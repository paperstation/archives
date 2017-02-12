/datum/targetable/vampire/vampire_bite
	name = "Bite victim"
	desc = "Bite the victim's neck to drain them of blood."
	targeted = 1
	target_nodamage_check = 1
	max_range = 1
	cooldown = 0
	pointCost = 0
	when_stunned = 0
	not_when_handcuffed = 1
	dont_lock_holder = 1
	restricted_area_check = 2

	proc/can_bite(var/mob/living/carbon/human/target)
		if (!holder)
			return 0

		var/mob/living/M = holder.owner
		var/datum/abilityHolder/vampire/H = holder

		if (!M || !target)
			return 0

		if (!ishuman(target)) // Only humans use the blood system.
			boutput(M, __red("You can't seem to find any blood vessels."))
			return 0

		if (M == target)
			boutput(M, __red("Why would you want to bite yourself?"))
			return 0

		if (iscritter(M) && !istype(H))
			boutput(M, __red("Critter mobs currently don't have to worry about blood. Lucky you."))
			return 0

		if (istype(H) && H.vamp_isbiting)
			boutput(M, __red("You are already draining someone's blood!"))
			return 0

		if (target.head && target.head.body_parts_covered & HEAD)
			boutput(M, __red("You need to remove their headgear first."))
			return 0

		if (target.wear_mask && target.wear_mask.body_parts_covered & HEAD)
			boutput(M, __red("You need to remove their facemask first."))
			return 0

		if (check_target_immunity(target) == 1)
			target.visible_message("<span style=\"color:red\"><B>[M] bites [target], but fails to even pierce their skin!</B></span>")
			return 0

		if ((target.mind && target.mind.special_role == "vampthrall") && target.is_mentally_dominated_by(M))
			boutput(M, __red("You can't drink the blood of your own thralls!"))
			return 0

		if (ismonkey(target) || (target.bioHolder && target.bioHolder.HasEffect("monkey")))
			boutput(M, __red("Drink monkey blood?! That's disgusting!"))
			return 0

		return 1

	cast(mob/target)
		if (!holder)
			return 1

		var/mob/living/M = holder.owner
		var/datum/abilityHolder/vampire/H = holder

		if (!M || !target || !ismob(target))
			return 1

		if (get_dist(M, target) > src.max_range)
			boutput(M, __red("[target] is too far away."))
			return 1

		if (src.can_bite(target) != 1)
			return 1

		logTheThing("combat", M, target, "bites %target%'s neck at [log_loc(M)].")

		boutput(M, __blue("You bite [target] and begin to drain them of blood."))
		target.visible_message("<span style=\"color:red\"><B>[M] bites [target]!</B></span>")
		if (istype(H)) H.vamp_isbiting = target
		target.vamp_beingbitten = 1

		var/mob/living/carbon/human/HH = target

		while (do_mob(M, HH, 30))
			if (HH.blood_volume > 0)

				if (HH.stat == 2)
					if (prob(20))
						boutput(M, __red("The blood of the dead provides little sustenance..."))
					M.change_vampire_blood(5, 1)
					M.change_vampire_blood(5, 0)
					if (HH.blood_volume < 20)
						HH.blood_volume = 0
					else
						HH.blood_volume -= 20
					if (istype(H)) H.blood_tracking_output()

				else if (HH.bioHolder && HH.bioHolder.HasEffect("training_chaplain"))
					M.visible_message("<span style=\"color:red\"><b>[M]</b> begins to crisp and burn!</span>", "<span style=\"color:red\">You drank the blood of a holy man! It burns!</span>")
					M.emote("scream")
					if (M.get_vampire_blood() >= 20)
						M.change_vampire_blood(-20, 0)
					else
						M.change_vampire_blood(0, 0, 1)
					M.TakeDamage("chest", 0, 30)

				else
					if (isvampire(HH))
						if (HH.get_vampire_blood() >= 20)
							HH.change_vampire_blood(-20, 0)
							HH.change_vampire_blood(-20, 1) // Otherwise, two vampires could perpetually feed off of each other, trading blood endlessly.
							M.change_vampire_blood(20, 0)
							M.change_vampire_blood(20, 1)
							if (istype(H)) H.blood_tracking_output()
							if (prob(50))
								boutput(M, __red("This is the blood of a fellow vampire!"))
						else
							HH.change_vampire_blood(0, 0, 1)
							HH.vamp_beingbitten = 0
							if (istype(H)) H.vamp_isbiting = null
							boutput(M, __red("[HH] doesn't have enough blood left to drink."))
							return 0

					else
						M.change_vampire_blood(10, 1)
						M.change_vampire_blood(10, 0)
						if (HH.blood_volume < 20)
							HH.blood_volume = 0
						else
							HH.blood_volume -= 20
						if (HH.blood_volume < 300 && prob(15))
							if (HH.paralysis == 0)
								boutput(HH, __red("Your vision fades to blackness."))
							HH.paralysis = min(HH.paralysis + 5, 10)
						else
							if (prob(65))
								HH.weakened = min(HH.weakened + 3, 10)
								HH.stuttering = min(HH.stuttering + 3, 10)
						if (istype(H)) H.blood_tracking_output()

				if (istype(H)) H.check_for_unlocks()

			else
				boutput(M, __red("[HH] doesn't have enough blood left to drink."))
				if (istype(H)) H.vamp_isbiting = null
				HH.vamp_beingbitten = 0
				return 0

		boutput(M, __red("Your feast was interrupted."))
		if (istype(H)) H.vamp_isbiting = null
		if (HH) HH.vamp_beingbitten = 0 // Victim might have been gibbed, who knowns.
		return 0