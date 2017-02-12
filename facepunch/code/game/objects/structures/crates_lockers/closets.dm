/obj/structure/closet
	name = "closet"
	desc = "It's a basic storage unit."
	icon = 'icons/obj/closet.dmi'
	icon_state = "closed"
	density = 1
	flags = FPRINT
	var/icon_closed = "closed"
	var/icon_opened = "open"
	var/opened = 0
	var/welded = 0
	health = 100
	max_health = 100
	damage_resistance = 0
	var/lastbang
	var/storage_capacity = 30 //This is so that someone can't pack hundreds of items in a locker/crate
							  //then open it in a populated area to crash clients.


	New()
		..()
		spawn(1)
			if(opened)		// if closed, any item at the crate's loc is put in the contents
				return
			for(var/obj/item/I in src.loc)
				if(I.density || I.anchored || I == src) continue
				I.loc = src
		return


	alter_health()//What does this do
		return get_turf(src)


	CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
		if(air_group || height==0) return 1
		return (!density)


	proc/can_open()
		if(src.welded)
			return 0
		return 1


	proc/can_close()//We cant figure out any reason why this needs to be here
		///for(var/obj/structure/closet/closet in get_turf(src))
		//	if(closet != src)
		//		return 0
		return 1


	proc/dump_contents()
		for(var/atom/movable/A in src)
			A.loc = src.loc
			if(istype(A,/mob))
				var/mob/M = A
				if(M.client)
					M.client.eye = M.client.mob
					M.client.perspective = MOB_PERSPECTIVE
		return
/*		//Cham Projector Exception
		for(var/obj/effect/dummy/chameleon/AD in src)
			AD.loc = src.loc

		for(var/obj/item/I in src)
			I.loc = src.loc

		for(var/mob/M in src)
			M.loc = src.loc
			if(M.client)
				M.client.eye = M.client.mob
				M.client.perspective = MOB_PERSPECTIVE
*/

	proc/open()
		if(src.opened)
			return 0

		if(!src.can_open())
			return 0

		src.dump_contents()

		src.opened = 1
		if(istype(src, /obj/structure/closet/body_bag))
			playsound(src.loc, 'sound/items/zip.ogg', 15, 1, -3)
		else
			playsound(src.loc, 'sound/machines/click.ogg', 15, 1, -3)
		density = 0
		update_icon()
		return 1


	proc/close()
		if(!src.opened)
			return 0
		if(!src.can_close())
			return 0

		var/itemcount = 0

		//Cham Projector Exception
		for(var/obj/effect/dummy/chameleon/AD in src.loc)
			if(itemcount >= storage_capacity)
				break
			AD.loc = src
			itemcount++

		for(var/obj/item/I in src.loc)
			if(itemcount >= storage_capacity)
				break
			if(!I.anchored)
				I.loc = src
				itemcount++

		for(var/mob/M in src.loc)
			if(itemcount >= storage_capacity)
				break
			if(istype (M, /mob/dead/observer))
				continue
			if(M.buckled)
				continue

			if(M.client)
				M.client.perspective = EYE_PERSPECTIVE
				M.client.eye = src

			M.loc = src
			itemcount++

		src.opened = 0
		if(istype(src, /obj/structure/closet/body_bag))
			playsound(src.loc, 'sound/items/zip.ogg', 15, 1, -3)
		else
			playsound(src.loc, 'sound/machines/click.ogg', 15, 1, -3)
		density = 1
		update_icon()
		return 1


	proc/toggle()
		if(src.opened)
			return src.close()
		return src.open()


	destroy()
		dump_contents()
		..()
		return


// this should probably use dump_contents()
	ex_act(severity)
		switch(severity)
			if(1)
				for(var/atom/movable/A as mob|obj in src)//pulls everything out of the locker and hits it with an explosion
					A.loc = src.loc
					A.ex_act(severity++)
				del(src)
			if(2)
				if(prob(50))
					for (var/atom/movable/A as mob|obj in src)
						A.loc = src.loc
						A.ex_act(severity++)
					del(src)
			if(3)
				if(prob(5))
					for(var/atom/movable/A as mob|obj in src)
						A.loc = src.loc
						A.ex_act(severity++)
					del(src)


	attack_animal(mob/living/simple_animal/user as mob)
		if(user.wall_smash)
			visible_message("\red [user] hits the [src]. ")
			damage(50)//Just damage for 50, use to just kill it instantly
		return


	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(src.opened)
			if(istype(W, /obj/item/weapon/grab))
				src.MouseDrop_T(W:affecting, user)      //act like they were dragged onto the closet
				return 0

			if(istype(W, /obj/item/weapon/weldingtool))
				var/obj/item/weapon/weldingtool/WT = W
				if(!WT.welding)
					user << "<span class='notice'>The welding tool needs to be on.</span>"
					return 0
				if(!WT.remove_fuel(0,user))
					user << "<span class='notice'>You need more welding fuel to complete this task.</span>"
					return 0
				new /obj/item/stack/sheet/metal(src.loc)
				for(var/mob/M in viewers(src))
					M.show_message("<span class='notice'>\The [src] has been cut apart by [user] with \the [WT].</span>", 3, "You hear welding.", 2)
				del(src)
				return 0

			if(isrobot(user))
				return 0

			user.drop_item()
			if(W)
				W.loc = src.loc
			return

		if(istype(W, /obj/item/weapon/packageWrap))
			return 0
		if(istype(W, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/WT = W
			if(!WT.welding)
				user << "<span class='notice'>The welding tool needs to be on.</span>"
				return 0
			if(!WT.remove_fuel(0,user))
				user << "<span class='notice'>You need more welding fuel to complete this task.</span>"
				return 0
			src.welded =! src.welded
			src.update_icon()
			for(var/mob/M in viewers(src))
				M.show_message("<span class='warning'>[src] has been [welded?"welded shut":"unwelded"] by [user.name].</span>", 3, "You hear welding.", 2)
			return 0

		src.attack_hand(user)
		return 1


	MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
		if(istype(O, /obj/screen))	//fix for HUD elements making their way into the world	-Pete
			return
		if(O.loc == user)
			return
		if(user.restrained() || user.stat || user.stunned || user.paralysis)
			return
		if((!( istype(O, /atom/movable) ) || O.anchored || get_dist(user, src) > 1 || get_dist(user, O) > 1 || user.contents.Find(src)))
			return
		if(user.loc==null) // just in case someone manages to get a closet into the blue light dimension, as unlikely as that seems
			return
		if(!istype(user.loc, /turf)) // are you in a container/closet/pod/etc?
			return
		if(!src.opened)
			return
		if(istype(O, /obj/structure/closet))
			return
		step_towards(O, src.loc)
		if(user != O)
			user.show_viewers("<span class='danger'>[user] stuffs [O] into [src]!</span>")
		src.add_fingerprint(user)
		return


	relaymove(mob/user as mob)
		if(user.stat || !isturf(src.loc))
			return

		if(!src.open())
			user << "<span class='notice'>It won't budge!</span>"
			if(!lastbang)
				lastbang = 1
				for (var/mob/M in hearers(src, null))
					M << text("<FONT size=[]>BANG, bang!</FONT>", max(0, 5 - get_dist(src, M)))
				spawn(30)
					lastbang = 0


	attack_paw(mob/user as mob)
		return src.attack_hand(user)


	attack_hand(mob/user as mob)
		src.add_fingerprint(user)
		if(!src.toggle())
			usr << "<span class='notice'>It won't budge!</span>"
		return

	verb/verb_toggleopen()
		set src in oview(1)
		set category = "Object"
		set name = "Toggle Open"

		if(!usr.canmove || usr.stat || usr.restrained())
			return

		if(ishuman(usr))
			src.attack_hand(usr)
		else
			usr << "<span class='warning'>This mob type can't use this verb.</span>"
		return


	update_icon()//Putting the welded stuff in updateicon() so it's easy to overwrite for special cases (Fridges, cabinets, and whatnot)
		overlays.Cut()
		if(opened)
			icon_state = icon_opened
			return
		icon_state = icon_closed
		if(welded)
			overlays += "welded"
		return

