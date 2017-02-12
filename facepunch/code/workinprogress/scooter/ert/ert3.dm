var/ertcompspawned = 0





/proc/create_ERT(ckey)
	var/list/candidates = list()	//candidates for being a commando out of all the active ghosts in world.
	var/list/commando = list()			//actual commando ghosts as picked by the user.
	var/commandos_possible = 6
	if(!ckey)
		for(var/mob/dead/observer/G	 in player_list)
			if(!G.client.is_afk())	//Whoever called/has the proc won't be added to the list.
				if(!(G.mind && G.mind.current && G.mind.current.stat != DEAD))
					candidates += G.key
		for(var/i=commandos_possible,(i>0&&candidates.len),i--)//Decrease with every commando selected.
			var/candidate = input("Pick characters to spawn as the commandos. This will go on until there either no more ghosts to pick from or the slots are full.", "Active Players") as null|anything in candidates	//It will auto-pick a person when there is only one candidate.
			candidates -= candidate		//Subtract from candidates.
			commando += candidate//Add their ghost to commandos.
/*
		for(var/mob/M in player_list)
			if(M.stat != DEAD)		continue	//we are not dead!
			if(M.client.is_afk())	continue	//we are afk
			if(M.mind && M.mind.current && M.mind.current.stat != DEAD)	continue	//we have a live body we are tied to
			candidates += M.ckey
		for(var/i=commandos_possible,(i>0&&candidates.len),i--)//Decrease with every commando selected.
			var/candidate = input("Pick characters to spawn as the commandos. This will go on until there either no more ghosts to pick from or the slots are full.", "Active Players") as null|anything in candidates	//It will auto-pick a person when there is only one candidate.
			candidates -= candidate		//Subtract from candidates.
			commando += candidate//Add their ghost to commandos.
			world << "[commando]"*/
	if(!istext(commando))	return 0

	var/syndicate_commando_number = syndicate_commandos_possible //for selecting a leader
	var/ertjob = input(usr, "Please choose which caste to spawn.","Pick a profession (I suggest a 1, 1, 3 ratio depending on the situation.)",null) as null|anything in list("Medic","Engineer","Normal")
	for(var/obj/effect/landmark/L in world)
		if(syndicate_commando_number <= 0)	break
		if(L.name == "ERT_spawn")
			var/mob/living/carbon/human/new_ert = new/mob/living/carbon/human (L.loc)
			switch(ertjob)
				if("Engineer")
					new_ert.equip_to_slot_or_del(new /obj/item/clothing/under/yellowgreen(new_ert), slot_w_uniform)
					new_ert.equip_to_slot_or_del(new /obj/item/clothing/suit/hazardvest(new_ert), slot_wear_suit)
					new_ert.equip_to_slot_or_del(new /obj/item/clothing/shoes/green(new_ert), slot_shoes)
					new_ert.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_ert), slot_gloves)
					new_ert.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/captain(new_ert), slot_ears)
					new_ert.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/syndi(new_ert), slot_glasses)
					new_ert.equip_to_slot_or_del(new /obj/item/clothing/mask/cigarette/cigar/cohiba(new_ert), slot_wear_mask)
					new_ert.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/orange(new_ert), slot_head)
					new_ert.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full(new_ert), slot_belt)
					new_ert.equip_to_slot_or_del(new /obj/item/weapon/lighter/zippo(new_ert), slot_r_store)
					new_ert.gender = pick(MALE, FEMALE)
					var/commando_name = pick(last_names)
					new_ert.real_name = "ERT Engineer [commando_name]"
					new_ert.age = rand(35,45)
					new_ert.dna.ready_dna(new_ert)//Creates DNA.

					var/obj/item/weapon/card/id/W = new(new_ert)
					W.name = "[new_ert.real_name]'s ID Card"
					W.icon_state = "centcom"
					W.access = get_all_accesses()
					W.access += get_all_centcom_access()
					W.assignment = "ERT Engineer"
					W.registered_name = new_ert.real_name
					new_ert.equip_to_slot_or_del(W, slot_wear_id)

				if("Medic")
					new_ert.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/blue(new_ert), slot_w_uniform)
					new_ert.equip_to_slot_or_del(new /obj/item/clothing/suit/labcoat(new_ert), slot_wear_suit)
					new_ert.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(new_ert), slot_shoes)
					new_ert.equip_to_slot_or_del(new /obj/item/clothing/gloves/white(new_ert), slot_gloves)
					new_ert.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/captain(new_ert), slot_ears)
					new_ert.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/librarian(new_ert), slot_glasses)
					new_ert.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_ert), slot_wear_mask)
					new_ert.equip_to_slot_or_del(new /obj/item/clothing/head/nursehat(new_ert), slot_head)
					new_ert.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/medical(new_ert), slot_belt)
					new_ert.gender = pick(MALE, FEMALE)
					var/commando_name = pick(last_names)
					new_ert.real_name = "ERT Doctor [commando_name]"
					new_ert.age = rand(55,65)
					new_ert.dna.ready_dna(new_ert)//Creates DNA.

					var/obj/item/weapon/card/id/W = new(new_ert)
					W.name = "[new_ert.real_name]'s ID Card"
					W.icon_state = "centcom"
					W.access = get_all_accesses()
					W.access += get_all_centcom_access()
					W.assignment = "ERT Doctor"
					W.registered_name = new_ert.real_name
					new_ert.equip_to_slot_or_del(W, slot_wear_id)

				if("Normal")
					new_ert.equip_to_slot_or_del(new /obj/item/clothing/under/lawyer/black(new_ert), slot_w_uniform)
					new_ert.equip_to_slot_or_del(new /obj/item/clothing/suit/reporterjacket(new_ert), slot_wear_suit)
					new_ert.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_ert), slot_shoes)
					new_ert.equip_to_slot_or_del(new /obj/item/clothing/gloves/white(new_ert), slot_gloves)
					new_ert.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/captain(new_ert), slot_ears)
					new_ert.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/librarian(new_ert), slot_glasses)
					new_ert.equip_to_slot_or_del(new /obj/item/clothing/head/beret(new_ert), slot_head)
					new_ert.gender = pick(MALE, FEMALE)
					var/commando_name = pick(last_names)
					new_ert.real_name = "ERT Member [commando_name]"
					new_ert.age = rand(55,65)
					new_ert.dna.ready_dna(new_ert)//Creates DNA.

					var/obj/item/weapon/card/id/W = new(new_ert)
					W.name = "[new_ert.real_name]'s ID Card"
					W.icon_state = "centcom"
					W.access = get_all_accesses()
					W.access += get_all_centcom_access()
					W.assignment = "ERT Member"
					W.registered_name = new_ert.real_name
					new_ert.equip_to_slot_or_del(W, slot_wear_id)
				else			return 0

					new_ert.ckey = pick(commando)
					new_ert << "<b>You are an Emergency Response Team Member. Your goal is to aid the crew in what they need; as well as assist any Medic or Engineers on your team.</b>"
					new_ert << "Please refer to the Standard Operating Procedure paper in front of space suits. Remember though; space suits are completely optional and situational."
					new_ert << "Also remember that you are <b>NOT</b> a Death Squad. Your job is to <b>HELP</B> the crew; not murder them. Also remember you are a NEW person; do not use information you learned in your previous life."
					message_admins("\blue [key_name_admin(usr)] has spawned [commando] as an ERT [ertjob].", 1)
	if(ertcompspawned == 0)
		for (var/obj/effect/landmark/L in /area/shuttle/transport1/centcom)
			if (L.name == "ertcomp")
				new /obj/machinery/computer/ert_shuttle(L.loc)
	else
		return
	return 1


///////////////////////
///ERT Related Items///
///////////////////////


//cloests on ERT shuttle
/obj/structure/closet/secure_closet/ert
	name = "ERT Storage Supply Locker"
	req_access = list(access_cent_specops)


//Food freezer
/obj/structure/closet/crate/freezer/ert
	//This exists so the prespawned hydro crates spawn with their contents.
	desc = "Toss a banging donk at them!"
	name = "Emergency Food Freezer"
	icon = 'icons/obj/storage.dmi'
	icon_state = "freezer"
	density = 1
	icon_opened = "freezeropen"
	icon_closed = "freezer"
	New()
		..()
		new /obj/item/weapon/storage/box/donkpockets(src)
		new /obj/item/weapon/storage/box/donkpockets(src)
		new /obj/item/weapon/storage/box/donkpockets(src)
		new /obj/item/weapon/storage/box/donkpockets(src)
		new /obj/item/weapon/storage/box/donkpockets(src)
		new /obj/item/weapon/storage/box/donkpockets(src)
		new /obj/item/weapon/storage/box/donkpockets(src)
		new /obj/item/weapon/storage/box/donkpockets(src)




/obj/structure/closet/crate/medical/ert
	desc = "This will all be gone in 5 minutes."
	name = "Emergency Medical Crate"
	icon = 'icons/obj/storage.dmi'
	icon_state = "medicalcrate"
	density = 1
	icon_opened = "medicalcrateopen"
	icon_closed = "medicalcrate"
	New()
		..()
		new /obj/item/weapon/storage/firstaid/regular(src)
		new /obj/item/weapon/storage/firstaid/regular(src)
		new /obj/item/weapon/storage/firstaid/regular(src)
		new /obj/item/weapon/storage/firstaid/fire(src)
		new /obj/item/weapon/storage/firstaid/fire(src)
		new /obj/item/weapon/storage/firstaid/fire(src)
		new /obj/item/weapon/storage/firstaid/o2(src)
		new /obj/item/weapon/storage/firstaid/o2(src)
		new /obj/item/weapon/storage/firstaid/o2(src)
		new /obj/item/weapon/storage/firstaid/toxin(src)
		new /obj/item/weapon/storage/firstaid/toxin(src)
