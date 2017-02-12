
/* ================================================= */
/* -------------------- Beakers -------------------- */
/* ================================================= */

/obj/item/reagent_containers/glass/beaker
	name = "beaker"
	desc = "A beaker. Can hold up to 50 units."
	icon = 'icons/obj/chemical.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_medical.dmi'
	icon_state = "beaker"
	item_state = "beaker"
	initial_volume = 50
	module_research = list("science" = 2, "medicine" = 2)
	module_research_type = /obj/item/reagent_containers/glass/beaker
	var/image/fluid_image
	var/icon_style = "beaker"
	rc_flags = RC_SCALE | RC_VISIBLE | RC_SPECTRO

	New()
		..()
		fluid_image = image(src.icon, "fluid-[src.icon_style]")

	on_reagent_change()
		src.update_icon()

	proc/update_icon()
		src.underlays = null
		if (reagents.total_volume)
			icon_state = "[src.icon_style]1"
			var/datum/color/average = reagents.get_average_color()
			fluid_image.color = average.to_rgba()
			src.underlays += src.fluid_image
		else
			icon_state = src.icon_style

		if (istype(src.master,/obj/item/assembly))
			var/obj/item/assembly/A = src.master
			A.c_state(1)

	attackby(obj/A as obj, mob/user as mob)
		if (istype(A, /obj/item/assembly/time_ignite) && !(A:status))
			var/obj/item/assembly/time_ignite/W = A
			if (!W.part3)
				W.part3 = src
				src.master = W
				src.layer = initial(src.layer)
				user.u_equip(src)
				src.set_loc(W)
				W.c_state(0)

				boutput(user, "You attach [W.name] to [src].")
			else
				boutput(user, "You must remove [W.part3] from the assembly before transferring chemicals to it!")
			return

		if (istype(A, /obj/item/assembly/prox_ignite) && !(A:status))
			var/obj/item/assembly/prox_ignite/W = A
			if (!W.part3)
				W.part3 = src
				src.master = W
				src.layer = initial(src.layer)
				user.u_equip(src)
				src.set_loc(W)
				W.c_state(0)

				boutput(user, "You attach [W.name] to [src].")
			else boutput(user, "You must remove [W.part3] from the assembly before transferring chemicals to it!")
			return

		if (istype(A, /obj/item/assembly/rad_ignite) && !(A:status))
			var/obj/item/assembly/rad_ignite/W = A
			if (!W.part3)
				W.part3 = src
				src.master = W
				src.layer = initial(src.layer)
				user.u_equip(src)
				src.set_loc(W)
				W.c_state(0)

				boutput(user, "You attach [W.name] to [src].")
			else boutput(user, "You must remove [W.part3] from the assembly before transferring chemicals to it!")
			return

		..(A, user)

/* =================================================== */
/* -------------------- Sub-Types -------------------- */
/* =================================================== */

/obj/item/reagent_containers/glass/beaker/cryoxadone
	name = "beaker (cryoxadone)"
	New()
		..()
		reagents.add_reagent("cryoxadone", 50)

/obj/item/reagent_containers/glass/beaker/epinephrine
	name = "beaker (epinephrine)"
	New()
		..()
		reagents.add_reagent("epinephrine", 50)

/obj/item/reagent_containers/glass/beaker/antitox
	name = "beaker (anti-toxin)"
	New()
		..()
		reagents.add_reagent("charcoal", 50)

/obj/item/reagent_containers/glass/beaker/brute
	name = "beaker (styptic powder)"
	New()
		..()
		reagents.add_reagent("stypic_powder", 50)

/obj/item/reagent_containers/glass/beaker/burn
	name = "beaker (silver sulfadiazine)"
	New()
		..()
		reagents.add_reagent("silver_sulfadiazine", 50)

/* ======================================================= */
/* -------------------- Large Beakers -------------------- */
/* ======================================================= */

/obj/item/reagent_containers/glass/beaker/large
	name = "large beaker"
	desc = "A large beaker. Can hold up to 100 units."
	icon_state = "beakerlarge"
	initial_volume = 100
	icon_style = "beakerlarge"

/* =================================================== */
/* -------------------- Sub-Types -------------------- */
/* =================================================== */

/obj/item/reagent_containers/glass/beaker/large/epinephrine
	name = "epinephrine reserve tank"
	New()
		..()
		reagents.add_reagent("epinephrine", 100)

/obj/item/reagent_containers/glass/beaker/large/antitox
	name = "anti-toxin reserve tank"
	New()
		..()
		reagents.add_reagent("charcoal", 100)

/obj/item/reagent_containers/glass/beaker/large/brute
	name = "styptic powder reserve tank"
	New()
		..()
		reagents.add_reagent("stypic_powder", 100)

/obj/item/reagent_containers/glass/beaker/large/burn
	name = "silver sulfadiazine reserve tank"
	New()
		..()
		reagents.add_reagent("silver_sulfadiazine", 100)

/obj/item/reagent_containers/glass/beaker/large/happy_plant //I have to test too many fucking plant-related issues atm so I'm adding this just to make my life less annoying
	name = "Happy Plant Mixture"
	desc = "160 units of things that make plants grow happy!"
	amount_per_transfer_from_this = 40
	initial_volume = 160

	New()
		..()
		reagents.add_reagent("saltpetre", 40)
		reagents.add_reagent("ammonia", 40)
		reagents.add_reagent("potash", 40)
		reagents.add_reagent("poo", 40)

/* ================================================================= */
/* -------------------- Reagent Extractor Tanks -------------------- */
/* ================================================================= */

/obj/item/reagent_containers/glass/beaker/extractor_tank
	name = "reagent extractor tank"
	desc = "A large tank used in the reagent extractors. You probably shouldn't be able to see this!"
	initial_volume = 500
