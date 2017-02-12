/obj/item/projectile/ion
	name = "ion bolt"
	icon_state = "ion"

	on_hit(var/atom/target, var/blocked = 0)
		empulse(target, 1, 1)
		return 1


/obj/item/projectile/bullet/silent
	name ="silent dart"
	icon_state= "bolter"

	on_hit(var/atom/target, var/blocked = 0)
		if(blocked)
			return 0
		if(istype(target, /mob/living))
			var/mob/M = target
			if(M.sdisabilities == MUTE)
				return
			else
				M.sdisabilities |= MUTE
				spawn(100)
				M.sdisabilities &= MUTE
		return 1


/obj/item/projectile/temp
	name = "temperature beam"
	icon_state = "ice_2"
	var/temperature = 300

	on_hit(var/atom/target, var/blocked = 0)//These two could likely check temp protection on the mob
		if(blocked)
			return 0
		if(istype(target, /mob/living))
			var/mob/M = target
			M.bodytemperature = temperature
		return 1


/obj/item/projectile/meteor
	name = "meteor"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "smallf"

	Bump(atom/A as mob|obj|turf|area)
		if(A == firer)
			loc = A.loc
			return

		sleep(-1) //Might not be important enough for a sleep(-1) but the sleep/spawn itself is necessary thanks to explosions and metoerhits

		if(src)//Do not add to this if() statement, otherwise the meteor won't delete them
			if(A)

				A.meteorhit(src)
				playsound(src.loc, 'sound/effects/meteorimpact.ogg', 40, 1)

				for(var/mob/M in range(5, src))
					if(!M.stat && !istype(M, /mob/living/silicon/ai))\
						shake_camera(M, 3, 1)
				del(src)
				return 1
		else
			return 0


/obj/item/projectile/energy/floramut
	name = "alpha somatoray"
	icon_state = "energy"

	on_hit(var/atom/target, var/blocked = 0)
		if(blocked)
			return 0
		if(istype(target, /mob/living))
			var/mob/living/M = target
			if(ishuman(target) && M.dna && M.dna.mutantrace == "plant") //Plantmen possibly get mutated and damaged by the rays.
				if(prob(15))
					M.deal_damage(rand(30,80),IRRADIATE, IRRADIATE, )
					M.deal_damage(5, WEAKEN)
					for (var/mob/V in viewers(src))
						V.show_message("\red [M] writhes in pain as \his vacuoles boil.", 3, "\red You hear the crunching of leaves.", 2)
				if(prob(35))
				//	for (var/mob/V in viewers(src)) //Public messages commented out to prevent possible metaish genetics experimentation and stuff. - Cheridan
				//		V.show_message("\red [M] is mutated by the radiation beam.", 3, "\red You hear the snapping of twigs.", 2)
					if(prob(80))
						randmutb(M)
						domutcheck(M,null)
					else
						randmutg(M)
						domutcheck(M,null)
				else
					M.deal_damage(10, BURN, IRRADIATE)
					M.show_message("\red The radiation beam singes you!")
				//	for (var/mob/V in viewers(src))
				//		V.show_message("\red [M] is singed by the radiation beam.", 3, "\red You hear the crackle of burning leaves.", 2)
			else if(istype(target, /mob/living/carbon/))
			//	for (var/mob/V in viewers(src))
			//		V.show_message("The radiation beam dissipates harmlessly through [M]", 3)
				M.show_message("\blue The radiation beam dissipates harmlessly through your body.")
			else
				return 1


/obj/item/projectile/energy/florayield
	name = "beta somatoray"
	icon_state = "energy2"

	on_hit(var/atom/target, var/blocked = 0)
		if(!istype(target, /mob/living))
			return 0
		var/mob/living/M = target
		if(ishuman(target) && M.dna && M.dna.mutantrace == "plant") //These rays make plantmen fat.
			if(M.nutrition < 500) //sanity check
				M.nutrition += 30
		else if (istype(target, /mob/living/carbon/))
			M.show_message("\blue The radiation beam dissipates harmlessly through your body.")
		else
			return 1


/obj/item/projectile/beam/mindflayer
	name = "flayer ray"

	on_hit(var/atom/target, var/blocked = 0)
		if(blocked)
			return 0
		if(ishuman(target))
			var/mob/living/carbon/human/M = target
			M.brain_damage += 20
			M.hallucination += 20
