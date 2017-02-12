/obj/structure/closet/secure_closet/hydroponics
	name = "Botanist's locker"
	icon_state = "hydrosecure1"
	icon_closed = "hydrosecure"
	icon_locked = "hydrosecure1"
	icon_opened = "hydrosecureopen"
	icon_broken = "hydrosecurebroken"
	icon_off = "hydrosecureoff"
	#ifdef NEWMAP
	req_access = list(access_botany_area)
	#else
	req_access = list(access_hydroponics)
	#endif


	New()
		..()
		new /obj/item/clothing/suit/apron(src)
		new /obj/item/weapon/storage/bag/plants/portaseeder(src)
		new /obj/item/clothing/under/rank/hydroponics(src)
		new /obj/item/device/analyzer/plant_analyzer(src)
		new /obj/item/clothing/head/greenbandana(src)
		new /obj/item/weapon/minihoe(src)
		new /obj/item/weapon/hatchet(src)
		return