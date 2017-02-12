#define NON_CONTAGIOUS -1
#define SPECIAL 0
#define CONTACT_GENERAL 1
#define CONTACT_HANDS 2
#define CONTACT_FEET 3
#define AIRBORNE 4
#define BLOOD 5

#define SCANNER 1
#define PANDEMIC 2

/*

IMPORTANT NOTE: Please delete the diseases by using cure() proc or del() instruction.
Diseases are referenced in a global list, so simply setting mob or obj vars
to null does not delete the object itself. Thank you.

*/


/datum/disease
	var/form = "Virus" //During medscans, what the disease is referred to as
	var/name = "No disease"
	var/stage = 1 //all diseases start at stage 1
	var/max_stages = 0.0
	var/cure = null
	var/cure_id = null// reagent.id or list containing them
	var/cure_list = null // allows for multiple possible cure combinations
	var/cure_chance = 8//chance for the cure to do its job
	var/spread = null //spread type description
	var/spread_type = AIRBORNE
	var/contagious_period = 0//the disease stage when it can be spread
	var/list/affected_species = list()
	var/mob/living/carbon/affected_mob = null //the mob which is affected by disease.
	var/holder = null //the atom containing the disease (mob or obj)
	var/carrier = 0.0 //there will be a small chance that the person will be a carrier
	var/curable = 0 //can this disease be cured? (By itself...)
	var/list/strain_data = list() //This is passed on to infectees
	var/stage_prob = 4		// probability of advancing to next stage, default 5% per check
	var/agent = "some microbes"//name of the disease agent
	var/permeability_mod = 1//permeability modifier coefficient.
	var/desc = null//description. Leave it null and this disease won't show in med records.
	var/severity = null//severity descr
	var/longevity = 250//time in "ticks" the virus stays in inanimate object (blood stains, corpses, etc). In syringes, bottles and beakers it stays infinitely.
	var/list/hidden = list(0, 0)
	var/clicks
	var/list/affected_species2 = list()
	var/list/datum/effects = list()
	var/datum/disease/effect
	var/happensonce = 0
	var/chance = 0
	var/uniqueid
	var/multiplier = 1
	var/mutated
	var/id
	var/disease_load_spreader = 0
	var/why_so_serious = 0
	// if hidden[1] is true, then virus is hidden from medical scanners
	// if hidden[2] is true, then virus is hidden from PANDEMIC machine

/datum/disease/proc/stage_act()
	start:
	var/cure_present = has_cure()
//		world << "[cure_present]"

	if(affected_mob.stat == 2)
		del src

	if(carrier&&!cure_present)
//		world << "[affected_mob] is carrier"
		return

	var/timer
	if(affected_mob.reagents.reagent_list.len >= 1)
		for(var/datum/reagent/R in affected_mob.reagents.reagent_list)
			if(R.disease_slowing)
				if(prob(min(R.disease_slowing, 5)))
					if(stage > 0)
						stage--
					else if(prob(min(R.disease_slowing, 5)))
						cure()
					return
			if(R.disease_heal)
				if(affected_mob.bruteloss > 0)
					affected_mob.bruteloss -= R.disease_heal
				if(affected_mob.oxyloss > 0)
					affected_mob.oxyloss -= R.disease_heal
			if(R.disease_pause)
				timer = R.disease_pause * 10

	while(timer > 0)
		timer--
		if(cure_present == 1)
			break
		goto start


	spread = (cure_present?"Remissive":initial(spread))

	if(stage > max_stages)
		stage = max_stages
	if(stage_prob != 0 && prob(stage_prob) && stage != max_stages && !cure_present) //now the disease shouldn't get back up to stage 4 in no time
		stage++
	if(stage != 1 && (prob(1) || (cure_present && prob(cure_chance))))
		stage--
	else if(stage <= 1 && ((prob(1) && curable) || (cure_present && prob(cure_chance))))
//		world << "Cured as stage act"
		cure()
		return
	return

/datum/disease/proc/has_cure()//check if affected_mob has required reagents.
	if(!cure_id) return 0
	var/result = 1
	if(cure_list == list(cure_id))
		if(istype(cure_id, /list))
			for(var/C_id in cure_id)
				if(!affected_mob.reagents.has_reagent(C_id))
					result = 0
		else if(!affected_mob.reagents.has_reagent(cure_id))
			result = 0
	else
		for(var/C_list in cure_list)
			if(istype(C_list, /list))
				for(var/C_id in cure_id)
					if(!affected_mob.reagents || !affected_mob.reagents.has_reagent(C_id))
						result = 0
			else if(!affected_mob.reagents.has_reagent(C_list))
				result = 0
	return result


/mob/proc/contract_disease(var/datum/disease/virus, var/skip_this = 0, var/force_species_check=1)
//	world << "Contract_disease called by [src] with virus [virus]"
	if(stat >=2)
	//	world << "stat 2"
		return
	if(virus.type in resistances)
		if(prob(99.9))
	//		world << "resistance"
			return
		resistances.Remove(virus.type)//the resistance is futile

	for(var/datum/disease/D in viruses)
		if(istype(D, virus.type))
//			world << "2 viruses"
			return // two viruses of the same kind can't infect a body at once!!


	if(force_species_check)
//		world << "species check"
		var/fail = 1
		var/mob_type = virus.affected_species2
		if(mob_type && istype(src, mob_type))
			fail = 0
		if(fail) return

	if(skip_this == 1)
/*		if(prob(1) && virus.mutated == 0)
			var/datum/disease/D = virus.mutate(virus)
			src.viruses += D
			D.affected_mob = src
			D.strain_data = D.strain_data.Copy()
			D.holder = src
			if(prob(5))
				D.carrier = 1
*/
		var/datum/disease/D = virus.getcopy(virus)
		src.viruses += D
		D.affected_mob = src
		D.strain_data = D.strain_data.Copy()
		D.holder = src
		if(prob(5))
			D.carrier = 1
		return

	var/obj/item/clothing/Cl = null
	var/passed = 1

	//chances to target this zone
	var/head_ch
	var/body_ch
	var/hands_ch
	var/feet_ch

	if(virus.spread_type != AIRBORNE)
		switch(virus.spread_type)
			if(CONTACT_HANDS)
//				world << "contact hands"
				head_ch = 0
				body_ch = 0
				hands_ch = 100
				feet_ch = 0
			if(CONTACT_FEET)
//				world << "contact feet"
				head_ch = 0
				body_ch = 0
				hands_ch = 0
				feet_ch = 100
			else
				//world << "contact else"
				head_ch = 100
				body_ch = 100
				hands_ch = 25
				feet_ch = 25

		if(virus.spread_type == SPECIAL)
			passed = 1

		var/target_zone = pick(head_ch;1,body_ch;2,hands_ch;3,feet_ch;4)//1 - head, 2 - body, 3 - hands, 4- feet

		if(istype(src, /mob/living/carbon/human && !virus.spread_type == SPECIAL && !virus.spread_type == NON_CONTAGIOUS))
			var/mob/living/carbon/human/H = src

			switch(target_zone)
				if(1)
					if(isobj(H.head))
						Cl = H.head
						passed = prob(Cl.permeability_coefficient*100*virus.permeability_mod)
					//	world << "Head pass [passed]"
					if(passed && isobj(H.wear_mask))
						Cl = H.wear_mask
						passed = prob(Cl.permeability_coefficient*100*virus.permeability_mod)
						world << "Mask pass [passed]"
				if(2)//arms and legs included
					if(isobj(H.wear_suit))
						Cl = H.wear_suit
						passed = prob(Cl.permeability_coefficient*100*virus.permeability_mod)
//						world << "Suit pass [passed]"
					if(passed && isobj(H.slot_w_uniform))
						Cl = H.slot_w_uniform
						passed = prob(Cl.permeability_coefficient*100*virus.permeability_mod)
//						world << "Uniform pass [passed]"
				if(3)
					if(isobj(H.wear_suit) && H.wear_suit.body_parts_covered&HANDS)
						Cl = H.wear_suit
						passed = prob(Cl.permeability_coefficient*100*virus.permeability_mod)
//						world << "Suit pass [passed]"

					if(passed && isobj(H.gloves))
						Cl = H.gloves
						passed = prob(Cl.permeability_coefficient*100*virus.permeability_mod)
//						world << "Gloves pass [passed]"
				if(4)
					if(isobj(H.wear_suit) && H.wear_suit.body_parts_covered&FEET)
						Cl = H.wear_suit
						passed = prob(Cl.permeability_coefficient*100*virus.permeability_mod)
//						world << "Suit pass [passed]"

					if(passed && isobj(H.shoes))
						Cl = H.shoes
						passed = prob(Cl.permeability_coefficient*100*virus.permeability_mod)
//						world << "Shoes pass [passed]"
				else
					src << "Something strange's going on, something's wrong."

	if(virus.spread_type == AIRBORNE)
		if(istype(src, /mob/living/carbon))
			if (src.internal != null && src.wear_mask && (src.wear_mask.flags & MASKINTERNALS))
				passed = 0
//				world << "internals"
			else
				passed = 1
//				world << "without internals"
//				world << "AIRBORNE [passed]"
	if(passed)
		score_disease++
//		world << "Infection in the mob [src]. YAY"

// Commenting out mutation untill I finish writing it.
/*		if(prob(2) && virus.mutated == 0)
			var/datum/disease/D = virus.mutate(virus)
			src.viruses += D
			D.affected_mob = src
			D.strain_data = D.strain_data.Copy()
			D.holder = src
			if(prob(5))
				D.carrier = 1
		else
*/
		var/datum/disease/D = virus.getcopy(virus)
		src.viruses += D
		D.affected_mob = src
		D.strain_data = D.strain_data.Copy()
		D.holder = src
		if(prob(5))
			D.carrier = 1
		return
	return

/datum/disease/proc/mutate(var/datum/disease/v)
//	world << "getting copy"
	var/datum/disease/D = new v.type
	var/H = rand(1,50)
	var/N = rand(1,50)
	D.name = "H[H]N[N] virion"
	D.max_stages = v.max_stages
	D.spread = v.spread
	D:cure = "Unknown"
	D.cure_id = null
	D.affected_species = v.affected_species
	D.permeability_mod = v.permeability_mod
	D:desc = "A mutated virus"
	D.severity = "Unknown"
	D.mutated = 1
	D.multiplier = rand(2,10)
	D.stage_prob = round(v.stage_prob / (multiplier / 2), 1)
	D.cure_chance = v.cure_chance / D.multiplier
//	D.world << "[v.name] converted to [D.name]"
	D.id = "[D.name][D.multiplier]"
	D:agent = "H[H]N[N] virion"
//	world << "new ID [D.id]"
	return D


/datum/disease/proc/getcopy(var/datum/disease/v)
	if(mutated)
//		world << "getting copy"
		var/datum/disease/D = new v.type
		D.name = v.name
		D.max_stages = v.max_stages
		D.spread = v.spread
		D:cure = v:cure
		D.cure_id = v.cure_id
		D.affected_species = v.affected_species
		D.permeability_mod = v.permeability_mod
		D:desc = v:desc
		D.severity = v.severity
		D.mutated = v.mutated
		D.multiplier = v.multiplier
		D.cure_chance = v.cure_chance
//		D.world << "[D.name] maintains [v.name] attributes"
		D.id = v.id
		D.agent = v.agent
		return D
	else
		var/datum/disease/D = new v.type
		return D
/datum/disease/proc/spread(var/atom/source=null)
//	world << "Disease [src] proc spread was called from holder [source]"
	if(spread_type == SPECIAL || spread_type == NON_CONTAGIOUS)//does not spread
		return

	if(stage < contagious_period) //the disease is not contagious at this stage
		return

	if(!source)//no holder specified
		if(affected_mob)//no mob affected holder
			source = affected_mob
		else //no source and no mob affected. Rogue disease. Break
			return


//	var/check_range = AIRBORNE//defaults to airborne - range 4

//	if(spread_type != AIRBORNE && spread_type != SPECIAL)
//		check_range = 0 // everything else, like infect-on-contact things, only infect things on top of it

	var/datum/disease/C = src.getcopy(src)

	for(var/turf/A in range(affected_mob, 0))
		A.viruses += C
		if(A.zone)
			A.zone.viruses += C


//	for(var/mob/living/carbon/monkey/M in oviewers(check_range, source))
//		M.contract_disease(src)
//	for(var/mob/living/carbon/human/H in oviewers(check_range, source))
//		H.contract_disease(src)
	return


/datum/disease/proc/process()
	if(!holder) return

	if(affected_mob)
		if(prob(5))
			affected_mob.emote("cough")
			spread(holder)

	if(affected_mob)
		for(var/datum/disease/D in affected_mob.viruses)
			if(D != src)
				if(istype(src, D.type))
					del(D) // if there are somehow two viruses of the same kind in the system, delete the other one

	if(holder == affected_mob)
		if(affected_mob.stat < 2) //he's alive
			stage_act()
		else //he's dead.
			if(spread_type!=SPECIAL)
				spread_type = CONTACT_GENERAL
			affected_mob = null
	if(!affected_mob) //the virus is in inanimate obj
//		world << "[src] longevity = [longevity]"

		if(prob(70))
			if(--longevity<=0)
				cure(0)
	return

/datum/disease/proc/cure(var/resistance=1)//if resistance = 0, the mob won't develop resistance to disease
	if(resistance && affected_mob && !(type in affected_mob.resistances))
//		world << "Setting res to [src]"
		var/saved_type = "[type]"//copy the value, not create the reference to it, so when the object is deleted, the value remains.
		affected_mob.resistances += text2path(saved_type)
	if(istype(src, /datum/disease/alien_embryo))//Get rid of the flag.
		affected_mob.alien_egg_flag = 0
//	world << "Removing [src] (Cure())"
	spawn(0)
		del(src)
	return


/datum/disease/New(var/process=1)//process = 1 - adding the object to global list. List is processed by master controller.
	cure_list = list(cure_id) // to add more cures, add more vars to this list in the actual disease's New()

	if(process && why_so_serious > 2)					 // Viruses in list are considered active.
		active_diseases += src

	else if(process && why_so_serious < 3)
		active_diseases_low += src


/datum/disease/Del()
	active_diseases.Remove(src)

