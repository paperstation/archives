
/* ================================================= */
/* -------------------- Bottles -------------------- */
/* ================================================= */

/obj/item/reagent_containers/glass/bottle
	name = "bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle1"
	item_state = "atoxinbottle"
	initial_volume = 30
	var/image/fluid_image
	var/bottle_style = null
	rc_flags = RC_FULLNESS | RC_VISIBLE | RC_SPECTRO
	amount_per_transfer_from_this = 10
	flags = FPRINT | TABLEPASS | OPENCONTAINER | SUPPRESSATTACK
	module_research = list("science" = 0.5, "medicine" = 0.5)
	module_research_type = /obj/item/reagent_containers/glass/bottle

	New()
		..()
		if (!bottle_style)
			bottle_style = "[rand(1,4)]"
		fluid_image = image('icons/obj/chemical.dmi', "bottle[bottle_style]-fluid")

	on_reagent_change()
		if (!(src.icon_state in list("bottle1", "bottle2", "bottle3", "bottle4")))
			return
		src.underlays = null
		icon_state = "bottle[bottle_style]"
		if (reagents.total_volume >= 0)
			var/datum/color/average = reagents.get_average_color()
			fluid_image.color = average.to_rgba()
			src.underlays += src.fluid_image

/* =================================================== */
/* -------------------- Sub-Types -------------------- */
/* =================================================== */

/obj/item/reagent_containers/glass/bottle/epinephrine
	name = "epinephrine bottle"
	desc = "A small bottle. Contains epinephrine - used to stabilize patients."
	bottle_style = "1"
	amount_per_transfer_from_this = 10

	New()
		..()
		reagents.add_reagent("epinephrine", 30)

/obj/item/reagent_containers/glass/bottle/toxin
	name = "toxin bottle"
	desc = "A small bottle containing toxic compounds."
	bottle_style = "2"
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("toxin", 30)

/obj/item/reagent_containers/glass/bottle/atropine
	name = "atropine bottle"
	desc = "A small bottle containing atropine, used for cardiac emergencies."
	bottle_style = "2"
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("atropine", 30)

/obj/item/reagent_containers/glass/bottle/saline
	name = "saline-glucose bottle"
	desc = "A small bottle containing saline-glucose solution."
	bottle_style = "2"
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("saline", 30)

/obj/item/reagent_containers/glass/bottle/aspirin
	name = "salicylic acid bottle"
	desc = "A small bottle containing medicine for pain and fevers."
	bottle_style = "2"
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("salicylic_acid", 30)

/// cogwerks - adding some new bottles for traitor medics
// haine - I added beedril/royal beedril to these, and my heart-related disease reagents. yolo (remove these if they're a dumb idea, idk)
/obj/item/reagent_containers/glass/bottle/poison
	name = "poison bottle"
	desc = "There is a little skull and crossbones on the label. Yikes."
	initial_volume = 40
	amount_per_transfer_from_this = 5

	New()
		..()
		var/poison = pick_string("chemistry_tools.txt", "traitor_poison_bottle")
		reagents.add_reagent(poison, 40)
		logTheThing("debug", src, null, "poison bottle spawned from string [poison], contains: [log_reagents(src)]")

/obj/item/reagent_containers/glass/bottle/morphine
	name = "morphine bottle"
	desc = "A small bottle of morphine, a powerful painkiller."
	bottle_style = "4"
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("morphine", 30)

//the good medicines

/obj/item/reagent_containers/glass/bottle/pfd
	name = "perfluorodecalin bottle"
	desc = "A small bottle of an experimental liquid-breathing medicine."
	bottle_style = "4"
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("perfluorodecalin", 30)

/obj/item/reagent_containers/glass/bottle/omnizine
	name = "omnizine bottle"
	desc = "A small bottle of an experimental and expensive herbal compound."
	bottle_style = "4"
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("omnizine", 30)

/obj/item/reagent_containers/glass/bottle/ether
	name = "ether bottle"
	desc = "A small bottle of an ether, a strong but highly addictive anesthetic and sedative."
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("ether", 30)

/obj/item/reagent_containers/glass/bottle/haloperidol
	name = "haloperidol bottle"
	desc = "A small bottle of haloperidol, a powerful anti-psychotic."
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("haloperidol", 30)

/obj/item/reagent_containers/glass/bottle/pentetic
	name = "pentetic acid bottle"
	desc = "A small bottle of pentetic acid, an experimental and aggressive chelation agent."
	bottle_style = "4"
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("penteticacid", 30)

//////

/obj/item/reagent_containers/glass/bottle/sulfonal
	name = "sulfonal bottle"
	desc = "A small bottle."
	bottle_style = "4"
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("sulfonal", 30)

/obj/item/reagent_containers/glass/bottle/pancuronium
	name = "pancuronium bottle"
	desc = "A small bottle."
	bottle_style = "1"
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("pancuronium", 30)

/obj/item/reagent_containers/glass/bottle/antitoxin
	name = "anti-toxin bottle"
	desc = "A small bottle."
	bottle_style = "3"
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("charcoal", 30)

/obj/item/reagent_containers/glass/bottle/antihistamine
	name = "antihistamine bottle"
	desc = "A small bottle of allergy medication."
	bottle_style = "1"
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("antihistamine", 30)

/obj/item/reagent_containers/glass/bottle/eyedrops
	name = "oculine bottle"
	desc = "A small bottle of combined eye and ear medication."
	bottle_style = "1"
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("oculine", 30)

/obj/item/reagent_containers/glass/bottle/antirad
	name = "anti-radiation bottle"
	desc = "A small bottle of potassium iodide."
	bottle_style = "3"
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("anti_rad", 30)

/obj/item/reagent_containers/glass/bottle/pacid
	name = "fluorosulfuric acid bottle"
	desc = "A small bottle."
	bottle_style = "2"
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("pacid", 30)

/obj/item/reagent_containers/glass/bottle/fluorosurfactant
	name = "fluorosurfactant bottle"
	desc = "A small bottle."
	bottle_style = "1"
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("fluorosurfactant", 30)

/* ========================================================= */
/* -------------------- Chem Precursors -------------------- */
/* ========================================================= */

/obj/item/reagent_containers/glass/bottle/oil
	name = "oil bottle"
	desc = "A reagent storage bottle."
	icon_state = "reagent_bottle"
	initial_volume = 50
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("oil", 50)

/obj/item/reagent_containers/glass/bottle/phenol
	name = "phenol bottle"
	desc = "A reagent storage bottle."
	icon_state = "reagent_bottle"
	initial_volume = 50
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("phenol", 50)

/obj/item/reagent_containers/glass/bottle/acetone
	name = "acetone bottle"
	desc = "A reagent storage bottle."
	icon_state = "reagent_bottle"
	initial_volume = 50
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("acetone", 50)

	large
		desc = "A large bottle."
		initial_volume = 100
		icon_state = "largebottle"
		New()
			..()
			reagents.add_reagent("acetone", 50)

	janitors
		desc = "A generic unbranded metallic container for acetone."
		initial_volume = 100
		icon_state = "acetone"
		New()
			..()
			reagents.add_reagent("acetone", 50)

/obj/item/reagent_containers/glass/bottle/ammonia
	name = "ammonia bottle"
	desc = "A reagent storage bottle."
	icon_state = "reagent_bottle"
	initial_volume = 50
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("ammonia", 50)

	large
		desc = "A large bottle."
		initial_volume = 100
		icon_state = "largebottle"
		New()
			..()
			reagents.add_reagent("ammonia", 50)

	janitors
		desc = "A generic unbranded bottle of ammonia."
		initial_volume = 100
		icon_state = "bleach" // heh

		New()
			..()
			reagents.add_reagent("ammonia", 50)

/obj/item/reagent_containers/glass/bottle/diethylamine
	name = "diethylamine bottle"
	desc = "A reagent storage bottle."
	icon_state = "reagent_bottle"
	initial_volume = 50
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("diethylamine", 50)

/obj/item/reagent_containers/glass/bottle/acid
	name = "acid bottle"
	desc = "A reagent storage bottle."
	icon_state = "reagent_bottle"
	initial_volume = 50
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("acid", 50)

	large
		desc = "A large bottle."
		initial_volume = 100
		icon_state = "largebottle"

		New()
			..()
			reagents.add_reagent("acid", 50)

/obj/item/reagent_containers/glass/bottle/formaldehyde
	name = "embalming fluid bottle"
	desc = "A reagent storage bottle."
	icon_state = "reagent_bottle"
	initial_volume = 50
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("formaldehyde", 50)

/* ============================================== */
/* -------------------- Misc -------------------- */
/* ============================================== */

/obj/item/reagent_containers/glass/bottle/bubblebath
	name = "Cap'n Bubs(TM) Extra-Manly Bubble Bath"
	desc = "Industrial strength bubblebath with a fat and sassy mascot on the bottle. Neat."
	icon = 'icons/obj/drink.dmi'
	icon_state = "moonshine"
	initial_volume = 50
	amount_per_transfer_from_this = 5
	rc_flags = RC_FULLNESS

	New()
		..()
		reagents.add_reagent("fluorosurfactant", 30)
		reagents.add_reagent("pepperoni", 10)
		reagents.add_reagent("bourbon", 10)

/obj/item/reagent_containers/glass/bottle/icing
	name = "icing tube"
	desc = "Used to put icing on cakes."
	icon = 'icons/obj/food.dmi'
	icon_state = "icing_tube"
	initial_volume = 50
	amount_per_transfer_from_this = 5
	rc_flags = RC_FULLNESS

/obj/item/reagent_containers/glass/bottle/holywater
	name = "Holy Water"
	desc = "A small bottle filled with blessed water."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "holy_water"
	amount_per_transfer_from_this = 10

	New()
		..()
		var/datum/reagents/R = new/datum/reagents(30)
		reagents = R
		R.my_atom = src
		R.add_reagent("water_holy", 30)

/obj/item/reagent_containers/glass/bottle/cleaner
	name = "cleaner bottle"
	desc = "A bottle filled with cleaning fluid."
	icon_state = "largebottle-labeled"
	initial_volume = 50
	amount_per_transfer_from_this = 10

	New()
		..()
		reagents.add_reagent("cleaner", 50)
