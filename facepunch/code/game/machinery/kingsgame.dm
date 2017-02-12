/obj/machinery/royalgame
	name = "Royal Gambit"
	desc = "Have six people swipe their IDs to the machine to play	!"
	anchored = 1
	icon = 'icons/obj/thegame.dmi'
	icon_state = "queensgame_idle"
	var/king = null
	var/chosen = null
	var/stage1 = 1
	var/stage2 = 0
	var/stage3 = 0
	var/canplay = 0
	var/enabled = 1 //It can spawn on the map; it just can't do anything until overridden by a varedit


//For the themes
	var/player1 = null
	var/player2 = null
	var/player3 = null
	var/player4 = null
	var/player5 = null
	var/player6 = null

//	if(chosen == king) //Stops the chosen person from being picked as their own.
//		choose()

	var/player1ch = 0 //So the first person can swipe
	var/player2ch = 1
	var/player3ch = 1
	var/player4ch = 1
	var/player5ch = 1
	var/player6ch = 1

/obj/machinery/royalgame/power_change()
	..()
	update_icon()

/obj/machinery/royalgame/update_icon()
	if(stage1)
		if(icon_state != "queensgame_pick")
			icon_state = "queensgame_pick"
		else
			if(icon_state == "queensgame_idle")
				icon_state = "queensgame_idle"

/obj/machinery/royalgame/attack_hand(mob/living/user as mob)
	if(enabled)
		var/dat = "<B>This rounds players are!</B><BR>"
		dat += "[player1] [player2] [player3] <BR>[player4] [player5] [player6]<BR>"
		if(canplay == 1 && stage1 == 1)
			dat += "<A href='byond://?src=\ref[src];op=queensgame'>Press to play!</A><BR>"

	//Fun fact; no one has numbers. It just randomly picks!
		if(stage2 && user.name == king)
			dat += "<A href='byond://?src=\ref[src];op=chooser'>Choose number 1!</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=chooser'>Choose number 2!</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=chooser'>Choose number 3!</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=chooser'>Choose number 4!</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=chooser'>Choose number 5!</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=chooser'>Choose number 6!</A><BR>"

	//Why reset everytime? Its so people can't spam play it. Also prevents the game from choosing multiple people!
		if(stage3)
			dat += "<A href='byond://?src=\ref[src];op=reset'>Reset and Reswipe IDs!</A><BR>"
		dat += "<p><br>What is the Royal Gambit? Its so simple! Grab five other friends and have them swipe their IDs on the device! Then have one person activate it! Watch the flashing colors and wait for it to choose the Royalty! Whoever is chosen must choose a number from the console (ensure your IDs registered name matches your current name!) and whoever is announced as that number has to do one thing the Queen tells them to do!<br> The only things that may not be done are murder, suicide, rape, or anything that breaks the Otherworldly Occut Conspiracy (OOC for short) rules. <br> "
		user << browse(dat, "window=scroll")
		onclose(user, "scroll")
		return



//////////////////////////////
//The main logic behind this//
//////////////////////////////




/obj/machinery/royalgame/Topic(href, href_list)
	if (usr.stat)
		return
	if ((in_range(src, usr) && istype(src.loc, /turf)) || (istype(usr, /mob/living/silicon)))
		usr.set_machine(src)

		switch(href_list["op"])

			if("queensgame")
				if(stage1 == 1)
					if(emagged == 1)
						src.visible_message("YOU'RE WINNER!")
						spawn(10)//Gives people enough time to run
							explosion(loc, 3, 1, 2, 3)
					else
						stage1 = 0
						icon_state = "queensgame_pick"
						spawn(200)
							switch(rand(1,11))		// The king is absolute!
								if(1 to 2 )
									king = player1
									icon_state = "queensgame_p1"
								if(3 to 4)
									king = player2
									icon_state = "queensgame_p2"
								if(5 to 5)
									king = player3
									icon_state = "queensgame_p3"
								if(6 to 7)
									king = player4
									icon_state = "queensgame_p4"
								if(8 to 9)
									king = player5
									icon_state = "queensgame_p5"
								if(10 to 11)
									king = player6
									icon_state = "queensgame_p6"
							spawn(1)
								icon_state = "queensgame_idle"
								src.visible_message("The royalty is; [king]. [king], please select a number on the console and input your command!")
								stage2 = 1
			if("chooser")
				choose()
				stage1 = 0 //To prevent other people from managing to break it
				stage2 = 0
				stage3 = 1
			if("reset")
				src.visible_message("Reseting. Please reswipe ID cards!")
				icon_state = "queensgame_idle"
				king = null
				chosen = null
				stage1 = 1
				stage2 = 0
				stage3 = 0
				canplay = 0
				player1 = null
				player2 = null
				player3 = null
				player4 = null
				player5 = null
				player6 = null
				player1ch = 0
				player2ch = 1
				player3ch = 1
				player4ch = 1
				player5ch = 1
				player6ch = 1
		attack_hand(usr)
		return


/////////////////////
//IF statement land//
/////////////////////
/obj/machinery/royalgame/attackby(obj/item/I as obj, mob/living/user as mob)
	if(enabled)
		if(istype(I,/obj/item/weapon/card/id))
			var/obj/item/weapon/card/id/ID = I
			if(player1ch == 0)
				user << "You sign into the game as [user.name]!"
				player1 = ID.registered_name
				player2ch = 0
				player1ch = 1
				return
			if(player2ch == 0)
				player2 = ID.registered_name
				if(player2 == player1)
					player2 = null
					user << "You have already signed into slot 1!"
					return
				else
					player3ch = 0
					player2ch = 1
					user << "You sign into the game as [user.name]!"
				return
			if(player3ch == 0)
				player3 = ID.registered_name
				if(player3 == player2)
					if(player3 == player1)
						user << "You have already signed into slot 1!"
						player3 = null
						return
					else
						user << "You have already signed into slot 2!"
						player3 = null
				 	return
				else
					player4ch = 0
					player3ch = 1
					user << "You sign into the game as [user.name]!"
				return
			if(player4ch == 0)
				player4 = ID.registered_name
				if(player4 == player2)
					if(player4 == player1)
						if(player4 == player3)
							user << "You have already signed into slot 3!"
							player4 = null
							return
						else
							user << "You have already signed into slot 2!"
							player4 = null
							return
					else
						user << "You have already signed into slot 1!"
						player3 = null
					return
				else
					player5ch = 0
					player4ch = 1
					user << "You sign into the game as [user.name]!"
					return
			if(player5ch == 0)
				player5 = ID.registered_name
				if(player5 == player2)
					if(player5 == player1)
						if(player5 == player3)
							if(player5 == player4)
								user << "You have already signed into slot 4!"
								player5 = null.
								return
							else
								user << "You have already signed into slot 3!"
								player5 = null
								return
						else
							user << "You have already signed into slot 1!"
							player5 = null
							return
					else
						user << "You have already signed into slot 2!"
						player5 = null
					return
				else
					player6ch = 0
					player5ch = 1
					user << "You sign into the game as [user.name]!"
					return
			if(player6ch == 0)
				player6 = ID.registered_name
				if(player6 == player2)
					if(player6 == player1)
						if(player6 == player3)
							if(player6 == player4)
								if(player6 == player5)
									user << "You have already signed into slot 5!"
									player6 = null.
									return
								else
									user << "You have already signed into slot 4!"
									player6 = null.
									return
							else
								user << "You have already signed into slot 3!"
								player6 = null
								return
						else
							user << "You have already signed into slot 1!"
							player6 = null
							return
					else
						user << "You have already signed into slot 2!"
						player6 = null
					return
				else
					user << "You sign into the game as [user.name]!"
					player6 = ID.registered_name
					player6ch = 1
					canplay = 1
					return

	if(istype(I,/obj/item/weapon/card/emag))
		emagged = 1


//Randomly chooses one person to be the person
/obj/machinery/royalgame/proc/choose()
	switch(rand(1,11))		// The king is absolute!
		if(1 to 2 )
			chosen = player1
			icon_state = "queensgame_p1"
			src.visible_message("Player one; [player1] has been chosen to do the Queens bidding!")
		if(3 to 4)
			chosen = player2
			icon_state = "queensgame_p2"
			src.visible_message("Player two; [player2] has been chosen to do the Queens bidding!")
		if(5 to 5)
			chosen = player3
			icon_state = "queensgame_p3"
			src.visible_message("Player three; [player3] has been chosen to do the Queens bidding!")
		if(6 to 7)
			chosen = player4
			icon_state = "queensgame_p4"
			src.visible_message("Player four; [player4] has been chosen to do the Queens bidding!")
		if(8 to 9)
			chosen = player5
			icon_state = "queensgame_p5"
			src.visible_message("Player five; [player5] has been chosen to do the Queens bidding!")
		if(10 to 11)
			chosen = player6
			icon_state = "queensgame_p6"
			src.visible_message("Player six; [player6] has been chosen to do the Queens bidding!")
	if(chosen == king) //Stops the chosen person from being picked as their own.
		choose()
