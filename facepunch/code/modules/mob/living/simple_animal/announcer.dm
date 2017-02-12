/mob/living/simple_animal/announcer/
	name = "Arrivals Announcer"
	real_name = "Arrivals Announcer"
	desc = "Why are you looking at this?"
	icon_state = "cat"
	speak_emote = list("announces")
	canmove = 0

	New()
		..()
		var/MM	=	text2num(time2text(world.timeofday, "MM")) 	// get the current month
		var/DD	=	text2num(time2text(world.timeofday, "DD")) 	// get the current day
		if(DD == 31 && MM == 10)
			name = "Town Crier"
		if(DD == 25 && MM == 12)
			name = "Package Processor"

/mob/living/simple_animal/text2speech
	name = "Text-To-Speech Device"
	real_name = "Text-To-Speech Device"
	desc = "Why are you looking at this?"
	icon_state = "cat"
	speak_emote = list("says")
	canmove = 0

/mob/living/simple_animal/text2speech/tator
	name = "Text-To-Speech Device"
	real_name = "Text-To-Speech Device"
	desc = "Why are you looking at this?"
	icon_state = "cat"
	speak_emote = list("says")
	canmove = 0
