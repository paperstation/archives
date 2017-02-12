/datum/disease/jungle_fever
	name = "Jungle Fever"
	max_stages = 1
	cure = "None"
	spread = "Bites"
	spread_type = SPECIAL
	affected_species = list("Monkey", "Human")
	affected_species2 = list(/mob/living/carbon/monkey, /mob/living/carbon/human)
	curable = 0
	desc = "Monkies with this disease will bite humans, causing humans to spontaneously mutate into a monkey."
	severity = "Medium"
	//stage_prob = 100
	agent = "Kongey Vibrion M-909"
