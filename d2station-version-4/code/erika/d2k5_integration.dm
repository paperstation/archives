//Give Achievement
//WARNING: Achievement must be created in the forum control panel and its id is used here. These can only be created by erika.
//Usage: mob.achievement_give(<achievement name>, <achievement id>)
/mob/proc/achievement_give(name,id)
	if(src.client)
		if(src.client.goon)
			spawn(rand(1,5))
				var/achievementdebug = world.Export("http://78.47.53.54/requester.php?url=http://d2k5.com/doachievement.php@vals@ckey=[src.ckey]@and@aid=[id]")
				if(!achievementdebug)
					return "no key found"
				var/acontent = file2text(achievementdebug["CONTENT"])
				var/acode = lowertext(acontent)
				if(acode == "yes")
					src << "<font color=\"#54A300\"><b>You have unlocked the \"[name]\" achievement!</b> (<a href=\"http://d2k5.com/ss13unlocks.php?ckey=[src.ckey]\" target=\"_blank\">view all</a>)</font>"
					log_game("[src.key] has unlocked the \"[name]\" achievement")
				else
					return
		return

//Do Bank Transaction
//Amount can be negative or positive. If you use a negative amount it will take that amount from the members forum bank.
//You can do transactions as low as 0.01
//It returns 1 if the transaction went through and 0 if it did not, just in case you need to verify.
//Transactions will not go through if the user doesn't have enough money or there was some other error.

//If you want to see if they are authenticated with the forums, there is src.client.forumauthed, which works exactly just like src.client.goon. This can be used to give people bank cards, etc.

//Usage: doTransaction(<ckey>,<amount>,<description>)
/datum/proc/doTransaction(ckey,amount,description)
	var/achievementdebug = world.Export("http://78.47.53.54/requester.php?url=http://178.63.153.81/emauth.php@vals@ckey=[ckey]@and@doTransaction@and@amount=[amount]@and@description=[description]@and@type=Space Station 13")
	if(!achievementdebug)
		return "no key found"
	var/acontent = file2text(achievementdebug["CONTENT"])
	var/acode = lowertext(acontent)
	if(acode == "done")
		if(text2num(amount) < 0)
			score_moneyspent += text2num(amount)
		if(text2num(amount) > 0)
			score_moneyearned += text2num(amount)
		log_game("Transaction: [ckey] Amount: [amount] Description: [description]")
		return 1
	else
		return 0

/datum/proc/getBalance(ckey)
	var/getcurrency = world.Export("http://78.47.53.54/requester.php?url=http://178.63.153.81/emauth.php@vals@ckey=[ckey]@and@getCurrency")
	if(!getcurrency)
		return "no key found"
	var/currencycontent = file2text(getcurrency["CONTENT"])
	var/currency = lowertext(currencycontent)
	if(currency != "no key found")
		return currency
	else
		return "no key found"

//Usage: getInflation()
/datum/proc/getInflation()
	var/getcurrency = world.Export("http://78.47.53.54/requester.php?url=http://178.63.153.81/emauth.php@vals@getInflation")
	if(!getcurrency)
		return 0
	var/currencycontent = file2text(getcurrency["CONTENT"])
	var/currency = lowertext(currencycontent)
	if(currency)
		log_game("Inflation [currency]")
		return currency
	else
		return 0


//Mob Verbs
/mob/verb/ForumVerify()
	set name = "Verify Forum Integration"
	set category = "OOC"

	if (src.client)
		if(src.client.prisoner)
			usr << "Prisoners can't use the verify verb."
			return
		client.goonauth()

/mob/verb/memory()
	set name = "View Mind"
	set category = "Mind"
	if(mind)
		mind.show_memory(src)
	else
		src << "The game appears to have misplaced your mind datum, so we can't show you your notes."

/mob/verb/add_memory(msg as message)
	set name = "Add Thought"
	set category = "Mind"

	msg = copytext(msg, 1, MAX_MESSAGE_LEN)
	msg = sanitize(msg)

	if(mind)
		mind.store_memory(msg)
	else
		src << "The game appears to have misplaced your mind datum, so we can't show you your notes."

/mob/verb/StopMusic()
	set name = "Mute Sounds (until rejoin)"
	set category = "Commands"
	src << browse("", "window=rpane.hosttracker")
