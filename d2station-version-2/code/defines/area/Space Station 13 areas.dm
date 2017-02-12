/*

### This file contains a list of all the areas in your station. Format is as follows:

/area/CATEGORY/OR/DESCRIPTOR/NAME 	(you can make as many subdivisions as you want)
	name = "NICE NAME" 				(not required but makes things really nice)
	icon = "ICON FILENAME" 			(defaults to areas.dmi)
	icon_state = "NAME OF ICON" 	(defaults to "unknown" (blank))
	requires_power = 0 				(defaults to 1)
	music = "music/music.ogg"		(defaults to "music/music.ogg")

*/


/area
	var/fire = null
	var/atmos = 1
	var/atmosalm = null
	var/poweralm = 1
	var/party = null
	level = null
	name = "Space"
	icon = 'areas.dmi'
	icon_state = "unknown"
	layer = 10
	mouse_opacity = 0
	luminosity = 0
	var/lightswitch = 1

	var/eject = null

	var/requires_power = 1
	var/power_equip = 1
	var/power_light = 1
	var/power_environ = 1
	var/music = null
	var/used_equip = 0
	var/used_light = 0
	var/used_environ = 0


	var/no_air = null
	var/area/master				// master area used for power calcluations
								// (original area before splitting due to sd_DAL)
	var/list/related			// the other areas of the same type as this

/*Adding a wizard area teleport list because motherfucking lag -- Urist*/
/*I am far too lazy to make it a proper list of areas so I'll just make it run the usual telepot routine at the start of the game*/
var/list/teleportlocs = list()

proc/process_teleport_locs()
	for(var/area/AR in world)
		if(istype(AR, /area/shuttle) || istype(AR, /area/syndicate_station) || istype(AR, /area/wizard_station)) continue
		if(teleportlocs.Find(AR.name)) continue
		var/turf/picked = pick(get_area_turfs(AR.type))
		if (picked.z == 1)
			teleportlocs += AR.name
			teleportlocs[AR.name] = AR

var/list/ghostteleportlocs = list()

proc/process_ghost_teleport_locs()
	for(var/area/AR in world)
		if(ghostteleportlocs.Find(AR.name)) continue
		if(istype(AR, /area/turret_protected/aisat) || istype(AR, /area/derelict) || istype(AR, /area/tdome))
			ghostteleportlocs += AR.name
			ghostteleportlocs[AR.name] = AR
		var/turf/picked = pick(get_area_turfs(AR.type))
		if (picked.z == 1 || picked.z == 8)
			ghostteleportlocs += AR.name
			ghostteleportlocs[AR.name] = AR

/*-----------------------------------------------------------------------------*/

/area/engine/

/area/engine/heatengine

/area/turret_protected/

/area/arrival
	requires_power = 0

/area/arrival/start
	name = "Arrival Area"
	icon_state = "start"

/area/admin
	name = "Admin room"
	icon_state = "start"

//These are shuttle areas, they must contain two areas in a subgroup if you want to move a shuttle from one
//place to another. Look at escape shuttle for example.
//All shuttles show now be under shuttle since we have smooth-wall code.

/area/shuttle //DO NOT TURN THE SD_LIGHTING STUFF ON FOR SHUTTLES. IT BREAKS THINGS.
	requires_power = 0
	luminosity = 1
	sd_lighting = 0

/area/shuttle/arrival
	name = "Arrival Shuttle"

/area/shuttle/arrival/pre_game
	icon_state = "shuttle2"

/area/shuttle/arrival/station
	icon_state = "shuttle"

/area/shuttle/heatengine/dock
	icon_state = "shuttle5"

/area/shuttle/heatengine/satellite
	icon_state = "shuttle5"

/area/shuttle/dock2
	icon_state = "shuttle6"

/area/shuttle/dock2/ss13
	icon_state = "shuttle6"

/area/shuttle/dock2/derelic
	icon_state = "shuttle6"

/area/shuttle/dock2/Journey
	icon_state = "shuttle6"

/area/shuttle/dock2/syndi
	icon_state = "shuttle6"

/area/shuttle/derelict
	icon_state = "shuttle6"

/area/shuttle/derelict/station
	icon_state = "shuttle6"

/area/shuttle/derelict/derelict
	icon_state = "shuttle6"

/area/shuttle/derelict/transit
	icon_state = "shuttle6"

/area/shuttle/rdsat/station
	icon_state = "shuttle5"

/area/shuttle/rdsat/transit
	icon_state = "shuttle5"

/area/shuttle/rdsat/satellite
	icon_state = "shuttle5"

/area/shuttle/escape
	name = "Emergency Shuttle"
	music = "music/escape.ogg"

/area/shuttle/escape/station
	icon_state = "shuttle2"

/area/shuttle/escape/transit
	icon_state = "shuttle2"

/area/shuttle/escape/centcom
	icon_state = "shuttle"

/area/shuttle/mining
	name = "Mining Shuttle"
	icon_state = "miningshuttlestat"

/area/shuttle/mining/asteroid
	name = "Mining Shuttle"
	icon_state = "miningshuttlestat"

/area/shuttle/mining/station
	name = "Mining Shuttle"
	icon_state = "miningshuttledock"

/area/shuttle/mining/transit
	name = "Mining Shuttle"
	icon_state = "miningshuttlestat"

/area/shuttle/nori/
	name = "Nori's Shuttle"

/area/shuttle/nori/norishuttle
	icon_state = "shuttle5"

/area/shuttle/transport1/centcom
	icon_state = "shuttle"

/area/shuttle/transport2/centcom
	icon_state = "shuttle"

/area/shuttle/prison/
	name = "Prison Shuttle"

/area/shuttle/prison/station
	icon_state = "shuttle"

/area/shuttle/prison/prison
	icon_state = "shuttle2"

/area/shuttle/prison/transit
	icon_state = "shuttle2"

/area/shuttle/specops/centcom
	name = "Special Ops Shuttle"
	icon_state = "shuttlered"

/area/shuttle/specops/station
	name = "Special Ops Shuttle"
	icon_state = "shuttlered2"

/area/shuttle/thunderdome
	name = "honk"

/area/shuttle/thunderdome/grnshuttle
	name = "Thunderdome GRN Shuttle"
	icon_state = "green"

/area/shuttle/thunderdome/grnshuttle/dome
	name = "GRN Shuttle"
	icon_state = "shuttlegrn"

/area/shuttle/thunderdome/grnshuttle/station
	name = "GRN Station"
	icon_state = "shuttlegrn2"

/area/shuttle/thunderdome/redshuttle
	name = "Thunderdome RED Shuttle"
	icon_state = "red"

/area/shuttle/thunderdome/redshuttle/dome
	name = "RED Shuttle"
	icon_state = "shuttlered"

/area/shuttle/thunderdome/redshuttle/station
	name = "RED Station"
	icon_state = "shuttlered2"

/area/shuttle/pdock2
	icon_state = "shuttle6"

/area/shuttle/pdock2/ss13
	icon_state = "shuttle6"

/area/shuttle/pdock2/prison
	icon_state = "shuttle6"

/area/shuttle/pdock2/Journey
	icon_state = "shuttle6"
// === Trying to remove these areas:

/area/airtunnel1/      // referenced in airtunnel.dm:759

/area/dummy/           // Referenced in engine.dm:261

/area/start            // will be unused once kurper gets his login interface patch done
	name = "start area"
	icon_state = "start"

// === end remove

/area/puzzlechamber
	name = "Puzzle Area"
	icon_state = "puzzle"
	requires_power = 0

// CENTCOM

/area/centcom/adminquarts
	name = "Centcom Administration Quarters"
	icon_state = "purple"
	requires_power = 0

/area/centcom
	name = "Centcom"
	icon_state = "purple"
	requires_power = 0

/area/winterretreat
	name = "Winter Valley"
	icon_state = "puzzle"
	requires_power = 0
	luminosity = 1
	sd_lighting = 0

/area/winterretreat/hiddengrove
	name = "Christmas Clearing"
	icon_state = "puzzle"
	requires_power = 0

/area/centcom/evac
	name = "Centcom Emergency Shuttle"
	icon_state = "purple"
	requires_power = 0

/area/centcom/suppy
	name = "Centcom Supply Shuttle"
	icon_state = "purple"
	requires_power = 0

/area/centcom/ferry
	name = "Centcom Transport Shuttle"
	icon_state = "purple"
	requires_power = 0

/area/centcom/shuttle
	name = "Centcom Administration Shuttle"
	icon_state = "purple"
	requires_power = 0

/area/centcom/test
	name = "Centcom Testing Facility"
	icon_state = "purple"
	requires_power = 0

/area/centcom/living
	name = "Centcom Living Quarters"
	icon_state = "purple"
	requires_power = 0

/area/centcom/specops
	name = "Centcom Special Ops"
	icon_state = "purple"
	requires_power = 0

/area/centcom/creed
	name = "Creed's Office"
	icon_state = "purple"
	requires_power = 0

//EXTRA

/area/asteroid					// -- TLE
	name = "Asteroid"
	icon_state = "asteroid"
	requires_power = 0

/area/asteroid/cave				// -- TLE
	name = "Asteroid - Underground"
	icon_state = "cave"
	requires_power = 0

/area/planet/clown
	name = "Clown Planet"
	icon_state = "honk"
	requires_power = 0

/area/tdome
	name = "Thunderdome"
	icon_state = "medbay"
	requires_power = 0

/area/tdome/tdome1
	name = "Thunderdome (Team 1)"
	icon_state = "green"

/area/tdome/tdome2
	name = "Thunderdome (Team 2)"
	icon_state = "yellow"

/area/tdome/tdomeadmin
	name = "Thunderdome (Admin.)"
	icon_state = "purple"

/area/tdome/tdomeobserve
	name = "Thunderdome (Observer.)"
	icon_state = "purple"

//ENEMY

/area/syndicate_station
	name = "Syndicate Station"
	icon_state = "yellow"
	requires_power = 0

/area/syndicate_station/start
	name = "Syndicate Station Start"
	icon_state = "yellow"

/area/syndicate_station/one
	name = "Syndicate Station Location 1"
	icon_state = "green"

/area/syndicate_station/two
	name = "Syndicate Station Location 2"
	icon_state = "green"

/area/syndicate_station/three
	name = "Syndicate Station Location 3"
	icon_state = "green"

/area/syndicate_station/four
	name = "Syndicate Station Location 4"
	icon_state = "green"

/area/wizard_station
	name = "Wizard's Den"
	icon_state = "yellow"
	requires_power = 0

//PRISON

/area/prison/arrival_airlock
	name = "Prison Station Airlock"
	icon_state = "green"

/area/prison/control
	name = "Prison Security Checkpoint"
	icon_state = "security"

/area/prison/crew_quarters
	name = "Prison Security Quarters"
	icon_state = "security"

/area/prison/closet
	name = "Prison Supply Closet"
	icon_state = "dk_yellow"

/area/prison/hallway/fore
	name = "Prison Fore Hallway"
	icon_state = "yellow"

/area/prison/hallway/aft
	name = "Prison Aft Hallway"
	icon_state = "yellow"

/area/prison/hallway/port
	name = "Prison Port Hallway"
	icon_state = "yellow"

/area/prison/hallway/starboard
	name = "Prison Starboard Hallway"
	icon_state = "yellow"

/area/prison/morgue
	name = "Prison Morgue"
	icon_state = "morgue"

/area/prison/medical_research
	name = "Prison Genetic Research"
	icon_state = "medresearch"

/area/prison/medical
	name = "Prison Medbay"
	icon_state = "medbay"

/area/prison/solar
	name = "Prison Solar Array"
	icon_state = "storage"
	requires_power = 0

/area/prison/podbay
	name = "Prison Podbay"
	icon_state = "dk_yellow"

/area/prison/solar_control
	name = "Prison Solar Array Control"
	icon_state = "dk_yellow"

/area/prison/solitary
	name = "Solitary Confinement"
	icon_state = "brig"

/area/prison/cell_block/A
	name = "Prison Cell Block A"
	icon_state = "brig"

/area/prison/cell_block/B
	name = "Prison Cell Block B"
	icon_state = "brig"

/area/prison/cell_block/C
	name = "Prison Cell Block C"
	icon_state = "brig"

//STATION13
/area/commsat
	name = "Communications Satellite"
	icon_state = "commsat"
	requires_power = 1

/area/commsat/solar
	name = "Communications Sattelite"
	icon_state = "yellow"
	requires_power = 0

/area/atmos
 	name = "Atmospherics"
 	icon_state = "atmos"

//Maintenance

/area/maintenance/fpmaint
	name = "Fore Port Maintenance"
	icon_state = "fpmaint"

/area/maintenance/fpmaint2
	name = "Secondary Fore Port Maintenance"
	icon_state = "fpmaint"

/area/maintenance/fsmaint
	name = "Fore Starboard Maintenance"
	icon_state = "fsmaint"

/area/maintenance/asmaint
	name = "Aft Starboard Maintenance"
	icon_state = "asmaint"

/area/maintenance/asmaint2
	name = "Secondary Aft Starboard Maintenance"
	icon_state = "asmaint"

/area/maintenance/apmaint
	name = "Aft Port Maintenance"
	icon_state = "apmaint"

/area/maintenance/maintcentral
	name = "Central Maintenance"
	icon_state = "maintcentral"

/area/maintenance/bathroom
	name = "Bathroom"
	icon_state = "bathroom"
/area/maintenance/fore
	name = "Fore Maintenance"
	icon_state = "fmaint"

/area/maintenance/starboard
	name = "Starboard Maintenance"
	icon_state = "smaint"

/area/maintenance/port
	name = "Port Maintenance"
	icon_state = "pmaint"

/area/maintenance/aft
	name = "Aft Maintenance"
	icon_state = "amaint"

/area/maintenance/auxsolarport
	name = "Port Auxiliary Solar Maintenance"
	icon_state = "SolarcontrolA"

/area/maintenance/starboardsolar
	name = "Starboard Solar Maintenance"
	icon_state = "SolarcontrolS"

/area/maintenance/portsolar
	name = "Port Solar Maintenance"
	icon_state = "SolarcontrolP"

/area/maintenance/auxsolarstarboard
	name = "Starboard Auxiliary Solar Maintenance"
	icon_state = "SolarcontrolA"

/area/maintenance/storage
	name = "Atmospherics"
	icon_state = "green"

/area/maintenance/disposal
	name = "Waste Disposal"
	icon_state = "disposal"

/area/maintenance/incinerator
	name = "Incinerator"
	icon_state = "disposal"

//Hallway

/area/hallway/primary/fore
	name = "Fore Primary Hallway"
	icon_state = "hallF"

/area/hallway/primary/starboard
	name = "Starboard Primary Hallway"
	icon_state = "hallS"

/area/hallway/primary/aft
	name = "Aft Primary Hallway"
	icon_state = "hallA"

/area/hallway/secondary/docking
	name = "Shuttle Docking Area"
	icon_state = "docking"

/area/hallway/primary/port
	name = "Port Primary Hallway"
	icon_state = "hallP"

/area/hallway/primary/central
	name = "Central Primary Hallway"
	icon_state = "hallC"

/area/hallway/secondary/exit
	name = "Escape Shuttle Hallway"
	icon_state = "escape"

/area/hallway/secondary/construction
	name = "Construction Area"
	icon_state = "construction"

/area/hallway/secondary/entry
	name = "Arrival Shuttle Hallway"
	icon_state = "entry"

/area/store
 	name = "Mech Bay"
 	icon_state = "store"

//Command

/area/bridge
	name = "Bridge"
	icon_state = "bridge"
	music = "signal"

/area/commsat
	name = "Communications Satellite"
	icon_state = "commshuttle"
	requires_power = 1

/area/commsat/solar
	name = "Communications Sattelite"
	icon_state = "yellow"
	requires_power = 0

/area/crew_quarters/captain
	name = "Captain's Quarters"
	icon_state = "captain"

/area/crew_quarters/crew
	name = "Crew Quarters"
	icon_state = "crewqrtrs"

/area/crew_quarters/courtroom
	name = "Courtroom"
	icon_state = "courtroom"

/area/crew_quarters/heads
	name = "Head of Personnel's Quarters"
	icon_state = "head_quarters"

/area/crew_quarters/hor
	name = "Research Director's Office"
	icon_state = "head_quarters"

/area/crew_quarters/chief
	name = "Chief Engineer's Office"
	icon_state = "head_quarters"

//Crew

/area/crew_quarters
	name = "Dormitory"
	icon_state = "Sleep"

/area/crew_quarters/toilet
	name = "Dormitory Toilets"
	icon_state = "toilet"

/area/crew_quarters/sleep_male
	name = "Male Dorm"
	icon_state = "Sleep"

/area/crew_quarters/sleep_male/toilet_male
	name = "Male Toilets"
	icon_state = "toilet"

/area/crew_quarters/sleep_female
	name = "Female Dorm"
	icon_state = "Sleep"

/area/crew_quarters/sleep_female/toilet_female
	name = "Female Toilets"
	icon_state = "toilet"

/area/crew_quarters/locker
	name = "Locker Room"
	icon_state = "locker"

/area/crew_quarters/locker/locker_toilet
	name = "Locker Toilets"
	icon_state = "toilet"

/area/crew_quarters/fitness
	name = "Fitness Room"
	icon_state = "fitness"

/area/crew_quarters/cafeteria
	name = "Cafeteria"
	icon_state = "cafeteria"

/area/crew_quarters/kitchen
	name = "Kitchen"
	icon_state = "kitchen"

/area/crew_quarters/bar
	name= "Bar"
	icon_state = "bar"

/area/crew_quarters/barber
	name= "Barbershop"
	icon_state = "bar"

/area/crew_quarters/miner
	name = "Miners' Quarters"
	icon_state = "mine"

/area/library
 	name = "Library"
 	icon_state = "library"

/area/chapel/main
	name = "Chapel"
	icon_state = "chapel"

/area/chapel/office
	name = "Chapel Office"
	icon_state = "chapeloffice"

/area/lawoffice
	name = "Law Office"
	icon_state = "law"

//Engineering

/area/engine/engine_smes
	name = "Engine SMES Room"
	icon_state = "enginesmes"

/area/engine/engine
	name = "Engine Chambre"
	icon_state = "engine"

/area/engine/mechwork
	name = "Mechanics Workshop"
	icon_state = "engine"

/area/engine/engine_walls
	name = "Engine Walls"
	icon_state = "engine"

/area/engine/engine_gas_storage
	name = "Engine Storage"
	icon_state = "engine_gas_storage"

/area/engine/heat_engine
	name = "Heat Distribution Engine"
	icon_state = "heatengine"

/area/engine/engine_hallway
	name = "Engine Hallway"
	icon_state = "enginehall"
/area/engine/engine_mon
	name = "Engine Storage"
	icon_state = "enginemon"

/area/engine/engine_eva
	name = "Engine EVA"
	icon_state = "engineeva"

/area/engine/combustion
	name = "Engine Core"
	icon_state = "engine"
	music = "signal"


/area/engine/engine_control
	name = "Engine Control"
	icon_state = "engine_control"

/area/engine/launcher
	name = "Engine Launcher Room"
	icon_state = "engine_monitoring"

/area/miningasteroid
	name = "Mining Satellite"
	icon_state = "mine"

/area/assembly/chargebay
	name = "Recharging Bay"
	icon_state = "mechbay"

/area/assembly/showroom
	name = "Robotics Showroom"
	icon_state = "showroom"

/area/assembly/assembly_line
	name = "Assembly Line"
	icon_state = "ass_line"

//Teleporter

/area/teleporter
	name = "Teleporter"
	icon_state = "teleporter"
	music = "signal"

/area/AIsattele
	name = "AI Satellite Teleporter Room"
	icon_state = "teleporter"
	music = "signal"

/area/Emilytest
	name = "Emily's test room"
	icon_state = "teleporter"
	music = "signal"
	requires_power = 0

//MedBay

/area/medical/medbay
	name = "Medbay"
	icon_state = "medbay"
	music = 'signal.ogg'

/area/medical/cmo
	name = "Chief Medical Officer's office"
	icon_state = "medbay"
	music = 'signal.ogg'

/area/medical/robotics
	name = "Robotics"
	icon_state = "medresearch"

/area/medical/research
	name = "Medical Research"
	icon_state = "medresearch"

/area/medical/virology
	name = "Virology"
	icon_state = "viral_lab"

/area/medical/morgue
	name = "Morgue"
	icon_state = "morgue"

/area/medical/chemistry
	name = "Chemistry"
	icon_state = "chem"

/area/medical/oproom
	name = "Operating Room"
	icon_state = "operroom"

/area/medical/patientroom
	name = "Operating Room"
	icon_state = "patientroom"

//Security

/area/security/main
	name = "Security"
	icon_state = "security"

/area/security/armory
	name = "Armory"
	icon_state = "security"

/area/security/guardquarters
	name = "Guard's Quarters"
	icon_state = "security"

/area/security/brig
	name = "Brig"
	icon_state = "brig"

/area/security/brig/cell1
	name = "Cell 1"
	icon_state = "cell1"

/area/security/brig/cell2
	name = "Cell 2"
	icon_state = "cell2"
/area/security/brig/cell3
	name = "Cell 3"
	icon_state = "cell3"

/area/security/brig/cell4
	name = "Cell 4"
	icon_state = "cell4"
/area/security/brig/cell5
	name = "Cell 5"
	icon_state = "cell5"
/area/security/brig/cell6
	name = "Cell 6"
	icon_state = "cell6"
/area/security/warden
	name = "Warden"
	icon_state = "Warden"

/area/security/hos
	name = "Head of Security"
	icon_state = "security"

/area/security/weaponlabS
	name = "Weapon Lab Sercurity Checkpoint"
	icon_state = "weaponlabS"
/area/security/detectives_office
	name = "Detectives Office"
	icon_state = "detective"

/area/security/nuke_storage
	name = "Nuke Storage"
	icon_state = "nuke_storage"

/area/security/checkpoint
	name = "Security Checkpoint"
	icon_state = "checkpoint1"

/area/security/checkpoint2
	name = "Security Checkpoint"
	icon_state = "security"

/area/security/vacantoffice
	name = "Vacant Office"
	icon_state = "security"

//Solars

/area/solar
	requires_power = 0
	luminosity = 1
	sd_lighting = 0

/area/solar/auxport
	name = "Port Auxiliary Solar Array"
	icon_state = "panelsA"

/area/solar/auxstarboard
	name = "Starboard Auxiliary Solar Array"
	icon_state = "panelsA"

/area/solar/fore
	name = "Fore Solar Array"
	icon_state = "yellow"

/area/solar/aft
	name = "Aft Solar Array"
	icon_state = "aft"

/area/solar/starboard
	name = "Starboard Solar Array"
	icon_state = "panelsS"

/area/solar/port
	name = "Port Solar Array"
	icon_state = "panelsP"

/area/syndicate_station2
	name = "Syndicate Station"
	icon_state = "yellow"
	requires_power = 0

/area/syndicate_wreck
	name = "Syndicate Station"
	icon_state = "yellow"

/area/quartermaster
	name = "Quartermasters"
	icon_state = "quart"

/area/quartermaster/office
	name = "Cargo Office"
	icon_state = "quartoffice"

/area/quartermaster/storage
	name = "Cargo Bay"
	icon_state = "quartstorage"

/area/quartermaster/qm
	name = "Quartermaster's Office"
	icon_state = "quart"

/area/quartermaster/sorting
	name = "Delivery Office"
	icon_state = "quartstorage"

/area/quartermaster/miningdock
	name = "Mining Dock"
	icon_state = "yellow"

/area/quartermaster/mechbay
	name = "Mech Bay"
	icon_state = "yellow"

/area/janitor/
	name = "Janitors Closet"
	icon_state = "janitor"

/area/store
 	name = "Store"
 	icon_state = "store"

/area/hydroponics
	name = "Hydroponics"
	icon_state = "hydro"

/area/science/weaponlab
	name = "Weapons Lab"
	icon_state = "weaponlab"

/area/science/weaponscanner
	name = "Weapons Lab"
	icon_state = "security"

/area/science/viral_lab
	name = "Virology"
	icon_state = "viral_lab"

/area/science/Server
	name = "Server Room"
	icon_state = "chem"

/area/science/Server2
	name = "Server's Core"
	icon_state = "viral_lab"

/area/science/viral_cell2
	name = "Virology"
	icon_state = "viral_lab"

/area/science/viral_cell3
	name = "Virology"
	icon_state = "viral_lab"

/area/science/viral_decon
	name = "Virology Decontamination"
	icon_state = "viral_lab"


/area/science/heatlab
	name = "Heated Environment Lab"
	icon_state = "heatlab"

/area/science/chemistry
	name = "Chemistry"
	icon_state = "chem"

//Toxins

/area/toxins/lab
	name = "Toxin Lab"
	icon_state = "toxlab"

/area/toxins/lab2
	name = "Toxin Lab 2"
	icon_state = "toxlab"

/area/toxins/xenobiology
	name = "Secure Storage"
	icon_state = "toxlab"

/area/toxins/lockerroom
	name = "Locker Room"
	icon_state = "toxlab"

/area/toxins/storage
	name = "Toxin Storage"
	icon_state = "toxstorage"

/area/toxins/test_area
	name = "Toxin Test Area"
	icon_state = "toxtest"

/area/toxins/mixing
	name = "Toxin Mixing Room"
	icon_state = "toxmix"

/area/toxins/server
	name = "Server Room"
	icon_state = "server"

//Research Satellite

/area/rdsat/hallway
	name = "Research Satellite"
	icon_state = "hallF"

/area/rdsat/hallway/docking
	name = "Shuttle Docking Area"
	icon_state = "docking"

/area/rdsat/toxins
	name = "Toxin Research"
	icon_state = "toxlab"

/area/rdsat/gasstorage
	name = "Toxin Research Storage"
	icon_state = "toxstorage"

/area/rdsat/viral_lab
	name = "Viral Research"
	icon_state = "viral_lab"

/area/rdsat/chemistry
	name = "Chemical Research"
	icon_state = "chem"

/area/rdsat/server
	name = "RD Server Core"
	icon_state = "storage"

/area/rdsat/matstorage
	name = "Materials Storage"
	icon_state = "storage"

/area/rdsat/kitchen
	name = "Scientists' Kitchen"
	icon_state = "kitchen"

/area/rdsat/research
	name = "Materials Research"
	icon_state = "research"

/area/rdsat/quarters
	name = "Scientists' Quarters"
	icon_state = "crewqrtrs"

/area/rdsat/solar
	name = "Research Satellite Solars"
	icon_state = "yellow"
	requires_power = 0

//Storage

/area/storage/tools
	name = "Tool Storage"
	icon_state = "storage"

/area/storage/primary
	name = "Primary Tool Storage"
	icon_state = "primarystorage"

/area/storage/autolathe
	name = "Autolathe Storage"
	icon_state = "storage"

/area/storage/auxillary
	name = "Auxillary Storage"
	icon_state = "auxstorage"

/area/storage/eva
	name = "EVA Storage"
	icon_state = "eva"

/area/storage/secure
	name = "Secure Storage"
	icon_state = "storage"

/area/storage/emergency
	name = "Emergency Storage A"
	icon_state = "emergencystorage"

/area/storage/emergency2
	name = "Emergency Storage B"
	icon_state = "emergencystorage"

/area/storage/tech
	name = "Technical Storage"
	icon_state = "auxstorage"

/area/storage/testroom
	requires_power = 0
	name = "Test Room"
	icon_state = "storage"

//DJSTATION

/area/djstation
	name = "Ruskie DJ Station"
	icon_state = "DJ"

/area/djstation/solars
	name = "DJ Station Solars"
	icon_state = "DJ"

//DERELICT

/area/derelict
	name = "Derelict Station"
	icon_state = "storage"

/area/derelict/hallway/primary
	name = "Derelict Primary Hallway"
	icon_state = "hallP"

/area/derelict/hallway/secondary
	name = "Derelict Secondary Hallway"
	icon_state = "hallS"

/area/derelict/arrival
	name = "Arrival Centre"
	icon_state = "yellow"

/area/derelict/storage/equipment
	name = "Derelict Equipment Storage"

/area/derelict/storage/storage_access
	name = "Derelict Storage Access"

/area/derelict/storage/engine_storage
	name = "Derelict Engine Storage"
	icon_state = "green"

/area/derelict/bridge
	name = "Control Room"
	icon_state = "bridge"

/area/derelict/secret
	name = "Secret Room"
	icon_state = "library"

/area/derelict/bridge/access
	name = "Control Room Access"
	icon_state = "auxstorage"

/area/derelict/bridge/ai_upload
	name = "Ruined Computer Core"
	icon_state = "ai"

/area/derelict/solar_control
	name = "Solar Control"
	icon_state = "engine"

/area/derelict/crew_quarters
	name = "Derelict Crew Quarters"
	icon_state = "fitness"

/area/derelict/medical
	name = "Derelict Medbay"
	icon_state = "medbay"

/area/derelict/medical/morgue
	name = "Derelict Morgue"
	icon_state = "morgue"

/area/derelict/medical/chapel
	name = "Derelict Chapel"
	icon_state = "chapel"

/area/derelict/teleporter
	name = "Derelict Teleporter"
	icon_state = "teleporter"

/area/derelict/eva
	name = "Derelict EVA Storage"
	icon_state = "eva"

/area/derelict/ship
	name = "Abandoned ship"
	icon_state = "yellow"

/area/solar/derelict_starboard
	name = "Derelict Starboard Solar Array"
	icon_state = "panelsS"

/area/solar/derelict_aft
	name = "Derelict Aft Solar Array"
	icon_state = "aft"

//Construction

/area/construction
	name = "Construction Area"
	icon_state = "yellow"

/area/construction/supplyshuttle
	name = "Supply Shuttle"
	icon_state = "yellow"

/area/construction/quarters
	name = "Engineer's Quarters"
	icon_state = "yellow"

/area/construction/qmaint
	name = "Maintenance"
	icon_state = "yellow"

/area/construction/hallway
	name = "Hallway"
	icon_state = "yellow"

/area/construction/solars
	name = "Solar Panels"
	icon_state = "yellow"

/area/construction/solarscontrol
	name = "Solar Panel Control"
	icon_state = "yellow"

/area/construction/Storage
	name = "Construction Site Storage"
	icon_state = "yellow"

//AI

/area/ai_monitored/storage/eva
	name = "EVA Storage"
	icon_state = "eva"

/area/ai_monitored/storage/secure
	name = "Secure Storage"
	icon_state = "storage"

/area/ai_monitored/storage/emergency
	name = "Emergency Storage"
	icon_state = "storage"

/area/turret_protected/ai_upload
	name = "AI Upload Chamber"
	icon_state = "ai_upload"

/area/turret_protected/ai_upload_foyer
	name = "AI Upload Foyer"
	icon_state = "ai_foyer"

/area/turret_protected/ai
	name = "AI Chamber"
	icon_state = "ai_chamber"

/area/turret_protected/aisat
	name = "AI Satellite"
	icon_state = "ai"

/area/turret_protected/aisat_interior
	name = "AI Satellite"
	icon_state = "ai"

/area/turret_protected/AIsatextFP
	name = "AI Sat Ext"
	icon_state = "storage"
	luminosity = 1
	sd_lighting = 0

/area/turret_protected/AIsatextFS
	name = "AI Sat Ext"
	icon_state = "storage"
	luminosity = 1
	sd_lighting = 0

/area/turret_protected/AIsatextAS
	name = "AI Sat Ext"
	icon_state = "storage"
	luminosity = 1
	sd_lighting = 0

/area/turret_protected/AIsatextAP
	name = "AI Sat Ext"
	icon_state = "storage"
	luminosity = 1
	sd_lighting = 0

/area/turret_protected/weaplab
	name = "Weapons Lab"
	icon_state = "weaponlabT"

/area/turret_protected/prisonstation
	name = "Cell Block Automated Guard"
	icon_state = "weaponlabT"