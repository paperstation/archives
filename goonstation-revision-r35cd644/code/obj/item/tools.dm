/*
CONTAINS:
CROWBAR
WIRECUTTERS
WRENCH
SCREWDRIVER
WELDINGTOOL
MATERIAL COLLECTOR
*/

// CROWBAR
/obj/item/crowbar
	name = "crowbar"
	icon = 'icons/obj/items.dmi'
	icon_state = "crowbar"
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 5.0
	throwforce = 7.0
	item_state = "wrench"
	w_class = 2.0
	m_amt = 50
	desc = "A tool used as a lever to pry objects."
	stamina_damage = 33
	stamina_cost = 25
	stamina_crit_chance = 10
	module_research = list("tools" = 4, "metals" = 2)
	rand_pos = 1

/obj/item/crowbar/vr
	icon = 'icons/effects/VR.dmi'

// WIRECUTTERS
/obj/item/wirecutters
	name = "wirecutters"
	desc = "A tool used to cut wires and bars of metal."
	icon = 'icons/obj/items.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	icon_state = "cutters"
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 6.0
	throw_speed = 2
	throw_range = 9
	w_class = 2.0
	hit_type = DAMAGE_STAB
	hitsound = 'sound/effects/bloody_stab.ogg'
	m_amt = 80
	stamina_damage = 5
	stamina_cost = 10
	stamina_crit_chance = 30
	module_research = list("tools" = 4, "metals" = 1)
	rand_pos = 1

	attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
		if (!src.remove_bandage(M, user))
			return ..()

	attack_self(mob/user as mob)
		var/fuckup_chance = 8
		if (!iscarbon(user))
			return
		if (user.bioHolder.HasEffect("clumsy"))
			fuckup_chance = 33
		if (iscluwne(user))
			fuckup_chance = 100

		if (prob(fuckup_chance))
			user.visible_message("<span style=\"color:red\"><b>[user.name]</b> accidentally cuts [himself_or_herself(user)] while fooling around with [src] and drops them!</span>")
			playsound(src.loc, "sound/effects/bloody_stab.ogg", 50, 1, -6)
			user.TakeDamage(user.zone_sel.selecting, 3, 0)
			take_bleeding_damage(user, user, 3, DAMAGE_CUT)
			user.drop_item() // Damn message spam.
			return
		else
			user.visible_message("<b>[user.name]</b> snips [src].")
			playsound(src.loc, "sound/items/Wirecutter.ogg", 50, 1, -6)
			sleep(3)
			playsound(src.loc, "sound/items/Wirecutter.ogg", 50, 1, -6)
		return

/obj/item/wirecutters/vr
	icon = 'icons/effects/VR.dmi'

// WRENCH
/obj/item/wrench
	name = "wrench"
	icon = 'icons/obj/items.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	icon_state = "wrench"
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 5.0
	throwforce = 7.0
	w_class = 2.0
	m_amt = 150
	desc = "A tool used to apply torque to turn nuts and bolts."
	stamina_damage = 25
	stamina_cost = 20
	stamina_crit_chance = 15
	module_research = list("tools" = 4, "metals" = 2)
	rand_pos = 1

/obj/item/wrench/monkey
	icon_state = "monkey_wrench"
	name = "monkey wrench"
	desc = "What the FUCK is that thing???"
	module_research = list("tools" = 8)

/obj/item/wrench/vr
	icon = 'icons/effects/VR.dmi'

// SCREWDRIVER
/obj/item/screwdriver
	name = "screwdriver"
	icon = 'icons/obj/items.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	icon_state = "screwdriver"
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 5.0
	w_class = 1.0
	hit_type = DAMAGE_STAB
	hitsound = 'sound/effects/bloody_stab.ogg'
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	desc = "A tool used to turn slotted screws and other slotted objects."
	stamina_damage = 10
	stamina_cost = 10
	stamina_crit_chance = 30
	module_research = list("tools" = 4, "metals" = 1)
	rand_pos = 1

/obj/item/screwdriver/suicide(var/mob/user as mob)
	user.visible_message("<span style=\"color:red\"><b>[user] jams the screwdriver into \his eye over and over and over.</b></span>")
	take_bleeding_damage(user, null, 25, DAMAGE_STAB)
	user.TakeDamage("head", 160, 0)
	user.updatehealth()
	spawn(100)
		if (user)
			user.suiciding = 0
	return 1

/obj/item/screwdriver/vr
	icon = 'icons/effects/VR.dmi'

// WELDING TOOL
/obj/item/weldingtool
	name = "weldingtool"
	icon = 'icons/obj/items.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	icon_state = "welder"
	var/welding = 0.0
	var/status = 0	//flamethrower construction :shobon:
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	m_amt = 30
	g_amt = 30
	desc = "A tool that, when turned on, uses fuel to emit a concentrated flame, welding metal together or slicing it apart."
	stamina_damage = 30
	stamina_cost = 30
	stamina_crit_chance = 5
	module_research = list("tools" = 4, "metals" = 1, "fuels" = 5)
	rand_pos = 1

/obj/item/weldingtool/New()
	var/datum/reagents/R = new/datum/reagents(20)
	reagents = R
	R.my_atom = src
	R.add_reagent("fuel", 20)
	return

/obj/item/weldingtool/examine()
	set src in usr
	set category = "Local"
	boutput(usr, "[bicon(src)] [src.name] contains [get_fuel()] units of fuel left!")
	return

/obj/item/weldingtool/attackby(obj/item/W as obj, mob/user as mob)
	if (status == 0 && istype(W,/obj/item/screwdriver))
		status = 1
		boutput(user, "<span style=\"color:blue\">The welder can now be attached and modified.</span>")
	else if (status == 1 && istype(W,/obj/item/rods))
		if (src.loc != user)
			boutput(user, "<span style=\"color:red\">You need to be holding [src] to work on it!</span>")
			return
		var/obj/item/rods/R = new /obj/item/rods
		R.amount = 1

		var/obj/item/rods/S = W
		S.amount = S.amount - 1
		if (S.amount == 0)
			qdel(S)
		var/obj/item/assembly/weld_rod/F = new /obj/item/assembly/weld_rod( user )
		src.set_loc(F)
		F.part1 = src
		user.u_equip(src)
		user.put_in_hand_or_drop(F)
		R.master = F
		src.master = F
		src.layer = initial(src.layer)
		user.u_equip(src)
		src.set_loc(F)
		F.part2 = R
		src.add_fingerprint(user)
	else if (status == 1 && istype(W,/obj/item/screwdriver))
		status = 0
		boutput(user, "<span style=\"color:blue\">You resecure the welder.</span>")
		return

// helper functions for weldingtool fuel use

// return fuel amount
/obj/item/weldingtool/proc/get_fuel()
	return reagents.get_reagent_amount("fuel")

// remove fuel amount
/obj/item/weldingtool/proc/use_fuel(var/amount)
	amount = min( get_fuel() , amount)
	reagents.remove_reagent("fuel", amount)
	return

/obj/item/weldingtool/afterattack(obj/O as obj, mob/user as mob)
	if (istype(O, /obj/reagent_dispensers/fueltank) && get_dist(src,O) <= 1)
		O.reagents.trans_to(src, 20)
		boutput(user, "<span style=\"color:blue\">Welder refueled</span>")
		playsound(src.loc, "sound/effects/zzzt.ogg", 50, 1, -6)

	else if (src.welding)
		use_fuel(1)
		if (get_fuel() <= 0)
			boutput(usr, "<span style=\"color:blue\">Need more fuel!</span>")
			src.welding = 0
			src.force = 3
			src.damtype = "brute"
			src.icon_state = "welder"
			user.update_inhands()
		var/turf/location = user.loc

		if (istype(location, /turf))
			location.hotspot_expose(700, 50, 1)

		if (!ismob(O) && O.reagents)
			boutput(usr, "<span style=\"color:blue\">You heat \the [O.name]</span>")
			O.reagents.temperature_reagents(2500,10)
	return


/obj/item/weldingtool/proc/eyecheck(mob/user as mob)
	if(user.isBlindImmune())
		return
	//check eye protection
	var/safety = 0

	if (ishuman(user))
/*	L:head:up broke for no reason so I had to rewrite it.
		if (istype(L:head, /obj/item/clothing/head/helmet/welding))
			if(!L:head:up)
				safety = 8*/
		var/mob/living/carbon/human/newuser = user
		if (istype(newuser.glasses, /obj/item/clothing/glasses/thermal) || newuser.eye_istype(/obj/item/organ/eye/cyber/thermal)) // we wanna check for the thermals first so having a polarized eye doesn't protect you if you also have a thermal eye
			safety = -1
		else if (istype(newuser.head, /obj/item/clothing/head/helmet/welding))
			if(!newuser.head:up)
				safety = 2
			else
				safety = 0
		else if (istype(newuser.head, /obj/item/clothing/head/helmet/space))
			safety = 2
		else if (istype(newuser.glasses, /obj/item/clothing/glasses/sunglasses) || newuser.eye_istype(/obj/item/organ/eye/cyber/sunglass))
			safety = 1
		else
			safety = 0
	switch(safety)
		if(1)
			boutput(usr, "<span style=\"color:red\">Your eyes sting a little.</span>")
			user.take_eye_damage(rand(1, 2))
		if(0)
			boutput(usr, "<span style=\"color:red\">Your eyes burn.</span>")
			user.take_eye_damage(rand(2, 4))
		if(-1)
			boutput(usr, "<span style=\"color:red\"><b>Your thermals intensify the welder's glow. Your eyes itch and burn severely.</b></span>")
			user.change_eye_blurry(rand(12,20))
			user.take_eye_damage(rand(12, 16))

/obj/item/weldingtool/attack_self(mob/user as mob)
	if(status > 1)	return
	src.welding = !( src.welding )
	if (src.welding)
		if (get_fuel() <= 0)
			boutput(user, "<span style=\"color:blue\">Need more fuel!</span>")
			src.welding = 0
			return 0
		boutput(user, "<span style=\"color:blue\">You will now weld when you attack.</span>")
		src.force = 15
		src.damtype = "fire"
		src.icon_state = "welder1"
		if (!(src in processing_items))
			processing_items.Add(src)
	else
		boutput(user, "<span style=\"color:blue\">Not welding anymore.</span>")
		src.force = 3
		src.damtype = "brute"
		src.icon_state = "welder"
	user.update_inhands()
	return

/obj/item/weldingtool/process()
	if(!welding)
		processing_items.Remove(src)
		return

	var/turf/location = src.loc
	if(istype(location, /mob/))
		var/mob/M = location
		if(M.l_hand == src || M.r_hand == src)
			location = M.loc

	if (istype(location, /turf))
		location.hotspot_expose(700, 5)

	if (prob(20))
		use_fuel(1)
		if (!get_fuel())
			welding = 0
			force = 3
			damtype = "brute"
			src.icon_state = "welder"
			processing_items.Remove(src)
			return

/obj/item/weldingtool/blob_act(var/power)
	if (prob(power * 0.5))
		qdel(src)

/obj/item/weldingtool/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 1000)
		return ..()
	return

/obj/item/weldingtool/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if (!src.welding)
		if (!src.cautery_surgery(M, user, 0, src.welding))
			return ..()

	if (!istype(M, /mob))
		return

	src.add_fingerprint(user)

	if (ishuman(M))

		var/mob/living/carbon/human/H = M

		if (H.bleeding || (H.butt_op_stage == 4 && user.zone_sel.selecting == "chest"))
			if (!src.cautery_surgery(H, user, 15, src.welding))
				return ..()

		else if (user.zone_sel.selecting != "chest" && user.zone_sel.selecting != "head")
			if (!H.limbs.vars[user.zone_sel.selecting])
				switch (user.zone_sel.selecting)
					if ("l_arm")
						if (H.limbs.l_arm_bleed) cauterise("l_arm")
						else
							boutput(user, "<span style=\"color:red\">[H.name]'s left arm stump is not bleeding!</span>")
							return
					if ("r_arm")
						if (H.limbs.r_arm_bleed) cauterise("r_arm")
						else
							boutput(user, "<span style=\"color:red\">[H.name]'s right arm stump is not bleeding!</span>")
							return
					if ("l_leg")
						if (H.limbs.l_leg_bleed) cauterise("l_leg")
						else
							boutput(user, "<span style=\"color:red\">[H.name]'s left leg stump is not bleeding!</span>")
							return
					if ("r_leg")
						if (H.limbs.r_leg_bleed) cauterise("r_leg")
						else
							boutput(user, "<span style=\"color:red\">[H.name]'s right leg stump is not bleeding!</span>")
							return
					else return ..()

			else
				if (!(locate(/obj/machinery/optable, M.loc) && M.lying) && !(locate(/obj/table, M.loc) && (M.paralysis || M.stat)) && !(M.reagents && M.reagents.get_reagent_amount("ethanol") > 10 && M == user))
					return ..()

				if (istype(H.limbs.l_leg,/obj/item/parts/robot_parts/leg/treads)) attach_robopart("treads")
				else
					switch (user.zone_sel.selecting)
						if ("l_arm")
							if (istype(H.limbs.l_arm,/obj/item/parts/robot_parts) && H.limbs.l_arm.remove_stage > 0) attach_robopart("l_arm")
							else
								boutput(user, "<span style=\"color:red\">[H.name]'s left arm doesn't need welding on!</span>")
								return
						if ("r_arm")
							if (istype(H.limbs.r_arm,/obj/item/parts/robot_parts) && H.limbs.r_arm.remove_stage > 0) attach_robopart("r_arm")
							else
								boutput(user, "<span style=\"color:red\">[H.name]'s right arm doesn't need welding on!</span>")
								return
						if ("l_leg")
							if (istype(H.limbs.l_leg,/obj/item/parts/robot_parts) && H.limbs.l_leg.remove_stage > 0) attach_robopart("l_leg")
							else
								boutput(user, "<span style=\"color:red\">[H.name]'s left leg doesn't need welding on!</span>")
								return
						if ("r_leg")
							if(istype(H.limbs.r_leg,/obj/item/parts/robot_parts) && H.limbs.r_leg.remove_stage > 0) attach_robopart("r_leg")
							else
								boutput(user, "<span style=\"color:red\">[H.name]'s right leg doesn't need welding on!</span>")
								return
						else return ..()
		else return ..()

/obj/item/weldingtool/proc/cauterise(mob/living/carbon/human/H as mob, mob/living/carbon/user as mob, var/part)
	if(!istype(H)) return
	if(!istype(user)) return
	if(!part) return

	var/variant = H.bioHolder.HasEffect("lost_[part]")
	if(!variant) return

	if (get_fuel() < 5)
		boutput(user, "<span style=\"color:blue\">You need more welding fuel to complete this task.</span>")
		return
	use_fuel(5)
	playsound(src.loc, "sound/items/Welder.ogg", 100, 1)
	eyecheck(user)

	H.TakeDamage("chest",0,20)
	if(prob(50)) H.emote("scream")

	variant = max(1,variant-20)
	H.bioHolder.RemoveEffect("lost_[part]")
	H.bioHolder.AddEffect("lost_[part]",variant)

	for(var/mob/O in AIviewers(H, null))
		if(O == (user || H))
			continue
		if(H == user)
			O.show_message("<span style=\"color:red\">[user.name] cauterises their own stump with [src]!</span>", 1)
		else
			O.show_message("<span style=\"color:red\">[H.name] has their stump cauterised by [user.name] with [src].</span>", 1)

	if(H != user)
		boutput(H, "<span style=\"color:red\">[user.name] cauterises your stump with [src].</span>")
		boutput(user, "<span style=\"color:red\">You cauterise [H.name]'s stump with [src].</span>")
	else
		boutput(user, "<span style=\"color:red\">You cauterise your own stump with [src].</span>")

	return

/obj/item/weldingtool/proc/attach_robopart(mob/living/carbon/human/H as mob, mob/living/carbon/user as mob, var/part)
	if(!istype(H)) return
	if(!istype(user)) return
	if(!part) return

	if(!H.bioHolder.HasEffect("loose_robot_[part]")) return

	if (get_fuel() < 5)
		boutput(user, "<span style=\"color:blue\">You need more welding fuel to complete this task.</span>")
		return
	use_fuel(5)
	playsound(src.loc, "sound/items/Welder.ogg", 100, 1)
	eyecheck(user)

	H.TakeDamage("chest",0,20)
	if(prob(50)) H.emote("scream")
	user.visible_message("<span style=\"color:red\">[user.name] welds [H.name]'s robotic part to their stump with [src].</span>", "<span style=\"color:red\">You weld [H.name]'s robotic part to their stump with [src].</span>")

	H.bioHolder.RemoveEffect("loose_robot_[part]")

	return

/obj/item/weldingtool/vr
	icon = 'icons/effects/VR.dmi'
