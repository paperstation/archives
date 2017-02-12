//new/obj/item/clothing/gloves/combat(src)
/obj/item/clothing/head/helmet/space/swat
	name = "\improper SWAT helmet"
	desc = "They're often used by highly trained Swat Members."
	icon_state = "swat"
	item_state = "swat"
	armor = list(impact = 0.8, slash = 0.8, pierce = 0.4, bomb = 0.8, bio = 1.0, rad = 1.0)
	flags_inv = HIDEEARS|HIDEEYES


/obj/item/clothing/suit/space/swat
	name = "swat suit"
	desc = "A heavily armored suit that protects against moderate damage. Used in special operations."
	icon_state = "deathsquad"
	item_state = "swat_suit"
	slowdown = 1
	armor = list(impact = 0.8, slash = 0.8, pierce = 0.4, bomb = 0.8, bio = 1.0, rad = 1.0)


/obj/item/clothing/suit/space/swat/officer
	name = "officer jacket"
	desc = "An armored jacket used in special operations."
	icon_state = "detective"
	item_state = "det_suit"
	blood_overlay_type = "coat"
	flags_inv = 0
