var/global/datum/controller/gameticker/ticker

#define GAME_STATE_PREGAME		1
#define GAME_STATE_SETTING_UP	2
#define GAME_STATE_PLAYING		3
#define GAME_STATE_FINISHED		4


/datum/controller/gameticker
	var/const/restart_timeout = 250
	var/current_state = GAME_STATE_PREGAME

	var/hide_mode = 0
	var/datum/game_mode/mode = null
	var/event_time = null
	var/event = 0

	var/list/datum/mind/minds = list()//The people in the game. Used for objective tracking.

	var/pregame_timeleft = 0

/datum/controller/gameticker/proc/pregame()

	do
		pregame_timeleft = 60
		world << "<B><FONT color='blue'>Welcome to the pre-game lobby!</FONT></B>"
		world << "Please, setup your character and select ready. Game will start in [pregame_timeleft] seconds"
		while(current_state == GAME_STATE_PREGAME)
			sleep(10)
			if(going)
				pregame_timeleft--

			if(pregame_timeleft <= 0)
				current_state = GAME_STATE_SETTING_UP
	while (!setup())

/datum/controller/gameticker/proc/setup()
	//Create and announce mode
	setup_isno_mining()
	if(master_mode=="secret")
		src.hide_mode = 1
	var/list/datum/game_mode/runnable_modes
	if((master_mode=="random") || (master_mode=="secret"))
		runnable_modes = config.get_runnable_modes()
		if (runnable_modes.len==0)
			current_state = GAME_STATE_PREGAME
			world << "<B>Unable to choose playable game mode.</B> Reverting to pre-game lobby."
			return 0
		src.mode = pickweight(runnable_modes)
	else
		src.mode = config.pick_mode(master_mode)
		if (!src.mode.can_start())
			del(mode)
			current_state = GAME_STATE_PREGAME
			world << "<B>Unable to start [master_mode].</B> Not enough players. Reverting to pre-game lobby."
			return 0

	//Configure mode and assign player to special mode stuff
	var/can_continue

	if (src.mode.config_tag == "revolution")
		var/tries=5
		do
			can_continue = src.mode.pre_setup()
		while (tries-- && !can_continue)
		if (!can_continue)
			del(mode)
			current_state = GAME_STATE_PREGAME
			world << "<B>Error setting up revolution.</B> Not enough players. Reverting to pre-game lobby."
			return 0
	else
		can_continue = src.mode.pre_setup()
		if(!can_continue)
			del(mode)
			current_state = GAME_STATE_PREGAME
			world << "<B>Error setting up [master_mode].</B> Reverting to pre-game lobby."
			return 0

	if(hide_mode)
		var/list/modes = new
		for (var/datum/game_mode/M in runnable_modes)
			modes+=M.name
		modes = sortList(modes)
		world << "<B>The current game mode is - Secret!</B>"
		world << "<B>Possibilities:</B> [english_list(modes)]"
	else
		src.mode.announce()
	if(air_master)
		air_master.process()
	ul_Update()
	distribute_jobs() //Distribute jobs and announce the captain
	create_characters() //Create player characters and transfer them

	apply_cluwne() //cluwnes for the cluwne god

	collect_minds()
	data_core.manifest()
	equip_characters()
	current_state = GAME_STATE_PLAYING
	//ooc_allowed = 0
	//world << "\blue <B>The OOC channel has been automatically disabled for the round due to constant IC in OOC!</B>"
	mode.post_setup()
	//Cleanup some stuff

	for(var/obj/landmark/start/S in landmarkz)
		//Deleting Startpoints but we need the ai point to AI-ize people later
		if (S.name != "AI")
			del(S)

	var/list/artispawn = list()
	for(var/obj/landmark/S in landmarkz)
		if (S.name == "Artifact spawn")
			artispawn.Add(S.loc)
	if(artispawn.len)
		var/artiamt = rand(2,8)
		while(artiamt > 0)
			var/artiloc = pick(artispawn)
			if (prob(66)) new/obj/machinery/artifact(artiloc)
			--artiamt

	//Start master_controller.process()
	//We went too full retarded with the "and remember". Removed. Sorry.
	spawn (5)
		meteorevent()
	spawn (3000)
		start_events()
	spawn ((18000+rand(3000)))
		event()
	spawn() supply_ticker() // Added to kick-off the supply shuttle regenerating points -- TLE

	//Start master_controller.process()
	spawn master_controller.process()
	return 1

/datum/controller/gameticker
	proc/distribute_jobs()
		DivideOccupations() //occupations can be distributes already by gamemode, it is okay. --rastaf0
		var/captainless=1
		for(var/mob/new_player/player in mobz)
			if(player.mind && player.mind.assigned_role=="Captain")
				captainless=0
				break
		if (captainless)
			world << "Captainship not forced on anyone."

	proc/create_characters()
		for(var/mob/new_player/player in mobz)
			if(player.ready)
				if(player.mind && player.mind.assigned_role=="AI")
					player.close_spawn_windows()
					player.AIize()
				else if(player.mind)
					player.create_character()
					del(player)
	proc/collect_minds()
		for(var/mob/living/player in mobz)
			if(player.mind)
				ticker.minds += player.mind

	proc/equip_characters()
		for(var/mob/living/carbon/human/player in mobz)
			if(player.mind && player.mind.assigned_role)
				if(player.mind.assigned_role != "MODE")
					player.Equip_Rank(player.mind.assigned_role)

	proc/process()
		if(current_state != GAME_STATE_PLAYING)
			return 0

		mode.process()

		emergency_shuttle.process()

		if(!mode.explosion_in_progress && mode.check_finished())
			current_state = GAME_STATE_FINISHED
			//ooc_allowed = 1
			//world << "\blue <B>The OOC channel has been globally enabled!</B>"

			spawn
				declare_completion()

			spawn(50)
				if (mode.station_was_nuked)
					world << "\blue <B>Rebooting due to destruction of station in [restart_timeout/10] seconds</B>"
				else
					world << "\blue <B>Restarting in [restart_timeout/10] seconds</B>"
				sleep(restart_timeout)
				world.Reboot()

		return 1

/*
/datum/controller/gameticker/proc/timeup()

	if (shuttle_left) //Shuttle left but its leaving or arriving again
		check_win()	  //Either way, its not possible
		return

	if (src.shuttle_location == shuttle_z)

		move_shuttle(locate(/area/shuttle), locate(/area/arrival/shuttle))

		src.timeleft = shuttle_time_in_station
		src.shuttle_location = 1

		world << "<B>The Emergency Shuttle has docked with the station! You have [ticker.timeleft/600] minutes to board the Emergency Shuttle.</B>"

	else //marker2
		world << "<B>The Emergency Shuttle is leaving!</B>"
		shuttle_left = 1
		shuttlecoming = 0
		check_win()
	return
*/

/datum/controller/gameticker/proc/declare_completion()
// and this stuff goes in gameticker.dm's declare_completion() proc
	for (var/mob/living/silicon/ai/aiPlayer in mobz)
		if (aiPlayer.stat != 2)
			world << "<b>[aiPlayer.name]'s laws at the end of the game were:</b>"
		else
			world << "<b>[aiPlayer.name]'s laws when it was deactivated were:</b>"
		aiPlayer.show_laws(1)

		if (aiPlayer.connected_robots.len)
			var/robolist = "<b>The AI's loyal minions were:</b> "
			for(var/mob/living/silicon/robot/robo in aiPlayer.connected_robots)
				robolist += "[robo.name][robo.stat?" (Deactivated), ":", "]"
			world << "[robolist]"

	for (var/mob/living/silicon/robot/robo in mobz)
		if (!robo.connected_ai)
			if (robo.stat != 2)
				world << "<b>[robo.name] survived as an AI-less borg! Its laws were:</b>"
			else
				world << "<b>[robo.name] was unable to survive the rigors of being a cyborg without an AI. Its laws were:</b>"
			robo.laws.show_laws(world)

	mode.declare_completion()//To declare normal completion.

	//calls auto_declare_completion_* for all modes
	for (var/handler in typesof(/datum/game_mode/proc))
		if (findtext("[handler]","auto_declare_completion_"))
			call(mode, handler)()
	// Score Calculation and Display

	// Who is alive/dead, who escaped
	for (var/mob/living/silicon/ai/I in mobz)
		if (I.stat == 2 && I.z == 1)
			score_deadaipenalty = 1
			score_deadcrew += 1
	for (var/mob/living/carbon/I in mobz)
		for (var/datum/disease/V in I.viruses)
			if (!V.spread != "Remissive") score_disease++
		if (I.stat == 2 && I.z == 1) score_deadcrew += 1
	for(var/mob/living in mobz)
		if (living.client)
			var/turf/location = get_turf(living.loc)
			var/area/escape_zone = locate(/area/shuttle/escape/centcom)
			if (location in escape_zone)

				score_escapees += 1
				if(istype(living, /mob/living/carbon/human))
					var/escapepayment = 50 + text2num(src.getInflation()) - score_deadcrew
					if(living.client.goon)
						escapepayment += 75
					if(src.doTransaction(living.ckey,"[escapepayment]","Escaped the station alive.") != 1)
						src << "\blue Unfortunately you lack a bank account and didn't get paid for escaping the station alive."
					else
						src << "\blue You got Ð[escapepayment] for escaping the station alive!"
					for (var/obj/item/weapon/money/LODSEMONE in living:get_contents())
						if(LODSEMONE.value > 0)
							if(src.doTransaction(living.ckey,"[LODSEMONE.value]","Deposited from escape.") != 1)
								src << "\blue You lack a bank account, and therefore can't deposit the money you just brought with you."
							else
								src << "\blue Deposited Ð[LODSEMONE.value] to your account as you carried this."
			/*	player.unlock_medal("100M Dash", 1)
			player.unlock_medal("Survivor", 1)
			for (var/obj/item/weapon/gnomechompski/G in player.get_contents())
				player.unlock_medal("Guardin' gnome", 1)*/


	var/cashscore = 0
	var/dmgscore = 0
	for(var/mob/living/carbon/human/E in mobz)
		cashscore = 0
		dmgscore = 0
		var/turf/location = get_turf(E.loc)
		var/area/escape_zone = locate(/area/shuttle/escape/centcom)
		if(E.stat != 2 && location in escape_zone) // Escapee Scores
			for (var/obj/item/weapon/card/id/C1 in E.contents) cashscore += C1:money
			for (var/obj/item/weapon/money/C2 in E.contents) cashscore += C2.value
			for (var/obj/item/weapon/storage/S in E.contents)
				for (var/obj/item/weapon/card/id/C3 in S.contents) cashscore += C3:money
				for (var/obj/item/weapon/money/C4 in S.contents) cashscore += C4.value
/*			for(var/datum/data/record/Ba in data_core:bank)
				if(Ba.fields["name"] == E.real_name) cashscore += Ba.fields["current_money"]
			if (cashscore > score_richestcash)
				score_richestcash = cashscore
				score_richestname = E.real_name
				score_richestjob = E.job
				score_richestkey = E.key
*/
			dmgscore = E.bruteloss + E.fireloss + E.toxloss + E.oxyloss + E.cloneloss + E.bloodloss
			if (dmgscore > score_dmgestdamage)
				score_dmgestdamage = dmgscore
				score_dmgestname = E.real_name
				score_dmgestjob = E.job
				score_dmgestkey = E.key

	var/nukedpenalty = 1000
	if (ticker.mode.config_tag == "nuclear")
		var/foecount = 0
		for(var/datum/mind/M in ticker.mode:syndicates)
			foecount++
			if (!M || !M.current)
				score_opkilled++
				continue
			var/turf/T = M.current.loc
			if (T && istype(T.loc, /area/security/brig)) score_arrested += 1
			else if (M.current.stat == 2) score_opkilled++
		if(foecount == score_arrested) score_allarrested = 1

		score_disc = 1
//		for (var/datum/computer/file/nuclear_auth/A in nuclear_auths)
//			if(!A.holder) continue
//			var/turf/location = get_turf(A.holder.loc)
//			var/area/bad_zone1 = locate(/area)
//			var/area/bad_zone2 = locate(/area/syndicate_station)
///			var/area/bad_zone3 = locate(/area/wizard_station)
	//		if (location in bad_zone1) score_disc = 0
	//		if (location in bad_zone2) score_disc = 0
	//		if (location in bad_zone3) score_disc = 0
	//		if (A.holder.z != 1) score_disc = 0

		if (score_nuked)
			if (nukedpenalty)
				for (var/obj/machinery/nuclearbomb/NUKE in machines)
					if (NUKE.r_code == "Nope") continue
					var/turf/T = NUKE.loc
					if (istype(T,/area/syndicate_station) || istype(T,/area/wizard_station) || istype(T,/area/solar)) nukedpenalty = 1000
					else if (istype(T,/area/security/main) || istype(T,/area/security/brig) || istype(T,/area/security/armory) || istype(T,/area/security/checkpoint2)) nukedpenalty = 50000
					else if (istype(T,/area/engine/engineering)) nukedpenalty = 100000
					else nukedpenalty = 10000

	if (ticker.mode.config_tag == "revolution")
		var/foecount = 0
		for(var/datum/mind/M in ticker.mode:head_revolutionaries)
			foecount++
			if (!M || !M.current)
				score_opkilled++
				continue
			var/turf/T = M.current.loc
			if (istype(T.loc, /area/security/brig)) score_arrested += 1
			else if (M.current.stat == 2) score_opkilled++
		if(foecount == score_arrested) score_allarrested = 1
		for(var/mob/living/carbon/human/player in mobz)
			if(player.endgamemodifier)
				score_clownabuse += player.endgamemodifier
			if(player.mind)
				var/role = player.mind.assigned_role
				if(role in list("Captain", "Head of Security", "Head of Personnel", "Chief Engineer", "Research Director"))
					if (player.stat == 2) score_deadcommand++

	// Check station's power levels
	for (var/obj/machinery/power/apc/A in machines)
		if (A.z != 1) continue
		for (var/obj/item/weapon/cell/C in A.contents)
			if (C.charge < 2300) score_powerloss += 1 // 200 charge leeway

	// Check how much uncleaned mess is on the station
	for (var/obj/decal/cleanable/M in world)
		if (M.z != 1) continue
		if (istype(M, /obj/decal/cleanable/blood/gibs/)) score_mess += 10
		if (istype(M, /obj/decal/cleanable/blood/)) score_mess += 5
//		if (istype(M, /obj/decal/cleanable/greenpuke)) score_mess += 1
		if (istype(M, /obj/decal/cleanable/poo)) score_mess += 2
		if (istype(M, /obj/decal/cleanable/urine)) score_mess += 1
		if (istype(M, /obj/decal/cleanable/vomit)) score_mess += 1
		if (istype(M, /obj/decal/cleanable)) score_mess += 2

	// Bonus Modifiers
	var/traitorwins = score_traitorswon
	var/deathpoints = score_deadcrew * 200
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

/*	// Mode Specific
	if (ticker.mode.config_tag == "nuclear")
		if (score_disc) score_crewscore += 500
		var/killpoints = score_opkilled * 250
		var/arrestpoints = score_arrested * 1000
		score_crewscore += killpoints
		score_crewscore += arrestpoints
		if (score_nuked) score_crewscore -= nukedpenalty

	if (ticker.mode.config_tag == "revolution")
		var/arrestpoints = score_arrested * 1000
		var/killpoints = score_opkilled * 500
		var/comdeadpts = score_deadcommand * 500
		if (score_traitorswon) score_crewscore -= 10000
		score_crewscore += arrestpoints
		score_crewscore += killpoints
		score_crewscore -= comdeadpts
*/
	// Good Things
	score_crewscore += shipping
	score_crewscore += harvests
	score_crewscore += mining
	score_crewscore += borgpoints
	score_crewscore += researchpoints
	score_crewscore += eventpoints
	score_crewscore += escapoints

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
	if (score_crewscore != 0) // Dont divide by zero!
		while (traitorwins > 0)
			score_crewscore /= 2
			traitorwins -= 1
	score_crewscore -= messpoints
	score_crewscore -= plaguepoints

	// Show the score - might add "ranks" later
	if(score_crewscore >= 1)
		score_mess = score_mess + 50000
		score_crewscore = score_crewscore - 50000

	world << "<b>The crew's final score is:</b>"
	world << "<b><font size='4'>[score_crewscore]</font></b>"
	for(var/mob/E in mobz)
		if(E.client) E.scorestats()

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
					world << "<FONT size = 3><B>Cent. Com. Update</B> AI Malfunction Detected</FONT>"
					world << "\red It seems we have provided you with a malfunctioning AI. We're very sorry."
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



/mob/proc/scorestats()
	var/dat = {"<B>Round Statistics and Score</B><BR><HR>"}
//	var/totalfunds = wagesystem.station_budget + wagesystem.research_budget + wagesystem.shipping_budget
	if (ticker.mode.name == "nuclear emergency")
		var/foecount = 0
		var/crewcount = 0
		var/diskdat = null
		var/bombdat = null
		for(var/datum/mind/M in ticker.mode:syndicates)
			foecount++
		for(var/mob/living/C in mobz)
			if (!istype(C,/mob/living/carbon/human) || !istype(C,/mob/living/silicon/robot) || !istype(C,/mob/living/silicon/ai)) continue
			if (C.stat == 2) continue
			if (!C.client) continue
			crewcount++
		var/nukedpenalty = 0
		for(var/obj/item/weapon/disk/nuclear/DISK in world)
			var/turf/T = DISK.loc
			diskdat = T.loc

		for(var/obj/machinery/nuclearbomb/NUKE in machines)
			if (NUKE.r_code == "Nope") continue
			var/turf/T = NUKE.loc
			bombdat = T.loc
			if (istype(T,/area/syndicate_station) || istype(T,/area/wizard_station) || istype(T,/area/solar/) || istype(T,/area)) nukedpenalty = 1000
			else if (istype(T,/area/security/main) || istype(T,/area/security/brig) || istype(T,/area/security/armory) || istype(T,/area/security/checkpoint2)) nukedpenalty = 50000
			else if (istype(T,/area/engine/engineering)) nukedpenalty = 100000
			else nukedpenalty = 10000
			break
		if (!diskdat) diskdat = "Uh oh. Something has fucked up! Report this."
		dat += {"<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><B><U>MODE STATS</U></B><BR>
		<B>Number of Operatives:</B> [foecount]<BR>
		<B>Number of Surviving Crew:</B> [crewcount]<BR>
		<B>Final Location of Nuke:</B> [bombdat]<BR>
		<B>Final Location of Disk:</B> [diskdat]<BR><BR>
		<B>Nuclear Disk Secure:</B> [score_disc ? "Yes" : "No"] ([score_disc * 500] Points)<BR>
		<B>Operatives Arrested:</B> [score_arrested] ([score_arrested * 1000] Points)<BR>
		<B>Operatives Killed:</B> [score_opkilled] ([score_opkilled * 250] Points)<BR>
		<B>Station Destroyed:</B> [score_nuked ? "Yes" : "No"] (-[nukedpenalty] Points)<BR>
		<B>All Operatives Arrested:</B> [score_allarrested ? "Yes" : "No"] (Score tripled)<BR>
		<HR>"}
	if (ticker.mode.name == "revolution")
		var/foecount = 0
		var/comcount = 0
		var/revcount = 0
		var/loycount = 0
		for(var/datum/mind/M in ticker.mode:head_revolutionaries)
			if (M.current && M.current.stat != 2) foecount++
		for(var/datum/mind/M in ticker.mode:revolutionaries)
			if (M.current && M.current.stat != 2) revcount++
		for(var/mob/living/carbon/human/player in mobz)
			if(player.mind)
				var/role = player.mind.assigned_role
				if(role in list("Captain", "Head of Security", "Head of Personnel", "Chief Engineer", "Research Director"))
					if (player.stat != 2) comcount++
				else
					if(player.mind in ticker.mode:revolutionaries) continue
					loycount++
		for(var/mob/living/silicon/X in mobz)
			if (X.stat != 2) loycount++
		var/revpenalty = 10000
		dat += {"<B><U>MODE STATS</U></B><BR>
		<B>Number of Surviving Revolution Heads:</B> [foecount]<BR>
		<B>Number of Surviving Command Staff:</B> [comcount]<BR>
		<B>Number of Surviving Revolutionaries:</B> [revcount]<BR>
		<B>Number of Surviving Loyal Crew:</B> [loycount]<BR><BR>
		<B>Revolution Heads Arrested:</B> [score_arrested] ([score_arrested * 1000] Points)<BR>
		<B>Revolution Heads Slain:</B> [score_opkilled] ([score_opkilled * 500] Points)<BR>
		<B>Command Staff Slain:</B> [score_deadcommand] (-[score_deadcommand * 500] Points)<BR>
		<B>Revolution Successful:</B> [score_traitorswon ? "Yes" : "No"] (-[score_traitorswon * revpenalty] Points)<BR>
		<B>All Revolution Heads Arrested:</B> [score_allarrested ? "Yes" : "No"] (Score tripled)<BR>
		<HR>"}

	dat += {"<B><U>GENERAL STATS</U></B><BR>
	<U>THE GOOD:</U><BR>
	<B>Useful Items Shipped:</B> [score_stuffshipped] ([score_stuffshipped * 5] Points)<BR>
	<B>Hydroponics Harvests:</B> [score_stuffharvested] ([score_stuffharvested * 5] Points)<BR>
	<B>Ore Mined:</B> [score_oremined] ([score_oremined * 2] Points)<BR>
	<B>Refreshments Prepared:</B> [score_meals] ([score_meals * 5] Points)<BR>
	<B>Research Completed:</B> [score_researchdone] ([score_researchdone * 30] Points)<BR>
	<B>Cyborgs Constructed:</B> [score_cyborgsmade] ([score_cyborgsmade * 50] Points)<BR>"}
	if (emergency_shuttle.location == 2) dat += "<B>Shuttle Escapees:</B> [score_escapees] ([score_escapees * 25] Points)<BR>"
	dat += {"<B>Random Events Endured:</B> [score_eventsendured] ([score_eventsendured * 50] Points)<BR>
	<B>Whole Station Powered:</B> [score_powerbonus ? "Yes" : "No"] ([score_powerbonus * 2500] Points)<BR>
	<B>Ultra-Clean Station:</B> [score_mess ? "No" : "Yes"] ([score_messbonus * 3000] Points)<BR><BR>
	<U>THE BAD:</U><BR>
	<B>Dead Bodies on Station:</B> [score_deadcrew] (-[score_deadcrew * 25] Points)<BR>
	<B>Uncleaned Messes:</B> [score_mess] (-[score_mess] Points)<BR>
	<B>Station Power Issues:</B> [score_powerloss] (-[score_powerloss * 20] Points)<BR>
	<B>Rampant Diseases:</B> [score_disease] (-[score_disease * 30] Points)<BR>
	<B>AI Destroyed:</B> [score_deadaipenalty ? "Yes" : "No"] (-[score_deadaipenalty * 250] Points)<BR><BR>
	<U>THE WEIRD</U><BR>
	<B>Final Station Budget:</B> [getBalance("GAYBUTTHOLES")]<BR>"}
	dat += {"<B>Food Eaten:</b> [score_foodeaten]<BR>
	<B>Money Spent:</B> Ð[score_moneyspent]<BR>
	<B>Money Earned:</B> Ð[score_moneyearned]<BR>
	<B>Inflation Taxes:</B> Ð[getInflation()]<BR>
	<B>Cigarettes Smoked:</b> [score_cigssmoked]<BR>
	<B>Times a Clown was Abused:</B> [score_clownabuse]<BR><BR>"}
	if (score_escapees)
		dat += {"
		<B>Most Battered Escapee:</B> [score_dmgestname], [score_dmgestjob]: [score_dmgestdamage] damage ([score_dmgestkey])<BR>"}
	else
		if (emergency_shuttle.location != 2) dat += "The station wasn't evacuated!<BR>"
		else dat += "No-one escaped!<BR>"
	dat += {"<HR><BR>
	<B><U>FINAL SCORE: [score_crewscore]</U></B><BR>"}
	var/score_rating = "The Aristocrats!"
	switch(score_crewscore)
		if(-99999 to -50000) score_rating = "Even the Singularity Deserves Better"
		if(-49999 to -5000) score_rating = "Singularity Fodder"
		if(-4999 to -1000) score_rating = "You're All Fired"
		if(-999 to -500) score_rating = "A Waste of Perfectly Good Oxygen"
		if(-499 to -250) score_rating = "A Wretched Heap of Scum and Incompetence"
		if(-249 to -100) score_rating = "Outclassed by Lab Monkeys"
		if(-99 to -21) score_rating = "The Undesirables"
		if(-20 to 20) score_rating = "Ambivalently Average"
		if(21 to 99) score_rating = "Not Bad, but Not Good"
		if(100 to 249) score_rating = "Skillful Servants of Science"
		if(250 to 499) score_rating = "Best of a Good Bunch"
		if(500 to 999) score_rating = "Lean Mean Machine Thirteen"
		if(1000 to 4999) score_rating = "Promotions for Everyone"
		if(5000 to 9999) score_rating = "Ambassadors of Discovery"
		if(10000 to 49999) score_rating = "The Pride of Science Itself"
		if(50000 to 59999) score_rating = "NanoTrasen's Finest"
		if(60000 to INFINITY) score_rating = "<img src=\"http://s1.d2k5.com/Erika1/winner_2.png\">"
	dat += "<B><U>RATING:</U></B> [score_rating]"
	src << browse(dat, "window=roundstats;size=500x600")
	return
