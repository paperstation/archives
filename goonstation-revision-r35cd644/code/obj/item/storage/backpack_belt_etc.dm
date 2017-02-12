
/* -------------------- Backpacks  -------------------- */

/obj/item/storage/backpack
	name = "backpack"
	icon_state = "backpack"
	flags = ONBACK | FPRINT | TABLEPASS | NOSPLASH
	w_class = 4.0
	max_wclass = 3
	desc = "A thick, wearable container made of synthetic fibers, able to carry a number of objects comfortably on a crewmember's back."
	wear_image_icon = 'icons/mob/back.dmi'
	does_not_open_in_pocket = 0
	spawn_contents = list(/obj/item/storage/box/starter)

/obj/item/storage/backpack/NT
	name = "\improper NT backpack"
	icon_state = "NTbackpack"
	w_class = 4.0

/obj/item/storage/backpack/medic
	name = "medic's backpack"
	icon_state = "bp_medic"

/obj/item/storage/backpack/satchel
	name = "satchel"
	icon_state = "satchel"
	w_class = 4.0
	desc = "A thick, wearable container made of synthetic fibers, able to carry a number of objects comfortably on a crewmember's shoulder."

/obj/item/storage/backpack/satchel/medic
	name = "medic's satchel"
	icon_state = "satchel_medic"

/* -------------------- Fanny Packs -------------------- */

/obj/item/storage/fanny
	name = "fanny pack"
	desc = "No, 'fanny' as in 'butt.' Not the other thing."
	icon = 'icons/obj/belts.dmi'
	icon_state = "fanny"
	item_state = "fanny"
	flags = FPRINT | TABLEPASS | ONBELT | NOSPLASH
	w_class = 4.0
	max_wclass = 3
	does_not_open_in_pocket = 0
	stamina_damage = 5
	stamina_cost = 5
	stamina_crit_chance = 5
	spawn_contents = list(/obj/item/storage/box/starter)

/obj/item/storage/fanny/funny
	name = "funny pack"
	desc = "Haha, get it? Get it? 'Funny'!"
	icon_state = "funny"
	item_state = "funny"
	spawn_contents = list(/obj/item/storage/box/starter,\
	/obj/item/storage/box/balloonbox)

/obj/item/storage/fanny/syndie
	name = "syndicate tactical espionage belt pack"
	desc = "It's different than a fanny pack. It's tactical and action-packed!"
	icon_state = "syndie"
	item_state = "syndie"

/* -------------------- Belts -------------------- */

/obj/item/storage/belt
	flags = FPRINT | TABLEPASS | ONBELT | NOSPLASH
	max_wclass = 2
	does_not_open_in_pocket = 0
	stamina_damage = 5
	stamina_cost = 5
	stamina_crit_chance = 5

	proc/can_use()
		if (!ismob(loc))
			return 0
		var/mob/M = loc
		if (src in M.get_equipped_items())
			return 1
		else
			return 0

	MouseDrop(obj/over_object as obj, src_location, over_location)
		var/mob/M = usr
		if (!istype(over_object, /obj/screen))
			if(!can_use())
				boutput(M, "<span style=\"color:red\">I need to wear the belt for that.</span>")
				return
		return ..()

	attack_hand(mob/user as mob)
		if (src.loc == user && !can_use())
			boutput(user, "<span style=\"color:red\">I need to wear the belt for that.</span>")
			return
		return ..()

	attackby(obj/item/W as obj, mob/user as mob)
		if(!can_use())
			boutput(user, "<span style=\"color:red\">I need to wear the belt for that.</span>")
			return
		else
			..()

/obj/item/storage/belt/utility
	name = "utility belt"
	desc = "Can hold various small objects."
	icon = 'icons/obj/belts.dmi'
	icon_state = "utilitybelt"
	item_state = "utility"

/obj/item/storage/belt/utility/prepared
	spawn_contents = list(/obj/item/crowbar,\
	/obj/item/weldingtool,\
	/obj/item/wirecutters,\
	/obj/item/screwdriver,\
	/obj/item/wrench,\
	/obj/item/device/multitool,\
	/obj/item/electronics/soldering)

/obj/item/storage/belt/medical
	name = "medical belt"
	icon = 'icons/obj/belts.dmi'
	icon_state = "injectorbelt"
	item_state = "injector"

/obj/item/storage/belt/mining
	name = "miner's belt"
	desc = "Can hold various mining tools."
	icon = 'icons/obj/mining.dmi'
	icon_state = "minerbelt"
	item_state = "utility"

/obj/item/storage/belt/predator
	name = "trophy belt"
	desc = "Holds normal-sized items, such as skulls."
	icon = 'icons/obj/mining.dmi'
	icon_state = "minerbelt"
	item_state = "utility"
	max_wclass = 3

/* -------------------- Wrestling Belt -------------------- */

/obj/item/storage/belt/wrestling
	name = "championship wrestling belt"
	desc = "A haunted antique wrestling belt, imbued with the spirits of wrestlers past."
	icon = 'icons/obj/belts.dmi'
	icon_state = "machobelt"
	item_state = "machobelt"
	contraband = 8

	equipped(var/mob/user)
		user.make_wrestler(0, 1, 0)

	unequipped(var/mob/user)
		user.make_wrestler(0, 1, 1)