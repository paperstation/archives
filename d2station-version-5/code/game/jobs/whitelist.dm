var/list/whitelist

//define WHITELISTFILE "data/whitelist.txt"
/proc/load_whitelist()
	/*var/text = file2text(WHITELISTFILE)
	if (!text)
		diary << "Failed to [WHITELISTFILE]\n"
	else
		whitelist = dd_text2list(text, "\n")*/
	return

/proc/check_whitelist(mob/M /*, var/rank*/)
	var/feresult = world.Export("http://api.d2k5.com/ss13/auth.php?ckey=[M.ckey]&isCorrect")
	if(!feresult)
		return 1
	var/feresultcontent = file2text(feresult["CONTENT"])
	var/feresultcode = lowertext(feresultcontent)
	if(feresultcode == "yes")
		return 1
	else
		return 0

#undef WHITELISTFILE