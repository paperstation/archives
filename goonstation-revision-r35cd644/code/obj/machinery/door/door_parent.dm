/obj/machinery/door
	name = "door"
	icon_state = "door1"
	opacity = 1
	density = 1
	var/secondsElectrified = 0
	var/visible = 1
	var/p_open = 0
	var/operating = 0
	var/operation_time = 10
	anchored = 1
	var/autoclose = 0
	var/last_used = 0
	var/cant_emag = 0
	var/hardened = 0 // Can't be hacked, RCD'd or controlled by silicon mobs.
	var/locked = 0
	//var/req_only_one_required = 0
	var/next_deny = 0
	var/icon_base = "door"
	var/brainloss_stumble = 0 // Can a mob stumble into this door if they have enough brain damage? Won't work if you override Bumped() or attackby() and don't check for it separately.
	var/brainloss_nospam = 1 // In relation to world time.

/obj/machinery/door/Bumped(atom/AM)
	if (src.p_open || src.operating) return
	if (src.isblocked()) return

	if (ismob(AM))
		if (src.density && src.brainloss_stumble && src.do_brainstumble(AM) == 1)
			return
		else
			var/mob/M = AM
			if (!M.handcuffed)
				src.bumpopen(M)

	else if (istype(AM, /obj/vehicle))
		var/obj/vehicle/V = AM
		var/mob/M2 = V.rider
		if (!M2 || !ismob(M2))
			return
		if (!M2.handcuffed)
			src.bumpopen(M2)

	else if (istype(AM, /obj/machinery/bot))
		var/obj/machinery/bot/B = AM
		if (src.check_access(B.botcard))
			if (src.density)
				src.open()

	else if (istype(AM, /obj/critter/))
		var/obj/critter/C = AM
		if (C.opensdoors == 1)
			if (src.density)
				src.open()
				C.frustration = 0
		else
			C.frustration++

	return

// Simple proc to avoid some duplicate code (Convair880).
/obj/machinery/door/proc/do_brainstumble(var/mob/user)
	if (!src || !user || !ismob(user))
		return 0

	if (ishuman(user))
		var/mob/living/carbon/human/C = user
		if (C.brainloss >= 60)
			// No text spam, please. Bumped() is called more than once by some doors, though.
			// If we just return 0, they will be able to bump-open the door and get past regardless
			// because mob paralysis doesn't take effect until the next tick.
			if (src.brainloss_nospam && world.time < src.brainloss_nospam + 10)
				return 1

			if (prob(40))
				playsound(src.loc, "sound/effects/metal_bang.ogg", 50, 1)
				src.visible_message("<span style=\"color:red\"><b>[C]</b> stumbles into [src] head-first. [pick("Ouch", "Damn", "Woops")]!</span>")
				if (!istype(C.head, /obj/item/clothing/head/helmet))
					var/obj/item/affecting = C.organs["head"]
					if (affecting)
						affecting.take_damage(10, 0)
						C.UpdateDamage()
						C.UpdateDamageIcon()
					C.stunned = 8
					C.weakened = 5
				else
					boutput(C, "<span style=\"color:blue\">Your helmet protected you from injury!</span>")

				src.brainloss_nospam = world.time
				return 1
	return 0

/obj/machinery/door/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	//if(air_group) return 0
	if(istype(mover, /obj/projectile))
		var/obj/projectile/P = mover
		if(P.proj_data.window_pass)
			return !opacity
	return !density

/obj/machinery/door/proc/update_nearby_tiles(need_rebuild)
	var/turf/simulated/source = loc
	if (istype(source))
		return source.update_nearby_tiles(need_rebuild)

	return 1

//cannot be opened by bots.
/obj/machinery/door/proc/isblocked()
	if (src.density && src.operating == -1)
		return 1
	return 0

/obj/machinery/door
	New()
		..()
		UnsubscribeProcess()
		mechanics = new(src)
		mechanics.master = src
		mechanics.addInput("toggle", "toggleinput")
		update_nearby_tiles(need_rebuild=1)
		for (var/turf/simulated/wall/supernorn/T in orange(1))
			T.update_icon()

	disposing()
		update_nearby_tiles()

		..()

	proc/toggleinput()
		if(src.req_access && !(src.operating == -1))
			play_animation("deny")
			return
		if(density)
			open()
		else
			close()
		return


/obj/machinery/door/meteorhit(obj/M as obj)
	if (src.z == 2)
		return
	qdel(src)
	return

/obj/machinery/door/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/door/attack_hand(mob/user as mob)
	return src.attackby(null, user)

/obj/machinery/door/proc/tear_apart(mob/user as mob)
	if (!src.density)
		return src.attackby(null, user)

	if (istype(src, /obj/machinery/door/airlock) || istype(src, /obj/machinery/door/window))
		if (src.allowed(user, req_only_one_required)) // Don't override ID cards.
			return src.attackby(null, user)

	src.visible_message("<span style=\"color:red\">[user] is attempting to pry open [src].</span>")
	user.show_text("You have to stand still...", "red")

	if (do_after(user, 100) && !(user.stunned > 0 || user.weakened > 0 || user.paralysis > 0 || user.stat != 0 || user.restrained()))
		var/success = 0
		spawn (6)
			if (src)
				if (istype(src, /obj/machinery/door/poddoor))
					boutput(user, "<span style=\"color:red\">The door is too strong for you!</span>")

				if (istype(src, /obj/machinery/door/unpowered/wood))
					var/obj/machinery/door/unpowered/wood/WD = src
					if (WD.locked)
						boutput(user, "<span style=\"color:red\">It's shut tight!</span>")
					else
						WD.open()
						success = 1

				if (istype(src, /obj/machinery/door/firedoor))
					var/obj/machinery/door/firedoor/FD = src
					if (FD.blocked)
						boutput(user, "<span style=\"color:red\">It's shut tight!</span>")
					else
						FD.open()
						success = 1

				if (istype(src, /obj/machinery/door/window))
					var/obj/machinery/door/window/SD = src
					if (SD.cant_emag != 0 || SD.isblocked() != 0)
						boutput(user, "<span style=\"color:red\">It's shut tight!</span>")
					else
						SD.open(1)
						success = 1

				if (istype(src, /obj/machinery/door/airlock))
					var/obj/machinery/door/airlock/AL = src
					if (AL.locked || AL.operating == -1 || AL.welded || AL.cant_emag != 0)
						boutput(user, "<span style=\"color:red\">It's shut tight!</span>")
					else
						if (!AL.arePowerSystemsOn() || (AL.stat & NOPOWER))
							AL.unpowered_open_close()
						else
							AL.open()
						success = 1

			if (success != 0)
				src.operating = -1 // It's broken now.
				src.visible_message("<span style=\"color:red\">[user] pries open [src]!</span>")
	else
		user.show_text("You were interrupted.", "red")

	return

/obj/machinery/door/proc/requiresID()
	return 1

/obj/machinery/door/emag_act(var/mob/user, var/obj/item/card/emag/E)
	if (src.density && cant_emag <= 0)
		last_used = world.time
		src.operating = -1
		flick(text("[]_spark", src.icon_base), src)
		sleep(6)
		open()
		return 1
	return 0

/obj/machinery/door/demag(var/mob/user)
	if (src.operating != -1)
		return 0
	src.operating = 0
	sleep(6)
	close()
	return 1

/obj/machinery/door/attackby(obj/item/I as obj, mob/user as mob)
	if (user.stunned || user.weakened || user.stat || user.restrained())
		return
	if (src.isblocked() == 1)
		return
	if (src.operating)
		return
	if (world.time - src.last_used <= 10)
		return

	src.add_fingerprint(user)

	if (src.density && src.brainloss_stumble && src.do_brainstumble(user) == 1)
		return

	if (!src.requiresID())
		if (src.density)
			src.last_used = world.time
			src.open()
		else
			src.last_used = world.time
			src.close()
		return

	if (src.allowed(user, req_only_one_required))
		if (src.density)
			src.last_used = world.time
			src.open()
		else
			src.last_used = world.time
			src.close()
	else if (src.density && world.time >= src.next_deny)
		play_animation("deny")
		src.next_deny = world.time + 10 // stop the sound from spamming, if there is one

	//grabsmash
	if (istype(I, /obj/item/grab/))
		var/obj/item/grab/G = I

		if (ismob(G.affecting) && src.allowed(G.affecting, req_only_one_required) && src.density)
			src.last_used = world.time
			src.open()

		if  (!grab_smash(G, user))
			return ..(I, user)
		else return

	return

/obj/machinery/door/proc/bumpopen(mob/user as mob)
	if (src.operating)
		return 0
	if(world.time-last_used <= 10)
		return 0
	src.add_fingerprint(user)
	if (!src.requiresID())
		user = null

	if (src.allowed(user, req_only_one_required))
		if (src.density)
			last_used = world.time
			if (src.open() == 1)
				return 1
			else
				return 0
	else if (src.density && world.time > src.next_deny)
		play_animation("deny")
		src.next_deny = world.time + 10
		return 0

/obj/machinery/door/blob_act(var/power)
	if(prob(power))
		qdel(src)

/obj/machinery/door/ex_act(severity)
	if (src.z == 2)
		return
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if(prob(25))
				qdel(src)
		if(3.0)
			if(prob(80))
				var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
				s.set_up(2, 1, src)
				s.start()

/obj/machinery/door/proc/update_icon()
	if(density)
		icon_state = "[icon_base]1"
	else
		icon_state = "[icon_base]0"
	return

/obj/machinery/door/proc/play_animation(animation)
	switch(animation)
		if("opening")
			if(p_open)
				flick("o_[icon_base]c0", src)
			else
				flick("[icon_base]c0", src)
			icon_state = "[icon_base]0"
		if("closing")
			if(p_open)
				flick("o_[icon_base]c1", src)
			else
				flick("[icon_base]c1", src)
			icon_state = "[icon_base]1"
		if("deny")
			flick("[icon_base]_deny", src)
	return

/obj/machinery/door/proc/open()
	if(!density)
		return 1
	if (src.operating == 1) //doors can still open when emag-disabled
		return
	if (!ticker)
		return 0
	if(!src.operating) //in case of emag
		src.operating = 1

	spawn()
		play_animation("opening")
		src.RL_SetOpacity(0)
		sleep(src.operation_time / 2)
		src.density = 0
		update_nearby_tiles()
		sleep(src.operation_time / 2)
		update_icon()
		if(mechanics) mechanics.fireOutgoing(mechanics.newSignal("doorOpened"))

		if(operating == 1) //emag again
			src.operating = 0
		opened()

	return 1

/obj/machinery/door/proc/close()
	if(density)
		return 1
	if (src.operating)
		return
	src.operating = 1

	spawn()
		play_animation("closing")
		src.density = 1
		update_nearby_tiles()
		sleep(src.operation_time)
		update_icon()
		if (src.visible)
			src.RL_SetOpacity(1)

		closed()

		if(operating == 1)
			operating = 0

/obj/machinery/door/proc/opened()
	if(autoclose)
		sleep(150)
		autoclose()

/obj/machinery/door/proc/closed()
	if(mechanics)
		mechanics.fireOutgoing(mechanics.newSignal("doorClosed"))

/obj/machinery/door/proc/autoclose()
	if (!density && !operating && !locked)
		close()
	else return

/obj/machinery/door/proc/checkForMultipleDoors()
	if(!src.loc)
		return 0
	for(var/obj/machinery/door/D in src.loc)
		if(!istype(D, /obj/machinery/door/window) && D.density)
			return 0
	return 1

/turf/simulated/wall/proc/checkForMultipleDoors()
	if(!src.loc)
		return 0
	for(var/obj/machinery/door/D in locate(src.x,src.y,src.z))
		if(!istype(D, /obj/machinery/door/window) && D.density)
			return 0
	//There are no false wall checks because that would be fucking retarded
	return 1

/obj/machinery/door/suicide(var/mob/usr as mob)
	if (!src.allowed(usr, req_only_one_required) || src.density || !ishuman(usr))
		return 0
	var/mob/living/carbon/human/H = usr
	if (!H.organHolder)
		return 0
	H.visible_message("<span style=\"color:red\"><b>[H] sticks \his head into the [src.name] door and closes it!</b></span>")
	src.close()
	var/obj/head = H.organHolder.drop_organ("head")
	qdel(head)
	new /obj/decal/cleanable/blood/gibs(src.loc)
	playsound(src.loc, "sound/effects/gib.ogg", 50, 1)
	H.updatehealth()
	spawn(100)
		if(H)
			H.suiciding = 0
	return 1

/////////////////////////////////////////////////// Unpowered doors

/obj/machinery/door/unpowered
	autoclose = 0
	cant_emag = 1

/obj/machinery/door/unpowered/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/door/unpowered/attack_hand(mob/user as mob)
	return src.attackby(null, user)

/obj/machinery/door/unpowered/attackby(obj/item/I as obj, mob/user as mob)
	if (src.operating)
		return
	src.add_fingerprint(user)
	if (src.allowed(user, req_only_one_required))
		if (src.density)
			open()
		else
			close()
	return

/obj/machinery/door/unpowered/shuttle
	icon = 'icons/turf/shuttle.dmi'
	name = "door"
	icon_state = "door1"
	opacity = 1
	density = 1

/obj/machinery/door/unpowered/martian
	icon = 'icons/turf/martian.dmi'
	name = "Orifice"
	icon_state = "door1"
	opacity = 1
	density = 1
	var/id = null

/obj/machinery/door/unpowered/martian/open()
	if(src.locked) return
	playsound(src.loc, "sound/effects/splat.ogg", 50, 1)
	. = ..()

/obj/machinery/door/unpowered/martian/close()
	playsound(src.loc, "sound/effects/splat.ogg", 50, 1)
	. = ..()

// APRIL FOOLS
/obj/machinery/door/unpowered/wood
	name = "door"
	icon = 'icons/obj/doors/door_wood.dmi'
	icon_state = "door1"
	opacity = 1
	density = 1
	p_open = 0
	operating = 0
	anchored = 1
	autoclose = 1
	var/blocked = null

/obj/machinery/door/unpowered/wood/pyro
	icon = 'icons/obj/doors/SL_doors.dmi'
	icon_state = "wood1"
	icon_base = "wood"

/obj/machinery/door/unpowered/wood/isblocked()
	if (src.density && (src.operating == -1 || src.locked))
		return 1
	return 0

/obj/machinery/door/unpowered/wood/attackby(obj/item/I as obj, mob/user as mob)
	if (src.operating)
		return
	src.add_fingerprint(user)
	if (!src.requiresID())
		//don't care who they are or what they have, act as if they're NOTHING
		user = null
	if(istype(I, /obj/item/device/key) && src.density)
		src.locked = !src.locked
		src.visible_message("<span style=\"color:blue\"><B>[user] [src.locked ? "locks" : "unlocks"] the door.</B></span>")
		return
	if (user.bioHolder.HasEffect("hulk"))
		src.visible_message("<span style=\"color:red\"><B>[user] smashes through the door!</B></span>")
		playsound(src.loc, "sound/misc/meteorimpact.ogg", 50, 1)
		src.operating = -1
		src.locked = 0
		open()
		return 1
	if (!src.locked)
		if (src.density)
			open()
		else
			close()
	else if (src.density)
		play_animation("deny")
		playsound(src.loc, "sound/machines/door_locked.ogg", 50, 1, -2)
		boutput(user, "<span style=\"color:red\">The door is locked!</span>")
	return

/obj/machinery/door/unpowered/wood/open()
	if(src.locked) return
	playsound(src.loc, "sound/machines/door_open.ogg", 50, 1)
	. = ..()

/obj/machinery/door/unpowered/wood/close()
	playsound(src.loc, "sound/machines/door_close.ogg", 50, 1)
	. = ..()

/obj/machinery/door/unpowered/bulkhead
	name = "bulkhead door"
	desc = "A heavy manually operated door. It looks rather beaten."
	icon = 'icons/obj/doors/bulkhead.dmi'
	operation_time = 20

/obj/machinery/door/unpowered/bulkhead/Bumped()
	return

/obj/machinery/door/control/oneshot
	var/broken = 0