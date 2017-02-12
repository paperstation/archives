//More old code, as with scrap should likely be looked over.  Also for this one it should be less op and not gib the fuck out of everything that touches it right away

/obj/machinery/crusher
	name = "Crusher Unit"
	desc = "Breaks things down into metal/glass/waste"
	density = 1
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "furnace"
	layer = MOB_LAYER + 1
	anchored = 1.0
	use_power = USE_POWER_ACTIVE
	idle_power_usage = 100
	active_power_usage = 500
	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null
	New()
		..()
		spawn( 5 )
			for (var/dir in cardinal)
				src.input = locate(/obj/machinery/mineral/input, get_step(src, dir))
				if(src.input) break
			for (var/dir in cardinal)
				src.output = locate(/obj/machinery/mineral/output, get_step(src, dir))
				if(src.output) break
			//processing_objects.Add(src)
			return
		return

	Bumped(atom/AM)
		var/tm_amt = 0
		var/tg_amt = 0//Oh god the var names
		var/tw_amt = 0
		var/bblood = 0

		if(istype(AM,/obj/item/scrap))
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
		else
			return
		for(var/mob/M in oviewers())
			if(M.client)
				M << "\red You hear a ginding sound!"
		var/obj/item/scrap/S = new(get_turf(src))
		S.blood = bblood
		S.set_components(tm_amt,tg_amt,tw_amt)
		S.loc = output.loc
		del(AM)
	//		step(S,2)
		return


	process()
		if(stat & (NOPOWER|BROKEN))	return
		use_power(500)





//Filters waste away from the normal scrap, if on
/obj/machinery/fabricator
	name = "Waste Relay Unit"
	desc = "Relays waste to its destination."
	density = 1
	icon = 'icons/obj/scrap.dmi'
	icon_state = "Crusher_1"
	layer = MOB_LAYER + 1
	anchored = 1.0
	use_power = USE_POWER_ACTIVE
	idle_power_usage = 100
	active_power_usage = 500
	var/on = 1
	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null

	New()
		..()
		spawn( 5 )
			for (var/dir in cardinal)
				src.input = locate(/obj/machinery/mineral/input, get_step(src, dir))
				if(src.input) break
			for (var/dir in cardinal)
				src.output = locate(/obj/machinery/mineral/output, get_step(src, dir))
				if(src.output) break
			//processing_objects.Add(src)
			return
		return

	Bumped(atom/AM)

		if(istype(AM,/obj/item/scrap))
			if(on)
				var/obj/item/scrap/C = AM
				var/obj/item/scrap/Z = new/obj/item/scrap
				var/obj/item/scrap/X = new/obj/item/scrap
				X.m_amt += C.m_amt
				X.g_amt += C.g_amt
				Z.w_amt += C.w_amt
				X.loc = input.loc
				Z.loc = output.loc
				del(AM)
				return
			else
				return


	process()
		if(stat & (NOPOWER|BROKEN))	return
		use_power(500)














/**********************Gas extractor**************************/

/obj/structure/statue/gasextractor//dummy version so I can update the map
	name = "Gas extractor"
	desc = "A machine which extracts gasses from scraps. It doesn't look like CentComm installed it yet."
	icon ='icons/vehicles/starship.dmi'
	icon_state="generator"


/obj/machinery/mineral/gasextractor
	name = "Gas extractor"
	desc = "A machine which extracts gasses from ores."
	icon ='icons/vehicles/starship.dmi'
	icon_state="generator"
	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null
	var/message = "";
	var/processing = 0
	var/newtoxins = 0
	density = 1
	anchored = 1.0

	New()
		processing_objects.Add(src)
		world << "added to list"
		..()
		spawn( 5 )
			for (var/dir in cardinal)
				src.input = locate(/obj/machinery/mineral/input, get_step(src, dir))
				if(src.input) break
			for (var/dir in cardinal)
				src.output = locate(/obj/machinery/mineral/output, get_step(src, dir))
				if(src.output) break
			return
		return

/obj/machinery/mineral/gasextractor/process(temperature)
	if(stat & (NOPOWER|BROKEN))	return
	use_power(500)
	world << "using power"
	for(var/obj/item/stack/sheet/mineral/plasma/T in range(src, 1))
		world << "Looking for sheets"
		if (src.output)
			for(var/turf/simulated/floor/target_tile in range(1,output))
				world << "gas"
				var/datum/gas_mixture/napalm = new
				napalm.toxins = 100
				napalm.temperature = 600+T0C
				target_tile.assume_air(napalm)
		//		spawn (0) target_tile.hotspot_expose(700,125)
				del(T)


/*
					var/obj/machinery/portable_atmospherics/canister/C
					C = locate(/obj/machinery/portable_atmospherics/canister,output.loc)
					var/datum/gas/oxygen_agent_b/trace_gas = new
					C.air_contents.trace_gases += trace_gas
					trace_gas.moles = (C.maximum_pressure*1)*C.air_contents.volume/(R_IDEAL_GAS_EQUATION*C.air_contents.temperature)
					del(AM)*/




		/*

/obj/machinery/mineral/controlpanel
	name = "Control Panel"
	desc = "A machine which controls the paths"
	icon = 'icons/obj/computer.dmi'
	icon_state = "aiupload"
	var/obj/machinery/mineral/gasextractor/Z = null
	var/obj/machinery/mineral/output = null
	var/processed = 0
	var/processing = 0
	density = 1
	anchored = 1.0
	var/w2s = 0
/obj/machinery/mineral/controlpanel/attack_hand(user as mob)
	var/dat
	dat = text("input connection status: ")
	if(!w2s)
		dat += "<br><A href='byond://?src=\ref[src];op=w2soff'>Turn Waste to Scrap on</A><BR>"
	else
		dat += "<br><A href='byond://?src=\ref[src];op=w2son'>Turn Waste to Scrap ooff</A><BR>"
/obj/machinery/mineral/controlpanel/Topic(href, href_list)
	if(..())
		return
	usr.machine = src
	src.add_fingerprint(usr)
	if(href_list["op"])
		if ("stats")
			w2s = 1
	src.updateUsrDialog()
	return


/obj/machinery/mineral/controlpanel/New()
	..()
	spawn( 5 )
		for (var/dir in src.area)
			src.input = locate(/obj/machinery/mineral/gasextractor, get_step(src, dir))
			if(src.input) break
		for (var/dir in area)
			src.output = locate(/obj/machinery/mineral/output, get_step(src, dir))
			if(src.output) break
		return
	return*/