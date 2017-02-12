// Contains:
// - Baton parent
// - Subtypes

////////////////////////////////////////// Stun baton parent //////////////////////////////////////////////////

// Completely refactored the ca. 2009-era code here. Powered batons also use power cells now (Convair880).
/obj/item/baton
	name = "stun baton"
	desc = "A standard issue baton for stunning people with."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "stunbaton"
	inhand_image_icon = 'icons/mob/inhand/hand_weapons.dmi'
	item_state = "baton"
	flags = FPRINT | ONBELT | TABLEPASS
	force = 10
	throwforce = 7
	w_class = 3
	mats = 8
	contraband = 4
	stamina_damage = 15
	stamina_cost = 10
	stamina_crit_chance = 5

	var/icon_on = "stunbaton_active"
	var/icon_off = "stunbaton"
	var/wait_cycle = 0 // Update sprite periodically if we're using a self-charging cell.

	var/cell_type = /obj/item/ammo/power_cell/med_power // Type of cell to spawn by default.
	var/obj/item/ammo/power_cell/cell = null // Ignored for cyborgs and when used_electricity is false.
	var/cost_normal = 25 // Cost in PU. Doesn't apply to cyborgs.
	var/cost_cyborg = 500 // Battery charge to drain when user is a cyborg.
	var/uses_charges = 1 // Does it deduct charges when used? Distinct from...
	var/uses_electricity = 1 // Does it use electricity? Certain interactions don't work with a wooden baton.
	var/status = 1

	var/stun_normal_weakened = 10
	var/stun_normal_stuttering = 10
	var/stun_harm_weakened = 5 // Only used when next flag is set to 1.
	var/instant_harmbaton_stun = 0 // Legacy behaviour for harmbaton, that is an instant knockdown.
	var/stamina_based_stun = 0 // Experimental. Centered around stamina instead of traditional stun.
	var/stamina_based_stun_amount = 275 // Amount of stamina drained.

	New()
		..()
		if (src.uses_electricity != 0 && (!isnull(src.cell_type) && ispath(src.cell_type, /obj/item/ammo/power_cell)) && (!src.cell || !istype(src.cell)))
			src.cell = new src.cell_type(src)
		if (!(src in processing_items)) // No self-charging cell? Will be removed after the first tick.
			processing_items.Add(src)
		src.update_icon()
		return

	disposing()
		if (src in processing_items)
			processing_items.Remove(src)
		..()
		return

	examine()
		..()
		if (src.uses_charges != 0 && src.uses_electricity != 0)
			if (!src.cell || !istype(src.cell))
				boutput(usr, "<span style=\"color:red\">No power cell installed.</span>")
			else
				boutput(usr, "The baton is turned [src.status ? "on" : "off"]. There are [src.cell.charge]/[src.cell.max_charge] PUs left! Each stun will use [src.cost_normal] PUs.")
		return

	emp_act()
		if (src.uses_charges != 0 && src.uses_electricity != 0)
			src.status = 0
			src.process_charges(-INFINITY)
		return

	process()
		src.wait_cycle = !src.wait_cycle
		if (src.wait_cycle)
			return

		if (!(src in processing_items))
			logTheThing("debug", null, null, "<b>Convair880</b>: Process() was called for a stun baton ([src.type]) that wasn't in the item loop. Last touched by: [src.fingerprintslast ? "[src.fingerprintslast]" : "*null*"]")
			processing_items.Add(src)
			return
		if (!src.cell || !istype(src.cell) || src.uses_electricity == 0)
			processing_items.Remove(src)
			return
		if (!istype(src.cell, /obj/item/ammo/power_cell/self_charging)) // Kick out batons with a plain cell.
			processing_items.Remove(src)
			return
		if (src.cell.charge == src.cell.max_charge) // Keep self-charging cells in the loop, though.
			return

		src.update_icon()
		return

	proc/update_icon()
		if (!src || !istype(src))
			return

		if (src.status)
			icon_state = src.icon_on
		else
			icon_state = src.icon_off

		return

	proc/can_stun(var/requires_electricity = 0, var/amount = 1, var/mob/user)
		if (!src || !istype(src))
			return 0
		if (src.uses_electricity == 0)
			if (requires_electricity == 0)
				return 1
			else
				return 0
		if (src.status == 0)
			return 0
		if (amount <= 0)
			return 0

		src.regulate_charge()
		if (user && isrobot(user))
			var/mob/living/silicon/robot/R = user
			if (R.cell && R.cell.charge >= (src.cost_cyborg * amount))
				return 1
			else
				return 0
		if (!src.cell || !istype(src.cell))
			if (user && ismob(user))
				user.show_text("The [src.name] doesn't have a power cell!", "red")
			return 0
		if (src.cell.charge < (src.cost_normal * amount))
			if (user && ismob(user))
				user.show_text("The [src.name] is out of charge!", "red")
			return 0
		else
			return 1

	proc/regulate_charge()
		if (!src || !istype(src))
			return

		if (src.cell && istype(src.cell))
			if (src.cell.charge < 0)
				src.cell.charge = 0
			if (src.cell.charge > src.cell.max_charge)
				src.cell.charge = src.cell.max_charge

			src.cell.update_icon()
			src.update_icon()

		return

	proc/process_charges(var/amount = -1, var/mob/user)
		if (!src || !istype(src) || amount == 0)
			return
		if (src.uses_electricity == 0)
			return

		if (user && isrobot(user))
			var/mob/living/silicon/robot/R = user
			if (amount < 0)
				R.cell.use(src.cost_cyborg * -(amount))
		else
			if (src.uses_charges != 0 && (src.cell && istype(src.cell)))
				if (amount < 0)
					src.cell.use(src.cost_normal * -(amount))
					if (user && ismob(user))
						if (src.cell.charge > 0)
							user.show_text("The [src.name] now has [src.cell.charge]/[src.cell.max_charge] PUs remaining.", "blue")
						else if (src.cell.charge <= 0)
							user.show_text("The [src.name] is now out of charge!", "red")
				else if (amount > 0)
					src.cell.charge(src.cost_normal * amount)

		src.update_icon()
		return

	proc/use_stamina_stun()
		if (!src || !istype(src))
			return 0

		if (src.stamina_based_stun != 0)
			src.stamina_damage = src.stamina_based_stun_amount
			return 1
		else
			src.stamina_damage = initial(src.stamina_damage) // Doubles as reset fallback (var editing).
			return 0

	proc/do_stun(var/mob/user, var/mob/victim, var/type = "", var/stun_who = 2)
		if (!src || !istype(src) || type == "")
			return
		if (!user || !victim || !ismob(victim))
			return

		// Sound effects, log entries and text messages.
		switch (type)
			if ("failed")
				logTheThing("combat", user, null, "accidentally stuns [himself_or_herself(user)] with the [src.name] at [log_loc(user)].")

				if (src.uses_electricity != 0)
					user.visible_message("<span style=\"color:red\"><b>[user]</b> fumbles with the [src.name] and accidentally stuns [himself_or_herself(user)]!</span>")
					flick("baton_active", src)
					playsound(src.loc, "sound/weapons/Egloves.ogg", 50, 1, -1)
				else
					user.visible_message("<span style=\"color:red\"><b>[user]</b> swings the [src.name] in the wrong way and accidentally hits [himself_or_herself(user)]!</span>")
					playsound(src.loc, "sound/weapons/Genhit.ogg", 50, 1, -1)
					random_brute_damage(user, 2 * src.force)

			if ("failed_stun")
				user.visible_message("<span style=\"color:red\"><B>[victim] has been prodded with the [src.name] by [user]! Luckily it was off.</B></span>")
				playsound(src.loc, "sound/weapons/Genhit.ogg", 25, 1, -1)
				logTheThing("combat", user, victim, "unsuccessfully tries to stun %target% with the [src.name] at [log_loc(victim)].")

				if (src.uses_electricity && src.status == 1 && (src.cell && istype(src.cell) && (src.cell.charge < src.cost_normal)))
					if (user && ismob(user))
						user.show_text("The [src.name] is out of charge!", "red")
				return

			if ("failed_harm")
				user.visible_message("<span style=\"color:red\"><B>[user] has attempted to beat [victim] with the [src.name] but held it wrong!</B></span>")
				playsound(src.loc, "sound/weapons/Genhit.ogg", 50, 1, -1)
				logTheThing("combat", user, victim, "unsuccessfully tries to beat %target% with the [src.name] at [log_loc(victim)].")

			if ("stun", "stun_classic")
				user.visible_message("<span style=\"color:red\"><B>[victim] has been stunned with the [src.name] by [user]!</B></span>")
				logTheThing("combat", user, victim, "stuns %target% with the [src.name] at [log_loc(victim)].")

				if (type == "stun_classic")
					playsound(src.loc, "sound/weapons/Genhit.ogg", 50, 1, -1)
				else
					flick("baton_active", src)
					playsound(src.loc, "sound/weapons/Egloves.ogg", 50, 1, -1)

			if ("harm_classic")
				user.visible_message("<span style=\"color:red\"><B>[victim] has been beaten with the [src.name] by [user]!</B></span>")
				playsound(src.loc, "swing_hit", 50, 1, -1)
				logTheThing("combat", user, victim, "beats %target% with the [src.name] at [log_loc(victim)].")

			else
				logTheThing("debug", user, null, "<b>Convair880</b>: stun baton ([src.type]) do_stun() was called with an invalid argument ([type]), aborting. Last touched by: [src.fingerprintslast ? "[src.fingerprintslast]" : "*null*"]")
				return

		// Target setup. User might not be a mob (Beepsky), but the victim needs to be one.
		var/mob/dude_to_stun
		if (stun_who == 1 && user && ismob(user))
			dude_to_stun = user
		else
			dude_to_stun = victim

		var/hulk = 0
		if (dude_to_stun.bioHolder && dude_to_stun.bioHolder.HasEffect("hulk"))
			hulk = 1

		// Stun the target mob.
		if (type == "harm_classic")
			if ((dude_to_stun.weakened < src.stun_harm_weakened) && !hulk)
				dude_to_stun.weakened = src.stun_harm_weakened
			random_brute_damage(dude_to_stun, src.force) // Necessary since the item/attack() parent wasn't called.
			dude_to_stun.remove_stamina(src.stamina_damage)
			if (user && ismob(user))
				user.remove_stamina(src.stamina_cost)

		else
			if (dude_to_stun.bioHolder && dude_to_stun.bioHolder.HasEffect("resist_electric") && src.uses_electricity != 0)
				boutput(dude_to_stun, "<span style=\"color:blue\">Thankfully, electricity doesn't do much to you in your current state.</span>")
			else
				if (!src.use_stamina_stun() || (src.use_stamina_stun() && ismob(dude_to_stun) && !hasvar(dude_to_stun, "stamina")))
					if ((dude_to_stun.weakened < src.stun_normal_weakened) && !hulk)
						dude_to_stun.weakened = src.stun_normal_weakened
					if ((dude_to_stun.stuttering < src.stun_normal_stuttering) && !hulk)
						dude_to_stun.stuttering = src.stun_normal_stuttering
				else
					dude_to_stun.remove_stamina(src.stamina_damage)
					dude_to_stun.stamina_stun() // Must be called manually here to apply the stun instantly.

				if (isliving(dude_to_stun) && src.uses_electricity != 0)
					var/mob/living/L = dude_to_stun
					L.Virus_ShockCure(33)
					L.shock_cyberheart(33)

			src.process_charges(-1, user)

		// Some after attack stuff.
		if (user && ismob(user))
			user.lastattacked = dude_to_stun
			dude_to_stun.lastattacker = user
			dude_to_stun.lastattackertime = world.time

		src.update_icon()
		return

	attack_self(mob/user as mob)
		src.add_fingerprint(user)

		if (src.uses_electricity == 0)
			return

		src.regulate_charge()
		src.status = !src.status

		if (src.can_stun() == 1 && user.bioHolder && user.bioHolder.HasEffect("clumsy") && prob(50))
			src.do_stun(user, user, "failed", 1)
			return

		if (src.status)
			user.show_text("The [src.name] is now on.", "blue")
			playsound(src.loc, "sparks", 75, 1, -1)
		else
			user.show_text("The [src.name] is now off.", "blue")
			playsound(src.loc, "sparks", 75, 1, -1)

		src.update_icon()
		return

	attack(mob/M as mob, mob/user as mob)
		src.add_fingerprint(user)
		src.regulate_charge()

		if (src.can_stun() == 1 && user.bioHolder && user.bioHolder.HasEffect("clumsy") && prob(50))
			src.do_stun(user, M, "failed", 1)
			return

		switch (user.a_intent)
			if ("harm")
				if (src.uses_electricity == 0)
					if (src.instant_harmbaton_stun != 0)
						src.do_stun(user, M, "harm_classic", 2)
					else
						playsound(src.loc, "swing_hit", 50, 1, -1)
						..() // Parent handles attack log entry and stamina drain.
				else
					if (src.status == 0 || (src.status != 0 && src.can_stun() == 0))
						if (src.instant_harmbaton_stun != 0)
							src.do_stun(user, M, "harm_classic", 2)
						else
							playsound(src.loc, "swing_hit", 50, 1, -1)
							..()
					else
						src.do_stun(user, M, "failed_harm", 1)

			else
				if (src.uses_electricity == 0)
					src.do_stun(user, M, "stun_classic", 2)
				else
					if (src.status == 0 || (src.status != 0 && src.can_stun() == 0))
						src.do_stun(user, M, "failed_stun", 1)
					else
						src.do_stun(user, M, "stun", 2)

		return

	proc/log_cellswap(var/mob/user as mob, var/obj/item/ammo/power_cell/C)
		if (!user || !src || !istype(src) || !C || !istype(C))
			return

		logTheThing("combat", user, null, "swaps the power cell (<b>Cell type:</b> <i>[C.type]</i>) of [src] at [log_loc(user)].")
		return

/////////////////////////////////////////////// Subtypes //////////////////////////////////////////////////////

/obj/item/baton/secbot
	uses_charges = 0

/obj/item/baton/stamina
	stamina_based_stun = 1

/obj/item/baton/cane
	name = "stun cane"
	desc = "A stun baton built into the casing of a cane."
	icon_state = "stuncane"
	item_state = "cane"
	icon_on = "stuncane_active"
	icon_off = "stuncane"
	cell_type = /obj/item/ammo/power_cell

/obj/item/baton/classic
	name = "police baton"
	desc = "A wooden truncheon for beating criminal scum."
	icon_state = "baton"
	item_state = "classic_baton"
	force = 10
	mats = 0
	contraband = 6
	icon_on = "baton"
	icon_off = "baton"
	uses_charges = 0
	uses_electricity = 0
	stun_normal_weakened = 8
	stun_normal_stuttering = 8
	instant_harmbaton_stun = 1