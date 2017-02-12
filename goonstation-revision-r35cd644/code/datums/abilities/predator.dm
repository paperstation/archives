// Converted everything related to predators from client procs to ability holders and used
// the opportunity to do some clean-up as well (Convair880).

//////////////////////////////////////////// Setup //////////////////////////////////////////////////

/mob/proc/make_predator()
	if (ishuman(src))
		var/datum/abilityHolder/predator/A = src.get_ability_holder(/datum/abilityHolder/predator)
		if (A && istype(A))
			return

		var/datum/abilityHolder/predator/P = src.add_ability_holder(/datum/abilityHolder/predator)
		P.addAbility(/datum/targetable/predator/predator_gearspawn)
		P.addAbility(/datum/targetable/predator/predator_taketrophy)
		P.addAbility(/datum/targetable/predator/predator_trophycount)

		if (src.mind && src.mind.special_role != "omnitraitor")
			src << browse(grabResource("html/traitorTips/predatorTips.html"),"window=antagTips;titlebar=1;size=600x400;can_minimize=0;can_resize=0")

	else return

////////////////////////////////////////////// Helper procs //////////////////////////////

/mob/living/carbon/human/proc/predator_transform()
	if (ishuman(src))
		var/mob/living/carbon/human/M = src

		M.real_name = "predator"

		M.jitteriness = 0
		M.stunned = 0
		M.weakened = 0
		M.paralysis = 0
		M.slowed = 0
		M.change_misstep_chance(-INFINITY)
		M.stuttering = 0
		M.drowsyness = 0

		if (M.handcuffed)
			M.visible_message("<span style=\"color:red\"><B>[M] rips apart the handcuffs with pure brute strength!</b></span>")
			qdel(M.handcuffed)
			M.handcuffed = null
		M.buckled = null

		if (M.mutantrace)
			qdel(M.mutantrace)
		M.set_mutantrace(/datum/mutantrace/predator)

		M.unequip_all()

		var/obj/item/implant/microbomb/predator/B = new /obj/item/implant/microbomb/predator(M)
		B.implanted = 1
		B.implanted(M)

		M.equip_if_possible(new /obj/item/clothing/under/gimmick/predator(M), slot_w_uniform) // Must be at the top of the list.
		M.equip_if_possible(new /obj/item/clothing/mask/predator(M), slot_wear_mask)
		M.equip_if_possible(new /obj/item/storage/belt/predator(M), slot_belt)
		M.equip_if_possible(new /obj/item/clothing/shoes/cowboy/predator(M), slot_shoes)
		M.equip_if_possible(new /obj/item/device/radio/headset(M), slot_ears)
		M.equip_if_possible(new /obj/item/storage/backpack(M), slot_back)
		M.equip_if_possible(new /obj/item/cloaking_device(M), slot_r_store)
		M.equip_if_possible(new /obj/item/knife_butcher/predspear(M), slot_l_hand)
		M.equip_if_possible(new /obj/item/gun/energy/laser_gun/pred(M), slot_r_hand)

		M.set_face_icon_dirty()
		M.set_body_icon_dirty()
		M.update_clothing()

		boutput(M, __blue("<h3>You have received your equipment. Let the hunt begin!</h3>"))
		logTheThing("combat", M, null, "transformed into a predator at [log_loc(M)].")
		return 1

	else
		return 0

// Called for every human mob spawn and mutantrace change. The value of non-standard skulls is defined in organ.dm.
#define default_skull_desc "A trophy from a less interesting kill."
#define default_skull_value 1
/mob/proc/assign_gimmick_skull()
	if (!src || !ismob(src))
		return

	if (ishuman(src))
		var/mob/living/carbon/human/H = src

		if (!H.organHolder)
			sleep (20)
			if (!H.organHolder)
				return

		for (var/obj/item/W in H)
			if (istype(W, /obj/item/skull/) && W == H.organHolder.skull)
				var/obj/item/skull/S = H.organHolder.skull
				var/skull_type = null
				var/skull_value = default_skull_value
				var/skull_desc = default_skull_desc // The examine desc for predators.

				// Cluwnes first.
				if (iscluwne(H))
					skull_type = /obj/item/skull/noface
					skull_desc = "A meaningless trophy from a weak opponent. You feel disgusted to even look at it."

				else
					// Antagonist check.
					if (checktraitor(H))
						switch (H.mind.special_role) // Ordered by skull value.
							if ("omnitraitor")
								skull_type = /obj/item/skull/crystal
								skull_desc = "A trophy taken from a mystic, all-powerful creature. It is an immeasurable honor."
							if ("predator")
								skull_type = /obj/item/skull/strange
								skull_desc = "A trophy taken from a predator, the finest hunters of all."
							if ("changeling")
								skull_type = /obj/item/skull/odd
								skull_desc = "A trophy taken from a shapeshifting alien! It is an immense honor."
							if ("werewolf")
								skull_value = 4
								skull_desc = "A grand trophy from a lycanthrope, a very capable hunter. It is an immense honor."
							if ("wizard")
								skull_type = /obj/item/skull/peculiar
								skull_desc = "A grand trophy from a powerful magician. It brings you great honor."
							if ("vampire")
								skull_value = 3
								skull_desc = "A trophy taken from an undead vampire! It brings you great honor."
							else
								skull_value = 2
								skull_desc = "A worthy trophy from a capable opponent."

					else
						// Mutantrace and ability holder check for non-antagonists.
						if (ischangeling(H) || isvampire(H))
							if (ischangeling(H))
								skull_type = /obj/item/skull/odd
								skull_desc = "A trophy taken from a shapeshifting alien! It is an immense honor."
							else if (isvampire(H))
								skull_value = 3
								skull_desc = "A trophy taken from an undead vampire! It brings you great honor."

						else
							if (!isnull(H.mutantrace))
								if (ispredator(H))
									skull_type = /obj/item/skull/strange
									skull_desc = "A trophy taken from a predator, the finest hunters of all."
								if (iswerewolf(H))
									skull_value = 4
									skull_desc = "A grand trophy from a lycanthrope, a very capable hunter. It is an immense honor."
								if (ismonkey(H) || H.bioHolder && H.bioHolder.HasEffect("monkey"))
									skull_value = 0
									skull_desc = "A meaningless trophy from a lab monkey. You feel disgusted to even look at it."

						// Everything's still default, so check for assigned_role. Could be a lizard captain or whatever.
						if (isnull(skull_type) && skull_value == default_skull_value && skull_desc == default_skull_desc)
							if (H.mind)
								if (H.mind.special_role == "macho man") // Not in ticker.Agimmicks.
									skull_type = /obj/item/skull/gold
									skull_desc = "A trophy taken from a legendary wrestler. It is an immeasurable honor."
								else
									switch (H.mind.assigned_role)
										if ("Head of Security")
											skull_value = 3
											skull_desc = "A grand trophy from a very worthy foe. It brings you great honor."
										if ("Captain")
											skull_value = 3
											skull_desc = "A grand trophy from a very worthy foe. It brings you great honor."
										if ("Security Officer")
											skull_value = 2
											skull_desc = "A worthy trophy from a capable opponent."
										if ("Detective")
											skull_value = 2
											skull_desc = "A worthy trophy from a capable opponent."
										if ("Vice Officer")
											skull_value = 2
											skull_desc = "A worthy trophy from a capable opponent."
										if ("Head of Personnel")
											skull_value = 2
											skull_desc = "A worthy trophy from a capable opponent."
										if ("Clown")
											skull_value = -1
											skull_desc = "A meaningless trophy from a weak opponent. You feel disgusted to even look at it."

				// Assign new skull or change value/desc.
				if (!isnull(skull_type))
					var/obj/item/skull/new_skull = new skull_type
					skull_value = new_skull.value // Defined in organ.dm. Copied because there isn't always a need to replace the skull.

					if (S.type != new_skull.type)
						new_skull.donor = H
						new_skull.preddesc = skull_desc
						new_skull.set_loc(H)
						H.organHolder.skull = new_skull
						qdel(S)
						//DEBUG("[H]'s skull: [new_skull.type] (V: [new_skull.value], D: [new_skull.preddesc])")
					else
						qdel(new_skull)
						S.value = skull_value
						S.preddesc = skull_desc
						//DEBUG("[H]'s skull: [S.type] (V: [S.value], D: [S.preddesc])")
				else
					S.value = skull_value
					S.preddesc = skull_desc
					//DEBUG("[H]'s skull: [S.type] (V: [S.value], D: [S.preddesc])")

	return
#undef default_skull_value
#undef default_skull_desc

// Returns the combined value of all trophies in the player's possession.
/mob/proc/get_skull_value()
	if (!src || !ismob(src))
		return 0

	var/value = 0

	var/list/L = src.get_all_items_on_mob()
	if (L && L.len)
		for (var/obj/item/skull/S in L)
			if (ishuman(src))
				var/mob/living/carbon/human/H = src
				if (H.organHolder.skull == S)
					continue // Your own skull doesn't count, dummy!
			value += S.value
	return value

//////////////////////////////////////////// Ability holder /////////////////////////////////////////

/obj/screen/ability/predator
	clicked(params)
		var/datum/targetable/predator/spell = owner
		if (!istype(spell))
			return
		if (!spell.holder)
			return
		if (!isturf(owner.holder.owner.loc))
			boutput(owner.holder.owner, "<span style=\"color:red\">You can't use this ability here.</span>")
			return
		if (spell.targeted && usr:targeting_spell == owner)
			usr:targeting_spell = null
			usr.update_cursor()
			return
		if (spell.targeted)
			if (world.time < spell.last_cast)
				return
			owner.holder.owner.targeting_spell = owner
			owner.holder.owner.update_cursor()
		else
			spawn
				spell.handleCast()
		return

/datum/abilityHolder/predator
	usesPoints = 0
	regenRate = 0
	tabName = "Predator"
	notEnoughPointsMessage = "<span style=\"color:red\">You aren't strong enough to use this ability.</span>"

/////////////////////////////////////////////// Predator spell parent ////////////////////////////

/datum/targetable/predator
	icon = 'icons/mob/critter_ui.dmi'
	icon_state = "template"  // No custom sprites yet.
	cooldown = 0
	last_cast = 0
	pointCost = 0
	preferred_holder_type = /datum/abilityHolder/predator
	var/when_stunned = 0 // 0: Never | 1: Ignore mob.stunned and mob.weakened | 2: Ignore all incapacitation vars
	var/not_when_handcuffed = 0
	var/predator_only = 0

	New()
		var/obj/screen/ability/predator/B = new /obj/screen/ability/predator(null)
		B.icon = src.icon
		B.icon_state = src.icon_state
		B.owner = src
		B.name = src.name
		B.desc = src.desc
		src.object = B
		return

	updateObject()
		..()
		if (!src.object)
			src.object = new /obj/screen/ability/predator()
			object.icon = src.icon
			object.owner = src
		if (src.last_cast > world.time)
			var/pttxt = ""
			if (pointCost)
				pttxt = " \[[pointCost]\]"
			object.name = "[src.name][pttxt] ([round((src.last_cast-world.time)/10)])"
			object.icon_state = src.icon_state + "_cd"
		else
			var/pttxt = ""
			if (pointCost)
				pttxt = " \[[pointCost]\]"
			object.name = "[src.name][pttxt]"
			object.icon_state = src.icon_state
		return

	proc/incapacitation_check(var/stunned_only_is_okay = 0)
		if (!holder)
			return 0

		var/mob/living/M = holder.owner
		if (!M || !ismob(M))
			return 0

		switch (stunned_only_is_okay)
			if (0)
				if (M.stat != 0 || M.stunned > 0 || M.paralysis > 0 || M.weakened > 0)
					return 0
				else
					return 1
			if (1)
				if (M.stat != 0 || M.paralysis > 0)
					return 0
				else
					return 1
			else
				return 1

	castcheck()
		if (!holder)
			return 0

		var/mob/living/carbon/human/M = holder.owner

		if (!M)
			return 0

		if (!ishuman(M)) // Only humans use mutantrace datums.
			boutput(M, __red("You cannot use any powers in your current form."))
			return 0

		if (M.transforming)
			boutput(M, __red("You can't use any powers right now."))
			return 0

		if (predator_only == 1 && !ispredator(M))
			boutput(M, __red("You're not quite sure how to go about doing that in your current form."))
			return 0

		if (incapacitation_check(src.when_stunned) != 1)
			boutput(M, __red("You can't use this ability while incapacitated!"))
			return 0

		if (src.not_when_handcuffed == 1 && M.restrained())
			boutput(M, __red("You can't use this ability when restrained!"))
			return 0

		return 1

	cast(atom/target)
		. = ..()
		actions.interrupt(holder.owner, INTERRUPT_ACT)
		return