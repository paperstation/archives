/datum/admins/proc/player_notes(var/player)
	if(!player)
		return
	if (src.level < 0)
		alert("UM, EXCUSE ME??  YOU AREN'T AN ADMIN, GET DOWN FROM THERE!")
		usr << sound('sound/misc/poo2.ogg')
		return
	var/dat = text("")
	dat += text("")
	var/query = text("")
	query += config.player_notes_baseurl
	query += "playernotes.php?action=getnotes&ckey="
	query += text("[player]")
	var/http[] = world.Export(url_encode(query,1))

	if(!http)
		dat += "Query Failed."
		usr << browse(dat, "window=notesp;size=875x400")
		return

	var/key
	var/contentExists = 0
	for (key in http)
		if (key == "CONTENT")
			contentExists = 1

	if (0 == contentExists)
		dat += "Query Failed."
		usr << browse(dat, "window=notesp;size=875x400")
		return

	var/content = text("")
	content += file2text(http["CONTENT"])
	var/deletelinkpre = text("<A href='?src=\ref[src];action=notes2;target=[player];type=del;id=")
	var/deletelinkpost = text("'>(DEL)")
	var/regex/R = new("/!!ID(\\d+)/[deletelinkpre]$1[deletelinkpost]/")

	var/newcontent = R.Replace(content)
	while(newcontent)
		content = newcontent
		newcontent = R.ReplaceNext(content)

	dat += content
	dat = "<h1>Player Notes for <b>[player]</b></h1><HR></FONT><br><A href='?src=\ref[src];action=notes2;target=[player];type=add'>Add Note</A><br><HR>[dat]"
	usr << browse(dat, "window=notesp;size=875x400")
	return


/proc/add_player_note(player, admin, notetext)
	//var/akey = url_encode(text("[admin]"))
	//var/ckey = url_encode(text("[player]"))
	var/akey = text("[admin]")
	var/ckey = text("[player]")
	var/server = ""
	if (config && config.server_name != null)
		server = config.server_name
	else
		server = "server"

	notetext = dd_replacetext(notetext, "'", " ")
	notetext = dd_replacetext(notetext, "\"", " ")

	var/note = notetext
	var/query = text("")
	query += config.player_notes_baseurl
	query += "playernotes.php?action=addnote&ckey=[ckey]&serverid=[server]&akey=[akey]&note=[note]"
	query = url_encode(query, 1)
	boutput(usr, query)
	spawn(0) world.Export(query)