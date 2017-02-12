/datum/clipboardTurf
	var/rel_x = 0
	var/rel_y = 0
	var/turf_type = null
	var/turf_icon = null
	var/list/objects = list()

/datum/buildmode/clipboard_wide
	name = "Wide Area Clipboard"
	desc = {"***********************************************************<br>
Ctrl + RMB on buildmode button         = Reset (if the copier bugs up)<br>
Left Mouse Button                      = Paste selected area. Selected tile will be the LOWER LEFT corner.<br>
Right Mouse Button                     = Select area to copy with two clicks<br>
***********************************************************"}
	icon_state = "buildmode11"
	var/turf/A
	var/list/clipboard = list()
	var/copying = 0

	deselected()
		..()
		A = null
		copying = 0

	click_mode_right(var/ctrl, var/alt, var/shift)
		if (ctrl)
			A = null
			copying = 0
			clipboard.len = 0
			boutput(usr, "<span style=\"color:red\">Reset.</span>")

	click_left(atom/object, var/ctrl, var/alt, var/shift)
		if (!clipboard.len)
			return
		if (copying)
			boutput(usr, "<span style=\"color:red\">Copying, please wait.</span>")
			return
		var/turf/T = get_turf(object)
		var/tx = T.x
		var/ty = T.y
		var/tz = T.z
		for (var/datum/clipboardTurf/CBT in clipboard)
			var/turf/TheOneToReplace = locate(tx + CBT.rel_x, ty + CBT.rel_y, tz)
			if (!TheOneToReplace)
				continue
			var/turf/R = new CBT.turf_type(TheOneToReplace)
			R.icon_state = CBT.turf_icon
			for (var/obj/O in CBT.objects)
				O.clone(R)
			blink(R)

	click_right(atom/object, var/ctrl, var/alt, var/shift)
		if (copying)
			boutput(usr, "<span style=\"color:red\">Copying, please wait.</span>")
			return
		if (!A)
			A = get_turf(object)
			boutput(usr, "<span style=\"color:blue\">Corner 1 set.</span>")
		else
			var/turf/B = get_turf(object)
			if (A.z != B.z)
				boutput(usr, "<span style=\"color:red\">Corners must be on the same Z-level!</span>")
				return
			copying = 1
			clipboard.len = 0
			var/minx = min(A.x, B.x)
			var/miny = min(A.y, B.y)
			var/workgroup = 0
			spawn(0)
				for (var/turf/Q in block(A,B))
					var/datum/clipboardTurf/CBT = new()
					CBT.rel_x = Q.x - minx
					CBT.rel_y = Q.y - miny
					CBT.turf_type = Q.type
					CBT.turf_icon = Q.icon_state
					for (var/obj/O in Q)
						if (istype(O, /obj/overlay/tile_effect))
							continue
						CBT.objects += O.clone()
					clipboard += CBT
					workgroup++
					blink(Q)
					if (workgroup > 4)
						workgroup = 0
						sleep(1)
				boutput(usr, "<span style=\"color:blue\">Copying complete!</span>")
				copying = 0
				A = null