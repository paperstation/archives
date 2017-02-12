/datum/disease/spaceaids
	name = "AIDS"
	max_stages = 10
	spread = "Oral"
	spread_type = SPECIAL
	cure = "None"
	cure_id = list("synaptizine","spaceacillin")
	cure_chance =1
	affected_species = list("Human", "Monkey")
	affected_species2 = list(/mob/living/carbon/monkey, /mob/living/carbon/human)
	permeability_mod = 0.75
	desc = "If left untreated the subject will feel quite unwell and have a short life span."
	severity = "Medium"
	mutated = 0
	why_so_serious = 3
/datum/disease/spaceaids/stage_act()
	..()
	if(multiplier > 1)
		cure_chance = (cure_chance / multiplier)
	if(mutated)
		cure_id = null
		name = "Mutated	AIDS"
		cure = "AIDS Vaccine"
	switch(stage)
		if(2)
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
		if(4)
			if(prob(3 * multiplier))
				affected_mob.nutrition -= 1
			if(prob(1 * multiplier))
				affected_mob << "\red Your throat feels swollen."
		if(5)
			if(prob(1 * multiplier))
				affected_mob << "\red Your muscles ache."
				if(prob(20 * multiplier))
					affected_mob.take_organ_damage(1)

			if(prob(3 * multiplier))
				affected_mob.nutrition -= 1
			if(prob(1 * multiplier))
				affected_mob << "\red Your throat feels swollen."

		if(6)
			if(prob(1 * multiplier))
				affected_mob << "\red Your muscles ache."
				if(prob(20 * multiplier))
					affected_mob.take_organ_damage(1)

			if(prob(3 * multiplier))
				affected_mob.nutrition -= 1
			if(prob(1 * multiplier))
				affected_mob << "\red Your throat feels swollen."
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
		if(7)
			if(prob(1 * multiplier))
				affected_mob << "\red Your muscles ache."
				if(prob(20 * multiplier))
					affected_mob.take_organ_damage(1)

			if(prob(3 * multiplier))
				affected_mob.nutrition -= 1
			if(prob(1 * multiplier))
				affected_mob << "\red Your throat feels swollen."
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
		if(8)
			if(prob(1 * multiplier))
				affected_mob.emote("sneeze")
			if(prob(1 * multiplier))
				affected_mob.emote("cough")
			if(prob(1 * multiplier))
				affected_mob.emote("gasp")
			if(prob(1 * multiplier))
				affected_mob << "\red Your muscles ache."
				if(prob(20 * multiplier))
					affected_mob.bruteloss += (1 * multiplier)
					affected_mob.updatehealth()
			if(prob(1 * multiplier))
				affected_mob << "\red Your head hurts."
				if(prob(20 * multiplier))
					affected_mob.toxloss += (1 * multiplier)
					affected_mob.updatehealth()
			if (prob(3 * multiplier))
				affected_mob.emote("vomit")
			if(prob(1 * multiplier))
				affected_mob << "\red Your stomach hurts."
				if(prob(20 * multiplier))
					affected_mob.toxloss += (1 * multiplier)
					affected_mob.updatehealth()
			if(prob(1 * multiplier))
				affected_mob << "\red Your feel tired."
				if(prob(20 * multiplier))
					affected_mob.toxloss += (1 * multiplier)
					affected_mob.bodytemperature += (1 * multiplier)
					affected_mob.updatehealth()
				if(prob(10 * multiplier))
					affected_mob.paralysis = rand(3,5 * multiplier)
			if(prob(1 * multiplier))
				if(prob(3 * multiplier))
					playsound(affected_mob.loc, 'poo2.ogg', 50, 1)
					for(var/mob/O in viewers(affected_mob, null))
						O.show_message(text("\red [] has an uncontrollable diarrhea!", affected_mob), 1)
//					new /obj/item/weapon/reagent_containers/food/snacks/poo(affected_mob.loc)
					new /obj/decal/cleanable/poo(affected_mob.loc)
		if(9)
			if(prob(1 * multiplier))
				affected_mob.emote("sneeze")
			if(prob(1 * multiplier))
				affected_mob.emote("cough")
			if(prob(1 * multiplier))
				affected_mob.emote("gasp")
			if(prob(1 * multiplier))
				affected_mob << "\red Your muscles ache."
				if(prob(20 * multiplier))
					affected_mob.bruteloss += (1 * multiplier)
					affected_mob.updatehealth()
			if(prob(1 * multiplier))
				affected_mob << "\red Your head hurts."
				if(prob(20 * multiplier))
					affected_mob.toxloss += (1 * multiplier)
					affected_mob.updatehealth()
			if (prob(3 * multiplier))
				affected_mob.emote("vomit")
			if(prob(1 * multiplier))
				affected_mob << "\red Your stomach hurts."
				if(prob(20 * multiplier))
					affected_mob.toxloss += (1 * multiplier)
					affected_mob.updatehealth()
			if(prob(1 * multiplier))
				affected_mob << "\red Your feel tired."
				if(prob(20 * multiplier))
					affected_mob.toxloss += (1 * multiplier)
					affected_mob.bodytemperature += (1 * multiplier)
					affected_mob.updatehealth()
				if(prob(10 * multiplier))
					affected_mob.paralysis = rand(3,5 * multiplier)
			if(prob(1 * multiplier))
				affected_mob << "\red Your muscles ache."
				if(prob(20 * multiplier))
					affected_mob.take_organ_damage(1)
			if(prob(3 * multiplier))
				affected_mob.nutrition -= 1
			if(prob(1 * multiplier))
				affected_mob << "\red Your throat feels swollen."
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
		if(10)
			if(prob(1 * multiplier))
				affected_mob.emote("sneeze")
			if(prob(1 * multiplier))
				affected_mob.emote("cough")
			if(prob(1 * multiplier))
				affected_mob.emote("gasp")
			if(prob(1 * multiplier))
				affected_mob << "\red Your muscles ache."
				if(prob(20 * multiplier))
					affected_mob.bruteloss += (1 * multiplier)
					affected_mob.updatehealth()
			if(prob(1 * multiplier))
				affected_mob << "\red Your head hurts."
				if(prob(20 * multiplier))
					affected_mob.toxloss += (1 * multiplier)
					affected_mob.updatehealth()
			if (prob(3 * multiplier))
				affected_mob.emote("vomit")
			if(prob(1 * multiplier))
				affected_mob << "\red Your stomach hurts."
				if(prob(20 * multiplier))
					affected_mob.toxloss += (1 * multiplier)
					affected_mob.updatehealth()
			if(prob(1 * multiplier))
				affected_mob << "\red Your feel tired."
				if(prob(20 * multiplier))
					affected_mob.toxloss += (1 * multiplier)
					affected_mob.bodytemperature += (1 * multiplier)
					affected_mob.updatehealth()
				if(prob(10 * multiplier))
					affected_mob.paralysis = rand(3,5 * multiplier)
			if(prob(1 * multiplier))
				affected_mob << "\red Your muscles ache."
				if(prob(20 * multiplier))
					affected_mob.take_organ_damage(1)
			if(prob(3 * multiplier))
				affected_mob.nutrition -= 1
			if(prob(1 * multiplier))
				affected_mob << "\red Your throat feels swollen."
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
			if(prob(2 * multiplier))
				affected_mob.bruteloss += (2 * multiplier)
				affected_mob.toxloss += (2 * multiplier)
				affected_mob.bodytemperature += (5 * multiplier)
				affected_mob.fireloss += (4 * multiplier)
				affected_mob.updatehealth()
	return
