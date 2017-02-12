/datum/targetable/vampire/vampire_scream
	name = "Chiropteran screech"
	desc = "Deafens nearby foes, smashes windows and lights. Blocked by ear protection."
	targeted = 0
	target_nodamage_check = 0
	max_range = 0
	cooldown = 1200
	pointCost = 60
	when_stunned = 1
	not_when_handcuffed = 0
	unlock_message = "You have gained chiropteran screech. It deafens nearby foes, smashes windows and lights."

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

		M.emote("scream")

		for (var/mob/living/HH in hearers(M, null))
			if (HH == M) continue
			if (isvampire(HH) && HH.check_vampire_power(3) == 1)
				boutput(HH, __blue("You are immune to [M]'s screech!"))
				continue
			if (HH.bioHolder && HH.bioHolder.HasEffect("training_chaplain"))
				boutput(HH, __blue("[M]'s scream only strengthens your resolve!"))
				continue

			HH.apply_sonic_stun(0, 0, 40, 0, 15, 8, 12)

		sonic_attack_environmental_effect(M, 7, list("light", "window", "r_window"))

		if (istype(H)) H.blood_tracking_output(src.pointCost)
		logTheThing("combat", M, null, "uses chiropteran screech at [log_loc(M)].")
		return 0