/obj/item/satchel
	name = "satchel"
	desc = "A leather bag. It holds 0/20 items."
	icon = 'icons/obj/items.dmi'
	icon_state = "satchel"
	flags = ONBELT
	w_class = 1
	var/maxitems = 30
	var/list/allowed = list(/obj/item/)
	var/itemstring = "items"

	New()
		src.overlays += image('icons/obj/items.dmi', "satcounter0")
		..()

	attackby(obj/item/W as obj, mob/user as mob)
		var/proceed = 0
		for(var/check_path in src.allowed)
			if(istype(W, check_path))
				proceed = 1
				break
		if (!proceed)
			boutput(user, "<span style=\"color:red\">[src] cannot hold that kind of item!</span>")
			return

		if (src.contents.len < src.maxitems)
			user.u_equip(W)
			W.set_loc(src)
			W.dropped()
			boutput(user, "<span style=\"color:blue\">You put [W] in [src].</span>")
			var/itemamt = src.contents.len
			src.desc = "A leather bag. It holds [itemamt]/[src.maxitems] [src.itemstring]."
			if (itemamt == src.maxitems) boutput(user, "<span style=\"color:blue\">[src] is now full!</span>")
			src.satchel_updateicon()
		else boutput(user, "<span style=\"color:red\">[src] is full!</span>")

	attack_self(var/mob/user as mob)
		if (src.contents.len)
			var/turf/T = user.loc
			for (var/obj/item/I in src.contents)
				I.set_loc(T)
			boutput(user, "<span style=\"color:blue\">You empty out [src].</span>")
			src.desc = "A leather bag. It holds 0/[src.maxitems] [src.itemstring]."
			src.satchel_updateicon()
		else ..()

	MouseDrop_T(atom/movable/O as obj, mob/user as mob)
		var/proceed = 0
		for(var/check_path in src.allowed)
			if(istype(O, check_path))
				proceed = 1
				break
		if (!proceed)
			boutput(user, "<span style=\"color:red\">[src] cannot hold that kind of item!</span>")
			return

		if (src.contents.len < src.maxitems)
			user.visible_message("<span style=\"color:blue\">[user] begins quickly filling [src]!</span>")
			var/staystill = user.loc
			var/amt
			for(var/obj/item/I in view(1,user))
				if (!istype(I, O)) continue
				if (I in user)
					continue
				I.set_loc(src)
				amt = src.contents.len
				src.desc = "A leather bag. It holds [amt]/[src.maxitems] [src.itemstring]."
				src.satchel_updateicon()
				sleep(2)
				if (user.loc != staystill) break
				if (src.contents.len >= src.maxitems)
					boutput(user, "<span style=\"color:blue\">[src] is now full!</span>")
					break
			boutput(user, "<span style=\"color:blue\">You finish filling [src]!</span>")
		else boutput(user, "<span style=\"color:red\">[src] is full!</span>")

	proc/satchel_updateicon()
		var/perc
		if (src.contents.len > 0 && src.maxitems > 0)
			perc = (src.contents.len / src.maxitems) * 100
		else
			perc = 0
		src.overlays = null
		switch(perc)
			if (-INFINITY to 0)
				src.overlays += image('icons/obj/items.dmi', "satcounter0")
			if (1 to 24)
				src.overlays += image('icons/obj/items.dmi', "satcounter1")
			if (25 to 49)
				src.overlays += image('icons/obj/items.dmi', "satcounter2")
			if (50 to 74)
				src.overlays += image('icons/obj/items.dmi', "satcounter3")
			if (75 to 99)
				src.overlays += image('icons/obj/items.dmi', "satcounter4")
			if (100 to INFINITY)
				src.overlays += image('icons/obj/items.dmi', "satcounter5")

/obj/item/satchel/hydro
	name = "produce satchel"
	desc = "A leather bag. It holds 0/50 items of produce."
	icon_state = "hydrosatchel"
	maxitems = 50
	allowed = list(/obj/item/seed,
	/obj/item/plant,
	/obj/item/reagent_containers/food,
	/obj/item/organ,
	/obj/item/clothing/head/butt,
	/obj/item/parts/human_parts/arm,
	/obj/item/parts/human_parts/leg,
	/obj/item/raw_material/cotton)
	itemstring = "items of produce"