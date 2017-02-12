/datum/disease/startrekkin
	name = "Star Trekkin"
	max_stages = 5
	spread = "Contact" //ie shot bees
	agent = "Sci-Fi"
	affected_species = list("Human")
	affected_species2 = list(/mob/living/carbon/human)
	curable = 0
	var/sound/mysound = null
	var/sound/S = null
	why_so_serious = 4
	New()
		..()
		S = new/sound()
		mysound = S
		S.file = 'startrekkin.ogg'
		S.repeat = 1
		S.wait = 0
		S.channel = 123
		S.volume = 10
		S.priority = 255
		S.status = SOUND_UPDATE


/datum/disease/startrekkin/stage_act()
	..()
	var/mob/living/carbon/C = affected_mob
	switch(stage)
		if(1)
			affected_mob << mysound
			mysound.status = SOUND_UPDATE
		if(2)
			spawn_trekky_clothes()
			mysound.volume = 30
			mysound.status = SOUND_UPDATE
		if(3)
			spawn_trekky_clothes()
			mysound.volume = 60
			mysound.status = SOUND_UPDATE
		if(4)
			spawn_trekky_clothes()
			mysound.volume = 80
			mysound.status = SOUND_UPDATE
		if(5)
			spawn_trekky_clothes()
			mysound.volume = 100
			mysound.status = SOUND_UPDATE
			sleep(1200)
			mysound.repeat = 0
			mysound.volume = 0
			mysound.status = SOUND_PAUSED | SOUND_UPDATE
			spawn(10)
			C.gib()

/datum/disease/startrekkin/Del()
			S.repeat = 0
			S.volume = 0
			mysound.status = SOUND_PAUSED | SOUND_UPDATE
			mysound = null


/datum/disease/startrekkin/proc/spawn_trekky_clothes(var/chance=5)

	if(istype(affected_mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = affected_mob
		if(H.head)
			H.drop_from_slot(H.head)
		if(H.wear_suit)
			H.drop_from_slot(H.wear_suit)
		if(!istype(H.w_uniform, /obj/item/clothing/under/rank/startrek2))
			if(H.w_uniform)
				H.drop_from_slot(H.w_uniform)
			H.w_uniform = new /obj/item/clothing/under/rank/startrek2(H)
			H.w_uniform.layer = 20
	return
