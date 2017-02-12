//RECIPES START//

/datum/modular_recipe/flash
	recipe_name = "flash"
	recipe_desc = "A flash."

	New(var/obj/workbench/w)
		recipe_parts.Add(new/datum/modular_component/energy_cell_small(src))
		recipe_parts.Add(new/datum/modular_component/material_metal(src))
		recipe_parts.Add(new/datum/modular_component/lens(src))
		return ..(w)

	create()
		var/obj/item/device/flash/newObj = new()
		var/datum/modular_component/cell = recipe_parts[1] //This should be the energy cell if order is preserved.
		var/datum/modular_component/metal = recipe_parts[2] //This should be the metal if order is preserved.
		var/datum/modular_component/lens = recipe_parts[3] //This should be the lens if order is preserved.

		if(cell.slot_object && cell.slot_object.material && metal.slot_object && metal.slot_object.material)
			newObj.setMaterial(metal.slot_object.material)
			newObj.name = "[cell.slot_object.name] fitted [newObj.name]"
			newObj.desc = newObj.desc + " It has a [cell.slot_object.name] and a [lens.slot_object.name]."
			newObj.use = round(cell.slot_object:max_charge / 10) * (-1)
			newObj.eye_damage_mod = round(lens.slot_object:focal_strength / 30)
			newObj.range_mod = round(lens.slot_object:clarity / 55)
			newObj.burn_mod = round(metal.slot_object.material.getProperty(PROP_THERMAL) / 9) * (-1)
			newObj.stun_mod = round(metal.slot_object.material.quality / 40)
		return newObj

/datum/modular_recipe/flashlight
	recipe_name = "flashlight"
	recipe_desc = "A flashlight."

	New(var/obj/workbench/w)
		recipe_parts.Add(new/datum/modular_component/energy_cell_large(src))
		recipe_parts.Add(new/datum/modular_component/material_metal(src))
		recipe_parts.Add(new/datum/modular_component/lens(src))
		return ..(w)

	create()
		var/obj/item/device/flashlight/newObj = new()
		var/datum/modular_component/cell = recipe_parts[1] //This should be the energy cell if order is preserved.
		var/datum/modular_component/metal = recipe_parts[2] //This should be the metal if order is preserved.
		var/datum/modular_component/lens = recipe_parts[3] //This should be the lens if order is preserved.

		if(cell.slot_object && cell.slot_object.material && metal.slot_object && metal.slot_object.material)
			newObj.setMaterial(metal.slot_object.material)
			newObj.name = "[lens.slot_object.name] [newObj.name]"
			newObj.desc = newObj.desc + " It has a [lens.slot_object.name]."
			newObj.col_r = GetRedPart(lens.slot_object.material.color) / 255
			newObj.col_g = GetGreenPart(lens.slot_object.material.color) / 255
			newObj.col_b = GetBluePart(lens.slot_object.material.color) / 255

		return newObj

/datum/modular_recipe/cell_small
	recipe_name = "small energy cell"
	recipe_desc = "A small energy cell used in guns and small portable devices."

	New(var/obj/workbench/w)
		recipe_parts.Add(new/datum/modular_component/material_energy(src))
		return ..(w)

	create()
		var/obj/item/ammo/power_cell/newObj = new()
		var/datum/modular_component/C = recipe_parts[1]
		if(C.slot_object && C.slot_object.material)
			newObj.setMaterial(C.slot_object.material)
		return newObj

/datum/modular_recipe/cell_large
	recipe_name = "large energy cell"
	recipe_desc = "A large enery cell, often used in APCs or cyborgs."

	New(var/obj/workbench/w)
		recipe_parts.Add(new/datum/modular_component/material_energy(src))
		return ..(w)

	create()
		var/obj/item/cell/newObj = new()
		var/datum/modular_component/C = recipe_parts[1]
		if(C.slot_object && C.slot_object.material)
			newObj.setMaterial(C.slot_object.material)
		return newObj

/datum/modular_recipe/arrowhead
	recipe_name = "arrowhead"
	recipe_desc = "A few arrowheads."

	New(var/obj/workbench/w)
		recipe_parts.Add(new/datum/modular_component/material_metal_or_crystal(src))
		return ..(w)

	create()
		var/obj/item/arrowhead/newObj = new()
		var/datum/modular_component/C = recipe_parts[1]
		if(C.slot_object && C.slot_object.material)
			newObj.setMaterial(C.slot_object.material)
		newObj.amount = 4
		return newObj

/datum/modular_recipe/lens
	recipe_name = "lens"
	recipe_desc = "A small lens."

	New(var/obj/workbench/w)
		recipe_parts.Add(new/datum/modular_component/material_crystal(src))
		return ..(w)

	create()
		var/obj/item/lens/newObj = new()
		var/datum/modular_component/C = recipe_parts[1]
		if(C.slot_object && C.slot_object.material)
			newObj.setMaterial(C.slot_object.material)
		return newObj

/datum/modular_recipe/gears
	recipe_name = "gears"
	recipe_desc = "Some gears."

	New(var/obj/workbench/w)
		recipe_parts.Add(new/datum/modular_component/material_metal(src))
		return ..(w)

	create()
		var/obj/item/gears/newObj = new()
		var/datum/modular_component/C = recipe_parts[1]
		if(C.slot_object && C.slot_object.material)
			newObj.setMaterial(C.slot_object.material)
		return newObj

/datum/modular_recipe/small_coil
	recipe_name = "small coil"
	recipe_desc = "A small coil."

	New(var/obj/workbench/w)
		recipe_parts.Add(new/datum/modular_component/material_metal(src))
		return ..(w)

	create()
		var/obj/item/coil/small/newObj = new()
		var/datum/modular_component/C = recipe_parts[1]
		if(C.slot_object && C.slot_object.material)
			newObj.setMaterial(C.slot_object.material)
		return newObj

/datum/modular_recipe/large_coil
	recipe_name = "large coil"
	recipe_desc = "A large coil."

	New(var/obj/workbench/w)
		recipe_parts.Add(new/datum/modular_component/material_metal(src))
		return ..(w)

	create()
		var/obj/item/coil/large/newObj = new()
		var/datum/modular_component/C = recipe_parts[1]
		if(C.slot_object && C.slot_object.material)
			newObj.setMaterial(C.slot_object.material)
		return newObj

/datum/modular_recipe/sheets_ten
	recipe_name = "10 sheets"
	recipe_desc = "10 sheets of a given material."

	New(var/obj/workbench/w)
		recipe_parts.Add(new/datum/modular_component/material_any(src))
		return ..(w)

	create()
		var/obj/item/sheet/newObj = new()
		var/datum/modular_component/C = recipe_parts[1]
		if(C.slot_object && C.slot_object.material)
			newObj.setMaterial(C.slot_object.material)
		newObj.amount = 10
		return newObj

/datum/modular_recipe/jumpsuit
	recipe_name = "jumpsuit"
	recipe_desc = "A simple jumpsuit."

	New(var/obj/workbench/w)
		recipe_parts.Add(new/datum/modular_component/material_fabric(src))
		return ..(w)

	create()
		var/obj/item/clothing/under/color/whitetemp/newObj = new()
		var/datum/modular_component/C = recipe_parts[1]
		if(C.slot_object && C.slot_object.material)
			newObj.setMaterial(C.slot_object.material)
		return newObj

/datum/modular_recipe/atmoscanister
	recipe_name = "atmos canister"
	recipe_desc = "A large gas canister."

	New(var/obj/workbench/w)
		recipe_parts.Add(new/datum/modular_component/material_metal(src))
		return ..(w)

	create()
		var/obj/machinery/portable_atmospherics/canister/newObj = new()
		var/datum/modular_component/C = recipe_parts[1]
		if(C.slot_object && C.slot_object.material)
			newObj.setMaterial(C.slot_object.material)
		return newObj

/datum/modular_recipe/horsemask
	recipe_name = "horse mask"
	recipe_desc = "A horse mask."

	New(var/obj/workbench/w)
		recipe_parts.Add(new/datum/modular_component/material_any(src))
		return ..(w)

	create()
		var/obj/item/clothing/mask/horse_mask/newObj = new()
		var/datum/modular_component/C = recipe_parts[1]
		if(C.slot_object && C.slot_object.material)
			newObj.setMaterial(C.slot_object.material)
		return newObj

/datum/modular_recipe/armorplates
	recipe_name = "armor plates"
	recipe_desc = "Some armor plates."

	New(var/obj/workbench/w)
		recipe_parts.Add(new/datum/modular_component/tile/three(src))
		recipe_parts.Add(new/datum/modular_component/rods_5(src))
		return ..(w)

	create()
		var/obj/item/aplate/newObj = new()
		var/datum/modular_component/tiles = recipe_parts[1]
		var/datum/modular_component/rods = recipe_parts[2]

		if(tiles.slot_object && tiles.slot_object.material && rods.slot_object && rods.slot_object.material)
			newObj.setMaterial(tiles.slot_object.material)

		return newObj

/datum/modular_recipe/harmor
	recipe_name = "heavy armor"
	recipe_desc = "heavy armor."

	New(var/obj/workbench/w)
		recipe_parts.Add(new/datum/modular_component/aplate(src))
		recipe_parts.Add(new/datum/modular_component/rods_5(src))
		return ..(w)

	create()
		var/obj/item/clothing/suit/armor/heavy/newObj = new()
		var/datum/modular_component/plates = recipe_parts[1]
		var/datum/modular_component/rods = recipe_parts[2]

		if(plates.slot_object && plates.slot_object.material && rods.slot_object && rods.slot_object.material)
			newObj.setMaterial(plates.slot_object.material)

		return newObj

/datum/modular_recipe/podarmor
	recipe_name = "pod armor"
	recipe_desc = "pod armor."

	New(var/obj/workbench/w)
		recipe_parts.Add(new/datum/modular_component/aplate(src))
		recipe_parts.Add(new/datum/modular_component/rods_5(src))
		recipe_parts.Add(new/datum/modular_component/material_crystal(src))
		recipe_parts.Add(new/datum/modular_component/gears(src))
		return ..(w)

	create()
		var/obj/item/pod/armor_custom/newObj = new()
		var/datum/modular_component/plates = recipe_parts[1]

		if(plates.slot_object && plates.slot_object.material)
			newObj.setMaterial(plates.slot_object.material)

		return newObj

/datum/modular_recipe/fuelpellet
	recipe_name = "fuel pellet"
	recipe_desc = "A small fueled pellet used in RTGs."

	New(var/obj/workbench/w)
		recipe_parts.Add(new/datum/modular_component/material_metal(src))
		return ..(w)

	create()
		var/obj/item/fuel_pellet/newObj = new()
		var/datum/modular_component/C = recipe_parts[1]
		if(C.slot_object && C.slot_object.material)
			newObj.setMaterial(C.slot_object.material)
		return newObj

/datum/modular_recipe/cablecoil
	recipe_name = "cable coil"
	recipe_desc = "A coil of cable."

	New(var/obj/workbench/w)
		recipe_parts.Add(new/datum/modular_component/material_any(src))
		recipe_parts.Add(new/datum/modular_component/material_metal(src))
		return ..(w)

	create()
		var/obj/item/cable_coil/newObj = new()
		var/datum/modular_component/C = recipe_parts[1] //Insulator
		var/datum/modular_component/C2 = recipe_parts[2] //Conductor
		if(C.slot_object && C.slot_object.material && C2.slot_object && C2.slot_object.material)
			applyCableMaterials(newObj, C.slot_object.material, C2.slot_object.material)
			newObj.amount = MAXCOIL
		return newObj

/datum/modular_recipe/tripod
	recipe_name = "tripod"
	recipe_desc = "A 3-legged stand for supporting various devices."

	New(var/obj/workbench/w)
		recipe_parts.Add(new/datum/modular_component/rods_3(src))
		return ..(w)

	create()
		var/obj/item/tripod/newObj = new()
		var/datum/modular_component/C = recipe_parts[1]
		if(C.slot_object && C.slot_object.material)
			newObj.setMaterial(C.slot_object.material)
		return newObj

/datum/modular_recipe/eguncellswap
	recipe_name = "Swap energy gun cell"
	recipe_desc = "Allows you to switch out the energy cell used by a gun."
	manual_component_handling = 1

	New(var/obj/workbench/w)
		recipe_parts.Add(new/datum/modular_component/egun(src))
		recipe_parts.Add(new/datum/modular_component/energy_cell_small(src))
		return ..(w)

	create()
		var/datum/modular_component/gun = recipe_parts[1]
		var/datum/modular_component/cell = recipe_parts[2]

		var/obj/item/gun/energy/gunobj = gun.slot_object
		var/obj/item/ammo/power_cell/cellobj = cell.slot_object

		// Those self-charging ten-shot radbows were a bit overpowered (Convair880).
		if (gunobj.custom_cell_max_capacity && (cellobj.max_charge > gunobj.custom_cell_max_capacity))
			usr.show_text("This power cell won't fit!", "red")
			cellobj.set_loc(bench.loc)
			return gunobj

		if(gunobj.cell)
			gunobj.cell.set_loc(bench.loc)
			gunobj.cell = null

		gunobj.cell = cellobj
		cellobj.set_loc(gunobj)

		gunobj.logme_temp(usr, gunobj, gunobj.cell) // Added a pair of proc calls here (Convair880).
		gunobj.update_icon()

		if(!processing_items.Find(gunobj))
			processing_items.Add(gunobj)

		return gunobj

// Made batons use energy cells, and it make sense that you can swap them too (Convair880).
/datum/modular_recipe/batoncellswap
	recipe_name = "Swap stun baton cell"
	recipe_desc = "Allows you to switch out the energy cell used by a stun baton."
	manual_component_handling = 1

	New(var/obj/workbench/w)
		recipe_parts.Add(new/datum/modular_component/baton(src))
		recipe_parts.Add(new/datum/modular_component/energy_cell_small(src))
		return ..(w)

	create()
		var/datum/modular_component/baton = recipe_parts[1]
		var/datum/modular_component/cell = recipe_parts[2]

		var/obj/item/baton/batonobj = baton.slot_object
		var/obj/item/ammo/power_cell/cellobj = cell.slot_object

		if (batonobj.uses_electricity == 0 || batonobj.uses_charges == 0)
			usr.show_text("This baton doesn't require a power cell.", "red")
			cellobj.set_loc(bench.loc)
			return batonobj

		if (batonobj.cell)
			batonobj.cell.set_loc(bench.loc)
			batonobj.cell = null

		batonobj.cell = cellobj
		cellobj.set_loc(batonobj)

		batonobj.log_cellswap(usr, batonobj.cell)
		batonobj.update_icon()

		if (!processing_items.Find(batonobj))
			processing_items.Add(batonobj)

		return batonobj

/datum/modular_recipe/meleeweapon
	recipe_name = "Improvised weapon"
	recipe_desc = "Allows you to improvise a weapon of some sort. Results may vary depending on items used."
	manual_component_handling = 1

	New(var/obj/workbench/w)
		recipe_parts.Add(new/datum/modular_component/item_any/core(src))
		recipe_parts.Add(new/datum/modular_component/item_any/head(src))
		return ..(w)

	create()
		var/datum/modular_component/core = recipe_parts[1]
		var/datum/modular_component/head = recipe_parts[2]

		var/obj/item/coreobj = core.slot_object
		var/obj/item/headobj = head.slot_object

		var/list/long_stuff = list(/obj/item/rods, /obj/item/rods/steel, /obj/item/baton, /obj/item/crowbar, /obj/item/slag_shovel, /obj/item/clothing/head/plunger)
		var/list/sharp_stuff = list(/obj/item/raw_material/shard, /obj/item/raw_material/shard/plasmacrystal, /obj/item/raw_material/shard/glass, /obj/item/scalpel, /obj/item/wirecutters, /obj/item/screwdriver, /obj/item/scissors, /obj/item/razor_blade, /obj/item/kitchen/utensil/knife, /obj/item/kitchen/utensil/fork)

		if(long_stuff.Find(coreobj.type) && sharp_stuff.Find(headobj.type)) //I guess this makes a spear.
			var/obj/item/craftedmelee/spear/spear = new/obj/item/craftedmelee/spear(bench.loc)

			coreobj.set_loc(spear)
			headobj.set_loc(spear)

			spear.core = coreobj
			spear.head = headobj

			spear.rebuild()
			return spear
		else if (long_stuff.Find(coreobj.type) && istype(headobj, /obj/item/arrowhead))
			if (headobj.amount < 1)
				headobj.amount = 1
			if (coreobj.amount < 1)
				coreobj.amount = 1
			var/obj/item/arrow/A = new(bench.loc)
			A.setHeadMaterial(headobj.material)
			A.setShaftMaterial(coreobj.material)
			A.amount = min(headobj.amount, coreobj.amount)
			headobj.amount -= A.amount
			coreobj.amount -= A.amount
			if (headobj.amount <= 0)
				qdel(headobj)
			if (coreobj.amount <= 0)
				qdel(coreobj)
			return A
		else
			//var/obj/item/craftedcrap/crap = new/obj/item/craftedcrap(bench.loc)

			//coreobj.set_loc(crap)
			//headobj.set_loc(crap)

			coreobj.set_loc(bench.loc)
			headobj.set_loc(bench.loc)

			//crap.item1 = coreobj
			//crap.item2 = headobj

			//crap.rebuild()

			return coreobj //crap

//RECIPES END//



//COMPONENTS START//
/datum/modular_component/item_any/core
	component_name = "any item (core)"

/datum/modular_component/item_any/head
	component_name = "any item (head)"

/datum/modular_component/item_any
	component_name = "any item"
	component_desc = "This slot requires an item of any type."
	icon_state = "pocket"

	check_match(var/obj/item/A)
		if(!..(A)) return 0 //This checks for the amount.
		if(istype(A,/obj/item)) return 1
		return 0

/datum/modular_component/material_any
	component_name = "any material"
	component_desc = "This slot requires a material of any type."
	icon_state = "any"

	check_match(var/obj/item/A)
		if(!..(A)) return 0 //This checks for the amount.
		if(!istype(A,/obj/item/raw_material) && !istype(A,/obj/item/material_piece)) return 0
		if(A.material)
			return 1
		return 0

/datum/modular_component/material_metal
	component_name = "metal"
	component_desc = "This slot requires some form of metal."
	icon_state = "metal"

	check_match(var/obj/item/A)
		if(!..(A)) return 0 //This checks for the amount.
		if(!istype(A,/obj/item/raw_material) && !istype(A,/obj/item/material_piece)) return 0
		if(A.material)
			if(A.material.material_flags & MATERIAL_METAL) return 1
		return 0

/datum/modular_component/material_crystal
	component_name = "crystal"
	component_desc = "This slot requires some form of crystal."
	icon_state = "crystal"

	check_match(var/obj/item/A)
		if(!..(A)) return 0 //This checks for the amount.
		if(!istype(A,/obj/item/raw_material) && !istype(A,/obj/item/material_piece)) return 0
		if(A.material)
			if(A.material.material_flags & MATERIAL_CRYSTAL) return 1
		return 0

/datum/modular_component/material_metal_or_crystal
	component_name = "metal or crystal"
	component_desc = "This slot requires some form of metal or crystal."
	icon_state = "metal_or_crystal"

	check_match(var/obj/item/A)
		if(!..(A)) return 0 //This checks for the amount.
		if(!istype(A,/obj/item/raw_material) && !istype(A,/obj/item/material_piece)) return 0
		if(A.material)
			if(A.material.material_flags & MATERIAL_CRYSTAL || A.material.material_flags & MATERIAL_METAL) return 1
		return 0

/datum/modular_component/material_fabric
	component_name = "fabric"
	component_desc = "This slot requires some form of fabric."
	icon_state = "fabric"

	check_match(var/obj/item/A)
		if(!..(A)) return 0 //This checks for the amount.
		if(!istype(A,/obj/item/raw_material) && !istype(A,/obj/item/material_piece)) return 0
		if(A.material)
			if(A.material.material_flags & MATERIAL_CLOTH) return 1
		return 0

/datum/modular_component/material_rubber
	component_name = "rubber"
	component_desc = "This slot requires some form of rubber."
	icon_state = "rubber"

	check_match(var/obj/item/A)
		if(!..(A)) return 0 //This checks for the amount.
		if(!istype(A,/obj/item/raw_material) && !istype(A,/obj/item/material_piece)) return 0
		if(A.material)
			if(A.material.material_flags & MATERIAL_RUBBER) return 1
		return 0

/datum/modular_component/material_organic
	component_name = "organic material"
	component_desc = "This slot requires some form of organic material."
	icon_state = "organic"

	check_match(var/obj/item/A)
		if(!..(A)) return 0 //This checks for the amount.
		if(!istype(A,/obj/item/raw_material) && !istype(A,/obj/item/material_piece)) return 0
		if(A.material)
			if(A.material.material_flags & MATERIAL_ORGANIC) return 1
		return 0

/datum/modular_component/material_energy
	component_name = "energy source"
	component_desc = "This slot requires some form of raw energy source."
	icon_state = "energy"

	check_match(var/obj/item/A)
		if(!..(A)) return 0 //This checks for the amount.
		if(!istype(A,/obj/item/raw_material) && !istype(A,/obj/item/material_piece)) return 0
		if(A.material)
			if(A.material.material_flags & MATERIAL_ENERGY) return 1
		return 0

/datum/modular_component/energy_cell_small
	component_name = "small energy cell"
	component_desc = "This slot requires some form of small enery cell, often used in energy guns."
	icon_state = "sbattery"

	check_match(var/obj/item/A)
		if(!..(A)) return 0 //This checks for the amount.
		if(istype(A,/obj/item/ammo/power_cell)) return 1
		return 0

/datum/modular_component/energy_cell_large
	component_name = "large energy cell"
	component_desc = "This slot requires some form of large enery cell."
	icon_state = "lbattery"

	check_match(var/obj/item/A)
		if(!..(A)) return 0 //This checks for the amount.
		if(istype(A,/obj/item/cell)) return 1
		return 0

/datum/modular_component/lens
	component_name = "lens"
	component_desc = "This slot requires a lens."
	icon_state = "lens"

	check_match(var/obj/item/A)
		if(!..(A)) return 0 //This checks for the amount.
		if(istype(A,/obj/item/lens)) return 1
		return 0

/datum/modular_component/gears
	component_name = "gears"
	component_desc = "This slot requires some gears."
	icon_state = "gears"

	check_match(var/obj/item/A)
		if(!..(A)) return 0 //This checks for the amount.
		if(istype(A,/obj/item/gears)) return 1
		return 0

/datum/modular_component/rods_3
	component_name = "3+ rods"
	component_desc = "This slot requires at least 3 rods."
	icon_state = "3rods"
	required_amount = 3

	check_match(var/obj/item/A)
		if(!..(A)) return 0 //This checks for the amount.
		if(istype(A,/obj/item/rods)) return 1
		return 0

/datum/modular_component/rods_5
	component_name = "5+ rods"
	component_desc = "This slot requires at least 5 rods."
	icon_state = "5rods"
	required_amount = 5

	check_match(var/obj/item/A)
		if(!..(A)) return 0 //This checks for the amount.
		if(istype(A,/obj/item/rods)) return 1
		return 0

/datum/modular_component/aplate
	component_name = "armor plate"
	component_desc = "This slot requires armor plates."
	icon_state = "armor"

	check_match(var/obj/item/A)
		if(!..(A)) return 0 //This checks for the amount.
		if(istype(A,/obj/item/aplate)) return 1
		return 0

/datum/modular_component/tile
	component_name = "floor tiles"
	component_desc = "This slot requires floor tiles."
	icon_state = "tile"

	check_match(var/obj/item/A)
		if(!..(A)) return 0 //This checks for the amount.
		if(istype(A,/obj/item/tile)) return 1
		return 0

/datum/modular_component/tile/three
	component_name = "3 floor tiles"
	component_desc = "This slot requires 3 floor tiles."
	icon_state = "tile"
	required_amount = 3

/datum/modular_component/egun
	component_name = "energy gun"
	component_desc = "This slot requires an energy cell-based gun."
	icon_state = "egun"

	check_match(var/obj/item/A)
		if(!..(A)) return 0 //This checks for the amount.
		if(istype(A,/obj/item/gun/energy)) return 1
		return 0

/datum/modular_component/baton
	component_name = "stun baton"
	component_desc = "This slot requires an energy cell-based stun baton."
	icon_state = "baton"

	check_match(var/obj/item/A)
		if (!..(A)) return 0 //This checks for the amount.
		if (istype(A, /obj/item/baton))
			var/obj/item/baton/B = A
			if (B.uses_electricity != 0 && B.uses_charges != 0)
				return 1
		return 0

//COMPONENTS END//