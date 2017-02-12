
/obj/item/reagent_containers/food/snacks/yellow_cake_uranium_cake
	name = "yellow cake"
	desc = "A decent yellow cake that seems to be glowing a bit. Is this safe?"
	icon = 'icons/obj/foodNdrink/food_dessert.dmi'
	icon_state = "yellowcake"
	w_class = 1
	amount = 1
	heal_amt = 2
	initial_volume = 5

	New()
		..()
		src.reagents.add_reagent("uranium", 5)

/obj/item/reagent_containers/food/snacks/cake/
	name = "sponge cake"
	desc = "A plain sponge cake. Could be better, could be worse."
	icon = 'icons/obj/foodNdrink/food_dessert.dmi'
	icon_state = "cake_batter"
	amount = 12
	heal_amt = 2
	custom_food = 0
	w_class = 3

/obj/item/reagent_containers/food/snacks/cake/custom
	name = "cake"
	desc = "a cake"
	icon_state = "cake"
	amount = 10
	heal_amt = 2
	var/icing = 0
	var/sliced = 0
	var/icing_color =  "#FFFFFF"
	flags = FPRINT | TABLEPASS | NOSPLASH
	initial_volume = 100

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/axe) || istype(W, /obj/item/circular_saw) || istype(W, /obj/item/kitchen/utensil/knife) || istype(W, /obj/item/scalpel) || istype(W, /obj/item/sword) || istype(W,/obj/item/saw) || istype(W,/obj/item/knife_butcher))
			if (src.sliced == 1)
				boutput(user, "<span style=\"color:red\">This has already been sliced.</span>")
				return
			if (!icing)
				boutput(user, "<span style=\"color:red\">You need to add icing first!</span>")
				return
			boutput(user, "<span style=\"color:blue\">You cut the cake into slices.</span>")
			var/makeslices = src.amount
			while (makeslices > 0)
				var/obj/item/reagent_containers/food/snacks/cake/custom/P = new src.type(get_turf(src))
				P.sliced = 1
				P.amount = 1
				P.w_class = 1
				P.icon_state = "cake_slice"
				P.quality = src.quality
				P.name = src.name
				P.desc = src.desc
				P.food_color = src.food_color
				P.update_icon(1)
				P.icing_color = src.icing_color
				P.update_icing(1)
				src.reagents.trans_to(P, src.reagents.total_volume/makeslices)
				P.pixel_x = rand(-6, 6)
				P.pixel_y = rand(-6, 6)
				makeslices--
			qdel (src)
		if(istype(W, /obj/item/reagent_containers/glass/bottle/icing) && !(icing) &&(!sliced) && (W.reagents.total_volume))
			if(W.reagents.total_volume == 50)
				boutput(user, "<span style=\"color:blue\">You add the icing to the cake.</span>")
				icing = 1
				src.desc += "<br>It has " + W.reagents.get_master_reagent_name() + " icing."
				icing_color = W.reagents.get_master_color()
				src.update_icing(0)
				W.reagents.trans_to(src, W.reagents.total_volume)
			else
				boutput(user, "<span style=\"color:red\">The icing tube must be full!</span>")
		else
			..()

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

	//Update the base cake icon
	proc/update_icon(var/num)
		if(num== 0)
			var/icon/I = new /icon('icons/obj/foodNdrink/food_dessert.dmi',"cake")
			I.Blend(food_color, ICON_ADD)
			src.icon = I
		else
			var/icon/I = new /icon('icons/obj/foodNdrink/food_dessert.dmi',"cake_slice")
			I.Blend(food_color, ICON_ADD)
			src.icon = I

	//Update the icing sprite
	proc/update_icing(var/num)
		if(num == 0)
			var/icon/I = new /icon('icons/obj/foodNdrink/food_dessert.dmi', "cake_icing")
			I.Blend(icing_color, ICON_ADD)
			src.overlays += I
		else
			var/icon/I = new /icon('icons/obj/foodNdrink/food_dessert.dmi', "cake_slice_icing")
			I.Blend(icing_color, ICON_ADD)
			src.overlays += I

/obj/item/reagent_containers/food/snacks/cake/batter
	name = "cake batter"
	desc = "An uncooked bit of cake batter. Eating it like this won't be very nice."
	icon_state = "cake_batter"
	amount = 12
	heal_amt = 1
	var/obj/item/reagent_containers/custom_item
	initial_volume = 50

/obj/item/reagent_containers/food/snacks/cake/cream
	name = "cream sponge cake"
	desc = "Mmm! A delicious-looking cream sponge cake!"
	icon_state = "cake_cream"
	amount = 12
	heal_amt = 2
	initial_volume = 50

	New()
		..()
		reagents.add_reagent("sugar", 30)

/obj/item/reagent_containers/food/snacks/cake/chocolate
	name = "chocolate sponge cake"
	desc = "Mmm! A delicious-looking chocolate sponge cake!"
	icon_state = "cake_chocolate"
	amount = 12
	heal_amt = 3
	initial_volume = 50

	New()
		..()
		reagents.add_reagent("chocolate", 50)

/obj/item/reagent_containers/food/snacks/cake/meat
	name = "meat cake"
	desc = "Uh... well... wow. What is this?"
	var/hname = ""
	var/job = null
	icon_state = "cake_meat"
	amount = 12
	heal_amt = 3
	initial_volume = 50

	New()
		..()
		reagents.add_reagent("blood", 50)

/obj/item/reagent_containers/food/snacks/cake/bacon
	name = "bacon cake"
	desc = "This...this is just terrible."
	icon_state = "cake_bacon"
	amount = 12
	heal_amt = 4
	initial_volume = 250

	New()
		..()
		reagents.add_reagent("porktonium", 250)

	heal(var/mob/M)
		M.nutrition += 500
		return

/obj/item/reagent_containers/food/snacks/cake/downs
	name = "droopy cake"
	desc = "This cake looks all weird and droopy."
	icon_state = "cake_downs"
	amount = 12
	heal_amt = 4
	initial_volume = 250

	New()
		..()
		reagents.add_reagent("downbrosia", 250)

	heal(var/mob/M)
		M.nutrition += 500
		return

/obj/item/cake_item
	name = "cream sponge cake"
	desc = "Mmm! A delicious-looking cream sponge cake! There's a lump in it..."
	icon = 'icons/obj/foodNdrink/food_dessert.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_food.dmi'
	icon_state = "cake_cream"

/obj/item/cake_item/attack(target as mob, mob/user as mob)
	var/iteminside = src.contents.len
	if(!iteminside)
		boutput(user, "<span style=\"color:red\">The cake crumbles away!</span>")
		qdel(src)
	boutput(user, "<span style=\"color:blue\">You bite down on something odd! You open up the cake...</span>")
	for(var/obj/item/I in src.contents)
		I.set_loc(user.loc)
		I.add_fingerprint(user)
	qdel(src)
	return
