//STRIKE TEAMS

var/const/ert_possible = 6 //if more ert are needed in the future
var/global/sent_ert_team = 0
var/global/ertjob = null
var/global/ertmod = null
/client/proc/ert_team()
	if(!ticker)
		usr << "<font color='red'>The game hasn't started yet!</font>"
		return
	if(world.time < 1)
		usr << "<font color='red'>There are [(6000-world.time)/10] seconds remaining before it may be called.</font>"
		return
	if(sent_ert_team == 1)
		usr << "<font color='red'>CentCom is already sending a team.</font>"
		return
	if(alert("Do you want to send in the CentCom ERT squad? Once enabled, this is irreversible.",,"Yes","No")!="Yes")
		return
	alert("Choose what kind of ERT you want to send in. Choose the people..")

	while(!ertjob)
		ertjob = input(usr, "Please ERT type to send in.","CHOOOSE.)",null) as null|anything in list("Court","Bio Hazard Cleanup","Normal")
		world << "ert job"
		if(!ertjob)
			if(alert("Error, no mission set. Do you want to exit the setup process?",,"Yes","No")=="Yes")
				return
/*
	while(!ertmod)
		ertmod = input(usr, "Modifiers give them extra equipment.","Best used with 'Normal' ERTs)",null) as null|anything in list("Medical Supplies","Engineering Supplies","None", "Rev", "Cult", "ERP Buster")
		if(!ertmod)
			if(alert("Error, no mission set. Do you want to exit the setup process?",,"Yes","No")=="Yes")
				return
*/
/*
	if(sent_ert_team)
		usr << "Looks like someone beat you to it."
		return
*/
	sent_ert_team = 1

	var/commando_number = ert_possible //for selecting a leader
	var/leader_selected = 0 //when the leader is chosen. The last person spawned.


//Generates a list of ert from active ghosts. Then the user picks which characters to respawn as the ert.
	var/list/candidates = list()	//candidates for being a commando out of all the active ghosts in world.
	var/list/ert = list()			//actual commando ghosts as picked by the user.
	for(var/mob/dead/observer/G	 in player_list)
	//	if(!G.client.holder && !G.client.is_afk())	//Whoever called/has the proc won't be added to the list.
		if(!(G.mind && G.mind.current && G.mind.current.stat != DEAD))
			candidates += G.key
	for(var/i=ert_possible,(i>0&&candidates.len),i--)//Decrease with every commando selected.
		var/candidate = input("Pick characters to spawn as the ert. This will go on until there either no more ghosts to pick from or the slots are full.", "Active Players") as null|anything in candidates	//It will auto-pick a person when there is only one candidate.
		candidates -= candidate		//Subtract from candidates.
		ert += candidate//Add their ghost to ert.

//Spawns ert and equips them.
	for(var/obj/effect/landmark/L in landmarks_list)
		if(commando_number<=0)	break
		if (L.name == "ERT")
			leader_selected = commando_number == 1?1:0
			var/mob/living/carbon/human/new_commando = create_ert_commando(L, leader_selected)

			if(ert.len)
				new_commando.key = pick(ert)
				ert -= new_commando.key
				new_commando.internal = new_commando.s_store
				new_commando.internals.icon_state = "internal1"

			new_commando << "\blue You are an ERP. [!leader_selected?"commando":"<B>LEADER</B>"] in the service of Central Command. Check the table ahead for detailed instructions.\nYour current mission is: \red<B>[ertjob]</B>"

			commando_number--
/*
		if(L.name == "ERTsing")
			new/obj/structure/closet/crate/secure/pa(L.loc)
		if(L.name == "ERT_addon")
			switch(ertmod)
				if("Medical Supplies")
					new /obj/structure/closet/crate/medical/ert (L.loc)
				if("None")
					return//sadface
				if("Engineering Supplies")
					new/obj/structure/closet/crate/radiation/engy(L.loc)
					return
				if("Rev")
					new /obj/structure/table/holotable/unbreak (L.loc)
					new /obj/item/weapon/storage/lockbox/loyalty(L.loc)
					return
				if("Cult")
					new /obj/structure/table/holotable/unbreak (L.loc)
					return
				if("ERP Buster")
					return
					*/
//Spawns the rest of the commando gear.
/*	for (var/obj/effect/landmark/L in landmarks_list)
		if (L.name == "ert_addon")
			if(ert_job == "Normal")
				return
*/
	for (var/obj/effect/landmark/L in landmarks_list)
		if (L.name == "Commando-Bomb")
			new /obj/effect/spawner/newbomb/timer/syndicate(L.loc)
			del(L)

	message_admins("\blue [key_name_admin(usr)] has spawned a CentCom strike squad.", 1)
	log_admin("[key_name(usr)] used Spawn ERP Squad.")
	return 1

/client/proc/create_ert_commando(obj/spawn_location, leader_selected = 0)
	var/mob/living/carbon/human/new_commando = new(spawn_location.loc)
	new_commando.gender = pick(MALE, FEMALE)

	var/datum/preferences/A = new()//Randomize appearance for the commando.
	A.randomize_appearance_for(new_commando)


	//Creates mind stuff.
	new_commando.mind_initialize()
	new_commando.mind.assigned_role = "MODE"
	ticker.mode.traitors |= new_commando.mind//Adds them to current traitor list. Which is really the extra antagonist list.
	new_commando.equip_ert_commando(leader_selected)

	return new_commando

/mob/living/carbon/human/proc/equip_ert_commando(leader_selected = 0)
	var/obj/item/device/radio/R = new /obj/item/device/radio/headset/heads/captain(src)
	R.set_frequency(1441)
	switch(ertjob)
		if("Bio Hazard Cleanup")
			gender = pick(MALE, FEMALE)
			var/commando_name = pick(last_names)
			real_name = "Biohazard Clean-up [commando_name]"
			age = rand(55,65)
			dna.ready_dna(src)//Creates DNA.
			var/obj/item/weapon/card/id/W = new(src)
			W.name = "[real_name]'s ID Card"
			W.icon_state = "centcom"
			W.access = get_all_accesses()
			W.access += get_all_centcom_access()
			W.assignment = "ERP Member"
			W.registered_name = real_name
			equip_to_slot_or_del(W, slot_wear_id)
			equip_to_slot_or_del(R, slot_ears)
			equip_to_slot_or_del(new /obj/item/clothing/under/rank/centcom_commander(src), slot_w_uniform)
			equip_to_slot_or_del(new /obj/item/clothing/suit/bio_suit(src), slot_wear_suit)
			equip_to_slot_or_del(new /obj/item/clothing/shoes/green(src), slot_shoes)
			equip_to_slot_or_del(new /obj/item/clothing/gloves/white(src), slot_gloves)
			equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/captain(src), slot_ears)
			equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/mech(src), slot_glasses)
			equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(src), slot_wear_mask)
			equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(src), slot_back)
			if(prob(25))
				equip_to_slot_or_del(new /obj/item/clothing/head/bio_hood/general(src), slot_head)
			else if(prob(25))
				equip_to_slot_or_del(new /obj/item/clothing/head/bio_hood/janitor(src), slot_head)
			else if(prob(25))
				equip_to_slot_or_del(new /obj/item/clothing/head/bio_hood/security(src), slot_head)
			else
				equip_to_slot_or_del(new /obj/item/clothing/head/bio_hood/cmo(src), slot_head)
			equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/regular(src), slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/o2(src), slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/fire(src), slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/weapon/storage/belt/medical/full(src), slot_belt)
		if("Court")
			gender = pick(MALE, FEMALE)
			var/commando_name = pick(last_names)
			real_name = pick("Secretary [commando_name]", "Judge [commando_name]", "Baliff [commando_name]")
			age = rand(55,65)

			var/obj/item/weapon/card/id/W = new(src)
			W.name = "[real_name]'s ID Card"
			W.icon_state = "centcom"
			W.access = get_all_accesses()
			W.access += get_all_centcom_access()
			if(real_name == "Court Assistant [commando_name]")
				W.assignment = "ERP Court Assistant"
			else if(real_name == "Judge [commando_name]")
				W.assignment = "ERP Judge"
			else if(real_name == "Baliff [commando_name]")
				W.assignment = "ERP Baliff"
			W.registered_name = real_name
			if(real_name == "Court Assistant [commando_name]")
				equip_to_slot_or_del(R, slot_ears)
				equip_to_slot_or_del(new /obj/item/clothing/under/reporter(src), slot_w_uniform)
				equip_to_slot_or_del(new /obj/item/clothing/suit/reporterjacket(src), slot_wear_suit)
				equip_to_slot_or_del(new /obj/item/clothing/shoes/black(src), slot_shoes)
				equip_to_slot_or_del(new /obj/item/clothing/gloves/black(src), slot_gloves)
				equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big(src), slot_glasses)
				equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(src), slot_back)
				equip_to_slot_or_del(new /obj/item/clothing/head/reporter(src), slot_head)
				equip_to_slot_or_del(new /obj/item/device/camera(src), slot_in_backpack)
				equip_to_slot_or_del(new /obj/item/device/detective_scanner(src), slot_in_backpack)
				equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/fire(src), slot_in_backpack)
				equip_to_slot_or_del(new /obj/item/weapon/gun/energy/stunrevolver(src), slot_in_backpack)
				equip_to_slot_or_del(W, slot_wear_id)
				equip_to_slot_or_del(R, slot_ears)
			else if(real_name == "Judge [commando_name]")
				if(gender == FEMALE)
					equip_to_slot_or_del(new /obj/item/clothing/under/lawyer/female(src), slot_w_uniform)
				else
					equip_to_slot_or_del(new /obj/item/clothing/under/lawyer/black(src), slot_w_uniform)
				equip_to_slot_or_del(new /obj/item/clothing/suit/judgerobe(src), slot_wear_suit)
				equip_to_slot_or_del(new /obj/item/clothing/shoes/black(src), slot_shoes)
				equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/librarian(src), slot_glasses)
				equip_to_slot_or_del(new /obj/item/clothing/head/powdered_wig(src), slot_head)
				equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(src), slot_back)
				equip_to_slot_or_del(new /obj/item/weapon/gun/energy/stunrevolver(src), slot_in_backpack)
				equip_to_slot_or_del(W, slot_wear_id)
				equip_to_slot_or_del(R, slot_ears)
			else if(real_name == "Baliff [commando_name]")
				equip_to_slot_or_del(new /obj/item/clothing/under/rank/vicedetective(src), slot_w_uniform)
				equip_to_slot_or_del(new /obj/item/clothing/suit/armor/det_suit(src), slot_wear_suit)
				equip_to_slot_or_del(new /obj/item/clothing/shoes/black(src), slot_shoes)
				equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/captain(src), slot_ears)
				equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(src), slot_glasses)
				equip_to_slot_or_del(new /obj/item/clothing/head/det_hat(src), slot_head)
				equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(src), slot_back)
				equip_to_slot_or_del(new /obj/item/weapon/gun/energy/stunrevolver(src), slot_in_backpack)
				equip_to_slot_or_del(W, slot_wear_id)
				equip_to_slot_or_del(R, slot_ears)

		if("Normal")
			equip_to_slot_or_del(new /obj/item/clothing/under/rank/centcom_commander(src), slot_w_uniform)
			equip_to_slot_or_del(new /obj/item/clothing/suit/space/emerg(src), slot_wear_suit)
			equip_to_slot_or_del(new /obj/item/clothing/shoes/black(src), slot_shoes)
			equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(src), slot_gloves)
			equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/captain(src), slot_ears)
			equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/syndi(src), slot_glasses)
			equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/emerg(src), slot_head)
			equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(src), slot_back)
			equip_to_slot_or_del(new /obj/item/weapon/gun/energy/stunrevolver(src), slot_in_backpack)

			gender = pick(MALE, FEMALE)
			var/commando_name = pick(last_names)
			real_name = "ERP Member [commando_name]"
			age = rand(55,65)
			dna.ready_dna(src)//Creates DNA

			var/obj/item/weapon/card/id/W = new(src)
			W.name = "[real_name]'s ID Card"
			W.icon_state = "centcom"
			W.access = get_all_accesses()
			W.access += get_all_centcom_access()
			W.assignment = "ERP Member"
			W.registered_name = real_name
			equip_to_slot_or_del(W, slot_wear_id)
			equip_to_slot_or_del(R, slot_ears)
		else			return 0








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
























/*
	var/obj/item/device/radio/R = new /obj/item/device/radio/headset(src)
	R.set_frequency(1441)
	equip_to_slot_or_del(R, slot_ears)
	if (leader_selected == 0)
		equip_to_slot_or_del(new /obj/item/clothing/under/color/green(src), slot_w_uniform)
	else
		equip_to_slot_or_del(new /obj/item/clothing/under/rank/centcom_officer(src), slot_w_uniform)
	equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(src), slot_shoes)
	equip_to_slot_or_del(new /obj/item/clothing/suit/space/swat(src), slot_wear_suit)
	equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(src), slot_gloves)
	equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/deathsquad(src), slot_head)
	equip_to_slot_or_del(new /obj/item/clothing/mask/gas/swat(src), slot_wear_mask)
	equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal(src), slot_glasses)

	equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/security(src), slot_back)
	equip_to_slot_or_del(new /obj/item/weapon/storage/box(src), slot_in_backpack)

	equip_to_slot_or_del(new /obj/item/ammo_magazine/a357(src), slot_in_backpack)
	equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/regular(src), slot_in_backpack)
	equip_to_slot_or_del(new /obj/item/weapon/storage/box/flashbangs(src), slot_in_backpack)
	equip_to_slot_or_del(new /obj/item/device/flashlight(src), slot_in_backpack)
	if (!leader_selected)
		equip_to_slot_or_del(new /obj/item/weapon/plastique(src), slot_in_backpack)
	else
		equip_to_slot_or_del(new /obj/item/weapon/pinpointer(src), slot_in_backpack)
		equip_to_slot_or_del(new /obj/item/weapon/disk/nuclear(src), slot_in_backpack)

	equip_to_slot_or_del(new /obj/item/weapon/melee/energy/sword(src), slot_l_store)
	equip_to_slot_or_del(new /obj/item/weapon/grenade/flashbang(src), slot_r_store)
	equip_to_slot_or_del(new /obj/item/weapon/tank/emergency_oxygen(src), slot_s_store)
	equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/mateba(src), slot_belt)

	equip_to_slot_or_del(new /obj/item/weapon/gun/energy/pulse_rifle(src), slot_r_hand)


	var/obj/item/weapon/implant/loyalty/L = new/obj/item/weapon/implant/loyalty(src)//Here you go Deuryn
	L.imp_in = src
	L.implanted = 1



	var/obj/item/weapon/card/id/W = new(src)
	W.name = "[real_name]'s ID Card"
	W.icon_state = "centcom"
	W.access = get_all_accesses()//They get full station access.
	W.access += list(access_cent_general, access_cent_specops, access_cent_living, access_cent_storage)//Let's add their alloted CentCom access.
	W.assignment = "ert Commando"
	W.registered_name = real_name
	equip_to_slot_or_del(W, slot_wear_id)

	return 1*/