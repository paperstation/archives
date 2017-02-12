obj/machinery/atmospherics/unary/nitrogen_generator
	icon = 'nitrogen_generator.dmi'
	icon_state = "intact_on"
	density = 1

	name = "Nitrogen Generator"
	desc = "It generates nitrogen! Surprising, huh?"

	dir = NORTH
	initialize_directions = NORTH

	var/on = 1 //yes it starts online

	var/nitrogen_content = 500

	update_icon()
		if(node)
			icon_state = "intact_[on?("on"):("off")]"
		else
			icon_state = "exposed_on"

			on = 0

		return

	New()
		..()

		air_contents.volume = 50

	process()
		..()
		if(!on)
			return 0

		var/total_moles = air_contents.total_moles()

		if(total_moles < nitrogen_content)
			var/current_heat_capacity = air_contents.heat_capacity()

			var/added_nitrogen = nitrogen_content - total_moles

			air_contents.temperature = (current_heat_capacity*air_contents.temperature + 20*added_nitrogen*T0C)/(current_heat_capacity+20*added_nitrogen)
			air_contents.nitrogen += added_nitrogen

			if(network)
				network.update = 1

		return 1