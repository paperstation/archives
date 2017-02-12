// EARS

/obj/item/clothing/ears
	name = "ears"
	inhand_image_icon = 'icons/mob/inhand/hand_headgear.dmi'
	wear_image_icon = 'icons/mob/ears.dmi'
	w_class = 1.0
	throwforce = 2
	var/block_hearing = 0

/obj/item/clothing/ears/earmuffs
	name = "earmuffs"
	icon_state = "earmuffs"
	protective_temperature = 500
	item_state = "earmuffs"
	desc = "Keeps you warm, makes it hard to hear."
	block_hearing = 1

/obj/item/clothing/ears/earmuffs/earplugs
	name = "ear plugs"
	icon_state = "earplugs"
	item_state = "nothing"
	desc = "Protects you from sonic attacks."