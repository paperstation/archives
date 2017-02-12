/obj/critter/floateye
	name = "floating thing"
	desc = "You have never seen something like this before."
	icon_state = "floateye"
	health = 10
	aggressive = 0
	defensive = 0
	wanderer = 1
	opensdoors = 0
	atkcarbon = 0
	atksilicon = 0
	butcherable = 1
	flying = 1

/obj/critter/roach
	name = "cockroach"
	desc = "An unpleasant insect that lives in filthy places."
	icon_state = "roach"
	density = 0
	health = 10
	aggressive = 0
	defensive = 0
	wanderer = 1
	opensdoors = 0
	atkcarbon = 0
	atksilicon = 0
	butcherable = 1

	attack_hand(mob/user as mob)
		if (src.alive && (user.a_intent != INTENT_HARM))
			src.visible_message("<span class='combat'><b>[user]</b> pets [src]!</span>")
			return
		if(prob(95))
			src.visible_message("<span class='combat'><B>[user] stomps [src], killing it instantly!</B></span>")
			CritterDeath()
			return
		..()

/obj/critter/mouse/remy
	name = "Remy"
	desc = "A rat.  In space... wait, is it wearing a chefs hat?"
	icon_state = "remy"
	health = 33
	aggressive = 0

/obj/critter/mouse
	name = "space-mouse"
	desc = "A mouse.  In space."
	icon_state = "mouse"
	density = 0
	health = 2
	aggressive = 1
	defensive = 1
	wanderer = 1
	opensdoors = 0
	atkcarbon = 0
	atksilicon = 0
	firevuln = 1
	brutevuln = 1
	butcherable = 1
	chases_food = 1
	health_gain_from_food = 2
	feed_text = "squeaks happily!"
	var/diseased = 0

	skinresult = /obj/item/material_piece/cloth/leather //YEP
	max_skins = 1

	New()
		..()
		if(prob(10))
			diseased = 1
		atkcarbon = diseased

	CritterAttack(mob/living/M)
		src.attacking = 1
		src.visible_message("<span class='combat'><B>[src]</B> bites [src.target]!</span>")
		random_brute_damage(src.target, 1)
		spawn(10)
			src.attacking = 0
		if(iscarbon(M))
			if(diseased && prob(10))
				if(prob(50))
					M.contract_disease(/datum/ailment/disease/berserker, null, null, 1) // path, name, strain, bypass resist
				else
					M.contract_disease(/datum/ailment/disease/space_madness, null, null, 1) // path, name, strain, bypass resist

/*	seek_target()
		if(src.target)
			src.task = "chasing"
			return
		var/list/visible = new()
		for(var/obj/item/reagent_containers/food/snacks/S in view(src.seekrange,src))
			visible.Add(S)
		if(src.food_target && visible.Find(src.food_target))
			src.task = "chasing food"
			return
		else src.task = "thinking"
		if(visible.len)
			src.food_target = visible[1]
			src.task = "chasing food"
		..()

	ai_think()
		if(task == "chasing food")
			if(src.food_target == null)
				src.task = "thinking"
			else if(get_dist(src, src.food_target) <= src.attack_range)
				src.task = "eating"
			else
				walk_to(src, src.food_target,1,4)
		else if(task == "eating")
			if (get_dist(src, src.food_target) > src.attack_range)
				src.task = "chasing food"
			else
				src.visible_message("<b>[src]</b> nibbles at [src.food_target].")
				playsound(src.loc,"sound/items/eatfood.ogg", rand(10,50), 1)
				if (food_target.reagents.total_volume > 0 && src.reagents.total_volume < 30)
					food_target.reagents.trans_to(src, 5)
				src.food_target.amount--
				spawn(25)
				if(src.food_target != null && src.food_target.amount <= 0)
					qdel(src.food_target)
					src.task = "thinking"
					src.food_target = null
		return ..()
*/
/obj/critter/opossum
	name = "space opossum"
	desc = "A possum that came from space. Or maybe went to space. Who knows how it got here?"
	icon_state = "possum"
	density = 1
	health = 15
	aggressive = 1
	defensive = 1
	wanderer = 1
	opensdoors = 0
	atkcarbon = 0
	atksilicon = 0
	firevuln = 1
	brutevuln = 1
	butcherable = 1
	pet_text = list("gently baps", "pets", "cuddles")

	skinresult = /obj/item/material_piece/cloth/leather
	max_skins = 1

	on_revive()
		..()
		src.visible_message("<span style=\"color:blue\"><b>[src]</b> stops playing dead and gets back up!</span>")
		src.alive = 1
		src.density = 1
		src.health = initial(src.health)
		src.icon_state = src.living_state ? src.living_state : initial(src.icon_state)
		src.target = null
		src.task = "wandering"
		return

	CritterDeath()
		..()
		spawn(rand(200,800))
			if (src)
				src.on_revive()
		return

/obj/critter/opossum/morty
	name = "Morty"
	generic = 0

var/list/cat_names = list("Gary", "Mittens", "Mr. Jingles", "Rex", "Jasmine", "Litterbox",
"Reginald", "Poosycat", "Dr. Purrsworthy", "Lt. Scratches", "Michael Catson",
"Fluffy", "Mr. Purrfect", "Lord Furstooth", "Lion-O", "Johnathan", "Gary Catglitter",
"Kitler", "Benito Mewssolini", "Chat de Gaulle", "Ratbag",
"Baron Fuzzykins, Defiler of Carpets", "Robert Meowgabe", "Chairman Meow", "Bacon",
"Prunella", "Poonella", "SEXCOPTER", "Fat, Lazy Piece of Shit", "Jones Mk. II",
"Jones Mk. III", "Jones Mk. IV", "Jones Mk.V", "Mr. Meowgi",
"Furrston von Purringsworth", "Garfadukecliff", "SyndiCat", "Rosa Fluffemberg",
"Karl Meowx", "Margaret Scratcher", "Marcel Purroust", "Franz Katka", "Das Katpital",
"Proletaricat", "Perestroikat", "Mewy P. Newton", "Fidel Catstro", "George Lucats",
"Lin Miao", "Felix Purrzhinsky", "Pol Pet", "Piggy", "Long Kitty")

// hi I added my childhood cats' names to the list cause I miss em, they aren't really funny names but they were great cats
// remove em if you want I guess
// - Haine

/obj/critter/cat
	name = "space-cat"
	desc = "A cat. In space."
	icon_state = "cat1"
	density = 0
	health = 10
	aggressive = 1
	defensive = 1
	wanderer = 1
	opensdoors = 0
	atkcarbon = 0
	atksilicon = 0
	firevuln = 1
	brutevuln = 1
	angertext = "hisses at"
	butcherable = 2
	var/cattype = 1
	var/randomize_cat = 1
	var/catnip = 0

	New()
		..()
		if (src.randomize_cat)
			src.name = pick(cat_names)

#ifdef HALLOWEEN
			src.cattype = 3 //Black cats for halloween.
			icon_state = "cat3"
#else
			src.cattype = rand(2,9)
			icon_state = "cat[cattype]"
#endif

	seek_target()
		src.anchored = 0
		for (var/obj/critter/mouse/C in view(src.seekrange,src))
			if (src.target)
				src.task = "chasing"
				break
			if ((C.name == src.oldtarget_name) && (world.time < src.last_found + 100)) continue
			if (C.health < 0) continue

			src.attack = 1

			if (src.attack)
				src.target = C
				src.oldtarget_name = C.name
				src.visible_message("<span class='combat'><b>[src]</b> [src.angertext] [C.name]!</span>")
				src.task = "chasing"
				break
			else
				continue

	attackby(obj/item/W as obj, mob/living/user as mob)
		if (src.alive && istype(W, /obj/item/plant/herb/catnip))
			user.visible_message("<b>[user]</b> gives [src.name] the [W]!","You give [src.name] the [W].")
			src.catnip_effect()
			qdel(W)
		else
			..()

	CritterAttack(mob/M)
		if(ismob(M))
			src.attacking = 1
			var/attackCount = (src.catnip ? rand(4,8) : 1)
			while(attackCount-- > 0)
				src.visible_message("<span class='combat'><B>[src]</B> bites [src.target]!</span>")
				random_brute_damage(src.target, 2)
				sleep(2)

			spawn(10)
				src.attacking = 0

		else if(istype(M, /obj/critter/mouse)) //robust cat simulation.
			src.attacking = 1
			src.visible_message("<span class='combat'><b>[src]</b> bites [src.target]!</span>")
			src.target:health -= 2
			if(src.target:health <= 0 && src.target:alive)
				src.target:CritterDeath()
				src.attacking = 0

		return

	ChaseAttack(mob/M)
		src.visible_message("<span class='combat'><B>[src]</B> pounces on [M]!</span>")
		playsound(src.loc, "sound/weapons/genhit1.ogg", 50, 1, -1)

		if(ismob(M))
			M.stunned += rand(0,2)
			M.weakened += rand(0,1)

	attack_hand(mob/user as mob)
		if (src.alive && (user.a_intent != INTENT_HARM))
			src.visible_message("<span class='combat'><b>[user]</b> pets [src]!</span>")
			if(prob(10))
				for(var/mob/O in hearers(src, null))
					O.show_message("[src] purrs!",2)
			return
		else
			..()

		return

	CritterDeath()
		src.alive = 0
		density = 0
		src.icon_state = "cat[cattype]-dead"
		walk_to(src,0)
		src.visible_message("<b>[src]</b> dies!")
		if(prob(5))
			spawn(30)
				src.visible_message("<b>[src]</b> comes back to life, good thing he has 9 lives!")
				src.alive = 1
				density = 1
				src.health = 10
				src.icon_state = "cat[cattype]"
				return

	process()
		if(!..())
			return 0
		if (src.alive && src.catnip)

			spawn(0)
				var/x = rand(2,4)
				while (x-- > 0)
					src.pixel_x = rand(-6,6)
					src.pixel_y = rand(-6,6)
					sleep(2)

			if (prob(10))
				src.visible_message("[src.name] [pick("purrs","frolics","rolls about","does a cute cat thing of some sort")]!")

			if (src.catnip-- < 1)
				src.visible_message("[src.name] calms down.")

	proc/catnip_effect()
		if (src.catnip)
			return
		src.catnip = 45
		src.visible_message("[src.name]'s eyes dilate.")

	HasEntered(mob/living/carbon/M as mob)
		..()
		if (src.sleeping || !src.alive)
			return
		else if (ishuman(M) && prob(33))
			src.visible_message("<span class='combat'>[src] weaves around [M]'s legs and trips [him_or_her(M)]!</span>")
			M:weakened += 2
		return

/obj/critter/cat/jones
	name = "Jones"
	desc = "Jones the cat."
	icon_state = "cat1"
	health = 30
	randomize_cat = 0
	generic = 0

	emag_act(var/mob/user, var/obj/item/card/emag/E)
		if (!src.alive || (cattype == 7))
			return 0
		src.icon_state = "cat-emagged"
		cattype = 7
		if (user)
			user.show_text("You swipe down [src]'s back in a petting motion...")
		return 1

	attackby(obj/item/W as obj, mob/living/user as mob)
		if (istype(W, /obj/item/card/emag))
			emag_act(usr, W)
		else
			..()

/obj/critter/cat/goddamnittobba
	aggressive = 1
	New()
		..()
		src.catnip = rand(50,250)

	CritterAttack(mob/M)
		if(ismob(M))
			src.attacking = 1
			var/attackCount = (src.catnip ? rand(4,8) : 1)
			while(attackCount-- > 0)
				src.visible_message("<span class='combat'><B>[src]</B> claws at [src.target]!</span>")
				random_brute_damage(src.target, 6)
				sleep(2)

			spawn(10)
				src.attacking = 0

/obj/critter/dog/george
	name = "George"
	desc = "Good dog."
	icon_state = "george"
	var/doggy = "george"
	density = 1
	health = 100
	aggressive = 1
	defensive = 1
	wanderer = 1
	opensdoors = 0
	atkcarbon = 0
	atksilicon = 0 //set to 1 for robots as space cars
	firevuln = 1
	brutevuln = 1
	angertext = "growls at"
	butcherable = 0
	generic = 0
/*
	seek_target()
		src.anchored = 0
		for (var/obj/critter/cat/C in view(src.seekrange,src))
			if (src.target)
				src.task = "chasing"
				break
			if ((C.name == src.oldtarget_name) && (world.time < src.last_found + 100)) continue
			if (C.health < 0) continue

			src.attack = 1

			if (src.attack)
				src.target = C
				src.oldtarget_name = C.name
				src.visible_message("<span class='combat'><b>[src]</b> [src.angertext] [C.name]!</span>")
				src.task = "chasing"
				break
			else
				continue
*/
	CritterAttack(mob/M)
		if(ismob(M))
			src.attacking = 1
			src.visible_message("<span class='combat'><B>[src]</B> bites [src.target]!</span>")
			random_brute_damage(src.target, 2)
			spawn(10)
				src.attacking = 0

	/*	else if(istype(M, /obj/critter/cat)) //uncomment for robust dog simulation.
			src.attacking = 1
			src.visible_message("<span class='combat'><b>[src]</b> bites [src.target]!</span>")
			src.target:health -= 2
			if(src.target:health <= 0 && src.target:alive)
				src.target:CritterDeath()
				src.attacking = 0 */

		return

	ChaseAttack(mob/M)
		src.visible_message("<span class='combat'><B>[src]</B> jumps on [M]!</span>")
		playsound(src.loc, "sound/weapons/genhit1.ogg", 50, 1, -1)

		if(ismob(M))
			M.stunned += rand(0,2)
			M.weakened += rand(0,1)

	attack_hand(mob/user as mob)
		if (src.alive && (user.a_intent != INTENT_HARM))
			src.visible_message("<span class='combat'><b>[user]</b> pets [src]!</span>")
			if(prob(30))
				src.icon_state = "[src.doggy]-lying"
				for(var/mob/O in hearers(src, null))
					O.show_message("<span style=\"color:blue\"><B>[src]</B> flops on his back! Scratch that belly!</span>",2)
				spawn(30)
				src.icon_state = "[src.doggy]"
			return
		else
			..()

		return

	CritterDeath()
		src.alive = 0
		density = 0
		src.icon_state = "[src.doggy]-lying"
		walk_to(src,0)
		for(var/mob/O in hearers(src, null))
			O.show_message("<span class='combat'><b>[src]</b> [pick("tires","tuckers out","gets pooped")] and lies down!</span>")
		spawn(600)
			for(var/mob/O in hearers(src, null))
				O.show_message("<span style=\"color:blue\"><b>[src]</b> wags his tail and gets back up!</span>")
			src.alive = 1
			density = 1
			src.health = 100
			src.icon_state = "[src.doggy]"
		return

	proc/howl()
		if(prob(60))
			for(var/mob/O in hearers(src, null))
				O.show_message("<span class='combat'><b>[src]</b> [pick("howls","bays","whines","barks","croons")] to the music! He thinks he's singing!</span>")
				spawn(3)
				playsound(src.loc, pick("sound/misc/howl1.ogg","sound/misc/howl2.ogg","sound/misc/howl3.ogg","sound/misc/howl4.ogg","sound/misc/howl5.ogg","sound/misc/howl6.ogg"), 100, 0)

/obj/critter/dog/george/blair
	name = "Blair"
	icon_state = "pug"
	doggy = "pug"

/obj/critter/pig
	name = "space-pig"
	desc = "A pig. In space."
	icon_state = "pig"
	density = 1
	health = 15
	aggressive = 0
	defensive = 1
	wanderer = 1
	opensdoors = 0
	atkcarbon = 0
	atksilicon = 0
	firevuln = 1
	brutevuln = 1
	angertext = "oinks at"
	butcherable = 1
	meat_type = /obj/item/reagent_containers/food/snacks/ingredient/meat/bacon
	name_the_meat = 0

	skinresult = /obj/item/material_piece/cloth/leather
	max_skins = 2

	CritterDeath()
		..()
		src.reagents.add_reagent("beff", 50, null)
		return

	seek_target()
		src.anchored = 0
		for (var/obj/critter/mouse/C in view(src.seekrange,src))
			if (src.target)
				src.task = "chasing"
				break
			if ((C.name == src.oldtarget_name) && (world.time < src.last_found + 100)) continue
			if (C.health < 0) continue

			src.attack = 1

			if (src.attack)
				src.target = C
				src.oldtarget_name = C.name
				src.visible_message("<span class='combat'><b>[src]</b> [src.angertext] [C.name]!</span>")
				src.task = "chasing"
				break
			else
				continue

	CritterAttack(mob/M)
		if(ismob(M))
			src.attacking = 1
			src.visible_message("<span class='combat'><B>[src]</B> bites [src.target]!</span>")
			random_brute_damage(src.target, 2)
			spawn(10)
				src.attacking = 0
		return

	ChaseAttack(mob/M)
		src.visible_message("<span class='combat'><B>[src]</B> bites [M]!</span>")
		playsound(src.loc, "sound/weapons/genhit1.ogg", 50, 1, -1)

		if(ismob(M))
			M.stunned += rand(0,2)
			M.weakened += rand(0,1)

	on_pet()
		if(prob(10))
			for(var/mob/O in hearers(src, null))
				O.show_message("[src] purrs!",2)

/obj/critter/clownspider
	name = "clownspider"
	desc = "Holy shit, that's fucking creepy."
	icon_state = "clownspider"
	health = 5
	aggressive = 0
	defensive = 1
	wanderer = 1
	opensdoors = 0
	atkcarbon = 1
	atksilicon = 1
	butcherable = 0
	angertext = "honks angrily at"
	var/sound_effect = 'sound/items/bikehorn.ogg'
	var/item_shoes = /obj/item/clothing/shoes/clown_shoes
	var/item_mask = /obj/item/clothing/mask/clown_hat

	cluwne
		name = "cluwnespider"
		desc = "Oh my god, what is this thing?"
		icon_state = "cluwnespider"
		sound_effect = 'sound/voice/cluwnelaugh3.ogg'
		item_shoes = /obj/item/clothing/shoes/cursedclown_shoes
		item_mask = /obj/item/clothing/mask/cursedclown_hat

	attack_hand(mob/user as mob)
		if (src.alive && (user.a_intent != INTENT_HARM))
			src.visible_message("<span class='combat'><b>[user]</b> [src.pet_text] [src]!</span>")
			return
		if(prob(50))
			src.visible_message("<span class='combat'><B>[user] stomps [src], killing it instantly!</B></span>")
			CritterDeath()
			return
		..()

	CritterAttack(mob/M)
		if(ismob(M))
			src.attacking = 1
			src.visible_message("<span class='combat'><B>[src]</B> kicks [src.target] with its shoes!</span>")
			playsound(src.loc, "swing_hit", 30, 0)
			if(prob(10))
				playsound(src.loc, src.sound_effect, 50, 0)
			random_brute_damage(src.target, rand(0,1))
			spawn(10)
				src.attacking = 0

	ChaseAttack(mob/M)
		src.visible_message("<span class='combat'><B>[src]</B> [src.angertext] [M]!</span>")
		playsound(src.loc, src.sound_effect, 50, 0)
		M.stunned += rand(0,1)
		if(prob(25))
			M.weakened += rand(1,2)
			random_brute_damage(M, rand(1,2))

	CritterDeath()
		src.alive = 0
		playsound(src.loc, "sound/effects/splat.ogg", 75, 1)
		var/obj/decal/cleanable/blood/gibs/gib = null
		gib = new /obj/decal/cleanable/blood/gibs(src.loc)
		new src.item_shoes(src.loc)
		if (prob(25))
			new src.item_mask(src.loc)
		gib.streak(list(NORTH, NORTHEAST, NORTHWEST))
		qdel (src)

/obj/critter/owl
	name = "space owl"
	desc = "Did you know? By 2063, it is expected that there will be more owls on Earth than human beings."
	icon_state = "smallowl"
	density = 1
	health = 10
	aggressive = 1
	defensive = 1
	wanderer = 1
	opensdoors = 0
	atkcarbon = 0
	atksilicon = 0
	firevuln = 1
	brutevuln = 1
	angertext = "hoots at"
	butcherable = 2
	flying = 1

	attackby(obj/item/W as obj, mob/M as mob)
		if(istype(W,/obj/item/clothing/head/void_crown))
			var/data[] = new()
			data["ckey"] = M.ckey
			data["compID"] = M.computer_id
			data["ip"] = M.lastKnownIP
			data["reason"] = "Get out you nerd. Also, stop abusing your access to the commit messages."
			data["mins"] = 1440
			data["akey"] = "NERDBANNER"
			boutput(M, "<span style=\"color:red\"><BIG><B>WELP, GUESS YOU SHOULDN'T BELIEVE EVERYTHING YOU READ!</B></BIG></span>")
			addBan(1, data)
			del(M.client)
		else
			return ..(W, M)

	CritterAttack(mob/M)
		if(ismob(M))
			src.attacking = 1
			src.visible_message("<span class='combat'><B>[src]</B> pecks at [src.target]!</span>")
			random_brute_damage(src.target, 2)
			spawn(10)
				src.attacking = 0

		return

	ChaseAttack(mob/M)
		src.visible_message("<span class='combat'><B>[src]</B> swoops down upon [M]!</span>")
		playsound(src.loc, "sound/weapons/genhit1.ogg", 50, 1, -1)
		random_brute_damage(src.target, 1)

		return

/obj/item/reagent_containers/food/snacks/ingredient/egg/critter/owl
	name = "owl egg"
	critter_type = /obj/critter/owl

/obj/critter/goose
	name = "space goose"
	desc = "An offshoot species of <i>branta canadensis</i> adapted for space."
	icon_state = "goose"
	density = 1
	health = 20
	aggressive = 1
	defensive = 1
	wanderer = 1
	opensdoors = 1
	atkcarbon = 0
	atksilicon = 0
	firevuln = 1
	brutevuln = 1
	angertext = "hisses angrily at"
	butcherable = 1
	death_text = "%src% collapses and stops moving!"

	ai_think()
		..()
		if (task == "thinking" || task == "wandering")
			if (prob(20))
				if (!src.muted)
					src.visible_message("<b>[src]</b> honks!")
				playsound(src.loc, "sound/effects/goose.ogg", 70, 1)
		else
			if (prob(20))
				flick("goose2", src)
				playsound(src.loc, "sound/effects/cat_hiss.ogg", 50, 1)

	seek_target()
		..()
		if (src.target)
			flick("goose2", src)
			src.visible_message("<span class='combat'><b>[src]</b> [src.angertext] [src.target]!</span>")
			playsound(src.loc, "sound/effects/cat_hiss.ogg", 50, 1)

	CritterAttack(mob/M)
		if (ismob(M))
			src.attacking = 1
			flick("goose2", src)
			src.visible_message("<span class='combat'><B>[src]</B> bites [src.target]!</span>")
			playsound(src.loc, "swing_hit", 30, 0)
			random_brute_damage(src.target, 2)
			spawn(rand(1,10))
				src.attacking = 0
		return

	ChaseAttack(mob/M)
		flick("goose2", src)
		src.visible_message("<span class='combat'><B>[src]</B> tackles [M]!</span>")
		playsound(src.loc, "sound/weapons/genhit1.ogg", 50, 1, -1)

		if(ismob(M))
			M.stunned += rand(0,2)
			M.weakened += rand(0,1)

	on_pet()
		if(prob(10))
			src.visible_message("<b>[src]</b> honks!",2)
			playsound(src.loc, "sound/effects/goose.ogg", 50, 1)

/obj/item/reagent_containers/food/snacks/ingredient/egg/critter/goose
	name = "goose egg"
	critter_type = /obj/critter/goose

#define PARROT_MAX_WORDS 64		// may as well try and be careful I guess
#define PARROT_MAX_PHRASES 32	// doesn't hurt, does it?

/obj/critter/parrot // if you didn't want me to make a billion dumb parrot things you shouldn't have let me anywhere near the code so this is YOUR FAULT NOT MINE - Haine
	name = "space parrot"
	desc = "A spacefaring species of parrot."
	icon = 'icons/misc/bird.dmi'
	icon_state = "parrot"
	dead_state = "parrot-dead"
	density = 0
	health = 15
	aggressive = 0
	defensive = 1
	wanderer = 1
	opensdoors = 0 // this was funny for a while but now is less so
	atkcarbon = 0
	atksilicon = 0
	firevuln = 1
	brutevuln = 1
	angertext = "squawks angrily at"
	death_text = "%src% lets out a final weak squawk and keels over."
	butcherable = 1
	flying = 1
	health_gain_from_food = 2
	feed_text = "chirps happily!"
	var/species = "parrot"
	var/obj/item/treasure = null
	var/list/learned_words = list()
	var/list/learned_phrases = list()
	var/learn_words_chance = 33
	var/learn_phrase_chance = 10
	var/chatter_chance = 2
	var/obj/item/new_treasure = null
	var/turf/treasure_loc = null
	var/find_treasure_chance = 2
	var/destroys_treasure = 0
	var/impatience = 0
	var/can_fussle = 1

	get_desc()
		..()
		if (src.treasure)
			. += "<br>[src] is holding \a [src.treasure]."

	hear_talk(mob/M as mob, messages, heardname, lang_id)
		if (!src.alive || src.sleeping || !text)
			return
		var/m_id = (lang_id == "english" || lang_id == "") ? 1 : 2
		if (prob(learn_words_chance))
			src.learn_stuff(messages[m_id])
		if (prob(learn_phrase_chance))
			src.learn_stuff(messages[m_id], 1)

	proc/learn_stuff(var/message, var/learn_phrase = 0)
		if (!message)
			return
		if (!learn_phrase && src.learned_words.len >= PARROT_MAX_WORDS)
			return
		if (learn_phrase && src.learned_phrases.len >= PARROT_MAX_PHRASES)
			return

		if (learn_phrase)
			src.learned_phrases += message
		var/list/heard_stuff = dd_text2list(message, " ")
		for (var/word in heard_stuff)
			if (copytext(word, -1) in list(".", ","))
				word = copytext(word, 1, -1)
			if (word in src.learned_words)
				continue
			if (!length(word)) // idk how things were ending up with blank words but um
				continue // hopefully this will stop that??
			src.learned_words += word
			//boutput(world, word)
			heard_stuff -= word

	proc/chatter()
		if (src.learned_phrases.len && prob(20))
			var/my_phrase = pick(src.learned_phrases)
			var/my_verb = pick("chatters", "chirps", "squawks", "mutters", "cackles", "mumbles")
			src.visible_message("<span class='game say'><span class='name'>[src]</span> [my_verb], \"[my_phrase]\"</span>")
		else if (src.learned_words.len)
			var/my_word = pick(src.learned_words) // :monocle:
			var/my_verb = pick("chatters", "chirps", "squawks", "mutters", "cackles", "mumbles")
			src.visible_message("<span class='game say'><span class='name'>[src]</span> [my_verb], \"[capitalize(my_word)]!\"</span>")

	proc/take_stuff()
		if (src.treasure)
			if (prob(2))
				src.visible_message("<span style=\"color:blue\"><b>[src]</b> drops its [src.treasure]!</span>")
				src.treasure.set_loc(src.loc)
				src.treasure = null
				src.impatience = 0
				walk_to(src, 0)
			else
				return
		if (src.new_treasure && src.treasure_loc)
			if ((get_dist(src, src.treasure_loc) <= 1) && (src.new_treasure.loc == src.treasure_loc))
				src.visible_message("<span class='combat'><b>[src]</b> picks up [src.new_treasure]!</span>")
				src.new_treasure.set_loc(src)
				src.treasure = src.new_treasure
				src.new_treasure = null
				src.treasure_loc = null
				src.impatience = 0
				walk_to(src, 0)
				return
			else if (src.new_treasure.loc == src.treasure_loc)
				if (get_dist(src, src.treasure_loc) > 4 || src.impatience > 8)
					src.new_treasure = null
					src.treasure_loc = null
					src.impatience = 0
					walk_to(src, 0)
					return
				else
					walk_to(src, src.treasure_loc)
					src.impatience ++

			else if (src.new_treasure.loc != src.treasure_loc)
				if (get_dist(src.new_treasure, src) > 4 || src.impatience > 8 || !isturf(src.new_treasure.loc))
					src.new_treasure = null
					src.treasure_loc = null
					src.impatience = 0
					walk_to(src, 0)
					return
				else
					walk_to(src, src.treasure_loc)
					src.impatience ++

	proc/find_stuff()
		var/list/stuff_near_me = list()
		for (var/obj/item/I in view(4, src))
			if (!isturf(I.loc))
				continue
			if (I.anchored || I.density)
				continue
			stuff_near_me += I
		if (stuff_near_me.len)
			src.new_treasure = pick(stuff_near_me)
			src.treasure_loc = get_turf(new_treasure.loc)
		else
			src.new_treasure = null
			src.treasure_loc = null

	proc/fussle()
		if (!src.can_fussle)
			return
		if (src.treasure && prob(10))
			if (!src.muted)
				src.visible_message("<span style=\"color:blue\"><b>[src]</b> [pick("fusses with", "picks at", "pecks at", "throws around", "waves around", "nibbles on", "chews on", "tries to pry open")] [src.treasure].</span>")
			if (prob(5))
				src.visible_message("<span style=\"color:blue\"><b>[src]</b> drops its [src.treasure]!</span>")
				src.treasure.set_loc(src.loc)
				src.treasure = null
				return
			else if (src.destroys_treasure && prob(1))
				src.visible_message("<span class='combat'><b>[src.treasure] breaks!</b></span>")
				new /obj/decal/cleanable/machine_debris(src.loc)
				qdel(src.treasure)
				src.treasure = null
				return
		else if (!src.treasure && src.new_treasure)
			src.take_stuff()
			return
		else if (!src.treasure && !src.new_treasure && prob(src.find_treasure_chance))
			src.find_stuff()
			if (src.new_treasure)
				src.take_stuff()
			return

	CritterDeath()
		..()
		if (src.treasure)
			src.treasure.set_loc(src.loc)
			src.treasure = null

	ai_think()
		if (task == "thinking" || task == "wandering")
			src.fussle()
			if (prob(src.chatter_chance) && !src.muted)
				src.chatter()
			if (prob(5) && !src.muted)
				src.visible_message("<span style=\"color:blue\"><b>[src]</b> [pick("chatters", "chirps", "squawks", "mutters", "cackles", "mumbles", "fusses", "preens", "clicks its beak", "fluffs up", "poofs up")]!</span>")
			if (prob(15))
				flick("[src.species]-flaploop", src)
		return ..()

	seek_target()
		..()
		if (src.target)
			flick("[src.species]-flaploop", src)

	CritterAttack(mob/M as mob)
		src.attacking = 1
		flick("[src.species]-flaploop", src)
		if (iscarbon(M))
			if (prob(60)) //Go for the eyes!
				src.visible_message("<span class='combat'><B>[src]</B> pecks [M] in the eyes!</span>")
				playsound(src.loc, "sound/effects/bloody_stabOLD.ogg", 30, 1)
				M.take_eye_damage(rand(2,10)) //High variance because the bird might not hit well
				if (prob(75) && !M.stat)
					M.emote("scream")
			else
				src.visible_message("<span class='combat'><B>[src]</B> bites [M]!</span>")
				playsound(src.loc, "swing_hit", 30, 0)
				random_brute_damage(M, 3)
		else if (isrobot(M))
			if (prob(10))
				src.visible_message("<span class='combat'><B>[src]</B> bites [M] and snips an important-looking cable!</span>")
				M:compborg_take_critter_damage(null, 0 ,rand(40,70))
				M.emote("scream")
			else
				src.visible_message("<span class='combat'><B>[src]</B> bites [M]!</span>")
				M:compborg_take_critter_damage(null, rand(1,5),0)

		spawn (rand(1,10))
			src.attacking = 0

	ChaseAttack(mob/M)
		src.visible_message("<span class='combat'><B>[src]</B> flails into [M]!</span>")
		playsound(src.loc, "sound/weapons/genhit1.ogg", 50, 1, -1)

		if (ismob(M))
			M.stunned += rand(0,2)
			M.weakened += rand(0,1)

	attack_ai(mob/user as mob)
		if (get_dist(user, src) < 2)
			return attack_hand(user)
		else
			return ..()

	attack_hand(mob/user as mob)
		if (src.alive)
			if (user.a_intent == INTENT_HARM)
				return ..()

			else if (user.a_intent == "disarm")
				user.visible_message ("<b>[user]</b> puts their hand up to [src] and says, \"Step up!\"")
				if (src.task == "attacking" && src.target)
					src.visible_message("<b>[user]</b> can't get [src]'s attention!")
					return
				if (prob(25))
					src.visible_message("[src] [pick("ignores","pays no attention to","warily eyes","turns away from")] [user]!")
					return
				else
					user.pulling = src
					src.wanderer = 0
					if (src.task == "wandering")
						src.task = "thinking"
					src.wrangler = user
					src.visible_message("[src] steps onto [user]'s hand!")
			else if (user.a_intent == "grab" && src.treasure)
				if (prob(25))
					src.visible_message("<span class='combat'><b>[user]</b> [pick("takes", "wrestles", "grabs")] [treasure] from [src]!</span>")
					user.put_in_hand_or_drop(src.treasure)
					src.treasure = null
				else
					src.visible_message("<span class='combat'><b>[user]</b> tries to [pick("take", "wrestle", "grab")] [treasure] from [src], but [src] won't let go!</span>")
			else
				src.visible_message("<b>[user]</b> [pick("gives [src] a scritch", "pets [src]", "cuddles [src]", "snuggles [src]")]!")
				if(prob(15))
					src.visible_message("<span style=\"color:blue\"><b>[src]</b> chirps happily!</span>")
				return
		else
			..()
		return

/*	attackby(obj/item/W as obj, mob/living/user as mob)
		if (!src.alive || src.sleeping)
			return ..()
		if (istype(W, /obj/item/reagent_containers/food/snacks) || istype(W, /obj/item/seed))
			user.visible_message("<b>[user]</b> feeds [W] to [src]!","You feed [W] to [src].")
			src.visible_message("<b>[src]</b> chirps happily!", 1)
			src.health = min(initial(src.health), src.health+10)
			qdel(W)
		else
			return ..()
*/
	proc/dance_response()
		if (!src.alive || src.sleeping)
			return
		if (prob(20))
			src.visible_message("<span style=\"color:blue\"><b>[src]</b> responds with a dance of its own!</span>")
			src.dance()
		else
			src.visible_message("<span style=\"color:blue\"><b>[src]</b> flaps and bobs [pick("to the beat", "in tune", "approvingly", "happily")].</span>")

	proc/dance()
		if (!src.alive || src.sleeping)
			return
		src.icon_state = "[src.species]-flap"
		spawn(38)
			src.icon_state = src.species
		return

/obj/critter/parrot/eclectus
	name = "space eclectus"
	desc = "A spacefaring species of <i>eclectus roratus</i>."
	species = null

	New()
		..()
		if (!src.species)
			src.species = pick("eclectus", "eclectusf")
			src.icon_state = src.species
			src.dead_state = "[src.species]-dead"

/obj/critter/parrot/eclectus/male
	icon_state = "eclectus"
	dead_state = "eclectus-dead"
	species = "eclectus"

/obj/critter/parrot/eclectus/female
	icon_state = "eclectusf"
	dead_state = "eclectusf-dead"
	species = "eclectusf"

/obj/critter/parrot/grey
	name = "space grey"
	desc = "A spacefaring species of <i>psittacus erithacus</i>."
	icon_state = "agrey"
	dead_state = "agrey-dead"
	species = "agrey"

/obj/critter/parrot/caique
	name = "space caique"
	desc = "A spacefaring species of parrot from the <i>pionites</i> genus."
	species = null

	New()
		..()
		if (!src.species)
			src.species = pick("bcaique", "wcaique")
			src.icon_state = src.species
			src.dead_state = "[src.species]-dead"
			switch (src.species)
				if ("bcaique")
					src.desc = "A spacefaring species of <i>pionites melanocephalus</i>."
				if ("wcaique")
					src.desc = "A spacefaring species of <i>pionites leucogaster</i>."

/obj/critter/parrot/caique/black
	desc = "A spacefaring species of <i>pionites melanocephalus</i>."
	icon_state = "bcaique"
	dead_state = "bcaique-dead"
	species = "bcaique"

/obj/critter/parrot/caique/white
	desc = "A spacefaring species of <i>pionites leucogaster</i>."
	icon_state = "wcaique"
	dead_state = "wcaique-dead"
	species = "wcaique"

/obj/critter/parrot/budgie
	name = "space budgerigar"
	desc = "A spacefaring species of <i>melopsittacus undulatus</i>."
	species = null

	New()
		..()
		if (!src.species)
			src.species = pick("gbudge", "bbudge", "bgbudge")
			src.icon_state = src.species
			src.dead_state = "[src.species]-dead"

/obj/critter/parrot/cockatiel
	name = "space cockatiel"
	desc = "A spacefaring species of <i>nymphicus hollandicus</i>."
	species = null

	New()
		..()
		if (!src.species)
			src.species = pick("tiel", "wtiel", "luttiel", "blutiel")
			src.icon_state = src.species
			src.dead_state = "[src.species]-dead"

/obj/critter/parrot/cockatoo
	name = "space cockatoo"
	desc = "A spacefaring species of parrot from the <i>cacatua</i> genus."
	species = null

	New()
		..()
		if (!src.species)
			src.species = pick("too", "utoo", "mtoo")
			src.icon_state = src.species
			src.dead_state = "[src.species]-dead"
			switch (src.species)
				if ("too")
					src.desc = "A spacefaring species of <i>cacatua galerita</i>."
				if ("utoo")
					src.desc = "A spacefaring species of <i>cacatua alba</i>."
				if ("mtoo")
					src.desc = "A spacefaring species of <i>lophochroa leadbeateri</i>."

/obj/critter/parrot/kea
	name = "space kea" // and its swedish brother space ikea
	desc = "A spacefaring species of <i>nestor notabillis</i>, also known as the 'space mountain parrot,' originating from Space Zealand."
	icon_state = "kea"
	dead_state = "kea-dead"
	species = "kea"
	find_treasure_chance = 15
	destroys_treasure = 1

/obj/critter/parrot/random
	species = null
	New()
		..()
		if (!parrot_species)
			logTheThing("debug", null, null, "One of haine's stupid parrot things is broken because var/list/parrot_species doesn't exist or something, go whine at her until she fixes it")
			return
		var/chosen_species = pick(parrot_species)
		if (chosen_species)
			src.species = chosen_species
			src.icon_state = chosen_species
			src.dead_state = "[chosen_species]-dead"
			if (islist(parrot_species[chosen_species]))
				var/list/stop_the_runtimes_please = parrot_species[chosen_species]
				src.name = "[src.quality_name ? "[src.quality_name] " : null][stop_the_runtimes_please[1]]"
				src.desc = stop_the_runtimes_please[2]

var/list/parrot_species = list(\
	"eclectus" = list(1 = "space eclectus", 2 = "A spacefaring species of <i>eclectus roratus</i>."),\
	"eclectusf" = list(1 = "space eclectus", 2 = "A spacefaring species of <i>eclectus roratus</i>."),\
	"agrey" = list(1 = "space grey", 2 = "A spacefaring species of <i>psittacus erithacus</i>."),\
	"bcaique" = list(1 = "space caique", 2 = "A spacefaring species of <i>pionites melanocephalus</i>."),\
	"wcaique" = list(1 = "space caique", 2 = "A spacefaring species of <i>pionites leucogaster</i>."),\
	"gbudge" = list(1 = "space budgerigar", 2 = "A spacefaring species of <i>melopsittacus undulatus</i>."),\
	"bbudge" = list(1 = "space budgerigar", 2 = "A spacefaring species of <i>melopsittacus undulatus</i>."),\
	"bgbudge" = list(1 = "space budgerigar", 2 = "A spacefaring species of <i>melopsittacus undulatus</i>."),\
	"tiel" = list(1 = "space cockatiel", 2 = "A spacefaring species of <i>nymphicus hollandicus</i>."),\
	"wtiel" = list(1 = "space cockatiel", 2 = "A spacefaring species of <i>nymphicus hollandicus</i>."),\
	"luttiel" = list(1 = "space cockatiel", 2 = "A spacefaring species of <i>nymphicus hollandicus</i>."),\
	"blutiel" = list(1 = "space cockatiel", 2 = "A spacefaring species of <i>nymphicus hollandicus</i>."),\
	"too" = list(1 = "space cockatoo", 2 = "A spacefaring species of <i>cacatua galerita</i>."),\
	"utoo" = list(1 = "space cockatoo", 2 = "A spacefaring species of <i>cacatua alba</i>."),\
	"mtoo" = list(1 = "space cockatoo", 2 = "A spacefaring species of <i>lophochroa leadbeateri</i>."),\
	"kea" = list(1 = "space kea", 2 = "A spacefaring species of <i>nestor notabillis</i>, also known as the 'space mountain parrot,' originating from Space Zealand.")\
	)

/obj/critter/parrot/random/testing
	learn_words_chance = 100
	learn_phrase_chance = 100
	chatter_chance = 100
	find_treasure_chance = 100

/obj/item/reagent_containers/food/snacks/ingredient/egg/critter/parrot
	name = "parrot egg"
	critter_type = /obj/critter/parrot/random
	critter_reagent = "flaptonium"

/obj/critter/seagull
	name = "space gull"
	desc = "A spacefaring species of bird from the <i>Laridae</i> family."
	icon_state = "gull"
	dead_state = "gull-dead"
	density = 0
	health = 15
	aggressive = 0
	defensive = 1
	wanderer = 1
	opensdoors = 0
	atkcarbon = 0
	atksilicon = 0
	firevuln = 1
	brutevuln = 1
	angertext = "caws angrily at"
	death_text = "%src% lets out a final weak caw and keels over."
	butcherable = 1
	flying = 1
	chases_food = 1
	health_gain_from_food = 2
	feed_text = "caws happily!"

/obj/critter/boogiebot
	name = "Boogiebot"
	desc = "A robot that looks ready to get down at any moment."
	icon_state = "boogie"
	density = 1
	health = 20
	aggressive = 1
	defensive = 1
	wanderer = 1
	opensdoors = 0
	atkcarbon = 0
	atksilicon = 0
	firevuln = 1
	brutevuln = 1
	angertext = "wonks angrily at"
	generic = 0
	var/dance_forever = 0
	death_text = "%src% stops dancing forever."

	proc/do_a_little_dance()
		if (src.icon_state == "boogie")
			if (!src.muted)
				var/msg = pick("beeps and boops","does a little dance","gets down tonight","is feeling funky","is out of control","gets up to get down","busts a groove","begins clicking and whirring","emits an excited bloop","can't contain itself","can dance if it wants to")
				src.visible_message("<b>[src]</b> [msg]!",2)
			src.icon_state = pick("boogie-d1","boogie-d2","boogie-d3")
			// maybe later make it ambient play a short chiptune here later or at least some new sound effect
			spawn(200)
				if (src) src.icon_state = "boogie"

	ai_think()
		..()
		if(task == "thinking" || task == "wandering")
			if(dance_forever || prob(2)) do_a_little_dance()

	seek_target()
		..()
		if(src.target)
			src.visible_message("<span class='combat'><b>[src]</b> [src.angertext] [src.target]!</span>")
			playsound(src.loc, "sound/vox/bizwarn.ogg", 50, 1)

	CritterAttack(mob/M)
		if(ismob(M))
			src.attacking = 1
			src.visible_message("<span class='combat'><B>[src]</B> bashes itself into [src.target]!</span>")
			playsound(src.loc, "swing_hit", 30, 0)
			random_brute_damage(src.target, 2)
			spawn(rand(1,10))
				src.attacking = 0
		return

	ChaseAttack(mob/M)
		src.visible_message("<span class='combat'><B>[src]</B> boogies right into [M]!</span>")
		playsound(src.loc, "sound/weapons/genhit1.ogg", 50, 1, -1)

		if(ismob(M))
			M.stunned += rand(0,2)
			M.weakened += rand(0,1)

	attack_hand(mob/user as mob)
		if (src.alive && (user.a_intent != INTENT_HARM))
			src.visible_message("<span class='combat'><b>[user]</b> pets [src]!</span>")
			if(prob(10)) do_a_little_dance()
			return
		else
			. = ..()