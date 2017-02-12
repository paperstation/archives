#define FLASHLIGHT_LUM 4

/obj/item/device/flashlight/attack_self(mob/user)
	if(!power)
		on = 0
		icon_state = icon_off
		return

	on = !on
	if (on)
		icon_state = icon_on
	else
		icon_state = icon_off


	if(on)
		src.ul_SetLuminosity(max_lum)
		powerdrain(user)
	else
		//user.ul_SetLuminosity(user.luminosity - brightness_on)
		src.ul_SetLuminosity(0)

/obj/item/device/flashlight/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/cell))
		if(power)
			user << "There is already a power cell inside."
			return
		else
			// insert cell
			var/obj/item/weapon/cell/C = usr.equipped()
			if(istype(C))
				user.drop_item()
				power = C
				C.loc = src
				C.add_fingerprint(usr)

/obj/item/device/flashlight/verb/removecell()
	set name = "Remove Cell"
	set src in oview(1)
	if(power)
		for(var/mob/V in viewers(usr))
			usr.visible_message("[usr] removes the cell.")
		usr.put_in_hand(power)
		power.add_fingerprint(usr)
		power = null
		powerdrain(usr)
	else
		usr << "There is no cell inside."

/obj/item/device/flashlight/proc/powerdrain(mob/user)
	while(on)
		if(power.charge > 0)
			power.use(0.1)
			var/ratio = round(power.charge / 100, 1)
			if(max_lum != ratio)
				src.ul_SetLuminosity(ratio)
				max_lum = ratio
				if(max_lum < 1)
					attack_self(user)
					break
				else if(max_lum > 15)
					var/location = get_turf(src)
					var/datum/effects/system/reagents_explosion/e = new()
					e.set_up(rand(2,1), location, 0, 0)
					sleep(10)
					e.start()
					for(var/mob/V in viewers(usr))
						usr.visible_message("\red The [src.name] explodes")
					del src
				sleep(250)
		else
			attack_self(user)
			break

/obj/item/device/flashlight/attack(mob/M as mob, mob/user as mob)
	src.add_fingerprint(user)
	if(src.on && user.zone_sel.selecting == "eyes")
		if ((user.mutations & CLOWN || user.brainloss >= 60) && prob(50))//too dumb to use flashlight properly
			return ..()//just hit them in the head
			/*user << "\blue You bounce the light spot up and down and drool."
			for(var/mob/O in viewers(M, null))
				O.show_message(text("\blue [] bounces the light spot up and down and drools", user), 1)
			src.add_fingerprint(user)
			return*/

		if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")//don't have dexterity
			usr.show_message("\red You don't have the dexterity to do this!",1)
			return

		var/mob/living/carbon/human/H = M//mob has protective eyewear
		if(istype(M, /mob/living/carbon/human) && ((H.head && H.head.flags & HEADCOVERSEYES) || (H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) || (H.glasses && H.glasses.flags & GLASSESCOVERSEYES)))
			user << text("\blue You're going to need to remove that [] first.", ((H.head && H.head.flags & HEADCOVERSEYES) ? "helmet" : ((H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) ? "mask": "glasses")))
			return

		for(var/mob/O in viewers(M, null))//echo message
			if ((O.client && !(O.blinded )))
				O.show_message("\blue [(O==user?"You direct":"[user] directs")] [src] to [(M==user? "your":"[M]")] eyes", 1)

		if(istype(M, /mob/living/carbon/human) || istype(M, /mob/living/carbon/monkey))//robots and aliens are unaffected
			if(M.stat > 1 || M.sdisabilities & 1)//mob is dead or fully blind
				if(M!=user)
					user.show_message(text("\red [] pupils does not react to the light!", M),1)
			else if(M.mutations & XRAY)//mob has X-RAY vision
				if(M!=user)
					user.show_message(text("\red [] pupils give an eerie glow!", M),1)
			else //nothing wrong
				flick("flash", M.flash)//flash the affected mob
				if(M!=user)
					user.show_message(text("\blue [] pupils narrow", M),1)
	else
		return ..()

/obj/item/device/flashlight/New()
	power = new(src)
	power.give(power.maxcharge)
	max_lum = round(power.maxcharge / 100, 1)

/obj/item/device/flashlight/pickup(mob/user)
	user.lum_list += src

//	if(on)
//		src.ul_SetLuminosity(0)
//		user.ul_SetLuminosity(user.luminosity + FLASHLIGHT_LUM)


/obj/item/device/flashlight/dropped(mob/user)
	user.lum_list -= src
	if(on)
		src.ul_SetLuminosity(max_lum)
/*
	if(on)
		user.ul_SetLuminosity(user.luminosity - FLASHLIGHT_LUM)
		src.ul_SetLuminosity(FLASHLIGHT_LUM)
*/

/obj/item/clothing/head/helmet/hardhat/verb/toggle()
	return(attack_self(usr))

/obj/item/clothing/head/helmet/hardhat/attack_self(mob/user)
	on = !on
	icon_state = "hardhat[on]_[color]"
	item_state = "hardhat[on]_[color]"

	if(on)
		//user.ul_SetLuminosity(user.luminosity + brightness_on)
		src.ul_SetLuminosity(FLASHLIGHT_LUM)
	else
		//user.ul_SetLuminosity(user.luminosity - brightness_on)
		src.ul_SetLuminosity(0)

/obj/item/clothing/head/helmet/hardhat/pickup(mob/user)
	user.lum_list += src




/obj/item/clothing/head/helmet/hardhat/dropped(mob/user)
	user.lum_list -= src
	if(on)
		src.ul_SetLuminosity(FLASHLIGHT_LUM)



