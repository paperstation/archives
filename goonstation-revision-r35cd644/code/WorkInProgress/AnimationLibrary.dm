//Collection of animations we can reuse for stuff.
//Try to isolate animations you create an put them in here.

/proc/animate_fade_grayscale(var/atom/A, var/time=5)
	if (!istype(A) && !istype(A, /client))
		return
	A.color = list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1)
	animate(A, color=list(0.33, 0.33, 0.33, 0, 0.33, 0.33, 0.33, 0, 0.33, 0.33, 0.33, 0, 0, 0, 0, 1), time=time, easing=SINE_EASING)
	return

/proc/animate_melt_pixel(var/atom/A)
	if (!istype(A))
		return
	//A.alpha = 200
	animate(A, pixel_y = 0, time = 50 - A.pixel_y, alpha = 175, easing = BOUNCE_EASING)
	animate(alpha = 0, easing = LINEAR_EASING)
	return

/proc/animate_explode_pixel(var/atom/A)
	if (!istype(A))
		return
	var/floatdegrees = rand(5, 20)
	var/side = 1
	side = pick(-1, 1)
	animate(A, pixel_x = rand(-64, 64), pixel_y = rand(-64, 64), transform = matrix(floatdegrees * (side == 1 ? 1:-1), MATRIX_ROTATE), time = 10, alpha = 0, easing = SINE_EASING)
	return

/proc/animate_float(var/atom/A, var/loopnum = -1, floatspeed = 20, random_side = 1)
	if (!istype(A))
		return
	var/floatdegrees = rand(5, 20)
	var/side = 1
	if(random_side) side = pick(-1, 1)

	spawn(rand(1,10))
		animate(A, pixel_y = 32, transform = matrix(floatdegrees * (side == 1 ? 1:-1), MATRIX_ROTATE), time = floatspeed, loop = loopnum, easing = SINE_EASING)
		animate(pixel_y = 0, transform = matrix(floatdegrees * (side == 1 ? -1:1), MATRIX_ROTATE), time = floatspeed, loop = loopnum, easing = SINE_EASING)
	return

/proc/animate_levitate(var/atom/A, var/loopnum = -1, floatspeed = 20, random_side = 1)
	if (!istype(A))
		return
	var/floatdegrees = rand(5, 20)
	var/side = 1
	if(random_side) side = pick(-1, 1)

	spawn(rand(1,10))
		animate(A, pixel_y = 8, transform = matrix(floatdegrees * (side == 1 ? 1:-1), MATRIX_ROTATE), time = floatspeed, loop = loopnum, easing = SINE_EASING)
		animate(pixel_y = 0, transform = null, time = floatspeed, loop = loopnum, easing = SINE_EASING)
	return

/proc/animate_revenant_shockwave(var/atom/A, var/loopnum = -1, floatspeed = 20, random_side = 1)
	if (!istype(A))
		return
	var/floatdegrees = rand(5, 20)
	var/side = 1
	if(random_side) side = pick(-1, 1)

	spawn(rand(1,10))
		animate(A, pixel_y = 8, transform = matrix(floatdegrees * (side == 1 ? 1:-1), MATRIX_ROTATE), time = floatspeed, loop = loopnum, easing = SINE_EASING)
		animate(pixel_y = 0, transform = matrix(floatdegrees * (side == 1 ? -1:1), MATRIX_ROTATE), time = floatspeed, loop = loopnum, easing = SINE_EASING)
	return

/proc/animate_glitchy_freakout(var/atom/A)
	if (!istype(A))
		return
	var/matrix/M = matrix()
	var/looper = rand(3,5)
	while(looper > 0)
		looper--
		M.Scale(rand(1,4),rand(1,4))
		animate(A, transform = M, pixel_x = A.pixel_x + rand(-12,12), pixel_z = A.pixel_z + rand(-12,12), time = 3, loop = 1, easing = LINEAR_EASING)
		animate(transform = matrix(rand(-360,360), MATRIX_ROTATE), time = 3, loop = 1, easing = LINEAR_EASING)
		M.Scale(1,1)
		animate(transform = M, pixel_x = 0, pixel_z = 0, time = 1, loop = 1, easing = LINEAR_EASING)
		animate(transform = null, time = 1, loop = 1, easing = LINEAR_EASING)

/proc/animate_fading_leap_up(var/atom/A)
	if (!istype(A))
		return
	var/matrix/M = matrix()
	var/do_loops = 15
	while (do_loops > 0)
		do_loops--
		animate(A, transform = M, pixel_z = A.pixel_z + 12, alpha = A.alpha - 17, time = 1, loop = 1, easing = LINEAR_EASING)
		M.Scale(1.2,1.2)
		sleep(1)
	A.alpha = 0

/proc/animate_fading_leap_down(var/atom/A)
	if (!istype(A))
		return
	var/matrix/M = matrix()
	var/do_loops = 15
	M.Scale(18,18)
	while (do_loops > 0)
		do_loops--
		animate(A, transform = M, pixel_z = A.pixel_z - 12, alpha = A.alpha + 17, time = 1, loop = 1, easing = LINEAR_EASING)
		M.Scale(0.8,0.8)
		sleep(1)
	animate(A, transform = M, pixel_z = 0, alpha = 255, time = 1, loop = 1, easing = LINEAR_EASING)

/proc/animate_shake(var/atom/A,var/amount = 5,var/x_severity = 2,var/y_severity = 2)
	// Wiggles the sprite around on its tile then returns it to normal
	if (!istype(A))
		return
	if (!isnum(amount) || !isnum(x_severity) || !isnum(y_severity))
		return
	amount = max(1,min(amount,50))
	x_severity = max(-32,min(x_severity,32))
	y_severity = max(-32,min(y_severity,32))

	var/x_severity_inverse = 0 - x_severity
	var/y_severity_inverse = 0 - y_severity

	animate(A, transform = null, pixel_y = rand(y_severity_inverse,y_severity), pixel_x = rand(x_severity_inverse,x_severity),time = 1,loop = amount, easing = ELASTIC_EASING)
	spawn(amount)
		animate(A, transform = null, pixel_y = 0, pixel_x = 0,time = 1,loop = 1, easing = LINEAR_EASING)
	return

/proc/animate_teleport(var/atom/A)
	if (!istype(A))
		return
	var/matrix/M = matrix(1, 3, MATRIX_SCALE)
	animate(A, transform = M, pixel_y = 32, time = 10, alpha = 50, easing = CIRCULAR_EASING)
	M.Scale(0,4)
	animate(transform = M, time = 5, color = "#1111ff", alpha = 0, easing = CIRCULAR_EASING)
	animate(transform = null, time = 5, color = "#ffffff", alpha = 255, pixel_y = 0, easing = ELASTIC_EASING)
	return

/proc/animate_teleport_wiz(var/atom/A)
	if (!istype(A))
		return
	var/matrix/M = matrix(0, 4, MATRIX_SCALE)
	animate(A, color = "#ddddff", time = 20, alpha = 70, easing = LINEAR_EASING)
	animate(transform = M, pixel_y = 32, time = 20, color = "#2222ff", alpha = 0, easing = CIRCULAR_EASING)
	animate(time = 8, transform = M, alpha = 5) //Do nothing, essentially
	animate(transform = null, time = 5, color = "#ffffff", alpha = 255, pixel_y = 0, easing = ELASTIC_EASING)
	return

/proc/animate_rainbow_glow_old(var/atom/A)
	if (!istype(A))
		return
	animate(A, color = "#FF0000", time = rand(5,10), loop = -1, easing = LINEAR_EASING)
	animate(color = "#00FF00", time = rand(5,10), loop = -1, easing = LINEAR_EASING)
	animate(color = "#0000FF", time = rand(5,10), loop = -1, easing = LINEAR_EASING)
	return

/proc/animate_rainbow_glow(var/atom/A)
	if (!istype(A))
		return
	animate(A, color = "#FF0000", time = rand(5,10), loop = -1, easing = LINEAR_EASING)
	animate(color = "#FFFF00", time = rand(5,10), loop = -1, easing = LINEAR_EASING)
	animate(color = "#00FF00", time = rand(5,10), loop = -1, easing = LINEAR_EASING)
	animate(color = "#00FFFF", time = rand(5,10), loop = -1, easing = LINEAR_EASING)
	animate(color = "#0000FF", time = rand(5,10), loop = -1, easing = LINEAR_EASING)
	animate(color = "#FF00FF", time = rand(5,10), loop = -1, easing = LINEAR_EASING)
	return

/proc/animate_fade_to_color_fill(var/atom/A,var/the_color,var/time)
	if (!istype(A) || !the_color || !time)
		return
	animate(A, color = the_color, time = time, easing = LINEAR_EASING)

/proc/animate_flash_color_fill(var/atom/A,var/the_color,var/loops,var/time)
	if (!istype(A) || !the_color || !time || !loops)
		return
	animate(A, color = the_color, time = time, easing = LINEAR_EASING)
	animate(color = "#FFFFFF", time = 5, loop = loops, easing = LINEAR_EASING)

/proc/animate_flash_color_fill_inherit(var/atom/A,var/the_color,var/loops,var/time)
	if (!istype(A) || !the_color || !time || !loops)
		return
	var/color_old = A.color
	animate(A, color = the_color, time = time, loop = loops, easing = LINEAR_EASING)
	animate(A, color = color_old, time = time, loop = loops, easing = LINEAR_EASING)

/proc/animate_clownspell(var/atom/A)
	if (!istype(A))
		return
	animate(A, transform = matrix(1.3, MATRIX_SCALE), time = 5, color = "#00ff00", easing = BACK_EASING)
	animate(transform = null, time = 5, color = "#ffffff", easing = ELASTIC_EASING)
	return

/proc/animate_wiggle_then_reset(var/atom/A, var/loops = 5, var/speed = 5, var/x_var = 3, var/y_var = 3)
	if (!istype(A) || !loops || !speed)
		return
	animate(A, pixel_x = rand(-x_var, x_var), pixel_y = rand(-y_var, y_var), time = speed * 2,loop = loops, easing = rand(2,7))
	animate(pixel_x = 0, pixel_y = 0, time = speed, easing = rand(2,7))

/proc/animate_blink(var/atom/A)
	if (!istype(A))
		return
	var/matrix/Orig = A.transform
	A.Scale(0.2,0.2)
	A.alpha = 50
	animate(A,transform = Orig, time = 3, alpha = 255, easing = CIRCULAR_EASING)
	return

/proc/animate_bullspellground(var/atom/A, var/spell_color = "#cccccc")
	if (!istype(A))
		return
	animate(A, time = 5, color = spell_color)
	animate(time = 5, color = "#ffffff")
	return

/proc/animate_spin(var/atom/A, var/dir = "L", var/T = 1, var/looping = -1)
	if (!istype(A))
		return

	var/matrix/M = A.transform
	var/turn = -90
	if (dir == "R")
		turn = 90

	animate(A, transform = matrix(M, turn, MATRIX_ROTATE | MATRIX_MODIFY), time = T, loop = looping)
	animate(transform = matrix(M, turn, MATRIX_ROTATE | MATRIX_MODIFY), time = T, loop = looping)
	animate(transform = matrix(M, turn, MATRIX_ROTATE | MATRIX_MODIFY), time = T, loop = looping)
	animate(transform = matrix(M, turn, MATRIX_ROTATE | MATRIX_MODIFY), time = T, loop = looping)
	return

/proc/animate_bumble(var/atom/A, var/loopnum = -1, floatspeed = 10, Y1 = 3, Y2 = -3, var/slightly_random = 1)
	if (!istype(A))
		return

	if (slightly_random)
		floatspeed = floatspeed * rand_deci(1, 0, 1, 4)
	animate(A, pixel_y = Y1, time = floatspeed, loop = loopnum, easing = LINEAR_EASING)
	animate(pixel_y = Y2, time = floatspeed, loop = loopnum, easing = LINEAR_EASING)
	return

/proc/animate_beespin(var/atom/A, var/dir = "L", var/T = 1.5, var/looping = 1)
	if (!istype(A))
		return

	var/matrix/turned

	if (dir == "R")
		A.dir = WEST
		turned = matrix(A.transform, 90, MATRIX_ROTATE)

	if (dir == "L")
		A.dir = EAST
		turned = matrix(A.transform, -90, MATRIX_ROTATE)

	animate(A, pixel_y = (A.pixel_y + 4), pixel_x = (A.pixel_x + 4), transform = turned, time = T, loop = looping, dir = EAST)
	animate(pixel_y = (A.pixel_y + 6), transform = turned.Turn(dir == "R" ? 90 : -90), time = T, loop = looping, dir = EAST)
	animate(pixel_y = (A.pixel_y - 4), transform = turned.Turn(dir == "R" ? 90 : -90), time = T, loop = looping, dir = EAST)
	animate(pixel_y = (A.pixel_y - 6), pixel_x = (A.pixel_x - 4), transform = turned.Turn(dir == "R" ? 90 : -90), time = T, loop = looping, dir = EAST)

	animate(pixel_y = (A.pixel_y - 4), pixel_x = (A.pixel_x + 4), transform = turned.Turn(dir == "R" ? 90 : -90), time = T, loop = looping, dir = EAST)
	animate(pixel_y = (A.pixel_y - 4), transform = turned.Turn(dir == "R" ? 90 : -90), time = T, loop = looping, dir = EAST)
	animate(pixel_y = (A.pixel_y + 4), transform = turned.Turn(dir == "R" ? 90 : -90), time = T, loop = looping, dir = EAST)
	animate(pixel_y = (A.pixel_y + 4), pixel_x = (A.pixel_x - 4), transform = turned.Turn(dir == "R" ? 90 : -90), time = T, loop = looping, dir = EAST)
	return

/proc/animate_smug(var/atom/A)
	if (!istype(A))
		return
	var/obj/effect/smug/S = new(A.loc)
	S.Scale(0.05, 0.05)
	S.alpha = 0
	animate(S,transform = matrix(0.5, MATRIX_SCALE), time = 20, alpha = 255, pixel_y = 27, easing = ELASTIC_EASING)
	animate(time = 5, alpha = 0, pixel_y = -16, easing = CIRCULAR_EASING)
	spawn(30) qdel(S)
	return

/proc/animate_horizontal_wiggle(var/atom/A, var/loopnum = 5, speed = 10, X1 = 3, X2 = -3, var/slightly_random = 1)
	if (!istype(A))
		return

	if (slightly_random)
		var/rand_var = (rand(10, 14) / 10)
		DEBUG("rand_var [rand_var]")
		speed = speed * rand_var
	animate(A, pixel_x = X1, time = speed, loop = loopnum, easing = LINEAR_EASING)
	animate(pixel_x = X2, time = speed, loop = loopnum, easing = LINEAR_EASING)
	return

/proc/animate_slide(var/atom/A, var/px, var/py, var/T = 10, var/ease = SINE_EASING)
	if(!istype(A))
		return

	animate(A, pixel_x = px, pixel_y = py, time = T, easing = ease)

/proc/animate_rest(var/atom/A, var/stand)
	if(!istype(A))
		return

	if(stand)
		animate(A, pixel_x = 0, pixel_y = 0, transform = null, time = 3, easing = LINEAR_EASING)
	else
		animate(A, pixel_x = 0, pixel_y = -4, transform = matrix(90, MATRIX_ROTATE), time = 2, easing = LINEAR_EASING)

/proc/animate_flip(var/atom/A, var/T)
	animate(A, transform = matrix(A.transform, 90, MATRIX_ROTATE), time = T)
	animate(transform = matrix(A.transform, 180, MATRIX_ROTATE), time = T)


/proc/animate_offset_spin(var/atom/A, var/radius, var/laps, var/lap_start_t, var/lap_end_t)
	if(!laps || !radius || lap_start_t < 1 || lap_end_t < 1)
		return

	animate(A, transform = null, time = 1)
	var/time_diff = (lap_end_t - lap_start_t)	//How much should the lap time change overall ?
	var/T = lap_start_t		//Lap time starts at the set start time
	var/res = 8		//The resolution - how many points on the circle do we want to calculate?
	var/deg = 360 / res	//How much difference in degrees is there per point?
	for(var/J = 0 to res*laps)	//Step through the points
		animate(transform = matrix(A.transform, (J!=0)*deg, MATRIX_ROTATE), \
					 pixel_x = (radius * sin(deg*J)), \
					 pixel_y = (radius * cos(deg*J)), \
					 time = (T + (time_diff*J/(laps*res))) / res )
		DEBUG("Animating D: [deg], res: [res], px: [A.pixel_x], py: [A.pixel_y], T: [T], ActualTime:[(T + (time_diff*J/(laps*res)))], J/laps:[J/(laps*res)] TD:[(time_diff*J/(laps*res))]")
	//T += time_diff	//Modify the time with the calculated difference.
	animate(pixel_x = 0, pixel_y = 0, time = 2)

/*
/mob/verb/offset_spin(var/radius as num, var/laps as num, var/s_time as num, var/e_time as num)
	set category = "Debug"
	set name = "Test Offset Spin"
	set desc = "(radius,laps,s_time,e_time)Holy balls!"
	set usr = src
	animate_offset_spin(src, radius, laps, s_time, e_time)
*/

/proc/animate_shockwave(var/atom/A)
	if (!istype(A))
		return
	var/punchstr = rand(10, 20)
	var/original_y = A.pixel_y
	animate(A, transform = matrix(punchstr, MATRIX_ROTATE), pixel_y = 16, time = 2, color = "#eeeeee", easing = BOUNCE_EASING)
	animate(transform = matrix(-punchstr, MATRIX_ROTATE), pixel_y = original_y, time = 2, color = "#ffffff", easing = BOUNCE_EASING)
	animate(transform = null, time = 3, easing = BOUNCE_EASING)
	return

/proc/animate_glitchy_fuckup1(var/atom/A)
	if (!istype(A))
		return

	animate(A, pixel_z = A.pixel_z + -128, time = 3, loop = -1, easing = LINEAR_EASING)
	animate(pixel_z = A.pixel_z + 128, time = 0, loop = -1, easing = LINEAR_EASING)

/proc/animate_glitchy_fuckup2(var/atom/A)
	if (!istype(A))
		return

	animate(A, pixel_x = A.pixel_x + rand(-128,128), pixel_z = A.pixel_z + rand(-128,128), time = 2, loop = -1, easing = LINEAR_EASING)
	animate(pixel_x = 0, pixel_z = 0, time = 0, loop = -1, easing = LINEAR_EASING)

/proc/animate_glitchy_fuckup3(var/atom/A)
	if (!istype(A))
		return
	var/matrix/M = matrix()
	var/matrix/MD = matrix()
	var/list/scaley_numbers = list(0.25,0.5,1,1.5,2)
	M.Scale(pick(scaley_numbers),pick(scaley_numbers))
	animate(A, transform = M, time = 1, loop = -1, easing = LINEAR_EASING)
	animate(transform = MD, time = 1, loop = -1, easing = LINEAR_EASING)

// these don't use animate but they're close enough, idk
/proc/showswirl(var/atom/target)
	if (!target)
		return
	var/turf/target_turf = get_turf(target)
	if (!target_turf)
		return
	var/obj/decal/teleport_swirl/swirl = unpool(/obj/decal/teleport_swirl)
	swirl.set_loc(target_turf)
	swirl.pixel_y = 10
	playsound(target_turf, "sound/effects/teleport.ogg", 50, 1)
	spawn(15)
		if (swirl)
			swirl.pixel_y = 0
			pool(swirl)
	return

/proc/leaveresidual(var/atom/target)
	if (!target)
		return
	var/turf/target_turf = get_turf(target)
	if (!target_turf)
		return
	if (locate(/obj/decal/residual_energy) in target_turf)
		return
	var/obj/decal/residual_energy/e = unpool(/obj/decal/residual_energy)
	e.set_loc(target_turf)
	spawn(100)
		if (e)
			pool(e)
	return
