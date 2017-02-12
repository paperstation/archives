
/obj/item/reagent_containers/food/snacks/breadloaf
	name = "loaf of bread"
	desc = "I'm loafin' it!"
	icon = 'icons/obj/foodNdrink/food_bread.dmi'
	icon_state = "breadloaf"
	amount = 1
	heal_amt = 1
	food_color = "#FFFFCC"
	real_name = "bread"
	var/slicetype = /obj/item/reagent_containers/food/snacks/breadslice
	initial_volume = 30

	attack(mob/M as mob, mob/user as mob, def_zone)
		if (user == M)
			boutput(user, "<span style=\"color:red\">You can't just cram that in your mouth, you greedy beast!</span>")
			user.visible_message("<b>[user]</b> stares at [src] in a confused manner.")
			return
		else
			user.visible_message("<span style=\"color:red\"><b>[user]</b> futilely attempts to shove [src] into [M]'s mouth!</span>")
			return

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/axe) || istype(W, /obj/item/circular_saw) || istype(W, /obj/item/kitchen/utensil/knife) || istype(W, /obj/item/scalpel) || istype(W, /obj/item/sword) || istype(W,/obj/item/knife_butcher))
			if(user.bioHolder.HasEffect("clumsy") && prob(50))
				user.visible_message("<span style=\"color:red\"><b>[user]</b> fumbles and jabs \himself in the eye with [W].</span>")
				user.change_eye_blurry(5)
				user.weakened = max(3, user.weakened)
				return

			var/turf/T = get_turf(src)
			user.visible_message("[user] cuts [src] into slices.", "You cut [src] into slices.")
			var/makeslices = 6
			while (makeslices > 0)
				new slicetype (T)
				makeslices -= 1
			qdel (src)
		else ..()

	New()
		..()
		reagents.add_reagent("bread", 30)

/obj/item/reagent_containers/food/snacks/breadloaf/honeywheat
	name = "loaf of honey-wheat bread"
	desc = "A bread made with honey. Right there in the name, first thing, top billing."
	icon_state = "honeyloaf"
	amount = 1
	heal_amt = 1
	real_name = "honey-wheat bread"
	slicetype = /obj/item/reagent_containers/food/snacks/breadslice/honeywheat

/obj/item/reagent_containers/food/snacks/breadloaf/banana
	name = "loaf of banana bread"
	desc = "A bread commonly found near clowns."
	icon_state = "bananabread"
	amount = 1
	heal_amt = 1
	real_name = "banana bread"
	slicetype = /obj/item/reagent_containers/food/snacks/breadslice/banana

/obj/item/reagent_containers/food/snacks/breadloaf/brain
	name = "loaf of brain bread"
	desc = "A pretty smart way to eat."
	icon_state = "brainbread"
	amount = 1
	heal_amt = 1
	real_name = "brain bread"
	slicetype = /obj/item/reagent_containers/food/snacks/breadslice/brain

/obj/item/reagent_containers/food/snacks/breadloaf/pumpkin
	name = "loaf of pumpkin bread"
	desc = "A very seasonal quickbread!  It tastes like Fall."
	icon_state = "pumpkinbread"
	amount = 1
	heal_amt = 1
	real_name = "pumpkin bread"
	slicetype = /obj/item/reagent_containers/food/snacks/breadslice/pumpkin

/obj/item/reagent_containers/food/snacks/breadloaf/elvis
	name = "loaf of elvis bread"
	desc = "Fattening and delicious, despite the hair.  It tastes like the soul of rock and roll."
	icon_state = "elvisbread"
	amount = 1
	heal_amt = 1
	real_name ="elvis bread"
	slicetype = /obj/item/reagent_containers/food/snacks/breadslice/elvis

/obj/item/reagent_containers/food/snacks/breadloaf/spooky
	name = "loaf of dread"
	desc = "The bread of the damned."
	icon_state = "dreadloaf"
	amount = 1
	heal_amt = 1
	real_name = "dread"
	slicetype = /obj/item/reagent_containers/food/snacks/breadslice/spooky

/obj/item/reagent_containers/food/snacks/breadloaf/corn
	name = "southern-style cornbread"
	desc = "A maize-based quickbread.  This variety, popular in the Southern United States, is not particularly sweet."
	icon_state= "cornbread"
	amount = 1
	heal_amt = 1
	real_name = "cornbread"
	slicetype = /obj/item/reagent_containers/food/snacks/breadslice/corn

	sweet
		name = "northern-style cornbread"
		desc = "A chunk of sweet maize-based quickbread."
		slicetype = /obj/item/reagent_containers/food/snacks/breadslice/corn/sweet

		honey
			name = "honey cornbread"
			desc = "A chunk of honey-sweetened maize-based quickbread."
			slicetype = /obj/item/reagent_containers/food/snacks/breadslice/corn/sweet/honey

/obj/item/reagent_containers/food/snacks/breadslice
	name = "slice of bread"
	desc = "That's slice."
	icon = 'icons/obj/foodNdrink/food_bread.dmi'
	icon_state = "breadslice"
	amount = 1
	heal_amt = 1
	food_color = "#FFFFCC"
	real_name = "bread"

	honeywheat
		name = "slice of honey-wheat bread"
		desc = "A slice of bread distinguished by the use of honey in its creation.  Also wheat."
		icon_state = "honeyslice"
		real_name = "honey-wheat bread"
		food_color = "#C07D1E"

	banana
		name = "slice of banana bread"
		desc = "It's a slice.  A slice of banana bread."
		icon_state = "bananabreadslice"
		amount = 1
		heal_amt = 4
		real_name = "banana bread"
		food_color = "#633821"

	brain
		name = "slice of brain bread"
		desc = "A slice of bread that may or may not be plotting world domination."
		icon_state = "brainbreadslice"
		amount = 1
		heal_amt = 3
		real_name = "brain bread"
		food_color = "#DD90A3"

	pumpkin
		name = "slice of pumpkin bread"
		desc = "A slice of a festive seasonal bread, vaguely like eating a loaf of pumpkin pie."
		icon_state = "pumpkinbreadslice"
		amount = 1
		heal_amt = 5
		real_name = "pumpkin bread"
		food_color = "#D99C1B"

	elvis
		name = "slice of elvis bread"
		desc = "A slice of the most incredible bread you have ever seen."
		icon_state = "elvisslice"
		amount = 1
		heal_amt = 6
		real_name = "elvis bread"
		initial_volume = 30

		New()
			..()
			reagents.add_reagent("essenceofelvis",25)

	spooky
		name = "slice of dread"
		desc = "A slice of the scariest bread imaginable, even scarier than the buns on a microwaved vending machine hamburger."
		icon_state = "dreadslice"
		amount = 1
		heal_amt = 2
		real_name = "dread"
		initial_volume = 30

		New()
			..()
			reagents.add_reagent("ectoplasm",10)

	corn
		name = "piece of southern cornbread"
		desc = "A chunk of maize-based quickbread.  This variety, popular in the Southern United States, is not particularly sweet."
		icon_state = "cornbreadslice"
		heal_amt = 3
		real_name = "cornbread"
		food_color = "#BAAC2C"

	corn/sweet
		name = "piece of northern cornbread"
		desc = "A chunk of sweet maize-based quickbread."
		initial_volume = 25

		New()
			..()
			reagents.add_reagent("cornsyrup",5)

	corn/sweet/honey
		name = "piece of honey cornbread"
		initial_volume = 25

		New()
			..()
			reagents.add_reagent("honey",10)

	New()
		..()
		src.pixel_x += rand(-3,3)
		src.pixel_y += rand(-3,3)

/obj/item/reagent_containers/food/snacks/breadslice/New()
	..()
	var/datum/reagents/R = new/datum/reagents(5)
	reagents = R
	R.my_atom = src
	R.add_reagent("bread", 5)

/obj/item/reagent_containers/food/snacks/breadslice/toastslice
	name = "slice of toast"
	desc = "Crispy cooked bread."
	icon = 'icons/obj/foodNdrink/food_bread.dmi'
	icon_state = "toast"
	amount = 2
	heal_amt = 1
	food_color = "#CC9966"
	real_name = "toast"

	banana
		name = "slice of banana toast"
		desc = "A less conventional form of crispy bread."
		icon_state = "bananatoast"
		amount = 2
		heal_amt = 4

	brain
		name = "slice of brain toast"
		desc = "Historians believe that brain toast originated due to a garbled request for crispy bread made from wheat bran."
		icon_state = "braintoast"
		amount = 2
		heal_amt = 3
		real_name = "brain toast"

	elvis
		name = "slice of elvis toast"
		desc = "Just when you thought Elvis couldn't get any hotter."
		icon_state = "elvistoast"
		amount = 2
		heal_amt = 5
		real_name = "elvis toast"
		initial_volume = 25

		New()
			..()
			reagents.add_reagent("essenceofelvis",25)

	spooky
		name = "slice of terror toast"
		desc = "It's scarier than regular toast.  That doesn't really say much unless you are going low-carb though."
		icon_state = "terrortoast"
		amount = 2
		heal_amt = 2
		real_name = "terror toast"

	New()
		..()
		src.pixel_x += rand(-3,3)
		src.pixel_y += rand(-3,3)

/obj/item/reagent_containers/food/snacks/toastcheese
	name = "cheese on toast"
	desc = "A quick cheesy snack."
	icon = 'icons/obj/foodNdrink/food_bread.dmi'
	icon_state = "cheesetoast"
	amount = 2
	heal_amt = 2
	food_color = "#CC9966"
	real_name = "toast cheese"

	elvis
		name = "cheese on elvis toast"
		desc = "The king of cheesy toast."
		icon_state = "cheesyelvis"
		amount = 3
		heal_amt = 6
		real_name = "elvis cheese toast"
		initial_volume = 30

		New()
			..()
			reagents.add_reagent("essenceofelvis",25)

	New()
		..()
		src.pixel_x += rand(-3,3)
		src.pixel_y += rand(-3,3)

/obj/item/reagent_containers/food/snacks/toastbacon
	name = "bacon on toast"
	desc = "Is this a real snack anywhere? Honestly?"
	icon = 'icons/obj/foodNdrink/food_bread.dmi'
	icon_state = "bacontoast"
	amount = 2
	heal_amt = 3
	food_color = "#CC9966"
	real_name = "bacon toast"
	initial_volume = 30

	elvis
		name = "bacon on elvis toast"
		desc = "Oh, come on. That just does not look healthy."
		icon_state = "baconelvis"
		amount = 3
		heal_amt = 4
		real_name ="bacon elvis toast"

		New()
			..()
			reagents.add_reagent("essenceofelvis",25)

	New()
		..()
		src.pixel_x += rand(-3,3)
		src.pixel_y += rand(-3,3)
		reagents.add_reagent("porktonium", 5)
