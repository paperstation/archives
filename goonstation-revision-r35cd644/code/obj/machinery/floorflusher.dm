//Floor Flushing Mechanism.

/obj/machinery/floorflusher
	name = "\improper Floor Flusher"
	desc = "It's totally not just a gigantic disposal chute!"
	//icon = 'icons/obj/disposal.dmi'
	icon = 'icons/obj/delivery.dmi' // new icon
	icon_state = "floorflush_c"
	anchored = 1
	density = 0
	flags = NOSPLASH
	var/open = 0 //is it open
	var/id = null //ID used for brig stuff
	var/datum/gas_mixture/air_contents	// internal reservoir
	var/mode = 1	// item mode 0=off 1=charging 2=charged
	var/flush = 0	// true if triggered
	var/obj/disposalpipe/trunk/trunk = null // the attached pipe trunk, if none reject user
	var/flushing = 0	// true if flushing in progress

	// Please keep synchronizied with these lists for easy map changes:
	// /obj/storage/secure/closet/brig/automatic (secure_closets.dm)
	// /obj/machinery/door_timer (door_timer.dm)
	// /obj/machinery/door/window/brigdoor (window.dm)
	// /obj/machinery/flasher (flasher.dm)
	solitary
		name = "\improper Floor Flusher (Cell #1)"
		id = "solitary"

	solitary2
		name = "\improper Floor Flusher (Cell #2)"
		id = "solitary2"

	solitary3
		name = "\improper Floor Flusher (Cell #3)"
		id = "solitary3"

	solitary4
		name = "\improper Floor Flusher (Cell #4)"
		id = "solitary4"

	minibrig
		name = "\improper Floor Flusher (Mini-Brig)"
		id = "minibrig"

	minibrig2
		name = "\improper Floor Flusher (Mini-Brig #2)"
		id = "minibrig2"

	minibrig3
		name = "\improper Floor Flusher (Mini-Brig #3)"
		id = "minibrig3"

	genpop
		name = "\improper Floor Flusher (Genpop)"
		id = "genpop"

	genpop_n
		name = "\improper Floor Flusher (Genpop North)"
		id = "genpop_n"

	genpop_s
		name = "\improper Floor Flusher (Genpop South)"
		id = "genpop_s"

	// create a new floor flusher
	// find the attached trunk (if present) and init gas resvr.
	New()
		..()
		spawn(5)
			trunk = locate() in src.loc
			if(!trunk)
				mode = 0
				flush = 0
			else
				trunk.linked = src	// link the pipe trunk to self

			air_contents = unpool(/datum/gas_mixture)
			//gas.volume = 1.05 * CELLSTANDARD
			update()

	disposing()
		if(air_contents)
			pool(air_contents)
			air_contents = null
		..()

	// attack by item places it in to disposal
	attackby(var/obj/item/I, var/mob/user)
		if(stat & BROKEN)
			return

		if(open == 1)
			user.drop_item()
			I.set_loc(src)
			user.visible_message("[user.name] drops \the [I] into the [src].", "You drop \the [I] into the inky blackness of the [src].")

		update()

	// mouse drop another mob or self

	HasEntered(atom/A)
		//you can fall in if its open
		if(open == 1)


			if(istype(A, /obj))
				var/obj/O = A
				O.set_loc(src)
				update()

			if(istype(A, /mob/living))
				var/mob/living/M = A
				M.set_loc(src)
				if (M.buckled)
					M.buckled = null
				boutput(M, "You fall into the [src].")
				src.visible_message("[M] falls into the [src].")
				flush = 1
				update()

	MouseDrop_T(mob/target, mob/user)
		if (!istype(target) || target.buckled || get_dist(user, src) > 1 || get_dist(user, target) > 1 || user.stat || user.paralysis || user.stunned || user.weakened || istype(user, /mob/living/silicon/ai))
			return

		if(open != 1)
			return

		var/msg

		if(target == user && !user.stat)	// if drop self, then climbed in
												// must be awake
			msg = "[user.name] falls into [src]."
			boutput(user, "You fall into [src].")
		else if(target != user && !user.restrained())
			msg = "[user.name] pushes [target.name] into the [src]!"
			boutput(user, "You push [target.name] into the [src]!")
		else
			return
		target.set_loc(src)

		for (var/mob/C in AIviewers(src))
			if(C == user)
				continue
			C.show_message(msg, 3)

		update()
		return

	// can breath normally in the disposal
	alter_health()
		return get_turf(src)

	// attempt to move while inside
	relaymove(mob/user as mob)
		if(user.stat || src.flushing)
			return
		boutput(user, "<span style=\"color:red\">It's too deep. You can't climb out.</span>")
		return

	// ai cannot interface.
	attack_ai(mob/user as mob)
		boutput(user, "<span style=\"color:red\">You cannot interface with this device.</span>")

	// human interact with machine
	attack_hand(mob/user as mob)
		src.add_fingerprint(usr)
		if (open != 1)
			return
		if(stat & BROKEN)
			user.machine = null
			return

		//fall in hilariously
		boutput(user, "You slip and fall in.")
		user.set_loc(src)
		update()


	// eject the contents of the unit
	proc/eject()
		for(var/atom/movable/AM in src)
			AM.set_loc(src.loc)
			AM.pipe_eject(0)
		update()

	// update the icon & overlays to reflect mode & status
	proc/update()
		overlays = null
		if(stat & BROKEN)
			icon_state = "floorflush_c"
			mode = 0
			flush = 0
			return

		// 	check for items in disposal - if there is a mob in there, flush.
		if(contents.len > 0)
			var/mob/living/M = locate() in contents
			if(M)
				flush = 1
				if(M.handcuffed)
					boutput(M, "You feel your handcuffs being removed.")
					M.handcuffed = null
					new /obj/item/handcuffs(src)

	// timed process
	// charge the gas reservoir and perform flush if ready
	process()
		if(stat & BROKEN)			// nothing can happen if broken
			return

		src.updateDialog()

		if(open && flush)	// flush can happen even without power, must be open first
			flush()

		if(stat & NOPOWER)			// won't charge if no power
			return

		use_power(100)		// base power usage

		if(mode != 1)		// if off or ready, no need to charge
			return
		return

	// perform a flush
	proc/flush()

		flushing = 1

		closeup()
		var/obj/disposalholder/H = new()	// virtual holder object which actually
											// travels through the pipes.

		H.init(src)	// copy the contents of disposer to holder

		air_contents.zero() // empty gas

		sleep(10)
		playsound(src, "sound/machines/disposalflush.ogg", 50, 0, 0)
		sleep(5) // wait for animation to finish


		H.start(src) // start the holder processing movement
		flushing = 0
		// now reset disposal state
		flush = 0



		if(mode == 2)	// if was ready,
			mode = 1	// switch to charging
		update()
		return

	// called when area power changes
	power_change()
		..()	// do default setting/reset of stat NOPOWER bit
		update()	// update icon
		return


	//open up, called on trigger
	proc/openup()
		open = 1
		flick("floorflush_a", src)
		src.icon_state = "floorflush_o"

	proc/closeup()
		open = 0
		flick("floorflush_a2", src)
		src.icon_state = "floorflush_c"

	// called when holder is expelled from a disposal
	// should usually only occur if the pipe network is modified
	proc/expel(var/obj/disposalholder/H)

		var/turf/target
		playsound(src, "sound/machines/hiss.ogg", 50, 0, 0)
		for(var/atom/movable/AM in H)
			target = get_offset_target_turf(src.loc, rand(5)-rand(5), rand(5)-rand(5))

			AM.set_loc(src.loc)
			AM.pipe_eject(0)
			spawn(1)
				if(AM)
					AM.throw_at(target, 5, 1)

		H.vent_gas(loc)
		qdel(H)


/obj/machinery/floorflusher/industrial
	name = "industrial loading chute"
	desc = "Totally just a giant disposal chute"
	icon = 'icons/obj/delivery.dmi'


	New()
		..()
		spawn (10)
			openup()

	Crossed(atom/movable/AM)
		if (AM && AM.loc == src.loc)
			HasEntered(AM)

		return 1

	HasEntered(atom/A)
		if(open == 1)

			if(istype(A, /obj))
				var/obj/O = A
				if (O.loc != src.loc)
					return

				O.set_loc(src)

				src.visible_message("[O] falls into [src].")
				flush = 1
				update()

			else if(istype(A, /mob/living))
				var/mob/living/M = A
				M.set_loc(src)
				if (M.buckled)
					M.buckled = null
				boutput(M, "You fall into the [src].")
				src.visible_message("[M] falls into [src].")
				flush = 1
				update()

	process()
		if(stat & BROKEN)			// nothing can happen if broken
			return

		src.updateDialog()

		if(open && flush)	// flush can happen even without power, must be open first
			flush()

		if(stat & NOPOWER)			// won't charge if no power
			return

		use_power(100)		// base power usage

		if(mode == 1)
			mode = 2
			if (!open)
				openup()

		return