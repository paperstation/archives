/client/proc/authorize()
	set name = "Authorize"
	set category = "OOC"

	if (src.authenticating)
		return

	if (!config.enable_authentication)
		src.authenticated = 1
		return
	spawn(rand(1,5))
		src.authenticating = 1

		spawn (rand(4, 18))
			var/result = world.Export("http://lemon.d2k5.com/requester.php?url=http://178.63.153.81/emauth.php@vals@ckey=[src.ckey]@and@isGold")
			var/success = 0
			if(result)
				var/content = file2text(result["CONTENT"])

				var/pos = findtext(content, " ")
				var/code
				var/account = ""

				if (!pos)
					code = lowertext(content)
				else
					code = lowertext(copytext(content, 1, pos))
					account = copytext(content, pos + 1)

				if (code == "ok" && account)
					src.verbs -= /client/proc/authorize
					src.authenticated = account
					src << "\green Gold Member verification successful."
					success = 1

				if (!success)
					src.verbs += /client/proc/authorize
					src << "\red Gold Member verification failed. This is most likely because you are not a Gold Member."
					src.goon = null
			src.authenticating = 0

/client/proc/goonauth()
	set name = "D2K5 Auth"
	set category = "OOC"

	/*if (src.authenticating)
		return*/
	spawn(rand(1,5))
		var/feresult = world.Export("http://lemon.d2k5.com/requester.php?url=http://178.63.153.81/emauth.php@vals@ckey=[src.ckey]@and@isCorrect")
		if(feresult)
			var/feresultcontent = file2text(feresult["CONTENT"])
			var/feresultcode = lowertext(feresultcontent)
			if(feresultcode == "yes")
				src << "\green Forum verification successful."
				src.forumauthed = 1
			else
				src << "\red Forum verification failed. <b>Please go to <a href=\"http://d2k5.com/account/contact-details\" target=\"_blank\">Preferences > Contact Details</a> and enter your BYOND Username.</b>"

			if (config.enable_authentication)	//so that this verb isn't used when its goon only
				if(src.authenticated && src.authenticated != 1)
					src.goon = src.authenticated
					src.verbs -= /client/proc/goonauth
					src << "\red Gold Member verification failed. This is most likely because you are not a Gold Member."
					//src << "\blue[auth_motd]"
				else
					src << "Please authorize first"
				return

			src.authenticating = 1

			spawn (rand(4, 18))
				var/result = world.Export("http://lemon.d2k5.com/requester.php?url=http://178.63.153.81/emauth.php@vals@ckey=[src.ckey]@and@isGold")
				var/success = 0

				var/content = file2text(result["CONTENT"])

				var/pos = findtext(content, " ")
				var/code
				var/account = ""

				if (!pos)
					code = lowertext(content)
				else
					code = lowertext(copytext(content, 1, pos))
					account = copytext(content, pos + 1)

				if (code == "ok" && account)
					src.verbs -= /client/proc/goonauth
					src.goon = account
					src << "\green Gold Member verification successful."
					//src << "\blue[auth_motd]"
					success = 1

				if (!success)
					src.verbs += /client/proc/goonauth
					src << "\red Gold Member verification failed. This is most likely because you are not a Gold Member."
					src.goon = null

				if(feresultcode != "yes")
					src << "\red[no_auth_motd]"

			src.authenticating = 0

var/goon_keylist[0]
var/list/beta_tester_keylist

/proc/beta_tester_loadfile()
	beta_tester_keylist = new/list()
	var/text = file2text("config/testers.txt")
	if (!text)
		diary << "Failed to load config/testers.txt\n"
	else
		var/list/lines = dd_text2list(text, "\n")
		for(var/line in lines)
			if (!line)
				continue

			var/tester_key = copytext(line, 1, 0)
			beta_tester_keylist.Add(tester_key)


/proc/goon_loadfile()
	var/savefile/S=new("data/goon.goon")
	S["key[0]"] >> goon_keylist
	log_admin("Loading goon_keylist")
	if (!length(goon_keylist))
		goon_keylist=list()
		log_admin("goon_keylist was empty")

/proc/goon_savefile()
	var/savefile/S=new("data/goon.goon")
	S["key[0]"] << goon_keylist

/proc/goon_key(key as text,account as text)
	var/ckey=ckey(key)
	if (!goon_keylist.Find(ckey))
		goon_keylist.Add(ckey)
	goon_keylist[ckey] = account
	goon_savefile()

/proc/isgoon(X)
	if (istype(X,/mob)) X=X:ckey
	if (istype(X,/client)) X=X:ckey
	if ((ckey(X) in goon_keylist)) return 1
	else return 0

/proc/istester(X)
	if (istype(X,/mob)) X=X:ckey
	if (istype(X,/client)) X=X:ckey
	if ((ckey(X) in beta_tester_keylist)) return 1
	else return 0

/proc/remove_goon(key as text)
	var/ckey=ckey(key)
	if (key && goon_keylist.Find(ckey))
		goon_keylist.Remove(ckey)
		goon_savefile()
		return 1
	return 0
