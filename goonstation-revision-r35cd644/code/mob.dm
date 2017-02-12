/mob
	density = 1
	layer = MOB_LAYER
	animate_movement = 2
	soundproofing = 10
	var/datum/mind/mind

	var/datum/abilityHolder/abilityHolder = null
	var/datum/bioHolder/bioHolder = null
	var/datum/adventurevars/adventure_variables = new

	var/datum/targetable/targeting_spell = null

	var/obj/screen/pullin = null
	var/obj/screen/internals = null
	var/obj/screen/oxygen = null
	var/obj/screen/i_select = null
	var/obj/screen/m_select = null
	var/obj/screen/bodytemp = null
	var/obj/screen/healths = null
	var/obj/screen/throw_icon = null
	var/obj/screen/stamina_bar/stamina_bar = null
	var/last_overlay_refresh = 1 // In relation to world time. Used for traitor/nuke ops overlays certain mobs can see.

	var/robot_talk_understand = 0

	var/list/obj/hallucination/hallucinations = list()

	var/last_resist = 0

	//var/obj/screen/zone_sel/zone_sel = null
	var/datum/hud/zone_sel/zone_sel = null

	var/obj/item/device/energy_shield/energy_shield = null

	var/custom_gib_handler = null

	var/emote_allowed = 1
	var/last_emote_time = 0
	var/last_emote_wait = 0
	var/computer_id = null
	var/lastattacker = null
	var/lastattacked = null
	var/lastattackertime = 0
	var/obj/machinery/machine = null
	var/other_mobs = null
	var/memory = ""
	var/atom/movable/pulling = null
	var/stat = 0.0
	var/next_click = 0
	var/transforming = null
	var/hand = 0
	var/eye_blind = null
	var/eye_blurry = null
	var/eye_damage = null
	var/ear_deaf = null
	var/ear_damage = null
	var/stuttering = null
	var/real_name = null
	var/blinded = null
	var/druggy = 0
	var/asleep = 0
	var/sleeping = 0.0
	var/resting = 0.0
	var/lying = 0.0
	var/lying_old = 0
	var/canmove = 1.0
	var/timeofdeath = 0.0
	var/fakeloss = 0
	var/fakedead = 0
	var/cpr_time = 1.0
	var/health = 100
	var/max_health = 100
	var/bodytemperature = 310.055 // 98.7F / 37C
	var/base_body_temp = 310.055
	var/temp_tolerance = 15 // iterations between each temperature state
	var/thermoregulation_mult = 0.025 // how quickly the body's temperature tries to correct itself, higher = faster
	var/innate_temp_resistance = 0.15  // how good the body is at resisting environmental temperature
	var/drowsyness = 0.0
	var/dizziness = 0
	var/is_dizzy = 0
	var/is_jittery = 0
	var/jitteriness = 0
	var/charges = 0.0
	var/urine = 0.0
	var/nutrition = 0.0
	var/paralysis = 0.0
	var/stunned = 0.0
	var/weakened = 0.0
	var/slowed = 0.0
	var/last_recovering_msg = 0
	var/losebreath = 0.0
	var/intent = null
	var/shakecamera = 0
	var/a_intent = "help"
	var/m_intent = "run"
	var/lastKnownIP = null
	var/obj/stool/buckled = null
	var/obj/item/handcuffs/handcuffed = null
	var/obj/item/l_hand = null
	var/obj/item/r_hand = null
	var/obj/item/back = null
	var/obj/item/tank/internal = null
	var/obj/item/clothing/mask/wear_mask = null
	var/obj/item/clothing/ears/ears = null
	var/network_device = null
	var/Vnetwork = null
	var/lastDamageIconUpdate
	var/say_language = "english"

	var/datum/hud/storage/s_active

	var/respawning = 0

	var/obj/hud/hud_used = null

	var/list/organs = list(  )
	var/list/grabbed_by = list(  )

	var/datum/traitHolder/traitHolder

	var/inertia_dir = 0
	var/footstep = 1

	var/music_lastplayed = "null"

	var/job = null

	var/nodamage = 0

	//var/underwear = "No Underwear"
	//var/underwear_color = "#FFFFFF"

	var/spellshield = 0

	var/radiation = 0.0

	var/bomberman = 0

	var/voice_name = "unidentifiable voice"
	var/voice_message = null
	var/oldname = null
	var/mob/oldmob = null
	var/datum/mind/oldmind = null
	var/mob/dead/observer/ghost = null
	var/twitching = 0
	var/attack_alert = 0 // should we message admins when attacking another player?

	var/speechverb_say = "says"
	var/speechverb_ask = "asks"
	var/speechverb_exclaim = "exclaims"
	var/speechverb_stammer = "stammers"
	var/speechverb_gasp = "gasps"
	var/now_pushing = null

//Disease stuff
	var/list/resistances = list()
	var/list/ailments = list()

	mouse_drag_pointer = MOUSE_ACTIVE_POINTER

	var/vamp_beingbitten = 0 // Are we being drained by a vampire?

	var/atom/eye = null
	var/eye_pixel_x = 0
	var/eye_pixel_y = 0
	var/loc_pixel_x = 0
	var/loc_pixel_y = 0

	var/icon/cursor = null

	var/list/datum/hud/huds = list()

	var/client/last_client // actually the current client, used by Logout due to BYOND
	var/joined_date = null
	mat_changename = 0
	mat_changedesc = 0

	//Used for combat melee messages (e.g. "Foo punches Bar!")
	var/punchMessage = "punches"
	var/kickMessage = "kicks"

#ifdef MAP_OVERRIDE_DESTINY
	var/last_cryotron_message = 0 // to stop relaymove spam  :I
#endif

// mob procs
/mob/New()
	traitHolder = new(src)
	. = ..()
	mobs.Add(src)

/mob/proc/is_spacefaring()
	return 0

/mob/Move(a, b, flag)
	..()
	if (src.s_active && !(s_active.master in src))
		src.detach_hud(src.s_active)
		src.s_active = null

/mob/disposing()
	mobs.Remove(src)
	mind = null
	ckey = null
	client = null
	bioHolder = null
	pullin = null
	internals = null
	oxygen = null
	i_select = null
	m_select = null
	bodytemp = null
	healths = null
	throw_icon = null
	zone_sel = null
	energy_shield = null
	hallucinations = null
	buckled = null
	handcuffed = null
	l_hand = null
	r_hand = null
	back = null
	internal = null
	s_active = null
	wear_mask = null
	ears = null
	hud_used = null
	organs = null
	grabbed_by = null
	oldmob = null
	oldmind = null
	ghost = null
	resistances = null
	ailments = null
	..()

/mob/Login()
	// drsingh for cannot read null.address
	if (!src || !src.client)
		return

	if(!src.client.chatOutput.loaded)
		//Load custom chat
		src.client.chatOutput.start()

	src.client.screen = null //ov1 - to make sure we don't keep overlays of our old mob. This is here since logout wont work - when logout is called client is already null

	spawn (50)
		if (src.client)
			src.client.install_macros()

	src.last_client = src.client
	src.apply_camera(src.client)
	src.update_cursor()
	src.client.mouse_pointer_icon = src.cursor

	logTheThing("diary", null, src, "Login: %target% from [src.client.address]", "access")
	src.lastKnownIP = src.client.address
	src.computer_id = src.client.computer_id
	if (IsGuestKey(src.key))
		spawn() alert("Please sign into your BYOND key!")
		del(src)
	if (config.log_access)
		for (var/mob/M in mobs)
			if ((!M) || M == src || M.client == null)
				continue
			else if (M && M.client && M.client.address == src.client.address)
				logTheThing("admin", src, M, "has same IP address as %target%")
				logTheThing("diary", src, M, "has same IP address as %target%", "access")
				if (IP_alerts)
					message_admins("<font color='red'><B>Notice: </B><font color='blue'>[key_name(src)] has the same IP address as [key_name(M)]</font>")
			else if (M && M.lastKnownIP && M.lastKnownIP == src.client.address && M.ckey != src.ckey && M.key)
				logTheThing("diary", src, M, "has same IP address as %target% did (%target% is no longer logged in).", "access")
				if (IP_alerts)
					message_admins("<font color='red'><B>Notice: </B><font color='blue'>[key_name(src)] has the same IP address as [key_name(M)] did ([key_name(M)] is no longer logged in).</font>")
			if (M && M.client && M.client.computer_id == src.client.computer_id)
				logTheThing("admin", src, M, "has same computer ID as %target%")
				logTheThing("diary", src, M, "has same computer ID as %target%", "access")
				message_admins("<font color='red'><B>Notice: </B><font color='blue'>[key_name(src)] has the same <font color='red'><B>computer ID</B><font color='blue'> as [key_name(M)]</font>")
				spawn() alert("You have logged in already with another key this round, please log out of this one NOW or risk being banned!")
			else if (M && M.computer_id && M.computer_id == src.client.computer_id && M.ckey != src.ckey && M.key)
				logTheThing("diary", src, M, "has same computer ID as %target% did (%target% is no longer logged in).", null, "access")
				logTheThing("admin", M, null, "is no longer logged in.")
				message_admins("<font color='red'><B>Notice: </B><font color='blue'>[key_name(src)] has the same <font color='red'><B>computer ID</B><font color='blue'> as [key_name(M)] did ([key_name(M)] is no longer logged in).</font>")
				spawn() alert("You have logged in already with another key this round, please log out of this one NOW or risk being banned!")
/*  don't get me wrong this was awesome but it's leading to false positives now and we stopped caring about that guy
	var/evaderCheck = copytext(lastKnownIP,1, findtext(lastKnownIP, ".", 5))
	if (evaderCheck in list("174.50", "69.245", "71.228", "69.247", "71.203", "98.211", "68.53"))
		spawn(0)
			var/joinstring = "???"
			var/list/response = world.Export("http://www.byond.com/members/[src.ckey]?format=text")
			if (response && response["CONTENT"])
				var/result = html_encode(file2text(response["CONTENT"]))
				if (result)
					var/pos = findtext(result, "joined = ")
					joinstring = copytext(result, pos+14, pos+24)
			message_admins("<font color=red>Possible login by That Ban Evader Jerk: [key_name(src)] with IP \"[lastKnownIP]\" and computer ID \[[src.client.computer_id]]. (Regdate: [joinstring])</font>")
			logTheThing("admin", src, null, "Possible login by Ban Evader Jerk:. IP: [lastKnownIP], Computer ID: \[[src.client.computer_id]], Regdate: [joinstring]")
			logTheThing("diary", src, null, "Possible login by Ban Evader Jerk:. IP: [lastKnownIP], Computer ID: \[[src.client.computer_id]], Regdate: [joinstring]", "admin")
			if (!("[src.ckey]" in IRC_alerted_keys))
				IRC_alerted_keys += "[src.ckey]"
*/
	if (!src.bioHolder) src.bioHolder = new /datum/bioHolder ( src )

	world.update_status()

	if (!src.hud_used)
		src.hud_used = new/obj/hud( src )
	else
		src.hud_used.dispose()
		src.hud_used = new/obj/hud( src )

	src.sight |= SEE_SELF

	..()

	if (src.client)
		for (var/datum/hud/hud in src.huds)
			hud.add_client(src.client)

		src.addOverlaysClient(src.client)  //ov1

	src.emote_allowed = 1

	if (!src.mind)
		src.mind = new (src)

	if (src.mind && !src.mind.key)
		src.mind.key = src.key

	if (isobj(src.loc))
		var/obj/O = src.loc
		if (istype(O))
			O.client_login(src)

	src.need_update_item_abilities = 1
	src.antagonist_overlay_refresh(1, 0)
	return

/mob/Logout()

	//logTheThing("diary", src, null, "logged out", "access") <- sometimes shits itself and has been known to out traitors. Disabling for now.
	src.machine = null

	if (src.last_client && !src.key) // lets see if not removing the HUD from disconnecting players helps with the crashes
		for (var/datum/hud/hud in src.huds)
			hud.remove_client(src.last_client)

	..()

	return 1

/mob/proc/deliver_move_trigger(ev)
	return

/mob/Bump(atom/movable/AM as mob|obj, yes)
	if ((!( yes ) || src.now_pushing))
		return
	src.now_pushing = 1

	if (ismob(AM) && istype (AM, /mob/living/carbon/) && istype(src, /mob/living/))
		src:viral_transmission(AM,"Contact",1)

	if (ismob(AM))
		var/mob/tmob = AM
		if (!issilicon(AM))
			if (tmob.a_intent == "help" && src.a_intent == "help" && tmob.canmove && src.canmove && !tmob.buckled && !src.buckled) // mutual brohugs all around!
				var/turf/oldloc = src.loc
				var/turf/newloc = tmob.loc

				src.set_loc(newloc)
				tmob.set_loc(oldloc)

				if (istype(tmob.loc, /turf/space))
					logTheThing("combat", src, tmob, "trades places with (Help Intent) %target%, pushing them into space.")
				else if (locate(/obj/hotspot) in tmob.loc)
					logTheThing("combat", src, tmob, "trades places with (Help Intent) %target%, pushing them into a fire.")
				deliver_move_trigger("swap")
				tmob.deliver_move_trigger("swap")
				src.now_pushing = 0

				return

		if (istype(tmob, /mob/living/carbon/human) && tmob.bioHolder.HasEffect("fat"))
			if (prob(40) && !src.bioHolder.HasEffect("fat"))
				for(var/mob/M in viewers(src, null))
					if (M.client)
						boutput(M, "<span style=\"color:red\"><B>[src] fails to push [tmob]'s fat ass out of the way.</B></span>")
				src.now_pushing = 0
				src.unlock_medal("That's no moon, that's a GOURMAND!", 1)
				deliver_move_trigger("bump")
				tmob.deliver_move_trigger("bump")
				return
	src.now_pushing = 0
	spawn(0)
		..()
		if (!istype(AM, /atom/movable))
			return
		if (!src.now_pushing)
			src.now_pushing = 1
			if (!AM.anchored)
				var/t = get_dir(src, AM)
				step(AM, t)
				if (istype(AM, /mob/living))
					var/mob/victim = AM
					deliver_move_trigger("bump")
					victim.deliver_move_trigger("bump")
					if (victim.buckled && !victim.buckled.anchored)
						step(victim.buckled, t)
					if (istype(victim.loc, /turf/space))
						logTheThing("combat", src, victim, "pushes %target% into space.")
					else if (locate(/obj/hotspot) in victim.loc)
						logTheThing("combat", src, victim, "pushes %target% into a fire.")
			src.now_pushing = null
		return
	return

// I moved the log entries from human.dm to make them global (Convair880).
/mob/ex_act(severity, last_touched)
	logTheThing("combat", src, null, "is hit by an explosion (Severity: [severity]) at [log_loc(src)]. Explosion source last touched by [last_touched]")
	return

/mob/proc/projCanHit(datum/projectile/P)
	return 1

/mob/proc/attach_hud(datum/hud/hud)
	if (!huds.Find(hud))
		huds += hud
		hud.mobs += src
		if (src.client)
			hud.add_client(src.client)

/mob/proc/detach_hud(datum/hud/hud)
	huds -= hud
	hud.mobs -= src
	if (src.client)
		hud.remove_client(src.client)

/mob/proc/set_eye(atom/new_eye, new_pixel_x = 0, new_pixel_y = 0)
	src.eye = new_eye
	src.eye_pixel_x = new_pixel_x
	src.eye_pixel_y = new_pixel_y
	src.update_camera()

/mob/set_loc(atom/new_loc, new_pixel_x = 0, new_pixel_y = 0)
	. = ..(new_loc)
	src.loc_pixel_x = new_pixel_x
	src.loc_pixel_y = new_pixel_y
	src.update_camera()

/mob/proc/update_camera()
	if (src.client)
		apply_camera(src.client)

/mob/proc/apply_camera(client/C)
	if (src.eye)
		C.eye = src.eye
		C.pixel_x = src.eye_pixel_x
		C.pixel_y = src.eye_pixel_y
	else
		C.eye = src
		C.pixel_x = src.loc_pixel_x
		C.pixel_y = src.loc_pixel_y

/mob/proc/can_strip()
	return 1

/mob/proc/set_cursor(icon/cursor)
	src.cursor = cursor
	if (src.client)
		src.client.mouse_pointer_icon = cursor

/mob/proc/update_cursor()
	if (src.targeting_spell)
		if(client)
			src.set_cursor(cursors_selection[client.preferences.target_cursor])
			return
		else
			src.set_cursor('icons/cursors/target/default.dmi')
			return
	src.set_cursor(null)

// medals

/mob/proc/unlock_medal(title, announce)
	if (!src.client || !src.key)
		return
	else if (IsGuestKey(src.key))
		return
	else if (!config || !config.medal_hub || !config.medal_password)
		return

	var/key = src.key
	spawn ()
		var/list/unlocks = list()
		for(var/A in rewardDB)
			var/datum/achievementReward/D = rewardDB[A]
			if (D.required_medal == title)
				unlocks.Add(D)

		var/result = world.SetMedal(title, key, config.medal_hub, config.medal_password)

		if (result == 1)
			if (announce)
				boutput(world, "<span class=\"medal\">[key] earned the [title] medal.</span>")//src.client.stealth ? src.client.fakekey : << seems to be causing trouble
			else if (ismob(src) && src.client)
				boutput(src, "<span class=\"medal\">You earned the [title] medal.</span>")

			if (length(unlocks))
				for(var/datum/achievementReward/B in unlocks)
					boutput(src, "<FONT FACE=Arial COLOR=gold SIZE=+1>You've unlocked a Reward : [B.title]!</FONT>")

		else if (isnull(result) && ismob(src) && src.client)
			return
//			boutput(src, "<span style=\"color:red\">You would have earned the [title] medal, but there was an error communicating with the BYOND hub.</span>")

/mob/proc/has_medal(var/medal) //This is not spawned because of return values. Make sure the proc that uses it uses spawn or you lock up everything.

	if (IsGuestKey(src.key))
		return null
	else if (!config)
		return null
	else if (!config.medal_hub || !config.medal_password)
		return null

	var/result = world.GetMedal(medal, src.key, config.medal_hub, config.medal_password)
	return result

/mob/verb/list_medals()
	set name = "Medals"

	if (IsGuestKey(src.key))
		boutput(src, "<span style=\"color:red\">Sorry, you are a guest and cannot have medals.</span>")
		return
	else if (!config)
		boutput(src, "<span style=\"color:red\">Sorry, medal information is currently not available.</span>")
		return
	else if (!config.medal_hub || !config.medal_password)
		boutput(src, "<span style=\"color:red\">Sorry, this server does not have medals enabled.</span>")
		return

	boutput(src, "Retrieving your medal information...")

	spawn ()
		var/medals = world.GetMedal("", src.key, config.medal_hub, config.medal_password)

		if (isnull(medals))
			boutput(src, "<span style=\"color:red\">Sorry, could not contact the BYOND hub for your medal information.</span>")
			return

		if (!medals)
			boutput(src, "<b>You don't have any medals.</b>")
			return

		medals = params2list(medals)
		medals = sortList(medals)

		boutput(src, "<b>Medals:</b>")
		for (var/medal in medals)
			boutput(src, "&emsp;[medal]")
		boutput(src, "<b>You have [length(medals)] medal\s.</b>")

/mob/verb/setdnr()
	set name = "Set DNR"
	set desc = "Set yourself as Do Not Resuscitate."
	var/confirm = alert("Set yourself as Do Not Resuscitate (WARNING: This is one-use only and will prevent you from being revived in any manner)", "Set Do Not Resuscitate", "Yes", "Cancel")
	if (confirm == "Cancel")
		return
	if (confirm == "Yes")
		if (src.mind)
			src.verbs -= list(/mob/verb/setdnr)
			src.mind.dnr = 1
			boutput(src, "<span style=\"color:red\">DNR status set!</span>")
		else
			src << alert("There was an error setting this status. Perhaps you are a ghost?")
	return

/mob/proc/Cell()
	set category = "Admin"
	set hidden = 1

	if (!loc) return 0

	var/datum/gas_mixture/environment = loc.return_air()
//
	var/t = "<span style=\"color:blue\">Coordinates: [x],[y]<br></span>"
	t+= "<span style=\"color:red\">Temperature: [environment.temperature]<br></span>"
	t+= "<span style=\"color:blue\">Nitrogen: [environment.nitrogen]<br></span>"
	t+= "<span style=\"color:blue\">Oxygen: [environment.oxygen]<br></span>"
	t+= "<span style=\"color:blue\">Plasma : [environment.toxins]<br></span>"
	t+= "<span style=\"color:blue\">Carbon Dioxide: [environment.carbon_dioxide]<br></span>"
	if (environment.trace_gases)
		for(var/datum/gas/trace_gas in environment.trace_gases)
			boutput(usr, "<span style=\"color:blue\">[trace_gas.type]: [trace_gas.moles]<br></span>")
	else
		boutput(usr, "<span style=\"color:blue\">No trace gases.<br></span>")

	usr.show_message(t, 1)



/obj/equip_e/proc/process()
	return

/obj/equip_e/proc/done()
	return

/obj/equip_e/New()
	if (!ticker)
		qdel(src)
		return
	spawn(100)
		qdel(src)
		return
	..()
	return

/mob/proc/show_message(msg, type, alt, alt_type)
	if (!src.client)
		return

	// We have procs to check for this stuff, you know. Ripped out a bunch of duplicate code, which also fixed earmuffs (Convair880).
	if (type)
		if ((type & 1) && !src.sight_check(1))
			if (!alt)
				return
			else
				msg = alt
				type = alt_type
		if ((type & 2) && !src.hearing_check(1))
			if (!alt)
				return
			else
				msg = alt
				type = alt_type
			if ((type & 1) && !src.sight_check(1))
				return

	if (src.stat == 1 || src.sleeping || src.paralysis)
		if (prob(20))
			boutput(src, "<I>... You can almost hear something ...</I>")
			if (istype(src, /mob/living))
				for (var/mob/dead/target_observer/observer in src:observers)
					boutput(observer, "<I>... You can almost hear something ...</I>")
	else
		boutput(src, msg)

		var/psychic_link = src.get_psychic_link()
		if (ismob(psychic_link))
			boutput(psychic_link, msg)

		if (istype(src, /mob/living))
			for (var/mob/dead/target_observer/observer in src:observers)
				boutput(observer, msg)

// Show a message to all mobs in sight of this one
// This would be for visible actions by the src mob
// message is the message output to anyone who can see e.g. "[src] does something!"
// self_message (optional) is what the src mob sees  e.g. "You do something!"
// blind_message (optional) is what blind people will hear e.g. "You hear something!"

/mob/visible_message(var/message, var/self_message, var/blind_message)
	for (var/mob/M in AIviewers(src))
		if (!M.client)
			continue
		var/msg = message
		if (self_message && M==src)
			msg = self_message
		M.show_message(msg, 1, blind_message, 2)

// Show a message to all mobs in sight of this atom
// Use for objects performing visible actions
// message is output to anyone who can see, e.g. "The [src] does something!"
// blind_message (optional) is what blind people will hear e.g. "You hear something!"
/atom/proc/visible_message(var/message, var/blind_message)
	for (var/mob/M in AIviewers(src))
		if (!M.client)
			continue
		M.show_message(message, 1, blind_message, 2)

// for things where there are three parties that should recieve different messages (specifically made for surgery):
// viewer_message, the thing visible to everyone except specified targets
// first_message, the thing visible to first_target
// second_message, the thing visible to second_target
// blind_message (optional) is what blind people will hear e.g. "You hear something!"
/mob/proc/tri_message(var/viewer_message, var/first_target, var/first_message, var/second_target, var/second_message, var/blind_message)
	for (var/mob/M in AIviewers(src))
		if (!M.client)
			continue
		var/msg = viewer_message
		if (first_message && M == first_target)
			msg = first_message
		if (second_message && M == second_target && M != first_target)
			msg = second_message
		M.show_message(msg, 1, blind_message, 2)
		//DEBUG("<b>[M] recieves message: &quot;[msg]&quot;</b>")

// it was about time we had this instead of just visible_message()
/atom/proc/audible_message(var/message)
	for (var/mob/M in all_hearers(null, src))
		if (!M.client)
			continue
		M.show_message(message, 2)

/mob/audible_message(var/message, var/self_message)
	for (var/mob/M in all_hearers(null, src))
		if (!M.client)
			continue
		var/msg = message
		if (self_message && M==src)
			msg = self_message
		M.show_message(msg, 2)

/mob/proc/unequip_all()
	if (isobserver(src))
		var/obj/ecto = new/obj/item/reagent_containers/food/snacks/ectoplasm
		ecto.loc = src.loc
	return

/mob/living/unequip_all(var/delete_stuff = 0)
	for (var/obj/item/W in src)
		if (istype(W, /obj/item/parts) && W:holder == src)
			continue

		src.u_equip(W)
		if (W)
			W.set_loc(src.loc)
			W.dropped(src)
			W.layer = initial(W.layer)
			if (delete_stuff)
				qdel(W)

	return

/mob/living/carbon/human/unequip_all(var/delete_stuff = 0)
	for (var/obj/item/W in src)
		if (istype(W, /obj/item/parts) && W:holder == src)
			continue

		if (src.organHolder)
			if (istype(W, /obj/item/organ/chest) && src.organHolder.chest == W)
				continue
			if (istype(W, /obj/item/organ/head) && src.organHolder.head == W)
				continue
			if (istype(W, /obj/item/skull) && src.organHolder.skull == W)
				continue
			if (istype(W, /obj/item/organ/brain) && src.organHolder.brain == W)
				continue
			if (istype(W, /obj/item/organ/eye) && (src.organHolder.left_eye == W || src.organHolder.right_eye == W))
				continue
			if (istype(W, /obj/item/organ/heart) && src.organHolder.heart == W)
				continue
			if (istype(W, /obj/item/organ/lung) && (src.organHolder.left_lung == W || src.organHolder.right_lung == W))
				continue
			if (istype(W, /obj/item/clothing/head/butt) && src.organHolder.butt == W)
				continue

		src.u_equip(W)
		if (W)
			W.set_loc(src.loc)
			W.dropped(src)
			W.layer = initial(W.layer)
			if (delete_stuff)
				qdel(W)

	return

/mob/proc/findname(msg)
	for(var/mob/M in mobs)
		if (M.real_name == text("[]", msg))
			return M
	return 0

/mob/proc/movement_delay()
	return 0

/mob/proc/Life(datum/controller/process/mobs/parent)
	return

// for mobs without organs
/mob/proc/TakeDamage(zone, brute, burn, tox, damage_type)
	hit_twitch()
	src.health -= max(0, brute)
	if (!is_heat_resistant())
		src.health -= max(0, burn)

/mob/proc/TakeDamageAccountArmor(zone, brute, burn, tox, damage_type)
	TakeDamage(zone, brute, burn)

/mob/proc/HealDamage(zone, brute, burn, tox)
	health += max(0, brute)
	health += max(0, burn)
	health += max(0, tox)
	health = min(max_health, health)

// less icon caching maybe?!

#define FACE 1
#define BODY 2
#define CLOTHING 4
#define DAMAGE 8

/mob/var/icon_rebuild_flag = 0

/mob/proc/update_icons_if_needed()
	if (icon_rebuild_flag & FACE)
		update_face()

	if (icon_rebuild_flag & BODY)
		update_body()

	if (icon_rebuild_flag & CLOTHING)
		update_clothing()

	if (icon_rebuild_flag & DAMAGE)
		UpdateDamageIcon()

/mob/proc/set_clothing_icon_dirty()
	icon_rebuild_flag |= CLOTHING

/mob/proc/update_clothing()
	icon_rebuild_flag &= ~CLOTHING

/mob/proc/set_body_icon_dirty()
	icon_rebuild_flag |= BODY

/mob/proc/update_body()
	icon_rebuild_flag &= ~BODY

/mob/proc/UpdateDamage()
	return

/mob/proc/set_damage_icon_dirty()
	icon_rebuild_flag |= DAMAGE

/mob/proc/UpdateDamageIcon()
	if (lastDamageIconUpdate && !(world.time - lastDamageIconUpdate))
		return
	lastDamageIconUpdate = world.time
	icon_rebuild_flag &= ~DAMAGE

/mob/proc/set_face_icon_dirty()
	icon_rebuild_flag |= FACE

/mob/proc/update_face()
	icon_rebuild_flag &= ~FACE

#undef FACE
#undef BODY
#undef CLOTHING
#undef DAMAGE

/mob/proc/death(gibbed)
	//Traitor's dead! Oh no!
	if (src.mind && src.mind.special_role)
		message_admins("<span style=\"color:red\">Antagonist [key_name(src)] ([src.mind.special_role]) died at [log_loc(src)].</span>")

	src.timeofdeath = world.time
	return ..(gibbed)

/mob/proc/restrained()
	if (src.handcuffed)
		return 1

/mob/proc/key_down(var/key)
/mob/proc/key_up(var/key)

/mob/proc/click(atom/target, params)
	var/list/parameters = params2list(params)

	if (src.targeting_spell)
		var/datum/targetable/S = src.targeting_spell

		src.targeting_spell = null
		update_cursor()

		if (!S.target_anything && !ismob(target))
			src.show_text("You have to target a person.", "red")
			if(S.sticky)
				src.targeting_spell = S
				update_cursor()
			return 100
		if (!isturf(target.loc) && !isturf(target))
			if(S.sticky)
				src.targeting_spell = S
				update_cursor()
			return 100
		if (S.check_range && (get_dist(src, target) > S.max_range) )
			src.show_text("You are too far away from the target.", "red") // At least tell them why it failed.
			if(S.sticky)
				src.targeting_spell = S
				update_cursor()
			return 100
		if (!S.can_target_ghosts && ismob(target) && (!isliving(target) || iswraith(target) || isintangible(target)))
			src.show_text("It would have no effect on this target.", "red")
			if(S.sticky)
				src.targeting_spell = S
				update_cursor()
			return 100
		if (!S.castcheck(src))
			if(S.sticky)
				src.targeting_spell = S
				update_cursor()
			return 100
		actions.interrupt(src, INTERRUPT_ACTION)
		spawn
			S.handleCast(target)
			if(S)
				if((S.ignore_sticky_cooldown && !S.cooldowncheck()) || (S.sticky && S.cooldowncheck()))
					if(src)
						src.targeting_spell = S
						src.update_cursor()
		return 100

	if (abilityHolder)
		if (abilityHolder.topBarRendered)
			if (abilityHolder.click(target, params))
				return 100

	if (src.client.holder)
		if (("ctrl" in parameters) && ("right" in parameters))
			usr.client.debug_variables(target)

	//circumvented by some rude hack in client.dm; uncomment if hack ceases to exist
	//if (istype(target, /obj/screen/ability))
	//	target:clicked(params)
	if (get_dist(src, target) > 0)
		dir = get_dir(src, target)

/mob/proc/action(num)
	if(src.abilityHolder)
		src.abilityHolder.actionKey(num)
	return

/mob/proc/south_east()
	return

/mob/proc/drop_item_v()
	if (src.stat == 0)
		drop_item()
	return

/mob/proc/drop_from_slot(var/obj/item/item, var/turf/T)
	if (!item)
		return
	if (!(item in src.contents))
		return
	if (item.cant_drop)
		return
	if (item.cant_self_remove && src.l_hand != item && src.r_hand != item)
		return
	u_equip(item)
	src.set_clothing_icon_dirty()
	if (!T)
		T = src.loc
	if (item)
		item.set_loc(T)
		item.dropped(src)
		if (item)
			item.layer = initial(item.layer)
	T.Entered(item)
	return

/mob/proc/drop_item()
	var/obj/item/W = src.equipped()
	if (istype(W))
		var/obj/item/magtractor/origW
		if (W.useInnerItem && W.contents.len > 0)
			if (istype(W, /obj/item/magtractor))
				origW = W
			W = pick(W.contents)
		if (!W || W.cant_drop) return
		u_equip(W)
		if (W)
			if (istype(src.loc, /obj/vehicle))
				var/obj/vehicle/V = src.loc
				if (V.throw_dropped_items_overboard == 1)
					W.set_loc(get_turf(V))
				else
					W.set_loc(src.loc)
			else if (istype(src.loc, /obj/machinery/bot/mulebot))
				W.set_loc(get_turf(src.loc))
			else
				W.set_loc(src.loc)
			W.dropped(src)
			if (W)
				W.layer = initial(W.layer)
		var/turf/T = get_turf(src.loc)
		T.Entered(W)
		if (origW)
			origW.holding = null
			actions.stopId("magpickerhold", src)
		return 1
	return 0

/mob/proc/remove_item(var/obj/O)
	if (O)
		u_equip(O)
		src.set_clothing_icon_dirty()

/mob/proc/equipped()
	if (issilicon(src))
		if (ishivebot(src)||isrobot(src))
			if (src:module_active)
				return src:module_active

	else
		if (src.hand)
			return src.l_hand
		else
			return src.r_hand
		return

/mob/proc/swap_hand()
	return

/mob/proc/u_equip(W as obj)

// I think this bit is handled by each method of dropping it, and it prevents dropping items in your hands and other procs using u_equip so I'll get rid of it for now.
//	if (hasvar(W,"cant_self_remove"))
//		if (W:cant_self_remove) return

	if (W == src.r_hand)
		src.r_hand = null
	else if (W == src.l_hand)
		src.l_hand = null
	else if (W == src.handcuffed)
		src.handcuffed = null
	else if (W == src.back)
		src.back = null
	else if (W == src.wear_mask)
		src.wear_mask = null

	if (src.client)
		src.client.screen -= W

	set_clothing_icon_dirty()

/mob/proc/ret_grab(obj/list_container/mobl/L as obj, flag)
	if (!(locate(/obj/item/grab) in src))
		if (!L)
			return null
		else
			return L.container
	else
		if (!L)
			L = new /obj/list_container/mobl( null )
			L.container += src
			L.master = src
		for (var/obj/item/grab/G in src)
			if (!G.affecting)
				qdel(G)
				return
			if (!( L.container.Find(G.affecting) ))
				L.container += G.affecting
				G.affecting.ret_grab(L, 1)
		if (!( flag ))
			if (L.master == src)
				var/list/temp = list(  )
				temp += L.container
				//L = null
				qdel(L)
				return temp
			else
				return L.container
	return

/*
/mob/verb/dump_source()

	var/master = "<PRE>"
	for(var/t in typesof(/area))
		master += text("[]<br>", t)
		//Foreach goto(26)
	src << browse(master)
	return
*/

/mob/verb/memory()
	set name = "Notes"
	// drsingh for cannot execute null.show_memory
	if (isnull(mind))
		return

	mind.show_memory(src)
//	for(var/datum/objective/objective in mind.objectives)
		//if (istype(objective, /datum/objective/aikill))
		//	usr << browse('icons/AIobjective.jpg',"window=some;titlebar=1;size=550x400;can_minimize=0;can_resize=0")
//		if (istype(objective, /datum/objective/destroy_outpost))
//			usr << browse('nukezeta.jpg',"window=some;titlebar=1;size=550x400;can_minimize=0;can_resize=0")


/mob/verb/add_memory(msg as message)
	set name = "Add Note"

	if (mind.last_memory_time + 10 <= world.time)
		mind.last_memory_time = world.time

		msg = copytext(msg, 1, MAX_MESSAGE_LEN)
		msg = sanitize(msg)

		mind.store_memory(msg)

// please note that this store_memory() vvv
// does not store memories in the notes
// it is named the same thing as the mind proc to store notes, but it does not store notes
/mob/proc/store_memory(msg as message, popup, sane = 1)
	msg = copytext(msg, 1, MAX_MESSAGE_LEN)

	if (sane)
		msg = sanitize(msg)

	if (length(src.memory) == 0)
		src.memory += msg
	else
		src.memory += "<BR>[msg]"

	if (popup)
		src.memory()

/mob/proc/recite_miranda()
	set name = "Recite Miranda Rights"
	if (isnull(src.mind))
		return
	if (isnull(src.mind.miranda))
		src.say_verb("You have the right to remain silent. Anything you say can and will be used against you in a NanoTrasen court of Space Law. You have the right to a rent-an-attorney. If you cannot afford one, a monkey in a suit and funny hat will be appointed to you.")
		return
	src.say_verb(src.mind.miranda)

/mob/proc/add_miranda()
	set name = "Set Miranda Rights"
	if (isnull(src.mind))
		return
	if (src.mind.last_memory_time + 10 <= world.time) // leaving it using this var cause vOv
		src.mind.last_memory_time = world.time // why not?

		if (isnull(src.mind.miranda))
			src.mind.set_miranda("You have the right to remain silent. Anything you say can and will be used against you in a NanoTrasen court of Space Law. You have the right to a rent-an-attorney. If you cannot afford one, a monkey in a suit and funny hat will be appointed to you.")

		src.mind.show_miranda(src)

		var/new_rights = input(usr, "Change what you will say with the Say Miranda Rights verb.", "Set Miranda Rights", src.mind.miranda) as null|text
		if (!new_rights || new_rights == src.mind.miranda)
			src.show_text("Miranda rights not changed.", "red")
			return

		new_rights = copytext(new_rights, 1, MAX_MESSAGE_LEN)
		new_rights = sanitize(strip_html(new_rights))

		src.mind.set_miranda(new_rights)

		logTheThing("telepathy", src, null, "has set their miranda rights quote to: [src.mind.miranda]")
		src.show_text("Miranda rights set to \"[src.mind.miranda]\"", "blue")

/mob/verb/help()
	set name = "Help"
	//src << browse('browserassets/html/admin/help.html', "window=help")
	//boutput(src, "<span style=\"color:blue\">Please visit the goonstation wiki at <b>http://wiki.ss13.co</b> for more indepth help.</span>")
	return

/mob/verb/hotkeys()
	set name = "Hotkeys"
	//src << browse('browserassets/html/admin/hotkeys.html', "window=help")
	return

/mob/verb/abandon_mob()
	set name = "Respawn"

	if (!( abandon_allowed ))
		return
	if ((src.stat != 2 || !( ticker )))
		boutput(usr, "<span style=\"color:blue\"><B>You must be dead to use this!</B></span>")
		return

	logTheThing("diary", usr, null, "used abandon mob.", "game")

	//boutput(usr, "<span style=\"color:blue\"><B>Please roleplay correctly!</B></span>")

	if (!src.client)
		logTheThing("diary", usr, null, "AM failed due to disconnect.", "game")
		return
	for(var/obj/screen/t in usr.client.screen)
		if (t.loc == null)
			//t = null
			qdel(t)
	if (!src.client)
		logTheThing("diary", usr, null, "AM failed due to disconnect.", "game")
		return

	var/mob/new_player/M = new /mob/new_player()
	if (!src.client)
		logTheThing("diary", usr, null, "AM failed due to disconnect.", "game")
		qdel(M)
		return



	if (src.client && src.client.holder && (src.client.holder.state == 2))
		src.client.admin_play()
		return

	M.key = src.client.key
	M.Login()
	return

/mob/verb/cmd_rules()
	set name = "Rules"
	src << browse(rules, "window=rules;size=480x320")

/mob/verb/togglelocaldeadchat()
	set desc = "Toggle whether you can hear all chat while dead or just local chat"
	set name = "Toggle Deadchat Range"

	if (!usr.client) //How could this even happen?
		return

	usr.client.local_deadchat = !usr.client.local_deadchat
	boutput(usr, "<span style=\"color:blue\">[usr.client.local_deadchat ? "Now" : "No longer"] hearing local chat only.</span>")

/mob/verb/succumb()
	set hidden = 1
/*
//prevent a suicide if the person is infected with the headspider disease.
	for (var/datum/ailment/V in src.ailments)
		if (istype(V, /datum/ailment/parasite/headspider) || istype(V, /datum/ailment/parasite/alien_embryo))
			boutput(src, "You can't muster the willpower. Something is preventing you from doing it.")
			return
*/
//or if they are being drained of blood
	if (src.vamp_beingbitten)
		boutput(src, "You can't muster the willpower. Something is preventing you from doing it.")
		return

	if (src.health < 0)
		boutput(src, "<span style=\"color:blue\">You have given up life and succumbed to death.</span>")
		src.death()
		if (!src.suiciding)
			src.unlock_medal("Yield", 1)
		logTheThing("combat", src, null, "succumbs")

/mob/verb/cancel_camera()
	set name = "Cancel Camera View"
	src.set_eye(null)
	src.machine = null
	if (istype(src, /mob/living))
		if (src:cameraFollow)
			src:cameraFollow = null
	else
		src.sight = SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_SELF

/mob/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (air_group || (height==0)) return 1

	if (istype(mover, /obj/projectile))
		return !projCanHit(mover:proj_data)


	if (ismob(mover))
		var/mob/moving_mob = mover
		if ((src.other_mobs && moving_mob.other_mobs))
			return 1
		return (!mover.density || !src.density || src.lying)
	else
		return (!mover.density || !src.density || src.lying)
	return

/mob/proc/update_inhands()

/mob/proc/put_in_hand(obj/item/I, hand)
	return 0

/mob/proc/get_damage()
	return src.health

/mob/bullet_act(var/obj/projectile/P)
	var/damage = 0
	damage = round((P.power*P.proj_data.ks_ratio), 1.0)
	var/stun = 0
	stun = round((P.power*(1.0-P.proj_data.ks_ratio)), 1.0)

	if (src.material) src.material.triggerOnAttacked(src, P.shooter, src, (ismob(P.shooter) ? P.shooter:equipped() : P.shooter))
	for(var/atom/A in src)
		if (A.material)
			A.material.triggerOnAttacked(A, P.shooter, src, (ismob(P.shooter) ? P.shooter:equipped() : P.shooter))

	switch(P.proj_data.damage_type)
		if (D_KINETIC)
			TakeDamage("All", damage, 0)
		if (D_PIERCING)
			TakeDamage("All", damage / 2, 0)
		if (D_SLASHING)
			TakeDamage("All", damage, 0)
		if (D_ENERGY)
			TakeDamage("All", 0, damage)
			if (prob(stun))
				src.paralysis += stun
			else if (prob(90))
				src.stunned += stun
			else
				src.weakened += (stun/2)
			src.set_clothing_icon_dirty()
		if (D_BURNING)
			TakeDamage("All", 0, damage)
		if (D_RADIOACTIVE)
			src.irradiate(damage)
			src.stuttering += stun
			src.drowsyness += stun
		if (D_TOXIC)
			src.take_toxin_damage(damage)
	if (!P.proj_data.silentshot)
		src.visible_message("<span style=\"color:red\">[src] is hit by the [P]!</span>")

	actions.interrupt(src, INTERRUPT_ATTACKED)
	return

/mob/proc/can_use_hands()
	if (src.handcuffed)
		return 0
	if (src.buckled && istype(src.buckled, /obj/stool/bed)) // buckling does not restrict hands
		return 0
	return 1

/mob/proc/is_active()
	return (0 >= usr.stat)

/mob/proc/see(message)
	if (!src.is_active())
		return 0
	boutput(src, message)
	return 1

/mob/proc/show_viewers(message)
	for(var/mob/M in AIviewers())
		M.see(message)

/mob/proc/updatehealth()
	if (src.nodamage == 0)
		src.health = max_health - src.get_oxygen_deprivation() - src.get_toxin_damage() - src.get_burn_damage() - src.get_brute_damage()
	else
		src.health = max_health
		src.stat = 0

/mob/proc/adjustBodyTemp(actual, desired, incrementboost, divisor)
	var/temperature = actual
	var/difference = abs(actual-desired)   // get difference
	var/increments = difference * divisor  //find how many increments apart they are
	var/change = increments*incrementboost // Get the amount to change by (x per increment)
	//change = change * 0.10

	if (actual < desired) // Too cold
		temperature += change
		if (actual > desired)
			temperature = desired

	if (actual > desired) // Too hot
		temperature -= change
		if (actual < desired)
			temperature = desired

	return temperature

/mob/proc/gib(give_medal)
	if (istype(src, /mob/dead/observer))
		var/list/virus = src.ailments
		gibs(src.loc, virus)
		return
#ifdef DATALOGGER
	game_stats.Increment("violence")
#endif
	logTheThing("combat", src, null, "is blown apart")
	src.death(1)
	var/atom/movable/overlay/animation = null
	src.transforming = 1
	src.canmove = 0
	src.icon = null
	src.invisibility = 101

	var/bdna = null // For forensics (Convair880).
	var/btype = null

	if (ishuman(src))
		if (src.bioHolder)
			bdna = src.bioHolder.Uid // Ditto (Convair880).
			btype = src.bioHolder.bloodType

		animation = new(src.loc)
		animation.icon_state = "blank"
		animation.icon = 'icons/mob/mob.dmi'
		animation.master = src
		flick("gibbed", animation)

	if ((src.mind || src.client) && !istype(src, /mob/living/carbon/human/npc))
		var/mob/dead/observer/newmob = ghostize()
		if (!isnull(newmob) && give_medal)
			newmob.unlock_medal("Gore Fest", 1)

	var/list/viral_list = list()
	for (var/datum/ailment_data/AD in src.ailments)
		viral_list += AD

	if (!custom_gib_handler)
		if (iscarbon(src))
			var/list/ejectables = list_ejectables()
			if (bdna && btype)
				. = gibs(src.loc, viral_list, ejectables, bdna, btype) // For forensics (Convair880).
			else
				. = gibs(src.loc, viral_list, ejectables)
		else
			. = robogibs(src.loc, viral_list)
	else
		call(custom_gib_handler)(src.loc, viral_list, list_ejectables(), bdna, btype)

	for(var/obj/item/implant/I in src) qdel(I)

	if (animation)
		animation.master = null
		spawn(30)
			if (animation) qdel(animation)
	qdel(src)
	return

/mob/proc/elecgib()
	if (istype(src, /mob/dead)) return
#ifdef DATALOGGER
	game_stats.Increment("violence")
#endif
	logTheThing("combat", src, null, "is fried")
	src.death(1)
	var/atom/movable/overlay/animation = null
	src.transforming = 1
	src.canmove = 0
	src.icon = null
	src.invisibility = 101

	if (ishuman(src))
		animation = new(src.loc)
		animation.icon_state = "blank"
		animation.icon = 'icons/mob/mob.dmi'
		animation.master = src
		flick("elecgibbed", animation)

	if ((src.mind || src.client) && !istype(src, /mob/living/carbon/human/npc))
		ghostize()

	if (!iscarbon(src))
		var/list/virus = src.ailments
		robogibs(src.loc, virus)

	qdel(src)

/mob/proc/firegib()
	if (istype(src, /mob/dead)) return
#ifdef DATALOGGER
	game_stats.Increment("violence")
#endif
	logTheThing("combat", src, null, "is fried")
	src.death(1)
	var/atom/movable/overlay/animation = null
	src.transforming = 1
	src.canmove = 0
	src.icon = null
	src.invisibility = 101

	if (ishuman(src))
		animation = new(src.loc)
		animation.icon_state = "blank"
		animation.icon = 'icons/mob/mob.dmi'
		animation.master = src
		flick("firegibbed", animation)

	if ((src.mind || src.client) && !istype(src, /mob/living/carbon/human/npc))
		ghostize()

	if (!iscarbon(src))
		var/list/virus = src.ailments
		robogibs(src.loc, virus)

	qdel(src)

/mob/proc/partygib(give_medal)
	if (istype(src, /mob/dead))
		var/list/virus = src.ailments
		partygibs(src.loc, virus)
		return
#ifdef DATALOGGER
	game_stats.Increment("violence")
#endif
	src.death(1)
	var/atom/movable/overlay/animation = null
	src.transforming = 1
	src.canmove = 0
	src.icon = null
	src.invisibility = 101

	var/bdna = null // For forensics (Convair880).
	var/btype = null

	if (ishuman(src))
		if (src.bioHolder)
			bdna = src.bioHolder.Uid // Ditto (Convair880).
			btype = src.bioHolder.bloodType

		animation = new(src.loc)
		animation.icon_state = "blank"
		animation.icon = 'icons/mob/mob.dmi'
		animation.master = src
		flick("gibbed", animation)

	if ((src.mind || src.client) && !istype(src, /mob/living/carbon/human/npc))
		ghostize()

	var/list/virus = src.ailments

	if (bdna && btype)
		partygibs(src.loc, virus, bdna, btype) // For forensics (Convair880).
	else
		partygibs(src.loc, virus)

	playsound(src.loc, "sound/items/bikehorn.ogg", 100, 1)

	qdel(src)

/mob/proc/owlgib(give_medal)
	if (istype(src, /mob/dead))
		var/list/virus = src.ailments
		gibs(src.loc, virus)
		return
#ifdef DATALOGGER
	game_stats.Increment("violence")
#endif
	src.death(1)
	var/atom/movable/overlay/animation = null
	src.transforming = 1
	src.canmove = 0
	src.icon = null
	src.invisibility = 101

	var/bdna = null // For forensics (Convair880).
	var/btype = null

	if (ishuman(src))
		if (src.bioHolder)
			bdna = src.bioHolder.Uid // Ditto (Convair880).
			btype = src.bioHolder.bloodType

		animation = new(src.loc)
		animation.icon_state = "blank"
		animation.icon = 'icons/mob/mob.dmi'
		animation.master = src
		flick("owlgibbed", animation)
		var/obj/critter/owl/O = new /obj/critter/owl(src.loc)
		O.name = pick("Hooty Mc[src.real_name]", "Professor [src.real_name]", "Screechin' [src.real_name]")

	if ((src.mind || src.client) && !istype(src, /mob/living/carbon/human/npc))
		ghostize()

	var/list/virus = src.ailments

	if (bdna && btype)
		gibs(src.loc, virus, null, bdna, btype) // For forensics (Convair880).
	else
		gibs(src.loc, virus)

	playsound(src.loc, "sound/misc/hoot.ogg", 100, 1)

	qdel(src)

/mob/proc/vaporize(give_medal, forbid_abberation)
	if (istype(src, /mob/dead))
		return
#ifdef DATALOGGER
	game_stats.Increment("violence")
#endif
	src.death(1)
	var/atom/movable/overlay/animation = null
	src.transforming = 1
	src.canmove = 0
	src.icon = null
	src.invisibility = 101

	if (ishuman(src))
		animation = new(src.loc)
		animation.icon_state = "blank"
		animation.icon = 'icons/mob/mob.dmi'
		animation.master = src
		flick("disintegrated", animation)

		if (prob(20))
			new /obj/decal/cleanable/ash(src.loc)

		if (!forbid_abberation && prob(50))
			new /obj/critter/aberration(src.loc)

	else
		gibs(src.loc)

	if ((src.mind || src.client) && !istype(src, /mob/living/carbon/human/npc))
		ghostize()

	var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
	s.set_up(2, 1, src.loc)
	s.start()

	qdel(src)

/mob/proc/implode(give_medal)
	if (istype(src, /mob/dead)) return
#ifdef DATALOGGER
	game_stats.Increment("violence")
#endif
	logTheThing("combat", src, null, "implodes")
	src.death(1)
	var/atom/movable/overlay/animation = null
	src.transforming = 1
	src.canmove = 0
	src.icon = null
	src.invisibility = 101

	if (ishuman(src))
		animation = new(src.loc)
		animation.icon_state = "blank"
		animation.icon = 'icons/mob/mob.dmi'
		animation.master = src
		flick("implode", animation)

	if ((src.mind || src.client) && !istype(src, /mob/living/carbon/human/npc))
		ghostize()

	playsound(src.loc, "sound/misc/loudcrunch2.ogg", 100, 1)

	qdel(src)


/mob/proc/cluwnegib(var/duration = 30)
	if(istype(src, /mob/dead)) return
	spawn(0) //multicluwne
		duration = minmax(duration, 10, 100)

	#ifdef DATALOGGER
		game_stats.Increment("violence")
	#endif
		logTheThing("combat", src, null, "is taken by the floor cluwne")
		src.transforming = 1
		src.canmove = 0
		src.anchored = 1
		src.mouse_opacity = 0

		var/mob/living/carbon/human/cluwne/floor/floorcluwne = new(null)

		var/list/cardinals = list(NORTH, SOUTH, WEST, EAST)
		var/turf/the_turf = null
		while(!the_turf)
			if(cardinals.len)
				var/C = pick(cardinals)
				the_turf = get_step(src, C)
				if(the_turf.density)
					the_turf = null //Prefer floors
					cardinals -= C
			else
				the_turf = get_turf(src)
				break //Well, if we're at null we don't want an infinite loop

		if(!the_turf)
			src.gib()
			return
		src.show_text("<span style=\"font-weight:bold; font-style:italic; color:red; font-family:'Comic Sans MS', sans-serif; font-size:200%;\">It's coming!!!</span>")
		playsound(the_turf, 'sound/ambience/lavamoon_strange_fx1.ogg', 70, 1)
		floorcluwne.loc=the_turf //I actually do want to bypass Entered() and Exit() stuff now tyvm
		animate_slide(the_turf, 0, -24, duration)
		sleep(duration/2)
		if(!floorcluwne)
			animate_slide(the_turf, 0, 0, duration)
			src.gib()
			return
		floorcluwne.say("honk honk motherfucker")
		floorcluwne.point(src)
		sleep(duration/2)
		if(!floorcluwne)
			animate_slide(the_turf, 0, 0, duration)
			src.gib()
			return
		floorcluwne.visible_message("<span style='font-weight:bold; color:red;'>[floorcluwne] drags [src] beneath \the [the_turf]!</span>")
		playsound(floorcluwne.loc, 'sound/weapons/thudswoosh.ogg', 60, 2)
		src.set_loc(the_turf)
		src.layer=0
		animate_slide(the_turf, 0, 0, duration)
		spawn(duration+5)
			src.death(1)
			src.ghostize()
			qdel(src)
			qdel(floorcluwne)

// Man, there's a lot of possible inventory spaces to store crap. This should get everything under normal circumstances.
// Well, it's hard to account for every possible matryoshka scenario (Convair880).
/mob/proc/get_all_items_on_mob()
	if (!src || !ismob(src))
		return 0

	var/list/L = list()
	L += src.contents // Item slots.

	for (var/obj/item/storage/S in src.contents) // Backpack, belt, briefcases etc.
		var/list/T1 = S.get_all_contents()
		for (var/obj/O1 in T1)
			if (!L.Find(O1)) L.Add(O1)

	for (var/obj/item/gift/G in src.contents)
		if (!L.Find(G.gift)) L += G.gift
		if (istype(G.gift, /obj/item/storage))
			var/obj/item/storage/S2 = G.gift
			var/list/T2 = S2.get_all_contents()
			for (var/obj/O2 in T2)
				if (!L.Find(O2)) L.Add(O2)

	for (var/obj/item/storage/backpack/BP in src.contents) // Backpack boxes etc.
		for (var/obj/item/storage/S3 in BP.contents)
			var/list/T3 = S3.get_all_contents()
			for (var/obj/O3 in T3)
				if (!L.Find(O3)) L.Add(O3)

		for (var/obj/item/gift/G2 in BP.contents)
			if (!L.Find(G2.gift)) L += G2.gift
			if (istype(G2.gift, /obj/item/storage))
				var/obj/item/storage/S4 = G2.gift
				var/list/T4 = S4.get_all_contents()
				for (var/obj/O4 in T4)
					if (!L.Find(O4)) L.Add(O4)

	for (var/obj/item/storage/belt/BL in src.contents) // Stealth storage in belts etc.
		for (var/obj/item/storage/S5 in BL.contents)
			var/list/T5 = S5.get_all_contents()
			for (var/obj/O5 in T5)
				if (!L.Find(O5)) L.Add(O5)

		for (var/obj/item/gift/G3 in BL.contents)
			if (!L.Find(G3.gift)) L += G3.gift
			if (istype(G3.gift, /obj/item/storage))
				var/obj/item/storage/S6 = G3.gift
				var/list/T6 = S6.get_all_contents()
				for (var/obj/O6 in T6)
					if (!L.Find(O6)) L.Add(O6)

	for (var/obj/item/storage/box/syndibox/SB in L) // For those "belt-in-stealth storage-in-backpack" situations.
		for (var/obj/item/storage/S7 in SB.contents)
			var/list/T7 = S7.get_all_contents()
			for (var/obj/O7 in T7)
				if (!L.Find(O7)) L.Add(O7)

		for (var/obj/item/gift/G4 in SB.contents)
			if (!L.Find(G4.gift)) L += G4.gift
			if (istype(G4.gift, /obj/item/storage))
				var/obj/item/storage/S8 = G4.gift
				var/list/T8 = S8.get_all_contents()
				for (var/obj/O8 in T8)
					if (!L.Find(O8)) L.Add(O8)

	return L

// Made these three procs use get_all_items_on_mob(). "Steal X" objective should work more reliably as a result (Convair880).
/mob/proc/check_contents_for(A, var/accept_subtypes = 0)
	if (!src || !ismob(src) || !A)
		return 0

	var/list/L = src.get_all_items_on_mob()
	if (L && L.len)
		for (var/obj/B in L)
			if (B.type == A || (accept_subtypes && istype(B, A)))
				return 1
	return 0

/mob/proc/check_contents_for_num(A, X, var/accept_subtypes = 0)
	if (!src || !ismob(src) || !A)
		return 0

	var/tally = 0
	var/list/L = src.get_all_items_on_mob()
	if (L && L.len)
		for (var/obj/B in L)
			if (B.type == A || (accept_subtypes && istype(B, A)))
				tally++

	if (tally >= X)
		return 1

	return 0

#define REFRESH "* Refresh list"
/mob/proc/print_contents(var/mob/output_target)
	if (!src || !ismob(src) || !output_target || !ismob(output_target))
		return

	var/list/L = src.get_all_items_on_mob()
	if (L && L.len)
		var/list/OL = list() // Sorted output list. Could definitely be improved, but is functional enough.
		var/list/O_names = list()
		var/list/O_namecount = list()

		OL.Add(REFRESH)

		for (var/obj/O in L)
			if (!OL.Find(O))
				var/N = O.name
				var/N2
				if (O.loc == src)
					N2 = "mob"
				else
					N2 = O.loc.name

				if (N in O_names)
					O_namecount[N]++
					N = text("[] #[]", N, O_namecount[N])
				else
					O_names.Add(N)
					O_namecount[N] = 1

				var/N3 = "[N2]: [N]"
				OL[N3] = O

		OL = sortList(OL)

		selection
		var/IP = input(output_target, "Select item to view fingerprints, cancel to close window.", "[src]'s inventory") as null|anything in OL

		if (!IP || !output_target || !ismob(output_target))
			return

		if (!src || !ismob(src))
			output_target.show_text("Target mob doesn't exist anymore.", "red")
			return

		if (IP == REFRESH)
			src.print_contents(output_target)
			return

		if (isnull(OL[IP]) || !isobj(OL[IP]))
			output_target.show_text("Selected object reference is invalid (item deleted?). Try freshing the list.", "red")
			goto selection

		if (output_target.client)
			output_target.client.view_fingerprints(OL[IP])
			goto selection

	return
#undef REFRESH

// adds a dizziness amount to a mob
// use this rather than directly changing var/dizziness
// since this ensures that the dizzy_process proc is started
// currently only humans get dizzy

// value of dizziness ranges from 0 to 500
// below 100 is not dizzy

/mob/proc/make_dizzy(var/amount)
	if (!istype(src, /mob/living/carbon/human)) // for the moment, only humans get dizzy
		return

	dizziness = min(500, dizziness + amount)	// store what will be new value
													// clamped to max 500
	if (dizziness > 100 && !is_dizzy)
		spawn(0)
			dizzy_process()


// dizzy process - wiggles the client's pixel offset over time
// spawned from make_dizzy(), will terminate automatically when dizziness gets <100
// note dizziness decrements automatically in the mob's Life() proc.
/mob/proc/dizzy_process()
	is_dizzy = 1
	while(dizziness > 100)
		if (client)
			var/amplitude = dizziness*(sin(dizziness * 0.044 * world.time) + 1) / 70
			client.pixel_x = amplitude * sin(0.008 * dizziness * world.time)
			client.pixel_y = amplitude * cos(0.008 * dizziness * world.time)

		sleep(1)
	//endwhile - reset the pixel offsets to zero
	is_dizzy = 0
	if (client)
		client.pixel_x = 0
		client.pixel_y = 0

// jitteriness - copy+paste of dizziness

/mob/proc/make_jittery(var/amount)
	if (!istype(src, /mob/living/carbon/human)) // for the moment, only humans get dizzy
		return

	jitteriness = min(500, jitteriness + amount)	// store what will be new value
													// clamped to max 500
	if (jitteriness > 100 && !is_jittery)
		spawn(0)
			jittery_process()


// jittery process - shakes the mob's pixel offset randomly
// will terminate automatically when dizziness gets <100
// jitteriness decrements automatically in the mob's Life() proc.
/mob/proc/jittery_process()
	var/old_x = pixel_x
	var/old_y = pixel_y
	is_jittery = 1
	while(jitteriness > 100)
//		var/amplitude = jitteriness*(sin(jitteriness * 0.044 * world.time) + 1) / 70
//		pixel_x = amplitude * sin(0.008 * jitteriness * world.time)
//		pixel_y = amplitude * cos(0.008 * jitteriness * world.time)

		var/amplitude = min(4, jitteriness / 100)
		pixel_x = old_x + rand(-amplitude, amplitude)
		pixel_y = old_y + rand(-amplitude/3, amplitude/3)

		sleep(1)
	//endwhile - reset the pixel offsets to zero
	is_jittery = 0
	pixel_x = old_x
	pixel_y = old_y

/mob/Stat()
	..()

	if (src.abilityHolder && !src.abilityHolder.topBarRendered)
		abilityHolder.StatAbilities()

	statpanel("Status")
	if (client.statpanel == "Status")
		if (ticker)
			if ((!src.client.holder) && (ticker.hide_mode || master_mode == "wizard"))
				stat("Game Mode:", "secret")
			else
				stat("Game Mode:", "[(client.holder && ticker.hide_mode) ? "[master_mode] **HIDDEN**" : "[master_mode]"]")

			if (ticker.current_state == GAME_STATE_PREGAME)
				var/timeLeftColor
				switch (ticker.pregame_timeleft)
					if (120 to 999)
						timeLeftColor = "green"
					if (60 to 120)
						timeLeftColor = "#ffb400"
					if (0 to 60)
						timeLeftColor = "red"
				stat("Time To Start:", "<span style='color: [timeLeftColor];'>[ticker.pregame_timeleft]</span>")
				stat(null, " ")

		if (src.client.holder)
			if (!istype(src.loc, /turf) && !isnull(loc))
				stat("Co-ordinates:", "([loc.x], [loc.y], [loc.z])")
			else
				stat("Co-ordinates:", "([x], [y], [z])")

			stat("Server Load:", "[world.cpu] ([lag_string])")
		else
			stat("Server Load:", lag_string) //Yes very useful a++

		if (ticker && ticker.round_elapsed_ticks)
			stat(null, " ")
			var/shiftTime = round(ticker.round_elapsed_ticks / 600)
			stat("Shift Time:", "[shiftTime] minute[shiftTime == 1 ? "" : "s"]")
			if (ticker.mode && istype(ticker.mode, /datum/game_mode/construction))
				stat(null, " ")
				var/datum/game_mode/construction/C = ticker.mode
				stat("Construction time left:", C.human_time_left)
				var/datum/construction_controller/E = C.events
				if (E.event_delay)
					if (E.current_event)
						stat("Event in progress:", E.current_event.name)
					else
						stat("Event cycle starts in:", dstohms(E.event_delay - ticker.round_elapsed_ticks))
				else if (E.choose_at)
					stat("Next event type:", E.next_event_type)
					stat("Estimated event ETA:", dstohms(E.next_event_at - ticker.round_elapsed_ticks))
				else if (E.next_event_at)
					stat("Next event type:", E.next_event_type)
					stat("Event ETA:", dstohms(E.next_event_at - ticker.round_elapsed_ticks))
				stat(null, " ")
	#ifdef XMAS
			stat("Christmas Cheer:", "[christmas_cheer]%")
	#endif
		if (emergency_shuttle && emergency_shuttle.online && emergency_shuttle.location < 2)
			var/timeleft = emergency_shuttle.timeleft()
			if (timeleft)
				stat("Shuttle ETA:", "[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]")
				stat(null, " ")

	if (abilityHolder)
		abilityHolder.Stat()

	if (is_near_gauntlet())
		gauntlet_controller.Stat()

	if (is_near_colosseum())
		colosseum_controller.Stat()


/mob/onVarChanged(variable, oldval, newval)
	update_clothing()

/mob/proc/say()
	return

/mob/verb/whisper()
	return

/mob/verb/say_verb(message as text)
	set name = "say"
	if (src.client && !src.client.holder && url_regex && url_regex.Find(message))
		boutput(src, "<span style=\"color:blue\"><b>Web/BYOND links are not allowed in ingame chat.</b></span>")
		boutput(src, "<span style=\"color:red\">&emsp;<b>\"[message]</b>\"</span>")
		return

	usr.say(message)
	if (!dd_hasprefix(message, "*")) // if this is an emote it is logged in emote
		logTheThing("say", src, null, "SAY: [message]")

// ghosts now can emote now too so vOv
/*	if (istype(src,/mob/living/))
		if (copytext(message, 1, 2) != "*") // if this is an emote it is logged in emote
			logTheThing("say", src, null, "SAY: [message]")
	else logTheThing("say", src, null, "SAY: [message]")
*/
/mob/verb/me_verb(message as text)
	set name = "me"

	if (src.client && !src.client.holder && url_regex && url_regex.Find(message))
		boutput(src, "<span style=\"color:blue\"><b>Web/BYOND links are not allowed in ingame chat.</b></span>")
		boutput(src, "<span style=\"color:red\">&emsp;<b>\"[message]</b>\"</span>")
		return

	src.emote(message, 1)
/* ghost emotes wooo also the logging is already taken care of in the emote() procs vOv
	if (istype(src,/mob/living/) && src.stat == 0)
		src.emote(message, 1)
		logTheThing("say", src, null, "EMOTE: [message]")
	else
		boutput(src, "<span style=\"color:blue\">You can't emote when you're dead! How would that even work!?</span>")
*/
/mob/proc/say_dead(var/message, wraith = 0)
	var/name = src.real_name
	var/alt_name = ""

	if (!deadchat_allowed)
		boutput(usr, "<b>Deadchat is currently disabled.</b>")
		return

	message = trim(copytext(html_encode(sanitize(message)), 1, MAX_MESSAGE_LEN))
	if (!message)
		return

	if (ishuman(src) && src.name != src.real_name)
		if (src:wear_id && src:wear_id:registered && src:wear_id:registered != src.real_name)
			alt_name = " (as [src:wear_id:registered])"
		else if (!src:wear_id)
			alt_name = " (as Unknown)"

	else if (istype(src, /mob/dead))
		name = "Ghost"
		alt_name = " ([src.real_name])"
	else if (istype(src, /mob/wraith))
		name = "Wraith"
		alt_name = " ([src.real_name])"

	else if (!istype(src, /mob/living/carbon/human))
		name = src.name

#ifdef DATALOGGER
	game_stats.ScanText(message)
#endif

	message = src.say_quote(message)
	//logTheThing("say", src, null, "SAY: [message]")

	var/rendered = "<span class='game deadsay'><span class='prefix'>DEAD:</span> <span class='name' data-ctx='\ref[src.mind]'>[name]<span class='text-normal'>[alt_name]</span></span> <span class='message'>[message]</span></span>"

	for (var/mob/M in mobs)
		if (istype(M, /mob/new_player))
			continue
		if (M.client && M.client.deadchatoff)
			continue
		//admins can toggle deadchat on and off. This is a proc in admin.dm and is only give to Administrators and above
		if (M.stat == 2 || istype(M, /mob/wraith) || (M.client && M.client.holder && M.client.deadchat && !M.client.player_mode))
			var/thisR = rendered
			if (M.client && M.client.holder && src.mind)
				thisR = "<span class='adminHearing' data-ctx='[M.client.chatOutput.ctxFlag]'>[rendered]</span>"
			boutput(M, thisR)


/mob/proc/say_understands(var/mob/other, var/forced_language)
	if (src.stat == 2)
		return 1
//	else if (istype(other, src.type) || istype(src, other.type))
//		return 1
	var/L = other.say_language
	if (forced_language)
		L = forced_language
	if (understands_language(L))
		return 1
	return 0
	/*if (isrobot(other) || isAI(other) || (ismonkey(other) && src.bioHolder.HasEffect("monkey_speak")))
		return 1
	else
		. = 0
		. += ismonkey(src) ? 1 : 0
		. += ismonkey(other) ? 1 : 0
		if (. == 1)
			return monkeysspeakhuman
		else
			return 1
	return 0*/

/mob/proc/say_quote(var/text)
	var/ending = copytext(text, length(text))
	var/speechverb = speechverb_say
	var/loudness = 0
	var/font_accent = null

	if (ending == "?")
		speechverb = speechverb_ask
	else if (ending == "!")
		speechverb = speechverb_exclaim
	if (src.stuttering)
		speechverb = speechverb_stammer
	for (var/datum/ailment_data/A in src.ailments)
		if (istype(A.master, /datum/ailment/disease/berserker))
			if (A.stage > 1)
				speechverb = "roars"
	if ((src.reagents && src.reagents.get_reagent_amount("ethanol") > 30))
		speechverb = "slurs"
	if (src.bioHolder)
		if (src.bioHolder.HasEffect("loud_voice"))
			speechverb = "bellows"
			loudness += 1
		if (src.bioHolder.HasEffect("quiet_voice"))
			speechverb = "murmurs"
			loudness -= 1
		if (src.bioHolder.HasEffect("unintelligable"))
			speechverb = "splutters"
		if (src.bioHolder.HasEffect("accent_comic"))
			font_accent = "Comic Sans MS"

		if (src.bioHolder && src.bioHolder.genetic_stability < 50)
			speechverb = "gurgles"

	if (src.get_brain_damage() >= 60)
		speechverb = "gibbers"

	if (src.health <= 20)
		speechverb = speechverb_gasp
	if (src.stat == 2 || isobserver(src))
		speechverb = pick("moans","wails","laments")
		if (prob(5))
			speechverb = "grumps"

	if (text == "" || !text)
		return speechverb

	if (loudness > 0)
		return "[speechverb], \"[font_accent ? "<font face='[font_accent]'>" : null]<big><strong><b>[text]</b></strong></big>[font_accent ? "</font>" : null]\""
	else if (loudness < 0)
		return "[speechverb], \"[font_accent ? "<font face='[font_accent]'>" : null]<small>[text]</small>[font_accent ? "</font>" : null]\""
	else
		return "[speechverb], \"[font_accent ? "<font face='[font_accent]'>" : null][text][font_accent ? "</font>" : null]\""

/mob/proc/emote(var/act, var/voluntary = 0)
	return

/mob/proc/emote_check(var/voluntary = 1, var/time = 10, var/admin_bypass = 1, var/dead_check = 1)
	if (src.emote_allowed)
		if (dead_check && src.stat == 2)
			src.emote_allowed = 0
			return 0
		if (world.time >= (src.last_emote_time + src.last_emote_wait))
			if (!(src.client && (src.client.holder && admin_bypass)) && voluntary)
				src.emote_allowed = 0
				src.last_emote_time = world.time
				src.last_emote_wait = time
				spawn(time)
					src.emote_allowed = 1
			return 1
		else
			return 0
	else
		return 0

/mob/living/carbon/human/proc/JobEquipSpawned(rank)
	var/datum/job/JOB = find_job_in_controller_by_string(rank)
	if (!JOB)
		boutput(src, "<span style=\"color:red\"><b>UH OH, the game couldn't find your job to set it up! Report this to a coder.</b></span>")
		return

	if (JOB.slot_back)
		src.equip_if_possible(new JOB.slot_back(src), slot_back)
	if (JOB.slot_back && JOB.items_in_backpack.len)
		for (var/X in JOB.items_in_backpack)
			src.equip_if_possible(new X(src), slot_in_backpack)
	if (JOB.slot_jump)
		src.equip_if_possible(new JOB.slot_jump(src), slot_w_uniform)
	if (JOB.slot_belt)
		src.equip_if_possible(new JOB.slot_belt(src), slot_belt)
	if (JOB.slot_foot)
		src.equip_if_possible(new JOB.slot_foot(src), slot_shoes)
	if (JOB.slot_suit)
		src.equip_if_possible(new JOB.slot_suit(src), slot_wear_suit)
	if (JOB.slot_ears)
		src.equip_if_possible(new JOB.slot_ears(src), slot_ears)
	if (JOB.slot_mask)
		src.equip_if_possible(new JOB.slot_mask(src), slot_wear_mask)
	if (JOB.slot_glov)
		src.equip_if_possible(new JOB.slot_glov(src), slot_gloves)
	if (JOB.slot_eyes)
		src.equip_if_possible(new JOB.slot_eyes(src), slot_glasses)
	if (JOB.slot_head)
		src.equip_if_possible(new JOB.slot_head(src), slot_head)
	if (JOB.slot_poc1)
		src.equip_if_possible(new JOB.slot_poc1(src), slot_l_store)
	if (JOB.slot_poc2)
		src.equip_if_possible(new JOB.slot_poc2(src), slot_r_store)
	if (JOB.slot_rhan)
		src.equip_if_possible(new JOB.slot_rhan(src), slot_r_hand)
	if (JOB.slot_lhan)
		src.equip_if_possible(new JOB.slot_lhan(src), slot_l_hand)

	JOB.special_setup(src)

	update_clothing()

	return

/mob/proc/hit_twitch()
	if (twitching)
		return

	twitching = 1
	var/which
	if (usr)
		which = get_dir(usr,src)
	else
		which = pick(alldirs)
	spawn(1)
		var/ipx = src.pixel_x
		var/ipy = src.pixel_y
		switch(which)
			if (NORTHEAST)       animate(src, pixel_x = ipx + 2, pixel_y = ipy + 2, time = 2,easing = EASE_OUT)
			if (NORTH)           animate(src, pixel_x = ipx + 0, pixel_y = ipy + 3, time = 2,easing = EASE_OUT)
			if (NORTHWEST)       animate(src, pixel_x = ipx - 2, pixel_y = ipy + 2, time = 2,easing = EASE_OUT)
			if (WEST)            animate(src, pixel_x = ipx - 3, pixel_y = ipy + 0, time = 2,easing = EASE_OUT)
			if (SOUTHWEST)       animate(src, pixel_x = ipx - 2, pixel_y = ipy - 2, time = 2,easing = EASE_OUT)
			if (SOUTH)           animate(src, pixel_x = ipx + 0, pixel_y = ipy - 3, time = 2,easing = EASE_OUT)
			if (SOUTHEAST)       animate(src, pixel_x = ipx + 2, pixel_y = ipy - 2, time = 2,easing = EASE_OUT)
			if (EAST)            animate(src, pixel_x = ipx + 3, pixel_y = ipy + 0, time = 2,easing = EASE_OUT)
			else
				return
		animate(pixel_x = ipx, pixel_y = ipy, time = 2,easing = EASE_IN)
		sleep(4)
		twitching = 0

/mob/attackby(obj/item/W as obj, mob/user as mob)
	actions.interrupt(src, INTERRUPT_ATTACKED)

	// why is this not in human/attackby?
	if (W.arm_icon && ishuman(src) && (user.zone_sel && user.zone_sel.selecting in list("l_arm","r_arm")) && ((locate(/obj/machinery/optable, src.loc) && src.lying) || (locate(/obj/table, src.loc) && (src.paralysis || src.stat)) || (src.reagents && src.reagents.get_reagent_amount("ethanol") > 100 && src == user)))
		var/mob/living/carbon/human/H = src

		if (!H.limbs.vars[user.zone_sel.selecting])
			W.attach(src,user)
			return

	var/shielded = 0
	if (src.spellshield)
		shielded = 1
		boutput(user, "<span style=\"color:red\"><b>[src]'s Spell Shield prevents your attack!</b></span>")
	else
		if (!src.spellshield)
			for(var/obj/item/device/shield/S in src)
				if (S.active)
					shielded = 1
				else
	if (locate(/obj/item/grab, src))
		var/mob/safe = null
		if (istype(src.l_hand, /obj/item/grab))
			var/obj/item/grab/G = src.l_hand
			if ((G.state == 2 && get_dir(src, user) == src.dir))
				safe = G.affecting
		if (istype(src.r_hand, /obj/item/grab))
			var/obj/item/grab/G = src.r_hand
			if ((G.state == 2 && get_dir(src, user) == src.dir))
				safe = G.affecting
		if (safe)
			return safe.attackby(W, user)
	if ((!( shielded ) || !( W.flags ) & 32))
		spawn( 0 )
		// drsingh Cannot read null.force
#ifdef DATALOGGER
			if (!isnull(W) && W.force)
				game_stats.Increment("violence")
#endif
			if (!isnull(W))
				W.attack(src, user)
				if(W && W.force) //Wire: Fix for Cannot read null.force
					message_admin_on_attack(user, "uses \a [W.name] on")
			return
	return

/mob/proc/throw_impacted() //Called when mob hits something after being thrown.

	if (throw_count <= 410)
		random_brute_damage(src, min((6 + (throw_count / 5)), (src.health - 5) < 0 ? src.health : (src.health - 5)))
		src:weakened += 2
	else
		if (src.gib_flag) return
		src.gib_flag = 1
		src.gib()

	src.throw_count = 0

	return

/mob/verb/listen_ooc()
	set name = "(Un)Mute OOC"

	if (src.client)
		src.client.preferences.listen_ooc = !src.client.preferences.listen_ooc
		if (src.client.preferences.listen_ooc)
			boutput(src, "<span style=\"color:blue\">You are now listening to messages on the OOC channel.</span>")
		else
			boutput(src, "<span style=\"color:blue\">You are no longer listening to messages on the OOC channel.</span>")

/mob/verb/ooc(msg as text)
	if (IsGuestKey(src.key))
		boutput(src, "You are not authorized to communicate over these channels.")
		return
	if (oocban_isbanned(src))
		boutput(src, "You are currently banned from using OOC and LOOC, you may appeal at http://forum.ss13.co/index.php")
		return

	msg = trim(copytext(html_encode(sanitize(msg)), 1, MAX_MESSAGE_LEN))
	if (!msg)
		return
	else if (!src.client.preferences.listen_ooc)
		return
	else if (!ooc_allowed && !src.client.holder)
		boutput(usr, "OOC is currently disabled.")
		return
	else if (!dooc_allowed && !src.client.holder && (src.client.deadchat != 0))
		boutput(usr, "OOC for dead mobs has been turned off.")
		return
	else if (src.client && src.client.ismuted())
		boutput(usr, "You are currently muted and cannot talk in OOC.")
		return
	else if (findtext(msg, "byond://") && !src.client.holder)
		boutput(src, "<B>Advertising other servers is not allowed.</B>")
		logTheThing("admin", src, null, "has attempted to advertise in OOC.")
		logTheThing("diary", src, null, "has attempted to advertise in OOC.", "admin")
		message_admins("[key_name(src)] has attempted to advertise in OOC.")
		return

	logTheThing("diary", src, null, ": [msg]", "ooc")

#ifdef DATALOGGER
	game_stats.ScanText(msg)
#endif

	for (var/client/C)
		// DEBUGGING
		if (!C.preferences)
			logTheThing("debug", null, null, "[C] (\ref[C]): client.preferences is null")

		if (C.preferences && !C.preferences.listen_ooc)
			continue

		var ooc_class = ""
		var display_name = src.key

		if (src.client.stealth || src.client.alt_key)
			if (!C.holder)
				display_name = src.client.fakekey
			else
				display_name += " (as [src.client.fakekey])"

		if (src.client.holder && (!src.client.stealth || C.holder))
			if (src.client.holder.level == LEVEL_BABBY)
				ooc_class = "gfartooc"
			else
				ooc_class = "adminooc"
		else if (src.client.mentor)
			ooc_class = "mentorooc"

		var/rendered = "<span class=\"ooc [ooc_class]\"><span class=\"prefix\">OOC:</span> <span class=\"name\" data-ctx='\ref[src.mind]'>[display_name]:</span> <span class=\"message\">[msg]</span></span>"

		if (C.holder)
			rendered = "<span class='adminHearing' data-ctx='[C.chatOutput.ctxFlag]'>[rendered]</span>"

		boutput(C, rendered)

	logTheThing("ooc", src, null, "OOC: [msg]")

/mob/verb/listen_looc()
	set name = "(Un)Mute LOOC"

	if (src.client)
		src.client.preferences.listen_looc = !src.client.preferences.listen_looc
		if (src.client.preferences.listen_looc)
			boutput(src, "<span style=\"color:blue\">You are now listening to messages on the LOOC channel.</span>")
		else
			boutput(src, "<span style=\"color:blue\">You are no longer listening to messages on the LOOC channel.</span>")

/mob/verb/looc(msg as text)
	if (IsGuestKey(src.key))
		boutput(src, "You are not authorized to communicate over these channels.")
		return
	if (oocban_isbanned(src))
		boutput(src, "You are currently banned from using OOC and LOOC, you may appeal at http://forum.ss13.co/index.php")
		return

	msg = trim(copytext(html_encode(sanitize(msg)), 1, MAX_MESSAGE_LEN))
	if (!msg)
		return
	else if (!src.client.preferences.listen_looc)
		return
	else if (!looc_allowed && !src.client.holder)
		boutput(usr, "LOOC is currently disabled.")
		return
	else if (!dooc_allowed && !src.client.holder && (src.client.deadchat != 0))
		boutput(usr, "LOOC for dead mobs has been turned off.")
		return
	else if (src.client && src.client.ismuted())
		boutput(usr, "You are currently muted and cannot talk in LOOC.")
		return
	else if (findtext(msg, "byond://") && !src.client.holder)
		boutput(src, "<B>Advertising other servers is not allowed.</B>")
		logTheThing("admin", src, null, "has attempted to advertise in LOOC.")
		logTheThing("diary", src, null, "has attempted to advertise in LOOC.", "admin")
		message_admins("[key_name(src)] has attempted to advertise in LOOC.")
		return

	logTheThing("diary", src, null, ": [msg]", "ooc")

#ifdef DATALOGGER
	game_stats.ScanText(msg)
#endif

	var/list/recipients = list()

	for (var/mob/M in range(LOOC_RANGE))
		if (!M.client)
			continue
		if (M.client.preferences && !M.client.preferences.listen_looc)
			continue
		recipients += M.client

	for (var/mob/M in mobs)
		if (!M.client)
			continue
		if (recipients.Find(M.client))
			continue
		if (M.client.holder && !M.client.only_local_looc && !M.client.player_mode)
			recipients += M.client

	for (var/client/C in recipients)
		// DEBUGGING
		if (!C.preferences)
			logTheThing("debug", null, null, "[C] (\ref[C]): client.preferences is null")

		if (C.preferences && !C.preferences.listen_ooc)
			continue

		var looc_class = ""
		var display_name = src.key

		if (src.client.stealth || src.client.alt_key)
			if (!C.holder)
				display_name = src.client.fakekey
			else
				display_name += " (as [src.client.fakekey])"

		if (src.client.holder && (!src.client.stealth || C.holder))
			if (src.client.holder.level == LEVEL_BABBY)
				looc_class = "gfartlooc"
			else
				looc_class = "adminlooc"
		else if (src.client.mentor)
			looc_class = "mentorlooc"

		var/rendered = "<span class=\"looc [looc_class]\"><span class=\"prefix\">LOOC:</span> <span class=\"name\" data-ctx='\ref[src.mind]'>[display_name]:</span> <span class=\"message\">[msg]</span></span>"

		if (C.holder)
			rendered = "<span class='adminHearing' data-ctx='[C.chatOutput.ctxFlag]'>[rendered]</span>"

		boutput(C, rendered)

	logTheThing("ooc", src, null, "LOOC: [msg]")

/mob/proc/full_heal()
	src.HealDamage("All", 10000, 10000)
	src.drowsyness = 0
	src.stuttering = 0
	src.losebreath = 0
	src.paralysis = 0
	src.stunned = 0
	src.weakened = 0
	src.slowed = 0
	src.radiation = 0
	src.change_eye_blurry(-INFINITY)
	src.take_eye_damage(-INFINITY)
	src.take_eye_damage(-INFINITY, 1)
	src.take_ear_damage(-INFINITY)
	src.take_ear_damage(-INFINITY, 1)
	src.take_brain_damage(-120)
	src.health = src.max_health
	src.buckled = initial(src.buckled)
	src.handcuffed = initial(src.handcuffed)
	src.bodytemperature = src.base_body_temp
	if (src.stat > 1)
		src.stat = 0
	src.updatehealth()

/mob/proc/infected(var/datum/pathogen/P)
	return

/mob/proc/remission(var/datum/pathogen/P)
	return

/mob/proc/immunity(var/datum/pathogen/P)
	return

/mob/proc/cured(var/datum/pathogen/P)
	return

/mob/proc/shock(var/atom/origin, var/wattage, var/zone, var/stun_multiplier = 1, var/ignore_gloves = 0)
	return 0

/mob/proc/flash(duration)
	return 0

/mob/proc/take_brain_damage(var/amount)
	if (!isnum(amount) || amount == 0)
		return 1
	return 0

/mob/proc/take_toxin_damage(var/amount)
	if (!isnum(amount) || amount == 0)
		return 1
	return 0

/mob/proc/take_oxygen_deprivation(var/amount)
	if (!isnum(amount) || amount == 0)
		return 1
	return 0

/mob/proc/get_eye_damage(var/tempblind = 0)
	if (tempblind == 0)
		return src.eye_damage
	else
		return src.eye_blind

/mob/proc/take_eye_damage(var/amount, var/tempblind = 0)
	//Shamefully stolen from the welder
	// and then from a different proc, to bring this in line with the other damage procs
	//
	// Then I came along and integrated eye_blind handling (Convair880).

	if (!src || !ismob(src) || (!isnum(amount) || amount == 0))
		return 0

	var/eyeblind = 0
	if (tempblind == 0)
		src.eye_damage = max(0, src.eye_damage + amount)
	else
		eyeblind = amount

	// Modify eye_damage or eye_blind if prompted, but don't perform more than we absolutely have to.
	var/blind_bypass = 0
	if (src.bioHolder && src.bioHolder.HasEffect("blind"))
		blind_bypass = 1

	if (amount > 0 && tempblind == 0 && blind_bypass == 0) // so we don't enter the damage switch thing if we're healing damage
		switch (src.eye_damage)
			if (10 to 12)
				src.change_eye_blurry(rand(3,6))

			if (12 to 15)
				src.show_text("Your eyes hurt.", "red")
				src.change_eye_blurry(rand(6,9))

			if (15 to 25)
				src.show_text("Your eyes are really starting to hurt.", "red")
				src.change_eye_blurry(rand(12,16))

				if (prob(src.eye_damage - 15 + 1))
					src.show_text("Your eyes are badly damaged!", "red")
					eyeblind = 5
					src.change_eye_blurry(5)
					src.bioHolder.AddEffect("bad_eyesight")
					spawn(100)
						src.bioHolder.RemoveEffect("bad_eyesight")

			if (25 to INFINITY)
				src.show_text("<B>Your eyes hurt something fierce!</B>", "red")

				if (prob(src.eye_damage - 25 + 1))
					src.show_text("<b>You go blind!</b>", "red")
					src.bioHolder.AddEffect("blind")
				else
					src.change_eye_blurry(rand(12,16))

	if (eyeblind != 0)
		src.eye_blind = max(0, src.eye_blind + eyeblind)

	//DEBUG("Eye damage applied: [amount]. Tempblind: [tempblind == 0 ? "N" : "Y"]")
	return 1

/mob/proc/get_eye_blurry()
	return src.eye_blurry

// Why not, I suppose. Wraps up the three major eye-related mob vars (Convair880).
/mob/proc/change_eye_blurry(var/amount, var/cap = 0)
	if (!src || !ismob(src) || (!isnum(amount) || amount == 0))
		return 0

	var/upper_cap_default = 150
	var/upper_cap = upper_cap_default
	if (cap && isnum(cap) && (cap > 0 && cap < upper_cap_default))
		if (src.get_eye_blurry() >= cap)
			return
		else
			upper_cap = cap

	src.eye_blurry = max(0, min(src.eye_blurry + amount, upper_cap))
	//DEBUG("Amount is [amount], new eye blurry is [src.eye_blurry], cap is [upper_cap]")
	return 1

/mob/proc/get_ear_damage(var/tempdeaf = 0)
	if (tempdeaf == 0)
		return src.ear_damage
	else
		return src.ear_deaf

// And here's the missing one for ear damage too (Convair880).
/mob/proc/take_ear_damage(var/amount, var/tempdeaf = 0)
	if (!src || !ismob(src) || (!isnum(amount) || amount == 0))
		return 0

	var/eardeaf = 0
	if (tempdeaf == 0)
		src.ear_damage = max(0, src.ear_damage + amount)
	else
		eardeaf = amount

	// Modify ear_damage or ear_deaf if prompted, but don't perform more than we absolutely have to.
	var/deaf_bypass = 0
	if (src.bioHolder && src.bioHolder.HasEffect("deaf"))
		deaf_bypass = 1

	if (amount > 0 && tempdeaf == 0 && deaf_bypass == 0)
		switch (src.ear_damage)
			if (10 to 12)
				eardeaf += 1

			if (13 to 15)
				boutput(src, "<span style=\"color:red\">Your ears ring a bit!</span>")
				eardeaf += rand(2, 3)

			if (15 to 24)
				boutput(src, "<span style=\"color:red\">Your ears are really starting to hurt!</span>")
				eardeaf += src.ear_damage * 0.5

			if (25 to INFINITY)
				boutput(src, "<span style=\"color:red\"><b>Your ears ring very badly!</b></span>")

				if (src.bioHolder && prob(src.ear_damage - 10 + 5))
					src.show_text("<b>You go deaf!</b>", "red")
					src.bioHolder.AddEffect("deaf")
				else
					eardeaf += src.ear_damage * 0.75

	if (eardeaf != 0)
		var/suppress_message = 0
		if (!src.get_ear_damage(1) && eardeaf < 0) // We don't have any temporary deafness to begin with and are told to heal it.
			suppress_message = 1
		if (src.get_ear_damage(1) && (src.get_ear_damage(1) + eardeaf) > 0) // We already have temporary deafness and are adding to it.
			suppress_message = 1

		src.ear_deaf = max(0, src.ear_deaf + eardeaf)

		if (src.ear_deaf == 0 && deaf_bypass == 0 && suppress_message == 0)
			boutput(src, "<span style=\"color:blue\">The ringing in your ears subsides enough to let you hear again.</span>")
		else if (eardeaf > 0 && deaf_bypass == 0 && suppress_message == 0)
			boutput(src, "<span style=\"color:red\">The ringing overpowers your ability to hear momentarily.</span>")

	//DEBUG("Ear damage applied: [amount]. Tempdeaf: [tempdeaf == 0 ? "N" : "Y"]")
	return 1

// No natural healing can occur if ear damage is above this threshold. Didn't want to make it yet another mob parent var.
/mob/proc/get_ear_damage_natural_healing_threshold()
	return max(0, src.max_health / 4)

/mob/proc/lose_breath(var/amount)
	if (!isnum(amount) || amount == 0)
		return 1
	return 0

/mob/proc/change_misstep_chance(var/amount)
	if (!isnum(amount) || amount == 0)
		return 1
	return 0

/mob/proc/get_brain_damage()
	return 0

/mob/proc/get_brute_damage()
	return 0

/mob/proc/get_burn_damage()
	return 0

/mob/proc/get_toxin_damage()
	return 0

/mob/proc/get_oxygen_deprivation()
	return 0

/mob/proc/get_radiation()
	return radiation

/mob/proc/hotkey(var/key)
	if (isobj(src.loc))
		var/obj/O = src.loc
		O.hotkey(src, key)

/mob/UpdateName()
	if (src.real_name)
		src.name = "[name_prefix(null, 1)][src.real_name][name_suffix(null, 1)]"
	else
		src.name = "[name_prefix(null, 1)][initial(src.name)][name_suffix(null, 1)]"

/mob/proc/protected_from_space()
	return 0

/mob/proc/list_ejectables()
	return list()

/mob/proc/get_valid_target_zones()
	return list()


/mob/proc/message_admin_on_attack(var/mob/attacker, var/attack_type = "attacks")
	//Due to how attacking is set up we will need
	if(!attacker.attack_alert || !src.key || attacker == src || src.stat == 2) return //Only send the alert if we're hitting an actual, living person who isn't ourselves

	message_attack("[key_name(attacker)] [attack_type] [key_name(src)] shortly after spawning!")

/mob/proc/temporary_attack_alert(var/time = 600)
	//Only start the clock if there's time and we're not already alerting about attacks
	if(attack_alert || !time) return

	attack_alert = 1
	spawn(time) attack_alert = 0

/mob/proc/heard_say(var/mob/other)
	return

/mob/proc/add_ability_holder(holder_type)
	if (abilityHolder && istype(abilityHolder, /datum/abilityHolder/composite))
		var/datum/abilityHolder/composite/C = abilityHolder
		C.addHolder(holder_type)
		return C.getHolder(holder_type)
	else if (abilityHolder)
		var/datum/abilityHolder/T = abilityHolder
		var/datum/abilityHolder/composite/C = new(src)
		C.holders = list(T)
		C.addHolder(holder_type)
		return C.getHolder(holder_type)
	else
		abilityHolder = new holder_type(src)
		return abilityHolder

/mob/proc/get_ability_holder(holder_type)
	if (abilityHolder && istype(abilityHolder, /datum/abilityHolder/composite))
		var/datum/abilityHolder/composite/C = abilityHolder
		return C.getHolder(holder_type)
	else if (abilityHolder && abilityHolder.type == holder_type)
		return abilityHolder
	return null

/mob/proc/remove_ability_holder(var/datum/abilityHolder/H)
	if (abilityHolder && istype(abilityHolder, /datum/abilityHolder/composite))
		var/datum/abilityHolder/composite/C = abilityHolder
		return C.removeHolder(H)
	else if (abilityHolder && abilityHolder == H)
		abilityHolder = null

/mob/proc/add_existing_ability_holder(var/datum/abilityHolder/H)
	if (H.owner != src)
		H.owner = src
	if (abilityHolder && istype(abilityHolder, /datum/abilityHolder/composite))
		var/datum/abilityHolder/composite/C = abilityHolder
		C.addHolderInstance(H)
		return H
	else if (abilityHolder)
		var/datum/abilityHolder/T = abilityHolder
		var/datum/abilityHolder/composite/C = new(src)
		C.holders = list(T, H)
		return H
	else
		abilityHolder = H
		return H

/mob/proc/lastgasp()
	return

/mob/proc/item_attack_message(var/mob/T, var/obj/item/S, var/d_zone)
	if (d_zone)
		return "<span style=\"color:red\"><B>[src] attacks [T] in the [d_zone] with [S]!</B></span>"
	else
		return "<span style=\"color:red\"><B>[src] attacks [T] with [S]!</B></span>"

/mob/proc/get_age_pitch()
	if (!src.bioHolder || !src.bioHolder.age) return
	if (src.reagents && src.reagents.has_reagent("helium"))
		return 1.0 + 0.5*(60 - src.bioHolder.age)/80
	else
		return 1.0 + 0.5*(30 - src.bioHolder.age)/80

/mob/proc/understands_language(var/langname)
	if (langname == say_language)
		return 1
	if (langname == "english" || !langname)
		return 1
	if (langname == "monkey" && (monkeysspeakhuman || (bioHolder && bioHolder.HasEffect("monkey_speak"))))
		return 1
	return 0

/mob/proc/get_language_id(var/forced_language = null)
	var/language = say_language
	if (forced_language)
		language = forced_language
	return language

/mob/proc/process_language(var/message, var/forced_language = null)
	var/datum/language/L = languages.language_cache[get_language_id(forced_language)]
	if (!L)
		L = languages.language_cache["english"]
	return L.get_messages(message)

/mob/proc/get_special_language(var/secure_mode)
	return null

/mob/proc/on_reagent_react(var/datum/reagents/R, var/method = 1, var/react_volume = null)

/mob/proc/HealBleeding(var/amt)

/mob/proc/find_in_equipment(var/eqtype)
	return null

/mob/proc/find_in_hands(var/eqtype)
	return null

/mob/proc/is_in_hands(var/obj/O)
	return 0

/mob/proc/does_it_metabolize()
	return 0

/mob/proc/isBlindImmune()
	return 0

/mob/proc/canRideMailchutes()
	return 0

/mob/proc/choose_name(var/retries = 3)
	var/newname
	for (retries, retries > 0, retries--)
		newname = input(src, "Would you like to change your name to something else?", "Name Change", src.real_name) as null|text
		if (!newname)
			if (src.client && src.client.preferences && src.client.preferences.real_name)
				src.real_name = src.client.preferences.real_name
			else
				src.real_name = random_name(src.gender)
			src.name = src.real_name
		else
			newname = strip_html(newname, 32, 1)
			if (!length(newname) || length(newname <= 3) || copytext(newname,1,2) == " ")
				src.show_text("That name was too short after removing bad characters from it. Please choose a different name.", "red")
				continue
			else
				if (alert(src, "Use the name [newname]?", newname, "Yes", "No") == "Yes")
					src.real_name = newname
					src.name = newname
					return 1
				else
					continue
	if (!newname)
		if (src.client && src.client.preferences && src.client.preferences.real_name)
			src.real_name = src.client.preferences.real_name
		else
			src.real_name = random_name(src.gender)
		src.name = src.real_name

/mob/proc/set_mutantrace(var/mutantrace_type)
	return

/proc/random_name(var/gen = MALE)
	var/return_name
	if (gen == MALE)
		return_name = capitalize(pick(first_names_male) + " " + capitalize(pick(last_names)))
	else if (gen == FEMALE)
		return_name = capitalize(pick(first_names_female) + " " + capitalize(pick(last_names)))
	else
		return_name = capitalize(pick(first_names_male + first_names_female) + " " + capitalize(pick(last_names)))
	return return_name

