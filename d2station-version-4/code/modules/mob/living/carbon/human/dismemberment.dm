//Just for admintesting, to see if this works, honk
//You can no longer pick shit up with a missing hand
//TODO
//Drop items on worn limb //done //???
//Slow down user when missing legs/Crawl //done
//Cyborg limbsb //done

/mob/living/carbon/human/var/datum/organmanager/organ_manager = new()

/datum/organmanager
	var/head = 1
	var/l_hand = 1
	var/r_hand = 1
	var/l_arm = 1
	var/r_arm = 1
	var/l_foot = 1
	var/r_foot = 1
	var/l_leg = 1
	var/r_leg = 1


/mob/living/carbon/human/proc/update_body() //Honk
	if(src.stand_icon)
		del(src.stand_icon)
	if(src.lying_icon)
		del(src.lying_icon)

	if(!mutantrace == "zombie" && src.mutantrace)
		return

	var/g = "m"
	if (src.gender == MALE)
		g = "m"
	else if (src.gender == FEMALE)
		g = "f"

	if(mutantrace == "zombie")
		src.stand_icon = new /icon('zombie.dmi', "blank")
		src.lying_icon = new /icon('zombie.dmi', "blank")
	else
		src.stand_icon = new /icon('human.dmi', "blank")
		src.lying_icon = new /icon('human.dmi', "blank")

//	var/husk = (src.mutations & 64)
	var/obese = (src.mutations & 32)

//	if (husk)
//		src.stand_icon.Blend(new /icon('human.dmi', "husk_s"), ICON_OVERLAY)
//		src.lying_icon.Blend(new /icon('human.dmi', "husk_l"), ICON_OVERLAY)
//	else
	if(mutantrace == "zombie")
		src.stand_icon.Blend(new /icon('zombie.dmi', "chest_[g]_s"), ICON_OVERLAY)
		src.lying_icon.Blend(new /icon('zombie.dmi', "chest_[g]_l"), ICON_OVERLAY)
	else if(obese)
		src.stand_icon.Blend(new /icon('human.dmi', "fatbody_s"), ICON_OVERLAY)
		src.lying_icon.Blend(new /icon('human.dmi', "fatbody_l"), ICON_OVERLAY)
	else
		src.stand_icon.Blend(new /icon('human.dmi', "chest_[g]_s"), ICON_OVERLAY)
		src.lying_icon.Blend(new /icon('human.dmi', "chest_[g]_l"), ICON_OVERLAY)

	for (var/part in list("head", "arm_left", "arm_right", "hand_left", "hand_right", "leg_left", "leg_right", "foot_left", "foot_right"))
		if(part == "hand_left" && !src.hasPart("arm_left"))
			continue
		if(part == "hand_right" && !src.hasPart("arm_right"))
			continue
		if(part == "foot_left" && !src.hasPart("leg_left"))
			continue
		if(part == "foot_right" && !src.hasPart("leg_right"))
			continue

		if(mutantrace == "zombie")
			if(src.hasPart(part) == 1)
				src.stand_icon.Blend(new /icon('zombie.dmi', "[part]_s"), ICON_OVERLAY)
				src.lying_icon.Blend(new /icon('zombie.dmi', "[part]_l"), ICON_OVERLAY)
			else
				src.stand_icon.Blend(new /icon('zombie_dismemberment.dmi', "[part]_s[src.hasPart(part)]"), ICON_OVERLAY)
				src.lying_icon.Blend(new /icon('zombie_dismemberment.dmi', "[part]_l[src.hasPart(part)]"), ICON_OVERLAY)
			src.stand_icon.Blend(new /icon('zombie.dmi', "groin_[g]_s"), ICON_OVERLAY)
			src.lying_icon.Blend(new /icon('zombie.dmi', "groin_[g]_l"), ICON_OVERLAY)
		else
			if(src.hasPart(part) == 1)
				src.stand_icon.Blend(new /icon('human.dmi', "[part]_s"), ICON_OVERLAY)
				src.lying_icon.Blend(new /icon('human.dmi', "[part]_l"), ICON_OVERLAY)
			else
				src.stand_icon.Blend(new /icon('human_dismemberment.dmi', "[part]_s[src.hasPart(part)]"), ICON_OVERLAY)
				src.lying_icon.Blend(new /icon('human_dismemberment.dmi', "[part]_l[src.hasPart(part)]"), ICON_OVERLAY)

			src.stand_icon.Blend(new /icon('human.dmi', "groin_[g]_s"), ICON_OVERLAY)
			src.lying_icon.Blend(new /icon('human.dmi', "groin_[g]_l"), ICON_OVERLAY)

	// Skin tone
	if(mutantrace == "zombie")
		if (src.underwear > 0)
			src.stand_icon.Blend(new /icon('zombie.dmi', "underwear[src.underwear]_[g]_s"), ICON_OVERLAY)
			src.lying_icon.Blend(new /icon('zombie.dmi', "underwear[src.underwear]_[g]_l"), ICON_OVERLAY)
	else
		if (src.s_tone >= 0)
			src.stand_icon.Blend(rgb(src.s_tone, src.s_tone, src.s_tone), ICON_ADD)
			src.lying_icon.Blend(rgb(src.s_tone, src.s_tone, src.s_tone), ICON_ADD)
		else
			src.stand_icon.Blend(rgb(-src.s_tone,  -src.s_tone,  -src.s_tone), ICON_SUBTRACT)
			src.lying_icon.Blend(rgb(-src.s_tone,  -src.s_tone,  -src.s_tone), ICON_SUBTRACT)

		if (src.underwear > 0)
			src.stand_icon.Blend(new /icon('human.dmi', "underwear[src.underwear]_[g]_s"), ICON_OVERLAY)
			src.lying_icon.Blend(new /icon('human.dmi', "underwear[src.underwear]_[g]_l"), ICON_OVERLAY)

/mob/living/carbon/human/proc/hasPart(var/part)
	switch(part)
		if("arm_left")
			return src.organ_manager.l_arm
		if("arm_right")
			return src.organ_manager.r_arm
		if("hand_left")
			return src.organ_manager.l_hand
		if("hand_right")
			return src.organ_manager.r_hand
		if("leg_left")
			return src.organ_manager.l_leg
		if("leg_right")
			return src.organ_manager.r_leg
		if("foot_left")
			return src.organ_manager.l_foot
		if("foot_right")
			return src.organ_manager.r_foot
		else
			return src.organ_manager.head
	return

/mob/living/carbon/human/proc/removePart(var/part)

	if(!src.mutantrace == "zombie" && src.mutantrace)
		src << "\red Your mutant powers prevent a limb being blown off."
		return

	if(!src.sleeping)
		src << "\red The pain feels too intense!"
		src.emote(pick("twitch", "faint", "collapse", "scream"))

	switch(part)
		if("arm_left")
			if(src.organ_manager.l_arm != 1)
				return
			src.organ_manager.l_arm = 0
			src.organ_manager.l_hand = 0

			src.l_armbloodloss = 1
			if(src.hand)
				src.drop_item()
			else
				src.hand = !(src.hand)
				src.drop_item()
				src.hand = !(src.hand) //Cheating here, so what?
			if(src.changeling_level >= 1)
				var/obj/critter/thething/L = new(src.loc)
				L.infectedby = src.key
				L.absorbed_dna = src.absorbed_dna
				L.olddna = src.dna
				L.oldname = "[src.name]"
				L.name = "[src.real_name]'s left arm"
				L.icon_state = "l_arm"
				step_rand(L)
			else
				if(mutantrace == "zombie")
					var/obj/item/weapon/organ/limb/L = new(src.loc)
					src.icon = getSkin(new/icon('zombie_dismemberment.dmi', "l_arm"))
					L.name = "[src.real_name]'s left arm"
					L.icon = 'zombie_dismemberment.dmi'
					L.icon_state = "l_arm"
					step_rand(L)
				else
					var/obj/item/weapon/organ/limb/L = new(src.loc)
					src.icon = getSkin(new/icon('human_dismemberment.dmi', "l_arm"))
					L.name = "[src.real_name]'s left arm"
					L.icon_state = "l_arm"
					step_rand(L)


		if("arm_right")
			if(src.organ_manager.r_arm != 1)
				return
			src.organ_manager.r_arm = 0
			src.organ_manager.r_hand = 0
			src.r_armbloodloss = 1
			if(!src.hand)
				src.drop_item()
			else
				src.hand = !(src.hand)
				src.drop_item()
				src.hand = !(src.hand)

			if(src.changeling_level >= 1)
				var/obj/critter/thething/L = new(src.loc)
				L.infectedby = src.key
				L.absorbed_dna = src.absorbed_dna
				L.olddna = src.dna
				L.oldname = "[src.name]"
				L.name = "[src.real_name]'s right arm"
				L.icon_state = "r_arm"
				step_rand(L)
			else
				if(mutantrace == "zombie")
					var/obj/item/weapon/organ/limb/L = new(src.loc)
					src.icon = getSkin(new/icon('zombie_dismemberment.dmi', "r_arm"))
					L.name = "[src.real_name]'s right arm"
					L.icon = 'zombie_dismemberment.dmi'
					L.icon_state = "r_arm"
					step_rand(L)
				else
					var/obj/item/weapon/organ/limb/L = new(src.loc)
					src.icon = getSkin(new/icon('human_dismemberment.dmi', "r_arm"))
					L.name = "[src.real_name]'s right arm"
					L.icon_state = "r_arm"
					step_rand(L)

		if("hand_left")
			if(src.organ_manager.l_hand != 1)
				return
			src.l_hand.clean_blood()
			src.organ_manager.l_hand = 0
			//src.l_handbloodloss = 1
			if(src.hand)
				src.drop_item()
			else
				src.hand = !(src.hand)
				src.drop_item()
				src.hand = !(src.hand)

		if("hand_right")
			if(src.organ_manager.r_hand != 1)
				return
			src.r_hand.clean_blood()
			src.organ_manager.r_hand = 0
			//src.r_handbloodloss = 1
			if(!src.hand)
				src.drop_item()
			else
				src.hand = !(src.hand)
				src.drop_item()
				src.hand = !(src.hand)

		if("leg_left")
			if(src.organ_manager.l_leg != 1)
				return
			src.organ_manager.l_leg = 0
			src.organ_manager.l_foot = 0
			src.l_legbloodloss = 1
			if(src.changeling_level >= 1)
				var/obj/critter/thething/L = new(src.loc)
				L.infectedby = src.key
				L.absorbed_dna = src.absorbed_dna
				L.olddna = src.dna
				L.oldname = "[src.name]"
				L.name = "[src.real_name]'s left leg"
				L.icon_state = "l_leg"
				step_rand(L)
			else
				if(mutantrace == "zombie")
					var/obj/item/weapon/organ/limb/L = new(src.loc)
					src.icon = getSkin(new/icon('zombie_dismemberment.dmi', "l_leg"))
					L.name = "[src.real_name]'s left leg"
					L.icon_state = "l_leg"
					L.icon = 'zombie_dismemberment.dmi'
					step_rand(L)
				else
					var/obj/item/weapon/organ/limb/L = new(src.loc)
					src.icon = getSkin(new/icon('human_dismemberment.dmi', "l_leg"))
					L.name = "[src.real_name]'s left leg"
					L.icon_state = "l_leg"
					step_rand(L)
		if("leg_right")
			if(src.organ_manager.r_leg != 1)
				return
			src.organ_manager.r_leg = 0
			src.organ_manager.r_foot= 0
			src.r_legbloodloss = 1
			if(src.changeling_level >= 1)
				var/obj/critter/thething/L = new(src.loc)
				L.infectedby = src.key
				L.absorbed_dna = src.absorbed_dna
				L.olddna = src.dna
				L.oldname = "[src.name]"
				L.name = "[src.real_name]'s right leg"
				L.icon_state = "r_leg"
				step_rand(L)
			else
				if(mutantrace == "zombie")

					var/obj/item/weapon/organ/limb/L = new(src.loc)
					src.icon = getSkin(new/icon('zombie_dismemberment.dmi', "r_leg"))
					L.name = "[src.real_name]'s right leg"
					L.icon_state = "r_leg"
					L.icon = 'zombie_dismemberment.dmi'
					step_rand(L)

				else

					var/obj/item/weapon/organ/limb/L = new(src.loc)
					src.icon = getSkin(new/icon('human_dismemberment.dmi', "r_leg"))
					L.name = "[src.real_name]'s right leg"
					L.icon_state = "r_leg"
					step_rand(L)

		if("foot_left")
			if(src.organ_manager.l_foot != 1)
				return
			src.organ_manager.l_foot = 0
			//src.l_footbloodloss = 1

		if("foot_right")
			if(src.organ_manager.r_foot != 1)
				return
			src.organ_manager.r_foot = 0
			//src.r_footbloodloss = 1

		else if(src.organ_manager.head)
			src.organ_manager.head = 0
			src.headbloodloss = 1
			if(src.changeling_level >= 1)
				var/obj/critter/thething/H = new(src.loc)
				H.infectedby = src.key
				H.absorbed_dna = src.absorbed_dna
				H.olddna = src.dna
				H.oldname = "[src.name]"
				H.icon_state = "head"
				H.name = "[src.real_name]'s head"
				//For gore man, for gore
				src.hair_icon_state = "bald"
				src.face_icon_state = "bald"
				src.update_body()
				src.update_face()
				step_rand(H) //Heh
			else
				var/obj/item/weapon/organ/head/H = new(src.loc)
				H.icon = src.getHeadIcon()
				H.name = "[src.real_name]'s head"
				//For gore man, for gore
				src.hair_icon_state = "bald"
				src.face_icon_state = "bald"
				src.update_body()
				src.update_face()

				if(src.ears)
					var/obj/O = src.ears
					src.u_equip(src.ears)
					if (src.client)
						src.client.screen -= src.ears
					if (src.ears)
						src.ears.loc = src.loc
						src.ears.dropped(src)
						src.ears.layer = initial(src.layer)
					O.loc = H

				if(src.glasses)
					var/t1 = src.glasses.icon_state
					src.overlays += image("icon" = 'eyes.dmi', "icon_state" = text("[][]", t1, "2"), "layer" = MOB_LAYER)
					var/obj/O = src.glasses
					src.u_equip(src.glasses)
					if (src.client)
						src.client.screen -= src.glasses
					if (src.glasses)
						src.glasses.loc = src.loc
						src.glasses.dropped(src)
						src.glasses.layer = initial(src.layer)
					O.loc = H

				if(src.wear_mask)
					var/t1 = src.wear_mask.icon_state
					H.overlays += image("icon" = 'mask.dmi', "icon_state" = text("[][]", t1, "2"), "layer" = MOB_LAYER)
					var/obj/O = src.wear_mask
					src.u_equip(src.wear_mask)
					if (src.client)
						src.client.screen -= src.wear_mask
					if (src.wear_mask)
						src.wear_mask.loc = src.loc
						src.wear_mask.dropped(src)
						src.wear_mask.layer = initial(src.layer)
					O.loc = H

				if(src.head)
					var/t1 = src.head.icon_state
					var/icon/head_icon
					head_icon = icon('head.dmi', text("[][]", t1, "2"))
					H.overlays += image("icon" = head_icon, "layer" = MOB_LAYER)
					var/obj/O = src.head
					src.u_equip(src.head)
					if (src.client)
						src.client.screen -= src.head
					if (src.head)
						src.head.loc = src.loc
						src.head.dropped(src)
						src.head.layer = initial(src.layer)
					O.loc = H
				step_rand(H) //Heh
	step_rand(new/obj/decal/cleanable/blood/splatter(src.loc))
	step_rand(new/obj/decal/cleanable/blood/splatter(src.loc))
	src.remove_items()
	src.update_body()
	src.update_face()
	src.update_clothing()
	return

/mob/living/carbon/human/proc/remove_items()
	if(!src.organ_manager.l_hand && !src.organ_manager.r_hand)
		if(src.gloves)
			src.u_equip(src.gloves)
			if (src.client)
				src.client.screen -= src.gloves
			if (src.gloves)
				src.gloves.loc = src.loc
				src.gloves.dropped(src)
				src.gloves.layer = initial(src.layer)
	if(!src.organ_manager.l_foot && !src.organ_manager.r_foot)
		if(src.shoes)
			src.u_equip(src.shoes)
			if (src.client)
				src.client.screen -= src.shoes
			if (src.shoes)
				src.shoes.loc = src.loc
				src.shoes.dropped(src)
				src.shoes.layer = initial(src.layer)
	return

/mob/living/carbon/human/proc/getHeadIcon()
	var/g = "m"
	if (src.gender == MALE)
		g = "m"
	else if (src.gender == FEMALE)
		g = "f"
	if(mutantrace == "zombie")
		var/icon/head = getSkin(new/icon("icon" = 'zombie_dismemberment.dmi', "icon_state" = "head_l"))

		var/icon/eyes_l = new/icon("icon" = 'human_face.dmi', "icon_state" = "eyes_l")
		eyes_l.Blend(rgb(src.r_eyes, src.g_eyes, src.b_eyes), ICON_ADD)

		var/icon/hair_l = new/icon("icon" = 'human_face.dmi', "icon_state" = "[src.hair_icon_state]_l")
		hair_l.Blend(rgb(src.r_hair, src.g_hair, src.b_hair), ICON_ADD)

		var/icon/facial_l = new/icon("icon" = 'human_face.dmi', "icon_state" = "[src.face_icon_state]_l")
		facial_l.Blend(rgb(src.r_facial, src.g_facial, src.b_facial), ICON_ADD)

		var/icon/mouth_l = new/icon("icon" = 'human_face.dmi', "icon_state" = "mouth_[g]_l")
		var/icon/gore_l = new/icon("icon" = 'zombie_dismemberment.dmi', "icon_state" = "head")
		head.Blend(eyes_l, ICON_OVERLAY)
		head.Blend(hair_l, ICON_OVERLAY)
		head.Blend(facial_l, ICON_OVERLAY)
		head.Blend(mouth_l, ICON_OVERLAY)
		head.Blend(gore_l, ICON_OVERLAY)

		del(facial_l)
		del(hair_l)
		del(eyes_l)
		del(mouth_l)
		del(gore_l)
		return head

	else
		var/icon/head = getSkin(new/icon("icon" = 'human_dismemberment.dmi', "icon_state" = "head_l"))

		var/icon/eyes_l = new/icon("icon" = 'human_face.dmi', "icon_state" = "eyes_l")
		eyes_l.Blend(rgb(src.r_eyes, src.g_eyes, src.b_eyes), ICON_ADD)

		var/icon/hair_l = new/icon("icon" = 'human_face.dmi', "icon_state" = "[src.hair_icon_state]_l")
		hair_l.Blend(rgb(src.r_hair, src.g_hair, src.b_hair), ICON_ADD)

		var/icon/facial_l = new/icon("icon" = 'human_face.dmi', "icon_state" = "[src.face_icon_state]_l")
		facial_l.Blend(rgb(src.r_facial, src.g_facial, src.b_facial), ICON_ADD)

		var/icon/mouth_l = new/icon("icon" = 'human_face.dmi', "icon_state" = "mouth_[g]_l")
		var/icon/gore_l = new/icon("icon" = 'human_dismemberment.dmi', "icon_state" = "head")

		head.Blend(eyes_l, ICON_OVERLAY)
		head.Blend(hair_l, ICON_OVERLAY)
		head.Blend(facial_l, ICON_OVERLAY)
		head.Blend(mouth_l, ICON_OVERLAY)
		head.Blend(gore_l, ICON_OVERLAY)

		del(facial_l)
		del(hair_l)
		del(eyes_l)
		del(mouth_l)
		del(gore_l)
		return head

/mob/living/carbon/human/proc/addRoboPart(var/part)

	if(src.mutantrace)
		src << "\red Your mutant powers prevent a limb being blown off."
		return

	switch(part)

		if("arm_left")
			src.organ_manager.l_arm = 2
			src.organ_manager.l_hand = 2

		if("arm_right")
			src.organ_manager.r_arm = 2
			src.organ_manager.r_hand = 2

		if("leg_left")
			src.organ_manager.l_leg = 2
			src.organ_manager.l_foot = 2

		if("leg_right")
			src.organ_manager.r_leg = 2
			src.organ_manager.r_foot = 2

	src.update_body()
	src.update_face()
	src.update_clothing()
	if(src.hud_used) src.hud_used.human_hud()
	return

/mob/living/carbon/human/proc/getSkin(var/icon/I)
	if (src.s_tone >= 0)
		I.Blend(rgb(src.s_tone, src.s_tone, src.s_tone), ICON_ADD)
		return I
	I.Blend(rgb(-src.s_tone,  -src.s_tone,  -src.s_tone), ICON_SUBTRACT)
	return I

/obj/item/weapon/organ/icon = 'human_dismemberment.dmi'

/obj/item/weapon/organ/head
	name = "head"
	desc = "Gristly ..."

	verb/removeItems()
		set name = "Remove Items"
		set src in oview(1)
		if (istype(usr, /mob/dead/observer))
			usr << "\red You're a ghost. You don't need items. They don't even fit."
			return // fuck off
		if(!isturf(src.loc))
			return
		for(var/image/I in overlays)
			del(I)
		for(var/obj/I in src)
			I.loc = get_turf(src.loc)
		return

/obj/item/weapon/organ/limb
	name = "limb"