/datum/disease/plague
	name = "Plague"
	max_stages = 5
	spread = "On contact"
	spread_type = CONTACT_GENERAL
	cure = "None"
	cure_chance = 0
	affected_species = list("Human", "Monkey")
	affected_species2 = list(/mob/living/carbon/monkey, /mob/living/carbon/human)
	curable = 0
	mutated = 0
	multiplier = 1
	why_so_serious = 4
/datum/disease/plague/stage_act()
	..()
	switch(stage)
		if(2)
			if(prob(45 * multiplier))
				affected_mob.toxloss += (5 * multiplier)
				affected_mob.updatehealth()
			if(prob(10 * multiplier))
				affected_mob << "\red You feel swollen..."
		if(3)
			if(prob(5 * multiplier))
				affected_mob.emote("cough")
			else if(prob(5 * multiplier))
				affected_mob.emote("gasp")
			if(prob(3 * multiplier))
				affected_mob.emote("sneeze")
			if(prob(1 * multiplier))
				affected_mob << "\red You feel very sick..."
		if(4)
			if(prob(2 * multiplier))
				affected_mob.emote("cough")
			else if(prob(5 * multiplier))
				affected_mob.emote("gasp")
			if(prob(3 * multiplier))
				affected_mob.emote("sneeze")
			if(prob(4 * multiplier))
				affected_mob.emote("cough")
				affected_mob.toxloss += (5 * multiplier)
				affected_mob.bruteloss += (5 * multiplier)
				affected_mob.updatehealth()
		if(5)
			if(prob(5 * multiplier))
				affected_mob.emote("cough")
				new /obj/decal/cleanable/blood(affected_mob.loc)
				affected_mob.bruteloss += (5 * multiplier)
			else if(prob(5 * multiplier))
				affected_mob.emote("gasp")
			if(prob(1 * multiplier))
				affected_mob.emote("sneeze")
			if(prob(5 * multiplier))
				affected_mob.emote("sneeze")
			if(prob(5 * multiplier))
				affected_mob.bruteloss += (30 * multiplier)
				affected_mob.toxloss += (30 * multiplier)
				affected_mob.stunned += rand(2,4 * multiplier)
				affected_mob.weakened += rand(2,4 * multiplier)
				affected_mob.updatehealth()
		else
			return