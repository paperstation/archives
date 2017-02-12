/datum/disease/ebola
	name = "Ebola"
	max_stages = 4
	spread = "On contact"
	spread_type = CONTACT_GENERAL
	cure = "None"
	cure_id = list("capsaicin","spaceacillin")
	cure_chance = 10
	affected_species = list("Human", "Monkey")
	affected_species2 = list(/mob/living/carbon/monkey, /mob/living/carbon/human)
	desc = "If left untreated the subject will die."
	severity = "Extreme"
	mutated = 0
	why_so_serious = 3
/datum/disease/ebola/stage_act()
	..()
	if(multiplier > 1)
		cure_chance = (cure_chance / multiplier)
	if(mutated)
		cure_id = null
		name = "Mutated	Ebola"
		cure = "Ebola Vaccine"
	switch(stage)
		if(2)
			if(prob(5 * multiplier))
				affected_mob.emote("cough")
			if(prob(1 * multiplier))
				affected_mob << "\red You feel weak."
			if(prob(10 * multiplier))
				affected_mob.bruteloss += (10 * multiplier)
				affected_mob.bodytemperature += (3 * multiplier)
				affected_mob.fireloss += (1 * multiplier)
				affected_mob.updatehealth()
			if(prob(1 * multiplier))
				affected_mob << "\red Your muscles ache."
				if(prob(10 * multiplier))
					affected_mob.toxloss += (1 * multiplier)
					affected_mob.updatehealth()

		if(3)
			if(prob(5 * multiplier))
				affected_mob.emote("cough")
			if(prob(1 * multiplier))
				affected_mob << "\red Your muscles ache."
			if(prob(3 * multiplier))
				affected_mob.bruteloss += (20 * multiplier)
				affected_mob.updatehealth()
			if(prob(5 * multiplier))
				affected_mob.stunned += rand(1,2 * multiplier)
				affected_mob.weakened += rand(1,2 * multiplier)
				affected_mob.bodytemperature += (20 * multiplier)
				affected_mob.fireloss += (1 * multiplier)
			if(prob(1 * multiplier))
				affected_mob << "\red Your stomach hurts."
				if(prob(20 * multiplier))
					affected_mob.toxloss += (5 * multiplier)
					affected_mob.updatehealth()
			if(prob(7 * multiplier))
				new /obj/decal/cleanable/blood(affected_mob.loc)
		if(4)
			if(prob(10 * multiplier))
				affected_mob.bruteloss += (100 * multiplier)
				affected_mob.toxloss += (10 * multiplier)
				affected_mob.updatehealth()
			if(prob(10 * multiplier))
				affected_mob.bodytemperature += (100 * multiplier)
				affected_mob.fireloss += (1 * multiplier)
				affected_mob.updatehealth()
	return
