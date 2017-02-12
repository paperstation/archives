/datum/disease/fake_gbs
	name = "GBS"
	max_stages = 5
	spread = "On contact"
	spread_type = CONTACT_GENERAL
	cure = "Synaptizine and Sulfur"
	cure_id = list("synaptizine","sulfur")
	affected_species = list("Human", "Monkey")
	affected_species2 = list(/mob/living/carbon/monkey, /mob/living/carbon/human)
	desc = "If left untreated death will occur."
	severity = "Major"
	why_so_serious = 1
/datum/disease/fake_gbs/stage_act()
	..()
	if(multiplier > 1)
		cure_chance = (cure_chance / multiplier)
	switch(stage)
		if(2)
			if(prob(1 * multiplier))
				affected_mob.emote("sneeze")
		if(3)
			if(prob(5 * multiplier))
				affected_mob.emote("cough")
			else if(prob(5 * multiplier))
				affected_mob.emote("gasp")
			if(prob(10 * multiplier))
				affected_mob << "\red You're starting to feel very weak..."
		if(4)
			if(prob(10 * multiplier))
				affected_mob.emote("cough")

		if(5)
			if(prob(10 * multiplier))
				affected_mob.emote("cough")
