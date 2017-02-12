//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/client/verb/wiki()
	set name = "wiki"
	set desc = "Visit the wiki."
	set hidden = 1
	if( config.wikiurl )
		if(alert("This will open the wiki in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.wikiurl)
	else
		src << "\red The wiki URL is not set in the server configuration."
	return

#define BUG_FILE "http://fluidsurveys.com/surveys/fpstation/bug-reports/"
/client/verb/bugs()
	set name = "bugs"
	set desc = "Report a bug."
	set hidden = 1
	if( config.forumurl )
		if(alert("This will open the bug reports form in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(BUG_FILE)
	else
		src << "\red Error."
	return

#undef BUG_FILE


/client/verb/tutorial()
	set name = "Tutorial"
	set desc = "Learn some basics."
	set hidden = 1
	if (ticker.current_state == 3)
		if (istype(src, /mob/living/carbon/human))
			src.screen += new/obj/screen/tutorialbasics
		else
			src << "\red You must be a human to do this!"
	else
		src << "\red The game must have started to do this!"
	return

/client/verb/forum()
	set name = "forum"
	set desc = "Visit the forum."
	set hidden = 1
	if( config.forumurl )
		if(alert("This will open the forum in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.forumurl)
	else
		src << "\red The forum URL is not set in the server configuration."
	return

#define interactivemap "http://www.maplib.net/fullmap.php?id=17203&legend=1"
#define mapfile "https://dl.dropboxusercontent.com/s/rp0a594s9rkimu9/FPStationmapv4.png?token_hash=AAHYzuyxIPuY9cOUK_jlwq_uUe6qvBfZv9Ev151BJMJHfA"
/client/verb/map()
	set name = "map"
	set desc = "Check the map."
	set hidden = 1
	if( mapfile && interactivemap)
		switch(alert("Would you like a plain map or interactive map?",,"Interactive","Plain", "Neither"))
			if("Interactive")
				src << link(interactivemap)
				return
			if("Plain")
				src << link(mapfile)
				return
			if("None")
				return
	else
		src << "\red The map is not set in the server configuration. Contact a coder."
	return
#undef mapfile
#undef interactivemap

#define RULES_FILE "config/rules.html"
/client/verb/rules()
	set name = "Rules"
	set desc = "Show Server Rules."
	set hidden = 1
	src << browse(file(RULES_FILE), "window=rules;size=480x320")
	usr.unlock_achievement("I'm Learning")
#undef RULES_FILE

/client/verb/displayend()
	set name = "Round Results"
	set desc = "Display the most recent round end results."
	set category = "OOC"

	var/tempstats = file2text("config/endlogs.txt")
	src << browse(tempstats,"window=endround;size=600x700;can_close=1")

/client/verb/changes()
	set name = "Changelog"
	set category = "OOC"
	getFiles(
		'html/postcardsmall.jpg',
		'html/somerights20.png',
		'html/88x31.png',
		'html/bug-minus.png',
		'html/cross-circle.png',
		'html/hard-hat-exclamation.png',
		'html/image-minus.png',
		'html/image-plus.png',
		'html/music-minus.png',
		'html/music-plus.png',
		'html/tick-circle.png',
		'html/wrench-screwdriver.png',
		'html/spell-check.png',
		'html/burn-exclamation.png',
		'html/chevron.png',
		'html/chevron-expand.png',
		'html/changelog.css',
		'html/changelog.js',
		'html/changelog.html'
		)
	src << browse('html/changelog.html', "window=changes;size=675x650")
	if(prefs.lastchangelog != changelog_hash)
		prefs.lastchangelog = changelog_hash
		prefs.save_preferences()
		winset(src, "rpane.changelog", "background-color=none;font-style=;")





/client/verb/hotkeys_help()
	set name = "hotkeys-help"
	set category = "OOC"

	var/hotkey_mode = {"<font color='purple'>
Hotkey-Mode: (hotkey-mode must be on)
\tTAB = toggle hotkey-mode
\ta = left
\ts = down
\td = right
\tw = up
\tq = drop
\te = equip
\tr = throw
\tt = say
\tx = swap-hand
\tz = activate held object (or y)
\tf = cycle-intents-left
\tg = cycle-intents-right
\t1 = help-intent
\t2 = disarm-intent
\t3 = grab-intent
\t4 = harm-intent
</font>"}

	var/other = {"<font color='purple'>
Any-Mode: (hotkey doesn't need to be on)
\tCtrl+Click = Start/Stop Pulling Target
\tAtl+Click = Point at Target
\tShift+Click = Examine Target
\tCtrl+a = left
\tCtrl+s = down
\tCtrl+d = right
\tCtrl+w = up
\tCtrl+q = drop
\tCtrl+e = equip
\tCtrl+r = throw
\tCtrl+x = swap-hand
\tCtrl+z = activate held object (or Ctrl+y)
\tCtrl+f = cycle-intents-left
\tCtrl+g = cycle-intents-right
\tCtrl+1 = help-intent
\tCtrl+2 = disarm-intent
\tCtrl+3 = grab-intent
\tCtrl+4 = harm-intent
\tDEL = pull
\tINS = cycle-intents-right
\tHOME = drop
\tPGUP = swap-hand
\tPGDN = activate held object
\tEND = throw
</font>"}

	var/admin = {"<font color='purple'>
Admin:
\tF5 = Aghost (admin-ghost)
\tF6 = player-panel-new
\tF7 = admin-pm
\tF8 = Invisimin
</font>"}

	src << hotkey_mode
	src << other
	if(holder)
		src << admin
