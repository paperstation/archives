/datum/bioEffect/hidden
	name = "Miner Training"
	desc = "Subject is trained in geological and metallurgical matters."
	id = "training_miner"
	probability = 0
	occur_in_genepools = 0
	scanner_visibility = 0
	curable_by_mutadone = 0
	can_reclaim = 0
	can_copy = 0
	can_scramble = 0
	can_research = 0
	can_make_injector = 0
	reclaim_fail = 100
	effectType = effectTypePower

/datum/bioEffect/hidden/trainingchaplain
	name = "Chaplain Training"
	desc = "Subject is trained in cultural and psychological matters."
	id = "training_chaplain"

//	OnAdd()
//		if (ishuman(owner))
//			owner.add_ability_holder(/datum/abilityHolder/religious)

/datum/bioEffect/hidden/trainingmedical
	name = "Medical Training"
	desc = "Subject is a proficient surgeon."
	id = "training_medical"

/datum/bioEffect/hidden/arcaneshame
	// temporary debuff for when the wizard gets shaved
	name = "Wizard's Shame"
	desc = "Subject is suffering from Post Traumatic Shaving Disorder."
	id = "arcane_shame"
	msgGain = "You feel shameful.  Also bald."
	msgLose = "Your shame fades. Now you feel only righteous anger!"
	effectType = effectTypeDisability
	isBad = 1

/datum/bioEffect/hidden/arcanepower
	// Variant 1 = Half Spell Cooldown, Variant 2 = No Spell Cooldown
	// Only use variant 2 for debugging/horrible admin gimmicks ok
	name = "Arcane Power"
	desc = "Subject is imbued with an unknown power."
	id = "arcane_power"
	msgGain = "Your hair stands on end."
	msgLose = "The tingling in your skin fades."

/datum/bioEffect/hidden/husk
	name = "Husk"
	desc = "Subject appears to have been drained of all fluids."
	id = "husk"
	effectType = effectTypeDisability
	isBad = 1

	OnMobDraw()
		if(ishuman(owner))
			owner:body_standing:overlays += image('icons/mob/human.dmi', "husk")

	OnAdd()
		if (ishuman(owner))
			owner:set_body_icon_dirty()

	OnRemove()
		if (ishuman(owner))
			owner:set_body_icon_dirty()

/datum/bioEffect/hidden/eaten
	name = "Eaten"
	desc = "Subject appears to have been partially consumed."
	id = "eaten"
	effectType = effectTypeDisability
	isBad = 1

	OnMobDraw()
		if (ishuman(owner) && !owner:decomp_stage)
			owner:body_standing:overlays += image('icons/mob/human.dmi', "decomp1")
		return

	OnAdd()
		if (ishuman(owner))
			owner:set_body_icon_dirty()

	OnRemove()
		if (ishuman(owner))
			owner:set_body_icon_dirty()

/datum/bioEffect/hidden/consumed
	name = "Consumed"
	desc = "Most of their flesh has been chewed off."
	id = "consumed"
	effectType = effectTypeDisability

/datum/bioEffect/hidden/zombie
	// Don't put this one in the standard mutantrace pool
	name = "Necrotic Degeneration"
	desc = "Subject's cellular structure is degenerating due to sub-lethal necrosis."
	id = "zombie"
	effectType = effectTypeMutantRace
	isBad = 1
	msgGain = "You begin to rot."
	msgLose = "You are no longer rotting."

	OnAdd()
		owner.set_mutantrace(/datum/mutantrace/zombie)
		return

	OnRemove()
		if (istype(owner:mutantrace, /datum/mutantrace/zombie))
			owner.set_mutantrace(null)
		return

	OnLife()
		if(!istype(owner:mutantrace, /datum/mutantrace/zombie))
			holder.RemoveEffect(id)
		return

/datum/bioEffect/hidden/premature_clone
	// Probably shouldn't put this one in either
	name = "Stunted Genetics"
	desc = "Genetic abnormalities possibly resulting from incomplete development in a cloning pod."
	id = "premature_clone"
	effectType = effectTypeMutantRace
	isBad = 1
	msgGain = "You don't feel quite right."
	msgLose = "You feel normal again."
	var/outOfPod = 0 //Out of the cloning pod.

	OnAdd()
		owner.set_mutantrace(/datum/mutantrace/premature_clone)
		if (!istype(owner.loc, /obj/machinery/clonepod))
			boutput(owner, "<span style=\"color:red\">Your genes feel...disorderly.</span>")
		return

	OnRemove()
		if (istype(owner:mutantrace, /datum/mutantrace/premature_clone))
			owner.set_mutantrace(null)
		return

	OnLife()
		if(!istype(owner:mutantrace, /datum/mutantrace/premature_clone))
			holder.RemoveEffect(id)

		if (outOfPod)
			if (prob(6))
				owner.visible_message("<span style=\"color:red\">[owner.name] suddenly and violently vomits!</span>")
				playsound(owner.loc, "sound/effects/splat.ogg", 50, 1)
				new /obj/decal/cleanable/vomit(owner.loc)

			else if (prob(2))
				owner.visible_message("<span style=\"color:red\">[owner.name] vomits blood!</span>")
				playsound(owner.loc, "sound/effects/splat.ogg", 50, 1)
				random_brute_damage(owner, rand(5,8))
				bleed(owner, rand(5,8), 5)

		else if (!istype(owner.loc, /obj/machinery/clonepod))
			outOfPod = 1

		return

/datum/bioEffect/hidden/sims_stinky
	name = "Poor Hygiene"
	desc = "This guy needs a shower, stat!"
	id = "sims_stinky"
	effectType = effectTypeDisability
	isBad = 1
	curable_by_mutadone = 0
	occur_in_genepools = 0
	var/personalized_stink = "Wow, it stinks in here!"

	New()
		..()
		src.personalized_stink = stinkString()
		if (prob(5))
			src.variant = 2

	OnLife()
		if (prob(10))
			for(var/mob/living/carbon/C in view(6,get_turf(owner)))
				if (C == owner)
					continue
				if (src.variant == 2)
					boutput(C, "<span style=\"color:red\">[src.personalized_stink]</span>")
				else
					boutput(C, "<span style=\"color:red\">[stinkString()]</span>")