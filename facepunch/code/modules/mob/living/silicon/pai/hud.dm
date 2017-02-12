/mob/living/silicon/pai/proc/regular_hud_updates()
	if(client)
		for(var/image/hud in client.images)
			if(copytext(hud.icon_state,1,4) == "hud")
				del(hud)

/mob/living/silicon/pai/proc/securityHUD()
	if(!client)
		return

	var/icon/tempHud = 'icons/mob/hud.dmi'
	var/turf/T = get_turf(src.loc)

	for(var/mob/living/carbon/human/perp in view(T))//Copypaste from sechuds, I dont really like this but dont have the time or willpower to give them glasses
		if(!client) break
		var/perpname = "wot"
		if(!istype(perp.wear_id,/obj/item))//If they dont have an item on the ID slot then just use unknown.
			perpname = perp.name
			client.images += image(tempHud, perp, "hudunknown")
		else
			var/obj/item/weapon/card/id/I = perp.wear_id:GetID()//See if we have an ID anywhere, getID returns null or an ID
			if(!I)
				perpname = perp.name
				client.images += image(tempHud, perp, "hudunknown")
			else
				var/jobname = "Unknown"
				if(I.assignment in get_all_jobs())
					jobname = I.assignment//Looking for a matching image
				client.images += image(tempHud, perp, "hud[ckey(jobname)]")
				perpname = I.registered_name

		for(var/datum/data/record/E in data_core.general)
			if(E.fields["name"] == perpname)
				for (var/datum/data/record/R in data_core.security)
					if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "*Arrest*"))
						client.images += image(tempHud, perp, "hudwanted")
						break
					else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Incarcerated"))
						client.images += image(tempHud, perp, "hudprisoner")
						break
					else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Parolled"))
						client.images += image(tempHud, perp, "hudparolled")
						break
					else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Released"))
						client.images += image(tempHud, perp, "hudreleased")
						break
		for(var/obj/item/weapon/implant/I in perp)
			if(I.implanted)
				if(istype(I,/obj/item/weapon/implant/tracking))
					client.images += image(tempHud, perp, "hud_imp_tracking")
				if(istype(I,/obj/item/weapon/implant/loyalty))
					client.images += image(tempHud, perp, "hud_imp_loyal")
				if(istype(I,/obj/item/weapon/implant/chem))
					client.images += image(tempHud, perp, "hud_imp_chem")
	return


/mob/living/silicon/pai/proc/medicalHUD()
	if(client)
		var/icon/tempHud = 'icons/mob/hud.dmi'
		var/turf/T = get_turf(src.loc)
		for(var/mob/living/carbon/human/patient in view(T))

			var/foundVirus = 0
			for(var/datum/disease/D in patient.viruses)
				if(!D.hidden[SCANNER])
					foundVirus = 1

			client.images += image(tempHud,patient,"hud[RoundHealth(patient.health)]")
			if(patient.stat == 2)
				client.images += image(tempHud,patient,"huddead")
			else if(patient.status_flags & XENO_HOST)
				client.images += image(tempHud,patient,"hudxeno")
			else if(foundVirus)
				client.images += image(tempHud,patient,"hudill")
			else
				client.images += image(tempHud,patient,"hudhealthy")

/mob/living/silicon/pai/proc/RoundHealth(health)
	switch(health)
		if(100 to INFINITY)
			return "health100"
		if(70 to 100)
			return "health80"
		if(50 to 70)
			return "health60"
		if(30 to 50)
			return "health40"
		if(20 to 30)
			return "health25"
		if(5 to 15)
			return "health10"
		if(1 to 5)
			return "health1"
		if(-99 to 0)
			return "health0"
		else
			return "health-100"
	return "0"