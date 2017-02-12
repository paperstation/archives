//To simplify, all diseases have 4 stages, with effects starting at stage 2
//Stage 1 = Rest,Minor disease
//Stage 2 = Minimal effect
//Stage 3 = Medium effect
//Stage 4 = Death/Really Really really bad effect

#define SPECIAL 0
#define CONTACT_GENERAL 1
#define CONTACT_HANDS 2
#define CONTACT_FEET 3
#define AIRBORNE 4

/*

IMPORTANT NOTE: Please delete the diseases by using cure() proc or del() instruction.
Diseases are referenced in global list, so simply setting mob or obj vars
to null does not delete the object itself. Thank you.

*/


/datum/disease2/disease
	var/name = "No disease"
	var/stage = 1					//all diseases start at stage 1
	var/max_stages = 0.0
	var/cure = null
	var/cure_id = null				// reagent.id or list containing them
	var/cure_list = null			// allows for multiple possible cure combinations
	var/cure_chance = 8				//chance for the cure to do its job
	var/spread = null				//spread type description
	var/spread_type = AIRBORNE
	var/contagious_period = 0		//the disease stage when it can be spread
	var/list/affected_species = list()
	var/mob/affected_mob = null		//the mob which is affected by disease.
	var/holder = null				//the atom containing the disease (mob or obj)
	var/carrier = 0.0				//there will be a small chance that the person will be a carrier
	var/curable = 1					//can this disease be cured? (By itself...)
	var/list/strain_data = list()	//This is passed on to infectees
	var/stage_prob = 5				// probability of advancing to next stage, default 5% per check
	var/agent = "some microbes"		//name of the disease agent
	var/permeability_mod = 1		//permeability modifier coefficient.
	var/desc = null					//description. Leave it null and this disease won't show in med records.
	var/severity = null				//severity descr
	var/longevity = 250				//time in "ticks" the virus stays in inanimate object (blood stains, corpses, etc). In syringes, bottles and beakers it stays infinitely.
	var/uniqueID = 0
	var/list/datum/disease2/effectholder/effects = list()
	var/infectionchance = 10
	var/stageprob = 2
	var/dead = 0
	var/clicks = 0

	var/list/gayphrases = list("This 'gay disease' stuff is kind of offensive, despite it being intended as tongue in cheek. ",\
	 "And the nazi uniform is A-Okay? Well, admittedly, the nazi uniform is so rarely brought out and jews are so rarely eliminated, but hey. Take it for what it is. Stupid in an amusing way as opposed to hateful.",\
	 "Yeah I think the gay disease crosses over into if not really offensive in its own right, too puerile to be very amusing. ",\
	 "Well, I'll give that at the very least you're even handed with the whole thing. And it certainly is offensive and I can quickly imagine some retard using it as a launching point for a tirade against homosexuality. I guess you just need to have a thick skin to deal with it. Well, that and I imagine it's going to go into nazi uniform land and not be used much after its induction as the magic wears thin.",\
	 "I don't think you really understand the nature of my objection. Someone doesn't have to use bigoted jokes as a starting point for a sincerely hateful screed in order for the jokes to be bad; a popular culture that treats homosexuality as an illness or as at best an amusing character flaw is itself a problem, and I don't think we should be contributing to that.It may seem a bit silly to apply such a grand view to a simple game like this, but on the other hand, these are precisely the sorts of things that we can readily affect.",\
	 "I get that you're pointing it out more as part of a trend than anything, but I don't personally see poking fun at the concept harmful itself. Though with the... eagerness of some of the people suggesting ideas, I can see how it can quickly become less \"Let's poke fun at a silly concept\" and \"HRF DRF FAGITS R FUNY CAUSE THEY WEK AND GAY\" Then again, in this case I do have an outsider's view and can only try and draw parallels here. ",\
	 "I didn't get the impression this here gay disease was implying all people that are gay have it or any of that. Just that it was a disease that made you stereotypically gay. Then again, I never gave much though to the sexuality of the characters in SS13. Maybe if you had a box you could change from heterosexual to homosexual, and by being homosexual you instantly had the gay disease, that comparison might work quite a bit better.",\
	 "This discussion had to come up at some point. There's a lot of racist humor that shows up in SS13. I know very little of it is earnest -- just people looking for shock laughs -- but on the internet comedy scale it's right at the bottom next to catch phrases. It also makes whoever said it look like they're fourteen and I have enough trouble already pretending I don't spend the majority of my gaming time with children.",\
	 "Piss and poop just seems meh, its not very funny at the moment, and its gonna get even less so fast, then its just going to be tedious with every new pubbie going \"HAI GUYS I SHAT MY PANTS LAWL\" every fucking round.",\
	 "You know if you actually wrote up a good definition of what is griefing and what is just criminal you'd have something to point to when people pissed and moaned at you and it might make stuff like shark week less necessary. \"hurf durf don;t grief!\" is stupid when you fight back against an admin or make an honest mistake.",\
	 "You're incredibly stupid. I'm not telling you to make a definition so everyone in this thread knows what griefing is. I'm telling you it would save admins a lot of arguing if they could say \"oh well you don't have an excuse because here's a good definition and i don't have to spend any time arguing with you because its already laid out!\"",\
	 "There you go, showing the forums you have no clue how to read. All I said was there should be a definition of what \"griefing\" is. No doubt you'll wave it off as being pedantic or \"LOL U TAEK GAME SERIOUS\" but your big bad list has nothing like that in it. Just arbitrary examples of things you don't want to happen. The portion of my post you bolded is qualifying the word \"griefing.\" Of course, I know you were rushing so quickly to copy and paste the rules this escaped you.",\
	 "I'm not really sure what you mean by this. I was just responding to how shitty he was talking to me. I don't know about you, but I don't really like it when people call me retarded. I have feelings. I guess, if anything, I was successfully trolled into calling him names back. And for the record I never thought I was that shitty of a player. I got banned for the second time ever tonight because I attacked someone who I thought was a revolutionary. You can keep swinging from his nuts if you want to though.",\
	 "You just act like a dick in general. If it bothers you that much to spend all of your free time on this game then why even do it? And I'm sorry I hurt your feelings back--I like your game and I like most of the admins who spend their time on it, for better or worse, because even when they do grief its pretty funny. My suggestion was a throw-away comment that you decided would be awesome to troll me over for some reason. I won't bother you anymore if you're going to be that butt hurt when someone makes a suggestion that might not be brilliant to you. That's probably why they're just suggestions and not binding commands on what you should do with YOUR GAME that you spend all your time on. Also, please show me where I have trolled you before.",\
	 "I can see how poo is funny if you're in grade school, but after that \"HE POOPED HIMSELF HAHAHA\" goes away. At least it should.",\
	 "Ugh, Honestly this whole poo argument just feels like the clown/bartender/janitor argument all over again, \"Why would a clown/bartender/janitor be on a space station?!\" for a few months, and then it gets to be the underused thing that only crazy people do")



	proc/makerandom()
		var/datum/disease2/effectholder/holder = new /datum/disease2/effectholder
		holder.stage = 1
		holder.getrandomeffect()
		effects += holder
		holder = new /datum/disease2/effectholder
		holder.stage = 2
		holder.getrandomeffect()
		effects += holder
		holder = new /datum/disease2/effectholder
		holder.stage = 3
		holder.getrandomeffect()
		effects += holder
		holder = new /datum/disease2/effectholder
		holder.stage = 4
		holder.getrandomeffect()
		effects += holder
		uniqueID = rand(0,10000)
		infectionchance = rand(1,10)
		spreadtype = "Airborne"

	proc/minormutate()
		var/datum/disease2/effectholder/holder = pick(effects)
		holder.minormutate()
		infectionchance = min(10,infectionchance + rand(0,1))
	proc/issame(var/datum/disease2/disease/disease)
		var/list/types = list()
		var/list/types2 = list()
		for(var/datum/disease2/effectholder/d in effects)
			types += d.effect.type
		var/equal = 1

		for(var/datum/disease2/effectholder/d in disease.effects)
			types2 += d.effect.type

		for(var/type in types)
			if(!(type in types2))
				equal = 0
		return equal

	proc/activate(var/mob/living/carbon/mob)
		if(dead)
			mob.virus2 = null
			return
		if(mob.stat == 2)
			return
		if(mob.radiation > 50)
			if(prob(1))
				majormutate()
		if(mob.reagents.has_reagent("spaceacillin"))
			return
		if(prob(stageprob) && prob(25 + (clicks/100)) && stage != 4)
			stage++
			clicks = 0
		for(var/datum/disease2/effectholder/e in effects)
			e.runeffect(mob,stage)

	proc/cure_added(var/datum/disease2/resistance/res)
		if(res.resistsdisease(src))
			dead = 1

	proc/majormutate()
		var/datum/disease2/effectholder/holder = pick(effects)
		holder.majormutate()


	proc/getcopy()
//		world << "getting copy"
		var/datum/disease2/disease/disease = new /datum/disease2/disease
		disease.infectionchance = infectionchance
		disease.spreadtype = spreadtype
		disease.stageprob = stageprob
		for(var/datum/disease2/effectholder/holder in effects)
	//		world << "adding effects"
			var/datum/disease2/effectholder/newholder = new /datum/disease2/effectholder
			newholder.effect = new holder.effect.type
			newholder.chance = holder.chance
			newholder.cure = holder.cure
			newholder.multiplier = holder.multiplier
			newholder.happensonce = holder.happensonce
			newholder.stage = holder.stage
			disease.effects += newholder
	//		world << "[newholder.effect.name]"
	//	world << "[disease]"
		return disease



/datum/disease2/proc/stage_act()
	var/cure_present = has_cure()
	//world << "[cure_present]"

	if(carrier&&!cure_present)
		//world << "[affected_mob] is carrier"
		return

	spread = (cure_present?"Remissive":initial(spread))

	if(stage > max_stages)
		stage = max_stages
	if(prob(stage_prob) && stage != max_stages && !cure_present) //now the disease shouldn't get back up to stage 4 in no time
		stage++
	if(stage != 1 && (prob(1) || (cure_present && prob(cure_chance))))
		stage--
	else if(stage <= 1 && ((prob(1) && src.curable) || (cure_present && prob(cure_chance))))
//		world << "Cured as stage act"
		src.cure()
		return
	return

/datum/disease2/proc/has_cure()//check if affected_mob has required reagents.
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


/mob/proc/contract_disease2(var/datum/disease2/virus, var/skip_this = 0, var/force_species_check=1)
//	world << "Contract_disease called by [src] with virus [virus]"
	if(src.stat >=2) return


	if(force_species_check)
		var/fail = 1
		for(var/name in virus.affected_species)
			var/mob_type = text2path("/mob/living/carbon/[lowertext(name)]")
			if(mob_type && istype(src, mob_type))
				fail = 0
				break
		if(fail) return

	if(skip_this == 1)//be wary, it replaces the current disease...
		if(src.virus)
			src.virus.cure(0)
		src.virus = new virus.type
		src.virus.affected_mob = src
		src.virus.strain_data = virus.strain_data.Copy()
		src.virus.holder = src
		if(prob(5))
			src.virus.carrier = 1
		return

	if(src.virus) return

	if(virus.type in src.resistances)
		if(prob(99.9)) return
		src.resistances.Remove(virus.type)//the resistance is futile


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
	if(prob(15/virus.permeability_mod)) return //the power of immunity compels this disease!

	var/obj/item/clothing/Cl = null
	var/passed = 1

	//chances to target this zone
	var/head_ch
	var/body_ch
	var/hands_ch
	var/feet_ch

	switch(virus.spread_type)
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

		switch(target_zone)
			if(1)
				if(isobj(H.head))
					Cl = H.head
					passed = prob(Cl.permeability_coefficient*100*virus.permeability_mod)
//					world << "Head pass [passed]"
				if(passed && isobj(H.wear_mask))
					Cl = H.wear_mask
					passed = prob(Cl.permeability_coefficient*100*virus.permeability_mod)
//					world << "Mask pass [passed]"
			if(2)//arms and legs included
				if(isobj(H.wear_suit))
					Cl = H.wear_suit
					passed = prob(Cl.permeability_coefficient*100*virus.permeability_mod)
//					world << "Suit pass [passed]"
				if(passed && isobj(H.slot_w_uniform))
					Cl = H.slot_w_uniform
					passed = prob(Cl.permeability_coefficient*100*virus.permeability_mod)
//					world << "Uniform pass [passed]"
			if(3)
				if(isobj(H.wear_suit) && H.wear_suit.body_parts_covered&HANDS)
					Cl = H.wear_suit
					passed = prob(Cl.permeability_coefficient*100*virus.permeability_mod)
//					world << "Suit pass [passed]"

				if(passed && isobj(H.gloves))
					Cl = H.gloves
					passed = prob(Cl.permeability_coefficient*100*virus.permeability_mod)
//					world << "Gloves pass [passed]"
			if(4)
				if(isobj(H.wear_suit) && H.wear_suit.body_parts_covered&FEET)
					Cl = H.wear_suit
					passed = prob(Cl.permeability_coefficient*100*virus.permeability_mod)
//					world << "Suit pass [passed]"

				if(passed && isobj(H.shoes))
					Cl = H.shoes
					passed = prob(Cl.permeability_coefficient*100*virus.permeability_mod)
//					world << "Shoes pass [passed]"
			else
				src << "Something strange's going on, something's wrong."

			/*if("feet")
				if(H.shoes && istype(H.shoes, /obj/item/clothing/))
					Cl = H.shoes
					passed = prob(Cl.permeability_coefficient*100)
					//
					world << "Shoes pass [passed]"
			*/		//
	else if(istype(src, /mob/living/carbon/monkey))
		var/mob/living/carbon/monkey/M = src
		switch(target_zone)
			if(1)
				if(M.wear_mask && isobj(M.wear_mask))
					Cl = M.wear_mask
					passed = prob(Cl.permeability_coefficient*100+virus.permeability_mod)
					//world << "Mask pass [passed]"

	if(passed && virus.spread_type == AIRBORNE && src.internals)
		passed = (prob(50*virus.permeability_mod))

	if(passed)
//		world << "Infection in the mob [src]. YAY"


/*
	var/score = 0
	if(istype(src, /mob/living/carbon/human))
		if(src:gloves) score += 5
		if(istype(src:wear_suit, /obj/item/clothing/suit/space)) score += 10
		if(istype(src:wear_suit, /obj/item/clothing/suit/bio_suit)) score += 10
		if(istype(src:head, /obj/item/clothing/head/helmet/space)) score += 5
		if(istype(src:head, /obj/item/clothing/head/bio_hood)) score += 5
	if(src.wear_mask)
		score += 5
		if((istype(src:wear_mask, /obj/item/clothing/mask) || istype(src:wear_mask, /obj/item/clothing/mask/surgical)) && !src.internal)
			score += 5
		if(src.internal)
			score += 5
	if(score > 20)
		return
	else if(score == 20 && prob(95))
		return
	else if(score >= 15 && prob(75))
		return
	else if(score >= 10 && prob(55))
		return
	else if(score >= 5 && prob(35))
		return
	else if(prob(15))
		return
	else*/
		src.virus = new virus.type
		src.virus.strain_data = virus.strain_data.Copy()
		src.virus.affected_mob = src
		src.virus.holder = src
		if(prob(5))
			src.virus.carrier = 1
		return
	return


/datum/disease2/proc/spread(var/source=null)
	//world << "Disease [src] proc spread was called from holder [source]"
	if(src.spread_type == SPECIAL)//does not spread
		return

	if(src.stage < src.contagious_period) //the disease is not contagious at this stage
		return

	if(!source)//no holder specified
		if(src.affected_mob)//no mob affected holder
			source = src.affected_mob
		else //no source and no mob affected. Rogue disease. Break
			return


	var/check_range = AIRBORNE//defaults to airborne - range 4
	if(src.spread_type != AIRBORNE)
		check_range = 0

	for(var/mob/living/carbon/M in oviewers(check_range, source))
		M.contract_disease(src)

	return


/datum/disease2/proc/process()
	if(!src.holder) return
	if(prob(40))
		src.spread(holder)
	if(src.holder == src.affected_mob)
		if(affected_mob.stat < 2) //he's alive
			src.stage_act()
		else //he's dead.
			if(src.spread_type!=SPECIAL)
				src.spread_type = CONTACT_GENERAL
			src.affected_mob = null
	if(!src.affected_mob) //the virus is in inanimate obj
//		world << "[src] longevity = [src.longevity]"
		if(--src.longevity<=0)
			src.cure(0)
	return

/datum/disease2/proc/cure(var/resistance=1)//if resistance = 0, the mob won't develop resistance to disease
	if(resistance && src.affected_mob && !(src.type in affected_mob.resistances))
//		world << "Setting res to [src]"
		var/type = "[src.type]"//copy the value, not create the reference to it, so when the object is deleted, the value remains.
		affected_mob.resistances += text2path(type)
//	world << "Removing [src]"
	spawn(0)
		del(src)
	return


/datum/disease2/New(var/process=1)//process = 1 - adding the object to global list. List is processed by master controller.
	cure_list = list(cure_id) // to add more cures, add more vars to this list in the actual disease's New()
	if(process)					 // Viruses in list are considered active.
		active_diseases += src

/*
/datum/disease/Del()
	active_diseases.Remove(src)
*/


/datum/disease2/effectholder
	var/name = "Holder"
	var/datum/disease2/effect/effect
	var/chance = 0 //Chance in percentage each tick
	var/cure = "" //Type of cure it requires
	var/happensonce = 0
	var/multiplier = 1 //The chance the effects are WORSE
	var/stage = 0

	proc/runeffect(var/mob/living/carbon/human/mob,var/stage)
		if(happensonce > -1 && effect.stage <= stage && prob(chance))
			effect.activate(mob)
			if(happensonce == 1)
				happensonce = -1

	proc/getrandomeffect()
		var/list/datum/disease2/effect/list = list()
		for(var/e in (typesof(/datum/disease2/effect) - /datum/disease2/effect))
		//	world << "Making [e]"
			var/datum/disease2/effect/f = new e
			if(f.stage == src.stage)
				list += f
		effect = pick(list)
		chance = rand(1,6)

	proc/minormutate()
		switch(pick(1,2,3,4,5))
			if(1)
				chance = rand(0,100)
			if(2)
				multiplier = rand(1,effect.maxm)
	proc/majormutate()
		getrandomeffect()

/proc/dprob(var/p)
	return(prob(sqrt(p)) && prob(sqrt(p)))



/proc/infect_virus2(var/mob/living/carbon/M,var/datum/disease2/disease/disease,var/forced = 0)
	if(prob(disease.infectionchance))
		if(M.virus2)
			return
		else
			var/score = 0
			if(!forced)
				if(istype(M, /mob/living/carbon/human))
					if(M:gloves)
						score += 5
					if(istype(M:wear_suit, /obj/item/clothing/suit/space)) score += 10
					if(istype(M:wear_suit, /obj/item/clothing/suit/bio_suit)) score += 10
					if(istype(M:head, /obj/item/clothing/head/helmet/space)) score += 5
					if(istype(M:head, /obj/item/clothing/head/bio_hood)) score += 5
				if(M.wear_mask)
					score += 5
					if((istype(M:wear_mask, /obj/item/clothing/mask) || istype(M:wear_mask, /obj/item/clothing/mask/surgical)) && !M.internal)
						score += 5
					if(M.internal)
						score += 5

			if(score > 20)
				return
			else if(score == 20 && prob(95))
				return
			else if(score == 15 && prob(75))
				return
			else if(score == 10 && prob(55))
				return
			else if(score == 5 && prob(35))
				return

			M.virus2 = disease.getcopy()
//			M.virus2.minormutate()

			for(var/datum/disease2/resistance/res in M.resistances)
				if(res.resistsdisease(M.virus2))
					M.virus2 = null



/datum/disease2/resistance
	var/list/datum/disease2/effect/resistances = list()

	proc/resistsdisease(var/datum/disease2/disease/virus2)
		var/list/res2 = list()
		for(var/datum/disease2/effect/e in resistances)
			res2 += e.type
		for(var/datum/disease2/effectholder/holder in virus2)
			if(!(holder.effect.type in res2))
				return 0
			else
				res2 -= holder.effect.type
		if(res2.len > 0)
			return 0
		else
			return 1

	New(var/datum/disease2/disease/virus2)
		for(var/datum/disease2/effectholder/h in virus2.effects)
			resistances += h.effect.type


/proc/infect_mob_random(var/mob/living/carbon/M)
	if(!M.virus2)
		M.virus2 = new /datum/disease2/disease
//		M.virus2.makerandom()





