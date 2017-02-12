/obj/machinery/teleport
	name = "teleport"
	icon = 'icons/obj/teleporter.dmi'
	density = 1
	anchored = 1.0
	mats = 10

	New()
		..()

/obj/machinery/teleport/portal_ring
	name = "portal ring"
	icon_state = "tele0"
	var/obj/machinery/computer/teleporter/linked_computer = null
	var/obj/machinery/teleport/portal_generator/linked_generator = null
	var/datum/light/light
	power_usage = 0

	New()
		..()
		find_links()
		light = new /datum/light/point
		light.set_brightness(0.6)
		light.set_color(0.4, 0.4, 1)
		light.attach(src)

	attack_ai()
		src.attack_hand()

	Bumped(M as mob|obj)
		spawn( 0 )
			if (src.icon_state == "tele1")
				teleport(M)
				use_power(5000)
			return
		return

	process()
		if (src.icon_state == "tele1") // REALLY. really. really? r e a l l y?
			power_usage = 5000
		else
			power_usage = 0
		..()
		if (stat & NOPOWER)
			icon_state = "tele0"

	proc/teleport(atom/movable/M as mob|obj)
		if (find_links() < 2)
			src.visible_message("<b>[src]</b> intones, \"System error. Cannot find required equipment links.\"")
			return
		if (!linked_computer.locked)
			src.visible_message("<b>[src]</b> intones, \"System error. Cannot verify locked co-ordinates.\"")
			return
		if (istype(M, /atom/movable))
			do_teleport(M, linked_computer.locked, 0) //dead-on precision
		else
			var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
			s.set_up(5, 1, src)
			s.start()

	proc/find_links()
		linked_computer = null
		linked_generator = null
		var/found = 0
		for(var/obj/machinery/computer/teleporter/T in orange(2,src))
			linked_computer = T
			found++
			break
		for(var/obj/machinery/teleport/portal_generator/S in orange(2,src))
			linked_generator = S
			found++
			break
		return found

/obj/machinery/teleport/portal_generator
	name = "portal generator"
	icon_state = "controller"
	var/active = 0
	var/engaged = 0
	var/obj/machinery/computer/teleporter/linked_computer = null
	var/list/linked_rings = list()
	power_usage = 250

	New()
		..()
		find_links()

	attack_ai()
		src.attack_hand()

	attack_hand()
		if(engaged)
			src.disengage()
		else
			src.engage()

	attackby(var/obj/item/W)
		src.attack_hand()

	power_change()
		..()
		if(stat & NOPOWER)
			icon_state = "controller-p"
			if (istype(linked_computer))
				linked_computer.icon_state = "tele0"
				linked_computer.light.disable()
		else
			icon_state = "controller"

	proc/engage()
		if(stat & (BROKEN|NOPOWER))
			return
		if (find_links() < 2)
			src.visible_message("<b>[src]</b> intones, \"System error. Cannot find required equipment links.\"")
			return
		for (var/obj/machinery/teleport/portal_ring/R in linked_rings)
			R.icon_state = "tele1"
			R.light.enable()
		use_power(5000)
		src.visible_message("<b>[src]</b> intones, \"Teleporter engaged.\"")
		src.add_fingerprint(usr)
		src.engaged = 1
		return

	proc/disengage()
		if(stat & (BROKEN|NOPOWER))
			return
		if (find_links() < 2)
			src.visible_message("<b>[src]</b> intones, \"System error. Cannot find required equipment links.\"")
			return
		for (var/obj/machinery/teleport/portal_ring/R in linked_rings)
			R.icon_state = "tele0"
			R.light.disable()
		src.visible_message("<b>[src]</b> intones, \"Teleporter disengaged.\"")
		src.add_fingerprint(usr)
		src.engaged = 0
		return

	proc/find_links()
		linked_computer = null
		linked_rings = list()
		var/found = 0
		for(var/obj/machinery/computer/teleporter/T in orange(2,src))
			linked_computer = T
			T.linkedportalgen = src
			found++
			break
		for(var/obj/machinery/teleport/portal_ring/H in orange(2,src))
			linked_rings += H
		if (linked_rings.len > 0) found++
		return found

/proc/find_loc(obj/R as obj)
	if (!R)	return null
	var/turf/T = R.loc
	while(!istype(T, /turf))
		T = T.loc
		if(!T || istype(T, /area))	return null
	return T

/proc/do_teleport(atom/movable/M as mob|obj, atom/destination, precision, var/use_teleblocks = 1)
	if(istype(M, /obj/effects))
		qdel(M)
		return

	var/turf/destturf = get_turf(destination)
	if (!istype(destturf))
		return

	if (isrestrictedz(destturf.z))
		precision = 0

	var/tx = destturf.x + rand(precision * -1, precision)
	var/ty = destturf.y + rand(precision * -1, precision)

	var/turf/tmploc

	if (ismob(destination.loc)) //If this is an implant.
		tmploc = locate(tx, ty, destturf.z)
	else
		tmploc = locate(tx, ty, destination.z)

	if(tx == destturf.x && ty == destturf.y && (istype(destination.loc, /obj/storage/closet) || istype(destination.loc, /obj/storage/secure/closet)))
		tmploc = destination.loc

	if(tmploc==null)
		return

	var/m_blocked = 0
	for (var/obj/machinery/telejam/T in range(tmploc, 5))
		if (!T.active)
			continue
		var/r = get_dist(T, tmploc)
		if (r > T.range)
			continue
		m_blocked = 1
		break

	//if((istype(tmploc,/area/wizard_station)) || (istype(tmploc,/area/syndicate_station)))
	if ((istype(tmploc.loc, /area) && tmploc.loc:teleport_blocked) || m_blocked)
		var/restr = isrestrictedz(tmploc.z)
		if((!restr && use_teleblocks) || restr)
			if(istype(M,/mob/living))
				boutput(M, "<span style=\"color:red\"><b>Teleportation failed!</b></span>")
				return

	M.set_loc(tmploc)

	sleep(2)

	var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
	s.set_up(5, 1, M)
	s.start()
	return