/obj/machinery/door/window/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			health = 0
			new /obj/item/stack/rods( src.loc)
			updatehealth()
		if(3.0)
			if (prob(50))
				health = 0
				new /obj/item/stack/rods( src.loc)
				updatehealth()
	return

/obj/machinery/door/window/hitby(AM as mob|obj)

	..()
	for(var/mob/O in viewers(src, null))
		O.show_message(text("\red <B>[src] was hit by [AM].</B>"), 1)
	var/tforce = 0
	if(ismob(AM))
		tforce = 40
	else
		tforce = AM:throwforce
	playsound(src.loc, 'Glasshit.ogg', 100, 1)
	src.health = max(0, src.health - tforce)
	if (src.health <= 0)
		new /obj/item/weapon/shard( src.loc )
		if(ismob(AM) && (ishuman(AM) || ismonkey(AM)))
			if(seen_by_camera(AM))
				var/perpname = AM:name
				if(AM:wear_id && AM:wear_id.registered)
					perpname = AM:wear_id.registered
				for(var/datum/data/record/R in data_core.general)
					if(R.fields["name"] == perpname)
						for (var/datum/data/record/S in data_core.security)
							if (S.fields["id"] == R.fields["id"])
								S.fields["criminal"] = "*Arrest*"
								S.fields["mi_crim"] = "Vandalism (Breaking Windows)"
								break
	updatehealth()
	..()
	return

/obj/machinery/door/window/proc/updatehealth()
	if (health <= 0)
		new /obj/item/weapon/shard( src.loc )
		new /obj/item/stack/rods( src.loc )
		src.density = 0
		del(src)
		return


/obj/machinery/door/window/Del()
	density = 0

	update_nearby_tiles()

	playsound(src, "shatter", 70, 0)
	if(src.icon_state == "vwindow") // so it's shit, sue me
		message_admins("\red <B> Vacuum window breaking at X:[src.x] Y:[src.y] Z:[src.z]")
	..()

/obj/window/bullet_act(var/obj/item/projectile/Proj)
	if(Proj.flag == "bullet")
		if(!reinf)
			health = 0
			updatehealth()
		else
			health -= Proj.damage
			updatehealth()
	return

/obj/window/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			health = 0
			updatehealth()
		if(3.0)
			if (prob(50))
				health = 0
				updatehealth()
	return

/obj/window/blob_act()
	health = 0
	updatehealth()

/obj/window/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return 1
	if (src.dir == SOUTHWEST || src.dir == SOUTHEAST || src.dir == NORTHWEST || src.dir == NORTHEAST)
		return 0 //full tile window, you can't move into it!
	if(get_dir(loc, target) == dir)
		return !density
	else
		return 1

/obj/window/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASSGLASS))
		return 1
	if (get_dir(O.loc, target) == dir)
		return 0
	return 1

/obj/window/meteorhit()

	//*****RM
	//world << "glass at [x],[y],[z] Mhit"
	src.health = 0
	new /obj/item/weapon/shard( src.loc )
	if(reinf) new /obj/item/stack/rods( src.loc)
	src.density = 0


	del(src)
	return


/obj/window/hitby(AM as mob|obj)

	..()
	for(var/mob/O in viewers(src, null))
		O.show_message(text("\red <B>[src] was hit by [AM].</B>"), 1)
	var/tforce = 0
	if(ismob(AM))
		tforce = 40
	else
		tforce = AM:throwforce
	if(reinf) tforce /= 4.0
	playsound(src.loc, 'Glasshit.ogg', 100, 1)
	src.health = max(0, src.health - tforce)
	if (src.health <= 7 && !reinf)
		src.anchored = 0
		step(src, get_dir(AM, src))
	updatehealth()
	..()
	return

/obj/window/attack_hand(mob/user as mob)
	if ((usr.mutations & HULK))
		for(var/mob/O in viewers(world.view,src))
			O.show_message("\red [] smashes through the window!", user.name)
		src.health = 0
		updatehealth()
	else
		for(var/mob/O in oviewers())
			O << text("\red [] knocks on the window!", user.name)
		playsound(src.loc, 'Glasshit.ogg', 100, 1)
		spawn(3)
		playsound(src.loc, 'Glasshit.ogg', 100, 1)
		spawn(3)
		playsound(src.loc, 'Glasshit.ogg', 100, 1)
	return

/obj/window/attack_paw(mob/user as mob)
	if ((usr.mutations & HULK))
		usr << text("\blue You smash through the window.")
		for(var/mob/O in viewers(world.view,src))
			O.show_message("\red [] smashes through the window!", user.name)
		src.health = 0
		updatehealth()
	else
		for(var/mob/O in viewers(world.view,src))
			O.show_message("\red [] knocks on the window!", user.name)
		playsound(src.loc, 'Glasshit.ogg', 100, 1)
		spawn(3)
		playsound(src.loc, 'Glasshit.ogg', 100, 1)
		spawn(3)
		playsound(src.loc, 'Glasshit.ogg', 100, 1)
	return

/obj/window/attack_alien()
	if (istype(usr, /mob/living/carbon/alien/larva))//Safety check for larva. /N
		return
	usr << text("\green You smash against the window.")
	for(var/mob/O in viewers(world.view,src))
		O.show_message("\red [] smashes against the window!", usr.name)
	playsound(src.loc, 'Glasshit.ogg', 100, 1)
	src.health -= 15
	if(src.health <= 0)
		usr << text("\green You smash through the window.")
		for(var/mob/O in viewers(world.view,src))
			O.show_message("\red [] smashes through the window!", usr.name)
		src.health = 0
		updatehealth()
	return

/obj/window/attack_metroid()
	if(!istype(usr, /mob/living/carbon/metroid/adult))
		return

	usr<< text("\green You smash against the window.")
	for(var/mob/O in viewers(world.view,src))
		O.show_message("\red [] smashes against the window!", usr.name)
	playsound(src.loc, 'Glasshit.ogg', 100, 1)
	src.health -= rand(10,15)
	if(src.health <= 0)
		usr << text("\green You smash through the window.")
		for(var/mob/O in viewers(world.view,src))
			O.show_message("\red [] smashes through the window!", usr.name)
		src.health = 0
		updatehealth()
	return

/obj/window/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/screwdriver))
		if(src.icon_state == "vwindow")
			if(!usr.mind.special_role)
				message_admins("\red <B> [usr] is fucking with a vacuum window. No special_role. </B>")
		if(reinf && state >= 1)
			state = 3 - state
			playsound(src.loc, 'Screwdriver.ogg', 75, 1)
			user << ( state==1? "You have unfastened the window from the frame." : "You have fastened the window to the frame." )
		else if(reinf && state == 0)
			anchored = !anchored
			playsound(src.loc, 'Screwdriver.ogg', 75, 1)
			user << (src.anchored ? "You have fastened the frame to the floor." : "You have unfastened the frame from the floor.")
		else if(!reinf)
			src.anchored = !( src.anchored )
			playsound(src.loc, 'Screwdriver.ogg', 75, 1)
			user << (src.anchored ? "You have fastened the window to the floor." : "You have unfastened the window.")
	else if(istype(W, /obj/item/weapon/crowbar) && reinf)
		if(state <=1)
			state = 1-state;
			playsound(src.loc, 'Crowbar.ogg', 75, 1)
			user << (state ? "You have pried the window into the frame." : "You have pried the window out of the frame.")
	else
		var/aforce = W.force
		if(reinf) aforce /= 2.0
		src.health = max(0, src.health - aforce)
		playsound(src.loc, 'Glasshit.ogg', 75, 1)
		if (src.health <= 7)
			src.anchored = 0
			step(src, get_dir(user, src))
		updatehealth()
		..()
	return


/obj/window/verb/rotate()
	set name = "Rotate Window Counter-Clockwise"
	set category = "Object"
	set src in oview(1)

	if (src.anchored)
		usr << "It is fastened to the floor; therefore, you can't rotate it!"
		return 0

	update_nearby_tiles(need_rebuild=1) //Compel updates before

	src.dir = turn(src.dir, 90)

	update_nearby_tiles(need_rebuild=1)

	src.ini_dir = src.dir
	return

/obj/window/verb/revrotate()
	set name = "Rotate Window Clockwise"
	set category = "Object"
	set src in oview(1)

	if (src.anchored)
		usr << "It is fastened to the floor; therefore, you can't rotate it!"
		return 0

	update_nearby_tiles(need_rebuild=1) //Compel updates before

	src.dir = turn(src.dir, 270)

	update_nearby_tiles(need_rebuild=1)

	src.ini_dir = src.dir
	return

/obj/window/New(Loc,re=0)
	..()

	if(re)	reinf = re

	src.ini_dir = src.dir
	if(reinf)
		icon_state = "rwindow"
		desc = "A reinforced window."
		name = "reinforced window"
		state = 2*anchored
		health = 40
		if(opacity)
			icon_state = "twindow"

	update_nearby_tiles(need_rebuild=1)

	return

/obj/window/Del()
	density = 0

	update_nearby_tiles()

	playsound(src, "shatter", 70, 1)
	..()

/obj/window/Move()
	update_nearby_tiles(need_rebuild=1)

	..()

	src.dir = src.ini_dir
	update_nearby_tiles(need_rebuild=1)

	return

/obj/window/proc/update_nearby_tiles(need_rebuild)
	if(!air_master) return 0

	var/turf/simulated/source = loc
	var/turf/simulated/target = get_step(source,dir)

	if(need_rebuild)
		if(istype(source)) //Rebuild/update nearby group geometry
			if(source.parent)
				air_master.groups_to_rebuild += source.parent
			else
				air_master.tiles_to_update += source
		if(istype(target))
			if(target.parent)
				air_master.groups_to_rebuild += target.parent
			else
				air_master.tiles_to_update += target
	else
		if(istype(source)) air_master.tiles_to_update += source
		if(istype(target)) air_master.tiles_to_update += target

	return 1

/obj/window/proc/updatehealth()
	if (health <= 0)
		if (src.dir == SOUTHWEST)
			var/index = null
			index = 0
			while(index < 2)
				new /obj/item/weapon/shard( src.loc )
				if(reinf) new /obj/item/stack/rods( src.loc)
				index++
		else
			new /obj/item/weapon/shard( src.loc )
			if(reinf) new /obj/item/stack/rods( src.loc )
		src.density = 0
		del(src)
		return

/obj/window_shuttle/update_icon()
	if(health)
		switch(health)
			if(30 to 60)
				icon_state = "[source_icon_state]1"
			if(1 to 30)
				icon_state = "[source_icon_state]2"
	if(broken)
		if(glass)
			icon_state = "[source_icon_state]3"
		else
			icon_state = "[source_icon_state]4"

/obj/window_shuttle/proc/updatehealth()
	if(health <= 1)
		if(!broken)
			new /obj/item/weapon/shard( src.loc )
			new /obj/item/stack/rods( src.loc)
		density = 0
		health = 0
		broken = 1
	update_icon()

/obj/window_shuttle/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/stack/sheet/rglass))
		if(!glass)
			playsound(src.loc, 'Screwdriver.ogg', 75, 1)
			user << ("\blue You fit a sheet of glass into the frame.")
			health = 60
			glass = 1
			broken = 0
			density = 1
		else
			user << ("\blue You need to clear the glass out of this frame first.")
	else if (istype(W, /obj/item/stack/sheet/glass))
		if(!glass)
			playsound(src.loc, 'Screwdriver.ogg', 75, 1)
			usr << ("\blue You fit a sheet of glass into the frame.")
			health = 20
			glass = 1
			broken = 0
			density = 1
		else
			user << ("\blue You need to clear the glass out of this frame first.")
	else if (istype(W, /obj/item/device/detective_scanner))
		for(var/mob/O in viewers(src, null))
			if ((O.client && !( O.blinded )))
				O << text("\red [src] has been scanned by [user] with the [W]")
	else
		if (!( istype(W, /obj/item/weapon/grab) ) && !(istype(W, /obj/item/weapon/plastique)) &&!(istype(W, /obj/item/weapon/spraybottle/cleaner)) && !(istype(W, /obj/item/weapon/plantbgone)) )
			for(var/mob/O in viewers(src, null))
				if ((O.client && !( O.blinded )))
					O << text("\red <B>[] has been hit by [] with []</B>", src, user, W)
	src.health = max(0, src.health - W.force)
	playsound(src.loc, 'Glasshit.ogg', 75, 1)
	updatehealth()
	return

/obj/window_shuttle/attack_hand(mob/user as mob)
	if(health)
		if ((usr.mutations & HULK))
			usr << text("\blue You smash through the window.")
			for(var/mob/O in viewers(world.view,src))
				O.show_message("\red [] smashes through the window!", user.name)
			src.health = 0
			updatehealth()
		else
			for(var/mob/O in viewers(world.view,src))
				O.show_message("\red [] knocks on the the window!", user.name)
			playsound(src.loc, 'Glasshit.ogg', 100, 1)
			spawn(3)
			playsound(src.loc, 'Glasshit.ogg', 100, 1)
			spawn(3)
			playsound(src.loc, 'Glasshit.ogg', 100, 1)
	if(broken && glass)
		usr << text("\blue You clear the glass out of the frame.")
		new /obj/item/weapon/shard( src.loc )
		glass = 0
		update_icon()
	return

/obj/window_shuttle/attack_paw(mob/user as mob)
	if(health)
		if ((usr.mutations & HULK))
			usr << text("\blue You smash through the window.")
			for(var/mob/O in viewers(world.view,src))
				O.show_message("\red [] smashes through the window!", user.name)
			src.health = 0
			updatehealth()
		else
			for(var/mob/O in viewers(world.view,src))
				O.show_message("\red [] knocks on the the window!", user.name)
			playsound(src.loc, 'Glasshit.ogg', 100, 1)
			spawn(3)
			playsound(src.loc, 'Glasshit.ogg', 100, 1)
			spawn(3)
			playsound(src.loc, 'Glasshit.ogg', 100, 1)
	if(icon_state == "[source_icon_state]3")
		usr << text("\blue You clear the glass out of the frame.")
		new /obj/item/weapon/shard( src.loc )
		glass = 0
		update_icon()
	return

/obj/window_shuttle/HasEntered(AM as mob|obj)
	if(ishuman(AM))
		if(icon_state == "[source_icon_state]3" && prob(30))
			var/mob/living/carbon/human/H = AM
			var/datum/organ/external/affecting = H.organs[pick("l_leg", "r_leg")]
			H << "\blue You cut yourself on the broken glass!"
			affecting.take_damage(5, 0)
			H.UpdateDamageIcon()
			H.updatehealth()

/obj/window_shuttle/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return 1
	else if(broken)
		return 1
	else
		return 0
