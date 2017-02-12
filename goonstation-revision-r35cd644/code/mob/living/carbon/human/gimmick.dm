// cluwne

/mob/living/carbon/human/cluwne
	New()
		..()
		spawn(0)
			src.gender = "male"
			src.real_name = "cluwne"
			src.contract_disease(/datum/ailment/disease/cluwneing_around,null,null,1)
			src.contract_disease(/datum/ailment/disability/clumsy,null,null,1)

			src.equip_if_possible(new /obj/item/clothing/under/gimmick/cursedclown(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/cursedclown_shoes(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/mask/cursedclown_hat(src), slot_wear_mask)
			src.equip_if_possible(new /obj/item/clothing/gloves/cursedclown_gloves(src), slot_gloves)
			src.make_jittery(1000)
			src.bioHolder.AddEffect("clumsy")
			src.take_brain_damage(80)

	Life(datum/controller/process/mobs/parent)
		if (..(parent))
			return 1
		if (stat == 2)
			return
		jitteriness = INFINITY
		stuttering = INFINITY
		nutrition = INFINITY
		HealDamage("All", INFINITY, INFINITY)
		take_oxygen_deprivation(-INFINITY)
		take_toxin_damage(-INFINITY)
		if(prob(5))
			spawn(0)
				src.say("HANK!")
				playsound(src.loc, "sound/items/bikehorn.ogg", 50, 1)

/mob/living/carbon/human/cluwne/floor
	nodamage = 1
	anchored = 1
	layer = 0

	New()
		..()
		spawn(0)
			ailments.Cut()
			real_name = "floor cluwne"
			name = "floor cluwne"

	cluwnegib()
		return

	ex_act()
		return


// how you gonna have father ted and father jack and not father dougal? smh

/mob/living/carbon/human/fatherted
	New()
		..()
		spawn(0)
			bioHolder.mobAppearance.gender = "male"
			src.real_name = "Father Ted"

			src.equip_if_possible(new /obj/item/clothing/shoes/red(src), slot_shoes)

			src.equip_if_possible(new /obj/item/clothing/under/rank/chaplain(src), slot_w_uniform)

			spawn(10)
				bioHolder.mobAppearance.UpdateMob()

/mob/living/carbon/human/fatherjack
	New()
		..()
		spawn(0)
			bioHolder.mobAppearance.gender = "male"
			src.real_name = "Father Jack"
			bioHolder.bloodType = "B+"

			src.equip_if_possible(new /obj/item/clothing/shoes/red(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/under/misc/chaplain(src), slot_w_uniform)

			spawn(10)
				bioHolder.mobAppearance.UpdateMob()

	Life(datum/controller/process/mobs/parent)
		if (..(parent))
			return 1

		if(prob(1) && !src.stat)
			spawn(0) src.say(pick( "DRINK!", "FECK!", "ARSE!", "GIRLS!","That would be an ecumenical matter."))

	attack_hand(mob/M)
		..()
		if (M.a_intent in list(INTENT_HARM,INTENT_DISARM,INTENT_GRAB))
			for (var/mob/living/carbon/human/npc/diner_bartender/BT in all_viewers(7, src))
				BT.protect_from(M, src)

	attackby(obj/item/W, mob/M)
		var/tmp/oldbloss = get_brute_damage()
		var/tmp/oldfloss = get_burn_damage()
		..()
		var/tmp/damage = ((get_brute_damage() - oldbloss) + (get_burn_damage() - oldfloss))
		if ((damage > 0) || W.force)
			for (var/mob/living/carbon/human/npc/diner_bartender/BT in all_viewers(7, src))
				BT.protect_from(M, src)

//biker // cogwerks - bringing back the bikers for the diner, now less offensive

/// BILL SPEECH STUFF

var/list/BILL_greetings = strings("shittybill.txt", "greetings")
var/list/BILL_rude = strings("shittybill.txt", "rude")
var/list/BILL_insults = strings("shittybill.txt", "insults")
var/list/BILL_people = strings("shittybill.txt", "people")
var/list/BILL_question = strings("shittybill.txt", "question")
var/list/BILL_item = strings("shittybill.txt", "item")
var/list/BILL_drugs = strings("shittybill.txt", "drugs")
var/list/BILL_nouns = strings("shittybill.txt", "nouns")
var/list/BILL_verbs = strings("shittybill.txt", "verbs")
var/list/BILL_stories = strings("shittybill.txt", "stories1") + strings("shittybill.txt", "stories2") + strings("shittybill.txt", "stories3")
var/list/BILL_doMiss = strings("shittybill.txt", "domiss")
var/list/BILL_dontMiss = strings("shittybill.txt", "dontmiss")
var/list/BILL_friends = strings("shittybill.txt", "friends")
var/list/BILL_friendActions = strings("shittybill.txt", "friendsactions")
var/list/BILL_emotes = strings("shittybill.txt", "emotes")
var/list/BILL_deadguy = strings("shittybill.txt", "deadguy")
var/list/BILL_murray = strings("shittybill.txt", "murraycompliment")

/mob/living/carbon/human/biker
	real_name = "Shitty Bill"
	gender = MALE
	var/talk_prob = 5
	var/greeted_murray = 0
	var/list/mob/alive_mobs = list()
	var/list/mob/dead_mobs = list()

	New()
		..()
		spawn(0)
			bioHolder.mobAppearance.customization_second = "Tramp"
			bioHolder.age = 62
			bioHolder.bloodType = "A-"
			bioHolder.mobAppearance.gender = "male"
			bioHolder.mobAppearance.underwear = "briefs"
			spawn(10)
				bioHolder.mobAppearance.UpdateMob()

			src.equip_if_possible(new /obj/item/clothing/shoes/brown(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/under/misc/head_of_security(src), slot_w_uniform)
			//src.equip_if_possible(new /obj/item/clothing/suit(src), slot_wear_suit)
			//src.equip_if_possible(new /obj/item/clothing/head/biker_cap(src), slot_head)

	Life(datum/controller/process/mobs/parent)
		if (..(parent))
			return 1
		if(!src.stat)
			if(target)
				if(target.stat == 2)
					target = null
				if(get_dist(src, target) > 1)
					step_to(src, target, 1)
				if(get_dist(src, target) <= 1 && !LinkBlocked(src.loc, target.loc))
					var/obj/item/W = src.equipped()
					if (!src.restrained())
						if(W)
							W.attack(target, src, ran_zone("chest"))
						else
							target.attack_hand(src)
			else if(ai_aggressive)
				a_intent = INTENT_HARM
				for(var/mob/M in oview(5, src))
					if(M == src)
						continue
					if(M.type == src.type)
						continue
					if(M.stat)
						continue
					// stop on first human mob
					if(ishuman(M))
						target = M
						break
					target = M
			if(src.canmove && prob(20) && isturf(src.loc))
				step(src, pick(NORTH, SOUTH, EAST, WEST))
			if(prob(2))
				spawn(0) emote(pick(BILL_emotes))

			if(prob(talk_prob))
				spawn(0)
					var/obj/machinery/bot/guardbot/old/tourguide/murray = locate() in oview(src, 5)
					if (istype(murray))
						if (!findtext(murray.name, "murray"))
							murray = null

					for(var/mob/living/M in oviewers(src, 5))
						if(M.stat != 2)
							alive_mobs.Add(M)
						else
							dead_mobs.Add(M)
					if(dead_mobs && dead_mobs.len > 0 && prob(60)) //SpyGuy for undefined var/len (what the heck)
						var/mob/M = pick(dead_mobs)
						say("[pick(BILL_deadguy)] [M.name]...")
					else if (alive_mobs.len > 0)
						if (murray && !greeted_murray)
							greeted_murray = 1
							say("[pick(BILL_greetings)] Murray! How's it [pick(BILL_verbs)]?")
							spawn(rand(20,40))
								if (murray && murray.on && !murray.idle)
									murray.speak("Hi, Bill! It's [pick(BILL_murray)] to see you again!")

						else
							var/mob/M = pick(alive_mobs)
							var/speech_type = rand(1,11)

							switch(speech_type)
								if(1)
									say("[pick(BILL_greetings)] [M.name].")

								if(2)
									say("[pick(BILL_question)] you lookin' at, [pick(BILL_insults)]?")

								if(3)
									say("You a [pick(BILL_people)]?")

								if(4)
									say("[pick(BILL_rude)], gimme yer [pick(BILL_item)].")

								if(5)
									say("Got a light, [pick(BILL_insults)]?")

								if(6)
									say("Nice [pick(BILL_nouns)], [pick(BILL_insults)].")

								if(7)
									say("Got any [pick(BILL_drugs)]?")

								if(8)
									say("I ever tell you 'bout [pick(BILL_stories)]?")

								if(9)
									say("You [pick(BILL_verbs)]?")

								if(10)
									if (prob(50))
										say("Man, I sure miss [pick(BILL_doMiss)].")
									else
										say("Man, I sure don't miss [pick(BILL_dontMiss)].")

								if(11)
									say("I think my [pick(BILL_friends)] [pick(BILL_friendActions)].")

							if (prob(10))
								spawn(40)
									for (var/mob/living/carbon/human/npc/diner_bartender/BT in all_hearers(7, src))
										switch (speech_type)
											if (4)
												BT.say("Look in the machine, you bum.")
											if (7)
												BT.say("You ask that weirdo in the bathroom?")
											if (8)
												if (prob(2))
													BT.say("One of these days, you better. You always talkin' like you're gunna tell some grand story about that, and then you never do[pick("", ", you ass")].")
												else if (prob(6))
													BT.say("Nah, [src].")
												else
													BT.say("Yeah, [src], I remember that one.")
											if (9)
												if (prob(50))
													BT.say("Yeah, sometimes.")
												else
													BT.say("Nah.")

					alive_mobs = list()
					dead_mobs = list()

	attack_hand(mob/M)
		..()
		if (M.a_intent in list(INTENT_HARM,INTENT_DISARM,INTENT_GRAB))
			for (var/mob/living/carbon/human/npc/diner_bartender/BT in all_viewers(7, src))
				BT.protect_from(M, src)

	attackby(obj/item/W, mob/M)
		var/tmp/oldbloss = get_brute_damage()
		var/tmp/oldfloss = get_burn_damage()
		..()
		var/tmp/damage = ((get_brute_damage() - oldbloss) + (get_burn_damage() - oldfloss))
		if ((damage > 0) || W.force)
			for (var/mob/living/carbon/human/npc/diner_bartender/BT in all_viewers(7, src))
				BT.protect_from(M, src)

// merchant

/mob/living/carbon/human/merchant
	New()
		..()
		spawn(0)
			src.gender = "male"
			src.real_name = pick("Slick", "Fast", "Frugal", "Thrifty", "Clever", "Shifty") + " " + pick(first_names_male)
			src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/under/gimmick/merchant(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/suit/merchant(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(src), slot_glasses)
			src.equip_if_possible(new /obj/item/clothing/head/merchant_hat(src), slot_head)

// myke

/mob/living/carbon/human/myke
	New()
		..()
		spawn(0)
			src.gender = "male"
			src.real_name = "Myke"

			spawn(10)
				bioHolder.mobAppearance.UpdateMob()

			src.equip_if_possible(new /obj/item/clothing/shoes/red(src), slot_shoes)

			src.equip_if_possible(new /obj/item/clothing/under/color/lightred(src), slot_w_uniform)

			src.equip_if_possible(new /obj/item/clothing/mask/breath(src), slot_wear_mask)
			src.internal = src.back
	Life(datum/controller/process/mobs/parent)
		if (..(parent))
			return 1
		src.weakened = 5
		if(prob(15))
			spawn(0) emote(pick("giggle", "laugh"))
		if(prob(1))
			spawn(0) src.say(pick("You guys wanna hear me play bass?", stutter("HUFFFF"), "I missed my AA meeting to play Left 4 Dead...", "I got my license suspended AGAIN", "I got fired from [pick("McDonald's", "Boston Market", "Wendy's", "Burger King", "Starbucks", "Menard's")]..."))

// waldo

// Where's WAL[DO/LY]???

/mob/living/carbon/human/waldo
	New()
		..()
		spawn(0)
			src.gender = "male"
			src.real_name = "Waldo"

			src.equip_if_possible(new /obj/item/clothing/shoes/brown(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/under/gimmick/waldo(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/head/waldohat(src), slot_head)
			src.equip_if_possible(new /obj/item/device/radio/headset(src), slot_ears)
			src.equip_if_possible(new /obj/item/storage/backpack(src), slot_back)

/mob/living/carbon/human/fake_waldo
	nodamage = 1
	New()
		..()
		spawn(0)
			src.gender = "male"
			src.bioHolder.mobAppearance.s_tone = pick(0, -140, -50)
			src.real_name = "[pick(prob(150); "W", "V")][pick(prob(150); "a", "au", "o", "e")][pick(prob(150); "l", "ll")][pick(prob(150); "d", "t")][pick(prob(150); "o", "oh", "a", "e")]"

			spawn(10)
				bioHolder.mobAppearance.UpdateMob()

			var/shoes = text2path("/obj/item/clothing/shoes/" + pick("black","brown","red"))
			src.equip_if_possible(new shoes(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/under/gimmick/fake_waldo(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/device/radio/headset(src), slot_ears)
			src.equip_if_possible(new /obj/item/storage/backpack(src), slot_back)
			if(prob(75))
				src.equip_if_possible(new /obj/item/clothing/head/fake_waldohat(src), slot_head)
			else if(prob(20))
				src.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(src), slot_glasses)
			walk(src, pick(cardinal), 1)
			sleep(rand(150, 600))
			illusion_expire()
	Life(datum/controller/process/mobs/parent)
		if (..(parent))
			return 1
		if(prob(33) && canmove && isturf(loc))
			step(src, pick(cardinal))
	proc/illusion_expire(mob/user)
		if(user)
			boutput(user, "<span style=\"color:red\"><B>You reach out to attack the Waldo illusion but it explodes into dust, knocking you off your feet!</B></span>")
			user.weakened = max(user.weakened, 4)
		for(var/mob/M in viewers(src, null))
			if(M.client && M != user)
				M.show_message("<span style=\"color:red\"><b>The Waldo illusion explodes into smoke!</b></span>")
		var/datum/effects/system/harmless_smoke_spread/smoke = new /datum/effects/system/harmless_smoke_spread()
		smoke.set_up(1, 0, src.loc)
		smoke.start()
		spawn(0)
			qdel(src)
		return
	attack_hand(mob/user)
		return illusion_expire(user)
	attackby(obj/item/W, mob/user)
		return illusion_expire(user)
	MouseDrop(mob/M)
		if(iscarbon(M) && !M.handcuffed)
			return illusion_expire(M)

/mob/living/carbon/human/don_glab
	real_name = "Donald \"Don\" Glabs"
	gender = MALE

	New()
		..()
		spawn(0)
			bioHolder.age = 44
			bioHolder.bloodType = "Worchestershire"
			bioHolder.mobAppearance.customization_first = "Pompadour"
			bioHolder.mobAppearance.customization_first_color = "#F6D646"
			bioHolder.mobAppearance.gender = "male"
			bioHolder.mobAppearance.underwear = "boxers"
			spawn(10)
				bioHolder.mobAppearance.UpdateMob()

			src.equip_if_possible(new /obj/item/clothing/shoes/orange(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/under/suit/red(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/glasses/sunglasses, slot_glasses)
			src.equip_if_possible(new /obj/item/clothing/head/cowboy(src), slot_head)

	attack_hand(mob/M)
		..()
		if (M.a_intent in list(INTENT_HARM,INTENT_DISARM,INTENT_GRAB))
			for (var/mob/living/carbon/human/npc/diner_bartender/BT in all_viewers(7, src))
				BT.protect_from(M, src)

	attackby(obj/item/W, mob/M)
		var/tmp/oldbloss = get_brute_damage()
		var/tmp/oldfloss = get_burn_damage()
		..()
		var/tmp/damage = ((get_brute_damage() - oldbloss) + (get_burn_damage() - oldfloss))
		if ((damage > 0) || W.force)
			for (var/mob/living/carbon/human/npc/diner_bartender/BT in all_viewers(7, src))
				BT.protect_from(M, src)

/mob/living/carbon/human/tommy
	sound_list_laugh = list('sound/voice/tommy_hahahah.ogg', 'sound/voice/tommy_hahahaha.ogg')
	sound_list_scream = list('sound/voice/tommy_you-are-tearing-me-apart-lisauh.ogg', 'sound/voice/tommy_did-not-hit-hehr.ogg')
	sound_list_flap = list('sound/voice/tommy_weird-chicken-noise.ogg')

	New()
		..()
		spawn(0)
			src.real_name = Create_Tommyname()

			src.gender = "male"
			bioHolder.mobAppearance.customization_first = "Dreadlocks"
			bioHolder.mobAppearance.gender = "male"
			bioHolder.mobAppearance.s_tone = -15
			bioHolder.AddEffect("accent_tommy")
			spawn(10)
				bioHolder.mobAppearance.UpdateMob()

			src.equip_if_possible(new /obj/item/clothing/shoes/black {cant_drop = 1; cant_other_remove = 1; cant_self_remove = 1} (src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/under/suit {cant_drop = 1; cant_other_remove = 1; cant_self_remove = 1} (src), slot_w_uniform)

			src.equip_if_possible(new /obj/item/device/radio/headset(src), slot_ears)
			src.equip_if_possible(new /obj/item/storage/backpack(src), slot_back)
			src.equip_if_possible(new /obj/item/football(src), slot_in_backpack)

/mob/living/carbon/human/secret
	// Cannot be observed
	real_name = "unobservable"