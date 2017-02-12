/mob/living/carbon/human/death(gibbed)
	if(src.stat == 2)
		return
	if(src.healths)
		src.healths.icon_state = "health5"
	if(!buddha)
		src.stat = 2
	src.dizziness = 0
	src.jitteriness = 0

	if (!gibbed && !buddha)
		if(client)
			emote("deathgasp") //let the world KNOW WE ARE DEAD
			message_admins("\red Player [key_name_admin(src)]([src.real_name]) has died. Last attacker: [key_name_admin(lastattacker)].\black <BR>\red Brute:(\black[src.bruteloss]\red) Tox:(\black[src.toxloss]\red) Fire:(\black[src.fireloss]\red) Oxy:(\black[src.oxyloss]\red)")
			if(lastattacker && src != lastattacker)
				src << "\red <font size=4><b>You were just killed by [lastattacker]. If you think this was grief and you were killed for no reason, please adminhelp it by pressing F1.</b></font>"
		//For ninjas exploding when they die./N
		if (istype(wear_suit, /obj/item/clothing/suit/space/space_ninja)&&wear_suit:s_initialized)
			src << browse(null, "window=spideros")//Just in case.
			var/location = loc
			explosion(location, 1, 2, 3, 4)
		//src.flags = 0
		//reagents.handle_reactions() //No magic stomach for corpses.
		canmove = 0
		if(src.client)
			src.blind.layer = 0
		lying = 1
		var/h = src.hand
		hand = 0
		drop_item()
		hand = 1
		drop_item()
		hand = h
		if (istype(wear_suit, /obj/item/clothing/suit/armor/a_i_a_ptank))
			var/obj/item/clothing/suit/armor/a_i_a_ptank/A = wear_suit
			bombers += "[key] has detonated a suicide bomb. Temp = [A.part4.air_contents.temperature-T0C]."
	//		world << "Detected that [src.key] is wearing a bomb" debug stuff
			if(A.status && prob(90))
	//			world << "Bomb has ignited?"
				A.part4.ignite()

		if (client)
			spawn(10)
				if(client && src.stat == 2)
					verbs += /mob/proc/ghost
				else
					verbs -= /mob/proc/ghost

	var/tod = time2text(world.realtime,"hh:mm:ss") //weasellos time of death patch
	if(mind)
		mind.store_memory("Time of death: [tod]", 0)
//	sql_report_death(src)
	//src.icon_state = "dead"

	ticker.mode.check_win()

	/*
		if (ticker.mode.name == "Corporate Restructuring" && ticker.target != src)
			src.unlock_medal("Expendable", 1)

		//For restructuring
		if (ticker.mode.name == "Corporate Restructuring" || ticker.mode.name == "revolution")
			ticker.check_win()

		if (ticker.mode.name == "wizard" && src == ticker.killer)
			world << "<FONT size = 3><B>Research Station Victory</B></FONT>"
			world << "<B>The Wizard has been killed!</B> The wizards federation has been taught an important lesson."
			ticker.processing = 0
			sleep(100)
			world << "\blue Rebooting due to end of game"
			world.Reboot()
	*/ //TODO: FIX

	//Traitor's dead! Oh no!
	if (ticker.mode.name == "traitor" && src.mind && src.mind.special_role == "traitor")
		message_admins("\red Traitor [key_name_admin(src)] has died.")
		log_game("Traitor [key_name(src)] has died.")

	var/cancel
	for (var/mob/M in mobz)
		if (M.client && !M.stat)
			cancel = 1
			break

	if (!cancel && !abandon_allowed)
		spawn (50)
			cancel = 0
			for (var/mob/M in mobz)
				if (M.client && !M.stat)
					cancel = 1
					break

			if (!cancel && !abandon_allowed)
				world << "<B>Everyone is dead! Resetting in 30 seconds!</B>"

				spawn (300)
					log_game("Rebooting because of no live players")
					world.Reboot()

	return ..(gibbed)
