
/obj/random_item_spawner
	name = "random item spawner"
	icon = 'icons/obj/objects.dmi'
	icon_state = "itemspawn"
	density = 0
	anchored = 1.0
	invisibility = 101
	layer = 99
	var/min_amt2spawn = 1
	var/max_amt2spawn = 1
	var/list/items2spawn = list()
	var/list/guaranteed = list() // things that will always spawn from this - set to a number to spawn that many of the thing

	New()
		spawn(1)
			src.spawn_items()
			spawn(100)
				qdel(src)

	proc/spawn_items()
		if (islist(src.guaranteed) && src.guaranteed.len)
			for (var/new_item in src.guaranteed)
				if (!ispath(new_item))
					logTheThing("debug", src, null, "has a non-path item in its guaranteed list, [new_item]")
					DEBUG("[src] has a non-path item in its guaranteed list, [new_item]")
					continue
				var/amt = 1
				if (isnum(guaranteed[new_item]))
					amt = abs(guaranteed[new_item])
				for (amt, amt>0, amt--)
					new new_item(src.loc)

		if (!islist(src.items2spawn) || !src.items2spawn.len)
			logTheThing("debug", src, null, "has an invalid items2spawn list")
			return

		var/amt2spawn = rand(min_amt2spawn, max_amt2spawn)
		for (amt2spawn, amt2spawn>0, amt2spawn--)
			var/new_item = pick(src.items2spawn)
			if (!ispath(new_item))
				logTheThing("debug", src, null, "has a non-path item in its spawn list, [new_item]")
				DEBUG("[src] has a non-path item in its spawn list, [new_item]")
				continue
			new new_item(src.loc)

/obj/random_item_spawner/tools
	name = "random tool spawner"
	min_amt2spawn = 3
	max_amt2spawn = 7
	items2spawn = list(/obj/item/crowbar,
	/obj/item/wirecutters,
	/obj/item/wrench,
	/obj/item/screwdriver,
	/obj/item/weldingtool,
	/obj/item/device/multitool,
	/obj/item/cable_coil/cut/small,
	/obj/item/cable_coil,
	/obj/item/sheet/steel/fullstack,
	/obj/item/sheet/steel/reinforced/fullstack,
	/obj/item/sheet/glass/fullstack,
	/obj/item/sheet/glass/reinforced/fullstack,
	/obj/item/rods/steel/fullstack,
	/obj/item/tile/steel/fullstack,
	/obj/item/storage/toolbox/mechanical,
	/obj/item/storage/toolbox/electrical,
	/obj/item/storage/toolbox/emergency,
	/obj/item/storage/box/cablesbox,
	/obj/item/storage/box/lightbox,
	/obj/item/storage/box/lightbox/tubes,
	/obj/item/clothing/gloves/black,
	/obj/item/clothing/head/helmet/hardhat,
	/obj/item/clothing/head/helmet/welding,
	/obj/item/cell,
	/obj/item/cell/supercell,
	/obj/item/device/flashlight,
	/obj/item/device/glowstick,
	/obj/item/device/t_scanner,
	/obj/item/device/analyzer,
	/obj/item/extinguisher,
	/obj/item/reagent_containers/glass/oilcan,
	/obj/item/storage/belt/utility)

/obj/random_item_spawner/tools_w_igloves
	name = "random tool spawner (includes insulated gloves)"
	min_amt2spawn = 3
	max_amt2spawn = 7
	items2spawn = list(/obj/item/crowbar,
	/obj/item/wirecutters,
	/obj/item/wrench,
	/obj/item/screwdriver,
	/obj/item/weldingtool,
	/obj/item/device/multitool,
	/obj/item/cable_coil/cut/small,
	/obj/item/cable_coil,
	/obj/item/sheet/steel/fullstack,
	/obj/item/sheet/steel/reinforced/fullstack,
	/obj/item/sheet/glass/fullstack,
	/obj/item/sheet/glass/reinforced/fullstack,
	/obj/item/rods/steel/fullstack,
	/obj/item/tile/steel/fullstack,
	/obj/item/storage/toolbox/mechanical,
	/obj/item/storage/toolbox/electrical,
	/obj/item/storage/toolbox/emergency,
	/obj/item/storage/box/cablesbox,
	/obj/item/storage/box/lightbox,
	/obj/item/storage/box/lightbox/tubes,
	/obj/item/clothing/gloves/black,
	/obj/item/clothing/gloves/yellow,
	/obj/item/clothing/head/helmet/hardhat,
	/obj/item/clothing/head/helmet/welding,
	/obj/item/cell,
	/obj/item/cell/supercell,
	/obj/item/device/flashlight,
	/obj/item/device/glowstick,
	/obj/item/device/t_scanner,
	/obj/item/device/analyzer,
	/obj/item/extinguisher,
	/obj/item/reagent_containers/glass/oilcan,
	/obj/item/storage/belt/utility)

/obj/random_item_spawner/med_tool
	name = "random medical tool spawner"
	min_amt2spawn = 3
	max_amt2spawn = 7
	items2spawn = list(/obj/item/scalpel,
	/obj/item/circular_saw,
	/obj/item/staple_gun,
	/obj/item/robodefibrilator,
	/obj/item/hemostat,
	/obj/item/suture,
	/obj/item/bandage,
	/obj/item/body_bag,
	/obj/item/device/healthanalyzer,
	/obj/item/device/healthanalyzer_upgrade,
	/obj/item/reagent_containers/dropper,
	/obj/item/storage/box/syringes,
	/obj/item/storage/box/patchbox,
	/obj/item/storage/box/iv_box,
	/obj/item/reagent_containers/hypospray,
	/obj/item/clothing/glasses/healthgoggles,
	/obj/item/storage/box/lglo_kit,
	/obj/item/storage/box/stma_kit,
	/obj/item/clothing/mask/surgical_shield,
	/obj/item/storage/belt/medical)

/obj/random_item_spawner/medicine
	name = "random medicine spawner"
	min_amt2spawn = 3
	max_amt2spawn = 7
	items2spawn = list(/obj/item/storage/pill_bottle/antirad,
	/obj/item/storage/pill_bottle/mutadone,
	/obj/item/storage/pill_bottle/epinephrine,
	/obj/item/storage/pill_bottle/antitox,
	/obj/item/storage/pill_bottle/salbutamol,
	/obj/item/reagent_containers/syringe/epinephrine,
	/obj/item/reagent_containers/syringe/insulin,
	/obj/item/reagent_containers/syringe/haloperidol,
	/obj/item/reagent_containers/syringe/antitoxin,
	/obj/item/reagent_containers/syringe/antiviral,
	/obj/item/reagent_containers/syringe/atropine,
	/obj/item/reagent_containers/syringe/morphine,
	/obj/item/reagent_containers/syringe/calomel,
	/obj/item/reagent_containers/iv_drip/blood,
	/obj/item/reagent_containers/iv_drip/saline,
	/obj/item/reagent_containers/glass/bottle/epinephrine,
	/obj/item/reagent_containers/glass/bottle/atropine,
	/obj/item/reagent_containers/glass/bottle/saline,
	/obj/item/reagent_containers/glass/bottle/aspirin,
	/obj/item/reagent_containers/glass/bottle/morphine,
	/obj/item/reagent_containers/glass/bottle/antitoxin,
	/obj/item/reagent_containers/glass/bottle/antihistamine,
	/obj/item/reagent_containers/glass/bottle/eyedrops,
	/obj/item/reagent_containers/glass/bottle/antirad,
	/obj/item/reagent_containers/glass/beaker/cryoxadone,
	/obj/item/reagent_containers/glass/beaker/large/epinephrine,
	/obj/item/reagent_containers/glass/beaker/large/antitox,
	/obj/item/reagent_containers/glass/beaker/large/brute,
	/obj/item/reagent_containers/glass/beaker/large/burn,
	/obj/item/reagent_containers/emergency_injector/epinephrine,
	/obj/item/reagent_containers/emergency_injector/atropine,
	/obj/item/reagent_containers/emergency_injector/charcoal,
	/obj/item/reagent_containers/emergency_injector/saline,
	/obj/item/reagent_containers/emergency_injector/anti_rad,
	/obj/item/reagent_containers/emergency_injector/insulin,
	/obj/item/reagent_containers/emergency_injector/calomel,
	/obj/item/reagent_containers/emergency_injector/salicylic_acid,
	/obj/item/reagent_containers/emergency_injector/spaceacillin,
	/obj/item/reagent_containers/emergency_injector/antihistamine,
	/obj/item/reagent_containers/emergency_injector/salbutamol,
	/obj/item/reagent_containers/emergency_injector/mannitol,
	/obj/item/reagent_containers/emergency_injector/mutadone,
	/obj/item/item_box/medical_patches/styptic,
	/obj/item/item_box/medical_patches/mini_styptic,
	/obj/item/item_box/medical_patches/silver_sulf,
	/obj/item/item_box/medical_patches/mini_silver_sulf,
	/obj/item/item_box/medical_patches/synthflesh,
	/obj/item/item_box/medical_patches/mini_synthflesh)

/obj/random_item_spawner/med_kit
	name = "random medical kit spawner"
	min_amt2spawn = 2
	max_amt2spawn = 4
	items2spawn = list(/obj/item/storage/firstaid/regular,
	/obj/item/storage/firstaid/brute,
	/obj/item/storage/firstaid/fire,
	/obj/item/storage/firstaid/toxin,
	/obj/item/storage/firstaid/oxygen,
	/obj/item/storage/firstaid/brain)

/obj/random_item_spawner/desk_stuff
	name = "random desk item spawner"
	min_amt2spawn = 2
	max_amt2spawn = 5
	items2spawn = list(/obj/item/pen,
	/obj/item/pen/fancy,
	/obj/item/pen/marker,
	/obj/item/pen/marker/red,
	/obj/item/pen/marker/blue,
	/obj/item/storage/box/crayon,
	/obj/item/storage/box/marker,
	/obj/item/hand_labeler,
	/obj/item/clipboard,
	/obj/item/stamp/random,
	/obj/item/paper,
	/obj/item/paper_bin,
	/obj/decal/cleanable/generic,
	/obj/item/reagent_containers/food/drinks/mug/random_color,
	/obj/item/postit_stack)

/obj/random_item_spawner/desk_stuff/g_clip_bin_pen
	name = "random desk item spawner (guaranteed basic)"
	guaranteed = list(/obj/item/clipboard,
	/obj/item/paper_bin,
	/obj/item/pen)
	items2spawn = list(/obj/item/pen/fancy,
	/obj/item/pen/marker,
	/obj/item/pen/marker/red,
	/obj/item/pen/marker/blue,
	/obj/item/storage/box/crayon,
	/obj/item/storage/box/marker,
	/obj/item/hand_labeler,
	/obj/item/stamp/random,
	/obj/item/paper,
	/obj/decal/cleanable/generic,
	/obj/item/reagent_containers/food/drinks/mug/random_color,
	/obj/item/postit_stack)

/obj/random_item_spawner/desk_stuff/g_clip_bin_fpen
	name = "random desk item spawner (guaranteed fancy)"
	guaranteed = list(/obj/item/clipboard,
	/obj/item/paper_bin,
	/obj/item/stamp/random,
	/obj/item/pen/fancy)
	items2spawn = list(/obj/item/pen,
	/obj/item/pen/marker,
	/obj/item/pen/marker/red,
	/obj/item/pen/marker/blue,
	/obj/item/storage/box/crayon,
	/obj/item/storage/box/marker,
	/obj/item/hand_labeler,
	/obj/item/paper,
	/obj/decal/cleanable/generic,
	/obj/item/reagent_containers/food/drinks/mug/random_color,
	/obj/item/postit_stack)

/obj/random_item_spawner/tableware
	name = "random tableware spawner"
	min_amt2spawn = 2
	max_amt2spawn = 7
	items2spawn = list(/obj/item/kitchen/utensil/fork,
	/obj/item/kitchen/utensil/knife,
	/obj/item/kitchen/utensil/spoon,
	/obj/item/plate,
	/obj/item/reagent_containers/food/drinks/bowl,
	/obj/item/reagent_containers/food/drinks/drinkingglass,
	/obj/item/reagent_containers/food/drinks/drinkingglass/shot,
	/obj/item/reagent_containers/food/drinks/drinkingglass/wine,
	/obj/item/reagent_containers/food/drinks/drinkingglass/cocktail,
	/obj/item/reagent_containers/food/drinks/drinkingglass/flute,
	/obj/item/reagent_containers/food/drinks/mug/random_color)

/obj/random_item_spawner/landmine
	name = "random land mine spawner"
	min_amt2spawn = 1
	max_amt2spawn = 1
	items2spawn = list(/obj/item/mine/radiation/armed,
	/obj/item/mine/incendiary/armed,
	/obj/item/mine/stun/armed,
	/obj/item/mine/blast/armed)

// Surplus crate picker.
/obj/random_item_spawner/landmine/surplus
	name = "random land mine spawner (surplus crate)"
	min_amt2spawn = 1
	max_amt2spawn = 1
	items2spawn = list(/obj/item/mine/radiation,
	/obj/item/mine/incendiary,
	/obj/item/mine/stun,
	/obj/item/mine/blast)

/obj/random_pod_spawner
	name = "random pod spawner"
	icon = 'icons/obj/objects.dmi'
	icon_state = "podspawn"
	density = 0
	anchored = 1.0
	invisibility = 101
	layer = 99
	var/obj/machinery/vehicle/pod2spawn = null

	New()
		spawn(1)
			src.set_up()
			spawn(10)
				qdel(src)

	proc/set_up()
		// choose pod to spawn and spawn it
		src.spawn_pod()
		// everyone gets a lock
		src.spawn_lock()

		// add the pod to the list of available random pods
		if (islist(random_pod_codes))
			random_pod_codes += pod2spawn

		// small chance for a paintjob
		if (prob(2))
			src.paint_pod()
		// weapons are common enough
		if (prob(33))
			src.spawn_weapon()
		// maybe a nicer engine
		if (prob(10))
			src.spawn_engine()
		// maybe a nicer sensor
		if (prob(8))
			src.spawn_sensor()
		// maybe let's have been treated a bit rough
		if (prob(5))
			pod2spawn.keyed = rand(1,66)

		// update our hud
		pod2spawn.myhud.update_systems()
		pod2spawn.myhud.update_states()

	proc/spawn_pod()
		var/turf/T = get_turf(src)
		if (prob(1))
			pod2spawn = new /obj/machinery/vehicle/pod_smooth/iridium(T)
		else if (prob(2))
			pod2spawn = new /obj/machinery/vehicle/pod_smooth/black(T)
		else if (prob(3))
			pod2spawn = new /obj/machinery/vehicle/pod_smooth/gold(T)
		else if (prob(5))
			pod2spawn = new /obj/machinery/vehicle/pod_smooth/heavy(T)
		else if (prob(15))
			pod2spawn = new /obj/machinery/vehicle/pod_smooth/industrial(T)
		else
			pod2spawn = new /obj/machinery/vehicle/pod_smooth/light(T)

	proc/spawn_lock()
		pod2spawn.lock = new /obj/item/shipcomponent/secondary_system/lock(pod2spawn)
		pod2spawn.lock.ship = pod2spawn
		pod2spawn.components += pod2spawn.lock
		pod2spawn.lock.code = random_hex(4)
		pod2spawn.locked = 1

	proc/paint_pod()
		var/paintjob
		if (prob(5))
			paintjob = pick(/obj/item/pod/paintjob/tronthing, /obj/item/pod/paintjob/rainbow)
		else
			paintjob = pick(/obj/item/pod/paintjob/flames, /obj/item/pod/paintjob/flames_p, /obj/item/pod/paintjob/flames_b, /obj/item/pod/paintjob/stripe_r, /obj/item/pod/paintjob/stripe_b, /obj/item/pod/paintjob/stripe_g)
		var/obj/item/pod/paintjob/P = new paintjob(pod2spawn)
		pod2spawn.paint_pod(P)

	proc/spawn_weapon()
		var/obj/item/shipcomponent/mainweapon/new_weapon
		if (prob(1))
			new_weapon = pick(/obj/item/shipcomponent/mainweapon/artillery, /obj/item/shipcomponent/mainweapon/precursor)
		else if (prob(3))
			new_weapon = pick(/obj/item/shipcomponent/mainweapon/disruptor, /obj/item/shipcomponent/mainweapon/laser_ass, /obj/item/shipcomponent/mainweapon/gun)
		else if (prob(5))
			new_weapon = pick(/obj/item/shipcomponent/mainweapon/rockdrills, /obj/item/shipcomponent/mainweapon/disruptor_light, /obj/item/shipcomponent/mainweapon/russian, /obj/item/shipcomponent/mainweapon/mining)
		else if (prob(10))
			new_weapon = pick(/obj/item/shipcomponent/mainweapon/phaser, /obj/item/shipcomponent/mainweapon/laser, /obj/item/shipcomponent/mainweapon/taser)
		else
			new_weapon = /obj/item/shipcomponent/mainweapon

		pod2spawn.m_w_system = new new_weapon(pod2spawn)
		pod2spawn.m_w_system.ship = pod2spawn
		pod2spawn.components += pod2spawn.m_w_system
		if (pod2spawn.uses_weapon_overlays)
			pod2spawn.overlays += image(pod2spawn.icon, "[pod2spawn.m_w_system.appearanceString]")

	proc/spawn_engine()
		if (prob(5))
			pod2spawn.engine.deactivate()
			pod2spawn.components -= pod2spawn.engine
			qdel(pod2spawn.engine)

			pod2spawn.engine = new /obj/item/shipcomponent/engine/hermes(pod2spawn)
			pod2spawn.engine.ship = pod2spawn
			pod2spawn.components += pod2spawn.engine
			pod2spawn.engine.activate()

		else
			pod2spawn.engine.deactivate()
			pod2spawn.components -= pod2spawn.engine
			qdel(pod2spawn.engine)

			pod2spawn.engine = new /obj/item/shipcomponent/engine/helios(pod2spawn)
			pod2spawn.engine.ship = pod2spawn
			pod2spawn.components += pod2spawn.engine
			pod2spawn.engine.activate()

	proc/spawn_sensor()
		pod2spawn.sensors.deactivate()
		pod2spawn.components -= pod2spawn.sensors
		qdel(pod2spawn.sensors)

		pod2spawn.sensors = new /obj/item/shipcomponent/sensor/mining(pod2spawn)
		pod2spawn.sensors.ship = pod2spawn
		pod2spawn.components += pod2spawn.sensors
		pod2spawn.sensors.activate()

/obj/random_pod_spawner/random_putt_spawner
	name = "random miniputt spawner"
	icon_state = "puttspawn"

	spawn_pod()
		var/turf/T = get_turf(src)
		if (prob(1))
			pod2spawn = new /obj/machinery/vehicle/miniputt/iridium(T)
		else if (prob(1))
			pod2spawn = new /obj/machinery/vehicle/miniputt/soviputt(T)
		else if (prob(2))
			pod2spawn = new /obj/machinery/vehicle/miniputt/black(T)
		else if (prob(3))
			pod2spawn = new /obj/machinery/vehicle/miniputt/gold(T)
		else if (prob(5))
			pod2spawn = new /obj/machinery/vehicle/miniputt/nanoputt(T)
		else if (prob(15))
			pod2spawn = new /obj/machinery/vehicle/miniputt/indyputt(T)
		else
			pod2spawn = new /obj/machinery/vehicle/miniputt(T)
