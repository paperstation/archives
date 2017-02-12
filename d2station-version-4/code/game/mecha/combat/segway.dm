/obj/mecha/combat/segway
	desc = "A fancy space segway."
	name = "Segway"
	icon_state = "segway"
	melee_cooldown = 10
	melee_can_hit = 0
	anchored = 0
	step_in = 1
	health = 40
	opacity = 0
	deflect_chance = 10
	internal_damage_threshold = 60
	max_temperature = 500
	infra_luminosity = 5
	operation_req_access = ""
	add_req_access = 0
	max_equip = 0
	step_energy_drain = 1

/obj/mecha/combat/segway/New()
	..()
	src.icon_state = "segway-open"

/obj/mecha/combat/segway/melee_action(target as obj|mob|turf)
	return

/obj/mecha/combat/segway/Bump(var/atom/obstacle)
	if(istype(obstacle, /obj))
		var/obj/O = obstacle
		if(istype(O , /obj/machinery/door))
			if(src.occupant)
				O.Bumped(src.occupant)
		else if(!O.anchored)
			step(obstacle,src.dir)
		else
			obstacle.Bumped(src)
	else if(istype(obstacle, /mob))
		if(obstacle && src.occupant)
			var/mob/M = obstacle
			M.stunned = 1
			M.weakened = 1
			M.bruteloss += 3
			src.occupant.stunned = 3
			src.occupant.weakened = 3
			src.occupant.bruteloss += rand(20,50)
			src.take_damage(rand(5,30))
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


/obj/mecha/combat/segway/clown
	desc = "HONK"
	name = "honkway"
	icon_state = "clown_segway"


/obj/mecha/combat/segway/clown/New()
	..()
	src.icon_state = "clown_segway-open"

/obj/mecha/combat/segway/clown/relaymove(mob/user,direction)
	..()
	playsound(src, 'bikehorn.ogg', 30, 1)

/obj/mecha/combat/segway/fucker
	desc = "NanoTrasen TM Fuckmachine"
	name = "fuckmachine"
	icon_state = "fuckmachine"


/obj/mecha/combat/segway/fucker/New()
	..()
	src.icon_state = "fuckmachine-open"

/obj/mecha/combat/segway/fucker/relaymove(mob/user,direction)
	..()
	playsound(src, 'squish.ogg', 5, 1)