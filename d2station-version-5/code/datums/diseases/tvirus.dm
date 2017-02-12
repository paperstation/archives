/datum/disease/tvirus
	name = "Tyrant Virus"
	max_stages = 5
	spread = "On bite"
	spread_type = SPECIAL
	cure = "None"
	cure_id = list("beer", "space_drugs", "spaceacillin")
	cure_chance = 10
	permeability_mod = 30
	affected_species = list("Human")
	affected_species2 = list(/mob/living/carbon/human)
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
				affected_mob.brainloss = 0
				affected_mob.fireloss++
				affected_mob.updatehealth()
			if(prob(1))
				affected_mob << "\red Your muscles ache."
				if(prob(20))
					affected_mob.toxloss += 1
					affected_mob.updatehealth()
			if((affected_mob:mutantrace) && (affected_mob:mutantrace == "zombie"))
				affected_mob:mutantrace = ""
				affected_mob.miming = 0
				affected_mob:mutations = ""
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
		if(4)
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
					affected_mob.toxloss += 5
					affected_mob.updatehealth()
		if(5)
			if(affected_mob:mutantrace != "zombie" && affected_mob.health < 80)
				affected_mob.stunned += rand(1,3)
				affected_mob.weakened += rand(1,3)
				var/mob/dead/observer/temp_ghost = new(affected_mob)
				temp_ghost.key = affected_mob.key
				temp_ghost.mind = affected_mob.mind
				affected_mob.key = null
				affected_mob.mind = null
				sleep(5)
				affected_mob:mutantrace = "zombie"
				affected_mob:ai_init_zombie()
				affected_mob:update_body()
				affected_mob:update_face()
	return


