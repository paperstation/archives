/obj/machinery/stargate
	name = "Gate"
	icon = 'icons/obj/largegate.dmi'
	density = 1
	anchored = 1
	dir = 2
	use_power = USE_POWER_NONE//So the sides dont use power
	unacidable = 1
	damage_resistance = -1
	var/datum/awaymission/away

	ex_act(serverity)
		return

	emp_act(severity)
		return

/obj/machinery/stargate/New()
	..()
	away = new/datum/awaymission/

/obj/machinery/stargate/side
	var/obj/machinery/stargate/center/center = null


	New(loc, var/obj/machinery/stargate/center/C)
		center = C
		..(loc)
		return


	Bumped(atom/AM)
		if(!center)
			return
		if(!center.active)
			return
		center.port_user(AM,src)
		return


/obj/machinery/stargate/side/left
	icon_state = "left"
	pixel_x = -4
	pixel_y = 0

	update_icon()
		if(!center)	return
		if(center.active)
			icon_state = "left_on"
		else
			icon_state = "left"
		return

/obj/machinery/stargate/side/right
	icon_state = "right"
	pixel_x = 2
	pixel_y = 0

	update_icon()
		if(!center)	return
		if(center.active)
			icon_state = "right_on"
		else
			icon_state = "right"
		return


/obj/machinery/stargate/center
	icon_state = "mid"
	pixel_x = -1
	pixel_y = 0

	use_power = USE_POWER_IDLE// 1 = idle 2 = active
	idle_power_usage = 100
	active_power_usage = 4000//Will likely need tweaking

	var/id = null//The name of the gate
	var/code = ""//Connection code
	var/list/code_parts = new/list()//The code broken up into a list for the decoder
	//The rest of the gate
	var/obj/machinery/stargate/side/left = null
	var/obj/machinery/stargate/side/right = null
	//Anyone we connected to
	var/obj/machinery/stargate/center/linked_gate = null

	var/active = 0
	var/can_shutdown = 1//Can we turn off, either side can have this on to prevent a shutdown and it can generally be toggled off via the computer
	var/receiving = 0//Did we dial out or have something coming in.

	var/station = 0//Station side gate?
	var/world_id = 0//Should be moved to world control
	var/world_issetup = 0


	New()
		//Currently will only work down
		left = new/obj/machinery/stargate/side/left(get_step(src,8), src)
		right = new/obj/machinery/stargate/side/right(get_step(src,4), src)

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
			use_power = USE_POWER_ACTIVE
		if(!active && use_power != 1)
			use_power = USE_POWER_IDLE

		if(active && !receiving)//Gates receiving do not need power
			if(stat & (BROKEN|NOPOWER))
				if(src.shutdown_gate())//However gates that cant shut down ignore power
					if(src.active >= 1)
						src.active = 0
						update_icon()
		return


	Bumped(atom/AM)//Should have a tele delay, needs rework
		if(!src.active)	return
		if(!src.linked_gate)	return
		if(ismob(AM))
			var/mob/M = AM
			port_user(M,src)
			M.unlock_achievement("Not of this World")
		else if(isobj(AM))//Will need to change up what can come though likely
			var/obj/O = AM
			//if(istype(O,/obj/bullet)||istype(O,/obj/laser))	return
			port_user(O,src)
		return


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
		if(!linked_gate.left || !linked_gate.right)
			return 0
		//Teleport them
		if(istype(G,/obj/machinery/stargate/center))
			target.loc = get_turf(linked_gate.loc)
		else if(istype(G,/obj/machinery/stargate/side/left))
			target.loc = get_turf(linked_gate.left.loc)
		else if(istype(G,/obj/machinery/stargate/side/right))
			target.loc = get_turf(linked_gate.right.loc)
		//Move them off of the gate
		step(target,linked_gate.dir)
		return


	update_icon()
		if(active)
			icon_state = "mid_on"
		else
			icon_state = "mid"
		if(left)
			left.update_icon()
		if(right)
			right.update_icon()
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
			return 1
		return 0


	proc/shutdown_gate()
		//We dont have another gate for some reason
		if(!src.linked_gate)
			if(active)
				active = 0
				update_icon()
			return 1
		//If either gate is preventing shutdown then fail
		if(!src.can_shutdown || !src.linked_gate.can_shutdown)
			return 0
		//Reset vars
		linked_gate.linked_gate = null
		linked_gate.active = 0
		linked_gate.update_icon()
		linked_gate.visible_message("\red The [linked_gate] Shuts down!")
		linked_gate = null
		active = 0
		src.update_icon()
		visible_message("\red The [name] Shuts down!")
		return 1

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

			if(2)
				for(var/obj/effect/landmark/miniworld/w2/lizards/L in world)
					new/mob/living/simple_animal/hostile/lizard(L.loc)
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
			if(6)//halloween
				for(var/obj/effect/landmark/miniworld/w6/ghoul/L in world)
					new/mob/living/simple_animal/hostile/ghoul(L.loc)
					del(L)
				for(var/obj/effect/landmark/miniworld/w6/bucket/L in world)
					new/obj/item/candybucket(L.loc)
					new/obj/item/candybucket(L.loc)
					new/obj/item/candybucket(L.loc)
					new/obj/item/candybucket(L.loc)
					new/obj/item/candybucket(L.loc)
					new/obj/item/candybucket(L.loc)
					new/obj/item/candybucket(L.loc)
					new/obj/item/candybucket(L.loc)
					new/obj/item/candybucket(L.loc)
					new/obj/item/candybucket(L.loc)
					del(L)
			if(7)//newcasino for later
				for(var/obj/effect/landmark/miniworld/w7/shuttle/L in world)
				//	new/
					spawn(10)
						del(L)
			if(8)//deepseadiving
				for(var/obj/effect/landmark/miniworld/w8/carp/L in world)
					new/mob/living/simple_animal/hostile/carp (L.loc)
					spawn(10)
						del(L)
			if(10)//highway
				for(var/obj/effect/landmark/miniworld/w10/xenos/L in world)
					new/mob/living/simple_animal/hostile/alien (L.loc)
					spawn(10)
						del(L)
		return




/obj/machinery/stargate/center/special