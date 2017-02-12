
/atom/proc/electrocute(mob/user, prb, netnum, var/ignore_gloves)

	if(!prob(prb))
		return 0

	if(!netnum)		// unconnected cable is unpowered
		return 0

	var/datum/powernet/PN
	if(powernets && powernets.len >= netnum)
		PN = powernets[netnum]

	var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
	s.set_up(3, 1, src)
	s.start()

	return user.shock(src, PN.avail, user.hand == 1 ? "l_arm": "r_arm", 1, ignore_gloves ? 1 : 0)

// attach a wire to a power machine - leads from the turf you are standing on

/obj/machinery/power/attackby(obj/item/W, mob/user)

	if(istype(W, /obj/item/cable_coil))

		var/obj/item/cable_coil/coil = W

		var/turf/T = user.loc

		if(T.intact || !istype(T, /turf/simulated/floor))
			return

		if(get_dist(src, user) > 1)
			return

		if(!directwired)		// only for attaching to directwired machines
			return

		var/dirn = get_dir(user, src)


		for(var/obj/cable/LC in T)
			if(LC.d1 == dirn || LC.d2 == dirn)
				boutput(user, "There's already a cable at that position.")
				return

		var/obj/cable/NC = new(T, coil)
		NC.d1 = 0
		NC.d2 = dirn
		NC.add_fingerprint()
		NC.updateicon()
		NC.update_network()
		coil.use(1)
		return
	else
		..()
	return


// the power cable object
/obj/cable
	level = 1
	anchored =1
	var/netnum = 0
	name = "power cable"
	desc = "A flexible power cable."
	icon = 'icons/obj/power_cond.dmi'
	icon_state = "0-1"
	var/d1 = 0
	var/d2 = 1
	var/image/cableimg = null
	layer = CABLE_LAYER
	color = "#DD0000"

	var/datum/material/insulator = null
	var/datum/material/conductor = null

	conduit
		name = "power conduit"
		desc = "A rigid assembly of superconducting power lines."
		icon_state = "conduit"


/obj/cable/New(var/newloc, var/obj/item/cable_coil/source)
	..()


	// ensure d1 & d2 reflect the icon_state for entering and exiting cable

	var/dash = findtext(icon_state, "-")

	d1 = text2num( copytext( icon_state, 1, dash ) )

	d2 = text2num( copytext( icon_state, dash+1 ) )

	var/turf/T = src.loc			// hide if turf is not intact
									// but show if in space
	if(istype(T, /turf/space)) hide(0)
	else if(level==1) hide(T.intact)

	cableimg = image(src.icon, src.loc, src.icon_state)
	cableimg.layer = OBJ_LAYER

	if (istype(source))
		applyCableMaterials(src, source.insulator, source.conductor)
	else
		applyCableMaterials(src, getCachedMaterial("synthrubber"), getCachedMaterial("steel"))

	allcables += src

/obj/cable/disposing()		// called when a cable is deleted

	if(!defer_powernet_rebuild)	// set if network will be rebuilt manually

		if(netnum && powernets && powernets.len >= netnum)		// make sure cable & powernet data is valid
			var/datum/powernet/PN = powernets[netnum]
			PN.cut_cable(src)									// updated the powernets
	else
		if(Debug) diary << "Defered cable deletion at [x],[y]: #[netnum]"
		defer_powernet_rebuild = 2

	allcables -= src

	..()													// then go ahead and delete the cable

/obj/cable/hide(var/i)

	if(level == 1)// && istype(loc, /turf/simulated))
		invisibility = i ? 101 : 0
	updateicon()

/obj/cable/proc/updateicon()
	if(invisibility)
		icon_state = "[d1]-[d2]-f"
	else
		icon_state = "[d1]-[d2]"
	if (cableimg) cableimg.icon_state = icon_state

// returns the powernet this cable belongs to
/obj/cable/proc/get_powernet()
	var/datum/powernet/PN			// find the powernet
	if(netnum && powernets && powernets.len >= netnum)
		PN = powernets[netnum]
	return PN

/obj/cable/attackby(obj/item/W, mob/user)

	var/turf/T = src.loc
	if(T.intact)
		return

	if(istype(W, /obj/item/wirecutters))

		if(src.d1)	// 0-X cables are 1 unit, X-X cables are 2 units long
			var/atom/A = new/obj/item/cable_coil(T, 2)
			applyCableMaterials(A, src.insulator, src.conductor)
		else
			var/atom/A = new/obj/item/cable_coil(T, 1)
			applyCableMaterials(A, src.insulator, src.conductor)

		src.visible_message("<span style=\"color:red\">[user] cuts the cable.</span>")
		src.log_wirelaying(user, 1)

		shock(user, 50)

		defer_powernet_rebuild = 0		// to fix no-action bug
		qdel(src)

		return	// not needed, but for clarity


	else if(istype(W, /obj/item/cable_coil))
		var/obj/item/cable_coil/coil = W
		coil.cable_join(src, user)
		//note do shock in cable_join

	else if(istype(W, /obj/item/device/t_scanner) || istype(W,/obj/item/device/multitool) || (istype(W, /obj/item/device/pda2) && istype(W:module, /obj/item/device/pda_module/tray)))

		var/datum/powernet/PN = get_powernet()		// find the powernet

		if(PN && (PN.avail > 0))		// is it powered?
			boutput(user, "<span style=\"color:red\">[PN.avail]W in power network.</span>")

		else
			boutput(user, "<span style=\"color:red\">The cable is not powered.</span>")

		if(prob(40))
			shock(user, 10)

	else
		shock(user, 10)

	src.add_fingerprint(user)

// shock the user with probability prb

/obj/cable/proc/shock(mob/user, prb)
	if(!netnum)		// unconnected cable is unpowered
		return 0

	return src.electrocute(user, prb, netnum)

		//var/shock_damage = 0

// cogwerks - simplifying this stack of ranges below into something that feels better

		//shock_damage = (max(rand(10,20), round(PN.avail * 0.00004)))*prot // adjust the multiplier as needed

/*	if(PN.avail > 700000)	//someone juiced up the grid enough, people going to die!
			shock_damage = min(rand(70,145),rand(70,145))*prot
		else if(PN.avail > 200000)
			shock_damage = min(rand(35,110),rand(35,110))*prot
			playsound(src.loc, "sound/effects/elec_bzzz.ogg", 50, 1)
		else if(PN.avail > 75000)
			shock_damage = min(rand(30,100),rand(30,100))*prot
			playsound(src.loc, "sound/effects/electric_shock.ogg", 50, 1)
		else if(PN.avail > 50000)
			shock_damage = min(rand(25,90),rand(25,90))*prot
			playsound(src.loc, "sound/effects/electric_shock.ogg", 50, 1)
		else if(PN.avail > 25000)
			shock_damage = min(rand(20,80),rand(20,80))*prot
			playsound(src.loc, "sound/effects/electric_shock.ogg", 50, 1)
		else if(PN.avail > 10000)
			shock_damage = min(rand(20,65),rand(20,65))*prot
			playsound(src.loc, "sound/effects/electric_shock.ogg", 50, 1)
		else
			shock_damage = min(rand(20,45),rand(20,45))*prot
			playsound(src.loc, "sound/effects/electric_shock.ogg", 50, 1)*/

//		message_admins("<span style=\"color:blue\"><B>ADMIN: </B>DEBUG: shock_damage = [shock_damage] PN.avail = [PN.avail] user = [user] netnum = [netnum]</span>")

		/*if (user.bioHolder)
			. = user.bioHolder.HasEffect("resist_electric")
			if (. == 2)
				var/healing = 0
				healing = shock_damage / 3
				user.HealDamage("All", healing, healing)
				user.take_toxin_damage(0 - healing)
				boutput(user, "<span style=\"color:blue\">You absorb the electrical shock, healing your body!</span>")
				return 0
			else if (. == 1)
				boutput(user, "<span style=\"color:blue\">You feel electricity course through you harmlessly!</span>")
				return 0

//cogwerks - fun horrible things

		switch(shock_damage)
			if (0 to 25)
				playsound(user.loc, "sound/effects/electric_shock.ogg", 50, 1)
			if (26 to 59)
				playsound(user.loc, "sound/effects/elec_bzzz.ogg", 50, 1)
			if (60 to 99)
				playsound(user.loc, "sound/effects/elec_bigzap.ogg", 50, 1)  // begin the fun arcflash
				boutput(user, "<span style=\"color:red\"><b>[src] discharges a violent arc of electricity!</b></span>")
				flick("e_flash", user.flash)
				user.stunned = 10
				if (istype(user, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = user
					H.cust_one_state = pick("xcom","bart","zapped")
					H.set_face_icon_dirty()
			if (100 to INFINITY)  // cogwerks - here are the big fuckin murderflashes
				playsound(user.loc, "sound/effects/elec_bigzap.ogg", 50, 1)
				playsound(user.loc, "explosion", 50, 1)
				flick("e_flash", user.flash)
				if (istype(user, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = user
					H.cust_one_state = pick("xcom","bart","zapped")
					H.set_face_icon_dirty()

				var/turf/T = get_turf(user) // not src goddamn
				if(T)
					T.hotspot_expose(5000,125)
					explosion(src, T, -1,-1,1,2)
				if (istype(user, /mob/living/carbon/human))
					var/mob/living/carbon/human/M = user
					if(prob(20))
						boutput(M, "<span style=\"color:red\"><b>[src] vaporizes you with a lethal arc of electricity!</b></span>")
						if(M.shoes)
							M.drop_from_slot(M.shoes)
						new /obj/decal/cleanable/ash(M.loc)
						spawn(1)
							M.elecgib()
					else
						boutput(M, "<span style=\"color:red\"><b>[src] blasts you with an arc flash!</b></span>")
						if(M.shoes)
							M.drop_from_slot(M.shoes)
						var/atom/targetTurf = get_edge_target_turf(M, get_dir(src, get_step_away(M, src)))
						M.throw_at(targetTurf, 200, 4)

		// fuck all that deafen/flash mess

		///////////// end arcflash mess
		if(user)
			user.TakeDamage(user.hand == 1 ? "l_arm" : "r_arm", 0, shock_damage)
			user.updatehealth()
			boutput(user, "<span style=\"color:red\"><B>You feel a powerful shock course through your body!</B></span>")
			user.unlock_medal("HIGH VOLTAGE", 1)
			if (istype(user,/mob/living/carbon/))
				var/mob/living/carbon/C = user
				C.Virus_ShockCure(user, 100)
				C.shock_cyberheart(100)
			spawn(1) // cogwerks - changed sleep to spawn
				if(user.stunned < 12)	user.stunned = min((shock_damage/5), 12) //cogwerks: limiter - 40 stun was waaaaay too high
				if(user.weakened < 8)	user.weakened = min((shock_damage/6), 8) // cogwerks: limiter
				for(var/mob/M in AIviewers(src))
					if(M == user)	continue
					M.show_message("<span style=\"color:red\">[user.name] was shocked by the [src.name]!</span>", 3, "<span style=\"color:red\">You hear a heavy electrical crack</span>", 2)
			return 1
	return 0*/


/obj/cable/ex_act(severity)
	switch (severity)
		if (1)
			qdel(src)
		if (2)
			if (prob(15))
				var/atom/A = new/obj/item/cable_coil(src.loc, src.d1 ? 2 : 1)
				applyCableMaterials(A, src.insulator, src.conductor)
			qdel(src)



// called when a new cable is created
// can be 1 of 3 outcomes:
// 1. Isolated cable (or only connects to isolated machine) -> create new powernet
// 2. Joins to end or bridges loop of a single network (may also connect isolated machine) -> add to old network
// 3. Bridges gap between 2 networks -> merge the networks (must rebuild lists also) (currently just calls makepowernets. welp)



/obj/cable/proc/update_network()
	var/turf/T = get_turf(src)
	var/obj/cable/cable_d1 = null //locate() in (d1 ? get_step(src,d1) : orange(0, src) )
	var/obj/cable/cable_d2 = null //locate() in (d2 ? get_step(src,d2) : orange(0, src) )
	var/obj/machinery/power/terminal/PT = null

	// Terminal connections aren't always restored when laying wires...and I can't be bothered
	// to dive into the powernet code to avoid an additional makepowernets() call. Sorry.
	if (T && isturf(T))
		for (var/obj/machinery/power/terminal/t_check in T.contents)
			PT = t_check
			break

	var/flip_d1 = d1 ? turn(d1, 180) : 0
	for (var/obj/cable/new_cable_d1 in (d1 ? get_step(src, d1) : orange(0, src) ))
		if (new_cable_d1.d1 != flip_d1 && new_cable_d1.d2 != flip_d1)
			continue

		cable_d1 = new_cable_d1
		break

	var/flip_d2 = d2 ? turn(d2, 180) : 0
	for (var/obj/cable/new_cable_d2 in (d2 ? get_step(src, d2) : orange(0, src) ))
		if (new_cable_d2.d1 != flip_d2 && new_cable_d2.d2 != flip_d2)
			continue

		cable_d2 = new_cable_d2
		break

	if (cable_d1 && cable_d2)
		if (cable_d1.netnum == cable_d2.netnum)
			var/datum/powernet/PN = powernets[cable_d1.netnum]
			PN.cables += src
			src.netnum = cable_d1.netnum
			if (PT && istype(PT))
				return makepowernets()
			else
				return

		return makepowernets() //ugh :(

	else if (!cable_d1 && !cable_d2)
		var/datum/powernet/PN = new()
		powernets += PN
		PN.number = powernets.len
		src.netnum = powernets.len
		if (PT && istype(PT))
			return makepowernets()
		else
			return

	else if (cable_d1)
		var/datum/powernet/PN = powernets[cable_d1.netnum]
		PN.cables += src
		src.netnum = cable_d1.netnum
		if (PT && istype(PT))
			return makepowernets()
		else
			return

	else
		var/datum/powernet/PN = powernets[cable_d2.netnum]
		PN.cables += src
		src.netnum = cable_d2.netnum

	if (PT && istype(PT))
		return makepowernets()
	else
		return

	//powernets are really in need of a renovation.  makepowernets() is called way too much and is really intensive on the server ok.

// Some non-traitors love to hotwire the engine (Convair880).
/obj/cable/proc/log_wirelaying(var/mob/user, var/cut = 0)
	if (!src || !istype(src) || !user || !ismob(user))
		return

	var/powered = 0
	var/datum/powernet/PN = src.get_powernet()
	if (PN && istype(PN) && (PN.avail > 0))
		powered = 1

	logTheThing("station", user, null, "[cut == 0 ? "lays" : "cuts"] a cable[powered == 1 ? " (powered when [cut == 0 ? "connected" : "cut"])" : ""] at [log_loc(src)].")
	return