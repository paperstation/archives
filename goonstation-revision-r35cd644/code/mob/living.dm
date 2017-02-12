// living

/mob/living
	var/t_plasma = null
	var/t_oxygen = null
	var/t_sl_gas = null
	var/t_n2 = null

	var/cameraFollow = null
	var/spell_soulguard = 0

	// this is a read only variable. do not set it directly.
	// use set_burning or update_burning instead.
	// the value means how on fire is the mob, from 0 to 100
	var/burning = 0
	var/misstep_chance = 0

	var/datum/hud/vision/vision

	//AI Vars

	var/ai_busy = 0
	var/ai_laststep = 0
	var/ai_state = 0
	var/ai_threatened = 0
	var/ai_movedelay = 6
	var/ai_lastaction = 0
	var/ai_actiondelay = 10
	var/ai_pounced = 0
	var/ai_attacked = 0
	var/ai_frustration = 0
	var/ai_throw = 0
	var/ai_attackadmins = 1
	var/ai_attacknpc = 1
	var/ai_suicidal = 0 //Will it attack itself?
	var/ai_active = 0

	var/blood_id = null

	var/mob/living/ai_target = null
	var/list/mob/living/ai_target_old = list()
	var/is_npc = 0

	var/obj/move_laying = null
	var/list/mob/dead/target_observer/observers = list()
	var/static/image/speech_bubble = image('icons/mob/mob.dmi', "speech")
	var/image/static_image = null
	var/in_point_mode = 0
	var/butt_op_stage = 0.0 // sigh

	var/sound_burp = 'sound/misc/burp.ogg'
	var/sound_scream = 'sound/voice/robot_scream.ogg' // for silicon mobs
	var/sound_malescream = 'sound/voice/male_scream.ogg'
	var/sound_femalescream = 'sound/voice/female_scream.ogg'
	var/sound_flip1 = 'sound/machines/whistlealert.ogg' // for silicon mobs
	var/sound_flip2 = 'sound/machines/whistlebeep.ogg' // for silicon mobs
	var/sound_fart = 'sound/misc/poo2.ogg'
	var/sound_snap = 'sound/effects/snap.ogg'
	var/sound_fingersnap = 'sound/effects/fingersnap.ogg'

#ifdef MAP_OVERRIDE_DESTINY
	var/hibernating = 0 // if they're stored in the cryotron, Life() gets skipped
#endif

/mob/living/New()
	vision = new()
	src.attach_hud(vision)
	..()
	spawn(0)
		src.get_static_image()

/mob/living/flash(duration)
	vision.flash(duration)

/mob/living/Stat()
	..()

/mob/living/disposing()
	ai_target = null
	ai_target_old.len = 0
	move_laying = null
	observers.len = 0
	if (src.static_image)
		mob_static_icons.Remove(src.static_image)
		src.static_image = null
	..()

/mob/living/death(gibbed)
	if (src.key) statlog_death(src,gibbed)
	if (src.client && (ticker.round_elapsed_ticks >= 12000))
		var/num_players = 0
		for(var/mob/players in mobs)
			if (players.client && players.stat != 2) num_players++

		if (num_players <= 5)
			if (!emergency_shuttle.online && ticker && ticker.current_state != GAME_STATE_FINISHED && ticker.mode.crew_shortage_enabled)
				emergency_shuttle.incall()
				boutput(world, "<span style=\"color:blue\"><B>Alert: Due to crew shortages and fatalities, the emergency shuttle has been called. It will arrive in [round(emergency_shuttle.timeleft()/60)] minutes.</B></span>")

	if (deathConfettiActive) //Active if XMAS or manually toggled
		src.deathConfetti()

	return ..(gibbed)

/mob/living/Life(datum/controller/process/mobs/parent)
#ifdef MAP_OVERRIDE_DESTINY
	if (hibernating)
		if (istype(src.loc, /obj/cryotron))
			if (!stat)
				stat = 1
			return 1
		else
			hibernating = 0
#endif
	if (..(parent))
		return 1
	return

/mob/living/update_camera()
	for (var/mob/dead/target_observer/observer in observers)
		if (observer.client)
			src.apply_camera(observer.client)
	..()

/mob/living/attach_hud(datum/hud/hud)
	for (var/mob/dead/target_observer/observer in observers)
		observer.attach_hud(hud)
	return ..()

/mob/living/detach_hud(datum/hud/hud)
	for (var/mob/dead/target_observer/observer in observers)
		observer.detach_hud(hud)
	return ..()

/mob/living/projCanHit(datum/projectile/P)
	if (!src.lying || (src:lying && prob(P.hit_ground_chance))) return 1
	return 0

/mob/living/proc/hand_attack(atom/target, params)
	target.attack_hand(src)

/mob/living/proc/hand_range_attack(atom/target, params)
	return

/mob/living/proc/weapon_attack(atom/target, obj/item/W, reach, params)
	var/usingInner = 0
	if (W.useInnerItem && W.contents.len > 0)
		W = pick(W.contents)
		usingInner = 1

	if (reach)
		target.attackby(W, src, params)
	if (W && (equipped() == W || usingInner))
		var/pixelable = isturf(target)
		if (!pixelable)
			if (istype(target, /atom/movable) && isturf(target:loc))
				pixelable = 1
		if (pixelable)
			if (!W.pixelaction(target, params, src, reach))
				if (W)
					W.afterattack(target, src, reach, params)
		else if (!pixelable && W)
			W.afterattack(target, src, reach, params)

/mob/living/click(atom/target, params)
	. = ..()
	if (. == 100)
		return 100

#ifdef MAP_OVERRIDE_DESTINY
	if (src.hibernating && istype(src.loc, /obj/cryotron))
		var/obj/cryotron/cryo = src.loc
		if (cryo.exit_prompt(src))
			return
#endif

	if (params["alt"])
		target.examine() // in theory, usr should be us, this is shit though
		return

	if (params["middle"])
		src.swap_hand()
		return

	if (src.in_point_mode)
		src.point(target)
		src.toggle_point_mode()
		return

	if (!src.stat && !src.restrained() && !src.weakened && !src.paralysis && !src.stunned)
		if (target != src && ishuman(src))
			var/mob/living/carbon/human/S = src
			if (S.sims)
				var/mult = S.sims.getMoodActionMultiplier()
				if (mult < 0.5)
					if (prob((0.5 - mult) * 200))
						boutput(src, pick("<span style=\"color:red\">You're not in the mood to attack that.</span>", "<span style=\"color:red\">You don't feel like doing that.</span>"))
						return
		var/obj/item/item = target
		if (istype(item) && item == src.equipped())
			if (!disable_next_click && world.time < src.next_click)
				return
			item.attack_self(src)
			return

		if (params["ctrl"])
			var/atom/movable/movable = target
			if (istype(movable))
				movable.pull()
			return

		var/obj/item/W = src.equipped()
		if ((!disable_next_click || ismob(target) || (target && target.flags & USEDELAY) || (W && W.flags & USEDELAY)) && world.time < src.next_click)
			return src.next_click - world.time

		var/reach = can_reach(src, target)
		if (reach || (W && (W.flags & EXTRADELAY))) //Fuck you, magic number prickjerk
			if (!disable_next_click || ismob(target) || (target && target.flags & USEDELAY) || (W && W.flags & USEDELAY))
				src.next_click = world.time + 10
			if (src.invisibility > 0 && get_dist(src, target) > 0) // dont want to check for a cloaker every click if we're not invisible
				for (var/obj/item/cloaking_device/I in src)
					if (I.active)
						I.deactivate(src)
						src.visible_message("<span style=\"color:blue\"><b>[src]'s cloak is disrupted!</b></span>")
			if (W && istype(W))
				weapon_attack(target, W, reach, params)
			else if (!W)
				hand_attack(target, params)
		else if (!reach && W)
			if (!disable_next_click || ismob(target))
				src.next_click = world.time + 10
			var/pixelable = isturf(target)
			if (!pixelable)
				if (istype(target, /atom/movable) && isturf(target:loc))
					pixelable = 1
			if (pixelable)
				W.pixelaction(target, params, src, 0)
		else if (!W)
			// oh god
			// okay, this is only ACTUALLY used for power gloves, I'm disabling the rest for now because heavy hasvar usage is causing lag
			/*if(hasvar(src, "back") && src:back) src:back:equipment_click(target, src)
			if(hasvar(src, "belt") && src:belt) src:belt:equipment_click(target, src)
			if(src.ears) src.ears.equipment_click(target, src)
			if(hasvar(src, "glasses") && src:glasses) src:glasses:equipment_click(target, src)*/
			if(hasvar(src, "gloves") && src:gloves) src:gloves:equipment_click(target, src)
			/*if(hasvar(src, "head") && src:head) src:head:equipment_click(target, src)
			if(src.l_hand) src.l_hand.equipment_click(target, src)
			if(hasvar(src, "l_store") && src:l_store) src:l_store:equipment_click(target, src)
			if(src.r_hand) src.r_hand.equipment_click(target, src)
			if(hasvar(src, "r_store") && src:r_store) src:r_store:equipment_click(target, src)
			if(hasvar(src, "shoes") && src:shoes) src:shoes:equipment_click(target, src)
			if(hasvar(src, "wear_id") && src:wear_id) src:wear_id:equipment_click(target, src)
			if(src.wear_mask) src.wear_mask.equipment_click(target, src)
			if(hasvar(src, "wear_suit") && src:wear_suit) src:wear_suit:equipment_click(target, src)
			if(hasvar(src, "w_uniform") && src:w_uniform) src:w_uniform:equipment_click(target, src)*/
			hand_range_attack(target, params)

/mob/living/update_cursor()
	..()
	if (src.client)
		if (src.in_point_mode)
			src.set_cursor('icons/cursors/point.dmi')
			return

		if (src.client.check_key("alt"))
			src.set_cursor('icons/cursors/examine.dmi')
			return

		if (src.client.check_key("ctrl"))
			src.set_cursor('icons/cursors/pull.dmi')
			return

	//src.set_cursor(null)

/mob/living/key_down(key)
	if (key == "alt" || key == "ctrl" || key == "shift")
		update_cursor()

/mob/living/key_up(key)
	if (key == "alt" || key == "ctrl" || key == "shift")
		update_cursor()

/mob/living/proc/toggle_point_mode(var/force_off = 0)
	if (force_off)
		src.in_point_mode = 0
		src.update_cursor()
		return
	src.in_point_mode = !(src.in_point_mode)
	src.update_cursor()

/mob/living/verb/point(var/atom/target as mob|obj|turf in oview())
	set name = "Point"
	if (!isturf(src.loc) || usr.stat || usr.restrained())
		return

	if (src.reagents && src.reagents.has_reagent("capulettium_plus"))
		src.show_text("You are completely paralysed and can't point!", "red")
		return

	if (istype(target, /obj/decal/point))
		return

	var/obj/item/gun/G = src.equipped()
	if(!istype(G) || !ismob(target))
		src.visible_message("<b>[src]</b> points to [target].")
	else
		src.visible_message("<span style='font-weight:bold;color:#f00;font-size:120%;'>[src] points \the [G] at [target]!</span>")

	var/obj/decal/point/P = new(get_turf(target))
	src = null // required to make sure its deleted
	spawn (20)
		P.invisibility = 101
		qdel(P)

// set burning to a value
/mob/living/proc/set_burning(var/new_value)
	if (new_value == burning)
		return

	update_burning(new_value - burning)

// change burning, for example update_burning(-10) in a fire fighting item
// doesn't matter if you tell it to go past 0-100. the proc will deal with it.
/mob/living/proc/update_burning(var/change)
	if (change == 0)
		return

	// cache the original value
	var/old_burning = src.burning

	// mob/living update_burning sets the burning var and clamps the value
	if (change == 0)
		return

	burning += change
	if (burning < 0) burning = 0
	if (burning > 100) burning = 100

	// set the upper and lower bounds of the change based on the direction
	var/lbound
	var/ubound
	if (change > 0)
		lbound = old_burning
		ubound = burning
	else if (change < 0)
		ubound = old_burning
		lbound = burning

	// figure out if we crossed an icon threshold
	if (lbound == 0 || (lbound < 33 && ubound >= 33) || (lbound < 66 && ubound >= 66))
		update_burning_icon(old_burning)

/mob/living/proc/update_burning_icon(var/old_burning)
	return

/mob/living/proc/get_equipped_ore_scoop()
	return null

/mob/living/proc/talk_into_equipment(var/mode, var/messages, var/param, var/lang_id)
	switch (mode)
		if ("headset")
			if (src.ears)
				src.ears.talk_into(src, messages, param, src.real_name, lang_id)

		if ("secure headset")
			if (src.ears)
				src.ears.talk_into(src, messages, param, src.real_name, lang_id)

		if ("right hand")
			if (src.r_hand)
				src.r_hand.talk_into(src, messages, param, src.real_name, lang_id)
			else
				spawn(0)
					src.emote("handpuppet")

		if ("left hand")
			if (src.l_hand)
				src.l_hand.talk_into(src, messages, param, src.real_name, lang_id)
			else
				spawn (0)
					src.emote("handpuppet")

/mob/living/say(var/message)
	message = trim(copytext(sanitize_noencode(message), 1, MAX_MESSAGE_LEN))

	if (!message)
		return

	if (reverse_mode) message = reverse_text(message)

	logTheThing("diary", src, null, ": [message]", "say")

#ifdef DATALOGGER
	// Jewel's attempted fix for: null.ScanText()
	if (game_stats)
		game_stats.ScanText(message)
#endif

	if (src.client && src.client.ismuted())
		boutput(src, "You are currently muted and may not speak.")
		return

	if(src.reagents && src.reagents.has_reagent("capulettium_plus"))
		boutput(src, "<span style=\"color:red\">You are completely paralysed and can't speak!</span>")
		return

	if (src.stat == 2)
		if (dd_hasprefix(message, "*")) // no dead emote spam
			return
		return src.say_dead(message)

	// wtf?
	if (src.stat)
		return

	// emotes
	if (dd_hasprefix(message, "*") && !src.stat)
		return src.emote(copytext(message, 2),1)

	// Mute disability
	if (src.bioHolder.HasEffect("mute"))
		boutput(src, "<span style=\"color:red\">You seem to be unable to speak.</span>")
		return

	if (istype(src.wear_mask, /obj/item/clothing/mask/muzzle))
		boutput(src, "<span style=\"color:red\">Your muzzle prevents you from speaking.</span>")
		return

	// Insert space check here
//	var/turf/T = get_turf(src)
	// If human
	if (ishuman(src))
		var/mob/living/carbon/human/H = src
		// If theres no oxygen
		if (H.oxyloss > 10 || H.losebreath >= 4) // Perfluorodecalin cap - normal life() depletion - buffer.
			H.emote("gasp")
			return

	if (istype(loc, /obj/machinery/colosseum_putt))
		var/obj/machinery/colosseum_putt/C = loc
		logTheThing("say", src, null, "<i>broadcasted between Colosseum Putts:</i> \"[message]\"")
		C.broadcast(message)
		return

	var/italics = 0
	var/forced_language = null
	var/message_range = null
	var/message_mode = null
	var/secure_headset_mode = null
	var/skip_open_mics_in_range = 0 // For any radios or intercoms that happen to be in range.

	if (src.get_brain_damage() >= 60 && prob(50))
		if (ishuman(src))
			message_mode = "headset"
	// Special message handling
	else if (copytext(message, 1, 2) == ";")
		message_mode = "headset"
		message = copytext(message, 2)

	else if ((length(message) >= 2) && (copytext(message,1,2) == ":"))
		switch (lowertext( copytext(message,2,4) ))
			if ("rh")
				message_mode = "right hand"
				message = copytext(message, 4)

			if ("lh")
				message_mode = "left hand"
				message = copytext(message, 4)

		/*else if (copytext(message, 1, 3) == ":w")
			message_mode = "whisper"
			message = copytext(message, 3)*/

			if ("in")
				message_mode = "intercom"
				message = copytext(message, 4)

			else
				// AI radios. See further down in this proc (Convair880).
				if (issilicon(src))
					switch (lowertext(copytext(message, 2, 3))) // One vs. two letter prefix.
						if ("1")
							message_mode = "internal 1"
							message = copytext(message, 3)

						if ("2")
							message_mode = "internal 2"
							message = copytext(message, 3)

						if ("3")
							message_mode = "internal 3"
							message = copytext(message, 3)

						else
							message = copytext(message, 3)

				else
					if (ishuman(src) || istype(src, /mob/living/critter)) // this is shit
						message_mode = "secure headset"
						secure_headset_mode = lowertext(copytext(message,2,3))
					message = copytext(message, 3)

	forced_language = get_special_language(secure_headset_mode)

	message = trim(message)

	if (!message)
		return

	if (src.stuttering)
		message = stutter(message)

	// :downs:
	if (src.get_brain_damage() >= 60)
		message = dd_replacetext(message, " am ", " ")
		message = dd_replacetext(message, " is ", " ")
		message = dd_replacetext(message, " are ", " ")
		message = dd_replacetext(message, "you", "u")
		message = dd_replacetext(message, "help", "halp")
		message = dd_replacetext(message, "grief", "grife")
		message = dd_replacetext(message, "she ", "him ")
		message = dd_replacetext(message, "he ", "him ")

		if(prob(50))
			message = uppertext(message)
			message = "[message][stutter(pick("!", "!!", "!!!"))]"
		if(!src.stuttering && prob(15))
			message = stutter(message)

	UpdateOverlays(speech_bubble, "speech_bubble")
	spawn(15)
		UpdateOverlays(null, "speech_bubble")

	//Blobchat handling
	if (istype(src, /mob/living/intangible/blob_overmind))
		message = html_encode(src.say_quote(message))
		var/rendered = "<span class='game blobsay'>"
		rendered += "<span class='prefix'>BLOB:</span> "
		rendered += "<span class='name text-normal' data-ctx='\ref[src.mind]'>[src.get_heard_name()]</span> "
		rendered += "<span class='message'>[message]</span>"
		rendered += "</span>"

		for (var/mob/M in mobs)
			if (istype(M, /mob/new_player))
				continue

			if (M.client && (istype(M, /mob/living/intangible/blob_overmind) || M.client.holder))
				var/thisR = rendered
				if (M.client.holder && src.mind)
					thisR = "<span class='adminHearing' data-ctx='[M.client.chatOutput.ctxFlag]'>[rendered]</span>"
				M.show_message(thisR, 2)

		return

	var/list/messages = process_language(message, forced_language)
	var/lang_id = get_language_id(forced_language)
	switch (message_mode)
		if ("headset", "secure headset", "right hand", "left hand")
			talk_into_equipment(message_mode, messages, secure_headset_mode, lang_id)
			message_range = 1
			italics = 1

		//Might put this back if people are used to the old system.
		/*if ("whisper")
			message_range = 1
			italics = 1*/

		// Added shortcuts for the AI mainframe radios. All the relevant vars are already defined here, and
		// I didn't want to have to reinvent the wheel in silicon.dm (Convair880).
		if ("internal 1", "internal 2", "internal 3")
			var/mob/living/silicon/ai/A
			var/obj/item/device/radio/R1
			var/obj/item/device/radio/R2
			var/obj/item/device/radio/R3

			if (isAI(src))
				A = src
			else if (issilicon(src))
				var/mob/living/silicon/S = src
				if (S.dependent && S.mainframe && isAI(S.mainframe)) // AI-controlled robot.
					A = S.mainframe

			if (A && isAI(A))
				if (A.radio1 && istype(A.radio1, /obj/item/device/radio/))
					R1 = A.radio1
				if (A.radio2 && istype(A.radio2, /obj/item/device/radio/))
					R2 = A.radio2
				if (A.radio3 && istype(A.radio3, /obj/item/device/radio/))
					R3 = A.radio3

			switch (message_mode)
				if ("internal 1")
					if (R1 && !(A.stat || A.stunned || A.weakened)) // Mainframe may be stunned when the shell isn't.
						R1.talk_into(src, messages, null, A.name, lang_id)
						italics = 1
						skip_open_mics_in_range = 1 // First AI intercom broadcasts everything by default.
						//DEBUG("AI radio #1 triggered. Message: [message]")
					else
						src.show_text("Mainframe radio inoperable or unavailable.", "red")
				if ("internal 2")
					if (R2 && !(A.stat || A.stunned || A.weakened))
						R2.talk_into(src, messages, null, A.name, lang_id)
						italics = 1
						skip_open_mics_in_range = 1
						//DEBUG("AI radio #2 triggered. Message: [message]")
					else
						src.show_text("Mainframe radio inoperable or unavailable.", "red")
				if ("internal 3")
					if (R3 && !(A.stat || A.stunned || A.weakened))
						R3.talk_into(src, messages, null, A.name, lang_id)
						italics = 1
						skip_open_mics_in_range = 1
						//DEBUG("AI radio #3 triggered. Message: [message]")
					else
						src.show_text("Mainframe radio inoperable or unavailable.", "red")

		if ("intercom")
			for (var/obj/item/device/radio/intercom/I in view(1, null))
				I.talk_into(src, messages, null, src.real_name, lang_id)
			for (var/obj/colosseum_radio/M in hearers(1, src))
				M.hear_talk(src, messages, real_name, lang_id)

			message_range = 1
			italics = 1

	var/heardname = src.real_name
	for (var/obj/O in all_view(message_range, src))
		spawn (0)
			if (!skip_open_mics_in_range && O)
				O.hear_talk(src, messages, heardname, lang_id)

	var/list/listening = list()
	var/list/olocs = list()
	var/thickness = 0
	if (isturf(loc))
		listening = all_hearers(message_range, src)
	else
		olocs = obj_loc_chain(src)
		for (var/atom/movable/AM in olocs)
			thickness += AM.soundproofing
		listening = all_hearers(message_range, olocs[olocs.len])
	listening -= src
	listening += src

	var/list/heard_a = list() // understood us
	var/list/heard_b = list() // didn't understand us

	for (var/mob/M in listening)
		if (M.say_understands(src, forced_language))
			heard_a += M
		else
			heard_b += M

	var/list/processed = list()


	var/rendered = null
	if (length(heard_a))
		processed = saylist(messages[1], heard_a, olocs, thickness, italics, processed)

	if (length(heard_b))
		processed = saylist(messages[2], heard_b, olocs, thickness, italics, processed, 1)

	message = src.say_quote(messages[1])
	if (italics)
		message = "<i>[message]</i>"

	rendered = "<span class='game say'>[src.get_heard_name()] <span class='message'>[message]</span></span>"

	for (var/mob/M in mobs)
		if (istype(M, /mob/new_player))
			continue

		//Hello welcome to the world's most awful if
		if (M.client && ( \
			istype(M, /mob/dead/observer) || \
			(istype(M, /mob/wraith) && !M.density) || \
			(istype(M, /mob/living/intangible) && M in hearers(src)) || \
			( \
				(!isturf(src.loc) && src.loc == M.loc) && \
				!(M in heard_a) && \
				!istype(M, /mob/dead/target_observer) && \
				M != src \
			) \
		))

			var/thisR = rendered
			if (M.client.holder && src.mind)
				thisR = "<span class='adminHearing' data-ctx='[M.client.chatOutput.ctxFlag]'>[rendered]</span>"

			if (istype(M, /mob/dead) && M.client) //if a ghooooost (dead) (and online)
				if (M.client.local_deadchat || istype(M, /mob/wraith)) //only listening locally (or a wraith)? w/e man dont bold dat
					if (M in range(M.client.view, src))
						M.show_message(thisR, 2)
				else
					if (M in range(M.client.view, src)) //you're not just listening locally and the message is nearby? sweet! bold that sucka brosef
						M.show_message("<span class='bold'>[thisR]</span>", 2) //awwwww yeeeeeah lookat dat bold
					else
						M.show_message(thisR, 2)
			else
				M.show_message(thisR, 2)

// helper proooocs

/mob/proc/get_heard_name()
	return "<span class='name' data-ctx='\ref[src.mind]'>[src.name]</span>"

// say filters

/proc/say_drunk(var/string)
	var/modded = ""
	var/datum/text_roamer/T = new/datum/text_roamer(string)

	for(var/i = 0, i < length(string), i++)
		switch(T.curr_char)
			if("k")
				if(lowertext(T.prev_char) == "n" || lowertext(T.prev_char) == "c")
					modded += "gh"
				else
					modded += "g"
			if("K")
				if(lowertext(T.prev_char) == "N" || lowertext(T.prev_char) == "C")
					modded += "GH"
				else
					modded += "G"

			if("s")
				modded += "sh"
			if("S")
				modded += "SH"

			if("t")
				if(lowertext(T.next_char) == "h")
					modded += "du"
					T.curr_char_pos++
				else if(lowertext(T.prev_char) == "n")
					modded += "thf"
				else
					modded += "ff"
			if("T")
				if(lowertext(T.next_char) == "H")
					modded += "DU"
					T.curr_char_pos++
				else if(lowertext(T.prev_char) == "N")
					modded += "THF"
				else
					modded += "FF"
			else
				modded += T.curr_char
		T.curr_char_pos++
		T.update()

	return modded

// totally garbled drunk slurring

/proc/say_superdrunk(var/string)
	var/modded = ""
	var/datum/text_roamer/T = new/datum/text_roamer(string)

	for(var/i = 0, i < length(string), i++)
		switch(T.curr_char)
			if("b","c","d","f","g","h","j","k","l","m","n","p","q","r","s","t","v","w","x","y","z")
				modded += pick(consonants_lower)
			if("B","C","D","F","G","H","J","K","L","M","N","P","Q","R","S","T","V","W","X","Y","Z")
				modded += pick(consonants_upper)
			else
				modded += T.curr_char
		T.curr_char_pos++
		T.update()

	return modded

// berserker proc thing

/proc/say_furious(var/string)
	var/modded = ""
	var/datum/text_roamer/T = new/datum/text_roamer(string)

	for(var/i = 0, i < length(string), i=i)
		var/datum/parse_result/P = say_furious_parse(T)
		modded += P.string
		i += P.chars_used
		T.curr_char_pos = T.curr_char_pos + P.chars_used
		T.update()

	return modded

/proc/say_furious_parse(var/datum/text_roamer/R)
	var/new_string = ""
	var/used = 0

	switch(R.curr_char)
		if(" ","!","?",".",",",";")
			used = 1
		else
			new_string = pick("A","R","G","H")
			used = 1

	if(new_string == "")
		new_string = R.curr_char
		used = 1

	var/datum/parse_result/P = new/datum/parse_result
	P.string = new_string
	P.chars_used = used
	return P

// genetically falling apart!

/proc/say_gurgle(var/string)
	var/modded = ""
	var/datum/text_roamer/T = new/datum/text_roamer(string)

	for(var/i = 0, i < length(string), i=i)
		var/datum/parse_result/P = say_gurgle_parse(T)
		modded += P.string
		i += P.chars_used
		T.curr_char_pos = T.curr_char_pos + P.chars_used
		T.update()

	return modded

/proc/say_gurgle_parse(var/datum/text_roamer/R)
	var/new_string = ""
	var/used = 0

	switch(R.curr_char)
		if(" ","!","?",".",",",";")
			used = 1
		else
			new_string = pick("g","u","b","l")
			used = 1

	if(new_string == "")
		new_string = R.curr_char
		used = 1

	var/datum/parse_result/P = new/datum/parse_result
	P.string = new_string
	P.chars_used = used
	return P

/proc/chavify(var/string)
	var/modded = ""
	var/datum/text_roamer/T = new/datum/text_roamer(string)

	for(var/i = 0, i < length(string), i=i)
		var/datum/parse_result/P = chav_parse(T)
		modded += P.string
		i += P.chars_used
		T.curr_char_pos = T.curr_char_pos + P.chars_used
		T.update()

	if(prob(15))
		modded += pick(" innit"," like"," mate")

	return modded

/proc/chav_parse(var/datum/text_roamer/R)
	var/new_string = ""
	var/used = 0

	switch(lowertext(R.curr_char))
		if("w")
			if(lowertext(R.next_char) == "h" && lowertext(R.next_next_char) == "a")
				new_string = "wo"
				used = 3
		if("W")
			if(lowertext(R.next_char) == "H" && lowertext(R.next_next_char) == "A")
				new_string = "WO"
				used = 3

		if("o")
			if(lowertext(R.next_char) == "u" && lowertext(R.next_next_char) == "g" && lowertext(R.next_next_next_char) == "h")
				new_string = "uf"
				used = 4
			if(lowertext(R.next_char) == "r" && lowertext(R.next_next_char) == "r" && lowertext(R.next_next_next_char) == "y")
				new_string = "oz"
				used = 4
		if("O")
			if(lowertext(R.next_char) == "U" && lowertext(R.next_next_char) == "G" && lowertext(R.next_next_next_char) == "H")
				new_string = "UF"
				used = 4
			if(lowertext(R.next_char) == "R" && lowertext(R.next_next_char) == "R" && lowertext(R.next_next_next_char) == "Y")
				new_string = "OZ"
				used = 4

		if("t")
			if(lowertext(R.next_char) == "i" && lowertext(R.next_next_char) == "o" && lowertext(R.next_next_next_char) == "n")
				new_string = "shun"
				used = 4
			else if(lowertext(R.next_char) == "h" && lowertext(R.next_next_char) == "e")
				new_string = "zee"
				used = 3
			else if(lowertext(R.next_char) == "h" && (lowertext(R.next_next_char) == " " || lowertext(R.next_next_char) == "," || lowertext(R.next_next_char) == "." || lowertext(R.next_next_char) == "-"))
				new_string = "t" + R.next_next_char
				used = 3
		if("T")
			if(lowertext(R.next_char) == "I" && lowertext(R.next_next_char) == "O" && lowertext(R.next_next_next_char) == "N")
				new_string = "SHUN"
				used = 4
			else if(lowertext(R.next_char) == "H" && lowertext(R.next_next_char) == "E")
				new_string = "ZEE"
				used = 3
			else if(lowertext(R.next_char) == "H" && (lowertext(R.next_next_char) == " " || lowertext(R.next_next_char) == "," || lowertext(R.next_next_char) == "." || lowertext(R.next_next_char) == "-"))
				new_string = "T" + R.next_next_char
				used = 3

		if("u")
			if (lowertext(R.prev_char) != " " || lowertext(R.next_char) != " ")
				new_string = "oo"
				used = 1
		if("U")
			if (lowertext(R.prev_char) != " " || lowertext(R.next_char) != " ")
				new_string = "OO"
				used = 1

		if("o")
			if (lowertext(R.next_char) == "w"  && (lowertext(R.prev_char) != " " || lowertext(R.next_next_char )!= " "))
				new_string = "oo"
				used = 2
			else if (lowertext(R.prev_char) != " " || lowertext(R.next_char) != " ")
				new_string = "u"
				used = 1
			else if(lowertext(R.next_char) == " " && lowertext(R.prev_char) == " ") ///!!!
				new_string = "oo"
				used = 1
		if("O")
			if (lowertext(R.next_char) == "W"  && (lowertext(R.prev_char) != " " || lowertext(R.next_next_char )!= " "))
				new_string = "OO"
				used = 2
			else if (lowertext(R.prev_char) != " " || lowertext(R.next_char) != " ")
				new_string = "U"
				used = 1
			else if(lowertext(R.next_char) == " " && lowertext(R.prev_char) == " ") ///!!!
				new_string = "OO"
				used = 1

		if("i")
			if (lowertext(R.next_char) == "r"  && (lowertext(R.prev_char) != " " || lowertext(R.next_next_char) != " "))
				new_string = "ur"
				used = 2
			else if((lowertext(R.prev_char) != " " || lowertext(R.next_char) != " "))
				new_string = "ee"
				used = 1
		if("I")
			if (lowertext(R.next_char) == "R"  && (lowertext(R.prev_char) != " " || lowertext(R.next_next_char) != " "))
				new_string = "UR"
				used = 2
			else if((lowertext(R.prev_char) != " " || lowertext(R.next_char) != " "))
				new_string = "EE"
				used = 1

		if("e")
			if (lowertext(R.next_char) == "n"  && lowertext(R.next_next_char) == " ")
				new_string = "ee "
				used = 3
			else if (lowertext(R.next_char) == "w"  && (lowertext(R.prev_char) != " " || lowertext(R.next_next_char) != " "))
				new_string = "oo"
				used = 2
			else if ((lowertext(R.next_char) == " " || lowertext(R.next_char) == "," || lowertext(R.next_char) == "." || lowertext(R.next_char) == "-")  && lowertext(R.prev_char) != " ")
				new_string = "e-a" + R.next_char
				used = 2
			else if(lowertext(R.next_char) == " " && lowertext(R.prev_char) == " ") ///!!!
				new_string = "i"
				used = 1
		if("E")
			if (lowertext(R.next_char) == "N"  && lowertext(R.next_next_char) == " ")
				new_string = "EE "
				used = 3
			else if (lowertext(R.next_char) == "W"  && (lowertext(R.prev_char) != " " || lowertext(R.next_next_char) != " "))
				new_string = "OO"
				used = 2
			else if ((lowertext(R.next_char) == " " || lowertext(R.next_char) == "," || lowertext(R.next_char) == "." || lowertext(R.next_char) == "-")  && lowertext(R.prev_char) != " ")
				new_string = "E-A" + R.next_char
				used = 2
			else if(lowertext(R.next_char) == " " && lowertext(R.prev_char) == " ") ///!!!
				new_string = "I"
				used = 1

		if("a")
			if (lowertext(R.next_char) == "u")
				new_string = "oo"
				used = 2
			else if (lowertext(R.next_char) == "n")
				new_string = "un"
				used = 2
			else
				new_string = "e" //{WC} ?
				used = 1
		if("A")
			if (lowertext(R.next_char) == "U")
				new_string = "OO"
				used = 2
			else if (lowertext(R.next_char) == "N")
				new_string = "UN"
				used = 2
			else
				new_string = "E" //{WC} ?
				used = 1

	if(new_string == "")
		new_string = R.curr_char
		used = 1

	var/datum/parse_result/P = new/datum/parse_result
	P.string = new_string
	P.chars_used = used
	return P

/proc/smilify(var/string)
	var/modded = ""
	var/datum/text_roamer/T = new/datum/text_roamer(string)

	for(var/i = 0, i < length(string), i=i)
		var/datum/parse_result/P = smile_parse(T)
		modded += P.string
		i += P.chars_used
		T.curr_char_pos = T.curr_char_pos + P.chars_used
		T.update()

	modded += " :)"

	return modded

/proc/smile_parse(var/datum/text_roamer/R)
	var/used = 0
	var/new_string = ""
	if(R.next_char && lowertext(R.next_char) != " ")
		if(R.next_next_char != " ") new_string = "[R.curr_char] [R.next_char] "
		else new_string = "[R.curr_char] [R.next_char]"
		used = 2

	if(new_string == "")
		new_string = R.curr_char
		used = 1

	var/datum/parse_result/P = new/datum/parse_result
	P.string = new_string
	P.chars_used = used
	return P

/mob/living/Move(var/turf/NewLoc, direct)
	var/oldloc = loc
	..()
	if (isturf(oldloc) && isturf(loc) && move_laying)
		if (move_laying == src.equipped())
			move_laying.move_callback(src, oldloc, NewLoc)
		else
			move_laying = null

/mob/living/change_misstep_chance(var/amount)
	if (..())
		return

	src.misstep_chance = max(0,min(misstep_chance + amount,100))
	return

/mob/living/proc/get_static_image()
	if (src.disposed)
		return
	if (src.static_image)
		mob_static_icons.Remove(src.static_image)
	src.static_image = getTexturedImage(src.build_flat_icon(), "static", ICON_OVERLAY)//src, "static", ICON_OVERLAY)
	if (src.static_image)
		src.static_image.override = 1
		src.static_image.loc = src
		mob_static_icons.Add(src.static_image)
		DEBUG(bicon(src.static_image))
		return src.static_image
