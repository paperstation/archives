//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/* Tools!
 * Note: Multitools are /obj/item/device
 *
 * Contains:
 * 		Wrench
 * 		Screwdriver
 *      Sonic Screwdriver
 * 		Wirecutters
 * 		Welding Tool
 * 		Crowbar
 */

/*
 * Wrench
 */
/obj/item/weapon/wrench
	name = "wrench"
	desc = "A wrench with common uses. Can be found in your hand."
	icon = 'icons/obj/items.dmi'
	icon_state = "wrench"
	flags = FPRINT | TABLEPASS| CONDUCT
	slot_flags = SLOT_BELT
	force = DAMAGE_LOW
	w_class = 2.0
	m_amt = 150
	origin_tech = "materials=1;engineering=1"
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")


/*
 * Screwdriver
 */
/obj/item/weapon/screwdriver
	name = "screwdriver"
	desc = "You can be totally screwwy with this."
	icon = 'icons/obj/items.dmi'
	icon_state = "screwdriver"
	flags = FPRINT | TABLEPASS| CONDUCT
	slot_flags = SLOT_BELT
	force = DAMAGE_LOW
	forcetype = PIERCE
	w_class = 1.0
	g_amt = 0
	m_amt = 75
	attack_verb = list("stabbed")

	suicide_act(mob/user)
		viewers(user) << pick("\red <b>[user] is stabbing the [src.name] into \his temple! It looks like \he's trying to commit suicide.</b>", \
							"\red <b>[user] is stabbing the [src.name] into \his heart! It looks like \he's trying to commit suicide.</b>")
		return(BRUTELOSS)

/obj/item/weapon/screwdriver/New()
	switch(pick("red","blue","purple","brown","green","cyan","yellow"))
		if ("red")
			icon_state = "screwdriver2"
			item_state = "screwdriver"
		if ("blue")
			icon_state = "screwdriver"
			item_state = "screwdriver_blue"
		if ("purple")
			icon_state = "screwdriver3"
			item_state = "screwdriver_purple"
		if ("brown")
			icon_state = "screwdriver4"
			item_state = "screwdriver_brown"
		if ("green")
			icon_state = "screwdriver5"
			item_state = "screwdriver_green"
		if ("cyan")
			icon_state = "screwdriver6"
			item_state = "screwdriver_cyan"
		if ("yellow")
			icon_state = "screwdriver7"
			item_state = "screwdriver_yellow"

	if (prob(75))
		src.pixel_y = rand(0, 16)
	return

/obj/item/weapon/screwdriver/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M))	return ..()
	if(user.zone_sel.selecting != "eyes" && user.zone_sel.selecting != "head")
		return ..()
	if((CLUMSY in user.mutations) && prob(50))
		M = user
	return eyestab(M,user)


/*
 * Sonic Screwdriver
 */
/obj/item/weapon/sonicscrewdriver
	name = "ss-omni driver"
	desc = "Invented after many long, boring nights. It had something to do with cabnets. "
	icon = 'icons/obj/items.dmi'
	icon_state = "sonicscrewdriver-0"
	item_state = "sonicscrewdriver"
	flags = FPRINT | TABLEPASS| CONDUCT
	slot_flags = SLOT_BELT
	force = DAMAGE_LOW
	w_class = 1.0
	g_amt = 0
	m_amt = 75
	attack_verb = list("poked")
	var/owner = null

	suicide_act(mob/user)
		viewers(user) << pick("\red <b>[user] is sticking the [src.name] up \his nose and turned it on!</b>", \
							"\red <b>[user] is stabbing the [src.name] into both \his hearts!</b>")
		return(BRUTELOSS)

/obj/item/weapon/sonicscrewdriver/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if((!istype(M)) || (user != owner))	return ..()
	if(user.a_intent == "disarm")
		M.deal_damage(2, WEAKEN)
		usr.visible_message("[usr] shocks [M] with [src]!",\
		"You have shocked [M] with [src]!",\
		"You hear a buzz.")
	else
		return ..()
	return

/obj/item/weapon/sonicscrewdriver/afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
	var/turf/T = user.loc
	if(istype(target, /obj/machinery/door))
		var/obj/machinery/door/D = target
		if (user != owner)
			user << "You have no idea how to use this"
		else
			user << "\red You point [src] at the door lock."
			playsound(src.loc, 'sound/items/SonicScrewdriver.ogg', 35, 1)
			usr.visible_message("\red <B>\the [target] starts buzzing!</B>",\
			"\red <B>[src] starts buzzing</B>",\
			"\red You hear a strange buzzing")
			if ((user.get_active_hand() == src) && (do_after(user, 40)))
				if(user.loc == T)
					D.open()
	return

/obj/item/weapon/sonicscrewdriver/attack_self(mob/user as mob)
	if(!owner)
		user << "\blue [src] lights up in your hand."
		owner = user
		icon_state = "sonicscrewdriver-1"
	else
		if(user != owner)
			user << "\blue [src] remains unresponsive to you."
		else
			user << "\blue [src] blinks in your hand."

/*
 * Wirecutters
 */
/obj/item/weapon/wirecutters
	name = "wirecutters"
	desc = "This cuts wires."
	icon = 'icons/obj/items.dmi'
	icon_state = "cutters"
	flags = FPRINT | TABLEPASS| CONDUCT
	slot_flags = SLOT_BELT
	force = DAMAGE_LOW
	forcetype = SLASH
	w_class = 2.0
	m_amt = 80
	origin_tech = "materials=1;engineering=1"
	attack_verb = list("pinched", "nipped")

/obj/item/weapon/wirecutters/New()
	if(prob(50))
		icon_state = "cutters-y"
		item_state = "cutters_yellow"

/obj/item/weapon/wirecutters/attack(mob/living/carbon/C as mob, mob/user as mob)
	if((C.handcuffed) && (istype(C.handcuffed, /obj/item/weapon/handcuffs/cable)))
		usr.visible_message("\The [usr] cuts \the [C]'s restraints with \the [src]!",\
		"You cut \the [C]'s restraints with \the [src]!",\
		"You hear cable being cut.")
		C.handcuffed = null
		C.update_inv_handcuffed()
		return
	else
		..()

/*
 * Welding Tool
 */
/obj/item/weapon/weldingtool
	name = "welding tool"
	icon = 'icons/obj/items.dmi'
	icon_state = "welder"
	flags = FPRINT | TABLEPASS| CONDUCT
	slot_flags = SLOT_BELT
	var/icontype = "normal"
	force = DAMAGE_LOW
	w_class = 2.0

	//Cost to make in the autolathe
	m_amt = 70
	g_amt = 30

	//R&D tech level
	origin_tech = "engineering=1"

	//Welding tool specific stuff
	var/welding = 0 	//Whether or not the welding tool is off(0), on(1) or currently welding(2)
	var/status = 1 		//Whether the welder is secured or unsecured (able to attach rods to it to make a flamethrower)
	var/max_fuel = 20 	//The max amount of fuel the welder can hold

/obj/item/weapon/weldingtool/New()
//	var/random_fuel = min(rand(10,20),max_fuel)
	if(icontype == "scrap")
		icon_state = "scrapweld"
	var/datum/reagents/R = new/datum/reagents(max_fuel)
	reagents = R
	R.my_atom = src
	R.add_reagent("fuel", max_fuel)
	return


/obj/item/weapon/weldingtool/examine()
	..()
	usr << text("[src] contains [get_fuel()]/[max_fuel] units of fuel!")
	return

/obj/item/weapon/weldingtool/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/screwdriver))
		if(welding)
			user << "\red Stop welding first!"
			return
		status = !status
		if(status)
			user << "\blue You resecure the welder."
		else
			user << "\blue The welder can now be attached and modified."
		src.add_fingerprint(user)
		return

	if((!status) && (istype(W,/obj/item/stack/rods)))
		var/obj/item/stack/rods/R = W
		R.use(1)
		var/obj/item/weapon/flamethrower/F = new/obj/item/weapon/flamethrower(user.loc)
		src.loc = F
		F.weldtool = src
		if (user.client)
			user.client.screen -= src
		if (user.r_hand == src)
			user.u_equip(src)
		else
			user.u_equip(src)
		src.master = F
		src.layer = initial(src.layer)
		user.u_equip(src)
		if (user.client)
			user.client.screen -= src
		src.loc = F
		src.add_fingerprint(user)
		return

	..()
	return


/obj/item/weapon/weldingtool/process()
	switch(welding)
		//If off
		if(0)
			if(icontype == "normal")
				if(src.icon_state != "welder") //Check that the sprite is correct, if it isnt, it means toggle() was not called
					src.force = DAMAGE_LOW
					src.damtype = BRUTE
					forcetype = IMPACT
					src.icon_state = "welder"
					src.welding = 0
				processing_objects.Remove(src)
				return
			else if (icontype == "scrap")
				if(src.icon_state != "scrapweld") //Check that the sprite is correct, if it isnt, it means toggle() was not called
					src.force = DAMAGE_LOW
					src.damtype = BRUTE
					forcetype = IMPACT
					src.icon_state = "scrapweld"
					src.welding = 0
				processing_objects.Remove(src)
				return
		if(1)
			if(icontype == "normal")
				if(src.icon_state != "welder1") //Check that the sprite is correct, if it isnt, it means toggle() was not called
					src.force = DAMAGE_HIGH
					src.damtype = BURN
					forcetype = PIERCE
					src.icon_state = "welder1"
			else if(icontype == "scrap")
				if(src.icon_state != "scrapweld1") //Check that the sprite is correct, if it isnt, it means toggle() was not called
					src.force = DAMAGE_HIGH
					src.damtype = BURN
					forcetype = PIERCE
					src.icon_state = "scrapweld1"
			if(prob(5))
				remove_fuel(1)

	//I'm not sure what this does. I assume it has to do with starting fires...
	//...but it doesnt check to see if the welder is on or not. There is a return in the welding check above, if it is off it will never get here.
	var/turf/location = src.loc
	if(istype(location, /mob/))
		var/mob/M = location
		if(M.l_hand == src || M.r_hand == src)
			location = get_turf(M)
	if(istype(location, /turf))
		location.hotspot_expose(700, 5)


/obj/item/weapon/weldingtool/afterattack(obj/O as obj, mob/user as mob)
	if (istype(O, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,O) <= 1)
		O.reagents.trans_to(src, max_fuel)
		user << "\blue Welder refueled"
		playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
		if(!welding)
			return
		message_admins("[key_name_admin(user)] triggered a fueltank explosion.")
		log_game("[key_name(user)] triggered a fueltank explosion.")
		user << "\red Your [src.name] set the fuel on fire!"
		explosion(O.loc,-1,0,2)
		if(O)
			del(O)
		return
	if (istype(O, /obj/item/clothing/back/weld) && get_dist(src,O) <= 1)
		O.reagents.trans_to(src, max_fuel)
		user << "\blue Welder refueled"
		playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
		if(!welding)
			return
		message_admins("[key_name_admin(user)] triggered a weldpack explosion.")
		log_game("[key_name(user)] triggered a weldpack explosion.")
		user << "\red Your [src.name] set the fuel on fire!"
		user.drop_item(src)
		user.regenerate_icons()
		explosion(O.loc,-1,0,2)
		if(O)
			del(O)
			user.regenerate_icons()
		return
	if(src.welding)
		remove_fuel(1)
		var/turf/location = get_turf(user)
		if (istype(location, /turf))
			location.hotspot_expose(700, 50, 1)
	return


/obj/item/weapon/weldingtool/attack_self(mob/user as mob)
	toggle()
	return

//Returns the amount of fuel in the welder
/obj/item/weapon/weldingtool/proc/get_fuel()
	return reagents.get_reagent_amount("fuel")


//Removes fuel from the welding tool. If a mob is passed, it will perform an eyecheck on the mob. This should probably be renamed to use()
/obj/item/weapon/weldingtool/proc/remove_fuel(var/amount = 1, var/mob/M = null)
	if(!welding || !check_fuel())
		return 0
	if(get_fuel() >= amount)
		reagents.remove_reagent("fuel", amount)
		check_fuel()
		if(M)
			eyecheck(M)
		return 1
	else
		if(M)
			M << "\blue You need more welding fuel to complete this task."
		return 0

//Returns whether or not the welding tool is currently on.
/obj/item/weapon/weldingtool/proc/isOn()
	return src.welding

//Sets the welding state of the welding tool. If you see W.welding = 1 anywhere, please change it to W.setWelding(1)
//so that the welding tool updates accordingly
/obj/item/weapon/weldingtool/proc/setWelding(var/temp_welding)
	//If we're turning it on
	if(temp_welding > 0)
		if (remove_fuel(1))
			usr << "\blue The [src] switches on."
			src.force = DAMAGE_HIGH
			src.damtype = BURN
			forcetype = PIERCE
			if(icontype == "normal")
				src.icon_state = "welder1"
			else if(icontype == "scrap")
				src.icon_state = "scrapweld1"
			processing_objects.Add(src)
		else
			usr << "\blue Need more fuel!"
			src.welding = 0
			return
	//Otherwise
	else
		usr << "\blue The [src] switches off."
		src.force = DAMAGE_LOW
		src.damtype = BRUTE
		forcetype = IMPACT
		if(icontype == "normal")
			src.icon_state = "welder"
		else if(icontype == "scrap")
			src.icon_state = "scrapweld"
		src.welding = 0

//Turns off the welder if there is no more fuel (does this really need to be its own proc?)
/obj/item/weapon/weldingtool/proc/check_fuel()
	if((get_fuel() <= 0) && welding)
		toggle(1)
		return 0
	return 1


//Toggles the welder off and on
/obj/item/weapon/weldingtool/proc/toggle(var/message = 0)
	if(!status)	return
	src.welding = !src.welding
	if (src.welding)
		if (remove_fuel(1))
			usr << "\blue You switch the [src] on."
			src.force = DAMAGE_HIGH
			src.damtype = BURN
			forcetype = PIERCE
			if(icontype == "normal")
				src.icon_state = "welder1"
			else if(icontype == "scrap")
				src.icon_state = "scrapweld1"
			processing_objects.Add(src)
		else
			usr << "\blue Need more fuel!"
			src.welding = 0
			return
	else
		if(!message)
			usr << "\blue You switch the [src] off."
		else
			usr << "\blue The [src] shuts off!"
		src.force = DAMAGE_LOW
		src.damtype = BRUTE
		forcetype = IMPACT
		if(icontype == "normal")
			src.icon_state = "welder"
		else if(icontype == "scrap")
			src.icon_state = "scrapweld"
			src.welding = 0

//Decides whether or not to damage a player's eyes based on what they're wearing as protection
//Note: This should probably be moved to mob
/obj/item/weapon/weldingtool/proc/eyecheck(mob/user as mob)
	if(!iscarbon(user))	return 1
	var/safety = user:eyecheck()
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
			usr << "\red Your thermals intensify the welder's glow. Your eyes itch and burn severely."
			user.eye_blurry += rand(12,20)
			user.eye_stat += rand(12, 16)
	if(user.eye_stat > 10 && safety < 2)
		user << "\red Your eyes are really starting to hurt. This can't be good for you!"
	if (prob(user.eye_stat - 25 + 1))
		user << "\red You go blind!"
		user.sdisabilities |= BLIND
	else if (prob(user.eye_stat - 15 + 1))
		user << "\red You go blind!"
		user.eye_blind = 5
		user.eye_blurry = 5
		user.disabilities |= NEARSIGHTED
		spawn(100)
			user.disabilities &= ~NEARSIGHTED
	return


/obj/item/weapon/weldingtool/largetank
	name = "Industrial Welding Tool"
	max_fuel = 40
	m_amt = 70
	g_amt = 60
	origin_tech = "engineering=2"

/obj/item/weapon/weldingtool/hugetank
	name = "Upgraded Welding Tool"
	max_fuel = 80
	m_amt = 70
	g_amt = 120
	origin_tech = "engineering=3"

/obj/item/weapon/weldingtool/experimental
	name = "Experimental Welding Tool"
	max_fuel = 40
	m_amt = 70
	g_amt = 120
	origin_tech = "engineering=4;plasma=3"
	icon_state = "ewelder"
	var/last_gen = 0


/obj/item/weapon/weldingtool/scrap
	name = "Scrap Welding Tool"
	max_fuel = 60
	m_amt = 70
	g_amt = 120
	origin_tech = "engineering=4;plasma=3"
	icon_state = "ewelder"
	icontype = "scrap"


//I dont think this is even called anywhere
/obj/item/weapon/weldingtool/experimental/proc/fuel_gen()//Proc to make the experimental welder generate fuel, optimized as fuck -Sieve
	var/gen_amount = ((world.time-last_gen)/25)
	reagents += (gen_amount)
	if(reagents > max_fuel)
		reagents = max_fuel

/*
 * Crowbar
 */

/obj/item/weapon/crowbar
	name = "crowbar"
	desc = "Used to hit floors"
	icon = 'icons/obj/items.dmi'
	icon_state = "crowbar"
	flags = FPRINT | TABLEPASS| CONDUCT
	slot_flags = SLOT_BELT
	force = DAMAGE_LOW
	item_state = "crowbar"
	w_class = 2.0
	m_amt = 50
	origin_tech = "engineering=1"
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked")

/obj/item/weapon/crowbar/red
	icon = 'icons/obj/items.dmi'
	icon_state = "red_crowbar"
	item_state = "crowbar_red"