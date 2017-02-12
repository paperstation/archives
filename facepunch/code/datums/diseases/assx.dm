//Nanomachines!

/datum/disease/assinspection
	name = "GBA"
	max_stages = 3
	spread_type = SPECIAL
	cure_chance = 5
	agent = "Ass induced stomach pains."
	affected_species = list("Human")
	desc = "Report to Medical Bay for Ass Inspection"
	severity = "It will eventually pass out of your system, with your ass as well."
	var/gibbed = 0

/datum/disease/assinspection/stage_act()
	..()
	switch(stage)
		if(2)
			if(prob(10))
				affected_mob << "\red Your feel a lot of pressure behind you."
				affected_mob.deal_damage(5, BRUTE)
			if(prob(10))
				affected_mob.say(pick("WOOP!", "ASS INSPECTION!", "SON OF A CLOWN IT HURTS!", "WOOP WOOP!", "SON OF A COMDOM!", "BRING ME TO THE MEDICAL BAY!", "I NEED AN ASS INSPECTION!" ))
			else if(prob(10))
				affected_mob.say(pick(";WOOP!", ";ASS INSPECTION!", ";SON OF A CLOWN IT HURTS!", ";WOOP WOOP!", ";SON OF A COMDOM!", ";BRING ME TO THE MEDICAL BAY!", ";I NEED AN ASS INSPECTION!" ))
			else if(prob(8))
				affected_mob << "\red Oh the pain! The cruel, yet ironic, pain!."
		if(3)
			affected_mob.physeffect |= ASSLESS
			affected_mob.deal_damage(40, BRUTE, null, "chest")
			if(src.gibbed != 0) return 0
			var/turf/T = find_loc(affected_mob)
			gibs(T)
			src.cure(0)



/datum/disease/assinspectionplacebo
	name = "GBA"
	max_stages = 3
	spread = "Syringe"
	spread_type = SPECIAL
	cure_chance = 5
	agent = "Ass induced stomach pains."
	affected_species = list("Human")
	desc = "Report to Medical Bay for Ass Inspection"
	severity = "It will eventually pass out of your system, with your ass as well."
	var/gibbed = 0

/datum/disease/assinspectionplacebo/stage_act()
	..()
	switch(stage)
		if(2)
			if(prob(10))
				affected_mob << "\red Your feel a lot of pressure behind you."
				affected_mob.deal_damage(5, BRUTE)
			else if(prob(10))
				affected_mob.say(pick("WOOP!", "ASS INSPECTION!", "SON OF A CLOWN IT DOESN'T HURT!", "WOOP WOOP!", "SON OF A COMDOM!", "BRING ME TO THE MEDICAL BAY!", "I NEED AN ASS INSPECTION!" ))
			else if(prob(10))
				affected_mob.say(pick(";WOOP!", ";ASS INSPECTION!", ";SON OF A CLOWN IT DOESN'T HURT", ";WOOP WOOP!", ";SON OF A COMDOM!", ";BRING ME TO THE MEDICAL BAY!", ";I NEED AN ASS INSPECTION!" ))
			else if(prob(8))
				affected_mob << "\red Oh the pain! The cruel, yet ironic, pain!."
		if(3)
			affected_mob <<"\red You feel you should get an Ass Inspection in Medical Bay."
			affected_mob.say(pick("WHY DO I STILL HAVE AN ASS!?!", "FUCK ITS FAKE!" ))
			src.cure(0)