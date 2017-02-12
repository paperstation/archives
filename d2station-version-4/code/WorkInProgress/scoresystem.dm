// these global variables are placed in global.dm
// these should be added to relevant places within the code such as the chef cooking something would increment the
// meals score thing
var/
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

	// these ones are mainly for the stat panel
	score_powerbonus = 0 // if all APCs on the station are running optimally, big bonus
	score_messbonus = 0 // if there are no messes on the station anywhere, huge bonus
	score_deadaipenalty = 0 // is the AI dead? if so, big penalty

	score_foodeaten = 0 // nom nom nom
	score_cigssmoked = 0 //puff
	score_clownabuse = 0 // how many times a clown was punched, struck or otherwise maligned

	score_richestname = null // this is all stuff to show who was the richest alive on the shuttle
	score_richestjob = null  // kinda pointless if you dont have a money system i guess
	score_richestcash = 0
	score_richestkey = null

	score_dmgestname = null // who had the most damage on the shuttle (but was still alive)
	score_dmgestjob = null
	score_dmgestdamage = 0
	score_dmgestkey = null



// and afaik this can go anywhere but I have it at the end of gameticker.dm
