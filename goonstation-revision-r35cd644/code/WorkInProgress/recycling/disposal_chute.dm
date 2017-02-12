// Disposal bin
// Holds items for disposal into pipe system
// Draws air from turf, gradually charges internal reservoir
// Once full (~1 atm), uses air resv to flush items into the pipes
// Automatically recharges air (unless off), will flush when ready if pre-set
// Can hold items and human size things, no other draggables

/obj/machinery/disposal
	name = "disposal unit"
	desc = "A pneumatic waste disposal unit."
	icon = 'icons/obj/disposal.dmi'
	icon_state = "disposal"
	anchored = 1
	density = 1
	flags = NOSPLASH
	var/datum/gas_mixture/air_contents	// internal reservoir
	var/mode = 1	// item mode 0=off 1=charging 2=charged
	var/flush = 0	// true if flush handle is pulled
	var/obj/disposalpipe/trunk/trunk = null // the attached pipe trunk
	var/flushing = 0	// true if flushing in progress
	var/icon_style = "disposal"
	var/handle_state = null // this is the overlay added when the handle is in the normal position (for the small chutes, mainly this can be ignored otherwise)
	var/image/handle_image = null
	mats = 20			// whats the point of letting people build trunk pipes if they cant build new disposals?
	power_usage = 100

	// create a new disposal
	// find the attached trunk (if present) and init gas resvr.
	New()
		..()
		spawn(5)
			if (src)
				trunk = locate() in src.loc
				if(!trunk)
					mode = 0
					flush = 0
				else
					trunk.linked = src	// link the pipe trunk to self

				initair()
				update()

	disposing()
		if(air_contents)
			pool(air_contents)
			air_contents = null
		..()

	proc/initair()
		air_contents = unpool(/datum/gas_mixture)
		air_contents.volume = 255
		air_contents.nitrogen = 16.5
		air_contents.oxygen = 4.4
		air_contents.temperature = 293.15

	// attack by item places it in to disposal
	attackby(var/obj/item/I, var/mob/user)
		if(stat & BROKEN)
			return
		if (istype(I,/obj/item/electronics/scanner))
			user.visible_message("<span style=\"color:red\"><B>[user] hits [src] with [I]!</B></span>")
			return
		if (istype(I,/obj/item/satchel/))
			var/action = input(usr, "What do you want to do with the satchel?") in list("Empty it into the Chute","Place it in the Chute","Never Mind")
			if (!action || action == "Never Mind") return
			if (get_dist(src,user) > 1)
				boutput(user, "<span style=\"color:red\">You need to be closer to the chute to do that.</span>")
				return
			if (action == "Empty it into the Chute")
				var/obj/item/satchel/S = I
				for(var/obj/item/O in S.contents) O.set_loc(src)
				S.satchel_updateicon()
				user.visible_message("<b>[user.name]</b> dumps out [S] into [src].")
				return
		if (issilicon(user))
			boutput(user, "<span style=\"color:red\">You can't put that in the trash when it's attached to you!</span>")
			return

		var/obj/item/grab/G = I
		if(istype(G))	// handle grabbed mob
			if (ismob(G.affecting))
				var/mob/GM = G.affecting
				if (istype(src, /obj/machinery/disposal/mail) && !GM.canRideMailchutes())
					boutput(user, "<span style=\"color:red\">That won't fit!</span>")
					return
				GM.set_loc(src)
				user.visible_message("<span style=\"color:red\"><b>[user.name] stuffs [GM.name] into [src]!</b></span>")
				qdel(G)
				logTheThing("combat", user, GM, "places %target% into [src] at [log_loc(src)].")
				actions.interrupt(G.affecting, INTERRUPT_MOVE)
				actions.interrupt(user, INTERRUPT_ACT)
		else
			if (!user.drop_item())
				return
			I.set_loc(src)
			boutput(user, "You place \the [I] into the [src].")
			user.show_message("[user.name] places \the [I] into the [src].")
			actions.interrupt(user, INTERRUPT_ACT)

		update()

	// mouse drop another mob or self
	//
	MouseDrop_T(mob/target, mob/user)
		//jesus fucking christ
		if (!istype(target) || target.buckled || get_dist(user, src) > 1 || get_dist(user, target) > 1 || user.stat || user.paralysis || user.stunned || user.weakened || istype(user, /mob/living/silicon/ai) || istype(target, /mob/living/silicon/ai))
			return

		if (istype(src, /obj/machinery/disposal/mail) && istype(target, /mob/living))
			//Is this mob allowed to ride mailchutes?
			if (!target.canRideMailchutes())
				boutput(user, "<span style=\"color:red\">That won't fit!</span>")
				return

		var/msg
		var/turf/Q = target.loc
		sleep (5)
		if(target == user && !user.stat)	// if drop self, then climbed in
												// must be awake
			msg = "[user.name] climbs into the [src]."
			boutput(user, "You climb into the [src].")
		else if(target != user && !user.restrained() && Q == target.loc)
			msg = "[user.name] stuffs [target.name] into the [src]!"
			boutput(user, "You stuff [target.name] into the [src]!")
			logTheThing("combat", user, target, "places %target% into [src] at [log_loc(src)].")
		else
			return
		actions.interrupt(target, INTERRUPT_MOVE)
		actions.interrupt(user, INTERRUPT_ACT)
		target.set_loc(src)

		if (msg)
			src.visible_message(msg)

		update()
		return

	hitby(MO as mob|obj)
		// This feature interferes with mail delivery, i.e. objects bouncing back into the chute.
		// Leaves people wondering where the stuff is, assuming they received a PDA alert at all.
		if (istype(src, /obj/machinery/disposal/mail))
			return ..()

		if(istype(MO, /obj/item))
			var/obj/item/I = MO

			if(prob(20)) //It might land!
				I.set_loc(get_turf(src))
				if(prob(30)) //It landed cleanly!
					I.set_loc(src)
					src.visible_message("<span style=\"color:red\">\The [I] lands cleanly in \the [src]!</span>")
				else	//Aaaa the tension!
					src.visible_message("<span style=\"color:red\">\The [I] teeters on the edge of \the [src]!</span>")
					var/delay = rand(5, 15)
					spawn(0)
						var/in_x = I.pixel_x
						for(var/d = 0; d < delay; d++)
							if(I) I.pixel_x = in_x + rand(-1, 1)
							sleep(1)
						if(I) I.pixel_x = in_x
					sleep(delay)
					if(I && I.loc == src.loc)
						if(prob(40)) //It goes in!
							src.visible_message("<span style=\"color:red\">\The [I] slips into \the [src]!</span>")
							I.set_loc(src)
						else
							src.visible_message("<span style=\"color:red\">\The [I] slips off of the edge of \the [src]!</span>")

		else if (ishuman(MO))
			var/mob/living/carbon/human/H = MO
			H.set_loc(get_turf(src))
			if(prob(30))
				H.visible_message("<span style=\"color:red\"><B>[H] falls into the disposal outlet!</B></span>")
				logTheThing("combat", H, null, "is thrown into a [src.name] at [log_loc(src)].")
				H.set_loc(src)
				if(prob(20))
					src.visible_message("<span style=\"color:red\"><B><I>...accidentally hitting the handle!</I></B></span>")
					H.show_text("<B><I>...accidentally hitting the handle!</I></B>", "red")
					flush = 1
					update()
		else
			return ..()


	// can breath normally in the disposal
	alter_health()
		return get_turf(src)

	// attempt to move while inside
	relaymove(mob/user as mob)
		if(user.stat || src.flushing)
			return
		src.go_out(user)
		return

	// leave the disposal
	proc/go_out(mob/user)
		user.set_loc(src.loc)
		user.weakened = max(user.weakened, 2)
		update()
		return

	// ai as human but can't flush
	attack_ai(mob/user as mob)
		interact(user, 1)

	// human interact with machine
	attack_hand(mob/user as mob)
		interact(user, 0)

	proc/interact(mob/user, var/ai=0)
		src.add_fingerprint(user)
		if(stat & BROKEN)
			user.machine = null
			return

		var/dat = "<head><title>Waste Disposal Unit</title></head><body><TT><B>Waste Disposal Unit</B><HR>"

		if(!ai)  // AI can't pull flush handle
			if(flush)
				dat += "Disposal handle: <A href='?src=\ref[src];handle=0'>Disengage</A> <B>Engaged</B>"
			else
				dat += "Disposal handle: <B>Disengaged</B> <A href='?src=\ref[src];handle=1'>Engage</A>"

			dat += "<BR><HR><A href='?src=\ref[src];eject=1'>Eject contents</A><HR>"

		if(mode == 0)
			dat += "Pump: <B>Off</B> <A href='?src=\ref[src];pump=1'>On</A><BR>"
		else if(mode == 1)
			dat += "Pump: <A href='?src=\ref[src];pump=0'>Off</A> <B>On</B> (pressurizing)<BR>"
		else
			dat += "Pump: <A href='?src=\ref[src];pump=0'>Off</A> <B>On</B> (idle)<BR>"

		if (!air_contents)
			initair()

		var/per = 100* air_contents.return_pressure() / (2*ONE_ATMOSPHERE)

		dat += "Pressure: [round(per, 1)]%<BR></body>"


		user.machine = src
		user << browse(dat, "window=disposal;size=360x170")
		onclose(user, "disposal")

	// handle machine interaction

	Topic(href, href_list)
		..()
		src.add_fingerprint(usr)
		if(stat & BROKEN)
			DEBUG("[src] is broken")
			return
		if(usr.stat || usr.restrained() || src.flushing)
			DEBUG("[src] is flushing/usr.stat returned with someting/usr is restrained")
			return

		if (in_range(src, usr) && isturf(src.loc))
			DEBUG("in range of [src] and it is on a turf")
			usr.machine = src

			if(href_list["close"])
				DEBUG("closed [src]")
				usr.machine = null
				usr << browse(null, "window=disposal")
				return

			if(href_list["pump"])
				if(text2num(href_list["pump"]))
					DEBUG("[src] pump engaged")
					power_usage = 600
					mode = 1
				else
					DEBUG("[src] pump disengaged")
					power_usage = 100
					mode = 0
				update()

			if(href_list["handle"])
				DEBUG("[src] handle")
				flush = text2num(href_list["handle"])
				update()

			if(href_list["eject"])
				DEBUG("[src] eject")
				eject()
		else
			if (!isturf(src.loc))
				DEBUG("[src]'s loc is not a turf: [src.loc]")
			if (!in_range(src, usr))
				DEBUG("[src] and [usr] are too far apart: [src] [log_loc(src)], [usr] [log_loc(usr)]")

			usr << browse(null, "window=disposal")
			usr.machine = null
			return
		return

	// eject the contents of the disposal unit
	proc/eject()
		for(var/atom/movable/AM in src)
			AM.set_loc(src.loc)
			AM.pipe_eject(0)
		update()

	// update the icon & overlays to reflect mode & status
	proc/update()
		if (stat & BROKEN)
			icon_state = "disposal-broken"
			ClearAllOverlays()
			mode = 0
			flush = 0
			return

		// flush handle
		if (flush)
			if (!src.handle_image)
				src.handle_image = image(src.icon, "[icon_style]-over-handle")
			else if (!src.handle_state)
				src.handle_image.icon_state = "[icon_style]-over-handle"
			UpdateOverlays(src.handle_image, "handle")
		else
			if (src.handle_state)
				if (!src.handle_image)
					src.handle_image = image(src.icon, src.handle_state)
				else
					src.handle_image.icon_state = src.handle_state
				UpdateOverlays(src.handle_image, "handle")
			else
				UpdateOverlays(null, "handle", 0, 1)

		// only handle is shown if no power
		if (stat & NOPOWER)
			return

		// 	check for items in disposal - occupied light
		if (contents.len > 0)
			var/image/I = GetOverlayImage("content_light")
			if (!I)
				I = image(src.icon, "dispover-full")
			UpdateOverlays(I, "content_light")
		else
			UpdateOverlays(null, "content_light", 0, 1)

		// charging and ready light
		var/image/I = GetOverlayImage("status")
		if (!I)
			I = image(src.icon, "dispover-charge")
		switch (mode)
			if (1)
				I.icon_state = "dispover-charge"
			if (2)
				I.icon_state = "dispover-ready"
			else
				I = null

		UpdateOverlays(I, "status", 0, 1)
		/*
		if(mode == 1)
			overlays += image('icons/obj/disposal.dmi', "dispover-charge")
		else if(mode == 2)
			overlays += image('icons/obj/disposal.dmi', "dispover-ready")
		*/
	// timed process
	// charge the gas reservoir and perform flush if ready
	process()
		if(stat & BROKEN)			// nothing can happen if broken
			return

		..()

		src.updateDialog()

		if(flush && air_contents.return_pressure() >= 2*ONE_ATMOSPHERE)	// flush can happen even without power
			spawn(0) //Quit holding up the process you fucker
				flush()

		if(stat & NOPOWER)			// won't charge if no power
			return

		if (!loc) return

		use_power(100)		// base power usage

		if(mode != 1)		// if off or ready, no need to charge
			return

		// otherwise charge
		use_power(500)		// charging power usage

		var/atom/L = loc						// recharging from loc turf
		var/datum/gas_mixture/env = L.return_air()
		if (!air_contents)
			air_contents = unpool(/datum/gas_mixture)
		var/pressure_delta = (ONE_ATMOSPHERE*2.1) - air_contents.return_pressure()

		if(env.temperature > 0)
			var/transfer_moles = 0.1 * pressure_delta*air_contents.volume/(env.temperature * R_IDEAL_GAS_EQUATION)

			//Actually transfer the gas
			var/datum/gas_mixture/removed = env.remove(transfer_moles)
			air_contents.merge(removed)


		// if full enough, switch to ready mode
		if(air_contents.return_pressure() >= 2*ONE_ATMOSPHERE)
			mode = 2
			power_usage = 100
			update()
		return

	// perform a flush
	proc/flush()

		flushing = 1
		flick("[icon_style]-flush", src)

		var/obj/disposalholder/H = new()	// virtual holder object which actually
											// travels through the pipes.

		H.init(src)	// copy the contents of disposer to holder

		air_contents.zero()

		sleep(10)
		playsound(src, 'sound/machines/disposalflush.ogg', 50, 0, 0)
		sleep(5) // wait for animation to finish


		H.start(src) // start the holder processing movement
		flushing = 0
		// now reset disposal state
		flush = 0
		if(mode == 2)	// if was ready,
			mode = 1	// switch to charging
		power_usage = 600
		update()
		return


	// called when area power changes
	power_change()
		..()	// do default setting/reset of stat NOPOWER bit
		update()	// update icon
		return


	// called when holder is expelled from a disposal
	// should usually only occur if the pipe network is modified
	proc/expel(var/obj/disposalholder/H)

		var/turf/target
		playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)
		for(var/atom/movable/AM in H)
			target = get_offset_target_turf(src.loc, rand(5)-rand(5), rand(5)-rand(5))

			AM.set_loc(src.loc)
			AM.pipe_eject(0)
			spawn(1)
				if(AM)
					AM.throw_at(target, 5, 1)

		H.vent_gas(loc)
		qdel(H)

	suicide(var/mob/user as mob)
		if(src.mode != 2 || !hasvar(user,"organHolder")) return 0

		user.visible_message("<span style=\"color:red\"><b>[user] sticks \his head into the [src.name] and pulls the flush!</b></span>")
		var/obj/head = user:organHolder.drop_organ("head")
		head.set_loc(src)
		src.flush()
		playsound(src.loc, 'sound/effects/bloody_stab.ogg', 50, 1)
		new /obj/decal/cleanable/blood(user.loc)
		user.updatehealth()
		spawn(100)
			if (user)
				user.suiciding = 0
		return 1

/obj/machinery/disposal/small
	icon = 'icons/obj/disposal_small.dmi'
	handle_state = "dispover-handle"
	density = 0

	north
		dir = NORTH
	east
		dir = EAST
	south
		dir = SOUTH
	west
		dir = WEST

/obj/machinery/disposal/brig
	name = "brig chute"
	icon_state = "brigchute"
	desc = "A pneumatic delivery chute for sending things directly to the brig."
	icon_style = "brig"

/obj/machinery/disposal/morgue
	name = "morgue chute"
	icon_state = "morguechute"
	desc = "A pneumatic delivery chute for sending things directly to the morgue."
	icon_style = "morgue"

/obj/machinery/disposal/alert_a_chump
	var/message = null
	var/mailgroup = null

	var/net_id = null
	var/frequency = 1149
	var/datum/radio_frequency/radio_connection

	New()
		..()
		spawn(8)
			if(radio_controller)
				radio_connection = radio_controller.add_object(src, "[frequency]")
			if(!src.net_id)
				src.net_id = generate_net_id(src)

	expel(var/obj/disposalholder/H)
		..(H)

		if (message && mailgroup && radio_connection)
			var/datum/signal/newsignal = get_free_signal()
			newsignal.source = src
			newsignal.transmission_method = TRANSMISSION_RADIO
			newsignal.data["command"] = "text_message"
			newsignal.data["sender_name"] = "CHUTE-MAILBOT"
			newsignal.data["message"] = "[message]"

			newsignal.data["address_1"] = "00000000"
			newsignal.data["group"] = mailgroup
			newsignal.data["sender"] = src.net_id

			radio_connection.post_signal(src, newsignal)