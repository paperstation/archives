/var/const/OPEN = 1
/var/const/CLOSED = 2

/obj/machinery/door/firedoor
	name = "Firelock"
	desc = "Thick, fire-proof doors that prevent the spread of fire, they can only be pried open unless the fire alarm is cleared."
	icon = 'icons/obj/doors/Doorfire.dmi'
	icon_state = "door0"
	var/blocked = null
	opacity = 0
	density = 0
	var/nextstate = null
	var/datum/radio_frequency/control_frequency = "1437"
	var/zone
	var/image/welded_image = null
	var/welded_icon_state = "welded"

/obj/machinery/door/firedoor/border_only
	name = "Firelock"
	icon = 'icons/obj/doors/door_fire2.dmi'
	icon_state = "door0"

/obj/machinery/door/firedoor/pyro
	icon = 'icons/obj/doors/SL_doors.dmi'
	icon_state = "fdoor0"
	icon_base = "fdoor"
	welded_icon_state = "fdoor_welded"

/obj/machinery/door/firedoor/New()
	..()
	if(!zone)
		var/area/A = get_area(loc)
		zone = A.name
	spawn(5)
		if (radio_controller)
			radio_controller.add_object(src, "[control_frequency]")


/obj/machinery/door/firedoor/proc/set_open()
	if(!blocked)
		if(operating)
			nextstate = OPEN
		else
			open()
	return

/obj/machinery/door/firedoor/proc/set_closed()
	if(!blocked)
		if(operating)
			nextstate = CLOSED
		else
			close()
	return

// listen for fire alert from firealarm
/obj/machinery/door/firedoor/receive_signal(datum/signal/signal)
	if(signal.data["zone"] == zone && signal.data["type"] == "Fire")
		if(signal.data["alert"] == "fire")
			set_closed()
		else
			set_open()
	return


/obj/machinery/door/firedoor/power_change()
	if( powered(ENVIRON) )
		stat &= ~NOPOWER
	else
		stat |= NOPOWER

/obj/machinery/door/firedoor/bumpopen(mob/user as mob)
	return

/obj/machinery/door/firedoor/isblocked()
	if (src.blocked)
		return 1
	return 0

/obj/machinery/door/firedoor/attackby(obj/item/C as obj, mob/user as mob)
	src.add_fingerprint(user)
	if ((istype(C, /obj/item/weldingtool) && !( src.operating ) && src.density))
		var/obj/item/weldingtool/W = C
		if(W.welding)
			if (W.get_fuel() > 2)
				W.use_fuel(2)
			if (!( src.blocked ))
				src.blocked = 1
			else
				src.blocked = 0
			update_icon()

			return
	if (!( istype(C, /obj/item/crowbar) ))
		return

	if (!src.blocked && !src.operating)
		if(src.density)
			spawn( 0 )
				src.operating = 1

				play_animation("opening")
				sleep(15)
				src.density = 0
				update_icon()

				src.RL_SetOpacity(0)
				src.operating = 0
				return
		else //close it up again
			spawn( 0 )
				src.operating = 1

				play_animation("closing")
				src.density = 1
				sleep(15)
				update_icon()

				src.RL_SetOpacity(1)
				src.operating = 0
				return
	return


/obj/machinery/door/firedoor/attack_ai(mob/user as mob)
	if(!blocked && !operating)
		if(density)
			set_open()
		else
			set_closed()
	return

/obj/machinery/door/firedoor/proc/check_nextstate()
	switch (src.nextstate)
		if (OPEN)
			src.open()
		if (CLOSED)
			src.close()
	src.nextstate = null

/obj/machinery/door/firedoor/opened()
	..()
	check_nextstate()

/obj/machinery/door/firedoor/closed()
	..()
	check_nextstate()

/obj/machinery/door/firedoor/border_only
	CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
		if(air_group)
			var/direction = get_dir(src,target)
			return (dir != direction)
		else if(density)
			if(!height)
				var/direction = get_dir(src,target)
				return (dir != direction)
			else
				return 0

		return 1

	update_nearby_tiles(need_rebuild)
		if(!air_master) return 0

		var/turf/simulated/source = loc
		var/turf/simulated/destination = get_step(source,dir)

		if(need_rebuild)
			if(istype(source)) //Rebuild/update nearby group geometry
				if(source.parent)
					air_master.queue_update_group(source.parent)
				else
					air_master.queue_update_tile(source)
			if(istype(destination))
				if(destination.parent)
					air_master.queue_update_group(destination.parent)
				else
					air_master.queue_update_tile(destination)

		else
			if(istype(source)) air_master.queue_update_tile(source)
			if(istype(destination)) air_master.queue_update_tile(destination)

		return 1

/obj/machinery/door/firedoor/update_icon()
	if (density)
		if (locked)
			icon_state = "[icon_base]_locked"
		else
			icon_state = "[icon_base]1"
		if (blocked)
			if (!src.welded_image)
				src.welded_image = image(src.icon, src.welded_icon_state)
			src.UpdateOverlays(src.welded_image, "weld")
		else
			src.UpdateOverlays(null, "weld")
	else
		src.UpdateOverlays(null, "weld")
		icon_state = "[icon_base]0"

	return