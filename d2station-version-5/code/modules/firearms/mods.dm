/obj/item/weapon/gunmod
	name = "gunmod"
	desc = "A modification for a firearm."
	icon = 'weapon_assembly.dmi'
	var/calibre

/obj/item/weapon/gunmod/suppressor
	name = "suppressor"
	desc = "Reduces round velocity and muzzle sound to quiet weapon."
	icon_state = "shortsuppressor"

/obj/item/weapon/gunmod/suppressor/uzi
	name = "mini-uzi suppressor"
	icon_state = "shortsuppressor"
	calibre = "11.4"

/obj/item/weapon/gunmod/suppressor/deagle
	name = "desert eagle suppressor"
	calibre = "12.7"

/obj/item/weapon/gunmod/suppressor/fiveseven
	name = "five-seven suppressor"
	icon_state = "silvthinshortsuppressor"
	calibre = "5.7"