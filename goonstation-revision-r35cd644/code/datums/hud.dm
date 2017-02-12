/obj/screen
	anchored = 1

/obj/screen/hud
	var/datum/hud/master
	var/id = ""
	var/tooltipTheme

	clicked(list/params)
		if (master && (!master.click_check || (usr in master.mobs)))
			master.clicked(src.id, usr, params)

	//WIRE TOOLTIPS
	MouseEntered(location, control, params)
		if (src.tooltipTheme)
			usr.client.tooltip.show(src, params, title = src.name, content = (src.desc ? src.desc : null), theme = src.tooltipTheme)

	MouseExited()
		usr.client.tooltip.hide()

/datum/hud
	var/list/mob/living/mobs = list()
	var/list/client/clients = list()
	var/list/obj/screen/hud/objects = list()
	var/click_check = 1

	disposing()
		for (var/mob/M in src.mobs)
			M.detach_hud(src)
		for (var/client/C in src.clients)
			remove_client(C)

	proc/check_objects()
		for (var/i = 1; i <= src.objects.len; i++)
			var/j = 0
			while (j+i <= src.objects.len && isnull(src.objects[j+i]))
				j++
			if (j)
				src.objects.Cut(i, i+j)

	proc/add_client(client/C)
		check_objects()
		C.screen += src.objects
		src.clients += C

	proc/remove_client(client/C)
		src.clients -= C
		for (var/atom/A in src.objects)
			C.screen -= A

	proc/create_screen(id, name, icon, state, loc, layer = HUD_LAYER, dir = SOUTH, tooltipTheme = null)
		var/obj/screen/hud/S = new
		S.name = name
		S.id = id
		S.master = src
		S.icon = icon
		S.icon_state = state
		S.screen_loc = loc
		S.layer = layer
		S.dir = dir
		S.tooltipTheme = tooltipTheme
		src.objects += S
		for (var/client/C in src.clients)
			C.screen += S
		return S

	proc/add_object(atom/movable/A, layer = HUD_LAYER, loc)
		if (loc)
			A.screen_loc = loc
		A.layer = layer
		if (!src.objects.Find(A))
			src.objects += A
			for (var/client/C in src.clients)
				C.screen += A

	proc/remove_object(atom/movable/A)
		src.objects -= A
		for (var/client/C in src.clients)
			C.screen -= A

	proc/add_screen(obj/screen/S)
		if (!src.objects.Find(S))
			src.objects += S
			for (var/client/C in src.clients)
				C.screen += S

	proc/remove_screen(obj/screen/S)
		src.objects -= S
		for (var/client/C in src.clients)
			C.screen -= S

	proc/clicked(id)
