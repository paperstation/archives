/datum/buildmode/varedit
	name = "Variable Edit (single)"
	desc = {"***********************************************************<br>
Right Mouse Button on buildmode button = Set variable details<br>
Left Mouse Button on turf/mob/obj      = Set variable to value<br>
Right Mouse Button                     = Reset variable to initial value<br>
***********************************************************"}
	icon_state = "buildmode3"
	var/varname = null
	var/varvalue = null
	var/is_refpicking = 0
	var/is_newinst = 0

	click_mode_right(var/ctrl, var/alt, var/shift)
		var/newvn = input("Enter variable name", "Variable name", varname) as text|null
		if (!newvn)
			return
		varname = newvn
		var/vartype = input("What kind of variable?","Variable Type") in list("text", "num", "type", "reference", "mob reference", "turf by coordinates", "reference picker", "new instance of a type", "icon", "file", "color")
		is_refpicking = 0
		is_newinst = 0
		switch (vartype)
			if("text")
				varvalue = input("Enter new text:","Text") as null|text

			if("num")
				varvalue = input("Enter new number:","Num") as null|num

			if("type")
				varvalue = input("Enter type:","Type") in typesof(/obj,/mob,/area,/turf)

			if("reference")
				varvalue = input("Select reference:","Reference") as null|mob|obj|turf|area in world

			if("mob reference")
				varvalue = input("Select reference:","Reference") as null|mob in world

			if("file")
				varvalue = input("Pick file:","File") as null|file

			if("icon")
				varvalue = input("Pick icon:","Icon") as null|icon

			if("color")
				varvalue = input("Pick color:","Color") as null|color

			if("turf by coordinates")
				var/x = input("X coordinate", "Set to turf at \[_, ?, ?\]", 1) as num
				var/y = input("Y coordinate", "Set to turf at \[[x], _, ?\]", 1) as num
				var/z = input("Z coordinate", "Set to turf at \[[x], [y], _\]", 1) as num
				var/turf/T = locate(x, y, z)
				if (istype(T))
					varvalue = T
				else
					boutput(usr, "<span style=\"color:red\">Invalid coordinates!</span>")
					return

			if("reference picker")
				boutput(usr, "<span style=\"color:blue\">Click the mob, object or turf to use as a reference.</span>")
				is_refpicking = 1

			if ("new instance of a type")
				boutput(usr, "<span style=\"color:blue\">Type part of the path of type of thing to instantiate.</span>")
				var/typename = input("Part of type path.", "Part of type path.", "/obj") as null|text
				if (typename)
					var/basetype = /obj
					if (holder.owner.holder.rank in list("Host", "Coder", "Shit Person"))
						basetype = /datum
					var/match = get_one_match(typename, basetype)
					if (match)
						varvalue = match
						is_newinst = 1

		if(varvalue == null) return

	click_left(atom/object, var/ctrl, var/alt, var/shift)
		if (is_refpicking)
			boutput(usr, "<span style=\"color:blue\">Reference grabbed from [object].</span>")
			varvalue = object
			is_refpicking = 0
			return
		if (varname in object.vars)
			var/ov = object.vars[varname]
			if (is_newinst)
				object.vars[varname] = new varvalue()
			else
				object.vars[varname] = varvalue
			object.onVarChanged(varname, ov, object.vars[varname])
			boutput(usr, "<span style=\"color:blue\">Set [object].[varname] to [varvalue].</span>")
			blink(get_turf(object))
		else
			boutput(usr, "<span style=\"color:red\">[object] has no var named [varname].</span>")

	click_right(atom/object, var/ctrl, var/alt, var/shift)
		if (is_refpicking)
			return
		if (varname in object.vars)
			var/ov = object.vars[varname]
			object.vars[varname] = initial(object.vars[varname])
			object.onVarChanged(varname, ov, object.vars[varname])
			blink(get_turf(object))
		else
			boutput(usr, "<span style=\"color:red\">[object] has no var named [varname].</span>")