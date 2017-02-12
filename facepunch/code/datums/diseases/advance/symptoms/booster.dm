//Checks if the body has spaceacillin in it, gives it if it doesn't.

/datum/symptom/booster

	name = "Immune System Booster"
	stealth = 1
	resistance = 0
	stage_speed = 1
	transmittable = 0
	level = 2

/datum/symptom/booster/Activate(var/datum/disease/advance/A)
	..()
	if(prob(15))
		var/mob/living/carbon/M = A.affected_mob
		if (M.reagents && !M.reagents.get_reagent_amount("spaceacillin"))
			M << "<span class='notice'>[pick("You feel a little bit better.", "You feel the pain ease away.")]</span>"
			M.reagents.add_reagent("spaceacillin", 5)
	return
