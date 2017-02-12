

////////Laser Tag////////////////////



/obj/item/weapon/gun/energy/lasertag
	name = "laser tag gun"
	icon_state = "bluetag"
	desc = "Standard issue weapon of the Imperial Guard"
	projectile_type = "/obj/item/projectile/lasertag/red"
	origin_tech = "combat=1;magnets=2"
	fire_sound = 'sound/weapons/Laser.ogg'
	w_class = 3.0
	m_amt = 2000
	var/charge_tick = 0


	New()
		..()
		processing_objects.Add(src)


	Del()
		processing_objects.Remove(src)
		..()


	process()
		charge_tick++
		if(charge_tick < 4) return 0
		charge_tick = 0
		if(!power_supply) return 0
		power_supply.give(100)
		update_icon()
		return 1


/obj/item/weapon/gun/energy/lasertag/red
	icon_state = "redtag"
	projectile_type = "/obj/item/projectile/lasertag/red"

	special_check(var/mob/living/carbon/human/M)
		if(ishuman(M))
			if(istype(M.wear_suit, /obj/item/clothing/suit/lasertag/red))
				return 1
			M << "\red You need to be wearing your laser tag vest!"
		return 0

obj/item/weapon/gun/energy/lasertag/blue
	icon_state = "bluetag"
	projectile_type = "/obj/item/projectile/lasertag/blue"

	special_check(var/mob/living/carbon/human/M)
		if(ishuman(M))
			if(istype(M.wear_suit, /obj/item/clothing/suit/lasertag/blue))
				return 1
			M << "\red You need to be wearing your laser tag vest!"
		return 0

/obj/item/weapon/gun/energy/lasertag/practice
	name = "practice laser gun"
	desc = "A modified version of the basic laser gun, this one fires less concentrated energy bolts designed for target practice."
	projectile_type = "/obj/item/projectile/practice"





/obj/item/weapon/gun/energy/lasertag/red/away
	icon_state = "redtag"
	projectile_type = "/obj/item/projectile/lasertag/red/away"

	special_check(var/mob/living/carbon/human/M)
		if(ishuman(M))
			if(istype(M.wear_suit, /obj/item/clothing/suit/lasertag/red))
				return 1
			M << "\red You need to be wearing your laser tag vest!"
		return 0

obj/item/weapon/gun/energy/lasertag/blue/away
	icon_state = "bluetag"
	projectile_type = "/obj/item/projectile/lasertag/blue/away"

	special_check(var/mob/living/carbon/human/M)
		if(ishuman(M))
			if(istype(M.wear_suit, /obj/item/clothing/suit/lasertag/blue))
				return 1
			M << "\red You need to be wearing your laser tag vest!"
		return 0










/obj/item/weapon/gun/energy/paintball
	name = "laser tag gun"
	icon_state = "bluetag"
	desc = "Standard issue weapon of the Imperial Guard"
	projectile_type = "/obj/item/projectile/energy/paintball"
	origin_tech = "combat=1;magnets=2"
	fire_sound = 'sound/weapons/Laser.ogg'
	w_class = 3.0
	m_amt = 2000
	var/charge_tick = 0


	New()
		..()
		processing_objects.Add(src)


	Del()
		processing_objects.Remove(src)
		..()


	process()
		charge_tick++
		if(charge_tick < 15) return 0
		charge_tick = 0
		if(!power_supply) return 0
		power_supply.give(100)
		update_icon()
		return 1



/obj/item/weapon/gun/energy/paintball/green
	name = "green paintball gun"
	icon_state = "bluetag"
	desc = "Standard issue fun gun."
	color = "green"
	projectile_type = "/obj/item/projectile/energy/paintball/green"
	origin_tech = "combat=1;magnets=2"
	fire_sound = 'sound/weapons/Laser.ogg'

/obj/item/weapon/gun/energy/paintball/red
	name = "red paintball gun"
	icon_state = "bluetag"
	desc = "Standard issue fun gun."
	color = "red"
	projectile_type = "/obj/item/projectile/energy/paintball/red"
	origin_tech = "combat=1;magnets=2"
	fire_sound = 'sound/weapons/Laser.ogg'
