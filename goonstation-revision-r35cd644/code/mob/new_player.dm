mob/new_player
	anchored = 1

	var/ready = 0
	var/spawning = 0
	var/keyd
	var/adminspawned = 0

	invisibility = 101

	density = 0
	stat = 2
	canmove = 0

	anchored = 1	//  don't get pushed around

	// How could this even happen? Regardless, no log entries for unaffected mobs (Convair880).
	ex_act(severity)
		return

	disposing()
		mobs.Remove(src)
		if (mind)
			if (mind.current == src)
				mind.current = null

			mind = null

		key = null
		..()

	Login()
		..()

		if(!mind)
			mind = new(src)
			keyd = mind.key

		// moved the below to /client/New() so mentor-related preference loading works properly
		/*if ((NT.Find(ckey(mind.key)) || mentors.Find(ckey(mind.key))) && !admins.Find(ckey(mind.key)))
			client.mentor = 1
			client.mentor_authed = 1*/

		new_player_panel()
		var/starting_loc
		if (newplayer_start.len > 0)
			starting_loc = pick(newplayer_start)
		else
			starting_loc = locate(1,1,1)
		src.set_loc(starting_loc)
		src.sight |= SEE_TURFS
		var/list/watch_locations = list()
		for(var/obj/landmark/landmark in world)
			if(landmark.tag == "landmark*new_player")
				watch_locations += landmark.loc

		if(watch_locations.len>0)
			loc = pick(watch_locations)

		if (src.ckey && !adminspawned)
			if (spawned_in_keys.Find("[src.ckey]"))
				if (!(client && client.holder) && !abandon_allowed)
					 //They have already been alive this round!!
					var/mob/dead/observer/observer = new()

					src.spawning = 1

					close_spawn_windows()
					boutput(src, "<span style=\"color:blue\">Now teleporting.</span>")
					var/ASLoc = pick(observer_start)
					if (ASLoc)
						observer.set_loc(ASLoc)
					else
						observer.set_loc(locate(1, 1, 1))
					observer.key = key
					if(client.preferences.be_random_name)
						client.preferences.randomize_name()
					observer.name = client.preferences.real_name
					observer.real_name = observer.name

					qdel(src)

			else
				spawned_in_keys += "[src.ckey]"

	Logout()
		ready = 0
		if (src.ckey) //Null if the client changed to another mob, but not null if they disconnected.
			spawned_in_keys -= "[src.ckey]"
		..()
		close_spawn_windows()
		if(!spawning)
			qdel(src)
		return

	verb/new_player_panel()
		set src = usr
		if(client)
			winset(src, "joinmenu.button_charsetup", "is-disabled=false")
		// drsingh i put the extra ifs here. i think its dumb but there's a bad client error here so maybe it's somehow going away in winset because byond is shitty
		if(client)
			winset(src, "joinmenu.button_ready", "is-disabled=false;is-visible=true")
		if(client)
			winset(src, "joinmenu.button_cancel", "is-disabled=true;is-visible=false")
		if(client)
			winshow(src, "joinmenu", 1)
/*
		var/output = "<HR><B>New Player Options</B><BR>"
		output += "<HR><br><a href='byond://?src=\ref[src];show_preferences=1'>Setup Character</A><BR><BR>"
		if(!ticker || ticker.current_state <= GAME_STATE_PREGAME)
			if(!ready)
				output += "<a href='byond://?src=\ref[src];ready=1'>Declare Ready</A><BR>"
			else
				output += "You are ready.<BR>"
		else
			output += "<a href='byond://?src=\ref[src];late_join=1'>Join Game!</A><BR>"

		output += "<BR><a href='byond://?src=\ref[src];observe=1'>Observe</A><BR>"

		src << browse(output,"window=playersetup;size=250x200;can_close=0")
*/
	Stat()
		..()
		statpanel("Lobby")
		if(client.statpanel=="Lobby" && ticker)
			if(ticker.current_state == GAME_STATE_PREGAME)
				for(var/mob/new_player/player in mobs)
					if (player.client && player.client.holder && (player.client.stealth || player.client.alt_key)) // are they an admin and in stealth mode/have a fake key?
						if (client.holder) // are we an admin?
							stat("[player.key] (as [player.client.fakekey])", (player.ready)?("(Playing)"):(null)) // give us the full deets
						else // are we not an admin?
							stat("[player.client.fakekey]", (player.ready)?("(Playing)"):(null)) // only show the fake key
					else // are they a normal player or not in stealth mode/using a fake key?
						stat("[player.key]", (player.ready)?("(Playing)"):(null)) // show them normally

	Topic(href, href_list[])
		if(href_list["show_preferences"])
			client.preferences.ShowChoices(src)
			return 1

		if(href_list["ready"])
			if(!ready)
				if(alert(src,"Are you sure you are ready? This will lock-in your preferences.","Player Setup","Yes","No") == "Yes")
					ready = 1

		if(href_list["observe"])
			if(alert(src,"Are you sure you wish to observe? You will not be able to play this round!","Player Setup","Yes","No") == "Yes")
				var/mob/dead/observer/observer = new()

				src.spawning = 1

				close_spawn_windows()
				boutput(src, "<span style=\"color:blue\">Now teleporting.</span>")
				var/ASLoc = observer_start.len ? pick(observer_start) : locate(1, 1, 1)
				if (ASLoc)
					observer.set_loc(ASLoc)
				else
					observer.set_loc(locate(1, 1, 1))
				observer.apply_looks_of(client)

				if(src.mind)
					src.mind.dnr = 1
					src.mind.transfer_to(observer)
				else
					src.mind = new /datum/mind()
					src.mind.dnr = 1
					src.mind.transfer_to(observer)

				if(client.preferences.be_random_name)
					client.preferences.randomize_name()
				observer.name = client.preferences.real_name
				observer.real_name = observer.name
				src.client.loadResources()


				qdel(src)

		if(href_list["late_join"])
			LateChoices()

		if(href_list["SelectedJob"])
			if (src.spawning)
				return

			if (!enter_allowed)
				boutput(usr, "<span style=\"color:blue\">There is an administrative lock on entering the game!</span>")
				return

			if (ticker.mode && !istype(ticker.mode, /datum/game_mode/construction))
				var/list/alljobs = job_controls.staple_jobs | job_controls.special_jobs
				var/datum/job/JOB = locate(href_list["SelectedJob"]) in alljobs
				AttemptLateSpawn(JOB)
			else
				var/datum/game_mode/construction/C = ticker.mode
				var/datum/job/JOB = locate(href_list["SelectedJob"]) in C.enabled_jobs
				AttemptLateSpawn(JOB)

		if(href_list["preferences"])
			if (!ready)
				client.preferences.process_link(src, href_list)
		else if(!href_list["late_join"])
			new_player_panel()

	proc/IsJobAvailable(var/datum/job/JOB)
		if(!ticker || !ticker.mode)
			return 0
		if (!JOB || !istype(JOB,/datum/job/) || JOB.limit == 0)
			return 0
		if((ticker && ticker.mode && istype(ticker.mode, /datum/game_mode/revolution)) && istype(JOB,/datum/job/command/))
			return 0
		if (!JOB.no_jobban_from_this_job && jobban_isbanned(src,JOB.name))
			return 0
		if (JOB.requires_whitelist)
			if (!NT.Find(src.ckey))
				return 0
		if (JOB.limit < 0 || countJob(JOB.name) < JOB.limit)
			return 1
		return 0

	proc/AttemptLateSpawn(var/datum/job/JOB)
		if (!JOB)
			return

		if (JOB && IsJobAvailable(JOB))
			var/mob/character = create_character(JOB, JOB.allow_traitors)
			if (isnull(character))
				return

			if (ticker.current_state == GAME_STATE_PLAYING)
				//for (var/mob/living/silicon/ai/A in mobs)
				if (map_setting != "DESTINY")
					for (var/obj/machinery/computer/announcement/A in machines)
						if (!A.stat && A.announces_arrivals)
							A.announce_arrival("[character.real_name]","[JOB.name]")

#ifdef MAP_OVERRIDE_DESTINY
			var/obj/cryotron/starting_loc = null
			if (ishuman(character) && rp_latejoin && rp_latejoin.len)
				starting_loc = pick(rp_latejoin)

			if (istype(starting_loc))
				starting_loc.add_person_to_queue(character)
			else
				starting_loc = latejoin.len ? pick(latejoin) : locate(1, 1, 1)
				character.set_loc(starting_loc)
#else
			var/starting_loc = null
			starting_loc = latejoin.len ? pick(latejoin) : locate(1, 1, 1)
			character.set_loc(starting_loc)
#endif
			if (ishuman(character))
				var/mob/living/carbon/human/HC = character
				HC.Equip_Rank(JOB.name, joined_late=1)

			var/miscreant = 0
#ifdef MISCREANTS
			if (ticker && character.mind && JOB.allow_traitors != 0 && prob(10))
				if (map_setting != "DESTINY") // miscreants are causing issue in the rp setting atm
					ticker.generate_miscreant_objectives(character.mind)
					miscreant = 1
#endif

#ifdef CREW_OBJECTIVES
			if (ticker && character.mind && !miscreant)
				ticker.generate_individual_objectives(character.mind)
#endif

			if (manualbreathing)
				boutput(character, "<B>You must breathe manually using the *inhale and *exhale commands!</B>")
			if (manualblinking)
				boutput(character, "<B>You must blink manually using the *closeeyes and *openeyes commands!</B>")

			if (ticker && character.mind)
				//ticker.implant_skull_key() // This also checks if a key has been implanted already or not. If not then it'll implant a random sucker with a key.
				if (!(character.mind in ticker.minds))
					logTheThing("debug", character, null, "<b>Late join:</b> added player to ticker.minds.")
					ticker.minds += character.mind
				logTheThing("debug", character, null, "<b>Late join:</b> assigned job: [JOB.name]")

			spawn (0)
				qdel(src)

		else
			src << alert("[JOB.name] is not available. Please try another.")

		return

// This fxn creates positions for assistants based on existing positions. This could be more elgant.
	proc/LateChoices()
		var/dat = "<html><body><title>Select a Job</title>"
		dat += "Which job would you like?<br>"
		dat += "<table>"
		if (ticker.mode && !istype(ticker.mode, /datum/game_mode/construction))
			dat += "<tr>"
			dat += "<th><B><U>Command/Security</U></B><BR></th>"
			dat += "<th><B><U>Research</U></B><BR></th>"
			dat += "<th><B><U>Engineering</U></B><BR></th>"
			dat += "<th><B><U>Civilian</U></B><BR></th>"
			if (job_controls.allow_special_jobs)
				dat += "<th><B><U>Special Jobs</U></B><BR></th>"

			dat += "</tr><tr>"

			dat += {"<td valign="top"><center>"}
			for(var/datum/job/command/J in job_controls.staple_jobs)
				if (IsJobAvailable(J) && !J.no_late_join)
					dat += {"<a href='byond://?src=\ref[src];SelectedJob=\ref[J]'><font color=[J.linkcolor]>[J.name]</font></a><br>"}
			for(var/datum/job/security/J in job_controls.staple_jobs)
				if (IsJobAvailable(J) && !J.no_late_join)
					dat += {"<a href='byond://?src=\ref[src];SelectedJob=\ref[J]'><font color=[J.linkcolor]>[J.name]</font></a><br>"}
			dat += "</center></td>"

			dat += {"<td valign="top"><center>"}
			for(var/datum/job/research/J in job_controls.staple_jobs)
				if (IsJobAvailable(J) && !J.no_late_join)
					dat += {"<a href='byond://?src=\ref[src];SelectedJob=\ref[J]'><font color=[J.linkcolor]>[J.name]</font></a><br>"}
			dat += "</center></td>"

			dat += {"<td valign="top"><center>"}
			for(var/datum/job/engineering/J in job_controls.staple_jobs)
				if (IsJobAvailable(J) && !J.no_late_join)
					dat += {"<a href='byond://?src=\ref[src];SelectedJob=\ref[J]'><font color=[J.linkcolor]>[J.name]</font></a><br>"}
			dat += "</center></td>"

			dat += {"<td valign="top"><center>"}
			for(var/datum/job/civilian/J in job_controls.staple_jobs)
				if (IsJobAvailable(J) && !J.no_late_join)
					dat += {"<a href='byond://?src=\ref[src];SelectedJob=\ref[J]'><font color=[J.linkcolor]>[J.name]</font></a><br>"}

			for(var/datum/job/daily/J in job_controls.staple_jobs)
				if (IsJobAvailable(J) && !J.no_late_join)
					dat += {"<a href='byond://?src=\ref[src];SelectedJob=\ref[J]'><font color=[J.linkcolor]>[J.name]</font></a><br>"}

			dat += "</center></td>"


			if (job_controls.allow_special_jobs)
				dat += {"<td valign="top"><center>"}

				for(var/datum/job/special/J in job_controls.special_jobs)
					if (IsJobAvailable(J) && !J.no_late_join)
						dat += {"<a href='byond://?src=\ref[src];SelectedJob=\ref[J]'><font color=[J.linkcolor]>[J.name]</font></a><br>"}

				for(var/datum/job/created/J in job_controls.special_jobs)
					if (IsJobAvailable(J) && !J.no_late_join)
						dat += {"<a href='byond://?src=\ref[src];SelectedJob=\ref[J]'><font color=[J.linkcolor]>[J.name]</font></a><br>"}
				dat += "</center></td>"
			dat += "</tr>"
		else
			var/datum/game_mode/construction/C = ticker.mode
			if (!C.enabled_jobs.len)
				var/datum/job/engineering/construction_worker/D = new /datum/job/engineering/construction_worker()
				D.limit = -1
				C.enabled_jobs += D
			for (var/datum/job/J in C.enabled_jobs)
				if (IsJobAvailable(J) && !J.no_late_join)
					dat += "<tr><td style='width:100%'>"
					dat += {"<a href='byond://?src=\ref[src];SelectedJob=\ref[J]'><font color=[J.linkcolor]>[J.name]</font></a><br>"}
					dat += "</td></tr>"
		dat += "</table>"

		src << browse(dat, "window=latechoices;size=500x400;can_close=0")

	proc/create_character(var/datum/job/J, var/allow_late_antagonist = 0)
		if (!src || !src.mind || !src.client)
			return null
		if (!J)
			J = find_job_in_controller_by_string(src.mind.assigned_role)

		src.spawning = 1

		if(latejoin.len == 0)
			boutput(world, "No latejoin landmarks placed, dumping [src] to (1,1,1)")
			src.set_loc(locate(1,1,1))
		else
			src.set_loc(pick(latejoin))

		var/mob/new_character = null
		if (J)
			new_character = new J.mob_type(src.loc)
		else
			new_character = new /mob/living/carbon/human(src.loc) // fallback

		close_spawn_windows()

		client.preferences.copy_to(new_character,src)
		var/client/C = client
		mind.transfer_to(new_character)

		if (ishuman(new_character) && allow_late_antagonist && ticker.current_state == GAME_STATE_PLAYING && ticker.round_elapsed_ticks >= 6000 && emergency_shuttle.timeleft() >= 300 && !C.hellbanned) // no new evils for the first 10 minutes or last 5 before shuttle
			if (late_traitors && ticker.mode && ticker.mode.latejoin_antag_compatible == 1)
				var/livingtraitor = 0

				for(var/datum/mind/brain in ticker.minds)
					if(brain.current && checktraitor(brain.current)) // if a traitor
						if (issilicon(brain.current) || brain.current.stat & 2 || brain.current.client == null) // if a silicon mob, dead or logged out, skip
							continue

						livingtraitor = 1
						logTheThing("debug", null, null, "<b>Late join</b>: checking [new_character.ckey], found livingtraitor [brain.key].")
						break

				if ((!livingtraitor && prob(40)) || (livingtraitor && ticker.mode.latejoin_only_if_all_antags_dead == 0 && prob(4)))
					var/bad_type = null
					if (islist(ticker.mode.latejoin_antag_roles) && ticker.mode.latejoin_antag_roles.len)
						bad_type = pick(ticker.mode.latejoin_antag_roles)
					else
						bad_type = "traitor"

					makebad(new_character, bad_type)
					new_character.mind.late_special_role = 1
					logTheThing("debug", new_character, null, "<b>Late join</b>: assigned antagonist role.")

		if(new_character && new_character.client)
			new_character.client.loadResources()

		new_character.temporary_attack_alert(1200) //Messages admins if this new character attacks someone within 2 minutes of signing up. Might help detect grief, who knows?
		return new_character

	Move()
		return 1 // do not return 0 in here for the love of god, let me tell you the tale of why:
		// the default mob/Login (which got called before we actually set our loc onto the start screen), will attempt to put the mob at (1, 1, 1) if the loc is null
		// however, the documentation actually says "near" (1, 1, 1), and will count Move returning 0 as that it cannot be placed there
		// by "near" it means anywhere on the goddamn map where Move will return 1, this meant that anyone logging in would cause the server to
		// grind itself to a slow death in a caciphony of endless Move calls

	proc/makebad(var/mob/living/carbon/human/traitormob, type)
		if (!traitormob || !ismob(traitormob) || !traitormob.mind)
			return

		var/datum/mind/traitor = traitormob.mind
		ticker.mode.traitors += traitor

		var/objective_set_path = null
		switch (type)

			if ("traitor")
				traitor.special_role = "traitor"
				var/role = traitor.assigned_role
				if(role in list("Captain","Head of Personnel","Head of Security","Chief Engineer","Research Director"))
					objective_set_path = pick(typesof(/datum/objective_set/traitor/hard))
				else
					objective_set_path = pick(typesof(/datum/objective_set/traitor/easy))

			if ("changeling")
				traitor.special_role = "changeling"
				objective_set_path = /datum/objective_set/changeling
				traitormob.make_changeling()

			if ("vampire")
				traitor.special_role = "vampire"
				objective_set_path = /datum/objective_set/vampire
				traitormob.make_vampire()

			if ("wrestler")
				traitor.special_role = "wrestler"
				objective_set_path = pick(typesof(/datum/objective_set/traitor/easy))
				traitormob.make_wrestler(1)

			if ("grinch")
				traitor.special_role = "grinch"
				objective_set_path = /datum/objective_set/grinch
				traitormob.make_grinch()

			if ("predator")
				traitor.special_role = "predator"
				objective_set_path = /datum/objective_set/predator
				traitormob.make_predator()

			if ("werewolf")
				traitor.special_role = "werewolf"
				objective_set_path = /datum/objective_set/werewolf
				traitormob.make_werewolf()

			if ("wraith")
				traitor.special_role = "wraith"
				traitormob.make_wraith()
				generate_wraith_objectives(traitor)

			else // Fallback if role is unrecognized.
				traitor.special_role = "traitor"
				var/role = traitor.assigned_role
				if(role in list("Captain","Head of Personnel","Head of Security","Chief Engineer","Research Director"))
					objective_set_path = pick(typesof(/datum/objective_set/traitor/hard))
				else
					objective_set_path = pick(typesof(/datum/objective_set/traitor/easy))

		if (!isnull(objective_set_path))
			if (ispath(objective_set_path, /datum/objective_set))
				new objective_set_path(traitor)
			else if (ispath(objective_set_path, /datum/objective))
				ticker.mode.bestow_objective(traitor, objective_set_path)

		var/obj_count = 1
		for(var/datum/objective/objective in traitor.objectives)
			#ifdef CREW_OBJECTIVES
			if (istype(objective, /datum/objective/crew) || istype(objective, /datum/objective/miscreant)) continue
			#endif
			boutput(traitor.current, "<B>Objective #[obj_count]</B>: [objective.explanation_text]")
			obj_count++

	proc/close_spawn_windows()
		if(client)
			src << browse(null, "window=latechoices") //closes late choices window
			src << browse(null, "window=playersetup") //closes the player setup window
			winshow(src, "joinmenu", 0)
			winshow(src, "playerprefs", 0)

	verb/show_preferences()
		set hidden = 1
		set name = ".show_preferences"

		client.preferences.ShowChoices(src)

	verb/declare_ready()
		set hidden = 1
		set name = ".ready"

		if (ticker)
			if (ticker.mode)
				if (istype(ticker.mode, /datum/game_mode/construction))
					var/datum/game_mode/construction/C = ticker.mode
					if (C.in_setup)
						boutput(usr, "<span style=\"color:red\">The round is currently being set up. Please wait.</span>")
						return

		if(!ticker || ticker.current_state <= GAME_STATE_PREGAME)
			if(!ready)
				ready = 1
				if (usr.client) winset(src, "joinmenu.button_charsetup", "is-disabled=true")
				if (usr.client) winset(src, "joinmenu.button_ready", "is-disabled=true;is-visible=false")
				if (usr.client) winset(src, "joinmenu.button_cancel", "is-disabled=false;is-visible=true")
				usr << browse(null, "window=mob_occupation")
				if(master_mode in list("secret","traitor","nuclear","blob","wizard","changeling","mixed"))
					if (src.client.antag_tokens > 0) //If the player has any antag tokens available, check if they want to redeem one.
						if(alert(src,"Would you like to use an Antagonist Token for this round? (Modes that do not support redemption will not alter token balance.)","Remaining Tokens: [src.client.antag_tokens]","Yes","No") == "Yes")
							src.client.using_antag_token = 1
							src.show_text("Token redeemed, if mode supports redemption your new total will be [src.client.antag_tokens - 1].", "red")
				else
					if (src.client.antag_tokens > 0) //If the player has any antag tokens available, check if they want to redeem one.
						if(alert(src,"Would you like to use an Antagonist Token for this round? (Modes that do not support redemption will not alter token balance.)","Remaining Tokens: [src.client.antag_tokens]","Yes","No") == "Yes")
							src.show_text("Token redeemed, if mode supports redemption your new total will be [src.client.antag_tokens - 1].", "red")

				src.client.loadResources()
		else
			LateChoices()

	verb/cancel_ready()
		set hidden = 1
		set name = ".cancel_ready"

		if (ticker)
			if (ticker.mode)
				if (istype(ticker.mode, /datum/game_mode/construction))
					var/datum/game_mode/construction/C = ticker.mode
					if (C.in_setup)
						boutput(usr, "<span style=\"color:red\">You are already spawning, and cannot unready. Please wait until setup finishes.</span>")
						return

		if(ready)
			ready = 0
			winset(src, "joinmenu.button_charsetup", "is-disabled=false")
			winset(src, "joinmenu.button_ready", "is-disabled=false;is-visible=true")
			winset(src, "joinmenu.button_cancel", "is-disabled=true;is-visible=false")
			if (src.client.using_antag_token)
				src.client.using_antag_token = 0
				src.show_text("Token cancelled", "red")

	verb/observe_round()
		set hidden = 1
		set name = ".observe_round"

		if(alert(src,"Are you sure you wish to observe? You will not be able to play this round!","Player Setup","Yes","No") == "Yes")
			var/mob/dead/observer/observer = new()
			if (src.client.using_antag_token)
				src.client.using_antag_token = 0
				src.show_text("Token refunded, your new total is [src.client.antag_tokens].", "red")
			src.spawning = 1

			close_spawn_windows()
			boutput(src, "<span style=\"color:blue\">Now teleporting.</span>")
			var/ASLoc = observer_start.len ? pick(observer_start) : locate(1, 1, 1)
			if (ASLoc)
				observer.set_loc(ASLoc)
			observer.apply_looks_of(client)

			observer.observe_round = 1
			if(client.preferences && client.preferences.be_random_name) //Wire: fix for Cannot read null.be_random_name (preferences &&)
				client.preferences.randomize_name()
			observer.name = client.preferences.real_name

			if(!src.mind) src.mind = new(src)

			src.mind.dnr=1
			src.mind.transfer_to(observer)
			observer.real_name = observer.name
			if(observer && observer.client)
				observer.client.loadResources()

			qdel(src)