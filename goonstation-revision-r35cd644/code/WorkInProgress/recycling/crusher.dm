/obj/machinery/crusher
	name = "Crusher Unit"
	desc = "Breaks things down into metal/glass/waste"
	density = 1
	icon = 'icons/obj/scrap.dmi'
	icon_state = "Crusher_1"
	layer = MOB_LAYER + 1
	anchored = 1.0
	mats = 20
	is_syndicate = 1
	var/active = 0

/obj/machinery/crusher/Bumped(atom/AM)
	var/tm_amt = 0
	var/tg_amt = 0
	var/tw_amt = 0
	var/bblood = 0

	if(istype(AM,/obj/item/scrap))
		return

	if(world.timeofday - AM.last_bumped <= 60)
		return

	if(ismob(AM))
		var/mob/M = AM
		for(var/obj/O in M.contents)
			if(isobj(O))
				tm_amt += O.m_amt
				tg_amt += O.g_amt
				tw_amt += O.w_amt
				if(iscarbon(M))
					tw_amt += 5000
					bblood = 2
				else if(issilicon(M))
					tm_amt += 5000
					tg_amt += 1000
			qdel(O)
		logTheThing("combat", M, null, "is ground up in a crusher at [log_loc(src)].")
		M.gib()
	else if(isobj(AM))
		var/obj/B = AM
		tm_amt += B.m_amt
		tg_amt += B.g_amt
		tw_amt += B.w_amt
		for(var/obj/O in AM.contents)
			if(isobj(O))
				tm_amt += O.m_amt
				tg_amt += O.g_amt
				tw_amt += O.w_amt
			qdel(O)
	else
		return
	for(var/mob/M in oviewers())
		if(M.client)
			boutput(M, "<span style=\"color:red\">You hear a grinding sound!</span>")
	var/obj/item/scrap/S = new(get_turf(src))
	S.blood = bblood
	S.set_components(tm_amt,tg_amt,tw_amt)
	qdel(AM)
//		step(S,2)
	return



/obj/machinery/crusher/process()
	..()
	if(stat & (NOPOWER|BROKEN))	return
	use_power(500)
