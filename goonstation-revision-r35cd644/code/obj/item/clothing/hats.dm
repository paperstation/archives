// HATS. OH MY WHAT A FINE CHAPEAU, GOOD SIR.

/obj/item/clothing/head
	name = "hat"
	desc = "For your head!"
	icon = 'icons/obj/clothing/item_hats.dmi'
	wear_image_icon = 'icons/mob/head.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_headgear.dmi'
	body_parts_covered = HEAD
	compatible_species = list("human", "monkey")
	armor_value_melee = 1
	var/seal_hair = 0 // best variable name I could come up with, if 1 it forms a seal with a suit so no hair can stick out
	cold_resistance = 10
	heat_resistance = 5

/obj/item/clothing/head/red
	desc = "A knit cap in red."
	icon_state = "red"
	item_state = "rgloves"

/obj/item/clothing/head/blue
	desc = "A knit cap in blue."
	icon_state = "blue"
	item_state = "bgloves"

/obj/item/clothing/head/yellow
	desc = "A knit cap in yellow."
	icon_state = "yellow"
	item_state = "ygloves"

/obj/item/clothing/head/dolan
	name = "Dolan's Hat"
	desc = "A plsing hat."
	icon_state = "dolan"
	item_state = "dolan"

/obj/item/clothing/head/green
	desc = "A knit cap in green."
	icon_state = "green"
	item_state = "ggloves"

/obj/item/clothing/head/black
	desc = "A knit cap in black."
	icon_state = "black"
	item_state = "swat_gl"

/obj/item/clothing/head/white
	desc = "A knit cap in white."
	icon_state = "white"
	item_state = "lgloves"

/obj/item/clothing/head/psyche
	desc = "A knit cap in...what the hell?"
	icon_state = "psyche"
	item_state = "bgloves"

/obj/item/clothing/head/serpico
	icon_state = "serpico"
	item_state = "serpico"

/obj/item/clothing/head/bio_hood
	name = "bio hood"
	icon_state = "bio"
	permeability_coefficient = 0.01
	c_flags = SPACEWEAR | COVERSEYES | COVERSMOUTH
	desc = "This hood protects you from harmful biological contaminants."
	disease_resistance = 50
	armor_value_melee = 3
	seal_hair = 1
	cold_resistance = 10
	heat_resistance = 10

/obj/item/clothing/head/bio_hood/nt
	name = "NT bio hood"
	icon_state = "ntbiohood"
	armor_value_melee = 5

/obj/item/clothing/head/emerg
	name = "Emergency Hood"
	icon_state = "emerg"
	permeability_coefficient = 0.25
	c_flags = SPACEWEAR | COVERSEYES | COVERSMOUTH
	desc = "Helps protect from vacuum for a short period of time."

/obj/item/clothing/head/rad_hood
	name = "Class II Radiation Hood"
	icon_state = "radiation"
	permeability_coefficient = 0.01
	heat_transfer_coefficient = 0.10
	c_flags = COVERSEYES | COVERSMOUTH
	desc = "Asbestos, right near your face. Perfect!"
	armor_value_melee = 5
	radproof = 1
	seal_hair = 1

/obj/item/clothing/head/cakehat
	name = "cakehat"
	desc = "It is a cakehat"
	icon_state = "cake0"
	var/status = 0
	var/processing = 0
	c_flags = SPACEWEAR | COVERSEYES
	var/fire_resist = T0C+1300	//this is the max temp it can stand before you start to cook. although it might not burn away, you take damage
	var/datum/light/light
	var/on = 0

	New()
		..()
		light = new /datum/light/point
		light.set_brightness(0.6)
		light.set_height(1.8)
		light.set_color(0.94, 0.69, 0.27)
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
		if (!src || !user || !ismob(user)) return

		if (status > 1)
			return

		if (force_on)
			src.on = 1
		else
			src.on = !src.on

		if (src.on)
			src.force = 10
			src.damtype = "fire"
			src.icon_state = "cake1"
			light.enable()
			if (!(src in processing_items))
				processing_items.Add(src)
		else
			src.force = 3
			src.damtype = "brute"
			src.icon_state = "cake0"
			light.disable()

		user.update_clothing()
		src.add_fingerprint(user)
		return

	process()
		if (!src.on)
			processing_items.Remove(src)
			return

		var/turf/location = src.loc
		if (istype(location, /mob/))
			var/mob/living/carbon/human/M = location
			if (M.l_hand == src || M.r_hand == src || M.head == src)
				location = M.loc

		if (istype(location, /turf))
			location.hotspot_expose(700, 1)
		return

	afterattack(atom/target, mob/user as mob)
		if (src.on && !ismob(target) && target.reagents)
			boutput(usr, "<span style=\"color:blue\">You heat \the [target.name]</span>")
			target.reagents.temperature_reagents(2500,10)
		return

/obj/item/clothing/head/caphat
	name = "Captain's hat"
	icon_state = "captain"
	c_flags = SPACEWEAR
	item_state = "caphat"
	desc = "A symbol of the captain's rank, and the source of all his power."
	armor_value_melee = 5

/obj/item/clothing/head/centhat
	name = "Cent. Comm. hat"
	icon_state = "centcom"
	c_flags = SPACEWEAR
	item_state = "centcom"
	armor_value_melee = 5

	red
		icon_state = "centcom-red"
		item_state = "centcom-red"

/obj/item/clothing/head/det_hat
	name = "hat"
	desc = "Someone who wears this will look very smart"
	icon_state = "detective"
	armor_value_melee = 3

/obj/item/clothing/head/powdered_wig
	name = "powdered wig"
	desc = "A powdered wig"
	icon_state = "pwig"
	item_state = "pwig"

/obj/item/clothing/head/that
	name = "hat"
	desc = "An stylish looking hat"
	icon_state = "tophat"
	item_state = "that"

/obj/item/clothing/head/that/purple
	name = "purple hat"
	desc = "A purple tophat."
	icon_state = "ptophat"
	item_state = "pthat"
	c_flags = SPACEWEAR

	protective_temperature = 500
	heat_transfer_coefficient = 0.10

/obj/item/clothing/head/chefhat
	name = "Chef's hat"
	icon_state = "chef"
	item_state = "chef"
	desc = "Your toque blanche, coloured as such so that your poor sanitation is obvious, and the blood shows up nice and crazy."
	c_flags = SPACEWEAR

/obj/item/clothing/head/souschefhat
	name = "Sous-Chef's hat"
	icon_state = "souschef"
	item_state = "souschef"
	c_flags = SPACEWEAR

/obj/item/clothing/head/mailcap
	name = "Mailman's Hat"
	desc = "The hat of a mailman."
	icon_state = "mailcap"
	item_state = "mailcap"
	c_flags = SPACEWEAR

/obj/item/clothing/head/policecap
	name = "Police Hat"
	desc = "An old surplus-issue police hat."
	icon_state = "mailcap"
	item_state = "mailcap"
	c_flags = SPACEWEAR

/obj/item/clothing/head/plunger
	name = "plunger"
	desc = "get dat fukken clog"
	icon_state = "plunger"
	item_state = "plunger"
	armor_value_melee = 2

/obj/item/clothing/head/hosberet
	name = "HoS Beret"
	desc = "This makes you feel like Che Guevara."
	icon_state = "hosberet"
	item_state = "hosberet"
	c_flags = SPACEWEAR

/obj/item/clothing/head/NTberet
	name = "Nanotrasen Beret"
	desc = "For the inner dictator in you."
	icon_state = "ntberet"
	item_state = "ntberet"
	c_flags = SPACEWEAR

/obj/item/clothing/head/XComHair
	name = "Rookie Scalp"
	desc = "Some unfortunate soldier's charred scalp. The hair is intact."
	icon_state = "xcomhair"
	item_state = "xcomhair"
	c_flags = SPACEWEAR

/obj/item/clothing/head/apprentice
	name = "Apprentice's Cap"
	desc = "Legends tell about space sorcerors taking on apprentices. Such apprentices would wear a magical cap, and this is one such ite- hey! This is just a cardboard cone with wrapping paper on it!"
	icon_state = "apprentice"
	item_state = "apprentice"
	c_flags = SPACEWEAR

/obj/item/clothing/head/snake
	name = "Dirty Rag"
	desc = "A rag that looks like it was dragged through the jungle. Yuck."
	icon_state = "snake"
	item_state = "snake"
	c_flags = SPACEWEAR

// Chaplain Hats

/obj/item/clothing/head/rabbihat
	name = "rabbi's hat"
	desc = "Complete with jewcurls. Oy vey!"
	icon_state = "rabbihat"
	item_state = "that"

/obj/item/clothing/head/formal_turban
	name = "formal turban"
	desc = "A very stylish formal turban."
	icon_state = "formal_turban"
	item_state = "egg5"
	cold_resistance = 15
	heat_resistance = 10

/obj/item/clothing/head/turban
	name = "turban"
	desc = "A very comfortable cotton turban."
	icon_state = "turban"
	item_state = "that"
	cold_resistance = 15
	heat_resistance = 10

/obj/item/clothing/head/rastacap
	name = "rastafarian cap"
	desc = "Comes with pre-attached dreadlocks for that authentic look."
	icon_state = "rastacap"
	item_state = "that"

/obj/item/clothing/head/fedora
	name = "fedora"
	desc = "Tip your fedora to the fair maiden and win her heart. A foolproof plan."
	icon_state = "fdora"
	item_state = "fdora"

	New()
		..()
		src.name = "[pick("fancy", "suave", "manly", "sexerific", "sextacular", "intellectual", "majestic", "euphoric")] fedora"

/obj/item/clothing/head/fruithat
	name = "fruit basket hat"
	desc = "Where do these things even come from?"
	wear_image_icon = 'icons/mob/fruithat.dmi'
	icon_state = "fruithat"

/obj/item/clothing/head/cowboy
	name = "cowboy hat"
	desc = "Yeehaw!"
	icon_state = "cowboy"
	item_state = "cowboy"
	c_flags = SPACEWEAR

/obj/item/clothing/head/fancy/captain
	name = "captain's hat"
	icon_state = "captain-fancy"
	armor_value_melee = 3
	c_flags = SPACEWEAR

/obj/item/clothing/head/fancy/rank
	name = "hat"
	icon_state = "rank-fancy"
	armor_value_melee = 3
	c_flags = SPACEWEAR

/obj/item/clothing/head/wizard
	name = "blue wizard hat"
	desc = "A slightly crumply and foldy blue hat. Every self-respecting Wizard has one of these."
	icon_state = "wizard"
	item_state = "wizard"
	magical = 1

	handle_other_remove(var/mob/source, var/mob/living/carbon/human/target)
		. = ..()
		if (prob(75))
			source.show_message(text("<span style=\"color:red\">\The [src] writhes in your hands as though it is alive! It just barely wriggles out of your grip!</span>"), 1)
			. = 0

/obj/item/clothing/head/wizard/red
	name = "red wizard hat"
	desc = "An elegant red hat with some nice gold trim on it."
	icon_state = "wizardred"
	item_state = "wizardred"

/obj/item/clothing/head/wizard/purple
	name = "purple wizard hat"
	desc = "A very nice purple hat with a big, sassy buckle on it!"
	icon_state = "wizardpurple"
	item_state = "wizardpurple"

/obj/item/clothing/head/wizard/necro
	name = "necromancer hood"
	desc = "Good god, this thing STINKS. Is that mold on the inner lining? Ugh."
	icon_state = "wizardnec"
	item_state = "wizardnec"
	see_face = 0

/obj/item/clothing/head/paper_hat
	name = "Paper"
	desc = "A knit cap in white."
	icon_state = "paper"
	item_state = "lgloves"
	see_face = 1
	body_parts_covered = HEAD
