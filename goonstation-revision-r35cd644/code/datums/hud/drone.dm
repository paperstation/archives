/datum/hud/drone
	var/obj/screen/charge
	var/obj/screen/health
	var/obj/screen/disconnect
	var/mob/living/silicon/drone/master
	var/list/tools = list(null, null, null, null, null)

	New(M)
		master = M
		charge = create_screen("health", "Condition", 'icons/mob/hud_drone.dmi', "health5", "NORTH, EAST", HUD_LAYER+1)
		charge = create_screen("charge", "Battery", 'icons/mob/hud_drone.dmi', "charge4", "NORTH, EAST-1", HUD_LAYER+1)
		disconnect = create_screen("disconnect", "Disconnect", 'icons/mob/hud_drone.dmi', "disconnect", "SOUTH, EAST", HUD_LAYER+1)
		tools[1] = create_screen("tool1", "Tool 1", 'icons/mob/hud_drone.dmi', "toolslot", "NORTH, 1", HUD_LAYER+1)
		tools[2] = create_screen("tool2", "Tool 2", 'icons/mob/hud_drone.dmi', "toolslot", "NORTH, 2", HUD_LAYER+1)
		tools[3] = create_screen("tool3", "Tool 3", 'icons/mob/hud_drone.dmi', "toolslot", "NORTH, 3", HUD_LAYER+1)
		tools[4] = create_screen("tool4", "Tool 4", 'icons/mob/hud_drone.dmi', "toolslot", "NORTH, 4", HUD_LAYER+1)
		tools[5] = create_screen("tool5", "Tool 5", 'icons/mob/hud_drone.dmi', "toolslot", "NORTH, 5", HUD_LAYER+1)
		update_health()
		update_charge()
		update_tools()

	clicked(id)
		if (!master)
			return
		switch (id)
			if ("tool1")
				master.swap_hand(1)
			if ("tool2")
				master.swap_hand(2)
			if ("tool3")
				master.swap_hand(3)
			if ("tool4")
				master.swap_hand(4)
			if ("tool5")
				master.swap_hand(5)
			if ("charge")
				if (master.controller)
					if (master.cell)
						var/perc = round(100*master.cell.charge/master.cell.maxcharge)
						boutput(master.controller, "<span style=\"color:blue\">Current cell charge level is [perc]%.</span>")
					else
						boutput(master.controller, "<span style=\"color:red\">No power cell installed. Only basic systems will be available.</span>")
			if ("disconnect")
				master.disconnect_user()

	proc
		update_health()
			if (!health)
				return
			if (master.stat == 2)
				health.icon_state = "dead"
			else
				switch(round(100*master.health/master.health_max))
					if(100 to INFINITY)
						health.icon_state = "health5"
					if(75 to 99)
						health.icon_state = "health4"
					if(50 to 75)
						health.icon_state = "health3"
					if(25 to 50)
						health.icon_state = "health2"
					if(1 to 25)
						health.icon_state = "health1"
					else
						health.icon_state = "health0"

		update_charge()
			if (!charge)
				return
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

		set_active_tool()
			var/list_counter = 0
			var/obj/screen/S = null
			for (var/obj/item/I in master.equipment_slots)
				list_counter++
				if (I == master.active_tool)
					S = tools[list_counter]
					S.icon_state = "toolslot1"
				else
					S = tools[list_counter]
					S.icon_state = "toolslot"

		update_tools()
			//for (var/obj/item/I in last_tools)
			//	remove_object(I)
			var/obj/item/tool1 = master.equipment_slots[1]
			var/obj/item/tool2 = master.equipment_slots[2]
			var/obj/item/tool3 = master.equipment_slots[3]
			var/obj/item/tool4 = master.equipment_slots[4]
			var/obj/item/tool5 = master.equipment_slots[5]
			if (tool1)
				add_object(tool1, HUD_LAYER+2, "NORTH, 1")
			if (tool2)
				add_object(tool2, HUD_LAYER+2, "NORTH, 2")
			if (tool3)
				add_object(tool3, HUD_LAYER+2, "NORTH, 3")
			if (tool4)
				add_object(tool4, HUD_LAYER+2, "NORTH, 4")
			if (tool5)
				add_object(tool5, HUD_LAYER+2, "NORTH, 5")