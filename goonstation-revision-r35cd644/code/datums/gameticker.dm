var/global/datum/controller/gameticker/ticker
/* -- moved to _setup.dm
#define GAME_STATE_PREGAME		1
#define GAME_STATE_SETTING_UP	2
#define GAME_STATE_PLAYING		3
#define GAME_STATE_FINISHED		4
*/
/datum/controller/gameticker
	var/current_state = GAME_STATE_PREGAME

	var/hide_mode = 0
	var/datum/game_mode/mode = null
	var/event_time = null
	var/event = 0

	var/list/datum/mind/minds = list()
	var/last_readd_lost_minds_to_ticker = 1 // In relation to world time.

	var/pregame_timeleft = 0

	var/round_elapsed_ticks = 0

	var/click_delay = 3

	var/datum/ai_laws/centralized_ai_laws

	var/skull_key_assigned = 0

/datum/controller/gameticker/proc/pregame()
	pregame_timeleft = 180 // raised from 120 to accomodate the v500 ads
	boutput(world, "<B><FONT color='blue'>Welcome to the pre-game lobby!</FONT></B>")
	boutput(world, "Please, setup your character and select ready. Game will start in [pregame_timeleft] seconds")

	while(current_state == GAME_STATE_PREGAME)
		sleep(10)
		if (!game_start_delayed)
			pregame_timeleft--

		if(pregame_timeleft <= 0)
			current_state = GAME_STATE_SETTING_UP

	spawn setup()

/datum/controller/gameticker/proc/setup()
	set background = 1
	//Create and announce mode
	if(master_mode in list("secret","wizard","alien"))
		src.hide_mode = 1

	if((master_mode=="random") || (master_mode=="secret")) src.mode = config.pick_random_mode()
	else src.mode = config.pick_mode(master_mode)

	if(hide_mode)
		var/modes = sortList(config.get_used_mode_names())
		boutput(world, "<B>The current game mode is a secret!</B>")
		boutput(world, "<B>Possibilities:</B> [english_list(modes)]")
	else
		src.mode.announce()

	// uhh is this where this goes??
	src.centralized_ai_laws = new /datum/ai_laws/asimov()

	//Configure mode and assign player to special mode stuff
	var/can_continue = src.mode.pre_setup()

	if(!can_continue)
		qdel(mode)

		current_state = GAME_STATE_PREGAME
		boutput(world, "<B>Error setting up [master_mode].</B> Reverting to pre-game lobby.")

		spawn pregame()

		return 0

	if (!istype(src.mode, /datum/game_mode/construction) && map_setting != "DESTINY")
		ooc_allowed = 0
		boutput(world, "<B>OOC has been automatically disabled until the round ends.</B>")

	if (map_setting == "DESTINY")
		looc_allowed = 1
		boutput(world, "<B>LOOC has been automatically enabled.</B>")

	//Distribute jobs
	distribute_jobs()

	//Create player characters and transfer them
	create_characters()

	add_minds()

	// rip collar key, nerds murdered people for you as non-antags and it was annoying
	//implant_skull_key() //Solarium

#ifdef CREW_OBJECTIVES
	//Create objectives for the non-traitor/nogoodnik crew.
	generate_crew_objectives()
#endif

	//Equip characters
	equip_characters()

	current_state = GAME_STATE_PLAYING
	round_time_check = world.timeofday

	spawn(0)
		ircbot.event("roundstart")
		mode.post_setup()

		//Cleanup some stuff
		for(var/obj/landmark/start/S in world)
			//Deleting Startpoints but we need the ai point to AI-ize people later
			if (S.name != "AI")
				qdel(S)

		hydro_controls.set_up()
		manuf_controls.set_up()
		event_wormhole_buildturflist()
		total_corruptible_terrain = get_total_corruptible_terrain()

		mode.post_post_setup()

		if (istype(random_events,/datum/event_controller/))
			spawn(random_events.minor_events_begin)
				message_admins("<span style=\"color:blue\">Minor Event cycle has been started.</span>")
				random_events.minor_event_cycle()
			spawn(random_events.events_begin)
				message_admins("<span style=\"color:blue\">Random Event cycle has been started.</span>")
				random_events.event_cycle()
			random_events.next_event = random_events.events_begin
			random_events.next_minor_event = random_events.minor_events_begin

		for(var/obj/landmark/artifact/A in world)
			if (prob(A.spawnchance))
				if (A.spawnpath)
					new A.spawnpath(A.loc)
				else
					Artifact_Spawn(A.loc)

		var/list/lootspawn = list()
		for(var/obj/landmark/S in world)
			if (S.name == "Loot spawn")
				lootspawn.Add(S.loc)
		if(lootspawn.len)
			var/lootamt = rand(5,15)
			while(lootamt > 0)
				var/lootloc = lootspawn.len ? pick(lootspawn) : null
				if (lootloc && prob(75))
					new/obj/storage/crate/loot(lootloc)
				--lootamt

		shippingmarket.get_market_timeleft()

		for(var/area/AR in world)
			if(!AR || teleareas.Find(AR.name)) continue
			if (istype(AR, /area/wizard_station))
				var/entry = text("* []", AR.name)
				teleareas[entry] = AR
				continue
			var/list/topick = get_area_turfs(AR.type);
			if (topick.len > 0)
				var/turf/picked = pick(topick)
				if (picked && picked.z == 1)
					teleareas += AR.name
					teleareas[AR.name] = AR
		teleareas = sortList(teleareas) // Moved wizard's den back to the top of the list for convenience. It's also sorted now (Convair880).

		logTheThing("ooc", null, null, "<b>Current round begins</b>")
		boutput(world, "<FONT color='blue'><B>Enjoy the game!</B></FONT>")
		boutput(world, "<span style=\"color:blue\"><b>Tip:</b> [pick(tips)]</span>")

		//Setup the hub site logging
		var hublog_filename = "data/stats/data.txt"
		if (fexists(hublog_filename))
			fdel(hublog_filename)

		hublog = file(hublog_filename)
		hublog << ""

	spawn (6000) // 10 minutes in
		for(var/obj/machinery/power/generatorTemp/E in world)
			if (E.lastgen <= 0)
				command_alert("Reports indicate that the engine on-board [station_name()] has not yet been started. Setting up the engine is strongly recommended, or else stationwide power failures may occur.", "Power Grid Warning")
			break

	processScheduler.start()

/datum/controller/gameticker
	proc/distribute_jobs()
		DivideOccupations()

	proc/create_characters()
		for(var/mob/new_player/player in mobs)
			if(player.ready)
				if(player.mind && player.mind.assigned_role=="AI")
					player.close_spawn_windows()
					player.AIize()
				else if(player.mind && player.mind.special_role == "wraith")
					player.close_spawn_windows()
					var/mob/wraith/W = player.make_wraith()
					if (W)
						W.set_loc(pick(observer_start))
				else if(player.mind && player.mind.special_role == "blob")
					player.close_spawn_windows()
					var/mob/living/intangible/blob_overmind/B = player.make_blob()
					if (B)
						B.set_loc(pick(observer_start))
				else if(player.mind)
					if (player.client.using_antag_token)
						player.client.use_antag_token()	//Removes a token from the player
					player.create_character()
					qdel(player)

	proc/add_minds(var/periodic_check = 0)
		for (var/mob/player in mobs)
			// Who cares about NPCs? Adding them here breaks all antagonist objectives
			// that attempt to scale with total player count (Convair880).
			if (player.mind && !istype(player, /mob/new_player) && player.client)
				if (!(player.mind in ticker.minds))
					if (periodic_check == 1)
						logTheThing("debug", player, null, "<b>Gameticker fallback:</b> re-added player to ticker.minds.")
					else
						logTheThing("debug", player, null, "<b>Gameticker setup:</b> added player to ticker.minds.")
					ticker.minds.Add(player.mind)

	proc/implant_skull_key()
		//Hello, I will sneak in a solarium thing here.
		if(!skull_key_assigned && ticker.minds.len > 5) //Okay enough gaming the system you pricks
			var/list/HL = list()
			for (var/mob/living/carbon/human/human in mobs)
				if (human.client)
					HL += human

			if(HL.len > 5)
				var/mob/living/carbon/human/H = pick(HL)
				if(istype(H))
					skull_key_assigned = 1
					spawn(50)
						if(H.organHolder && H.organHolder.skull)
							H.organHolder.skull.key = new /obj/item/device/key/skull (H.organHolder.skull)
							logTheThing("debug", H, null, "has the dubious pleasure of having a key embedded in their skull.")
						else
							skull_key_assigned = 0
		else if(!skull_key_assigned)
			logTheThing("debug", null, null, "<B>SpyGuy/collar key:</B> Did not implant a key because there was not enough players.")

	proc/equip_characters()
		for(var/mob/living/carbon/human/player in mobs)
			if(player.mind && player.mind.assigned_role)
				if(player.mind.assigned_role != "MODE")
					spawn(0)
						player.Equip_Rank(player.mind.assigned_role)

	proc/process()
		if(current_state != GAME_STATE_PLAYING)
			return 0

		updateRoundTime()

		mode.process()

		emergency_shuttle.process()

		// Minds are sometimes kicked out of the global list, hence the fallback (Convair880).
		if (src.last_readd_lost_minds_to_ticker && world.time > src.last_readd_lost_minds_to_ticker + 1800)
			src.add_minds(1)
			src.last_readd_lost_minds_to_ticker = world.time

		if(mode.check_finished())
			current_state = GAME_STATE_FINISHED

			spawn
				declare_completion()

			ooc_allowed = 1
			boutput(world, "<B>OOC is now enabled.</B>")

			spawn(50)
				boutput(world, "<span style=\"color:blue\"><B>Restarting soon</B></span>")

				sleep(250)
				if (game_end_delayed == 1)
					message_admins("<font color='blue'>Server would have restarted now, but the restart has been delayed[game_end_delayer ? " by [game_end_delayer]" : null]. Remove the delay for an immediate restart.</font>")
					game_end_delayed = 2
					var/ircmsg[] = new()
					ircmsg["msg"] = "Server would have restarted now, but the restart has been delayed[game_end_delayer ? " by [game_end_delayer]" : null]."
					ircbot.export("admin", ircmsg)
				else
					ircbot.event("roundend")
					Reboot_server()

		return 1

	proc/updateRoundTime()
		if (round_time_check)
			var/elapsed = world.timeofday - round_time_check
			round_time_check = world.timeofday

			if (round_time_check == 0) // on the slim chance that this happens exactly on a timeofday rollover
				round_time_check = 1   // make it nonzero so it doesn't quit updating

			if (elapsed > 0)
				ticker.round_elapsed_ticks += elapsed

/datum/controller/gameticker/proc/declare_completion()
	set background = 1
	//End of round statistic collection for goonhub
	statlog_traitors()
	statlog_ailaws(0)
	round_end_data(1) //Export round end packet (normal completion)

	// Score Calculation and Display

	// Who is alive/dead, who escaped
	for (var/mob/living/silicon/ai/I in mobs)
		if (I.stat == 2)
			score_deadaipenalty = 1
			score_deadcrew += 1

	for (var/mob/living/carbon/human/I in mobs)
		if (I.stat == 2 && I.z == 1)
			score_deadcrew += 1

	for(var/mob/living/player in mobs)
		if (player.client)
			if (player.stat != 2)
				var/turf/location = get_turf(player.loc)
				var/area/escape_zone = locate(/area/shuttle/escape/centcom)
				if (location in escape_zone)
					score_escapees += 1
					player.unlock_medal("100M dash", 1)
				player.unlock_medal("Survivor", 1)

				if (player.check_contents_for(/obj/item/gnomechompski))
					player.unlock_medal("Guardin' gnome", 1)

				if (ishuman(player))
					var/mob/living/carbon/human/H = player
					if (H && istype(H) && H.implant && H.implant.len > 0)
						var/bullets = 0
						for (var/obj/item/implant/I in H)
							if (istype(I, /obj/item/implant/projectile))
								bullets = 1
								break
						if (bullets > 0)
							H.unlock_medal("It's just a flesh wound!", 1)
					if (H.limbs && (!H.limbs.l_arm && !H.limbs.r_arm))
						H.unlock_medal("Mostly Armless", 1)

#ifdef CREW_OBJECTIVES
	var/list/successfulCrew = list()
	for (var/datum/mind/crewMind in minds)
		if (!crewMind.current || !crewMind.objectives.len)
			continue

		var/count = 0
		var/allComplete = 1
		for (var/datum/objective/crew/CO in crewMind.objectives)
			count++
			if(CO.check_completion())
				boutput(crewMind.current, "<B>Objective #[count]</B>: [CO.explanation_text] <span style=\"color:green\"><B>Success</B></span>")
				if (!isnull(CO.medal_name) && !isnull(crewMind.current))
					crewMind.current.unlock_medal(CO.medal_name, CO.medal_announce)
			else
				boutput(crewMind.current, "<B>Objective #[count]</B>: [CO.explanation_text] <span style=\"color:red\">Failed</span>")
				allComplete = 0

		if (allComplete && count)
			successfulCrew += "[crewMind.current.real_name] ([crewMind.key])"
#endif
	var/cashscore = 0
	var/dmgscore = 0
	for(var/mob/living/carbon/human/E in mobs)
		cashscore = 0
		dmgscore = 0
		var/turf/location = get_turf(E.loc)
		var/area/escape_zone = locate(/area/shuttle/escape/centcom)
		if(E.stat != 2 && location in escape_zone) // Escapee Scores
			for (var/obj/item/card/id/C1 in E.contents) cashscore += C1.money
			for (var/obj/item/device/pda2/PDA in E.contents)
				if (PDA.ID_card) cashscore += PDA.ID_card.money
			for (var/obj/item/spacecash/C2 in E.contents) cashscore += C2.amount
			for (var/obj/item/storage/S in E.contents)
				for (var/obj/item/card/id/C3 in S.contents) cashscore += C3.money
				for (var/obj/item/device/pda2/PDA in S.contents)
					if (PDA.ID_card) cashscore += PDA.ID_card.money
				for (var/obj/item/spacecash/C4 in S.contents) cashscore += C4.amount
			for(var/datum/data/record/Ba in data_core.bank)
				if(Ba.fields["name"] == E.real_name) cashscore += Ba.fields["current_money"]
			if (cashscore > score_richestcash)
				score_richestcash = cashscore
				score_richestname = E.real_name
				score_richestjob = E.job
				score_richestkey = E.key
			dmgscore = E.get_brute_damage() + E.get_burn_damage() + E.get_toxin_damage() + E.get_oxygen_deprivation()
			if (dmgscore > score_dmgestdamage)
				score_dmgestdamage = dmgscore
				score_dmgestname = E.real_name
				score_dmgestjob = E.job
				score_dmgestkey = E.key

	var/list/stock_t5 = list()
	for (var/i = 0, i < 5, i++)
		if (!stockExchange.balances.len)
			break
		var/m = stockExchange.balances[1]
		var/mv = stockExchange.balances[m]
		for (var/N in stockExchange.balances)
			if (stockExchange.balances[N] > mv)
				m = N
				mv = stockExchange.balances[N]
		stock_t5[m] = mv
		stockExchange.balances -= m
	if (stock_t5.len)
		score_allstock_html = "<ul>"
		for (var/N in stock_t5)
			score_allstock_html += "<li>[N] ($[stock_t5[N]])</li>"
		score_allstock_html += "</ul>"

	var/nukedpenalty = 1000
	if (ticker && ticker.mode && istype(ticker.mode, /datum/game_mode/nuclear))
		var/foecount = 0
		for(var/datum/mind/M in ticker.mode:syndicates)
			foecount++
			if (!M || !M.current)
				score_opkilled++
				continue
			var/turf/T = M.current.loc
			if (T && istype(T.loc, /area/station/security/brig)) score_arrested += 1
			else if (M.current.stat == 2) score_opkilled++
		if(foecount == score_arrested) score_allarrested = 1

	if (ticker && ticker.mode && istype(ticker.mode, /datum/game_mode/revolution))
		var/foecount = 0
		for(var/datum/mind/M in ticker.mode:head_revolutionaries)
			foecount++
			if (!M || !M.current)
				score_opkilled++
				continue
			var/turf/T = M.current.loc
			if (istype(T.loc, /area/station/security/brig)) score_arrested += 1
			else if (M.current.stat == 2) score_opkilled++
		if(foecount == score_arrested) score_allarrested = 1
		for(var/mob/living/carbon/human/player in mobs)
			if(player.mind)
				var/role = player.mind.assigned_role
				if(role in list("Captain","Head of Security","Head of Personnel","Chief Engineer","Research Director", "Medical Director"))
					if (player.stat == 2) score_deadcommand++

	// Check station's power levels
	for (var/obj/machinery/power/apc/A in machines)
		if (A.z != 1) continue
		for (var/obj/item/cell/C in A.contents)
			if (C.charge < 2300) score_powerloss += 1 // 200 charge leeway

	// Check how much uncleaned mess is on the station
	for (var/obj/decal/cleanable/M in world)
		if (M.z != 1) continue
		if (istype(M, /obj/decal/cleanable/blood/gibs/)) score_mess += 3
		if (istype(M, /obj/decal/cleanable/blood/)) score_mess += 1
		if (istype(M, /obj/decal/cleanable/greenpuke)) score_mess += 1
		if (istype(M, /obj/decal/cleanable/urine)) score_mess += 1
		if (istype(M, /obj/decal/cleanable/vomit)) score_mess += 1

	// Bonus Modifiers
	//var/traitorwins = score_traitorswon
	var/deathpoints = score_deadcrew * 25
	var/researchpoints = score_researchdone * 30
	var/eventpoints = score_eventsendured * 50
	var/borgpoints = score_cyborgsmade * 50
	var/escapoints = score_escapees * 25
	var/harvests = score_stuffharvested * 5
	var/shipping = score_stuffshipped * 5
	var/mining = score_oremined * 2
	var/meals = score_meals * 5
	var/power = score_powerloss * 20
	var/messpoints
	if (score_mess != 0) messpoints = score_mess
	var/plaguepoints = score_disease * 30

	// Mode Specific
	if (ticker && ticker.mode && istype(ticker.mode, /datum/game_mode/nuclear))
		if (score_disc) score_crewscore += 500
		var/killpoints = score_opkilled * 250
		var/arrestpoints = score_arrested * 1000
		score_crewscore += killpoints
		score_crewscore += arrestpoints
		if (score_nuked) score_crewscore -= nukedpenalty

	if (ticker && ticker.mode && istype(ticker.mode, /datum/game_mode/revolution))
		var/arrestpoints = score_arrested * 1000
		var/killpoints = score_opkilled * 500
		var/comdeadpts = score_deadcommand * 500
		if (score_traitorswon) score_crewscore -= 10000
		score_crewscore += arrestpoints
		score_crewscore += killpoints
		score_crewscore -= comdeadpts

	// Good Things
	score_crewscore += shipping
	score_crewscore += harvests
	score_crewscore += mining
	score_crewscore += borgpoints
	score_crewscore += researchpoints
	score_crewscore += eventpoints
	score_crewscore += escapoints
#ifdef CREW_OBJECTIVES
	score_crewscore += successfulCrew.len * 250 //Not sure what the multiplier should be, feel free to adjust it.
#endif

	if (power == 0)
		score_crewscore += 2500
		score_powerbonus = 1
	if (score_mess == 0)
		score_crewscore += 3000
		score_messbonus = 1
	score_crewscore += meals
	if (score_allarrested) score_crewscore *= 3 // This needs to be here for the bonus to be applied properly

	// Bad Things
	score_crewscore -= deathpoints
	if (score_deadaipenalty) score_crewscore -= 250
	score_crewscore -= power
	//if (score_crewscore != 0) // Dont divide by zero!
	//	while (traitorwins > 0)
	//		score_crewscore /= 2
	//		traitorwins -= 1
	score_crewscore -= messpoints
	score_crewscore -= plaguepoints

	// Show the score - might add "ranks" later
	boutput(world, "<b>The crew's final score is:</b>")
	boutput(world, "<b><font size='4'>[score_crewscore]</font></b>")
	for(var/mob/E in mobs)
		if(E.client)
			if (E.client.preferences.view_score)
				E.scorestats()
			if (E.client.preferences.view_tickets)
				E.showtickets()

	for (var/mob/living/silicon/ai/aiPlayer in mobs)
		if (aiPlayer.stat != 2)
			boutput(world, "<b>The AI, [aiPlayer.name] ([aiPlayer.key]) had the following laws at the end of the game:</b>")
		else
			boutput(world, "<b>The AI, [aiPlayer.name] ([aiPlayer.key]) had the following laws when it was deactivated:</b>")

		aiPlayer.show_laws(1)

	mode.declare_completion()

	if (gauntlet_controller.state)
		gauntlet_controller.resetArena()
#ifdef CREW_OBJECTIVES
	if (successfulCrew.len)
		boutput(world, "<B>The following crewmembers completed all of their Crew Objectives:</B>")
		for (var/i in successfulCrew)
			boutput(world, "<B>[i]</B>")
		boutput(world, "Good job!")
	else
		boutput(world, "<B>Nobody completed all of their Crew Objectives!</B>")
#endif
#ifdef MISCREANTS
	boutput(world, "<B>Miscreants:</B>")
	if(miscreants.len == 0) boutput(world, "None!")
	for(var/datum/mind/miscreantMind in miscreants)
		if(!miscreantMind.objectives.len)
			continue

		var/miscreant_info = "[miscreantMind.key]"
		if(miscreantMind.current) miscreant_info = "[miscreantMind.current.real_name] ([miscreantMind.key])"

		boutput(world, "<B>[miscreant_info] was a miscreant!</B>")
		for (var/datum/objective/miscreant/O in miscreantMind.objectives)
			boutput(world, "Objective: [O.explanation_text] <B>Maybe</B>")
#endif

	return 1

/////
/////SETTING UP THE GAME
/////

/////
/////MAIN PROCESS PART
/////
/*
/datum/controller/gameticker/proc/game_process()

	switch(mode.name)
		if("deathmatch","monkey","nuclear emergency","Corporate Restructuring","revolution","traitor",
		"wizard","extended")
			do
				if (!( shuttle_frozen ))
					if (src.timing == 1)
						src.timeleft -= 10
					else
						if (src.timing == -1.0)
							src.timeleft += 10
							if (src.timeleft >= shuttle_time_to_arrive)
								src.timeleft = null
								src.timing = 0
				if (prob(0.5))
					spawn_meteors()
				if (src.timeleft <= 0 && src.timing)
					src.timeup()
				sleep(10)
			while(src.processing)
			return
//Standard extended process (incorporates most game modes).
//Put yours in here if you don't know where else to put it.
		if("AI malfunction")
			do
				check_win()
				ticker.AItime += 10
				sleep(10)
				if (ticker.AItime == 6000)
					boutput(world, "<FONT size = 3><B>Cent. Com. Update</B> AI Malfunction Detected</FONT>")
					boutput(world, "<span style=\"color:red\">It seems we have provided you with a malfunctioning AI. We're very sorry.</span>")
			while(src.processing)
			return
//malfunction process
		if("meteor")
			do
				if (!( shuttle_frozen ))
					if (src.timing == 1)
						src.timeleft -= 10
					else
						if (src.timing == -1.0)
							src.timeleft += 10
							if (src.timeleft >= shuttle_time_to_arrive)
								src.timeleft = null
								src.timing = 0
				for(var/i = 0; i < 10; i++)
					spawn_meteors()
				if (src.timeleft <= 0 && src.timing)
					src.timeup()
				sleep(10)
			while(src.processing)
			return
//meteor mode!!! MORE METEORS!!!
		else
			return
//Anything else, like sandbox, return.
*/