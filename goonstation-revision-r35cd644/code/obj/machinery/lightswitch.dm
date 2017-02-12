// the light switch
// can have multiple per area
// can also operate on non-loc area through "otherarea" var

/obj/machinery/light_switch
	desc = "A light switch"
	name = null
	icon = 'icons/obj/power.dmi'
	icon_state = "light1"
	anchored = 1.0
	var/on = 1
	var/area/area = null
	var/otherarea = null
	//	luminosity = 1
	// mats = 6 fuck you mport


/obj/machinery/light_switch/New()
	..()
	UnsubscribeProcess()
	spawn(5)
		src.area = src.loc.loc

		if(otherarea)
			src.area = locate(text2path("/area/[otherarea]"))

		if(!name || name == "N light switch" || name == "E light switch" || name == "S light switch" || name == "W light switch")
			name = "light switch"

		src.on = src.area.lightswitch
		updateicon()

		mechanics = new(src)
		mechanics.master = src
		mechanics.addInput("trigger", "trigger")

/obj/machinery/light_switch/proc/trigger(var/datum/mechanicsMessage/inp)
	attack_hand(usr) //bit of a hack but hey.
	return


/obj/machinery/light_switch/proc/updateicon()
	if(stat & NOPOWER)
		icon_state = "light-p"
	else
		if(on)
			icon_state = "light1"
		else
			icon_state = "light0"

/obj/machinery/light_switch/examine()
	set src in oview(1)
	set category = "Local"
	if(usr && !usr.stat)
		boutput(usr, "A light switch. It is [on? "on" : "off"].")

/obj/machinery/light_switch/attack_hand(mob/user)

	on = !on

	area.lightswitch = on
	for(var/obj/machinery/light_switch/L in area)
		L.on = on
		L.updateicon()

	area.power_change()

	if(mechanics) mechanics.fireOutgoing(mechanics.newSignal("[on ? "lightOn":"lightOff"]"))

/obj/machinery/light_switch/power_change()

	if(!otherarea)
		if(powered(LIGHT))
			stat &= ~NOPOWER
		else
			stat |= NOPOWER

		updateicon()

/obj/machinery/light_switch/north
	name = "N light switch"
	pixel_y = 24

/obj/machinery/light_switch/east
	name = "E light switch"
	pixel_x = 24

/obj/machinery/light_switch/south
	name = "S light switch"
	pixel_y = -24

/obj/machinery/light_switch/west
	name = "W light switch"
	pixel_x = -24
