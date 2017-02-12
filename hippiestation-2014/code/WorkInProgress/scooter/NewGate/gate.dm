/obj/machinery/stargate
	name = "Gate"
	icon_state = "port"
	icon = 'icons/scooterstuff.dmi'
	density = 1
	anchored = 1
	dir = 2
	use_power = 0
	unacidable = 1
	var/area/gatewaymissions/area
	var/locationname = null
	ex_act(serverity)
		return

	emp_act(severity)
		return

/obj/machinery/stargate/New()
	area = src.loc.loc:master
	locationname = area.locationname
	..()


/obj/machinery/stargate/center
	icon_state = "port"
	pixel_x = -1
	pixel_y = 0

	use_power = 500// 1 = idle 2 = active
	idle_power_usage = 100
	active_power_usage = 4000//Will likely need tweaking

	var/id = null//The name of the gate
	var/code = ""//Connection code
	var/list/code_parts = new/list()//The code broken up into a list for the decoder

	var/obj/machinery/stargate/center/linked_gate = null

	var/active = 0
	var/can_shutdown = 1//Can we turn off, either side can have this on to prevent a shutdown and it can generally be toggled off via the computer
	var/receiving = 0//Did we dial out or have something coming in.

	var/station = 0//Station side gate?
	var/world_id = 0//Should be moved to world control
	var/world_issetup = 0



	New()


		//Might want to take another look at code gen
		if(!id)//Can name gates
			for(var/M = 0, M < 7, M++)//Add in a same id check for other gates later
				src.id += pick("1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S")
		for(var/M = 0, M < 7, M++)//Add in a same code check for other gates later
			var/pcode = pick("1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S")
			src.code_parts.Add(pcode)
		for(var/M = 1, M < 8, M++)
			src.code += src.code_parts[M]
		..()
		return


	process()
		if(active && use_power != 2)//Makes sure the power is working properly
			use_power = 500
		if(!active && use_power != 1)
			use_power = 50

//		if(active && !receiving)//Gates receiving do not need power
//			if(stat & (BROKEN|NOPOWER))
//
//					if(src.active >= 1)
//						src.active = 0
//						update_icon()






	proc/port_user(var/atom/movable/target, var/obj/machinery/stargate/G)
		var/startdir = target.dir
		var/odir = 0
		switch(G.dir)
			if(1)
				odir = 2
			if(2)
				odir = 1
			if(8)
				odir = 4
			if(4)
				odir = 8

		if(!startdir == odir)
			return 0

		//Is the other gate intact?
		if(!linked_gate)
			return 0//Should likely shutdown
		//Teleport them
		if(istype(G,/obj/machinery/stargate/center))
			target.loc = get_turf(linked_gate.loc)
		//Move them off of the gate
		step(target,linked_gate.dir)
		return


	update_icon()
		if(active)
			icon_state = "port_on"
		else
			icon_state = "port"
		return


	proc/dial(var/address = "0000000")
		for(var/obj/machinery/stargate/center/gate in world)
			if(gate == src)
				continue
			if(address != gate.code)
				continue
			if(gate.active)
				visible_message("\red The [gate] blinks red!")
				return 0
			gate.linked_gate = src
			linked_gate = gate
			gate.active = 1
			active = 1
			gate.update_icon()
			update_icon()
			gate.visible_message("\red The [gate] starts up!")
			visible_message("\red The [src] starts up!")

			gate.setup_miniworld()//Should be moved to control
			teleroom()
			return 1
		return 0

	proc/teleroom()

		for(var/area/A in area.related)
			A.gatesalert()
			icon_state = "port-on"
			spawn(50)
				for(var/mob/L in A)
					var/mobloc = get_turf(L.loc)
					var/atom/movable/overlay/animation = new /atom/movable/overlay( mobloc )
					animation.name = "warp"
					animation.density = 0
					animation.anchored = 1
					animation.icon = 'icons/scooterstuff.dmi'
					animation.layer = 5
					animation.master = L
					flick("warp", animation)
					L.loc = get_turf(linked_gate.loc)
					step(L,linked_gate.dir)
				A.gatereset()
				icon_state = "port"

	//This should go in the world control thing
	proc/setup_miniworld()
		if(!world_id)	return
		if(world_issetup)	return
		world_issetup = 1

		switch(world_id)
			if(1)//Two is currently the ship
				for(var/obj/effect/landmark/miniworld/w1/L in world)
					switch(L.mob_type)
						if(1)
							new/mob/living/simple_animal/hostile/syndicate/melee(L.loc)
						if(2)
							new/mob/living/simple_animal/hostile/syndicate/melee/space(L.loc)
						if(3)
							new/mob/living/simple_animal/hostile/syndicate/ranged(L.loc)
						if(4)
							new/mob/living/simple_animal/hostile/syndicate/ranged/space(L.loc)
					spawn(10)
						del(L)


/*
			if(3)
				for(var/obj/landmark/miniworld/w3/L in world)
					switch(L.id)
						if(1)
							new/obj/critter/spirit(L.loc)
							del(L)
						if(2)
							new/obj/critter/zombie(L.loc)
							del(L)
						if(3)
							new/obj/critter/spore(L.loc)
							del(L)

			if(4)
				for(var/obj/landmark/miniworld/w4/L in world)
					var/datum/special_respawn/SR = new /datum/special_respawn/
					if(SR.spawn_hivebots(1,L.loc))
						continue
					else
						new /mob/living/silicon/hivebot(L.loc)
*/
		return




/obj/machinery/stargate/center/special