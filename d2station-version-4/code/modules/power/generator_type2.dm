/obj/machinery/power/generator_type2/New()
	..()

	spawn(5)
		input1 = locate(/obj/machinery/atmospherics/unary/generator_input) in get_step(src,WEST)
		input2 = locate(/obj/machinery/atmospherics/unary/generator_input) in get_step(src,EAST)
		if(!input1 || !input2)
			stat |= BROKEN

		updateicon()

/obj/machinery/power/generator_type2/proc/updateicon()

	if(stat & (NOPOWER|BROKEN))
		overlays = null
	else
		overlays = null

		if(lastgenlev != 0)
			overlays += image('power.dmi', "teg-ef[lastgenlev]")

#define GENRATE 1500	// generator output coefficient from Q

/obj/machinery/power/generator_type2/process()

	if(!input1 || !input2)
		return

	var/datum/gas_mixture/air1 = input1.return_exchange_air()
	var/datum/gas_mixture/air2 = input2.return_exchange_air()
	if(i < 4)
		i++
	else
		i = 1
	lastgen = 0
	average = (lastgenaverage1 + lastgenaverage2 + lastgenaverage3) / 3

	if(air1 && air2)
		var/datum/gas_mixture/hot_air = air1
		var/datum/gas_mixture/cold_air = air2

		if(hot_air.temperature > 2870+T0C) //Tungsten Carbine. Get at me. 500C Default on an engine?? YEAH THATS A GREAT IDEA. - Nernums
			det++
			if(det > explosiondet)
				//proc/explosion(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, force = 0)
				explosion(src.loc,2,3,6,11,1)
				det = 0
				del(src)
				return
			if(det > 800)
				if(prob(10))
					det++
					radioalert("TURBINE CONTAINMENT HAS FAILED - TURBINE EXPLOSION IMMINENT","Core control computer")
			else if(det >= previousdet)   // The damage is still going up
				if(hot_air.temperature > 5000+T0C)
					radioalert("TURBINE OVERLOAD - Turbine temperature is hotter than the surface of the sun.","Core control computer")
				else if(prob(1))
					radioalert("TURBINE OVERLOAD - Turbine temperature reaching [hot_air.temperature+T0C]*C.","Core control computer")

		if(input2.air_contents.return_pressure() > 250000 || input1.air_contents.return_pressure() > 250000)
			radioalert("TURBINE CONTAINMENT HAS FAILED - PRESSURE OUTSIDE TOLERANCE","Core control computer")
			explosion(src.loc,0,3,4,5,1)
			det = 0
			del(src)
			return

		if(hot_air.temperature < cold_air.temperature)
			hot_air = air2
			cold_air = air1
		else
			hot_air = air1
			cold_air = air2

		var/hot_air_heat_capacity = hot_air.heat_capacity()
		var/cold_air_heat_capacity = cold_air.heat_capacity()

		var/delta_temperature = hot_air.temperature - cold_air.temperature

		if(delta_temperature > 1 && cold_air_heat_capacity > 0.01 && hot_air_heat_capacity > 0.01)
			var/efficiency = 1 - (cold_air.temperature/hot_air.temperature)//65% of Carnot efficiency

			var/energy_transfer = (1+delta_temperature)*hot_air_heat_capacity*cold_air_heat_capacity/(hot_air_heat_capacity+cold_air_heat_capacity)

			var/heat = energy_transfer*(1-efficiency)
			lastgen = energy_transfer*efficiency

			hot_air.temperature = hot_air.temperature - (energy_transfer/hot_air_heat_capacity / 2)
			cold_air.temperature = cold_air.temperature + (heat/cold_air_heat_capacity / 2)

			//world << "POWER: [lastgen] W generated at [efficiency*100]% efficiency and sinks sizes [cold_air_heat_capacity], [hot_air_heat_capacity]"

			if(input1.network)
				input1.network.update = 1

			if(input2.network)
				input2.network.update = 1

			add_avail(lastgen)

	// update icon overlays only if displayed level has changed

	var/genlev = max(0, min( round(4 * average / 65000), 4))
	if(genlev != lastgenlev)
		lastgenlev = genlev
		updateicon()
	if(i == 1 || i == 0)
		lastgenaverage1 = lastgen
	if(i == 2)
		lastgenaverage2 = lastgen
	if(i == 3)
		lastgenaverage3 = lastgen
	src.updateDialog()

/obj/machinery/power/generator_type2/attack_ai(mob/user)
	if(stat & (BROKEN|NOPOWER)) return

	interact(user)

/obj/machinery/power/generator_type2/attack_hand(mob/user)

	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER)) return

	interact(user)

/obj/machinery/power/generator_type2/proc/interact(mob/user)
	if ( (get_dist(src, user) > 1 ) && (!istype(user, /mob/living/silicon/ai)))
		user.machine = null
		user << browse(null, "window=teg")
		return

	user.machine = src


	var/t = "<PRE><B>Thermo-Electric Generator</B><HR>"
	if(average < 1000000)
		t += "Output : [round(average)] W<BR><BR>"
	else
		t += "Output : [round(average / 1000)] KW<BR><BR>"
	t += "<B>Cold loop</B><BR>"
	t += "Temperature: [round(input1.air_contents.temperature, 0.1) - T0C] C<BR>"
	t += "Pressure: [round(input1.air_contents.return_pressure(), 0.1)] kPa<BR>"

	t += "<B>Hot loop</B><BR>"
	t += "Temperature: [round(input2.air_contents.temperature, 0.1) - T0C] C<BR>"
	t += "Pressure: [round(input2.air_contents.return_pressure(), 0.1)] kPa<BR>"

	t += "<BR><HR><A href='?src=\ref[src];close=1'>Close</A>"

	t += "</PRE>"
	user << browse(t, "window=teg;size=460x300")
	onclose(user, "teg")
	return 1

/obj/machinery/power/generator_type2/Topic(href, href_list)
	..()

	if( href_list["close"] )
		usr << browse(null, "window=teg")
		usr.machine = null
		return 0

	return 1

/obj/machinery/power/generator_type2/power_change()
	..()
	updateicon()