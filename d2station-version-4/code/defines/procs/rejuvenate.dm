/mob/proc/rejuvenate()
	mobz -= src
	mobz += src
	if (istype(src, /mob/dead/observer))
		return
	emote_allowed = 1
	sdisabilities = 0
	disabilities = 0
	stat = 0
	eye_blind = null
	eye_blurry = null
	ear_deaf = null
	ear_damage = null
	stuttering = null
	blinded = null
	bhunger = 0
	druggy = 0
	confused = 0
	antitoxs = null
	plasma = null
	sleeping = 0
	resting = 0
	lying = 0
	canmove = 1.0
	eye_stat = null
	oxyloss = 0
	toxloss = 0
	fireloss = 0
	bruteloss = 0
	timeofdeath = 0
	cpr_time = 1.0
	emotetime = 0
	chattime = 0
	health = 100
	bodytemperature = 310.55
	immunetoflaming = 0
	flaming = 0
	frozen = 0
	drowsyness = 0
	dizziness = 0
	is_dizzy = 0
	is_jittery = 0
	jitteriness = 0
	nutrition = 400
	overeatduration = 0
	paralysis = 0
	stunned = 0
	weakened = 0
	losebreath = 0
	shakecamera = 0
	turnedon = 0
	moaning = 0
	panicing = 0
	brainloss = 0
	dna = null
	radiation = 0
	addictions = list()
	brains = 100
	bleeding = 0
	blood = 300
	bloodthickness = 5
	systolic = 100
	diastolic = 70
	circ_pressure_mod = 0
	thrombosis = 0
	thrombosis_severity = 0
	blood_clot = 5
	bloodstopper = 0
	headbloodloss = 0
	l_handbloodloss = 0
	r_handbloodloss = 0
	l_armbloodloss = 0
	r_armbloodloss = 0
	l_footbloodloss = 0
	r_footbloodloss = 0
	l_legbloodloss = 0
	r_legbloodloss = 0
	butt_op_stage = 0
	penis_op_stage = 0
	buckled = initial(buckled)
	handcuffed = initial(handcuffed)
	cloneloss = 0
	arrhythmia = 0
	heartrate = 80
	silent = 0
	bloodloss = 0
	blinded = 0
	if(istype(src, /mob/living/carbon/human))
		var/mob/living/carbon/human/V = src
		for(var/datum/disease/D in V.viruses)
			D.cure()
		for(var/datum/reagent/R in V.reagents.reagent_list)
			V.reagents.del_reagent(R)
		V.organ_manager.head = 1
		V.organ_manager.l_hand = 1
		V.organ_manager.r_hand = 1
		V.organ_manager.l_arm = 1
		V.organ_manager.r_arm = 1
		V.organ_manager.l_foot = 1
		V.organ_manager.r_foot = 1
		V.organ_manager.l_leg = 1
		V.organ_manager.r_leg = 1
		V:heal_overall_damage(1000, 1000)
		V.update_body()
		V.update_face()
		V.update_clothing()
		if(V.r_hand)
			V.r_hand.clean_blood()
		if(V.l_hand)
			V.l_hand.clean_blood()
	if (stat > 1)
		stat=0
	if (src && src.client)
		src:heal_overall_damage(1000, 1000)
	..()