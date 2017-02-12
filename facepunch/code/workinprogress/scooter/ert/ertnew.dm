var/ertcompspawned = 0
var/const/erts_possible = 6
var/global/sent_ert_team = 0
var/global/ertmission
/proc/create_ERT(ckey)
	var/ertjob
	if(!ticker)
		usr << "<font color='red'>The game hasn't started yet!</font>"
		return
//	if(world.time < 6000)
//		usr << "<font color='red'>There are [(6000-world.time)/10] seconds remaining before it may be called.</font>"
//		return
	if(sent_strike_team == 1)
		usr << "<font color='red'>An ERT is already being sent in.</font>"
		return
	if(alert("Do you want to send in an ERT team? You can only do this once.",,"Yes","No")!="Yes")
		return
	alert("While you will be able to manually pick the candidates from active ghosts, their assignment in the ERT will be random.")


	if(sent_ert_team)
		usr << "Looks like someone beat you to it."
		return

	sent_ert_team = 1

	var/input = null
	while(!input)
		input = input(usr, "Please choose which mission the team will be taking?.","Equipment shall be assigned randomly based on the mission)",null) as null|anything in list("Court","Bio Hazard Cleanup","Normal")
		ertjob = input
//Generates a list of commandos from active ghosts. Then the user picks which characters to respawn as the commandos.
	var/list/candidates = list()	//candidates for being a commando out of all the active ghosts in world.
	var/list/commandos = list()			//actual commando ghosts as picked by the user.
	if(candidates.len)
		return
	for(var/mob/dead/observer/G	 in player_list)
		if(!G.client.is_afk())	//Whoever called/has the proc won't be added to the list.
			if(!(G.mind && G.mind.current && G.mind.current.stat != DEAD))
				candidates += G.key
	for(var/i=commandos_possible,(i>0&&candidates.len),i--)//Decrease with every commando selected.
		var/candidate = input("Pick characters to spawn as the ERTs. This will go on until there either no more ghosts to pick from or the slots are full.", "Active Players") as null|anything in candidates	//It will auto-pick a person when there is only one candidate.
		candidates -= candidate		//Subtract from candidates.
		commandos += candidate//Add their ghost to commandos.

	var/obj/effect/landmark/spawn_here = ERT_spawn.len ? pick(ERT_spawn) : pick(ERT_spawn)
	var/mob/living/carbon/human/new_ert

//	var/erts_possible = 5
//	var/list/erts = list()
//	var/candidate_amount = 0
/*
	if(!ckey)
		var/list/candidates = list()
		for(var/mob/M in player_list)
			if(M.stat != DEAD)		continue	//we are not dead!
			if(M.client.is_afk())	continue	//we are afk
			if(M.mind && M.mind.current && M.mind.current.stat != DEAD)	continue	//we have a live body we are tied to
			candidates += M.ckey
		if(candidates.len)
			ckey = input("Pick the player you want to respawn as part of the Emergency Rescue Team.", "Suitable Candidates") as null|anything in candidates
		else
			usr << "<font color='red'>Error: create_ert(): no suitable candidates.</font>"
	if(!istext(ckey))	return 0

	for(var/obj/effect/landmark/L in landmarks_list)
		if(commando_number<=0)	break
		if (L.name == "Commando")
			leader_selected = commando_number == 1?1:0

			var/mob/living/carbon/human/new_commando = create_death_commando(L, leader_selected)

			if(commandos.len)
				new_commando.key = pick(commandos)
				commandos -= new_commando.key
			new_commando << "\blue You are a Special Ops. [!leader_selected?"commando":"<B>LEADER</B>"] in the service of Central Command. Check the table ahead for detailed instructions.\nYour current mission is: \red<B>[input]</B>"

			commando_number--

/*
	var/ertjob = input(usr, "Please choose which caste to spawn.","Pick a profession (I suggest a 1, 1, 3 ratio depending on the situation.)",null) as null|anything in list("Medic","Engineer","Normal")
	var/obj/effect/landmark/spawn_here = ERT_spawn.len ? pick(ERT_spawn) : pick(ERT_spawn)
	var/mob/living/carbon/human/new_ert
*/
	/*
	if(!ckey)
		var/list/candidates = list()
		for(var/mob/M in player_list)
			if(M.stat != DEAD)		continue	//we are not dead!
			if(M.client.is_afk())	continue	//we are afk
			if(M.mind && M.mind.current && M.mind.current.stat != DEAD)	continue	//we have a live body we are tied to
			candidates += M.ckey
			candidate_amount += 1
		for(var/i=erts_possible,(i>0&&candidates.len),i--)//Decrease with every commando selected.
			var/candidate = input("Pick characters to spawn as the commandos. This will go on until there either no more ghosts to pick from or the slots are full.", "Active Players") as null|anything in candidates	//It will auto-pick a person when there is only one candidate.
			candidates -= candidate		//Subtract from candidates.
			erts += candidate//Add their ghost to commandos.
			candidate_amount += 1
	if(candidate_amount >= erts_possible) return 0
*/

	var/ertjob = input(usr, "Please choose which mission the team will be taking?.","Equipment shall be assigned randomly based on the mission)",null) as null|anything in list("Court","Bio Hazard Cleanup","Normal")
	var/obj/effect/landmark/spawn_here = ERT_spawn.len ? pick(ERT_spawn) : pick(ERT_spawn)
	var/mob/living/carbon/human/new_ert

/*

	var/list/candidates = list()	//candidates for being a commando out of all the active ghosts in world.
	var/list/commandos = list()			//actual commando ghosts as picked by the user.
	for(var/mob/dead/observer/G	 in player_list)
		if(!G.client.holder && !G.client.is_afk())	//Whoever called/has the proc won't be added to the list.
			if(!(G.mind && G.mind.current && G.mind.current.stat != DEAD))
				candidates += G.key
	for(var/i=commandos_possible,(i>0&&candidates.len),i--)//Decrease with every commando selected.
		var/candidate = input("Pick characters to spawn as the commandos. This will go on until there either no more ghosts to pick from or the slots are full.", "Active Players") as null|anything in candidates	//It will auto-pick a person when there is only one candidate.
		candidates -= candidate		//Subtract from candidates.
		commandos += candidate//Add their ghost to commandos.
/*
*/
*/
/mob/living/carbon/human/proc/equip_ert(leader_selected = 0)
	if(ertmission == court)
		new_ert = new /mob/living/carbon/human(spawn_here)
		new_ert.gender = pick(MALE, FEMALE)
		var/commando_name = pick(last_names)
		new_ert.real_name = pick("Court Assistant [commando_name]", "Judge [commando_name]", "Baliff [commando_name]")
		new_ert.age = rand(55,65)
		new_ert.dna.ready_dna(new_ert)//Creates DNA.

		var/obj/item/weapon/card/id/W = new(new_ert)
		W.name = "[new_ert.real_name]'s ID Card"
		W.icon_state = "centcom"
		W.access = get_all_accesses()
		W.access += get_all_centcom_access()
		if(new_ert.real_name == "Court Assistant [commando_name]")
			W.assignment = "ERT Court Assistant"
		else if(new_ert.real_name == "Judge [commando_name]")
			W.assignment = "ERT Judge"
		else if(new_ert.real_name == "Baliff [commando_name]")
			W.assignment = "ERT Baliff"
		W.registered_name = new_ert.real_name
		if(new_ert.real_name == "Court Assistant [commando_name]")
			new_ert.equip_to_slot_or_del(new /obj/item/clothing/under/reporter(new_ert), slot_w_uniform)
			new_ert.equip_to_slot_or_del(new /obj/item/clothing/suit/reporterjacket(new_ert), slot_wear_suit)
			new_ert.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(new_ert), slot_shoes)
			new_ert.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(new_ert), slot_gloves)
			new_ert.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/captain(new_ert), slot_ears)
			new_ert.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big(new_ert), slot_glasses)
			new_ert.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(new_ert), slot_back)
			new_ert.equip_to_slot_or_del(new /obj/item/clothing/head/reporter(new_ert), slot_head)
			new_ert.equip_to_slot_or_del(new /obj/item/device/camera(src), slot_in_backpack)
			new_ert.equip_to_slot_or_del(new /obj/item/device/detective_scanner(src), slot_in_backpack)
			new_ert.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/fire(src), slot_in_backpack)
			new_ert.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/stunrevolver(src), slot_in_backpack)
		else if(new_ert.real_name == "Judge [commando_name]")
			if(new_ert.gender == FEMALE)
				new_ert.equip_to_slot_or_del(new /obj/item/clothing/under/lawyer/female(new_ert), slot_w_uniform)
			else
				new_ert.equip_to_slot_or_del(new /obj/item/clothing/under/lawyer/black(new_ert), slot_w_uniform)
				new_ert.equip_to_slot_or_del(new /obj/item/clothing/suit/judgerobe(new_ert), slot_wear_suit)
				new_ert.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(new_ert), slot_shoes)
				new_ert.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/captain(new_ert), slot_ears)
				new_ert.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/librarian(new_ert), slot_glasses)
				new_ert.equip_to_slot_or_del(new /obj/item/clothing/head/powdered_wig(new_ert), slot_head)
				new_ert.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(new_ert), slot_back)
				new_ert.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/stunrevolver(src), slot_in_backpack)
			else if(new_ert.real_name == "Baliff [commando_name]")
				new_ert.equip_to_slot_or_del(new /obj/item/clothing/under/rank/vicedetective(new_ert), slot_w_uniform)
				new_ert.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/det_suit(new_ert), slot_wear_suit)
				new_ert.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(new_ert), slot_shoes)
				new_ert.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/captain(new_ert), slot_ears)
				new_ert.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(new_ert), slot_glasses)
				new_ert.equip_to_slot_or_del(new /obj/item/clothing/head/det_hat(new_ert), slot_head)
				new_ert.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(new_ert), slot_back)
				new_ert.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/stunrevolver(src), slot_in_backpack)
			new_ert.equip_to_slot_or_del(W, slot_wear_id)
	var/obj/item/weapon/implant/loyalty/L = new/obj/item/weapon/implant/loyalty(src)//Here you go Deuryn
	L.imp_in = src
	L.implanted = 1
	var/commando_number = erts_possible //for selecting a leader

	switch(ertjob)
		if("Bio Hazard Cleanup")
			new_ert = new /mob/living/carbon/human(spawn_here)
			new_ert.gender = pick(MALE, FEMALE)
			var/commando_name = pick(last_names)
			new_ert.real_name = pick("Court Assistant [commando_name]", "Judge [commando_name]", "Baliff [commando_name]")
			new_ert.age = rand(55,65)
			new_ert.dna.ready_dna(new_ert)//Creates DNA.

			var/obj/item/weapon/card/id/W = new(new_ert)
			W.name = "[new_ert.real_name]'s ID Card"
			W.icon_state = "centcom"
			W.access = get_all_accesses()
			W.access += get_all_centcom_access()
			W.assignment = "ERT Hazard Unit"
			new_ert.equip_to_slot_or_del(new /obj/item/clothing/under/rank/centcom_commander(new_ert), slot_w_uniform)
			new_ert.equip_to_slot_or_del(new /obj/item/clothing/suit/bio_suit(new_ert), slot_wear_suit)
			new_ert.equip_to_slot_or_del(new /obj/item/clothing/shoes/green(new_ert), slot_shoes)
			new_ert.equip_to_slot_or_del(new /obj/item/clothing/gloves/white(new_ert), slot_gloves)
			new_ert.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/captain(new_ert), slot_ears)
			new_ert.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/mech(new_ert), slot_glasses)
			new_ert.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_ert), slot_wear_mask)
			new_ert.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_med(new_ert), slot_back)
			if(prob(25))
				new_ert.equip_to_slot_or_del(new /obj/item/clothing/head/bio_hood/general(new_ert), slot_head)
			else if(prob(25))
				new_ert.equip_to_slot_or_del(new /obj/item/clothing/head/bio_hood/janitor(new_ert), slot_head)
			else if(prob(25))
				new_ert.equip_to_slot_or_del(new /obj/item/clothing/head/bio_hood/security(new_ert), slot_head)
			else
				new_ert.equip_to_slot_or_del(new /obj/item/clothing/head/bio_hood/cmo(new_ert), slot_head)
			new_ert.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/regular(src), slot_in_backpack)
			new_ert.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/o2(src), slot_in_backpack)
			new_ert.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/fire(src), slot_in_backpack)
			new_ert.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/medical/full(new_ert), slot_belt)
			new_ert.gender = pick(MALE, FEMALE)
			new_ert.equip_to_slot_or_del(W, slot_wear_id)

		if("Court")


		if("Normal")
			new_ert = new /mob/living/carbon/human(spawn_here)
			new_ert.equip_to_slot_or_del(new /obj/item/clothing/under/rank/centcom_commander(new_ert), slot_w_uniform)
			new_ert.equip_to_slot_or_del(new /obj/item/clothing/suit/space/emerg(new_ert), slot_wear_suit)
			new_ert.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(new_ert), slot_shoes)
			new_ert.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_ert), slot_gloves)
			new_ert.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/captain(new_ert), slot_ears)
			new_ert.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/syndi(new_ert), slot_glasses)
			new_ert.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/emerg(new_ert), slot_head)
			new_ert.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_med(new_ert), slot_back)
			new_ert.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/stunrevolver(src), slot_in_backpack)

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

	new_ert.ckey = ckey
	new_ert << "<b>You are an Emergency Response Team Member. Your goal is to aid the crew in what they need; as well as assist any Medic or Engineers on your team.</b>"
	new_ert << "Please refer to the Standard Operating Procedure paper in front of space suits. Remember though; space suits are completely optional and situational."
	new_ert << "Also remember that you are <b>NOT</b> a Death Squad. Your job is to <b>HELP</B> the crew; not murder them. Also remember you are a NEW person; do not use information you learned in your previous life."
	message_admins("\blue [key_name_admin(usr)] has spawned [ckey] as an ERT [ertjob].", 1)
	if(ertcompspawned == 0)
		for (var/obj/effect/landmark/L in /area/shuttle/transport1/centcom)
			if (L.name == "ertcomp")
				new /obj/machinery/computer/ert_shuttle(L.loc)
	else
		return
	return 1

	for(var/obj/effect/landmark/L in landmarks_list)
		if(commando_number<=0)	break
		if (L.name == "ERT_spawn")

			if(commandos.len)
				new_ert.ckey = pick(commandos)
				commandos -= new_ert.key
			commando_number--
*/
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
