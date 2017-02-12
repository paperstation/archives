/* Protip: Prepending an underscore to this file puts it at the top of the compile order,
// so that it already has the defines for the later files that use them.
*/
#define NETWORK_MACHINE_RESET_DELAY 40 //Time (in 1/10 of a second) before we can be manually reset again (machines).

#define LEVEL_HOST 6
#define LEVEL_CODER 5
#define LEVEL_SHITGUY 4
#define LEVEL_PA 3
#define LEVEL_ADMIN 2
#define LEVEL_SA 1
#define LEVEL_MOD 0
#define LEVEL_BABBY -1

#define SAVEFILE_VERSION_MIN	3
#define SAVEFILE_VERSION_MAX	7
#define SAVEFILE_PROFILES_MAX	3

//Action defines
#define INTERRUPT_ALWAYS -1 //Internal flag that will always interrupt any action.
#define INTERRUPT_MOVE 1 //Interrupted when object moves
#define INTERRUPT_ACT 2 //Interrupted when object does anything
#define INTERRUPT_ATTACKED 4 //Interrupted when object is attacked
#define INTERRUPT_STUNNED 8//Interrupted when owner is stunned or knocked out etc.
#define INTERRUPT_ACTION 16 //Interrupted when another action is started.

#define ACTIONSTATE_STOPPED 1 //Action has not been started yet.
#define ACTIONSTATE_RUNNING 2 //Action is in progress
#define ACTIONSTATE_INTERRUPTED 4 //Action was interrupted
#define ACTIONSTATE_ENDED 8 //Action ended succesfully
#define ACTIONSTATE_DELETE 16 //Action is ready to be deleted.
#define ACTIONSTATE_FINISH 32 //Will finish action after next process.
#define ACTIONSTATE_INFINITE 64 //Will not finish unless interrupted.
//Action defines END

//Material flag defines
#define MATERIAL_CRYSTAL 1 //Crystals, Minerals
#define MATERIAL_METAL 2   //Metals
#define MATERIAL_CLOTH 4   //Cloth or cloth-like
#define MATERIAL_ORGANIC 8 //Coal, meat and whatnot.
#define MATERIAL_ENERGY 16 //Is energy or outputs energy.
#define MATERIAL_RUBBER 32 //Rubber , latex etc

#define MATERIAL_ALPHA_OPACITY 190 //At which alpha do opague objects become see-through?
//---

//Very specific cruiser defines
#define CRUISER_FIREMODE_LEFT 1 //Fire only left weapon
#define CRUISER_FIREMODE_RIGHT 2//Fire only right weapon
#define CRUISER_FIREMODE_BOTH 4 //Fire both weapons
#define CRUISER_FIREMODE_ALT 8  //Alternate between the weapons.

#define SPEED_OF_LIGHT 3e8 //not exact but hey!
#define SPEED_OF_LIGHT_SQ 9e+16
#define FIRE_DAMAGE_MODIFIER 0.0215 //Higher values result in more external fire damage to the skin (default 0.0215)
#define AIR_DAMAGE_MODIFIER 2.025 //More means less damage from hot air scalding lungs, less = more damage. (default 2.025)
#define INFINITY 1e31 //closer then enough

//#define nround(x, n) round(x, 10 ** n)
//#define floor(x) round(x)
//#define ceiling(x) -round(-x)

#define ceil(x) (-round(-(x)))
#define nround(x) (((x % 1) >= 0.5)?round(x):ceil(x))

//Don't set this very much higher then 1024 unless you like inviting people in to dos your server with message spam
#define MAX_MESSAGE_LEN 1024


#define R_IDEAL_GAS_EQUATION	8.31 //kPa*L/(K*mol)
#define ONE_ATMOSPHERE		101.325	//kPa

#define CELL_VOLUME 2500	//liters in a cell
#define MOLES_CELLSTANDARD (ONE_ATMOSPHERE*CELL_VOLUME/(T20C*R_IDEAL_GAS_EQUATION))	//moles in a 2.5 m^3 cell at 101.325 Pa and 20 degC

#define O2STANDARD 0.21
#define N2STANDARD 0.79
//
#define MOLES_O2STANDARD MOLES_CELLSTANDARD*O2STANDARD	// O2 standard value (21%)
#define MOLES_N2STANDARD MOLES_CELLSTANDARD*N2STANDARD	// N2 standard value (79%)

#define MOLES_PLASMA_VISIBLE	2 //Moles in a standard cell after which plasma is visible

#define BREATH_VOLUME 0.5	//liters in a normal breath
#define BREATH_PERCENTAGE BREATH_VOLUME/CELL_VOLUME
	//Amount of air to take a from a tile
#define HUMAN_NEEDED_OXYGEN	MOLES_CELLSTANDARD*BREATH_PERCENTAGE*0.16
	//Amount of air needed before pass out/suffocation commences


#define MINIMUM_AIR_RATIO_TO_SUSPEND 0.08
	//Minimum ratio of air that must move to/from a tile to suspend group processing
#define MINIMUM_AIR_TO_SUSPEND MOLES_CELLSTANDARD*MINIMUM_AIR_RATIO_TO_SUSPEND
	//Minimum amount of air that has to move before a group processing can be suspended

#define MINIMUM_WATER_TO_SUSPEND MOLAR_DENSITY_WATER*CELL_VOLUME*MINIMUM_AIR_RATIO_TO_SUSPEND

#define MINIMUM_MOLES_DELTA_TO_MOVE MOLES_CELLSTANDARD*MINIMUM_AIR_RATIO_TO_SUSPEND //Either this must be active
#define MINIMUM_TEMPERATURE_TO_MOVE	T20C+100 		  //or this (or both, obviously)

#define MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND 0.012
#define MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND 5
	//Minimum temperature difference before group processing is suspended
#define MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER 1
	//Minimum temperature difference before the gas temperatures are just set to be equal

#define MINIMUM_TEMPERATURE_FOR_SUPERCONDUCTION		T20C+10
#define MINIMUM_TEMPERATURE_START_SUPERCONDUCTION	T20C+200

#define FLOOR_HEAT_TRANSFER_COEFFICIENT 0.15
#define WALL_HEAT_TRANSFER_COEFFICIENT 0.12
#define SPACE_HEAT_TRANSFER_COEFFICIENT 0.20 //a hack to partly simulate radiative heat
#define OPEN_HEAT_TRANSFER_COEFFICIENT 0.40
#define WINDOW_HEAT_TRANSFER_COEFFICIENT 0.18 //a hack for now
	//Must be between 0 and 1. Values closer to 1 equalize temperature faster
	//Should not exceed 0.4 else strange heat flow occur

#define FIRE_MINIMUM_TEMPERATURE_TO_SPREAD	120+T0C
#define FIRE_MINIMUM_TEMPERATURE_TO_EXIST	100+T0C
#define FIRE_SPREAD_RADIOSITY_SCALE		0.85
#define FIRE_CARBON_ENERGY_RELEASED	  500000 //Amount of heat released per mole of burnt carbon into the tile
#define FIRE_PLASMA_ENERGY_RELEASED	 3000000 //Amount of heat released per mole of burnt plasma into the tile
#define FIRE_GROWTH_RATE			25000 //For small fires

//Plasma fire properties
#define PLASMA_MINIMUM_BURN_TEMPERATURE		100+T0C
#define PLASMA_UPPER_TEMPERATURE			2370+T0C
#define PLASMA_MINIMUM_OXYGEN_NEEDED		2
#define PLASMA_MINIMUM_OXYGEN_PLASMA_RATIO	30
#define PLASMA_OXYGEN_FULLBURN				10

#define T0C 273.15					// 0degC
#define T20C 293.15					// 20degC
#define TCMB 2.7					// -270.3degC

#define TANK_LEAK_PRESSURE		(30.*ONE_ATMOSPHERE)	// Tank starts leaking
#define TANK_RUPTURE_PRESSURE	(40.*ONE_ATMOSPHERE) // Tank spills all contents into atmosphere

#define TANK_FRAGMENT_PRESSURE	(50.*ONE_ATMOSPHERE) // Boom 3x3 base explosion
#define TANK_FRAGMENT_SCALE	    (10.*ONE_ATMOSPHERE) // +1 for each SCALE kPa aboe threshold
								// was 2 atm

#define NORMPIPERATE 30					//pipe-insulation rate divisor
#define HEATPIPERATE 8					//heat-exch pipe insulation

#define FLOWFRAC 0.99				// fraction of gas transfered per process

// Defines the Mining Z level, change this when the map changes
// all this does is set the z-level to be ignored by erebite explosion admin log messages
// if you want to see all erebite explosions set this to 0 or -1 or something
#define MINING_Z 4

//FLAGS BITMASK
#define ONBACK 1			// can be put in back slot
#define TABLEPASS 2			// can pass by a table or rack
#define NODRIFT 4			// thing doesn't drift in space
#define USEDELAY 8			// put this on either a thing you don't want to be hit rapidly, or a thing you don't want people to hit other stuff rapidly with
#define EXTRADELAY 16		// 1 second extra delay on use
#define NOSHIELD 32			// weapon not affected by shield
#define CONDUCT 64			// conducts electricity (metal etc.)
// 96 - unused
#define ONBELT 128			// can be put in belt slot
#define FPRINT 256			// takes a fingerprint
#define ON_BORDER 512		// item has priority to check when entering or leaving
// 1024 - unused
// 2048	- unused
#define OPENCONTAINER	4096	// is an open container for chemistry purposes
#define ISADVENTURE 8192        // is an atom spawned in an adventure area
#define NOSPLASH 16384  		//No beaker etc. splashing. For Chem machines etc.
#define SUPPRESSATTACK 32768 	//No attack message when hitting stuff with this item.
// 65535 - unused

// bitflags for clothing parts
#define HEAD			1
#define TORSO			2
#define LEGS			4
#define ARMS			8

// other clothing-specific bitflags, applied via the c_flags var
#define SPACEWEAR 1				// combined HEADSPACE and SUITSPACE into this because seriously??
#define MASKINTERNALS 2			// mask allows internals
#define COVERSEYES 4			// combined COVERSEYES, COVERSEYES and COVERSEYES into this
#define COVERSMOUTH 8			// combined COVERSMOUTH and COVERSMOUTH into this.
#define ONESIZEFITSALL 16		// can be worn by fatties (or children? ugh)
#define NOSLIP 32				// for galoshes/magic sandals/etc that prevent slipping on things

// channel numbers for power

#define EQUIP 1
#define LIGHT 2
#define ENVIRON 3
#define TOTAL 4	//for total power used only

// bitflags for machine stat variable
#define BROKEN 1		// machine non-functional
#define NOPOWER 2		// no available power
#define POWEROFF 4		// machine shut down, but may still draw a trace amount
#define MAINT 8			// under maintainance
#define HIGHLOAD 16		// using a lot of power

#define ENGINE_EJECT_Z 3

// Radio (headset etc) colors.
#define RADIOC_STANDARD "#008000"
#define RADIOC_INTERCOM "#006080"
#define RADIOC_COMMAND "#334E6D"
#define RADIOC_SECURITY "#E00000"
//#define RADIOC_ENGINEERING "#D4A017"
#define RADIOC_ENGINEERING "#BD8F15"
#define RADIOC_MEDICAL "#461B7E"
#define RADIOC_RESEARCH "#153E7E"
#define RADIOC_CIVILIAN "#A10082"
#define RADIOC_SYNDICATE "#962121"
#define RADIOC_OTHER "#800080"

// Frequency defines for headsets & intercoms (Convair880).
#define R_FREQ_DEFAULT 1459
#define R_FREQ_COMMAND 1358
#define R_FREQ_SECURITY 1359
#define R_FREQ_ENGINEERING 1357
#define R_FREQ_RESEARCH 1354
#define R_FREQ_MEDICAL 1356
#define R_FREQ_CIVILIAN 1355
#define R_FREQ_SYNDICATE 1352 // Randomized for nuke rounds.
#define R_FREQ_GANG 1400 // Placeholder, it's actually randomized in gang rounds.
#define R_FREQ_MULTI 1451
#define R_FREQ_INTERCOM_COLOSSEUM 1403
#define R_FREQ_INTERCOM_MEDICAL 1445
#define R_FREQ_INTERCOM_SECURITY 1485
#define R_FREQ_INTERCOM_BRIG 1489
#define R_FREQ_INTERCOM_RESEARCH 1443
#define R_FREQ_INTERCOM_ENGINEERING 1441
#define R_FREQ_INTERCOM_CARGO 1455
#define R_FREQ_INTERCOM_CATERING 1485
#define R_FREQ_INTERCOM_AI 1447
#define R_FREQ_INTERCOM_BRIDGE 1442

// These are for the Syndicate headset randomizer proc.
#define R_FREQ_BLACKLIST_HEADSET list(R_FREQ_DEFAULT, R_FREQ_COMMAND, R_FREQ_SECURITY, R_FREQ_ENGINEERING, R_FREQ_RESEARCH, R_FREQ_MEDICAL, R_FREQ_CIVILIAN, R_FREQ_SYNDICATE, R_FREQ_GANG, R_FREQ_MULTI)
#define R_FREQ_BLACKLIST_INTERCOM list(R_FREQ_INTERCOM_COLOSSEUM, R_FREQ_INTERCOM_MEDICAL, R_FREQ_INTERCOM_SECURITY, R_FREQ_INTERCOM_BRIG, R_FREQ_INTERCOM_RESEARCH, R_FREQ_INTERCOM_ENGINEERING, R_FREQ_INTERCOM_CARGO, R_FREQ_INTERCOM_CATERING, R_FREQ_INTERCOM_AI, R_FREQ_INTERCOM_BRIDGE)

//   HOLIDAYS
//#define HALLOWEEN 1
//#define XMAS 1
//#define CANADADAY 1




var/const
	GAS_O2 = 1 << 0
	GAS_N2 = 1 << 1
	GAS_PL = 1 << 2
	GAS_CO2 = 1 << 3
	GAS_N2O = 1 << 4
	GAS_H2O = 1 << 5


// so that you can move things around easily, in theory
// before you use any of these, please make sure the HUD you are using them in is actually related to the ones they're used on,
// so that we dont move the human HUD around and half the robot HUD winds up being all over the place (again)
#define ui_belt "CENTER-4, SOUTH"
#define ui_storage1 "CENTER-3, SOUTH"
#define ui_storage2 "CENTER-2, SOUTH"
#define ui_back "CENTER-1, SOUTH"
#define ui_lhand "CENTER, SOUTH"
#define ui_rhand "CENTER+1, SOUTH"
#define ui_shoes "CENTER-5, SOUTH+1"
#define ui_gloves "CENTER-4, SOUTH+1"
#define ui_id "CENTER-3, SOUTH+1"
#define ui_clothing "CENTER-2, SOUTH+1"
#define ui_suit "CENTER-1, SOUTH+1"
#define ui_glasses "CENTER, SOUTH+1"
#define ui_ears "CENTER+1, SOUTH+1"
#define ui_mask "CENTER+2, SOUTH+1"
#define ui_head "CENTER+3, SOUTH+1"

#define ui_oxygen "EAST-3, NORTH"
#define ui_toxin "EAST-5, NORTH"
#define ui_internal "EAST, NORTH-1"
#define ui_fire "EAST-4, NORTH"
#define ui_rad "EAST-6, NORTH"
#define ui_temp "EAST-2, NORTH"
#define ui_health "EAST, NORTH"
#define ui_stamina "EAST-1, NORTH"
#define ui_pull "SOUTH,14"

#define ui_acti "SOUTH,11"
#define ui_movi "SOUTH,13"

#define ui_module "SOUTH-1,6"
#define ui_botradio "SOUTH-1,7"
#define ui_bothealth "EAST+1, NORTH"
#define ui_boto2 "EAST+1, NORTH-2"
#define ui_botfire "EAST+1, NORTH-3"
#define ui_bottemp "EAST+1, NORTH-4"
#define ui_cell "EAST+1, NORTH-6"
#define ui_botpull "SOUTH-1,14"
#define ui_botstore "SOUTH-1,4"
#define ui_panel "SOUTH-1,5"

#define ui_iarrowleft "SOUTH-1,11"
#define ui_iarrowright "SOUTH-1,13"
#define ui_zone_select "SOUTH,12"

#define ui_inv1 "SOUTH-1,1"
#define ui_inv2 "SOUTH-1,2"
#define ui_inv3 "SOUTH-1,3"

/*
//TESTING A LAYOUT
#define ui_mask "SOUTH-1:-14,1:7"
#define ui_headset "SOUTH-2:-14,1:7"
#define ui_head "SOUTH-1:-14,1:51"
#define ui_glasses "SOUTH-1:-14,2:51"
#define ui_ears "SOUTH-1:-14,3:51"
#define ui_oclothing "SOUTH-1:-49,1:51"
#define ui_iclothing "SOUTH-2:-49,1:51"
#define ui_shoes "SOUTH-3:-49,1:51"
#define ui_back "SOUTH-1:-49,2:51"
#define ui_lhand "SOUTH-2:-49,2:51"
#define ui_rhand "SOUTH-2:-49,0:51"
#define ui_gloves "SOUTH-3:-49,0:51"
#define ui_belt "SOUTH-2:-49,1:127"
#define ui_id "SOUTH-2:-49,2:127"
#define ui_storage1 "SOUTH-3:-49,1:127"
#define ui_storage2 "SOUTH-3:-49,2:127"

#define ui_dropbutton "SOUTH-3,12"
#define ui_swapbutton "SOUTH-1,13"
#define ui_resist "SOUTH-3,14"
#define ui_throw "SOUTH-3,15"
#define ui_oxygen "EAST+1, NORTH-4"
#define ui_toxin "EAST+1, NORTH-6"
#define ui_internal "EAST+1, NORTH-2"
#define ui_fire "EAST+1, NORTH-8"
#define ui_temp "EAST+1, NORTH-10"
#define ui_health "EAST+1, NORTH-11"
#define ui_pull "WEST+6,SOUTH-2"
#define ui_hand "SOUTH-1,6"
#define ui_sleep "EAST+1, NORTH-13"
#define ui_rest "EAST+1, NORTH-14"
//TESTING A LAYOUT
*/

// gameticker
#define GAME_STATE_PREGAME		1
#define GAME_STATE_SETTING_UP	2
#define GAME_STATE_PLAYING		3
#define GAME_STATE_FINISHED		4

//States for airlock_control
#define ACCESS_STATE_INTERNAL	-1
#define ACCESS_STATE_LOCKED		0
#define ACCESS_STATE_EXTERNAL	1

#define AIRLOCK_STATE_INOPEN		-2
#define AIRLOCK_STATE_PRESSURIZE	-1
#define AIRLOCK_STATE_CLOSED		0
#define AIRLOCK_STATE_DEPRESSURIZE	1
#define AIRLOCK_STATE_OUTOPEN		2

#define AIRLOCK_CONTROL_RANGE 5

#define DATALOGGER

#define CREW_OBJECTIVES

#define MISCREANTS

//mob intent type defines
#define INTENT_HARM "harm"
#define INTENT_DISARM "disarm"
#define INTENT_HELP "help"
#define INTENT_GRAB "grab"

//#define RESTART_WHEN_ALL_DEAD 1

//#define PLAYSOUND_LIMITER

//Projectile damage type defines
#define D_KINETIC 1
#define D_PIERCING 2
#define D_SLASHING 4
#define D_ENERGY 8
#define D_BURNING 16
#define D_RADIOACTIVE 32
#define D_TOXIC 48
#define D_SPECIAL 128
/*
#define D_KINETIC 1
#define D_PIERCING 2
#define D_SLASHING 3
#define D_ENERGY 4
#define D_BURNING 5
#define D_RADIOACTIVE 6
#define D_TOXIC 7
#define D_SPECIAL 8
*/
//Missing limb flags
#define LIMB_LEFT_ARM 1
#define LIMB_RIGHT_ARM 2
#define LIMB_LEFT_LEG 4
#define LIMB_RIGHT_LEG 8

// see in dark levels
#define SEE_DARK_FULL 8
#define SEE_DARK_HUMAN 3

//stamina config
#define STAMINA_MAX 200        			//Default max stamina value
#define STAMINA_REGEN 10   	   		 	//Default stamina regeneration rate.
#define STAMINA_ITEM_DMG 20     		//Default stamina damage objects do.
#define STAMINA_ITEM_COST 20    		//Default attack cost on user for attacking with items.
#define STAMINA_HTH_DMG 40      		//Default hand-to-hand (punch, kick) stamina damage.
#define STAMINA_HTH_COST 20     		//Default hand-to-hand (punch, kick) stamina cost
#define STAMINA_MIN_ATTACK 50   		//The minimum amount of stamina required to attack.
#define STAMINA_NEG_CAP -75     		//How far into the negative we can take stamina. (People will be stunned while stamina regens up to > 0 - so this can lead to long stuns if set too high)
#define STAMINA_STUN_TIME 8     		//How long we will be stunned for, for being <= 0 stamina
#define STAMINA_GRAB_COST 25    		//How much grabbing someone costs.
#define STAMINA_DISARM_COST 5   		//How much disarming someone costs.
#define STAMINA_FLIP_COST 25    		//How much flipping / suplexing costs.
#define STAMINA_CRIT_CHANCE 25  		//Base chance of landing a critical hit to stamina.
#define STAMINA_CRIT_DIVISOR 2  		//Divide stamina by how much on a crit
#define STAMINA_BLOCK_CHANCE 40 		//Chance to block an attack in disarm mode. Settings this to 0 effectively disables the blocking system.
#define STAMINA_GRAB_BLOCK_CHANCE 85    //Chance to block grabs.
#define STAMINA_DEFAULT_BLOCK_COST 7    //Cost of blocking an attack.
#define STAMINA_LOW_COST_KICK 1 	    //Does kicking people on the ground cost less stamina ? (Right now it doesnt cost less but rather refunds some because kicking people on the ground is very relaxing OKAY)
#define STAMINA_NO_ATTACK_CAP 1 		//Attacks only cost stamina up to the min atttack cap. after that they are free
#define STAMINA_NEG_CRIT_KNOCKOUT 1     //Getting crit below or at 0 stamina will always knock out
#define STAMINA_WINDED_SPEAK_MIN 0      //Can't speak below this point.

//This is a bad solution. Optimally this should scale.
#define STAMINA_MIN_WEIGHT_CLASS 2 	    //Minimum weightclass (w_class) of an item that allows for knock-outs and critical hits.

//This is the last resort option for the RNG lovers.
#define STAMINA_STUN_ON_CRIT 0          //Getting crit stuns the affected person for a short moment?
#define STAMINA_STUN_ON_CRIT_SEV 2      //How long people get stunned on crits

#define STAMINA_CRIT_DROP 1	    	    //If 1, stamina crits will instantly set a targets stamina to the number set below instead of dividing it by a number.
#define STAMINA_CRIT_DROP_NUM 1			//Amount of stamina to drop to on a crit.
////////////////////////////////////////////////////

#define STAMINA_SCALING_KNOCKOUT_BASE 20   //Base chance at 0 stamina to be knocked out by an attack - scales up the lower stamina goes.
#define STAMINA_SCALING_KNOCKOUT_SCALER 60 //Up to which *additional* value the chance will scale with lower stamina nearly the negative cap

#define STAMINA_EXHAUSTED_STR "<p style=\"color:red;font-weight:bold;\">You are too exhausted to attack.</p>" //The message tired people get when they try to attack.

#define STAMINA_DEFAULT_FART_COST 0  //How much farting costs. I am not even kidding.

//reagent_container bit flags
#define RC_SCALE 	1		// has a graduated scale, so total reagent volume can be read directly (e.g. beaker)
#define RC_VISIBLE	2		// reagent is visible inside, so color can be described
#define RC_FULLNESS 4		// can estimate fullness of container
#define RC_SPECTRO	8		// spectroscopic glasses can analyse contents

// blood system and item damage things
#define DAMAGE_BLUNT 1
#define DAMAGE_CUT 2
#define DAMAGE_STAB 4
#define DAMAGE_BURN 8					// a) this is an excellent idea and b) why do we still use damtype strings then
#define DAMAGE_CRUSH 16					// crushing damage is technically blunt damage, but it causes bleeding
#define DEFAULT_BLOOD_COLOR "#990000"	// speak for yourself, as a shapeshifting illuminati lizard, my blood is somewhere between lime and leaf green

// Process Scheduler defines
// Process status defines
#define PROCESS_STATUS_IDLE 1
#define PROCESS_STATUS_QUEUED 2
#define PROCESS_STATUS_RUNNING 3
#define PROCESS_STATUS_MAYBE_HUNG 4
#define PROCESS_STATUS_PROBABLY_HUNG 5
#define PROCESS_STATUS_HUNG 6

// Process time thresholds
#define PROCESS_DEFAULT_HANG_WARNING_TIME 	300 // 30 seconds
#define PROCESS_DEFAULT_HANG_ALERT_TIME 	600 // 60 seconds
#define PROCESS_DEFAULT_HANG_RESTART_TIME 	900 // 90 seconds
#define PROCESS_DEFAULT_SCHEDULE_INTERVAL 	50  // 50 ticks
#define PROCESS_DEFAULT_SLEEP_INTERVAL		2	// 2 ticks
#define PROCESS_DEFAULT_CPU_THRESHOLD		90  // 90%

/** Delete queue defines */
#define MIN_DELETE_CHUNK_SIZE 20

// attack message flags
#define SUPPRESS_BASE_MESSAGE 1
#define SUPPRESS_SOUND 2
#define SUPPRESS_VISIBLE_MESSAGES 4
#define SUPPRESS_SHOWN_MESSAGES 8
#define SUPPRESS_LOGS 16
// used by limbs which make a special kind of melee attack happen
#define SUPPRESS_MELEE_LIMB 15

//I feel like these should be a thing, ok
#define true 1
#define false 0

//How much stuff is allowed in the pools before the lifeguard throws them into the deletequeue instead. A shameful lifeguard.
#define DEFAULT_POOL_SIZE 50
//#define DETAILED_POOL_STATS

#define CDN_ENABLED 1

#define LOOC_RANGE 8
