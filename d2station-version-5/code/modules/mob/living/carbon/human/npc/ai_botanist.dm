/mob/living/carbon/human/proc/ai_botany()

	for (var/obj/machinery/hydroponics/H in view(7,src))
		if(H.waterlevel <= 20)
			ai_pickupbucket()
			if(!ai_validpath() && get_dist(src,H) <= 1)
				dir = get_step_towards(src,H)
				ai_obstacle() //Remove.
				if((get_dist(src,H) <= 1) && (istype(src.r_hand, /obj/item/weapon/reagent_containers/glass/bucket)))
					if(r_hand.reagents.total_volume)
						H.attackby(r_hand, src)
			else
				step_towards(src,H)
			drop_item()

/mob/living/carbon/human/proc/ai_pick_up_bucket(var/obj/item/weapon/found_bucket/B as obj)

	if(src.r_hand != found_bucket)
		drop_item()

	if(found_bucket && !src.r_hand)
		found_bucket.loc = src
		src.r_hand = found_bucket

/mob/living/carbon/human/proc/ai_find_a_bucket()

	var/obj/item/weapon/target_bucket

	if(istype(r_hand, /obj/item/weapon/reagent_containers/glass/bucket))
		target_bucket = r_hand

	if(!target_bucket)
		for (var/obj/item/weapon/reagent_containers/glass/bucket/G in view(10,src))
			if(!istype(G.loc, /turf) || G.anchored) continue
			if(!src.r_hand && target_bucket)
				target_bucket = G

		if(src.r_hand && pickup)
			src.r_hand:loc = get_turf(src)
			src.r_hand = null

		if(pickup && !src.r_hand)
			pickup.loc = src
			src.r_hand = pickup

/mob/living/carbon/human/proc/ai_fill_bucket(var/obj/item/weapon/current_bucket)

	var/obj/item/weapon/pickup

	if(src.r_hand && pickup)
		drop_item()

	if(pickup && !src.r_hand)
		pickup.loc = src
		src.r_hand = pickup

	pickup.reagents.clear_reagents()
	pickup.reagents.add_reagent("water", 50)