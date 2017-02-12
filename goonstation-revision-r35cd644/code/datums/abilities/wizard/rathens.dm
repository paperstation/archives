/datum/targetable/spell/rathens
	name = "Rathen's Secret"
	desc = "Summons a powerful shockwave around you that tears the arses and limbs off of enemies."
	icon_state = "arsenath"
	targeted = 0
	cooldown = 500
	requires_robes = 1
	offensive = 1

	cast()
		if(!holder)
			return
		holder.owner.say("ARSE NATH!")
		playsound(holder.owner.loc, "sound/voice/wizard/RathensSecretLoud.ogg", 50, 0, -1)

		playsound(holder.owner, "sound/misc/superfart.ogg", 25, 1)

		for (var/mob/*living/carbon/human*//H in oview(holder.owner))
			if (H.bioHolder.HasEffect("training_chaplain"))
				boutput(usr, "<span style=\"color:red\">[H]'s butt has divine protection from magic.</span>")
				H.visible_message("<span style=\"color:red\">The spell fails to work on [H]!</span>")
				continue
			if (iswizard(H) && H.wizard_spellpower())
				H.visible_message("<span style=\"color:red\">[H] magically farts the spell away!</span>")
				playsound(H, "sound/vox/Poo.ogg", 25, 1)
				continue
			var/datum/effects/system/harmless_smoke_spread/smoke = new /datum/effects/system/harmless_smoke_spread()
			smoke.set_up(5, 0, H:loc)
			smoke.attach(H)
			smoke.start()
			ass_explosion(H, 1, 7)
// See bigfart.dm for the ass_explosion() proc. The third value represents the probability of limb loss in percent.