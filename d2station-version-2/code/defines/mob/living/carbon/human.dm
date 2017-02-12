/mob/living/carbon/human
	name = "human"
	real_name = "human"
	voice_name = "human"
	icon = 'mob.dmi'
	icon_state = "m-none"


	var/r_hair = 0.0
	var/g_hair = 0.0
	var/b_hair = 0.0
	var/h_style = "Short Hair"
	var/r_facial = 0.0
	var/g_facial = 0.0
	var/b_facial = 0.0
	var/f_style = "Shaved"
	var/r_eyes = 0.0
	var/g_eyes = 0.0
	var/b_eyes = 0.0
	var/s_tone = 0.0
//	var/rleg_s_tone = 0.0
//	var/lleg_s_tone = 0.0
//	var/rfoot_s_tone = 0.0
//	var/lfoot_s_tone = 0.0
//	var/rarm_s_tone = 0.0
//	var/larm_s_tone = 0.0
	var/age = 30.0
	var/b_type = "A+"

	var/obj/item/clothing/suit/wear_suit = null
	var/obj/item/clothing/under/w_uniform = null
//	var/obj/item/device/radio/w_radio = null
	var/obj/item/clothing/shoes/shoes = null
	var/obj/item/weapon/belt = null
	var/obj/item/clothing/gloves/gloves = null
	var/obj/item/clothing/glasses/glasses = null
	var/obj/item/clothing/head/head = null
	var/obj/item/clothing/ears/ears = null
	var/obj/item/weapon/card/id/wear_id = null
	var/obj/item/weapon/r_store = null
	var/obj/item/weapon/l_store = null
	var/obj/item/weapon/s_store = null
	var/obj/item/weapon/h_store = null

	var/smearedwithpoo = 0
	var/pickeduppoo = 0

	var/icon/stand_icon = null
	var/icon/lying_icon = null

	var/last_b_state = 1.0

	var/image/face_standing = null
	var/image/face_lying = null

	var/hair_icon_state = "hair_a"
	var/face_icon_state = "bald"

	var/list/body_standing = list()
	var/list/body_lying = list()

	var/mutantrace = null

/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	nodamage = 1

/mob/living/carbon/human/myke
	New()
		..()
		spawn(0)
			src.dna = new /datum/dna(null)
			src.gender = "male"
			src.real_name = "Myke"
			src.name = "Myke"

			src.equip_if_possible(new /obj/item/clothing/shoes/red(src), slot_shoes)

			src.equip_if_possible(new /obj/item/clothing/under/lightred(src), slot_w_uniform)

			src.equip_if_possible(new /obj/item/weapon/tank/anesthetic(src), slot_back)
			src.equip_if_possible(new /obj/item/clothing/mask/breath(src), slot_wear_mask)
			src.internal = src.back

		spawn(20)
		ai_init()

	Life()
		..()
		if(prob(1))
			src.say(pick("You guys wanna hear me play bass?", stutter("HUFFFF"), "I got my license suspended AGAIN", "I got fired from [pick("McDonald's", "Boston Market", "Wendy's", "Burger King", "Starbucks", "Menard's")]..."))

/mob/living/carbon/human/santa
	New()
		..()
		spawn(0)
			src.dna = new /datum/dna(null)
			src.gender = "male"
			src.name = "Santa Claus"
			src.real_name = "Santa Claus"
			r_hair = 220
			g_hair = 220
			b_hair = 220

			src.equip_if_possible(new /obj/item/clothing/shoes/boots(src), slot_shoes)

			src.equip_if_possible(new /obj/item/clothing/under/lightred(src), slot_w_uniform)

			src.equip_if_possible(new /obj/item/clothing/suit/space/santa(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/clothing/head/helmet/space/santahat(src), slot_head)
			src.equip_if_possible(new /obj/item/clothing/gloves/latex(src), slot_gloves)

	//		src.contract_disease(new /datum/disease/xmas_cheer)

		spawn(20)
		ai_init()

	Life()
		..()
		if(prob(2))
			src.say(pick("HO HO HO!", "Merry Christmas!"))


/mob/living/carbon/human/cosby
	New()
		..()
		spawn(0)
			r_hair = 100
			g_hair = 100
			b_hair = 100
			s_tone = -115
			h_style = "hair_c"
			gender = "male"
			name = "Bill Cosby"
			real_name = "Bill Cosby"
			src.dna = new /datum/dna(null)
			src.dna.ready_dna(src)
			src.dna.uni_identity = "02802802800000000000000000000240107B385"
			spawn(10)
				updateappearance(src, src.dna.uni_identity)


			src.update_body()

			src.equip_if_possible(new /obj/item/clothing/shoes/brown(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/under/cosby(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/weapon/reagent_containers/food/snacks/pudding_pop(src), slot_r_hand)
		spawn(20)
			ai_init()
	Life()
		..()
		if(prob(6) && src.stat != 2)
			for(var/mob/M in hearers(src))
				M << "\red <B>[src]</B> starts rambling incoherently!"
			playsound(src.loc, pick('cosby1.ogg', 'cosby2.ogg', 'cosby3.ogg', 'cosby4.ogg', 'cosby5.ogg'), 50, 1)

/mob/living/carbon/human/retard/New()
	..()
	spawn(0)
		src.dna = new /datum/dna(null)
		src.brainloss = 60
		src.r_hair = rand(1, 250)
		src.g_hair = rand(1, 250)
		src.b_hair = rand(1, 250)
		src.s_tone = rand(-115,100)
		src.h_style = pick("bald", "hair_a", "hair_b", "hair_c", "hair_d", "hair_e", "hair_f", "hair_afro", "hair_bieber", "hair_bedhead", "hair_dreads", "hair_rocker", "hair_femalemessy", "hair_long", "hair_pony", "hair_female_short", "hair_scene", "hair_girly")
		if(prob(60))
			src.gender = "male"
			src.name = capitalize("Special " + pick(first_names_male))
			src.real_name = capitalize("Special " + pick(first_names_male))
		else
			src.gender = "female"
			src.name = capitalize("Special " + pick(first_names_female))
			src.real_name = capitalize("Special " + pick(first_names_female))
		switch(pick(1,2,3,4,5))
			if(1)
				src.equip_if_possible(new /obj/item/clothing/shoes/clown_shoes(src), slot_shoes)
			if(2)
				src.equip_if_possible(new /obj/item/clothing/shoes/white(src), slot_shoes)
			if(3)
				src.equip_if_possible(new /obj/item/clothing/shoes/cock(src), slot_shoes)
			if(4)
				src.equip_if_possible(new /obj/item/clothing/shoes/orange(src), slot_shoes)

		switch(pick(1,2,3,4))
			if(1)
				src.equip_if_possible(new /obj/item/clothing/under/rainbow(src), slot_w_uniform)
			if(2)
				src.equip_if_possible(new /obj/item/clothing/under/color/pink(src), slot_w_uniform)
			if(3)
				src.equip_if_possible(new /obj/item/clothing/under/cloud(src), slot_w_uniform)

		switch(pick(1,2,3))
			if(2)
				src.equip_if_possible(new /obj/item/clothing/glasses/regular(src), slot_glasses)
			if(3)
				src.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(src), slot_glasses)

		src.equip_if_possible(new /obj/item/clothing/head/helmet/bikehelmet(src), slot_head)
//		src.equip_if_possible(new /obj/item/device/radio/headset(src), slot_w_radio)
		src.spawnId("[pick("CAPTIAN", "hed of speshul stuf", "monkie keepr", "sekurity ofiser")] (scribbled in crayon)")
	spawn(20)
		ai_init()

/mob/living/carbon/human/retard/violent/New()
	..()


/mob/living/carbon/human/retard/violent/armed/New()
	..()
	spawn(0)
		var/obj/item/weapon/gun/revolver/gun = new /obj/item/weapon/gun/revolver(src)
		gun.bullets = 7
		src.equip_if_possible(gun, src.slot_r_hand)

/mob/living/carbon/human/retard/violent/armed/bomb/New()
	..()
	spawn(0)
		var/obj/item/weapon/gun/revolver/gun = new /obj/item/weapon/gun/revolver(src)
		var/obj/spawner/bomb/suicide/bomb = new /obj/spawner/bomb/suicide(src)
		gun.bullets = 7
		src.equip_if_possible(gun, src.slot_r_hand)
		src.equip_if_possible(bomb, slot_wear_suit)


/mob/living/carbon/human/stationpersonnel/botanist
	New()
		..()
		spawn(0)
			src.dna = new /datum/dna(null)
		src.r_hair = rand(1, 250)
		src.g_hair = rand(1, 250)
		src.b_hair = rand(1, 250)
		if(prob(39))
			src.gender = "male"
			src.real_name = capitalize(pick(first_names_male) + " " + pick(last_names))
			src.h_style = pick("bald", "hair_a", "hair_c", "hair_d", "hair_e", "hair_f", "hair_bedhead", "hair_rocker", "hair_femalemessy", "hair_dreads", "hair_scene")
		else
			src.gender = "female"
			src.real_name = capitalize(pick(first_names_female) + " " + pick(last_names))
			src.h_style = pick("hair_b", "hair_long", "hair_pony", "hair_femalemessy", "hair_scene", "hair_girly")

		src.equip_if_possible(new /obj/item/clothing/under/rank/hydroponics(src), slot_w_uniform)
		src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)
		src.equip_if_possible(new /obj/item/clothing/gloves/botanic_leather(src), slot_gloves)
		src.equip_if_possible(new /obj/item/clothing/suit/apron(src), slot_wear_suit)

		spawn(20)
		ai_init()

	Life()
		..()
		if(prob(1))
			src.say(pick("Hrmmmm.."))