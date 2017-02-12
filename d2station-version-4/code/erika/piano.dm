
//if u want songs added
//send them to erika
//songs can now be hotplugged with a script
//if you've uploaded a song you can give it to me as well
//use dis format: http://url.com/songname.mp3 - Song Name
//HASS 2 BE in MP3!!!!!!!!!!!1

/sound/turntable/test
	file = 'TestLoop1.ogg'
	falloff = 2
	repeat = 1

var/getmusic2 = ""
var/songsText2 = ""
//online list:

/obj/machinery/party/piano
	name = "Space Piano MK2"
	desc = "Now with no shitty players."
	icon = 'musician.dmi'
	icon_state = "piano"
	density = 1
	var/mode = 0
	var/startTime = 0
	anchored = 1
	luminosity = 16
	var/song = 0
	var/songLength = 0
	var/songdata = 0
	var/list/songURLs = list() // Had to make two because BYOND
	var/list/songNames = list()
	var/songIndex = 1
	var/locktime = 0
	var/locked = 0
	var/waittime = 10
	var/songsText2 = null
	var/list/lines = null

/obj/machinery/party/piano/New()
	spawn(rand(3,10))
		var/getmusic2 = world.Export("http://78.47.53.54/ss13piano/listsongs.php")
		if(getmusic2)
			songsText2 = file2text(getmusic2["CONTENT"])
			lines = dd_text2list(songsText2, "\n")
			for(var/line in lines)
				if (!line)
					continue

				var/pos = findtext(line, " - ", 1, null)
				if (pos)
					var/url = copytext(line, 1, pos)
					var/name = copytext(line, pos + 3, length(line) + 1)
					songURLs += url
					songNames += name
		else
			songsText2 = ""
			lines = ""

/obj/machinery/party/piano/attack_ai()
	return

/obj/machinery/party/piano/attack_paw()
	return

/obj/machinery/party/turntable2/piano/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/keycard/piano))
		if(src.locked)
			src.locked = 0
			locktime = 1
			user << "\blue The [src.name] is now unlocked."
			return
		else
			src.locked = 1
			user << "\blue The [src.name] is now locked. The lock will automatically expire after three minutes or whenever you decide to unlock it."
			locktime = 180
			locktimer()
			return


/obj/machinery/party/piano/proc/locktimer()
	if(locktime <= 1)
		src.locked = 0
		locktime = 0
	if(locktime)
		locktime--
		spawn(10)
		locktimer()

/obj/machinery/party/piano/attack_hand(mob/user as mob)
	var/t = "<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><B>Jukebox Interface</B><br>Protip: CTRL+F for search feature.<br><br>"
	if (src.mode == 0)
		t += "<B>Off</B> "
	else
		t += "<A href='?src=\ref[src];mode=0'>Off</A> "
	if (src.mode == 1)
		t += "<B>Single</B> "
	else
		t += "<A href='?src=\ref[src];mode=1'>Single</A> "
	if (src.mode == 2)
		t += "<B>Loop</B> "
	else
		t += "<A href='?src=\ref[src];mode=2'>Loop</A> "
	if (src.mode == 3)
		t += "<B>List</B> "
	else
		t += "<A href='?src=\ref[src];mode=3'>List</A> "
	if (src.mode == 4)
		t += "<B>Shuffle</B> "
	else
		t += "<A href='?src=\ref[src];mode=4'>Shuffle</A> "
	t += "<br>"
	if(songNames)
		t += "Current song: [songNames[songIndex]]"
	t += "<br><br>"
	var/i
	for(i = 1,i <= songURLs.len,i++)
		t += "<A href='?src=\ref[src];song=[i]'>[songNames[i]]</A><br>"

//	t += "<A href='?src=\ref[src];song='>Title</A><br>"


	user << browse(t, "window=turntable;size=420x700")


/obj/machinery/party/piano/Topic(href, href_list)
	..()
	spawn(waittime)
		if(locked)
			usr << "This Jukebox has been locked."
			return attack_hand(usr)
		if (href_list["song"])
			var/id = text2num(href_list["song"])
			if (id < 1 || id > songURLs.len)
				return attack_hand(usr)
			songIndex = id
			var/url = songURLs[id]
			if (mode == 0)
				mode = 1
			song = "http://lemon.d2k5.com/ss13piano/[url]"
			startTime = world.timeofday
			for (var/client/C) // TODO: Make this only update for clients inside the area
				C.update_music()

			songLength = 99999 // bah
			var/http[] = world.Export("http://lemon.d2k5.com/ss13piano/length.php?url=[url]")
			if(http)
				songdata = text2num(file2text(http))
				songLength = songdata * 10 + 40
			return attack_hand(usr)
		if (href_list["mode"])
			var/mode = text2num(href_list["mode"])
			if (isnull(mode) || mode < 0 || mode > 4)
				return attack_hand(usr)
			if (src.mode == 0)
				return attack_hand(usr) // Select a song first fuckass (windows media player crashed so hard it froze my entire computer when trying to play without a selected song)
			src.mode = mode
			for (var/client/C) // TODO: Make this only update for clients inside the area
				C.update_music()
		return attack_hand(usr)

/obj/machinery/party/piano/process()
	if (src.mode > 0 && world.timeofday > startTime + songLength)
		switch (src.mode)
			if (1) // Turn it off
				src.mode = 0
			if (2) // Restart song
				songIndex = songIndex
				startTime = world.timeofday
				if (songIndex > songURLs.len)
					songIndex = 1
				song = "http://lemon.d2k5.com/ss13piano/[songURLs[songIndex]]"
				songLength = 99999 // bah
				var/http[] = world.Export("http://lemon.d2k5.com/ss13piano/length.php?url=[songURLs[songIndex]]")
				if(http)
					songdata = text2num(file2text(http))
					songLength = songdata * 10 + 40
			if (3) // Next song
				songIndex++
				startTime = world.timeofday
				if (songIndex > songURLs.len)
					songIndex = 1
				song = "http://lemon.d2k5.com/ss13piano/[songURLs[songIndex]]"
				songLength = 99999 // bah
				var/http[] = world.Export("http://lemon.d2k5.com/ss13piano/length.php?url=[songURLs[songIndex]]")
				if(http)
					songdata = text2num(file2text(http))
					songLength = songdata * 10 + 10
			if (4) // Random song
				songIndex = rand(1, songURLs.len)
				startTime = world.timeofday
				song = "http://lemon.d2k5.com/ss13piano/[songURLs[songIndex]]"
				songLength = 99999 // bah
				var/http[] = world.Export("http://lemon.d2k5.com/ss13piano/length.php?url=[songURLs[songIndex]]")
				if(http)
					songdata = text2num(file2text(http))
					songLength = songdata * 10 + 10
		for (var/client/C) // TODO: Make this only update for clients inside the area
			C.update_music()