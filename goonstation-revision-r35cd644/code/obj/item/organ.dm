#define L_ORGAN 1
#define R_ORGAN 2

/datum/organHolder // you ever play fallout 3?  you know those like sacks of gibs that were around?  yeah
	var/mob/living/carbon/human/donor = null

	var/obj/item/organ/head/head = null
	var/obj/item/skull/skull = null
	var/obj/item/organ/brain/brain = null
	var/obj/item/organ/eye/left_eye = null
	var/obj/item/organ/eye/right_eye = null
	var/obj/item/organ/chest/chest = null
	var/obj/item/organ/heart/heart = null
	var/obj/item/organ/lung/left_lung = null
	var/obj/item/organ/lung/right_lung = null
	var/obj/item/clothing/head/butt/butt = null

	var/list/organ_list = list("all", "head", "skull", "brain", "left_eye", "right_eye", "chest", "heart", "left_lung", "right_lung", "butt")

	New(var/mob/living/carbon/human/H)
		..()
		if (istype(H))
			src.donor = H
		if (src.donor)
			src.create_organs()

	dispose()
		if (head)
			head.donor = null
		if (skull)
			skull.donor = null
		if (brain)
			brain.donor = null
			brain.owner = null
		if (left_eye)
			left_eye.donor = null
		if (right_eye)
			right_eye.donor = null
		if (chest)
			chest.donor = null
		if (heart)
			heart.donor = null
		if (left_lung)
			left_lung.donor = null
		if (right_lung)
			right_lung.donor = null
		if (butt)
			butt.donor = null
		donor = null
		..()

	proc/create_organs()
		if (!src.donor)
			return // vOv

		if (!src.head)
			src.head = new /obj/item/organ/head(src.donor)
			head.donor = src.donor
			organ_list["head"] = head

		if (!src.skull)
			src.skull = new /obj/item/skull(src.donor)
			src.skull.donor = src.donor
			organ_list["skull"] = skull

			// For variety and predators (Convair880).
			spawn(25) // Don't remove.
				if (src.donor && src.donor.organHolder && src.donor.organHolder.skull)
					src.donor.assign_gimmick_skull()

		if (!src.brain)
			if (prob(2))
				src.brain = new /obj/item/organ/brain/synth(src.donor)
			else
				src.brain = new /obj/item/organ/brain(src.donor)
			src.brain.setOwner(src.donor.mind)
			src.brain.donor = src.donor
			organ_list["brain"] = brain
			spawn (20)
				if (src.brain && src.donor)
					src.brain.name = "[src.donor.real_name]'s [initial(src.brain.name)]"
					if (src.donor.mind)
						src.brain.setOwner(src.donor.mind)

		if (!src.left_eye)
			src.left_eye = new /obj/item/organ/eye/left(src.donor)
			src.left_eye.donor = src.donor
			organ_list["left_eye"] = left_eye
		if (!src.right_eye)
			src.right_eye = new /obj/item/organ/eye/right(src.donor)
			src.right_eye.donor = src.donor
			organ_list["right_eye"] = right_eye

		if (!src.chest)
			src.chest = new /obj/item/organ/chest(src.donor)
			chest.donor = src.donor
			organ_list["chest"] = chest

		if (!src.heart)
			src.heart = new /obj/item/organ/heart(src.donor)
			src.heart.donor = src.donor
			organ_list["heart"] = heart

		if (!src.left_lung)
			src.left_lung = new /obj/item/organ/lung/left(src.donor)
			src.left_lung.donor = src.donor
			organ_list["left_lung"] = left_lung
		if (!src.right_lung)
			src.right_lung = new /obj/item/organ/lung/right(src.donor)
			src.right_lung.donor = src.donor
			organ_list["right_lung"] = right_lung

		if (!src.butt)
			src.butt = new /obj/item/clothing/head/butt(src.donor)
			src.butt.donor = src.donor
			organ_list["butt"] = butt

	proc/drop_organ(var/type, var/location)
		if (!src.donor || !type)
			return

		if (!location)
			location = src.donor.loc

		switch (lowertext(type))

			if ("all")
				if (islist(src.organ_list))
					for (var/thing in src.organ_list)
						if (!src.organ_list[thing])
							continue
						src.drop_organ(thing, location)
					return 1
				/*src.drop_organ("brain", location)
				src.drop_organ("head", location)
				src.drop_organ("skull", location)
				src.drop_organ("right_eye", location)
				src.drop_organ("left_eye", location)
				src.drop_organ("chest", location)
				src.drop_organ("heart", location)
				src.drop_organ("right_lung", location)
				src.drop_organ("left_lung", location)
				src.drop_organ("butt", location)
				return 1*/

			if ("head")
				if (!src.head)
					return 0
				var/obj/item/organ/head/myHead = src.head
				if (src.brain)
					myHead.brain = src.drop_organ("brain", myHead)
				if (src.skull)
					myHead.skull = src.drop_organ("skull", myHead)
				if (src.right_eye)
					myHead.right_eye = src.drop_organ("right_eye", myHead)
				if (src.left_eye)
					myHead.left_eye = src.drop_organ("left_eye", myHead)
				if (src.donor.glasses)
					var/obj/item/W = src.donor.glasses
					src.donor.u_equip(W)
					W.set_loc(myHead)
					myHead.glasses = W
				if (src.donor.head)
					var/obj/item/W = src.donor.head
					src.donor.u_equip(W)
					W.set_loc(myHead)
					myHead.head = W // blehhhh
				if (src.donor.ears)
					var/obj/item/W = src.donor.ears
					src.donor.u_equip(W)
					W.set_loc(myHead)
					myHead.ears = W
				if (src.donor.wear_mask)
					var/obj/item/W = src.donor.wear_mask
					src.donor.u_equip(W)
					W.set_loc(myHead)
					myHead.wear_mask = W
				myHead.set_loc(location)
				myHead.update_headgear_image()
				myHead.on_removal()
				src.head = null
				src.donor.update_body()
				src.donor.UpdateDamageIcon()
				src.donor.update_clothing()
				return myHead

			if ("skull")
				if (!src.skull)
					return 0
				var/obj/item/skull/mySkull = src.skull
				mySkull.set_loc(location)
				src.skull = null
				return mySkull

			if ("brain")
				if (!src.brain)
					return 0
				var/obj/item/organ/brain/myBrain = src.brain
				if (!myBrain.owner) //Oh no, they have no mind!
					if (src.donor.ghost)
						if (src.donor.ghost.mind)
							logTheThing("debug", null, null, "<b>Mind</b> drop_organ forced to retrieve mind for key \[[src.donor.key]] from ghost.")
							myBrain.setOwner(src.donor.ghost.mind)
						else if (src.donor.ghost.key)
							logTheThing("debug", null, null, "<b>Mind</b> drop_organ forced to create new mind for key \[[src.donor.key]] from ghost.")
							var/datum/mind/newmind = new
							newmind.key = src.donor.ghost.key
							newmind.current = src.donor.ghost
							src.donor.ghost.mind = newmind
							myBrain.setOwner(newmind)
					else if (src.donor.key)
						logTheThing("debug", null, null, "<b>Mind</b> drop_organ forced to create new mind for key \[[src.donor.key]]")
						var/datum/mind/newmind = new
						newmind.key = src.donor.key
						newmind.current = src.donor
						src.donor.mind = newmind
						myBrain.setOwner(newmind)
				myBrain.set_loc(location)
				myBrain.on_removal()
				src.brain = null
				return myBrain

			if ("left_eye")
				if (!src.left_eye)
					return 0
				var/obj/item/organ/eye/myLeftEye = src.left_eye
				myLeftEye.set_loc(location)
				myLeftEye.on_removal()
				src.left_eye = null
				return myLeftEye

			if ("right_eye")
				if (!src.right_eye)
					return 0
				var/obj/item/organ/eye/myRightEye = src.right_eye
				myRightEye.set_loc(location)
				myRightEye.on_removal()
				src.right_eye = null
				return myRightEye

			if ("chest")
				if (!src.chest)
					return 0
				var/obj/item/organ/chest/myChest = src.chest
				myChest.set_loc(location)
				myChest.on_removal()
				src.chest = null
				return myChest

			if ("heart")
				if (!src.heart)
					return 0
				var/obj/item/organ/heart/myHeart = src.heart
				if (src.donor.reagents)
					src.donor.reagents.trans_to(myHeart, 330)
				if (src.heart.robotic)
					src.donor.remove_stam_mod_regen("heart")
					src.donor.remove_stam_mod_max("heart")
				myHeart.set_loc(location)
				myHeart.on_removal()
				src.heart = null
				src.donor.update_body()
				return myHeart

			if ("left_lung")
				if (!src.left_lung)
					return 0
				var/obj/item/organ/lung/myLeftLung = src.left_lung
				myLeftLung.set_loc(location)
				myLeftLung.on_removal()
				src.left_lung = null
				return myLeftLung

			if ("right_lung")
				if (!src.right_lung)
					return 0
				var/obj/item/organ/lung/myRightLung = src.right_lung
				myRightLung.set_loc(location)
				myRightLung.on_removal()
				src.right_lung = null
				return myRightLung

			if ("butt")
				if (!src.butt)
					return 0
				var/obj/item/clothing/head/butt/myButt = src.butt
				myButt.set_loc(location)
				src.butt = null
				return myButt

	proc/receive_organ(var/obj/item/I, var/type, var/op_stage = 0.0, var/force = 0)
		if (!src.donor || !I || !type)
			return 0

		var/success = 0

		switch (lowertext(type))

			if ("head")
				if (src.head)
					if (force)
						qdel(src.head)
					else
						return 0
				var/obj/item/organ/head/newHead = I
				if (src.donor.client)
					src.donor.client.mob = new /mob/dead/observer(src)
				if (newHead.brain && newHead.brain.owner)
					newHead.brain.owner.transfer_to(src.donor)
				newHead.op_stage = op_stage
				src.head = newHead
				newHead.set_loc(src.donor)
				if (newHead.skull)
					if (src.skull) // how
						src.drop_organ("skull") // I mean really, how
					src.skull = newHead.skull
					newHead.skull.set_loc(src.donor)
					newHead.skull = null
				if (newHead.brain)
					if (src.brain) // ???
						src.drop_organ("brain") // god idfk
					src.brain = newHead.brain
					newHead.brain.set_loc(src.donor)
					newHead.brain = null
				if (newHead.right_eye)
					if (src.right_eye)
						src.drop_organ("right_eye")
					src.right_eye = newHead.right_eye
					newHead.right_eye.set_loc(src.donor)
					newHead.right_eye = null
				if (newHead.left_eye)
					if (src.left_eye)
						src.drop_organ("left_eye")
					src.left_eye = newHead.left_eye
					newHead.left_eye.set_loc(src.donor)
					newHead.left_eye = null

				if (newHead.glasses)
					if (src.donor.glasses)
						src.donor.glasses.set_loc(get_turf(src.donor))
						src.donor.u_equip(src.donor.glasses)
					src.donor.glasses = newHead.glasses
					newHead.glasses.set_loc(src.donor)
					newHead.glasses = null
				if (newHead.head)
					if (src.donor.head)
						src.donor.head.set_loc(get_turf(src.donor))
						src.donor.u_equip(src.donor.head)
					src.donor.head = newHead.head
					newHead.head.set_loc(src.donor)
					newHead.head = null
				if (newHead.ears)
					if (src.donor.ears)
						src.donor.ears.set_loc(get_turf(src.donor))
						src.donor.u_equip(src.donor.ears)
					src.donor.ears = newHead.ears
					newHead.ears.set_loc(src.donor)
					newHead.ears = null
				if (newHead.wear_mask)
					if (src.donor.wear_mask)
						src.donor.wear_mask.set_loc(get_turf(src.donor))
						src.donor.u_equip(src.donor.wear_mask)
					src.donor.wear_mask = newHead.wear_mask
					newHead.wear_mask.set_loc(src.donor)
					newHead.wear_mask = null

				src.donor.update_body()
				src.donor.UpdateDamageIcon()
				src.donor.update_clothing()
				organ_list["head"] = newHead
				success = 1

			if ("skull")
				if (src.skull)
					if (force)
						qdel(src.skull)
					else
						return 0
				var/obj/item/skull/newSkull = I
				newSkull.op_stage = op_stage
				src.skull = newSkull
				newSkull.set_loc(src.donor)
				organ_list["skull"] = newSkull
				success = 1

			if ("brain")
				if (src.brain)
					if (force)
						qdel(src.brain)
					else
						return 0
				var/obj/item/organ/brain/newBrain = I
				if (src.donor.client)
					src.donor.client.mob = new /mob/dead/observer(src)
				if (newBrain.owner)
					newBrain.owner.transfer_to(src.donor)
				newBrain.op_stage = op_stage
				src.brain = newBrain
				newBrain.set_loc(src.donor)
				organ_list["brain"] = newBrain
				success = 1

			if ("left_eye")
				if (src.left_eye)
					if (force)
						qdel(src.left_eye)
					else
						return 0
				var/obj/item/organ/eye/newLeftEye = I
				newLeftEye.op_stage = op_stage
				src.left_eye = newLeftEye
				newLeftEye.set_loc(src.donor)
				organ_list["left_eye"] = newLeftEye
				success = 1

			if ("right_eye")
				if (src.right_eye)
					if (force)
						qdel(src.right_eye)
					else
						return 0
				var/obj/item/organ/eye/newRightEye = I
				newRightEye.op_stage = op_stage
				src.right_eye = newRightEye
				newRightEye.set_loc(src.donor)
				organ_list["right_eye"] = newRightEye
				success = 1

			if ("chest") // should never be this but vOv
				if (src.chest)
					if (force)
						qdel(src.chest)
					else
						return 0
				var/obj/item/organ/chest/newChest = I
				newChest.op_stage = op_stage
				src.chest = newChest
				newChest.set_loc(src.donor)
				organ_list["chest"] = newChest
				success = 1

			if ("heart")
				if (src.heart)
					if (force)
						qdel(src.heart)
					else
						return 0
				var/obj/item/organ/heart/newHeart = I
				if (newHeart.robotic)
					if (src.donor.bioHolder.HasEffect("elecres"))
						newHeart.broken = 1
					if (newHeart.broken || src.donor.bioHolder.HasEffect("elecres"))
						src.donor.show_text("Something is wrong with [newHeart], it fails to start beating!", "red")
						src.donor.contract_disease(/datum/ailment/disease/flatline,null,null,1)
					if (newHeart.emagged)
						src.donor.add_stam_mod_regen("heart", 20)
						src.donor.add_stam_mod_max("heart", 100)
					else
						src.donor.add_stam_mod_regen("heart", 10)
						src.donor.add_stam_mod_max("heart", 50)
				newHeart.op_stage = op_stage
				src.heart = newHeart
				newHeart.set_loc(src.donor)
				organ_list["heart"] = newHeart
				success = 1

			if ("left_lung")
				if (src.left_lung)
					if (force)
						qdel(src.left_lung)
					else
						return 0
				var/obj/item/organ/lung/newLeftLung = I
				newLeftLung.op_stage = op_stage
				src.left_lung = newLeftLung
				newLeftLung.set_loc(src.donor)
				organ_list["left_lung"] = newLeftLung
				success = 1

			if ("right_lung")
				if (src.right_lung)
					if (force)
						qdel(src.right_lung)
					else
						return 0
				var/obj/item/organ/lung/newRightLung = I
				newRightLung.op_stage = op_stage
				src.right_lung = newRightLung
				newRightLung.set_loc(src.donor)
				organ_list["right_lung"] = newRightLung
				success = 1

			if ("butt")
				if (src.butt)
					if (force)
						qdel(src.butt)
					else
						return 0
				var/obj/item/clothing/head/butt/newButt = I
				newButt.op_stage = op_stage
				src.butt = newButt
				newButt.set_loc(src.donor)
				organ_list["butt"] = newButt
				success = 1

		if (success)
			if (istype(I, /obj/item/organ))
				var/obj/item/organ/O = I
				O.on_transplant(src.donor)
			if (I.reagents)
				I.reagents.trans_to(src.donor, 330)
			return 1

/mob/living/carbon/human/proc/eye_istype(var/obj/item/I)
	if (!src.organHolder || !I)
		return 0
	if (!src.organHolder.left_eye && !src.organHolder.right_eye)
		return 0
	if (istype(src.organHolder.left_eye, I) || istype(src.organHolder.right_eye, I))
		return 1
	else
		return 0

/*=================================*/
/*---------- Organ Items ----------*/
/*=================================*/

/obj/item/organ
	name = "organ"
	var/organ_name = "organ" // so you can refer to the organ by a simple name and not end up telling someone "Your Lia Alliman's left lung flies out your mouth!"
	desc = "What does this thing even do? Is it something you need?"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "brain1"
	inhand_image_icon = 'icons/mob/inhand/hand_medical.dmi'
	item_state = "brain2"
	flags = TABLEPASS
	force = 1.0
	w_class = 1.0
	throwforce = 1.0
	throw_speed = 3
	throw_range = 5
	stamina_damage = 5
	stamina_cost = 5
	edible = 1
	module_research = list("medicine" = 2) // why would you put this below the throw_impact() stuff
	module_research_type = /obj/item/organ // were you born in a fuckin barn
	var/mob/living/carbon/human/donor = null // if I can't use "owner" I can at least use this
	var/donor_name = null // so you don't get dumb "Unknown's skull mask" shit

	var/op_stage = 0.0
	var/brute_dam = 0
	var/burn_dam = 0
	var/tox_dam = 0

	var/created_decal = /obj/decal/cleanable/blood // what kinda mess it makes.  mostly so cyberhearts can splat oil on the ground, but idk maybe you wanna make something that creates a broken balloon or something on impact vOv
	var/decal_done = 0 // fuckers are tossing these around a lot so I guess they're only gunna make one, ever now
	var/body_side = null // L_ORGAN/1 for left, R_ORGAN/2 for right
	var/datum/bone/bones = null
	rand_pos = 1

	New()
		..()
		spawn(5)
			if (src.donor)
				src.name = "[src.donor.real_name]'s [initial(src.name)]"
				src.donor_name = "[src.donor.real_name]"

	throw_impact(var/turf/T)
		playsound(src.loc, "sound/effects/bloody_stabOLD.ogg", 100, 1)
		if (T && !src.decal_done && ispath(src.created_decal))
			playsound(src.loc, "sound/effects/splat.ogg", 100, 1)
			new src.created_decal(T)
			src.decal_done = 1
		..() // call your goddamn parents

	proc/on_life()
		return

	proc/on_transplant(var/mob/M as mob)
		return

	proc/on_removal()
		return

	take_damage(brute, burn, tox, damage_type)
		if (brute <= 0 && burn <= 0)// && tox <= 0)
			return 0
		src.brute_dam += brute
		src.burn_dam += burn
		//src.tox_dam += tox

		if (ishuman(donor))
			var/mob/living/carbon/human/H = donor
			H.hit_twitch()
			H.UpdateDamage()
			if (bone_system && src.bones && brute && prob(brute * 2))
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

/*=========================*/
/*----------Brain----------*/
/*=========================*/

/obj/item/organ/brain
	name = "brain"
	organ_name = "brain"
	desc = "A human brain, gross."
	icon_state = "brain2"
	item_state = "brain2"
	var/datum/mind/owner = null
	edible = 0
	module_research = list("medicine" = 1, "efficiency" = 10)
	module_research_type = /obj/item/organ/brain

	get_desc()
		if (usr)
			if (usr.job == "Roboticist" || usr.job == "Medical Doctor" || usr.job == "Geneticist" || usr.job == "Medical Director")
				if (src.owner)
					if (src.owner.current)
						. += "<br><span style=\"color:blue\">This brain is still warm.</span>"
					else
						. += "<br><span style=\"color:red\">This brain has gone cold.</span>"
				else
					. += "<br><span style=\"color:red\">This brain has gone cold.</span>"

	attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
		if (!ismob(M))
			return

		src.add_fingerprint(user)

		if (user.zone_sel.selecting != "head")
			return ..()
		if (!surgeryCheck(M, user))
			return ..()

		var/mob/living/carbon/human/H = M
		if (!H.organHolder)
			return ..()

		if (!headSurgeryCheck(H))
			boutput(user, "<span style=\"color:blue\">You're going to need to remove that mask/helmet/glasses first.</span>")
			return

		//since these people will be dead M != usr

		if (!H.organHolder.brain)

			var/fluff = pick("insert", "shove", "place", "drop", "smoosh", "squish")

			H.tri_message("<span style=\"color:red\"><b>[user]</b> [fluff][fluff == "smoosh" || fluff == "squish" ? "es" : "s"] [src] into [H == user ? "[his_or_her(H)]" : "[H]'s"] head!</span>",\
			user, "<span style=\"color:red\">You [fluff] [src] into [user == H ? "your" : "[H]'s"] head!</span>",\
			H, "<span style=\"color:red\">[H == user ? "You" : "<b>[user]</b>"] [fluff][fluff == "smoosh" || fluff == "squish" ? "es" : "s"] [src] into your head!</span>")

			user.u_equip(src)
			H.organHolder.receive_organ(src, "brain", 3.0)

		else
			..()
		return

	proc/setOwner(var/datum/mind/mind)
		if (!mind)
			return
		if (mind.brain)
			var/obj/item/organ/brain/brain = mind.brain
			brain.owner = null
		mind.brain = src
		owner = mind

/obj/item/organ/brain/synth
	name = "synthbrain"
	item_state = "plant"
	desc = "An artificial mass of grey matter. Not actually, as one might assume, very good at thinking."

	New()
		..()
		src.icon_state = pick("plant_brain", "plant_brain_bloom")

/obj/item/organ/brain/ai
	name = "neural net processor"
	desc = "A heavily augmented human brain, upgraded to deal with the large amount of information an AI unit must process."
	icon_state = "ai_brain"
	item_state = "ai_brain"
	created_decal = /obj/decal/cleanable/oil

/*=========================*/
/*----------Heart----------*/
/*=========================*/

/obj/item/organ/heart
	name = "heart"
	organ_name = "heart"
	desc = "Offal, just offal."
	icon_state = "heart"
	item_state = "heart"
	var/robotic = 0
	var/emagged = 0
	var/broken = 0
	var/synthetic = 0
	module_research = list("medicine" = 1, "efficiency" = 5)
	module_research_type = /obj/item/organ/heart

	on_transplant()
		..()
		if (src.donor)
			for (var/datum/ailment_data/disease in src.donor.ailments)
				if (disease.cure == "Heart Transplant")
					src.donor.cure_disease(disease)
			return

	attack(var/mob/living/carbon/M as mob, var/mob/user as mob)
		if (!ismob(M))
			return

		src.add_fingerprint(user)

		if (user.zone_sel.selecting != "chest")
			return ..()
		if (!surgeryCheck(M, user))
			return ..()

		var/mob/living/carbon/human/H = M
		if (!H.organHolder)
			return ..()

		if (!H.organHolder.heart)

			var/fluff = pick("insert", "shove", "place", "drop", "smoosh", "squish")

			H.tri_message("<span style=\"color:red\"><b>[user]</b> [fluff][fluff == "smoosh" || fluff == "squish" ? "es" : "s"] [src] into [H == user ? "[his_or_her(H)]" : "[H]'s"] chest!</span>",\
			user, "<span style=\"color:red\">You [fluff] [src] into [user == H ? "your" : "[H]'s"] chest!</span>",\
			H, "<span style=\"color:red\">[H == user ? "You" : "<b>[user]</b>"] [fluff][fluff == "smoosh" || fluff == "squish" ? "es" : "s"] [src] into your chest!</span>")

			user.u_equip(src)
			H.organHolder.receive_organ(src, "heart", 3.0)
			H.update_body()

		else
			..()
		return

/obj/item/organ/heart/synth
	name = "synthheart"
	desc = "A synthetic heart, made out of some odd, meaty plant thing."
	synthetic = 1
	item_state = "plant"

	New()
		..()
		src.icon_state = pick("plant_heart", "plant_heart_bloom")

/obj/item/organ/heart/cyber
	name = "cyberheart"
	desc = "A cybernetic heart. Is this thing really medical-grade?"
	icon_state = "heart_robo1"
	item_state = "heart_robo1"
	//created_decal = /obj/decal/cleanable/oil
	edible = 0
	robotic = 1
	mats = 8

	emag_act(var/mob/user, var/obj/item/card/emag/E)
		if (user)
			user.show_text("You disable the safety limiters on [src].", "red")
		src.visible_message("<span style=\"color:red\"><B>[src] sparks and shudders oddly!</B></span>", 1)
		src.emagged = 1
		return 1

	demag(var/mob/user)
		if (!src.emagged)
			return 0
		if (user)
			user.show_text("You reactivate the safety limiters on [src].", "red")
		src.emagged = 0
		return 1

	emp_act()
		if (!src.broken)
			src.broken = 1

/*=========================*/
/*----------Lungs----------*/
/*=========================*/

/obj/item/organ/lung
	name = "lungs"
	organ_name = "lung"
	desc = "Inflating meat airsacks that pass breathed oxygen into a person's blood and expels carbon dioxide back out. Hopefully whoever used to have these doesn't need them anymore."
	icon_state = "lungs_t"

/obj/item/organ/lung/left
	name = "left lung"
	desc = "Inflating meat airsack that passes breathed oxygen into a person's blood and expels carbon dioxide back out. This is a left lung, since it has three lobes. Hopefully whoever used to have this one doesn't need it anymore."
	icon_state = "lung_L"
	body_side = L_ORGAN

/obj/item/organ/lung/right
	name = "right lung"
	desc = "Inflating meat airsack that passes breathed oxygen into a person's blood and expels carbon dioxide back out. This is a right lung, since it has two lobes and a cardiac notch, where the heart would be. Hopefully whoever used to have this one doesn't need it anymore."
	icon_state = "lung_R"
	body_side = R_ORGAN

/*========================*/
/*----------Eyes----------*/
/*========================*/

/obj/item/organ/eye
	name = "eyeball"
	organ_name = "eye"
	desc = "Here's lookin' at you! Er, maybe not so much, anymore."
	icon_state = "eye"
	var/robotic = 0
	var/emagged = 0
	var/broken = 0
	var/synthetic = 0

	New()
		..()
		spawn(10)
			src.update_icon()

	proc/update_icon()
		src.overlays = null
		var/image/iris_image = image(src.icon, src, "eye-iris")
		iris_image.color = "#0D84A8"
		if (src.donor && src.donor.bioHolder && src.donor.bioHolder.mobAppearance) // good lord
			var/datum/appearanceHolder/AH = src.donor.bioHolder.mobAppearance // I ain't gunna type that a billion times thanks
			if ((src.body_side == L_ORGAN && AH.customization_second == "Heterochromia Left") || (src.body_side == R_ORGAN && AH.customization_second == "Heterochromia Right")) // dfhsgfhdgdapeiffert
				iris_image.color = AH.customization_second_color
			else if ((src.body_side == L_ORGAN && AH.customization_third == "Heterochromia Left") || (src.body_side == R_ORGAN && AH.customization_third == "Heterochromia Right")) // gbhjdghgfdbldf
				iris_image.color = AH.customization_third_color
			else
				iris_image.color = AH.e_color
		src.overlays += iris_image

	attack(var/mob/living/carbon/M as mob, var/mob/user as mob)
		if (!ismob(M))
			return

		src.add_fingerprint(user)

		if (user.zone_sel.selecting != "head")
			return ..()
		if (!surgeryCheck(M, user))
			return ..()

		var/mob/living/carbon/human/H = M
		if (!H.organHolder)
			return ..()

		if (!headSurgeryCheck(H))
			user.show_text("You're going to need to remove that mask/helmet/glasses first.", "blue")
			return

		if (user.find_in_hand(src) == user.r_hand && !H.organHolder.right_eye)
			var/fluff = pick("insert", "shove", "place", "drop", "smoosh", "squish")

			H.tri_message("<span style=\"color:red\"><b>[user]</b> [fluff][fluff == "smoosh" || fluff == "squish" ? "es" : "s"] [src] into [H == user ? "[his_or_her(H)]" : "[H]'s"] right eye socket!</span>",\
			user, "<span style=\"color:red\">You [fluff] [src] into [user == H ? "your" : "[H]'s"] right eye socket!</span>",\
			H, "<span style=\"color:red\">[H == user ? "You" : "<b>[user]</b>"] [fluff][fluff == "smoosh" || fluff == "squish" ? "es" : "s"] [src] into your right eye socket!</span>")

			user.u_equip(src)
			H.organHolder.receive_organ(src, "right_eye", 2.0)
			H.update_body()

		else if (user.find_in_hand(src) == user.l_hand && !H.organHolder.left_eye)
			var/fluff = pick("insert", "shove", "place", "drop", "smoosh", "squish")

			H.tri_message("<span style=\"color:red\"><b>[user]</b> [fluff][fluff == "smoosh" || fluff == "squish" ? "es" : "s"] [src] into [H == user ? "[his_or_her(H)]" : "[H]'s"] left eye socket!</span>",\
			user, "<span style=\"color:red\">You [fluff] [src] into [user == H ? "your" : "[H]'s"] left eye socket!</span>",\
			H, "<span style=\"color:red\">[H == user ? "You" : "<b>[user]</b>"] [fluff][fluff == "smoosh" || fluff == "squish" ? "es" : "s"] [src] into your left eye socket!</span>")

			user.u_equip(src)
			H.organHolder.receive_organ(src, "left_eye", 2.0)
			H.update_body()

		else
			..()
		return

/obj/item/organ/eye/left
	name = "left eye"
	body_side = L_ORGAN

/obj/item/organ/eye/right
	name = "right eye"
	body_side = R_ORGAN

/obj/item/organ/eye/synth
	name = "syntheye"
	desc = "An eye what done grew out of a plant."
	icon_state = "eye-synth"
	item_state = "plant"
	synthetic = 1

/obj/item/organ/eye/cyber
	name = "cybereye"
	desc = "A fancy electronic eye to replace one that someone's lost. Kinda fragile, but better than nothing!"
	icon_state = "eye-cyber"
	item_state = "heart_robo1"
	robotic = 1
	edible = 0
	mats = 6

/obj/item/organ/eye/cyber/sunglass
	name = "polarized cybereye"
	desc = "A fancy electronic eye. It has a polarized filter on the lens for built-in protection from the sun and other harsh lightsources. Your night vision is fucked, though."
	icon_state = "eye-sunglass"
	mats = 7

	update_icon()
		return

/obj/item/organ/eye/cyber/thermal
	name = "thermal imager cybereye"
	desc = "A fancy electronic eye. It lets you see through cloaks and enhances your night vision. Use caution around bright lights."
	icon_state = "eye-thermal"
	mats = 7

	update_icon()
		return

/obj/item/organ/eye/cyber/meson
	name = "mesonic imager cybereye"
	desc = "A fancy electronic eye. It lets you see the structure of the station through walls. Trippy!"
	icon_state = "eye-meson"
	mats = 7

	update_icon()
		return

/obj/item/organ/eye/cyber/spectro
	name = "spectroscopic imager cybereye"
	desc = "A fancy electronic eye. It has an integrated minature Raman spectroscope for easy qualitative and quantitative analysis of chemical samples."
	icon_state = "eye-spectro"
	mats = 7

	update_icon()
		return

/obj/item/organ/eye/cyber/prodoc
	name = "\improper ProDoc Healthview cybereye"
	desc = "A fancy electronic eye. It's fitted with an advanced miniature sensor array that allows you to quickly determine the physical condition of others."
	icon_state = "eye-prodoc"
	mats = 7
	var/client/assigned = null

	update_icon()
		return

	//proc/updateIcons() // stolen from original prodocs
	process()
		if (assigned)
			assigned.images.Remove(health_mon_icons)
			addIcons()

			if (loc != assigned.mob)
				assigned.images.Remove(health_mon_icons)
				assigned = null

			//sleep(20)
		else
			processing_items.Remove(src)

	proc/addIcons()
		if (assigned)
			for (var/image/I in health_mon_icons)
				if (!I || !I.loc || !src)
					continue
				if (I.loc.invisibility && I.loc != src.loc)
					continue
				else
					assigned.images.Add(I)

	on_transplant(var/mob/M as mob)
		if (M.client)
			src.assigned = M.client
			spawn(-1)
				if (!(src in processing_items))
					processing_items.Add(src)
		return

	on_removal()
		if (assigned)
			assigned.images.Remove(health_mon_icons)
			assigned = null
			processing_items.Remove(src)
		return

/obj/item/organ/eye/cyber/ecto
	name = "ectosensor cybereye"
	desc = "A fancy electronic eye. It lets you see spooky stuff."
	icon_state = "eye-ecto"
	mats = 7

	update_icon()
		return

/obj/item/organ/eye/cyber/camera
	name = "camera cybereye"
	desc = "A fancy electronic eye. It has a camera in it connected to the station's security camera network."
	icon_state = "eye-camera"
	mats = 7
	var/obj/machinery/camera/camera = null
	var/camera_tag = "Eye Cam"
	var/camera_network = "Zeta"

	New()
		..()
		src.camera = new /obj/machinery/camera(src)
		src.camera.c_tag = src.camera_tag
		src.camera.network = src.camera_network

	update_icon()
		return

	on_transplant(var/mob/M as mob)
		src.camera.c_tag = "[M]'s Eye"
		return ..()

/*========================*/
/*----------Butt----------*/
/*========================*/

/obj/item/clothing/head/butt
	name = "butt"
	desc = "It's a butt. It goes on your head."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "butt"
	force = 1.0
	w_class = 1.0
	throwforce = 1.0
	throw_speed = 3
	throw_range = 5
	c_flags = COVERSEYES
	var/toned = 1
	var/s_tone = 0.0
	var/stapled = 0
	var/allow_staple = 1
	module_research = list("medical" = 1)
	module_research_type = /obj/item/clothing/head/butt
	var/op_stage = 0.0
	rand_pos = 1
	var/mob/living/carbon/human/donor = null
	var/donor_name = null

	New()
		..()
		spawn(5)
			src.material = getCachedMaterial("butt")
			if (src.donor)
				if (src.toned && src.donor.bioHolder)
					var/icon/new_icon = icon('icons/obj/surgery.dmi', "butt")
					src.s_tone = src.donor.bioHolder.mobAppearance.s_tone
					if (src.s_tone >= 0)
						new_icon.Blend(rgb(src.s_tone, src.s_tone, src.s_tone), ICON_ADD)
					else
						new_icon.Blend(rgb(-src.s_tone,  -src.s_tone,  -src.s_tone), ICON_SUBTRACT)
					src.icon = new_icon
				src.name = "[src.donor.real_name]'s [initial(src.name)]"
				src.donor_name = "[src.donor.real_name]"

	attack(mob/living/carbon/human/H as mob, mob/living/carbon/user as mob)
		if (!ismob(H))
			return

		src.add_fingerprint(user)

		if (!(user.zone_sel.selecting == "chest") || !ishuman(H))
			return ..()

		if (!surgeryCheck(H, user))
			return ..()

		if (!H.organHolder)
			return ..()

		if (H.butt_op_stage >= 4.0)
			var/fluff = pick("shove", "place", "drop")
			var/fluff2 = pick("hole", "gaping hole", "incision", "wound")

			if (H.butt_op_stage == 5.0)
				H.tri_message("<span style=\"color:red\"><b>[user]</b> [fluff]s [src] onto the [fluff2] where [H == user ? "[H.gender == "male" ? "his" : "her"]" : "[H]'s"] butt used to be, but the [fluff2] has been cauterized closed and [src] falls right off!</span>",\
				user, "<span style=\"color:red\">You [fluff] [src] onto the [fluff2] where [H == user ? "your" : "[H]'s"] butt used to be, but the [fluff2] has been cauterized closed and [src] falls right off!</span>",\
				H, "<span style=\"color:red\">[H == user ? "You" : "<b>[user]</b>"] [fluff]s [src] onto the [fluff2] where your butt used to be, but the [fluff2] has been cauterized closed and [src] falls right off!</span>")
				return

			else
				H.tri_message("<span style=\"color:red\"><b>[user]</b> [fluff]s [src] onto the [fluff2] where [H == user ? "[H.gender == "male" ? "his" : "her"]" : "[H]'s"] butt used to be!</span>",\
				user, "<span style=\"color:red\">You [fluff] [src] onto the [fluff2] where [H == user ? "your" : "[H]'s"] butt used to be!</span>",\
				H, "<span style=\"color:red\">[H == user ? "You" : "<b>[user]</b>"] [fluff]s [src] onto the [fluff2] where your butt used to be!</span>")

				user.u_equip(src)
				H.organHolder.receive_organ(src, "butt")
				H.butt_op_stage = 3.0
		else
			..()
		return

	proc/staple()
		if (src.stapled <=0)
			src.cant_self_remove = 1
			src.stapled = max(src.stapled, 0)
		src.stapled += 1

	proc/unstaple()
		. = 0
		if (stapled && allow_staple )	//Did an unstaple operation take place?
			if ( --src.stapled <= 0 ) //Got all the staples
				src.cant_self_remove = 0
				src.stapled = 0
			. = 1
			allow_staple = 0
			spawn(50)
				allow_staple = 1

	handle_other_remove(var/mob/source, var/mob/living/carbon/human/target)
		. = ..() && !src.stapled
		if (!source || !target) return
		if( src.unstaple()) //Try a staple if it worked, yay
			if (!src.stapled) //That's the last staple!
				source.visible_message("<span style=\"color:red\"><B>[source.name] rips out the staples from \the [src]!</B></span>", "<span style=\"color:red\"><B>You rip out the staples from \the [src]!</B></span>", "<span style=\"color:red\">You hear a loud ripping noise.</span>")
				. = 1
			else //Did you get some of them?
				source.visible_message("<span style=\"color:red\"><B>[source.name] rips out some of the staples from \the [src]!</B></span>", "<span style=\"color:red\"><B>You rip out some of the staples from \the [src]!</B></span>", "<span style=\"color:red\">You hear a loud ripping noise.</span>")
				. = 0

			//Commence owie
			take_bleeding_damage(target, null, rand(4, 8), DAMAGE_BLUNT)	//My
			playsound(get_turf(target), "sound/effects/splat.ogg", 50, 1) //head,
			target.emote("scream") 									//FUCKING
			target.TakeDamage("head", rand(8, 16), 0) 				//OW!

			logTheThing("combat", source, target, "rips out the staples on %target%'s butt hat") //Crime

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/device/timer))
			var/obj/item/gimmickbomb/butt/B = new /obj/item/gimmickbomb/butt
			B.set_loc(get_turf(user))
			user.show_text("You add the timer to the butt!", "blue")
			qdel(W)
			qdel(src)
		else if (istype(W, /obj/item/parts/robot_parts/arm))
			var/obj/machinery/bot/buttbot/B = new /obj/machinery/bot/buttbot
			var/icon/new_icon = icon('icons/obj/aibots.dmi', "buttbot")
			if (src.s_tone >= 0)
				new_icon.Blend(rgb(src.s_tone, src.s_tone, src.s_tone), ICON_ADD)
			else
				new_icon.Blend(rgb(-src.s_tone,  -src.s_tone,  -src.s_tone), ICON_SUBTRACT)
			B.icon = new_icon
			if (src.donor || src.donor_name)
				B.name = "[src.donor_name ? "[src.donor_name]" : "[src.donor.real_name]"] buttbot"
			user.show_text("You add [W] to [src]. Fantastic.", "blue")
			B.set_loc(get_turf(user))
			qdel(W)
			qdel(src)

		else if (istype(W, /obj/item/spacecash) && W.type != /obj/item/spacecash/buttcoin)
			user.u_equip(W)
			qdel(W)
			user.put_in_hand_or_drop(new /obj/item/spacecash/buttcoin)
			user.show_text("You stuff the cash into the butt... (What is wrong with you?)")
			qdel(src)

		else
			return ..()

/obj/item/clothing/head/butt/cyberbutt // what the fuck am I doing with my life
	name = "robutt"
	desc = "This is a butt, made of metal. A futuristic butt. Okay."
	icon_state = "cyberbutt"
	allow_staple = 0
	toned = 0
// no this is not done and I dunno when it will be done
// I am a bad person who accepts bribes of freaky macho butt drawings and then doesn't prioritize the request the bribe was for

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/parts/robot_parts/arm))
			var/obj/machinery/bot/buttbot/cyber/B = new /obj/machinery/bot/buttbot/cyber(get_turf(user))
			if (src.donor || src.donor_name)
				B.name = "[src.donor_name ? "[src.donor_name]" : "[src.donor.real_name]"] robuttbot"
			user.show_text("You add [W] to [src]. Fantastic.", "blue")
			qdel(W)
			qdel(src)
		else
			return ..()

/*=========================*/
/*----------Skull----------*/
/*=========================*/
// it's uhh.  it's close enough to an organ.

/obj/item/skull
	name = "skull"
	desc = "It's a SKULL!"
	var/preddesc = "A trophy from a less interesting kill." // See assign_gimmick_skull().
	icon = 'icons/obj/surgery.dmi'
	icon_state = "skull"
	w_class = 1
	var/mob/donor = null
	var/donor_name = null
	//var/owner_job = null
	var/value = 1
	var/op_stage = 0.0
	var/obj/item/device/key/skull/key = null //May randomly contain a key
	rand_pos = 1

	New()
		..()
		spawn(5)
			if (src.donor)
				src.name = "[src.donor.real_name]'s [initial(src.name)]"
				src.donor_name = "[src.donor.real_name]"

	examine() // For the predator-specific objective (Convair880).
		set src in usr
		if (ispredator(usr))
			var/trophy = "This is [src.name]<br>[src.preddesc]<br>This trophy has a value of [src.value]."
			boutput(usr, trophy)
		else
			..()
		return

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/parts/robot_parts/leg))
			var/obj/machinery/bot/skullbot/B

			if (src.icon_state == "skull_crystal" || istype(src, /obj/item/skull/crystal))
				B = new /obj/machinery/bot/skullbot/crystal(get_turf(user))

			else if (src.icon_state == "skullP" || istype(src, /obj/item/skull/strange))
				B = new /obj/machinery/bot/skullbot/strange(get_turf(user))

			else if (src.icon_state == "skull_strange" || istype(src, /obj/item/skull/peculiar))
				B = new /obj/machinery/bot/skullbot/peculiar(get_turf(user))

			else if (src.icon_state == "skullA" || istype(src, /obj/item/skull/odd))
				B = new /obj/machinery/bot/skullbot/odd(get_turf(user))

			else if (src.icon_state == "skull_noface" || istype(src, /obj/item/skull/noface))
				B = new /obj/machinery/bot/skullbot/faceless(get_turf(user))

			else if (src.icon_state == "skull_gold" || istype(src, /obj/item/skull/gold))
				B = new /obj/machinery/bot/skullbot/gold(get_turf(user))

			else
				B = new /obj/machinery/bot/skullbot(get_turf(user))

			if (src.donor || src.donor_name)
				B.name = "[src.donor_name ? "[src.donor_name]" : "[src.donor.real_name]"] skullbot"

			user.show_text("You add [W] to [src]. That's neat.", "blue")
			qdel(W)
			qdel(src)
			return

		if (istype(W, /obj/item/rods) && W.amount > 0)
			W:consume_rods(1)
			user.visible_message("<b>[user]</b> jams a rod into the bottom of [src]. Welp.",\
			"You jam a rod into the bottom of [src]. Welp.")
			var/obj/item/reagent_containers/food/drinks/skull_chalice/C = new /obj/item/reagent_containers/food/drinks/skull_chalice(src.loc)
			user.put_in_hand_or_drop(C)
			qdel(src)
			return

		if (istype(W, /obj/item/circular_saw))
			user.visible_message("<span style=\"color:blue\">[user] hollows out [src].</span>")
			var/obj/item/clothing/mask/skull/smask = new /obj/item/clothing/mask/skull
			playsound(user.loc, "sound/machines/mixer.ogg", 50, 1)

			if (src.key)
				var/obj/item/device/key/skull/SK = src.key
				SK.set_loc(get_turf(user))
				SK.visible_message("<span style=\"color:red\"><B>A key clatters out of \the [src]!</B></span>")
				src.key = null

			smask.set_loc(get_turf(user))
			if (src.donor || src.donor_name)
				smask.name = "[src.donor_name ? "[src.donor_name]" : "[src.donor.real_name]"] skull mask"
				smask.desc = "The hollowed out skull of [src.donor_name ? "[src.donor_name]" : "[src.donor.real_name]"]"
			qdel(src)
			return

		else
			return ..()

/obj/item/skull/strange // Predators get this one (Convair880).
	name = "strange skull"
	desc = "This thing is weird."
	icon_state = "skullP"
	value = 5

/obj/item/skull/odd // Changelings.
	name = "odd skull"
	desc = "What the hell was wrong with this person's FACE?! Were they even human?!"
	icon_state = "skullA"
	value = 4

/obj/item/skull/peculiar // Wizards.
	name = "peculiar skull"
	desc = "You feel extremely uncomfortable near this thing."
	icon_state = "skull_strange"
	value = 3

/obj/item/skull/crystal // Omnitraitors.
	name = "crystal skull"
	desc = "Does this mean there's an alien race with crystal bones somewhere?"
	icon_state = "skull_crystal"
	value = 10

/obj/item/skull/gold // Macho man.
	name = "golden skull"
	desc = "Is this thing solid gold, or just gold-plated? Yeesh."
	icon_state = "skull_gold"
	value = 7

/obj/item/skull/noface // Cluwnes.
	name = "faceless skull"
	desc = "Fuck that's creepy."
	icon_state = "skull_noface"
	value = -1

/*==========================*/
/*---------- Head ----------*/
/*==========================*/

/obj/item/organ/head // vOv
	name = "head"
	organ_name = "head"
	desc = "Well, shit."
	icon = 'icons/mob/human_head.dmi'
	icon_state = "head"
	edible = 0
	rand_pos = 0 // we wanna override it below

	var/obj/item/organ/brain/brain = null
	var/obj/item/skull/skull = null
	var/obj/item/organ/eye/left_eye = null
	var/obj/item/organ/eye/right_eye = null

	var/datum/appearanceHolder/donor_appearance = null
	var/datum/mutantrace/donor_mutantrace = null

	var/icon/head_icon = null

	// equipped items - they use the same slot names because eh.
	var/obj/item/clothing/head/head = null
	var/obj/item/clothing/ears/ears = null
	var/obj/item/clothing/mask/wear_mask = null
	var/obj/item/clothing/glasses/glasses = null

	New()
		..()
		spawn(10)
			if (src.donor)
				src.bones = new /datum/bone(src)
				src.bones.donor = src.donor
				src.bones.parent_organ = src.organ_name
				src.bones.name = "ribs"
				if (src.donor.bioHolder && src.donor.bioHolder.mobAppearance)
					src.donor_appearance = src.donor.bioHolder.mobAppearance

				else //The heck?
					src.donor_appearance = new(src)

				if (src.donor.mutantrace)
					src.donor_mutantrace = src.donor.mutantrace
				src.update_icon()
			src.pixel_y = rand(-20,-8)
			src.pixel_x = rand(-8,8)

	get_desc()
		if (src.ears)
			. += "<br><span style=\"color:blue\">[src.name] has a [bicon(src.ears)] [src.ears.name] by its mouth.</span>"

		if (src.head)
			if (src.head.blood_DNA)
				. += "<br><span style=\"color:red\">[src.name] has a[src.head.blood_DNA ? " bloody " : " "][bicon(src.head)] [src.head.name] on it!</span>"
			else
				. += "<br><span style=\"color:blue\">[src.name] has a [bicon(src.head)] [src.head.name] on it.</span>"

		if (src.wear_mask)
			if (src.wear_mask.blood_DNA)
				. += "<br><span style=\"color:red\">[src.name] has a[src.wear_mask.blood_DNA ? " bloody " : " "][bicon(src.wear_mask)] [src.wear_mask.name] on its face!</span>"
			else
				. += "<br><span style=\"color:blue\">[src.name] has a [bicon(src.wear_mask)] [src.wear_mask.name] on its face.</span>"

		if (src.glasses)
			if (((src.wear_mask && src.wear_mask.see_face) || !src.wear_mask) && ((src.head && src.head.see_face) || !src.head))
				if (src.glasses.blood_DNA)
					. += "<br><span style=\"color:red\">[src.name] has a[src.glasses.blood_DNA ? " bloody " : " "][bicon(src.wear_mask)] [src.glasses.name] on its face!</span>"
				else
					. += "<br><span style=\"color:blue\">[src.name] has a [bicon(src.glasses)] [src.glasses.name] on its face.</span>"

		if (src.brain)
			if (src.brain.op_stage > 0.0)
				. += "<br><span style=\"color:red\"><B>[src.name] has an open incision on it!</B></span>"
		else if (!src.brain && src.skull)
			. += "<br><span style=\"color:red\"><B>[src.name] has been cut open and its brain is gone!</B></span>"
		else if (!src.skull)
			. += "<br><span style=\"color:red\"><B>[src.name] no longer has a skull in it, its face is just empty skin mush!</B></span>"

		if (!src.right_eye)
			. += "<br><span style=\"color:red\"><B>[src.name]'s right eye is missing!</B></span>"
		if (!src.left_eye)
			. += "<br><span style=\"color:red\"><B>[src.name]'s left eye is missing!</B></span>"

	proc/update_icon()
		if (!src.donor || !src.donor_appearance)
			return // vOv

		if (src.donor_mutantrace)
			src.head_icon = new /icon(src.icon, src.donor_mutantrace.icon_state)
		else
			src.head_icon = new /icon(src.icon, src.icon_state)

		if (!src.donor_mutantrace || !src.donor_mutantrace.override_skintone)
			if (src.donor_appearance.s_tone >= 0)
				src.head_icon.Blend(rgb(src.donor_appearance.s_tone, src.donor_appearance.s_tone, src.donor_appearance.s_tone), ICON_ADD)
			else
				src.head_icon.Blend(rgb(-src.donor_appearance.s_tone, -src.donor_appearance.s_tone, -src.donor_appearance.s_tone), ICON_SUBTRACT)

		if (!src.donor_mutantrace || !src.donor_mutantrace.override_eyes)
			var/icon/e_icon = new /icon('icons/mob/human_hair.dmi', "eyes")
			var/ecol = src.donor_appearance.e_color
			if (!ecol || length(ecol) > 7)
				ecol = "#000000"
			e_icon.Blend(ecol, ICON_MULTIPLY)
			src.head_icon.Blend(e_icon, ICON_OVERLAY)

		if (!src.donor_mutantrace || !src.donor_mutantrace.override_hair)
			var/icon/h_icon = new /icon('icons/mob/human_hair.dmi', "[customization_styles[src.donor_appearance.customization_first]]")
			var/hcol = src.donor_appearance.customization_first_color
			if (!hcol || length(hcol) > 7)
				hcol = "#000000"
			h_icon.Blend(hcol, ICON_MULTIPLY)
			src.head_icon.Blend(h_icon, ICON_OVERLAY)

		if (!src.donor_mutantrace || !src.donor_mutantrace.override_beard)
			var/icon/f_icon = new /icon('icons/mob/human_hair.dmi', "[customization_styles[src.donor_appearance.customization_second]]")
			var/fcol = src.donor_appearance.customization_second_color
			if (!fcol || length(fcol) > 7)
				fcol = "#000000"
			f_icon.Blend(fcol, ICON_MULTIPLY)
			src.head_icon.Blend(f_icon, ICON_OVERLAY)

		if (!src.donor_mutantrace || !src.donor_mutantrace.override_detail)
			var/icon/d_icon = new /icon('icons/mob/human_hair.dmi', "[customization_styles[src.donor_appearance.customization_third]]")
			var/dcol = src.donor_appearance.customization_third_color
			if (!dcol || length(dcol) > 7)
				dcol = "#000000"
			d_icon.Blend(dcol, ICON_MULTIPLY)
			src.head_icon.Blend(d_icon, ICON_OVERLAY)

		src.icon = src.head_icon

	proc/update_headgear_image()
		src.overlays = null

		if (src.glasses && src.glasses.wear_image_icon)
			src.overlays += image(src.glasses.wear_image_icon, src.glasses.icon_state)

		if (src.wear_mask && src.wear_mask.wear_image_icon)
			src.overlays += image(src.wear_mask.wear_image_icon, src.wear_mask.icon_state)

		if (src.ears && src.ears.wear_image_icon)
			src.overlays += image(src.ears.wear_image_icon, src.ears.icon_state)

		if (src.head && src.head.wear_image_icon)
			src.overlays += image(src.head.wear_image_icon, src.head.icon_state)

	attack(var/mob/living/carbon/M as mob, var/mob/user as mob)
		if (!ismob(M))
			return

		src.add_fingerprint(user)

		if (user.zone_sel.selecting != "head")
			return ..()
		if (!surgeryCheck(M, user))
			return ..()

		var/mob/living/carbon/human/H = M
		if (!H.organHolder)
			return ..()

		if (!H.organHolder.head)

			var/fluff = pick("attach", "shove", "place", "drop", "smoosh", "squish")

			H.tri_message("<span style=\"color:red\"><b>[user]</b> [fluff][(fluff == "smoosh" || fluff == "squish" || fluff == "attach") ? "es" : "s"] [src] onto [H == user ? "[his_or_her(H)]" : "[H]'s"] neck stump!</span>",\
			user, "<span style=\"color:red\">You [fluff] [src] onto [user == H ? "your" : "[H]'s"] neck stump!</span>",\
			H, "<span style=\"color:red\">[H == user ? "You" : "<b>[user]</b>"] [fluff][(fluff == "smoosh" || fluff == "squish" || fluff == "attach") ? "es" : "s"] [src] onto your neck stump!</span>")

			user.u_equip(src)
			H.organHolder.receive_organ(src, "head", 3.0)

			spawn(rand(50,500))
				if (H && H.organHolder && H.organHolder.head && H.organHolder.head == src) // aaaaaa
					if (src.op_stage != 0.0)
						H.visible_message("<span style=\"color:red\"><b>[H]'s head comes loose and tumbles off of [his_or_her(H)] neck!</b></span>",\
						"<span style=\"color:red\"><b>Your head comes loose and tumbles off of your neck!</b></span>")
						H.organHolder.drop_organ("head") // :I

		else
			..()
		return

	attackby(obj/item/W as obj, mob/user as mob) // this is real ugly
		if (src.skull || src.brain)

			// scalpel surgery
			if (istype(W, /obj/item/scalpel) || istype(W, /obj/item/razor_blade) || istype(W, /obj/item/knife_butcher) || istype(W, /obj/item/kitchen/utensil/knife) || istype(W, /obj/item/raw_material/shard))
				if (src.right_eye && src.right_eye.op_stage == 1.0 && user.find_in_hand(W) == user.r_hand)
					playsound(get_turf(src), "sound/weapons/squishcut.ogg", 50, 1)
					user.visible_message("<span style=\"color:red\"><b>[user]</b> cuts away the flesh holding [src]'s right eye in with [W]!</span>",\
					"<span style=\"color:red\">You cut away the flesh holding [src]'s right eye in with [W]!</span>")
					src.right_eye.op_stage = 2.0
				else if (src.left_eye && src.left_eye.op_stage == 1.0 && user.find_in_hand(W) == user.l_hand)
					playsound(get_turf(src), "sound/weapons/squishcut.ogg", 50, 1)
					user.visible_message("<span style=\"color:red\"><b>[user]</b> cuts away the flesh holding [src]'s left eye in with [W]!</span>",\
					"<span style=\"color:red\">You cut away the flesh holding [src]'s left eye in with [W]!</span>")
					src.left_eye.op_stage = 2.0
				else if (src.brain)
					if (src.brain.op_stage == 0.0)
						playsound(get_turf(src), "sound/weapons/squishcut.ogg", 50, 1)
						user.visible_message("<span style=\"color:red\"><b>[user]</b> cuts [src] open with [W]!</span>",\
						"<span style=\"color:red\">You cut [src] open with [W]!</span>")
						src.brain.op_stage = 1.0
					else if (src.brain.op_stage == 2.0)
						playsound(get_turf(src), "sound/weapons/squishcut.ogg", 50, 1)
						user.visible_message("<span style=\"color:red\"><b>[user]</b> removes the connections to [src]'s brain with [W]!</span>",\
						"<span style=\"color:red\">You remove [src]'s connections to [src]'s brain with [W]!</span>")
						src.brain.op_stage = 3.0
					else
						return ..()
				else if (src.skull && src.skull.op_stage == 0.0)
					playsound(get_turf(src), "sound/weapons/squishcut.ogg", 50, 1)
					user.visible_message("<span style=\"color:red\"><b>[user]</b> cuts [src]'s skull away from the skin with [W]!</span>",\
					"<span style=\"color:red\">You cut [src]'s skull away from the skin with [W]!</span>")
					src.skull.op_stage = 1.0
				else
					return ..()

			// saw surgery
			else if (istype(W, /obj/item/circular_saw) || istype(W, /obj/item/saw) || istype(W, /obj/item/kitchen/utensil/fork))
				if (src.brain)
					if (src.brain.op_stage == 1.0)
						playsound(get_turf(src), "sound/weapons/squishcut.ogg", 50, 1)
						user.visible_message("<span style=\"color:red\"><b>[user]</b> saws open [src]'s skull with [W]!</span>",\
						"<span style=\"color:red\">You saw open [src]'s skull with [W]!</span>")
						src.brain.op_stage = 2.0
					else if (src.brain.op_stage == 3.0)
						playsound(get_turf(src), "sound/weapons/squishcut.ogg", 50, 1)
						user.visible_message("<span style=\"color:red\"><b>[user]</b> saws open [src]'s skull with [W]!</span>",\
						"<span style=\"color:red\">You saw open [src]'s skull with [W]!</span>")
						src.brain.set_loc(get_turf(src))
						src.brain = null
					else
						return ..()
				else if (src.skull && src.skull.op_stage == 1.0)
					playsound(get_turf(src), "sound/weapons/squishcut.ogg", 50, 1)
					user.visible_message("<span style=\"color:red\"><b>[user]</b> saws [src]'s skull out with [W]!</span>",\
					"<span style=\"color:red\">You saw [src]'s skull out with [W]!</span>")
					src.skull.set_loc(get_turf(src))
					src.skull = null
				else
					return ..()

			// spoon surgery
			else if (istype(W, /obj/item/surgical_spoon) || istype(W, /obj/item/kitchen/utensil/spoon))
				if (src.right_eye && src.right_eye.op_stage == 0.0 && user.find_in_hand(W) == user.r_hand)
					playsound(get_turf(src), "sound/weapons/squishcut.ogg", 50, 1)
					user.visible_message("<span style=\"color:red\"><b>[user]</b> inserts [W] into [src]'s right eye socket!</span>",\
					"<span style=\"color:red\">You insert [W] into [src]'s right eye socket!</span>")
					src.right_eye.op_stage = 1.0
				else if (src.left_eye && src.left_eye.op_stage == 0.0 && user.find_in_hand(W) == user.l_hand)
					playsound(get_turf(src), "sound/weapons/squishcut.ogg", 50, 1)
					user.visible_message("<span style=\"color:red\"><b>[user]</b> inserts [W] into [src]'s left eye socket!</span>",\
					"<span style=\"color:red\">You insert [W] into [src]'s left eye socket!</span>")
					src.left_eye.op_stage = 1.0
				else if (src.right_eye && src.right_eye.op_stage == 2.0 && user.find_in_hand(W) == user.r_hand)
					playsound(get_turf(src), "sound/weapons/squishcut.ogg", 50, 1)
					user.visible_message("<span style=\"color:red\"><b>[user]</b> removes [src]'s right eye with [W]!</span>",\
					"<span style=\"color:red\">You remove [src]'s right eye with [W]!</span>")
					src.right_eye.set_loc(get_turf(src))
					src.right_eye = null
				else if (src.left_eye && src.left_eye.op_stage == 2.0 && user.find_in_hand(W) == user.l_hand)
					playsound(get_turf(src), "sound/weapons/squishcut.ogg", 50, 1)
					user.visible_message("<span style=\"color:red\"><b>[user]</b> removes [src]'s left eye with [W]!</span>",\
					"<span style=\"color:red\">You remove [src]'s left eye with [W]!</span>")
					src.left_eye.set_loc(get_turf(src))
					src.left_eye = null
				else
					return ..()

			else
				return ..()
		else
			return ..()

/*===========================*/
/*---------- Torso ----------*/
/*===========================*/

/obj/item/organ/chest // basically a dummy thing right now, this shouldn't do anything or go anywhere
	name = "chest"
	organ_name = "chest"
	desc = "Oh, crap."
	icon_state = "chest_m"
	edible = 0

	var/datum/appearanceHolder/donor_appearance = null
	//var/datum/mutantrace/donor_mutantrace = null

	var/icon/body_icon = null

	New()
		..()
		spawn(10)
			if (src.donor)
				src.bones = new /datum/bone(src)
				src.bones.donor = src.donor
				src.bones.parent_organ = src.organ_name
				src.bones.name = "skull"
				if (src.donor.bioHolder && src.donor.bioHolder.mobAppearance)
					src.donor_appearance = new(src)
					src.donor_appearance.CopyOther(src.donor.bioHolder.mobAppearance)
				src.update_icon()

	proc/update_icon()
		if (!src.donor || !src.donor_appearance)
			return // vOv

		src.body_icon = new /icon(src.icon, src.icon_state)

		if (src.donor_appearance.s_tone >= 0)
			src.body_icon.Blend(rgb(src.donor_appearance.s_tone, src.donor_appearance.s_tone, src.donor_appearance.s_tone), ICON_ADD)
		else
			src.body_icon.Blend(rgb(-src.donor_appearance.s_tone, -src.donor_appearance.s_tone, -src.donor_appearance.s_tone), ICON_SUBTRACT)

		src.body_icon.Blend(icon(src.icon, "chest_blood"), ICON_OVERLAY)

		src.icon = src.body_icon

/*=========================*/
/*---------- WIP ----------*/
/*=========================*/

/obj/item/organ/liver
	name = "liver"
	desc = "Ew, this thing is just the wurst."
	icon_state = "liver"

/obj/item/organ/kidney
	name = "kidneys"
	desc = "Bean shaped, but not actually beans. You can still eat them, though!"
	icon_state = "kidneys"

/obj/item/organ/kidney/left
	name = "left kidney"
	icon_state = "kidney_L"
	body_side = L_ORGAN

/obj/item/organ/kidney/right
	name = "right kidney"
	icon_state = "kidney_R"
	body_side = R_ORGAN

/obj/item/organ/stomach
	name = "stomach"
	desc = "A little meat sack containing acid for the digestion of food. Like most things that come out of living creatures, you can probably eat it."
	icon_state = "stomach"

/obj/item/organ/intestines
	name = "intestines"
	desc = "Did you know that if you laid your guts out in a straight line, they'd be about 9 meters long? Also, you'd probably be dying, so it's not something you should do. Probably."
	icon_state = "intestines"

/obj/item/organ/spleen
	name = "spleen"
	icon_state = "spleen"

/obj/item/organ/pancreas
	name = "pancreas"
	icon_state = "pancreas"

/obj/item/organ/appendix
	name = "appendix"
	icon_state = "appendix"

#undef L_ORGAN
#undef R_ORGAN