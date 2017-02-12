/obj/machinery/computer/material
	name = "material recombobulator"
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer_generic"

	var/mob/using = null
	var/datum/material/editing = null
	var/obj/editing_obj = null

	New()
		..()

	attackby(obj/item/W as obj, mob/user as mob)
		if(W.material != null)
			if(!W.material.canMix || (!istype(W,/obj/item/raw_material) && !istype(W,/obj/item/material_piece)))
				boutput(user, "<span style=\"color:red\">This material can not be used in [src].</span>")
				return

			if(!editing)
				src.visible_message("<span style=\"color:blue\">[user] puts [W] into [src]</span>")
				user.drop_item()
				editing = W.material
				editing_obj = W
				W.loc = src
			else
				boutput(user, "<span style=\"color:red\">There's already a material inside [src]</span>")
		else
			boutput(user, "<span style=\"color:red\">This object has no material.</span>")
		return

	attack_ai(mob/user as mob)
		return attack_hand(user)

	attack_hand(mob/user as mob)
		if(stat & (BROKEN|NOPOWER))
			return

		if(using && (!using.client || using.client.inactivity >= 1200 || get_dist(src, using) > 1))
			using << browse(null, "window=materials")
			using = null

		if(using && using != user)
			boutput(user, "<span style=\"color:red\">Somebody is already using that machine.</span>")
			return.

		using = user

		//<a href='?src=\ref[src];fart=1'><small>(fart)</small></a>
		user.machine = src
		add_fingerprint(user)
		user << browse(grabResource("html/materialRecombobulator.html"), "window=materials;size=730x415;can_resize=0;can_minimize=0;can_close=0")
		onclose(user, "materials", src)

		spawn(10) callJsFunc(usr, "setRef", list("\ref[src]")) //This is shit but without it, it calls the JS before the window is open and doesn't work.
		return

	proc/handleRecipes()
		if(!editing || !editing_obj) return
		var/datum/material_recipe/RE = matchesMaterialRecipe(editing)
		if(RE)
			if(RE.result_item)
				var/atom/movable/A = new RE.result_item(src.loc)
				A.set_loc(src)
				editing = null
				del(editing_obj)
				editing_obj = A
				editing = A.material
			else if(length(RE.result_id))
				editing = null
				editing_obj.removeMaterial()
				editing_obj.setMaterial(getCachedMaterial(RE.result_id))
			else
				RE.apply_to(editing)
				editing_obj.setMaterial(editing_obj.material)
		return

	Topic(href, href_list)
		//boutput(world, href)
		if(!using || get_dist(using, src) > 1)
			using << browse(null, "window=materials")
			using = null
			return

		if(href_list["close"])
			using = null
		else if(href_list["jscall"])
			switch(href_list["jscall"])
				if("refResearch")
					loadContent("Research")
				if("selMod")
					if(!editing)
						callJsFunc(usr, "showDialog", list("No material to edit. Please insert material into computer."))
						return

					var/newhtml = ""

					switch(href_list["name"])
						if("Wendigo thermal insulation")
							newhtml += "<table><tr>"
							newhtml += "<th>BEFORE<br>[generateMaterialInfo()]</th>" //Before
							editing.setProperty(PROP_THERMAL, max(editing.getProperty(PROP_THERMAL) - 10, 18))
							editing.setProperty(PROP_INSTABILITY, editing.getProperty(PROP_INSTABILITY) + 10)
							editing_obj.setMaterial(editing_obj.material)
							handleRecipes()
							newhtml += "<th>AFTER<br>[generateMaterialInfo()]</th>" //After
							newhtml += "</tr></table>"
							callJsFunc(usr, "setHtmlId", list("#tabs-3", newhtml))
						if("Wendigo King thermal protection")
							newhtml += "<table><tr>"
							newhtml += "<th>BEFORE<br>[generateMaterialInfo()]</th>" //Before
							editing.setProperty(PROP_THERMAL, max(editing.getProperty(PROP_THERMAL) - 20, 10))
							editing.setProperty(PROP_INSTABILITY, editing.getProperty(PROP_INSTABILITY) + 25)
							editing.addDelegate(editing.triggersOnLife, new /datum/materialProc/wendigo_temp_onlife())
							editing_obj.setMaterial(editing_obj.material)
							handleRecipes()
							newhtml += "<th>AFTER<br>[generateMaterialInfo()]</th>" //After
							newhtml += "</tr></table>"
							callJsFunc(usr, "setHtmlId", list("#tabs-3", newhtml))
						if("Supernatural enhancement")
							newhtml += "<table><tr>"
							newhtml += "<th>BEFORE<br>[generateMaterialInfo()]</th>" //Before
							editing.color = "#FFFFFF"
							editing.setProperty(PROP_ENERGY, min(editing.getProperty(PROP_ENERGY) + 20, 95))
							editing.addDelegate(editing.triggersOnAdd, new /datum/materialProc/ethereal_add())
							editing.setProperty(PROP_INSTABILITY, editing.getProperty(PROP_INSTABILITY) + 33)
							editing_obj.setMaterial(editing_obj.material)
							handleRecipes()
							newhtml += "<th>AFTER<br>[generateMaterialInfo()]</th>" //After
							newhtml += "</tr></table>"
							callJsFunc(usr, "setHtmlId", list("#tabs-3", newhtml))
				if("closeWindow")
					usr << browse(null, "window=materials")
					using = null
				if("ejectMaterial")
					if(editing_obj)
						editing_obj.set_loc(src.loc)
						editing = null
						editing_obj = null
				if("loadTab")
					if(href_list["newTab"])
						loadContent(href_list["newTab"])
				if("research")
					if(href_list["id"] && materialsResearch.research.Find(href_list["id"]))
						var/datum/materialResearch/R = materialsResearch.research[href_list["id"]]
						var/error = R.canStart()
						if(!error)
							R.beginResearch()
							loadContent("Research")
						else
							callJsFunc(usr, "showDialog", list(error))

		src.add_fingerprint(usr)
		callJsFunc(usr, "setRef", list("\ref[src]"))
		return

	proc/loadContent(var/content, var/divId)
		switch(content)
			if("View Material")
				if(src.editing)
					callJsFunc(usr, "setHtmlId", list(divId ? divId : "#tabs-2", "[generateMaterialInfo()]"))
				else
					callJsFunc(usr, "setHtmlId", list(divId ? divId : "#tabs-2", "No material loaded."))

			if("Modify Material")
				var/scripts = ""
				var/newhtml = ""
				newhtml += {"<ul id="modmenu">"}
				newhtml += {"<li class="ui-widget-header">Standard methods</li>"}
				newhtml += {"<li class="ui-widget-header">Researched methods</li>"}
				if(materialsResearch.completed.Find("wendigo")) newhtml += {"<li>Wendigo thermal insulation</li>"}
				if(materialsResearch.completed.Find("wendigoking")) newhtml += {"<li>Wendigo King thermal protection</li>"}
				if(materialsResearch.completed.Find("supernatural2")) newhtml += {"<li>Supernatural enhancement</li>"}
				if(materialsResearch.completed.Find("recondition1") && !materialsResearch.completed.Find("recondition2")) newhtml += {"<li>Reconditioning</li>"}
				if(materialsResearch.completed.Find("recondition2")) newhtml += {"<li>Advanced reconditioning</li>"}
				newhtml += {"</ul">"}
				scripts += {"<script>$(function() {$( "#modmenu" ).menu({items: "> :not(.ui-widget-header)" });});</script>"}
				scripts += {"<script>$(function() {$( "#modmenu" ).on( "menuselect", function( event, ui ) {callByond("selMod", \["name=" + ui.item.text()\]);});});</script>"}
				newhtml += scripts
				callJsFunc(usr, "setHtmlId", list(divId ? divId : "#tabs-3", newhtml))

			if("Research")
				var/scripts = {"<script>$(function() {$( "#researchfold" ).accordion({heightStyle: "content" });});</script>"}
				var/newhtml = {"<div style="height:365px; padding:0px; margin:0px; border:0px;overflow:auto">"}
				newhtml += {"<button id="bttrefreshres" style="top:39px;z-index: 200;font-size:10px;position:absolute;left:675px;">Refresh</button>"}
				newhtml += {"<div id="researchfold" style="width:670px;overflow:visible;max-width: 670px;">"}
				scripts += {"<script>$(function(){$( "#bttrefreshres" ).button({icons: {primary: "ui-icon-refresh" },text: false});$( "#bttrefreshres" ).click(function() {callByond("refResearch", \[\]);});});</script>"}

				for(var/x in materialsResearch.research)
					var/datum/materialResearch/R = materialsResearch.research[x]
					if(!R.canShow()) continue
					newhtml += "<h3>[R.name]  <div id=\"prog[R.id]\" style=\"float: right;\"><span id=\"proglabel[R.id]\" style=\"position:absolute;width: 300px;text-align: center; margin-top:2px; font-size: 9px;\">[R.statusString]</span></div></h3>"
					newhtml += "<div><div style=\"width:625px;max-width:625px;\">[R.completed ? (length(R.r_desc) ? R.r_desc : R.desc) : R.desc]</div>"
					newhtml += "<br>Research cost: [R.researchCost] ([wagesystem.research_budget])	|	Research duration: [round(R.researchTime / 10)]s<br>"
					if(istype(R, /datum/materialResearch/scanner))
						newhtml += "<br>Required Scans:<br>"
						var/linkcount = 0
						for(var/datum/materialResearchScan/S in R:requiredScans)
							newhtml += {"<div id="sc[R.id][linkcount]" style="width:150px;background-color: [S.completed?"#5FD269":"#D2655F"];cursor: pointer; cursor: hand;">[S.name]</div><br>"} //I could use jquery for this but fuck it
							if(!R.completed) scripts += {"<script>$('#sc[R.id][linkcount]').click(function(){ showDialog("[S.name]<br><br>[S.desc]"); return false; });</script>"}
							linkcount++

					if(!R.completed) newhtml += "<br><button id=\"btt[R.id]\">Research</button>"
					newhtml += "</div>"

					scripts += {"<script>$(function(){$( "#prog[R.id]" ).progressbar({value:[R.prcComplete],max:100});$( "#prog[R.id]" ).height(15);$( "#prog[R.id]" ).width(300);});</script>"}
					scripts += {"<script>$(function(){$( "#btt[R.id]" ).button();});</script>"}
					scripts += {"<script>$(function(){$( "#btt[R.id]" ).click(function() {callByond("research", \["id=[R.id]"\]);});});</script>"}

				newhtml +=  "</div>"
				newhtml +=  "</div>"
				newhtml += scripts
				callJsFunc(usr, "setHtmlId", list(divId ? divId : "#tabs-4", newhtml))
		return

	proc/callJsFunc(var/client, var/funcName, var/list/params)
		var/paramsJS = list2params(params)
		client << output(paramsJS,"materials.browser:[funcName]")
		return

	proc/generateMaterialInfo()
		var/matInfo = ""
		if(!editing) return "No material"
		matInfo += "<div class=\"matcomptext\">[editing.name]</div>"
		matInfo += "<div class=\"matcomptext\">[editing.material_flags & MATERIAL_CRYSTAL ? "(Crystal)":""][editing.material_flags & MATERIAL_METAL ? "(Metal)":""][editing.material_flags & MATERIAL_CLOTH ? "(Fabric)":""][editing.material_flags & MATERIAL_ORGANIC ? "(Organic)":""][editing.material_flags & MATERIAL_ENERGY ? "(Energy)":""][editing.material_flags & MATERIAL_RUBBER ? "(Rubber)":""]</div><br>"
		matInfo += "<div class=\"matcomptext\">Color: <div style=\"width:35px; height:8px; display:inline-block; background-color: [editing.color];margin:0px;border-style: solid;border-width: 1px;\"></div></div>"
		matInfo += "<div class=\"matcomptext\">Quality: [editing.quality]%</div>"

		for(var/X in editing.properties)
			matInfo += "<div class=\"matcomptext\">[X]: [editing.getProperty(X)] / [editing.getProperty(X, VALUE_MAX)]</div>"

		matInfo += "<div class=\"matcomptext\">Unique Effects: [editing.triggersTemp.len + editing.triggersChem.len + editing.triggersPickup.len + editing.triggersDrop.len + editing.triggersExp.len + editing.triggersOnAdd.len + editing.triggersOnLife.len + editing.triggersOnAttack.len + editing.triggersOnAttacked.len + editing.triggersOnEntered.len]</div>" //AAAAHHH
		return matInfo

/obj/machinery/smelter_portable
	name = "Portable Smelter"
	desc = "A small furnace-like machine used to melt and combine metals or minerals."
	icon = 'icons/obj/crafting.dmi'
	icon_state = "portsmelter0"
	anchored = 0
	density = 1
	layer = FLOOR_EQUIP_LAYER1
	var/list/components = list()
	var/sound/sound_bubble = sound('sound/effects/bubbles.ogg')
	var/datum/material/output = null
	var/datum/light/light

	New()
		..()
		light = new /datum/light/point
		light.attach(src)
		light.set_brightness(0.5)
		light.set_color(1, 0.6, 0.2)

	proc/resetMats()
		icon_state = "portsmelter0"
		output = null
		for(var/atom/A in components)
			qdel(A)
		components.Cut()
		return

	attack_hand(mob/user as mob)
		if(output)
			var/datum/material_recipe/R = matchesMaterialRecipe(output)
			if(R)
				if(R.result_item)
					var/atom/A = new R.result_item(src.loc)
					boutput(user, "<span style=\"color:blue\">You remove [A.name] from the [src].</span>")
					resetMats()
					return
				else if(length(R.result_id))
					output = getCachedMaterial(R.result_id)
				else
					R.apply_to(output)

			boutput(user, "<span style=\"color:blue\">You remove [output.name] from the [src].</span>")
			icon_state = "portsmelter0"

			var/bar_type = getProcessedMaterialForm(output)
			var/obj/item/material_piece/M = new bar_type(src.loc)

			M.add_fingerprint(user) // May not be the same person who smelted the materials (Convair880).
			src.add_fingerprint(user) // Add some prints to the smelter too.

			M.setMaterial(output)
			resetMats()

			if(M.material && prob(M.material.getProperty(PROP_INSTABILITY)))
				M.visible_message("<span style=\"color:red\">[M] [getMatFailString(M.material.material_flags)]!</span>")
				M.material.triggerOnFail(M)
			return

		if(components.len > 0)

			if(!src.powered())
				boutput(usr, "<span style=\"color:red\">The smelter is not powered.</span>")
				return
			else
				src.use_power(1000)

			light.enable()
			playsound(src.loc, sound_bubble, 40, 1)
			if(components.len == 1)
				boutput(user, "<span style=\"color:red\">You activate the [src].</span>")
				icon_state = "portsmelter2"
				sleep(10)
				var/atom/obj1 = components[1]
				output = copyMaterial(obj1.material)
			else
				icon_state = "portsmelter2"
				sleep(10)
				var/atom/obj1 = components[1]
				var/atom/obj2 = components[2]

				var/datum/material/mat1 = obj1.material
				var/datum/material/mat2 = obj2.material

				if(!mat1 || !mat2)
					icon_state = "portsmelter0"
					return

				output = getFusedMaterial(mat1, mat2)
				output.generation++
			logTheThing("station", user, null, "creates a [output] bar (<b>Material:</b> <i>[output.mat_id]</i>) with the [src] at [log_loc(src)].") //  Re-added/fixed because of erebite, plasmastone etc. alloys (Convair880).
			spawn(8)
				light.disable()
		else
			boutput(user, "<span style=\"color:red\">There is nothing in the [src].</span>")
		return

	attackby(obj/item/W as obj, mob/user as mob)
		if(W.material != null)
			if(!W.material.canMix || (!istype(W,/obj/item/raw_material) && !istype(W,/obj/item/material_piece)))
				boutput(user, "<span style=\"color:red\">This material can not be used in the [src].</span>")
				return
			if(W.material.material_flags & MATERIAL_METAL || W.material.material_flags & MATERIAL_CRYSTAL)
				if(components.len < 2)
					src.visible_message("<span style=\"color:blue\">[user] puts [W] into [src]</span>")
					user.drop_item()
					components.Add(W)
					W.loc = src
					icon_state = "portsmelter1"
				else
					boutput(user, "<span style=\"color:red\">The smelter is already filled to capacity!</span>")
					return
			else
				boutput(user, "<span style=\"color:red\">The smelter can only use metals or minerals.</span>")
				return
		return

	ex_act(severity)
		return

/obj/machinery/loom
	name = "Auto-loom"
	desc = "A piece of machinery used to process fabrics."
	icon = 'icons/obj/crafting.dmi'
	icon_state = "loom-off"
	anchored = 1
	density = 1
	layer = FLOOR_EQUIP_LAYER1

	var/list/components = list()
	var/active = 0

	New()
		..()

	proc/resetMats()
		icon_state = "loom-off"
		for(var/atom/A in components)
			qdel(A)
		components.Cut()
		return

	proc/produceMaterial(var/datum/material/O)
		if(!O) return

		var/datum/material_recipe/R = matchesMaterialRecipe(O)
		if(R)
			if(R.result_item)
				new R.result_item(src.loc)
				resetMats()
				return
			else if(length(R.result_id))
				O = getCachedMaterial(R.result_id)

		var/obj/item/material_piece/cloth/M = new/obj/item/material_piece/cloth(src.loc)
		M.setMaterial(O)
		resetMats()
		if(M.material && prob(M.material.getProperty(PROP_INSTABILITY)))
			M.visible_message("<span style=\"color:red\">[M] [getMatFailString(M.material.material_flags)]!</span>")
			M.material.triggerOnFail(M)
		return

	attack_hand(mob/user as mob)
		if(active) return
		if(components.len > 0)
			if(components.len == 1)
				boutput(user, "<span style=\"color:red\">You activate the [src].</span>")
				icon_state = "loom-work"
				playsound(src.loc, "sound/machines/loom.ogg", 35, 0)
				active = 1
				sleep(25)
				active = 0
				var/atom/obj1 = components[1]
				produceMaterial(copyMaterial(obj1.material))
			else
				icon_state = "loom-work"
				playsound(src.loc, "sound/machines/loom.ogg", 35, 0)
				active = 1
				sleep(25)
				active = 0
				var/atom/obj1 = components[1]
				var/atom/obj2 = components[2]

				var/datum/material/mat1 = obj1.material
				var/datum/material/mat2 = obj2.material

				if(!mat1 || !mat2)
					icon_state = "loom-off"
					return

				var/datum/material/output = getFusedMaterial(mat1, mat2)
				output.generation++
				produceMaterial(output)
		else
			boutput(user, "<span style=\"color:red\">There is nothing in the [src].</span>")
		return

	attackby(obj/item/W as obj, mob/user as mob)
		if(active) return

		if (istype(W,/obj/item/clothing/under/))
			src.visible_message("<span style=\"color:blue\">[user] puts [W] into [src]</span>")
			var/datum/material/M
			if (W.material)
				M = W.material
			else
				M = getCachedMaterial("cotton")
			qdel(W)
			icon_state = "loom-work"
			playsound(src.loc, "sound/machines/loom.ogg", 35, 0)
			active = 1
			sleep(10)
			active = 0
			produceMaterial(M)
			return

		if (istype(W,/obj/item/clothing/shoes/))
			src.visible_message("<span style=\"color:blue\">[user] puts [W] into [src]</span>")
			var/datum/material/M
			if (W.material)
				M = W.material
			else
				M = getCachedMaterial("leather")
			qdel(W)
			icon_state = "loom-work"
			playsound(src.loc, "sound/machines/loom.ogg", 35, 0)
			active = 1
			sleep(10)
			active = 0
			produceMaterial(M)
			return

		if(W.material != null)
			if(!W.material.canMix)
				boutput(user, "<span style=\"color:red\">This material can not be used in the [src].</span>")
				return

			if(W.material.material_flags & MATERIAL_CLOTH || W.material.material_flags & MATERIAL_RUBBER)
				if(components.len < 2)
					icon_state = "loom-on"
					src.visible_message("<span style=\"color:blue\">[user] puts [W] into [src]</span>")
					user.drop_item()
					components.Add(W)
					W.loc = src
				else
					boutput(user, "<span style=\"color:red\">The loom can not hold any more materials!</span>")
					return
			else
				boutput(user, "<span style=\"color:red\">The loom can only use cloth or rubber.</span>")
				return
		return

	ex_act(severity)
		return

/obj/machinery/smelter
	name = "Arc Smelter"
	desc = "A huge furnace-like machine used to melt and combine metals or minerals."
	icon = 'icons/effects/96x96.dmi'
	icon_state = "smelter0"
	anchored = 1
	bound_height = 96
	bound_width = 96
	density = 1
	layer = FLOOR_EQUIP_LAYER1

	var/list/components = list()
	var/slag_level = 0

	var/sound/sound_thunk = sound('sound/items/Deconstruct.ogg')
	var/sound/sound_zap = sound('sound/effects/elec_bzzz.ogg')
	var/sound/sound_hiss = sound('sound/machines/hiss.ogg')
	var/sound/sound_bubble = sound('sound/effects/bubbles.ogg')

	var/datum/material/output = null
	var/datum/light/light

	New()
		..()
		light = new /datum/light/point
		light.attach(src, 1.5, 1.5)
		light.set_brightness(0.5)
		light.set_color(0.4, 0.8, 1)

	proc/resetMats()
		icon_state = "smelter0"
		output = null
		for(var/atom/A in components)
			qdel(A)
		components.Cut()
		return

	attack_hand(mob/user as mob)
		if(output)
			var/datum/material_recipe/R = matchesMaterialRecipe(output)
			if(R)
				if(R.result_item)
					var/atom/A = new R.result_item(locate(src.x + 1, src.y, src.z))
					boutput(user, "<span style=\"color:blue\">You remove [A.name] from the [src].</span>")
					playsound(src.loc, sound_thunk, 40, 1)
					resetMats()
					return
				else if(length(R.result_id))
					output = getCachedMaterial(R.result_id)
				else
					R.apply_to(output)

			boutput(user, "<span style=\"color:blue\">You remove [output.name] from the [src].</span>")

			var/bar_type = getProcessedMaterialForm(output)
			var/obj/item/material_piece/M = new bar_type(locate(src.x + 1, src.y, src.z))

			M.add_fingerprint(user) // May not be the same person who smelted the materials (Convair880).
			src.add_fingerprint(user) // Add some prints to the smelter too.

			M.setMaterial(output)
			resetMats()
			playsound(src.loc, sound_thunk, 40, 1)

			if(M.material && prob(M.material.getProperty(PROP_INSTABILITY)))
				M.visible_message("<span style=\"color:red\">[M] [getMatFailString(M.material.material_flags)]!</span>")
				M.material.triggerOnFail(M)
			return

		if(components.len > 0)
			light.enable()
			playsound(src.loc, sound_zap, 40, 1)
			spawn(5)
				playsound(src.loc, sound_bubble, 40, 1)
			if(components.len == 1)
				boutput(user, "<span style=\"color:red\">You activate the [src].</span>")
				icon_state = "smelter1"
				sleep(10)
				var/atom/obj1 = components[1]
				output = copyMaterial(obj1.material)
				logTheThing("station", user, null, "creates a [output] bar (<b>Material:</b> <i>[output.mat_id]</i>) with the [src] at [log_loc(src)].") //  Re-added/fixed because of erebite, plasmastone etc. alloys (Convair880).
				handleSlag()
			else
				icon_state = "smelter1"
				sleep(10)
				var/atom/obj1 = components[1]
				var/atom/obj2 = components[2]

				var/datum/material/mat1 = obj1.material
				var/datum/material/mat2 = obj2.material

				if(!mat1 || !mat2)
					icon_state = "smelter0"
					return

				output = getFusedMaterial(mat1, mat2)
				output.generation++
				logTheThing("station", user, null, "creates a [output] bar (<b>Material:</b> <i>[output.mat_id]</i>) with the [src] at [log_loc(src)].") // Sorry for code duplication, but I'm regularly seeing runtime errors for some reason if this proc is called after handleSlag (Convair880).
				handleSlag()
			spawn(8)
				playsound(src.loc, sound_hiss, 45, 1)
				light.disable()
		else
			boutput(user, "<span style=\"color:red\">There is nothing in the [src].</span>")
		return

	proc/handleSlag()
		switch(slag_level)
			if(500 to 1000)
				particleMaster.SpawnSystem(new /datum/particleSystem/localSmoke("#967360", 10, locate(src.x +1, src.y, src.z)))
				//output.adjustProperty(PROP_INSTABILITY , 5)
				output.quality += rand(5, -15)
			if(1000 to INFINITY)
				particleMaster.SpawnSystem(new /datum/particleSystem/localSmoke("#221511", 10, locate(src.x +1, src.y, src.z)))
				output.quality += rand(-15, -30)
				//output.adjustProperty(PROP_INSTABILITY , 15)
		slag_level += (100 - output.quality)
		return

	suicide(var/mob/user)
		if (!user)
			return

		user.visible_message("<span style=\"color:red\"><b>[user] hops right into [src]! Jesus!</b></span>")
		user.unequip_all()
		user.set_loc(src)


		var/datum/material/M = new /datum/material/organic/flesh {desc="A disgusting wad of flesh."; color="#881111";} ()
		M.name = "[user.real_name] flesh"

		var/obj/item/dummyItem = new (src)
		dummyItem.material = M
		components += dummyItem
		user.ghostize()

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/slag_shovel))
			if(slag_level)
				src.visible_message("<span style=\"color:blue\">[user] removes slag from the [src]</span>")
				slag_level = 0
				new/obj/item/material_piece/slag(src.loc)
				return
			else
				boutput(user, "<span style=\"color:blue\">There is no slag in [src].</span>")
				return

		if(istype(W, /obj/item/wizard_crystal) && components.len < 2 && !W.material)
			W.material = new W:assoc_material()

		if(W.material != null)
			if(!W.material.canMix)
				boutput(user, "<span style=\"color:red\">This material can not be used in the [src].</span>")
				return

			if((W.material.material_flags & MATERIAL_METAL || W.material.material_flags & MATERIAL_CRYSTAL) && (istype(W, /obj/item/material_piece) || istype(W, /obj/item/raw_material)) )
				if(components.len < 2)
					src.visible_message("<span style=\"color:blue\">[user] puts [W] into [src]</span>")
					user.drop_item()
					components.Add(W)
					W.loc = src
					playsound(src.loc, sound_thunk, 40, 1)
				else
					boutput(user, "<span style=\"color:red\">The smelter is already filled to capacity!</span>")
					return
			else
				boutput(user, "<span style=\"color:red\">The smelter can only use metals or minerals in raw form.</span>")
				return
		return

	ex_act(severity) // bloo bloo we blew it up and nobody gets to have fun
		return

//
/obj/item/device/matanalyzer
	icon_state = "matanalyzer"
	name = "Material analyzer"
	flags = FPRINT | EXTRADELAY | TABLEPASS | CONDUCT
	w_class = 2

	afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
		if(get_dist(src, target) <= 2)
			var/atom/W = target
			if(!W.material)
				boutput(user, "<span style=\"color:red\">No material found.</span>")
			else
				boutput(user, "<span style=\"color:blue\">[W.material.name]</span>")
				boutput(user, "<span style=\"color:blue\">[W.material.desc]</span>")
				boutput(user, "<span style=\"color:blue\">Quality: [W.material.quality]%</span>")
				boutput(user, "<br>")

				if(W.material.properties.len)
					boutput(user, "Noteworthy properties:")
					for(var/X in W.material.properties)
						boutput(user, "<span style=\"color:blue\">[X]: [W.material.getProperty(X)] / [W.material.getProperty(X, VALUE_MAX)]</span>")

				if(W.material.triggersTemp.len || W.material.triggersChem.len || W.material.triggersPickup.len || W.material.triggersDrop.len || W.material.triggersExp.len || W.material.triggersOnAdd.len || W.material.triggersOnLife.len || W.material.triggersOnAttack.len || W.material.triggersOnAttacked.len)
					boutput(user, "<span style=\"color:blue\">Material has unique properties.</span>")

		else
			boutput(user, "<span style=\"color:red\">[target] is too far away.</span>")
		return

/obj/item/slag_shovel
	name = "slag shovel"
	desc = "Used to remove slag from the arc smelter."
	icon = 'icons/obj/items.dmi'
	icon_state = "shovel"
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	item_state = "pick"
	w_class = 3
	flags = ONBELT
	force = 7 // 15 puts it significantly above most other weapons
	hitsound = 'sound/weapons/smash.ogg'