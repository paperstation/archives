/mob/living/carbon/human
	name = "human"
	real_name = "human"
	voice_name = "human"
	icon = 'mob.dmi'
	icon_state = "m-none"
	var/prioritory = 7
	var/pincode = 0
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
	var/age = 14.88
	var/b_type = "O+" //while A+ is common, O+ is more common.
	var/obj/item/clothing/suit/wear_suit = null
//	var/obj/item/device/radio/w_radio = null
	var/obj/item/clothing/shoes/shoes = null
	var/obj/item/weapon/belt = null
	var/obj/item/clothing/gloves/gloves = null
	var/obj/item/clothing/glasses/glasses = null
	var/obj/item/clothing/head/head = null
	var/obj/item/weapon/card/id/wear_id = null
	var/obj/item/weapon/r_store = null
	var/obj/item/weapon/l_store = null
	var/obj/item/weapon/s_store = null
	var/obj/item/weapon/h_store = null
	var/icon/stand_icon = null
	var/icon/lying_icon = null
	var/list/mob/living/carbon/human/humansaround = list()
	var/last_b_state = 1.0

	var/image/face_standing = null
	var/image/face_lying = null

	var/hair_icon_state = "hair_a"
	var/flattened_hair_icon_state = "hair_a"
	var/face_icon_state = "bald"

	var/list/body_standing = list()
	var/list/body_lying = list()

	var/smearedwithpoo = 0
	var/pickeduppoo = 0
	var/mutantrace = null
//	var/lactoseintolerant = 0 - i'm going to add this to disabilities instead (in the year 3000) -snipe
	var/harmbatons = 0

	var/list/organs = list(  )
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
		if(prob(1) && stat != 2)
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

			src.equip_if_possible(new /obj/item/clothing/shoes/combat(src), slot_shoes)

			src.equip_if_possible(new /obj/item/clothing/under/lightred(src), slot_w_uniform)

			src.equip_if_possible(new /obj/item/clothing/suit/space/santa(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/clothing/head/helmet/space/santahat(src), slot_head)
			src.equip_if_possible(new /obj/item/clothing/gloves/latex(src), slot_gloves)

	//		src.contract_disease(new /datum/disease/xmas_cheer)

		spawn(20)
			ai_init()

	Life()
		..()
		if(prob(2) && stat != 2)
			src.say(pick("HO HO HO!", "Merry Christmas!"))

/mob/living/carbon/human/nasa
	New()
		..()
		spawn(0)
			src.dna = new /datum/dna(null)
			src.gender = "male"
			src.name = "Space Man"
			src.real_name = "Space Man"
			r_hair = 220
			g_hair = 220
			b_hair = 220

			src.equip_if_possible(new /obj/item/clothing/shoes/white(src), slot_shoes)

			src.equip_if_possible(new /obj/item/clothing/under/color/white(src), slot_w_uniform)

			src.equip_if_possible(new /obj/item/clothing/suit/space/(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/clothing/head/helmet/space/(src), slot_head)




		spawn(20)
			ai_init()

	Life()
		..()
		if(prob(2) && stat != 2)
			src.say(pick("aeiou", "John Madden!"))

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
		//	src.equip_if_possible(new /obj/item/weapon/reagent_containers/food/snacks/pudding_pop(src), slot_r_hand)
		spawn(20)
			ai_init()
	Life()
		..()
		if(prob(6) && src.stat != 2)
			for(var/mob/M in hearers(src))
				M << "\red <B>[src]</B> starts rambling incoherently!"
			playsound(src.loc, pick('cosby1.ogg', 'cosby2.ogg', 'cosby3.ogg', 'cosby4.ogg', 'cosby5.ogg'), 50, 1)

/mob/living/carbon/human/retard/New() //this is a generic mob, do not attempt to 'fix' them spawning naked or anything please. You'll fuck everything else up
	..()
	spawn(0)
		src.dna = new /datum/dna(null)
	//	src.brainloss = 60
	//	src.r_hair = rand(1, 250)
	//	src.g_hair = rand(1, 250)
	//	src.b_hair = rand(1, 250)
	//	src.s_tone = rand(-115,100)
	//	src.h_style = pick("bald", "hair_a", "hair_b", "hair_c", "hair_d", "hair_e", "hair_f", "hair_afro", "hair_bieber", "hair_bedhead", "hair_dreads", "hair_rocker", "hair_femalemessy", "hair_long", "hair_pony", "hair_female_short", "hair_scene", "hair_girly", "hair_messym", "hair_messyf")
	//	src.equip_if_possible(new /obj/item/clothing/under/cloud(src), slot_w_uniform)
		if(prob(60))
			src.gender = "male"

		else
			src.gender = "female"

	spawn(20)
		ai_init()
/mob/living/carbon/human/retardtame/New()
	..()
	spawn(0)
		src.dna = new /datum/dna(null)
	//	src.brainloss = 60
		src.r_hair = rand(1, 250)
		src.g_hair = rand(1, 250)
		src.b_hair = rand(1, 250)
		src.s_tone = rand(-115,100)
		src.h_style = pick("bald", "hair_a", "hair_b", "hair_c", "hair_d", "hair_e", "hair_f", "hair_afro", "hair_bieber", "hair_bedhead", "hair_dreads", "hair_rocker", "hair_femalemessy", "hair_long", "hair_pony", "hair_female_short", "hair_scene", "hair_girly", "hair_messym", "hair_messyf")
	//	src.equip_if_possible(new /obj/item/clothing/under/cloud(src), slot_w_uniform)
		if(prob(60))
			src.gender = "male"
			src.name = capitalize("Special " + pick(first_names_male))
			src.real_name = capitalize("Special " + pick(first_names_male))
		else
			src.gender = "female"
			src.name = capitalize("Special " + pick(first_names_female))
			src.real_name = capitalize("Special " + pick(first_names_female))
		switch(pick(1,2,3))
			if(1)
				src.equip_if_possible(new /obj/item/clothing/shoes/clown_shoes(src), slot_shoes)
			if(2)
				src.equip_if_possible(new /obj/item/clothing/shoes/white(src), slot_shoes)
			if(3)
				src.equip_if_possible(new /obj/item/clothing/shoes/orange(src), slot_shoes)

		switch(pick(1,2,3,4))
			if(1)
				src.equip_if_possible(new /obj/item/clothing/under/rainbow(src), slot_w_uniform)
			if(2)
				src.equip_if_possible(new /obj/item/clothing/under/color/pink(src), slot_w_uniform)
			if(3)
				src.equip_if_possible(new /obj/item/clothing/under/cloud(src), slot_w_uniform)
			if(4)
				src.equip_if_possible(new /obj/item/clothing/under/rank/sexyman(src), slot_w_uniform)

		switch(pick(1,2,3))
			if(2)
				src.equip_if_possible(new /obj/item/clothing/glasses/regular(src), slot_glasses)
			if(3)
				src.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(src), slot_glasses)

		src.equip_if_possible(new /obj/item/clothing/head/helmet/bikehelmet(src), slot_head)
		src.spawnId("[pick("CAPTIAN", "hed of speshul stuf", "monkie keepr", "sekurity ofiser")] (scribbled in crayon)")

	spawn(20)
		ai_init()

/mob/living/carbon/human/retard/violent/New()
	..()

/mob/living/carbon/human/retard/violent/bubba
	New()
		..()
		spawn(0)
			src.dna = new /datum/dna(null)
			src.gender = "male"
			src.name = "Bubba"
			src.real_name = "Bubba"
			r_hair = 100
			g_hair = 100
			b_hair = 100
			s_tone = -115
			src.h_style = pick("bald")
		//	cangoldemote = 1

			src.equip_if_possible(new /obj/item/clothing/shoes/clown_shoes(src), slot_shoes)
			//src.equip_if_possible(new /obj/item/clothing/under/rank/sexyman(src), slot_w_uniform)
			//bubba doesnt need pants -Nernums
			src.equip_if_possible(new /obj/item/clothing/mask/gas/clown_hat(src), slot_wear_mask)
			src.equip_if_possible(new /obj/item/weapon/storage/cock(src), slot_belt)
		//	src.equip_if_possible(new /obj/item/weapon/reagent_containers/food/drinks/penismilk, src.slot_l_hand)
		//	src.equip_if_possible(new /obj/item/weapon/reagent_containers/food/drinks/penismilk, src.slot_r_hand)




		spawn(20)
			ai_init()

	Life()
		..()
		if(prob(1) && stat != 2)
			src.say(pick("ey, gotsum nice lips dere", "ain no thang!"))

/mob/living/carbon/human/retard/violent/retard/New()
	..()
	spawn(0)
		src.dna = new /datum/dna(null)
	//	src.brainloss = 60
		src.r_hair = rand(1, 250)
		src.g_hair = rand(1, 250)
		src.b_hair = rand(1, 250)
		src.s_tone = rand(-115,100)
		src.h_style = pick("bald", "hair_a", "hair_b", "hair_c", "hair_d", "hair_e", "hair_f", "hair_afro", "hair_bieber", "hair_bedhead", "hair_dreads", "hair_rocker", "hair_femalemessy", "hair_long", "hair_pony", "hair_female_short", "hair_scene", "hair_girly", "hair_messym", "hair_messyf")
	//	src.equip_if_possible(new /obj/item/clothing/under/cloud(src), slot_w_uniform)
		if(prob(60))
			src.gender = "male"
			src.name = capitalize("Special " + pick(first_names_male))
			src.real_name = capitalize("Special " + pick(first_names_male))
		else
			src.gender = "female"
			src.name = capitalize("Special " + pick(first_names_female))
			src.real_name = capitalize("Special " + pick(first_names_female))
		switch(pick(1,2,3))
			if(1)
				src.equip_if_possible(new /obj/item/clothing/shoes/clown_shoes(src), slot_shoes)
			if(2)
				src.equip_if_possible(new /obj/item/clothing/shoes/white(src), slot_shoes)
			if(3)
				src.equip_if_possible(new /obj/item/clothing/shoes/orange(src), slot_shoes)

		switch(pick(1,2,3,4))
			if(1)
				src.equip_if_possible(new /obj/item/clothing/under/rainbow(src), slot_w_uniform)
			if(2)
				src.equip_if_possible(new /obj/item/clothing/under/color/pink(src), slot_w_uniform)
			if(3)
				src.equip_if_possible(new /obj/item/clothing/under/cloud(src), slot_w_uniform)
			if(4)
				src.equip_if_possible(new /obj/item/clothing/under/rank/sexyman(src), slot_w_uniform)

		switch(pick(1,2,3))
			if(2)
				src.equip_if_possible(new /obj/item/clothing/glasses/regular(src), slot_glasses)
			if(3)
				src.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(src), slot_glasses)

		src.equip_if_possible(new /obj/item/clothing/head/helmet/bikehelmet(src), slot_head)
		src.spawnId("[pick("CAPTIAN", "hed of speshul stuf", "monkie keepr", "sekurity ofiser")] (scribbled in crayon)")

	spawn(20)
		ai_init()
/mob/living/carbon/human/retard/violent/retard/armed/New()
	..()
	spawn(0)
		var/obj/item/weapon/gun/projectile/gun = new /obj/item/weapon/gun/projectile(src)
//		gun.bullets = 7
		src.equip_if_possible(gun, src.slot_r_hand)

/mob/living/carbon/human/retard/violent/retard/armed/bomb/New()
	..()
	spawn(0)
		var/obj/item/weapon/gun/projectile/gun = new /obj/item/weapon/gun/projectile(src)
		var/obj/spawner/bomb/suicide/bomb = new /obj/spawner/bomb/suicide(src)
//		gun.bullets = 7
		src.equip_if_possible(gun, src.slot_r_hand)
		src.equip_if_possible(bomb, slot_wear_suit)



/mob/living/carbon/human/retard/violent/zombors/New() // these zombies will have certain sets of gear to choose from and then special 'loot' bags on their backs at random - Nernums
	..()
	mutantrace= "zombie"
	spawn(0)
		src.dna = new /datum/dna(null)
	//	src.brainloss = 10 //zombies do not need to sound like retards, thats all this verb does. - Nernums
		src.r_hair = rand(1, 250)
		src.g_hair = rand(1, 250)
		src.b_hair = rand(1, 250)
		src.s_tone = rand(-115,100)
		src.h_style = pick("bald", "hair_a", "hair_b", "hair_c", "hair_d", "hair_e", "hair_f", "hair_afro", "hair_bieber", "hair_bedhead", "hair_dreads", "hair_rocker", "hair_femalemessy", "hair_long", "hair_pony", "hair_female_short", "hair_scene", "hair_girly","hair_messym", "hair_messyf")
		if(prob(60))
			src.gender = "male"
			src.name = capitalize("Unknown" + pick(first_names_male))
			src.real_name = capitalize("Zombie")
		else
			src.gender = "female"
			src.name = capitalize("Unknown" + pick(first_names_female))
			src.real_name = capitalize("Zombie")
		switch(pick(1,2,3,4,5,6,7))
			if(2)
				src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)
				switch(pick(1,2,3))
					if(1)
						src.equip_if_possible(new /obj/item/clothing/head/that(src), slot_head)
				src.equip_if_possible(new /obj/item/clothing/under/suit_jacket(src), slot_w_uniform)
			if(3)
				src.equip_if_possible(new /obj/item/clothing/shoes/white(src), slot_shoes)

		//	if(src.gender == female) //gender checks stolen from sex emotes. hnng
		//		src.equip_if_possible(new /obj/item/clothing/under/rank/nursesuit(src), slot_w_uniform)
		//	else if(src.gender == male)
				src.equip_if_possible(new /obj/item/clothing/under/rank/medical(src), slot_w_uniform)
		/*	switch(pick(1,2,3,4,5,6))
				if(1)
				//	src.equip_if_possible(new /obj/item/weapon/storage/firstaid/zday, src.slot_l_hand)
					src.equip_if_possible(new /obj/item/weapon/reagent_containers/glass/bottle/tricordrazine, src.slot_r_hand)
				if(2)
					src.equip_if_possible(new /obj/item/weapon/reagent_containers/glass/bottle/tricordrazine, src.slot_l_hand)
				//	src.equip_if_possible(new /obj/item/weapon/storage/firstaid/zday, src.slot_r_hand)
				if(3)
				//	src.equip_if_possible(new /obj/item/weapon/storage/firstaid/zday, src.slot_l_hand)
				if(4)
					src.equip_if_possible(new /obj/item/weapon/reagent_containers/glass/bottle/tricordrazine, src.slot_r_hand)
		*/
			if(4)
				src.equip_if_possible(new /obj/item/clothing/shoes/jackboots(src), slot_shoes)
				src.equip_if_possible(new /obj/item/clothing/suit/armor/vest(src), slot_wear_suit)
				src.equip_if_possible(new /obj/item/clothing/under/gimmick/rank/police(src), slot_w_uniform)
				src.equip_if_possible(new /obj/item/clothing/head/collectable/police(src), slot_head)

			if(5)//janitorzombie
				src.equip_if_possible(new /obj/item/clothing/shoes/galoshes(src), slot_shoes)
				src.equip_if_possible(new /obj/item/clothing/under/rank/janitor(src), slot_w_uniform)
				switch(pick(1,2))
					if(1)
						src.equip_if_possible(new /obj/item/weapon/mop, src.slot_l_hand)
						src.equip_if_possible(new /obj/item/weapon/reagent_containers/glass/bucket, src.slot_r_hand)
					if(2)
						src.equip_if_possible(new /obj/item/weapon/mop, src.slot_l_hand)
						src.equip_if_possible(new /obj/item/weapon/reagent_containers/glass/bucket, src.slot_r_hand)

			if(6)//engineer zombie
				src.equip_if_possible(new /obj/item/clothing/shoes/workboots(src), slot_shoes)
				src.equip_if_possible(new /obj/item/clothing/under/rank/engineer(src), slot_w_uniform)
				switch(pick(1,2,3))
					if(1)
						src.equip_if_possible(new /obj/item/clothing/head/helmet/hardhat(src), slot_head)
					if(2)
						src.equip_if_possible(new /obj/item/clothing/head/helmet/welding(src), slot_head)
					if(3)
						src.equip_if_possible(new /obj/item/clothing/head/helmet/hardhat/white(src), slot_head)

				src.equip_if_possible(new /obj/item/clothing/suit/hazardvest(src), slot_wear_suit)
			if(7)
				src.equip_if_possible(new /obj/item/clothing/shoes/brown(src), slot_shoes)
				src.equip_if_possible(new /obj/item/clothing/under/overalls(src), slot_w_uniform)
				//src.equip_if_possible(new /obj/item/clothing/head/strawhat(src), slot_head)



		switch(pick(1,2,3,4,5,6,7,8,9,10)) //not everyone has eyewear usually. -Nernums
			if(2)
				src.equip_if_possible(new /obj/item/clothing/glasses/regular(src), slot_glasses)
			if(3)
				src.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(src), slot_glasses)
			if(9)
				src.equip_if_possible(new /obj/item/clothing/glasses/eyepatch(src), slot_glasses)
			if(10)
				src.equip_if_possible(new /obj/item/clothing/glasses/gglasses(src), slot_glasses)

	spawn(20)
		ai_init()

/mob/living/carbon/human/retard/violent/zombors/randomizedgear/New()
	..()
	mutantrace= "zombie"
	spawn(0)
		src.dna = new /datum/dna(null)
	//	src.brainloss = 10 //zombies do not need to sound like retards, thats all this verb does. - Nernums
		src.r_hair = rand(1, 250)
		src.g_hair = rand(1, 250)
		src.b_hair = rand(1, 250)
		src.s_tone = rand(-115,100)
		src.h_style = pick("bald", "hair_a", "hair_b", "hair_c", "hair_d", "hair_e", "hair_f", "hair_afro", "hair_bieber", "hair_bedhead", "hair_dreads", "hair_rocker", "hair_femalemessy", "hair_long", "hair_pony", "hair_female_short", "hair_scene", "hair_girly", "hair_messym", "hair_messyf")
		if(prob(60))
			src.gender = "male"
			src.name = capitalize("Unknown" + pick(first_names_male))
			src.real_name = capitalize("Zombie")
		else
			src.gender = "female"
			src.name = capitalize("Unknown" + pick(first_names_female))
			src.real_name = capitalize("Zombie")
		switch(pick(1,2,3,4,5,6,7))
			if(2)
				src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)
			if(3)
				src.equip_if_possible(new /obj/item/clothing/shoes/white(src), slot_shoes)
			if(4)
				src.equip_if_possible(new /obj/item/clothing/shoes/orange(src), slot_shoes)
			if(5)
				src.equip_if_possible(new /obj/item/clothing/shoes/galoshes(src), slot_shoes)
			if(6)
				src.equip_if_possible(new /obj/item/clothing/shoes/workboots(src), slot_shoes)
			if(7)
				src.equip_if_possible(new /obj/item/clothing/shoes/brown(src), slot_shoes)

		switch(pick(1,2,3,4,5,6,7,8,9,10,11,12,13,14))
			if(1)
				src.equip_if_possible(new /obj/item/clothing/under/shorts/black(src), slot_w_uniform)
			if(2)
				src.equip_if_possible(new /obj/item/clothing/under/color/grey(src), slot_w_uniform)
			if(3)
				src.equip_if_possible(new /obj/item/clothing/under/color/pink(src), slot_w_uniform)
			if(4)
				src.equip_if_possible(new /obj/item/clothing/under/rank/bartender(src), slot_w_uniform)
			if(5)
				src.equip_if_possible(new /obj/item/clothing/under/rank/sexyman(src), slot_w_uniform)
			if(6)
				src.equip_if_possible(new /obj/item/clothing/under/gimmick/rank/police(src), slot_w_uniform)
			if(7)
				src.equip_if_possible(new /obj/item/clothing/under/color/black(src), slot_w_uniform)
			if(8)
				src.equip_if_possible(new /obj/item/clothing/under/waiter(src), slot_w_uniform)
			if(9)
				src.equip_if_possible(new /obj/item/clothing/under/rank/atmospheric_technician(src), slot_w_uniform)
			if(10)
				src.equip_if_possible(new /obj/item/clothing/under/rank/engineer(src), slot_w_uniform)
			if(11)
				src.equip_if_possible(new /obj/item/clothing/under/rank/chief_engineer(src), slot_w_uniform)
			if(12)
				src.equip_if_possible(new /obj/item/clothing/under/rank/janitor(src), slot_w_uniform)
			if(13)
				src.equip_if_possible(new /obj/item/clothing/under/rank/medical(src), slot_w_uniform)
			if(14)
				src.equip_if_possible(new /obj/item/clothing/under/rank/nursesuit(src), slot_w_uniform)

		switch(pick(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,29,30))
			if(2)
				src.equip_if_possible(new /obj/item/clothing/head/ushanka(src), slot_head) // in soviet russia zombie eat you!
			if(3)
				src.equip_if_possible(new /obj/item/clothing/head/det_hat(src), slot_head)
			if(4)
				src.equip_if_possible(new /obj/item/clothing/head/secsoft(src), slot_head)
			if(5)
				src.equip_if_possible(new /obj/item/clothing/head/helmet/bikehelmet(src), slot_head)
			if(6)
				src.equip_if_possible(new /obj/item/clothing/head/chefhat(src), slot_head)
			if(7)
				src.equip_if_possible(new /obj/item/clothing/head/that(src), slot_head) //DAPPER
			if(8)
				src.equip_if_possible(new /obj/item/clothing/head/bandana(src), slot_head)
			if(9)
				src.equip_if_possible(new /obj/item/clothing/head/stockingcap(src), slot_head)
			if(10)
				src.equip_if_possible(new /obj/item/clothing/head/helmet/nernhat(src), slot_head) // SHIT SHIT THEY GOT GUNNER SHIT -Nernums
			if(11)
				src.equip_if_possible(new /obj/item/clothing/head/helmet/warden(src), slot_head)
			if(12)
				src.equip_if_possible(new /obj/item/clothing/head/helmet/HoS(src), slot_head)
			if(13)
				src.equip_if_possible(new /obj/item/clothing/head/helmet/cap(src), slot_head)
			if(14)
				src.equip_if_possible(new /obj/item/clothing/head/e_officerhat(src), slot_head)
			if(15)
				src.equip_if_possible(new /obj/item/clothing/head/helmet/hardhat(src), slot_head)
			if(16)
				src.equip_if_possible(new /obj/item/clothing/head/helmet/hardhat/white(src), slot_head)
			if(17)
				src.equip_if_possible(new /obj/item/clothing/head/rabbitears(src), slot_head) // PILCROW DOWN
			if(18)
				src.equip_if_possible(new /obj/item/clothing/head/helmet/space/deathsquad/beret(src), slot_head)
			if(19)
				src.equip_if_possible(new /obj/item/clothing/head/beret(src), slot_head)
		//	if(20)
		//		src.equip_if_possible(new /obj/item/weapon/paper(src), slot_head)	// I HOPE THIS WORKS // IT SPAMS ERRORS FUCK
			if(21)
				src.equip_if_possible(new /obj/item/clothing/head/helmet/welding(src), slot_head)
		//	if(22)
		//		src.equip_if_possible(new /obj/item/weapon/kitchen/utensil/knife(src), slot_head) //knife is face doesn't work, I am sad.

		switch(pick(1,2,3,4,5,6,7,8,9,10))
			if(2)
				src.equip_if_possible(new /obj/item/clothing/glasses/regular(src), slot_glasses)
			if(3)
				src.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(src), slot_glasses)
			if(9)
				src.equip_if_possible(new /obj/item/clothing/glasses/eyepatch(src), slot_glasses)
			if(10)
				src.equip_if_possible(new /obj/item/clothing/glasses/gglasses(src), slot_glasses)

		switch(pick(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22))
			if(2)
				src.equip_if_possible(new /obj/item/clothing/suit/fire/firefighter(src), slot_wear_suit)
			if(3)
				src.equip_if_possible(new /obj/item/clothing/suit/chef(src), slot_wear_suit)
			if(4)
				src.equip_if_possible(new /obj/item/clothing/suit/chickensuit(src), slot_wear_suit)
			if(5)
				src.equip_if_possible(new /obj/item/clothing/suit/armor/vest(src), slot_wear_suit)
			if(6)
				src.equip_if_possible(new /obj/item/clothing/suit/fire/firefighter(src), slot_wear_suit)
			if(7)
				src.equip_if_possible(new /obj/item/clothing/suit/chef(src), slot_wear_suit)
			if(8)
				src.equip_if_possible(new /obj/item/clothing/suit/labcoat/cmo(src), slot_wear_suit)
			if(9)
				src.equip_if_possible(new /obj/item/clothing/suit/labcoat/mad(src), slot_wear_suit)
			if(10)
				src.equip_if_possible(new /obj/item/clothing/suit/nazicoat(src), slot_wear_suit)
			if(11)
				src.equip_if_possible(new /obj/item/clothing/suit/wcoat(src), slot_wear_suit)
			if(12)
				src.equip_if_possible(new /obj/item/clothing/suit/hazardvest(src), slot_wear_suit)
			if(13)
				src.equip_if_possible(new /obj/item/clothing/suit/bedsheet(src), slot_wear_suit)


	spawn(20)
		ai_init()



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
			src.h_style = pick("bald", "hair_a", "hair_c", "hair_d", "hair_e", "hair_f", "hair_bedhead", "hair_rocker", "hair_femalemessy", "hair_dreads", "hair_scene", "hair_messym", "hair_messyf")
		else
			src.gender = "female"
			src.real_name = capitalize(pick(first_names_female) + " " + pick(last_names))
			src.h_style = pick("hair_b", "hair_long", "hair_pony", "hair_femalemessy", "hair_scene", "hair_girly", "hair_messym", "hair_messyf")

		src.equip_if_possible(new /obj/item/clothing/under/rank/hydroponics(src), slot_w_uniform)
		src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)
		src.equip_if_possible(new /obj/item/clothing/gloves/botanic_leather(src), slot_gloves)
		src.equip_if_possible(new /obj/item/clothing/suit/apron(src), slot_wear_suit)

		spawn(20)
			ai_init()

	Life()
		..()
		if(prob(1) && stat != 2)

			src.say(pick("Hrmmmm.."))

/*
/mob/living/carbon/human/zombie/New() // these zombies will have certain sets of gear to choose from and then special 'loot' bags on their backs at random - Nernums
	..()
	mutantrace= "zombie"
	spawn(0)
		src.dna = new /datum/dna(null)
		//src.brainloss = 60 //zombies do not need to sound like retards, thats all this verb does. - Nernums
		src.r_hair = rand(1, 250)
		src.g_hair = rand(1, 250)
		src.b_hair = rand(1, 250)
		src.s_tone = rand(-115,100)
		src.h_style = pick("bald", "hair_a", "hair_b", "hair_c", "hair_d", "hair_e", "hair_f", "hair_afro", "hair_bieber", "hair_bedhead", "hair_dreads", "hair_rocker", "hair_femalemessy", "hair_long", "hair_pony", "hair_female_short", "hair_scene", "hair_girly")
		if(prob(60))
			src.gender = "male"
			src.name = capitalize("Unknown" + pick(first_names_male))
			src.real_name = capitalize("Zombie")
		else
			src.gender = "female"
			src.name = capitalize("Unknown" + pick(first_names_female))
			src.real_name = capitalize("Zombie")
		switch(pick(1,2,3,4,5,6,7))
			if(2)
				src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)
				switch(pick(1,2,3))
					if(1)
						src.equip_if_possible(new /obj/item/clothing/head/that(src), slot_head)
				src.equip_if_possible(new /obj/item/clothing/under/suit_jacket(src), slot_w_uniform)
			if(3)
				src.equip_if_possible(new /obj/item/clothing/shoes/white(src), slot_shoes)

		/*	if(src.gender == FEMALE) //gender checks stolen from sex emotes. hnng
				src.equip_if_possible(new /obj/item/clothing/under/rank/nursesuit(src), slot_w_uniform)
			else if(src.gender == MALE)
				src.equip_if_possible(new /obj/item/clothing/under/rank/medical(src), slot_w_uniform)
			switch(pick(1,2,3,4,5,6))
				if(1)
				//	src.equip_if_possible(new /obj/item/weapon/storage/firstaid/zday, src.slot_l_hand)
					src.equip_if_possible(new /obj/item/weapon/reagent_containers/glass/bottle/tricordrazine, src.slot_r_hand)
				if(2)
					src.equip_if_possible(new /obj/item/weapon/reagent_containers/glass/bottle/tricordrazine, src.slot_l_hand)
				//	src.equip_if_possible(new /obj/item/weapon/storage/firstaid/zday, src.slot_r_hand)
				if(3)
				//	src.equip_if_possible(new /obj/item/weapon/storage/firstaid/zday, src.slot_l_hand)
				if(4)
					src.equip_if_possible(new /obj/item/weapon/reagent_containers/glass/bottle/tricordrazine, src.slot_r_hand)
		*/
			if(4)
				src.equip_if_possible(new /obj/item/clothing/shoes/jackboots(src), slot_shoes)
				src.equip_if_possible(new /obj/item/clothing/suit/armor/vest(src), slot_wear_suit)
				src.equip_if_possible(new /obj/item/clothing/under/gimmick/rank/police(src), slot_w_uniform)
				src.equip_if_possible(new /obj/item/clothing/head/collectable/police(src), slot_head)

			if(5)//janitorzombie
				src.equip_if_possible(new /obj/item/clothing/shoes/galoshes(src), slot_shoes)
				src.equip_if_possible(new /obj/item/clothing/under/rank/janitor(src), slot_w_uniform)
				switch(pick(1,2))
					if(1)
						src.equip_if_possible(new /obj/item/weapon/mop, src.slot_l_hand)
						src.equip_if_possible(new /obj/item/weapon/reagent_containers/glass/bucket, src.slot_r_hand)
					if(2)
						src.equip_if_possible(new /obj/item/weapon/mop, src.slot_l_hand)
						src.equip_if_possible(new /obj/item/weapon/reagent_containers/glass/bucket, src.slot_r_hand)

			if(6)//engineer zombie
				src.equip_if_possible(new /obj/item/clothing/shoes/workboots(src), slot_shoes)
				src.equip_if_possible(new /obj/item/clothing/under/rank/engineer(src), slot_w_uniform)
				switch(pick(1,2,3))
					if(1)
						src.equip_if_possible(new /obj/item/clothing/head/helmet/hardhat(src), slot_head)
					if(2)
						src.equip_if_possible(new /obj/item/clothing/head/helmet/welding(src), slot_head)
					if(3)
						src.equip_if_possible(new /obj/item/clothing/head/helmet/hardhat/white(src), slot_head)

				src.equip_if_possible(new /obj/item/clothing/suit/hazardvest(src), slot_wear_suit)
			if(7)
				src.equip_if_possible(new /obj/item/clothing/shoes/brown(src), slot_shoes)
				src.equip_if_possible(new /obj/item/clothing/under/overalls(src), slot_w_uniform)
				//src.equip_if_possible(new /obj/item/clothing/head/strawhat(src), slot_head)



		switch(pick(1,2,3,4,5,6,7,8,9,10)) //not everyone has eyewear usually. -Nernums
			if(2)
				src.equip_if_possible(new /obj/item/clothing/glasses/regular(src), slot_glasses)
			if(3)
				src.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(src), slot_glasses)
			if(9)
				src.equip_if_possible(new /obj/item/clothing/glasses/eyepatch(src), slot_glasses)
			if(10)
				src.equip_if_possible(new /obj/item/clothing/glasses/gglasses(src), slot_glasses)

	spawn(20)
		ai_init()

/mob/living/carbon/human/zombie/randomizedgear/New()
	..()
	mutantrace= "zombie"
	spawn(0)
		src.dna = new /datum/dna(null)
		//src.brainloss = 60 //zombies do not need to sound like retards, thats all this verb does. - Nernums
		src.r_hair = rand(1, 250)
		src.g_hair = rand(1, 250)
		src.b_hair = rand(1, 250)
		src.s_tone = rand(-115,100)
		src.h_style = pick("bald", "hair_a", "hair_b", "hair_c", "hair_d", "hair_e", "hair_f", "hair_afro", "hair_bieber", "hair_bedhead", "hair_dreads", "hair_rocker", "hair_femalemessy", "hair_long", "hair_pony", "hair_female_short", "hair_scene", "hair_girly")
		if(prob(60))
			src.gender = "male"
			src.name = capitalize("Unknown" + pick(first_names_male))
			src.real_name = capitalize("Zombie")
		else
			src.gender = "female"
			src.name = capitalize("Unknown" + pick(first_names_female))
			src.real_name = capitalize("Zombie")
		switch(pick(1,2,3,4,5,6,7))
			if(2)
				src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)
			if(3)
				src.equip_if_possible(new /obj/item/clothing/shoes/white(src), slot_shoes)
			if(4)
				src.equip_if_possible(new /obj/item/clothing/shoes/orange(src), slot_shoes)
			if(5)
				src.equip_if_possible(new /obj/item/clothing/shoes/galoshes(src), slot_shoes)
			if(6)
				src.equip_if_possible(new /obj/item/clothing/shoes/workboots(src), slot_shoes)
			if(7)
				src.equip_if_possible(new /obj/item/clothing/shoes/brown(src), slot_shoes)

		switch(pick(1,2,3,4,5,6,7,8,9,10,11,12,13,14))
			if(1)
				src.equip_if_possible(new /obj/item/clothing/under/shorts/black(src), slot_w_uniform)
			if(2)
				src.equip_if_possible(new /obj/item/clothing/under/color/grey(src), slot_w_uniform)
			if(3)
				src.equip_if_possible(new /obj/item/clothing/under/color/pink(src), slot_w_uniform)
			if(4)
				src.equip_if_possible(new /obj/item/clothing/under/rank/bartender(src), slot_w_uniform)
			if(5)
				src.equip_if_possible(new /obj/item/clothing/under/rank/sexyman(src), slot_w_uniform)
			if(6)
				src.equip_if_possible(new /obj/item/clothing/under/gimmick/rank/police(src), slot_w_uniform)
			if(7)
				src.equip_if_possible(new /obj/item/clothing/under/color/black(src), slot_w_uniform)
			if(8)
				src.equip_if_possible(new /obj/item/clothing/under/waiter(src), slot_w_uniform)
			if(9)
				src.equip_if_possible(new /obj/item/clothing/under/rank/atmospheric_technician(src), slot_w_uniform)
			if(10)
				src.equip_if_possible(new /obj/item/clothing/under/rank/engineer(src), slot_w_uniform)
			if(11)
				src.equip_if_possible(new /obj/item/clothing/under/rank/chief_engineer(src), slot_w_uniform)
			if(12)
				src.equip_if_possible(new /obj/item/clothing/under/rank/janitor(src), slot_w_uniform)
			if(13)
				src.equip_if_possible(new /obj/item/clothing/under/rank/medical(src), slot_w_uniform)
			if(14)
				src.equip_if_possible(new /obj/item/clothing/under/rank/nursesuit(src), slot_w_uniform)

		switch(pick(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,29,30))
			if(2)
				src.equip_if_possible(new /obj/item/clothing/head/ushanka(src), slot_head) // in soviet russia zombie eat you!
			if(3)
				src.equip_if_possible(new /obj/item/clothing/head/det_hat(src), slot_head)
			if(4)
				src.equip_if_possible(new /obj/item/clothing/head/secsoft(src), slot_head)
			if(5)
				src.equip_if_possible(new /obj/item/clothing/head/helmet/bikehelmet(src), slot_head)
			if(6)
				src.equip_if_possible(new /obj/item/clothing/head/chefhat(src), slot_head)
			if(7)
				src.equip_if_possible(new /obj/item/clothing/head/that(src), slot_head) //DAPPER
			if(8)
				src.equip_if_possible(new /obj/item/clothing/head/bandana(src), slot_head)
			if(9)
				src.equip_if_possible(new /obj/item/clothing/head/stockingcap(src), slot_head)
			if(10)
				src.equip_if_possible(new /obj/item/clothing/head/helmet/nernhat(src), slot_head) // SHIT SHIT THEY GOT GUNNER SHIT -Nernums
			if(11)
				src.equip_if_possible(new /obj/item/clothing/head/helmet/warden(src), slot_head)
			if(12)
				src.equip_if_possible(new /obj/item/clothing/head/helmet/HoS(src), slot_head)
			if(13)
				src.equip_if_possible(new /obj/item/clothing/head/helmet/cap(src), slot_head)
			if(14)
				src.equip_if_possible(new /obj/item/clothing/head/e_officerhat(src), slot_head)
			if(15)
				src.equip_if_possible(new /obj/item/clothing/head/helmet/hardhat(src), slot_head)
			if(16)
				src.equip_if_possible(new /obj/item/clothing/head/helmet/hardhat/white(src), slot_head)
			if(17)
				src.equip_if_possible(new /obj/item/clothing/head/rabbitears(src), slot_head) // PILCROW DOWN
			if(18)
				src.equip_if_possible(new /obj/item/clothing/head/helmet/space/deathsquad/beret(src), slot_head)
			if(19)
				src.equip_if_possible(new /obj/item/clothing/head/beret(src), slot_head)
		//	if(20)
		//		src.equip_if_possible(new /obj/item/weapon/paper(src), slot_head)	// I HOPE THIS WORKS // IT SPAMS ERRORS FUCK
			if(21)
				src.equip_if_possible(new /obj/item/clothing/head/helmet/welding(src), slot_head)
		//	if(22)
		//		src.equip_if_possible(new /obj/item/weapon/kitchen/utensil/knife(src), slot_head) //knife is face doesn't work, I am sad.

		switch(pick(1,2,3,4,5,6,7,8,9,10))
			if(2)
				src.equip_if_possible(new /obj/item/clothing/glasses/regular(src), slot_glasses)
			if(3)
				src.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(src), slot_glasses)
			if(9)
				src.equip_if_possible(new /obj/item/clothing/glasses/eyepatch(src), slot_glasses)
			if(10)
				src.equip_if_possible(new /obj/item/clothing/glasses/gglasses(src), slot_glasses)

		switch(pick(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22))
			if(2)
				src.equip_if_possible(new /obj/item/clothing/suit/fire/firefighter(src), slot_wear_suit)
			if(3)
				src.equip_if_possible(new /obj/item/clothing/suit/chef(src), slot_wear_suit)
			if(4)
				src.equip_if_possible(new /obj/item/clothing/suit/chickensuit(src), slot_wear_suit)
			if(5)
				src.equip_if_possible(new /obj/item/clothing/suit/armor/vest(src), slot_wear_suit)
			if(6)
				src.equip_if_possible(new /obj/item/clothing/suit/fire/firefighter(src), slot_wear_suit)
			if(7)
				src.equip_if_possible(new /obj/item/clothing/suit/chef(src), slot_wear_suit)
			if(8)
				src.equip_if_possible(new /obj/item/clothing/suit/labcoat/cmo(src), slot_wear_suit)
			if(9)
				src.equip_if_possible(new /obj/item/clothing/suit/labcoat/mad(src), slot_wear_suit)
			if(10)
				src.equip_if_possible(new /obj/item/clothing/suit/nazicoat(src), slot_wear_suit)
			if(11)
				src.equip_if_possible(new /obj/item/clothing/suit/wcoat(src), slot_wear_suit)
			if(12)
				src.equip_if_possible(new /obj/item/clothing/suit/hazardvest(src), slot_wear_suit)
			if(13)
				src.equip_if_possible(new /obj/item/clothing/suit/bedsheet(src), slot_wear_suit)


	spawn(20)
		ai_init()
*/
