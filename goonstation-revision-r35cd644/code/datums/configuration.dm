/datum/configuration
	var/server_name = null				// server name (for world name / status)
	var/server_suffix = 0				// generate numeric suffix based on server port
	var/server_region = null

	var/server_specific_configs = 0		// load extra config files (by port)

	var/update_check_enabled = 0				// Server will call world.Reboot after checking for update if this is on
	var/dmb_filename = "goonstation"

	var/medal_hub = null				// medal hub name
	var/medal_password = null			// medal hub password

	//Note: All logging configs are for logging to the diary out of game. Does not affect in-game logs!
	var/log_ooc = 0						// log OOC channel
	var/log_access = 0					// log login/logout
	var/log_say = 0						// log client say
	var/log_admin = 0					// log admin actions
	var/log_game = 0					// log game events
	var/log_vote = 0					// log voting
	var/log_whisper = 0					// log client whisper
	var/log_ahelp = 0					// log admin helps
	var/log_mhelp = 0					// log mentor helps
	var/log_combat = 0					// log combat events
	var/log_station = 0					// log station events (includes legacy build)
	var/log_telepathy = 0				// log telepathy events
	var/log_debug = 0					// log debug events
	var/log_vehicles = 0					//I feel like this is a better place for listing who entered what, than the admin log.

	var/allow_vote_restart = 0 			// allow votes to restart
	var/allow_vote_mode = 0				// allow votes to change mode
	var/allow_admin_jump = 1			// allows admin jumping
	var/allow_admin_sounds = 1			// allows admin sound playing
	var/allow_admin_spawning = 1		// allows admin item spawning
	var/allow_admin_rev = 1				// allows admin revives
	var/vote_delay = 600				// minimum time between voting sessions (seconds, 10 minute default)
	var/vote_period = 60				// length of voting period (seconds, default 1 minute)
	var/vote_no_default = 0				// vote does not default to nochange/norestart (tbi)
	var/vote_no_dead = 0				// dead people can't vote (tbi)

	var/list/mode_names = list()
	var/list/modes = list()				// allowed modes
	var/list/votable_modes = list()		// votable modes
	var/list/probabilities = list()		// relative probability of each mode
	var/allow_ai = 1					// allow ai job
	var/hostedby = null
	var/respawn = 1

	// MySQL
	var/sql_enabled = 0
	var/sql_hostname = "localhost"
	var/sql_port = 3306
	var/sql_username = null
	var/sql_password = null
	var/sql_database = null

	// Player notes base URL
	var/player_notes_baseurl = "http://playernotes.ss13.co/"

	// Server list for cross-bans and other stuff
	var/list/servers = list()
	var/crossbans = 0
	var/crossban_password = null

	//IRC Bot stuff
	var/irclog_url = null
	var/ircbot_api = null

	//External server configuration (for central bans etc)
	var/extserver_hostname = null
	var/extserver_token = null
	var/extserver_web_token = null

	//Environment
	var/env = "prod"
	var/cdn = ""
	var/disableResourceCache = 0

/datum/configuration/New()
	var/list/L = typesof(/datum/game_mode) - /datum/game_mode
	for (var/T in L)
		// I wish I didn't have to instance the game modes in order to look up
		// their information, but it is the only way (at least that I know of).
		var/datum/game_mode/M = new T()

		if (M.config_tag)
			if(!(M.config_tag in modes))		// ensure each mode is added only once
				diary << "Adding game mode [M.name] ([M.config_tag]) to configuration."
				src.modes += M.config_tag
				src.mode_names[M.config_tag] = M.name
				src.probabilities[M.config_tag] = M.probability
				if (M.votable)
					src.votable_modes += M.config_tag
		qdel(M)

/datum/configuration/proc/load(filename)
	var/text = file2text(filename)

	if (!text)
		diary << "No '[filename]' file found, setting defaults"
		src = new /datum/configuration()
		return

	diary << "Reading configuration file '[filename]'"

	var/list/CL = dd_text2list(text, "\n")

	for (var/t in CL)
		if (!t)
			continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		if (pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)

		if (!name)
			continue

		switch (name)
			if ("log_ooc")
				config.log_ooc = 1

			if ("log_access")
				config.log_access = 1

			if ("log_say")
				config.log_say = 1

			if ("log_admin")
				config.log_admin = 1

			if ("log_game")
				config.log_game = 1

			if ("log_vote")
				config.log_vote = 1

			if ("log_whisper")
				config.log_whisper = 1

			if ("log_ahelp")
				config.log_ahelp = 1

			if ("log_mhelp")
				config.log_mhelp = 1

			if ("log_combat")
				config.log_combat = 1

			if ("log_station")
				config.log_station = 1

			if ("log_telepathy")
				config.log_telepathy = 1

			if ("log_debug")
				config.log_debug = 1

			if ("log_vehicles")
				config.log_vehicles = 1

			if ("allow_vote_restart")
				config.allow_vote_restart = 0

			if ("allow_vote_mode")
				config.allow_vote_mode = 0

			if ("allow_admin_jump")
				config.allow_admin_jump = 1

			if ("allow_admin_sound")
				config.allow_admin_sounds = 1

			if ("allow_admin_rev")
				config.allow_admin_rev = 1

			if ("allow_admin_spawning")
				config.allow_admin_spawning = 1

			if ("no_dead_vote")
				config.vote_no_dead = 1

			if ("default_no_vote")
				config.vote_no_default = 1

			if ("vote_delay")
				config.vote_delay = text2num(value)

			if ("vote_period")
				config.vote_period = text2num(value)

			if ("allow_ai")
				config.allow_ai = 1

			if ("norespawn")
				config.respawn = 0

			if ("servername")
				config.server_name = value

			if ("serversuffix")
				config.server_suffix = 1

			if ("serverregion")
				config.server_region = value

			if ("medalhub")
				config.medal_hub = value

			if ("medalpass")
				config.medal_password = value

			if ("hostedby")
				config.hostedby = value

			if ("probability")
				var/prob_pos = findtext(value, " ")
				var/prob_name = null
				var/prob_value = null

				if (prob_pos)
					prob_name = lowertext(copytext(value, 1, prob_pos))
					prob_value = copytext(value, prob_pos + 1)
					if (prob_name in config.modes)
						config.probabilities[prob_name] = text2num(prob_value)
					else
						diary << "Unknown game mode probability configuration definition: [prob_name]."
				else
					diary << "Incorrect probability configuration definition: [prob_name]  [prob_value]."

			if ("use_mysql")
				config.sql_enabled = 1

			if ("mysql_hostname")
				config.sql_hostname = trim(value)

			if ("mysql_port")
				config.sql_port = text2num(value)

			if ("mysql_username")
				config.sql_username = trim(value)

			if ("mysql_password")
				config.sql_password = trim(value)

			if ("mysql_database")
				config.sql_database = trim(value)

			if ("server_specific_configs")
				config.server_specific_configs = 1

			if ("servers")
				for(var/sv in dd_text2list(trim(value), " "))
					sv = trim(sv)
					if(sv)
						config.servers.Add(sv)

			if ("use_crossbans")
				config.crossbans = 1
			if ("crossban_password")
				config.crossban_password = trim(value)

			if ("irclog_url")
				config.irclog_url = trim(value)
			if ("ircbot_api")
				config.ircbot_api = trim(value)

			if ("ticklag")
				world.tick_lag = text2num(value)

			if ("extserver_hostname")
				config.extserver_hostname = trim(value)
			if ("extserver_token")
				config.extserver_token = trim(value)
			if ("extserver_web_token")
				config.extserver_web_token = trim(value)
			if ("update_check_enabled")
				config.update_check_enabled = 1
			if ("dmb_filename")
				config.dmb_filename = trim(value)
			if ("env")
				config.env = trim(value)
			if ("cdn")
				config.cdn = trim(value)
			if ("disable_resource_cache")
				config.disableResourceCache = 1
			else
				diary << "Unknown setting in configuration: '[name]'"

	//Environment config overrides
	if (!CDN_ENABLED)
		config.cdn = ""

/datum/configuration/proc/pick_mode(mode_name)
	// I wish I didn't have to instance the game modes in order to look up
	// their information, but it is the only way (at least that I know of).
	for (var/T in (typesof(/datum/game_mode) - /datum/game_mode))
		var/datum/game_mode/M = new T()
		if (M.config_tag && M.config_tag == mode_name)
			return M
		qdel(M)

	return null

/datum/configuration/proc/pick_random_mode()
	var/total = 0
	var/list/accum = list()

	for(var/M in src.modes)
		total += src.probabilities[M]
		accum[M] = total

	var/r = total - (rand() * total)

	var/mode_name = null
	for (var/M in modes)
		if (src.probabilities[M] > 0 && accum[M] >= r)
			mode_name = M
			break

	if (!mode_name)
		boutput(world, "Failed to pick a random game mode.")
		return null

	//boutput(world, "Returning mode [mode_name]")

	return src.pick_mode(mode_name)

/datum/configuration/proc/get_used_mode_names()
	var/list/names = list()

	for (var/M in src.modes)
		if (src.probabilities[M] > 0)
			names += src.mode_names[M]

	return names
