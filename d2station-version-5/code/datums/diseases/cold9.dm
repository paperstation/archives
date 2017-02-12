/datum/disease/cold9
	name = "Cold"
	max_stages = 3
	spread = "On contact"
	spread_type = CONTACT_GENERAL
	cure = "Common Cold Anti-bodies and Spaceacillin"
	cure_id = "spaceacillin"
	affected_species = list("Human")
	affected_species2 = list(/mob/living/carbon/human)
	desc = "If left untreated the subject will slow, as if partly frozen."
	severity = "Moderate"
	mutated = 0
	why_so_serious = 0
/datum/disease/cold9/stage_act()
	..()
	switch(stage)
		if(2)
			affected_mob.bodytemperature -= (10 * multiplier)
			if(prob(1) && prob(10 / multiplier))
				affected_mob << "\blue You feel better."
				src.cure()
				return
			if(prob(1 * multiplier))
				affected_mob.emote("sneeze")
			if(prob(1 * multiplier))
				affected_mob.emote("cough")
			if(prob(1 * multiplier))
				affected_mob << "\red Your throat feels sore."
			if(prob(5 * multiplier))
				affected_mob << "\red You feel stiff."
		if(3)
			affected_mob.bodytemperature -= (20 * multiplier)
			if(prob(1 * multiplier))
				affected_mob.emote("sneeze")
			if(prob(1 * multiplier))
				affected_mob.emote("cough")
			if(prob(1 * multiplier))
				affected_mob << "\red Your throat feels sore."
			if(prob(10 * multiplier))
				affected_mob << "\red You feel stiff."