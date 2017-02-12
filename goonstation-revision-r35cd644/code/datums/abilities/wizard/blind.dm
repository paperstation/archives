/datum/targetable/spell/blind
	name = "Blind"
	desc = "Makes the victim temporarily unable to see."
	icon_state = "blind"
	targeted = 1
	cooldown = 100
	requires_robes = 1
	offensive = 1
	sticky = 1

	cast(mob/target)
		if(!holder)
			return
		holder.owner.say("YSTIGG MITAZIM")
		playsound(holder.owner.loc, "sound/voice/wizard/BlindLoud.ogg", 50, 0, -1)

		var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
		s.set_up(4, 1, target)
		s.start()

		if (target.bioHolder.HasEffect("training_chaplain"))
			boutput(holder.owner, "<span style=\"color:red\">[target] has divine protection from magic.</span>")
			target.visible_message("<span style=\"color:red\">The spell fails to work on [target]!</span>")
			return

		if (iswizard(target) && target.wizard_spellpower())
			target.visible_message("<span style=\"color:red\">The spell fails to work on [target]!</span>")
			return

		var/obj/overlay/B = new /obj/overlay(target.loc)
		B.icon_state = "blspell"
		B.icon = 'icons/obj/wizard.dmi'
		B.name = "spell"
		B.anchored = 1
		B.density = 0
		B.layer = MOB_EFFECT_LAYER
		target.canmove = 0
		spawn(5)
			qdel(B)
			target.canmove = 1
		boutput(target, "<span style=\"color:blue\">Your eyes cry out in pain!</span>")
		target.visible_message("<span style=\"color:red\">Sparks fly out of [target]'s eyes!</span>")
		if (holder.owner.wizard_spellpower())
			target.weakened += 2
			target.bioHolder.AddEffect("bad_eyesight")
			spawn(450)
				if (target) target.bioHolder.RemoveEffect("bad_eyesight")
			target.take_eye_damage(10, 1)
			target.change_eye_blurry(20)
		else
			boutput(holder.owner, "<span style=\"color:red\">Your spell doesn't last as long without a staff to focus it!</span>")
			target.weakened += 1
			target.bioHolder.AddEffect("bad_eyesight")
			spawn(300)
				target.bioHolder.RemoveEffect("bad_eyesight")
			target.take_eye_damage(5, 1)
			target.change_eye_blurry(10)
