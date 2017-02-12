/obj/rack
	name = "rack"
	icon = 'icons/obj/objects.dmi'
	icon_state = "rack"
	density = 1
	flags = FPRINT | NOSPLASH
	anchored = 1.0
	desc = "A metal frame used to hold objects. Can be wrenched and made portable."

/obj/rack/New()
	..()
	var/bonus = 0
	for (var/obj/O in loc)
		if (istype(O, /obj/item))
			bonus += 4
		if (istype(O, /obj/table))
			return
		if (istype(O, /obj/rack) && O != src)
			return
	var/area/Ar = get_area(src)
	if (Ar)
		Ar.sims_score = min(Ar.sims_score + bonus, 100)

/obj/rack/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
		if(3.0)
			if (prob(25))
				src.icon_state = "rackbroken"
				src.density = 0
		else
	return

/obj/rack/blob_act(var/power)
	if(prob(power * 2.5))
		qdel(src)
		return
	else if(prob(power * 2.5))
		src.icon_state = "rackbroken"
		src.density = 0
		return

/obj/rack/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1

	if (mover.flags & TABLEPASS)
		return 1
	else
		return 0

/obj/rack/MouseDrop_T(obj/O as obj, mob/user as mob)
	if ((!( istype(O, /obj/item) ) || user.equipped() != O))
		return
	user.drop_item()
	if (O.loc != src.loc)
		step(O, get_dir(O, src))
	return

/obj/rack/dispose()
	var/turf/OL = get_turf(src)
	loc = null
	if (!OL)
		return
	if (!(locate(/obj/table) in OL) && !(locate(/obj/rack) in OL))
		var/area/Ar = OL.loc
		for (var/obj/item/I in OL)
			Ar.sims_score -= 4
		Ar.sims_score = max(Ar.sims_score, 0)
	..()

/obj/rack/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/wrench))
		var/atom/A = new /obj/item/rack_parts( src.loc )
		if(src.material) A.setMaterial(src.material)
		playsound(src.loc, "sound/items/Ratchet.ogg", 50, 1)

		//SN src = null
		qdel(src)
		return
	if (issilicon(user)) return
	user.drop_item()
	if(W && W.loc)	W.set_loc(src.loc)
	return

/obj/rack/meteorhit(obj/O as obj)
	if(prob(75))
		qdel(src)
		return
	else
		src.icon_state = "rackbroken"
		src.density = 0
	return