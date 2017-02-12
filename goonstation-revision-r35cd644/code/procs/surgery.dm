// haine wuz heer
// I got rid of all the various message bullshit in here
// it's more organized and makes the code easier to read imo

// ~make procs 4 everything~
/proc/surgeryCheck(var/mob/living/carbon/human/patient as mob, var/mob/surgeon as mob)
	if (!patient) // did we not get passed a patient?
		return 0 // surgery is not okay
	if (!ishuman(patient)) // is the patient not a human?
		return 0 // surgery is not okay

	if (locate(/obj/machinery/optable, patient.loc) && patient.lying) // is the patient on an optable and lying?
		return 1 // surgery is okay
	else if (locate(/obj/stool/bed, patient.loc) && patient.lying) // is the patient on a bed and lying?
		return 1 // surgery is okay
	else if (locate(/obj/table, patient.loc) && (patient.paralysis || patient.stat)) // is the patient on a table and paralyzed or dead?
		return 1 // surgery is okay
	else if (patient.reagents && patient.reagents.get_reagent_amount("ethanol") > 100 && patient == surgeon) // is the patient really drunk and also the surgeon?
		return 1 // surgery is okay

	else // if all else fails?
		return 0 // surgery is not okay

/proc/headSurgeryCheck(var/mob/living/carbon/human/patient as mob)
	if (!patient) // did we not get passed a patient?
		return 0 // head surgery is not okay
	if (!ishuman(patient)) // is the patient not a human?
		return 0 // head surgery is not okay

	if (patient.head && patient.head.c_flags & COVERSEYES) // does the patient have a head, and on their head they have something covering their eyes?
		return 0 // head surgery is not okay
	else if (patient.wear_mask && patient.wear_mask.c_flags & COVERSEYES) // does the patient have a mask, and their mask covers their eyes?
		return 0 // head surgery is not okay
/*	else if (patient.glasses && patient.glasses.c_flags & COVERSEYES) // does the patient have glasses, and their glasses, uh, cover their eyes?
		return 0 // head surgery is not okay
*/
	else // if all else fails?
		return 1 // head surgery is okay

/obj/item/proc/surgeryConfusion(var/mob/living/carbon/human/patient as mob, var/mob/surgeon as mob, var/damage as num)
	if (!patient || !surgeon)
		return
	if (!ishuman(patient))
		return
	if (!damage)
		damage = rand(25,75)

	var/target_area = zone_sel2name[surgeon.zone_sel.selecting]

	if (prob(33)) // if they REALLY fuck up
		var/fluff = pick("", "confident ", "quick ", "agile ", "flamboyant ", "nimble ")
		patient.tri_message("<span style=\"color:red\"><b>[surgeon]</b> makes a [fluff]cut into [patient]'s [target_area] with [src]!</span>",\
		patient, "<span style=\"color:red\"><b>[surgeon]</b> makes a [fluff]cut into your [target_area] with [src]!</span>",\
		surgeon, "<span style=\"color:red\">You make a [fluff]cut into [patient]'s [target_area] with [src]!</span>")

		patient.TakeDamage(surgeon.zone_sel.selecting, damage, 0)
		take_bleeding_damage(patient, surgeon, damage)

		patient.visible_message("<span style=\"color:red\"><b>Blood gushes from the incision!</b> That can't have been the correct thing to do!</span>")
		return

	else
		var/fluff = pick("", "gently ", "carefully ", "lightly ", "trepidly ")
		var/fluff2 = pick("prod", "poke", "jab", "dig")
		var/fluff3 = pick("", " [he_or_she(surgeon)] looks [pick("confused", "unsure", "uncertain")][pick("", " about what [he_or_she(surgeon)]'s doing")].")
		patient.tri_message("<span style=\"color:red\"><b>[surgeon]</b> [fluff][fluff2]s at [patient]'s [target_area] with [src].[fluff3]</span>",\
		patient, "<span style=\"color:red\"><b>[surgeon]</b> [fluff][fluff2]s at your [target_area] with [src].[fluff3]</span>",\
		surgeon, "<span style=\"color:red\">You [fluff][fluff2] at [patient]'s [target_area] with [src].</span>")
		return

/proc/calc_screw_up_prob(var/mob/living/carbon/human/patient as mob, var/mob/surgeon as mob, var/screw_up_prob = 25)
	if (!patient) // did we not get passed a patient?
		return 0 // uhhh
	if (!ishuman(patient)) // is the patient not a human?
		return 0 // welp vOv

	if (surgeon.bioHolder.HasEffect("clumsy")) // is the surgeon clumsy?
		screw_up_prob += 35
	if (patient == surgeon) // is the patient doing self-surgery?
		screw_up_prob += 15
	if (patient.jitteriness) // is the patient all twitchy?
		screw_up_prob += 15
	if (surgeon.reagents)
		var/drunken_surgeon = surgeon.reagents.get_reagent_amount("ethanol") // has the surgeon had a drink (or two (or three (or four (etc))))?
		if (drunken_surgeon > 0 && drunken_surgeon < 50) // it steadies the hand a bit
			screw_up_prob -= 10
		else if (drunken_surgeon >= 50) // but too much and that might be bad
			screw_up_prob += 10

	if (patient.stat) // is the patient dead?
		screw_up_prob -= 30
	if (patient.paralysis) // unable to move?
		screw_up_prob -= 15
	if (patient.sleeping) // asleep?
		screw_up_prob -= 10
	if (patient.stunned) // stunned?
		screw_up_prob -= 5
	if (patient.drowsyness) // sleepy?
		screw_up_prob -= 5

	if (patient.reagents) // check for anesthetics/analgetics
		if (patient.reagents.get_reagent_amount("morphine") >= 10)
			screw_up_prob -= 10
		if (patient.reagents.get_reagent_amount("haloperidol") >= 10)
			screw_up_prob -= 10
		if (patient.reagents.get_reagent_amount("ethanol") >= 10)
			screw_up_prob -= 5
		if (patient.reagents.get_reagent_amount("salicylic_acid") >= 5)
			screw_up_prob -= 5
		if (patient.reagents.get_reagent_amount("antihistamine") >= 5)
			screw_up_prob -= 5

	if (surgeon.bioHolder.HasEffect("training_medical"))
		screw_up_prob = max(0, min(100, screw_up_prob)) // if they're a doctor they can have no chance to mess up
	else
		screw_up_prob = max(5, min(100, screw_up_prob)) // otherwise there'll always be a slight chance

	DEBUG("<b>[patient]'s surgery (performed by [surgeon]) has screw_up_prob set to [screw_up_prob]</b>")

	return screw_up_prob

/proc/calc_surgery_damage(var/mob/surgeon as mob, var/screw_up_prob = 25, var/damage = 10, var/adj1 = 0.5, adj2 = 200)
	damage = damage * (adj1 + (screw_up_prob / adj2))

	if (surgeon && surgeon.bioHolder.HasEffect("training_medical")) // doctor better trained and do less hurt
		damage = max(0, round(damage))
	else
		damage = max(2, round(damage))

	return damage

/obj/item/proc/remove_bandage(var/mob/living/carbon/human/H as mob, var/mob/user as mob)
	if (!H)
		return 0

	if (!ishuman(H))
		return 0

	if (user && user.a_intent != INTENT_HELP)
		return 0

	if (!islist(H.bandaged) || !H.bandaged.len)
		return 0

	var/removing = pick(H.bandaged)
	if (!removing) // ?????
		return 0

	H.tri_message("<span style=\"color:blue\"><b>[user]</b> begins removing [H == user ? "[his_or_her(H)]" : "[H]'s"] bandage.</span>",\
	user, "<span style=\"color:blue\">You begin removing [H == user ? "your" : "[H]'s"] bandage.</span>",\
	H, "<span style=\"color:blue\">[H == user ? "You begin" : "<b>[user]</b> begins"] removing your bandage.</span>")

	if (!do_mob(user, H, 50))
		user.show_text("You were interrupted!", "red")
		return 1

	H.tri_message("<span style=\"color:blue\"><b>[user]</b> removes [H == user ? "[his_or_her(H)]" : "[H]'s"] bandage.</span>",\
	user, "<span style=\"color:blue\">You remove [H == user ? "your" : "[H]'s"] bandage.</span>",\
	H, "<span style=\"color:blue\">[H == user ? "You remove" : "<b>[user]</b> removes"] your bandage.</span>")

	H.bandaged -= removing
	H.update_body()
	return 1

/mob/proc/get_surgery_status(var/zone)
	return 0

/mob/living/carbon/human/get_surgery_status(var/zone)
	if (!src.organHolder)
		DEBUG("get_surgery_status failed due to [src] having no organHolder")
		return 0

	var/datum/organHolder/oH = src.organHolder
	var/return_thing = 0

	if (!zone || zone == "head")
		if (oH.brain)
			return_thing += oH.brain.op_stage
		else
			return_thing ++

		if (oH.skull)
			return_thing += oH.skull.op_stage
		else
			return_thing ++

		if (oH.head)
			return_thing += oH.head.op_stage
		else
			return_thing ++

	if (!zone || zone == "chest")
		if (oH.heart)
			return_thing += oH.heart.op_stage
		else if (src.butt_op_stage < 5)
			return_thing += src.butt_op_stage

	if (!zone || zone in list("l_arm","r_arm","l_leg","r_leg"))
		var/obj/item/parts/surgery_limb = src.limbs.vars[zone]
		if (istype(surgery_limb))
			return_thing += surgery_limb.remove_stage
		else if (!surgery_limb)
			return_thing ++

	//DEBUG("get_surgery_status for [src] returning [return_thing]")
	return return_thing

/obj/item/proc/defibrillate(var/mob/living/carbon/human/patient as mob, var/mob/living/user as mob, var/emagged = 0, var/faulty = 0, var/obj/item/cell/cell = null)
	if (!ishuman(patient))
		return 0

	if (cell && cell.percent() <= 0)
		user.show_text("[src] doesn't have enough power in its cell!", "red")
		return 0

	var/shockcure = 0
	for (var/datum/ailment_data/V in patient.ailments)
		if (V.cure == "Electric Shock")
			shockcure = 1
			break

	if (emagged || (patient.health < 0 && !faulty) || (shockcure && !faulty) || (faulty && prob(25)))
		user.visible_message("<span style=\"color:blue\"><b>[user]</b> shocks [patient] with [src].</span>",\
		"<span style=\"color:blue\">You shock [patient] with [src].</span>")
		logTheThing("combat", patient, user, "was defibrillated by %target% with [src] [log_loc(patient)]")
		playsound(user.loc, "sound/weapons/Egloves.ogg", 75, 1)

		if (patient.bioHolder.HasEffect("resist_electric"))
			user.show_text("<b>[patient]</b> doesn't respond at all!", "red")
			patient.show_text("You resist the shock!", "blue")
			return 1

		else if (patient.stat == 2)
			user.show_text("<b>[patient]</b> doesn't respond at all!", "red")
			return 1

		else
			patient.Virus_ShockCure(100)
			var/sumdamage = patient.get_brute_damage() + patient.get_burn_damage() + patient.get_toxin_damage()
			if (patient.health < 0)
				if (sumdamage >= 90)
					user.show_text("<b>[patient]</b> looks horribly injured. Resuscitation alone may not help revive them.", "red")
				if (prob(66))
					user.show_text("<b>[patient]</b> inhales deeply!", "blue")
					patient.take_oxygen_deprivation(-50)
					patient.updatehealth()
				else
					user.show_text("<b>[patient]</b> doesn't respond!", "red")

			if (cell)
				var/adjust = cell.charge
				if (adjust <= 0) // bwuh??
					adjust = 1000 // fu
				patient.paralysis += min(0.001 * adjust, 5)
				patient.stunned += min(0.002 * adjust, 10)
				patient.weakened += min(0.002 * adjust, 10)
				patient.stuttering += min(0.005 * adjust, 25)
				DEBUG("[src]'s defibrillate(): adjust = [adjust], paralysis + [min(0.001 * adjust, 5)], stunned + [min(0.002 * adjust, 10)], weakened + [min(0.002 * adjust, 10)], stuttering + [min(0.005 * adjust, 25)]")

			else if (faulty)
				patient.paralysis += 1
				patient.stunned += 2
				patient.weakened += 2
				patient.stuttering += 5
			else
				patient.paralysis += 3
				patient.stunned += 5
				patient.weakened += 5
				patient.stuttering += 10
			patient.show_text("You feel a powerful jolt!", "red")
			patient.shock_cyberheart(100)

			if (cell)
				cell.zap(patient, 1)
				if (prob(25))
					cell.zap(user)
				cell.use(cell.charge)

			if (emagged && !faulty && prob(10))
				user.show_text("\The [src]'s on board scanner indicates that the target is undergoing a cardiac arrest!", "red")
				patient.contract_disease(/datum/ailment/disease/flatline, null, null, 1) // path, name, strain, bypass resist
			return 1

	else
		if (faulty)
			user.show_text("\The [src] doesn't discharge!", "red")
		else
			user.show_text("\The [src]'s on board medical scanner indicates that no shock is required!", "red")
		return 0

/* ============================= */
/* ---------- SCALPEL ---------- */
/* ============================= */

/obj/item/proc/scalpel_surgery(var/mob/living/carbon/human/patient as mob, var/mob/living/surgeon as mob)
	if (!ishuman(patient))
		return 0

	if (!patient.organHolder)
		return 0

	if (surgeon.bioHolder.HasEffect("clumsy") && prob(50))
		surgeon.visible_message("<span style=\"color:red\"><b>[surgeon]</b> fumbles and stabs [him_or_her(surgeon)]self in the eye with [src]!</span>", \
		"<span style=\"color:red\">You fumble and stab yourself in the eye with [src]!</span>")
		surgeon.bioHolder.AddEffect("blind")
		surgeon.weakened += 4
		var/damage = rand(5, 15)
		random_brute_damage(surgeon, damage)
		take_bleeding_damage(surgeon, null, damage)
		return 1

	src.add_fingerprint(surgeon)

	if (!surgeryCheck(patient, surgeon))
		return 0

	// fluff2 is for things that do more damage: nicking an artery is included in the choices
	var/fluff = pick(" messes up", "'s hand slips", " fumbles with [src]", " nearly drops [src]", "'s hand twitches", " makes a really messy cut")
	var/fluff2 = pick(" messes up", "'s hand slips", " fumbles with [src]", " nearly drops [src]", "'s hand twitches", " makes a really messy cut", " nicks an artery")

	var/screw_up_prob = calc_screw_up_prob(patient, surgeon)

	var/damage_low = calc_surgery_damage(surgeon, screw_up_prob, rand(5,15)/*, src.adj1, src.adj2*/)
	var/damage_high = calc_surgery_damage(surgeon, screw_up_prob, rand(15,25)/*, src.adj1, src.adj2*/)

	DEBUG("<b>[patient]'s surgery (performed by [surgeon]) damage_low is [damage_low], damage_high is [damage_high]</b>")

/* ---------- SCALPEL - HEAD ---------- */

	if (surgeon.zone_sel.selecting == "head")
		if (!headSurgeryCheck(patient))
			surgeon.show_text("You're going to need to remove that mask/helmet/glasses first.", "blue")
			return 1

		if (surgeon.a_intent == INTENT_HARM && patient.organHolder.head)
			if (patient.organHolder.head.op_stage == 0.0)
				playsound(get_turf(patient), "sound/weapons/squishcut.ogg", 50, 1)

				if (prob(screw_up_prob))
					surgeon.visible_message("<span style=\"color:red\"><b>[surgeon][fluff]!</b></span>")
					patient.TakeDamage("head", damage_low, 0)
					take_bleeding_damage(patient, surgeon, damage_low)
					return 1

				patient.tri_message("<span style=\"color:red\"><b>[surgeon]</b> cuts the skin of [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] neck open with [src]!</span>",\
				surgeon, "<span style=\"color:red\">You cut the skin of [surgeon == patient ? "your" : "[patient]'s"] neck open with [src]!</span>", \
				patient, "<span style=\"color:red\">[patient == surgeon ? "You cut" : "<b>[surgeon]</b> cuts"] the skin of your neck open with [src]!</span>")

				patient.TakeDamage("head", damage_low, 0)
				if (!surgeon.find_type_in_hand(/obj/item/hemostat))
					take_bleeding_damage(patient, surgeon, damage_low)
				else
					surgeon.show_text("You clamp the bleeders with the hemostat.", "blue")
				patient.updatehealth()
				patient.organHolder.head.op_stage = 1.0
				return 1

			else if (patient.organHolder.head.op_stage == 2.0)
				playsound(get_turf(patient), "sound/weapons/squishcut.ogg", 50, 1)

				if (prob(screw_up_prob))
					surgeon.visible_message("<span style=\"color:red\"><b>[surgeon][fluff2]!</b></span>")
					patient.TakeDamage("head", damage_high, 0)
					take_bleeding_damage(patient, surgeon, damage_high)
					return 1

				patient.tri_message("<span style=\"color:red\"><b>[surgeon]</b> slices the tissue around [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] spine with [src]!</span>",\
				surgeon, "<span style=\"color:red\">You slice the tissue around [surgeon == patient ? "your" : "[patient]'s"] spine with [src]!</span>",\
				patient, "<span style=\"color:red\">[patient == surgeon ? "You slice" : "<b>[surgeon]</b> slices"] the tissue around your spine with [src]!</span>")

				patient.TakeDamage("head", damage_high, 0)
				if (!surgeon.find_type_in_hand(/obj/item/hemostat))
					take_bleeding_damage(patient, surgeon, damage_low)
				else
					surgeon.show_text("You clamp the bleeders with the hemostat.", "blue")
				patient.updatehealth()
				patient.organHolder.head.op_stage = 3.0
				return 1

		else if (patient.organHolder.right_eye && patient.organHolder.right_eye.op_stage == 1.0 && surgeon.find_in_hand(src) == surgeon.r_hand)
			playsound(get_turf(patient), "sound/weapons/squishcut.ogg", 50, 1)

			if (prob(screw_up_prob))
				surgeon.visible_message("<span style=\"color:red\"><b>[surgeon][fluff]!</b></span>")
				patient.TakeDamage("head", damage_low, 0)
				take_bleeding_damage(patient, surgeon, damage_low)
				return 1

			patient.tri_message("<span style=\"color:red\"><b>[surgeon]</b> cuts away the flesh holding [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] right eye in with [src]!</span>",\
			surgeon, "<span style=\"color:red\">You cut away the flesh holding [surgeon == patient ? "your" : "[patient]'s"] right eye in with [src]!</span>", \
			patient, "<span style=\"color:red\">[patient == surgeon ? "You cut" : "<b>[surgeon]</b> cuts"] away the flesh holding your right eye in with [src]!</span>")

			patient.TakeDamage("head", damage_low, 0)
			if (!surgeon.find_type_in_hand(/obj/item/hemostat))
				take_bleeding_damage(patient, surgeon, damage_low)
			else
				surgeon.show_text("You clamp the bleeders with the hemostat.", "blue")
			patient.updatehealth()
			patient.organHolder.right_eye.op_stage = 2.0
			return 1

		else if (patient.organHolder.left_eye && patient.organHolder.left_eye.op_stage == 1.0 && surgeon.find_in_hand(src) == surgeon.l_hand)
			playsound(get_turf(patient), "sound/weapons/squishcut.ogg", 50, 1)

			if (prob(screw_up_prob))
				surgeon.visible_message("<span style=\"color:red\"><b>[surgeon][fluff]!</b></span>")
				patient.TakeDamage("head", damage_low, 0)
				take_bleeding_damage(patient, surgeon, damage_low)
				return 1

			patient.tri_message("<span style=\"color:red\"><b>[surgeon]</b> cuts away the flesh holding [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] left eye in with [src]!</span>",\
			surgeon, "<span style=\"color:red\">You cut away the flesh holding [surgeon == patient ? "your" : "[patient]'s"] left eye in with [src]!</span>", \
			patient, "<span style=\"color:red\">[patient == surgeon ? "You cut" : "<b>[surgeon]</b> cuts"] away the flesh holding your left eye in with [src]!</span>")

			patient.TakeDamage("head", damage_low, 0)
			if (!surgeon.find_type_in_hand(/obj/item/hemostat))
				take_bleeding_damage(patient, surgeon, damage_low)
			else
				surgeon.show_text("You clamp the bleeders with the hemostat.", "blue")
			patient.updatehealth()
			patient.organHolder.left_eye.op_stage = 2.0
			return 1

		else if (patient.organHolder.brain)
			if (patient.organHolder.brain.op_stage == 0.0)
				playsound(get_turf(patient), "sound/weapons/squishcut.ogg", 50, 1)

				if (prob(screw_up_prob))
					surgeon.visible_message("<span style=\"color:red\"><b>[surgeon][fluff]!</b></span>")
					patient.TakeDamage("head", damage_low, 0)
					take_bleeding_damage(patient, surgeon, damage_low)
					return 1

				patient.tri_message("<span style=\"color:red\"><b>[surgeon]</b> cuts [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] head open with [src]!</span>",\
				surgeon, "<span style=\"color:red\">You cut [surgeon == patient ? "your" : "[patient]'s"] head open with [src]!</span>", \
				patient, "<span style=\"color:red\">[patient == surgeon ? "You cut" : "<b>[surgeon]</b> cuts"] your head open with [src]!</span>")

				patient.TakeDamage("head", damage_low, 0)
				if (!surgeon.find_type_in_hand(/obj/item/hemostat))
					take_bleeding_damage(patient, surgeon, damage_low)
				else
					surgeon.show_text("You clamp the bleeders with the hemostat.", "blue")
				patient.updatehealth()
				patient.organHolder.brain.op_stage = 1.0
				return 1

			else if (patient.organHolder.brain.op_stage == 2.0)
				playsound(get_turf(patient), "sound/weapons/squishcut.ogg", 50, 1)

				if (prob(screw_up_prob))
					surgeon.visible_message("<span style=\"color:red\"><b>[surgeon][fluff2]!</b></span>")
					patient.TakeDamage("head", damage_high, 0)
					take_bleeding_damage(patient, surgeon, damage_high)
					return 1

				patient.tri_message("<span style=\"color:red\"><b>[surgeon]</b> removes the connections to [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] brain with [src]!</span>",\
				surgeon, "<span style=\"color:red\">You remove [surgeon == patient ? "your" : "[patient]'s"] connections to [surgeon == patient ? "your" : "[his_or_her(patient)]"] brain with [src]!</span>",\
				patient, "<span style=\"color:red\">[patient == surgeon ? "You remove" : "<b>[surgeon]</b> removes"] the connections to your brain with [src]!</span>")

				patient.TakeDamage("head", damage_high, 0)
				if (!surgeon.find_type_in_hand(/obj/item/hemostat))
					take_bleeding_damage(patient, surgeon, damage_low)
				else
					surgeon.show_text("You clamp the bleeders with the hemostat.", "blue")
				patient.updatehealth()
				patient.organHolder.brain.op_stage = 3.0
				return 1

			else
				src.surgeryConfusion(patient, surgeon, damage_high)
				return 1

		else if (patient.organHolder.skull)
			if (patient.organHolder.skull.op_stage == 0.0)
				playsound(get_turf(patient), "sound/weapons/squishcut.ogg", 50, 1)

				if (prob(screw_up_prob))
					surgeon.visible_message("<span style=\"color:red\"><b>[surgeon][fluff]!</b></span>")
					patient.TakeDamage("head", damage_low, 0)
					take_bleeding_damage(patient, surgeon, damage_low)
					return 1

				patient.tri_message("<span style=\"color:red\"><b>[surgeon]</b> cuts [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] skull away from the skin with [src]!</span>",\
				surgeon, "<span style=\"color:red\">You cut [surgeon == patient ? "your" : "[patient]'s"] skull away from the skin with [src]!</span>",\
				patient, "<span style=\"color:red\">[patient == surgeon ? "You cut" : "<b>[surgeon]</b> cuts"] your skull away from the skin with [src]!</span>")

				patient.TakeDamage("head", damage_low, 0)
				if (!surgeon.find_type_in_hand(/obj/item/hemostat))
					take_bleeding_damage(patient, surgeon, damage_low)
				else
					surgeon.show_text("You clamp the bleeders with the hemostat.", "blue")
				patient.updatehealth()
				patient.organHolder.skull.op_stage = 1.0
				return 1

			else
				src.surgeryConfusion(patient, surgeon, damage_high)
				return 1
		else
			return 0

/* ---------- SCALPEL - BUTT ---------- */

	else if (surgeon.zone_sel.selecting == "chest" && surgeon.a_intent == "harm")
		if (patient.butt_op_stage == 0.0)
			playsound(get_turf(patient), "sound/weapons/squishcut.ogg", 50, 1)

			if (prob(screw_up_prob))
				surgeon.visible_message("<span style=\"color:red\"><b>[surgeon][fluff]!</b></span>")
				patient.TakeDamage("chest", damage_low, 0)
				take_bleeding_damage(patient, surgeon, damage_low)
				return 1

			patient.tri_message("<span style=\"color:red\"><b>[surgeon]</b> cuts [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] butt open with [src]!</span>",\
			surgeon, "<span style=\"color:red\">You cut [surgeon == patient ? "your" : "[patient]'s"] butt open with [src]!</span>",\
			patient, "<span style=\"color:red\">[patient == surgeon ? "You cut" : "<b>[surgeon]</b> cuts"] your butt open with [src]!</span>")

			patient.TakeDamage("chest", damage_low, 0)
			if (!surgeon.find_type_in_hand(/obj/item/hemostat))
				take_bleeding_damage(patient, surgeon, damage_low)
			else
				surgeon.show_text("You clamp the bleeders with the hemostat.", "blue")
			patient.updatehealth()
			patient.butt_op_stage = 1.0
			return 1

		else if (patient.butt_op_stage == 2.0)
			playsound(get_turf(patient), "sound/weapons/squishcut.ogg", 50, 1)

			if (prob(screw_up_prob))
				surgeon.visible_message("<span style=\"color:red\"><b>[surgeon][fluff2]!</b></span>")
				patient.TakeDamage("chest", damage_high, 0)
				take_bleeding_damage(patient, surgeon, damage_high)
				return 1

			patient.tri_message("<span style=\"color:red\"><b>[surgeon]</b> severs [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] intestines with [src]!</span>",\
			surgeon, "<span style=\"color:red\">You sever [surgeon == patient ? "your" : "[patient]'s"] intestines with [src]!</span>",\
			patient, "<span style=\"color:red\">[patient == surgeon ? "You sever" : "<b>[surgeon]</b> severs"] your intestines with [src]!</span>")

			patient.TakeDamage("chest", damage_high, 0)
			if (!surgeon.find_type_in_hand(/obj/item/hemostat))
				take_bleeding_damage(patient, surgeon, damage_low)
			else
				surgeon.show_text("You clamp the bleeders with the hemostat.", "blue")
			patient.updatehealth()
			patient.butt_op_stage = 3.0
			return 1

		else
			src.surgeryConfusion(patient, surgeon, damage_high)
			return 1

/* ---------- SCALPEL - IMPLANT ---------- */

	else if (surgeon.zone_sel.selecting == "chest" && surgeon.a_intent != "harm")
		if (patient.implant.len > 0)
			playsound(get_turf(patient), "sound/weapons/squishcut.ogg", 50, 1)
			patient.tri_message("<span style=\"color:red\"><b>[surgeon]</b> cuts into [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] chest with [src]!</span>",\
			surgeon, "<span style=\"color:red\">You cut into [surgeon == patient ? "your" : "[patient]'s"] chest with [src]!</span>",\
			patient, "<span style=\"color:red\">[patient == surgeon ? "You cut" : "<b>[surgeon]</b> cuts"] into your chest with [src]!</span>")

			var/attempted_parasite_removal = 0
			for (var/datum/ailment_data/an_ailment in patient.ailments)
				if (an_ailment.cure == "Surgery")
					attempted_parasite_removal = 1
					var/success = an_ailment.surgery(surgeon, patient)
					if (success)
						surgeon.cure_disease(an_ailment)
					else
						break
			if (attempted_parasite_removal == 1)
				return 1

			for (var/obj/item/implant/projectile/I in patient.implant)
				patient.tri_message("<span style=\"color:red\"><b>[surgeon]</b> cuts out \an [I] from [patient == surgeon ? "[him_or_her(patient)]self" : "[patient]"] with [src]!</span>",\
				surgeon, "<span style=\"color:red\">You cut out \an [I] from [surgeon == patient ? "yourself" : "[patient]"] with [src]!</span>",\
				patient, "<span style=\"color:red\">[patient == surgeon ? "You cut" : "<b>[surgeon]</b> cuts"] out \an [I] from you with [src]!</span>")

				I.on_remove(patient)
				patient.implant.Remove(I)
				I.set_loc(patient.loc)
				return 1

			for (var/obj/item/implant/I in patient.implant)
				if (istype(I, /obj/item/implant/health))
					patient.mini_health_hud = 0

				// This is kinda important (Convair880).
				if (istype(I, /obj/item/implant/mindslave))
					if (patient.mind && (patient.mind.special_role == "mindslave"))
						remove_mindslave_status(patient, "mslave", "surgery")
					else if (patient.mind && patient.mind.master)
						remove_mindslave_status(patient, "otherslave", "surgery")

				patient.tri_message("<span style=\"color:red\"><b>[surgeon]</b> cuts out an implant from [patient == surgeon ? "[him_or_her(patient)]self" : "[patient]"] with [src]!</span>",\
				surgeon, "<span style=\"color:red\">You cut out an implant from [surgeon == patient ? "yourself" : "[patient]"] with [src]!</span>",\
				patient, "<span style=\"color:red\">[patient == surgeon ? "You cut" : "<b>[surgeon]</b> cuts"] out an implant from you with [src]!</span>")

				var/obj/item/implantcase/newcase = new /obj/item/implantcase(patient.loc)
				newcase.imp = I
				I.on_remove(patient)
				patient.implant.Remove(I)
				I.set_loc(newcase)
				newcase.icon_state = "implantcase-b"

				return 1

/* ---------- SCALPEL - HEART ---------- */

		else if (patient.organHolder.heart)
			if (patient.organHolder.heart.op_stage == 0.0)
				playsound(get_turf(patient), "sound/weapons/squishcut.ogg", 50, 1)

				if (prob(screw_up_prob))
					surgeon.visible_message("<span style=\"color:red\"><b>[surgeon][fluff]!</b></span>")
					patient.TakeDamage("chest", damage_low, 0)
					take_bleeding_damage(patient, surgeon, damage_low)
					return 1

				patient.tri_message("<span style=\"color:red\"><b>[surgeon]</b> cuts [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] chest open with [src]!</span>",\
				surgeon, "<span style=\"color:red\">You cut [surgeon == patient ? "your" : "[patient]'s"] chest open with [src]!</span>",\
				patient, "<span style=\"color:red\">[patient == surgeon ? "You cut" : "<b>[surgeon]</b> cuts"] your chest open with [src]!</span>")

				patient.TakeDamage("chest", damage_low, 0)
				if (!surgeon.find_type_in_hand(/obj/item/hemostat))
					take_bleeding_damage(patient, surgeon, damage_low)
				else
					surgeon.show_text("You clamp the bleeders with the hemostat.", "blue")
				patient.updatehealth()
				patient.organHolder.heart.op_stage = 1.0
				return 1

			else if (patient.organHolder.heart.op_stage == 2.0)
				playsound(get_turf(patient), "sound/weapons/squishcut.ogg", 50, 1)

				if (prob(screw_up_prob))
					surgeon.visible_message("<span style=\"color:red\"><b>[surgeon][fluff2]!</b></span>")
					patient.TakeDamage("chest", damage_high, 0)
					take_bleeding_damage(patient, surgeon, damage_high)
					return 1

				patient.tri_message("<span style=\"color:red\"><b>[surgeon]</b> cuts [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] aorta and vena cava with [src]!</span>",\
				surgeon, "<span style=\"color:red\">You cut [surgeon == patient ? "your" : "[patient]'s"] aorta and vena cava with [src]!</span>",\
				patient, "<span style=\"color:red\">[patient == surgeon ? "You cut" : "<b>[surgeon]</b> cuts"] your aorta and vena cava with [src]!</span>")

				patient.TakeDamage("chest", damage_high, 0)
				if (!surgeon.find_type_in_hand(/obj/item/hemostat))
					take_bleeding_damage(patient, surgeon, damage_low)
				else
					surgeon.show_text("You clamp the bleeders with the hemostat.", "blue")
				patient.updatehealth()
				patient.organHolder.heart.op_stage = 3.0
				return 1

			else
				src.surgeryConfusion(patient, surgeon, damage_high)
				return 1
		else
			return 0

/* ---------- SCALPEL - LIMBS ---------- */

	else if (surgeon.zone_sel.selecting in list("l_arm","r_arm","l_leg","r_leg"))
		var/obj/item/parts/surgery_limb = patient.limbs.vars[surgeon.zone_sel.selecting]
		if (istype(surgery_limb))
			if (surgery_limb.surgery(src))
				return 1
			else
				src.surgeryConfusion(patient, surgeon, damage_high)
				return 1
	else
		return 0

/* ========================= */
/* ---------- SAW ---------- */
/* ========================= */

/obj/item/proc/saw_surgery(var/mob/living/carbon/human/patient as mob, var/mob/surgeon as mob)
	if (!ishuman(patient))
		return 0

	if (!patient.organHolder)
		return 0

	if (surgeon.bioHolder.HasEffect("clumsy") && prob(50))
		surgeon.visible_message("<span style=\"color:red\"><b>[surgeon]</b> mishandles [src] and cuts [him_or_her(surgeon)]self!</span>",\
		"<span style=\"color:red\">You mishandle [src] and cut yourself!</span>")
		surgeon.weakened += 10
		var/damage = rand(10, 20)
		random_brute_damage(surgeon, damage)
		take_bleeding_damage(surgeon, damage)
		return 1

	src.add_fingerprint(surgeon)

	if (!surgeryCheck(patient, surgeon))
		return 0

	// fluff2 is for things that do more damage: nicking an artery is included in the choices
	var/fluff = pick(" messes up", "'s hand slips", " fumbles with [src]", " nearly drops [src]", "'s hand twitches")
	var/fluff2 = pick(" messes up", "'s hand slips", " fumbles with [src]", " nearly drops [src]", "'s hand twitches", " nicks an artery")

	var/screw_up_prob = calc_screw_up_prob(patient, surgeon)

	var/damage_low = calc_surgery_damage(surgeon, screw_up_prob, rand(10,20)/*, src.adj1, src.adj2*/)
	var/damage_high = calc_surgery_damage(surgeon, screw_up_prob, rand(20,30)/*, src.adj1, src.adj2*/)

	DEBUG("<b>[patient]'s surgery (performed by [surgeon]) damage_low is [damage_low], damage_high is [damage_high]</b>")

/* ---------- SAW - HEAD ---------- */

	if (surgeon.zone_sel.selecting == "head")
		if (!headSurgeryCheck(patient))
			surgeon.show_text("You're going to need to remove that mask/helmet/glasses first.", "blue")
			return 1

		if (surgeon.a_intent == INTENT_HARM && patient.organHolder.head)
			if (patient.organHolder.head.op_stage == 1.0)
				playsound(get_turf(patient), "sound/weapons/squishcut.ogg", 50, 1)

				if (prob(screw_up_prob))
					surgeon.visible_message("<span style=\"color:red\"><b>[surgeon][fluff]!</b></span>")
					patient.TakeDamage("head", damage_low, 0)
					take_bleeding_damage(patient, surgeon, damage_low)
					return 1

				patient.tri_message("<span style=\"color:red\"><b>[surgeon]</b> severs most of [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] neck with [src]!</span>",\
				surgeon, "<span style=\"color:red\">You sever most of [surgeon == patient ? "your" : "[patient]'s"] neck with [src]!</span>",\
				patient, "<span style=\"color:red\">[patient == surgeon ? "You sever" : "<b>[surgeon]</b> severs"] most of your neck with [src]!</span>")

				patient.TakeDamage("head", damage_low, 0)
				if (!surgeon.find_type_in_hand(/obj/item/hemostat))
					take_bleeding_damage(patient, surgeon, damage_low)
				else
					surgeon.show_text("You clamp the bleeders with the hemostat.", "blue")
				patient.updatehealth()
				patient.organHolder.head.op_stage = 2.0
				return 1

			else if (patient.organHolder.head.op_stage == 3.0)
				playsound(get_turf(patient), "sound/weapons/squishcut.ogg", 50, 1)

				if (prob(screw_up_prob))
					surgeon.visible_message("<span style=\"color:red\"><b>[surgeon][fluff]!</b></span>")
					patient.TakeDamage("head", damage_low, 0)
					take_bleeding_damage(patient, surgeon, damage_low)
					return 1

				patient.tri_message("<span style=\"color:red\"><b>[surgeon]</b> saws through the last of [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] head's connections to [surgeon == patient ? "[his_or_her(patient)]" : "[patient]'s"] body with [src]!</span>",\
				surgeon, "<span style=\"color:red\">You saw through the last of [surgeon == patient ? "your" : "[patient]'s"] head's connections to [surgeon == patient ? "your" : "[his_or_her(patient)]"] body with [src]!</span>",\
				patient, "<span style=\"color:red\">[patient == surgeon ? "You saw" : "<b>[surgeon]</b> saws"] through the last of your head's connection to your body with [src]!</span>")

				patient.TakeDamage("head", damage_low, 0)
				if (!surgeon.find_type_in_hand(/obj/item/hemostat))
					take_bleeding_damage(patient, surgeon, damage_low)
				else
					surgeon.show_text("You clamp the bleeders with the hemostat.", "blue")
				if (patient.organHolder.brain)
					logTheThing("combat", surgeon, patient, "removed %target%'s head and brain with [src].")
					patient.death()
				patient.organHolder.drop_organ("head")
				return 1

			else
				src.surgeryConfusion(patient, surgeon, damage_high)
				return 1

		else if (patient.organHolder.brain)
			if (patient.organHolder.brain.op_stage == 1.0)
				playsound(get_turf(patient), "sound/weapons/squishcut.ogg", 50, 1)

				if (prob(screw_up_prob))
					surgeon.visible_message("<span style=\"color:red\"><b>[surgeon][fluff]!</b></span>")
					patient.TakeDamage("head", damage_low, 0)
					take_bleeding_damage(patient, surgeon, damage_low)
					return 1

				patient.tri_message("<span style=\"color:red\"><b>[surgeon]</b> saws open [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] skull with [src]!</span>",\
				surgeon, "<span style=\"color:red\">You saw open [surgeon == patient ? "your" : "[patient]'s"] skull with [src]!</span>",\
				patient, "<span style=\"color:red\">[patient == surgeon ? "You saw" : "<b>[surgeon]</b> saws"] open your skull with [src]!</span>")

				patient.TakeDamage("head", damage_low, 0)
				if (!surgeon.find_type_in_hand(/obj/item/hemostat))
					take_bleeding_damage(patient, surgeon, damage_low)
				else
					surgeon.show_text("You clamp the bleeders with the hemostat.", "blue")
				patient.updatehealth()
				patient.organHolder.brain.op_stage = 2.0
				return 1

			else if (patient.organHolder.brain.op_stage == 3.0)
				playsound(get_turf(patient), "sound/weapons/squishcut.ogg", 50, 1)

				if (prob(screw_up_prob))
					surgeon.visible_message("<span style=\"color:red\"><b>[surgeon][fluff]!</b></span>")
					patient.TakeDamage("head", damage_low, 0)
					take_bleeding_damage(patient, surgeon, damage_low)
					return 1

				patient.tri_message("<span style=\"color:red\"><b>[surgeon]</b> severs [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] brain's connection to the spine with [src]!</span>",\
				surgeon, "<span style=\"color:red\">You sever [surgeon == patient ? "your" : "[patient]'s"] brain's connection to the spine with [src]!</span>",\
				patient, "<span style=\"color:red\">[patient == surgeon ? "You sever" : "<b>[surgeon]</b> severs"] your brain's connection to the spine with [src]!</span>")

				patient.TakeDamage("head", damage_low, 0)
				if (!surgeon.find_type_in_hand(/obj/item/hemostat))
					take_bleeding_damage(patient, surgeon, damage_low)
				else
					surgeon.show_text("You clamp the bleeders with the hemostat.", "blue")
				logTheThing("combat", surgeon, patient, "removed %target%'s brain with [src].")
				patient.death()
				patient.organHolder.drop_organ("brain")
				return 1

			else
				src.surgeryConfusion(patient, surgeon, damage_high)
				return 1

		else if (patient.organHolder.skull)
			if (patient.organHolder.skull.op_stage == 1.0)
				playsound(get_turf(patient), "sound/weapons/squishcut.ogg", 50, 1)

				if (prob(screw_up_prob))
					surgeon.visible_message("<span style=\"color:red\"><b>[surgeon][fluff]!</b></span>")
					patient.TakeDamage("head", damage_low, 0)
					take_bleeding_damage(patient, surgeon, damage_low)
					return 1

				patient.tri_message("<span style=\"color:red\"><b>[surgeon]</b> saws [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] skull out with [src]!</span>",\
				surgeon, "<span style=\"color:red\">You saw [surgeon == patient ? "your" : "[patient]'s"] skull out with [src]!</span>",\
				patient, "<span style=\"color:red\">[patient == surgeon ? "You saw" : "<b>[surgeon]</b> saws"] your skull out with [src]!</span>")

				patient.visible_message("<span style=\"color:red\"><b>[patient]</b>'s head collapses into a useless pile of skin with no skull to keep it in its proper shape!</span>",\
				"<span style=\"color:red\">Your head collapses into a useless pile of skin with no skull to keep it in its proper shape!</span>")
				patient.organHolder.drop_organ("skull")
				patient.TakeDamage("head", damage_low, 0)
				if (!surgeon.find_type_in_hand(/obj/item/hemostat))
					take_bleeding_damage(patient, surgeon, damage_low)
				else
					surgeon.show_text("You clamp the bleeders with the hemostat.", "blue")
				patient.real_name = "Unknown"
				patient.unlock_medal("Red Hood", 1)
				patient.updatehealth()
				patient.set_clothing_icon_dirty()
				return 1
			else
				src.surgeryConfusion(patient, surgeon, damage_high)
				return 1
		else
			return 0

/* ---------- SAW - BUTT ---------- */

	else if (surgeon.zone_sel.selecting == "chest" && surgeon.a_intent == "harm")
		switch (patient.butt_op_stage)
			if (1.0)
				playsound(get_turf(patient), "sound/weapons/squishcut.ogg", 50, 1)

				if (prob(screw_up_prob))
					surgeon.visible_message("<span style=\"color:red\"><b>[surgeon][fluff]!</b></span>")
					patient.TakeDamage("chest", damage_low, 0)
					take_bleeding_damage(patient, surgeon, damage_low)
					return 1

				patient.tri_message("<span style=\"color:red\"><b>[surgeon]</b> saws open [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] butt with [src]!</span>",\
				surgeon, "<span style=\"color:red\">You saw open [surgeon == patient ? "your" : "[patient]'s"] butt with [src]!</span>",\
				patient, "<span style=\"color:red\">[patient == surgeon ? "You saw" : "<b>[surgeon]</b> saws"] open your butt with [src]!</span>")

				patient.TakeDamage("chest", damage_low, 0)
				if (!surgeon.find_type_in_hand(/obj/item/hemostat))
					take_bleeding_damage(patient, surgeon, damage_low)
				else
					surgeon.show_text("You clamp the bleeders with the hemostat.", "blue")
				patient.updatehealth()
				patient.butt_op_stage = 2.0
				return 1

			if (3.0)
				playsound(get_turf(patient), "sound/weapons/squishcut.ogg", 50, 1)

				if (prob(screw_up_prob))
					surgeon.visible_message("<span style=\"color:red\"><b>[surgeon][fluff]!</b></span>")
					patient.TakeDamage("chest", damage_low, 0)
					take_bleeding_damage(patient, surgeon, damage_low)
					return 1

				patient.tri_message("<span style=\"color:red\"><b>[surgeon]</b> severs [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] butt's connection to the stomach with [src]!</span>",\
				surgeon , "<span style=\"color:red\">You sever [surgeon == patient ? "your" : "[patient]'s"] butt's connection to the stomach with [src]!</span>",\
				patient, "<span style=\"color:red\">[patient == surgeon ? "You sever" : "<b>[surgeon]</b> severs"] your butt's connection to the stomach with [src]!</span>")

				patient.TakeDamage("chest", damage_low, 0)
				if (!surgeon.find_type_in_hand(/obj/item/hemostat))
					take_bleeding_damage(patient, surgeon, damage_low)
				else
					surgeon.show_text("You clamp the bleeders with the hemostat.", "blue")
				patient.updatehealth()
				patient.butt_op_stage = 4.0
				patient.organHolder.drop_organ("butt")
				return 1

			else
				src.surgeryConfusion(patient, surgeon, damage_high)
				return 1

/* ---------- SAW - HEART ---------- */

	else if (surgeon.zone_sel.selecting == "chest" && surgeon.a_intent != "harm")
		if (patient.organHolder.heart)
			switch (patient.organHolder.heart.op_stage)
				if (1.0)
					playsound(get_turf(patient), "sound/weapons/squishcut.ogg", 50, 1)

					if (prob(screw_up_prob))
						surgeon.visible_message("<span style=\"color:red\"><b>[surgeon][fluff]!</b></span>")
						patient.TakeDamage("chest", damage_low, 0)
						take_bleeding_damage(patient, surgeon, damage_low)
						return 1

					patient.tri_message("<span style=\"color:red\"><b>[surgeon]</b> saws open [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] ribcage with [src]!</span>",\
					surgeon, "<span style=\"color:red\">You saw open [surgeon == patient ? "your" : "[patient]'s"] ribcage with [src]!</span>",\
					patient, "<span style=\"color:red\">[patient == surgeon ? "You saw" : "<b>[surgeon]</b> saws"] open your ribcage with [src]!</span>")

					patient.TakeDamage("chest", damage_low, 0)
					if (!surgeon.find_type_in_hand(/obj/item/hemostat))
						take_bleeding_damage(patient, surgeon, damage_low)
					else
						surgeon.show_text("You clamp the bleeders with the hemostat.", "blue")
					patient.updatehealth()
					patient.organHolder.heart.op_stage = 2.0
					return 1

				if (3.0)
					playsound(get_turf(patient), "sound/weapons/squishcut.ogg", 50, 1)

					if (prob(screw_up_prob))
						surgeon.visible_message("<span style=\"color:red\"><b>[surgeon][fluff2]!</b></span>")
						patient.TakeDamage("chest", damage_high, 0)
						take_bleeding_damage(patient, surgeon, damage_high)
						return 1

					patient.tri_message("<span style=\"color:red\"><b>[surgeon]</b> cuts out [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] heart with [src]!</span>",\
					surgeon, "<span style=\"color:red\">You cut out [surgeon == patient ? "your" : "[patient]'s"] heart with [src]!</span>",\
					patient, "<span style=\"color:red\">[patient == surgeon ? "You cut" : "<b>[surgeon]</b> cuts"] out your heart with [src]!</span>")

					patient.TakeDamage("chest", damage_high, 0)
					if (!surgeon.find_type_in_hand(/obj/item/hemostat))
						take_bleeding_damage(patient, surgeon, damage_low)
					else
						surgeon.show_text("You clamp the bleeders with the hemostat.", "blue")
					patient.updatehealth()
					logTheThing("combat", surgeon, patient, "removed %target%'s heart with [src].")
					//patient.contract_disease(/datum/ailment/disease/noheart,null,null,1)

					patient.organHolder.drop_organ("heart")
					return 1
				else
					src.surgeryConfusion(patient, surgeon, damage_high)
					return 1
		else
			return 0

/* ---------- SAW - LIMBS ---------- */

	else if (surgeon.zone_sel.selecting in list("l_arm","r_arm","l_leg","r_leg"))
		var/obj/item/parts/surgery_limb = patient.limbs.vars[surgeon.zone_sel.selecting]
		if (istype(surgery_limb))
			if (surgery_limb.surgery(src))
				return 1
			else
				src.surgeryConfusion(patient, surgeon, damage_high)
				return 1

	else
		return 0

/* ============================ */
/* ---------- SUTURE ---------- */
/* ============================ */

/obj/item/proc/suture_surgery(var/mob/living/carbon/human/patient as mob, var/mob/surgeon as mob)
	if (!ishuman(patient))
		return 0

	if (surgeon.bioHolder.HasEffect("clumsy") && prob(33))
		surgeon.visible_message("<span style=\"color:red\"><b>[surgeon]</b> pricks [his_or_her(surgeon)] finger with [src]!</span>",\
		"<span style=\"color:red\">You prick your finger with [src]</span>")

		//surgeon.bioHolder.AddEffect("blind") // oh my god I'm the biggest idiot ever I forgot to get rid of this part
		// I'm not deleting it I'm just commenting it out so my shame will be eternal and perhaps future generations of coders can learn from my mistake
		// - Haine
		surgeon.weakened += 4
		var/damage = rand(1, 10)
		random_brute_damage(surgeon, damage)
		take_bleeding_damage(surgeon, damage)
		return 1

	src.add_fingerprint(surgeon)

	if (!surgeryCheck(patient, surgeon))
		return 0

/* ---------- SUTURE - HEAD ---------- */

	if (surgeon.zone_sel.selecting == "head")
		if (patient.organHolder && patient.organHolder.head && patient.organHolder.head.op_stage > 0.0)
			patient.tri_message("<span style=\"color:blue\"><b>[surgeon]</b> sews the incision on [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] neck closed with [src].</span>",\
			surgeon, "<span style=\"color:blue\">You sew the incision on [surgeon == patient ? "your" : "[patient]'s"] neck closed with [src].</span>",\
			patient, "<span style=\"color:blue\">[patient == surgeon ? "You sew" : "<b>[surgeon]</b> sews"] the incision on your neck closed with [src].</span>")

			patient.organHolder.head.op_stage = 0.0
			patient.TakeDamage("head", 2, 0)
			if (patient.bleeding)
				repair_bleeding_damage(patient, 50, rand(1,3))
			patient.updatehealth()
			return 1

		else if (patient.organHolder && patient.organHolder.brain && patient.organHolder.brain.op_stage > 0.0)
			patient.tri_message("<span style=\"color:blue\"><b>[surgeon]</b> sews the incision on [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] head closed with [src].</span>",\
			surgeon, "<span style=\"color:blue\">You sew the incision on [surgeon == patient ? "your" : "[patient]'s"] head closed with [src].</span>",\
			patient, "<span style=\"color:blue\">[patient == surgeon ? "You sew" : "<b>[surgeon]</b> sews"] the incision on your head closed with [src].</span>")

			patient.organHolder.brain.op_stage = 0.0
			patient.TakeDamage("head", 2, 0)
			if (patient.bleeding)
				repair_bleeding_damage(patient, 50, rand(1,3))
			patient.updatehealth()
			return 1

		else if (patient.organHolder && patient.organHolder.right_eye && patient.organHolder.right_eye.op_stage > 0.0)
			patient.tri_message("<span style=\"color:blue\"><b>[surgeon]</b> sews the incision in [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] right eye socket closed with [src].</span>",\
			surgeon, "<span style=\"color:blue\">You sew the incision in [surgeon == patient ? "your" : "[patient]'s"] right eye socket closed with [src].</span>",\
			patient, "<span style=\"color:blue\">[patient == surgeon ? "You sew" : "<b>[surgeon]</b> sews"] the incision in your right eye socket closed with [src].</span>")

			patient.organHolder.right_eye.op_stage = 0.0
			patient.TakeDamage("head", 2, 0)
			if (patient.bleeding)
				repair_bleeding_damage(patient, 50, rand(1,3))
			patient.updatehealth()

		else if (patient.organHolder && patient.organHolder.left_eye && patient.organHolder.left_eye.op_stage > 0.0)
			patient.tri_message("<span style=\"color:blue\"><b>[surgeon]</b> sews the incision in [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] left eye socket closed with [src].</span>",\
			surgeon, "<span style=\"color:blue\">You sew the incision in [surgeon == patient ? "your" : "[patient]'s"] left eye socket closed with [src].</span>",\
			patient, "<span style=\"color:blue\">[patient == surgeon ? "You sew" : "<b>[surgeon]</b> sews"] the incision in your left eye socket closed with [src].</span>")

			patient.organHolder.left_eye.op_stage = 0.0
			patient.TakeDamage("head", 2, 0)
			if (patient.bleeding)
				repair_bleeding_damage(patient, 50, rand(1,3))
			patient.updatehealth()

		else if (patient.bleeding)
			patient.tri_message("<span style=\"color:blue\"><b>[surgeon]</b> sews [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] wounds closed with [src].</span>",\
			surgeon, "You sew [surgeon == patient ? "your" : "[patient]'s"] wounds closed with [src].",\
			patient, "<span style=\"color:blue\">[patient == surgeon ? "You sew" : "<b>[surgeon]</b> sews"] your wounds closed with [src].</span>")

			random_brute_damage(patient, 2)
			repair_bleeding_damage(patient, 100, 10)
			patient.updatehealth()
			return 1

		else
			return 0

/* ---------- SUTURE - CHEST ---------- */

	else if (surgeon.zone_sel.selecting == "chest")

		if (patient.organHolder && patient.organHolder.heart && patient.organHolder.heart.op_stage > 0.0)
			patient.tri_message("<span style=\"color:blue\"><b>[surgeon]</b> sews the incision on [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] chest closed with [src].</span>",\
			surgeon, "<span style=\"color:blue\">You sew the incision on [surgeon == patient ? "your" : "[patient]'s"] chest closed with [src].</span>",\
			patient, "<span style=\"color:blue\">[patient == surgeon ? "You sew" : "<b>[surgeon]</b> sews"] the incision on your chest closed with [src].</span>")

			patient.organHolder.heart.op_stage = 0.0
			patient.TakeDamage("chest", 2, 0)
			if (patient.bleeding)
				repair_bleeding_damage(patient, 50, rand(1,3))
			patient.updatehealth()
			return 1

		else if (patient.butt_op_stage > 0.0 && patient.butt_op_stage < 4.0)
			patient.tri_message("<span style=\"color:blue\"><b>[surgeon]</b> sews the incision on [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] butt closed with [src].</span>",\
			surgeon, "<span style=\"color:blue\">You sew the incision on [surgeon == patient ? "your" : "[patient]'s"] butt closed with [src].</span>",\
			patient, "<span style=\"color:blue\">[patient == surgeon ? "You sew" : "<b>[surgeon]</b> sews"] the incision on your butt closed with [src].</span>")

			patient.butt_op_stage = 0.0
			patient.TakeDamage("chest", 2, 0)
			if (patient.bleeding)
				repair_bleeding_damage(patient, 50, rand(1,3))
			patient.updatehealth()
			return 1

		else if (patient.bleeding)
			patient.tri_message("<span style=\"color:blue\"><b>[surgeon]</b> sews [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] wounds closed with [src].</span>",\
			surgeon, "You sew [surgeon == patient ? "your" : "[patient]'s"] wounds closed with [src].",\
			patient, "<span style=\"color:blue\">[patient == surgeon ? "You sew" : "<b>[surgeon]</b> sews"] your wounds closed with [src].</span>")

			random_brute_damage(patient, 2)
			repair_bleeding_damage(patient, 100, 10)
			patient.updatehealth()
			return 1

		else
			return 0
	else
		return 0

/* ============================= */
/* ---------- CAUTERY ---------- */
/* ============================= */

// right now this is just for cauterizing butt wounds in case someone wants to, uhh, do that, I guess
// okay I gotta make this proc work differently than the others because holy shit all those return 1/return 0s are driving me batty

/obj/item/proc/cautery_surgery(var/mob/living/carbon/human/patient as mob, var/mob/surgeon as mob, var/damage as num, var/lit = 1)
	if (!ishuman(patient))
		return 0

	if (patient.is_heat_resistant())
		patient.visible_message("<span style=\"color:red\"><b>Nothing happens!</b></span>")
		return 0

	if (!surgeon)
		surgeon = patient

	if (!damage)
		damage = rand(5, 15)

	if (surgeon.bioHolder.HasEffect("clumsy") && prob(33))
		surgeon.visible_message("<span style=\"color:red\"><b>[surgeon]</b> burns [him_or_her(surgeon)]self with [src]!</span>",\
		"<span style=\"color:red\">You burn yourself with [src]</span>")

		surgeon.weakened += 4
		random_burn_damage(surgeon, damage)
		return 1

	src.add_fingerprint(surgeon)

	var/quick_surgery = 0

	if (surgeryCheck(patient, surgeon))
		quick_surgery = 1

/* ---------- CAUTERY - HEAD ---------- */

	if (surgeon.zone_sel.selecting == "head" && patient.organHolder && patient.organHolder.head && patient.organHolder.head.op_stage > 0.0)

		if (!lit)
			patient.tri_message("<b>[surgeon]</b> tries to use [src] on [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] incision, but [src] isn't lit! Sheesh.",\
			surgeon, "You try to use [src] on [surgeon == patient ? "your" : "[patient]'s"] incision, but [src] isn't lit! Sheesh.",\
			patient, "[patient == surgeon ? "You try" : "<b>[surgeon]</b> tries"] to use [src] on your incision, but [src] isn't lit! Sheesh.")
			return 0

		random_burn_damage(patient, damage)
		patient.updatehealth()

		if (quick_surgery)
			patient.tri_message("<span style=\"color:blue\"><b>[surgeon]</b> cauterizes the incision on [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] neck closed with [src].</span>",\
			surgeon, "<span style=\"color:blue\">You cauterize the incision on [surgeon == patient ? "your" : "[patient]'s"] neck closed with [src].</span>",\
			patient, "<span style=\"color:blue\">[patient == surgeon ? "You cauterize" : "<b>[surgeon]</b> cauterizes"] the incision on your neck closed with [src].</span>")

			patient.organHolder.head.op_stage = 0.0
			if (patient.bleeding)
				repair_bleeding_damage(patient, 50, rand(1,3))
			return 1

		else
			patient.tri_message("<span style=\"color:blue\"><b>[surgeon]</b> begins cauterizing the incision on [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] neck closed with [src].</span>",\
			surgeon, "<span style=\"color:blue\">You begin cauterizing the incision on [surgeon == patient ? "your" : "[patient]'s"] neck closed with [src].</span>",\
			patient, "<span style=\"color:blue\">[patient == surgeon ? "You begin" : "<b>[surgeon]</b> begins"] cauterizing incision on your neck closed with [src].</span>")

			if (do_mob(patient, surgeon, max(100 - (damage * 2)), 0))
				patient.tri_message("<span style=\"color:blue\"><b>[surgeon]</b> cauterizes the incision on [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] neck closed with [src].</span>",\
				surgeon, "<span style=\"color:blue\">You cauterize the incision on [surgeon == patient ? "your" : "[patient]'s"] neck closed with [src].</span>",\
				patient, "<span style=\"color:blue\">[patient == surgeon ? "You cauterize" : "<b>[surgeon]</b> cauterizes"] the incision on your neck closed with [src].</span>")

				patient.organHolder.head.op_stage = 0.0
				if (patient.bleeding)
					repair_bleeding_damage(patient, 50, rand(1,3))
				return 1

			else
				surgeon.show_text("<b>You were interrupted!</b>", "red")
				return 1

/* ---------- CAUTERY - BUTT ---------- */

	else if (surgeon.zone_sel.selecting == "chest" && patient.butt_op_stage == 4.0)

		if (!lit)
			patient.tri_message("<b>[surgeon]</b> tries to use [src] on [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] incision, but [src] isn't lit! Sheesh.",\
			surgeon, "You try to use [src] on [surgeon == patient ? "your" : "[patient]'s"] incision, but [src] isn't lit! Sheesh.",\
			patient, "[patient == surgeon ? "You try" : "<b>[surgeon]</b> tries"] to use [src] on your incision, but [src] isn't lit! Sheesh.")
			return 0

		random_burn_damage(patient, damage)
		patient.updatehealth()

		if (quick_surgery)
			patient.tri_message("<span style=\"color:blue\"><b>[surgeon]</b> cauterizes the incision on [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] butt closed with [src].</span>",\
			surgeon, "<span style=\"color:blue\">You cauterize the incision on [surgeon == patient ? "your" : "[patient]'s"] butt closed with [src].</span>",\
			patient, "<span style=\"color:blue\">[patient == surgeon ? "You cauterize" : "<b>[surgeon]</b> cauterizes"] the incision on your butt closed with [src].</span>")

			patient.butt_op_stage = 5.0
			if (patient.bleeding)
				repair_bleeding_damage(patient, 50, rand(1,3))
			return 1

		else
			patient.tri_message("<span style=\"color:blue\"><b>[surgeon]</b> begins cauterizing the incision on [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] butt closed with [src].</span>",\
			surgeon, "<span style=\"color:blue\">You begin cauterizing the incision on [surgeon == patient ? "your" : "[patient]'s"] butt closed with [src].</span>",\
			patient, "<span style=\"color:blue\">[patient == surgeon ? "You begin" : "<b>[surgeon]</b> begins"] cauterizing incision on your butt closed with [src].</span>")

			if (do_mob(patient, surgeon, max(100 - (damage * 2)), 0))
				patient.tri_message("<span style=\"color:blue\"><b>[surgeon]</b> cauterizes the incision on [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] butt closed with [src].</span>",\
				surgeon, "<span style=\"color:blue\">You cauterize the incision on [surgeon == patient ? "your" : "[patient]'s"] butt closed with [src].</span>",\
				patient, "<span style=\"color:blue\">[patient == surgeon ? "You cauterize" : "<b>[surgeon]</b> cauterizes"] the incision on your butt closed with [src].</span>")

				patient.butt_op_stage = 5.0
				if (patient.bleeding)
					repair_bleeding_damage(patient, 50, rand(1,3))
				return 1

			else
				surgeon.show_text("<b>You were interrupted!</b>", "red")
				return 1

/* ---------- CAUTERY - BLEEDING ---------- */

	else if (patient.bleeding)

		if (!lit)
			patient.tri_message("<b>[surgeon]</b> tries to use [src] on [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] wounds, but [src] isn't lit! Sheesh.",\
			surgeon, "You try to use [src] on [surgeon == patient ? "your" : "[patient]'s"] wounds, but [src] isn't lit! Sheesh.",\
			patient, "[patient == surgeon ? "You try" : "<b>[surgeon]</b> tries"] to use [src] on your wounds, but [src] isn't lit! Sheesh.")
			return 1

		random_burn_damage(patient, damage)
		patient.updatehealth()

		if (quick_surgery)
			patient.tri_message("<span style=\"color:blue\"><b>[surgeon]</b> cauterizes [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] wounds closed with [src].</span>",\
			surgeon, "<span style=\"color:blue\">You cauterize [surgeon == patient ? "your" : "[patient]'s"] wounds closed with [src].</span>",\
			patient, "<span style=\"color:blue\">[patient == surgeon ? "You cauterizes" : "<b>[surgeon]</b> cauterizes"] your wounds closed with [src].</span>")

			repair_bleeding_damage(patient, 100, 10)
			return 1

		else
			patient.tri_message("<span style=\"color:blue\"><b>[surgeon]</b> begins cauterizing [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] wounds closed with [src].</span>",\
			surgeon, "<span style=\"color:blue\">You begin cauterizing [surgeon == patient ? "your" : "[patient]'s"] wounds closed with [src].</span>",\
			patient, "<span style=\"color:blue\">[patient == surgeon ? "You begin" : "<b>[surgeon]</b> begins"] cauterizing your wounds closed with [src].</span>")

			if (do_mob(patient, surgeon, max((patient.bleeding * 10) - (damage * 2), 0)))
				patient.tri_message("<span style=\"color:blue\"><b>[surgeon]</b> cauterizes [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] wounds closed with [src].</span>",\
				surgeon, "<span style=\"color:blue\">You cauterize [surgeon == patient ? "your" : "[patient]'s"] wounds closed with [src].</span>",\
				patient, "<span style=\"color:blue\">[patient == surgeon ? "You cauterize" : "<b>[surgeon]</b> cauterizes"] your wounds closed with [src].</span>")

				repair_bleeding_damage(patient, 100, 10)
				return 1

			else
				surgeon.show_text("<b>You were interrupted!</b>", "red")
				return 1

	else
		return 0

/* =========================== */
/* ---------- SPOON ---------- */
/* =========================== */

/obj/item/proc/spoon_surgery(var/mob/living/carbon/human/patient as mob, var/mob/living/surgeon as mob)
	if (!ishuman(patient))
		return 0

	if (!patient.organHolder)
		return 0
/* gunna think on this part
	if (surgeon.bioHolder.HasEffect("clumsy") && prob(50))
		surgeon.visible_message("<span style=\"color:red\"><b>[surgeon]</b> fumbles and stabs [him_or_her(surgeon)]self in the eye with [src]!</span>", \
		"<span style=\"color:red\">You fumble and stab yourself in the eye with [src]!</span>")
		surgeon.bioHolder.AddEffect("blind")
		surgeon.weakened += 4
		var/damage = rand(5, 15)
		random_brute_damage(surgeon, damage)
		take_bleeding_damage(surgeon, null, damage)
		return 1
*/
	src.add_fingerprint(surgeon)

	if (!surgeryCheck(patient, surgeon))
		return 0

	// fluff2 is for things that do more damage: nicking the optic nerve is included in the choices
	var/fluff = pick(" messes up", "'s hand slips", " fumbles with [src]", " nearly drops [src]", "'s hand twitches", " jabs [src] in too far")
	var/fluff2 = pick(" messes up", "'s hand slips", " fumbles with [src]", " nearly drops [src]", "'s hand twitches", " jabs [src] in too far", " nicks the optic nerve")

	var/screw_up_prob = calc_screw_up_prob(patient, surgeon)

	var/damage_low = calc_surgery_damage(surgeon, screw_up_prob, rand(5,15)/*, src.adj1, src.adj2*/)
	var/damage_high = calc_surgery_damage(surgeon, screw_up_prob, rand(15,25)/*, src.adj1, src.adj2*/)

	DEBUG("<b>[patient]'s surgery (performed by [surgeon]) damage_low is [damage_low], damage_high is [damage_high]</b>")

/* ---------- SPOON - EYES ---------- */

	if (surgeon.zone_sel.selecting == "head")
		if (!headSurgeryCheck(patient))
			surgeon.show_text("You're going to need to remove that mask/helmet/glasses first.", "blue")
			return 1

/* ---------- SPOON - RIGHT EYE ---------- */

		if (surgeon.find_in_hand(src) == surgeon.r_hand && patient.organHolder.right_eye)
			if (patient.organHolder.right_eye.op_stage == 0.0)
				playsound(get_turf(patient), "sound/weapons/squishcut.ogg", 50, 1)

				if (prob(screw_up_prob))
					surgeon.visible_message("<span style=\"color:red\"><b>[surgeon][fluff]!</b></span>")
					patient.TakeDamage("head", damage_low, 0)
					take_bleeding_damage(patient, surgeon, damage_low)
					return 1

				patient.tri_message("<span style=\"color:red\"><b>[surgeon]</b> inserts [src] into [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] right eye socket!</span>",\
				surgeon, "<span style=\"color:red\">You insert [src] into [surgeon == patient ? "your" : "[patient]'s"] right eye socket!</span>", \
				patient, "<span style=\"color:red\">[patient == surgeon ? "You insert" : "<b>[surgeon]</b> inserts"] [src] into your right eye socket!</span>")

				patient.TakeDamage("head", damage_low, 0)
				if (!surgeon.find_type_in_hand(/obj/item/hemostat))
					take_bleeding_damage(patient, surgeon, damage_low)
				else
					surgeon.show_text("You clamp the bleeders with the hemostat.", "blue")
				patient.updatehealth()
				patient.organHolder.right_eye.op_stage = 1.0
				return 1

			else if (patient.organHolder.right_eye.op_stage == 2.0)
				playsound(get_turf(patient), "sound/weapons/squishcut.ogg", 50, 1)

				if (prob(screw_up_prob))
					surgeon.visible_message("<span style=\"color:red\"><b>[surgeon][fluff2]!</b></span>")
					patient.TakeDamage("head", damage_high, 0)
					take_bleeding_damage(patient, surgeon, damage_high)
					return 1

				patient.tri_message("<span style=\"color:red\"><b>[surgeon]</b> removes [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] right eye with [src]!</span>",\
				surgeon, "<span style=\"color:red\">You remove [surgeon == patient ? "your" : "[patient]'s"] right eye with [src]!</span>",\
				patient, "<span style=\"color:red\">[patient == surgeon ? "You remove" : "<b>[surgeon]</b> removes"] your right eye with [src]!</span>")

				patient.TakeDamage("head", damage_low, 0)
				if (!surgeon.find_type_in_hand(/obj/item/hemostat))
					take_bleeding_damage(patient, surgeon, damage_low)
				else
					surgeon.show_text("You clamp the bleeders with the hemostat.", "blue")
				logTheThing("combat", surgeon, patient, "removed %target%'s right eye with [src].")
				patient.organHolder.drop_organ("right_eye")
				return 1

			else
				src.surgeryConfusion(patient, surgeon, damage_high)
				return 1

/* ---------- SPOON - LEFT EYE ---------- */

		else if (surgeon.find_in_hand(src) == surgeon.l_hand && patient.organHolder.left_eye)
			if (patient.organHolder.left_eye.op_stage == 0.0)
				playsound(get_turf(patient), "sound/weapons/squishcut.ogg", 50, 1)

				if (prob(screw_up_prob))
					surgeon.visible_message("<span style=\"color:red\"><b>[surgeon][fluff]!</b></span>")
					patient.TakeDamage("head", damage_low, 0)
					take_bleeding_damage(patient, surgeon, damage_low)
					return 1

				patient.tri_message("<span style=\"color:red\"><b>[surgeon]</b> inserts [src] into [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] left eye socket!</span>",\
				surgeon, "<span style=\"color:red\">You insert [src] into [surgeon == patient ? "your" : "[patient]'s"] left eye socket!</span>", \
				patient, "<span style=\"color:red\">[patient == surgeon ? "You insert" : "<b>[surgeon]</b> inserts"] [src] into your left eye socket!</span>")

				patient.TakeDamage("head", damage_low, 0)
				if (!surgeon.find_type_in_hand(/obj/item/hemostat))
					take_bleeding_damage(patient, surgeon, damage_low)
				else
					surgeon.show_text("You clamp the bleeders with the hemostat.", "blue")
				patient.updatehealth()
				patient.organHolder.left_eye.op_stage = 1.0
				return 1

			else if (patient.organHolder.left_eye.op_stage == 2.0)
				playsound(get_turf(patient), "sound/weapons/squishcut.ogg", 50, 1)

				if (prob(screw_up_prob))
					surgeon.visible_message("<span style=\"color:red\"><b>[surgeon][fluff2]!</b></span>")
					patient.TakeDamage("head", damage_high, 0)
					take_bleeding_damage(patient, surgeon, damage_high)
					return 1

				patient.tri_message("<span style=\"color:red\"><b>[surgeon]</b> removes [patient == surgeon ? "[his_or_her(patient)]" : "[patient]'s"] left eye with [src]!</span>",\
				surgeon, "<span style=\"color:red\">You remove [surgeon == patient ? "your" : "[patient]'s"] left eye with [src]!</span>",\
				patient, "<span style=\"color:red\">[patient == surgeon ? "You remove" : "<b>[surgeon]</b> removes"] your left eye with [src]!</span>")

				patient.TakeDamage("head", damage_low, 0)
				if (!surgeon.find_type_in_hand(/obj/item/hemostat))
					take_bleeding_damage(patient, surgeon, damage_low)
				else
					surgeon.show_text("You clamp the bleeders with the hemostat.", "blue")
				logTheThing("combat", surgeon, patient, "removed %target%'s left eye with [src].")
				patient.organHolder.drop_organ("left_eye")
				return 1

			else
				src.surgeryConfusion(patient, surgeon, damage_high)
				return 1

		else
			return 0
