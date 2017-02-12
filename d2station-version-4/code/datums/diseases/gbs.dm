/datum/disease/gbs
	name = "GBS"
	max_stages = 5
	spread = "On contact"
	spread_type = CONTACT_GENERAL
	cure = "Synaptizine and Sulfur"
	cure_id = list("synaptizine","sulfur")
	cure_chance = 15//higher chance to cure, since two reagents are required
	affected_species = list("Human")
	affected_species2 = list(/mob/living/carbon/human)
	curable = 0
	permeability_mod = 1
	mutated = 0
	why_so_serious = 4
/datum/disease/gbs/stage_act()
	..()
	if(multiplier > 1)
		cure_chance = (cure_chance / multiplier)
	if(mutated)
		cure_id = null
		name = "Mutated GBS"
		cure = "GBS Vaccine"
	switch(stage)
		if(2)
			if(prob(45 * multiplier))
				affected_mob.toxloss += (5 * multiplier)
				affected_mob.updatehealth()
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
			affected_mob.toxloss += (5 * multiplier)
			affected_mob.updatehealth()
		if(5)
			affected_mob << "\red Your body feels as if it's trying to rip itself open..."
			if(prob(50 * multiplier))
				affected_mob.gib()
		else
			return