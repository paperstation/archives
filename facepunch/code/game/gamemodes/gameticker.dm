var/global/datum/controller/gameticker/ticker

#define GAME_STATE_PREGAME		1
#define GAME_STATE_SETTING_UP	2
#define GAME_STATE_PLAYING		3
#define GAME_STATE_FINISHED		4

var/totalPlayers = 0
var/totalPlayersReady = 0

/datum/controller/gameticker
	var/const/restart_timeout = 250
	var/current_state = GAME_STATE_PREGAME

	var/hide_mode = 0
	var/datum/game_mode/mode = null
	var/event_time = null
	var/event = 0

	var/login_music			// music played in pregame lobby

	var/list/datum/mind/minds = list()//The people in the game. Used for objective tracking.

	var/Bible_icon_state	// icon_state the chaplain has chosen for his bible
	var/Bible_item_state	// item_state the chaplain has chosen for his bible
	var/Bible_name			// name of the bible
	var/Bible_deity_name

	var/random_players = 0 	// if set to nonzero, ALL players who latejoin or declare-ready join will have random appearances/genders

	var/list/syndicate_coalition = list() // list of traitor-compatible factions
	var/list/factions = list()			  // list of all factions
	var/list/availablefactions = list()	  // list of factions with openings

	var/pregame_timeleft = 180

	var/delay_end = 0	//if set to nonzero, the round will not restart on it's own

	var/triai = 0//Global holder for Triumvirate

/datum/controller/gameticker/proc/pregame()

	login_music = pickweight(list('sound/ambience/title2.ogg' = 33, 'sound/ambience/title1.ogg' = 32, 'sound/ambience/title3.ogg' = 32, 'sound/ambience/clown.ogg' = 1, 'sound/ambience/title4.ogg' = 1)) // choose title music!
	//login_music = pickweight(list('sound/ambience/title4.ogg')) //Love the way you move
	if(Holiday == "April Fool's Day")
		login_music = 'sound/ambience/clown.ogg'
	else if(Holiday == "Halloween")
		login_music = 'sound/ambience/TheRideNeverEnds.ogg'
//	if(Holiday == "Casino Night")
//		login_music = pickweight(list('sound/ambience/title2.ogg' = 33, 'sound/ambience/title1.ogg' = 16.5, 'sound/ambience/title3.ogg' = 16.5, 'sound/ambience/retroclub.ogg' = 33))
	for(var/mob/new_player/M in mob_list)
		if(M.client)	M.client.playtitlemusic()

	do
		pregame_timeleft = 180
		world << "<B><FONT color='blue'>Welcome to the pre-game lobby!</FONT></B>"
		world << "Please, setup your character and select ready. Game will start in [pregame_timeleft] seconds"
		while(current_state == GAME_STATE_PREGAME)
			sleep(10)
			if(going && --pregame_timeleft <= 0)
				current_state = GAME_STATE_SETTING_UP
	while(!setup())


/datum/controller/gameticker/proc/setup()
	//Create and announce mode
	if(master_mode=="secret")
		src.hide_mode = 1
	var/list/datum/game_mode/runnable_modes
	if((master_mode=="random") || (master_mode=="secret"))
		runnable_modes = config.get_runnable_modes()
		if (runnable_modes.len==0)
			current_state = GAME_STATE_PREGAME
			world << "<B>Unable to choose playable game mode.</B> Reverting to pre-game lobby."
			return 0
		if(secret_force_mode != "secret")
			var/datum/game_mode/M = config.pick_mode(secret_force_mode)
			if(M.can_start())
				src.mode = config.pick_mode(secret_force_mode)
		job_master.ResetOccupations()
		if(!src.mode)
			src.mode = pickweight(runnable_modes)
		if(src.mode)
			var/mtype = src.mode.type
			src.mode = new mtype
	else
		src.mode = config.pick_mode(master_mode)
	if (!src.mode.can_start())
		world << "<B>Unable to start [mode.name].</B> Not enough players, [mode.required_players] players needed. Reverting to pre-game lobby."
		del(mode)
		current_state = GAME_STATE_PREGAME
		job_master.ResetOccupations()
		return 0

	//Configure mode and assign player to special mode stuff
	job_master.DivideOccupations() //Distribute jobs
	var/can_continue = src.mode.pre_setup()//Setup special modes
	if(!can_continue)
		del(mode)
		current_state = GAME_STATE_PREGAME
		world << "<B>Error setting up [master_mode].</B> Reverting to pre-game lobby."
		job_master.ResetOccupations()
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

	create_characters() //Create player characters and transfer them
	collect_minds()
	equip_characters()
	data_core.manifest()
	current_state = GAME_STATE_PLAYING

	spawn(0)//Forking here so we dont have to wait for this to finish
		mode.post_setup()
		//Cleanup some stuff
		for(var/obj/effect/landmark/start/S in landmarks_list)
			//Deleting Startpoints but we need the ai point to AI-ize people later
			if (S.name != "AI")
				del(S)
		world << "<FONT color='blue'><B>Enjoy the game!</B></FONT>"
		world << sound('sound/AI/welcome.ogg') // Skie
		//Holiday Round-start stuff	~Carn
		Holiday_Game_Start()

	start_events() //handles random events and space dust. old random system
//new random event system is handled from the MC.

	var/admins_number = 0
	for(var/client/C)
		if(C.holder)
			admins_number++
	if(admins_number == 0)
		send2irc("Server", "Round just started with no admins online!")

	master_controller.process()		//Start master_controller.process()
	return 1

/datum/controller/gameticker
	//station_explosion used to be a variable for every mob's hud. Which was a waste!
	//Now we have a general cinematic centrally held within the gameticker....far more efficient!
	var/obj/screen/cinematic = null

	//Plus it provides an easy way to make cinematics for other events. Just use this as a template :)
	proc/station_explosion_cinematic(var/z_level_nuked = 0, var/override = null)
		if(cinematic)	return	//already a cinematic in progress!

		//initialise our cinematic screen object
		cinematic = new(src)
		cinematic.icon = 'icons/effects/station_explosion.dmi'
		cinematic.icon_state = "station_intact"
		cinematic.layer = 20
		cinematic.mouse_opacity = 0
		cinematic.screen_loc = "1,0"

		for(var/mob/M in player_list)
			if(istype(M,/mob/living))
				M.monkeyizing = 1//Prevents people from moving
			if(M.client && M.client.screen)
				M.client.screen += cinematic	//show every client the cinematic
		spawn(90)
			for(var/mob/living/M in player_list)
				M.monkeyizing = 0//you can move again

		if(mode && !override)
			override = mode.name

		switch(override)
			if("nuclear emergency")
				flick("intro_nuke",cinematic)
				sleep(35)
				if(z_level_nuked == 1)
					flick("station_explode_fade_red",cinematic)
					cinematic.icon_state = "summary_nukewin"
//				else//Nuke changes make this irrelevant.
//					flick("station_intact_fade_red",cinematic)
//					cinematic.icon_state = "summary_nukefail"
				world << sound('sound/effects/explosionfar.ogg')

			if("AI malfunction") //Malf (screen,explosion,summary)
				flick("intro_malf",cinematic)
				sleep(76)
				flick("station_explode_fade_red",cinematic)
				world << sound('sound/effects/explosionfar.ogg')
				cinematic.icon_state = "summary_malf"
			if("blob") //Station nuked (nuke,explosion,summary)
				flick("intro_nuke",cinematic)
				sleep(35)
				if(z_level_nuked == 1)
					flick("station_explode_fade_red",cinematic)
				else
					flick("station_intact_fade_red",cinematic)
				world << sound('sound/effects/explosionfar.ogg')

			if("microwave")
				flick("intro_nuke",cinematic)
				sleep(35)
				flick("station_intact_fade_red",cinematic)
				for(var/obj/machinery/microwave/O in world)
					if(O.z == 1)
						explosion(O.loc, -1, 1, 2, 5)
						spawn(40)
							if(O)
								del(O)
				//world << sound('sound/effects/explosionfar.ogg')

			else //Station nuked (nuke,explosion,summary)
				flick("intro_nuke",cinematic)
				sleep(35)
				if(z_level_nuked == 1)
					flick("station_explode_fade_red", cinematic)
					cinematic.icon_state = "summary_selfdes"
				else
					flick("station_intact_fade_red",cinematic)
				world << sound('sound/effects/explosionfar.ogg')


		for(var/mob/living/M in living_mob_list)
			if(M.stat == DEAD)
				continue
			if(M.z == 0)//Inside a locker or such
				var/turf/T = get_turf(M)
				if(!T)
					continue
				if(T.z != z_level_nuked)
					M.unlock_achievement("Was that the microwave?")
					continue
			if(M.z != z_level_nuked && M.z != 0)
				M.unlock_achievement("Was that the microwave?")
				continue
			M.unlock_achievement("Atomized")
			M.death()

		//If its actually the end of the round, wait for it to end.
		//Otherwise if its a verb it will continue on afterwards.
		sleep(300)
		if(cinematic)	del(cinematic)		//end the cinematic
		return


	proc/create_characters()
		for(var/mob/new_player/player in player_list)
			if(player.ready && player.mind)
				if(player.mind.assigned_role=="AI")
					player.close_spawn_windows()
					player.AIize()
				else
					player.create_character()
					del(player)


	proc/collect_minds()
		for(var/mob/living/player in player_list)
			if(player.mind)
				ticker.minds += player.mind


	proc/equip_characters()
		var/captainless=1
		for(var/mob/living/carbon/human/player in player_list)
			if(player && player.mind && player.mind.assigned_role)
				if(player.mind.assigned_role == "Captain")
					captainless=0
				if(player.mind.assigned_role != "MODE")
					job_master.EquipRank(player, player.mind.assigned_role, 0)
		if(captainless)
			for(var/mob/M in player_list)
				if(!istype(M,/mob/new_player))
					M << "Captainship not forced on anyone."

/**/
	proc/process()
		if(current_state != GAME_STATE_PLAYING)
			return 0
		mode.process()

		emergency_shuttle.process()

		if(!mode.explosion_in_progress && mode.check_finished())
			current_state = GAME_STATE_FINISHED

			spawn
				declare_completion()
				display_end_round()

			spawn(50)
				if (mode.station_was_nuked)
					feedback_set_details("end_proper","nuke")
					if(!delay_end)
						world << "\blue <B>Rebooting due to destruction of station in [restart_timeout/10] seconds</B>"
				else
					feedback_set_details("end_proper","proper completion")
					if(!delay_end)
						world << "\blue <B>Restarting in [restart_timeout/10] seconds</B>"

				if(!delay_end)
					var/F = file("data/consistent.ini")//Because of how this works, it can't be done until after the shuttle docks
					fdel(F)
					F << vouchers
					sleep(restart_timeout)

					world.Reboot()
				else
					world << "\blue <B>An admin has delayed the round end</B>"
					var/F = file("data/consistent.ini")//Save it because admin
					fdel(F)
					F << vouchers
		return 1


	proc/getfactionbyname(var/name)
		for(var/datum/faction/F in factions)
			if(F.name == name)
				return F


/*
	var/list/new_records = new
	new_records["Gold"] = max(gold, text2num(records["Gold"]))
	if(world.SetScores(key, list2params(new_records)))
		src << "Your journey has been recorded in the annals of [win ? "victory" : "failure"]."
		else
		src << "Sorry, the hub could not be contacted to record your score."
*/
/datum/controller/gameticker/proc/declare_completion()
	vouchers += 1
/*
	var/F = file("data/consistent.ini")//Rewrite the old var with the new one
	fdel(F)
	F << vouchers
	for(var/mob/D in world)
		if(D.client)
			var/params = list("Completed Rounds"=1)
			D.addscore(D.key, list2params(params))
	//		world.SetScores(D.key, list2params(params))
	*/
	var/text = "<div align='center'><B>Round statistics listed below:</B><br><br> General Statistics:"
	for (var/mob/living/silicon/ai/aiPlayer in mob_list)
		if (aiPlayer.stat != 2)
			text += "<br><br><b>[aiPlayer.name] (Played by: [aiPlayer.key])'s laws at the end of the game were:</b>"
		else
			text += "<br><br><b>[aiPlayer.name] (Played by: [aiPlayer.key])'s laws when it was deactivated were:</b>"
		text += aiPlayer.show_laws(1, 1)

		if (aiPlayer.connected_robots.len)
			var/robolist = "<br><br><b>The AI's loyal minions were:</b> "
			for(var/mob/living/silicon/robot/robo in aiPlayer.connected_robots)
				robolist += "[robo.name][robo.stat?" (Deactivated) (Played by: [robo.key]), ":" (Played by: [robo.key]), "]"
			text += " [robolist]"

	for (var/mob/living/silicon/robot/robo in mob_list)
		if (!robo.connected_ai)
			if (robo.stat != 2)
				text += "<br><br><b>[robo.name] (Played by: [robo.key]) survived as an AI-less borg! Its laws were:</b>"
			else
				text += "<br><br><b>[robo.name] (Played by: [robo.key]) was unable to survive the rigors of being a cyborg without an AI. Its laws were:</b>"

			if(robo) //How the hell do we lose robo between here and the world messages directly above this?
				text +=	robo.laws.show_laws(world, 1)

	outputstats +=  "<br>[text]<br>"
	mode.declare_completion()//To declare normal completion.

	//calls auto_declare_completion_* for all modes
	for(var/handler in typesof(/datum/game_mode/proc))
		if (findtext("[handler]","auto_declare_completion_"))
			call(mode, handler)()

	//Print a list of antagonists to the server log
	var/list/total_antagonists = list()
	//Look into all mobs in world, dead or alive
	for(var/datum/mind/Mind in minds)
		var/temprole = Mind.special_role
		if(temprole)							//if they are an antagonist of some sort.
			if(temprole in total_antagonists)	//If the role exists already, add the name to it
				total_antagonists[temprole] += ", [Mind.name]([Mind.key])"
			else
				total_antagonists.Add(temprole) //If the role doesnt exist in the list, create it and add the mob
				total_antagonists[temprole] += ": [Mind.name]([Mind.key])"

	//Now print them all into the log!
	log_game("Antagonists at round end were...")
	for(var/i in total_antagonists)
		log_game("[i]s[total_antagonists[i]].")
	if(religionname)
		outputstats += "<br>Religion: [religionname]"
	if(Bible_deity_name)
		outputstats += "<br>Deity Name: [Bible_deity_name]"

	outputstats += "<br><br>Misc statistics:"
	if(achivements_unlocked > 0)
		feedback_set("achivements_unlocked",achivements_unlocked)
		outputstats += "<br>[achivements_unlocked] achievement(s) were unlocked this round."
	if(surgery_preformed > 0)
		feedback_set("surgery_preformed",surgery_preformed)
		outputstats += "<br>[surgery_preformed] surgerie(s) were completed this round."
	if(snap_pops > 0)
		feedback_set("snap_pops",snap_pops)
		outputstats += "<br>[snap_pops] snap pops were thrown this round."
	if(suicides_dead > 0)
		feedback_set("suicides_dead",suicides_dead)
		outputstats += "<br>[suicides_dead] crew member(s) got rid of themselves."
	if(aliens_born > 0)
		feedback_set("aliens_born",aliens_born)
		outputstats += "<br>[aliens_born] crew member(s) became parent(s) to an alien larva."
	if(cores_smashed > 0)
		feedback_set("cores_smashed",cores_smashed)
		outputstats += "<br>[cores_smashed] adamantite cores were smashed."
	if(failed_tele > 0)
		feedback_set("failed_tele",failed_tele)
		outputstats += "<br>[failed_tele] crew member(s) went through a malfunctioning hand teleporter portal."
	if(areas_made > 0)
		feedback_set("areas_made",areas_made)
		outputstats += "<br>[areas_made] new areas were made."
	if(flush_disp > 0)
		feedback_set("flush_disp",flush_disp)
		outputstats += "<br>[flush_disp] disposals were flushed."
	if(record_bans > 0)
		feedback_set("record_bans",record_bans)
		outputstats += "<br>[record_bans] person/people were banned."
	if(vouchers > 0)
		feedback_set("vouchers_total",vouchers)
		outputstats += "<br>The station has [vouchers] vouchers."
	return 1

/datum/controller/gameticker/proc/display_end_round()

	fdel("config/endlogs.txt")
	text2file(outputstats, "config/endlogs.txt")

	for (var/mob/M in player_list)
		M << browse(outputstats,"window=endround;size=600x700;can_close=1")

	return