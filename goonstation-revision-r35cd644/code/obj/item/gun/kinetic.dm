/obj/item/gun/kinetic
	name = "kinetic weapon"
	icon = 'icons/obj/gun.dmi'
	item_state = "gun"
	m_amt = 2000
	var/obj/item/ammo/bullets/ammo = null
	var/max_ammo_capacity = 1 // How much ammo can this gun hold? Don't make this null (Convair880).
	var/caliber = null // Can be a list too. The .357 Mag revolver can also chamber .38 Spc rounds, for instance (Convair880).

	var/auto_eject = 0 // Do we eject casings on firing, or on reload?
	var/casings_to_eject = 0 // If we don't automatically ejected them, we need to keep track (Convair880).

	add_residue = 1 // Does this gun add gunshot residue when fired? Kinetic guns should (Convair880).

	// caliber list: update as needed
	// 0.308 - rifles
	// 0.357 - revolver
	// 0.38 - detective
	// 0.41 - derringer
	// 0.72 - shotgun shell, 12ga
	// 1.57 - 40mm shell
	// 1.58 - RPG-7 (Tube is 40mm too, though warheads are usually larger in diameter.)

	examine()
		set src in usr
		if (src.ammo && (src.ammo.amount_left > 0))
			src.desc = "There are [src.ammo.amount_left] bullets of [src.ammo.sname] left!"
		else
			src.desc = "There are 0 bullets left!"
		if (current_projectile)
			src.desc += "<br>Each shot will currently use [src.current_projectile.cost] bullets!"
		else
			src.desc += "<br><span style=\"color:red\">*ERROR* No output selected!</span>"
		..()

	update_icon()
		return 0

	canshoot()
		if(src.ammo && src.current_projectile)
			if(src.ammo:amount_left >= src.current_projectile:cost)
				return 1
		return 0

	process_ammo(var/mob/user)
		if(src.ammo && src.current_projectile)
			if(src.ammo.use(current_projectile.cost))
				return 1
		boutput(user, "<span style=\"color:red\">*click* *click*</span>")
		return 0

	attackby(obj/item/ammo/bullets/b as obj, mob/user as mob)
		if(istype(b, /obj/item/ammo/bullets))
			switch (src.ammo.loadammo(b,src))
				if(0)
					user.show_text("You can't reload this gun.", "red")
					return
				if(1)
					user.show_text("This ammo won't fit!", "red")
					return
				if(2)
					user.show_text("There's no ammo left in [b.name].", "red")
					return
				if(3)
					user.show_text("[src] is full!", "red")
					return
				if(4)
					user.visible_message("<span style=\"color:red\">[user] reloads [src].</span>", "<span style=\"color:red\">There wasn't enough ammo left in [b.name] to fully reload [src]. It only has [src.ammo.amount_left] rounds remaining.</span>")
					src.logme_temp(user, src, b) // Might be useful (Convair880).
					return
				if(5)
					user.visible_message("<span style=\"color:red\">[user] reloads [src].</span>", "<span style=\"color:red\">You fully reload [src] with ammo from [b.name]. There are [b.amount_left] rounds left in [b.name].</span>")
					src.logme_temp(user, src, b)
					return
				if(6)
					switch (src.ammo.swap(b,src))
						if(0)
							user.show_text("This ammo won't fit!", "red")
							return
						if(1)
							user.visible_message("<span style=\"color:red\">[user] reloads [src].</span>", "<span style=\"color:red\">You swap out the magazine. Or whatever this specific gun uses.</span>")
						if(2)
							user.visible_message("<span style=\"color:red\">[user] reloads [src].</span>", "<span style=\"color:red\">You swap [src]'s ammo with [b.name]. There are [b.amount_left] rounds left in [b.name].</span>")
					src.logme_temp(user, src, b)
					return
		else
			..()

	attack_self(mob/user as mob)
		return

	attack_hand(mob/user as mob)
	// Added this to make manual reloads possible (Convair880).

		if ((src.loc == user) && user.find_in_hand(src)) // Make sure it's not on the belt or in a backpack.
			src.add_fingerprint(user)
			if (src.sanitycheck(0, 1) == 0)
				user.show_text("You can't unload this gun.", "red")
				return
			if (src.ammo.amount_left <= 0)
				// The gun may have been fired; eject casings if so.
				if ((src.casings_to_eject > 0) && src.current_projectile.casing)
					if (src.sanitycheck(1, 0) == 0)
						logTheThing("debug", usr, null, "<b>Convair880</b>: [usr]'s gun ([src]) ran into the casings_to_eject cap, aborting.")
						src.casings_to_eject = 0
						return
					else
						user.show_text("You eject [src.casings_to_eject] casings from [src].", "red")
						src.ejectcasings()
						return
				else
					user.show_text("[src] is empty!", "red")
					return

			// Make a copy here to avoid item teleportation issues.
			var/obj/item/ammo/bullets/ammoHand = new src.ammo.type
			ammoHand.amount_left = src.ammo.amount_left
			ammoHand.name = src.ammo.name
			ammoHand.icon = src.ammo.icon
			ammoHand.icon_state = src.ammo.icon_state
			ammoHand.ammo_type = src.ammo.ammo_type
			ammoHand.delete_on_reload = 1 // No duplicating empty magazines, please (Convair880).
			ammoHand.update_icon()
			user.put_in_hand_or_drop(ammoHand)

			// The gun may have been fired; eject casings if so.
			src.ejectcasings()
			src.casings_to_eject = 0

			src.update_icon()
			src.ammo.amount_left = 0
			src.add_fingerprint(user)
			ammoHand.add_fingerprint(user)

			user.visible_message("<span style=\"color:red\">[user] unloads [src].</span>", "<span style=\"color:red\">You unload [src].</span>")
			//DEBUG("Unloaded [src]'s ammo manually.")
			return

		return ..()

	attack(mob/M as mob, mob/user as mob)
	// Finished Cogwerks' former WIP system (Convair880).
		if (src.canshoot() && user.a_intent != "help")
			if (src.auto_eject)
				var/turf/T = get_turf(src)
				if(T)
					if (src.current_projectile.casing && (src.sanitycheck(1, 0) == 1))
						var/number_of_casings = max(1, src.current_projectile.shot_number)
						//DEBUG("Ejected [number_of_casings] casings from [src].")
						for (var/i = 1, i <= number_of_casings, i++)
							var/obj/item/casing/C = new src.current_projectile.casing(T)
							C.forensic_ID = src.forensic_ID
							C.loc = T
			else
				if (src.casings_to_eject < 0)
					src.casings_to_eject = 0
				src.casings_to_eject += src.current_projectile.shot_number
		..()

	shoot(var/target,var/start ,var/mob/user)
		if (src.canshoot())
			if (src.auto_eject)
				var/turf/T = get_turf(src)
				if(T)
					if (src.current_projectile.casing && (src.sanitycheck(1, 0) == 1))
						var/number_of_casings = max(1, src.current_projectile.shot_number)
						//DEBUG("Ejected [number_of_casings] casings from [src].")
						for (var/i = 1, i <= number_of_casings, i++)
							var/obj/item/casing/C = new src.current_projectile.casing(T)
							C.forensic_ID = src.forensic_ID
							C.loc = T
			else
				if (src.casings_to_eject < 0)
					src.casings_to_eject = 0
				src.casings_to_eject += src.current_projectile.shot_number
		..()

	proc/ejectcasings()
		if ((src.casings_to_eject > 0) && src.current_projectile.casing && (src.sanitycheck(1, 0) == 1))
			var/turf/T = get_turf(src)
			if(T)
				//DEBUG("Ejected [src.casings_to_eject] [src.current_projectile.casing] from [src].")
				var/obj/item/casing/C = null
				while (src.casings_to_eject > 0)
					C = new src.current_projectile.casing(T)
					C.forensic_ID = src.forensic_ID
					C.loc = T
					src.casings_to_eject--
		return

	// Don't set this too high. Absurdly large reloads and item spawning can cause a lot of lag. (Convair880).
	proc/sanitycheck(var/casings = 0, var/ammo = 1)
		if (casings && (src.casings_to_eject > 30 || src.current_projectile.shot_number > 30))
			logTheThing("debug", usr, null, "<b>Convair880</b>: [usr]'s gun ([src]) ran into the casings_to_eject cap, aborting.")
			if (src.casings_to_eject > 0)
				src.casings_to_eject = 0
			return 0
		if (ammo && (src.max_ammo_capacity > 200 || src.ammo.amount_left > 200))
			logTheThing("debug", usr, null, "<b>Convair880</b>: [usr]'s gun ([src]) ran into the magazine cap, aborting.")
			return 0
		return 1

/obj/item/casing
	name = "bullet casing"
	desc = "A spent casing from a bullet of some sort."
	icon = 'icons/obj/casings.dmi'
	icon_state = "medium"
	w_class = 1
	var/forensic_ID = null

	small
		icon_state = "small"
		desc = "Seems to be a small pistol cartridge."

	medium
		icon_state = "medium"
		desc = "Seems to be a common revolver cartridge."

	rifle
		icon_state = "rifle"
		desc = "Seems to be a rifle cartridge."

	derringer
		icon_state = "medium"
		desc = "A fat and stumpy bullet casing. Looks pretty old."

	shotgun_red
		icon_state = "shotgun_red"
		desc = "A red shotgun shell."

	shotgun_blue
		icon_state = "shotgun_blue"
		desc = "A blue shotgun shell."

	shotgun_orange
		icon_state = "shotgun_orange"
		desc = "An orange shotgun shell."

	grenade
		w_class = 2
		icon_state = "40mm"
		desc = "A 40mm grenade round casing. Huh."

	New()
		..()
		src.pixel_y += rand(-12,12)
		src.pixel_x += rand(-12,12)
		src.dir = pick(alldirs)
		return

/obj/item/gun/kinetic/revolver
	desc = "There are 0 bullets left. Uses .357"
	name = "revolver"
	icon_state = "revolver"
	force = 8.0
	caliber = list(0.38, 0.357) // Just like in RL (Convair880).
	max_ammo_capacity = 7

	New()
		ammo = new/obj/item/ammo/bullets/a357
		current_projectile = new/datum/projectile/bullet/revolver_357
		..()

/obj/item/gun/kinetic/revolver/vr
	icon = 'icons/effects/VR.dmi'

/obj/item/gun/kinetic/derringer
	desc = "A small and easy-to-hide gun that comes with 2 shots. (Can be hidden in worn clothes and retrieved by using the wink emote)"
	name = "derringer"
	icon_state = "derringer"
	force = 5.0
	caliber = 0.41
	max_ammo_capacity = 2
	w_class = 2

	afterattack(obj/O as obj, mob/user as mob)
		if (O.loc == user && O != src && istype(O, /obj/item/clothing))
			boutput(user, "<span style=\"color:blue\">You hide the derringer inside \the [O]. (Use the wink emote to retrieve it.)</span>")
			user.u_equip(src)
			src.set_loc(O)
			src.dropped(user)
		else
			..()
		return

	New()
		ammo = new/obj/item/ammo/bullets/derringer
		current_projectile = new/datum/projectile/bullet/derringer
		..()

/obj/item/gun/kinetic/detectiverevolver
	desc = "An old surplus police-issue revolver. Uses .38-Special rounds."
	name = ".38 revolver"
	icon_state = "detective"
	w_class = 2.0
	force = 2.0
	caliber = 0.38
	max_ammo_capacity = 7

	New()
		ammo = new/obj/item/ammo/bullets/a38/stun
		current_projectile = new/datum/projectile/bullet/revolver_38/stunners
		..()

/obj/item/gun/kinetic/spacker
	name = "Spacker-12"
	desc = "Multi-purpose high-grade military shotgun."
	icon_state = "shotgun"
	force = 18.0
	contraband = 7
	caliber = 0.72
	max_ammo_capacity = 8
	auto_eject = 1

	New()
		ammo = new/obj/item/ammo/bullets/a12
		current_projectile = new/datum/projectile/bullet/a12
		..()

	suicide(var/mob/usr as mob)
		if(!src.canshoot() || !hasvar(usr,"organHolder")) return 0

		src.process_ammo(usr)
		usr.visible_message("<span style=\"color:red\"><b>[usr] places the [src.name]'s barrel in \his mouth and pulls the trigger with \his foot!</b></span>")
		var/obj/head = usr:organHolder.drop_organ("head")
		qdel(head)
		playsound(src, "sound/weapons/shotgunshot.ogg", 100, 1)
		var/obj/decal/cleanable/blood/gibs/gib = new /obj/decal/cleanable/blood/gibs(src.loc)
		gib.streak(turn(usr.dir,180))
		usr.updatehealth()
		return 1

/obj/item/gun/kinetic/spacker/vr
	icon = 'icons/effects/VR.dmi'

/obj/item/gun/kinetic/riotgun
	name = "Riot Shotgun"
	desc = "A police-issue shotgun meant for suppressing riots."
	icon_state = "shotgund"
	force = 15.0
	contraband = 5
	caliber = 0.72
	max_ammo_capacity = 8
	auto_eject = 1

	New()
		ammo = new/obj/item/ammo/bullets/abg
		current_projectile = new/datum/projectile/bullet/abg
		..()

/obj/item/gun/kinetic/ak47
	name = "AK-744 Rifle"
	desc = "Based on a an old Cold War relic, often used by paramilitary organizations and space terrorists."
	icon_state = "ak47"
	force = 30.0
	contraband = 8
	caliber = 0.308
	max_ammo_capacity = 30 // It's magazine-fed (Convair880).
	auto_eject = 1

	New()
		ammo = new/obj/item/ammo/bullets/ak47
		current_projectile = new/datum/projectile/bullet/ak47
		..()

/obj/item/gun/kinetic/ak47/vr
	icon = 'icons/effects/VR.dmi'

/obj/item/gun/kinetic/hunting_rifle
	name = "Old Hunting Rifle"
	desc = "A powerful antique hunting rifle."
	icon_state = "hunting_rifle"
	force = 10
	contraband = 8
	caliber = 0.308
	max_ammo_capacity = 30 // It's magazine-fed (Convair880).
	auto_eject = 1

	New()
		ammo = new/obj/item/ammo/bullets/rifle_3006
		current_projectile = new/datum/projectile/bullet/rifle_3006
		..()

/obj/item/gun/kinetic/hunting_rifle/vr
	icon = 'icons/effects/VR.dmi'

/obj/item/gun/kinetic/dart_rifle
	name = "Tranquilizer Rifle"
	desc = "A veterinary tranquilizer rifle chambered in .308 caliber."
	icon_state = "hunting_rifle"
	force = 10
	//contraband = 8
	caliber = 0.308
	max_ammo_capacity = 30 // It's magazine-fed (Convair880).
	auto_eject = 1

	New()
		ammo = new/obj/item/ammo/bullets/tranq_darts
		current_projectile = new/datum/projectile/bullet/tranq_dart
		..()

/obj/item/gun/kinetic/zipgun
	name = "Zip Gun"
	desc = "An improvised and unreliable gun."
	icon_state = "zipgun"
	force = 3
	contraband = 6
	caliber = null // use any ammo at all BA HA HA HA HA
	max_ammo_capacity = 2
	var/failure_chance = 6

	New()
		ammo = new/obj/item/ammo/bullets/derringer
		ammo.amount_left = 0 // start empty
		current_projectile = new/datum/projectile/bullet/derringer
		..()

	shoot()
		if(ammo && ammo.amount_left && current_projectile && current_projectile.caliber && current_projectile.power)
			failure_chance = max(10,min(33,round(current_projectile.caliber * (current_projectile.power/2))))
		if(canshoot() && prob(failure_chance)) // Empty zip guns had a chance of blowing up. Stupid (Convair880).
			var/turf/T = get_turf(src)
			explosion(src, T,-1,-1,1,2)
			qdel(src)
		else
			..()
			return

/obj/item/gun/kinetic/silenced_22
	name = "Suppressed .22 Pistol"
	desc = "A small pistol with an integrated flash and noise suppressor."
	icon_state = "silenced"
	w_class = 2
	silenced = 1
	force = 3
	contraband = 4
	caliber = 0.22
	max_ammo_capacity = 10
	auto_eject = 1

	New()
		ammo = new/obj/item/ammo/bullets/bullet_22
		current_projectile = new/datum/projectile/bullet/bullet_22
		..()

/obj/item/gun/kinetic/vgun
	name = "Virtual Pistol"
	desc = "This thing would be better if it wasn't such a piece of shit."
	icon_state = "railgun"
	force = 10.0
	contraband = 0
	max_ammo_capacity = 200

	New()
		ammo = new/obj/item/ammo/bullets/vbullet
		current_projectile = new/datum/projectile/bullet/vbullet
		..()

	shoot(var/target,var/start ,var/mob/user)
		var/turf/T = get_turf_loc(src)

		if (!istype(T.loc, /area/sim))
			boutput(user, "<span style=\"color:red\">You can't use the guns outside of the combat simulation, fuckhead!</span>")
			return
		else
			..()

/obj/item/gun/kinetic/flaregun
	desc = "A 12-gauge flaregun."
	name = "Flare Gun"
	icon_state = "flaregun"
	item_state = "flaregun"
	force = 5.0
	contraband = 2
	caliber = 0.72
	max_ammo_capacity = 1

	New()
		ammo = new/obj/item/ammo/bullets/flare/single
		current_projectile = new/datum/projectile/bullet/flare
		..()

/obj/item/gun/kinetic/riot40mm
	desc = "A 40mm riot control launcher."
	name = "Riot launcher"
	icon_state = "40mm"
	//item_state = "flaregun"
	force = 5.0
	contraband = 7
	caliber = 1.57
	max_ammo_capacity = 1

	New()
		ammo = new/obj/item/ammo/bullets/smoke/single
		current_projectile = new/datum/projectile/bullet/smoke
		..()

// Ported from old, non-gun RPG-7 object class (Convair880).
/obj/item/gun/kinetic/rpg7
	desc = "A rocket-propelled grenade launcher licensed by the Space Irish Republican Army."
	name = "MPRT-7"
	icon = 'icons/obj/gun.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_weapons.dmi'
	icon_state = "rpg7_empty"
	item_state = "rpg7_empty"
	w_class = 4
	throw_speed = 2
	throw_range = 4
	force = 5
	contraband = 8
	caliber = 1.58
	max_ammo_capacity = 1

	New()
		ammo = new /obj/item/ammo/bullets/rpg
		ammo.amount_left = 0 // Spawn empty.
		current_projectile = new /datum/projectile/bullet/rpg
		..()
		return

	update_icon()
		if (src.ammo.amount_left < 1)
			src.icon_state = "rpg7_empty"
			src.item_state = "rpg7_empty"
		else
			src.icon_state = "rpg7"
			src.item_state = "rpg7"
		return

	loaded
		New()
			..()
			ammo.amount_left = 1
			src.update_icon()
			return

/obj/item/gun/kinetic/coilgun_TEST
	name = "coil gun"
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "coilgun_2"
	item_state = "flaregun"
	force = 10.0
	contraband = 6
	caliber = 1.0
	max_ammo_capacity = 2

	New()
		ammo = new/obj/item/ammo/bullets/rod
		current_projectile = new/datum/projectile/bullet/rod
		..()

/obj/item/gun/kinetic/airzooka //This is technically kinetic? I guess?