/mob/verb/pray(msg as text)
	set category = "IC"
	set name = "Pray"
	if(!usr.client.authenticated)
		src << "Please authorize before sending these messages."
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)

	if (!msg)
		return

	if (src.client.muted)
		return

	for (var/client/C)
		if (C.holder)
			C.ctab_message("Admin", "\blue <b><font color=purple>PRAY: </font>[key_name(src, C.mob)](<A HREF='?src=\ref[C.holder];adminplayeropts=\ref[src]'>X</A>):</b> [msg]")

	usr << "Your prayers have been received by the gods."
	//log_admin("HELP: [key_name(src)]: [msg]")
