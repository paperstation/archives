#ifdef DELETE_QUEUE_DEBUG
var/global/list/detailed_delete_count = list()
var/global/list/detailed_delete_gc_count = list()
#endif

#ifdef MACHINE_PROCESSING_DEBUG
var/global/list/detailed_machine_timings = list()
#endif
#ifdef QUEUE_STAT_DEBUG
var/global/list/queue_stat_list = list()
#endif

/**
 * qdel
 *
 * queues a var for deletion by the delete queue processor.
 * if used on /world, /list, /client, or /savefile, it just skips the queue.
 */
proc/qdel(var/datum/O)
	if(!O)
		return

	if(!delete_queue)
		delete_queue = new /datum/dynamicQueue(100)

	if (istype(O))
		O:dispose()
		if (istype(O, /atom/movable))
			O:loc = null

		/**
		 * We'll assume here that the object will be GC'ed.
		 * If the object is not GC'ed and must be explicitly deleted,
		 * the delete queue process will decrement the gc counter and
		 * increment the explicit delete counter for the type.
		 */
		#ifdef DELETE_QUEUE_DEBUG
		detailed_delete_gc_count[O.type]++
		#endif

		// In the delete queue, we need to check if this is actually supposed to be deleted.
		O.qdeled = 1

		/**
		 * We will only enqueue the ref for deletion. This gives the GC time to work,
		 * and makes less work for the delete queue to do.
		 */
		delete_queue.enqueue("\ref[O]")
	else
		if(islist(O))
			O:len = 0
			del(O)
		else if(O == world)
			del(O)
			CRASH("Cannot qdel /world! Fuck you!")
		else if(istype(O, /client))
			del(O)
			CRASH("Cannot qdel /client! Fuck you!")
		else if(istype(O, /savefile))
			del(O)
			CRASH("Cannot qdel /savefile! Fuck you!")
		else
			CRASH("Cannot qdel this unknown type")

// -------------------- GLOBAL VARS --------------------

var/global

	obj/datacore/data_core = null
	obj/overlay/plmaster = null
	obj/overlay/slmaster = null
	obj/overlay/w1master = null
	obj/overlay/w2master = null
	obj/overlay/w3master = null

	turf/buzztile = null

	//obj/hud/main_hud1 = null

	list/cameras = list()
	list/clients = list()
	list/mobs = list()
	list/machines = list()
	list/allcables = list()
	list/atmos_machines = list() // need another list to pull atmos machines out of the main machine loop and in with the pipe networks
	list/processing_items = list()
		//items that ask to be called every cycle

	datum/dynamicQueue/delete_queue //List of items that want to be deleted

	//list/total_deletes = list() //List of things totally deleted
	list/critters = list()
	list/ghost_drones = list()
	list/muted_keys = list()

	round_time_check = 0			// set to world.timeofday when round starts, then used to calculate round time
	defer_powernet_rebuild = 0		// true if net rebuild will be called manually after an event
	defer_main_loops = 0			// true if master controller should be paused (usually for some large event)
	machines_may_use_wired_power = 0
	DBConnection/dbcon				// persistent connection to a mysql server
	DBQuery/query					// Database query handler
	regex/url_regex = null
	force_random_names = 0			// for the pre-roundstart thing
	force_random_looks = 0			// same as above

	list/health_mon_icons = new/list()
	list/mob_static_icons = list()
	list/orbicons = list()

	list/rewardDB = list() //Contains instances of the reward datums
	list/materialRecipes = list() //Contains instances of the material recipe datums

	// don't ask.
	list/couches = list()

	list/traitList = list() //List of trait objects

	IRC_alerted_keys = list()

	list/spawned_in_keys = list() //Player keys that have played this round, to prevent that "jerk gets deleted by a bug, gets to respawn" thing.

	list/random_pod_codes = list() // if /obj/random_pod_spawner exists on the map, this will be filled with refs to the pods they make, and people joining up will have a chance to start with the unlock code in their memory

	//list/disposed_things_that_dont_work = list()

	already_a_dominic = 0 // no just shut up right now, I don't care

	list/cursors_selection = list("Default" = 'icons/cursors/target/default.dmi',
	"Red" = 'icons/cursors/target/red.dmi',
	"Green" = 'icons/cursors/target/green.dmi',
	"Blue" = 'icons/cursors/target/blue.dmi',
	"Yellow" = 'icons/cursors/target/yellow.dmi',
	"Cyan" = 'icons/cursors/target/cyan.dmi',
	"White" = 'icons/cursors/target/white.dmi',
	"Rainbow" = 'icons/cursors/target/rainbow.dmi',
	"Animated Rainbow" = 'icons/cursors/target/rainbowanimated.dmi',
	"Flashing" = 'icons/cursors/target/flashing.dmi',
	"Minimalistic" = 'icons/cursors/target/minimalistic.dmi',
	"Small" = 'icons/cursors/target/small.dmi')

	list/hud_style_selection = list("New" = 'icons/mob/hud_human_new.dmi',
	"Old" = 'icons/mob/hud_human.dmi',
	"Classic" = 'icons/mob/hud_human_classic.dmi',
	"Mithril" = 'icons/mob/hud_human_quilty.dmi')

	list/customization_styles = list("None" = "none",
	"Balding" = "balding",
	"Tonsure" = "tonsure",
	"Buzzcut" = "cut",
	"Trimmed" = "short",
	"Mohawk" = "mohawk",
	"Mohawk: Fade from End" = "mohawkFT",
	"Mohawk: Fade from Root" = "mohawkFB",
	"Mohawk: Stripes" = "mohawkS",
	"Flat Top" = "flattop",
	"Pompadour" = "pomp",
	"Pompadour: Greaser Shine" = "pompS",
	"Ponytail" = "ponytail",
	"Mullet" = "long",
	"Emo" = "emo",
	"Emo: Highlight" = "emoH",
	"Bun" = "bun",
	"Bieber" = "bieb",
	"Bowl Cut" = "bowl",
	"Parted Hair" = "part",
	"Einstein" = "einstein",
	"Einstein: Alternating" = "einalt",
	"Clown" = "clown",
	"Clown: Top" = "clownT",
	"Clown: Middle Band" = "clownM",
	"Clown: Bottom" = "clownB",
	"Draped" = "shoulders",
	"Bedhead" = "bedhead",
	"Dreadlocks" = "dreads",
	"Dreadlocks: Alternating" = "dreadsA",
	"Afro" = "afro",
	"Afro: Left Half" = "afroHR",
	"Afro: Right Half" = "afroHL",
	"Afro: Top" = "afroST",
	"Afro: Middle Band" = "afroSM",
	"Afro: Bottom" = "afroSB",
	"Afro: Left Side" = "afroSL",
	"Afro: Right Side" = "afroSR",
	"Afro: Center Streak" = "afroSC",
	"Afro: NE Corner" = "afroCNE",
	"Afro: NW Corner" = "afroCNW",
	"Afro: SE Corner" = "afroCSE",
	"Afro: SW Corner" = "afroCSW",
	"Afro: Tall Stripes" = "afroSV",
	"Afro: Long Stripes" = "afroSH",
	"Long Braid" = "longbraid",
	"Very Long" = "vlong",
	"Hairmetal" = "80s",
	"Hairmetal: Faded" = "80sfade",
	"Glammetal" = "glammetal",
	"Glammetal: Faded" = "glammetalO",
	"Kingmetal" = "king-of-rock-and-roll",
	"Scraggly" = "scraggly",
	"Fabio" = "fabio",
	"Right Half-Shaved" = "halfshavedL",
	"Left Half-Shaved" = "halfshavedR",
	"High Ponytail" = "spud",
	"Low Ponytail" = "band",
	"High Flat Top" = "charioteers",
	"Indian" = "indian",
	"Shoulder Drape" = "pulledf",
	"Punky Flip" = "shortflip",
	"Pigtails" = "pig",
	"Low Pigtails" = "lowpig",
	"Mid-Back Length" = "midb",
	"Split-Tails" = "twotail",
	"Shoulder Length" = "shoulderl",
	"Pulled Back" = "pulledb",
	"Choppy Short" = "chop_short",
	"Long and Froofy" = "froofy_long",
	"Wavy Ponytail" = "wavy_tail",
	"Chaplin" = "chaplin",
	"Selleck" = "selleck",
	"Watson" = "watson",
	"Old Nick" = "devil",
	"Fu Manchu" = "fu",
	"Twirly" = "villain",
	"Dali" = "dali",
	"Hogan" = "hogan",
	"Van Dyke" = "vandyke",
	"Hipster" = "hip",
	"Robotnik" = "robo",
	"Elvis" = "elvis",
	"Goatee" = "gt",
	"Chinstrap" = "chin",
	"Neckbeard" = "neckbeard",
	"Abe" = "abe",
	"Full Beard" = "fullbeard",
	"Braided Beard" = "braided",
	"Puffy Beard" = "puffbeard",
	"Long Beard" = "longbeard",
	"Tramp" = "tramp",
	"Tramp: Beard Stains" = "trampstains",
	"Eyebrows" = "eyebrows",
	"Huge Eyebrows" = "thufir",
	"Hair Streak" = "streak",
	"Beard Streaks" = "bstreak",
	"Eyeshadow" = "eyeshadow",
	"Lipstick" = "lipstick",
	"Heterochromia Left" = "hetcroL",
	"Heterochromia Right" = "hetcroR")

	list/customization_styles_gimmick = list("Goku" = "goku",
	"Homer" = "homer",
	"Bart" = "bart",
	"Jetson" = "jetson",
	"X-COM Rookie" = "xcom",
	"Zapped" = "zapped",
	"Rainbow Afro" = "afroRB",
	"Flame Hair" = "flames",
	"Sailor Moon" = "sailor_moon",
	"Wizard" = "wiz",
	"Afro: Alternating Halves" = "afroHA")

	list/underwear_styles = list("No Underwear" = "none",
	"Briefs" = "briefs",
	"Boxers" = "boxers",
	"Bra and Panties" = "brapan",
	"Tanktop and Panties" = "tankpan",
	"Bra and Boyshorts" = "braboy",
	"Tanktop and Boyshorts" = "tankboy",
	"Panties" = "panties",
	"Boyshorts" = "boyshort")

	list/handwriting_styles = list("Aguafina Script",
	"Alex Brush",
	"Allan",
	"Allura",
	"Annie Use Your Telescope",
	"Architects Daughter",
	"Arizonia",
	"Bad Script",
	"Bilbo Swash Caps",
	"Bilbo",
	"Calligraffitti",
	"Cedarville Cursive",
	"Clicker Script",
	"Coming Soon",
	"Condiment",
	"Cookie",
	"Courgette",
	"Covered By Your Grace",
	"Crafty Girls",
	"Damion",
	"Dancing Script",
	"Dawning of a New Day",
	"Delius Swash Caps",
	"Delius Unicase",
	"Delius",
	"Devonshire",
	"Engagement",
	"Euphoria Script",
	"Fondamento",
	"Give You Glory",
	"Gloria Hallelujah",
	"Gochi Hand",
	"Grand Hotel",
	"Great Vibes",
	"Handlee",
	"Herr Von Muellerhoff",
	"Homemade Apple",
	"Indie Flower",
	"Italianno",
	"Julee",
	"Just Another Hand",
	"Just Me Again Down Here",
	"Kalam",
	"Kaushan Script",
	"Kristi",
	"La Belle Aurore",
	"Leckerli One",
	"Lobster Two",
	"Lobster",
	"Loved by the King",
	"Lovers Quarrel",
	"Marck Script",
	"Meddon",
	"Merienda One",
	"Merienda",
	"Molle",
	"Montez",
	"Mr Dafoe",
	"Mr De Haviland",
	"Mrs Saint Delafield",
	"Neucha",
	"Niconne",
	"Norican",
	"Nothing You Could Do",
	"Over the Rainbow",
	"Pacifico",
	"Parisienne",
	"Patrick Hand SC",
	"Patrick Hand",
	"Petit Formal Script",
	"Pinyon Script",
	"Playball",
	"Quintessential",
	"Qwigley",
	"Rancho",
	"Redressed",
	"Reenie Beanie",
	"Rochester",
	"Rock Salt",
	"Rouge Script",
	"Sacramento",
	"Satisfy",
	"Schoolbell",
	"Shadows Into Light Two",
	"Shadows Into Light",
	"Short Stack",
	"Sofia",
	"Stalemate",
	"Sue Ellen Francisco",
	"Sunshiney",
	"Swanky and Moo Moo",
	"Tangerine",
	"The Girl Next Door",
	"Unkempt",
	"Vibur",
	"Waiting for the Sunrise",
	"Walter Turncoat",
	"Yellowtail",
	"Yesteryear",
	"Zeyada")

	////////////////

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

	skipupdate = 0
	///////////////
	event = 0
	blobevent = 0
	///////////////

	//april fools
	manualbreathing = 0
	manualblinking = 0

	monkeysspeakhuman = 0
	late_traitors = 1
	no_automatic_ending = 0

	sound_waiting = 1
	soundpref_override = 0

	diary = null
	hublog = null
	station_name = null
	game_version = "Goon Station 13 (r" + svn_revision + ")"

//	datum/air_tunnel/air_tunnel1/SS13_airtunnel = null
	going = 1.0
	master_mode = "traitor"

	datum/engine_eject/engine_eject_control = null
	host = null
	game_start_delayed = 0
	game_end_delayed = 0
	game_end_delayer = null
	ooc_allowed = 1
	looc_allowed = 0
	dooc_allowed = 1
	player_capa = 0
	player_cap = 55
	traitor_scaling = 1
	deadchat_allowed = 1
	debug_mixed_forced_wraith = 0
	debug_mixed_forced_blob = 0
	farting_allowed = 1
	blood_system = 1
	bone_system = 0
	suicide_allowed = 1
	dna_ident = 1
	special_respawning = 1
	abandon_allowed = 1
	enter_allowed = 1
	shuttle_frozen = 0
	shuttle_left = 0
	turd_location = 0
	brigshuttle_location = 0
	miningshuttle_location = 0
	researchshuttle_location = 0
	researchshuttle_lockdown = 0
	toggles_enabled = 1
	announce_banlogin = 1
	announce_jobbans = 0
	station_creepified = 0
	AI_points = 10
	AI_points_win = 1000

	outpost_destroyed = 0
	solar_flare = 0
	fart_attack = 0
	blowout = 0

	total_corrupted_terrain = 0
	total_corruptible_terrain = 0

	// putting crew score shit here
	score_crewscore = 0
	score_stuffshipped = 0
	score_stufftraded = 0
	score_stuffharvested = 0
	score_oremined = 0
	score_gemsmined = 0
	score_cyborgsmade = 0
	score_researchdone = 0
	score_eventsendured = 0
	score_powerloss = 0
	score_escapees = 0
	score_deadcrew = 0
	score_mess = 0
	score_meals = 0
	score_disease = 0

	score_deadcommand = 0
	score_arrested = 0
	score_traitorswon = 0
	score_allarrested = 0

	score_opkilled = 0
	score_disc = 0
	score_nuked = 0

	// these ones are mainly for the stat panel
	score_powerbonus = 0
	score_messbonus = 0
	score_deadaipenalty = 0

	score_foodeaten = 0
	score_clownabuse = 0

	score_richestname = null
	score_richestjob = null
	score_richestcash = 0
	score_richestkey = null

	score_dmgestname = null
	score_dmgestjob = null
	score_dmgestdamage = 0
	score_dmgestkey = null

	score_allstock_html = null

	///////////////
	//Radio network passwords
	netpass_security = null
	netpass_heads = null
	netpass_medical = null
	netpass_banking = null
	netpass_cargo = null
	netpass_syndicate = null //Detomatix

	///////////////

	list/teleareas = list(  )

	list/logs = list ( //Loooooooooogs
		"admin_help" = list (  ),
		"speech" = list (  ),
		"ooc" = list (  ),
		"combat" = list (  ),
		"station" = list (  ),
		"pdamsg" = list (  ),
		"admin" = list (  ),
		"mentor_help" = list (  ),
		"telepathy" = list (  ),
		"bombing" = list (  ),
		"signalers" = list (  ),
		"atmos" = list (  ),
		"debug" = list (  ),
		"wire_debug" = list (  ),
		"pathology" = list (  ),
		"deleted" = list (  ),
		"vehicle" = list (  )
	)
	savefile/compid_file 	//The file holding computer ID information
	do_compid_analysis = 1	//Should we be analysing the comp IDs of new clients?
	list/admins = list(  )
	list/onlineAdmins = list(  )
	list/shuttles = list(  )
	list/reg_dna = list(  )
//	list/traitobj = list(  )
	list/warned_keys = list()	// tracking warnings per round, i guess

	CELLRATE = 0.002  // multiplier for watts per tick <> cell storage (eg: .002 means if there is a load of 1000 watts, 20 units will be taken from a cell per second)
	CHARGELEVEL = 0.001 // Cap for how fast cells charge, as a percentage-per-tick (.001 means cellcharge is capped to 1% per second)

	shuttle_z = 2	//default
//	airtunnel_start = 68 // default
//	airtunnel_stop = 68 // default
//	airtunnel_bottom = 72 // default
	list/monkeystart = list()
	list/wizardstart = list()
	list/predstart = list()
	list/syndicatestart = list()
	list/newplayer_start = list()
	list/latejoin = list()
#ifdef MAP_OVERRIDE_DESTINY
	list/rp_latejoin = list()
#endif
	list/observer_start = list()
	list/clownstart = list()
	list/prisonwarp = list()	//prisoners go to these
	//list/mazewarp = list()
	list/tdome1 = list()
	list/tdome2 = list()
	list/prisonsecuritywarp = list()	//prison security goes to these
	list/prisonwarped = list()	//list of players already warped
	list/blobstart = list()
	list/kudzustart = list()
	list/peststart = list()
	list/blobs = list()
	list/wormholeturfs = list()
	list/halloweenspawn = list()
	list/nuclear_auths = list()
	list/telesci = list() // special turfs from map landmarks to always allow telescience to access
						  // telesci landmarks add a 3z3 area centered on themselves to this list
	list/icefall = list() // list of locations for people to fall if they enter the deep abyss on the ice moon
	list/iceelefall = list() // list of locations for people to fall if they enter the ice moon elevator shaft
	list/deepfall = list() // list of locations for people to fall into the precursor pit area
	list/ancientfall = list() // list of locations for people to fall into the ancient pit area
	list/bioelefall = list() // biodome elevator shaft
	list/cardinal = list( NORTH, SOUTH, EAST, WEST )
	list/ordinal = list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
	list/alldirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)

	// Controllers
	datum/research/disease/disease_research = new()
	datum/research/artifact/artifact_research = new()
	datum/research/robotics/robotics_research = new()
	datum/wage_system/wagesystem
	datum/shipping_market/shippingmarket

	datum/station_state/start_state = null
	datum/configuration/config = null
	datum/vote/vote = null
	datum/sun/sun = null

	datum/changelog/changelog = null
	datum/admin_changelog/admin_changelog = null

	list/powernets = null

	Debug = 0	// global debug switch
	Debug2 = 0

	datum/debug/debugobj

	datum/moduletypes/mods = new()

	shuttlecoming = 0

	join_motd = null
	rules = null
	forceblob = 0

	halloween_mode = 0

	literal_disarm = 0

	global_sims_mode = 0 // SET THIS TO 0 TO DISABLE SIMS MODE

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

	global_jobban_cache = ""		// once jobban list is ready this is set to a giant string of all the jobban data. the new panel chops it up for use client side with javascript
	global_jobban_cache_rev = 0 	// increments every time the ban panel is built so clients know if they have the latest
	global_jobban_cache_built = 0	// set to world.timeofday when the cache is built

	building_jobbans = 0	// ditto
	jobban_count = 0		// ditto

	// drsingh global reaction cache to reduce cpu usage in handle_reactions (Chemistry-Holder.dm)
	list/chemical_reactions_cache = list()

	// SpyGuy global reaction structure to further recuce cpu usage in handle_reactions (Chemistry-Structure.dm)
	list/total_chem_reactions = list()
	list/chem_reactions_by_id = list() //This sure beats processing the monster above if I want a particular reaction. =I

	//SpyGuy: The reagents cache is now an associative list
	list/reagents_cache = list()

	// if you want stuff to not be spawnable by the list or buildmode, put it in here:
	list/do_not_spawn = list("/obj/bhole","/obj/item/old_grenade/gravaton","/mob/living/carbon/human/krampus")
	// cache for reusing datums
	list/object_pools = list()

	// list of miscreants since mode is irrelevant
	list/miscreants = list()

	// Antag overlays for admin ghosts, Syndieborgs and the like (Convair880).
	antag_generic = image('icons/mob/antag_overlays.dmi', icon_state = "generic")
	antag_syndieborg = image('icons/mob/antag_overlays.dmi', icon_state = "syndieborg")
	antag_traitor = image('icons/mob/antag_overlays.dmi', icon_state = "traitor")
	antag_changeling = image('icons/mob/antag_overlays.dmi', icon_state = "changeling")
	antag_wizard = image('icons/mob/antag_overlays.dmi', icon_state = "wizard")
	antag_vampire = image('icons/mob/antag_overlays.dmi', icon_state = "vampire")
	antag_predator = image('icons/mob/antag_overlays.dmi', icon_state = "predator")
	antag_werewolf = image('icons/mob/antag_overlays.dmi', icon_state = "werewolf")
	antag_emagged = image('icons/mob/antag_overlays.dmi', icon_state = "emagged")
	antag_mindslave = image('icons/mob/antag_overlays.dmi', icon_state = "mindslave")
	antag_vampthrall = image('icons/mob/antag_overlays.dmi', icon_state = "vampthrall")
	antag_head = image('icons/mob/antag_overlays.dmi', icon_state = "head")
	antag_rev = image('icons/mob/antag_overlays.dmi', icon_state = "rev")
	antag_revhead = image('icons/mob/antag_overlays.dmi', icon_state = "rev_head")
	antag_syndicate = image('icons/mob/antag_overlays.dmi', icon_state = "syndicate")
	antag_spyleader = image('icons/mob/antag_overlays.dmi', icon_state = "spy")
	antag_spyslave = image('icons/mob/antag_overlays.dmi', icon_state = "spyslave")
	antag_gang = image('icons/mob/antag_overlays.dmi', icon_state = "gang")
	antag_grinch = image('icons/mob/antag_overlays.dmi', icon_state = "grinch")
	antag_wraith = image('icons/mob/antag_overlays.dmi', icon_state = "wraith")
	antag_omnitraitor = image('icons/mob/antag_overlays.dmi', icon_state = "omnitraitor")
	antag_blob = image('icons/mob/antag_overlays.dmi', icon_state = "blob")
	antag_wrestler = image('icons/mob/antag_overlays.dmi', icon_state = "wrestler")

	//SpyGuy: Oh my fucking god the QM shit. *cry *wail *sob *weep *vomit *scream
	list/datum/supply_packs/qm_supply_cache = list()

	//Okay, I guess this was getting constructed every time someone wanted something from it
	list/datum/syndicate_buylist/syndi_buylist_cache = list()

	//AI camera movement dealies
	defer_camnet_rebuild = 0 //What it says on the tin.
	camnet_needs_rebuild = 0 //Also what it says on the tin.
	list/obj/machinery/camera/dirty_cameras = list() //Cameras that should be rebuilt

	list/obj/machinery/camera/camnets = list() //Associative list keyed by network name, contains a list of each camera in a network.
	list/datum/particleSystem/mechanic/camera_path_list = list() //List of particlesystems that the connection display proc creates. I dunno where else to put it. :(
	camera_network_reciprocity = 1 //If camera connections reciprocate one another or if the path is calculated separately for each camera
	list/datum/ai_camera_tracker/tracking_list = list()

	centralConn = 1 //Are we able to connect to the central server?
	centralConnTries = 0 //How many times have we tried and failed to connect?

	//Resource Management
	list/localResources = list()
	list/cachedResources = list()
	cdn = "" //Contains link to CDN as specified in the config (if not locally testing)
	disableResourceCache = 0

	//Pool limiter overrides
	list/pool_limit_overrides = null

	// for translating a zone_sel's id to its name
	list/zone_sel2name = list("head" = "head",
	"chest" = "chest",
	"l_arm" = "left arm",
	"r_arm" = "right arm",
	"l_leg" = "left leg",
	"r_leg" = "right leg")

var/global/mentorhelp_text_color = "#CC0066"
/proc/set_mentorhelp_color(var/new_color as color)
	if (!new_color)
		new_color = input(usr, "Select Mentorhelp color", "Selection", mentorhelp_text_color) as null|color
	if (new_color)
		mentorhelp_text_color = new_color
