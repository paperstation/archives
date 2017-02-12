/mob/living/carbon/human/attack_alien(mob/living/carbon/alien/humanoid/M as mob)
	if(check_shields(0, M.name))
		visible_message("\red <B>[M] attempted to touch [src]!</B>")
		return 0

	switch(M.a_intent)
		if ("help")
			visible_message(text("\blue [M] caresses [src] with its scythe like arm."))

		if ("grab")
			if(M == src)	return
			var/obj/item/weapon/grab/G = new /obj/item/weapon/grab(M, M, src)
			M.put_in_active_hand(G)
			grabbed_by += G
			G.synch()
			LAssailant = M
			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			visible_message(text("\red [] has grabbed [] passively!", M, src))


		if("hurt")
			playsound(loc, 'sound/weapons/slice.ogg', 25, 1, -1)
			visible_message("\red <B>[M] has slashed at [src]!</B>")
			deal_damage(rand(20, 25), BRUTE, SLASH, "chest")


		if("disarm")
			if(prob(80))
				playsound(loc, 'sound/weapons/pierce.ogg', 25, 1, -1)
				deal_damage(10, WEAKEN, IMPACT, "chest")
				visible_message(text("\red <B>[] has tackled down []!</B>", M, src))
			else if(prob(50))
				playsound(loc, 'sound/weapons/slash.ogg', 25, 1, -1)
				drop_item()
				visible_message(text("\red <B>[] disarmed []!</B>", M, src))
			else
				playsound(loc, 'sound/weapons/slashmiss.ogg', 50, 1, -1)
				visible_message(text("\red <B>[] has tried to disarm []!</B>", M, src))
	return