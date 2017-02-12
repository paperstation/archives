//Captain's Spacesuit
/obj/item/clothing/head/helmet/space/capspace
	name = "Captain's helmet"
	icon_state = "capspace"
	item_state = "capspacehelmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Only for the most fashionable of military figureheads."
	flags_inv = HIDEFACE
	armor = list(impact = 0.8, slash = 0.8, pierce = 0.4, bomb = 0.4, bio = 1.0, rad = 1.0)

/obj/item/clothing/suit/space/captain
	name = "Captain's armor"
	desc = "A bulky, heavy-duty piece of exclusive Nanotrasen armor. YOU are in charge!"
	icon_state = "caparmor"
	item_state = "capspacesuit"
	w_class = 4
	slowdown = 1
	armor = list(impact = 0.8, slash = 0.8, pierce = 0.4, bomb = 0.4, bio = 1.0, rad = 1.0)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
