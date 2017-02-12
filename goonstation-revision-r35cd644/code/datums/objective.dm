/datum/objective
	var/datum/mind/owner
	var/explanation_text
	var/medal_name = null // Called by ticker.mode.declare_completion().
	var/medal_announce = 1

	New(var/text)
		if(text)
			src.explanation_text = text

	proc/check_completion()
		return 1

	proc/set_up()
		return

///////////////////////////////////////////////////
// Regular objectives active in current gameplay //
///////////////////////////////////////////////////

/datum/objective/regular/assassinate
	var/datum/mind/target
	var/targetname

	set_up()
		var/list/possible_targets = list()

		for(var/datum/mind/possible_target in ticker.minds)
			if (possible_target && (possible_target != owner) && istype(possible_target.current, /mob/living/carbon/human))
				// 1) Wizard marked as another wizard's target.
				// 2) Presence of wizard is revealed to other antagonists at round start.
				// Both are bad.
				if (possible_target.special_role == "wizard")
					continue
				if (possible_target.current.mind && possible_target.current.mind.is_target) // Cannot read null.is_target
					continue
				if (!possible_target.current.client)
					continue
				possible_targets += possible_target

		if(possible_targets.len > 0)
			target = pick(possible_targets)
			target.current.mind.is_target = 1

		create_objective_string(target)

		return target

	proc/find_target_by_role(var/role)
		for(var/datum/mind/possible_target in ticker.minds)
			if((possible_target != owner) && istype(possible_target.current, /mob/living/carbon/human) && (possible_target.assigned_role == role || (possible_target.assigned_role == "MODE" && possible_target.special_role == role)))
				target = possible_target
				break

		create_objective_string(target)

		return target

	check_completion()
		if(target && target.current)
			if(target.current.stat == 2 || !iscarbon(target.current))
				return 1
			else
				return 0
		else
			return 1
	proc/create_objective_string(var/datum/mind/target)
		if(!(target && target.current))
			explanation_text = "Go hog wild!"
			return
		var/add_fluff = prob(50)
		var/objective_text = "Assassinate [target.current.real_name], the [target.assigned_role == "MODE" ? target.special_role : target.assigned_role][add_fluff ? " " : "."]"
		if(add_fluff)
			var/fluff = create_fluff(target)
			objective_text += "[fluff]."

		explanation_text = objective_text
		targetname = target.current.real_name

proc/create_fluff(var/datum/mind/target)
	if(!istype(target)) return ""

	var/job = target.assigned_role == "MODE" ? target.special_role : target.assigned_role
	var/datum/job/J = find_job_in_controller_by_string(job)
	var/list/general_fluff = strings("assassination_fluff.txt", "general") //Get a list of objectives matching every job
	var/list/special_fluff = list()

	if(J) //Ok, we found their job - now to build a list of job-specific stuff
		special_fluff += strings("assassination_fluff.txt", ckey(J.name), 1)

		if(J.name != J.initial_name) //We got us a case of alt_names
			special_fluff += strings("assassination_fluff.txt", ckey(J.initial_name), 1)

	//Pick which flufftext we want to use
	var/flufftext
	if(general_fluff && special_fluff.len)
		flufftext = pick(prob(50) ? general_fluff : special_fluff)
	else if (general_fluff)
		flufftext = pick(general_fluff)
	else if (special_fluff.len)
		flufftext = pick(special_fluff)

	if(flufftext)
		//Add pronouns
		var/mob/M = target.current
		flufftext = dd_replacetext(flufftext, "$HE", he_or_she(M))
		flufftext = dd_replacetext(flufftext, "$HIMSELF", himself_or_herself(M))
		flufftext = dd_replacetext(flufftext, "$HIM", him_or_her(M))
		flufftext = dd_replacetext(flufftext, "$HIS", his_or_her(M))
		flufftext = dd_replacetext(flufftext, "$JOB", job)

	return flufftext

/datum/objective/regular/borgdeath
	explanation_text = "Deactivate or destroy all Cyborgs on the station. If you end up borged, you do not need to kill yourself or be un-borged to win."

	check_completion()
		for(var/mob/living/silicon/robot/R in mobs)
			if (owner.current == R)
				continue
			if (R.stat != 2 && R.brain)
				return 0
		return 1

/datum/objective/regular/aikill
	explanation_text = "Steal the AI's neural net processor."

	check_completion()
		if(owner.current && owner.current.check_contents_for(/obj/item/organ/brain/ai))
			return 1
		else
			return 0

/datum/objective/regular/steal
	var/obj/item/steal_target
	var/target_name

	set_up()
		var/list/items = list( "head of security\'s jumpsuit", "pair of optical thermal scanners",
		"research director\'s jumpsuit", "head of personnel\'s jumpsuit", "hand teleporter", "RCD",
		"captain\'s jumpsuit", "computer core master tape")

		target_name = pick(items)
		switch(target_name)
			if("head of security\'s jumpsuit")
				steal_target = /obj/item/clothing/under/rank/head_of_securityold
			if("pair of optical thermal scanners")
				steal_target = /obj/item/clothing/glasses/thermal
			if("research director\'s jumpsuit")
				steal_target = /obj/item/clothing/under/rank/research_director
			if("head of personnel\'s jumpsuit")
				steal_target = /obj/item/clothing/under/suit/hop
			if("hand teleporter")
				steal_target = /obj/item/hand_tele
			if("RCD")
				steal_target = /obj/item/rcd
			if("captain\'s jumpsuit")
				steal_target = /obj/item/clothing/under/rank/captain
			if("computer core master tape")
				steal_target = /obj/item/disk/data/tape/master

		explanation_text = "Steal a [target_name]."
		return steal_target

	check_completion()
		if(steal_target)
			if(owner.current && owner.current.check_contents_for(steal_target, 1))
				return 1
			else
				return 0

/datum/objective/regular/gimmick
	explanation_text = "Go hog wild!"

	set_up()
		var/list/gimmick_list = list("Try to frame innocent crewmembers for various crimes.",
		"Try to sabotage as much station infrastructure as possible without getting caught.",
		"Try to ruin a department's productivity with constant annoyances.",
		"Get yourself arrested, and then stage a violent jailbreak. The more collateral damage the better!",
		"If anyone gets arrested, try to rescue them. The Syndicate values its employees!",
		"If anyone gets arrested, try to eliminate them. The Syndicate does not appreciate failure.",
		"Try to severely obstruct the flow of traffic around the station with barricades, sabotage, or construction projects.",
		"Incite the other crewmembers to violence and chaos without ever doing anything direct.",
		"Wage a personal war against all the assistants. Try to eradicate them without attracting the attention of other departments.",
		"Play increasingly more dangerous pranks on other crew members. If confronted, insist it was just a joke.",
		"Waste Medbay's time by causing a lot of non-fatal injuries around the station.",
		"Waste Security's time by committing a lot of minor crimes.",
		"Waste the AI's time by deactivating its access to anything you can.",
		"Lay various traps around the station. Be dastardly as heck.",
		"Start as many petty arguments and fistfights as possible. Be a real jerk.",
		"Try to make everyone hate a job department of your choice, through misdirection and slander.",
		"Sneak into a department of your choice every once in awhile and mess with all the things inside.",
		"Try to deprive the station of medical items and objects.",
		"Try to deprive the station of tools and useful items.",
		"Try to deprive the station of clothing.",
		"Try to deprive the station of their ID cards.",
		"Make the station as ugly and visually unpleasant as you can.",
		"Try to get the AI declared rogue and shut down.",
		"Get your hands on some weapons and then hand them out to the most untrustworthy crew members.",
		"Become a literal arms dealer. Harvest as many body parts as possible from the crew.",
		"Become a headhunter. Literally. Collect the crew's heads and take them with you.",
		"Become a vigilante and violently harass people over the slightest suspicion.",
		"Seek out any non-security vigilantes on the station and make their life utter hell.",
		"Find another crew member's pet project and subvert it to a more violent purpose.",
		"BURN IT ALL DOWN.",
		"FUCK THE POLICE.",
		"Try to become a supervillain by using costumes, treachery, and a lot of bluster and bravado.")

		var/gimmick_text = pick(gimmick_list)
		explanation_text = "[gimmick_text] <i>This objective is not tracked and will automatically succeed, so just have fun with it!</i>"

		return

	check_completion()
		return 1

/datum/objective/regular/bonsaitree
	// Brought this back as a very rare gimmick objective (Convair880).
	explanation_text = "Destroy the Captain's prized bonsai tree."

	check_completion()
		var/area/cap_quarters = locate(/area/station/crew_quarters/captain)
		var/obj/shrub/captainshrub/our_tree

		for (var/obj/shrub/captainshrub/T in cap_quarters)
			our_tree = T
		if (!our_tree)
			return 1  // Somebody deleted it somehow, I suppose?
		else if (our_tree && our_tree.destroyed == 1)
			return 1
		else
			return 0

/datum/objective/regular/damage_area
	var/area/target_area = null
	var/area_attempt = 0
	var/area_autopass = 0
	var/initial_value_score = 0
	var/damage_threshold = 50 // 25 was way too strict for larger rooms, causing people to fail the objective most of the time.

	set_up()
		var/list/target_areas = list(/area/station/chemistry,
		/area/station/artifact,
		/area/station/science/lab,
		/area/station/science/teleporter,
		/*/area/station/medical/medbay,*/ // On Cogmap 1, medbay is split up into three separate areas.
		/area/station/medical/research,
		/area/station/medical/robotics,
		/area/station/crew_quarters/courtroom,
		/area/station/bridge,
		/area/station/security/brig,
		/area/station/security/main,
		/area/station/crew_quarters/quarters,
		/area/station/crew_quarters/cafeteria,
		/area/station/chapel/main,
		/area/station/hydroponics,
		/area/station/quartermaster/office,
		/area/station/engine/elect,
		/area/station/engine/engineering,
		/area/station/turret_protected/ai_upload,
		/area/station/hallway/secondary/exit)

		target_area = get_area_by_type(pick(target_areas))

		while (src.area_attempt < 4 && (!target_area || !istype(target_area)))
			if (!target_area || !istype(target_area))
				target_area = get_area_by_type(pick(target_areas))
				src.area_attempt++

		if (!target_area || !istype(target_area))
			src.area_autopass = 1
			explanation_text = "Cause significant damage to...whoops, couldn't find a valid target area. Objective will succeed automatically."
		else
			initial_value_score = target_area.calculate_area_value()
			explanation_text = "Cause significant damage to [target_area]."

	check_completion()
		if (src.area_autopass == 1)
			return 1

		var/current_value_score = target_area.calculate_area_value()
		var/damage_perc = (max(1,current_value_score) / initial_value_score) * 100

		if (damage_perc <= damage_threshold)
			return 1

		return 0

/datum/objective/regular/destroy_equipment
	var/target_equipment = null
	var/target_name

	set_up()
		var/list/choices = list("cryo cells","cloning pods","cyborg recharge stations",
		"chem dispensers","plasma canisters","arc smelters","plant pots","large pod vehicles")

		target_name = pick(choices)
		switch(target_name)
			if ("cryo cells")
				target_equipment = /obj/machinery/atmospherics/unary/cryo_cell
			if ("cloning pods")
				target_equipment = /obj/machinery/clonepod
			if ("cyborg recharge stations")
				target_equipment = /obj/machinery/recharge_station
			if ("chem dispensers")
				target_equipment = /obj/machinery/chem_dispenser
			if ("plasma canisters")
				target_equipment = /obj/machinery/portable_atmospherics/canister/toxins
			if ("arc smelters")
				target_equipment = /obj/machinery/smelter
			if ("plant pots")
				target_equipment = /obj/machinery/plantpot
			if ("large pod vehicles")
				target_equipment = /obj/machinery/vehicle/pod_smooth
		explanation_text = "Destroy all [target_name] on the station."

	check_completion()
		for(var/obj/machinery/M in machines)
			if (M.z != 1 || get_area_name(M) == "Space")
				continue
			if (!istype(M,target_equipment))
				continue
			if (M.stat & BROKEN)
				continue
			return 0

		return 1

/datum/objective/regular/job_genocide
	var/target_job = "Staff Assistant"

	set_up()
		var/list/targets = list("Staff Assistant","Medical Doctor","Engineer","Security Officer",
		"Geneticist","Scientist","Roboticist","Mechanic","Quartermaster","Miner","Botanist")
		target_job = pick(targets)
		explanation_text = "Kill every [target_job] on the station. You do not need to kill yourself if you are a [target_job]."

	check_completion()
		for (var/datum/mind/M in ticker.minds)
			if (!M.current)
				continue
			if (M.current == owner.current)
				continue
			if (M.assigned_role != target_job)
				continue
			if (M.current.stat != 2 && iscarbon(M.current))
				return 0

		return 1

/datum/objective/regular/kill_heads
	explanation_text = "Kill the Captain, Head of Personnel, Head of Security, Chief Engineer, Medical Director and Research Director."
	var/list/targets = list("Captain", "Head of Personnel", "Head of Security", "Chief Engineer", "Medical Director", "Research Director")

	check_completion()
		for (var/datum/mind/M in ticker.minds)
			if (!M.current)
				continue
			if (M.current == owner.current)
				continue
			if (!(M.assigned_role in targets))
				continue
			if (M.current.stat != 2 && iscarbon(M.current))
				return 0

		return 1

/datum/objective/regular/no_clones
	explanation_text = "Ensure that no cloned personnel survive. You do not need to kill yourself if cloned."

	check_completion()
		for(var/mob/living/carbon/human/H in mobs)
			if (H == owner.current)
				continue
			if (!H.bioHolder)
				continue
			if (H.bioHolder.clone_generation < 1)
				continue
			if (H.stat != 2 && iscarbon(H))
				return 0

		return 1

/datum/objective/regular/traitor_supremacy
	explanation_text = "Eliminate all other syndicate operatives, changelings and other foes on the station."
	medal_name = "Untapped Potential"

	check_completion()
		for (var/datum/mind/M in ticker.mode.traitors + ticker.mode.Agimmicks)
			if (!M.current)
				continue
			if (M.current.stat != 2)
				return 0

		return 1


///////////////////////////////////////////////////////////////
// Regular objectives not currently used in current gameplay //
///////////////////////////////////////////////////////////////

/datum/objective/regular/force_evac_time
	var/time = 45
	explanation_text = "Force the crew to evacuate the station before 45 minutes elapse."

	check_completion()
		if(round(((world.time / 10) / 60)) < time)
			return 1
		return 0

/datum/objective/regular/destroy_outpost
	explanation_text = "Activate the computer mainframe's self-destruct charge."

	check_completion()
		if (outpost_destroyed == 1) return 1
		else return 0

/datum/objective/regular/multigrab
	var/obj/item/multigrab_target
	var/multigrab_num
	var/target_name

	set_up()
		var/list/items = list(
		"tasers",\
		"phasers",\
		"lasers",\
		"riot shotguns",\
		"identification cards",\
		"security headsets",\
		"command headsets",\
		"insulated gloves",\
		"stun batons",\
		"pairs of sunglasses",\
		"security helmets",\
		"flashes",\
		"multitools",\
		"space helmets",\
		"limbs",\
		"brains",\
		"hearts"
		)

		target_name = pick(items)
		switch (target_name)
			if ("tasers")
				multigrab_target = /obj/item/gun/energy/taser_gun
				multigrab_num = rand(2, 5)
			if ("phasers")
				multigrab_target = /obj/item/gun/energy/phaser_gun
				multigrab_num = rand(2, 5)
			if ("lasers")
				multigrab_target = /obj/item/gun/energy/laser_gun
				multigrab_num = rand(2, 5)
			if ("riot shotguns")
				multigrab_target = /obj/item/gun/kinetic/riotgun
				multigrab_num = rand(2, 3)
			if ("identification cards")
				multigrab_target = /obj/item/card/id
				multigrab_num = rand(6, 12)
			if ("security headsets")
				multigrab_target = /obj/item/device/radio/headset/security
				multigrab_num = rand(2, 4)
			if ("command headsets")
				multigrab_target = /obj/item/device/radio/headset/command
				multigrab_num = rand(2, 4)
			if ("insulated gloves")
				multigrab_target = /obj/item/clothing/gloves/yellow
				multigrab_num = rand(3, 8)
			if ("stun batons")
				multigrab_target = /obj/item/baton
				multigrab_num = rand(2, 5)
			if ("pairs of sunglasses")
				multigrab_target = /obj/item/clothing/glasses/sunglasses
				multigrab_num = rand(3, 10)
			if ("security helmets")
				multigrab_target = /obj/item/clothing/head/helmet
				multigrab_num = rand(2, 5)
			if ("space helmets")
				multigrab_target = /obj/item/clothing/head/helmet/space
				multigrab_num = rand(2, 4)
			if ("flashes")
				multigrab_target = /obj/item/device/flash
				multigrab_num = rand(3, 12)
			if ("multitools")
				multigrab_target = /obj/item/device/multitool
				multigrab_num = rand(2, 10)
			if ("limbs")
				multigrab_target = /obj/item/parts/human_parts
				multigrab_num = rand(5, 10)
			if ("brains")
				multigrab_target = /obj/item/organ/brain
				multigrab_num = rand(3, 7)
			if ("hearts")
				multigrab_target = /obj/item/organ/heart
				multigrab_num = rand(3, 7)

		if (target_name == "hearts")
			explanation_text = "You're a real romeo! Steal the hearts of [multigrab_num] crewmembers."
		else
			explanation_text = "Steal [multigrab_num] [target_name]."

		return multigrab_target

	check_completion()
		if (multigrab_target)
			if (owner.current.check_contents_for_num(multigrab_target, multigrab_num, 1))
				return 1
			else
				return 0
		else
			return 0

/datum/objective/regular/cash
	var/target_cash
	var/current_cash

	set_up()
		target_cash = rand(10000,80000)
		explanation_text = "Amass [target_cash] space credits."

	check_completion()
		if (!owner.current)
			return 0

		current_cash = 0

		// Tweaked to make it more reliable (Convair880).
		var/list/L = owner.current.get_all_items_on_mob()
		if (L && L.len)
			for (var/obj/item/card/id/C in L)
				current_cash += C.money
			for (var/obj/item/device/pda2/PDA in L)
				if (PDA.ID_card)
					current_cash += PDA.ID_card.money
			for (var/obj/item/spacecash/C in L)
				current_cash += C.amount

		for (var/datum/data/record/Ba in data_core.bank)
			if (Ba.fields["name"] == owner.current.real_name)
				current_cash += Ba.fields["current_money"]

		if (current_cash >= target_cash)
			return 1
		else
			return 0

////////////////////////////////
// Specialist role objectives //
////////////////////////////////

/datum/objective/specialist/nuclear
	explanation_text = "Destroy the station with a nuclear device."
	medal_name = "Manhattan Project"

	check_completion()
		if (ticker && ticker.mode && istype(ticker.mode, /datum/game_mode/nuclear))
			var/datum/game_mode/nuclear/N = ticker.mode
			if (N && istype(N) && (N.finished == -1 || N.finished == -2))
				return 1
		return 0

/datum/objective/specialist/conspiracy
	explanation_text = "Identify and eliminate any competing syndicate operatives on the station. Be careful not to be too obvious yourself, or they'll come after you!"

	check_completion()
		if (!owner.current || owner.current.stat == 2)
			return 0

		if (!istype(ticker.mode, /datum/game_mode/spy))
			return 0

		var/datum/game_mode/spy/spymode = ticker.mode
		for (var/datum/mind/mindCheck in spymode.leaders)
			if (mindCheck == owner)
				continue

			if (mindCheck && mindCheck.current && mindCheck.current.stat != 2)
				return 0

		return 1

/datum/objective/specialist/absorb
	var/absorb_count

	set_up()
		absorb_count = min(10, (ticker.minds.len - 1))
		explanation_text = "Absorb the DNA of at least [absorb_count] more crew members in addition to the one you started with, and escape on the shuttle alive."

	check_completion()
		if(emergency_shuttle.location<2)
			return 0

		if(!owner.current || owner.current.stat == 2)
			return 0

		var/turf/location = get_turf(owner.current.loc)
		if(!location)
			return 0

		var/area/check_area = location.loc

		if(!istype(check_area, /area/shuttle/escape/centcom))
			return 0

		if (!owner.is_changeling)
			return 0

		if (owner.is_changeling.absorbtions >= absorb_count) // You start with 0 DNA these days, not 1.
			return 1

/datum/objective/specialist/drinkblood
	medal_name = "Dracula Jr."
	var/bloodcount

	set_up()
		bloodcount = rand(60,100) * 10
		explanation_text = "Accumulate at least [bloodcount] units of blood in total."

	check_completion()
		if (owner.current && owner.current.get_vampire_blood(1) >= bloodcount)
			return 1
		else
			return 0

/datum/objective/specialist/predator/trophy
	medal_name = "Dangerous Game"
	var/trophycount // Added a bit of randomization here (Convair880).

	set_up()
		trophycount = min(10, (ticker.minds.len - 1))
		//DEBUG("Found [ticker.minds.len] minds.")
		explanation_text = "Take at least [trophycount] trophies. The skulls of worthy opponents are more valuable with regard to this objective."

	check_completion()
		var/trophyvalue = 0

		if (owner.current)
			trophyvalue = owner.current.get_skull_value()
			//DEBUG("Objective: [trophycount]. Total trophy value: [trophyvalue].")

		if (trophyvalue >= trophycount)
			return 1
		else
			return 0

/datum/objective/specialist/stealth
	var/min_score
	var/score = 0
	var/list/datum/mind/safe_minds = list()

	set_up()
		var/num_players = 0
		for(var/mob/living/player in mobs)
			if (player.client) num_players++
		min_score = min(500, num_players * 10) + (rand(-5,5) * 10)
		explanation_text = "Remain out of sight and accumulate [min_score] points."

	check_completion()
		if(score >= min_score)
			return 1
		else
			return 0

/datum/objective/specialist/gang
	explanation_text = "Kill the leaders of every other gang without being killed yourself."

	check_completion()
		if (!owner.current || owner.current.stat == 2)
			return 0

		if (!istype(ticker.mode, /datum/game_mode/gang))
			return 0

		var/datum/game_mode/gang/gangmode = ticker.mode
		for (var/datum/mind/mindCheck in gangmode.leaders)
			if (mindCheck == owner)
				continue

			if (mindCheck && mindCheck.current && mindCheck.current.stat != 2)
				return 0

		return 1

/datum/objective/specialist/blob
	explanation_text = "Grow up to at least 500 tiles in size and force the evacuation of the station."

	check_completion()
		if (!owner)
			return 0
		if (!owner.current)
			return 0

		var/mob/living/intangible/blob_overmind/O = owner.current
		if (!istype(O))
			return 0

		if (O.blobs.len >= 500)
			return 1

/datum/objective/specialist/wraith
	explanation_text = "Go hog wild!"

	proc/onAbsorb(var/mob/M)
		return
	proc/onWeakened()
		return
	proc/onBanished()
		return
	proc/Stat()
		return

	check_completion()
		return 1

/datum/objective/specialist/wraith/absorb
	var/absorbs = 0
	var/absorb_target

	onAbsorb(var/mob/M)
		absorbs++
	onWeakened()
		absorbs = 0
	Stat()
		stat("Currently absorbed:", "[absorbs] souls")

	set_up()
		absorb_target = max(1, min(7, round((ticker.minds.len - 5) / 2)))
		explanation_text = "Absorb and retain the life essence of at least [absorb_target] mortal(s) that inhabit this material structure."

	check_completion()
		return absorbs >= absorb_target

/datum/objective/specialist/wraith/murder
	var/datum/mind/target
	var/targetname

	proc/setText()
		explanation_text = "We sense a large untapped astral force with the mortal [target.current.real_name], the [target.assigned_role == "MODE" ? target.special_role : target.assigned_role]. Trap them in a spiritual form and ensure that they never manifest as a corporeal being again."
		targetname = target.current.real_name

	set_up()
		var/list/possible_targets = list()

		for(var/datum/mind/possible_target in ticker.minds)
			if((possible_target != owner) && istype(possible_target.current, /mob/living/carbon/human))
				if(possible_target.current.mind.is_target) continue
				possible_targets += possible_target

		if(possible_targets.len > 0)
			target = pick(possible_targets)
			target.current.mind.is_target = 1

		if(target && target.current)
			setText()
		else
			explanation_text = "Go hog wild!"

		return target

	proc/find_target_by_role(var/role)
		for(var/datum/mind/possible_target in ticker.minds)
			if((possible_target != owner) && istype(possible_target.current, /mob/living/carbon/human) && (possible_target.assigned_role == role || (possible_target.assigned_role == "MODE" && possible_target.special_role == role)))
				target = possible_target
				break

		if(target && target.current)
			setText()
		else
			explanation_text = "Go hog wild!"

		return target

	check_completion()
		if(target && target.current)
			if(target.current.stat == 2 || !iscarbon(target.current))
				if (istype(target.current, /mob/dead))
					if (!(target.current:corpse))
						return 1
			return 0
		else
			return 1

/datum/objective/specialist/wraith/murder/absorb
	var/success = 0
	setText()
		explanation_text = "[target.current.real_name], the [target.assigned_role == "MODE" ? target.special_role : target.assigned_role] is a vessel for astral energies we haven't detected before. Absorb and retain their essence at all costs!"
		targetname = target.current.real_name

	onAbsorb(var/mob/M)
		if (M == target.current)
			success = 1
		else if (istype(target.current, /mob/dead))
			if (M == target.current:corpse)
				success = 1

	onWeakened()
		if (success)
			success = 0
			boutput(owner.current, "<span style=\"color:red\">You lose the astral essence of your target!</span>")

	check_completion()
		return success

/datum/objective/specialist/wraith/prevent
	var/max_escapees

	set_up()
		max_escapees = max(min(5, round(ticker.minds.len / 10)), 1)
		explanation_text = "Force the mortals to remain stranded on this structure. No more than [max_escapees] may escape!"

	check_completion()
		var/area/shuttle = locate(/area/shuttle/escape/centcom)
		var/escapees = 0
		for (var/mob/living/carbon/player in mobs)
			if (get_turf(player) in shuttle)
				escapees++
		return escapees <= max_escapees

/datum/objective/specialist/wraith/travel
	explanation_text = "Locate the hive of the mortal infestation by concealing yourself aboard the escape vehicle."
	var/failed = 0

	onBanished()
		failed = 1

	check_completion()
		var/area/shuttle = locate(/area/shuttle/escape/centcom)
		if (failed)
			return 0
		if (get_turf(owner.current) in shuttle)
			return 1
		return 0

/datum/objective/specialist/wraith/survive
	explanation_text = "Maintain your material presence by avoiding permanent banishment."
	var/failed = 0

	onBanished()
		failed = 1

	check_completion()
		if (failed)
			return 0
		return 1

/datum/objective/specialist/wraith/flawless
	explanation_text = "Complete your objectives without your material presence being weakened by temporary banishment."
	var/failed = 0

	onWeakened()
		failed = 1

	check_completion()
		return !failed

/datum/objective/specialist/werewolf/feed
	var/feed_count = 0
	var/target_feed_count
	var/list/mob/mobs_fed_on = list() // Stores bioHolder.Uid of previous victims, so we can't feed on the same person multiple times.

	set_up()
		target_feed_count = min(10, (ticker.minds.len - 1))
		explanation_text = "Feed on at least [target_feed_count] crew members."

	check_completion()
		if (feed_count >= target_feed_count)
			return 1

/datum/objective/specialist/ruin_xmas
	explanation_text = "Ruin Christmas for everyone! Make sure Christmas cheer is at or below 20% when the round ends."
	medal_name = "You're a mean one..."

	check_completion()
		if (christmas_cheer <= 20)
			return 1
		else
			return 0

/////////////////////////////
// Round-ending objectives //
/////////////////////////////

/datum/objective/escape
	explanation_text = "Escape on the shuttle alive."

	check_completion()
		if(emergency_shuttle.location<2)
			return 0

		if(!owner.current || owner.current.stat ==2)
			return 0

		var/turf/location = get_turf(owner.current.loc)
		if(!location)
			return 0

		var/area/check_area = location.loc

		if(istype(check_area, /area/shuttle/escape/centcom))
			return 1
		else
			return 0

/datum/objective/escape/hijack
	explanation_text = "Hijack the emergency shuttle by escaping alone."

	check_completion()
		if(emergency_shuttle.location<2)
			return 0

		if(!owner.current || owner.current.stat ==2)
			return 0

		var/area/shuttle = locate(/area/shuttle/escape/centcom)

		for(var/mob/living/player in mobs)
			if (player.mind && (player.mind != owner))
				if (player.stat != 2) //they're not dead
					if (get_turf(player) in shuttle)
						return 0

		return 1

/datum/objective/escape/survive
	explanation_text = "Stay alive until the end."

	check_completion()
		if(!owner.current || owner.current.stat == 2)
			return 0

		return 1

/datum/objective/escape/kamikaze
	explanation_text = "Die a glorious death."

	check_completion()
		if(!owner.current || owner.current.stat == 2)
			return 1

		return 0

/datum/objective/escape/hijack_group
	explanation_text = "Hijack the emergency shuttle by escaping alone or with your accomplices."
	var/list/datum/mind/accomplices = list()

	check_completion()
		if(emergency_shuttle.location<2)
			return 0

		if(!owner.current || owner.current.stat ==2)
			return 0

		var/area/shuttle = locate(/area/shuttle/escape/centcom)

		for(var/mob/living/player in mobs)
			if (player.mind && (player.mind != owner) && !(player.mind in accomplices))
				if (player.stat != 2) //they're not dead
					if (get_turf(player) in shuttle)
						return 0

		return 1

/////////////////////////////////////////////////////////
// Neatly packaged objective sets for your convenience //
/////////////////////////////////////////////////////////

/datum/objective_set
	var/list/objective_list = list(/datum/objective/regular/gimmick)
	var/list/escape_choices = list(/datum/objective/escape,
	/datum/objective/escape/survive,
	/datum/objective/escape/hijack,
	/datum/objective/escape/kamikaze)

	New(var/datum/mind/enemy)
		if(!istype(enemy))
			return 1

		for(var/X in objective_list)
			if (!ispath(X))
				continue
			ticker.mode.bestow_objective(enemy,X)

		if (escape_choices.len > 0)
			var/escape_path = pick(escape_choices)
			if (ispath(escape_path))
				ticker.mode.bestow_objective(enemy,escape_path)

		spawn(0)
			qdel(src)
		return 0

	// Misc antags

/datum/objective_set/changeling
	objective_list = list(/datum/objective/specialist/absorb)
	escape_choices = list(/datum/objective/escape,
	/datum/objective/escape/hijack)

/datum/objective_set/vampire
	objective_list = list(/datum/objective/specialist/drinkblood)
	escape_choices = list(/datum/objective/escape,
	/datum/objective/escape/hijack)

/datum/objective_set/grinch
	objective_list = list(/datum/objective/specialist/ruin_xmas)
	escape_choices = list(/datum/objective/escape,
	/datum/objective/escape/survive,
	/datum/objective/escape/hijack,
	/datum/objective/escape/kamikaze)

/datum/objective_set/predator
	objective_list = list(/datum/objective/specialist/predator/trophy)
	escape_choices = list(/datum/objective/escape/survive)

/datum/objective_set/werewolf
	objective_list = list(/datum/objective/specialist/werewolf/feed)
	escape_choices = list(/datum/objective/escape/survive)

/datum/objective_set/blob
	objective_list = list(/datum/objective/specialist/blob)
	escape_choices = list(/datum/objective/escape/survive)

// Wraith not listed since it has its own dedicated proc

// Traitors, easier objectives

/datum/objective_set/traitor/easy/triple_assassinate
	objective_list = list(/datum/objective/regular/assassinate,
	/datum/objective/regular/assassinate,
	/datum/objective/regular/assassinate)
	escape_choices = list(/datum/objective/escape,
	/datum/objective/escape/survive)

/datum/objective_set/traitor/easy/genocide
	objective_list = list(/datum/objective/regular/job_genocide)
	escape_choices = list(/datum/objective/escape,
	/datum/objective/escape/survive)

/datum/objective_set/traitor/easy/massacre
	objective_list = list(/datum/objective/regular/assassinate,
	/datum/objective/regular/assassinate,
	/datum/objective/regular/assassinate,
	/datum/objective/regular/assassinate,
	/datum/objective/regular/assassinate,
	/datum/objective/regular/assassinate)
	escape_choices = list(/datum/objective/escape/kamikaze)

/datum/objective_set/traitor/easy/kill_heads
	objective_list = list(/datum/objective/regular/kill_heads)
	escape_choices = list(/datum/objective/escape/kamikaze,
	/datum/objective/escape/survive)

/datum/objective_set/traitor/easy/sabotage
	objective_list = list(/datum/objective/regular/damage_area,
	/datum/objective/regular/destroy_equipment)
	escape_choices = list(/datum/objective/escape)

/datum/objective_set/traitor/easy/havoc
	objective_list = list(/datum/objective/regular/damage_area,
	/datum/objective/regular/destroy_equipment,
	/datum/objective/regular/job_genocide)
	escape_choices = list(/datum/objective/escape/survive,
	/datum/objective/escape/kamikaze)

/datum/objective_set/traitor/easy/supremacy_and_hijack
	objective_list = list(/datum/objective/regular/traitor_supremacy)
	escape_choices = list(/datum/objective/escape/hijack)

/datum/objective_set/traitor/easy/damage_and_hijack
	objective_list = list(/datum/objective/regular/damage_area)
	escape_choices = list(/datum/objective/escape/hijack)

/datum/objective_set/traitor/easy/steal_and_hijack
	objective_list = list(/datum/objective/regular/steal)
	escape_choices = list(/datum/objective/escape/hijack)

/datum/objective_set/traitor/easy/noclones_and_hijack
	objective_list = list(/datum/objective/regular/no_clones)
	escape_choices = list(/datum/objective/escape/hijack)

/datum/objective_set/traitor/easy/steal_ai_brain
	objective_list = list(/datum/objective/regular/aikill)
	escape_choices = list(/datum/objective/escape)

/datum/objective_set/traitor/easy/borg_death
	objective_list = list(/datum/objective/regular/borgdeath)
	escape_choices = list(/datum/objective/escape)

/datum/objective_set/traitor/easy/dead_means_dead
	objective_list = list(/datum/objective/regular/borgdeath,
	/datum/objective/regular/no_clones)
	escape_choices = list(/datum/objective/escape/survive,
	/datum/objective/escape)

/datum/objective_set/traitor/easy/kill_all_silicons
	objective_list = list(/datum/objective/regular/aikill,
	/datum/objective/regular/borgdeath)
	escape_choices = list(/datum/objective/escape/survive)

/datum/objective_set/traitor/easy/bonsai_tree
	objective_list = list(/datum/objective/regular/bonsaitree,
	/datum/objective/regular/gimmick)
	escape_choices = list(/datum/objective/escape,
	/datum/objective/escape/survive)

// More difficult traitor objectives

/datum/objective_set/traitor/hard
	objective_list = list(/datum/objective/regular/assassinate,
	/datum/objective/regular/gimmick)
	escape_choices = list(/datum/objective/escape)

/datum/objective_set/traitor/hard/triple_assassinate_and_hijack
	objective_list = list(/datum/objective/regular/assassinate,
	/datum/objective/regular/assassinate,
	/datum/objective/regular/assassinate,
	/datum/objective/regular/no_clones)
	escape_choices = list(/datum/objective/escape/hijack)

/datum/objective_set/traitor/hard/double_genocide
	objective_list = list(/datum/objective/regular/job_genocide,
	/datum/objective/regular/job_genocide)
	escape_choices = list(/datum/objective/escape)

/datum/objective_set/traitor/hard/kill_all_silicons
	objective_list = list(/datum/objective/regular/aikill,
	/datum/objective/regular/borgdeath)
	escape_choices = list(/datum/objective/escape)

/datum/objective_set/traitor/hard/rampage
	objective_list = list(/datum/objective/regular/assassinate,
	/datum/objective/regular/damage_area,
	/datum/objective/regular/damage_area,
	/datum/objective/regular/destroy_equipment,
	/datum/objective/regular/destroy_equipment)
	escape_choices = list(/datum/objective/escape)