/datum/targetable/spell/kill
	name = "Shocking Grasp"
	desc = "Kills the victim with electrical power. Takes a few seconds to cast."
	icon_state = "grasp"
	targeted = 1
	max_range = 1
	cooldown = 600
	requires_robes = 1
	offensive = 1
	sticky = 1

	cast(mob/target)
		if(!holder)
			return
		holder.owner.visible_message("<span style=\"color:red\"><b>[holder.owner] begins to cast a spell on [target]!</b></span>")
		playsound(holder.owner.loc, "sound/effects/elec_bzzz.ogg", 25, 1, -1)
		if (do_mob(holder.owner, target, 20))
			holder.owner.say("EI NATH")
			playsound(holder.owner.loc, "sound/voice/wizard/ShockingGraspLoud.ogg", 50, 0, -1)
			playsound(holder.owner.loc, "sound/effects/elec_bigzap.ogg", 25, 1, -1)

			if (ishuman(target))
				if (target.bioHolder.HasEffect("training_chaplain"))
					boutput(holder.owner, "<span style=\"color:red\">[target] has divine protection from magic.</span>")
					target.visible_message("<span style=\"color:red\">The electric charge courses through [target] harmlessly!</span>")
					return
				else if (iswizard(target) && target.wizard_spellpower())
					target.visible_message("<span style=\"color:red\">The electric charge somehow completely misses [target]!</span>")
					return

			if (holder.owner.wizard_spellpower())
				var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
				s.set_up(4, 1, target)
				s.start()
				target.elecgib()
			else
				var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
				s.set_up(4, 1, target)
				s.start()
				boutput(holder.owner, "<span style=\"color:red\">Your spell is weak without a staff to focus it!</span>")
				target.visible_message("<span style=\"color:red\">[target] is severely burned by an electrical charge!</span>")
				target.lastattacker = holder.owner
				target.lastattackertime = world.time
				target.TakeDamage("chest", 0, 80, 0, DAMAGE_BURN)
				target.stunned += 10
				target.weakened += 10
				target.stuttering += 15
		else
			return 1 // no cooldown if it fails
