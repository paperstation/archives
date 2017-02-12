/mob/verb/who()
	set name = "Who"
	var/rendered = "---------------------<br>"

	var/list/whoAdmins = list()
	var/list/whoMentors = list()
	var/list/whoNormies = list()
	for (var/mob/M in mobs)
		if (!M.client) continue

		//Admins
		if (M.client.holder)
			var/thisW = "<span class='adminooc text-normal'>"
			if (usr.client.holder) //The viewer is an admin, we can show them stuff
				if (M.client.stealth || M.client.alt_key)
					thisW += "[M.client.key] <i>(as [M.client.fakekey])</i></span>"
					whoAdmins += thisW
				else
					thisW += "[M.client.key]</span>"
					whoAdmins += thisW

			else //A lowly normal person is viewing, hide!
				if (M.client.alt_key)
					thisW += "[M.client.fakekey]</span>"
					whoAdmins += thisW
				else if (M.client.stealth) // no you fucks don't show us as an admin anyway!!
					whoNormies += "<span class='ooc text-normal'>[M.client.fakekey]</span>"
				else
					thisW += "[M.client.key]</span>"
					whoAdmins += thisW

		//Mentors
		else if (M.client.mentor)
			whoMentors += "<span class='mentorooc text-normal'>[M.client.key]</span>"

		//Normies
		else
			whoNormies += "<span class='ooc text-normal'>[M.client.key]</span>"

	whoAdmins = sortList(whoAdmins)
	whoMentors = sortList(whoMentors)
	whoNormies = sortList(whoNormies)

	if (whoAdmins.len)
		rendered += "<b>Admins:</b><br>"
		for (var/anAdmin in whoAdmins)
			rendered += anAdmin + "<br>"
	if (whoMentors.len)
		rendered += "<b>Mentors:</b><br>"
		for (var/aMentor in whoMentors)
			rendered += aMentor + "<br>"
	if (whoNormies.len)
		rendered += "<b>Normal:</b><br>"
		for (var/aNormie in whoNormies)
			rendered += aNormie + "<br>"

	rendered += "<b>Total Players: [whoAdmins.len + whoMentors.len + whoNormies.len]</b><br>"
	rendered += "---------------------"
	boutput(usr, rendered)

/client/verb/adminwho()
	set category = "Commands"

	var/adwnum = 0
	var/rendered = ""
	rendered += "<b>Remember: even if there are no admins ingame, your adminhelps will still be sent to our IRC channel. Current Admins:</b><br>"

	for (var/mob/M in mobs)
		if (M && M.client && M.client.holder && !M.client.player_mode)
			if (usr.client.holder)
				if (M.client.holder.rank == "Administrator")
					rendered += "[M.key] is an [M.client.holder.rank][(M.client.stealth || M.client.fakekey) ? " <i>(as [M.client.fakekey])</i>" : ""]<br>"
				else
					rendered += "[M.key] is a [M.client.holder.rank][(M.client.stealth || M.client.fakekey) ? " <i>(as [M.client.fakekey])</i>" : ""]<br>"
			else
				if (M.client.alt_key)
					rendered += "&emsp;[M.client.fakekey]<br>"
					adwnum++
				else if (!M.client.stealth)
					rendered += "&emsp;[M.client]<br>"
					adwnum++

	rendered += "<br><b>Current Mentors:</b><br>"

	for (var/mob/M in mobs)
		if(M && M.client && M.client.mentor)
			rendered += "&emsp;[M.client]<br>"

	boutput(usr, rendered)

	if(!usr.client.holder)
		logTheThing("admin", usr, null, "used adminwho and saw [adwnum] admins.")
		logTheThing("diary", usr, null, "used adminwho and saw [adwnum] admins.", "admin")
		if(adwnum < 1)
			message_admins("<span style=\"color:blue\">[key_name(usr)] used adminwho and saw [adwnum] admins.</span>")