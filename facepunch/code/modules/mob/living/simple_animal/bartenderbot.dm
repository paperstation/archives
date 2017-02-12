/mob/living/simple_animal/bartenderbot/
	name = "Barkeepsky"
	real_name = "Barkeepsky"
	desc = "Give Barkeepsy a shout yo!"
	speak_emote = list("beeps")
	icon_state = "beepsky"
	var/list/storedinfo = new/list()
	turns_per_move = 8
	var/used = 0
	var/dancing = 0

/*
	Move()
		if(dancing == 0)
			if(prob(5))
				playsound(src.loc, pick('sound/voice/barkeepsky.ogg', 'sound/voice/barkeepsky4.ogg', 'sound/voice/barkeepsky2.ogg', 'sound/voice/barkeepsky3.ogg'), 100, 0)
				visible_message("Whoop")
			else if(prob(5))
				playsound(src.loc, 'sound/ambience/TheRideNeverEnds.ogg', 30, 1, -2)
				dancing = 1
				visible_message("Whoop1")

*/

/*	Life()
		hear_talk()


/mob/living/simple_animal/bartenderbot/proc/hear_talk(mob/living/M as mob, msg)
	var/ending = copytext(msg, length(msg))
	storedinfo += "\"[msg]\""

*/







/*
/proc/hear(var/range, var/atom/source)

	var/lum = source.luminosity
	source.luminosity = 6

	var/list/heard = view(range, source)
	source.luminosity = lum

	return heard


	/proc/trigger(emote, source as mob)
		if(emote == "deathgasp")
			src.activate("death")
		return


	/proc/activate(var/cause)
		if((!cause) || (!src.imp_in))	return 0
		explosion(src, -1, 0, 2, 3, 0)//This might be a bit much, dono will have to see.
		if(src.imp_in)
			src.imp_in.gib()
			*/