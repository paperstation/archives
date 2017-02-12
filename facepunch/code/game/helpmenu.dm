var/global/list/tiplist = list("A loyalty implant will allow you to use all kinds of guns, however certain antags might want to think twice about using an implant.",
	"If an Admin has wronged you or is \"blatantly abusing their powers\", make a complaint on the forums. We ENCOURAGE you to make one. If you have been truely wronged, making one proves it.",
	"Nations will never happen.",
	"IC in OOC is not tolerated <b>at all!</b> The round ends when the Emergency Escape shuttle docks with Central Command. No IC in OOC will be tolerated other than after that moment.",
	"The justification \"everyone else does it\" is more likely to get you in trouble if you break the rules and use it.",
	"A man chooses, a slave obeys. A Captain orders, a security officer is a player. If you know something breaks the rules and someone higher up tells you to do it, don't do it and instead adminhelp to let us know.",
	"We have a forum.",
	"If you are a Head of Staff or AI, adminhelp before leaving, especially if the round only recently started.",
	"If you know it is against the rules, don't do it.",
	"The Clown is a human.",
	"Your account is your responsibility, even if your \"brother\" or \"sister\" get on it and grief.",
	"Do not be a Rodrigo.",
	"Asking for admin axes your chances.",
	"If someone threatens to ban you and is not an admin, take it with a grain of salt.",
	"You are 99% less likely to be banned if you read the rules.",
	"There is a Map button at the very top of the screen. Can't miss it.",
	"Can't do the time? Don't do the crime.",
	"First time offence or not, its still an offence.",
	"Server lagging? The admins are obviously downloading porn.",
	"Spamming the cosby shirt removes your admin protection.",
	"If a person gets brigged three times, its safe to put them on the prison station.",
	"If an admin pms you and you drop everything you are doing and get killed, you stopped not us.",
	"Fire will not destroy or even harm a blob. It just kills people.")
var/global/tip = null

/client/verb/tip()
	set name = "Quick Menu"
	set category = "OOC"
	menu()


#define RULES_FILE "config/rules.html"
#define mapfile "https://dl.dropboxusercontent.com/s/rp0a594s9rkimu9/FPStationmapv4.png?token_hash=AAHYzuyxIPuY9cOUK_jlwq_uUe6qvBfZv9Ev151BJMJHfA"


//<A href='byond://?src=\ref[src];op=themescience'>Science Theme</A><BR>


/client/proc/menu()
	var/output = "<div align='center'><B>Quick Menu</B><br>"
	output += "Your Points: [prefs.points]<br>"
	output += "<A href='byond://?src=\ref[src];op=tip'>Tip of the Round</A><BR>"
	output += "<A href='byond://?src=\ref[src];op=rules'>Rules</A><BR>"
	output += "<A href='byond://?src=\ref[src];op=map'>Map</A><BR>"
//	output += "<A href='byond://?src=\ref[src];op=daily'>Daily Login Bonus</A><BR>"
	output += "</div>"
	src << browse(output,"window=quickmenu;size=250x240;can_close=1")
	return
/*
/client/
	var/datum/question/question

/client/New()
	..()
	var/datum/question/C = pick(questions_list)
	question = new C
/client/proc/dailylogin()

	world << "Press"

	var/output = "Test"
	world << "output"
	output += "<div align='center'><B>Daily Question - [rand(1,99)]% get this right!</B><br>"
	output += "[question]"
	output += "<A href='byond://?src=\ref[src];op=tip'>[question.a1]</A><BR>"
	output += "<A href='byond://?src=\ref[src];op=rules'>[question.a2]</A><BR>"
	output += "<A href='byond://?src=\ref[src];op=map'>[question.a3]</A><BR>"
	output += "<A href='byond://?src=\ref[src];op=daily'>[question.a4]</A><BR>"
	output += "</div>"
	src << browse(output,"window=zmenu;size=210x240;can_close=1")
	return
*/

client/Topic(href, href_list[])
	..()
	switch(href_list["op"])
		if("tip")
			src << tip
		if("rules")
			src << browse(file(RULES_FILE), "window=rules;size=480x320")
			usr.unlock_achievement("I'm Learning")
		if("map")
			src << link(mapfile)
//		if("daily")
//			dailylogin()

		/*
			src << "You get a point [src.prefs.points]"
			prefs.points++
			spawn(1)
				src.prefs.save_points()
				src << "You have [src.prefs.points] points"*/

#undef RULES_FILE
#undef mapfile
/client/proc/givepoint(num=1)
	prefs.points += num
	prefs.save_preferences()
	src << "\red You have [(num > 0) ? "gained" : "lost"] [abs(num)] point(s)."

/datum/question
	var/name
	var/question
	var/rightanswer
	var/a1
	var/a2
	var/a3
	var/a4

/datum/question/q1
	name = "What is Rule 1?"
	rightanswer = 2
	a1 = "Don't be a Rodrigo!!"
	a2 = "Don't be a Dick!!"
	a3 = "Don't grief!!"
	a4 = "Do not discuss the current round in OOC!!"

/datum/question/q2
	name =	"What does Valid/Legit mean?"
	rightanswer = 3
	a1 = "The person that killed me was a griefer."
	a2 = "Admins are on a Coffee break."
	a3 = "We can not give you information that could ruin the round."
	a4 = "Nothing."
/*
/datum/question/q3
	question = "Don't have objectives?"
	rightanswer = 1
	a1 = "You're not a traitor!"
	a2 = "You are a pirate!"
	a3 = "You are the AI!"
	a4 = "You are an admin!"

/datum/question/q4
	question = "At what point in the round can IC information be put into OOC?"
	rightanswer = 4
	a1 = "When the shuttle leaves the station."
	a2 = "When the shuttle docks with Central Command and the Round Results appear."
	a3 = "When I want to."
	a4 = "Never."

/datum/question/q5
	question = "Who is the host of the server?"
	rightanswer = 1
	a1 = "Foos"
	a2 = "Malanth"
	a3 = "Garry"
	a4 = "Rapefistversion2"


/datum/question/q6
	question = "Where is chemistry located?"
	rightanswer = 3
	a1 = "Space"
	a2 = "What's Chemistry?"
	a3 = "Research"
	a4 = "Medbay"

/datum/question/q7
	question = "Should you run straight to xenos and confess your love for them while embracing their facehuggers without offering any resistance whatsoever?"
	rightanswer = 3
	a1 = "Yes!"
	a2 = "Only if I don't ERP with them"
	a3 = "No."
	a4 = "Only if I rip my clothes off."


/datum/question/q8
	question = "Is the clown human?"
	rightanswer = 1
	a1 = "Yes."
	a2 = "No."
	a3 = "Maybe."
	a4 = "Its a cyborg.."


/datum/question/q9
	question = "Can security be antagonists?"
	rightanswer = 4
	a1 = "All security are antags.."
	a2 = "I only know of \"shitcurity\"."
	a3 = "Yes, but only sometimes."
	a4 = "Never."


/datum/question/q10
	question = "Can the head of personnel be an antagonist?"
	rightanswer = 3
	a1 = "No, but Ian can."
	a2 = "Yes."
	a3 = "No."
	a4 = "His chair is syndicate, he must be.."

/datum/question/q11
	question = "Can the captain be an antagonist?"
	rightanswer = 2
	a1 = "All condoms are antags in my eyes."
	a2 = "No."
	a3 = "Doesn't matter, space him anyways."
	a4 = "Yes."

/datum/question/q12
	question = "Does being stunned by security mean they're killing you?"
	rightanswer = 1
	a1 = "No."
	a2 = "Of course, especially if they cuff me too."
	a3 = "Only if I'm stunned in a public place."
	a4 = "Only if I'm stunned in a private place."
	*/