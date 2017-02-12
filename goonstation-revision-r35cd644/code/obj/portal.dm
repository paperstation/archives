/obj/portal
	name = "portal"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "portal"
	density = 1
	var/failchance = 5
	var/obj/item/target = null
	anchored = 1.0
	var/portal_lums = 2
	var/datum/light/light

/obj/portal/New()
	..()
	light = new /datum/light/point
	light.set_color(0.1, 0.1, 0.9)
	light.set_brightness(portal_lums / 6)
	light.attach(src)
	light.enable()

/obj/portal/Bumped(mob/M as mob|obj)
	spawn(0)
		src.teleport(M)
		return
	return

/obj/portal/HasEntered(AM as mob|obj)
	spawn(0)
		src.teleport(AM)
		return
	return

/obj/portal/disposing()
	target = null
	..()

/obj/portal/pooled(var/poolname)
	..()
	name = initial(name)
	icon = initial(icon)
	icon_state = initial(icon_state)
	density = initial(density)
	failchance = initial(failchance)
	anchored = initial(anchored)

/obj/portal/unpooled(var/poolname)
	portal_lums = initial(portal_lums)
	light.set_brightness(portal_lums / 3)
	light.enable()
	..()

/obj/portal/proc/teleport(atom/movable/M as mob|obj)
	if( istype(M, /obj/effects)) //sparks don't teleport
		return
	if (M.anchored)
		return
	if (src.icon_state == "portal1")
		return
	if (!src.target)
		return
	if (istype(M, /atom/movable))
		if (prob(failchance)) //oh dear a problem, put em in deep space
			src.icon_state = "portal1"
			do_teleport(M, locate(rand(5, world.maxx - 5), rand(5, world.maxy -5), 3), 0)
		else
			if (!isturf(target))
				var/turf/destination = find_loc(src.target) // Beacons and tracking implant might have been moved.
				if (destination)
					do_teleport(M, destination, 1)
				else return
			else
				do_teleport(M, src.target, 1) ///You will appear adjacent to the beacon

/obj/portal/wormhole
	name = "wormhole"
	desc = "Some sort of weird fold in space. It presumably leads somewhere."
	icon = 'icons/obj/objects.dmi'
	icon_state = "anom"
	density = 1
	failchance = 0