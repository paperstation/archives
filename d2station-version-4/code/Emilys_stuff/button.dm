/obj/machinery/shieldsbutton
	name = "Toggle Shields"
	icon = 'airlock_machines.dmi'
	icon_state = "Shields_Off"
	anchored = 1
	var/toggle = 0
	var/list/deployed_shields = list()
	var/shield_Integrity = 0
	var/shieldsfailed = 0
	var/list/missingshieldscheck = list()
	var/on = null
	var/charging = null
	var/list/capacitators = list()

	attack_hand(mob/user)
		if(!toggle)
			Shields.startshields()
			icon_state = "Shields_On"
			toggle = 1
			for(var/obj/machinery/shielding/emitter/E in machines)
				E.control = 1
		else
			Shields.stopshields()
			toggle = 0
			icon_state = "Shields_Off"
			for(var/obj/machinery/shielding/emitter/E in machines)
				E.control = 0
		flick("Shields_cycle", src)


