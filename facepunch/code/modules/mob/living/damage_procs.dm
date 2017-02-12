
/*
	apply_damage(a,b,c)
	args
	a:damage - How much damage to take
	b:damage_type - What type of damage to take, brute, burn
	c:def_zone - Where to take the damage if its brute or burn
	d:resistance - how much armor or something reduced the damage
	Returns
	standard 0 if no damage was done
*/
/*
/mob/living/proc/apply_damage(var/damage = 0,var/damagetype = BRUTE, var/def_zone = null, var/resistance = 1)
	if(!damage || (resistance <= 0))	return 0
	damage = damage*resistance
	switch(damagetype)
		if(BRUTE)
			adjustBruteLoss(damage)
		if(BURN)
			if(TEMPATURE_RESIST in mutations)	damage = 0
			adjustFireLoss(damage)
		if(TOX)
			adjustToxLoss(damage)
		if(OXY)
			adjustOxyLoss(damage)
		if(CLONE)
			adjustCloneLoss(damage)
		if(HALLOSS)
			adjustHalLoss(damage)
	updatehealth()
	return 1


//Call this if you want it to run the armor check
/mob/living/proc/deal_damage(var/damage = 0, var/damagetype = BRUTE, var/attack_flag = "melee", var/def_zone = null)
	if(!damage) return 0
	return apply_damage(damage, damagetype, def_zone, run_armor_check(def_zone, attack_flag, null))


//Allows you to apply several damages by using one proc
//Resistance might not calc properly here
/mob/living/proc/apply_damages(var/brute = 0, var/burn = 0, var/tox = 0, var/oxy = 0, var/clone = 0, var/def_zone = null, var/resistance = 1, var/halloss = 0)
	if(resistance <= 0)	return 0
	if(brute)	apply_damage(brute, BRUTE, def_zone, resistance)
	if(burn)	apply_damage(burn, BURN, def_zone, resistance)
	if(tox)		apply_damage(tox, TOX, def_zone, resistance)
	if(oxy)		apply_damage(oxy, OXY, def_zone, resistance)
	if(clone)	apply_damage(clone, CLONE, def_zone, resistance)
	if(halloss) apply_damage(halloss, HALLOSS, def_zone, resistance)
	return 1


/mob/living/proc/apply_effect(var/effect = 0,var/effecttype = STUN, var/resistance = 1)
	if(!effect || (resistance <= 0))	return 0
	effect = effect*resistance
	switch(effecttype)
		if(STUN)
			Stun(effect)
		if(WEAKEN)
			Weaken(effect)
		if(PARALYZE)
			Paralyse(effect)
		if(IRRADIATE)
			radiation += max(effect)
		if(STUTTER)
			if(status_flags & CANSTUN) // stun is usually associated with stutter
				stuttering = max(stuttering, effect)
		if(EYE_BLUR)
			eye_blurry = max(eye_blurry, effect)
		if(DROWSY)
			drowsyness = max(drowsyness, effect)
	updatehealth()
	return 1


/mob/living/proc/apply_effects(var/stun = 0, var/weaken = 0, var/paralyze = 0, var/irradiate = 0, var/stutter = 0, var/eyeblur = 0, var/drowsy = 0, var/resistance = 1)
	if(resistance <= 0)	return 0
	if(stun)		apply_effect(stun, STUN, resistance)
	if(weaken)		apply_effect(weaken, WEAKEN, resistance)
	if(paralyze)	apply_effect(paralyze, PARALYZE, resistance)
	if(irradiate)	apply_effect(irradiate, IRRADIATE, resistance)
	if(stutter)		apply_effect(stutter, STUTTER, resistance)
	if(eyeblur)		apply_effect(eyeblur, EYE_BLUR, resistance)
	if(drowsy)		apply_effect(drowsy, DROWSY, resistance)
	return 1
*/