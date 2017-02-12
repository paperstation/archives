/client
	preload_rsc = 1
	var/datum/admins/holder = null
	var/datum/preferences/preferences = null
	var/move_delay = 1
	var/moving = null
	var/vote = null
	var/showvote = null
	var/deadchat = 0
	var/changes = 0
	var/canplaysound = 1
	var/ambience_playing = null
	var/area = null
	var/played = 0
	var/team = null
	var/datum/buildmode_holder/buildmode = null
	var/lastbuildtype = 0
	var/lastbuildvar = 0
	var/lastbuildval = 0
	var/lastbuildobj = 0
	var/lastadvbuilder = 0
	var/stealth = 0
	var/stealth_hide_fakekey = 0
	var/alt_key = 0
	var/theater = 0
	var/pray_l = 0
	var/fakekey = null
	var/suicide = 0
	var/observing = 0
	var/warned = 0
	var/player_mode = 0
	var/player_mode_asay = 0
	var/player_mode_ahelp = 0
	var/player_mode_mhelp = 0
	var/only_local_looc = 0
	var/deadchatoff = 0
	var/local_deadchat = 0
	var/djmode = 0
	var/mentor = 0
	var/mentor_authed = 0
	var/see_mentor_pms = 1
	var/last_adminhelp = 0
	var/list/keys = list()
	var/use_azerty = 0
	var/queued_click = 0
	var/joined_date = null
	var/non_admin_dj = 0
	var/adventure_view = 0
	var/isbanned = 0 //just, in general

	var/hellbanned = 0 //The intention here is to basically make the game stealthily unplayable, prevents you from getting randomly picked as traitor, silently drops some Move() and Click() calls, etc.
	var/click_drops = 40
	var/move_drops = 30
	var/spiking = 0

	var/antag_tokens //Number of antagonist tokens available to the player
	var/using_antag_token = 0 //Set when the player readies up at round start, and opts to redeem a token.

	var/list/datum/compid_info_list = list()

	perspective = EYE_PERSPECTIVE
	// please ignore this for now thanks in advance - drsingh
#ifdef PROC_LOGGING
	var/proc_logging = 0
#endif

	// authenticate = 0
	// comment out the line below when debugging locally to enable the options & messages menu
	control_freak = 1

	var/datum/chatOutput/chatOutput = null
	var/resourcesLoaded = 0 //Has this client done the mass resource downloading yet?
	var/datum/tooltip/tooltip = null

/client/Del()
	if (ticker && ticker.current_state < GAME_STATE_FINISHED)
		ircbot.event("logout", src.key)

	clients -= src
	if(src.holder)
		onlineAdmins.Remove(src)
		src.holder.dispose()
		src.holder = null
	return ..()

var/global/list/hellbans = null

/client/New()
	if(findtext(src.key, "Telnet @"))
		boutput(src, "Sorry, this game does not support Telnet.")
		sleep(50)
		del(src)
		return

	if (config && config.env == "dev" && (!src.address || src.address == "127.0.0.1"))
		winshow(src, "runtimes", 1)

	//Assign custom interface datums
	src.chatOutput = new /datum/chatOutput(src)
	//src.chui = new /datum/chui(src)
	src.tooltip = new /datum/tooltip(src)

	src.isbanned = checkBan(src.ckey, src.computer_id, src.address)
	if (isbanned)
		logTheThing("diary", null, src, "Failed Login: %target% - Banned", "access")
		if (announce_banlogin) message_admins("<span style=\"color:blue\">Failed Login: <a href='?src=%admin_ref%;action=notes;target=[src.ckey]'>[src]</a> - Banned (IP: [src.address], ID: [src.computer_id])</span>")
		spawn(0)
			var/banstring = {"
								<!doctype html>
								<html>
									<head>
										<title>BANNED!</title>
										<style>
											h1, .banreason {
												font-color:#F00;
											}

										</style>
									</head>
									<body>
										<h1>You have been banned.</h1>
										<span class='banreason'>Reason: [isbanned].</span><br>
										If you believe you were unjustly banned, head to <a href=\"http://forum.ss13.co\">the forums</a> and post an appeal.
									</body>
								</html>
							"}
			src.mob << browse(banstring, "window=ripyou")

			if (src)
				del(src)
			return

	if (!hellbans)
		hellbans = dd_file2list("strings/hellbans.txt")
	if (hellbans && src.ckey in hellbans)
		hellbanned = 1

/*
	spawn(rand(4,18))
		if(proxy_check(src.address))
			logTheThing("diary", null, src, "Failed Login: %target% - Using a Tor Proxy Exit Node", "access")
			if (announce_banlogin) message_admins("<span style=\"color:blue\">Failed Login: [src] - Using a Tor Proxy Exit Node (IP: [src.address], ID: [src.computer_id])</span>")
			boutput(src, "You may not connect through TOR.")
			spawn(0) del(src)
			return
*/

	if (((world.address == src.address || !(src.address)) && !(host)))
		host = src.key
		world.update_status()

	if(player_capa)
		var/howmany = 0
		for(var/mob/M in mobs)
			if(M.client)
				howmany ++
		if(howmany >= player_cap)
			if (!src.holder)
				alert(src,"I'm sorry, the player cap of [player_cap] has been reached for this server.")
				del(src)
				return

	if (join_motd)
		boutput(src, "<div class=\"motd\">[join_motd]</div>")

	src.authorize()

	if (admins.Find(src.ckey))
		src.holder = new /datum/admins(src)
		src.holder.rank = admins[src.ckey]
		update_admins(admins[src.ckey])
		onlineAdmins.Add(src)

	else if (NT.Find(ckey(src.ckey)) || mentors.Find(ckey(src.ckey)))
		src.mentor = 1
		src.mentor_authed = 1

	..()

	// moved preferences from new_player so it's accessible in the client scope
	if (!preferences)
		preferences = new

	clients += src

	spawn(30)
		// new player logic, moving some of the preferences handling procs from new_player.Login
		if (!preferences)
			preferences = new
		if (istype(src.mob, /mob/new_player))
			if (noir)
				animate_fade_grayscale(src, 50)
			if(!preferences.savefile_load(src))
				preferences.ShowChoices(src)
			else if(!src.holder)
				preferences.sanitize_name()

			if (!changes && preferences.view_changelog)
				if (!CDN_ENABLED || config.env == "dev")
					src << browse_rsc(file("browserassets/images/changelog/postcardsmall.jpg"))
					src << browse_rsc(file("browserassets/images/changelog/somerights20.png"))
					src << browse_rsc(file("browserassets/images/changelog/88x31.png"))
				changes()

			if (src.holder && rank_to_level(src.holder.rank) >= LEVEL_MOD) // No admin changelog for goat farts (Convair880).
				admin_changes()
			load_antag_tokens()
			if (src.byond_version < 509)
				if (alert(src, "Please update BYOND to version 509! Would you like to be taken to the download page?", "ALERT", "Yes", "No") == "Yes")
					src << link("http://www.byond.com/download/")
		else
			if (noir)
				animate_fade_grayscale(src, 1)
			preferences.savefile_load(src)
			load_antag_tokens()
			src.loadResources()

		src.update_world()

		setJoinDate()

		if (winget(src, null, "hwmode") != "true")
			alert(src, "Hardware rendering is disabled.  This may cause errors displaying lighting, manifesting as BIG WHITE SQUARES.\nPlease enable hardware rendering from the byond preferences menu.","Potential Rendering Issue")

		ircbot.event("login", src.key)
		if (map_setting == "DESTINY")
			src.verbs += /client/proc/cmd_rp_rules
			if (istype(src.mob, /mob/new_player))
				src.cmd_rp_rules()

/*	if (ticker && ticker.mode && istype(ticker.mode, /datum/game_mode/sandbox))
		if(src.holder  && (src.holder.level >= 3))
			src.verbs += /mob/proc/Delete*/

	if(do_compid_analysis)
		do_computerid_test(src) //Will ban yonder fucker in case they are prix
		check_compid_list(src) 	//Will analyze their computer ID usage patterns for aberrations

/*
/client/proc/write_gauntlet_matches()
	return
*/

/client/Command(command)
	command = html_encode(command)
	out(src, "<span class='alert'>Command \"[command]\" not recognised</span>")

/client/proc/load_antag_tokens()
	var/savefile/AT = LoadSavefile("data/AntagTokens.sav")
	if (!AT) return
	var/ATtoken
	AT[ckey] >> ATtoken
	if (!ATtoken)
		antag_tokens = 0
	else
		antag_tokens = ATtoken

/client/proc/set_antag_tokens(amt as num)
	var/savefile/AT = LoadSavefile("data/AntagTokens.sav")
	if (!AT) return
	if (antag_tokens < 0) antag_tokens = 0
	AT[ckey] << antag_tokens

/client/proc/use_antag_token()
	src.set_antag_tokens(--antag_tokens)

var/global/curr_year = null
var/global/curr_month = null
var/global/curr_day = null

/client/proc/jd_warning(var/jd)
	if (!curr_year)
		curr_year = text2num(time2text(world.realtime, "YYYY"))
	if (!curr_month)
		curr_month = text2num(time2text(world.realtime, "MM"))
	if (!curr_day)
		curr_day = text2num(time2text(world.realtime, "DD"))
	var/deliver_warning = 0
	var/y = text2num(copytext(jd, 1, 5))
	var/m = text2num(copytext(jd, 6, 8))
	var/d = text2num(copytext(jd, 9, 11))
	if (curr_month == 1 && curr_day <= 4)
		if (y == curr_year - 1 && m == 12 && d >= 31 - (4 - curr_day))
			deliver_warning = 1
		else if (y == curr_year && m == 1)
			deliver_warning = 1
	else if (curr_day <= 4)
		if (y == curr_year)
			if (m == curr_month - 1 && d >= 28 - (4 - curr_day))
				deliver_warning = 1
			else if (m == curr_month)
				deliver_warning = 1
	else if (y == curr_year && m == curr_month && d >= curr_day - 4)
		deliver_warning = 1
	if (deliver_warning)
		var/msg = "(IP: [address], ID: [computer_id]) has a recent join date of [jd]."
		message_admins("[key_name(src)] [msg]")
		var/addr = address
		var/ck = ckey
		var/cid = computer_id
		spawn(0)
			if (geoip_check(addr))
				var/addData[] = new()
				addData["ckey"] = ck
				addData["compID"] = cid
				addData["ip"] = addr
				addData["reason"] = "Ban evader: computer ID collision." // haha get fucked
				addData["akey"] = "Marquesas"
				addData["mins"] = 0
				var/slt = rand(600, 3000)
				logTheThing("admin", null, null, "Evasion geoip autoban triggered on [key], will execute in [slt / 10] seconds.")
				message_admins("Autobanning evader [key] in [slt / 10] seconds.")
				sleep(slt)
				addBan(1, addData)

/proc/geoip_check(var/addr)
	set background = 1
	var/list/vl = world.Export("http://ip-api.com/json/[addr]")
	if (!("CONTENT" in vl) || vl["STATUS"] != "200 OK")
		sleep(3000)
		return geoip_check(addr)
	var/jd = html_encode(file2text(vl["CONTENT"]))
	// hardcoding argentina for now
	//var/c_text = "Argentina"
	//var/r_text = "Entre Rios"
	//var/i_text = "Federal"
	var/asshole_proxy_provider = "AnchorFree"

	//if (findtext(jd, c_text) && findtext(jd, r_text) && findtext(jd, i_text))
	//	logTheThing("admin", null, null, "Banned location: Argentina, Entre Rios, Federal for IP [addr].")
	//	return 1
	if (findtext(jd, asshole_proxy_provider))
		logTheThing("admin", null, null, "Banned proxy: AnchorFree Hotspot Shield [addr].")
		return 1
	return 0

/client/proc/setJoinDate()
	set background = 1
	joined_date = ""
	var/list/text = world.Export("http://byond.com/members/[src.ckey]?format=text")
	if(text)
		var/content = file2text(text["CONTENT"])
		var/savefile/save = new
		save.ImportText("/", content)
		save.cd = "general"
		joined_date = save["joined"]
		jd_warning(joined_date)
	return

/client/proc/install_macros()
	for(var/key in list("alt", "shift", "ctrl"))
		src.keys[key] = 0
		for(var/macro in params2list(winget(src, null, "macro")))
			winset(src, "[macro][key]down", "parent=[macro];name=[key];command=\".keydown [key]\"")
			winset(src, "[macro][key]up", "parent=[macro];name=[key]+UP;command=\".keyup [key]\"")

///client/Southwest()
	//
	//return

/client/Northeast()
	if (isobj(src.mob.loc))
		var/obj/O = src.mob.loc
		if (O.override_northeast(src.mob))
			return
	if (isliving(src.mob))
		var/mob/living/L = src.mob
		L.swap_hand()

/client/Southeast()
	if (isobj(src.mob.loc))
		var/obj/O = src.mob.loc
		if (O.override_southeast(src.mob))
			return
	var/obj/item/W = src.mob.equipped()
	if (src.mob.stat != 2)
		if (isitem(W) && ((!disable_next_click && world.time >= src.mob.next_click) || disable_next_click))
			W.attack_self(src.mob)
	if (!W)
		src.mob.south_east()

/client/Northwest()
	if (isobj(src.mob.loc))
		var/obj/O = src.mob.loc
		if (O.override_northwest(src.mob))
			return
	src.mob.drop_item_v()

/client/proc/check_key(key)
	return !!src.keys[key]

/client/verb/savetraits()
	set hidden = 1
	set name = ".savetraits"
	set instant = 1

	if(preferences)
		if(preferences.traitPreferences.isValid())
			preferences.ShowChoices(usr)
		else
			alert(usr, "Invalid trait setup. Please make sure you have 0 or more points available.")
			preferences.traitPreferences.showTraits(usr)
	return

/client/verb/keydown(key as text)
	set hidden = 1
	set name = ".keydown"
	set instant = 1
	if (src.keys.Find(key))
		src.keys[key] = 1
		mob.key_down(key)

/client/verb/keyup(key as text)
	set hidden = 1
	set name = ".keyup"
	set instant = 1
	if (src.keys.Find(key))
		src.keys[key] = 0
		mob.key_up(key)

/client/verb/hotkey(key as text)
	set hidden = 1
	set name = ".hotkey"
	set instant = 1
	mob.hotkey(key)

/client/verb/action(action as num)
	set hidden = 1
	set name = ".action"
	set instant = 1
	usr.action(action)

/client/verb/togglethrow()
	set hidden = 1
	if (!src.mob.stat && (ishuman(src.mob) || istype(src.mob, /mob/living/critter)) && isturf(src.mob.loc) && !src.mob.restrained())
		src.mob:toggle_throw_mode()
	return

/client/verb/togglepoint(force_off as num) // force_off is set to 1 when the button for this is released in WASD mode (currently B), else it's 0
	set hidden = 1
	if (!src.mob.stat && isliving(src.mob) && !src.mob.restrained())
		src.mob:toggle_point_mode(force_off)
	return

/client/verb/togglewasdzqsd()
	set hidden = 1
	if (src.use_azerty)
		src.togglezqsd()
	else
		src.togglewasd()

/client/verb/toggle_between_wasd_zqsd()
	set name = "Toggle AZERTY Hotkey Layout"
	set desc = "For WASD/ZQSD users: toggles between use of the WASD or ZQSD hotkey sets. You may have to disable and then re-enable WASD/ZQSD mode for it to change."
	set category = "Toggles"

	src.use_azerty = !(src.use_azerty)
	boutput(src, "<span style=\"color:blue\">[src.use_azerty ? "ZQSD" : "WASD"] hotkey layout enabled.</span>")

/client/verb/togglewasd()
	set hidden = 1
	var/current = winget(src, "mainwindow", "macro")
	if (current == "macro" || current == "zqsd")
		winset(src, "mainwindow", "macro=wasd")
		// ctrl+t for admin say
		if (src.holder)
			winset(src, "wasd.wasd-asay", "is-disabled=false")
			winset(src, "wasd.wasd-dsay", "is-disabled=false")
		else
			winset(src, "wasd.wasd-asay", "is-disabled=true")
			winset(src, "wasd.wasd-dsay", "is-disabled=true")
		boutput(src, "<span style=\"color:blue\">WASD hotkeys enabled.</span>")
	else
		winset(src, "mainwindow", "macro=macro")
		boutput(src, "<span style=\"color:blue\">WASD hotkeys disabled.</span>")
	src.install_macros()

/client/verb/togglezqsd()
	set hidden = 1
	var/current = winget(src, "mainwindow", "macro")
	if (current == "macro" || current == "wasd")
		winset(src, "mainwindow", "macro=zqsd")
		// ctrl+t for admin say
		if (src.holder)
			winset(src, "zqsd.zqsd-asay", "is-disabled=false")
			winset(src, "zqsd.zqsd-dsay", "is-disabled=false")
		else
			winset(src, "zqsd.zqsd-asay", "is-disabled=true")
			winset(src, "zqsd.zqsd-dsay", "is-disabled=true")
		boutput(src, "<span style=\"color:blue\">ZQSD hotkeys enabled.</span>")
	else
		winset(src, "mainwindow", "macro=macro")
		boutput(src, "<span style=\"color:blue\">ZQSD hotkeys disabled.</span>")
	src.install_macros()

/client/verb/toggletogglewasd()
	set name = "Toggle Tab WASD/ZQSD"
	set desc = "Enables/disables the Tab key WASD/ZQSD keyboard shortcut"
	set category = "Toggles"

	var/current = winget(usr, "macro.togglewasd", "is-disabled")
	if (current == "true")
		winset(usr, "macro.togglewasd", "is-disabled=false")
		winset(usr, "wasd.togglewasd", "is-disabled=false")
		winset(usr, "zqsd.togglewasd", "is-disabled=false")
		boutput(usr, "<span style=\"color:blue\">Tab now toggles WASD/ZQSD.</span>")
	else
		winset(usr, "macro.togglewasd", "is-disabled=true")
		winset(usr, "wasd.togglewasd", "is-disabled=true")
		boutput(usr, "<span style=\"color:blue\">Tab no longer toggles WASD/ZQSD.</span>")

/client/verb/equip()
	set name = "Equip"
	set desc = "Equips the item in your active hand."
	if (!(istype(usr, /mob/living/carbon/human/))) return
	var/mob/living/carbon/human/H = usr
	H.hud.clicked("invtoggle", list()) // this is incredibly dumb, it's also just as dumb as what was here previously

/client/verb/ping()
	set name = "Ping"
	boutput(usr, "Pong")

/*
/client/verb/Newcastcycle()
	set hidden = 1
	if (!(istype(usr, /mob/living/carbon/human/))) return
	var/mob/living/carbon/human/H = usr
	if (istype(H.wear_suit, /obj/item/clothing/suit/wizrobe/abuttontest))
		var/obj/screen/ability_button/spell/U = H.wear_suit.ability_buttons[2]
		U.execute_ability()
*/

/*
/client/Center()
	if (isobj(src.mob.loc))
		var/obj/O = src.mob.loc
		if (src.mob.canmove)
			return O.relaymove(src.mob, 16)
	return
*/

/client/Move(n, direct)
	if(hellbanned && prob(move_drops))
		if(prob(1) && prob(25)) fake_lagspike()
		return
	if(istype(mob, /mob/living/carbon/human/pixel))
		mob.Move(n, direct)
		return
	if(istype(src.mob, /mob/dead/observer) || istype(src.mob, /mob/dead/hhghost)) //what the shit
		return src.mob.Move(n,direct)
	if (src.moving)
		return 0
	if (!( src.mob ))
		return
	if (src.mob.stat == 2 && !istype(src.mob, /mob/wraith))
		return
	if (world.time < src.move_delay)
		src.mob.dir = direct
		return
	if(istype(src.mob, /mob/living/silicon/ai))
		return AIMove(n,direct,src.mob)
//	if(istype(src.mob, /mob/living/silicon/hive_mainframe))
//		return MainframeMove(n,direct,src.mob)
	if(istype(src.mob, /mob/living/silicon/hivebot/drone))
		return DroneMove(n,direct,src.mob)
	if (src.mob.transforming)
		return

	var/is_monkey = ismonkey(src.mob)
	if (locate(/obj/item/grab, locate(/obj/item/grab, src.mob.grabbed_by.len)))
		var/list/grabbing = list(  )
		if (istype(src.mob.l_hand, /obj/item/grab))
			var/obj/item/grab/G = src.mob.l_hand
			grabbing += G.affecting
		if (istype(src.mob.r_hand, /obj/item/grab))
			var/obj/item/grab/G = src.mob.r_hand
			grabbing += G.affecting
		for(var/obj/item/grab/G in src.mob.grabbed_by)
			if (G.state == 0)
				if (!( grabbing.Find(G.assailant) ))
					qdel(G)
			else
				if (G.state == 1)
					src.move_delay = world.time + 10
					if ((prob(25) && (!( is_monkey ) || prob(25))))
						mob.visible_message("<span style=\"color:red\">[mob] has broken free of [G.assailant]'s grip!</span>")
						qdel(G)
					else
						return
				else
					if (G.state == 2)
						src.move_delay = world.time + 10
						if ((prob(5) && !( is_monkey ) || prob(25)))
							mob.visible_message("<span style=\"color:red\">[mob] has broken free of [G.assailant]'s headlock!</span>")
							qdel(G)
						else
							return
	if (src.mob.canmove)

		if(src.mob.m_intent == "face")
			src.mob.dir = direct

		var/j_pack = 0
		if ((istype(src.mob.loc, /turf/space)) && !src.mob.is_spacefaring())
			src.mob.dir = direct
			if(ishuman(src.mob))
				if(istype(src.mob:wear_suit, /obj/item/clothing/suit/space/emerg))
					var/obj/item/clothing/suit/space/emerg/E = src.mob:wear_suit
					if (E.rip != -1)
						E.rip ++
						E.ripcheck(src.mob)
			if (!( src.mob.restrained() ))
				var/list/our_oview = oview(1, src.mob)
				if (!( (locate(/obj/grille) in our_oview) || (locate(/turf/simulated) in our_oview) || (locate(/turf/unsimulated) in our_oview) || (locate(/obj/lattice) in our_oview) ))
					if (istype(src.mob.back, /obj/item/tank/jetpack))
						var/obj/item/tank/jetpack/J = src.mob.back
						j_pack = J.allow_thrust(0.01, src.mob)
						if(j_pack)
							src.mob.inertia_dir = 0
						if (!( j_pack ))
							return 0
					else if(isrobot(src.mob) || isghostdrone(src.mob))
						if(src.mob:jetpack)
							if(!src.mob:jeton)
								src.mob.inertia_dir = 0
								if(!isnull(src.mob:ion_trail))
									src.mob:ion_trail.start()
									src.mob:jeton = 1
						else
							return 0
					else if(ishivebot(src.mob))
						if(src.mob:jetpack)
							src.mob.inertia_dir = 0
						else
							return 0
				//	else if(isalien(src.mob))
				//		src.mob.inertia_dir = 0
					else
						return 0
			else
				return 0


		if (isturf(src.mob.loc))
			if(isrobot(src.mob))
				if(src.mob:jetpack)
					if(src.mob:jeton)
						if(!isnull(src.mob:ion_trail))
							src.mob:ion_trail.stop()
							src.mob:jeton = 0
			src.move_delay = world.time
			if ((j_pack && j_pack < 1))
				src.move_delay += 2
			switch(src.mob.m_intent)
				if("run")
					if (src.mob.drowsyness > 0)
						src.move_delay += 6
					src.move_delay += 2.00 // 3.20
				if("face")
					src.mob.dir = direct
					return
				if("walk")
					src.move_delay += 8

			if(istype (src.mob, /mob/living/carbon/human/))
				var/mob/living/carbon/human/H = src.mob
				if (H.find_ailment_by_type(/datum/ailment/disease/vamplague))
					src.move_delay += 3
				if (H.buckled && H.canmove && !H.buckled.anchored)
					return H.buckled.relaymove(H, direct)

			src.move_delay += src.mob.movement_delay()
			if(src.mob.reagents)
				if(src.mob.reagents.has_reagent("methamphetamine")) src.move_delay = max(src.move_delay-10,0)

			if (src.mob.restrained())
				for(var/mob/M in range(src.mob, 1))
					if (((M.pulling == src.mob && (!( M.restrained() ) && M.stat == 0)) || locate(/obj/item/grab, src.mob.grabbed_by.len)))
						boutput(src, "<span style=\"color:blue\">You're restrained! You can't move!</span>")
						return 0
			src.moving = 1
			if (locate(/obj/item/grab, src.mob))
				src.move_delay = max(src.move_delay, world.time + 7)
				var/list/L = src.mob.ret_grab()
				if (islist(L))
					if (L.len == 2)
						L -= src.mob
						var/mob/M = L[1]
						if ((get_dist(src.mob, M) <= 1 || M.loc == src.mob.loc))
							var/turf/T = src.mob.loc
							. = ..()
							if (isturf(M.loc))
								var/diag = get_dir(src.mob, M)
								if ((diag - 1) & diag)
								else
									diag = null
								if ((get_dist(src.mob, M) > 1 || diag))
									M.inertia_dir = get_dir(M.loc, T)
									step(M, get_dir(M.loc, T))
					else
						for(var/mob/M in L)
							M.other_mobs = 1
							if (src.mob != M)
								M.animate_movement = 3
						for(var/mob/M in L)
							spawn( 0 )
								if (isturf(M.loc))
									step(M, direct)
								return
							spawn( 1 )
								M.other_mobs = null
								M.animate_movement = 2
								return
			else
				if(istype(src.mob,/mob/living/))
					var/mob/living/L = src.mob
					if (!isturf(src.mob.loc))
						return
					if (prob(L.misstep_chance))
						step(src.mob, pick(cardinal))
					else
						. = ..()
				else
					. = ..()
			src.moving = null
			return
		// If the person is inside an object .
		else
			if (isobj(src.mob.loc) || ismob(src.mob.loc))
				var/atom/O = src.mob.loc
				if (src.mob.canmove)
					return O.relaymove(src.mob, direct)
	else
		return
	return


/client/Click(atom/object, location, control, params)
	if(hellbanned && prob(click_drops)) //Drop some of their clicks
		if(prob(2)) fake_lagspike()
		return

	if(src.buildmode)
		if (src.buildmode.is_active)
			..() // temp fix for buildmode buttons
			buildmode.build_click(object, location, control, params)
			return

	var/list/parameters = params2list(params)
	var/mob/user = usr

	for (var/key in list("alt", "ctrl", "shift"))
		if (parameters.Find(key))
			if (!src.keys[key]) src.keydown(key)
		else
			if (src.keys[key]) src.keyup(key)

	// super shit hack for examining over the HUD, please replace this then murder me
	if (istype(object, /obj/screen) && !parameters["middle"])
		if (istype(usr, /mob/dead/target_observer))
			return
		var/obj/screen/S = object
		S.clicked(parameters)
		return

	if(user.traitHolder && istype(user, /mob/living/carbon) && isturf(object.loc) && prob(10) && user.traitHolder.hasTrait("clutz"))
		var/list/filtered = list()
		for(var/atom/movable/A in view(get_dist(src.mob, object), src.mob))
			if(A == object || !isturf(A.loc)) continue
			filtered.Add(A)
		if(filtered.len) object = pick(filtered)

	if(isturf(location) || isobj(location) || ismob(location))
		actions.interrupt(user, INTERRUPT_ACT) //Definitely not the best place for this.

	var/next = user.click(object, parameters)

	if (isnum(next) && src.preferences.use_click_buffer && !src.queued_click)
		src.queued_click = 1
		spawn(next+1)
			if(location && (isturf(location) || isobj(location) || ismob(location)))
				actions.interrupt(user, INTERRUPT_ACT) //Definitely not the best place for this.
			user.click(object, parameters)
	. = ..()

/client/Stat()
	. = ..()
	sleep(1) // yeah lets call this thing EVERY TICK, jesus fuck byond

/client/Topic(href, href_list)
	if (!usr || isnull(usr.client))
		return

	var/mob/M
	if (href_list["target"])
		var/targetCkey = href_list["target"]
		for (var/mob/allM in mobs)
			if (allM.ckey == targetCkey)
				M = allM
				break

	switch(href_list["action"])
		if ("priv_msg_irc")
			if (!usr || !usr.client)
				return
			var/target = href_list["nick"]
			var/t = input("Message:", text("Private message to [target] (IRC)")) as null|text
			if(!(usr.client.holder && usr.client.holder.rank in list("Host", "Coder")))
				t = strip_html(t,500)
			if (!( t ))
				return
			boutput(usr, "<span style=\"color:blue\" class=\"bigPM\">Admin PM to-<b>[target] (IRC)</b>: [t]</span>")

			var/ircmsg[] = new()
			ircmsg["key"] = usr && usr.client ? usr.client.key : ""
			ircmsg["name"] = usr.real_name
			ircmsg["key2"] = target
			ircmsg["name2"] = "IRC"
			ircmsg["msg"] = html_decode(t)
			ircbot.export("pm", ircmsg)

			//we don't use message_admins here because the sender/receiver might get it too
			for (var/mob/K in mobs)
				if(K && K.client && K.client.holder && K.key != usr.key)
					if (K.client.player_mode && !K.client.player_mode_ahelp)
						continue
					else
						boutput(K, "<font color='blue'><b>PM: [key_name(usr,0,0)][(usr.real_name ? "/"+usr.real_name : "")] <A HREF='?src=\ref[K.client.holder];action=adminplayeropts;targetckey=[usr.ckey]' class='popt'><i class='icon-info-sign'></i></A> <i class='icon-arrow-right'></i> [target] (IRC)</b>: [t]</font>")

		if ("priv_msg")
			if(M)
				if (!( ismob(M) ))
					return
				if (!usr || !usr.client)
					return
				if (!usr.client.holder && !(M.client && M.client.holder))
					return
				var/t = input("Message:", text("Private message to [admin_key(M.client, 1)]")) as null|text
				if(!(usr.client.holder && usr.client.holder.rank in list("Host", "Coder")))
					t = strip_html(t,500)
				if (!( t ))
					return
				if (usr.client.holder)
					boutput(M, "<span style=\"color:red\" class=\"bigPM\">Admin PM from-<b>[key_name(usr, 0, 0)]</b>: [t]</span>")
					boutput(usr, "<span style=\"color:blue\" class=\"bigPM\">Admin PM to-<b>[key_name(M, 0, 0)][(M.real_name ? "/"+M.real_name : "")] <A HREF='?src=\ref[usr.client.holder];action=adminplayeropts;targetckey=[M.ckey]' class='popt'><i class='icon-info-sign'></i></A></b>: [t]</span>")
				else
					if (M.client && M.client.holder)
						boutput(M, "<span style=\"color:blue\" class=\"bigPM\">Reply PM from-<b>[key_name(usr, 0, 0)][(usr.real_name ? "/"+usr.real_name : "")] <A HREF='?src=\ref[M.client.holder];action=adminplayeropts;targetckey=[usr.ckey]' class='popt'><i class='icon-info-sign'></i></A></b>: [t]</span>")
					else
						boutput(M, "<span style=\"color:red\" class=\"bigPM\">Reply PM from-<b>[key_name(usr, 0, 0)]</b>: [t]</span>")
					boutput(usr, "<span style=\"color:blue\" class=\"bigPM\">Reply PM to-<b>[key_name(M, 0, 0)]</b>: [t]</span>")

				logTheThing("admin_help", src, M, "<b>PM'd %target%</b>: [t]")
				logTheThing("diary", src, M, "PM'd %target%: [t]", "ahelp")

				var/ircmsg[] = new()
				ircmsg["key"] = usr && usr.client ? usr.client.key : ""
				ircmsg["name"] = usr.real_name
				ircmsg["key2"] = (M != null && M.client != null && M.client.key != null) ? M.client.key : ""
				ircmsg["name2"] = (M != null && M.real_name != null) ? M.real_name : ""
				ircmsg["msg"] = html_decode(t)
				ircbot.export("pm", ircmsg)

				//we don't use message_admins here because the sender/receiver might get it too
				for (var/mob/K in mobs)
					if(K && K.client && K.client.holder && K.key != usr.key && (M && K.key != M.key))
						if (K.client.player_mode && !K.client.player_mode_ahelp)
							continue
						else
							boutput(K, "<font color='blue'><b>PM: [key_name(usr,0,0)][(usr.real_name ? "/"+usr.real_name : "")] <A HREF='?src=\ref[K.client.holder];action=adminplayeropts;targetckey=[usr.ckey]' class='popt'><i class='icon-info-sign'></i></A> <i class='icon-arrow-right'></i> [key_name(M,0,0)][(M.real_name ? "/"+M.real_name : "")] <A HREF='?src=\ref[K.client.holder];action=adminplayeropts;targetckey=[M.ckey]' class='popt'><i class='icon-info-sign'></i></A></b>: [t]</font>")

		if ("mentor_msg_irc")
			if (!usr || !usr.client)
				return
			var/target = href_list["nick"]
			var/t = input("Message:", text("Mentor Message")) as null|text
			if(!(usr.client.holder && usr.client.holder.rank in list("Host", "Coder")))
				t = strip_html(t,500)
			if (!( t ))
				return
			boutput(usr, "<span style='color:[mentorhelp_text_color]'><b>MENTOR PM: TO [target] (IRC)</b>: <span class='message'>[t]</span></span>")

			var/ircmsg[] = new()
			ircmsg["key"] = usr && usr.client ? usr.client.key : ""
			ircmsg["name"] = usr.real_name
			ircmsg["key2"] = target
			ircmsg["name2"] = "IRC"
			ircmsg["msg"] = html_decode(t)
			ircbot.export("mentorpm", ircmsg)

			//we don't use message_admins here because the sender/receiver might get it too
			for (var/mob/K in mobs)
				if (K && K.client && ((K.client.mentor && K.client.see_mentor_pms) || K.client.holder) && K.key != usr.key && (M && K.key != M.key))
					if (K.client.holder)
						if (K.client.player_mode && !K.client.player_mode_mhelp)
							continue
						else //Message admins
							boutput(K, "<span style='color:[mentorhelp_text_color]'><b>MENTOR PM: [key_name(usr,0,0,1)][(usr.real_name ? "/"+usr.real_name : "")] <A HREF='?src=\ref[K.client.holder];action=adminplayeropts;targetckey=[usr.ckey]' class='popt'><i class='icon-info-sign'></i></A> <i class='icon-arrow-right'></i> [target] (IRC)</b>: <span class='message'>[t]</span></span>")
					else //Message mentors
						boutput(K, "<span style='color:[mentorhelp_text_color]'><b>MENTOR PM: [key_name(usr,0,0,1)] <i class='icon-arrow-right'></i> [target] (IRC)</b>: <span class='message'>[t]</span></span>")

		if ("mentor_msg")
			if (M)
				if (!( ismob(M) ) && !M.client)
					return
				if (!usr || !usr.client)
					return

				var/t = input("Message:", text("Mentor Message")) as null|text
				if (!(usr.client.holder && usr.client.holder.rank in list("Host", "Coder")))
					t = strip_html(t,500)
				if (!( t ))
					return
				if (usr.client.holder)
					boutput(M, "<span style='color:[mentorhelp_text_color]'><b>MENTOR PM: FROM [key_name(usr,0,0,1)]</b>: <span class='message'>[t]</span></span>")
					boutput(usr, "<span style='color:[mentorhelp_text_color]'><b>MENTOR PM: TO [key_name(M,0,0,1)][(M.real_name ? "/"+M.real_name : "")] <A HREF='?src=\ref[usr.client.holder];action=adminplayeropts;targetckey=[M.ckey]' class='popt'><i class='icon-info-sign'></i></A></b>: <span class='message'>[t]</span></span>")
				else
					if (M.client && M.client.holder)
						boutput(M, "<span style='color:[mentorhelp_text_color]'><b>MENTOR PM: FROM [key_name(usr,0,0,1)][(usr.real_name ? "/"+usr.real_name : "")] <A HREF='?src=\ref[M.client.holder];action=adminplayeropts;targetckey=[usr.ckey]' class='popt'><i class='icon-info-sign'></i></A></b>: <span class='message'>[t]</span></span>")
					else
						boutput(M, "<span style='color:[mentorhelp_text_color]'><b>MENTOR PM: FROM [key_name(usr,0,0,1)]</b>: <span class='message'>[t]</span></span>")
					boutput(usr, "<span style='color:[mentorhelp_text_color]'><b>MENTOR PM: TO [key_name(M,0,0,1)]</b>: <span class='message'>[t]</span></span>")

				logTheThing("mentor_help", usr, M, "Mentor PM'd %target%: [t]")
				logTheThing("diary", usr, M, "Mentor PM'd %target%: [t]", "admin")

				var/ircmsg[] = new()
				ircmsg["key"] = usr && usr.client ? usr.client.key : ""
				ircmsg["name"] = usr.real_name
				ircmsg["key2"] = (M != null && M.client != null && M.client.key != null) ? M.client.key : ""
				ircmsg["name2"] = (M != null && M.real_name != null) ? M.real_name : ""
				ircmsg["msg"] = html_decode(t)
				ircbot.export("mentorpm", ircmsg)

				for (var/mob/K in mobs)
					if (K && K.client && ((K.client.mentor && K.client.see_mentor_pms) || K.client.holder) && K.key != usr.key && (M && K.key != M.key))
						if (K.client.holder)
							if (K.client.player_mode && !K.client.player_mode_mhelp)
								continue
							else
								boutput(K, "<span style='color:[mentorhelp_text_color]'><b>MENTOR PM: [key_name(usr,0,0,1)][(usr.real_name ? "/"+usr.real_name : "")] <A HREF='?src=\ref[K.client.holder];action=adminplayeropts;targetckey=[usr.ckey]' class='popt'><i class='icon-info-sign'></i></A> <i class='icon-arrow-right'></i> [key_name(M,0,0,1)]/[M.real_name] <A HREF='?src=\ref[K.client.holder];action=adminplayeropts;targetckey=[M.ckey]' class='popt'><i class='icon-info-sign'></i></A></b>: <span class='message'>[t]</span></span>")
						else
							boutput(K, "<span style='color:[mentorhelp_text_color]'><b>MENTOR PM: [key_name(usr,0,0,1)] <i class='icon-arrow-right'></i> [key_name(M,0,0,1)]</b>: <span class='message'>[t]</span></span>")

		if ("mach_close")
			var/window = href_list["window"]
			var/t1 = text("window=[window]")
			usr.machine = null
			usr << browse(null, t1)
			//Special cases
			switch (window)
				if ("aialerts")
					usr:viewalerts = 0

		//A thing for the chat output to call so that links open in the user's default browser, rather than IE
		if ("openLink")
			src << link(href_list["link"])

		if ("ehjax")
			ehjax.topic("main", href_list, src)

		if("resourcePreloadComplete")
			bout(src, "<span style='color:blue;'><b>Preload completed.</b></span>")
			src << browse(null, "window=resourcePreload")
			return

		/* For debug
		if ("out")
			out(src, href_list["msg"])
		*/

	..()
	return

/client/proc/mute(len = -1)
	if (!src.ckey)
		return 0
	if (!src.ismuted())
		muted_keys += src.ckey
		muted_keys[src.ckey] = len

/client/proc/unmute()
	if (!src.ckey)
		return 0
	if (src.ismuted())
		muted_keys -= src.ckey

/client/proc/ismuted()
	if (!src.ckey)
		return 0
	return (src.ckey in muted_keys) && muted_keys[src.ckey]

/client/proc/fake_lagspike()
	if(!src.hellbanned || src.spiking) return
	//Let's significantly increase the dropped clicks / moves for some time
	var/duration = rand(10, 80) //1 - 8 seconds

	move_drops = min(move_drops + rand(30, 80), 100)
	click_drops = min(click_drops + rand(30, 80), 100)

	spiking = 1
	spawn(duration)
		move_drops = initial(move_drops)
		click_drops = initial(click_drops)
		spiking = 0

	return duration

/proc/add_test_screen_thing()
	var/client/C = input("For who", "For who", null) in clients
	var/wavelength_shift = input("Shift wavelength bounds by <x> nm, should be in the range of -370 to 370", "Wavelength shift", 0) as num
	if (wavelength_shift < -370 || wavelength_shift > 370)
		boutput(usr, "Invalid value.")
		return
	var/s_r = 0
	var/s_g = 0
	var/s_b = 0

	// total range: 380 - 750 (range: 370nm)
	// red: 570 - 750 (range: 180nm)
	if (wavelength_shift < 0)
		s_r = min(-wavelength_shift / 180 * 255, 255)
	else if (wavelength_shift > 190)
		s_r = min((wavelength_shift - 190) / 180 * 255, 255)
	// green: 490 - 620 (range: 130nm)
	if (wavelength_shift < -130)
		s_g = min(-(wavelength_shift + 130) / 130 * 255, 255)
	else if (wavelength_shift > 110)
		s_g = min((wavelength_shift - 110) / 130 * 255, 255)
	// blue: 380 - 500 (range: 120nm)
	if (wavelength_shift < -250)
		s_b = min(-(wavelength_shift + 250) / 120 * 255, 255)
	else if (wavelength_shift > 0)
		s_b = min(wavelength_shift / 120 * 255, 255)

	var/subtr_color = rgb(s_r, s_g, s_b)

	var/si_r = max(min(input("Red spectrum intensity (0-1)", "Intensity", 1.0) as num, 1), 0)
	var/si_g = max(min(input("Green spectrum intensity (0-1)", "Intensity", 1.0) as num, 1), 0)
	var/si_b = max(min(input("Blue spectrum intensity (0-1)", "Intensity", 1.0) as num, 1), 0)

	var/multip_color = rgb(si_r * 255, si_g * 255, si_b * 255)

	var/obj/screen/S = new
	S.icon = 'icons/mob/whiteview.dmi'
	S.blend_mode = BLEND_SUBTRACT
	S.color = subtr_color
	S.layer = HUD_LAYER - 0.2
	S.screen_loc = "SOUTH,WEST"
	S.mouse_opacity = 0

	C.screen += S

	var/obj/screen/M = new
	M.icon = 'icons/mob/whiteview.dmi'
	M.blend_mode = BLEND_MULTIPLY
	M.color = multip_color
	M.layer = HUD_LAYER - 0.1
	M.screen_loc = "SOUTH,WEST"
	M.mouse_opacity = 0

	C.screen += M

/client/verb/changes()
	set category = "Commands"
	set name = "Changelog"
	set desc = "Show or hide the changelog"

	if (winget(src, "changes", "is-visible") == "true")
		src.Browse(null, "window=changes")
	else
		var/changelogHtml = grabResource("html/changelog.html")
		var/data = changelog:html
		changelogHtml = dd_replacetext(changelogHtml, "<!-- HTML GOES HERE -->", "[data]")
		src.Browse(changelogHtml, "window=changes;size=500x650;title=Changelog;")
		src.changes = 1

/client/verb/wiki()
	set category = "Commands"
	set name = "Wiki"
	set desc = "Open the Wiki in your browser"
	set hidden = 1
	src << link("http://wiki.ss13.co")

/client/verb/map()
	set category = "Commands"
	set name = "Map"
	set desc = "Open an interactive map in your browser"
	set hidden = 1
	if (map_setting == "COG2")
		src << link("http://goonhub.com/maps/cogmap2")
	else if (map_setting == "DESTINY")
		src << link("http://goonhub.com/maps/destiny")
	else
		src << link("http://goonhub.com/maps/cogmap")

/client/verb/forum()
	set category = "Commands"
	set name = "Forum"
	set desc = "Open the Forum in your browser"
	set hidden = 1
	src << link("http://forum.ss13.co")