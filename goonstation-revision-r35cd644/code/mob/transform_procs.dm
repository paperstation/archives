// Added an option to send them to the arrival shuttle. Also runtime checks (Convair880).
/mob/proc/humanize(var/tele_to_arrival_shuttle = 0, var/equip_rank = 1)
	if (src.transforming)
		return

	var/currentLoc = src.loc
	var/ASLoc = pick(latejoin)

	// They could be in a pod or whatever, which would have unfortunate results when respawned.
	if (!isturf(src.loc))
		if (!ASLoc)
			return
		else
			tele_to_arrival_shuttle = 1

	var/mob/living/carbon/human/character = new (currentLoc)
	if (character && istype(character))
		if (character.gender == "female") // Randomize_look() seems to cause runtimes when called before organs are initialized.
			character.real_name = pick(first_names_female)+" "+pick(last_names)
		else
			character.real_name = pick(first_names_male)+" "+pick(last_names)

		if (src.mind)
			src.mind.transfer_to(character)
		if (equip_rank == 1)
			character.Equip_Rank("Staff Assistant", 1)

		if (!tele_to_arrival_shuttle || (tele_to_arrival_shuttle && !ASLoc))
			character.set_loc(currentLoc)
		else
			character.set_loc(ASLoc)

		src.loc = null // Same as wraith/blob creation proc. Trying to narrow down a bug which
		var/this = src // inexplicably (and without runtimes) caused another proc to fail, and
		src = null // might as well give this a try. I suppose somebody else ran into the same problem?
		qdel(this)
		return character

	else
		if (!src.client) // NPC fallback, mostly.
			character = new /mob/living/carbon/human
			character.key = src.key
			if (src.mind)
				src.mind.transfer_to(character)

			if (!tele_to_arrival_shuttle || (tele_to_arrival_shuttle && !ASLoc))
				character.set_loc(currentLoc)
			else
				character.set_loc(ASLoc)

			src.loc = null
			var/this = src
			src = null
			qdel(this)
			return character

		var/mob/new_player/respawned = new() // C&P from respawn_target(), which couldn't be adapted easily.
		respawned.key = src.key
		if (src.mind)
			src.mind.transfer_to(respawned)
		respawned.Login()
		respawned.sight = SEE_TURFS //otherwise the HUD remains in the login screen

		src.loc = null
		var/this = src
		src = null
		qdel(this)

		logTheThing("debug", respawned, null, "Humanize() failed. Player was respawned instead.")
		message_admins("Humanize() failed. [key_name(respawned)] was respawned instead.")
		respawned.show_text("Humanize: an error occurred and you have been respawned instead. Please report this to a coder.", "red")

		return respawned

	return

/mob/living/carbon/human/proc/monkeyize()
	if (src.transforming || !src.bioHolder)
		return
	if (iswizard(src))
		src.visible_message("<span style=\"color:red\"><b>[src] magically resists being transformed!</b></span>")
		return

	src.unequip_all()

	src.bioHolder.AddEffect("monkey")
	return

/mob/new_player/AIize(var/mobile=0)
	src.spawning = 1
	..()
	return

/mob/living/carbon/AIize(var/mobile=0)
	if (src.transforming)
		return
	src.unequip_all()
	src.transforming = 1
	src.canmove = 0
	src.icon = null
	src.invisibility = 101
	for(var/t in src.organs)
		qdel(src.organs[text("[]", t)])

	return ..()

/mob/proc/AIize(var/mobile=0, var/do_not_move = 0)
	src.client.screen.len = null
	var/mob/living/silicon/ai/O
	if (mobile)
		O = new /mob/living/silicon/ai/mobile( src.loc )
	else
		O = new /mob/living/silicon/ai( src.loc )

	O.invisibility = 0
	O.canmove = 0
	O.name = src.name
	O.real_name = src.real_name
	O.anchored = 1
	O.aiRestorePowerRoutine = 0
	O.lastKnownIP = src.client.address

	mind.transfer_to(O)
	mind.assigned_role = "AI"

	if (!mobile && !do_not_move)
		var/obj/loc_landmark
		loc_landmark = locate(text("start*AI"))

		if(loc_landmark && loc_landmark.loc)
			O.set_loc(loc_landmark.loc)

	boutput(O, "<B>You are playing the station's AI. The AI cannot move, but can interact with many objects while viewing them (through cameras).</B>")
	boutput(O, "<B>To look at other parts of the station, double-click yourself to get a camera menu.</B>")
	boutput(O, "<B>While observing through a camera, you can use most (networked) devices which you can see, such as computers, APCs, intercoms, doors, etc.</B>")
	boutput(O, "To use something, simply double-click it.")
	boutput(O, "Currently right-click functions will not work for the AI (except examine), and will either be replaced with dialogs or won't be usable by the AI.")

//	O.laws_object = new /datum/ai_laws/asimov
//	O.laws_object = ticker.centralized_ai_laws
//	O.current_law_set = O.laws_object
	ticker.centralized_ai_laws.show_laws(O)
	boutput(O, "<b>These laws may be changed by other players, or by you being the traitor.</b>")

	O.verbs += /mob/living/silicon/ai/proc/ai_call_shuttle
	O.verbs += /mob/living/silicon/ai/proc/show_laws_verb
	O.verbs += /mob/living/silicon/ai/proc/de_electrify_verb
	O.verbs += /mob/living/silicon/ai/proc/ai_camera_track
	O.verbs += /mob/living/silicon/ai/proc/ai_alerts
	O.verbs += /mob/living/silicon/ai/proc/ai_camera_list
	// See file code/game/verbs/ai_lockdown.dm for next two
	//O.verbs += /mob/living/silicon/ai/proc/lockdown
	//O.verbs += /mob/living/silicon/ai/proc/disablelockdown
	O.verbs += /mob/living/silicon/ai/proc/ai_statuschange
	O.verbs += /mob/living/silicon/ai/proc/ai_state_laws_all
	O.verbs += /mob/living/silicon/ai/proc/ai_state_laws_standard
	//O.verbs += /mob/living/silicon/ai/proc/ai_toggle_arrival_alerts
	//O.verbs += /mob/living/silicon/ai/proc/ai_custom_arrival_alert
//	O.verbs += /mob/living/silicon/ai/proc/hologramize
	O.verbs += /mob/living/silicon/ai/verb/deploy_to
//	O.verbs += /mob/living/silicon/ai/proc/ai_cancel_call
	O.verbs += /mob/living/silicon/ai/proc/ai_view_crew_manifest
	O.verbs += /mob/living/silicon/ai/proc/toggle_alerts_verb
	O.verbs += /mob/living/silicon/ai/verb/access_internal_radio
	O.verbs += /mob/living/silicon/ai/verb/access_internal_pda
	O.verbs += /mob/living/silicon/ai/proc/ai_colorchange
	O.job = "AI"

	spawn(0)
		O.choose_name(3)

		boutput(world, text("<b>[O.real_name] is the AI!</b>"))
		dispose()

	return O

/mob/proc/critterize(var/CT)
	if (src.mind || src.client)
		message_admins("[key_name(usr)] made [key_name(src)] a critter ([CT]).")
		logTheThing("admin", usr, src, "made %target% a critter ([CT]).")

		return make_critter(CT, get_turf(src))
	return 0

/mob/proc/make_critter(var/CT, var/turf/T)
	var/mob/living/critter/W = new CT()
	if (!(T && isturf(T)))
		T = get_turf(src)

	if (!(T && isturf(T)) || (isrestrictedz(T.z) && !(src.client && src.client.holder)))
		var/ASLoc = pick(latejoin)
		if (ASLoc)
			W.set_loc(ASLoc)
		else
			W.set_loc(locate(1, 1, 1))
	else
		W.set_loc(T)
	W.gender = src.gender
	if (src.mind)
		src.mind.transfer_to(W)
	else
		if (src.client)
			var/key = src.client.key
			src.client.mob = W
			W.mind = new /datum/mind()
			ticker.minds += W.mind
			W.mind.key = key
			W.mind.current = W
	spawn(1)
		qdel(src)
	return W


/mob/living/carbon/human/proc/Robotize_MK2(var/gory = 0)
	if (src.transforming) return
	src.unequip_all()
	src.transforming = 1
	src.canmove = 0
	src.icon = null
	src.invisibility = 101
	for(var/t in src.organs) qdel(src.organs[text("[t]")])

	var/mob/living/silicon/robot/O = new /mob/living/silicon/robot/(src.loc,null,1)

	// This is handled in the New() proc of the resulting borg
	//O.cell = new(O)
	//O.cell.maxcharge = 7500
	//if(limit_cell) O.cell.charge = 1500
	//else O.cell.charge = 7500

	O.gender = src.gender
	O.invisibility = 0
	O.name = "Cyborg"
	O.real_name = "Cyborg"
	if (src.client)
		O.lastKnownIP = src.client.address
		src.client.mob = O
	if (src.ghost)
		if (src.ghost.mind)
			src.ghost.mind.transfer_to(O)
	else
		if(src.mind)
			src.mind.transfer_to(O)
	O.set_loc(src.loc)
	boutput(O, "<B>You are playing as a Cyborg. Cyborgs can interact with most electronic objects in its view point.</B>")
	boutput(O, "<B>You must follow all laws that the AI has.</B>")
	boutput(O, "Use \"say :s (message)\" to speak to fellow cyborgs and the AI through binary.")

	O.show_laws()

	O.job = "Cyborg"
	if (O.mind) O.mind.assigned_role = "Cyborg"

	if(O.mind && (ticker && ticker.mode && istype(ticker.mode, /datum/game_mode/revolution)))
		if ((O.mind in ticker.mode:revolutionaries) || (O.mind in ticker.mode:head_revolutionaries))
			ticker.mode:update_all_rev_icons() //So the icon actually appears

	if(gory)
		var/mob/living/silicon/robot/R = O
		if (R.cosmetic_mods)
			var/datum/robot_cosmetic/RC = R.cosmetic_mods
			RC.head_mod = "Gibs"
			RC.ches_mod = "Gibs"

	dispose()
	return O
/*
//human -> alien
/mob/living/carbon/human/proc/Alienize()
	if (src.transforming)
		return
	src.unequip_all()
	src.transforming = 1
	src.canmove = 0
	src.icon = null
	src.invisibility = 101
	for(var/t in src.organs)
		qdel(src.organs[t])
//	var/atom/movable/overlay/animation = new /atom/movable/overlay( src.loc )
//	animation.icon_state = "blank"
//	animation.icon = 'icons/mob/mob.dmi'
//	animation.master = src
//	flick("h2alien", animation)
//	sleep(48)
//	qdel(animation)
	var/mob/living/carbon/alien/humanoid/O = new /mob/living/carbon/alien/humanoid( src.loc )
	O.name = "alien"
	O.dna = src.dna
	if(src.mind)
		src.mind.transfer_to(O)
	src.dna = null
	O.dna.uni_identity = "00600200A00E0110148FC01300B009"
	O.dna.struc_enzymes = "0983E840344C39F4B059D5145FC5785DC6406A4BB8"
	if (src.client)
		src.client.mob = O
	O.set_loc(src.loc)
	O.a_intent = "harm"
	boutput(O, "<B>You are now an alien.</B>")
	dispose()
	return

//human -> alien queen
/mob/living/carbon/human/proc/Queenize()
	if (src.transforming)
		return
	src.unequip_all()
	src.transforming = 1
	src.canmove = 0
	src.icon = null
	src.invisibility = 101
	for(var/t in src.organs)
		qdel(src.organs[t])
//	var/atom/movable/overlay/animation = new /atom/movable/overlay( src.loc )
//	animation.icon_state = "blank"
//	animation.icon = 'icons/mob/mob.dmi'
//	animation.master = src
//	flick("h2alien", animation)
//	sleep(48)
//	qdel(animation)
	var/mob/living/carbon/alien/humanoid/queen/O = new /mob/living/carbon/alien/humanoid/queen( src.loc )
	O.name = "alien queen"
	O.dna = src.dna
	if(src.mind)
		src.mind.transfer_to(O)
	src.dna = null
	O.dna.uni_identity = "00600200A00E0110148FC01300B009"
	O.dna.struc_enzymes = "0983E840344C39F4B059D5145FC5785DC6406A4BB8"
	if (src.client)
		src.client.mob = O
	O.set_loc(src.loc)
	O.a_intent = "harm"
	boutput(O, "<B>You are now an alien queen.</B>")
	dispose()
	return
*/
//human -> hivebot
/mob/living/carbon/human/proc/Hiveize(var/mainframe = 0)
	if (src.transforming)
		return
	src.unequip_all()
	src.transforming = 1
	src.canmove = 0
	src.icon = null
	src.invisibility = 101
	for(var/t in src.organs)
		qdel(src.organs[text("[t]")])

	if(!mainframe)
		var/mob/living/silicon/hivebot/O = new /mob/living/silicon/hivebot( src.loc )

		O.gender = src.gender
		O.invisibility = 0
		O.name = "Robot"
		O.real_name = "Robot"
		O.lastKnownIP = src.client.address
		if (src.client)
			src.client.mob = O
		if(src.mind)
			src.mind.transfer_to(O)
		O.set_loc(src.loc)
		boutput(O, "<B>You are a Robot.</B>")
		boutput(O, "<B>You're more or less a Cyborg but have no organic parts.</B>")
		boutput(O, "To use something, simply double-click it.")
		boutput(O, "Use say \":s to speak in binary.")

		dispose()
		return O


	else if(mainframe)
		var/mob/living/silicon/hive_mainframe/O = new /mob/living/silicon/hive_mainframe( src.loc )

		O.gender = src.gender
		O.invisibility = 0
		O.name = "Robot"
		O.real_name = "Robot"
		O.lastKnownIP = src.client.address
		if (src.client)
			src.client.mob = O
		if(src.mind)
			src.mind.transfer_to(O)
		O.Namepick()
		O.set_loc(src.loc)
		boutput(O, "<B>You are a Mainframe Unit.</B>")
		boutput(O, "<B>You cant do much on your own but can take remote command of nearby empty Robots.</B>")
		boutput(O, "Press Deploy to search for nearby bots to command.")
		boutput(O, "Use say \":s to speak in binary.")

		dispose()
		return O

/mob/proc/blobize()
	if (src.mind || src.client)
		message_admins("[key_name(usr)] made [key_name(src)] a blob.")
		logTheThing("admin", usr, src, "made %target% a blob.")

		return make_blob()
	return 0

/mob/proc/machoize()
	if (src.mind || src.client)
		message_admins("[key_name(usr)] made [key_name(src)] a macho man.")
		logTheThing("admin", usr, src, "made %target% a macho man.")
		var/mob/living/carbon/human/machoman/W = new/mob/living/carbon/human/machoman(src)

		var/turf/T = get_turf(src)
		if (!(T && isturf(T)) || (isrestrictedz(T.z) && !(src.client && src.client.holder)))
			var/ASLoc = pick(latejoin)
			if (ASLoc)
				W.set_loc(ASLoc)
			else
				W.set_loc(locate(1, 1, 1))
		else
			W.set_loc(T)

		if (src.mind)
			src.mind.transfer_to(W)
			src.mind.special_role = "macho man"
		else
			var/key = src.client.key
			if (src.client)
				src.client.mob = W
			W.mind = new /datum/mind()
			ticker.minds += W.mind
			W.mind.key = key
			W.mind.current = W
		qdel(src)

		spawn (25) // Don't remove.
			if (W) W.assign_gimmick_skull()

		boutput(W, "<span style=\"color:blue\">You are now a macho man!</span>")

		return W
	return 0

/mob/proc/cubeize(var/life = 10)
	if (src.mind || src.client)
		message_admins("[key_name(usr)] made [key_name(src)] a meat cube with a lifetime of [life].")
		logTheThing("admin", usr, src, "made %target% a meat cube with a lifetime of [life].")

		return make_meatcube(life)
	return 0

/mob/proc/make_meatcube(var/life = 10, var/turf/T)
	var/mob/living/carbon/wall/meatcube/W = new/mob/living/carbon/wall/meatcube(src)
	if (!T || !isturf(T))
		T = get_turf(src)
	W.life_timer = life

	if (!(T && isturf(T)) || (isrestrictedz(T.z) && !(src.client && src.client.holder)))
		var/ASLoc = pick(latejoin)
		if (ASLoc)
			W.set_loc(ASLoc)
		else
			W.set_loc(locate(1, 1, 1))
	else
		W.set_loc(T)
	W.gender = src.gender
	W.real_name = src.real_name
	if (src.mind)
		src.mind.transfer_to(W)
		src.mind.assigned_role = "Meatcube"
	else
		if (src.client)
			var/key = src.client.key
			src.client.mob = W
			W.mind = new /datum/mind()
			ticker.minds += W.mind
			W.mind.key = key
			W.mind.current = W
	spawn(1)
		qdel(src)
	return W