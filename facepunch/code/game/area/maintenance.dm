/area/station/maintenance
	name = "Maintenance"
	icon = 'icons/turf/areas_tunnels_hallways.dmi'
	default_access_req = access_maint_tunnels_area

	medbay_maintenance
		name = "Fore Primary Maintenance"
		icon_state = "med_maint"
		default_vent_id = "Med_Vent"
		default_scrubber_id = "Med_Scrubber"

	chapel_maintenance
		name = "Fore Starboard Primary Maintenance"
		icon_state = "med_maint"
		default_vent_id = "Med_Vent"
		default_scrubber_id = "Med_Scrubber"

	secure_maintenance
		name = "Secure Maintenance"
		icon_state = "secure_maint"
		default_access_req = access_secure_maint_area
		default_vent_id = "Command_Vent"
		default_scrubber_id = "Command_Scrubber"

	library_maintenance
		name = "Central Starboard Secondary Maintenance"
		icon_state = "library_maint"
		default_vent_id = "Tox_Vent"
		default_scrubber_id = "Tox_Scrubber"

	fitness_maintenance
		name = "Port Primary Maintenance"
		icon_state = "fit_maint"
		default_vent_id = "Arrivals_Vent"
		default_scrubber_id = "Arrivals_Scrubber"

	rd_maintenance
		name = "Aft Starboard Primary Maintenance"
		icon_state = "rd_maint"
		default_vent_id = "Tox_Vent"
		default_scrubber_id = "Tox_Scrubber"

	bridge_maintenance
		name = "Fore Secondary Maintenance"
		icon_state = "bridge_maint"
		default_access_req = access_secure_maint_area
		default_vent_id = "Command_Vent"
		default_scrubber_id = "Command_Scrubber"

	security_maintenance
		name = "Fore Port Secondary Maintenance"
		icon_state = "sec_maint"
		default_vent_id = "Command_Vent"
		default_scrubber_id = "Command_Scrubber"

	supply_maintenance
		name = "Supply Maintenance"
		icon_state = "supply_maint"
		default_vent_id = "Eng_Vent"
		default_scrubber_id = "Eng_Scrubber"

	dorms_maintenance
		name = "Port Secondary Maintenance"
		icon_state = "dorms_maint"
		default_vent_id = "Arrivals_Vent"
		default_scrubber_id = "Arrivals_Scrubber"

	engine_maintenance
		name = "Aft Primary Maintenance"
		icon_state = "engine_maint"
		default_vent_id = "Eng_Vent"
		default_scrubber_id = "Eng_Scrubber"

	arrivals_maintenance
		name = "AI Maintenance"
		icon_state = "arrival_maint"
		default_access_req = access_ai_area
		default_vent_id = "Command_Vent"
		default_scrubber_id = "Command_Scrubber"

	pod_maintenance
		name = "Escape Pod Maintenance"
		icon_state = "arrival_maint_2"
		default_vent_id = "Arrivals_Vent"
		default_scrubber_id = "Arrivals_Scrubber"

	central
		name = "Central Maintenance"
		icon_state = "central"
		default_vent_id = "Bar_Vent"
		default_scrubber_id = "Bar_Scrubber"

	central_lower
		name = "Lower Central Maintenance"
		icon_state = "central_low"
		default_vent_id = "Bar_Vent"
		default_scrubber_id = "Bar_Scrubber"

	crew_quarters
		name = "Locker Room Maintenance"
		icon_state = "crew"
		default_vent_id = "Bar_Vent"
		default_scrubber_id = "Bar_Scrubber"

	//Small rooms filled with things like air cans and backup masks, in general should not have many good things in it.
	emergency_storage
		default_access_req = access_emergency_area
		central
			name = "Central Emergency Storage"
			icon_state = "storage_central"
			default_vent_id = "Bar_Vent"
			default_scrubber_id = "Bar_Scrubber"

		arrivals
			name = "Arrivals Emergency Storage"
			icon_state = "arrival_emerg"
			default_vent_id = "Arrivals_Vent"
			default_scrubber_id = "Arrivals_Scrubber"

	incinerator
		name = "Incinerator"
		icon_state = "incinerator"
		default_vent_id = "Tox_Vent"
		default_scrubber_id = "Tox_Scrubber"

	vacant_office_1
		name = "Vacant Office"
		icon_state = "vacant_1"
		default_access_req = access_maint_tunnels_area
		default_vent_id = "Eng_Vent"
		default_scrubber_id = "Eng_Scrubber"

	vacant_office_2
		name = "Vacant Office 2"
		icon_state = "vacant_2"
		default_access_req = access_maint_tunnels_area
		default_vent_id = "Eng_Vent"
		default_scrubber_id = "Eng_Scrubber"

	vacant_office_3
		name = "Vacant Office 3"
		icon_state = "vacant_3"
		default_vent_id = "Command_Vent"
		default_scrubber_id = "Command_Scrubber"

	tech_storage
		name = "Technical Storage"
		icon_state = "tech"
		default_access_req = access_tech_storage_area
		default_vent_id = "Arrivals_Vent"
		default_scrubber_id = "Arrivals_Scrubber"

	secure_tech_storage
		name = "Secure Technical Storage"
		icon_state = "tech_secure"
		default_access_req = access_secure_tech_storage_area
		default_vent_id = "Arrivals_Vent"
		default_scrubber_id = "Arrivals_Scrubber"

	arrivals_tool_storage
		name = "Secondary Tool Storage"
		icon_state = "arrival_tool"
		default_vent_id = "Arrivals_Vent"
		default_scrubber_id = "Arrivals_Scrubber"

	disposals
		name = "Disposals"
		icon_state = "disposal"
		default_vent_id = "Med_Vent"
		default_scrubber_id = "Med_Scrubber"