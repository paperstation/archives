/datum/disease/ebola
	name = "Ebola"
	max_stages = 4
	spread = "On contact"
	spread_type = CONTACT_GENERAL
	cure = "None"
	cure_id = list("capsaicin","spaceacillin")
	cure_chance = 10
	affected_species = list("Human", "Monkey", "Rat")
	desc = "If left untreated the subject will die."
	severity = "Extreme"

/datum/disease/ebola/stage_act()
	..()
	switch(stage)
		if(2)
			if(prob(5))
				affected_mob.emote("cough")
			if(prob(1))
				affected_mob << "\red You feel weak."
			if(prob(10))
				affected_mob.bruteloss += 10
				affected_mob.bodytemperature += 3
				affected_mob.fireloss++
				affected_mob.updatehealth()
			if(prob(1))
				affected_mob << "\red Your muscles ache."
				if(prob(10))
					affected_mob.toxloss += 1
					affected_mob.updatehealth()

		if(3)
			if(prob(5))
				affected_mob.emote("cough")
			if(prob(1))
				affected_mob << "\red Your muscles ache."
			if(prob(3))
				affected_mob.bruteloss += 20
				affected_mob.updatehealth()
			if(prob(5))
				affected_mob.stunned += rand(1,2)
				affected_mob.weakened += rand(1,2)
				affected_mob.bodytemperature += 20
				affected_mob.fireloss++
			if(prob(1))
				affected_mob << "\red Your stomach hurts."
				if(prob(20))
					affected_mob.toxloss += 5
					affected_mob.updatehealth()
			if(prob(7))
				new /obj/decal/cleanable/blood(affected_mob.loc)
		if(4)
			if(prob(10))
				affected_mob.bruteloss += 100
				affected_mob.toxloss += 10
				affected_mob.updatehealth()
			if(prob(10))
				affected_mob.bodytemperature += 100
				affected_mob.fireloss++
				affected_mob.updatehealth()
	return
