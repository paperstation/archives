
// Bad food

/obj/item/reagent_containers/food/snacks/yuck
	name = "?????"
	desc = "How the hell did they manage to cook this abomination..?!"
	icon_state = "yuck"
	amount = 1
	heal_amt = 0
	food_color = "#d6d6d8"
	initial_volume = 25

	New()
		..()
		reagents.add_reagent("yuck",25)

/obj/item/reagent_containers/food/snacks/yuckburn
	name = "smoldering mess"
	desc = "This looks more like charcoal than food..."
	icon_state = "burnt"
	amount = 1
	heal_amt = 0
	food_color = "#33302b"
	initial_volume = 25

	New()
		..()
		reagents.add_reagent("yuck",25)

/obj/item/reagent_containers/food/snacks/fry_holder
	name = "physical manifestation of the very concept of fried foods"
	desc = "Oh, the power of the deep fryer."
	heal_amt = 10
	icon = 'icons/obj/food.dmi'
	icon_state = "fried"


	on_finish(mob/eater)
		..()
		if(iscarbon(eater))
			var/mob/living/carbon/C = eater
			for(var/atom/movable/MO as mob|obj in src)
				MO.set_loc(C)
				C.stomach_contents += MO

	disposing()
		for (var/mob/M in src)
			M.ghostize()
			for (var/obj/item/I in M)
				I.dispose()
		..()

/obj/item/reagent_containers/food/snacks/pizza
	name = "pizza"
	desc = "A plain cheese and tomato pizza."
	icon = 'icons/obj/foodNdrink/food_meals.dmi'
	icon_state = "pizza_p"
	amount = 6
	heal_amt = 3
	var/topping_color = null
	var/sliced = 0
	var/topping = 0
	custom_food = 0

	New()
		..()
		if (prob(1))
			spawn( rand(300, 900) )
				src.visible_message("<b>[src]</b> <i>says, \"I'm pizza.\"</i>")

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/axe) || istype(W, /obj/item/circular_saw) || istype(W, /obj/item/kitchen/utensil/knife) || istype(W, /obj/item/scalpel) || istype(W, /obj/item/sword) || istype(W,/obj/item/saw) || istype(W,/obj/item/knife_butcher))
			if (src.sliced == 1)
				boutput(user, "<span style=\"color:red\">This has already been sliced.</span>")
				return
			boutput(user, "<span style=\"color:blue\">You cut the pizza into slices.</span>")
			if (src.name == "cheese keyzza")
				boutput(user, "<i>You feel as though something of value has been lost...</i>")
			var/makeslices = src.amount
			while (makeslices > 0)
				var/obj/item/reagent_containers/food/snacks/pizza/P = new src.type(get_turf(src))
				P.sliced = 1
				P.amount = 1
				P.icon_state = "pslice"
				P.quality = src.quality
				if(topping)
					P.name = src.name
					P.desc = src.desc
					P.topping = 1
					P.topping_color = src.topping_color
					P.add_topping(1)
				src.reagents.trans_to(P, src.reagents.total_volume/makeslices)
				P.pixel_x = rand(-6, 6)
				P.pixel_y = rand(-6, 6)
				makeslices--
			qdel (src)
		else if (istype(W, /obj/item/reagent_containers/food/snacks/) && !(topping) && !(sliced))
			var/obj/item/reagent_containers/food/snacks/F = W
			if(!F.custom_food)
				return
			topping = 1
			boutput(user, "<span style=\"color:blue\">You add [W] to [src].</span>")
			if(F.real_name)
				src.name = "[F.real_name] pizza"
			else
				src.name = "[W.name] pizza"
			desc = "A pizza with [W.name] toppings"
			if(istype(W,/obj/item/reagent_containers/food/snacks/ingredient/))
				heal_amt = 4
			else
				heal_amt = round((F.heal_amt * F.amount)/amount) + 1
			topping_color = F.food_color
			add_topping(0)
			W.reagents.trans_to(src, W.reagents.total_volume)
			user.u_equip(W)
			qdel (W)

	attack(mob/M as mob, mob/user as mob, def_zone)
		if (!src.sliced)
			if (user == M)
				boutput(user, "<span style=\"color:red\">You can't just cram that in your mouth, you greedy beast!</span>")
				user.visible_message("<b>[user]</b> stares at [src] in a confused manner.")
				return
			else
				user.visible_message("<span style=\"color:red\"><b>[user]</b> futilely attempts to shove [src] into [M]'s mouth!</span>")
				return
		else
			..()

	proc/add_topping(var/num)
		var/icon/I
		if(num == 0)
			I = new /icon('icons/obj/foodNdrink/food_meals.dmi',"pizza_topping")
		else
			I = new /icon('icons/obj/foodNdrink/food_meals.dmi',"pizza_topping_s")
		I.Blend(topping_color, ICON_ADD)
		src.overlays += I

/obj/item/reagent_containers/food/snacks/cookie
	name = "sugar cookie"
	desc = "Outside of North America, the Earth's Moon, and certain regions of Europa, these are referred to as biscuits."
	icon = 'icons/obj/foodNdrink/food_snacks.dmi'
	icon_state = "cookie_sugar"
	amount = 1
	heal_amt = 1
	var/frosted = 0
	food_color = "#CC9966"
	festivity = 1

	New()
		..()
		src.pixel_x = rand(-6, 6)
		src.pixel_y = rand(-6, 6)

	attackby(obj/item/W as obj, mob/user as mob)
		if (!frosted && istype(W, /obj/item/reagent_containers/food/snacks/condiment/cream))
			src.frosted = 1

			var/list/frosting_colors = list(rgb(0,0,255),rgb(204,0,102),rgb(255,255,0),rgb(51,153,0))
			var/icon/frosticon = icon('icons/obj/foodNdrink/food_snacks.dmi', "frosting-cookie", src.dir, 1)
			frosticon.Blend( pick(frosting_colors) )
			src.overlays += frosticon

		else
			..()
		return

	metal
		name = "iron cookie"
		desc = "A cookie made out of iron. You could probably use this as a coaster or something."
		heal_amt = 0
		icon_state = "cookie_metal"

	chocolate_chip
		name = "chocolate-chip cookie"
		desc = "Invented during the Great Depression, this chocolate-laced cookie was a key element of FDR's New Deal policies."
		icon_state = "cookie_chips"
		heal_amt = 2
		initial_volume = 15

		New()
			..()
			reagents.add_reagent("chocolate", 10)

	oatmeal
		name = "oatmeal cookie"
		desc = "This cookie has been designed specifically to evoke memories of one's grandparents."
		icon_state = "cookie_medium"
		heal_amt = 2

	bacon
		name = "bacon cookie"
		desc = "A cookie made out of bacon. Is this intended to be savory or a sweet candied bacon sort of thing? Whatever it is, it's pretty dumb."
		icon_state = "cookie_bacon"
		initial_volume = 50

		New()
			..()
			reagents.add_reagent("porktonium", 25)

	jaffa
		name = "jaffa cake"
		desc = "Legally a cake, this edible consists of precision layers of chocolate, sponge cake, and orange jelly."
		icon_state = "cookie_jaffa"

	spooky
		name = "spookie"
		desc = "Two ounces of pure terror."
		icon_state = "cookie_spooky"
		frosted = 1
		initial_volume = 25

		New()
			..()
			reagents.add_reagent("ectoplasm",10)

/obj/item/reagent_containers/food/snacks/moon_pie
	name = "sugar moon pie"
	desc = "A confection consisting of a creamy filling sandwiched between two cookies."
	icon = 'icons/obj/foodNdrink/food_snacks.dmi'
	icon_state = "moonpie_sugar"
	amount = 1
	heal_amt = 6
	var/frosted = 0

	New()
		..()
		src.pixel_x = rand(-6, 6)
		src.pixel_y = rand(-6, 6)

	attackby(obj/item/W as obj, mob/user as mob)
		if (!frosted && istype(W, /obj/item/reagent_containers/food/snacks/condiment/cream))
			src.frosted = 1

			var/list/frosting_colors = list(rgb(0,0,255),rgb(204,0,102),rgb(255,255,0),rgb(51,153,0))
			var/icon/frosticon = icon('icons/obj/foodNdrink/food_snacks.dmi', "frosting-moonpie", src.dir, 1)
			frosticon.Blend(pick(frosting_colors) )
			src.overlays += frosticon

		else
			..()
		return

	metal
		name = "iron moon pie"
		desc = "Definitely not food.  Not even a good coaster anymore, what with all the cream."
		icon_state = "moonpie_metal"
		heal_amt = 0

	chocolate_chip
		name = "chocolate-chip moon pie"
		desc = "The confection commonly credited with winning the Korean, Gulf, and Unfolder wars."
		icon_state = "moonpie_chips"
		heal_amt = 7

	oatmeal
		name = "oatmeal moon pie"
		desc = "The official pie of the moon.  This one.  This specific sandwich cookie right here."
		icon_state = "moonpie_oatmeal"
		heal_amt = 7

	bacon
		name = "bacon moon pie"
		desc = "How is this even food?"
		icon_state = "moonpie_bacon"
		heal_amt = 5
		initial_volume = 50

		New()
			..()
			reagents.add_reagent("porktonium", 50)

	jaffa
		name = "jaffa moon cobbler"
		desc = "This dish was named in an attempt to dodge sales taxes on pie production. However, it is actually legally considered a form of crumble."
		icon_state = "moonpie_jaffa"
		heal_amt = 8

	chocolate
		name = "whoopie pie"
		desc = "A confection infamous for being especially terrible for you, in a culture noted for having nothing but foods that are terrible for you."
		icon_state = "moonpie_chocolate"
		heal_amt = 250 //oh jesus

	spooky
		name = "full moon pie"
		desc = "Caution: Do not serve confection within sight of a werewolf, wolfman, or particularly-hairy crew members."
		icon_state = "moonpie_spooky"
		heal_amt = 6
		frosted = 1
		initial_volume = 25

		New()
			..()
			reagents.add_reagent("ectoplasm",10)

/obj/item/reagent_containers/food/snacks/soup
	name = "soup"
	desc = "A soup of indeterminable type."
	icon = 'icons/obj/foodNdrink/food_meals.dmi'
	icon_state = "gruel"
	needspoon = 1
	amount = 6
	heal_amt = 1
	w_class = 2
	initial_volume = 100

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/reagent_containers/food/snacks/tortilla_chip))
			if (amount <= 1)
				boutput(user, "You scoop up the last of [src] with the [W.name].")
			else
				boutput(user, "You scoop some of [src] with the [W.name].")

			if (src.reagents)
				src.reagents.trans_to(W, src.reagents.total_volume/amount)

			src.amount--
			if (!amount)
				qdel(src)
		else
			..()

/obj/item/reagent_containers/food/snacks/soup/tomato
	name = "tomato soup"
	desc = "A rich and creamy soup made from tomatoes."
	icon_state = "tomsoup"
	needspoon = 1
	amount = 6
	heal_amt = 2

/obj/item/reagent_containers/food/snacks/soup/guacamole
	name = "guacamole"
	desc = "A spiced paste made of smashed avocados."
	icon_state = "guacamole"
	needspoon = 1
	amount = 6
	heal_amt = 2
	food_color = "#007B1C"

	New()
		..()
		reagents.add_reagent("guacamole", 90)

/obj/item/reagent_containers/food/snacks/soup/chili
	name = "chili con carne"
	desc = "Meat pieces in a spicy pepper sauce. Delicious."
	icon_state = "tomsoup"
	needspoon = 1
	amount = 6
	heal_amt = 2

	New()
		..()
		reagents.add_reagent("capsaicin", 20)

/obj/item/reagent_containers/food/snacks/soup/queso
	name = "chili con queso"
	desc = "Spicy mexican cheese stuff."
	icon_state = "custard"
	needspoon = 1
	amount = 6
	heal_amt = 2
	food_color = "#FF8C00"

	New()
		..()
		reagents.add_reagent("capsaicin", 10)

/obj/item/reagent_containers/food/snacks/soup/superchili
	name = "chili con flagration"
	desc = "God damn. This stuff smells strong."
	icon_state = "tomsoup"
	needspoon = 1
	amount = 6
	heal_amt = 2

	New()
		..()
		reagents.add_reagent("capsaicin", 50)

/obj/item/reagent_containers/food/snacks/soup/ultrachili
	name = "El Diablo"
	desc = "You feel overheated just looking at this dish."
	icon_state = "hotchili"
	needspoon = 1
	amount = 2
	heal_amt = 6

	New()
		..()
		reagents.add_reagent("el_diablo", 90)


/obj/item/reagent_containers/food/snacks/soup/gruel
	name = "gruel"
	desc = "Asking if you can have more is probably ill-advised."
	icon_state = "gruel"
	needspoon = 1
	amount = 6
	heal_amt = 0
	food_color = "#808080"

	heal(var/mob/M)
		if (prob(15)) boutput(M, "<span style=\"color:red\">You feel depressed.</span>")

/obj/item/reagent_containers/food/snacks/soup/oatmeal
	name = "oatmeal"
	desc = "Sometimes the station gets the fun kind with the little candy dinosaur eggs. This isn't the fun kind."
	icon_state = "oatmeal_plain"
	needspoon = 1
	amount = 6
	heal_amt = 2
	var/randomized = 1

	New()
		..()
		if (randomized)
			src.name = "[pick("cranberry", "apple cinnamon", "maple", "cran-apple";5, "blueberry-maple";5, "peaches and cream", "bananas and cream", "strawberries and cream", "plain", "cinnamon", "raisins, dates, and walnuts";5)] oatmeal"
		return


	fun
		desc = "The fun kind of oatmeal with the little candy dinosaur eggs.  HECK YES!"
		icon_state = "oatmeal_fun"
		randomized = 0

		heal(var/mob/M)
			var/dinosaur = pick("Ohmdenosaurus","Velafrons","Saurophaganax","Bissektipelta","Aardonyx","Tsintaosaurus","Barapasaurus","Rahonavis")
			boutput(M, "<span style=\"color:blue\">You found a marshmallow [dinosaur] in this bite!</span>")
			..()

/obj/item/reagent_containers/food/snacks/soup/creamofmushroom
	name= "cream of mushroom"
	desc = "A thick soup that can be made from various mushrooms."
	icon_state = "gruel"
	needspoon = 1
	amount = 6
	heal_amt = 2

/obj/item/reagent_containers/food/snacks/soup/creamofmushroom/amanita
	name= "cream of mushroom"
	desc = "A thick soup that can be made from various mushrooms."
	icon_state = "gruel"
	needspoon = 1
	amount = 6
	heal_amt = 2
	initial_volume = 30

	New()
		..()
		reagents.add_reagent("amanitin", 30)

/obj/item/reagent_containers/food/snacks/soup/creamofmushroom/psilocybin
	name= "cream of mushroom"
	desc = "A thick soup that can be made from various mushrooms."
	icon_state = "gruel"
	needspoon = 1
	amount = 6
	heal_amt = 2
	initial_volume = 60

	New()
		..()
		reagents.add_reagent("psilocybin", 20)
		reagents.add_reagent("LSD", 20)
		reagents.add_reagent("space_drugs", 20)

/obj/item/reagent_containers/food/snacks/salad
	name = "salad"
	desc = "A meal of mostly plants. Good for healthy eating."
	icon = 'icons/obj/foodNdrink/food_meals.dmi'
	icon_state = "salad"
	needfork = 1
	amount = 4
	heal_amt = 2

	heal(var/mob/M)
		if (istype(M, /mob/living/carbon/human))
			if (M.nutrition > 200) M.nutrition -= 30

/obj/item/reagent_containers/food/snacks/cereal_box
	name = "cereal box -'Pope Crunch'"
	desc = "A sugary breakfast cereal with a papal mascot. Each 1/8 cup serving is an important part of a balanced breakfast!"
	icon_state = "cereal_box"
	amount = 11
	real_name = "cereal"
	w_class = 2
	var/prize = 10 //Chance of a rad prize inside!

	New()
		..()
		if (prize > 0)
			prize = prob(prize)

	attack(mob/M as mob, mob/user as mob, def_zone)
		if (user == M)
			user.visible_message("<b>[user]</b> pours [src] directly into their mouth!", "You eat straight from the box!")
		else
			user.visible_message("<span style=\"color:red\"><b>[user]</b> pours [src] into [M]'s mouth!</span>")

		//Hello, here is a dumb hack to get around "you take a bite of cerealbox-'Pope Crunch'!"
		// apparently there was a runtime error here, i'm guessing someone edited a cereal box's name?
		var/name_len = length(src.name)
		if (name_len > 14)
			var/tempname = src.name
			src.name = copytext(src.name, 14, name_len)
			..()
			src.name = tempname
		else
			..()

		return

/obj/item/reagent_containers/food/snacks/cereal_box/honey
	name = "cereal box -'Honey Wonks'"
	desc = "A honey-sweetened breakfast cereal. A total sugarbomb, but it probably contains some vitamins or something."
	icon_state = "cereal_box2"
	prize = 0

/obj/item/reagent_containers/food/snacks/soup/cereal
	name = "dry cereal"
	desc = "A bowl of colorful breakfast cereal, each piece sharp enough to slice the roof of your mouth into meat confetti."
	icon_state = "cereal_bowl"
	amount = 5
	heal_amt = 1
	var/dry = 1
	var/hasPrize = 0

	New(loc, prize_inside)
		..()
		hasPrize = (prize_inside == 1)

	on_reagent_change()
		if (src.reagents && src.reagents.total_volume)
			src.name = "cereal"
			src.dry = 0
		else
			src.name = "[src.dry ? "dry" : "soggy"] cereal"

	heal(var/mob/M)
		M.reagents.add_reagent("sugar",15)
		if(src.dry)
			boutput(M, "<span style=\"color:red\">It cuts the roof of your mouth! WHY DID YOU TRY EATING THIS DRY?!</span>")
			random_brute_damage(M, 3)
			M.emote("scream")

		if(src.hasPrize && ishuman(M))
			var/mob/living/carbon/human/H = M
			var/obj/item/affecting = H.organs["head"]
			boutput(H, "<span style=\"color:red\">You slash your mouth and tongue open on a piece of jagged rusty metal! Looks like you found the prize inside!</span>")
			H.weakened = max(3, H.weakened)
			affecting.take_damage(10, 0)
			H.UpdateDamageIcon()
			H.updatehealth()
			src.hasPrize = 0
			new /obj/item/razor_blade( get_turf(src) )


		..()

	disposing()
		if (src.amount < 1)
			new /obj/item/reagent_containers/food/drinks/bowl(get_turf(src))
		..()

	is_open_container()
		return 1

/obj/item/reagent_containers/food/snacks/waffles
	name = "waffles"
	desc = "Mmm, waffles"
	icon = 'icons/obj/foodNdrink/food_dessert.dmi'
	icon_state = "waffles"
	amount = 5
	heal_amt = 2

/obj/item/reagent_containers/food/snacks/donkpocket
	name = "donk-pocket"
	desc = "The food of choice for the seasoned traitor."
	icon_state = "donkpocket"
	heal_amt = 1
	amount = 1
	doants = 0
	var/warm = 0

	warm
		name = "warm donk-pocket"
		warm = 1

		New()
			..()
			src.cooltime()
			return

	heal(var/mob/M)
		if(src.warm && M.reagents)
			M.reagents.add_reagent("omnizine",15)
		else
			boutput(M, "<span style=\"color:red\">It's just not good enough cold..</span>")
		..()

	temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
		if (!warm && exposed_temperature >= T0C+176.7) //Roughly 350 C
			src.warm = 1
			name = "warm [initial(src.name)]"
			src.cooltime()

		return ..()

	proc/cooltime()
		if (src.warm)
			spawn( 4200 )
				src.warm = 0
				src.name = "donk-pocket"
		return

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/reagent_containers/food/snacks/condiment/)) src.amount += 1

/obj/item/reagent_containers/food/snacks/donkpocket_w
	name = "donk-pocket"
	desc = "This donk-pocket is emitting a small amount of heat."
	icon_state = "donkpocket"
	heal_amt = 25
	amount = 1
	heal(var/mob/M)
		if(M.reagents)
			M.reagents.add_reagent("omnizine",15)
			M.reagents.add_reagent("teporone", 15)
			M.reagents.add_reagent("synaptizine", 15)
			M.reagents.add_reagent("saline", 15)
			M.reagents.add_reagent("salbutamol", 15)
			M.reagents.add_reagent("methamphetamine", 15)
		..()

/obj/item/reagent_containers/food/snacks/breakfast
	name = "bacon and eggs"
	desc = "A plate containing a breakfast meal of both bacon AND eggs. Together!"
	icon_state = "breakfast"
	amount = 4
	heal_amt = 4
	needfork = 1

/obj/item/reagent_containers/food/snacks/meatball
	name = "meatball"
	desc = "A great meal all round."
	icon_state = "meatball"
	amount = 1
	heal_amt = 2
	food_color ="#663300"

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/reagent_containers/food/snacks/condiment/)) src.amount += 1

/obj/item/reagent_containers/food/snacks/swedishmeatball
	name = "swedish meatballs"
	desc = "It's even got a little rice-paper swedish flag in it. How cute."
	icon_state = "swede_mball"
	needfork = 1
	amount = 6
	heal_amt = 2
	food_color ="#663300"
	initial_volume = 30

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/reagent_containers/food/snacks/condiment/)) src.amount += 1

	New()
		..()
		reagents.add_reagent("swedium",25)

/obj/item/reagent_containers/food/snacks/surstromming
	name = "funny-looking can"
	icon = 'icons/obj/foodNdrink/food_snacks.dmi'
	icon_state = "surs_closed" //todo: get real sprite
	heal_amt = 0
	amount = 5
	desc = ""

	attack(mob/M as mob, mob/user as mob, def_zone)
		if (src.icon_state == "surs_closed")
			if (user == M)
				boutput(user, "<span style=\"color:red\">You need to take the lid off first, you greedy beast!</span>")
				user.visible_message("<b>[user]</b> stares at [src] in a confused manner.")
				return
			else
				user.visible_message("<span style=\"color:red\"><b>[user]</b> futilely attempts to shove [src] into [M]'s mouth!</span>")
				return
		else
			..()

	New()
		..()
		if (!(src in processing_items))
			processing_items.Add(src)

	process()
		if (prob(30) && src.icon_state == "surs_open")
			for(var/mob/living/carbon/H in viewers(src, null))
				if (H.bioHolder.HasEffect("accent_swedish"))
					return
				boutput(H, "<span style=\"color:red\">[stinkString()]</span>")
				if(prob(30))
					new/obj/decal/cleanable/vomit(H.loc)
					H.stunned += 2
					boutput(H, "<span style=\"color:red\">[stinkString()]</span>")
					H.visible_message("<span style=\"color:red\">[H] vomits, unable to handle the fishy stank!</span>")
					playsound(H.loc, "sound/effects/splat.ogg", 50, 1)

	disposing()
		processing_items.Remove(src)
		..()


	heal(var/mob/M)
		if (M.bioHolder.HasEffect("accent_swedish"))
			boutput(M, "<span style=\"color:blue\">It tastes just like the old country!</span>")
			M.reagents.add_reagent("love", 5)
			..()
		else
			var/effect = rand(1,21)
			switch(effect)
				if(1 to 5)
					boutput(M, "<span style=\"color:red\">aaaaaAAAAA<b>AAAAAAAA</b></span>")
					M.visible_message("<span style=\"color:red\">[M] suddenly and violently vomits!</span>")
					playsound(M.loc, "sound/effects/splat.ogg", 50, 1)
					new /obj/decal/cleanable/vomit(M.loc)
					M.weakened+= 4
				if(6 to 10)
					boutput(M, "<span style=\"color:red\">A squirt of some foul-smelling juice gets in your sinuses!!!</span>")
					M.emote("scream")
					M.emote("sneeze")
					M.weakened+= 4
					spawn(0)
						while(prob(75))
							sleep(rand(50,75))
							boutput(M, "<span style=\"color:red\">Some of the horrible juice in your nose drips into the back of your throat!!</span>")
							M.emote("sneeze")
							playsound(M.loc, "sound/effects/splat.ogg", 50, 1)
							new /obj/decal/cleanable/vomit(M.loc)
							M.stunned+= 2
				if(11 to 15)
					boutput(M, "<span style=\"color:blue\">Huh. That wasn't so bad. <span style=\"color:red\">WAIT NEVERMIND THERE'S THE AFTERTASTE</span></span>")
					M.emote ("cry")
					M.weakened+= 4
				if(16 to 20)
					boutput(M, "<span style=\"color:red\">AGHBGLBLGHLGBGLHGHBLGH</span>")
					M.visible_message("<span style=\"color:red\">[M] pukes their guts out!</span>")
					playsound(M.loc, "sound/effects/splat.ogg", 50, 1)
					M.weakened+= 4
					if (ishuman(M))
						var/mob/living/carbon/human/H = M

						var/obj/decal/cleanable/blood/gibs/G = null // For forensics (Convair880).
						G = new /obj/decal/cleanable/blood/gibs(M.loc)
						if (H.bioHolder.Uid && H.bioHolder.bloodType)
							G.blood_DNA = H.bioHolder.Uid
							G.blood_type = H.bioHolder.bloodType

						if (prob(5) && H.organHolder && H.organHolder.heart)
							H.organHolder.drop_organ("heart")

							H.visible_message("<span style=\"color:red\"><b>Wait, is that their heart!?</b></span>")
				if(21)
					if (!M.bioHolder.HasEffect("stinky"))
						boutput(M, "<span style=\"color:red\">Oh God, the stink is <b>inside</b> you now!</span>")
						M.bioHolder.AddEffect("stinky")
						M.stunned+= 2
						return
					else
						boutput(M, "<span style=\"color:red\">The stink of the surströmming combines with your inherent body funk to create a stench of BIBLICAL PROPORTIONS!</span>")
						M.name_suffix("the Stinky")
						M.UpdateName()
		..()


	examine()
		..()
		if (usr.bioHolder.HasEffect("accent_swedish"))
			if (src.icon_state == "surs_closed")
				boutput(usr, "Oooh, a can of surströmming! It's been a while since you've seen one of these. It looks like it's ready to eat.")
			else
				boutput(usr, "Oooh, a can of surströmming! It's been a while since you've seen one of these. It smells heavenly!")
			return
		else
			if (src.icon_state == "surs_closed")
				boutput(usr, "The fuck is this? The label's written in some sort of gibberish, and you're pretty sure cans aren't supposed to bulge like that.")
			else
				boutput(usr, "<b>AAAAAAAAAAAAAAAAUGH AAAAAAAAAAAUGH IT SMELLS LIKE FERMENTED SKUNK EGG BUTTS MAKE IT STOP</b>")
			return

	attack_self(var/mob/user as mob)
		if (src.icon_state == "surs_closed")
			boutput(user, "<span style=\"color:blue\">You pop the lid off the [src].</span>")
			src.icon_state = "surs_open" //todo: get real sprite
			for(var/mob/living/carbon/M in viewers(user, null))
				if (M == user)
					if (user.bioHolder.HasEffect("accent_swedish"))
						boutput(user, "<span style=\"color:blue\">Ahhh, that smells wonderful!</span>")
					else
						boutput(user, "<span style=\"color:red\"><font size=4><B>HOLY FUCK THAT REEKS!!!!!</b></font></span>")
						user.weakened+= 8
						user.visible_message("<span style=\"color:red\">[user] suddenly and violently vomits!</span>")
						playsound(user.loc, "sound/effects/splat.ogg", 50, 1)
						new /obj/decal/cleanable/vomit(user.loc)
				else
					if(M.bioHolder.HasEffect("accent_swedish"))
						boutput(M, "<span style=\"color:blue\">Hey, something smells good!</span>")
					else
						boutput(M, "<span style=\"color:red\"><font size=4><B>WHAT THE FUCK IS THAT SMELL!?</b></font></span>")
						M.weakened+= 4
						M.visible_message("<span style=\"color:red\">[M] suddenly and violently vomits!</span>")
						playsound(M.loc, "sound/effects/splat.ogg", 50, 1)
						new /obj/decal/cleanable/vomit(M.loc)

/obj/item/reagent_containers/food/snacks/chips
	name = "chips"
	desc = "Commander Riker's What-The-Crisps"
	icon = 'icons/obj/foodNdrink/food_snacks.dmi'
	icon_state = "chips"
	heal_amt = 1
	doants = 0

/obj/item/reagent_containers/food/snacks/popcorn
	name = "popcorn"
	desc = "Pop that corn!"
	icon = 'icons/obj/foodNdrink/food_snacks.dmi'
	icon_state =  "popcorn1"
	amount = 4
	heal_amt = 1

/obj/item/reagent_containers/food/snacks/spaghetti/
	name = "sperghetti noodles"
	desc = "Just noodles on their own."
	icon = 'icons/obj/foodNdrink/food_meals.dmi'
	icon_state = "sperg_plain"
	needfork = 1
	heal_amt = 1
	amount = 3

	attackby(obj/item/W as obj, mob/user as mob)
		if(istype(W,/obj/item/reagent_containers/food/snacks/condiment/ketchup))
			boutput(user, "<span style=\"color:blue\">You create sperghetti with tomato sauce...</span>")
			var/obj/item/reagent_containers/food/snacks/spaghetti/sauce/D = new/obj/item/reagent_containers/food/snacks/spaghetti/sauce(W.loc)
			user.u_equip(W)
			user.put_in_hand_or_drop(D)
			qdel(W)
			qdel(src)

	heal(var/mob/M)
		boutput(M, "<span style=\"color:red\">This is really bland.</span>")
		..()

/obj/item/reagent_containers/food/snacks/spaghetti/sauce
	name = "sperghetti with tomato sauce"
	desc = "Eh, the sauce tastes pretty bland..."
	icon_state = "sperg_dish"
	needfork = 1
	heal_amt = 3
	amount = 5

	attackby(obj/item/W as obj, mob/user as mob)
		if(istype(W,/obj/item/reagent_containers/food/snacks/condiment/hotsauce))
			boutput(user, "<span style=\"color:blue\">You create sperghetti arrabbiata!</span>")
			var/obj/item/reagent_containers/food/snacks/spaghetti/spicy/D = new/obj/item/reagent_containers/food/snacks/spaghetti/spicy(W.loc)
			user.u_equip(W)
			user.put_in_hand_or_drop(D)
			qdel(W)
			qdel(src)

/obj/item/reagent_containers/food/snacks/spaghetti/spicy
	name = "sperghetti arrabbiata"
	desc = "Quite spicy!"
	icon_state = "sperg_dish_spicy"
	needfork = 1
	heal_amt = 1
	amount = 5
	initial_volume = 60

	New()
		..()
		reagents.add_reagent("capsaicin", 50)
		reagents.add_reagent("omnizine", 5)
		reagents.add_reagent("synaptizine", 5)

/obj/item/reagent_containers/food/snacks/spaghetti/meatball
	name = "sperghetti and meatballs"
	desc = "That's better!"
	icon_state = "sperg_meatball"
	needfork = 1
	heal_amt = 2
	amount = 5
	initial_volume = 5

	New()
		..()
		reagents.add_reagent("synaptizine", 5)

/obj/item/reagent_containers/food/snacks/donut
	name = "donut"
	desc = "Goes great with Robust Coffee."
	icon = 'icons/obj/foodNdrink/food_snacks.dmi'
	icon_state = "donut1"
	heal_amt = 1

	New()
		..()
		if(rand(1,3) == 1)
			src.icon_state = "donut2"
			src.name = "frosted donut"
			src.heal_amt = 2

	heal(var/mob/M)
		if(istype(M, /mob/living/carbon/human) && M.job in list("Security Officer", "Head of Security", "Detective"))
			src.heal_amt *= 2
			..()
			src.heal_amt /= 2

/obj/item/reagent_containers/food/snacks/mushroom
	name = "space mushroom"
	desc = "A mushroom cap of Space Fungus. Probably tastes pretty bad."
	icon = 'icons/obj/foodNdrink/food_produce.dmi'
	icon_state = "mushroom"
	amount = 1
	heal_amt = 0

/obj/item/reagent_containers/food/snacks/mushroom/amanita
	name = "space mushroom"
	desc = "A mushroom cap of Space Fungus. This one is quite different."
	icon_state = "mushroom-M1"
	amount = 1
	heal_amt = 3

/obj/item/reagent_containers/food/snacks/mushroom/psilocybin
	name = "space mushroom"
	desc = "A mushroom cap of Space Fungus. It's slightly more vibrant than usual."
	icon_state = "mushroom-M2"
	amount = 1
	heal_amt = 1

// Foods

/obj/item/reagent_containers/food/snacks/candy
	name = "candy"
	desc = "Man, that shit looks good. I bet it's got nougat. Fuck."
	icon = 'icons/obj/foodNdrink/food_snacks.dmi'
	icon_state = "candy"
	heal_amt = 1
	real_name = "candy"
	var/sugar_content = 50
	var/razor_blade = 0 //Is this BOOBYTRAPPED CANDY?
	festivity = 1

	New()
		..()
		reagents.add_reagent("sugar", sugar_content)
		return

	attackby(obj/item/W as obj, mob/user as mob)
		if(istype(W, /obj/item/razor_blade))
			boutput(user, "You add the razor blade to [src]")
			qdel(W)
			src.razor_blade = 1
			return

		else
			..()
		return

	heal(var/mob/M)
		if(src.razor_blade && ishuman(M))
			var/mob/living/carbon/human/H = M
			var/obj/item/affecting = H.organs["head"]
			boutput(H, "<span style=\"color:red\">You bite down into a razor blade!</span>")
			H.weakened = max(3, H.weakened)
			affecting.take_damage(10, 0)
			H.UpdateDamageIcon()
			H.updatehealth()
			src.razor_blade = 0
			new /obj/item/razor_blade( get_turf(src) )
		..()

/obj/item/reagent_containers/food/snacks/candy/nougat
	name = "nougat bar"
	desc = "Whoa, that totally has nougat. Heck yes."
	real_name = "nougat"
	icon_state = "nougat0"

	heal(var/mob/M)
		..()
		if (icon_state == "nougat0")
			icon_state = "nougat1"

/obj/item/reagent_containers/food/snacks/candy/caramel
	name = "Goatze's Caramel Cremes"
	desc = "You know you've thought of this when reading the name.  Shame on you."
	real_name = "caramel"
	icon_state = "caramel"

/obj/item/reagent_containers/food/snacks/candy/candy_cane
	name = "candy cane"
	desc = "Holiday treat and aid to limping gingerbread men everywhere."
	real_name = "candy cane"
	icon = 'icons/misc/xmas.dmi'
	icon_state = "candycane"
	sugar_content = 20

//Special HALLOWEEN snacks
//Apple + stick creation

//Candied apples!
/obj/item/reagent_containers/food/snacks/candy/candy_apple
	name = "candy apple"
	desc = "An apple covered in a hard sugar coating."
	icon_state = "candy apple"
	heal_amt = 2

//Candy corn!!
/obj/item/reagent_containers/food/snacks/candy/candy_corn
	name = "candy corn"
	desc = "A confection resembling a kernel of corn. A Halloween classic."
	icon_state = "candy corn"
	real_name = "candy corn"
	amount = 1
	sugar_content = 25
	food_color = "#FFCC00"

	New()
		..()
		reagents.add_reagent("badgrease", 5)
		return

	heal(var/mob/M)
		..()
		boutput(M, "It tastes disappointing.")
		return

//Candy bar variants
/obj/item/reagent_containers/food/snacks/candy/negativeonebar
	name = "-1 Bar"
	desc = "A candy bar containing '-1 calories.'"
	amount = 1
	heal_amt = -1
	icon_state = "candy-blue"
	sugar_content = 10

/obj/item/reagent_containers/food/snacks/candy/chocolate
	name = "chocolate bar"
	desc = "A plain chocolate bar. Is it dark chocolate, milk chocolate? Who knows!"
	sugar_content = 10
	real_name = "chocolate"
	icon_state = "candy-chocolate"
	food_color = "#663300"

	New()
		..()
		reagents.add_reagent("chocolate", 10)
		return

/obj/item/reagent_containers/food/snacks/candy/wrapped_pbcup
	name = "pack of Hetz's Cups"
	desc = "A package of the popular Hetz's Cups chocolate peanut butter cups."
	icon_state = "candy-pbcup_w"
	sugar_content = 20
	heal_amt = 5
	food_color = "#663300"
	real_name = "Hetz's Cup"

	attack(mob/M as mob, mob/user as mob, def_zone)
		if (user == M)
			boutput(user, "<span style=\"color:red\">You need to unwrap them first, you greedy beast!</span>")
			user.visible_message("<b>[user]</b> stares at [src] in a confused manner.")
			return
		else
			user.visible_message("<span style=\"color:red\"><b>[user]</b> futilely attempts to shove [src] into [M]'s mouth!</span>")
			return

	attack_self(mob/user as mob)
		user.visible_message("[user] unwraps the Hetz's Cups!", "You unwrap the Hetz's Cups.")
		var/turf/T = get_turf(user)
		for(var/i = 0, i < 3, i++)
			new /obj/item/reagent_containers/food/snacks/candy/pbcup(T)
		qdel(src)

/obj/item/reagent_containers/food/snacks/candy/pbcup
	name = "Hetz's Cup"
	desc = "A cup-shaped chocolate candy with a peanut butter filling. Of course, peanuts went extinct back in 2026, so it's really some weird soy paste that supposedly tastes like them."
	icon_state = "candy-pbcup"
	sugar_content = 20
	heal_amt = 5
	amount = 2
	food_color = "#663300"
	real_name = "Hetz's Cup"

	New()
		..()
		reagents.add_reagent("chocolate", 10)
		return

/obj/item/reagent_containers/food/snacks/ectoplasm
	name = "ectoplasm"
	desc = "A luminescent blob of what scientists refer to as \"ghost goo.\""
	icon = 'icons/misc/halloween.dmi'
	icon_state = "ectoplasm"
	real_name = "ectoplasm"
	heal_amt = 0
	amount = 2
	food_color = "#B3E197"
	initial_volume = 15

	New()
		..()
		reagents.add_reagent("ectoplasm", 10)
		return

	heal(var/mob/M)
		..()
		var/ughmessage = pick("Your mouth feels haunted. Haunted with bad flavors.","It tastes like flavor died.", "It tastes like a ghost fart.", "It has the texture of ham aspic.  From the 1950s.  Left out in the sun.")
		boutput(M, "<span style=\"color:red\">Ugh, why did you eat that? [ughmessage]</span>")
		return

/obj/item/reagent_containers/food/snacks/corndog
	name = "corndog"
	desc = "A hotdog inside a fried cornmeal shell.  On a stick."
	icon_state = "corndog"
	amount = 3
	heal_amt = 4
	initial_volume = 30

	banana
		name = "banana-corndog"
		desc = "A hotdog inside a fried banana bread shell.  Is that even possible?"
		icon_state = "corndogb"
		heal_amt = 20

	brain
		name = "brain-corndog"
		desc = "A hotdog inside a fried shell of...what."
		icon_state = "corndogbr"
		heal_amt = 5

	elvis
		name = "hounddog-on-a-stick"
		desc = "It ain't never caught a rabbit and it ain't no friend of mine."
		icon_state = "elviscorndog"
		heal_amt = 10
		initial_volume = 30

		New()
			..()
			reagents.add_reagent("essenceofelvis",25)

	spooky
		name = "corndog of the damned"
		desc = "A very haunted hotdog in a very haunted shell. Probably the most haunted hotdog ever, honestly."
		icon_state = "hauntedcorndog"
		heal_amt = 5


	New()
		..()
		reagents.add_reagent("porktonium", 10)
		src.update_icon()

	on_reagent_change()
		src.update_icon()

	proc/update_icon()
		src.overlays.len = 0
		if (src.reagents.has_reagent("juice_tomato"))
			src.overlays += image(src.icon, "corndog-k")
			//to-do: mustard
		return

/obj/item/reagent_containers/food/snacks/hotdog
	name = "hotdog"
	desc = "A plain hotdog."
	icon_state = "hotdog"
	amount = 3
	heal_amt = 2
	var/bun = 0
	var/herb = 0
	initial_volume = 30

	New()
		..()
		reagents.add_reagent("porktonium", 10)
		src.update_icon()

	on_reagent_change()
		src.update_icon()

	heal(var/mob/M)
		if (src.bun == 4) M.bioHolder.AddEffect("accent_elvis", timeleft = 180)
		..()

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/reagent_containers/food/snacks/breadslice))
			if(src.bun)
				boutput(user, "<span style=\"color:red\">It already has a bun!</span>")
				return

			if(istype(W, /obj/item/reagent_containers/food/snacks/breadslice/banana))
				src.bun = 2
				src.desc = "A hotdog...in a banana bread bun.  What."
				src.heal_amt += 8
				src.name = "bananadog"
				if(src.herb)
					src.name = "herbal " + src.name
			else if (istype(W, /obj/item/reagent_containers/food/snacks/breadslice/brain))
				src.bun = 3
				src.desc = "A hotdog in some manner of meat-bread bun."
				src.heal_amt += 2
				src.name = "braindog"
				if(src.herb)
					src.name = "herbal " + src.name
			else if (istype(W, /obj/item/reagent_containers/food/snacks/breadslice/elvis))
				src.bun = 4
				src.desc = "It ain't never caught a rabbit and it ain't no friend of mine."
				src.heal_amt += 4
				src.name = "hounddog"
				if(src.herb)
					src.name = "herbal " + src.name
			else if (istype(W, /obj/item/reagent_containers/food/snacks/breadslice/spooky))
				src.bun = 5
				src.desc = "A very haunted hotdog. A hauntdog, perhaps."
				src.heal_amt += 1
				src.name = "frankenstein's beef frank"
				if (src.reagents)
					src.reagents.add_reagent("ectoplasm", 10)
				if(src.herb)
					src.name = "herbal " + src.name
			else
				src.bun = 1
				src.desc = "A hotdog! A staple of both sporting events and space stations."

			qdel(W)
			user.visible_message("[user] adds a bun to [src].","You add a bun to [src].")
			src.update_icon()

		else if (istype(W,/obj/item/rods))
			if(!src.bun)
				boutput(user, "<span style=\"color:red\">You need to bread it first!</span>")
				return

			boutput(user, "<span style=\"color:blue\">You create a corndog...</span>")
			var/obj/item/reagent_containers/food/snacks/corndog/newdog = null
			switch(src.bun)
				if(2)
					newdog = new /obj/item/reagent_containers/food/snacks/corndog/banana(get_turf(src))
				if(3)
					newdog = new /obj/item/reagent_containers/food/snacks/corndog/brain(get_turf(src))
				if (4)
					newdog = new /obj/item/reagent_containers/food/snacks/corndog/elvis(get_turf(src))
				if (5)
					newdog = new /obj/item/reagent_containers/food/snacks/corndog/spooky(get_turf(src))
				else
					newdog = new /obj/item/reagent_containers/food/snacks/corndog(get_turf(src))
			W:amount--
			if(!W:amount) qdel(W)

			if(newdog.reagents)
				src.reagents.trans_to(newdog, 100)

			if(src.herb)
				newdog.name = dd_replacetext(newdog.name, "corn","herb")
				newdog.desc = dd_replacetext(newdog.desc, "hotdog","sausage")

			qdel(src)

		else if (istype(W,/obj/item/plant/herb) && !src.herb)
			if(src.bun)
				boutput(user, "<span style=\"color:red\">It's too late! This hotdog is already in a bun, you see.</span>")
				return

			boutput(user, "<span style=\"color:blue\">You create a herbal sausage...</span>")
			src.herb = 1
			src.icon_state = "sausage"
			src.name = "herbal sausage"
			desc = "A fancy herbal sausage! Spices really make the sausage."
			W.reagents.trans_to(src,W.reagents.total_volume)
			qdel(W)

		else
			..()
		return

	proc/update_icon()
		src.overlays.len = 0
		switch(src.bun)
			if(1)
				src.overlays += image(src.icon, "hotdog-bun")
			if(2)
				src.overlays += image(src.icon, "hotdog-bunb")
			if(3)
				src.overlays += image(src.icon, "hotdog-bunbr")
			if(4)
				src.overlays += image(src.icon, "elvisdog")
			if(5)
				src.icon_state = "hauntdog"
		if (src.reagents.has_reagent("juice_tomato"))
			src.overlays += image(src.icon, "hotdog-k")
			//to-do: mustard
		return


/obj/item/reagent_containers/food/snacks/hotdog/syndicate
	var/mob/living/carbon/wall/meatcube/victim = null

	disposing()
		if((victim)&&(victim.client))
			victim.ghostize()
		..()

/obj/item/reagent_containers/food/snacks/taco
	name = "empty taco shell"
	desc = "A lone taco shell, devoid of any filling."
	icon = 'icons/obj/foodNdrink/food_meals.dmi'
	amount = 3
	heal_amt = 1
	icon_state = "taco0"
	var/stage = 0
	var/salsa = 0
	food_color = "#FFFF33"
	initial_volume = 100

	heal(var/mob/M)
		if(!src.salsa)
			boutput(M, "<span style=\"color:red\">Could use sauce...</span>")
		..()
		return

	attack_self(mob/user as mob)
		if (!src.stage)
			boutput(user, "You crunch up the tortilla shell into tortilla chips.")
			new /obj/item/reagent_containers/food/snacks/tortilla_chip_spawner(user.loc)
			user.u_equip(src)
			qdel(src)
		else
			..()

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/reagent_containers/food/snacks/ingredient/meat))
			if(src.stage)
				boutput(user, "<span style=\"color:red\">It can't hold any more!</span>")
				return
			src.stage++
			src.icon_state = "taco1"
			src.name = "[W.name] taco"
			src.heal_amt++
			desc = "A meat taco. Pretty plain, really."
			boutput(user, "<span style=\"color:blue\">You add [W] to [src]!</span>")
			qdel (W)

		else if(istype(W,/obj/item/reagent_containers/food/snacks/condiment/hotsauce) || istype(W,/obj/item/reagent_containers/food/snacks/condiment/coldsauce))
			boutput(user, "<span style=\"color:blue\">You add [W] to [src]!</span>")
			if(!src.salsa)
				src.heal_amt++
				src.salsa = 1

			return

		else if (istype(W, /obj/item/reagent_containers/food/snacks/ingredient/cheese))
			switch(src.stage)
				if(0)
					boutput(user, "<span style=\"color:red\">You really should add the meat first.</span>")
				if(1)
					boutput(user, "<span style=\"color:blue\">You add [W] to [src]!</span>")
					qdel (W)
					src.stage++
					src.heal_amt++
					src.icon_state = "taco2"
					src.desc = "A complete taco.  Looks pretty good."
				if(2)
					boutput(user, "<span style=\"color:red\">It can't hold any more!</span>")
			return
		return

/obj/item/reagent_containers/food/snacks/steak_h
	name = "steak"
	desc = "Made of people."
	icon_state = "steak"
	amount = 2
	heal_amt = 3
	var/hname = null
	var/job = null
	food_color = "#999966"
	initial_volume = 50

	New()
		..()
		reagents.add_reagent("cholesterol",3)

/obj/item/reagent_containers/food/snacks/steak_m
	name = "monkey steak"
	desc = "You'll go bananas for it."
	icon_state = "steak"
	amount = 2
	heal_amt = 3
	food_color = "#999966"
	initial_volume = 50

	New()
		..()
		reagents.add_reagent("cholesterol",3)

/obj/item/reagent_containers/food/snacks/steak_s
	name = "synth-steak"
	desc = "And they thought processed food was artificial..."
	icon_state = "steak"
	amount = 2
	heal_amt = 3
	food_color = "#999966"
	initial_volume = 50

	New()
		..()
		reagents.add_reagent("cholesterol",2)

/obj/item/reagent_containers/food/snacks/fish_fingers
	name = "fish fingers"
	desc = "What kind of fish did it start out as? Who knows!"
	icon_state = "fish_fingers"
	amount = 3
	heal_amt = 2
	food_color = "#FFCC33"

/obj/item/reagent_containers/food/snacks/bakedpotato
	name = "baked potato"
	desc = "Would go good with some cheese or steak."
	icon_state = "bakedpotato"
	amount = 6
	heal_amt = 1
	food_color = "#FFFF99"

/obj/item/reagent_containers/food/snacks/omelette
	name = "omelette"
	desc = "A delicious breakfast food."
	icon_state = "omelette"
	amount = 3
	heal_amt = 4
	needfork = 1
	food_color = "#FFCC00"
	initial_volume = 10

	New()
		..()
		reagents.add_reagent("cholesterol",1)

/obj/item/reagent_containers/food/snacks/omelette/bee
	name = "deep-space hell omelette"
	desc = "<tt>BEE EGGS</tt> make this a delightful breakfast food."

/obj/item/reagent_containers/food/snacks/pancake
	name = "pancakes"
	desc = "They seem to be lacking something"
	icon_state = "pancake"
	amount = 3
	heal_amt = 1
	var/syrup = 0
	food_color = "#FFFF99"

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/reagent_containers/food/snacks/condiment/syrup))
			boutput(user, "<span style=\"color:blue\">You add [W] to [src].</span>")
			icon_state = "pancake_s"
			syrup = 1
			heal_amt = 5
			desc = "They look delicious!"
			user.u_equip(W)
			qdel (W)

	heal(var/mob/M)
		..()
		if(!syrup)
			boutput(M, "<span style=\"color:red\">[src] seem a bit dry.</span>")


/obj/item/reagent_containers/food/snacks/mashedpotatoes
	name ="mashed potatoes"
	desc = "A classic dish."
	icon_state = "mashedpotatoes"
	amount = 5
	heal_amt = 1
	needfork = 1
	food_color = "#FFFFFF"
	initial_volume = 50

	New()
		..()
		reagents.add_reagent("mashedpotatoes", 25)

/obj/item/reagent_containers/food/snacks/mashedbrains
	name = "mashed brains"
	desc = "Rumored to be a good brain food"
	icon_state = "mashedbrains"
	amount = 5
	heal_amt = 1
	needfork = 1
	food_color = "#FF6699"

	heal(var/mob/M as mob)
		..()
		if(quality >= 1)
			if(istype(M, /mob/living/carbon/human/))
				var/mob/living/carbon/human/H = M
				if(prob(1))
					boutput(M, "<span style=\"color:red\">You feel dumber.</span>")
					H:bioHolder:RandomEffect("bad")
				else if(prob(1))
					boutput(M, "<span style=\"color:blue\">You feel smarter.</span>")
					H:bioHolder:RandomEffect("good")

/obj/item/reagent_containers/food/snacks/meatloaf
	name = "meatloaf"
	desc = "A loaf of meat"
	icon_state = "meatloaf"
	amount = 5
	heal_amt = 1
	needfork = 1
	initial_volume = 50

	New()
		..()
		reagents.add_reagent("cholesterol",2)

/obj/item/reagent_containers/food/snacks/tortilla_chip_spawner
	name = "INVISIBLE GHOST OF PANCHO VILLA'S BAKER BROTHER, GARY VILLA"
	desc = "IGNORE ME"

	New()
		..()
		spawn(5)
			if (isturf(src.loc))
				for (var/x = 1, x <= 4, x++)
					new /obj/item/reagent_containers/food/snacks/tortilla_chip(src.loc)

			qdel(src)

/obj/item/reagent_containers/food/snacks/tortilla_chip
	name = "tortilla chip"
	desc = "A crispy little tortilla disk."
	icon = 'icons/obj/foodNdrink/food_snacks.dmi'
	icon_state = "tortilla_chip"
	amount = 1
	heal_amt = 1

	New()
		..()
		src.pixel_x = rand(-6, 6)
		src.pixel_y = rand(-6, 6)

	on_reagent_change()
		if (src.reagents && src.reagents.total_volume)
			src.overlays = null
			for(var/current_id in reagents.reagent_list)
				var/datum/reagent/current_reagent = reagents.reagent_list[current_id]
				var/icon/I = icon('icons/obj/foodNdrink/food_snacks.dmi', "tortilla_chip_overlay")
				I.Blend(rgb(current_reagent.fluid_r, current_reagent.fluid_g, current_reagent.fluid_b,current_reagent.transparency), ICON_ADD)
				src.overlays += image("icon" = I, "layer" = FLOAT_LAYER)
		return

/obj/item/reagent_containers/food/snacks/wonton_spawner
	name = "wonton spawner"
	desc = "You shouldn't see this."

	New()
		..()
		spawn(5)
			if (isturf(src.loc))
				for (var/x = 1, x <= 4, x++)
					new /obj/item/reagent_containers/food/snacks/wonton_wrapper(src.loc)

			qdel(src)

/obj/item/reagent_containers/food/snacks/wonton_wrapper
	name = "wonton wrapper"
	desc = "An egg dough wrapper typically employed in the creation of dumplings."
	icon_state = "wrapper"
	amount = 1
	heal_amt = 1
	var/obj/item/wrapped = null
	var/maximum_wrapped_size = 2

	attackby(obj/item/W as obj, mob/user as mob)
		if (wrapped)
			if (istype(W, /obj/item/axe) || istype(W, /obj/item/circular_saw) || istype(W, /obj/item/kitchen/utensil/knife) || istype(W, /obj/item/scalpel) || istype(W, /obj/item/sword) || istype(W,/obj/item/saw) || istype(W,/obj/item/knife_butcher))
				user.visible_message("<span style=\"color:red\">[user] performs an act of wonton destruction!</span>","You slice open the wrapper.")
				wrapped.set_loc(get_turf(src))
				src.reagents = null
				qdel(src)
			else
				boutput(user, "<span style=\"color:red\">That wrapper is already full!</span>")
			return
		else
			if (istype(W, /obj/item/reagent_containers/food/snacks/wonton_wrapper))
				boutput(user, "<span style=\"color:red\">A wrapped wrapper? That's ridiculous.</span>")
				return

			if (W.w_class > src.maximum_wrapped_size || istype(W, /obj/item/storage) || istype(W, /obj/item/storage/secure))
				boutput(user, "<span style=\"color:red\">There is no way that could fit!</span>")
				return

			boutput(user, "You wrap \the [W] into a dumpling.")
			user.u_equip(W)
			W.set_loc(src)
			src.wrapped = W
			W.dropped()

			if (W.w_class > (src.maximum_wrapped_size / 2))
				src.name = "[W.name] eggroll"
				src.desc = "A rolled appetizer with a wonton wrapper skin. It really should be fried before you eat it."
				icon_state = "eggroll"
			else
				src.name = "[W.name] rangoon"
				src.desc = "A dumpling made from a wonton wrapper wrapped in a flower configuration. It really should be fried before you eat it."
				icon_state = "rangoon"

			src.reagents = W.reagents
			return

	New()
		..()
		src.pixel_x = rand(-6, 6)
		src.pixel_y = rand(-6, 6)

	heal(var/mob/M)
		boutput(M, "<span style=\"color:red\">Ugh, you really should've cooked that first.</span>")
		if(prob(25))
			M.reagents.add_reagent("salmonella",15)
		..()

/obj/item/reagent_containers/food/snacks/agar_block
	name = "Agar Block"
	desc = "A gel derived from algae with multiple culinary and scientific uses.  Ingestion of plain agar is not advised."
	icon_state = "agar"
	amount = 1
	heal_amt = 0
	food_color = "#9D3811"

/obj/item/reagent_containers/food/snacks/granola_bar
	name = "granola bar"
	desc = "A crisp bar of oats bonded together by honey.  A big indicator of either space hikers or space hippies."
	icon = 'icons/obj/foodNdrink/food_snacks.dmi'
	icon_state = "granola_bar"
	amount = 2
	heal_amt = 2
	food_color = "#6A532D"

// boy i wish byond had static members doop doop
var/list/valid_jellybean_reagents = (typesof(/datum/reagent) - /datum/reagent)

//#ifdef HALLOWEEN
/obj/item/reagent_containers/food/snacks/candy/everyflavor
	name = "A Farty Snott's Every Flavour Bean"
	desc = "A favorite halloween sweet worldwide!"
	icon_state = "bean"
	amount = 1
	initial_volume = 100

	New()
		..()

		if(prob(75))
			var/flavor = null
			if (all_functional_reagent_ids.len > 0)
				flavor = pick(all_functional_reagent_ids)
			else
				flavor = "sugar"

			src.reagents.add_reagent(flavor, 50)

		else
			src.reagents.add_reagent("sugar", 40)
			src.heal_amt = 1
			if(prob(10))
				src.reagents.add_reagent("milk", 10)
			else if(prob(10))
				src.reagents.add_reagent("coffee", 10)
			else if(prob(10))
				src.reagents.add_reagent("VHFCS", 10)
			else if(prob(10))
				src.reagents.add_reagent("bilk", 10)
				src.heal_amt = 0
			else if(prob(10))
				src.reagents.add_reagent("gravy", 10)
			else if(prob(10))
				src.reagents.add_reagent("beff", 10)
				src.heal_amt = 0
			else if(prob(10))
				src.reagents.add_reagent("vomit", 10)
				src.heal_amt = 0
			else if(prob(10))
				src.reagents.add_reagent("gvomit", 10)
				src.heal_amt = 0
			else if(prob(10))
				src.reagents.add_reagent("fakecheese", 10)
			else if(prob(10))
				src.reagents.add_reagent("gravy", 10)
			else if(prob(10))
				src.reagents.add_reagent("porktonium", 10)
				src.heal_amt = 0
			else if(prob(10))
				src.reagents.add_reagent("badgrease", 10)
				src.heal_amt = 0
		src.icon += src.reagents.get_master_color()
		src.food_color = src.reagents.get_master_color()

	heal(var/mob/M)
		var/flavor
		var/phrase
		var/color

		if(prob(50))
			flavor = pick("egg", "vomit", "snot", "poo", "urine", "earwax", "wet dog", "belly-button lint", "sweat", "congealed farts", "mold", "armpits", "elbow grease", "sour milk", "WD-40", "slime", "blob", "gym sock", "pants", "brussels sprouts", "feet", "litter box", "durian fruit", "asbestos", "corpse flower", "corpse", "cow dung", "rot", "tar", "ham")
			phrase = pick("Oh god", "Jeez", "Ugh", "Blecch", "Holy crap that's awful", "What the hell?", "*HURP*", "Phoo")
			color = "<span style=\"color:red\">"
		else
			flavor = pick("egg", "strawberry", "raspberry", "snozzberry", "happiness", "popcorn", "buttered popcorn", "cinnamon", "macaroni and cheese", "pepperoni", "cheese", "lasagna", "pina colada", "tutti frutti", "lemon", "margarita", "coconut", "pineapple", "scotch", "vodka", "root beer", "cotton candy", "Lagavulin 18", "toffee", "vanilla", "coffee", "apple pie", "neapolitan", "orange", "lime", "crotch", "mango", "apple", "grape", "Slurm")
			phrase = pick("Yum", "Wow", "MMM", "Delicious", "Scrumptious", "Fantastic", "Oh yeah")
			color = "<span style=\"color:blue\">"

		boutput(M, "[color][phrase]! That tasted like [flavor]...</span>")


/obj/item/kitchen/everyflavor_box
	amount = 6
	icon = 'icons/obj/foodNdrink/food_snacks.dmi'
	icon_state = "beans"
	name = "bag of Farty Snott's Every Flavour Beans"

/obj/item/kitchen/everyflavor_box/attack_hand(mob/user as mob, unused, flag)
	if (flag)
		return ..()
	if(user.r_hand == src || user.l_hand == src)
		if(src.amount == 0)
			boutput(user, "<span style=\"color:red\">You're out of beans. You feel strangely sad.</span>")
			return
		else
			var/obj/item/reagent_containers/food/snacks/candy/everyflavor/B = new(user)
			user.put_in_hand_or_drop(B)
			src.amount--
			if(src.amount == 0)
				src.icon_state = "beans_empty"
				src.name = "empty Farty Snott's bag"
	else
		return ..()
	return

/obj/item/kitchen/everyflavor_box/examine()
	set src in oview(1)
	set category = "Local"

	src.amount = round(src.amount)
	var/n = src.amount
	for(var/obj/item/reagent_containers/food/snacks/donut/P in src)
		n++
	if (n <= 0)
		n = 0
		boutput(usr, "There are no beans left in the bag.")
	else
		if (n == 1)
			boutput(usr, "There is one bean left in the bag.")
		else
			boutput(usr, "There are [n] beans in the bag.")
	return

//#endif

/obj/item/reagent_containers/food/snacks/lollipop
	name = "lollipop"
	desc = "How many licks does it take to get to the center? No one knows, they just bite the things."
	icon = 'icons/obj/foodNdrink/food_snacks.dmi'
	icon_state = "lpop-r"
	heal_amt = 1
	amount = 5
	real_name = "lollipop"
	var/list/flavors = list("omnizine", "saline", "salicylic_acid", "epinephrine", "mannitol", "synaptizine", "anti_rad", "oculine", "ephedrine", "salbutamol", "charcoal")

	New()
		..()
		src.icon_state = "lpop-[rand(1,6)]"
		if (src.reagents && islist(src.flavors) && src.flavors.len)
			for (var/i=5, i>0, i--)
				reagents.add_reagent(pick(src.flavors), 1)
		return
