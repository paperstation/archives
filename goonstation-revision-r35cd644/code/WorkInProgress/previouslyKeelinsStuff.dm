//
// This file contains stuff that was originally made by me and then expanded on or butchered by other people.
// - Keelin
//

/proc/scaleatomall()
	var/scalex = input(usr,"X Scale","1 normal, 2 double etc","1") as num
	var/scaley = input(usr,"Y Scale","1 normal, 2 double etc","1") as num
	logTheThing("admin", usr, null, "scaled every goddamn atom by X:[scalex] Y:[scaley]")
	logTheThing("diary", usr, null, "scaled every goddamn atom by X:[scalex] Y:[scaley]", "admin")
	message_admins("[key_name(usr)] scaled every goddamn atom by X:[scalex] Y:[scaley]")
	for(var/atom/A in world)
		A.Scale(scalex,scaley)
	return

/proc/rotateatomall()
	var/rot = input(usr,"Rotation","Rotation","0") as num
	logTheThing("admin", usr, null, "rotated every goddamn atom by [rot] degrees")
	logTheThing("diary", usr, null, "rotated every goddamn atom by [rot] degrees", "admin")
	message_admins("[key_name(usr)] rotated every goddamn atom by [rot] degrees")
	for(var/atom/A in world)
		A.Turn(rot)
	return

/proc/scaleatom()
	var/atom/target = input(usr,"Target","Target") as mob|obj in world
	var/scalex = input(usr,"X Scale","1 normal, 2 double etc","1") as num
	var/scaley = input(usr,"Y Scale","1 normal, 2 double etc","1") as num
	logTheThing("admin", usr, null, "scaled [target] by X:[scalex] Y:[scaley]")
	logTheThing("diary", usr, null, "scaled [target] by X:[scalex] Y:[scaley]", "admin")
	message_admins("[key_name(usr)] scaled [target] by X:[scalex] Y:[scaley]")
	target.Scale(scalex, scaley)
	return

/proc/rotateatom()
	var/atom/target = input(usr,"Target","Target") as mob|obj in world
	var/rot = input(usr,"Rotation","Rotation","0") as num
	logTheThing("admin", usr, null, "rotated [target] by [rot] degrees")
	logTheThing("diary", usr, null, "rotated [target] by [rot] degrees", "admin")
	message_admins("[key_name(usr)] rotated [target] by [rot] degrees")
	target.Turn(rot)
	return

//proc/can_see(var/atom/source, var/atom/target, var/length=5)

/*
/verb/fuck_this_shit()
	set name = "Press this if the server is so badly fucked up that it will never recover or restart"
	set category = "Debug"
	//del(world)
	*/

/proc/is_null_or_space(var/input)
	if(input == " " || input == "" || isnull(input)) return 1
	else return 0

/proc/lolcat_parse(var/datum/text_roamer/R)
	var/new_string = ""
	var/used = 0

	switch(lowertext(R.curr_char))

		if("d")
			if( !is_null_or_space(R.prev_char) && lowertext(R.next_char) == "e" && is_null_or_space(R.next_next_char))
				new_string = "ded"
				used = 2

		if("a")
			if( is_null_or_space(R.prev_char) && lowertext(R.next_char) == "m" && is_null_or_space(R.next_next_char))
				new_string = "are"
				used = 2
			//else if(!is_null_or_space(R.prev_char) && lowertext(R.next_char) == "d" && lowertext(R.next_next_char) == "e")
			//	new_string = "aid"
			//	used = 3
			else if( !is_null_or_space(R.prev_char) && lowertext(R.next_char) == "y" && !is_null_or_space(R.next_next_char))
				new_string = "eh"
				used = 2
			else if(!is_null_or_space(R.prev_char) && lowertext(R.next_char) == "u" && !is_null_or_space(R.next_next_char))
				new_string = "oo"
				used = 2
			else if(is_null_or_space(R.prev_char) && lowertext(R.next_char) == "r" && lowertext(R.next_next_char) == "e" && is_null_or_space(R.next_next_next_char))
				new_string = "r"
				used = 3

		if("h")
			if(lowertext(R.next_char) == "a" && lowertext(R.next_next_char) == "v" && lowertext(R.next_next_next_char) == "e")
				new_string = "has"
				used = 4
			else if(is_null_or_space(R.prev_char) && lowertext(R.next_char) == "e" && is_null_or_space(R.next_next_char))
				new_string = "him"
				used = 2
			else if(is_null_or_space(R.prev_char) && lowertext(R.next_char) == "i" && lowertext(R.next_next_char) == "s" && is_null_or_space(R.next_next_next_char))
				new_string = "him"
				used = 3
			else if(lowertext(R.next_char) == "e" && lowertext(R.next_next_char) == "r" && lowertext(R.next_next_next_char) == "e")
				new_string = "ere"
				used = 4

		if("m")
			if(is_null_or_space(R.prev_char) && lowertext(R.next_char) == "e" && is_null_or_space(R.next_next_char))
				new_string = "i"
				used = 2

		if("g")
			if(!is_null_or_space(R.prev_char) && lowertext(R.next_char) == "h" && !is_null_or_space(R.next_next_char))
				new_string = ""
				used = 2

		if("n")
			if(!is_null_or_space(R.prev_char)&& lowertext(R.next_char) == "d" && lowertext(R.next_next_char) == "s" && is_null_or_space(R.next_next_char))
				new_string = "nz"
				used = 3
			else if(is_null_or_space(R.prev_char)&& lowertext(R.next_char) == "o" && is_null_or_space(R.next_next_char))
				new_string = "noes"
				used = 2

		if("t")
			if(!is_null_or_space(R.prev_char) && lowertext(R.next_char) == "i" && lowertext(R.next_next_char) == "o" && lowertext(R.next_next_next_char) == "n")
				new_string = "shun"
				used = 4
			else if(lowertext(R.next_char) == "h" && lowertext(R.next_next_char) == "e" && lowertext(R.next_next_next_char) == "y")
				new_string = "dem"
				used = 4
			else if(lowertext(R.next_char) == "h" && lowertext(R.next_next_char) == "e")
				new_string = "teh" //da
				used = 3
			else if(!is_null_or_space(R.prev_char)  && lowertext(R.next_char) == "l" && lowertext(R.next_next_char) == "e" && is_null_or_space(R.next_next_next_char))
				new_string = "tul"
				used = 3
			else if(!is_null_or_space(R.prev_char)  && lowertext(R.next_char) == "e" && is_null_or_space(R.next_next_char))
				new_string = "ted"
				used = 2
			else if(lowertext(R.next_char) == "h")
				new_string = pick("d","f")
				used = 2
			else if(!is_null_or_space(R.prev_char) && is_null_or_space(R.next_char))
				new_string = "te"
				used = 1

		if("q")
			new_string = "kw"
			used = 1

		if("o")
			if (!is_null_or_space(R.prev_char) && lowertext(R.next_char) == "u" && is_null_or_space(R.next_next_char))
				new_string = "o"
				used = 2
			if (!is_null_or_space(R.prev_char) && lowertext(R.next_char) == "u" && !is_null_or_space(R.next_next_char))
				new_string = "ow"
				used = 2
			else if (R.in_word() && lowertext(R.next_char) == "o")
				new_string = "u"
				used = 2
			else if (R.in_word())
				new_string = "u"
				used = 1
			else if (R.alone())
				new_string = "u"
				used = 1

		if("e")
			if (!is_null_or_space(R.prev_char) && lowertext(R.next_char) == "m" && is_null_or_space(R.next_next_char))
				new_string = "am"
				used = 2
			else if (!is_null_or_space(R.prev_char) && lowertext(R.next_char) == "n" && is_null_or_space(R.next_next_char))
				new_string = "un"
				used = 2
			else if (!is_null_or_space(R.prev_char) && lowertext(R.next_char) == "r" && is_null_or_space(R.next_next_char))
				new_string = pick("ah","ur")
				used = 2
			else if (!is_null_or_space(R.prev_char) && lowertext(R.next_char) == "l" && is_null_or_space(R.next_next_char))
				new_string = "ul"
				used = 2
			else if (!is_null_or_space(R.prev_char) && lowertext(R.next_char) == "n" && lowertext(R.next_next_char) == "t" && is_null_or_space(R.next_next_next_char))
				new_string = "unt"
				used = 3
			else if (!is_null_or_space(R.prev_char) && lowertext(R.next_char) == "d" && is_null_or_space(R.next_next_char))
				new_string = "eded"
				used = 2

		if("k")
			if(lowertext(R.next_char) == "n" && !is_null_or_space(R.next_next_char))
				new_string = "n"
				used = 2

		if("w")
			if(lowertext(R.next_char) == "h" && lowertext(R.next_next_char) == "y" && is_null_or_space(R.next_next_next_char))
				new_string = "y"
				used = 3

		if("y")
			if(is_null_or_space(R.prev_char) && lowertext(R.next_char) == "o" && lowertext(R.next_next_char) == "u")
				new_string = "u"
				used = 3
			else if(!is_null_or_space(R.prev_char) && is_null_or_space(R.next_char))
				new_string = "ai" //eh
				used = 1

		if("i")
			if(is_null_or_space(R.prev_char) && lowertext(R.next_char) == "m" && is_null_or_space(R.next_next_char))
				new_string = "iz"
				used = 2
			else if(is_null_or_space(R.prev_char) && lowertext(R.next_char) == "'" && lowertext(R.next_next_char) == "m" && is_null_or_space(R.next_next_next_char))
				new_string = "iz"
				used = 3
			else if(!is_null_or_space(R.prev_char) && lowertext(R.next_char) == "n" && lowertext(R.next_next_char) == "g" && is_null_or_space(R.next_next_next_char))
				new_string = "in"
				used = 3
			else if(!is_null_or_space(R.prev_char) && lowertext(R.next_char) == "t" && lowertext(R.next_next_char) == "e" && is_null_or_space(R.next_next_next_char))
				new_string = "iet"
				used = 3
			else if(!is_null_or_space(R.prev_char) && lowertext(R.next_char) == "o" && lowertext(R.next_next_char) == "u" && is_null_or_space(R.next_next_next_char))
				new_string = "u"
				used = 3

		if("s")
			if(!is_null_or_space(R.prev_char) && lowertext(R.next_char) == "s")
				new_string = "z"
				used = 2
			else if(!is_null_or_space(R.prev_char) && lowertext(R.next_char) == "h" && lowertext(R.next_next_char) == "e" && is_null_or_space(R.next_next_next_char))
				new_string = "her"
				used = 3
			else if(!is_null_or_space(R.prev_char) && is_null_or_space(R.next_char))
				new_string = "z"
				used = 1

		if("w")
			if(!is_null_or_space(R.prev_char) && lowertext(R.next_char) == "h" && !is_null_or_space(R.next_next_char))
				new_string = "w"
				used = 2

		if("u")
			if(R.in_word())
				new_string = "oo"
				used = 1

	if(new_string == "")
		new_string = R.curr_char
		used = 1

	var/datum/parse_result/P = new/datum/parse_result
	P.string = uppertext(new_string)
	P.chars_used = used
	return P

/proc/lolcat(var/string)
	var/modded = ""
	var/datum/text_roamer/T = new/datum/text_roamer(string)

	for(var/i = 0, i < length(string), i=i)
		var/datum/parse_result/P = lolcat_parse(T)
		modded += P.string
		i += P.chars_used
		T.curr_char_pos = T.curr_char_pos + P.chars_used
		T.update()

	if(prob(16))
		switch(pick(1,2))
			if(1)
				modded += " SRSLY"
			if(2)
				modded += " LUL"

	return modded

/*/area/forest
	name = "Strange Forest"
	icon_state = "null"
	luminosity = 1
	RL_Lighting = 0
	requires_power = 0

/area/forest/entrance
	name = "Strange Forest - Entrance"
	icon_state = "null"
	luminosity = 1
	RL_Lighting = 0
	requires_power = 0*/


var/reverse_mode = 0

/proc/reverse_text(var/string)
	var/new_string=""
	for(var/i=lentext(string)+1, i>0, i--)
		new_string += copytext(string,i,i+1)
	return new_string

/proc/reverse()
	reverse_mode = !reverse_mode
	for(var/atom/A)
		A.name = reverse_text(A.name)
		if(hasvar(A,"real_name")) A:real_name = reverse_text(A:real_name)
		if(hasvar(A,"registered")) A:registered = reverse_text(A:registered)

/proc/circlerange(center=usr,radius=3)

	var/turf/centerturf = get_turf(center)
	var/list/turfs = new/list()
	var/rsq = radius * (radius+0.5)

	for(var/atom/T in range(radius, centerturf))
		var/dx = T.x - centerturf.x
		var/dy = T.y - centerturf.y
		if(dx*dx + dy*dy <= rsq)
			turfs += T

	//turfs += centerturf
	return turfs

/proc/circleview(center=usr,radius=3)

	var/turf/centerturf = get_turf(center)
	var/list/turfs = new/list()
	var/rsq = radius * (radius+0.5)

	for(var/atom/T in view(radius, centerturf))
		var/dx = T.x - centerturf.x
		var/dy = T.y - centerturf.y
		if(dx*dx + dy*dy <= rsq)
			turfs += T

	//turfs += centerturf
	return turfs

/proc/fireflash_sm(atom/center, radius, temp, falloff, capped = 1, bypass_RNG = 0)
	var/list/affected = fireflash_s(center, radius, temp, falloff)
	for (var/turf/T in affected)
		if (istype(T, /turf/simulated))
			var/mytemp = affected[T]
			var/melt = 1643.15 // default steel melting point
			if (T.material && T.material.hasProperty(PROP_MELTING))
				melt = T.material.getProperty(PROP_MELTING)
			var/divisor = melt
			if (mytemp >= melt * 2)
				var/chance = mytemp / divisor
				if (capped)
					chance = min(chance, T:default_melt_cap)
				if (prob(chance) || bypass_RNG) // The bypass is for thermite (Convair880).
					T.visible_message("<span style=\"color:red\">[T] melts!</span>")
					T.burn_down()
	return affected

/proc/ff_cansee(var/atom/A, var/atom/B)
	var/AT = get_turf(A)
	var/BT = get_turf(B)
	if (AT == BT)
		return 1
	var/list/line = getline(A,B)
	for (var/turf/T in line)
		if (T == AT || T == BT)
			break
		if (T.density)
			return 0
		var/obj/blob/BL = locate() in T
		if (istype(BL, /obj/blob/wall) || istype(BL, /obj/blob/firewall) || istype(BL, /obj/blob/reflective))
			return 0
	return 1

/proc/fireflash_s(atom/center, radius, temp, falloff)
	if (locate(/obj/blob/firewall) in center)
		return list()
	if (temp < T0C + 60)
		return list()
	var/list/open = list()
	var/list/affected = list()
	var/list/closed = list()
	var/list/hotspots = list()
	var/turf/Ce = get_turf(center)
	var/max_dist = radius
	if (falloff)
		max_dist = min((temp - (T0C + 60)) / falloff, radius)
	open[Ce] = 0
	while (open.len)
		var/turf/T = open[1]
		var/dist = open[T]
		open -= T
		closed += T

		if (istype(T, /turf/space))
			continue
		if (dist > max_dist)
			continue
		if (!ff_cansee(Ce, T))
			continue

		var/obj/hotspot/existing_hotspot = locate(/obj/hotspot) in T
		var/prev_temp = 0
		var/need_expose = 0
		var/expose_temp = 0
		if (!existing_hotspot)
			var/obj/hotspot/h = unpool(/obj/hotspot)
			need_expose = 1
			h.temperature = temp - dist * falloff
			expose_temp = h.temperature
			h.volume = 400
			h.set_loc(T)
			T.active_hotspot = h
			hotspots += h
			existing_hotspot = h
		else if (existing_hotspot.temperature < temp - dist * falloff)
			expose_temp = (temp - dist * falloff) - existing_hotspot.temperature
			prev_temp = existing_hotspot.temperature
			if (expose_temp > prev_temp * 3)
				need_expose = 1
			existing_hotspot.temperature = temp - dist * falloff

		affected[T] = existing_hotspot.temperature
		if (need_expose && expose_temp)
			T.hotspot_expose(expose_temp, existing_hotspot.volume)
			if (T == ff_debug_turf && ff_debugger)
				boutput(ff_debugger, "<span style='color:#ff8800'>Fireflash affecting tile at [showCoords(T.x, T.y, T.z)], exposing to temperature [expose_temp], central tile is at [showCoords(Ce.x, Ce.y, Ce.z)], previous temperature: [prev_temp]</span>")
		if(istype(T, /turf/simulated/floor)) T:burn_tile()
		for (var/mob/living/L in T)
			L.update_burning(min(55, max(0, expose_temp - 100 / 550)))
			L.bodytemperature = (2 * L.bodytemperature + temp) / 3
		spawn(0)
			for (var/obj/critter/C in T)
				C.health -= (30 * C.firevuln)
				C.check_health()

		if (T.density)
			continue
		for (var/obj/O in T)
			if (O.density)
				continue
		if (dist == max_dist)
			continue

		for (var/dir in cardinal)
			var/turf/link = get_step(T, dir)
			if (!link)
				continue
			var/dx = link.x - Ce.x
			var/dy = link.y - Ce.y
			var/target_dist = max((dist + 1 + sqrt(dx * dx + dy * dy)) / 2, dist)
			if (!(link in closed))
				if (link in open)
					if (open[link] > target_dist)
						open[link] = target_dist
				else
					open[link] = target_dist

	spawn(1) // dumb lighting hotfix
		for(var/obj/hotspot/A in hotspots)
			A.set_real_color() // enable light

	spawn(30)
		for(var/obj/hotspot/A in hotspots)
			if (!A.disposed)
				pool(A)
		hotspots.len = 0

	return affected


/proc/fireflash(atom/center, radius)
	tfireflash(center, radius, rand(2800,3200))

/proc/tfireflash(atom/center, radius, temp)
	if (locate(/obj/blob/firewall) in center)
		return
	var/list/hotspots = new/list()
	for(var/turf/T in range(radius,get_turf(center)))
		if(istype(T, /turf/space)) continue
		if(locate(/obj/hotspot) in T) continue
		if(!can_line(get_turf(center), T, radius+1)) continue
		for(var/obj/spacevine/V in T) qdel(V)
//		for(var/obj/alien/weeds/V in T) qdel(V)

		var/obj/hotspot/h = unpool(/obj/hotspot)
		h.temperature = temp
		h.volume = 400
		h.set_real_color()
		h.set_loc(T)
		T.active_hotspot = h
		hotspots += h

		T.hotspot_expose(h.temperature, h.volume)
		//spawn(15) T.hotspot_expose(2000, 400)

		if(istype(T, /turf/simulated/floor)) T:burn_tile()
		spawn(0)
			for(var/mob/living/L in T)
				L.set_burning(55)
				L.bodytemperature = max(temp/3, L.bodytemperature)
			for(var/obj/critter/C in T)
				if(istype(C, "/obj/critter/zombie")) C.health -= 15
				C.health -= (30 * C.firevuln)
				C.check_health()
				spawn(5)
					if(C)
						C.health -= (2 * C.firevuln)
						C.check_health()
					sleep(5)
					if(C)
						C.health -= (2 * C.firevuln)
						C.check_health()
					sleep(5)
					if(C)
						C.health -= (2 * C.firevuln)
						C.check_health()
					sleep(5)
					if(C)
						C.health -= (2 * C.firevuln)
						C.check_health()
					sleep(5)
					if(C)
						C.health -= (2 * C.firevuln)
						C.check_health()
					sleep(5)
					if(C)
						C.health -= (2 * C.firevuln)
						C.check_health()
	/*
	// Take that, you flaming bastards
	if(istype(center, /obj) || istype(center, /mob))
		var/message = "<b>A [pick("burst", "gout", "pillar", "column")] of flame bursts from"
		if(istype(center, /obj))
			message += " the"
		message += " [center]"
		for(var/mob/living/L in range(2,get_turf(center)))
			if(center.fingerprintslast == L.key)
				L.visible_message("[message], striking you squarely in the [pick("face", "chest", "groin")]! It burns!</b>")
				if(prob(10))
					L.ex_act(2.0)
				else
					L.ex_act(3.0)
			else
				L.visible_message("[message]!</b>")
		center.ex_act(2.0)
		*/
	spawn(30)
		for(var/obj/hotspot/A in hotspots)
			if (!A.disposed)
				pool(A)
		hotspots.len = 0

/obj/item/relic
	icon = 'icons/misc/hstation.dmi'
	icon_state = "relic"
	name = "strange relic"
	desc = "It feels cold..."
	var/active = 0
	var/using = 0
	var/beingUsed = 0

	New()
		loop()
		return

	proc/loop()
		if(!active)
			spawn(10) loop()
			return

		if(prob(1) && prob(50) && ismob(src.loc))
			var/mob/M = src.loc
			boutput(M, "<span style=\"color:red\">You feel uneasy ...</span>")

		if(prob(25))
			for(var/obj/machinery/light/L in range(6, get_turf(src)))
				if(prob(25)) L.broken()

		if(prob(1) && prob(50) && !using)
			new/obj/critter/spirit( get_turf(src) )

		if(prob(3) && prob(50))
			var/obj/o = new/obj/spook( get_turf(src) )
			spawn(600) qdel(o)

		if(prob(25))
			for(var/obj/storage/L in range(6, get_turf(src)))
				if(prob(45))
					L.toggle()

		if(prob(25))
			for(var/obj/stool/chair/L in range(6, get_turf(src)))
				if(prob(15)) L.rotate()

		spawn(10) loop()
		return

	pickup(var/mob/living/M)
		spawn(600) active = 1

	attack_self(var/mob/user)
		if(user != loc)
			return
		if(using)
			boutput(user, "<span style=\"color:red\">The relic is humming loudly.</span>")
			return
		else
			if(!beingUsed) //I guess you could use this thing in-hand a lot and gain its powers repeatedly!
				beingUsed = 1
				switch( input(user,"What now?","???") in list("Let the relics power flow through you", "Bend the relics power to your will", "Use the relics power to heal your wounds" ,"Attempt to absorb the relics power"))
					if("Let the relics power flow through you")
						using = 1
						var/turf/T = get_turf(src)
						if (isrestrictedz(T.z))
							user.gib()
						else
							user.shock(src, rand(5000, 250000), "chest", 1, 1)
						/*harmless_smoke_puff(get_turf(src))
						playsound(user, "sound/effects/ghost2.ogg", 60, 0)
						user.flash(60)
						var/mob/oldmob = user
						var/mob/dead/observer/O = new/mob/dead/observer()
						O.set_loc(get_turf(src))
						oldmob.sleeping = 1
						oldmob.weakened = 600
						var/datum/mind/M = user.mind
						if(M) //Why would this happen? Why wouldn't it happen?
							M.transfer_to(O)
							spawn(600)
								if(M && oldmob)
									var/mob/newmob = M.current
									M.transfer_to(oldmob)
									qdel(newmob)
									oldmob.paralysis += 3
									oldmob.sleeping = 0
									oldmob.weakened = 0

								using = 0*/
					if("Bend the relics power to your will")
						using = 1
						boutput(user, "<span style=\"color:red\">You can feel the power of the relic coursing through you...</span>")
						user:TakeDamage("chest", 0, 50)
						user.bioHolder.AddEffect("telekinesis")
						spawn(1200)
							using = 0
							user.bioHolder.RemoveEffect("telekinesis")
					if("Use the relics power to heal your wounds")
						var/obj/shield/s = new/obj/shield( get_turf(src) )
						s.name = "energy"
						spawn(13) qdel(s)
						user:stunned = 10
						user.take_toxin_damage(-INFINITY)
						user:HealDamage("All", 1000, 1000)
						if(prob(75))
							boutput(user, "<span style=\"color:red\">The relic crumbles into nothingness</span>")
							qdel(src)
						spawn(600) using = 0
					if("Attempt to absorb the relics power")
						if(prob(1))
							user.bioHolder.AddEffect("telekinesis")
							user.bioHolder.AddEffect("thermal_resist")
							user.bioHolder.AddEffect("xray")
							user.bioHolder.AddEffect("hulk")
							boutput(user, "<span style=\"color:red\">The relic crumbles into nothingness</span>")
							src.invisibility = 101
							var/obj/effects/explosion/E = new/obj/effects/explosion( get_turf(src) )
							E.fingerprintslast = src.fingerprintslast
							sleep(5)
							E = new/obj/effects/explosion( get_turf(src) )
							E.fingerprintslast = src.fingerprintslast
							sleep(5)
							E = new/obj/effects/explosion( get_turf(src) )
							E.fingerprintslast = src.fingerprintslast
							qdel(src)
						else
							switch(pick(175;1,30;2,25;3,85;4))
								if(1)
									boutput(user, "<span style=\"color:red\">The relics power overwhelms you.</span>")
									user:weakened += 10
									user:TakeDamage("chest", 0, 33)
								if(2)
									boutput(user, "<span style=\"color:red\">The relic explodes in a bright flash, blinding you.</span>")
									user.flash(60)
									user:bioHolder.AddEffect("blind")
									qdel(src)
								if(3)
									boutput(user, "<span style=\"color:red\">The relic explodes violently.</span>")
									var/obj/effects/explosion/E = new/obj/effects/explosion( get_turf(src) )
									E.fingerprintslast = src.fingerprintslast
									user:gib()
									qdel(src)
								if(4)
									boutput(user, "<span style=\"color:red\">The relics power completely overwhelms you.</span>")
									using = 1
									harmless_smoke_puff( get_turf(src) )
									playsound(user, "sound/effects/ghost2.ogg", 60, 0)
									user.flash(60)
									var/mob/oldmob = user
									oldmob.ghostize()
									oldmob.death()
									using = 0
				beingUsed = 0


/obj/effect_sparker
	icon = 'icons/misc/mark.dmi'
	icon_state = "x4"
	invisibility = 101
	anchored = 1
	density = 0

	New()
		src.sparks()
		return ..()

	proc/sparks()
		var/area/A = get_area(src)
		if (A.active)
			var/datum/effects/system/spark_spread/E = unpool(/datum/effects/system/spark_spread)
			E.set_up(3,0,get_turf(src))
			E.start()
		spawn(rand(10,300))
			src.sparks()

/obj/creepy_sound_trigger
	icon = 'icons/misc/mark.dmi'
	icon_state = "ydn"
	invisibility = 101
	anchored = 1
	density = 0
	var/active = 0
	HasEntered(atom/movable/AM as mob|obj)
		if(active) return
		if(ismob(AM))
			if(AM:client)
				if(prob(75))
					active = 1
					spawn(600) active = 0
					playsound(get_turf(AM), pick('sound/ambience/ambimo1.ogg','sound/ambience/ambimo2.ogg'), 75, 0)

// cogwerks- variant for glaciers

/obj/creepy_sound_trigger_glacier
	icon = 'icons/misc/mark.dmi'
	icon_state = "ydn"
	invisibility = 101
	anchored = 1
	density = 0
	var/active = 0
	HasEntered(atom/movable/AM as mob|obj)
		if(active) return
		if(ismob(AM))
			if(AM:client)
				if(prob(75))
					active = 1
					spawn(600) active = 0
					if(prob(10))
						playsound(get_turf(AM), pick('sound/misc/wendigo_scream.ogg', 'sound/misc/wendigo_cry.ogg'),25, 1) // play these quietly so as to spook
					else
						playsound(get_turf(AM), pick('sound/ambience/glacier1.ogg','sound/ambience/glacier2.ogg', 'sound/ambience/glacier3.ogg', 'sound/ambience/glacier4.ogg', 'sound/ambience/glacier5.ogg', 'sound/ambience/glacier6.ogg'), 75, 0)
////////////
/proc/set_on_all()
	var/type = input(usr, "Typepath:")
	type = text2path(type)
	if(!type) return

	var/varname = input(usr, "Varname:")
	var/thetype = input(usr,"Select variable type:" ,"Type") in list("text","number","mob-reference","obj-reference","turf-reference","icon","random-number","random-color")
	if(!thetype) return

	var/thevalue = null
	var/minrnd = null
	var/maxrnd = null
	var/is_icon = 0
	switch(thetype)
		if("text")
			thevalue = input(usr,"Enter variable value:" ,"Value", "value") as text
		if("number")
			thevalue = input(usr,"Enter variable value:" ,"Value", 123) as num
		if("mob-reference")
			thevalue = input(usr,"Enter variable value:" ,"Value") as mob in world
		if("obj-reference")
			thevalue = input(usr,"Enter variable value:" ,"Value") as obj in world
		if("turf-reference")
			thevalue = input(usr,"Enter variable value:" ,"Value") as turf in world
		if("icon")
			thevalue = input(usr,"Select icon:" ,"Value") as icon
			is_icon = 1
		if("random-number")
			minrnd = input(usr,"Min:" ,"Value", 0) as num
			maxrnd = input(usr,"Max:" ,"Value", 0) as num
			thevalue = 1
		if("random-color")
			thevalue = rgb(rand(0,255),rand(0,255),rand(0,255))

	if(thevalue == null && !is_icon) return

	var/oldVal = null

	if(ispath(type, /client))
		for(var/client/C)
			if(minrnd != null || maxrnd != null)
				C.vars[varname] = rand(minrnd,maxrnd)
			else
				C.vars[varname] = thevalue
		return

	for(var/datum/A in world)
		if(!istype(A,type)) continue
		oldVal = A.vars[varname]
		if(minrnd != null || maxrnd != null)
			A.vars[varname] = rand(minrnd,maxrnd)
		else
			A.vars[varname] = thevalue
		A.onVarChanged(varname, oldVal, A.vars[varname])
		if(thetype == "random-color")
			thevalue = rgb(rand(0,255),rand(0,255),rand(0,255))
		sleep(1)
/*
	if(minrnd != null || maxrnd != null)
		logTheThing("admin", usr, null, "randomized all [type]s [varname] from [minrnd] to [maxrnd].")
		logTheThing("diary", usr, null, "randomized all [type]s [varname] from [minrnd] to [maxrnd].", "admin")
		message_admins("[key_name(usr)] randomized all [type]s [varname] from [minrnd] to [maxrnd].")
	else
		logTheThing("admin", usr, null, "modified all [type]s [varname] to [thevalue].")
		logTheThing("diary", usr, null, "modified all [type]s [varname] to [thevalue].", "admin")
		message_admins("[key_name(usr)] modified all [type]s [varname] to [thevalue].")
*/
	return

/proc/testa()
	fake_attack(usr)

/proc/testb()
	fake_attack(input(usr) as mob in world)

/obj/fake_attacker
	icon = null
	icon_state = null
	name = ""
	desc = ""
	density = 0
	anchored = 1
	opacity = 0
	var/mob/living/carbon/human/my_target = null
	var/weapon_name = null

/obj/fake_attacker/attackby()
	step_away(src,my_target,2)
	for(var/mob/M in oviewers(world.view,my_target))
		boutput(M, "<span style=\"color:red\"><B>[my_target] flails around wildly.</B></span>")
	my_target.show_message("<span style=\"color:red\"><B>[src] has been attacked by [my_target] </B></span>", 1) //Lazy.
	return

/obj/fake_attacker/HasEntered(var/mob/M, somenumber)
	if(M == my_target)
		step_away(src,my_target,2)
		if(prob(30))
			for(var/mob/O in oviewers(world.view , my_target))
				boutput(O, "<span style=\"color:red\"><B>[my_target] stumbles around.</B></span>")

/obj/fake_attacker/New(location, target)
	spawn(300)	qdel(src)
	src.my_target = target
	step_away(src,my_target,2)
	process()

/obj/fake_attacker/proc/process()
	if(!my_target)
		qdel(src)
		return
	if(get_dist(src,my_target) > 1)
		step_towards(src,my_target)
	else
		if(prob(15))
			if(weapon_name)
				if (narrator_mode)
					my_target << sound('sound/vox/weapon.ogg')
				else
					my_target << sound(pick('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg'))
				my_target.show_message("<span style=\"color:red\"><B>[my_target] has been attacked with [weapon_name] by [src.name] </B></span>", 1)
				if(prob(20)) my_target.change_eye_blurry(3)
				if(prob(33))
					if(!locate(/obj/overlay) in my_target.loc)
						fake_blood(my_target)
			else
				if (narrator_mode)
					my_target << sound('sound/vox/hit.ogg')
				else
					my_target << sound(pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg'))
				my_target.show_message("<span style=\"color:red\"><B>[src.name] has punched [my_target]!</B></span>", 1)
				if(prob(33))
					if(!locate(/obj/overlay) in my_target.loc)
						fake_blood(my_target)

	if(prob(15)) step_away(src,my_target,2)
	spawn(5) .()

/proc/fake_blood(var/mob/target)
	var/obj/overlay/O = new/obj/overlay(target.loc)
	O.name = "blood"
	var/image/I = image('icons/effects/blood.dmi',O,"floor[rand(1,7)]",O.dir,1)
	target << I
	spawn(300)
		qdel(O)
	return

/proc/fake_attack(var/mob/target)
	var/list/possible_clones = new/list()
	var/mob/living/carbon/human/clone = null
	var/clone_weapon = null

	for(var/mob/living/carbon/human/H in mobs)
		if(H.stat || H.lying || H.dir == NORTH) continue
		possible_clones += H

	if(!possible_clones.len) return
	clone = pick(possible_clones)

	if(clone.l_hand)
		clone_weapon = clone.l_hand.name
	else if (clone.r_hand)
		clone_weapon = clone.r_hand.name

	var/obj/fake_attacker/F = new/obj/fake_attacker(target.loc, target)

	F.name = clone.name
	//F.my_target = target
	F.weapon_name = clone_weapon

	var/image/O = image(clone,F)
	target << O

//Same as the thing below just for density and without support for atoms.
/proc/can_line(var/atom/source, var/atom/target, var/length=5)
	var/turf/current = get_turf(source)
	var/turf/target_turf = get_turf(target)
	var/steps = 0

	while(current != target_turf)
		if(steps > length) return 0
		if(!current) return 0
		if(current.density) return 0
		//for(var/atom/A in current)
		//	if(A.density) return 0
		current = get_step_towards(current, target_turf)
		steps++

	return 1



