/proc/command_alert(var/text, var/title = "")
	var/command
	command += "<h1 class='alert'>[command_name()] Update</h1>"

	if (title && length(title) > 0)
		command += "<br><h2 class='alert'>[html_encode(title)]</h2>"

	command += "<br><span class='alert'>[html_encode(text)]</span><br>"
	command += "<br>"
	for(var/mob/M in player_list)
		if(!istype(M,/mob/new_player))
			M << command




/proc/scommand_alert(var/text, var/title = "")
	var/scommand
	scommand += "<h1 class='alert'>[scommand_name()] Intercept</h1>"

	if (title && length(title) > 0)
		scommand += "<br><h2 class='alert'>[html_encode(title)]</h2>"

	scommand += "<br><span class='alert'>[html_encode(text)]</span><br>"
	scommand += "<br>"
	for(var/mob/M in player_list)
		if(!istype(M,/mob/new_player))
			M << scommand



/proc/vox_alert(var/input)
	var/list/tokens = dd_text2list(input, " ")
	for(var/t in tokens)
		t = lowertext(t)
		if(!voxsounds[t])
			continue
		for(var/client/C)
			spawn(0)
				C << sound(voxsounds[t], wait = 1, channel = 5)
