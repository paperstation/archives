/client/proc/authorize()
	set name = "Authorize"

	if (admins.Find(src.ckey))
		boutput(src, "<span class='ooc adminooc'>Admin IRC - #ss13centcom #ss13admin on irc.synirc.net</span>")
		if (!NT.Find(src.ckey))
			NT.Add(src.ckey)
			//src.mentor = 1
			return
		return

	if (NT.Find(src.ckey) || mentors.Find(src.ckey))
		src.mentor = 1
		src.mentor_authed = 1
		boutput(src, "<span class='ooc mentorooc'>You are a mentor!</span>")
		if (!src.holder)
			src.verbs += /client/proc/toggle_mentorhelps
		return

/client/proc/set_mentorhelp_visibility(var/set_as = null)
	if (!isnull(set_as))
		src.mentor = set_as
		src.see_mentor_pms = set_as
	else
		src.mentor = !(src.mentor)
		src.see_mentor_pms = src.mentor
	boutput(src, "<span class='ooc mentorooc'>You will [src.mentor ? "now" : "no longer"] see Mentorhelps [src.mentor ? "and" : "or"] show up as a Mentor.</span>")

/client/proc/toggle_mentorhelps()
	set name = "Toggle Mentorhelps"
	set category = "Toggles"
	set desc = "Show or hide mentorhelp messages. You will also no longer show up as a mentor in OOC and via the Who command if you disable mentorhelps."

	if (!src.mentor_authed && !src.holder)
		boutput(src, "<span style='color:red'>Only mentors may use this command.</span>")
		src.verbs -= /client/proc/toggle_mentorhelps // maybe?
		return

	src.set_mentorhelp_visibility()

/*
/proc/proxy_check(address)
	if(address)
		var/result = world.Export("http://autisticpowers.info/ss13/check_ip.php?ip=[address]")
		if("STATUS" in result && lowertext(result["STATUS"]) == "200 ok")
			var/using_proxy = text2num(file2text(result["CONTENT"]))
			if(using_proxy)
				return 1
	return 0
*/