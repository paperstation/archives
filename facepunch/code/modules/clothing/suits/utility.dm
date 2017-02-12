/*
 * Contains:
 *		Fire protection
 *		Bomb protection
 *		Radiation protection
 */

/*
 * Fire protection
 */


/obj/item/clothing/head/hardhat/red
	name = "firefighter helmet"
	desc = "A shitty piece of headgear used in hot working conditions to protect the head. Comes with a built-in flashlight."
	icon_state = "hardhat0_red"
	item_state = "hardhat0_red"
	variant = "red"
	max_temperature = HEAT_PROTECTION_TEMPERATURE_MED
	max_pressure = PRESSURE_PROTECTION_MAX_HIGH
	min_pressure = PRESSURE_PROTECTION_MIN_HIGH
	armor = list(impact = 0.4, slash = 0.4, pierce = 0, bomb = 0.2, bio = 0.2, rad = 0)


/obj/item/clothing/suit/fire
	name = "firesuit"
	desc = "A suit that protects against fire and heat."
	icon_state = "fire"
	item_state = "fire_suit"
	w_class = 4//bulky item
	body_parts_covered = CHEST|LEGS|ARMS
	slowdown = 1.0
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL | STOPSPRESSUREDMAGE
	max_temperature = HEAT_PROTECTION_TEMPERATURE_MED
	max_pressure = PRESSURE_PROTECTION_MAX_HIGH
	min_pressure = PRESSURE_PROTECTION_MIN_MED
	armor = list(impact = 0.2, slash = 0.4, pierce = 0, bomb = 0.2, bio = 0.2, rad = 0)


/obj/item/clothing/suit/fire/firefighter
	icon_state = "firesuit"
	item_state = "firefighter"


/obj/item/clothing/suit/fire/heavy//This should be better
	name = "firesuit"
	desc = "A suit that protects against extreme fire and heat."
	//icon_state = "thermal"
	item_state = "ro_suit"
	w_class = 4//bulky item
	slowdown = 1.5
	max_temperature = HEAT_PROTECTION_TEMPERATURE_HIGH


/*
 * Bomb protection
 */
/obj/item/clothing/head/bomb_hood
	name = "EOD hood"
	desc = "Use in case of bomb."
	icon_state = "bombsuit"
	flags = FPRINT|TABLEPASS|HEADCOVERSEYES|HEADCOVERSMOUTH|BLOCKHAIR
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES
	armor = list(impact = 0.2, slash = 0.4, pierce = 0.2, bomb = 1.0, bio = 0, rad = 0)

/obj/item/clothing/suit/bomb_suit
	name = "EOD suit"
	desc = "A suit designed for safety when handling explosives."
	icon_state = "bombsuit"
	item_state = "bombsuit"
	w_class = 4//bulky item
	body_parts_covered = CHEST|LEGS|ARMS
	slowdown = 2
	flags_inv = HIDEJUMPSUIT
	max_temperature = HEAT_PROTECTION_TEMPERATURE_LOW
	armor = list(impact = 0.2, slash = 0.4, pierce = 0.2, bomb = 1.0, bio = 0, rad = 0)


/obj/item/clothing/head/bomb_hood/security
	icon_state = "bombsuitsec"
	item_state = "bombsuitsec"


/obj/item/clothing/suit/bomb_suit/security
	icon_state = "bombsuitsec"
	item_state = "bombsuitsec"


/*
 * Radiation protection
 */
/obj/item/clothing/head/radiation
	name = "radiation hood"
	icon_state = "rad"
	desc = "A hood with radiation protective properties. Label: Made with lead, do not eat insulation"
	flags = FPRINT|TABLEPASS|HEADCOVERSEYES|HEADCOVERSMOUTH|BLOCKHAIR
	max_temperature = HEAT_PROTECTION_TEMPERATURE_LOW
	armor = list(impact = 0.2, slash = 0.2, pierce = 0, bomb = 0.2, bio = 0.8, rad = 1.0)


/obj/item/clothing/suit/radiation
	name = "radiation suit"
	desc = "A suit that protects against radiation. Label: Made with lead, do not eat insulation."
	icon_state = "rad"
	item_state = "rad_suit"
	w_class = 4//bulky item
	body_parts_covered = CHEST|LEGS|ARMS
	slowdown = 1.0
	armor = list(impact = 0.2, slash = 0.2, pierce = 0, bomb = 0.2, bio = 0.8, rad = 1.0)
	flags_inv = HIDEJUMPSUIT
