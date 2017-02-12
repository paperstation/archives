/*
 * Pipefilter - Machine that filters a specific gas out of a pipe at given rate and passes the remainder along
 * 1 o2
 * 2 n2
 * 4 co2
 * 8 n2o
 * 16 plasma
 */


/obj/machinery/atmospherics/trinary/pipefilter
	name = "pipe filter"
	icon = 'icons/obj/atmospherics/filter.dmi'
	icon_state = "filter_b"
	desc = "A three-port gas filter."
	anchored = 1
	density = 0

	dir = SOUTH
	//req_access = list(access_atmospherics)
	//var
		//n1dir			// direction of node1
		//n2dir			// direction of node2
						// "dir" is the direction of node3
		//obj/substance/gas/gas = null		// the gas reservoir
		//oj/substance/gas/ngas = null

//		obj/machinery/node1 = null			// }
//		obj/machinery/node2 = null			// } the machine connected to each port
//		obj/machinery/node3 = null			// }
//		obj/machinery/vnode1				// }
//		obj/machinery/vnode2				// } the pipeline connected to each port, if nodeX is a pipe object
//		obj/machinery/vnode3				// }


	//	f_mask = 0
	//	f_per = 0
		//obj/substance/gas/f_gas = null
		//obj/substance/gas/f_ngas = null
	var/filtering = 0//bitflag
	var/target_pressure = ONE_ATMOSPHERE
	var/capacity = 6000000.0				// nominal gas capacity
	var/maxrate = 1000000.0
	var/locked = 1 							// controls no sprite but must be 0 if you want to bypass
	var/bypassed = 0 						// controls the bypass wire sprite (1 = bypassed)



	New()
		..()

/*
	buildnodes()
		var/turf/T = src.loc

		n1dir = turn(dir, 90)
		n2dir = turn(dir,-90)

		//node1 = get_machine( level, T , n1dir )	// the main flow dir
		//node2 = get_machine( level, T , n2dir )
		//node3 = get_machine( level, T, dir )	// the ejector port

		//if(node1) vnode1 = node1.getline()
		//if(node2) vnode2 = node2.getline()
		//if(node3) vnode3 = node3.getline()

	gas_flow()
		gas.replace_by(ngas)
		f_gas.replace_by(f_ngas)
*/

	process()//Filter process
		..()
		if(kill_air)//No atmos when air is off
			return 0
		if(stat & NOPOWER)
			return 0
//		if(!on)
//			return 0
/*
		//Checking the third pipe
		var/output_starting_pressure = air3.return_pressure()
		if(output_starting_pressure >= target_pressure)
			//No need to mix if target is already full!
			return 1

		//Calculate necessary moles to transfer using PV=nRT
		var/pressure_delta = target_pressure - output_starting_pressure
		var/transfer_moles

		if(air1.temperature > 0)
			transfer_moles = pressure_delta*air3.volume/(air1.temperature * R_IDEAL_GAS_EQUATION)

		//Actually transfer the gas

		if(transfer_moles > 0)
			var/datum/gas_mixture/removed = air1.remove(transfer_moles)

			if(!removed)
				return
			var/datum/gas_mixture/filtered_out = new
			filtered_out.temperature = removed.temperature

			if(filtering & 1)//o2
				filtered_out.toxins = removed.toxins
				removed.toxins = 0

				if(removed.trace_gases.len>0)
				for(var/datum/gas/trace_gas in removed.trace_gases)
					if(istype(trace_gas, /datum/gas/oxygen_agent_b))
						removed.trace_gases -= trace_gas
						filtered_out.trace_gases += trace_gas

			if(filtering & 2)//n2

			if(filtering & 4)//co2

			if(filtering & 8)//n2o

			if(filtering & 16)//plasma



			switch(filtering)
				if(0) //removing hydrocarbons
					filtered_out.toxins = removed.toxins
					removed.toxins = 0

					if(removed.trace_gases.len>0)
						for(var/datum/gas/trace_gas in removed.trace_gases)
							if(istype(trace_gas, /datum/gas/oxygen_agent_b))
								removed.trace_gases -= trace_gas
								filtered_out.trace_gases += trace_gas

				if(1) //removing O2
					filtered_out.oxygen = removed.oxygen
					removed.oxygen = 0

				if(2) //removing N2
					filtered_out.nitrogen = removed.nitrogen
					removed.nitrogen = 0

				if(3) //removing CO2
					filtered_out.carbon_dioxide = removed.carbon_dioxide
					removed.carbon_dioxide = 0

				if(4)//removing N2O
					if(removed.trace_gases.len>0)
						for(var/datum/gas/trace_gas in removed.trace_gases)
							if(istype(trace_gas, /datum/gas/sleeping_agent))
								removed.trace_gases -= trace_gas
								filtered_out.trace_gases += trace_gas

				else
					filtered_out = null


			air2.merge(filtered_out)
			air3.merge(removed)

		if(network2)
			network2.update = 1

		if(network3)
			network3.update = 1

		if(network1)
			network1.update = 1

		return 1*/

/*
	process()
		if(kill_air)//No atmos when air is off
				return 0
		var/delta_gt

		if(vnode1)
			delta_gt = FLOWFRAC * ( vnode1.get_gas_val(src) - gas.tot_gas() / capmult)
			calc_delta( src, gas, ngas, vnode1, delta_gt)
		else
			leak_to_turf(1)
		if(vnode2)
			delta_gt = FLOWFRAC * ( vnode2.get_gas_val(src) - gas.tot_gas() / capmult)
			calc_delta( src, gas, ngas, vnode2, delta_gt)
		else
			leak_to_turf(2)
		if(vnode3)
			delta_gt = FLOWFRAC * ( vnode3.get_gas_val(src) - f_gas.tot_gas() / capmult)
			calc_delta( src, f_gas, f_ngas, vnode3, delta_gt)
		else
			leak_to_turf(3)

		// transfer gas from ngas->f_ngas according to extraction rate, but only if we have power
		if(! (stat & NOPOWER) )
			use_power(min(src.f_per, 100),ENVIRON)
			var/obj/substance/gas/ndelta = src.get_extract()
			ngas.sub_delta(ndelta)
			f_ngas.add_delta(ndelta)
		AutoUpdateAI(src)
		src.updateUsrDialog()

	get_gas_val(from)
		return ((from == vnode3) ? f_gas.tot_gas() : gas.tot_gas())/capmult

	get_gas(from)
		return (from == vnode3) ? f_gas : gas

	proc/leak_to_turf(var/port)
		var/turf/T

		switch(port)
			if(1)
				T = get_step(src, n1dir)
			if(2)
				T = get_step(src, n2dir)
			if(3)
				T = get_step(src, dir)
				if(T.density)
					T = src.loc
					if(T.density)
						return
				flow_to_turf(f_gas, f_ngas, T)
				return

		if(T.density)
			T = src.loc
			if(T.density)
				return

		flow_to_turf(gas, ngas, T)

	proc/get_extract()
		var/obj/substance/gas/ndelta = new()
		if (src.f_mask & GAS_O2)
			ndelta.oxygen = min(src.f_per, src.ngas.oxygen)
		if (src.f_mask & GAS_N2)
			ndelta.n2 = min(src.f_per, src.ngas.n2)
		if (src.f_mask & GAS_PL)
			ndelta.plasma = min(src.f_per, src.ngas.plasma)
		if (src.f_mask & GAS_CO2)
			ndelta.co2 = min(src.f_per, src.ngas.co2)
		if (src.f_mask & GAS_N2O)
			ndelta.sl_gas = min(src.f_per, src.ngas.sl_gas)
		return ndelta
*/
	attackby(obj/item/weapon/W, mob/user as mob)
		if(istype(W, /obj/item/device/detective_scanner))
			return ..()
		if(istype(W, /obj/item/weapon/screwdriver))
			if(bypassed)
				user.show_message(text("\red Remove the foreign wires first!"), 1)
				return
			src.add_fingerprint(user)
			user.show_message(text("\blue Now []securing the access system panel...", (src.locked) ? "un" : "re"), 1)
			if(do_after(user, 30))
				locked =! locked
				user.show_message(text("\blue Done!"),1)
				update_icon()
			return
		if(istype(W, /obj/item/weapon/cable_coil) && !bypassed)
			if(src.locked)
				user.show_message(text("\red You must remove the panel first!"),1)
				return
			var/obj/item/weapon/cable_coil/C = W
			if(!C.use(4))
				user.show_message(text("\red Not enough cable! <I>(Requires four pieces)</I>"),1)
				return
			user.show_message(text("\blue You unravel some cable.."),1)
			src.add_fingerprint(user)
			user.show_message(text("\blue Now bypassing the access system... <I>(This may take a while)</I>"), 1)
			if(do_after(user, 100))
				user.show_message(text("\blue You bypass the access system!"), 1)
				bypassed = 1
				update_icon()
			return
		if(istype(W, /obj/item/weapon/wirecutters) && bypassed)
			src.add_fingerprint(user)
			user.show_message(text("\blue Now removing the bypass wires... <I>(This may take a while)</I>"), 1)
			if(do_after(user, 50))
				user.show_message(text("\blue You remove the bypass wires!"), 1)
				bypassed = 0
				update_icon()
				return
		if(istype(W, /obj/item/weapon/card/emag) && (!emagged))
			emagged++
			src.add_fingerprint(user)
			for(var/mob/O in viewers(user, null))
				O.show_message("\red [user] has shorted out the [src] with \an [W]!", 1)
			src.overlays += "filter-spark"
			sleep(6)
			update_icon()
			return src.attack_hand(user)
		return src.attack_hand(user)

// pipefilter interact/topic
	attack_paw(mob/user as mob)
		return src.attack_hand(user)

	attack_ai(mob/user as mob)
		return src.attack_hand(user)

	attack_hand(mob/user as mob)
		if(stat & NOPOWER)
			user << browse(null, "window=pipefilter")
			user.machine = null
			return
/*
		var/list/gases = list("O2", "N2", "Plasma", "CO2", "N2O")
		user.machine = src
		var/dat = "Filter Release Rate:<BR>\n<A href='?src=\ref[src];fp=-[num2text(src.maxrate, 9)]'>M</A> <A href='?src=\ref[src];fp=-100000'>-</A> <A href='?src=\ref[src];fp=-10000'>-</A> <A href='?src=\ref[src];fp=-1000'>-</A> <A href='?src=\ref[src];fp=-100'>-</A> <A href='?src=\ref[src];fp=-1'>-</A> [src.f_per] <A href='?src=\ref[src];fp=1'>+</A> <A href='?src=\ref[src];fp=100'>+</A> <A href='?src=\ref[src];fp=1000'>+</A> <A href='?src=\ref[src];fp=10000'>+</A> <A href='?src=\ref[src];fp=100000'>+</A> <A href='?src=\ref[src];fp=[num2text(src.maxrate, 9)]'>M</A><BR>\n"
		for (var/i = 1; i <= gases.len; i++)
			dat += "[gases[i]]: <A HREF='?src=\ref[src];tg=[1 << (i - 1)]'>[(src.filtering & 1 << (i - 1)) ? "Releasing" : "Passing"]</A><BR>\n"
		if(gas.tot_gas())
			var/totalgas = gas.tot_gas()
			var/pressure = round(totalgas / gas.maximum * 100)
			var/nitrogen = gas.n2 / totalgas * 100
			var/oxygen = gas.oxygen / totalgas * 100
			var/plasma = gas.plasma / totalgas * 100
			var/co2 = gas.co2 / totalgas * 100
			var/no2 = gas.sl_gas / totalgas * 100

			dat += "<BR>Gas Levels: <BR>\nPressure: [pressure]%<BR>\nNitrogen: [nitrogen]%<BR>\nOxygen: [oxygen]%<BR>\nPlasma: [plasma]%<BR>\nCO2: [co2]%<BR>\nN2O: [no2]%<BR>\n"
		else
			dat += "<BR>Gas Levels: <BR>\nPressure: 0%<BR>\nNitrogen: 0%<BR>\nOxygen: 0%<BR>\nPlasma: 0%<BR>\nCO2: 0%<BR>\nN2O: 0%<BR>\n"
		dat += "<BR>\n<A href='?src=\ref[src];close=1'>Close</A><BR>\n"

		user << browse(dat, "window=pipefilter;size=300x365")

	Topic(href, href_list)
		..()
		if(usr.restrained() || usr.lying)
			return
		if (((in_range(src, usr) || istype(usr, /mob/living/silicon)) && istype(src.loc, /turf)))
			usr.machine = src
			if (href_list["close"])
				usr << browse(null, "window=pipefilter;")
				usr.machine = null
				return
			if (src.allowed(usr) || src.emagged || src.bypassed)
				if (href_list["fp"])
					src.f_per = min(max(round(src.f_per + text2num(href_list["fp"])), 0), src.maxrate)
				else if (href_list["tg"])
					// toggle gas
					src.f_mask ^= text2num(href_list["tg"])
					update_icon()
			else
				usr.see("\red Access Denied ([src.name] operation restricted to authorized atmospheric technicians.)")
			AutoUpdateAI(src)
			src.updateUsrDialog()
			src.add_fingerprint(usr)
		else
			usr << browse(null, "window=pipefilter")
			usr.machine = null
		return*/

	power_change()
		if(powered(ENVIRON))
			stat &= ~NOPOWER
		else
			stat |= NOPOWER
		spawn(rand(1,15))	//so all the filters don't come on at once
			update_icon()

	update_icon()
		src.overlays = null
		if(stat & NOPOWER)
			icon_state = "filter-off"
		else
			icon_state = "filter"
			if(emagged)	//only show if powered because presumeably its the interface that has been fried
				src.overlays += "filter-emag"
			/*if (src.f_mask & (GAS_N2O|GAS_PL))
				src.overlays += image('pipes2.dmi', "filter-tox")
			if (src.f_mask & GAS_O2)
				src.overlays += image('pipes2.dmi', "filter-o2")
			if (src.f_mask & GAS_N2)
				src.overlays += image('pipes2.dmi', "filter-n2")
			if (src.f_mask & GAS_CO2)
				src.overlays += image('pipes2.dmi', "filter-co2")
		if(!locked)
			src.overlays += image('pipes2.dmi', "filter-open")
			if(bypassed)	//should only be bypassed if unlocked
				src.overlays += image('pipes2.dmi', "filter-bypass")*/
		return