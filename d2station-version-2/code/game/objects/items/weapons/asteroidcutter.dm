/obj/item/weapon/asteroidcutter/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(user.stat || user.restrained() || user.lying)
		return
	if (istype(W,/obj/item/weapon/tank/plasma))
		if(src.loaded)
			user << "\red There's already a tank loaded!"
			return
		src.loaded = W
		W.loc = src
		if (user.client)
			user.client.screen -= W
		user.u_equip(W)
		user << "\blue The asteroid cutter is now loaded with a tank of plasma."
		lit = 0
		force = 3
		damtype = "brute"
		icon_state = "asteroidcutterloaded"
		item_state = "acutter_loaded"
		loaded = 1
	return

/obj/item/weapon/asteroidcutter/proc/eyecheck(mob/user as mob)
	//check eye protection
	var/safety = null
	if (istype(user, /mob/living/carbon/human))
		if (istype(user:head, /obj/item/clothing/head/helmet/welding) || istype(user:head, /obj/item/clothing/head/helmet/space))
			safety = 2
		else if (istype(user:glasses, /obj/item/clothing/glasses/sunglasses))
			safety = 1
		else if (istype(user:glasses, /obj/item/clothing/glasses/thermal))
			safety = -1
		else
			safety = 0
	else if(istype(user, /mob/living/carbon))
		safety = 0
	switch(safety)
		if(1)
			usr << "\red Your eyes sting a little."
			user.eye_stat += rand(1, 2)
			if(user.eye_stat > 12)
				user.eye_blurry += rand(3,6)
		if(0)
			usr << "\red Your eyes burn."
			user.eye_stat += rand(2, 4)
			if(user.eye_stat > 10)
				user.eye_blurry += rand(4,10)
		if(-1)
			usr << "\red Your thermals intensify the cutter's beam. Your eyes itch and burn severely."
			user.eye_blurry += rand(12,20)
			user.eye_stat += rand(12, 16)
	if(user.eye_stat > 10 && safety < 2)
		user << "\red Your eyes are really starting to hurt. This can't be good for you!"
	if (prob(user.eye_stat - 25 + 1))
		user << "\red You go blind!"
		user.sdisabilities |= 1
	else if (prob(user.eye_stat - 15 + 1))
		user << "\red You go blind!"
		user.eye_blind = 5
		user.eye_blurry = 5
		user.disabilities |= 1
		spawn(100)
			user.disabilities &= ~1

/obj/item/weapon/asteroidcutter/attack_self(mob/user as mob)
	if(src.loaded < 1)	return
	src.lit = !( src.lit )
	if (src.lit)
		user << "\blue Asteroid cutter lit."
		src.force = 22
		src.damtype = "fire"
		src.icon_state = "asteroidcutterlit"
		src.item_state = "acutter_lit"
		processing_items.Add(src)
	else
		user << "\blue Cutter not lit anymore."
		src.force = 6
		src.damtype = "brute"
		src.icon_state = "asteroidcutterloaded"
		src.item_state = "acutter_loaded"
	return

/obj/item/weapon/asteroidcutter/process()
	if(!lit)
		processing_items.Remove(src)
		return

	var/turf/location = src.loc
	if(istype(location, /mob/))
		var/mob/M = location
		if(M.l_hand == src || M.r_hand == src)
			location = M.loc

	if (istype(location, /turf))
		location.hotspot_expose(700, 5)
