var/global
	obj/datacore/data_core = null
	obj/overlay/plmaster = null
	obj/overlay/slmaster = null
	obj/overlay/clmaster = null
	//obj/hud/main_hud1 = null
	list/mobs = list()
	list/machines = list()
	list/processing_items = list()
	list/active_diseases = list()
		//items that ask to be called every cycle

	defer_powernet_rebuild = 0		// true if net rebuild will be called manually after an event

	powerreport = null //muskets 250810 these four are needed for the new engineering pda to work
	powerreportnodes = null //might be a better way to do it but w/e
	powerreportavail = null
	powerreportviewload = null

	list/global_map = null
	//list/global_map = list(list(1,5),list(4,3))//an array of map Z levels.
	//Resulting sector map looks like
	//|_1_|_4_|
	//|_5_|_3_|
	//
	//1 - SS13
	//4 - Derelict
	//3 - AI satellite
	//5 - empty space

var

	//////////////

	BLINDBLOCK = 0
	DEAFBLOCK = 0
	HULKBLOCK = 0
	TELEBLOCK = 0
	FIREBLOCK = 0
	XRAYBLOCK = 0
	CLUMSYBLOCK = 0
	FAKEBLOCK = 0
	BLOCKADD = 0
	DIFFMUT = 0
	HEADACHEBLOCK = 0
	COUGHBLOCK = 0
	TWITCHBLOCK = 0
	NERVOUSBLOCK = 0
	NOBREATHBLOCK = 0
	REMOTEVIEWBLOCK = 0
	REGENERATEBLOCK = 0
	INCREASERUNBLOCK = 0
	REMOTETALKBLOCK = 0
	MORPHBLOCK = 0
	BLENDBLOCK = 0
	HALLUCINATIONBLOCK = 0
	NOPRINTSBLOCK = 0
	BLOCK = 0
	SMALLSIZEBLOCK = 0
	SHOCKIMMUNITYBLOCK = 0

	skipupdate = 0
	///////////////
	eventchance = 1 //% per 2 mins
	event = 0
	hadevent = 0
	blobevent = 0
	///////////////
	meteorevent = 0

	diary = null
	station_name = null
	game_version = "D2Station V5"

	datum/air_tunnel/air_tunnel1/SS13_airtunnel = null
	going = 1.0
	master_mode = "traitor"//"extended"

	datum/engine_eject/engine_eject_control = null
	host = null
	aliens_allowed = 1
	ooc_allowed = 1
	dooc_allowed = 1
	traitor_scaling = 1
	goonsay_allowed = 1
	dna_ident = 1
	abandon_allowed = 1
	enter_allowed = 1
	guests_allowed = 1
	shuttle_frozen = 0
	shuttle_left = 0
	tinted_weldhelh = 1 //as soon as the thing is sprited, we'll code in the toggle verb, bot for now, it should stay on by default. -errorage //Until you have the actual functionality for it, don't set this on by default. You're putting the cart before the horse. --DH

	aiMax = 1
	captainMax = 1
	engineerMax = 5
	//minerMax = 3
	barmanMax = 1
	scientistMax = 3
	chemistMax = 2
	geneticistMax = 2
	securityMax = 6
	hopMax = 1
	hosMax = 1
	directorMax = 1
	chiefMax = 1
	atmosMax = 4
	detectiveMax = 1
	chaplainMax = 1
	janitorMax = 1
	doctorMax = 6
	clownMax = 1
	chefMax = 1
	roboticsMax = 3
	cargoMax = 1
	//cargotechMax = 2
	hydroponicsMax = 3
	//librarianMax = 1
	lawyerMax = 1
	viroMax = 1
	wardenMax = 1
	cmoMax = 1
	mimeMax = 1
	prostMax = 1
	retardMax = 1
	monkeyMax = 1
	//sorterMax = 2
	//borgMax = 1 < Isn't used anymore since borgs can't latejoin now. -- Urist

	list/bombers = list(  )
	list/admin_log = list (  )
	list/lastsignalers = list(	)	//keeps last 100 signals here in format: "[src] used \ref[src] @ location [src.loc]: [freq]/[code]"
	list/lawchanges = list(  ) //Stores who uploaded laws to which silicon-based lifeform, and what the law was
	list/admins = list(  )
	list/shuttles = list(  )
	list/reg_dna = list(  )
//	list/traitobj = list(  )


	CELLRATE = 0.002  // multiplier for watts per tick <> cell storage (eg: .002 means if there is a load of 1000 watts, 20 units will be taken from a cell per second)
	CHARGELEVEL = 0.001 // Cap for how fast cells charge, as a percentage-per-tick (.001 means cellcharge is capped to 1% per second)

	shuttle_z = 2	//default
	airtunnel_start = 68 // default
	airtunnel_stop = 68 // default
	airtunnel_bottom = 72 // default
	list/monkeystart = list()
	list/wizardstart = list()
	list/newplayer_start = list()
	list/latejoin = list()
	list/prisonwarp = list()	//prisoners go to these
	list/holdingfacility = list()	//captured people go here
	list/xeno_spawn = list()//Aliens spawn at these.
	list/mazewarp = list()
	list/tdome1 = list()
	list/tdome2 = list()
	list/tdomeobserve = list()
	list/tdomeadmin = list()
	list/puzzlechambersubject = list()
	list/puzzlechamberescape = list()
	list/prisonsecuritywarp = list()	//prison security goes to these
	list/prisonwarped = list()	//list of players already warped
	list/blobstart = list()
	list/blobs = list()
//	list/traitors = list()	//traitor list
	list/cardinal = list( NORTH, SOUTH, EAST, WEST )
	list/cardinal8 = list( NORTH, NORTHEAST, NORTHWEST, SOUTH, SOUTHEAST, SOUTHWEST, EAST, WEST )
	list/alldirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)

	datum/station_state/start_state = null
	datum/configuration/config = null
	datum/vote/vote = null
	datum/sun/sun = null
	// **********************************
	//	Networking Support
	// **********************************

	//Network address generation info
	list/usedtypes = list()
	list/usedids = list()
	list/usednetids = list()

	//True if computernet rebuild will be called manually after an event
	defer_computernet_rebuild = 0

	//Computernets in the world.
	list/datum/computernet/computernets = null

	//All the passwords needed for specific network devices
	list/accesspasswords = list()


	list/powernets = null

	Debug = 0	// global debug switch
	Debug2 = 0

	datum/debug/debugobj

	datum/moduletypes/mods = new()

	wavesecret = 0

	shuttlecoming = 0

	join_motd = null
	auth_motd = null
	rules = null
	no_auth_motd = null
	forceblob = 0

	//airlockWireColorToIndex takes a number representing the wire color, e.g. the orange wire is always 1, the dark red wire is always 2, etc. It returns the index for whatever that wire does.
	//airlockIndexToWireColor does the opposite thing - it takes the index for what the wire does, for example AIRLOCK_WIRE_IDSCAN is 1, AIRLOCK_WIRE_POWER1 is 2, etc. It returns the wire color number.
	//airlockWireColorToFlag takes the wire color number and returns the flag for it (1, 2, 4, 8, 16, etc)
	list/airlockWireColorToFlag = RandomAirlockWires()
	list/airlockIndexToFlag
	list/airlockIndexToWireColor
	list/airlockWireColorToIndex
	list/APCWireColorToFlag = RandomAPCWires()
	list/APCIndexToFlag
	list/APCIndexToWireColor
	list/APCWireColorToIndex
	list/BorgWireColorToFlag = RandomBorgWires()
	list/BorgIndexToFlag
	list/BorgIndexToWireColor
	list/BorgWireColorToIndex

	const/SPEED_OF_LIGHT = 3e8 //not exact but hey!
	const/SPEED_OF_LIGHT_SQ = 9e+16
	const/FIRE_DAMAGE_MODIFIER = 0.0215 //Higher values result in more external fire damage to the skin (default 0.0215)
	const/AIR_DAMAGE_MODIFIER = 2.025 //More means less damage from hot air scalding lungs, less = more damage. (default 2.025)
	const/INFINITY = 1e31 //closer then enough

	//Don't set this very much higher then 1024 unless you like inviting people in to dos your server with message spam
	const/MAX_MESSAGE_LEN = 1024

	const/shuttle_time_in_station = 1800 // 3 minutes in the station
	const/shuttle_time_to_arrive = 6000 // 10 minutes to arrive



	// MySQL configuration

	sqladdress = "localhost"
	sqlport = "3306"
	sqldb = "tgstation"
	sqllogin = "root"
	sqlpass = ""

	sqllogging = 0 // Should we log deaths, population stats, etc?



	// Forum MySQL configuration (for use with forum account/key authentication)
	// These are all default values that will load should the forumdbconfig.txt
	// file fail to read for whatever reason.

	forumsqladdress = "localhost"
	forumsqlport = "3306"
	forumsqldb = "tgstation"
	forumsqllogin = "root"
	forumsqlpass = ""
	forum_activated_group = "2"
	forum_authenticated_group = "10"

// these global variables are placed in global.dm
// these should be added to relevant places within the code such as the chef cooking something would increment the
// meals score thing
	score_crewscore = 0 // this is the overall score for the whole round
	score_stuffshipped = 0 // how many useful items have cargo shipped out?
	score_stuffharvested = 0 // how many harvests have hydroponics done?
	score_oremined = 0 // obvious
	score_cyborgsmade = 0
	score_researchdone = 0
	score_eventsendured = 0 // how many random events did the station survive?
	score_powerloss = 0 // how many APCs have poor charge?
	score_escapees = 0 // how many people got out alive?
	score_deadcrew = 0 // dead bodies on the station, oh no
	score_mess = 0 // how much poo, puke, gibs, etc went uncleaned
	score_meals = 0
	score_disease = 0 // how many rampant, uncured diseases are on board the station

	score_deadcommand = 0 // used during rev, how many command staff perished
	score_arrested = 0 // how many traitors/revs/whatever are alive in the brig
	score_traitorswon = 0 // how many traitors were successful?
	score_allarrested = 0 // did the crew catch all the enemies alive?

	score_opkilled = 0 // used during nuke mode, how many operatives died?
	score_disc = 0 // is the disc safe and secure?
	score_nuked = 0 // was the station blown into little bits?
	score_cigssmoked = 0 //puff

	// these ones are mainly for the stat panel
	score_powerbonus = 0 // if all APCs on the station are running optimally, big bonus
	score_messbonus = 0 // if there are no messes on the station anywhere, huge bonus
	score_deadaipenalty = 0 // is the AI dead? if so, big penalty

	score_foodeaten = 0 // nom nom nom
	score_clownabuse = 0 // how many times a clown was punched, struck or otherwise maligned

	score_moneyspent = 0
	score_moneyearned = 0

	score_richestname = null // this is all stuff to show who was the richest alive on the shuttle
	score_richestjob = null  // kinda pointless if you dont have a money system i guess
	score_richestcash = 0
	score_richestkey = null

	score_dmgestname = null // who had the most damage on the shuttle (but was still alive)
	score_dmgestjob = null
	score_dmgestdamage = 0
	score_dmgestkey = null


