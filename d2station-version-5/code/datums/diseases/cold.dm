/datum/disease/cold
	name = "Cold"
	max_stages = 3
	spread = "Airborne"
	cure = "Rest and Spaceacillin"
	cure_id = "spaceacillin"
	affected_species2 = list(/mob/living/carbon/monkey, /mob/living/carbon/human)
	affected_species = list("Human", "Monkey")
	permeability_mod = 0.5
	desc = "If left untreated the subject will contract the flu."
	severity = "Minor"
	mutated = 0
	why_so_serious = 0
/datum/disease/cold/stage_act()
	..()
	switch(stage)
		if(2)
			if(affected_mob.sleeping && prob(40))
				affected_mob << "\blue You feel better."
				src.cure()
				return
			if(prob(1) && prob(10))
				affected_mob << "\blue You feel better."
				src.cure()
				return
			if(prob(1))
				affected_mob.emote("sneeze")
			if(prob(1))
				affected_mob.emote("cough")
			if(prob(1))
				affected_mob << "\red Your throat feels sore."
			if(prob(1))
				affected_mob << "\red Mucous runs down the back of your throat."
		if(3)
			if(affected_mob.sleeping && prob(25))
				affected_mob << "\blue You feel better."
				src.cure()
				return
			if(prob(1) && prob(10))
				affected_mob << "\blue You feel better."
				src.cure()
			if(prob(1))
				affected_mob.emote("sneeze")
			if(prob(1))
				affected_mob.emote("cough")
			if(prob(1))
				affected_mob << "\red Your throat feels sore."
			if(prob(1))
				affected_mob << "\red Mucous runs down the back of your throat."
			if(prob(1) && prob(50))
				if(!affected_mob.resistances.Find(/datum/disease/flu))
					var/datum/disease/Flu = new /datum/disease/flu(0)
					affected_mob.contract_disease(Flu,1)