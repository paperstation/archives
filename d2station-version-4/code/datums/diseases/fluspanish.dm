/datum/disease/fluspanish
	name = "Spanish inquisition Flu"
	max_stages = 3
	spread = "Airborne"
	cure = "Spaceacillin and Anti-bodies to the common flu"
	cure_id = "spaceacillin"
	cure_chance = 10
	affected_species = list("Human")
	affected_species2 = list(/mob/living/carbon/human)
	permeability_mod = 0.75
	desc = "If left untreated the subject will burn to death for being a heretic."
	severity = "Serious"
	mutated = 0
	why_so_serious = 1
/datum/disease/inquisition/stage_act()
	..()
	if(multiplier > 1)
		cure_chance = (cure_chance / multiplier)
	if(mutated)
		cure_id = null
		name = "Mutated Spanish inquisition Flu"
		cure = "Spanish inquisition Flu Vaccine"
	switch(stage)
		if(2)
			affected_mob.bodytemperature += (10 * multiplier)
			if(prob(5 * multiplier))
				affected_mob.emote("sneeze")
			if(prob(5 * multiplier))
				affected_mob.emote("cough")
			if(prob(1 * multiplier))
				affected_mob << "\red You're burning in your own skin!"
				affected_mob.take_organ_damage(0,5 * multiplier)

		if(3)
			affected_mob.bodytemperature += (20 * multiplier)
			if(prob(5 * multiplier))
				affected_mob.emote("sneeze")
			if(prob(5 * multiplier))
				affected_mob.emote("cough")
			if(prob(5 * multiplier))
				affected_mob << "\red You're burning in your own skin!"
				affected_mob.take_organ_damage(0,5 * multiplier)
	return
