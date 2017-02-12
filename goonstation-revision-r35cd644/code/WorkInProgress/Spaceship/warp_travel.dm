///Warp Beacons and Wormholes
///Used by spaceships to travel to other Z-planes
/obj/warp_beacon
	name = "warp beacon"
	desc = "Part of an elaborate small-ship teleportation network recently deployed by Nanotrasen.  Probably won't cause you to die."
	icon = 'icons/obj/ship.dmi'
	icon_state = "beacon"
	anchored = 1
	density = 1

	// Please keep synchronizied with these lists for easy map changes:
	// /obj/machinery/door_control (door_control.dm)
	// /obj/machinery/r_door_control (door_control.dm)
	// /obj/machinery/door/poddoor/pyro (poddoor.dm)
	// /obj/machinery/door/poddoor/blast/pyro (poddoor.dm)
	// We don't need a complete copy of all hangars, though.
	// A limited-but-logical selection of beacon will suffice.
	catering
		name = "catering hangar beacon"
	arrivals
		name = "arrivals hangar beacon"
	escape
		name = "escape hangar beacon"
	mainpod1
		name = "main hangar beacon (#1)"
	mainpod2
		name = "main hangar beacon (#2)"
	engineering
		name = "engineering hangar beacon"
	security
		name = "security hangar beacon"
	medsci
		name = "medsci hangar beacon"
	research
		name = "research hangar beacon"
	medbay
		name = "medbay hangar beacon"
	qm
		name = "QM hangar beacon"
	mining
		name = "mining hangar beacon"
	miningoutpost
		name = "mining outpost beacon"
	diner
		name = "space diner beacon"
	faint
		name = "faint signal"

/obj/warp_portal
	name = "particularly buff portal"
	icon ='icons/obj/objects.dmi'
	icon_state = "fatportal"
	density = 0
	var/obj/target = null
	anchored = 1.0


/obj/warp_portal/Bumped(mob/M as mob|obj)
	spawn(0)
		src.teleport(M)
		return
	return

/obj/warp_portal/HasEntered(AM as mob|obj)
	spawn(0)
		src.teleport(AM)
		return
	return

/obj/warp_portal/New()
	spawn(300)
		qdel(src)
		return
	return

/obj/warp_portal/proc/teleport(atom/movable/M as mob|obj)
	if(istype(M, /obj/effects)) //sparks don't teleport
		return
	if (M.anchored && (!istype(M,/obj/machinery/vehicle)))
		return
	if (!( src.target ))
		qdel(src)
		return
	if (istype(M, /mob))
		var/mob/T = M
		boutput(T, "<span style=\"color:red\">You are exposed to some pretty swole strange particles, this can't be good...</span>")
		if(prob(10))
			T.gib()
			T.unlock_medal("Where we're going, we won't need eyes to see", 1)
			return
		else
			T.irradiate(rand(5,25))
			if(istype(T, /mob/living/carbon/human/))
				var/mob/living/carbon/human/H = T
				if (prob(75))
					H:bioHolder:RandomEffect("bad")
				else
					H:bioHolder:RandomEffect("good")
	if (istype(M, /atom/movable))
		do_teleport(M, src.target, 1) ///You will appear adjacent to the beacon


