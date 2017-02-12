//Shield Generator - Emitters
//The shield emitters



//
// Emitter Base Class
//

/obj/machinery/shielding/emitter
	icon = 'shieldgen.dmi'
	anchored = 1
	level = 1
	var/online = 0
	var/control = 0

/obj/machinery/shielding/emitter/plate
	icon_state = "plate"
	name = "Emitter Plate"
	desc = "An AoE shield emitter"
	level = 1
	var/range_dist = 10

/obj/machinery/shielding/emitter/powered()
	return Shields && Shields.HasPower()


/obj/machinery/shielding/emitter/plate/New()
	..()

	var/turf/T = src.loc			// hide if turf is not intact

	if(level==1) hide(T.intact)


/obj/machinery/shielding/emitter/plate/hide(var/i)
	if(level == 1 && istype(loc, /turf/simulated))
		invisibility = i ? 101 : 0
	updateicon()

/obj/machinery/shielding/emitter/proc/updateicon()
	icon_state = online ? "plate" : "plate-p"
	return

/obj/machinery/shielding/emitter/process()
	if(!powered())
		online = 0
//		world << "has Power fails"
		return
	else
		online = 1

	updateicon()
	if(control)
	//	world << "control var triggered"
		for(var/obj/machinery/shield/shield_tile in range(src,10))
			shield_tile.density = 1
			shield_tile.icon_state = "shieldsparkles[shield_tile.shieldsstrong]"
		//	Shields.deployed_shields += new /obj/machinery/shield(E.loc)
	else
	//	world << "control var fails"
		for(var/obj/machinery/shield/shield_tile in range(src,10))
			shield_tile.density = 0
			shield_tile.icon_state = "shieldsparklesblank"


