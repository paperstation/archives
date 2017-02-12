//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/mob/new_player
	var/ready = 0
	var/spawning = 0//Referenced when you want to delete the new_player later on in the code.

	invisibility = 101

	density = 0
	stat = 2
	canmove = 0

	anchored = 1	//  don't get pushed around

	New()
		mob_list += src

	verb/new_player_panel()
		set src = usr
		new_player_panel_proc()


	proc/new_player_panel_proc()

		var/output = "<div align='center'><B>New Player Options</B>"
		output +="<hr>"
		output += "<p><a href='?_src_=prefs;'>Setup Character/Preferences</A></p>"

		if(!ticker || ticker.current_state <= GAME_STATE_PREGAME)
			if(!ready)	output += "<p><a href='byond://?src=\ref[src];ready=1'>Declare Ready</A></p>"
			else	output += "<p><b>You are ready</b> (<a href='byond://?src=\ref[src];ready=2'>Cancel</A>)</p>"

		else
			output += "<p><a href='byond://?src=\ref[src];late_join=1'>Join Game!</A></p>"

		output += "<p><a href='byond://?src=\ref[src];observe=1'>Observe</A></p>"

		output += "<p><a href='byond://?src=\ref[src];quickpanel=1'>Quick Menu</A></p>"

		output += "</div>"

		src << browse(output,"window=playersetup;size=210x240;can_close=0")
		return

	Stat()
		..()


		if(ticker && statpanel("Lobby"))
			stat("Game Mode:", ticker.hide_mode ? "Secret" : "[master_mode]")

			if(ticker.current_state == GAME_STATE_PREGAME)
				stat("Time To Start:", going ? ticker.pregame_timeleft : "DELAYED")

				totalPlayers = 0
				totalPlayersReady = 0

				for(var/mob/new_player/player in player_list)
					stat("[player.key]", (player.ready)?("(Playing)"):(null))
					++totalPlayers
					if(player.ready) ++totalPlayersReady

				stat("Players: [totalPlayers]", "Players Ready: [totalPlayersReady]")

	Topic(href, href_list[])
		if(!client)	return 0

		if(href_list["quickpanel"])
			client.menu()

		if(href_list["ready"])
			ready = !ready

		if(href_list["refresh"])
			new_player_panel_proc()

		if(href_list["observe"])

			if(alert(src,"Are you sure you wish to observe? You will not be able to play this round!","Player Setup","Yes","No") == "Yes")
				if(!client)	return 1
				var/mob/dead/observer/observer = new()

				spawning = 1
				src << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1) // MAD JAMS cant last forever yo

				observer.started_as_observer = 1
				close_spawn_windows()
				var/obj/O = locate("landmark*Observer-Start")
				src << "\blue Now teleporting."
				if(O)
					observer.loc = O.loc
				else
					observer.x = 50
					observer.y = 50
					observer.z = 1
				var/name = client.prefs.real_name ? client.prefs.real_name : random_name(client.prefs.gender)
				observer.show_antags = 1
				observer.real_name = name
				observer.name = name
				observer.key = key

				del(src)
				return 1

		if(href_list["late_join"])
			if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
				usr << "\red The round is either not ready, or has already finished..."
				return
			LateChoices()

		if(href_list["SelectedJob"])

			if(!enter_allowed)
				usr << "\blue There is an administrative lock on entering the game!"
				return

			AttemptLateSpawn(href_list["SelectedJob"])
			return

		if(!ready && href_list["preference"])
			if(client)
				client.prefs.process_link(src, href_list)
		else if(!href_list["late_join"])
			new_player_panel()



	proc/IsJobAvailable(Job ,rank)
		var/datum/job/job = Job
		if(!job)	return 0
		if(!client)	return 0
		if((job.current_positions >= job.total_positions) && job.total_positions != -1)	return 0
		if(jobban_isbanned(src,rank))	return 0
		if(job.available_in_days(client.prefs))	return 0
		return 1


	proc/AttemptLateSpawn(rank)
		var/datum/job/job = job_master.GetJob(rank)
		if(!IsJobAvailable(job, rank))
			src << alert("[rank] is not available. Please try another.")
			return 0

		job_master.AssignRole(src, rank, job.job_title, 1)

		var/mob/living/carbon/human/character = create_character()	//creates the human and transfers vars and mind
		job_master.EquipRank(character, rank, 1)					//equips the human
		character.loc = pick(latejoin)
		character.lastarea = get_area(loc)

		if(character.mind.assigned_role != "Cyborg")
			data_core.manifest_inject(character)
			ticker.minds += character.mind//Cyborgs and AIs handle this in the transform proc.	//TODO!!!!! ~Carn
			AnnounceArrival(character, rank)
		else
			character.Robotize()
		del(src)


	proc/AnnounceArrival(var/mob/living/carbon/human/character, var/rank)
		if (ticker.current_state == GAME_STATE_PLAYING)
			var/ailist[] = list()
			for (var/mob/living/silicon/ai/A in living_mob_list)
				ailist += A
			if (ailist.len)
				var/mob/living/silicon/ai/announcer = pick(ailist)
				if(character.mind)
					if((character.mind.assigned_role != "Cyborg") && (character.mind.special_role != "MODE"))
						announcer.say("[character.real_name] has arrived on the station.")//signed up as [rank].")
			else
				var/announcerlist[] = list()
				for (var/mob/living/simple_animal/announcer/B in living_mob_list)
					announcerlist += B
				if (announcerlist.len)
					var/mob/living/simple_animal/announcer = pick(announcerlist)
					if(character.mind)
						if((character.mind.assigned_role != "Cyborg") && (character.mind.special_role != "MODE"))
							announcer.say("[character.real_name] has arrived on the station.")//signed up as [rank].")



	proc/LateChoices()
		var/mills = world.time // 1/10 of a second, not real milliseconds but whatever
		//var/secs = ((mills % 36000) % 600) / 10 //Not really needed, but I'll leave it here for refrence.. or something
		var/mins = (mills % 36000) / 600
		var/hours = mills / 36000

		var/dat = "<html><body><center>"
		dat += "Round Duration: [round(hours)]h [round(mins)]m<br>"

		if(emergency_shuttle) //In case Nanotrasen decides reposess CentComm's shuttles.
			if(emergency_shuttle.direction == 2) //Shuttle is going to centcomm, not recalled
				dat += "<font color='red'><b>The station has been evacuated.</b></font><br>"
			if(emergency_shuttle.direction == 1 && emergency_shuttle.timeleft() < 300) //Shuttle is past the point of no recall
				dat += "<font color='red'>The station is currently undergoing evacuation procedures.</font><br>"

		dat += "Choose from the following open positions:<br>"
		for(var/datum/job/job in job_master.occupations)
			if(job && IsJobAvailable(job, job.title))
				dat += "<a href='byond://?src=\ref[src];SelectedJob=[job.title]'>[job.title] ([job.current_positions])</a><br>"

		dat += "</center>"
		src << browse(dat, "window=latechoices;size=300x640;can_close=1")


	proc/create_character()
		spawning = 1
		close_spawn_windows()

		var/mob/living/carbon/human/new_character = new(loc)
		new_character.lastarea = get_area(loc)

		if(ticker.random_players)
			new_character.gender = pick(MALE, FEMALE)
			client.prefs.real_name = random_name()
			client.prefs.randomize_appearance_for(new_character)
		else
			client.prefs.copy_to(new_character)

		src << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1) // MAD JAMS cant last forever yo

		if(mind)
			mind.active = 0					//we wish to transfer the key manually
			if(mind.job_title)//If we have a title we need to edit the realname
				new_character.real_name = mind.job_title + " " + new_character.real_name
			if(mind.assigned_role == "Clown")				//give them a clownname if they are a clown
				new_character.real_name = "Clown " + get_preferred_clown_name(ckey)
			mind.original = new_character
			mind.transfer_to(new_character)					//won't transfer key since the mind is not active

		new_character.name = new_character.real_name
		new_character.dna.ready_dna(new_character)
		new_character.dna.b_type = client.prefs.b_type

		new_character.key = key		//Manually transfer the key to log them in
		if(Holiday == "The End")
			new_character.unlock_achievement("The End of Something")
		else
			new_character.startofsomething("The Start of Something")

		return new_character


	Move()
		return 0


	proc/close_spawn_windows()
		src << browse(null, "window=latechoices") //closes late choices window
		src << browse(null, "window=playersetup") //closes the player setup window
