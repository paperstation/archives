// CHUMP HELMETS: COOKING THEM DESTROYS THE CHUMP HELMET SPAWN.

/obj/item/clothing/head/helmet
	name = "helmet"
	icon_state = "helmet"
	c_flags = COVERSEYES
	item_state = "helmet"
	desc = "Somewhat protects your head from being bashed in."

	protective_temperature = 500
	heat_transfer_coefficient = 0.10
	armor_value_melee = 6

/obj/item/clothing/head/helmet/space
	name = "space helmet"
	icon_state = "space"
	c_flags = SPACEWEAR | COVERSEYES | COVERSMOUTH
	see_face = 0.0
	item_state = "s_helmet"
	desc = "Helps protect against vacuum."
	disease_resistance = 50
	armor_value_melee = 4
	seal_hair = 1
	cold_resistance = 20
	heat_resistance = 5

/obj/item/clothing/head/helmet/space/engineer
	name = "engineering space helmet"
	desc = "Comes equipped with a builtin flashlight."
	icon_state = "espace0"
	c_flags = SPACEWEAR | COVERSEYES | COVERSMOUTH
	see_face = 0.0
	item_state = "s_helmet"
	armor_value_melee = 5
	var/datum/light/light
	var/on = 0

	New()
		..()
		light = new /datum/light/point
		light.set_brightness(1)
		light.set_height(1.8)
		light.set_color(0.9, 0.9, 1)
		light.attach(src)

	attack_self(mob/user)
		src.flashlight_toggle(user)
		return

	pickup(mob/user)
		..()
		light.attach(user)

	dropped(mob/user)
		..()
		spawn(0)
			if (src.loc != user)
				light.attach(src)

	proc/flashlight_toggle(var/mob/user, var/force_on = 0)
		on = !on
		src.icon_state = "espace[on]"
		if (on)
			light.enable()
		else
			light.disable()
		user.update_clothing()
		return

/obj/item/clothing/head/helmet/space/syndicate
	name = "red space helmet"
	icon_state = "syndicate"
	item_state = "syndicate"
	desc = "The standard space helmet of the dreaded Syndicate."

/obj/item/clothing/head/helmet/swat
	name = "swat helmet"
	icon_state = "swat"
	c_flags = COVERSEYES
	item_state = "swat"
	armor_value_melee = 5

/obj/item/clothing/head/helmet/turd
	name = "T.U.R.D.S. helmet"
	icon_state = "turdhelm"
	c_flags = COVERSEYES
	item_state = "turdhelm"
	armor_value_melee = 5

/obj/item/clothing/head/helmet/thunderdome
	name = "Thunderdome helmet"
	icon_state = "thunderdome"
	c_flags = COVERSEYES
	item_state = "thunderdome"
	armor_value_melee = 5

/obj/item/clothing/head/helmet/hardhat
	name = "hard hat"
	icon_state = "hardhat0"
	c_flags = SPACEWEAR
	item_state = "hardhat0"
	desc = "Protects your head from falling objects, and comes with a flashlight. Safety first!"
	armor_value_melee = 7
	var/datum/light/light
	var/on = 0

	New()
		..()
		light = new /datum/light/point
		light.set_brightness(1)
		light.set_height(1.8)
		light.set_color(1, 1, 0.9)
		light.attach(src)

	pickup(mob/user)
		..()
		light.attach(user)

	dropped(mob/user)
		..()
		spawn(0)
			if (src.loc != user)
				light.attach(src)

	attack_self(mob/user)
		src.flashlight_toggle(user)
		return

	proc/flashlight_toggle(var/mob/user, var/force_on = 0)
		on = !on
		src.icon_state = "hardhat[on]"
		src.item_state = "hardhat[on]"
		user.update_clothing()
		if (on)
			light.enable()
		else
			light.disable()
		return

/obj/item/clothing/head/helmet/camera
	name = "camera helmet"
	desc = "A helmet with a built in camera."
	icon_state = "camhat"
	c_flags = SPACEWEAR
	item_state = "camhat"
	var/obj/machinery/camera/camera = null
	var/camera_tag = "Helmet Cam"
	var/camera_network = "Zeta"

	New()
		..()
		src.camera = new /obj/machinery/camera (src)
		src.camera.c_tag = src.camera_tag
		src.camera.network = src.camera_network

/obj/item/clothing/head/helmet/camera/security
	name = "security camera helmet"
	desc = "A red helmet with a built in camera. It has a little note taped to it that says \"Security\"."
	icon_state = "redcamhat"
	c_flags = SPACEWEAR
	item_state = "redcamhat"
	camera_tag = "Security Helmet Cam"

/obj/item/clothing/head/helmet/jetson
	name = "Fifties America Reclamation Team Helmet"
	desc = "Combat helmet used by a minor terrorist group."
	icon_state = "jetson1"
	c_flags = SPACEWEAR
	icon_state = "jetson"
	item_state = "jetson"
	armor_value_melee = 3

/obj/item/clothing/head/helmet/welding
	name = "welding helmet"
	desc = "A head-mounted face cover designed to protect the wearer completely from space-arc eye. Can be flipped up for clearer vision."
	icon_state = "welding"
	c_flags = SPACEWEAR | COVERSEYES
	see_face = 0.0
	item_state = "welding"
	protective_temperature = 1300
	m_amt = 3000
	g_amt = 1000
	var/up = 0
	armor_value_melee = 6

/obj/item/clothing/head/helmet/EOD
	name = "blast helmet"
	desc = "A thick head cover made of layers upon layers of space kevlar."
	icon_state = "EOD"
	item_state = "tdhelm"
	c_flags = COVERSEYES
	armor_value_melee = 8

/obj/item/clothing/head/helmet/HoS
	name = "HoS Hat"
	icon_state = "hoscap"
	item_state = "hoscap"
	c_flags = SPACEWEAR | COVERSEYES
	var/is_a_communist = 0
	var/folds = 0
	desc = "Actually, you got this hat from a fast-food restaurant, that's why it folds like it was made of paper."
	armor_value_melee = 7

/obj/item/clothing/head/helmet/HoS/attack_self(mob/user as mob)
	if(user.r_hand == src || user.l_hand == src)
		if(!src.folds)
			src.folds = 1
			src.name = "HoS Beret"
			src.icon_state = "hosberet"
			src.item_state = "hosberet"
			boutput(usr, "<span style=\"color:blue\">You fold the hat into a beret.</span>")
		else
			src.folds = 0
			src.name = "HoS Hat"
			src.icon_state = "hoscap"
			src.item_state = "hoscap"
			boutput(usr, "<span style=\"color:blue\">You unfold the beret back into a hat.</span>")
		return

/obj/item/clothing/head/helmet/NT
	name = "Nanotrasen Helmet"
	desc = "Security has the constitutionality of a vending machine."
	icon_state = "nthelm"
	item_state = "nthelm"
	c_flags = SPACEWEAR | COVERSEYES | COVERSMOUTH
	see_face = 0.0
	armor_value_melee = 7

/obj/item/clothing/head/helmet/space/industrial
	name = "Industrial Space Helmet"
	desc = "Goes with Industrial Space Armor. Now with zesty citrus-scented visor!"
	icon_state = "indus"
	item_state = "indus"
	mats = 7
	armor_value_melee = 2

	/*syndicate
		name = "Syndicate Command Helmet"
		desc = "Ooh, fancy."
		icon_state = "indusred"
		item_state = "indusred" */

/obj/item/clothing/head/helmet/bucket
	name = "bucket helmet"
	desc = "Someone's cut out a bit of this bucket so you can put it on your head."
	icon_state = "buckethelm"
	item_state = "buckethelm"
	armor_value_melee = 2
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	inhand_image = "bucket"

	red
		name = "red bucket helmet"
		desc = "Someone's cut out a bit of this bucket so you can put it on your head. It's red, and it kinda remind you of something."
		icon_state = "buckethelm-r"
		item_state = "buckethelm-r"
		inhand_image = "bucket-r"