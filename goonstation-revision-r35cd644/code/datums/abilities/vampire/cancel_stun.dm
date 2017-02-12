/datum/targetable/vampire/cancel_stuns
	name = "Cancel stuns"
	desc = "Recover from being stunned."
	targeted = 0
	target_nodamage_check = 0
	max_range = 0
	cooldown = 600
	pointCost = 0
	when_stunned = 2
	not_when_handcuffed = 0

	proc/remove_stuns(var/message_type = 1)
		if (!holder)
			return

		var/mob/living/M = holder.owner

		if (!M)
			return

		M.stunned = 0
		M.weakened = 0
		M.paralysis = 0
		M.slowed = 0
		M.change_misstep_chance(-INFINITY)
		M.stuttering = 0
		M.drowsyness = 0

		if (M.get_stamina() != (STAMINA_MAX + M.get_stam_mod_max())) // Tasers etc.
			M.set_stamina(STAMINA_MAX + M.get_stam_mod_max())

		if (message_type == 2)
			boutput(M, __blue("You feel your flesh knitting itself back together."))
		else
			boutput(M, __blue("You feel refreshed and ready to get back into the fight."))

		logTheThing("combat", M, null, "uses cancel stuns at [log_loc(M)].")
		return

	cast(mob/target)
		if (!holder)
			return 1

		var/mob/living/M = holder.owner

		if (!M)
			return 1

		src.remove_stuns(1)
		return 0

/datum/targetable/vampire/cancel_stuns/mk2
	name = "Cancel stuns Mk2"
	desc = "Recover from being stunned. Restores a minor amount of health."
	cooldown = 600
	pointCost = 0
	when_stunned = 2
	unlock_message = "Your cancel stuns power now heals you in addition to its original effect."

	cast(mob/target)
		if (!holder)
			return 1

		var/mob/living/M = holder.owner

		if (!M)
			return 1

		if (M.get_burn_damage() > 0 || M.get_toxin_damage() > 0 || M.get_brute_damage() > 0 || M.get_oxygen_deprivation() > 0 || M.losebreath > 0)
			M.HealDamage("All", 40, 40)
			M.take_toxin_damage(-40)
			M.take_oxygen_deprivation(-40)
			M.losebreath = min(usr.losebreath - 40)
			M.updatehealth()

		src.remove_stuns(2)
		return 0