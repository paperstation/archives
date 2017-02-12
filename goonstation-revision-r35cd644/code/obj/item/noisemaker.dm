/obj/item/noisemaker
	name = "Sound Synthesiser"
	desc = "Either the most awesome or most annoying thing in the universe, depending on which side of it you're on."
	icon = 'icons/obj/instruments.dmi'
	icon_state = "bike_horn"
	var/mode = "honk"
	var/custom_file = null

	attack_self(var/mob/user as mob)
		if(custom_file)
			playsound(src.loc, custom_file, 100, 1)
			return
		switch(src.mode)
			if ("honk") playsound(src.loc, "sound/items/bikehorn.ogg", 50, 1)
			if ("fart")
				if (farting_allowed)
					playsound(src.loc, "sound/misc/poo2_robot.ogg", 50, 1)
			if ("burp") playsound(src.loc, "sound/misc/burp_alien.ogg", 50, 1)
			if ("squeak") playsound(src.loc, "sound/misc/clownstep1.ogg", 50, 1)
			if ("cat") playsound(src.loc, "sound/effects/cat.ogg", 50, 1)
			if ("harmonica")
				var/which = rand(1,3)
				switch(which)
					if(1) playsound(src.loc, "sound/items/harmonica1.ogg", 50, 1)
					if(2) playsound(src.loc, "sound/items/harmonica2.ogg", 50, 1)
					if(3) playsound(src.loc, "sound/items/harmonica3.ogg", 50, 1)
			if ("vuvuzela") playsound(src.loc, "sound/items/vuvuzela.ogg", 45, 1)
			if ("bang") playsound(src.loc, "sound/effects/bang.ogg", 40, 1)
			if ("buzz") playsound(src.loc, "sound/machines/warning-buzzer.ogg", 50, 1)
			if ("gunshot") playsound(src.loc, "sound/weapons/Gunshot.ogg", 50, 1)
			if ("siren") playsound(src.loc, "sound/machines/siren_police.ogg", 50, 1)
			if ("coo") playsound(src.loc, "sound/misc/babynoise.ogg", 50, 1)
			if ("rimshot") playsound(src.loc, "sound/misc/rimshot.ogg", 50, 1)
			if ("trombone") playsound(src.loc, "sound/misc/trombone.ogg", 50, 1)
			if ("un2") playsound(src.loc, "sound/effects/screech.ogg", 50, 1)
			if ("un3") playsound(src.loc, "sound/effects/yeaaahhh.ogg", 50, 1)
			else playsound(src.loc, "sound/machines/buzz-two.ogg", 50, 1)

	attack(mob/M as mob, mob/user as mob, def_zone)
		var/newmode = input("Select sound to play", "Make some noise", src.mode) in list("honk", "fart", "burp", "squeak", "cat", "harmonica", "vuvuzela", "bang", "buzz", "gunshot", "siren", "coo", "rimshot", "trombone")
		/*
		switch(src.mode)
			if ("honk")
				if (farting_allowed)
					boutput(user, "<span style=\"color:blue\">Mode is now: Farter</span>")
					src.mode = "fart"
				else
					boutput(user, "<span style=\"color:blue\">Mode is now: Burper</span>")
					src.mode = "burp"
			if ("fart")
				boutput(user, "<span style=\"color:blue\">Mode is now: Burper</span>")
				src.mode = "burp"
			if ("burp")
				boutput(user, "<span style=\"color:blue\">Mode is now: Squeaker</span>")
				src.mode = "squeak"
			if ("squeak")
				boutput(user, "<span style=\"color:blue\">Mode is now: Cat</span>")
				src.mode = "cat"
			if ("cat")
				boutput(user, "<span style=\"color:blue\">Mode is now: Harmonica</span>")
				src.mode = "harmo"
			if ("harmo")
				boutput(user, "<span style=\"color:blue\">Mode is now: Vuvuzela</span>")
				src.mode = "vuvuz"
			if ("vuvuz")
				boutput(user, "<span style=\"color:blue\">Mode is now: Banger</span>")
				src.mode = "bang"
			if ("bang")
				boutput(user, "<span style=\"color:blue\">Mode is now: Buzzer</span>")
				src.mode = "buzz"
			if ("buzz")
				boutput(user, "<span style=\"color:blue\">Mode is now: Shooter</span>")
				src.mode = "gunshot"
			if ("gunshot")
				boutput(user, "<span style=\"color:blue\">Mode is now: Siren</span>")
				src.mode = "siren"
			if ("siren")
				boutput(user, "<span style=\"color:blue\">Mode is now: Coo</span>")
				src.mode = "coo"
			if ("coo")
				boutput(user, "<span style=\"color:blue\">Mode is now: Rimshot</span>")
				src.mode = "rimshot"
			if("rimshot")
				boutput(user, "<span style=\"color:blue\">Mode is now: Trombone</span>")
				src.mode = "trombone"
			else
				boutput(user, "<span style=\"color:blue\">Mode is now: Honk</span>")
				src.mode = "honk"
			*/

		if (newmode && rand(1,150) == 1)
			boutput(user, "<span style=\"color:red\">BZZZ SOUND SYNTHESISER ERROR</span>")
			boutput(user, "<span style=\"color:blue\">Mode is now: ???</span>")
			src.mode = pick("un1","un2","un3")
		else if (newmode)
			boutput(user, "<span style=\"color:blue\">Mode is now: [newmode]</span>")
			src.mode = newmode
