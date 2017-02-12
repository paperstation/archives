/obj/machinery/computer
	name = "computer"
	icon = 'icons/obj/computer.dmi'
	density = 1
	anchored = 1.0
	use_power = USE_POWER_IDLE
	idle_power_usage = 300
	active_power_usage = 300
	var/obj/item/weapon/circuitboard/circuit = null //if circuit==null, computer can't disassembly
	var/processing = 0

	New()
		..()
		if(ticker)
			initialize()
		return


	initialize()
		power_change()
		return


	process()
		if(stat & (NOPOWER|BROKEN))
			return 0
		return 1


	emp_act(severity)
		if(prob(20/severity)) set_broken()
		..()
		return


	damage(var/amount, var/use_armor = 1, var/use_sound = 1)
		if(prob(amount))
			set_broken()
		..()
		return



/obj/machinery/computer/update_icon()
	// Broken
	if(stat & BROKEN)
		icon_state = "computer_broken"
		return

	// Powered
	if(stat & NOPOWER)
		icon_state = "computer_no_power"
		return

	icon_state = initial(icon_state)
	return


/obj/machinery/computer/power_change()
	..()
	update_icon()


/obj/machinery/computer/proc/set_broken()
	stat |= BROKEN
	update_icon()


/obj/machinery/computer/attackby(I as obj, user as mob)
	if(istype(I, /obj/item/weapon/screwdriver) && circuit)
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			var/obj/structure/computerframe/A = new /obj/structure/computerframe(src.loc)
			var/obj/item/weapon/circuitboard/M = new circuit( A )
			A.circuit = M
			A.anchored = 1
			for (var/obj/C in src)
				C.loc = src.loc
			if (src.stat & BROKEN)
				user << "\blue The broken glass falls out."
				new /obj/item/weapon/shard( src.loc )
				A.state = 3
				A.icon_state = "3"
			else
				user << "\blue You disconnect the monitor."
				A.state = 4
				A.icon_state = "4"
			del(src)
	else
		src.attack_hand(user)
	return






