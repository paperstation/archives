/datum/hud/ghostdrone
	var/obj/screen/hud
		mod1
		charge
		pulling
		face

		prev
		boxes
		next
		close

		prevbg
		nextbg
		closebg

		health
		oxy
		temp

	var/list/screen_tools = list()
	var/list/screen_tools_bg = list()

	var/list/obj/screen/hud/upgrade_bg = list()
	var/list/obj/screen/hud/upgrade_slots = list()
	var/show_upgrades = 1

	var/items_screen = 1
	var/show_items = 0

	var/list/last_tools = list()
	var/mob/living/silicon/ghostdrone/master

	var/obj/screen/hud

	proc
		toggle_equipment()
			show_items = !show_items
			update_equipment()

		update_equipment()
			if (!master.tools || !show_items)
				show_items = 0
				for (var/O in screen_tools)
					remove_screen(O)
				for (var/O in screen_tools_bg)
					remove_screen(O)
				remove_screen(boxes)
				remove_screen(close)
				remove_screen(prev)
				remove_screen(next)
				remove_screen(closebg)
				remove_screen(prevbg)
				remove_screen(nextbg)
				return
			var x = 1, y = 10, sx = 1, sy = 10
			if (!boxes)
				return
			if (items_screen + 6 > master.tools.len)
				items_screen = max(master.tools.len - 6, 1)
			if (items_screen < 1)
				items_screen = 1
			boxes.screen_loc = "[x], [y] to [x+sx-1], [y-sy+1]"
			if (!close)
				src.close = create_screen("close", "Close", 'icons/mob/screen1.dmi', "x", "1, 1", HUD_LAYER+1)
			if (!prev)
				src.prev = create_screen("prev", "Previous Page", 'icons/mob/screen1.dmi', "up_dis", "1, 10", HUD_LAYER+1)
			if (!next)
				src.next = create_screen("next", "Next Page", 'icons/mob/screen1.dmi', "down", "1, 2", HUD_LAYER+1)
			close.screen_loc = "[x+sx-1], [y-sy+1]"
			next.screen_loc = "[x+sx-1], [y-sy+2]"
			prev.screen_loc = "[x+sx-1], [y]"
			closebg.screen_loc = "[x+sx-1], [y-sy+1]"
			nextbg.screen_loc = "[x+sx-1], [y-sy+2]"
			prevbg.screen_loc = "[x+sx-1], [y]"

			for (var/O in screen_tools)
				remove_screen(O)
			add_screen(boxes)
			add_screen(close)
			add_screen(prev)
			add_screen(next)
			add_screen(closebg)
			add_screen(prevbg)
			add_screen(nextbg)

			if (items_screen > 1)
				prev.icon_state = "up"
			else
				prev.icon_state = "up_dis"

			var/sid = 1
			var/i_max = items_screen + 7
			if (i_max <= master.tools.len)
				next.icon_state = "down"
			else
				next.icon_state = "down_dis"

			for (var/i = items_screen, i < i_max, i++)
				if (i > master.tools.len)
					break
				var/obj/item/I = master.tools[i]
				var/obj/screen/S = screen_tools[sid]
				var/obj/screen/BG = screen_tools_bg[sid]
				S.name = I.name
				BG.name = I.name
				S.icon = I.icon
				S.icon_state = I.icon_state
				S.overlays = I.overlays.Copy()
				S.underlays = I.underlays.Copy()
				S.color = I.color
				S.alpha = I.alpha
				S.screen_loc = "[x], [y - sid]"
				BG.screen_loc = "[x], [y - sid]"
				add_screen(BG)
				add_screen(S)
				sid++

		try_equip_at(var/i)
			if (!master || !master.cell || master.cell.charge <= 100)
				update_equipment()
				return
			if (!master.tools || !show_items)
				update_equipment()
				return
			var/content_id = items_screen + i - 1
			if (content_id > master.tools.len || content_id < 1)
				boutput(usr, "<span style=\"color:red\">An error occurred. Please notify Marquesas immediately. (Content ID: [content_id].)</span>")

			if (master.active_tool && istype(master.active_tool, /obj/item/magtractor) && master.active_tool:holding)
				actions.stopId("magpickerhold", master)
			var/obj/item/O = master.tools[content_id]
			master.active_tool = O
			O.loc = master
			O.pickup(master) // Handle light datums and the like.
			set_active_tool(1)
			update_equipment()
			update_tools()

	New(M)
		master = M
		src.boxes = create_screen("boxes", "Storage", 'icons/mob/screen1.dmi', "blank", "1, 10 to 1, 1")
		remove_screen(boxes)
		src.prevbg = create_screen("prevbg", "Previous Page", 'icons/mob/screen1.dmi', "block", "1, 10", HUD_LAYER+1)
		src.prev = create_screen("prev", "Previous Page", 'icons/mob/screen1.dmi', "up_dis", "1, 10", HUD_LAYER+2)
		remove_screen(prev)
		remove_screen(prevbg)
		src.nextbg = create_screen("nextbg", "Next Page", 'icons/mob/screen1.dmi', "block", "1, 10", HUD_LAYER+1)
		src.next = create_screen("next", "Next Page", 'icons/mob/screen1.dmi', "down", "1, 10", HUD_LAYER+2)
		remove_screen(next)
		remove_screen(nextbg)
		src.closebg = create_screen("closebg", "Close", 'icons/mob/screen1.dmi', "block", "1, 10", HUD_LAYER+1)
		src.close = create_screen("close", "Close", 'icons/mob/screen1.dmi', "x", "1, 10", HUD_LAYER+2)
		remove_screen(close)
		remove_screen(closebg)
		for (var/i = 1, i <= 7, i++)
			var/BG = create_screen("objectbg_[i]", "object", 'icons/mob/screen1.dmi', "block", "1, [10 - i]", HUD_LAYER + 1)
			var/S = create_screen("object[i]", "object", null, null, "1, [10 - i]", HUD_LAYER + 2)
			remove_screen(S)
			screen_tools += S
			screen_tools_bg += BG

		create_screen("", "", 'icons/mob/hud_common.dmi', "hotbar_bg", "CENTER-2, SOUTH to CENTER+2, SOUTH", HUD_LAYER)
		create_screen("", "", 'icons/mob/hud_common.dmi', "hotbar_side", "CENTER-2, SOUTH+1 to CENTER+2, SOUTH+1", HUD_LAYER, SOUTH)
		create_screen("", "", 'icons/mob/hud_common.dmi', "hotbar_side", "CENTER-3, SOUTH+1", HUD_LAYER, SOUTHWEST)
		create_screen("", "", 'icons/mob/hud_common.dmi', "hotbar_side", "CENTER-3, SOUTH", HUD_LAYER, EAST)
		create_screen("", "", 'icons/mob/hud_common.dmi', "hotbar_side", "CENTER+3, SOUTH+1", HUD_LAYER, SOUTHEAST)
		create_screen("", "", 'icons/mob/hud_common.dmi', "hotbar_side", "CENTER+3, SOUTH", HUD_LAYER, WEST)

		mod1 = create_screen("mod1", "Tool", 'icons/mob/hud_drone.dmi', "toolslot", "CENTER-2, SOUTH", HUD_LAYER+1)

		create_screen("store", "Store", 'icons/mob/hud_drone.dmi', "store", "CENTER-1, SOUTH", HUD_LAYER+1)
		charge = create_screen("charge", "Battery", 'icons/mob/hud_drone.dmi', "charge4", "CENTER, SOUTH", HUD_LAYER+1)

		pulling = create_screen("pulling", "Pulling", 'icons/mob/hud_drone.dmi', "pull0", "CENTER+1, SOUTH", HUD_LAYER+1)
		face = create_screen("face", "Customize Face", 'icons/mob/hud_drone.dmi', "custface", "CENTER+2, SOUTH", HUD_LAYER+1)

		health = create_screen("health", "Health", 'icons/mob/hud_drone.dmi', "health0", "EAST, NORTH")
		oxy = create_screen("oxy", "Oxygen", 'icons/mob/hud_drone.dmi', "oxy0", "EAST, NORTH-1")
		temp = create_screen("temp", "Temperature", 'icons/mob/hud_drone.dmi', "temp0", "EAST, NORTH-2")

		if (master.active_tool)
			set_active_tool(master.tools.Find(master.active_tool))
		update_tools()
		update_pulling()
		update_health()
		update_equipment()

	clicked(id)
		if (!master)
			return
		switch (id)
			if ("next", "nextbg")
				if (next.icon_state != "down_dis") // this is bad and i will fix it in 2025
					items_screen += 7
					update_equipment()
			if ("prev", "prevbg")
				if (next.icon_state != "up_dis") // this is bad and i will fix it in 2025
					items_screen -= 7
					update_equipment()
			if ("close", "closebg")
				show_items = 0
				update_equipment()
			if ("object1")
				try_equip_at(1)
				update_equipment()
			if ("object2")
				try_equip_at(2)
				update_equipment()
			if ("object3")
				try_equip_at(3)
				update_equipment()
			if ("object4")
				try_equip_at(4)
				update_equipment()
			if ("object5")
				try_equip_at(5)
				update_equipment()
			if ("object6")
				try_equip_at(6)
				update_equipment()
			if ("object7")
				try_equip_at(7)
				update_equipment()
			if ("mod1")
				toggle_equipment()
			if ("store")
				master.uneq_slot()
			if ("pulling")
				master.pulling = null
				update_pulling()
			if ("face")
				master.setFaceDialog()
			if ("charge")
				out(master, "<span style='color: blue;'>Your charge is: [master.cell.charge]/[master.cell.maxcharge]</span>")
			if ("health")
				out(master, "<span style='color: blue;'>Your health is: [master.health / master.max_health * 100]%</span>")
			else
				//Handle box BG clicks
				if (length(id) >= 10)
					var/slot = copytext(id, 10)
					slot = text2num(slot)
					try_equip_at(slot)

	proc
		set_active_tool(active) // naming these tools to distinuish it from the module of a borg
			mod1.icon_state = "toolslot[active ? 1 : ""]"

		update_tools()
			for (var/obj/item/I in last_tools)
				remove_object(I)
			var/obj/item/tool1 = master.active_tool
			if (tool1)
				add_object(tool1, HUD_LAYER+2, "CENTER-2, SOUTH")
			last_tools = master.tools.Copy()

		update_charge()
			if (master.cell)
				switch(round(100*master.cell.charge/master.cell.maxcharge))
					if(75 to INFINITY)
						charge.icon_state = "charge4"
					if(50 to 75)
						charge.icon_state = "charge3"
					if(25 to 50)
						charge.icon_state = "charge2"
					if(1 to 25)
						charge.icon_state = "charge1"
					else
						charge.icon_state = "charge0"
			else
				charge.icon_state = "charge-none"

		update_health()
			if (master.stat != 2)
				switch(master.health)
					if(10 to INFINITY)
						health.icon_state = "health5"
					if(8 to 10)
						health.icon_state = "health4"
					if(6 to 8)
						health.icon_state = "health3"
					if(4 to 6)
						health.icon_state = "health2"
					if(2 to 4)
						health.icon_state = "health1"
					if(0 to 2)
						health.icon_state = "health0"
					else
						health.icon_state = "dead"
			else
				health.icon_state = "dead"

		update_pulling()
			pulling.icon_state = "pull[master.pulling ? 1 : 0]"

		update_environment()
			var/turf/T = get_turf(master)
			if (T)
				var/datum/gas_mixture/environment = T.return_air()
				var/total = environment.total_moles()
				if (total > 0) // prevent a division by zero
					oxy.icon_state = "oxy[environment.oxygen/total*environment.return_pressure() < 17]"
				else
					oxy.icon_state = "oxy1"
				switch (environment.temperature)
					if (350 to INFINITY)
						temp.icon_state = "temp1"
					if (280 to 350)
						temp.icon_state = "temp0"
					else
						temp.icon_state = "temp-1"
