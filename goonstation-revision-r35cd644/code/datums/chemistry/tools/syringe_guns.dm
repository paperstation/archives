
/* ============================================= */
/* -------------------- Gun -------------------- */
/* ============================================= */

/obj/item/gun/syringe
	name = "syringe gun"
	icon = 'icons/obj/gun.dmi'
	icon_state = "syringegun"
	item_state = "syringegun"
	w_class = 3.0
	throw_speed = 2
	throw_range = 10
	force = 4.0
	current_projectile = new/datum/projectile/syringe
	m_amt = 2000
	contraband = 3
	add_residue = 1 // Does this gun add gunshot residue when fired? These syringes are probably propelled by CO2 or something, but whatever (Convair880).

	canshoot()
		if (reagents.total_volume >= 15)
			return 1
		return 0

	process_ammo(var/mob/user)
		if (!canshoot())
			boutput(user, "<span style=\"color:red\">The syringe gun's internal reservoir does not contain enough reagents to fire it!</span>")
			return 0
		return 1

	New()
		..()
		var/datum/reagents/R = new/datum/reagents(90)
		reagents = R
		R.my_atom = src

	get_desc(dist)
		if (dist > 2)
			return
		. = "<br>[round(reagents.total_volume/15)] / [round(reagents.maximum_volume/15)] shots available.<br><span style=\"color:blue\">The internal reservoir contains:</span>"
		if (src.reagents.reagent_list.len)
			for (var/current_id in src.reagents.reagent_list)
				var/datum/reagent/current_reagent = src.reagents.reagent_list[current_id]
				. += "<br><span style=\"color:blue\">&emsp; [current_reagent.volume] units of [current_reagent.name]</span>"
		else
			. += "<br><span style=\"color:blue\">&emsp; Nothing</span>"


	attackby(obj/item/I as obj, mob/user as mob)
		if (istype(I, /obj/item/reagent_containers/glass))
			return

		return ..()

	is_open_container()
		return 1

	verb/empty_out()
		set name = "Drain contents"
		set desc = "Dump out all loaded reagents."

		set src in usr

		if (!reagents)
			boutput(usr, "<span style=\"color:red\">The little cap on the fluid container is stuck. Uh oh.</span>")
			return

		if (reagents.total_volume)
			reagents.clear_reagents()
			boutput(usr, "You dump out the [src.name]'s stored reagents.")
		else
			boutput(usr, "<span style=\"color:red\">There's nothing loaded to drain!</span>")

	alter_projectile(var/obj/projectile/P)
		if (!P.reagents)
			P.reagents = new /datum/reagents(15)
			P.reagents.my_atom = P
		src.reagents.trans_to(P, 15)

/* ==================================================== */
/* -------------------- Projectile -------------------- */
/* ==================================================== */

/datum/projectile/syringe
	name = "syringe"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "syringeproj"
	dissipation_rate = 1
	dissipation_delay = 7
	power = 1
	hit_ground_chance = 10
	ks_ratio = 1.0
	shot_sound = 'sound/effects/syringeproj.ogg'

	on_hit(atom/hit, angle, var/obj/projectile/O)
		if (ismob(hit))
			if (O.reagents && hit.reagents)
				O.reagents.trans_to(hit, 15)
				O.reagents.clear_reagents()
