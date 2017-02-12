/client/proc/animate_something()
	set category = "Debug"
	set name = "Spin an Atom"
	if(!check_rights(R_DEBUG))
		usr << "<span class='danger'><font size='30'>FUCK YOU</font></span>"
		playsound(src,'sound/misc/no.ogg',800,1)
		return

	var/chosen
	chosen = input("spin something", "meatspin") as anything in world
	if(!chosen)
		return

	var/speednumb = input(src, "how fast to loop? higher numbers = FASTA", "SUPRA SANIC SEED") as num
	var/loopnumb = input(src, "how long to loop for? -1 for infinity", "touch badmin get dizzy") as num

	//start spin
	src << "begin spin"
	chosen.SpinAnimation(speednumb, loopnumb) //speed, duration
	src << "the spin has begun"


	log_admin("[key_name(usr)] made [chosen] at [chosen.x], [chosen.y], [chosen.z] spin for [speednumb],[loopnumb]")
	message_admins("<span class='adminnotice'>[key_name_admin(usr)] made [chosen] at [chosen.x], [chosen.y], [chosen.z] spin for [speednumb],[loopnumb]!!!</span>", 1)



/client/proc/animate_goddamn_everything()
	set category = "Debug"
	set name = "Spin any Atom"
	if(!check_rights(R_DEBUG))
		usr << "<span class='danger'><font size='30'>FUCK YOU</font></span>"
		playsound(src,'sound/misc/no.ogg',800,1)
		return

	var/start = null
	var/spinning_thing = null
	start = input(src, "what are we gonna spin today", "YOU SPIN ME RIGHT ROUND") in list("objects", "mobs", "turfs", "everything")
	if(start == "objects")
		var/confirm = null
		confirm = input(src, "are you fucking sure you want to spin all objects", "SPIN GODDAMN EVERYTHING") in list("yeah", "nope")
		if(confirm == "nope")
			return
		else
			for(var/obj/O in world)
				spinning_thing = O
	if(start == "mobs")
		var/confirm = null
		confirm = input(src, "are you fucking sure you want to spin every mob", "SPIN GODDAMN EVERYTHING") in list("yeah", "nope")
		if(confirm == "nope")
			return
		else
			for(var/mob/M in world)
				spinning_thing = M
	if(start == "turfs")
		var/confirm = null
		confirm = input(src, "are you fucking sure you want to spin all the turfs", "SPIN GODDAMN EVERYTHING") in list("yeah", "nope")
		if(confirm == "nope")
			return
		else
			for(var/turf/T in world)
				spinning_thing = T
	if(start == "everything")
		var/confirm = null
		confirm = input(src, "are you fucking sure you want to spin everything", "SPIN GODDAMN EVERYTHING") in list("yeah", "nope")
		if(confirm == "nope")
			return
		else
			for(var/atom/A in world)
				spinning_thing = A

	var/speednumb = input(src, "how fast to loop? higher numbers = FASTA", "SUPRA SANIC SEED") as num
	var/loopnumb = input(src, "how long to loop for? -1 for infinity", "touch badmin get dizzy") as num

	//start spin
	src << "begin spin"
	spinning_thing.SpinAnimation(speednumb, loopnumb) //speed, duration
	src << "the spin has begun"

	//time to log some shit
	if(start == "objects")
		log_admin("[key_name(usr)] made all objects spin for [speednumb],[loopnumb]! ! ! ! !")
		message_admins("<span class='adminnotice'>[key_name_admin(usr)] made all objects spin for [speednumb],[loopnumb]! ! ! ! !</span>", 1)
		for(var/client/C in admins)
			playsound(C,'sound/misc/woah.ogg',90,1)
		return
	if(start == "mobs")
		log_admin("[key_name(usr)] made all mobs spin for [speednumb],[loopnumb]! ! ! ! !")
		message_admins("<span class='adminnotice'>[key_name_admin(usr)] made all mobs spin for [speednumb],[loopnumb]! ! ! ! !</span>", 1)
		for(var/client/C in admins)
			playsound(C,'sound/misc/woah.ogg',90,1)
		return
	if(start == "turfs")
		log_admin("[key_name(usr)] made all turfs spin for [speednumb],[loopnumb]! ! ! ! !")
		message_admins("<span class='adminnotice'>[key_name_admin(usr)] made all turfs spin for [speednumb],[loopnumb]! ! ! ! !</span>", 1)
		for(var/client/C in admins)
			playsound(C,'sound/misc/woah.ogg',90,1)
		return
	if(start == "everything")
		log_admin("[key_name(usr)] made all atoms spin for [speednumb],[loopnumb]! ! ! ! !")
		message_admins("<span class='adminnotice'>[key_name_admin(usr)] made all atoms spin for [speednumb],[loopnumb]! ! ! ! !</span>", 1)
		for(var/client/C in admins)
			playsound(C,'sound/misc/woah.ogg',90,1)
		return
