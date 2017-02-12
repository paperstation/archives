/datum/game_mode
	var/name = "invalid" // Don't implement ticker.mode.name or .config_tag checks again, okay? I've had to swap them all to get game mode children to work.
	var/config_tag = null // Use istype(ticker.mode, /datum/game_mode/whatever) instead.
	var/votable = 1
	var/probability = 0 // Overridden by the server config. If you don't have access to that repo, keep it 0.
	var/crew_shortage_enabled = 1
	var/shuttle_available = 1 // 0: Won't dock. | 1: Normal. | 2: Won't dock if called too early.
	var/shuttle_available_threshold = 12000 // 20 min. Only works when shuttle_available == 2.

	var/latejoin_antag_compatible = 0 // Ultimately depends on the global 'late_traitors' setting, though.
	var/latejoin_only_if_all_antags_dead = 0 // Don't spawn 'em until all antagonists are dead.
	var/list/latejoin_antag_roles = list() // Unrecognized roles default to traitor in mob/new_player/proc/makebad().

	var/list/datum/mind/traitors = list() // enemies assigned at round start
	var/list/datum/mind/token_players = list() //players redeeming an antag token
	var/list/datum/mind/Agimmicks = list() // admin assigned and certain gimmick enemies
	var/list/datum/mind/former_antagonists = list() // For mindslaves and rogue cyborgs we'd want to show in the game over stats (Convair880).

/datum/game_mode/proc/announce()
	boutput(world, "<B>[src] did not define announce()</B>")

/datum/game_mode/proc/pre_setup()
	return 1

/datum/game_mode/proc/post_setup()

// yes. fucking manufacturers
// Fuck.
// F U C K
/datum/game_mode/proc/post_post_setup()

/datum/game_mode/proc/process()

/datum/game_mode/proc/check_finished()
	if(emergency_shuttle.location==2)
		return 1
	return 0

// Did some streamlining here (Convair880).
/datum/game_mode/proc/declare_completion()
	var/list/datum/mind/antags = list()

	for (var/datum/mind/traitor in traitors)
		antags.Add(traitor)
	for (var/datum/mind/various in Agimmicks)
		antags.Add(various)

	for (var/datum/mind/traitor in antags)
		var/traitorwin = 1
		var/traitor_name

		if (traitor.current)
			traitor_name = "[traitor.current.real_name] (played by [traitor.key])"
		else
			traitor_name = "[traitor.key] (character destroyed)"

		if (traitor.special_role == "mindslave")
			boutput(world, "<B>[traitor_name] was a mindslave!</B>")
			continue // Objectives are irrelevant for mindslaves and thralls.
		else if (traitor.special_role == "vampthrall")
			boutput(world, "<B>[traitor_name] was a vampire's thrall!</B>")
			continue // Ditto.
		else
			if (traitor.late_special_role)
				boutput(world, "<B>[traitor_name] was a late-joining [traitor.special_role]!</B>")
			else if (traitor.random_event_special_role)
				boutput(world, "<B>[traitor_name] was a random event [traitor.special_role]!</B>")
			else
				boutput(world, "<B>[traitor_name] was a [traitor.special_role]!</B>")

			if (traitor.special_role == "changeling" && traitor.current)
				var/dna_absorbed = 0
				var/datum/abilityHolder/changeling/C = traitor.current.get_ability_holder(/datum/abilityHolder/changeling)
				if (C && istype(C))
					dna_absorbed = max(0, C.absorbtions)
				else
					dna_absorbed = "N/A (body destroyed)"
				boutput(world, "<B>Absorbed DNA:</b> [dna_absorbed]")

			if (traitor.special_role == "vampire" && traitor.current)
				var/blood_acquired = 0
				if (isvampire(traitor.current))
					blood_acquired = traitor.current.get_vampire_blood(1)
				else
					blood_acquired = "N/A (body destroyed)"
				boutput(world, "<B>Blood acquired:</b>  [blood_acquired][isnum(blood_acquired) ? " units" : ""]")

			if (traitor.special_role == "werewolf")
				// Werewolves may not have the feed objective, so we don't want to make this output universal.
				for (var/datum/objective/specialist/werewolf/feed/O in traitor.objectives)
					if (O && istype(O, /datum/objective/specialist/werewolf/feed/))
						boutput(world, "<B>No. of victims:</b> [O.mobs_fed_on.len]")

			if (traitor.special_role == "predator")
				// Same reasoning here, really.
				for (var/datum/objective/specialist/predator/trophy/T in traitor.objectives)
					if (traitor.current && T && istype(T, /datum/objective/specialist/predator/trophy))
						var/S = traitor.current.get_skull_value()
						boutput(world, "<B>Combined trophy value:</b> [S]")

			if (traitor.special_role == "traitor")
				var/purchases = traitor.purchased_traitor_items.len
				var/surplus = traitor.traitor_crate_items.len
				boutput(world, "<b>They purchased [purchases <= 0 ? "nothing" : "[purchases] item[s_es(purchases)]"] with their telecrystals![purchases <= 0 ? " [pick("Wow", "Dang", "Gosh", "Good work", "Good job")]!" : null]</b>")
				if (purchases)
					var/item_detail = "They purchased: "
					for (var/i in traitor.purchased_traitor_items)
						item_detail += "[bicon(i:item)] [i:name], "
					item_detail = copytext(item_detail, 1, -2)
					if (surplus)
						item_detail += "<br>Their surplus crate contained: "
						for (var/i in traitor.traitor_crate_items)
							item_detail += "[bicon(i:item)] [i:name], "
						item_detail = copytext(item_detail, 1, -2)
					boutput(world, item_detail)

			var/count = 1
			for (var/datum/objective/objective in traitor.objectives)
#ifdef CREW_OBJECTIVES
				if (istype(objective, /datum/objective/crew)) continue
#endif
				if (istype(objective, /datum/objective/miscreant)) continue

				if (objective.check_completion())
					boutput(world, "<B>Objective #[count]</B>: [objective.explanation_text] <span style=\"color:green\"><B>Success</B></span>")
					if (!isnull(objective.medal_name) && !isnull(traitor.current))
						traitor.current.unlock_medal(objective.medal_name, objective.medal_announce)
				else
					boutput(world, "<B>Objective #[count]</B>: [objective.explanation_text] <span style=\"color:red\">Failed</span>")
					traitorwin = 0
				count++

		// Please use objective.medal_name for medals that are tied to a specific objective instead of adding them here.
		if (traitorwin)
			if (traitor.current)
				traitor.current.unlock_medal("MISSION COMPLETE", 1)
			if (traitor.special_role == "wizard" && traitor.current)
				traitor.current.unlock_medal("You're no Elminster!", 1)
			if (traitor.special_role == "wrestler" && traitor.current)
				traitor.current.unlock_medal("Cream of the Crop", 1)
			boutput(world, "<B>The [traitor.special_role] was successful!<B>")
		else
			boutput(world, "<B>The [traitor.special_role] has failed!<B>")

#ifdef DATALOGGER
		if (traitorwin)
			game_stats.Increment("traitorwin")
			score_traitorswon += 1
		else
			game_stats.Increment("traitorloss")
#endif

	// Their antag status is revoked on death/implant removal/expiration, but we still want them to show up in the game over stats (Convair880).
	for (var/datum/mind/traitor in former_antagonists)
		var/traitor_name

		if (traitor.current)
			traitor_name = "[traitor.current.real_name] (played by [traitor.key])"
		else
			traitor_name = "[traitor.key] (character destroyed)"

		if (traitor.former_antagonist_roles.len)
			for (var/string in traitor.former_antagonist_roles)
				if (string == "mindslave")
					boutput(world, "<B>[traitor_name] was a mindslave!</B>")
				else if (string == "vampthrall")
					boutput(world, "<B>[traitor_name] was a vampire's thrall!</B>")
				else
					boutput(world, "<B>[traitor_name] was a [string]!</B>")

	return 1

/datum/game_mode/proc/check_win()

/datum/game_mode/proc/send_intercept()

////////////////////////////
// Objective related code //
////////////////////////////

/datum/game_mode/proc/bestow_objective(var/datum/mind/traitor,var/objective_path)
	if (!istype(traitor) || !ispath(objective_path))
		return null

	var/datum/objective/O = new objective_path
	O.owner = traitor
	O.set_up()
	traitor.objectives += O

	return O

/datum/game_mode/proc/bestow_random_escape_objective(var/datum/mind/traitor,var/allow_hijack = 0)
	if (!istype(traitor) || !isnum(allow_hijack))
		return null

	var/upperbound = 3
	if (allow_hijack)
		upperbound = 4

	var/objective_path = null
	var/picker = rand(1,upperbound)
	switch(picker)
		if(1)
			objective_path = /datum/objective/escape
		if(2)
			objective_path = /datum/objective/escape/survive
		if(3)
			objective_path = /datum/objective/escape/kamikaze
		if(4)
			objective_path = /datum/objective/escape/hijack

	var/datum/objective/O = new objective_path
	O.owner = traitor
	O.set_up()
	traitor.objectives += O

	return O