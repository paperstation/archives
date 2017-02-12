/datum/random_event/major/virus
	name = "Viral Outbreak"
	centcom_headline = "Viral Outbreak"
	centcom_message = "A potentially harmful virus has been detected on the station. Medical personnel are advised to report for duty."

	event_effect(var/source)
		..()
		var/virus_type = pick(/datum/ailment/disease/flu,/datum/ailment/disease/clowning_around,
		/datum/ailment/disease/berserker,/datum/ailment/disease/space_madness)
		var/list/potential_victims = list()
		for (var/mob/living/carbon/human/H in mobs)
			if (H.stat == 2)
				continue
			potential_victims += H
		if (potential_victims.len)
			var/mob/living/carbon/human/patient_zero = pick(potential_victims)
			patient_zero.contract_disease(virus_type,null,null,1)