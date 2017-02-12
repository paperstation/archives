

/obj/machinery/shielding/capacitor
	name = "Shielding Capacitor"
	desc = "A storage device for shield energy"
	icon = 'shieldgen.dmi'
	icon_state = "cap"
	anchored = 1
	density = 1
	var/list/emit = list()
	var/maxcharge = 1000000
	var/charge = 100000
	var/obj/machinery/shielding/energyconverter/generator = null
	var/obj/machinery/shieldsbutton/shieldbutton = null
	var/shields_enabled = 0
	var/on = 1
	use_power = 1
	idle_power_usage = 5000
	active_power_usage = 30000

//Process Loop
/obj/machinery/shielding/capacitor/process()
	if(stat & BROKEN)
		charge = 0
		updateicon()
		use_power = 0
		return
	if(shields_enabled)
		use_power = 2
		if(charge)
			charge -= (100 * Shields.deployed_shields.len)
		//	world << "charge Remaining : [charge / 1000] (fractioned by a thousand)"
			charge = max(charge, 0)
	if(charge == 0 && on)
		Shields.stopshields()
		on = 0
		Shields.on = 0
	else if(charge >= 1 && !on)
		on = 1
		Shields.on = 1
		Shields.startshields()
	updateicon()
	return


///Update the icon
/obj/machinery/shielding/capacitor/proc/updateicon()
	clearoverlays()
	icon_state = "cap[stat & (NOPOWER|BROKEN) ? "-p" : ""]"
	addoverlay(image('shieldgen.dmi', "c[round(charge * 5 / maxcharge)]"))
	if(generator && (!generator.OperatingMode || generator.stat))
		addoverlay(image('shieldgen.dmi', "cap-o"))
	return