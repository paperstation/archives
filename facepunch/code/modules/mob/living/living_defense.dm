
/mob/living/emp_act(severity)
	for(var/obj/O in src)
		if(!O)	continue
		O.emp_act(severity)
	return


/mob/living/blob_act()
	if(stat == 2)	return
	show_message("\red The blob attacks you!")
	deal_damage(20, BRUTE, IMPACT)
	return


/mob/living/meteorhit(O as obj)
	visible_message("\red [src] has been hit by [O]")
	deal_overall_damage(30,30)
	return


/mob/living/ex_act(severity)
	if(!blinded)
		flick("flash", flash)

	if(stat == 2 && client)
		gib()
		return

	else if (stat == 2 && !client)
		gibs(loc, viruses)
		del(src)
		return

	var/resisted = prob(get_resistance("bomb", null)*100)
	var/b_loss = 0
	var/f_loss = 0
	switch(severity)
		if(1.0)
			if(!resisted)
				gib()
				return
			b_loss += 500
			f_loss += 500
			var/atom/target = get_edge_target_turf(src, get_dir(src, get_step_away(src, src)))
			throw_at(target, 200, 4)
			return

		if(2.0)
			if(resisted)
				b_loss = 40
				f_loss = 40
				deal_damage(8, PARALYZE)
			else
				b_loss = 60
				f_loss = 60
				deal_damage(16, PARALYZE)

			if(earcheck())
				ear_deaf += 15
			else
				ear_deaf += 30

		if(3.0)
			if(resisted)
				b_loss = 10
				f_loss = 10
				deal_damage(5, PARALYZE)
			else
				b_loss = 20
				f_loss = 20
				deal_damage(10, PARALYZE)

			if(earcheck())
				ear_deaf += 5
			else
				ear_deaf += 10

	deal_overall_damage(b_loss, f_loss)//We already ran armor so just use this
	return


/mob/living/bullet_act(var/obj/item/projectile/P, var/def_zone)
	var/blocked = check_shields(P.force, P.name)
	P.on_hit(src, blocked)
	return


/mob/living/hitby(atom/movable/AM as mob|obj)//Thrown objects hitting mobs
	if(istype(AM,/obj/))
		var/obj/O = AM
		var/zone = zone_scatter("chest",75)//Hits a random part of the body, geared towards the chest
		if(!check_shields(O.force, O.name))
			deal_damage(O.force, O.damtype, O.forcetype, zone)
			src.visible_message("\red [src] has been hit by [O].")

		if(!O.fingerprintslast)
			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been hit with [O], last touched by (Unknown/No one)</font>")
			return
		var/client/assailant = directory[ckey(O.fingerprintslast)]
		if(assailant && assailant.mob && istype(assailant.mob,/mob))
			var/mob/M = assailant.mob
			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been hit with [O], last touched by [M.name] ([assailant.ckey])</font>")
			M.attack_log += text("\[[time_stamp()]\] <font color='red'>Hit [src.name] ([src.ckey]) with [O]</font>")
			log_attack("<font color='red'>[src.name] ([src.ckey]) was hit by [O], last touched by [M.name] ([assailant.ckey])</font>")
	return


/mob/living/attack_animal(mob/living/simple_animal/M as mob)
	if(check_shields(0, M.name))
		visible_message("\red <B>[M] attempted to touch [src]!</B>")
		return 0

	if(M.melee_damage_upper == 0)
		M.emote("[M.friendly] [src]")
		return
	if(M.attack_sound)
		playsound(loc, M.attack_sound, 50, 1, 1)
	for(var/mob/O in viewers(src, null))
		O.show_message("\red <B>[M]</B> [M.attacktext] [src]!", 1)
	M.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [src.name] ([src.ckey])</font>")
	src.attack_log += text("\[[time_stamp()]\] <font color='orange'>was attacked by [M.name] ([M.ckey])</font>")
	deal_damage(rand(M.melee_damage_lower, M.melee_damage_upper), BRUTE, IMPACT, pick("chest", "chest", "chest", "head", "legs", "arms"))
	return



/mob/living/attack_slime(mob/living/carbon/slime/M as mob)
	if(M.Victim) return // can't attack while eating!

	if(check_shields(0, M.name))
		visible_message("\red <B>[M] attempted to touch [src]!</B>")
		return 0

	visible_message("\red <B>The [M.name] glomps [src]!</B>")
	deal_damage(rand(10, 20), BRUTE, IMPACT, pick("chest", "head", "legs", "arms"))
	return



/mob/living/attack_paw(mob/M as mob)
	if(check_shields(0, M.name))
		visible_message("\red <B>[M] attempted to touch [src]!</B>")
		return 0

	if(M.a_intent == "help")
		help_shake_act(M)
		return

	visible_message("\red <B>[M.name] has bit [src]!</B>")
	deal_damage(rand(0, 5), BRUTE, SLASH)
	return



/mob/living/attack_alien(mob/living/carbon/alien/humanoid/M as mob)
	if(check_shields(0, M.name))
		visible_message("\red <B>[M] attempted to touch [src]!</B>")
		return 0

	switch(M.a_intent)
		if("help")
			visible_message(text("\blue [M] caresses [src] with its scythe like arm."))


		if("grab")
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


/mob/living/attack_larva(mob/living/carbon/alien/larva/L as mob)
	if(L.a_intent == "help")
		visible_message("\blue [L] rubs it's head against [src]")
		return

	var/damage = rand(1, 5)
	visible_message("\red <B>[L] bites [src]!</B>")
	if(stat != DEAD)
		deal_damage(damage, BRUTE, IMPACT)
		L.amount_grown = min(L.amount_grown + damage, L.max_grown)
	return