/datum/disease/inhalational_anthrax
	name = "Anthrax"
	max_stages = 4
	spread = "Airborne"
	cure = "Synaptizine and Spaceacillin"
	cure_id = list("synaptizine","spaceacillin")
	cure_chance = 10
	affected_species = list("Human", "Monkey")
	affected_species2 = list(/mob/living/carbon/monkey, /mob/living/carbon/human)
	desc = "If left untreated the subject will die."
	severity = "High"
	mutated = 0
	why_so_serious = 4
/datum/disease/inhalational_anthrax/stage_act()
	..()
	switch(stage)
		if(2)
			if(prob(1 * multiplier))
				affected_mob.emote("sneeze")
			if(prob(1 * multiplier))
				affected_mob.emote("cough")
			if(prob(1 * multiplier))
				affected_mob << "\red Your body aches."
			if(prob(5 * multiplier))
				affected_mob.bruteloss += (2 * multiplier)
				affected_mob.bodytemperature += (3 * multiplier)
				affected_mob.fireloss += (1 * multiplier)
				affected_mob.updatehealth()
			if(prob(1 * multiplier))
				affected_mob << "\red Your stomach hurts."
				if(prob(10 * multiplier))
					affected_mob.toxloss += (5 * multiplier)
					affected_mob.updatehealth()

		if(3)
			if(prob(1 * multiplier))
				affected_mob.emote("sneeze")
				new /obj/decal/cleanable/blood(affected_mob.loc)
			if(prob(1 * multiplier))
				affected_mob.emote("cough")
				new /obj/decal/cleanable/blood(affected_mob.loc)
			if(prob(1 * multiplier))
				affected_mob << "\red Your muscles ache."
			if(prob(10 * multiplier))
				affected_mob.bruteloss += (20 * multiplier)
				affected_mob.updatehealth()
			if(prob(5 * multiplier))
				affected_mob.stunned += rand(2,5 * multiplier)
				affected_mob.weakened += rand(2,5 * multiplier)
				affected_mob.bodytemperature += (20 * multiplier)
				affected_mob.fireloss += (1 * multiplier)
			if(prob(1 * multiplier))
				affected_mob << "\red Your stomach hurts."
				if(prob(20 * multiplier))
					affected_mob.toxloss += (10 * multiplier)
					affected_mob.updatehealth()
		if(4)
			if(prob(10 * multiplier))
				affected_mob.bruteloss += (3 * multiplier)
				affected_mob.toxloss += (2 * multiplier)
				affected_mob.bodytemperature += (5 * multiplier)
				affected_mob.fireloss += (3 * multiplier)
				affected_mob.updatehealth()
	return
