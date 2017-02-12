/obj/item/weapon/gun/projectile/automatic //Hopefully someone will find a way to make these fire in bursts or something. --Superxpdude
	name = "submachine gun"
	desc = "A lightweight, fast firing gun. Uses 9mm rounds."
	icon_state = "saber"	//ugly
	w_class = 3.0
	max_shells = 18
	caliber = "9mm"
	origin_tech = "combat=4;materials=2"
	ammo_type = "/obj/item/ammo_casing/c9mm"
	locked = 0


/obj/item/weapon/gun/projectile/automatic/mini_uzi
	name = "Uzi"
	desc = "A lightweight, fast firing gun, for when you want someone dead. Uses .45 rounds."
	icon_state = "mini-uzi"
	w_class = 3.0
	max_shells = 16
	caliber = ".45"
	origin_tech = "combat=5;materials=2;syndicate=8"
	ammo_type = "/obj/item/ammo_casing/c45"



/obj/item/weapon/gun/projectile/automatic/c20r
	name = "C-20r SMG"
	desc = "A lightweight, fast firing gun, for when you REALLY need someone dead. Uses 12mm rounds. Has a 'Scarborough Arms - Per falcis, per pravitas' buttstamp"
	icon_state = "c20r"
	item_state = "c20r"
	w_class = 3.0
	max_shells = 20
	caliber = "12mm"
	origin_tech = "combat=5;materials=2;syndicate=8"
	ammo_type = "/obj/item/ammo_casing/a12mm"
	fire_sound = 'sound/weapons/Gunshot_smg.ogg'
	load_method = 2
	locked = 2//explosive lock level

	New()
		..()
		empty_mag = new /obj/item/ammo_magazine/a12mm/empty(src)
		update_icon()
		return


	afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag)
		..()
		if(!loaded.len && empty_mag)
			empty_mag.loc = get_turf(src.loc)
			empty_mag = null
			playsound(user, 'sound/weapons/smg_empty_alarm.ogg', 40, 1)
			update_icon()
		return


	update_icon()
		..()
		if(empty_mag)
			icon_state = "c20r-[round(loaded.len,4)]"
		else
			icon_state = "c20r"
		return

//Warframe Guns

/obj/item/weapon/gun/projectile/automatic/lato
	name = "Lato"
	desc = "A lightweight, fast firing pistol of alien origin."
	icon = 'icons/obj/warframe_objs.dmi'
	icon_state = "lato"
	max_shells = 15

/obj/item/weapon/gun/projectile/automatic/braton
	name = "Braton"
	desc = "A blocky but fast firing rifle of alien origin."
	icon = 'icons/obj/warframe_objs.dmi'
	icon_state = "braton"
	max_shells = 20
	caliber = "12mm"
	ammo_type = "/obj/item/ammo_casing/a12mm"



//Imperium Bolt Guns

/obj/item/weapon/gun/projectile/automatic/boltpistol  //This is just foundation, I'll be expanding on these later.
	name = "Ceres Bolt Pistol"
	desc = "The Bolt Pistol is a smaller handheld version of the venerable Bolter. Assault Marines and Imperial Officers tend to favour it."
	icon_state = "bolt_pistol"
//	item_state = "bolt_pistol"
	fire_sound = 'sound/weapons/bolterfire.ogg'
	max_shells = 10
	ammo_type = "/obj/item/ammo_casing/a75"
	caliber = "75"
	rateoffire = 9
	origin_tech = "combat=5;materials=5"
	locked = 2

/obj/item/weapon/gun/projectile/automatic/boltpistol/boltgun
	name = "Mark IV Boltgun"
	desc = "The Boltgun, or Bolter, is the .75 calibre weapon of Imperium Space Marines."
	icon_state = "bolter_bloodravens"
//	item_state = "bolter_bloodravens"
	max_shells = 20
	rateoffire = 7

/obj/item/weapon/gun/projectile/automatic/boltpistol/boltgun/ultramarines  //Having a million parent types is efficient, right, guys? Right?
	icon_state = "bolter_ultramarines"
//	item_state = "bolter_ultramarines"



/* The thing I found with guns in ss13 is that they don't seem to simulate the rounds in the magazine in the gun.
   Afaik, since projectile.dm features a revolver, this would make sense since the magazine is part of the gun.
   However, it looks like subsequent guns that use removable magazines don't take that into account and just get
   around simulating a removable magazine by adding the casings into the loaded list and spawning an empty magazine
   when the gun is out of rounds. Which means you can't eject magazines with rounds in them. The below is a very
   rough and poor attempt at making that happen. -Ausops */
