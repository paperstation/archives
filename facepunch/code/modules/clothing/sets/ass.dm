
/obj/item/clothing/head/helmet/space/ass
	name = "ass helmet"
	desc = "Assault System Specialist Combat Helmet. Highly resistant to pressure and all forms of damage."
	icon_state = "tcom"
	item_state = "tcom"
	armor = list(impact = 0.8, slash = 0.8, pierce = 0.4, bomb = 0.4, bio = 1.0, rad = 1.0)
	can_remove = 0

/obj/item/clothing/suit/space/ass
	name = "ass armor"
	desc = "Assault System Specialist Combat Suit. Highly resistant to pressure and all forms of damage."
	icon_state = "tcom"
	item_state = "tcom"
	flags_inv = HIDESHOES
	armor = list(impact = 0.8, slash = 0.8, pierce = 0.4, bomb = 0.4, bio = 1.0, rad = 1.0)
	slowdown = 1
	can_remove = 0


/obj/item/clothing/under/ass
	name = "ass jumpsuit"
	desc = "Assault System Specialist Combat Heavy Enhanced Energetic Kenitic Suit."
	icon_state = "tcom"
	variant = "tcom"


/obj/structure/closet/suit/syndicate/ass
	name = "ass Suit"
	desc = "Formerly Security for Hire now part of the Syndicate."
	icon_state = "black"
	icon_closed = "black"

	New()
		..()
		sleep(2)
		new/obj/item/weapon/tank/jetpack/oxygen(src)
		new/obj/item/clothing/shoes/combat(src)
		new/obj/item/clothing/under/ass(src)
		new/obj/item/clothing/suit/space/ass(src)
		new/obj/item/clothing/head/helmet/space/ass(src)
		new/obj/item/clothing/gloves/combat(src)
		new/obj/item/clothing/mask/breath(src)
		new/obj/item/weapon/gun/projectile/automatic/l6_saw(src)
		new/obj/item/ammo_magazine/a762(src)
		new/obj/item/ammo_magazine/a762(src)
		new/obj/item/weapon/implanter/ass(src)

