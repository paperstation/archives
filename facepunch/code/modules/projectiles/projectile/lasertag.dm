/obj/item/projectile/lasertag//A laser tag bolt that stuns EVERYONE
	name = "lasertag beam"
	icon_state = "omnilaser"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	force = 20
	damtype = FATIGUE

	on_hit(var/atom/target, var/blocked = 0)
		if(istype(target, /mob/living/carbon/human))
			var/mob/living/carbon/human/M = target
			if(istype(M.wear_suit, /obj/item/clothing/suit/lasertag))
				M.deal_damage(force, damtype, forcetype)
		return 1


/obj/item/projectile/lasertag/blue
	icon_state = "bluelaser"
	on_hit(var/atom/target, var/blocked = 0)
		if(istype(target, /mob/living/carbon/human))
			var/mob/living/carbon/human/M = target
			if(istype(M.wear_suit, /obj/item/clothing/suit/lasertag/red))
				M.deal_damage(force, damtype, forcetype)
		return 1


/obj/item/projectile/lasertag/red
	icon_state = "laser"
	on_hit(var/atom/target, var/blocked = 0)
		if(istype(target, /mob/living/carbon/human))
			var/mob/living/carbon/human/M = target
			if(istype(M.wear_suit, /obj/item/clothing/suit/lasertag/blue))
				M.deal_damage(force, damtype, forcetype)
		return 1















/obj/item/projectile/lasertag/blue/away
	icon_state = "bluelaser"
	on_hit(var/atom/target, var/blocked = 0)
		if(istype(target, /mob/living/carbon/human))
			var/mob/living/carbon/human/M = target
			if(istype(M.wear_suit, /obj/item/clothing/suit/lasertag/red))
				for(var/obj/effect/landmark/X in world)
					if(X.name == "tagred")
						M.loc = X.loc
				M.deal_damage(force, damtype, forcetype)
		return 1


/obj/item/projectile/lasertag/red/away
	icon_state = "laser"
	on_hit(var/atom/target, var/blocked = 0)
		if(istype(target, /mob/living/carbon/human))
			var/mob/living/carbon/human/M = target
			if(istype(M.wear_suit, /obj/item/clothing/suit/lasertag/blue))
				for(var/obj/effect/landmark/X in world)
					if(X.name == "tagblue")
						M.loc = X.loc
				M.deal_damage(force, damtype, forcetype)
		return 1
