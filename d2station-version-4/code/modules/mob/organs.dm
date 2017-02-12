/datum/organ/proc/process()
	return

/datum/organ/proc/receive_chem(chemical as obj)
	return

/datum/organ/proc/getType()
	if(istype(src, /datum/organ/external/chest))
		return "chest"
	if(istype(src, /datum/organ/external/groin))
		return "groin"
	if(istype(src, /datum/organ/external/r_hand))
		return "hand_right"
	if(istype(src, /datum/organ/external/l_hand))
		return "hand_left"
	if(istype(src, /datum/organ/external/r_arm))
		return "arm_right"
	if(istype(src, /datum/organ/external/l_arm))
		return "arm_left"
	if(istype(src, /datum/organ/external/r_leg))
		return "leg_right"
	if(istype(src, /datum/organ/external/l_leg))
		return "leg_left"
	if(istype(src, /datum/organ/external/r_foot))
		return "foot_right"
	if(istype(src, /datum/organ/external/l_foot))
		return "foot_left"
	if(istype(src, /datum/organ/external/head))
		return "head"
	return

/datum/organ/external/proc/take_damage(brute, burn)
	if (src.owner:nodamage) return
	if ((brute <= 0 && burn <= 0))
		return 0
	if ((src.brute_dam + src.burn_dam + brute + burn) < src.max_damage)
		src.brute_dam += brute
		src.burn_dam += burn
	else
		if(ishuman(owner))
			if(getType() == "chest" || getType() == "groin")
				src.owner:removePart(pick("hand_right", "hand_left", "arm_right", "arm_left", "leg_right", "leg_left", "foot_right", "foot_left", "head"))
		else
			src.owner:removePart(getType())
		var/can_inflict = src.max_damage - (src.brute_dam + src.burn_dam)
		if (can_inflict)
			if (brute > 0 && burn > 0)
				brute = can_inflict/2
				burn = can_inflict/2
				var/ratio = brute / (brute + burn)
				src.brute_dam += ratio * can_inflict
				src.burn_dam += (1 - ratio) * can_inflict
			else
				if (brute > 0)
					brute = can_inflict
					src.brute_dam += brute
				else
					burn = can_inflict
					src.burn_dam += burn
		else
			return 0

	var/result = src.update_icon()

	return result

/datum/organ/external/proc/heal_damage(brute, burn)
	src.brute_dam = max(0, src.brute_dam - brute)
	src.burn_dam = max(0, src.burn_dam - burn)
	return update_icon()

/datum/organ/external/proc/get_damage()	//returns total damage
	return src.brute_dam + src.burn_dam	//could use src.health?

// new damage icon system
// returns just the brute/burn damage code

/datum/organ/external/proc/damage_state_text()

	var/tburn = 0
	var/tbrute = 0

	if(burn_dam ==0)
		tburn =0
	else if (src.burn_dam < (src.max_damage * 0.25 / 2))
		tburn = 1
	else if (src.burn_dam < (src.max_damage * 0.75 / 2))
		tburn = 2
	else
		tburn = 3

	if (src.brute_dam == 0)
		tbrute = 0
	else if (src.brute_dam < (src.max_damage * 0.25 / 2))
		tbrute = 1
	else if (src.brute_dam < (src.max_damage * 0.75 / 2))
		tbrute = 2
	else
		tbrute = 3

	return "[tbrute][tburn]"

// new damage icon system
// adjusted to set damage_state to brute/burn code only (without r_name0 as before)

/datum/organ/external/proc/update_icon()

	var/n_is = src.damage_state_text()
	if (n_is != src.damage_state)
		src.damage_state = n_is
		return 1
	else
		return 0
	return
