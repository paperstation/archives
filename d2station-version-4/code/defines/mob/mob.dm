var/global/clientkey = "a"
/mob
	density = 1
	layer = 4.0
	animate_movement = 2
	flags
	var/datum/mind/mind
	var/list/lum_list = list()
	var/archived_lum = 0
	var/uses_hud = 0
	var/obj/screen/flash = null
	var/obj/screen/blind = null
	var/obj/screen/hands = null
	var/obj/screen/mach = null
	var/obj/screen/sleep = null
	var/obj/screen/rest = null
	var/obj/screen/pullin = null
	var/obj/screen/internals = null
	var/obj/screen/oxygen = null
	var/obj/screen/i_select = null
	var/obj/screen/m_select = null
	var/obj/screen/toxin = null
	var/obj/screen/fire = null
	var/obj/screen/bodytemp = null
	var/obj/screen/viewmind = null
	var/obj/screen/healths = null
	var/obj/screen/throw_icon = null
	var/obj/screen/nutrition_icon = null
	var/authenticsec = 0
	var/cangoldemote = 0
	// var/list/obj/hallucination/hallucinations = list() - Not used at all - Skie

	/*A bunch of this stuff really needs to go under their own defines instead of being globally attached to mob.
	A variable should only be globally attached to turfs/objects/whatever, when it is in fact needed as such.
	The current method unnecessarily clusters up the variable list, especially for humans (although rearranging won't really clean it up a lot but the difference will be noticable for other mobs).
	I'll make some notes on where certain variable defines should probably go.
	Changing this around would probably require a good look-over the pre-existing code.
	*/
	var/alien_egg_flag = 0//Have you been infected?
	var/last_special = 0
	var/obj/screen/zone_sel/zone_sel = null

	var/emote_allowed = 1
	var/computer_id = null
	var/lastattacker = null
	var/lastattacked = null
	var/attack_log = list( )
	var/already_placed = 0.0
	var/obj/machinery/machine = null
	var/other_mobs = null
	var/memory = ""
	var/poll_answer = 0.0
	var/sdisabilities = 0//Carbon
	var/disabilities = 0//Carbon
	var/atom/movable/pulling = null
	var/stat = 0.0
	var/next_move = null
	var/prev_move = null
	var/monkeyizing = null//Carbon
	var/other = 0.0
	var/hand = null
	var/eye_blind = null//Carbon
	var/eye_blurry = null//Carbon
	var/ear_deaf = null//Carbon
	var/ear_damage = null//Carbon
	var/stuttering = null//Carbon
	var/real_name = null
	var/blinded = null
	var/bhunger = 0//Carbon
	var/ajourn = 0
	var/clownattacked = 0
	var/endgamemodifier = 0
	var/rejuv = null
	var/druggy = 0//Carbon
	var/confused = 0//Carbon
	var/antitoxs = null
	var/plasma = null
	var/sleeping = 0.0//Carbon
	var/resting = 0.0//Carbon
	var/lying = 0.0
	var/canmove = 1.0
	var/eye_stat = null//Living, potentially Carbon
	var/oxyloss = 0.0//Living
	var/toxloss = 0.0//Living
	var/fireloss = 0.0//Living
	var/bruteloss = 0.0//Living
	var/timeofdeath = 0.0//Living
	var/cpr_time = 1.0//Carbon
	var/emotetime = 0
	var/chattime = 0
	var/health = 100//Living
	var/bodytemperature = 310.055	//98.7 F or 36.905 C

	var/immunetoflaming = 0
	var/flaming = 0.0				//On fire
	var/debugfireprot

	var/drowsyness = 0.0//Carbon
	var/dizziness = 0//Carbon
	var/is_dizzy = 0
	var/is_jittery = 0
	var/jitteriness = 0//Carbon
	var/infinitebutt = 0
	var/homosexual = 0
	var/charges = 0.0
	var/nutrition = 400.0//Carbon
	var/overeatduration = 0		// How long this guy is overeating //Carbon
	var/buddha = 0 //source engine --ds
	var/frozen = 0.0
	var/paralysis = 0.0
	var/stunned = 0.0
	var/weakened = 0.0
	var/deathhealing = 0
	var/losebreath = 0.0//Carbon
	var/metabslow = 0	// Metabolism slowed//Carbon
	var/intent = null//Living
	var/shakecamera = 0
	var/a_intent = "help"//Living
	var/m_int = null//Living
	var/m_intent = "run"//Living
	var/lastDblClick = 0
	var/lastKnownIP = null
	var/obj/stool/buckled = null//Living
	var/obj/item/weapon/handcuffs/handcuffed = null//Living
	var/obj/item/l_hand = null//Living
	var/obj/item/r_hand = null//Living
	var/obj/item/weapon/back = null//Human/Monkey
	var/obj/item/weapon/tank/internal = null//Human/Monkey
	var/obj/item/weapon/storage/s_active = null//Carbon
	var/obj/item/clothing/mask/wear_mask = null//Carbon
	var/r_epil = 0
	var/r_ch_cou = 0
	var/r_Tourette = 0//Carbon
	var/cloneloss = 0//Carbon
	var/nicotineaddiction = 0
	var/nicsmoketime = 0
	var/seer = 0 //for cult//Carbon, probably Human

	var/miming = null //checks if the guy is a mime//Human
	var/silent = null //Can't talk. Value goes down every life proc.//Human

	var/obj/hud/hud_used = null

	//var/list/organs = list(  ) //moved to human.
	var/list/grabbed_by = list(  )
	var/list/requests = list(  )

	var/list/mapobjs = list()

	var/in_throw_mode = 0

	var/coughedtime = null

	var/inertia_dir = 0
	var/footstep = 1

	var/music_lastplayed = "null"

	var/job = null				//Living

	var/knowledge = 0.0

	var/nodamage = 0			// Godmode against tempurature and gasses
	var/logged_in = 0

	var/turnedon = 0
	var/moaning = 0
	var/panicing = 0

	var/underwear = 1			//Human
	var/be_syndicate = 0		//This really should be a client variable.
	var/be_random_name = 0
	var/const/blindness = 1		//Carbon
	var/const/deafness = 2		//Carbon
	var/const/muteness = 4		//Carbon
	var/brainloss = 0			//Carbon

	var/datum/dna/dna = null	//Carbon
	var/radiation = 0.0			//Carbon

	var/datum/reagent/addictions = list( ) // Reagent addictions

	/*var/circulatory_pressure = 300 // A tie-in with Emily's blood stuff, but used for blood pressure and effects thereof
	var/normal_circ_pressure = 300
	var/pressure_warn_timer = 10*/

/////////////
//////zombie food
/////////
	var/brains = 100

////////////////////////Blood vars these are for Emyylii's blood mod
//
//
// Bleeding is for attacks that cut or viruses that cause bleeding
// 1 is light bleeding , 2 is medium, 3 is heavy
// blood is the level of blood the human mob has
// bloodloss is an automatic conversion of the blood you've lost into a
// game friendly '****loss' var that can be used to calculate health
// bear in mind people don't usually live to have 0 blood, and so once their
// blood drops below 75% they will start suffering oxyloss and bruteloss
// if a person has over 80 health their blood is regenerated (not if bleeding
// is set to anything other than 0)  Enjoy hope you find a use for it.
// also added a bloodstopper var that when activated will totally prevent bleeding
// it does not cancel the level of bloodloss or change the bleeding value.
	//internal fuction

	var/bleeding = 0

	//blood level 300 normal < 200 usually death and above 450 = gib
	var/blood = 300

	//internal fuction
	var/bloodloss = 0
	var/bloodcalculation1 = 0
	var/totalbloodloss = 0
	var/countdown = 0
	//used in deciding how fast people bleed 5 is normal, an increase
	//increases the thickness making people bleed slower, above 8 starts
	//doing oxy and brute damage slowly
	//and below 5 increases the amount of bloodloss quite fast

	var/bloodthickness = 5

	//Bloodpressure
	//Diastolic doesn't have any effect but is just there for IMMERSION.
	//Hypertension can result in a heart attack

	var/systolic = 100
	var/diastolic = 70
	var/circ_pressure_mod = 0

	//Heartrate
	//Value depends on a multitude of factors.
	//The value itself has an effect on the blood pressure.
	//If this is lower than 60,
	//If this is 0, SEVERE oxyloss and brainloss happen.

	var/heartrate = 80

	//Arrhythmia
	//Can be caused by genetic traits and outside influences.
	//Every sort of arrhythmia is different
	//1 - Asystole: Inevitable death.
	//2 - Pulseless electrical activity: Results in heavy damage, asystole usually follows if not treated.
	//3 - Ventricular Fibrillation: Results in heavy damage, asystole usually follows if not treated.

	var/arrhythmia = 0

	//Thrombosis
	//When you get thrombosis, it rolls for which type.
	//1 - Peripheral(leg) - 20%
	//2 - Peripheral(arm) - 20%
	//3 - Pulmonary Embolism - 25%
	//4 - Cerebrovascular Accident(Stroke) - 20%
	//5 - Myocardial Infarction - 15%
	//Severity can range from 0 to 4
	//0 is no thrombus, 4 is full blockage.

	var/thrombosis = 0
	var/thrombosis_severity = 0

	//Used in deciding how fast and if bleeding heals.
	//Higher than 7 brings a risk of thrombosis.

	var/blood_clot = 5

	//Temporarily stops all bleeding, DO NOT LEAVE THIS SET TO 1

	var/bloodstopper = 0


//// from now on these values may be used.

	var/headbloodloss = 0
	var/l_handbloodloss = 0
	var/r_handbloodloss = 0
	var/l_armbloodloss = 0
	var/r_armbloodloss = 0
	var/l_footbloodloss = 0
	var/r_footbloodloss = 0
	var/l_legbloodloss = 0
	var/r_legbloodloss = 0


////////////////////////////////////////////////////////
//////    Ailments framework
///////////////////////////////////////////////////////
	var/ailment = list()

////////////////////////////////////////////////////////
//// Ailments end
///////////////////////////////////////////////////////
	var/mutations = 0//Carbon
	//telekinesis = 1
	//firemut = 2
	//xray = 4
	//polymorphic = 5
	//hulk = 8
	//clumsy = 16
	//obese = 32
	//husk = 64
	var/Psionic_power
	var/expandedmind = 0
	var/voice_name = "unidentifiable voice"
	var/voice_message = null // When you are not understood by others (replaced with just screeches, hisses, chimpers etc.)
	var/say_message = null // When you are understood by others. Currently only used by aliens and monkeys in their say_quote procs

//Generic list for proc holders. Only way I can see to enable certain verbs/procs. Should be modified if needed.
	var/proc_holder_list[] = list()//Right now unused.
	//Also unlike the spell list, this would only store the object in contents, not an object in itself.

	/* Add this line to whatever stat module you need in order to use the proc holder list.
	Unlike the object spell system, it's also possible to attach verb procs from these objects to right-click menus.
	This requires creating a verb for the object proc holder.

	if (proc_holder_list.len)//Generic list for proc_holder objects.
		for(var/obj/proc_holder/P in proc_holder_list)
			statpanel("[P.panel]","",P)
	*/

//The last mob/living/carbon to push/drag/grab this mob (mostly used by Metroids friend recognition)
	var/mob/living/carbon/LAssailant = null

//Wizard mode, but can be used in other modes thanks to the brand new "Give Spell" badmin button
	var/obj/proc_holder/spell/list/spell_list = list()

//List of active diseases

	var/list/viruses = list() // replaces var/datum/disease/virus

//Monkey/infected mode
	var/list/resistances = list()
	var/datum/disease/virus = null

	mouse_drag_pointer = MOUSE_ACTIVE_POINTER

//Changeling mode stuff//Carbon
	var/changeling_level = 0
	var/list/absorbed_dna = list()
	var/changeling_fakedeath = 0
	var/chem_charges = 20.00
	var/sting_range = 1




//junk
	var/butt_op_stage
	var/penis_op_stage
	var/obj/item/clothing/under/w_uniform = null
	var/obj/item/clothing/ears/ears = null


	var/universal_speak = 0 // Set to 1 to enable the mob to speak to everyone -- TLE
	var/obj/control_object // Hacking in to control objects -- TLE

	var/robot_talk_understand = 0
	var/alien_talk_understand = 0

/*For ninjas and others. This variable is checked when a mob moves and I guess it was supposed to allow the mob to move
through dense areas, such as walls. Setting density to 0 does the same thing. The difference here is that
the mob is also allowed to move without any sort of restriction. For instance, in space or out of holder objects.*/
//0 is off, 1 is normal, 2 is for ninjas.
	var/incorporeal_move = 0


	var/update_icon = 1 // Set to 0 if you want that the mob's icon doesn't update when it moves -- Skie
						// This can be used if you want to change the icon on the fly and want it to stay

	var/UI = 'screen1_old.dmi' // For changing the UI from preferences

	var/obj/organstructure/organStructure = null //for dem organs


/mob/New()
	mobz -= src
	mobz += src
	..()