// Pretty much everything here is stolen from the dna scanner FYI


/obj/machinery/bodyscanner
	var/mob/living/carbon/occupant
	var/locked
	name = "Body scanner"
	icon = 'Cryogenic2.dmi'
	icon_state = "body_scanner_0"
	density = 1
	anchored = 1
	var/printing
/*/obj/machinery/bodyscanner/allow_drop()
	return 0*/

/obj/machinery/bodyscanner/relaymove(mob/user as mob)
	if (user.stat)
		return
	src.go_out()
	return

/obj/machinery/bodyscanner/verb/eject()
	set src in oview(1)

	if (usr.stat != 0)
		return
	src.go_out()
	add_fingerprint(usr)
	return

/obj/machinery/bodyscanner/verb/move_inside()
	set src in oview(1)

	if (usr.stat != 0)
		return
	if (src.occupant)
		usr << "\blue <B>The scanner is already occupied!</B>"
		return

	usr.pulling = null
	usr.client.perspective = EYE_PERSPECTIVE
	usr.client.eye = src
	src.icon_state = "body_scanner_open"
	sleep(11)
	usr.loc = src
	src.occupant = usr
	src.icon_state = "body_scanner_1"
	for(var/obj/O in src)
		//O = null
		del(O)
		//Foreach goto(124)
	src.add_fingerprint(usr)
	return

/obj/machinery/bodyscanner/proc/go_out()
	if ((!( src.occupant ) || src.locked))
		return
	for(var/obj/O in src)
		O.loc = src.loc
		//Foreach goto(30)
	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.occupant.loc = src.loc
	src.occupant = null
	src.icon_state = "body_scanner_0"
	return

/obj/machinery/bodyscanner/attackby(obj/item/weapon/grab/G as obj, user as mob)
	if ((!( istype(G, /obj/item/weapon/grab) ) || !( ismob(G.affecting) )))
		return
	if (src.occupant)
		user << "\blue <B>The scanner is already occupied!</B>"
		return
	var/mob/M = G.affecting
	if (M.client)
		M.client.perspective = EYE_PERSPECTIVE
		M.client.eye = src
	M.loc = src
	src.occupant = M
	src.icon_state = "body_scanner_1"
	for(var/obj/O in src)
		O.loc = src.loc
		//Foreach goto(154)
	src.add_fingerprint(user)
	//G = null
	del(G)
	return

/obj/machinery/bodyscanner/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.loc = src.loc
				ex_act(severity)
				//Foreach goto(35)
			//SN src = null
			del(src)
			return
		if(2.0)
			if (prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
					//Foreach goto(108)
				//SN src = null
				del(src)
				return
		if(3.0)
			if (prob(25))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
					//Foreach goto(181)
				//SN src = null
				del(src)
				return
		else
	return

/obj/machinery/bodyscanner/blob_act()
	if(prob(50))
		for(var/atom/movable/A as mob|obj in src)
			A.loc = src.loc
		del(src)

/obj/machinery/body_scanconsole/ex_act(severity)

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

/obj/machinery/body_scanconsole/blob_act()

	if(prob(50))
		del(src)

/obj/machinery/body_scanconsole/power_change()
	if(stat & BROKEN)
		icon_state = "body_scannerconsole-p"
	else if(powered())
		icon_state = initial(icon_state)
		stat &= ~NOPOWER
	else
		spawn(rand(0, 15))
			src.icon_state = "body_scannerconsole-p"
			stat |= NOPOWER

/obj/machinery/body_scanconsole
	var/obj/machinery/bodyscanner/connected
	var/delete
	var/temphtml
	name = "Advanced medical scanner console"
	icon = 'Cryogenic2.dmi'
	icon_state = "body_scannerconsole"
	density = 0
	anchored = 1
	var/printing
	var/results
	var/DNA
	var/list/Resistances = list()
	var/bloodtype
	var/list/tempchem
	var/list/temp_chem = list()
/
obj/machinery/body_scanconsole/New()
	..()
	spawn( 5 )
		src.connected = locate(/obj/machinery/bodyscanner, get_step(src, WEST))
		return


/obj/machinery/body_scanconsole/process() //not really used right now
	if(stat & (NOPOWER|BROKEN))
		return
	use_power(250) // power stuff

//	var/mob/M //occupant
//	if (!( src.status )) //remove this
//		return
//	if ((src.connected && src.connected.occupant)) //connected & occupant ok
//		M = src.connected.occupant
//	else
//		if (istype(M, /mob))
//		//do stuff
//		else
///			src.temphtml = "Process terminated due to lack of occupant in scanning chamber."
//			src.status = null
//	src.updateDialog()
//	return


/obj/machinery/body_scanconsole/attack_paw(user as mob)
	return src.attack_hand(user)

/obj/machinery/body_scanconsole/attack_ai(user as mob)
	return src.attack_hand(user)

/obj/machinery/body_scanconsole/attack_hand(mob/user as mob)
	if(..())
		return
	var/dat
	var/mob/occupant = src.connected.occupant
	if (istype(occupant,/mob/living/carbon/monkey))
		dat = "<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><font color='red'>This device can only scan human occupants.</FONT><BR>"
		user << browse(dat, "window=scannernew;size=550x625")
		return
	else if (!istype(occupant,/mob/living/carbon/human))
		dat = "<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><font color='red'>This device can only scan human occupants.</FONT><BR>"
		user << browse(dat, "window=scannernew;size=550x625")
	else
		return src.scan(src.connected.occupant, user)

/obj/machinery/body_scanconsole/proc/scan(mob/living/carbon/human/occupant as mob, mob/user as mob)
	var/dat
	var/shown = 0
	if (src.delete && src.temphtml) //Window in buffer but its just simple message, so nothing
		src.delete = src.delete
	else if (!src.delete && src.temphtml) //Window in buffer - its a menu, dont add clear message
		dat = text("[]<BR><BR><A href='?src=\ref[];clear=1'>Main Menu</A>", src.temphtml, src)
	else
		if (src.connected) //Is something connected?
			dat = "<font color='blue'><B>Occupant Statistics:</B></FONT><BR><br>" //Blah obvious
			if (occupant) //is there REALLY someone in there?
				if (!istype(occupant,/mob/living/carbon/human))
					sleep(1)
				DNA = copytext(occupant.dna.unique_enzymes,1,0)
				bloodtype = copytext(occupant.b_type,1,0)
				dat += "<B>Name:</B> [occupant.real_name]<BR>"
				dat += "<B>Age:</B> [occupant.age]<BR>"
				dat += "<B>Gender:</B> [occupant.gender == "male" ? "Male" : "Female"]<BR>"
				dat += "<B>DNA</B>: [DNA]<BR>"
				dat += "<B>Health:</B> [occupant.stat > 1 ? "<font color=\"red\">Dead</Font>" : "[occupant.health]% healthy"]<BR>"
				if(occupant.eye_blind || occupant.ear_deaf)
					dat += "<B>Sensory Organs:</B> [occupant.eye_blind ? "Blind, " : ""] [occupant.ear_deaf ? "Deaf" : ""]<BR>"
				else if(!occupant.eye_blind || !occupant.ear_deaf)
					dat += "<B>Sensory Organs: </B> Normal<BR>"
				dat += "<B>Radiation Level:</B> [occupant.radiation < 1 ? "none" : "<font color='red'>[occupant.radiation]</font>"]<BR>"
				dat += "<B>Brain Damage:</B> [occupant.brainloss < 1 ? "none" : "<font color='red'>[occupant.brainloss]</font>"]<BR>"

//				var/bloodloss = abs(occupant.blood - 300)
				dat += "<B>Blood Type:</B> [bloodtype]<BR>"
//				dat += "<B>Blood Loss:</B> [bloodloss < 1 ? "none" : "<font color='red'>[bloodloss] </font>"]<BR>"
				dat += "<B>Blood Pressure:</B> [occupant.systolic]/[occupant.diastolic] <BR>"
				dat += "<B>Heart Rate:</B> [occupant.heartrate]bpm<BR>"
				if(occupant.r_armbloodloss == 1)
					dat += "<B>Overall Bleeding:</B><font color=\"red\"> Light bleeding detected<BR></FONT>"
				if(occupant.r_armbloodloss == 2)
					dat += "<B>Overall Bleeding:</B><font color=\"red\"> Heavy bleeding detected<BR></FONT>"
				if(occupant.r_armbloodloss == 3)
					dat += "<B>Overall Bleeding:</B><font color=\"red\"> WARNING! Extreme bleeding detected<BR></FONT>"


				dat += "<B>Suffocation Damage:</B> [occupant.oxyloss < 1 ? "none" : "<font color='red'>[occupant.oxyloss]</font>"]<BR>"
				dat += "<B>Toxin Poisoning:</B> [occupant.toxloss < 1 ? "none" : "<font color='red'>[occupant.toxloss]</font>"]<BR>"
				dat += "<B>Genetic Damage Overall:</B> [occupant.cloneloss < 1 ? "none" : "<font color='red'>[occupant.cloneloss]</font>"]<BR>"
				dat += "<B>Burn Damage Overall:</B> [occupant.fireloss < 1 ? "none" : "<font color='red'>[occupant.fireloss]</font>"]<BR>"
				dat += "<B>Brute Damage Overall:</B> [occupant.bruteloss < 1 ? "none" : "<font color='red'>[occupant.bruteloss]</font>"]<BR>"
				dat += "<B>Body Temperature:</B>[occupant.bodytemperature-T0C]*C ([occupant.bodytemperature*1.8-459.67]*F)<BR>"
/*		for(var/datum/reagent/Reagents in occupant.reagents.reagent_list)
					temp_chem += Reagents.name
					temp_chem[Reagents.name] = Reagents.volume
					tempchem = list2params(temp_chem)
					for(var/C in tempchem)
						if(tempchem)
							dat += "<B>Trace Chemicals:</B> [C] ([tempchem[C]] units) "
						if(!tempchem)
							dat += "<B>Trace Chemicals:</B> None detected."*/
	//			for(var/datum/disease/addiction/D in occupant.ailment)
	//				if(occupant.ailment)
	//					dat += "<font color=\"red\"><b>Signs of chemical abuse detected, potential addiction to [D:addicted_to]<BR>"
	//			if(occupant.arrhythmia)
	//				dat += "\red Danger arrhythmia detected.<BR>"

	//			if(occupant.thrombosis)
	//				dat += "\red Danger thrombosis detected"

	/*				switch(occupant.thrombosis_severity)
						if(1)
							dat += ", (low severity)<BR>"
						if(2)
							dat += ", (medium severity)<BR>"
						if(3)
							dat += ", (high severity)<BR>"
						else
							dat += ".<br>"

				for(var/datum/disease/D in occupant.resistances)
					if(D.name)
						Resistances += D.name
						dat += "<B>Viral Resistances:</B> [Resistances]<BR>"
				for(var/datum/disease/D in occupant.viruses)
					if(occupant.viruses)
						dat += "<font color=\"red\"><b>Virus Detected</b></font><br/><b>Name:</b> [D.name]<br/><b>Type:</b> [D.spread]<br/><b>Stage:</b> [D.stage]/[D.max_stages]<br/><b>Possible Cure:</b> [D.cure]<br/><br/>"
*/
				dat += "<BR>"
				dat += "<B>Specific Body Part Details:</B><BR>"
				if(!shown)
					var/head = occupant:organs["head"]
					var/chest = occupant:organs["chest"]

					var/r_arm = occupant:organs["r_arm"]
					var/l_arm = occupant:organs["l_arm"]
					var/r_hand = occupant:organs["r_hand"]
					var/l_hand = occupant:organs["l_hand"]

					var/groin = occupant:organs["groin"]

					var/r_leg = occupant:organs["r_leg"]
					var/l_leg = occupant:organs["l_leg"]
					var/r_foot = occupant:organs["r_foot"]
					var/l_foot = occupant:organs["l_foot"]

					if (occupant.organ_manager.head < 1 || head:brute_dam || head:burn_dam)
						if(occupant.organ_manager.head > 0)
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<B>Head<B><BR>"
						else
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;<B>Head Missing<B><BR>"
						if(head:brute_dam)
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Brute damage: [head:brute_dam]%<BR></FONT>"
						if(head:burn_dam)
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Burn damage: [head:burn_dam]%<BR></FONT>"
						if(occupant.headbloodloss)
							if(occupant.headbloodloss == 1)
								dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Light bleeding detected<BR></FONT>"
							if(occupant.headbloodloss == 2)
								dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Heavy bleeding detected<BR></FONT>"
							if(occupant.headbloodloss == 3)
								dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	WARNING! Extreme bleeding detected<BR></FONT>"

					if (chest:brute_dam || chest:burn_dam)
						dat += "&nbsp;&nbsp;&nbsp;&nbsp;<B>Chest<B><BR>"
						if(chest:brute_dam)
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Brute damage: [chest:brute_dam]%<BR></FONT>"
						if(chest:burn_dam)
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Burn damage: [chest:burn_dam]%<BR></FONT>"



					if (occupant.organ_manager.r_arm < 1 || r_arm:brute_dam || r_arm:burn_dam)
						if(occupant.organ_manager.r_arm > 0)
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;<B>Right Arm<B><BR>"
						else
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;<B>Right Arm Missing<B><BR>"
						if(r_arm:brute_dam)
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Brute damage: [r_arm:brute_dam]%<BR></FONT>"
						if(r_arm:burn_dam)
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Burn damage: [r_arm:burn_dam]%<BR></FONT>"
						if(occupant.r_armbloodloss)
							if(occupant.r_armbloodloss == 1)
								dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Light bleeding detected<BR></FONT>"
							if(occupant.r_armbloodloss == 2)
								dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Heavy bleeding detected<BR></FONT>"
							if(occupant.r_armbloodloss == 3)
								dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	WARNING! Extreme bleeding detected<BR></FONT>"



					if (occupant.organ_manager.l_arm < 1 || l_arm:brute_dam || l_arm:burn_dam)
						if(occupant.organ_manager.l_arm > 0)
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;<B>Left Arm<B><BR>"
						else
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;<B>Left Arm Missing<B><BR>"
						if(l_arm:brute_dam)
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Brute damage: [l_arm:brute_dam]%<BR></FONT>"
						if(l_arm:burn_dam)
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Burn damage: [l_arm:burn_dam]%<BR></FONT>"
						if(occupant.r_armbloodloss)
							if(occupant.l_armbloodloss == 1)
								dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Light bleeding detected<BR></FONT>"
							if(occupant.l_armbloodloss == 2)
								dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Heavy bleeding detected<BR></FONT>"
							if(occupant.l_armbloodloss == 3)
								dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	WARNING! Extreme bleeding detected<BR></FONT>"



					if (occupant.organ_manager.r_hand < 1 || r_hand:brute_dam || r_hand:burn_dam)
						if(occupant.organ_manager.r_hand > 0)
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;<B>Right Hand<B><BR>"
						else
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;<B>Right Hand Missing<B><BR>"
						if(r_hand:brute_dam)
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Brute damage: [r_hand:brute_dam]%<BR></FONT>"
						if(r_hand:burn_dam)
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Burn damage: [r_hand:burn_dam]%<BR></FONT>"
						if(occupant.r_handbloodloss)
							if(occupant.r_handbloodloss == 1)
								dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Light bleeding detected<BR></FONT>"
							if(occupant.r_handbloodloss == 2)
								dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Heavy bleeding detected<BR></FONT>"
							if(occupant.r_handbloodloss == 3)
								dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	WARNING! Extreme bleeding detected<BR></FONT>"

					if (occupant.organ_manager.l_hand < 1 || l_hand:brute_dam || l_hand:burn_dam)
						if(occupant.organ_manager.l_hand > 0)
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;<B>Left Hand<B><BR>"
						else
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;<B>Left Hand Missing<B><BR>"
						if(l_hand:brute_dam)
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Brute damage: [l_hand:brute_dam]%<BR></FONT>"
						if(l_hand:burn_dam)
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Burn damage: [l_hand:burn_dam]%<BR></FONT>"
						if(occupant.l_handbloodloss)
							if(occupant.l_handbloodloss == 1)
								dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Light bleeding detected<BR></FONT>"
							if(occupant.l_handbloodloss == 2)
								dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Heavy bleeding detected<BR></FONT>"
							if(occupant.l_handbloodloss == 3)
								dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	WARNING! Extreme bleeding detected<BR></FONT>"


					if (groin:brute_dam || groin:burn_dam)
						dat += "&nbsp;&nbsp;&nbsp;&nbsp;<B>Groin<B><BR>"
						if(groin:brute_dam)
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Brute damage: [groin:brute_dam]%<BR></FONT>"
						if(groin:burn_dam)
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Burn damage: [groin:burn_dam]%<BR></FONT>"



					if (occupant.organ_manager.r_leg < 1 || r_leg:brute_dam || r_leg:burn_dam)
						if(occupant.organ_manager.r_leg > 0)
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;<B>Right Leg<B><BR>"
						else
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;<B>Right Leg Missing<B><BR>"
						if(r_leg:brute_dam)
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Brute damage to right leg: [r_leg:brute_dam]%<BR></FONT>"
						if(r_leg:burn_dam)
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Burn damage to right leg: [r_leg:burn_dam]%<BR></FONT>"
						if(occupant.r_legbloodloss)
							if(occupant.r_legbloodloss == 1)
								dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Light bleeding detected<BR></FONT>"
							if(occupant.r_legbloodloss == 2)
								dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Heavy bleeding detected<BR></FONT>"
							if(occupant.r_legbloodloss == 3)
								dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	WARNING! Extreme bleeding detected<BR></FONT>"

					if (occupant.organ_manager.l_leg < 1 || l_leg:brute_dam || l_leg:burn_dam)
						if(occupant.organ_manager.l_leg > 0)
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;<B>Left Leg<B><BR>"
						else
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;<B>Left Leg Missing<B><BR>"
						if(l_leg:brute_dam)
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Brute damage to left leg: [l_leg:brute_dam]%<BR></FONT>"
						if(l_leg:burn_dam)
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Burn damage to left leg: [l_leg:burn_dam]%<BR></FONT>"
						if(occupant.l_legbloodloss)
							if(occupant.l_legbloodloss == 1)
								dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Light bleeding detected<BR></FONT>"
							if(occupant.l_legbloodloss == 2)
								dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Heavy bleeding detected<BR></FONT>"
							if(occupant.l_legbloodloss == 3)
								dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	WARNING! Extreme bleeding detected<BR></FONT>"


					if (occupant.organ_manager.r_foot < 1 || r_foot:brute_dam || r_foot:burn_dam)
						if(occupant.organ_manager.r_foot > 0)
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;<B>Right Foot<B><BR>"
						else
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;<B>Right Foot Missing<B><BR>"
						if(r_foot:brute_dam)
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Brute damage to right foot: [r_foot:brute_dam]%<BR></FONT>"
						if(r_foot:burn_dam)
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Burn damage to right foot: [r_foot:burn_dam]%<BR></FONT>"
						if(occupant.r_footbloodloss)
							if(occupant:r_footbloodloss == 1)
								dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Light bleeding detected<BR></FONT>"
							if(occupant:r_footbloodloss == 2)
								dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Heavy bleeding detected<BR></FONT>"
							if(occupant:r_footbloodloss == 3)
								dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	WARNING! Extreme bleeding detected<BR></FONT>"



					if (occupant.organ_manager.l_foot < 1 || l_foot:brute_dam || l_foot:burn_dam)
						if(occupant.organ_manager.l_foot > 0)
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;<B>Left Foot<B><BR>"
						else
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;<B>Left Foot Missing<B><BR>"
						if(l_foot:brute_dam)
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Brute damage to left foot: [l_foot:brute_dam]%<BR></FONT>"
						if(l_foot:burn_dam)
							dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Burn damage to left foot: [l_foot:burn_dam]%<BR></FONT>"
						if(occupant:l_footbloodloss)
							if(occupant:l_footbloodloss == 1)
								dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Light bleeding detected<BR></FONT>"
							if(occupant:l_footbloodloss == 2)
								dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	Heavy bleeding detected<BR></FONT>"
							if(occupant:l_footbloodloss == 3)
								dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"red\">	WARNING! Extreme bleeding detected<BR></FONT>"

				dat += {"<br><A href='?src=\ref[src];rf=1'>Refresh</A><BR>"}
				shown++
		else
			dat = "<font color='red'> Error: No Scanner connected. </FONT>"
	user << browse(dat, "window=scannernew;size=550x625")
	shown--
	return

/obj/machinery/body_scanconsole/Topic(href, href_list)
	if(..())
		return
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.machine = src
		if (href_list["rf"])
			src.updateDialog()
		if (href_list["Print"])
			if (!( printing ))
				printing = 1
				sleep(50)
				if (src.connected)
					var/obj/item/weapon/paper/P = new /obj/item/weapon/paper( loc )
					P.info = "Test Results"
					P.name = "paper- 'Scan Results'"
					printing = null


		/*			for(var/datum/organ/external/e in occupant.GetOrgans())
					dat += "<tr>"
					var/AN = ""
					var/open = ""
					var/infected = ""
					var/imp = ""
					var/bled = ""
					if(e.wounds.len >= 1)
						bled = "Bleeding:"
					if(e.broken)
						AN = "[e.wound]:"
					if(e.open)
						open = "OPEN:"
					if(!e.clean)
						infected = "UNCLEAN:"
					if(e.split)
						e.split = ":SPLT"
					if(e.implant)
						imp = "IMPLANT:"
					if(!AN && !open && !infected & !imp)
						AN = "None"
					dat += "<td>[e.display_name]</td><td>[e.burn_dam]</td><td>[e.brute_dam]</td><td>[bled][AN][open][infected][imp]</font></td>"
					//dat += text("<td><font color='red'>[e.display_name]</td><td>BRN:[e.burn_dam]</td><td>BRT:[e.brute_dam]</td><td>[AN][open][infected][imp]</font></td>")
	*/