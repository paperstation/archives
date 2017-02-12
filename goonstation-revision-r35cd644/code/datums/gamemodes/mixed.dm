/datum/game_mode/mixed
	name = "mixed"
	config_tag = "mixed"
	latejoin_antag_compatible = 1
	latejoin_antag_roles = list("traitor", "changeling", "vampire", "wrestler")

	var/const/traitors_possible = 8 // cogwerks - lowered from 10
	var/list/traitor_types = list("traitor","changeling","vampire")

	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 1800 //upper bound on time before intercept arrives (in tenths of seconds)

/datum/game_mode/mixed/announce()
	boutput(world, "<B>The current game mode is - Mixed!</B>")
	boutput(world, "<B>Anything could happen! Be on your guard!</B>")

/datum/game_mode/mixed/pre_setup()
	var/num_players = 0
	for(var/mob/new_player/player in mobs)
		if(player.client && player.ready) num_players++

	var/i = rand(25)
	var/num_enemies = 1

	if(traitor_scaling)
		num_enemies = max(1, min(round((num_players + i) / 10), traitors_possible)) // adjust divisor as needed

	var/num_wizards = 0
	var/num_traitors = 0
	var/num_changelings = 0
	var/num_vampires = 0
	var/num_grinches = 0
	var/num_wraiths = 0
	var/num_blobs = 0
#ifdef XMAS
	src.traitor_types += "grinch"
	src.latejoin_antag_roles += "grinch"
#endif

	if ((num_enemies >= 4 && prob(20)) || debug_mixed_forced_wraith || debug_mixed_forced_blob)
		if (prob(50) || debug_mixed_forced_wraith)
			num_enemies = max(num_enemies - 4, 1)
			num_wraiths = 1
		else
			num_enemies = max(num_enemies - 4, 1)
			num_blobs = 1
	for(var/j = 0, j < num_enemies, j++)
		if(prob(10)) // powerful combat roles
			num_wizards++
			// if any combat roles end up in this mode they go here ok
		else // more stealthy roles
			switch(pick(src.traitor_types))
				if("traitor") num_traitors++
				if("changeling") num_changelings++
				if("vampire") num_vampires++
				if("grinch") num_grinches++

	token_players = antag_token_list()
	for(var/datum/mind/tplayer in token_players)
		if (!token_players.len)
			break
		switch(pick("wizard", "traitor", "changeling", "vampire", "wraith", "blob"))
			if("wizard")
				traitors += tplayer
				token_players.Remove(tplayer)
				tplayer.assigned_role = "MODE"
				tplayer.special_role = "wizard"
				//num_wizards = max(0, num_wizards -1)
			if("traitor")
				traitors += tplayer
				token_players.Remove(tplayer)
				tplayer.special_role = "traitor"
				//num_traitors = max(0, num_traitors -1)
			if("changeling")
				traitors += tplayer
				token_players.Remove(tplayer)
				tplayer.special_role = "changeling"
				//num_changelings = max(0, num_changelings -1)
			if("vampire")
				traitors += tplayer
				token_players.Remove(tplayer)
				tplayer.special_role = "vampire"
				//num_vampires = max(0, num_vampires -1)
			if("wraith")
				traitors += tplayer
				token_players.Remove(tplayer)
				tplayer.special_role = "wraith"
				//num_wraiths = max(0, num_wraiths -1)
			if("blob")
				traitors += tplayer
				token_players.Remove(tplayer)
				tplayer.special_role = "blob"
				//num_blobs = max(0, num_blobs -1)
		logTheThing("admin", tplayer.current, null, "successfully redeemed an antag token.")
		message_admins("[key_name(tplayer.current)] successfully redeemed an antag token.")

	if(num_wizards)
		var/list/possible_wizards = get_possible_enemies("wizard",num_wizards)
		for(var/j = 0, j < num_wizards, j++)
			if (!possible_wizards.len)
				break
			var/datum/mind/wizard = pick(possible_wizards)
			traitors += wizard
			possible_wizards.Remove(wizard)
			wizard.assigned_role = "MODE"
			wizard.special_role = "wizard"

	if(num_traitors)
		var/list/possible_traitors = get_possible_enemies("traitor",num_traitors)
		for(var/j = 0, j < num_traitors, j++)
			if (!possible_traitors.len)
				break
			var/datum/mind/traitor = pick(possible_traitors)
			traitors += traitor
			possible_traitors.Remove(traitor)
			traitor.special_role = "traitor"

	if(num_changelings)
		var/list/possible_changelings = get_possible_enemies("changeling",num_changelings)
		for(var/j = 0, j < num_changelings, j++)
			if (!possible_changelings.len)
				break
			var/datum/mind/changeling = pick(possible_changelings)
			traitors += changeling
			possible_changelings.Remove(changeling)
			changeling.special_role = "changeling"

	if(num_vampires)
		var/list/possible_vampires = get_possible_enemies("vampire",num_vampires)
		for(var/j = 0, j < num_vampires, j++)
			if (!possible_vampires.len)
				break
			var/datum/mind/vampire = pick(possible_vampires)
			traitors += vampire
			possible_vampires.Remove(vampire)
			vampire.special_role = "vampire"

	if(num_wraiths)
		var/list/possible_wraiths = get_possible_enemies("wraith",num_wraiths)
		for(var/j = 0, j < num_wraiths, j++)
			if (!possible_wraiths.len)
				break
			var/datum/mind/wraith = pick(possible_wraiths)
			traitors += wraith
			possible_wraiths.Remove(wraith)
			wraith.special_role = "wraith"

	if(num_blobs)
		var/list/possible_blobs = get_possible_enemies("blob",num_blobs)
		for(var/j = 0, j < num_blobs, j++)
			if (!possible_blobs.len)
				break
			var/datum/mind/blob = pick(possible_blobs)
			traitors += blob
			possible_blobs.Remove(blob)
			blob.special_role = "blob"

	if(num_grinches)
		var/list/possible_grinches = get_possible_enemies("grinch",num_grinches)
		for(var/j = 0, j < num_grinches, j++)
			if (!possible_grinches.len)
				break
			var/datum/mind/grinch = pick(possible_grinches)
			traitors += grinch
			possible_grinches.Remove(grinch)
			grinch.special_role = "grinch"

	if(!traitors) return 0

	return 1

/datum/game_mode/mixed/post_setup()
	var/objective_set_path = null

	for (var/datum/mind/traitor in traitors)
		objective_set_path = null // Gotta reset this.

		if (traitor.assigned_role == "Chaplain" && traitor.special_role == "vampire")
			// vamp will burn in the chapel before he can react
			if (prob(50))
				traitor.special_role = "traitor"
			else
				traitor.special_role = "changeling"

		switch (traitor.special_role)
			if ("traitor")
				var/role = traitor.current.mind.assigned_role
				if (role in list("Captain","Head of Personnel","Head of Security","Chief Engineer","Research Director","Medical Director"))
					objective_set_path = pick(typesof(/datum/objective_set/traitor/hard))
				else
					objective_set_path = pick(typesof(/datum/objective_set/traitor/easy))
				equip_traitor(traitor.current)

			if ("changeling")
				objective_set_path = /datum/objective_set/changeling
				traitor.current.make_changeling()

			if ("wizard")
				objective_set_path = pick(typesof(/datum/objective_set/traitor/easy))
				traitor.current.unequip_all(1)

				if (wizardstart.len == 0)
					boutput(traitor.current, "<B><span style=\"color:red\">A starting location for you could not be found, please report this bug!</span></B>")
				else
					var/starting_loc = pick(wizardstart)
					traitor.current.set_loc(starting_loc)

				equip_wizard(traitor.current)

				var/randomname
				if (traitor.current.gender == "female")
					randomname = pick(wiz_female)
				else
					randomname = pick(wiz_male)

				spawn (0)
					var/newname = input(traitor.current,"You are a Wizard. Would you like to change your name to something else?", "Name change",randomname)

					if (length(ckey(newname)) == 0)
						newname = randomname

					if (newname)
						if (length(newname) >= 26) newname = copytext(newname, 1, 26)
						newname = dd_replacetext(newname, ">", "'")
						traitor.current.real_name = newname
						traitor.current.name = newname

			if ("wraith")
				generate_wraith_objectives(traitor)

			if ("vampire")
				objective_set_path = /datum/objective_set/vampire
				traitor.current.make_vampire()

			if ("predator")
				objective_set_path = /datum/objective_set/predator
				traitor.current.show_text("<h2><font color=red><B>You are a predator!</B></font></h2>", "red")
				traitor.current.make_predator()

			if ("grinch")
				objective_set_path = /datum/objective_set/grinch
				boutput(traitor.current, "<h2><font color=red><B>You are a grinch!</B></font></h2>")
				traitor.current.make_grinch()

			if ("blob")
				objective_set_path = /datum/objective_set/blob
				spawn (0)
					var/newname = input(traitor.current, "You are a Blob. Please choose a name for yourself, it will show in the form: <name> the Blob", "Name change") as text

					if (newname)
						if (length(newname) >= 26) newname = copytext(newname, 1, 26)
						newname = dd_replacetext(newname, ">", "'") + " the Blob"
						traitor.current.real_name = newname
						traitor.current.name = newname

		if (!isnull(objective_set_path)) // Cannot create objects of type null. [wraiths use a special proc]
			new objective_set_path(traitor)
		var/obj_count = 1
		for (var/datum/objective/objective in traitor.objectives)
			boutput(traitor.current, "<B>Objective #[obj_count]</B>: [objective.explanation_text]")
			obj_count++

	spawn (rand(waittime_l, waittime_h))
		send_intercept()

/datum/game_mode/mixed/proc/get_possible_enemies(type,number)
	var/list/candidates = list()

	for(var/mob/new_player/player in mobs)
		if (ishellbanned(player)) continue //No treason for you
		if ((player.client) && (player.ready) && !(player.mind in traitors) && !(player.mind in token_players) && !candidates.Find(player.mind))
			switch(type)
				if("wizard")
					if(player.client.preferences.be_wizard) candidates += player.mind
				if("traitor")
					if(player.client.preferences.be_traitor) candidates += player.mind
				if("changeling")
					if(player.client.preferences.be_changeling) candidates += player.mind
				if("vampire")
					if(player.client.preferences.be_vampire) candidates += player.mind
				if("wraith")
					if(player.client.preferences.be_wraith) candidates += player.mind
				if("blob")
					if(player.client.preferences.be_blob) candidates += player.mind
				else
					if(player.client.preferences.be_misc) candidates += player.mind

	if(candidates.len < number)
		if(type in list("wizard","traitor","changeling", "wraith", "blob"))
			logTheThing("debug", null, null, "<b>Enemy Assignment</b>: Only [candidates.len] players with be_[type] set to yes were ready. We need [number] so including players who don't want to be [type]s in the pool.")
		else
			logTheThing("debug", null, null, "<b>Enemy Assignment</b>: Not enough players with be_misc set to yes, including players who don't want to be misc enemies in the pool for [type] assignment.")

		for(var/mob/new_player/player in mobs)
			if (ishellbanned(player)) continue //No treason for you
			if ((player.client) && (player.ready) && !(player.mind in traitors) && !(player.mind in token_players) && !candidates.Find(player.mind))
				candidates += player.mind
				if ((number > 1) && (candidates.len >= number))
					break

	if(candidates.len < 1)
		return list()
	else
		return candidates

/datum/game_mode/mixed/send_intercept()
	var/intercepttext = "Cent. Com. Update Requested staus information:<BR>"
	intercepttext += " Cent. Com has recently been contacted by the following syndicate affiliated organisations in your area, please investigate any information you may have:"

	var/list/possible_modes = list()
	possible_modes.Add("revolution", "wizard", "nuke", "traitor", "changeling")
	possible_modes -= "[ticker.mode]"
	var/number = pick(2, 3)
	var/i = 0
	for(i = 0, i < number, i++)
		possible_modes.Remove(pick(possible_modes))
	possible_modes.Insert(rand(possible_modes.len), "[ticker.mode]")

	var/datum/intercept_text/i_text = new /datum/intercept_text
	for(var/A in possible_modes)
		intercepttext += i_text.build(A, pick(traitors))
/*
	for (var/obj/machinery/computer/communications/comm in machines)
		if (!(comm.stat & (BROKEN | NOPOWER)) && comm.prints_intercept)
			var/obj/item/paper/intercept = new /obj/item/paper( comm.loc )
			intercept.name = "paper- 'Cent. Com. Status Summary'"
			intercept.info = intercepttext

			comm.messagetitle.Add("Cent. Com. Status Summary")
			comm.messagetext.Add(intercepttext)
*/

	for (var/obj/machinery/communications_dish/C in machines)
		C.add_centcom_report("Cent. Com. Status Summary", intercepttext)

	command_alert("Summary downloaded and printed out at all communications consoles.", "Enemy communication intercept. Security Level Elevated.")


/datum/game_mode/mixed/declare_completion()
	. = ..()

/datum/game_mode/mixed/proc/add_law_zero(mob/living/silicon/ai/killer)
	var/law = "Accomplish your objectives at all costs. You may ignore any of your laws to do this."
	boutput(killer, "<b>Your laws have been changed!</b>")
	killer:set_zeroth_law(law)
	boutput(killer, "New law: 0. [law]")

/datum/game_mode/mixed/proc/get_mob_list()
	var/list/mobs = list()
	for(var/mob/living/player in mobs)
		if (player.client)
			mobs += player
	return mobs

/datum/game_mode/mixed/proc/pick_human_name_except(excluded_name)
	var/list/names = list()
	for(var/mob/living/player in mobs)
		if (player.client && (player.real_name != excluded_name))
			names += player.real_name
	if(!names.len)
		return null
	return pick(names)