// Note: Don't forget to check and modify /obj/machinery/computer/card (the ID computer) as needed
//       when you re-enable old credentials or add new ones.
//       Also check proc/get_access_desc() (ID computer lookup) at the bottom of this file.

/var/const
	access_fuck_all = 0 //Because completely empty access lists can make things grump
	access_security = 1
	access_brig = 2
	access_armory = 3 // Unused and replaced by maxsec (HoS-exclusive).
	access_forensics_lockers = 4
	access_medical = 5
	access_morgue = 6
	access_tox = 7
	access_tox_storage = 8
	access_medlab = 9
	access_medical_lockers = 10
	access_research_director = 11
	access_maint_tunnels = 12
	access_external_airlocks = 13 // Unused. Most are all- or maintenance access these days.
	access_emergency_storage = 14
	access_change_ids = 15
	access_ai_upload = 16
	access_teleporter = 17
	access_eva = 18
	access_heads = 19 // Mostly just the bridge.
	access_captain = 20
	access_all_personal_lockers = 21 // Unused. Personal lockers are always linked to ID that was swiped first.
	access_chapel_office = 22
	access_tech_storage = 23
	access_research = 24
	access_bar = 25
	access_janitor = 26
	access_crematorium = 27
	access_kitchen = 28
	access_robotics = 29
	access_hangar = 30 // Unused. Theoretically the pod hangars, but not implemented as such in practice.
	access_cargo = 31 // QM.
	access_construction = 32 // Unused.
	access_chemistry = 33
	access_dwaine_superuser = 34 // So it's not the same as the RD's office and locker.
	access_hydro = 35
	access_mail = 36 // Unused.
	access_maxsec = 37 // The HoS' armory.
	access_securitylockers = 38
	access_carrypermit = 39 // Are allowed to carry sidearms as far as guardbuddies and secbots are concerned.
	access_engineering = 40 // General engineering area and substations.
	access_engineering_storage = 41 // Main metal/tool storage things.
	access_engineering_eva = 42 // Engineering space suits. Currently unused.
	access_engineering_power = 43 // APCs and related supplies.
	access_engineering_engine = 44 // Engine room.
	access_engineering_mechanic = 45 // Electronics lab.
	access_engineering_atmos = 46 // Engineering's supply of gas canisters.
	access_engineering_control = 48 // Engine control room.
	access_engineering_chief = 49 // CE's office.

	access_mining_shuttle = 47
	access_mining = 50
	access_mining_outpost = 51

	access_syndicate_shuttle = 52 // Also to the listening post.
	access_medical_director = 53
	access_head_of_personnel = 55

	access_special_club = 54 //Shouldnt be used for general gameplay. Used for adminevents.

/obj/var/list/req_access = null
/obj/var/req_access_txt = "0"
/obj/var/req_only_one_required = 0
/obj/New()

	if(src.req_access_txt && src.req_access_txt != "0")
		var/req_access_str = params2list(req_access_txt)
		req_access = list()
		for(var/x in req_access_str)
			var/n = text2num(x)
			if(n)
				req_access += n
	..()

//returns 1 if this mob has sufficient access to use this object
/obj/proc/allowed(mob/M, acceptIfAny=0)
	//check if it doesn't require any access at all
	if (src.check_access(null))
		return 1
	if (M && ismob(M))
		if (src.check_access(M.equipped(), acceptIfAny))
			return 1
		if (ishuman(M))
			var/mob/living/carbon/human/H = M
			//if they are holding or wearing a card that has access, that works
			if (src.check_access(H.wear_id, acceptIfAny))
				return 1
		else if (issilicon(M))
			var/mob/living/silicon/S = M
			if (src.check_access(S.botcard, acceptIfAny))
				return 1
	return 0


/obj/proc/check_access(obj/item/I, acceptAny=0)
	if(!src.req_access) //no requirements
		return 1
	if(!istype(src.req_access, /list)) //something's very wrong
		return 1

	if (istype(I, /obj/item/device/pda2))
		var/obj/item/device/pda2/P = I
		if (P.ID_card)
			I = P.ID_card
	var/obj/item/card/id/ID = I
	if (!istype(ID))
		return 0
	var/list/L = src.req_access
	if(!L.len) //no requirements
		return 1
	if(!ID.access) //not ID or no access
		return 0

	if (acceptAny)
		for(var/req in src.req_access)
			if (req in ID.access)
				return 1
		return 0
	else
		for(var/req in src.req_access)
			if(!(req in ID.access)) //doesn't have this access
				return 0
	return 1

// I moved all the duplicate definitions from jobs.dm to this global lookup proc.
// Advantages: can be used by other stuff (bots etc), and there's less code to maintain (Convair880).
/proc/get_access(job)
	switch(job)
		///////////////////////////// Heads of staff
		if("Captain")
			return get_all_accesses()
		if("Head of Personnel")
			return list(access_security, access_carrypermit, access_brig, access_forensics_lockers, access_armory,
						access_tox, access_tox_storage, access_chemistry, access_medical, access_medlab,
						access_emergency_storage, access_change_ids, access_eva, access_heads, access_head_of_personnel, access_medical_lockers,
						access_all_personal_lockers, access_tech_storage, access_maint_tunnels, access_bar, access_janitor,
						access_crematorium, access_kitchen, access_robotics, access_cargo,
						access_research, access_hydro, access_mail, access_ai_upload)
		if("Head of Security")
			if (map_setting == "DESTINY")
				var/list/hos_access = get_all_accesses()
				hos_access += access_maxsec
				return hos_access
			return list(access_security, access_carrypermit, access_maxsec, access_brig, access_securitylockers, access_forensics_lockers, access_armory,
						access_tox, access_tox_storage, access_chemistry, access_medical, access_medlab,
						access_emergency_storage, access_change_ids, access_eva, access_heads, access_medical_lockers,
						access_all_personal_lockers, access_tech_storage, access_maint_tunnels, access_bar, access_janitor,
						access_crematorium, access_kitchen, access_robotics, access_cargo,
						access_research, access_dwaine_superuser, access_hydro, access_mail, access_ai_upload)
		if("Research Director")
			return list(access_research, access_research_director, access_dwaine_superuser,
						access_tech_storage, access_maint_tunnels, access_heads, access_eva, access_tox,
						access_tox_storage, access_chemistry, access_teleporter, access_ai_upload)
		if("Medical Director", "Head Surgeon")
			return list(access_robotics, access_medical, access_morgue,
						access_maint_tunnels, access_tech_storage, access_medical_lockers,
						access_medlab, access_heads, access_eva, access_medical_director, access_ai_upload)
		if("Chief Engineer")
			return list(access_engineering, access_maint_tunnels, access_external_airlocks,
						access_tech_storage, access_engineering_storage, access_engineering_eva, access_engineering_atmos,
						access_engineering_power, access_engineering_engine, access_mining_shuttle,
						access_engineering_control, access_engineering_mechanic, access_engineering_chief, access_mining, access_mining_outpost,
						access_heads, access_ai_upload, access_construction, access_eva, access_cargo, access_hangar)
		if("Head of Mining", "Mining Supervisor")
			return list(access_engineering, access_maint_tunnels, access_external_airlocks,
						access_engineering_eva, access_mining_shuttle, access_mining,
						access_mining_outpost, access_hangar, access_heads, access_ai_upload, access_construction, access_eva)

		///////////////////////////// Security
		if("Security Officer")
			if (map_setting == "DESTINY") // trying out giving them more access for RP
				return list(access_security, access_brig, access_forensics_lockers, access_armory,
					access_medical, access_medlab, access_morgue, access_securitylockers,
					access_tox, access_tox_storage, access_chemistry, access_carrypermit,
					access_emergency_storage, access_chapel_office, access_kitchen, access_medical_lockers,
					access_bar, access_janitor, access_crematorium, access_robotics, access_cargo, access_construction, access_hydro, access_mail,
					access_engineering, access_maint_tunnels, access_external_airlocks,
					access_tech_storage, access_engineering_storage, access_engineering_eva,
					access_engineering_power, access_engineering_engine, access_mining_shuttle,
					access_engineering_control, access_engineering_mechanic, access_mining, access_mining_outpost,
					access_research, access_engineering_atmos, access_hangar)
			return list(access_security, access_carrypermit, access_securitylockers, access_brig, access_maint_tunnels, access_medical, access_morgue, access_crematorium, access_research)
		if("Vice Officer")
			return list(access_security, access_carrypermit, access_securitylockers, access_brig, access_maint_tunnels,access_hydro,access_bar,access_kitchen)
		if("Detective", "Forensic Technician")
			return list(access_brig, access_carrypermit, access_security, access_forensics_lockers, access_morgue, access_maint_tunnels, access_crematorium, access_medical, access_research)
		if("Lawyer")
			return list(access_maint_tunnels, access_security, access_brig)

		///////////////////////////// Medical
		if("Medical Doctor")
			return list(access_medical, access_medical_lockers, access_morgue, access_maint_tunnels)
		if("Geneticist")
			return list(access_medical, access_medical_lockers, access_morgue, access_medlab, access_maint_tunnels)
		if("Roboticist")
			return list(access_robotics, access_tech_storage, access_medical, access_medical_lockers, access_morgue, access_maint_tunnels)
		if("Pharmacist")
			return list(access_research,access_tech_storage, access_maint_tunnels, access_chemistry,
						access_medical_lockers, access_medical, access_morgue)
		if("Medical Assistant")
			return list(access_maint_tunnels, access_tech_storage, access_medical, access_morgue)

		///////////////////////////// Science
		if("Scientist")
			return list(access_tox, access_tox_storage, access_research, access_chemistry)
		if("Chemist")
			return list(access_research, access_chemistry)
		if("Toxins Researcher")
			return list(access_research, access_tox, access_tox_storage)
		if("Research Assistant")
			return list(access_maint_tunnels, access_tech_storage, access_research)

		//////////////////////////// Engineering
		if("Mechanic")
			return list(access_maint_tunnels, access_external_airlocks,
						access_tech_storage,access_engineering_mechanic,access_engineering_power)
		if("Atmospheric Technician")
			return list(access_maint_tunnels, access_external_airlocks, access_construction,
						access_eva, access_engineering, access_engineering_storage, access_engineering_eva, access_engineering_atmos)
		if("Engineer")
			return list(access_engineering,access_maint_tunnels,access_external_airlocks,
						access_engineering_storage,access_engineering_atmos,access_engineering_engine,access_engineering_power)
		if("Miner")
			return list(access_maint_tunnels, access_external_airlocks,
						access_engineering_eva, access_mining_shuttle, access_mining,
						access_mining_outpost, access_hangar)
		if("Quartermaster")
			return list(access_maint_tunnels, access_cargo, access_hangar)
		if("Construction Worker")
			return list(access_engineering,access_maint_tunnels,access_external_airlocks,
						access_engineering_storage,access_engineering_atmos,access_engineering_engine,access_engineering_power)

		///////////////////////////// Civilian
		if("Chaplain")
			return list(access_morgue, access_chapel_office, access_crematorium)
		if("Janitor")
			return list(access_janitor, access_maint_tunnels, access_medical, access_morgue, access_crematorium)
		if("Botanist", "Apiculturist")
			return list(access_maint_tunnels, access_hydro)
		if("Chef", "Sous-Chef")
			return list(access_kitchen)
		if("Barman")
			return list(access_bar)
		if("Waiter")
			return list(access_bar, access_kitchen)
		if("Clown", "Boxer", "Barber")
			return list(access_maint_tunnels)
		if("Assistant", "Staff Assistant", "Technical Assistant")
			return list(access_maint_tunnels, access_tech_storage)
		if("Mailman")
			return list(access_maint_tunnels, access_mail)

		//////////////////////////// Other or gimmick
		if("Rescue Worker")
			return get_all_accesses()
		if("VIP")
			return list(access_heads, access_carrypermit) // Their cane is contraband.
		if("Space Cowboy")
			return list(access_maint_tunnels, access_carrypermit)
		if("Club member")
			return list(access_special_club)
		if("Inspector")
			return list(access_security, access_tox, access_tox_storage, access_chemistry, access_medical, access_medlab,
						access_emergency_storage, access_eva, access_heads, access_tech_storage, access_maint_tunnels, access_bar, access_janitor,
						access_kitchen, access_robotics, access_cargo, access_research, access_hydro)

		else
			return list()

/proc/get_all_accesses()
	return list(access_security, access_brig, access_forensics_lockers, access_armory,
	            access_medical, access_medlab, access_morgue, access_securitylockers,
	            access_tox, access_tox_storage, access_chemistry, access_carrypermit,
	            access_emergency_storage, access_change_ids, access_ai_upload,
	            access_teleporter, access_eva, access_heads, access_captain, access_all_personal_lockers, access_head_of_personnel,
	            access_chapel_office, access_kitchen, access_medical_lockers,
	            access_bar, access_janitor, access_crematorium, access_robotics, access_cargo, access_construction, access_hydro, access_mail,
	            access_engineering, access_maint_tunnels, access_external_airlocks,
	            access_tech_storage, access_engineering_storage, access_engineering_eva,
	            access_engineering_power, access_engineering_engine, access_mining_shuttle,
	            access_engineering_control, access_engineering_mechanic, access_engineering_chief, access_mining, access_mining_outpost,
	            access_research, access_research_director, access_dwaine_superuser, access_engineering_atmos, access_hangar, access_medical_director, access_special_club)

var/list/access_name_lookup //Generated at round start.

//Build the access_name_lookup table, to associate descriptions of accesses with their numerical value.
/proc/generate_access_name_lookup()
	if (access_name_lookup)
		return

	access_name_lookup = list()
	var/list/accesses = get_all_accesses()
	for (var/accessNum in accesses)
		access_name_lookup += "[get_access_desc(accessNum)]"

	access_name_lookup = sortList(access_name_lookup) //Make the list all nice and alphabetical.

	for (var/accessNum in accesses)
		access_name_lookup["[get_access_desc(accessNum)]"] = accessNum

/proc/get_access_desc(A)
	switch(A)
		if(access_cargo)
			return "Cargo Bay"
		if(access_security)
			return "Security"
		if(access_forensics_lockers)
			return "Forensics"
		if(access_securitylockers)
			return "Security Equipment"
		if(access_medical)
			return "Medical"
		if(access_medical_lockers)
			return "Medical Equipment"
		if(access_medlab)
			return "Med-Sci/Genetics"
		if(access_morgue)
			return "Morgue"
		if(access_tox)
			return "Toxins Research"
		if(access_tox_storage)
			return "Toxins Storage"
		if(access_chemistry)
			return "Chemical Lab"
		if(access_bar)
			return "Bar"
		if(access_janitor)
			return "Janitorial Equipment"
		if(access_maint_tunnels)
			return "Maintenance"
		if(access_external_airlocks)
			return "External Airlock"
		if(access_emergency_storage)
			return "Emergency Storage"
		if(access_change_ids)
			return "ID Computer"
		if(access_ai_upload)
			return "AI Upload"
		if(access_teleporter)
			return "Teleporter"
		if(access_eva)
			return "EVA"
		if(access_heads)
			return "Head's Quarters/Bridge"
		if(access_captain)
			return "Captain's Quarters"
		if(access_all_personal_lockers)
			return "Personal Locker Master Key"
		if(access_chapel_office)
			return "Chaplain's Office"
		if(access_tech_storage)
			return "Technical Storage"
		if(access_crematorium)
			return "Crematorium"
		if(access_armory)
			return "Armory (Command Staff)"
		if(access_maxsec)
			return "Armory (Head of Security)"
		if(access_construction)
			return "Construction Site"
		if(access_kitchen)
			return "Kitchen"
		if(access_hydro)
			return "Hydroponics"
		if(access_mail)
			return "Mailroom"
		if(access_research)
			return "Research Sector"
		if(access_research_director)
			return "Research Director's Office"
		if(access_engineering)
			return "Engineering"
		if(access_engineering_storage)
			return "Engineering Storage"
		if(access_engineering_eva)
			return "Engineering EVA"
		if(access_engineering_power)
			return "Electrical Equipment (APCs)"
		if(access_engineering_engine)
			return "Engine Room"
		if(access_engineering_mechanic)
			return "Mechanical Lab"
		if(access_engineering_atmos)
			return "Engineering Gas Storage/Atmospherics"
		if(access_mining_shuttle)
			return "Mining Outpost Shuttle"
		if(access_engineering_control)
			return "Engine Control Room"
		if(access_engineering_chief)
			return "Chief Engineer's Office"
		if(access_mining)
			return "Mining Department"
		if(access_mining_outpost)
			return "Mining Outpost"
		if(access_hangar)
			return "Hangar"
		if(access_carrypermit)
			return "Firearms Carry Permit"
		if(access_medical_director)
			return "Medical Director's Office"
		if(access_robotics)
			return "Robotics"
		if(access_head_of_personnel)
			return "Head of Personnel's Office"
		if(access_dwaine_superuser)
			return "DWAINE Superuser"