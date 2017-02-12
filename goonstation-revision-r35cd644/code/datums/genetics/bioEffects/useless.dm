/datum/bioEffect/glowy
	name = "Glowy"
	desc = "Endows the subject with bioluminescent skin. Color and intensity may vary by subject."
	id = "glowy"
	probability = 99
	effectType = effectTypePower
	blockCount = 3
	blockGaps = 1
	msgGain = "Your skin begins to glow softly."
	msgLose = "Your glow fades away."
	var/datum/light/light

	New()
		..()
		light = new /datum/light/point
		light.set_color(rand(1,10) / 10, rand(1,10) / 10, rand(1,10) / 10)
		light.set_brightness(0.7)

	OnAdd()
		light.attach(owner)
		light.enable()

	OnRemove()
		light.disable()
		light.detach()

/datum/bioEffect/horns
	name = "Cranial Keratin Formation"
	desc = "Enables the growth of a compacted keratin formation on the subject's head."
	id = "horns"
	effectType = effectTypePower
	probability = 99
	msgGain = "A pair of horns erupt from your head."
	msgLose = "Your horns crumble away into nothing."

	OnAdd()
		if (ishuman(owner))
			overlay_image = image("icon" = 'icons/effects/genetics.dmi', "icon_state" = "horns", layer = MOB_LAYER)
		..()

/datum/bioEffect/particles
	name = "Dermal Glitter"
	desc = "Causes the subject's skin to shine and gleam."
	id = "shiny"
	effectType = effectTypePower
	probability = 66
	msgGain = "Your skin looks all blinged out."
	msgLose = "Your skin fades to a more normal state."
	var/system_path = /datum/particleSystem/sparkles

	OnAdd()
		if (!particleMaster.CheckSystemExists(system_path, owner))
			particleMaster.SpawnSystem(new system_path(owner))

	OnRemove()
		if (!particleMaster.CheckSystemExists(system_path, owner))
			particleMaster.RemoveSystem(system_path, owner)

/datum/bioEffect/color_changer
	name = "Melanin Suppressor"
	desc = "Shuts down all melanin production in the subject's body."
	id = "albinism"
	effectType = effectTypePower
	probability = 99
	var/eye_color_to_use = "#FF0000"
	var/color_to_use = "#FFFFFF"
	var/skintone_to_use = 35
	var/holder_eyes = null
	var/holder_hair = null
	var/holder_det1 = null
	var/holder_det2 = null
	var/holder_skin = null

	OnAdd()
		if (!istype(owner,/mob/living/carbon/human/))
			return

		var/mob/living/carbon/human/H = owner
		if (!H.bioHolder)
			return
		var/datum/bioHolder/B = H.bioHolder
		if (!B.mobAppearance)
			return
		var/datum/appearanceHolder/AH = H.bioHolder.mobAppearance
		holder_eyes = AH.e_color
		holder_hair = AH.customization_first_color
		holder_det1 = AH.customization_second_color
		holder_det2 = AH.customization_third_color
		holder_skin = AH.s_tone
		AH.e_color = eye_color_to_use
		AH.s_tone = skintone_to_use
		AH.customization_first_color = color_to_use
		AH.customization_second_color = color_to_use
		AH.customization_third_color = color_to_use
		H.update_face()
		H.update_body()

	OnRemove()
		if (!istype(owner,/mob/living/carbon/human/))
			return

		var/mob/living/carbon/human/H = owner
		if (!H.bioHolder)
			return
		var/datum/bioHolder/B = H.bioHolder
		if (!B.mobAppearance)
			return
		var/datum/appearanceHolder/AH = H.bioHolder.mobAppearance
		AH.e_color = holder_eyes
		AH.s_tone = holder_skin
		AH.customization_first_color = holder_hair
		AH.customization_second_color = holder_det1
		AH.customization_third_color = holder_det2
		H.update_face()
		H.update_body()

/datum/bioEffect/color_changer/black
	name = "Melanin Stimulator"
	desc = "Overstimulates the subject's melanin glands."
	id = "melanism"
	effectType = effectTypePower
	probability = 99
	eye_color_to_use = "#572E0B"
	color_to_use = "#000000"
	skintone_to_use = -185

/datum/bioEffect/stinky
	name = "Apocrine Enhancement"
	desc = "Increases the amount of natural body substances produced from the subject's apocrine glands."
	id = "stinky"
	probability = 99
	effectType = effectTypeDisability
	isBad = 1
	msgGain = "You feel sweaty."
	msgLose = "You feel much more hygenic."
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

/datum/bioEffect/drunk
	name = "Ethanol Production"
	desc = "Encourages growth of ethanol-producing symbiotic fungus in the subject's body."
	id = "drunk"
	msgGain = "You feel drunk!"
	msgLose = "You feel sober."
	probability = 99
	var/ethanol_threshold = 80
	var/add_per_tick = 1

	OnLife()
		var/mob/living/L = owner
		if (L.stat == 2)
			return
		if (L.reagents && L.reagents.get_reagent_amount("ethanol") < ethanol_threshold)
			L.reagents.add_reagent("ethanol",add_per_tick)

/datum/bioEffect/bee
	name = "Apidae Metabolism"
	desc = {"Human worker clone batch #92 may contain inactive space bee DNA.
	If you do not have the authorization level to know that SS13 is staffed with clones, please forget this entire message."}
	id = "bee"
	msgGain = "You feel buzzed"
	msgLose = "You lose your buzz."
	probability = 99

/datum/bioEffect/chime_snaps
	name = "Dactyl Crystallization"
	desc = "The subject's digits crystallize and, when struck together, emit a pleasant noise."
	id = "chime_snaps"
	effectType = effectTypePower
	probability = 99
	msgGain = "Your fingers and toes turn transparent and crystalline."
	msgLose = "Your fingers and toes return to normal."

/datum/bioEffect/aura
	name = "Dermal Glow"
	desc = "Causes the subject's skin to emit faint light patterns."
	id = "aura"
	effectType = effectTypePower
	probability = 99
	msgGain = "You start to emit a pulsing glow."
	msgLose = "The glow in your skin fades."
	var/ovl_sprite = null
	var/color_hex = null

	New()
		..()
		ovl_sprite = pick("aurapulse","aurapulse-fast","aurapulse-slow","aurapulse-offset")
		color_hex = random_color_hex()

	OnAdd()
		if (ishuman(owner))
			overlay_image = image("icon" = 'icons/effects/genetics.dmi', "icon_state" = ovl_sprite, layer = MOB_LIMB_LAYER)
			overlay_image.color = color_hex
		..()

//////////////////////
// Combination Only //
//////////////////////

/datum/bioEffect/fire_aura
	name = "Blazing Aura"
	desc = "Causes the subject's skin to emit harmless false fire."
	id = "aura_fire"
	effectType = effectTypePower
	occur_in_genepools = 0
	msgGain = "You burst into flames!"
	msgLose = "Your skin stops emitting fire."
	var/ovl_sprite = null
	var/color_hex = null

	New()
		..()
		color_hex = random_color_hex()

	OnAdd()
		if (ishuman(owner))
			overlay_image = image("icon" = 'icons/effects/genetics.dmi', "icon_state" = "fireaura", layer = MOB_LIMB_LAYER)
			overlay_image.color = color_hex
		..()