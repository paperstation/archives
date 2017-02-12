// Converted everything related to vampires from client procs to ability holders and used
// the opportunity to do some clean-up as well (Convair880).

/////////////////////////////////////////////////// Setup //////////////////////////////////////////

/mob/proc/make_vampire()
	if (ishuman(src) || iscritter(src))
		if (ishuman(src))
			var/datum/abilityHolder/vampire/A = src.get_ability_holder(/datum/abilityHolder/vampire)
			if (A && istype(A))
				return

			var/datum/abilityHolder/vampire/V = src.add_ability_holder(/datum/abilityHolder/vampire)
			V.addAbility(/datum/targetable/vampire/vampire_bite)
			V.addAbility(/datum/targetable/vampire/blood_tracking)
			V.addAbility(/datum/targetable/vampire/cancel_stuns)
			V.addAbility(/datum/targetable/vampire/glare)
			V.addAbility(/datum/targetable/vampire/hypnotize)

			if (src.mind)
				src.mind.is_vampire = V

			spawn (25) // Don't remove.
				if (src) src.assign_gimmick_skull()

		else if (iscritter(src)) // For testing. Just give them all abilities that are compatible.
			var/mob/living/critter/C = src

			if (isnull(C.abilityHolder)) // They do have a critter AH by default...or should.
				var/datum/abilityHolder/vampire/A2 = C.add_ability_holder(/datum/abilityHolder/vampire)
				if (!A2 || !istype(A2, /datum/abilityHolder/))
					return

			C.abilityHolder.addAbility(/datum/targetable/vampire/cancel_stuns/mk2)
			C.abilityHolder.addAbility(/datum/targetable/vampire/glare)
			C.abilityHolder.addAbility(/datum/targetable/vampire/hypnotize)
			C.abilityHolder.addAbility(/datum/targetable/vampire/plague_touch)
			C.abilityHolder.addAbility(/datum/targetable/vampire/phaseshift_vampire)
			C.abilityHolder.addAbility(/datum/targetable/vampire/call_bats)
			C.abilityHolder.addAbility(/datum/targetable/vampire/vampire_scream)
			C.abilityHolder.addAbility(/datum/targetable/vampire/enthrall)

			if (C.mind)
				C.mind.is_vampire = C.abilityHolder

		if (src.mind && src.mind.special_role != "omnitraitor")
			src << browse(grabResource("html/traitorTips/vampireTips.html"),"window=antagTips;titlebar=1;size=600x400;can_minimize=0;can_resize=0")

	else return

////////////////////////////////////////////////// Helper procs ////////////////////////////////////////////////

// Just a little helper or two since vampire parameters aren't tracked by mob vars anymore.
/mob/proc/get_vampire_blood(var/total_blood = 0)
	if (!isvampire(src))
		return 0

	var/datum/abilityHolder/vampire/AH = src.get_ability_holder(/datum/abilityHolder/vampire)
	if (AH && istype(AH))
		if (total_blood)
			return AH.vamp_blood
		else
			return AH.points
	else
		return 0

/mob/proc/change_vampire_blood(var/change = 0, var/total_blood = 0, var/set_null = 0)
	if (!isvampire(src))
		return

	var/datum/abilityHolder/vampire/AH = src.get_ability_holder(/datum/abilityHolder/vampire)
	if (AH && istype(AH))
		if (total_blood)
			if (AH.vamp_blood < 0)
				AH.vamp_blood = 0
				if (haine_blood_debug) logTheThing("debug", src, null, "<b>HAINE BLOOD DEBUG:</b> [src]'s vamp_blood dropped below 0 and was reset to 0")

			if (set_null == 1)
				AH.vamp_blood = 0
			else
				AH.vamp_blood = max(AH.vamp_blood + change, 0)

		else
			if (AH.points < 0)
				AH.points = 0
				if (haine_blood_debug) logTheThing("debug", src, null, "<b>HAINE BLOOD DEBUG:</b> [src]'s vamp_blood_remaining dropped below 0 and was reset to 0")

			if (set_null == 1)
				AH.points = 0
			else
				AH.points = max(AH.points + change, 0)

	return

/mob/proc/check_vampire_power(var/which_power = 3) // 1: thermal | 2: xray | 3: full power
	if (!isvampire(src))
		return 0

	if (!which_power)
		return 0

	var/datum/abilityHolder/vampire/AH = src.get_ability_holder(/datum/abilityHolder/vampire)
	if (AH && istype(AH))
		switch (which_power)
			if (1)
				if (AH.has_thermal == 1)
					return 1
				else
					return 0

			if (2)
				if (AH.has_xray == 1)
					return 1
				else
					return 0

			if (3)
				if (AH.has_fullpower == 1)
					return 1
				else
					return 0

			else
				return 0
	else
		return 0

////////////////////////////////////////////////// Ability holder /////////////////////////////////////////////

/obj/screen/ability/vampire
	clicked(params)
		var/datum/targetable/vampire/spell = owner
		var/datum/abilityHolder/holder = owner.holder

		if (!istype(spell))
			return
		if (!spell.holder)
			return

		if(params["shift"] && params["ctrl"])
			if(owner.waiting_for_hotkey)
				holder.cancel_action_binding()
				return
			else
				owner.waiting_for_hotkey = 1
				src.updateIcon()
				boutput(usr, "<span style=\"color:blue\">Please press a number to bind this ability to...</span>")
				return

		if (!isturf(owner.holder.owner.loc))
			boutput(owner.holder.owner, "<span style=\"color:red\">You can't use this spell here.</span>")
			return
		if (spell.targeted && usr:targeting_spell == owner)
			usr:targeting_spell = null
			usr.update_cursor()
			return
		if (spell.targeted)
			if (world.time < spell.last_cast)
				return
			owner.holder.owner.targeting_spell = owner
			owner.holder.owner.update_cursor()
		else
			spawn
				spell.handleCast()
		return

/datum/abilityHolder/vampire
	usesPoints = 1
	regenRate = 0
	tabName = "Vampire"
	notEnoughPointsMessage = "<span style=\"color:red\">You need more blood to use this ability.</span>"
	var/vamp_blood = 0
	points = 0 // Replaces the old vamp_blood_remaining var.
	var/vamp_blood_tracking = 1
	var/mob/vamp_isbiting = null

	// Note: please use mob.get_vampire_blood() & mob.change_vampire_blood() instead of changing the numbers directly.

	// At the time of writing, sight (thermal, x-ray) and chapel checks can be found in human.dm.
	var/has_thermal = 0
	var/has_xray = 0
	var/has_fullpower = 0

	// These are thresholds in relation to vamp_blood. Last_power exists only for unlock checks as stuff
	// might deduct something from vamp_blood, though it shouldn't happen on a regular basis.
	var/last_power = 0
	var/level1 = 200
	var/level2 = 300
	var/level3 = 400
	var/level4 = 600
	var/level5 = 800
	var/level6 = 1000 // Full power.

	onAbilityStat() // In the 'Vampire' tab.
		..()
		stat("Blood:", src.vamp_blood)
		stat("Blood remaining:", src.points)
		return

	proc/blood_tracking_output(var/deduct = 0)
		if (!src.owner || !ismob(src.owner))
			return

		if (!istype(src, /datum/abilityHolder/vampire))
			return

		if (!src.vamp_blood_tracking)
			return

		if (deduct > 1)
			boutput(src.owner, __blue("You used [deduct] units of blood, and have [src.points - deduct] remaining."))

		else
			boutput(src.owner, __blue("You have accumulated [src.vamp_blood] units of blood and [src.points] left to use."))

		return

	proc/check_for_unlocks()
		if (!src.owner || !ismob(src.owner))
			return

		if (!istype(src, /datum/abilityHolder/vampire))
			return

		if (!src.last_power && src.vamp_blood >= src.level1)
			src.last_power = 1

			src.has_thermal = 1
			boutput(src.owner, __blue("<h3>Your vampiric vision has improved (thermal)!</h3>"))

			src.addAbility(/datum/targetable/vampire/plague_touch)

		if (src.last_power == 1 && src.vamp_blood >= src.level2)
			src.last_power = 2

			src.addAbility(/datum/targetable/vampire/phaseshift_vampire)
			src.addAbility(/datum/targetable/vampire/radio_jammer)

		if (src.last_power == 2 && src.vamp_blood >= src.level3)
			src.last_power = 3

			src.addAbility(/datum/targetable/vampire/call_bats)
			src.addAbility(/datum/targetable/vampire/vampire_scream)

		if (src.last_power == 3 && src.vamp_blood >= src.level4)
			src.last_power = 4

			src.removeAbility(/datum/targetable/vampire/cancel_stuns)
			src.addAbility(/datum/targetable/vampire/cancel_stuns/mk2)
			src.addAbility(/datum/targetable/vampire/vamp_cloak)

		if (src.last_power == 4 && src.vamp_blood >= src.level5)
			src.last_power = 5

			src.addAbility(/datum/targetable/vampire/enthrall)

		if (src.last_power == 5 && src.vamp_blood >= src.level6)
			src.last_power = 6

			src.has_xray = 1
			src.has_fullpower = 1
			boutput(src.owner, __blue("<h3>Your vampiric vision has improved (x-ray)!</h3>"))
			boutput(src.owner, __blue("<h3>You have attained full power and are now too powerful to be harmed or stopped by the chapel's aura.</h3>"))

		return

///////////////////////////////////////////// Vampire spell parent //////////////////////////////////////////////////

// If you change the blood cost, cooldown etc of an ability, don't forget to update vampireTips.html too!

// Notes:
// - If an ability isn't available from the beginning, add an unlock_message to notify the player of unlocks.
// - Vampire abilities are logged. Please keep it that way when you make additions.
// - Add this snippet at the bottom of cast() if the ability isn't free. Optional but basic feedback for the player.
//		var/datum/abilityHolder/vampire/H = holder
//		if (istype(H)) H.blood_tracking_output(src.pointCost)
//		- You should also call the proc if you make the player pay for an interrupted attempt to use the ability, for
//		  instance when employing do_mob() checks.

/datum/targetable/vampire
	icon = 'icons/mob/critter_ui.dmi'
	icon_state = "template"  // Vampire ability sprites don't exist yet.
	cooldown = 0
	last_cast = 0
	pointCost = 0
	preferred_holder_type = /datum/abilityHolder/vampire
	var/when_stunned = 0 // 0: Never | 1: Ignore mob.stunned and mob.weakened | 2: Ignore all incapacitation vars
	var/not_when_handcuffed = 0
	var/unlock_message = null

	New()
		var/obj/screen/ability/vampire/B = new /obj/screen/ability/vampire(null)
		B.icon = src.icon
		B.icon_state = src.icon_state
		B.owner = src
		B.name = src.name
		B.desc = src.desc
		src.object = B
		return

	onAttach(var/datum/abilityHolder/H)
		..() // Start_on_cooldown check.
		if (src.unlock_message && src.holder && src.holder.owner)
			boutput(src.holder.owner, __blue("<h3>[src.unlock_message]</h3>"))
		return

	updateObject()
		..()
		if (!src.object)
			src.object = new /obj/screen/ability/vampire()
			object.icon = src.icon
			object.owner = src
		if (src.last_cast > world.time)
			var/pttxt = ""
			if (pointCost)
				pttxt = " \[[pointCost]\]"
			object.name = "[src.name][pttxt] ([round((src.last_cast-world.time)/10)])"
			object.icon_state = src.icon_state + "_cd"
		else
			var/pttxt = ""
			if (pointCost)
				pttxt = " \[[pointCost]\]"
			object.name = "[src.name][pttxt]"
			object.icon_state = src.icon_state
		return

	proc/incapacitation_check(var/stunned_only_is_okay = 0)
		if (!holder)
			return 0

		var/mob/living/M = holder.owner
		if (!M || !ismob(M))
			return 0

		switch (stunned_only_is_okay)
			if (0)
				if (M.stat != 0 || M.stunned > 0 || M.paralysis > 0 || M.weakened > 0)
					return 0
				else
					return 1
			if (1)
				if (M.stat != 0 || M.paralysis > 0)
					return 0
				else
					return 1
			else
				return 1

	castcheck()
		if (!holder)
			return 0

		var/mob/living/M = holder.owner

		if (!M)
			return 0

		if (!(iscarbon(M) || iscritter(M)))
			boutput(M, __red("You cannot use any powers in your current form."))
			return 0

		if (M.transforming)
			boutput(M, __red("You can't use any powers right now."))
			return 0

		if (incapacitation_check(src.when_stunned) != 1)
			boutput(M, __red("You can't use this ability while incapacitated!"))
			return 0

		if (src.not_when_handcuffed == 1 && M.restrained())
			boutput(M, __red("You can't use this ability when restrained!"))
			return 0

		if (istype(get_area(M), /area/station/chapel) && M.check_vampire_power(3) != 1)
			boutput(M, __red("Your powers do not work in this holy place!"))
			return 0

		return 1

	cast(atom/target)
		. = ..()
		actions.interrupt(holder.owner, INTERRUPT_ACT)
		return