/client/proc/cmd_admin_say(msg as text)
	set category = "OOC"
	set name = "asay"
	set hidden = 1

	//	All admins should be authenticated, but... what if?

	if (!src.holder)
		src << "Only administrators may use this command."
		return

	if (!src.mob || src.muted)
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	log_admin("[key_name(src)] : [msg]")


	if (!msg)
		return

	for (var/client/C)
		if (C.holder)
			if (C.holder.rank != "Cluwne")
				if (C.holder.rank != "Gib")
					C.ctab_message("Admin", "<span class=\"admin\"><span class=\"prefix\">ADMIN:</span> <span class=\"name\">[key_name(usr, C.mob)]:</span> <span class=\"message\">[msg]</span></span>")
