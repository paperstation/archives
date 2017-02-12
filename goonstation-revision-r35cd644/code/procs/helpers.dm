/proc/s_es(var/number as num, var/es = 0)
	if (isnull(number))
		return
	if (number == 1)
		return null
	else
		if (es)
			return "es"
		else
			return "s"

/proc/minmax(var/number, var/min, var/max)
	return max(min(number, max), min)

/proc/showadminlist()
	usr.client.Export("##action=browse_file","config/admins.txt")

/proc/showLine(var/atom/start, var/atom/end, s_icon_state = "lght", var/animate = 0, var/get_turfs=1) //Creates and shows a line object. Line object has an "affected" var that contains the cross tiles.
	var/angle = get_angle(start, end)
	var/anglemod = (-(angle < 180 ? angle : angle - 360) + 90) //What the fuck am i looking at
	var/lx = abs(start.x - end.x)
	var/ly = abs(start.y - end.y)
	var/beamlen = sqrt((lx * lx) + (ly * ly))
	var/obj/beam_dummy/B = new/obj/beam_dummy(get_turf(start))

	if(get_turfs) B.affected = castRay(start, anglemod, beamlen)

	B.origin_angle = angle
	B.icon_state = s_icon_state
	B.origin = start
	B.target = end

	var/matrix/M
	if(animate)
		B.transform = matrix(turn(B.transform, angle), 1, 0.1, MATRIX_SCALE)
		var/matrix/second = matrix(1, beamlen / 2, MATRIX_SCALE)
		second.Translate(1, (((beamlen / 2) * 64) / 2))
		second.Turn(angle)
		animate(B, transform = second, time = animate, loop = 1, easing = LINEAR_EASING)
	else
		M = B.transform
		M.Scale(1, beamlen / 2)
		M.Translate(1, (((beamlen/2) * 64) / 2))
		M.Turn(angle)
		B.transform = M

	return B

var/global/obj/flashDummy

/proc/getFlashDummy()
	if (!flashDummy)
		flashDummy = new /obj(null)
		flashDummy.density = 0
		flashDummy.opacity = 0
		flashDummy.anchored = 1
		flashDummy.mouse_opacity = 0
	return flashDummy

/proc/arcFlashTurf(var/atom/from, var/turf/target, var/wattage)
	var/obj/O = getFlashDummy()
	O.loc = target
	playsound(target, "sound/effects/elec_bigzap.ogg", 30, 1)

	var/list/affected = DrawLine(from, O, /obj/line_obj/elec ,'icons/obj/projectiles.dmi',"WholeLghtn",1,1,"HalfStartLghtn","HalfEndLghtn",OBJ_LAYER,1,PreloadedIcon='icons/effects/LghtLine.dmi')

	for(var/obj/Q in affected)
		spawn(6) pool(Q)

	for(var/mob/living/M in get_turf(target))
		M.shock(from, wattage, "chest", 1, 1)
	O.loc = null

/proc/arcFlash(var/atom/from, var/atom/target, var/wattage)
	playsound(target, "sound/effects/elec_bigzap.ogg", 30, 1)

	var/list/affected = DrawLine(from, target, /obj/line_obj/elec ,'icons/obj/projectiles.dmi',"WholeLghtn",1,1,"HalfStartLghtn","HalfEndLghtn",OBJ_LAYER,1,PreloadedIcon='icons/effects/LghtLine.dmi')

	for(var/obj/O in affected)
		spawn(6) pool(O)

	if(wattage && istype(target, /mob/living)) //Probably unsafe.
		target:shock(from, wattage, "chest", 1, 1)

proc/castRay(var/atom/A, var/Angle, var/Distance) //Adapted from some forum stuff. Takes some sort of bizzaro angles ?! Aahhhhh
	var/list/crossed = list()
	var/xPlus=cos(Angle)
	var/yPlus=sin(Angle)
	var/Runs=round(Distance+0.5)
	if(!isturf(A))
		if(isturf(A.loc))
			A=A.loc
		else
			return 0
	for(var/v=1 to Runs)
		set background = 1
		var/X=A.x+round((xPlus*v)+0.5)
		var/Y=A.y+round((yPlus*v)+0.5)
		var/turf/T=locate(X,Y,A.z)
		if(T)
			if(!(T in crossed)) crossed.Add(T)
	return crossed

proc/atan2(x, y)
    if(!x && !y) return 0
    return y >= 0 ? arccos(x / sqrt(x * x + y * y)) : -arccos(x / sqrt(x * x + y * y))

proc/get_angle(atom/a, atom/b)
    return atan2(b.y - a.y, b.x - a.x)

/*
proc
    //  returns an angle, [0, 360), from given offsets
    //  0 = north, increases clockwise
    atan2(x, y)
        if(!(x || y)) return 1.#IND
        if(istype(x, /list) && x:len == 2) { y = x[2]; x = x[1] }
        return x >= 0 ? arccos(y / sqrt(x * x + y * y)) : 360 - arccos(y / sqrt(x * x + y * y))
*/

//list2params without the dumb encoding
/proc/list2params_noencode(var/list/L)
	var/strbuild = ""
	var/first = 1
	for(var/x in L)
		strbuild += "[first?"":"&"][x]=[L[x]]"
		first = 0
	return strbuild

/proc/reverse_list(var/list/the_list)
	var/list/reverse = list()
	for(var/i = the_list.len, i > 0, i--)
		reverse.Add(the_list[i])
	return reverse

/turf/var/movable_area_next_type = null
/turf/var/movable_area_prev_type = null

/proc/get_steps(var/atom/ref, var/direction, var/numsteps)
	var/atom/curr = ref
	for(var/num=0, num<numsteps, num++)
		curr = get_step(curr, direction)
	return curr

/proc/movable_area_check(var/atom/A)
	if(!A.loc) return 0
	if(!A) return 0
	if(A.x > world.maxx) return 0
	if(A.x < 1) return 0
	if(A.y > world.maxy) return 0
	if(A.y < 1) return 0
	if(A.density) return 0
	for(var/atom/curr in A)
		if(curr.density) return 0
	return 1

/proc/do_mob(var/mob/user , var/atom/target as turf|obj|mob, var/time = 30) //This is quite an ugly solution but i refuse to use the old request system.
	if(!user || !target) return 0
	. = 0
	var/user_loc = user.loc
	var/target_loc = target.loc
	var/holding = user.equipped()
	sleep(time)
	if (!user || !target)
		return 0
	if ( user.loc == user_loc && target.loc == target_loc && user.equipped() == holding && !( user.stat ) && ( !user.stunned && !user.weakened && !user.paralysis && !user.lying ) )
		return 1

/proc/do_after(mob/M as mob, time as num)
	if (!ismob(M))
		return 0
	. = 0
	var/turf/T = M.loc
	var/holding = M.equipped()
	sleep(time)
	if ((M.loc == T && M.equipped() == holding && !( M.stat )))
		return 1

var/list/hasvar_type_cache = list()
/proc/hasvar(var/datum/A, var/varname)
	//Takes: Anything that could possibly have variables and a varname to check.
	//Returns: 1 if found, 0 if not.
	//Notes: Do i really need to explain this?
	if(!A) return
	. = 0
	if(A.vars.Find(varname)) . = 1

/proc/is_blocked_turf(var/turf/T)
	// drsingh for cannot read null.density
	if (!T) return 0
	. = 0
	if(T.density) . = 1
	for(var/atom/A in T)
		if(A && A.density)//&&A.anchored
			. = 1

/proc/get_edge_cheap(var/atom/A, var/direction)
	. = A.loc
	switch(direction)
		if(NORTH)
			. = locate(A.x, world.maxy, A.z)
		if(NORTHEAST)
			. = locate(world.maxx, world.maxy, A.z)
		if(EAST)
			. = locate(world.maxx, A.y, A.z)
		if(SOUTHEAST)
			. = locate(world.maxx, 1, A.z)
		if(SOUTH)
			. = locate(A.x, 1, A.z)
		if(SOUTHWEST)
			. = locate(1, 1, A.z)
		if(WEST)
			. = locate(1, A.y, A.z)
		if(NORTHWEST)
			. = locate(1, world.maxy, A.z)


/proc/hex2num(hex)

	if (!( istext(hex) ))
		CRASH("hex2num not given a hexadecimal string argument (user error)")
		return
	. = 0
	var/power = 0
	var/i = null
	i = length(hex)
	while(i > 0)
		var/char = copytext(hex, i, i + 1)
		switch(char)
			if("0")
				power++
				goto Label_290
			if("9", "8", "7", "6", "5", "4", "3", "2", "1")
				. += text2num(char) * 16 ** power
			if("a", "A")
				. += 16 ** power * 10
			if("b", "B")
				. += 16 ** power * 11
			if("c", "C")
				. += 16 ** power * 12
			if("d", "D")
				. += 16 ** power * 13
			if("e", "E")
				. += 16 ** power * 14
			if("f", "F")
				. += 16 ** power * 15
			else
				CRASH("hex2num given non-hexadecimal string (user error)")
				return
		power++
		Label_290:
		i--

/proc/num2hex(num, placeholder)

	if (placeholder == null)
		placeholder = 2
	if (!( isnum(num) ))
		CRASH("num2hex not given a numeric argument (user error)")
		return
	if (!( num ))
		return "0"
	. = ""
	var/i = 0
	while(16 ** i < num)
		i++
	var/power = null
	power = i - 1
	while(power >= 0)
		var/val = round(num / 16 ** power)
		num -= val * 16 ** power
		switch(val)
			if(9.0, 8.0, 7.0, 6.0, 5.0, 4.0, 3.0, 2.0, 1.0, 0.0)
				. += text("[]", val)
			if(10.0)
				. += "A"
			if(11.0)
				. += "B"
			if(12.0)
				. += "C"
			if(13.0)
				. += "D"
			if(14.0)
				. += "E"
			if(15.0)
				. += "F"
			else
		power--
	while(length(.) < placeholder)
		. = text("0[]", .)

/proc/invertHTML(HTMLstring)

	if (!( istext(HTMLstring) ))
		CRASH("Given non-text argument!")
		return
	else
		if (length(HTMLstring) != 7)
			CRASH("Given non-HTML argument!")
			return
	var/textr = copytext(HTMLstring, 2, 4)
	var/textg = copytext(HTMLstring, 4, 6)
	var/textb = copytext(HTMLstring, 6, 8)
	var/r = hex2num(textr)
	var/g = hex2num(textg)
	var/b = hex2num(textb)
	textr = num2hex(255 - r)
	textg = num2hex(255 - g)
	textb = num2hex(255 - b)
	if (length(textr) < 2)
		textr = text("0[]", textr)
	if (length(textg) < 2)
		textr = text("0[]", textg)
	if (length(textb) < 2)
		textr = text("0[]", textb)
	. = text("#[][][]", textr, textg, textb)

/proc/shuffle(var/list/shufflelist)
	if(!shufflelist)
		return
	. = list()
	var/list/old_list = shufflelist.Copy()
	while(old_list.len)
		var/item = pick(old_list)
		. += item
		if(old_list[item])
			.[item] = old_list[item]
		old_list -= item

/proc/uniquelist(var/list/L)
	. = list()
	for(var/item in L)
		if(!(item in .))
			. += item

/proc/sanitize(var/t)
	var/index = findtext(t, "\n")
	while(index)
		t = copytext(t, 1, index) + "#" + copytext(t, index+1)
		index = findtext(t, "\n")

	index = findtext(t, "\t")
	while(index)
		t = copytext(t, 1, index) + "#" + copytext(t, index+1)
		index = findtext(t, "\t")
	return t // fuk.

/proc/sanitize_noencode(var/t)
	var/index = findtext(t, "\n")
	while(index)
		t = copytext(t, 1, index) + "#" + copytext(t, index+1)
		index = findtext(t, "\n")

	index = findtext(t, "\t")
	while(index)
		t = copytext(t, 1, index) + "#" + copytext(t, index+1)
		index = findtext(t, "\t")
	return t

/proc/strip_html(var/t,var/limit=MAX_MESSAGE_LEN, var/no_fucking_autoparse = 0)
	t = html_decode(copytext(t,1,limit))
	if (no_fucking_autoparse == 1)
		var/list/bad_characters = list("_", "'", "\"", "<", ">", ";", "[", "]", "{", "}", "|", "\\", "/")
		for(var/c in bad_characters)
			t = dd_replacetext(t, c, "")
	var/index = findtext(t, "<")
	while(index)
		t = copytext(t, 1, index) + copytext(t, index+1)
		index = findtext(t, "<")
	index = findtext(t, ">")
	while(index)
		t = copytext(t, 1, index) + copytext(t, index+1)
		index = findtext(t, ">")
	. = sanitize(t)

/proc/adminscrub(var/t,var/limit=MAX_MESSAGE_LEN)
	t = html_decode(copytext(t,1,limit))
	var/index = findtext(t, "<")
	while(index)
		t = copytext(t, 1, index) + copytext(t, index+1)
		index = findtext(t, "<")
	index = findtext(t, ">")
	while(index)
		t = copytext(t, 1, index) + copytext(t, index+1)
		index = findtext(t, ">")
	. = html_encode(t)

/proc/add_zero(t, u)
	while (length(t) < u)
		t = "0[t]"
	. = t

/proc/add_lspace(t, u)
	while(length(t) < u)
		t = " [t]"
	. = t

/proc/add_tspace(t, u)
	while(length(t) < u)
		t = "[t] "
	. = t

/proc/trim_left(text)
	for (var/i = 1 to length(text))
		if (text2ascii(text, i) > 32)
			return copytext(text, i)
	return ""

/proc/trim_right(text)
	for (var/i = length(text), i > 0, i--)
		if (text2ascii(text, i) > 32)
			return copytext(text, 1, i + 1)

	return ""

/proc/trim(text)
	. = trim_left(trim_right(text))

/proc/capitalize(var/t as text)
	. = uppertext(copytext(t, 1, 2)) + copytext(t, 2)

/proc/sortList(var/list/L)
	if(L.len < 2)
		return L
	var/middle = L.len / 2 + 1 // Copy is first,second-1
	. = mergeLists(sortList(L.Copy(0,middle)), sortList(L.Copy(middle))) //second parameter null = to end of list

/proc/sortNames(var/list/L)
	var/list/Q = new()
	for(var/atom/x in L)
		Q[x.name] = x
	. = sortList(Q)

/proc/mergeLists(var/list/L, var/list/R)
	var/Li=1
	var/Ri=1
	. = list()
	while(Li <= L.len && Ri <= R.len)
		if(sorttext(L[Li], R[Ri]) < 1)
			var/key = R[Ri]
			var/ass = !isnum(key) ? R[key] : null //Associative lists. (also hurf durf)
			. += R[Ri++]
			if(ass) .[key] = ass
		else
			var/key = L[Li]
			var/ass = !isnum(key) ? L[key] : null //Associative lists. (also hurf durf)
			. += L[Li++]
			if(ass) .[key] = ass

	if(Li <= L.len)
		. += L.Copy(Li, 0)
	else
		. += R.Copy(Ri, 0)

/proc/dd_file2list(file_path, separator)
	if(separator == null)
		separator = "\n"
	if(isfile(file_path))
		. = file_path
	else
		. = file(file_path)
	. = dd_text2list(file2text(.), separator)

/proc/dd_range(var/low, var/high, var/num)
	. = max(low,min(high,num))

/proc/dd_replacetext(text, search_string, replacement_string)
	. = dd_text2list(text, search_string)
	. = dd_list2text(., replacement_string)

/proc/dd_replaceText(text, search_string, replacement_string)
	. = dd_text2List(text, search_string)
	. = dd_list2text(., replacement_string)

/proc/dd_hasprefix(text, prefix)
	var/start = 1
	var/end = length(prefix) + 1
	. = findtext(text, prefix, start, end)

/proc/dd_hasPrefix(text, prefix)
	var/start = 1
	var/end = length(prefix) + 1
	. = findtext(text, prefix, start, end) //was findtextEx

/proc/dd_hassuffix(text, suffix)
	var/start = length(text) - length(suffix)
	if(start)
		. = findtext(text, suffix, start, null)

/proc/dd_hasSuffix(text, suffix)
	var/start = length(text) - length(suffix)
	if(start)
		. = findtext(text, suffix, start, null) //was findtextEx

/proc/dd_text2list(text, separator, var/list/withinList)
	var/textlength = length(text)
	var/separatorlength = length(separator)
	if(withinList && !withinList.len) withinList = null
	var/list/textList = new()
	var/searchPosition = 1
	var/findPosition = 1
	while(1)
		findPosition = findtext(text, separator, searchPosition, 0)
		var/buggyText = copytext(text, searchPosition, findPosition)
		if(!withinList || (buggyText in withinList)) textList += "[buggyText]"
		if(!findPosition) return textList
		searchPosition = findPosition + separatorlength
		if(searchPosition > textlength)
			textList += ""
			return textList

/proc/dd_text2List(text, separator, var/list/withinList)
	var/textlength = length(text)
	var/separatorlength = length(separator)
	if(withinList && !withinList.len) withinList = null
	var/list/textList = new()
	var/searchPosition = 1
	var/findPosition = 1
	while(1)
		findPosition = findtextEx(text, separator, searchPosition, 0)
		var/buggyText = copytext(text, searchPosition, findPosition)
		if(!withinList || (buggyText in withinList)) textList += "[buggyText]"
		if(!findPosition) return textList
		searchPosition = findPosition + separatorlength
		if(searchPosition > textlength)
			textList += ""
			return textList

/proc/dd_list2text(var/list/the_list, separator)
	var/total = the_list.len
	if(!total)
		return
	var/count = 2
	. = "[the_list[1]]"
	while(count <= total)
		if(separator)
			. += separator
		. += "[the_list[count]]"
		count++

/proc/english_list(var/list/input, nothing_text = "nothing", and_text = " and ", comma_text = ", ", final_comma_text = "," )
	var/total = input.len
	if (!total)
		return "[nothing_text]"
	else if (total == 1)
		return "[input[1]]"
	else if (total == 2)
		return "[input[1]][and_text][input[2]]"
	else
		var/output = ""
		var/index = 1
		while (index < total)
			if (index == total - 1)
				comma_text = final_comma_text

			output += "[input[index]][comma_text]"
			index++

		return "[output][and_text][input[index]]"

/proc/dd_centertext(message, length)
	. = length(message)
	if(. == length)
		.= message
	else if(. > length)
		.= copytext(message, 1, length + 1)
	else
		var/delta = length - .
		if(delta == 1)
			. = message + " "
		else if(delta % 2)
			. = " " + message
		delta--
		var/spaces = add_lspace("",delta/2-1)
		. = spaces + . + spaces

/proc/dd_limittext(message, length)
	var/size = length(message)
	if(size <= length)
		. = message
	else
		.= copytext(message, 1, length + 1)

/proc/angle2dir(var/degree)
	. = NORTH|WEST
	degree = ((degree+22.5)%365)
	if(degree < 45)			. = NORTH
	else if(degree < 90)	. = NORTH|EAST
	else if(degree < 135)	. = EAST
	else if(degree < 180)	. = SOUTH|EAST
	else if(degree < 225)	. = SOUTH
	else if(degree < 270)	. = SOUTH|WEST
	else if(degree < 315)	. = WEST

/proc/angle2text(var/degree)
	. = dir2text(angle2dir(degree))

/proc/text_input(var/Message, var/Title, var/Default, var/length=MAX_MESSAGE_LEN)
	. = sanitize(input(Message, Title, Default) as text, length)

/proc/scrubbed_input(var/user, var/Message, var/Title, var/Default, var/length=MAX_MESSAGE_LEN)
	. = strip_html(input(user, Message, Title, Default) as null|text, length)

/proc/InRange(var/A, var/lower, var/upper)
	if(A < lower || A > upper)
		. = 0
	else
		. = 1

/proc/LinkBlocked(turf/A, turf/B)
	if(A == null || B == null) return 1
	var/adir = get_dir(A,B)
	var/rdir = get_dir(B,A)
	if((adir & (NORTH|SOUTH)) && (adir & (EAST|WEST)))	//	diagonal
		var/iStep = get_step(A,adir&(NORTH|SOUTH))
		if(!LinkBlocked(A,iStep) && !LinkBlocked(iStep,B)) return 0

		var/pStep = get_step(A,adir&(EAST|WEST))
		if(!LinkBlocked(A,pStep) && !LinkBlocked(pStep,B)) return 0
		return 1

	if(DirBlocked(A,adir)) return 1
	if(DirBlocked(B,rdir)) return 1
	return 0


/proc/DirBlocked(turf/loc,var/dir)
	for(var/obj/window/D in loc)
		if(!D.density)			continue
		if(D.dir == SOUTHWEST)	return 1
		if(D.dir == dir)		return 1

	for(var/obj/machinery/door/D in loc)
		if(!D.density)			continue
		if(istype(D, /obj/machinery/door/window))
			if((dir & SOUTH) && (D.dir & (EAST|WEST)))		return 1
			if((dir & EAST ) && (D.dir & (NORTH|SOUTH)))	return 1
		else return 1	// it's a real, air blocking door
	return 0

/proc/TurfBlockedNonWindow(turf/loc)
	for(var/obj/O in loc)
		if(O.density && !istype(O, /obj/window))
			return 1
	return 0

/proc/sign(x) //Should get bonus points for being the most compact code in the world!
	. = x!=0?x/abs(x):0 //((x<0)?-1:((x>0)?1:0))

/*	//Kelson's version (doesn't work)
/proc/getline(atom/M,atom/N)
	if(!M || !M.loc) return
	if(!N || !N.loc) return
	if(M.z != N.z) return
	var/line = new/list()

	var/dx = abs(M.x - N.x)
	var/dy = abs(M.y - N.y)
	var/cx = M.x < N.x ? 1 : -1
	var/cy = M.y < N.y ? 1 : -1
	var/slope = dy ? dx/dy : INFINITY

	var/tslope = slope
	var/turf/tloc = M.loc

	while(tloc != N.loc)
		if(tslope>0)
			--tslope
			tloc = locate(tloc.x+cx,tloc.y,tloc.z)
		else
			tslope += slope
			tloc = locate(tloc.x,tloc.y+cy,tloc.z)
		line += tloc
	return line
*/

/proc/getline(atom/M,atom/N)//Ultra-Fast Bresenham Line-Drawing Algorithm
	var/px=M.x		//starting x
	var/py=M.y
	. = list(locate(px,py,M.z))
	var/dx=N.x-px	//x distance
	var/dy=N.y-py
	var/dxabs=abs(dx)//Absolute value of x distance
	var/dyabs=abs(dy)
	var/sdx=sign(dx)	//Sign of x distance (+ or -)
	var/sdy=sign(dy)
	var/x=dxabs>>1	//Counters for steps taken, setting to distance/2
	var/y=dyabs>>1	//Bit-shifting makes me l33t.  It also makes getline() unnessecarrily fast.
	var/j			//Generic integer for counting
	if(dxabs>=dyabs)	//x distance is greater than y
		for(j=0;j<dxabs;j++)//It'll take dxabs steps to get there
			y+=dyabs
			if(y>=dxabs)	//Every dyabs steps, step once in y direction
				y-=dxabs
				py+=sdy
			px+=sdx		//Step on in x direction
			. += locate(px,py,M.z)//Add the turf to the list
	else
		for(j=0;j<dyabs;j++)
			x+=dxabs
			if(x>=dyabs)
				x-=dyabs
				px+=sdx
			py+=sdy
			. += locate(px,py,M.z)

/proc/IsGuestKey(key)
	if (findtext(key, "Guest-", 1, 7) != 1) //was findtextEx
		return 0

	var/i, ch, len = length(key)

	for (i = 7, i <= len, ++i)
		ch = text2ascii(key, i)
		if (ch != 87 && (ch < 48 || ch > 57)) // 87 is W for webclients... spec changed.
			return 0

	return 1

/proc/sanitize_frequency(var/f)
	. = round(f)
	. = max(1441, .) // 144.1
	. = min(1489, .) // 148.9
	if ((. % 2) == 0)
		. += 1

/proc/format_frequency(var/f)
	. = "[round(f / 10)].[f % 10]"

/proc/sortmobs()

	var/list/mob_list = list()
	for(var/mob/living/silicon/ai/M in mobs)
		mob_list.Add(M)
	for(var/mob/living/silicon/robot/M in mobs)
		mob_list.Add(M)
	for(var/mob/living/silicon/hivebot/M in mobs)
		mob_list.Add(M)
	for(var/mob/living/silicon/hive_mainframe/M in mobs)
		mob_list.Add(M)
	for(var/mob/living/carbon/human/M in mobs)
		mob_list.Add(M)
	for(var/mob/living/critter/C in mobs)
		if(C.client)
			mob_list.Add(C)
	for(var/mob/wraith/M in mobs)
		mob_list.Add(M)
	for(var/mob/living/intangible/blob_overmind/M in mobs)
		mob_list.Add(M)
//	for(var/mob/living/carbon/alien/M in mobs)
//		mob_list.Add(M)
	for(var/mob/dead/observer/M in mobs)
		mob_list.Add(M)
	for(var/mob/dead/target_observer/M in mobs)
		mob_list.Add(M)
	for(var/mob/new_player/M in mobs)
		mob_list.Add(M)
	for(var/mob/living/carbon/wall/M in mobs)
		mob_list.Add(M)

	return mob_list

/proc/convert2energy(var/M)
	var/E = M*(SPEED_OF_LIGHT_SQ)
	return E

/proc/convert2mass(var/E)
	var/M = E/(SPEED_OF_LIGHT_SQ)
	return M

/proc/modulus(var/M)
	if(M >= 0)
		return M
	if(M < 0)
		return -M

//Include details shows traitor status etc
//Admins replaces the src ref for links with a placeholder for message_admins
//Mentor just changes the private message link
/proc/key_name(var/whom, var/include_details = 1, var/admins = 1, var/mentor = 0)
	var/mob/the_mob = null
	var/client/the_client = null
	var/the_key = ""

	if (isnull(whom))
		return "*null*"
	else if (istype(whom, /client))
		the_client = whom
		the_mob = the_client.mob
		the_key = the_client.key
	else if (ismob(whom))
		the_mob = whom
		the_client = the_mob.client
		the_key = the_mob.key
	else if (istype(whom, /datum))
		if (istype(whom, /datum/mind))
			var/datum/mind/the_mind = whom
			the_mob = the_mind.current
			the_key = the_mind.key
			the_client = the_mind.current ? the_mind.current.client : null
			if (!the_client && the_key)
				for (var/client/C in clients)
					if (C.key == the_key || C.ckey == the_key)
						the_client = C
						break
		else
			var/datum/the_datum = whom
			return "*invalid:[the_datum.type]*"
	else //It's probably just a text string. We're ok with that.
		for (var/client/C in clients)
			if (C.key == whom || C.ckey == whom)
				the_client = C
				the_key = C.key
				if (C.mob)
					the_mob = C.mob
				break
			if (C.mob && C.mob.real_name == whom)
				the_client = C
				the_key = C.key
				the_mob = C.mob
				break

	var/text = ""

	if (!the_key)
		text += "*no client*"
	else
		if (!isnull(the_mob))
			if(!mentor) text += "<a href=\"byond://?action=priv_msg&target=[the_mob.ckey]\">"
			else text += "<a href=\"byond://?action=mentor_msg&target=[the_mob.ckey]\">"

		if (the_client)
			if (the_client.holder && the_client.stealth && !include_details)
				text += "Administrator"
			else
				text += "[the_key]"
		else
			text += "[the_key] *no client*"

		if (!isnull(the_mob))
			text += "</a>"

	//Show details for players
	if (include_details)
		if (!isnull(the_mob))
			text += "/"
			if (the_mob.real_name)
				text += the_mob.real_name
			else if (the_mob.name)
				text += the_mob.name
			text += " "
			if (the_client && !the_client.holder) //only show this stuff for non-admins because admins do a lot of shit while dead and it is unnecessary to show it
				if (checktraitor(the_mob))
					text += "\[<font color='red'>T</font>\] "
				if (the_mob.stat == 2)
					text += "\[DEAD\] "

			var/linkSrc
			if (admins)
				linkSrc = "%admin_ref%"
			else
				linkSrc = "\ref[usr.client.holder]"
			text += "<a href='byond://?src=[linkSrc]&action=adminplayeropts&targetckey=[the_mob.ckey]' class='popt'><i class='icon-info-sign'></i></a>"

	return text

// Registers the on-close verb for a browse window (client/verb/.windowclose)
// this will be called when the close-button of a window is pressed.
//
// This is usually only needed for devices that regularly update the browse window,
// e.g. canisters, timers, etc.
//
// windowid should be the specified window name
// e.g. code is	: user << browse(text, "window=fred")
// then use 	: onclose(user, "fred")
//
// Optionally, specify the "ref" parameter as the controlled atom (usually src)
// to pass a "close=1" parameter to the atom's Topic() proc for special handling.
// Otherwise, the user mob's machine var will be reset directly.
//
/proc/onclose(mob/user, windowid, var/datum/ref=null)

	var/param = "null"
	if(ref)
		param = "\ref[ref]"

	if (user && user.client) winset(user, windowid, "on-close=\".windowclose [param]\"")

	//boutput(world, "OnClose [user]: [windowid] : ["on-close=\".windowclose [param]\""]")


// the on-close client verb
// called when a browser popup window is closed after registering with proc/onclose()
// if a valid atom reference is supplied, call the atom's Topic() with "close=1"
// otherwise, just reset the client mob's machine var.
//
/client/verb/windowclose(var/atomref as text)
	set hidden = 1						// hide this verb from the user's panel
	set name = ".windowclose"			// no autocomplete on cmd line

	//boutput(world, "windowclose: [atomref]")
	if(atomref!="null")				// if passed a real atomref
		var/hsrc = locate(atomref)	// find the reffed atom
		var/href = "close=1"
		if(hsrc)
			//boutput(world, "[src] Topic [href] [hsrc]")
			usr = src.mob
			src.Topic(href, params2list(href), hsrc)	// this will direct to the atom's
			return										// Topic() proc via client.Topic()

	// no atomref specified (or not found)
	// so just reset the user mob's machine var
	if(src && src.mob)
		//boutput(world, "[src] was [src.mob.machine], setting to null")
		if(src.mob.machine && istype(src.mob.machine, /obj/machinery))
			src.mob.machine.current_user = null
		src.mob.machine = null
	return

/proc/get_turf_loc(var/mob/M) //gets the location of the turf that the mob is on, or what the mob is in is on, etc
	//in case they're in a closet or sleeper or something
	if (!M) return null
	var/atom/loc = M.loc
	while(!istype(loc, /turf/))
		if (!loc)
			break
		loc = loc.loc
	return loc

// returns the turf located at the map edge in the specified direction relative to A
// used for mass driver
/proc/get_edge_target_turf(var/atom/A, var/direction)

	var/turf/target = locate(A.x, A.y, A.z)
		//since NORTHEAST == NORTH & EAST, etc, doing it this way allows for diagonal mass drivers in the future
		//and isn't really any more complicated

		// Note diagonal directions won't usually be accurate
	if(direction & NORTH)
		target = locate(target.x, world.maxy, target.z)
	if(direction & SOUTH)
		target = locate(target.x, 1, target.z)
	if(direction & EAST)
		target = locate(world.maxx, target.y, target.z)
	if(direction & WEST)
		target = locate(1, target.y, target.z)

	return target



/proc/CompareList(var/list/biglist, var/list/smalllist)

	for(var/a in smalllist)

		if(a in biglist)

		else
			return 0

	return 1



// returns turf relative to A in given direction at set range
// result is bounded to map size
// note range is non-pythagorean
// used for disposal system
/proc/get_ranged_target_turf(var/atom/A, var/direction, var/range)

	var/x = A.x
	var/y = A.y
	if(direction & NORTH)
		y = min(world.maxy, y + range)
	if(direction & SOUTH)
		y = max(1, y - range)
	if(direction & EAST)
		x = min(world.maxx, x + range)
	if(direction & WEST)
		x = max(1, x - range)

	return locate(x,y,A.z)


// returns turf relative to A offset in dx and dy tiles
// bound to map limits
/proc/get_offset_target_turf(var/atom/A, var/dx, var/dy)
	var/x = min(world.maxx, max(1, A.x + dx))
	var/y = min(world.maxy, max(1, A.y + dy))
	return locate(x,y,A.z)

// extends pick() to associated lists
/proc/alist_pick(var/list/L)
	if(!L || !L.len)
		return null
	return L[pick(L)]

/proc/ran_zone(zone, probability)

	if (probability == null)
		probability = 90
	if (probability == 100)
		return zone
	switch(zone)
		if("chest")
			if (prob(probability))
				return "chest"
			else
				var/t = rand(1, 9)
				if (t < 3)
					return "head"
				else if (t < 6)
					return "l_arm"
				else if (t < 9)
					return "r_arm"
				else
					return "chest"

		if("head")
			if (prob(probability * 0.75))
				return "head"
			else
				if (prob(60))
					return "chest"
				else
					return "head"
		if("l_arm")
			if (prob(probability * 0.75))
				return "l_arm"
			else
				if (prob(60))
					return "chest"
				else
					return "l_arm"
		if("r_arm")
			if (prob(probability * 0.75))
				return "r_arm"
			else
				if (prob(60))
					return "chest"
				else
					return "r_arm"
		if("r_leg")
			if (prob(probability * 0.75))
				return "r_leg"
			else
				if (prob(60))
					return "chest"
				else
					return "r_leg"
		if("l_leg")
			if (prob(probability * 0.75))
				return "l_leg"
			else
				if (prob(60))
					return "chest"
				else
					return "l_leg"
	return

/proc/stars(n, pr)

	if (pr == null)
		pr = 25
	if (pr <= 0)
		return null
	else
		if (pr >= 100)
			return n
	var/te = n
	var/t = ""
	n = length(n)
	var/p = null
	p = 1
	while(p <= n)
		if ((copytext(te, p, p + 1) == " " || prob(pr)))
			t = text("[][]", t, copytext(te, p, p + 1))
		else
			t = text("[]*", t)
		p++
	return t

/proc/stutter(n)
	var/te = html_decode(n)
	var/t = ""
	n = length(n)
	var/p = null
	p = 1
	while(p <= n)
		var/n_letter = copytext(te, p, p + 1)
		if (prob(80))
			if (prob(10))
				n_letter = text("[n_letter][n_letter][n_letter][n_letter]")
			else
				if (prob(20))
					n_letter = text("[n_letter][n_letter][n_letter]")
				else
					if (prob(5))
						n_letter = null
					else
						n_letter = text("[n_letter][n_letter]")
		t = text("[t][n_letter]")
		p++
	return copytext(sanitize(t),1,MAX_MESSAGE_LEN)

/proc/shake_camera(mob/M, duration, strength=1, delay=0.2)
	spawn(1)
		if(!M || !M.client || M.shakecamera)
			return
		M.shakecamera = 1

		var/x
		var/str = strength
		for(x=0; x<duration, x++)
			M.client.pixel_x = str * 4 * pick(-1,1)
			M.client.pixel_y = str * 4 * pick(-1,1)
			str = strength * (((duration - x)/duration) ** 1.5)
			sleep(delay)
			if(!M || !M.client)
				return
		M.client.pixel_x = 0
		M.client.pixel_y = 0
		M.shakecamera = 0

/proc/findname(msg)
	for(var/mob/M in mobs)
		if (M.real_name == text("[msg]"))
			return 1
	return 0

/proc/get_cardinal_step_away(atom/start, atom/finish) //returns the position of a step from start away from finish, in one of the cardinal directions
	//returns only NORTH, SOUTH, EAST, or WEST
	var/dx = finish.x - start.x
	var/dy = finish.y - start.y
	if(abs(dy) > abs (dx)) //slope is above 1:1 (move horizontally in a tie)
		if(dy > 0)
			return get_step(start, SOUTH)
		else
			return get_step(start, NORTH)
	else
		if(dx > 0)
			return get_step(start, WEST)
		else
			return get_step(start, EAST)


/proc/parse_zone(zone)
	if (zone == "l_arm") return "left arm"
	else if (zone == "r_arm") return "right arm"
	else if (zone == "l_leg") return "left leg"
	else if (zone == "r_leg") return "right leg"
	else return zone

/proc/text2dir(direction)
	switch(uppertext(direction))
		if("NORTH")
			return NORTH
		if("SOUTH")
			return SOUTH
		if("EAST")
			return EAST
		if("WEST")
			return WEST
		if("NORTHEAST")
			return NORTHEAST
		if("NORTHWEST")
			return NORTHWEST
		if("SOUTHEAST")
			return SOUTHEAST
		if("SOUTHWEST")
			return SOUTHWEST
		else
	return

/proc/get_turf(turf/location as turf)
	while (location)
		if (istype(location, /turf))
			return location

		location = location.loc
	return null

/proc/dir2text(direction)
	switch(direction)
		if(NORTH)
			return "north"
		if(SOUTH)
			return "south"
		if(EAST)
			return "east"
		if(WEST)
			return "west"
		if(NORTHEAST)
			return "northeast"
		if(SOUTHEAST)
			return "southeast"
		if(NORTHWEST)
			return "northwest"
		if(SOUTHWEST)
			return "southwest"
		else
	return

// Marquesas: added an extra parameter to fix issue with changeling.
// Unfortunately, it has to be this extra parameter, otherwise the spawn(0) in the mob say will
// cause the mob's name to revert from the one it acquired for mimic voice.
/obj/proc/hear_talk(mob/M as mob, text, real_name)
	/*var/mob/mo = locate(/mob) in src
	if(mo)
		var/heardname = M.name
		if (real_name)
			heardname = real_name
		var/rendered = "<span class='game say'><span class='name'>[heardname]: </span> <span class='message'>[text]</span></span>"
		mo.show_message(rendered, 2)*/
	return

/proc/ishex(hex)

	if (!( istext(hex) ))
		return 0
	hex = lowertext(hex)
	var/list/hex_list = list("0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f")
	var/i = null
	i = length(hex)
	while(i > 0)
		var/char = copytext(hex, i, i + 1)
		if(!(char in hex_list))
			return 0
		i--
	return 1

/proc/format_username(var/playerName)
	if (!playerName)
		return "Unknown"

	var/list/name_temp = dd_text2list(playerName, " ")
	if (!name_temp.len)
		playerName = "Unknown"
	else if (name_temp.len == 1)
		playerName = name_temp[1]
	else //Ex: John Smith becomes JSmith
		playerName = copytext( ( copytext(name_temp[1],1, 2) + name_temp[name_temp.len] ), 1, 16)

	return lowertext(dd_replacetext(playerName, "/", null))

/proc/engineering_notation(var/value=0 as num)
	if (!value)
		return "0 "

	var/suffix = ""
	var/power = round( log(10, value) / 3)
	switch (power)
		if (-8)
			suffix = "y"
		if (-7)
			suffix = "z"
		if (-6)
			suffix = "a"
		if (-5)
			suffix = "f"
		if (-4)
			suffix = "p"
		if (-3)
			suffix = "n"
		if (-2)
			suffix = "&#956;"
		if (-1)
			suffix = "m"
		if (1)
			suffix = "k"
		if (2)
			suffix = "M"
		if (3)
			suffix = "G"
		if (4)
			suffix = "T"
		if (5)
			suffix = "P"
		if (6)
			suffix = "E"
		if (7)
			suffix = "Z"
		if (8)
			suffix = "Y"

	value = round( (value / (10 ** (3 * power))), 0.001 )
	return "[value] [suffix]"

/proc/obj_loc_chain(var/atom/movable/whose)
	if (isturf(whose) || isarea(whose))
		return list()
	if (isturf(whose.loc))
		return list()
	var/list/chain = list()
	var/atom/movable/M = whose
	while (ismob(M.loc) || isobj(M.loc))
		chain += M.loc
		M = M.loc
	return chain

/proc/all_hearers(var/range,var/centre)
	. = list()
	for(var/atom/A in view(range,centre))
		if (ismob(A))
			. += A
		if (isobj(A) || ismob(A))
			for(var/mob/M in A.contents)
				. += M

/proc/all_viewers(var/range,var/centre)
	. = list()
	for(var/atom/A in view(range,centre))
		if (ismob(A))
			. += A
		else if (isobj(A))
			for(var/mob/M in A.contents)
				. += M

/proc/all_range(var/range,var/centre) //above two are blocked by opaque objects
	. = list()
	for(var/atom/A in range(range,centre))
		if (ismob(A))
			. += A
		else if (isobj(A))
			for(var/mob/M in A.contents)
				. += M

/proc/all_view(var/range,var/centre)
	. = view(range,centre)
	for(var/obj/O in .)
		for(var/mob/M in O.contents)
			. += M

proc/pickweight(list/L)    // make this global
  var/total = 0
  var/item
  for(item in L)
    if(!L[item]) L[item] = 1    // if we didn't set a weight, call it 1
    total += L[item]
  total=rand(1, total)
  for(item in L)
    total-=L[item]
    if(total <= 0) return item
  return null   // this should never happen, but it's a fallback

 /*
/proc/shuffle(list/shuffle)
	for(var/i = 1, i <= shuffle.len, i++)
		var/pos = rand(1,shuffle.len)
		var/temp = shuffle[pos]
		shuffle[pos] = shuffle[i]
		shuffle[i] = temp
	return shuffle
*/

/proc/weightedprob(choices[], weights[])
	if(!choices || !weights) return null

	//Build a range of weights
	var/max_num = 0
	for(var/X in weights) if(isnum(X)) max_num += X

	//Now roll in the range.
	var/weighted_num = rand(1,max_num)

	var/running_total, i

	//Loop through all possible choices
	for(i = 1; i <= choices.len; i++)
		if(i > weights.len) return null

		running_total += weights[i]

		//Once the current step is less than the roll,
		// we have our winner.
		if(weighted_num <= running_total)
			return choices[i]
	return

/* Get the highest ancestor of this object in the tree that is an immediate child of
   a given ancestor.
   Usage:
   var/datum/fart/sassy/F = new
   get_top_parent(F, /datum) //returns a path to /datum/fart
   */
/proc/get_top_ancestor(var/datum/object, var/ancestor_of_ancestor=/datum)
	if(!object || !ancestor_of_ancestor)
		CRASH("Null value parameters in get top ancestor.")
	if(!ispath(ancestor_of_ancestor))
		CRASH("Non-Path ancestor of ancestor parameter supplied.")
	var/stringancestor = "[ancestor_of_ancestor]"
	var/stringtype = "[object.type]"
	var/ancestorposition = findtextEx(stringtype, stringancestor)
	if(!ancestorposition)
		return null
	var/parentstart = ancestorposition + length(stringancestor) + 1
	var/parentend = findtextEx(stringtype, "/", parentstart)
	var/stringtarget = copytext(stringtype, 1, parentend ? parentend : 0)
	return text2path(stringtarget)

/proc/check_facing(var/atom/A, var/atom/B)
	//////////// safety checks
	if(!A || !B)
		return 0

	if(A == B)
		return 0

	////////////

	if(turn(A.dir,180) == B.dir)
		//boutput(world, "[A] direction is [A.dir], [B] direction is [B.dir], [A] and [B] are facing eachother")
		return 1 // they are facing eachother


	else if(A.dir == B.dir)
		//boutput(world, "[A] direction is [A.dir], [B] direction is [B.dir], [A] and [B] are facing the same direction")
		return 2 // they are facing the same direction,

	else
		//boutput(world, "[A] direction is [A.dir], [B] direction is [B.dir], [A] and [B] are facing sides")
		return 3 // they are facing sides

//Returns a list of minds that are some type of antagonist role
//This may be a stop gap until a better solution can be figured out
/proc/get_all_enemies()
	if(ticker && ticker.mode && ticker.current_state >= GAME_STATE_PLAYING)
		var/datum/mind/enemies[] = new()
		var/datum/mind/someEnemies[] = new()

		//We gotta loop through the modes because someone thought it was a good idea to create new lists for all of them
		if (istype(ticker.mode, /datum/game_mode/revolution))
			someEnemies = ticker.mode:head_revolutionaries
			for(var/datum/mind/M in someEnemies)
				if (M.current)
					enemies += M
			someEnemies = ticker.mode:revolutionaries
			for(var/datum/mind/M in someEnemies)
				if (M.current)
					enemies += M
			someEnemies = ticker.mode:get_all_heads()
			for(var/datum/mind/M in someEnemies)
				if (M.current)
					enemies += M
		else if (istype(ticker.mode, /datum/game_mode/nuclear))
			someEnemies = ticker.mode:syndicates
			for(var/datum/mind/M in someEnemies)
				if (M.current)
					enemies += M
		else if (istype(ticker.mode, /datum/game_mode/spy))
			someEnemies = ticker.mode:spies
			for(var/datum/mind/M in someEnemies)
				if (M.current)
					enemies += M
			someEnemies = ticker.mode:leaders
			for(var/datum/mind/M in someEnemies)
				if (M.current)
					enemies += M
		else if (istype(ticker.mode, /datum/game_mode/gang))
			someEnemies = ticker.mode:leaders
			for(var/datum/mind/M in someEnemies)
				if (M.current)
					enemies += M
					for(var/datum/mind/G in M.gang.members) //This may be fucked. Dunno how these are stored.
						enemies += G

		//Lists we grab regardless of game type
		//Traitors list is populated during traitor or mixed rounds, however it is created along with the game_mode datum unlike the rest of the lists
		someEnemies = ticker.mode.traitors
		for(var/datum/mind/M in someEnemies)
			if (M.current)
				enemies += M

		//Sometimes admins assign traitors, this contains those dudes
		someEnemies = ticker.mode.Agimmicks
		for(var/datum/mind/M in someEnemies)
			if (M.current)
				enemies += M

		return enemies

	else
		return 0

/proc/GetRedPart(hex)
    hex = uppertext(hex)
    var
        hi = text2ascii(hex, 2)
        lo = text2ascii(hex, 3)
    return ( ((hi >= 65 ? hi-55 : hi-48)<<4) | (lo >= 65 ? lo-55 : lo-48) )

/proc/GetGreenPart(hex)
    hex = uppertext(hex)
    var
        hi = text2ascii(hex, 4)
        lo = text2ascii(hex, 5)
    return ( ((hi >= 65 ? hi-55 : hi-48)<<4) | (lo >= 65 ? lo-55 : lo-48) )

/proc/GetBluePart(hex)
    hex = uppertext(hex)
    var
        hi = text2ascii(hex, 6)
        lo = text2ascii(hex, 7)
    return ( ((hi >= 65 ? hi-55 : hi-48)<<4) | (lo >= 65 ? lo-55 : lo-48) )

/proc/GetColors(hex)
    hex = uppertext(hex)
    var
        hi1 = text2ascii(hex, 2)
        lo1 = text2ascii(hex, 3)
        hi2 = text2ascii(hex, 4)
        lo2 = text2ascii(hex, 5)
        hi3 = text2ascii(hex, 6)
        lo3 = text2ascii(hex, 7)
    return list(((hi1>= 65 ? hi1-55 : hi1-48)<<4) | (lo1 >= 65 ? lo1-55 : lo1-48),
        ((hi2 >= 65 ? hi2-55 : hi2-48)<<4) | (lo2 >= 65 ? lo2-55 : lo2-48),
        ((hi3 >= 65 ? hi3-55 : hi3-48)<<4) | (lo3 >= 65 ? lo3-55 : lo3-48))

//Shoves a jump to link or whatever in the thing :effort:
/proc/showCoords(x, y, z, plaintext, holder)
	var text
	if (plaintext)
		text += "[x], [y], [z]"
	else
		text += "<a href='?src=[holder ? "\ref[holder]" : "%admin_ref%"];action=jumptocoords;target=[x],[y],[z]' title='Jump to Coords'>[x],[y],[z]</a>"

	return text

// hi I'm haine -throws more crap onto the pile-
/proc/rand_deci(var/num1 = 1, var/num2 = 0, var/num3 = 2, var/num4 = 0)
// input num1.num2 and num3.num4 returns a random number between them
	var/output = text2num("[rand(num1, num2)].[rand(num3, num4)]")
	return output

var/list/easing_types = list(
"Linear/0" = LINEAR_EASING,
"Sine/1" = SINE_EASING,
"Circular/2" = CIRCULAR_EASING,
"Cubic/3" = CUBIC_EASING,
"Bounce/4" = BOUNCE_EASING,
"Elastic/5" = ELASTIC_EASING,
"Back/6" = BACK_EASING)

var/list/blend_types = list(
"Default/0" = BLEND_DEFAULT,
"Overlay/1" = BLEND_OVERLAY,
"Add/2" = BLEND_ADD,
"Subtract/3" = BLEND_SUBTRACT,
"Multipy/4" = BLEND_MULTIPLY)

var/list/hexpick = list("0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F")

var/list/all_functional_reagent_ids = list()

proc/get_all_functional_reagent_ids()
	var/datum/reagent/Read = null
	for (var/X in typesof(/datum/reagent))
		Read = new X
		all_functional_reagent_ids += Read.id
		spawn(0)
			del Read

proc/reagent_id_to_name(var/reagent_id)
	if (!reagent_id || !reagents_cache.len)
		return
	var/datum/reagent/R = reagents_cache[reagent_id]
	if (!R)
		return "nothing"
	else
		return R.name

proc/GetOppositeDirection(var/X)
	if (!isnum(X))
		return 1
	switch(X)
		if(1) return 2
		if(2) return 1
		if(4) return 8
		if(8) return 4
		if(5) return 10
		if(6) return 9
		if(9) return 6
		if(10) return 5

proc/GetOppositeHorizontalDirection(var/X)
	if (!isnum(X))
		return 1
	switch(X)
		if(4) return 8
		if(8) return 4
		if(5) return 9
		if(6) return 10
		if(9) return 5
		if(10) return 6

proc/GetOppositeVerticalDirection(var/X)
	if (!isnum(X))
		return 1
	switch(X)
		if(1) return 2
		if(2) return 1
		if(5) return 6
		if(6) return 5
		if(9) return 10
		if(10) return 9

proc/RarityClassRoll(var/scalemax = 100, var/mod = 0, var/list/category_boundaries)
	if (!isnum(scalemax) || scalemax <= 0)
		return 0
	if (!isnum(mod))
		return 0
	if (category_boundaries.len <= 0)
		return 0

	var/picker = rand(1,scalemax)
	picker += mod
	var/list_counter = category_boundaries.len

	for (var/X in category_boundaries)
		if (!isnum(X))
			return 1
		if (picker >= X)
			return list_counter + 1
		list_counter--

	return 1

/proc/circular_range(var/atom/A,var/size)
	if (!A || !isnum(size) || size <= 0)
		return list()

	var/list/turfs = list()
	var/turf/center = get_turf(A)

	var/corner_range = round(size * 1.5)
	var/total_distance = 0
	var/current_range = 0

	while (current_range < size - 1)
		current_range++
		total_distance = 0
		for (var/turf/T in range(size,center))
			if (get_dist(T,center) == current_range)
				total_distance = abs(center.x - T.x) + abs(center.y - T.y) + (current_range / 2)
				if (total_distance > corner_range)
					continue
				turfs += T

	return turfs

/proc/get_x_percentage_of_y(var/x,var/y)
	if (!isnum(x) || !isnum(y) || x == 0 || y == 0)
		return 0
	return (x / y) * 100

/proc/get_damage_after_percentage_based_armor_reduction(var/armor,var/damage)
	if (!isnum(armor) || !isnum(damage) || damage <= 0)
		return 0
	// [13:22] <volundr> it would be ( (100 - armorpercentage) / 100 ) * damageamount
	armor = max(0,min(armor,100))
	return ((100 - armor) / 100) * damage

/proc/get_filtered_atoms_in_touch_range(var/atom/center,var/filter)
	if (!center)
		return list()

	var/list/list_to_return = list()
	var/target_loc = get_turf(center)

	for(var/atom/A in range(1,target_loc))
		if (ispath(filter))
			if (istype(A,filter))
				list_to_return += A
		else
			list_to_return += A

	for(var/atom/B in center.contents)
		if (ispath(filter))
			if (istype(B,filter))
				list_to_return += B
		else
			list_to_return += B

	return list_to_return

/proc/random_color_hex()
	var/string_to_return = "#"
	var/loops = 6
	while (loops > 0)
		loops--
		string_to_return += pick(hexpick)

	//boutput(world, "random color hex returning [string_to_return]")
	return string_to_return

/proc/is_valid_color_string(var/string)
	if (!istext(string))
		return 0
	if (lentext(string) != 7)
		return 0
	if (copytext(string,1,2) != "#")
		return 0
	if (!ishex(copytext(string,2,8)))
		return 0
	return 1

/proc/get_digit_from_number(var/number,var/slot)
	// note this works "backwards", so slot 1 of 52964 would be 4, not 5
	if(!isnum(number))
		return 0
	var/string = num2text(number)
	string = reverse_text(string)
	return text2num(copytext(string,slot,slot+1))

/proc/o_clock_time()
	var/get_hour = text2num(time2text(world.timeofday, "hh"))
	var/final_hour = get_hour
	if (get_hour > 12)
		final_hour = (get_hour - 12)

	var/get_minutes = text2num(time2text(world.timeofday, "mm"))
	var/final_minutes = "[get_english_num(get_minutes)] minutes past "
	switch (get_minutes)
		if (0)
			final_minutes = ""
		if (1)
			final_minutes = "[get_english_num(get_minutes)] minute past "
		if (15)
			final_minutes = "quarter past "
		if (30)
			final_minutes = "half past "
		if (45)
			if (get_hour > 12)
				final_hour = (get_hour - 11)
			else
				final_hour = (get_hour + 1)
			final_minutes = "quarter 'til "

	var/the_time = "[final_minutes][get_english_num(final_hour)] o'clock"
	return the_time

/proc/antag_token_list() //List of all players redeeming antagonist tokens
	var/list/token_list = list()
	for(var/mob/new_player/player in mobs)
		if((player.client) && (player.ready) && ((player.client.using_antag_token)))
			token_list += player.mind
	if (!token_list.len)
		return 0
	else
		return token_list

/proc/strip_bad_characters(var/text)
	var/list/bad_characters = list("_", "'", "\"", "<", ">", ";", "[", "]", "{", "}", "|", "\\", "/")
	for(var/c in bad_characters)
		text = dd_replacetext(text, c, " ")
	return text

var/list/english_num = list("0" = "zero", "1" = "one", "2" = "two", "3" = "three", "4" = "four", "5" = "five", "6" = "six", "7" = "seven", "8" = "eight", "9" = "nine",\
"10" = "ten", "11" = "eleven", "12" = "twelve", "13" = "thirteen", "14" = "fourteen", "15" = "fifteen", "16" = "sixteen", "17" = "seventeen", "18" = "eighteen", "19" = "nineteen",\
"20" = "twenty", "30" = "thirty", "40" = "forty", "50" = "fifty", "60" = "sixty", "70" = "seventy", "80" = "eighty", "90" = "ninety")

/proc/get_english_num(var/num, var/sep) // can only do up to 999,999 because of scientific notation kicking in after 6 digits
	if (!num || !english_num.len)
		return

	DEBUG("<b>get_english_num recieves num \"[num]\"</b>")

	if (istext(num))
		num = text2num(num)

	var/num_return = null

	if (num == 0) // 0
		num_return = "[english_num["[num]"]]"

	else if ((num >= 1) && (num <= 20)) // 1 to 20
		num_return = "[english_num["[num]"]]"

	else if ((num > 20) && (num < 100)) // 21 to 99
		var/tens = text2num(copytext("[num]", 1, 2)) * 10
		var/ones = text2num(copytext("[num]", 2))
		if (ones <= 0)
			num_return = "[english_num["[tens]"]]"
		else
			num_return = "[english_num["[tens]"]][sep ? sep : " "][english_num["[ones]"]]"

	else if ((num >= 100) && (num < 1000)) // 100 to 999
		var/hundreds = text2num(copytext("[num]", 1, 2))
		var/tens = text2num(copytext("[num]", 2))
		if (tens <= 0)
			num_return = "[english_num["[hundreds]"]] hundred"
		else
			num_return = "[english_num["[hundreds]"]] hundred and [get_english_num(tens)]"

	else if ((num >= 1000) && (num < 1000000)) // 1,000 to 999,999
		var/thousands = null
		var/hundreds = null

		switch (num)
			if (1000 to 9999)
				thousands = text2num(copytext("[num]", 1, 2))
				hundreds = text2num(copytext("[num]", 2))
			if (10000 to 999999)
				thousands = text2num(copytext("[num]", 1, 3))
				hundreds = text2num(copytext("[num]", 3))
			if (100000 to 999999)
				thousands = text2num(copytext("[num]", 1, 4))
				hundreds = text2num(copytext("[num]", 4))

		if (hundreds <= 0)
			num_return = "[get_english_num(thousands)] thousand"
		else if (hundreds < 100)
			num_return = "[get_english_num(thousands)] thousand and [get_english_num(hundreds)]"
		else
			num_return = "[get_english_num(thousands)] thousand, [get_english_num(hundreds)]"

	if (num_return)
		DEBUG("<b>get_english_num returns num \"[num_return]\"</b>")
		return num_return

/proc/mutual_attach(var/atom/A as turf|obj|mob, var/atom/B as turf|obj|mob)
	if (!A || !B)
		return
	if (A:anchored || B:anchored)
		A:anchored = 1
		B:anchored = 1
	if (!(B in A.attached_objs))
		A.attached_objs.Add(B)
	if (!(A in B.attached_objs))
		B.attached_objs.Add(A)

/proc/mutual_detach(var/atom/A as turf|obj|mob, var/atom/B as turf|obj|mob)
	if (!A || !B)
		return
	A:anchored = initial(A:anchored)
	B:anchored = initial(B:anchored)
	if (B in A.attached_objs)
		A.attached_objs.Remove(B)
	if (A in B.attached_objs)
		B.attached_objs.Remove(A)

/proc/hex2rgb(var/hex)
	if (!hex)
		return
	var/adj = 0
	if (copytext(hex, 1, 2) == "#")
		adj = 1

	var/hR = hex2num(copytext(hex, 1 + adj, 3 + adj))
	var/hG = hex2num(copytext(hex, 3 + adj, 5 + adj))
	var/hB = hex2num(copytext(hex, 5 + adj, 7 + adj))
	//DEBUG("hex2rgb translates [hex] to r[hR] g[hG] b[hB]")
	return rgb(hR,hG,hB,255)

// This function counts a passed job.
proc/countJob(rank)
	var/jobCount = 0
	for(var/mob/H in mobs)
		if(H.mind && H.mind.assigned_role == rank)
			jobCount++
		sleep(-1)
	return jobCount

//alldirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
/atom/proc/letter_overlay(var/letter as text, var/lcolor, var/dir)
	if (!letter) // you get something random you shithead
		letter = pick("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z")
	if (!dir)
		dir = NORTHEAST
	if (!lcolor)
		lcolor = rgb(rand(0,255),rand(0,255),rand(0,255))
	var/image/B = image('icons/effects/letter_overlay.dmi', loc = src, icon_state = "[letter]2")
	var/image/L = image('icons/effects/letter_overlay.dmi', loc = src, icon_state = letter)
	B.color = lcolor
	var/px = 0
	var/py = 0

	if (dir & (EAST | WEST))
		px = 11
		if (dir & WEST)
			px *= -1

	if (dir & (NORTH | SOUTH))
		py = 11
		if (dir & SOUTH)
			py *= -1

	B.pixel_x = px
	L.pixel_x = px

	B.pixel_y = py
	L.pixel_y = py

	src.overlays += B
	src.overlays += L
	return

/atom/proc/debug_loverlay()
	var/letter = input(usr, "Please select a letter icon to display.", "Select Letter", "A") as null|anything in list("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z")
	if (!letter)
		return
	var/lcolor = input(usr, "Please enter a color for the icon.", "Input Color", "#FFFFFF") as null|text
	if (!lcolor)
		return
	var/dir = input(usr, "Please select a direction for the icon to display.", "Select Direction", "NORTHEAST") as null|anything in list("NORTH", "SOUTH", "EAST", "WEST", "NORTHEAST", "NORTHWEST", "SOUTHEAST", "SOUTHWEST")
	if (!dir)
		return
	src.letter_overlay(letter, lcolor, text2dir(dir))

// Returns a list of eligible dead players to be respawned as an antagonist or whatever (Convair880).
// Text messages: 1: alert | 2: alert (chatbox) | 3: alert acknowledged (chatbox) | 4: no longer eligible (chatbox) | 5: waited too long (chatbox)
/proc/dead_player_list(var/return_minds = 0, var/confirmation_spawn = 0, var/list/text_messages = list())
	var/list/candidates = list()

	// Confirmation delay specified, so prompt eligible dead mobs and wait for response.
	if (confirmation_spawn > 0)
		var/ghost_timestamp = world.time

		// Preliminary work.
		var/text_alert = "Would you like to be respawned? Your name will be added to the list of eligible candidates and may be selected at random by the game."
		var/text_chat_alert = "You are eligible to be respawned. You have [confirmation_spawn / 10] seconds to respond to the offer."
		var/text_chat_added = "You have been added to the list of eligible candidates. The game will pick a player soon. Good luck!"
		var/text_chat_failed = "You are no longer eligible for the offer."
		var/text_chat_toolate = "You have waited too long to respond to the offer."

		if (text_messages.len)
			if (text_messages.len >= 1) text_alert = text_messages[1]
			if (text_messages.len >= 2) text_chat_alert = text_messages[2]
			if (text_messages.len >= 3) text_chat_added = text_messages[3]
			if (text_messages.len >= 4) text_chat_failed = text_messages[4]
			if (text_messages.len >= 5) text_chat_toolate = text_messages[5]

		text_alert = strip_html(text_alert, MAX_MESSAGE_LEN, 1)
		text_chat_alert = "<span style=\"color:blue\"><h3>[strip_html(text_chat_alert, MAX_MESSAGE_LEN)]</h3></span>"
		text_chat_added = "<span style=\"color:blue\"><h3>[strip_html(text_chat_added, MAX_MESSAGE_LEN)]</h3></span>"
		text_chat_failed = "<span style=\"color:red\"><b>[strip_html(text_chat_failed, MAX_MESSAGE_LEN)]</b></span>"
		text_chat_toolate = "<span style=\"color:red\"><b>[strip_html(text_chat_toolate, MAX_MESSAGE_LEN)]</b></span>"

		// Run prompts. Minds are preferable to mob references because of the confirmation delay.
		for (var/datum/mind/M in ticker.minds)
			if (M.current)
				if (dead_player_list_helper(M.current) != 1)
					continue

				spawn (0) // Don't lock up the entire proc.
					M.current << csound("sound/misc/klaxon.ogg")
					boutput(M.current, text_chat_alert)

					if (alert(M.current, text_alert, "Respawn", "Yes", "No") == "Yes")
						if (ghost_timestamp && world.time > ghost_timestamp + confirmation_spawn)
							if (M.current) boutput(M.current, text_chat_toolate)
							return
						if (dead_player_list_helper(M.current) != 1)
							if (M.current) boutput(M.current, text_chat_failed)
							return

						if (M.current && !(M in candidates))
							boutput(M.current, text_chat_added)
							candidates.Add(M)
					else
						return

		while (ghost_timestamp && world.time < ghost_timestamp + confirmation_spawn)
			sleep (300)

		// Filter list again.
		if (candidates.len)
			for (var/datum/mind/M2 in candidates)
				if (!M2.current || !ismob(M2.current) || dead_player_list_helper(M2.current) != 1)
					candidates.Remove(M2)
					continue

			if (candidates.len)
				if (return_minds == 1)
					return candidates
				else
					var/list/mob/mobs = list()
					for (var/datum/mind/M3 in candidates)
						if (M3.current && ismob(M3.current))
							if (!(M3.current in mobs))
								mobs.Add(M3.current)

					if (mobs.len)
						return mobs
					else
						return list()
			else
				return list()
		else
			return list()

	// Confirmationd delay not specified, return list right away.
	candidates = list()

	for (var/mob/O in mobs)
		if (dead_player_list_helper(O) != 1)
			continue
		if (!(O in candidates))
			candidates.Add(O)

	if (return_minds == 1)
		var/list/datum/mind/minds = list()
		for (var/mob/M2 in candidates)
			if (M2.mind && !(M2.mind in minds))
				minds.Add(M2.mind)

		if (minds.len > 0)
			return minds
		else
			return list()

	if (!candidates.len)
		return list()
	else
		return candidates

// So there aren't multiple instances of C&P code (Convair880).
/proc/dead_player_list_helper(var/mob/G)
	if (!G || !ismob(G))
		return 0
	if (!istype(G, /mob/dead) && !(istype(G, /mob/living) && G.stat == 2))
		return 0
	if (istype(G, /mob/new_player) || G.respawning)
		return 0
	if (jobban_isbanned(G, "Syndicate"))
		return 0
	if (jobban_isbanned(G, "Special Respawn"))
		return 0

	if (istype(G, /mob/dead))
		var/mob/dead/observer/the_ghost = null
		if (isobserver(G))
			the_ghost = G
		if (istype(G, /mob/dead/target_observer))
			var/mob/dead/target_observer/TO = G
			if (TO.my_ghost && isobserver(TO.my_ghost))
				the_ghost = TO.my_ghost
		if (!the_ghost || !isobserver(the_ghost) || the_ghost.stat != 2 || the_ghost.observe_round)
			return 0

	if (!G.client || G.client && (G.client.suicide || G.client.holder)) // Admins can respawn and make themselves antagonists at any time.
		return 0
	if (!G.mind || G.mind && (G.mind.dnr || !isnull(G.mind.special_role) || G.mind.former_antagonist_roles.len)) // Dead antagonists have had their chance.
		return 0

	return 1

/proc/check_target_immunity(var/atom/target, var/ignore_everything_but_nodamage = 0)
	var/is_immune = 0

	if (isliving(target))
		var/mob/living/L = target

		if (L.stat != 2)
			if (ignore_everything_but_nodamage == 1)
				if (L.nodamage)
					is_immune = 1
			else
				if (L.nodamage || L.spellshield)
					is_immune = 1

	//if (is_immune == 1)
	//	DEBUG("[L] is immune to damage, aborting.")
	return is_immune

// Their antag status is revoked on death/implant removal/expiration, but we still want them to show up in the game over stats (Convair880).
/proc/remove_mindslave_status(var/mob/M, var/slave_type ="", var/removal_type ="")
	if (!M || !M.mind || !slave_type || !removal_type)
		return

	// Find our master's mob reference (if any).
	var/mob/mymaster = whois_ckey_to_mob_reference(M.mind.master)

	switch (slave_type)
		if ("mslave")
			switch (removal_type)
				if ("expired")
					logTheThing("combat", M, mymaster, "'s mindslave implant (implanted by [mymaster ? "%target%" : "*NOKEYFOUND*"]) has worn off.")
				if ("surgery")
					logTheThing("combat", M, mymaster, "'s mindslave implant (implanted by [mymaster ? "%target%" : "*NOKEYFOUND*"]) was removed surgically.")
				if ("override")
					logTheThing("combat", M, mymaster, "'s mindslave implant (implanted by [mymaster ? "%target%" : "*NOKEYFOUND*"]) was overridden by a different implant.")
				if ("death")
					logTheThing("combat", M, mymaster, "(implanted by [mymaster ? "%target%" : "*NOKEYFOUND*"]) has died, removing mindslave status.")
				else
					logTheThing("combat", M, mymaster, "'s mindslave implant (implanted by [mymaster ? "%target%" : "*NOKEYFOUND*"]) has vanished mysteriously.")

			remove_antag(M, null, 1, 0)
			if (M.mind && ticker.mode && !(M.mind in ticker.mode.former_antagonists))
				if (!M.mind.former_antagonist_roles.Find("mindslave"))
					M.mind.former_antagonist_roles.Add("mindslave")
				ticker.mode.former_antagonists += M.mind

		if ("vthrall")
			switch (removal_type)
				if ("death")
					logTheThing("combat", M, mymaster, "(enthralled by [mymaster ? "%target%" : "*NOKEYFOUND*"]) has died, removing vampire thrall status.")
				else
					logTheThing("combat", M, mymaster, "(enthralled by [mymaster ? "%target%" : "*NOKEYFOUND*"]) has been freed mysteriously, removing vampire thrall status.")

			remove_antag(M, null, 1, 0)
			if (M.mind && ticker.mode && !(M.mind in ticker.mode.former_antagonists))
				if (!M.mind.former_antagonist_roles.Find("vampthrall"))
					M.mind.former_antagonist_roles.Add("vampthrall")
				ticker.mode.former_antagonists += M.mind

		// This is only used for spy slaves and mindslaved antagonists at the moment.
		if ("otherslave")
			switch (removal_type)
				if ("expired")
					logTheThing("combat", M, mymaster, "'s mindslave implant (implanted by [mymaster ? "%target%" : "*NOKEYFOUND*"]) has worn off.")
				if ("surgery")
					logTheThing("combat", M, mymaster, "'s mindslave implant (implanted by [mymaster ? "%target%" : "*NOKEYFOUND*"]) was removed surgically.")
				if ("override")
					logTheThing("combat", M, mymaster, "'s mindslave implant (implanted by [mymaster ? "%target%" : "*NOKEYFOUND*"]) was overridden by a different implant.")
				if ("death")
					logTheThing("combat", M, mymaster, "(enslaved by [mymaster ? "%target%" : "*NOKEYFOUND*"]) has died, removing mindslave status.")
				else
					logTheThing("combat", M, mymaster, "(enslaved by [mymaster ? "%target%" : "*NOKEYFOUND*"]) has been freed mysteriously, removing mindslave status.")

			// Fix for mindslaved traitors etc losing their antagonist status.
			if (M.mind && (M.mind.special_role == "spyslave"))
				remove_antag(M, null, 1, 0)
			else
				M.mind.master = null
			if (M.mind && ticker.mode && !(M.mind in ticker.mode.former_antagonists))
				if (!M.mind.former_antagonist_roles.Find("mindslave"))
					M.mind.former_antagonist_roles.Add("mindslave")
				ticker.mode.former_antagonists += M.mind

		else
			logTheThing("debug", M, null, "<b>Convair880</b>: [M] isn't a mindslave or vampire thrall, can't remove mindslave status.")
			return

	if (removal_type == "death")
		boutput(M, "<h2><span style=\"color:red\">Since you have died, you are no longer a mindslave! Do not obey your former master's orders even if you've been brought back to life somehow.</span></h2>")
		M << browse(grabResource("html/mindslave/death.html"),"window=antagTips;titlebar=1;size=600x400;can_minimize=0;can_resize=0")
	else if (removal_type == "override")
		boutput(M, "<h2><span style=\"color:red\">Your mindslave implant has been overridden by a new one, cancelling out your former allegiances!</span></h2>")
		M << browse(grabResource("html/mindslave/override.html"),"window=antagTips;titlebar=1;size=600x400;can_minimize=0;can_resize=0")
	else
		boutput(M, "<h2><span style=\"color:red\">Your mind is your own again! You no longer feel the need to obey your former master's orders.</span></h2>")
		M << browse(grabResource("html/mindslave/expire.html"),"window=antagTips;titlebar=1;size=600x400;can_minimize=0;can_resize=0")

	return

//Looks up a player based on a string. Searches a shit load of things ~whoa~. Returns a list of mob refs.
/proc/whois(target, limit = 0, admin)
	target = trim(lowertext(target))
	if (!target) return 0
	var/list/found = list()
	for (var/mob/M in mobs)
		if (M.ckey && (limit == 0 || found.len < limit))
			if (findtext(M.real_name, target))
				found += M
			else if (findtext(M.ckey, target))
				found += M
			else if (findtext(M.key, target))
				found += M
			else if (M.mind)
				if (findtext(M.mind.assigned_role, target))
					if (M.mind.assigned_role == "MODE") //We matched on the internal MODE job this doesn't fuckin' count
						continue
					else
						found += M
				else if (findtext(M.mind.special_role, target))
					found += M

	if (found.len > 0)
		return found
	else
		return 0

// An universal ckey -> mob reference lookup proc, adapted from whois() (Convair880).
/proc/whois_ckey_to_mob_reference(target as text)
	if (!target || isnull(target))
		return 0
	target = lowertext(target)
	var/mob/our_mob
	for (var/mob/M in mobs)
		if ((!isnull(M.ckey) && !isnull(target)) && findtext(M.ckey, target))
			//DEBUG("Whois: match found for [target], it's [M].")
			our_mob = M
			break
	if (our_mob) return our_mob
	else return 0

/proc/random_hex(var/digits as num)
	var/list/hex_chars = list("1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "A", "B", "C", "D", "E", "F") // this way numbers like 000F04 are possible
	if (!digits)
		digits = 6
	var/return_hex = ""
	for (var/i = 0, i < digits, i++)
		return_hex += pick(hex_chars)
	return return_hex

//A global cooldown on this so it doesnt destroy the external server
var/global/nextDectalkDelay = 5 //seconds
var/global/lastDectalkUse = 0
/proc/dectalk(msg)
	if (!msg) return 0
	if (world.timeofday > (lastDectalkUse + (nextDectalkDelay * 10)))
		lastDectalkUse = world.timeofday
		msg = copytext(msg, 1, 2000)
		var/res[] = world.Export("http://tts.spess.cf/tts?words=[url_encode(msg)]")
		if (!res || !res["CONTENT"])
			return 0

		var/audio = file2text(res["CONTENT"])
		return list("audio" = audio, "message" = msg)
	else
		return list("cooldown" = 1)

proc/copy_datum_vars(var/atom/from, var/atom/target)
	if (!target || !from) return
	for(var/V in from.vars)
		if (!issaved(from.vars[V]))
			continue

		if(V == "type") continue
		if(V == "parent_type") continue
		if(V == "vars") continue
		target.vars[V] = from.vars[V]

/proc/hex2color_name(var/hex)
	if (!hex)
		return
	var/adj = 0
	if (copytext(hex, 1, 2) == "#")
		adj = 1

	var/hR = hex2num(copytext(hex, 1 + adj, 3 + adj))
	var/hG = hex2num(copytext(hex, 3 + adj, 5 + adj))
	var/hB = hex2num(copytext(hex, 5 + adj, 7 + adj))

	var/datum/color/C = new(hR, hG, hB, 0)
	var/name = get_nearest_color(C)
	if (name)
		return name

var/list/uppercase_letters = list("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z")
var/list/lowercase_letters = list("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z")

// Helper for blob, wraiths and whoever else might need them (Convair880).
/proc/restricted_z_allowed(var/mob/M, var/T)
	var/list/allowed = list()
	for (var/areas in typesof(/area/shuttle/escape))
		if (!allowed.Find(areas))
			allowed.Add(areas)
	for (var/areas2 in typesof(/area/shuttle_transit_space))
		if (!allowed.Find(areas2))
			allowed.Add(areas2)

	if (M && istype(M, /mob/living/intangible/blob_overmind))
		var/mob/living/intangible/blob_overmind/B = M
		if (B.tutorial)
			return 1

	var/area/A
	if (T && istype(T, /area))
		A = T
	else if (T && isturf(T))
		A = get_area(T)

	if (A && istype(A) && (A.type in allowed))
		return 1
	return 0

// What sonic grenades and similar functions use. It's a proc to avoid C&P code (Convair880).
/proc/sonic_attack_environmental_effect(var/center, var/range, var/list/smash)
	if (!center || !isnum(range) || range <= 0)
		return 0

	if (!islist(smash) || !smash.len)
		return 0

	var/turf/CT
	if (isturf(center))
		CT = center
	else if (istype(center, /atom))
		CT = get_turf(center)

	if (!(CT && isturf(CT)))
		return 0

	// No visible_messages here because of text spam. The station has a lot of windows and light fixtures.
	// And once again, view() proved quite unreliable.
	for (var/S in smash)
		if (S == "window")
			for (var/obj/window/W in range(CT, range))
				if (istype(W, /obj/window/reinforced))
					continue
				if (prob(get_dist(W, CT) * 6))
					continue
				W.health = 0
				W.smash()

		if (S == "r_window")
			for (var/obj/window/reinforced/R in range(CT, range))
				if (prob(get_dist(R, CT) * 7))
					continue
				R.health = 0
				R.smash()

		if (S == "light")
			for (var/obj/machinery/light/L in range(CT, range))
				L.broken()

		if (S == "displaycase")
			for (var/obj/displaycase/D in range(CT, range))
				D.ex_act(1)

		if (S == "glassware")
			for (var/obj/item/reagent_containers/glass/G in range(CT, range))
				G.smash()
			for (var/obj/item/reagent_containers/food/drinks/drinkingglass/G2 in range(CT, range))
				G2.smash()

	return 1

/proc/get_hud_style(var/someone)
	if (!someone)
		return
	var/client/C = null
	if (isclient(someone))
		C = someone
	else if (ismob(someone))
		var/mob/M = someone
		if (M.client)
			C = M.client
	if (!C || !C.preferences)
		return
	return C.preferences.hud_style