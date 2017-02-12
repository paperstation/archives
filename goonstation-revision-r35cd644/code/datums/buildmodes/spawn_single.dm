/datum/buildmode/spawn_single
	name = "Object Spawn"
	desc = {"***********************************************************<br>
Right Mouse Button on buildmode button = Set object type<br>
Left Mouse Button on turf/mob/obj      = Place objects<br>
Right Mouse Button                     = Delete objects<br>
<br>
Use the button in the upper left corner to<br>
change the direction of created objects.<br>
***********************************************************"}
	icon_state = "buildmode2"
	var/objpath = null

	click_mode_right(var/ctrl, var/alt, var/shift)
		objpath = get_one_match(input("Type path", "Type path", "/obj/closet"), /atom)

	click_left(atom/object, var/ctrl, var/alt, var/shift)
		if (!objpath)
			boutput(usr, "<span style=\"color:red\">No object path!</span>")
			return
		var/turf/T = get_turf(object)
		if(!isnull(T) && objpath)
			var/atom/A = new objpath(T)
			if (isobj(A) || ismob(A) || isturf(A))
				A.dir = holder.dir
				A.onVarChanged("dir", SOUTH, A.dir)
			blink(T)

	click_right(atom/object, var/ctrl, var/alt, var/shift)
		if(isobj(object))
			qdel(object)