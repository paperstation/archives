/datum/hud/storage
	var/obj/screen/hud
		boxes
		close
	var/obj/item/storage/master


	New(master)
		src.master = master
		src.boxes = create_screen("boxes", "Storage", 'icons/mob/screen1.dmi', "block", "1, 8 to 1, 1")
		src.close = create_screen("close", "Close", 'icons/mob/screen1.dmi', "x", "1, 1", HUD_LAYER+1)
		update()

	clicked(id, mob/user)
		switch (id)
			if ("close")
				user.detach_hud(src)
				user.s_active = null

	proc/update()
		var x = 1, y = 8, sx = 1, sy = 8
		if (isturf(master.loc) && !istype(master, /obj/item/storage/bible)) // goddamn BIBLES (prevents conflicting positions within different bibles)
			x = 7
			y = 8
			sx = 4
			sy = 2
		if (!boxes)
			return
		if (ishuman(usr))
			var/mob/living/carbon/human/player = usr
			var/icon/hud_style = hud_style_selection[get_hud_style(player)]
			if (isicon(hud_style) && boxes.icon != hud_style)
				boxes.icon = hud_style
		boxes.screen_loc = "[x], [y] to [x+sx-1], [y-sy+1]"
		if (!close)
			src.close = create_screen("close", "Close", 'icons/mob/screen1.dmi', "x", "1, 1", HUD_LAYER+1)
		close.screen_loc = "[x+sx-1], [y-sy+1]"
		var/i = 0
		for (var/obj/item/I in master.get_contents())
			if (!(I in src.objects)) // ugh
				add_object(I, HUD_LAYER+1)
			I.screen_loc = "[x+(i%sx)], [y-round(i/sx)]"
			i++

	proc/add_item(obj/item/I)
		update()

	proc/remove_item(obj/item/I)
		remove_object(I)
		update()
