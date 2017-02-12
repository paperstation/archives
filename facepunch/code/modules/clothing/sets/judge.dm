//Adminbus judge armor here

/obj/item/clothing/head/helmet/space/dredd
	name = "Judge Helmet"
	desc = "The sturdy and resistant helmet of a street judge, strikes comfort into citizens and terror into the hearts of criminals."
	icon_state = "dredd"
	item_state = "dredd_helm"
	w_class = 3.0
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE
	armor = list(impact = 0.8, slash = 0.8, pierce = 0.4, bomb = 0.4, bio = 1.0, rad = 1.0)
	can_remove = 0


/obj/item/clothing/suit/space/dredd
	name = "Judge Armor"
	desc = "The reinforced armour of a street judge, greatly resistant to most damage but most importantly bearing the golden shoulder pads representing both order and justice."
	icon_state = "dredd"
	item_state = "dredd_suit"
	w_class = 4.0
	body_parts_covered = CHEST|LEGS|ARMS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	allowed = list(/obj/item/weapon/tank/emergency_oxygen, /obj/item/device/flashlight,/obj/item/weapon/gun, /obj/item/weapon/gun/projectile, /obj/item/ammo_magazine, /obj/item/ammo_casing, /obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs)
	armor = list(impact = 0.8, slash = 0.8, pierce = 0.4, bomb = 0.4, bio = 1.0, rad = 1.0)
	can_remove = 0


/obj/structure/closet/suit/dredd
	name = "Judge Suit"
	desc = "Now you can be The Lawwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww!"
	icon_state = "black"
	icon_closed = "black"

	New()
		..()
		sleep(2)
		new/obj/item/clothing/shoes/combat(src)
		new/obj/item/clothing/under/color/black(src)
		new/obj/item/clothing/suit/space/dredd(src)
		new/obj/item/clothing/head/helmet/space/dredd(src)
		new/obj/item/clothing/gloves/combat(src)
		new/obj/item/clothing/glasses/sunglasses/sechud(src)
		new/obj/item/clothing/mask/breath(src)