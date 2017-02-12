/mob/verb/who()
	set name = "Who"

	usr << "<b>Current Players:</b>"

	var/list/peeps = list()

	if (config.enable_authentication)
		for (var/mob/M in world)
			if (!M.client)
				continue

			if (M.client.authenticated && M.client.authenticated != 1)
				peeps += "\t[M.client] ([html_encode(M.client.authenticated)])"
			else
				peeps += "\t[M.client]"
	else
		for (var/mob/M in world)
			if (!M.client)
				continue

			if (M.client.stealth && !usr.client.holder)
				peeps += " [M.client.fakekey]"
			else if (M.client.goon)				//everyone is authed
				peeps += " <font color=\"#0F4C6F\">[M.client] [M.client.stealth ? "<i>(as [M.client.fakekey])</i>" : "(SomethingDickful Member)"]</font>"
			else
				peeps += " [M.client][M.client.stealth ? " <i>(as [M.client.fakekey])</i>" : ""]"
	peeps = sortList(peeps)

	for (var/p in peeps)
		usr << p

	usr << "<b>Total Players: [length(peeps)]</b>"

/client/verb/adminwho()
	set name = "Adminwho"
	set category = "Admin"
	usr << "<b>Current Admins:</b>"

	for (var/mob/M in world)
		if(M && M.client && M.client.holder && M.client.authenticated)
			if(usr.client.holder)
				usr << "[M.key] is a [M.client.holder.rank][M.client.stealth ? " <i>(as [M.client.fakekey])</i>" : ""]"
			else if(!M.client.stealth)
				usr << "\t[M.client]"
