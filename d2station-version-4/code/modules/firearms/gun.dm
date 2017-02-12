/obj/item/weapon/gun
	name = "gun"
	desc = "Its a gun. It's pretty terrible, though."
	icon = 'gun.dmi'
	icon_state = "detective"
	item_state = "gun"
	flags =  FPRINT | TABLEPASS | CONDUCT | ONBELT | USEDELAY
	m_amt = 2000
	w_class = 3.0
	throwforce = 5
	throw_speed = 4
	throw_range = 5
	force = 5.0//They now do the ave damage
	origin_tech = "combat=1"

	var
		fire_sound = 'Gunshot.ogg'
		obj/item/projectile/in_chamber
		calibre = ""	// In mm
		suppressed = 0
		badmin = 0
		recoil = 0				//How much the screen shakes when firing the gun
		burst_size = 1			//How many rounds are fired at once
		burst_delay = 0			//Amount of time between each burst round fire
		locked = ""				//Type of implant needed for weapon operation, "" = no implant
		jammable = 1			//For projectile guns. Set to 0 for revolvers, etc.
		jammed = 0				//For projectile guns. Set to 1 if you try to re-fire a spent casing
		spread = 0				//How wide projectiles can stray from the targeted tile

		allow_suppressor = 0						//If a suppressor can be attached
		obj/item/weapon/gunmod/suppressor/sprsr		//Attached suppressor
		sprsr_icon_name								//Name of suppressor overlay used
		obj/overlay/suppressor_icon = null			//Overlay used
		suppressor_x = 0
		suppressor_y = 0							//x and y pixel offsets for suppressor icon overlay

		allow_railmod = 0						//If a suppressor can be attached
		obj/item/weapon/gunmod/rail/railmod		//Attached suppressor
		railmod_icon_name								//Name of suppressor overlay used
		obj/overlay/railmod_icon = null			//Overlay used
		railmod_x = 0
		railmod_y = 0							//x and y pixel offsets for suppressor icon overlay

	proc
		load_into_chamber()
		badmin_ammo()
		special_check(var/mob/M)
		eject_casing()


	load_into_chamber()
		in_chamber = new /obj/item/projectile/weakbullet(src)
		return 1


	badmin_ammo() //CREEEEEED!!!!!!!!!
		switch(badmin)
			if(1)
				in_chamber = new /obj/item/projectile/electrode(src)
			if(2)
				in_chamber = new /obj/item/projectile/weakbullet(src)
			if(3)
				in_chamber = new /obj/item/projectile(src)
			if(4)
				in_chamber = new /obj/item/projectile/beam(src)
			if(5)
				in_chamber = new /obj/item/projectile/beam/pulse(src)
			else
				return 0
		if(!istype(src, /obj/item/weapon/gun/energy))
			var/obj/item/ammo_casing/AC = new(get_turf(src))
			AC.name = "bullet casing"
			AC.desc = "This casing has the NT Insignia etched into the side."
		return 1


	special_check(var/mob/M) //Placeholder for any special checks, like detective's revolver.
		return 1


	emp_act(severity)
		for(var/obj/O in contents)
			O.emp_act(severity)


	eject_casing()
		return


	attack(mob/M as mob, mob/living/user as mob)
		if(user.a_intent == "hurt")
			add_fingerprint(user)

			if(locked)
				if (istype(src.loc, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = user
					var/list/implants = list() //Checking for a certain implant.
					for(var/obj/item/weapon/implant/W in H)
						if(locked == "[W.type]")
							implants += W
					if(!implants.len)
						var/datum/effects/system/spark_spread/s = new /datum/effects/system/spark_spread
						s.set_up(2, 1, H.loc)
						s.start()
						H.stunned += 3
						H.weakened += 3
						H << "\red The gun zaps you!"
						return

			if(badmin)
				badmin_ammo()
			else if(!special_check(user))
				return
			else if(!load_into_chamber())
				user << "\red *click* *click*"
				for(var/mob/O in oviewers(M, null))
					if(O.client)	O.show_message(text("\red <B>[] tries to shoot [] point-blank, but the [] is empty!</B>", user, M, name), 1)
				return

			var/guncalibre = text2num(calibre)
			if(!guncalibre)
				guncalibre = 0

			pblank_loop:

				sleep(burst_delay)

				var/temp_burst_size
				if(istype(src, /obj/item/weapon/gun/projectile) && burst_size > 1)
					temp_burst_size = burst_size - 1
				else
					temp_burst_size = burst_size

				for(var/i = 0; i < temp_burst_size; i++)

					if(suppressed)
						playsound(user, fire_sound, 5, 1)
						playsound(user, 'Gunshot_distant.ogg', 100, 1, 2 )
					else
						playsound(user, fire_sound, 50, 1)
						playsound(user, 'Gunshot_distant.ogg', 100, 0, 15 )

					if(istype(user, /mob/living/carbon/human) && guncalibre >= 5.6 && !suppressed)
						if(!istype(user:ears, /obj/item/clothing/ears/earmuffs) || istype(user.loc, /turf/space))
							user << "\red Your ears ring!"
							user.ear_damage += 5
							user.ear_deaf += 1

					if(istype(M, /mob/living/carbon/human) && guncalibre >= 5.6 && !suppressed)
						if(!istype(M:ears, /obj/item/clothing/ears/earmuffs) || istype(user.loc, /turf/space))
							M << "\red Your ears ring!"
							M.ear_damage += 5
							M.ear_deaf += 1

					for(var/mob/O in viewers(M, null))
						if(!istype(user.loc, /turf/space))
							if(in_chamber.def_zone)
								if(O.client)	O.show_message(text("\red <B>[] has been shot point-blank in the [] by []!</B>", M, in_chamber.def_zone, user), 1, "\red You hear a gunshot", 2)
							else
								if(O.client)	O.show_message(text("\red <B>[] has been shot point-blank by []!</B>", M, user), 1, "\red You hear a gunshot", 2)

					if(istype(src, /obj/item/weapon/gun/projectile))
						eject_casing()

					M.bullet_act(in_chamber)
					sleep(1)
					del(in_chamber)
					in_chamber = null
					update_icon()

					if(burst_size > 1)
						if(badmin)
							badmin_ammo()
						else if(!special_check(user))
							return
						else if(!load_into_chamber())
							user << "\red *click* *click*";
							return
						continue pblank_loop
		else
			..()
		return


	afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag)
		if (flag)
			return // placing gun on a table or in backpack
		if(istype(target, /obj/machinery/recharger) && istype(src, /obj/item/weapon/gun/energy))
			return
		if(istype(user, /mob/living))
			var/mob/living/M = user
			if ((M.mutations & CLOWN) && prob(50))
				if(istype(in_chamber, /obj/item/projectile))
					in_chamber.firer = user
					in_chamber.def_zone = "head"
					user.bullet_act(in_chamber)
					del(in_chamber)
					update_icon()
					M << "\red The [name] fires into your own head!"
					return

		if(locked)
			if (istype(src.loc, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = user
				var/list/implants = list() //Checking for a certain implant.
				for(var/obj/item/weapon/implant/W in H)
					if(locked == "[W.type]")
						implants += W
				if(!implants.len)
					var/datum/effects/system/spark_spread/s = new /datum/effects/system/spark_spread
					s.set_up(2, 1, H.loc)
					s.start()
					H.stunned += 3
					H.weakened += 3
					H << "\red The gun zaps you!"
					return

		if(badmin)
			badmin_ammo()
		else if(!special_check(user))
			return
		else if(!load_into_chamber())
			user << "\red *click* *click*";
			return
		else if(jammed)
			user << "\red The [src.name] is jammed!";
			return

		add_fingerprint(user)

		var/turf/curloc = user.loc
		var/turf/targloc = get_turf(target)
		if (!istype(targloc) || !istype(curloc))
			return

		var/guncalibre = text2num(calibre)		// For deafening check
		if(!guncalibre)
			guncalibre = 0

		burst_loop:

			sleep(burst_delay)

			if(istype(src, /obj/item/weapon/gun/projectile/shotgun))//TODO: Get this out of here, parent objects should check child types as little as possible
				var/obj/item/weapon/gun/projectile/shotgun/S = src
				if(S.pumped >= S.maxpump)
					S.pump()
					return

			if(istype(src, /obj/item/weapon/gun/energy/phaser))
				var/obj/item/weapon/gun/energy/phaser/P = src
				in_chamber:radius = P.radius
				in_chamber:power = P.power
				in_chamber:loaded_effect = P.loaded_effect

			if(istype(src, /obj/item/weapon/gun/energy/freeze))
				var/obj/item/projectile/freeze/F = in_chamber
				var/obj/item/weapon/gun/energy/freeze/Fgun = src
				F.temperature = Fgun.temperature

			if(istype(src, /obj/item/weapon/gun/energy/ep90))
				var/obj/item/projectile/ep90electrode/E = in_chamber
				var/obj/item/weapon/gun/energy/ep90/EPgun = src
				E.aoe = EPgun.aoe
				if(E.aoe)
					E.bump_at_ttile = 1

			if(istype(in_chamber, /obj/item/weapon/chem_grenade))
				in_chamber.attack_self(user)
				in_chamber.loc = get_turf(user)
				in_chamber.throw_at(targloc, 8, 2)
				in_chamber = null
		/*	if(istype(in_chamber, /obj/item/ammo_casing/shotgun/scatter))
				//New()
				for(var/i = 1, i<= gibtypes.len, i++)
					if(gibamounts[i])
						for(var/j = 1, j<= gibamounts[i], j++)
							var/gibType = gibtypes[i]
								gib = new gibType(location)
				//trying so hard in various ways to get scatter to work but its pointless
				new /obj/item/ammo_casing/shotgun/scatter(src)
					pixel_x = rand(-10.0, 10)
					pixel_y = rand(-10.0, 10)
					dir = pick(cardinal)
						..()*/
		//	if(istype(in_chamber, /obj/item/ammo_casing/shotgun/scatter))//spread seems to be handled by guns, so fuck moving it over, work arounds. -Nernums
		//		spread=1 //this is for shotguns
			//naturally my work around didnt work -Nernums

			var/temp_burst_size
//			if(istype(src, /obj/item/weapon/gun/projectile) && burst_size > 1)
//				temp_burst_size = burst_size
//			else
			temp_burst_size = burst_size

			for(var/i = 0; i < temp_burst_size; i++)

				if(!in_chamber)
					return

				if(suppressed)
					playsound(user, fire_sound, 5, 1)
				else
					playsound(user, fire_sound, 50, 1)

				if(prob(10))
					if(istype(user, /mob/living/carbon/human) && guncalibre >= 5.6 && !suppressed)
						if(!istype(user:ears, /obj/item/clothing/ears/earmuffs) || istype(user.loc, /turf/space))
							user << "\red Your ears ring!"
							user.ear_damage += 1
							user.ear_deaf += 1

				if(istype(in_chamber, /obj/item/projectile))
					in_chamber.firer = user
					in_chamber.def_zone = user.get_organ_target()

				if(targloc == curloc)
					user.bullet_act(in_chamber)
					del(in_chamber)
					update_icon()
					return
	//			if(istype(in_chamber, /obj/item/ammo_casing/shotgun/scatter))//spread seems to be handled by guns, so fuck moving it over, work arounds. -Nernums
	//				spread=1 //this is for shotguns
			//naturally my work around didnt work -Nernums
				if(spread)
					var/list/posstargs = list()
					for(var/turf/T in range(spread,get_turf(target)))
						posstargs += T
					targloc = pick(posstargs)

				if(recoil)
					spawn()
						shake_camera(user, recoil + 1, recoil)

				if(istype(in_chamber, /obj/item/projectile))
					in_chamber.original = targloc
					in_chamber.loc = get_turf(user)
					user.next_move = world.time + 4
					in_chamber.suppressed = suppressed
					in_chamber.current = curloc
					in_chamber.yo = targloc.y - curloc.y
					in_chamber.xo = targloc.x - curloc.x

					spawn()
						in_chamber.process()
				sleep(1)
				in_chamber = null

				if(istype(src, /obj/item/weapon/gun/projectile))
					eject_casing()

				update_icon()

				if(burst_size > 1)
					if(badmin)
						badmin_ammo()
					else if(!special_check(user))
						return
					else if(!load_into_chamber())
						user << "\red *click* *click*";
						return
					continue burst_loop

		if(istype(src, /obj/item/weapon/gun/projectile/shotgun))
			var/obj/item/weapon/gun/projectile/shotgun/S = src
			S.pumped++
		return



/obj/item/weapon/gun/projectile
	name = "revolver"
	desc = "A classic revolver. Uses .357 ammo."
	icon_state = "revolver"
	calibre = "9.1"
	origin_tech = "combat=2;materials=2;syndicate=6"
	w_class = 3.0
	m_amt = 1000

	var
		list/loaded = list()
		max_shells = 7
		load_method = 0 //0 = Single shells or quick loader, 1 = magazine
		obj/item/ammo_magazine/loaded_magazine
		obj/item/ammo_casing/chambered_casing

		// Shotgun variables
		pumped = 0
		maxpump = 1
		list/Storedshots = list()

	load_into_chamber()

		if(istype(src, /obj/item/weapon/gun/projectile/shotgun) && pumped >= maxpump)
			return 1

		if(in_chamber)
			return 1

		if(reliability > -1)
			if(prob(60)) reliability--
			if(jammable && !jammed)
				if(prob(1))
					jammed = 1

		if(load_method && loaded_magazine)
			if(loaded_magazine.stored_ammo.len)
				var/obj/item/ammo_casing/AMC = loaded_magazine.stored_ammo[1]
				loaded_magazine.stored_ammo -= AMC	//Remove the casing from the magazine
				loaded += AMC
				AMC.loc = src						//Move the casing from the magazine to the gun
				chambered_casing = AMC
				loaded_magazine.update_icon()
				if(chambered_casing.spent && jammable && !jammed)
					jammed = 1
				if(AMC.BB)
					in_chamber = AMC.BB //Load projectile into chamber.
					AMC.BB.loc = src	//Set projectile loc to gun.
					return 1

		if(!load_method)
			if(loaded.len)
				var/obj/item/ammo_casing/AC = loaded[1]
				chambered_casing = AC
				if(chambered_casing.spent && jammable && !jammed)
					jammed = 1
				if(AC.BB)
					in_chamber = AC.BB		//Load projectile into chamber.
					AC.BB.loc = src			//Set projectile loc to gun.
					return 1

		if(!loaded.len)
			if(Storedshots.len > 0)
				if(istype(src, /obj/item/weapon/gun/projectile/shotgun))
					var/obj/item/weapon/gun/projectile/shotgun/S = src
					S.pump(loc)
			return 0

		else
			return 0

	eject_casing()
		if(loaded.len)
			var/obj/item/ammo_casing/AC = chambered_casing //target top casing in list.
			loaded -= AC //Remove casing from loaded list.
			AC.spent = 1
			if(!istype(src, /obj/item/weapon/gun/projectile/shotgun))
				AC.loc = get_turf(src)	//Eject casing onto ground.
			else
				Storedshots += AC
			chambered_casing = null

	New()
		for(var/i = 1, i <= max_shells, i++)
			loaded += new /obj/item/ammo_casing(src)
		update_icon()

	attackby(var/obj/item/A as obj, mob/user as mob)
		var/num_loaded = 0
		if(istype(A, /obj/item/ammo_box) && !load_method)
			var/obj/item/ammo_box/AB = A
			for(var/obj/item/ammo_casing/AC in AB.stored_ammo)
				if(loaded.len >= max_shells)
					break
				if(AC.calibre == calibre && loaded.len < max_shells)
					AC.loc = src
					AB.stored_ammo -= AC
					loaded += AC
					num_loaded++
		else if(istype(A, /obj/item/ammo_casing) && !load_method)
			var/obj/item/ammo_casing/AC = A
			if(AC.calibre == calibre && loaded.len < max_shells)
				user.drop_item()
				AC.loc = src
				loaded += AC
				num_loaded++
		else if(istype(A, /obj/item/ammo_magazine) && load_method && !loaded_magazine)
			var/obj/item/ammo_magazine/AM = A
			if(AM.calibre == calibre)
				user.drop_item()
				AM.loc = src
				loaded_magazine = AM
				user << text("\blue You load the [] into the []!", AM.name, name)
				playsound(src, 'insert_mag.ogg', 60, 1)
			else
				user << text("\blue You can't fit the [] into the []!", AM.name, name)
		else if(istype(A, /obj/item/weapon/gunmod/suppressor) && allow_suppressor && !sprsr)
			var/obj/item/weapon/gunmod/suppressor/AS = A
			if(calibre == AS.calibre)
				user.drop_item()
				AS.loc = src
				sprsr = AS
				suppressed = 1
				suppressor_icon = new /obj/overlay(  )
				suppressor_icon.icon = 'gun.dmi'
				suppressor_icon.icon_state = "[sprsr_icon_name]"
				suppressor_icon.pixel_x = suppressor_x
				//suppressor_icon = new/icon('gun.dmi', "[sprsr_icon_name]")
				//suppressor_icon.Shift(EAST,suppressor_x)
				user << text("\blue You screw the [] onto the []'s barrel.", AS.name, name)
			else
				user << text("\red The [] does not fit on the []'s barrel.", AS.name, name)
		else if(istype(A, /obj/item/weapon/card/emag) && locked)
			locked = ""
			user << text("\red You short out the implant lock on the []!", name)
		if(num_loaded)
			user << text("\blue You load [] shell\s into the []!", num_loaded, name)
		A.update_icon()
		update_icon()
		return

	attack_hand(mob/user as mob)
		if(user.r_hand == src || user.l_hand == src)
			if(jammed)
				jammed = 0
				user << text("\blue You eject the jammed casing.")
				eject_casing()
				return
			if(sprsr && !loaded_magazine)
				sprsr.loc = user
				if(user.hand)
					user.l_hand = sprsr
				else
					user.r_hand = sprsr
				user << text("\blue You unscrew the [] from the []'s barrel.", sprsr.name, name)
				sprsr.layer = 20
				sprsr = null
				suppressor_icon = null
				suppressed = 0
				update_icon()
				return
			if(loaded_magazine)
				loaded_magazine.loc = user
				if(user.hand)
					user.l_hand = loaded_magazine
				else
					user.r_hand = loaded_magazine
				user << text("\blue You unload the [].", name)
				playsound(src, 'eject_mag.ogg', 60, 1)
				loaded_magazine.layer = 20
				loaded_magazine = null
				update_icon()
		else
			return ..()

	update_icon()
		overlays = null
		icon_state = text("[]", initial(icon_state))
		if(load_method && loaded_magazine)
			desc = initial(desc) + text(" Has [] rounds remaining.", loaded.len + loaded_magazine.stored_ammo.len)
			icon_state = text("[]_mag[]", initial(icon_state), loaded_magazine.max_ammo)
		else
			desc = initial(desc) + text(" Has [] rounds remaining.", loaded.len)
			icon_state = text("[]", initial(icon_state))
		if(sprsr)
			overlays = list(suppressor_icon)
			item_state = "[initial(item_state)]-suppressed"
		//else
		//	overlays = initial(overlays)
		//	item_state = "[initial(item_state)]"

/obj/item/weapon/gun/energy
	icon_state = "energy"
	name = "energy gun"
	desc = "A basic energy-based gun with two settings: Stun and kill."
	fire_sound = 'Taser.ogg'
	calibre = "energy"
	var
		var/obj/item/ammo_magazine/energy/power_supply
		var/removable_mag = 0
		mode = 0 //0 = stun, 1 = kill
		charge_cost = 100 //How much energy is needed to fire.

	emp_act(severity)
		power_supply.use(round(power_supply.maxcharge / severity))
		update_icon()
		..()

	New()
		power_supply = new(src)
		power_supply.give(power_supply.maxcharge)

	load_into_chamber()
		if(in_chamber)
			return 1
		if(!power_supply)
			return 0
		if(power_supply.charge < charge_cost)
			return 0
		switch (mode)
			if(0)
				in_chamber = new /obj/item/projectile/electrode(src)
			if(1)
				in_chamber = new /obj/item/projectile/beam(src)
		power_supply.use(charge_cost)
		return 1

	attack_self(mob/living/user as mob)
		switch(mode)
			if(0)
				mode = 1
				charge_cost = 100
				fire_sound = 'Laser.ogg'
				user << "\red [src.name] is now set to kill."
			if(1)
				mode = 0
				charge_cost = 100
				fire_sound = 'Taser.ogg'
				user << "\red [src.name] is now set to stun."
		update_icon()
		return

	attack_hand(mob/user as mob)
		if(user.r_hand == src || user.l_hand == src)
			if(power_supply && removable_mag)
				power_supply.loc = user
				if(user.hand)
					user.l_hand = power_supply
				else
					user.r_hand = power_supply
				user << text("\blue You unload the [].", name)
				playsound(src, 'eject_mag.ogg', 60, 1)
				power_supply.layer = 20
				power_supply = null
				update_icon()
		else
			return ..()

	attackby(var/obj/item/A as obj, mob/user as mob)
		if(istype(A, /obj/item/weapon/card/emag) && locked)
			locked = ""
			user << "\red You short out the implant lock on the gun!"
		else if(istype(A, /obj/item/ammo_magazine/energy) && removable_mag && !power_supply)
			var/obj/item/ammo_magazine/energy/EM = A
			if(EM.calibre == calibre)
				user.drop_item()
				EM.loc = src
				power_supply = EM
				user << text("\blue You load the [] into the []!", EM.name, name)
				playsound(src, 'insert_mag.ogg', 60, 1)
		else if(istype(A, /obj/item/weapon/gunmod/suppressor) && allow_suppressor && !sprsr)
			var/obj/item/weapon/gunmod/suppressor/AS = A
			if(calibre == AS.calibre)
				user.drop_item()
				AS.loc = src
				sprsr = AS
				suppressed = 1
				suppressor_icon = new /obj/overlay(  )
				suppressor_icon.icon = 'gun.dmi'
				suppressor_icon.icon_state = "[sprsr_icon_name]"
				suppressor_icon.pixel_x = suppressor_x
				//suppressor_icon = new/icon('gun.dmi', "[sprsr_icon_name]")
				//suppressor_icon.Shift(EAST,suppressor_x)
				user << text("\blue You screw the [] onto the []'s barrel.", AS.name, name)
			else
				user << text("\red The [] does not fit on the []'s barrel.", AS.name, name)
		update_icon()

	update_icon()
		var/ratio = power_supply.charge / power_supply.maxcharge
		ratio = round(ratio, 0.25) * 100
		icon_state = text("[][]", initial(icon_state), ratio)
		if(sprsr)
			overlays = list(suppressor_icon)
			item_state = "[initial(item_state)]-suppressed"
		else
			overlays = initial(overlays)
			item_state = "[initial(item_state)]"

