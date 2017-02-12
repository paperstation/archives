/*
CONTAINS:
SPACE CLEANER
MOP
SPONGES??
WET FLOOR SIGN

*/
/obj/item/spraybottle
	desc = "An unlabeled spray bottle."
	icon = 'icons/obj/janitor.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	name = "spray bottle"
	icon_state = "cleaner"
	item_state = "cleaner"
	flags = ONBELT|TABLEPASS|OPENCONTAINER|FPRINT|EXTRADELAY|SUPPRESSATTACK
	throwforce = 3
	w_class = 2.0
	throw_speed = 2
	throw_range = 10

/obj/item/spraybottle/New()
	var/datum/reagents/R = new/datum/reagents(100) // cogwerks - lowered from 1000 (what the hell) to 100
	reagents = R
	R.my_atom = src

/obj/item/spraybottle/detective
	name = "luminol bottle"
	desc = "A spray bottle labeled 'Luminol - Blood Detection Agent'. That's what those fancy detectives use to see blood!"

	New()
		var/datum/reagents/R = new/datum/reagents(100)
		reagents = R
		R.my_atom = src
		R.add_reagent("luminol", 100)
	examine()
		set src in usr
		boutput(usr, "[bicon(src)] [src.reagents.total_volume] units of luminol left!")
		..()
		return

/obj/item/spraybottle/cleaner/
	name = "cleaner bottle"
	desc = "A spray bottle labeled 'Poo-b-Gone Space Cleaner'."

	New()
		var/datum/reagents/R = new/datum/reagents(100)
		reagents = R
		R.my_atom = src
		R.add_reagent("cleaner", 100)

/obj/item/spraybottle/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	return

/obj/item/spraybottle/afterattack(atom/A as mob|obj, mob/user as mob)
	if (istype(A, /obj/item/storage))
		return
	if (!isturf(user.loc)) // Hi, I'm hiding in a closet like a wuss while spraying people with death chems risk-free.
		return
	if (src.reagents.total_volume < 1)
		boutput(user, "<span style=\"color:blue\">The spray bottle is empty!</span>")
		return

	var/obj/decal/D = new/obj/decal(get_turf(src))
	D.name = "chemicals"
	D.icon = 'icons/obj/chemical.dmi'
	D.icon_state = "chempuff"
	D.create_reagents(5) // cogwerks: lowered from 10 to 5
	src.reagents.trans_to(D, 5)
	playsound(src.loc, "sound/effects/zzzt.ogg", 50, 1, -6)
	var/log_reagents = log_reagents(src)
	var/travel_distance = max(min(get_dist(get_turf(src), A), 3), 1)
	spawn (0)
		for (var/i=0, i<travel_distance, i++)
			step_towards(D,A)
			var/turf/theTurf = get_turf(D)
			D.reagents.reaction(theTurf)
			D.reagents.remove_any(1)
			for (var/atom/T in theTurf)
				if (istype(T, /obj/overlay/tile_effect) || T.invisibility >= 100)
					continue
				D.reagents.reaction(T)
				if (ismob(T))
					logTheThing("combat", user, T, "'s spray hits %target% [log_reagents] at [log_loc(user)].")
				D.reagents.remove_any(1)
			if (!D.reagents.total_volume)
				break
			sleep(3)
		qdel(D)
	var/turf/logTurf = get_turf(D)
	logTheThing("combat", user, logTurf, "sprays [src] at %target% [log_reagents] at [log_loc(user)].")

	return

/obj/item/spraybottle/examine()
	set src in usr
	set category = "Local"
	..()
	boutput(usr, "<span style=\"color:blue\">It contains:</span>")
	if(!reagents) return
	if(reagents.reagent_list.len)
		for(var/datum/reagent/R in reagents.reagent_list)
			boutput(usr, "<span style=\"color:blue\">[R.volume] units of [R.name]</span>")
	else
		boutput(usr, "<span style=\"color:blue\">Nothing.</span>")

// MOP

/obj/item/mop
	desc = "The world of janitalia wouldn't be complete without a mop."
	name = "mop"
	icon = 'icons/obj/janitor.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	icon_state = "mop"
	var/mopping = 0
	var/mopcount = 0
	force = 3.0
	throwforce = 10.0
	throw_speed = 5
	throw_range = 10
	w_class = 3.0
	flags = FPRINT | TABLEPASS
	stamina_damage = 25
	stamina_cost = 15
	stamina_crit_chance = 10

/obj/item/mop/New()
	var/datum/reagents/R = new/datum/reagents(5)
	reagents = R
	R.my_atom = src

/obj/item/mop/examine()
	set src in view()
	set category = "Local"
	..()
	if(reagents && reagents.total_volume)
		boutput(usr, "<span style=\"color:blue\">[src] is wet!</span>")

/obj/item/mop/afterattack(atom/A, mob/user as mob)
	if (src.reagents.total_volume < 1 || mopcount >= 5)
		boutput(user, "<span style=\"color:blue\">Your mop is dry!</span>")
		return

	if (istype(A, /turf/simulated) || istype(A, /obj/decal/cleanable))
		user.visible_message("<span style=\"color:red\"><B>[user] begins to clean [A]</B></span>")
		var/turf/U = get_turf(A)

		if (do_after(user, 40))
			if (get_dist(A, user) > 1)
				user.show_text("You were interrupted.", "red")
				return
			user.show_text("You have finished mopping!", "blue")
			playsound(src.loc, "sound/effects/slosh.ogg", 25, 1)
			if (U && isturf(U))
				U.clean_forensic()
			else
				A.clean_forensic()
		else
			user.show_text("You were interrupted.", "red")
			return

		// Some people use mops for heat-delayed fireballs and stuff.
		// Mopping the floor with just water isn't of any interest, however (Convair880).
		if (src.reagents.total_volume && (!src.reagents.has_reagent("water") || (src.reagents.has_reagent("water") && src.reagents.reagent_list.len > 1)))
			logTheThing("combat", user, null, "mops [U && isturf(U) ? "[U]" : "[A]"] with chemicals [log_reagents(src)] at [log_loc(user)].")

		if (U && isturf(U))
			src.reagents.reaction(U,1,10)
			mopcount++

	if (mopcount >= 5) //Okay this stuff is an ugly hack and i feel bad about it.
		spawn (5)
			if (src && src.reagents)
				src.reagents.clear_reagents()
				mopcount = 0

	return

// SPONGES? idk

/obj/item/sponge
	name = "sponge"
	desc = "After careful analysis, you've come to the conclusion that the strange object is, in fact, a sponge."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "sponge"
	item_state = "sponge"
	force = 0
	throwforce = 0

	var/hit_face_prob = 30 // MODULAR SPONGES
	var/spam_flag = 0 // people spammed snapping their fucking fingers, so this is probably necessary

/obj/item/sponge/New()
	var/datum/reagents/R = new/datum/reagents(10)
	reagents = R
	R.my_atom = src

/obj/item/sponge/examine()
	set src in view()
	set category = "Local"
	..()
	if(reagents && reagents.total_volume)
		boutput(usr, "<span style=\"color:blue\">The sponge is wet!</span>")

/obj/item/sponge/attack_self(mob/user as mob)
	if(spam_flag)
		return
	var/turf/location = get_turf(user)
	user.visible_message("<span style=\"color:blue\">[user] wrings [src] out.</span>")
	if(location)
		src.reagents.reaction(location,1,1)
	spawn(1) // to make sure the reagents actually react before they're cleared
	src.reagents.clear_reagents()
	spam_flag = 1
	spawn(10)
	spam_flag = 0

/obj/item/sponge/throw_impact(atom/hit)
	if(hit && ishuman(hit))
		if(prob(hit_face_prob))
			var/mob/living/carbon/human/DUDE = hit
			hit.visible_message("<span style=\"color:red\"><b>[src] hits [DUDE] squarely in the face!</b></span>")
			playsound(DUDE.loc, "sound/effects/splat.ogg", 50, 1)
			if(DUDE.wear_mask || (DUDE.head && DUDE.head.c_flags & COVERSEYES))
				boutput(DUDE, "<span style=\"color:red\">Your headgear protects you! PHEW!!!</span>")
				spawn(1) src.reagents.clear_reagents()
				return
			src.reagents.reaction(DUDE, TOUCH)
			src.reagents.trans_to(DUDE, reagents.total_volume)
			spawn(1) src.reagents.clear_reagents()
	..()

/obj/item/sponge/afterattack(atom/target, mob/user as mob)
	if(istype (target, /obj/item/reagent_containers/food/drinks) || istype (target, /obj/machinery/bathtub) && src.reagents.total_volume) // dump reagents to these things
		user.visible_message("<span style=\"color:red\">[user] wrings [src] out into [target].</span>")
		src.reagents.trans_to(target, 10)
		return

	else if(istype (target, /obj/item/reagent_containers/glass/bucket) && src.reagents.total_volume) // popup "dry/wet" interactions with these
		user.visible_message("<span style=\"color:red\">[user] wrings [src] out into [target].</span>")
		src.reagents.trans_to(target, 10)
		return

	else if(istype (target, /turf/simulated))
		var/turf/simulated/T = target
		if(src.reagents.total_volume == src.reagents.maximum_volume)
			boutput(user, "<span style=\"color:red\">You can't soak anything else up!</span>")
			return
		if(T.reagents)
			boutput(user, "<span style=\"color:blue\">You soak up the mess from [T].</span>")
			T.reagents.trans_to(src, 10)
		if(T.wet)
			boutput(user, "<span style=\"color:blue\">You dry [T] up with [src].</span>")
			src.reagents.add_reagent("water", 10)
			T.wet = 0
		return

	else if(istype (target, /obj/decal/cleanable))
		var/turf/T = get_turf(target)
		if(src.reagents.total_volume)
			T.clean_forensic()

	else
		..()

/obj/item/caution
	desc = "Caution! Wet Floor!"
	name = "wet floor sign"
	icon = 'icons/obj/janitor.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	icon_state = "caution"
	force = 1.0
	throwforce = 3.0
	throw_speed = 1
	throw_range = 5
	w_class = 3.0
	flags = FPRINT | TABLEPASS
	stamina_damage = 15
	stamina_cost = 15
	stamina_crit_chance = 10