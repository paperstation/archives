/mob/living/critter
	name = "critter"
	desc = "A beastie!"
	icon = 'icons/misc/critter.dmi'
	icon_state = "lavacrab"
	var/icon_state_dead = "lavacrab-dead"
	abilityHolder = new /datum/abilityHolder/critter

	var/datum/hud/critter/hud

	var/hand_count = 0		// Used to ease setup. Setting this in-game has no effect.
	var/list/hands = list()
	var/list/equipment = list()
	var/image/equipment_image = new
	var/image/burning_image = new
	var/burning_suffix = "generic"
	var/active_hand = 0		// ID of the active hand

	var/can_burn = 1
	var/can_throw = 0
	var/can_choke = 0
	var/in_throw_mode = 0

	var/can_help = 0
	var/can_grab = 0
	var/can_disarm = 0

	var/metabolizes = 1

	var/reagent_capacity = 50
	max_health = 0
	health = 0

	var/ultravision = 0
	var/tranquilizer_resistance = 0
	explosion_resistance = 0

	var/list/inhands = list()
	var/list/healthlist = list()

	New()
		abilityHolder.owner = src
//		if (ispath(default_task))
//			default_task = new default_task
//		if (ispath(current_task))
//			current_task = new current_task

		setup_hands()
		post_setup_hands()
		setup_equipment_slots()
		setup_reagents()
		setup_healths()
		if (!healthlist.len)
			message_coders("ALERT: Critter [type] ([name]) does not have health holders.")
		count_healths()

		hud = new(src)
		src.attach_hud(hud)
		src.zone_sel = new(src, "CENTER[hud.next_right()], SOUTH")
		src.attach_hud(zone_sel)

		for (var/datum/equipmentHolder/EE in equipment)
			EE.after_setup(hud)

		burning_image.icon = 'icons/misc/critter.dmi'
		burning_image.icon_state = null

		updatehealth()

		..()

	proc/setup_healths()
		// add_health_holder(/datum/healthHolder/flesh)
		// etc..

	proc/add_health_holder(var/T)
		var/datum/healthHolder/HH = new T
		if (!istype(HH))
			return null
		if (HH.associated_damage_type in healthlist)
			var/datum/healthHolder/OH = healthlist[HH.associated_damage_type]
			if (OH.type == T)
				return OH
			return null
		HH.holder = src
		healthlist[HH.associated_damage_type] = HH
		return HH

	proc/get_health_percentage()
		var/hp = 0
		for (var/T in healthlist)
			var/datum/healthHolder/HH = healthlist[T]
			if (HH.count_in_total)
				hp += HH.value
		if (max_health > 0)
			return hp / max_health
		return 0

	proc/count_healths()
		max_health = 0
		health = 0
		for (var/T in healthlist)
			var/datum/healthHolder/HH = healthlist[T]
			if (HH.count_in_total)
				max_health += HH.maximum_value
				health += HH.maximum_value

	// begin convenience procs
	proc/add_hh_flesh(var/min, var/max, var/mult)
		var/datum/healthHolder/Brute = add_health_holder(/datum/healthHolder/flesh)
		Brute.maximum_value = max
		Brute.value = max
		Brute.last_value = max
		Brute.damage_multiplier = mult
		Brute.depletion_threshold = min
		Brute.minimum_value = min
		return Brute

	proc/add_hh_flesh_burn(var/min, var/max, var/mult)
		var/datum/healthHolder/Burn = add_health_holder(/datum/healthHolder/flesh_burn)
		Burn.maximum_value = max
		Burn.value = max
		Burn.last_value = max
		Burn.damage_multiplier = mult
		Burn.depletion_threshold = min
		Burn.minimum_value = min
		return Burn

	proc/add_hh_robot(var/min, var/max, var/mult)
		var/datum/healthHolder/Brute = add_health_holder(/datum/healthHolder/structure)
		Brute.maximum_value = max
		Brute.value = max
		Brute.last_value = max
		Brute.damage_multiplier = mult
		Brute.depletion_threshold = min
		Brute.minimum_value = min
		return Brute

	proc/add_hh_robot_burn(var/min, var/max, var/mult)
		var/datum/healthHolder/Burn = add_health_holder(/datum/healthHolder/wiring)
		Burn.maximum_value = max
		Burn.value = max
		Burn.last_value = max
		Burn.damage_multiplier = mult
		Burn.depletion_threshold = min
		Burn.minimum_value = min
		return Burn

	// end convenience procs

	on_reagent_react(var/datum/reagents/R, var/method = 1, var/react_volume)
		for (var/T in healthlist)
			var/datum/healthHolder/HH = healthlist[T]
			HH.on_react(R, method, react_volume)

	proc/equip_click(var/datum/equipmentHolder/EH)
		if (!handcheck())
			return
		var/obj/item/I = equipped()
		var/obj/item/W = EH.item
		if (I && W)
			W.attackby(I)
		else if (I)
			if (EH.can_equip(I))
				u_equip(I)
				EH.equip(I)
				hud.add_object(I, HUD_LAYER+2, EH.screenObj.screen_loc)
			else
				boutput(src, "<span style='color:red'>You cannot equip [I] in that slot!</span>")
			update_clothing()
		else if (W)
			if (!EH.remove())
				boutput(src, "<span style='color:red'>You cannot remove [W] from that slot!</span>")
			update_clothing()

	proc/handcheck()
		if (!hand_count)
			return 0
		if (!active_hand)
			return 0
		if (hands.len >= active_hand)
			return 1
		return 0

	attackby(var/obj/item/I, var/mob/M)
		var/rv = 1
		for (var/T in healthlist)
			var/datum/healthHolder/HH = healthlist[T]
			rv = min(HH.on_attack(I, M), rv)
		if (!rv)
			return
		else
			..()

	// The throw code is a direct copy-paste from humans
	// pending better solution.
	proc/toggle_throw_mode()
		if (src.in_throw_mode)
			throw_mode_off()
		else
			throw_mode_on()

	proc/throw_mode_off()
		src.in_throw_mode = 0
		src.update_cursor()
		hud.update_throwing()

	proc/throw_mode_on()
		if (!can_throw)
			return
		src.in_throw_mode = 1
		src.update_cursor()
		hud.update_throwing()

	proc/throw_item(atom/target)
		if (!can_throw)
			return
		src.throw_mode_off()
		if (usr.stat)
			return

		var/atom/movable/item = src.equipped()

		if (istype(item, /obj/item) && item:cant_self_remove)
			return

		if (!item) return

		u_equip(item)

		if (istype(item, /obj/item/grab))
			var/obj/item/grab/grab = item
			var/mob/M = grab.affecting
			if (grab.state < 1 && !(M.paralysis || M.weakened || M.stat))
				src.visible_message("<span style=\"color:red\">[M] stumbles a little!</span>")
				qdel(grab)
				return
			M.lastattacker = src
			M.lastattackertime = world.time
			item = M
			qdel(grab)

		item.set_loc(src.loc)

		if (istype(item, /obj/item))
			item:dropped(src) // let it know it's been dropped

		//actually throw it!
		if (item)
			item.layer = initial(item.layer)
			src.visible_message("<span style=\"color:red\">[src] throws [item].</span>")
			if (iscarbon(item))
				var/mob/living/carbon/C = item
				logTheThing("combat", src, C, "throws %target% at [log_loc(src)].")
				if ( ishuman(C) )
					C.weakened = max(src.weakened, 1)
			else
				// Added log_reagents() call for drinking glasses. Also the location (Convair880).
				logTheThing("combat", src, null, "throws [item] [item.is_open_container() ? "[log_reagents(item)]" : ""] at [log_loc(src)].")
			if (istype(src.loc, /turf/space)) //they're in space, move em one space in the opposite direction
				src.inertia_dir = get_dir(target, src)
				step(src, inertia_dir)
			if (istype(item.loc, /turf/space) && istype(item, /mob))
				var/mob/M = item
				M.inertia_dir = get_dir(src,target)
			item.throw_at(target, item.throw_range, item.throw_speed)

	click(atom/target, list/params)
		if ((src.in_throw_mode || params.Find("shift")) && src.can_throw)
			src.throw_item(target)
			return
		return ..()

	update_cursor()
		if (((src.client && src.client.check_key("shift")) || src.in_throw_mode) && src.can_throw)
			src.set_cursor('icons/cursors/throw.dmi')
			return
		return ..()

	update_clothing()
		//overlays -= equipment_image
		equipment_image.overlays.len = 0
		for (var/datum/equipmentHolder/EH in equipment)
			EH.on_update()
			if (EH.item)
				var/obj/item/I = EH.item
				var/image/w_image = I.wear_image
				w_image.icon_state = "[I.icon_state]"
				w_image.layer = EH.equipment_layer
				w_image.alpha = I.alpha
				w_image.color = I.color
				w_image.pixel_x = EH.offset_x
				w_image.pixel_y = EH.offset_y
				equipment_image.overlays += w_image
		UpdateOverlays(equipment_image, "equipment")

	find_in_equipment(var/eqtype)
		for (var/datum/equipmentHolder/EH in equipment)
			if (EH.item && istype(EH.item, eqtype))
				return EH.item
		return null

	find_in_hands(var/eqtype)
		for (var/datum/handHolder/HH in equipment)
			if (HH.item && istype(HH.item, eqtype))
				return HH.item
		return null

	is_in_hands(var/obj/O)
		for (var/datum/handHolder/HH in equipment)
			if (HH.item && HH.item == O)
				return 1
		return 0

	swap_hand()
		if (!handcheck())
			return
		if (active_hand < hands.len)
			active_hand++
			hand = active_hand
		else
			active_hand = 1
			hand = active_hand
		hud.update_hands()

	hand_range_attack(atom/target, params)
		var/datum/handHolder/ch = get_active_hand()
		if (ch && ch.can_range_attack && ch.limb)
			ch.limb.attack_range(target, src, params)
			ch.set_cooldown_overlay()

	hand_attack(atom/target, params)
		var/datum/limb/L = equipped_limb()
		var/datum/handHolder/HH = get_active_hand()
		if (!L || !HH)
			boutput(src, "<span style='color:red'>You have no limbs to attack with!</span>")
			return
		if (!HH.can_attack && HH.can_range_attack)
			hand_range_attack(target, params)
		else if (HH.can_attack)
			if (ismob(target))
				switch (a_intent)
					if (INTENT_HELP)
						if (can_help)
							L.help(target, src)
					if (INTENT_DISARM)
						if (can_disarm)
							L.disarm(target, src)
					if (INTENT_HARM)
						if (HH.can_attack)
							L.harm(target, src)
					if (INTENT_GRAB)
						if (HH.can_hold_items && can_grab)
							L.grab(target, src)
			else
				L.attack_hand(target, src)
				HH.set_cooldown_overlay()
		else
			boutput(src, "<span style='color:red'>You cannot attack with your [HH.name]!</span>")

	proc/melee_attack_human(var/mob/living/carbon/human/M, var/extra_damage) // non-special limb attack
		if (M.nodamage)
			visible_message("<b><span style='color:red'>[src]'s attack bounces uselessly off [M]!</span></b>")
			playsound_local(M, "punch", 50, 0)
			return
		src.visible_message("<b><span style='color:red'>[src] punches [M]!</span></b>")
		playsound_local(M, "punch", 50, 0)
		M.TakeDamageAccountArmor(zone_sel.selecting, rand(3,6), 0, 0, DAMAGE_BLUNT)

	can_strip()
		var/datum/handHolder/HH = get_active_hand()
		if (!HH)
			return 0
		if (HH.can_hold_items)
			return 1
		else
			boutput(src, "<span style='color:red'>You cannot strip other people with your [HH.name].</span>")

	attack_hand(var/mob/living/M)
		switch (M.a_intent)
			if (INTENT_HELP)
				visible_message("<b><span style='color:blue'>[M] pets [src]!</span></b>")
			if (INTENT_DISARM)
				actions.interrupt(src, INTERRUPT_ATTACKED)
				if (src.hands.len)
					M.disarm(src)
			if (INTENT_HARM)
				actions.interrupt(src, INTERRUPT_ATTACKED)
				src.TakeDamage(M.zone_sel.selecting, rand(1,3), 0)
				playsound_local(src, "punch", 50, 0)
				visible_message("<b><span style='color:red'>[M] punches [src]!</span></b>")
			if (INTENT_GRAB)
				visible_message("<b><span style='color:red'>[M] attempts to grab [src] but it is not implemented yet!</span></b>")

	proc/get_active_hand()
		if (!handcheck())
			return null
		return hands[active_hand]

	equipped_limb()
		var/datum/handHolder/HH = get_active_hand()
		if (HH)
			return HH.limb
		return null

	proc/setup_hands()
		if (hand_count)
			for (var/i = 1, i <= hand_count, i++)
				var/datum/handHolder/HH = new
				HH.holder = src
				hands += HH
			active_hand = 1
			hand = active_hand

	proc/post_setup_hands()
		if (hand_count)
			for (var/datum/handHolder/HH in hands)
				if (!HH.limb)
					HH.limb = new /datum/limb
				HH.spawn_dummy_holder()

	proc/setup_equipment_slots()

	proc/setup_reagents()
		reagent_capacity = max(0, reagent_capacity)
		var/datum/reagents/R = new(reagent_capacity)
		R.my_atom = src
		reagents = R

	equipped()
		if (active_hand)
			if (hands.len >= active_hand)
				var/datum/handHolder/HH = hands[active_hand]
				return HH.item
		return null

	u_equip(var/obj/item/I)
		var/inhand = 0
		var/clothing = 0
		for (var/datum/handHolder/HH in hands)
			if (HH.item == I)
				HH.item = null
				hud.remove_object(I)
				inhand = 1
		if (inhand)
			update_inhands()
		for (var/datum/equipmentHolder/EH in equipment)
			if (EH.item == I)
				EH.item = null
				hud.remove_object(I)
				clothing = 1
		if (clothing)
			update_clothing()

	put_in_hand(obj/item/I, t_hand)
		if (!hands.len)
			return 0
		if (t_hand)
			if (t_hand > hands.len)
				return 0
			var/datum/handHolder/HH = hands[t_hand]
			if (HH.item || !HH.can_hold_items)
				return 0
			HH.item = I
			hud.add_object(I, HUD_LAYER+2, HH.screenObj.screen_loc)
			update_inhands()
			return 1
		else if (active_hand)
			var/datum/handHolder/HH = hands[active_hand]
			if (HH.item || !HH.can_hold_items)
				return 0
			HH.item = I
			hud.add_object(I, HUD_LAYER+2, HH.screenObj.screen_loc)
			update_inhands()
			return 1
		return 0

	Life(datum/controller/process/mobs/parent)
		if (..(parent))
			return 1

		if (burning)
			if (isturf(src.loc))
				var/turf/location = src.loc
				location.hotspot_expose(T0C + 100 + src.burning * 3, 400)
			var/damage = 1
			if (burning > 66)
				damage = 3
			else if (burning > 33)
				damage = 2
			TakeDamage("All", 0, damage)
			update_burning(-2)

		if (stat == 2)
			return 0

		if (src.get_eye_blurry())
			src.change_eye_blurry(-1)

		if (src.drowsyness)
			src.drowsyness = max(0, src.drowsyness - 1)
			if (src.drowsyness >= tranquilizer_resistance)
				src.change_eye_blurry(2)
				if (prob(5 + src.drowsyness - tranquilizer_resistance))
					src.sleeping = 2
					src.paralysis = 5

		handle_hud_overlays()
		src.antagonist_overlay_refresh(0, 0)

		if (paralysis || stunned || weakened)
			canmove = 0
		else
			canmove = 1

		if (sleeping)
			sleeping = max(0, sleeping - 1)
			paralysis = max(1, paralysis)

		var/may_deliver_recovery_warning = (paralysis || stunned || weakened)

		if (may_deliver_recovery_warning)
			empty_hands()
			actions.interrupt(src, INTERRUPT_STUNNED)

		if (paralysis)
			if (stat < 1)
				stat = 1
			paralysis = max(0, paralysis-2)
		else if (stat == 1)
			stat = 0

		if (stunned)
			stunned = max(0, stunned-2)

		if (weakened)
			weakened = max(0, weakened-2)

		if (stuttering)
			stuttering = max(0, stuttering-2)

		if (may_deliver_recovery_warning && max(max(paralysis, weakened), stunned) <= 2)
			boutput(src, "<span style='color:green'>You begin to recover</span>")

		if (reagents && metabolizes)
			reagents.metabolize(src)

		for (var/T in healthlist)
			var/datum/healthHolder/HH = healthlist[T]
			HH.Life()

		for (var/obj/item/grab/G in src)
			G.process()

		if (stat)
			return 0

//		if (!client && istype(current_task))


	proc/handle_hud_overlays()
		var/color_mod_r = 255
		var/color_mod_g = 255
		var/color_mod_b = 255
		if (src.druggy)
			vision.animate_color_mod(rgb(rand(0, 255), rand(0, 255), rand(0, 255)), 15)
		else
			vision.set_color_mod(rgb(color_mod_r, color_mod_g, color_mod_b))

		if (!src.sight_check(1) && src.stat != 2)
			src.addOverlayComposition(/datum/overlayComposition/blinded) //ov1
		else
			src.removeOverlayComposition(/datum/overlayComposition/blinded) //ov1
		vision.animate_dither_alpha(src.get_eye_blurry() / 10 * 255, 15)
		return 1

	death(var/gibbed)
		density = 0
		if (!gibbed)
			src.visible_message("<span style=\"color:red\"><b>[src]</b> dies!</span>")
			stat = 2
			icon_state = icon_state_dead
		else
			empty_hands()
			drop_equipment()
		hud.update_health()

	proc/get_health_holder(var/assoc)
		if (assoc in healthlist)
			return healthlist[assoc]
		return null

	TakeDamage(zone, brute, burn)
		hit_twitch()
		if (nodamage)
			return
		var/datum/healthHolder/Br = get_health_holder("brute")
		if (Br)
			Br.TakeDamage(brute)
		var/datum/healthHolder/Bu = get_health_holder("burn")
		if (Bu && !is_heat_resistant())
			Bu.TakeDamage(burn)
		updatehealth()

	take_brain_damage(var/amount)
		if (..())
			return 1
		if (nodamage)
			return
		var/datum/healthHolder/Br = get_health_holder("brain")
		if (Br)
			Br.TakeDamage(amount)
		return 0

	take_toxin_damage(var/amount)
		if (..())
			return 1
		if (nodamage)
			return
		var/datum/healthHolder/Tx = get_health_holder("toxin")
		if (Tx)
			Tx.TakeDamage(amount)
		return 0

	take_oxygen_deprivation(var/amount)
		if (..())
			return 1
		if (nodamage)
			return
		var/datum/healthHolder/Ox = get_health_holder("oxy")
		if (Ox)
			Ox.TakeDamage(amount)
		return 0

	get_brain_damage()
		var/datum/healthHolder/Br = get_health_holder("brain")
		if (Br)
			return Br.maximum_value - Br.value

	get_toxin_damage()
		var/datum/healthHolder/Tx = get_health_holder("toxin")
		if (Tx)
			return Tx.maximum_value - Tx.value

	get_oxygen_deprivation()
		var/datum/healthHolder/Ox = get_health_holder("oxy")
		if (Ox)
			return Ox.maximum_value - Ox.value

	lose_breath(var/amount)
		if (..())
			return 1
		var/datum/healthHolder/suffocation/Ox = get_health_holder("oxy")
		if (!istype(Ox))
			return 0
		Ox.lose_breath(amount)
		return 0

	HealDamage()
		..()
		updatehealth()

	updatehealth()
		if (src.nodamage)
			if (health != max_health)
				full_heal()
			src.health = max_health
			src.stat = 0
			icon_state = initial(icon_state)
		else
			health = max_health
			for (var/T in healthlist)
				var/datum/healthHolder/HH = healthlist[T]
				if (HH.count_in_total)
					health -= (HH.maximum_value - HH.value)
		hud.update_health()
		if (health <= 0 && stat < 2)
			death()

	proc/specific_emotes(var/act, var/param = null, var/voluntary = 0)
		return null

	proc/specific_emote_type(var/act)
		return 1

	update_inhands()
		inhands.len = 0
		for (var/datum/handHolder/HH in hands)
			var/obj/item/I = HH.item
			if (!I)
				continue
			if (!I.inhand_image)
				I.inhand_image = image(I.inhand_image_icon, "", HH.render_layer)
			I.inhand_image.icon_state = I.item_state ? "[I.item_state][HH.suffix]" : "[I.icon_state][HH.suffix]"
			I.inhand_image.pixel_x = HH.offset_x
			I.inhand_image.pixel_y = HH.offset_y
			I.inhand_image.layer = HH.render_layer
			inhands += I.inhand_image
		if (stat != 2)
			UpdateOverlays(inhands, "inhands")

	proc/empty_hands()
		for (var/datum/handHolder/HH in hands)
			if (HH.item)
				if (istype(HH.item, /obj/item/grab))
					qdel(HH.item)
					continue
				var/obj/item/I = HH.item
				I.loc = src.loc
				I.master = null
				I.layer = initial(I.layer)
				u_equip(I)

	proc/drop_equipment()
		for (var/datum/equipmentHolder/EH in equipment)
			if (EH.item)
				EH.drop(1)

	emote(var/act, var/voluntary = 0)
		var/param = null

		if (findtext(act, " ", 1, null))
			var/t1 = findtext(act, " ", 1, null)
			param = copytext(act, t1 + 1, length(act) + 1)
			act = copytext(act, 1, t1)

		var/message = specific_emotes(act, param, voluntary)
		var/m_type = specific_emote_type(act)
		if (!message)
			switch (lowertext(act))
				if ("gasp")
					if (src.emote_check(voluntary, 10))
						message = "<b>[src]</b> gasps."
				if ("cough")
					if (src.emote_check(voluntary, 10))
						message = "<b>[src]</b> coughs."
				if ("laugh")
					if (src.emote_check(voluntary, 10))
						message = "<b>[src]</b> laughs."
				if ("giggle")
					if (src.emote_check(voluntary, 10))
						message = "<b>[src]</b> giggles."
				if ("flip")
					if (src.emote_check(voluntary, 50) && !src.shrunk)
						if (istype(src.loc,/obj/))
							var/obj/container = src.loc
							boutput(src, "<span style=\"color:red\">You leap and slam your head against the inside of [container]! Ouch!</span>")
							src.paralysis += 2
							src.weakened += 4
							container.visible_message("<span style=\"color:red\"><b>[container]</b> emits a loud thump and rattles a bit.</span>")
							playsound(src.loc, "sound/effects/bang.ogg", 50, 1)
							var/wiggle = 6
							while(wiggle > 0)
								wiggle--
								container.pixel_x = rand(-3,3)
								container.pixel_y = rand(-3,3)
								sleep(1)
							container.pixel_x = 0
							container.pixel_y = 0
							if (prob(33))
								if (istype(container, /obj/storage))
									var/obj/storage/C = container
									if (C.can_flip_bust == 1)
										boutput(src, "<span style=\"color:red\">[C] [pick("cracks","bends","shakes","groans")].</span>")
										C.bust_out()
						else
							message = "<B>[src]</B> does a flip!"
							if (prob(50))
								animate_spin(src, "R", 1, 0)
							else
								animate_spin(src, "L", 1, 0)
		if (message)
			logTheThing("say", src, null, "EMOTE: [message]")
			if (m_type & 1)
				for (var/mob/O in viewers(src, null))
					O.show_message(message, m_type)
			else if (m_type & 2)
				for (var/mob/O in hearers(src, null))
					O.show_message(message, m_type)
			else if (!isturf(src.loc))
				var/atom/A = src.loc
				for (var/mob/O in A.contents)
					O.show_message(message, m_type)


	talk_into_equipment(var/mode, var/message, var/param)
		switch (mode)
			if ("left hand")
				for (var/i = 1, i <= hands.len, i++)
					var/datum/handHolder/HH = hands[i]
					if (HH.can_hold_items)
						if (HH.item)
							HH.item.talk_into(src, message, param, src.real_name)
						return
			if ("right hand")
				for (var/i = hands.len, i >= 1, i--)
					var/datum/handHolder/HH = hands[i]
					if (HH.can_hold_items)
						if (HH.item)
							HH.item.talk_into(src, message, param, src.real_name)
						return
			else
				..()

	update_burning()
		if (can_burn)
			..()

	update_burning_icon(var/old_burning)
		if (!burning)
			UpdateOverlays(null, "burning")
			return
		else if (burning < 33)
			burning_image.icon_state = "fire1_[burning_suffix]"
		else if (burning < 66)
			burning_image.icon_state = "fire2_[burning_suffix]"
		else
			burning_image.icon_state = "fire3_[burning_suffix]"
		UpdateOverlays(burning_image, "burning")

	get_head_armor_modifier()
		var/armor_mod = 0
		for (var/datum/equipmentHolder/EH in equipment)
			if ((EH.armor_coverage & HEAD) && istype(EH.item, /obj/item/clothing))
				var/obj/item/clothing/C = EH.item
				armor_mod = max(C.armor_value_melee, armor_mod)
		return armor_mod

	get_chest_armor_modifier()
		var/armor_mod = 0
		for (var/datum/equipmentHolder/EH in equipment)
			if ((EH.armor_coverage & TORSO) && istype(EH.item, /obj/item/clothing))
				var/obj/item/clothing/C = EH.item
				armor_mod = max(C.armor_value_melee, armor_mod)
		return armor_mod

	full_heal()
		..()
		icon_state = initial(icon_state)
		density = 1

	does_it_metabolize()
		return metabolizes

	is_heat_resistant()
		if (!get_health_holder("burn"))
			return 1
		return 0

	get_explosion_resistance()
		var/ret = explosion_resistance
		for (var/datum/equipmentHolder/EH in equipment)
			if (EH.armor_coverage & TORSO)
				var/obj/item/clothing/suit/S = EH.item
				if (istype(S))
					ret += S.armor_value_explosion
		return ret

	ex_act(var/severity)
		..() // Logs.
		var/ex_res = get_explosion_resistance()
		if (ex_res >= 15 && prob(ex_res * 3.5))
			severity++
		if (ex_res >= 30 && prob(ex_res * 1.5))
			severity++
		switch(severity)
			if (1)
				gib()
			if (2)
				if (health < max_health * 0.35 && prob(50))
					gib()
				else
					TakeDamage("All", rand(10, 30), rand(10, 30))
			if (3)
				TakeDamage("All", rand(20, 20))
