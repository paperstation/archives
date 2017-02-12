//Config stuff
#define PRISONSHUTTLE_MOVETIME 630										//Time to station is milliseconds.
#define PRISONSHUTTLE_STATION_AREATYPE "/area/shuttle/prison/station" 	//Type of the shuttle area for station
#define PRISONSHUTTLE_TRANSIT_AREATYPE "/area/shuttle/prison/transit"	//Type of the area the shuttle moves to while queued to arrive at destination
#define PRISONSHUTTLE_DOCK_AREATYPE "/area/shuttle/prison/prison"		//Type of the shuttle area for dock
#define DERELICTSHUTTLE_MOVETIME 630
#define DERELICTSHUTTLE_STATION_AREATYPE "/area/shuttle/derelict/station"
#define DERELICTSHUTTLE_TRANSIT_AREATYPE "/area/shuttle/derelict/transit"
#define DERELICTSHUTTLE_DOCK_AREATYPE "/area/shuttle/derelict/derelict"
#define MININGSHUTTLE_MOVETIME 1488
#define MININGSHUTTLE_STATION_AREATYPE "/area/shuttle/mining/station"
#define MININGSHUTTLE_TRANSIT_AREATYPE "/area/shuttle/mining/transit"
#define MININGSHUTTLE_DOCK_AREATYPE "/area/shuttle/mining/asteroid"

var/mining_shuttle_moving_to_station = 0
var/mining_shuttle_moving_to_asteroid = 0
var/mining_shuttle_intransit = 0
var/mining_shuttle_at_station = 0
var/mining_shuttle_can_send = 1
var/mining_shuttle_time = 0
var/mining_shuttle_timeleft = 0
var/derelict_shuttle_moving_to_station = 0
var/derelict_shuttle_moving_to_derelict = 0
var/derelict_shuttle_intransit = 0
var/derelict_shuttle_at_station = 1
var/derelict_shuttle_can_send = 1
var/derelict_shuttle_time = 0
var/derelict_shuttle_timeleft = 0
var/prison_shuttle_moving_to_station = 0
var/prison_shuttle_moving_to_prison = 0
var/prison_shuttle_intransit = 0
var/prison_shuttle_at_station = 0
var/prison_shuttle_can_send = 1
var/prison_shuttle_time = 0
var/prison_shuttle_timeleft = 0

/obj/machinery/computer/transitshuttle
	var/temp = null
	var/hacked = 0
	var/allowedtocall = 0
	var/prison_break = 0

/obj/machinery/computer/transitshuttle/mining
	name = "Shuttle Terminal"
	icon_state = "mineshuttle"

/obj/machinery/computer/transitshuttle/newstationprison
	name = "Shuttle Terminal"
	icon_state = "prisshuttle"

/obj/machinery/computer/transitshuttle/derelict
	name = "Shuttle Terminal"
	icon_state = "dereshuttle"

/*
/obj/machinery/computer/transitshuttle/mining/proc/mining_process()
	while(mining_shuttle_time - world.timeofday > 0)
		var/ticksleft = mining_shuttle_time - world.timeofday

		if(ticksleft > 1e5)
			mining_shuttle_time = world.timeofday + 10	// midnight rollover


		mining_shuttle_timeleft = (ticksleft / 10)
		sleep(5)
	mining_shuttle_moving_to_station = 0
	mining_shuttle_intransit = 0
	mining_shuttle_moving_to_asteroid = 0

	switch(mining_shuttle_at_station)

		if(0)
			mining_shuttle_at_station = 1
			if (mining_shuttle_intransit) return

			if (!mining_can_move())
				usr << "\red The mining shuttle is unable to leave."
				return

			mining_shuttle_intransit = 1
			for (var/mob/C in viewers(src))
				C.show_message("\blue <B>Shuttle desination set to [station_name]. Shuttle autopilot initialized.</B>", 3)
				C.show_message("\blue Undocking sequence initialized.", 3)
			for(var/obj/machinery/door/poddoor/L in machines)
				if (L.id == "mining")
					spawn( 0 )
					L.close()
			sleep(10)
			for(var/area/FTLship/E in world)
				E.requires_power = 0
				E.luminosity = 0
				E.ul_Lighting = 0
			var/area/start_location = locate(/area/FTLship/start)
			var/area/end_location = locate(/area/FTLship/hyperspace)

			for (var/mob/C in viewers(src))
				C.show_message("\blue Thrusters engaged.", 3)
			for(var/turf/Q in end_location)
				for(var/atom/movable/AM as mob|obj in Q)
					del(AM)
					del(Q)
			sleep(10)
			start_location.move_contents_to(end_location)
			for(var/area/FTLship/F in world)
				F.requires_power = 1
				F.ul_Lighting = 1
			for(var/turf/Q in end_location)
				for(var/atom/movable/AM as mob|obj in Q)
					del(AM)
					del(Q)

			for (var/mob/C in viewers(src))
				C.show_message("\blue Shuttle en route.", 3)
			sleep(600)
			for(var/area/FTLship/G in world)
				G.requires_power = 0
				G.luminosity = 0
				G.ul_Lighting = 0
			var/area/start_location2 = locate(/area/FTLship/hyperspace)
			var/area/end_location2 = locate(/area/FTLship/start)

			for (var/mob/C in viewers(src))
				C.show_message("\blue Shuttle approaching destination.", 3)
			sleep(30)
			for (var/mob/C in viewers(src))
				C.show_message("\blue Docking sequence initiated.", 3)
			sleep(10)

			var/list/mshutturfs = list()
			var/throwy = world.maxy

			for(var/turf/T in end_location2)
				mshutturfs += T
				if(T.y < throwy)
					throwy = T.y

						// hey you, get out of the way!
			for(var/turf/T in mshutturfs)
							// find the turf to move things to
				var/turf/D = locate(T.x, throwy - 1, 1)
							//var/turf/E = get_step(D, SOUTH)
				for(var/atom/movable/AM as mob|obj in T)
					AM.Move(D)
				if(istype(T, /turf/simulated))
					del(T)

			start_location2.move_contents_to(end_location2)
			sleep(2)
			for(var/area/FTLship/H in world)
				H.requires_power = 1
				H.ul_Lighting = 1

			for (var/mob/C in viewers(src))
				C.show_message("\blue <B>Shuttle has arrived at destination: [station_name].</B>", 3)
			mining_shuttle_intransit = 0
			for(var/obj/machinery/door/poddoor/L in machines)
				if (L.id == "ss13m")
					spawn( 0 )
					L.open()
			for(var/obj/machinery/door/poddoor/L in machines)
				if (L.id == "mining")
					spawn( 0 )
					L.open()


		if(1)
			mining_shuttle_at_station = 0
			if (mining_shuttle_intransit) return

			if (!mining_can_move())
				usr << "\red The mining shuttle is unable to leave."
				return

			mining_shuttle_intransit = 1
			for(var/obj/machinery/door/poddoor/L in machines)
				if (L.id == "ss13m")
					spawn( 0 )
					L.close()
			for (var/mob/C in viewers(src))
				C.show_message("\blue <B>Shuttle desination set to Mining Asteroid. Shuttle autopilot initialized.</B>", 3)
				C.show_message("\blue Undocking sequence initialized.", 3)
			for(var/obj/machinery/door/poddoor/L in machines)
				if (L.id == "mining")
					spawn( 0 )
					L.close()
			sleep(10)
			var/area/start_location = locate(/area/shuttle/mining/station)
			var/area/end_location = locate(/area/shuttle/mining/transit)

			for (var/mob/C in viewers(src))
				C.show_message("\blue Thrusters engaged.", 3)
			sleep(10)
			start_location.move_contents_to(end_location)
			for (var/mob/C in viewers(src))
				C.show_message("\blue Shuttle en route.", 3)
			sleep(600)

			var/area/start_location2 = locate(/area/shuttle/mining/transit)
			var/area/end_location2 = locate(/area/shuttle/mining/asteroid)

			for (var/mob/C in viewers(src))
				C.show_message("\blue Shuttle approaching destination.", 3)
			sleep(30)
			for (var/mob/C in viewers(src))
				C.show_message("\blue Docking sequence initiated.", 3)
			sleep(10)

			var/list/mshutturfs = list()
			var/throwy = world.maxy

			for(var/turf/T in end_location2)
				mshutturfs += T
				if(T.y < throwy)
					throwy = T.y

						// hey you, get out of the way!
			for(var/turf/T in mshutturfs)
							// find the turf to move things to
				var/turf/D = locate(T.x, throwy - 1, 1)
							//var/turf/E = get_step(D, SOUTH)
				for(var/atom/movable/AM as mob|obj in T)
					AM.Move(D)
				if(istype(T, /turf/simulated))
					del(T)

			start_location2.move_contents_to(end_location2)
			sleep(2)
			for (var/mob/C in viewers(src))
				C.show_message("\blue <B>Shuttle has arrived at destination: Mining Asteroid.</B>", 3)
			mining_shuttle_intransit = 0
			for(var/obj/machinery/door/poddoor/L in machines)
				if (L.id == "mining")
					spawn( 0 )
					L.open()
*/
/obj/machinery/computer/transitshuttle/mining/proc/mining_can_move()
	if(mining_shuttle_intransit) return 0

	else return 1

/obj/machinery/computer/transitshuttle/mining/attackby(I as obj, user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/transitshuttle/mining/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/transitshuttle/mining/attack_paw(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/transitshuttle/mining/attackby(I as obj, user as mob)
	if(istype(I,/obj/item/weapon/card/emag))
		user << "\blue The screen's picture slightly deforms around the sequencer."
	else
		return src.attack_hand(user)

/obj/machinery/computer/transitshuttle/newstationprison/proc/prison_process()
	while(prison_shuttle_time - world.timeofday > 0)
		var/ticksleft = prison_shuttle_time - world.timeofday

		if(ticksleft > 1e5)
			prison_shuttle_time = world.timeofday + 10	// midnight rollover


		prison_shuttle_timeleft = (ticksleft / 10)
		sleep(5)
	prison_shuttle_moving_to_station = 0
	prison_shuttle_intransit = 0
	prison_shuttle_moving_to_prison = 0

	switch(prison_shuttle_at_station)

		if(0)
			prison_shuttle_at_station = 1
			if (prison_shuttle_intransit) return

			if (!prison_can_move())
				usr << "\red The prison shuttle is unable to leave."
				return

			prison_shuttle_intransit = 1
			for (var/mob/C in viewers(src))
				C.show_message("\blue <B>Shuttle desination set to [station_name]. Shuttle autopilot initialized.</B>", 3)
				C.show_message("\blue Undocking sequence initialized.", 3)
			for(var/obj/machinery/door/poddoor/L in machines)
				if (L.id == "tankp")
					spawn( 0 )
					L.close()
			for(var/obj/machinery/door/poddoor/L in machines)
				if (L.id == "prison")
					spawn( 0 )
					L.close()
			sleep(10)
			var/area/start_location = locate(/area/shuttle/prison/prison)
			var/area/end_location = locate(/area/shuttle/prison/transit)

			for (var/mob/C in viewers(src))
				C.show_message("\blue Thrusters engaged.", 3)
			sleep(10)
			start_location.move_contents_to(end_location)
			for (var/mob/C in viewers(src))
				C.show_message("\blue Shuttle en route.", 3)
			sleep(600)

			var/area/start_location2 = locate(/area/shuttle/prison/transit)
			var/area/end_location2 = locate(/area/shuttle/prison/station)

			for (var/mob/C in viewers(src))
				C.show_message("\blue Shuttle approaching destination.", 3)
			sleep(30)
			for (var/mob/C in viewers(src))
				C.show_message("\blue Docking sequence initiated.", 3)
			sleep(10)

			var/list/pshutturfs = list()
			var/throwy = world.maxy

			for(var/turf/T in end_location2)
				pshutturfs += T
				if(T.y < throwy)
					throwy = T.y

						// hey you, get out of the way!
			for(var/turf/T in pshutturfs)
							// find the turf to move things to
				var/turf/D = locate(T.x, throwy - 1, 1)
							//var/turf/E = get_step(D, SOUTH)
				for(var/atom/movable/AM as mob|obj in T)
					AM.Move(D)
				if(istype(T, /turf/simulated))
					del(T)

			start_location2.move_contents_to(end_location2)
			sleep(2)
			for (var/mob/C in viewers(src))
				C.show_message("\blue <B>Shuttle has arrived at destination: [station_name].</B>", 3)
			prison_shuttle_intransit = 0
			for(var/obj/machinery/door/poddoor/L in machines)
				if (L.id == "tanks")
					spawn( 0 )
					L.open()
			for(var/obj/machinery/door/poddoor/L in machines)
				if (L.id == "pss13")
					spawn( 0 )
					L.open()

		if(1)
			prison_shuttle_at_station = 0
			if (prison_shuttle_intransit) return

			if (!prison_can_move())
				usr << "\red The prison shuttle is unable to leave."
				return

			prison_shuttle_intransit = 1
			for (var/mob/C in viewers(src))
				C.show_message("\blue <B>Shuttle desination set to Prison Satellite. Shuttle autopilot initialized.</B>", 3)
				C.show_message("\blue Undocking sequence initialized.", 3)
			for(var/obj/machinery/door/poddoor/L in machines)
				if (L.id == "pss13")
					spawn( 0 )
					L.close()
			for(var/obj/machinery/door/poddoor/L in machines)
				if (L.id == "tanks")
					spawn( 0 )
					L.close()
			sleep(10)
			var/area/start_location = locate(/area/shuttle/prison/station)
			var/area/end_location = locate(/area/shuttle/prison/transit)

			for (var/mob/C in viewers(src))
				C.show_message("\blue Thrusters engaged.", 3)
			sleep(10)
			start_location.move_contents_to(end_location)
			for (var/mob/C in viewers(src))
				C.show_message("\blue Shuttle en route.", 3)
			sleep(600)

			var/area/start_location2 = locate(/area/shuttle/prison/transit)
			var/area/end_location2 = locate(/area/shuttle/prison/prison)

			for (var/mob/C in viewers(src))
				C.show_message("\blue Shuttle approaching destination.", 3)
			sleep(30)
			for (var/mob/C in viewers(src))
				C.show_message("\blue Docking sequence initiated.", 3)
			sleep(10)

			var/list/pshutturfs = list()
			var/throwy = world.maxy

			for(var/turf/T in end_location2)
				pshutturfs += T
				if(T.y < throwy)
					throwy = T.y

						// hey you, get out of the way!
			for(var/turf/T in pshutturfs)
							// find the turf to move things to
				var/turf/D = locate(T.x, throwy - 1, 1)
							//var/turf/E = get_step(D, SOUTH)
				for(var/atom/movable/AM as mob|obj in T)
					AM.Move(D)
				if(istype(T, /turf/simulated))
					del(T)

			start_location2.move_contents_to(end_location2)
			sleep(2)
			for (var/mob/C in viewers(src))
				C.show_message("\blue <B>Shuttle has arrived at destination: Prison Satellite.</B>", 3)
			prison_shuttle_intransit = 0
			for(var/obj/machinery/door/poddoor/L in machines)
				if (L.id == "tankp")
					spawn( 0 )
					L.open()
			for(var/obj/machinery/door/poddoor/L in machines)
				if (L.id == "prison")
					spawn( 0 )
					L.open()

/obj/machinery/computer/transitshuttle/newstationprison/proc/prison_can_move()
	if(prison_shuttle_intransit) return 0

	else return 1

/obj/machinery/computer/transitshuttle/newstationprison/attackby(I as obj, user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/transitshuttle/newstationprison/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/transitshuttle/newstationprison/attack_paw(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/transitshuttle/newstationprison/attackby(I as obj, user as mob)
	if(istype(I,/obj/item/weapon/card/emag))
		user << "\blue The screen's picture slightly deforms around the sequencer."
	else
		return src.attack_hand(user)


/obj/machinery/computer/transitshuttle/derelict/proc/derelict_process()
	while(derelict_shuttle_time - world.timeofday > 0)
		var/ticksleft = derelict_shuttle_time - world.timeofday

		if(ticksleft > 1e5)
			derelict_shuttle_time = world.timeofday + 10	// midnight rollover


		derelict_shuttle_timeleft = (ticksleft / 10)
		sleep(5)
	derelict_shuttle_moving_to_station = 0
	derelict_shuttle_intransit = 0
	derelict_shuttle_moving_to_derelict = 0

	switch(derelict_shuttle_at_station)

		if(0)
			derelict_shuttle_at_station = 1
			if (derelict_shuttle_intransit) return

			if (!derelict_can_move())
				usr << "\red The shuttle is unable to leave."
				return

			derelict_shuttle_intransit = 1
			for (var/mob/C in viewers(src))
				C.show_message("\blue <B>Shuttle desination set to [station_name]. Shuttle autopilot initialized.</B>", 3)
				C.show_message("\blue Undocking sequence initialized.", 3)
			sleep(10)
			var/area/start_location = locate(/area/shuttle/derelict/derelict)
			var/area/end_location = locate(/area/shuttle/derelict/transit)

			for (var/mob/C in viewers(src))
				C.show_message("\blue Thrusters engaged.", 3)
			sleep(10)
			start_location.move_contents_to(end_location)
			for (var/mob/C in viewers(src))
				C.show_message("\blue Shuttle en route.", 3)
			sleep(600)

			var/area/start_location2 = locate(/area/shuttle/derelict/transit)
			var/area/end_location2 = locate(/area/shuttle/derelict/station)

			for (var/mob/C in viewers(src))
				C.show_message("\blue Shuttle approaching destination.", 3)
			sleep(30)
			for (var/mob/C in viewers(src))
				C.show_message("\blue Docking sequence initiated.", 3)
			sleep(10)

			var/list/mshutturfs = list()
			var/throwy = world.maxy

			for(var/turf/T in end_location2)
				mshutturfs += T
				if(T.y < throwy)
					throwy = T.y

						// hey you, get out of the way!
			for(var/turf/T in mshutturfs)
							// find the turf to move things to
				var/turf/D = locate(T.x, throwy - 1, 1)
							//var/turf/E = get_step(D, SOUTH)
				for(var/atom/movable/AM as mob|obj in T)
					AM.Move(D)
				if(istype(T, /turf/simulated))
					del(T)

			start_location2.move_contents_to(end_location2)
			sleep(2)
			for (var/mob/C in viewers(src))
				C.show_message("\blue <B>Shuttle has arrived at destination: [station_name].</B>", 3)
			derelict_shuttle_intransit = 0
		if(1)
			derelict_shuttle_at_station = 0
			if (derelict_shuttle_intransit) return

			if (!derelict_can_move())
				usr << "\red The shuttle is unable to leave."
				return

			derelict_shuttle_intransit = 1
			for (var/mob/C in viewers(src))
				C.show_message("\blue <B>Shuttle desination set to \[Beacon NT-288\]. Shuttle autopilot initialized.</B>", 3)
				C.show_message("\blue Undocking sequence initialized.", 3)
			sleep(10)
			var/area/start_location = locate(/area/shuttle/derelict/station)
			var/area/end_location = locate(/area/shuttle/derelict/transit)

			for (var/mob/C in viewers(src))
				C.show_message("\blue Thrusters engaged.", 3)
			sleep(10)
			start_location.move_contents_to(end_location)
			for (var/mob/C in viewers(src))
				C.show_message("\blue Shuttle en route.", 3)
			sleep(600)

			var/area/start_location2 = locate(/area/shuttle/derelict/transit)
			var/area/end_location2 = locate(/area/shuttle/derelict/derelict)

			for (var/mob/C in viewers(src))
				C.show_message("\blue Shuttle approaching destination.", 3)
			sleep(30)
			for (var/mob/C in viewers(src))
				C.show_message("\blue Docking sequence initiated.", 3)
			sleep(10)

			var/list/dshutturfs = list()
			var/throwy = world.maxy

			for(var/turf/T in end_location2)
				dshutturfs += T
				if(T.y < throwy)
					throwy = T.y

						// hey you, get out of the way!
			for(var/turf/T in dshutturfs)
							// find the turf to move things to
				var/turf/D = locate(T.x, throwy - 1, 1)
							//var/turf/E = get_step(D, SOUTH)
				for(var/atom/movable/AM as mob|obj in T)
					AM.Move(D)
				if(istype(T, /turf/simulated))
					del(T)

			start_location2.move_contents_to(end_location2)
			sleep(2)
			for (var/mob/C in viewers(src))
				C.show_message("\blue <B>Shuttle has arrived at destination: \[Beacon NT-288\].</B>", 3)
			derelict_shuttle_intransit = 0

/obj/machinery/computer/transitshuttle/derelict/proc/derelict_can_move()
	if(derelict_shuttle_intransit) return 0

	else return 1

/obj/machinery/computer/transitshuttle/derelict/attackby(I as obj, user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/transitshuttle/derelict/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/transitshuttle/derelict/attack_paw(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/transitshuttle/derelict/attackby(I as obj, user as mob)
	if(istype(I,/obj/item/weapon/card/emag))
		user << "\blue The screen's picture slightly deforms around the sequencer."
	else
		return src.attack_hand(user)










/obj/machinery/computer/transitshuttle/newstationprison/attack_hand(var/mob/user as mob)
//	if(!src.allowed(user))
//		user << "\red Access Denied."
//		return

	if(prison_break)
		user << "\red Unable to locate shuttle."
		return

	if(..())
		return
	user.machine = src
	post_signal("prison")
	var/dat
	if (src.temp)
		dat = src.temp
	else
		dat += {"<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><BR><B>Prison Shuttle</B><HR>
		\nLocation: [prison_shuttle_moving_to_station || prison_shuttle_moving_to_prison ? "Moving to station ([prison_shuttle_timeleft] Secs.)":prison_shuttle_at_station ? "Station":"Dock"]<BR>
		[prison_shuttle_moving_to_station || prison_shuttle_moving_to_prison ? "\n*Shuttle already called*<BR>\n<BR>":prison_shuttle_at_station ? "\n<A href='?src=\ref[src];sendtodock=1'>Send to Dock</A><BR>\n<BR>":"\n<A href='?src=\ref[src];sendtostation=1'>Send to station</A><BR>\n<BR>"]
		\n<A href='?src=\ref[user];mach_close=computer'>Close</A>"}

	user << browse(dat, "window=computer;size=575x450")
	onclose(user, "computer")
	return

/obj/machinery/computer/transitshuttle/newstationprison/Topic(href, href_list)
	if(..())
		return

	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.machine = src

	if (href_list["sendtodock"])
		if(!prison_shuttle_at_station|| prison_shuttle_moving_to_station || prison_shuttle_moving_to_prison) return

		if (!prison_can_move())
			usr << "\red The prison shuttle is unable to leave."
			return

		post_signal("prison")
		usr << "\blue The prison shuttle has been called."

		src.temp += "Shuttle sent.<BR><BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
		src.updateUsrDialog()

		prison_shuttle_moving_to_prison = 1

		prison_shuttle_time = world.timeofday + PRISONSHUTTLE_MOVETIME
		spawn(0)
			prison_process()

	else if (href_list["sendtostation"])
		if(prison_shuttle_at_station || prison_shuttle_moving_to_station || prison_shuttle_moving_to_prison) return

		if (!prison_can_move())
			usr << "\red The prison shuttle is unable to leave."
			return

		post_signal("prison")
		usr << "\blue The prison shuttle has been called."

		src.temp += "Shuttle sent.<BR><BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
		src.updateUsrDialog()

		prison_shuttle_moving_to_station = 1

		prison_shuttle_time = world.timeofday + PRISONSHUTTLE_MOVETIME
		spawn(0)
			prison_process()

	else if (href_list["mainmenu"])
		src.temp = null

	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return

/obj/machinery/computer/transitshuttle/newstationprison/proc/prison_break()
	switch(prison_break)
		if (0)
			if(!prison_shuttle_at_station || prison_shuttle_moving_to_prison) return

			prison_shuttle_moving_to_prison = 1
			prison_shuttle_at_station = prison_shuttle_at_station

			if (!prison_shuttle_moving_to_prison || !prison_shuttle_moving_to_station)
				prison_shuttle_time = world.timeofday + PRISONSHUTTLE_MOVETIME
			spawn(0)
				prison_process()
			prison_break = 1
		if(1)
			prison_break = 0

/obj/machinery/computer/transitshuttle/newstationprison/proc/post_signal(var/command)

	var/datum/radio_frequency/frequency = radio_controller.return_frequency(1311)

	if(!frequency) return

	var/datum/signal/status_signal = new
	status_signal.source = src
	status_signal.transmission_method = 1
	status_signal.data["command"] = command

	frequency.post_signal(src, status_signal)






/*


/obj/machinery/computer/transitshuttle/mining/attack_hand(var/mob/user as mob)
//	if(!src.allowed(user))
//		user << "\red Access Denied."
//		return

	if(..())
		return
	user.machine = src
	sleep(-1)
	post_signal("mining")
	var/dat
	if (src.temp)
		dat = src.temp
	else
		dat += {"<BR><B>Mining Shuttle</B><HR>
		\nLocation: [mining_shuttle_moving_to_station || mining_shuttle_moving_to_asteroid ? "Moving to station (Approximately [mining_shuttle_timeleft] Secs.)":mining_shuttle_at_station ? "Station":"Asteroid"]<BR>
		[mining_shuttle_moving_to_station || mining_shuttle_moving_to_asteroid ? "\n*Shuttle already called*<BR>\n<BR>":mining_shuttle_at_station ? "\n<A href='?src=\ref[src];sendtodock=1'>Send to asteroid</A><BR>\n<BR>":"\n<A href='?src=\ref[src];sendtostation=1'>Send to station</A><BR>\n<BR>"]
		\n<A href='?src=\ref[user];mach_close=computer'>Close</A>"}

	user << browse(dat, "window=computer;size=575x450")
	onclose(user, "computer")
	return

/obj/machinery/computer/transitshuttle/mining/Topic(href, href_list)
	if(..())
		return

	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.machine = src

	if (href_list["sendtodock"])
		if(!mining_shuttle_at_station|| mining_shuttle_moving_to_station || mining_shuttle_moving_to_asteroid) return

		if (!mining_can_move())
			usr << "\red The mining shuttle is unable to leave."
			return
		sleep(-1)
		post_signal("mining")
		usr << "\blue The mining shuttle has been called."

		src.temp += "Shuttle sent.<BR><BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
		src.updateUsrDialog()

		mining_shuttle_moving_to_asteroid = 1

		mining_shuttle_time = world.timeofday + MININGSHUTTLE_MOVETIME
		spawn(0)
	//		mining_process()

	else if (href_list["sendtostation"])
		if(mining_shuttle_at_station || mining_shuttle_moving_to_station || mining_shuttle_moving_to_asteroid) return

		if (!mining_can_move())
			usr << "\red The mining shuttle is unable to leave."
			return
		sleep(-1)
		post_signal("mining")
		usr << "\blue The mining shuttle has been called."

		src.temp += "Shuttle sent.<BR><BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
		src.updateUsrDialog()

		mining_shuttle_moving_to_station = 1

		mining_shuttle_time = world.timeofday + MININGSHUTTLE_MOVETIME
		spawn(0)
		//	mining_process()

	else if (href_list["mainmenu"])
		src.temp = null

	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return

/obj/machinery/computer/transitshuttle/mining/proc/post_signal(var/command)

	var/datum/radio_frequency/frequency = radio_controller.return_frequency(1311)

	if(!frequency) return

	var/datum/signal/status_signal = new
	status_signal.source = src
	status_signal.transmission_method = 1
	status_signal.data["command"] = command

	frequency.post_signal(src, status_signal)

*/



/obj/machinery/computer/transitshuttle/derelict/attack_hand(var/mob/user as mob)
//	if(!src.allowed(user))
//		user << "\red Access Denied."
//		return

	if(..())
		return
	user.machine = src
	sleep(-1)
	post_signal("derelict")
	var/dat
	if (src.temp)
		dat = src.temp
	else
		dat += {"<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><BR><B>Salvaging Shuttle</B><HR>
		\nLocation: [derelict_shuttle_moving_to_station || derelict_shuttle_moving_to_derelict ? "Moving to station (Approximately [derelict_shuttle_timeleft] Secs.)":derelict_shuttle_at_station ? "Station":"\[Beacon NT-288\]"]<BR>
		[derelict_shuttle_moving_to_station || derelict_shuttle_moving_to_derelict ? "\n*Shuttle already called*<BR>\n<BR>":derelict_shuttle_at_station ? "\n<A href='?src=\ref[src];sendtodock=1'>Send to \[Beacon NT-288\]</A><BR>\n<BR>":"\n<A href='?src=\ref[src];sendtostation=1'>Send to station</A><BR>\n<BR>"]
		\n<A href='?src=\ref[user];mach_close=computer'>Close</A>"}

	user << browse(dat, "window=computer;size=575x450")
	onclose(user, "computer")
	return

/obj/machinery/computer/transitshuttle/derelict/Topic(href, href_list)
	if(..())
		return

	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.machine = src

	if (href_list["sendtodock"])
		if(!derelict_shuttle_at_station|| derelict_shuttle_moving_to_station || derelict_shuttle_moving_to_derelict) return

		if (!derelict_can_move())
			usr << "\red The salvaging shuttle is unable to leave."
			return
		sleep(-1)
		post_signal("derelict")
		usr << "\blue The salvaging shuttle has been called."

		src.temp += "Shuttle sent.<BR><BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
		src.updateUsrDialog()

		derelict_shuttle_moving_to_derelict = 1

//		derelict_shuttle_time = world.timeofday + DERELICTSHUTTLE_MOVETIME
		spawn(0)
			derelict_process()

	else if (href_list["sendtostation"])
		if(derelict_shuttle_at_station || derelict_shuttle_moving_to_station || derelict_shuttle_moving_to_derelict) return

		if (!derelict_can_move())
			usr << "\red The salvaging shuttle is unable to leave."
			return
		sleep(-1)
		post_signal("derelict")
		usr << "\blue The salvaging shuttle has been called."

		src.temp += "Shuttle sent.<BR><BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
		src.updateUsrDialog()

		derelict_shuttle_moving_to_station = 1

//		derelict_shuttle_time = world.timeofday + DERELICTSHUTTLE_MOVETIME
		spawn(0)
			derelict_process()

	else if (href_list["mainmenu"])
		src.temp = null

	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return

/obj/machinery/computer/transitshuttle/derelict/proc/post_signal(var/command)

	var/datum/radio_frequency/frequency = radio_controller.return_frequency(1311)

	if(!frequency) return

	var/datum/signal/status_signal = new
	status_signal.source = src
	status_signal.transmission_method = 1
	status_signal.data["command"] = command

	frequency.post_signal(src, status_signal)

















