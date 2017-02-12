//Contains the areas used on the station
//Generally we would not want to use the tab type path however in this case as areas dont really have any special code and they are all in this folder its fine

/area/station
	name = "Station"
	icon = 'icons/turf/areas_station.dmi'

	command
		default_vent_id = "Command_Vent"
		default_scrubber_id = "Command_Scrubber"

		bridge
			name = "Bridge"
			icon_state = "bridge"
			default_access_req = access_bridge_area

		vault
			name = "Vault"
			icon_state = "bridge"
			default_access_req = access_bridge_area

		captain
			name = "Captain's Office"
			icon_state = "captain"
			default_access_req = access_captain_area

		hop
			name = "Head of Personnel's Office"
			icon_state = "hop"
			default_access_req = access_hop_area

		borg
			name = "Cyborg Storage"
			icon_state = "ai_borgs"
			default_access_req = access_ai_area

		eva
			name = "EVA"
			icon_state = "eva"
			default_access_req = access_eva_area


	//General Civi areas not part of a department like the bar/toilets/ect
	general
		default_vent_id = "Bar_Vent"
		default_scrubber_id = "Bar_Scrubber"

		bar
			name = "Bar"
			icon_state = "bar"
			default_access_req = access_bar_area

		diner
			name = "Diner"
			icon_state = "bar"

		kitchen
			name = "Kitchen"
			icon_state = "kitchen"
			default_access_req = access_kitchen_area

		rec
			name = "Rec Room"
			icon_state = "kitchen"

		hydro
			name = "Hydroponics"
			icon_state = "hydro"
			default_access_req = access_botany_area
		park
			name = "McGriff Station Park"
			icon_state = "park"

		toilets
			name = "Toilets"
			icon_state = "toilet"

		assistant
			name = "Assistant Storage"
			icon_state = "astorage"
			default_access_req = access_maint_tunnels_area

		janitor
			name = "Custodial Closet"
			icon_state = "janitor"
			default_access_req = access_janitor_area

		theater
			name = "Theatre"
			icon_state = "theatre"
			default_access_req = access_theater_area

		photo
			name = "Photo Lab"
			icon_state = "library"
			default_vent_id = "Tox_Vent"
			default_scrubber_id = "Tox_Scrubber"
			default_access_req = access_library_area

		darkroom
			name = "Dark Room"
			icon_state = "library_office"
			default_access_req = access_library_area
			default_vent_id = "Tox_Vent"
			default_scrubber_id = "Tox_Scrubber"

		lawyer
			name = "Legal Office"
			default_access_req = access_legel_area
			default_vent_id = "Command_Vent"
			default_scrubber_id = "Command_Scrubber"
			one
				icon_state = "lawyer_1"
			two
				icon_state = "lawyer_2"

		fitness
			name = "Fitness Room"
			icon_state = "fitness"
			default_vent_id = "Arrivals_Vent"
			default_scrubber_id = "Arrivals_Scrubber"


		crew
			default_vent_id = "Arrivals_Vent"
			default_scrubber_id = "Arrivals_Scrubber"

			quarters
				name = "Crew Quarters"
				icon_state = "crew"

			locker
				name = "Locker Room"
				icon_state = "locker"
				default_vent_id = "Bar_Vent"
				default_scrubber_id = "Bar_Scrubber"

			room1
				name = "Room 1"
				icon_state = "room"

			room2
				name = "Room 2"
				icon_state = "room"

			room3
				name = "Room 3"
				icon_state = "room"

			room4
				name = "Room 4"
				icon_state = "room"

			room5
				name = "Room 5"
				icon_state = "room"

			room6
				name = "Room 6"
				icon_state = "room"

			room7
				name = "Room 7"
				icon_state = "room"

			room8
				name = "Room 8"
				icon_state = "room"

		chapel
			default_vent_id = "Med_Vent"
			default_scrubber_id = "Med_Scrubber"

			main
				name = "Chapel"
				icon_state = "chapel"

			office
				name = "Chapel Office"
				icon_state = "chapel_office"
				default_access_req = access_chapel_area

	medical
		default_vent_id = "Med_Vent"
		default_scrubber_id = "Med_Scrubber"

		medbay
			name = "Medbay"
			icon_state = "medbay"
			default_access_req = access_medbay_area

		cmo
			name = "Chief Medical Officer's office"
			icon_state = "cmo"
			default_access_req = access_cmo_area

		genetics
			name = "Genetics"
			icon_state = "genetics"
			default_access_req = access_genetics_area

		surgery
			name = "Surgery"
			icon_state = "surgery"
			default_access_req = access_surgery_area

		exam
			name = "Exam Room"
			icon_state = "exam_room"
			default_access_req = access_exam_room_area

		storage
			name = "Medical Storage"
			icon_state = "med_storage"
			default_access_req = access_medbay_storage_area

		virology
			name = "Virology"
			icon_state = "virology"
			default_access_req = access_viro_area

		morgue
			name = "Morgue"
			icon_state = "morgue"
			default_access_req = access_morgue_area


	security
		default_vent_id = "Command_Vent"
		default_scrubber_id = "Command_Scrubber"

		brig
			name = "Brig"
			icon_state = "brig"
			default_access_req = access_security_area

		office
			name = "Security Office"
			icon_state = "security"
			default_access_req = access_sec_gear_area

		armory
			name = "Armory"
			icon_state = "armory"
			default_access_req = access_armory_area

		detective
			name = "Detective's Office"
			icon_state = "detective"
			default_access_req = access_detective_area

		hos
			name = "Head of Security's Office"
			icon_state = "sec_hos"
			default_access_req = access_hos_area

		courtroom
			name = "Courtroom"
			icon_state = "court"
			default_access_req = access_courtroom_area

		arrivals_checkpoint
			name = "Docking Bay Security Checkpoint"
			icon_state = "checkpoint"
			default_access_req = access_security_area
			default_vent_id = "Arrivals_Vent"
			default_scrubber_id = "Arrivals_Scrubber"


		prison
			default_access_req = access_security_area
			default_vent_id = "Prison_Vent"
			default_scrubber_id = "Prison_Scrubber"

			office
				name = "Prison Security"
				icon_state = "prison"

			solars
				name = "Prison Maintainance"
				icon_state = "prison_maint"

			solar_panel
				name = "Prison Solars"
				icon_state = "prison_solars"
				requires_power = 0
				luminosity = 1
				lighting_use_dynamic = 0
				default_access_req = null

			general
				name = "Prison"
				icon_state = "prison_general"
				default_access_req = null


	tox
		default_vent_id = "Tox_Vent"
		default_scrubber_id = "Tox_Scrubber"

		science
			name = "Toxins Lab"
			icon_state = "science"
			default_access_req = access_science_area

		server
			name = "Server Room"
			icon_state = "server"
			default_access_req = access_rd_lab_area

		chem
			name = "Chemistry Lab"
			icon_state = "chemistry"
			default_access_req = access_chemistry_area

		mixing
			name = "Gas Mixing Lab"
			icon_state = "mixing"
			default_access_req = access_toxins_area

		robotics
			name = "Robotics Lab"
			icon_state = "robotics"
			default_access_req = access_robotics_area

		research
			name = "Research Lab"
			icon_state = "research"
			default_access_req = access_rd_lab_area

		xeno
			name = "Xeno Lab"
			icon_state = "xeno"
			default_access_req = access_xeno_area

		gateway
			name = "Teleportation Lab"
			icon_state = "gateway"
			default_access_req = access_gateway_area

		rd
			name = "Research Director's Office"
			icon_state = "rd"
			default_access_req = access_rd_office_area

		misc
			name = "Misc Lab"
			icon_state = "misc"
			default_access_req = access_science_misc_area

		storage
			name = "Gas Storage"
			icon_state = "tox_storage"
			default_access_req = access_toxins_storage_area

		test
			name = "Test Chamber"
			icon_state = "tox_test"

		teleporter
			name = "Teleporter"
			icon_state = "teleporter"
			default_access_req = access_teleporter_area


	supply
		default_vent_id = "Eng_Vent"
		default_scrubber_id = "Eng_Scrubber"

		cargo
			name = "Cargo Bay"
			icon_state = "cargo"
			default_access_req = access_cargo_bay_area

		cargo_office
			name = "Quartermaster"
			icon_state = "qm"
			default_access_req = access_cargo_office_area

		mining
			name = "Mining Dock"
			icon_state = "mining"
			default_access_req = access_mining_bay_area

		mining_outpost
			name = "Mining Outpost"
			icon_state = "mining"
			default_access_req = access_mining_bay_area
			default_vent_id = "Outpost_Vent"
			default_scrubber_id = "Outpost_Scrubber"


	engineering
		default_vent_id = "Eng_Vent"
		default_scrubber_id = "Eng_Scrubber"

		engine
			name = "Engineering"
			icon_state = "engine"
			default_access_req = access_engineering_area

		ce
			name = "Chief Engineer's Office"
			icon_state = "ce"
			default_access_req = access_ce_area

		lobby
			name = "Engineering Lobby"
			icon_state = "atmos"
			default_access_req = access_lobby

			breakroom
				name = "Engineering Breakroom"

		atmospherics
			name = "Atmospherics"
			icon_state = "atmos"
			default_access_req = access_atmosia_area

			LAC1
			LAC2
			LAC3
			LAC4

		solar
			default_vent_id = "Solar_Vent"
			default_scrubber_id = "Solar_Scrubber"

			control
				default_access_req = access_engineering_area
				foreport
					name = "Fore Port Solar Control"
					icon_state = "solar-foreport-c"

				aftport
					name = "Aft Port Solar Control"
					icon_state = "solar-aftport-c"

				forestarboard
					name = "Fore Starboard Solar Control"
					icon_state = "solar-forestar-c"

				aftstarboard
					name = "Aft Starboard Solar Control"
					icon_state = "solar-aftstar-c"

			panel//These have no power or access levels, they are outside in space
				requires_power = 0
				luminosity = 1
				lighting_use_dynamic = 0

				foreport
					name = "Fore Port Solar Array"
					icon_state = "solar-foreport"

				aftport
					name = "Aft Port Solar Array"
					icon_state = "solar-aftport"

				forestarboard
					name = "Fore Starboard Solar Array"
					icon_state = "solar-forestar"

				aftstarboard
					name = "Aft Starboard Solar Array"
					icon_state = "solar-aftstar"

	starship

		bridge
			name = "Starship Bridge"
			icon_state = "engine"
			default_access_req = access_starship_command

		eva
			name = "Starship EVA"
			icon_state = "engine"

		boarding
			name = "Starship Access"
			icon_state = "engine"
			default_access_req = access_starship

		crew
			name = "Starship Friendzone"
			icon_state = "engine"
			default_access_req = access_starship

		cargo
			name = "Starship Storage"
			icon_state = "engine"
			default_access_req = access_starship
		medical
			name = "Starship Sickbay"
			icon_state = "engine"
			default_access_req = access_starship
		bar
			name = "Starship Brewery"
			icon_state = "engine"
			default_access_req = access_bar_area

		kitchen
			name = "Starship Mess-hall"
			icon_state = "engine"
			default_access_req = access_kitchen_area

		sec
			name = "Starship Detainment"
			icon_state = "engine"
			default_access_req = access_starship
			cell1
				name = "Solitary Cell #1"
				icon_state = "engine"
				default_access_req = access_starship

		scoutship
			name = "Scoutship"
			icon_state = "engine"
			default_access_req = access_starship
/area/turret_protected/ai_upload
	name = "AI Upload Chamber"
	icon_state = "ai_upload"
	icon = 'icons/turf/areas_station.dmi'
	default_access_req = access_ai_area
	default_vent_id = "Command_Vent"
	default_scrubber_id = "Command_Scrubber"


/area/turret_protected/ai
	name = "AI Chamber"
	icon_state = "ai"
	icon = 'icons/turf/areas_station.dmi'
	default_access_req = access_ai_area
	default_vent_id = "Command_Vent"
	default_scrubber_id = "Command_Scrubber"









