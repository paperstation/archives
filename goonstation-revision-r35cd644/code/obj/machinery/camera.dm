/obj/machinery/camera
	name = "security camera"
	desc = "A small, high quality camera with thermal, light-amplification, and diffused laser imaging to see through walls. It is tied into a computer system, allowing those with access to watch what occurs around it."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "camera"
	var/network = "SS13"
	layer = EFFECTS_LAYER_UNDER_1
	var/c_tag = null
	var/c_tag_order = 999
	var/status = 1.0
	anchored = 1.0
	var/invuln = null
	var/last_paper = 0

	//This camera is a node pointing to the other bunch of cameras nearby for AI movement purposes
	var/obj/machinery/camera/c_north = null
	var/obj/machinery/camera/c_east = null
	var/obj/machinery/camera/c_west = null
	var/obj/machinery/camera/c_south = null

	//Here's a list of cameras pointing to this camera for reprocessing purposes
	var/list/obj/machinery/camera/referrers = list()


/obj/machinery/camera/television
	name = "television camera"
	desc = "A bulky stationary camera for wireless broadcasting of live feeds."
	network = "Zeta" // why not.
	icon_state = "television"
	anchored = 1
	density = 1

/obj/machinery/camera/television/mobile
	name = "mobile television camera"
	desc = "A bulky mobile camera for wireless broadcasting of live feeds."
	anchored = 0
	icon_state = "mobilevision"

/obj/machinery/camera/New()
	..()

	cameras.Add(src)

	spawn(10)
		// making life easy for mappers since 2013
		if (dd_hasprefix(name, "autoname"))
			var/area/where = get_area(src)
			if (isarea(where))
				name = "security camera"
				var/count = 1

				for(var/obj/machinery/camera/C in where)
					if (C == src)
						continue
					if (dd_hasprefix(C.name, "autoname"))
						C.name = "security camera"
						if (C.c_tag == "autotag")
							count++
							C.c_tag = "[where.name] [count]"

				if (c_tag == "autotag")
					if (count > 1)
						c_tag = "[where.name] 1"
					else
						c_tag = "[where.name]"

		addToNetwork()

/obj/machinery/camera/proc/addToNetwork()

	if(camnets[network])
		var/list/net = camnets[network]
		net.Add(src)
	else
		var/list/net = list()
		net.Add(src)
		camnets[network] = net

/obj/machinery/camera/proc/addToReferrers(var/obj/machinery/camera/C) //Safe addition
	if(!(C in referrers)) referrers += C

/obj/machinery/camera/proc/removeNode(var/obj/machinery/camera/node) //Completely remove a node from this camera
	for(var/N in list("c_north", "c_east", "c_south", "c_west"))
		if(node == vars[N])
			vars[N] = null
	node.referrers -= src

/obj/machinery/camera/proc/hasNode(var/obj/machinery/camera/node)
	if(!istype(node)) return 0
	. = 0
	. = (node == c_north) + (node == c_east) + (node == c_south) + (node == c_west)


/obj/machinery/camera/disposing()
	..()
	dirty_cameras |= referrers
	camnet_needs_rebuild = 1
	for(var/obj/machinery/camera/C in referrers) //In case the GC does not have time to remove us from the referring cameras
		C.removeNode(src)

	//logTheThing("debug", null, null, "<B>SpyGuy/Camnet:</B> Camera destroyed. Camera network needs a rebuild! Number of dirty cameras: [dirty_cameras.len]")
	//connect_camera_list(referrers)


/obj/machinery/camera/ex_act(severity)
	if(src.invuln)
		return
	else
		..(severity)
	return

/obj/machinery/camera/emp_act()
	..()
	src.icon_state = "cameraemp"
	src.network = null                   //Not the best way but it will do. I think.
	spawn(900)
		src.network = initial(src.network)
		src.icon_state = initial(src.icon_state)
	src.disconnect_viewers()
	return

/obj/machinery/camera/blob_act(var/power)
	return

/obj/machinery/camera/attack_ai(var/mob/living/silicon/ai/user as mob)
	if (!istype(user)) //Other silicon mobs shouldn't try to encroach on the AI's "view through all cameras" schtick.  Mostly because it generates runtime errors.
		return
	if (src.network != user.network || !(src.status))
		return
	//if (istype(user, /mob/living/silicon/ai/hologram))
	//	return
	user.current = src
	user.set_eye(src)

// v the fuck is this??? v
/*/obj/machinery/camera/attack_hand(mob/user as mob)
	if(user.jew == 1)
		src.status = !( src.status )
		if (!( src.status ))
			var/message = pick("OY VEY!","Bupkes!","Feh!","What a mishegas!","Schlocky putz!")
			user.say(message)
			src.icon_state = "camera1"
		else
			var/message = pick("OY VEY!","Bupkes!","Feh!","What a mishegas!","Schlocky putz!")
			user.say(message)
			src.icon_state = "camera"
		// now disconnect anyone using the camera
		disconnect_viewers()
	else
		return
	return*/

/obj/machinery/camera/proc/disconnect_viewers()
	for(var/mob/O in mobs)
		if (istype(O, /mob/living/silicon/ai))
			var/mob/living/silicon/ai/OAI = O
			if (OAI.current == src)
				if( OAI.camera_overlay_check(src) )
					boutput(OAI, "Your regain your connection to the camera.")
				else
					boutput(OAI, "Your connection to the camera has been lost.")

		else if (istype(O.machine, /obj/machinery/computer/security))
			var/obj/machinery/computer/security/S = O.machine
			if (S.current == src)
				O.machine = null
				S.current = null
				O.set_eye(null)
				boutput(O, "The screen bursts into static.")

/obj/machinery/camera/attackby(obj/W as obj, mob/user as mob)
	if(istype(W,/obj/item/parts/human_parts)) //dumb easter egg incoming
		user.visible_message("<span style=\"color:red\">[user] wipes [src] with the bloody end of [W.name]. What the fuck?</span>", "<span style=\"color:red\">You wipe [src] with the bloody end of [W.name]. What the fuck?</span>")
		return
	if (istype(W, /obj/item/wirecutters))
		src.status = !( src.status )
		if (!( src.status ))
			user.visible_message("<span style=\"color:red\">[user] has deactivated [src]!</span>", "<span style=\"color:red\">You have deactivated [src].</span>")
			logTheThing("station", null, null, "[key_name(user)] deactivated a security camera ([showCoords(src.loc.x, src.loc.y, src.loc.z)])")
			playsound(src.loc, "sound/items/Wirecutter.ogg", 100, 1)
			src.icon_state = "camera1"
			add_fingerprint(user)

		else
			user.visible_message("<span style=\"color:red\">[user] has reactivated [src]!</span>", "<span style=\"color:red\">You have reactivated [src].</span>")
			playsound(src.loc, "sound/items/Wirecutter.ogg", 100, 1)
			src.icon_state = "camera"
			add_fingerprint(user)
		// now disconnect anyone using the camera
		src.disconnect_viewers()
	else if (istype(W, /obj/item/paper))
		if (last_paper && ( (last_paper + 80) >= world.time))
			return

		last_paper = world.time
		var/obj/item/paper/X = W
		boutput(user, "You hold a paper up to the camera ...")
		for(var/mob/O in mobs)
			if (istype(O, /mob/living/silicon/ai))
				boutput(O, "[user] holds a paper up to one of your cameras ...")
				O << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", X.name, X.info), text("window=[]", X.name))
				logTheThing("station", user, O, "holds up a paper to a camera at [log_loc(src)], forcing %target% to read it. <b>Title:</b> [X.name]. <b>Text:</b> [adminscrub(X.info)]")
			else if (istype(O.machine, /obj/machinery/computer/security))
				var/obj/machinery/computer/security/S = O.machine
				if (S.current == src)
					boutput(O, "[user] holds a paper up to one of the cameras ...")
					O << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", X.name, X.info), text("window=[]", X.name))
					logTheThing("station", user, O, "holds up a paper to a camera at [log_loc(src)], forcing %target% to read it. <b>Title:</b> [X.name]. <b>Text:</b> [adminscrub(X.info)]")


//Return a working camera that can see a given mob
//or null if none
/proc/seen_by_camera(var/mob/M)

	for(var/obj/machinery/camera/C in oview(M))
		if(C.status)	// check if camera disabled
			return C
			break

	return null



/obj/machinery/camera/motion
	name = "Motion Security Camera"
	var/list/motionTargets = list()
	var/detectTime = 0
	var/locked = 1

/obj/machinery/camera/motion/process()
	// motion camera event loop
	if (detectTime > 0)
		var/elapsed = world.time - detectTime
		if (elapsed > 300)
			triggerAlarm()
	else if (detectTime == -1)
		for (var/mob/target in motionTargets)
			if (target.stat == 2) lostTarget(target)

/obj/machinery/camera/motion/proc/newTarget(var/mob/target)
	if (istype(target, /mob/living/silicon/ai)) return 0
	if (detectTime == 0)
		detectTime = world.time // start the clock
	if (!(target in motionTargets))
		motionTargets += target
	return 1

/obj/machinery/camera/motion/proc/lostTarget(var/mob/target)
	if (target in motionTargets)
		motionTargets -= target
	if (motionTargets.len == 0)
		cancelAlarm()

/obj/machinery/camera/motion/proc/cancelAlarm()
	if (detectTime == -1)
		for (var/mob/living/silicon/aiPlayer in mobs)
			if (status) aiPlayer.cancelAlarm("Motion", src.loc.loc)
	detectTime = 0
	return 1

/obj/machinery/camera/motion/proc/triggerAlarm()
	if (!detectTime) return 0
	for (var/mob/living/silicon/aiPlayer in mobs)
		if (status) aiPlayer.triggerAlarm("Motion", src.loc.loc, src)
	detectTime = -1
	return 1

/obj/machinery/camera/motion/attackby(W as obj, mob/user as mob)
	if (istype(W, /obj/item/wirecutters) && locked == 1) return
	if (istype(W, /obj/item/screwdriver))
		var/turf/T = user.loc
		boutput(user, text("<span style=\"color:blue\">[]ing the access hatch... (this is a long process)</span>", (locked) ? "Open" : "Clos"))
		sleep(100)
		if ((user.loc == T && user.equipped() == W && !( user.stat )))
			src.locked ^= 1
			boutput(user, text("<span style=\"color:blue\">The access hatch is now [].</span>", (locked) ? "closed" : "open"))

	..() // call the parent to (de|re)activate

	if (istype(W, /obj/item/wirecutters)) // now handle alarm on/off...
		if (status) // ok we've just been reconnected... send an alarm!
			detectTime = world.time - 301
			triggerAlarm()
		else
			for (var/mob/living/silicon/aiPlayer in mobs) // manually cancel, to not disturb internal state
				aiPlayer.cancelAlarm("Motion", src.loc.loc)




/*------------------------------------
		CAMERA NETWORK STUFF
------------------------------------*/

/proc/build_camera_network()
	connect_camera_list(machines)

/proc/rebuild_camera_network()
	if(defer_camnet_rebuild || !camnet_needs_rebuild) return

	connect_camera_list(dirty_cameras)
	dirty_cameras.Cut()
	camnet_needs_rebuild = 0

/proc/disconnect_camera_network()
	for(var/obj/machinery/camera/C in machines)
		C.c_north = null
		C.c_east = null
		C.c_south = null
		C.c_west = null
		C.referrers.Cut()

/proc/connect_camera_list(var/list/obj/machinery/camera/camlist, var/force_connection=0)
	if( camlist.len < 1)  return 1

	logTheThing("debug", null, null, "<B>SpyGuy/Camnet:</B> Starting to connect cameras")
	var/count = 0
	for(var/obj/machinery/camera/C in camlist)
		if(!isturf(C.loc) || C.disposed || C.qdeled) //This is one of those weird internal cameras, or it's been deleted and hasn't had the decency to go away yet
			continue


		connect_camera_neighbours(C, NORTH, force_connection)
		connect_camera_neighbours(C, EAST, force_connection)
		connect_camera_neighbours(C, SOUTH, force_connection)
		connect_camera_neighbours(C, WEST, force_connection)
		count++

		if(!(C.c_north || C.c_east || C.c_south || C.c_west))
			logTheThing("debug", null, null, "<B>SpyGuy/Camnet:</B> Camera at [showCoords(C.x, C.y, C.z)] failed to receive cardinal directions during initialization.")

	logTheThing("debug", null, null, "<B>SpyGuy/Camnet:</B> Done. Connected [count] cameras.")

	return 0

/proc/connect_camera_neighbours(var/obj/machinery/camera/C, var/direction, var/force_connection=0)
	var/dir_var = "" //The direction we're trying to fill
	var/rec_var = "" //The reciprocal of this direction

	if(direction & NORTH)
		dir_var = "c_north"
		rec_var = "c_south"
	else if(direction & EAST)
		dir_var ="c_east"
		rec_var = "c_west"
	else if(direction & SOUTH)
		dir_var = "c_south"
		rec_var = "c_north"
	else if(direction & WEST)
		dir_var = "c_west"
		rec_var = "c_east"

	if(!dir_var) return


	if(!C.vars[dir_var] || force_connection)
		var/obj/machinery/camera/candidate = null
		candidate = getCameraMove(C, direction)
		/*
		if(!candidate)
			logTheThing("debug", null, null, "<B>SpyGuy/Camnet:</B> Camera at [showCoords(C.x, C.y, C.z)] didn't get a candidate when heading [dir2text(direction)].")
			return
		*/
		if(candidate && C.z == candidate.z && C.network == candidate.network) // && (!camera_network_reciprocity || !candidate.vars[rec_var]))
			C.vars[dir_var] = candidate
			candidate.addToReferrers(C)

			if(camera_network_reciprocity && (!candidate.vars[rec_var]))
				candidate.vars[rec_var] = C
				C.addToReferrers(candidate)
/*
		else
			logTheThing("debug", null, null, "<B>SpyGuy/Camnet:</B> Camera at [showCoords(C.x, C.y, C.z)] rejected. cand z = [candidate.z], C z = [C.z]; cand net = [candidate.network], C net = [C.network]; reciprocity = [camera_network_reciprocity], rec_var:[rec_var] ( [isnull(candidate.vars[rec_var]) ? "null" : "not null"] )")
	else
		logTheThing("debug", null, null, "<B>SpyGuy/Camnet:</B> Camera at [showCoords(C.x, C.y, C.z)] rejected because [dir_var] was already set.")
		*/




