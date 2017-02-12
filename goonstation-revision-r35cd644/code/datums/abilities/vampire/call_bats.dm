/datum/targetable/vampire/call_bats
	name = "Call bats"
	desc = "Calls a swarm of bats to attack your foes."
	targeted = 0
	target_nodamage_check = 0
	max_range = 0
	cooldown = 1200
	pointCost = 150
	when_stunned = 0
	not_when_handcuffed = 1
	unlock_message = "You have gained call bats, which summons bats to fight for you."

	cast(mob/target)
		if (!holder)
			return 1

		var/mob/living/M = holder.owner
		var/datum/abilityHolder/vampire/H = holder

		if (!M)
			return 1

		if (M.wear_mask && istype(M.wear_mask, /obj/item/clothing/mask/muzzle))
			boutput(M, __red("How do you expect this to work? You're muzzled!"))
			M.visible_message("<span style=\"color:red\"><b>[M]</b> makes a loud noise.</span>")
			if (istype(H)) H.blood_tracking_output(src.pointCost)
			return 0 // Cooldown because spam is bad.

		var/turf/T = get_turf(M)
		if (T && isturf(T))
			M.say("BATT PHAR")
			new /obj/critter/bat/buff(T)
			new /obj/critter/bat/buff(T)
			new /obj/critter/bat/buff(T)
			for (var/obj/critter/bat/buff/B in range(M, 1))
				B.friends += M
		else
			boutput(M, __red("The bats did not respond to your call!"))
			return 1 // No cooldown here, though.

		if (istype(H)) H.blood_tracking_output(src.pointCost)
		logTheThing("combat", M, null, "uses call bats at [log_loc(M)].")
		return 0