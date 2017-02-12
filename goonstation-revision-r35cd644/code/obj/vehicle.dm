/*
Contains:

-Vehicle parent
-Segway
-Floor buffer
-Clown car
-Rideable cats
-Admin bus
-Forklift
*/

//////////////////////////////// Vehicle parent ///////////////////////////////////////

/obj/vehicle
	name = "vehicle"
	icon = 'icons/obj/vehicles.dmi'
	density = 1
	var/mob/living/carbon/human/rider = null
	var/in_bump = 0
	var/sealed_cabin = 0
	var/rider_visible =	1
	var/list/ability_buttons = new/list()
	var/throw_dropped_items_overboard = 0 // See /mob/proc/drop_item() in mob.dm.
	layer = MOB_LAYER

	remove_air(amount)
		return src.loc.remove_air(amount)

	return_air()
		return src.loc.return_air()

	attackby(obj/item/W as obj, mob/user as mob)
		if(rider && rider_visible && W.force)
			eject_rider()
			W.attack(rider, user)
			return
		return

	proc/eject_rider(var/crashed, var/selfdismount)
		rider.set_loc(src.loc)
		rider = null
		return

	ex_act(severity)
		switch(severity)
			if(1.0)
				for(var/atom/movable/A as mob|obj in src)
					A.set_loc(src.loc)
					A.ex_act(severity)
					//Foreach goto(35)
				//SN src = null
				qdel(src)
				return
			if(2.0)
				if (prob(50))
					for(var/atom/movable/A as mob|obj in src)
						A.set_loc(src.loc)
						A.ex_act(severity)
						//Foreach goto(108)
					//SN src = null
					qdel(src)
					return
			if(3.0)
				if (prob(25))
					for(var/atom/movable/A as mob|obj in src)
						A.set_loc(src.loc)
						A.ex_act(severity)
						//Foreach goto(181)
					//SN src = null
					qdel(src)
					return
			else
		return

	proc/Stopped()
		return

	proc/stop()
		walk(src,0)
		Stopped()

	blob_act(var/power)
		qdel(src)

//////////////////////////////////////////////////////////// Segway ///////////////////////////////////////////

/obj/vehicle/segway
	name = "Space Segway"
	desc = "Now you too can look like a complete tool in space!"
	icon_state = "segway"
	layer = MOB_LAYER + 1
	mats = 8
	var/weeoo_in_progress = 0
	soundproofing = 0
	throw_dropped_items_overboard = 1
	var/datum/light/light

/obj/vehicle/segway/New()
	..()
	var/obj/ability_button/weeoo/NB = new
	NB.screen_loc = "NORTH-2,1"
	ability_buttons += NB
	light = new /datum/light/point
	light.set_brightness(0.7)
	light.attach(src)

/obj/vehicle/segway/proc/weeoo()
	if (weeoo_in_progress)
		return

	weeoo_in_progress = 10
	spawn (0)
		playsound(src.loc, "sound/machines/siren_police.ogg", 50, 1)
		light.enable()
		while (weeoo_in_progress--)
			light.set_color(0.9, 0.1, 0.1)
			sleep(3)
			light.set_color(0.1, 0.1, 0.9)
			sleep(3)
		light.disable()

		weeoo_in_progress = 0

/obj/ability_button/weeoo
	name = "Police Siren"
	icon = 'icons/misc/abilities.dmi'
	icon_state = "noise"

	Click()
		if(!the_mob) return

		var/obj/vehicle/segway/seg = the_mob.loc
		if (istype(seg))
			seg.weeoo()

		return

/obj/vehicle/segway/proc/update()
	if(rider)
		icon_state = "segway1"
	else
		icon_state = "segway"

/obj/vehicle/segway/Bump(atom/AM as mob|obj|turf)
	if(in_bump)
		return
	if(AM == rider || !rider)
		return
	if(world.timeofday - AM.last_bumped <= 100)
		return
	walk(src, 0)
	update()
	..()
	in_bump = 1
	if((isturf(AM) || istype(AM, /mob/living/carbon/wall)) && (rider.bioHolder.HasEffect("clumsy") || rider.reagents.has_reagent("ethanol")))
		boutput(rider, "<span style=\"color:red\"><B>You crash into the wall!</B></span>")
		for (var/mob/C in AIviewers(src))
			if(C == rider)
				continue
			C.show_message("<span style=\"color:red\"><B>[rider] crashes into the wall with the [src]!</B></span>", 1)
		eject_rider(2)
		in_bump = 0
		return
	if(ismob(AM))
		var/mob/M = AM
		boutput(rider, "<span style=\"color:red\"><B>You crash into [M]!</B></span>")
		for (var/mob/C in AIviewers(src))
			if(C == rider)
				continue
			C.show_message("<span style=\"color:red\"><B>[rider] crashes into [M] with the [src]!</B></span>", 1)
		// drsingh for undef variable silicon/robot/var/shoes
		// i guess a borg got on a segway? maybe someone was riding one with nanites
		if (istype(M, /mob/living/carbon/human))
			if(!istype(M:shoes, /obj/item/clothing/shoes/sandal))
				M.stunned = 8
				M.weakened = 5
				src.log_me(src.rider, M, "impact")
			else
				boutput(M, "<span style=\"color:red\"><B>Your magical sandals keep you upright!</B></span>")
				boutput(rider, "<span style=\"color:red\"><B>[M] is kept upright by magical sandals!</B></span>")
				src.log_me(src.rider, M, "impact", 1)
				for (var/mob/C in AIviewers(src))
					if(C == M)
						continue
					C.show_message("<span style=\"color:red\"><B>[M] is kept upright by magical sandals!</B></span>", 1)
		else
			M.stunned = 8
			M.weakened = 5
			src.log_me(src.rider, M, "impact")
		eject_rider(2)
		in_bump = 0

	if(istype(AM, /obj/item))
		if(AM:w_class >= 4.0)
			boutput(rider, "<span style=\"color:red\"><B>You crash into [AM]!</B></span>")
			for (var/mob/C in AIviewers(src))
				if(C == rider)
					continue
				C.show_message("<span style=\"color:red\"><B>[rider] crashes into [AM] with the [src]!</B></span>", 1)
			eject_rider(1)
			in_bump = 0
			return
	if(istype(AM, /obj/vehicle/segway))
		var/obj/vehicle/segway/SG = AM
		if(SG.rider)
			SG.in_bump = 1
			var/mob/M = SG.rider
			var/mob/N = rider
			boutput(N, "<span style=\"color:red\"><B>You crash into [M]'s [SG]!</B></span>")
			boutput(M, "<span style=\"color:red\"><B>[N] crashes into your [SG]!</B></span>")
			for (var/mob/C in AIviewers(src))
				if(C == N || C == M)
					continue
				C.show_message("<span style=\"color:red\"><B>[N] and [M] crash into each other!</B></span>", 1)
			eject_rider(2)
			SG.eject_rider(1)
			src.log_me(N, M, "impact")
			in_bump = 0
			SG.in_bump = 0
			return
	in_bump = 0
	return

/obj/vehicle/segway/eject_rider(var/crashed, var/selfdismount)
	if (!rider)
		return

	rider.set_loc(src.loc)
	rider.pixel_y = 0
	walk(src, 0)
	if (rider.client)
		for(var/obj/ability_button/B in ability_buttons)
			rider.client.screen -= B
	if(crashed)
		if(crashed == 2)
			playsound(src.loc, "sound/misc/meteorimpact.ogg", 40, 1)
		boutput(rider, "<span style=\"color:red\"><B>You are flung over the [src]'s handlebars!</B></span>")
		rider.stunned = 8
		rider.weakened = 5
		for (var/mob/C in AIviewers(src))
			if(C == rider)
				continue
			C.show_message("<span style=\"color:red\"><B>[rider] is flung over the [src]'s handlebars!</B></span>", 1)
		var/turf/target = get_edge_target_turf(src, src.dir)
		rider.throw_at(target, 5, 1)
		rider.buckled = null
		rider = null
		overlays = null
		update()
		return
	if(selfdismount)
		boutput(rider, "<span style=\"color:blue\">You dismount from the [src].</span>")
		for (var/mob/C in AIviewers(src))
			if(C == rider)
				continue
			C.show_message("<B>[rider]</B> dismounts from the [src].", 1)
	rider.buckled = null
	rider = null
	overlays = null
	update()
	return

/obj/vehicle/segway/relaymove(mob/user as mob, dir)
	if(rider)
		if(istype(src.loc, /turf/space))
			return
		icon_state = "segway2"
		walk(src, dir, 2)
	else
		for(var/mob/M in src.contents)
			M.set_loc(src.loc)

/obj/vehicle/segway/MouseDrop_T(mob/living/carbon/human/target, mob/user)
	if (rider || !istype(target) || target.buckled || LinkBlocked(target.loc,src.loc) || get_dist(user, src) > 1 || get_dist(user, target) > 1 || user.paralysis || user.stunned || user.weakened || user.stat || istype(user, /mob/living/silicon/ai))
		return

	var/msg

	if(target == user && !user.stat)	// if drop self, then climbed in
		msg = "[user.name] climbs onto the [src]."
		boutput(user, "<span style=\"color:blue\">You climb onto the [src].</span>")
	else if(target != user && !user.restrained())
		msg = "[user.name] helps [target.name] onto the [src]!"
		boutput(user, "<span style=\"color:blue\">You help [target.name] onto the [src]!</span>")
	else
		return

	if (target.client)
		for(var/obj/ability_button/B in ability_buttons)
			B.the_mob = target

		var/x_btt = 1
		for(var/obj/ability_button/B in ability_buttons)
			B.screen_loc = "NORTH-2,[x_btt]"
			target.client.screen += B
			x_btt++

	target.set_loc(src)
	rider = target
	rider.pixel_x = 0
	rider.pixel_y = 5
	overlays += rider
	if(rider.restrained() || rider.stat)
		rider.buckled = src

	for (var/mob/C in AIviewers(src))
		if(C == user)
			continue
		C.show_message(msg, 3)

	update()
	return

/obj/vehicle/segway/Click()
	if(usr != rider)
		..()
		return
	if(!(usr.paralysis || usr.stunned || usr.weakened || usr.stat))
		eject_rider(0, 1)
	return

/obj/vehicle/segway/attack_hand(mob/living/carbon/human/M as mob)
	if(!M || !rider)
		..()
		return
	switch(M.a_intent)
		if("harm", "disarm")
			if(prob(60))
				playsound(src.loc, "sound/weapons/thudswoosh.ogg", 50, 1, -1)
				src.visible_message("<span style=\"color:red\"><B>[M] has shoved [rider] off of the [src]!</B></span>")
				src.log_me(src.rider, M, "shoved_off")
				rider.weakened = 2
				eject_rider()
			else
				playsound(src.loc, "sound/weapons/punchmiss.ogg", 25, 1, -1)
				src.visible_message("<span style=\"color:red\"><B>[M] has attempted to shove [rider] off of the [src]!</B></span>")
	return

/obj/vehicle/segway/bullet_act(flag, A as obj)
	if(rider)
		rider.bullet_act(flag, A)
		eject_rider()
	return

/obj/vehicle/segway/meteorhit()
	if(rider)
		eject_rider()
		rider.meteorhit()
	return

/obj/vehicle/segway/disposing()
	if(rider)
		boutput(rider, "<span style=\"color:red\"><B>Your segway is destroyed!</B></span>")
		eject_rider()
	..()
	return

// Some people get really angry over this, so whatever. Logs would've been helpful on occasion (Convair880).
/obj/vehicle/segway/proc/log_me(var/mob/rider, var/mob/other_dude, var/action = "", var/immune_to_impact = 0)
	if (!src || action == "")
		return

	switch (action)
		if ("impact")
			if (ismob(rider) && ismob(other_dude))
				logTheThing("vehicle", rider, other_dude, "driving [src] crashes into %target%[immune_to_impact != 0 ? " (immune to impact)" : ""] at [log_loc(src)].")

		if ("shoved_off")
			if (ismob(rider) && ismob(other_dude))
				logTheThing("vehicle", other_dude, rider, "shoves %target% off of a [src] at [log_loc(src)].")

	return

////////////////////////////////////////////////////// Floor buffer /////////////////////////////////////

/obj/vehicle/floorbuffer
	name = "Buff-R-Matic 3000"
	desc = "A snazzy ridable floor buffer with a holding tank for cleaning agents."
	icon_state = "floorbuffer"
	layer = MOB_LAYER + 1
	is_syndicate = 1
	mats = 8
	var/low_reagents_warning = 0
	var/booster_upgrade = 0 // TODO: replace with wire hacking ala MULE
	var/zamboni = 0
	soundproofing = 0
	throw_dropped_items_overboard = 1

	New()
		..()
		var/datum/reagents/R = new/datum/reagents(1250)
		reagents = R
		R.my_atom = src
		if(zamboni)
			R.add_reagent("cryostylane", 1000)
		else
			R.add_reagent("water", 1000)
			R.add_reagent("cleaner", 250)
/*
/obj/ability_button/toggle_buffer
	name = "Toggle Buff-R-Matic Sprayer"
	icon = 'icons/misc/abilities.dmi'
	icon_state = "on"
	var/active = 0

	Click()
		if(!the_mob) return

		var/mob/my_mob = the_mob

		var/obj/vehicle/floorbuffer/FB = null

		if(istype(my_mob.loc, /obj/vehicle/floorbuffer))
			FB = my_mob.loc
			active = !active
			boutput(my_mob, "<span style=\"color:blue\"><B>You turn [active ? "on" : "off"] the floor buffer's sprayer.</span></B>")
			FB.sprayer_active = active
			src.icon_state = active ? "on" : "off"
			playsound(my_mob.loc, "sound/machines/click.ogg", 50, 1)

		return
*/
/obj/vehicle/floorbuffer/proc/update()
	underlays = null
	if(rider)
		icon_state = "floorbuffer1"
		underlays += image("icon" = 'icons/obj/vehicles.dmi', "icon_state" = "floorbuffer1a", "layer" = MOB_LAYER - 1 )
	else
		icon_state = "floorbuffer"

/obj/vehicle/floorbuffer/Move()
	if(..() && rider)
		pixel_x = rand(-1, 1)
		pixel_y = rand(-1, 1)
		spawn(1)
			pixel_x = rand(-1, 1)
			pixel_y = rand(-1, 1)
		spawn(0)
			if (src.reagents.total_volume < 1)
				return
			else if(src.reagents.total_volume < 250 && !low_reagents_warning)
				low_reagents_warning = 1
				boutput(rider, "<span style=\"color:blue\"><B>The \"Storage Tank Low\" indicator light starts blinking on the [src.name]'s dashboard.</B></span>")
				playsound(src, "sound/machines/twobeep.ogg", 50)
			else if(src.reagents.total_volume >= 250)
				low_reagents_warning = 0


			var/obj/decal/D = new/obj/decal(get_turf(src))
			D.name = null
			D.icon = null
			D.invisibility = 101
			D.create_reagents(5)
			src.reagents.trans_to(D, 5)

			D.reagents.reaction(get_turf(D))
			for(var/atom/T in get_turf(D))
				D.reagents.reaction(T)
			sleep(3)
			qdel(D)

/obj/vehicle/floorbuffer/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/reagent_containers) && W.is_open_container() && W.reagents)
		if(!W.reagents.total_volume)
			boutput(user, "<span style=\"color:red\">[W] is empty.</span>")
			return

		if(src.reagents.total_volume >= src.reagents.maximum_volume)
			boutput(user, "<span style=\"color:red\">The [src.name]'s holding tank is full!</span>")
			return

		logTheThing("combat", user, null, "pours chemicals [log_reagents(W)] into the [src] at [log_loc(src)].") // Logging for floor buffers (Convair880).
		var/trans = W.reagents.trans_to(src, W.reagents.total_volume)
		boutput(user, "<span style=\"color:blue\">You empty [trans] units of the solution into the [src.name]'s holding tank.</span>")
		return
	..()

/obj/vehicle/floorbuffer/is_open_container()
	return 2

/obj/vehicle/floorbuffer/Bump(atom/AM as mob|obj|turf)
	if(in_bump)
		return
	if(AM == rider || !rider)
		return
	if(world.timeofday - AM.last_bumped <= 100)
		return
	walk(src, 0)
	update()
	..()
	in_bump = 1
	if(ismob(AM) && src.booster_upgrade)
		var/mob/M = AM
		boutput(rider, "<span style=\"color:red\"><B>You crash into [M]!</B></span>")
		for (var/mob/C in AIviewers(src))
			if(C == rider)
				continue
			C.show_message("<span style=\"color:red\"><B>[rider] crashes into [M] with the [src]!</B></span>", 1)
		M.stunned = 5
		M.weakened = 3
		in_bump = 0
		return
	if(istype(AM, /obj/item))
		..()
		in_bump = 0
		return
	if(istype(AM, /obj/vehicle/segway))
		var/obj/vehicle/segway/SG = AM
		if(SG.rider)
			SG.in_bump = 1
			var/mob/M = SG.rider
			var/mob/N = rider
			boutput(N, "<span style=\"color:red\"><B>You crash into [M]'s [SG]!</B></span>")
			boutput(M, "<span style=\"color:red\"><B>[N] crashes into your [SG]!</B></span>")
			for (var/mob/C in AIviewers(src))
				if(C == N || C == M)
					continue
				C.show_message("<span style=\"color:red\"><B>[N] and [M] crash into each other!</B></span>", 1)
			SG.eject_rider(1)
			in_bump = 0
			SG.in_bump = 0
			return
	in_bump = 0
	return

/obj/vehicle/floorbuffer/eject_rider(var/crashed, var/selfdismount)
	rider.set_loc(src.loc)
	rider.pixel_y = 0
	walk(src, 0)
	src.log_rider(rider, 1)
	if(crashed)
		if(crashed == 2)
			playsound(src.loc, "sound/misc/meteorimpact.ogg", 40, 1)
		boutput(rider, "<span style=\"color:red\"><B>You are flung over the [src]'s handlebars!</B></span>")
		rider.stunned = 8
		rider.weakened = 5
		for (var/mob/C in AIviewers(src))
			if(C == rider)
				continue
			C.show_message("<span style=\"color:red\"><B>[rider] is flung over the [src]'s handlebars!</B></span>", 1)
		var/turf/target = get_edge_target_turf(src, src.dir)
		rider.throw_at(target, 5, 1)
		rider.buckled = null
		rider = null
		overlays = null
		update()
		return
	if(selfdismount)
		boutput(rider, "<span style=\"color:blue\">You dismount from the [src].</span>")
		for (var/mob/C in AIviewers(src))
			if(C == rider)
				continue
			C.show_message("<B>[rider]</B> dismounts from the [src].", 1)
	rider.buckled = null
	rider = null
	overlays = null
	update()
	return

/obj/vehicle/floorbuffer/relaymove(mob/user as mob, dir)
	src.overlays = null
	if(rider)
		src.overlays += rider
		if(istype(src.loc, /turf/space) && !src.booster_upgrade)
			return
		if(src.booster_upgrade)
			src.overlays += icon('icons/mob/robots.dmi', "up-speed")
			walk(src, dir, 1)
		else
			walk(src, dir, 4)
	else
		for(var/mob/M in src.contents)
			M.set_loc(src.loc)

/obj/vehicle/floorbuffer/MouseDrop_T(mob/living/carbon/human/target, mob/user)
	if (rider || !istype(target) || target.buckled || LinkBlocked(target.loc,src.loc) || get_dist(user, src) > 1 || get_dist(user, target) > 1 || user.paralysis || user.stunned || user.weakened || user.stat || istype(user, /mob/living/silicon/ai))
		return

	var/msg

	if(target == user && !user.stat)	// if drop self, then climbed in
		msg = "[user.name] climbs onto the [src]."
		boutput(user, "<span style=\"color:blue\">You climb onto the [src].</span>")
		src.log_rider(user, 0)
	else if(target != user && !user.restrained())
		msg = "[user.name] helps [target.name] onto the [src]!"
		boutput(user, "<span style=\"color:blue\">You help [target.name] onto the [src]!</span>")
		src.log_rider(target, 0)
	else
		return

	target.set_loc(src)
	rider = target
	rider.pixel_x = 0
	rider.pixel_y = 10
	overlays += rider
	if(rider.restrained() || rider.stat)
		rider.buckled = src

	for (var/mob/C in AIviewers(src))
		if(C == user)
			continue
		C.show_message(msg, 3)

	update()
	return

/obj/vehicle/floorbuffer/Click()
	if(usr != rider)
		..()
		return
	if(!(usr.paralysis || usr.stunned || usr.weakened || usr.stat))
		eject_rider(0, 1)
	return

/obj/vehicle/floorbuffer/attack_hand(mob/living/carbon/human/M as mob)
	if(!M || !rider)
		..()
		return
	switch(M.a_intent)
		if("harm", "disarm")
			if(prob(70) || M.bioHolder.HasEffect("hulk"))
				playsound(src.loc, "sound/weapons/thudswoosh.ogg", 50, 1, -1)
				src.visible_message("<span style=\"color:red\"><B>[M] has yanked [rider] off of the [src]!</B></span>")
				rider.weakened = 2
				eject_rider()
			else
				playsound(src.loc, "sound/weapons/punchmiss.ogg", 25, 1, -1)
				src.visible_message("<span style=\"color:red\"><B>[M] has attempted to yank [rider] off of the [src]!</B></span>")
	return

/obj/vehicle/floorbuffer/bullet_act(flag, A as obj)
	if (src.rider && ismob(src.rider))
		src.rider.bullet_act(flag, A)
		src.eject_rider()
	return

/obj/vehicle/floorbuffer/meteorhit()
	if (src.rider && ismob(src.rider))
		src.rider.meteorhit()
		src.eject_rider()
	return

/obj/vehicle/floorbuffer/disposing()
	if(rider)
		boutput(rider, "<span style=\"color:red\"><B>Your floor buffer is destroyed!</B></span>")
		eject_rider()
	..()
	return

// Ditto, more logs (Convair880).
/obj/vehicle/floorbuffer/proc/log_rider(var/mob/rider, var/mount_or_dismount = 0)
	if (!src || !rider || !ismob(rider))
		return

	logTheThing("vehicle", rider, null, "[mount_or_dismount == 0 ? "mounts" : "dismounts"] a [src.name] [log_reagents(src)] at [log_loc(src)].")
	return

/////////////////////////////////////////////////////// Clown car ////////////////////////////////////////

/obj/vehicle/clowncar
	name = "Clown Car"
	desc = "A funny-looking car designed for circus events. Seats 30, very roomy!"
	icon_state = "clowncar"
	var/antispam = 0
	var/moving = 0
	rider_visible = 0
	is_syndicate = 1
	mats = 15
	soundproofing = 5

/obj/vehicle/clowncar/relaymove(mob/user as mob, dir)
	if(rider && user == rider)
		if(istype(src.loc, /turf/space))
			return
		for (var/mob/living/carbon/human/H in src)
			if (H.sims)
				H.sims.affectMotive("fun", 1)
				H.sims.affectMotive("hunger", 1)
				H.sims.affectMotive("thirst", 1)
		icon_state = "clowncar2"
		walk(src, dir, 2)
		moving = 1
		if(!(world.timeofday - src.antispam <= 60))
			src.antispam = world.timeofday
			playsound(src, "sound/machines/rev_engine.ogg", 50, 1)
			playsound(src.loc, "sound/machines/rev_engine.ogg", 50, 1)
			//play engine sound
	else
		..()
		return

/obj/vehicle/clowncar/Click()
	if(usr != rider)
		..()
		return
	if(!(usr.paralysis || usr.stunned || usr.weakened || usr.stat))
		eject_rider(0, 1)
	return

/obj/vehicle/clowncar/attack_hand(mob/living/carbon/human/M as mob)
	if(!M)
		..()
		return
	if(M.bioHolder.HasEffect("hulk"))
		if(prob(40))
			boutput(M, "<span style=\"color:red\"><B>You smash the puny [src] apart!</B></span>")
			playsound(src, "shatter", 70, 1)
			playsound(src.loc, "sound/misc/meteorimpact.ogg", 40, 1)

			for(var/mob/N in AIviewers(M, null))
				if(N == M)
					continue
				N.show_message(text("<span style=\"color:red\"><B>[] smashes the [] apart!</B></span>", M, src), 1)
			for(var/atom/A in src.contents)
				if(ismob(A))
					if (A != src.rider) // Rider log is called by disposing().
						src.log_me(src.rider, A, "pax_exit")
					var/mob/N = A
					N.show_message(text("<span style=\"color:red\"><B>[] smashes the [] apart!</B></span>", M, src), 1)
					N.set_loc(src.loc)
				else if (isobj(A))
					var/obj/O = A
					O.set_loc(src.loc)
			var/obj/item/scrap/S = new
			S.size = 4
			S.update()
			qdel(src)
		else
			boutput(M, "<span style=\"color:red\"><B>You punch the puny [src]!</B></span>")
			playsound(src.loc, "sound/misc/meteorimpact.ogg", 40, 1)
			for(var/mob/N in AIviewers(M, null))
				if(N == M)
					continue
				N.show_message(text("<span style=\"color:red\"><B>[] punches the []!</B></span>", M, src), 1)
			for(var/atom/A in src.contents)
				if(ismob(A))
					var/mob/N = A
					N.show_message(text("<span style=\"color:red\"><B>[] punches the []!</B></span>", M, src), 1)
	else
		playsound(src.loc, "sound/machines/click.ogg", 15, 1, -3)
		if(rider && prob(40))
			playsound(src.loc, "sound/weapons/thudswoosh.ogg", 50, 1, -1)
			src.visible_message("<span style=\"color:red\"><B>[M] has pulled [rider] out of the [src]!</B></span>")
			rider.weakened = 2
			eject_rider()
		else
			if(src.contents.len)
				playsound(src.loc, "sound/weapons/thudswoosh.ogg", 50, 1, -1)
				src.visible_message("<span style=\"color:red\"><B>[M] opens up the [src], spilling the contents out!</B></span>")
				for(var/atom/A in src.contents)
					if(ismob(A))
						var/mob/N = A
						if (N != src.rider)
							src.log_me(src.rider, N, "pax_exit")
							N.show_message(text("<span style=\"color:red\"><B>You are let out of the [] by []!</B></span>", src, M), 1)
							N.set_loc(src.loc)
						else
							N.weakened = 2
							src.eject_rider()
					else if (isobj(A))
						var/obj/O = A
						O.set_loc(src.loc)
			else
				boutput(M, "<span style=\"color:blue\">There's nothing inside of the [src].</span>")
				return
	return

/obj/vehicle/clowncar/MouseDrop_T(mob/living/carbon/human/target, mob/user)
	if (!istype(target) || target.buckled || LinkBlocked(target.loc,src.loc) || get_dist(user, src) > 1 || get_dist(user, target) > 1 || user.paralysis || user.stunned || user.weakened || user.stat || istype(user, /mob/living/silicon/ai))
		return

	var/msg

	var/clown_tally = 0
	if(ishuman(user))
		if(istype(user:w_uniform, /obj/item/clothing/under/misc/clown))
			clown_tally += 1
		if(istype(user:shoes, /obj/item/clothing/shoes/clown_shoes))
			clown_tally += 1
		if(istype(user:wear_mask, /obj/item/clothing/mask/clown_hat))
			clown_tally += 1
	if(clown_tally < 2)
		boutput(user, "<span style=\"color:blue\">You don't feel funny enough to use the [src].</span>")
		return

	if(target == user && !user.stat)	// if drop self, then climbed in
		if(rider)
			return
		rider = target
		src.log_me(src.rider, null, "rider_enter")
		msg = "[user.name] climbs into the driver's seat of the [src]."
		boutput(user, "<span style=\"color:blue\">You climb into the driver's seat of the [src].</span>")
	else if(target != user && !user.restrained() && target.lying)
		src.log_me(user, target, "pax_enter", 1)
		msg = "[user.name] stuffs [target.name] into the back of the [src]!"
		boutput(user, "<span style=\"color:blue\">You stuff [target.name] into the back of the [src]!</span>")
	else
		return

	target.set_loc(src)
	for (var/mob/C in AIviewers(src))
		if(C == user)
			continue
		C.show_message(msg, 3)
	return

/obj/vehicle/clowncar/Bump(atom/AM as mob|obj|turf)
	if(in_bump)
		return
	if(AM == rider || !rider)
		return
	if(world.timeofday - AM.last_bumped <= 100)
		return
	walk(src, 0)
	moving = 0
	icon_state = "clowncar"
	..()
	in_bump = 1
	if((isturf(AM) || istype(AM, /mob/living/carbon/wall)))
		boutput(rider, "<span style=\"color:red\"><B>You crash into the wall!</B></span>")
		for (var/mob/C in AIviewers(src))
			if(C == rider)
				continue
			C.show_message("<span style=\"color:red\"><B>[rider] crashes into the wall with the [src]!</B></span>", 1)
		eject_rider(2)
		in_bump = 0
		return
	if(ismob(AM))
		DEBUG("Bumped [AM] and gonna bowl 'em over.")
		bumpstun(AM)

//		eject_rider(2)
		in_bump = 0
		return
	if(istype(AM, /obj/vehicle/segway))
		var/obj/vehicle/segway/SG = AM
		if(SG.rider)
			SG.in_bump = 1
			var/mob/M = SG.rider
			var/mob/N = rider
			boutput(N, "<span style=\"color:red\"><B>You crash into [M]'s [SG]!</B></span>")
			boutput(M, "<span style=\"color:red\"><B>[N] crashes into your [SG]!</B></span>")
			for (var/mob/C in AIviewers(src))
				if(C == N || C == M)
					continue
				C.show_message("<span style=\"color:red\"><B>[N] crashes into [M]'s [SG]!</B></span>", 1)
			SG.eject_rider(1)
			in_bump = 0
			SG.in_bump = 0
			return
	in_bump = 0
	return

/obj/vehicle/clowncar/Bumped(var/atom/movable/AM as mob|obj)
	if (moving && ismob(AM)) //If we're moving and they're in front of us then bump they
		walk(src, 0)
		moving = 0
		bumpstun(AM)

	..()

/obj/vehicle/clowncar/proc/bumpstun(var/mob/M)
	if(istype(M))
		boutput(rider, "<span style=\"color:red\"><B>You crash into [M]!</B></span>")
		for (var/mob/C in AIviewers(src))
			if(C == rider)
				continue
			C.show_message("<span style=\"color:red\"><B>[rider] crashes into [M] with the [src]!</B></span>", 1)
		M.stunned = 8
		M.weakened = 5
		playsound(src.loc, "sound/misc/meteorimpact.ogg", 40, 1)

/obj/vehicle/clowncar/bullet_act(flag, A as obj)
	if (src.rider && ismob(src.rider) && prob(30))
		src.rider.bullet_act(flag, A)
		src.eject_rider(1)
	return

/obj/vehicle/clowncar/meteorhit()
	if(prob(60))
		eject_rider(2)
	return

/obj/vehicle/clowncar/disposing()
	if(rider)
		boutput(rider, "<span style=\"color:red\"><B>Your [src] is destroyed!</B></span>")
		eject_rider(1)
	..()
	return

/obj/vehicle/clowncar/eject_rider(var/crashed, var/selfdismount)
	if (!src.rider || !ismob(src.rider))
		return
	rider.set_loc(src.loc)
	walk(src, 0)
	moving = 0
	src.log_me(src.rider, null, "rider_exit")
	if(crashed)
		if(crashed == 2)
			playsound(src.loc, "sound/misc/meteorimpact.ogg", 40, 1)
		playsound(src.loc, "shatter", 40, 1)
		boutput(rider, "<span style=\"color:red\"><B>You are flung through the [src]'s windshield!</B></span>")
		rider.stunned = 8
		rider.weakened = 5
		for (var/mob/C in AIviewers(src))
			if(C == rider)
				continue
			C.show_message("<span style=\"color:red\"><B>[rider] is flung through the [src]'s windshield!</B></span>", 1)
		var/turf/target = get_edge_target_turf(src, src.dir)
		rider.throw_at(target, 5, 1)
		rider.buckled = null
		rider = null
		icon_state = "clowncar"
		if(prob(40) && src.contents.len)
			for(var/mob/O in AIviewers(src, null))
				O.show_message(text("<span style=\"color:red\"><B>Everything in the [] flies out!</B></span>", src), 1)
			for(var/atom/A in src.contents)
				if(ismob(A))
					src.log_me(null, A, "pax_exit")
					var/mob/N = A
					N.show_message(text("<span style=\"color:red\"><B>You are flung out of the []!</B></span>", src), 1)
					N.set_loc(src.loc)
				else if (isobj(A))
					var/obj/O = A
					O.set_loc(src.loc)
		return
	if(selfdismount)
		boutput(rider, "<span style=\"color:blue\">You climb out of the [src].</span>")
		for (var/mob/C in AIviewers(src))
			if(C == rider)
				continue
			C.show_message("<B>[rider]</B> climbs out of the [src].", 1)
	rider.buckled = null
	rider = null
	icon_state = "clowncar"
	return

/obj/vehicle/clowncar/attackby(var/obj/item/I, var/mob/user)
	var/clown_tally = 0
	if(ishuman(user))
		if(istype(user:w_uniform, /obj/item/clothing/under/misc/clown))
			clown_tally += 1
		if(istype(user:shoes, /obj/item/clothing/shoes/clown_shoes))
			clown_tally += 1
		if(istype(user:wear_mask, /obj/item/clothing/mask/clown_hat))
			clown_tally += 1
	if(clown_tally < 2)
		boutput(user, "<span style=\"color:blue\">You don't feel funny enough to use the [src].</span>")
		return

	var/obj/item/grab/G = I
	if(istype(G))	// handle grabbed mob
		if(ismob(G.affecting))
			var/mob/GM = G.affecting
			GM.set_loc(src)
			boutput(user, "<span style=\"color:blue\">You stuff [GM.name] into the back of the [src].</span>")
			boutput(GM, "<span style=\"color:red\"><B>[user] stuffs you into the back of the [src]!</B></span>")
			src.log_me(user, GM, "pax_enter", 1)
			for (var/mob/C in AIviewers(src))
				if(C == user)
					continue
				C.show_message("<span style=\"color:red\"><B>[GM.name] has been stuffed into the back of the [src] by [user]!</B></span>", 3)
			qdel(G)
			return
	..()
	return

// Could be useful, I guess (Convair880).
obj/vehicle/clowncar/proc/log_me(var/mob/rider, var/mob/pax, var/action = "", var/forced_in = 0)
	if (!src || action == "")
		return

	switch (action)
		if ("rider_enter", "rider_exit")
			if (rider && ismob(rider))
				logTheThing("vehicle", rider, null, "[action == "rider_enter" ? "starts driving" : "stops driving"] [src.name] at [log_loc(src)].")

		if ("pax_enter", "pax_exit")
			if (pax && ismob(pax))
				logTheThing("vehicle", pax, rider && ismob(rider) ? rider : null, "[action == "pax_enter" ? "is stuffed into" : "is ejected from"] [src.name] ([forced_in == 1 ? "Forced by" : "Driven by"]: [rider && ismob(rider) ? "%target%" : "N/A or unknown"]) at [log_loc(src)].")

	return

/obj/vehicle/clowncar/cluwne
	name = "cluwne car"
	desc = "A hideous-looking piece of shit on wheels. You probably shouldn't drive this."
	icon_state = "cluwnecar"

/obj/vehicle/clowncar/cluwne/Move()
	if(..())
		if(prob(2) && rider)
			eject_rider(1)
		pixel_x = rand(-6, 6)
		pixel_y = rand(-2, 2)
		spawn(1)
			pixel_x = rand(-6, 6)
			pixel_y = rand(-2, 2)

/obj/vehicle/clowncar/cluwne/relaymove(mob/user as mob, dir)
	..(user, dir)
	if(rider && user == rider)
		icon_state = "cluwnecar2"

/obj/vehicle/clowncar/cluwne/attackby(var/obj/item/W, var/mob/user)
	eject_rider()
	W.attack(rider, user)

/obj/vehicle/clowncar/cluwne/eject_rider(var/crashed, var/selfdismount)
	..(crashed, selfdismount)
	icon_state = "cluwnecar"
	pixel_x = 0
	pixel_y = 0

/obj/vehicle/clowncar/cluwne/Bump(atom/AM as mob|obj|turf)
	..(AM)
	icon_state = "cluwnecar"
	pixel_x = 0
	pixel_y = 0

/obj/vehicle/clowncar/cluwne/MouseDrop_T(mob/living/carbon/human/target, mob/user)
	if (!istype(target) || target.buckled || LinkBlocked(target.loc,src.loc) || get_dist(user, src) > 1 || get_dist(user, target) > 1 || user.paralysis || user.stunned || user.weakened || user.stat || istype(user, /mob/living/silicon/ai))
		return

	var/msg

	if(!user.mind || !iscluwne(user))
		boutput(user, "<span style=\"color:red\">You think it's a REALLY bad idea to use the [src].</span>")
		return

	if(target == user && !user.stat)	// if drop self, then climbed in
		if(rider)
			return
		rider = target
		src.log_me(src.rider, null, "rider_enter")
		msg = "[user.name] climbs into the driver's seat of the [src]."
		boutput(user, "<span style=\"color:blue\">You climb into the driver's seat of the [src].</span>")
	else
		return

	target.set_loc(src)
	for (var/mob/C in AIviewers(src))
		if(C == user)
			continue
		C.show_message(msg, 3)
	return

/obj/vehicle/clowncar/surplus
	name = "Clown Car"
	desc = "A funny-looking car designed for circus events. Seats 30, very roomy! Comes with a free set of clown clothes!"
	icon_state = "clowncar"

	New()
		..()
		new /obj/item/storage/box/costume/clown(src.loc)

//////////////////////////////////////////////////// Rideable cats /////////////////////////////////////////////////////

/obj/vehicle/cat
	name = "Rideable Cat"
	desc = "He looks happy... how odd!"
	icon_state = "segwaycat-norider"
	layer = MOB_LAYER + 1
	soundproofing = 0
	throw_dropped_items_overboard = 1

// Might as well make use of the Garfield sprites (Convair880).

/obj/vehicle/cat/garfield
	name = "Garfield??"
	desc = "I'm not overweight, I'm undertall."
	icon_state = "garfield-norider"

/obj/vehicle/cat/proc/update()
	if(rider)
		if (istype(src, /obj/vehicle/cat/garfield))
			icon_state = "garfield"
		else
			icon_state = "segwaycat"
	else
		if (istype(src, /obj/vehicle/cat/garfield))
			icon_state = "garfield-norider"
		else
			icon_state = "segwaycat-norider"

/obj/vehicle/cat/Bump(atom/AM as mob|obj|turf)
	if(in_bump)
		return
	if(AM == rider || !rider)
		return
	if(world.timeofday - AM.last_bumped <= 100)
		return
	walk(src, 0)
	update()
	..()
	in_bump = 1
	if((isturf(AM) || istype(AM, /mob/living/carbon/wall)) && (rider.bioHolder.HasEffect("clumsy") || rider.reagents.has_reagent("ethanol")))
		boutput(rider, "<span style=\"color:red\"><B>You run to the wall!</B></span>")
		for (var/mob/C in AIviewers(src))
			if(C == rider)
				continue
			C.show_message("<span style=\"color:red\"><B>[rider] runs into the wall with the [src]!</B></span>", 1)
		eject_rider(2)
		in_bump = 0
		return
	if(ismob(AM))
		var/mob/M = AM
		boutput(rider, "<span style=\"color:red\"><B>You run into [M]!</B></span>")
		for (var/mob/C in AIviewers(src))
			if(C == rider)
				continue
			C.show_message("<span style=\"color:red\"><B>[rider] runs into [M] with the [src]!</B></span>", 1)
		M.stunned = 8
		M.weakened = 5
		eject_rider(2)
		in_bump = 0
		return
	if(istype(AM, /obj/item))
		if(AM:w_class >= 4.0)
			boutput(rider, "<span style=\"color:red\"><B>You run into [AM]!</B></span>")
			for (var/mob/C in AIviewers(src))
				if(C == rider)
					continue
				C.show_message("<span style=\"color:red\"><B>[rider] runs into [AM] with the [src]!</B></span>", 1)
			eject_rider(1)
			in_bump = 0
			return
	if(istype(AM, /obj/vehicle/segway))
		var/obj/vehicle/segway/SG = AM
		if(SG.rider)
			SG.in_bump = 1
			var/mob/M = SG.rider
			var/mob/N = rider
			boutput(N, "<span style=\"color:red\"><B>You run into [M]'s [SG]!</B></span>")
			boutput(M, "<span style=\"color:red\"><B>[N] runs into your [SG]!</B></span>")
			for (var/mob/C in AIviewers(src))
				if(C == N || C == M)
					continue
				C.show_message("<span style=\"color:red\"><B>[N] and [M] crash into each other!</B></span>", 1)
			eject_rider(2)
			SG.eject_rider(1)
			in_bump = 0
			SG.in_bump = 0
			return
	in_bump = 0
	return

/obj/vehicle/cat/eject_rider(var/crashed, var/selfdismount)
	rider.set_loc(src.loc)
	rider.pixel_y = 0
	walk(src, 0)
	if(crashed)
		if(crashed == 2)
			playsound(src.loc, "sound/effects/cat.ogg", 70, 1)
		boutput(rider, "<span style=\"color:red\"><B>You are flung over the [src]'s head!</B></span>")
		rider.stunned = 8
		rider.weakened = 5
		for (var/mob/C in AIviewers(src))
			if(C == rider)
				continue
			C.show_message("<span style=\"color:red\"><B>[rider] is flung over the [src]'s head!</B></span>", 1)
		var/turf/target = get_edge_target_turf(src, src.dir)
		rider.throw_at(target, 5, 1)
		rider.buckled = null
		rider = null
		overlays = null
		update()
		return
	if(selfdismount)
		boutput(rider, "<span style=\"color:blue\">You dismount from the [src].</span>")
		for (var/mob/C in AIviewers(src))
			if(C == rider)
				continue
			C.show_message("<B>[rider]</B> dismounts from the [src].", 1)
	rider.buckled = null
	rider = null
	overlays = null
	update()
	return

/obj/vehicle/cat/relaymove(mob/user as mob, dir)
	if(rider)
		if(istype(src.loc, /turf/space))
			return
		switch(dir)
			if(NORTH,SOUTH)
				layer = MOB_LAYER+1// TODO Layer wtf
			if(EAST,WEST)
				layer = 3
		walk(src, dir, 2)
	else
		for(var/mob/M in src.contents)
			M.set_loc(src.loc)

/obj/vehicle/cat/MouseDrop_T(mob/living/carbon/human/target, mob/user)
	if (rider || !istype(target) || target.buckled || get_dist(user, src) > 1 || get_dist(user, target) > 1 || user.paralysis || user.stunned || user.weakened || user.stat || istype(user, /mob/living/silicon/ai))
		return

	var/msg

	if(target == user && !user.stat)	// if drop self, then climbed in
		msg = "[user.name] climbs onto the [src]."
		boutput(user, "<span style=\"color:blue\">You climb onto the [src].</span>")
	else if(target != user && !user.restrained())
		msg = "[user.name] helps [target.name] onto the [src]!"
		boutput(user, "<span style=\"color:blue\">You help [target.name] onto the [src]!</span>")
	else
		return

	target.set_loc(src)
	rider = target
	rider.pixel_x = 0
	rider.pixel_y = 5
	overlays += rider
	if(rider.restrained() || rider.stat)
		rider.buckled = src

	for (var/mob/C in AIviewers(src))
		if(C == user)
			continue
		C.show_message(msg, 3)

	update()
	return

/obj/vehicle/cat/Click()
	if(usr != rider)
		..()
		return
	if(!(usr.paralysis || usr.stunned || usr.weakened || usr.stat))
		eject_rider(0, 1)
	return

/obj/vehicle/cat/attack_hand(mob/living/carbon/human/M as mob)
	if(!M || !rider)
		..()
		return
	switch(M.a_intent)
		if("harm", "disarm")
			if(prob(60))
				playsound(src.loc, "sound/weapons/thudswoosh.ogg", 50, 1, -1)
				src.visible_message("<span style=\"color:red\"><B>[M] has shoved [rider] off of the [src]!</B></span>")
				rider.weakened = 2
				eject_rider()
			else
				playsound(src.loc, "sound/weapons/punchmiss.ogg", 25, 1, -1)
				src.visible_message("<span style=\"color:red\"><B>[M] has attempted to shove [rider] off of the [src]!</B></span>")
	return

/obj/vehicle/cat/bullet_act(flag, A as obj)
	if(rider)
		eject_rider()
		rider.bullet_act(flag, A)
	return

/obj/vehicle/cat/meteorhit()
	if(rider)
		eject_rider()
		rider.meteorhit()
	return

/obj/vehicle/cat/disposing()
	if(rider)
		boutput(rider, "<span style=\"color:red\"><B>Your cat is destroyed!</B></span>")
		eject_rider()
	..()
	return

////////////////////////////////////////////////// Admin bus /////////////////////////////////////

/obj/vehicle/adminbus
	name = "Admin Bus"
	desc = "A short yellow bus that looks reinforced."
	icon_state = "adminbus"
	var/nonmoving_state = "adminbus"
	var/moving_state = "adminbus2"
	var/antispam = 0
	is_syndicate = 1
	mats = 15
	sealed_cabin = 1
	rider_visible = 0
	var/gib_onhit = 0
	var/is_badmin_bus = 0
	var/atom/movable/effect/darkness/darkness
	soundproofing = 5

/obj/vehicle/adminbus/New()
	..()
	var/obj/ability_button/loudhorn/NB = new
	NB.screen_loc = "NORTH-2,1"
	ability_buttons += NB
	var/obj/ability_button/stopthebus/SB = new
	SB.screen_loc = "NORTH-2,2"
	ability_buttons += SB

/obj/vehicle/adminbus/Del()
	if(darkness)
		qdel(darkness)
	..()

/obj/vehicle/adminbus/Move()
	if(src.darkness)
		src.darkness.set_loc(src.loc)
		if(prob(3))
			src.do_darkness()

	return ..()

/obj/ability_button/loudhorn
	name = "Loudhorn"
	icon = 'icons/misc/abilities.dmi'
	icon_state = "noise"
	var/active = 0

	Click()
		if(!the_mob) return
		if(active) return

		var/the_turf = get_turf(the_mob)
		active = 1
		var/mob/my_mob = the_mob

		if(!isturf(my_mob.loc))
			playsound(my_mob.loc, "sound/items/vuvuzela.ogg", 50, 1)
		playsound(the_turf, "sound/items/vuvuzela.ogg", 50, 1)

		spawn(10)
			active = 0

		return

/obj/ability_button/stopthebus
	name = "Stop The Bus"
	icon = 'icons/misc/ManuUI.dmi'
	icon_state = "cancel"
	var/active = 0

	Click()
		if(!the_mob) return
		var/mob/my_mob = the_mob
		if(!istype(my_mob.loc, /obj/vehicle)) return
		var/obj/vehicle/v = my_mob.loc
		v.stop()
		return

/obj/vehicle/adminbus/Stopped()
	..()
	icon_state = nonmoving_state

/obj/vehicle/adminbus/relaymove(mob/user as mob, dir)
	src.overlays = null
	if(rider && user == rider)
		if(istype(src.loc, /turf/space))
			src.overlays += icon('icons/mob/robots.dmi', "up-speed")
		icon_state = moving_state
		walk(src, dir, 1)
		if(!(world.timeofday - src.antispam <= 60))
			src.antispam = world.timeofday
			playsound(src, "sound/machines/rev_engine.ogg", 50, 1)
			playsound(src.loc, "sound/machines/rev_engine.ogg", 50, 1)
			//play engine sound
	else
		..()
		return

// the adminbus has a pressurized cabin!
/obj/vehicle/adminbus/handle_internal_lifeform(mob/lifeform_inside_me, breath_request)
	var/datum/gas_mixture/GM = unpool(/datum/gas_mixture)

	var/oxygen = MOLES_O2STANDARD
	var/nitrogen = MOLES_N2STANDARD
	var/sum = oxygen + nitrogen

	GM.oxygen = (oxygen/sum)*breath_request
	GM.nitrogen = (nitrogen/sum)*breath_request
	GM.temperature = T20C

	return GM

/obj/vehicle/adminbus/Click()
	if(usr != rider)
		var/mob/M = usr
		if(M.client && M.client.holder && M.loc == src)
			M.show_message(text("<span style=\"color:red\"><B>You exit the []!</B></span>", src), 1)
			M.remove_adminbus_powers()
			M.set_loc(src.loc)
			return
		..()
		return
	if(!(usr.paralysis || usr.stunned || usr.weakened || usr.stat))
		eject_rider(0, 1)
	return

/obj/vehicle/adminbus/attack_hand(mob/living/carbon/human/M as mob)
	if(!M || !(M.client && M.client.holder))
		..()
		return
	if(M.bioHolder.HasEffect("hulk"))
		if(prob(40))
			boutput(M, "<span style=\"color:red\"><B>You smash the puny [src] apart!</B></span>")
			playsound(src, "shatter", 70, 1)
			playsound(src.loc, "sound/misc/meteorimpact.ogg", 40, 1)

			for(var/mob/N in AIviewers(M, null))
				if(N == M)
					continue
				N.show_message("<span style=\"color:red\"><B>[M] smashes the [src] apart!</B></span>", 1)
			for(var/atom/A in src.contents)
				if(ismob(A))
					var/mob/N = A
					N.show_message("<span style=\"color:red\"><B>[M] smashes the [src] apart!</B></span>", 1)
					N.set_loc(src.loc)
				else if (isobj(A))
					var/obj/O = A
					O.set_loc(src.loc)
			var/obj/item/scrap/S = new
			S.size = 4
			S.update()
			qdel(src)
		else
			boutput(M, "<span style=\"color:red\"><B>You punch the puny [src]!</B></span>")
			playsound(src.loc, "sound/misc/meteorimpact.ogg", 40, 1)
			for(var/mob/N in AIviewers(M, null))
				if(N == M)
					continue
				N.show_message("<span style=\"color:red\"><B>[M] punches the [src]!</B></span>", 1)
			for(var/atom/A in src.contents)
				if(ismob(A))
					var/mob/N = A
					N.show_message("<span style=\"color:red\"><B>[M] punches the [src]!</B></span>", 1)
	else
		playsound(src.loc, "sound/machines/click.ogg", 15, 1, -3)
		if(rider && prob(40))
			playsound(src.loc, "sound/weapons/thudswoosh.ogg", 50, 1, -1)
			src.visible_message("<span style=\"color:red\"><B>[M] has pulled [rider] out of the [src]!</B></span>", 1)
			rider.weakened = 2
			eject_rider()
		else
			if(src.contents.len)
				playsound(src.loc, "sound/weapons/thudswoosh.ogg", 50, 1, -1)
				src.visible_message("<span style=\"color:red\"><B>[M] opens up the [src], spilling the contents out!</B></span>", 1)
				for(var/atom/A in src.contents)
					if(ismob(A))
						var/mob/N = A
						N.show_message("<span style=\"color:red\"><B>You are let out of the [src] by [M]!</B></span>", 1)
						N.set_loc(src.loc)
					else if (isobj(A))
						var/obj/O = A
						O.set_loc(src.loc)
			else
				boutput(M, "<span style=\"color:blue\">There's nothing inside of the [src].</span>")
				return
	return

/obj/vehicle/adminbus/MouseDrop_T(mob/living/carbon/human/target, mob/user)
	if (!istype(target) || target.buckled || LinkBlocked(target.loc,src.loc) || get_dist(user, src) > 1 || get_dist(user, target) > 1 || user.paralysis || user.stunned || user.weakened || user.stat || istype(user, /mob/living/silicon/ai))
		return

	var/msg

	if(!(user.client && user.client.holder))
		boutput(user, "<span style=\"color:blue\">You don't feel cool enough to use the [src].</span>")
		return

	if(target == user && !user.stat)	// if drop self, then climbed in
		if(rider)
			msg = "[user.name] climbs into the front of the [src]."
			boutput(user, "<span style=\"color:blue\">You climb into the front of the [src].</span>")
		else
			rider = target
			msg = "[user.name] climbs into the driver's seat of the [src]."
			boutput(user, "<span style=\"color:blue\">You climb into the driver's seat of the [src].</span>")
			rider.add_adminbus_powers()
			sleep(10)
			for(var/obj/ability_button/B in ability_buttons)
				B.the_mob = rider

			var/x_btt = 1
			for(var/obj/ability_button/B in ability_buttons)
				B.screen_loc = "NORTH-2,[x_btt]"
				rider.client.screen += B
				x_btt++
	else if(target != user && !user.restrained())
		msg = "[user.name] stuffs [target.name] into the back of the [src]!"
		boutput(user, "<span style=\"color:blue\">You stuff [target.name] into the back of the [src]!</span>")
	else
		return
	target.set_loc(src)
	for (var/mob/C in AIviewers(src))
		if(C == user)
			continue
		C.show_message(msg, 3)
	return

/obj/vehicle/adminbus/Bump(atom/AM as mob|obj|turf)
	if(in_bump)
		return
	if(AM == rider || !rider)
		return
	if(!is_badmin_bus && world.timeofday - AM.last_bumped <= 100)
		return
	if(is_badmin_bus && world.timeofday - AM.last_bumped <= 50)
		return
	walk(src, 0)
	icon_state = nonmoving_state
	..()
	in_bump = 1
	if(isturf(AM))
		if(istype(AM, /turf/simulated/wall/r_wall || istype(AM, /turf/simulated/wall/auto/reinforced)) && prob(40))
			in_bump = 0
			return
		if(istype(AM, /turf/simulated/wall))
			var/turf/simulated/wall/T = AM
			T.dismantle_wall(1)
			playsound(src.loc, "sound/misc/meteorimpact.ogg", 40, 1)
			playsound(src, "sound/misc/meteorimpact.ogg", 40, 1)
			boutput(rider, "<span style=\"color:red\"><B>You crash through the wall!</B></span>")
			for(var/mob/C in viewers(src))
				shake_camera(C, 10, 4)
				if(C == rider)
					continue
				C.show_message("<span style=\"color:red\"><B>The [src] crashes through the wall!</B></span>", 1)
			in_bump = 0
			return
	if(ismob(AM))
		var/mob/M = AM
		boutput(rider, "<span style=\"color:red\"><B>You crash into [M]!</B></span>")
		for (var/mob/C in viewers(src))
			shake_camera(C, 8, 3)
			if(C == rider)
				continue
			C.show_message("<span style=\"color:red\"><B>The [src] crashes into [M]!</B></span>", 1)
		if(src.gib_onhit)
			M.gib()
		else
			M.stunned = 8
			M.weakened = 5
			var/turf/target = get_edge_target_turf(src, src.dir)
			spawn(0)
				M.throw_at(target, 10, 2)
		playsound(src.loc, "sound/misc/meteorimpact.ogg", 40, 1)
		playsound(src, "sound/misc/meteorimpact.ogg", 40, 1)
		in_bump = 0
		return
	if(isobj(AM))
		var/obj/O = AM
		if(O.density)
			boutput(rider, "<span style=\"color:red\"><B>You crash into [O]!</B></span>")
			for (var/mob/C in viewers(src))
				shake_camera(C, 8, 3)
				if(C == rider)
					continue
				C.show_message("<span style=\"color:red\"><B>The [src] crashes into [O]!</B></span>", 1)
			var/turf/target = get_edge_target_turf(src, src.dir)
			playsound(src.loc, "sound/misc/meteorimpact.ogg", 40, 1)
			playsound(src, "sound/misc/meteorimpact.ogg", 40, 1)
			O.throw_at(target, 10, 2)
			if(istype(O, /obj/window) || istype(O, /obj/grille) || istype(O, /obj/machinery/door) || istype(O, /obj/structure/girder) || istype(O, /obj/foamedmetal))
				qdel(O)
			if(istype(O, /obj/critter))
				O:CritterDeath()
			if(!isnull(O) && is_badmin_bus)
				O:ex_act(2)
			in_bump = 0
			return
	in_bump = 0
	return

/obj/vehicle/adminbus/bullet_act(flag, A as obj)
	return

/obj/vehicle/adminbus/meteorhit()
	return

/obj/vehicle/adminbus/disposing()
	if(rider)
		boutput(rider, "<span style=\"color:red\"><B>Your [src] is destroyed!</B></span>")
		eject_rider(1)
	..()
	return

/obj/vehicle/adminbus/ex_act(severity)
	return

/obj/vehicle/adminbus/eject_rider(var/crashed, var/selfdismount)
	rider.set_loc(src.loc)
	rider.remove_adminbus_powers()
	for(var/obj/ability_button/B in ability_buttons)
		rider.client.screen -= B
	walk(src, 0)
	if(crashed)
		if(crashed == 2)
			playsound(src.loc, "sound/misc/meteorimpact.ogg", 40, 1)
		playsound(src.loc, "shatter", 40, 1)
		boutput(rider, "<span style=\"color:red\"><B>You are flung through the [src]'s windshield!</B></span>")
		rider.stunned = 8
		rider.weakened = 5
		for (var/mob/C in AIviewers(src))
			if(C == rider)
				continue
			C.show_message("<span style=\"color:red\"><B>[rider] is flung through the [src]'s windshield!</B></span>", 1)
		var/turf/target = get_edge_target_turf(src, src.dir)
		rider.throw_at(target, 5, 1)
		rider.buckled = null
		rider = null
		icon_state = nonmoving_state
		if(prob(40) && src.contents.len)
			src.visible_message("<span style=\"color:red\"><B>Everything in the [src] flies out!</B></span>")
			for(var/atom/A in src.contents)
				if(ismob(A))
					var/mob/N = A
					N.show_message(text("<span style=\"color:red\"><B>You are flung out of the []!</B></span>", src), 1)
					N.set_loc(src.loc)
				else if (isobj(A))
					var/obj/O = A
					O.set_loc(src.loc)

		if(is_badmin_bus)
			toggle_darkness()
		return
	if(selfdismount)
		boutput(rider, "<span style=\"color:blue\">You climb out of the [src].</span>")
		if(is_badmin_bus)
			toggle_darkness()
		for (var/mob/C in AIviewers(src))
			if(C == rider)
				continue
			C.show_message("<B>[rider]</B> climbs out of the [src].", 1)
	rider.buckled = null
	rider = null
	icon_state = nonmoving_state
	return

/obj/vehicle/adminbus/attackby(var/obj/item/I, var/mob/user)
	if(!(user.client && user.client.holder))
		boutput(user, "<span style=\"color:blue\">You don't feel cool enough to use the [src].</span>")
		return

	var/obj/item/grab/G = I
	if(istype(G))	// handle grabbed mob
		if(ismob(G.affecting))
			var/mob/GM = G.affecting
			GM.set_loc(src)
			boutput(user, "<span style=\"color:blue\">You stuff [GM.name] into the back of the [src].</span>")
			boutput(GM, "<span style=\"color:red\"><B>[user] stuffs you into the back of the [src]!</B></span>")
			for (var/mob/C in AIviewers(src))
				if(C == user)
					continue
				C.show_message("<span style=\"color:red\"><B>[GM.name] has been stuffed into the back of the [src] by [user]!</B></span>", 3)
			qdel(G)
			return
	..()
	return

/obj/vehicle/adminbus/proc/do_darkness()
	if(prob(50))
		playsound(src.loc, 'sound/effects/ghost.ogg', 50, 1)
	else
		playsound(src.loc, 'sound/effects/ghost2.ogg', 50, 1)

	var/list/apcs = bounds(src, 192)
	for(var/obj/machinery/power/apc/apc in apcs)
		if(prob(60))
			apc.overload_lighting()

	if(prob(50))
		gibs(get_turf(src))

/obj/vehicle/adminbus/proc/toggle_darkness()
	if(src.darkness)
		qdel(src.darkness)
		src.name = "Admin Bus"
		src.desc = "A short yellow bus that looks reinforced."
		src.moving_state = "adminbus2"
		src.nonmoving_state = "adminbus"
		src.is_badmin_bus = 0
	else
		src.name = "Badmin Bus"
		src.desc = "A short bus painted in blood that looks horrifyingly evil."
		src.moving_state = "badminbus2"
		src.nonmoving_state = "badminbus"
		src.is_badmin_bus = 1
		src.darkness = new
		src.darkness.set_loc(src.loc)

/client/proc/toggle_gib_onhit()
	set category = "Adminbus"
	set name = "Toggle Gib On Collision"
	set desc = "Toggle gibbing when colliding with mobs."

	if(usr.stat)
		boutput(usr, "<span style=\"color:red\">Not when you are incapacitated.</span>")
		return
	if(istype(usr.loc, /obj/vehicle/adminbus))
		var/obj/vehicle/adminbus/bus = usr.loc
		if(bus.gib_onhit)
			bus.gib_onhit = 0
			boutput(usr, "<span style=\"color:red\">No longer gibbing on collision.</span>")
		else
			bus.gib_onhit = 1
			boutput(usr, "<span style=\"color:red\">You will now gib mobs on collision. Let's paint the town red!</span>")
	else
		boutput(usr, "<span style=\"color:red\">Uh-oh, you aren't in the adminbus! Report this.</span>")

/client/proc/toggle_dark_adminbus()
	set category = "Adminbus"
	set name = "Toggle The Darkness"
	set desc = "Activates a cloud of darkness that the adminbus emits. Spooky..."


	if(usr.stat)
		boutput(usr, "<span style=\"color:red\">Not when you are incapacitated.</span>")
		return
	if(istype(usr.loc, /obj/vehicle/adminbus))
		var/obj/vehicle/adminbus/bus = usr.loc
		bus.toggle_darkness()
	else
		boutput(usr, "<span style=\"color:red\">Uh-oh, you aren't in the adminbus! Report this.</span>")

/atom/movable/effect/darkness
	icon = 'icons/effects/64x64.dmi'
	icon_state = "spooky"
	layer = EFFECTS_LAYER_BASE
	mouse_opacity = 0
	//blend_mode = BLEND_MULTIPLY

	New()
		src.Scale(9,9)

/mob/proc/add_adminbus_powers()
	if(src.client.holder && src.client.holder.rank && src.client.holder.level >= LEVEL_PA)
		src.verbs += /client/proc/toggle_gib_onhit
		src.verbs += /client/proc/toggle_dark_adminbus
	return

/mob/proc/remove_adminbus_powers()
	src.verbs -= /client/proc/toggle_gib_onhit
	src.verbs -= /client/proc/toggle_dark_adminbus
	return

//////////////////////////////////////////////////////////////// Forklift //////////////////////////

/obj/vehicle/forklift
	name = "forklift"
	desc = "A vehicle used to transport crates."
	icon_state = "forklift"
	anchored = 1
	mats = 12
	var/list/helditems = list()	//Items being held by the forklift
	var/helditems_maximum = 3
	var/openpanel = 0			//1 when the back panel is opened
	var/broken = 0				//1 when the forklift is broken
	var/light = 0				//1 when the yellow light is on
	var/datum/light/actual_light
	soundproofing = 5
	throw_dropped_items_overboard = 1
	var/image/image_light = null
	var/image/image_panel = null
	var/image/image_crate = null
	var/image/image_under = null

/obj/vehicle/forklift/New()
	..()
	actual_light = new /datum/light/point
	actual_light.set_color(0.5, 0.5, 0.1)
	actual_light.set_brightness(0.5)
	actual_light.attach(src)

/obj/vehicle/forklift/examine()
	..()
	var/examine_text	//Shows who is driving it and also the items being carried
	var/obj/HI
	if(src.rider)
		examine_text += "[src.rider] is using it. "
	if(helditems.len >= 1)
		if (istype(helditems[1], /obj/))
			HI = helditems[1]
			examine_text += "It is carrying \a [HI.name]"
		if(helditems.len >= 2)
			for(var/i=2,i<=helditems.len-1,i++)
				if (istype(helditems[i], /obj/))
					HI = helditems[i]
					examine_text += ", [HI.name]"
			if (istype(helditems[helditems.len], /obj/))
				HI = helditems[helditems.len]
			examine_text += " and \a [HI.name]"
		examine_text += "."
	boutput(usr, "[examine_text]")
	return

/obj/vehicle/forklift/verb/enter_forklift()
	set src in oview(1)
	set category = "Local"

	if (usr.stat)
		return

	if(!istype(usr, /mob/living/carbon/human))
		return

	if (src.rider)
		if(src.rider == usr)
			boutput(usr, "You are already in [src]!")
			return
		boutput(usr, "[src.rider] is using [src]!")
		return

	//if successful
	var/mob/M = usr
	M.set_loc(src)
	src.rider = M
	boutput(usr, "You get into [src].")
	src.update_overlays()
	return

/obj/vehicle/forklift/verb/exit_forklift()
	set src in oview(1)
	set category = "Local"

	if (usr.stat)
		return

	if (usr.loc != src)
		boutput(usr, "You aren't in [src]!")
		return

	//if successful
	eject_rider()
	return

/obj/vehicle/forklift/Click()
	//Click the forklift when inside it to get out
	if(src.rider != usr)
		..()
		return

	if (usr.stat)
		return

	eject_rider()
	return

/obj/vehicle/forklift/eject_rider()
	if (!rider)
		return

	usr.set_loc(src.loc)
	src.rider = null
	boutput(usr, "You get out of [src].")

	//Stops items from being lost forever
	for (var/obj/item/I in src)
		if (I in helditems)
			continue
		I.set_loc(src.loc)

	for (var/mob/M in src)
		M.set_loc(src.loc)

	src.update_overlays()

/obj/vehicle/forklift/relaymove(mob/user as mob, direction)

	if (user.stat)
		return

	if (broken)
		return

	if (istype(src.loc, /turf/space))
		return

	//forklift movement
	if (direction == 1 || direction == 2 || direction == 4 || direction == 8)
		if(src.dir != direction)
			src.dir = direction
		walk(src, dir, 4)
	return

/obj/vehicle/forklift/verb/brake()
	set category = "Forklift"
	set src = usr.loc

	if (usr.stat)
		return

	if (istype(src.loc, /turf/space))
		return

	walk(src, 0)
	return

/obj/vehicle/forklift/verb/toggle_lights()
	set category = "Forklift"
	set src = usr.loc

	if (usr.stat)
		return

	if (broken)
		boutput(usr, "You try to turn on the lights. Nothing happens.")

	if (!light)
		light = 1
		update_overlays()
		actual_light.enable()
		return

	if (light)
		light = 0
		update_overlays()
		actual_light.disable()
	return

/obj/vehicle/forklift/MouseDrop_T(atom/movable/A as obj|mob, mob/user as mob)

	if (usr.stat)
		return

	//pick up crates with forklift
	if((istype(A, /obj/storage/crate) || istype(A, /obj/storage/cart)) && get_dist(A, src) <= 1 && src.rider == usr && helditems.len != helditems_maximum && !broken)
		A.loc = src
		helditems.Add(A)
		update_overlays()
		boutput(usr, "<span style=\"color:blue\"><B>You pick up the [A.name].</B></span>")
		for (var/mob/C in AIviewers(src))
			if(C == rider)
				continue
			C.show_message("<span style=\"color:blue\"><B>[src] picks up the [A.name].</B></span>", 1)
		return

	//Very funny
	if(istype(A, /obj/item/kitchen/utensil/fork))
		boutput(user, "You don't think [src] has enough utensil strength to pick this up.")
		return

	if(istype(A, /mob/living/carbon/human/) && get_dist(usr, src) <= 1  && get_dist(A, usr) <= 1 && !rider)
		if (A == usr)
			boutput(user, "You get into [src].")
		else
			boutput(user, "<span style=\"color:blue\">You help [A] onto [src]!</span>")
		A.set_loc(src)
		src.rider = A
		src.update_overlays()
		return

/obj/vehicle/forklift/attack_hand(mob/living/carbon/human/M as mob)
	if(!M || !rider)
		..()
		return
	switch(M.a_intent)
		if("harm", "disarm")
			if(prob(40))
				playsound(src.loc, "sound/weapons/thudswoosh.ogg", 50, 1, -1)
				src.visible_message("<span style=\"color:red\"><B>[M] has shoved [rider] off of [src]!</B></span>")
				rider.weakened = 2
				rider.set_loc(src.loc)
				src.rider = null
				src.update_overlays()
			else
				playsound(src.loc, "sound/weapons/punchmiss.ogg", 25, 1, -1)
				src.visible_message("<span style=\"color:red\"><B>[M] has attempted to shove [rider] off of [src]!</B></span>")
	return

/obj/vehicle/forklift/verb/drop_crates()
	set category = "Forklift"
	set src = usr.loc

	if (usr.stat)
		return

	if (istype(src.loc, /turf/space))
		return

	if(helditems.len >= 1)

		if(helditems.len == 1)
			var/obj/O = helditems[1]
			for (var/mob/C in AIviewers(src))
				C.show_message("<span style=\"color:blue\"><B>[src] leaves the [O.name] on [src.loc].</B></span>", 1)
			boutput(usr, "<span style=\"color:blue\"><B>You leave the [O.name] on [src.loc].</B></span>")
		if(helditems.len > 1)
			for (var/mob/C in AIviewers(src))
				C.show_message("<span style=\"color:blue\"><B>[src] leaves [helditems.len] crates on [src.loc].</B></span>", 1)
			boutput(usr, "<span style=\"color:blue\"><B>You leave [helditems.len] crates on [src.loc].</B></span>")

		for (var/obj/HI in helditems)
			HI.loc = src.loc

		helditems.len = 0
		update_overlays()
	return

obj/vehicle/forklift/attackby(var/obj/item/I, var/mob/user)
	//Use screwdriver to open/close the forklift's back panel
	if(istype(I,/obj/item/screwdriver))
		if (!openpanel)
			openpanel = 1
			boutput(usr, "You unlock [src]'s panel with [I].")
			update_overlays()
			return

		if (openpanel)
			openpanel = 0
			boutput(usr, "You lock [src]'s panel with [I].")
			update_overlays()
			return

	//Breaking the forklift
	if(istype(I,/obj/item/wirecutters))
		if (openpanel && !broken)
			boutput(usr, "<span style=\"color:blue\">You cut [src]'s wires!<span>")
			new /obj/item/cable_coil/cut/small( src.loc )
			break_forklift()
		return

	//Repairing the forklift
	if(istype(I,/obj/item/cable_coil))
		if (openpanel && broken)
			var/obj/item/cable_coil/coil = I
			coil.use(5)
			boutput(usr, "<span style=\"color:blue\">You replace [src]'s wires!</span>")
			broken = 0
			if (helditems_maximum < 4)
				helditems_maximum = 4
	return

/obj/vehicle/forklift/proc/break_forklift()
	broken = 1
	//break the light if it is on
	if (light)
		light = 0
		actual_light.disable()
		update_overlays()

/obj/vehicle/forklift/proc/update_overlays()
	if (light)
		if (!src.image_light)
			src.image_light = image(src.icon, "forklift_light")
		src.UpdateOverlays(src.image_light, "light")
	else
		src.UpdateOverlays(null, "light")
	if (openpanel)
		if (!src.image_panel)
			src.image_panel = image(src.icon, "forklift_panel")
		src.UpdateOverlays(src.image_panel, "panel")
	else
		src.UpdateOverlays(null, "panel")
	if (helditems.len > 0)
		if (!src.image_crate)
			src.image_crate = image(src.icon, "forklift_crate")
		for (var/i=0, i < helditems.len, i++)
			if (i <= 1)
				image_crate.icon_state = "forklift_crate"
			else if (i >= 2 && i <= 4)
				image_crate.icon_state = "forklift_crate[i]"
			else
				image_crate.icon_state = "forklift_crate4"
			image_crate.pixel_y = 7*i
			if (i >= 3)
				image_crate.pixel_x = rand(-1,1)
			src.UpdateOverlays(src.image_crate, "crate[i]")
	else
		for (var/i=0, i < src.helditems_maximum, i++)
			src.UpdateOverlays(null, "crate[i]")
	if (src.rider)
		src.icon_state = "forklift1"
		src.underlays += rider
		if (!src.image_under)
			src.image_under = image(src.icon, "forklift")
		src.underlays += src.image_under
	else
		src.icon_state = "forklift"
		src.underlays = null
