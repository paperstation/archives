
/*
CONTAINS:
T-RAY
DETECTIVE SCANNER
HEALTH ANALYZER
GAS ANALYZER
PLANT ANALYZER
MASS SPECTROMETER

*/

/obj/item/device/t_scanner/attack_self(mob/user)

	on = !on
	icon_state = "t-ray[on]"

	if(on)
		processing_items.Add(src)


/obj/item/device/t_scanner/process()
	if(!on)
		processing_items.Remove(src)
		return null

	for(var/turf/T in range(1, src.loc) )

		if(!T.intact)
			continue

		for(var/obj/O in T.contents)

			if(O.level != 1)
				continue

			if(O.invisibility == 101)
				O.invisibility = 0
				spawn(10)
					if(O)
						var/turf/U = O.loc
						if(U.intact)
							O.invisibility = 101

		var/mob/living/M = locate() in T
		if(M && M.invisibility == 2)
			M.invisibility = 0
			spawn(2)
				if(M)
					M.invisibility = 2

/obj/item/device/detective_scanner/attackby(obj/item/weapon/f_card/W as obj, mob/user as mob)
	..()

	if (istype(W, /obj/item/weapon/f_card))
		if (W.fingerprints)
			return
		if (src.amount == 20)
			return
		if (W.amount + src.amount > 20)
			src.amount = 20
			W.amount = W.amount + src.amount - 20
		else
			src.amount += W.amount
			//W = null
			del(W)
		src.add_fingerprint(user)
		if (W)
			W.add_fingerprint(user)
	return

/obj/item/device/detective_scanner/attack_self(mob/user as mob)

	src.printing = !( src.printing )
	if(src.printing)
		user << "\blue Printing turned on"
	else
		user << "\blue Printing turned off"
	src.icon_state = text("forensic[]", src.printing)
	add_fingerprint(user)
	return

/obj/item/device/detective_scanner/attack(mob/living/carbon/human/M as mob, mob/user as mob)

	if (!istype(M))
		user << "\red [M] is not humas and cannot have the fingerprints."
	if (( !( istype(M.dna, /datum/dna) ) || M.gloves) )
		user << "\blue No fingerprints found on [M]"
	else
		if ((src.amount < 1 && src.printing))
			user << text("\blue Fingerprints scanned on [M]. Need more cards to print.")
			src.printing = 0
		src.icon_state = text("forensic[]", src.printing)
		if (src.printing)
			src.amount--
			var/obj/item/weapon/f_card/F = new /obj/item/weapon/f_card( user.loc )
			F.amount = 1
			F.fingerprints = md5(M.dna.uni_identity)
			F.icon_state = "fingerprint1"
			F.name = text("FPrintC- '[M.name]'")
			user << "\blue Done printing."
		user << text("\blue [M]'s Fingerprints: [md5(M.dna.uni_identity)]")
	if ( !(M.blood_DNA) )
		user << "\blue No blood found on [M]"
	else
		user << "\blue Blood found on [M]. Analysing..."
		spawn(15)
			user << "\blue Blood type: [M.blood_type]\nDNA: [M.blood_DNA]"
	return

/obj/item/device/detective_scanner/afterattack(atom/A as mob|obj|turf|area, mob/user as mob)

	src.add_fingerprint(user)
	if (istype(A, /obj/decal/cleanable/blood) || istype(A, /obj/rune))
		if(A.blood_DNA)
			user << "\blue Blood type: [A.blood_type]\nDNA: [A.blood_DNA]"
	else if (A.blood_DNA)
		user << "\blue Blood found on [A]. Analysing..."
		sleep(15)
		user << "\blue Blood type: [A.blood_type]\nDNA: [A.blood_DNA]"
	else
		user << "\blue No blood found on [A]."
	if (!( A.fingerprints ))
		user << "\blue Unable to locate any fingerprints on [A]!"
		return 0
	else
		if ((src.amount < 1 && src.printing))
			user << "\blue Fingerprints found. Need more cards to print."
			src.printing = 0
	src.icon_state = text("forensic[]", src.printing)
	if (src.printing)
		src.amount--
		var/obj/item/weapon/f_card/F = new /obj/item/weapon/f_card( user.loc )
		F.amount = 1
		F.fingerprints = A.fingerprints
		F.icon_state = "fingerprint1"
		user << "\blue Done printing."
	var/list/L = params2list(A.fingerprints)
	user << text("\blue Isolated [L.len] fingerprints.")
	for(var/i in L)
		user << text("\blue \t [i]")
		//Foreach goto(186)
	return

/obj/item/device/healthanalyzer/attack(mob/M as mob, mob/user as mob)
	if ((user.mutations & CLOWN || user.brainloss >= 60) && prob(50))
		user << text("\red You try to analyze the floor's vitals!")
		for(var/mob/O in viewers(M, null))
			O.show_message(text("\red [user] has analyzed the floor's vitals!"), 1)
		user.show_message(text("\blue Analyzing Results for The floor:\n\t Overall Status: Healthy"), 1)
		user.show_message(text("\blue \t Damage Specifics: [0]-[0]-[0]-[0]"), 1)
		user.show_message("\blue Key: Suffocation/Toxin/Burns/Brute", 1)
		user.show_message("\blue Body Temperature: ???", 1)
		return
	if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return
	for(var/mob/O in viewers(M, null))
		O.show_message(text("\red [] has analyzed []'s vitals!", user, M), 1)
		//Foreach goto(67)

	var/dat = "<meta HTTP-EQUIV='REFRESH' content='0; url="
	dat += "http://vps.d2k5.com/d2station/medscanner/?name=[M.real_name]"
	dat += "&health=[M.stat > 1 ? "dead" : "[M.health]% healthy"]"
	dat += "&bloodlevel=[M.blood]"
	dat += "&suffocation=[M.oxyloss]"
	dat += "&toxin=[M.toxloss]"
	dat += "&burn=[M.fireloss ]"
	dat += "&brute=[M.bruteloss]"
	dat += "&btemp=[M.bodytemperature-T0C]*C ([M.bodytemperature*1.8-459.67]*F)"


	/////////////////////////////////////////////////////////
	//START LIMB CODE
	if (istype(M, /mob/living/carbon/human))
		var/head = M:organs["head"]
		var/chest = M:organs["chest"]

		var/r_arm = M:organs["r_arm"]
		var/l_arm = M:organs["l_arm"]
		var/r_hand = M:organs["r_hand"]
		var/l_hand = M:organs["l_hand"]

		var/groin = M:organs["groin"]

		var/r_leg = M:organs["r_leg"]
		var/l_leg = M:organs["l_leg"]
		var/r_foot = M:organs["r_foot"]
		var/l_foot = M:organs["l_foot"]

		dat += "&organs="

		if((M.headbloodloss) || (head:brute_dam) || (head:burn_dam))
			//dat += "&headbrute=1"
			dat += "HEb-"

		if((chest:brute_dam) || (chest:burn_dam))
			//dat += "&torsobrute=1"
			dat += "CHb-"


		if(!M:r_arm_op_stage)
			dat += "RAl-"
		else if((M.r_armbloodloss) || (r_arm:brute_dam) || (r_arm:burn_dam))
			//dat += "&r_armbrute=1"
			dat += "RAb-"

		if(!M:l_arm_op_stage)
			dat += "LAl-"
		else if((M.l_armbloodloss) || (l_arm:brute_dam) || (l_arm:burn_dam))
			//dat += "&l_armbrute=1"
			dat += "LAb-"



		if(!M:r_arm_op_stage)
			dat += "RHl-"
		else if((M.r_handbloodloss) || (r_hand:brute_dam) || (r_hand:burn_dam))
			//dat += "&r_handbrute=1"
			dat += "RHb-"

		if(!M:l_arm_op_stage)
			dat += "LHl-"
		else if((M.l_handbloodloss) || (l_hand:brute_dam) || (l_hand:burn_dam))
			//dat += "&l_handbrute=1"
			dat += "LHb-"



		if((groin:brute_dam) || (groin:burn_dam))
			//dat += "&crotchbrute=1"
			dat += "GRb-"



		if(!M:r_leg_op_stage)
			dat += "RLl-"
		else if((M.r_legbloodloss) || (r_leg:brute_dam) || (r_leg:burn_dam))
			//dat += "&r_legbrute=1"
			dat += "RLb-"

		if(!M:l_leg_op_stage)
			dat += "LLl-"
		else if((M.l_legbloodloss) || (l_leg:brute_dam) || (l_leg:burn_dam))
			//dat += "&l_legbrute=1"
			dat += "LLb-"



		if(!M:r_leg_op_stage)
			dat += "RFl-"
		else if((M.r_footbloodloss) || (r_foot:brute_dam) || (r_foot:burn_dam))
			//dat += "&r_footbrute=1"
			dat += "RFb-"

		if(!M:l_leg_op_stage)
			dat += "LFl-"
		else if((M.l_footbloodloss) || (l_foot:brute_dam) || (l_foot:burn_dam))
			//dat += "&l_footbrute=1"
			dat += "LFb-"

		dat += "END"
	else
		dat += "&extrainfo=Unable to scan damage specifics for this species."
		dat += "&no_body"
	//END LIMB CODE
	/////////////////////////////////////////////////////////

	dat += "&virus="
	for(var/datum/disease/D in M.viruses)
		if(!D.hidden[SCANNER])
			dat += "<font color=\"red\"><b>Virus Detected</b></font><br/>"

	dat += "'>Scanning..."
	usr << browse("[dat]","window=healthscan;size=510x245")
	onclose(usr, "healthscan")

	src.add_fingerprint(user)
	return
/obj/item/device/healthanalyzer/tricorder/attack(mob/M as mob, mob/user as mob)
	dat = null
	if ((user.mutations & CLOWN || user.brainloss >= 60) && prob(50))
		user << text("\red You try to analyze the floor's vitals!")
		for(var/mob/O in viewers(M, null))
			O.show_message(text("\red [user] has analyzed the floor's vitals!"), 1)
		user.show_message(text("\blue Analyzing Results for The floor:\n\t Overall Status: Healthy"), 1)
		user.show_message(text("\blue \t Damage Specifics: [0]-[0]-[0]-[0]"), 1)
		user.show_message("\blue Key: Suffocation/Toxin/Burns/Brute", 1)
		user.show_message("\blue Body Temperature: ???", 1)
		return
	if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return
	for(var/mob/O in viewers(M, null))
		O.show_message(text("\red [] has analyzed []'s vitals!", user, M), 1)
		//Foreach goto(67)
	if(!istype(M, /mob/living/carbon/human))
		var/dat = "<meta HTTP-EQUIV='REFRESH' content='0; url="
		dat += "http://vps.d2k5.com/d2station/medscanner/?name=[M.real_name]"
		dat += "&health=[M.stat > 1 ? "dead" : "[M.health]% healthy"]"
		dat += "&bloodlevel=[M.blood]"
		dat += "&suffocation=[M.oxyloss]"
		dat += "&toxin=[M.toxloss]"
		dat += "&burn=[M.fireloss ]"
		dat += "&brute=[M.bruteloss]"
		dat += "&btemp=[M.bodytemperature-T0C]*C ([M.bodytemperature*1.8-459.67]*F)"
	else
		var/mob/living/carbon/human/occupant = M

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
	/*	for(var/datum/disease/addiction/D in occupant.ailment)
			if(occupant.ailment)
				dat += "<font color=\"red\"><b>Signs of chemical abuse detected, potential addiction to [D:addicted_to]<BR>"
		if(occupant.arrhythmia)
			dat += "\red Danger arrhythmia detected.<BR>"

		if(occupant.thrombosis)
			dat += "\red Danger thrombosis detected"

			switch(occupant.thrombosis_severity)
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

	usr << browse("[dat]","window=healthscan;size=510x720")
	onclose(usr, "healthscan")

	src.add_fingerprint(user)
	return

/obj/item/device/analyzer/attack_self(mob/user as mob)

	if (user.stat)
		return
	if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return

	var/turf/location = user.loc
	if (!( istype(location, /turf) ))
		return

	var/datum/gas_mixture/environment = location.return_air()

	var/pressure = environment.return_pressure()
	var/total_moles = environment.total_moles()
	if(total_moles)
		var/o2_concentration = environment.oxygen/total_moles
		var/n2_concentration = environment.nitrogen/total_moles
		var/co2_concentration = environment.carbon_dioxide/total_moles
		var/plasma_concentration = environment.toxins/total_moles

		var/unknown_concentration =  1-(o2_concentration+n2_concentration+co2_concentration+plasma_concentration)
		/*if(abs(n2_concentration - N2STANDARD) < 20)
			user.show_message("\blue Nitrogen: [round(n2_concentration*100)]%", 1)
		else
			user.show_message("\red Nitrogen: [round(n2_concentration*100)]%", 1)

		if(abs(o2_concentration - O2STANDARD) < 2)
			user.show_message("\blue Oxygen: [round(o2_concentration*100)]%", 1)
		else
			user.show_message("\red Oxygen: [round(o2_concentration*100)]%", 1)

		if(co2_concentration > 0.01)
			user.show_message("\red CO2: [round(co2_concentration*100)]%", 1)
		else
			user.show_message("\blue CO2: [round(co2_concentration*100)]%", 1)

		if(plasma_concentration > 0.01)
			user.show_message("\red Plasma: [round(plasma_concentration*100)]%", 1)

		if(unknown_concentration > 0.01)
			user.show_message("\red Unknown: [round(unknown_concentration*100)]%", 1)

		user.show_message("\blue Temperature: [round(environment.temperature-T0C)]&deg;C", 1)*/
		var/dat = "<meta HTTP-EQUIV='REFRESH' content='0; url="
		dat += "http://vps.d2k5.com/d2station/atmosscanner/?"
		//dat += "http://informatica.bc-enschede.nl/jhaas/atmos.php?"
		dat += "pres=[round(pressure,0.1)]"
		if(n2_concentration > 0.01)
			dat += "&n2=[round(n2_concentration,0.001)]"
		if(o2_concentration > 0.01)
			dat += "&o2=[round(o2_concentration,0.001)]"
		if(co2_concentration > 0.01)
			dat += "&co2=[round(co2_concentration,0.001)]"
		if(plasma_concentration > 0.01)
			dat += "&tox=[round(plasma_concentration,0.001)]"
		if(unknown_concentration > 0.01)
			dat += "&misc=[round(unknown_concentration,0.001)]"
		dat += "&temp=[round(environment.temperature)]"
		dat += "'>Analyzing..."
		usr << browse("[dat]","window=scanatmos;size=510x300")
		onclose(usr, "scanatmos")


	src.add_fingerprint(user)
	return

/obj/item/device/rd_analyzer/proc/ConvertReqString2List(var/list/source_list)
	var/list/temp_list = params2list(source_list)
	for(var/O in temp_list)
		temp_list[O] = text2num(temp_list[O])
	return temp_list

/obj/item/device/rd_analyzer/proc/CallTechName(var/ID)
	var/datum/tech/check_tech
	var/return_name = null
	for(var/T in typesof(/datum/tech) - /datum/tech)
		check_tech = null
		check_tech = new T()
		if(check_tech.id == ID)
			return_name = check_tech.name
			del(check_tech)
			check_tech = null
			break
	return return_name

/obj/item/device/rd_analyzer/afterattack(atom/A as mob|obj|turf|area, mob/user as mob)
	if(istype(A, /obj/))
		if(hasvar(A, origin_tech))
			var/list/techs = ConvertReqString2List(A:origin_tech)
			if (techs.len == 0 || !A:origin_tech)
				user << "\red This object is not compatible with the scanner!"
				return
			for(var/T in techs)
				user << "\blue [CallTechName(T)]-[techs[T]]"
	return

/obj/item/device/mass_spectrometer/New()
	..()
	var/datum/reagents/R = new/datum/reagents(5)
	reagents = R
	R.my_atom = src

/obj/item/device/mass_spectrometer/on_reagent_change()
	if(reagents.total_volume)
		icon_state = initial(icon_state) + "_s"
	else
		icon_state = initial(icon_state)

/obj/item/device/mass_spectrometer/attack_self(mob/user as mob)
	if (user.stat)
		return
	if (crit_fail)
		user << "\red This device has critically failed and is no longer functional!"
		return
	if (!(istype(user, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		user << "\red You don't have the dexterity to do this!"
		return
	if(reagents.total_volume)
		var/list/blood_traces = list()
		for(var/datum/reagent/R in reagents.reagent_list)
			if(R.id != "blood")
				reagents.clear_reagents()
				user << "\red The sample was contaminated! Please insert another sample"
				return
			else
				blood_traces = params2list(R.data["trace_chem"])
				break
		var/dat = "Trace Chemicals Found: "
		for(var/R in blood_traces)
			if(prob(reliability))
				if(details)
					dat += "[R] ([blood_traces[R]] units) "
				else
					dat += "[R] "
				recent_fail = 0
			else
				if(recent_fail)
					crit_fail = 1
					reagents.clear_reagents()
					return
				else
					recent_fail = 1
		user << "[dat]"
		reagents.clear_reagents()
	return

