/*
Contains most of the procs that are called when a mob is attacked by something
ex_act
meteor_act
*/

/mob/living/carbon/human/get_resistance(var/weapon_type, var/zone)
	switch(zone)
		if("head")
			return check_armor(HEAD, weapon_type)
		if("arms")
			return check_armor(ARMS, weapon_type)
		if("chest")
			return check_armor(CHEST, weapon_type)
		if("legs")
			return check_armor(LEGS, weapon_type)

	//If you don't specify a bodypart, it checks ALL your bodyparts for protection, and averages out the values
	var/resistance = check_armor(HEAD, weapon_type)
	resistance += check_armor(ARMS, weapon_type)
	resistance += check_armor(CHEST, weapon_type)
	resistance += check_armor(LEGS, weapon_type)
	return (resistance/4)


/mob/living/carbon/human/proc/check_armor(var/bodypart, var/weapon_type)
	if(!bodypart || !weapon_type)	return 0
	var/resistance = 0
	//Only the head and suit have armor
	if(head && istype(head))
		if(head.body_parts_covered & bodypart)
			var/armor = head.armor[weapon_type]
			if(armor > resistance)
				resistance = armor

	if(wear_suit && istype(wear_suit))
		if(wear_suit.body_parts_covered & bodypart)
			var/armor = wear_suit.armor[weapon_type]
			if(armor > resistance)
				resistance = armor

	if(HULK in mutations)//Hulks now have DR
		resistance = 0.4//MED resistance
	return resistance



/mob/living/carbon/human/check_shields(var/damage = 0, var/attack_text = "the attack")
	if(l_hand && istype(l_hand, /obj/item/weapon))//Current base is the prob(50-d/3)
		var/obj/item/weapon/I = l_hand
		if(I.IsShield() && (prob(50 - round(damage / 3))))
			visible_message("\red <B>[src] blocks [attack_text] with the [l_hand.name]!</B>")
			return 1
	if(r_hand && istype(r_hand, /obj/item/weapon))
		var/obj/item/weapon/I = r_hand
		if(I.IsShield() && (prob(50 - round(damage / 3))))
			visible_message("\red <B>[src] blocks [attack_text] with the [r_hand.name]!</B>")
			return 1
	return 0



/mob/living/carbon/human/proc/attacked_by(var/obj/item/I, var/mob/living/user)
	if(!istype(I) || !user)
		return 0

	var/hit_zone = zone_scatter(user.zone_sel.selecting)
	var/hit_area = parse_zone(hit_zone)//Dono if this guy is actually needed now

	if((user != src) && check_shields(I.force, "the [I.name]"))
		return 0

	if(I.attack_verb.len)
		visible_message("\red <B>[src] has been [pick(I.attack_verb)] in the [hit_area] with [I.name] by [user]!</B>")
	else
		visible_message("\red <B>[src] has been attacked in the [hit_area] with [I.name] by [user]!</B>")

	var/amount = deal_damage(I.force, I.damtype, I.forcetype, hit_zone)//Returns how much damage was actually done

	var/bloody = 0
	if(I.damtype == BRUTE && prob(25 + (amount*2)))
		I.add_blood(src)	//Make the weapon bloody, not the person.
		if(prob(I.force*2))//Next see if we should splatter blood
			bloody = 1
			var/turf/location = loc
			if(istype(location, /turf/simulated))
				location.add_blood(src)
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				if(get_dist(H, src) <= 1) //people with TK won't get smeared with blood
					if(H.wear_suit)
						H.wear_suit.add_blood(src)
						H.update_inv_wear_suit(0)	//updates mob overlays to show the new blood (no refresh)
					else if(H.w_uniform)
						H.w_uniform.add_blood(src)
						H.update_inv_w_uniform(0)	//updates mob overlays to show the new blood (no refresh)
					if (H.gloves)
						H.gloves.add_blood(H)
						H.gloves:transfer_blood = 2
						H.gloves:bloody_hands_mob = H
					else
						H.add_blood(H)
						H.bloody_hands = 2
						H.bloody_hands_mob = H
					H.update_inv_gloves()		//updates on-mob overlays for bloody hands and/or bloody gloves

		switch(hit_area)
			if("head")//Harder to score a stun but if you do it lasts a bit longer
				if(prob(amount))
					deal_damage(10, PARALYZE, IMPACT, hit_area)
					visible_message("\red <B>[src] has been knocked unconscious!</B>")
					if(src != user && I.damtype == BRUTE)
						ticker.mode.remove_revolutionary(mind)

				if(bloody)//Apply blood
					if(wear_mask)
						wear_mask.add_blood(src)
						update_inv_wear_mask(0)
					if(head)
						head.add_blood(src)
						update_inv_head(0)
					if(glasses && prob(33))
						glasses.add_blood(src)
						update_inv_glasses(0)

			if("chest")//Easier to score a stun but lasts less time
				if(prob((amount + 10)))
					deal_damage(5, WEAKEN, IMPACT, hit_area)
					visible_message("\red <B>[src] has been knocked down!</B>")

				if(bloody)
					if(wear_suit)
						wear_suit.add_blood(src)
						update_inv_wear_suit(0)
					if(w_uniform)
						w_uniform.add_blood(src)
						update_inv_w_uniform(0)
	return 1