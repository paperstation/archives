/proc/roundTZ(var/i)
	if (i < 0)
		return -round(-i)
	return round(i)

/proc/angleToDir(var/angle)
	if (angle >= 360)
		return angleToDir(angle-360)
	else if (angle < 0)
		return angleToDir(angle+360)
	else
		if (angle < 22.5 || angle >= 337.5)
			return NORTH
		else if (angle < 67.5)
			return NORTHWEST
		else if (angle < 112.5)
			return WEST
		else if (angle < 157.5)
			return SOUTHWEST
		else if (angle < 202.5)
			return SOUTH
		else if (angle < 247.5)
			return SOUTHEAST
		else if (angle < 292.5)
			return EAST
		else
			return NORTHEAST

/obj/projectile
	name = "projectile"
	flags = TABLEPASS
	var/xo
	var/yo

	// I have no idea what to do with these.
	var/target = null
	var/datum/projectile/proj_data = null
	//var/obj/o_shooter = null
	var/list/targets = list()
	var/dissipation_ticker = 0 // moved this from the datum because why the hell was it on there
	var/power = 20 // local copy of power for proper dissipation tracking
	var/implanted = null
	var/forensic_ID = null
	var/atom/shooter = null // Who/what fired this?
	var/mob/mob_shooter = null
	// We use shooter to avoid self collision, however, the shot may have been initiated through a proxy object. This is for logging.
	var/travelled = 0 // track distance
	var/angle // for reference @see setup()
	animate_movement = 0
	var/turf/orig_turf
	var/datum/light/light

	var/data = 0
	var/was_pointblank = 0 // Adjusts the log entry accordingly.

	var/was_setup = 0
	var/far_border_hit

	var/incidence = 0 // reflection normal on the current tile (NORTH if projectile came from the north, etc.)
	var/list/crossing = list()
	var/list/special_data = list()
	var/curr_t = 0

	var/wx = 0
	var/wy = 0

	proc/rotateDirection(var/angle)
		var/oldxo = xo
		var/oldyo = yo
		var/sa = sin(angle)
		var/ca = cos(angle)
		xo = ca * oldxo - sa * oldyo
		yo = sa * oldxo + ca * oldyo
		src.Turn(-angle)

	proc/launch()
		proj_data.on_launch(src)
		if (!disposed)
			spawn(0)
				process()

	proc/process()
		if (!src.was_setup)
			src.setup()

		while (!disposed)
			do_step()
			sleep(1)

	proc/collide(atom/A as mob|obj|turf|area)
		if (!A)
			// you never know ok??
			return
		if (disposed)
			// if disposed is set to true we have been pooled or set for garbage collection and shouldn't process bumps
			return
		if (A == shooter)
			// never collide with the original shooter
			return

		// Necessary because the check in human.dm is ineffective (Convair880).
		var/immunity = check_target_immunity(A)
		if (immunity)
			log_shot(src, A, 1)
			A.visible_message("<b><span style=\"color:red\">The projectile bounces off of [A] uselessly!</span></b>")
			die()
			return

		// Unified check instead of a separate one in every mob type's bullet_act() (Convair880).
		if (ismob(A))
			for (var/obj/item/cloaking_device/S in A.contents)
				if (S.active)
					S.deactivate(A)
					src.visible_message("<span style=\"color:blue\"><b>[A]'s cloak is disrupted!</b></span>")
			for (var/obj/item/device/disguiser/D in A.contents)
				if (D.on)
					D.disrupt(A)
					src.visible_message("<span style=\"color:blue\"><b>[A]'s disguiser is disrupted!</b></span>")

		// also run the atom's general bullet act
		var/atom/B = A.bullet_act(src) //If bullet_act returns an atom, do all bad stuff to that atom instead
		if(istype(B))
			A = B


		// if we made it this far this is a valid bump, run the specific projectile's hit code
		proj_data.on_hit(A, src.angle, src)

		//Trigger material on attack.
		if(proj_data.material)
			proj_data.material.triggerOnAttack(src, src.shooter, A)



		if (istype(A,/turf))
			// if we hit a turf apparently the bullet is magical and hits every single object in the tile, nice shooting tex
			for (var/obj/O in A)
				O.bullet_act(src)
			if (istype(A, /turf/simulated/wall) && proj_data.icon_turf_hit)
				var/turf/simulated/wall/W = A
				if (src.forensic_ID)
					W.forensic_impacts += src.forensic_ID
				var/image/impact = image('icons/obj/projectiles.dmi', proj_data.icon_turf_hit)
				impact.transform = turn(impact.transform, pick(0, 90, 180, 270))
				impact.pixel_x += rand(-12,12)
				impact.pixel_y += rand(-12,12)
				W.proj_impacts += impact
				W.update_projectile_image(ticker.round_elapsed_ticks)

		die() // pool the projectile

	pooled()
		name = "projectile"
		xo = 0
		yo = 0
		pixel_x = 0
		pixel_y = 0
		power = 0
		dissipation_ticker = 0
		travelled = 0
		target = null
		proj_data = null
		//o_shooter = null
		shooter = null
		mob_shooter = null
		implanted = null
		forensic_ID = null
		targets = null
		angle = 0
		was_setup = 0
		was_pointblank = 0
		data = 0
		crossing.len = 0
		curr_t = 0
		wx = 0
		wy = 0
		color = null
		special_data.len = 0
		overlays = null
		transform = null
		removeMaterial()
		..()

	proc/die()
		if (proj_data)
			proj_data.on_end(src)
		if (src.light)
			src.light.disable()
		pool(src)

	proc/set_icon()
		if(istype(proj_data))
			src.icon = proj_data.icon
			src.icon_state = proj_data.icon_state
			if (!proj_data.override_color)
				src.color = proj_data.color_icon
		else
			src.icon = 'icons/obj/projectiles.dmi'
			src.icon_state = null
			if (!proj_data.override_color)
				src.color = "#ffffff"

	proc/setup()
		if (src.proj_data == null || (xo == 0 && yo == 0) || proj_data.projectile_speed == 0)
			die()
			return

		name = src.proj_data.name
		set_icon()
		orig_turf = get_turf(src)

		var/len = sqrt(src.xo * src.xo + src.yo * src.yo)

		if (len == 0)
			die()
		src.xo = src.xo / len
		src.yo = src.yo / len

		if (src.yo == 0)
			if (src.xo < 0)
				src.angle = 90
			else
				src.angle = 270
		else if (src.xo == 0)
			if (src.yo < 0)
				src.angle = 180
			else
				src.angle = 0
		else
			var/r = 1
			src.angle = arccos(src.yo / r)
			var/anglecheck = arcsin(-src.xo / r)
			if (anglecheck < 0)
				src.angle = -src.angle
		transform = null
		Turn(-angle)
		if (!proj_data.precalculated)
			return

		var/x32 = 0
		var/xs = 1
		var/y32 = 0
		var/ys = 1
		if (xo)
			x32 = 32 / (proj_data.projectile_speed * xo)
			if (x32 < 0)
				xs = -1
				x32 = -x32
		if (yo)
			y32 = 32 / (proj_data.projectile_speed * yo)
			if (y32 < 0)
				ys = -1
				y32 = -y32
		var/max_t
		if (proj_data.dissipation_rate)
			max_t = proj_data.dissipation_delay + round(proj_data.power / proj_data.dissipation_rate) + 1
		else
			max_t = 500 // why not
		var/next_x = x32 / 2
		var/next_y = y32 / 2
		var/ct = 0
		var/turf/T = get_turf(src)
		var/cx = T.x
		var/cy = T.y
		while (ct < max_t)
			if (next_x == 0 && next_y == 0)
				break
			if (next_x == 0 || (next_y != 0 && next_y < next_x))
				ct = next_y
				next_y = ct + y32
				cy += ys
			else
				ct = next_x
				next_x = ct + x32
				cx += xs
			var/turf/Q = locate(cx, cy, T.z)
			if (!Q)
				break
			crossing += Q
			crossing[Q] = ct

		curr_t = 0
		src.was_setup = 1

	Bump(var/atom/A)
		src.collide(A)

	Crossed(var/atom/movable/A)
		if (!istype(A))
			return // can't happen will happen
		if (!A.CanPass(src, get_step(src, A.dir), 1, 0))
			src.collide(A)

	proc/do_step()
		if (!loc)
			die()
			return
		src.dissipation_ticker++

		// The bullet has expired/decayed.
		if (src.dissipation_ticker > src.proj_data.dissipation_delay)
			src.power -= src.proj_data.dissipation_rate
			if (src.power <= 0)
				die()
				return
		proj_data.tick(src)
		if (disposed)
			return

		var/turf/curr_turf = loc

		var/dwx = src.proj_data.projectile_speed * src.xo
		var/dwy = src.proj_data.projectile_speed * src.yo
		curr_t++
		src.travelled += src.proj_data.projectile_speed

		if (proj_data.precalculated)
			for (var/i = 1, i < crossing.len, i++)
				var/turf/T = crossing[i]
				if (crossing[T] < curr_t)
					Move(T)
					if (disposed)
						return
					incidence = get_dir(curr_turf, T)
					curr_turf = T
					crossing.Cut(1,2)
					i--
				else
					break

		wx += dwx
		wy += dwy
		dir = 1
		if (!proj_data.precalculated)
			var/trfx = round((wx + 16) / 32)
			var/trfy = round((wy + 16) / 32)
			var/turf/Dest = locate(orig_turf.x + trfx, orig_turf.y + trfy, orig_turf.z)
			if (loc != Dest)
				Move(Dest)
				incidence = get_dir(curr_turf, Dest)
				if (!(incidence in cardinal))
					var/txl = wx + 16 % 32
					var/tyl = wy + 16 % 32
					var/ext = xo < 0 ? (32 - txl) / -xo : txl / xo
					var/eyt = yo < 0 ? (32 - tyl) / -yo : tyl / yo
					if (ext < eyt)
						incidence &= EAST | WEST
					else
						incidence &= NORTH | SOUTH

		incidence = turn(incidence, 180)

		var/dx = loc.x - orig_turf.x
		var/dy = loc.y - orig_turf.y
		var/dpx = dx * 32
		var/dpy = dy * 32
		pixel_x = wx - dpx
		pixel_y = wy - dpy

datum/projectile
	// These vars were copied from the an projectile datum. I am not sure which version, probably not 4407.
	var
		name = "projectile"
		icon = 'icons/obj/projectiles.dmi'
		icon_state = "bullet"	// A special note: the icon state, if not a point-symmetric sprite, should face NORTH by default.
		icon_turf_hit = null // what kinda overlay they puke onto turfs when they hit
		brightness = 0
		color_red = 0
		color_green = 0
		color_blue = 0
		color_icon = "#ffffff"
		override_color = 0
		power = 20               // How much of a punch this has
		cost = 1                 // How much ammo this costs
		dissipation_rate = 2     // How fast the power goes away
		dissipation_delay = 10   // How many tiles till it starts to lose power
		dissipation_ticker = 0   // Tracks how many tiles we moved
		ks_ratio = 1.0           /* Kill/Stun ratio, when it hits a mob the damage/stun is based upon this and the power
		                            eg 1.0 will cause damage = to power while 0.0 would cause just stun = to power */

		sname = "stun"           // name of the projectile setting, used when you change a guns setting
		shot_sound = 'sound/weapons/Taser.ogg' // file location for the sound you want it to play
		shot_number = 0          // How many projectiles should be fired, each will cost the full cost
		damage_type = D_KINETIC  // What is our damage type
		hit_type = null          // For blood system damage - DAMAGE_BLUNT, DAMAGE_CUT and DAMAGE_STAB
		hit_ground_chance = 0    // With what % do we hit mobs laying down
		window_pass = 0          // Can we pass windows
		obj/projectile/master = null
		silentshot = 0           // standard visible message upon bullet_act
		implanted                // Path of "bullet" left behind in the mob on successful hit
		disruption = 0           // planned thing to deal with pod electronics / etc
		zone = null              // todo: if fired from a handheld gun, check the targeted zone --- this should be in the goddamn obj
		caliber = null

		datum/material/material = null

		casing = null
		reagent_payload = null
		forensic_ID = null
		precalculated = 1

	// Determines the amount of length units the projectile travels each tick
	// A tile is 32 wide, 32 long, and 32 * sqrt(2) across.
	// Setting this to 32 will mimic the old behaviour for shots travelling in one of the cardinal directions.
	var/projectile_speed = 28

	// Determines the impact range of the projectile. Should ideally be half the length of the sprite
	// for line-based stuff (lasers), or the radius for circular projectiles.
	// If the projectile is irregular (like, a square), try to use the radius of a circle that touches the farthest point
	// of the edge of a shape in a cardinal direction from the center of symmetry (eg. half the edge length for a square)
	// This is mostly aesthetic, so the player feels like they are actually hit when the projectile reaches them, not
	// earlier or later.
	// For very high speed projectiles, this may be much lower than the suggested amounts.
	// If 0, no forward checking is done at all. May be useful for stuff like revolver shots, where the bullets are literally
	// a pixel wide.
	var/impact_range = 8

	// Self-explanatory.
	var/hits_ghosts = 0

	proc
		hit_ground()
			return prob(hit_ground_chance)
		//For future use, ie guns that can change the power settings
		set_power()
			return
		//When it hits a mob or such should anything special happen
		on_hit(atom/hit, angle, var/obj/projectile/O)
			return
		tick(var/obj/projectile/O)
			return
		on_launch(var/obj/projectile/O)
			return
		on_pointblank(var/obj/projectile/O, var/mob/target)
			return
		on_end(var/obj/projectile/O)
			return

// WOO IMPACT RANGES
// Meticulously calculated by hand.

datum/projectile/laser
	impact_range = 16

datum/projectile/laser/pred
	impact_range = 2

datum/projectile/laser/light
	impact_range = 2

datum/projectile/laser/glitter
	impact_range = 4

datum/projectile/laser/precursor
	impact_range = 4

datum/projectile/laser/precursor/sphere
	impact_range = 16

datum/projectile/laser/mining
	impact_range = 12

datum/projectile/laser/eyebeams
	impact_range = 4

datum/projectile/laser/drill
	impact_range = 0

datum/projectile/laser/drill/cutter
	impact_range = 0

datum/projectile/fourtymm
	impact_range = 12

datum/projectile/bfg
	impact_range = 16

datum/projectile/bullet
	impact_range = 0

datum/projectile/bullet/autocannon
	impact_range = 2

datum/projectile/bullet/autocannon/plasma_orb
	impact_range = 8

datum/projectile/bullet/autocannon/huge
	impact_range = 8

datum/projectile/bullet/glitch
	impact_range = 4

// for the gun, not the drone
datum/projectile/bullet/glitch/gun
	impact_range = 16

datum/projectile/bullet/rod
	impact_range = 16

datum/projectile/bullet/flare/ufo
	impact_range = 8

datum/projectile/owl
	impact_range = 16

datum/projectile/disruptor
	impact_range = 4

datum/projectile/disruptor/high
	impact_range = 4

datum/projectile/energy_bolt
	impact_range = 4

datum/projectile/energy_bolt_v
	impact_range = 4

datum/projectile/energy_bolt_antighost
	impact_range = 16
	hits_ghosts = 1 // do it.

datum/projectile/rad_bolt
	impact_range = 0

datum/projectile/tele_bolt
	impact_range = 4

datum/projectile/wavegun
	impact_range = 4

datum/projectile/snowball
	impact_range = 4

// THIS IS INTENDED FOR POINTBLANKING.
/proc/hit_with_projectile(var/S, var/datum/projectile/DATA, var/atom/T)
	if (!S || !T)
		return
	var/times = max(1, DATA.shot_number)
	for (var/i = 1, i <= times, i++)
		var/obj/projectile/P = initialize_projectile_ST(S, DATA, T)
		if (S == T)
			P.shooter = null
			P.mob_shooter = S
		hit_with_existing_projectile(P, T)

/proc/hit_with_existing_projectile(var/obj/projectile/P, var/atom/T)
	if (!P || !T)
		return
	if (ismob(T))
		var/immunity = check_target_immunity(T) // Point-blank overrides, such as stun bullets (Convair880).
		if (immunity)
			log_shot(P, T, 1)
			T.visible_message("<b><span style=\"color:red\">...but the projectile bounces off uselessly!</span></b>")
			P.die()
			return
		P.proj_data.on_pointblank(P, T)
	P.collide(T) // The other immunity check is in there (Convair880).

/proc/shoot_projectile_ST(var/atom/movable/S, var/datum/projectile/DATA, var/T)
	if (!S)
		return
	if (!isturf(S) && !isturf(S.loc))
		return null
	var/turf/target = get_turf(T)
	var/obj/projectile/Q = shoot_projectile_relay(S, DATA, target)
	if (DATA.shot_number > 1)
		spawn(0)
			for (var/i = 2, i < DATA.shot_number, i++)
				sleep(1)
				shoot_projectile_relay(S, DATA, target)
	return Q

/proc/shoot_projectile_ST_pixel(var/atom/movable/S, var/datum/projectile/DATA, var/T, var/pox, var/poy)
	if (!S)
		return
	if (!isturf(S) && !isturf(S.loc))
		return null
	var/turf/target = get_turf(T)
	var/obj/projectile/Q = shoot_projectile_relay_pixel(S, DATA, target, pox, poy)
	if (DATA.shot_number > 1)
		spawn(0)
			for (var/i = 2, i <= DATA.shot_number, i++)
				sleep(1)
				shoot_projectile_relay_pixel(S, DATA, target, pox, poy)
	return Q

/proc/shoot_projectile_ST_pixel_spread(var/atom/movable/S, var/datum/projectile/DATA, var/T, var/pox, var/poy, var/spread_angle)
	if (!S)
		return
	if (!isturf(S) && !isturf(S.loc))
		return null
	var/turf/target = get_turf(T)
	var/obj/projectile/Q = shoot_projectile_relay_pixel_spread(S, DATA, target, pox, poy, spread_angle)
	if (DATA.shot_number > 1)
		spawn(0)
			for (var/i = 2, i <= DATA.shot_number, i++)
				sleep(1)
				shoot_projectile_relay_pixel_spread(S, DATA, target, pox, poy, spread_angle)
	return Q

/proc/shoot_projectile_DIR(var/atom/movable/S, var/datum/projectile/DATA, var/dir)
	if (!S)
		return
	if (!isturf(S) && !isturf(S.loc))
		return null
	var/turf/T = get_step(get_turf(S), dir)
	if (T)
		return shoot_projectile_ST(S, DATA, T)
	return null

/proc/shoot_projectile_relay(var/atom/movable/S, var/datum/projectile/DATA, var/T)
	if (!S)
		return
	if (!isturf(S) && !isturf(S.loc))
		return
	var/obj/projectile/P = initialize_projectile_ST(S, DATA, T)
	if (P)
		P.launch()
	return P

/proc/shoot_projectile_relay_pixel(var/atom/movable/S, var/datum/projectile/DATA, var/T, var/pox, var/poy)
	if (!S)
		return
	if (!isturf(S) && !isturf(S.loc))
		return
	var/obj/projectile/P = initialize_projectile_pixel(S, DATA, T, pox, poy)
	if (P)
		P.launch()
	return P

/proc/shoot_projectile_relay_pixel_spread(var/atom/movable/S, var/datum/projectile/DATA, var/T, var/pox, var/poy, var/spread_angle)
	if (!S)
		return
	if (!isturf(S) && !isturf(S.loc))
		return
	var/obj/projectile/P = initialize_projectile_pixel_spread(S, DATA, T, pox, poy, spread_angle)
	if (P)
		P.launch()
	return P

/proc/shoot_projectile_XY(var/atom/movable/S, var/datum/projectile/DATA, var/xo, var/yo)
	if (!S)
		return
	if (!isturf(S) && !isturf(S.loc))
		return
	var/obj/projectile/Q = shoot_projectile_XY_relay(S, DATA, xo, yo)
	if (DATA.shot_number > 1)
		spawn(0)
			for (var/i = 2, i <= DATA.shot_number, i++)
				sleep(1)
				shoot_projectile_XY_relay(S, DATA, xo, yo)
	return Q

/proc/shoot_projectile_XY_relay(var/atom/movable/S, var/datum/projectile/DATA, var/xo, var/yo)
	if (!S)
		return
	if (!isturf(S) && !isturf(S.loc))
		return
	var/obj/projectile/P = initialize_projectile(get_turf(S), DATA, xo, yo, S)
	if (P)
		P.launch()
	return P

/proc/initialize_projectile_ST(var/atom/movable/S, var/datum/projectile/DATA, var/T)
	if (!S)
		return
	if (!isturf(S) && !isturf(S.loc))
		return
	var/turf/Q1 = get_turf(S)
	var/turf/Q2 = get_turf(T)
	return initialize_projectile(Q1, DATA, Q2.x - Q1.x, Q2.y - Q1.y, S)

/proc/initialize_projectile_pixel(var/atom/movable/S, var/datum/projectile/DATA, var/T, var/pox, var/poy)
	if (!S)
		return
	if (!isturf(S) && !isturf(S.loc))
		return
	var/turf/Q1 = get_turf(S)
	var/turf/Q2 = get_turf(T)
	return initialize_projectile(Q1, DATA, (Q2.x - Q1.x) * 32 + pox, (Q2.y - Q1.y) * 32 + poy, S)

/proc/initialize_projectile_pixel_spread(var/atom/movable/S, var/datum/projectile/DATA, var/T, var/pox, var/poy, var/spread_angle)
	var/obj/projectile/P = initialize_projectile_pixel(S, DATA, T, pox, poy)
	if (P && spread_angle)
		if (spread_angle < 0)
			spread_angle = -spread_angle
		var/spread = rand(spread_angle * 10) / 10
		P.rotateDirection(prob(50) ? spread : -spread)
	return P

/proc/initialize_projectile(var/turf/S, var/datum/projectile/DATA, var/xo, var/yo, var/shooter = null)
	if (!S)
		return
	var/obj/projectile/P = unpool(/obj/projectile)
	if(!P)
		return

	P.set_loc(S)
	P.proj_data = DATA

	if (narrator_mode)
		playsound(S, 'sound/vox/shoot.ogg', 50, 1)
	else if(DATA.shot_sound && shooter)
		playsound(S, DATA.shot_sound, 50)
		if (isobj(shooter))
			for (var/mob/M in shooter)
				M << sound(DATA.shot_sound, volume=50)

#ifdef DATALOGGER
	if (game_stats && istype(game_stats))
		game_stats.Increment("gunfire")
#endif

	if (DATA.implanted)
		P.implanted = DATA.implanted

	P.set_icon()
	P.shooter = shooter
	P.name = DATA.name
	P.setMaterial(DATA.material)
	P.power = DATA.power

	if (DATA.brightness)
		if (!P.light)
			P.light = new /datum/light/point
			P.light.attach(P)
		P.light.set_brightness(DATA.brightness)
		P.light.set_color(DATA.color_red, DATA.color_green, DATA.color_blue)
		P.light.enable()

	P.xo = xo
	P.yo = yo
	return P

/proc/stun_bullet_hit(var/obj/projectile/P, var/mob/living/M)
	if (ishuman(M) && M.stat != 2)
		var/mob/living/carbon/human/H = M
		H.lying = 1
		H.stat = 1
		H.stunned = max(H.stunned, 1)
	else if (istype(M, /mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = M
		R.stunned = max(R.stunned, 5)

/proc/shoot_reflected(var/obj/projectile/P, var/obj/reflector)
	var/obj/projectile/Q = initialize_projectile(get_turf(reflector), P.proj_data, -P.xo, -P.yo, reflector)
	if (!Q)
		return null
	if (ismob(P.shooter))
		Q.mob_shooter = P.shooter
	Q.name = "reflected [Q.name]"
	Q.launch()
	return Q

/proc/shoot_cardinal_normal_reflected(var/obj/projectile/P, var/obj/reflector)
	if (!P.incidence || !(P.incidence in cardinal))
		return null

	var/rx = 0
	var/ry = 0

	var/nx = P.incidence == WEST ? -1 : (P.incidence == EAST ?  1 : 0)
	var/ny = P.incidence == SOUTH ? -1 : (P.incidence == NORTH ?  1 : 0)

	var/dn = 2 * (P.xo * nx + P.yo * ny) // incident direction DOT normal * 2
	rx = P.xo - dn * nx // r = d - 2 * (d * n) * n
	ry = P.yo - dn * ny

	if (rx == ry && rx == 0)
		logTheThing("debug", null, null, "<b>Marquesas/Reflecting Projectiles</b>: Reflection failed for [P.name] (incidence: [P.incidence], direction: [P.xo];[P.yo]).")
		return null // unknown error

	var/obj/projectile/Q = initialize_projectile(get_turf(reflector), P.proj_data, rx, ry, reflector)
	if (!Q)
		return null
	if (ismob(P.shooter))
		Q.mob_shooter = P.shooter
	Q.name = "reflected [Q.name]"
	Q.launch()
	return Q