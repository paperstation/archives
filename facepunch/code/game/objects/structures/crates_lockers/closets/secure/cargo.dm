/obj/structure/closet/secure_closet/quartermaster
	name = "Quartermaster's Locker"
	#ifdef NEWMAP
	req_access = list(access_cargo_bay_area)
	#else
	req_access = list(access_qm)
	#endif
	icon_state = "secureqm1"
	icon_closed = "secureqm"
	icon_locked = "secureqm1"
	icon_opened = "secureqmopen"
	icon_broken = "secureqmbroken"
	icon_off = "secureqmoff"

	New()
		..()
		sleep(2)
		new /obj/item/clothing/under/rank/cargo(src)
		new /obj/item/clothing/shoes/brown(src)
		new /obj/item/device/radio/headset/headset_cargo(src)
		new /obj/item/clothing/gloves/black(src)
//		new /obj/item/clothing/suit/fire/firefighter(src)
//		new /obj/item/weapon/tank/emergency_oxygen(src)
//		new /obj/item/clothing/mask/gas(src)
		new /obj/item/clothing/head/soft(src)
		return