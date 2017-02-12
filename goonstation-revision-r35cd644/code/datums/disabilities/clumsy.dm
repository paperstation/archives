/datum/ailment/disability/clumsy
	name = "Dyspraxia"
	max_stages = 1
	cure = "Unknown"
	affected_species = list("Human")

/datum/ailment/disability/clumsy/stage_act(var/mob/living/affected_mob,var/datum/ailment_data/D)
	if (..())
		return
	var/mob/living/M = D.affected_mob
	if (prob(6))
		boutput(M, "<span style=\"color:red\">Your hands twitch.</span>")
		var/h = M.hand
		M.hand = 0
		M.drop_item()
		M.hand = 1
		M.drop_item()
		M.hand = h
	if (prob(3))
		M.visible_message("<span style=\"color:red\"><B>[M.name]</B> stumbles and falls!</span>")
		M.stunned = max(10, M.stunned)
		M.weakened = max(10, M.weakened)
		if (istype(M,/mob/living/carbon/human/) && prob(25))
			var/mob/living/carbon/human/H = M
			if(!istype(H.head, /obj/item/clothing/head/helmet))
				boutput(H, "<span style=\"color:red\">You bash your head on the ground.</span>")
				random_brute_damage(H, 5)
				H.take_brain_damage(2)
				H.paralysis = max(10, H.paralysis)
				H.make_jittery(1000)
				H.updatehealth()
			else
				boutput(H, "<span style=\"color:red\">You bash your head on the ground - good thing you were wearing a helmet!</span>")
	if (prob(1))
		boutput(M, "<span style=\"color:red\">You forget to breathe.</span>")
		M.take_oxygen_deprivation(33)