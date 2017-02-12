////////////////////////////////
// Resistances and Immunities //
////////////////////////////////

/datum/bioEffect/fireres
	name = "Fire Resistance"
	desc = "Shields the subject's cellular structure against high temperatures and flames."
	id = "fire_resist"
	effectType = effectTypePower
	probability = 66
	blockCount = 3
	msgGain = "You feel cold."
	msgLose = "You feel warm."
	stability_loss = 10

	OnAdd()
		if (ishuman(owner))
			overlay_image = image("icon" = 'icons/effects/genetics.dmi', "icon_state" = "aurapulse", layer = MOB_LIMB_LAYER)
			overlay_image.color = "#FFA200"
		..()

/datum/bioEffect/coldres
	name = "Cold Resistance"
	desc = "Shields the subject's cellular structure against freezing temperatures and crystallization."
	id = "cold_resist"
	effectType = effectTypePower
	probability = 66
	blockCount = 3
	msgGain = "You feel warm."
	msgLose = "You feel cold."
	stability_loss = 10
	// you feel warm because you're resisting the cold, stop changing these around! =(

	OnAdd()
		if (ishuman(owner))
			overlay_image = image("icon" = 'icons/effects/genetics.dmi', "icon_state" = "aurapulse", layer = MOB_LIMB_LAYER)
			overlay_image.color = "#009DFF"
		..()

/datum/bioEffect/thermalres
	name = "Thermal Resistance"
	desc = "Shields the subject's cellular structure against any harmful temperature exposure."
	id = "thermal_resist"
	effectType = effectTypePower
	blockCount = 3
	occur_in_genepools = 0
	stability_loss = 10
	var/image/overlay_image_two = null

	OnAdd()
		if (ishuman(owner))
			overlay_image = image("icon" = 'icons/effects/genetics.dmi', "icon_state" = "aurapulse", layer = MOB_LIMB_LAYER)
			overlay_image_two = image("icon" = 'icons/effects/genetics.dmi', "icon_state" = "aurapulse-offset", layer = MOB_LIMB_LAYER)
			overlay_image.color = "#FFA200"
			overlay_image_two.color = "#009DFF"
		..()
		if(overlay_image_two)
			var/mob/living/L = owner
			L.UpdateOverlays(overlay_image_two, id + "2")

	OnRemove()
		..()
		if(overlay_image_two)
			if(isliving(owner))
				var/mob/living/L = owner
				L.UpdateOverlays(null, id + "2")
		return

/datum/bioEffect/elecres
	name = "SMES Human"
	desc = "Protects the subject's cellular structure from electrical energy."
	id = "resist_electric"
	effectType = effectTypePower
	probability = 66
	blockCount = 3
	blockGaps = 3
	stability_loss = 15
	msgGain = "Your hair stands on end."
	msgLose = "The tingling in your skin fades."

	OnAdd()
		if (ishuman(owner))
			overlay_image = image("icon" = 'icons/effects/genetics.dmi', "icon_state" = "elec[owner:bioHolder.HasEffect("fat") ? "fat" :""]", layer = MOB_EFFECT_LAYER)
		..()
		if (owner:organHolder && owner:organHolder:heart && owner:organHolder:heart:robotic)
			owner:organHolder:heart:broken = 1
			owner:contract_disease(/datum/ailment/disease/flatline,null,null,1)
			boutput(owner, "<span style=\"color:red\">Something is wrong with your cyberheart, it stops beating!</span>")

/datum/bioEffect/rad_resist
	name = "Radiation Resistance"
	desc = "Shields the subject's cellular structure against ionizing radiation."
	id = "rad_resist"
	effectType = effectTypePower
	blockCount = 2
	secret = 1
	stability_loss = 15

/datum/bioEffect/alcres
	name = "Alcohol Resistance"
	desc = "Strongly reinforces the subject's nervous system against alcoholic intoxication."
	id = "resist_alcohol"
	probability = 99
	effectType = effectTypePower
	msgGain = "You feel unusually sober."
	msgLose = "You feel like you could use a stiff drink."

/datum/bioEffect/toxres
	name = "Toxic Resistance"
	desc = "Renders the subject's blood immune to toxification. This will not stop other effects of poisons from occurring, however."
	id = "resist_toxic"
	effectType = effectTypePower
	probability = 8
	blockCount = 4
	blockGaps = 5
	reclaim_mats = 40
	curable_by_mutadone = 0
	stability_loss = 40
	msgGain = "You feel refreshed and clean."
	msgLose = "You feel a bit grody."

	OnAdd()
		if (!istype(owner,/mob/living/carbon/human/))
			return
		var/mob/living/carbon/human/H = owner
		H.toxloss = 0

/datum/bioEffect/breathless
	name = "Anaerobic Metabolism"
	desc = "Allows the subject's body to generate its own oxygen internally, invalidating the need for respiration."
	id = "breathless"
	effectType = effectTypePower
	probability = 8
	blockCount = 4
	blockGaps = 2
	reclaim_mats = 40
	lockProb = 66
	lockedGaps = 3
	lockedDiff = 4
	lockedChars = list("G","C","A","T")
	lockedTries = 10
	stability_loss = 40
	msgGain = "Your lungs feel strangely empty."
	msgLose = "You start gasping for air."

/datum/bioEffect/psychic_resist
	name = "Meta-Neural Enhancement"
	desc = "Boosts efficiency in sectors of the brain commonly associated with resisting meta-mental energies."
	id = "psy_resist"
	probability = 99
	effectType = effectTypePower
	msgGain = "Your mind feels closed."
	msgLose = "You feel oddly exposed."

/////////////
// Healing //
/////////////

/datum/bioEffect/regenerator
	name = "Regeneration"
	desc = "Overcharges the subject's natural healing, enabling them to rapidly heal from any wound."
	id = "regenerator"
	effectType = effectTypePower
	probability = 8
	blockCount = 4
	blockGaps = 3
	reclaim_mats = 40
	lockProb = 66
	lockedGaps = 1
	lockedDiff = 4
	lockedChars = list("G","C","A","T")
	lockedTries = 10
	stability_loss = 40
	msgGain = "Your skin feels tingly and shifty."
	msgLose = "Your skin tightens."
	var/heal_per_tick = 1
	var/regrow_prob = 250

	OnLife()
		var/mob/living/L = owner
		L.HealDamage("All", heal_per_tick, heal_per_tick)
		if (rand(1,regrow_prob) == 1 && istype(L,/mob/living/carbon/human/))
			var/mob/living/carbon/human/H = L
			if (H.limbs)
				H.limbs.mend(1)

/datum/bioEffect/detox
	name = "Natural Anti-Toxins"
	desc = "Enables the subject's bloodstream to purge foreign substances more rapidly."
	id = "detox"
	probability = 66
	blockCount = 2
	blockGaps = 4
	msgGain = "Your pulse seems to relax."
	msgLose = "Your pulse quickens."
	lockProb = 66
	lockedGaps = 3
	lockedDiff = 2
	lockedChars = list("G","C","A","T")
	lockedTries = 10
	curable_by_mutadone = 0
	var/remove_per_tick = 5
	stability_loss = 15

	OnLife()
		var/mob/living/L = owner
		if (L.stat == 2)
			return
		if (L.reagents)
			L.reagents.remove_any(remove_per_tick)

/////////////
// Stealth //
/////////////

/datum/bioEffect/uncontrollable_cloak
	name = "Unstable Refraction"
	desc = "The subject will occasionally become invisible. The subject has no control or awareness of this occurring."
	id = "uncontrollable_cloak"
	effectType = effectTypePower
	probability = 66
	blockCount = 3
	blockGaps = 3
	lockProb = 40
	lockedGaps = 1
	lockedDiff = 4
	lockedChars = list("A","T")
	lockedTries = 6
	var/active = 0
	stability_loss = 15

	OnLife()
		if (prob(20))
			src.active = !src.active
		if (src.active)
			owner.invisibility = 1
		return

/datum/bioEffect/examine_stopper
	name = "Meta-Neural Haze"
	desc = "Causes the subject's brain to emit waves that make the subject's body difficult to observe."
	id = "examine_stopper"
	effectType = effectTypePower
	secret = 1
	blockCount = 3
	blockGaps = 3
	lockProb = 40
	lockedGaps = 1
	lockedDiff = 4
	lockedChars = list("A","T")
	lockedTries = 6
	stability_loss = 5

/datum/bioEffect/dead_scan
	name = "Pseudonecrosis"
	desc = "Causes the subject's cells to mimic a death-like state."
	id = "dead_scan"
	effectType = effectTypePower
	probability = 99
	stability_loss = 5

///////////////////
// General buffs //
///////////////////

/datum/bioEffect/strong
	name = "Musculature Enhancement"
	desc = "Enhances the subject's ability to build and retain heavy muscles."
	id = "strong"
	effectType = effectTypePower
	probability = 99
	msgGain = "You feel buff!"
	msgLose = "You feel wimpy and weak."

/datum/bioEffect/radio_brain
	name = "Meta-Neural Antenna"
	desc = "Enables the subject's brain to pick up radio signals."
	id = "radio_brain"
	effectType = effectTypePower
	probability = 33
	blockCount = 4
	blockGaps = 5
	reclaim_mats = 30
	msgGain = "You can hear weird chatter in your head."
	msgLose = "The weird noise in your head stops."
	lockProb = 40
	lockedGaps = 1
	lockedDiff = 3
	lockedChars = list("G","C","A","T")
	lockedTries = 8
	stability_loss = 5

	OnAdd()
		radio_brains += owner

	OnRemove()
		radio_brains -= owner

var/list/radio_brains = list()

/datum/bioEffect/hulk
	name = "Gamma Ray Exposure"
	desc = "Vastly enhances the subject's musculature. May cause severe melanocyte corruption."
	id = "hulk"
	effectType = effectTypePower
	probability = 33
	blockCount = 4
	blockGaps = 5
	reclaim_mats = 30
	msgGain = "You feel your muscles swell to an immense size."
	msgLose = "Your muscles shrink back down."
	lockProb = 40
	lockedGaps = 1
	lockedDiff = 3
	lockedChars = list("G","C","A","T")
	lockedTries = 8
	stability_loss = 25

	OnAdd()
		owner.unlock_medal("It's not easy being green", 1)
		if (ishuman(owner))
			owner:set_body_icon_dirty()
		..()

	OnMobDraw()
		if(disposed)
			return

		if(ishuman(owner))
			owner:body_standing:overlays += image("icon" = 'icons/effects/genetics.dmi', "icon_state" = "hulk[owner:bioHolder.HasEffect("fat") ? "fat" :""]", layer = MOB_LAYER)

	OnRemove()
		if (ishuman(owner))
			owner:set_body_icon_dirty()

	OnLife()
		..()
		if (owner:health <= 25)
			timeLeft = 1
			boutput(owner, "<span style=\"color:red\">You suddenly feel very weak.</span>")
			owner:weakened = 3
			owner:emote("collapse")


/datum/bioEffect/xray
	name = "X-Ray Vision"
	desc = "Enhances the subject's optic nerves, allowing them to see on x-ray wavelengths."
	id = "xray"
	effectType = effectTypePower
	probability = 33
	blockCount = 3
	blockGaps = 5
	reclaim_mats = 40
	msgGain = "You suddenly seem to be able to see through everything."
	msgLose = "Your vision fades back to normal."
	lockProb = 40
	lockedGaps = 1
	lockedDiff = 3
	lockedChars = list("G","C","A","T")
	lockedTries = 8
	stability_loss = 30

/datum/bioEffect/toxic_farts
	name = "High Decay Digestion"
	desc = "Causes the subject's digestion to create a significant amount of noxious gas."
	id = "toxic_farts"
	probability = 33
	blockCount = 2
	blockGaps = 4
	msgGain = "Your stomach grumbles unpleasantly."
	msgLose = "Your stomach stops acting up. Phew!"
	lockProb = 40
	lockedGaps = 1
	lockedDiff = 3
	lockedChars = list("G","C","A","T")
	lockedTries = 8
	stability_loss = 10

///////////////////////////
// Disabled/Inaccessible //
///////////////////////////

/datum/bioEffect/telekinesis
	name = "Telekinesis"
	desc = "Enables the subject to project kinetic energy using certain thought patterns."
	id = "telekinesis"
	effectType = effectTypePower
	probability = 8
	blockCount = 5
	blockGaps = 5
	reclaim_mats = 40
	msgGain = "You feel your consciousness expand outwards."
	msgLose = "Your conciousness closes inwards."
	stability_loss = 30
	occur_in_genepools = 0

	OnAdd()
		if (ishuman(owner))
			overlay_image = image("icon" = 'icons/effects/genetics.dmi', "icon_state" = "telekinesishead[owner:bioHolder.HasEffect("fat") ? "fat" :""]", layer = MOB_LAYER)
		..()