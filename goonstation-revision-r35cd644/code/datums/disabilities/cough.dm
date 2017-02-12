/datum/ailment/disability/cough
	name = "Chronic Cough"
	max_stages = 1
	cure = "stypic_powder"
	reagentcure = list("stypic_powder")
	recureprob = 10
	affected_species = list("Human")

/datum/ailment/disability/cough/stage_act(var/mob/living/affected_mob,var/datum/ailment_data/D)
	if (..())
		return
	var/mob/living/M = D.affected_mob
	if (prob(10))
		M.emote("cough")
	if (prob(2))
		M.stunned = max(5, M.stunned)
		M.visible_message("<span style=\"color:red\"><B>[M.name]</B> suffers a coughing fit</span>")