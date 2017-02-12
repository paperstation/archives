/datum/buildmode/clipboard
	name = "Clipboard"
	desc = {"***********************************************************<br>
Left Mouse Button                      = Paste object<br>
Right Mouse Button                     = Select object to copy<br>
***********************************************************"}
	icon_state = "buildmode11"
	var/atom/cloned = null

	click_left(atom/object, var/ctrl, var/alt, var/shift)
		if (!cloned)
			return
		var/turf/T = get_turf(object)
		if (isobj(cloned))
			var/obj/O = cloned:clone()
			O.set_loc(T)
		else if (ispath(cloned))
			new cloned(T)
		blink(T)

	click_right(atom/object, var/ctrl, var/alt, var/shift)
		if (isturf(object))
			cloned = object.type
			boutput(usr, "<span style=\"color:blue\">Selected [object] for copying.</span>")
		else if (isobj(object))
			cloned = object:clone()
			boutput(usr, "<span style=\"color:blue\">Selected [object] for copying.</span>")