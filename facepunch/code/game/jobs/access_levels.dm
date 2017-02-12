/var/const
//1-10 Command
	access_bridge_area = 1//Comms, bridge, meeting room
	access_hop_area = 2//HoP office
	access_captain_area = 3//Captain office, captain bedroom
	access_id_computer = 4//id computer access
	access_ai_area = 5//AI upload, and borg funhouse
	access_cyborg_control = 6//Cyborg covers and killswitch
	access_eva_area = 7//EVA
	access_personal_lockers = 8//1984
	access_vault_area = 9

//11-20 Security
	access_security_area = 11//Opens general doors
	access_sec_gear_area = 12//Opens lockers/crates
	access_cells_area = 13 //Cell timers/lockers/doors
	access_armory_area = 14 //Opens armory doors and warden gear
	access_detective_area = 15 //Detective's Office
	access_hos_area = 16 //HoS office/gear
	access_courtroom_area = 17 //has to be seperate for legel reasons
	access_secure_maint_area = 18

//21-30 Medical
	access_medbay_area = 21
	access_medbay_storage_area = 22
	access_cmo_area = 23
	access_viro_area = 24
	access_genetics_area = 25
	access_surgery_area = 26
	access_exam_room_area = 27
	access_morgue_area = 28

//31-41 Science
	access_science_area = 31
	access_toxins_area = 32
	access_xeno_area = 33
	access_gateway_area = 34
	access_chemistry_area = 35
	access_rd_office_area = 36
	access_science_misc_area = 37
	access_toxins_storage_area = 38
	access_teleporter_area = 39
	access_rd_lab_area = 40
	access_robotics_area = 41


//71-80 Engineering
	access_maint_tunnels_area = 71
	access_engineering_area = 72
	access_tech_storage_area = 73
	access_secure_tech_storage_area = 74
	access_ce_area = 75
	access_atmosia_area = 76
	access_emergency_area = 77
	access_lobby = 78
//51-60 Civilian
	access_bar_area = 51
	access_kitchen_area = 52
	access_botany_area = 53
	access_chapel_area = 54
	access_janitor_area = 55
	access_library_area = 56
	access_theater_area = 57
	access_legel_area = 58 //lawyers office


//61-70 Cargo Bay/Mining
	access_cargo_bay_area = 61
	access_cargo_office_area = 62
	access_mining_bay_area = 63
	access_mining_asteroid_area = 64


//81-90 Syndicate
	access_syndicate_area = 81


//100+ etc

#ifdef NEWMAP
/proc/get_all_accesses()
	return list(access_bridge_area, access_hop_area, access_captain_area, access_id_computer, access_ai_area, access_cyborg_control, access_eva_area, access_personal_lockers,
			access_security_area, access_sec_gear_area, access_cells_area, access_armory_area, access_detective_area, access_hos_area, access_courtroom_area, access_secure_maint_area,
			access_medbay_area, access_medbay_storage_area, access_cmo_area, access_viro_area, access_genetics_area, access_surgery_area, access_exam_room_area, access_morgue_area,
			access_science_area, access_toxins_area, access_xeno_area, access_gateway_area, access_chemistry_area, access_rd_office_area, access_science_misc_area, access_toxins_storage_area, access_teleporter_area, access_rd_lab_area, access_robotics_area,
			access_bar_area, access_kitchen_area, access_botany_area, access_chapel_area, access_janitor_area, access_library_area, access_theater_area, access_legel_area,
			access_cargo_bay_area, access_cargo_office_area, access_mining_bay_area, access_mining_asteroid_area,
			access_maint_tunnels_area, access_engineering_area, access_tech_storage_area, access_secure_tech_storage_area, access_ce_area, access_atmosia_area, access_lobby, access_emergency_area, access_starship, access_starship_command)


/proc/get_region_accesses(var/code)
	switch(code)
		if(0)
			return get_all_accesses()
		if(1) //command
			return list(access_bridge_area, access_hop_area, access_captain_area, access_id_computer, access_ai_area, access_cyborg_control, access_eva_area, access_personal_lockers)
		if(2) //security
			return list(access_security_area, access_sec_gear_area, access_cells_area, access_armory_area, access_detective_area, access_hos_area, access_courtroom_area, access_secure_maint_area)
		if(3) //medbay
			return list(access_medbay_area, access_medbay_storage_area, access_cmo_area, access_viro_area, access_genetics_area, access_surgery_area, access_exam_room_area, access_morgue_area)
		if(4) //research
			return list(access_science_area, access_toxins_area, access_xeno_area, access_gateway_area, access_chemistry_area, access_rd_office_area, access_science_misc_area, access_toxins_storage_area, access_teleporter_area, access_rd_lab_area, access_robotics_area)
		if(5) //station general
			return list(access_bar_area, access_kitchen_area, access_botany_area, access_chapel_area, access_janitor_area, access_library_area, access_theater_area, access_legel_area)
		if(6) //cargo
			return list(access_cargo_bay_area, access_cargo_office_area, access_mining_bay_area, access_mining_asteroid_area)
		if(7) //engineering and maintenance
			return list(access_maint_tunnels_area, access_engineering_area, access_tech_storage_area, access_secure_tech_storage_area, access_lobby, access_ce_area, access_atmosia_area, access_emergency_area)
		if(8) //starship
			return list(access_starship, access_starship_command)

/proc/get_region_accesses_name(var/code)
	switch(code)
		if(0)
			return "All"
		if(1) //security
			return "Command"
		if(2) //medbay
			return "Security"
		if(3) //research
			return "Medbay"
		if(4) //engineering and maintenance
			return "Research"
		if(5) //command
			return "General"
		if(6) //station general
			return "Cargo"
		if(7) //supply
			return "Engineering"
		if(8) //supply
			return "Starship"

/proc/get_access_desc(A)
	switch(A)
		if(access_cargo_bay_area)
			return "Cargo Bay"
		if(access_security_area)
			return "Security"
		if(access_cells_area)
			return "Holding Cells"
		if(access_courtroom_area)
			return "Courtroom"
		if(access_secure_maint_area)
			return "Security Maintenance"
		if(access_detective_area)
			return "Detective"
		if(access_medbay_area)
			return "Medical"
		if(access_genetics_area)
			return "Genetics Lab"
		if(access_morgue_area)
			return "Morgue"
		if(access_rd_lab_area)
			return "R&D Lab"
		if(access_toxins_storage_area)
			return "Toxins Storage"
		if(access_toxins_area)
			return "Toxins Lab"
		if(access_chemistry_area)
			return "Chemistry Lab"
		if(access_rd_office_area)
			return "Research Director"
		if(access_bar_area)
			return "Bar"
		if(access_janitor_area)
			return "Custodial Closet"
		if(access_engineering_area)
			return "Engineering"
		if(access_maint_tunnels_area)
			return "Maintenance"
		if(access_emergency_area)
			return "Emergency Storage"
		if(access_id_computer)
			return "ID Computer"
		if(access_ai_area)
			return "AI Upload"
		if(access_cyborg_control)
			return "Cyborg Maintenance"
		if(access_teleporter_area)
			return "Teleporter"
		if(access_eva_area)
			return "EVA"
		if(access_bridge_area)
			return "Bridge"
		if(access_captain_area)
			return "Captain"
		if(access_personal_lockers)
			return "Personal Lockers"
		if(access_chapel_area)
			return "Chapel Office"
		if(access_tech_storage_area)
			return "Technical Storage"
		if(access_atmosia_area)
			return "Atmospherics"
		if(access_lobby)
			return "Engineering Lobby"
		if(access_armory_area)
			return "Armory"
		if(access_kitchen_area)
			return "Kitchen"
		if(access_botany_area)
			return "Hydroponics"
		if(access_library_area)
			return "Library"
		if(access_legel_area)
			return "Law Office"
		if(access_robotics_area)
			return "Robotics"
		if(access_viro_area)
			return "Virology"
		if(access_cmo_area)
			return "Chief Medical Officer"
		if(access_surgery_area)
			return "Surgery"
		if(access_theater_area)
			return "Theatre"
		if(access_science_area)
			return "Science"
		if(access_mining_bay_area)
			return "Mining Bay"
		if(access_mining_asteroid_area)
			return "Mining Asteroid"
		if(access_vault_area)
			return "Main Vault"
		if(access_xeno_area)
			return "Xenobiology Lab"
		if(access_hop_area)
			return "Head of Personnel"
		if(access_hos_area)
			return "Head of Security"
		if(access_ce_area)
			return "Chief Engineer"
		if(access_gateway_area)
			return "Gateway Laboratory"
		if(access_cells_area)
			return "Brig"
		if(access_starship)
			return "Starship General"
		if(access_starship_command)
			return "Starship Command"

/proc/get_centcom_access_desc(A)
	switch(A)
		if(access_cent_general)
			return "Code Grey"
		if(access_cent_thunder)
			return "Code Yellow"
		if(access_cent_storage)
			return "Code Orange"
		if(access_cent_living)
			return "Code Green"
		if(access_cent_medical)
			return "Code White"
		if(access_cent_teleporter)
			return "Code Blue"
		if(access_cent_specops)
			return "Code Black"
		if(access_cent_creed)
			return "Code Silver"
		if(access_cent_captain)
			return "Code Gold"

/proc/get_all_jobs()
	return list("Assistant", "Captain", "Head of Personnel", "Bartender", "Chef", "Botanist", "Quartermaster",
				"Shaft Miner", "Clown", "Mime", "Janitor", "Librarian", "Lawyer", "Chaplain", "Chief Engineer", "Station Engineer",
				"Atmospheric Technician", "Chief Medical Officer", "Medical Doctor", "Chemist", "Geneticist", "Virologist",
				"Research Director", "Scientist", "Roboticist", "Head of Security", "Warden", "Detective", "Security Officer")

/proc/get_all_centcom_jobs()
	return list("VIP Guest","Custodian","Thunderdome Overseer","Intel Officer","Medical Officer","Death Commando","Research Officer","BlackOps Commander","Supreme Commander")

/proc/get_all_centcom_access()
	return list()
/proc/get_centcom_access()
	return list()

/proc/get_all_syndicate_access()
	return list(access_syndicate_area)
#endif