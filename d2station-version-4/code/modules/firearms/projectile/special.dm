//These could likely use an Onhit proc
/obj/item/projectile/ion
	name = "ion bolt"
	icon_state = "ion"
	flag = "taser"//Need to check this
	damage = 0
	nodamage = 1
	New()
		..()
		effects["emp"] = 1
		effectprob["emp"] = 80

/obj/item/projectile/freeze
	name = "freeze beam"
	icon_state = "ice_2"
	damage = 0
	var/temperature = 0

	proc/Freeze(atom/A as mob|obj|turf|area)
		if(istype(A, /mob))
			var/mob/M = A
			if(M.bodytemperature > temperature)
				M.bodytemperature = temperature

/obj/item/projectile/plasma
	name = "plasma blast"
	icon_state = "plasma_2"
	damage = 0
	var/temperature = 800

	proc/Heat(atom/A as mob|obj|turf|area)
		if(istype(A, /mob/living/carbon))
			var/mob/M = A
			if(M.bodytemperature < temperature)
				M.bodytemperature = temperature

/obj/item/projectile/goober
	name = "goober"
	desc = "Ewwwwwwwwwwwwwww!"
	icon_state = "goober"
	damage = 0

//	impact(atom/hit_atom)
//		else
//			..()
//		return

/obj/item/projectile/phaser
	name = "phaser shot"
	icon_state = "spark"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage = 0
	density = 0
	mobdamage = list(BRUTE = 0, BURN = 1, TOX = 0, OXY = 0, CLONE = 0)
	flag = "taser"
	bump_at_ttile = 1
	var/loaded_effect = "stun"
	var/radius = 0.0
	var/power = 25.0

	proc/effect_tiles(turf/A, var/effect_type)
		if(effect_type == "stun")
			for (var/turf/phaseturf in range(radius,A))
				for(var/mob/living/carbon/M in phaseturf)
					M.stunned += power / 5
					M.weakened += power / 5
				new /obj/effects/sparks(phaseturf)
			del(src)
		return