/datum/ailment
	// all the vars that don't change/are defaults go in here - these will be in a central list for referencing
	var/name = "ailment"
	var/scantype = "Ailment"           // what type this shows up as on scanners
	var/cure = "Unknown"               // how do we get rid of it
	var/print_name = null              // printed name for health scanners
	var/max_stages = 0                 // how many stages the disease has overall
	var/stage_prob = 5                 // % chance per tick it'll advance a stage
	var/list/affected_species = list() // what kind of mobs does this disease affect
	var/tmp/DNA = null                 // no fuckin idea
	var/list/reagentcure = list()      // which reagents cure this disease...
	var/recureprob = 8                 // ...and how likely % they are per tick to do so
	var/temperature_cure = 406         // bodytemperature >= this will purge the infection
	var/detectability = 0              // detectors must >= this to pick up the disease
	var/resistance_prob = 0            // how likely this disease is to grant immunity once cured
	var/max_stacks = 1                 // how many times at once you can have this ailment

	proc/stage_act(var/mob/living/affected_mob,var/datum/ailment_data/D)
		if (!affected_mob || !D)
			return 1
		return 0

	proc/on_remove(var/mob/living/affected_mob,var/datum/ailment_data/D)
		disposed = 1 // set to avoid bizarre interactions (such as surgerizing out a single disease multiple times)
		return

	proc/on_infection(var/mob/living/affected_mob,var/datum/ailment_data/D)
		return

	// This is still subject to serious change. For now it's mostly a mockup.
	// Determines things that may happen during a surgery for different ailments
	// requiring a surgeon's intervention. Currently used for the parasites.
	// Returns a true value if the surgery was successful.
	proc/surgery(var/mob/living/surgeon, var/mob/living/affected_mob, var/datum/ailment_data/D)
		return 1

/datum/ailment/parasite
	name = "Parasite"
	scantype = "Parasite"
	cure = "Surgery"

/datum/ailment/disability
	name = "Disability"
	scantype = "Disability"
	cure = "Unknown"

/datum/ailment/disease
	name = "Disease"
	scantype = "Virus"
	cure = "Unknown"
	var/virulence = 100
	var/develop_resist = 0
	var/spread = "Unknown"
	var/associated_reagent = null // associated reagent, duh

	var/list/disease_data = list() // A list of things for people to research about the disease to make it
	var/list/strain_data = list()  // Used for Rhinovirus

// IMPLEMENT PROPER CURE PROC

/datum/ailment_data
	// these will be the local thing on mobs that does all the effecting, and they store unique vars so we can still
	// have unique strains of disease and whatnot
	/////////////////////////////////////////////////////////////////////////
	var/datum/ailment/master = null // we reference back to the ailment itself to get effects and static vars
	var/tmp/mob/living/affected_mob = null // the poor sod suffering from the disease
	var/name = null                 // an override - uses the base disease name if null - if not, it uses this
	var/detectability = 0           // scans must >= this to detect the disease
	var/cure = "Unknown"            // how do we get rid of it
	var/stage = 1                   // what stage the disease is currently at
	var/state = "Active"            // what is this disease currently doing
	var/stage_prob = 5              // how likely is this disease to advance to the next stage
	var/list/reagentcure = list()   // list of reagents that can cure this disease
	var/recureprob = 8              // probability per tick that the reagent will cure the disease
	var/temperature_cure = 406      // this temp or higher will cure the disease
	var/resistance_prob = 0         // how likely this disease is to grant immunity once cured

	disposing()
		if (affected_mob)
			if (affected_mob.ailments)
				affected_mob.ailments -= src
			affected_mob = null

		master = null
		reagentcure = null

		..()

	proc/stage_act()
		if (!affected_mob || disposed)
			return 1

		if (!istype(master,/datum/ailment/))
			affected_mob.cure_disease(src)
			return 1

		if (stage > master.max_stages)
			stage = master.max_stages

		if (prob(stage_prob) && stage < master.max_stages)
			stage++

		master.stage_act(affected_mob,src)

		return 0

	proc/scan_info()
		var/text = "<span style=\"color:red\"><b>"
		if (istype(src.master,/datum/ailment/disease))
			text += "[src.state] "
		text += "[src.master.scantype]:"

		text += " [src.name ? src.name : src.master.name]</b> <small>(Stage [src.stage]/[src.master.max_stages])<br>"
		if (istype(src.master,/datum/ailment/disease))
			var/datum/ailment_data/disease/AD = src
			text += "Spread: [AD.spread]<br>"
		if (src.cure == "Incurable")
			text += "Infection is incurable. Suggest quarantine measures."
		else if (src.cure == "Unknown")
			text += "No suggested remedies."
		else
			text += "Suggested Remedy: [src.cure]"
		text += "</small></span>"
		return text

	proc/on_infection()
		master.on_infection(affected_mob, src)
		return

	proc/surgery(var/mob/living/surgeon, var/mob/living/affected_mob)
		if (master && istype(master, /datum/ailment))
			return master.surgery(surgeon, affected_mob, src)
		return 1

/datum/ailment_data/disease
	var/virulence = 100    // how likely is this disease to spread
	var/develop_resist = 0 // can you develop a resistance to this?
	var/spread = "Unknown" // how does this disease transmit itself around?
	var/cycles = 0         // does this disease have a cyclical nature? if so, how many cycles have elapsed?

	stage_act()
		if (!affected_mob || disposed)
			return 1

		if (!istype(master,/datum/ailment/))
			affected_mob.ailments -= src
			qdel(src)
			return 1

		if (stage > master.max_stages)
			stage = master.max_stages

		if (stage < 1) // if it's less than one just get rid of it, goddamn
			affected_mob.cure_disease(src)
			return 1

		var/advance_prob = stage_prob
		if (state == "Acute")
			advance_prob *= 2
		advance_prob = max(0,min(advance_prob,100))

		if (prob(advance_prob))
			if (state == "Remissive")
				stage--
				if (stage < 1)
					affected_mob.cure_disease(src)
				return 1
			else if (stage < master.max_stages)
				stage++

		// Common cures
		if (cure != "Incurable")
			if (cure == "Sleep" && affected_mob.sleeping && prob(33))
				state = "Remissive"
				return 1

			else if (cure == "Self-Curing" && prob(5))
				state = "Remissive"
				return 1

			else if (cure == "Beatings" && affected_mob.get_brute_damage() >= 40)
				state = "Remissive"
				return 1

			else if (cure == "Burnings" && (affected_mob.get_burn_damage() >= 40 || affected_mob.burning))
				state = "Remissive"
				return 1

			else if (affected_mob.bodytemperature >= temperature_cure)
				state = "Remissive"
				return 1

			if (reagentcure.len && affected_mob.reagents)
				for(var/current_id in affected_mob.reagents.reagent_list)
					if (reagentcure.Find(current_id))
						if (prob(recureprob))
							state = "Remissive"
							return 1

		if (state == "Asymptomatic" || state == "Dormant")
			return 1

		spawn(rand(1,5))
			// vary it up a bit so the processing doesnt look quite as transparent
			if (master)
				master.stage_act(affected_mob,src)

		return 0

/datum/ailment_data/addiction
	var/associated_reagent = null
	var/last_reagent_dose = 0
	var/withdrawal_duration = 4800

	New()
		..()
		master = get_disease_from_path(/datum/ailment/addiction)

/datum/ailment_data/parasite
	var/was_setup = 0
	var/surgery_prob = 50

	var/source = null // for headspiders
	var/stealth_asymptomatic = 0
	proc/setup()
		src.stage_prob = master.stage_prob
		src.cure = master.cure
		src.was_setup = 1

	stage_act()
		if (!affected_mob)
			return

		if (!istype(master, /datum/ailment/))
			affected_mob.cure_disease(src)
			return

		if (!istype(source, /datum/mind))
			affected_mob.cure_disease(src)
			return

		if (!was_setup)
			src.setup()

		if (stage > master.max_stages)
			stage = master.max_stages

		if (prob(stage_prob) && stage < master.max_stages)
			stage++


		if(!stealth_asymptomatic)
			master.stage_act(affected_mob,src,source)

		return

/mob/living/proc/disease_resistance_check(var/ailment_path, var/ailment_name)
	if (!src)
		// no mob (somehow), so fuck this shit!
		return 0

	if (!ispath(ailment_path) && !istext(ailment_name))
		// didn't specify a disease to check against
		return 0

	var/datum/ailment/A = null
	if (ailment_name)
		A = get_disease_from_name(ailment_name)
	else
		A = get_disease_from_path(ailment_path)

	if (!istype(A,/datum/ailment/))
		// can't find shit, captain!
		return 0

	if (src.resistances.Find(A.type))
		// If we've already got this disease or are resistant to it, then NOPE
		// duplicate strain checking is in the main loop because otherwise bypass resistance ignores it
		return 0

	var/mob_type = null
	if (ismonkey(src))
		mob_type = "Monkey"
	else if (ishuman(src))
		//Current thought: It's really weird for a base mob proc to run istypes on itself.
		var/mob/living/carbon/human/H = src
		if (H.mutantrace && !H.mutantrace.human_compatible)
			mob_type = capitalize(H.mutantrace.name)
		else
			mob_type = "Human"
	if (!A.affected_species.Find(mob_type))
		// Only valid vector species can get a disease.
		return 0

	if (src.stat == 2 && !istype(A,/datum/ailment/parasite))
		//Dead folks cannot get non-parasitoid infections.
		return 0

	var/resist_prob = 0
	if (istype(A,/datum/ailment/disease/))
		var/datum/ailment/disease/D = A
		resist_prob -= D.virulence
		if (istype(src,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = src
			if (D.spread == "Airborne")
				if (src.wear_mask)
					if (H.internal)
						resist_prob += 100
						// if you don't breathe it in, you're fine
					else
						resist_prob += 20
						// mask but no air supply - still better than nothing

			else if (D.spread == "Sight")
				if (H.eyes_protected_from_light())
					resist_prob += 190

			for (var/obj/item/clothing/C in H.get_equipped_items())
				resist_prob += C.disease_resistance

	resist_prob = max(0,min(resist_prob,100))
	if (prob(resist_prob))
		// we successfully resisted it
		return 0

	// you caught the virus! do you want to give the captured virus a nickname? virus has been recorded in lurgydex
	return 1

/mob/living/proc/contract_disease(var/ailment_path, var/ailment_name, var/datum/ailment_data/disease/strain, bypass_resistance = 0)
	if (!src)
		return null
	if (!ailment_path && !ailment_name && !istype(strain,/datum/ailment_data/disease/))
		return null

	var/datum/ailment/A = null
	if (strain && istype(strain.master,/datum/ailment/))
		A = strain.master
	else if (ailment_name)
		A = get_disease_from_name(ailment_name)
	else
		A = get_disease_from_path(ailment_path)

	if (!istype(A,/datum/ailment/))
		// can't find shit, captain!
		return null

	var/count = 0
	for (var/datum/ailment_data/D in src.ailments)
		if (D.master == A)
			count++

	if (count >= A.max_stacks)
		return null

	if (ischangeling(src) || isvampire(src) || src.nodamage)
		//Vampires and changelings are immune to disease, as are the godmoded.
		//This is here rather than in the resistance check proc because otherwise certain things could bypass the
		//hard immunity these folks are supposed to have
		return null

	if (!bypass_resistance && !src.disease_resistance_check(null,A.name))
		return null

	if (istype(A, /datum/ailment/disease/))
		var/datum/ailment/disease/D = A
		var/datum/ailment_data/disease/AD = new /datum/ailment_data/disease
		if (istype(strain,/datum/ailment_data/disease/))
			if (strain.name)
				AD.name = strain.name
			else
				AD.name = D.name
			AD.stage_prob = strain.stage_prob
			AD.reagentcure = strain.reagentcure
			AD.recureprob = strain.recureprob
			AD.virulence = strain.virulence
			AD.detectability = strain.detectability
			AD.develop_resist = strain.develop_resist
			AD.cure = strain.cure
			AD.spread = strain.spread
			AD.resistance_prob = strain.resistance_prob
			AD.temperature_cure = strain.temperature_cure
		else
			AD.name = D.name
			AD.stage_prob = D.stage_prob
			AD.reagentcure = D.reagentcure
			AD.recureprob = D.recureprob
			AD.virulence = D.virulence
			AD.detectability = D.detectability
			AD.develop_resist = D.develop_resist
			AD.cure = D.cure
			AD.spread = D.spread
			AD.resistance_prob = D.resistance_prob
			AD.temperature_cure = D.temperature_cure

		src.ailments += AD
		AD.master = A
		AD.affected_mob = src
		AD.on_infection()

		if (prob(5))
			AD.state = "Asymptomatic"
			// carrier - will spread it but won't suffer from it
		return AD
	else
		var/datum/ailment_data/AD = new /datum/ailment_data
		AD.name = A.name
		AD.stage_prob = A.stage_prob
		AD.cure = A.cure
		AD.reagentcure = A.reagentcure
		AD.recureprob = A.recureprob
		AD.master = A

		AD.master = A
		AD.affected_mob = src
		src.ailments += AD

		return AD

/mob/living/proc/viral_transmission(var/mob/living/target, var/spread_type, var/two_way = 0)
	if (!src || !target || !istext(spread_type))
		return

	if (!src.ailments || !src.ailments.len)
		return

	for (var/datum/ailment_data/disease/AD in src.ailments)
		if (AD.spread == spread_type)
			target.contract_disease(null,null,AD,0)

	if (two_way)
		for (var/datum/ailment_data/disease/AD in target.ailments)
			if (AD.spread == spread_type)
				src.contract_disease(null,null,AD,0)

	return

/mob/living/proc/cure_disease(var/datum/ailment_data/AD)
	if (!AD.master || !istype(AD,/datum/ailment_data/))
		return 0

	if (prob(AD.resistance_prob))
		src.resistances += AD.master.type
	src.ailments -= AD
	AD.master.on_remove(src,AD)
	qdel(AD)
	return 1

/mob/living/proc/cure_disease_by_path(var/ailment_path)
	for (var/datum/ailment_data/AD in src.ailments)
		if (!AD.master)
			continue
		if (AD.master.type == ailment_path)
			if (prob(AD.resistance_prob))
				src.resistances += AD.master.type
			src.ailments -= AD
			AD.master.on_remove(src,AD)
			qdel(AD)
			return 1
	return 0

/mob/living/proc/find_ailment_by_type(var/ailment_path)
	if (!ispath(ailment_path))
		return null

	for (var/datum/ailment_data/AD in src.ailments)
		if (AD.master && AD.master.type == ailment_path)
			return AD

	return null

/mob/living/proc/find_ailment_by_name(var/ailment_name,var/base_ailments_only = 0)
	if (!istext(ailment_name))
		return null

	for (var/datum/ailment_data/AD in src.ailments)
		if (AD.name == ailment_name && !base_ailments_only)
			return AD
		if (AD.master && AD.master.name == ailment_name)
			return AD

	return null

/mob/living/proc/Virus_ShockCure(var/probcure = 50)
	for (var/datum/ailment_data/V in src.ailments)
		if (V.cure == "Electric Shock" && prob(probcure))
			src.cure_disease(V)

/mob/living/proc/shock_cyberheart(var/shockInput)
	return

/mob/living/carbon/human/shock_cyberheart(var/shockInput)
	if (!src.organHolder)
		return
	var/numHigh = round((1 * shockInput) / 5)
	var/numMid = round((1 * shockInput) / 10)
	var/numLow = round((1 * shockInput) / 20)
	if (src.organHolder.heart && src.organHolder.heart.robotic && src.organHolder.heart.emagged && !src.organHolder.heart.broken)
		src.add_stam_mod_regen("heart_shock", 5)
		src.add_stam_mod_max("heart_shock", 20)
		spawn(9000)
			src.remove_stam_mod_regen("heart_shock")
			src.remove_stam_mod_max("heart_shock")
		if (prob(numHigh))
			boutput(src, "<span style=\"color:red\">Your cyberheart spasms violently!</span>")
			random_brute_damage(src, numHigh)
		if (prob(numHigh))
			boutput(src, "<span style=\"color:red\">Your cyberheart shocks you painfully!</span>")
			random_burn_damage(src, numHigh)
		if (prob(numMid))
			boutput(src, "<span style=\"color:red\">Your cyberheart lurches awkwardly!</span>")
			src.contract_disease(/datum/ailment/disease/heartfailure, null, null, 1)
		if (prob(numMid))
			boutput(src, "<span style=\"color:red\"><B>Your cyberheart stops beating!</B></span>")
			src.contract_disease(/datum/ailment/disease/flatline, null, null, 1)
		if (prob(numLow))
			boutput(src, "<span style=\"color:red\"><B>Your cyberheart shuts down!</B></span>")
			src.organHolder.heart.broken = 1
			src.contract_disease(/datum/ailment/disease/flatline, null, null, 1)
	else if (src.organHolder.heart && src.organHolder.heart.robotic && !src.organHolder.heart.emagged && !src.organHolder.heart.broken)
		src.add_stam_mod_regen("heart_shock", 1)
		src.add_stam_mod_max("heart_shock", 10)
		spawn(9000)
			src.remove_stam_mod_regen("heart_shock")
			src.remove_stam_mod_max("heart_shock")
		if (prob(numMid))
			boutput(src, "<span style=\"color:red\">Your cyberheart spasms violently!</span>")
			random_brute_damage(src, numMid)
		if (prob(numMid))
			boutput(src, "<span style=\"color:red\">Your cyberheart shocks you painfully!</span>")
			random_burn_damage(src, numMid)
		if (prob(numLow))
			boutput(src, "<span style=\"color:red\">Your cyberheart lurches awkwardly!</span>")
			src.contract_disease(/datum/ailment/disease/heartfailure, null, null, 1)
