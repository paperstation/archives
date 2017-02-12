/mob/verb/OOC(msg as text)
	set name = "OOC"
	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if (!src.client.authenticated || IsGuestKey(src.key))
		src << "You are not authorized to communicate over these channels."
		return
	if(!msg)
		return
	else if (!ooc_allowed && !src.client.holder)
		return
	else if (!dooc_allowed && !src.client.holder && (src.client.deadchat != 0))
		usr << "OOC for dead mobs has been turned off."
		return
	else if (src.client.muted)
		return
	else if (findtext(msg, "byond://") && !src.client.holder)
		src << "<B>Advertising other servers is not allowed.</B>"
		log_admin("[key_name(src)] has attempted to advertise in OOC.")
		message_admins("[key_name_admin(src)] has attempted to advertise in OOC.")
		return
	var/avatarembed = ""
	var/hostavatarembed = ""
	log_ooc("[src.name]/[src.key] : [msg]")
	for (var/client/C)
		if(C && C.mob && C.mob.client)
			if (src.client.holder && (!src.client.stealth || C.holder))
				if (src.client.holder.rank == "Host" || src.client.holder.rank == "Robustmin" || src.client.holder.rank == "Badmin")
					C.mob.ctab_message("OOC", "<font color=[src.client.ooccolor]><b><span class=\"prefix\">[hostavatarembed]OOC:</span> <span class=\"name\">[src.client.stealth ? src.client.fakekey : src.key]:</span> <span class=\"message\">[msg]</span></b></font>")
				else if (src.client.holder.rank == "Cluwne")
					C.mob.ctab_message("OOC", "<font color=#B3DB4D><b><span class=\"prefix\">[avatarembed]OOC:</span> <span class=\"name\">[src.client.stealth ? src.client.fakekey : src.key]:</span> <span class=\"message\">[msg]</span></b></font>")
				else
					C.mob.ctab_message("OOC", "<span class=\"adminooc\"><span class=\"prefix\">[avatarembed]OOC:</span> <span class=\"name\">[src.client.stealth ? src.client.fakekey : src.key]:</span> <span class=\"message\">[msg]</span></span>")
			else if (src.client.goon)
				C.mob.ctab_message("OOC", "<font color=#B36500><b><span class=\"prefix\">[avatarembed]OOC:</span> <span class=\"name\">[src.client.stealth ? src.client.fakekey : src.key]:</span> <span class=\"message\">[msg]</span></b></font>")
			else
				C.mob.ctab_message("OOC", "<span class=\"ooc\"><span class=\"prefix\">[avatarembed]OOC:</span> <span class=\"name\">[src.client.stealth ? src.client.fakekey : src.key]:</span> <span class=\"message\">[msg]</span></span>")

/mob/verb/esay(msg as text)
	set name = "esay"
	if (!src.client.authenticated || !src.client.goon)
		src << "You are not authorized to communicate over these channels."
		return
	if (src.client.muted)
		return
	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if (!msg)
		return

	log_ooc("D2K5 : [key_name(src)] : [msg]")
	var/avatarembed = ""
	for (var/client/C)
		if ((C && C.mob && C.mob.client) && (C.goon || C.holder))
			C.mob.ctab_message("OOC", "<font color=#009451><b><span class=\"prefix\">[avatarembed]GOLD:</span> <span class=\"name\">[src.client.stealth ? src.client.fakekey : src.key]:</span> <span class=\"message\">[msg]</span><b></font>")
