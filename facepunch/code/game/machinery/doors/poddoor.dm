/obj/machinery/door/poddoor
	name = "Podlock"
	desc = "A large heavy metal blast door."
	icon = 'icons/obj/doors/rapid_pdoor.dmi'
	icon_state = "pdoor1"
	var/id = 1.0
	//var/glass = 0//Can you see through it when its closed
	explosion_resistance = 25
	layer = 2.7//Lower here so its below most things when mapping
	layer_open = 2.6//Below doors and most other things if open
	layer_closed = 3.4//Above doors and windows if closed


	Bumped(atom/AM)
		if(!density)
			return ..()
		else
			return 0


	attackby(obj/item/weapon/C as obj, mob/user as mob)
		src.add_fingerprint(user)
		if (!( istype(C, /obj/item/weapon/crowbar) || (istype(C, /obj/item/weapon/twohanded/fireaxe) && C:wielded == 1) ))
			return 0
		if((src.density && (stat & NOPOWER) && !src.operating))
			open(1)
		return 1


	open(var/forced = 0)
		if(src.operating)
			return 0
		if(!ticker)
			return 0
		src.operating = 1
		flick("pdoorc0", src)
		src.icon_state = "pdoor0"

		layer = layer_open
		spawn(10)
			src.density = 0
			src.operating = 0
			src.SetOpacity(0)
			update_nearby_tiles()

		if(!forced && autoclose)
			spawn(150)
				autoclose()
		return 1


	close(var/forced = 0)
		if (src.operating)
			return 0
		if (!ticker)
			return 0
		src.operating = 1
		flick("pdoorc1", src)
		src.icon_state = "pdoor1"
		layer = layer_closed
		spawn(10)
			src.density = 1
			src.operating = 0
			src.SetOpacity(initial(opacity))
			update_nearby_tiles()
		return 1



//A breakable glass version, used in brig cells.
/obj/machinery/door/poddoor/glass
	name = "Cell Door"
	desc = "A large heavy metal blast door. Now with windows!  Can be repaired with reinforced glass."
	icon_state = "pdoor_glass_closed"
	damage_sound = 'sound/effects/Glasshit.ogg'
	var/next_door_state = 1//Controls if it should open or close 0 =  open 1 = close

	opacity = 0
	layer_open = 2.7//above other blast doors when open so it can be hit
	layer_closed = 3.2//below the other blast doors doors if closed

	examine()
		..()
		var/damage = "very bad"
		if(health > max_health*0.7)
			damage = "good"
		else if(health > max_health*0.3)
			damage = "bad"
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
		flick("pdoor_glass_close", src)
		src.icon_state = "pdoor_glass_closed"
		layer = layer_closed
		spawn(10)
			src.density = 1
			src.operating = 0
			src.SetOpacity(initial(opacity))
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
		flick("pdoor_glass_open", src)
		src.icon_state = "pdoor_glass_opened"

		layer = layer_open
		spawn(10)
			src.density = 0
			src.operating = 0
			src.SetOpacity(0)
			update_nearby_tiles()

		if(!forced && autoclose)
			spawn(150)
				autoclose()
		return 1

		return (..())


	process()
		..()
		if(stat & (NOPOWER|BROKEN))
			return 0
		if(next_door_state != density)
			switch(next_door_state)
				if(0)
					open()
				if(1)
					close()
		return


	attackby(obj/item/W as obj, mob/user as mob)
		if(!istype(W)||!istype(user))
			return 0
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
		if(..())//Could crowbar it or such so stop here
			return 1

		damaged_by(W, user)
//		visible_message("\red <B>[src] has been hit by [user] with [W]</B>", 1)
		return 1


	destroy()//Taken care of by check health as this can be fixed
		return

	emp_act(severity)
		return 0

	update_health()
		if(health > 0)
			if(stat & BROKEN)
				stat &= ~BROKEN//If we are above 0 then we can function
				close()//Close the door, it will be set properly by the open/close state shortly
			return 1
		stat |= BROKEN//We are now broken
		src.icon_state = "pdoor_glass_broken"
		src.SetOpacity(0)
		spawn(10)
			src.density = 0
			update_nearby_tiles()
		return 0
