/obj/item/parts/human_parts
	name = "human parts"
	icon = 'icons/obj/human_parts.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	item_state = "buildpipe"
	flags = FPRINT | ONBELT | TABLEPASS | CONDUCT
	var/skin_tone = 25
	var/mob/living/original_holder = null
	stamina_damage = 30
	stamina_cost = 15
	stamina_crit_chance = 5
	skintoned = 1
	module_research = list("medicine" = 1)
	module_research_type = /obj/item/parts/human_parts

	take_damage(brute, burn, tox, damage_type, disallow_limb_loss)
		if (brute <= 0 && burn <= 0)// && tox <= 0)
			return 0

		src.brute_dam += brute
		src.burn_dam += burn
		//src.tox_dam += tox

		if (ishuman(holder))
			var/mob/living/carbon/human/H = holder
			H.hit_twitch()
			H.UpdateDamage()
			if (brute > 30 && prob(brute - 30) && !disallow_limb_loss)
				src.sever()
			else if (bone_system && src.bones && brute && prob(brute * 2))
				src.bones.take_damage(damage_type)
		return 1

	heal_damage(brute, burn, tox)
		if (brute_dam <= 0 && burn_dam <= 0 && tox_dam <= 0)
			return 0
		src.brute_dam = max(0, src.brute_dam - brute)
		src.burn_dam = max(0, src.burn_dam - burn)
		src.tox_dam = max(0, src.tox_dam - tox)
		return 1

	get_damage()
		return src.brute_dam + src.burn_dam	+ src.tox_dam

	attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
		if(!ismob(M))
			return

		src.add_fingerprint(user)

		if(user.zone_sel.selecting != slot || !ishuman(M))
			return ..()

		if(!(locate(/obj/machinery/optable, M.loc) && M.lying) && !(locate(/obj/table, M.loc) && (M.paralysis || M.stat)) && !(M.reagents && M.reagents.get_reagent_amount("ethanol") > 10 && M == user))
			return ..()

		var/mob/living/carbon/human/H = M

		if(H.limbs.vars[src.slot])
			boutput(user, "<span style=\"color:red\">[H.name] already has one of those!</span>")
			return

		attach(H,user)

		return
/*
	proc/set_skin_tone()
		skin_tone = holder.bioHolder.mobAppearance.s_tone
		var/icon/newicon = icon(src.icon, src.icon_state)
		if(skin_tone >= 0) newicon.Blend(rgb(skin_tone, skin_tone, skin_tone), ICON_ADD)
		else newicon.Blend(rgb(-skin_tone,  -skin_tone,  -skin_tone), ICON_SUBTRACT)
		src.icon = newicon
		return
*/
	New(mob/new_holder)
		..()
		holder = new_holder
		original_holder = new_holder
		src.bones = new /datum/bone(src)
		src.bones.donor = new_holder
		src.bones.parent_organ = "[src.name]"
		spawn(20)
			if (new_holder && istype(new_holder))
				name = "[new_holder.real_name]'s [initial(name)]"

		set_skin_tone()

	proc/set_skin_tone()
		if (!skintoned)
			return
		if (holder && ismob(holder) && holder.bioHolder && holder.bioHolder.mobAppearance)
			skin_tone = holder.bioHolder.mobAppearance.s_tone

		var/newrgb = rgb(skin_tone + 220, skin_tone + 220, skin_tone + 220)
		if (src.lyingImage)
			src.lyingImage.color = newrgb
		if (src.standImage)
			src.standImage.color = newrgb

	getMobIcon(var/lying)
		. = ..()
		if (skintoned)
			var/newrgb = rgb(skin_tone + 220, skin_tone + 220, skin_tone + 220)
			if (src.lyingImage)
				src.lyingImage.color = newrgb
			if (src.standImage)
				src.standImage.color = newrgb

	surgery(var/obj/item/tool)
		if(remove_stage > 1 && tool.type == /obj/item/staple_gun)
			remove_stage = 0

		else if(remove_stage == 0 || remove_stage == 2)
			if(istype(tool, /obj/item/scalpel) || istype(tool, /obj/item/raw_material/shard) || istype(tool, /obj/item/kitchen/utensil/knife) || istype(tool, /obj/item/knife_butcher) || istype(tool,/obj/item/razor_blade))
				remove_stage++
			else
				return 0

		else if(remove_stage == 1)
			if(istype(tool, /obj/item/circular_saw) || istype(tool, /obj/item/saw))
				remove_stage++
			else
				return 0

		switch(remove_stage)
			if(0)
				tool.the_mob.visible_message("<span style=\"color:red\">[tool.the_mob] staples [holder.name]'s [src.name] securely to their stump with [tool].</span>", "<span style=\"color:red\">You staple [holder.name]'s [src.name] securely to their stump with [tool].</span>")
				logTheThing("combat", tool.the_mob, holder, "staples %target%'s [src.name] back on")
				logTheThing("diary", tool.the_mob, holder, "staples %target%'s [src.name] back on", "combat")
			if(1)
				tool.the_mob.visible_message("<span style=\"color:red\">[tool.the_mob] slices through the skin and flesh of [holder.name]'s [src.name] with [tool].</span>", "<span style=\"color:red\">You slice through the skin and flesh of [holder.name]'s [src.name] with [tool].</span>")
			if(2)
				tool.the_mob.visible_message("<span style=\"color:red\">[tool.the_mob] saws through the bone of [holder.name]'s [src.name] with [tool].</span>", "<span style=\"color:red\">You saw through the bone of [holder.name]'s [src.name] with [tool].</span>")

				spawn(rand(150,200))
					if(remove_stage == 2)
						src.remove(0)
			if(3)
				tool.the_mob.visible_message("<span style=\"color:red\">[tool.the_mob] cuts through the remaining strips of skin holding [holder.name]'s [src.name] on with [tool].</span>", "<span style=\"color:red\">You cut through the remaining strips of skin holding [holder.name]'s [src.name] on with [tool].</span>")
				logTheThing("combat", tool.the_mob, holder, "removes %target%'s [src.name]")
				logTheThing("diary", tool.the_mob, holder, "removes %target%'s [src.name]", "combat")
				src.remove(0)

		if(holder.stat != 2)
			if(prob(40))
				holder.emote("scream")
		holder.TakeDamage("chest",20,0)
		take_bleeding_damage(holder, null, 15, DAMAGE_STAB)

		return 1

/obj/item/parts/human_parts/arm
	name = "placeholder item (don't use this!)"
	desc = "A human arm."
	override_attack_hand = 0 //to hit with an item instead of hand when used empty handed
	can_hold_items = 1

/obj/item/parts/human_parts/arm/left
	name = "left arm"
	icon_state = "arm_left"
	slot = "l_arm"
	handlistPart = "hand_left"

/obj/item/parts/human_parts/arm/right
	name = "right arm"
	icon_state = "arm_right"
	slot = "r_arm"
	side = "right"
	handlistPart = "hand_right"

/obj/item/parts/human_parts/leg
	name = "placeholder item (don't use this!)"
	desc = "A human leg."

/obj/item/parts/human_parts/leg/left
	name = "left leg"
	icon_state = "leg_left"
	slot = "l_leg"
	partlistPart = "foot_left"

/obj/item/parts/human_parts/leg/right
	name = "right leg"
	icon_state = "leg_right"
	slot = "r_leg"
	side = "right"
	partlistPart = "foot_right"
/*
/obj/item/parts/human_parts/arm/left/synth
	name = "synthetic left arm"
	desc = "A left arm. Looks like a rope composed of flesh coloured vines. And tofu??"

/obj/item/parts/human_parts/arm/right/synth
	name = "synthetic right arm"
	desc = "A right arm. Looks like a rope composed of flesh coloured vines."

/obj/item/parts/human_parts/leg/left/synth
	name = "synthetic left leg"
	desc = "A left leg. Looks like a rope composed of flesh coloured vines."

/obj/item/parts/human_parts/leg/right/synth
	name = "synthetic right leg"
	desc = "A right leg. Looks like a rope composed of flesh coloured vines."
*/
//gimmick parts

#define ORIGINAL_FLAGS_CANT_DROP 1
#define ORIGINAL_FLAGS_CANT_SELF_REMOVE 2
#define ORIGINAL_FLAGS_CANT_OTHER_REMOVE 4

/obj/item/parts/human_parts/arm/left/item
	name = "left item arm"
	decomp_affected = 0
	limb_type = /datum/limb/item
	streak_decal = /obj/decal/cleanable/oil // what streaks everywhere when it's cut off?
	streak_descriptor = "oily" //bloody, oily, etc
	override_attack_hand = 1
	can_hold_items = 0
	remove_object = null
	handlistPart = null
	partlistPart = null
	no_icon = 1
	var/original_flags = 0

	New(new_holder, var/obj/item/I)
		..()
		if (I)
			src.set_item(I)

	set_loc(var/newloc)
		..()
		if (!ismob(loc))
			return
		var/ret = null
		if (!istype(newloc, /mob))
			if (remove_object)
				remove_object.set_loc(newloc)
				ret = remove_object
			src.loc = null
			if (!disposed)
				qdel(src)
		else
			ret = src
		return ret


	proc/set_item(var/obj/item/I)
		var/mob/living/carbon/human/H = null
		if (ishuman(src.holder))
			H = src.holder
		else if (ishuman(src.loc))
			H = src.loc
		if (H)
			H.l_hand = I
			if (istype(I))
				I.pickup(H)
			I.add_fingerprint(H)
			I.layer = HUD_LAYER+2
			I.screen_loc = ui_lhand
			if (H.client)
				H.client.screen += I
			H.update_inhands()

		name = "left [I.name] arm"
		remove_object = I//I.type
		I.set_loc(src)
		if (istype(I))
			if(I.over_clothes) handlistPart += "l_arm_[I.arm_icon]"
			else partlistPart += "l_arm_[I.arm_icon]"
			override_attack_hand = I.override_attack_hand
			can_hold_items = I.can_hold_items

			if (I.cant_drop)
				original_flags |= ORIGINAL_FLAGS_CANT_DROP
			if (I.cant_self_remove)
				original_flags |= ORIGINAL_FLAGS_CANT_SELF_REMOVE
			if (I.cant_other_remove)
				original_flags |= ORIGINAL_FLAGS_CANT_OTHER_REMOVE

			I.cant_drop = 1
			I.cant_self_remove = 1
			I.cant_other_remove = 1

	proc/remove_from_mob(delete = 0)
		if (istype(remove_object, /obj/item))
			remove_object.cant_drop = (original_flags & ORIGINAL_FLAGS_CANT_DROP) ? 1 : 0
			remove_object.cant_self_remove = (original_flags & ORIGINAL_FLAGS_CANT_SELF_REMOVE) ? 1 : 0
			remove_object.cant_other_remove = (original_flags & ORIGINAL_FLAGS_CANT_OTHER_REMOVE) ? 1 : 0
		if (src.holder)
			src.holder.u_equip(remove_object)
		if (delete && remove_object)
			qdel(remove_object)


	remove(var/show_message = 1)
		remove_from_mob(0)
		..()

	sever()
		remove_from_mob(0)
		..()

	dispose()
		remove_from_mob(1)
		..()

/obj/item/parts/human_parts/arm/right/item
	name = "right item arm"
	decomp_affected = 0
	limb_type = /datum/limb/item
	streak_decal = /obj/decal/cleanable/oil // what streaks everywhere when it's cut off?
	streak_descriptor = "oily" //bloody, oily, etc
	override_attack_hand = 1
	can_hold_items = 0
	remove_object = null
	handlistPart = null
	partlistPart = null
	no_icon = 1
	var/original_flags = 0

	New(new_holder, var/obj/item/I)
		..()
		if (I)
			src.set_item(I)

	proc/set_item(var/obj/item/I)
		var/mob/living/carbon/human/H = null
		if (ishuman(src.holder))
			H = src.holder
		else if (ishuman(src.loc))
			H = src.loc
		if (H)
			H.r_hand = I
			if (istype(I))
				I.pickup(H)
			I.add_fingerprint(H)
			I.layer = HUD_LAYER+2
			I.screen_loc = ui_rhand
			if (H.client)
				H.client.screen += I
			H.update_inhands()

		name = "right [I.name] arm"
		remove_object = I//.type
		I.set_loc(src)
		if (istype(I))
			if(I.over_clothes) handlistPart += "r_arm_[I.arm_icon]"
			else partlistPart += "r_arm_[I.arm_icon]"
			override_attack_hand = I.override_attack_hand
			can_hold_items = I.can_hold_items

			if (I.cant_drop)
				original_flags |= ORIGINAL_FLAGS_CANT_DROP
			if (I.cant_self_remove)
				original_flags |= ORIGINAL_FLAGS_CANT_SELF_REMOVE
			if (I.cant_other_remove)
				original_flags |= ORIGINAL_FLAGS_CANT_OTHER_REMOVE

			I.cant_drop = 1
			I.cant_self_remove = 1
			I.cant_other_remove = 1

	proc/remove_from_mob(delete = 0)
		if (istype(remove_object, /obj/item))
			remove_object.cant_drop = (original_flags & ORIGINAL_FLAGS_CANT_DROP) ? 1 : 0
			remove_object.cant_self_remove = (original_flags & ORIGINAL_FLAGS_CANT_SELF_REMOVE) ? 1 : 0
			remove_object.cant_other_remove = (original_flags & ORIGINAL_FLAGS_CANT_OTHER_REMOVE) ? 1 : 0
		if (src.holder)
			src.holder.u_equip(remove_object)
		if (delete && remove_object)
			qdel(remove_object)


	remove(var/show_message = 1)
		remove_from_mob(0)
		..()

	sever()
		remove_from_mob(0)
		..()

	dispose()
		remove_from_mob(1)
		..()

/obj/item/parts/human_parts/arm/left/wendigo
	name = "left wendigo arm"
	icon_state = "arm_left_wendigo"
	slot = "l_arm"
	side = "left"
	decomp_affected = 0
	streak_descriptor = "eerie"
	override_attack_hand = 1
	limb_type = /datum/limb/wendigo
	handlistPart = "l_hand_wendigo"

	New(var/atom/holder)
		if (holder != null)
			set_loc(holder)
		..()

	getMobIcon(var/lying, var/decomp_stage = 0)
		if (src.standImage && ((src.decomp_affected && src.current_decomp_stage_s == decomp_stage) || !src.decomp_affected))
			return src.standImage
		current_decomp_stage_s = decomp_stage
		src.standImage = image('icons/mob/human.dmi', "[src.slot]_wendigo")
		return standImage

/obj/item/parts/human_parts/arm/right/wendigo
	name = "right wendigo arm"
	icon_state = "arm_right_wendigo"
	slot = "r_arm"
	side = "right"
	decomp_affected = 0
	streak_descriptor = "eerie"
	override_attack_hand = 1
	limb_type = /datum/limb/wendigo
	handlistPart = "r_hand_wendigo"

	New(var/atom/holder)
		if (holder != null)
			set_loc(holder)
		..()

	getMobIcon(var/lying, var/decomp_stage = 0)
		if (src.standImage && ((src.decomp_affected && src.current_decomp_stage_s == decomp_stage) || !src.decomp_affected))
			return src.standImage
		current_decomp_stage_s = decomp_stage
		src.standImage = image('icons/mob/human.dmi', "[src.slot]_wendigo")
		return standImage

/obj/item/parts/human_parts/arm/left/bear
	name = "left bear arm"
	desc = "Dear god it's still wiggling."
	icon_state = "arm_left_bear"
	slot = "l_arm"
	side = "left"
	decomp_affected = 0
	skintoned = 1
	streak_descriptor = "bearly"
	override_attack_hand = 1
	limb_type = /datum/limb/bear
	handlistPart = "l_hand_bear"

	New(var/atom/holder)
		if (holder != null)
			set_loc(holder)
		..()

	getMobIcon(var/lying, var/decomp_stage = 0)
		set_skin_tone()
		if (src.standImage && ((src.decomp_affected && src.current_decomp_stage_s == decomp_stage) || !src.decomp_affected))
			return src.standImage
		current_decomp_stage_s = decomp_stage
		src.standImage = image('icons/mob/human.dmi', "[src.slot]_bear")
		return standImage

/obj/item/parts/human_parts/arm/right/bear
	name = "right bear arm"
	desc = "Dear god it's still wiggling."
	icon_state = "arm_right_bear"
	slot = "r_arm"
	side = "right"
	decomp_affected = 0
	skintoned = 1
	streak_descriptor = "bearly"
	override_attack_hand = 1
	limb_type = /datum/limb/bear
	handlistPart = "r_hand_bear"

	New(var/atom/holder)
		if (holder != null)
			set_loc(holder)
		..()

	getMobIcon(var/lying, var/decomp_stage = 0)
		set_skin_tone()
		if (src.standImage && ((src.decomp_affected && src.current_decomp_stage_s == decomp_stage) || !src.decomp_affected))
			return src.standImage
		current_decomp_stage_s = decomp_stage
		src.standImage = image('icons/mob/human.dmi', "[src.slot]_bear")
		return standImage

/obj/item/parts/human_parts/arm/left/synth
	name = "synthetic left arm"
	desc = "A left arm. Looks like a rope composed of vines. And tofu??"
	icon_state = "arm_left_plant"
	slot = "l_arm"
	side = "left"
	decomp_affected = 0
	handlistPart = "l_hand_plant"
	var/name_thing = "plant"

	New(var/atom/holder)
		if (holder != null)
			set_loc(holder)
		..()

	getMobIcon(var/lying, var/decomp_stage = 0)
		if (src.standImage && ((src.decomp_affected && src.current_decomp_stage_s == decomp_stage) || !src.decomp_affected))
			return src.standImage
		current_decomp_stage_s = decomp_stage
		src.standImage = image('icons/mob/human.dmi', "[src.slot]_[name_thing]")
		return standImage

/obj/item/parts/human_parts/arm/right/synth
	name = "synthetic right arm"
	desc = "A right arm. Looks like a rope composed of vines. And tofu??"
	icon_state = "arm_right_plant"
	slot = "r_arm"
	side = "right"
	decomp_affected = 0
	handlistPart = "r_hand_plant"
	var/name_thing = "plant"

	New(var/atom/holder)
		if (holder != null)
			set_loc(holder)
		..()

	getMobIcon(var/lying, var/decomp_stage = 0)
		if (src.standImage && ((src.decomp_affected && src.current_decomp_stage_s == decomp_stage) || !src.decomp_affected))
			return src.standImage
		current_decomp_stage_s = decomp_stage
		src.standImage = image('icons/mob/human.dmi', "[src.slot]_[name_thing]")
		return standImage

/obj/item/parts/human_parts/leg/left/synth
	name = "synthetic left leg"
	desc = "A left leg. Looks like a rope composed of vines. And tofu??"
	icon_state = "leg_left_plant"
	slot = "l_leg"
	side = "left"
	decomp_affected = 0
	partlistPart = "l_foot_plant"
	var/name_thing = "plant"

	New(var/atom/holder)
		if (holder != null)
			set_loc(holder)
		..()

	getMobIcon(var/lying, var/decomp_stage = 0)
		if (src.standImage && ((src.decomp_affected && src.current_decomp_stage_s == decomp_stage) || !src.decomp_affected))
			return src.standImage
		current_decomp_stage_s = decomp_stage
		src.standImage = image('icons/mob/human.dmi', "[src.slot]_[name_thing]")
		return standImage

/obj/item/parts/human_parts/leg/right/synth
	name = "synthetic right leg"
	desc = "A right leg. Looks like a rope composed of vines. And tofu??"
	icon_state = "leg_right_plant"
	slot = "r_leg"
	side = "right"
	decomp_affected = 0
	partlistPart = "r_foot_plant"
	var/name_thing = "plant"

	New(var/atom/holder)
		if (holder != null)
			set_loc(holder)
		..()

	getMobIcon(var/lying, var/decomp_stage = 0)
		if (src.standImage && ((src.decomp_affected && src.current_decomp_stage_s == decomp_stage) || !src.decomp_affected))
			return src.standImage
		current_decomp_stage_s = decomp_stage
		src.standImage = image('icons/mob/human.dmi', "[src.slot]_[name_thing]")
		return standImage


/obj/item/parts/human_parts/arm/left/synth/bloom
	desc = "A left arm. Looks like a rope composed of vines. There's some little flowers on it."
	icon_state = "arm_left_plant_bloom"
	handlistPart = "l_hand_plant"
	name_thing = "plant_bloom"

/obj/item/parts/human_parts/arm/right/synth/bloom
	desc = "A right arm. Looks like a rope composed of vines. There's some little flowers on it."
	icon_state = "arm_right_plant_bloom"
	handlistPart = "r_hand_plant"
	name_thing = "plant_bloom"

/obj/item/parts/human_parts/leg/left/synth/bloom
	desc = "A left leg. Looks like a rope composed of vines. There's some little flowers on it."
	icon_state = "leg_left_plant_bloom"
	partlistPart = "l_foot_plant"
	name_thing = "plant_bloom"

/obj/item/parts/human_parts/leg/right/synth/bloom
	desc = "A right leg. Looks like a rope composed of vines. There's some little flowers on it."
	icon_state = "leg_right_plant_bloom"
	partlistPart = "r_foot_plant"
	name_thing = "plant_bloom"

// Added shambler, werewolf and predator arms, including the sprites (Convair880).
/obj/item/parts/human_parts/arm/left/abomination
	name = "left chitinous tendril"
	desc = "Some sort of alien tendril with very sharp edges. Seems to be moving on its own..."
	icon_state = "arm_left_abomination"
	slot = "l_arm"
	side = "left"
	decomp_affected = 0
	skintoned = 0
	override_attack_hand = 1
	limb_type = /datum/limb/abomination
	handlistPart = "l_hand_abomination"

	New(var/atom/holder)
		if (holder != null)
			set_loc(holder)
		..()

	getMobIcon(var/lying, var/decomp_stage = 0)
		if (src.standImage && ((src.decomp_affected && src.current_decomp_stage_s == decomp_stage) || !src.decomp_affected))
			return src.standImage
		current_decomp_stage_s = decomp_stage
		src.standImage = image('icons/mob/human.dmi', "[src.slot]_abomination")
		return standImage

/obj/item/parts/human_parts/arm/right/abomination
	name = "right chitinous tendril"
	desc = "Some sort of alien tendril with very sharp edges. Seems to be moving on its own..."
	icon_state = "arm_right_abomination"
	slot = "r_arm"
	side = "right"
	decomp_affected = 0
	skintoned = 0
	override_attack_hand = 1
	limb_type = /datum/limb/abomination
	handlistPart = "r_hand_abomination"

	New(var/atom/holder)
		if (holder != null)
			set_loc(holder)
		..()

	getMobIcon(var/lying, var/decomp_stage = 0)
		if (src.standImage && ((src.decomp_affected && src.current_decomp_stage_s == decomp_stage) || !src.decomp_affected))
			return src.standImage
		current_decomp_stage_s = decomp_stage
		src.standImage = image('icons/mob/human.dmi', "[src.slot]_abomination")
		return standImage

/obj/item/parts/human_parts/arm/left/werewolf
	name = "left werewolf arm"
	desc = "Huh, lots of fur and very sharp claws."
	icon_state = "arm_left_werewolf"
	slot = "l_arm"
	side = "left"
	decomp_affected = 0
	skintoned = 0
	override_attack_hand = 1
	limb_type = /datum/limb/abomination/werewolf
	handlistPart = "l_hand_werewolf"

	New(var/atom/holder)
		if (holder != null)
			set_loc(holder)
		..()

	getMobIcon(var/lying, var/decomp_stage = 0)
		if (src.standImage && ((src.decomp_affected && src.current_decomp_stage_s == decomp_stage) || !src.decomp_affected))
			return src.standImage
		current_decomp_stage_s = decomp_stage
		src.standImage = image('icons/mob/human.dmi', "[src.slot]_werewolf")
		return standImage

/obj/item/parts/human_parts/arm/right/werewolf
	name = "right werewolf arm"
	desc = "Huh, lots of fur and very sharp claws."
	icon_state = "arm_right_werewolf"
	slot = "r_arm"
	side = "right"
	decomp_affected = 0
	skintoned = 0
	override_attack_hand = 1
	limb_type = /datum/limb/abomination/werewolf
	handlistPart = "r_hand_werewolf"

	New(var/atom/holder)
		if (holder != null)
			set_loc(holder)
		..()

	getMobIcon(var/lying, var/decomp_stage = 0)
		if (src.standImage && ((src.decomp_affected && src.current_decomp_stage_s == decomp_stage) || !src.decomp_affected))
			return src.standImage
		current_decomp_stage_s = decomp_stage
		src.standImage = image('icons/mob/human.dmi', "[src.slot]_werewolf")
		return standImage

/obj/item/parts/human_parts/arm/left/predator
	name = "left predator arm"
	desc = "A muscular and strong arm."
	icon_state = "arm_left_predator"
	slot = "l_arm"
	side = "left"
	decomp_affected = 0
	skintoned = 0
	override_attack_hand = 1
	limb_type = /datum/limb/predator
	handlistPart = "l_hand_predator"

	New(var/atom/holder)
		if (holder != null)
			set_loc(holder)
		..()

	getMobIcon(var/lying, var/decomp_stage = 0)
		if (src.standImage && ((src.decomp_affected && src.current_decomp_stage_s == decomp_stage) || !src.decomp_affected))
			return src.standImage
		current_decomp_stage_s = decomp_stage
		src.standImage = image('icons/mob/human.dmi', "[src.slot]_predator")
		return standImage

/obj/item/parts/human_parts/arm/right/predator
	name = "right predator arm"
	desc = "A muscular and strong arm."
	icon_state = "arm_right_predator"
	slot = "r_arm"
	side = "right"
	decomp_affected = 0
	skintoned = 0
	override_attack_hand = 1
	limb_type = /datum/limb/predator
	handlistPart = "r_hand_predator"

	New(var/atom/holder)
		if (holder != null)
			set_loc(holder)
		..()

	getMobIcon(var/lying, var/decomp_stage = 0)
		if (src.standImage && ((src.decomp_affected && src.current_decomp_stage_s == decomp_stage) || !src.decomp_affected))
			return src.standImage
		current_decomp_stage_s = decomp_stage
		src.standImage = image('icons/mob/human.dmi', "[src.slot]_predator")
		return standImage