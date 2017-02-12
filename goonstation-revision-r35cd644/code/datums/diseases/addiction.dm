// Addiction with comically-exaggerated withdrawal effects!

/datum/ailment/addiction
	name = "reagent addiction"
	scantype = "Chemical Dependency"
	max_stages = 5
	cure = "Time"
	affected_species = list("Human")

/datum/ailment/addiction/stage_act(var/mob/living/affected_mob,var/datum/ailment_data/addiction/D)
	if (..())
		return
	if(prob(20) && (world.timeofday > (D.last_reagent_dose + D.withdrawal_duration)))
		boutput(affected_mob, "<span style=\"color:blue\">You no longer feel reliant on [D.associated_reagent]!</span>")
		affected_mob.ailments -= D
		qdel(D)
		return
	switch(D.stage)
		if(2)
			if(prob(8))
				affected_mob.emote("shiver")
			if(prob(8))
				affected_mob.emote("sneeze")
			if(prob(4))
				boutput(affected_mob, "<span style=\"color:blue\">You feel a dull headache.</span>")
		if(3)
			if(prob(8))
				affected_mob.emote("twitch_s")
			if(prob(8))
				affected_mob.emote("shiver")
			if(prob(4))
				boutput(affected_mob, "<span style=\"color:red\">You begin craving [D.associated_reagent]!</span>")
		if(4)
			if(prob(8))
				affected_mob.emote("twitch")
			if(prob(4))
				boutput(affected_mob, "<span style=\"color:red\">You have the strong urge for some [D.associated_reagent]!</span>")
			if(prob(4))
				boutput(affected_mob, "<span style=\"color:red\">You REALLY crave some [D.associated_reagent]!</span>")
		if(5)
			if(prob(8))
				affected_mob.emote("twitch")
			if(prob(6))
				if (affected_mob.nutrition > 10)
					affected_mob.visible_message("<span style=\"color:red\">[affected_mob] vomits on the floor profusely!</span>")
					playsound(affected_mob.loc, "sound/effects/splat.ogg", 50, 1)
					new /obj/decal/cleanable/vomit(affected_mob.loc)
					affected_mob.nutrition -= rand(3,5)
				else
					boutput(affected_mob, "<span style=\"color:red\">Your stomach lurches painfully!</span>")
					affected_mob.visible_message("<span style=\"color:red\">[affected_mob] gags and retches!</span>")
					affected_mob.stunned += rand(2,4)
					affected_mob.weakened += rand(2,4)
			if(prob(5))
				boutput(affected_mob, "<span style=\"color:red\">You feel like you can't live without [D.associated_reagent]!</span>")
			if(prob(5))
				boutput(affected_mob, "<span style=\"color:red\">You would DIE for some [D.associated_reagent] right now!</span>")