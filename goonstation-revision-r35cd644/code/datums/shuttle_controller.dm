// Controls the emergency shuttle
#define SHUTTLE_TRANSIT 1

// these define the time taken for the shuttle to get to SS13
// and the time before it leaves again
#define SHUTTLEARRIVETIME 600		// 10 minutes = 600 seconds
#define SHUTTLELEAVETIME 180		// 3 minutes = 180 seconds
#define SHUTTLETRANSITTIME 120		// 2 minutes = 120 seconds

// where you at, dawg, where you where you at
#define SHUTTLE_LOC_CENTCOM 0
#define SHUTTLE_LOC_STATION 1
#define SHUTTLE_LOC_TRANSIT 1.5
#define SHUTTLE_LOC_RETURNED 2

var/global/datum/shuttle_controller/emergency_shuttle/emergency_shuttle

datum/shuttle_controller
	var/location = 0 //0 = somewhere far away, 1 = at SS13, 2 = returned from SS13
	var/online = 0
	var/direction = 1 //-1 = going back to central command, 1 = going back to SS13
	var/disabled = 0 //Block shuttle calling if it's disabled.
	var/callcount = 0 //Number of shuttle calls required to break through interference (wizard mode)
	var/endtime			// round_elapsed_ticks		that shuttle arrives
	var/announcement_done = 0
	var/list/airbridges = list()
		//timeleft = 360 //600

	// call the shuttle
	// if not called before, set the endtime to T+600 seconds
	// otherwise if outgoing, switch to incoming
	proc/incall()
		if(online)
			if(direction == -1)
				setdirection(1)
		else
			settimeleft(SHUTTLEARRIVETIME)
			online = 1

		ircbot.event("shuttlecall", src.timeleft())

	proc/recall()
		if(online && direction == 1)
			setdirection(-1)
			ircbot.event("shuttlerecall", src.timeleft())


	// returns the time (in seconds) before shuttle arrival
	// note if direction = -1, gives a count-up to SHUTTLEARRIVETIME
	proc/timeleft()
		if(online)
			var/timeleft = round((endtime - ticker.round_elapsed_ticks)/10 ,1)
			if(direction == 1)
				return timeleft
			else
				return SHUTTLEARRIVETIME-timeleft
		else
			return SHUTTLEARRIVETIME

	// sets the time left to a given delay (in seconds)
	proc/settimeleft(var/delay)
		endtime = ticker.round_elapsed_ticks + delay * 10

	// sets the shuttle direction
	// 1 = towards SS13, -1 = back to centcom
	proc/setdirection(var/dirn)
		if(direction == dirn)
			return
		direction = dirn
		// if changing direction, flip the timeleft by SHUTTLEARRIVETIME
		var/ticksleft = endtime - ticker.round_elapsed_ticks
		endtime = ticker.round_elapsed_ticks + (SHUTTLEARRIVETIME*10 - ticksleft)
		return

	proc/process()

	emergency_shuttle

		New()
			..()
			for (var/obj/machinery/computer/airbr/S in machines)
				if (S.emergency && !(S in src.airbridges))
					src.airbridges += S

		process()
			if (!online)
				return
			var/timeleft = timeleft()
			if (timeleft > 1e5 || timeleft <= 0)		// midnight rollover protection
				timeleft = 0
			switch (location)
				if (SHUTTLE_LOC_CENTCOM)
					if (timeleft>SHUTTLEARRIVETIME)
						online = 0
						direction = 1
						endtime = null
						return 0

					else if (timeleft <= 0)
						location = SHUTTLE_LOC_STATION
						if (ticker && ticker.mode)
							if (ticker.mode.shuttle_available == 0)
								command_alert("CentCom has received reports of unusual activity on the station. The shuttle has been returned to base as a precaution, and will not be usable.");
								online = 0
								direction = 1
								endtime = null
								return 0
							if (ticker.mode.shuttle_available == 2 && (ticker.round_elapsed_ticks < max(0, ticker.mode.shuttle_available_threshold)) && callcount < 1)
								callcount++
								command_alert("CentCom reports that the emergency shuttle has veered off course due to unknown interference. The next shuttle will be equipped with electronic countermeasures to break through.");
								online = 0
								direction = 1
								location = SHUTTLE_LOC_CENTCOM
								endtime = null
								return 0
						var/area/start_location = locate(/area/shuttle/escape/centcom)
						var/area/end_location = locate(/area/shuttle/escape/station)

						var/list/dstturfs = list()
						var/throwy = world.maxy

						for (var/atom/A as obj|mob in end_location)
							spawn(0)
								A.ex_act(1)

						for (var/turf/T in end_location)
							dstturfs += T
							if(T.y < throwy)
								throwy = T.y

						// hey you, get out of the way!
						for (var/turf/T in dstturfs)
							// find the turf to move things to
							var/turf/D = locate(T.x, throwy - 1, 1)
							//var/turf/E = get_step(D, SOUTH)
							for (var/atom/movable/AM as mob|obj in T)
								if (istype(AM, /mob/dead))
									continue
								AM.Move(D)
								// NOTE: Commenting this out to avoid recreating mass driver glitch
								/*
								spawn(0)
									AM.throw_at(E, 1, 1)
									return
								*/

							if (istype(T, /turf/simulated))
								T.ReplaceWithSpace()

						start_location.move_contents_to(end_location)
						settimeleft(SHUTTLELEAVETIME)

						if (src.airbridges.len)
							for (var/obj/machinery/computer/airbr/S in src.airbridges)
								S.establish_bridge()

						boutput(world, "<B>The Emergency Shuttle has docked with the station! You have [timeleft()/60] minutes to board the Emergency Shuttle.</B>")
						ircbot.event("shuttledock")

						return 1

#ifdef SHUTTLE_TRANSIT // shuttle spends some time in transit to centcom before arriving
				if (SHUTTLE_LOC_STATION)
					if (!announcement_done && timeleft < 60)
						boutput(world, "<B>The Emergency Shuttle will be entering the wormhole to CentCom in 1 minute! Please prepare for wormhole traversal.</B>")
						announcement_done = 1

					else if (announcement_done < 2 && timeleft < 30)
						var/area/sound_location = locate(/area/shuttle_sound_spawn)
						playsound(sound_location, 'sound/effects/ship_charge.ogg', 100)
						announcement_done = 2

					else if (announcement_done < 3 && timeleft < 4)
						var/area/sound_location = locate(/area/shuttle_sound_spawn)
						playsound(sound_location, 'sound/effects/ship_engage.ogg', 100)
						announcement_done = 3

					else if (announcement_done < 4 && timeleft < 1)
						var/area/sound_location = locate(/area/shuttle_sound_spawn)
						playsound(sound_location, 'sound/effects/explosion_new4.ogg', 75)
						playsound(sound_location, 'sound/effects/flameswoosh.ogg', 75)
						announcement_done = 4
						if (src.airbridges.len)
							for (var/obj/machinery/computer/airbr/S in src.airbridges)
								S.remove_bridge()

					else if (timeleft > 0)
						return 0

					else
						location = SHUTTLE_LOC_TRANSIT
						var/area/start_location = locate(/area/shuttle/escape/station)
						var/area/end_location = locate(/area/shuttle/escape/transit)

						for (var/obj/machinery/door/D in start_location)
							D.close()
							if (istype(D, /obj/machinery/door/airlock/external))
								D.locked = 1
								D.update_icon()

						for (var/mob/M in start_location)
							shake_camera(M, 32, 4)
							M.addOverlayComposition(/datum/overlayComposition/shuttle_warp)
							if (!isturf(M.loc) || !isliving(M) || isintangible(M))
								continue
							spawn(1)
								var/bonus_stun = 0
								if (ishuman(M))
									var/mob/living/carbon/human/H = M
									bonus_stun = (H && H.buckled && H.on_chair)
									DEBUG("[M] is human and bonus_stun is [bonus_stun]")
								if (!M.buckled || bonus_stun)
									M.stunned += 2
									M.weakened += 4

									if (prob(50) || bonus_stun)
										var/atom/target = get_edge_target_turf(M, pick(alldirs))
										spawn(0)
											if (target)
												if (M.buckled) M.buckled.unbuckle()
												M.throw_at(target, 25, 1)
												if (bonus_stun)
													M.paralysis += 4
													M.playsound_local(target, 'sound/effects/fleshbr1.ogg', 50, 1)
													M.show_text("You are thrown off the chair! [prob(50) ? "Standing on that during takeoff was a terrible idea!" : null]", "red")

									if (!bonus_stun)
										M.show_text("You are thrown about as the shuttle launches due to not being securely buckled in!", "red")

						for (var/turf/space/S in start_location)
							S.icon_state = "blank"

						for (var/turf/simulated/shuttle/wall/corner/C in start_location)
							if (C.icon_style && C.icon_state == "[C.icon_style]_space")
								C.icon_state = "[C.icon_style]_trans"

						var/area/shuttle_particle_spawn/particle_location = locate(/area/shuttle_particle_spawn)
						if (particle_location)
							var/turf/space/shuttle_transit/S = locate(/turf/space/shuttle_transit) in particle_location
							if (S && !particleMaster.CheckSystemExists(/datum/particleSystem/warp_star, S))
								particleMaster.SpawnSystem(new /datum/particleSystem/warp_star(S, particle_location.star_dir))

						spawn(0)
							DEBUG("Now moving shuttle!")
							start_location.move_contents_to(end_location)
							DEBUG("Done moving shuttle!")
							settimeleft(SHUTTLETRANSITTIME)
							boutput(world, "<B>The Emergency Shuttle has left for CentCom! It will arrive in [timeleft()/60] minute[s_es(timeleft()/60)]!</B>")
							//online = 0

						return 1

				if (SHUTTLE_LOC_TRANSIT)
					if (timeleft>0)
						return 0
					else
						location = SHUTTLE_LOC_RETURNED
						var/area/start_location = locate(/area/shuttle/escape/transit)
						var/area/end_location = locate(/area/shuttle/escape/centcom)

						for (var/mob/M in start_location)
							M.removeOverlayComposition(/datum/overlayComposition/shuttle_warp)

						for (var/obj/machinery/door/airlock/external/D in start_location)
							D.locked = 0
							D.update_icon()

						for (var/turf/space/S in start_location)
							S.icon_state = "[rand(1,25)]"

						for (var/turf/simulated/shuttle/wall/corner/C in start_location)
							if (C.icon_style && C.icon_state == "[C.icon_style]_trans")
								C.icon_state = "[C.icon_style]_space"

						start_location.move_contents_to(end_location)
						boutput(world, "<B>The Emergency Shuttle has arrived at CentCom!")
						online = 0

						return 1

				else
					return 1

#else // standard shuttle departure - immediately arrives at centcom
				if (SHUTTLE_LOC_STATION)
					if (timeleft>0)
						return 0
					else
						location = SHUTTLE_LOC_RETURNED
						var/area/start_location = locate(/area/shuttle/escape/station)
						var/area/end_location = locate(/area/shuttle/escape/centcom)

						start_location.move_contents_to(end_location)
						boutput(world, "<B>The Emergency Shuttle has arrived at CentCom!")
						online = 0

						return 1

				else
					return 1
#endif
