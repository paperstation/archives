// whatever man

/obj/machinery/bot/buttbot
	name = "buttbot"
	desc = "Well I... uh... huh."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "buttbot"
	layer = 5.0 // Todo layer
	density = 0
	anchored = 0
	on = 1
	health = 5
	no_camera = 1

/obj/machinery/bot/buttbot/cyber
	name = "robuttbot"
	icon_state = "cyberbuttbot"

/obj/machinery/bot/buttbot/process()
	if (prob(10) && src.on == 1)
		spawn(0)
			var/message = pick("butts", "butt")
			speak(message)
	if (src.emagged == 1)
		spawn(0)
			var/message = pick("BuTTS", "buTt", "b##t", "bztBUTT", "b^%t", "BUTT", "buott", "bats", "bates", "bouuts", "buttH", "b&/t", "beats", "boats", "booots", "BAAAAATS&/", "//t/%/")
			playsound(src.loc, "sound/vox/Poo.ogg", 50, 1)
			speak(message)

/obj/machinery/bot/buttbot/emag_act(var/mob/user, var/obj/item/card/emag/E)
	if (!src.emagged)
		if (user)
			user.show_text("You short out the vocal emitter on [src].", "red")
		spawn(0)
			src.visible_message("<span style=\"color:red\"><B>[src] buzzes oddly!</B></span>")
			playsound(src.loc, "sound/misc/poo2.ogg", 50, 1)
		src.emagged = 1
		return 1
	return 0

/obj/machinery/bot/buttbot/demag(var/mob/user)
	if (!src.emagged)
		return 0
	if (user)
		user.show_text("You repair [src]'s vocal emitter. Thank God.", "blue")
	src.emagged = 0
	return 1

/obj/machinery/bot/buttbot/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/card/emag))
		//Do not hit the buttbot with the emag tia
	else
		src.visible_message("<span style=\"color:red\">[user] hits [src] with [W]!</span>")
		switch(W.damtype)
			if("fire")
				src.health -= W.force * 0.5
			if("brute")
				src.health -= W.force * 0.5
			else
		if (src.health <= 0)
			src.explode()

/obj/machinery/bot/buttbot/hear_talk(var/mob/living/carbon/speaker, messages, real_name, lang_id)
	if(!messages || !src.on)
		return
	var/m_id = (lang_id == "english" || lang_id == "") ? messages[1] : messages[2]
	if(prob(25))
		var/list/speech_list = dd_text2list(messages[m_id], " ")
		if(!speech_list || !speech_list.len)
			return

		var/num_butts = rand(1,4)
		var/counter = 0
		while(num_butts)
			counter++
			num_butts--
			speech_list[rand(1,speech_list.len)] = "butt"
			if(counter >= (speech_list.len / 2) )
				num_butts = 0

		src.speak( dd_list2text(speech_list, " ") )
	return

/obj/machinery/bot/buttbot/gib()
	return src.explode()

/obj/machinery/bot/buttbot/explode()
	src.on = 0
	src.visible_message("<span style=\"color:red\"><B>[src] blows apart!</B></span>")
	var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
	s.set_up(3, 1, src)
	s.start()
	qdel(src)
	return