/datum/hook_handler/soundmanager
	proc
		HookMobAreaChange(var/list/args)
			var/mob/M = args["mob"]

			M.update_music()

		HookLogin(var/list/args)
			var/client/C = args["client"]
			var dat = "<OBJECT id='player' CLASSID='CLSID:6BF52A52-394A-11d3-B153-00C04F79FAA6' type='application/x-oleobject'></OBJECT><script>function noErrorMessages () { return true; } window.onerror = noErrorMessages; function SetMusic(url, time, volume) { var player = document.getElementById('player'); player.URL = url; player.Controls.currentPosition = time; player.Settings.volume = volume; }</script>"
			C << browse(dat, "window=rpane.hosttracker")
			src << output(list2params(list(C.musicURL, (world.timeofday - C.musicStartTime) / 10, C.musicVolume)), "rpane.hosttracker:SetMusic")

/mob/proc/update_music()
	if (client)
		client.update_music()

/client
	var
		musicURL = ""
		musicStartTime = 0
		musicVolume = 100

	proc/update_music()
		var/targetURL = ""
		var/targetStartTime = 0
		var/targetVolume = 100

		if (mob)
			var/area/A1 = get_area(mob)
			var/areaTag = copytext(A1.tag, 1, findtext(A1.tag, ":UL"))
			for (var/obj/machinery/party/turntable2/jukebox)
				var/area/A2 = get_area(jukebox)
				if (areaTag == copytext(A2.tag, 1, findtext(A2.tag, ":UL")) && jukebox.mode > 0)
					targetURL = jukebox.song
					targetStartTime = jukebox.startTime
					break
			for (var/obj/machinery/party/piano/jukebox)
				var/area/A2 = get_area(jukebox)
				if (areaTag == copytext(A2.tag, 1, findtext(A2.tag, ":UL")) && jukebox.mode > 0)
					targetURL = jukebox.song
					targetStartTime = jukebox.startTime
					break

		if (src.musicURL != targetURL || (targetStartTime - src.musicStartTime) > 1 || (targetStartTime - src.musicStartTime) < -1 || targetVolume != src.musicVolume)
			src << output(list2params(list(targetURL, (world.timeofday - targetStartTime) / 10, targetVolume)), "rpane.hosttracker:SetMusic")
			src.musicURL = targetURL
			src.musicStartTime = targetStartTime
			src.musicVolume = targetVolume