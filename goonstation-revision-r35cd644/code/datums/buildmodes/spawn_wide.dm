/datum/buildmode/spawn_wide
	name = "Wide Area Spawn"
	desc = {"***********************************************************<br>
Right Mouse Button on buildmode button = Set object type<br>
Left Mouse Button on turf/mob/obj      = Mark corners of area with two clicks<br>
Right Mouse Button                     = Delete all objects and turfs in the area marked with two clicks<br>
<br>
Use the button in the upper left corner to<br>
change the direction of created objects.<br>
***********************************************************"}
	icon_state = "buildmode5"
	var/objpath = null
	var/turf/A = null

	deselected()
		..()
		A = null

	click_mode_right(var/ctrl, var/alt, var/shift)
		objpath = get_one_match(input("Type path", "Type path", "/obj/closet"), /atom)
		A = null

	proc/mark_corner(atom/object)
		A = get_turf(object)

	click_left(atom/object, var/ctrl, var/alt, var/shift)
		if (!objpath)
			boutput(usr, "<span style=\"color:red\">No object path!</span>")
			return
		if (!A)
			mark_corner(object)
		else
			var/turf/B = get_turf(object)
			if (A.z != B.z)
				boutput(usr, "<span style=\"color:red\">Corners must be on the same Z-level!</span>")
				return
			var/cnt = 0
			for (var/turf/Q in block(A,B))
				var/atom/sp = new objpath(Q)
				if (isobj(sp) || ismob(sp) || isturf(sp))
					sp.dir = holder.dir
					sp.onVarChanged("dir", 2, holder.dir)
				blink(Q)
				cnt++
				if (cnt > 499)
					cnt = 0
					sleep(2)
			A = null

	click_right(atom/object, var/ctrl, var/alt, var/shift)
		if (!A)
			mark_corner(object)
		else
			var/turf/B = get_turf(object)
			if (A.z != B.z)
				boutput(usr, "<span style=\"color:red\">Corners must be on the same Z-level!</span>")
				return
			var/cnt = 0
			for (var/turf/Q in block(A,B))
				blink(Q)
				for (var/obj/O in Q)
					del O
				Q.ReplaceWithSpaceForce()
				cnt++
				if (cnt > 499)
					cnt = 0
					sleep(2)
			A = null
