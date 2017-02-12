/obj/item/grab
	flags = SUPPRESSATTACK
	var/mob/living/assailant
	var/mob/living/affecting
	var/state = 0 // 0 = passive, 1 aggressive, 2 neck, 3 kill
	var/choke_count = 0
	icon = 'icons/mob/hud_human_new.dmi'
	icon_state = "reinforce"
	name = "grab"
	w_class = 5

	New()
		..()
		spawn(0)
			var/icon/hud_style = hud_style_selection[get_hud_style(src.assailant)]
			if (isicon(hud_style))
				src.icon = hud_style

	disposing()
		if(affecting)
			if (state == 3)
				logTheThing("combat", src.assailant, src.affecting, "releases their choke on %target% after [choke_count] cycles")
			else
				logTheThing("combat", src.assailant, src.affecting, "drops their grab on %target%")
			affecting.grabbed_by -= src
			affecting = null
		assailant = null
		..()

	dropped()
		qdel(src)

	process()
		if (check())
			return

		var/mob/living/carbon/human/H
		if(istype(src.affecting, /mob/living/carbon/human))
			H = src.affecting

		if (src.state >= 2)
			if (!src.affecting.buckled)
				src.affecting.set_loc(src.assailant.loc)
			if(H) H.remove_stamina(STAMINA_REGEN+7)
		if (src.state == 3)
			//src.affecting.losebreath++
			//if (src.affecting.paralysis < 2)
			//	src.affecting.paralysis = 2
			if(H)
				choke_count++
				H.remove_stamina(STAMINA_REGEN+7)
				H.stamina_stun()
				if(H.stamina <= -75)
					H.losebreath += 2
				else if(H.stamina <= -50)
					H.losebreath++
				else if(H.stamina <= -33)
					if(prob(33)) H.losebreath++
		update_icon()

	attack(atom/target, mob/user)
		if (check())
			return
		if (target == src.affecting)
			attack_self()
			return

	attack_hand(mob/user)
		return

	attack_self(mob/user)
		if (!user)
			return
		if (check())
			return
		switch (src.state)
			if (0)
				if (prob(75))
					logTheThing("combat", src.assailant, src.affecting, "'s grip upped to aggressive on %target%")
					for(var/mob/O in AIviewers(src.assailant, null))
						O.show_message("<span style=\"color:red\">[src.assailant] has grabbed [src.affecting] aggressively (now hands)!</span>", 1)
					icon_state = "reinforce"
					src.state = 1
				else
					for(var/mob/O in AIviewers(src.assailant, null))
						O.show_message("<span style=\"color:red\">[src.assailant] has failed to grab [src.affecting] aggressively!</span>", 1)
					/*if (!disable_next_click) this actually is always gunna be a mob so we want to use next click even if disabled
						*/user.next_click = world.time + 10
			if (1)
				if (ishuman(src.affecting))
					var/mob/living/carbon/human/H = src.affecting
					if (H.bioHolder.HasEffect("fat"))
						boutput(src.assailant, "<span style=\"color:blue\">You can't strangle [src.affecting] through all that fat!</span>")
						return
					for (var/obj/item/clothing/C in list(H.head, H.wear_suit, H.wear_mask, H.w_uniform))
						if (C.body_parts_covered & HEAD)
							boutput(src.assailant, "<span style=\"color:blue\">You have to take off [src.affecting]'s [C.name] first!</span>")
							return
				icon_state = "!reinforce"
				src.state = 2
				if (!src.affecting.buckled)
					src.affecting.set_loc(src.assailant.loc)
				src.assailant.lastattacked = src.affecting
				src.affecting.lastattacker = src.assailant
				src.affecting.lastattackertime = world.time
				logTheThing("combat", src.assailant, src.affecting, "'s grip upped to neck on %target%")
				for(var/mob/O in AIviewers(src.assailant, null))
					O.show_message("<span style=\"color:red\">[src.assailant] has reinforced [his_or_her(assailant)] grip on [src.affecting] (now neck)!</span>", 1)
			if (2)
				icon_state = "disarm/kill"
				logTheThing("combat", src.assailant, src.affecting, "chokes %target%")
				choke_count = 0
				for (var/mob/O in AIviewers(src.assailant, null))
					O.show_message("<span style=\"color:red\">[src.assailant] has tightened [his_or_her(assailant)] grip on [src.affecting]'s neck!</span>", 1)
				src.state = 3
				src.assailant.lastattacked = src.affecting
				src.affecting.lastattacker = src.assailant
				src.affecting.lastattackertime = world.time
				if (!src.affecting.buckled)
					src.affecting.set_loc(src.assailant.loc)
				if (src.assailant.bioHolder.HasEffect("fat"))
					src.affecting.unlock_medal("Bear Hug", 1)
				//src.affecting.losebreath++
				//if (src.affecting.paralysis < 2)
				//	src.affecting.paralysis = 2
				src.affecting.stunned = max(src.affecting.stunned, 3)
				if (ishuman(src.affecting))
					var/mob/living/carbon/human/H = src.affecting
					H.set_stamina(min(0, H.stamina))
				if (/*!disable_next_click && */user)
					user.next_click = world.time + 10
			if (3)
				src.state = 2
				logTheThing("combat", src.assailant, src.affecting, "releases their choke on %target% after [choke_count] cycles")
				for (var/mob/O in AIviewers(src.assailant, null))
					O.show_message("<span style=\"color:red\">[src.assailant] has loosened [his_or_her(assailant)] grip on [src.affecting]'s neck!</span>", 1)
				/*if (!disable_next_click) same as before
					*/user.next_click = world.time + 10
		update_icon()

	proc/check()
		if (!src.affecting || get_dist(src.assailant, src.affecting) > 1 || src.loc != src.assailant)
			qdel(src)
			return 1
		return 0

	proc/update_icon()
		switch (src.state)
			if (0)
				icon_state = "reinforce"
			if (1)
				icon_state = "!reinforce"
			if (2)
				icon_state = "disarm/kill"
			if (3)
				icon_state = "disarm/kill1"