//FOR THE LAST TIME THIS IS NOT TEXT-TO-SPEECH! ITS TEXT-TO-TEXT.

/obj/item/device/speaker
	name = "Text-To-Speaker"
	desc = "Uhhhhhhhhhhhhhh! This isn't what you think it is."
	icon_state = "voice0"
	item_state = "analyzer"
	var/canuse = 0 //Cooldown for use.
	w_class = 1.0
	origin_tech = "materials=1"
	var/mob/living/simple_animal/text2speech/linkedmob
	New()
		..()
		var/mob/living/simple_animal/text2speech/X = new /mob/living/simple_animal/text2speech
		X.loc = src
		linkedmob = X


/obj/item/device/speaker/attack_self(mob/user)
	if(canuse == 0)
		canuse = 1
		user.visible_message("[user] is typing on \his [name]!")
		sleep(1)
		var/typerlist[] = list()
		var/newlaws = copytext(sanitize(input("Enter what you want the speaker to say for you", "Cancel", null)),1,MAX_NAME_LEN)
		for (var/mob/living/simple_animal/text2speech/A in src)
			typerlist += A
		if (typerlist.len)
			if(findtext(newlaws, "One day while")) //This is all to make sure that the person isn't trying to say someones name
				if(findtext(newlaws, "Andy")) //WGW protection
					if(findtext(newlaws, "Woody")) //WGW protection
						newlaws = replacetext(newlaws, "Woody", "[user.name]")
						newlaws = replacetext(newlaws, "Andy", "the Comdom")
			if(copytext(newlaws, 1, 2) != "*") //This fixes ", & and # from appearing because of how they work
				newlaws = replacetext(newlaws, "34;", "")
				newlaws = replacetext(newlaws, "amp;", "")
				newlaws = replacetext(newlaws, "#;", "")
				newlaws = replacetext(newlaws, "&", "")
				newlaws = replacetext(newlaws, "*", "")
			var/mob/living/simple_animal/text2speech/announcer = pick(typerlist)
			sleep(1)
			announcer.say("[newlaws]")
			sleep(1)
			icon_state = "voice1"
			sleep(250) //Spam prevention
			icon_state = "voice0"
			canuse = 0
	else
		user << "The Text-To-Speaker is recharging!"
		return 1




/obj/item/device/speaker/traitor
	name = "Text-To-Speaker"
	desc = "The device speaks for itself; with your input!."
	icon_state = "voice0"
	item_state = "analyzer"
	w_class = 1.0
	origin_tech = "materials=1"
	var/originalname = "Text-To-Speaker"
	New()
		..()
		new /mob/living/simple_animal/text2speech/tator(src)

/obj/item/device/speaker/traitor/attack_self(mob/user)
	if(canuse == 0)
		canuse = 1
		user.visible_message("[user] is typing on \his [name]!")
		sleep(1)
		var/typerlist[] = list()
		var/newlaws = copytext(sanitize(input("Enter what you want the speaker to say for you", "Cancel", null) as message),1,MAX_MESSAGE_LEN)
		for (var/mob/living/simple_animal/text2speech/A in living_mob_list)
			typerlist += A
		if (typerlist.len)
			var/mob/living/simple_animal/text2speech/announcer = pick(typerlist)
			announcer.name = originalname
			announcer.real_name = originalname
			sleep(1)
			announcer.say("[newlaws]")
			sleep(1)
			icon_state = "voice1"
			sleep(150) //Spam prevention
			icon_state = "voice0"
			canuse = 0
	else
		user << "The Text-To-Speaker is on cooldown!."
		return 1



/obj/item/device/speaker/traitor/verb/change()
	set name = "T2S"
	set category = "Object"
	if(canuse == 0)
		canuse = 1
		sleep(1)
		var/typerlist[] = list()
		var/newname = copytext(sanitize(input("Enter the name of the person you wish to speak as", "Cancel", null) as message),1,MAX_MESSAGE_LEN)
		var/newlaws = copytext(sanitize(input("Enter what you want the speaker to say for you", "Cancel", null) as message),1,MAX_MESSAGE_LEN)
		for (var/mob/living/simple_animal/text2speech/A in living_mob_list)
			typerlist += A
		if (typerlist.len)
			var/mob/living/simple_animal/text2speech/announcer = pick(typerlist)
			announcer.name = ("[newname]")
			sleep(1)
			announcer.say("[newlaws]")
			icon_state = "voice1"
			sleep(150) //Spam prevention
			icon_state = "voice0"
			canuse = 0
	else
		return 1





/*		//Scanning papers to read them. Tossed the idea because this thing is new in general and thus shouldn't have anything as powerful as this.


/obj/item/device/speaker/attack_self(obj/item/I as obj, mob/living/user as mob)
	if(istype(I,/obj/item/weapon/paper))
		if(canuse == 0)
			canuse = 1
			user.visible_message("[user] is scanning a piece of paper to read!")
			sleep(1)
			var/typerlist[] = list()
			var/newlaws = I.info
			for (var/mob/living/simple_animal/text2speech/A in living_mob_list)
				typerlist += A
			if (typerlist.len)
				var/mob/living/simple_animal/text2speech/announcer = pick(typerlist)
				announcer.say("[newlaws]")
				sleep(100)
				canuse = 0
	else
		user << "The Text-To-Speaker is on cooldown!."
		return 1


		*/