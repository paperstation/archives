/obj/machinery/bot/pullbot
	name = "Knat"
	desc = "A little Medical robot; drags corpses and critically ill people to medbay."
	icon = 'aibots2.dmi'
	icon_state = "medbot0"
	layer = 5.0
	density = 1
	anchored = 0
	health = 25
	maxhealth = 25
	var/inject
	var/mode
	var/patrol
	var/auto_patrol
	var/scan
	var/speak
	var/beacon_freq = 1445		// navigation beacon frequency
	var/control_freq = 1447		// bot control frequency
	var/locked
	var/medbay = null // medbay location
	var/turf/patrol_target	// this is turf to navigate to (location of beacon)
	var/new_destination		// pending new destination (waiting for beacon response)
	var/destination			// destination description tag
	var/next_destination	// the next destination in the patrol route
	var/list/path = new				// list of path turfs
	var/patient_lastloc
	var/blockcount = 0		//number of times retried a blocked path
	var/awaiting_beacon	= 0	// count of pticks awaiting a beacon response
	var/mob/living/carbon/human/patient
	var/nearest_beacon			// the nearest beacon's tag
	var/turf/nearest_beacon_loc	// the nearest beacon's location
	var/currently_healing = 0
	var/frustration
	var/last_found
	var/obj/machinery/camera/cam
	var/list/pathpatrol = new
	var/reagent_id = "inaprovaline"
	var/injection_amount = 30
	var/atom/movable/pulling = null
	var/liveone = 0
	var/obj/machinery/navbeacon/E
	var/home_destination = "HOME"
	var/donedest = 0
	var/pull = 0
	var/oldpatient = null

#define PULLBOT_IDLE 		0		// idle
#define PULLBOT_ASSIST 		1		// found patient, hunting
#define PULLBOT_TREATMENT 	2		// at patient, preparing to arrest
#define PULLBOT_DRAGGING	3		// arresting patient
#define PULLBOT_START_PATROL	4		// start patrol
#define PULLBOT_PATROL		5		// patrolling
#define PULLBOT_SUMMON		6		// summoned by PDA
#define MOVING_TO_CORPSE	7 //had to make a pathfinding and moving mode for long distances.
#define MOVING_TO_HOME		8


/obj/machinery/bot/pullbot
	New()
		..()
		src.icon_state = "medbot[src.on]"
		spawn(3)
			src.botcard = new /obj/item/weapon/card/id(src)
			src.botcard.access = get_access("Head of Personnel")
			src.cam = new /obj/machinery/camera(src)
			src.cam.c_tag = src.name
			src.cam.network = "SS13"
			if(radio_controller)
				radio_controller.add_object(src, control_freq, filter = RADIO_SECBOT)
				radio_controller.add_object(src, beacon_freq, filter = RADIO_NAVBEACONS)

//turning the bot on
/obj/machinery/bot/pullbot/turn_on()
	..()
	src.icon_state = "medbot[src.on]"
	src.updateUsrDialog()

//turning the bot off
/obj/machinery/bot/pullbot/turn_off()
	..()
	src.patient = null
	src.path = new()
	src.currently_healing = 0
	src.last_found = world.time
	src.icon_state = "medbot[src.on]"
	src.updateUsrDialog()

/obj/machinery/bot/pullbot/attack_hand(mob/user as mob)
	. = ..()
	if (.)
		return
	usr.machine = src
	interact(user)

/obj/machinery/bot/pullbot/proc/interact(mob/user as mob)
	var/dat
	dat += text({"
<TT><B>Medical Exploration Drone v1.3 Beta</B></TT><BR><BR>
Status: []<BR>
Behaviour controls are [src.locked ? "locked" : "unlocked"]"},

"<A href='?src=\ref[src];power=1'>[src.on ? "On" : "Off"]</A>" )

	if(!src.locked)
		dat += text({"<BR>
Stablize Patients: []<BR>
Auto Patrol: []"},

"<A href='?src=\ref[src];operation=inject'>[src.inject ? "Yes" : "No"]</A>",
"<A href='?src=\ref[src];operation=patrol'>[auto_patrol ? "On" : "Off"]</A>" )


	user << browse("<HEAD><TITLE>Securitron v1.3 controls</TITLE></HEAD>[dat]", "window=autosec")
	onclose(user, "autosec")
	return

/obj/machinery/bot/pullbot/Topic(href, href_list)
	usr.machine = src
	src.add_fingerprint(usr)
	if ((href_list["power"]) && (src.allowed(usr)))
		if (src.on)
			turn_off()
		else
			turn_on()
		return

	switch(href_list["operation"])
		if ("inject")
			src.inject = !src.inject
			src.updateUsrDialog()
		if("patrol")
			auto_patrol = !auto_patrol
			mode = PULLBOT_IDLE
			updateUsrDialog()


/obj/machinery/bot/pullbot/process()
	for(var/obj/machinery/navbeacon/I in machines)
		if ((I.name == "home") && (I.loc == medbay))
			E = I
	if (!src.on)
		return

	switch(mode)
		if(PULLBOT_IDLE)		// idle
			walk_to(src,0)
			pull = null
			src.pulling = null
			look_for_corpse()
			if(!mode && auto_patrol)	// still idle, and set to patrol
				mode = PULLBOT_START_PATROL	// switch to patrol mode
			else
				sleep(-1)
				look_for_corpse()
				mode = PULLBOT_IDLE

		if(PULLBOT_ASSIST)		// hunting for perp

			// if can't reach perp for long enough, go idle
			if (src.frustration >= 8)
				//		for(var/mob/O in hearers(src, null))
		//			O << "<span class='game say'><span class='name'>[src]</span> beeps, \"Backup requested! Suspect has evaded arrest.\""
				src.patient = null
				src.last_found = world.time
				src.frustration = 0
				src.mode = 0
				walk_to(src,0)
			if(src.patient)		// make sure patient exists
				if (get_dist(src, src.patient) <= 1)		// if right next to perp
					mode = PULLBOT_TREATMENT
					src.anchored = 1
					var/mob/living/carbon/M = src.patient
					src.patient_lastloc = M.loc
					return

				else								// not next to perp
					var/turf/olddist = get_dist(src, src.patient)
					walk_to(src, src.patient,1,4)
					if ((get_dist(src, src.patient)) >= (olddist))
						src.frustration++
					else
						src.frustration = 0

		if(PULLBOT_START_PATROL)	// start a patrol

			if(path.len > 0 && patrol_target)	// have a valid path, so just resume
				mode = PULLBOT_PATROL
				return

			else if(patrol_target)		// has patrol target already
				spawn(0)
					calc_path()		// so just find a route to it
					if(path.len == 0)
						patrol_target = 0
						return
					look_for_corpse()
					mode = PULLBOT_PATROL


			else					// no patrol target, so need a new one
				look_for_corpse()
				find_patrol_target()
				speak("Engaging patrol mode.")



		if(PULLBOT_PATROL)		// patrol mode
			patrol_step()
			spawn(5)
				if(mode == PULLBOT_PATROL)
					patrol_step()


		if(PULLBOT_SUMMON)		// summoned to PDA
			patrol_step()
			spawn(4)
				if(mode == PULLBOT_SUMMON)
					patrol_step()
					sleep(-1)
					patrol_step()

		if(PULLBOT_TREATMENT)
			if (patient.stat != 2)
				if(!(liveone >= 2))
					liveone()
					liveone++
				src.pulling = patient
				pull = 1
				pulled()
				sleep(40)
				spawn(5)
				mode = MOVING_TO_HOME
				return(process())

			else if (patient.stat == 2)
				src.pulling = patient
				pulled()
				sleep(40)
				spawn(5)
				mode = MOVING_TO_HOME
				return(process())
			else if (patient.loc == medbay)
				mode = PULLBOT_IDLE
				return(process())

		if(MOVING_TO_CORPSE)
			patrol_step2()
			spawn(4)
				if(mode == MOVING_TO_CORPSE)
					patrol_step2()
					sleep(4)
					patrol_step2()

		if(MOVING_TO_HOME)
			if(src.loc == medbay)
				mode = PULLBOT_IDLE
				return(process())
			world << "moving to home"
			look_for_home()
			spawn(4)
			calc_path()
			mode = PULLBOT_PATROL

/obj/machinery/bot/pullbot/proc/Scan_wait()
	scan = 1
	sleep(-1)
	scan = 0

///Bot Speaking//

/obj/machinery/bot/pullbot/proc/speak(var/message)
	for(var/mob/O in hearers(src, null))
		O << "<span class='game say'><span class='name'>[src]</span> beeps, \"[message]\""
	return


////// HELPING PEOPLE, LETS FIND THEM....

/obj/machinery/bot/pullbot/proc/look_for_corpse()    //Look for somebody to help.

	medbay = locate(/area/medical/medbay)
	sleep(-1)
	src.anchored = 0
	sleep(50)
	for (var/mob/living/carbon/human/C in world)
		if(!(oldpatient == C))
			if (C.loc == medbay)
				return(process())
			if	(C.stat == 2)
				if (get_dist(src, C) >= 30)
					return
				src.patient = C
				mode = MOVING_TO_CORPSE
				world << "Oh noes a corpse"
				calc_pathpatient()
				src.pull = 1
				spawn(0)
					process()
				break
			if((C.stat != 2) && (C.health <= 1))
				if (get_dist(src, C) >= 30)
					return
				src.patient = C
				mode = MOVING_TO_CORPSE
				world << "Oh noes a critical"
				calc_pathpatient()
				src.pull = 1
				spawn(0)
					process()
				break
		else
			return(process())

//// LETS FIND THE HOME BECON

/obj/machinery/bot/pullbot/proc/look_for_home()
	spawn(0)
		if(donedest != 1)
			set_destination("HOME")
			spawn(5)
			calc_path()
			donedest = 1
		else
			return(process())

/obj/machinery/bot/pullbot/proc/pulled()
	if(src.pull >= 1)
		if(src.pulling == patient)
			walk_to(src.pulling, src,1,4)
	else

		return



//each step on the patrol
/obj/machinery/bot/pullbot/proc/patrol_step() // each step the bot takes

	if(loc == patrol_target)		// reached target
		donedest = 0
		at_patrol_target()
		return

	else if(path.len > 0 && patrol_target)		// valid path

		var/turf/next = path[1]
		if(next == loc)
			path -= next
			return


		if(istype( next, /turf/simulated))

			var/moved = step_towards(src, next)	// attempt to move
			if(moved)	// successful move
				blockcount = 0
				path -= loc
			else		// failed to move

				blockcount++

				if(blockcount > 5)	// attempt 5 times before recomputing
					// find new path excluding blocked turf

					spawn(2)
						calc_path(next)
						if(path.len == 0)
							find_patrol_target()
						else
							blockcount = 0

					return

				return

		else	// not a valid turf
			mode = PULLBOT_IDLE
			return

	else	// no path, so calculate new one
		mode = PULLBOT_START_PATROL





// finds a new patrol target
/obj/machinery/bot/pullbot/proc/find_patrol_target()
	send_status()
	if(awaiting_beacon)			// awaiting beacon response
		awaiting_beacon++
		if(awaiting_beacon > 5)	// wait 5 secs for beacon response
			find_nearest_beacon()	// then go to nearest instead
		return

	if(next_destination)
		set_destination(next_destination)
	else
		find_nearest_beacon()
	return


// finds the nearest beacon to self
// signals all beacons matching the patrol code
/obj/machinery/bot/pullbot/proc/find_nearest_beacon()
	nearest_beacon = null
	new_destination = "__nearest__"
	post_signal(beacon_freq, "findbeacon", "patrol")
	awaiting_beacon = 1
	spawn(10)
		awaiting_beacon = 0
		if(nearest_beacon)
			set_destination(nearest_beacon)
		else
			auto_patrol = 0
			mode = PULLBOT_IDLE
			send_status()


/obj/machinery/bot/pullbot/proc/at_patrol_target()
	find_patrol_target()
	return

	// sets the current destination
// signals all beacons matching the patrol code
// beacons will return a signal giving their locations
/obj/machinery/bot/pullbot/proc/set_destination(var/new_dest)
	new_destination = new_dest
	post_signal(beacon_freq, "findbeacon", "patrol")
	awaiting_beacon = 1


// receive a radio signal
// used for beacon reception

/obj/machinery/bot/pullbot/receive_signal(datum/signal/signal)
	//log_admin("DEBUG \[[world.timeofday]\]: /obj/machinery/bot/secbot/receive_signal([signal.debug_print()])")
	if(!on)
		return

	/*
	world << "rec signal: [signal.source]"
	for(var/x in signal.data)
		world << "* [x] = [signal.data[x]]"
	*/

	var/recv = signal.data["command"]
	// process all-bot input
	if(recv=="bot_status")
		send_status()

	// check to see if we are the commanded bot
	if(signal.data["active"] == src)
	// process control input
		switch(recv)
			if("stop")
				mode = PULLBOT_IDLE
				auto_patrol = 0
				return

			if("go")
				mode = PULLBOT_IDLE
				auto_patrol = 1
				return

			if("summon")
				patrol_target = signal.data["target"]
				next_destination = destination
				destination = null
				awaiting_beacon = 0
				mode = PULLBOT_SUMMON
				calc_path()
				return



	// receive response from beacon
	recv = signal.data["beacon"]
	var/valid = signal.data["patrol"]
	if(!recv || !valid)
		return

	if(recv == new_destination)	// if the recvd beacon location matches the set destination
								// the we will navigate there
		destination = new_destination
		patrol_target = signal.source.loc
		next_destination = signal.data["next_patrol"]
		awaiting_beacon = 0

	// if looking for nearest beacon
	else if(new_destination == "__nearest__")
		var/dist = get_dist(src,signal.source.loc)
		if(nearest_beacon)

			// note we ignore the beacon we are located at
			if(dist>1 && dist<get_dist(src,nearest_beacon_loc))
				nearest_beacon = recv
				nearest_beacon_loc = signal.source.loc
				return
			else
				return
		else if(dist > 1)
			nearest_beacon = recv
			nearest_beacon_loc = signal.source.loc
	return


// send a radio signal with a single data key/value pair
/obj/machinery/bot/pullbot/proc/post_signal(var/freq, var/key, var/value)
	post_signal_multiple(freq, list("[key]" = value) )

// send a radio signal with multiple data key/values
/obj/machinery/bot/pullbot/proc/post_signal_multiple(var/freq, var/list/keyval)

	var/datum/radio_frequency/frequency = radio_controller.return_frequency(freq)

	if(!frequency) return

	var/datum/signal/signal = new()
	signal.source = src
	signal.transmission_method = 1
//	for(var/key in keyval)
//		signal.data[key] = keyval[key]
	signal.data = keyval
//		world << "sent [key],[keyval[key]] on [freq]"
	if (signal.data["findbeacon"])
		frequency.post_signal(src, signal, filter = RADIO_NAVBEACONS)
	else if (signal.data["type"] == "secbot")
		frequency.post_signal(src, signal, filter = RADIO_SECBOT)
	else
		frequency.post_signal(src, signal)

// signals bot status etc. to controller
/obj/machinery/bot/pullbot/proc/send_status()
	var/list/kv = list(
	"type" = "secbot",
	"name" = name,
	"loca" = loc.loc,	// area
	"mode" = mode
	)
	post_signal_multiple(control_freq, kv)



// calculates a path to the current destination
// given an optional turf to avoid
/obj/machinery/bot/pullbot/proc/calc_path(var/turf/avoid = null)
	src.path = AStar(src.loc, patrol_target, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 120, id=botcard, exclude=avoid)
	src.path = reverselist(src.path)







/////////////////////////////
/////////////////////////////
/////////////////////////////PATROL STUFF END
/////////////////////////////
/////////////////////////////
/////////////////////////////








/////////////////////////////
/////////////////////////////
/////////////////////////////Patient / Home primary code.
/////////////////////////////
/////////////////////////////
/////////////////////////////

///so it can move to corpse/bodies rather than a becon.
/obj/machinery/bot/pullbot/proc/calc_pathpatient(var/turf/avoid = null)
	src.path = AStar(src.loc, src.patient.loc, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 120, id=botcard, exclude=avoid)
	src.path = reverselist(src.path)

///so it can move to corpse/bodies rather than a becon.
/obj/machinery/bot/pullbot/proc/patrol_step2() // step towards patient

	if(src.loc == src.patient.loc)		// reached target
		mode = PULLBOT_ASSIST
		return(process())

	else if(path.len > 0 && src.patient)		// valid path

		var/turf/next = path[1]
		if(next == loc)
			path -= next
			return


		if(istype( next, /turf/simulated))

			var/moved = step_towards(src, next)	// attempt to move
			if(moved)	// successful move
				blockcount = 0
				path -= loc
			else		// failed to move

				blockcount++

				if(blockcount > 5)	// attempt 5 times before recomputing
					// find new path excluding blocked turf

					spawn(2)
						calc_pathpatient(next)
						if(path.len == 0)
							mode = PULLBOT_ASSIST
						else
							blockcount = 0

					return

				return

		else	// not a valid turf
			mode = PULLBOT_IDLE
			return

	else	// no path, so calculate new one
		mode = PULLBOT_ASSIST

/////////////////////////////////////////////////////TREATMENT///////////////////////////////////////////////////////////////////

/obj/machinery/bot/pullbot/proc/injectacheck()
	sleep(-1)
	if(patient.losebreath >= 20)
		return(liveone())
	else
		return(PULLBOT_TREATMENT)

/obj/machinery/bot/pullbot/proc/liveone()
	for(var/mob/O in viewers(src, null))
		sleep(30)
		O.show_message("\red <B>[src] is trying to inject [src.patient]!</B>", 1)
	spawn(30)
	if ((get_dist(src, src.patient) <= 1) && (src.on))
		src.patient.reagents.add_reagent(reagent_id,src.injection_amount)
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>[src] injects [src.patient] with the syringe!</B>", 1)
		return(PULLBOT_TREATMENT)