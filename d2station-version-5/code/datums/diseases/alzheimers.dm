/datum/disease/alzheimers
	name = "Alzheimers Disease"
	max_stages = 2
	spread = "Acute"
	cure = "Alkysine and Ryetalyn"
	cure_id = list("alkysine", "Ryetalyn")
	cure_chance = 20
	affected_species = list("Human", "Monkey")
	affected_species2 = list(/mob/living/carbon/monkey, /mob/living/carbon/human)
	desc = "Subjects affected show the signs of memory loss and disorientation."
	severity = "Low"
	why_so_serious = 4
/datum/disease/alzheimers/stage_act()
	..()
	switch(stage)
		if(2)
			if(prob(1))
				if(prob(20))
					affected_mob << "\red You pee yourself uncontrollably."
					new /obj/decal/cleanable/urine(affected_mob.loc)
			if(prob(3))
				if(prob(20))
					affected_mob << "\red You feel forgetful."
			if(prob(2))
				if(prob(20))
					affected_mob << "\red Your muscles feel weak."
			if(prob(2))
				if(prob(20))
					affected_mob << "\red You forget where you are."
					affected_mob.paralysis = rand(2,4)
					teleport()
			if(prob(5) && affected_mob.brainloss<=98)
				if(prob(20))
					affected_mob.brainloss += 1
	return


/datum/disease/alzheimers/proc/teleport()
	var/list/theareas = new/list()
	for(var/area/AR in orange(80, affected_mob))
		if(theareas.Find(AR) || AR.name == "Space") continue
		theareas += AR

	if(!theareas)
		return

	var/area/thearea = pick(theareas)

	var/list/L = list()
	for(var/turf/T in get_area_turfs(thearea.type))
		if(T.z != affected_mob.z) continue
		if(T.name == "space") continue
		if(!T.density)
			var/clear = 1
			for(var/obj/O in T)
				if(O.density)
					clear = 0
					break
			if(clear)
				L+=T

	if(!L)
		return
	affected_mob.loc = pick(L)
	return
