//***********************Spacesuit***********************
//Note: Everything in modules/clothing/spacesuits should have the entire suit grouped together.
//      Meaning the the suit is defined directly after the corrisponding helmet. Just like below!
//		I moved this - crackerroll
/obj/item/clothing/head/helmet/space
	name = "Space helmet"
	icon_state = "space"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment."
	flags = FPRINT | TABLEPASS | HEADCOVERSEYES | BLOCKHAIR | HEADCOVERSMOUTH
	item_state = "space"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE
	armor = list(impact = 0.2, slash = 0.2, pierce = 0, bomb = 0.2, bio = 1.0, rad = 1.0)

	max_temperature = HEAT_PROTECTION_TEMPERATURE_LOW
	max_pressure = PRESSURE_PROTECTION_MAX_HIGH
	min_pressure = PRESSURE_PROTECTION_MIN_LOW



/obj/item/clothing/suit/space
	name = "Space suit"
	desc = "A suit that protects against low pressure environments. Has a big 13 on the back."
	icon_state = "space"
	item_state = "s_suit"
	w_class = 4//bulky item
	flags = FPRINT | TABLEPASS
	body_parts_covered = CHEST|LEGS|ARMS
	allowed = list(/obj/item/weapon/tank, /obj/item/device/flashlight,/obj/item/weapon/gun, /obj/item/ammo_magazine, /obj/item/weapon/melee/baton,/obj/item/clothing/head/helmet, /obj/item/weapon/storage/bag/ore,/obj/item/device/t_scanner,/obj/item/weapon/pickaxe, /obj/item/weapon/rcd, /obj/item/weapon/melee/energy/sword)
	slowdown = 3
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	armor = list(impact = 0.2, slash = 0.2, pierce = 0, bomb = 0.2, bio = 1.0, rad = 1.0)

	max_temperature = HEAT_PROTECTION_TEMPERATURE_LOW
	max_pressure = PRESSURE_PROTECTION_MAX_HIGH
	min_pressure = PRESSURE_PROTECTION_MIN_LOW
