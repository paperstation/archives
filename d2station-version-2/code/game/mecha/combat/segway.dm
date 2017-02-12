/obj/mecha/combat/segway
	desc = "A fancy space segway."
	name = "Segway"
	icon_state = "segway"
	step_in = 1
	health = 200
	opacity = 0
	deflect_chance = 5
	max_temperature = 500
	infra_luminosity = 8
	operation_req_access = null
	force = 35
	use_internal_tank = 0
	var/defence = 0
	var/defence_deflect = 20

/obj/mecha/combat/segway/New()
	..()
	src.icon_state = "segway-open"
	src.air_contents.volume = gas_tank_volume //liters
	src.air_contents.temperature = T20C
	src.air_contents.oxygen = (src.maximum_pressure*filled)*air_contents.volume/(R_IDEAL_GAS_EQUATION*air_contents.temperature)
	src.spark_system.set_up(2, 0, src)
	src.spark_system.attach(src)
	src.cell.charge = 10000
	src.cell.maxcharge = 10000

/obj/mecha/combat/segway/melee_action(target as obj|mob|turf)
	return

/obj/mecha/combat/segway/Bump(var/atom/obstacle)
//	src.inertia_dir = null
	if(istype(obstacle, /obj))
		var/obj/O = obstacle
		if(istype(O , /obj/machinery/door))
			if(src.occupant)
				O.Bumped(src.occupant)
		/* //not working, will fix later
		else if(istype(O, /obj/portal)) //derpfix
			src.anchored = 0
			O.Bumped(src)
			src.anchored = 1
		*/
		else if(!O.anchored)
			step(obstacle,src.dir)
		else //I have no idea why I disabled this
			obstacle.Bumped(src)
	else if(istype(obstacle, /mob))
		var/mob/M = obstacle
		M.stunned = 5
		M.weakened = 4
		M.bruteloss += 5
		src.occupant.stunned = 5
		src.occupant.weakened = 4
		src.occupant.bruteloss += 9
		src.take_damage(1)
		playsound(src, 'bang.ogg', 25)

		src.occupant.pixel_y = 0
		src.go_out()

		src.occupant.throw_at(obstacle, 5, 3)
		for(var/mob/living/carbon/V in ohearers(6, src))
			V.show_message("\red <B>[src.occupant] has crashes into [M] with their [src.name]!</B>",1)
	else
		obstacle.Bumped(src)
	return

/obj/mecha/combat/segway/cop
	desc = "A fancy space segway, good for cops."
	name = "Police Segway"
	icon_state = "cop_segway"


/obj/mecha/combat/segway/cop/New()
	..()
	src.icon_state = "cop_segway-open"
	src.air_contents.volume = gas_tank_volume //liters
	src.air_contents.temperature = T20C
	src.air_contents.oxygen = (src.maximum_pressure*filled)*air_contents.volume/(R_IDEAL_GAS_EQUATION*air_contents.temperature)
	src.spark_system.set_up(2, 0, src)
	src.spark_system.attach(src)
	src.cell.charge = 50000
	src.cell.maxcharge = 50000