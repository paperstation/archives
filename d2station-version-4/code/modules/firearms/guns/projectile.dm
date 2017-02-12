/obj/item/weapon/gun/projectile/detective
	desc = "A cheap Martian knock-off of a Smith & Wesson Model 10. Uses .38-Special rounds."
	name = ".38 revolver"
	icon_state = "detective"
	calibre = "9.1"
	origin_tech = "combat=2;materials=2"

	New()
		for(var/i = 1, i <= max_shells, i++)
			loaded += new /obj/item/ammo_casing/c38(src)
		update_icon()

	special_check(var/mob/living/carbon/human/M)
		return 1

	verb
		rename_gun()
			set name = "Name Gun"
			set desc = "Click to rename your gun. If you're the detective."

			var/mob/U = usr
			var/input = input("What do you want to name the gun?",,"")
			input = sanitize(input)
			if(input)
				if(in_range(U,src)&&(!isnull(src))&&!U.stat)
					name = input
					U << "You name the gun [input]. Say hello to your new friend."
				else
					U << "\red Can't let you do that, detective!"


/obj/item/weapon/gun/projectile/mateba
	name = "mateba"
	desc = "When you absolutely, positively need a 10mm hole in the other guy. Uses .357 ammo."
	icon_state = "mateba"
	origin_tech = "combat=2;materials=2"



/obj/item/weapon/gun/projectile/shotgun
	name = "shotgun"
	desc = "Useful for sweeping alleys."
	icon_state = "shotgun"
	item_state = "shotgun"
	max_shells = 2
	w_class = 4.0
	force = 10
	flags =  FPRINT | TABLEPASS | CONDUCT | USEDELAY | ONBACK
	calibre = "18.5"
	origin_tech = "combat=2;materials=2"
	jammable = 1
	var/recentpump = 0 // to prevent spammage

	New()
		for(var/i = 1, i <= max_shells, i++)
			loaded += new /obj/item/ammo_casing/shotgun/beanbag(src)
		update_icon()

	attack_self(mob/living/user as mob)
		if(recentpump) return
		pump()
		recentpump = 1
		sleep(10)
		recentpump = 0
		return

	proc/pump(mob/M)
		playsound(M, 'shotgunpump.ogg', 60, 1)
		pumped = 0
		for(var/obj/item/ammo_casing/AC in Storedshots)
			Storedshots -= AC //Remove casing from loaded list.
			AC.loc = get_turf(src) //Eject casing onto ground.



/obj/item/weapon/gun/projectile/shotgun/combat
	name = "combat shotgun"
	icon_state = "cshotgun"
	item_state = "cshotgun"
	burst_delay = 1
	w_class = 4.0
	flags =  FPRINT | TABLEPASS | CONDUCT | USEDELAY | ONBACK
	max_shells = 8
	origin_tech = "combat=3"
	maxpump = 1
	New()
		for(var/i = 1, i <= max_shells, i++)
			loaded += new /obj/item/ammo_casing/shotgun(src)
		update_icon()



/obj/item/weapon/gun/projectile/shotgun/combat2
	name = "security combat shotgun"
	icon_state = "cshotgun"
	item_state = "cshotgun"
	burst_delay = 1
	w_class = 4.0
	flags =  FPRINT | TABLEPASS | CONDUCT | USEDELAY | ONBACK
	max_shells = 4
	origin_tech = "combat=3"
	maxpump = 1
	New()
		for(var/i = 1, i <= max_shells, i++)
			loaded += new /obj/item/ammo_casing/shotgun/beanbag(src)
		update_icon()


/obj/item/weapon/gun/projectile/nadelauncher
	name = "grenade launcher"
	desc = "Can load and deploy any standard grenade."
	icon_state = "nadelauncher"
	item_state = "nadelauncher"
	w_class = 4.0
	burst_delay = 5
	flags =  FPRINT | TABLEPASS | CONDUCT | USEDELAY | ONBACK
	fire_sound = 'Egloves.ogg'
	calibre = "grenade"
	max_shells = 5
	recoil = 1
	origin_tech = "combat=3"

	New()
		return

	attackby(var/obj/item/A as obj, mob/user as mob)
		var/num_loaded = 0
		if(istype(A, /obj/item/weapon/chem_grenade))
			if(loaded.len < max_shells)
				user.drop_item()
				A.loc = src
				loaded += A
				num_loaded++
				playsound(src.loc, 'pop.ogg', 50, 0)
		if(istype(A, /obj/item/weapon/card/emag) && locked)
			locked = ""
			user << "\red You short out the implant lock on the gun!"
		if(num_loaded)
			user << text("\blue You load a grenade into the launcher!")
		update_icon()
		return

	update_icon()
		desc = initial(desc) + text(" Has [] grenades loaded.", loaded.len)

	load_into_chamber()
		if(!in_chamber)
			playsound(src.loc, 'shotgunpump.ogg', 60, 1)
			if(loaded.len)
				var/obj/item/weapon/chem_grenade/CG = loaded[1] //load next grenade
				loaded -= CG		//Remove grenade from loaded list.
				in_chamber = CG		//And chamber it
				update_icon()
			else
				return 0

		if(in_chamber)		//Do a second check just to be sure
			return 1
		else
			return 0


/obj/item/weapon/gun/projectile/automatic //Hopefully someone will find a way to make these fire in bursts or something. --Superxpdude
	name = "Submachine Gun"
	desc = "A lightweight, fast firing gun. Uses 9mm rounds."
	icon_state = "saber"
	burst_delay = 1
	w_class = 3.0
	max_shells = 18
	calibre = "9.0"
	origin_tech = "combat=4;materials=2"
	burst_size = 3
	jammable = 1

	New()
		for(var/i = 1, i <= max_shells, i++)
			loaded += new /obj/item/ammo_casing/c9mm(src)
		update_icon()

	attack_self(mob/living/user as mob)
		if(burst_size == 3)
			burst_size = 1
			user << "\blue You set the [name] to semi-automatic fire."
		else
			burst_size = 3
			user << "\blue You set the [name] to three-round burst fire."


/obj/item/weapon/gun/projectile/automatic/mini_uzi
	name = "Mini-Uzi"
	desc = "A lightweight, fast firing gun, for when you REALLY need someone dead. Uses .45 rounds."
	icon_state = "mini-uzi"
	item_state = "miniuzi"
	burst_delay = 3
	w_class = 3.0
	max_shells = 1
	load_method = 1
	calibre = "11.4"
	origin_tech = "combat=5;materials=2;syndicate=8"
	burst_size = 3
	allow_suppressor = 1
	sprsr_icon_name = "uzi-suppress"
	suppressor_x = 6

	New()
		loaded_magazine = new /obj/item/ammo_magazine/c45(src)
		update_icon()



/obj/item/weapon/gun/projectile/silenced
	name = "Silenced Pistol"
	desc = "A small, quiet,  easily concealable gun. Uses .45 rounds."
	icon_state = "silenced_pistol"
	w_class = 3.0
	max_shells = 1
	calibre = "11.4"
	suppressed = 1
	jammable = 1
	origin_tech = "combat=2;materials=2;syndicate=8"

	New()
		for(var/i = 1, i <= max_shells, i++)
			loaded += new /obj/item/ammo_casing/c45(src)
		update_icon()



/obj/item/weapon/gun/projectile/deagle
	name = "Desert Eagle"
	desc = "A robust handgun that uses .50AE ammo."
	icon_state = "deagle"
	item_state = "deagle"
	burst_delay = 3
	w_class = 3.0
	force = 14.0
	max_shells = 1
	fire_sound = 'pdw_single_shot.ogg'
	load_method = 1
	calibre = "12.7"
	jammable = 1
	origin_tech = "combat=2;materials=2"
	allow_suppressor = 1
	sprsr_icon_name = "deagle-suppress"
	suppressor_x = 11

	New()
		loaded_magazine = new /obj/item/ammo_magazine/c50ae(src)
		update_icon()

	gold
		desc = "A gold plated gun folded over a million times by superior martian gunsmiths. Uses .50AE ammo."
		icon_state = "deaglegold"
		item_state = "deaglegold"

	goldcamo
		desc = "A Deagle brand Deagle for operators operating operationally. Uses .50AE ammo."
		icon_state = "deaglegoldcamo"
		item_state = "deaglegold"


/obj/item/weapon/gun/projectile/gyropistol
	name = "Gyrojet Pistol"
	desc = "A bulky pistol designed to fire self propelled rounds."
	icon_state = "gyropistol"
	w_class = 3.0
	max_shells = 8
	calibre = "6.1"
	jammable = 1
	fire_sound = 'Explosion1.ogg'
	origin_tech = "combat=3"

	New()
		update_icon()


/obj/item/weapon/gun/projectile/magnetrifle
	name = "magnet rifle"
	desc = "An experiemental rifle that uses magnetic fields to propel a magnetized projectile. Uses magnet rifle ammo."
	icon_state = "magnetrifle1"
	w_class = 3.0
	max_shells = 1
	calibre = "magnetrifle"
	jammable = 1
	origin_tech = "combat=3;materials=2;magnets=1"

	New()
		update_icon()


/obj/item/weapon/gun/projectile/fiveseven
	name = "five-seven"
	desc = "A versatile pistol favored by varied forces. Uses 5.7x28mm."
	icon_state = "five_seven"
	w_class = 3.0
	max_shells = 1
	calibre = "5.7"
	jammable = 1
	load_method = 1
	origin_tech = "combat=3"
	allow_suppressor = 1
	sprsr_icon_name = "five_seven-suppress"
	suppressor_x = 10

	New()
		loaded_magazine = new /obj/item/ammo_magazine/fiveseven(src)
		update_icon()


/obj/item/weapon/gun/projectile/glock
	name = "glock 19"
	desc = "A powerful, widely-used pistol. Uses 9mm."
	icon_state = "glock"
	item_state = "glock"
	w_class = 3.0
	force = 5.0
	max_shells = 1
	load_method = 1
	calibre = "9.0"
	jammable = 1
	origin_tech = "combat=2;materials=2"

	New()
		loaded_magazine = new /obj/item/ammo_magazine/c9mm(src)
		update_icon()


