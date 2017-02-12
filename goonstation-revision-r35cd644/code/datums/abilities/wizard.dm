//////////////////////////////////////////// Setup //////////////////////////////////////////////////

/proc/equip_wizard(mob/living/carbon/human/wizard_mob, var/robe = 0)
	if (!ishuman(wizard_mob)) return

	var/datum/abilityHolder/H = wizard_mob.add_ability_holder(/datum/abilityHolder/wizard)
	H.addAbility(/datum/targetable/spell/phaseshift)
	H.addAbility(/datum/targetable/spell/magicmissile)
	H.addAbility(/datum/targetable/spell/clairvoyance)

	if (wizard_mob.mind)
		wizard_mob.mind.is_wizard = H

	spawn (25) // Don't remove.
		if (wizard_mob) wizard_mob.assign_gimmick_skull() // For variety and predators (Convair880).

	wizard_mob.bioHolder.mobAppearance.customization_first_color = "#FFFFFF"
	wizard_mob.bioHolder.mobAppearance.customization_second_color = "#FFFFFF"
	wizard_mob.cust_two_state = "wiz"
	wizard_mob.set_face_icon_dirty()

	var/obj/item/SWF_uplink/SB = new /obj/item/SWF_uplink(wizard_mob)
	if (wizard_mob.mind)
		SB.wizard_key = wizard_mob.mind.key

	//so that this proc will work for wizards made mid-round who are wearing stuff
	for(var/obj/item/I in list(wizard_mob.w_uniform, wizard_mob.wear_suit,wizard_mob.head, wizard_mob.ears, wizard_mob.back, wizard_mob.shoes, wizard_mob.r_hand, wizard_mob.l_hand, wizard_mob.r_store, wizard_mob.l_store,wizard_mob.belt))
		wizard_mob.u_equip(I)
		I.set_loc(wizard_mob.loc)
		I.dropped(wizard_mob)
		I.layer = initial(I.layer)

	if(robe) wizard_mob.equip_if_possible(new /obj/item/clothing/suit/wizrobe(wizard_mob), wizard_mob.slot_wear_suit)
	wizard_mob.equip_if_possible(new /obj/item/clothing/under/shorts/black(wizard_mob), wizard_mob.slot_w_uniform)
	wizard_mob.equip_if_possible(new /obj/item/clothing/head/wizard(wizard_mob), wizard_mob.slot_head)
	wizard_mob.equip_if_possible(new /obj/item/device/radio/headset(wizard_mob), wizard_mob.slot_ears)
	wizard_mob.equip_if_possible(new /obj/item/storage/backpack(wizard_mob), wizard_mob.slot_back)
	wizard_mob.equip_if_possible(new /obj/item/clothing/shoes/sandal(wizard_mob), wizard_mob.slot_shoes)
	wizard_mob.equip_if_possible(new /obj/item/staff(wizard_mob), wizard_mob.slot_r_hand)
	wizard_mob.equip_if_possible(new /obj/item/teleportation_scroll(wizard_mob), wizard_mob.slot_l_hand)
	wizard_mob.equip_if_possible(new /obj/item/paper/Wizardry101(wizard_mob), wizard_mob.slot_l_store)
	wizard_mob.equip_if_possible(SB, wizard_mob.slot_belt)
	wizard_mob.set_clothing_icon_dirty()

	boutput(wizard_mob, "The Space Wizards Federation has equipped you with a Spellbook on your belt with which to purchase your desired spells.")
	wizard_mob << browse(grabResource("html/traitorTips/wizardTips.html"),"window=antagTips;titlebar=1;size=600x400;can_minimize=0;can_resize=0")
	return

////////////////////////////////////////////// Helper procs ////////////////////////////////////////////////////

/mob/proc/wizard_spellpower()
	return 0

/mob/living/carbon/human/wizard_spellpower()
	var/magcount = 0
	if (!src) return 0 // ??
	if (src.bioHolder.HasEffect("arcane_power") == 2)
		magcount += 10
	for (var/obj/item/clothing/C in src.contents)
		if (C.magical) magcount += 1
	if (istype(src.r_hand, /obj/item/staff))
		magcount += 2
	if (istype(src.l_hand, /obj/item/staff))
		magcount += 2
	if (magcount >= 4) return 1
	else return 0

/mob/living/critter/wizard_spellpower()
	var/magcount = 0
	for (var/obj/item/clothing/C in src.contents)
		if (C.magical) magcount += 1
	if (src.find_in_hands(/obj/item/staff))
		magcount += 2
	if (magcount >= 4) return 1
	else return 0

/mob/proc/wizard_castcheck(var/offensive = 0)
	return 0

/mob/living/carbon/human/wizard_castcheck(var/offensive = 0)
	if(src.stat)
		boutput(src, "You can't cast spells while incapacitated.")
		return 0
	if (src.bioHolder.HasEffect("arcane_power") == 2)
		return 1
	if(!istype(src.wear_suit, /obj/item/clothing/suit/wizrobe))
		boutput(src, "You don't feel strong enough without a magical robe.")
		return 0
	if(!istype(src.head, /obj/item/clothing/head/wizard))
		boutput(src, "You don't feel strong enough without a magical hat.")
		return 0
	var/area/getarea = get_area(src)
	if(getarea.name == "Chapel" || getarea.name == "Chapel Office")
		if (get_corruption_percent() < 40)
			boutput(src, "You cannot cast spells on hallowed ground!")// Maybe if the station were more corrupted...")
			return 0
	if (offensive == 1 && src.bioHolder.HasEffect("arcane_shame"))
		boutput(src, "You are too consumed with shame to cast that spell!")
		return 0
	return 1

/mob/living/critter/wizard_castcheck(var/offensive = 0)
	if(src.stat)
		boutput(src, "You can't cast spells while incapacitated.")
		return 0
	if(!find_in_equipment(/obj/item/clothing/suit/wizrobe))
		boutput(src, "You don't feel strong enough without a magical robe.")
		return 0
	if(!find_in_equipment(/obj/item/clothing/head/wizard))
		boutput(src, "You don't feel strong enough without a magical hat.")
		return 0
	var/area/getarea = get_area(src)
	if(getarea.name == "Chapel" || getarea.name == "Chapel Office")
		if (get_corruption_percent() < 40)
			boutput(src, "You cannot cast spells on hallowed ground!")// Maybe if the station were more corrupted...")
			return 0
	return 1

//////////////////////////////////////////// Ability holder /////////////////////////////////////////

/obj/screen/ability/spell
	clicked(params)
		var/datum/targetable/spell/spell = owner
		var/datum/abilityHolder/holder = owner.holder

		if (!istype(spell))
			return
		if (!spell.holder)
			return

		if(params["shift"] && params["ctrl"])
			if(owner.waiting_for_hotkey)
				holder.cancel_action_binding()
				return
			else
				owner.waiting_for_hotkey = 1
				src.updateIcon()
				boutput(usr, "<span style=\"color:blue\">Please press a number to bind this ability to...</span>")
				return

		if (!isturf(usr.loc))
			return
		if (world.time < spell.last_cast)
			return
		if (spell.targeted && usr:targeting_spell == owner)
			usr:targeting_spell = null
			usr.update_cursor()
			return
		var/mob/user = spell.holder.owner
		if (!user.wizard_castcheck(spell.offensive))
			return
		if (spell.targeted)
			usr:targeting_spell = owner
			usr.update_cursor()
		else
			spawn
				spell.handleCast()

/datum/abilityHolder/wizard
	usesPoints = 0
	topBarRendered = 0
	tabName = "Wizard"

/////////////////////////////////////////////// Wizard spell parent ////////////////////////////

/datum/targetable/spell
	preferred_holder_type = /datum/abilityHolder/wizard
	var
		requires_robes = 0
		offensive = 0
		cooldown_staff = 0
		prepared_count = 0
		casting_time = 0

	proc/calculate_cooldown()
		var/cool = src.cooldown
		var/mob/user = src.holder.owner
		if (user && user.bioHolder)
			switch (user.bioHolder.HasEffect("arcane_power"))
				if (1)
					cool /= 2
				if (2)
					cool = 1
		if (src.cooldown_staff && !user.wizard_spellpower())
			cool *= 1.5
		return cool

	dispose()
		if (object)
			qdel(object)

	doCooldown()
		src.last_cast = world.time + calculate_cooldown()

	tryCast(atom/target)
		if (!holder || !holder.owner)
			return 1
		var/datum/abilityHolder/wizard/H = holder
		if (H.locked && src.ignore_holder_lock != 1)
			boutput(holder.owner, "<span style=\"color:red\">You're already casting an ability.</span>")
			return 1 // ASSHOLES
		if (src.last_cast > world.time)
			return 1
		if (src.restricted_area_check)
			var/turf/T = get_turf(holder.owner)
			if (!T || !isturf(T))
				boutput(holder.owner, "<span style=\"color:red\">That ability doesn't seem to work here.</span>")
				return 1
			switch (src.restricted_area_check)
				if (1)
					if (isrestrictedz(T.z))
						boutput(holder.owner, "<span style=\"color:red\">That ability doesn't seem to work here.</span>")
						return 1
				if (2)
					var/area/A = get_area(T)
					if (A && istype(A, /area/sim))
						boutput(holder.owner, "<span style=\"color:red\">You can't use this ability in virtual reality.</span>")
						return 1
		if (src.dont_lock_holder != 1)
			H.locked = 1
		if (src.cooldown_staff && !holder.owner.wizard_spellpower())
			boutput(holder.owner, "<span style=\"color:red\">Your spell takes longer to recharge without a staff to focus it!</span>")
		var/val = cast(target)
		H.locked = 0
		return val

	updateObject()
		if (!holder || !holder.owner)
			qdel(src)
		if (!src.object)
			src.object = new /obj/screen/ability/spell()
		object.icon = src.icon
		if (src.last_cast > world.time)
			object.name = "[src.name] ([round((src.last_cast-world.time)/10)])"
			object.icon_state = src.icon_state + "_cd"
		else
			object.name = src.name
			object.icon_state = src.icon_state
		object.owner = src

	castcheck()
		return holder.owner.wizard_castcheck(src.offensive)