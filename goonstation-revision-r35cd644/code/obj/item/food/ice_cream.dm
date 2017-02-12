
/obj/item/reagent_containers/food/snacks/ice_cream_cone
	name = "ice cream cone"
	desc = "A cone designed in 1937 by members of FDR's brain trust.  Its purpose? To hold as much ice cream as possible."
	icon = 'icons/obj/foodNdrink/food_snacks.dmi'
	icon_state = "icecream"
	amount = 1

/obj/item/reagent_containers/food/snacks/ice_cream
	name = "ice cream"
	desc = "You scream, I scream, we all scream, but nobody hears it.  This is space."
	icon = 'icons/obj/foodNdrink/food_snacks.dmi'
	icon_state = "icecream"
	amount = 4
	heal_amt = 4
	food_color = null
	initial_volume = 40

	New()
		..()
		spawn(12)
			var/icecream_name = src.reagents.get_master_reagent_name()
			src.food_color = src.reagents.get_master_color()
			if(icecream_name)
				src.name ="[icecream_name]-flavored ice cream"
			src.update_cone()
		return

	heal(var/mob/M)
		..()
		src.update_cone()
		M.bodytemperature = min(M.base_body_temp, M.bodytemperature-20)
		return

	suicide(var/mob/user as mob)
		var/icecount = 0
		if(istype(user.l_hand,/obj/item/reagent_containers/food/snacks/ice_cream) && user.l_hand.amount)
			var/obj/item/reagent_containers/food/snacks/ice_cream/I = user.l_hand
			icecount += I.amount
			I.amount = 1
			I.update_cone()
		if(istype(user.r_hand,/obj/item/reagent_containers/food/snacks/ice_cream) && user.r_hand.amount)
			var/obj/item/reagent_containers/food/snacks/ice_cream/I = user.r_hand
			icecount += I.amount
			I.amount = 1
			I.update_cone()
		if(!icecount) return
		user.visible_message("<span style=\"color:red\"><b>[user] eats the ice cream in one bite and collapses from brainfreeze.</b></span>")
		user.TakeDamage("head", 0, 50 * icecount)
		user.paralysis += icecount //in case the damage isn't enough to crit
		user.bodytemperature -= 100
		user.updatehealth()
		spawn(100)
			if (user)
				user.suiciding = 0
		return 1

	proc/update_cone()
		src.overlays.len = 0
		var/cream_level = (100 * round(amount/initial(amount),0.25))

		if(!food_color)
			food_color = src.reagents.get_master_color()
		var/icon/I = new /icon('icons/obj/foodNdrink/food_snacks.dmi',"ice[cream_level]")
		I.Blend(food_color, ICON_ADD)

		src.overlays += I
		return


/obj/item/reagent_containers/food/snacks/ice_cream/gross
	New()
		..()
		src.reagents.add_reagent("vomit", 40)

/obj/item/reagent_containers/food/snacks/ice_cream/random
	New()
		..()
		spawn (10)
			var/flavor = null
			if (all_functional_reagent_ids.len > 1)
				flavor = pick(all_functional_reagent_ids)
			else
				flavor = "vanilla"

			src.reagents.add_reagent(flavor, 40)

/obj/item/reagent_containers/food/snacks/ice_cream/goodrandom
	New()
		..()
		var/randreag = pick("coffee","chocolate","vanilla")
		src.reagents.add_reagent(randreag, 40)

/obj/item/reagent_containers/food/snacks/yoghurt
	name = "yoghurt"
	desc = "A plain yoghurt."
	icon = 'icons/obj/foodNdrink/food_snacks.dmi'
	icon_state = "yoghurt"
	needspoon = 1
	amount = 6
	heal_amt = 1

/obj/item/reagent_containers/food/snacks/yoghurt/frozen
	name = "frozen yoghurt"
	desc = "A delightful tub of frozen yoghurt."
	heal_amt = 2
	initial_volume = 30

	New()
		..()
		reagents.add_reagent("cryostylane", 20)
