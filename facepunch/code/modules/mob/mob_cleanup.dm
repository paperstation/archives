//Methods that need to be cleaned.
/* INFORMATION
Put (mob/proc)s here that are in dire need of a code cleanup.
*/

/mob/proc/has_disease(var/datum/disease/virus)
	for(var/datum/disease/D in viruses)
		if(D.IsSame(virus))
			//error("[D.name]/[D.type] is the same as [virus.name]/[virus.type]")
			return 1
	return 0

// This proc has some procs that should be extracted from it. I believe we can develop some helper procs from it - Rockdtben
/mob/proc/contract_disease(var/datum/disease/virus, var/skip_this = 0, var/force_species_check=1, var/spread_type = -5)
	//world << "Contract_disease called by [src] with virus [virus]"
	if(stat >=2)
		//world << "He's dead jim."
		return
	if(istype(virus, /datum/disease/advance))
		//world << "It's an advance virus."
		var/datum/disease/advance/A = virus
		if(A.GetDiseaseID() in resistances)
			//world << "It resisted us!"
			return
		if(count_by_type(viruses, /datum/disease/advance) >= 3)
			return

	else
		if(src.resistances.Find(virus.type))
			//world << "Normal virus and resisted"
			return


	if(has_disease(virus))
		return


	if(force_species_check)
		var/fail = 1
		for(var/name in virus.affected_species)
			var/mob_type = text2path("/mob/living/carbon/[lowertext(name)]")
			if(mob_type && istype(src, mob_type))
				fail = 0
				break
		if(fail) return

	if(skip_this == 1)
		//world << "infectin"
		//if(src.virus)				< -- this used to replace the current disease. Not anymore!
			//src.virus.cure(0)
		var/datum/disease/v = new virus.type(1, virus, 0)
		src.viruses += v
		v.affected_mob = src
		v.strain_data = v.strain_data.Copy()
		v.holder = src
		if(v.can_carry && prob(5))
			v.carrier = 1
		return
	//world << "Not skipping."
	//if(src.virus) //
		//return //


/*
	var/list/clothing_areas	= list()
	var/list/covers = list(UPPER_TORSO,LOWER_TORSO,LEGS,FEET,ARMS,HANDS)
	for(var/Covers in covers)
		clothing_areas[Covers] = list()

	for(var/obj/item/clothing/Clothing in src)
		if(Clothing)
			for(var/Covers in covers)
				if(Clothing&Covers)
					clothing_areas[Covers] += Clothing

*/
	if(prob(15/virus.permeability_mod)) return //the power of immunity compels this disease! but then you forgot resistances

	//chances to target this zone
	var/head_ch
	var/body_ch
	var/hands_ch
	var/feet_ch

	if(spread_type == -5)
		spread_type = virus.spread_type

	switch(spread_type)
		if(CONTACT_HANDS)
			head_ch = 0
			body_ch = 0
			hands_ch = 100
			feet_ch = 0
		if(CONTACT_FEET)
			head_ch = 0
			body_ch = 0
			hands_ch = 0
			feet_ch = 100
		else
			head_ch = 100
			body_ch = 100
			hands_ch = 25
			feet_ch = 25


	var/target_zone = pick(head_ch;1,body_ch;2,hands_ch;3,feet_ch;4)//1 - head, 2 - body, 3 - hands, 4- feet

	if(istype(src, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = src
		var/obj/item/clothing/head/head = null
		var/obj/item/clothing/suit/suit = null
		if(istype(H.head))
			head = H.head
		if(istype(H.wear_suit))
			suit = H.wear_suit

		var/zone = ""
		switch(zone)
			if(1)
				target_zone = HEAD
				if(istype(H.wear_mask, /obj/item/clothing/mask/gas))
					if(prob(80))
						return
			if(2)//arms and legs included
				target_zone = CHEST
			if(3)
				target_zone = ARMS
				if(istype(H.gloves, /obj/item/clothing/gloves))
					return
			if(4)
				target_zone = LEGS

		if(target_zone)
			if(head && head.body_parts_covered & target_zone)
				if(prob(100*head.armor[BIO]))
					return
			if(suit && suit.body_parts_covered & target_zone)
				if(prob(100*suit.armor[BIO]))
					return

	if(internal)
		return

	if(spread_type == AIRBORNE)
		if(prob(100-(50*virus.permeability_mod)))
			return

	var/datum/disease/v = new virus.type(1, virus, 0)
	src.viruses += v
	v.affected_mob = src
	v.strain_data = v.strain_data.Copy()
	v.holder = src
	if(v.can_carry && prob(5))
		v.carrier = 1
	return
