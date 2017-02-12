//DKK here

/obj/item/clothing/mask/gas/krieg
	name = "Krieg Mask"
	desc = "A three piece respirator unit issued to every Death Korps Guardsman designed to allow them to operate in any toxic enviroment including their homeworld of Krieg in the Segmentum Tempestus. This mask also has a tendency to strike fear into the heart of anyone human or not when they see it charging towards them."
	icon_state = "krieg_mask"
	flags = FPRINT | TABLEPASS | MASKCOVERSMOUTH | MASKCOVERSEYES | BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE
	w_class = 3.0
	item_state = "krieg_mask"


/obj/item/clothing/head/helmet/krieg
	name = "Krieg Helmet"
	desc = "The standard-issue Mark IX helmet constructed out of plasteel designed to keep the user safe while creating an air tight seal around the standard issue gasmask."
	icon_state = "krieg_helmet"
	item_state = "krieg_helmet"
	w_class = 3.0
	flags_inv = HIDEEARS|HIDEEYES
	armor = list(impact = 0.4, slash = 0.4, pierce = 0.4, bomb = 0.4, bio = 0.8, rad = 0.0)


/obj/item/clothing/suit/armor/krieg
	name = "Krieg Armor"
	desc = "A heavy greatcoat, warm, waterproof and built to last. It has armoured shoulder and chest plates designed to deflect even the most powerful of xeno weaponry."
	icon_state = "krieg_suit"
	item_state = "krieg_suit"
	w_class = 4.0
	body_parts_covered = CHEST|LEGS|ARMS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	armor = list(impact = 0.4, slash = 0.4, pierce = 0.4, bomb = 0.4, bio = 0.8, rad = 0.0)


/obj/item/device/flashlight/krieg
	name = "lasrifle"
	desc = "Standard issue armament."


/obj/structure/closet/suit/krieg
	name = "Krieg Suit"
	desc = "Contains all the gear a Krieger would need"
	icon_state = "black"
	icon_closed = "black"

	New()
		..()
		sleep(2)
		new/obj/item/clothing/shoes/combat(src)
		new/obj/item/clothing/under/color/black(src)
		new/obj/item/clothing/suit/armor/krieg(src)
		new/obj/item/clothing/head/helmet/krieg(src)
		new/obj/item/clothing/gloves/combat(src)
		new/obj/item/clothing/mask/gas/krieg(src)
		new/obj/item/device/flashlight/krieg(src)