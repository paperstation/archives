/datum/disease/mutation
	name = "proof of concept"
	max_stages = 4
	spread = "On contact"
	spread_type = CONTACT_GENERAL
	cure = "Spaceacillin and Alkysine"
	cure_id = list("alkysine","spaceacillin")
	affected_species = list("Human")
	curable = 0
	cure_chance = 15//higher chance to cure, since two reagents are required
	desc = "This disease destroys the braincells, causing brain fever, brain necrosis and general intoxication."
	severity = "Major"
	var/dead = 0
	mutated = 1

	proc/makerandom()
		var/datum/disease/effectholder/holder = new /datum/disease/effectholder
		holder.stage = 1
		holder.getrandomeffect()
		effects += holder
		holder = new /datum/disease/effectholder
		holder.stage = 2
		holder.getrandomeffect()
		effects += holder
		holder = new /datum/disease/effectholder
		holder.stage = 3
		holder.getrandomeffect()
		effects += holder
		holder = new /datum/disease/effectholder
		holder.stage = 4
		holder.getrandomeffect()
		effects += holder
		uniqueID = rand(0,10000)
		spread_type = "Airborne"
		world << "make random called"

	proc/minormutate()
		var/datum/disease/effectholder/holder = pick(effects)
		holder.minormutate()


	proc/majormutate()
		var/datum/disease/effectholder/holder = pick(effects)
		holder.majormutate()


/datum/disease/mutation/stage_act()
	..()
	var/mob/living/carbon/human/D = affected_mob
	world << "Stage act called inside [D.name]"
	for(var/datum/disease/effectholder/e in effects)
		e.runeffect(D,stage)


/datum/disease/effectholder
	name = "Holder"
	var/datum/disease/effect/effect
	chance = 1 //Chance in percentage each tick
	cure = "" //Type of cure it requires
	happensonce = 0
	multiplier = 1 //The chance the effects are WORSE
	stage = 0

	proc/runeffect(var/mob/living/carbon/human/mob,var/stage)
		if(happensonce > -1 && effect.stage <= stage && prob(chance))
			effect.activate(mob)
			if(happensonce == 1)
				happensonce = -1

	proc/getrandomeffect()
		var/list/datum/disease/effect/list = list()
		for(var/e in (typesof(/datum/disease/effect) - /datum/disease/effect))
		//	world << "Making [e]"
			var/datum/disease/effect/f = new e
			if(f.stage == src.stage)
				list += f
		var/datum/disease/effect/type = pick(list)
		var/saved_type = "[type]"
		world << "[type] << type is"
		effect = text2path(saved_type)
		world << "choosing [effect.name]"
		chance = rand(1,6)

	proc/minormutate()
		switch(pick(1,2,3,4,5))
			if(1)
				chance = rand(0,100)
			if(2)
				multiplier = rand(1,effect.maxm)

	proc/majormutate()
		getrandomeffect()

/datum/disease/effect
	name = "Blanking effect"
	stage = 4
	var/maxm = 1
	proc/activate(var/mob/living/carbon/mob,var/multiplier)

/datum/disease/effect/gibbingtons
	name = "Gibbingtons Syndrome"
	stage = 4
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.gib()
		world << "effect"
/datum/disease/effect/radian
	name = "Radian's syndrome"
	stage = 4
	maxm = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.radiation += (2*multiplier)
		world << "effect"
/datum/disease/effect/toxins
	name = "Hyperacid Syndrome"
	stage = 3
	maxm = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.toxloss += (2*multiplier)
		world << "effect"
/datum/disease/effect/scream
	name = "Random screaming syndrome"
	stage = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.say("*scream")
		world << "effect"
/datum/disease/effect/drowsness
	name = "Automated sleeping syndrome"
	stage = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.drowsyness += 10
		world << "effect"
/datum/disease/effect/shakey
	name = "World Shaking syndrome"
	stage = 3
	maxm = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		shake_camera(mob,5*multiplier)
		world << "effect"
/datum/disease/effect/deaf
	name = "Hard of hearing syndrome"
	stage = 4
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.ear_deaf += 20
		world << "effect"
/datum/disease/effect/invisible
	name = "Waiting Syndrome"
	stage = 1
	activate(var/mob/living/carbon/mob,var/multiplier)
		world << "effect"
		return
/*
/datum/disease/effect/telepathic
	name = "Telepathy Syndrome"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.mutations |= 512
*/
/datum/disease/effect/noface
	name = "Identity Loss syndrome"
	stage = 4
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.real_name = "Unknown"
		world << "effect"
/datum/disease/effect/monkey
	name = "Monkism syndrome"
	stage = 4
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(istype(mob,/mob/living/carbon/human))
			var/mob/living/carbon/human/h = mob
			h.monkeyize()
		world << "effect"
/datum/disease/effect/sneeze
	name = "Coldingtons Effect"
	stage = 1
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.say("*sneeze")
		world << "effect"
/datum/disease/effect/gunck
	name = "Flemmingtons"
	stage = 1
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob << "\red Mucous runs down the back of your throat."
		world << "effect"
/datum/disease/effect/killertoxins
	name = "Toxification syndrome"
	stage = 4
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.toxloss += 15
		world << "effect"
/*
/datum/disease/effect/hallucinations
	name = "Hallucinational Syndrome"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.hallucination += 25
*/
/datum/disease/effect/sleepy
	name = "Resting syndrome"
	stage = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.say("*collapse")
		world << "effect"
/datum/disease/effect/mind
	name = "Lazy mind syndrome"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.brainloss = 50
		world << "effect"
/datum/disease/effect/suicide
	name = "Suicidal syndrome"
	stage = 4
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.suiciding = 1
		//instead of killing them instantly, just put them at -175 health and let 'em gasp for a while
		viewers(mob) << "\red <b>[mob.name] is holding \his breath. It looks like \he's trying to commit suicide.</b>"
		mob.oxyloss = max(175 - mob.toxloss - mob.fireloss - mob.bruteloss, mob.oxyloss)
		mob.updatehealth()
		world << "effect"
		spawn(200) //in case they get revived by cryo chamber or something stupid like that, let them suicide again in 20 seconds
			mob.suiciding = 0
