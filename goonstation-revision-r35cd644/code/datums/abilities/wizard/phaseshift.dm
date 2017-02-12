/datum/targetable/spell/phaseshift
	name = "Phase Shift"
	desc = "Become incorporeal and move through walls."
	icon_state = "phaseshift"
	targeted = 0
	cooldown = 300
	requires_robes = 1
	cooldown_staff = 1
	restricted_area_check = 1

	cast()
		if(!holder)
			return
		if (spell_invisibility(holder.owner, 1, 0, 1, 1) != 1) // Dry run. Can we phaseshift?
			return 1

		holder.owner.say("PHEE CABUE")
		playsound(holder.owner.loc, "sound/voice/wizard/MistFormLoud.ogg", 50, 0, -1)
		var/SPtime = 35
		if(holder.owner.wizard_spellpower())
			SPtime = 50
		else
			boutput(holder.owner, "<span style=\"color:red\">Your spell doesn't last as long without a staff to focus it!</span>")
		playsound(holder.owner.loc, "sound/effects/mag_phase.ogg", 25, 1, -1)
		spell_invisibility(holder.owner, SPtime, 0, 1)

// Merged some stuff from wizard and vampire phaseshift for easy of use (Convair880).
/proc/spell_invisibility(var/mob/H, var/time, var/check_for_watchers = 0, var/stop_burning = 0, var/dry_run_only = 0)
	if (!H || !ismob(H))
		return
	if (!isturf(H.loc))
		H.show_text("You can't seem to turn incorporeal here.", "red")
		return
	if (H.stat || H.paralysis > 0)
		H.show_text("You can't turn incorporeal when you are incapacitated.", "red")
		return

	var/turf/T = get_turf(H)
	if (T && isrestrictedz(T.z))
		H.show_text("You can't seem to turn incorporeal here.", "red")
		return

	if (check_for_watchers == 1)
		if (H.client)
			for (var/mob/living/L in view(H.client.view, H))
				if (L.stat == 0 && L.sight_check(1) && L.ckey != H.ckey)
					H.show_text("You can only use that when nobody can see you!", "red")
					return

	if (dry_run_only)
		return 1 // Return 1 if we got this far in the test run.

	if (stop_burning == 1)
		var/mob/living/carbon/human/HH = H
		if (istype(HH) && HH.burning)
			boutput(HH, "<span style=\"color:blue\">The flames sputter out as you phase shift.</span>")
			HH.set_burning(0)

	spawn(0)
		var/mobloc = get_turf(H.loc)
		var/obj/dummy/spell_invis/holder = new /obj/dummy/spell_invis( mobloc )
		var/atom/movable/overlay/animation = new /atom/movable/overlay( mobloc )
		animation.name = "water"
		animation.density = 0
		animation.anchored = 1
		animation.icon = 'icons/mob/mob.dmi'
		animation.icon_state = "liquify"
		animation.layer = EFFECTS_LAYER_BASE
		animation.master = holder
		flick("liquify",animation)
		H.set_loc(holder)
		var/datum/effects/system/steam_spread/steam = unpool(/datum/effects/system/steam_spread)
		steam.set_up(10, 0, mobloc)
		steam.start()
		sleep(time)
		mobloc = get_turf(H.loc)
		animation.set_loc(mobloc)
		steam.location = mobloc
		steam.start()
		H.canmove = 0
		sleep(20)
		flick("reappear",animation)
		sleep(5)
		H.set_loc(mobloc)
		H.canmove = 1
		qdel(animation)
		for (var/obj/junk_to_dump in holder.contents)
			junk_to_dump.set_loc(mobloc)

		qdel(holder)

/obj/dummy/spell_invis
	name = "water"
	icon = 'icons/effects/effects.dmi'
	icon_state = "nothing"
	invisibility = 101
	var/canmove = 1
	density = 0
	anchored = 1

/obj/dummy/spell_invis/relaymove(var/mob/user, direction)
	if (!src.canmove) return
	switch(direction)
		if(NORTH)
			src.y++
		if(SOUTH)
			src.y--
		if(EAST)
			src.x++
		if(WEST)
			src.x--
		if(NORTHEAST)
			src.y++
			src.x++
		if(NORTHWEST)
			src.y++
			src.x--
		if(SOUTHEAST)
			src.y--
			src.x++
		if(SOUTHWEST)
			src.y--
			src.x--
	src.canmove = 0
	spawn(2) src.canmove = 1

/obj/dummy/spell_invis/ex_act(blah)
	return

/obj/dummy/spell_invis/bullet_act(blah,blah)
	return
