
var/list/department_radio_keys = list(
	  ":r" = "right hand",	"#r" = "right hand",	".r" = "right hand",
	  ":l" = "left hand",	"#l" = "left hand",		".l" = "left hand",
	  ":i" = "intercom",	"#i" = "intercom",		".i" = "intercom",
	  ":h" = "department",	"#h" = "department",	".h" = "department",
	  ":c" = "Command",		"#c" = "Command",		".c" = "Command",
	  ":n" = "Science",		"#n" = "Science",		".n" = "Science",
	  ":m" = "Medical",		"#m" = "Medical",		".m" = "Medical",
	  ":e" = "Engineering", "#e" = "Engineering",	".e" = "Engineering",
	  ":s" = "Security",	"#s" = "Security",		".s" = "Security",
	  ":w" = "whisper",		"#w" = "whisper",		".w" = "whisper",
	  ":b" = "binary",		"#b" = "binary",		".b" = "binary",
	  ":a" = "alientalk",	"#a" = "alientalk",		".a" = "alientalk",
	  ":t" = "Syndicate",	"#t" = "Syndicate",		".t" = "Syndicate",
	  ":u" = "Supply",		"#u" = "Supply",		".u" = "Supply",
	  ":g" = "changeling",	"#g" = "changeling",	".g" = "changeling",
	  ":z" = "starship",	"#z" = "starhip",		".z" = "starship",

	  ":R" = "right hand",	"#R" = "right hand",	".R" = "right hand",
	  ":L" = "left hand",	"#L" = "left hand",		".L" = "left hand",
	  ":I" = "intercom",	"#I" = "intercom",		".I" = "intercom",
	  ":H" = "department",	"#H" = "department",	".H" = "department",
	  ":C" = "Command",		"#C" = "Command",		".C" = "Command",
	  ":N" = "Science",		"#N" = "Science",		".N" = "Science",
	  ":M" = "Medical",		"#M" = "Medical",		".M" = "Medical",
	  ":E" = "Engineering",	"#E" = "Engineering",	".E" = "Engineering",
	  ":S" = "Security",	"#S" = "Security",		".S" = "Security",
	  ":W" = "whisper",		"#W" = "whisper",		".W" = "whisper",
	  ":B" = "binary",		"#B" = "binary",		".B" = "binary",
	  ":A" = "alientalk",	"#A" = "alientalk",		".A" = "alientalk",
	  ":T" = "Syndicate",	"#T" = "Syndicate",		".T" = "Syndicate",
	  ":U" = "Supply",		"#U" = "Supply",		".U" = "Supply",
	  ":G" = "changeling",	"#G" = "changeling",	".G" = "changeling",

	  //kinda localization -- rastaf0
	  //same keys as above, but on russian keyboard layout. This file uses cp1251 as encoding.
	  ":ê" = "right hand",	"#ê" = "right hand",	".ê" = "right hand",
	  ":ä" = "left hand",	"#ä" = "left hand",		".ä" = "left hand",
	  ":ø" = "intercom",	"#ø" = "intercom",		".ø" = "intercom",
	  ":ð" = "department",	"#ð" = "department",	".ð" = "department",
	  ":ñ" = "Command",		"#ñ" = "Command",		".ñ" = "Command",
	  ":ò" = "Science",		"#ò" = "Science",		".ò" = "Science",
	  ":ü" = "Medical",		"#ü" = "Medical",		".ü" = "Medical",
	  ":ó" = "Engineering",	"#ó" = "Engineering",	".ó" = "Engineering",
	  ":û" = "Security",	"#û" = "Security",		".û" = "Security",
	  ":ö" = "whisper",		"#ö" = "whisper",		".ö" = "whisper",
	  ":è" = "binary",		"#è" = "binary",		".è" = "binary",
	  ":ô" = "alientalk",	"#ô" = "alientalk",		".ô" = "alientalk",
	  ":å" = "Syndicate",	"#å" = "Syndicate",		".å" = "Syndicate",
	  ":é" = "Supply",		"#é" = "Supply",		".é" = "Supply",
	  ":ï" = "changeling",	"#ï" = "changeling",	".ï" = "changeling"
)

/mob/living/proc/binarycheck()
	if (istype(src, /mob/living/silicon/pai))
		return
	if (issilicon(src))
		return 1
	if (!ishuman(src))
		return
	var/mob/living/carbon/human/H = src
	if (H.ears)
		var/obj/item/device/radio/headset/dongle = H.ears
		if(!istype(dongle)) return
		if(dongle.translate_binary) return 1

/mob/living/proc/hivecheck()
	if (isalien(src)) return 1
	if (!ishuman(src)) return
	var/mob/living/carbon/human/H = src
	if (H.ears)
		var/obj/item/device/radio/headset/dongle = H.ears
		if(!istype(dongle)) return
		if(dongle.translate_hive) return 1

/mob/living/say(var/message)
	message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))

	if(!message)//Nothing to say
		return

	if(stat == 2)//Dead
		return say_dead(message)

	if(src.client)
		if(client.prefs.muted & MUTE_IC)
			src << "\red You cannot speak in IC (muted)."
			return
		if(src.client.handle_spam_prevention(message,MUTE_IC))
			return

	if (stat)	return//Knocked out
	if (sdisabilities & MUTE)	return// Mute disability
	if (istype(wear_mask, /obj/item/clothing/mask/muzzle))	return//Blocked by mask

	// emotes
	if(copytext(message, 1, 2) == "*" && !stat)
		return emote(copytext(message, 2))


	var/alt_name = ""
	if(istype(src, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = src
		if(name != GetVoice())
			alt_name = " (as [H.get_id_name("Unknown")])"
		/*else if(mind && H.wear_id) Currently commented out for the Halloween names, also because it breaks voice changers and changlings
			var/idjob = ""
			if(istype(H.wear_id,/obj/item/device/pda))
				var/obj/item/device/pda/pda = H.wear_id
				idjob = pda.ownjob
			else if(istype(H.wear_id,/obj/item/weapon/card/id))
				var/obj/item/weapon/card/id/id = H.wear_id
				idjob = id.assignment
			switch(idjob)//Some of the jobs use shorter titles because they are so long
				if("Head of Security")
					idjob = "HoS"
				if("Chief Engineer")
					idjob = "Chief"
				if("Quartermaster")
					idjob = "QM"
				if("Shaft Miner")
					idjob = "Miner"
				if("Head of Personnel")
					idjob = "HoP"
				if("Security Officer")
					idjob = "Officer"
				if("Research Director")
					idjob = "Director"
				if("Chief Medical Officer")
					idjob = "CMO"
				if("Medical Doctor")
					idjob = "Doctor"
				if("Station Engineer")
					idjob = "Engineer"
				if("Atmospheric Technician")
					idjob = "Technician"
			if(idjob && mind.job_title != idjob)
				alt_name = " ([idjob])"*/



	var/italics = 0
	var/message_range = null
	var/message_mode = null

	if(brain_damage >= 60 && prob(50))
		if(ishuman(src))
			message_mode = "headset"
	// Special message handling
	else if (copytext(message, 1, 2) == ";")
		if (ishuman(src))
			message_mode = "headset"
		else if(ispAI(src) || isrobot(src))
			message_mode = "pAI"
		message = copytext(message, 2)

	else if (length(message) >= 2)
		var/channel_prefix = copytext(message, 1, 3)

		message_mode = department_radio_keys[channel_prefix]
		//world << "channel_prefix=[channel_prefix]; message_mode=[message_mode]"
		if (message_mode)
			message = trim(copytext(message, 3))
			if(!(ishuman(src) || istype(src, /mob/living/simple_animal/parrot) || isrobot(src) && (message_mode=="department" || (message_mode in radiochannels))))
				message_mode = null //only humans can use headsets
			// Check changed so that parrots can use headsets. Other simple animals do not have ears and will cause runtimes.
			// And borgs -Sieve

	if(!message)
		return

	// :downs:
	if(brain_damage >= 60)
		message = replacetext(message, " am ", " ")
		message = replacetext(message, " is ", " ")
		message = replacetext(message, " are ", " ")
		message = replacetext(message, "you", "u")
		message = replacetext(message, "help", "halp")
		message = replacetext(message, "grief", "grife")
		message = replacetext(message, "space", "spess")
		message = replacetext(message, "carp", "crap")
		message = replacetext(message, "reason", "raisin")
		if(prob(50))
			message = uppertext(message)
			message += "[stutter(pick("!", "!!", "!!!"))]"
		if(!stuttering && prob(15))
			message = stutter(message)

	if(stuttering)
		message = stutter(message)

	var/list/obj/item/used_radios = new

	switch (message_mode)
		if("headset")
			if (src:ears)
				src:ears.talk_into(src, message)
				used_radios += src:ears

			message_range = 1
			italics = 1


		if("secure headset")
			if (src:ears)
				src:ears.talk_into(src, message, 1)
				used_radios += src:ears

			message_range = 1
			italics = 1

		if("right hand")
			if (r_hand)
				r_hand.talk_into(src, message)
				used_radios += src:r_hand

			message_range = 1
			italics = 1

		if("left hand")
			if(l_hand)
				l_hand.talk_into(src, message)
				used_radios += src:l_hand

			message_range = 1
			italics = 1

		if("intercom")
			for(var/obj/item/device/radio/intercom/I in view(1, null))
				I.talk_into(src, message)
				used_radios += I

			message_range = 1
			italics = 1

		//I see no reason to restrict such way of whispering
		if("whisper")
			whisper(message)
			return

		if("binary")
			if(robot_talk_understand || binarycheck())
			//message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN)) //seems redundant
				robot_talk(message)
			return

		if("alientalk")
			if(alien_talk_understand || hivecheck())
			//message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN)) //seems redundant
				alien_talk(message)
			return

		if("department")
			if(src:ears)
				src:ears.talk_into(src, message, message_mode)
				used_radios += src:ears
			message_range = 1
			italics = 1

		if("pAI")
			if(src:radio)
				src:radio.talk_into(src, message)
				used_radios += src:radio
			message_range = 1
			italics = 1

		if("changeling")
			if(mind && mind.changeling)
				for(var/mob/Changeling in mob_list)
					if((Changeling.mind && Changeling.mind.changeling) || istype(Changeling, /mob/dead/observer))
						Changeling << "<i><font color=#800080><b>[mind.changeling.changelingID]:</b> [message]</font></i>"
				return
////SPECIAL HEADSETS START
		else
			//world << "SPECIAL HEADSETS"
			if(message_mode in radiochannels)
				if(isrobot(src))//Seperates robots to prevent runtimes from the ear stuff
					var/mob/living/silicon/robot/R = src
					if(R.radio)//Sanityyyy
						R.radio.talk_into(src, message, message_mode)
						used_radios += R.radio
				else
					if (src:ears)
						src:ears.talk_into(src, message, message_mode)
						used_radios += src:ears
				message_range = 1
				italics = 1
/////SPECIAL HEADSETS END

	var/turf/To = get_turf(src)				//speaker's containing turf
	var/list/LOS = hear(message_range, To)	//all objects in line-of-sight of speaker's containing turf

	var/list/LOS_turfs = list()

	for(var/thing in LOS)
		if(isturf(thing))
			LOS_turfs += thing
		else if(isobj(thing))
			if(thing in used_radios)
				continue
			thing:hear_talk(src, message)


	var/msg_understood = say_quote(message)
	var/msg_deaf = "<span class='name'>[name][alt_name]</span> talks but you cannot hear them."
	var/msg_obscured = voice_message ? voice_message : say_quote(stars(message))
	if(italics)
		msg_understood = "<i>[msg_understood]</i>"
		msg_obscured = "<i>[msg_obscured]</i>"

	msg_understood = "<span class='game say'><span class='name'>[GetVoice()]</span>[alt_name] <span class='message'>[msg_understood]</span></span>"
	msg_obscured = "<span class='game say'><span class='name'>[voice_name]</span> <span class='message'>[msg_obscured]</span></span>"

	for(var/thing in player_list)
		var/mob/M = thing
		if(M == src)
			M.show_message(msg_understood, 2, "<span class='notice'>You cannot hear yourself!</span>", 2)
		else if(client && M.client.prefs && (M.stat == DEAD) && (M.client.prefs.toggles & CHAT_GHOSTEARS))
			M.show_message(msg_understood, 2)
		else
			var/turf/T = get_turf(M)
			if(T in LOS_turfs)
				if(M.say_understands(src))
					M.show_message(msg_understood, 2, msg_deaf, 1)
				else
					M.show_message(msg_obscured, 2)

	log_say("[name]/[key] : [message]")

/mob/living/proc/GetVoice()
	return name


