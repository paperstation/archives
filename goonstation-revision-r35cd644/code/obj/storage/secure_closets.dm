/obj/storage/secure/closet
	name = "secure locker"
	desc = "A card-locked storage locker."
	soundproofing = 5
	can_flip_bust = 1

/obj/storage/secure/closet/personal
	name = "personal locker"
	desc = "The first card swiped gains control."
	personal = 1
	spawn_contents = list(/obj/item/device/radio/signaler,\
	/obj/item/pen,\
	/obj/item/storage/backpack,\
	/obj/item/storage/backpack/satchel,\
	/obj/item/device/radio/headset)

/* =================== */
/* ----- Command ----- */
/* =================== */

/obj/storage/secure/closet/command
	name = "command locker"
	req_access = list(access_heads)
	icon_state = "command"
	icon_closed = "command"
	icon_opened = "secure_blue-open"

/obj/storage/secure/closet/command/captain
	name = "\improper Captain's locker"
	req_access = list(access_captain)
	spawn_contents = list(/obj/item/gun/energy/egun,\
	/obj/item/storage/box/id_kit,\
	/obj/item/storage/box/clothing/captain,\
	/obj/item/clothing/shoes/brown,\
	/obj/item/clothing/suit/armor/vest,\
	/obj/item/clothing/head/helmet/swat,\
	/obj/item/clothing/glasses/sunglasses,\
	/obj/item/device/radio/headset/command/captain)

/obj/storage/secure/closet/command/hos
	name = "\improper Head of Security's locker"
	req_access = list(access_maxsec)
	spawn_contents = list(/obj/item/storage/box/id_kit,\
	/obj/item/handcuffs,\
	/obj/item/device/flash,\
	/obj/item/storage/box/clothing/hos,\
	/obj/item/clothing/shoes/brown,\
	/obj/item/clothing/suit/armor/vest,\
	/obj/item/clothing/head/helmet,\
	/obj/item/clothing/glasses/sunglasses,\
	/obj/item/baton,\
	/obj/item/gun/energy/egun,\
	/obj/item/device/radio/headset/security,\
	/obj/item/clothing/glasses/thermal,\
	/obj/item/device/radio/headset/command/hos)

/obj/storage/secure/closet/command/hop
	name = "\improper Head of Personnel's locker"
	req_access = list(access_head_of_personnel)
	spawn_contents = list(/obj/item/device/flash,\
	/obj/item/storage/box/id_kit,\
	/obj/item/storage/box/clothing/hop,\
	/obj/item/clothing/shoes/brown,\
	/obj/item/clothing/suit/armor/vest,\
	/obj/item/device/radio/headset/command/hop)

/obj/storage/secure/closet/command/research_director
	name = "\improper Research Director's locker"
	req_access = list(access_research_director)
	spawn_contents = list(/obj/item/plant/herb/cannabis/spawnable,\
	/obj/item/zippo,\
	/obj/item/storage/box/clothing/research_director,\
	/obj/item/clothing/shoes/brown,\
	/obj/item/circular_saw,\
	/obj/item/scalpel,\
	/obj/item/hand_tele,\
	/obj/item/storage/box/zeta_boot_kit,\
	/obj/item/device/radio/electropack,\
	/obj/item/device/flash,\
	/obj/item/device/radio/headset/command/rd)

	make_my_stuff()
		..()
		if (prob(10))
			new /obj/item/photo/heisenbee(src)

/obj/storage/secure/closet/command/medical_director
	name = "\improper Medical Director's locker"
	req_access = list(access_medical_director)
	spawn_contents = list(/obj/item/storage/box/clothing/medical_director,\
	/obj/item/clothing/shoes/brown,\
	/obj/item/gun/kinetic/dart_rifle,\
	/obj/item/ammo/bullets/tranq_darts,\
	/obj/item/ammo/bullets/tranq_darts/anti_mutant,\
	/obj/item/robodefibrilator,\
	/obj/item/clothing/gloves/latex,\
	/obj/item/storage/belt/medical,\
	/obj/item/circular_saw,\
	/obj/item/scalpel,\
	/obj/item/reagent_containers/hypospray,\
	/obj/item/device/flash,\
	/obj/item/device/radio/headset/command/md)

	make_my_stuff()
		..()
		if (prob(10)) // heh
			new /obj/item/reagent_containers/glass/bottle/eyedrops(src)
			new /obj/item/reagent_containers/dropper(src)

/obj/storage/secure/closet/command/chief_engineer
	name = "\improper Chief Engineer's locker"
	req_access = list(access_engineering_chief)
	spawn_contents = list(/obj/item/storage/toolbox/mechanical,\
	/obj/item/storage/box/clothing/chief_engineer,\
	/obj/item/clothing/gloves/yellow,\
	/obj/item/clothing/shoes/brown,\
	/obj/item/clothing/shoes/magnetic,\
	/obj/item/clothing/ears/earmuffs,\
	/obj/item/clothing/glasses/meson,\
	/obj/item/clothing/suit/fire,\
	/obj/item/clothing/mask/gas,\
	/obj/item/storage/belt/utility,\
	/obj/item/clothing/head/helmet/welding,\
	/obj/item/clothing/head/helmet/hardhat,\
	/obj/item/device/multitool,\
	/obj/item/device/flash,\
	/obj/item/device/radio/headset/command/ce)

/* ==================== */
/* ----- Security ----- */
/* ==================== */

/obj/storage/secure/closet/security
	name = "\improper Security locker"
	req_access = list(access_securitylockers)
	icon_state = "sec"
	icon_closed = "sec"
	icon_opened = "secure_red-open"

/obj/storage/secure/closet/security/equipment
	name = "\improper Security equipment locker"
	spawn_contents = list(/obj/item/handcuffs,\
	/obj/item/device/flash,\
	/obj/item/clothing/under/color/red,\
	/obj/item/clothing/shoes/brown,\
	/obj/item/clothing/suit/armor/vest,\
	/obj/item/clothing/head/helmet,\
	/obj/item/clothing/glasses/sunglasses,\
	/obj/item/baton,\
	/obj/item/gun/energy/taser_gun,\
	/obj/item/device/radio/headset/security)

/obj/storage/secure/closet/security/forensics
	name = "Forensics equipment locker"
	req_access = list(access_forensics_lockers)
	spawn_contents = list(/obj/item/clothing/under/rank/det,\
	/obj/item/clothing/shoes/brown,\
	/obj/item/clothing/head/det_hat,\
	/obj/item/clothing/suit/det_suit,\
	/obj/item/clothing/gloves/black,\
	/obj/item/clothing/glasses/thermal,\
	/obj/item/clothing/glasses/spectro,\
	/obj/item/storage/box/lglo_kit,\
	/obj/item/device/detective_scanner,\
	/obj/item/storage/box/detectivegun,\
	/obj/item/device/flash,\
	/obj/item/camera_film,\
	/obj/item/device/radio/headset/security)

/obj/storage/secure/closet/security/armory
	name = "\improper Special Equipment locker"
	req_access = list(access_maxsec)
	spawn_contents = list(/obj/item/device/flash,\
	/obj/item/storage/box/flashbang_kit,\
	/obj/item/clothing/glasses/sunglasses,\
	/obj/item/clothing/suit/armor/EOD,\
	/obj/item/clothing/head/helmet/EOD,\
	/obj/item/ammo/bullets/abg,\
	/obj/item/gun/kinetic/riotgun)

/obj/storage/secure/closet/brig
	name = "\improper Confiscated Items locker"
	req_access = list(access_brig)

// Old Mushroom-era feature I fixed up (Convair880).
/obj/storage/secure/closet/brig/automatic
	name = "\improper Automatic Locker"
	desc = "Card-locked closet linked to a brig timer. Will unlock automatically when timer reaches zero."
	var/obj/machinery/door_timer/our_timer = null
	var/id = null

	// Please keep synchronizied with these lists for easy map changes:
	// /obj/machinery/floorflusher (floorflusher.dm)
	// /obj/machinery/door_timer (door_timer.dm)
	// /obj/machinery/door/window/brigdoor (window.dm)
	// /obj/machinery/flasher (flasher.dm)
	solitary
		name = "\improper Automatic Locker (Cell #1)"
		id = "solitary"

	solitary2
		name = "\improper Automatic Locker (Cell #2)"
		id = "solitary2"

	solitary3
		name = "\improper Automatic Locker (Cell #3)"
		id = "solitary3"

	solitary4
		name = "\improper Automatic Locker (Cell #4)"
		id = "solitary4"

	minibrig
		name = "\improper Automatic Locker (Mini-Brig)"
		id = "minibrig"

	minibrig2
		name = "\improper Automatic Locker (Mini-Brig #2)"
		id = "minibrig2"

	minibrig3
		name = "\improper Automatic Locker (Mini-Brig #3)"
		id = "minibrig3"

	genpop
		name = "\improper Automatic Locker (Genpop)"
		id = "genpop"

	genpop_n
		name = "\improper Automatic Locker (Genpop North)"
		id = "genpop_n"

	genpop_s
		name = "\improper Automatic Locker (Genpop South)"
		id = "genpop_s"

	New()
		..()
		spawn (5)
			if (src)
				// Why range 30? COG2 places linked fixtures much further away from the timer than originally envisioned.
				for (var/obj/machinery/door_timer/DT in range(30, src))
					if (DT && DT.id == src.id)
						src.our_timer = DT
						if (src.name == "\improper Automatic Locker")
							src.name = "\improper Automatic Locker ([src.id])"
						break
				if (!src.our_timer)
					message_admins("Automatic locker: couldn't find brig timer with ID [isnull(src.id) ? "*null*" : "[src.id]"] in [get_area(src)].")
					logTheThing("debug", null, null, "<b>Convair880:</b> couldn't find brig timer with ID [isnull(src.id) ? "*null*" : "[src.id]"] for automatic locker at [log_loc(src)].")
		return

	MouseDrop(over_object, src_location, over_location)
		..()
		if (isobserver(usr) || isintangible(usr))
			return
		if (!isturf(usr.loc))
			return
		if (usr.stat || usr.stunned || usr.weakened)
			return
		if (get_dist(src, usr) > 1)
			usr.show_text("You are too far away to do this!", "red")
			return
		if (get_dist(over_object, src) > 5)
			usr.show_text("The [src.name] is too far away from the target!", "red")
			return
		if (!istype(over_object, /obj/machinery/door_timer))
			usr.show_text("Automatic lockers can only be linked to a brig timer.", "red")
			return

		if (alert("Link locker to this brig timer?",,"Yes","No") == "Yes")
			var/obj/machinery/door_timer/DT = over_object
			if (!DT.id)
				usr.show_text("This brig timer doesn't have an ID assigned to it.", "red")
				return
			src.id = DT.id
			src.our_timer = DT
			src.name = "\improper Automatic Locker ([src.id])"
			usr.visible_message("<span style=\"color:blue\"><b>[usr.name]</b> links [src.name] to a brig timer.</span>", "<span style=\"color:blue\">Brig timer linked: [src.id].</span>")
		return

/* =================== */
/* ----- Medical ----- */
/* =================== */

/obj/storage/secure/closet/medical
	name = "medical locker"
	icon_state = "medical"
	icon_closed = "medical"
	icon_opened = "secure_white-open"
	req_access = list(access_medical_lockers)

/obj/storage/secure/closet/medical/medicine
	name = "medicine storage locker"
	spawn_contents = list(/obj/item/clothing/glasses/visor,\
	/obj/item/device/radio/headset/deaf,\
	/obj/item/clothing/glasses/eyepatch,\
	/obj/item/reagent_containers/glass/bottle/antitoxin = 3,\
	/obj/item/reagent_containers/glass/bottle/epinephrine = 3,\
	/obj/item/storage/box/syringes,\
	/obj/item/storage/box/stma_kit,\
	/obj/item/storage/box/lglo_kit,\
	/obj/item/reagent_containers/dropper = 2,\
	/obj/item/reagent_containers/glass/beaker = 2)

/obj/storage/secure/closet/medical/medkit
	name = "medkit storage locker"
	spawn_contents = list()
	make_my_stuff()
		..()
		var/obj/item/storage/firstaid/regular/B1 = new(src)
		B1.pixel_y = 6
		B1.pixel_x = -6

		var/obj/item/storage/firstaid/brute/B2 = new(src)
		B2.pixel_y = 6
		B2.pixel_x = 6

		var/obj/item/storage/firstaid/fire/B3 = new(src)
		B3.pixel_y = 0
		B3.pixel_x = -6

		var/obj/item/storage/firstaid/toxin/B4 = new(src)
		B4.pixel_y = 0
		B4.pixel_x = 6

		var/obj/item/storage/firstaid/oxygen/B5 = new(src)
		B5.pixel_y = -6
		B5.pixel_x = -6

		var/obj/item/storage/firstaid/brain/B6 = new(src)
		B6.pixel_y = -6
		B6.pixel_x = 6
		return

/obj/storage/secure/closet/medical/anesthetic
	name = "anesthetic storage locker"
	spawn_contents = list(/obj/item/reagent_containers/glass/bottle/morphine = 2,\
	/obj/item/storage/box/syringes,\
	/obj/item/tank/anesthetic = 5,\
	/obj/item/clothing/mask/medical = 4)

/obj/storage/secure/closet/medical/uniforms
	name = "medical uniform locker"
	spawn_contents = list(/obj/item/storage/backpack/satchel/medic,\
	/obj/item/storage/backpack/medic,\
	/obj/item/clothing/under/rank/medical,\
	/obj/item/clothing/shoes/red,\
	/obj/item/clothing/suit/labcoat,\
	/obj/item/storage/belt/medical,\
	/obj/item/storage/box/stma_kit,\
	/obj/item/storage/box/lglo_kit,\
	/obj/item/clothing/glasses/healthgoggles,\
	/obj/item/device/radio/headset/medical)

/obj/storage/secure/closet/medical/chemical
	name = "restricted medical locker"
	spawn_contents = list()
	req_access = list(access_medical_director)
	make_my_stuff()
		..()
		// let's organize the SHIT outta this closet too! hot damn
		var/obj/item/reagent_containers/glass/bottle/pfd/B1 = new(src)
		B1.pixel_y = 6
		B1.pixel_x = -4

		var/obj/item/reagent_containers/glass/bottle/pentetic/B2 = new(src)
		B2.pixel_y = 6
		B2.pixel_x = 4

		var/obj/item/reagent_containers/glass/bottle/omnizine/B3 = new(src)
		B3.pixel_y = 0
		B3.pixel_x = -4

		var/obj/item/reagent_containers/glass/bottle/pfd/B4 = new(src)
		B4.pixel_y = 0
		B4.pixel_x = 4

		var/obj/item/reagent_containers/glass/bottle/ether/B5 = new(src)
		B5.pixel_y = -5
		B5.pixel_x = -4

		var/obj/item/reagent_containers/glass/bottle/haloperidol/B6 = new(src)
		B6.pixel_y = -5
		B6.pixel_x = 4
		return

/obj/storage/secure/closet/animal
	name = "\improper Animal Control locker"
	req_access = list(access_medical)
	spawn_contents = list(/obj/item/device/radio/signaler,\
	/obj/item/device/radio/electropack = 5,\
	/obj/item/clothing/glasses/blindfold = 2)

/* ==================== */
/* ----- Research ----- */
/* ==================== */

/obj/storage/secure/closet/research
	name = "\improper Research locker"
	icon_state = "science"
	icon_closed = "science"
	icon_opened = "secure_white-open"
	req_access = list(access_tox_storage)

/obj/storage/secure/closet/research/uniform
	name = "science uniform locker"
	spawn_contents = list(/obj/item/tank/air,\
	/obj/item/clothing/mask/gas,\
	/obj/item/clothing/suit/bio_suit,\
	/obj/item/clothing/under/rank/scientist,\
	/obj/item/clothing/shoes/white,\
	/obj/item/clothing/gloves/latex,\
	/obj/item/clothing/head/bio_hood,\
	/obj/item/clothing/suit/labcoat,\
	/obj/item/device/radio/headset/research)

/obj/storage/secure/closet/research/chemical
	name = "chemical storage locker"
	spawn_contents = list()
	make_my_stuff()
		..()
		// let's organize the SHIT outta this closet hot damn
		var/obj/item/reagent_containers/glass/bottle/oil/B1 = new(src)
		B1.pixel_y = 6
		B1.pixel_x = -4

		var/obj/item/reagent_containers/glass/bottle/phenol/B2 = new(src)
		B2.pixel_y = 6
		B2.pixel_x = 4

		var/obj/item/reagent_containers/glass/bottle/acetone/B3 = new(src)
		B3.pixel_y = 0
		B3.pixel_x = -4

		var/obj/item/reagent_containers/glass/bottle/ammonia/B4 = new(src)
		B4.pixel_y = 0
		B4.pixel_x = 4

		var/obj/item/reagent_containers/glass/bottle/diethylamine/B5 = new(src)
		B5.pixel_y = -5
		B5.pixel_x = -4

		var/obj/item/reagent_containers/glass/bottle/acid/B6 = new(src)
		B6.pixel_y = -5
		B6.pixel_x = 4
		return

/* ======================= */
/* ----- Engineering ----- */
/* ======================= */

/obj/storage/secure/closet/engineering
	name = "\improper Engineering locker"
	icon_state = "eng"
	icon_closed = "eng"
	icon_opened = "secure_yellow-open"
	req_access = list(access_engineering)

/obj/storage/secure/closet/engineering/electrical
	name = "electrical supplies locker"
	req_access = list(access_engineering_power)
	spawn_contents = list(/obj/item/clothing/gloves/yellow = 3,\
	/obj/item/storage/toolbox/electrical = 3,\
	/obj/item/device/multitool = 3)

/obj/storage/secure/closet/engineering/welding
	name = "welding supplies locker"
	spawn_contents = list(/obj/item/clothing/head/helmet/welding = 3,\
	/obj/item/weldingtool = 3)

/obj/storage/secure/closet/engineering/mechanic
	name = "\improper Mechanic's locker"
	req_access = list(access_engineering_mechanic)
	spawn_contents = list(/obj/item/storage/toolbox/electrical,\
	/obj/item/clothing/under/rank/mechanic,\
	/obj/item/clothing/shoes/black,\
	/obj/item/clothing/gloves/yellow,\
	/obj/item/clothing/head/helmet/hardhat,\
	/obj/item/electronics/scanner,\
	/obj/item/clothing/glasses/meson,\
	/obj/item/electronics/soldering,\
	/obj/item/deconstructor,\
	/obj/item/device/radio/headset/engineer)

/obj/storage/secure/closet/engineering/atmos
	name = "\improper Atmospheric Technician's locker"
	req_access = list(access_engineering_atmos)
	spawn_contents = list(/obj/item/clothing/under/misc/atmospheric_technician,\
	/obj/item/clothing/suit/fire,\
	/obj/item/clothing/shoes/orange,\
	/obj/item/clothing/head/helmet/hardhat,\
	/obj/item/clothing/glasses/meson,\
	/obj/item/device/radio/headset/engineer)

/obj/storage/secure/closet/engineering/engineer
	name = "\improper Engineer's locker"
	req_access = list(access_engineering_engine)
	spawn_contents = list(/obj/item/storage/toolbox/mechanical,\
	/obj/item/clothing/under/rank/engineer,\
	/obj/item/clothing/shoes/orange,\
	/obj/item/clothing/mask/gas,\
	/obj/item/clothing/head/helmet/hardhat,\
	/obj/item/clothing/glasses/meson,\
	/obj/item/pen/infrared,\
	/obj/item/clothing/head/helmet/welding,\
	/obj/item/storage/belt/utility,\
	/obj/item/device/radio/headset/engineer)

/obj/storage/secure/closet/engineering/mining
	name = "\improper Miner's locker"
	req_access = list(access_mining)
	spawn_contents = list(/obj/item/breaching_charge/mining/light = 3,\
	/obj/item/satchel/mining = 2,\
	/obj/item/oreprospector,\
	/obj/item/ore_scoop,\
	/obj/item/mining_tool/power_pick,\
	/obj/item/clothing/glasses/meson,\
	/obj/item/storage/belt/mining,\
	/obj/item/device/radio/headset/engineer)

/* =================== */
/* ----- Fridges ----- */
/* =================== */

/obj/storage/secure/closet/fridge
	name = "refrigerator"
	icon_state = "fridge"
	icon_closed = "fridge"
	icon_opened = "fridge-open"
	icon_greenlight = "fridge-greenlight"
	icon_redlight = "fridge-redlight"
	icon_sparks = "fridge-sparks"

/obj/storage/secure/closet/fridge/kitchen
	spawn_contents = list(/obj/item/reagent_containers/food/drinks/cola,\
	/obj/item/reagent_containers/food/drinks/cola,\
	/obj/item/reagent_containers/food/snacks/ingredient/cheese = 6,\
	/obj/item/reagent_containers/food/drinks/milk = 5,\
	/obj/item/kitchen/food_box/egg_box = 2,\
	/obj/item/storage/box/donkpocket_kit,\
	/obj/item/storage/box/bacon_kit = 2)
	make_my_stuff()
		..()
		if (prob(25))
			for (var/i = rand(2,10), i > 0, i--)
				new /obj/item/reagent_containers/food/snacks/ingredient/meat/mysterymeat/nugget(src)

/obj/item/paper/blood_fridge_note
	name = "paper- 'angry note'"
	info = "This fridge is for BLOOD PACKS <u>ONLY</u>! If I ever catch the idiot who keeps leaving their lunch in here, you're taking a one-way trip to the goddamn solarium!<br><br><i>L. Alliman</i><br>"

/obj/storage/secure/closet/fridge/blood
	name = "blood supply refrigerator"
	req_access = list(access_medical_lockers)
	spawn_contents = list(/obj/item/storage/box/iv_box,\
	/obj/item/reagent_containers/iv_drip/saline,\
	/obj/item/reagent_containers/iv_drip/blood = 5,\
	/obj/item/paper/blood_fridge_note)
	make_my_stuff()
		..()
		if (prob(11))
			new /obj/item/plate(src)
			var/obj/item/a_sandwich = pick(typesof(/obj/item/reagent_containers/food/snacks/sandwich))
			//a_sandwich.pixel_y = 0
			//a_sandwich.pixel_x = 0
			new a_sandwich(src)

/obj/storage/secure/closet/fridge/pathology
	name = "pathology lab fridge"
	req_access = list(access_medical_lockers)
	spawn_contents = list(/obj/item/reagent_containers/glass/vial/prepared = 10,
	/obj/item/reagent_containers/syringe/antiviral = 3)

/* ================ */
/* ----- Misc ----- */
/* ================ */

/obj/storage/secure/closet/courtroom
	name = "\improper Courtroom locker"
	req_access = list(access_heads)
	spawn_contents = list(/obj/item/clothing/shoes/brown,\
	/obj/item/paper/Court = 3,\
	/obj/item/pen,\
	/obj/item/clothing/suit/judgerobe,\
	/obj/item/clothing/head/powdered_wig,\
	/obj/item/clothing/under/misc/lawyer/red,\
	/obj/item/clothing/under/misc/lawyer,\
	/obj/item/clothing/under/misc/lawyer/black,\
	/obj/item/storage/briefcase)

/obj/storage/secure/closet/kitchen
	name = "kitchen cabinet"
	req_access = list(access_kitchen)
	spawn_contents = list(/obj/item/clothing/head/chefhat = 2,\
	/obj/item/clothing/under/rank/chef = 2,\
	/obj/item/kitchen/utensil/fork,\
	/obj/item/kitchen/utensil/knife,\
	/obj/item/kitchen/utensil/spoon,\
	/obj/item/kitchen/rollingpin,\
	/obj/item/reagent_containers/food/snacks/ingredient/spaghetti = 5)

/obj/storage/secure/closet/barber
	spawn_contents = list(/obj/item/clothing/under/misc/barber = 3,\
	/obj/item/clothing/head/wig = 2,\
	/obj/item/scissors,\
	/obj/item/razor_blade)