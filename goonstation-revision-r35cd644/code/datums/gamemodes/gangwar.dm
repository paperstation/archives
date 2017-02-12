/datum/game_mode/gang
	name = "gang"
	config_tag = "gang"

	var/list/leaders = list()
	var/list/gangs = list()

	//List of gang stuff already used so that there are no repeats.
	var/list/tags_used = list()
	var/list/part1_used = list()
	var/list/part2_used = list()
	var/list/fullnames_used = list()
	var/list/item1_used = list()
	var/list/item2_used = list()
	var/list/frequencies_used = list()

	var/list/gang_lockers = list() //list of all existing gang lockers

	var/const/setup_min_teams = 2
	var/const/setup_max_teams = 4
	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 1800 //upper bound on time before intercept arrives (in tenths of seconds)

	var/current_max_gang_members = 3 //maximum number of gang members, not including the leader
	var/const/absolute_max_gang_members = 12

/datum/game_mode/gang/announce()
	boutput(world, "<B>The current game mode is - Gang War!</B>")
	boutput(world, "<B>A number of gangs are competing for control of the station!</B>")
	boutput(world, "<B>Gang members are normal crew except that they can kill other gang members without being banned.</B>")

/datum/game_mode/gang/pre_setup()
	var/num_players = 0
	for(var/mob/new_player/player in mobs)
		if(player.client && player.ready) num_players++

	var/num_teams = max(setup_min_teams, min(round((num_players) / 12), setup_max_teams)) //1 gang per 12 players

	var/list/leaders_possible = get_possible_leaders(num_teams)
	if (num_teams > leaders_possible.len)
		num_teams = leaders_possible.len

	if (!leaders_possible.len)
		return 0

	for(var/j = 0, j < num_teams, j++)
		var/datum/mind/leader = pick(leaders_possible)
		leaders += leader
		leaders_possible.Remove(leader)
		leader.special_role = "Gang Leader"

	return 1

/datum/game_mode/gang/post_setup()

	for (var/datum/mind/leaderMind in leaders)
		if (!leaderMind.current)
			continue

		generate_gang(leaderMind)
		bestow_objective(leaderMind,/datum/objective/specialist/gang)

		//ToDo: One of those goofy popup windows?
		boutput(leaderMind.current, "<h1><font color=red>You are the leader of the [leaderMind.gang.gang_name] gang!</font></h1>")
		boutput(leaderMind.current, "<span style=\"color:red\">You must recruit people to your gang and compete for wealth and territory!</span>")
		boutput(leaderMind.current, "<span style=\"color:red\">You can only harm other gang members and those who attack you. Try making deals with other people!</span>")
		boutput(leaderMind.current, "<span style=\"color:red\">You must wear your gang's uniform whenever possible.</span>")
		boutput(leaderMind.current, "<span style=\"color:red\">You can use the Set Gang Base command once which will make your current area into your gang's home turf and spawn a locker.</span>")
		boutput(leaderMind.current, "<span style=\"color:red\">People can join your gang by clicking on your locker, up to a limit of [current_max_gang_members].</span>")
		boutput(leaderMind.current, "<span style=\"color:red\">Once all active gangs are at the current maximum size, the member cap will increase, up to an absolute maximum of [absolute_max_gang_members].</span>")
		boutput(leaderMind.current, "<span style=\"color:red\">Build up a stash of cash, guns and drugs. They must be on your gang's home turf to count!</span>")
		boutput(leaderMind.current, "<span style=\"color:red\"><b>Turf, cash, guns and drugs all count towards victory, and your survival gives your gang bonus points!</b></span>")

		equip_leader(leaderMind.current)

	spawn (rand(waittime_l, waittime_h))
		send_intercept()

	spawn (20000)
		force_shuttle()

	return 1

/datum/game_mode/gang/proc/force_shuttle()
	if (!emergency_shuttle.online)
		emergency_shuttle.disabled = 0
		emergency_shuttle.incall()
		command_alert("Centcom is very disappointed in you all for this 'gang' silliness. The shuttle has been called.","Emergency Shuttle Update")

/datum/game_mode/gang/send_intercept()
	var/intercepttext = "Cent. Com. Update Requested staus information:<BR>"
	intercepttext += " Cent. Com has recently been contacted by the following syndicate affiliated organisations in your area, please investigate any information you may have:"

	var/list/possible_modes = list("revolution", "wizard", "nuke", "traitor", "changeling")
	var/number = pick(2, 3)
	var/i = 0
	for(i = 0, i < number, i++)
		possible_modes.Remove(pick(possible_modes))
	possible_modes.Insert(rand(possible_modes.len), "[ticker.mode]")

	var/datum/intercept_text/i_text = new /datum/intercept_text
	for(var/A in possible_modes)
		intercepttext += i_text.build(A, pick(leaders))

	for (var/obj/machinery/communications_dish/C in machines)
		C.add_centcom_report("Cent. Com. Status Summary", intercepttext)

	command_alert("Summary downloaded and printed out at all communications consoles.", "Enemy communication intercept. Security Level Elevated.")

/datum/game_mode/gang/proc/equip_leader(mob/living/carbon/human/leader)
	if (!istype(leader))
		return

	leader.verbs += /client/proc/gearspawn_gang

	return

/datum/game_mode/gang/proc/get_possible_leaders(minimum_leaders=1)
	var/list/candidates = list()

	for(var/mob/new_player/player in mobs)
		if (ishellbanned(player)) continue //No treason for you
		if ((player.client) && (player.ready) && !(player.mind in leaders) && !(player.mind in token_players) && !candidates.Find(player.mind))
			if(player.client.preferences.be_gangleader)
				candidates += player.mind

	if(candidates.len < minimum_leaders)
		logTheThing("debug", null, null, "<b>Enemy Assignment</b>: Not enough players with be_gangleader set to yes, including players who don't want to be misc enemies in the pool for Gang Leader selection.")
		for(var/mob/new_player/player in mobs)
			if (ishellbanned(player)) continue //No treason for you
			if ((player.client) && (player.ready) && !(player.mind in leaders) && !(player.mind in token_players) && !candidates.Find(player.mind))
				candidates += player.mind

				if (candidates.len >= minimum_leaders)
					break

	if(candidates.len < 1)
		return list()
	else
		return candidates

datum/game_mode/gang/check_finished()
	if(emergency_shuttle.location == 2)
		return 1

	if (no_automatic_ending)
		return 0

	var/leadercount = 0
	for (var/datum/mind/L in ticker.mode:leaders)
		leadercount++

	if(leadercount <= 1 && ticker.round_elapsed_ticks > 12000 && !emergency_shuttle.online)
		force_shuttle()

	else return 0

/datum/game_mode/gang/declare_completion()

	var/text = ""

	boutput(world, "<FONT size = 2><B>The gang leaders were: </B></FONT><br>")
	for(var/datum/mind/leader_mind in leaders)
		text = ""
		text += "<b>[leader_mind.gang.gang_name]</b><br>"
		if(leader_mind.current)
			text += "<b>Leader: </b>[leader_mind.current.real_name]"
			if(leader_mind.current.stat == 2) text += " (Dead)"
			else text += " (Survived)"
		else
			text += "<b>Leader: </b>[leader_mind.key] (Destroyed)"
		text += "<br><b>Members:</b> "
		if(!leader_mind.gang.members.len) text += "None!"
		else
			for(var/mob/living/carbon/member in leader_mind.gang.members)
				text += "[member.real_name]   "
		text += "<br><b>Areas Owned:</b> [leader_mind.gang.num_areas_controlled()]"
		text += "<br><b>Cash Pile:</b> $[leader_mind.gang.gang_cash_amount()]"
		text += "<br><b>Guns Stashed:</b> [leader_mind.gang.gang_gun_amount()]"
		text += "<br><b>Drug Score:</b> [leader_mind.gang.gang_drug_score()]"
		text += "<br><b>Total Score: [leader_mind.gang.gang_score()]</b>"
		text += "<br>"
		boutput(world, text)

	if (!check_winner())
		boutput(world, "<h2><b>The round was a draw!</b></h2>")

	else
		var/datum/mind/winner = check_winner()
		if (istype(winner))
			boutput(world, "<h2><b>[winner.gang.gang_name], led by [winner.current.real_name], won the round!</b></h2>")

	..() // Admin-assigned antagonists or whatever.

/datum/game_mode/gang/proc/generate_gang(datum/mind/leaderMind)
	leaderMind.gang = new /datum/gang
	leaderMind.gang.leader = leaderMind

	var/part1chosen = null
	var/part2chosen = null
	var/fullchosen = null

	leaderMind.gang.gang_tag = rand(0,22) // increase if you add more tags!

	while(leaderMind.gang.gang_tag in tags_used)
		leaderMind.gang.gang_tag = rand(0,22) // increase if you add more tags!

	tags_used += leaderMind.gang.gang_tag

	leaderMind.gang.gang_frequency = rand(1360,1420)

	while(leaderMind.gang.gang_frequency in frequencies_used)
		leaderMind.gang.gang_frequency = rand(1360,1420)

	frequencies_used += leaderMind.gang.gang_frequency

	while(leaderMind.gang.gang_name == "Gang Name")
		if(prob(10)) //Unique name.
			fullchosen = pick_string("gangwar.txt", "fullchosen")
			part1chosen = null
			part2chosen = null
			if (!(fullchosen in fullnames_used))
				leaderMind.gang.gang_name = fullchosen
				fullnames_used += fullchosen
		else
			var/list/part1 = pick_string("gangwar.txt", "part1")
			var/list/part2 = pick_string("gangwar.txt", "part2")
			part1chosen = pick(part1)
			part2chosen = pick(part2)
			fullchosen = null
			if (!(part1chosen in part1_used) && !(part2chosen in part2_used))
				leaderMind.gang.gang_name = part1chosen + " " + part2chosen
				part1_used += part1chosen
				part2_used += part2chosen

	var/list/under = list(/obj/item/clothing/under/gimmick/owl,/obj/item/clothing/under/suit/pinstripe,/obj/item/clothing/under/suit/purple,/obj/item/clothing/under/gimmick/chaps,/obj/item/clothing/under/misc/mail,/obj/item/clothing/under/gimmick/cosby,/obj/item/clothing/under/gimmick/princess,/obj/item/clothing/under/gimmick/merchant,/obj/item/clothing/under/gimmick/birdman,/obj/item/clothing/under/gimmick/safari,/obj/item/clothing/under/rank/det,/obj/item/clothing/under/shorts/red,/obj/item/clothing/under/shorts/blue,/obj/item/clothing/under/jersey/black,/obj/item/clothing/under/jersey,/obj/item/clothing/under/gimmick/rainbow,/obj/item/clothing/under/gimmick/johnny,/obj/item/clothing/under/misc/chaplain/rasta,/obj/item/clothing/under/misc/chaplain/atheist,/obj/item/clothing/under/misc/barber,/obj/item/clothing/under/rank/mechanic,/obj/item/clothing/under/misc/vice,/obj/item/clothing/under/gimmick,/obj/item/clothing/under/gimmick/bowling,/obj/item/clothing/under/misc/syndicate,/obj/item/clothing/under/misc/lawyer/black,/obj/item/clothing/under/misc/lawyer/red,/obj/item/clothing/under/misc/lawyer,/obj/item/clothing/under/gimmick/chav,/obj/item/clothing/under/gimmick/dawson,/obj/item/clothing/under/gimmick/sealab,/obj/item/clothing/under/gimmick/spiderman,/obj/item/clothing/under/gimmick/vault13,/obj/item/clothing/under/gimmick/duke,/obj/item/clothing/under/gimmick/psyche,/obj/item/clothing/under/misc/tourist)
	leaderMind.gang.item1 = pick(under)

	while(leaderMind.gang.item1 in item1_used)
		leaderMind.gang.item1 = pick(under)

	item1_used += leaderMind.gang.item1

	var/list/headwear = list(/obj/item/clothing/mask/owl_mask,/obj/item/clothing/mask/smile,/obj/item/clothing/mask/balaclava,/obj/item/clothing/mask/horse_mask,/obj/item/clothing/mask/melons,/obj/item/clothing/head/waldohat,/obj/item/clothing/head/that/purple,/obj/item/clothing/head/cakehat,/obj/item/clothing/head/wizard,/obj/item/clothing/head/that,/obj/item/clothing/head/wizard/red,/obj/item/clothing/head/wizard/necro,/obj/item/clothing/head/pumpkin,/obj/item/clothing/head/flatcap,/obj/item/clothing/head/mj_hat,/obj/item/clothing/head/genki,/obj/item/clothing/head/butt,/obj/item/clothing/head/mailcap,/obj/item/clothing/head/turban,/obj/item/clothing/head/helmet/bobby,/obj/item/clothing/head/helmet/viking,/obj/item/clothing/head/helmet/batman,/obj/item/clothing/head/helmet/welding,/obj/item/clothing/head/biker_cap,/obj/item/clothing/head/NTberet,/obj/item/clothing/head/rastacap,/obj/item/clothing/head/XComHair,/obj/item/clothing/head/chav,/obj/item/clothing/head/psyche,/obj/item/clothing/head/formal_turban,/obj/item/clothing/head/snake,/obj/item/clothing/head/powdered_wig,/obj/item/clothing/mask/spiderman,/obj/item/clothing/mask/gas/swat,/obj/item/clothing/mask/skull,/obj/item/clothing/mask/surgical)
	if(fullchosen && (fullchosen == "NICOLAS CAGE FAN CLUB"))
		leaderMind.gang.item2 = /obj/item/clothing/mask/niccage
	else
		leaderMind.gang.item2 = pick(headwear)

	while(leaderMind.gang.item2 in item2_used)
		leaderMind.gang.item2 = pick(headwear)

	item2_used += leaderMind.gang.item2

	gangs += leaderMind.gang

/datum/game_mode/gang/proc/check_winner()
	var/datum/mind/current_winner = null

	for(var/datum/mind/leader_mind in leaders) // Find the highest score
		if(!current_winner)
			current_winner = leader_mind
		else if(current_winner.gang.gang_score() < leader_mind.gang.gang_score())
			current_winner = leader_mind

	for(var/datum/mind/leader_mind in leaders) // See if two gangs have the highest score ie. it's a draw
		if(current_winner != leader_mind && current_winner.gang.gang_score() == leader_mind.gang.gang_score())
			return 0

	if (istype(current_winner))
		return current_winner

/datum/gang
	var/gang_name = "Gang Name"
	var/gang_tag = 0
	var/gang_frequency = 0
	var/obj/item/clothing/item1 = null
	var/obj/item/clothing/item2 = null
	var/area/base = null
	var/list/members = list()
	var/datum/mind/leader = null

	proc/num_areas_controlled()
		var/areacount = 0
		var/list/counted_areas = list()
		for(var/area/A in world)
			if(A.gang_owners == src && !(A in counted_areas))
				areacount ++
				counted_areas += A
		return areacount

	proc/gang_score()
		var/score = 0

		score += src.num_areas_controlled()*25
		if(leader.current && leader.current.stat != 2) score += 50

		//oh god
		for(var/obj/O in base)
			if(istype(O,/obj/item/plant/herb/cannabis)) score += 2
			else if(istype(O,/obj/item/gun)) score += 10
			else if(istype(O,/obj/item/spacecash)) score += (O:amount / 50)
			else if(O.reagents) //cant think of a better way to do this
				score += O.reagents.get_reagent_amount("bathsalts")
				score += O.reagents.get_reagent_amount("jenkem")/2
				score += O.reagents.get_reagent_amount("crank")*1.5
				score += O.reagents.get_reagent_amount("LSD")/2
				score += O.reagents.get_reagent_amount("space_drugs")/4
				score += O.reagents.get_reagent_amount("THC")/8 //i think this can be made in huge volumes with lots of weed? should encourage weed to be left in plant form
				score += O.reagents.get_reagent_amount("psilocybin")/2
				score += O.reagents.get_reagent_amount("krokodil")
				score += O.reagents.get_reagent_amount("catdrugs")
				score += O.reagents.get_reagent_amount("methamphetamine")*1.5 //meth

		return round(score)

	//procs below are for round end stats, i think for actual score calculations its more efficient to use the above though

	proc/gang_drug_score()
		var/score = 0

		for(var/obj/O in base)
			if(istype(O,/obj/item/plant/herb/cannabis)) score += 2
			else if(O.reagents) //cant think of a better way to do this
				score += O.reagents.get_reagent_amount("bathsalts")
				score += O.reagents.get_reagent_amount("jenkem")/2
				score += O.reagents.get_reagent_amount("crank")*1.5
				score += O.reagents.get_reagent_amount("LSD")/2
				score += O.reagents.get_reagent_amount("space_drugs")/4
				score += O.reagents.get_reagent_amount("THC")/8 //i think this can be made in huge volumes with lots of weed? should encourage weed to be left in plant form
				score += O.reagents.get_reagent_amount("psilocybin")/2
				score += O.reagents.get_reagent_amount("krokodil")
				score += O.reagents.get_reagent_amount("catdrugs")
				score += O.reagents.get_reagent_amount("methamphetamine")*1.5 //meth

		return round(score)

	proc/gang_gun_amount()
		var/number = 0

		for(var/obj/item/gun/G in base)
			number ++

		return round(number) //no point rounding it really but fuck it

	proc/gang_cash_amount()
		var/number = 0

		for(var/obj/item/spacecash/S in base)
			number += S.amount

		return round(number)

/client/proc/gearspawn_gang()
	set category = "Gang"
	set name = "Set Gang Base"
	set desc = "Permanently sets the area you're currently in as your gang's base. You will also receive equipment for your gang."

	var/area/area = get_area(usr)

	if(area.gang_base)
		boutput(usr, "<span style=\"color:red\">Another gang's base is in this area!</span>")
		return

	if(usr.stat)
		boutput(usr, "<span style=\"color:red\">Not when you're incapacitated.</span>")
		return

	usr.mind.gang.base = area
	area.gang_owners = usr.mind.gang
	area.gang_base = 1

	for(var/obj/decal/cleanable/gangtag/G in area)
		var/obj/decal/cleanable/gangtag/T = new /obj/decal/cleanable/gangtag(G.loc)
		T.icon_state = "gangtag[usr.mind.gang.gang_tag]"
		T.name = "[usr.mind.gang.gang_name] tag"
		T.owners = usr.mind.gang
		T.delete_same_tags()
		break

	var/obj/ganglocker/gearcloset = new /obj/ganglocker(usr.loc)
	gearcloset.name = "[usr.mind.gang.gang_name] Gear Locker"
	gearcloset.desc = "The words 'Property of [usr.mind.gang.gang_name] - DO NOT TOUCH!' have been scratched into the front of the locker."
	gearcloset.gang = usr.mind.gang
	ticker.mode:gang_lockers += gearcloset

	usr.verbs -= /client/proc/gearspawn_gang

	return

/mob/proc/gangpower()
	var/gangcount = 0
	if (!usr) return 0
	for (var/obj/item/clothing/C in usr.contents)
		if(istype(C,usr.mind.gang.item1) || istype(C,usr.mind.gang.item2))
			gangcount++
	if(gangcount > 1) return 1
	else return 0

/obj/item/spray_paint
	name = "Spraypaint Can"
	desc = "A can of spray paint."
	icon = 'icons/obj/items.dmi'
	icon_state = "spraycan"
	item_state = "spraycan"
	flags = FPRINT | EXTRADELAY | TABLEPASS | CONDUCT
	w_class = 2.0

	afterattack(target as turf|obj, mob/user as mob)
		if(!istype(target,/turf) && !istype(target,/obj/decal/cleanable/gangtag)) return

		if (!user)
			return

		var/turf/turftarget = get_turf(target)

		if(turftarget == loc || get_dist(src,target) > 1) return

		if(!user.mind || !user.mind.gang)
			boutput(user, "<span style=\"color:red\">You aren't in a gang, why would you do that?</span>")
			return

		var/area/getarea = get_area(turftarget)
		if(!getarea)
			boutput(user, "<span style=\"color:red\">You can't claim this place!</span>")
			return
		if(getarea.name == "Space")
			boutput(user, "<span style=\"color:red\">You can't claim space!</span>")
			return
		if((getarea.teleport_blocked) || istype(getarea, /area/supply) || istype(getarea, /area/shuttle/))
			boutput(user, "<span style=\"color:red\">You can't claim this place!</span>")
			return
		if(getarea.gang_owners == user.mind.gang)
			boutput(user, "<span style=\"color:red\">This place is already owned by your gang!</span>")
			return
		if(!istype(user,/mob/living/carbon/human))
			boutput(user, "<span style=\"color:red\">You don't have the dexterity to spray paint a gang tag!</span>")
		if(!user.gangpower())
			boutput(user, "<span style=\"color:red\">You must be wearing your gang's uniform to claim areas!</span>")
			return
		if(getarea.gang_owners && getarea.gang_owners != user.mind.gang && !turftarget.tagged)
			boutput(user, "<span style=\"color:red\">[getarea.gang_owners.gang_name] own this area! You must paint over their tag to capture it!</span>")
			return
		if(getarea.being_captured)
			boutput(user, "<span style=\"color:red\">Somebody is already tagging that area!</span>")
			return

		boutput(user, "You begin to spray your gang's tag.")
		getarea.being_captured = 1

		var/timer = 100
		while(timer > 0)
			if(do_after(user, 10))
				timer -= 10
			else
				boutput(user, "<span style=\"color:red\">You were interrupted!</span>")
				getarea.being_captured = 0
				return
			if(timer == 30 || timer == 60 || timer == 90) playsound(src, "sound/machines/hiss.ogg", 50, 0, 0, 1.5)

		if (user && user.mind)
			getarea.gang_owners = user.mind.gang
			var/obj/decal/cleanable/gangtag/T = new /obj/decal/cleanable/gangtag(turftarget)
			T.icon_state = "gangtag[user.mind.gang.gang_tag]"
			T.name = "[user.mind.gang.gang_name] tag"
			T.owners = user.mind.gang
			T.delete_same_tags()
			turftarget.tagged = 1
			getarea.being_captured = 0

		boutput(user, "<span style=\"color:blue\">You have claimed this area for your gang!</span>")

// /obj/decal/cleanable/gangtag moved to decal.dm

/obj/ganglocker
	desc = "Gang locker."
	name = "Gang Closet"
	icon = 'icons/obj/closet.dmi'
	icon_state = "secure"
	density = 1
	anchored = 1
	var/datum/gang/gang = null

	attack_hand(var/mob/living/carbon/human/user as mob)
		if(user.stat != 0)
			boutput(user, "<span style=\"color:red\">Not when you're incapacitated.</span>")
			return

		if(user.mind.gang == src.gang)
			get_gear(user)
			return

		if(user.mind.assigned_role in list("Security Officer","Head of Security","Captain","Head of Personnel")) //Let detectives join gangs, they don't get tasers etc anyway
			boutput(user, "<span style=\"color:red\">You are too responsible to join a gang!</span>")
			return

		if(user.mind in ticker.mode:leaders)
			boutput(user, "<span style=\"color:red\">You can't join a gang, you run your own!</span>")
			return

		if(src.gang.members.len >= ticker.mode:current_max_gang_members)
			boutput(user, "<span style=\"color:red\">That gang is full!</span>")
			return

		var/joingang = alert("Do you wish to join [src.gang.gang_name]?", "Gang", "Yes", "No")
		if (joingang == "No") return

		if(user.mind.gang) user.mind.gang.members -= user

		user.mind.gang = src.gang
		src.gang.members += user
		if (!usr.mind.special_role)
			usr.mind.special_role = "Gang Member"
		var/datum/objective/gangObjective = new /datum/objective/specialist/gang(  )
		gangObjective.owner = usr.mind
		gangObjective.explanation_text = "Protect your boss, recruit new members, tag up the station and beware the other gangs! [src.gang.gang_name] FOR LIFE!"
		usr.mind.objectives += gangObjective
		boutput(user, "<span style=\"color:blue\">You are now a member of [src.gang.gang_name]! You must wear your gang uniform.</span>")
		boutput(user, "<span style=\"color:blue\">Beware the other gangs. You can attack them if you want to, but that might start a war!</span>")
		boutput(user, "<span style=\"color:blue\">Capture turf for your gang by using spraypaint on other gangs' tags (or on any turf if the area is unclaimed).</span>")
		boutput(user, "<span style=\"color:blue\">Your gang will earn points for cash, drugs and guns on the floor in the same area as your locker.</span>")
		boutput(user, "<span style=\"color:blue\">Don't harm non-gang members unless they attack you first!</span>")

		get_gear(user)
		update_max_members()
		update_all_icons() //gang member cap might've increased in which case they all need updating

		return

	proc/get_gear(var/mob/living/carbon/human/user)
		if(user.mind.gang == src.gang) // Needs new gear? Maybe!
			var/hasitem1 = 0
			var/hasitem2 = 0
			var/haspaint = 0
			var/hasheadset = 0
			for(var/obj/item/I in user.contents)
				if(istype(I,user.mind.gang.item1))
					hasitem1 = 1
				if(istype(I,user.mind.gang.item2))
					hasitem2 = 1
				if(istype(I,/obj/item/spray_paint))
					haspaint = 1
				if(istype(I,/obj/item/device/radio/headset/gang) && I:secure_frequencies && I:secure_frequencies["h"] == src.gang.gang_frequency)
					hasheadset = 1
			if(hasitem1 && hasitem2 && hasheadset)
				if(!haspaint)
					boutput(user, "You take a can of spray paint from the locker.")
					var/obj/item/spray_paint/paint = new /obj/item/spray_paint(user)
					if(user.hand) user.equip_if_possible(paint,user.slot_l_hand)
					else user.equip_if_possible(paint,user.slot_r_hand)
					user.set_clothing_icon_dirty()
					return
				else
					boutput(user, "You already have all of your gang equipment!")
					return
			else
				var/obj/item/id = user.wear_id
				var/obj/item/beltitem = user.belt
				var/list/removeitems = list()
				if(!hasitem1) removeitems += user.w_uniform
				if(!hasitem2)
					removeitems += user.head
					removeitems += user.wear_mask
				if(!hasheadset) removeitems += user.ears
				for(var/obj/item/O in removeitems)
					//boutput(world, "removing [O]")
					user.u_equip(O)
					if (O)
						O.set_loc(user.loc)
						O.dropped(user)
						O.layer = initial(O.layer)

				if(!hasitem1)
					var/obj/item/clothing/under/item1 = new user.mind.gang.item1(user)
					item1.cant_self_remove = 1
					user.equip_if_possible(item1, user.slot_w_uniform)
					if(id)
						id.set_loc(user)
						user.equip_if_possible(id,user.slot_wear_id)
					if(beltitem)
						beltitem.set_loc(user)
						user.equip_if_possible(beltitem,user.slot_belt)
				if(!hasitem2)
					var/obj/item/clothing/under/item2 = new user.mind.gang.item2(user)
					item2.cant_self_remove = 1
					if(istype(item2,/obj/item/clothing/mask)) user.equip_if_possible(item2, user.slot_wear_mask)
					else if(istype(item2,/obj/item/clothing/head)) user.equip_if_possible(item2, user.slot_head)
				if(!hasheadset)
					var/obj/item/device/radio/headset/gang/headset = new /obj/item/device/radio/headset/gang(user)
					headset.set_secure_frequency("g",src.gang.gang_frequency)
					headset.name = "[src.gang.gang_name] Headset"
					user.equip_if_possible(headset, user.slot_ears)
				if(!haspaint)
					var/obj/item/spray_paint/paint = new /obj/item/spray_paint(user)
					if(user.hand) user.equip_if_possible(paint,user.slot_l_hand)
					else user.equip_if_possible(paint,user.slot_r_hand)

				boutput(user, "You take some equipment from the locker.")

				user.set_clothing_icon_dirty()

				return

	proc/can_be_joined() //basic for now but might be expanded on so I'm making it a proc of its own
		if(src.gang.members.len >= ticker.mode:current_max_gang_members)
			return 0

		return 1

	proc/update_icon()
		src.overlays = null
		if(can_be_joined())
			src.overlays += image('icons/obj/closet.dmi', "greenlight")
		else
			src.overlays += image('icons/obj/closet.dmi', "redlight")

	proc/update_all_icons()
		for(var/obj/ganglocker/G in ticker.mode:gang_lockers)
			update_icon()
		return

	proc/update_max_members()
		for(var/datum/gang/G in ticker.mode:gangs)
			var/dead_members = 0
			for(var/mob/M in G.members)
				if(M.stat == 2) dead_members++
			if(G.members.len != ticker.mode:current_max_gang_members && G.members.len != dead_members && G.leader.current && G.leader.current.stat != 2)
				return

		ticker.mode:current_max_gang_members = min(ticker.mode:absolute_max_gang_members, ticker.mode:current_max_gang_members + 3)