/***************************************************************
**						Design Datums						  **
**	All the data for building stuff and tracking reliability. **
***************************************************************/
/*
For the materials datum, it assumes you need reagents unless specified otherwise. To designate a material that isn't a reagent,
you use one of the material IDs below. These are NOT ids in the usual sense (they aren't defined in the object or part of a datum),
they are simply references used as part of a "has materials?" type proc. They all start with a $ to denote that they aren't reagents.
The currently supporting non-reagent materials:
- $metal (/obj/item/stack/metal). One sheet = 3750 units.
- $glass (/obj/item/stack/glass). One sheet = 3750 units.
- $plasma (/obj/item/stack/plasma). One sheet = 3750 units.
- $silver (/obj/item/stack/silver). One sheet = 3750 units.
- $gold (/obj/item/stack/gold). One sheet = 3750 units.
- $uranium (/obj/item/stack/uranium). One sheet = 3750 units.
- $diamond (/obj/item/stack/diamond). One sheet = 3750 units.
- $clown (/obj/item/stack/clown). One sheet = 3750 units. ("Bananium")
(Insert new ones here)

Don't add new keyword/IDs if they are made from an existing one (such as rods which are made from metal). Only add raw materials.

Design Guidlines
- The reliability formula for all R&D built items is reliability_base (a fixed number) + total tech levels required to make it +
reliability_mod (starts at 0, gets improved through experimentation). Example: PACMAN generator. 79 base reliablity + 6 tech
(3 plasmatech, 3 powerstorage) + 0 (since it's completely new) = 85% reliability. Reliability is the chance it works CORRECTLY.
- When adding new designs, check rdreadme.dm to see what kind of things have already been made and where new stuff is needed.
- A single sheet of anything is 3750 units of material. Materials besides metal/glass require help from other jobs (mining for
other types of metals and chemistry for reagents).
- Add the AUTOLATHE tag to


*/
#define	IMPRINTER	1	//For circuits. Uses glass/chemicals.
#define PROTOLATHE	2	//New stuff. Uses glass/metal/chemicals
#define	AUTOLATHE	4	//Uses glass/metal only.
#define CRAFTLATHE	8	//Uses fuck if I know. For use eventually.
#define MECHFAB		16 //Remember, objects utilising this flag should have construction_time and construction_cost vars.
//Note: More then one of these can be added to a design but imprinter and lathe designs are incompatable.

datum
	design						//Datum for object designs, used in construction
		var
			name = "Name"					//Name of the created object.
			desc = "Desc"					//Description of the created object.
			id = "id"						//ID of the created object for easy refernece. Alphanumeric, lower-case, no symbols
			list/req_tech = list()			//IDs of that techs the object originated from and the minimum level requirements.
			reliability_mod = 0				//Reliability modifier of the device at it's starting point.
			reliability_base = 100			//Base reliability of a device before modifiers.
			reliability = 100				//Reliability of the device.
			build_type = null				//Flag as to what kind machine the design is built in. See defines.
			list/materials = list()			//List of materials. Format: "id" = amount.
			build_path = ""					//The file path of the object that gets created

		proc
			//A proc to calculate the reliability of a design based on tech levels and innate modifiers.
			//Input: A list of /datum/tech; Output: The new reliabilty.
			CalcReliability(var/list/temp_techs)
				var/new_reliability = reliability_mod + reliability_base
				for(var/datum/tech/T in temp_techs)
					if(T.id in req_tech)
						new_reliability += T.level
				new_reliability = between(reliability_base, new_reliability, 100)
				reliability = new_reliability
				return


///////////////////Computer Boards///////////////////////////////////

		seccamera
			name = "Circuit Design (Security)"
			desc = "Allows for the construction of circuit boards used to build security camera computers."
			id = "seccamera"
			req_tech = list("programming" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/security"

		aicore
			name = "Circuit Design (AI Core)"
			desc = "Allows for the construction of circuit boards used to build new AI cores."
			id = "aicore"
			req_tech = list("programming" = 4, "biotech" = 3)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/aicore"

		aiupload
			name = "Circuit Design (AI Upload)"
			desc = "Allows for the construction of circuit boards used to build an AI Upload Console."
			id = "aiupload"
			req_tech = list("programming" = 4)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/aiupload"

		borgupload
			name = "Circuit Design (Cyborg Upload)"
			desc = "Allows for the construction of circuit boards used to build a Cyborg Upload Console."
			id = "borgupload"
			req_tech = list("programming" = 4)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/borgupload"

		med_data
			name = "Circuit Design (Medical Records)"
			desc = "Allows for the construction of circuit boards used to build a medical records console."
			id = "med_data"
			req_tech = list("programming" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/med_data"

//		pandemic
//			name = "Circuit Design (PanD.E.M.I.C. 2200)"
//			desc = "Allows for the construction of circuit boards used to build a PanD.E.M.I.C. 2200 console."
//			id = "pandemic"
//			req_tech = list("programming" = 2, "biotech" = 2)
//			build_type = IMPRINTER
//			materials = list("$glass" = 2000, "acid" = 20)
//			build_path = "/obj/item/weapon/circuitboard/pandemic"

		scan_console
			name = "Circuit Design (DNA Machine)"
			desc = "Allows for the construction of circuit boards used to build a new DNA scanning console."
			id = "scan_console"
			req_tech = list("programming" = 2, "biotech" = 3)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/scan_consolenew"

		comconsole
			name = "Circuit Design (Communications)"
			desc = "Allows for the construction of circuit boards used to build a communications console."
			id = "comconsole"
			req_tech = list("programming" = 2, "magnets" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/communications"

		idcardconsole
			name = "Circuit Design (ID Computer)"
			desc = "Allows for the construction of circuit boards used to build an ID computer."
			id = "idcardconsole"
			req_tech = list("programming" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/card"

		teleconsole
			name = "Circuit Design (Teleporter Console)"
			desc = "Allows for the construction of circuit boards used to build a teleporter control console."
			id = "teleconsole"
			req_tech = list("programming" = 3, "bluespace" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/teleporter"

		secdata
			name = "Circuit Design (Security Records Console)"
			desc = "Allows for the construction of circuit boards used to build a security records console."
			id = "secdata"
			req_tech = list("programming" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/secure_data"

		atmosalerts
			name = "Circuit Design (Atmosphere Alerts Console)"
			desc = "Allows for the construction of circuit boards used to build an atmosphere alert console.."
			id = "atmosalerts"
			req_tech = list("programming" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/atmosphere/alerts"

		air_management
			name = "Circuit Design (Atmospheric Monitor)"
			desc = "Allows for the construction of circuit boards used to build an Atmospheric Monitor."
			id = "air_management"
			req_tech = list("programming" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/general_air_control"

		general_alert
			name = "Circuit Design (General Alert Console)"
			desc = "Allows for the construction of circuit boards used to build a General Alert console."
			id = "general_alert"
			req_tech = list("programming" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/general_alert"

		robocontrol
			name = "Circuit Design (Robotics Control Console)"
			desc = "Allows for the construction of circuit boards used to build a Robotics Control console."
			id = "robocontrol"
			req_tech = list("programming" = 4)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/robotics"

		clonecontrol
			name = "Circuit Design (Cloning Machine Console)"
			desc = "Allows for the construction of circuit boards used to build a new Cloning Machine console."
			id = "clonecontrol"
			req_tech = list("programming" = 3, "biotech" = 3)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/cloning"

		arcademachine
			name = "Circuit Design (Arcade Machine)"
			desc = "Allows for the construction of circuit boards used to build a new arcade machine."
			id = "arcademachine"
			req_tech = list("programming" = 1)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/arcade"

//		puzzlearcademachine
//			name = "Circuit Design (Arcade Machine)"
//			desc = "Allows for the construction of circuit boards used to build a new arcade machine."
//			id = "arcademachine"
//			req_tech = list("programming" = 1)
//			build_type = IMPRINTER
//			materials = list("$glass" = 2000, "acid" = 20)
//			build_path = "/obj/item/weapon/circuitboard/arcadepuzzle"

		powermonitor
			name = "Circuit Design (Power Monitor)"
			desc = "Allows for the construction of circuit boards used to build a new power monitor"
			id = "powermonitor"
			req_tech = list("programming" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/powermonitor"

//		prisonmanage
//			name = "Circuit Design (Prisoner Management Console)"
//			desc = "Allows for the construction of circuit boards used to build a prisoner management console."
//			id = "prisonmanage"
//			req_tech = list("programming" = 2)
//			build_type = IMPRINTER
//			materials = list("$glass" = 2000, "acid" = 20)
//			build_path = "/obj/item/weapon/circuitboard/prisoner"

		mechacontrol
			name = "Circuit Design (Exosuit Control Console)"
			desc = "Allows for the construction of circuit boards used to build an exosuit control console."
			id = "mechacontrol"
			req_tech = list("programming" = 3)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/mecha_control"

///////////////////////////////////
//////////AI Module Disks//////////
///////////////////////////////////
		safeguard_module
			name = "Module Design (Safeguard)"
			desc = "Allows for the construction of a Safeguard AI Module."
			id = "safeguard_module"
			req_tech = list("programming" = 3, "materials" = 4)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20, "$gold" = 100)
			build_path = "/obj/item/weapon/aiModule/safeguard"

		onehuman_module
			name = "Module Design (OneHuman)"
			desc = "Allows for the construction of a OneHuman AI Module."
			id = "onehuman_module"
			req_tech = list("programming" = 4, "materials" = 6)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20, "$diamond" = 100)
			build_path = "/obj/item/weapon/aiModule/oneHuman"

		protectstation_module
			name = "Module Design (ProtectStation)"
			desc = "Allows for the construction of a ProtectStation AI Module."
			id = "protectstation_module"
			req_tech = list("programming" = 3, "materials" = 6)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20, "$gold" = 100)
			build_path = "/obj/item/weapon/aiModule/protectStation"

		notele_module
			name = "Module Design (TeleporterOffline Module)"
			desc = "Allows for the construction of a TeleporterOffline AI Module."
			id = "notele_module"
			req_tech = list("programming" = 3)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20, "$gold" = 100)
			build_path = "/obj/item/weapon/aiModule/teleporterOffline"

		quarantine_module
			name = "Module Design (Quarantine)"
			desc = "Allows for the construction of a Quarantine AI Module."
			id = "quarantine_module"
			req_tech = list("programming" = 3, "biotech" = 2, "materials" = 4)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20, "$gold" = 100)
			build_path = "/obj/item/weapon/aiModule/quarantine"

		oxygen_module
			name = "Module Design (OxygenIsToxicToHumans)"
			desc = "Allows for the construction of a Safeguard AI Module."
			id = "oxygen_module"
			req_tech = list("programming" = 3, "biotech" = 2, "materials" = 4)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20, "$gold" = 100)
			build_path = "/obj/item/weapon/aiModule/oxygen"

		freeform_module
			name = "Module Design (Freeform)"
			desc = "Allows for the construction of a Freeform AI Module."
			id = "freeform_module"
			req_tech = list("programming" = 4, "materials" = 4)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20, "$gold" = 100)
			build_path = "/obj/item/weapon/aiModule/freeform"

		namechange_module
			name = "Module Design (Namechange)"
			desc = "Allows for the construction of a Namechange AI Module."
			id = "namechange_module"
			req_tech = list("programming" = 3, "materials" = 1)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20, "$gold" = 100)
			build_path = "/obj/item/weapon/aiModule/namechange"

		reset_module
			name = "Module Design (Reset)"
			desc = "Allows for the construction of a Reset AI Module."
			id = "reset_module"
			req_tech = list("programming" = 3, "materials" = 6)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20, "$gold" = 100)
			build_path = "/obj/item/weapon/aiModule/reset"

		purge_module
			name = "Module Design (Purge)"
			desc = "Allows for the construction of a Purge AI Module."
			id = "purge_module"
			req_tech = list("programming" = 4, "materials" = 6)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20, "$diamond" = 100)
			build_path = "/obj/item/weapon/aiModule/purge"

		freeformcore_module
			name = "Core Module Design (Freeform)"
			desc = "Allows for the construction of a Freeform AI Core Module."
			id = "freeformcore_module"
			req_tech = list("programming" = 4, "materials" = 6)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20, "$diamond" = 100)
			build_path = "/obj/item/weapon/aiModule/freeformcore"

		asimov
			name = "Core Module Design (Asimov)"
			desc = "Allows for the construction of a Asimov AI Core Module."
			id = "asimov_module"
			req_tech = list("programming" = 3, "materials" = 6)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20, "$diamond" = 100)
			build_path = "/obj/item/weapon/aiModule/asimov"

		paladin_module
			name = "Core Module Design (P.A.L.A.D.I.N.)"
			desc = "Allows for the construction of a P.A.L.A.D.I.N. AI Core Module."
			id = "paladin_module"
			req_tech = list("programming" = 4, "materials" = 6)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20, "$diamond" = 100)
			build_path = "/obj/item/weapon/aiModule/paladin"

		tyrant_module
			name = "Core Module Design (T.Y.R.A.N.T.)"
			desc = "Allows for the construction of a T.Y.R.A.N.T. AI Module."
			id = "tyrant_module"
			req_tech = list("programming" = 4, "syndicate" = 2, "materials" = 6)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20, "$diamond" = 100)
			build_path = "/obj/item/weapon/aiModule/tyrant"


///////////////////////////////////
/////Non-Board Computer Stuff//////
///////////////////////////////////

		intellicard
			name = "Intellicard AI Transportation System"
			desc = "Allows for the construction of an intellicard."
			id = "intellicard"
			req_tech = list("programming" = 4, "materials" = 4)
			build_type = PROTOLATHE
			materials = list("$glass" = 1000, "$gold" = 200)
			build_path = "/obj/item/device/aicard"

		paicard
			name = "Personal Artificial Intelligence Card"
			desc = "Allows for the construction of a pAI Card"
			id = "paicard"
			req_tech = list("programming" = 3)
			build_type = PROTOLATHE
			materials = list("$glass" = 500, "$metal" = 500)
			build_path = "/obj/item/device/paicard"

///////////////////////////////////
//////////Mecha Module Disks///////
///////////////////////////////////

		ripley_main
			name = "Circuit Design (APLU \"Ripley\" Central Control module)"
			desc = "Allows for the construction of a \"Ripley\" Central Control module."
			id = "ripley_main"
			req_tech = list("programming" = 3)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/mecha_parts/circuitboard/ripley/main"

		ripley_peri
			name = "Circuit Design (APLU \"Ripley\" Peripherals Control module)"
			desc = "Allows for the construction of a  \"Ripley\" Peripheral Control module."
			id = "ripley_peri"
			req_tech = list("programming" = 3)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/mecha_parts/circuitboard/ripley/peripherals"

		gygax_main
			name = "Circuit Design (\"Gygax\" Central Control module)"
			desc = "Allows for the construction of a \"Gygax\" Central Control module."
			id = "gygax_main"
			req_tech = list("programming" = 4)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/mecha_parts/circuitboard/gygax/main"

		gygax_peri
			name = "Circuit Design (\"Gygax\" Peripherals Control module)"
			desc = "Allows for the construction of a \"Gygax\" Peripheral Control module."
			id = "gygax_peri"
			req_tech = list("programming" = 4)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/mecha_parts/circuitboard/gygax/peripherals"

		gygax_targ
			name = "Circuit Design (\"Gygax\" Weapons & Targeting Control module)"
			desc = "Allows for the construction of a \"Gygax\" Weapons & Targeting Control module."
			id = "gygax_targ"
			req_tech = list("programming" = 4, "combat" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/mecha_parts/circuitboard/gygax/targeting"

		durand_main
			name = "Circuit Design (\"Durand\" Central Control module)"
			desc = "Allows for the construction of a \"Durand\" Central Control module."
			id = "durand_main"
			req_tech = list("programming" = 4)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/mecha_parts/circuitboard/durand/main"

		durand_peri
			name = "Circuit Design (\"Durand\" Peripherals Control module)"
			desc = "Allows for the construction of a \"Durand\" Peripheral Control module."
			id = "durand_peri"
			req_tech = list("programming" = 4)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/mecha_parts/circuitboard/durand/peripherals"

		durand_targ
			name = "Circuit Design (\"Durand\" Weapons & Targeting Control module)"
			desc = "Allows for the construction of a \"Durand\" Weapons & Targeting Control module."
			id = "durand_targ"
			req_tech = list("programming" = 4, "combat" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/mecha_parts/circuitboard/durand/targeting"


		honker_main
			name = "Circuit Design (\"H.O.N.K\" Central Control module)"
			desc = "Allows for the construction of a \"H.O.N.K\" Central Control module."
			id = "honker_main"
			req_tech = list("programming" = 3)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/mecha_parts/circuitboard/honker/main"

		honker_peri
			name = "Circuit Design (\"H.O.N.K\" Peripherals Control module)"
			desc = "Allows for the construction of a \"H.O.N.K\" Peripheral Control module."
			id = "honker_peri"
			req_tech = list("programming" = 3)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/mecha_parts/circuitboard/honker/peripherals"

		honker_targ
			name = "Circuit Design (\"H.O.N.K\" Weapons & Targeting Control module)"
			desc = "Allows for the construction of a \"H.O.N.K\" Weapons & Targeting Control module."
			id = "honker_targ"
			req_tech = list("programming" = 3)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/mecha_parts/circuitboard/honker/targeting"

////////////////////////////////////////
/////////// Mecha Equpment /////////////
////////////////////////////////////////

		mech_scattershot
			name = "Exosuit Weapon Design (LBX AC 10 \"Scattershot\")"
			desc = "Allows for the construction of LBX AC 10."
			id = "mech_scattershot"
			build_type = MECHFAB
			req_tech = list("combat" = 4)
			build_path = "/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot"

		mech_laser
			name = "Exosuit Weapon Design (CH-PS \"Immolator\" Laser)"
			desc = "Allows for the construction of CH-PS Laser."
			id = "mech_laser"
			build_type = MECHFAB
			req_tech = list("combat" = 3, "magnets" = 3)
			build_path = "/obj/item/mecha_parts/mecha_equipment/weapon/laser"

		mech_grenade_launcher
			name = "Exosuit Weapon Design (SGL-6 Grenade Launcher)"
			desc = "Allows for the construction of SGL-6 Grenade Launcher."
			id = "mech_grenade_launcher"
			build_type = MECHFAB
			req_tech = list("combat" = 3)
			build_path = "/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flashbang"

		mech_wormhole_gen
			name = "Exosuit Module Design (Localized Wormhole Generator)"
			desc = "An exosuit module that allows generating of small quasi-stable wormholes."
			id = "mech_wormhole_gen"
			build_type = MECHFAB
			req_tech = list("bluespace" = 3, "magnets" = 2)
			build_path = "/obj/item/mecha_parts/mecha_equipment/wormhole_generator"

		mech_teleporter
			name = "Exosuit Module Design (Teleporter Module)"
			desc = "An exosuit module that allows exosuits to teleport to any position in view."
			id = "mech_teleporter"
			build_type = MECHFAB
			req_tech = list("bluespace" = 10, "magnets" = 5)
			build_path = "/obj/item/mecha_parts/mecha_equipment/teleporter"

		mech_rcd
			name = "Exosuit Module Design (RCD Module)"
			desc = "An exosuit-mounted Rapid Construction Device."
			id = "mech_rcd"
			build_type = MECHFAB
			req_tech = list("materials" = 4, "bluespace" = 3, "magnets" = 4, "powerstorage"=4, "engineering" = 4)
			build_path = "/obj/item/mecha_parts/mecha_equipment/tool/rcd"

		mech_gravcatapult
			name = "Exosuit Module Design (Gravitational Catapult Module)"
			desc = "An exosuit mounted Gravitational Catapult."
			id = "mech_gravcatapult"
			build_type = MECHFAB
			req_tech = list("bluespace" = 2, "magnets" = 3, "engineering" = 3)
			build_path = "/obj/item/mecha_parts/mecha_equipment/gravcatapult"

		mech_repair_droid
			name = "Exosuit Module Design (Repair Droid Module)"
			desc = "Automated Repair Droid. BEEP BOOP"
			id = "mech_repair_droid"
			build_type = MECHFAB
			req_tech = list("magnets" = 3, "programming" = 3, "engineering" = 3)
			build_path = "/obj/item/mecha_parts/mecha_equipment/repair_droid"


////////////////////////////////////////
//////////Disk Construction Disks///////
////////////////////////////////////////
		design_disk
			name = "Design Storage Disk"
			desc = "Produce additional disks for storing device designs."
			id = "design_disk"
			req_tech = list("programming" = 1)
			build_type = PROTOLATHE | AUTOLATHE
			materials = list("$metal" = 30, "$glass" = 10)
			build_path = "/obj/item/weapon/disk/design_disk"

		tech_disk
			name = "Technology Data Storage Disk"
			desc = "Produce additional disks for storing technology data."
			id = "tech_disk"
			req_tech = list("programming" = 1)
			build_type = PROTOLATHE | AUTOLATHE
			materials = list("$metal" = 30, "$glass" = 10)
			build_path = "/obj/item/weapon/disk/tech_disk"

////////////////////////////////////////
/////////////Stock Parts////////////////
////////////////////////////////////////


		basic_capacitor
			name = "Basic Capacitor"
			desc = "A stock part used in the construction of various devices."
			id = "basic_capacitor"
			req_tech = list("powerstorage" = 1)
			build_type = PROTOLATHE | AUTOLATHE
			materials = list("$metal" = 50, "$glass" = 50)
			build_path = "/obj/item/weapon/stock_parts/capacitor"

		basic_sensor
			name = "Basic Sensor Module"
			desc = "A stock part used in the construction of various devices."
			id = "basic_sensor"
			req_tech = list("magnets" = 1)
			build_type = PROTOLATHE | AUTOLATHE
			materials = list("$metal" = 50, "$glass" = 20)
			build_path = "/obj/item/weapon/stock_parts/scanning_module"

		micro_mani
			name = "Micro Manipulator"
			desc = "A stock part used in the construction of various devices."
			id = "micro_mani"
			req_tech = list("materials" = 1, "programming" = 1)
			build_type = PROTOLATHE | AUTOLATHE
			materials = list("$metal" = 30)
			build_path = "/obj/item/weapon/stock_parts/manipulator"

		basic_micro_laser
			name = "Basic Micro-Laser"
			desc = "A stock part used in the construction of various devices."
			id = "basic_micro_laser"
			req_tech = list("magnets" = 1)
			build_type = PROTOLATHE | AUTOLATHE
			materials = list("$metal" = 10, "$glass" = 20)
			build_path = "/obj/item/weapon/stock_parts/micro_laser"

		basic_matter_bin
			name = "Basic Matter Bin"
			desc = "A stock part used in the construction of various devices."
			id = "basic_matter_bin"
			req_tech = list("materials" = 1)
			build_type = PROTOLATHE | AUTOLATHE
			materials = list("$metal" = 80)
			build_path = "/obj/item/weapon/stock_parts/matter_bin"

		adv_capacitor
			name = "Advanced Capacitor"
			desc = "A stock part used in the construction of various devices."
			id = "adv_capacitor"
			req_tech = list("powerstorage" = 3)
			build_type = PROTOLATHE
			materials = list("$metal" = 50, "$glass" = 50)
			build_path = "/obj/item/weapon/stock_parts/capacitor/adv"

		adv_sensor
			name = "Advanced Sensor Module"
			desc = "A stock part used in the construction of various devices."
			id = "adv_sensor"
			req_tech = list("magnets" = 3)
			build_type = PROTOLATHE
			materials = list("$metal" = 50, "$glass" = 20)
			build_path = "/obj/item/weapon/stock_parts/scanning_module/adv"

		nano_mani
			name = "Nano Manipulator"
			desc = "A stock part used in the construction of various devices."
			id = "nano_mani"
			req_tech = list("materials" = 3, "programming" = 2)
			build_type = PROTOLATHE
			materials = list("$metal" = 30)
			build_path = "/obj/item/weapon/stock_parts/manipulator/nano"

		high_micro_laser
			name = "High-Power Micro-Laser"
			desc = "A stock part used in the construction of various devices."
			id = "high_micro_laser"
			req_tech = list("magnets" = 3)
			build_type = PROTOLATHE
			materials = list("$metal" = 10, "$glass" = 20)
			build_path = "/obj/item/weapon/stock_parts/micro_laser/high"

		adv_matter_bin
			name = "Advanced Matter Bin"
			desc = "A stock part used in the construction of various devices."
			id = "adv_matter_bin"
			req_tech = list("materials" = 3)
			build_type = PROTOLATHE
			materials = list("$metal" = 80)
			build_path = "/obj/item/weapon/stock_parts/matter_bin/adv"

		super_capacitor
			name = "Super Capacitor"
			desc = "A stock part used in the construction of various devices."
			id = "super_capacitor"
			req_tech = list("powerstorage" = 5, "materials" = 4)
			build_type = PROTOLATHE
			reliability_base = 71
			materials = list("$metal" = 50, "$glass" = 50, "$gold" = 20)
			build_path = "/obj/item/weapon/stock_parts/capacitor/super"

		phasic_sensor
			name = "Phasic Sensor Module"
			desc = "A stock part used in the construction of various devices."
			id = "phasic_sensor"
			req_tech = list("magnets" = 5, "materials" = 3)
			build_type = PROTOLATHE
			materials = list("$metal" = 50, "$glass" = 20, "$silver" = 10)
			reliability_base = 72
			build_path = "/obj/item/weapon/stock_parts/scanning_module/phasic"

		pico_mani
			name = "Pico Manipulator"
			desc = "A stock part used in the construction of various devices."
			id = "pico_mani"
			req_tech = list("materials" = 5, "programming" = 2)
			build_type = PROTOLATHE
			materials = list("$metal" = 30)
			reliability_base = 73
			build_path = "/obj/item/weapon/stock_parts/manipulator/pico"

		ultra_micro_laser
			name = "Ultra-High-Power Micro-Laser"
			desc = "A stock part used in the construction of various devices."
			id = "ultra_micro_laser"
			req_tech = list("magnets" = 5, "materials" = 5)
			build_type = PROTOLATHE
			materials = list("$metal" = 10, "$glass" = 20, "$uranium" = 10)
			reliability_base = 70
			build_path = "/obj/item/weapon/stock_parts/micro_laser/ultra"

		super_matter_bin
			name = "Super Matter Bin"
			desc = "A stock part used in the construction of various devices."
			id = "super_matter_bin"
			req_tech = list("materials" = 5)
			build_type = PROTOLATHE
			materials = list("$metal" = 80)
			reliability_base = 75
			build_path = "/obj/item/weapon/stock_parts/matter_bin/super"
//////////

		basic_analyser
			name = "Basic Analyzer"
			desc = "A hand-held environmental scanner which reports current gas levels."
			id = "basic_analyser"
			req_tech = list("powerstorage" = 1, "magnets" = 1, "programming" = 1)
			build_type = PROTOLATHE | AUTOLATHE
			materials = list("$metal" = 150, "$glass" = 150)
			build_path = "/obj/item/device/analyzer"

		plant_analyser
			name = "Plant Analyzer"
			desc = "A hand-held scanner which aids in the growth and care of plants."
			id = "plant_analyser"
			req_tech = list("powerstorage" = 2, "magnets" = 1, "programming" = 1)
			build_type = PROTOLATHE | AUTOLATHE
			materials = list("$metal" = 150, "$glass" = 220)
			build_path = "/obj/item/device/analyzer/plant_analyzer"

		detective_scanner
			name = "Detective Scanner"
			desc = "Used to scan objects for DNA and fingerprints."
			id = "detective_scanner"
			req_tech = list("powerstorage" = 1, "materials" = 2, "programming" = 2)
			build_type = PROTOLATHE | AUTOLATHE
			materials = list("$metal" = 300, "$glass" = 220)
			build_path = "/obj/item/device/detective_scanner"

		flashlight
			name = "Flashlight"
			desc = "A hand-held emergency light."
			id = "flashlight"
			req_tech = list("powerstorage" = 1)
			build_type = PROTOLATHE | AUTOLATHE
			materials = list("$metal" = 10, "$glass" = 20)
			build_path = "/obj/item/device/flashlight"
/*
		basic_matter_bin
			name = "Basic Matter Bin"
			desc = "It's a bin that destroys objects that are put inside."
			id = "basic_matter_bin"
			req_tech = list("materials" = 1)
			build_type = PROTOLATHE | AUTOLATHE
			materials = list("$metal" = 80)
			build_path = "/obj/item/weapon/stock_parts/matter_bin"
*/
		igniter
			name = "Igniter"
			desc = "A small electronic device able to ignite combustable substances. Does not function well as a lighter."
			id = "igniter"
			req_tech = list("powerstorage" = 1)
			build_type = PROTOLATHE
			materials = list("$metal" = 50, "$glass" = 50)
			build_path = "/obj/item/device/igniter"

		multitool
			name = "Multitool"
			desc = "Used for pulsing wires to test which to cut. Not recommended by doctors."
			id = "multitool"
			req_tech = list("magnets" = 2)
			build_type = PROTOLATHE
			materials = list("$metal" = 250, "$glass" = 120)
			build_path = "/obj/item/device/multitool"

		prox_sensor
			name = "Proximity Sensor"
			desc = "Used for scanning and alerting when someone enters a certain proximity."
			id = "prox_sensor"
			req_tech = list("materials" = 2, "programming" = 2)
			build_type = PROTOLATHE
			materials = list("$metal" = 30)
			build_path = "/obj/item/device/prox_sensor"

		radio
			name = "Radio"
			desc = "Radio communication device"
			id = "radio"
			req_tech = list("magnets" = 3, "powerstorage" = 2)
			build_type = PROTOLATHE
			materials = list("$metal" = 10, "$glass" = 20)
			build_path = "/obj/item/device/radio"
/*
		adv_matter_bin
			name = "Advanced Matter Bin"
			desc = "A stock part used in the construction of various devices."
			id = "adv_matter_bin"
			req_tech = list("materials" = 3)
			build_type = PROTOLATHE
			materials = list("$metal" = 80)
			build_path = "/obj/item/weapon/stock_parts/matter_bin/adv"
*/
		signaler
			name = "Remote Signaling Device"
			desc = "Used to remotely activate devices."
			id = "signaler"
			req_tech = list("powerstorage" = 5, "materials" = 4)
			build_type = PROTOLATHE
			reliability_base = 91
			materials = list("$metal" = 150, "$glass" = 150)
			build_path = "/obj/item/device/radio/signaler"

		rdanalyzer
			name = "Technology Analyzer"
			desc = "A hand-held scanner which reports technology levels."
			id = "rdanalyzer"
			req_tech = list("magnets" = 3, "materials" = 3)
			build_type = PROTOLATHE
			materials = list("$metal" = 50, "$glass" = 20, "$silver" = 10)
			reliability_base = 82
			build_path = "/obj/item/device/rd_analyzer"


		t_scanner
			name = "T-ray scanner"
			desc = "A terahertz-ray emitter and scanner used to detect underfloor objects such as cables and pipes."
			id = "t_scanner"
			req_tech = list("materials" = 4, "programming" = 2)
			build_type = PROTOLATHE
			materials = list("$metal" = 130, "$glass" = 20)
			reliability_base = 73
			build_path = "/obj/item/device/t_scanner"

		cargotele
			name = "Cargo Transporter"
			desc = "A device for teleporting crated goods."
			id = "cargotele"
			req_tech = list("magnets" = 4, "materials" = 1)
			build_type = PROTOLATHE
			materials = list("$metal" = 150, "$glass" = 20, "$silver" = 10)
			reliability_base = 90
			build_path = "/obj/item/weapon/cargotele"

/*		super_matter_bin
			name = "Super Matter Bin"
			desc = "A stock part used in the construction of various devices."
			id = "super_matter_bin"
			req_tech = list("materials" = 5)
			build_type = PROTOLATHE
			materials = list("$metal" = 80)
			reliability_base = 75
			build_path = "/obj/item/weapon/stock_parts/matter_bin/super"
*/
		fireaxe
			name = "Fire Axe"
			desc = "Truly, the tool of a madman. Who would possibly think to fight fire with an axe?"
			id = "fireaxe"
			req_tech = list("materials" = 5)
			build_type = PROTOLATHE
			materials = list("$metal" = 280)
			build_path = "/obj/item/weapon/fireaxe"

		hand_tele
			name = "Hand Teleporter"
			desc = "A portable item using blue-space technology."
			id = "hand_tele"
			req_tech = list("powerstorage" = 6, "materials" = 5, "bluespace" = 4)
			build_type = PROTOLATHE
			materials = list("$metal" = 280)
			build_path = "/obj/item/weapon/fireaxe"

////////////////////////////////////////
//////////////////Power/////////////////
////////////////////////////////////////

		basic_cell
			name = "Basic Power Cell"
			desc = "A basic power cell that holds 1000 units of energy"
			id = "basic_cell"
			req_tech = list("powerstorage" = 1)
			build_type = PROTOLATHE | AUTOLATHE
			materials = list("$metal" = 700, "$glass" = 50)
			build_path = "/obj/item/weapon/cell"

		high_cell
			name = "High-Capacity Power Cell"
			desc = "A power cell that holds 10000 units of energy"
			id = "high_cell"
			req_tech = list("powerstorage" = 2)
			build_type = PROTOLATHE | AUTOLATHE
			materials = list("$metal" = 700, "$glass" = 60)
			build_path = "/obj/item/weapon/cell/high"

		super_cell
			name = "Super-Capacity Power Cell"
			desc = "A power cell that holds 20000 units of energy"
			id = "super_cell"
			req_tech = list("powerstorage" = 3, "materials" = 2)
			reliability_base = 75
			build_type = PROTOLATHE
			materials = list("$metal" = 700, "$glass" = 70)
			build_path = "/obj/item/weapon/cell/super"

		hyper_cell
			name = "Hyper-Capacity Power Cell"
			desc = "A power cell that holds 30000 units of energy"
			id = "hyper_cell"
			req_tech = list("powerstorage" = 6, "materials" = 4)
			reliability_base = 70
			build_type = PROTOLATHE
			materials = list("$metal" = 400, "$gold" = 150, "$silver" = 150, "$glass" = 70)
			build_path = "/obj/item/weapon/cell/hyper"

////////////////////////////////////////
//////////////MISC Boards///////////////
////////////////////////////////////////

		destructive_analyzer
			name = "Destructive Analyzer Board"
			desc = "The circuit board for a destructive analyzer."
			id = "destructive_analyzer"
			req_tech = list("programming" = 2, "magnets" = 2, "engineering" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/destructive_analyzer"

		protolathe
			name = "Protolathe Board"
			desc = "The circuit board for a protolathe."
			id = "protolathe"
			req_tech = list("programming" = 2, "engineering" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/protolathe"

		circuit_imprinter
			name = "Circuit Imprinter Board"
			desc = "The circuit board for a circuit imprinter."
			id = "circuit_imprinter"
			req_tech = list("programming" = 2, "engineering" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/circuit_imprinter"

		autolathe
			name = "Autolathe Board"
			desc = "The circuit board for a autolathe."
			id = "autolathe"
			req_tech = list("programming" = 2, "engineering" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/autolathe"

		rdservercontrol
			name = "R&D Server Control Console Board"
			desc = "The circuit board for a R&D Server Control Console"
			id = "rdservercontrol"
			req_tech = list("programming" = 3)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/rdservercontrol"

		rdserver
			name = "R&D Server Board"
			desc = "The circuit board for an R&D Server"
			id = "rdserver"
			req_tech = list("programming" = 3)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/rdserver"

		mechfab
			name = "Exosuit Fabricator Board"
			desc = "The circuit board for an Exosuit Fabricator"
			id = "mechfab"
			req_tech = list("programming" = 3, "engineering" = 3)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/mechfab"


/////////////////////////////////////////
////////////Power Stuff//////////////////
/////////////////////////////////////////

/*		pacman
			name = "PACMAN-type Generator Board"
			desc = "The circuit board that for a PACMAN-type portable generator."
			id = "pacman"
			req_tech = list("programming" = 3, "plasmatech" = 3, "powerstorage" = 3, "engineering" = 3)
			build_type = IMPRINTER
			reliability_base = 79
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/pacman"

		superpacman
			name = "SUPERPACMAN-type Generator Board"
			desc = "The circuit board that for a SUPERPACMAN-type portable generator."
			id = "superpacman"
			req_tech = list("programming" = 3, "powerstorage" = 4, "engineering" = 4)
			build_type = IMPRINTER
			reliability_base = 76
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/pacman/super"

		mrspacman
			name = "MRSPACMAN-type Generator Board"
			desc = "The circuit board that for a MRSPACMAN-type portable generator."
			id = "mrspacman"
			req_tech = list("programming" = 3, "powerstorage" = 5, "engineering" = 5)
			build_type = IMPRINTER
			reliability_base = 74
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/pacman/mrs"

*/

/////////////////////////////////////////
////////////Medical Tools////////////////
/////////////////////////////////////////

		mass_spectrometer
			name = "Mass-Spectrometer"
			desc = "A device for analyzing chemicals in the blood."
			id = "mass_spectrometer"
			req_tech = list("biotech" = 2, "magnets" = 2)
			build_type = PROTOLATHE
			materials = list("$metal" = 30, "$glass" = 20)
			reliability_base = 76
			build_path = "/obj/item/device/mass_spectrometer"

		cautery
			name = "Cauterizer"
			desc = "This stops bleeding, by burning the wound closed."
			id = "cautery"
			req_tech = list("materials" = 2, "biotech" = 1)
			build_type = PROTOLATHE
			materials = list("$metal" = 20)
			build_path = "/obj/item/weapon/cautery"

		scalpel
			name = "Scalpel"
			desc = "A scalpel, is a small and extremely sharp bladed instrument used for surgery."
			id = "scalpel"
			req_tech = list("materials" = 2, "biotech" = 1)
			build_type = PROTOLATHE
			materials = list("$metal" = 60)
			build_path = "/obj/item/weapon/scalpel"

		hemostat
			name = "Hemostat"
			desc = "A hemostat is a vital surgical tool used in almost any surgical procedure."
			id = "hemostat"
			req_tech = list("materials" = 2, "biotech" = 1)
			build_type = PROTOLATHE
			materials = list("$metal" = 20)
			build_path = "/obj/item/weapon/hemostat"

		retractor
			name = "Surgical Retractor"
			desc = "A retractor is a surgical instrument by which a surgeon can either actively separate the edges of a surgical incision or wound."
			id = "retractor"
			req_tech = list("materials" = 1, "biotech" = 1)
			build_type = PROTOLATHE
			materials = list("$metal" = 20)
			build_path = "/obj/item/weapon/retractor"


		surgicaldrill
			name = "Surgical Drill"
			desc = "A Surgical drill is a tool fitted with a cutting tool attachment or driving tool attachment used for drilling holes in the human body."
			id = "surgicaldrill"
			req_tech = list("materials" = 2, "biotech" = 1)
			build_type = PROTOLATHE
			materials = list("$metal" = 80)
			build_path = "/obj/item/weapon/surgicaldrill"

		circular_saw
			name = "Circular Saw"
			desc = "For heavy duty cutting of biological matter."
			id = "circular_saw"
			req_tech = list("materials" = 2, "biotech" = 1)
			build_type = PROTOLATHE
			materials = list("$metal" = 60)
			build_path = "/obj/item/weapon/circular_saw"

		adv_mass_spectrometer
			name = "Advanced Mass-Spectrometer"
			desc = "A device for analyzing chemicals in the blood and their quantities."
			id = "adv_mass_spectrometer"
			req_tech = list("biotech" = 2, "magnets" = 4)
			build_type = PROTOLATHE
			materials = list("$metal" = 30, "$glass" = 20)
			reliability_base = 74
			build_path = "/obj/item/device/mass_spectrometer/adv"

		mmi
			name = "Man-Machine Interface"
			desc = "The Warrior's bland acronym, MMI, obscures the true horror of this monstrosity."
			id = "mmi"
			req_tech = list("programming" = 2, "biotech" = 3)
			build_type = PROTOLATHE | MECHFAB
			materials = list("$metal" = 1000, "$glass" = 500)
			reliability_base = 76
			build_path = "/obj/item/device/mmi"

		hypospray
			name = "Hypospray"
			desc = "The DeForest Medical Corporation hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
			id = "hypospray"
			req_tech = list("materials" = 3, "biotech" = 3)
			build_type = PROTOLATHE
			materials = list("$metal" = 90, "tricordrazine" = 30)
			build_path = "/obj/item/weapon/reagent_containers/hypospray"

		tricorder
			name = "Tricorder"
			desc = "An advanced hand-held body scanner able to distinguish vital signs of the subject."
			id = "tricorder"
			req_tech = list("programming" = 2, "materials" = 3, "biotech" = 3, "powerstorage" = 3)
			build_type = PROTOLATHE
			materials = list("$metal" = 300, "$glass" = 20)
			build_path = "/obj/item/device/healthanalyzer/tricorder"

		mmi_radio
			name = "Radio-enabled Man-Machine Interface"
			desc = "The Warrior's bland acronym, MMI, obscures the true horror of this monstrosity. This one comes with a built-in radio."
			id = "mmi_radio"
			req_tech = list("programming" = 2, "biotech" = 4)
			build_type = PROTOLATHE | MECHFAB
			materials = list("$metal" = 1200, "$glass" = 500)
			reliability_base = 74
			build_path = "/obj/item/device/mmi/radio_enabled"

		genetics
			name = "Genetic Analyser"
			desc = "Used to analyse genetic abnormalities"
			id = "genetics"
			req_tech = list("programming" = 2, "materials" = 2, "biotech" = 2, "powerstorage" = 2)
			build_type = PROTOLATHE
			materials = list("$metal" = 300, "$glass" = 20)
			build_path = "/obj/item/device/geneticsanalyzer"

		regenerator
			name = "Dermal Regenerator"
			desc = "Used to heal light brute damage"
			id = "genetics"
			req_tech = list("programming" = 1, "materials" = 1, "biotech" = 2, "powerstorage" = 1)
			build_type = PROTOLATHE
			materials = list("$metal" = 300, "$glass" = 20)
			build_path = "/obj/item/weapon/dermalregenerator"


/////////////////////////////////////////
/////////////////Weapons/////////////////
/////////////////////////////////////////

		nuclear_gun
			name = "Advanced Energy Gun"
			desc = "An energy gun with an experimental miniaturized reactor."
			id = "nuclear_gun"
			req_tech = list("combat" = 3, "materials" = 5, "powerstorage" = 3)
			build_type = PROTOLATHE
			materials = list("$metal" = 5000, "$glass" = 1000, "$uranium" = 500)
			reliability_base = 76
			build_path = "/obj/item/weapon/gun/energy/nuclear"

		freeze_gun
			name = "Freeze Gun"
			desc = "A gun that shoots supercooled hydrogen particles to drastically chill a target's body temperature."
			id = "freeze_gun"
			req_tech = list("combat" = 3, "materials" = 4, "powerstorage" = 3, "magnets" = 2)
			build_type = PROTOLATHE
			materials = list("$metal" = 5000, "$glass" = 500, "$silver" = 3000)
			build_path = "/obj/item/weapon/gun/energy/freeze"

		energy_gun
			name = "Energy Gun"
			desc = "A basic energy-based gun with two settings: Stun and kill."
			id = "energy_gun"
			req_tech = list("combat" = 5, "materials" = 4, "powerstorage" = 5, "magnets" = 2)
			build_type = PROTOLATHE
			materials = list("$metal" = 7000, "$glass" = 500, "$silver" = 1000)
			build_path = "/obj/item/weapon/gun/energy"

		phaser_gun
			name = "Phaser"
			desc = "A gun with multiple settings allowing area of effect electrical fields to stun targets."
			id = "freeze_gun"
			req_tech = list("combat" = 4, "materials" = 4, "powerstorage" = 4, "magnets" = 2)
			build_type = PROTOLATHE
			materials = list("$metal" = 5000, "$glass" = 500, "$silver" = 3000)
			build_path = "/obj/item/weapon/gun/energy/phaser"

		sword
			name = "Energy Sword"
			desc = "May the force be within you."
			id = "sword"
			req_tech = list("syndicate" = 3, "materials" = 5, "powerstorage" = 3)
			build_type = PROTOLATHE
			materials = list("$metal" = 5000, "$glass" = 1000, "$uranium" = 500)
			reliability_base = 76
			build_path = "/obj/item/weapon/melee/energy/sword"

		baton
			name = "Stun Baton"
			desc = "Used to stun criminals for arrest."
			id = "baton"
			req_tech = list("materials" = 5, "powerstorage" = 3)
			build_type = PROTOLATHE
			materials = list("$metal" = 5000, "$glass" = 1000)
			reliability_base = 96
			build_path = "/obj/item/weapon/melee/baton"

//		large_grenade
//			name = "Large Grenade"
//			desc = "A grenade that affects a larger area and use larger containers."
//			id = "large_Grenade"
//			req_tech = list("combat" = 3, "materials" = 2)
//			build_type = PROTOLATHE
//			materials = list("$metal" = 3000)
//			reliability_base = 79
//			build_path = "/obj/item/weapon/chem_grenade/large"

		smg
			name = "Submachine Gun"
			desc = "A lightweight, fast firing gun."
			id = "smg"
			req_tech = list("combat" = 5, "materials" = 2)
			build_type = PROTOLATHE
			materials = list("$metal" = 8000, "$silver" = 2000, "$diamond" = 1000)
			build_path = "/obj/item/weapon/gun/projectile/automatic"

		c45
			name = "Ammunition Box (.45)"
			desc = "A box of prototype .45 ammunition."
			id = "c9mm"
			req_tech = list("combat" = 4, "materials" = 3)
			build_type = PROTOLATHE
			materials = list("$metal" = 3750, "$silver" = 100)
			build_path = "/obj/item/ammo_magazine/c45"

	//	c9mm
	//		name = "Ammunition Box (9mm)"
	//		desc = "A box of prototype 9mm ammunition."
	//		id = "c9mm"
	//		req_tech = list("combat" = 4, "materials" = 3)
	//		build_type = PROTOLATHE
	//		materials = list("$metal" = 3750, "$silver" = 100)
	//		build_path = "obj/item/ammo_magazine/c9mm"

		cloaking_device
			name = "Cloaking Device"
			desc = "Use this to become invisible to the human eyesocket."
			id = "cloaking_device"
			req_tech = list("combat" = 5, "materials" = 5, "powerstorage" = 5, "magnets" = 5)
			build_type = PROTOLATHE
			materials = list("$metal" = 5000, "$glass" = 500, "$silver" = 3000)
			build_path = "/obj/item/weapon/cloaking_device"


/////////////////////////////////////////
/////////////////Mining//////////////////
/////////////////////////////////////////

		jackhammer
			name = "Sonic Jackhammer"
			desc = "Cracks rocks with sonic blasts, perfect for killing cave lizards."
			id = "jackhammer"
			req_tech = list("materials" = 3, "powerstorage" = 2, "engineering" = 2)
			build_type = PROTOLATHE
			materials = list("$metal" = 2000, "$glass" = 500, "$silver" = 500)
			build_path = "/obj/item/weapon/tgpickaxe/jackhammer"

		drill
			name = "Mining Drill"
			desc = "Yours is the drill that will pierce through the rock walls."
			id = "drill"
			req_tech = list("materials" = 2, "powerstorage" = 3, "engineering" = 2)
			build_type = PROTOLATHE
			materials = list("$metal" = 6000, "$glass" = 1000) //expensive, but no need for miners.
			build_path = "/obj/item/weapon/tgpickaxe/drill"

		plasmacutter
			name = "Plasma Cutter"
			desc = "You could use it to cut limbs off of xenos! Or, you know, mine stuff."
			id = "plasmacutter"
			req_tech = list("materials" = 4, "plasmatech" = 3, "engineering" = 3)
			build_type = PROTOLATHE
			materials = list("$metal" = 1500, "$glass" = 500, "$gold" = 500, "$plasma" = 500)
			reliability_base = 79
			build_path = "/obj/item/weapon/tgpickaxe/plasmacutter"

		pick_diamond
			name = "Diamond Pickaxe"
			desc = "A pickaxe with a diamond pick head, this is just like minecraft."
			id = "pick_diamond"
			req_tech = list("materials" = 6)
			build_type = PROTOLATHE
			materials = list("$diamond" = 3000)
			build_path = "/obj/item/weapon/tgpickaxe/diamond"

		drill_diamond
			name = "Diamond Mining Drill"
			desc = "Yours is the drill that will pierce the heavens!"
			id = "drill_diamond"
			req_tech = list("materials" = 6, "powerstorage" = 4, "engineering" = 4)
			build_type = PROTOLATHE
			materials = list("$metal" = 3000, "$glass" = 1000, "$diamond" = 3750) //Yes, a whole diamond is needed.
			reliability_base = 79
			build_path = "/obj/item/weapon/tgpickaxe/diamonddrill"

/////////////////////////////////////////
//////////////Blue Space/////////////////
/////////////////////////////////////////

		beacon
			name = "Tracking Beacon"
			desc = "A blue space tracking beacon."
			id = "beacon"
			req_tech = list("bluespace" = 1)
			build_type = PROTOLATHE
			materials = list ("$metal" = 20, "$glass" = 10)
			build_path = "/obj/item/device/radio/beacon"

		bag_holding
			name = "Bag of Holding"
			desc = "A backpack that opens into a localized pocket of Blue Space."
			id = "bag_holding"
			req_tech = list("bluespace" = 4, "materials" = 6)
			build_type = PROTOLATHE
			materials = list("$gold" = 3000, "$diamond" = 1500, "$uranium" = 250)
			reliability_base = 80
			build_path = "/obj/item/weapon/storage/backpack/holding"

/////////////////////////////////////////
/////////////////HUDs////////////////////
/////////////////////////////////////////

			health_hud
				name = "Health Scanner HUD"
				desc = "A heads-up display that scans the humans in view and provides accurate data about their health status."
				id = "health_hud"
				req_tech = list("biotech" = 2, "magnets" = 3)
				build_type = PROTOLATHE
				materials = list("$metal" = 50, "$glass" = 50)
				build_path = "/obj/item/clothing/glasses/hud/health"

			security_hud
				name = "Security HUD"
				desc = "A heads-up display that scans the humans in view and provides accurate data about their ID status."
				id = "security_hud"
				req_tech = list("magnets" = 3, "combat" = 2)
				build_type = PROTOLATHE
				materials = list("$metal" = 50, "$glass" = 50)
				build_path = "/obj/item/clothing/glasses/hud/security"

			thermal_hud
				name = "Thermal HUD"
				desc = "A heads-up display that scans for heat prints in an area, allowing one to detect people through walls."
				id = "security_hud"
				req_tech = list("biotech" = 2, "magnets" = 3, "combat" = 5)
				build_type = PROTOLATHE
				materials = list("$metal" = 50, "$glass" = 50)
				build_path = "/obj/item/clothing/glasses/thermal"

/////////////////////////////////////////
//////////////////Test///////////////////
/////////////////////////////////////////

	/*	test
			name = "Test Design"
			desc = "A design to test the new protolathe."
			id = "protolathe_test"
			build_type = PROTOLATHE
			req_tech = list("materials" = 1)
			materials = list("$gold" = 3000, "iron" = 15, "copper" = 10, "$silver" = 2500)
			build_path = "/obj/item/weapon/banhammer" */

////////////////////////////////////////
//Disks for transporting design datums//
////////////////////////////////////////

/obj/item/weapon/disk/design_disk
	name = "Component Design Disk"
	desc = "A disk for storing device design data for construction in lathes."
	icon = 'cloning.dmi'
	icon_state = "datadisk2"
	item_state = "card-id"
	w_class = 1.0
	m_amt = 30
	g_amt = 10
	var/datum/design/blueprint
	New()
		src.pixel_x = rand(-5.0, 5)
		src.pixel_y = rand(-5.0, 5)


