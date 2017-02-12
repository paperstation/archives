var/global/datum/controller/occupations/job_master

/datum/controller/occupations
		//List of all jobs
	var/list/occupations = list()
		//Players who need jobs
	var/list/unassigned = list()
		//Debug info
	var/list/job_debug = list()


	proc/SetupOccupations(var/faction = "Station")
		occupations = list()
		var/list/all_jobs = typesof(/datum/job)
		if(!all_jobs.len)
			world << "\red \b Error setting up jobs, no job datums found"
			return 0
		for(var/J in all_jobs)
			var/datum/job/job = new J()
			if(!job)	continue
			if(job.faction != faction)	continue
			occupations += job


		return 1


	proc/Debug(var/text)
		if(!Debug2)	return 0
		job_debug.Add(text)
		return 1


	proc/GetJob(var/rank)
		if(!rank)	return null
		for(var/datum/job/J in occupations)
			if(!J)	continue
			if(J.title == rank)	return J
		return null


	proc/AssignRole(var/mob/new_player/player, var/rank, var/title = null, var/latejoin = 0)
		Debug("Running AR, Player: [player], Rank: [rank], LJ: [latejoin]")
		if(player && player.mind && rank && player.client)
			var/datum/job/job = GetJob(rank)
			if(!job)	return 0

			var/datum/preferences/P = player.client.prefs
			if(P.isJobbanned(rank))	return 0
			if(job.available_in_days(P) > 0) return 0

			var/position_limit = job.total_positions
			if(!latejoin)
				position_limit = job.spawn_positions
			if((job.current_positions < position_limit) || position_limit == -1)
				Debug("Player: [player] is now Rank: [rank], JCP:[job.current_positions], JPL:[position_limit]")
				player.mind.assigned_role = rank
				player.mind.job_title = title
				unassigned -= player
				job.current_positions++
				return 1
		Debug("AR has failed, Player: [player], Rank: [rank]")
		return 0


	proc/FindOccupationCandidates(datum/job/job, level, flag)
		Debug("Running FOC, Job: [job], Level: [level], Flag: [flag]")
		var/list/candidates = list()
		for(var/mob/new_player/player in unassigned)
			if(!player.client)	continue
			var/datum/preferences/P = player.client.prefs

			if(P.isJobbanned(job.title))
				Debug("FOC isbanned failed, Player: [player]")
				continue

			if(job.available_in_days(P) > 0)
				Debug("FOC player not old enough, Player: [player]")
				continue

			if(flag && !(P.be_special & flag))
				Debug("FOC flag failed, Player: [player], Flag: [flag], ")
				continue

			if(P.GetJobDepartment(job, level) & job.flag)
				Debug("FOC pass, Player: [player], Level:[level]")
				candidates += player

		return candidates

	proc/ResetOccupations()
		for(var/mob/new_player/player in player_list)
			if((player) && (player.mind))
				player.mind.assigned_role = null
				player.mind.special_role = null
		SetupOccupations()
		unassigned = list()
		return


	///This proc is called before the level loop of DivideOccupations() and will try to select a head, ignoring ALL non-head preferences for every level until it locates a head or runs out of levels to check
	proc/FillHeadPosition()
		for(var/level = 1 to 5)
			for(var/command_position in command_positions)
				var/datum/job/job = GetJob(command_position)
				if(!job)	continue
				var/list/candidates = FindOccupationCandidates(job, level)
				if(!candidates.len)	continue
				var/mob/new_player/candidate = pick(candidates)
				if(AssignRole(candidate, command_position, job.job_title))
					return 1
		return 0


	///This proc is called at the start of the level loop of DivideOccupations() and will cause head jobs to be checked before any other jobs of the same level
	proc/CheckHeadPositions(var/level)
		for(var/command_position in command_positions)
			var/datum/job/job = GetJob(command_position)
			if(!job)	continue
			var/list/candidates = FindOccupationCandidates(job, level)
			if(!candidates.len)	continue
			var/mob/new_player/candidate = pick(candidates)
			AssignRole(candidate, command_position, job.job_title)
		return


	proc/FillAIPosition()
		var/ai_selected = 0
		var/datum/job/job = GetJob("AI")
		if(!job)	return 0
		if((job.title == "AI") && (config) && (!config.allow_ai))	return 0

		for(var/i = job.total_positions, i > 0, i--)
			for(var/level = 1 to 5)
				var/list/candidates = list()
				if(ticker.mode.name == "AI malfunction")//Make sure they want to malf if its malf
					candidates = FindOccupationCandidates(job, level, BE_MALF)
				else
					candidates = FindOccupationCandidates(job, level)
				if(candidates.len)
					var/mob/new_player/candidate = pick(candidates)
					if(AssignRole(candidate, "AI", null))
						ai_selected++
						break
			//Malf NEEDS an AI so force one if we didn't get a player who wanted it
			if((ticker.mode.name == "AI malfunction")&&(!ai_selected))
				unassigned = shuffle(unassigned)
				for(var/mob/new_player/player in unassigned)
					if(jobban_isbanned(player, "AI"))	continue
					if(AssignRole(player, "AI", null))
						ai_selected++
						break
			if(ai_selected)	return 1
			return 0


/** Proc DivideOccupations
 *  fills var "assigned_role" for all ready players.
 *  This proc must not have any side effect besides of modifying "assigned_role".
 **/
	proc/DivideOccupations()
		//Setup new player list and get the jobs list
		Debug("Running DO")
		SetupOccupations()

		//Holder for Triumvirate is stored in the ticker, this just processes it
		if(ticker)
			for(var/datum/job/ai/A in occupations)
				if(ticker.triai)
					A.spawn_positions = 3

		//Get the players who are ready
		for(var/mob/new_player/player in player_list)
			if(player.ready && player.mind && !player.mind.assigned_role)
				unassigned += player

		Debug("DO, Len: [unassigned.len]")
		if(unassigned.len == 0)	return 0

		//Shuffle players and jobs
		unassigned = shuffle(unassigned)

		HandleFeedbackGathering()

		//People who wants to be assistants, sure, go on.
		Debug("DO, Running Assistant Check 1")
		var/datum/job/assist = new /datum/job/assistant()
		var/list/assistant_candidates = FindOccupationCandidates(assist, 5)
		Debug("AC1, Candidates: [assistant_candidates.len]")
		for(var/mob/new_player/player in assistant_candidates)
			Debug("AC1 pass, Player: [player]")
			AssignRole(player, "Assistant", assist.job_title)
			assistant_candidates -= player
		Debug("DO, AC1 end")

		//Select one head
		Debug("DO, Running Head Check")
		FillHeadPosition()
		Debug("DO, Head Check end")

		//Check for an AI
		Debug("DO, Running AI Check")
		FillAIPosition()
		Debug("DO, AI Check end")

		//Other jobs are now checked
		Debug("DO, Running Standard Check")


		// New job giving system by Donkie
		// This will cause lots of more loops, but since it's only done once it shouldn't really matter much at all.
		// Hopefully this will add more randomness and fairness to job giving.

		// Loop through all levels from high to low
		var/list/shuffledoccupations = shuffle(occupations)
		for(var/level = 1 to 5)
			//Check the head jobs first each level
			CheckHeadPositions(level)

			// Loop through all unassigned players
			for(var/mob/new_player/player in unassigned)
				if(!player.client)	continue
				var/datum/preferences/P = player.client.prefs

				// Loop through all jobs
				for(var/datum/job/job in shuffledoccupations) // SHUFFLE ME BABY
					if(!job)
						continue

					if(P.isJobbanned(job.title))
						Debug("DO isbanned failed, Player: [player], Job:[job.title]")
						continue

					if(job.available_in_days(P) > 0)
						Debug("DO player not old enough, Player: [player], Job:[job.title]")
						continue

					// If the player wants that job on this level, then try give it to him.
					if(P.GetJobDepartment(job, level) & job.flag)

						// If the job isn't filled
						if((job.current_positions < job.spawn_positions) || job.spawn_positions == -1)
							Debug("DO pass, Player: [player], Level:[level], Job:[job.title]")
							AssignRole(player, job.title, job.job_title)
							unassigned -= player
							break

		// Hand out random jobs to the people who didn't get any in the last check
		// Also makes sure that they got their preference correct
		/*for(var/mob/new_player/player in unassigned)
			if(player.client.prefs.userandomjob)
				GiveRandomJob(player)*/

		Debug("DO, Standard Check end")

		Debug("DO, Running AC2")

		// For those who wanted to be assistant if their preferences were filled, here you go.
		for(var/mob/new_player/player in unassigned)
			Debug("AC2 Assistant located, Player: [player]")
			AssignRole(player, "Assistant", "Assistant")//Assistant is hardcoded here because no job datum
		return 1


	proc/EquipRank(var/mob/living/carbon/human/H, var/rank, var/joined_late = 0)
		if(!H)	return 0
		var/datum/job/job = GetJob(rank)
		if(job)
			job.equip(H)
			job.apply_fingerprints(H)
		else
			H << "Your job is [rank] and the game just can't handle it! Please report this bug to an administrator."

		H.job = rank

		if(!joined_late)
			var/obj/S = null
			for(var/obj/effect/landmark/start/sloc in landmarks_list)
				if(sloc.name != rank)	continue
				if(locate(/mob/living) in sloc.loc)	continue
				S = sloc
				break
			if(!S)
				S = locate("start*[rank]") // use old stype
			if(istype(S, /obj/effect/landmark/start) && istype(S.loc, /turf))
				H.loc = S.loc



		if(H.mind)
			H.mind.assigned_role = rank

			switch(rank)
				if("Cyborg")
					H.Robotize()
					return 1
				if("AI","Clown")	//don't need bag preference stuff!
				else
					switch(H.backbag)
						if(1)
							H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
						if(2)
							var/obj/item/weapon/storage/backpack/BPK = new/obj/item/weapon/storage/backpack(H)
							new /obj/item/weapon/storage/box/survival(BPK)
							H.equip_to_slot_or_del(BPK, slot_back,1)
						if(3)
							var/obj/item/weapon/storage/backpack/BPK = new/obj/item/weapon/storage/backpack/satchel(H)
							new /obj/item/weapon/storage/box/survival(BPK)
							H.equip_to_slot_or_del(BPK, slot_back,1)
				//MY code starts here

		H << "<B>You are the [rank].</B>"
		H << "<b>As the [rank] you answer directly to [job.supervisors]. Special circumstances may change this.</b>"
		switch(rank)
			if ("Chemist", "Medical Doctor", "Virologist")
				H << "<b>As a [rank] you can use your department's radio channel with <i>:m</i> (medical) before you speak.	</b>"
			if ("Geneticist")
				H << "<b>As a [rank] you can use your department's radio channel with <i>:m</i> (medical) and <i>:n</i> (science) before you speak.</b>"
			if ("Engineer", "Atmospheric Technician")
				H << "<b>As a [rank] you can use your department's radio channel with <i>:e</i> (engineering) before you speak.  Also flooding the station with deadly gas or releasing the singularity will get you job banned or worse.</b>"
			if ("Xenobiologist", "Scientist", "Roboticist")
				H << "<b>As a [rank] you can use your department's radio channel with <i>:n</i> (science) before you speak.</b>"
			if ("Security Officer", "Warden", "Detective")
				H << "<b>As a [rank] you can use your department's radio channel with <i>:s</i> (security) before you speak. <u>Being shit as security will result in you being job banned. Also remember to set timers.</u></b>"
			if ("Shaft Miner", "Cargo Technician", "Quartermaster")
				H << "<b>As a [rank] you can use your department's radio channel with <i>:u</i> (supply) before you speak.</b>"
			if ("AI", "Cyborg")
				H << "<b>As a [rank] you can use robotic talk with <i>:b</i> before you speak.</b>"
			if ("Chief Engineer")
				H << "<b>As the [rank] you can use your department's radio channel with <i>:e</i> (engineering) and talk on the command channel with <i>:c</i> before you speak.</b>"
			if ("Head of Personnel")
				H << "<b>As the [rank] you can use your department's radio channel with <i>:u</i> (supply), <i>security</i> (security) and talk on the command channel with <i>:c</i> before you speak.</b>"
			if ("Captain")
				H << "<b>As the [rank] you can shift click your headset for a list of all channels you can speak on, place one of the prefixes before you say something to say it over the specific channel.</b>"
			if ("Head of Security")
				H << "<b>As the [rank] you can use your department's radio channel with <i>:s</i> (security), and talk on the command channel with <i>:c</i> before you speak.</b>"
			if ("Chief Medical Officer")
				H << "<b>As the [rank] you can use your department's radio channel with <i>:m</i> (medical), and talk on the command channel with <i>:c</i> before you speak.</b>"
			if ("Research Director")
				H << "<b>As the [rank] you can use your department's radio channel with <i>:n</i> (science), and talk on the command channel with <i>:c</i> before you speak.</b>"

		if(job.req_admin_notify)
			H << "<b>You are playing a job that is important for Game Progression. If you have to disconnect, please notify the admins via adminhelp.</b>"
			H << "<b>You are an example to be followed, don't act like a shithead, doing so is enough to get you jobbanned. If you can't handle this then play as a subordinate job.</b>"
		spawnId(H,rank)

		H.equip_to_slot_or_del(new /obj/item/device/radio/headset(H), slot_ears)
//		H.update_icons()
		return 1


	proc/spawnId(var/mob/living/carbon/human/H, rank)
		if(!H)	return 0
		var/obj/item/weapon/card/id/C = null

		var/datum/job/job = null
		for(var/datum/job/J in occupations)
			if(J.title == rank)
				job = J
				break

		if(job)
			if(job.title == "Cyborg")
				return
			else
				C = new job.idtype(H)
				C.access = job.get_access()
		else
			C = new /obj/item/weapon/card/id(H)
		if(C)
			C.registered_name = H.real_name
			C.assignment = rank
			C.name = "[C.registered_name]'s ID Card ([C.assignment])"
			H.equip_to_slot_or_del(C, slot_wear_id)
	/*	if(prob(50))
			H.equip_to_slot_or_del(new /obj/item/weapon/pen(H), slot_r_store)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/pen/blue(H), slot_r_store)*/
		H.equip_to_slot_or_del(new /obj/item/device/pda(H), slot_belt)
		if(locate(/obj/item/device/pda,H))//I bet this could just use locate.  It can --SkyMarshal
			var/obj/item/device/pda/pda = locate(/obj/item/device/pda,H)
			pda.owner = H.real_name
			pda.ownjob = C.assignment
			pda.name = "PDA-[H.real_name] ([pda.ownjob])"
		return 1


	proc/LoadJobs(jobsfile) //ran during round setup, reads info from jobs.txt -- Urist
		if(!config.load_jobs_from_txt)
			return 0

		var/list/jobEntries = file2list(jobsfile)

		for(var/job in jobEntries)
			if(!job)
				continue

			job = trim(job)
			if (!length(job))
				continue

			var/pos = findtext(job, "=")
			var/name = null
			var/value = null

			if(pos)
				name = copytext(job, 1, pos)
				value = copytext(job, pos + 1)
			else
				continue

			if(name && value)
				var/datum/job/J = GetJob(name)
				if(!J)	continue
				J.total_positions = text2num(value)
				J.spawn_positions = text2num(value)
				if(name == "AI" || name == "Cyborg")//I dont like this here but it will do for now
					J.total_positions = 0

		return 1


	proc/HandleFeedbackGathering()
		return 1
