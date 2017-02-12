/obj/item/clothing/head/helmet/riot
	name = "riot helmet"
	desc = "It's a helmet specifically designed to protect against close range attacks."
	icon_state = "riot"
	item_state = "helmet"
	flags = FPRINT|TABLEPASS|HEADCOVERSEYES
	flags_inv = HIDEEARS
	armor = list(impact = 0.8, slash = 0.8, pierce = 0.2, bomb = 0.4, bio = 0.0, rad = 0.0)


/obj/item/clothing/suit/armor/riot
	name = "riot suit"
	desc = "A suit of armor with heavy padding to protect against melee attacks. Looks like it might impair movement."
	icon_state = "riot"
	item_state = "swat_suit"
	body_parts_covered = CHEST|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT
	slowdown = 1
	armor = list(impact = 0.8, slash = 0.8, pierce = 0.2, bomb = 0.4, bio = 0.0, rad = 0.0)

