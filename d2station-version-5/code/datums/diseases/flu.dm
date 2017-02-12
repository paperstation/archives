/datum/disease/flu
	name = "Flu"
	max_stages = 3
	spread = "Airborne"
	cure = "Spaceacillin"
	cure_id = "spaceacillin"
	cure_chance = 10
	affected_species = list("Human", "Monkey")
	affected_species2 = list(/mob/living/carbon/monkey, /mob/living/carbon/human)
	permeability_mod = 0.75
	desc = "If left untreated the subject will feel quite unwell."
	severity = "Medium"
	mutated = 0
	why_so_serious = 1
/datum/disease/flu/stage_act()
	..()
	if(multiplier > 1)
		cure_chance = (cure_chance / multiplier)
	if(mutated)
		cure_id = null
		name = "Mutated	Flu"
		cure = "Flu Vaccine"
	switch(stage)
		if(2)
			if(affected_mob.sleeping && prob(20 * multiplier))
				affected_mob << "\blue You feel better."
				stage--
				return
			if(prob(1 * multiplier))
				affected_mob.emote("sneeze")
			if(prob(1 * multiplier))
				affected_mob.emote("cough")
			if(prob(1 * multiplier))
				affected_mob << "\red Your muscles ache."
				if(prob(20 * multiplier))
					affected_mob.take_organ_damage(1 * multiplier)
			if(prob(1 * multiplier))
				affected_mob << "\red Your stomach hurts."
				if(prob(20 * multiplier))
					affected_mob.toxloss += (1 * multiplier)
					affected_mob.updatehealth()

		if(3)
			if(affected_mob.sleeping && prob(15 * multiplier))
				affected_mob << "\blue You feel better."
				stage--
				return
			if(prob(1 * multiplier))
				affected_mob.emote("sneeze")
			if(prob(1 * multiplier))
				affected_mob.emote("cough")
			if(prob(1 * multiplier))
				affected_mob << "\red Your muscles ache."
				if(prob(20 * multiplier))
					affected_mob.take_organ_damage(1)
			if(prob(1 * multiplier))
				affected_mob << "\red Your stomach hurts."
				if(prob(20 * multiplier))
					affected_mob.toxloss += 1
					affected_mob.updatehealth()
	return
