/obj/machinery/atmospherics/unary/local_atmos_connection
	name = "Local Atmospheric Connection"
	desc = "Connects a pipe network to the understation network and receives gas."
	icon = 'icons/obj/atmospherics/local_machines.dmi'
	icon_state = "distro_controller"
	density = 1
	use_power = USE_POWER_IDLE
	health = 600
	max_health = 600
	var/id = "Station_Distro"//Who to connect to


	update_icon()
		if(!node)
			icon_state = "distro_controller_node"
		else if(stat & (NOPOWER|BROKEN))
			icon_state = "distro_controller_off"
		else
			icon_state = "distro_controller"
		return



/obj/machinery/atmospherics/unary/local_atmos_connection/waste
	name = "Local Atmospheric Waste Connection"
	id = "Station_Waste"
	icon_state = "waste_controller"


	update_icon()
		if(!node)
			icon_state = "waste_controller_node"
		else if(stat & (NOPOWER|BROKEN))
			icon_state = "waste_controller_off"
		else
			icon_state = "waste_controller"
		return



/obj/machinery/atmospherics/unary/local_atmos_connection/scrubber
	name = "Local Scrubber Connection"
	desc = "Connects a pipe network to the local scrubber network."
	icon_state = "waste_controller"
	id = null


	New()
		..()
		var/area/A = get_area(loc)
		if(A.master)
			A = A.master
		if(!id)
			id = A.default_scrubber_id


	update_icon()
		if(!node)
			icon_state = "waste_controller_node"
		else if(stat & (NOPOWER|BROKEN))
			icon_state = "waste_controller_off"
		else
			icon_state = "waste_controller"
		return



/obj/machinery/atmospherics/unary/local_atmos_connection/vent
	name = "Local Vent Connection"
	desc = "Connects a pipe network to the local vent network."
	id = null
	var/obj/machinery/atmospherics/local_vent/list/vents = list()


	New()
		..()
		var/area/A = get_area(loc)
		if(A.master)
			A = A.master
		if(!id)
			id = A.default_vent_id



/obj/machinery/atmospherics/unary/local_atmos_connection/output
	name = "Local Atmospheric Output"
	desc = "Connects a pipe network to the understation network and inputs gas."

	var/list/obj/machinery/atmospherics/unary/local_atmos_connection/lacs = list()
	var/target_pressure = 4500//What pressure we output at


	initialize()
		..()
		//Search for all LACs and if the ID matches then connect us
		for(var/obj/machinery/atmospherics/unary/local_atmos_connection/LAC in world)
			if(istype(LAC, /obj/machinery/atmospherics/unary/local_atmos_connection/output))
				continue
			if(LAC.id != src.id || LAC == src)
				continue
			lacs += LAC
		return


	process()
		..()
		if(!lacs.len)
			return

		var/moles_allowed = air_contents.total_moles()/lacs.len

		if(!moles_allowed)
			return

		for(var/obj/machinery/atmospherics/unary/local_atmos_connection/LAC in lacs)
			if(!LAC.air_contents || !LAC.network)
				continue
			if(LAC.air_contents.return_pressure() >= target_pressure)
				//No need to mix if target is already full!
				return 1
			LAC.air_contents.merge(air_contents.remove(moles_allowed))//Add the gas to the lac
			LAC.network.update = 1



/obj/machinery/atmospherics/unary/local_atmos_connection/output/waste
	name = "Local Atmospheric Waste Output"
	id = "Station_Waste"
	icon_state = "waste_controller"


	update_icon()
		if(!node)
			icon_state = "waste_controller_node"
		else if(stat & (NOPOWER|BROKEN))
			icon_state = "waste_controller_off"
		else
			icon_state = "waste_controller"
		return