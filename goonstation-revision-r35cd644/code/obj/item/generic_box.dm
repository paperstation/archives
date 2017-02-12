
/obj/item/item_box // for when you want something that "contains" a certain amount of an item
	name = "box"
	desc = "A little cardboard box for keeping stuff in. Woah! We're truly in the future with technology like this."
	icon = 'icons/obj/storage.dmi'
	icon_state = "item_box"
	force = 1
	throwforce = 1
	w_class = 2
	var/contained_item = /obj/item/sticker/gold_star
	var/item_amount = -1 // how many of thing to start with, -1 for infinite
	var/max_item_amount = -1 // how many can the thing hold total, -1 for infinite
	var/open = 0
	var/icon_closed = "item_box"
	var/icon_open = "item_box-open"
	var/icon_empty = "item_box-empty"
	var/reusable = 1

	gold_star
		name = "box of gold star stickers"

	banana
		name = "box of banana stickers"
		contained_item = /obj/item/sticker/banana

	clover
		name = "box of clover stickers"
		contained_item = /obj/item/sticker/clover

	umbrella
		name = "box of umbrella stickers"
		contained_item = /obj/item/sticker/umbrella

	skull
		name = "box of skull stickers"
		contained_item = /obj/item/sticker/skull

	no
		name = "box of \"no\" stickers"
		contained_item = /obj/item/sticker/no

	left_arrow
		name = "box of left arrow stickers"
		contained_item = /obj/item/sticker/left_arrow

	right_arrow
		name = "box of right arrow stickers"
		contained_item = /obj/item/sticker/right_arrow

	heart
		name = "box of heart stickers"
		contained_item = /obj/item/sticker/heart

	moon
		name = "box of moon stickers"
		contained_item = /obj/item/sticker/moon

	smile
		name = "box of smile stickers"
		contained_item = /obj/item/sticker/smile

	frown
		name = "box of frown stickers"
		contained_item = /obj/item/sticker/frown

	balloon
		name = "box of red balloon stickers"
		contained_item = /obj/item/sticker/balloon

	rainbow
		name = "box of rainbow stickers"
		contained_item = /obj/item/sticker/rainbow

	horseshoe
		name = "box of horseshoe stickers"
		contained_item = /obj/item/sticker/horseshoe

	award_ribbon
		name = "box of award ribbons"
		contained_item = /obj/item/sticker/ribbon

		first_place
			name = "box of 1st place ribbons"
			contained_item = /obj/item/sticker/ribbon/first_place
		second_place
			name = "box of 2nd place ribbons"
			contained_item = /obj/item/sticker/ribbon/second_place
		third_place
			name = "box of 3rd place ribbons"
			contained_item = /obj/item/sticker/ribbon/third_place
		participant
			name = "box of participation ribbons"
			contained_item = /obj/item/sticker/ribbon/participant

	medical_patches
		name = "box of patches"
		contained_item = /obj/item/reagent_containers/patch
		item_amount = 0
		icon_closed = "patchbox"
		icon_open = "patchbox-open"
		icon_empty = "patchbox-empty"

		styptic
			name = "box of healing patches"
			contained_item = /obj/item/reagent_containers/patch/bruise
			item_amount = 10
			max_item_amount = 10
		silver_sulf
			name = "box of burn patches"
			contained_item = /obj/item/reagent_containers/patch/burn
			item_amount = 10
			max_item_amount = 10
		synthflesh
			name = "box of synthflesh patches"
			contained_item = /obj/item/reagent_containers/patch/synthflesh
			item_amount = 10
			max_item_amount = 10

		mini_styptic
			name = "box of mini healing patches"
			contained_item = /obj/item/reagent_containers/patch/mini/bruise
			item_amount = 10
			max_item_amount = 10
		mini_silver_sulf
			name = "box of mini burn patches"
			contained_item = /obj/item/reagent_containers/patch/mini/burn
			item_amount = 10
			max_item_amount = 10
		mini_synthflesh
			name = "box of mini synthflesh patches"
			contained_item = /obj/item/reagent_containers/patch/mini/synthflesh
			item_amount = 10
			max_item_amount = 10

	New()
		..()
		spawn(10)
			if (!ispath(src.contained_item))
				logTheThing("debug", src, null, "has a non-path contained_item, \"[src.contained_item]\", and is being disposed of to prevent errors")
				qdel(src)
				return

	get_desc(dist)
		if (src.item_amount == -1)
			. += "There's a whole, whole lot of things inside. Dang!"
		else if (src.item_amount >= 1)
			. += "There's [src.item_amount] thing[src.item_amount == 1 ? "" : "s"] inside."
		else
			. += "It's empty."

	attack_self(mob/user as mob)
		if (src.reusable)
			src.open = !src.open
		else if (!src.open)
			src.open = 1
		else
			boutput(user, "<span style=\"color:red\">[src] is already open!</span>")
		src.update_icon()
		return

	attackby(obj/item/W as obj, mob/living/user as mob)
		if (!src.add_to(W, user))
			return ..()

	attack_hand(mob/user as mob)
		src.add_fingerprint(user)
		if (src.loc == user && src.open)
			var/obj/item/I = src.take_from()
			if (I)
				user.put_in_hand_or_drop(I)
				boutput(user, "You take \an [I] out of [src].")
				src.update_icon()
				return
			else
				boutput(user, "<span style=\"color:red\">[src] is empty!</span>")
				return ..()
		else
			return ..()

	proc/take_from()
		var/obj/item/myItem = locate(src.contained_item) in src
		if (myItem)
			if (src.item_amount >= 1)
				src.item_amount--
			src.update_icon()
			return myItem
		else if (src.item_amount != 0) // should be either a positive number or -1
			if (src.item_amount >= 1)
				src.item_amount--
			var/obj/item/newItem = new src.contained_item(src)
			src.update_icon()
			return newItem
		else
			return 0

	proc/add_to(var/obj/item/I, var/mob/user)
		if (!I)
			return 0
		if (!user && usr)
			user = usr
		if (!istype(I, src.contained_item))
			if (user)
				boutput(user, "<span style=\"color:red\">[I] doesn't fit in [src]!</span>")
			return 0
		if (src.reusable && !(src.item_amount >= src.max_item_amount || src.max_item_amount == -1))
			if (!src.open)
				if (user)
					boutput(user, "<span style=\"color:red\">[src] isn't open, you goof!</span>")
				return 0
			if (src.item_amount != -1)
				src.item_amount ++
			src.update_icon()
			if (user)
				boutput(user, "You stuff [I] into [src].")
				user.u_equip(I)
			I.set_loc(src)
			return 1
		else
			if (user)
				boutput(user, "<span style=\"color:red\">You can't seem to make [I] fit into [src].</span>")
			return 0

	proc/update_icon()
		if (src.open && !src.item_amount)
			src.icon_state = src.icon_empty
		else if (src.open && src.item_amount)
			src.icon_state = src.icon_open
		else
			src.icon_state = src.icon_closed
