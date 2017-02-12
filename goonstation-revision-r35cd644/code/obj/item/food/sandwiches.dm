
/obj/item/reagent_containers/food/snacks/sandwich/
	icon = 'icons/obj/foodNdrink/food_bread.dmi'
	amount = 4
	heal_amt = 2
	var/hname = null
	var/job = null
	food_color = "#FFFFCC"
	custom_food = 0
	initial_volume = 30

	meat_h
		name = "manwich"
		desc = "Human meat between two slices of bread."
		icon_state = "sandwich_m"

	meat_m
		name = "monkey sandwich"
		desc = "Meat between two slices of bread."
		icon_state = "sandwich_m"

	pb
		name = "peanut butter sandwich"
		desc = "Peanut butter between two slices of bread."
		icon_state = "sandwich_p"

	pbh
		name = "peanut butter and honey sandwich"
		desc = "Peanut butter and honey between two slices of bread."
		icon_state = "sandwich_p"

		New()
			..()
			reagents.add_reagent("honey",10)


	meat_s
		name = "synthmeat sandwich"
		desc = "Synthetic meat between two slices of bread."
		icon_state = "sandwich_m"

	cheese
		name = "cheese sandwich"
		desc = "Cheese between two slices of bread."
		icon_state = "sandwich_c"

	elvis_meat_h
		name = "elvismanwich"
		desc = "Human meat between two slices of elvis bread."
		icon_state = "elviswich_m"

		New()
			..()
			reagents.add_reagent("essenceofelvis",25)

	elvis_meat_m
		name = "monkey elviswich"
		desc = "Meat between two slices of elvis bread."
		icon_state = "elviswich_m"

		New()
			..()
			reagents.add_reagent("essenceofelvis",25)

	elvis_pb
		name = "peanut butter elviswich"
		desc = "Peanut butter between two slices of elvis bread."
		icon_state = "elviswich_p"

		New()
			..()
			reagents.add_reagent("essenceofelvis",25)

	elvis_pbh
		name = "peanut butter and honey elviswich"
		desc = "Peanut butter and honey between two slices of elvis bread."
		icon_state = "elviswich_p"

		New()
			..()
			reagents.add_reagent("essenceofelvis",15)
			reagents.add_reagent("honey",10)

	elvis_meat_s
		name = "synthmeat elviswich"
		desc = "Synthetic meat between two slices of elvis bread."
		icon_state = "elviswich_m"

		New()
			..()
			reagents.add_reagent("essenceofelvis",25)

	elvis_cheese
		name = "cheese elviswich"
		desc = "Cheese between two slices of elvis bread."
		icon_state = "elviswich_c"

		New()
			..()
			reagents.add_reagent("essenceofelvis",25)

	spooky_cheese
		name = "killed cheese sandwich"
		desc = "Cheese that has been murdered and buried in a hasty grave of dread."
		icon_state = "scarewich_c"

		New()
			..()
			reagents.add_reagent("ectoplasm",15)
			reagents.add_reagent("cheese", 10)

	spooky_pb
		name = "peanut butter and jelly meet breadula"
		desc = "It's probably rather frightening if you have a nut allergy."
		icon_state = "scarewich_pb"

		New()
			..()
			reagents.add_reagent("ectoplasm",15)
			reagents.add_reagent("eyeofnewt",10)

	spooky_pbh
		name = "killer beenut butter sandwich"
		desc = "A peanut butter sandwich with a terrifying twist: Honey!"
		icon_state = "scarewich_pb"

		New()
			..()
			reagents.add_reagent("ectoplasm",10)
			reagents.add_reagent("tongueofdog",5)
			reagents.add_reagent("honey",10)

	spooky_meat_h
		name = "murderwich"
		desc = "Dawn of the bread."
		icon_state = "scarewich_m"
		New()
			..()
			reagents.add_reagent("ectoplasm",15)
			reagents.add_reagent("blood", 10)

	spooky_meat_m
		name = "scare wich project"
		desc = "What's a ghost's favorite sandwich meat? BOO-loney!"
		icon_state = "scarewich_m"
		New()
			..()
			reagents.add_reagent("ectoplasm",15)
			reagents.add_reagent("blood", 10)

	spooky_meat_s
		name = "synthmeat steinwich"
		desc = "A dreadful sandwich of flesh borne not of man or beast, but of twisted science."
		icon_state = "scarewich_m"

		New()
			..()
			reagents.add_reagent("ectoplasm",15)
			reagents.add_reagent("synthflesh", 10)

	meatball
		name = "meatball sub"
		desc = "A submarine sandwich consisting of meatballs, cheese, and marinara sauce."
		icon_state = "meatball_sub"
		amount = 6
		heal_amt = 4

/obj/item/reagent_containers/food/snacks/burger/
	name = "burger"
	desc = "A burger."
	icon = 'icons/obj/foodNdrink/food_meals.dmi'
	icon_state = "hburger"
	amount = 5
	heal_amt = 2
	food_color ="#663300"
	initial_volume = 15

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/reagent_containers/food/snacks/condiment/)) src.amount += 1

	New()
		..()
		reagents.add_reagent("cholesterol",4)

/obj/item/reagent_containers/food/snacks/burger/assburger
	name = "assburger"
	desc = "This burger gives off an air of awkwardness."
	icon_state = "assburger"

/obj/item/reagent_containers/food/snacks/burger/heartburger
	name = "heartburger"
	desc = "This burger tastes kind of offal."
	icon_state = "heartburger"

/obj/item/reagent_containers/food/snacks/burger/brainburger
	name = "brainburger"
	desc = "A strange looking burger. It looks almost sentient."
	icon_state = "brainburger"
	initial_volume = 15

	New()
		..()
		reagents.add_reagent("prions", 10)

/obj/item/reagent_containers/food/snacks/burger/humanburger
	name = "burger"
	var/hname = ""
	desc = "A bloody burger."
	icon_state = "hburger"

/obj/item/reagent_containers/food/snacks/burger/monkeyburger
	name = "monkeyburger"
	desc = "The cornerstone of every nutritious breakfast."
	icon_state = "mburger"

/obj/item/reagent_containers/food/snacks/burger/fishburger
	name = "Fish-Fil-A"
	desc = "A delicious alternative to heart-grinding beef patties."
	icon_state = "fishburger"

/obj/item/reagent_containers/food/snacks/burger/moldy
	name = "moldy burger"
	desc = "A rather disgusting looking burger."
	icon_state ="moldyburger"
	amount = 1
	heal_amt = 1
	initial_volume = 15

	New()
		..()
		wrap_pathogen(reagents, generate_flu_pathogen(), 7)
		wrap_pathogen(reagents, generate_cold_pathogen(), 8)

/obj/item/reagent_containers/food/snacks/burger/plague
	name = "burgle"
	desc = "The plagueburger."
	icon_state = "moldyburger"
	amount = 1
	heal_amt = 1
	initial_volume = 15

	New()
		..()
		wrap_pathogen(reagents, generate_random_pathogen(), 15)

/obj/item/reagent_containers/food/snacks/burger/roburger
	name = "roburger"
	desc = "The lettuce is the only organic component. Beep."
	icon_state = "roburger"
	amount = 3
	heal_amt = 1
	food_color = "#C8C8C8"
	initial_volume = 10
	brewable = 1
	brew_result = "beepskybeer"

	New()
		..()
		reagents.add_reagent("nanites", 10)

/obj/item/reagent_containers/food/snacks/burger/synthburger
	name = "synthburger"
	desc = "A thoroughly artificial snack."
	icon_state = "mburger"
	amount = 5
	heal_amt = 2

/obj/item/reagent_containers/food/snacks/burger/baconburger
	name = "baconatrix"
	desc = "The official food of the Lunar Football League! Also possibly one of the worst things you could ever eat."
	icon_state = "baconburger"
	amount = 5
	heal_amt = 1
	initial_volume = 50

	New()
		..()
		reagents.add_reagent("porktonium", 50)

	heal(var/mob/M)
		if(prob(25))
			M.nutrition += 100
		..()

/obj/item/reagent_containers/food/snacks/burger/sloppyjoe
	name = "sloppy joe"
	desc = "A rather messy burger."
	icon_state = "sloppyjoe"
	amount = 5
	heal_amt = 2

	heal(var/mob/M)
		if(prob(20))
			var/obj/decal/cleanable/blood/gibs/gib = new /obj/decal/cleanable/blood/gibs( get_turf(src) )
			gib.streak(M.dir)
			boutput(M, "<span style=\"color:red\">You drip some meat on the floor</span>")
			M.visible_message("<span style=\"color:red\">[M] drips some meat on the floor!</span>")
			playsound(M.loc, "sound/effects/splat.ogg", 50, 1)

		else
			..()

/obj/item/reagent_containers/food/snacks/burger/mysteryburger
	name = "dubious burger"
	desc = "A burger of indeterminate meat type."
	icon_state = "brainburger"
	amount = 5
	heal_amt = 1

	heal(var/mob/M)
		if(prob(8))
			var/effect = rand(1,4)
			switch(effect)
				if(1)
					boutput(M, "<span style=\"color:red\">Ugh. Tasted all greasy and gristly.</span>")
					M.nutrition += 20
				if(2)
					boutput(M, "<span style=\"color:red\">Good grief, that tasted awful!</span>")
					M.take_toxin_damage(2)
				if(3)
					boutput(M, "<span style=\"color:red\">There was a cyst in that burger. Now your mouth is full of pus OH JESUS THATS DISGUSTING OH FUCK</span>")
					M.nutrition -= 20
					M.visible_message("<span style=\"color:red\">[M] suddenly and violently vomits!</span>")
					playsound(M.loc, "sound/effects/splat.ogg", 50, 1)
					new /obj/decal/cleanable/vomit(M.loc)
				if(4)
					boutput(M, "<span style=\"color:red\">You bite down on a chunk of bone, hurting your teeth.</span>")
					random_brute_damage(M, 2)
		..()

/obj/item/reagent_containers/food/snacks/burger/cheeseburger
	name = "cheeseburger"
	desc = "Tasty, but not paticularly healthy."
	icon_state = "hburger"
	amount = 6
	heal_amt = 2

/obj/item/reagent_containers/food/snacks/burger/cheeseburger_m
	name = "monkey cheese burger"
	desc = "How very dadaist."
	icon_state = "hburger"
	amount = 6
	heal_amt = 2

	heal(var/mob/M)
		if(prob(3) && ishuman(M))
			boutput(M, "<span style=\"color:red\">You wackily and randomly turn into a lizard.</span>")
			M.set_mutantrace(/datum/mutantrace/lizard)
			M:update_face()
			M:update_body()

		if(prob(3))
			boutput(M, "<span style=\"color:red\">You wackily and randomly turn into a monkey.</span>")
			M:monkeyize()

		..()

/obj/item/reagent_containers/food/snacks/burger/bigburger
	name = "Coronator"
	desc = "The king of burgers. You can feel your digestive system shutting down just LOOKING at it."
	icon_state = "bigburger"
	amount = 10
	heal_amt = 5
	initial_volume = 100

	New()
		..()
		reagents.add_reagent("cholesterol", 50)

/obj/item/reagent_containers/food/snacks/burger/monsterburger
	name = "THE MONSTER"
	desc = "There are no words to describe the sheer unhealthiness of this abomination."
	icon_state = "giantburger"
	amount = 1
	heal_amt = 50
	throwforce = 10
	initial_volume = 330

	New()
		..()
		reagents.add_reagent("cholesterol",200)

/obj/item/reagent_containers/food/snacks/burger/vr
	icon = 'icons/effects/VR.dmi'

/obj/item/reagent_containers/food/snacks/fries
	name = "fries"
	desc = "Lightly salted potato fingers."
	icon = 'icons/obj/foodNdrink/food_snacks.dmi'
	icon_state = "fries"
	amount = 6
	heal_amt = 1
	initial_volume = 5

	New()
		..()
		reagents.add_reagent("cholesterol",1)
