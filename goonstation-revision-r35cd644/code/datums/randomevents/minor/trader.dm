/datum/random_event/minor/trader
	name = "Travelling Trader"
	centcom_headline = "Commerce and Customs Alert"
	centcom_message = "A merchant shuttle has docked with the station."
	var/active = 0

	event_effect()
		..()
		if(active == 1)
			return //This is to prevent admins from fucking up the shuttle arrival/departures by spamming this event.
		event = 1
		var/shuttle = pick("left","right");
		var/area/start_location = null
		var/area/end_location = null
		if(shuttle == "left")
			start_location = locate(/area/shuttle/merchant_shuttle/left_centcom)
			end_location = locate(/area/shuttle/merchant_shuttle/left_station)
		else
			start_location = locate(/area/shuttle/merchant_shuttle/right_centcom)
			end_location = locate(/area/shuttle/merchant_shuttle/right_station)

		var/list/dstturfs = list()
		var/throwy = world.maxy

		for(var/atom/A as obj|mob in end_location)
			spawn(0)
				A.ex_act(1)

		for(var/turf/T in end_location)
			dstturfs += T
			if(T.y < throwy)
				throwy = T.y

		// hey you, get out of the way!
		for(var/turf/T in dstturfs)
			// find the turf to move things to
			var/turf/D = locate(T.x, throwy - 1, 1)
			//var/turf/E = get_step(D, SOUTH)
			for(var/atom/movable/AM as mob|obj in T)
				if(istype(AM, /mob/dead))
					continue
				AM.Move(D)
			if(istype(T, /turf/simulated))
				qdel(T)

		start_location.move_contents_to(end_location)

		sleep(rand(3000,6000))

		command_alert("The merchant shuttle is preparing to undock, please stand clear.", "Merchant Departure Alert")

		sleep(300)

		// hey you, get out of my shuttle! I ain't taking you back to centcom!
		var/area/teleport_to_location = locate(/area/station/hallway/secondary/construction) //TODO: Make this go to the closest station area, so that this doesn't break on future maps.

		for(var/turf/T in dstturfs)
			for(var/mob/AM in T)
				if(istype(AM, /mob/dead))
					continue
				showswirl(AM)
				AM.set_loc(pick(get_area_turfs(teleport_to_location, 1)))
				showswirl(AM)
			for (var/obj/O in T)
				get_hiding_jerk(O)
				/*
				for (var/mob/AM in O.contents)
					boutput(AM, "<span style=\"color:red\"><b>Your body is destroyed as the merchant shuttle passes [pick("an eldritch decomposure field", "a life negation ward", "a telekinetic assimilation plant", "a swarm of matter devouring nanomachines", "an angry Greek god", "a burnt-out coder", "a death ray fired millenia ago from a galaxy far, far away")].</b></span>")
					AM.gib()
				*/

		end_location.move_contents_to(start_location)
		active = 0

/proc/get_hiding_jerk(var/atom/movable/container)
	for(var/atom/movable/AM in container)
		if(AM.contents.len) get_hiding_jerk(AM)
		if(ismob(AM))
			var/mob/M = AM
			boutput(AM, "<span style=\"color:red\"><b>Your body is destroyed as the merchant shuttle passes [pick("an eldritch decomposure field", "a life negation ward", "a telekinetic assimilation plant", "a swarm of matter devouring nanomachines", "an angry Greek god", "a burnt-out coder", "a death ray fired millenia ago from a galaxy far, far away")].</b></span>")
			M.gib()
