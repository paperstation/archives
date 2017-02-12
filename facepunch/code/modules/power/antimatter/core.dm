/*

Core: Matter+AMatter = energy+flux
Shielding: Plasma into power(energy) and heat(flux)
Matter Input: Place assistants here
AM Input: Place containement jar here
Control Computer: GUI
Transformer: Outputs power
Heatvent: Outputs heat
Gas Input: Plasma here

Flux: Waste material that builds up and can cause issues
Energy: Can be converted into power



*/
/obj/machinery/antimatter
	name = "antimatter base"
	desc = "A contained plasma life-form that reacts with neutrinos."

	icon = 'icons/obj/machines/antimatter.dmi'
	icon_state = "shield"
	anchored = 1
	density = 1
	dir = 1

	use_power = USE_POWER_NONE//No power used
	idle_power_usage = 0
	active_power_usage = 0
	var/obj/machinery/power/antimatter/control_unit = null//ref back to the real core of the machine
	var/processing = 0//To track if we are in the update list or not, we need to be when we are damaged and if we ever
	var/stability = 100//If this gets low bad things tend to happen


	New(loc)
		..(loc)
		spawn(10)
			controllerscan()
		return


	proc/controllerscan(var/priorscan = 0)//Needs to chance to allow freestanding parts
		//Make sure we are the only one here
		/*if(!istype(src.loc, /turf))
			del(src)
			return
		for(var/obj/machinery/antimatter/AM in loc.contents)
			if(AM == src) continue
			spawn(0)
				del(src)
			return

		//Search for shielding first
		for(var/obj/machinery/antimatter/AMS in cardinalrange(src))
			if(AMS && AMS.control_unit && link_control(AMS.control_unit))
				break

		if(!control_unit)//No other guys nearby look for a control unit
			for(var/direction in cardinal)
			for(var/obj/machinery/power/am_control_unit/AMC in cardinalrange(src))
				if(AMC.add_shielding(src))
					break

		if(!control_unit)
			if(!priorscan)
				spawn(20)
					controllerscan(1)//Last chance
				return
			spawn(0)
				del(src)
		return*/


	Del()
		//if(control_unit)	control_unit.remove_shielding(src)
		//if(processing)	shutdown_core()
		visible_message("\red The [src.name] melts!")
		//Might want to have it leave a mess on the floor but no sprites for now
		..()
		return


	CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
		if(air_group || (height==0))	return 1
		return 0


	process()
		if(!processing) . = PROCESS_KILL
		//TODO: core functions and stability
		//TODO: think about checking the airmix for plasma and increasing power output
		return


	emp_act()//Immune due to not really much in the way of electronics.
		return 0


	blob_act()
		stability -= 20
		if(prob(100-stability))
			if(prob(10))//Might create a node
				new /obj/effect/blob/node(src.loc,150)
			else
				new /obj/effect/blob(src.loc,60)
			spawn(0)
				del(src)
			return
		//check_stability()
		return


	ex_act(severity)
		switch(severity)
			if(1.0)
				stability -= 80
			if(2.0)
				stability -= 40
			if(3.0)
				stability -= 20
		//check_stability()
		return


	bullet_act(var/obj/item/projectile/Proj)
		//if(Proj.flag != "bullet")
		//	stability -= Proj.force/2
		return 0


	update_icon()
		overlays.Cut()
		for(var/direction in alldirs)
			var/machine = locate(/obj/machinery, get_step(loc, direction))
			if((istype(machine, /obj/machinery/antimatter) && machine:control_unit == control_unit)||(istype(machine, /obj/machinery/power/antimatter/control_unit) && machine == control_unit))
				overlays += "shield_[direction]"

		//if(core_check())
		//	overlays += "core"
		//	if(!processing) setup_core()
		//else if(processing) shutdown_core()


	attackby(obj/item/W, mob/user)//Should be changed
		if(!istype(W) || !user) return
		if(W.force > 10)
			stability -= W.force/2
			//check_stability()
		..()
		return



/obj/machinery/antimatter/shielding//Plasma reaction chamber
	name = "antimatter shielding"
	desc = "A contained plasma life-form that reacts with neutrinos."

	icon_state = "shield"
	anchored = 1
	density = 1
	dir = 1

	var/energy_strength = 1.0
	var/flux_strength = 0.5



/obj/machinery/antimatter/input
	name = "antimatter fuel input"
	desc = "A contained plasma life-form that reacts with neutrinos."
	icon_state = "input_am"
	var/fuel_storage = 1000//how much fuel this can hold
	var/obj/item/weapon/antimatter_fuel/jar = null

	Bumped(atom/AM)
		if(ismob(AM))
			return//no killing mobs right now


	attackby(obj/item/W, mob/user)
		if(!istype(W) || !user) return
		//if(istype(W,/obj/item/weapon/antimatter_fuel))
			//var/obj/item/weapon/antimatter_fuel/fuel = W
			//place can and shit

			//visible_message("[user] places the [W] in the [name]")
