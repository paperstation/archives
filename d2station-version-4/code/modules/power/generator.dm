// dummy generator object for testing

/*/obj/machinery/power/generator/verb/set_amount(var/g as num)
	set src in view(1)

	gen_amount = g

*/

/obj/machinery/power/generator/New()
	..()

	spawn(5)
		circ1 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src,WEST)
		circ2 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src,EAST)
		if(!circ1 || !circ2)
			stat |= BROKEN

		updateicon()

/obj/machinery/power/generator/proc/updateicon()

	if(stat & (NOPOWER|BROKEN))
		overlays = null
	else
		overlays = null

		if(lastgenlev != 0)
			overlays += image('power.dmi', "teg-op[lastgenlev]")

#define GENRATE 80000		// generator output coefficient from Q

/obj/machinery/power/generator/process()

	if(!circ1 || !circ2)
		return

	var/datum/gas_mixture/hot_air_in = circ1.air1
	var/datum/gas_mixture/cold_air_in = circ2.air1
	var/datum/gas_mixture/hot_air_out = circ1.air2
	var/datum/gas_mixture/cold_air_out = circ2.air2

	lastgen = 0


	if(hot_air_in && hot_air_out && cold_air_in && cold_air_out)
		var/cold_air_heat_capacity = (cold_air_in.heat_capacity() + cold_air_out.heat_capacity()) / 2
		var/hot_air_heat_capacity = (hot_air_in.heat_capacity() + hot_air_out.heat_capacity()) / 2
		var/cold_air_temperature = (cold_air_in.temperature + cold_air_out.temperature) / 2
		var/hot_air_temperature = (hot_air_in.temperature + hot_air_out.temperature) / 2
		var/delta_temperature = (hot_air_in.temperature + hot_air_out.temperature) - (cold_air_in.temperature + cold_air_out.temperature)

		if(delta_temperature > 0 && cold_air_heat_capacity > 0 && hot_air_heat_capacity > 0)
			var/efficiency = (1 - cold_air_temperature/hot_air_temperature)*0.05 //65% of Carnot efficiency

			var/energy_transfer = delta_temperature*hot_air_heat_capacity*cold_air_heat_capacity/(hot_air_heat_capacity+cold_air_heat_capacity)

			var/heat = energy_transfer*(1-efficiency)
			lastgen = energy_transfer*efficiency

			hot_air_temperature = hot_air_temperature - energy_transfer/hot_air_heat_capacity
			cold_air_temperature = cold_air_temperature + heat/cold_air_heat_capacity


		//	world << "POWER: [lastgen] W generated at [efficiency*100]% efficiency and sinks sizes [cold_air_heat_capacity], [hot_air_heat_capacity]"

			add_avail(lastgen)
	// update icon overlays only if displayed level has changed

/*	if(hot_air_in)
		circ1.air2.merge(hot_air_in)

	if(cold_air_in)
		circ2.air2.merge(cold_air_in)
*/
	var/genlev = max(0, min( round(11*lastgen / 100000), 11))
	if(genlev != lastgenlev)
		lastgenlev = genlev
		updateicon()

	src.updateDialog()

/obj/machinery/power/generator/attack_ai(mob/user)
	if(stat & (BROKEN|NOPOWER)) return

	interact(user)

/obj/machinery/power/generator/attack_hand(mob/user)

	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER))
		world << "returns as broken"
		return

	interact(user)

/obj/machinery/power/generator/proc/interact(mob/user)
	if ( (get_dist(src, user) > 1 ) && (!istype(user, /mob/living/silicon/ai)))
		user.machine = null
		user << browse(null, "window=teg")
		return

	user.machine = src

	var/t = "<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><PRE><B>Thermo-Electric Generator</B><HR>"

	t += "Output : [round(lastgen)] W<BR><BR>"

	t += "<B>Cold loop</B><BR>"
	t += "Temperature Inlet: [round(circ1.air1.temperature, 0.1)] K  Outlet: [round(circ1.air2.temperature, 0.1)] K<BR>"
	t += "Pressure Inlet: [round(circ1.air1.return_pressure(), 0.1)] kPa  Outlet: [round(circ1.air2.return_pressure(), 0.1)] kPa<BR>"

	t += "<B>Hot loop</B><BR>"
	t += "Temperature Inlet: [round(circ2.air1.temperature, 0.1)] K  Outlet: [round(circ2.air2.temperature, 0.1)] K<BR>"
	t += "Pressure Inlet: [round(circ2.air1.return_pressure(), 0.1)] kPa  Outlet: [round(circ2.air2.return_pressure(), 0.1)] kPa<BR>"

	t += "<BR><HR><A href='?src=\ref[src];close=1'>Close</A>"

	t += "</PRE>"
	user << browse(t, "window=teg;size=460x300")
	onclose(user, "teg")
	return 1

/obj/machinery/power/generator/Topic(href, href_list)
	..()

	if( href_list["close"] )
		usr << browse(null, "window=teg")
		usr.machine = null
		return 0

	return 1

/obj/machinery/power/generator/power_change()
	..()
	updateicon()

