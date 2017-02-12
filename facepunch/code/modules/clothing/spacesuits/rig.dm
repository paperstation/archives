//Regular rig suits
/obj/item/clothing/head/helmet/space/rig
	name = "engineering hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Has radiation shielding and electrical insulation."
	icon_state = "rig0-engineering"
	item_state = "eng_helm"
	armor = list(impact = 0.4, slash = 0.4, pierce = 0.0, bomb = 0.4, bio = 1.0, rad = 1.0)
	var/brightness_on = 4 //luminosity when on
	var/on = 0
	variant = "engineering" //Determines used sprites: rig[on]-[variant] and rig[on]-[variant]2 (lying down sprite)
	icon_action_button = "action_hardhat"

	attack_self(mob/user)
		if(!isturf(user.loc))
			user << "You cannot turn the light on while in this [user.loc]" //To prevent some lighting anomalities.
			return
		on = !on
		icon_state = "rig[on]-[variant]"
//		item_state = "rig[on]-[variant]"

		if(on)	user.SetLuminosity(user.luminosity + brightness_on)
		else	user.SetLuminosity(user.luminosity - brightness_on)

	pickup(mob/user)
		if(on)
			user.SetLuminosity(user.luminosity + brightness_on)
//			user.UpdateLuminosity()
			SetLuminosity(0)

	dropped(mob/user)
		if(on)
			user.SetLuminosity(user.luminosity - brightness_on)
//			user.UpdateLuminosity()
			SetLuminosity(brightness_on)

/obj/item/clothing/suit/space/rig
	name = "engineering hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has radiation shielding and electrical insulation."
	icon_state = "rig-engineering"
	item_state = "eng_hardsuit"
	slowdown = 2
	armor = list(impact = 0.4, slash = 0.4, pierce = 0.0, bomb = 0.4, bio = 1.0, rad = 1.0)

//Chief Engineer's rig
/obj/item/clothing/head/helmet/space/rig/elite
	name = "advanced hardsuit helmet"
	desc = "An advanced helmet designed for work in a hazardous, low pressure environment. Shines with a high polish."
	icon_state = "rig0-white"
	item_state = "ce_helm"
	variant = "white"
	armor = list(impact = 0.8, slash = 0.4, pierce = 0.0, bomb = 0.4, bio = 1.0, rad = 1.0)

/obj/item/clothing/suit/space/rig/elite
	icon_state = "rig-white"
	name = "advanced hardsuit"
	desc = "An advanced suit that protects against hazardous, low pressure environments. Shines with a high polish."
	item_state = "ce_hardsuit"
	armor = list(impact = 0.8, slash = 0.4, pierce = 0.0, bomb = 0.4, bio = 1.0, rad = 1.0)


//Mining rig
/obj/item/clothing/head/helmet/space/rig/mining
	name = "mining hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environments. Has reinforced plating for protection from cave-ins."
	icon_state = "rig0-mining"
	item_state = "mining_helm"
	variant = "mining"

/obj/item/clothing/suit/space/rig/mining
	icon_state = "rig-mining"
	name = "mining hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has reinforced plating for protection from cave-ins."
	item_state = "mining_hardsuit"


//Syndicate rig
/obj/item/clothing/head/helmet/space/rig/syndi
	name = "blood-red hardsuit helmet"
	desc = "An advanced helmet designed for work in special operations. Property of Gorlex Marauders."
	icon_state = "rig0-syndi"
	item_state = "syndie_helm"
	variant = "syndi"
	armor = list(impact = 0.4, slash = 0.8, pierce = 0.4, bomb = 0.8, bio = 1.0, rad = 1.0)


/obj/item/clothing/suit/space/rig/syndi
	icon_state = "rig-syndi"
	name = "blood-red hardsuit"
	desc = "An advanced suit that protects against injuries during special operations. Property of Gorlex Marauders."
	item_state = "syndie_hardsuit"
	slowdown = 1
	w_class = 3
	armor = list(impact = 0.4, slash = 0.8, pierce = 0.4, bomb = 0.8, bio = 1.0, rad = 1.0)
