/mob/verb/adminhelp(msg as text)
	set category = "Commands"
	set name = "adminhelp"

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)

	if (!msg)
		return

	if (usr.client.muted)
		return

	for (var/client/C)
		if (C.holder)
			C.ctab_message("Admin", "\blue <b><font color=red>HELP: </font>[key_name(src, C.mob)](<A HREF='?src=\ref[C.holder];adminplayeropts=\ref[src]'>X</A>):</b> [msg]")
			C << sound('adminhelp.ogg', volume=70)

	usr << "\blue <b><font color=red>HELP: </font>[key_name(src, src.client.mob)]:</b> [msg]"
	usr << "Your message has been broadcast to administrators and relayed to the IRC."
	msg = sanitize(strip_html(dd_replaceText(dd_replaceText(dd_replaceText(msg,"&", ""), "#39;", ""), "&amp;", "")))
	world.Export("http://178.63.153.81/ss13/adminhelp/adminhelp.php?name=[key_name(src)]&msg=[msg]")

//	var/sqltime = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")
//	var/DBConnection/dbcon = new()
//	dbcon.Connect("dbi:mysql:[sqldb]:[sqladdress]:[sqlport]","[sqllogin]","[sqlpass]")
//	if(dbcon.IsConnected())
//		var/DBQuery/query = dbcon.NewQuery("INSERT INTO adminhelp (name, message, time) VALUES ('[key_name(src)]', '[msg]', '[sqltime]')")
//		query.Execute()
//		return
//	dbcon.Disconnect()
	return