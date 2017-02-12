/*
 * Detective
 */

/obj/item/clothing/suit/armor/det_suit
	name = "armor"
	desc = "An armored vest with a detective's badge on it."
	icon_state = "detective-armor"
	item_state = "armor"
	blood_overlay_type = "armor"
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL
	body_parts_covered = CHEST
	armor = list(impact = 0.4, slash = 0.4, pierce = 0.2, bomb = 0.2, bio = 0.0, rad = 0.0)


//Detective
/obj/item/clothing/suit/det_suit
	name = "coat"
	desc = "An 18th-century multi-purpose trenchcoat. Someone who wears this means serious business."
	icon_state = "detective"
	item_state = "det_suit"
	blood_overlay_type = "coat"
	body_parts_covered = CHEST|LEGS|ARMS
	allowed = list(/obj/item/weapon/tank/emergency_oxygen, /obj/item/device/flashlight,/obj/item/weapon/gun/energy,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/lighter,/obj/item/device/detective_scanner,/obj/item/device/taperecorder)
	armor = list(impact = 0.4, slash = 0.4, pierce = 0.2, bomb = 0.2, bio = 0.0, rad = 0.0)


//Detective
/obj/item/clothing/suit/det_suit/white
	name = "coat"
	desc = "An 18th-century multi-purpose trenchcoat. Someone who wears this means serious business and someone painted it white."
	icon_state = "detectivewhite"
	item_state = "detectivecoat"
	blood_overlay_type = "coat"
	body_parts_covered = CHEST|LEGS|ARMS
	allowed = list(/obj/item/weapon/tank/emergency_oxygen, /obj/item/device/flashlight,/obj/item/weapon/gun/energy,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/lighter,/obj/item/device/detective_scanner,/obj/item/device/taperecorder)
	verb/toggle()
		set name = "Toggle Coat Buttons"
		set category = "Object"
		set src in usr

		if(!usr.canmove || usr.stat || usr.restrained())
			return 0

		switch(icon_state)
			if("detectivewhite")
				src.icon_state = "detectivewhiteclose"
				usr << "You button up the coat."
			if("detectivewhiteclose")
				src.icon_state = "detectivewhite"
				usr << "You unbutton the coat."
			else
				usr << "You attempt to button-up your coat, before promptly realising how retarded you are."
				return
		usr.update_inv_wear_suit()	//so our overlays update

	verb/incorp(mob/living/carbon/human/user as mob)
		set name = "Phantom"
		set category = "Spec-Ops"
		set src in usr
		var/cooldown = 0
		var/effect = 0
		if(!cooldown)
			visible_message("[user]'s coat lights up.")
			cooldown = 1
			user.incorporeal_move = 2
			spawn(40)
				user.incorporeal_move = 0
				if(effect >= 5 && effect <= 8)
					user.weakened = 1
				if(effect >= 9)
					user.weakened = 5
				else
					effect++
				spawn(100)
					cooldown = 0



/obj/item/clothing/under/det
	name = "hard-worn suit"
	desc = "Someone who wears this means business."
	icon_state = "detective"
	item_state = "det"
	variant = "detective"
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL


/obj/item/clothing/head/det_hat
	name = "hat"
	desc = "Someone who wears this will look very smart."
	icon_state = "detective"
	armor = list(impact = 0.4, slash = 0.4, pierce = 0.2, bomb = 0.2, bio = 0.0, rad = 0.0)

