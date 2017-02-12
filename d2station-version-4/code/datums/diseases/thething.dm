
/datum/disease/the_thing
	name = "Unidentified Foreign Body"
	max_stages = 5
	spread = "None"
	spread_type = SPECIAL
	cure = "Unknown"
	cure_id = list("lexorin","toxin","gargleblaster")
	cure_chance = 20
	affected_species = list("Human", "Monkey")
	affected_species2 = list(/mob/living/carbon/monkey, /mob/living/carbon/human)
	permeability_mod = 3//likely to infect
	var/gibbed = 0
	stage_prob = 16
	var/mob/dead/observer/G = null
	var/infectedby = null
	var/no_old_host = 0
	var/list/absorbed_dna = list()
	var/olddna
	var/oldname
	why_so_serious = 5
/datum/disease/the_thing/stage_act()
	..()
	if(affected_mob.changeling_level >= 1)
		src.cure(0)
		return
	else
		switch(stage)
			if(2)
				if(prob(1))
					affected_mob.emote("sneeze")
				if(prob(1))
					affected_mob.emote("cough")
				if(prob(1))
					affected_mob << "\red Your throat feels sore."
				if(prob(1))
					affected_mob << "\red Mucous runs down the back of your throat."
			if(3)
				if(prob(1))
					affected_mob.emote("sneeze")
				if(prob(1))
					affected_mob.emote("cough")
				if(prob(1))
					affected_mob << "\red Your throat feels sore."
				if(prob(1))
					affected_mob << "\red Mucous runs down the back of your throat."
			if(4)
				if(prob(1))
					affected_mob.emote("sneeze")
				if(prob(1))
					affected_mob.emote("cough")
				if(prob(2))
					affected_mob << "\red Your muscles ache."
					if(prob(20))
						affected_mob.take_organ_damage(1)
				if(prob(2))
					affected_mob << "\red Your stomach hurts."
					if(prob(20))
						affected_mob.toxloss += 1
						affected_mob.updatehealth()
			if(5)
				affected_mob << "\red You don't feel like yourself..."
				affected_mob.toxloss += 10
				affected_mob.updatehealth()
				if(prob(100))
					ASSERT(gibbed == 0)
					var/list/candidates = list() // Picks a random ghost in the world to shove in the larva -- TLE
					for(var/mob/dead/observer/G in mobz)
						if(G.client)
							if(((G.client.inactivity/10)/60) <= 5)
								if(G.corpse) //hopefully will make adminaliums possible --Urist
									if(G.corpse.stat==2)
										candidates.Add(G)
								if(!G.corpse) //hopefully will make adminaliums possible --Urist
									candidates.Add(G)
					if(candidates.len)
						var/mob/living/carbon/human/new_changeling = new(affected_mob.loc)
						for(var/mob/dead/observer/A in candidates)
							if(A.key == infectedby)
								G = A
							else
								G = pick(candidates)
						new_changeling.mind_initialize(G)
						new_changeling.dna.uni_identity = affected_mob.dna.uni_identity
						new_changeling.dna.struc_enzymes = affected_mob.dna.struc_enzymes
						updateappearance(new_changeling, new_changeling.dna.uni_identity)
						domutcheck(new_changeling)
						new_changeling.real_name = affected_mob.real_name
						new_changeling.name = affected_mob.name
						new_changeling.key = G.key
						new_changeling.verbs += /client/proc/changeling_absorb_dna
						new_changeling.verbs += /client/proc/changeling_transform
						new_changeling.verbs += /client/proc/changeling_lesser_form
						new_changeling.verbs += /client/proc/changeling_fakedeath
						new_changeling.changeling_level = 2
						if (!new_changeling.absorbed_dna)
							new_changeling.absorbed_dna = list()
						if (new_changeling.absorbed_dna.len == 0)
							new_changeling.absorbed_dna = absorbed_dna
							new_changeling.absorbed_dna[new_changeling.real_name] = new_changeling.dna
							new_changeling.absorbed_dna[oldname] = olddna
						for(var/obj/item/W in affected_mob)
							affected_mob.drop_from_slot(W)
						var/turf/T = find_loc(affected_mob)
						gibs(T)
						new_changeling << "\red We are now complete..."
						new_changeling << "\blue You are now a changeling"
//						if(new_changeling.key == infectedby)
//							new_changeling.absorbed_dna[new_changeling.name] = new_changeling.dna
//							new_changeling.absorbed_dna[oldname] = olddna
//						else
//							new_changeling.absorbed_dna[new_changeling.name] = new_changeling.dna
						affected_mob.gib()
						del(G)

					else
						affected_mob << "\red We are now complete..."
						affected_mob.make_changeling()
						for(var/obj/item/W in affected_mob)
							affected_mob.drop_from_slot(W)
						spawn(1)
						affected_mob << "\blue You are now a changeling"
						var/turf/T = find_loc(affected_mob)
						gibs(T)
					src.cure(0)
					gibbed = 1


				/*
					if(affected_mob.client)
						affected_mob.client.mob = new/mob/living/carbon/alien/larva(affected_mob.loc)
					else
						new/mob/living/carbon/alien/larva(affected_mob.loc)
					affected_mob:gib()
				*/
					return

