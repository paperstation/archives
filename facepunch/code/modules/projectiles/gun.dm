/obj/item/weapon/gun
	name = "gun"
	desc = "Its a gun. It's pretty terrible, though."
	icon = 'icons/obj/gun.dmi'
	icon_state = "detective"
	item_state = "gun"
	flags =  FPRINT | TABLEPASS | CONDUCT |  USEDELAY
	slot_flags = SLOT_BELT
	m_amt = 2000
	w_class = 3.0
	force = DAMAGE_LOW
	origin_tech = "combat=1"
	attack_verb = list("struck", "hit", "bashed")

	var/fire_sound = 'sound/weapons/Gunshot.ogg'
	var/obj/item/projectile/in_chamber = null
	var/caliber = ""
	var/silenced = 0
	var/recoil = 0
	var/rateoffire = 4 // ,4 seconds by default
	//Weapon lock, based upon implants, Loyalty and Explosive implants will allow a user to pass the check
	var/locked = -1//-1=cant, 0=none, 1=loyalty, 2=explosive, 3=ass
	//Access to unlock the gun, might change this to armory later
	#ifdef NEWMAP
	req_access = list(access_sec_gear_area)
	#else
	req_access = list(access_brig)
	#endif



	examine()
		..()
		if(locked > 0)
			usr << "\blue Has a level [locked] weapon lock."
		else if(!locked)
			usr << "\blue Weapon lock is disengaged."
		return


	attackby(obj/item/W as obj, mob/living/user as mob)
		if(!istype(W) || !istype(user))
			return
		if(istype(W, /obj/item/weapon/card/emag) && locked != -1)
			user.visible_message("\red [user] breaks the weapon lock on [src] with [W]!")
			locked = -1
			return
		if(istype(W, /obj/item/weapon/card/id) || istype(W, /obj/item/device/pda))
			if(locked == -1)
				user << "\blue This weapon does not appear to have a weapon lock."
				return
			if(!src.allowed(user))
				user << "\red Access Denied."
				return
			if(locked > 1)
				user << "\red You are unable to clear the weapon lock!"//Higher level locked weapons cant be toggled
				return
			else if(locked == 1)
				locked = 0
			else if(!locked)
				locked = 1
			user << "\blue You [locked?"":"un"]lock [src]."
			return
		..()
		return


	proc/load_into_chamber()
		return 0


	proc/special_check(var/mob/living/user)
		if((CLUMSY in user.mutations) && prob(50))
			user << "<span class='danger'>You hurt yourself with the [src].</span>"
			user.deal_damage(20, BURN, PIERCE)
			user.drop_item()
			return 0

		if(!user.IsAdvancedToolUser())
			user << "\red You don't have the dexterity to do this!"
			return
		if(HULK in user.mutations)
			user << "\red Your meaty finger is much too large for the trigger guard!"
			return 0

		if(user.dna && user.dna.mutantrace == "adamantine")
			user << "\red Your metal fingers don't fit in the trigger guard!"
			return 0

		if(locked > 0)
			if(istype(user,/mob/living/silicon))
				return 1//Borgs beat locks
			for(var/obj/item/weapon/implant/I in user)
				if(istype(I, /obj/item/weapon/implant/loyalty))
					if(locked == 1)
						return 1
				if(istype(I, /obj/item/weapon/implant/explosive))
					var/obj/item/weapon/implant/explosive/E = I
					if(locked <= E.weapon_level)
						return 1
			if(locked >= 3)
				user << "\red Access Denied"
				playsound(user, 'sound/weapons/Egloves.ogg', 50, 1)
				if(istype(user,/mob/living/carbon/human))
					var/mob/living/carbon/human/H = user
					if(H.gloves && !H.gloves:siemens_coefficient)
						return 0//coeff of 0 blocks shocks
					H.deal_damage(2, WEAKEN)
			else
				user << "\red Access Denied"
				playsound(user, 'sound/machines/buzz-sigh.ogg', 50, 1)
			return 0
		return 1



	emp_act(severity)
		for(var/obj/O in contents)
			O.emp_act(severity)


	afterattack(atom/target as mob|obj|turf, mob/living/user as mob|obj, flag, params)//TODO: go over this
		if(flag)	return //we're placing gun on a table or in backpack
		if(istype(target, /obj/machinery/recharger) && istype(src, /obj/item/weapon/gun/energy))	return//Shouldnt flag take care of this?

		add_fingerprint(user)
		var/turf/curloc = user.loc
		var/turf/targloc = get_turf(target)
		if (!istype(targloc) || !istype(curloc))
			return
		if(!special_check(user))

			return
		fire(user, targloc, curloc,target)
		return

	proc/fire(var/mob/living/user, var/turf/targloc, var/turf/curloc, var/atom/target)
		if(!load_into_chamber())
			user << "\red *click*"
			playsound(user, 'sound/weapons/empty.wav', 50, 1)
			return

		if(!in_chamber)
			return

		in_chamber.firer = user
		in_chamber.def_zone = user.zone_sel.selecting


		if(targloc == curloc)
			user.bullet_act(in_chamber)
			del(in_chamber)
			update_icon()
			return

		if(recoil)
			spawn()
				shake_camera(user, recoil + 1, recoil)

		if(silenced)
			playsound(user, fire_sound, 10, 1)
		else
			var/turf/source = get_turf(src)
			var/far_dist = 0
			for(var/mob/M in hearers(15, source))
				var/turf/M_turf = get_turf(M)
				if(M_turf && M_turf.z == source.z)
					var/dist = get_dist(M_turf, source)
					var/far_volume = Clamp(far_dist, 30, 50) // Volume is based on explosion size and dist
					far_volume += (dist <= far_dist * 0.5 ? 50 : 0) // add 50 volume if the mob is pretty close to the explosion
					M.playsound_local(source, fire_sound, far_volume, 1, 1, falloff = 5)
			user.visible_message("<span class='warning'>[user] fires [src]!</span>", "<span class='warning'>You fire [src]!</span>", "You hear a [istype(in_chamber, /obj/item/projectile/beam) ? "laser blast" : "gunshot"]!")

		in_chamber.original = target
		in_chamber.loc = get_turf(user)
		in_chamber.starting = get_turf(user)
		in_chamber.shot_from = src
		user.next_move = world.time + rateoffire
		in_chamber.silenced = silenced
		in_chamber.current = curloc
		in_chamber.yo = targloc.y - curloc.y
		in_chamber.xo = targloc.x - curloc.x

		spawn()
			if(in_chamber)
				in_chamber.process()
		sleep(1)
		in_chamber = null

		update_icon()

		if(user.hand)
			user.update_inv_l_hand()
		else
			user.update_inv_r_hand()

