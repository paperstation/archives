/obj/machinery/sink
	name = "sink"
	icon = 'device.dmi'
	icon_state = "sink"
	desc = "A sink used for washing one's hands and face."
	anchored = 1


	attack_hand(mob/M as mob)
		M.clean_blood()
		if(istype(M, /mob/living/carbon))
			var/mob/living/carbon/C = M
			C.clean_blood()
			if(C.r_hand)
				C.r_hand.clean_blood()
			if(C.l_hand)
				C.l_hand.clean_blood()
/*			if(C.wear_mask)
				C.wear_mask.clean_blood()*/
			if(istype(M, /mob/living/carbon/human))
				if(M:pickeduppoo)
					M:pickeduppoo = 0
/*				if(C:w_uniform)
					C:w_uniform.clean_blood()
				if(C:wear_suit)
					C:wear_suit.clean_blood()
				if(C:shoes)
					C:shoes.clean_blood()*/
				if(C:gloves)
					C:gloves.clean_blood()
					C:gloves.clean_poo()
/*				if(C:head)
					C:head.clean_blood()*/
		for(var/mob/V in viewers(src, null))
			V.show_message(text("\blue [M] washes up using \the [src]."))
			playsound(src, 'wash.ogg', 30, 1)


	attackby(var/obj/item/O as obj, var/mob/user as mob)
		O.clean_blood()
		if (istype(O, /obj/item/weapon/melee/baton))
			var/obj/item/weapon/melee/baton/B = O
			if (B.charges > 0 && B.status == 1)
				flick("baton_active", src)
				user.stunned = 35
				user.stuttering = 35
				user.weakened = 50
				if(isrobot(user))
					var/mob/living/silicon/robot/R = user
					R.cell.charge -= 20
				else
					B.charges--
				user.visible_message("[user] was stunned by their wet [O]!")
				return
		else if (istype(O, /obj/item/weapon/reagent_containers/food/snacks/flour))
			del(O)
			new /obj/item/weapon/reagent_containers/food/snacks/doughball(src.loc)
			user << "\blue You mix some water into the flour, making a blob of simple dough."
			return
		else if(istype(O, /obj/item/weapon/reagent_containers/glass)) //Dump contents into the sink, but fill it up with water if it's empty
			var/obj/item/weapon/reagent_containers/glass/G = O
			if(G.reagents.total_volume)
				user << "\blue You empty [G] into the sink."
				G.reagents.clear_reagents()
			else
				user << "\blue You add some water from the sink to [G]."
				G.reagents.add_reagent("water", 10)
				if(hascall(G, on_reagent_change()))
					G.on_reagent_change()
				return
		else if(istype(O, /obj/item/weapon/reagent_containers/food/drinks)) //Dump contents into the sink, but fill it up with water if it's empty
			var/obj/item/weapon/reagent_containers/food/drinks/D = O
			if(D.reagents.total_volume)
				user << "\blue You empty [D] into the sink."
				D.reagents.clear_reagents()
			else
				user << "\blue You add some water from the sink to [D]."
				D.reagents.add_reagent("water", 10)
				if(hascall(D, on_reagent_change()))
					D:on_reagent_change()
				return
		else
			user.visible_message("\blue [user] washes \a [O] using \the [src].")
			playsound(src, 'wash.ogg', 30, 1)

	shower
		name = "Shower"
		desc = "Plenty of hot water, powered by radiation! Nothing harmful could come from that, right?"

	kitchen
		name = "Kitchen Sink"
		icon_state = "sink_alt"

	kitchen2
		name = "Kitchen Sink"
		icon_state = "sink_alt2"

	sink_l
		name = "sink"
		icon = 'kitchen.dmi'
		icon_state = "sink_l"

	sink_r
		name = "sink"
		icon = 'kitchen.dmi'
		icon_state = "sink_r"