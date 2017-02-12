// AI (i.e. game AI, not the AI player) controlled bots

/obj/machinery/bot
	icon = 'icons/obj/aibots.dmi'
	layer = MOB_LAYER
	var/obj/item/card/id/botcard // ID card that the bot "holds".
	var/access_lookup = "Captain" // For the get_access() proc. Defaults to all-access.
	var/locked = null
	var/on = 1
	var/health = 25
	var/muted = 0 // shut up omg shut up.
	var/no_camera = 0
	var/setup_camera_network = "Robots"
	var/obj/machinery/camera/cam = null
	var/emagged = 0
	var/mob/emagger = null
	var/text2speech = 0 // dectalk!

	power_change()
		return

	CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
		if (istype(mover, /obj/projectile))
			return 0
		return ..()

	New()
		..()

		if(!no_camera)
			src.cam = new /obj/machinery/camera(src)
			src.cam.c_tag = src.name
			src.cam.network = setup_camera_network

	// Generic default. Override for specific bots as needed.
	bullet_act(var/obj/projectile/P)
		if (!P || !istype(P))
			return

		var/damage = 0
		damage = round(((P.power/4)*P.proj_data.ks_ratio), 1.0)

		if (P.proj_data.damage_type == D_KINETIC)
			src.health -= damage
		else if (P.proj_data.damage_type == D_PIERCING)
			src.health -= (damage*2)
		else if (P.proj_data.damage_type == D_ENERGY)
			src.health -= damage

		if (src.health <= 0)
			src.explode()
		return

	proc/explode()
		return

	proc/speak(var/message)
		if (!src.on || !message || src.muted)
			return
		src.audible_message("<span class='game say'><span class='name'>[src]</span> beeps, \"[message]\"")
		if (src.text2speech)
			spawn(0)
				var/audio = dectalk("\[:nk\][message]")
				if (audio && audio["audio"])
					for (var/mob/O in hearers(src, null))
						if (!O.client)
							continue
						ehjax.send(O.client, "browseroutput", list("dectalk" = audio["audio"]))
					return 1
				else
					return 0

/******************************************************************/
// Navigation procs
// Used for A-star pathfinding

// Returns the surrounding cardinal turfs with open links
// Including through doors openable with the ID
/turf/proc/CardinalTurfsWithAccess(var/obj/item/card/id/ID)
	var/L[] = new()

	//	for(var/turf/simulated/t in oview(src,1))

	for(var/d in cardinal)
		var/turf/simulated/T = get_step(src, d)
		//if(istype(T) && !T.density)
		if (T && T.pathable && !T.density)
			if(!LinkBlockedWithAccess(src, T, ID))
				L.Add(T)
	return L

/turf/proc/CardinalTurfsSpace()
	var/L[] = new()

	for (var/d in cardinal)
		var/turf/T = get_step(src, d)
		if (T && (T.pathable || istype(T, /turf/space)) && !T.density)
			if (!LinkBlockedWithAccess(src, T))
				L.Add(T)

	return L

// Returns true if a link between A and B is blocked
// Movement through doors allowed if ID has access
/proc/LinkBlockedWithAccess(turf/A, turf/B, obj/item/card/id/ID)

	if(A == null || B == null) return 1
	var/adir = get_dir(A,B)
	var/rdir = get_dir(B,A)
	if((adir & (NORTH|SOUTH)) && (adir & (EAST|WEST)))	//	diagonal
		var/iStep = get_step(A,adir&(NORTH|SOUTH))
		if(!LinkBlockedWithAccess(A,iStep, ID) && !LinkBlockedWithAccess(iStep,B,ID))
			return 0

		var/pStep = get_step(A,adir&(EAST|WEST))
		if(!LinkBlockedWithAccess(A,pStep,ID) && !LinkBlockedWithAccess(pStep,B,ID))
			return 0
		return 1

	if(DirBlockedWithAccess(A,adir, ID))
		return 1

	if(DirBlockedWithAccess(B,rdir, ID))
		return 1

	for (var/atom/O in B.contents)
		if (O.density && !(O.flags & ON_BORDER))
			if (istype(O, /obj/machinery/door))
				var/obj/machinery/door/D = O
				if (D.isblocked())
					return 1
				return 0
			if (ismob(O))
				var/mob/M = O
				if (M.anchored)
					return 1
				return 0
			return 1

	return 0

// Returns true if direction is blocked from loc
// Checks doors against access with given ID
/proc/DirBlockedWithAccess(turf/loc,var/dir,var/obj/item/card/id/ID)
	var/blocked = 0

	for (var/obj/window/D in loc)
		if (D.density && D.dir == dir)
			blocked = 1
		if (D.density && !(D.flags & ON_BORDER))
			blocked = 1

	for (var/obj/machinery/door/D in loc)
		if (D.isblocked())
			blocked = 1
		if (istype(D, /obj/machinery/door/window))
			if (dir & D.dir)
				if (D.density && D.check_access(ID) == 0)
					blocked = 1
		else
			if (D.density && D.check_access(ID) == 0)
				blocked = 1

	return blocked