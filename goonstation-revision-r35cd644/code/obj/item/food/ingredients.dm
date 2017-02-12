// Ingredients

/obj/item/reagent_containers/food/snacks/ingredient/
	name = "ingredient"
	desc = "you shouldnt be able to see this"
	icon = 'icons/obj/foodNdrink/food_ingredient.dmi'
	amount = 1
	heal_amt = 0
	custom_food = 0

/obj/item/reagent_containers/food/snacks/ingredient/meat/
	name = "raw meat"
	desc = "you shouldnt be able to see this either!!"
	icon_state = "meat"
	amount = 1
	heal_amt = 0
	custom_food = 1

	heal(var/mob/living/M)
		if (prob(33))
			boutput(M, "<span style=\"color:red\">You briefly think you probably shouldn't be eating raw meat.</span>")
			M.contract_disease(/datum/ailment/disease/food_poisoning, null, null, 1) // path, name, strain, bypass resist

	throw_impact(var/turf/T)
		playsound(src.loc, "sound/effects/splat.ogg", 100, 1)
		if (istype(T))
			new /obj/decal/cleanable/blood(T)
		..()

/obj/item/reagent_containers/food/snacks/ingredient/meat/humanmeat
	name = "-meat"
	desc = "A slab of meat."
	var/subjectname = ""
	var/subjectjob = null
	amount = 1

/obj/item/reagent_containers/food/snacks/ingredient/meat/monkeymeat
	name = "monkeymeat"
	desc = "A slab of meat from a monkey."
	amount = 1

/obj/item/reagent_containers/food/snacks/ingredient/meat/fish
	name = "fish fillet"
	desc = "A slab of meat from a fish."
	icon_state = "fillet_pink"
	amount = 1
	food_color = "#FF6699"
	real_name = "fish"
	salmon
		name = "salmon fillet"
		icon_state = "fillet_orange"
		food_color = "#FF9900"
		real_name = "salmon"
	white
		name = "white fish fillet"
		icon_state = "fillet_white"
		food_color = "#FFFFFF"
		real_name = "white fish"

/obj/item/reagent_containers/food/snacks/ingredient/meat/synthmeat
	name = "synthmeat"
	desc = "Synthetic meat grown in hydroponics."
	amount = 1

/obj/item/reagent_containers/food/snacks/ingredient/meat/mysterymeat
	name = "mystery meat"
	desc = "What the fuck is this??"
	icon_state = "mysterymeat"
	amount = 1

/obj/item/reagent_containers/food/snacks/ingredient/meat/bacon
	name = "bacon"
	desc = "A strip of salty cured pork. Many disgusting nerds have a bizarre fascination with this meat, going so far as to construct tiny houses out of it."
	icon_state = "bacon"
	amount = 1

	New()
		..()
		src.pixel_x += rand(-4,4)
		src.pixel_y += rand(-4,4)
		var/datum/reagents/R = new/datum/reagents(20)
		reagents = R
		R.my_atom = src
		R.add_reagent("porktonium", 10)

	heal(var/mob/M)
		M.nutrition += 20
		return

	raw
		name = "raw bacon"
		desc = "A strip of salty raw cured pork. It really should be cooked first."
		icon_state = "bacon_raw"
		amount = 1
		real_name = "bacon"

/obj/item/reagent_containers/food/snacks/ingredient/meat/mysterymeat/nugget
	name = "chicken nugget"
	desc = "A breaded wad of poultry, far too processed to have a more specific label than 'nugget.'"
	icon = 'icons/obj/foodNdrink/food_ingredient.dmi'
	icon_state = "nugget0"
	amount = 2

	New()
		..()
		src.pixel_x += rand(-4,4)
		src.pixel_y += rand(-4,4)
		var/datum/reagents/R = new/datum/reagents(15)
		reagents = R
		R.my_atom = src

	heal(var/mob/M)
		if (icon_state == "nugget0")
			icon_state = "nugget1"
		return ..()

/obj/item/reagent_containers/food/snacks/ingredient/egg
	name = "egg"
	desc = "An egg!"
	icon_state = "egg"
	food_color = "#FFFFFF"
	initial_volume = 20

	New()
		..()
		reagents.add_reagent("egg", 5)

	throw_impact(var/turf/T)
		src.visible_message("<span style=\"color:red\">[src] splats onto the floor messily!</span>")
		playsound(src.loc, "sound/effects/splat.ogg", 100, 1)
		new/obj/decal/cleanable/eggsplat(T)
		qdel (src)

/obj/item/reagent_containers/food/snacks/ingredient/flour
	name = "flour"
	desc = "Some flour."
	icon_state = "flour"
	amount = 1
	food_color = "#FFFFFF"

/obj/item/reagent_containers/food/snacks/ingredient/rice
	name = "rice"
	desc = "A sprig of rice. There's probably a decent amount in it, thankfully."
	icon_state = "rice"
	amount = 1
	food_color = "#FFFFAA"

/obj/item/reagent_containers/food/snacks/ingredient/bean
	name = "bean pod"
	desc = "This bean pod contains an inordinately large amount of beans due to genetic engineering. How convenient."
	icon_state = "beanpod"
	amount = 1
	food_color = "#CCFFCC"

/obj/item/reagent_containers/food/snacks/ingredient/sugar
	name = "sugar"
	desc = "How sweet."
	icon_state = "sugar"
	amount = 1
	food_color = "#FFFFFF"
	custom_food = 1
	initial_volume = 50
	brewable = 1
	brew_result = "rum"

	New()
		..()
		reagents.add_reagent("sugar", 25)

/obj/item/reagent_containers/food/snacks/ingredient/peanutbutter
	name = "peanut butter"
	desc = "A jar of GRIF peanut butter."
	icon_state = "peanutbutter"
	amount = 3
	heal_amt = 1
	food_color = "#996600"
	custom_food = 1

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/reagent_containers/food/snacks/candy) && W.reagents && W.reagents.has_reagent("chocolate"))
			if (istype(W, /obj/item/reagent_containers/food/snacks/candy/pbcup))
				return
			boutput(user, "You get chocolate in the peanut butter!  Or maybe the other way around?")

			var/obj/item/reagent_containers/food/snacks/candy/pbcup/A = new /obj/item/reagent_containers/food/snacks/candy/pbcup
			user.u_equip(W)
			user.put_in_hand_or_drop(A)

			qdel(W)
			if (src.amount-- < 1)
				qdel(src)

		else
			..()
		return

/obj/item/reagent_containers/food/snacks/ingredient/oatmeal
	name = "oatmeal"
	desc = "A breakfast staple."
	icon_state = "oatmeal"
	amount = 1
	food_color = "#CC9966"
	custom_food = 1

/obj/item/reagent_containers/food/snacks/ingredient/honey
	name = "honey"
	desc = "A sweet nectar derivative produced by bees."
	icon_state = "honeyblob"
	amount = 1
	food_color = "#C0C013"
	custom_food = 1
	doants = 0
	initial_volume = 50
	brewable = 1
	brew_result = "mead"

	New()
		..()
		spawn(10)
			if (!reagents.total_volume)
				reagents.add_reagent("honey", 15)

/obj/item/reagent_containers/food/snacks/ingredient/royal_jelly
	name = "royal jelly"
	desc = "A blob of nutritive gel for larval bees."
	icon_state = "jellyblob"
	amount = 1
	food_color = "#990066"
	custom_food = 1
	doants = 0
	initial_volume = 50

	New()
		..()
		spawn(10)
			if (!reagents.total_volume)
				reagents.add_reagent("royal_jelly", 25)

/obj/item/reagent_containers/food/snacks/ingredient/peeled_banana
	name = "peeled banana"
	icon = 'icons/obj/foodNdrink/food_produce.dmi'
	icon_state = "banana_fruit"

/obj/item/reagent_containers/food/snacks/ingredient/cheese
	name = "cheese"
	desc = "Some kind of curdled milk product."
	icon_state = "cheese"
	amount = 2
	heal_amt = 1
	food_color = "#FFD700"
	custom_food = 1

/obj/item/reagent_containers/food/snacks/ingredient/gcheese
	name = "weird cheese"
	desc = "Some kind of... gooey, messy, gloopy thing. Similar to cheese, but only in the looser sense of the word."
	icon_state = "gcheese"
	amount = 2
	heal_amt = 1
	food_color = "#669966"
	custom_food = 1
	initial_volume = 50

	New()
		..()
		reagents.add_reagent("mercury", 5)
		reagents.add_reagent("LSD", 5)
		reagents.add_reagent("ethanol", 5)
		reagents.add_reagent("gcheese", 5)

/obj/item/reagent_containers/food/snacks/ingredient/pancake_batter
	name = "pancake batter"
	desc = "Used for making pancakes."
	icon_state = "pancake"
	amount = 1
	food_color = "#FFFFFF"

/obj/item/reagent_containers/food/snacks/ingredient/meatpaste
	name = "meatpaste"
	desc = "A meaty paste"
	icon_state = "meatpaste"
	amount = 1
	custom_food = 1
	initial_volume = 50

	New()
		..()
		reagents.add_reagent("meat_slurry", 15)

/obj/item/reagent_containers/food/snacks/ingredient/dough
	name = "dough"
	desc = "Used for making bready things."
	icon_state = "dough"
	amount = 1
	food_color = "#FFFFFF"
	custom_food = 0

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/reagent_containers/food/snacks/ingredient/sugar))
			boutput(user, "<span style=\"color:blue\">You add [W] to [src] to make sweet dough!</span>")
			var/obj/item/reagent_containers/food/snacks/ingredient/dough_s/D = new /obj/item/reagent_containers/food/snacks/ingredient/dough_s(W.loc)
			user.u_equip(W)
			user.put_in_hand_or_drop(D)
			qdel(W)
			qdel(src)
		else if (istype(W, /obj/item/kitchen/rollingpin))
			boutput(user, "<span style=\"color:blue\">You flatten out the dough.</span>")
			var/obj/item/reagent_containers/food/snacks/ingredient/pizza1/P = new /obj/item/reagent_containers/food/snacks/ingredient/pizza1(src.loc)
			user.u_equip(src)
			user.put_in_hand_or_drop(P)
			qdel(src)
		else ..()

/obj/item/reagent_containers/food/snacks/ingredient/dough_s
	name = "sweet dough"
	desc = "Used for making cakey things."
	icon_state = "dough_s"
	amount = 1

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/axe) || istype(W, /obj/item/circular_saw) || istype(W, /obj/item/kitchen/utensil/knife) || istype(W, /obj/item/scalpel) || istype(W, /obj/item/sword) || istype(W,/obj/item/saw) || istype(W,/obj/item/knife_butcher))
			boutput(user, "<span style=\"color:blue\">You cut [src] into smaller pieces...</span>")
			for(var/i = 1, i <= 4, i++)
				new /obj/item/reagent_containers/food/snacks/ingredient/dough_cookie(get_turf(src))
			qdel(src)
		else ..()

/obj/item/reagent_containers/food/snacks/ingredient/dough_cookie
	name = "cookie dough"
	desc = "Probably shouldn't be eaten raw, not that THAT'S ever stopped anyone."
	icon_state = "cookie_dough"
	amount = 1
	custom_food = 1

	New()
		..()
		src.pixel_x = rand(-6, 6)
		src.pixel_y = rand(-6, 6)

	heal(var/mob/M)
		if(prob(15))
			wrap_pathogen(M.reagents, generate_indigestion_pathogen(), 15)
			boutput(M, "<span style=\"color:red\">That tasted a little bit...off.</span>")
		..()

/obj/item/reagent_containers/food/snacks/ingredient/tortilla
	name = "uncooked tortilla"
	desc = "An uncooked flour tortilla."
	amount = 1
	icon_state = "tortillabase"
	food_color = "#FFFFFF"
	New()
		..()
		src.pixel_x = rand(-8, 8)
		src.pixel_y = rand(-8, 8)

/obj/item/reagent_containers/food/snacks/ingredient/pizza1
	name = "unfinished pizza base"
	desc = "You need to add tomatoes..."
	icon_state = "pizzabase"
	amount = 1

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/reagent_containers/food/snacks/condiment/ketchup) || istype(W, /obj/item/reagent_containers/food/snacks/plant/tomato))
			boutput(user, "<span style=\"color:blue\">You add [W] to [src].</span>")
			var/obj/item/reagent_containers/food/snacks/ingredient/pizza2/D=new /obj/item/reagent_containers/food/snacks/ingredient/pizza2(W.loc)
			user.u_equip(W)
			user.put_in_hand_or_drop(D)
			qdel(W)
			qdel(src)
		else if (istype(W, /obj/item/axe) || istype(W, /obj/item/circular_saw) || istype(W, /obj/item/kitchen/utensil/knife) || istype(W, /obj/item/scalpel) || istype(W, /obj/item/sword) || istype(W,/obj/item/saw) || istype(W,/obj/item/knife_butcher))
			boutput(user, "<span style=\"color:blue\">You cut [src] into smaller pieces...</span>")
			for(var/i = 1, i <= 3, i++)
				new /obj/item/reagent_containers/food/snacks/ingredient/tortilla(get_turf(src))
			qdel(src)
		else ..()

	attack_self(var/mob/user as mob)
		boutput(user, "<span style=\"color:blue\">You knead the [src] back into a blob.</span>")
		new /obj/item/reagent_containers/food/snacks/ingredient/dough(get_turf(src))
		qdel (src)

/obj/item/reagent_containers/food/snacks/ingredient/pizza2
	name = "half-finished pizza base"
	desc = "You need to add cheese..."
	icon_state = "pizzabase2"
	amount = 1
	custom_food = 0

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/reagent_containers/food/snacks/ingredient/cheese))
			boutput(user, "<span style=\"color:blue\">You add [W] to [src].</span>")
			var/obj/item/reagent_containers/food/snacks/pizza/D = new /obj/item/reagent_containers/food/snacks/pizza(W.loc)
			user.u_equip(W)
			user.put_in_hand_or_drop(D)
			qdel(W)
			qdel(src)
		else ..()

/obj/item/reagent_containers/food/snacks/ingredient/chips
	name = "uncooked chips"
	desc = "Cook them up into some nice fries."
	icon_state = "pchips"
	amount = 6
	heal_amt = 0
	food_color = "#FFFF99"

	heal(var/mob/M)
		boutput(M, "<span style=\"color:red\">Raw potato tastes pretty nasty...</span>") // does it?

/obj/item/reagent_containers/food/snacks/ingredient/spaghetti
	name = "sperghetti noodles"
	desc = "Original italian sperghetti spaghetti noodles."
	icon_state = "sperghetti"
	heal_amt = 0
	amount = 1

	attackby(obj/item/W as obj, mob/user as mob)
		if(istype(W,/obj/item/reagent_containers/food/snacks/condiment/ketchup))
			boutput(user, "<span style=\"color:blue\">You create sperghetti with tomato sauce...</span>")
			var/obj/item/reagent_containers/food/snacks/spaghetti/sauce/D = new/obj/item/reagent_containers/food/snacks/spaghetti/sauce(W.loc)
			user.u_equip(W)
			user.put_in_hand_or_drop(D)
			qdel(W)
			qdel(src)

	heal(var/mob/M)
		boutput(M, "<span style=\"color:red\">The noodles taste terrible uncooked...</span>")
		..()
