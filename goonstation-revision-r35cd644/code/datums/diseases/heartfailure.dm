/datum/ailment/disease/heartfailure
	name = "Cardiac Failure"
	scantype = "Medical Emergency"
	max_stages = 3
	spread = "The patient is having a cardiac emergency"
	cure = "Cardiac Stimulants"
	reagentcure = list("atropine","epinephrine")
	recureprob = 10
	affected_species = list("Human")
	stage_prob = 5
	var/robo_restart = 0

/datum/ailment/disease/heartfailure/stage_act(var/mob/living/affected_mob,var/datum/ailment_data/D)
	if (..())
		return

	if (ishuman(affected_mob))
		var/mob/living/carbon/human/H = affected_mob
		if (!H.organHolder)
			H.cure_disease(D)
			return
		if (!H.organHolder.heart)
			H.cure_disease(D)
			return
		else if (H.organHolder.heart && H.organHolder.heart.robotic && !H.organHolder.heart.broken && !src.robo_restart)
			boutput(H, "<span style=\"color:red\">Your cyberheart detects a cardiac event and attempts to return to its normal rhythm!</span>")
			if (prob(40) && H.organHolder.heart.emagged)
				H.cure_disease(D)
				src.robo_restart = 1
				if (H.organHolder.heart.emagged)
					spawn(200)
						src.robo_restart = 0
				else
					spawn(300)
						src.robo_restart = 0
				spawn(30)
					boutput(H, "<span style=\"color:red\">Your cyberheart returns to its normal rhythm!</span>")
					return
			else if (prob(25))
				H.cure_disease(D)
				src.robo_restart = 1
				if (H.organHolder.heart.emagged)
					spawn(200)
						src.robo_restart = 0
				else
					spawn(300)
						src.robo_restart = 0
				spawn(30)
					boutput(H, "<span style=\"color:red\">Your cyberheart returns to its normal rhythm!</span>")
					return
			else
				src.robo_restart = 1
				if (H.organHolder.heart.emagged)
					spawn(200)
						src.robo_restart = 0
				else
					spawn(300)
						src.robo_restart = 0
				spawn(30)
					boutput(H, "<span style=\"color:red\">Your cyberheart fails to return to its normal rhythm!</span>")

	switch (D.stage)
		if (1)
			if (prob(1) && prob(10))
				boutput(affected_mob, "<span style=\"color:blue\">You feel better.</span>")
				affected_mob.cure_disease(D)
				return
			if (prob(8)) affected_mob.emote(pick("pale", "shudder"))
			if (prob(5))
				boutput(affected_mob, "<span style=\"color:red\">Your arm hurts!</span>")
			else if (prob(5))
				boutput(affected_mob, "<span style=\"color:red\">Your chest hurts!</span>")
		if (2)
			if (prob(1) && prob(10))
				boutput(affected_mob, "<span style=\"color:blue\">You feel better.</span>")
				affected_mob.resistances += src.type
				affected_mob.ailments -= src
				return
			if (prob(8)) affected_mob.emote(pick("pale", "groan"))
			if (prob(5))
				boutput(affected_mob, "<span style=\"color:red\">Your heart lurches in your chest!</span>")
				affected_mob.losebreath++
			if (prob(3))
				boutput(affected_mob, "<span style=\"color:red\">Your heart stops beating!</span>")
				affected_mob.losebreath+=3
			if (prob(5)) affected_mob.emote(pick("faint", "collapse", "groan"))
		if (3)
			affected_mob.take_oxygen_deprivation(1)
			affected_mob.updatehealth()
			if (prob(8)) affected_mob.emote(pick("twitch", "gasp"))
			if (prob(5))
				affected_mob.contract_disease(/datum/ailment/disease/flatline,null,null,1)