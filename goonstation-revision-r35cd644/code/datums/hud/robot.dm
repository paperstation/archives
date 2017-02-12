/datum/hud/robot
	var/obj/screen/hud
		mod1
		mod2
		mod3
		charge
		module
		intent
		pulling

		prev
		boxes
		next
		close

		health
		oxy
		temp

	var/list/screen_tools = list()

	var/list/obj/screen/hud/upgrade_bg = list()
	var/list/obj/screen/hud/upgrade_slots = list()
	var/show_upgrades = 1

	var/items_screen = 1
	var/show_items = 0

	var/list/last_upgrades = list()
	var/list/last_tools = list()
	var/mob/living/silicon/robot/master

	var/obj/screen/hud

	proc
		toggle_equipment()
			show_items = !show_items
			update_equipment()

		module_added()
			items_screen = 1
			update_equipment()

		module_removed()
			items_screen = 1
			update_equipment()

		update_equipment()
			if (!master.module || !show_items)
				show_items = 0
				for (var/O in screen_tools)
					remove_screen(O)
				remove_screen(boxes)
				remove_screen(close)
				remove_screen(prev)
				remove_screen(next)
				return
			var x = 1, y = 10, sx = 1, sy = 10
			if (!boxes)
				return
			if (items_screen + 6 > master.module.contents.len)
				items_screen = max(master.module.contents.len - 6, 1)
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

			for (var/O in screen_tools)
				remove_screen(O)
			add_screen(boxes)
			add_screen(close)
			add_screen(prev)
			add_screen(next)

			if (items_screen > 1)
				prev.icon_state = "up"
			else
				prev.icon_state = "up_dis"

			var/sid = 1
			var/i_max = items_screen + 7
			if (i_max <= master.module.contents.len)
				next.icon_state = "down"
			else
				next.icon_state = "down_dis"

			for (var/i = items_screen, i < i_max, i++)
				if (i > master.module.contents.len)
					break
				var/obj/item/I = master.module.contents[i]
				var/obj/screen/S = screen_tools[sid]
				S.name = I.name
				S.icon = I.icon
				S.icon_state = I.icon_state
				S.overlays = I.overlays.Copy()
				S.underlays = I.underlays.Copy()
				S.color = I.color
				S.alpha = I.alpha
				S.screen_loc = "[x], [y - sid]"
				add_screen(S)
				sid++

		try_equip_at(var/i)
			if (!master || !master.cell || master.cell.charge <= 100)
				update_equipment()
				return
			if (!master.module || !show_items)
				update_equipment()
				return
			var/content_id = items_screen + i - 1
			if (content_id > master.module.contents.len || content_id < 1)
				boutput(usr, "<span style=\"color:red\">An error occurred. Please notify Marquesas immediately. (Content ID: [content_id].)</span>")
			var/obj/item/O = master.module.contents[content_id]
			if(!master.module_states[1] && istype(master.part_arm_l,/obj/item/parts/robot_parts/arm/))
				master.module_states[1] = O
				O.loc = master
				O.pickup(master) // Handle light datums and the like.
			else if(!master.module_states[2])
				master.module_states[2] = O
				O.loc = master
				O.pickup(master)
			else if(!master.module_states[3] && istype(master.part_arm_r,/obj/item/parts/robot_parts/arm/))
				master.module_states[3] = O
				O.loc = master
				O.pickup(master)
			else
				master.uneq_active()
				if(!master.module_states[1] && istype(master.part_arm_l,/obj/item/parts/robot_parts/arm/))
					master.module_states[1] = O
					O.loc = master
					O.pickup(master)
				else if(!master.module_states[2])
					master.module_states[2] = O
					O.loc = master
					O.pickup(master)
				else if(!master.module_states[3] && istype(master.part_arm_r,/obj/item/parts/robot_parts/arm/))
					master.module_states[3] = O
					O.loc = master
					O.pickup(master)
			update_equipment()
			update_tools()

	New(M)
		master = M
		src.boxes = create_screen("boxes", "Storage", 'icons/mob/screen1.dmi', "block", "1, 10 to 1, 1")
		remove_screen(boxes)
		src.prev = create_screen("prev", "Previous Page", 'icons/mob/screen1.dmi', "up_dis", "1, 10", HUD_LAYER+1)
		remove_screen(prev)
		src.next = create_screen("next", "Next Page", 'icons/mob/screen1.dmi', "down", "1, 2", HUD_LAYER+1)
		remove_screen(next)
		src.close = create_screen("close", "Close", 'icons/mob/screen1.dmi', "x", "1, 1", HUD_LAYER+1)
		remove_screen(close)
		for (var/i = 1, i <= 7, i++)
			var/S = create_screen("object[i]", "object", null, null, "1, [10 - i]", HUD_LAYER + 1)
			remove_screen(S)
			screen_tools += S

		create_screen("", "", 'icons/mob/hud_common.dmi', "hotbar_bg", "CENTER-5, SOUTH to CENTER+5, SOUTH", HUD_LAYER)
		create_screen("", "", 'icons/mob/hud_common.dmi', "hotbar_side", "CENTER-5, SOUTH+1 to CENTER+5, SOUTH+1", HUD_LAYER, SOUTH)
		create_screen("", "", 'icons/mob/hud_common.dmi', "hotbar_side", "CENTER-6, SOUTH+1", HUD_LAYER, SOUTHWEST)
		create_screen("", "", 'icons/mob/hud_common.dmi', "hotbar_side", "CENTER-6, SOUTH", HUD_LAYER, EAST)
		create_screen("", "", 'icons/mob/hud_common.dmi', "hotbar_side", "CENTER+6, SOUTH+1", HUD_LAYER, SOUTHEAST)
		create_screen("", "", 'icons/mob/hud_common.dmi', "hotbar_side", "CENTER+6, SOUTH", HUD_LAYER, WEST)

		mod1 = create_screen("mod1", "Module 1", 'icons/mob/hud_robot.dmi', "mod10", "CENTER-5, SOUTH", HUD_LAYER+1)
		mod2 = create_screen("mod2", "Module 2", 'icons/mob/hud_robot.dmi', "mod20", "CENTER-4, SOUTH", HUD_LAYER+1)
		mod3 = create_screen("mod3", "Module 3", 'icons/mob/hud_robot.dmi', "mod30", "CENTER-3, SOUTH", HUD_LAYER+1)

		create_screen("store", "Store", 'icons/mob/hud_robot.dmi', "store", "CENTER-2, SOUTH", HUD_LAYER+1)
		charge = create_screen("charge", "Battery", 'icons/mob/hud_robot.dmi', "charge4", "CENTER-1, SOUTH", HUD_LAYER+1)
		module = create_screen("module", "Module", 'icons/mob/hud_robot.dmi', "module-blank", "CENTER, SOUTH", HUD_LAYER+1)
		create_screen("radio", "Radio", 'icons/mob/hud_robot.dmi', "radio", "CENTER+1, SOUTH", HUD_LAYER+1)
		intent = create_screen("intent", "Intent", 'icons/mob/hud_robot.dmi', "intent-[master.a_intent]", "CENTER+2, SOUTH", HUD_LAYER+1)

		pulling = create_screen("pulling", "Pulling", 'icons/mob/hud_robot.dmi', "pull0", "CENTER+4, SOUTH", HUD_LAYER+1)
		create_screen("upgrades", "Upgrades", 'icons/mob/hud_robot.dmi', "upgrades", "CENTER+5, SOUTH", HUD_LAYER+1)

		health = create_screen("health", "Health", 'icons/mob/hud_robot.dmi', "health0", "EAST, NORTH")
		oxy = create_screen("oxy", "Oxygen", 'icons/mob/hud_robot.dmi', "oxy0", "EAST, NORTH-1")
		temp = create_screen("temp", "Temperature", 'icons/mob/hud_robot.dmi', "temp0", "EAST, NORTH-2")

		if (master.module_active)
			set_active_tool(master.module_states.Find(master.module_active))
		update_tools()
		update_pulling()
		update_health()
		update_module()
		update_upgrades()
		update_equipment()

	clicked(id)
		if (!master)
			return
		switch (id)
			if ("next")
				if (next.icon_state != "down_dis") // this is bad and i will fix it in 2025
					items_screen += 7
					update_equipment()
			if ("prev")
				if (next.icon_state != "up_dis") // this is bad and i will fix it in 2025
					items_screen -= 7
					update_equipment()
			if ("close")
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
				master.swap_hand(1)
			if ("mod2")
				master.swap_hand(2)
			if ("mod3")
				master.swap_hand(3)
			if ("store")
				master.uneq_active()
			if ("module")
				master.toggle_module_pack()
			if ("radio")
				master.radio_menu()
			if ("intent")
				if (master.a_intent == INTENT_HELP)
					master.a_intent = INTENT_HARM
				else
					master.a_intent = INTENT_HELP
				intent.icon_state = "intent-[master.a_intent]"
			if ("pulling")
				master.pulling = null
				update_pulling()
			if ("upgrades")
				set_show_upgrades(!src.show_upgrades)
			if ("upgrade1") // this is horrifying
				if (last_upgrades.len >= 1)
					master.activate_upgrade(src.last_upgrades[1])
			if ("upgrade2")
				if (last_upgrades.len >= 2)
					master.activate_upgrade(src.last_upgrades[2])
			if ("upgrade3")
				if (last_upgrades.len >= 3)
					master.activate_upgrade(src.last_upgrades[3])
			if ("upgrade4")
				if (last_upgrades.len >= 4)
					master.activate_upgrade(src.last_upgrades[4])
			if ("upgrade5")
				if (last_upgrades.len >= 5)
					master.activate_upgrade(src.last_upgrades[5])
			if ("upgrade6")
				if (last_upgrades.len >= 6)
					master.activate_upgrade(src.last_upgrades[6])
			if ("upgrade7")
				if (last_upgrades.len >= 7)
					master.activate_upgrade(src.last_upgrades[7])
			if ("upgrade8")
				if (last_upgrades.len >= 8)
					master.activate_upgrade(src.last_upgrades[8])
			if ("upgrade9")
				if (last_upgrades.len >= 9)
					master.activate_upgrade(src.last_upgrades[9])
			if ("upgrade10")
				if (last_upgrades.len >= 10)
					master.activate_upgrade(src.last_upgrades[10])
	proc
		set_active_tool(active) // naming these tools to distinuish it from the module of a borg
			mod1.icon_state = "mod1[active == 1]"
			mod2.icon_state = "mod2[active == 2]"
			mod3.icon_state = "mod3[active == 3]"

		set_show_upgrades(show)
			if (show == show_upgrades)
				return
			show_upgrades = show
			if (show)
				for (var/obj/screen/hud/H in upgrade_bg)
					add_screen(H)
				for (var/obj/screen/hud/H in upgrade_slots)
					add_screen(H)
				for (var/obj/item/roboupgrade/upgrade in last_upgrades)
					add_object(upgrade, HUD_LAYER+2)
			else
				for (var/obj/screen/hud/H in upgrade_bg)
					remove_screen(H)
				for (var/obj/screen/hud/H in upgrade_slots)
					remove_screen(H)
				for (var/obj/item/roboupgrade/upgrade in last_upgrades)
					remove_object(upgrade)

		update_tools()
			for (var/obj/item/I in last_tools)
				remove_object(I)
			var/obj/item/tool1 = master.module_states[1]
			var/obj/item/tool2 = master.module_states[2]
			var/obj/item/tool3 = master.module_states[3]
			if (tool1)
				add_object(tool1, HUD_LAYER+2, "CENTER-5, SOUTH")
			if (tool2)
				add_object(tool2, HUD_LAYER+2, "CENTER-4, SOUTH")
			if (tool3)
				add_object(tool3, HUD_LAYER+2, "CENTER-3, SOUTH")
			last_tools = master.module_states.Copy()

		update_module()
			if (master.module)
				module.icon_state = "module-[master.module.mod_hudicon]"
			else
				module.icon_state = "module-blank"


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
					if(100 to INFINITY)
						health.icon_state = "health0"
					if(80 to 100)
						health.icon_state = "health1"
					if(60 to 80)
						health.icon_state = "health2"
					if(40 to 60)
						health.icon_state = "health3"
					if(20 to 40)
						health.icon_state = "health4"
					if(0 to 20)
						health.icon_state = "health5"
					else
						health.icon_state = "health6"
			else
				health.icon_state = "health7"

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

		update_upgrades()
			var/startx = 5 - master.max_upgrades
			if (master.max_upgrades != upgrade_slots.len)
				for (var/obj/screen/hud/H in upgrade_bg)
					remove_screen(H)
				for (var/obj/screen/hud/H in upgrade_slots)
					remove_screen(H)

				upgrade_bg.len = 0
				upgrade_bg += create_screen("", "", 'icons/mob/hud_common.dmi', "hotbar_bg", "CENTER+[startx]:24, SOUTH+1:4 to CENTER+4:24, SOUTH+1:4", HUD_LAYER)
				upgrade_bg += create_screen("", "", 'icons/mob/hud_common.dmi', "hotbar_side", "CENTER+[startx]:24, SOUTH+2:4 to CENTER+4:24, SOUTH+2:4", HUD_LAYER, SOUTH)
				upgrade_bg += create_screen("", "", 'icons/mob/hud_common.dmi', "hotbar_side", "CENTER+[startx-1]:24, SOUTH+2:4", HUD_LAYER, SOUTHWEST)
				upgrade_bg += create_screen("", "", 'icons/mob/hud_common.dmi', "hotbar_side", "CENTER+[startx-1]:24, SOUTH+1:4", HUD_LAYER, EAST)
				upgrade_bg += create_screen("", "", 'icons/mob/hud_common.dmi', "hotbar_side", "CENTER+5:24, SOUTH+2:4", HUD_LAYER, SOUTHEAST)
				upgrade_bg += create_screen("", "", 'icons/mob/hud_common.dmi', "hotbar_side", "CENTER+5:24, SOUTH+1:4", HUD_LAYER, WEST)

				upgrade_slots.len = 0
				for (var/i = 0; i < master.max_upgrades; i++)
					upgrade_slots += create_screen("upgrade[i+1]", "Upgrade [i+1]", 'icons/mob/hud_robot.dmi', "upgrade0", "CENTER+[startx+i]:24, SOUTH+1:4", HUD_LAYER+1)

				if (!show_upgrades) // this is dumb
					for (var/obj/screen/hud/H in upgrade_bg)
						remove_screen(H)
					for (var/obj/screen/hud/H in upgrade_slots)
						remove_screen(H)

			for (var/obj/item/roboupgrade/upgrade in last_upgrades)
				remove_object(upgrade)
			var/i = 0
			for (var/obj/item/roboupgrade/upgrade in master.upgrades)
				if (i >= upgrade_slots.len)
					break

				var/obj/screen/hud/slot = upgrade_slots[i+1]
				slot.icon_state = "upgrade[upgrade.activated]"
				if (show_upgrades)
					add_object(upgrade, HUD_LAYER+2, "CENTER+[startx+i]:24, SOUTH+1:4")
					i++
			last_upgrades = master.upgrades.Copy()
