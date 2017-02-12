/obj/item/weapon/storage/backpack/MouseDrop(obj/over_object as obj)

//	if (src.loc != usr)
//		return
//	if ((istype(usr, /mob/living/carbon/human) || (ticker && ticker.mode.name == "monkey")))
	if (ishuman(usr) || ismonkey(usr)) //so monkies can take off their backpacks -- Urist
		var/mob/M = usr
		if (!( istype(over_object, /obj/screen) ))
			return ..()
		playsound(src.loc, "rustle", 50, 1, -5)
		if ((!( M.restrained() ) && !( M.stat ) && M.back == src))
			if (over_object.name == "r_hand")
				if (!( M.r_hand ))
					M.u_equip(src)
					M.r_hand = src
			else
				if (over_object.name == "l_hand")
					if (!( M.l_hand ))
						M.u_equip(src)
						M.l_hand = src
			M.update_clothing()
			src.add_fingerprint(usr)
			return
		if(over_object == usr && in_range(src, usr) || usr.contents.Find(src))
			if (usr.s_active)
				usr.s_active.close(usr)
			src.show_to(usr)
			return
	return

/obj/item/weapon/storage/backpack/attackby(obj/item/weapon/W as obj, mob/user as mob)
	playsound(src.loc, "rustle", 50, 1, -5)
	..()

/obj/item/weapon/storage/backpack/holding
	name = "Bag of Holding"
	desc = "A backpack that opens into a localized pocket of Blue Space."
	origin_tech = "bluespace=4"
	icon_state = "holdingpack"

	New()
		..()
		return

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(crit_fail)
			user << "\red The Bluespace generator isn't working."
			return
		if(istype(W, /obj/item/weapon/storage/backpack/holding) && !W.crit_fail)
			user << "\red The Bluespace interfaces of the two devices catastrophically malfunction!"
			del(W)
			new /obj/machinery/singularity (get_turf(src))
			del(src)
			return
		..()

	proc/failcheck(mob/user as mob)
		if (prob(src.reliability)) return 1 //No failure
		if (prob(src.reliability))
			user << "\red The Bluespace portal resists your attempt to add another item." //light failure
		else
			user << "\red The Bluespace generator malfunctions!"
			for (var/obj/O in src.contents) //it broke, delete what was in it
				del(O)
			crit_fail = 1
			icon_state = "brokenpack"

/*											//I tried to use a Topic() window with a list of items. It didn't work :C
/obj/item/weapon/bag_of_holding
	name = "bag of holding"
	desc = "A backpack that opens into a localized pocket of Blue Space."
	origin_tech = "bluespace=4"
	icon = 'storage.dmi'
	icon_state = "holdingpack"
	flags =  FPRINT | TABLEPASS | CONDUCT | ONBACK
	var/list/stored_items = list()

	New()
		..()
		return

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(crit_fail)
			user << "\red The Bluespace generator isn't working."
			return
		if(istype(W, /obj/item/weapon/bag_of_holding) && !W.crit_fail)
			user << "\red The Bluespace interfaces of the two devices catastrophically malfunction!"
			del(W)
			new /obj/machinery/singularity (get_turf(src))
			del(src)
			return
		user.u_equip(W)
		W.loc = src
		if ((user.client && user.s_active != src))
			user.client.screen -= W
		W.dropped(user)
		add_fingerprint(user)
		stored_items += W
		if (istype(W, /obj/item/weapon/gun/energy/crossbow)) return //STEALTHY
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\blue [user] has added [W] to [src]!"))
		return

	proc/failcheck(mob/user as mob)
		if (prob(src.reliability)) return 1 //No failure
		if (prob(src.reliability))
			user << "\red The Bluespace portal resists your attempt to add another item." //light failure
		else
			user << "\red The Bluespace generator malfunctions!"
			for (var/obj/O in src.contents) //it broke, delete what was in it
				del(O)
			crit_fail = 1
			icon_state = "brokenpack"

	Topic(href, href_list)
		if(..())
			return

		add_fingerprint(usr)
		usr.machine = src

		if(href_list["drop"])
			for(var/obj/item/I in stored_items)
				if(I == text2num(href_list["drop"]))
					stored_items -= I
					I.loc = get_turf(src)
					break

		updateUsrDialog()
		return

	attack_hand(mob/user as mob)
		if(crit_fail)
			return
		user.machine = src
		var/dat = ""

		dat += "Contents: <BR>"

		for(var/obj/item/I in stored_items)
			dat += "<A href='?src=\ref[src];drop=[I]'> [I.name]</A><BR>"

		dat += "<BR><A href='?src=\ref[];mach_close=bagofholding[]'>Close</A>"

		user << browse("<TITLE>Bag of Holding</TITLE><HR>[dat]", "window=bagofholding;size=200x250")
		onclose(user, "bagofholding")
		return

	MouseDrop(obj/over_object as obj)
		if (ishuman(usr) || ismonkey(usr)) //so monkies can take off their backpacks -- Urist
			var/mob/M = usr
			if (!( istype(over_object, /obj/screen) ))
				return ..()
			playsound(src.loc, "rustle", 50, 1, -5)
			if ((!( M.restrained() ) && !( M.stat ) && M.back == src))
				if (over_object.name == "r_hand")
					if (!( M.r_hand ))
						M.u_equip(src)
						M.r_hand = src
				else
					if (over_object.name == "l_hand")
						if (!( M.l_hand ))
							M.u_equip(src)
							M.l_hand = src
				M.update_clothing()
				src.add_fingerprint(usr)
				return
			if(over_object == usr && in_range(src, usr) || usr.contents.Find(src))
				return attack_hand(usr)
		return*/

/obj/item/weapon/storage/recyclingbin/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if (src.contents.len >= 7)
		return
	if (W.w_class > 3 || src.loc == W)
		return
	var/t
	for(var/obj/item/weapon/O in src)
		t += O.w_class
		//Foreach goto(46)
	t += W.w_class
	if (t > 20)
		user << "You cannot fit the item inside. (Remove larger classed items)"
		return
	playsound(src.loc, "rustle", 50, 1, -5)
	user.u_equip(W)
	W.loc = src
	if ((user.client && user.s_active != src))
		user.client.screen -= W
	src.orient2hud(user)
	W.dropped(user)
	if (istype(W, /obj/item/weapon/gun/energy/crossbow)) return //STEALTHY
	add_fingerprint(user)
//	for(var/mob/O in viewers(user, null))
//		O.show_message(text("\blue [] has put [] into the []!", user, W, src), 1)
		//Foreach goto(206)
	return

/obj/item/weapon/storage/recyclingbin/attack_paw(mob/user as mob)
	playsound(src.loc, "rustle", 50, 1, -5)
	return src.attack_hand(user)
	return

/obj/item/weapon/storage/recyclingbin/attack_hand(mob/user as mob)
	playsound(src.loc, "rustle", 50, 1, -5)
	if (src.loc != user)
		if (user.s_active)
			user.s_active.close(user)
		src.show_to(user)
	return


