/datum/targetable/vampire/phaseshift_vampire
	name = "Mist form"
	desc = "Phase through walls. Only works when you can't be seen."
	targeted = 0
	target_nodamage_check = 0
	max_range = 0
	cooldown = 600
	pointCost = 0
	when_stunned = 0
	not_when_handcuffed = 0
	restricted_area_check = 1
	var/duration = 50
	unlock_message = "You have gained mist form. It temporarily turns you incorporeal, allowing you to pass through solid objects."

	cast(mob/target)
		if (!holder)
			return 1

		var/mob/living/M = holder.owner
		var/datum/abilityHolder/vampire/H = holder

		if (!M)
			return 1

		if (spell_invisibility(M, 1, 1, 0, 1) != 1) // Dry run. Can we phaseshift?
			return 1

		spell_invisibility(M, src.duration, 1)
		H.locked = 1 // Can't use any powers during phaseshift.
		spawn (src.duration)
			if (H) H.locked = 0

		logTheThing("combat", M, null, "uses mist form at [log_loc(M)].")
		return 0