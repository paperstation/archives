/*
 * Contains:
 *		Lasertag
 *		Costume
 *		Misc
 */

/*
 * Lasertag
 */

/obj/item/clothing/suit/lasertag
	name = "broken laser tag armour"
	desc = "The Sensors appear to be broken"
	icon_state = "bluetag"
	item_state = "bluetag"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST
	allowed = list (/obj/item/weapon/gun)


/obj/item/clothing/suit/lasertag/blue
	name = "blue laser tag armour"
	desc = "Blue Pride, Station Wide"
	icon_state = "bluetag"
	item_state = "bluetag"


/obj/item/clothing/suit/lasertag/red
	name = "red laser tag armour"
	desc = "better Red than dead"
	icon_state = "redtag"
	item_state = "redtag"


/obj/item/clothing/suit/lasertag/blue/away
	name = "blue laser tag armour"
	desc = "Blue Pride, Station Wide"
	icon_state = "bluetag"
	item_state = "bluetag"


/obj/item/clothing/suit/lasertag/red/away
	name = "red laser tag armour"
	desc = "better Red than dead"
	icon_state = "redtag"
	item_state = "redtag"



/*
 * Costume
 */
/obj/item/clothing/suit/pirate
	name = "pirate coat"
	desc = "Yarr."
	icon_state = "pirate"
	item_state = "pirate"


/obj/item/clothing/suit/hgpirate
	name = "pirate captain coat"
	desc = "Yarr."
	icon_state = "hgpirate"
	item_state = "hgpirate"
	flags_inv = HIDEJUMPSUIT


/obj/item/clothing/suit/cyborg_suit
	name = "cyborg suit"
	desc = "Suit for a cyborg costume."
	icon_state = "death"
	item_state = "death"
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT


/obj/item/clothing/suit/greatcoat
	name = "great coat"
	desc = "A Nazi great coat"
	icon_state = "nazi"
	item_state = "nazi"

/obj/item/clothing/suit/johnny_coat
	name = "johnny~~ coat"
	desc = "Johnny~~"
	icon_state = "johnny"
	item_state = "johnny"

/obj/item/clothing/suit/justice
	name = "justice suit"
	desc = "this pretty much looks ridiculous"
	icon_state = "justice"
	item_state = "justice"
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT


/obj/item/clothing/suit/judgerobe
	name = "judge's robe"
	desc = "This robe commands authority."
	icon_state = "judge"
	item_state = "judge"
	body_parts_covered = CHEST|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT


/obj/item/clothing/suit/wcoat
	name = "waistcoat"
	desc = "For some classy, murderous fun."
	icon_state = "vest"
	item_state = "wcoat"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST

/obj/item/clothing/suit/syndicatefake
	name = "red space suit replica"
	icon_state = "syndicate"
	item_state = "space_suit_syndicate"
	desc = "A plastic replica of the syndicate space suit, you'll look just like a real murderous syndicate agent in this! This is a toy, it is not made for use in space!"
	w_class = 3
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT


/obj/item/clothing/suit/hastur
	name = "Hastur's Robes"
	desc = "Robes not meant to be worn by man"
	icon_state = "hastur"
	item_state = "hastur"
	body_parts_covered = CHEST|LEGS|ARMS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT


/obj/item/clothing/suit/imperium_monk
	name = "Imperium monk"
	desc = "Have YOU killed a xenos today?"
	icon_state = "imperium_monk"
	item_state = "imperium_monk"
	body_parts_covered = CHEST|LEGS|ARMS
	flags_inv = HIDESHOES|HIDEJUMPSUIT|HIDEGLOVES


/obj/item/clothing/suit/mechanicus
	name = "adeptus mechanicus suit"
	desc = "Have you tried lighting some incense?"
	icon_state = "mechanicus"
	item_state = "mechanicus"
	body_parts_covered = CHEST|LEGS|ARMS
	flags_inv = HIDESHOES|HIDEJUMPSUIT|BLOCKHAIR
	flags = FPRINT|TABLEPASS|HEADCOVERSEYES|HEADCOVERSMOUTH|BLOCKHAIR
	can_remove = 0
	allowed = list(/obj/item)
	armor = list(impact = 0.2, slash = 0.2, pierce = 0, bomb = 0, bio = 0, rad = 0)


/obj/item/clothing/suit/chickensuit
	name = "Chicken Suit"
	desc = "A suit made long ago by the ancient empire KFC."
	icon_state = "chickensuit"
	item_state = "chickensuit"
	body_parts_covered = CHEST|LEGS|ARMS
	flags_inv = HIDESHOES|HIDEJUMPSUIT


/obj/item/clothing/suit/monkeysuit
	name = "Monkey Suit"
	desc = "A suit that looks like a primate"
	icon_state = "monkeysuit"
	item_state = "monkeysuit"
	body_parts_covered = CHEST|LEGS|ARMS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT


/obj/item/clothing/suit/holidaypriest
	name = "Holiday Priest"
	desc = "This is a nice holiday my son."
	icon_state = "holidaypriest"
	item_state = "holidaypriest"
	body_parts_covered = CHEST|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT


/obj/item/clothing/suit/cardborg
	name = "cardborg suit"
	desc = "An ordinary cardboard box with holes cut in the sides."
	icon_state = "cardborg"
	item_state = "cardborg"
	body_parts_covered = CHEST
	flags_inv = HIDEJUMPSUIT
	armor = list(impact = 0.2, slash = 0, pierce = 0, bomb = 0, bio = 0, rad = 0.2)

/*
 * Misc
 */
/obj/item/clothing/suit/ianshirt
	name = "worn shirt"
	desc = "A worn out, curiously comfortable t-shirt with a picture of Ian. You wouldn't go so far as to say it feels like being hugged when you wear it but it's pretty close. Good for sleeping in."
	icon_state = "ianshirt"
	item_state = "ianshirt"

//Blue suit jacket toggle
/obj/item/clothing/suit/suit/verb/toggle()
	set name = "Toggle Jacket Buttons"
	set category = "Object"
	set src in usr

	if(!usr.canmove || usr.stat || usr.restrained())
		return 0

	if(src.icon_state == "suitjacket_blue_open")
		src.icon_state = "suitjacket_blue"
		src.item_state = "suitjacket_blue"
		usr << "You button up the suit jacket."
	else if(src.icon_state == "suitjacket_blue")
		src.icon_state = "suitjacket_blue_open"
		src.item_state = "suitjacket_blue_open"
		usr << "You unbutton the suit jacket."
	else
		usr << "You button-up some imaginary buttons on your [src]."
		return
	usr.update_inv_wear_suit()

/obj/item/clothing/head/xenos
	name = "xenos helmet"
	icon_state = "xenos"
	item_state = "xenos_helm"
	desc = "A helmet made out of chitinous alien hide."
	flags = FPRINT | TABLEPASS | BLOCKHAIR
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE

/obj/item/clothing/suit/xenos
	name = "xenos suit"
	desc = "A suit made out of chitinous alien hide."
	icon_state = "xenos"
	item_state = "xenos_helm"
	body_parts_covered = CHEST|LEGS|ARMS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT


/obj/item/clothing/suit/reporterjacket
	name = "Reporter Jacket"
	desc = "With my handy dandy notebook!."
	icon_state = "reporterjacket"
	item_state = "reporterjacket"
	flags = FPRINT | TABLEPASS


/obj/item/clothing/suit/welder//Needs some armor, sprite verify, temp protection
	name = "Welder's Apron"
	desc = "Something is VERY wrong with this apron"
	icon_state = "wapron"
	item_state = "wapron"
	body_parts_covered = CHEST|LEGS|ARMS
	armor = list(impact = 0.4, slash = 0.8, pierce = 0.2, bomb = 1.0, bio = 1.0, rad = 1.0)