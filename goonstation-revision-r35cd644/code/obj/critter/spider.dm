
/obj/critter/nicespider
	name = "bumblespider"
	desc = "It seems pretty friendly. D'aww."
	icon_state = "bumblespider"
	health = 30
	aggressive = 1
	defensive = 1
	wanderer = 1
	opensdoors = 0
	atkcarbon = 0
	atksilicon = 0
	density = 0
	sleeping_icon_state = "bumblespider-sleep"
	var/venom1 = "venom"
	var/spazzing = 0

	CritterAttack(mob/M)
		src.attacking = 1
		M.visible_message("<span style=\"color:red\"><b>[src]</b> nibbles [src.target]!</span>")
		random_brute_damage(M, rand(2,4))
		if(iscarbon(M) && M.reagents)
			M.reagents.add_reagent("[venom1]", 3)
		if(prob(15))
			spiderspaz(src.target)

		spawn(10)
			src.attacking = 0

	attack_hand(mob/user as mob)
		if (src.alive)
			if (user.a_intent == INTENT_HARM)
				return ..()
			else
				src.visible_message("<span style=\"color:red\"><b>[user]</b> [pick("pets","hugs","snuggles","cuddles")] [src]!</span>")
				if (prob(15))
					for (var/mob/O in hearers(src, null))
						O.show_message("[src] coos[prob(50) ? " happily!" : ""]!",2)
						playsound(src.loc, "sound/misc/babynoise.ogg", 40, 0)
				return
		else
			..()

		return

	proc/spiderspaz(mob/M) //todo: centralize this fucking mess of spiders into one base type
		if (spazzing)
			return

		spazzing = 10
		playsound(src.loc, "rustle", 50, 0)
		spawn(0)
			while(spazzing-- > 0 && src.alive)
				src.set_loc(M.loc)
				src.pixel_x = rand(-2,2) * 2
				src.pixel_y = rand(-2,2) * 2
				src.dir = pick(alldirs)
				if(prob(30))
					src.visible_message("<span style=\"color:red\"><B>[src]</B> bites [src.target]!</span>")
					playsound(src.loc, "rustle", 50, 1)
					random_brute_damage(src.target, rand(1,2))
					M.reagents.add_reagent("[venom1]", 2)
				sleep(4)
			src.pixel_x = 0
			src.pixel_y = 0
			if(spazzing < 0)
				spazzing = 0

/obj/item/reagent_containers/food/snacks/ingredient/egg/critter/nicespider
	name = "bumblespider egg"
	critter_type = /obj/critter/nicespider

/obj/critter/spider
	name = "space spider"
	desc = "A big ol' spider, from space. In space. A space spider."
	density = 1
	health = 50
	aggressive = 0
	defensive = 1
	wanderer = 1
	opensdoors = 0
	atkcarbon = 1
	atksilicon = 1
	firevuln = 0.65
	brutevuln = 0.45
	angertext = "scuttles towards"
	butcherable = 1
	var/spazzing = 0
	var/feeding = 0
	var/venom1 = "venom"  // making these modular so i don't have to rewrite this gigantic goddamn section for all the subtypes
	var/venom2 = "spiders"
	var/babyspider = 0
	var/adultpath = null
	var/bitesound = 'sound/weapons/handcuffs.ogg'
	var/stepsound = null
	var/deathsound = 'sound/effects/snap.ogg'
	death_text = "%src% crumples up into a ball!"
	var/encase_in_web = 1 // do they encase people in web or ice?
	var/reacting = 1 // when they inject their venom, does it react immediately or not?

	skinresult = /obj/item/material_piece/cloth/spidersilk
	max_skins = 4

	New()
		..()
		if (!icon_state && !babyspider)
			icon_state = pick("big_spide", "big_spide-red", "big_spide-green", "big_spide-blue")
			src.dead_state = "[src.icon_state]-dead"

	CritterDeath()
		if(!src.alive) return
		..()
		playsound(src.loc, src.deathsound, 50, 0)
		src.reagents.add_reagent(venom1, 50, null)
		src.reagents.add_reagent(venom2, 50, null)

	seek_target()
		src.anchored = 0
		if (src.target)
			src.task = "chasing"
			return
		for (var/mob/living/C in hearers(src.seekrange,src))
			if ((C.name == src.oldtarget_name) && (world.time < src.last_found + 100)) continue
			//if (C.stat || C.health < 0) continue
			if (C.bioHolder.HasEffect("husk")) continue
			src.target = C
			src.oldtarget_name = C.name
			src.task = "chasing"
			playsound(src.loc, "sound/effects/cat_hiss.ogg", 50, 1)
			src.visible_message("<span style=\"color:red\"><B>[src]</B> hisses!</span>")
			break

	Move()
		if (src.stepsound)
			if(prob(30))
				playsound(src.loc, src.stepsound, 50, 0)
		..()

	CritterAttack(mob/M)
		if(ismob(M))
			src.attacking = 1
			if (prob(20))
				src.visible_message("<span style=\"color:red\"><B>[src]</B> dives on [M]!</span>")
				playsound(src.loc, "sound/weapons/thudswoosh.ogg", 50, 0)
				M.weakened += rand(2,4)
				M.stunned += rand(1,3)
				random_brute_damage(M, rand(2,5))
				src.spiderspaz(src.target)
				if(!M.stat) M.emote("scream") // don't scream while dead/asleep // why?
			else
				src.visible_message("<span style=\"color:red\"><B>[src]</B> bites [src.target]!</span>")
				playsound(src.loc, src.bitesound, 50, 1)
				if(ishuman(M))
					random_brute_damage(src.target, rand(1,2))
					src.reagents.add_reagent("[venom1]", 2) // doing this instead of directly adding reagents to M should give people the correct messages
					src.reagents.add_reagent("[venom2]", 2)
					if (src.reacting)
						src.reagents.reaction(M, INGEST)
					else
						src.reagents.trans_to(M, 4)
				else if(issilicon(M))
					switch(rand(1,4))
						if(1)
							M:compborg_take_critter_damage("r_arm", rand(2,4))
						if(2)
							M:compborg_take_critter_damage("l_arm", rand(2,4))
						if(3)
							M:compborg_take_critter_damage("r_leg", rand(2,4))
						if(4)
							M:compborg_take_critter_damage("l_leg", rand(2,4))
			if(ishuman(M))
				if(M.stat == 1) // kill KOd people faster
					src.set_loc(M.loc)
					src.visible_message("<span style=\"color:red\"><B>[src]</B> jumps onto [src.target]!</span>")
					sleep(5)
					src.visible_message("<span style=\"color:red\"><B>[src]</B> sinks its fangs into [src.target]!</span>")
					playsound(src.loc, "sound/misc/fuse.ogg", 50, 1)
					src.reagents.add_reagent("[venom1]", 5) // doing this instead of directly adding reagents to M should give people the correct messages
					src.reagents.add_reagent("[venom2]", 5)
					if (src.reacting)
						src.reagents.reaction(M, INGEST)
					else
						src.reagents.trans_to(M, 10)
					random_brute_damage(M, rand(2,5))

				if(M.stat == 2 && !feeding) // drain corpses into husks
					if(ishuman(M))
						var/mob/living/carbon/human/T = M
						feeding = 1
						src.spiderspaz(src.target)
						src.visible_message("<span style=\"color:red\"><B>[src]</B> starts draining the fluids out of [T]!</span>")
						src.set_loc(T.loc)
						sleep(20)
						playsound(src.loc, "sound/misc/pourdrink.ogg", 50, 1)
						sleep(50)
						if(src.target && T.stat && src.loc == T.loc) // check to see if the target is still passed out and under the spider
							src.visible_message("<span style=\"color:red\"><B>[src]</B> drains [T] dry!</span>")
							T.death(0)
							T.real_name = "Unknown"
							T.bioHolder.AddEffect("husk")
							sleep(2)
							playsound(src.loc, "sound/misc/fuse.ogg", 50, 1)
							src.set_loc(get_step(src, pick(alldirs))) // get the fuck out of the way of the ice cube
							sleep(2)
							var/obj/icecube/cube = new /obj/icecube(get_turf(M), M)
							M.set_loc(cube)
							if (src.encase_in_web)
								src.visible_message("<span style=\"color:red\"><B>[src]</B> encases [src.target] in web!</span>")
								cube.name = "bundle of web"
								cube.desc = "A big wad of web. Someone seems to be stuck inside it."
								cube.icon_state = "web2"
								cube.steam_on_death = 0
							else
								src.visible_message("<span style=\"color:red\"><B>[src]</B> encases [src.target] in ice!</span>")

							feeding = 0
							if (babyspider) // dawww
								src.visible_message("<span style=\"color:red\"><B>[src]</B> grows up!</span>")
								var/adult = text2path(src.adultpath)
								new adult(src.loc)
								qdel(src)
						else
							feeding = 0

			spawn(20)
				src.attacking = 0

	ChaseAttack(mob/M)
		playsound(src.loc, "sound/effects/cat_hiss.ogg", 50, 1)
		src.visible_message("<span style=\"color:red\"><B>[src]</B> hisses!</span>")
		if (prob(30))
			src.visible_message("<span style=\"color:red\"><B>[src]</B> dives on [M]!</span>")
			playsound(src.loc, pick("sound/weapons/thudswoosh.ogg"), 50, 0)
			M.weakened += rand(2,4)
			M.stunned += rand(1,3)
			random_brute_damage(M, rand(2,5))
			src.spiderspaz(src.target)
			if(!M.stat) M.emote("scream") // don't scream while dead or KOd
		else src.visible_message("<span style=\"color:red\"><B>[src]</B> dives at [M], but misses!</span>")

	on_pet()
		playsound(src.loc, 'sound/misc/babynoise.ogg', 50, 1)
		src.visible_message("<span style=\"color:red\"><b>[src] coos!</b></span>", 1)

	proc/spiderspaz(mob/M)
		if (spazzing)
			return

		spazzing = 10
		if (src.stepsound)
			playsound(src.loc, src.stepsound, 50, 0)
		spawn(0)
			while(spazzing-- > 0 && src.alive)
				src.set_loc(M.loc)
				src.pixel_x = rand(-2,2) * 2
				src.pixel_y = rand(-2,2) * 2
				src.dir = pick(alldirs)
				if(prob(30))
					src.visible_message("<span style=\"color:red\"><B>[src]</B> bites [src.target]!</span>")
					playsound(src.loc, src.bitesound, 50, 1)
					if(ishuman(M))
						random_brute_damage(src.target, rand(1,2))
						src.reagents.add_reagent("[venom1]", 2) // doing this instead of directly adding reagents to M should give people the correct messages
						src.reagents.add_reagent("[venom2]", 2)
						if (src.reacting)
							src.reagents.reaction(M, INGEST)
						else
							src.reagents.trans_to(M, 4)
					else if(issilicon(M))
						switch(rand(1,4))
							if(1)
								M:compborg_take_critter_damage("r_arm", rand(2,4))
							if(2)
								M:compborg_take_critter_damage("l_arm", rand(2,4))
							if(3)
								M:compborg_take_critter_damage("r_leg", rand(2,4))
							if(4)
								M:compborg_take_critter_damage("l_leg", rand(2,4))
				sleep(4)
			src.pixel_x = 0
			src.pixel_y = 0
			if(spazzing < 0)
				spazzing = 0

/obj/critter/spider/baby
	name = "li'l space spider"
	desc = "A li'l tiny spider, from space. In space. A space spider."
	icon_state = "lil_spide"
	density = 0
	health = 1
	venom1 = "toxin"
	venom2 = "black_goop"
	babyspider = 1
	max_skins = 1
	adultpath = "/obj/critter/spider"

	// don't ask
	proc/streak(var/list/directions)
		spawn (0)
			for (var/i = 0, i < pick(1, 200; 2, 150; 3, 50; 4), i++)
				sleep(3)
				if (step_to(src, get_step(src, pick(directions)), 0))
					break

/obj/item/reagent_containers/food/snacks/ingredient/egg/critter/spider
	name = "spider egg"
	critter_type = /obj/critter/spider/baby
	critter_reagent = "spiders"

/obj/critter/spider/ice
	name = "ice spider"
	desc = "It seems to be adapted to a frozen climate."
	icon_state = "icespider"
	density = 1
	health = 20
	aggressive = 1
	firevuln = 1.5
	brutevuln = 0.5
	hitsound = 'sound/effects/crystalhit.ogg'
	venom1 = "toxin"
	venom2 = "cryostylane"
	babyspider = 0
	bitesound = 'sound/effects/crystalhit.ogg'
	stepsound = 'sound/misc/glass_step.ogg'
	deathsound = 'sound/effects/crystalshatter.ogg'
	encase_in_web = 0
	max_skins = 4
	reacting = 0

/// subtypes

/obj/critter/spider/ice/baby
	name = "baby ice spider"
	desc = "Dawww."
	icon_state = "babyicespider"
	density = 0
	health = 1
	venom1 = "toxin"
	venom2 = "cryostylane"
	babyspider = 1
	max_skins = 1
	adultpath = "/obj/critter/spider/ice"

/obj/item/reagent_containers/food/snacks/ingredient/egg/critter/icespider
	name = "ice spider egg"
	critter_type = /obj/critter/spider/ice/baby
	warm_count = 25
	critter_reagent = "spidereggs"

/obj/critter/spider/ice/queen
	name = "queen ice spider"
	desc = "AHHHHHHH"
	icon_state = "gianticespider"
	density = 1
	health = 100
	venom1 = "morphine"
	venom2 = "spidereggs"

	skinresult = /obj/item/material_piece/cloth/spidersilk
	max_skins = 8

/obj/critter/spider/ice/nice
	name = "nice spider"
	desc = "Aww, hi there!"
	aggressive = 0
	defensive = 0
	atkcarbon = 0
	atksilicon = 0
	venom1 = "hugs"
	venom2 = "glitter_harmless"

/obj/critter/spider/ice/queen/nice
	name = "queen nice spider"
	desc = "AWWWWWWW!"
	icon_state = "gianticespider"
	aggressive = 0
	defensive = 0
	atkcarbon = 0
	atksilicon = 0
	venom1 = "hugs"
	venom2 = "glitter_harmless"

/obj/critter/spider/spacerachnid // you get to be in here TOO
	name = "spacerachnid"
	desc = "A rather large spider."
	icon_state = "spider"
	density = 1
	health = 10
	aggressive = 1
	defensive = 0
	wanderer = 1
	opensdoors = 1
	atkcarbon = 1
	atksilicon = 1
	atcritter = 1
	firevuln = 0.65
	brutevuln = 0.45
	venom1 = "venom"
	venom2 = "venom"
	death_text = "%src% is squashed!"

/obj/item/reagent_containers/food/snacks/ingredient/egg/critter/spacerachnid
	name = "spacerachnid egg"
	critter_type = /obj/critter/spider/spacerachnid
	critter_reagent = "spiders"
