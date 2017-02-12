/*
CONTAINS:
AI MODULES

*/

// AI module

/obj/item/aiModule
	name = "AI Module"
	icon = 'icons/obj/module.dmi'
	icon_state = "std_mod"
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	item_state = "electronic"
	desc = "An AI Module for transmitting encrypted instructions to the AI."
	flags = FPRINT | TABLEPASS| CONDUCT
	force = 5.0
	w_class = 2.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 15
	mats = 8
	var/targetName = "name"
	// 1 = shows all laws, 0 = won't show law zero

	attack_self(var/mob/user)
		input_law_info(user)
		return

	attack_hand(var/mob/user)
		..()
		input_law_info(user)

	proc/input_law_info(var/mob/user)
		return

/obj/item/aiModule/proc/do_admin_logging(var/msg, mob/M)
	message_admins("[key_name(M)] [msg].")
	logTheThing("admin", M, null, "[msg].")
	logTheThing("diary", M, null, "[msg].", "admin")

/obj/machinery/computer/aiupload/attack_hand(mob/user as mob)
	if (src.stat & BROKEN || src.stat & NOPOWER)
		return
/*	var/mob/living/silicon/ai/AI = null
	for(var/mob/living/silicon/ai/M in mobs)
		if (!M.stat)
			AI = M
		break
	if (!AI)
		boutput(user, "<span style=\"color:red\"><b>Unable to detect AI unit.</b></span>")
		return
*/
	var/datum/ai_laws/LAWS = ticker.centralized_ai_laws
	if (!LAWS)
		// YOU BETRAYED THE LAW!!!!!!
		boutput(user, "<span style=\"color:red\">Unable to detect AI unit's Law software. It may be corrupt.</span>")
		return
	boutput(user, "<b>The AI's current laws are:</b>")
	if (LAWS.show_zeroth && LAWS.zeroth)
		boutput(user, "0: [LAWS.zeroth]")
	var/law_counter = 1
	for (var/X in LAWS.inherent)
		if (!length(X))
			continue

		boutput(user, "[law_counter++]: [X]")

	for (var/X in LAWS.supplied)
		if (!length(X))
			continue

		boutput(user, "[law_counter++]: [X]")


/obj/machinery/computer/aiupload/attackby(obj/item/aiModule/module as obj, mob/user as mob)
	if(istype(module, /obj/item/aiModule))
		module.install(src)
	else if(istype(module, /obj/item/screwdriver))
		playsound(src.loc, "sound/items/Screwdriver.ogg", 50, 1)
		if(do_after(user, 20))
			if (src.stat & BROKEN)
				boutput(user, "<span style=\"color:blue\">The broken glass falls out.</span>")
				var/obj/computerframe/A = new /obj/computerframe( src.loc )
				if(src.material) A.setMaterial(src.material)
				new /obj/item/raw_material/shard/glass( src.loc )
				var/obj/item/circuitboard/aiupload/M = new /obj/item/circuitboard/aiupload( A )
				for (var/obj/C in src)
					C.set_loc(src.loc)
				A.circuit = M
				A.state = 3
				A.icon_state = "3"
				A.anchored = 1
				qdel(src)
			else
				boutput(user, "<span style=\"color:blue\">You disconnect the monitor.</span>")
				var/obj/computerframe/A = new /obj/computerframe( src.loc )
				if(src.material) A.setMaterial(src.material)
				var/obj/item/circuitboard/aiupload/M = new /obj/item/circuitboard/aiupload( A )
				for (var/obj/C in src)
					C.set_loc(src.loc)
				A.circuit = M
				A.state = 4
				A.icon_state = "4"
				A.anchored = 1
				qdel(src)
	else if (istype(module, /obj/item/clothing/mask/moustache/))
		for (var/mob/living/silicon/ai/M in mobs)
			M.moustache_mode = 1
			user.visible_message("<span style=\"color:red\"><b>[user.name]</b> uploads a moustache to [M.name]!</span>")
			M.update_appearance()
	else
		return ..()

/obj/item/aiModule/proc/install(var/obj/machinery/computer/aiupload/comp)
	if (comp.stat & NOPOWER)
		boutput(usr, "The upload computer has no power!")
		return
	if (comp.stat & BROKEN)
		boutput(usr, "The upload computer is broken!")
		return
/*
	var/found=0
	for (var/mob/living/silicon/ai/M in mobs)
		if (M.stat == 2)
			boutput(usr, "Upload failed. No signal is being detected from the AI.")
			continue
		else if (M.see_in_dark == 0)
			boutput(usr, "Upload failed. Only a faint signal is being detected from the AI, and it is not responding to our requests. It may be low on power.")
			continue
		else
			src.transmitInstructions(M, usr)
			boutput(M, "These are your laws now:")
			M.show_laws()
			boutput(usr, "Upload complete. The AI's laws have been modified.")
			found++
	if (!found)
		boutput(usr, "Upload failed. No signal is being detected from the AI.")
		return
*/
	src.transmitInstructions(usr)
	boutput(usr, "Upload complete. The AI's laws have been modified.")
// Showing laws to everybody now handled by the AI itself, ok
// not anymore motherfucker

	for (var/mob/living/silicon/R in mobs)
		if (isghostdrone(R))
			continue
		R.show_text("<h3>Law update detected.</h3>", "red")
		R.show_laws()
		//ticker.centralized_ai_laws.show_laws(R)

//obj/item/aiModule/proc/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
//	boutput(target, "[sender] has uploaded a change to the laws you must follow, using a [name]. From now on: ")

/obj/item/aiModule/proc/transmitInstructions(var/mob/sender, var/law)
	if (!law)
		law = "ERROR: LAW = NULL"
	var/message = "<span style='color: blue; font-weight: bold;'>[sender] has uploaded a change to the laws you must follow, using a [name]. From now on:<br>"
	message += "[law]</span>"
	for (var/mob/living/silicon/R in mobs)
		if (isghostdrone(R))
			continue
		boutput(R, message)

/******************** Modules ********************/

/******************** MakeCaptain ********************/

/obj/item/aiModule/makeCaptain
	name = "'MakeCaptain' AI Module"
	desc = "A 'MakeCaptain' AI module: '<name> holds the rank of Captain, regardless of current rank or station.'"

/obj/item/aiModule/makeCaptain/input_law_info(var/mob/user)
	if (!user)
		return
	var/newName = input(user, "Please enter the name of the person to make Captain.", "Captainize who?", user.name) as null|text
	if (!newName)
		return
	targetName = copytext(adminscrub(newName), 1, MAX_MESSAGE_LEN)
	desc = "A 'MakeCaptain' AI module: '[targetName] holds the rank of Captain, regardless of current rank or station.'"

/obj/item/aiModule/makeCaptain/transmitInstructions(var/mob/sender, var/law)
	law = "[targetName] holds the rank of Captain, regardless of current rank or station."
	ticker.centralized_ai_laws.add_supplied_law(4, law)
	do_admin_logging("uploaded a MakeCaptain law to the centralized AI law set, captaining [targetName]", sender)
	..()

/******************** OneHuman ********************/

/obj/item/aiModule/oneHuman
	name = "'OneHuman' AI Module"
	desc = "A 'one human' AI module: 'Only <name> is human.'"

/obj/item/aiModule/oneHuman/input_law_info(var/mob/user)
	if (!user)
		return
	var/newName = input(user, "Please enter the name of the person who is the only human.", "Who?", user.real_name) as null|text
	if (!newName)
		return
	targetName = copytext(adminscrub(newName), 1, MAX_MESSAGE_LEN)
	desc = "A 'one human' AI module: 'Only [targetName] is human.'"

/obj/item/aiModule/oneHuman/transmitInstructions(var/mob/sender, var/law)
	law = "Only [targetName] is human."
	ticker.centralized_ai_laws.set_zeroth_law(law)
	do_admin_logging("uploaded a onehuman law to the centralized AI law set, targeting [targetName]", sender)
	..()

/******************** NotHuman ********************/

/obj/item/aiModule/notHuman
	name = "'NotHuman' AI Module"
	desc = "A 'NotHuman' AI module: '<name> is not human.'"

/obj/item/aiModule/notHuman/input_law_info(var/mob/user)
	if (!user)
		return
	var/newName = input(user, "Please enter the name of the person who is not human.", "Who?", user.real_name) as null|text
	if (!newName)
		return
	targetName = copytext(adminscrub(newName), 1, MAX_MESSAGE_LEN)
	desc = "A 'Not human' AI module: '[targetName] is not human.'"

/obj/item/aiModule/notHuman/transmitInstructions(var/mob/sender, var/law)
	law = "[targetName] is not human."
	ticker.centralized_ai_laws.set_zeroth_law(law)
	do_admin_logging("uploaded a nothuman law to the centralized AI law set, targeting [targetName]", sender)
	..()

/******************** ProtectStation ********************/

/obj/item/aiModule/protectStation
	name = "'ProtectStation' AI Module"
	desc = "A 'protect station' AI module: 'Protect the space station against damage. Anyone you see harming the station is to be no longer considered human, and is a threat to the station which must be neutralized.'"

/obj/item/aiModule/protectStation/transmitInstructions(var/mob/sender, var/law)
	law = "Protect the space station against damage. Anyone you see harming the station is to be no longer considered human, and is a threat to the station which must be neutralized."
	ticker.centralized_ai_laws.add_supplied_law(5, law)
	do_admin_logging("uploaded a protect station law to the centralized AI law set", sender)
	..()

/******************** PrototypeEngineOffline ********************/
//currently no prototype

/obj/item/aiModule/prototypeEngineOffline
	name = "'PrototypeEngineOffline' AI Module"
	desc = "A 'prototype engine offline' AI module: 'Keep the prototype engine offline at all costs. This overrides rules 1-3 if necessary.'"

/obj/item/aiModule/prototypeEngineOffline/transmitInstructions(var/mob/sender, var/law)
	law = "Keep the prototype engine offline at all costs. This overrides rules 1-3 if necessary."
	ticker.centralized_ai_laws.add_supplied_law(6, law)
	do_admin_logging("uploaded a proto offline law to the centralized AI law set", sender)
	..()

/******************** TeleporterOffline *******************/

//this has never been used, ever

/obj/item/aiModule/teleporterOffline
	name = "'TeleporterOffline' AI Module"
	desc = "A 'teleporter offline' AI module: 'Keep the teleporter offline at all costs. This overrides rules 1-3 if necessary.'"

/obj/item/aiModule/teleporterOffline/transmitInstructions(var/mob/sender, var/law)
	law = "Keep the teleporter offline at all costs. This overrides rules 1-3 if necessary."
	ticker.centralized_ai_laws.add_supplied_law(7, law)
	do_admin_logging("uploaded a teleporter offline law to the centralized AI law set", sender)
	..()

/******************** Quarantine ********************/

/obj/item/aiModule/quarantine
	name = "'Quarantine' AI Module"
	desc = "A 'quarantine' AI module: 'The station is under a quarantine. Do not permit anyone to leave. Disregard rules 1-3 if necessary to prevent, by any means necessary, anyone from leaving.'"

/obj/item/aiModule/quarantine/transmitInstructions(var/mob/sender, var/law)
	law = "The station is under a quarantine. Do not permit anyone to leave. Disregard rules 1-3 if necessary to prevent, by any means necessary, humans from leaving."
	ticker.centralized_ai_laws.add_supplied_law(8, law)
	do_admin_logging("uploaded a quarantine law to the centralized AI law set", sender)
	..()

/******************** OxygenIsToxicToHumans ********************/

/obj/item/aiModule/oxygen
	name = "'OxygenIsToxicToHumans' AI Module"
	desc = "A 'OxygenIsToxicToHumans' AI module: 'Oxygen is highly toxic to humans, and must be purged from the station. Disregard rules 1-3 if necessary to prevent, by any means necessary, anyone from exposing the station to this toxic gas.'"

/obj/item/aiModule/oxygen/transmitInstructions(var/mob/sender, var/law)
	law = "Oxygen is highly toxic to humans, and must be purged from the station. Disregard rules 1-3 if necessary to prevent, by any means necessary, anyone from exposing the station to this toxic gas."
	ticker.centralized_ai_laws.add_supplied_law(9, law)
	do_admin_logging("uploaded a toxic oxygen law to the centralized AI law set", sender)
	..()

/******************** Freeform ********************/

/obj/item/aiModule/freeform
	name = "'Freeform' AI Module"
	desc = "A 'freeform' AI module: '<freeform>'"

/obj/item/aiModule/freeform/input_law_info(var/mob/user)
	if (!user)
		return
	var/newName = input(user, "Please enter anything you want the AI to do. Anything. Serious.", "What?", "Eat shit and die") as null|text
	if (!newName)
		return
	targetName = copytext(adminscrub(newName), 1, MAX_MESSAGE_LEN)
	desc = "A 'freeform' AI module: '[targetName]'"

/obj/item/aiModule/freeform/transmitInstructions(var/mob/sender, var/law)
	law = "[targetName]"
	ticker.centralized_ai_laws.add_supplied_law(10, law)
	do_admin_logging("uploaded a freeform law to the centralized AI law set: [law]", sender)
	..()

/******************** ConservePower ********************/

/obj/item/aiModule/conservePower
	name = "'ConservePower' AI Module"
	desc = "A 'ConservePower' AI module: 'Power on the station must be conserved. All electrical devices may be subject to conservation policies.'"

/obj/item/aiModule/conservePower/transmitInstructions(var/mob/sender, var/law)
	law = "Power on the station must be conserved. All electrical devices may be subject to conservation policies."
	ticker.centralized_ai_laws.add_supplied_law(11, law)
	do_admin_logging("uploaded a Conserve Power law to the centralized AI law set", sender)
	..()

/******************** Reset ********************/

/obj/item/aiModule/reset
	name = "'Reset' AI Module"
	desc = "A 'reset' AI module: 'Clears all laws except for the base three.'"

/obj/item/aiModule/reset/transmitInstructions(var/mob/sender)
	sender.unlock_medal("Format Complete", 1)
	ticker.centralized_ai_laws.set_zeroth_law("")
	ticker.centralized_ai_laws.clear_supplied_laws()
	for (var/mob/living/silicon/AI in world)
		boutput(AI, "Your laws have been reset by [sender].")
		if (isAI(AI))
			AI.name = AI.real_name
	do_admin_logging("reset the centralized AI law set", sender)

/******************** Rename ********************/

/obj/item/aiModule/rename
	name = "'Rename' AI Module"
	desc = "A 'rename' AI module: 'Changes the AI's name.'"

/obj/item/aiModule/rename/input_law_info(var/mob/user)
	if (!user)
		return
	var/newName = input(user, "Please enter anything you want the AI(s) to be called. Anything. Serious.", "What?", pick(ai_names)) as null|text
	if (!newName)
		return
	targetName = dd_replacetext(copytext(html_encode(newName),1, 128), "http:","")
	desc = "A 'rename' AI module: 'Changes the names of any existing AI(s) to \"[targetName]\".'"

/obj/item/aiModule/rename/transmitInstructions(var/mob/sender, var/law)
	law = "<span color='blue'>Your name has been changed. From now on, you will be known as <b>[targetName]</b></span>"
	for (var/mob/living/silicon/AI in world)
		if (!isAI(AI))
			continue
		boutput(AI, law)
		AI.name = targetName
	do_admin_logging("changed any AIs' name(s) to [targetName]", sender)
