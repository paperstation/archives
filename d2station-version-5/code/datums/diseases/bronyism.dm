/*/datum/disease/bronyism
	name = "Bronyism"
	max_stages = 4
	spread = "Unknown"
	spread_type = CONTACT_GENERAL
	cure = "Death of the patient, and then disposal of the body."
	curable = 0
	affected_species = list("Human")
	desc = "The subject has turned into the bane of humanity, destroy it."
	severity = "Apocalyptic"
	longevity = 900000

/datum/disease/bronyism/stage_act()
	..()
	switch(stage)
		if(1)
			if(prob(3)) affected_mob << "\red You feel a desire to be retarded."
			affected_mob.mutantrace = "brony"
				if (affected_mob.mutantrace == "brony")
					stage_act()
		if(2)
			if(prob(3))
				affected_mob.say("OMG FLUTTERSHY")
			affected_mob.flaming = 25
			if(prob(6)) affected_mob.emote("superfart")
			if (affected_mob.butt_op_stage == 4)
				stage_act()
		if(3)
			if(prob(5)) affected_mob.say("LOOK AT MY CUTIE MARK")
			if(prob(7))stage_act()
		if(4)
			affected_mob.nutrition = 3000 // i hope this makes them fat -- ds*/

			// this needs fixing because i suck or i just can't perform when sleepy as shit