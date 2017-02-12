proc/explosion(atom/source, turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range)
	var/power = max(devastation_range+heavy_impact_range+0.25, 1)
	//boutput(world, "<span style=\"color:blue\">[devastation_range] [heavy_impact_range] [power]</span>")
	explosion_new(source, epicenter, (power*1.5)**2, max(light_impact_range/(power*1.5), 1))
	//boutput(world, "<span style=\"color:red\">[power]</span>")

proc/explosion_new(atom/source, turf/epicenter, power, brisance=1)
	var/distant_sound = 'sound/effects/explosionfar.ogg'

	if (!istype(epicenter, /turf))
		epicenter = get_turf(epicenter)

	if (!epicenter)
		return

	if(power > 10)
		if(!istype(get_area(epicenter), /area/colosseum)) //I do not give a flying FUCK about what goes on in the colosseum. =I
			// Cannot read null.name
			var/logmsg = "Explosion with power [power] (Source: [source ? "[source.name]" : "*unknown*"])  at [log_loc(epicenter)]. Source last touched by: [source ? "[source.fingerprintslast]" : "*null*"]"
			message_admins(logmsg)
			logTheThing("bombing", null, null, logmsg)
			logTheThing("diary", null, null, logmsg, "combat")

		if(big_explosions.len)
			distant_sound = pick(big_explosions)


	for(var/client/C)
		if(C.mob && (C.mob.z == epicenter.z))
			if(power > 15 && C.mob.z == 1 && epicenter.z == 1)
				shake_camera(C.mob, 8, 3) // remove if this is too laggy

			C << sound(distant_sound)

	playsound(epicenter.loc, "explosion", 100, 1, round(power, 1) )
	if(power > 10)
		var/datum/effects/system/explosion/E = new/datum/effects/system/explosion()
		E.set_up(epicenter)
		E.start()

	var/radius = round(sqrt(power), 1) * brisance

	var/last_touched
	if (source) // Cannot read null.fingerprintslast
		last_touched = source.fingerprintslast
	else
		last_touched = "*null*"

	spawn(0)
		var/list/nodes = list()
		var/list/open = list(epicenter)
		nodes[epicenter] = radius
		while (open.len)
			var/turf/T = open[1]
			open.Cut(1, 2)
			var/value = nodes[T] - 1 - T.explosion_resistance
			var/value2 = nodes[T] - 1.4 - T.explosion_resistance
			for (var/atom/A in T.contents)
				if (A.density/* && !A.CanPass(null, target)*/) // nothing actually used the CanPass check
					value -= A.explosion_resistance
					value2 -= A.explosion_resistance
			if (value < 0)
				continue
			for (var/dir in alldirs)
				var/turf/target = get_step(T, dir)
				if (!target) continue // woo edge of map
				var/new_value = dir & (dir-1) ? value2 : value
				if ((nodes[target] && nodes[target] >= new_value))
					continue
				nodes[target] = new_value
				open |= target

		defer_powernet_rebuild = 1
		defer_camnet_rebuild = 1
		defer_main_loops = 1
		RL_Suspend()
		radius += 1 // avoid a division by zero
		for (var/turf/T in nodes) // inverse square law (IMPORTANT) and pre-stun
			var/p = power / ((radius-nodes[T])**2)
			nodes[T] = p
			p = min(p, 10)
			for(var/mob/living/carbon/C in T)
				if (C.stat != 2 && C.client)
					shake_camera(C, 3 * p, p)
				C.stunned += p
				C.stuttering += p
				C.lying = 1
				C.set_clothing_icon_dirty()
		var/needrebuild = 0
		for (var/turf/T in nodes)
			var/p = nodes[T]
			//boutput(world, "P1 [p]")
			if (p >= 6)
				for (var/atom/A as obj|mob in T)
					A.ex_act(1, last_touched)
					if (istype(A, /obj/cable)) // these two are hacky, newcables should relieve the need for this
						needrebuild = 1
			else if (p >= 3)
				for (var/atom/A as obj|mob in T)
					A.ex_act(2, last_touched)
					if (istype(A, /obj/cable))
						needrebuild = 1
			else
				for (var/atom/A as obj|mob in T)
					A.ex_act(3, last_touched)
			sleep(-1)
		for (var/turf/T in nodes) // AFTER that ordeal (which may sleep quite a few times), fuck the turfs up all at once to prevent lag
			var/p = nodes[T]
			//boutput(world, "P2 [p]")
			if (p >= 6)
				T.ex_act(1, last_touched)
			else if (p >= 3)
				T.ex_act(2, last_touched)
			else
				T.ex_act(3, last_touched)

		defer_powernet_rebuild = 0
		defer_camnet_rebuild = 0
		defer_main_loops = 0
		RL_Resume()
		if (needrebuild)
			makepowernets()

		rebuild_camera_network()
