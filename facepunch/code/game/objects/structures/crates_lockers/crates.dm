//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/structure/closet/crate
	name = "crate"
	desc = "A rectangular steel crate."
	icon = 'icons/obj/storage.dmi'
	icon_state = "crate"
	density = 1
	icon_opened = "crateopen"
	icon_closed = "crate"
	req_access = null
	opened = 0
	flags = FPRINT
//	mouse_drag_pointer = MOUSE_ACTIVE_POINTER	//???
	var/rigged = 0

/obj/structure/closet/crate/internals
	desc = "A internals crate."
	name = "Internals crate"
	icon = 'icons/obj/storage.dmi'
	icon_state = "o2crate"
	density = 1
	icon_opened = "o2crateopen"
	icon_closed = "o2crate"

/obj/structure/closet/crate/internals/filled
	New()
		..()
		new /obj/item/weapon/tank/emergency_oxygen(src)
		new /obj/item/weapon/tank/emergency_oxygen(src)
		new /obj/item/weapon/tank/emergency_oxygen(src)
		new /obj/item/weapon/tank/emergency_oxygen(src)
		new /obj/item/weapon/tank/emergency_oxygen(src)
		new /obj/item/weapon/tank/emergency_oxygen(src)
		new /obj/item/weapon/tank/emergency_oxygen(src)
		new /obj/item/weapon/tank/emergency_oxygen(src)

/obj/structure/closet/crate/trashcart
	desc = "A heavy, metal trashcart with wheels."
	name = "Trash Cart"
	icon = 'icons/obj/storage.dmi'
	icon_state = "trashcart"
	density = 1
	icon_opened = "trashcartopen"
	icon_closed = "trashcart"

/obj/structure/closet/crate/medical
	desc = "A medical crate."
	name = "Medical crate"
	icon = 'icons/obj/storage.dmi'
	icon_state = "medicalcrate"
	density = 1
	icon_opened = "medicalcrateopen"
	icon_closed = "medicalcrate"

/obj/structure/closet/crate/rcd
	desc = "A crate for the storage of the RCD."
	name = "RCD crate"
	icon = 'icons/obj/storage.dmi'
	icon_state = "crate"
	density = 1
	icon_opened = "crateopen"
	icon_closed = "crate"

/obj/structure/closet/crate/freezer
	desc = "A freezer."
	name = "Freezer"
	icon = 'icons/obj/storage.dmi'
	icon_state = "freezer"
	density = 1
	icon_opened = "freezeropen"
	icon_closed = "freezer"

/obj/structure/closet/crate/bin
	desc = "A large bin."
	name = "Large bin"
	icon = 'icons/obj/storage.dmi'
	icon_state = "largebin"
	density = 1
	icon_opened = "largebinopen"
	icon_closed = "largebin"

/obj/structure/closet/crate/radiation
	desc = "A crate with a radiation sign on it."
	name = "Radioactive gear crate"
	icon = 'icons/obj/storage.dmi'
	icon_state = "radiation"
	density = 1
	icon_opened = "radiationopen"
	icon_closed = "radiation"


/obj/structure/closet/crate/radiation/engy
	name = "Engineering Supplies"
	New()
		..()
		new /obj/item/weapon/storage/toolbox/electrical
		new /obj/item/clothing/gloves/yellow
		new /obj/item/weapon/tank/emergency_oxygen/double
		new /obj/item/clothing/mask/gas


/obj/structure/closet/crate/secure/weapon
	desc = "A secure weapons crate."
	name = "Weapons crate"
	icon = 'icons/obj/storage.dmi'
	icon_state = "weaponcrate"
	density = 1
	icon_opened = "weaponcrateopen"
	icon_closed = "weaponcrate"

/obj/structure/closet/crate/secure/weapon/filled
	#ifdef NEWMAP
	req_access = list(access_sec_gear_area)
	#else
	req_access = list(access_security)
	#endif
	New()
		..()
		spawn(2)
			new/obj/item/weapon/melee/baton(src)
			new/obj/item/weapon/melee/baton(src)
			new/obj/item/weapon/melee/baton(src)
			new/obj/item/weapon/melee/baton(src)
			new/obj/item/weapon/gun/energy/laser(src)
			new/obj/item/weapon/gun/energy/laser(src)
			new/obj/item/weapon/gun/energy/laser(src)
			new/obj/item/weapon/gun/energy/laser(src)


/obj/structure/closet/crate/secure/plasma
	desc = "A secure plasma crate."
	name = "Plasma crate"
	icon = 'icons/obj/storage.dmi'
	icon_state = "plasmacrate"
	density = 1
	icon_opened = "plasmacrateopen"
	icon_closed = "plasmacrate"

/obj/structure/closet/crate/secure/gear
	desc = "A secure gear crate."
	name = "Gear crate"
	icon = 'icons/obj/storage.dmi'
	icon_state = "secgearcrate"
	density = 1
	icon_opened = "secgearcrateopen"
	icon_closed = "secgearcrate"

/obj/structure/closet/crate/secure/hydrosec
	desc = "A crate with a lock on it, painted in the scheme of the station's botanists."
	name = "secure hydroponics crate"
	icon = 'icons/obj/storage.dmi'
	icon_state = "hydrosecurecrate"
	density = 1
	icon_opened = "hydrosecurecrateopen"
	icon_closed = "hydrosecurecrate"

/obj/structure/closet/crate/secure/bin
	desc = "A secure bin."
	name = "Secure bin"
	icon_state = "largebins"
	icon_opened = "largebinsopen"
	icon_closed = "largebins"
	redlight = "largebinr"
	greenlight = "largebing"
	sparks = "largebinsparks"
	emag = "largebinemag"

/obj/structure/closet/crate/secure
	desc = "A secure crate."
	name = "Secure crate"
	icon_state = "securecrate"
	icon_opened = "securecrateopen"
	icon_closed = "securecrate"
	var/redlight = "securecrater"
	var/greenlight = "securecrateg"
	var/sparks = "securecratesparks"
	var/emag = "securecrateemag"
	var/broken = 0
	var/locked = 1


/obj/structure/closet/crate/juice
	New()
		..()
		new/obj/machinery/juicer(src)
		new/obj/item/weapon/reagent_containers/food/snacks/grown/tomato(src)
		new/obj/item/weapon/reagent_containers/food/snacks/grown/carrot(src)
		new/obj/item/weapon/reagent_containers/food/snacks/grown/berries(src)
		new/obj/item/weapon/reagent_containers/food/snacks/grown/banana(src)
		new/obj/item/weapon/reagent_containers/food/snacks/grown/tomato(src)
		new/obj/item/weapon/reagent_containers/food/snacks/grown/carrot(src)
		new/obj/item/weapon/reagent_containers/food/snacks/grown/berries(src)
		new/obj/item/weapon/reagent_containers/food/snacks/grown/banana(src)
		new/obj/item/weapon/reagent_containers/food/snacks/grown/tomato(src)
		new/obj/item/weapon/reagent_containers/food/snacks/grown/carrot(src)
		new/obj/item/weapon/reagent_containers/food/snacks/grown/berries(src)
		new/obj/item/weapon/reagent_containers/food/snacks/grown/banana(src)

/obj/structure/closet/crate/secure/pa
	name = "Partical Accelerator crate"
	#ifdef NEWMAP
	req_access = list(access_engineering_area)
	#else
	req_access = list(access_ce)
	#endif

	New()
		new/obj/structure/particle_accelerator/fuel_chamber(src)
		new/obj/machinery/particle_accelerator/control_box(src)
		new/obj/structure/particle_accelerator/particle_emitter/center(src)
		new/obj/structure/particle_accelerator/particle_emitter/left(src)
		new/obj/structure/particle_accelerator/particle_emitter/right(src)
		new/obj/structure/particle_accelerator/power_box(src)
		new/obj/structure/particle_accelerator/end_cap(src)


/obj/structure/closet/crate/hydroponics
	name = "Hydroponics crate"
	desc = "All you need to destroy those pesky weeds and pests."
	icon = 'icons/obj/storage.dmi'
	icon_state = "hydrocrate"
	icon_opened = "hydrocrateopen"
	icon_closed = "hydrocrate"
	density = 1

/obj/structure/closet/crate/hydroponics/prespawned
	//This exists so the prespawned hydro crates spawn with their contents.
/*	name = "Hydroponics crate"
	desc = "All you need to destroy those pesky weeds and pests."
	icon = 'icons/obj/storage.dmi'
	icon_state = "hydrocrate"
	icon_opened = "hydrocrateopen"
	icon_closed = "hydrocrate"
	density = 1*/
	New()
		..()
		new /obj/item/weapon/reagent_containers/spray/plantbgone(src)
		new /obj/item/weapon/reagent_containers/spray/plantbgone(src)
		new /obj/item/weapon/minihoe(src)
//		new /obj/item/weapon/weedspray(src)
//		new /obj/item/weapon/weedspray(src)
//		new /obj/item/weapon/pestspray(src)
//		new /obj/item/weapon/pestspray(src)
//		new /obj/item/weapon/pestspray(src)


/obj/structure/closet/crate/secure/New()
	..()
	if(istype(src, /obj/structure/closet/crate/secure/locked))
		return
	if(locked)
		overlays.Cut()
		overlays += redlight
	else
		overlays.Cut()
		overlays += greenlight

/obj/structure/closet/crate/rcd/New()
	..()
	new /obj/item/weapon/rcd_ammo(src)
	new /obj/item/weapon/rcd_ammo(src)
	new /obj/item/weapon/rcd_ammo(src)
	new /obj/item/weapon/rcd(src)

/obj/structure/closet/crate/radiation/New()
	..()
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)

/obj/structure/closet/crate/open()
	playsound(src.loc, 'sound/machines/click.ogg', 15, 1, -3)

	for(var/obj/O in src)
		O.loc = get_turf(src)

	icon_state = icon_opened
	src.opened = 1

/obj/structure/closet/crate/close()
	playsound(src.loc, 'sound/machines/click.ogg', 15, 1, -3)

	var/itemcount = 0

	for(var/obj/O in get_turf(src))
		if(itemcount >= storage_capacity)
			break

		if(O.density || O.anchored || istype(O,/obj/structure/closet))
			continue

		if(istype(O, /obj/structure/stool/bed)) //This is only necessary because of rollerbeds and swivel chairs.
			var/obj/structure/stool/bed/B = O
			if(B.buckled_mob)
				continue

		O.loc = src
		itemcount++

	icon_state = icon_closed
	src.opened = 0

/obj/structure/closet/crate/attack_hand(mob/user as mob)
	if(opened)
		close()
	else
		if(rigged && locate(/obj/item/device/radio/electropack) in src)
			if(isliving(user))
				var/mob/living/L = user
				if(L.electrocute_act(17, src))
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(5, 1, src)
					s.start()
					return
		open()
	return

/obj/structure/closet/crate/secure/attack_hand(mob/user as mob)
	if(locked && !broken)
		if (allowed(user))
			user << "<span class='notice'>You unlock [src].</span>"
			src.locked = 0
			overlays.Cut()
			overlays += greenlight
			return
		else
			user << "<span class='notice'>[src] is locked.</span>"
			return
	else
		..()

/obj/structure/closet/crate/secure/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/card) && src.allowed(user) && !locked && !opened && !broken)
		user << "<span class='notice'>You lock \the [src].</span>"
		src.locked = 1
		overlays.Cut()
		overlays += redlight
		return
	else if ( (istype(W, /obj/item/weapon/card/emag)||istype(W, /obj/item/weapon/melee/energy/blade)) && locked &&!broken)
		overlays.Cut()
		overlays += emag
		overlays += sparks
		spawn(6) overlays -= sparks //Tried lots of stuff but nothing works right. so i have to use this *sadface*
		playsound(src.loc, "sparks", 60, 1)
		src.locked = 0
		src.broken = 1
		user << "<span class='notice'>You unlock \the [src].</span>"
		return

	return ..()

/obj/structure/closet/crate/attack_paw(mob/user as mob)
	return attack_hand(user)

/obj/structure/closet/crate/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(opened)
		if(isrobot(user))
			return
		user.drop_item()
		if(W)
			W.loc = src.loc
	else if(istype(W, /obj/item/weapon/packageWrap))
		return
	else if(istype(W, /obj/item/weapon/cable_coil))
		if(rigged)
			user << "<span class='notice'>[src] is already rigged!</span>"
			return
		user  << "<span class='notice'>You rig [src].</span>"
		user.drop_item()
		del(W)
		rigged = 1
		return
	else if(istype(W, /obj/item/device/radio/electropack))
		if(rigged)
			user  << "<span class='notice'>You attach [W] to [src].</span>"
			user.drop_item()
			W.loc = src
			return
	else if(istype(W, /obj/item/weapon/wirecutters))
		if(rigged)
			user  << "<span class='notice'>You cut away the wiring.</span>"
			playsound(loc, 'sound/items/Wirecutter.ogg', 100, 1)
			rigged = 0
			return
	else return attack_hand(user)

/obj/structure/closet/crate/secure/emp_act(severity)
	for(var/obj/O in src)
		O.emp_act(severity)
	if(!broken && !opened  && prob(50/severity))
		if(!locked)
			src.locked = 1
			overlays.Cut()
			overlays += redlight
		else
			overlays.Cut()
			overlays += emag
			overlays += sparks
			spawn(6) overlays -= sparks //Tried lots of stuff but nothing works right. so i have to use this *sadface*
			playsound(src.loc, 'sound/effects/sparks4.ogg', 75, 1)
			src.locked = 0
	if(!opened && prob(20/severity))
		if(!locked)
			open()
		else
			src.req_access = list()
			src.req_access += pick(get_all_accesses())
	..()


/obj/structure/closet/crate/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/obj/O in src.contents)
				del(O)
			del(src)
			return
		if(2.0)
			for(var/obj/O in src.contents)
				if(prob(50))
					del(O)
			del(src)
			return
		if(3.0)
			if (prob(50))
				del(src)
			return
		else
	return

/////////////////////////////////////// LOCKED CRATES /////////////////////////////////////////////

/obj/structure/closet/crate/secure/locked
	desc = "A locked crate with a decicode lock. Maybe there are goodies inside..."
	name = "Locked crate"
	icon = 'icons/obj/storage.dmi'
	icon_state = "cratelocked"
	density = 1
	icon_opened = "crateunlockedopen"
	icon_closed = "crateunlocked"
	var/attempts = 0
	var/lastguess = null
	var/code = null
	var/permalocked = 0

/obj/structure/closet/crate/secure/locked/New() // maybe there's a better way to do this...
	code = rand(1,10) // create a lock code
	var/typeofcrate = rand(1, 20) // 5% increments, we want weighted probability here!
	switch(typeofcrate)
		if(1) // 5%
			new/obj/item/adamantitecore/diamond(src)
		if(2 to 4) // 15% | 25% total
			new/obj/item/weapon/reagent_containers/food/drinks/thirteenloko(src) // driiinks
			new/obj/item/weapon/reagent_containers/food/drinks/beer(src)
			new/obj/item/weapon/reagent_containers/food/drinks/beer(src)
			new/obj/item/weapon/reagent_containers/food/drinks/beer(src)
			new/obj/item/weapon/reagent_containers/food/drinks/beer(src)
		if(5 to 7) // 15% | 40% total
			new/obj/item/weapon/reagent_containers/food/drinks/space_mountain_wind(src) // driiinks
			new/obj/item/weapon/reagent_containers/food/drinks/beer(src)
			new/obj/item/weapon/reagent_containers/food/drinks/beer(src)
			new/obj/item/weapon/reagent_containers/food/drinks/beer(src)
			new/obj/item/weapon/reagent_containers/food/drinks/beer(src)
		if(8 to 10) // 15% | 55% total
			var/obj/item/weapon/reagent_containers/glass/beaker/A = new/obj/item/weapon/reagent_containers/glass/beaker/large(src) // tricord
			var/obj/item/weapon/reagent_containers/glass/beaker/B = new/obj/item/weapon/reagent_containers/glass/beaker/large(src) // inaprovaline
			var/obj/item/weapon/reagent_containers/glass/beaker/C = new/obj/item/weapon/reagent_containers/glass/beaker/large(src) // dexalin plus
			var/obj/item/weapon/reagent_containers/glass/beaker/D = new/obj/item/weapon/reagent_containers/glass/beaker/large(src) // clonexadone
			A.reagents.add_reagent("tricordrazine", 100)
			B.reagents.add_reagent("inaprovaline", 100)
			C.reagents.add_reagent("dexalinp", 100)
			D.reagents.add_reagent("clonexadone", 100)
		if(11) //5% | 60% total
			new/obj/item/stack/sheet/mineral/diamond(src, 10)
			new/obj/item/stack/sheet/mineral/gold(src, 10)
		if(12 to 15) // 15% | 75% total
			new/obj/item/clothing/under/sexyclown(src)
			new/obj/item/clothing/mask/gas/sexyclown(src)
			new/obj/item/clothing/mask/gas/clown_hat(src)
		if(16)
			var/randnum = rand(1,3)
			switch(randnum)
				if(1)
					new/obj/item/weapon/gun/energy(src)
				if(2)
					new/obj/item/weapon/gun/energy/ionrifle(src)
				if(3)
					new/obj/item/weapon/gun/energy/floragun(src)
		if(17 to 20)
			new/obj/item/weapon/pickaxe/drill(src)
			new/obj/item/clothing/glasses/meson(src)
			new/obj/item/weapon/pickaxe/jackhammer(src)
	..()
	return

/obj/structure/closet/crate/secure/locked/attack_hand(mob/living/user as mob)
	if(permalocked && !broken)
		user << "The crate's lock has fused together. You cannot input any codes."
		return
	if(locked && !broken)
		var/guess = input("Enter an integer between 1 and 10. You have [3-attempts] tries left before the lock fuses shut", "Decicode Panel") as num
		if(!in_range(src, user))
			user << "You are too far away from the crate to input codes."
			return
		if(IsInteger(guess) && guess <= 10 && guess >= 1) //Guess is between 1 and 10
			if(guess == code) // Guessed right!
				src.visible_message("\red The locked crate clicks open!")
				locked = 0
				icon_state = icon_closed
				return
			else
				attempts++
				if(attempts >= 3) // max number of tries
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(12, 1, src)
					s.start()
					if(istype(user, /mob/living/carbon))
						var/mob/living/carbon/M = user
						M.electrocute_act(10, src)
					src.visible_message("\red Sparks fly out as the crate's lock fuses shut.")
					permalocked = 1
					return
				src.visible_message("\red The locked crate flashes red!")
				lastguess = guess
				return
		else
			user << "That is not a valid input! No attempts have been used."
	else
		return ..()


/*	if(locked && !broken)
		if (allowed(user))
			user << "<span class='notice'>You unlock [src].</span>"
			src.locked = 0
			overlays.Cut()
			overlays += greenlight
			return
		else
			user << "<span class='notice'>[src] is locked.</span>"
			return
	else
		..()*/

/obj/structure/closet/crate/secure/locked/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if( (istype(W, /obj/item/weapon/card/emag)||istype(W, /obj/item/weapon/melee/energy)) && locked && !broken)
		icon_state = icon_closed
		overlays += emag
		overlays += sparks
		spawn(6) overlays -= sparks //Tried lots of stuff but nothing works right. so i have to use this *sadface*
		playsound(src.loc, "sparks", 60, 1)
		src.locked = 0
		src.broken = 1
		if(istype(W, /obj/item/weapon/card/emag))
			user << "<span class='notice'>You unlock the [src].</span>"
		else
			user << "<span class='notice'>You slice open the [src]'s lock.</span>"
		return
	if( (istype(W, /obj/item/device/multitool)) && locked && !broken)
		if(permalocked)
			user << "The lock has fused shut. The crate no longer accepts any inputs."
			return
		if(!lastguess)
			user << "No attempts have been made to open this crate yet."
		else if(lastguess < code)
			user << "The last input ([lastguess]) is lower than the correct code number. There are [3-attempts] attempts remaining to open this crate."
		else if(lastguess > code)
			user << "The last input ([lastguess]) is higher than the correct code number. There are [3-attempts] attempts remaining to open this crate."
		return
	return ..()



/obj/structure/closet/crate/grineer
	name = "Grineer crate"
	desc = "A heavy rounded crate of alien origin."
	icon = 'icons/obj/warframe_objs.dmi'
	icon_state = "grineer_crate"
	density = 1
	icon_opened = "grineer_crate_open"
	icon_closed = "grineer_crate"