
/obj/item/clothing/suit/armor
	allowed = list(/obj/item/weapon/tank/emergency_oxygen,/obj/item/clothing/head/helmet, /obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs)
	body_parts_covered = CHEST


/obj/item/clothing/suit/armor/bulletproof//Now used by the barman
	name = "Old Bulletproof Vest"
	desc = "An old vest that use to excel in protecting the wearer against high-velocity solid projectiles."
	icon_state = "bulletproof"
	item_state = "armor"
	blood_overlay_type = "armor"
	armor = list(impact = 0.4, slash = 0.4, pierce = 0.2, bomb = 0.4, bio = 0.0, rad = 0.0)


/obj/item/clothing/suit/armor/laserproof
	name = "Ablative Armor Vest"
	desc = "A vest that excels in protecting the wearer against all projectiles."
	icon_state = "armor_reflec"
	item_state = "armor_reflec"
	blood_overlay_type = "armor"
	armor = list(impact = 0.2, slash = 0.2, pierce = 0.8, bomb = 0, bio = 0, rad = 0)





//All of the armor below is mostly unused
/obj/item/clothing/suit/armor/centcomm
	name = "Cent. Com. armor"
	desc = "A suit that protects against some damage."
	icon_state = "centcom"
	item_state = "centcom"
	w_class = 4//bulky item
	body_parts_covered = CHEST|LEGS|ARMS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	armor = list(impact = 0.8, slash = 0.8, pierce = 0.4, bomb = 0.8, bio = 1.0, rad = 1.0)

/obj/item/clothing/suit/armor/heavy
	name = "heavy armor"
	desc = "A heavily armored suit that protects against moderate damage."
	icon_state = "heavy"
	item_state = "swat_suit"
	w_class = 4//bulky item
	body_parts_covered = CHEST|LEGS|ARMS
	slowdown = 3
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	armor = list(impact = 0.8, slash = 0.8, pierce = 0.4, bomb = 0.8, bio = 1.0, rad = 1.0)




/obj/item/clothing/head/helmet/samurai
	name = "samurai helmet"
	desc = "SHAMFUL DISPRAY."
	icon_state = "samurai"
	flags = FPRINT|TABLEPASS|HEADCOVERSEYES|HEADCOVERSMOUTH
	item_state = "samurai"
	armor = list(impact = 0.4, slash = 0.8, pierce = 0.0, bomb = 0.2, bio = 0.0, rad = 0.0)

/obj/item/clothing/suit/armor/samurai
	name = "samurai armor"
	desc = "Its Samurai armor, what more could you need?"
	icon_state = "samurai"
	can_remove = 1
	item_state = "samurai"
	body_parts_covered = CHEST|LEGS|ARMS
	armor = list(impact = 1, slash = 1, pierce = 1, bomb = 1, bio = 1, rad = 1)
