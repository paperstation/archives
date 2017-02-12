/obj/mopbucket
	desc = "Fill it with water, but don't forget a mop!"
	name = "mop bucket"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "mopbucket"
	density = 1
	flags = FPRINT
	pressure_resistance = ONE_ATMOSPHERE
	flags = FPRINT | TABLEPASS | OPENCONTAINER

/obj/mopbucket/New()
	var/datum/reagents/R = new/datum/reagents(50)
	reagents = R
	R.my_atom = src

/obj/mopbucket/get_desc(dist)
	if (dist > 1)
		return
	if (!reagents)
		return
	. = "<br><span style=\"color:blue\">It contains:</span>"
	if(reagents.reagent_list.len)
		for(var/current_id in reagents.reagent_list)
			var/datum/reagent/current_reagent = reagents.reagent_list[current_id]
			. += "<br><span style=\"color:blue\">[current_reagent.volume] units of [current_reagent.name]</span>"
	else
		. += "<br><span style=\"color:blue\">Nothing. The answer is nothing.</span>"

/obj/mopbucket/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/mop))
		if (src.reagents.total_volume >= 2)
			src.reagents.trans_to(W, 2)
			boutput(user, "<span style=\"color:blue\">You wet the mop</span>")
			playsound(src.loc, "sound/effects/slosh.ogg", 25, 1)
		if (src.reagents.total_volume < 1)
			boutput(user, "<span style=\"color:blue\">Out of water!</span>")
	else
		return ..()

/obj/mopbucket/MouseDrop(atom/over_object as obj)
	if (!istype(over_object, /obj/item/reagent_containers/glass) && !istype(over_object, /obj/item/reagent_containers/food/drinks) && !istype(over_object, /obj/item/spraybottle) && !istype(over_object, /obj/machinery/plantpot) && !istype(over_object, /obj/mopbucket))
		return ..()

	if (get_dist(usr, src) > 1 || get_dist(usr, over_object) > 1)
		boutput(usr, "<span style=\"color:red\">That's too far!</span>")
		return

	src.transfer_all_reagents(over_object, usr)

/obj/mopbucket/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
	if (!in_range(user, src) || user.restrained() || user.paralysis || user.sleeping || user.stat || user.lying)
		return

	if (O == user)
		//check to see if the user is trying to go through walls, etc.
		var/turf/T = get_turf(src)
		var/no_go = 0
		if (T.density)
			no_go = T //can''t pass through walls
		else
			for (var/obj/thingy in T)
				if (thingy == src)
					continue
				if (thingy.density) //can't pass through dense objects
					no_go = thingy
					break
		if (no_go)
			user.visible_message("<span style=\"color:red\"><b>[user]</b> scoots around [src], right into [no_go]!</span>",\
			"<span style=\"color:red\">You scoot around [src], right into [no_go]!</span>")
			user.weakened += 4
			if (prob(25))
				user.show_text("You hit your head on [no_go]!", "red")
				user.TakeDamage("head", 0, 10)
			return

		if (iscarbon(O))
			var/mob/living/carbon/M = user
			if (M.bioHolder && M.bioHolder.HasEffect("clumsy") && prob(40))
				user.visible_message("<span style=\"color:red\"><b>[user]</b> trips over [src]!</span>",\
				"<span style=\"color:red\">You trip over [src]!</span>")
				playsound(user.loc, 'sound/weapons/genhit2.ogg', 15, 1, -3)
				user.set_loc(src.loc)
				user.weakened += 10
				return
			else
				user.show_text("You scoot around [src].")
				user.set_loc(src.loc)
				return

		if (issilicon(O))
			user.show_text("You scoot around [src].")
			user.set_loc(src.loc)
			return


/obj/mopbucket/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				qdel(src)
				return
