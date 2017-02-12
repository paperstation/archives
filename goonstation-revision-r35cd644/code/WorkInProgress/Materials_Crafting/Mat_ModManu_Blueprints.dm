/*///////RECIPE DATUMS
/datum/manufacturer_blueprint/sunglasses
	name = "Sunglasses"
	desc = "Some fancy sunglasses."
	assembly_time = 40

	setParts()
		part_list.Add("Glass")
		part_list["Glass"] = new/datum/manufacturer_part(MATERIAL_CRYSTAL, "Glass")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/item/clothing/glasses/sunglasses/G = new/obj/item/clothing/glasses/sunglasses(get_turf(owner))

		var/datum/manufacturer_part/part1 = part_list["Glass"]
		G.setMaterial(part1.assigned.material)
		return 1


/datum/manufacturer_blueprint/mop
	name = "Mop"
	desc = "A mop."
	assembly_time = 40

	setParts()
		part_list.Add("Metal")
		part_list["Metal"] = new/datum/manufacturer_part(MATERIAL_METAL, "Metal")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/item/mop/G = new/obj/item/mop(get_turf(owner))

		var/datum/manufacturer_part/part1 = part_list["Metal"]
		G.setMaterial(part1.assigned.material)
		return 1

/datum/manufacturer_blueprint/basketball
	name = "Basketball"
	desc = "A basketball."
	assembly_time = 40

	setParts()
		part_list.Add("Rubber")
		part_list["Rubber"] = new/datum/manufacturer_part(MATERIAL_RUBBER, "Rubber")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/item/basketball/G = new/obj/item/basketball(get_turf(owner))

		var/datum/manufacturer_part/part1 = part_list["Rubber"]
		G.setMaterial(part1.assigned.material)
		return 1

/datum/manufacturer_blueprint/baton
	name = "Baton"
	desc = "A security baton."
	assembly_time = 40

	setParts()
		part_list.Add("Metal")
		part_list["Metal"] = new/datum/manufacturer_part(MATERIAL_METAL, "Metal")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/item/baton/G = new/obj/item/baton(get_turf(owner))

		var/datum/manufacturer_part/part1 = part_list["Metal"]
		G.setMaterial(part1.assigned.material)
		return 1

/datum/manufacturer_blueprint/bulletstwentytwo
	name = "Custom .22 bullets"
	desc = "8 custom .22 caliber bullets."
	assembly_time = 40

	setParts()
		part_list.Add("Metal")
		part_list["Metal"] = new/datum/manufacturer_part(MATERIAL_METAL, "Metal")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/item/ammo/bullets/custom/G = new/obj/item/ammo/bullets/custom(get_turf(owner))

		var/datum/manufacturer_part/part1 = part_list["Metal"]
		G.setMaterial(part1.assigned.material)
		return 1

/datum/manufacturer_blueprint/wateringcan
	name = "Watering can"
	desc = "A watering can."
	assembly_time = 40

	setParts()
		part_list.Add("Metal")
		part_list["Metal"] = new/datum/manufacturer_part(MATERIAL_METAL, "Metal")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/item/reagent_containers/glass/wateringcan/G = new/obj/item/reagent_containers/glass/wateringcan(get_turf(owner))

		var/datum/manufacturer_part/part1 = part_list["Metal"]
		G.setMaterial(part1.assigned.material)
		return 1

/datum/manufacturer_blueprint/chainsaw
	name = "Chainsaw"
	desc = "A chainsaw."
	assembly_time = 80

	setParts()
		part_list.Add("Metal")
		part_list["Metal"] = new/datum/manufacturer_part(MATERIAL_METAL, "Metal")

		part_list.Add("Energy")
		part_list["Energy"] = new/datum/manufacturer_part(MATERIAL_ENERGY, "Energy source")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/item/saw/G = new/obj/item/saw(get_turf(owner))

		var/datum/manufacturer_part/part1 = part_list["Metal"]
		G.setMaterial(part1.assigned.material)
		return 1

/datum/manufacturer_blueprint/shoes
	name = "Shoes"
	desc = "Shoes! Not very protective."
	assembly_time = 20

	setParts()
		part_list.Add("Fabric")
		part_list["Fabric"] = new/datum/manufacturer_part(MATERIAL_CLOTH, "Fabric")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/item/clothing/shoes/white/G = new/obj/item/clothing/shoes/white(get_turf(owner))

		var/datum/manufacturer_part/part1 = part_list["Fabric"]

		var/datum/material/M = part1.assigned.material

		G.setMaterial(M)
		return 1

/datum/manufacturer_blueprint/rollingpin
	name = "Rolling pin"
	desc = "A rolling pin."
	assembly_time = 40

	setParts()
		part_list.Add("Metal")
		part_list["Metal"] = new/datum/manufacturer_part(MATERIAL_METAL, "Metal")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/item/kitchen/rollingpin/G = new/obj/item/kitchen/rollingpin(get_turf(owner))

		var/datum/manufacturer_part/part1 = part_list["Metal"]
		G.setMaterial(part1.assigned.material)
		return 1

///MAKE ESCAPE TIME DEPEDANT ON MATERIAL!!!!!!!!!!! Exploding erebite handcuffs?
/datum/manufacturer_blueprint/handcuffs
	name = "Handcuffs"
	desc = "Some handcuffs."
	assembly_time = 40

	setParts()
		part_list.Add("Metal")
		part_list["Metal"] = new/datum/manufacturer_part(MATERIAL_METAL, "Metal")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/item/handcuffs/G = new/obj/item/handcuffs(get_turf(owner))

		var/datum/manufacturer_part/part1 = part_list["Metal"]
		G.setMaterial(part1.assigned.material)
		return 1

/datum/manufacturer_blueprint/spaceset
	name = "Space suit set"
	desc = "A space suit, helmet and jetpack."
	assembly_time = 200

	setParts()
		part_list.Add("Fabric")
		part_list["Fabric"] = new/datum/manufacturer_part(MATERIAL_CLOTH, "Fabric")

		part_list.Add("Padding")
		part_list["Padding"] = new/datum/manufacturer_part(MATERIAL_CLOTH, "Padding")

		part_list.Add("Reinforment")
		part_list["Reinforment"] = new/datum/manufacturer_part(MATERIAL_METAL, "Reinforment")

		part_list.Add("Jetpack")
		part_list["Jetpack"] = new/datum/manufacturer_part(MATERIAL_METAL, "Jetpack metal")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/item/clothing/suit/space/G = new/obj/item/clothing/suit/space(get_turf(owner))
		var/obj/item/clothing/head/helmet/space/G1 = new/obj/item/clothing/head/helmet/space(get_turf(owner))
		var/obj/item/tank/jetpack/G2 = new/obj/item/tank/jetpack(get_turf(owner))

		var/datum/manufacturer_part/part1 = part_list["Fabric"]
		var/datum/manufacturer_part/part2 = part_list["Jetpack"]

		var/datum/material/M = part1.assigned.material

		G.setMaterial(M)
		G1.setMaterial(M)
		G2.setMaterial(part2.assigned.material)
		return 1

/datum/manufacturer_blueprint/gasmask
	name = "Gas mask"
	desc = "A gas mask. Doesn't protect much from physical attacks."
	assembly_time = 50

	setParts()
		part_list.Add("Fabric")
		part_list["Fabric"] = new/datum/manufacturer_part(MATERIAL_CLOTH, "Fabric")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/item/clothing/mask/gas/emergency/G = new/obj/item/clothing/mask/gas/emergency(get_turf(owner))

		var/datum/manufacturer_part/part1 = part_list["Fabric"]

		var/datum/material/M = part1.assigned.material

		G.setMaterial(M)
		return 1

/datum/manufacturer_blueprint/gastank
	name = "Gas tank"
	desc = "A portable gas tank."
	assembly_time = 40

	setParts()
		part_list.Add("Metal")
		part_list["Metal"] = new/datum/manufacturer_part(MATERIAL_METAL, "Metal")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/item/tank/air/G = new/obj/item/tank/air(get_turf(owner))

		var/datum/manufacturer_part/part1 = part_list["Metal"]
		G.setMaterial(part1.assigned.material)
		return 1

/datum/manufacturer_blueprint/beakers
	name = "Beaker box"
	desc = "A box of simple beakers."
	assembly_time = 40

	setParts()
		part_list.Add("Material")
		part_list["Material"] = new/datum/manufacturer_part(MATERIAL_CRYSTAL, "Material")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/item/storage/box/beakerbox/G = new/obj/item/storage/box/beakerbox(get_turf(owner))

		var/datum/manufacturer_part/part1 = part_list["Material"]

		G.name = "Box of [part1.assigned.material.name] beakers"

		for(var/atom/A in G)
			A.setMaterial(part1.assigned.material)
		return 1

/datum/manufacturer_blueprint/labcoat
	name = "Labcoat"
	desc = "A labcoat. Not very good against physical hazards but very good against diseases."
	assembly_time = 50

	setParts()
		part_list.Add("Fabric")
		part_list["Fabric"] = new/datum/manufacturer_part(MATERIAL_CLOTH, "Fabric")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/item/clothing/suit/labcoat/G = new/obj/item/clothing/suit/labcoat(get_turf(owner))

		var/datum/manufacturer_part/part1 = part_list["Fabric"]

		var/datum/material/M = part1.assigned.material

		G.setMaterial(M)

		return 1

/datum/manufacturer_blueprint/firesuit
	name = "Firesuit"
	desc = "A firesuit. Doesn't help much against physical attacks but can have superb temperature stats."
	assembly_time = 50

	setParts()
		part_list.Add("Fabric")
		part_list["Fabric"] = new/datum/manufacturer_part(MATERIAL_CLOTH, "Fabric")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/item/clothing/suit/fire/G = new/obj/item/clothing/suit/fire(get_turf(owner))

		var/datum/manufacturer_part/part1 = part_list["Fabric"]

		var/datum/material/M = part1.assigned.material

		G.setMaterial(M)
		return 1

/datum/manufacturer_blueprint/cutlery
	name = "Cutlery set"
	desc = "A fork, spoon and knife."
	assembly_time = 30

	setParts()
		part_list.Add("Metal")
		part_list["Metal"] = new/datum/manufacturer_part(MATERIAL_METAL, "Metal")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/item/kitchen/utensil/fork/G = new/obj/item/kitchen/utensil/fork(get_turf(owner))
		var/obj/item/kitchen/utensil/spoon/G1 = new/obj/item/kitchen/utensil/spoon(get_turf(owner))
		var/obj/item/kitchen/utensil/knife/G2 = new/obj/item/kitchen/utensil/knife(get_turf(owner))

		var/datum/manufacturer_part/part1 = part_list["Metal"]

		G.setMaterial(part1.assigned.material)
		G1.setMaterial(part1.assigned.material)
		G2.setMaterial(part1.assigned.material)
		return 1

/datum/manufacturer_blueprint/glass
	name = "Drinking glass"
	desc = "A drinking glass."
	assembly_time = 20

	setParts()
		part_list.Add("Material")
		part_list["Material"] = new/datum/manufacturer_part(MATERIAL_CRYSTAL, "Material")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/item/reagent_containers/food/drinks/drinkingglass/G = new/obj/item/reagent_containers/food/drinks/drinkingglass(get_turf(owner))

		var/datum/manufacturer_part/part1 = part_list["Material"]
		G.setMaterial(part1.assigned.material)
		return 1

/datum/manufacturer_blueprint/plate
	name = "Plate"
	desc = "A simple plate for food."
	assembly_time = 20

	setParts()
		part_list.Add("Material")
		part_list["Material"] = new/datum/manufacturer_part(MATERIAL_CRYSTAL, "Material")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/item/plate/G = new/obj/item/plate(get_turf(owner))

		var/datum/manufacturer_part/part1 = part_list["Material"]
		G.setMaterial(part1.assigned.material)
		return 1

/datum/manufacturer_blueprint/extinguisher
	name = "Extinguisher"
	desc = "A fire extinguisher."
	assembly_time = 40

	setParts()
		part_list.Add("Metal")
		part_list["Metal"] = new/datum/manufacturer_part(MATERIAL_METAL, "Metal")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/item/extinguisher/G = new/obj/item/extinguisher(get_turf(owner))

		var/datum/manufacturer_part/part1 = part_list["Metal"]
		G.setMaterial(part1.assigned.material)
		return 1

/datum/manufacturer_blueprint/toolbox_emergency
	name = "Emergency toolbox"
	desc = "A complete emergency toolbox."
	assembly_time = 80

	setParts()
		part_list.Add("Metal")
		part_list["Metal"] = new/datum/manufacturer_part(MATERIAL_METAL, "Metal")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/item/storage/toolbox/emergency/G = new/obj/item/storage/toolbox/emergency(get_turf(owner))

		var/datum/manufacturer_part/part1 = part_list["Metal"]

		G.setMaterial(part1.assigned.material)

		for(var/atom/A in G)
			A.setMaterial(part1.assigned.material)
		return 1

/datum/manufacturer_blueprint/toolbox_electrical
	name = "Electrical toolbox"
	desc = "A complete electrical toolbox."
	assembly_time = 80

	setParts()
		part_list.Add("Metal")
		part_list["Metal"] = new/datum/manufacturer_part(MATERIAL_METAL, "Metal")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/item/storage/toolbox/electrical/G = new/obj/item/storage/toolbox/electrical(get_turf(owner))

		var/datum/manufacturer_part/part1 = part_list["Metal"]
		G.setMaterial(part1.assigned.material)

		for(var/atom/A in G)
			A.setMaterial(part1.assigned.material)
		return 1

/datum/manufacturer_blueprint/toolbox_mechanical
	name = "Mechanical toolbox"
	desc = "A complete mechanical toolbox."
	assembly_time = 80

	setParts()
		part_list.Add("Metal")
		part_list["Metal"] = new/datum/manufacturer_part(MATERIAL_METAL, "Metal")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/item/storage/toolbox/mechanical/G = new/obj/item/storage/toolbox/mechanical(get_turf(owner))

		var/datum/manufacturer_part/part1 = part_list["Metal"]
		G.setMaterial(part1.assigned.material)

		for(var/atom/A in G)
			A.setMaterial(part1.assigned.material)
		return 1

/datum/manufacturer_blueprint/glasssheet10
	name = "Glass sheet x10"
	desc = "Sheets of glass-like material."
	assembly_time = 20

	setParts()
		part_list.Add("Panel")
		part_list["Panel"] = new/datum/manufacturer_part(MATERIAL_CRYSTAL, "Panel")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/item/sheet/G = new/obj/item/sheet(get_turf(owner))

		var/datum/manufacturer_part/part1 = part_list["Panel"]
		G.setMaterial(part1.assigned.material)
		G.amount = 10
		return 1

/datum/manufacturer_blueprint/metalsheet10
	name = "Metal sheet x10"
	desc = "Sheets of metal-like material."
	assembly_time = 20

	setParts()
		part_list.Add("Panel")
		part_list["Panel"] = new/datum/manufacturer_part(MATERIAL_METAL, "Panel")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/item/sheet/G = new/obj/item/sheet(get_turf(owner))

		var/datum/manufacturer_part/part1 = part_list["Panel"]
		G.setMaterial(part1.assigned.material)
		G.amount = 10
		return 1

/datum/manufacturer_blueprint/slagshovel
	name = "Slag shovel"
	desc = "A shovel used to remove slag from the arc smelter."
	assembly_time = 40

	setParts()
		part_list.Add("Shovel")
		part_list["Shovel"] = new/datum/manufacturer_part(MATERIAL_METAL, "Shovel")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/item/slag_shovel/G = new/obj/item/slag_shovel(get_turf(owner))

		var/datum/manufacturer_part/part1 = part_list["Shovel"]
		G.setMaterial(part1.assigned.material)
		return 1

/datum/manufacturer_blueprint/gloves
	name = "Gloves"
	desc = "Simple gloves."
	assembly_time = 30

	setParts()
		part_list.Add("Fabric")
		part_list["Fabric"] = new/datum/manufacturer_part(MATERIAL_CLOTH, "Fabric")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/item/clothing/gloves/latex/G = new/obj/item/clothing/gloves/latex(get_turf(owner))
		G.name = "gloves"

		var/datum/manufacturer_part/part1 = part_list["Fabric"]
		G.setMaterial(part1.assigned.material)
		return 1

/datum/manufacturer_blueprint/jumpsuit
	name = "Jumpsuit"
	desc = "A very basic jumpsuit. Has capped stats due to thin fabric."
	assembly_time = 40

	setParts()
		part_list.Add("Fabric")
		part_list["Fabric"] = new/datum/manufacturer_part(MATERIAL_CLOTH, "Fabric")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/item/clothing/under/color/whitetemp/G = new/obj/item/clothing/under/color/whitetemp(get_turf(owner))

		var/datum/manufacturer_part/part1 = part_list["Fabric"]

		var/datum/material/M = part1.assigned.material

		G.setMaterial(M)
		return 1

/datum/manufacturer_blueprint/podarmor
	name = "Pod Armor"
	desc = "A custom-built set of pod armor."
	assembly_time = 300

	setParts()
		part_list.Add("Armor plating")
		part_list["Armor plating"] = new/datum/manufacturer_part(MATERIAL_METAL, "Armor plating")

		part_list.Add("Coating")
		part_list["Coating"] = new/datum/manufacturer_part(MATERIAL_CRYSTAL, "Coating")

		part_list.Add("Bolts")
		part_list["Bolts"] = new/datum/manufacturer_part(MATERIAL_METAL, "Bolts")

		part_list.Add("Struts")
		part_list["Struts"] = new/datum/manufacturer_part(MATERIAL_METAL, "Struts")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/item/pod/armor_custom/G = new/obj/item/pod/armor_custom(get_turf(owner))

		var/datum/manufacturer_part/part1 = part_list["Armor plating"]
		G.setMaterial(part1.assigned.material)
		return 1

/datum/manufacturer_blueprint/harmor
	name = "Heavy Armor"
	desc = "A full set of heavy armor. Offers good protection against attacks but not much else."
	assembly_time = 40

	setParts()
		part_list.Add("Plating")
		part_list["Plating"] = new/datum/manufacturer_part(MATERIAL_METAL, "Plating")

		part_list.Add("Coating")
		part_list["Coating"] = new/datum/manufacturer_part(MATERIAL_CRYSTAL, "Coating")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/item/clothing/suit/armor/heavy/G = new/obj/item/clothing/suit/armor/heavy(get_turf(owner))

		var/datum/manufacturer_part/part1 = part_list["Plating"]

		var/datum/material/M = part1.assigned.material

		G.setMaterial(M)
		return 1

/datum/manufacturer_blueprint/horse
	name = "Horse mask"
	desc = "A stupid looking horse mask."
	assembly_time = 40

	setParts()
		part_list.Add("Mask")
		part_list["Mask"] = new/datum/manufacturer_part(MATERIAL_METAL, "Mask")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/item/clothing/mask/horse_mask/G = new/obj/item/clothing/mask/horse_mask(get_turf(owner))

		var/datum/manufacturer_part/part1 = part_list["Mask"]
		G.setMaterial(part1.assigned.material)
		return 1

/datum/manufacturer_blueprint/gtank
	name = "Atmos Canister"
	desc = "A large gas tank."
	assembly_time = 40

	setParts()
		part_list.Add("Hull")
		part_list["Hull"] = new/datum/manufacturer_part(MATERIAL_METAL, "Hull")
		return

	assemble(var/atom/owner)
		for(var/datum/manufacturer_part/P in part_list)
			if(!P.assigned) return 0

		var/obj/machinery/portable_atmospherics/canister/G = new/obj/machinery/portable_atmospherics/canister(get_turf(owner))

		var/datum/manufacturer_part/part1 = part_list["Hull"]
		G.setMaterial(part1.assigned.material)
		return 1

/datum/manufacturer_blueprint
	var/name = "blueprint" //Please make sure names are unique. They are also used as ID
	var/desc = "desc"
	var/list/part_list = list()
	var/assembly_time = 10 //ticks.

	New()
		setParts()
		return ..()

	proc/assemble(var/atom/owner)
		return

	proc/setParts() //This is responsible for setting the required materials.
		return

	proc/reset()	//Resets the blueprint after assembly.
		part_list.Cut()
		setParts()
		return
///////RECIPE DATUMS

///////RECIPE OBJECTS
/obj/item/man_blueprint
	icon = 'icons/obj/manufacturer.dmi'
	icon_state = "blueprint"
	name = "manufacturer blueprint"
	desc = "A blueprint that will allow a manufacturer to produce new objects."
	var/bpType = null

/obj/item/man_blueprint/horsemask
	name = "horse mask blueprint"
	bpType = /datum/manufacturer_blueprint/horse

/obj/item/man_blueprint/sunglasses
	name = "sunglasses blueprint"
	bpType = /datum/manufacturer_blueprint/sunglasses

/obj/item/man_blueprint/mop
	name = "mop blueprint"
	bpType = /datum/manufacturer_blueprint/mop

/obj/item/man_blueprint/basketball
	name = "basketball blueprint"
	bpType = /datum/manufacturer_blueprint/basketball
///////RECIPE OBJECTS
*/