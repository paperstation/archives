/datum/ailment/disease/necrotic_degeneration
	name = "Necrotic Degeneration"
	max_stages = 6
	spread = "Non-Contagious"
	cure = "Healing Reagents"
	reagentcure = list("tricordazine","cryoxadone","mannitol","penteticacid","stypic_powder")
	recureprob = 8
	associated_reagent = "necrovirus"
	affected_species = list("Human")

/datum/ailment/disease/necrotic_degeneration/stage_act(var/mob/living/affected_mob,var/datum/ailment_data/D)
	if (..())
		return
	if (affected_mob.get_burn_damage() >= 80)
		affected_mob.cure_disease(D)
		return
	switch(D.stage)
		if(2)
			if (prob(5))
				affected_mob.emote(pick("shiver", "pale"))
		if(3)
			if (prob(8))
				boutput(affected_mob, "<span style=\"color:red\">You notice a foul smell.</span>")
			if (prob(10))
				boutput(affected_mob, "<span style=\"color:red\">You lose track of your thoughts.</span>")
				affected_mob.take_brain_damage(10)
			if (prob(4))
				boutput(affected_mob, "<span style=\"color:red\">You pass out momentarily.</span>")
				affected_mob.paralysis += 2
			if (prob(5))
				affected_mob.emote(pick("shiver","pale","drool"))
		if(4)
			affected_mob.stuttering = 10
			if (prob(10))
				affected_mob.emote(pick("drool","moan"))
			if (prob(20))
				affected_mob.say(pick("Hungry...", "Must... kill...", "Brains..."))
		if(5)
			boutput(affected_mob, "<span style=\"color:red\">Your heart seems to have stopped...</span>")
			affected_mob.set_mutantrace(/datum/mutantrace/zombie)
			if (ishuman(affected_mob))
				affected_mob:update_face()
				affected_mob:update_body()
			affected_mob:update_clothing()
			cure = "Incurable"
			D.stage++
		if(6)
			if(!istype(affected_mob:mutantrace, /datum/mutantrace/zombie))
				affected_mob.set_mutantrace(/datum/mutantrace/zombie)
				if (ishuman(affected_mob))
					affected_mob:update_face()
					affected_mob:update_body()
				affected_mob:update_clothing()
			affected_mob.stuttering = 10
			affected_mob.take_brain_damage(90)
			if (prob(10))
				affected_mob.emote(pick("moan"))