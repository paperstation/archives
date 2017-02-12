/obj/machinery/computer/stargate
	name = "stargate"
	desc = "Use this to set your destination...hopefully..."
	icon_state = "teleport"
	var/obj/item/locked = null
	var/id = null

/obj/machinery/computer/stargate/New()
	src.id = text("[]", rand(1000, 9999))
	..()
	return


/obj/machinery/computer/stargate/attackby(obj/item/weapon/W)
	if (istype(W, /obj/item/weapon/card/data/))
		if(stat & (NOPOWER|BROKEN))
			src.attack_hand()

		var/obj/S = null
		for(var/obj/landmark/sloc in landmarkz)
			if (sloc.name != "Clown Land")
				continue
			if (locate(/mob) in sloc.loc)
				continue
			S = sloc
			break
		if (!S)
			S = locate("landmark*["Clown Land"]") // use old stype
		if (istype(S, /obj/landmark/) && istype(S.loc, /turf))
			usr.loc = S.loc
			del(W)
	else
		src.attack_hand()

/obj/machinery/computer/stargate/attack_paw()
	src.attack_hand()

/obj/machinery/computer/stargate/security/attackby(obj/item/weapon/W)
	src.attack_hand()

/obj/machinery/computer/stargate/security/attack_paw()
	src.attack_hand()

/obj/machinery/stargate/Power/attack_ai()
	src.attack_hand()

/obj/machinery/computer/stargate/attack_hand()
	if(stat & (NOPOWER|BROKEN))
		return

	var/list/L = list()
	var/list/areaindex = list()

	for(var/obj/item/device/radio/beacon/R in world)
		var/turf/T = find_loc(R)
		if (!T)	continue
		var/tmpname = T.loc.name
		if(areaindex[tmpname])
			tmpname = "[tmpname] ([++areaindex[tmpname]])"
		else
			areaindex[tmpname] = 1
		L[tmpname] = R

	for (var/obj/item/weapon/implant/tracking/I in world)
		if (!I.implanted || !ismob(I.loc))
			continue
		else
			var/mob/M = I.loc
			if (M.stat == 2)
				if (M.timeofdeath + 6000 < world.time)
					continue
			var/tmpname = M.real_name
			if(areaindex[tmpname])
				tmpname = "[tmpname] ([++areaindex[tmpname]])"
			else
				areaindex[tmpname] = 1
			L[tmpname] = I

	var/desc = input("Please select a location to lock in.", "Locking Computer") in L
	src.locked = L[desc]
	for(var/mob/O in hearers(src, null))
		O.show_message("\blue Locked In", 2)
	src.add_fingerprint(usr)
	return

/obj/machinery/computer/stargate/verb/set_id(t as text)
	set category = "Object"
	set name = "Set teleporter ID"
	set src in oview(1)
	set desc = "ID Tag:"

	if(stat & (NOPOWER|BROKEN) || !istype(usr,/mob/living))
		return
	if (t)
		src.id = t
	return

/obj/machinery/computer/stargate/security/attack_hand()
	if(stat & (NOPOWER|BROKEN))
		return

	var/list/L = list()
	var/list/areaindex = list()

	for(var/obj/item/device/radio/courtroom_beacon/R in world)
		var/turf/T = find_loc(R)
		if (!T)	continue
		var/tmpname = T.loc.name
		if(areaindex[tmpname])
			tmpname = "[tmpname] ([++areaindex[tmpname]])"
		else
			areaindex[tmpname] = 1
		L[tmpname] = R

	var/desc = input("Please select a location to lock in.", "Locking Computer") in L
	src.locked = L[desc]
	for(var/mob/O in hearers(src, null))
		O.show_message("\blue Locked In", 2)
	src.add_fingerprint(usr)
	return

/obj/machinery/stargate/portal/Bumped(M as mob|obj)
	spawn( 0 )
		if (src.icon_state == "gate1")
			teleport(M)
			use_power(5000)
		return
	return

/obj/machinery/stargate/portal/proc/teleport(atom/movable/M as mob|obj)
	var/atom/l = src.loc
	var/obj/machinery/computer/stargate/com = locate(/obj/machinery/computer/stargate, locate(l.x - 2, l.y, l.z))
	if (!com)
		return
	if (!com.locked)
		for(var/mob/O in hearers(src, null))
			O.show_message("\red Failure: Cannot authenticate locked on coordinates. Please reinstate coordinate matrix.")
		return
	if (istype(M, /atom/movable))
		if(prob(5)) //oh dear a problem, put em in deep space
			do_teleport(M, locate(rand(5, world.maxx - 5), rand(5, world.maxy - 5), 3), 2)
		else
			do_teleport(M, com.locked, 0) //dead-on precision
	else
		var/datum/effects/system/spark_spread/s = new /datum/effects/system/spark_spread
		s.set_up(5, 1, src)
		s.start()
		for(var/mob/B in hearers(src, null))
			B.show_message("\blue Test fire completed.")
	return

/obj/machinery/stargate/Power/attackby(var/obj/item/weapon/W)
	src.attack_hand()

/obj/machinery/stargate/Power/attack_paw()
	src.attack_hand()

/obj/machinery/stargate/Power/attack_ai()
	src.attack_hand()

/obj/machinery/stargate/Power/attack_hand()
	if(engaged)
		src.disengage()
	else
		src.engage()

/obj/machinery/stargate/Power/proc/engage()
	if(stat & (BROKEN|NOPOWER))
		return

	var/atom/l = src.loc
	var/atom/com = locate(/obj/machinery/stargate/portal, locate(l.x + 1, l.y, l.z))
	if (com)
		com.icon_state = "gate1"
		use_power(5000)
		playsound(src.loc, 'teleporter_open.ogg', 30, 0)
		for(var/mob/O in hearers(src, null))
			O.show_message("\blue Teleporter engaged!", 2)
	src.add_fingerprint(usr)
	src.engaged = 1
	return

/obj/machinery/stargate/Power/proc/disengage()
	if(stat & (BROKEN|NOPOWER))
		return

	var/atom/l = src.loc
	var/atom/com = locate(/obj/machinery/stargate/portal, locate(l.x + 1, l.y, l.z))
	if (com)
		com.icon_state = "gate0"
		playsound(src.loc, 'teleporter_close.ogg', 30, 0)
		for(var/mob/O in hearers(src, null))
			O.show_message("\blue Teleporter disengaged!", 2)
	src.add_fingerprint(usr)
	src.engaged = 0
	return

/obj/machinery/stargate/Power/verb/testfire()
	set name = "Test Fire Teleporter"
	set category = "Object"
	set src in oview(1)

	if(stat & (BROKEN|NOPOWER) || !istype(usr,/mob/living))
		return

	var/atom/l = src.loc
	var/obj/machinery/stargate/portal/com = locate(/obj/machinery/stargate/portal, locate(l.x + 1, l.y, l.z))
	if (com && !active)
		active = 1
		for(var/mob/O in hearers(src, null))
			O.show_message("\blue Test firing!", 2)
		com.teleport()
		use_power(5000)

		spawn(30)
			active=0

	src.add_fingerprint(usr)
	return

/obj/machinery/stargate/Power/power_change()
	..()
	if(stat & NOPOWER)
		icon_state = "controller-p"
		var/obj/machinery/stargate/portal/com = locate(/obj/machinery/stargate/portal, locate(x + 1, y, z))
		if(com)
			com.icon_state = "gate0"
	else
		icon_state = "controller"

