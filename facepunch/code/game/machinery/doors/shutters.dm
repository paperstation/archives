/obj/machinery/door/poddoor/shutters
	name = "Shutters"
	icon = 'icons/obj/doors/rapid_pdoor.dmi'
	icon_state = "shutter1"
	power_channel = ENVIRON

/obj/machinery/door/poddoor/shutters/New()
	..()
	layer = 3.1

/obj/machinery/door/poddoor/shutters/attackby(obj/item/weapon/C as obj, mob/user as mob)
	add_fingerprint(user)
	if(!(istype(C, /obj/item/weapon/crowbar) || (istype(C, /obj/item/weapon/twohanded/fireaxe) && C:wielded == 1) ))
		return
	if(density && (stat & NOPOWER) && !operating)
		operating = 1
		spawn(-1)
			flick("shutterc0", src)
			icon_state = "shutter0"
			sleep(15)
			density = 0
			SetOpacity(0)
			operating = 0
			return
	return

/obj/machinery/door/poddoor/shutters/open()
	if(operating == 1) //doors can still open when emag-disabled
		return
	if(!ticker)
		return 0
	if(!operating) //in case of emag
		operating = 1
	playsound(src.loc, 'sound/machines/shutter_open.ogg', 100, 1)
	flick("shutterc0", src)
	icon_state = "shutter0"
	sleep(10)
	density = 0
	SetOpacity(0)
	update_nearby_tiles()

	if(operating == 1) //emag again
		operating = 0
	if(autoclose)
		spawn(150)
			autoclose()		//TODO: note to self: look into this ~Carn
	return 1

/obj/machinery/door/poddoor/shutters/close()
	if(operating)
		return
	operating = 1
	playsound(src.loc, 'sound/machines/shutter_close.ogg', 100, 1)
	flick("shutterc1", src)
	icon_state = "shutter1"
	density = 1
	if(visible)
		SetOpacity(1)
	update_nearby_tiles()

	sleep(10)
	operating = 0
	return




//Replacement for windoors
/obj/machinery/door/poddoor/handshutter
	name = "Shutters"
	icon = 'icons/obj/doors/rapid_pdoor.dmi'
	desc = "A light metal blast door with a window!"
	icon_state = "glass_shutter_closed"
	health = 100
	max_health = 100
	damage_sound = 'sound/effects/Glasshit.ogg'

	opacity = 0
	//layer_open = 2.7//above other blast doors when open so it can be hit
	layer_open = 3.2//So you can touch it, might need editing
	layer_closed = 3.2//below the other blast doors doors if closed
	autoclose = 0


	examine()
		..()
		var/damage = "bad"
		if(health > max_health*0.5)
			damage = "good"
		usr << "It appears to be in [damage] condition."
		return


	close()
		if(stat & BROKEN)
			return 0
		if (src.operating)
			return 0
		if (!ticker)
			return 0
		src.operating = 1
		playsound(src.loc, 'sound/machines/shutter_close.ogg', 100, 1)
		flick("glass_shutter_close", src)
		src.icon_state = "glass_shutter_closed"
		layer = layer_closed
		spawn(10)
			src.density = 1
			src.operating = 0
			update_nearby_tiles()
		return 1


	open(var/forced = 0)
		if(stat & BROKEN)
			return 0
		if(src.operating)
			return 0
		if(!ticker)
			return 0
		src.operating = 1
		playsound(src.loc, 'sound/machines/shutter_open.ogg', 100, 1)
		flick("glass_shutter_open", src)
		src.icon_state = "glass_shutter_opened"

		layer = layer_open
		spawn(10)
			src.density = 0
			src.operating = 0
			update_nearby_tiles()

		if(!forced && autoclose)
			spawn(150)
				autoclose()
		return 1


	process()
		..()
		if(stat & (NOPOWER|BROKEN))
			return 0
		return


	attackby(obj/item/W as obj, mob/user as mob)
		if(!W||!istype(user))
			return 0
		if(istype(W, /obj/item/device/detective_scanner))
			return 0

		src.add_fingerprint(user)
		if(istype(W,/obj/item/stack/sheet/rglass))//Fixing the door
			if(health >= max_health)
				user << "<span class='notice'>The [src] has been fully repaired.</span>"
				return 0
			var/obj/item/stack/glass = W
			if(glass.amount < 2)
				user << "<span class='notice'>You need more glass.</span>"
				return 0
			visible_message("<span class='notice'>[user] begins to repair the [src]. </span>", "<span class='notice'>You begin to repair the [src].</span>")
			if(do_after(user,15))
				glass.use(2)
				health = min(max_health, health+50)
				user << "<span class='notice'>You repair the [src].</span>"
				if(health >= max_health)
					user <<  "<span class='notice'>The [src] has been fully repaired.</span>"
				update_health()
			return 1

		if(stat & BROKEN)//No hitting it after it breaks
			return 0

		if(src.allowed(user))
			if(src.density)
				return open()
			else
				return close()

		if(..())//Could crowbar it or such so stop here
			return 1

		return 1


	emp_act(severity)
		return 0


	update_health()
		if(health > 0)
			if(stat & BROKEN)
				stat &= ~BROKEN//If we are above 0 then we can function
				close()//Close the door, it will be set properly by the open/close state shortly
			return 1
		stat |= BROKEN//We are now broken
		src.icon_state = "glass_shutter_broken"
		src.SetOpacity(0)
		spawn(10)
			src.density = 0
			update_nearby_tiles()
		return 0
