/obj/machinery/driver_button
	name = "mass driver button"
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt"
	desc = "A remote control switch for a mass driver."
	var/id = null
	var/active = 0
	anchored = 1.0
	use_power = USE_POWER_IDLE
	idle_power_usage = 2
	active_power_usage = 4

/obj/machinery/ignition_switch
	name = "ignition switch"
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt"
	desc = "A remote control switch for a mounted igniter."
	var/id = null
	var/active = 0
	anchored = 1.0
	use_power = USE_POWER_IDLE
	idle_power_usage = 2
	active_power_usage = 4

/obj/machinery/crema_switch
	name = "crematorium igniter"
	desc = "Burn baby burn!"
	icon = 'icons/obj/power.dmi'
	icon_state = "crema_switch"
	anchored = 1.0
	var/on = 0
	var/area/area = null
	var/otherarea = null
	var/id = 1


/obj/machinery/inter_switch
	name = "interrogation switch"
	desc = "Wonder if someon- oh yeah someone is inside!"
	icon = 'icons/obj/power.dmi'
	icon_state = "crema_switch"
	anchored = 1.0
	var/on = 0
	var/obj/structure/interrolight/id
	var/lighte = 0

/obj/machinery/inter_switch/attack_hand(mob/user as mob)
	for(var/obj/structure/interrolight/Z in range(src,5))
		id = Z
	if(!lighte == 1)
		id.icon_state = "bulb0"
	else
		id.icon_state = "firelight1"
		lighte = 0