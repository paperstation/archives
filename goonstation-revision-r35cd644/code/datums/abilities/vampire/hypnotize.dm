/datum/targetable/vampire/hypnotize
	name = "Hypnotize"
	desc = "KO's the target for a long time. Takes a few seconds to cast."
	targeted = 1
	target_nodamage_check = 1
	max_range = 1
	cooldown = 1200
	pointCost = 25
	when_stunned = 0
	not_when_handcuffed = 0

	cast(mob/target)
		if (!holder)
			return 1

		var/mob/living/M = holder.owner
		var/datum/abilityHolder/vampire/H = holder

		if (!M || !target || !ismob(target))
			return 1

		if (M == target)
			boutput(M, __red("Why would you want to stun yourself?"))
			return 1

		if (get_dist(M, target) > src.max_range)
			boutput(M, __red("[target] is too far away."))
			return 1

		if (target.stat == 2)
			boutput(M, __red("It would be a waste of time to stun the dead."))
			return 1

		if (!isliving(target) || (isliving(target) && issilicon(target)))
			boutput(M, __red("This spell would have no effect on [target]."))
			return 1

		if (!M.sight_check(1))
			boutput(M, __red("How do you expect this to work? You can't use your eyes right now."))
			M.visible_message("<span style=\"color:red\">What was that? There's something odd about [M]'s eyes.</span>")
			if (istype(H)) H.blood_tracking_output(src.pointCost)
			return 0 // Cooldown because spam is bad.

		M.visible_message("<span style=\"color:red\"><B>[M] stares into [target]'s eyes!</B></span>")
		boutput(M, __red("You have to stand still..."))

		if (do_mob(M, target, 20))
			if (target.bioHolder && target.bioHolder.HasEffect("training_chaplain"))
				boutput(target, __blue("Your faith protects you from [M]'s dark designs!"))
				target.visible_message("<span style=\"color:red\"><b>[target] just stares right back at [M]!</b></span>")

			else if (target.sight_check(1)) // Can't stare through a blindfold very well, no?
				boutput(target, __red("Your consciousness is overwhelmed by [M]'s dark glare!"))
				boutput(M, __blue("Your piercing gaze knocks out [target]."))
				target.stunned = max(target.stunned, 50)
				target.weakened = max(target.weakened, 50)
				target.paralysis = max(target.paralysis, 33)
		else
			boutput(M, __red("Your attempt to hypnotize the target was interrupted!"))

		if (istype(H)) H.blood_tracking_output(src.pointCost)
		logTheThing("combat", M, target, "uses hypnotise on [target ? "%target%" : "*UNKNOWN*"] at [log_loc(M)].") // Target might have been gibbed, who knows.
		return 0