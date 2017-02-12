//tricorder

/obj/item/device/Tricorder/attack(mob/M as mob, mob/user as mob)
	if ((user.mutations & 16 || user.brainloss >= 60) && prob(50))
		usr << "\red You look at the flashing control panel!"
		return

	if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return
	for(var/mob/O in viewers(M, null))
		O.show_message(text("\red [] has scanned []'s vitals!", user, M), 1)
		//Foreach goto(67)
	var/fake_oxy = max(rand(1,40), M.oxyloss, (300 - (M.toxloss + M.fireloss + M.bruteloss)))
	if(M.changeling_fakedeath || M.reagents.has_reagent("zombiepowder"))
		user.show_message(text("\green Analyzing Results for []:\n\t <BR>Overall Status: []", M, "dead"), 1)
		user.show_message(text("\blue \t <BR>Damage Specifics: <BR>Suffocation = []<BR>Toxin =[]<BR>Burn = []<BR>Brute = []", fake_oxy < 50 ? "\red [fake_oxy]" : fake_oxy , M.toxloss > 50 ? "\red [M.toxloss]" : M.toxloss, M.fireloss > 50 ? "\red[M.fireloss]" : M.fireloss, M.bruteloss > 50 ? "\red[M.bruteloss]" : M.bruteloss), 1)
	else
		user.show_message(text("\blue Analyzing Results for []:\n\t <BR>Overall Status: []", M, (M.stat > 1 ? "dead" : text("[]% healthy", M.health))), 1)
		user.show_message(text("\blue \t <BR>Damage Specifics: <BR>Suffocation = []<BR>Toxin =[]<BR>Burn = []<BR>Brute = []", M.oxyloss > 50 ? "\red [M.oxyloss]" : M.oxyloss, M.toxloss > 50 ? "\red [M.toxloss]" : M.toxloss, M.fireloss > 50 ? "\red[M.fireloss]" : M.fireloss, M.bruteloss > 50 ? "\red[M.bruteloss]" : M.bruteloss), 1)
		user.show_message("\blue Body Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)", 1)
	if(M.changeling_fakedeath || M.reagents.has_reagent("zombiepowder"))
		user.show_message(text("\blue [] | [] | [] | []", fake_oxy > 50 ? "\red Severe oxygen deprivation detected\blue" : "Subject bloodstream oxygen level normal", M.toxloss > 50 ? "\red Dangerous amount of toxins detected\blue" : "Subject bloodstream toxin level minimal", M.fireloss > 50 ? "\red Severe burn damage detected\blue" : "Subject burn injury status O.K", M.bruteloss > 50 ? "\red Severe anatomical damage detected\blue" : "Subject brute-force injury status O.K"), 1)
	else
		user.show_message(text("\blue [] | [] | [] | []", M.oxyloss > 50 ? "\red Severe oxygen deprivation detected\blue" : "Subject bloodstream oxygen level normal", M.toxloss > 50 ? "\red Dangerous amount of toxins detected\blue" : "Subject bloodstream toxin level minimal", M.fireloss > 50 ? "\red Severe burn damage detected\blue" : "Subject burn injury status O.K", M.bruteloss > 50 ? "\red Severe anatomical damage detected\blue" : "Subject brute-force injury status O.K"), 1)
	if (M.virus)
		user.show_message(text("\red <b>Warning: Virus Detected.</b>\nName: [M.virus.name].\nType: [M.virus.spread].\nStage: [M.virus.stage]/[M.virus.max_stages].\nPossible Cure: [M.virus.cure]"))
//	if (M.reagents:get_reagent_amount("inaprovaline"))
//		reagentsinhuman += "Inaprovaline"
//	if (M.reagents:get_reagent_amount("anti_toxin"))
//		reagentsinhuman += "Dylovene"
//	user.show_message(text("\blue Bloodstream Analysis located...... [reagentsinhuman] contained in body."), 1)
	if (M.brainloss >= 100 || istype(M, /mob/living/carbon/human) && M:brain_op_stage == 4.0)
		user.show_message(text("\red Subject is brain dead."), 1)
	else if (M.brainloss >= 60)
		user.show_message(text("\red Severe brain damage detected. Subject likely to have mental retardation."), 1)
	else if (M.brainloss >= 10)
		user.show_message(text("\red Significant brain damage detected. Subject may have had a concussion."), 1)
	sleep(20)


	src.add_fingerprint(user)
	return

/obj/item/device/Tricorder/afterattack(atom/A as mob|obj|turf|area, mob/user as mob)

	src.add_fingerprint(user)
	sleep(10)
	if (istype(A, /obj/decal/cleanable/blood) || istype(A, /obj/rune))
		if(A.blood_DNA)
			user << "\red<B>Blood type:</B> [A.blood_type]<BR><B>\nDNA:</B> [A.blood_DNA]"
		if(A:virus)
			user << "\red Warning, virus found in the blood!<BR><B>Name:</B> [A:virus.name]"
	else if (A.blood_DNA)
		user << "\blue Blood found on [A].<BR>Analysing..."
		sleep(5)
		user << "\blue <B>Blood type:</B> [A.blood_type]<BR> <B>\nDNA:</B> [A.blood_DNA]"
	else
		user << "\blue <B>No blood found on [A].</B>"
	if (!( A.fingerprints ))
		user << "\blue <B>Unable to locate any fingerprints on [A]!</B>"
		return 0
		//if ((src.amount < 1 && src.printing))
		//	user << "\blue Fingerprints found. Need more cards to print."
		//	src.printing = 0
	var/list/L = params2list(A.fingerprints)
	user << text("\blue <B>Isolated</B> [L.len] fingerprints.")
	for(var/i in L)
		user << text("\blue \t [i]")
		//Foreach goto(186)
	return



/*
	if ( istype(location, /turf) )

		var/datum/gas_mixture/environment = location.return_air()

		var/pressure = environment.return_pressure()
		var/total_moles = environment.total_moles()

		user.show_message("\blue <B>Atmospheric Scan:</B>", 1)
		sleep(30)
		if(abs(pressure - ONE_ATMOSPHERE) < 10)
			user.show_message("\blue Pressure: [round(pressure,0.1)] kPa", 1)
		else
			user.show_message("\red Pressure: [round(pressure,0.1)] kPa", 1)
		if(total_moles)
			var/o2_concentration = environment.oxygen/total_moles
			var/n2_concentration = environment.nitrogen/total_moles
			var/co2_concentration = environment.carbon_dioxide/total_moles
			var/plasma_concentration = environment.toxins/total_moles

			var/unknown_concentration =  1-(o2_concentration+n2_concentration+co2_concentration+plasma_concentration)
			if(abs(n2_concentration - N2STANDARD) < 20)
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

			user.show_message("\blue Temperature: [round(environment.temperature-T0C)]&deg;C", 1)

*/

/obj/item/device/Tricorder/attack_self(mob/user as mob)

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

	user.show_message("\blue <B>Atmospheric Scan:</B>", 1)
	if(abs(pressure - ONE_ATMOSPHERE) < 10)
		user.show_message("\blue Pressure: [round(pressure,0.1)] kPa", 1)
	else
		user.show_message("\red Pressure: [round(pressure,0.1)] kPa", 1)
	if(total_moles)
		var/o2_concentration = environment.oxygen/total_moles
		var/n2_concentration = environment.nitrogen/total_moles
		var/co2_concentration = environment.carbon_dioxide/total_moles
		var/plasma_concentration = environment.toxins/total_moles

		var/unknown_concentration =  1-(o2_concentration+n2_concentration+co2_concentration+plasma_concentration)
		if(abs(n2_concentration - N2STANDARD) < 20)
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

		user.show_message("\blue Temperature: [round(environment.temperature-T0C)]&deg;C", 1)

	src.add_fingerprint(user)
	return

/obj/item/device/Tricorder/attackby(var/obj/I as obj, var/mob/user as mob)

	var/datum/reagents/R = I:reagents
	var/datum/reagent/blood/Blood = null
	if(istype(I,/obj/item/weapon/reagent_containers))
		for(var/datum/reagent/G in R.reagent_list)
			user.show_message("The [I.name] contains<BR>[G.name] , [G.volume] Units<BR> ", 1)
		for(var/datum/reagent/blood/B in R.reagent_list)
			if(B)
				Blood = B
				break
		if(Blood)
			user.show_message("analysing blood sample, please wait...<BR>", 1)
			sleep(35)
			user.show_message("<b>Blood DNA:</b> [(Blood.data["blood_DNA"]||"none")]<BR>", 1)
			user.show_message("<b>Blood Type:</b> [(Blood.data["blood_type"]||"none")]<BR>", 1)





