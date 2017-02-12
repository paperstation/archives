var/datum/subsystem/sun/SSsun

/datum/subsystem/sun
	name = "Sun"
	wait = 600

	var/angle
	var/dx
	var/dy
	var/degrees_per_minute

	var/list/controls = list()
	var/list/solars = list()


/datum/subsystem/sun/fire()
	set background = 1

	calc_position()
	for(var/obj/machinery/power/solar_control/C in controls)
		C.sun_update()
	for(var/obj/machinery/power/solar/S in solars)
		var/delta = abs(S.angle - angle)
		if(delta < 90)
			delta = cos(delta) ** 2
			if(delta > 0)
				if(raycast(S.x, S.y, S.z, dx, dy))
					S.sunfrac = delta
					continue
		S.sunfrac = 0


/datum/subsystem/sun/New()
	if(SSsun != src)
		SSsun = src

	degrees_per_minute = rand(3,9)	//3 to 9 degrees a minute
	if(prob(50))
		degrees_per_minute *= -1
	..()

// calculate the sun's position given the time of day
/datum/subsystem/sun/proc/calc_position()
	angle = (angle + (degrees_per_minute * wait / 600)) % 360
	if(angle < 0)
		angle += 360

	// now calculate and cache the (dx,dy) increments for line drawing
	dx = sin(angle)
	dy = cos(angle)
	var/largest = max(abs(dx),abs(dy))
	dx /= largest
	dy /= largest


/proc/raycast(x, y, z, dx, dy, iterations=20)
	var/last_turf
	for(var/i=1, i<=iterations, ++i)
		x += dx
		y += dy

		var/turf/T = locate(round(x,0.5), round(y,0.5), z)
		if(!T)	break
		if(T == last_turf)	continue

		if(T.opacity)
			return 0

		for(var/atom/movable/AM in T)
			if(AM.opacity)
				return 0

		last_turf = T

	return 1