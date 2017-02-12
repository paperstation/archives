// Foam
// Similar to smoke, but spreads out more
// metal foams leave behind a foamed metal wall

/obj/effects/foam
	name = "foam"
	icon_state = "foam"
	opacity = 0
	anchored = 1
	density = 0
	layer = OBJ_LAYER + 0.9
	mouse_opacity = 0
	var/foamcolor
	var/amount = 3
	var/expand = 1
	animate_movement = 0
	var/metal = 0

/*
/obj/effects/foam/New(loc, var/ismetal=0)
	..(loc)

*/

/obj/effects/foam/pooled()
	..()
	name = "foam"
	icon_state = "foam"
	opacity = 0
	foamcolor = null
	expand = 0
	amount = 0
	metal = 0
	animate_movement = 0
	if(reagents)
		reagents.clear_reagents()

/obj/effects/foam/unpooled()
	..()
	amount = 3
	expand = 1

/obj/effects/foam/proc/set_up(loc, var/ismetal)
	src.set_loc(loc)
	expand = 1
	if(ismetal == 1)
		icon_state = "mfoam"
	else
		icon_state = "foam"
		if(reagents)
			src.overlays.len = 0
			icon_state = "foam"
			src.foamcolor = src.reagents.get_master_color()
			var/icon/I = new /icon('icons/effects/effects.dmi',"foam_overlay")
			I.Blend(src.foamcolor, ICON_ADD)
			src.overlays += I
	metal = ismetal
	playsound(src, "sound/effects/bubbles2.ogg", 80, 1, -3)

	spawn(3 + metal*3)
		process()
	spawn(120)
		expand = 0 // stop expanding
		sleep(30)

		if(metal)
			var/obj/foamedmetal/M = new(src.loc)
			M.metal = metal
			M.updateicon()

		if(metal)
			flick("mfoam-disolve", src)
		else
			flick("foam-disolve", src)
		sleep(5)
		die()
	return

// on delete, transfer any reagents to the floor & surrounding tiles
/obj/effects/foam/proc/die()
	expand = 0
	if(!metal && reagents)
		reagents.handle_reactions()
		for(var/atom/A in oview(1,src))
			if(A == src)
				continue
			if(istype(A,/mob/living))
				var/mob/living/L = A
				logTheThing("combat", L, null, "is hit by chemical foam [log_reagents(src)] at [log_loc(src)].")
			reagents.reaction(A, TOUCH, 5)
	pool(src)

/obj/effects/foam/proc/process()
	if(--amount < 0)
		return


	while(expand)	// keep trying to expand while true

		for(var/direction in cardinal)
			var/turf/T = get_step(src,direction)
			if(!T)
				continue

			if(!T.Enter(src))
				continue

			//if(istype(T, /turf/space))
			//	continue

			var/obj/effects/foam/F = locate() in T
			if(F)
				continue

			F = unpool(/obj/effects/foam)
			F.set_up(T, metal)
			F.amount = amount
			if(!metal)
				F.overlays.len = 0
				F.create_reagents(15)

				//This very slight tweak is to make it so some reactions that require different ratios
				//can still work in foam.
				for(var/reagent_id in src.reagents.reagent_list)
					var/datum/reagent/current_reagent = src.reagents.reagent_list[reagent_id]
					if(current_reagent)
						F.reagents.add_reagent(reagent_id,min(current_reagent.volume, 3), current_reagent.data, src.reagents.total_temperature)

				F.icon_state = "foam"
				F.foamcolor = src.reagents.get_master_color()
				var/icon/I = new /icon('icons/effects/effects.dmi',"foam_overlay")
				I.Blend(F.foamcolor, ICON_ADD)
				F.overlays += I

		sleep(15)

// foam disolves when heated
// except metal foams
/obj/effects/foam/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(!metal && prob(max(0, exposed_temperature - 475)))
		flick("foam-disolve", src)

		spawn(5)
			die()
			expand = 0


/obj/effects/foam/HasEntered(var/atom/movable/AM)
	if (metal)
		return

	if (ishuman(AM))
		var/mob/living/carbon/human/M = AM
		if (!M.can_slip())
			return

		for(var/reagent_id in src.reagents.reagent_list)
			var/amount = M.reagents.get_reagent_amount(reagent_id)
			if(amount < 25)
				M.reagents.add_reagent(reagent_id, min(round(amount / 2),15))
		logTheThing("combat", M, null, "is hit by chemical foam [log_reagents(src)] at [log_loc(src)].")
		reagents.reaction(M, TOUCH, 5)

		if(!istype(src.loc, /turf/space))
			M.pulling = null
			M.show_text("You slip on the foam!", "red")
			playsound(src.loc, "sound/misc/slip.ogg", 50, 1, -3)
			M.stunned = 2
			M.weakened = 2