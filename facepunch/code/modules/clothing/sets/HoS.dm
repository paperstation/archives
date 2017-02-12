/*
 * Head of Security
 */
/obj/item/clothing/under/rank/head_of_security
	desc = "It's a jumpsuit worn by those few with the dedication to achieve the position of \"Head of Security\". It has additional armor to protect the wearer."
	name = "head of security's jumpsuit"
	icon_state = "hos"
	item_state = "r_suit"
	variant = "hosred"
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL


/obj/item/clothing/head/helmet/HoS
	name = "Head of Security Hat"
	desc = "The hat of the Head of Security. For showing the officers who's in charge."
	icon_state = "hoscap"
	flags_inv = HIDEEARS
	flags = FPRINT | TABLEPASS | HEADCOVERSEYES
	armor = list(impact = 0.8, slash = 0.4, pierce = 0.4, bomb = 0.2, bio = 0.0, rad = 0.0)


/obj/item/clothing/suit/armor/hos
	name = "armored coat"
	desc = "A greatcoat enchanced with a special alloy for some protection and style."
	icon_state = "hos"
	item_state = "hos"
	body_parts_covered = CHEST|ARMS|LEGS
	flags_inv = HIDEJUMPSUIT
	armor = list(impact = 0.8, slash = 0.4, pierce = 0.4, bomb = 0.2, bio = 0.0, rad = 0.0)



//Jensen cosplay gear
/obj/item/clothing/head/helmet/HoS/dermal
	name = "Dermal Armour Patch"
	desc = "You're not quite sure how you manage to take it on and off, but it implants nicely in your head."
	icon_state = "dermal"
	item_state = "dermal"

/obj/item/clothing/under/rank/head_of_security/jensen
	desc = "You never asked for anything that stylish."
	name = "head of security's jumpsuit"
	icon_state = "jensen"
	item_state = "jensen"
	variant = "jensen"

/obj/item/clothing/suit/armor/hos/jensen
	name = "armored trenchoat"
	desc = "A trenchoat augmented with a special alloy for some protection and style"
	icon_state = "jensencoat"
	item_state = "jensencoat"
	flags_inv = 0