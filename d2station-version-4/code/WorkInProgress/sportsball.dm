/obj/sportsball
	animate_movement = NO_STEPS
	icon = 'sportsball.dmi'
	icon_state = "s"
	density = 1
	anchored = 0
	opacity = 0

	var
		ball_xer = 0
		ball_yer = 0

		ball_acc = 5
		ball_max = 20

		ball_moved = 0
		ball_movedelay = 2
		ball_turning

		ball_nulls = 0
		ball_und = 0
		ball_turnx = 0
		ball_turny = 0

		ball_lpx = 0
		ball_lpy = 0
		ball_lloc

		ball_type = "null"

/obj/sportsball/basketball
	ball_type = "basketball"

/obj/sportsball/football
	ball_type = "football"

/obj/sportsball/New()
	ball_yer = 1
	ball_xer = 1
	PixMove()
	spawn(1)
		ball_xer = 0
		ball_yer = 0

/obj/sportsball/Bump(atom/O)
	Bounce(get_dir(src, O))

/obj/sportsball/Bumped(atom/O)
	if(ismob(O))
		if(ball_moved == 1)
			return
		ball_moved = 1
		spawn(ball_movedelay)
			ball_moved = 0
		ball_turning = get_dir(O, src)
		return
	else
		Bounce(get_dir(src, O))

/obj/sportsball/attack_hand(mob/user as mob)
	if(ball_moved == 1)
		return
	ball_moved = 1
	spawn(ball_movedelay)
		ball_moved = 0
	ball_turning = get_dir(user, src)
	return

/obj/sportsball/proc/PixMove()
	ball_lpx = pixel_x
	ball_lpy = pixel_y
	var/d = ball_turning
	if(d == NORTH)
		if(ball_yer < ball_max)
			ball_yer += ball_acc
		if(ball_xer < 0)
			ball_xer += ball_acc
		else
			if(ball_xer > 0)
				ball_xer -= ball_acc
	if(d == SOUTH)
		if(ball_yer > -ball_max)
			ball_yer -= ball_acc
		if(ball_xer < 0)
			ball_xer += ball_acc
		else
			if(ball_xer > 0)
				ball_xer -= ball_acc
	if(d == EAST)
		if(ball_xer < ball_max)
			ball_xer += ball_acc
		if(ball_yer < 0)
			ball_yer += ball_acc
		else
			if(ball_yer > 0)
				ball_yer -= ball_acc
	if(d == WEST)
		if(ball_xer > -ball_max)
			ball_xer -= ball_acc
		if(ball_yer < 0)
			ball_yer += ball_acc
		else
			if(ball_yer > 0)
				ball_yer -= ball_acc
	if(d == NORTHWEST)
		if(ball_xer > -ball_max)
			ball_xer -= ball_acc
		if(ball_yer < ball_max)
			ball_yer += ball_acc
	if(d == NORTHEAST)
		if(ball_xer < ball_max)
			ball_xer += ball_acc
		if(ball_yer < ball_max)
			ball_yer += ball_acc
	if(d == SOUTHEAST)
		if(ball_xer < ball_max)
			ball_xer += ball_acc
		if(ball_yer > -ball_max)
			ball_yer -= ball_acc
	if(d == SOUTHWEST)
		if(ball_xer > -ball_max)
			ball_xer -= ball_acc
		if(ball_yer > -ball_max)
			ball_yer -= ball_acc
	if(ball_xer > ball_max)
		ball_xer = ball_max
	if(ball_xer < -ball_max)
		ball_xer = -ball_max
	if(ball_yer > ball_max)
		ball_yer = ball_max
	if(ball_yer < -ball_max)
		ball_yer = -ball_max
	ball_turning = null
	pixel_x += ball_xer
	pixel_y += ball_yer
	var/safe = 0
	while(pixel_x >= 16)
		safe += 1
		if(safe >= 100)
			break
		pixel_x -= 32
		step(src,EAST)
	while(pixel_x <= -16)
		safe += 1
		if(safe >= 100)
			break
		pixel_x += 32
		step(src,WEST)
	while(pixel_y >= 16)
		safe += 1
		if(safe >= 100)
			break
		pixel_y -= 32
		step(src,NORTH)
	while(pixel_y <= -16)
		safe += 1
		if(safe >= 100)
			break
		pixel_y += 32
		step(src,SOUTH)
	if(ball_yer != 0 || ball_xer != 0)
		/*
		var/icon/i = new('ball.dmi')
		var/ang
		var/am = 0
		var/yam = ball_yer
		var/xam = ball_xer
		if(ball_yer >= 20)
			yam = 20
		if(yam <= -20)
			yam = -20
		if(ball_xer <= -20)
			xam = -20
		if(ball_xer >= 20)
			xam = 20
		if(abs(xam) > abs(yam))
			am = abs(xam)-abs(yam)
			am *= 2
		if(abs(xam) < abs(yam))
			am = abs(yam)-abs(xam)
			am *= -2
		if(yam > 0 && xam == 0)
			ang = 180
		if(yam < 0 && xam == 0)
			ang = 0
		if(yam == 0 && xam > 0)
			ang = -90
		if(yam == 0 && xam < 0)
			ang = 90
		if(yam > 0 && xam > 0)
			ang = -135 + am
		if(yam < 0 && xam < 0)
			ang = 45 + am
		if(yam > 0 && xam < 0)
			ang = 135 + -am
		if(yam < 0 && xam > 0)
			ang = -45 + -am
		i.Turn(ang)
		icon = i
		world<<"[ball_xer],[ball_yer]"
		*/
		if(ball_und == 0)
			ball_turnx += ball_xer
			ball_turny += ball_yer
		else
			ball_turnx -= ball_xer
			ball_turny -= ball_yer
		var/icon/i = new('sportsball.dmi', "[ball_type]_dot")
		var/icon/ld = new('sportsball.dmi',"[ball_type]")
		var/p = PixelZone(ld,(ball_turnx+16)-3,(ball_turny+16)-3,(ball_turnx+16)+3,(ball_turny+16)+3)
		var/allnull = 1
		for(var/v in p)
			if(v != null)
				allnull = 0
		if(allnull == 1)
			ball_nulls += 1
			if(ball_nulls < 3)
				if(ball_und == 0)
					ball_und = 1
				else
					ball_und = 0
			else
				if(ball_nulls > 6)
					ball_turnx = 0
					ball_turny = 0
					ball_nulls = 0
		else
			ball_nulls = 0
		icon = ld
		icon -= rgb(255,255,255)
		ld = icon
		i.Shift(NORTH,ball_turny)
		i.Shift(EAST,ball_turnx)
		var/icon/I = new('sportsball.dmi',"[ball_type]")
		if(ball_und == 0)
			I.Blend(i,ICON_OVERLAY)
		icon = I
		icon += ld
	spawn(1)
		PixMove()

/obj/sportsball/proc/PixelZone(var/icon/i,var/xa,var/ya,var/xb,var/yb)
	var/list/l = new/list
	var/done = 0
	var/checkx = xa
	var/checky = ya
	while(done == 0)
		l += i.GetPixel(checkx,checky)
		checkx += 1
		if(checkx > xb)
			checkx = xa
			checky += 1
			if(checky > yb)
				break
	return l

/obj/sportsball/proc/Bounce(var/d)
	var/xd = 0
	var/yd = 0
	if(d == SOUTH || d == NORTH)
		xd = 1
	if(d == EAST || d == WEST)
		yd = 1
	if(xd == 1)
		ball_yer *= -1
	if(yd == 1)
		ball_xer *= -1
	var/r = rand(1,4)
	if(ball_xer > 0)
		ball_xer -= r
		if(ball_xer < 0)
			ball_xer = 0
	else
		if(ball_xer < 0)
			ball_xer += r
			if(ball_xer > 0)
				ball_xer = 0
	if(ball_yer > 0)
		ball_yer -= r
		if(ball_yer < 0)
			ball_yer = 0
	else
		if(ball_yer < 0)
			ball_yer += r
			if(ball_yer > 0)
				ball_yer = 0
		pixel_x = ball_lpx
		pixel_y = ball_lpy







