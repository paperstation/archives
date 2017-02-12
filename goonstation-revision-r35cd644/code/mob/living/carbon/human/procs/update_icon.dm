#define wear_sanity_check(X) if (!X.wear_image) X.wear_image = image(X.wear_image_icon)
#define inhand_sanity_check(X) if (!X.inhand_image) X.inhand_image = image(X.inhand_image_icon)

/mob/living/carbon/human/update_clothing(var/loop_blocker)
	..()

	if (src.transforming || loop_blocker)
		return

	if (!blood_image)
		blood_image = image('icons/effects/blood.dmi')

	// lol

	var/tmp/head_offset = 0
	var/tmp/hand_offset = 0
	var/tmp/body_offset = 0

	if (src.mutantrace)
		head_offset = src.mutantrace.head_offset
		hand_offset = src.mutantrace.hand_offset
		body_offset = src.mutantrace.body_offset

	if (src.buckled)
		if (istype(src.buckled, /obj/stool/bed))
			src.lying = 1
		else
			src.lying = 0

	// If he's wearing magnetic boots anchored = 1, otherwise anchored = 0
	if (istype(src.shoes, /obj/item/clothing/shoes/magnetic))
		src.anchored = 1
	else
		src.anchored = 0
	// Automatically drop anything in store / id / belt if you're not wearing a uniform.
	if (!src.w_uniform)
		for (var/obj/item/thing in list(src.r_store, src.l_store, src.wear_id, src.belt))
			if (thing)
				u_equip(thing, 1)

				if (thing)
					thing.set_loc(src.loc)
					thing.dropped(src)
					thing.layer = initial(thing.layer)

	src.UpdateOverlays(src.body_standing, "body")
	src.UpdateOverlays(src.hands_standing, "hands")
	src.UpdateOverlays(src.damage_standing, "damage")
	src.UpdateOverlays(src.head_damage_standing, "head_damage")
	src.UpdateOverlays(src.inhands_standing, "inhands")

	UpdateOverlays(src.fire_standing, "fire")

	if (src.lying != src.lying_old)
		src.lying_old = src.lying
		animate_rest(src, !src.lying)

	src.update_face()
	if (src.organHolder && src.organHolder.head)
		if (!src.mutantrace || !src.mutantrace.override_eyes)
			UpdateOverlays(image_eyes, "eyes")
		else
			UpdateOverlays(null, "eyes")
		if (!src.mutantrace || !src.mutantrace.override_hair)
			UpdateOverlays(image_cust_one, "cust_one")
		else
			UpdateOverlays(null, "cust_one")
		if (!src.mutantrace || !src.mutantrace.override_detail)
			UpdateOverlays(image_cust_two, "cust_two")
		else
			UpdateOverlays(null, "cust_two")
		if (!src.mutantrace || !src.mutantrace.override_beard)
			UpdateOverlays(image_cust_three, "cust_three")
		else
			UpdateOverlays(null, "cust_three")


	else
		UpdateOverlays(null, "eyes")
		UpdateOverlays(null, "cust_one")
		UpdateOverlays(null, "cust_two")
		UpdateOverlays(null, "cust_three")

	// Uniform
	if (src.w_uniform)
		if (src.bioHolder && bioHolder.HasEffect("fat") && !(src.w_uniform.c_flags & ONESIZEFITSALL))
			boutput(src, "<span style=\"color:red\">You burst out of the [src.w_uniform.name]!</span>")
			var/obj/item/clothing/c = src.w_uniform
			src.u_equip(c)
			if (c)
				c.set_loc(src.loc)
				c.dropped(src)
				c.layer = initial(c.layer)
		if (istype(src.w_uniform, /obj/item/clothing/under))
			var/image/suit_image
			if (src.bioHolder && src.bioHolder.HasEffect("fat"))
				if (!src.w_uniform.wear_image_fat) src.w_uniform.wear_image_fat = image(src.w_uniform.wear_image_fat_icon)
				suit_image = src.w_uniform.wear_image_fat
			else
				wear_sanity_check(src.w_uniform)
				suit_image = src.w_uniform.wear_image

			suit_image.icon_state = src.w_uniform.icon_state
			suit_image.layer = MOB_CLOTHING_LAYER
			suit_image.alpha = src.w_uniform.alpha
			suit_image.color = src.w_uniform.color
			UpdateOverlays(suit_image, "suit_image")

			if (src.w_uniform.blood_DNA)
				blood_image.icon_state =  "uniformblood"
				blood_image.layer = MOB_CLOTHING_LAYER+0.1
				UpdateOverlays(blood_image, "suit_image_blood")
			else
				UpdateOverlays(null, "suit_image_blood")
	else
		UpdateOverlays(null, "suit_image")
		UpdateOverlays(null, "suit_image_blood")

	if (src.wear_id)
		wear_sanity_check(src.wear_id)
		src.wear_id.wear_image.icon_state = "id"
		src.wear_id.wear_image.pixel_y = body_offset
		src.wear_id.wear_image.layer = MOB_BELT_LAYER
		src.wear_id.wear_image.color = src.wear_id.color
		src.wear_id.wear_image.alpha = src.wear_id.alpha
		UpdateOverlays(src.wear_id.wear_image, "wear_id")
	else
		UpdateOverlays(null, "wear_id")

	// No blood overlay if we have gloves (e.g. bloody hands visible through clean gloves).
	if (src.blood_DNA && !src.gloves)
		if (src.lying)
			blood_image.pixel_x = hand_offset
			blood_image.pixel_y = 0
		else
			blood_image.pixel_x = 0
			blood_image.pixel_y = hand_offset

		blood_image.layer = MOB_HAND_LAYER2 + 0.1
		if (src.limbs && src.limbs.l_arm && !istype(src.limbs.l_arm, /obj/item/parts/robot_parts))
			blood_image.icon_state = "left_bloodyhands"
			UpdateOverlays(blood_image, "bloody_hands_l")

		if (src.limbs && src.limbs.r_arm && !istype(src.limbs.r_arm, /obj/item/parts/robot_parts))
			blood_image.icon_state = "right_bloodyhands"
			UpdateOverlays(blood_image, "bloody_hands_r")

		blood_image.pixel_x = 0
		blood_image.pixel_y = 0
	else
		UpdateOverlays(null, "bloody_hands_l")
		UpdateOverlays(null, "bloody_hands_r")

	// Gloves
	if (src.gloves)
		wear_sanity_check(src.gloves)
		var/icon_name = src.gloves.item_state
		if (!icon_name)
			icon_name = src.gloves.icon_state

		src.gloves.wear_image.layer = MOB_HAND_LAYER2

		if (!src.gloves.monkey_clothes)
			src.gloves.wear_image.pixel_x = 0
			src.gloves.wear_image.pixel_y = hand_offset

		src.gloves.wear_image.layer = MOB_HAND_LAYER2
		if (src.limbs && src.limbs.l_arm && src.limbs && !istype(src.limbs.l_arm, /obj/item/parts/robot_parts)) //src.bioHolder && !src.bioHolder.HasEffect("robot_left_arm"))
			src.gloves.wear_image.icon_state = "left_[icon_name]"
			src.gloves.wear_image.color = src.gloves.color
			UpdateOverlays(src.gloves.wear_image, "wear_gloves_l")

		if (src.limbs && src.limbs.r_arm && src.limbs && !istype(src.limbs.r_arm, /obj/item/parts/robot_parts)) //src.bioHolder && !src.bioHolder.HasEffect("robot_right_arm"))
			src.gloves.wear_image.icon_state = "right_[icon_name]"
			src.gloves.wear_image.color = src.gloves.color
			src.gloves.wear_image.alpha = src.gloves.alpha
			UpdateOverlays(src.gloves.wear_image, "wear_gloves_r")

		if (src.gloves.blood_DNA)
			if (!src.gloves.monkey_clothes)
				if (src.lying)
					blood_image.pixel_x = hand_offset
					blood_image.pixel_y = 0
				else
					blood_image.pixel_x = 0
					blood_image.pixel_y = hand_offset

			blood_image.layer = MOB_HAND_LAYER2 + 0.1
			if (src.limbs && src.limbs.l_arm && !istype(src.limbs.l_arm, /obj/item/parts/robot_parts))
				blood_image.icon_state = "left_bloodygloves"
				UpdateOverlays(blood_image, "bloody_gloves_l")

			if (src.limbs && src.limbs.r_arm && !istype(src.limbs.r_arm, /obj/item/parts/robot_parts))
				blood_image.icon_state = "right_bloodygloves"
				UpdateOverlays(blood_image, "bloody_gloves_r")

			blood_image.pixel_x = 0
			blood_image.pixel_y = 0
		else
			UpdateOverlays(null, "bloody_gloves_l")
			UpdateOverlays(null, "bloody_gloves_r")

	else
		UpdateOverlays(null, "wear_gloves_l")
		UpdateOverlays(null, "wear_gloves_r")
		UpdateOverlays(null, "bloody_gloves_l")
		UpdateOverlays(null, "bloody_gloves_r")

	if (src.gloves && src.gloves.uses >= 1)
		src.gloves.wear_image.icon_state = "stunoverlay"
		UpdateOverlays(src.gloves.wear_image, "stunoverlay")
	else
		UpdateOverlays(null, "stunoverlay")

	// Shoes
	if (src.shoes)
		wear_sanity_check(src.shoes)
		//. = src.limbs && (!src.limbs.l_leg || istype(src.limbs.l_leg, /obj/item/parts/robot_parts) //(src.bioHolder && src.bioHolder.HasOneOfTheseEffects("lost_left_leg","robot_left_leg","robot_treads"))
		src.shoes.wear_image.layer = MOB_CLOTHING_LAYER
		if (src.limbs && src.limbs.l_leg && !istype(src.limbs.l_leg, /obj/item/parts/robot_parts))
			src.shoes.wear_image.icon_state = "left_[src.shoes.icon_state]"
			src.shoes.wear_image.color = src.shoes.color
			UpdateOverlays(src.shoes.wear_image, "wear_shoes_l")

		if (src.limbs && src.limbs.r_leg && !istype(src.limbs.r_leg, /obj/item/parts/robot_parts))
			src.shoes.wear_image.icon_state = "right_[src.shoes.icon_state]"//[!( src.lying ) ? null : "2"]"
			src.shoes.wear_image.color = src.shoes.color
			src.shoes.wear_image.alpha = src.shoes.alpha
			UpdateOverlays(src.shoes.wear_image, "wear_shoes_r")

		if (src.shoes.blood_DNA)
			blood_image.layer = MOB_CLOTHING_LAYER+0.1
			if (src.limbs && src.limbs.l_leg && !.)
				blood_image.icon_state = "left_shoesblood"//[!( src.lying ) ? null : "2"]"
				UpdateOverlays(blood_image, "bloody_shoes_l")
			else
				UpdateOverlays(null, "bloody_shoes_l")

			if (src.limbs && src.limbs.r_leg && !.)
				blood_image.icon_state = "right_shoesblood"//[!( src.lying ) ? null : "2"]"
				UpdateOverlays(blood_image, "bloody_shoes_r")
			else
				UpdateOverlays(null, "bloody_shoes_r")
		else
			UpdateOverlays(null, "bloody_shoes_l")
			UpdateOverlays(null, "bloody_shoes_r")
	else
		UpdateOverlays(null, "bloody_shoes_l")
		UpdateOverlays(null, "bloody_shoes_r")
		UpdateOverlays(null, "wear_shoes_l")
		UpdateOverlays(null, "wear_shoes_r")

	if (src.wear_suit)
		if (src.bioHolder && src.bioHolder.HasEffect("fat") && !(src.wear_suit.c_flags & ONESIZEFITSALL))
			boutput(src, "<span style=\"color:red\">You burst out of the [src.wear_suit.name]!</span>")
			var/obj/item/clothing/c = src.wear_suit
			src.u_equip(c)
			if (c)
				c.set_loc(src.loc)
				c.dropped(src)
				c.layer = initial(c.layer)
		else
			wear_sanity_check(src.wear_suit)
			if (istype(src.wear_suit, /obj/item/clothing/suit))
				if (src.wear_suit.over_all)
					src.wear_suit.wear_image.layer = MOB_OVERLAY_BASE
				else
					src.wear_suit.wear_image.layer = MOB_ARMOR_LAYER
				src.wear_suit.wear_image.icon_state = "[src.wear_suit.icon_state]"//[!( src.lying ) ? null : "2"]"
				src.wear_suit.wear_image.color = src.wear_suit.color
				src.wear_suit.wear_image.alpha = src.wear_suit.alpha
				UpdateOverlays(src.wear_suit.wear_image, "wear_suit")

			if (src.wear_suit.blood_DNA)
				if (istype(src.wear_suit, /obj/item/clothing/suit/armor/vest || /obj/item/clothing/suit/wcoat || /obj/item/clothing/suit/armor/suicide_bomb))
					blood_image.icon_state = "armorblood"
				else if (istype(src.wear_suit, /obj/item/clothing/suit/det_suit || /obj/item/clothing/suit/labcoat))
					blood_image.icon_state = "coatblood"
				else
					blood_image.icon_state = "suitblood"
				switch (src.wear_suit.wear_image.layer)
					if (MOB_OVERLAY_BASE)
						blood_image.layer = MOB_OVERLAY_BASE + 0.1
					if (MOB_ARMOR_LAYER)
						blood_image.layer = MOB_ARMOR_LAYER + 0.1
				UpdateOverlays(blood_image, "wear_suit_bloody")
			else
				UpdateOverlays(null, "wear_suit_bloody")

			if (istype(src.wear_suit, /obj/item/clothing/suit/straight_jacket))
				if (src.handcuffed)
					src.handcuffed.set_loc(src.loc)
					src.handcuffed.layer = initial(src.handcuffed.layer)
					src.handcuffed = null
				if ((src.l_hand || src.r_hand))
					var/h = src.hand
					src.hand = 1
					drop_item()
					src.hand = 0
					drop_item()
					src.hand = h
	else
		UpdateOverlays(null, "wear_suit")
		UpdateOverlays(null, "wear_suit_bloody")

	if (src.back)
		wear_sanity_check(src.back)
		src.back.wear_image.icon_state = "[src.back.icon_state]"//[!( src.lying ) ? null : "2"]"
		src.back.wear_image.pixel_x = 0
		src.back.wear_image.pixel_y = body_offset

		src.back.wear_image.layer = MOB_BACK_LAYER
		src.back.wear_image.color = src.back.color
		src.back.wear_image.alpha = src.back.alpha
		UpdateOverlays(src.back.wear_image, "wear_back")
		src.back.screen_loc = ui_back
	else
		UpdateOverlays(null, "wear_back")

	// Glasses
	if (src.glasses)
		wear_sanity_check(src.glasses)
		src.glasses.wear_image.icon_state = "[src.glasses.icon_state]"//[(!( src.lying ) ? null : "2")]"
		src.glasses.wear_image.layer = MOB_GLASSES_LAYER
		if (!src.glasses.monkey_clothes)
			src.glasses.wear_image.pixel_x = 0
			src.glasses.wear_image.pixel_y = head_offset
		src.glasses.wear_image.color = src.glasses.color
		src.glasses.wear_image.alpha = src.glasses.alpha
		UpdateOverlays(src.glasses.wear_image, "wear_glasses")
	else
		UpdateOverlays(null, "wear_glasses")
	// Ears
	if (src.ears)
		wear_sanity_check(src.ears)
		src.ears.wear_image.icon_state = "[src.ears.icon_state]"//[(!( src.lying ) ? null : "2")]"
		src.ears.wear_image.layer = MOB_GLASSES_LAYER
		src.ears.wear_image.pixel_x = 0
		src.ears.wear_image.pixel_y = head_offset
		src.ears.wear_image.color = src.ears.color
		src.ears.wear_image.alpha = src.ears.alpha
		UpdateOverlays(src.ears.wear_image, "wear_ears")
	else
		UpdateOverlays(null, "wear_ears")

	if (src.wear_mask)
		wear_sanity_check(src.wear_mask)
		if (istype(src.wear_mask, /obj/item/clothing/mask))
			src.wear_mask.wear_image.icon_state = "[src.wear_mask.icon_state]"//[(!( src.lying ) ? null : "2")]"
			if (!src.wear_mask.monkey_clothes)
				src.wear_mask.wear_image.pixel_x = 0
				src.wear_mask.wear_image.pixel_y = head_offset
			src.wear_mask.wear_image.layer = MOB_HEAD_LAYER1
			src.wear_mask.wear_image.color = src.wear_mask.color
			src.wear_mask.wear_image.alpha = src.wear_mask.alpha
			UpdateOverlays(src.wear_mask.wear_image, "wear_mask")
			if (!istype(src.wear_mask, /obj/item/clothing/mask/cigarette))
				if (src.wear_mask.blood_DNA)
					blood_image.icon_state = "maskblood"
					blood_image.layer = MOB_HEAD_LAYER1 + 0.1
					if (!src.wear_mask.monkey_clothes)
						blood_image.pixel_x = 0
						blood_image.pixel_y = head_offset
					UpdateOverlays(blood_image, "wear_mask_blood")
					blood_image.pixel_x = 0
					blood_image.pixel_y = 0
				else
					UpdateOverlays(null, "wear_mask_blood")
	else
		UpdateOverlays(null, "wear_mask")
		UpdateOverlays(null, "wear_mask_blood")
	// Head
	if (src.head)
		wear_sanity_check(src.head)

		src.head.wear_image.layer = MOB_HEAD_LAYER2
		src.head.wear_image.icon_state = "[src.head.icon_state]"
		/* TODO: adapt butts to blend colors properly again
		if (istype(src.head, /obj/item/clothing/head/butt))
			var/obj/item/clothing/head/butt/B = src.head
			if (B.s_tone >= 0)
				head_icon.Blend(rgb(B.s_tone, B.s_tone, B.s_tone), ICON_ADD)
			else
				head_icon.Blend(rgb(-B.s_tone,  -B.s_tone,  -B.s_tone), ICON_SUBTRACT)
		*/
		if (!src.head.monkey_clothes)
			src.head.wear_image.pixel_x = 0
			src.head.wear_image.pixel_y = head_offset
		src.head.wear_image.color = src.head.color
		src.head.wear_image.alpha = src.head.alpha
		UpdateOverlays(src.head.wear_image, "wear_head")
		if (src.head.blood_DNA)
			blood_image.icon_state = "helmetblood"
			blood_image.layer = MOB_HEAD_LAYER2 + 0.1
			if (!src.head.monkey_clothes)
				blood_image.pixel_x = 0
				blood_image.pixel_y = head_offset
			UpdateOverlays(blood_image, "wear_head_blood")
			blood_image.pixel_x = 0
			blood_image.pixel_y = 0
		else
			UpdateOverlays(null, "wear_head_blood")
	else
		UpdateOverlays(null, "wear_head")
		UpdateOverlays(null, "wear_head_blood")
	// Belt
	if (src.belt)
		wear_sanity_check(src.belt)
		var/t1 = src.belt.item_state
		if (!t1)
			t1 = src.belt.icon_state
		src.belt.wear_image.icon_state = "[t1]"
		src.belt.wear_image.pixel_x = 0
		src.belt.wear_image.pixel_y = body_offset
		src.belt.wear_image.layer = MOB_BELT_LAYER
		src.belt.wear_image.color = src.belt.color
		src.belt.wear_image.alpha = src.belt.alpha
		UpdateOverlays(src.belt.wear_image, "wear_belt")
		src.belt.screen_loc = ui_belt
	else
		UpdateOverlays(null, "wear_belt")

	src.UpdateName()

//	if (src.wear_id) //Most of the inventory is now hidden, this is handled by other_update()
//		src.wear_id.screen_loc = ui_id

	if (src.l_store)
		src.l_store.screen_loc = ui_storage1

	if (src.r_store)
		src.r_store.screen_loc = ui_storage2

	if (src.handcuffed)
		src.pulling = null
		handcuff_img.icon_state = "handcuff1"
		handcuff_img.pixel_x = 0
		handcuff_img.pixel_y = hand_offset
		handcuff_img.layer = MOB_HANDCUFF_LAYER
		UpdateOverlays(handcuff_img, "handcuffs")
	else
		UpdateOverlays(null, "handcuffs")

	var/shielded = 0
	for (var/obj/item/device/shield/S in src)
		if (S.active)
			shielded = 1
			break

	for (var/obj/item/cloaking_device/S in src)
		if (S.active)
			shielded = 2
			break

	if (shielded == 2) src.invisibility = 2
	else src.invisibility = 0

	if (shielded)
		UpdateOverlays(shield_image, "shield")
	else
		UpdateOverlays(null, "shield")

	for (var/I in implant_images)
		if (!(I in implant))
			UpdateOverlays(null, "implant--\ref[I]")
			implant_images -= I
	for (var/obj/item/implant/I in implant)
		if (I.implant_overlay && !(I in implant_images))
			UpdateOverlays(I.implant_overlay, "implant--\ref[I]")
			implant_images += I

	for (var/mob/M in viewers(1, src))
		if ((M.client && M.machine == src))
			spawn (0)
				src.show_inv(M)
				return

	src.last_b_state = src.stat

#undef wear_sanity_check
#undef inhand_sanity_check

/mob/living/carbon/human/update_face()
	..()

	if (src.organHolder && !src.organHolder.head)
		image_eyes.icon_state = "bald"
		image_cust_one.icon_state = "bald"
		image_cust_two.icon_state = "bald"
		image_cust_three.icon_state = "bald"
		return

	if (!src.bioHolder)
		return // fuck u

	var/datum/appearanceHolder/aH = src.bioHolder.mobAppearance
	var/datum/mutantrace/m_race = src.mutantrace
	if (src.organHolder && src.organHolder.head && src.organHolder.head.donor != src) // gaaaaaaaaaahhhhh
		if (src.organHolder.head.donor_appearance)
			aH = src.organHolder.head.donor_appearance
		if (src.organHolder.head.donor_mutantrace)
			m_race = src.organHolder.head.donor_mutantrace

	if (!m_race || !m_race.override_eyes)
		image_eyes.icon_state = "eyes"
		image_eyes.color = aH.e_color

	if (!m_race || !m_race.override_hair)
		cust_one_state = customization_styles[aH.customization_first]
		if (!cust_one_state)
			cust_one_state = customization_styles_gimmick[aH.customization_first]
		image_cust_one.icon_state = src.cust_one_state
		image_cust_one.color = aH.customization_first_color

	if (!m_race || !m_race.override_beard)
		cust_two_state = customization_styles[aH.customization_second]
		if (!cust_two_state)
			cust_two_state = customization_styles_gimmick[aH.customization_second]
		image_cust_two.icon_state = src.cust_two_state
		image_cust_two.color = aH.customization_second_color

	if (!m_race || !m_race.override_detail)
		cust_three_state = customization_styles[aH.customization_third]
		if (!cust_three_state)
			cust_three_state = customization_styles_gimmick[aH.customization_third]
		image_cust_three.icon_state = src.cust_three_state
		image_cust_three.color = aH.customization_third_color


/mob/living/carbon/human/update_burning_icon(var/old_burning)

	if (src.burning > 0)
		var/istate = "fire1"
		if (src.burning <= 33)
			istate = "fire1"
			//src.fire_standing = image('icons/mob/human.dmi', "fire1", MOB_EFFECT_LAYER)
			//src.fire_lying = image('icons/mob/human.dmi', "fire1_l", MOB_EFFECT_LAYER)
		else if (src.burning > 33 && src.burning <= 66)
			istate = "fire2"
			//src.fire_standing = image('icons/mob/human.dmi', "fire2", MOB_EFFECT_LAYER)
			//src.fire_lying = image('icons/mob/human.dmi', "fire2_l", MOB_EFFECT_LAYER)
		else if (src.burning > 66)
			istate = "fire3"
			//src.fire_standing = image('icons/mob/human.dmi', "fire3", MOB_EFFECT_LAYER)
			//src.fire_lying = image('icons/mob/human.dmi', "fire3_l", MOB_EFFECT_LAYER)
		src.fire_standing = SafeGetOverlayImage("fire", 'icons/mob/human.dmi', istate, MOB_EFFECT_LAYER)

		//make them light up!
		burning_light.set_brightness(round(0.5 + src.burning / 150, 0.1))
		burning_light.enable()
	else
		src.fire_standing = null
		burning_light.disable()

	UpdateOverlays(src.fire_standing, "fire", 0, 1)

/mob/living/carbon/human/update_inhands()

	src.inhands_standing.len = 0
	var/image/i_r_hand = null
	var/image/i_l_hand = null

	var/hand_offset = 0
	if (src.mutantrace)
		hand_offset = src.mutantrace.hand_offset

	if (src.limbs)
		if (src.limbs.r_arm && src.r_hand)
			if (!istype(src.limbs.r_arm, /obj/item/parts/human_parts/arm/right/item) && istype(src.r_hand, /obj/item))
				var/obj/item/I = src.r_hand
				if (!I.inhand_image)
					I.inhand_image = image(I.inhand_image_icon, "", MOB_INHAND_LAYER)
				I.inhand_image.icon_state = I.item_state ? I.item_state + "-R" : I.icon_state + "-R"

				I.inhand_image.pixel_x = 0
				I.inhand_image.pixel_y = hand_offset
				i_r_hand = I.inhand_image

		if (src.limbs.l_arm && src.l_hand)
			if (!istype(src.limbs.l_arm, /obj/item/parts/human_parts/arm/left/item) && istype(src.l_hand, /obj/item))
				var/obj/item/I = src.l_hand
				if (!I.inhand_image)
					I.inhand_image = image(I.inhand_image_icon, "", MOB_INHAND_LAYER)
				I.inhand_image.icon_state = I.item_state ? I.item_state + "-L" : I.icon_state + "-L"

				I.inhand_image.pixel_x = 0
				I.inhand_image.pixel_y = hand_offset
				i_l_hand = I.inhand_image


	UpdateOverlays(i_r_hand, "i_r_hand")
	UpdateOverlays(i_l_hand, "i_l_hand")

/mob/living/carbon/human/proc/update_hair_layer()
	if (src.wear_suit && src.head && src.wear_suit.over_hair && src.head.seal_hair)
		src.image_cust_one.layer = MOB_HAIR_LAYER1
		src.image_cust_two.layer = MOB_HAIR_LAYER1
		src.image_cust_three.layer = MOB_HAIR_LAYER1
	else
		src.image_cust_one.layer = MOB_HAIR_LAYER2
		src.image_cust_two.layer = MOB_HAIR_LAYER2
		src.image_cust_three.layer = MOB_HAIR_LAYER2


var/list/update_body_limbs = list("r_arm" = "stump_arm_right", "l_arm" = "stump_arm_left", "r_leg" = "stump_leg_right", "l_leg" = "stump_leg_left")

/mob/living/carbon/human/update_body()
	..()

	var/file
	if (!src.decomp_stage)
		file = 'icons/mob/human.dmi'
	else
		file = 'icons/mob/human_decomp.dmi'

	src.body_standing = SafeGetOverlayImage("body", file, "blank", MOB_LIMB_LAYER) // image('icons/mob/human.dmi', "blank", MOB_LIMB_LAYER)
	src.body_standing.overlays.len = 0
	src.hands_standing = SafeGetOverlayImage("hands", file, "blank", MOB_HAND_LAYER1) //image('icons/mob/human.dmi', "blank", MOB_HAND_LAYER1)
	src.hands_standing.overlays.len = 0

	/*
	src.body_standing = image('icons/mob/human_decomp.dmi', "blank", MOB_LIMB_LAYER)
	src.hands_standing = image('icons/mob/human_decomp.dmi', "blank", MOB_HAND_LAYER1)
	*/
	if (!src.mutantrace)
		if ((src.bioHolder && !src.bioHolder.HasEffect("fat")) || src.decomp_stage)
			var/gender_t = src.gender == FEMALE ? "f" : "m"

			var/skin_tone = src.bioHolder.mobAppearance.s_tone
			human_image.color = rgb(skin_tone + 220, skin_tone + 220, skin_tone + 220)
			human_decomp_image.color = rgb(skin_tone + 220, skin_tone + 220, skin_tone + 220)

			if (!src.decomp_stage)
				human_image.icon_state = "chest_[gender_t]"
				src.body_standing.overlays += human_image
				human_image.icon_state = "groin_[gender_t]"
				src.body_standing.overlays += human_image
				if (src.organHolder && src.organHolder.head)
					human_head_image.icon_state = "head"
					if (src.organHolder.head.donor_mutantrace)
						human_head_image.icon_state = "[src.organHolder.head.donor_mutantrace.icon_state]"
					else if (src.organHolder.head.donor_appearance && src.organHolder.head.donor_appearance.s_tone != skin_tone)
						var/h_skin_tone = src.organHolder.head.donor_appearance.s_tone
						human_head_image.color = rgb(h_skin_tone + 220, h_skin_tone + 220, h_skin_tone + 220)
					else
						human_head_image.color = rgb(skin_tone + 220, skin_tone + 220, skin_tone + 220)
					src.body_standing.overlays += human_head_image

			else
				human_decomp_image.icon_state = "body_decomp[src.decomp_stage]"
				src.body_standing.overlays += human_decomp_image

			if (src.limbs)
				for (var/name in update_body_limbs) // this is awful
					var/obj/item/parts/human_parts/limb = src.limbs.vars[name]
					if (limb)
						src.body_standing.overlays += limb.getMobIcon(0, src.decomp_stage)

						var/hand_icon_s = limb.getHandIconState(0, src.decomp_stage)

						var/part_icon_s = limb.getPartIconState(0, src.decomp_stage)

						if (limb.decomp_affected && src.decomp_stage)
							if (hand_icon_s)
								if (limb.skintoned)
									var/oldlayer = human_decomp_image.layer // ugh
									human_decomp_image.layer = MOB_HAND_LAYER1
									human_decomp_image.icon_state = hand_icon_s
									src.hands_standing.overlays += human_decomp_image
									human_decomp_image.layer = oldlayer
								else
									var/oldlayer = human_untoned_decomp_image.layer // ugh
									human_untoned_decomp_image.layer = MOB_HAND_LAYER1
									human_untoned_decomp_image.icon_state = hand_icon_s
									src.hands_standing.overlays += human_untoned_decomp_image
									human_untoned_decomp_image.layer = oldlayer


							if (part_icon_s)
								if (limb.skintoned)
									human_decomp_image.icon_state = part_icon_s
									src.body_standing.overlays += human_decomp_image
								else
									human_untoned_decomp_image.icon_state = part_icon_s
									src.body_standing.overlays += human_untoned_decomp_image
						else
							if (hand_icon_s)
								if (limb.skintoned)
									var/oldlayer = human_image.layer // ugh
									human_image.layer = MOB_HAND_LAYER1
									human_image.icon_state = hand_icon_s
									src.hands_standing.overlays += human_image
									human_image.layer = oldlayer
								else
									var/oldlayer = human_untoned_image.layer // ugh
									human_untoned_image.layer = MOB_HAND_LAYER1
									human_untoned_image.icon_state = hand_icon_s
									src.hands_standing.overlays += human_untoned_image
									human_untoned_image.layer = oldlayer

							if (part_icon_s)
								if (limb.skintoned)
									human_image.icon_state = part_icon_s
									src.body_standing.overlays += human_image
								else
									human_untoned_image.icon_state = part_icon_s
									src.body_standing.overlays += human_untoned_image
					else
						var/stump = update_body_limbs[name]
						if (src.decomp_stage)
							var/decomp = "_decomp[src.decomp_stage]"
							human_decomp_image.icon_state = "[stump][decomp]"
							src.body_standing.overlays += human_decomp_image
						else
							human_image.icon_state = "[stump]"
							src.body_standing.overlays += human_image

			human_image.color = "#fff"

			if (src.organHolder && src.organHolder.heart)
				if (src.organHolder.heart.robotic)
					heart_image.icon_state = "roboheart"
					src.body_standing.overlays += heart_image

				if (src.organHolder.heart.emagged)
					heart_emagged_image.layer = FLOAT_LAYER
					heart_emagged_image.icon_state = "roboheart_emagged"
					src.body_standing.overlays += heart_emagged_image

				if (src.organHolder.heart.synthetic)
					heart_image.icon_state = "synthheart"
					src.body_standing.overlays += heart_image

			if (src.bioHolder.mobAppearance.underwear && src.decomp_stage < 3)
				undies_image.icon_state = underwear_styles[src.bioHolder.mobAppearance.underwear]
				undies_image.color = hex2rgb(src.bioHolder.mobAppearance.u_color)
				src.body_standing.overlays += undies_image

			if (src.bandaged.len > 0)
				for (var/part in src.bandaged)
					bandage_image.icon_state = "bandage-[part]"
					src.body_standing.overlays += bandage_image

			if (src.spiders)
				spider_image.icon_state = "spiders"
				src.body_standing.overlays += spider_image

			if (src.juggling())
				juggle_image.icon_state = "juggle"
				src.body_standing.overlays += juggle_image

		else
			var/skin_tone = src.bioHolder.mobAppearance.s_tone
			human_image.color = rgb(skin_tone + 220, skin_tone + 220, skin_tone + 220)
			human_image.icon_state = "fatbody"
			src.body_standing.overlays += human_image
			human_image.color = "#fff"
	else
		src.body_standing.overlays += image(src.mutantrace.icon, src.mutantrace.icon_state, MOB_LIMB_LAYER)

	if (src.bioHolder)
		src.bioHolder.OnMobDraw()
	//Also forcing the updates since the overlays may have been modified on the images
	src.UpdateOverlays(src.body_standing, "body", 1, 1)
	src.UpdateOverlays(src.hands_standing, "hands", 1, 1)
	//if (src.damage_animation)
		//src.overlays += src.damage_animation


/mob/living/carbon/human/UpdateDamageIcon()
	if (lastDamageIconUpdate && !(world.time - lastDamageIconUpdate))
		return
	..()

	var/brute = get_brute_damage()
	var/burn = get_burn_damage()
	var/brute_state = 0
	var/burn_state = 0
	if (brute > 100)
		brute_state = 3
	else if (brute > 50)
		brute_state = 2
	else if (brute > 25)
		brute_state = 1

	if (burn > 100)
		burn_state = 3
	else if (burn > 50)
		burn_state = 2
	else if (burn > 25)
		burn_state = 1

	var/obj/item/organ/head/HO = organs["head"]
	var/head_damage = null
	if (HO && organHolder && organHolder.head)
		var/head_brute = min(3,round(HO.brute_dam/10))
		var/head_burn = min(3,round(HO.burn_dam/10))
		if (head_brute+head_burn > 0)
			head_damage = "head[head_brute][head_burn]"

	src.damage_standing = SafeGetOverlayImage("damage", 'icons/mob/dam_human.dmi',"[brute_state][burn_state]")// image('icons/mob/dam_human.dmi', "[brute_state][burn_state]", MOB_DAMAGE_LAYER)
	src.damage_standing.layer = MOB_DAMAGE_LAYER
	if (head_damage && organHolder && organHolder.head)
		src.head_damage_standing = SafeGetOverlayImage("head_damage", 'icons/mob/dam_human.dmi', head_damage, MOB_DAMAGE_LAYER) // image('icons/mob/dam_human.dmi', head_damage, MOB_DAMAGE_LAYER)
	else
		src.head_damage_standing = SafeGetOverlayImage("head_damage", 'icons/mob/dam_human.dmi', "00", MOB_DAMAGE_LAYER)//image('icons/mob/dam_human.dmi', "00", MOB_DAMAGE_LAYER)

	if(burn_state || brute_state)
		UpdateOverlays(src.damage_standing, "damage")
		UpdateOverlays(src.head_damage_standing, "head_damage")
	else
		UpdateOverlays(null, "damage",0,1)
		UpdateOverlays(null, "head_damage",0,1)

