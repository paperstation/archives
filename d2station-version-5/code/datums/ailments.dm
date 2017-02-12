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

IMPORTANT NOTE: Please delete the ailments by using cure() proc or del() instruction.
ailments are referenced in a global list, so simply setting mob or obj vars
to null does not delete the object itself. Thank you.

*/


/datum/ailment
	var/form = "Virus"				//During medscans, what the ailment is referred to as
	var/name = "No ailment"
	var/stage = 1					//all ailments start at stage 1
	var/max_stages = 0.0
	var/cure = null
	var/cure_id = null				// reagent.id or list containing them
	var/cure_list = null			// allows for multiple possible cure combinations
	var/cure_chance = 8				//chance for the cure to do its job
	var/spread = null				//spread type description
	var/spread_type = SPECIAL
	var/contagious_period = 0		//the ailment stage when it can be spread
	var/list/affected_species = list()
	var/mob/living/carbon/affected_mob = null //the mob which is affected by ailment.
	var/holder = null				//the atom containing the ailment (mob or obj)
	var/carrier = 0.0				//there will be a small chance that the person will be a carrier
	var/curable = 0					//can this ailment be cured? (By itself...)
	var/list/strain_data = list()	//This is passed on to infectees
	var/stage_prob = 4				// probability of advancing to next stage, default 5% per check
	var/agent = "some microbes"		//name of the ailment agent
	var/permeability_mod = 1		//permeability modifier coefficient.
	var/desc = null					//description. Leave it null and this ailment won't show in med records.
	var/severity = null				//severity descr
	var/longevity = 250				//time in "ticks" the virus stays in inanimate object (blood stains, corpses, etc). In syringes, bottles and beakers it stays infinitely.
	var/list/hidden = list(0, 0)
	var/clicks
	var/list/datum/effects = list()
	var/datum/ailment/effect/effect
	var/happensonce = 0
	var/chance = 0
	var/uniqueid

/datum/ailment/proc/stage_act()
	var/cure_present = has_cure()
//		world << "[cure_present]"

	if(carrier&&!cure_present)
//		world << "[affected_mob] is carrier"
		return

	spread = (cure_present?"Remissive":initial(spread))

	if(stage > max_stages)
		stage = max_stages
	if(stage_prob != 0 && prob(stage_prob) && stage != max_stages && !cure_present) //now the ailment shouldn't get back up to stage 4 in no time
		stage++
	if(stage != 1 && (prob(1) || (cure_present && prob(cure_chance))))
		stage--
	else if(stage <= 1 && ((prob(1) && curable) || (cure_present && prob(cure_chance))))
//		world << "Cured as stage act"
		cure()
		return
	return

/datum/ailment/proc/has_cure()//check if affected_mob has required reagents.
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
					if(!affected_mob.reagents.has_reagent(C_id))
						result = 0
			else if(!affected_mob.reagents.has_reagent(C_list))
				result = 0
	return result


/mob/proc/contract_ailment(var/datum/ailment/virus, var/skip_this = 0, var/force_species_check=1)
//	world << "Contract_ailment called by [src] with virus [virus]"
	if(stat >=2)
	//	world << "stat 2"
		return
	if(virus.type in resistances)
		if(prob(99.9))
	//		world << "resistance"
			return
		resistances.Remove(virus.type)//the resistance is futile

	for(var/datum/ailment/D in ailment)
		if(istype(D, virus.type))
//			world << "2 viruses"
			return // two viruses of the same kind can't infect a body at once!!


	if(force_species_check)
//		world << "species check"
		var/fail = 1
		for(var/name in virus.affected_species)
			var/mob_type = text2path("/mob/living/carbon/[lowertext(name)]")
			if(mob_type && istype(src, mob_type))
				fail = 0
		if(fail) return

	if(skip_this == 1)
		var/datum/ailment/v = new virus.type
		src.ailment += v
		v.affected_mob = src
		v.strain_data = v.strain_data.Copy()
		v.holder = src
		if(prob(5))
			v.carrier = 1
		return
	return


/datum/ailment/proc/spread(var/atom/source=null)
//	world << "ailment [src] proc spread was called from holder [source]"
	sleep(1)
	if(spread_type == SPECIAL || spread_type == NON_CONTAGIOUS)//does not spread
		return

/datum/ailment/proc/process()
	if(!holder) return
	if(prob(95))
		spread(holder)

	if(affected_mob)
		for(var/datum/ailment/D in affected_mob.ailment)
			if(D != src)
				if(istype(src, D.type))
					del(D) // if there are somehow two viruses of the same kind in the system, delete the other one

	if(holder == affected_mob)
		if(affected_mob.stat < 2) //he's alive
			stage_act()
	return

/datum/ailment/proc/cure(var/resistance=1)//if resistance = 0, the mob won't develop resistance to ailment
	if(resistance && affected_mob && !(type in affected_mob.resistances))
//		world << "Setting res to [src]"
		var/saved_type = "[type]"//copy the value, not create the reference to it, so when the object is deleted, the value remains.
		affected_mob.resistances += text2path(saved_type)
//	world << "Removing [src] (Cure())"
	spawn(0)
		del(src)
	return


/datum/ailment/New(var/process=1)//process = 1 - adding the object to global list. List is processed by master controller.
	cure_list = list(cure_id) // to add more cures, add more vars to this list in the actual ailment's New()
	if(process)					 // Viruses in list are considered active.
		active_diseases += src

/*
/datum/ailment/Del()
	active_ailments.Remove(src)
*/
