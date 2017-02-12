/datum/targetable/spell/clairvoyance
	name = "Clairvoyance"
	desc = "Finds the location of a target."
	icon_state = "clairvoyance"
	targeted = 0
	cooldown = 600
	requires_robes = 1
	cooldown_staff = 1

	cast()
		if(!holder)
			return
		holder.owner.say("HAIDAN SEEHQ")
		playsound(holder.owner.loc, "sound/voice/wizard/ClairvoyanceLoud.ogg", 50, 0, -1)

		var/list/mob/targets = list()
		for (var/mob/living/carbon/human/H in world)
			targets += H

		if (targets.len > 1)
			targets = sortNames(targets)

		var/t1 = input(holder.owner, "Select target", "Clairvoyance") as null|anything in targets
		if (!t1)
			return 1

		var/mob/M = targets[t1]
		if (!M || !ismob(M))
			return 1

		var/atom/target_loc = M.loc
		if (holder.owner.z == 2)
			if (M.z == 2)
				boutput(holder.owner, "<span style=\"color:blue\"><B>[M.real_name]</B> is in [target_loc.loc].</span>")
				return
			else
				boutput(holder.owner, "<span style=\"color:red\"><B>[M.real_name]</B> isn't in VR!</span>")
				return
		if (M.bioHolder.HasEffect("training_chaplain"))
			boutput(holder.owner, "<span style=\"color:red\">[M] has divine protection. Your scrying spell fails!</span>")
			boutput(M, "<span style=\"color:red\">You sense a Wizard's scrying spell!</span>")
		else
			var/spellstring = "<B>[M.real_name]</B> is "
			if (!istype(target_loc, /turf))
				if (target_loc.loc.name == "Chapel")
					spellstring = "<span style=\"color:red\">Your scrying spell fails! It just can't seem to find [M.real_name].</span>"
					boutput(M, "<span style=\"color:red\">You sense a Wizard's scrying spell!</span>")
					return
				if(istype(target_loc, /mob))
					spellstring += "somehow inside <b>[target_loc.name]</b> in <b>[target_loc.loc.loc]</b>."
				else if(istype(target_loc, /obj))
					spellstring += "inside \a <b>[target_loc.name]</b> in <b>[target_loc.loc.loc]</b>."
			else
				spellstring += "in [target_loc.loc]."
			if (M.stat == 2)
				spellstring += " They also seem to be dead."

			boutput(holder.owner, "<span style=\"color:blue\">[spellstring]</span>")
