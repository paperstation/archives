/obj/item/clothing/head/wizard
	name = "wizard hat"
	desc = "Strange-looking hat-wear that most certainly belongs to a real magic user."
	icon_state = "wizard"
	body_parts_covered = HEAD
	armor = list(impact = 0.2, slash = 0.2, pierce = 0.2, bomb = 0.2, bio = 0.2, rad = 0.2)


/obj/item/clothing/head/wizard/red
	name = "red wizard hat"
	desc = "Strange-looking, red, hat-wear that most certainly belongs to a real magic user."
	icon_state = "redwizard"

/obj/item/clothing/head/wizard/magus
	name = "Magus Helm"
	desc = "A mysterious helmet that hums with an unearthly power"
	icon_state = "magus"
	item_state = "magus"

/obj/item/clothing/head/wizard/marisa
	name = "Witch Hat"
	desc = "Strange-looking hat-wear, makes you want to cast fireballs."
	icon_state = "marisa"

/obj/item/clothing/head/wizard/fake
	name = "wizard hat"
	desc = "It has WIZZARD written across it in sequins. Comes with a cool beard."
	icon_state = "wizard-fake"
	armor = list(impact = 0, slash = 0, pierce = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/head/wizard/fake/marisa
	name = "Witch Hat"
	desc = "Strange-looking hat-wear, makes you want to cast fireballs."
	icon_state = "marisa"


/obj/item/clothing/suit/wizrobe
	name = "wizard robe"
	desc = "A magnificant, gem-lined robe that seems to radiate power."
	icon_state = "wizard"
	item_state = "wizrobe"
	body_parts_covered = CHEST|ARMS|LEGS
	armor = list(impact = 0.2, slash = 0.2, pierce = 0.2, bomb = 0.2, bio = 0.2, rad = 0.2)
	allowed = list(/obj/item/weapon/teleportation_scroll)
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/wizrobe/red
	name = "red wizard robe"
	desc = "A magnificant, red, gem-lined robe that seems to radiate power."
	icon_state = "redwizard"
	item_state = "redwizrobe"

/obj/item/clothing/suit/wizrobe/marisa
	name = "Witch Robe"
	desc = "Magic is all about the spell power, ZE!"
	icon_state = "marisa"
	item_state = "marisarobe"

/obj/item/clothing/suit/wizrobe/magusblue
	name = "Magus Robe"
	desc = "A set of armoured robes that seem to radiate a dark power"
	icon_state = "magusblue"
	item_state = "magusblue"

/obj/item/clothing/suit/wizrobe/magusred
	name = "Magus Robe"
	desc = "A set of armoured robes that seem to radiate a dark power"
	icon_state = "magusred"
	item_state = "magusred"

/obj/item/clothing/suit/wizrobe/fake
	name = "wizard robe"
	desc = "A rather dull, blue robe meant to mimick real wizard robes."
	icon_state = "wizard-fake"
	item_state = "wizrobe"
	armor = list(impact = 0, slash = 0, pierce = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/suit/wizrobe/fake/marisa
	name = "Witch Robe"
	desc = "Magic is all about the spell power, ZE!"
	icon_state = "marisa"
	item_state = "marisarobe"


//Wizard rig
/obj/item/clothing/head/wizard/helmet
	icon_state = "rig-wiz"
	name = "mastercrafted hardsuit"
	desc = "Mystical purple armor created by the Space Wizard Federation."
	item_state = "wiz_hardsuit"
	flags = FPRINT | TABLEPASS | HEADCOVERSEYES | BLOCKHAIR | HEADCOVERSMOUTH
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE
	max_temperature = HEAT_PROTECTION_TEMPERATURE_LOW
	max_pressure = PRESSURE_PROTECTION_MAX_HIGH
	min_pressure = PRESSURE_PROTECTION_MIN_LOW
	armor = list(impact = 0.4, slash = 0.2, pierce = 0.2, bomb = 0.2, bio = 0.2, rad = 0.2)

/obj/item/clothing/suit/wizrobe/rig
	icon_state = "rig-wiz"
	name = "mastercrafted hardsuit"
	desc = "Mystical purple armor created by the Space Wizard Federation."
	item_state = "wiz_hardsuit"
	w_class = 3
	flags = FPRINT | TABLEPASS
	body_parts_covered = CHEST|LEGS|ARMS
	allowed = list(/obj/item/weapon/tank, /obj/item/device/flashlight,/obj/item/weapon/gun, /obj/item/ammo_magazine, /obj/item/weapon/melee/baton,/obj/item/clothing/head/helmet, /obj/item/weapon/storage/bag/ore,/obj/item/device/t_scanner,/obj/item/weapon/pickaxe, /obj/item/weapon/rcd, /obj/item/weapon/melee/energy/sword)
	slowdown = 1
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	max_temperature = HEAT_PROTECTION_TEMPERATURE_LOW
	max_pressure = PRESSURE_PROTECTION_MAX_HIGH
	min_pressure = PRESSURE_PROTECTION_MIN_LOW
	armor = list(impact = 0.4, slash = 0.2, pierce = 0.2, bomb = 0.2, bio = 0.2, rad = 0.2)