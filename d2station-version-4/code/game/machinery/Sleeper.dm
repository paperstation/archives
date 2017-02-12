/////////////////////////////////////////
// SLEEPER CONSOLE
/////////////////////////////////////////

/obj/machinery/sleep_console
	name = "Sleeper Console"
	icon = 'Cryogenic2.dmi'
	icon_state = "sleeperconsole"
	var/obj/machinery/sleeper/connected = null
	anchored = 1 //About time someone fixed this.
	density = 0 //looks retarded with 1
	var/orient = "LEFT" // "RIGHT" changes the dir suffix to "-r"
	var/emagged = 0

/obj/machinery/sleep_console/ex_act(severity)
	switch(severity)
		if(1.0)
			//SN src = null
			del(src)
			return
		if(2.0)
			if (prob(50))
				//SN src = null
				del(src)
				return
		else
	return

/obj/machinery/sleep_console/New()
	..()
	spawn( 5 )
		if(orient == "RIGHT")
			icon_state = "sleeperconsole-r"
			src.connected = locate(/obj/machinery/sleeper, get_step(src, EAST))
		else
			src.connected = locate(/obj/machinery/sleeper, get_step(src, WEST))

		return
	return

/obj/machinery/sleep_console/attackby(obj/G as obj, mob/user as mob)
	if ((istype(G, /obj/item/weapon/card/emag)) && (!src.emagged))
		emagged = 1
		user << text("\blue <B>You emag the [src]</b>")
		spawn(0)
			for(var/mob/O in hearers(src, null))
				O.show_message("\red <B>[src] buzzes oddly!</B>", 1)

/obj/machinery/sleep_console/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/sleep_console/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/sleep_console/attack_hand(mob/user as mob)
	if(..())
		return
	if (src.connected)
		var/mob/occupant = src.connected.occupant
		var/dat = "<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><font color='blue'><B>Occupant Statistics:</B></FONT><BR>"
		if (occupant)
			var/t1
			switch(occupant.stat)
				if(0)
					t1 = "Conscious"
				if(1)
					t1 = "<font color='blue'>Unconscious</font>"
				if(2)
					t1 = "<font color='red'>*dead*</font>"
			if ((!occupant.ckey) || (!occupant.client))
				dat += "<BR><font color='red'>Error: Mental interface failure.</font><BR><BR>"
			dat += text("[]\tHealth %: [] ([])</FONT><BR>", (occupant.health > 50 ? "<font color='blue'>" : "<font color='red'>"), occupant.health, t1)
			dat += text("Blood: [] units<BR>", occupant.blood)
			dat += text("[]\t-Brute Damage %: []</FONT><BR>", (occupant.bruteloss < 60 ? "<font color='blue'>" : "<font color='red'>"), occupant.bruteloss)
			dat += text("[]\t-Respiratory Damage %: []</FONT><BR>", (occupant.oxyloss < 60 ? "<font color='blue'>" : "<font color='red'>"), occupant.oxyloss)
			dat += text("[]\t-Toxin Content %: []</FONT><BR>", (occupant.toxloss < 60 ? "<font color='blue'>" : "<font color='red'>"), occupant.toxloss)
			dat += text("[]\t-Burn Severity %: []</FONT><BR>", (occupant.fireloss < 60 ? "<font color='blue'>" : "<font color='red'>"), occupant.fireloss)
			dat += text("<HR>Paralysis Summary %: [] ([] seconds left!)<BR>", occupant.paralysis, round(occupant.paralysis / 4))
			dat += text("Inaprovaline units: [] units<BR>", occupant.reagents.get_reagent_amount("inaprovaline"))
			dat += text("Clonexadone: [] units<BR>", occupant.reagents.get_reagent_amount("clonexadone"))
			dat += text("Dermaline: [] units<BR>", occupant.reagents.get_reagent_amount("dermaline"))
			dat += text("Dylovene: [] units<BR>", occupant.reagents.get_reagent_amount("anti_toxin"))
			dat += text("Bicaridine: [] units<BR>", occupant.reagents.get_reagent_amount("bicaridine"))
			dat += text("Dexalin+: [] units<BR>", occupant.reagents.get_reagent_amount("dexalinp"))
			dat += text("Polyadrenalobin: [] units<BR>", occupant.reagents.get_reagent_amount("polyadrenalobin"))
			dat += text("Nutriment: [] units<BR>", occupant.reagents.get_reagent_amount("nutriment"))
			if(src.emagged == 1)
				dat += text("Sleep Toxins: [] units<BR>", occupant.reagents.get_reagent_amount("stoxin"))
				dat += text("Toxins: [] units<BR>", occupant.reagents.get_reagent_amount("toxin"))
			dat += text("<HR><A href='?src=\ref[];refresh=1'>Refresh meter readings each second</A><BR><A href='?src=\ref[];inap=1'>Inject Inaprovaline</A><BR><A href='?src=\ref[];clon=1'>Inject Clonexadone</A><BR><A href='?src=\ref[];derm=1'>Inject Dermaline</A><BR><A href='?src=\ref[];bic=1'>Inject Bicaridine</A><BR><A href='?src=\ref[];dex=1'>Inject Dexalin+</A><BR><A href='?src=\ref[];revive_occupant=1'><font color='red'>Resurrect Occupant</font></A><BR><A href='?src=\ref[];stox=1'>Inject Sleep Toxins</A><BR><A href='?src=\ref[];nut=1'>Inject Nutriment</A><BR><A href='?src=\ref[];antitoxin=1'>Inject Dylovene</A>", src, src, src, src, src, src, src, src, src, src)
		else
			dat += "The sleeper is empty."
		dat += text("<BR><BR><A href='?src=\ref[];mach_close=sleeper'>Close</A>", user)
		user << browse(dat, "window=sleeper;size=400x500")
		onclose(user, "sleeper")
	return

/obj/machinery/sleep_console/Topic(href, href_list)
	if(..())
		return
	if ((usr.contents.Find(src) || ((get_dist(src, usr) <= 1) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon/ai)))
		usr.machine = src
		if (src.connected)
			if (href_list["inap"])
				src.connected.inject_inap(usr)
				src.updateUsrDialog()
			if (href_list["clon"])
				src.connected.inject_clonexadone(usr)
				src.updateUsrDialog()
			if (href_list["derm"])
				src.connected.inject_dermaline(usr)
				src.updateUsrDialog()
			if (href_list["bic"])
				src.connected.inject_bicaridine(usr)
				src.updateUsrDialog()
			if (href_list["dex"])
				src.connected.inject_dexalin(usr)
				src.updateUsrDialog()
			if (href_list["antitoxin"])
				src.connected.inject_antitoxin(usr)
				src.updateUsrDialog()
			if (href_list["revive_occupant"])
				src.connected.revive_occupant(usr)
				src.updateUsrDialog()
				src.connected.inject_inap(usr)
				src.updateUsrDialog()
			if (href_list["nut"])
				src.connected.inject_nutriment(usr)
				src.updateUsrDialog()
			if (href_list["stox"])
				src.connected.inject_stoxins(usr)
				src.updateUsrDialog()

		if (href_list["refresh"])
			src.updateUsrDialog()
		src.add_fingerprint(usr)
	return

/obj/machinery/sleep_console/process()
	if(stat & (NOPOWER|BROKEN))
		return
	src.updateUsrDialog()
	if(emagged)
		icon_state = "sleeperconsole-p"

	if (src.connected)
		if (src.connected.occupant)
			if(src.connected.occupant.health > 70)
				playsound(src.loc, 'normalrate.ogg', 3, 0)
				sleep(10)
			else if(src.connected.occupant.health < -199)
				playsound(src.loc, 'flatline.ogg', 3, 0)
				sleep(9)
			else if(src.connected.occupant.health < 100)
				playsound(src.loc, 'fasterrate3.ogg', 3, 0)
				sleep(src.connected.occupant.health / 40)
			else if(src.connected.occupant.health < 70)
				playsound(src.loc, 'fasterrate.ogg', 3, 0)
				sleep(src.connected.occupant.health / 20)
			else if(src.connected.occupant.health < 0)
				playsound(src.loc, 'fasterrate2.ogg', 3, 0)
				sleep(src.connected.occupant.health / 20)
		else
			return
		return

/obj/machinery/sleep_console/power_change()
	return
	// no change - sleeper works without power (you just can't inject more)







/////////////////////////////////////////
// THE SLEEPER ITSELF
/////////////////////////////////////////

/obj/machinery/sleeper
	name = "Sleeper"
	icon = 'Cryogenic2.dmi'
	icon_state = "sleeper_0"
	density = 1
	var/occupied = 0 // So there won't be multiple persons trying to get into one sleeper
	var/mob/occupant = null
	anchored = 1
	var/orient = "LEFT" // "RIGHT" changes the dir suffix to "-r"
	var/rejuvtime = null


/obj/machinery/sleeper/New()
	..()
	spawn( 5 )
		if(orient == "RIGHT")
			icon_state = "sleeper_0-r"

		return
	return

/obj/machinery/sleeper/dummy//For effects only.
	icon_state = "sleeper_1"

/obj/machinery/sleeper/allow_drop()
	return 0

/obj/machinery/sleeper/process()
	src.updateDialog()
	return

/obj/machinery/sleeper/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.loc = src.loc
				ex_act(severity)
			del(src)
			return
		if(2.0)
			if (prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
				del(src)
				return
	return

/obj/machinery/sleeper/blob_act()
	if(prob(75))
		for(var/atom/movable/A as mob|obj in src)
			A.loc = src.loc
			A.blob_act()
		del(src)
	return

/obj/machinery/sleeper/attackby(obj/item/weapon/grab/G as obj, mob/user as mob)
	if ((!( istype(G, /obj/item/weapon/grab) ) || !( ismob(G.affecting) )))
		return
	if (src.occupant)
		user << "\blue <B>The sleeper is already occupied!</B>"
		return
																// Removing the requirement for subjects to be naked -- TLE
/*	if (G.affecting.abiotic())
		user << "Subject may not have abiotic items on."
		return */
	for (var/mob/V in viewers(user))
		V.show_message("[user] starts putting [G.affecting.name] into the sleeper.", 3)
	if(do_after(user, 20))
		if(!G || !G.affecting) return
		var/mob/M = G.affecting
		if (M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		if (!M.client)
			for(var/mob/dead/observer/O)
				if(O.client && O.computer_id == M.computer_id)
					O << "\red <B>-------------------------------------------------------------------</B>"
					O << "\red <B>YOU HAVE BEEN PUT INTO A SLEEPER. GO BACK TO YOUR BODY FOR REVIVAL!</B>"
					O << "\red <B>-------------------------------------------------------------------</B>"

		M.loc = src
		src.occupant = M
		src.icon_state = "sleeper_1"
		if(orient == "RIGHT")
			icon_state = "sleeper_1-r"

		for(var/obj/O in src)
			O.loc = src.loc
		src.add_fingerprint(user)
		del(G)
		return
	return

/obj/machinery/sleeper/dummy/attackby()
	return

/obj/machinery/sleeper/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.loc = src.loc
				ex_act(severity)
			del(src)
			return
		if(2.0)
			if (prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
				del(src)
				return
		if(3.0)
			if (prob(25))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
				del(src)
				return
		else
	return

/obj/machinery/sleeper/alter_health(mob/living/M as mob)
	if (M.health > 0)
		if (M.oxyloss >= 10)
			var/amount = max(0.15, 1)
			M.oxyloss -= amount
		else
			M.oxyloss = 0
		M.updatehealth()
	M.paralysis -= 4
	M.weakened -= 4
	M.stunned -= 4
	if (M.paralysis <= 1)
		M.paralysis = 3
	if (M.weakened <= 1)
		M.weakened = 3
	if (M.stunned <= 1)
		M.stunned = 3
	if (M:reagents.get_reagent_amount("inaprovaline") < 5)
		M:reagents.add_reagent("inaprovaline", 5)
	return

/obj/machinery/sleeper/proc/go_out()
	if (!src.occupant)
		return
	for(var/obj/O in src)
		O.loc = src.loc
	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.occupant.loc = src.loc
//	src.occupant.metabslow = 0
	src.occupant = null

	if(orient == "RIGHT")
		icon_state = "sleeper_0-r"
	return

/obj/machinery/sleeper/proc/inject_inap(mob/user as mob)
	if (src.occupant)
		if (src.occupant.reagents.get_reagent_amount("inaprovaline") + 30 <= 90)
			src.occupant.reagents.add_reagent("inaprovaline", 30)
		user << text("Occupant now has [] units of Inaprovaline in his/her bloodstream.", src.occupant.reagents.get_reagent_amount("inaprovaline"))
	else
		user << "No occupant!"
	return


/obj/machinery/sleeper/proc/inject_clonexadone(mob/user as mob)
	if (src.occupant)
		if (src.occupant.reagents.get_reagent_amount("clonexadone") + 20 <= 90)
			src.occupant.reagents.add_reagent("clonexadone", 20)
		user << text("Occupant now has [] units of clonexadone in his/her bloodstream.", src.occupant.reagents.get_reagent_amount("clonexadone"))
	else
		user << "No occupant!"
	return

/obj/machinery/sleeper/proc/inject_dermaline(mob/user as mob)
	if (src.occupant)
		if (src.occupant.reagents.get_reagent_amount("dermaline") + 20 <= 90)
			src.occupant.reagents.add_reagent("dermaline", 20)
		user << text("Occupant now has [] units of Dermaline in his/her bloodstream.", src.occupant.reagents.get_reagent_amount("dermaline"))
	else
		user << "No occupant!"
	return

/obj/machinery/sleeper/proc/inject_bicaridine(mob/user as mob)  //GRAND AGOURI MARKER
	if (src.occupant)
		if (src.occupant.reagents.get_reagent_amount("bicaridine") + 10 <= 90)
			src.occupant.reagents.add_reagent("bicaridine", 10)
		user << text("Occupant now has [] units of Bicaridine in his/her bloodstream.", src.occupant.reagents.get_reagent_amount("bicaridine"))
	else
		user << "No occupant!"
	return

/obj/machinery/sleeper/proc/inject_antitoxin(mob/user as mob)  //hi i'm deadsnipe if this breaks your everything i'm sorry
	if (src.occupant)
		if (src.occupant.reagents.get_reagent_amount("anti_toxin") + 10 <= 90)
			src.occupant.reagents.add_reagent("anti_toxin", 10)
		user << text("Occupant now has [] units of Dylovene in his/her bloodstream.", src.occupant.reagents.get_reagent_amount("anti_toxin"))
	else
		user << "No occupant!"
	return


/obj/machinery/sleeper/proc/inject_dexalin(mob/user as mob)  //GRAND AGOURI MARKER
	if (src.occupant)
		if (src.occupant.reagents.get_reagent_amount("dexalinp") + 20 <= 90)
			src.occupant.reagents.add_reagent("dexalinp", 20)
		user << text("Occupant now has [] units of Dexalin+ in his/her bloodstream.", src.occupant.reagents.get_reagent_amount("dexalinp"))
	else
		user << "No occupant!"
	return

/obj/machinery/sleeper/proc/revive_occupant(mob/user as mob)  //GRAND AGOURI MARKER
	if (src.occupant)
		if (src.occupant.reagents.get_reagent_amount("polyadrenalobin") <= 90)
			src.occupant.reagents.add_reagent("polyadrenalobin", 10)
		user << text("Occupant now has [] units of Polyadrenalobin in his/her bloodstream.", src.occupant.reagents.get_reagent_amount("polyadrenalobin"))
	else
		user << "No occupant!"
	return


/obj/machinery/sleeper/proc/inject_nutriment(mob/user as mob)  //GRAND AGOURI MARKER
	if (src.occupant)
		if (src.occupant.reagents.get_reagent_amount("nutriment") + 10 <= 90)
			src.occupant.reagents.add_reagent("nutriment", 10)
		user << text("Occupant now has [] units of Nutriment in his/her bloodstream.", src.occupant.reagents.get_reagent_amount("nutriment"))
	else
		user << "No occupant!"
	return
/obj/machinery/sleeper/proc/inject_stoxins(mob/user as mob)
	if (src.occupant)
		if (src.occupant.reagents.get_reagent_amount("stoxin") + 10 <= 90)
			src.occupant.reagents.add_reagent("stoxin", 10)
		user << text("Occupant now has [] units of Sleep Toxins in his/her bloodstream.", src.occupant.reagents.get_reagent_amount("stoxin"))
	else
		user << "No occupant!"
	return

///obj/machinery/sleeper/proc/inject_toxins(mob/user as mob)
//	if (src.occupant)
//		if (src.occupant.reagents.get_reagent_amount("toxin") + 10 <= 90)
//			src.occupant.reagents.add_reagent("toxin", 10)
//		user << text("Occupant now has [] units of Toxins in his/her bloodstream.", src.occupant.reagents.get_reagent_amount("toxin"))
//	else
//		user << "No occupant!"
//	return

// BEGIN REVIVAL STUFF (BECAUSE FUCK POLY) FUCK YOU - Emyylii - no, FUCK YOU -snipe
/*
/obj/machinery/sleeper/proc/revive_occupant(mob/user as mob)
	if (src.occupant)
		if (!rejuvtime)
			src.occupant.toxloss = 0
			src.occupant.fireloss = 0
			src.occupant.bruteloss = 0
			src.occupant.cloneloss = 0
			src.occupant.oxyloss = 0
			src.occupant.radiation = 0
			src.occupant.blood = 300
			src.occupant.arrhythmia = 0
			src.occupant.thrombosis = 0
			src.occupant.heartrate = 80
			src.occupant.bleeding = 0
			src.occupant.bloodstopper = 0
			src.occupant.bloodloss = 0
			src.occupant.headbloodloss = 0
			src.occupant.l_handbloodloss = 0
			src.occupant.r_handbloodloss = 0
			src.occupant.l_armbloodloss = 0
			src.occupant.r_armbloodloss = 0
			src.occupant.l_footbloodloss = 0
			src.occupant.r_footbloodloss = 0
			src.occupant.l_legbloodloss = 0
			src.occupant.r_legbloodloss = 0
			src.occupant.l_handbloodloss = 0
			src.occupant.r_handbloodloss = 0
			src.occupant.reagents.add_reagent("polyadrenalobin", 60)
			src.occupant.losebreath = 0
			if (src.occupant.stat > 1)
				src.occupant.stat=0
			src.rejuvtime = 1
			spawn(6000)
				src.rejuvtime = null
		else if (src.rejuvtime)
			usr << "\red The sleeper is still restoring its regenerative chemical reserves."
			return

*/
///obj/machinery/sleeper/proc/check(mob/user as mob)
	if (src.occupant)
		user << text("\blue <B>Occupant ([]) Statistics:</B>", src.occupant)
		var/t1
		switch(src.occupant.stat)
			if(0.0)
				t1 = "Conscious"
			if(1.0)
				t1 = "Unconscious"
			if(2.0)
				t1 = "*dead*"
			else
		user << text("[]\t Health %: [] ([])", (src.occupant.health > 50 ? "\blue " : "\red "), src.occupant.health, t1)
		user << text("[]\t -Core Temperature: []&deg;C ([]&deg;F)</FONT><BR>", (src.occupant.bodytemperature > 50 ? "<font color='blue'>" : "<font color='red'>"), src.occupant.bodytemperature-T0C, src.occupant.bodytemperature*1.8-459.67)
		user << text("[]\t -Brute Damage %: []", (src.occupant.bruteloss < 60 ? "\blue " : "\red "), src.occupant.bruteloss)
		user << text("[]\t -Respiratory Damage %: []", (src.occupant.oxyloss < 60 ? "\blue " : "\red "), src.occupant.oxyloss)
		user << text("[]\t -Toxin Content %: []", (src.occupant.toxloss < 60 ? "\blue " : "\red "), src.occupant.toxloss)
		user << text("[]\t -Burn Severity %: []", (src.occupant.fireloss < 60 ? "\blue " : "\red "), src.occupant.fireloss)
		user << "\blue Expected time till occupant can safely awake: (note: If health is below 20% these times are inaccurate)"
		user << text("\blue \t [] second\s (if around 1 or 2 the sleeper is keeping them asleep.)", src.occupant.paralysis / 5)
	else
		user << "\blue There is no one inside!"
	return

/obj/machinery/sleeper/verb/eject()
	set name = "Eject Sleeper"
	set category = "Object"
	set src in oview(1)

	if (usr.stat != 0)
		return
	if(orient == "RIGHT")
		icon_state = "sleeper_0-r"
	src.icon_state = "sleeper_0"

	src.go_out()
	add_fingerprint(usr)

	occupied = 0
	return

/obj/machinery/sleeper/dummy/eject()
	set category = null
	set hidden = 1

	return

/obj/machinery/sleeper/verb/move_inside()
	set name = "Enter Sleeper"
	set category = "Object"
	set src in oview(1)

	if (usr.stat != 0)
		return
	if (occupied)
		usr << "\blue <B>The sleeper is already occupied!</B>"
		return
/*	if (usr.abiotic())									// Removing the requirement for user to be naked -- TLE
		usr << "Subject may not have abiotic items on."
		return*/
	for (var/mob/V in viewers(usr))
		occupied = 1
		V.show_message("[usr] starts climbing into the sleeper.", 3)
	if(do_after(usr, 20))
		if (occupied)
			usr << "\blue <B>The sleeper is already occupied!</B>"
			return
		else
			usr.pulling = null
			usr.client.perspective = EYE_PERSPECTIVE
			usr.client.eye = src
			usr.loc = src
//			usr.metabslow = 1
			src.occupant = usr
			src.icon_state = "sleeper_1"
			if(orient == "RIGHT")
				icon_state = "sleeper_1-r"

		for(var/obj/O in src)
			del(O)
		src.add_fingerprint(usr)
		return
	else
		occupied = 0
	return

/obj/machinery/sleeper/dummy/move_inside()
	set category = null
	set hidden = 1

	return