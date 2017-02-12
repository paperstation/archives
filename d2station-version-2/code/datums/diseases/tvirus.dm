/datum/disease/tvirus
	name = "Tyrant Virus"
	max_stages = 3
	spread = "On contact"
	spread_type = CONTACT_GENERAL
	cure = "None"
	cure_id = list("beer")
	cure_chance = 10
	permeability_mod = 30
	affected_species = list("Human")
	desc = "If left untreated the subject will become a zombie."
	severity = "High"

/datum/disease/tvirus/stage_act()
	..()
	switch(stage)
		if(2)
			if(prob(1))
				affected_mob << "\red You feel hungry."
			if(prob(5))
				affected_mob.bruteloss += 3
				affected_mob.bodytemperature += 1
				affected_mob.fireloss++
				affected_mob.updatehealth()
			if(prob(1))
				affected_mob << "\red Your muscles ache."
				if(prob(20))
					affected_mob.toxloss += 1
					affected_mob.updatehealth()

		if(3)
			if(prob(5))
				affected_mob.emote("cough")
			if(prob(1))
				affected_mob << "\red Your muscles ache."
			if(prob(4))
				affected_mob.bruteloss += 10
				affected_mob.updatehealth()
			if(prob(8))
				affected_mob.bodytemperature += 5
				affected_mob.fireloss++
			if(prob(1))
				affected_mob << "\red Your stomach hurts."
				if(prob(20))
					affected_mob.toxloss += 5
					affected_mob.updatehealth()
			if(prob(50))
				new /obj/livestock/zombie(affected_mob.loc)
				affected_mob.gib()
	return
