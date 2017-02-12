/datum/disease/fluspanish
	name = "Spanish inquisition Flu"
	max_stages = 3
	spread = "Airborne"
	cure = "Spaceacillin & Anti-bodies to the common flu"
	cure_id = "spaceacillin"
	cure_chance = 10
	agent = "1nqu1s1t10n flu virion"
	affected_species = list("Human")
	permeability_mod = 0.75
	desc = "If left untreated the subject will burn to death for being a heretic."
	severity = "Serious"

/datum/disease/inquisition/stage_act()
	..()
	if(stage == 1)
		return
	switch(stage)
		if(2)
			affected_mob.bodytemperature += 10
		if(3)
			affected_mob.bodytemperature += 20
	if(prob(5))
		affected_mob.emote("sneeze")
	if(prob(5))
		affected_mob.emote("cough")
	if(prob(5))
		affected_mob << "\red You're burning up!"
		affected_mob.deal_damage(5, BURN)
	return
