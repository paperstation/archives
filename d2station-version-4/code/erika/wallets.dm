/obj/item/weapon/storage/walletpocket
	name = "wallet"
	desc = "Can hold small items such as pens, letters and money."
	icon = 'old_or_unused.dmi'
	icon_state = "walletpocket"
	item_state = "wallet"
	w_class = 1.0
	can_hold = list("/obj/item/weapon/pen",
		"/obj/item/weapon/paper",
		"/obj/item/weapon/screwdriver",
		"/obj/item/weapon/disk",
		"/obj/item/weapon/money",
		"/obj/item/weapon/zippo",
		"/obj/item/weapon/cigpacket",
		"/obj/item/weapon/cigarpacket",
		"/obj/item/weapon/cigbutt",
		"/obj/item/weapon/scalpel",
		"/obj/item/device/flashlight/pen",
		"/obj/item/weapon/card/id",
		"/obj/item/weapon/reagent_containers/syringe",
		"/obj/item/weapon/reagent_containers/pill",
		"/obj/item/weapon/reagent_containers/cigs",
		"/obj/item/weapon/reagent_containers/syringe",
		"/obj/item/weapon/reagent_containers/dropper",
		"/obj/item/weapon/reagent_containers/glass/bottle",
		"/obj/item/weapon/reagent_containers/glass/beaker",
		"/obj/item/weapon/medical/bruise_pack",
		"/obj/item/weapon/medical/ointment",
		"/obj/item/clothing/mask/muzzle",
		"/obj/item/clothing/mask/breath",
		"/obj/item/clothing/mask/surgical",
		"/obj/item/device/healthanalyzer",
		"/obj/item/weapon/reagent_containers/hypospray",
		"/obj/item/weapon/storage/pill_bottle",
		"/obj/item/weapon/dermalregenerator")
	flags = FPRINT | TABLEPASS | ONBELT

/obj/item/weapon/storage/walletpocket/New()

	new /obj/item/weapon/pen( src )
	new /obj/item/weapon/paper ( src )
	..()
	return

/obj/item/weapon/storage/walletpocket/MouseDrop(obj/over_object as obj)

	if ((istype(usr, /mob/living/carbon/human) || (ticker && ticker.mode.name == "monkey")))
		var/mob/M = usr
		if (!( istype(over_object, /obj/screen) ))
			return ..()
		if ((!( M.restrained() ) && !( M.stat )))
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