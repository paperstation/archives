/datum/achievementReward
	var/title = ""
	var/desc = ""
	var/required_medal = null
	var/once_per_round = 1   //Can only be claimed once per round.

	proc/rewardActivate(var/mob/activator) //Called when the reward is claimed from the locker. Spawn item here / give verbs here / do whatever for reward.
		boutput(activator, "This reward is undefined. Please inform a coder.")
		return							   //You could even make one-time reward by stripping their medal here.

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// Rewards below
/datum/achievementReward/satchel
	title = "(Skin) Satchel"
	desc = "Converts whatever backpack you're wearing into a satchel. Requires that you're wearing a backpack."
	required_medal = "Fish"
	once_per_round = 0

	rewardActivate(var/mob/activator)
		if (!istype(activator))
			return

		if (!activator.back)
			boutput(activator, "<span style=\"color:red\">You can't reskin a backpack if you're not wearing one!</span>")
			return

		if (istype(activator.back, /obj/item/storage/backpack/medic))
			var/obj/item/storage/backpack/medic/M = activator.back
			var/prev1 = M.name
			M.icon = 'icons/obj/storage.dmi'
			M.inhand_image_icon = 'icons/mob/inhand/hand_general.dmi'
			M.inhand_image.icon = 'icons/mob/inhand/hand_general.dmi'
			M.wear_image_icon = 'icons/mob/back.dmi'
			M.wear_image.icon = 'icons/mob/back.dmi'
			M.icon_state = "satchel_medic"
			M.item_state = "backpack"
			M.name = "medic's satchel"
			M.desc = "A thick, wearable container made of synthetic fibers, able to carry a number of objects comfortably on a crewmember's shoulder. (Base Item: [prev1])"
			activator.set_clothing_icon_dirty()

		else if (istype(activator.back, /obj/item/storage/backpack/NT))
			var/obj/item/storage/backpack/NT/M = activator.back
			var/prev2 = M.name
			M.icon = 'icons/obj/storage.dmi'
			M.inhand_image_icon = 'icons/mob/inhand/hand_general.dmi'
			M.inhand_image.icon = 'icons/mob/inhand/hand_general.dmi'
			M.wear_image_icon = 'icons/mob/back.dmi'
			M.wear_image.icon = 'icons/mob/back.dmi'
			M.icon_state = "NTsatchel"
			M.item_state = "backpack"
			M.name = "NT satchel"
			M.desc = "A thick, wearable container made of synthetic fibers, able to carry a number of objects comfortably on a crewmember's shoulder. (Base Item: [prev2])"
			activator.set_clothing_icon_dirty()

		else if (istype(activator.back, /obj/item/storage/backpack))
			var/obj/item/storage/backpack/M = activator.back
			var/prev3 = M.name
			M.icon = 'icons/obj/storage.dmi'
			M.inhand_image_icon = 'icons/mob/inhand/hand_general.dmi'
			M.inhand_image.icon = 'icons/mob/inhand/hand_general.dmi'
			M.wear_image_icon = 'icons/mob/back.dmi'
			M.wear_image.icon = 'icons/mob/back.dmi'
			M.icon_state = "satchel"
			M.item_state = "backpack"
			M.name = "satchel"
			M.desc = "A thick, wearable container made of synthetic fibers, able to carry a number of objects comfortably on a crewmember's shoulder. (Base Item: [prev3])"
			activator.set_clothing_icon_dirty()

		else
			boutput(activator, "<span style=\"color:red\">Whatever it is you've got on your back, it can't be reskinned!</span>")
			return

		return

/datum/achievementReward/hightechpodskin
	title = "(Skin) HighTech Pod"
	desc = "Gives you a Kit that allows you to change the appearance of a Pod."
	required_medal = "Newton's Crew"

	rewardActivate(var/mob/activator)
		boutput(usr, "<span style=\"color:blue\">The Kit has been dropped at your current location.</span>")
		new /obj/item/pod/paintjob/tronthing(get_turf(activator))
		return

/datum/achievementReward/swatgasmask
	title = "(Skin) SWAT Gas Mask"
	desc = "Turns your Gas Mask into a SWAT Gas Mask. If you're wearing one."
	required_medal = "Leave no man behind!"

	rewardActivate(var/mob/activator)
		if (!istype(activator))
			return

		if (activator.wear_mask && istype(activator.wear_mask, /obj/item/clothing/mask/gas))
			var/obj/item/clothing/mask/gas/emergency/M = activator.wear_mask
			M.icon_state = "swat"
			M.item_state = "swat"
			M.name = "SWAT Gas Mask"
			M.desc = "A snazzy-looking black Gas Mask."
			activator.set_clothing_icon_dirty()
		return

/datum/achievementReward/round_flask
	title = "(Skin) Round-bottom Flask"
	desc = "Requires you to be holding a large beaker."
	required_medal = "We didn't start the fire"
	once_per_round = 0

	rewardActivate(var/mob/activator)
		if (!istype(activator))
			return

		if (istype(activator.l_hand, /obj/item/reagent_containers/glass/beaker/large))
			var/obj/item/reagent_containers/glass/beaker/large/M = activator.l_hand
			var/prev = M.name
			M.name = "round-bottom flask"
			M.desc = "A large round-bottom flask, for all your chemistry needs. (Base Item: [prev])"
			M.icon_style = "flask"
			M.item_state = "flask"
			M.update_icon()
			activator.set_clothing_icon_dirty()

		else if (istype(activator.r_hand, /obj/item/reagent_containers/glass/beaker/large))
			var/obj/item/reagent_containers/glass/beaker/large/M = activator.r_hand
			var/prev = M.name
			M.name = "round-bottom flask"
			M.desc = "A large round-bottom flask, for all your chemistry needs. (Base Item: [prev])"
			M.icon_style = "flask"
			M.item_state = "flask"
			M.update_icon()
			activator.set_clothing_icon_dirty()

		else
			boutput(activator, "<span style=\"color:red\">You need to be holding a large beaker in order to claim this reward!</span>")
			return

		return

/datum/achievementReward/pilotuniform
	title = "(Skin) Pilot Suit"
	desc = "Requires that you wear something in your jumpsuit slot."
	required_medal = "It's not 'Door to Heaven'"

	rewardActivate(var/mob/activator)
		if (ishuman(activator))
			var/mob/living/carbon/human/H = activator
			if (H.w_uniform)
				var/obj/item/clothing/M = H.w_uniform
				var/prev = M.name
				M.icon = 'icons/obj/clothing/uniforms/item_js_misc.dmi'
				M.inhand_image_icon = 'icons/mob/inhand/jumpsuit/hand_js_misc.dmi'
				M.inhand_image.icon = 'icons/mob/inhand/jumpsuit/hand_js_misc.dmi'
				M.wear_image_icon = 'icons/mob/jumpsuits/worn_js_misc.dmi'
				M.wear_image.icon = 'icons/mob/jumpsuits/worn_js_misc.dmi'
				M.icon_state = "mechanic"
				M.item_state = "mechanic"
				M.name = "pilot suit"
				M.desc = "(Base Item: [prev])"
				H.set_clothing_icon_dirty()
		return

/datum/achievementReward/med_labcoat
	title = "(Skin) Medical Labcoat"
	desc = "Requires that you wear a labcoat in your suit slot."
	required_medal = "Patchwork"
	once_per_round = 0

	rewardActivate(var/mob/activator)
		if (ishuman(activator))
			var/mob/living/carbon/human/H = activator
			if (H.wear_suit)
				var/obj/item/clothing/M = H.wear_suit
				if (!istype(M, /obj/item/clothing/suit/labcoat))
					boutput(activator, "<span style=\"color:red\">You're not wearing a labcoat!</span>")
					return
				var/prev = M.name
				M.icon = 'icons/obj/clothing/overcoats/item_suit.dmi'
				M.inhand_image_icon = 'icons/mob/inhand/inhand_cl_suit.dmi'
				M.inhand_image.icon = 'icons/mob/inhand/inhand_cl_suit.dmi'
				M.wear_image_icon = 'icons/mob/overcoats/worn_suit.dmi'
				M.wear_image.icon = 'icons/mob/overcoats/worn_suit.dmi'
				M.icon_state = "MDlabcoat"
				M.item_state = "MDlabcoat"
				M.name = "doctor's labcoat"
				M.desc = "A protective laboratory coat with the red markings of a Medical Doctor. (Base Item: [prev])"
				H.set_clothing_icon_dirty()
		return

/datum/achievementReward/sci_labcoat
	title = "(Skin) Science Labcoat"
	desc = "Requires that you wear a labcoat in your suit slot."
	required_medal = "Meth is a hell of a drug"
	once_per_round = 0

	rewardActivate(var/mob/activator)
		if (ishuman(activator))
			var/mob/living/carbon/human/H = activator
			if (H.wear_suit)
				var/obj/item/clothing/M = H.wear_suit
				if (!istype(M, /obj/item/clothing/suit/labcoat))
					boutput(activator, "<span style=\"color:red\">You're not wearing a labcoat!</span>")
					return
				var/prev = M.name
				M.icon = 'icons/obj/clothing/overcoats/item_suit.dmi'
				M.inhand_image_icon = 'icons/mob/inhand/inhand_cl_suit.dmi'
				M.inhand_image.icon = 'icons/mob/inhand/inhand_cl_suit.dmi'
				M.wear_image_icon = 'icons/mob/overcoats/worn_suit.dmi'
				M.wear_image.icon = 'icons/mob/overcoats/worn_suit.dmi'
				M.icon_state = "SCIlabcoat"
				M.item_state = "SCIlabcoat"
				M.name = "scientist's labcoat"
				M.desc = "A protective laboratory coat with the purple markings of a Scientist. (Base Item: [prev])"
				H.set_clothing_icon_dirty()
		return

/datum/achievementReward/alchemistrobes
	title = "(Skin) Grand Alchemist's Robes"
	desc = "Requires that you wear a labcoat in your suit slot."
	required_medal = "Illuminated"
	once_per_round = 0

	rewardActivate(var/mob/activator)
		if (ishuman(activator))
			var/mob/living/carbon/human/H = activator
			if (H.wear_suit)
				var/obj/item/clothing/M = H.wear_suit
				if (!istype(M, /obj/item/clothing/suit/labcoat))
					boutput(activator, "<span style=\"color:red\">You're not wearing a labcoat!</span>")
					return
				var/prev = M.name
				M.icon = 'icons/obj/clothing/overcoats/item_suit.dmi'
				M.inhand_image_icon = 'icons/mob/inhand/inhand_cl_suit.dmi'
				M.inhand_image.icon = 'icons/mob/inhand/inhand_cl_suit.dmi'
				M.wear_image_icon = 'icons/mob/overcoats/worn_suit.dmi'
				M.wear_image.icon = 'icons/mob/overcoats/worn_suit.dmi'
				M.icon_state = "alchrobe"
				M.item_state = "alchrobe"
				M.name = "Grand Alchemist's Robes"
				M.desc = "Well you sure LOOK the part with these on. (Base Item: [prev])"
				H.set_clothing_icon_dirty()
		return

/datum/achievementReward/dioclothes
	title = "(Skin) Dio's outfit"
	desc = "Requires that you wear something in your suit slot."
	required_medal = "Dracula Jr."

	rewardActivate(var/mob/activator)
		if (ishuman(activator))
			var/mob/living/carbon/human/H = activator
			if (H.wear_suit)
				var/obj/item/clothing/M = H.wear_suit
				var/prev = M.name
				M.icon = 'icons/obj/clothing/overcoats/item_suit.dmi'
				M.inhand_image_icon = 'icons/mob/inhand/inhand_cl_suit.dmi'
				M.inhand_image.icon = 'icons/mob/inhand/inhand_cl_suit.dmi'
				M.wear_image_icon = 'icons/mob/overcoats/worn_suit.dmi'
				M.wear_image.icon = 'icons/mob/overcoats/worn_suit.dmi'
				M.icon_state = "vclothes"
				M.item_state = "vclothes"
				M.name = "Dio's outfit"
				M.desc += " (Base Item: [prev])"
				H.set_clothing_icon_dirty()
		return

/datum/achievementReward/inspectorscloths
	title = "(Skin set) Inspector's clothes"
	desc = "Requires that you wear something in your suit and jumpsuit slots."
	required_medal = "Neither fashionable noir stylish"

	rewardActivate(var/mob/activator)
		if (ishuman(activator))
			var/mob/living/carbon/human/H = activator
			if (H.wear_suit)
				var/obj/item/clothing/M = H.wear_suit
				var/prev = M.name
				M.icon = 'icons/obj/clothing/overcoats/item_suit.dmi'
				M.inhand_image_icon = 'icons/mob/inhand/inhand_cl_suit.dmi'
				M.inhand_image.icon = 'icons/mob/inhand/inhand_cl_suit.dmi'
				M.wear_image_icon = 'icons/mob/overcoats/worn_suit.dmi'
				M.wear_image.icon = 'icons/mob/overcoats/worn_suit.dmi'
				M.icon_state = "inspectorc"
				M.item_state = "inspectorc"
				M.name = "Inspector's short coat"
				M.desc = "A coat for the modern detective. (Base Item: [prev])"
				H.set_clothing_icon_dirty()

			if (H.w_uniform)
				var/obj/item/clothing/M = H.w_uniform
				var/prev2 = M.name
				M.icon = 'icons/obj/clothing/uniforms/item_js_misc.dmi'
				M.inhand_image_icon = 'icons/mob/inhand/jumpsuit/hand_js_misc.dmi'
				M.inhand_image.icon = 'icons/mob/inhand/jumpsuit/hand_js_misc.dmi'
				M.wear_image_icon = 'icons/mob/jumpsuits/worn_js_misc.dmi'
				M.wear_image.icon = 'icons/mob/jumpsuits/worn_js_misc.dmi'
				M.icon_state = "inspectorj"
				M.item_state = "viceG"
				M.name = "Inspector's uniform"
				M.desc = "A uniform for the modern detective. (Base Item: [prev2])"
				H.set_clothing_icon_dirty()
		return

/datum/achievementReward/ntso_commander
	title = "(Skin set) NT-SO Commander Uniform"
	desc = "Requires that you're wearing a captain's hat and armor."
	required_medal = "Icarus"
	once_per_round = 0

	rewardActivate(var/mob/activator)
		if (ishuman(activator))
			var/mob/living/carbon/human/H = activator

			if (H.w_uniform)
				var/obj/item/clothing/M = H.w_uniform
				if (istype(M, /obj/item/clothing/under/rank/captain))
					var/prev = M.name
					M.icon_state = "captain-blue"
					M.item_state = "captain-blue"
					M.name = "administrator's uniform"
					M.desc = "A uniform specifically for NanoTrasen commanders. (Base Item: [prev])"
					H.set_clothing_icon_dirty()

			if (H.wear_suit)
				var/obj/item/clothing/M = H.wear_suit
				if (istype(M, /obj/item/clothing/suit/armor/captain))
					var/prev = M.name
					M.icon_state = "centcom"
					M.item_state = "centcom"
					M.name = "administrator's armor"
					M.desc = "A suit of protective formal armor. It is made specifically for NanoTrasen commanders. (Base Item: [prev])"
					H.set_clothing_icon_dirty()

				else if (istype(M, /obj/item/clothing/suit/space/captain))
					var/prev = M.name
					M.icon_state = "spacecap-blue"
					M.item_state = "spacecap-blue"
					M.name = "administrator's space suit"
					M.desc = "A suit that protects against low pressure environments. It is made specifically for NanoTrasen commanders. (Base Item: [prev])"
					H.set_clothing_icon_dirty()

			if (H.head)
				var/obj/item/clothing/M = H.head
				if (istype(M, /obj/item/clothing/head/caphat))
					var/prev = M.name
					M.icon_state = "centcom"
					M.item_state = "centcom"
					M.name = "Cent. Comm. hat"
					M.desc = "A fancy hat specifically for NanoTrasen commanders. (Base Item: [prev])"
					H.set_clothing_icon_dirty()
		return

/datum/achievementReward/ai_malf
	title = "(AI Skin) Malfuction"
	desc = "Turns you into a scary malfunctioning AI! Only in appearance, of course."
	required_medal = "HUMANOID MUST NOT ESCAPE"

	rewardActivate(var/mob/activator)
		if (isAI(activator))
			var/mob/living/silicon/ai/A = activator
			A.custom_emotions = ai_emotions | list("ROGUE(reward)" = "ai-red")
			A.faceEmotion = "ai-red"
			A.set_color("#EE0000")
			//A.icon_state = "ai-malf"
		else
			boutput(activator, "<span style=\"color:red\">You need to be an AI to use this, you goof!</span>")
		return

/datum/achievementReward/borg_automoton
	title = "(Cyborg Skin) Automaton"
	desc = "Turns you into the mysterious Automaton! Only in appearance, of course. Keys not included."
	required_medal = "Icarus"

	rewardActivate(var/mob/activator)
		if (isrobot(activator))
			var/mob/living/silicon/robot/C = activator
			C.automaton_skin = 1
			C.update_appearance()
		else
			boutput(activator, "<span style=\"color:red\">You need to be a cyborg to use this, you goof!</span>")
		return

/datum/achievementReward/smug
	title = "(Emote) Smug"
	desc = "Gives you the ability to be all smug about something. I bet nobody likes you."
	required_medal = ":10bux:"

	rewardActivate(var/mob/activator)
		if (!istype(activator))
			return
		activator.verbs += /proc/smugproc
		return

/proc/smugproc()
	set name = ":smug:"
	set desc = "Allows you to show others how great you feel about yourself for having paid 10 bucks."
	set category = "Achievements"

	animate_smug(usr)
	usr.verbs -= /proc/smugproc
	usr.verbs += /proc/smugprocCD
	spawn(300)
		boutput(usr, "<span style=\"color:blue\">You can now be smug again! Go hog wild.</span>")
		usr.verbs += /proc/smugproc
		usr.verbs -= /proc/smugprocCD
	return

/proc/smugprocCD()
	set name = ":smug:"
	set desc = "Currently on cooldown."
	set category = "Achievements"

	boutput(usr, "<span style=\"color:red\">You can't use that again just yet.</span>")
	return

/obj/effect/smug
	name = "smug"
	icon = 'icons/mob/64.dmi'
	icon_state = "smug"
	anchored = 1.0
	pixel_x = -16
	pixel_y = -16

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// Management stuff below.

//You could even make one-time reward by stripping their medal here.

/client/var/list/claimed_rewards = list() //Keeps track of once-per-round rewards

/mob/living/verb/claimreward()
	set background = 1
	set name = "Claim Reward"
	set desc = "Allows you to claim a Reward you might have earned."
	set category = "Achievements"
	set popup_menu = 0

	spawn(0)
		src.verbs -= /mob/living/verb/claimreward
		boutput(usr, "<span style=\"color:red\">Checking your eligibility. There might be a short delay, please wait.</span>")
		var/list/eligible = list()
		for(var/A in rewardDB)
			var/datum/achievementReward/D = rewardDB[A]
			var/result = usr.has_medal(D.required_medal)
			if(result == 1)
				if((D.once_per_round && !usr.client.claimed_rewards.Find(D.type)) || !D.once_per_round)
					eligible.Add(D.title)
					eligible[D.title] = D

		if(!length(eligible))
			boutput(usr, "<span style=\"color:red\">Sorry, you don't have any rewards available.</span>")
			src.verbs += /mob/living/verb/claimreward
			return

		var/selection = input(usr,"Please select your reward", "VIP Rewards","CANCEL") in (eligible + "CANCEL")

		if(selection == "CANCEL")
			src.verbs += /mob/living/verb/claimreward
			return

		var/datum/achievementReward/S = null

		for(var/X in rewardDB)
			var/datum/achievementReward/C = rewardDB[X]
			if(C.title == selection)
				S = C
				break

		if(S == null)
			boutput(usr, "<span style=\"color:red\">Invalid Rewardtype after selection. Please inform a coder.</span>")

		var/M = alert(usr,S.desc + "\n(Earned through the \"[S.required_medal]\" Medal)","Claim this Reward?","Yes","No")
		if(M == "Yes")
			S.rewardActivate(usr)
			if(S.once_per_round)
				usr.client.claimed_rewards.Add(S.type)
			src.verbs += /mob/living/verb/claimreward
		else
			src.verbs += /mob/living/verb/claimreward
