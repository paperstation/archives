

/obj/item/clothing/suit/abs
	name = "Duke Armor"
	desc = "Always count on duke!"
	icon_state = "dukeabs"
	item_state = "dukeabs"
	body_parts_covered = CHEST
	armor = list(impact = 0.0, slash = 0.0, pierce = 1.0, bomb = 0.0, bio = 0.0, rad = 0.0)


/obj/item/clothing/gloves/fingerless
	desc = "These gloves lack fingers."
	name = "Fingerless Gloves"
	icon_state = "fgloves"
	item_state = "finger-"


/obj/item/clothing/under/duke
	name = "Duke Suit"
	desc = "You have come here to chew bubblegum and kick ass...and you're all out of bubblegum."
	icon_state = "duke"
	item_state = "r_suit"
	variant = "duke"


/obj/structure/closet/suit/duke
	name = "Duke Suit"
	desc = "Always count on duke!"
	icon_state = "black"
	icon_closed = "black"


	New()
		..()
		sleep(2)
		new/obj/item/clothing/shoes/black(src)
		new/obj/item/clothing/under/duke(src)
		new/obj/item/clothing/suit/abs(src)
		new/obj/item/clothing/gloves/fingerless(src)
		new/obj/item/clothing/glasses/sunglasses/big(src)




