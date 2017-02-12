
// haine wuz here and tore this file to bits!!!  f u we can have things in their own files and we SHOULD
// rather than EVERYTHING BEING IN HALLOWEEN.DM AND KEELINSSTUFF.DM OKAY THINGS CAN BE IN OTHER FILES

/obj/item/storage
	name = "storage"
	icon = 'icons/obj/storage.dmi'
	icon_state = "box_blank"
	inhand_image_icon = 'icons/mob/inhand/hand_general.dmi'
	item_state = "box"
	var/list/can_hold = new/list()
	var/datum/hud/storage/hud
	var/sneaky = 0 //Don't print a visible message on use.
	var/does_not_open_in_pocket = 1
	var/max_wclass = 2
	var/list/spawn_contents = list()
	move_triggered = 1
	flags = FPRINT | TABLEPASS | NOSPLASH
	w_class = 3.0

		//cogwerks - burn vars
	burn_point = 2500
	burn_output = 2500
	burn_possible = 1
	health = 10

	New()
		hud = new(src)
		..()
		spawn(1)
			src.make_my_stuff()

	disposing()
		qdel(hud)
		..()

	move_trigger(var/mob/M, kindof)
		if (..())
			for (var/obj/O in contents)
				if (O.move_triggered)
					O.move_trigger(M, kindof)

	emp_act()
		if (src.contents.len)
			for (var/atom/A in src.contents)
				if (isitem(A))
					var/obj/item/I = A
					I.emp_act()
		return

	proc/make_my_stuff() // use this rather than overriding the container's New()
		if (!src.spawn_contents || !islist(src.spawn_contents) || !src.spawn_contents.len)
			return
		var/total_amt = 0
		for (var/thing in src.spawn_contents)
			var/amt = 1
			if (!ispath(thing))
				continue
			if (isnum(spawn_contents[thing])) //Instead of duplicate entries in the list, let's make them associative
				amt = abs(spawn_contents[thing])
			total_amt += amt
			for (amt, amt>0, amt--)
				new thing(src)
		if (total_amt > 7)
			logTheThing("debug", null, null, "STORAGE ITEM: [src] has more than 7 items in it!")
		total_amt = null
		return

	attackby(obj/item/W as obj, mob/user as mob)
		if (W.cant_drop) return
		if (can_hold.len)
			var/ok = 0
			for (var/A in can_hold)
				if (istype(W, text2path(A) )) ok = 1
			if (!ok)
				boutput(user, "<span style=\"color:red\">This container cannot hold [W].</span>")
				return

		var/list/contents = src.get_contents()
		if (contents.len >= 7)
			boutput(user, "<span style=\"color:red\">\the [src] is full!</span>")
			return

		if (W.w_class > src.max_wclass)
			boutput(user, "<span style=\"color:red\">[W] won't fit into [src]!</span>")
			return

		var/atom/checkloc = src.loc // no infinite loops for you
		while (checkloc && !isturf(src.loc))
			if (checkloc == W) // nope
				//Hi hello this used to gib the user and create an actual 5x5 explosion on their tile
				//Turns out this condition can be met and reliably reproduced by players!
				//Lets not give players the ability to fucking explode at will eh
				return
			checkloc = checkloc.loc

		user.u_equip(W)
		W.dropped(user)
		src.add_contents(W)
		hud.add_item(W)
		add_fingerprint(user)
		if (!src.sneaky && !istype(W, /obj/item/gun/energy/crossbow))
			user.visible_message("<span style=\"color:blue\">[user] has added [W] to [src]!</span>", "<span style=\"color:blue\">You have added [W] to [src].</span>")
		return

	dropped(mob/user as mob)
		if (hud)
			hud.update()
		..()

	proc/mousetrap_check(mob/user)
		if (!ishuman(user) || user.stat)
			return
		for (var/obj/item/mousetrap/MT in src)
			if (MT.armed)
				user.visible_message("<span style=\"color:red\"><B>[user] reaches into \the [src] and sets off a mousetrap!</B></span>",\
				"<span style=\"color:red\"><B>You reach into \the [src], but there was a live mousetrap in there!</B></span>")
				MT.triggered(user, user.hand ? "l_hand" : "r_hand")
				. = 1
		for (var/obj/item/mine/M in src)
			if (M.armed && M.used_up != 1)
				user.visible_message("<span style=\"color:red\"><B>[user] reaches into \the [src] and sets off a [M.name]!</B></span>",\
				"<span style=\"color:red\"><B>You reach into \the [src], but there was a live [M.name] in there!</B></span>")
				M.triggered(user)
				. = 1

	MouseDrop(atom/over_object, src_location, over_location)
		..()
		var/obj/screen/hud/S = over_object
		if (istype(S))
			playsound(src.loc, "rustle", 50, 1, -5)
			if (!usr.restrained() && !usr.stat && src.loc == usr)
				if (S.id == "rhand")
					if (!usr.r_hand)
						usr.u_equip(src)
						usr.put_in_hand(src, 0)
				else
					if (S.id == "lhand")
						if (!usr.l_hand)
							usr.u_equip(src)
							usr.put_in_hand(src, 1)
				return
		if (over_object == usr && in_range(src, usr) && isliving(usr) && !usr.stat)
			if (usr.s_active)
				usr.detach_hud(usr.s_active)
				usr.s_active = null
			if (src.mousetrap_check(usr))
				return
			usr.s_active = src.hud
			hud.update()
			usr.attach_hud(src.hud)
			return
		if (usr.is_in_hands(src))
			var/turf/T = over_object
			if (istype(T, /obj/table))
				T = get_turf(T)
			if (!(usr in range(1, T)))
				return
			if (istype(T))
				for (var/obj/O in T)
					if (O.density && !istype(O, /obj/table) && !istype(O, /obj/rack))
						return
				if (!T.density)
					usr.visible_message("<span style=\"color:red\">[usr] dumps the contents of [src] onto [T]!</span>")
					for (var/obj/item/I in src)
						I.set_loc(T)
						I.layer = initial(I.layer)
						if (istype(I, /obj/item/mousetrap))
							var/obj/item/mousetrap/MT = I
							if (MT.armed)
								MT.visible_message("<span style=\"color:red\">[MT] triggers as it falls on the ground!</span>")
								MT.triggered(usr, null)
						else if (istype(I, /obj/item/mine))
							var/obj/item/mine/M = I
							if (M.armed && M.used_up != 1)
								M.visible_message("<span style=\"color:red\">[M] triggers as it falls on the ground!</span>")
								M.triggered(usr)
						hud.remove_item(I)

	attack_hand(mob/user as mob)
		if (!src.sneaky)
			playsound(src.loc, "rustle", 50, 1, -5)
		if (src.loc == user && (!does_not_open_in_pocket || src == user.l_hand || src == user.r_hand))
			if (ishuman(user))
				var/mob/living/carbon/human/H = user
				if (H.limbs) // this check is probably dumb. BUT YOU NEVER KNOW
					if ((src == H.l_hand && istype(H.limbs.l_arm, /obj/item/parts/human_parts/arm/left/item)) || (src == H.r_hand && istype(H.limbs.r_arm, /obj/item/parts/human_parts/arm/right/item)))
						return
			if (usr.s_active)
				usr.detach_hud(usr.s_active)
				usr.s_active = null
			if (src.mousetrap_check(usr))
				return
			usr.s_active = src.hud
			hud.update()
			usr.attach_hud(src.hud)
			src.add_fingerprint(user)
		else
			..()
			for (var/mob/M in hud.mobs)
				if (M != user)
					M.detach_hud(hud)
			hud.update()

	proc/get_contents()
		return src.contents

	proc/add_contents(obj/item/I)
		I.set_loc(src)

	proc/get_all_contents()
		var/list/L = list()
		L += src.contents
		for (var/obj/item/storage/S in src.contents)
			L += S.get_all_contents()
		return L

/obj/item/storage/box
	name = "box"
	icon_state = "box"
	desc = "A box that can hold a number of small items."
	max_wclass = 2

/obj/item/storage/box/starter // the one you get in your backpack
	spawn_contents = list(/obj/item/clothing/mask/breath)
	make_my_stuff()
		..()
		if (prob(15))
			new /obj/item/tank/emergency_oxygen(src)
		if (prob(10)) // put these together
			new /obj/item/clothing/suit/space/emerg(src)
			new /obj/item/clothing/head/emerg(src)

/obj/item/storage/pill_bottle
	name = "pill bottle"
	icon_state = "pill_canister"
	icon = 'icons/obj/chemical.dmi'
	item_state = "contsolid"
	can_hold = list("/obj/item/reagent_containers/pill")
	w_class = 2.0
	max_wclass = 1
	desc = "A small bottle designed to carry pills. Does not come with a child-proof lock, as that was determined to be too difficult for the crew to open."

/obj/item/storage/briefcase
	name = "briefcase"
	icon_state = "briefcase"
	item_state = "briefcase"
	flags = FPRINT | TABLEPASS| CONDUCT | NOSPLASH
	force = 8.0
	throw_speed = 1
	throw_range = 4
	w_class = 4.0
	max_wclass = 3
	desc = "A fancy synthetic leather-bound briefcase, capable of holding a number of small objects, with style."
	stamina_damage = 35
	stamina_cost = 30
	stamina_crit_chance = 10
	spawn_contents = list(/obj/item/paper = 2,/obj/item/pen)
	// Don't use up more slots, certain job datums put items in the briefcase the player spawns with.
	// And nobody needs six sheets of paper right away, realistically speaking.

/obj/item/storage/wall
	name = "cabinet"
	desc = "It's basically a big box attached to the wall."
	icon = 'icons/obj/storage.dmi'
	icon_state = "wall"
	flags = FPRINT | TABLEPASS
	force = 8.0
	w_class = 4.0
	anchored = 1.0
	density = 0
	mats = 8
	max_wclass = 4
	mechanics_type_override = /obj/item/storage/wall

	attack_hand(mob/user as mob)
		return MouseDrop(user)

	random
		pixel_y = 32
		make_my_stuff()
			..()
			switch (pickweight(list("screwdriver" = 10, "wrench" = 10, "crowbar" = 5, "wirecutters" = 3)))
				if ("screwdriver")
					new /obj/item/screwdriver(src)
				if ("wrench")
					new /obj/item/wrench(src)
				if ("crowbar")
					new /obj/item/crowbar(src)
				if ("wirecutters")
					new /obj/item/wirecutters(src)

			switch (pickweight(list("radio" = 10, "signaler" = 4, "glowstick" = 30, "flashlight" = 15, "multitool" = 1)))
				if ("radio")
					new /obj/item/device/radio(src)
				if ("signaler")
					new /obj/item/device/radio/signaler(src)
				if ("glowstick")
					new /obj/item/device/glowstick(src)
				if ("flashlight")
					new /obj/item/device/flashlight(src)
				if ("multitool")
					new /obj/item/device/multitool(src)

			if(prob(40))
				switch (pickweight(list("cigs" = 10, "snack" = 15, "alcohol" = 5, "drugs" = 2)))
					if ("cigs")
						new /obj/item/cigpacket/propuffs(src)
					if ("snack")
						new /obj/item/reagent_containers/food/snacks/chips(src)
					if ("alcohol")
						new /obj/item/reagent_containers/food/drinks/bottle/hobo_wine(src)
					if ("drugs")
						new /obj/item/reagent_containers/pill/cyberpunk(src)

			return

/obj/item/storage/rockit
	name = "\improper Rock-It Launcher"
	desc = "Huh..."
	icon = 'icons/obj/gun.dmi'
	icon_state = "rockit"
	item_state = "gun"
	flags = FPRINT | EXTRADELAY | TABLEPASS | CONDUCT
	w_class = 4.0
	max_wclass = 3

	afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
		if (target == loc)
			return
		if (!src.contents.len)
			return
		var/obj/item/I = pick(src.contents)
		if (!I)
			return

		I.throwforce += 8 //Ugly. Who cares.
		spawn(15)
			if (I)
				I.throwforce -= 8

		I.set_loc(get_turf(src.loc))
		I.throw_at(target, 8, 2)

		playsound(src, 'sound/effects/singsuck.ogg', 40, 1)