//This is a complete remake of Blackjack to make it player V player.


/obj/machinery/blackjack
	name = "21 Toolboxes (Blackjack)"
	desc = "From the hit game 20 floortiles."
	icon = 'icons/obj/computer.dmi'
	icon_state = "blackjack"
	use_power = USE_POWER_ACTIVE
	anchored = 1
	density = 1
	idle_power_usage = 5
	active_power_usage = 10
	var/enabled = 1 //Just cause
	var/streak = 0 //Keeps track of the current players winning streak
	var/highstreak = 0 //Blinds are off on this one
	var/highplayer = null //See botany for details
	var/tempstreak = 0
	var/playing = 0 //Main menu or not to mainmenu, that is the question
	var/ID = 0

////////////////////////
///Playing Variables///
///////////////////////
	var/cardvalue1 = 0
	var/cardvalue2 = 0
	var/cardvalue3 = 0
	var/cardvalue4 = 0
	var/cardvalue5 = 0
	var/cardvalue6 = 0
	var/card = 0
	var/card3 = 0
	var/card4 = 0
	var/card5 = 0
	var/total = 0
	var/canhit = 0 //*GASP*YOUR CHEATING!
	var/start = 1
	var/hitcard3 = 0
	var/hitcard4 = 0
	var/hitcard5 = 0
	var/dealer = 0
	var/stand = 0
	var/prize = 30
	var/grandprize = 50//Because this game can't be any easier yo
	var/canplay = 0
	var/chose = 0 //So it doesn't get locked up
	var/points = 0//How many coins were inserted
	var/vip = 0//So we can increase the VIP dealer
	var/busted
	var/done //Lets the machine nearby know if the player is done.
	var/lock = 0
/obj/machinery/blackjack/attack_hand(mob/living/user as mob)
	if(enabled)
		var/dat = "<B>21 Toolboxes!</B><BR>"
		if(start == 1)
			dat += "21 Toolboxes is a sub-division of CentComm enterprises and is not responsible for any death, virus, hulk, changeling, traitor, nuclear operative, ailment, corgi, faggot george melons or any other things that happen to you while playing."
			dat += "<br>"
			dat += "<br><br>"
			dat += "<A href='byond://?src=\ref[src];op=play'>Play!</A><BR>"
			dat += "<br>"
			dat += "The current play streak is: [tempstreak]/[prize]<br>The current win streak is: [streak]/[grandprize]"
			dat += "<br>"
			if(streak >= grandprize)
				dat += "<A href='byond://?src=\ref[src];op=grandprize'>CLAIM BELT!</A><BR>"
			if(tempstreak >= prize)
				dat += "<A href='byond://?src=\ref[src];op=prize'>CLAIM PRIZE!</A><BR>"
		if(card == 1)
			dat += "<br>"
			dat += "Your first card is: [cardvalue1]"
			dat += "<br>"
			dat += "Your second card is: [cardvalue2]"
			dat += "<br>"
			dat += "Your card total is: [total]"
		if(card3 == 1)
			dat += "<br>"
			dat += "Your first card is: [cardvalue1]"
			dat += "<br>"
			dat += "Your second card is: [cardvalue2]"
			dat += "<br>"
			dat += "Your third card is: [cardvalue3]"
			dat += "<br>"
			dat += "Your card total is: [total]"
		if(card4 == 1)
			dat += "<br>"
			dat += "Your first card is: [cardvalue1]"
			dat += "<br>"
			dat += "Your second card is: [cardvalue2]"
			dat += "<br>"
			dat += "Your third card is: [cardvalue3]"
			dat += "<br>"
			dat += "Your forth card is: [cardvalue4]"
			dat += "<br>"
			dat += "Your card total is: [total]"

		if(card5 == 1)
			dat += "Your first card is: [cardvalue1]"
			dat += "<br>"
			dat += "Your second card is: [cardvalue2]"
			dat += "<br>"
			dat += "Your third card is: [cardvalue3]"
			dat += "<br>"
			dat += "Your forth card is: [cardvalue4]"
			dat += "<br>"
			dat += "Your fifth card is: [cardvalue5]"
			dat += "<br>"
			dat += "Your card total is: [total]"
		if(stand == 1)
			dat += "Your cards total to:[total]"
			dat += "<br>"

		if(canplay)
			if(canhit)
				dat += "<br>"
				dat += "What will you do?"
				dat += "<br>"
				dat += "<A href='byond://?src=\ref[src];op=hit'>Hit!</A><BR>"
				dat += "<A href='byond://?src=\ref[src];op=stand'>Stand!</A><BR>"
				dat += "<br>"
			else
				dat += "<br>"
				dat += "What will you do?"
				dat += "<br>"
				dat += "<A href='byond://?src=\ref[src];op=stand'>Stand!</A><BR>"
				dat += "<br>"
		if(start == 1)
			dat += "<b>How to Play</b> <br> To play, you will be dealt two cards. Your objective is to get enough cards to get to 21. Unlike regular blackjack, Nanotrasen blackjack has its own rules and regulations. For instance you can only hit or stand as splitting and doubleing down require money. You are also limited to 5 cards, two being dealt as soon as you start. The reason these rules are in affect are so you can get a 'streak'. Streaks allow you to gain advantages while playing. Hitting a streak of 30 plays will give you an item to show how pro you are. Just remember though; you do not need to do consecutive wins to get your streak up. The more you play, the more you have a chance at winning an item! <br> WIN 50 games and you will win the champion belt! <br> It costs 1 coin to play each hand, you gain two coins for winning."
		user << browse(dat, "window=scroll")
		onclose(user, "scroll")
		return


/obj/machinery/blackjack/Topic(href, href_list)
	if (usr.stat)
		return
	if ((in_range(src, usr) && istype(src.loc, /turf)) || (istype(usr, /mob/living/silicon)))
		usr.set_machine(src)
		switch(href_list["op"])
			if("play")
				icon_state = "blackjack"//YOUR WINNER
				start = 0
				canhit = 1
				canplay = 1
				points -= 1
				card = 1
				cardvalue1 = rand(1,10)
				cardvalue2 = rand(1,10)
				deal()
				total = cardvalue1 + cardvalue2
				hitcard3 = 1
				attack_hand(usr)
				return
			if("hit")
				if(hitcard3)
					cardvalue3 = rand(1,10)
					hitcard3 = 0
					hitcard4 = 1
					card = 0
					card3 = 1
					total = cardvalue1 + cardvalue2 + cardvalue3
					if(total > 21)
						busted = 1
						canhit = 0
					attack_hand(usr)
					return
				if(hitcard4)
					cardvalue4 = rand(1,10)
					hitcard4 = 0
					hitcard5 = 1
					card3 = 0
					card4 = 1
					total = cardvalue1 + cardvalue2 + cardvalue3 + cardvalue4
					if(total > 21)
						busted = 1
						canhit = 0
					attack_hand(usr)
					return
				if(hitcard5)
					cardvalue5 = rand(1,10)
					canhit = 0
					total = cardvalue1 + cardvalue2 + cardvalue3 + cardvalue4 + cardvalue5
					card4 = 0
					card5 = 1
					if(total > 21)
						busted = 1
						canhit = 0
					attack_hand(usr)
					stand = 1
					return
			if("stand")
				stand = 1
				card5 = 0
				card4 = 0
				card3 = 0
				card = 0
				attack_hand(usr)
				enabled = 1
				canplay = 0
			if("restart")//Winning
				stand = 0
				card = 1
				cardvalue1 = 0
				cardvalue2 = 0
				cardvalue3 = 0
				cardvalue4 = 0
				cardvalue5 = 0
				cardvalue6 = 0
				card = 0
				card3 = 0
				card4 = 0
				card5 = 0
				total = 0
				canhit = 0
				start = 1
				busted = 0
				hitcard3 = 0
				hitcard4 = 0
				hitcard5 = 0
				canplay = 0
				dealer = 0
				chose = 0
				stand = 0
				tempstreak += 1
				if(tempstreak > highstreak)
					highstreak = tempstreak
			if("push")//Tie
				stand = 0
				card = 1
				cardvalue1 = 0
				cardvalue2 = 0
				cardvalue3 = 0
				cardvalue4 = 0
				cardvalue5 = 0
				cardvalue6 = 0
				card = 0
				card3 = 0
				card4 = 0
				card5 = 0
				total = 0
				canhit = 0
				start = 1
				busted = 0
				hitcard3 = 0
				hitcard4 = 0
				hitcard5 = 0
				chose = 0
				dealer = 0
				canplay = 0
				stand = 0
			if("reset")//losing
				stand = 0
				card = 1
				cardvalue1 = 0
				cardvalue2 = 0
				cardvalue3 = 0
				cardvalue4 = 0
				cardvalue5 = 0
				cardvalue6 = 0
				card = 0
				card3 = 0
				card4 = 0
				card5 = 0
				total = 0
				canhit = 0
				start = 1
				busted = 0
				hitcard3 = 0
				hitcard4 = 0
				hitcard5 = 0
				canplay = 0
				dealer = 0
				chose = 0
				stand = 0
				if(tempstreak > highstreak)
					highstreak = tempstreak
				spawn(1)
					tempstreak = 0
			if("grandprize")
				playsound(src.loc, 'sound/effects/blackjack3.ogg', 75, 1)
				var/obj/item/weapon/storage/belt/champion/casino/B = new/obj/item/weapon/storage/belt/champion/casino
				B.name = "21 Floortiles Champion Belt"
				B.loc = src.loc
				streak = 0
				icon_state = "blackjackwin"
			if("prize")
				playsound(src.loc, 'sound/effects/blackjack4.ogg', 75, 1)//Not as important
				var/obj/item/weapon/coin/plasma/B = new/obj/item/weapon/coin/plasma
				B.name = "Dr.Bonertons Sticky 1-of-a-kind coin"
				B.desc = "A result of stroking soppy donkpockets."
				B.loc = src.loc
				tempstreak = 0

		attack_hand(usr)
		return



/*
/obj/machinery/blackjack/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/weapon/storage/bag/coin))
		G.loc = src
		for(var/obj/item/weapon/coin/plasma/G in O.contents)
			if(G.
			points += 1
		user << "\red You insert the bag into the machine."
	if(istype(O, /obj/item/weapon/coin/plasma/))
		user << "\red You casually insert a coin into the machine."
		points += 1
		del(O)

		*/



/obj/machinery/casinoanouncer
	name = "21 Toolboxes (Blackjack)"
	desc = "From the hit game 20 floortiles."
	icon = 'icons/obj/computer.dmi'
	icon_state = "blackjack"
	var/p1 = 0//1 for each ID
	var/p2 = 0
	var/p3 = 0
	var/p4 = 0
	var/done//Lets it know in the process if all players are done

/obj/machinery/casinoanouncer/process()
	for(var/obj/machinery/blackjack/D in view(7,src))
		done = 0
		if(D.ID == 1)
			done += 1
			p1 = D.total
		if(D.ID == 2)
			done += 2
			p2 = D.total
		if(D.ID == 3)
			done += 3
			p3 = D.total
		if(D.ID == 4)
			done += 4
			p4 = D.total
		if(done >= 4)
			world << "<b>The Dealer</b> says, 'Player 1 scored a [p1], Player 2 scored [p2], Player 3 scored a [p3], and player 4 scored a [p4]!"
			done = 0
			D.lock = 0
			logic()
/obj/machinery/casinoanouncer/proc/logic()
	if(p1 > p2 && p1 > p3 && p1 > p4 && p1 < 21)
		world << "Player 1 wins the hand!"
	if(p2 > p1 && p2 > p3 && p2 > p4 && p2 < 21)
		world << "Player 2 wins the hand!"
	if(p3 > p1 && p3 > p2 && p1 > p4 && p3 < 21)
		world << "Player 3 wins the hand!"
	if(p4 > p2 && p4 > p3 && p4 > p1 && p4 < 21)
		world << "Player 4 wins the hand!"



/obj/machinery/biogenerator/casino
	name = "Coinverter"
	desc = "Change items into casino coins!"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "furnace"
	var/vip = 0
	var/discount = 0
	update_icon()
		if(!src.beaker)
			icon_state = "furnace"
		else if(!src.processing)
			icon_state = "furnace"
		else
			icon_state = "furnace"
		return



	New()
		..()
		var/datum/reagents/R = new/datum/reagents(1000)
		reagents = R
		R.my_atom = src
		beaker = new /obj/item/weapon/reagent_containers/glass/beaker/large(src)
	//	if(Holiday == "Casino Night")
	//		if(prob(20))
		//		for(var/obj/machinery/biogenerator/casino/B in world)
		//			B.discount = 1
	on_reagent_change()			//When the reagents change, change the icon as well.
		update_icon()



/obj/machinery/biogenerator/casino/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(processing)
		user << "\red The coinverter is currently processing."
	else if(istype(O, /obj/item/weapon/storage/bag/coin))
		var/i = 0
		for(var/obj/item/weapon/coin/plasma/G in contents)
			i++
		if(i >= 50)
			user << "\red The coinverter is already full! Activate it."
		else
			for(var/obj/item/weapon/coin/plasma/G in O.contents)
				if(G.casino == 1)
					G.loc = src
					i++
					if(i >= 50)
						user << "\blue You fill the coinverter to its capacity."
						break
				else
					if(G.casino == 1)
						if(i<50)
							user << "\blue You empty the coin bag into the coinverter."
					else
						user << "\blue You empty the coin bag into the coinverter; however the coins not won from Blackjack fall teleport back into your bag!."
			//	casino()
	else if(!istype(O, /obj/item/weapon/coin/plasma))
		user << "\red You cannot put this in [src.name]"
	else
		var/i = 0
		for(var/obj/item/weapon/coin/plasma/G in contents)
			i++
		if(i >= 50)
			user << "\red The coinverter is full! Activate it."
		else
			user.before_take_item(O)
			O.loc = src
			user << "\blue You put [O.name] in [src.name]"
	//	casino()
	update_icon()
	return

/obj/machinery/biogenerator/casino/proc/casino()
	if (usr.stat != 0)
		return
	if (src.stat != 0) //NOPOWER etc
		return
	if(src.processing)
		usr << "\red The coinverter is in the process of working."
		return
	var/S = 0
	for(var/obj/item/weapon/coin/plasma/I in contents)
		S += 5
		points += 1
		del(I)
	if(S)
		processing = 1
		update_icon()
		updateUsrDialog()
		playsound(src.loc, 'sound/machines/blender.ogg', 50, 1)
		use_power(S*30)
		sleep(S+15)
		processing = 0
		update_icon()
	else
		menustat = "void"
	return

/obj/machinery/biogenerator/casino/interact(mob/user as mob)
	if(stat & BROKEN)
		return
	user.set_machine(src)
	var/dat = "<TITLE>Coinverter</TITLE>Coinverter:<BR>"
	if (processing)
		dat += "<FONT COLOR=red>coinverter is processing! Please wait...</FONT>"
	else // should work...
		dat += "Casino Coins: [points] coins.<HR>"
		switch(menustat)
			if("menu")
				if(beaker)
					dat += "<A href='?src=\ref[src];action=create;item=coin;cost=1'>Casino Coin Cashout</A> <FONT COLOR=blue>(x1)</FONT><br> | <A href='?src=\ref[src];action=create;item=coin10;cost=10'>x10</A><BR>"
					dat += "<A href='?src=\ref[src];action=create;item=clear;cost=20'>Clearo PDA</A> <FONT COLOR=blue>(20)</FONT><BR>"
					dat += "<A href='?src=\ref[src];action=create;item=gloves;cost=20'>'Insulated' Gloves</A> <FONT COLOR=blue>(20)</FONT><BR>"
					dat += "<A href='?src=\ref[src];action=create;item=steak;cost=20'>fsteak</A> <FONT COLOR=blue>(20)</FONT><BR>"
					dat += "<A href='?src=\ref[src];action=create;item=armband;cost=20'>Hippy Armband</A> <FONT COLOR=blue>(20)</FONT><BR>"
					dat += "<A href='?src=\ref[src];action=create;item=lipstick;cost=20'>Extra-Special Lipstick</A> <FONT COLOR=blue>(20)</FONT><BR>"
					dat += "<A href='?src=\ref[src];action=create;item=assx;cost=20'>ASS-X</A> <FONT COLOR=blue>(20)</FONT><BR>"
					dat += "<A href='?src=\ref[src];action=create;item=rr;cost=20'>Revolver of Chance</A> <FONT COLOR=blue>(20)</FONT><BR>"
					dat += "<A href='?src=\ref[src];action=create;item=weld;cost=20'>Welding Tool Collection</A> <FONT COLOR=blue>(20)</FONT><BR>"
					dat += "<A href='?src=\ref[src];action=create;item=gshoe;cost=20'>Ghastly Shoes</A> <FONT COLOR=blue>(20)</FONT><BR>"
					dat += "<A href='?src=\ref[src];action=create;item=speaker;cost=30'>TTS</A> <FONT COLOR=blue>(30)</FONT><BR>"
					dat += "<A href='?src=\ref[src];action=create;item=box;cost=100'>THE ULTIMATE PRIZE</A> <FONT COLOR=blue>(100)</FONT><BR>"
					if(vip == 0)
						dat += "<A href='?src=\ref[src];action=create;item=vip;cost=50'>VIP Card</A> <FONT COLOR=red>(50)</FONT><BR>"
					else
						dat += "<A href='?src=\ref[src];action=create;item=bucket;cost=30'>Bucket Buddy</A> <FONT COLOR=red>(30)</FONT><BR>"
						dat += "<A href='?src=\ref[src];action=create;item=brief;cost=30'>Case-E</A> <FONT COLOR=red>(30)</FONT><BR>"
						dat += "<A href='?src=\ref[src];action=create;item=gun;cost=40'>A Raw Deal</A> <FONT COLOR=red>(40)</FONT><BR>"
						dat += "<A href='?src=\ref[src];action=create;item=luck;cost=40'>777</A> <FONT COLOR=red>(40)</FONT><BR>"
						dat += "<A href='?src=\ref[src];action=create;item=sero;cost=50'>Serotonium Pill</A> <FONT COLOR=red>(50)</FONT><BR>"
						dat += "<A href='?src=\ref[src];action=create;item=elec;cost=60'>ULTRA VIP CARD</A> <FONT COLOR=red>(60)</FONT><BR>"
				else
					dat += "<BR><FONT COLOR=red>No beaker inside. Please insert a beaker.</FONT><BR>"
			if("nopoints")
				dat += "You do not have enough coins.<BR>Please put more coins into reactor and activate it.<BR>"
				dat += "<A href='?src=\ref[src];action=menu'>Return to menu</A>"
			if("complete")
				dat += "Operation complete.<BR>"
				dat += "<A href='?src=\ref[src];action=menu'>Return to menu</A>"
			if("void")
				dat += "<FONT COLOR=red>Error: No coins inside.</FONT><BR>Please, put coins into reactor.<BR>"
				dat += "<A href='?src=\ref[src];action=menu'>Return to menu</A>"
	user << browse(dat, "window=biogenerator")
	onclose(user, "biogenerator")
	return


/obj/machinery/biogenerator/proc/create_coin(var/item,var/cost)
	if(cost > points)
		menustat = "nopoints"
		return 0
	processing = 1
	update_icon()
	updateUsrDialog()
	points -= cost
	sleep(30)
	switch(item)
		if("coin")
			new/obj/item/weapon/coin/plasma (src.loc)
		if("coin10")
			new/obj/item/weapon/coin/plasma (src.loc)
			new/obj/item/weapon/coin/plasma (src.loc)
			new/obj/item/weapon/coin/plasma (src.loc)
			new/obj/item/weapon/coin/plasma (src.loc)
			new/obj/item/weapon/coin/plasma (src.loc)
			new/obj/item/weapon/coin/plasma (src.loc)
			new/obj/item/weapon/coin/plasma (src.loc)
			new/obj/item/weapon/coin/plasma (src.loc)
			new/obj/item/weapon/coin/plasma (src.loc)
			new/obj/item/weapon/coin/plasma (src.loc)
		if("clear")
			var/obj/item/device/pda/clear/B = new/obj/item/device/pda/clear
			B.name = "Clearo-Tech PDA"
			B.desc = "What the hell I can still see it, I want a refund!"
			B.loc = src.loc
		if("gloves")
			var/obj/item/clothing/gloves/fyellow/B = new/obj/item/clothing/gloves/fyellow //Easy prizes = easy fool!
			B.name = "Insulated Gloves"
			B.desc = "Give me 20 toolbelts, give me 20 toolbelts, no insulated gloves."
			B.loc = src.loc
		if("steak")
			var/obj/item/weapon/reagent_containers/food/snacks/meatsteak/B = new/obj/item/weapon/reagent_containers/food/snacks/meatsteak
			B.name = "Beefsteak"
			B.desc = "If you drop the 'beef' from it, shouldn't it be called fsteak..?"
			B.loc = src.loc
		if("lipstick")
			var/obj/item/weapon/lipstick/random/B = new/obj/item/weapon/lipstick/random
			B.name = "Bishop Bishopson's Namby Pamby Lipstick"
			B.desc = "The smell of deminned at half the price!"
			B.loc = src.loc
		if("assx")
			var/obj/item/weapon/reagent_containers/pill/inspectionitesplacebo/B = new/obj/item/weapon/reagent_containers/pill/inspectionitesplacebo
			B.name = "AIiMB Brand ASS-X"
			B.desc = "Woop!"
			B.loc = src.loc
		if("rr")
			var/obj/item/weapon/gun/projectile/russian/B = new/obj/item/weapon/gun/projectile/russian
			B.name = "Broken Revolver"
			B.desc = "The revolving russian!"
			B.loc = src.loc
		if("weld")
			var/obj/item/clothing/head/collectable/welding/B = new/obj/item/clothing/head/collectable/welding
			B.name = "Hippy Glasses"
			B.desc = "HIPPIES!"
			B.loc = src.loc
		if("gshoe")
			var/obj/item/clothing/shoes/green/B = new/obj/item/clothing/shoes/green
			B.name = "Ghastly Green Shoes"
			B.desc = "Its a shoe-in, get it?"
			B.loc = src.loc
		if("speaker")
			var/obj/item/device/speaker/B = new/obj/item/device/speaker
			B.name = "Text-To-Speaker"
			B.desc = "Fun fact; there is a cat in here!"
			B.loc = src.loc
		if("box")
			var/obj/item/weapon/storage/box/casino/B = new/obj/item/weapon/storage/box/casino
			B.name = "Fancy Box"
			B.desc = "WHATS IN HERE!?!?!"
			B.loc = src.loc
		if("vip")
			var/obj/item/weapon/card/VIP/B = new/obj/item/weapon/card/VIP
			B.name = "Barkeepsky Casino VIP Card"
			B.desc = "Point waster."
			B.loc = src.loc
		if("bucket")
			var/obj/item/weapon/bucket_sensor/B = new/obj/item/weapon/bucket_sensor
			B.name = "Bucket O' Sensor"
			B.desc = "A friendly buddy!"
			B.loc = src.loc
		if("brief")
			var/obj/item/weapon/storage/secure/briefcase/B = new/obj/item/weapon/storage/secure/briefcase
			B.name = "Case-E"
			B.desc = "Your new best friend!"
			B.loc = src.loc
		if("gun")
			var/obj/item/weapon/gun/projectile/raigun/B = new/obj/item/weapon/gun/projectile/raigun
			B.name = "A Raw Deal"
			B.desc = "Somewere stuck between some cheap knock off of a bond movie and a gun ban."
			B.loc = src.loc
		if("sero")
			var/obj/item/weapon/reagent_containers/pill/sero/B = new/obj/item/weapon/reagent_containers/pill/sero
			B.loc = src.loc
		if("elec")
			var/obj/item/weapon/card/VIP/ultra/B = new/obj/item/weapon/card/VIP/ultra
			B.loc = src.loc
	processing = 0
	menustat = "complete"
	update_icon()
	return 1


/obj/machinery/biogenerator/casino/Topic(href, href_list)
	if(stat & BROKEN) return
	if(usr.stat || usr.restrained()) return
	if(!in_range(src, usr)) return

	usr.set_machine(src)

	switch(href_list["action"])
		if("activate") // is this never called...?
			casino()
//		if("detach")
//			if(beaker)
//				beaker.loc = src.loc
//				beaker = null
//				update_icon()
		if("create")
			create_coin(href_list["item"],text2num(href_list["cost"]))
		if("menu")
			menustat = "menu"
	updateUsrDialog()


/obj/machinery/itemverter
	name = "Itemverter"
	icon = 'icons/obj/virology.dmi'
	icon_state = "analyser"
	anchored = 1
	density = 1
	var/vip = 0
/obj/machinery/itemverter/attackby(var/obj/item/O as obj, var/mob/living/carbon/human/user as mob)
	if(istype(user, /mob/living/carbon/human))
		if(istype(O, /obj/item/weapon))
			if(vip == 0)
				if(istype(O, /obj/item/weapon/disk/nuclear))
					user << "\red You can't insert that!"
					return
				if(istype(O, /obj/item/weapon/paper))
					user << "\red This item is too generic!"
				if(istype(O, /obj/item/stack/tile/plasteel))
					user << "\red This item is too generic!"
					return
				if(istype(O, /obj/item/weapon/coin/plasma))
					user << "\red SERIOUSLY!?!"
					return
				if(istype(O, /obj/item/weapon/storage/bag/coin ))
					user << "\red Come on, really?"
					return
				var/obj/item/weapon/coin/plasma/C = new/obj/item/weapon/coin/plasma
				C.loc = src.loc
				user << "\red You insert the [O.name] into the Itemverter."
				O.loc = src
				del(O)
			else
				if(istype(O, /obj/item/weapon/disk/nuclear))
					user << "\red You can't insert that!"
					return
				if(istype(O, /obj/item/weapon/paper))
					user << "\red This item is too generic!"
				if(istype(O, /obj/item/stack/tile/plasteel))
					user << "\red This item is too generic!"
					return
				if(istype(O, /obj/item/weapon/coin/plasma))
					user << "\red SERIOUSLY!?!"
					return
				if(istype(O, /obj/item/weapon/storage/bag/coin ))
					user << "\red Come on, really?"
					return
				var/obj/item/weapon/coin/plasma/C = new/obj/item/weapon/coin/plasma
				C.loc = src.loc
				var/obj/item/weapon/coin/plasma/B = new/obj/item/weapon/coin/plasma
				B.loc = src.loc
				var/obj/item/weapon/coin/plasma/D = new/obj/item/weapon/coin/plasma
				D.loc = src.loc
				user << "\red You insert the [O.name] into the Itemverter."
				O.loc = src
				del(O)


/obj/item/weapon/storage/box/casino
	name = "Fancy Box"

/obj/item/weapon/storage/box/casino/New()
	..()
	new /obj/item/clothing/head/collectable/tophat(src)
	new /obj/item/clothing/glasses/monocle(src)
	new /obj/item/clothing/mask/fakemoustache(src)
	new /obj/item/clothing/gloves/white(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/under/lawyer/black(src)



/obj/structure/reagent_dispensers/beerkeg/bartap
	name = "Bartap"
	desc = "Your bound to end up drinking from this directly sooner or later.."
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "bartap"
	anchored = 1

	attackby(var/obj/item/O as obj, var/mob/living/carbon/human/user as mob)
		if(istype(O, /obj/item/weapon/coin/plasma))
		 var/obj/item/weapon/reagent_containers/food/drinks/beer/B = new/obj/item/weapon/reagent_containers/food/drinks/beer
			B.icon_state = "beepskysmashglass"
			B.name = "Barkeepskys Finest Beer"
			B.desc = "Served in a Beepsky styled container! Its definitely plain beer!"
			B.loc = src.loc
			user.drop_item()
			del(O)


/obj/structure/reagent_dispensers/atomickeg/bartap
	name = "VIP Bartap"
	desc = "VIP GOOD!"
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "bartap"
	anchored = 1

	attackby(var/obj/item/O as obj, var/mob/living/carbon/human/user as mob)
		if(istype(O, /obj/item/weapon/coin/plasma))
		 var/obj/item/weapon/reagent_containers/food/drinks/beer/B = new/obj/item/weapon/reagent_containers/food/drinks/beer
			B.icon_state = "beepskysmashglass"
			B.name = "Barkeepskys Finest VIP Beer"
			B.desc = "Served in a Beepsky styled container! Its definitely plain beer!"
			B.loc = src.loc
			user.drop_item()
			del(O)



/obj/structure/table/holotable/unbreak
	icon_state = "wood_table"

	attackby(obj/item/weapon/W as obj, mob/living/carbon/human/user as mob)
		if(istype(user, /mob/living/carbon/human))
			if (istype(W, /obj/item/weapon/grab) && get_dist(src,user)<2)
				return

			if (istype(W, /obj/item/weapon/wrench))
				user << "It's not station property!  You can't remove this!"
				return
			if (istype(W, /obj/item))
				user.drop_item()
				W.loc = src.loc
			if(isrobot(user))
				return

	CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
		return


/obj/machinery/blackjack/VIP
	name = "VIP 21 Toolboxes"
	desc = "From the hit game 20 floortiles."
	grandprize = 30
	prize = 15
	vip = 1


/obj/machinery/blackjack/proc/deal()
	if(vip == 0)
		if(dealer == 0)//Why are we dealing dealer cards now? Dem cards man dem cards
			dealer = rand(1,13)
			if(dealer <= 5)
				dealer = dealer + rand(12,18)
				if(prob(25)) //The ai is a crapshoot
					dealer = rand(21,26)
			else
				if(dealer <= 10 && dealer >= 5) //The ai is a crapshoot
					dealer = rand(15,22)
	else
		if(dealer == 0)//Why are we dealing dealer cards now? Dem cards man dem cards
			dealer = rand(17,21)//smarter AI, duh
			if(prob(25)) //The ai is a crapshoot
				dealer = rand(21,25)