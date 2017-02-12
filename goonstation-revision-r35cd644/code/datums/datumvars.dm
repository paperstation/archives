//
/client/proc/debug_variables(datum/D in world)
	set category = "Debug"
	set name = "View Variables"
	//set src in world

	var/title = ""
	var/body = ""

	if (istype(D, /atom))
		var/atom/A = D
		title = "[A.name][src.holder.level >= LEVEL_SHITGUY ? " (\ref[A])" : ""] = [A.type]"

		#ifdef VARSICON
		if (A.icon)
			body += debug_variable("icon", new/icon(A.icon, A.icon_state, A.dir), 0)
		#endif
	title = "[D][src.holder.level >= LEVEL_SHITGUY ? " (\ref[D])" : ""] = [D.type]"

	body += "<ol>"

	var/list/names = list()
	for (var/V in D.vars)
		names += V

	names = sortList(names)

	for (var/V in names)
		body += debug_variable(V, D.vars[V], 0)
		body += " - <a href='byond://?src=\ref[src];Vars=\ref[D];varToEdit=[V]'><font size=1>Edit</font></a> <a href='byond://?src=\ref[src];Vars=\ref[D];varToEditAll=[V]'><font size=1>(A)</font></a>  <a href='byond://?src=\ref[src];Vars=\ref[D];setAll=[V]'><font size=1>(S)</font></a>"
		if (istype(D.vars[V], /datum) && src.holder.level >= LEVEL_CODER)
			body += " <a href='byond://?src=\ref[src];Vars=\ref[D];procCall=[V]'><font size=1>(P)</font></a>"

	body += "</ol>"

	var/html = "<html><head>"
	if (title)
		html += "<title>[title]</title>"
	html += {"<style>
body
{
	font-family: Verdana, sans-serif;
	font-size: 9pt;
}
.value
{
	font-family: "Courier New", monospace;
	font-size: 8pt;
}
</style>"}
	html += "</head><body>"
	html += "<a href='byond://?src=\ref[src];Refresh=\ref[D]'>Refresh</a>"
	if (src.holder.level >= LEVEL_CODER)
		html += " | <a href='byond://?src=\ref[src];CallProc=\ref[D]'>Call Proc</a> <br>"
	if (istype(D, /atom))
		html += "<a href='byond://?src=\ref[src];JumpToThing=\ref[D]'>Jump To</a>"
		if (ismob(D) || isobj(D))
			html += " | <a href='byond://?src=\ref[src];GetThing=\ref[D]'>Get</a>"
			if (ismob(D))
				html += " | <a href='byond://?src=\ref[src];PlayerOptions=\ref[D]'>Player Options</a>"
		html += "<br><a href='byond://?src=\ref[src];SetDirection=\ref[D];DirectionToSet=L90'><<==</a> "
		html += "<a href='byond://?src=\ref[src];SetDirection=\ref[D];DirectionToSet=L45'><=</a> "
		html += "<a href='byond://?src=\ref[src];SetDirection=\ref[D]'>Set Direction</a> "
		html += "<a href='byond://?src=\ref[src];SetDirection=\ref[D];DirectionToSet=R45'>=></a> "
		html += "<a href='byond://?src=\ref[src];SetDirection=\ref[D];DirectionToSet=R90'>==>></a><br>"
	html += "<br><small> (A) = Edit all entities of same type <br> (S) = Set this var on all entities of same type <br> (P) = Call Proc</small>"
	html += body
	html += "</body></html>"

	usr << browse(html, "window=variables\ref[D]")

	return

/client/proc/debug_variable(name, value, level)
	var/html = ""

	html += "<li>"

	if (isnull(value))
		html += "[name] = <span class='value'>null</span>"

	else if (istext(value))
		html += "[name] = <span class='value'>\"[value]\"</span>"

	else if (isicon(value))
		#ifdef VARSICON
		var/icon/I = new/icon(value)
		var/rnd = rand(1,10000)
		var/rname = "tmp\ref[I][rnd].png"
		usr << browse_rsc(I, rname)
		html += "[name] = (<span class='value'>[value]</span>) <img class=icon src=\"[rname]\">"
		#else
		html += "[name] = /icon (<span class='value'>[value]</span>)"
		#endif

/*	else if (istype(value, /image))
		#ifdef VARSICON
		var/rnd = rand(1, 10000)
		var/image/I = value

		src << browse_rsc(I.icon, "tmp\ref[value][rnd].png")
		html += "[name] = <img src=\"tmp\ref[value][rnd].png\">"
		#else
		html += "[name] = /image (<span class='value'>[value]</span>)"
		#endif
*/
	else if (isfile(value))
		html += "[name] = <span class='value'>'[value]'</span>"

	else if (istype(value, /datum))
		var/datum/D = value
		var/dname = null
		if ("name" in D.vars)
			dname = " (" + D.vars["name"] + ")"
		html += "<a href='byond://?src=\ref[src];Vars=\ref[value]'>[name][src.holder.level >= LEVEL_SHITGUY ? " \ref[value]" : ""]</a> = [D.type][dname]"

	else if (istype(value, /client))
		var/client/C = value
		html += "<a href='byond://?src=\ref[src];Vars=\ref[value]'>[name][src.holder.level >= LEVEL_SHITGUY ? " \ref[value]" : ""]</a> = [C] [C.type]"

	else if (islist(value))
		var/list/L = value
		html += "[name] = /list ([L.len])"

		if (!isnull(L) && L.len > 0 && !(name == "underlays" || name == "overlays" || name == "vars" || name == "verbs" || L.len > 500))
			// not sure if this is completely right...
			if (0) // (L.vars.len > 0)
				html += "<ol>"
				for (var/entry in L)
					html += debug_variable(entry, L[entry], level + 1)
				html += "</ol>"
			else
				html += "<ul>"
				for (var/index = 1, index <= L.len, index++)
					html += debug_variable("[index]", L[index], level + 1)
					if (name != "contents" && !isnum(L[index]) && L["[L[index]]"])
						html += "[debug_variable("&nbsp;&nbsp;&nbsp;", L["[L[index]]"], level + 1)]"
				html += "</ul>"
	else
		html += "[name] = <span class='value'>[value]</span>"

	html += "</li>"

	return html

/client/Topic(href, href_list, hsrc)
	if (href_list["Refresh"])
		src.debug_variables(locate(href_list["Refresh"]))
	if (href_list["JumpToThing"])
		var/atom/A = locate(href_list["JumpToThing"])
		if (istype(A))
			src.jumptoturf(get_turf(A))
		return
	if (href_list["GetThing"])
		var/atom/A = locate(href_list["GetThing"])
		if (ismob(A) || isobj(A))
			src.cmd_admin_get_mobject(A)
		return
	if (href_list["PlayerOptions"])
		var/mob/M = locate(href_list["PlayerOptions"])
		if (istype(M))
			src.holder.playeropt(M)
		return
	if (href_list["SetDirection"])
		var/atom/A = locate(href_list["SetDirection"])
		if (istype(A))
			var/new_dir = href_list["DirectionToSet"]
			if (new_dir == "L90")
				A.dir = turn(A.dir, 90)
				boutput(src, "Turned [A] 90° to the left: direction is now [uppertext(dir2text(A.dir))].")
			else if (new_dir == "L45")
				A.dir = turn(A.dir, 45)
				boutput(src, "Turned [A] 45° to the left: direction is now [uppertext(dir2text(A.dir))].")
			else if (new_dir == "R90")
				A.dir = turn(A.dir, -90)
				boutput(src, "Turned [A] 90° to the right: direction is now [uppertext(dir2text(A.dir))].")
			else if (new_dir == "R45")
				A.dir = turn(A.dir, -45)
				boutput(src, "Turned [A] 45° to the right: direction is now [uppertext(dir2text(A.dir))].")
			else
				var/list/english_dirs = list("NORTH", "NORTHEAST", "EAST", "SOUTHEAST", "SOUTH", "SOUTHWEST", "WEST", "NORTHWEST")
				new_dir = input(src, "Choose a direction for [A] to face.", "Selection", "NORTH") as null|anything in english_dirs
				if (new_dir)
					A.dir = text2dir(new_dir)
					boutput(src, "Set [A]'s direction to [new_dir]")
		return
	if (href_list["CallProc"])
		doCallProc(locate(href_list["CallProc"]))
		return
	if (href_list["Vars"])
		if (href_list["varToEdit"])
			modify_variable(locate(href_list["Vars"]), href_list["varToEdit"])
		else if (href_list["varToEditAll"])
			modify_variable(locate(href_list["Vars"]), href_list["varToEditAll"], 1)
		else if (href_list["setAll"])
			set_all(locate(href_list["Vars"]), href_list["setAll"])
		else if (href_list["procCall"])
			var/datum/D = locate(href_list["Vars"])
			if (D)
				var/datum/C = D.vars[href_list["procCall"]]
				if (istype(C, /datum))
					doCallProc(C)
		else
			debug_variables(locate(href_list["Vars"]))
	else
		..()

/client/proc/set_all(datum/D, variable)
	if(!variable || !D || !(variable in D.vars))
		return

	if(!src.holder)
		boutput(src, "Only administrators may use this command.")
		return

	var/var_value = D.vars[variable]

	for(var/x in world)
		if(!istype(x, D.type)) continue
		x:vars[variable] = var_value
		sleep(1)

/client/proc/modify_variable(datum/D, variable, set_global = 0)
	if(!variable || !D || !(variable in D.vars))
		return
	var/list/locked = list("vars", "key", "ckey", "client", "holder")

	if(!src.holder)
		boutput(src, "Only administrators may use this command.")
		return

	var/default
	var/var_value = D.vars[variable]
	var/dir

	if (locked.Find(variable) && !(src.holder.rank in list("Host", "Coder", "Shit Person")))
		boutput(usr, "<span style=\"color:red\">You do not have access to edit this variable!</span>")
		return

	//Let's prevent people from promoting themselves, yes?
	var/list/locked_type = list(/datum/admins) //Short list - might be good if there are more objects that oughta be paws-off
	if(!(src.holder.rank in list("Host", "Coder")) && D.type in locked_type )
		boutput(usr, "<span style=\"color:red\">You're not allowed to edit [D.type] for security reasons!</span>")
		logTheThing("admin", usr, null, "tried to varedit [D.type] but was denied!")
		logTheThing("diary", usr, null, "tried to varedit [D.type] but was denied!", "admin")
		message_admins("[key_name(usr)] tried to varedit [D.type] but was denied.") //If someone tries this let's make sure we all know it.
		return


	if (isnull(var_value))
		boutput(usr, "Unable to determine variable type.")

	else if (isnum(var_value))
		boutput(usr, "Variable appears to be <b>NUM</b>.")
		default = "num"
		dir = 1

	else if (is_valid_color_string(var_value))
		boutput(usr, "Variable appears to be <b>COLOR</b>.")
		default = "color"

	else if (istext(var_value))
		boutput(usr, "Variable appears to be <b>TEXT</b>.")
		default = "text"

	else if (isloc(var_value))
		boutput(usr, "Variable appears to be <b>REFERENCE</b>.")
		default = "reference"

	else if (isicon(var_value))
		boutput(usr, "Variable appears to be <b>ICON</b>.")
		//var_value = "[bicon(var_value)]"
		default = "icon"

	else if (istype(var_value,/atom) || istype(var_value,/datum))
		boutput(usr, "Variable appears to be <b>TYPE</b>.")
		default = "type"

	else if (islist(var_value))
		boutput(usr, "Variable appears to be <b>LIST</b>.")
		default = "list"

	else if (istype(var_value,/client))
		boutput(usr, "Variable appears to be <b>CLIENT</b>.")
		default = "cancel"

	else
		boutput(usr, "Variable appears to be <b>FILE</b>.")
		default = "file"

	boutput(usr, "Variable contains: [var_value]")
	if(dir)
		switch(var_value)
			if(1)
				dir = "NORTH"
			if(2)
				dir = "SOUTH"
			if(4)
				dir = "EAST"
			if(8)
				dir = "WEST"
			if(5)
				dir = "NORTHEAST"
			if(6)
				dir = "SOUTHEAST"
			if(9)
				dir = "NORTHWEST"
			if(10)
				dir = "SOUTHWEST"
			else
				dir = null
		if(dir)
			boutput(usr, "If a direction, direction is: [dir]")

	var/class = input("What kind of variable?","Variable Type",default) as null|anything in list("text",
		"num","type","reference","mob reference","turf by coordinates","reference picker","new instance of a type","icon","file","color","list","edit referenced object","create new list","restore to default")

	if(!class)
		return

	var/original_name

	if (!istype(D, /atom))
		original_name = "[src.holder.level >= LEVEL_SHITGUY ? "\ref[D] " : ""]([D])"
	else
		original_name = D:name

	var/tmp/oldVal = D.vars[variable]
	switch(class)

		if("list")
			mod_list(D.vars[variable])
			//return <- Way to screw up logging

		if("restore to default")
			if(set_global)
				for(var/x in world)
					if(!istype(x, D.type)) continue
					x:vars[variable] = initial(x:vars[variable])
			else
				D.vars[variable] = initial(D.vars[variable])

		if("edit referenced object")
			return .(D.vars[variable])

		if("create new list")
			if(set_global)
				for(var/x in world)
					if(!istype(x, D.type)) continue
					x:vars[variable] = list()
			else
				D.vars[variable] = list()

		if("text")
			var/theInput = input("Enter new text:","Text", D.vars[variable]) as null|text
			if(theInput == null) return
			if(set_global)
				for(var/x in world)
					if(!istype(x, D.type)) continue
					x:vars[variable] = theInput
			else
				D.vars[variable] = theInput

		if("num")
			var/theInput = input("Enter new number:","Num", D.vars[variable]) as null|num
			if(theInput == null) return
			if(set_global)
				for(var/x in world)
					if(!istype(x, D.type)) continue
					x:vars[variable] = theInput
			else
				D.vars[variable] = theInput

		if("type")
			var/theInput = input("Enter type:","Type",D.vars[variable]) in null|typesof(/obj,/mob,/area,/turf)
			if(theInput == null) return
			if(set_global)
				for(var/x in world)
					if(!istype(x, D.type)) continue
					x:vars[variable] = theInput
			else
				D.vars[variable] = theInput

		if("reference")
			var/theInput = input("Select reference:","Reference", D.vars[variable]) as null|mob|obj|turf|area in world
			if(theInput == null) return
			if(set_global)
				for(var/x in world)
					if(!istype(x, D.type)) continue
					x:vars[variable] = theInput
			else
				D.vars[variable] = theInput

		if("mob reference")
			var/theInput = input("Select reference:","Reference", D.vars[variable]) as null|mob in world
			if(theInput == null) return
			if(set_global)
				for(var/x in world)
					if(!istype(x, D.type)) continue
					x:vars[variable] = theInput
			else
				D.vars[variable] = theInput

		if("file")
			var/theInput = input("Pick file:","File",D.vars[variable]) as null|file
			if(theInput == null) return
			if(set_global)
				for(var/x in world)
					if(!istype(x, D.type)) continue
					x:vars[variable] = theInput
			else
				D.vars[variable] = theInput

		if("icon")
			var/theInput = input("Pick icon:","Icon",D.vars[variable]) as null|icon
			if(theInput == null) return
			if(set_global)
				for(var/x in world)
					if(!istype(x, D.type)) continue
					x:vars[variable] = theInput
			else
				D.vars[variable] = theInput

		if("color")
			var/theInput = input("Pick color:","Color",D.vars[variable]) as null|color
			if(theInput == null) return
			if(set_global)
				for(var/x in world)
					if(!istype(x, D.type)) continue
					x:vars[variable] = theInput
			else
				D.vars[variable] = theInput

		if("turf by coordinates")
			var/x = input("X coordinate", "Set to turf at \[_, ?, ?\]", 1) as num
			var/y = input("Y coordinate", "Set to turf at \[[x], _, ?\]", 1) as num
			var/z = input("Z coordinate", "Set to turf at \[[x], [y], _\]", 1) as num
			var/turf/T = locate(x, y, z)
			if (istype(T))
				if (set_global)
					for (var/datum/q in world)
						if (!istype(q, D.type)) continue
						q.vars[variable] = T
				else
					D.vars[variable] = T
			else
				boutput(usr, "<span style=\"color:red\">Invalid coordinates!</span>")
				return

		if("reference picker")
			boutput(usr, "<span style=\"color:blue\">Click the mob, object or turf to use as a reference.</span>")
			var/mob/M = usr
			if (istype(M))
				var/datum/targetable/refpicker/R
				if (set_global)
					R = new /datum/targetable/refpicker/global()
				else
					R = new()
				R.target = D
				R.varname = variable
				M.targeting_spell = R
				M.update_cursor()
				return

		if ("new instance of a type")
			boutput(usr, "<span style=\"color:blue\">Type part of the path of type of thing to instantiate.</span>")
			var/typename = input("Part of type path.", "Part of type path.", "/obj") as null|text
			if (typename)
				var/basetype = /obj
				if (src.holder.rank in list("Host", "Coder", "Shit Person"))
					basetype = /datum
				var/match = get_one_match(typename, basetype)
				if (match)
					if (set_global)
						for (var/datum/x in world)
							if (!istype(x, D.type)) continue
							x.vars[variable] = new match(x)
					else
						D.vars[variable] = new match(D)
			else
				return

	logTheThing("admin", src, null, "modified [original_name]'s [variable] to [D.vars[variable]]" + (set_global ? " on all entities of same type" : ""))
	logTheThing("diary", src, null, "modified [original_name]'s [variable] to [D.vars[variable]]" + (set_global ? " on all entities of same type" : ""), "admin")
	message_admins("[key_name(src)] modified [original_name]'s [variable] to [D.vars[variable]]" + (set_global ? " on all entities of same type" : ""), 1)
	spawn(0)
		if (istype(D, /datum))
			D.onVarChanged(variable, oldVal, D.vars[variable])
	src.debug_variables(D)

/mob/proc/Delete(atom/A in view())
	set category = "Debug"
	switch (alert("Are you sure you wish to delete \the [A.name] at ([A.x],[A.y],[A.z]) ?", "Admin Delete Object","Yes","No"))
		if("Yes")
			logTheThing("admin", usr, null, "deleted [A.name] at ([showCoords(A.x, A.y, A.z)])")
			logTheThing("diary", usr, null, "deleted [A.name] at ([showCoords(A.x, A.y, A.z, 1)])", "admin")
