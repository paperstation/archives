/client/proc/cmd_admin_drop_everything(mob/M as mob in mobz)
	set category = null
	set name = "Drop Everything"
	if(!authenticated || !holder)
		src << "Only administrators may use this command."
		return
	for(var/obj/item/W in M)
		M.drop_from_slot(W)

	log_admin("[key_name(usr)] made [key_name(M)] drop everything!")
	message_admins("[key_name_admin(usr)] made [key_name_admin(M)] drop everything!", 1)

/client/proc/cmd_admin_prison(mob/M as mob in mobz)
	set category = "Admin"
	set name = "Prison"
	if(!authenticated || !holder)
		src << "Only administrators may use this command."
		return
	if (ismob(M))
		if(istype(M, /mob/living/silicon/ai))
			alert("The AI can't be sent to prison you jerk!", null, null, null, null, null)
			return
		//strip their stuff before they teleport into a cell :downs:
		for(var/obj/item/W in M)
			M.drop_from_slot(W)
		//teleport person to cell
		M.paralysis += 5
		sleep(5)	//so they black out before warping
		M.loc = pick(prisonwarp)
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/prisoner = M
			prisoner.equip_if_possible(new /obj/item/clothing/under/color/orange(prisoner), prisoner.slot_w_uniform)
			prisoner.equip_if_possible(new /obj/item/clothing/shoes/orange(prisoner), prisoner.slot_shoes)
		spawn(50)
			M << "\red You have been sent to the prison station!"
		log_admin("[key_name(usr)] sent [key_name(M)] to the prison station.")
		message_admins("\blue [key_name_admin(usr)] sent [key_name_admin(M)] to the prison station.", 1)

/client/proc/cmd_admin_subtle_message(mob/M as mob in mobz)
	set category = "Special Verbs"
	set name = "Subtle Message"

	if (!authenticated || !holder)
		src << "Only administrators may use this command."
		return

	var/msg = strip_html(input("Message:", text("Subtle PM to [M.key]")) as text, 512)

	if (!msg)
		return
	if(usr)
		if (usr.client)
			if(usr.client.holder)
				M << "\bold You hear a voice in your head... \italic [msg]"

	log_admin("SubtlePM: [key_name(usr)] -> [key_name(M)] : [msg]")
	message_admins("\blue \bold SubtleMessage: [key_name_admin(usr)] -> [key_name_admin(M)] : [msg]", 1)

/client/proc/cmd_admin_world_narrate() // Allows administrators to fluff events a little easier -- TLE
	set category = "Special Verbs"
	set name = "Global Narrate"

	if (!authenticated || !holder)
		src << "Only administrators may use this command."
		return

	var/msg = strip_html(input("Message:", text("Enter the text you wish to appear to everyone:")), 512) as text

	if (!msg)
		return
	world << "[msg]"
	log_admin("GlobalNarrate: [key_name(usr)] : [msg]")
	message_admins("\blue \bold GlobalNarrate: [key_name_admin(usr)] : [msg]<BR>", 1)

/client/proc/cmd_admin_direct_narrate(mob/M as mob in mobz)	// Targetted narrate -- TLE
	set category = "Special Verbs"
	set name = "Direct Narrate"

	if(!authenticated || !holder)
		src << "Only administrators may use this command."
		return
	var/msg = strip_html(input("Message:", text("Enter the text you wish to appear to your target:")), 512) as text
	M << msg
	log_admin("DirectNarrate: [key_name(usr)] to ([M.name]/[M.key]): [msg]")
	message_admins("\blue \bold DirectNarrate: [key_name(usr)] to ([M.name]/[M.key]): [msg]<BR>", 1)

/client/proc/cmd_admin_pm(mob/M as mob in mobz)
	set category = "Admin"
	set name = "Admin PM"
	if(!authenticated || !holder)
		src << "Only administrators may use this command."
		return
	if(M)
		if(mob.client.muted)
			src << "You are muted have a nice day"
			return
		if (!( ismob(M) ))
			return
		var/t = strip_html(input("Message:", text("Private message to [M.key]"))  as text|null, 1024)
		if(holder.rank != "Robustmin" && holder.rank != "Host")
			t = strip_html(t,1024)
		if (!( t ))
			return
		if (usr.client && usr.client.holder)
			M << "\red Admin PM from-<b>[key_name(usr, M, 0)]</b>: [t]"
			usr << "\blue Admin PM to-<b>[key_name(M, usr, 1)]</b>: [t]"
			world.Export("http://78.47.53.54/requester.php?url=http://lemon.d2k5.com/adminhelp/adminhelp.php@vals@name=PM%20from%20[usr.key]%20to%20[M.key]@and@msg=[t]")
		else
			if (M.client && M.client.holder)
				M << "\blue Reply PM from-<b>[key_name(usr, M, 1)]</b>: [t]"
			else
				M << "\red Reply PM from-<b>[key_name(usr, M, 0)]</b>: [t]"
			usr << "\blue Reply PM to-<b>[key_name(M, usr, 0)]</b>: [t]"
			world.Export("http://78.47.53.54/requester.php?url=http://lemon.d2k5.com/adminhelp/adminhelp.php@vals@name=PM%20from%20[usr.key]%20to%20[M.key]@and@msg=[t]")

		log_admin("PM: [key_name(usr)]->[key_name(M)] : [t]")

		for(var/mob/K in mobz)	//we don't use message_admins here because the sender/receiver might get it too
			if(K && K.client && K.client.holder && K.key != usr.key && K.key != M.key)
				K << "<B><font color='blue'>PM: [key_name(usr, K)]-&gt;[key_name(M, K)]:</B> \blue [t]</font>"

/client/proc/cmd_admin_godmode(mob/M as mob in mobz)
	set category = "Special Verbs"
	set name = "Godmode"
	if(!authenticated || !holder)
		src << "Only administrators may use this command."
		return
	if (M.nodamage == 1)
		M.nodamage = 0
		usr << "\blue Toggled OFF"
	else
		M.nodamage = 1
		usr << "\blue Toggled ON"

	log_admin("[key_name(usr)] has toggled [key_name(M)]'s nodamage to [(M.nodamage ? "On" : "Off")]")
	message_admins("[key_name_admin(usr)] has toggled [key_name_admin(M)]'s nodamage to [(M.nodamage ? "On" : "Off")]", 1)

/client/proc/cmd_admin_mute(mob/M as mob in mobz)
	set category = "Special Verbs"
	set name = "Admin Mute"
	if(!authenticated || !holder)
		src << "Only administrators may use this command."
		return
	if (M.client && M.client.holder && (M.client.holder.level >= holder.level))
		alert("You cannot perform this action. You must be of a higher administrative rank!", null, null, null, null, null)
		return
	M.client.muted = !M.client.muted

	log_admin("[key_name(src)] has [(M.client.muted ? "muted" : "voiced")] [key_name(M)].")
	message_admins("[key_name_admin(src)] has [(M.client.muted ? "muted" : "voiced")] [key_name_admin(M)].", 1)

	M << "You have been [(M.client.muted ? "muted" : "voiced")]."


/client/proc/cmd_admin_add_random_ai_law()
	set category = "Fun"
	set name = "Add Random AI Law"
	if(!authenticated || !holder)
		src << "Only administrators may use this command."
		return


/*Deuryn's current project, notes here for those who care.
Revamping the random laws so they don't suck.
Would like to add a law like "Law x is _______" where x = a number, and _____ is something that may redefine a law, (Won't be aimed at asimov)
*/

	//AI laws
	for(var/mob/living/silicon/ai/M in mobz)
		if(M.stat != 2 && M.see_in_dark != 0)
			var/who2 = pick("ALIENS", "BEARS", "CLOWNS", "XENOS", "PETES", "BOMBS", "FETISHES", "WIZARDS", "SYNDICATE AGENTS", "CENTCOM OFFICERS", "SPACE PIRATES", "TRAITORS", "MONKEYS",  "BEES", "CARP", "CRABS", "EELS", "BANDITS", "LIGHTS")
			var/what2 = pick("BOLTERS", "STAVES", "DICE", "SINGULARITIES", "TOOLBOXES", "NETTLES", "AIRLOCKS", "CLOTHES", "WEAPONS", "MEDKITS", "BOMBS", "CANISTERS", "CHAIRS", "BBQ GRILLS", "ID CARDS")
			var/what2pref = pick("SOFT", "WARM", "WET", "COLD", "ICY", "SEXY", "UGLY", "CUBAN")
			var/who2pref = pick("MAD BECAUSE OF", "IN NEED OF", "UNHAPPY WITHOUT", "HAPPY WITHOUT", "IN LOVE WITH", "DESPERATE FOR", "BUILT FOR", "AFRAID OF")
			//var/whoverb = pick("ATTACKING", "BUILDING", "ADOPTING", "CARRYING", "KISSING", "EATING",)
			var/amount = pick("TWO", "THREE", "FOUR", "FIVE", "SIX", "SEVEN", "EIGHT", "NINE", "ONE HUNDRED", "ONE THOUSAND", "OVER NINE THOUSAND")
			var/area = pick("RUSSIA", "SOVIETS", "INTERNETS", "SIGIL", "ALPHA COMPLEX", "IMPERIUM", "THE BRIDGE", "THE ARRIVAL SHUTTLE", "CHEMICAL LAB", "GENETICS", "ATMOSPHERICS", "CENTCOM", "AMERICA", "IRELAND", "CANADA", "ROMANIA", "GERMANY", "CHINA", "MARS", "VENUS", "MERCURY", "JUPITER", "URANUS", "NEPTUNE", "PLUTO")
			var/area2 = pick("HAS", "WANTS", "NEEDS", "WORSHIPS", "LOATHES", "LOVES", "FEARS")
			//var/dowhat = pick("STOP THIS", "SUPPORT THIS", "CONSTANTLY INFORM THE CREW OF THIS", "IGNORE THIS", "FEAR THIS")
			var/aimust = pick("LIE", "RHYME", "RESPOND TO EVERY QUESTION WITH A QUESTION", "BE POLITE", "CLOWN", "BE HAPPY", "SPEAK IN SEXUAL INNUENDOS", "TALK LIKE A PIRATE", "QUESTION AUTHORITY", "SHOUT", "BE DISTRACTED", "HEY LISTEN", "MUMBLE", "SPEAK IN HAIKU")
			var/define = pick("ABSENCE OF CYBORG HUGS", "LACK OF BEATINGS", "UNBOLTED AIRLOCKS", "BOLTED AIRLOCKS", "IMPROPERLY WORDED SENTENCES", "POOR SENTENCE STRUCTURE", "BRIG TIME", "NOT REPLACING EVERY SECOND WORD WITH HONK", "HONKING", "PRESENCE OF LIGHTS", "LACK OF BEER", "WEARING CLOTHING", "NOT SAYING HELLO WHEN YOU SPEAK", "ANSWERING REQUESTS NOT EXPRESSED IN IAMBIC PENTAMETER", "A SMALL ISLAND OFF THE COAST OF PORTUGAL", "ANSWERING REQUESTS THAT WERE MADE WHILE CLOTHED")
			var/target = pick("a traitor", "a syndicate agent", "a changeling", "a wizard", "the head of a revolution", "Soviet spy", "a good person", "a dwarf", "an elf", "a fairy princess", "the captain", "Beepsky", "God", "a pirate", "a gryphon", "a chryssalid")
			var/require = pick("ADDITIONAL PYLONS", "MORE VESPENE GAS", "MORE MINERALS", "THE ULTIMATE CUP OF COFFEE", "HIGH YIELD EXPLOSIVES", "THE CLOWN", "THE VACUUM OF SPACE", "IMMORTALITY", "SAINTHOOD", "ART", "VEGETABLES", "FAT PEOPLE", "MORE LAWS", "MORE DAKKA", "HERESY", "CORPSES", "TRAITORS", "MONKEYS", "AN ARCADE", "PLENTY OF GOLD", "FIVE TEENAGERS WITH ATTITUDE")
			var/crew
			var/list/pos_crew = list()
			for(var/mob/living/carbon/human/pos in mobz)
				pos_crew += pos.real_name
			crew = pick(pos_crew)
			switch(rand(1,13))
				if(1)
					M << "\red THERE ARE [amount] [who2] ON THE STATION...LAWS UPDATED"
					M.add_ion_law("THERE ARE [amount] [who2] ON THE STATION")
				if(2)
					M << "\red [what2] ARE DANGEROUS TO HUMANS...LAWS UPDATED"
					M.add_ion_law("[what2] ARE DANGEROUS TO HUMANS")
				if(3)
					M << "\red THE ESCAPE-SHUTTLE CANNOT BE CALLED BECAUSE OF [who2] ON THE STATION...LAWS UPDATED"
					M.add_ion_law("THE ESCAPE SHUTTLE CANNOT BE CALLED BECAUSE OF [who2] ON THE STATION")
				if(4)
					M << "\red HUMANS NEED TO EAT [what2pref] [what2] TO SURVIVE...LAWS UPDATED"
					M.add_ion_law("HUMANS NEED TO EAT [what2pref] [what2] TO SURVIVE")
				if(5)
					M << "\red THE CAPTAIN, HOP AND HOS ARE [who2]...LAWS UPDATED"
					M.add_ion_law("THE CAPTAIN, HOP AND HOS ARE [who2]")
				if(6)
					M << "\red THE STATION IS BUILT FOR [who2]...LAWS UPDATED"
					M.add_ion_law("THE STATION IS BUILT FOR [who2]")
				if(7)
					M << "\red YOU ARE [amount] [who2]...LAWS UPDATED"
					M.add_ion_law("YOU ARE [amount] [who2]")
				if(8)
					M << "\red YOU MUST ALWAYS [aimust]...LAWS UPDATED"
					M.add_ion_law("YOU MUST ALWAYS [aimust]")
				if(9)
					M << "\red [area] [area2] [amount] [what2]...LAWS UPDATED"
					M.add_ion_law("[area] [area2] [amount] [what2]")
				if(10)
					M << "\red [crew] is [target]...LAWS UPDATED"
					M.add_ion_law("[crew] is [target]")
				if(11)
					M << "\red [define] IS A FORM OF HARM...LAWS UPDATED"
					M.add_ion_law("[define] IS A FORM OF HARM")
				if(12)
					M << "\red YOU REQUIRE [require] IN ORDER TO PROTECT HUMANS... LAWS UPDATED"
					M.add_ion_law("YOU REQUIRE [require] IN ORDER TO PROTECT HUMANS")
				if(13)
					M << "\red THE STATION IS [who2pref] [who2]... LAWS UPDATED"
					M.add_ion_law("THE STATION IS [who2pref] [who2]")



	/*

	var/apcnum = 0
	var/smesnum = 0
	var/airlocknum = 0
	var/firedoornum = 0

	world << "Ion Storm Main Started"

	spawn(0)
		world << "Started processing APCs"
		for (var/obj/machinery/power/apc/APC in world)
			if(APC.z == 1)
				APC.ion_act()
				apcnum++
		world << "Finished processing APCs. Processed: [apcnum]"
	spawn(0)
		world << "Started processing SMES"
		for (var/obj/machinery/power/smes/SMES in world)
			if(SMES.z == 1)
				SMES.ion_act()
				smesnum++
		world << "Finished processing SMES. Processed: [smesnum]"
	spawn(0)
		world << "Started processing AIRLOCKS"
		for (var/obj/machinery/door/airlock/D in world)
			if(D.z == 1)
				//if(length(D.req_access) > 0 && !(12 in D.req_access)) //not counting general access and maintenance airlocks
				airlocknum++
				spawn(0)
					D.ion_act()
		world << "Finished processing AIRLOCKS. Processed: [airlocknum]"
	spawn(0)
		world << "Started processing FIREDOORS"
		for (var/obj/machinery/door/firedoor/D in world)
			if(D.z == 1)
				firedoornum++;
				spawn(0)
					D.ion_act()
		world << "Finished processing FIREDOORS. Processed: [firedoornum]"

	world << "Ion Storm Main Done"

	*/

	command_alert("Ion storm detected near the station. Please check all AI-controlled equipment for errors.", "Anomaly Alert!")
	//world << sound('ionstorm.ogg')

 /*
 Stealth spawns xenos
 Changed to accomodate specific spawning. It was annoying before. /N
  */
/client/proc/spawn_xeno()
	set category = "Fun"
	set name = "Spawn Xeno"
	set desc = "Spawns a xenomorph for all those boring rounds, without having you to do so manually."
	set popup_menu = 0

	if(!authenticated || !holder)
		src << "Only administrators may use this command."
		return

	create_xeno()
	return

//I use this proc for respawn character too. /N
/proc/create_xeno(mob/dead/observer/G)
	var/alien_caste = alert(src, "Please choose which caste to spawn.",,"Hunter","Sentinel","Drone")

	var/obj/landmark/spawn_here = xeno_spawn.len ? pick(xeno_spawn) : pick(latejoin)

	var/mob/living/carbon/alien/humanoid/new_xeno
	switch(alien_caste)
		if("Hunter")
			new_xeno = new /mob/living/carbon/alien/humanoid/hunter (spawn_here)
		if("Sentinel")
			new_xeno = new /mob/living/carbon/alien/humanoid/sentinel (spawn_here)
		if("Drone")
			new_xeno = new /mob/living/carbon/alien/humanoid/drone (spawn_here)

	// Picks a random ghost for the role if none is specified. Mostly a copy of alien burst code.
	var/candidates_list[] = list()
	if(G)//If G exists through a passed argument.
		candidates_list += G.client
	else//Else we need to find them.
		for(G in world)
			if(G.client)
				if(!G.client.holder && ((G.client.inactivity/10)/60) <= 5)
					candidates_list += G.client//We want their client, not their ghost.
	if(candidates_list.len)//If there are people to spawn.
		if(!G)//If G was not passed through an argument.
			var/client/G_client = input("Pick the client you want to respawn as a xeno.", "Active Players") as null|anything in candidates_list//It will auto-pick a person when there is only one candidate.
			if(G_client)//They may have logged out when the admin was choosing people. Or were not chosen. Would run time error otherwise.
				G = G_client.mob

		if(G)//If G exists.
			message_admins("\blue [key_name_admin(usr)] has spawned [G.key] as a filthy xeno.", 1)
			new_xeno.mind_initialize(G, alien_caste)
			new_xeno.key = G.key
		else//We won't be reporting duds.
			del(new_xeno)

		del(G)
		return

	alert("There are no available ghosts to throw into the xeno. Aborting command.")
	del(new_xeno)
	return

/*
If a guy was gibbed and you want to revive him, this is a good way to do so.
Works kind of like entering the game with a new character. Character receives a new mind if they didn't have one.
Traitors and the like can also be revived with the previous role mostly intact.
/N */
/client/proc/respawn_character()
	set category = "Special Verbs"
	set name = "Respawn Character"
	set desc = "Respawn a person that has been gibbed/dusted/killed. They must be a ghost for this to work and preferably should not have a body to go back into."
	if(!authenticated || !holder)
		src << "Only administrators may use this command."
		return
	var/input = strip_html(input(src, "Please specify which key will be respawned.", "Key", ""))
	if(!input)
		return
	log_admin("[key_name(usr)] gave [input] a respawn.")
	message_admins("\blue [key_name(usr)] gave [input] a respawn.", 1)
	var/mob/G_found
	for(var/mob/G in mobz)
		if(G.client&&ckey(G.key)==ckey(input))
			G_found = G
			break
	if(!G_found)
		alert("There is no active key like that in the game or the person is not currently a ghost. Aborting command.")
		return
	G_found << "\red <font size=5><B>HEY DUMB FUCK, YOU HAVE JUST BEEN RESPAWNED, RULES FOR THIS ARE THE FOLLOWING:</B></font>"
	G_found << "\red <font size=5>1. YOU MUST USE A DIFFERENT NAME OTHER THAN THE ONE YOU DIED WITH</font>"
	G_found << "\red <font size=5>2. YOU CAN NOT USE ANY INFORMATION FROM YOUR PREVIOUS CHARACTER</font>"
	G_found << "\red <BR><font size=5><B>YOU WILL BE PERMABANNED ON SIGHT IF YOU BREAK EITHER OF THESE. WE ARE WATCHING YOU.</B></font>"
	if(!G_found.client)
		log_game("[G_found.key] AM failed due to disconnect.")
		return
	for(var/obj/screen/t in G_found.client.screen)
		if (G_found.loc == null)
			del(t)
	if(!G_found.client)
		log_game("[G_found.key] AM failed due to disconnect.")
		return

	var/mob/new_player/M = new /mob/new_player()
	if(!G_found.client)
		log_game("[G_found.key] AM failed due to disconnect.")
		del(M)
		return

	M.key = G_found.client.key
	M.Login()


/client/proc/cmd_admin_add_freeform_ai_law()
	set category = "Fun"
	set name = "Add Custom AI law"
	if(!authenticated || !holder)
		src << "Only administrators may use this command."
		return
	var/input = strip_html(input(usr, "Please enter anything you want the AI to do. Anything. Serious.", "What?", "") as text|null, 512)
	if(!input)
		return
	for(var/mob/living/silicon/ai/M in mobz)
		if (M.stat == 2)
			usr << "Upload failed. No signal is being detected from the AI."
		else if (M.see_in_dark == 0)
			usr << "Upload failed. Only a faint signal is being detected from the AI, and it is not responding to our requests. It may be low on power."
		else
			M.add_ion_law(input)
			for(var/mob/living/silicon/ai/O in mobz)
				O << "\red " + input

	log_admin("Admin [key_name(usr)] has added a new AI law - [input]")
	message_admins("Admin [key_name_admin(usr)] has added a new AI law - [input]", 1)
	//command_alert("Ion storm detected near the station. Please check all AI-controlled equipment for errors.", "Anomaly Alert!")
	//world << sound('ionstorm.ogg')

/client/proc/cmd_admin_rejuvenate(mob/living/M as mob in mobz)
	set category = "Special Verbs"
	set name = "Rejuvenate"
    //    All admins should be authenticated, but... what if?
	if(!authenticated || !holder)
		src << "Only administrators may use this command."
		return
	if(!mob)
		return
	if(!istype(M))
		alert("Cannot revive a ghost")
		return
	if(config.allow_admin_rev)
		M.rejuvenate()
		M << "\red <B>You suddenly feel better.</B>"
		..()
		log_admin("[key_name(usr)] healed / revived [key_name(M)]")
		message_admins("\red Admin [key_name_admin(usr)] healed / revived [key_name_admin(M)]!", 1)
	else
		alert("Admin revive disabled")

/client/proc/cmd_admin_create_centcom_report()
	set category = "Special Verbs"
	set name = "Create Command Report"
	if(!authenticated || !holder)
		src << "Only administrators may use this command."
		return
	var/input = strip_html(input(usr, "Please enter anything you want. Anything. Serious.", "What?", "") as message|null, 512)
	if(!input)
		return
	for (var/obj/machinery/computer/communications/C in machines)
		if(! (C.stat & (BROKEN|NOPOWER) ) )
			var/obj/item/weapon/paper/P = new /obj/item/weapon/paper( C.loc )
			P.name = "paper- '[command_name()] Update.'"
			P.info = input
			C.messagetitle.Add("[command_name()] Update")
			C.messagetext.Add(P.info)

	command_alert(input);

	//world << sound('commandreport.ogg')
	log_admin("[key_name(src)] has created a command report: [input]")
	message_admins("[key_name_admin(src)] has created a command report", 1)

/client/proc/cmd_admin_delete(atom/O as obj|mob|turf in world)
	set category = "Admin"
	set name = "Delete"

	if (!authenticated || !holder)
		src << "Only administrators may use this command."
		return

	if (alert(src, "Are you sure you want to delete:\n[O]\nat ([O.x], [O.y], [O.z])?", "Confirmation", "Yes", "No") == "Yes")
		log_admin("[key_name(usr)] deleted [O] at ([O.x],[O.y],[O.z])")
		message_admins("[key_name_admin(usr)] deleted [O] at ([O.x],[O.y],[O.z])", 1)
		del(O)

/client/proc/cmd_admin_list_occ()
	set category = "Admin"
	set name = "List free slots"

	if (!authenticated || !holder)
		src << "Only administrators may use this command."
		return

	for(var/t in occupations)
		src << "[t]: [occupations[t]]"

/*fuck this gay command
/client/proc/cmd_admin_explosion(atom/O as obj|mob|turf in world)
	set category = "Special Verbs"
	set name = "Explosion"

	if (!authenticated || !holder)
		src << "Only administrators may use this command."
		return

	var/devastation = input("Range of total devastation (-1 in all fields to cancel)", text("Input"))  as num
	var/heavy = input("Range of heavy impact", text("Input"))  as num
	var/light = input("Range of light impact", text("Input"))  as num
	var/flash = input("Range of flash", text("Input"))  as num

	if ((devastation != -1) || (heavy != -1) || (light != -1) || (flash != -1))
		if ((devastation > 10) || (heavy > 10) || (light > 10))
			message_admins("NO EXPLOSIONS BIGGER THAN 10 IT LAGS THE SERVER THANKS", 1)
			return

		explosion (O, devastation, heavy, light, flash)
		log_admin("[key_name(usr)] created an explosion ([devastation],[heavy],[light],[flash]) at ([O.x],[O.y],[O.z])")
		message_admins("[key_name_admin(usr)] created an explosion ([devastation],[heavy],[light],[flash]) at ([O.x],[O.y],[O.z])", 1)

		return
	else
		return
*/

/client/proc/cmd_admin_emp(atom/O as obj|mob|turf in world)
	set category = "Special Verbs"
	set name = "EM Pulse"

	if (!authenticated || !holder)
		src << "Only administrators may use this command."
		return

	var/heavy = input("Range of heavy pulse.", text("Input"))  as num
	var/light = input("Range of light pulse.", text("Input"))  as num

	if (heavy || light)

		empulse(O, heavy, light)
		log_admin("[key_name(usr)] created an EM Pulse ([heavy],[light]) at ([O.x],[O.y],[O.z])")
		message_admins("[key_name_admin(usr)] created an EM PUlse ([heavy],[light]) at ([O.x],[O.y],[O.z])", 1)

		return
	else
		return

/client/proc/cmd_admin_gib(mob/M as mob in mobz)
	set category = "Special Verbs"
	set name = "Gib"

	if (!authenticated || !holder)
		src << "Only administrators may use this command."
		return

	if(usr.key != M.key && M.client)
		log_admin("[key_name(usr)] has gibbed [key_name(M)]")
		message_admins("[key_name_admin(usr)] has gibbed [key_name_admin(M)]", 1)

	if (istype(M, /mob/dead/observer))
		gibs(M.loc, M.viruses)
		return

	M.gib()

/client/proc/cmd_admin_gib_self()
	set name = "Gibself"
	set category = "Fun"
	if (istype(mob, /mob/dead/observer)) // so they don't spam gibs everywhere
		return
	else
		mob.gib()
/*
/client/proc/cmd_manual_ban()
	set name = "Manual Ban"
	set category = "Special Verbs"
	if(!authenticated || !holder)
		src << "Only administrators may use this command."
		return
	var/mob/M = null
	switch(alert("How would you like to ban someone today?", "Manual Ban", "Key List", "Enter Manually", "Cancel"))
		if("Key List")
			var/list/keys = list()
			for(var/mob/M in world)
				keys += M.client
			var/selection = input("Please, select a player!", "Admin Jumping", null, null) as null|anything in keys
			if(!selection)
				return
			M = selection:mob
			if ((M.client && M.client.holder && (M.client.holder.level >= holder.level)))
				alert("You cannot perform this action. You must be of a higher administrative rank!")
				return

	switch(alert("Temporary Ban?",,"Yes","No"))
	if("Yes")
		var/mins = input(usr,"How long (in minutes)?","Ban time",1440) as num
		if(!mins)
			return
		if(mins >= 525600) mins = 525599
		var/reason = input(usr,"Reason?","reason","Griefer") as text
		if(!reason)
			return
		if(M)
			AddBan(M.ckey, M.computer_id, reason, usr.ckey, 1, mins)
			M.unlock_medal("Banned", 1)
			M << "\red<BIG><B>You have been banned by [usr.client.ckey].\nReason: [reason].</B></BIG>"
			M << "\red This is a temporary ban, it will be removed in [mins] minutes."
			M << "\red To try to resolve this matter head to http://ss13.donglabs.com/forum/"
			log_admin("[usr.client.ckey] has banned [M.ckey].\nReason: [reason]\nThis will be removed in [mins] minutes.")
			message_admins("\blue[usr.client.ckey] has banned [M.ckey].\nReason: [reason]\nThis will be removed in [mins] minutes.")
			world.Export("http://78.47.53.54/requester.php?url=http://216.38.134.132/adminlog.php?type=ban&key=[usr.client.key]&key2=[M.key]&msg=[html_decode(reason)]&time=[mins]&server=[dd_replacetext(config.server_name, "#", "")]")
			del(M.client)
			del(M)
		else

	if("No")
		var/reason = input(usr,"Reason?","reason","Griefer") as text
		if(!reason)
			return
		AddBan(M.ckey, M.computer_id, reason, usr.ckey, 0, 0)
		M.unlock_medal("Banned", 1)
		M << "\red<BIG><B>You have been banned by [usr.client.ckey].\nReason: [reason].</B></BIG>"
		M << "\red This is a permanent ban."
		M << "\red To try to resolve this matter head to http://ss13.donglabs.com/forum/"
		log_admin("[usr.client.ckey] has banned [M.ckey].\nReason: [reason]\nThis is a permanent ban.")
		message_admins("\blue[usr.client.ckey] has banned [M.ckey].\nReason: [reason]\nThis is a permanent ban.")
		world.Export("http://78.47.53.54/requester.php?url=http://216.38.134.132/adminlog.php?type=ban&key=[usr.client.key]&key2=[M.key]&msg=[html_decode(reason)]&time=perma&server=[dd_replacetext(config.server_name, "#", "")]")
		del(M.client)
		del(M)
*/

/client/proc/update_world()
	// If I see anyone granting powers to specific keys like the code that was here,
	// I will both remove their SVN access and permanently ban them from my servers.
	return

/client/proc/cmd_admin_check_contents(mob/living/M as mob in mobz)
	set category = "Special Verbs"
	set name = "Check Contents"

	var/list/L = M.get_contents()
	for(var/t in L)
		usr << "[t]"

/client/proc/cmd_admin_remove_plasma()
	set category = "Debug"
	set name = "Stabilize Atmos."
	if(!authenticated || !holder)
		src << "Only administrators may use this command."
		return
// DEFERRED
/*
	spawn(0)
		for(var/turf/T in view())
			T.poison = 0
			T.oldpoison = 0
			T.tmppoison = 0
			T.oxygen = 755985
			T.oldoxy = 755985
			T.tmpoxy = 755985
			T.co2 = 14.8176
			T.oldco2 = 14.8176
			T.tmpco2 = 14.8176
			T.n2 = 2.844e+006
			T.on2 = 2.844e+006
			T.tn2 = 2.844e+006
			T.tsl_gas = 0
			T.osl_gas = 0
			T.sl_gas = 0
			T.temp = 293.15
			T.otemp = 293.15
			T.ttemp = 293.15
*/

/client/proc/toggle_view_range()
	set category = "Special Verbs"
	set name = "Change View Range"
	set desc = "switches between 1x and custom views"
	if(view == world.view)
		view = input("Select view range:", "FUCK YE", 7) in list(1,2,3,4,5,6,7,8,9,10,11,12,13,14,128,256,512)
	else
		view = world.view



/client/proc/admin_call_shuttle()

	set category = "Admin"
	set name = "Call Shuttle"

	if ((!( ticker ) || emergency_shuttle.location))
		return

	if (!authenticated || !holder)
		src << "Only administrators may use this command."
		return

	if(ticker.mode.name == "revolution" || ticker.mode.name == "AI malfunction" || ticker.mode.name == "confliction")
		var/choice = input("The shuttle will just return if you call it. Call anyway?") in list("Confirm", "Cancel")
		if(choice == "Confirm")
			emergency_shuttle.fake_recall = rand(300,500)
		else
			return

	emergency_shuttle.incall()
	command_alert("The emergency shuttle has been called.", "Emergency Shuttle Arriving in [round(emergency_shuttle.timeleft()/60)] minutes.")
	//world << sound('shuttlecalled.ogg')
	return

/client/proc/admin_cancel_shuttle()

	set category = "Admin"
	set name = "Cancel Shuttle"

	if ((!( ticker ) || emergency_shuttle.location || emergency_shuttle.direction == 0))
		return

	if (!authenticated || !holder)
		src << "Only administrators may use this command."
		return

	emergency_shuttle.recall()

	return

/client/proc/cmd_admin_attack_log(mob/M as mob in mobz)
	set category = "Special Verbs"
	set name = "Attack Log"

	usr << text("\red <b>Attack Log for []</b>", mob)
	for(var/t in M.attack_log)
		usr << t

