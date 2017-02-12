
/obj/item/reagent_containers/food/drinks/bottle/beer
	name = "Space Beer"
	desc = "Beer. in space."
	icon_state = "bottle-brown"
	heal_amt = 1
	g_amt = 40
	bottle_style = "brown"
	label = "alcohol1"
	initial_volume = 50
	module_research = list("vice" = 5)
	module_research_type = /obj/item/reagent_containers/food/drinks/bottle/beer

	New()
		..()
		reagents.add_reagent("beer", 30)

/obj/item/reagent_containers/food/drinks/bottle/beer/borg
	unbreakable = 1

/obj/item/reagent_containers/food/drinks/bottle/fancy_beer
	name = "Fancy Beer"
	desc = "Some kind of fancy-pants IPA or lager or ale. Some sort of beer-type thing."
	icon_state = "bottle-green"
	initial_volume = 50
	module_research = list("vice" = 5)
	module_research_type = /obj/item/reagent_containers/food/drinks/bottle/beer

	New()
		..()
		name = "[pick(BOOZE_prefixes)] [pick(BEER_suffixes)]"
		bottle_style = pick("clear", "black", "barf", "brown", "red", "orange", "yellow", "green", "cyan", "blue", "purple")
		label = pick("alcohol1","alcohol2","alcohol3","alcohol4","alcohol5","alcohol6","alcohol7")
		reagents.add_reagent("beer", 25)
		reagents.add_reagent("ethanol", 5)

		var/flavors = 1
		var/adulterants = 1

		while(flavors > 0)
			flavors--
			reagents.add_reagent(pick(BOOZE_flavors),rand(1,3))

		while(adulterants > 0)
			adulterants--
			reagents.add_reagent(pick(CYBERPUNK_drug_adulterants), rand(1,3))

		update_icon()

///////////

/var/list/BOOZE_prefixes = strings("chemistry_tools.txt", "BOOZE_prefixes")
/var/list/WINE_suffixes = strings("chemistry_tools.txt", "WINE_suffixes")
/var/list/BEER_suffixes = strings("chemistry_tools.txt", "BEER_suffixes")
/var/list/BOOZE_flavors = strings("chemistry_tools.txt", "BOOZE_flavors")

////////////

/obj/item/reagent_containers/food/drinks/bottle/wine
	name = "Wine"
	desc = "Not to be confused with pubbie tears."
	icon_state = "bottle-purple"
	heal_amt = 1
	g_amt = 40
	bottle_style = "purple"
	label = "alcohol2"
	initial_volume = 50
	module_research = list("vice" = 5)
	module_research_type = /obj/item/reagent_containers/food/drinks/bottle/beer

	New()
		..()
		reagents.add_reagent("wine", 30)


/obj/item/reagent_containers/food/drinks/bottle/hobo_wine
	name = "Fortified Wine"
	desc = "Some sort of bottom-shelf booze. Wasn't this brand banned awhile ago?"
	icon_state = "bottle-vermouth"
	heal_amt = 1
	g_amt = 40
	bottle_style = "vermouth"
	fluid_style = "vermouth"
	label = "vermouth"
	var/safe
	initial_volume = 50
	module_research = list("vice" = 5)
	module_research_type = /obj/item/reagent_containers/food/drinks/bottle/beer

	New()
		..()
		name = "[pick(BOOZE_prefixes)] [pick(WINE_suffixes)]"
		bottle_style = pick("vermouthR", "vermouthO", "vermouthY", "vermouth", "vermouthC", "vermouthB", "vermouthP")
		reagents.add_reagent("wine", 20)
		reagents.add_reagent("ethanol", 5)

		var/adulterant_safety = safe ? "CYBERPUNK_drug_adulterants_safe" : "CYBERPUNK_drug_adulterants"
		var/flavors = rand(1,3)
		var/adulterants = rand(2,4)


		if(safe)
			name = "Watered Down [name]"
			reagents.add_reagent("water", 1) // how is this safe?

		while(flavors > 0)
			flavors--
			reagents.add_reagent(pick(BOOZE_flavors),rand(2,5))

		while(adulterants > 0)
			adulterants--
			reagents.add_reagent(pick(adulterant_safety), rand(1,3))

/obj/item/reagent_containers/food/drinks/bottle/hobo_wine/safe
	safe = 1

/obj/item/reagent_containers/food/drinks/bottle/champagne
	name = "Champagne"
	desc = "Fizzy wine used in celebrations. It's not technically champagne if it's not made using grapes from the Champagne region of France."
	icon_state = "bottle-champagneG"
	bottle_style = "champagneG"
	fluid_style = "champagne"
	label = "champagne"
	heal_amt = 1
	g_amt = 60
	initial_volume = 50
	module_research = list("vice" = 5)
	module_research_type = /obj/item/reagent_containers/food/drinks/bottle/beer

	New()
		..()
		reagents.add_reagent("champagne", 30)

	afterattack(obj/O as obj, mob/user as mob)
		if (istype(O, /obj/machinery/vehicle) || istype(O, /obj/vehicle) && user.a_intent == "harm")
			var/turf/U = user.loc
			if (src.broken)
				boutput(user, "You can't christen something with a bottle in that state! Are you some kind of unsophisticated ANIMAL?!")
				return
			if (prob(50))
				user.visible_message("<span style=\"color:red\"><b>[user]</b> hits [O] with [src], shattering it open!</span>")
				playsound(U, pick('sound/effects/Glassbr1.ogg','sound/effects/Glassbr2.ogg','sound/effects/Glassbr3.ogg'), 100, 1)
				new /obj/item/raw_material/shard/glass(U)
				src.broken = 1
				src.reagents.reaction(U)
				src.create_reagents(0)
				src.update_icon()
			var/new_name = input(usr, "Enter new name for [O]", "Rename [O]", O.name) as text
			logTheThing("station", user, null, "renamed [O] to [new_name] in [get_area(user)] ([showCoords(user.x, user.y, user.z)])")
			new_name = copytext(html_encode(new_name), 1, 32)
			O.name = new_name
			return

/obj/item/reagent_containers/food/drinks/bottle/cider
	name = "Cider"
	desc = "Made from apples."
	icon_state = "bottle-green"
	heal_amt = 1
	g_amt = 40
	bottle_style = "green"
	label = "alcohol1"
	initial_volume = 50
	module_research = list("vice" = 5)
	module_research_type = /obj/item/reagent_containers/food/drinks/bottle/beer

	New()
		..()
		reagents.add_reagent("cider", 30)

/obj/item/reagent_containers/food/drinks/rum
	name = "Rum"
	desc = "Yo ho ho and all that."
	icon_state = "rum"
	heal_amt = 1
	initial_volume = 50
	module_research = list("vice" = 5)
	module_research_type = /obj/item/reagent_containers/food/drinks/bottle/beer

	New()
		..()
		reagents.add_reagent("rum", 30)

/obj/item/reagent_containers/food/drinks/rum_spaced
	name = "Spaced Rum"
	desc = "Rum which has been exposed to cosmic radiation. Don't worry, radiation does everything!"
	icon_state = "rum"
	heal_amt = 1
	initial_volume = 60
	module_research = list("vice" = 5)
	module_research_type = /obj/item/reagent_containers/food/drinks/bottle/beer

	New()
		..()
		reagents.add_reagent("rum", 30)
		reagents.add_reagent("yobihodazine", 30)

/obj/item/reagent_containers/food/drinks/grog
	name = "Ye Olde Grogge"
	desc = "The dusty glass bottle has caustic fumes wafting out of it. You're not sure drinking it is a good idea."
	icon_state = "moonshine"
	heal_amt = 0
	initial_volume = 60
	module_research = list("vice" = 5)

	New()
		..()
		reagents.add_reagent("grog", 60)

/obj/item/reagent_containers/food/drinks/bottle/mead
	name = "Mead"
	desc = "A pillager's tipple."
	icon_state = "bottle-barf"
	heal_amt = 1
	g_amt = 40
	bottle_style = "barf"
	label = "alcohol5"
	initial_volume = 50
	module_research = list("vice" = 5)
	module_research_type = /obj/item/reagent_containers/food/drinks/bottle/beer

	New()
		..()
		reagents.add_reagent("mead", 30)

/obj/item/reagent_containers/food/drinks/bottle/vintage
	name = "2010 Vintage"
	desc = "A bottle marked '2010 Vintage'. ...wait, this isn't wine..."
	icon_state = "bottle-barf"
	heal_amt = 1
	g_amt = 40
	bottle_style = "barf"
	label = "alcohol5"
	initial_volume = 50
	module_research = list("vice" = 2)

	New()
		..()
		reagents.add_reagent("urine", 30)

/obj/item/reagent_containers/food/drinks/bottle/vodka
	name = "Vodka"
	desc = "Russian stuff. Pretty good quality."
	icon_state = "bottle-vodka"
	bottle_style = "vodka"
	fluid_style = "vodka"
	label = "none"
	heal_amt = 1
	g_amt = 60
	initial_volume = 50
	module_research = list("vice" = 5)
	module_research_type = /obj/item/reagent_containers/food/drinks/bottle/beer

	New()
		..()
		reagents.add_reagent("vodka", 30)

/obj/item/reagent_containers/food/drinks/bottle/vodka/vr
	icon_state = "vr_vodka"
	bottle_style = "vr_vodka"

/obj/item/reagent_containers/food/drinks/bottle/tequila
	name = "Tequila"
	desc = "Guadalajara is a crazy place, man, lemme tell you."
	icon_state = "bottle-tequila"
	bottle_style = "tequila"
	fluid_style = "none"
	label = "none"
	heal_amt = 1
	g_amt = 60
	initial_volume = 50
	module_research = list("vice" = 5)
	module_research_type = /obj/item/reagent_containers/food/drinks/bottle/beer

	New()
		..()
		reagents.add_reagent("tequila", 30)

/obj/item/reagent_containers/food/drinks/bottle/gin
	name = "Gin"
	desc = "Gin is technically just a kind of alcohol that tastes strongly of juniper berries. Would juniper-flavored vodka count as a gin?"
	icon_state = "bottle-gin"
	bottle_style = "gin"
	fluid_style = "gin"
	label = "gin"
	heal_amt = 1
	g_amt = 60
	initial_volume = 50
	module_research = list("vice" = 5)
	module_research_type = /obj/item/reagent_containers/food/drinks/bottle/beer

	New()
		..()
		reagents.add_reagent("gin", 30)

/obj/item/reagent_containers/food/drinks/bottle/ntbrew
	name = "NanoTrasen Brew"
	desc = "Jesus, how long has this even been here?"
	icon_state = "bottle-vermouth"
	bottle_style = "vermouth"
	fluid_style = "vermouth"
	label = "vermouth"
	heal_amt = 1
	g_amt = 60
	initial_volume = 250
	module_research = list("vice" = 2)

	New()
		..()
		reagents.add_reagent("wine", 40)
		reagents.add_reagent("charcoal", 20)

/obj/item/reagent_containers/food/drinks/bottle/thegoodstuff
	name = "Stinkeye's Special Reserve"
	desc = "An old bottle labelled 'The Good Stuff'. This probably has enough kick to knock an elephant on its ass."
	icon_state = "bottle-whiskey"
	bottle_style = "whiskey"
	fluid_style = "whiskey"
	label = "whiskey"
	heal_amt = 1
	g_amt = 60
	initial_volume = 250
	module_research = list("vice" = 10)

	New()
		..()
		reagents.add_reagent("beer", 30)
		reagents.add_reagent("wine", 30)
		reagents.add_reagent("cider", 30)
		reagents.add_reagent("vodka", 30)
		reagents.add_reagent("ethanol", 30)
		reagents.add_reagent("eyeofnewt", 30);

/obj/item/reagent_containers/food/drinks/bottle/bojackson
	name = "Bo Jack Daniel's"
	desc = "Bo knows how to get you drunk, by diddley!"
	icon_state = "bottle-spicedrum"
	bottle_style = "spicedrum"
	fluid_style = "none"
	label = "none"
	heal_amt = 1
	g_amt = 40
	initial_volume = 60
	module_research = list("vice" = 5)
	module_research_type = /obj/item/reagent_containers/food/drinks/bottle/beer

	New()
		..()
		reagents.add_reagent("bojack", 60)

/obj/item/reagent_containers/food/drinks/moonshine
	name = "Jug of Moonshine"
	desc = "A jug of an illegaly brewed alchoholic beverage, which is quite potent."
	icon_state = "moonshine"
	heal_amt = 1
	rc_flags = RC_FULLNESS
	initial_volume = 250
	module_research = list("vice" = 100)

	New()
		..()
		reagents.add_reagent("moonshine", 250)

// nicknacks for making fancy drinks

/obj/item/cocktail_stuff
	name = "cocktail doodad"
	desc = "Some kinda li'l thing to put in a cocktail. How are you seeing this?"
	icon = 'icons/obj/drink.dmi'
	flags = FPRINT | TABLEPASS
	var/food = 0
	w_class = 1.0

	attack(mob/M as mob, mob/user as mob)
		if (!src.food)
			return
		if (user == M)
			boutput(user, "<span style=\"color:red\">You eat [src]. Yum!</span>")
			user.visible_message("<b>[user]</b> eats [src].")
		else
			boutput(M, "<span style=\"color:red\">You eat [src]. Yum!</span>")
			user.visible_message("<span style=\"color:red\"><b>[user]</b> sticks [src] into [M]'s mouth.</span>")
		playsound(usr.loc,"sound/items/eatfood.ogg", rand(10,50), 1)
		qdel(src)
		..()

	drink_umbrella
		name = "drink umbrella"
		desc = "A tiny little umbrella, to put into drinks. I guess it makes you feel like you're on the beach, even when you're actually in a vomit-, piss- and blood-covered bar in the middle of some shitty dump of a space station. Maybe."
		var/umbrella_color = null

		New()
			..()
			umbrella_color = rand(1,6)
			update_icon()

		proc/update_icon()
			if (umbrella_color)
				icon_state = "cocktail-umbrella[umbrella_color]"
			return

	maraschino_cherry
		name = "maraschino cherry"
		desc = "A sweet, vibrantly red little cherry, which has been preserved in maraschino liquer, which is made from maraschino cherries. Huh."
		icon_state = "cocktail-cherry"
		food = 1

	cocktail_olive
		name = "cocktail olive"
		desc = "An olive on a toothpick, to put in a drink. I dunno what this accomplishes for the taste of the drink, but hey, you get an olive to eat."
		icon_state = "cocktail-olive"
		food = 1

	celery
		name = "celery stick"
		desc = "A stick of celery. Does not feature ants. Unless you leave it on the floor, but those would probably not be very tasty. I dunno, though, I've never eaten an ant. They might be delicious."
		icon_state = "cocktail-celery"
		food = 1
