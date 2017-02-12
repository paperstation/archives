/mob/verb/adminhelp(msg as text)
	set category = "Admin"
	set name = "Adminhelp"
	if(!usr.client.authenticated)
		src << "Please authorize before sending these messages."
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)

	if (!msg)
		return

	if (usr.client.muted)
		return

	for (var/mob/M in mobz)
		if (M.client && M.client.holder)
			M << "\blue <b><font color=red>HELP: </font>[key_name(src, M)](<A HREF='?src=\ref[M.client.holder];adminplayeropts=\ref[src]'>X</A>):</b> [msg]"

	usr << "Your message has been broadcast to administrators and relayed to the IRC."
	world.Export("http://78.47.53.54/requester.php?url=http://lemon.d2k5.com/adminhelp/adminhelp.php@vals@name=[key_name(src)]@and@msg=[msg]")
	log_admin("HELP: [key_name(src)]: [msg]")
