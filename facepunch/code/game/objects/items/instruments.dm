/obj/item/instrument
	name = "instrument"
	desc = "Makes sounds."
	icon = 'icons/obj/instruments.dmi'
	icon_state = ""
	//attack_verb = list("attacked", "bashed", "hit")
	//hitsound = ogg
	var/play_sound = null
	var/spam_delay = 10//Seconds till ready to play
	var/ready = 1

	attack_self(mob/user as mob)
		if(!ready || !play_sound)	return
		user.visible_message("<span class='warning'>[user] plays the [src]!</span>", "<span class='warning'>You play the [src]!</span>", "You hear a sound!")
		playsound(user, play_sound, 50, 1)
		ready = 0
		spawn(spam_delay*10)
			ready = 1

//Large things
/obj/structure/instrument/gong
	name = "gong"
	desc = "Space Japanese culture."
	icon_state = "gong"
	var/play_sound = "sound/effects/gong.ogg"
	icon = 'icons/obj/instruments.dmi'
	var/spam_delay = 10//Seconds till ready to play
	var/ready = 1
	anchored = 1
	density = 1

	attack_hand(mob/user as mob)
		if(!ready || !play_sound)	return
		user.visible_message("<span class='warning'>[user] plays [src]!</span>", "<span class='warning'>You play [src]!</span>", "You hear a sound!")
		playsound(src, play_sound, 50, 1)
		ready = 0
		spawn(spam_delay*10)
			ready = 1