/mob/proc/scorestats()
	var/dat = {"<B>Round Statistics and Score</B><BR><HR>"}
	if (ticker && ticker.mode && istype(ticker.mode, /datum/game_mode/nuclear))
		var/foecount = 0
		var/crewcount = 0
		var/bombdat = null
		for(var/datum/mind/M in ticker.mode:syndicates)
			foecount++
		for(var/mob/living/C in mobs)
			if (!istype(C,/mob/living/carbon/human) || !istype(C,/mob/living/silicon/robot) || !istype(C,/mob/living/silicon/ai)) continue
			if (C.stat == 2) continue
			if (!C.client) continue
			crewcount++
		dat += {"<B><U>MODE STATS</U></B><BR>
		<B>Number of Operatives:</B> [foecount]<BR>
		<B>Number of Surviving Crew:</B> [crewcount]<BR>
		<B>Final Location of Nuke:</B> [bombdat]<BR><BR>
		<B>Nuclear Disk Secure:</B> [score_disc ? "Yes" : "No"] ([score_disc * 500] Points)<BR>
		<B>Operatives Arrested:</B> [score_arrested] ([score_arrested * 1000] Points)<BR>
		<B>Operatives Killed:</B> [score_opkilled] ([score_opkilled * 250] Points)<BR>
		<B>Station Destroyed:</B> [score_nuked ? "Yes" : "No"] (-10000 Points)<BR>
		<B>All Operatives Arrested:</B> [score_allarrested ? "Yes" : "No"] (Score tripled)<BR>
		<HR>"}
	if (ticker && ticker.mode && istype(ticker.mode, /datum/game_mode/revolution))
		var/foecount = 0
		var/comcount = 0
		var/revcount = 0
		var/loycount = 0
		for(var/datum/mind/M in ticker.mode:head_revolutionaries)
			if (M.current && M.current.stat != 2) foecount++
		for(var/datum/mind/M in ticker.mode:revolutionaries)
			if (M.current && M.current.stat != 2) revcount++
		for(var/mob/living/carbon/human/player in mobs)
			if(player.mind)
				var/role = player.mind.assigned_role
				if(role in list("Captain", "Head of Security", "Head of Personnel", "Chief Engineer", "Research Director", "Medical Director"))
					if (player.stat != 2) comcount++
				else
					if(player.mind in ticker.mode:revolutionaries) continue
					loycount++
		for(var/mob/living/silicon/X in mobs)
			if (X.stat != 2) loycount++
		var/revpenalty = 10000
		dat += {"<B><U>MODE STATS</U></B><BR>
		<B>Number of Surviving Revolution Heads:</B> [foecount]<BR>
		<B>Number of Surviving Command Staff:</B> [comcount]<BR>
		<B>Number of Surviving Revolutionaries:</B> [revcount]<BR>
		<B>Number of Surviving Loyal Crew:</B> [loycount]<BR><BR>
		<B>Revolution Heads Arrested:</B> [score_arrested] ([score_arrested * 1000] Points)<BR>
		<B>Revolution Heads Slain:</B> [score_opkilled] ([score_opkilled * 500] Points)<BR>
		<B>Command Staff Slain:</B> [score_deadcommand] (-[score_deadcommand * 500] Points)<BR>
		<B>Revolution Successful:</B> [score_traitorswon ? "Yes" : "No"] (-[score_traitorswon * revpenalty] Points)<BR>
		<B>All Revolution Heads Arrested:</B> [score_allarrested ? "Yes" : "No"] (Score tripled)<BR>
		<HR>"}
	var/totalfunds = wagesystem.station_budget + wagesystem.research_budget + wagesystem.shipping_budget
	dat += {"<B><U>GENERAL STATS</U></B><BR>
	<U>THE GOOD:</U><BR>
	<B>Useful Items Shipped:</B> [score_stuffshipped] ([score_stuffshipped * 5] Points)<BR>
	<B>Hydroponics Harvests:</B> [score_stuffharvested] ([score_stuffharvested * 5] Points)<BR>
	<B>Ore Mined:</B> [score_oremined] ([score_oremined * 2] Points)<BR>
	<B>Refreshments Prepared:</B> [score_meals] ([score_meals * 5] Points)<BR>
	<B>Research Completed:</B> [score_researchdone] ([score_researchdone * 30] Points)<BR>
	<B>Cyborgs Constructed:</B> [score_cyborgsmade] ([score_cyborgsmade * 50] Points)<BR>"}
	if (emergency_shuttle.location == 2) dat += "<B>Shuttle Escapees:</B> [score_escapees] ([score_escapees * 25] Points)<BR>"
	dat += {"<B>Random Events Endured:</B> [score_eventsendured] ([score_eventsendured * 50] Points)<BR>
	<B>Whole Station Powered:</B> [score_powerbonus ? "Yes" : "No"] ([score_powerbonus * 2500] Points)<BR>
	<B>Ultra-Clean Station:</B> [score_mess ? "No" : "Yes"] ([score_messbonus * 3000] Points)<BR><BR>
	<U>THE BAD:</U><BR>
	<B>Dead Bodies on Station:</B> [score_deadcrew] (-[score_deadcrew * 25] Points)<BR>
	<B>Uncleaned Messes:</B> [score_mess] (-[score_mess] Points)<BR>
	<B>Station Power Issues:</B> [score_powerloss] (-[score_powerloss * 20] Points)<BR>
	<B>Rampant Diseases:</B> [score_disease] (-[score_disease * 30] Points)<BR>
	<B>AI Destroyed:</B> [score_deadaipenalty ? "Yes" : "No"] (-[score_deadaipenalty * 250] Points)<BR><BR>
	<U>THE WEIRD</U><BR>
	<B>Final Station Budget:</B> $[num2text(totalfunds,50)]<BR>"}
	var/profit = totalfunds - 100000
	if (profit > 0) dat += "<B>Station Profit:</B> +[num2text(profit,50)]<BR>"
	else if (profit < 0) dat += "<B>Station Deficit:</B> [num2text(profit,50)]<BR>"
	dat += {"<B>Food Eaten:</b> [score_foodeaten]<BR>
	<B>Shots Fired:</B> [game_stats.GetStat("gunfire")]<BR>
	<B>Times a Clown was Abused:</B> [score_clownabuse]<BR><BR>"}
	if (score_escapees)
		dat += {"<B>Richest Escapee:</B> [score_richestname], [score_richestjob]: $[num2text(score_richestcash,50)] ([score_richestkey])<BR>
		<B>Most Battered Escapee:</B> [score_dmgestname], [score_dmgestjob]: [score_dmgestdamage] damage ([score_dmgestkey])<BR>"}
	else
		if (emergency_shuttle.location != 2) dat += "The station wasn't evacuated!<BR>"
		else dat += "No-one escaped!<BR>"
	if (score_allstock_html)
		dat += "<B>Stock market top 5:</B><BR>[score_allstock_html]<BR><BR>"

	dat += {"<HR><BR>
	<B><U>FINAL SCORE: [score_crewscore]</U></B><BR>"}
	var/score_rating = "The Aristocrats!"
	switch(score_crewscore)
		if(-99999 to -50000) score_rating = "Even the Engine Deserves Better"
		if(-49999 to -5000) score_rating = "Engine Fodder"
		if(-4999 to -1000) score_rating = "You're All Fired"
		if(-999 to -500) score_rating = "A Waste of Perfectly Good Oxygen"
		if(-499 to -250) score_rating = "A Wretched Heap of Scum and Incompetence"
		if(-249 to -100) score_rating = "Outclassed by Lab Monkeys"
		if(-99 to -21) score_rating = "The Undesirables"
		if(-20 to 20) score_rating = "Ambivalently Average"
		if(21 to 99) score_rating = "Not Bad, but Not Good"
		if(100 to 249) score_rating = "Skillful Servants of Science"
		if(250 to 499) score_rating = "Best of a Good Bunch"
		if(500 to 999) score_rating = "Lean Mean Machine Thirteen"
		if(1000 to 4999) score_rating = "Promotions for Everyone"
		if(5000 to 9999) score_rating = "Ambassadors of Discovery"
		if(10000 to 49999) score_rating = "The Pride of Science Itself"
		if(50000 to INFINITY) score_rating = "NanoTrasen's Finest"
	dat += "<B><U>RATING:</U></B> [score_rating]<BR>"
	var/score_randomfact = "Somebody fucked something up."
	var/factselector = rand(0,100)
	if (factselector <= 30)
		//Game and chat related facts. (0-30)
		switch(factselector)
			if(0 to 3) score_randomfact = "That game lasted [ (world.time) / 600] minutes."
			if(4 to 7) score_randomfact = "[game_stats.GetStat("farts")] farts occurred during that game."
			if(8 to 11) score_randomfact = "There were [game_stats.GetStat("violence")] acts of violence during that game."
			if(12 to 15) score_randomfact = "[game_stats.GetStat("catches")] items were caught during that game."
			if(16 to 18) score_randomfact = "[game_stats.GetStat("fornoreason")] people reportedly did something terrible 'for no reason' during that game."
			if(19 to 22)
				var/griefwrongsum = game_stats.GetStat("grife") + game_stats.GetStat("grif") + game_stats.GetStat("griff") + game_stats.GetStat("greif") + game_stats.GetStat("grief_other")
				score_randomfact = "'Grief' was misspelled [griefwrongsum] times."
				if(factselector > 20 && game_stats.GetStat("grief") > 0) score_randomfact += " Conversely, somebody got it right [game_stats.GetStat("grief")] times."
			if(23 to 26) score_randomfact = "The AI was described using the French word for red a total of [game_stats.GetStat("rouge")] times."
			if(27 to 30) score_randomfact = "The word 'verily' was uttered [game_stats.GetStat("verily")] times."
	else if (factselector <= 60)
		//Environment facts. (31-60)
		if(factselector < 40)
			//Monkeys!
			var/fact_monkeycount = 0
			var/fact_monkeysdead = 0
			var/fact_monkeydiseases = 0
			var/fact_monkeysescaped = 0
			//Count all themonkeys.
			for (var/mob/M in mobs)
				if (!ismonkey(M))
					continue
				fact_monkeycount++
				//Count the dead ones.
				if (M.stat == 2) fact_monkeysdead++
				//Count diseased ones.
				if (M.ailments != null) fact_monkeydiseases++
				//See how many escaped.
				var/turf/location = get_turf(M.loc)
				var/area/escape_zone = locate(/area/shuttle/escape/centcom)
				if (location in escape_zone && M.stat != 2)
					fact_monkeysescaped++
				score_randomfact = "There were a total of [fact_monkeycount] monkeys in that game"
			switch(factselector)
				if(31 to 33) score_randomfact += "."
				if(34 to 35) score_randomfact += ", [fact_monkeysdead] of them are dead."
				if(36 to 37) score_randomfact += ", [fact_monkeydiseases] carried diseases."
				if(38 to 39)
					score_randomfact += ", [fact_monkeysescaped] safely made it to the escape shuttle. "
					if (fact_monkeysescaped == 0) score_randomfact += "You monsters."
		else if(factselector <= 50)
			//Butts!
			var/fact_butts = 0
			for (var/obj/item/clothing/head/butt/B in world)
				fact_butts++
			score_randomfact = "There were [fact_butts] disembodied butts existing at the end of the round."
		else
			//Farts!
			score_randomfact = "There were [game_stats.GetStat("farts")] farts during the round."
	else
		//Snail facts.
		score_randomfact = pick("A snail can sleep for three years.",
		"A snail can actually glide over the sharp edge of a knife or razor without harming itself. This has something to do with the mucus it produces.",
		"A garden snail has thousands of tiny teeth located on a ribbon-like tongue. They work like a file and rip the food to bits.",
		"Snails can gnaw through limestone. They eat the little bits of chalk in the rock which they need for their shells.",
		"As a snail grows its shell grows too.",
		"Snails can mate when they are about one year old.",
		"Snails are hermaphrodites (one organism is both male and female). However, they need to exchange sperm with each other to reproduce.",
		"Some snails can live up to 15 years.",
		"Snails are gastropods, which means 'belly footed'.",
		"Snails are one of around 50000 species of mollusc.",
		"The largest land snail ever found was 15 inches long and weighed 2 pounds!",
		"Snails rely mainly on touch and smell because they have very poor eyesight.",
		"Snails cannot hear.",
		"Snails are nocturnal animals which means they are more active at night.",
		"The fastest snails are the speckled garden snails which can move up to 55 yards per hour compared 23 inches per hour of most other land snails.",
		"Garden snails hibernate during the winter and live on their stored fat.",
		"Garden snails breathe with lungs.",
		"The largest land snail recorded was 12 inches long and weighed near 2 pounds.",
		"Snails are nocturnal animals, which means most of their movements take place at night.",
		"Snails don't like the brightness of sunlight, which is why you will find them out more on cloudy days.",
		"Snails will die if you put salt on them.",
		"The Giant African Land Snail is known to eat more than 500 different types of plants.",
		"Snails are very strong and can lift up to 10 times their own body weight in a vertical position.",
		"It is believed that there are at least 200,000 species of mollusks out there including snails. Although only 50,000 have been classified.")

	dat += "<B>FACT: </B> [score_randomfact]"
	src << browse(dat, "window=roundstats;size=500x650")
	return

/mob/proc/showtickets()
	if(!data_core.tickets.len && !data_core.fines.len) return

	var/dat = {"<B>Tickets</B><BR><HR>"}

	if(data_core.tickets.len)
		var/list/people_with_tickets = list()
		for (var/datum/ticket/T in data_core.tickets)
			if(!(T.target in people_with_tickets))
				people_with_tickets += T.target

		for(var/N in people_with_tickets)
			dat += "<b>[N]</b><br><br>"
			for(var/datum/ticket/T in data_core.tickets)
				if(T.target == N)
					dat += "[T.text]<br>"
		dat += "<br>"
	else
		dat += "No tickets were issued!<br><br>"

	dat += {"<B>Fines</B><BR><HR>"}

	if(data_core.fines.len)
		var/list/people_with_fines = list()
		for (var/datum/fine/F in data_core.fines)
			if(!(F.target in people_with_fines))
				people_with_fines += F.target

		for(var/N in people_with_fines)
			dat += "<b>[N]</b><br><br>"
			for(var/datum/fine/F in data_core.fines)
				if(F.target == N)
					dat += "[F.target]: [F.amount] credits<br>Reason: [F.reason]<br>[F.approver ? "[F.issuer != F.approver ? "Requested by: [F.issuer] - [F.issuer_job]<br>Approved by: [F.approver] - [F.approver_job]" : "Issued by: [F.approver] - [F.approver_job]"]" : "Not Approved"]<br>Paid: [F.paid_amount] credits<br><br>"
	else
		dat += "No fines were issued!"

	src << browse(dat, "window=roundstats;size=500x650")
	return