/*
CONTAINS:
FORK
ROLLING PIN
KNIFE

*/


/obj/item/weapon/kitchen/utensil/New()
	if (prob(60))
		src.pixel_y = rand(0, 4)
	return





// FORK

/obj/item/weapon/kitchen/utensil/fork/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M, /mob))
		return

	if (src.icon_state == "forkloaded") //This is a poor way of handling it, but a proper rewrite of the fork to allow for a more varied foodening can happen when I'm in the mood. --NEO
		if(M == user)
			for(var/mob/O in viewers(M, null))
				O.show_message(text("\blue [] eats a delicious forkful of omelette!", user), 1)
				M.reagents.add_reagent("nutriment", 1)
		else
			for(var/mob/O in viewers(M, null))
				O.show_message(text("\blue [] feeds [] a delicious forkful of omelette!", user, M), 1)
				M.reagents.add_reagent("nutriment", 1)
		src.icon_state = "fork"
		return



	if((usr.mutations & 16) && prob(50))
		M << "\red You stab yourself in the eye."
		M.sdisabilities |= 1
		M.weakened += 4
		M.bruteloss += 10

	src.add_fingerprint(user)
	if(!(user.zone_sel.selecting == ("eyes" || "head")))
		return ..()
	var/mob/living/carbon/human/H = M

	if(istype(M, /mob/living/carbon/human) && ((H.head && H.head.flags & HEADCOVERSEYES) || (H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) || (H.glasses && H.glasses.flags & GLASSESCOVERSEYES)))
		// you can't stab someone in the eyes wearing a mask!
		user << "\blue You're going to need to remove that mask/helmet/glasses first."
		return
	if(istype(M, /mob/living/carbon/alien))//Aliens don't have eyes./N
		user << "\blue You cannot locate any eyes on this creature!"
		return

	for(var/mob/O in viewers(M, null))
		if(O == (user || M))	continue
		if(M == user)	O.show_message(text("\red [] has stabbed themself with []!", user, src), 1)
		else	O.show_message(text("\red [] has been stabbed in the eye with [] by [].", M, src, user), 1)
	if(M != user)
		M << "\red [user] stabs you in the eye with [src]!"
		user << "\red You stab [M] in the eye with [src]!"
	else
		user << "\red You stab yourself in the eyes with [src]!"
	if(istype(M, /mob/living/carbon/human))
		var/datum/organ/external/affecting = M.organs["head"]
		affecting.take_damage(7)
	else
		M.bruteloss += 7
	M.eye_blurry += rand(3,4)
	M.eye_stat += rand(2,4)
	if (M.eye_stat >= 10)
		M << "\red Your eyes start to bleed profusely!"
		M.eye_blurry += 15+(0.1*M.eye_blurry)
		M.disabilities |= 1
		if(M.stat == 2)	return
		if(prob(50))
			M << "\red You drop what you're holding and clutch at your eyes!"
			M.eye_blurry += 10
			M.paralysis += 1
			M.weakened += 4
			M.drop_item()
		if (prob(M.eye_stat - 10 + 1))
			M << "\red You go blind!"
			M.sdisabilities |= 1
	return




// ROLLING PIN

/obj/item/weapon/kitchen/rollingpin/attack(mob/M as mob, mob/user as mob)
	if ((usr.mutations & 16) && prob(50))
		usr << "\red The [src] slips out of your hand and hits your head."
		usr.bruteloss += 10
		usr.paralysis += 2
		return
	if (M.stat < 2 && M.health < 50 && prob(90))
		var/mob/H = M
		// ******* Check
		if ((istype(H, /mob/living/carbon/human) && istype(H, /obj/item/clothing/head) && H.flags & 8 && prob(80)))
			M << "\red The helmet protects you from being hit hard in the head!"
			return
		var/time = rand(2, 6)
		if (prob(75))
			if (M.paralysis < time && (!(M.mutations & 8)) )
				M.paralysis = time
		else
			if (M.stunned < time && (!(M.mutations & 8)) )
				M.stunned = time
		if(M.stat != 2)	M.stat = 1
		for(var/mob/O in viewers(M, null))
			O.show_message(text("\red <B>[] has been knocked unconscious!</B>", M), 1, "\red You hear someone fall.", 2)
	else
		M << text("\red [] tried to knock you unconcious!",user)
		M.eye_blurry += 3

	return





// KNIFE

/obj/item/weapon/kitchen/utensil/knife/attack(target as mob, mob/user as mob)
	if ((usr.mutations & 16) && prob(50))
		usr << "\red You accidentally cut yourself with the [src]."
		usr.bruteloss += 20
		return


// SERVING TRAY

/*/obj/item/weapon/tray/attackby(obj/item/I as obj, mob/user as mob)
	if (!src.item)
		var/icon/itemicon = icon(I.icon, I.icon_state, I.dir, 1)
		var/icon/tray = icon('food.dmi',"tray")
		itemicon.Scale(18,18)
		tray.Blend(itemicon,ICON_OVERLAY,6,8)
		src.icon = tray
		user << "You lay the [I.name] onto the [src.name]."
		src.item = I
		I.loc = src
		if (user.client)
			user.client.screen -= I
		user.u_equip(I)*/
/*
/obj/item/weapon/tray/attack_hand(mob/user as mob)
	if (src.item)
			src.item = null
		..()
	else
		return ..()
*/
/*												WIP
/obj/item/weapon/tray/MouseDrop(obj/over_object as obj)
	var/icon/trayreset = icon('food.dmi',"tray")
	if ((istype(usr, /mob/living/carbon/human) || (ticker && ticker.mode.name == "monkey")))
		var/mob/M = usr
		if (!( istype(over_object, /obj/screen) ))
			return ..()
		if ((!( M.restrained() ) && !( M.stat )))
			if (over_object.name == "r_hand")
				if (!( M.r_hand ))
					M << "You take the [src.item:name] from the the [src.name]."
					M.r_hand = src.item
					src.item = null
					src.icon = trayreset
			else
				if (over_object.name == "l_hand")
					if (!( M.l_hand ))
						M << "You take the [src.item:name] from the the [src.name]."
						M.l_hand = src.item
						src.item = null
						src.icon = trayreset
			src.add_fingerprint(usr)
			return
		if(over_object == usr && in_range(src, usr))
			src.item:loc = src.loc
			M << "You take the [src.item:name] from the the [src.name]."
			src.item = null
			src.icon = trayreset
			return
	return
*/