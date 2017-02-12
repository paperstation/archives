#define CRYOSLEEP_DELAY 9000 // 15 minutes
#define CRYOTRON_MESSAGE_DELAY 30 // 3 seconds

//Special destiny spawn point doodad
/obj/cryotron
	name = "industrial cryogenics unit"
	desc = "The terminus of a large underfloor cryogenic storage complex."
	anchored = 1
	density = 1
	icon = 'icons/obj/64x96.dmi'
	icon_state = "cryotron_down"
	bound_width = 96
	bound_height = 64

	var/list/folks_to_spawn = list()
	var/list/stored_mobs = list() // people who've bowed out of the round
	var/tmp/busy = 0

#ifdef MAP_OVERRIDE_DESTINY
	New()
		..()
		rp_latejoin += src
		processing_items += src

	disposing()
		var/turf/T = get_turf(src)
		for (var/mob/M in src)
			M.set_loc(T)
			if (isliving(M))
				var/mob/living/L = M
				L.hibernating = 0
				L.removeOverlayComposition(/datum/overlayComposition/blinded)
		for (var/obj/O in src)
			O.set_loc(T)
		..()
#endif
	ex_act()
		return

	proc/add_person_to_queue(var/mob/living/person)
		if (!istype(person))
			return 0

		person.set_loc(src)
		folks_to_spawn += person

		boutput(person, "<b>Cryo-recovery process initiated.  Please wait . . .</b>")
		person.removeOverlayComposition(/datum/overlayComposition/blinded)
		return 1

		//spawn(0)	//If you would prefer a game controller managing this, please address your concerns in the form of a brick through AIBM's window.
			//while (spawn_next_person())
				//sleep (20)

#ifdef MAP_OVERRIDE_DESTINY
	proc/process()
		spawn_next_person()
		ensure_storage()
#endif

	//Return 1 if there is another person to spawn afterward
	proc/spawn_next_person()
		if (!folks_to_spawn.len)
			var/mob/living/L = locate(/mob/living) in src
			if (L && !stored_mobs.Find(L))
				folks_to_spawn += L
			else
				return 0
		if (busy)
			return

		busy = 1
		var/mob/living/thePerson = folks_to_spawn[1]
		folks_to_spawn.Cut(1,2)
		if (!istype(thePerson))
			busy = 0
			return (folks_to_spawn.len != 0)

		src.icon_state = "cryotron_up"
		flick("cryotron_go_up", src)

		//sleep(19)
		spawn(19)
			if (!thePerson)
				busy = 0
				return (folks_to_spawn.len != 0)
			var/turf/firstLoc = locate(src.x + 1, src.y, src.z)
			thePerson.set_loc( firstLoc )
			playsound(src, "sound/vox/decompression.ogg",50)
			for (var/obj/O in src) // someone dropped something
				O.set_loc(firstLoc)

		//sleep(10)
			spawn(10)
				if (!thePerson)
					busy = 0
					return (folks_to_spawn.len != 0)
				if (thePerson.loc == firstLoc)
					step(thePerson, SOUTH)
				src.icon_state = "cryotron_down"
				flick("cryotron_go_down", src)

#ifdef MAP_OVERRIDE_DESTINY
				if (thePerson)
					thePerson.hibernating = 0
					if (thePerson.mind && thePerson.mind.assigned_role)
						for (var/obj/machinery/computer/announcement/A in machines)
							if (!A.stat && A.announces_arrivals)
								A.announce_arrival(thePerson.real_name, thePerson.mind.assigned_role)
#endif
		//sleep(9)
				spawn(9)
					busy = 0
					return (folks_to_spawn.len != 0)

		//return (folks_to_spawn.len != 0)

#ifdef MAP_OVERRIDE_DESTINY
	proc/add_person_to_storage(var/mob/living/L as mob)
		if (!istype(L))
			return 0
		if (stored_mobs.Find(L))
			if (L.loc == src)
				return 0
			else
				L.set_loc(src)
				L.hibernating = 1
				if (L.client)
					L.addOverlayComposition(/datum/overlayComposition/blinded)
					L.updateOverlaysClient(L.client)
				return 1

		stored_mobs += L
		stored_mobs[L] = world.timeofday
		L.set_loc(src)
		L.hibernating = 1
		if (L.client)
			L.addOverlayComposition(/datum/overlayComposition/blinded)
			L.updateOverlaysClient(L.client)
		return 1

	proc/enter_prompt(var/mob/living/user as mob)
		if (mob_can_enter_storage(user)) // check before the prompt for dead/incapped/restrained/etc users
			if (alert(user, "Would you like to enter cryogenic storage? You will be unable to leave it again until 15 minutes have passed.", "Confirmation", "Yes", "No") == "Yes")
				if (mob_can_enter_storage(user)) // check again in case they left the prompt up and moved away/died/whatever
					add_person_to_storage(user)
					return 1
		return 0

	proc/mob_can_enter_storage(var/mob/living/L as mob)
		if (!ticker)
			boutput(L, "<b>You can't enter cryogenic storage before the game's started!</b>")
			return 0
		if (!istype(L) || L.stat == 2)
			boutput(L, "<b>You have to be alive to enter cryogenic storage!</b>")
			return 0
		if (L.stat || L.restrained() || L.paralysis || L.sleeping)
			boutput(L, "<b>You can't enter cryogenic storage while incapacitated!</b>")
			return 0
		if (get_dist(src, L) > 1)
			boutput(L, "<b>You need to be closer to [src] to enter cryogenic storage!</b>")
			return 0
		return 1

	proc/exit_prompt(var/mob/living/user as mob)
		if (!user || !stored_mobs.Find(user))
			return 0
		var/entered = stored_mobs[user] // this will be the world.timeofday that the mob went into the cryotron
		if ((entered + CRYOSLEEP_DELAY) > world.timeofday) // is the time entered plus 15 minutes greater than the current time? the mob hasn't waited long enough
			var/time_left = round((entered + CRYOSLEEP_DELAY - world.timeofday)/600) // format this so it's nice and clear how many minutes are left to wait
			if (time_left > 15) // something went wrong! we probably hit the midnight rollover
				entered = 864000 - entered // adjust the time we went in, the highest number timeofday can return minus the time we went in
				stored_mobs[user] = entered // and save that

				time_left = round((entered + CRYOSLEEP_DELAY - world.timeofday)/600) // recalculate time_left so the if (time_left >= 0) can catch it if it's still above 0

			if (time_left >= 0)
				boutput(user, "<b>You must wait [time_left] minute[s_es(time_left)] before you can leave cryosleep.</b>")
				user.last_cryotron_message = ticker.round_elapsed_ticks
				return 0
		if (alert(user, "Would you like to leave cryogenic storage?", "Confirmation", "Yes", "No") == "No")
			return 0
		if (user.loc != src || !stored_mobs.Find(user))
			return 0
		if (add_person_to_queue(user))
			stored_mobs[user] = null
			stored_mobs -= user
			return 1
		return 0

	proc/ensure_storage()
		if (!stored_mobs.len)
			return
		for (var/mob/living/L in stored_mobs)
			if (L.loc != src)
				L.hibernating = 0
				L.removeOverlayComposition(/datum/overlayComposition/blinded)
				stored_mobs[L] = null
				stored_mobs -= L

	attack_hand(var/mob/user as mob)
		if (!enter_prompt(user))
			return ..()

	attackby(var/obj/item/W as obj, var/mob/user as mob)
		if (!enter_prompt(user))
			return ..()

	relaymove(var/mob/user as mob, dir)
		if ((user.last_cryotron_message + CRYOTRON_MESSAGE_DELAY) > ticker.round_elapsed_ticks)
			return ..()
		if (!exit_prompt(user))
			return ..()
#endif
