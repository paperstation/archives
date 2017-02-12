//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

#define SOLAR_MAX_DIST 40
#define SOLARGENRATE 1500

#define TRACK_OFF 0
#define TRACK_MANUAL 1
#define TRACK_AUTO 2

/obj/machinery/power/solar
	name = "solar panel"
	desc = "A solar electrical generator."
	icon = 'icons/obj/power.dmi'
	icon_state = "sp_base"
	anchored = 1
	density = 1
	directwired = 1
	use_power = USE_POWER_IDLE
	idle_power_usage = 0
	active_power_usage = 250
	var/id = 0
	health = 10
	max_health = 10

	var/sunfrac = 0
	var/angle
	var/obj/machinery/power/solar_control/control = null

/obj/machinery/power/solar/New(var/turf/loc, var/obj/item/solar_assembly/S, var/process = 1)
	if(process)	SSsun.solars += src
	..(loc)
	Make(S)
	connect_to_network()

/obj/machinery/power/solar/Del()
	SSsun.solars -= src
	..()

/obj/machinery/power/solar/process_power(seconds)
	if(stat & BROKEN) return
	if(!powernet) return

	if(control && (control.powernet == powernet) && (get_dist(control, src) < SOLAR_MAX_DIST))
		if(angle != control.angle)
			angle = control.angle
			dir = angle2dir(-angle)
			use_power = USE_POWER_ACTIVE	//we are rotating, and therefore use power
		else
			use_power = USE_POWER_IDLE
	else
		control = null
		use_power = USE_POWER_IDLE

	. = ..()	//handles automatic use of power stuff (like every other powered machine)


	var/sgen = SOLARGENRATE * sunfrac * seconds
	if(sgen <= 0)	return

	add_avail(sgen)

	if(control)
		control.gen += sgen

/obj/machinery/power/solar/proc/Make(var/obj/item/solar_assembly/S)
	if(!S)
		S = new /obj/item/solar_assembly(src)
		S.glass_type = /obj/item/stack/sheet/glass
		S.anchored = 1
	S.loc = src
	update_icon()



/obj/machinery/power/solar/attackby(obj/item/weapon/W, mob/user)
	if(iscrowbar(W))
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		if(do_after(user, 50))
			var/obj/item/solar_assembly/S = locate() in src
			if(S)
				S.loc = src.loc
				S.give_glass()
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			user.visible_message("<span class='notice'>[user] takes the glass off the solar panel.</span>")
			del(src)
		return
	else if(W && user.a_intent != "hurt")
		damaged_by(W, user)
		return
	..()
	return


/obj/machinery/power/solar/destroy()
	new /obj/item/weapon/shard(src.loc)
	new /obj/item/weapon/shard(src.loc)
	..()
	return


/obj/machinery/power/solar/update_icon()
	..()
	overlays.Cut()
	if(stat & BROKEN)
		overlays += "solar_panel-b"
	else
		overlays += "solar_panel"
	return



/obj/machinery/power/solar/proc/broken()
	stat |= BROKEN
	update_icon()
	return


/obj/machinery/power/solar/ex_act(severity)
	damage(50)
	return

/obj/machinery/power/solar/fake
	use_power = USE_POWER_NONE

/obj/machinery/power/solar/fake/New(var/turf/loc, var/obj/item/solar_assembly/S)
	..(loc, S, 0)

/obj/machinery/power/solar/fake/process()
	return PROCESS_KILL


//
// Solar Assembly - For construction of solar arrays.
//

/obj/item/solar_assembly
	name = "solar panel assembly"
	desc = "A solar panel assembly kit, allows constructions of a solar panel, or with a tracking circuit board, a solar tracker"
	icon = 'icons/obj/power.dmi'
	icon_state = "sp_base"
	item_state = "electropack"
	w_class = 4 // Pretty big!
	anchored = 0
	var/tracker = 0
	var/glass_type = null

/obj/item/solar_assembly/attack_hand(var/mob/user)
	if(!anchored && isturf(loc)) // You can't pick it up
		..()

// Give back the glass type we were supplied with
/obj/item/solar_assembly/proc/give_glass()
	if(glass_type)
		var/obj/item/stack/sheet/S = new glass_type(src.loc)
		S.amount = 2
		glass_type = null


/obj/item/solar_assembly/attackby(var/obj/item/weapon/W, var/mob/user)

	if(!anchored && isturf(loc))
		if(iswrench(W))
			anchored = 1
			user.visible_message("<span class='notice'>[user] wrenches the solar assembly into place.</span>")
			playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
			return 1
	else
		if(iswrench(W))
			anchored = 0
			user.visible_message("<span class='notice'>[user] unwrenches the solar assembly from it's place.</span>")
			playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
			return 1

		if(istype(W, /obj/item/stack/sheet/glass) || istype(W, /obj/item/stack/sheet/rglass))
			var/obj/item/stack/sheet/S = W
			if(S.amount >= 2)
				glass_type = W.type
				S.use(2)
				playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
				user.visible_message("<span class='notice'>[user] places the glass on the solar assembly.</span>")
				if(tracker)
					new /obj/machinery/power/tracker(get_turf(src), src)
				else
					new /obj/machinery/power/solar(get_turf(src), src)
			return 1

	if(!tracker)
		if(istype(W, /obj/item/weapon/tracker_electronics))
			tracker = 1
			user.drop_item()
			del(W)
			user.visible_message("<span class='notice'>[user] inserts the electronics into the solar assembly.</span>")
			return 1
	else
		if(iscrowbar(W))
			new /obj/item/weapon/tracker_electronics(src.loc)
			tracker = 0
			user.visible_message("<span class='notice'>[user] takes out the electronics from the solar assembly.</span>")
			return 1
	..()

//
// Solar Control Computer
//

/obj/machinery/power/solar_control
	name = "solar panel control"
	desc = "A controller for solar panel arrays."
	icon = 'icons/obj/computer.dmi'
	icon_state = "solar"
	anchored = 1
	density = 1
	directwired = 1
	use_power = USE_POWER_IDLE
	idle_power_usage = 5
	active_power_usage = 20
	var/id = 0

	var/angle = 0
	var/obj/machinery/power/tracker/tracker
	var/track_mode = TRACK_OFF			//TRACK_OFF, TRACK_MANUAL, TRACK_AUTO
	var/degrees_per_minute = 6

	var/gen = 0
	var/lastgen = 0

/obj/machinery/power/solar_control/New()
	..()
	initialize()
	connect_to_network()

/obj/machinery/power/solar_control/disconnect_from_network()
	. = ..()
	if(.)
		SSsun.controls.Remove(src)

/obj/machinery/power/solar_control/connect_to_network()
	. = ..()
	if(.)
		SSsun.controls.Add(src)

/obj/machinery/power/solar_control/update_icon()
	if(stat & BROKEN)
		icon_state = "computer_broken"
		overlays.Cut()
		return
	if(stat & NOPOWER)
		icon_state = "computer_no_power"
		overlays.Cut()
		return
	icon_state = "solar"
	overlays.Cut()
	if(angle)
		overlays += image('icons/obj/computer.dmi', "solcon-o", FLY_LAYER, angle2dir(-angle))
	return


/obj/machinery/power/solar_control/attack_ai(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN | NOPOWER)) return
	interact(user)


/obj/machinery/power/solar_control/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN | NOPOWER)) return
	interact(user)


/obj/machinery/power/solar_control/attackby(I as obj, mob/user as mob)
	if(user.a_intent == "hurt")
		..()
		return
	if(istype(I, /obj/item/weapon/screwdriver))
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			if (src.stat & BROKEN)
				user << "\blue The broken glass falls out."
				var/obj/structure/computerframe/A = new /obj/structure/computerframe( src.loc )
				new /obj/item/weapon/shard( src.loc )
				var/obj/item/weapon/circuitboard/solar_control/M = new /obj/item/weapon/circuitboard/solar_control( A )
				for (var/obj/C in src)
					C.loc = src.loc
				A.circuit = M
				A.state = 3
				A.icon_state = "3"
				A.anchored = 1
				del(src)
			else
				user << "\blue You disconnect the monitor."
				var/obj/structure/computerframe/A = new /obj/structure/computerframe( src.loc )
				var/obj/item/weapon/circuitboard/solar_control/M = new /obj/item/weapon/circuitboard/solar_control( A )
				for (var/obj/C in src)
					C.loc = src.loc
				A.circuit = M
				A.state = 4
				A.icon_state = "4"
				A.anchored = 1
				del(src)
	else
		src.attack_hand(user)
	return

// called by solar tracker when sun position changes
/obj/machinery/power/solar_control/proc/sun_update()
	lastgen = round(gen * 10 / SSsun.wait)
	gen = 0

	if(stat & (NOPOWER | BROKEN))
		return

	var/prev_angle = angle

	switch(track_mode)
		if(TRACK_MANUAL)
			if(degrees_per_minute)
				angle += (degrees_per_minute * SSsun.wait / 600)
				angle %= 360
				if(angle < 0)
					angle += 360
		if(TRACK_AUTO)
			if(tracker && tracker.powernet == powernet)
				var/tracker_angle = tracker.get_sun_angle()
				if(tracker_angle != null)
					angle = tracker_angle
			else
				tracker = null

	if(angle != prev_angle)
		update_icon()
		updateDialog()



/obj/machinery/power/solar_control/interact(mob/user)
	if(stat & (BROKEN | NOPOWER)) return
	if ( (get_dist(src, user) > 1 ))
		if (!istype(user, /mob/living/silicon/ai))
			user.unset_machine()
			user << browse(null, "window=solcon")
			return

	add_fingerprint(user)
	user.set_machine(src)

	var/t = "<TT><B>Solar Generator Control</B><HR><PRE>"
	t += "Generated power : [lastgen] W/s<BR><BR>"
	t += "<B>Orientation</B>: [rate_control(src,"angle","[angle]&deg",1,15)] ([angle2text(-angle)])<BR><BR>"
	t += "<B>Solar Tracker</B>: [tracker ? "\ref[tracker]" : "none"] <a href='?src=\ref[src];sync=tracker'>\[Sync\]</a><BR>"

	var/count = 0
	for(var/obj/machinery/power/solar/S in SSsun.solars)
		if(S.control == src)
			++count

	t += "<B>Solar Panels</B>: [count] <a href='?src=\ref[src];sync=solars'>\[Sync\]</a><BR><BR>"
	t += "<BR><HR><BR><BR>"
	t += "Tracking: "

	if(track_mode == TRACK_OFF)
		t += "<B>Off</B> "
	else
		t += "<A href='?src=\ref[src];track_mode=[TRACK_OFF]'>Off</A> "
	if(track_mode == TRACK_MANUAL)
		t += "<B>Timed</B> "
	else
		t += "<A href='?src=\ref[src];track_mode=[TRACK_MANUAL]'>Timed</A> "
	if(track_mode == TRACK_AUTO)
		t += "<B>Auto</B><BR>"
	else
		t += "<A href='?src=\ref[src];track_mode=[TRACK_AUTO]'>Auto</A><BR>"

	t += "Tracking Rate: [rate_control(src,"degrees_per_minute","[degrees_per_minute] deg/m ([degrees_per_minute<0 ? "(CCW)" : "(CW)"])",5,30,180)]<BR><BR>"
	t += "<A href='?src=\ref[src];close=1'>Close</A></TT>"
	user << browse(t, "window=solcon")
	onclose(user, "solcon")
	return


/obj/machinery/power/solar_control/Topic(href, href_list)
	if(..())
		usr << browse(null, "window=solcon")
		usr.unset_machine()
		return
	if(href_list["close"] )
		usr << browse(null, "window=solcon")
		usr.unset_machine()
		return

	switch(href_list["sync"])
		if("tracker")
			var/list/trackers = list()
			if(powernet)
				for(var/obj/machinery/power/tracker/T in powernet.nodes)
					if(get_dist(T, src) < SOLAR_MAX_DIST)
						trackers += T
			if(!trackers.len)
				trackers += "<None Found>"
			tracker = input(usr, "Please select a tracker to sync with:","System update",null) as null|anything in trackers
			if(!istype(tracker))
				tracker = null

		if("solars")
			if(powernet)
				for(var/obj/machinery/power/solar/S in powernet.nodes)
					if(get_dist(S, src) < SOLAR_MAX_DIST)
						S.control = src

		else
			if(href_list["rate control"])
				if(href_list["angle"])
					angle = angle + text2num(href_list["angle"]) % 360
					if(angle < 0)
						angle += 360
				if(href_list["degrees_per_minute"])
					degrees_per_minute = Clamp(round(degrees_per_minute+text2num(href_list["degrees_per_minute"]),1), -90, 90)

			if(href_list["track_mode"])
				track_mode = sanitize_integer(text2num(href_list["track_mode"]), TRACK_OFF, TRACK_AUTO, track_mode)

	update_icon()
	src.updateUsrDialog()
	return


/obj/machinery/power/solar_control/power_change()
	if(powered())
		stat &= ~NOPOWER
		update_icon()
	else
		stat |= NOPOWER
		update_icon()


/obj/machinery/power/solar_control/proc/broken()
	stat |= BROKEN
	update_icon()


/obj/machinery/power/solar_control/meteorhit()
	broken()
	return


/obj/machinery/power/solar_control/ex_act(severity)
	switch(severity)
		if(1.0)
			//SN src = null
			del(src)
			return
		if(2.0)
			if (prob(50))
				broken()
		if(3.0)
			if (prob(25))
				broken()
	return


/obj/machinery/power/solar_control/blob_act()
	if (prob(75))
		broken()
		src.density = 0


//
// MISC
//

/obj/item/weapon/paper/solar
	name = "paper- 'Going green! Setup your own solar array instructions.'"
	info = "<h1>Welcome</h1><p>At greencorps we love the environment, and space. With this package you are able to help mother nature and produce energy without any usage of fossil fuel or plasma! Singularity energy is dangerous while solar energy is safe, which is why it's better. Now here is how you setup your own solar array.</p><p>You can make a solar panel by wrenching the solar assembly onto a cable node. Adding a glass panel, reinforced or regular glass will do, will finish the construction of your solar panel. It is that easy!.</p><p>Now after setting up 19 more of these solar panels you will want to create a solar tracker to keep track of our mother nature's gift, the sun. These are the same steps as before except you insert the tracker equipment circuit into the assembly before performing the final step of adding the glass. You now have a tracker! Now the last step is to add a computer to calculate the sun's movements and to send commands to the solar panels to change direction with the sun. Setting up the solar computer is the same as setting up any computer, so you should have no trouble in doing that. You do need to put a wire node under the computer, and the wire needs to be connected to the tracker.</p><p>Congratulations, you should have a working solar array. If you are having trouble, here are some tips. Make sure all solar equipment are on a cable node, even the computer. You can always deconstruct your creations if you make a mistake.</p><p>That's all to it, be safe, be green!</p>"


#undef TRACK_OFF
#undef TRACK_MANUAL
#undef TRACK_AUTO