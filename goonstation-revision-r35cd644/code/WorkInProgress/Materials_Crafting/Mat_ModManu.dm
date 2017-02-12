//processing_items.Add(src)
//process()

//And the sloppiest code award 2014 goes to this file. FUCK. ME.
//This will need some major refactoring once im done.

/obj/workbench_ui/maptext_dummy
	name = ""
	desc = ""

/obj/workbench_ui
	layer = HUD_LAYER_UNDER_1

/obj/workbench_ui/menubutton
	name = "button"
	desc = ""
	icon = 'icons/misc/ManuUI.dmi'
	var/datum/modular_recipe/recipe = null
	New(var/datum/modular_recipe/C)
		recipe = C
		return

	Click(location,control,params)
		switch(src.name)
			if("okay")
				recipe.bench.build_recipe()
			if("hide")
				recipe.bench.hide_from(usr)
				recipe.bench.users.Remove(usr)
			if("unload")
				recipe.bench.unload_recipe()
		return

/obj/workbench_ui/menubutton/okay
	name = "okay"
	icon_state = "ok"

/obj/workbench_ui/menubutton/cancel
	name = "hide"
	icon_state = "cancel"

/obj/workbench_ui/menubutton/unload
	name = "unload"
	icon_state = "unload"

/obj/workbench_ui/slotbutton
	name = "slotbutton"
	desc = "flerpderp"
	icon = 'icons/misc/ManuUI.dmi'
	var/datum/modular_component/component = null

	New(var/datum/modular_component/C)
		component = C
		return

	Click(location,control,params)
		if(get_dist(component.recipe.bench, usr) > 1)
			component.recipe.bench.process() //This is dumb and im sorry.
			boutput(usr, "<span style=\"color:red\">You are too far away.</span>")
			return
		if(istype(usr, /mob/living/carbon/human))

			if(component.slot_object)
				boutput(usr, "<span style=\"color:red\">You remove the [component.slot_object].</span>")
				component.remove_object()
				return

			var/mob/living/carbon/human/H = usr

			if(!H.equipped())
				src.examine()
				return

			if(component.check_match(H.equipped()))
				var/atom/movable/M = H.equipped()
				H.drop_item()
				component.assign_object(M)
				boutput(usr, "<span style=\"color:green\">You put the [M] into the slot.</span>")
			else
				boutput(usr, "<span style=\"color:red\">Not enough items or wrong type.</span>")
				return
		..()

/datum/modular_component
	var/component_name = "component"
	var/component_desc = "a COMPONENT is required for this slot. What kind of component? WHO KNOWS!"
	var/icon_state = "pocket"
	var/datum/modular_recipe/recipe = null

	var/obj/workbench_ui/slotbutton/component_button = null
	var/obj/item/slot_object = null

	var/required_amount = 1

	New(var/datum/modular_recipe/p)
		recipe = p
		component_button = new (src)
		component_button.icon_state = icon_state
		component_button.name = component_name
		component_button.desc = component_desc
		return ..()

	proc/assign_object(var/atom/movable/A)
		if(!A) return
		A.x = 0
		A.y = 0
		A.z = 0
		A.layer = HUD_LAYER
		component_button.overlays.Cut()
		component_button.overlays.Add(A)
		src.slot_object = A
		component_button.name = A.name
		component_button.desc = A.desc
		return

	proc/remove_object(var/manual = 0)
		var/atom/movable/A = slot_object
		if(A)
			A.layer = initial(A.layer)
			slot_object = null
			component_button.name = component_name
			component_button.desc = component_desc
			component_button.overlays.Cut()
			if(!manual) A.set_loc(get_turf(recipe.bench))
		return

	proc/check_match(var/obj/item/A)
		if(A.amount < required_amount)
			boutput(usr, "<span style=\"color:red\">You do not have enough of that item for use in the recipe.</span>")
			return 0
		if(A.amount > required_amount)
			var/left = (A.amount - required_amount)
			A.amount = required_amount
			var/obj/item/X = new A.type(get_turf(recipe.bench))
			X.amount = left
			if(A.material) X.setMaterial(copyMaterial(A.material))
			boutput(usr, "<span style=\"color:blue\">You put the remaining [left] [A] on the workbench.</span>")
		return 1

/datum/modular_recipe
	var/recipe_name = "recipe"
	var/recipe_desc = "a recipe"
	var/list/recipe_parts = list()
	var/obj/workbench/bench = null

	var/obj/workbench_ui/menubutton/okay/okay
	var/obj/workbench_ui/menubutton/cancel/cancel
	var/obj/workbench_ui/menubutton/unload/unload
	var/obj/workbench_ui/maptext_dummy/maptext

	var/manual_component_handling = 0 //If 1 then the used materials will not be deleted.

	New(var/obj/workbench/w)
		bench = w
		var/loc_x = 0
		var/loc_y = 0

		maptext = new()
		okay = new (src)
		cancel = new (src)
		unload = new (src)

		okay.screen_loc = "CENTER-1, CENTER-1"
		cancel.screen_loc = "CENTER, CENTER-1"
		unload.screen_loc = "CENTER+1, CENTER-1"
		maptext.screen_loc = "CENTER-1, CENTER"
		maptext.maptext_width = 128
		maptext.maptext = "<span style=\"color:white\">[capitalize(recipe_name)]</span>"

		for(var/datum/modular_component/C in recipe_parts)
			C.component_button.screen_loc = "CENTER [loc_x - 1 > 0 ? "+" : ""][loc_x - 1 == 0 ? "" : loc_x - 1] , CENTER[-2+loc_y]"
			if(loc_x >= 2)
				loc_x = 0
				loc_y--
			else
				loc_x++

		return ..()

	proc/unload() //Dumps all the objects loaded into the recipe onto the floor.
		for(var/datum/modular_component/C in recipe_parts)
			C.remove_object()
		return

	proc/create()
		var/obj/storage/closet/newObj = new()
		return newObj

/obj/workbench
	icon = 'icons/obj/crafting.dmi'
	icon_state = "workbench"
	density = 1
	anchored = 1
	var/list/recipe_list = list()
	var/list/users = list()

	var/datum/modular_recipe/active_recipe = null
	var/list/active_buttons = list()

	var/building = 0

	ProximityLeave(atom/movable/AM as mob|obj)
		if(get_dist(src, AM) > 1 && users.Find(AM))
			users.Remove(AM)
			hide_from(AM)
		return

	Del()
		active_recipe = null
		for(var/datum/modular_recipe/R in recipe_list)
			R.unload()
			for(var/datum/modular_component/C in R.recipe_parts)
				if(C.component_button) qdel(C.component_button)
			R.recipe_parts.Cut()
		recipe_list.Cut()
		..()

	New()
		if (!(src in processing_items))
			processing_items.Add(src)
		var/list/types = typesof(/datum/modular_recipe) - /datum/modular_recipe
		for(var/r in types)
			recipe_list.Add(new r(src))
		return

	proc/process()
		for(var/mob/M in users)
			if(get_dist(src, M) > 1)
				users.Remove(M)
				hide_from(M)
		return

	attack_hand(mob/user as mob)
		if(active_recipe)
			if(!users.Find(user)) users.Add(user)
			show_to(user)
		else
			var/html = {"<!DOCTYPE html>
				<html>
					<head>
						<title>Workbench</title>
						<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
						<link rel="stylesheet" type="text/css" href="[resource("css/style.css")]">
					</head>
					<body id="manubody">"}
			html += {"<div id="manudiv">"}
			for(var/datum/modular_recipe/x in recipe_list)
				html += {"<div class="manuborder"><a class="manulink" href='?src=\ref[src];loadrecipe=\ref[x]'>[capitalize(x.recipe_name)]</a></div><br>"}
			html += {"</div>
					</body>
				</html>"}
			user << browse(html, "window=modmanu2;size=610x458;can_resize=0;can_minimize=0")
		return

	Topic(href, href_list)

		if(href_list["loadrecipe"])

			if(active_recipe)
				if(!users.Find(usr)) users.Add(usr)
				show_to(usr)
				usr << browse(null, "window=modmanu2")
				return

			var/datum/modular_recipe/sel = locate(href_list["loadrecipe"])
			if(sel && istype(sel, /datum/modular_recipe))
				load_recipe(sel)
				if(!users.Find(usr)) users.Add(usr)
				show_to(usr)
				usr << browse(null, "window=modmanu2")

	proc/unload_recipe()
		if(active_recipe)
			hide_from_all()
			users.Cut()
			for(var/datum/modular_component/C in active_recipe.recipe_parts)
				var/atom/movable/A = C.remove_object()
				if(A) A.set_loc(get_turf(src))
			active_recipe = null
		return

	proc/show_to(var/mob/M)
		if(active_recipe)
			if(M.client)
				M.client.screen += active_recipe.okay
				M.client.screen += active_recipe.cancel
				M.client.screen += active_recipe.unload
				M.client.screen += active_recipe.maptext
				for(var/datum/modular_component/C in active_recipe.recipe_parts)
					M.client.screen += C.component_button
		return

	proc/hide_from(var/mob/M)
		if(active_recipe)
			if(M.client)
				M.client.screen -= active_recipe.okay
				M.client.screen -= active_recipe.cancel
				M.client.screen -= active_recipe.unload
				M.client.screen -= active_recipe.maptext
				for(var/datum/modular_component/C in active_recipe.recipe_parts)
					M.client.screen -= C.component_button
		return

	proc/load_recipe(var/datum/modular_recipe/R)
		active_recipe = R
		return

	proc/hide_from_all()
		for(var/mob/M in users)
			hide_from(M)
		return

	proc/build_recipe()
		if(active_recipe)
			var/fail = 0
			for(var/datum/modular_component/C in active_recipe.recipe_parts)
				if(!C.slot_object)
					fail = 1
					break
			if(fail)
				boutput(usr, "<span style=\"color:red\">The recipe is not complete.</span>")
				return
			else
				playsound(src.loc, "sound/items/Ratchet.ogg", 100, 1)
				var/atom/movable/M = active_recipe.create()
				M.set_loc(src.loc)
				for(var/datum/modular_component/CB in active_recipe.recipe_parts)
					if(CB.slot_object)
						if(CB.slot_object == M) continue //To allow us to pass modified items through the recipe.
						var/atom/movable/AM = CB.slot_object
						CB.remove_object(active_recipe.manual_component_handling)
						if(!active_recipe.manual_component_handling) del(AM) //THIS NEEDS TO BE DEL NOT QDEL. DONT FUCK AROUND WITH IT.
						else CB.slot_object = null
				unload_recipe()
		return