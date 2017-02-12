////////////////// MISC BULLSHIT //////////////////

/mob/proc/fake_damage(var/amount,var/seconds)
	if (!amount || !seconds)
		return

	src.fakeloss += amount

	spawn(seconds * 10)
		src.fakeloss -= amount

/mob/proc/false_death(var/seconds)
	if (!seconds)
		return

	src.fakedead = 1
	boutput(src, "<B>[src]</B> seizes up and falls limp, [his_or_her(src)] eyes dead and lifeless...")
	src.weakened = 5

	spawn(seconds * 10)
		src.fakedead = 0
		src.weakened = 0

/proc/get_mobs_of_type_at_point_blank(var/atom/object,var/mob_path)
	var/list/returning_list = list()
	if (!object || !mob_path)
		return returning_list

	if (istype(object,/area/))
		return returning_list

	for (var/mob/L in range(1,object))
		if (istype(L,mob_path))
			returning_list += L

	return returning_list

/proc/get_mobs_of_type_in_view(var/atom/object,var/mob_path)
	var/list/returning_list = list()
	if (!object || !mob_path)
		return returning_list

	if (istype(object,/area/))
		return returning_list

	for (var/mob/L in view(7,object))
		if (istype(L,mob_path))
			returning_list += L

	return returning_list

/mob/proc/get_current_active_item()
	return null

/mob/living/carbon/human/get_current_active_item()
	if (src.hand)
		return src.r_hand
	else
		return src.l_hand

/mob/living/silicon/robot/get_current_active_item()
	return src.module_active

/mob/proc/get_temp_deviation()
	var/tempdiff = src.bodytemperature - src.base_body_temp
	var/tol = src.temp_tolerance
	var/ntl = 0 - src.temp_tolerance // these are just to make the switch a bit easier to look at

	if (tempdiff > tol*4)
		return 4 // some like to be on fire
	else if (tempdiff < ntl*4)
		return -4 // i think my ears just froze off oh god
	else if (tempdiff > tol*3)
		return 3 // some like it too hot
	else if (tempdiff < ntl*3)
		return -3 // too chill
	else if (tempdiff > tol*2)
		return 2 // some like it hot
	else if (tempdiff < ntl*2)
		return -2 // pretty chill
	else if (tempdiff > tol*1)
		return 1 // some like it warm
	else if (tempdiff < ntl*1)
		return -1 // a little bit chill
	else
		return 0 // I'M APOLLO JUSTICE AND I'M FINE

/mob/proc/is_cold_resistant()
	if (!src)
		return 0
	if(src.bioHolder && src.bioHolder.HasOneOfTheseEffects("cold_resist","thermal_resist"))
		return 1
	if(src.get_ability_holder(/datum/abilityHolder/changeling))
		return 1
	if(src.nodamage)
		return 1
	return 0

/mob/proc/is_heat_resistant()
	if (!src)
		return 0
	if(src.bioHolder && src.bioHolder.HasOneOfTheseEffects("fire_resist","thermal_resist"))
		return 1
	if(src.nodamage)
		return 1
	return 0

// Hallucinations

/mob/living/proc/hallucinate_fake_melee_attack()
	var/list/PB_mobs = get_mobs_of_type_at_point_blank(src,/mob/living/)
	var/mob/living/H = pick(PB_mobs)
	if (H.stat)
		return
	var/obj/item/I = H.get_current_active_item()

	if (istype(I))
		boutput(src, "<span style=\"color:red\"><b>[H.name] attacks [src.name] with [I]!</b></span>")
		if (I.hitsound)
			src.playsound_local(src.loc, I.hitsound, 50, 1)
		src.fake_damage(I.force,100)
	else
		if (!istype(H,/mob/living/carbon/human/))
			return
		if (!src.canmove)
			src.playsound_local(src.loc, 'sound/weapons/genhit1.ogg', 25, 1, -1)
			boutput(src, "<span style=\"color:red\"><B>[H.name] kicks [src.name]!</B></span>")
		else
			var/list/punches = list('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
			src.playsound_local(src.loc, pick(punches), 25, 1, -1)
			boutput(src, "<span style=\"color:red\"><B>[H.name] punches [src.name]!</B></span>")
		src.fake_damage(rand(2,9),100)
	src.hit_twitch()

///////////////
// Anomalies //
///////////////

/obj/anomaly
	name = "anomaly"
	desc = "swirly thing alert!!!!"
	icon = 'icons/obj/objects.dmi'
	icon_state = "anom"
	density = 1
	opacity = 0
	anchored = 1
	var/has_processing_loop = 0

	New()
		..()
		if (has_processing_loop)
			global.processing_items.Add(src)
		return 0

	proc/process()
		return 0

/obj/anomaly/test
	name = "boing anomaly"
	desc = "it goes boing and does stuff"
	has_processing_loop = 1

	process()
		playsound(src.loc, 'sound/effects/chanting.ogg', 100, 0, 5, 0.5)