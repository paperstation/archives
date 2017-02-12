/mob/living/carbon/human/attack_hand(mob/living/carbon/human/M as mob)
	..()

	if((M != src) && check_shields(0, M.name))
		visible_message("<span class='warning'>[M] attempted to touch [src]!</span>")
		return 0

	if(M.gloves && istype(M.gloves,/obj/item/clothing/gloves))
		var/obj/item/clothing/gloves/G = M.gloves
		if(G.cell)
			if(G.cell.charge >= 2500)
				G.cell.charge -= 2500
				visible_message("<span class='danger'>[src] has been touched with the stun gloves by [M]!</span>")
				M.attack_log += text("\[[time_stamp()]\] <font color='red'>Stungloved [src.name] ([src.ckey])</font>")
				src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been stungloved by [M.name] ([M.ckey])</font>")
				log_attack("<font color='red'>[M.name] ([M.ckey]) stungloved [src.name] ([src.ckey])</font>")
				deal_damage(5, WEAKEN, PIERCE)
				stuttering =  max(5, stuttering)
				return 1
			else
				M << "<span class='notice'>Not enough charge!</span>"
				visible_message("<span class='danger'>[src] has been touched with the stun gloves by [M]!</span>")
			return

	switch(M.a_intent)
		if("help")
			if(health >= 0)
				help_shake_act(M)
				return 1
			if(M.health < -75)	return 0

			if((M.head && (M.head.flags & HEADCOVERSMOUTH)) || (M.wear_mask && (M.wear_mask.flags & MASKCOVERSMOUTH)))
				M << "<span class='notice'>Remove your mask!</span>"
				return 0
			if((head && (head.flags & HEADCOVERSMOUTH)) || (wear_mask && (wear_mask.flags & MASKCOVERSMOUTH)))
				M << "<span class='notice'>Remove his mask!</span>"
				return 0

			var/obj/effect/equip_e/human/O = new /obj/effect/equip_e/human()
			O.source = M
			O.target = src
			O.s_loc = M.loc
			O.t_loc = loc
			O.place = "CPR"
			requests += O
			spawn(0)
				O.process()
			return 1

		if("grab")
			if(M == src)	return 0
			if(w_uniform)	w_uniform.add_fingerprint(M)
			var/obj/item/weapon/grab/G = new /obj/item/weapon/grab(M, M, src)

			M.put_in_active_hand(G)

			grabbed_by += G
			G.synch()
			LAssailant = M

			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			visible_message("<span class='warning'>[M] has grabbed [src] passively!</span>")
			return 1

		if("hurt")
			M.attack_log += text("\[[time_stamp()]\] <font color='red'>Punched [src.name] ([src.ckey])</font>")
			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been punched by [M.name] ([M.ckey])</font>")
			log_attack("<font color='red'>[M.name] ([M.ckey]) punched [src.name] ([src.ckey])</font>")

			var/attack_verb = "punch"
			if(src.lying)
				attack_verb = "kick"
			else if(M.dna)
				switch(M.dna.mutantrace)
					if("lizard")
						attack_verb = "scratch"
					if("plant")
						attack_verb = "slash"
					if("orange")
						attack_verb = "juices"

			var/damage = rand(0, 9)
			if(!damage)
				switch(attack_verb)
					if("slash")
						playsound(loc, 'sound/weapons/slashmiss.ogg', 25, 1, -1)
					else
						playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				visible_message("<span class='warning'>[M] has attempted to [attack_verb] [src]!</span>")
				return 0

			if(HULK in M.mutations)
				damage += 6

			switch(attack_verb)
				if("slash")
					playsound(loc, 'sound/weapons/slice.ogg', 25, 1, -1)
				else if(istype(M.gloves, /obj/item/clothing/gloves/boxing))
					playsound(loc, "sound/items/boxinggloves.ogg", 25, 1, -1)
				else if(dna.mutantrace == "orange")
					playsound(loc, "sound/items/eatfood.ogg", 25, 1, -1)
				else
					playsound(loc, "punch", 25, 1, -1)


///////////////////
///special moves///
///////////////////
			if(istype(M.gloves, /obj/item/clothing/gloves/boxing))
				visible_message("<span class='danger'>[M] has boxed [src]!</span>")
			else if(istype(M.wear_mask, /obj/item/clothing/mask/luchador))
				if(prob(25))
					visible_message("<span class='danger'>[M] has bodyslammed [src]!</span>")
				if(prob(25))
					visible_message("<span class='danger'>[M] puts [src] into a half nelson!</span>")
				if(prob(25))
					visible_message("<span class='danger'>[M] has headbutted [src]!</span>")
			else
				visible_message("<span class='danger'>[M] has [attack_verb]ed [src]!</span>")
			deal_damage(damage, BRUTE, IMPACT, M.zone_sel.selecting)

		if("disarm")
			M.attack_log += text("\[[time_stamp()]\] <font color='red'>Disarmed [src.name] ([src.ckey])</font>")
			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been disarmed by [M.name] ([M.ckey])</font>")
			log_attack("<font color='red'>[M.name] ([M.ckey]) disarmed [src.name] ([src.ckey])</font>")

			if(w_uniform)
				w_uniform.add_fingerprint(M)
			if(prob(20))
				deal_damage(2, WEAKEN, IMPACT, M.zone_sel.selecting)
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
				visible_message("<span class='danger'>[M] has pushed [src]!</span>")
				return

			var/talked = 0

			if(prob(60))
				if(pulling)
					visible_message("<span class='warning'>[M] has broken [src]'s grip on [pulling]!</span>")
					talked = 1
					stop_pulling()
				if(istype(l_hand, /obj/item/weapon/grab))
					var/obj/item/weapon/grab/lgrab = l_hand
					if(lgrab.affecting)
						visible_message("<span class='warning'>[M] has broken [src]'s grip on [lgrab.affecting]!</span>")
						talked = 1
					spawn(1)
						del(lgrab)
				if(istype(r_hand, /obj/item/weapon/grab))
					var/obj/item/weapon/grab/rgrab = r_hand
					if(rgrab.affecting)
						visible_message("<span class='warning'>[M] has broken [src]'s grip on [rgrab.affecting]!</span>")
						talked = 1
					spawn(1)
						del(rgrab)
				//End BubbleWrap

				if(!talked)	//BubbleWrap
					drop_item()
					visible_message("<span class='danger'>[M] has disarmed [src]!</span>")
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
				return

			playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
			visible_message("<span class='warning'>[M] attempted to disarm [src]!</span>")
	return

///mob/living/carbon/human/proc/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, inrange, params)
//	return