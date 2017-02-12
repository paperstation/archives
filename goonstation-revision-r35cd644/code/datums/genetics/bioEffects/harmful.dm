///////////////////////
// Totally Crippling //
///////////////////////

/datum/bioEffect/blind
	name = "Blindness"
	desc = "Disconnects the optic nerves from the brain, rendering the subject unable to see."
	id = "blind"
	effectType = effectTypeDisability
	isBad = 1
	probability = 33
	msgGain = "You can't seem to see anything!"
	msgLose = "Your vision returns!"
	reclaim_fail = 15
	stability_loss = -20
	lockProb = 50
	lockedGaps = 2
	lockedDiff = 4
	lockedChars = list("G","C","A","T")
	lockedTries = 10

/datum/bioEffect/mute
	name = "Frontal Gyrus Suspension"
	desc = "Completely shuts down the speech center of the subject's brain."
	id = "mute"
	effectType = effectTypeDisability
	isBad = 1
	probability = 33
	msgGain = "You feel unable to express yourself at all."
	msgLose = "You feel able to speak freely again."
	reclaim_fail = 15
	stability_loss = -20
	lockProb = 50
	lockedGaps = 2
	lockedDiff = 4
	lockedChars = list("G","C","A","T")
	lockedTries = 10

/datum/bioEffect/deaf
	name = "Deafness"
	desc = "Diminishes the subject's tympanic membrane, rendering them unable to hear."
	id = "deaf"
	effectType = effectTypeDisability
	isBad = 1
	probability = 33
	blockCount = 4
	msgGain = "It's quiet. Too quiet."
	msgLose = "You can hear again!"
	reclaim_fail = 15
	stability_loss = -20
	lockProb = 50
	lockedGaps = 2
	lockedDiff = 4
	lockedChars = list("G","C","A","T")
	lockedTries = 10

///////////////////////////
// Bad but not crippling //
///////////////////////////

/datum/bioEffect/clumsy
	name = "Dyspraxia"
	desc = "Hinders transmissions in the subject's nervous system, causing poor motor skills."
	id = "clumsy"
	effectType = effectTypeDisability
	probability = 66
	isBad = 1
	msgGain = "You feel kind of off-balance and disoriented."
	msgLose = "You feel well co-ordinated again."
	reclaim_fail = 15
	stability_loss = -5

/datum/bioEffect/narcolepsy
	name = "Narcolepsy"
	desc = "Alters the sleep center of the subject's brain, causing bouts of involuntary sleepiness."
	id = "narcolepsy"
	effectType = effectTypeDisability
	probability = 66
	isBad = 1
	msgGain = "You feel a bit sleepy."
	msgLose = "You feel wide awake."
	reclaim_fail = 15
	stability_loss = -5
	var/sleep_prob = 4

	OnLife()
		var/mob/living/L = owner
		if (!L)
			return
		if (prob(sleep_prob))
			L.sleeping = 1

/datum/bioEffect/coprolalia
	name = "Coprolalia"
	desc = "Causes involuntary outbursts from the subject."
	id = "coprolalia"
	effectType = effectTypeDisability
	probability = 99
	isBad = 1
	msgGain = "You can't seem to shut up!"
	msgLose = "You feel more in control."
	reclaim_fail = 15
	var/talk_prob = 10
	var/list/talk_strings = list("PISS","FUCK","SHIT","DAMN","TITS","ARGH","WOOF","CRAP","BALLS")

	OnLife()
		var/mob/living/L = owner
		if (!L)
			return
		if (L.stat == 2)
			return
		if (prob(talk_prob))
			L.say(pick(talk_strings))

/datum/bioEffect/fat
	name = "Obesity"
	desc = "Greatly slows the subject's metabolism, enabling greater buildup of lipid tissue."
	id = "fat"
	probability = 99
	effectType = effectTypeDisability
	isBad = 1
	msgGain = "You feel blubbery and lethargic!"
	msgLose = "You feel fit!"
	reclaim_fail = 15
	stability_loss = -5

	OnAdd()
		if (ishuman(owner))
			owner:set_body_icon_dirty()
			owner.unlock_medal("Space Ham", 1)

	OnRemove()
		if (ishuman(owner))
			owner:set_body_icon_dirty()

/datum/bioEffect/shortsighted
	name = "Diminished Optic Nerves"
	desc = "Reduces the subject's ability to see clearly without glasses or other visual aids."
	id = "bad_eyesight"
	effectType = effectTypeDisability
	probability = 99
	isBad = 1
	msgGain = "Your vision blurs."
	msgLose = "Your vision is no longer blurry."
	reclaim_fail = 15
	stability_loss = -5
	var/datum/hud/vision_impair/hud = new
	var/applied = 1

	OnAdd()
		owner.attach_hud(src.hud)

	OnRemove()
		owner.detach_hud(src.hud)

	OnLife()
		if (owner.client && istype(owner,/mob/living/carbon/human/) && owner.sight_check(1))
			var/mob/living/carbon/human/H = owner
			var/corrected_vision = 0
			if (H.glasses) // Marq fix for cannot read null.correct_bad_vision
				if (H.glasses.correct_bad_vision)
					corrected_vision = 1

			if (!corrected_vision)
				if (!applied)
					owner.attach_hud(src.hud)
					applied = 1
			else
				if (applied)
					owner.detach_hud(src.hud)
					applied = 0

		return

/datum/bioEffect/epilepsy
	name = "Epilepsy"
	desc = "Causes damage to the subject's brain structure, resulting in occasional siezures from brain misfires."
	id = "epilepsy"
	effectType = effectTypeDisability
	isBad = 1
	probability = 66
	blockCount = 3
	msgGain = "Your thoughts become disorderly and hard to control."
	msgLose = "Your mind regains its former clarity."
	reclaim_fail = 15
	stability_loss = -10

	OnLife()
		if (owner.stat == 2)
			return
		if (prob(1) && owner:paralysis < 1)
			owner:visible_message("<span style=\"color:red\"><B>[owner] starts having a seizure!</span>", "<span style=\"color:red\">You have a seizure!</span>")
			owner:paralysis = max(2, owner:paralysis)
			owner:make_jittery(100)
		return

/datum/bioEffect/tourettes
	name = "Tourettes"
	desc = "Alters the subject's brain structure, causing periodic involuntary movements and outbursts."
	id = "tourettes"
	effectType = effectTypeDisability
	isBad = 1
	probability = 66
	msgGain = "You feel like you can't control your actions fully."
	msgLose = "You feel in full control of yourself once again."
	reclaim_fail = 15
	stability_loss = -5

	OnLife()
		if (owner.stat == 2)
			return
		if ((prob(10) && owner:paralysis <= 1))
			owner:stunned = max(3, owner:stunned)
			spawn( 0 )
				switch(rand(1, 3))
					if (1 to 2)
						owner:emote("twitch")
					if (3)
						if (owner:client)
							var/enteredtext = winget(owner, "mainwindow.input", "text")
							if ((copytext(enteredtext,1,6) == "say \"") && length(enteredtext) > 5)
								winset(owner, "mainwindow.input", "text=\"\"")
								if (prob(50))
									owner:say(uppertext(copytext(enteredtext,6,0)))
								else
									owner:say(copytext(enteredtext,6,0))
		return

/datum/bioEffect/cough
	name = "Chronic Cough"
	desc = "Enhances the sensitivity of nerves in the subject's throat, causing periodic coughing fits."
	id = "cough"
	probability = 99
	effectType = effectTypeDisability
	isBad = 1
	msgGain = "You feel an irritating itch in your throat."
	msgLose = "Your throat clears up."
	reclaim_fail = 15

	OnLife()
		if (owner.stat == 2)
			return
		if ((prob(5) && owner:paralysis <= 1))
			owner:drop_item()
			spawn (0)
				owner:emote("cough")
				return
		return

#define LIMB_IS_ARM 1
#define LIMB_IS_LEG 2
/datum/bioEffect/funky_limb
	name = "Motor Neuron Signal Enhancement" // heh
	desc = "Causes involuntary muscle contractions in limbs, due to a loss of inhibition of motor neurons."
	id = "funky_limb"
	effectType = effectTypeDisability
	isBad = 1
	probability = 33
	blockCount = 4
	msgGain = "One of your limbs feels a bit strange and twitchy."
	msgLose = "Your limb feels fine again."
	reclaim_fail = 15
	stability_loss = -20
	lockProb = 50
	lockedGaps = 2
	lockedDiff = 4
	lockedChars = list("G","C","A","T")
	lockedTries = 10
	var/obj/item/parts/limb = null
	var/limb_type = LIMB_IS_ARM

	OnAdd()
		..()
		if (!ishuman(owner))
			return
		var/mob/living/carbon/human/H = owner
		var/list/possible_limbs = list()
		if (H.limbs.l_arm)
			possible_limbs += H.limbs.l_arm
		if (H.limbs.r_arm)
			possible_limbs += H.limbs.r_arm
		if (H.limbs.l_leg)
			possible_limbs += H.limbs.l_leg
		if (H.limbs.r_leg)
			possible_limbs += H.limbs.r_leg
		if (!possible_limbs.len)
			return

		src.limb = pick(possible_limbs)

		if (istype(src.limb, /obj/item/parts/human_parts/arm) || istype(src.limb, /obj/item/parts/robot_parts/arm))
			src.limb_type = LIMB_IS_ARM
			return
		else if (istype(src.limb, /obj/item/parts/human_parts/leg) || istype(src.limb, /obj/item/parts/robot_parts/leg))
			src.limb_type = LIMB_IS_LEG
			return

	OnLife()
		..()
		if (!src.limb || (src.limb.loc != src.owner))
			return
		if (owner.stat)
			return

		if (src.limb_type == LIMB_IS_ARM)
			if (prob(5))
				owner.visible_message("<span style=\"color:red\">[owner.name]'s [src.limb] makes a [pick("rude", "funny", "weird", "lewd", "strange", "offensive", "cruel", "furious")] gesture!</span>")
			else if (prob(2))
				owner.emote("slap")
			else if (prob(2))
				owner.visible_message("<span style=\"color:red\"><B>[owner.name]'s [src.limb] punches [him_or_her(owner)] in the face!</B></span>")
				owner.TakeDamage("head", rand(2,5), 0, 0, DAMAGE_BLUNT)
			else if (prob(1))
				owner.visible_message("<span style=\"color:red\">[owner.name]'s [src.limb] tries to strangle [him_or_her(owner)]!</span>")
				while (prob(80) && owner.bioHolder.HasEffect("funky_limb"))
					owner.losebreath = max(owner.losebreath, 2)
					sleep(10)
				owner.visible_message("<span style=\"color:red\">[owner.name]'s [src.limb] stops trying to strangle [him_or_her(owner)].</span>")
			return

		else if (src.limb_type == LIMB_IS_LEG)
			if (prob(5))
				owner.visible_message("<span style=\"color:red\">[owner.name]'s [src.limb] twitches [pick("rudely", "awkwardly", "weirdly", "lewdly", "strangely", "offensively", "cruelly", "furiously")]!</span>")
			else if (prob(3))
				owner.visible_message("<span style=\"color:red\"><B>[owner.name] trips over [his_or_her(owner)] own [src.limb]!</B></span>")
				owner.weakened += 2
			else if (prob(2))
				owner.visible_message("<span style=\"color:red\"><B>[owner.name]'s [src.limb] kicks [him_or_her(owner)] in the head somehow!</B></span>")
				owner.paralysis += 5
				owner.TakeDamage("head", rand(5,10), 0, 0, DAMAGE_BLUNT)
			else if (prob(2))
				owner.visible_message("<span style=\"color:red\"><B>[owner.name] can't seem to control [his_or_her(owner)] [src.limb]!</B></span>")
				owner.change_misstep_chance(10)
			return

#undef LIMB_IS_ARM
#undef LIMB_IS_LEG

///////////////////////////////////////
// Harmful to others as well as self //
///////////////////////////////////////

/datum/bioEffect/radioactive
	name = "Radioactive"
	desc = "The subject suffers from constant radiation sickness and causes the same on nearby organics."
	id = "radioactive"
	effectType = effectTypeDisability
	probability = 66
	blockCount = 3
	blockGaps = 3
	isBad = 1
	stability_loss = 10
	msgGain = "You feel a strange sickness permeate your whole body."
	msgLose = "You no longer feel awful and sick all over."
	reclaim_fail = 15

	OnAdd()
		if (ishuman(owner))
			overlay_image = image("icon" = 'icons/effects/genetics.dmi', "icon_state" = "aurapulse", layer = MOB_LIMB_LAYER)
			overlay_image.color = "#BBD90F"
		..()

	OnLife()
		owner.radiation = max(owner.radiation, 20)
		for(var/mob/living/L in range(1, owner))
			if (L == owner)
				continue
			boutput(L, "<span style=\"color:red\">You are enveloped by a soft green glow emanating from [owner].</span>")
			L.irradiate(5)
		return

/datum/bioEffect/mutagenic_field
	name = "Mutagenic Field"
	desc = "The subject emits low-level radiation that may cause everyone in range to mutate."
	id = "mutagenic_field"
	effectType = effectTypeDisability
	isBad = 1
	probability = 33
	blockCount = 3
	blockGaps = 4
	msgGain = "Your flesh begins to warp and contort weirdly!"
	msgLose = "You stop warping and contorting. Phew, what a relief..."
	reclaim_fail = 50
	lockProb = 50
	lockedGaps = 2
	lockedDiff = 4
	lockedChars = list("G","C","A","T")
	lockedTries = 10
	stability_loss = 50
	var/affect_others = 0
	var/field_range = 2
	var/proc_prob = 5
	var/mutation_type = "either"

	New()
		..()
		if (prob(25))
			mutation_type = "bad"
			if (prob(5))
				mutation_type = "good"

	OnLife()
		if (prob(proc_prob))
			owner.bioHolder.RandomEffect(mutation_type,1)
			if (affect_others)
				for(var/mob/living/L in range(field_range, get_turf(owner)))
					if (!L.bioHolder)
						continue
					L.bioHolder.RandomEffect(mutation_type,1)
				return

/datum/bioEffect/involuntary_teleporting
	name = "Spatial Destabilization"
	desc = "Causes the subject's molecular structure to become partially unstuck in space."
	id = "involuntary_teleporting"
	effectType = effectTypeDisability
	isBad = 1
	probability = 33
	blockCount = 3
	blockGaps = 4
	msgGain = "You feel a bit out of place."
	msgLose = "You feel firmly rooted in place again."
	lockProb = 40
	lockedGaps = 1
	lockedDiff = 3
	lockedChars = list("G","C","A","T")
	lockedTries = 8
	stability_loss = 15
	var/tele_prob = 5

	OnLife()
		var/mob/living/L = owner
		if (!isturf(L.loc))
			return
		if (prob(tele_prob))
			var/list/randomturfs = new/list()
			for(var/turf/simulated/floor/T in orange(L, 10))
				randomturfs.Add(T)

			if (randomturfs.len > 0)
				L.emote("hiccup")
				L.set_loc(pick(randomturfs))

//////////////
// Annoying //
//////////////

/datum/bioEffect/emoter
	name = "Irritable Bowels"
	desc = "Causes the subject to experience frequent involuntary flatus."
	id = "farty"
	effectType = effectTypeDisability
	isBad = 1
	msgGain = "Your guts are rumbling."
	msgLose = "Your guts settle down."
	probability = 99
	var/emote_prob = 15
	var/emote_type = "fart"

	OnLife()
		var/mob/living/L = owner
		if (!L)
			return
		if (L.stat == 2)
			return
		if (prob(emote_prob))
			L.emote(emote_type)

/datum/bioEffect/emoter/screamer
	name = "Paranoia"
	desc = "Causes the subject to become easily startled."
	id = "screamer"
	msgGain = "They're gonna get you!!!!!"
	msgLose = "You calm down."
	emote_type = "scream"
	emote_prob = 10

////////////////////////////
// Disabled for *Reasons* //
////////////////////////////

/datum/bioEffect/mind_jockey
	name = "Meta-Neural Transferral"
	desc = "The subject's brainwaves will occasionally involuntarily switch with those of another near them."
	id = "mind_jockey"
	effectType = effectTypeDisability
	occur_in_genepools = 0
	isBad = 1
	msgGain = "You wanna be somebody else."
	msgLose = "You're happy with yourself."
	var/proc_prob = 5

	OnLife()
		if (prob(proc_prob))
			var/list/potential_victims = list()
			for(var/mob/living/carbon/human/H in range(7,owner))
				if (!H.client || H.stat)
					continue
				potential_victims += H
			if (potential_victims.len)
				var/mob/living/carbon/human/this_one = pick(potential_victims)
				boutput(src, "<span style=\"color:red\">Your mind twangs uncomfortably!</span>")
				boutput(this_one, "<span style=\"color:red\">Your mind twangs uncomfortably!</span>")
				owner.mind.swap_with(this_one)

/datum/bioEffect/mutagenic_field/prenerf
	name = "High-Power Mutagenic Field"
	id = "mutagenic_field_prenerf"
	affect_others = 1
	occur_in_genepools = 0

/datum/bioEffect/randomeffects
	name = "Booster Gene Q"
	desc = "This function of this gene is not well-researched."
	researched_desc = "This gene has random, unpredictable effects on the subject."
	id = "randomeffects"
	occur_in_genepools = 0
	blockCount = 2
	blockGaps = 4
	lockProb = 66
	lockedGaps = 1
	lockedDiff = 4
	lockedChars = list("G","C","A","T")
	lockedTries = 10
	curable_by_mutadone = 0
	stability_loss = 15
	var/prob_per_tick = 15
	var/list/emotes = list("slap","snap","hiccup","burp","fart","dance","tantrum","flipoff","flip","boggle")
	var/list/noises = list('sound/items/hellhorn_0.ogg','sound/effects/cat.ogg','sound/items/sax.ogg',
	'sound/machines/engine_alert3.ogg','sound/machines/fortune_riff.ogg','sound/misc/ancientbot_grump2.ogg',
	'sound/misc/diarrhea.ogg','sound/misc/sad_server_death.ogg','sound/misc/werewolf_howl.ogg',
	'sound/voice/MEruncoward.ogg','sound/voice/macho/macho_become_enraged01.ogg',
	'sound/voice/macho/macho_rage_81.ogg','sound/voice/macho/macho_rage_73.ogg','sound/weapons/male_cswordstart.ogg')

	New(var/for_global_list = 0)
		..()
		if (!for_global_list)
			name = "Booster Gene"

	OnLife()
		if (prob(prob_per_tick))
			var/mob/living/L = owner
			var/picker = rand(1,5)
			switch(picker)
				if (1)
					L.HealDamage("All",10,0)
				if (2)
					var/list/randomturfs = new/list()
					for(var/turf/simulated/floor/T in orange(L, 10))
						randomturfs.Add(T)

					if (randomturfs.len > 0)
						L.emote("hiccup")
						L.set_loc(pick(randomturfs))
				if (3)
					L.emote(pick(emotes))
				if (4)
					L.color = random_color_hex()
					var/turf/T = get_turf(L)
					T.color = random_color_hex()
				if (5)
					L.visible_message("<span style=\"color:red\"><b>[L.name]</b> makes a weird noise!</span>")
					playsound(L.loc, pick(noises), 50, 0)