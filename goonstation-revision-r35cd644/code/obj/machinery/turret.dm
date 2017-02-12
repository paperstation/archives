/obj/machinery/turret
	name = "turret"
	icon = 'icons/obj/turrets.dmi'
	icon_state = "grey_target_prism"
	var/raised = 0
	var/enabled = 1
	anchored = 1
	layer = OBJ_LAYER
	invisibility = 2
	density = 1
	var/lasers = 0
	var/health = 100
	var/obj/machinery/turretcover/cover = null
	var/popping = 0
	var/wasvalid = 0
	var/lastfired = 0
	var/shot_delay = 15 //1.5 seconds between shots (previously 3, way too much to be useful)
	var/shot_type = 0
	var/override_area_bullshit = 0
	var/datum/projectile/lethal = new/datum/projectile/laser/heavy
	var/datum/projectile/stun = new/datum/projectile/energy_bolt/robust
	var/list/mob/target_list = null

/obj/machinery/turretcover
	name = "pop-up turret cover"
	icon = 'icons/obj/turrets.dmi'
	icon_state = "turretCover"
	anchored = 1
	layer = OBJ_LAYER+0.5
	density = 0

/obj/machinery/turret/New()
	..()
	var/area/station/turret_protected/TP = get_area(src)
	if(istype(TP))
		TP.turret_list += src

/obj/machinery/turret/disposing()
	var/area/station/turret_protected/TP = get_area(src)
	if(istype(TP))
		TP.turret_list -= src
	..()

/obj/machinery/turret/proc/isPopping()
	return (popping!=0)

/obj/machinery/turret/power_change()
	if(stat & BROKEN)
		icon_state = "grey_target_prism"
	else
		if( powered() )
			if (src.enabled)
				if (src.lasers)
					icon_state = "orange_target_prism"
				else
					icon_state = "target_prism"
			else
				icon_state = "grey_target_prism"
			stat &= ~NOPOWER
		else
			spawn(rand(0, 15))
				src.icon_state = "grey_target_prism"
				stat |= NOPOWER

/obj/machinery/turret/proc/setState(var/enabled, var/lethal)
	src.enabled = enabled
	src.lasers = lethal
	src.power_change()

/obj/machinery/turret/process()
	if(stat & BROKEN)
		return
	..()
	if(stat & NOPOWER)
		return
	if(override_area_bullshit)
		return
	if(lastfired && world.time - lastfired < shot_delay)
		return

	if (src.cover==null)
		src.cover = new /obj/machinery/turretcover(src.loc)
	use_power(50)
	var/area/area = get_area(loc)
	if (istype(area))
		if(!target_list)
			target_list = get_target_list()	//Calculate a new batch of targets
			if(istype(area, /area/station/turret_protected)) //It'd be faster to just throw our turret buds our target list.
				var/area/station/turret_protected/TP = area
				for(var/obj/machinery/turret/T in TP.turret_list) //Sharing is caring - give it to our turret friends so they don't have to work out a target list
					T.target_list = src.target_list


		if (target_list && target_list.len)
			if (!isPopping())
				if (isDown())
					popUp()
				else
					var/mob/target = pick(target_list)
					src.dir = get_dir(src, target)
					lastfired = world.time //Setting this here to prevent immediate firing when enabled
					if (src.enabled)
						if (istype(target, /mob/living))
							if (target.stat!=2)
								src.shootAt(target)
		else if(!isDown() && !isPopping())
			popDown()

		target_list = null //Get ready for a new batch of targets during the next cycle

/obj/machinery/turret/proc/get_target_list()
	var/area/A = get_area(src)
	.= list()
	for(var/mob/living/C in A)
		if (!iscarbon(C) && !iscritter(C))
			continue
		if (C.stat == 2)
			continue
		. += C

/obj/machinery/turret/proc/isDown()
	return (invisibility!=0)

/obj/machinery/turret/proc/popUp()
	if (!isDown()) return
	if ((!isPopping()) || src.popping==-1)
		invisibility = 0
		popping = 1
		if (src.cover!=null)
			flick("popup", src.cover)
			src.cover.icon_state = "openTurretCover"
		spawn(10)
			if (popping==1) popping = 0

/obj/machinery/turret/proc/popDown()
	if (isDown()) return
	if ((!isPopping()) || src.popping==1)
		popping = -1
		if (src.cover!=null)
			flick("popdown", src.cover)
			src.cover.icon_state = "turretCover"
		spawn(13)
			if (popping==-1)
				invisibility = 2
				popping = 0

/obj/machinery/turret/proc/shootAt(var/mob/target)
	var/turf/T = loc
	var/atom/U = (istype(target, /atom/movable) ? target.loc : target)
	if ((!( U ) || !( T )))
		return
	while(!( istype(U, /turf) ))
		U = U.loc
	if (!( istype(T, /turf) ))
		return

	if(shot_type == 1)
		return
	else

		if (src.lasers)
			use_power(200)
			shoot_projectile_ST(src, lethal, U)
		else
			use_power(100)
			shoot_projectile_ST(src, stun, U)


	return

/obj/machinery/turret/bullet_act(var/obj/projectile/P)
	var/damage = 0
	damage = round((P.power*P.proj_data.ks_ratio), 1.0)

	if(src.material) src.material.triggerOnAttacked(src, P.shooter, src, (ismob(P.shooter) ? P.shooter:equipped() : P.shooter))
	for(var/atom/A in src)
		if(A.material)
			A.material.triggerOnAttacked(A, P.shooter, src, (ismob(P.shooter) ? P.shooter:equipped() : P.shooter))

	if(P.proj_data.damage_type == D_KINETIC)
		src.health -= damage
	else if(P.proj_data.damage_type == D_PIERCING)
		src.health -= (damage*2)
	else if(P.proj_data.damage_type == D_ENERGY)
		src.health -= damage / 2

	if (src.health <= 0)
		src.die()
	return


/obj/machinery/turret/ex_act(severity)
	if(severity < 3)
		src.die()

/obj/machinery/turret/emp_act()
	..()
	src.enabled = 0
	src.lasers = 0
	src.power_change()
	return

/obj/machinery/turret/proc/die()
	src.health = 0
	src.density = 0
	src.stat |= BROKEN
	src.icon_state = "destroyed_target_prism"
	if (cover!=null)
		qdel(cover)
	sleep(3)
	flick("explosion", src)
	spawn(13)
		qdel(src)

/*
 *	Network turret, a turret controlled over the wire network instead of a turretid
 */

/obj/machinery/turret/network
	var/net_id = null
	var/obj/machinery/power/data_terminal/link = null

	New()
		..()
		spawn(6)
			src.net_id = generate_net_id(src)
			if(!src.link)
				var/turf/T = get_turf(src)
				var/obj/machinery/power/data_terminal/test_link = locate() in T
				if(test_link && !test_link.is_valid_master(test_link.master))
					src.link = test_link
					src.link.master = src

		return

	receive_signal(datum/signal/signal)
		if(stat & NOPOWER)
			return

		if(!signal || signal.encryption || !signal.data["sender"])
			return

		if(signal.transmission_method != TRANSMISSION_WIRE)
			return

		var/sender = signal.data["sender"]
		if((signal.data["address_1"] == "ping") && sender)
			spawn(5)
				src.post_status(sender, "command", "ping_reply", "device", "PNET_SEC_TURRT", "netid", src.net_id)
			return

		if(signal.data["address_1"] == src.net_id && signal.data["acc_code"] == netpass_security)
			var/command = lowertext(signal.data["command"])
			switch(command)
				if("status")
					var/status_string = "on=[!(stat & NOPOWER)]&health=[src.health]&lethal=[src.lasers]&active=[src.enabled]"
					spawn(3)
						src.post_status(sender, "command", "device_reply", status_string)
				if("setmode")
					var/list/L = params2list(signal.data["data"])
					if(!L || !L.len) return
					var/new_lethal_state = text2num(L["lethal"])
					var/new_enabled_state = text2num(L["active"])
					if(!isnull(new_lethal_state))
						if(new_lethal_state)
							src.lasers = 1
						else
							src.lasers = 0
					if(!isnull(new_enabled_state))
						if(new_enabled_state)
							src.enabled = 1
						else
							src.enabled = 0

			return
		return

	proc/post_status(var/target_id, var/key, var/value, var/key2, var/value2, var/key3, var/value3)
		if(!src.link || !target_id)
			return

		var/datum/signal/signal = get_free_signal()
		signal.source = src
		signal.transmission_method = TRANSMISSION_WIRE
		signal.data[key] = value
		if(key2)
			signal.data[key2] = value2
		if(key3)
			signal.data[key3] = value3

		signal.data["address_1"] = target_id
		signal.data["sender"] = src.net_id

		src.link.post_signal(src, signal)

/obj/machinery/turretid
	name = "Turret deactivation control"
	icon = 'icons/obj/device.dmi'
	icon_state = "motion3"
	anchored = 1
	density = 0
	var/enabled = 1
	var/lethal = 0
	var/locked = 1
	var/emagged = 0
	var/turretsExist = 1

	req_access = list(access_ai_upload)

/obj/machinery/turretid/attackby(obj/item/W, mob/user)
	if(stat & BROKEN) return
	if (istype(user, /mob/living/silicon))
		return src.attack_hand(user)
	else // trying to unlock the interface
		if (src.allowed(usr, req_only_one_required))
			locked = !locked
			boutput(user, "You [ locked ? "lock" : "unlock"] the panel.")
			if (locked)
				if (user.machine==src)
					user.machine = null
					user << browse(null, "window=turretid")
			else
				if (user.machine==src)
					src.attack_hand(usr)
		else
			boutput(user, "<span style=\"color:red\">Access denied.</span>")

/obj/machinery/turretid/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/turretid/attack_hand(mob/user as mob)
	if (user.stunned || user.weakened || user.stat)
		return

	if ( (get_dist(src, user) > 1 ))
		if (!istype(user, /mob/living/silicon))
			boutput(user, text("Too far away."))
			user.machine = null
			user << browse(null, "window=turretid")
			return

	user.machine = src
	var/loc = src.loc
	if (istype(loc, /turf))
		loc = loc:loc
	if (!istype(loc, /area))
		boutput(user, text("Turret badly positioned - loc.loc is [].", loc))
		return
	var/area/area = loc
	var/t = "<TT><B>Turret Control Panel</B> ([area.name])<HR>"

	if(!src.emagged && turretsExist)
		if(src.locked && (!istype(user, /mob/living/silicon)))
			t += "<I>(Swipe ID card to unlock control panel.)</I><BR>"
		else
			t += text("Turrets [] - <A href='?src=\ref[];toggleOn=1'>[]?</a><br><br>", src.enabled?"activated":"deactivated", src, src.enabled?"Disable":"Enable")
			t += text("Currently set for [] - <A href='?src=\ref[];toggleLethal=1'>Change to []?</a><br><br>", src.lethal?"lethal":"stun repeatedly", src,  src.lethal?"Stun repeatedly":"Lethal")
	else if(src.emagged)
		var/o = ""
		for(var/i=rand(4,50), i > 0, i--)
			o += "kill[prob(50)?" ":null]"


		for(var/i=1, i <= length(o), i++)
			var/mod = rand(-5, 5)
			t += text("<font size=[][]>[]</font>",mod>=0?"+":"-" ,mod , copytext(o, i, i+1))
		t = "<B><font color=#FF0000>[t]</font></B>"
		t += "<br><br>"


	else
		t += "!ALERT! Unable to connect to a turret!<br><br>"

	user << browse(t, "window=turretid")
	onclose(user, "turretid")

/obj/machinery/turretid/Topic(href, href_list)
	..()
	if (!isliving(usr) || usr.stunned || usr.weakened || usr.stat)
		return
	if (src.locked)
		if (!issilicon(usr))
			boutput(usr, "Control panel is locked!")
			return

	if (!issilicon(usr) && get_dist(usr, src) > 1)
		return

	if (href_list["toggleOn"])
		src.enabled = !src.enabled
		logTheThing("combat", usr, null, "turned [enabled ? "ON" : "OFF"] turrets from control \[[showCoords(src.x, src.y, src.z)]].")
		src.updateTurrets()
	else if (href_list["toggleLethal"])
		src.lethal = !src.lethal
		if(src.lethal)
			logTheThing("combat", usr, null, "set turrets to LETHAL from control \[[showCoords(src.x, src.y, src.z)]].")
			message_admins("[key_name(usr)] set turrets to LETHAL from control \[[showCoords(src.x, src.y, src.z)]].")
		else
			logTheThing("combat", usr, null, "set turrets to STUN from control \[[showCoords(src.x, src.y, src.z)]].")
			message_admins("[key_name(usr)] set turrets to STUN from control \[[showCoords(src.x, src.y, src.z)]].")
		src.updateTurrets()
	src.attack_hand(usr)

/obj/machinery/turretid/proc/updateTurrets()
	if(turretsExist) //Let's not waste a lot of time here.
		if (src.enabled)
			if (src.lethal)
				icon_state = "motion1"
			else
				icon_state = "motion3"
		else
			icon_state = "motion0"

		var/loc = src.loc
		if (istype(loc, /turf))
			loc = loc:loc
		if (!istype(loc, /area))
			boutput(world, text("Turret badly positioned - loc.loc is [loc]."))
			return
		var/area/area = loc
		turretsExist = 0
		for (var/obj/machinery/turret/aTurret in get_area_all_atoms(area))
			aTurret.setState(enabled, lethal)
			turretsExist = 1

/obj/machinery/turretid/emag_act(var/mob/user)
	if(!emagged)
		if(user)
			user.show_text("You short out the control circuit on [src]!", "blue")
			logTheThing("combat", user, null, "emagged the turret control in [loc.name] \[[showCoords(src.x, src.y, src.z)]]")
			logTheThing("admin", user, null, "emagged the turret control in [loc.name] \[[showCoords(src.x, src.y, src.z)]]")
		emagged = 1
		enabled = 0
		updateTurrets()
		spawn(100 + (rand(0,20)*10))
			process_emag()

		return 1

	else
		if(user) user.show_text("This thing is already fried!", "red")
		return 0

/obj/machinery/turretid/demag(var/mob/user)
	if (!emagged)
		return 0
	if (user)
		user.show_text("You repair the control circuit on [src]!", "blue")
	emagged = 0
	updateTurrets()
	return 1

/obj/machinery/turretid/proc/process_emag()
	do
		src.enabled = prob(90)
		src.lethal = prob(60)
		updateTurrets()

		sleep(rand(1, 10) * 10)
	while(emagged && turretsExist)