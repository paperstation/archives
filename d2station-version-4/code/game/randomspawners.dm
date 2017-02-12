//...MMMMM.......MMMM?....MMMMM.MMMMMMMMMMMM..MMMMMMMM..MMMM?....MMMMM.MMMMMMMM.MMMMMMMMMMMM.....MMMMM....
//.MMMMMMMMM.....MMMM?....MMMMM.MMMMNMMMMMMM....MMMM....MMMM?....MMMMM.MMMMMMMM.MMMMMMMMMMMM...MMMMMMMMM..
//MMMM?...MMMM...MMMMMM...MMMMM.....MMMM........MMMM....MMMMMM..MMMMMM.MMMM?........MMMM......MMMM?...MMMM
//MMMM?...MMMM...MMMMMMMM.MMMMM.....MMMM........MMMM....MMMM+.MM.MMMMM.MMMM?........MMMM......MMMM?...MMMM
//MMMM?...MMMM...MMMMMMMM.NMMMM.....MMMM........MMMM....MMMM?.MM.MMMMM.MMMMMMM......MMMM......MMMM?...MMMM
//MMMM?...MMMM...MMMM?.MMMMMMMM.....MMMM........MMMM....MMMM?.MM.MMMMM.MMMMMMM......MMMM......MMMM?...MMMM
//MMMMMMMMMMMM...MMMM?...MMMMMM.....MMMM........MMMM....MMMM?.MM.MMMMM.MMMM?........MMMM......MMMMMMMMMMMM
//MMMM?...MMMM...MMMM?....MMMMM.....MMMM .......MMMM....MMMM?....MMMMM.MMMM?........MMMM......MMMM?...MMMM
//MMMM?...MMMM...MMMM?....MMMMM.....MMMM........MMMM....MMMM?....MMMMM.MMMMMMMM.....MMMM......MMMM?...MMMM
//MMMM?...MMMM...MMMM?....MMMMM.....MMMM......MMMMMMMM..MMMM?....MMMMM.MMMMMMMM.... MMMM......MMMM?...MMMM
// ^ i were bored --soyuz

//Random Object Spawners / Anti-Metagaming measure.
//This is for randomly placing shit all over the map which hugely prevents metagaming and pisses off everyone who tries to.

//Written by ErikaT

/*
LANDMARKS:
a-medicalkits
a-medicaltools
a-generaltools
a-food
a-junk
a-randomchem
a-randomrnd

EXAMPLE:
/proc/antimeta_something()
	for(var/obj/landmark/C in world)
		if(C.name == "a-something")
			var/antimeta_something = pick("",
			"",
			"",)
			new antimeta_something(C.loc)

*/

//Chemicals
/proc/antimeta_randomchem()
	for(var/obj/landmark/C in landmarkz)
		if(C.name == "a-randomchem")
			var/antimeta_chems = pick("/obj/item/weapon/reagent_containers/glass/bottle/antitoxin",
			"/obj/item/weapon/reagent_containers/glass/bottle/corophizine",
			"/obj/item/weapon/reagent_containers/glass/bottle/tricordrazine",
			"/obj/item/weapon/reagent_containers/glass/bottle/stoxin",
			"/obj/item/weapon/reagent_containers/glass/bottle/kelotane",
			"/obj/item/weapon/reagent_containers/glass/bottle/spaceacillin",
			"/obj/item/weapon/reagent_containers/glass/bottle/hemoline",
			"/obj/item/weapon/reagent_containers/glass/bottle/heparin",
			"/obj/item/weapon/reagent_containers/glass/bottle/toxin",
			"/obj/item/weapon/reagent_containers/glass/bottle/chloromydride",
			"/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline",
			"/obj/item/weapon/reagent_containers/glass/bottle/dexalin")
			new antimeta_chems(C.loc)

//Junk
/proc/antimeta_junk()
	for(var/obj/landmark/C in landmarkz)
		if(C.name == "a-junk")
			var/antimeta_junk = pick("/obj/item/weapon/cigbutt",
			"/obj/decal/cleanable/blood/drip",
			"/obj/decal/cleanable/dirt",
			"/obj/decal/cleanable/generic",
			"/obj/decal/cleanable/oil")
			new antimeta_junk(C.loc)

//Food
/proc/antimeta_food()
	for(var/obj/landmark/C in landmarkz)
		if(C.name == "a-food")
			var/antimeta_food = pick("/obj/item/weapon/reagent_containers/food/snacks/applepie",
			"/obj/item/weapon/reagent_containers/food/snacks/fries",
			"/obj/item/weapon/reagent_containers/food/snacks/humeatpie",
			"/obj/item/weapon/reagent_containers/food/snacks/cheesepizza",
			"/obj/item/weapon/reagent_containers/food/snacks/meatpizza",
			"/obj/item/weapon/reagent_containers/food/snacks/muffin",
			"/obj/item/weapon/reagent_containers/food/snacks/cheesyfries",
			"/obj/item/weapon/reagent_containers/food/snacks/sandwich",
			"/obj/item/weapon/reagent_containers/food/snacks/tomatosoup",
			"/obj/item/weapon/reagent_containers/food/snacks/waffles",
			"/obj/item/weapon/reagent_containers/food/snacks/popcorn",
			"/obj/item/weapon/reagent_containers/food/snacks/pie",
			"/obj/item/weapon/reagent_containers/food/snacks/omelette",
			"/obj/item/weapon/reagent_containers/food/snacks/hotchili",
			"/obj/item/weapon/reagent_containers/food/snacks/sliceable/applecake",
			"/obj/item/weapon/reagent_containers/food/snacks/sliceable/bananabread",
			"/obj/item/weapon/reagent_containers/food/snacks/sliceable/birthdaycake",
			"/obj/item/weapon/reagent_containers/food/snacks/sliceable/bread",
			"/obj/item/weapon/reagent_containers/food/snacks/sliceable/carrotcake",
			"/obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesecake",
			"/obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesewheel",
			"/obj/item/weapon/reagent_containers/food/snacks/sliceable/creamcheesebread",
			"/obj/item/weapon/reagent_containers/food/snacks/sliceable/meatbread",
			"/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/margherita",
			"/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/mushroompizza",
			"/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza",
			"/obj/item/weapon/reagent_containers/food/snacks/sliceable/plaincake",
			"/obj/item/weapon/reagent_containers/food/snacks/sliceable/tofubread")
			new antimeta_food(C.loc)

/*/proc/antimeta_drinks()
	for(var/obj/landmark/C in world)
		if(C.name == "a-drinks")
			var/antimeta_drinks = pick("/obj/item/weapon/reagent_containers/food/drinks/",
			"/obj/item/weapon/reagent_containers/food/drinks/",
			"/obj/item/weapon/reagent_containers/food/drinks/",
			"/obj/item/weapon/reagent_containers/food/drinks/",
			"/obj/item/weapon/reagent_containers/food/drinks/",
			"/obj/item/weapon/reagent_containers/food/drinks/",
			"/obj/item/weapon/reagent_containers/food/drinks/",
			"/obj/item/weapon/reagent_containers/food/drinks/",
			"/obj/item/weapon/reagent_containers/food/drinks/",
			"/obj/item/weapon/reagent_containers/food/drinks/",
			"/obj/item/weapon/reagent_containers/food/drinks/",)
			new antimeta_drinks(C.loc)*/

//Tools general
/proc/antimeta_generaltools()
	for(var/obj/landmark/C in landmarkz)
		if(C.name == "a-generaltools")
			var/antimeta_generaltools = pick("/obj/item/weapon/bikehorn",
			"/obj/item/weapon/cable_coil",
			"/obj/item/weapon/cell",
			"/obj/item/weapon/chem_grenade",
			"/obj/item/weapon/crowbar",
			"/obj/item/weapon/extinguisher",
			"/obj/item/weapon/mousetrap",
			"/obj/item/weapon/clipboard",
			"/obj/item/weapon/pepperspray",
			"/obj/item/weapon/paper",
			"/obj/item/weapon/pen",
			"/obj/item/weapon/screwdriver",
			"/obj/item/weapon/scissors",
			"/obj/item/weapon/table_parts",
			"/obj/item/weapon/weldingtool",
			"/obj/item/weapon/wirecutters",
			"/obj/item/weapon/wrench",
			"/obj/item/weapon/zippo",
			"/obj/item/weapon/storage/toolbox/electrical",
			"/obj/item/weapon/storage/toolbox/emergency",
			"/obj/item/weapon/storage/toolbox/mechanical"
			"/obj/item/device/analyzer",
			"/obj/item/device/flashlight",
			"/obj/item/device/igniter",
			"/obj/item/device/multitool",
			"/obj/item/device/prox_sensor",
			"/obj/item/device/radio",
			"/obj/item/device/radio/signaler",
			"/obj/item/device/timer",
			"/obj/item/device/taperecorder",
			"/obj/item/device/t_scanner")
			new antimeta_generaltools(C.loc)

//Medical tools
/proc/antimeta_medicaltools()
	for(var/obj/landmark/C in landmarkz)
		if(C.name == "a-medicaltools")
			var/antimeta_medicaltools = pick("/obj/item/weapon/storage/firstaid/regular",
			"/obj/item/weapon/storage/firstaid/fire",
			"/obj/item/weapon/storage/firstaid/o2",
			"/obj/item/weapon/storage/syringes",
			"/obj/item/weapon/storage/testtubebox",
			"/obj/item/weapon/storage/pillbottlebox",
			"/obj/item/weapon/storage/utilitybelt/medical",
			"/obj/item/weapon/storage/beakerbox",
			"/obj/item/device/healthanalyzer",
			"/obj/item/weapon/scalpel",
			"/obj/item/weapon/retractor",
			"/obj/item/weapon/hemostat",
			"/obj/item/weapon/cautery",
			"/obj/item/weapon/surgicaldrill",
			"/obj/item/weapon/circular_saw",
			"/obj/item/weapon/surgicaltube")
			new antimeta_medicaltools(C.loc)

//Medical kits
/proc/antimeta_medicalkits()
	for(var/obj/landmark/C in landmarkz)
		if(C.name == "a-medicalkits")
			var/antimeta_medicalkits = pick("/obj/item/weapon/storage/firstaid/regular",
			"/obj/item/weapon/storage/firstaid/fire",
			"/obj/item/weapon/storage/firstaid/o2",
			"/obj/item/weapon/storage/firstaid/toxin")
			new antimeta_medicalkits(C.loc)



//Z-day spawn-list shit
// -Nernums


//Food Zday
/proc/antimeta_zdayfood()
	for(var/obj/landmark/C in landmarkz)
		if(C.name == "a-zdayfood")
			var/antimeta_zdayfood = pick("/obj/item/weapon/reagent_containers/food/snacks/applepie",
			"/obj/item/weapon/reagent_containers/food/snacks/fries",
			"/obj/item/weapon/reagent_containers/food/snacks/humeatpie",
			"/obj/item/weapon/reagent_containers/food/snacks/cheesepizza",
			"/obj/item/weapon/reagent_containers/food/snacks/meatpizza",
			"/obj/item/weapon/reagent_containers/food/snacks/muffin",
			"/obj/item/weapon/reagent_containers/food/snacks/cheesyfries",
			"/obj/item/weapon/reagent_containers/food/snacks/sandwich",
			"/obj/item/weapon/reagent_containers/food/snacks/tomatosoup",
			"/obj/item/weapon/reagent_containers/food/snacks/waffles",
			"/obj/item/weapon/reagent_containers/food/snacks/popcorn",
			"/obj/item/weapon/reagent_containers/food/snacks/pie",
			"/obj/item/weapon/reagent_containers/food/snacks/omelette",
			"/obj/item/weapon/reagent_containers/food/snacks/hotchili",
			"/obj/item/weapon/reagent_containers/food/snacks/sliceable/applecake",
			"/obj/item/weapon/reagent_containers/food/snacks/sliceable/bananabread",
			"/obj/item/weapon/reagent_containers/food/snacks/sliceable/birthdaycake",
			"/obj/item/weapon/reagent_containers/food/snacks/sliceable/bread",
			"/obj/item/weapon/reagent_containers/food/snacks/sliceable/carrotcake",
			"/obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesecake",
			"/obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesewheel",
			"/obj/item/weapon/reagent_containers/food/snacks/sliceable/creamcheesebread",
			"/obj/item/weapon/reagent_containers/food/snacks/sliceable/meatbread",
			"/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/margherita",
			"/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/mushroompizza",
			"/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza",
			"/obj/item/weapon/reagent_containers/food/snacks/sliceable/plaincake",
			"/obj/item/weapon/reagent_containers/food/snacks/sliceable/tofubread")
			new antimeta_zdayfood(C.loc)

//Medical tools Zday
/proc/antimeta_zdaymedicaltools()
	for(var/obj/landmark/C in landmarkz)
		if(C.name == "a-zdaymedicaltools")
			var/antimeta_zdaymedicaltools = pick("/obj/item/weapon/storage/firstaid/regular",
			"/obj/item/weapon/storage/firstaid/fire",
			"/obj/item/weapon/storage/firstaid/toxin",
			"/obj/item/weapon/storage/syringes",
			"/obj/item/weapon/storage/testtubebox",
			"/obj/item/weapon/storage/pillbottlebox",
			"/obj/item/weapon/storage/utilitybelt/medical",
			"/obj/item/weapon/storage/beakerbox",
			"/obj/item/device/healthanalyzer",
			"/obj/item/weapon/scalpel",
			"/obj/item/weapon/retractor",
			"/obj/item/weapon/hemostat",
			"/obj/item/weapon/cautery",
			"/obj/item/weapon/surgicaldrill",
			"/obj/item/weapon/circular_saw",
			"/obj/item/weapon/surgicaltube")
			new antimeta_zdaymedicaltools(C.loc)

//guns and ammo Zday
/proc/antimeta_zdayammoguns()
	for(var/obj/landmark/C in landmarkz)
		if(C.name == "a-zdayammoguns")
			var/antimeta_zdayammoguns = pick("/obj/item/ammo_magazine/c9mm",
			"/obj/item/ammo_magazine/c45",
			"/obj/item/ammo_magazine/shotgun",
			"/obj/item/ammo_casing/shotgun",
		//	"/obj/item/ammo_magazine/shotgun/buckshot",
		//	"/obj/item/ammo_casing/shotgun/buckshot",
			"/obj/item/ammo_casing/c45",  //m1911 pistol. miniuzi, silenced pistol
			"/obj/item/ammo_casing/c9mm", //Beretta M9, famas
			"/obj/item/ammo_casing/c38",
			"/obj/item/ammo_magazine/c38",
			"/obj/item/ammo_magazine", //.357 S&W Magnum, Marlin Model 1894, Colt Pythons
			"/obj/item/ammo_casing", // this is 357
		//	"/obj/item/ammo_magazine/762", //AK47/SKS/mosin-nagant
		//	"/obj/item/ammo_casing/762",
		//	"/obj/item/ammo_magazine/556", //M16/M4/AK74
		//	"/obj/item/ammo_casing/556",
		//	"/obj/item/ammo_magazine/500", // Desert eagle, Smith & Wesson Model 500
		//	"/obj/item/ammo_casing/500",
		//	"/obj/item/ammo_magazine/22", //small round http://en.wikipedia.org/wiki/.22_Long_Rifle
		//	"/obj/item/ammo_casing/22",
		//	"/obj/item/ammo_magazine/44", // .44 magnum revolver and Winchester Model 1873, Charter Arms Bulldog
		//	"/obj/item/ammo_casing/44",
			"/obj/item/ammo_magazine/c45",
			"/obj/item/ammo_magazine/shotgun",
			"/obj/item/ammo_casing/shotgun",
		//	"/obj/item/ammo_magazine/shotgun/buckshot",
		//	"/obj/item/ammo_casing/shotgun/buckshot",
			"/obj/item/ammo_casing/c45",  //m1911 pistol. miniuzi, silenced pistol
			"/obj/item/ammo_casing/c9mm", //Beretta M9, famas
			"/obj/item/ammo_casing/c38",
			"/obj/item/ammo_magazine/c38",
			"/obj/item/ammo_magazine", //.357 S&W Magnum, Marlin Model 1894, Colt Pythons
			"/obj/item/ammo_casing", // this is 357
		//	"/obj/item/ammo_magazine/762", //AK47/SKS/mosin-nagant
		//	"/obj/item/ammo_casing/762",
		//	"/obj/item/ammo_magazine/556", //M16/M4/AK74
		//	"/obj/item/ammo_casing/556",
		//	"/obj/item/ammo_magazine/500", // Desert eagle, Smith & Wesson Model 500
		//	"/obj/item/ammo_casing/500",
		//	"/obj/item/ammo_magazine/22", //small round http://en.wikipedia.org/wiki/.22_Long_Rifle
		//	"/obj/item/ammo_casing/22",
		//	"/obj/item/ammo_magazine/44", // .44 magnum revolver and Winchester Model 1873, Charter Arms Bulldog
		//	"/obj/item/ammo_casing/44",
			"/obj/item/weapon/storage/syringes",// syringe gun HEH
			"/obj/item/weapon/gun/projectile/automatic", //9mm
			"/obj/item/weapon/gun/projectile/automatic/mini_uzi", //45
			"/obj/item/weapon/gun/projectile", //ss13 357 revolver
			"/obj/item/weapon/gun/projectile/silenced", //9mm
			"/obj/item/toy/ammo/gun",
			"/obj/item/toy/gun",
			"/obj/item/weapon/gun/syringe",
			"/obj/item/weapon/gun/projectile/shotgun",
			"/obj/item/weapon/gun/projectile/shotgun/combat")
			new antimeta_zdayammoguns(C.loc)

//r&d storage shits --soyuz

/proc/antimeta_rnd()
	for(var/obj/landmark/C in landmarkz)
		if(C.name == "a-rnd")
			var/antimeta_rnd = pick("/obj/item/weapon/ore/Elerium",	//MATERIALS OUTTA THE ASS
			"/obj/item/weapon/ore/cerenkite",
			"/obj/item/stack/sheet/glass/m50",
			"/obj/item/weapon/ore/uranium",
			"/obj/item/weapon/ore/erebite",
			"/obj/item/weapon/storage/firstaid/regular",
			"/obj/item/weapon/storage/firstaid/fire", //we ARE dealing with toxins here after all
			"/obj/item/stack/sheet/diamond",
			"/obj/item/stack/sheet/gold",
			"/obj/item/stack/sheet/silver",
			"/obj/item/stack/sheet/plasma",
			"/obj/item/weapon/ore/slag",
			"/obj/item/weapon/ore/mauxite",
			"/obj/item/weapon/ore/char",
			"/obj/item/weapon/ore/pharosium",
			"/obj/item/weapon/ore/molitz",
			"/obj/item/weapon/ore/cobryl",
			"/obj/item/weapon/ore/claretine",
			"/obj/item/weapon/ore/syreline",
			"/obj/item/stack/sheet/metal/m50",
			"/obj/item/weapon/ore/bohrum",)
			new antimeta_rnd(C.loc)
