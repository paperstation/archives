/proc/command_alert(var/text, var/title = "")
	for (var/obj/machinery/computer/communications/comm in machines)
		if (!(comm.stat & (BROKEN | NOPOWER)) && comm.prints_intercept)
			var/obj/item/weapon/paper/intercept = new /obj/item/weapon/paper( comm.loc )
			intercept.name = title
			intercept.info = text
			comm.messagetitle.Add("Cent. Com. Status Summary")
			//comm.messagetext.Add(intercepttext)

	radioalert("[title] An extended document about this has been printed on the communications console!","Communications Console","Command")

	world << "<h1 class='alert'>[station_name()] Update</h1>"

	if (title && length(title) > 0)
		world << "<h2 class='alert'>[sanitize(title)]</h2>"

	world << "<span class='alert'>[sanitize(text)]</span>"
	world << "<br>"
	world << sound('commandalert.ogg', volume=90)

	//TTS Status Updates
	var/ttscontent = world.Export("http://lemon.d2k5.com/tts/request.php?speech=[sanitize(text)]&volume_scale=1&save_mp3=1&make_audio=Text-To-Speech&announce")
	if(ttscontent)
		var/tts = file2text(ttscontent["CONTENT"])
		var dat = "<OBJECT id='mediaPlayer1' width=\"180\" height=\"32\"  classid='CLSID:22d6f312-b0f6-11d0-94ab-0080c74c7e95'  codebase='http://activex.microsoft.com/activex/controls/mplayer/en/nsmp2inf.cab#Version=5,1,52,701' standby='Loading Microsoft Windows Media Player components...' type='application/x-oleobject'> <param name='fileName' value=\"[tts]\"> <param name='animationatStart' value='false'> <param name='transparentatStart' value='false'> <param name='autoStart' value=\"true\"> <param name='showControls' value=\"true\"> <param name =\"ShowAudioControls\"value=\"true\">  <param name=\"ShowStatusBar\" value=\"false\"> <param name='loop' value=\"false\"> <param name='volume' value=\"50\"> <EMBED type='application/x-mplayer2' pluginspage='http://microsoft.com/windows/mediaplayer/en/download/' id='mediaPlayer' name='mediaPlayer' displaysize='4' autosize='-1'  bgcolor='darkblue' showcontrols=\"true\" showtracker='0'  showdisplay='0' showstatusbar='0' videoborder3d='0' width=\"420\" height=\"32\" src=\"[tts]\" autostart=\"true\" designtimesp='5311' loop=\"false\"> </EMBED> </OBJECT>"
		sleep(5)
		for(var/mob/M in mobz)
			if(istype(M, /mob))
				M << browse(dat, "window=rpane.hwload")
	//TTS Status Updates