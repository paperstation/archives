obj/machinery/atmospherics/valve
	icon = 'icons/obj/atmospherics/pumps_valves.dmi'
	icon_state = "valve0"

	name = "manual valve"
	desc = "A pipe valve"

	dir = SOUTH
	initialize_directions = SOUTH|NORTH

	var/open = 0
	var/openDuringInit = 0

	var/obj/machinery/atmospherics/node1
	var/obj/machinery/atmospherics/node2

	var/datum/pipe_network/network_node1
	var/datum/pipe_network/network_node2


	open
		open = 1
		icon_state = "valve1"


	update_icon(animation)
		if(animation)
			flick("valve[src.open][!src.open]",src)
		else
			icon_state = "valve[open]"


	New()
		switch(dir)
			if(NORTH || SOUTH)
				initialize_directions = NORTH|SOUTH
			if(EAST || WEST)
				initialize_directions = EAST|WEST
		..()


	network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
		if(reference == node1)
			network_node1 = new_network
			if(open)
				network_node2 = new_network
		else if(reference == node2)
			network_node2 = new_network
			if(open)
				network_node1 = new_network

		if(new_network.normal_members.Find(src))
			return 0

		new_network.normal_members += src

		if(open)
			if(reference == node1)
				if(node2)
					return node2.network_expand(new_network, src)
			else if(reference == node2)
				if(node1)
					return node1.network_expand(new_network, src)
		return null


	Del()
		loc = null

		if(node1)
			node1.disconnect(src)
			del(network_node1)
		if(node2)
			node2.disconnect(src)
			del(network_node2)

		node1 = null
		node2 = null
		..()


	proc/open()
		if(open) return 0

		open = 1
		update_icon()

		if(network_node1&&network_node2)
			network_node1.merge(network_node2)
			network_node2 = network_node1

		if(network_node1)
			network_node1.update = 1
		else if(network_node2)
			network_node2.update = 1
		return 1


	proc/close()
		if(!open)
			return 0

		open = 0
		update_icon()

		if(network_node1)
			del(network_node1)
		if(network_node2)
			del(network_node2)

		build_network()
		return 1


	proc/normalize_dir()
		if(dir==3)
			dir = 1
		else if(dir==12)
			dir = 4

	attack_ai(mob/user as mob)
		return

	attack_paw(mob/user as mob)
		return attack_hand(user)

	attack_hand(mob/user as mob)
		src.add_fingerprint(usr)
		update_icon(1)
		sleep(10)
		if (src.open)
			src.close()
		else
			src.open()


	process()
		..()
		. = PROCESS_KILL
		return


	initialize()
		normalize_dir()

		var/node1_dir
		var/node2_dir

		for(var/direction in cardinal)
			if(direction&initialize_directions)
				if (!node1_dir)
					node1_dir = direction
				else if (!node2_dir)
					node2_dir = direction

		for(var/obj/machinery/atmospherics/target in get_step(src,node1_dir))
			if(target.initialize_directions & get_dir(target,src))
				node1 = target
				break
		for(var/obj/machinery/atmospherics/target in get_step(src,node2_dir))
			if(target.initialize_directions & get_dir(target,src))
				node2 = target
				break

		build_network()

		if(openDuringInit)
			close()
			open()
			openDuringInit = 0


	build_network()
		if(!network_node1 && node1)
			network_node1 = new /datum/pipe_network()
			network_node1.normal_members += src
			network_node1.build_network(node1, src)

		if(!network_node2 && node2)
			network_node2 = new /datum/pipe_network()
			network_node2.normal_members += src
			network_node2.build_network(node2, src)


	return_network(obj/machinery/atmospherics/reference)
		build_network()

		if(reference==node1)
			return network_node1

		if(reference==node2)
			return network_node2
		return null


	reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
		if(network_node1 == old_network)
			network_node1 = new_network
		if(network_node2 == old_network)
			network_node2 = new_network
		return 1


	return_network_air(datum/network/reference)
		return null


	disconnect(obj/machinery/atmospherics/reference)
		if(reference==node1)
			del(network_node1)
			node1 = null

		else if(reference==node2)
			del(network_node2)
			node2 = null
		return null


	attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
		if (!istype(W, /obj/item/weapon/wrench))
			return ..()
		var/turf/T = src.loc
		if (level==1 && isturf(T) && T.intact)
			user << "\red You must remove the plating first."
			return 1
		var/datum/gas_mixture/int_air = return_air()
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
			del(src)



/obj/machinery/atmospherics/valve/digital		// can be controlled by AI
	name = "digital valve"
	desc = "A digitally controlled valve."
	icon_state = "dvalve0"
	var/warn = 0

	attack_ai(mob/user as mob)
		return src.attack_hand(user)

	attack_hand(mob/user as mob)
		if(warn)
			message_admins("[key_name_admin(user)] has touched the [name] in [get_area(src)]! Their antagonist status is [(user.mind.special_role ? user.mind.special_role : "none")] (<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>)  (<A HREF='?_src_=vars;Vars=\ref[user]'>VV</A>) (<A HREF='?priv_msg=\ref[user]'>PM</A>) (<A HREF='?_src_=holder;adminplayerobservejump=\ref[user]'>JMP</A>)")
		..()
		return

	update_icon(animation)
		if(animation)
			flick("dvalve[src.open][!src.open]",src)
		else
			icon_state = "dvalve[open]"

	attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
		if(!istype(W, /obj/item/weapon/wrench))
			return ..()
		user << "\red You are unable to unwrench this [name], it's too complicated."
		return 1
