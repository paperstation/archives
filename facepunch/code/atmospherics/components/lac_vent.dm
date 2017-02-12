//This atmos thing is a vent and scrubber all in one package
//Also it does not use any of the bad radio code and runs off of areas


/obj/machinery/atmospherics/local_vent
	name = "Air Vent"
	desc = "A metal air vent with a pump and filter attached."

	icon = 'icons/obj/atmospherics/local_machines.dmi'
	icon_state = "off"

	level = 1
	use_power = USE_POWER_IDLE
	idle_power_usage = 10

	var/area/initial_loc
	var/welded = 0

	var/open = 0

	//Vent vars
	var/obj/machinery/atmospherics/unary/local_atmos_connection/vent/lac_vent = null
	var/vent_id = null

	var/vent_on = 0
	var/external_pressure_bound = ONE_ATMOSPHERE
	var/internal_pressure_bound = 0

	var/pressure_checks = 1
	//1: Do not pass external_pressure_bound
	//2: Do not pass internal_pressure_bound
	//3: Do not pass either

	//Scrubber vars
	var/obj/machinery/atmospherics/unary/local_atmos_connection/scrubber/lac_scrubber = null
	var/scrubber_id = null

	var/panic = 0 //is this scrubber panicked?
	var/scrubbing = SCRUB_CO2


	var/volume_rate = 120
	var/volume_rate_panic = 2000


	on
		vent_on = 1
		icon_state = "vent"


	New()
		initial_loc = get_area(loc)
		if(initial_loc.master)
			initial_loc = initial_loc.master
		initial_loc.vents += src
		if(!vent_id)
			vent_id = initial_loc.default_vent_id
		if(!scrubber_id)
			scrubber_id = initial_loc.default_scrubber_id
		if(ticker && ticker.current_state == 3)//if the game is running
			src.initialize()
		..()
		return


	update_icon()
		if(welded)
			icon_state = "welded"
			return
		if(!(stat & (NOPOWER|BROKEN)))
			if(panic)
				icon_state = "scrub"
				return
			else if(vent_on)
				icon_state = "vent"
				return
		icon_state = "off"
		return


	initialize()
		..()

		for(var/obj/machinery/atmospherics/unary/local_atmos_connection/vent/LAC in world)
			if(LAC.id != src.vent_id)
				continue
			lac_vent = LAC
			lac_vent.vents += src
			break
		for(var/obj/machinery/atmospherics/unary/local_atmos_connection/scrubber/LAC in world)
			if(LAC.id != src.scrubber_id)
				continue
			lac_scrubber = LAC
			break

		if(initial_loc)
			src.name = "[initial_loc.name] Air Vent #[initial_loc.vent_id]"
			initial_loc.vent_id++
		return

	attack_hand()
		if(!welded)
			if(open)
				for(var/obj/item/W in src)
					W.loc = src.loc

	process()
		..()
		if(stat & (NOPOWER|BROKEN))
			return 0
		if(kill_air)//if air is off then prevent vents from doing things
			return 0
		if(welded)
			return 0

		var/datum/gas_mixture/environment = loc.return_air()
		if(!environment)
			return 0
		if(scrubbing && lac_scrubber && lac_scrubber.air_contents)
			if(!panic)
				var/transfer_moles = min(1, volume_rate/environment.volume)*environment.total_moles()

				//Take a gas sample
				var/datum/gas_mixture/removed = loc.remove_air(transfer_moles)
				if(isnull(removed)) //in space
					return

				//Filter it
				var/datum/gas_mixture/filtered_out = new
				filtered_out.temperature = removed.temperature
				if(scrubbing & SCRUB_O2)
					filtered_out.oxygen = removed.oxygen
					removed.oxygen = 0
				if(scrubbing & SCRUB_N2)
					filtered_out.nitrogen = removed.nitrogen
					removed.nitrogen = 0
				if(scrubbing & SCRUB_PLASMA)
					filtered_out.toxins = removed.toxins
					removed.toxins = 0
				if(scrubbing & SCRUB_CO2)
					filtered_out.carbon_dioxide = removed.carbon_dioxide
					removed.carbon_dioxide = 0

				if(removed.trace_gases.len>0)
					for(var/datum/gas/trace_gas in removed.trace_gases)
						if(istype(trace_gas, /datum/gas/oxygen_agent_b) && (scrubbing & SCRUB_PLASMA))
							removed.trace_gases -= trace_gas
							filtered_out.trace_gases += trace_gas
						else if(istype(trace_gas, /datum/gas/sleeping_agent) && (scrubbing & SCRUB_N2O))
							removed.trace_gases -= trace_gas
							filtered_out.trace_gases += trace_gas

				lac_scrubber.air_contents.merge(filtered_out)
				loc.assume_air(removed)
				if(lac_scrubber.network)
					lac_scrubber.network.update = 1
			else
				//Just draining everything
				var/transfer_moles = environment.total_moles()*(volume_rate_panic/environment.volume)
				lac_scrubber.air_contents.merge(loc.remove_air(transfer_moles))
				if(lac_scrubber.network)
					lac_scrubber.network.update = 1
				return//If we are draining everything then no venting

		//After scrubbing refresh the air then vent
		environment = loc.return_air()
		if(!environment)
			return 0

		if(!panic && vent_on && lac_vent && lac_vent.air_contents)
			var/environment_pressure = environment.return_pressure()
			var/pressure_delta = 10000

			if(pressure_checks&1)
				pressure_delta = min(pressure_delta, (external_pressure_bound - environment_pressure))
			if(pressure_checks&2)
				pressure_delta = min(pressure_delta, (lac_vent.air_contents.return_pressure() - internal_pressure_bound))

			if(pressure_delta > 0)
				if(lac_vent.air_contents.temperature > 0)
					var/transfer_moles = pressure_delta*environment.volume/(lac_vent.air_contents.temperature * R_IDEAL_GAS_EQUATION)

					var/datum/gas_mixture/removed = lac_vent.air_contents.remove(transfer_moles)

					loc.assume_air(removed)

					if(lac_vent.network)
						lac_vent.network.update = 1
		return 1


	power_change()
		if(powered(power_channel))
			stat &= ~NOPOWER
		else
			stat |= NOPOWER
		update_icon()


	attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
		if(istype(W, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/WT = W
			if (WT.remove_fuel(0,user))
				user << "\blue Now welding the vent."
				if(do_after(user, 20))
					if(!src || !WT.isOn()) return
					playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
					if(!welded)
						user.visible_message("[user] welds the vent shut.", "You weld the vent shut.", "You hear welding.")
						welded = 1
						update_icon()
					else
						user.visible_message("[user] unwelds the vent.", "You unweld the vent.", "You hear welding.")
						welded = 0
						update_icon()
				else
					user << "\blue The welding tool needs to be on to start this task."
			else
				user << "\blue You need more welding fuel to complete this task."
				return 1
		if(istype(W, /obj/item/weapon/screwdriver))
			if(!welded)
				if(open)
					user << "\blue Now closing the vent."
					if(do_after(user, 20))
						open = 0
						user.visible_message("[user] screwdrivers the vent shut.", "You screwdriver the vent shut.", "You hear a screwdriver.")
				else
					user << "\blue Now opening the vent."
					if(do_after(user, 20))
						open = 1
						user.visible_message("[user] screwdrivers the vent shut.", "You screwdriver the vent shut.", "You hear a screwdriver.")
			return
		if(istype(W, /obj/item/weapon/paper/))
			if(!welded)
				if(open)
					user.drop_item(W)
					W.loc = src
				if(!open)
					user << "You can't shove that down there when it is closed"
			else
				user << "The vent is welded."
			return
		if(istype(W, /obj/item/weapon/coin))
			if(!welded)
				if(open)
					user.drop_item(W)
					W.loc = src
				if(!open)
					user << "You can't shove that down there when it is closed"
			else
				user << "The vent is welded."
			return
		if(istype(W, /obj/item/weapon/card))
			if(!welded)
				if(open)
					user.drop_item(W)
					W.loc = src
				if(!open)
					user << "You can't shove that down there when it is closed"
			else
				user << "The vent is welded."
			return
		if(istype(W, /obj/item/weapon/wrench))
			user << "\red You are unable to unwrench this [name], it's too complicated."
			return
			/* The code for removing this object, I dont really think these should be able to be moved around easily.
			if (!(stat & NOPOWER) && (vent_on || scrubber_on))
				user << "\red You cannot unwrench this [name], turn it off first."
				return 1
			var/turf/T = src.loc
			if (level==1 && isturf(T) && T.intact)
				user << "\red You must remove the plating first."
				return 1
			if(lac_vent)
				var/datum/gas_mixture/int_air = lac_vent.return_air()
				var/datum/gas_mixture/env_air = loc.return_air()
				if ((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
					user << "\red You cannot unwrench this [src], it too exerted due to internal pressure."
					add_fingerprint(user)
					return 1
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			user << "\blue You begin to unfasten \the [src]..."
			if (do_after(user, 40))
				user.visible_message( \
					"[user] unfastens \the [src].", \
					"\blue You have unfastened \the [src].", \
					"You hear ratchet.")
				new /obj/item/pipe(loc, make_from=src)
			del(src)*/
		..()
		return


	Del()
		if(initial_loc)
			initial_loc.vents -= src
		..()
		return

