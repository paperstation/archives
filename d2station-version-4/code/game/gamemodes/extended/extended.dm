/datum/game_mode/extended
	name = "extended"
	config_tag = "extended"
	var/const/swaittime_l = 60000 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/swaittime_h = 80000 //upper bound on time before intercept arrives (in tenths of seconds)

/datum/game_mode/announce()
	world << "<B>The current game mode is - Extended Role-Playing!</B>"
	world << "<B>Just have fun and role-play!</B>"

/datum/game_mode/extended/pre_setup()
	//setup_sectors()
	return 1

/*/datum/game_mode/extended/post_setup()
	spawn (rand(swaittime_l, swaittime_h))
		emergency_shuttle.incall()
		world << "\blue <B>Alert: The transport shuttle has been called by centcom. It will arrive in [round(emergency_shuttle.timeleft()/60)] minutes.</B>"
		world << sound('shuttlecalled.ogg')
		extendedshuttlesent = 1*/

/datum/game_mode/extended/can_start()
	return (num_players() > 0)