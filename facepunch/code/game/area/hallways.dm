/area/station/hallway
	name = "Hallway"
	icon = 'icons/turf/areas_tunnels_hallways.dmi'

	//The large ones
	major
		central_primary
			name = "Central Primary Hallway"
			icon_state = "central_primary"
			default_vent_id = "Bar_Vent"
			default_scrubber_id = "Bar_Scrubber"

		port_primary
			name = "Port Primary Hallway"
			icon_state = "port_primary"
			default_vent_id = "Arrivals_Vent"
			default_scrubber_id = "Arrivals_Scrubber"

		fore_primary
			name = "Fore Primary Hallway"
			icon_state = "fore_primary"
			default_vent_id = "Command_Vent"
			default_scrubber_id = "Command_Scrubber"

		aft_primary
			name = "Aft Primary Hallway"
			icon_state = "aft_primary"
			default_vent_id = "Eng_Vent"
			default_scrubber_id = "Eng_Scrubber"

		starboard_primary
			name = "Starboard Primary Hallway"
			icon_state = "starboard_primary"
			default_vent_id = "Med_Vent"
			default_scrubber_id = "Med_Scrubber"

		arrivals_hallway
			name = "Arrivals Hallway"
			icon_state = "arrival_hall"
			default_vent_id = "Arrivals_Vent"
			default_scrubber_id = "Arrivals_Scrubber"


	//Smaller ones
	minor
		central_sub
			name = "Central Sub Hallway"
			icon_state = "central_sub"
			default_vent_id = "Bar_Vent"
			default_scrubber_id = "Bar_Scrubber"
