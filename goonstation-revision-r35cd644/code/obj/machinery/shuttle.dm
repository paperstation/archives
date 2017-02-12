/obj/machinery/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'

/obj/machinery/shuttle/engine
	name = "engine"
	density = 1
	anchored = 1.0

/obj/machinery/shuttle/engine/heater
	name = "heater"
	icon_state = "heater"

/obj/machinery/shuttle/engine/platform
	name = "platform"
	icon_state = "platform"

/obj/machinery/shuttle/engine/propulsion
	name = "propulsion"
	icon_state = "propulsion"
	opacity = 1
	var/stat1 = 1
	var/stat2 = 1
	var/id = null

//////////////////////////////////////////
// SHUTTLE THRUSTER DAMAGE STARTS HERE
//////////////////////////////////////////

/obj/machinery/shuttle/engine/propulsion/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/screwdriver))
		if (src.stat1 == 0)
			boutput(usr, "<span style=\"color:blue\">Resecuring outer frame.</span>")
			playsound(src.loc, "sound/items/Screwdriver.ogg", 100, 1)
			sleep(20)
			boutput(usr, "<span style=\"color:blue\">Outer frame secured.</span>")
			src.stat1 = 1
			return
		if (src.stat1 == 1)
			boutput(usr, "<span style=\"color:red\">Unsecuring outer frame.</span>")
			playsound(src.loc, "sound/items/Screwdriver.ogg", 100, 1)
			sleep(20)
			boutput(usr, "<span style=\"color:red\">Done.</span>")
			src.stat1 = 0
			return
		else
			..()
			return
	else if (istype(W, /obj/item/rods) && src.stat2 == 0)
		boutput(usr, "<span style=\"color:blue\">Now plating hull.</span>")
		sleep(20)
		boutput(usr, "<span style=\"color:blue\">Plating secured.</span>")
		qdel(W)
		src.stat2 = 1
		return
	else if (istype(W, /obj/item/wrench) && src.stat2 == 1)
		var/obj/item/rods/R = new /obj/item/rods
		playsound(src.loc, "sound/items/Ratchet.ogg", 100, 1)
		boutput(usr, "<span style=\"color:red\">Removing outer hull plating.</span>")
		sleep(20)
		boutput(usr, "<span style=\"color:red\">Done.</span>")
		src.stat2 = 0
		R.set_loc(src.loc)
		return
	else
		..()
		return

/obj/machinery/shuttle/engine/propulsion/examine()
	if (src.stat1 == 1 && src.stat2 == 1)
		boutput(usr, "<span style=\"color:blue\">The propulsion engine is working properly!</span>")
	else
		boutput(usr, "<span style=\"color:red\">The propulsion engine is not functioning.</span>")

/obj/machinery/shuttle/engine/propulsion/ex_act()
	if(src.stat1 == 0 && src.stat2 == 0) // don't break twice, that'd be silly
		src.visible_message("<span style=\"color:red\">[src] explodes!</span>")
		src.stat1 = 0
		src.stat2 = 0
		return
/obj/machinery/shuttle/engine/propulsion/meteorhit()
	if(src.stat1 == 0 && src.stat2 == 0)
		src.visible_message("<span style=\"color:red\">[src] explodes!</span>")
		src.stat1 = 0
		src.stat2 = 0
		return
/obj/machinery/shuttle/engine/propulsion/blob_act(var/power)
	if(src.stat1 == 0 && src.stat2 == 0)
		src.visible_message("<span style=\"color:red\">[src] explodes!</span>")
		src.stat1 = 0
		src.stat2 = 0
		return

//////////////////////////////////////////
// SHUTTLE THRUSTER DAMAGE ENDS HERE
//////////////////////////////////////////

/obj/machinery/shuttle/engine/propulsion/burst
	name = "burst"

/obj/machinery/shuttle/engine/propulsion/burst/left
	name = "left"
	icon_state = "burst_l"

/obj/machinery/shuttle/engine/propulsion/burst/right
	name = "right"
	icon_state = "burst_r"

/obj/machinery/shuttle/engine/router
	name = "router"
	icon_state = "router"

