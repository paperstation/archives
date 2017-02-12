/*
CONTAINS:
PROJECTILE DEFINES
PULSE RIFLE
357 AMMO
38 AMMO
SHOTGUN SHELLS
SHOTGUN
REVOLVER
DETECTIVES REVOLVER
LASER GUN
TASER GUN
CROSSBOW
ALIEN SPIT
TELEPORT GUN

*/

/var/const/PROJECTILE_TASER = 1
/var/const/PROJECTILE_LASER = 2
/var/const/PROJECTILE_BULLET = 3
/var/const/PROJECTILE_PULSE = 4
/var/const/PROJECTILE_BOLT = 5
/var/const/PROJECTILE_WEAKBULLET = 6
/var/const/PROJECTILE_TELEGUN = 7
/var/const/PROJECTILE_PLASMA = 8
/var/const/PROJECTILE_MAGNET = 9
/var/const/PROJECTILE_DART = 10


// PULSE RIFLE

/obj/item/weapon/gun/energy/pulse_rifle
	name = "pulse rifle"
	desc = "A heavy-duty, pulse-based energy weapon preferred by front-line combat personnel."
	icon_state = "pulse"
	force = 15
	origin_tech = "combat=7;magnets=7"
	var/mode = 1//I guess I'll leave this here in case another mode to the weapon is added./N

	afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
		if ((user.mutations & 16) && prob(50))
			usr << "\red The pulse rifle blows up in your face."
			usr.fireloss += 20
			usr.drop_item()
			del(src)
			return
		if (flag)
			return
		if ((!istype(user, /mob/living/carbon/human)) && ticker.mode != "monkey")
			usr << "\red You don't have the dexterity to do this!"
			return

		src.add_fingerprint(user)

		var/turf/curloc = user.loc
		var/atom/targloc = get_turf(target)
		if (!targloc || !istype(targloc, /turf) || !curloc)
			return
		if (targloc == curloc)
			user.bullet_act(PROJECTILE_PULSE, src, user.get_organ_target())
			return

		var/obj/beam/a_laser/A = new /obj/beam/a_laser/pulse_laser(user.loc)
		playsound(user, 'pulse.ogg', 50, 1)
		A.def_zone = user.get_organ_target()
		A.current = curloc
		A.yo = targloc.y - curloc.y
		A.xo = targloc.x - curloc.x
		user.next_move = world.time + 4
		spawn()
			A.process()
		return

/obj/item/weapon/gun/energy/pulse_rifle/attack(mob/M as mob, mob/user as mob)
	..()
	/*
	src.add_fingerprint(user)
	var/mob/living/carbon/human/H = M

	if ((istype(H, /mob/living/carbon/human) && istype(H, /obj/item/clothing/head) && H.flags & 8 && prob(80)))
		M << "\blue The helmet protects you from being hit hard in the head!"
		for(var/mob/O in viewers(M, null))
			if(O.client)
				O.show_message(text("\red <B>[] blocked a hit from []!</B>", M, user), 1)
		return
	else
		var/time = rand(20, 60)
		if (prob(90))
			M.paralysis = max(time, M.paralysis)
		else
			M.weakened = max(time, M.weakened)
		src.force = 35
		..()
		if(M.stat != 2)	M.stat = 1
		for(var/mob/O in viewers(M, null))
			if(O.client)
				O.show_message(text("\red <B>[] has been rifle butted by []!</B>", M, user), 1, "\red You hear someone fall.", 2)
	return
	*/
// AMMO


/obj/item/weapon/ammo/update_icon()
	return


// .357

/obj/item/weapon/ammo/a357/update_icon()
	src.icon_state = text("357-[]", src.amount_left)
	src.desc = text("There are [] bullet\s left!", src.amount_left)
	return


// .38

/obj/item/weapon/ammo/a38/update_icon()
	src.desc = text("There are [] bullet\s left!", src.amount_left)
	if(src.amount_left > 0)
		src.icon_state = text("38-[]", src.amount_left)
	else
		src.icon_state = "speedloader_empty"

// 5.7x28mm

/obj/item/weapon/ammo/fiveseven/update_icon()
	src.icon_state = text("5-7_[]", src.amount_left)
	if(src.amount_left > 0)
		src.desc = text("There are [] bullet\s left!", src.amount_left)
	else
		src.icon_state = "5-7_empty"

// REVOLVER

/obj/item/weapon/gun/revolver/examine()
	set src in usr

	src.desc = text("There are [] bullet\s left! Uses 357.", src.bullets)
	..()
	return

obj/item/weapon/gun/revolver/attackby(obj/item/weapon/ammo/a357/A as obj, mob/user as mob)
	..()
	if (istype(A, /obj/item/weapon/ammo/a357))
		if (src.bullets >= 7)
			user << "\blue It's already fully loaded!"
			return 1
		if (A.amount_left <= 0)
			user << "\red There is no more bullets!"
			return 1
		if (A.amount_left < (7 - src.bullets))
			src.bullets += A.amount_left
			user << text("\red You reload [] bullet\s!", A.amount_left)
			A.amount_left = 0
		else
			user << text("\red You reload [] bullet\s!", 7 - src.bullets)
			A.amount_left -= 7 - src.bullets
			src.bullets = 7
		A.update_icon()
		return 1
	return

/obj/item/weapon/gun/revolver/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
	if (flag)
		return
	if ((istype(user, /mob/living/carbon/monkey)) && ticker.mode != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return
	src.add_fingerprint(user)
	if (src.bullets < 1)
		user.show_message("\red *click* *click*", 2)
		return
	var/S = user.loc
	if (!( istype(S, /turf/space) ))
		playsound(user, 'Magnum.ogg', 100, 0)
		//world << sound('Magnum_distant.ogg', volume=100)
	for(var/mob/O in viewers(user, null))
		O.show_message(text("\red <B>[] fires a revolver at []!</B>", user, target), 1, "\red You hear a gunshot", 2)
		if (istype(user, /mob/living/carbon/human))
			if (!istype(user:ears, /obj/item/clothing/ears/earmuffs))
				user << "\red Your ears ring!"
				user.ear_damage += 5
				user.ear_deaf += 1
	src.bullets--
	var/turf/T = user.loc
	var/turf/U = (istype(target, /atom/movable) ? target.loc : target)
	if ((!( U ) || !( T )))
		return
	while(!( istype(U, /turf) ))
		U = U.loc
	if (!( istype(T, /turf) ))
		return
	if (U == T)
		user.bullet_act(PROJECTILE_BULLET, src, user.get_organ_target())
		return
	var/obj/bullet/A = new /obj/bullet( user.loc )
	if (!istype(U, /turf))
		del(A)
		return
	A.def_zone = user.get_organ_target()
	A.current = U
	A.yo = U.y - T.y
	A.xo = U.x - T.x
	user.next_move = world.time + 4
	spawn( 0 )
		A.process()
		return
	return

/obj/item/weapon/gun/revolver/attack(mob/M as mob, mob/user as mob)
	if ((user.a_intent == "hurt" && src.bullets > 0))
		playsound(user, 'Gunshot.ogg', 100, 1)
		for(var/mob/O in viewers(M, null))
			if(O.client)	O.show_message(text("\red <B>[] has been shot point-blank by []!</B>", M, user), 1, "\red You hear a gunshot", 2)
		if (istype(user, /mob/living/carbon/human))
			if (!istype(user:ears, /obj/item/clothing/ears/earmuffs))
				user << "\red Your ears ring!"
				user.ear_damage += 5
				user.ear_deaf += 1
		if (istype(M, /mob/living/carbon/human))
			if (!istype(M:ears, /obj/item/clothing/ears/earmuffs))
				M << "\red Your ears ring!"
				M.ear_damage += 5
				M.ear_deaf += 1
		M.bullet_act(PROJECTILE_BULLET, src, user.get_organ_target())
		src.bullets--
	else
		..()
	return




// SHOTGUN

/obj/item/weapon/gun/shotgun/examine()
	set src in usr

	if(src.name == "shotgun" || src.name == "combat shotgun")
		src.desc = text("There are [src.index] shell\s left!") //no need to mention what shells are used, we have only one type of them

	..()

	return

//0, not loaded. 1, beanbag, 2, 12gauge, 3, blank, 4, dart.

/obj/item/weapon/gun/shotgun/attackby(obj/item/weapon/A as obj, mob/user as mob)
	..()
	if (istype(A, /obj/item/weapon/ammo/shell/beanbag))
		if (index == src.shellsmax || shellsunlimited >= 1) //...than sorry.
			user << "\blue It's already fully loaded!"
			return 1
		else
			user << "\blue You load the shell into the shotgun."
			index++
			src.shells.len = index
			del(A)
			src.shells[index] = 1
			return 1
		return 1

	else if (istype(A, /obj/item/weapon/ammo/shell/gauge))
		if (index == src.shellsmax || shellsunlimited >= 1)
			user << "\blue It's already fully loaded!"
			return 1
		else
			user << "\blue You load the shell into the shotgun."
			index++
			src.shells.len = index
			del(A)
			src.shells[index] = 2
			return 1
		return 1

	else if (istype(A, /obj/item/weapon/ammo/shell/blank))
		if (index == src.shellsmax || shellsunlimited >= 1)
			user << "\blue It's already fully loaded!"
			return 1
		else
			user << "\blue You load the shell into the shotgun."
			index++
			src.shells.len = index
			del(A)
			src.shells[index] = 3
			return 1
		return 1
	else if (istype(A, /obj/item/weapon/ammo/shell/dart))
		if (index == src.shellsmax || shellsunlimited >= 1)
			user << "\blue It's already fully loaded!"
			return 1
		else
			user << "\blue You load the dart into the shotgun."
			index++
			src.shells.len = index
			del(A)
			src.shells[index] = 4
			return 1
		return 1
	return 1

/obj/item/weapon/gun/shotgun/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
	if (flag)
		return
	if ((istype(user, /mob/living/carbon/monkey)) && ticker.mode != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return
	if (src.pumped == 0)
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red <B>[] pumps the [src.name]!</B>", user), 1, "\red You hear pumping", 2)
			playsound(user, 'shotgunpump.ogg', 100, 0)
			src.pumped = 1
			return
	src.add_fingerprint(user)
	if (!index && !shellsunlimited)
		user.show_message("\red *click* *click*", 2)
		return
	var/S = user.loc
	if (!( istype(S, /turf/space) ))
		playsound(user, 'shotgun_shot.ogg', 100, 0)
		//world << sound('shotgun_distant.ogg', volume=100)
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red <B>[] fires the [src.name] at []!</B>", user, target), 1, "\red You hear a gunshot", 2)
		if (istype(user, /mob/living/carbon/human))
			if (!istype(user:ears, /obj/item/clothing/ears/earmuffs))
				usr << "\red Your ears ring!"
				user.ear_damage += 5
				user.ear_deaf += 1
	var/turf/T = user.loc
	var/turf/U = (istype(target, /atom/movable) ? target.loc : target)
	if ((!( U ) || !( T )))
		return
	while(!( istype(U, /turf) ))
		U = U.loc
	if (!( istype(T, /turf) ))
		return
	if (U == T)
		if (src.shells[index] == 1 || shellsunlimited == 1)
			user.bullet_act(PROJECTILE_WEAKBULLET, src, user.get_organ_target())
		else if (src.shells[index] == 2 || shellsunlimited == 2)
			user.bullet_act(PROJECTILE_BULLET, src, user.get_organ_target())
		else if (src.shells[index] == 4 || shellsunlimited == 4)
			user.bullet_act(PROJECTILE_BOLT, src, user.get_organ_target())
		return
	switch(shellsunlimited)
		if (1)
			var/obj/bullet/A = new /obj/bullet/weakbullet( user.loc )
			src.pumped = 0
			A.def_zone = user.get_organ_target()
			A.current = U
			A.yo = U.y - T.y
			A.xo = U.x - T.x
			user.next_move = world.time + 4
			spawn( 0 )
				A.process()
			if (!istype(U, /turf))
				del(A)
				return
		if (2)
			var/obj/bullet/A = new /obj/bullet( user.loc )
			src.pumped = 0
			A.def_zone = user.get_organ_target()
			A.current = U
			A.yo = U.y - T.y
			A.xo = U.x - T.x
			user.next_move = world.time + 4
			spawn( 0 )
				A.process()
			if (!istype(U, /turf))
				del(A)
				return
		if (3) //I don't know why the fuck you'll need unlimited blank shells. Just to be sure. -- Barhandar
			src.pumped = 0
			spawn( 0 )
			return
		if (4)
			var/obj/bullet/A = new /obj/bullet/cbbolt( user.loc )
			src.pumped = 0
			A.def_zone = user.get_organ_target()
			A.current = U
			A.yo = U.y - T.y
			A.xo = U.x - T.x
			user.next_move = world.time + 4
			spawn( 0 )
				A.process()
			if (!istype(U, /turf))
				del(A)
				return
		else switch(src.shells[index])
			if (1)
				var/obj/bullet/A = new /obj/bullet/weakbullet( user.loc )
				src.pumped = 0
				src.shells[index] = 0
				index--
				A.def_zone = user.get_organ_target()
				A.current = U
				A.yo = U.y - T.y
				A.xo = U.x - T.x
				user.next_move = world.time + 4
				spawn( 0 )
					A.process()
				if (!istype(U, /turf))
					del(A)
					return
			if (2)
				var/obj/bullet/A = new /obj/bullet( user.loc )
				src.pumped = 0
				src.shells[index] = 0
				index--
				A.def_zone = user.get_organ_target()
				A.current = U
				A.yo = U.y - T.y
				A.xo = U.x - T.x
				user.next_move = world.time + 4
				spawn( 0 )
					A.process()
				if (!istype(U, /turf))
					del(A)
					return
			if (3)
				src.pumped = 0
				src.shells[index] = 0
				index--
				spawn( 0 )
				return
			if (4)
				var/obj/bullet/A = new /obj/bullet/cbbolt( user.loc )
				src.pumped = 0
				src.shells[index] = 0
				index--
				A.def_zone = user.get_organ_target()
				A.current = U
				A.yo = U.y - T.y
				A.xo = U.x - T.x
				user.next_move = world.time + 4
				spawn( 0 )
					A.process()
				if (!istype(U, /turf))
					del(A)
					return

// Magnet Rifle

/obj/item/weapon/gun/magnetrifle/examine()
	set src in usr
	if(src.bullets == 1)
		src.desc = text("The rifle is loaded.")
	if(src.bullets == 0)
		src.desc = text("The rifle is empty!")
	..()
	return

obj/item/weapon/gun/magnetrifle/attackby(obj/item/weapon/ammo/magnetrifle/A as obj, mob/user as mob)

	if (istype(A, /obj/item/weapon/ammo/magnetrifle))
		if (src.bullets >= 1)
			user << "\blue It's already loaded!"
			return 1
		if (A.amount_left < (1 - src.bullets))
			src.bullets += A.amount_left
			user << text("\red You reload the rifle!")
			A.amount_left = 0
		else
			user << text("\red You reload the rifle!")
			A.amount_left -= 1 - src.bullets
			src.bullets = 1
		del(A)
		return 1
	return

/obj/item/weapon/gun/magnetrifle/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
	if (flag)
		return
	if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return
	src.add_fingerprint(user)
	if ((src.bullets < 1) || (src.charges < 1))
		user.show_message("\red *click* *click*", 2)
		return
	src.bullets--
	src.charges--
	var/S = user.loc
	if (!( istype(S, /turf/space) ))
		playsound(user, 'laser.ogg', 50, 1)
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red <B>[] fires a magnet rifle at []!</B>", user, target), 1, "\red You hear a gunshot", 2)
		if (istype(user, /mob/living/carbon/human))
			if (!istype(user:ears, /obj/item/clothing/ears/earmuffs))
				usr << "\red Your ears ring!"
				user.ear_damage += 5
				user.ear_deaf += 1
	var/turf/T = user.loc
	var/turf/U = (istype(target, /atom/movable) ? target.loc : target)
	if ((!( U ) || !( T )))
		return
	while(!( istype(U, /turf) ))
		U = U.loc
	if (!( istype(T, /turf) ))
		return
	if (U == T)
		user.bullet_act(PROJECTILE_MAGNET, src, user.get_organ_target())
		return
	var/obj/bullet/A = new /obj/bullet( user.loc )
	if (!istype(U, /turf))
		del(A)
		return
	A.def_zone = user.get_organ_target()
	A.current = U
	A.yo = U.y - T.y
	A.xo = U.x - T.x
	user.next_move = world.time + 4
	spawn( 0 )
		A.process()
		return
	return

/obj/item/weapon/gun/magnetrifle/attack(mob/M as mob, mob/user as mob)
	..()
	/*
	src.add_fingerprint(user)
	var/mob/living/carbon/human/H = M

// ******* Check

	if ((istype(H, /mob/living/carbon/human) && istype(H, /obj/item/clothing/head) && H.flags & 8 && prob(80)))
		M << "\red The helmet protects you from being hit hard in the head!"
		return
	if ((user.a_intent == "hurt" && src.bullets > 0))
		if (prob(20))
			if (M.paralysis < 10)
				M.paralysis = 10
		else
			if (M.weakened < 10)
				M.weakened = 10
		src.bullets--
		src.force = 90
		..()
		src.force = 60
		if(M.stat != 2)	M.stat = 1
		for(var/mob/O in viewers(M, null))
			if(O.client)	O.show_message(text("\red <B>[] has been shot point-blank by []!</B>", M, user), 1, "\red You hear someone fall", 2)
	else
		if (prob(50))
			if (M.paralysis < 10)
				M.paralysis = 10
		else
			if (M.weakened < 10)
				M.weakened = 10
		src.force = 8.0
		..()
		if(M.stat != 2)	M.stat = 1
		for(var/mob/O in viewers(M, null))
			if (O.client)	O.show_message(text("\red <B>[] has been pistol whipped by []!</B>", M, user), 1, "\red You hear someone fall", 2)
	return
	*/

//Five-seveN


/obj/item/weapon/gun/fiveseven/examine()
	set src in usr
	if (src.magazine)
		if (istype(src.magazine, /obj/item/weapon/ammo/fiveseven))
			src.desc = text("There are [] bullet\s left! Uses .45 ACP", src.magazine.amount_left)
	else
		src.desc = "There are 0 bullets left! Uses .45 ACP"
	..()
	return

/obj/item/weapon/gun/fiveseven/verb/eject()
	set name = "Eject Magazine"
	set category = "Object"
	set src in usr
	if (src.magazine)
		if (istype(src.magazine, /obj/item/weapon/ammo/fiveseven))
			if (istype(src.loc, /mob))
				var/obj/item/W = src.loc:equipped()
				var/emptyHand = (W == null)
				if(emptyHand)
					src.magazine.DblClick()
					if(!istype(src.magazine.loc, /obj/item/weapon/gun/fiveseven))
						src.magazine = null
			else
				src.magazine.loc = src.loc
				src.magazine = null
	..()
	return

/obj/item/weapon/gun/fiveseven/attack_hand(mob/user as mob)
	if(user.r_hand == src || user.l_hand == src)
		if(src.magazine)
			if(user.hand)
				user.l_hand = src.magazine
			else
				user.r_hand = src.magazine
			src.magazine = null
	else
		return ..()

/obj/item/weapon/ammo/fiveseven/examine()
	set src in usr
	src.desc = text("There are [] 5.7x28mm round\s left in the magazine!", src.amount_left)
	..()
	return

/obj/item/weapon/gun/fiveseven/attackby(obj/item/weapon/ammo/fiveseven/A as obj, mob/user as mob)
	..()

	if (istype(A, /obj/item/weapon/ammo/fiveseven))
		if (src.magazine)
			user << "\blue There is already a magazine in!"
			return 1
		user.drop_item()
		A.loc = src
		src.magazine = A
		return 1
	return

/obj/item/weapon/gun/fiveseven/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)

	if (flag)
		return
	if ((istype(user, /mob/living/carbon/monkey)) && ticker.mode != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return
	src.add_fingerprint(user)
	if (src.magazine.amount_left < 1)
		user.show_message("\red *click* *click*", 2)
		return
	playsound(user, 'fiveseven.ogg', 100, 0)
	src.magazine.amount_left--
	src.magazine.update_icon()
	for(var/mob/O in viewers(user, null))
		O.show_message(text("\red <B>[] fires the five-seven at []!</B>", user, target), 1, "\red You hear a gunshot", 2)
	var/turf/T = user.loc
	var/turf/U = (istype(target, /atom/movable) ? target.loc : target)
	if ((!( U ) || !( T )))
		return
	while(!( istype(U, /turf) ))
		U = U.loc
	if (!( istype(T, /turf) ))
		return
	if (U == T)
		user.bullet_act(PROJECTILE_BULLET, src, user.get_organ_target())
		return
	var/obj/bullet/weakbullet/A = new /obj/bullet( user.loc )
	if (!istype(U, /turf))
		del(A)
		return
	A.def_zone = user.get_organ_target()
	A.current = U
	A.yo = U.y - T.y
	A.xo = U.x - T.x
	user.next_move = world.time + 4
	spawn( 0 )
		A.process()
		return
	return

/obj/item/weapon/gun/fiveseven/attack(mob/M as mob, mob/user as mob)
	..()
	/*
	src.add_fingerprint(user)
	var/mob/living/carbon/human/H = M

// ******* Check

	if ((istype(H, /mob/living/carbon/human) && istype(H, /obj/item/clothing/head) && H.flags & 8 && prob(80)))
		M << "\red The helmet protects you from being hit hard in the head!"
		return
	if ((user.a_intent == "hurt" && src.magazine.amount_left > 0))
		if (prob(20))
			if (M.paralysis < 10)
				M.paralysis = 10
		else
			if (M.weakened < 10)
				M.weakened = 10
		src.magazine.amount_left--
		src.force = 90
		..()
		src.force = 60
		if(M.stat != 2)	M.stat = 1
		for(var/mob/O in viewers(M, null))
			if(O.client)	O.show_message(text("\red <B>[] has been shot point-blank by []!</B>", M, user), 1, "\red You hear someone fall", 2)
	else
		if (prob(50))
			if (M.paralysis < 10)
				M.paralysis = 10
		else
			if (M.weakened < 10)
				M.weakened = 10
		src.force = 8.0
		..()
		if(M.stat != 2)	M.stat = 1
		for(var/mob/O in viewers(M, null))
			if (O.client)	O.show_message(text("\red <B>[] has been pistol whipped by []!</B>", M, user), 1, "\red You hear someone fall", 2)
	return
	*/

// DETECTIVE REVOLVER


/obj/item/weapon/gun/detectiverevolver/examine()
	set src in usr
	src.desc = text("There are [] bullet\s left! Uses .38-Special rounds", src.bullets)
	..()
	return

/obj/item/weapon/gun/detectiverevolver/attackby(obj/item/weapon/ammo/a38/A as obj, mob/user as mob)
	..()
	if (istype(A, /obj/item/weapon/ammo/a38))
		if (src.bullets >= 7)
			user << "\blue It's already fully loaded!"
			return 1
		if (A.amount_left <= 0)
			user << "\red There is no more bullets!"
			return 1
		if (A.amount_left < (7 - src.bullets))
			src.bullets += A.amount_left
			user << text("\red You reload [] bullet\s!", A.amount_left)
			A.amount_left = 0
		else
			user << text("\red You reload [] bullet\s!", 7 - src.bullets)
			A.amount_left -= 7 - src.bullets
			src.bullets = 7
		A.update_icon()
		return 1
	return

/obj/item/weapon/gun/detectiverevolver/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)

	var/detective = (istype(user:w_uniform, /obj/item/clothing/under/rank/det) && istype(user:head, /obj/item/clothing/head/det_hat)  && istype(user:wear_suit, /obj/item/clothing/suit/det_suit))

	if (flag)
		return
	if ((istype(user, /mob/living/carbon/monkey)) && ticker.mode != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return
	if(!detective)
		usr << "\red You just don't feel cool enough to use this gun looking like that."
		return
	src.add_fingerprint(user)
	if (src.bullets < 1)
		user.show_message("\red *click* *click*", 2)
		return
	src.bullets--
	var/S = user.loc
	if (!( istype(S, /turf/space) ))
		playsound(user, 'Magnum.ogg', 100, 0)
		//world << sound('Magnum_distant.ogg', volume=100)
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red <B>[] fires the detective's revolver at []!</B>", user, target), 1, "\red You hear a gunshot", 2)
		if (istype(user, /mob/living/carbon/human))
			if (!istype(user:ears, /obj/item/clothing/ears/earmuffs))
				usr << "\red Your ears ring!"
				user.ear_damage += 5
				user.ear_deaf += 1
	var/turf/T = user.loc
	var/turf/U = (istype(target, /atom/movable) ? target.loc : target)
	if ((!( U ) || !( T )))
		return
	while(!( istype(U, /turf) ))
		U = U.loc
	if (!( istype(T, /turf) ))
		return
	if (U == T)
		user.bullet_act(PROJECTILE_WEAKBULLET, src, user.get_organ_target())
		return
	var/obj/bullet/weakbullet/A = new /obj/bullet/weakbullet( user.loc )
	if (!istype(U, /turf))
		del(A)
		return
	A.def_zone = user.get_organ_target()
	A.current = U
	A.yo = U.y - T.y
	A.xo = U.x - T.x
	user.next_move = world.time + 4
	spawn( 0 )
		A.process()
		return
	return

/obj/item/weapon/gun/detectiverevolver/attack(mob/M as mob, mob/user as mob)
	src.add_fingerprint(user)
	var/mob/living/carbon/human/H = user
	var/detective
	if(!istype(H))
		detective = 0
	else
		detective = (istype(H.w_uniform, /obj/item/clothing/under/rank/det) && istype(H.head, /obj/item/clothing/head/det_hat)  && istype(H.wear_suit, /obj/item/clothing/suit/det_suit))

// ******* Check

	if(!detective)
		usr << "\red You just don't feel cool enough to use this gun looking like that."
		return
	..()
/*	if ((istype(H, /mob/living/carbon/human) && istype(H, /obj/item/clothing/head) && H.flags & 8 && prob(80)))
		M << "\red The helmet protects you from being hit hard in the head!"
		return
	if ((user.a_intent == "hurt" && src.bullets > 0))
		if (prob(5))
			if (M.paralysis < 10)
				M.paralysis = 10
		else
			if (M.weakened < 10)
				M.weakened = 10
		src.bullets--
		src.force = 9.0
		..()
		src.force = 9.0
		if(M.stat != 2)	M.stat = 1
		for(var/mob/O in viewers(M, null))
			if(O.client)
				O.show_message(text("\red <B>[] has been shot point-blank with the detectives revolver by []!</B>", M, user), 1, "\red You hear someone fall", 2)
				playsound(user, 'Magnum.ogg', 100, 0)
				//world << sound('Magnum_distant.ogg', volume=100)
	else
		if (prob(5))
			if (M.paralysis < 10)
				M.paralysis = 10
		else
			if (M.weakened < 10)
				M.weakened = 10
		src.force = 8.0
		..()
		if(M.stat != 2)	M.stat = 1
		for(var/mob/O in viewers(M, null))
			if (O.client)	O.show_message(text("\red <B>[] has been pistol whipped with the detectives revolver by []!</B>", M, user), 1, "\red You hear someone fall", 2)
	return
	*/

// ENERGY GUN

/obj/item/weapon/gun/energy/update_icon()
	if (istype(src, /obj/item/weapon/gun/energy/crossbow)) return
	var/ratio = src.charges / 10
	ratio = round(ratio, 0.25) * 100
	src.icon_state = text("gun[]", ratio)
	return

/obj/item/weapon/gun/energy/emp_act(severity)
	charges = 0
	update_icon()
	..()

// PLASMA GUN

/obj/item/weapon/gun/energy/Research/plasma_pistol/update_icon()
	var/ratio = src.charges / maximum_charges
	ratio = round(ratio, 0.25) * 100
	src.icon_state = text("Plasma_Gun[]", ratio)
	return

/obj/item/weapon/gun/energy/Research/plasma_pistol/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
	if ((usr.mutations & 16) && prob(50))
		usr << "\red The plasma gun blows up in your face."
		usr.fireloss += 20
		usr.drop_item()
		del(src)
		return
	if (flag)
		return
	if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return

	src.add_fingerprint(user)
	if(src.charges < 1)
		user << "\red *click* *click*"
		return

	playsound(user, 'Plasmagun.ogg', 50, 1)
	src.charges--
	update_icon()
	for(var/mob/O in viewers(user, null))
		O.show_message(text("\red <B>[] fires a plasma gun at []!</B>", user, target), 1, "\red You hear a strange noise", 2)
	var/turf/T = user.loc
	var/turf/U = (istype(target, /atom/movable) ? target.loc : target)

	if(!U || !T)
		return
	while(U && !istype(U, /turf))
		U = U.loc
	if(!istype(T, /turf))
		return
	if(U == T)
		user.bullet_act(PROJECTILE_PLASMA, src, user.get_organ_target())
		return
	if(!istype(U, /turf))
		return

	var/obj/beam/a_plasma/A = new /obj/beam/a_plasma( user.loc )
	A.def_zone = user.get_organ_target()
	A.current = U
	A.yo = U.y - T.y
	A.xo = U.x - T.x

	user.next_move = world.time + 4
	A.process()
	return

/obj/item/weapon/gun/energy/Research/plasma_pistol/attack(mob/M as mob, mob/user as mob)
	..()
	/*
	src.add_fingerprint(user)
	if ((prob(30) && M.stat < 2))
		var/mob/living/carbon/human/H = M

// ******* Check
		if ((istype(H, /mob/living/carbon/human) && istype(H, /obj/item/clothing/head) && H.flags & 8 && prob(80)))
			M << "\red The helmet protects you from being hit hard in the head!"
			return
		var/time = rand(10, 120)
		if (prob(90))
			if (M.paralysis < time)
				M.paralysis = time
		else
			if (M.weakened < time)
				M.weakened = time
		if(M.stat != 2)	M.stat = 1
		for(var/mob/O in viewers(M, null))
			if(O.client)	O.show_message(text("\red <B>[] has been knocked unconscious!</B>", M), 1, "\red You hear someone fall", 2)

	return
	*/

// PLASMA RIFLE

/obj/item/weapon/gun/energy/Research/Plasma_Rifle/update_icon()
	var/ratio = src.charges / maximum_charges
	ratio = round(ratio, 0.25) * 100
	src.icon_state = text("Plasma_Rifle[]", ratio)
	return

/obj/item/weapon/gun/energy/Research/Plasma_Rifle/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
	if ((usr.mutations & 16) && prob(50))
		usr << "\red The plasma gun blows up in your face."
		usr.fireloss += 20
		usr.drop_item()
		del(src)
		return
	if (flag)
		return
	if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return

	src.add_fingerprint(user)
	if(src.charges < 1)
		user << "\red *click* *click*"
		return

	playsound(user, 'Plasmagun.ogg', 50, 1)
	src.charges--
	update_icon()
	for(var/mob/O in viewers(user, null))
		O.show_message(text("\red <B>[] fires a plasma rifle at []!</B>", user, target), 1, "\red You hear a strange noise", 2)
	var/turf/T = user.loc
	var/turf/U = (istype(target, /atom/movable) ? target.loc : target)

	if(!U || !T)
		return
	while(U && !istype(U, /turf))
		U = U.loc
	if(!istype(T, /turf))
		return
	if(U == T)
		user.bullet_act(PROJECTILE_PLASMA, src, user.get_organ_target())
		return
	if(!istype(U, /turf))
		return

	var/obj/beam/a_plasma/A = new /obj/beam/a_plasma( user.loc )
	A.def_zone = user.get_organ_target()
	A.current = U
	A.yo = U.y - T.y
	A.xo = U.x - T.x

	user.next_move = world.time + 4
	A.process()
	return

/obj/item/weapon/gun/energy/Research/Plasma_Rifle/attack(mob/M as mob, mob/user as mob)
	..()
	/*
	src.add_fingerprint(user)
	if ((prob(30) && M.stat < 2))
		var/mob/living/carbon/human/H = M

// ******* Check
		if ((istype(H, /mob/living/carbon/human) && istype(H, /obj/item/clothing/head) && H.flags & 8 && prob(80)))
			M << "\red The helmet protects you from being hit hard in the head!"
			return
		var/time = rand(10, 120)
		if (prob(90))
			if (M.paralysis < time)
				M.paralysis = time
		else
			if (M.weakened < time)
				M.weakened = time
		if(M.stat != 2)	M.stat = 1
		for(var/mob/O in viewers(M, null))
			if(O.client)	O.show_message(text("\red <B>[] has been knocked unconscious!</B>", M), 1, "\red You hear someone fall", 2)

	return
	*/

// HPR

/obj/item/weapon/gun/energy/Research/Heavy_Plasma/update_icon()
	var/ratio = src.charges / maximum_charges
	ratio = round(ratio, 0.25) * 100
	src.icon_state = text("HPR[]", ratio)
	return


/obj/item/weapon/gun/energy/Research/Heavy_Plasma/em/update_icon()
	var/ratio = src.charges / maximum_charges
	ratio = round(ratio, 0.25) * 100
	src.icon_state = text("emHPR[]", ratio)
	return

/obj/item/weapon/gun/energy/Research/Heavy_Plasma/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
	if ((usr.mutations & 16) && prob(50))
		usr << "\red The heavy plasma rifle blows up in your face."
		usr.fireloss += 20
		usr.drop_item()
		del(src)
		return
	if (flag)
		return
	if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return

	src.add_fingerprint(user)
	if(src.charges < 1)
		user << "\red *click* *click*"
		return

	playsound(user, 'Plasmagun.ogg', 50, 1)
	src.charges--
	update_icon()
	for(var/mob/O in viewers(user, null))
		O.show_message(text("\red <B>[] fires a heavy plasma rifle at []!</B>", user, target), 1, "\red You hear a strange noise", 2)
	var/turf/T = user.loc
	var/turf/U = (istype(target, /atom/movable) ? target.loc : target)

	if(!U || !T)
		return
	while(U && !istype(U, /turf))
		U = U.loc
	if(!istype(T, /turf))
		return
	if(U == T)
		user.bullet_act(PROJECTILE_PLASMA, src, user.get_organ_target())
		return
	if(!istype(U, /turf))
		return

	var/obj/beam/a_plasma/A = new /obj/beam/a_plasma( user.loc )
	A.def_zone = user.get_organ_target()
	A.current = U
	A.yo = U.y - T.y
	A.xo = U.x - T.x

	user.next_move = world.time + 4
	A.process()
	return

/obj/item/weapon/gun/energy/Research/Heavy_Plasma/attack(mob/M as mob, mob/user as mob)
	..()
	/*
	src.add_fingerprint(user)
	if ((prob(30) && M.stat < 2))
		var/mob/living/carbon/human/H = M

// ******* Check
		if ((istype(H, /mob/living/carbon/human) && istype(H, /obj/item/clothing/head) && H.flags & 8 && prob(80)))
			M << "\red The helmet protects you from being hit hard in the head!"
			return
		var/time = rand(40, 120)
		if (prob(90))
			if (M.paralysis < time)
				M.paralysis = time
		else
			if (M.weakened < time)
				M.weakened = time
		if(M.stat != 2)	M.stat = 1
		for(var/mob/O in viewers(M, null))
			if(O.client)	O.show_message(text("\red <B>[] has been knocked unconscious!</B>", M), 1, "\red You hear someone fall", 2)

	return
	*/

// LASER GUN

/obj/item/weapon/gun/energy/laser_gun/update_icon()
	if (istype(src, /obj/item/weapon/gun/energy/crossbow)) return
	var/ratio = src.charges / 10
	ratio = round(ratio, 0.25) * 100
	if (istype(src, /obj/item/weapon/gun/energy/laser_gun/captain))
		src.icon_state = text("caplaser[]", ratio)
	else
		src.icon_state = text("laser[]", ratio)
	return

/obj/item/weapon/gun/energy/laser_gun/captain/New()
	charge()

/obj/item/weapon/gun/energy/laser_gun/captain/proc/charge()
	if(charges < maximum_charges)
		charges++
		update_icon()
	spawn(50) charge()

/obj/item/weapon/gun/energy/laser_gun/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
	if ((usr.mutations & 16) && prob(50))
		usr << "\red The laser gun blows up in your face."
		usr.fireloss += 20
		usr.drop_item()
		del(src)
		return
	if (flag)
		return
	if ((istype(user, /mob/living/carbon/monkey)) && ticker.mode != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return

	src.add_fingerprint(user)

	if(src.charges < 1)
		user << "\red *click* *click*"
		return

	playsound(user, 'Laser.ogg', 50, 1)
	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		R.cell.charge -= 30
	else
		src.charges--
	update_icon()

	var/turf/T = user.loc
	var/turf/U = (istype(target, /atom/movable) ? target.loc : target)

	if(!U || !T)
		return
	while(U && !istype(U, /turf))
		U = U.loc
	if(!istype(T, /turf))
		return
	if(U == T)
		user.bullet_act(PROJECTILE_LASER, src, user.get_organ_target())
		return
	if(!istype(U, /turf))
		return

	var/obj/beam/a_laser/A = new /obj/beam/a_laser( user.loc )
	A.def_zone = user.get_organ_target()
	A.current = U
	A.yo = U.y - T.y
	A.xo = U.x - T.x

	user.next_move = world.time + 4
	A.process()
	return

/obj/item/weapon/gun/energy/laser_gun/attack(mob/M as mob, mob/user as mob)
	..()
	/*
	src.add_fingerprint(user)
	if ((prob(30) && M.stat < 2))
		var/mob/living/carbon/human/H = M

// ******* Check
		if ((istype(H, /mob/living/carbon/human) && istype(H, /obj/item/clothing/head) && H.flags & 8 && prob(80)))
			M << "\red The helmet protects you from being hit hard in the head!"
			return
		var/time = rand(10, 120)
		if (prob(90))
			if (M.paralysis < time)
				M.paralysis = time
		else
			if (M.weakened < time)
				M.weakened = time
		if(M.stat != 2)	M.stat = 1
		for(var/mob/O in viewers(M, null))
			if(O.client)	O.show_message(text("\red <B>[] has been knocked unconscious!</B>", M), 1, "\red You hear someone fall", 2)

	return
	*/

// TASER GUN


/obj/item/weapon/gun/energy/taser_gun/update_icon()
	var/ratio = src.charges / maximum_charges
	ratio = round(ratio, 0.25) * 100
	src.icon_state = text("taser[]", ratio)

/obj/item/weapon/gun/energy/taser_gun/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
	if(flag)
		return
	if ((istype(user, /mob/living/carbon/monkey)) && ticker.mode != "monkey")
		user << "\red You don't have the dexterity to do this!"
		return
	src.add_fingerprint(user)
	if(!isrobot(user) && src.charges < 1)
		user << "\red *click* *click*";
		return

	playsound(user, 'Taser.ogg', 50, 1)
	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		R.cell.charge -= 20
	else
		src.charges--
	update_icon()

	var/turf/T = user.loc
	var/turf/U = (istype(target, /atom/movable) ? target.loc : target)

	if(!U || !T)
		return
	while(U && !istype(U,/turf))
		U = U.loc
	if(!istype(T, /turf))
		return
	if (U == T)
		user.bullet_act(PROJECTILE_TASER, src, user.get_organ_target())
		return
	if(!istype(U, /turf))
		return

	var/obj/bullet/electrode/A = new /obj/bullet/electrode(user.loc)
	A.def_zone = user.get_organ_target()
	A.current = U
	A.yo = U.y - T.y
	A.xo = U.x - T.x

	A.process()


/obj/item/weapon/gun/energy/taser_gun/attack(mob/M as mob, mob/user as mob)
	..()
	/*
	if ((usr.mutations & 16) && prob(50))
		usr << "\red The taser gun discharges in your hand."
		usr.paralysis += 60
		return
	src.add_fingerprint(user)
	var/mob/living/carbon/human/H = M
	if ((istype(H, /mob/living/carbon/human) && istype(H, /obj/item/clothing/head) && H.flags & 8 && prob(80)))
		M << "\red The helmet protects you from being hit hard in the head!"
		return
	if((src.charges >= 1) && (istype(H, /mob/living/carbon/human)))
		if (user.a_intent == "hurt")
			if (prob(20))
				if (M.paralysis < 10 && (!(M.mutations & 8))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
					M.paralysis = 10
			else if (M.weakened < 10 && (!(M.mutations & 8))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
				M.weakened = 10
			if (M.stuttering < 10 && (!(M.mutations & 8))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
				M.stuttering = 10
			..()
			if(M.stat != 2)	M.stat = 1
			for(var/mob/O in viewers(M, null))
				O.show_message("\red <B>[M] has been knocked unconscious!</B>", 1, "\red You hear someone fall", 2)
		else
			if (prob(50))
				if (M.paralysis < 60 && (!(M.mutations & 8))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
					M.paralysis = 60
			else
				if (M.weakened < 60 && (!(M.mutations & 8))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
					M.weakened = 60
			if (M.stuttering < 60 && (!(M.mutations & 8))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
				M.stuttering = 60
			if(M.stat != 2)	M.stat = 1
			for(var/mob/O in viewers(M, null))
				if (O.client)	O.show_message("\red <B>[M] has been stunned with the taser gun by [user]!</B>", 1, "\red You hear someone fall", 2)
		src.charges--
		update_icon()
	else if((src.charges >= 1) && (istype(M, /mob/living/carbon/monkey)))
		if (user.a_intent == "hurt")
			if (prob(20))
				if (M.paralysis < 10 && (!(M.mutations & 8)) )
					M.paralysis = 10
			else if (M.weakened < 10 && (!(M.mutations & 8)) )
				M.weakened = 10
			if (M.stuttering < 10 && (!(M.mutations & 8)) )
				M.stuttering = 10
			..()
			if(M.stat != 2)	M.stat = 1
			for(var/mob/O in viewers(M, null))
				O.show_message("\red <B>[M] has been knocked unconscious!</B>", 1, "\red You hear someone fall", 2)
		else
			if (prob(50))
				if (M.paralysis < 60 && (!(M.mutations & 8)) )
					M.paralysis = 60
			else
				if (M.weakened < 60 && (!(M.mutations & 8)) )
					M.weakened = 60
			if (M.stuttering < 60 && (!(M.mutations & 8)) )
				M.stuttering = 60
			if(M.stat != 2)	M.stat = 1
			for(var/mob/O in viewers(M, null))
				if (O.client)	O.show_message("\red <B>[M] has been stunned with the taser gun by [user]!</B>", 1, "\red You hear someone fall", 2)
		if(isrobot(user))
			var/mob/living/silicon/robot/R = user
			R.cell.charge -= 20
		else
			src.charges--
		update_icon()
	else // no charges in the gun, so they just wallop the target with it
	*/




// CROSSBOW


/obj/item/weapon/gun/energy/crossbow/New()
	charge()

/obj/item/weapon/gun/energy/crossbow/proc/charge()
	if(charges < maximum_charges) charges++
	spawn(50) charge()

/obj/item/weapon/gun/energy/crossbow/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
	if(flag)
		return
	if ((istype(user, /mob/living/carbon/monkey)) && ticker.mode != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return

	//src.add_fingerprint(user) stealthy and stuff

	if(src.charges < 1)
		user << "\red *click* *click*";
		return

	playsound(user, 'Genhit.ogg', 20, 1)
	src.charges--
	var/turf/T = user.loc
	var/turf/U = (istype(target, /atom/movable) ? target.loc : target)

	if(!U || !T)
		return
	while(U && !istype(U,/turf))
		U = U.loc
	if(!istype(T, /turf))
		return
	if (U == T)
		user.bullet_act(PROJECTILE_BOLT, src, user.get_organ_target())
		return
	if(!istype(U, /turf))
		return

	var/obj/bullet/cbbolt/A = new /obj/bullet/cbbolt(user.loc)
	A.def_zone = user.get_organ_target()
	A.current = U
	A.yo = U.y - T.y
	A.xo = U.x - T.x

	A.process()

/obj/item/weapon/gun/energy/crossbow/attack(mob/M as mob, mob/user as mob)
	..()
	/*
	src.add_fingerprint(user)
	var/mob/living/carbon/human/H = M
	if ((istype(H, /mob/living/carbon/human) && istype(H, /obj/item/clothing/head) && H.flags & 8 && prob(80)))
		M << "\red The helmet protects you from being hit hard in the head!"
		return
	*/




// TELEPORT GUN
// This whole thing is just a copy/paste job

/obj/item/weapon/gun/energy/teleport_gun/attack_self(mob/user as mob)
	var/list/L = list(  )
	for(var/obj/machinery/teleport/hub/R in world)
		var/obj/machinery/computer/teleporter/com = locate(/obj/machinery/computer/teleporter, locate(R.x - 2, R.y, R.z))
		if (istype(com, /obj/machinery/computer/teleporter) && com.locked)
			if(R.icon_state == "tele1")
				L["[com.id] (Active)"] = com.locked
			else
				L["[com.id] (Inactive)"] = com.locked
	L["None (Dangerous)"] = null
	var/t1 = input(user, "Please select a teleporter to lock in on.", "Hand Teleporter") in L
	if ((user.equipped() != src || user.stat || user.restrained()))
		return
	var/T = L[t1]
	src.target = T
	usr << "\blue Teleportation hub selected!"
	src.add_fingerprint(user)
	return

/obj/item/weapon/gun/energy/teleport_gun/update_icon()
	var/ratio = src.charges / maximum_charges
	ratio = round(ratio, 0.25) * 100
	src.icon_state = text("taser[]", ratio)

/obj/item/weapon/gun/energy/teleport_gun/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
	if(flag)
		return
	if ((istype(user, /mob/living/carbon/monkey)) && ticker.mode != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return
	src.add_fingerprint(user)
	if(src.charges < 1)
		user << "\red *click* *click*";
		return

	playsound(user, 'Taser.ogg', 50, 1)
	src.charges--
	update_icon()

	var/turf/T = user.loc
	var/turf/U = (istype(target, /atom/movable) ? target.loc : target)

	if(!U || !T)
		return
	while(U && !istype(U,/turf))
		U = U.loc
	if(!istype(T, /turf))
		return
	if (U == T)
		return
	if(!istype(U, /turf))
		return

	var/obj/bullet/teleshot/A = new /obj/bullet/teleshot(user.loc)
	A.def_zone = user.get_organ_target()
	A.target = src.target
	A.current = U
	A.yo = U.y - T.y
	A.xo = U.x - T.x

	A.process()

/obj/item/weapon/gun/energy/teleport_gun/proc/point_blank_teleport(mob/M as mob, mob/user as mob)
	if (src.target == null)
		var/list/turfs = list(	)
		for(var/turf/T in orange(10))
			if(T.x>world.maxx-4 || T.x<4)	continue	//putting them at the edge is dumb
			if(T.y>world.maxy-4 || T.y<4)	continue
			turfs += T
		if(turfs)
			src.target = pick(turfs)
	if (!src.target)
		return
	spawn(0)
		if(M)
			var/datum/effects/system/spark_spread/s = new /datum/effects/system/spark_spread
			s.set_up(5, 1, M)
			s.start()
			if(prob(src.failchance)) //oh dear a problem, put em in deep space
				do_teleport(M, locate(rand(5, world.maxx - 5), rand(5, world.maxy -5), 3), 0)
			else
				do_teleport(M, src.target, 2)
	return

/obj/item/weapon/gun/energy/teleport_gun/attack(mob/M as mob, mob/user as mob)
	..()
	/*
	if ((usr.mutations & 16) && prob(50))
		usr << "\red You shoot the teleport gun while holding it backwards."
		point_blank_teleport(usr)
		return
	src.add_fingerprint(user)
	if(src.charges >= 1)
		if (prob(95))
			point_blank_teleport(M)
			for(var/mob/O in viewers(M, null))
				if (O.client)	O.show_message("\red <B>[M] was shot point blank with the teleport gun by [user]!</B>", 1)
		else
			point_blank_teleport(usr)
			for(var/mob/O in viewers(M, null))
				if (O.client)	O.show_message("\red <B>[user] tried to shoot [M] but the teleport gun misfired!</B>", 1)
		src.charges--
		update_icon()
	else // no charges in the gun, so they just wallop the target with it
	*/








// General Gun

/obj/item/weapon/gun/energy/general
	name = "energy gun"
	icon_state = "energy"
	desc = "A gun that has two modes, stun and kill"
	w_class = 3.0
	item_state = "gun"
	force = 10.0
	throw_speed = 2
	throw_range = 10
	charges = 10
	maximum_charges = 10
	m_amt = 2000
	g_amt = 1000

	var/mode = 2

	atomic
		name = "Advanced Energy Gun"
		desc = "An energy gun with an experimental radioactive core."
		var/critfail = 0
		var/lightfail = 0
		origin_tech = "combat=3;materials=5;powerstorage=4"

		New()
			..()
			charge()
			update_reactor()

		proc/charge()
			if(charges < maximum_charges)
				if(failcheck())
					charges++ //If the gun isn't fully charged, and it doesn't suffer a failure, add a charge.
					update_icon()
			update_reactor()
			if(!crit_fail)
				spawn(50) charge()

		proc/failcheck()
			lightfail = 0
			if (prob(src.reliability)) return 1 //No failure
			if (prob(src.reliability))
				for (var/mob/M in range(0,src)) //Only a minor failure, enjoy your radiation if you're in the same tile or carrying it
					if (src in M.contents)
						M << "\red Your gun feels pleasantly warm for a moment."
					else
						M << "\red You feel a warm sensation."
					src.loc:radiation += rand(1,40)
				lightfail = 1
			else
				for (var/mob/M in range(rand(1,4),src)) //Big failure, TIME FOR RADIATION BITCHES
					if (src in M.contents)
						M << "\red Your gun's reactor overloads!"
					M << "\red You feel a wave of heat wash over you."
					M.radiation += 80
				crit_fail = 1 //break the gun so it stops recharging

		proc/update_reactor()
			overlays -= "energyatomic_critfail"
			overlays -= "energyatomic_fail"
			overlays -= "energyatomic"
			if(crit_fail)
				overlays += "energyatomic_critfail"
				return
			if(lightfail)
				overlays += "energyatomic_fail"
			else
				overlays += "energyatomic"

		update_icon()
			var/ratio = src.charges / maximum_charges
			ratio = round(ratio, 0.25) * 100
			src.icon_state = text("energy[]", ratio)
			src.update_reactor()

	update_icon()
		var/ratio = src.charges / maximum_charges
		ratio = round(ratio, 0.25) * 100
		src.icon_state = text("energy[]", ratio)

	afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
		if ((usr.mutations & 16) && prob(50))
			usr << "\red The energy gun blows up in your face."
			usr.fireloss += 20
			usr.drop_item()
			del(src)
			return
		if (flag)
			return
		if ((istype(user, /mob/living/carbon/monkey)) && ticker.mode != "monkey")
			usr << "\red You don't have the dexterity to do this!"
			return

		src.add_fingerprint(user)

		if(src.charges < 1)
			user << "\red *click* *click*";
			return

		playsound(user, 'laser3.ogg', 50, 1)
		src.charges--
		update_icon()

		var/turf/curloc = user.loc
		var/atom/targloc = get_turf(target)
		if (!targloc || !istype(targloc, /turf) || !curloc)
			return

		if(mode == 1)
			if (targloc == curloc)
				user.bullet_act(PROJECTILE_LASER, src, user.get_organ_target())
				return
		else if(mode == 2)
			if (targloc == curloc)
				user.bullet_act(PROJECTILE_TASER, src, user.get_organ_target())
				return

		if(mode == 1)
			var/obj/beam/a_laser/A = new /obj/beam/a_laser(user.loc)
			A.def_zone = user.get_organ_target()
			A.current = curloc
			A.yo = targloc.y - curloc.y
			A.xo = targloc.x - curloc.x
			user.next_move = world.time + 4
			spawn()
				A.process()

		else if(mode == 2)
			var/obj/bullet/electrode/A = new /obj/bullet/electrode(user.loc)
			A.def_zone = user.get_organ_target()
			A.current = curloc
			A.yo = targloc.y - curloc.y
			A.xo = targloc.x - curloc.x
			user.next_move = world.time + 4
			spawn()
				A.process()

	attack_self(mob/user as mob)
		if(mode == 1)
			mode = 2
			user << "\blue You set the gun to stun"
			overlays += "energystun"
			overlays -= "energykill"
		else if (mode == 2)
			mode = 1
			user << "\blue You set the gun to kill"
			overlays += "energykill"
			overlays -= "energystun"
		update_icon()

	attack(mob/M as mob, mob/user as mob)
		..()
		src.add_fingerprint(user)
		if ((prob(30) && M.stat < 2))
			var/mob/living/carbon/human/H = M

			if ((istype(H, /mob/living/carbon/human) && istype(H, /obj/item/clothing/head) && H.flags & 8 && prob(80)))
				M << "\red The helmet protects you from being hit hard in the head!"
				return
			var/time = rand(10, 120)
			if (prob(90))
				if (M.paralysis < time)
					M.paralysis = time
			else
				if (M.weakened < time)
					M.weakened = time
			if(M.stat != 2)	M.stat = 1
			for(var/mob/O in viewers(M, null))
				if(O.client)	O.show_message(text("\red <B>[M] has been knocked unconscious!</B>"), 1, "\red You hear someone fall", 2)

		return



//GLOCK


/obj/item/weapon/gun/glock/examine()
	set src in usr
	if (src.magazine)
		if (istype(src.magazine, /obj/item/weapon/ammo/a45))
			src.desc = text("There are [] bullet\s left! Uses .45 ACP", src.magazine.amount_left)
	else
		src.desc = "There are 0 bullets left! Uses .45 ACP"
	..()
	return

/obj/item/weapon/gun/glock/verb/eject()
	set name = "Eject Magazine"
	set category = "Object"
	set src in usr
	if (src.magazine)
		if (istype(src.magazine, /obj/item/weapon/ammo/a45))
			if (istype(src.loc, /mob))
				var/obj/item/W = src.loc:equipped()
				var/emptyHand = (W == null)
				if(emptyHand)
					src.magazine.DblClick()
					if(!istype(src.magazine.loc, /obj/item/weapon/gun/glock))
						src.magazine = null
			else
				src.magazine.loc = src.loc
				src.magazine = null
	..()
	return

/obj/item/weapon/gun/glock/attack_hand(mob/user as mob)
	if(user.r_hand == src || user.l_hand == src)
		if(src.magazine)
			if(user.hand)
				user.l_hand = src.magazine
			else
				user.r_hand = src.magazine
			src.magazine = null
	else
		return ..()

/obj/item/weapon/ammo/a45/examine()
	set src in usr
	src.desc = text("There are [] bullet\s left!", src.amount_left)
	..()
	return

/obj/item/weapon/gun/glock/attackby(obj/item/weapon/ammo/a45/A as obj, mob/user as mob)
	..()

	if (istype(A, /obj/item/weapon/ammo/a45))
		if (src.magazine)
			user << "\blue There is already a magazine in!"
			return 1
		user.drop_item()
		A.loc = src
		src.magazine = A
		return 1
	return

/obj/item/weapon/gun/glock/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)

	if (flag)
		return
	if ((istype(user, /mob/living/carbon/monkey)) && ticker.mode != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return
	src.add_fingerprint(user)
	if (!src.magazine)
		usr << "\red The [src.name] isn't loaded!"
		return
	if (!src.magazine || ((src.magazine) && (src.magazine.amount_left < 1)))
		user.show_message("\red *click* *click*", 2)
		return
	playsound(user, 'Glock.ogg', 100, 0)
	//world << sound('Glock_distant.ogg', volume=100)
	src.magazine.amount_left--
	for(var/mob/O in viewers(user, null))
		O.show_message(text("\red <B>[] fires the glock at []!</B>", user, target), 1, "\red You hear a gunshot", 2)
	var/turf/T = user.loc
	var/turf/U = (istype(target, /atom/movable) ? target.loc : target)
	if ((!( U ) || !( T )))
		return
	while(!( istype(U, /turf) ))
		U = U.loc
	if (!( istype(T, /turf) ))
		return
	if (U == T)
		user.bullet_act(PROJECTILE_WEAKBULLET, src, user.get_organ_target())
		return
	var/obj/bullet/weakbullet/A = new /obj/bullet/weakbullet( user.loc )
	if (!istype(U, /turf))
		del(A)
		return
	A.def_zone = user.get_organ_target()
	A.current = U
	A.yo = U.y - T.y
	A.xo = U.x - T.x
	user.next_move = world.time + 4
	spawn( 0 )
		A.process()
		return
	return

/obj/item/weapon/gun/m1911/examine()
	set src in usr
	if (src.magazine)
		if (istype(src.magazine, /obj/item/weapon/ammo/a45))
			src.desc = text("There are [] bullet\s left! Uses .45 ACP", src.magazine.amount_left)
	else
		src.desc = "There are 0 bullets left! Uses .45 ACP"
	..()
	return

/obj/item/weapon/gun/m1911/verb/eject()
	set name = "Eject Magazine"
	set category = "Object"
	set src in usr
	if (src.magazine)
		if (istype(src.magazine, /obj/item/weapon/ammo/a45))
			if (istype(src.loc, /mob))
				var/obj/item/W = src.loc:equipped()
				var/emptyHand = (W == null)
				if(emptyHand)
					src.magazine.DblClick()
					if(!istype(src.magazine.loc, /obj/item/weapon/gun/m1911))
						src.magazine = null
			else
				src.magazine.loc = src.loc
				src.magazine = null
	..()
	return

/obj/item/weapon/gun/m1911/attack_hand(mob/user as mob)
	if(user.r_hand == src || user.l_hand == src)
		if(src.magazine)
			if(user.hand)
				user.l_hand = src.magazine
			else
				user.r_hand = src.magazine
			src.magazine = null
	else
		return ..()

/obj/item/weapon/gun/m1911/attackby(obj/item/weapon/ammo/a45/A as obj, mob/user as mob)
	..()

	if (istype(A, /obj/item/weapon/ammo/a45))
		if (src.magazine)
			user << "\blue There is already a magazine in!"
			return 1
		user.drop_item()
		A.loc = src
		src.magazine = A
		return 1
	return

/obj/item/weapon/gun/m1911/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)

	if (flag)
		return
	if ((istype(user, /mob/living/carbon/monkey)) && ticker.mode != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return
	src.add_fingerprint(user)
	if (!src.magazine)
		usr << "\red The [src.name] isn't loaded!"
		return
	if (!src.magazine || ((src.magazine) && (src.magazine.amount_left < 1)))
		user.show_message("\red *click* *click*", 2)
		return
	playsound(user, 'Glock.ogg', 100, 0)
	//world << sound('Glock_distant.ogg', volume=100)
	src.magazine.amount_left--
	for(var/mob/O in viewers(user, null))
		O.show_message(text("\red <B>[] fires the  m1911 at []!</B>", user, target), 1, "\red You hear a gunshot", 2)
	var/turf/T = user.loc
	var/turf/U = (istype(target, /atom/movable) ? target.loc : target)
	if ((!( U ) || !( T )))
		return
	while(!( istype(U, /turf) ))
		U = U.loc
	if (!( istype(T, /turf) ))
		return
	if (U == T)
		user.bullet_act(PROJECTILE_BULLET, src, user.get_organ_target())
		return
	var/obj/bullet/A = new /obj/bullet( user.loc )
	if (!istype(U, /turf))
		del(A)
		return
	A.def_zone = user.get_organ_target()
	A.current = U
	A.yo = U.y - T.y
	A.xo = U.x - T.x
	user.next_move = world.time + 4
	spawn( 0 )
		A.process()
		return
	return


/obj/item/weapon/gun/carbine/examine()
	set src in usr
	if (src.magazine)
		if ((istype(src.magazine, /obj/item/weapon/ammo/assaultmag)) && (src.magazine.amount_left))
			src.desc = text("There are [] bullet\s left! Uses 5.56x45mm NATO", src.magazine.amount_left)
	else
		src.desc = "There are 0 bullets left! Uses 5.56x45mm NATO"
	..()
	return

/obj/item/weapon/gun/carbine/verb/eject()
	set name = "Eject Magazine"
	set category = "Object"
	set src in usr
	if (src.magazine)
		if (istype(src.magazine, /obj/item/weapon/ammo/assaultmag))
			if (istype(src.loc, /mob))
				var/obj/item/W = src.loc:equipped()
				var/emptyHand = (W == null)
				if(emptyHand)
					src.magazine.DblClick()
					if(!istype(src.magazine.loc, /obj/item/weapon/gun/m1911))
						src.magazine = null
						src.icon_state = "carbinenomag"
			else
				src.magazine.loc = src.loc
				src.magazine = null
	..()
	return

/obj/item/weapon/gun/carbine/attack_hand(mob/user as mob)
	if(user.r_hand == src || user.l_hand == src)
		if(src.magazine)
			if(user.hand)
				user.l_hand = src.magazine
			else
				user.r_hand = src.magazine
			src.magazine = null
	else
		return ..()

/obj/item/weapon/ammo/assaultmag/examine()
	set src in usr
	src.desc = text("There are [] bullet\s left!", src.amount_left)
	..()
	return

/obj/item/weapon/gun/carbine/attackby(obj/item/weapon/ammo/assaultmag/A as obj, mob/user as mob)
	..()

	if (istype(A, /obj/item/weapon/ammo/assaultmag))
		if (src.magazine)
			user << "\blue There is already a magazine in!"
			return 1
		user.drop_item()
		A.loc = src
		src.magazine = A
		src.icon_state = "carbine"
		return 1
	return

/obj/item/weapon/gun/carbine/attack_self(mob/user as mob)
	if (src.burst)
		src.burst = 0
		user << "\blue [src.name] set to fire single rounds."
	else
		src.burst = 1
		user << "\blue [src.name] set to fire three rounds in quick succession."

/obj/item/weapon/gun/carbine/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)

	if (flag)
		return
	if ((istype(user, /mob/living/carbon/monkey)) && ticker.mode != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return
	src.add_fingerprint(user)
	if (!src.magazine)
		usr << "\red The [src.name] isn't loaded!"
		return
// BULLET 1/3
	if (!src.magazine || ((src.magazine) && (src.magazine.amount_left < 1)))
		user.show_message("\red *click* *click*", 2)
		return
	playsound(user, 'carbine.wav', 100, 0)
	src.magazine.amount_left--
	for(var/mob/O in viewers(user, null))
		O.show_message(text("\red <B>[] fires the  carbine at []!</B>", user, target), 1, "\red You hear a gunshot", 2)
	var/turf/T = user.loc
	var/turf/U = (istype(target, /atom/movable) ? target.loc : target)
	if ((!( U ) || !( T )))
		return
	while(!( istype(U, /turf) ))
		U = U.loc
	if (!( istype(T, /turf) ))
		return
	if (U == T)
		user.bullet_act(PROJECTILE_WEAKBULLET, src, user.get_organ_target())
		return
	var/obj/bullet/weakbullet/A = new /obj/bullet/weakbullet( user.loc )
	if (!istype(U, /turf))
		del(A)
		return
	A.def_zone = user.get_organ_target()
	A.current = U
	A.yo = U.y - T.y
	A.xo = U.x - T.x
	user.next_move = world.time + 4
	spawn( 0 )
		A.process()
		return
	if (src.burst)
// BULLET 2/3
		sleep(2)
		if (!src.magazine || ((src.magazine) && (src.magazine.amount_left < 1)))
			user.show_message("\red *click* *click*", 2)
			return
		playsound(user, 'carbine.wav', 100, 0)
		src.magazine.amount_left--
		var/turf/T2 = user.loc
		if ((!( U ) || !( T2 )))
			return
		while(!( istype(U, /turf) ))
			U = U.loc
		if (!( istype(T2, /turf) ))
			return
		if (U == T2)
			user.bullet_act(PROJECTILE_WEAKBULLET, src, user.get_organ_target())
			return
		var/obj/bullet/weakbullet/A2 = new /obj/bullet/weakbullet( user.loc )
		if (!istype(U, /turf))
			del(A2)
			return
		A.def_zone = user.get_organ_target()
		A2.current = U
		A2.yo = U.y - T2.y
		A2.xo = U.x - T2.x
		user.next_move = world.time + 4
		spawn( 0 )
			A2.process()
			return
// BULLET 3/3
		sleep(2)
		if (!src.magazine || ((src.magazine) && (src.magazine.amount_left < 1)))
			user.show_message("\red *click* *click*", 2)
			return
		playsound(user, 'carbine.wav', 100, 0)
		src.magazine.amount_left--
		var/turf/T3 = user.loc
		if ((!( U ) || !( T3 )))
			return
		while(!( istype(U, /turf) ))
			U = U.loc
		if (!( istype(T3, /turf) ))
			return
		if (U == T3)
			user.bullet_act(PROJECTILE_WEAKBULLET, src, user.get_organ_target())
			return
		var/obj/bullet/weakbullet/A3 = new /obj/bullet/weakbullet( user.loc )
		if (!istype(U, /turf))
			del(A3)
			return
		A.def_zone = user.get_organ_target()
		A3.current = U
		A3.yo = U.y - T3.y
		A3.xo = U.x - T3.x
		user.next_move = world.time + 4
		spawn( 0 )
			A3.process()
			return
	return


/obj/item/weapon/gun/ak331/examine()
	set src in usr
	if (src.magazine)
		if ((istype(src.magazine, /obj/item/weapon/ammo/assaultmag)) && (src.magazine.amount_left))
			src.desc = text("There are [] bullet\s left! Uses 5.56x45mm NATO", src.magazine.amount_left)
	else
		src.desc = "There are 0 bullets left! Uses 5.56x45mm NATO"
	..()
	return

/obj/item/weapon/gun/ak331/verb/eject()
	set name = "Eject Magazine"
	set category = "Object"
	set src in usr
	if (src.magazine)
		if (istype(src.magazine, /obj/item/weapon/ammo/assaultmag))
			if (istype(src.loc, /mob))
				var/obj/item/W = src.loc:equipped()
				var/emptyHand = (W == null)
				if(emptyHand)
					src.magazine.DblClick()
					if(!istype(src.magazine.loc, /obj/item/weapon/gun/m1911))
						src.magazine = null
						src.icon_state = "ak331nomag"
			else
				src.magazine.loc = src.loc
				src.magazine = null
	..()
	return

/obj/item/weapon/gun/ak331/attack_hand(mob/user as mob)
	if(user.r_hand == src || user.l_hand == src)
		if(src.magazine)
			if(user.hand)
				user.l_hand = src.magazine
			else
				user.r_hand = src.magazine
			src.magazine = null
	else
		return ..()

/obj/item/weapon/gun/ak331/attackby(obj/item/weapon/ammo/assaultmag/A as obj, mob/user as mob)
	..()

	if (istype(A, /obj/item/weapon/ammo/assaultmag))
		if (src.magazine)
			user << "\blue There is already a magazine in!"
			return 1
		user.drop_item()
		A.loc = src
		src.magazine = A
		src.icon_state = "ak331"
		return 1
	return

/obj/item/weapon/gun/ak331/attack_self(mob/user as mob)
	if (src.burst)
		src.burst = 0
		user << "\blue [src.name] set to fire single rounds."
	else
		src.burst = 1
		user << "\blue [src.name] set to fire three rounds in quick succession."

/obj/item/weapon/gun/ak331/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)

	if (flag)
		return
	if ((istype(user, /mob/living/carbon/monkey)) && ticker.mode != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return
	src.add_fingerprint(user)
	if (!src.magazine)
		usr << "\red The [src.name] isn't loaded!"
		return
// BULLET 1/3
	if (!src.magazine || ((src.magazine) && (src.magazine.amount_left < 1)))
		user.show_message("\red *click* *click*", 2)
		return
	for(var/mob/O in viewers(user, null))
		O.show_message(text("\red <B>[] fires the carbine at []!</B>", user, target), 1, "\red You hear a gunshot", 2)
	playsound(user, 'ak331.wav', 100, 0)
	src.magazine.amount_left--
	var/turf/T = user.loc
	var/turf/U = (istype(target, /atom/movable) ? target.loc : target)
	if ((!( U ) || !( T )))
		return
	while(!( istype(U, /turf) ))
		U = U.loc
	if (!( istype(T, /turf) ))
		return
	if (U == T)
		user.bullet_act(PROJECTILE_BULLET, src, user.get_organ_target())
		return
	var/obj/bullet/A = new /obj/bullet( user.loc )
	if (!istype(U, /turf))
		del(A)
		return
	A.def_zone = user.get_organ_target()
	A.current = U
	A.yo = U.y - T.y
	A.xo = U.x - T.x
	user.next_move = world.time + 4
	spawn( 0 )
		A.process()
		return
	if (src.burst)
// BULLET 2/3
		sleep(2)
		if (!src.magazine || ((src.magazine) && (src.magazine.amount_left < 1)))
			user.show_message("\red *click* *click*", 2)
			return
		playsound(user, 'ak331.wav', 100, 0)
		src.magazine.amount_left--
		var/turf/T2 = user.loc
		if ((!( U ) || !( T2 )))
			return
		while(!( istype(U, /turf) ))
			U = U.loc
		if (!( istype(T2, /turf) ))
			return
		if (U == T2)
			user.bullet_act(PROJECTILE_BULLET, src, user.get_organ_target())
			return
		var/obj/bullet/A2 = new /obj/bullet( user.loc )
		if (!istype(U, /turf))
			del(A2)
			return
		A.def_zone = user.get_organ_target()
		A2.current = U
		A2.yo = U.y - T2.y
		A2.xo = U.x - T2.x
		user.next_move = world.time + 4
		spawn( 0 )
			A2.process()
			return
// BULLET 3/3
		sleep(2)
		if (!src.magazine || ((src.magazine) && (src.magazine.amount_left < 1)))
			user.show_message("\red *click* *click*", 2)
			return
		playsound(user, 'ak331.wav', 100, 0)
		src.magazine.amount_left--
		var/turf/T3 = user.loc
		if ((!( U ) || !( T3 )))
			return
		while(!( istype(U, /turf) ))
			U = U.loc
		if (!( istype(T, /turf) ))
			return
		if (U == T3)
			user.bullet_act(PROJECTILE_BULLET, src, user.get_organ_target())
			return
		var/obj/bullet/A3 = new /obj/bullet( user.loc )
		if (!istype(U, /turf))
			del(A3)
			return
		A.def_zone = user.get_organ_target()
		A3.current = U
		A3.yo = U.y - T3.y
		A3.xo = U.x - T3.x
		user.next_move = world.time + 4
		spawn( 0 )
			A3.process()
			return
	return

