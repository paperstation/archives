/obj/effect/portal
	name = "portal"
	desc = "Looks unstable."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "portal"
	density = 1
	unacidable = 1//Can't destroy energy portals.
	var/failchance = 5
	var/obj/item/target = null
	var/creator = null
	anchored = 1.0

/obj/effect/portal/Bumped(mob/M as mob|obj)
	if(istype(M, /mob/living/simple_animal/starship))
		var/mob/living/simple_animal/starship/C = M
		C.health = 0
	spawn(0)
		src.teleport(M)
		return
	return

/obj/effect/portal/HasEntered(AM as mob|obj)
	spawn(0)
		src.teleport(AM)
		return
	return

/obj/effect/portal/New()
	spawn(300)
		del(src)
		return
	return
/var/global/failed_tele = 0
/obj/effect/portal/proc/teleport(atom/movable/M as mob|obj)
	if(istype(M, /obj/effect)) //sparks don't teleport
		return
	if (M.anchored&&istype(M, /obj/mecha))
		return
	if (icon_state == "portal1")
		return
	if (!( target ))
		del(src)
		return
	if (istype(M, /atom/movable))
		if(prob(failchance)) //oh dear a problem, put em in deep space
			src.icon_state = "portal1"
			do_teleport(M, locate(rand(5, world.maxx - 5), rand(5, world.maxy -5), 3), 0)
			failed_tele +=1
		else
			do_teleport(M, target, 1) ///You will appear adjacent to the beacon


