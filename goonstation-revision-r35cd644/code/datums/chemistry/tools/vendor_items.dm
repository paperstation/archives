
/* ======================================================= */
/* -------------------- Vendor Parent -------------------- */
/* ======================================================= */

/obj/item/reagent_containers/vending
	name = "chem vendor item"
	desc = "A generic parent item for the chemical vendor chem containers. You really shouldn't be able to see this thing!"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "vendvial"
	flags = FPRINT | TABLEPASS | OPENCONTAINER
	initial_volume = 5
	amount_per_transfer_from_this = 5
	var/image/fluid_image
	rc_flags = RC_FULLNESS | RC_VISIBLE

/* ============================================== */
/* -------------------- Vial -------------------- */
/* ============================================== */

/obj/item/reagent_containers/vending/vial
	name = "small vial"
	desc = "A little vial. Can hold up to 5 units."
	icon_state = "minivial"
	rc_flags = RC_VISIBLE | RC_SPECTRO

	New()
		..()
		fluid_image = image('icons/obj/chemical.dmi', "minivial-fluid")

	on_reagent_change()
		update_icon()

	proc/update_icon()
		src.underlays = null
		if (src.reagents.total_volume == 0)
			icon_state = "minivial"
		if (src.reagents.total_volume > 0)
			icon_state = "minivial1"
			var/datum/color/average = reagents.get_average_color()
			fluid_image.color = average.to_rgba()
			src.underlays += src.fluid_image
		return

	ex_act(severity)
		src.smash()

	proc/smash(var/turf/T)
		if (!T)
			T = src.loc
		src.reagents.reaction(T)
		if (ismob(T)) // we've reacted with whatever we've hit, but if what we hit is a mob, let's not stick glass in their contents
			T = get_turf(T)
		T.visible_message("<span style=\"color:red\">[src] shatters!</span>")
		playsound(T, pick('sound/effects/Glassbr1.ogg','sound/effects/Glassbr2.ogg','sound/effects/Glassbr3.ogg'), 100, 1)
		new /obj/item/raw_material/shard/glass(T)
		qdel(src)

	throw_impact(var/turf/T)
		..()
		src.smash(T)

/* ============================================= */
/* -------------------- Bag -------------------- */
/* ============================================= */

/obj/item/reagent_containers/vending/bag
	name = "small bag"
	desc = "A little bag. Can hold up to 5 units."
	icon_state = "vendbag"

	New()
		..()
		fluid_image = image('icons/obj/chemical.dmi', "vendbag-fluid")

	on_reagent_change()
		update_icon()

	proc/update_icon()
		src.underlays = null
		if (src.reagents.total_volume == 0)
			icon_state = "vendbag"
		if (src.reagents.total_volume > 0)
			icon_state = "vendbag1"
			var/datum/color/average = reagents.get_average_color()
			fluid_image.color = average.to_rgba()
			src.underlays += src.fluid_image
		return

	ex_act(severity)
		src.smash()

	proc/smash(var/turf/T)
		if (!T)
			T = src.loc
		src.reagents.reaction(T)
		if (ismob(T))
			T = get_turf(T)
		T.visible_message("<span style=\"color:red\">[src] bursts!</span>")
		playsound(T, 'sound/effects/splat.ogg', 100, 1)
		qdel(src)

	throw_impact(var/turf/T)
		..()
		src.smash(T)

/* =================================================== */
/* -------------------- Sub-Types -------------------- */
/* =================================================== */

/obj/item/reagent_containers/vending/bag/larger
	name = "bag"
	desc = "A bag. Can hold up to 50 units."
	initial_volume = 50

/obj/item/reagent_containers/vending/bag/random
	New()
		var/chem = null
		if (all_functional_reagent_ids.len > 1)
			chem = pick(all_functional_reagent_ids)
		else
			chem = "water"
		..()
		src.reagents.add_reagent(chem, 5)
		src.update_icon()


/obj/item/reagent_containers/vending/vial/random
	New()
		var/chem = null
		if (all_functional_reagent_ids.len > 1)
			chem = pick(all_functional_reagent_ids)
		else
			chem = "water"
		..()
		src.reagents.add_reagent(chem, 5)
		src.update_icon()
