//Deathsquad suit
/obj/item/clothing/head/helmet/space/deathsquad
	name = "deathsquad helmet"
	desc = "That's not red paint. That's real blood."
	icon_state = "deathsquad"
	item_state = "deathsquad"
	armor = list(impact = 0.8, slash = 0.8, pierce = 0.4, bomb = 0.8, bio = 1.0, rad = 1.0)

/obj/item/clothing/head/helmet/space/deathsquad/beret
	name = "officer's beret"
	desc = "An armored beret commonly used by special operations officers."
	icon_state = "beret_badge"
	armor = list(impact = 0.8, slash = 0.8, pierce = 0.4, bomb = 0.8, bio = 1.0, rad = 1.0)
	flags = FPRINT | TABLEPASS | HEADCOVERSEYES | BLOCKHAIR


//NASA Voidsuit
/obj/item/clothing/head/helmet/space/nasavoid
	name = "NASA Void Helmet"
	desc = "A high tech, NASA Centcom branch designed, dark red space suit helmet."
	icon_state = "void"
	item_state = "void"

/obj/item/clothing/suit/space/nasavoid
	name = "NASA Voidsuit"
	icon_state = "void"
	item_state = "void"
	desc = "A high tech, NASA Centcom branch designed, dark red Space suit."
	slowdown = 1


//Space santa outfit suit
/obj/item/clothing/head/helmet/space/santahat
	name = "Santa's hat"
	desc = "Ho ho ho. Merrry X-mas!"
	icon_state = "santahat"
	flags = FPRINT | TABLEPASS | HEADCOVERSEYES | BLOCKHAIR

/obj/item/clothing/suit/space/santa
	name = "Santa's suit"
	desc = "Festive!"
	icon_state = "santa"
	item_state = "santa"
	slowdown = 0
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL
	allowed = list(/obj/item) //for stuffing exta special presents


//Space pirate outfit
/obj/item/clothing/head/helmet/space/pirate
	name = "pirate hat"
	desc = "Yarr."
	icon_state = "pirate"
	item_state = "pirate"
	armor = list(impact = 0.8, slash = 0.2, pierce = 0.4, bomb = 0.4, bio = 1.0, rad = 1.0)
	flags = FPRINT | TABLEPASS | HEADCOVERSEYES | BLOCKHAIR


/obj/item/clothing/suit/space/pirate
	name = "pirate coat"
	desc = "Yarr."
	icon_state = "pirate"
	item_state = "pirate"
	w_class = 3
	slowdown = 0
	armor = list(impact = 0.8, slash = 0.2, pierce = 0.4, bomb = 0.4, bio = 1.0, rad = 1.0)


/obj/item/clothing/head/helmet/space/emerg
	name = "Emergency Suit Helmet"
	desc = "emerg"
	icon_state = "emerg"
	item_state = "emerg"
	slowdown = 1
	armor = list(impact = 0.4, slash = 0.2, pierce = 0.0, bomb = 0.2, bio = 1.0, rad = 1.0)

/obj/item/clothing/suit/space/emerg
	name = "Emergency Suit"
	desc = "emerg"
	icon_state = "emerg"
	item_state = "emerg"
	slowdown = 1
	armor = list(impact = 0.4, slash = 0.2, pierce = 0.0, bomb = 0.2, bio = 1.0, rad = 1.0)

// Space Marine Power Armour

// Space Marine Power Armour - Just a foundation, more exciting features coming soon. Armor values also placeholder.

/obj/item/clothing/head/helmet/space/imperium
	name = "Mark VII Aquila Helmet"
	desc = "The Mark VII Helmet corresponding to it's parent Power Armour."
	icon_state = "bloodraven_helmet"
	item_state = "bloodraven_helmet"
	armor = list(impact = 0.5, slash = 0.5, pierce = 0.5, bomb = 0.5, bio = 1.0, rad = 1.0)

/obj/item/clothing/suit/space/imperium
	name = "Mark VII Aquila Power Armour"
	desc = "Mark VII armour was developed during the Horus Heresy, and remains in use as the most common form of power armour."
	icon_state = "bloodraven_suit"
	item_state = "bloodraven_suit"
	can_remove = 0
	slowdown = 2
	armor = list(impact = 0.5, slash = 0.5, pierce = 0.5, bomb = 0.5, bio = 1.0, rad = 1.0)