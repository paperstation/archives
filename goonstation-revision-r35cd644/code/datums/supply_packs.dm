
/proc/build_supply_pack_cache()
	qm_supply_cache.Cut()
	for(var/S in (typesof(/datum/supply_packs) - /datum/supply_packs) )
		qm_supply_cache += new S()

/datum/supply_order
	var/datum/supply_packs/object = null
	var/orderedby = null
	var/comment = null
	var/whos_id = null
	var/console_location = null

	proc/create(var/spawnpoint)
		var/atom/movable/A = object.create(spawnpoint)

		if(!isnull(whos_id))
			A.name = "[A.name], Ordered by [whos_id:registered], [comment ? "([comment])":"" ]"
		else
			A.name = "[A.name] [comment ? "([comment])":"" ]"

		if(comment)
			A.delivery_destination = comment

		return A

//SUPPLY PACKS
//NOTE: only secure crate types use the access var (and are lockable)
//NOTE: hidden packs only show up when the computer has been hacked.

/datum/supply_packs
	var/name = null
	var/desc = null
	var/list/contains = list()
	var/amount = null
	var/cost = null
	var/containertype = null
	var/containername = null
	var/access = null
	var/hidden = 0	//So as it turns out this is used in construction mode hardyhar
	var/syndicate = 0 //If this is one the crate will only show up when the console is emagged
	var/id = 0 //What jobs can order it
	var/whos_id = null //linked ID

	proc/create(var/spawnpoint)
		if (!spawnpoint)
			return null
		var/atom/movable/A
		if (!ispath(containertype) && contains.len > 1)
			containertype = text2path(containertype)
			if (!ispath(containertype))
				containertype = /obj/storage/crate // this did not need to be a string

		if (ispath(containertype))
#ifdef HALLOWEEN
			if (halloween_mode && prob(10))
				A = new /obj/storage/crate/haunted(spawnpoint)
			else
				A = new containertype(spawnpoint)
#else
			A = new containertype(spawnpoint)
#endif
			if (A)
				spawnpoint = A // set the spawnpoint to the container we made so we don't have to duplicate the contains spawner loop
				if (containername)
					A.name = containername

				if (access && isobj(A))
					var/obj/O = A
					O.req_access = list()
					O.req_access += text2num(access)

		if (contains.len)
			for (var/B in contains)
				var/thepath = B
				if (!ispath(thepath))
					thepath = text2path(B)
					if (!ispath(thepath))
						continue

				var/amt = 1
				if (isnum(contains[B]))
					amt = abs(contains[B])

				for (amt, amt>0, amt--)
					var/atom/thething = new thepath(spawnpoint)
					if (amount && isitem(thething))
						var/obj/item/I = thething
						I.amount = amount
		if (A)
			return A
		return null

/datum/supply_packs/emptycrate
	name = "Empty Crate"
	desc = "Nothing (crate only)"
	contains = list()
	cost = 10
	containertype = /obj/storage/crate
	containername = "crate"

/datum/supply_packs/specialops
	name = "Special Ops Supplies"
	desc = "x1 Sleepy Pen, x1 Holographic Disguiser, x1 Signal Jammer, x1 Agent Card, x1 EMP Grenade Kit, x1 Tactical Grenades Kit"
	contains = list(/obj/item/card/id/syndicate,
					/obj/item/storage/box/emp_kit,
					/obj/item/storage/box/tactical_kit,
					/obj/item/pen/sleepypen,
					/obj/item/device/disguiser,
					/obj/item/radiojammer)
	cost = 80000
	containertype = /obj/storage/crate
	containername = "Special Ops Crate"
	syndicate = 1

/datum/supply_packs/paint
	name = "Paint Cans"
	desc = "A selection of random paints."
	contains = list(/obj/item/paint_can/random = 4)
	cost = 1000
	containertype = /obj/storage/crate
	containername = "Paint Crate"

/datum/supply_packs/metal200
	name = "200 Metal Sheets"
	desc = "x200 Metal Sheets"
	contains = list(/obj/item/sheet/steel)
	amount = 200
	cost = 2000
	containertype = /obj/storage/crate
	containername = "Metal Sheets Crate - 200 pack"

/datum/supply_packs/metal50
	name = "50 Metal Sheets"
	desc = "x50 Metal Sheets"
	contains = list(/obj/item/sheet/steel)
	amount = 50
	cost = 500
	containertype = /obj/storage/crate
	containername = "Metal Sheets Crate - 50 pack"

/datum/supply_packs/glass200
	name = "200 Glass Sheets"
	desc = "x200 Glass Sheets"
	contains = list(/obj/item/sheet/glass)
	amount = 200
	cost = 2000
	containertype = /obj/storage/crate
	containername = "Glass Sheets Crate - 200 pack"

/datum/supply_packs/glass50
	name = "50 Glass Sheets"
	desc = "x50 Glass Sheets"
	contains = list(/obj/item/sheet/glass)
	amount = 50
	cost = 500
	containertype = /obj/storage/crate
	containername = "Glass Sheets Crate - 50 pack"

/datum/supply_packs/dryfoods
	name = "Catering: Dry Goods Crate"
	desc = "x25 Assorted Cooking Ingredients"
	contains = list(/obj/item/reagent_containers/food/snacks/ingredient/flour = 6,
					/obj/item/reagent_containers/food/snacks/ingredient/rice = 4,
					/obj/item/reagent_containers/food/snacks/ingredient/spaghetti = 3,
					/obj/item/reagent_containers/food/snacks/ingredient/sugar = 4,
					/obj/item/reagent_containers/food/snacks/ingredient/oatmeal = 3,
					/obj/item/reagent_containers/food/snacks/ingredient/tortilla = 3,
					/obj/item/reagent_containers/food/snacks/ingredient/pancake_batter = 2)
	cost = 200
	containertype = /obj/storage/crate/freezer
	containername = "Catering: Dry Goods Crate"

/datum/supply_packs/meateggdairy
	name = "Catering: Meat, Eggs and Dairy Crate"
	desc = "x25 Assorted Cooking Ingredients"
	contains = list(/obj/item/reagent_containers/food/snacks/hotdog = 4,
					/obj/item/reagent_containers/food/snacks/ingredient/cheese = 4,
					/obj/item/reagent_containers/food/drinks/milk = 4,
					/obj/item/reagent_containers/food/snacks/ingredient/meat/synthmeat = 3,
					/obj/item/reagent_containers/food/snacks/ingredient/meat/monkeymeat = 3,
					/obj/item/reagent_containers/food/snacks/ingredient/meat/fish/salmon,
					/obj/item/reagent_containers/food/snacks/ingredient/meat/fish/white,
					/obj/item/kitchen/food_box/egg_box = 3,
					/obj/item/storage/box/bacon_kit = 2)
	cost = 600
	containertype = /obj/storage/crate/freezer
	containername = "Catering: Meat, Eggs and Dairy Crate"

/datum/supply_packs/produce
	name = "Catering: Fresh Produce Crate"
	desc = "x20 Assorted Cooking Ingredients"
	contains = list(/obj/item/reagent_containers/food/snacks/plant/apple = 2,
					/obj/item/reagent_containers/food/snacks/plant/banana = 2,
					/obj/item/reagent_containers/food/snacks/plant/carrot = 2,
					/obj/item/reagent_containers/food/snacks/plant/corn = 2,
					/obj/item/reagent_containers/food/snacks/plant/garlic,
					/obj/item/reagent_containers/food/snacks/plant/lettuce = 2,
					/obj/item/reagent_containers/food/snacks/plant/tomato = 4,
					/obj/item/reagent_containers/food/snacks/plant/potato = 2,
					/obj/item/reagent_containers/food/snacks/plant/onion,
					/obj/item/reagent_containers/food/snacks/plant/lime,
					/obj/item/reagent_containers/food/snacks/plant/lemon,
					/obj/item/reagent_containers/food/snacks/plant/orange)
	cost = 1050
	containertype = /obj/storage/crate/freezer
	containername = "Catering: Fresh Produce Crate"

/datum/supply_packs/condiment
	name = "Catering: Condiment Crate"
	desc = "x25 Assorted Cooking Ingredients"
	contains = list(/obj/item/reagent_containers/food/snacks/condiment/chocchips = 3,
					/obj/item/reagent_containers/food/snacks/condiment/cream = 2,
					/obj/item/reagent_containers/food/snacks/condiment/custard,
					/obj/item/reagent_containers/food/snacks/condiment/hotsauce = 3,
					/obj/item/reagent_containers/food/snacks/condiment/ketchup = 4,
					/obj/item/reagent_containers/food/snacks/condiment/mayo = 4,
					/obj/item/reagent_containers/food/snacks/condiment/syrup = 3,
					/obj/item/reagent_containers/food/snacks/ingredient/peanutbutter = 3,
					/obj/item/reagent_containers/food/snacks/ingredient/honey = 2)
	cost = 250
	containertype = /obj/storage/crate/freezer
	containername = "Catering: Condiment Crate"

/datum/supply_packs/electrical4
	name = "Electrical Supplies Crate - 4 pack"
	desc = "x4 Cabling Box (28 cable coils total)"
	contains = list(/obj/item/storage/box/cablesbox = 4)
	cost = 1000
	containertype = /obj/storage/crate
	containername = "Electrical Supplies Crate - 4 pack"

/datum/supply_packs/engineering
	name = "Engineering Crate"
	desc = "x2 Mechanical Toolbox, x2 Welding Mask, x2 Insulated Gloves"
	contains = list(/obj/item/storage/toolbox/mechanical = 2,
					/obj/item/clothing/head/helmet/welding = 2,
					/obj/item/clothing/gloves/yellow = 2)
	cost = 1000
	containertype = /obj/storage/crate
	containername = "Engineering Crate"

/datum/supply_packs/generator
	name = "Experimental Local Generator"
	desc = "x1 Experimental Local Generator"
	contains = list(/obj/machinery/power/lgenerator)
	cost = 2500
	containertype = /obj/storage/crate
	containername = "Experimental Local Generator Crate"

/datum/supply_packs/medicalfirstaid
	name = "Medical: First Aid Crate"
	desc = "x10 Assorted First Aid Kits"
	contains = list(/obj/item/storage/firstaid/regular = 2,
					/obj/item/storage/firstaid/brute = 2,
					/obj/item/storage/firstaid/fire = 2,
					/obj/item/storage/firstaid/toxin = 2,
					/obj/item/storage/firstaid/oxygen,
					/obj/item/storage/firstaid/brain)
	cost = 1000
	containertype = /obj/storage/crate/medical
	containername = "Medical: First Aid Crate"

/datum/supply_packs/medicalchems
	name = "Medical: Medical Reservoir Crate"
	desc = "x4 Assorted reservoir beakers, x2 Sedative bottles, x2 Hyposprays, x1 Syringe Kit"
	contains = list(/obj/item/reagent_containers/glass/beaker/large/antitox,
					/obj/item/reagent_containers/glass/beaker/large/epinephrine,
					/obj/item/reagent_containers/glass/beaker/large/brute,
					/obj/item/reagent_containers/glass/beaker/large/burn,
					/obj/item/reagent_containers/glass/bottle/morphine = 2,
					/obj/item/reagent_containers/hypospray = 2,
					/obj/item/storage/box/syringes)
	cost = 1500
	containertype = /obj/storage/crate/medical
	containername = "Medical Crate"


/datum/supply_packs/janitor
	name = "Janitorial Supplies"
	desc = "x3 Buckets, x1 Mop, x3 Wet Floor Signs, x3 Cleaning Grenades, x1 Mop Bucket"
	contains = list(/obj/item/reagent_containers/glass/bucket = 3,
					/obj/item/mop,
					/obj/item/caution = 3,
					/obj/item/chem_grenade/cleaner = 3,
					/obj/mopbucket)
	cost = 500
	containertype = /obj/storage/crate
	containername = "Janitorial Supplies"

/datum/supply_packs/hydrostarter
	name = "Hydroponics: Starter Crate"
	desc = "x2 Watering Cans, x4 Compost Bags, x2 Weedkiller bottles, x2 Plant Analyzers, x4 Plant Trays"
	contains = list(/obj/item/reagent_containers/glass/wateringcan = 2,
					/obj/item/reagent_containers/glass/compostbag = 4,
					/obj/item/reagent_containers/glass/bottle/weedkiller = 2,
					/obj/item/plantanalyzer = 2,
					/obj/machinery/plantpot = 4)
	cost = 500
	containertype = /obj/storage/crate
	containername = "Hydroponics: Starter Crate"

/datum/supply_packs/hydronutrient
	name = "Hydroponics: Nutrient Pack"
	desc = "x15 Nutrient Formulas"
	contains = list(/obj/item/reagent_containers/glass/bottle/fruitful = 3,
					/obj/item/reagent_containers/glass/bottle/mutriant = 3,
					/obj/item/reagent_containers/glass/bottle/groboost = 3,
					/obj/item/reagent_containers/glass/bottle/topcrop = 3,
					/obj/item/reagent_containers/glass/bottle/powerplant = 3)
	cost = 1000
	containertype = /obj/storage/crate
	containername = "Hydroponics: Nutrient Crate"

/datum/supply_packs/mining
	name = "Mining Equipment"
	desc = "x1 Powered Pickaxe, x1 Power Hammer, x1 Optical Meson Scanner, x1 Geological Scanner, x2 Mining Satchel, x3 Mining Explosives"
	contains = list(/obj/item/mining_tool/power_pick,
					/obj/item/mining_tool/powerhammer,
					/obj/item/clothing/glasses/meson,
					/obj/item/oreprospector,
					/obj/item/satchel/mining = 2,
					/obj/item/breaching_charge/mining = 3)
	cost = 500
	containertype = /obj/storage/secure/crate/plasma
	containername = "Mining Equipment Crate (Cardlocked \[Mining])"
	access = access_mining

/datum/supply_packs/monkey4
	name = "Lab Monkey Crate - 4 pack"
	desc = "x4 Monkey"
	contains = list(/mob/living/carbon/human/npc/monkey = 4)
	cost = 500
	containertype = /obj/storage/crate/medical
	containername = "Lab Monkey Crate"

/datum/supply_packs/bee
	name = "Honey Production Kit"
	desc = "For use with existing hydroponics bay."
	contains = list(/obj/item/bee_egg_carton = 5)
	cost = 450
	containertype = /obj/storage/secure/crate/bee
	containername = "Honey Production Kit (Cardlocked \[Hydroponics])"
	access = access_hydro

/datum/supply_packs/chemical
	name = "Chemistry Resupply Crate (Cardlocked \[Research])"
	desc = "x6 Reagent Bottles, x1 Beaker Box, x1 Mechanical Dropper, x1 Spectroscopic Goggles, x1 Reagent Scanner"
	contains = list(/obj/item/storage/box/beakerbox,
					/obj/item/reagent_containers/glass/bottle/oil,
					/obj/item/reagent_containers/glass/bottle/phenol,
					/obj/item/reagent_containers/glass/bottle/acid,
					/obj/item/reagent_containers/glass/bottle/acetone,
					/obj/item/reagent_containers/glass/bottle/diethylamine,
					/obj/item/reagent_containers/glass/bottle/ammonia,
					/obj/item/reagent_containers/dropper/mechanical,
					/obj/item/clothing/glasses/spectro,
					/obj/item/device/reagentscanner)
	cost = 500
	containertype = /obj/storage/secure/crate/plasma
	containername = "Chemistry Resupply Crate (Cardlocked \[Research])"
	access = access_tox

// Added security resupply crate (Convair880).
/datum/supply_packs/security_resupply
	name = "Weapons Crate - Security Equipment (Cardlocked \[Security])"
	desc = "x1 Port-a-Brig and remote, x1 Taser, x1 Stun Baton, x1 Security-Issue Grenade Box, x1 Handcuff Kit"
	contains = list(/obj/machinery/port_a_brig,
					/obj/item/remote/porter/port_a_brig,
					/obj/item/gun/energy/taser_gun,
					/obj/item/baton,
					/obj/item/storage/box/QM_grenadekit_security,
					/obj/item/storage/box/handcuff_kit)
	cost = 5000
	containertype = /obj/storage/secure/crate/weapon
	containername = "Weapons Crate - Security Equipment (Cardlocked \[Security])"
	access = access_security

/datum/supply_packs/weapons2
	name = "Weapons Crate - Phasers (Cardlocked \[Security])"
	desc = "x2 Phaser Gun"
	contains = list(/obj/item/gun/energy/phaser_gun = 2)
	cost = 5000
	containertype = /obj/storage/secure/crate/weapon
	containername = "Weapons Crate - Phasers (Cardlocked \[Security])"
	access = access_security

/datum/supply_packs/eweapons
	name = "Weapons Crate - Experimental (Cardlocked \[Security])"
	desc = "x1 Wave gun, x1 Experimental Grenade Box (7 grenades)"
	contains = list(/obj/item/gun/energy/wavegun,
					/obj/item/storage/box/QM_grenadekit_experimentalweapons)
	cost = 5000
	containertype = /obj/storage/secure/crate/weapon
	containername = "Weapons Crate - Experimental (Cardlocked \[Security])"
	access = access_security

/datum/supply_packs/evacuation
	name = "Emergency Equipment"
	desc = "x4 Floor Bot, x5 Air Tank, x5 Gas Mask"
	contains = list(/obj/machinery/bot/floorbot = 4,
	/obj/item/tank/air = 5,
	/obj/item/clothing/mask/gas = 5)
	cost = 1500
	containertype = /obj/storage/crate/internals
	containername = "Emergency Equipment"

/datum/supply_packs/party
	name = "Alcohol Crate"
	desc = "x8 Assorted Liquor"
	contains = list(/obj/item/storage/box/beer,
					/obj/item/reagent_containers/food/drinks/bottle/beer,
					/obj/item/reagent_containers/food/drinks/bottle/wine,
					/obj/item/reagent_containers/food/drinks/bottle/mead,
					/obj/item/reagent_containers/food/drinks/bottle/cider,
					/obj/item/reagent_containers/food/drinks/rum,
					/obj/item/reagent_containers/food/drinks/bottle/vodka,
					/obj/item/reagent_containers/food/drinks/bottle/tequila)
	cost = 300
	containertype = /obj/storage/crate
	containername = "Alcohol Crate"

/datum/supply_packs/robot
	name = "Robotics Crate"
	desc = "x1 Securitron, x1 Floorbot, x1 Cleanbot, x1 Medibot, x1 Firebot"
	contains = list(/obj/machinery/bot/secbot,
					/obj/machinery/bot/floorbot,
					/obj/machinery/bot/cleanbot,
					/obj/machinery/bot/medbot,
					/obj/machinery/bot/firebot)
	cost = 2000
	containertype = /obj/storage/crate
	containername = "Robotics Crate"

/datum/supply_packs/mulebot
	name = "Replacement Mulebot"
	desc = "x1 Mulebot"
	contains = list("/obj/machinery/bot/mulebot")
	cost = 750
	containertype = /obj/storage/crate
	containername = "Replacement Mulebot Crate"

/datum/supply_packs/dressup
	name = "Novelty Clothing Crate"
	desc = "x20 Assorted Novelty Clothing"
	contains = list(/obj/item/clothing/under/gimmick/princess,
					/obj/item/clothing/under/suit/red,
					/obj/item/clothing/under/gimmick/yay,
					/obj/item/clothing/under/gimmick/cloud,
					/obj/item/clothing/under/gimmick/rainbow,
					/obj/item/clothing/under/gimmick/psyche,
					/obj/item/clothing/under/gimmick/chav,
					/obj/item/clothing/head/chav,
					/obj/item/clothing/under/gimmick/chaps,
					/obj/item/clothing/under/gimmick/sealab,
					/obj/item/clothing/under/gimmick/vault13,
					/obj/item/clothing/under/gimmick/predator,
					/obj/item/clothing/suit/armor/batman,
					/obj/item/clothing/mask/batman,
					/obj/item/clothing/head/helmet/batman,
					/obj/item/clothing/under/gimmick/duke,
					/obj/item/clothing/under/gimmick/mario,
					/obj/item/clothing/head/mario,
					/obj/item/clothing/shoes/cowboy,
					/obj/item/clothing/head/genki)
	cost = 15000
	containertype = /obj/storage/crate
	containername = "Novelty Clothing Crate"

#ifdef HALLOWEEN
/datum/supply_packs/halloween
	name = "Spooky Crate"
	desc = "WHAT COULD IT BE? SPOOKY GHOSTS?? TERRIFYING SKELETONS??? DARE YOU FIND OUT?!"
	contains = list(/obj/item/storage/goodybag = 6)
	cost = 250
	containertype = /obj/storage/crate
	containername = "Spooky Crate"
#endif

#ifdef XMAS
/datum/supply_packs/xmas
	name = "Holiday Supplies"
	desc = "Winter joys from the workshop of Santa Claus himself! (Amusing Trivia: Santa Claus does not infact exist.)"
	contains = list(/obj/item/clothing/head/helmet/space/santahat = 3,
					/obj/item/wrapping_paper = 2,
					/obj/item/scissors,
					/obj/item/reagent_containers/food/drinks/eggnog = 2,
					/obj/item/a_gift/festive = 2)
	cost = 500
	containertype = /obj/storage/crate/xmas
	containername = "Holiday Supplies"
#endif

/datum/supply_packs/banking_kit
	name = "Banking Kit"
	desc = "Circuit Boards: 1x Bank Records, 1x ATM"
	contains = list(/obj/item/circuitboard/atm,
					/obj/item/circuitboard/bank_data)
	hidden = 1
	cost = 10000
	containertype = /obj/storage/crate
	containername = "Banking Kit"

/datum/supply_packs/homing_kit
	name = "Homing Kit"
	desc = "3x Tracking Beacon"
	cost = 1000
	hidden = 1
	contains = list(/obj/item/device/radio/beacon = 3)
	containertype = /obj/storage/crate
	containername = "Homing Kit"

/datum/supply_packs/fueltank
	name = "Welding Fuel tank"
	desc = "1x Welding Fuel tank"
	contains = list(/obj/reagent_dispensers/fueltank)
	cost = 4000

/datum/supply_packs/watertank
	name = "High Capacity Watertank"
	desc = "1x High Capacity Watertank"
	contains = list(/obj/reagent_dispensers/watertank/big)
	cost = 2500

/datum/supply_packs/compostbin
	name = "Compost Bin"
	desc = "1x Compost Bin"
	contains = list(/obj/reagent_dispensers/compostbin)
	cost = 1000

/datum/supply_packs/id_computer
	name = "ID Computer Circuitboard"
	desc = "1x ID Computer Circuitboard"
	hidden = 1
	contains = list(/obj/item/circuitboard/card)
	cost = 10000

/datum/supply_packs/administrative_id
	name = "Administrative ID card"
	desc = "1x Captain level ID"
	contains = list(/obj/item/card/id/captains_spare)
	cost = 2500
	hidden = 1
	containertype = null
	containername = null

/datum/supply_packs/plasmastone
	name = "Plasmastone"
	desc = "1x Plasmastone"
	contains = list(/obj/item/raw_material/plasmastone)
	cost = 7000
	hidden = 1
	containertype = null
	containername = null

/datum/supply_packs/baton
	name = "Stun Baton"
	desc = "1x Stun Baton"
	contains = list(/obj/item/baton)
	cost = 3000
	hidden = 1
	containertype = null
	containername = null

/datum/supply_packs/telecrystal
	name = "Telecrystal"
	desc = "1x Telecrystal"
	contains = list(/obj/item/raw_material/telecrystal)
	cost = 7000
	hidden = 1
	containertype = null
	containername = null

/datum/supply_packs/telecrystal_bulk
	name = "Telecrystal Resupply Pack"
	desc = "10x Telecrystal"
	contains = list(/obj/item/raw_material/telecrystal = 10)
	cost = 63000
	hidden = 1
	containertype = /obj/storage/crate
	containername = "Telecrystal Resupply Pack"

/* ================================================= */
/* -------------------- Complex -------------------- */
/* ================================================= */

/datum/supply_packs/complex
	hidden = 1
	var/list/blueprints = list()
	var/list/frames = list()

	create(var/spawnpoint)
		var/atom/movable/A = ..()
		if (!A)
			// TODO: spawn a new crate instead of just returning?
			return

		for (var/path in blueprints)
			if (!ispath(path))
				path = text2path(path)
				if (!ispath(path))
					continue

			var/amt = 1
			if (isnum(blueprints[path]))
				amt = abs(blueprints[path])

			for (amt, amt>0, amt--)
				new /obj/item/paper/manufacturer_blueprint(A, path)

		for (var/path in frames)
			if (!ispath(path))
				path = text2path(path)
				if (!ispath(path))
					continue

			var/amt = 1
			if (isnum(frames[path]))
				amt = abs(frames[path])

			// vvv this is barf vvv
			var/atom/template = new path()
			var/template_name = template ? template.name : null
			qdel(template)
			if (!template_name)
				continue

			for (amt, amt>0, amt--)
				var/obj/item/electronics/frame/F = new /obj/item/electronics/frame(A)
				F.name = "[template_name] frame"
				F.store_type = path
				F.viewstat = 2
				F.secured = 2
				F.icon_state = "dbox"

/datum/supply_packs/complex/electronics_kit
	name = "Mechanics Reconstruction Kit"
	desc = "1x Ruckingenur frame, 1x Manufacturer frame, 1x reclaimer frame, 1x device analyzer, 1x soldering iron"
	contains = list(/obj/item/electronics/scanner,
					/obj/item/electronics/soldering)
	frames = list(/obj/machinery/rkit,
					/obj/machinery/manufacturer/mechanic,
					/obj/machinery/portable_reclaimer)
	cost = 1000
	containertype = /obj/storage/crate
	containername = "Mechanics Reconstruction Kit"

/datum/supply_packs/complex/mini_magnet_kit
	name = "Small Magnet Kit"
	desc = "1x Magnetizer, 1x Low Performance Magnet Kit, 1x Magnet Chassis Frame"
	contains = list(/obj/item/magnetizer,
					/obj/item/magnet_parts/construction/small)
	frames = list(/obj/machinery/magnet_chassis,
					/obj/machinery/computer/magnet)
	cost = 10000
	containertype = /obj/storage/crate
	containername = "Small Magnet Kit"

/datum/supply_packs/complex/magnet_kit
	name = "Magnet Kit"
	desc = "1x Magnetizer, 1x High Performance Magnet Kit, 1x Magnet Chassis Frame"
	contains = list(/obj/item/magnetizer,
					/obj/item/magnet_parts/construction)
	frames = list(/obj/machinery/magnet_chassis,
					/obj/machinery/computer/magnet)
	cost = 75000
	containertype = /obj/storage/crate
	containername = "Magnet Kit"

/datum/supply_packs/complex/arc_smelter
	name = "Arc Smelter"
	desc = "2x Slag Shovel, Frames: 1x Arc Smelter, 1x Loom, 1x Workbench"
	contains = list(/obj/item/slag_shovel = 2)
	frames = list(/obj/machinery/smelter,
					/obj/machinery/loom,
					/obj/workbench)
	cost = 150000
	containertype = /obj/storage/crate
	containername = "Arc Smelter"

/datum/supply_packs/complex/manufacturer_kit
	name = "Manufacturer Kit"
	desc = "Frames: 1x General Manufacturer, 1x Mining Manufacturer, 1x Gas Extractor, 1x Reclaimer"
	frames = list(/obj/machinery/manufacturer/general,
					/obj/machinery/manufacturer/mining,
					/obj/machinery/manufacturer/gas,
					/obj/machinery/portable_reclaimer)
	cost = 8000
	containertype = /obj/storage/crate
	containername = "Manufacturer Kit"

/datum/supply_packs/complex/cargo_kit
	name = "Cargo Bay Kit"
	desc = "Contains a higher tier of cargo computer, allowed access to the full NT catalog.<br>1x Cargo Teleporter, Frames: 1x Commerce Computer, 1x Incoming supply pad, 1x Outgoing supply pad, 1x Cargo Teleporter pad, 1x Recharger"
	contains = list(/obj/item/paper/cargo_instructions,
					/obj/item/cargotele)
	frames = list(/obj/machinery/computer/special_supply/commerce,
					/obj/supply_pad/incoming,
					/obj/supply_pad/outgoing,
					/obj/submachine/cargopad,
					/obj/machinery/recharger)
	cost = 45000
	containertype = /obj/storage/crate
	containername = "Cargo Bay Kit"

/datum/supply_packs/complex/pod_kit
	name = "Pod Production Kit"
	desc = "Frames: 1x Ship Component Fabricator, 1x Reclaimer"
	frames = list(/obj/machinery/manufacturer/hangar,
					/obj/machinery/portable_reclaimer)
	cost = 60000
	containertype = /obj/storage/crate
	containername = "Pod Production Kit"

/datum/supply_packs/complex/turret_kit
	name = "Defense Turret Kit"
	desc = "Frames: 3x Turret, 1x Turret Control Console, 2x Security Camera"
	frames = list(/obj/machinery/turret/construction = 3,
					/obj/machinery/turretid/computer,
					/obj/machinery/camera = 2)
	cost = 40000
	containertype = /obj/storage/crate
	containername = "Defense Turret Kit"

/datum/supply_packs/complex/ai_kit
	name = "Artificial Intelligence Kit"
	desc = "Frames: 1x Asimov 5 AI, 2x Turret, 1x Turret Control Console, 2x Security Camera"
	frames = list(/obj/ai_frame,
					/obj/machinery/turret/construction = 2,
					/obj/machinery/turretid/computer,
					/obj/machinery/camera = 2)
	cost = 100000
	containertype = /obj/storage/crate
	containername = "AI Kit"

/datum/supply_packs/complex/basic_power_kit
	name = "Basic Power Kit"
	desc = "Frames: 1x SMES cell, 2x Furnace"
	frames = list(/obj/smes_spawner,
					/obj/machinery/power/furnace = 2)
	cost = 40000
	containertype = /obj/storage/crate
	containername = "AI Kit"

/datum/supply_packs/complex/mainframe_kit
	name = "Computer Core Kit"
	desc = "1x Memory Board, 1x Mainframe Recovery Kit, 1x TermOS B disk, Frames: 1x Computer Mainframe, 1x Databank, 1x Network Radio, 3x Data Terminal, 1x CompTech"
	contains = list(/obj/item/disk/data/memcard,
					/obj/item/storage/box/zeta_boot_kit,
					/obj/item/disk/data/floppy/read_only/terminal_os)
	frames = list(/obj/machinery/networked/mainframe,
					/obj/machinery/networked/storage,
					/obj/machinery/networked/radio,
					/obj/machinery/power/data_terminal = 3,
					/obj/machinery/vending/computer3)
	cost = 150000
	containertype = /obj/storage/crate
	containername = "Computer Core Kit"

/datum/supply_packs/complex/artlab_kit
	name = "Artifact Research Kit"
	desc = "Frames: 5x Data Terminal, 1x Pitcher, 1x Impact pad, 1x Heater pad, 1x Electric box, 1x X-Ray machine"
	frames = list(/obj/machinery/networked/test_apparatus/pitching_machine,
					/obj/machinery/networked/test_apparatus/impact_pad,
					/obj/machinery/networked/test_apparatus/electrobox,
					/obj/machinery/networked/test_apparatus/heater,
					/obj/machinery/networked/test_apparatus/xraymachine,
					/obj/machinery/power/data_terminal = 5)
	cost = 80000
	containertype = /obj/storage/crate
	containername = "Artifact Research Kit"

/datum/supply_packs/complex/toilet_kit
	name = "Bathroom Kit"
	desc = "Frames: 4x Toilet, 1x Sink, 1x Shower Head, 1x Bathtub"
	frames = list(/obj/item/storage/toilet = 4,
					/obj/machinery/shower,
					/obj/machinery/bathtub,
					/obj/submachine/chef_sink/chem_sink)
	cost = 15000
	containertype = /obj/storage/crate
	containername = "Bathroom Kit"

/datum/supply_packs/complex/kitchen_kit
	name = "Kitchen Kit"
	desc = "1x Fridge, Frames: 1x Oven, 1x Mixer, 1x Sink, 1x Deep Fryer, 1x Food Processor, 1x ValuChimp, 1x FoodTech, 1x Meat Spike, 1x Gibber"
	contains = list(/obj/storage/secure/closet/fridge)
	frames = list(/obj/submachine/chef_oven,
					/obj/submachine/mixer,
					/obj/submachine/chef_sink,
					/obj/machinery/deep_fryer,
					/obj/submachine/foodprocessor,
					/obj/machinery/vending/monkey,
					/obj/machinery/vending/kitchen,
					/obj/kitchenspike,
					/obj/machinery/gibber)
	cost = 50000
	containertype = /obj/storage/crate
	containername = "Kitchen Kit"

/datum/supply_packs/complex/bartender_kit
	name = "Bar Kit"
	desc = "2x Glassware box, Frames: 1x Alcohol Dispenser, 1x Soda Fountain, 1x Ice Cream Machine, 1x Kitchenware Recycler, 1x Microwave"
	contains = list(/obj/item/storage/box/glassbox = 2)
	frames = list(/obj/machinery/microwave,
					/obj/machinery/chem_dispenser/alcohol,
					/obj/machinery/chem_dispenser/soda,
					/obj/submachine/ice_cream_dispenser,
					/obj/machinery/glass_recycler)
	cost = 25000
	containertype = /obj/storage/crate
	containername = "Bar Kit"

/datum/supply_packs/complex/arcade
	name = "Arcade Machine"
	desc = "Frames: 1x Arcade Machine"
	frames = list(/obj/machinery/computer/arcade)
	cost = 2500
	containertype = /obj/storage/crate
	containername = "Arcade Machine"

/datum/supply_packs/complex/telescience_kit
	name = "Telescience Kit"
	desc = "Frames: 1x Science Teleporter Console, 2x Data Terminal, 1x Telepad"
	frames = list(/obj/machinery/networked/teleconsole,
					/obj/machinery/networked/telepad,
					/obj/machinery/power/data_terminal = 2)
	cost = 40000
	containertype = /obj/storage/crate
	containername = "Telescience"

/datum/supply_packs/complex/security_camera
	name = "Security Camera kit"
	desc = "Frames: 5x Security Camera"
	frames = list(/obj/machinery/camera = 5)
	cost = 1000
	containertype = /obj/storage/crate
	containername = "Security Camera"

/datum/supply_packs/complex/medical_kit
	name = "Medbay kit"
	desc = "1x Defibrillator, 2x Hypospray, 1x Medical Belt, Frames: 1x NanoMed, 1x Medical Records computer"
	contains = list(/obj/item/robodefibrilator,
					/obj/item/storage/belt/medical,
					/obj/item/reagent_containers/hypospray = 2)
	frames = list(/obj/machinery/optable,
					/obj/machinery/vending/medical)
	cost = 10000
	containertype = /obj/storage/crate
	containername = "Medbay kit"

/datum/supply_packs/complex/operating_kit
	name = "Operating Room kit"
	desc = "1x Staple Gun, 1x Defibrillator, 2x Scalpel, 2x Circular Saw, 1x Hemostat, 2x Suture, 1x Enucleation Spoon, Frames: 1x Medical Fabricator, 1x Operating Table"
	contains = list(/obj/item/staple_gun,
					/obj/item/robodefibrilator,
					/obj/item/scalpel = 2,
					/obj/item/circular_saw = 2,
					/obj/item/hemostat,
					/obj/item/suture,
					/obj/item/surgical_spoon)
	frames = list(/obj/machinery/manufacturer/medical,
					/obj/machinery/optable,
					/obj/machinery/vending/medical)
	cost = 15000
	containertype = /obj/storage/crate
	containername = "Operating Room kit"

/datum/supply_packs/complex/robotics_kit
	name = "Robotics kit"
	desc = "1x Staple Gun, 1x Scalpel, 1x Circular Saw, Frames: 1x Robotics Fabricator, 1x Operating Table, 1x Module Rewriter, 1x Recharge station"
	contains = list(/obj/item/staple_gun,
					/obj/item/scalpel,
					/obj/item/circular_saw)
	frames = list(/obj/machinery/manufacturer/robotics,
					/obj/machinery/optable,
					/obj/submachine/robomoduler,
					/obj/machinery/recharge_station)
	cost = 20000
	containertype = /obj/storage/crate
	containername = "Robotics kit"

/datum/supply_packs/complex/genetics_kit
	name = "Genetics kit"
	desc = "Circuitboards: 1x DNA Modifier, 1x Cloning Console, Frames: 1x Cloning Scanner, 1x Cloning Pod, 1x Reclaimer, 1x DNA Scanner"
	contains = list(/obj/item/circuitboard/genetics,
					/obj/item/circuitboard/cloning)
	frames = list(/obj/machinery/clone_scanner,
					/obj/machinery/clonepod,
					/obj/machinery/clonegrinder,
					/obj/machinery/genetics_scanner)
	cost = 50000
	containertype = /obj/storage/crate
	containername = "Genetics kit"
