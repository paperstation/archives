/*
CONTAINS:
RETRACTOR
HEMOSTAT
CAUTERY
SURGICAL DRILL
SCALPEL
CIRCULAR SAW

*/

/////////////
//RETRACTOR//
/////////////
/obj/item/weapon/retractor/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M))
		return

	if(!((locate(/obj/machinery/optable, M.loc) && M.resting) || (locate(/obj/table/, M.loc) && (M.lying || M.weakened || M.stunned || M.paralysis || M.sleeping || M.stat) && prob(50))))
		return ..()

	if (user.zone_sel.selecting == "eyes")

		var/mob/living/carbon/human/H = M
		if(istype(H) && ( \
				(H.head && H.head.flags & HEADCOVERSEYES) || \
				(H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) || \
				(H.glasses && H.glasses.flags & GLASSESCOVERSEYES) \
			))
			user << "\red You're going to need to remove that mask/helmet/glasses first."
			return

		var/mob/living/carbon/monkey/Mo = M
		if(istype(Mo) && ( \
				(Mo.wear_mask && Mo.wear_mask.flags & MASKCOVERSEYES) \
			))
			user << "\red You're going to need to remove that mask/helmet/glasses first."
			return

		if(istype(M, /mob/living/carbon/alien) || istype(M, /mob/living/carbon/metroid))//Aliens don't have eyes./N
			user << "\red You cannot locate any eyes on this creature!"
			return

		switch(M.eye_op_stage)
			if(1.0)
				if(M != user)
					for(var/mob/O in (viewers(M) - user - M))
						O.show_message("\red [M] is having his eyes retracted by [user].", 1)
					M << "\red [user] begins to seperate your eyes with [src]!"
					user << "\red You seperate [M]'s eyes with [src]!"
				else
					user.visible_message( \
						"\red [user] begins to have his eyes retracted.", \
						"\red You begin to pry open your eyes with [src]!" \
					)
				if(M == user && prob(25))
					user << "\red You mess up!"
					if(istype(M, /mob/living/carbon/human))
						var/datum/organ/external/affecting = M:organs["head"]
						affecting.take_damage(15)
						M.updatehealth()
					else
						M.take_organ_damage(15)

				M:eye_op_stage = 2.0

	else if((!(user.zone_sel.selecting == "head")) || (!(user.zone_sel.selecting == "groin")) || (!(istype(M, /mob/living/carbon/human))))
		return ..()

	return

////////////
//Hemostat//
////////////

/obj/item/weapon/hemostat/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M))
		return

	if(!((locate(/obj/machinery/optable, M.loc) && M.resting) || (locate(/obj/table/, M.loc) && M.lying && prob(50))))
		return ..()

	if (user.zone_sel.selecting == "eyes")

		var/mob/living/carbon/human/H = M
		if(istype(H) && ( \
				(H.head && H.head.flags & HEADCOVERSEYES) || \
				(H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) || \
				(H.glasses && H.glasses.flags & GLASSESCOVERSEYES) \
			))
			user << "\red You're going to need to remove that mask/helmet/glasses first."
			return

		var/mob/living/carbon/monkey/Mo = M
		if(istype(Mo) && ( \
				(Mo.wear_mask && Mo.wear_mask.flags & MASKCOVERSEYES) \
			))
			user << "\red You're going to need to remove that mask/helmet/glasses first."
			return

		if(istype(M, /mob/living/carbon/alien))//Aliens don't have eyes./N
			user << "\red You cannot locate any eyes on this creature!"
			return

		switch(M.eye_op_stage)
			if(2.0)
				if(M != user)
					for(var/mob/O in (viewers(M) - user - M))
						O.show_message("\red [M] is having his eyes mended by [user].", 1)
					M << "\red [user] begins to mend your eyes with [src]!"
					user << "\red You mend [M]'s eyes with [src]!"
				else
					user.visible_message( \
						"\red [user] begins to have his eyes mended.", \
						"\red You begin to mend your eyes with [src]!" \
					)
				if(M == user && prob(25))
					user << "\red You mess up!"
					if(istype(M, /mob/living/carbon/human))
						var/datum/organ/external/affecting = M:organs["head"]
						affecting.take_damage(15)
						M.updatehealth()
					else
						M.take_organ_damage(15)
				M:eye_op_stage = 3.0

	else if((!(user.zone_sel.selecting == "head")) || (!(user.zone_sel.selecting == "groin")) || (!(istype(M, /mob/living/carbon/human))))
		return ..()

	return

///////////
//Cautery//
///////////

/obj/item/weapon/cautery/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M))
		return

	if(!((locate(/obj/machinery/optable, M.loc) && M.resting) || (locate(/obj/table/, M.loc) && M.lying && prob(50))))
		return ..()

	if (user.zone_sel.selecting == "eyes")

		var/mob/living/carbon/human/H = M
		if(istype(H) && ( \
				(H.head && H.head.flags & HEADCOVERSEYES) || \
				(H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) || \
				(H.glasses && H.glasses.flags & GLASSESCOVERSEYES) \
			))
			user << "\red You're going to need to remove that mask/helmet/glasses first."
			return

		var/mob/living/carbon/monkey/Mo = M
		if(istype(Mo) && ( \
				(Mo.wear_mask && Mo.wear_mask.flags & MASKCOVERSEYES) \
			))
			user << "\red You're going to need to remove that mask/helmet/glasses first."
			return

		if(istype(M, /mob/living/carbon/alien))//Aliens don't have eyes./N
			user << "\red You cannot locate any eyes on this creature!"
			return

		switch(M.eye_op_stage)
			if(3.0)
				if(M != user)
					for(var/mob/O in (viewers(M) - user - M))
						O.show_message("\red [M] is having his eyes cauterized by [user].", 1)
					M << "\red [user] begins to cauterize your eyes!"
					playsound(src.loc, 'cauterize.ogg', 30, 0)
					user << "\red You cauterize [M]'s eyes with [src]!"
				else
					user.visible_message( \
						"\red [user] begins to have his eyes cauterized.", \
						"\red You begin to cauterize your eyes!" \
					)
				if(M == user && prob(25))
					user << "\red You mess up!"
					if(istype(M, /mob/living/carbon/human))
						var/datum/organ/external/affecting = M:organs["head"]
						affecting.take_damage(15)
						M.updatehealth()
					else
						M.take_organ_damage(15)
				M.sdisabilities &= ~1
				M:eye_op_stage = 0.0

	if(user.zone_sel.selecting == "l_arm" && M.l_arm_op_stage == 1)
		if(M.l_arm_op_stage == 2)
			user << "\red The blood vessels have been cauterized."
			return
		if(!M:hasPart("arm_left") && M.lying)
			user << "\red You cauterize broken blood vessels on [M]."
			playsound(src.loc, 'cauterize.ogg', 30, 0)
			M << "\red [user] cauterizes your broken blood vessels."
			M.l_armbloodloss = 0
			M.l_arm_op_stage = 3
			return

	if(user.zone_sel.selecting == "r_arm" && M.r_arm_op_stage == 1)
		if(M.r_arm_op_stage == 2)
			user << "\red The blood vessels have been cauterized."
			return
		if(!M:hasPart("arm_right") && M.lying)
			user << "\red You cauterize broken blood vessels on [M]."
			playsound(src.loc, 'cauterize.ogg', 30, 0)
			M << "\red [user] starts cauterizes your broken blood vessels."
			M.r_armbloodloss = 0
			M.r_arm_op_stage = 3
			return

	if(user.zone_sel.selecting == "l_leg" && M.l_leg_op_stage == 1)
		if(M.l_leg_op_stage == 2)
			user << "\red The blood vessels have been cauterized."
			return
		if(!M:hasPart("leg_left") && M.lying)
			user << "\red You cauterize broken blood vessels on [M]."
			playsound(src.loc, 'cauterize.ogg', 30, 0)
			M << "\red [user] starts cauterizes your broken blood vessels."
			M.l_legbloodloss = 0
			M.l_leg_op_stage = 3
			return

	if(user.zone_sel.selecting == "r_leg" && M.r_leg_op_stage == 1)
		if(M.r_leg_op_stage == 2)
			user << "\red The blood vessels have been cauterized."
			return
		if(!M:hasPart("leg_right") && M.lying)
			user << "\red You cauterize broken blood vessels on [M]."
			playsound(src.loc, 'cauterize.ogg', 30, 0)
			M << "\red [user] starts cauterizes your broken blood vessels."
			M.r_legbloodloss = 0
			M.r_leg_op_stage = 3
			return

	else if((!(user.zone_sel.selecting == "head")) || (!(user.zone_sel.selecting == "groin")) || (!(istype(M, /mob/living/carbon/human))))
		return ..()

	return


//////////////////
//SURGICAL DRILL//
//////////////////

//Limb replacement
/obj/item/weapon/surgicaldrill/attack(mob/living/carbon/human/M as mob, mob/living/carbon/human/user as mob)
	if(istype(M) && istype(user) && M.lying)
		if(user.zone_sel.selecting == "l_arm" && M.l_arm_op_stage == 0)
			if(M.l_arm_op_stage)
				user << "\red The bone has already been cleaned."
				return
			if(!M.hasPart("arm_left") && M.lying)
				user << "\red You drill away excess bone shards from [M]."
				playsound(src.loc, 'bonedrill.ogg', 30, 0)
				M.l_armbloodloss = 1
				M << "\red [user] starts to drill away at your arm."
				M.l_arm_op_stage = 1
				return
		if(user.zone_sel.selecting == "r_arm" && M.r_arm_op_stage == 0)
			if(M.r_arm_op_stage)
				user << "\red The bone has already been cleaned."
				return
			if(!M.hasPart("arm_right") && M.lying)
				user << "\red You drill away excess bone shards from [M]."
				playsound(src.loc, 'bonedrill.ogg', 30, 0)
				M.r_armbloodloss = 1
				M << "\red [user] starts to drill away at your arm."
				M.r_arm_op_stage = 1
				return
		if(user.zone_sel.selecting == "l_leg" && M.l_leg_op_stage == 0)
			if(M.l_leg_op_stage)
				user << "\red The bone has already been cleaned."
				return
			if(!M.hasPart("leg_left") && M.lying)
				user << "\red You drill away excess bone shards from [M]."
				playsound(src.loc, 'bonedrill.ogg', 30, 0)
				M.l_legbloodloss = 1
				M << "\red [user] starts to drill away at your arm."
				M.l_leg_op_stage = 1
				return
		if(user.zone_sel.selecting == "r_leg" && M.r_leg_op_stage == 0)
			if(M.r_leg_op_stage)
				user << "\red The bone has already been cleaned."
				return
			if(!M.hasPart("leg_right") && M.lying)
				user << "\red You drill away excess bone shards from [M]."
				playsound(src.loc, 'bonedrill.ogg', 30, 0)
				M.r_legbloodloss = 1
				M << "\red [user] starts to drill away at your arm."
				M.r_leg_op_stage = 1
				return
	..()

/////////////////
//SURGICAL TUBE//
/////////////////
/obj/item/weapon/surgicaltube/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if (istype(W, /obj/item/weapon/reagent_containers/syringe) && !cannula)
		cannula = 1
		del(W)
		icon_state = "surgicaltube"
		overlays += image('chemical.dmi', "surgicaltube_cannula")
		user << "\blue You use the end of the syringe to make a cannula for the surgical tube!"
	if (istype(W, /obj/item/weapon/reagent_containers/glass/large/iv_bag) && !istype(src.loc, /obj/item/weapon/reagent_containers/glass/large/iv_bag))
		if(!W:tube)
			W.icon_state = "ivbag_surgicaltube"
			W:tube = src
			src.loc = W
			user.client.screen -= src
			user << "\blue You clamp the end of of the tubing around the [W.name]'s IV port!"
			if(cannula)
				W.overlays += image('chemical.dmi', "surgicaltube_cannula")
				W:cannula = 1
				W:on_reagent_change()
		else
			user << "\red There's already a tube hooked up to the [W.name]!"

///////////
//SCALPEL//
///////////
/obj/item/weapon/scalpel/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M))
		return ..()

	if((user.mutations & CLOWN) && prob(50))
		M = user
		return eyestab(M,user)

	if(!((locate(/obj/machinery/optable, M.loc) && M.resting) || (locate(/obj/table/, M.loc) && M.lying && prob(50))))
		return ..()

	src.add_fingerprint(user)

	if(user.zone_sel.selecting == "head" || istype(M, /mob/living/carbon/metroid))

		var/mob/living/carbon/human/H = M
		if(istype(H) && ( \
				(H.head && H.head.flags & HEADCOVERSEYES) || \
				(H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) || \
				(H.glasses && H.glasses.flags & GLASSESCOVERSEYES) \
			))
			user << "\red You're going to need to remove that mask/helmet/glasses first."
			return

		var/mob/living/carbon/monkey/Mo = M
		if(istype(Mo) && ( \
				(Mo.wear_mask && Mo.wear_mask.flags & MASKCOVERSEYES) \
			))
			user << "\red You're going to need to remove that mask/helmet/glasses first."
			return

		switch(M:brain_op_stage)
			if(0.0)
				if(istype(M, /mob/living/carbon/metroid))
					if(M.stat == 2)
						for(var/mob/O in (viewers(M) - user - M))
							O.show_message("\red [M.name] is beginning to have its flesh cut open with [src] by [user].", 1)
						M << "\red [user] begins to cut open your flesh with [src]!"
						user << "\red You cut [M]'s flesh open with [src]!"
						M:brain_op_stage = 1.0

					return

				if(M != user)
					for(var/mob/O in (viewers(M) - user - M))
						O.show_message("\red [M] is beginning to have his head cut open with [src] by [user].", 1)
					M << "\red [user] begins to cut open your head with [src]!"
					user << "\red You cut [M]'s head open with [src]!"
				else
					user.visible_message( \
						"\red [user] begins to cut open his skull with [src]!", \
						"\red You begin to cut open your head with [src]!" \
					)

				if(M == user && prob(25))
					user << "\red You mess up!"
					if(istype(M, /mob/living/carbon/human))
						var/datum/organ/external/affecting = M:organs["head"]
						affecting.take_damage(15)
					else
						M.take_organ_damage(15)

				if(istype(M, /mob/living/carbon/human))
					var/datum/organ/external/affecting = M:organs["head"]
					affecting.take_damage(7)
				else
					M.take_organ_damage(7)

				M.updatehealth()
				M:brain_op_stage = 1.0

			if(1)
				if(istype(M, /mob/living/carbon/metroid))
					if(M.stat == 2)
						for(var/mob/O in (viewers(M) - user - M))
							O.show_message("\red [M.name] is having its silky inndards cut apart with [src] by [user].", 1)
						M << "\red [user] begins to cut apart your innards with [src]!"
						user << "\red You cut [M]'s silky innards apart with [src]!"
						M:brain_op_stage = 2.0
					return
			if(2.0)
				if(istype(M, /mob/living/carbon/metroid))
					if(M.stat == 2)
						var/mob/living/carbon/metroid/Metroid = M
						if(Metroid.cores > 0)
							if(istype(M, /mob/living/carbon/metroid))
								user << "\red You attempt to remove [M]'s core, but [src] is ineffective!"
					return

				if(M != user)
					for(var/mob/O in (viewers(M) - user - M))
						O.show_message("\red [M] is having his connections to the brain delicately severed with [src] by [user].", 1)
					M << "\red [user] begins to cut open your head with [src]!"
					user << "\red You cut [M]'s head open with [src]!"
				else
					user.visible_message( \
						"\red [user] begin to delicately remove the connections to his brain with [src]!", \
						"\red You begin to cut open your head with [src]!" \
					)
				if(M == user && prob(25))
					user << "\red You nick an artery!"
					if(istype(M, /mob/living/carbon/human))
						var/datum/organ/external/affecting = M:organs["head"]
						affecting.take_damage(75)
					else
						M.take_organ_damage(75)

				if(istype(M, /mob/living/carbon/human))
					var/datum/organ/external/affecting = M:organs["head"]
					affecting.take_damage(7)
				else
					M.take_organ_damage(7)

				M.updatehealth()
				M:brain_op_stage = 3.0
			else
				..()
		return


	if(user.zone_sel.selecting == "chest")
		if(M.chest_op_stage == 0 && M.lying)
			user.visible_message("\red [M] has their abdomen cut open by [user]")
			M.chest_op_stage = 1
			return
		if(M.chest_op_stage == 1 && M.lying && (M.mutations & 32))
			user.visible_message("\red [M] has their fat cut out by [user]")
			M.overeatduration = 0
			M.chest_op_stage = 0
			return //Shitty, will be relooked at
		else
			..()
		return

	else if(user.zone_sel.selecting == "groin")

		switch(M:butt_op_stage)
			if(0.0)
				for(var/mob/O in viewers(M, null))
					if(O == (user || M))
						continue
					if(M == user)
						O.show_message(text("\red [user] begins to cut open his butt with [src]!"), 1)
					else
						O.show_message(text("\red [M] is beginning to have his butt cut open with [src] by [user]."), 1)

				if(M != user)
					M << "\red [user] begins to cut open your butt with [src]!"
					user << "\red You cut [M]'s butt open with [src]!"
				else
					user << "\red You begin to cut open your butt with [src]!"
					if(prob(25))
						user << "\red You mess up!"
						M.bruteloss += 15

				if(istype(M, /mob/living/carbon/human))
					var/datum/organ/external/affecting = M:organs["groin"]
					affecting.take_damage(7)
				else
					M.bruteloss += 7

				M.updatehealth()
				M:butt_op_stage = 1.0
			if(2.0)
				for(var/mob/O in viewers(M, null))
					if(O == (user || M))
						continue
					if(M == user)
						O.show_message(text("\red [user] begin to delicately slice the intestines with [src]!"), 1)
					else
						O.show_message(text("\red [M] is having his intestines delicately severed with [src] by [user]."), 1)

				if(M != user)
					M << "\red [user] begins to cut open your butt with [src]!"
					user << "\red You cut [M]'s butt open with [src]!"
				else
					user << "\red You begin to delicately slice the intestines with [src]!"
					if(prob(25))
						user << "\red You nick an artery!"
						M.bruteloss += 75

				if(istype(M, /mob/living/carbon/human))
					var/datum/organ/external/affecting = M:organs["groin"]
					affecting.take_damage(7)
				else
					M.bruteloss += 7

				M.updatehealth()
				M:butt_op_stage = 3.0

			else
				..()
		return

	else if(user.zone_sel.selecting == "eyes")
		user << "\blue So far so good."

		var/mob/living/carbon/human/H = M
		if(istype(H) && ( \
				(H.head && H.head.flags & HEADCOVERSEYES) || \
				(H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) || \
				(H.glasses && H.glasses.flags & GLASSESCOVERSEYES) \
			))
			user << "\red You're going to need to remove that mask/helmet/glasses first."
			return

		var/mob/living/carbon/monkey/Mo = M
		if(istype(Mo) && ( \
				(Mo.wear_mask && Mo.wear_mask.flags & MASKCOVERSEYES) \
			))
			user << "\red You're going to need to remove that mask/helmet/glasses first."
			return

		if(istype(M, /mob/living/carbon/alien) || istype(M, /mob/living/carbon/metroid))//Aliens don't have eyes./N
			user << "\red You cannot locate any eyes on this creature!"
			return

		switch(M:eye_op_stage)
			if(0.0)
				if(M != user)
					for(var/mob/O in (viewers(M) - user - M))
						O.show_message("\red [M] is beginning to have his eyes incised with [src] by [user].", 1)
					M << "\red [user] begins to cut open your eyes with [src]!"
					user << "\red You make an incision around [M]'s eyes with [src]!"
				else
					user.visible_message( \
						"\red [user] begins to cut around his eyes with [src]!", \
						"\red You begin to cut open your eyes with [src]!" \
					)
				if(M == user && prob(25))
					user << "\red You mess up!"
					if(istype(M, /mob/living/carbon/human))
						var/datum/organ/external/affecting = M:organs["head"]
						affecting.take_damage(15)
					else
						M.take_organ_damage(15)

				user << "\blue So far so good before."
				M.updatehealth()
				M:eye_op_stage = 1.0
				user << "\blue So far so good after."
	else
		return ..()
/* wat
	else if((!(user.zone_sel.selecting == "head")) || (!(user.zone_sel.selecting == "groin")) || (!(istype(M, /mob/living/carbon/human))))
		return ..()
*/
	return


////////////////
//CIRCULAR SAW//
////////////////

/obj/item/weapon/circular_saw/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M))
		return ..()

	if((user.mutations & CLOWN) && prob(50))
		M = user
		return eyestab(M,user)

	if(!((locate(/obj/machinery/optable, M.loc) && M.resting) || (locate(/obj/table/, M.loc) && M.lying && prob(50))))
		return ..()

	src.add_fingerprint(user)


	if((M.lying) && (istype(M, /mob/living/carbon/human)))
		switch(user.zone_sel.selecting)
			//if("head")
			//	if(M.hasPart("head"))
			//		user.visible_message("\red [src] whines as [user] starts to saw off [M]'s head.")
			//		if(do_after(user, 50))
			//			user.visible_message("\red [user] saws off [M]'s head!")
			//			M.removePart("head")
			//		return
			if("l_arm")
				if(M:hasPart("arm_left"))
					user.visible_message("\red [src] whines as [user] starts to saw off [M]'s left arm.")
					playsound(src.loc, 'bonesaw.ogg', 30, 0)
					if(do_after(user, 50))
						user.visible_message("\red [user] saws off [M]'s left arm!")
						M:removePart("arm_left")
					return
			if("r_arm")
				if(M:hasPart("arm_right"))
					user.visible_message("\red [src] whines as [user] starts to saw off [M]'s right arm.")
					playsound(src.loc, 'bonesaw.ogg', 30, 0)
					if(do_after(user, 50))
						user.visible_message("\red [user] saws off [M]'s right arm!")
						M:removePart("arm_right")
					return
			if("l_leg")
				if(M:hasPart("leg_left"))
					user.visible_message("\red [src] whines as [user] starts to saw off [M]'s left leg.")
					playsound(src.loc, 'bonesaw.ogg', 30, 0)
					if(do_after(user, 50))
						user.visible_message("\red [user] saws off [M]'s left leg!")
						M:removePart("leg_left")
					return
			if("r_leg")
				if(M:hasPart("leg_right"))
					user.visible_message("\red [src] whines as [user] starts to saw off [M]'s right leg.")
					playsound(src.loc, 'bonesaw.ogg', 30, 0)
					if(do_after(user, 50))
						user.visible_message("\red [user] saws off [M]'s right leg!")
						M:removePart("leg_right")
					return


	if(user.zone_sel.selecting == "groin")

		switch(M:penis_op_stage)
			if(0.0)
				for(var/mob/O in viewers(M, null))
					if(O == (user || M))
						continue
					if(M == user)
						O.show_message(text("\red [user] begins to cut off his penis with [src]!"), 1)
					else
						O.show_message(text("\red [M] is beginning to have his penis cut open with [src] by [user]."), 1)

				if(M != user)
					M << "\red [user] begins to cut open your penis with [src]!"
					user << "\red You cut [M]'s penis open with [src]!"
				else
					user << "\red You begin to cut open your penis with [src]!"
					if(prob(25))
						user << "\red You mess up!"
						M.bruteloss += 15

				if(istype(M, /mob/living/carbon/human))
					var/datum/organ/external/affecting = M:organs["groin"]
					affecting.take_damage(7)
				else
					M.bruteloss += 7

				M.updatehealth()
				M:penis_op_stage = 1.0
			if(1.0)
				for(var/mob/O in viewers(M, null))
					if(O == (user || M))
						continue
					if(M == user)
						O.show_message(text("\red [user] begin to delicately slice the intestines with [src]!"), 1)
					else
						O.show_message(text("\red [M] is having his intestines delicately severed with [src] by [user]."), 1)

				if(M != user)
					M << "\red [user] begins to cut open your penis with [src]!"
					user << "\red You cut [M]'s penis open with [src]!"
				else
					user << "\red You begin to delicately slice the intestines with [src]!"
					if(prob(25))
						user << "\red You nick an artery!"
						M.bruteloss += 75

				if(istype(M, /mob/living/carbon/human))
					var/datum/organ/external/affecting = M:organs["groin"]
					affecting.take_damage(7)
				else
					M.bruteloss += 7

				M.updatehealth()
				M:penis_op_stage = 4.0

				var/obj/item/weapon/storage/cock/B = new /obj/item/weapon/storage/cock(M.loc)
				B.name = "[M.name]'s penis"
				new /obj/decal/cleanable/cum(M.loc)

			else
				..()
		return

	if(user.zone_sel.selecting == "head" || istype(M, /mob/living/carbon/metroid))

		var/mob/living/carbon/human/H = M
		if(istype(H) && ( \
				(H.head && H.head.flags & HEADCOVERSEYES) || \
				(H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) || \
				(H.glasses && H.glasses.flags & GLASSESCOVERSEYES) \
			))
			user << "\red You're going to need to remove that mask/helmet/glasses first."
			return

		var/mob/living/carbon/monkey/Mo = M
		if(istype(Mo) && ( \
				(Mo.wear_mask && Mo.wear_mask.flags & MASKCOVERSEYES) \
			))
			user << "\red You're going to need to remove that mask/helmet/glasses first."
			return

		switch(M:brain_op_stage)
			if(1.0)
				if(istype(M, /mob/living/carbon/metroid))
					return
				if(M != user)
					for(var/mob/O in (viewers(M) - user - M))
						O.show_message("\red [M] has his skull sawed open with [src] by [user].", 1)
					M << "\red [user] begins to saw open your head with [src]!"
					user << "\red You saw [M]'s head open with [src]!"
				else
					user.visible_message( \
						"\red [user] saws open his skull with [src]!", \
						"\red You begin to saw open your head with [src]!" \
					)
				if(M == user && prob(25))
					user << "\red You mess up!"
					if(istype(M, /mob/living/carbon/human))
						var/datum/organ/external/affecting = M:organs["head"]
						affecting.take_damage(40)
						M.updatehealth()
					else
						M.take_organ_damage(40)

				if(istype(M, /mob/living/carbon/human))
					var/datum/organ/external/affecting = M:organs["head"]
					affecting.take_damage(7)
				else
					M.take_organ_damage(7)

				M.updatehealth()
				M:brain_op_stage = 2.0

			if(2.0)
				if(istype(M, /mob/living/carbon/metroid))
					if(M.stat == 2)
						var/mob/living/carbon/metroid/Metroid = M
						if(Metroid.cores > 0)
							for(var/mob/O in (viewers(M) - user - M))
								O.show_message("\red [M.name] is having one of its cores sawed out with [src] by [user].", 1)

							Metroid.cores--
							M << "\red [user] begins to remove one of your cores with [src]! ([Metroid.cores] cores remaining)"
							user << "\red You cut one of [M]'s cores out with [src]! ([Metroid.cores] cores remaining)"

							new/obj/item/weapon/reagent_containers/glass/metroidcore(M.loc)

							if(Metroid.cores <= 0)
								M.icon_state = "baby metroid dead-nocore"

					return

			if(3.0)
				if(M != user)
					for(var/mob/O in (viewers(M) - user - M))
						O.show_message("\red [M] has his spine's connection to the brain severed with [src] by [user].", 1)
					M << "\red [user] severs your brain's connection to the spine with [src]!"
					user << "\red You sever [M]'s brain's connection to the spine with [src]!"
				else
					user.visible_message( \
						"\red [user] severs his brain's connection to the spine with [src]!", \
						"\red You sever your brain's connection to the spine with [src]!" \
					)

				var/obj/item/brain/B = new(M.loc)
				B.transfer_identity(M)

				M:brain_op_stage = 4.0
				M.death()//You want them to die after the brain was transferred, so not to trigger client 	death() twice.

			else
				..()
		return

	else if(user.zone_sel.selecting == "groin")
		switch(M:butt_op_stage)
			if(1.0)
				for(var/mob/O in viewers(M, null))
					if(O == (user || M))
						continue
					if(M == user)
						O.show_message(text("\red [user] saws open his butt with [src]!"), 1)
					else
						O.show_message(text("\red [M] has his butt sawed open with [src] by [user]."), 1)

				if(M != user)
					M << "\red [user] begins to saw open your butt with [src]!"
					user << "\red You saw [M]'s butt open with [src]!"
				else
					user << "\red You begin to saw open your butt with [src]!"
					if(prob(25))
						user << "\red You mess up!"
						M.bruteloss += 40

				if(istype(M, /mob/living/carbon/human))
					var/datum/organ/external/affecting = M:organs["groin"]
					affecting.take_damage(7)
				else
					M.bruteloss += 7

				M.updatehealth()
				M:butt_op_stage = 2.0

			if(3.0)
				for(var/mob/O in viewers(M, null))
					if(O == (user || M))
						continue
					if(M == user)
						O.show_message(text("\red [user] severs his butt's connection to the stomach with [src]!"), 1)
					else
						O.show_message(text("\red [M] has his stomach's connenction to the butt severed with [src] by [user]."), 1)

				if(M != user)
					M << "\red [user] severs your butt's connection to the stomach with [src]!"
					user << "\red You sever [M]'s butt's connection to the stomach with [src]!"
				else
					user << "\red You sever your butt's connection to the stomach with [src]!"

				M:butt_op_stage = 4.0

				var/obj/item/clothing/head/butt/B = new /obj/item/clothing/head/butt(M.loc)
				new /obj/decal/cleanable/poo(M.loc)
				B.owner = M

			else
				..()
		return

	else if((!(user.zone_sel.selecting == "head")) || (!(user.zone_sel.selecting == "groin")) || (!(istype(M, /mob/living/carbon/human))))
		return ..()

	return

/obj/item/clothing/head/butt
	name = "butt"
	icon = 'surgery.dmi'
	icon_state = "butt"
	flags = TABLEPASS
	force = 4.0
	w_class = 1.0
	throwforce = 2
	throw_speed = 3
	throw_range = 5
	var/s_tone = 0.0

	var/mob/living/carbon/human/owner = null

/obj/item/clothing/head/butt/New()
	..()
	spawn(5)
		if(src.owner)
			var/icon/new_icon = icon('surgery.dmi', "butt")
			src.s_tone = src.owner.s_tone
			if (src.s_tone >= 0)
				new_icon.Blend(rgb(src.s_tone, src.s_tone, src.s_tone), ICON_ADD)
			else
				new_icon.Blend(rgb(-src.s_tone,  -src.s_tone,  -src.s_tone), ICON_SUBTRACT)
			src.icon = new_icon
			src.name = "[src.owner]'s butt"


/////////////////
//ROBOTIC LIMBS//
/////////////////

/obj/item/robot_parts/l_arm/attack(mob/living/carbon/human/M as mob, mob/living/carbon/human/user as mob)
	if(istype(M) && istype(user))
		if(M.l_arm_op_stage == 3)
			user.drop_item()
			user << "\red You attach [src] to [M]."
			M << "[user] attaches [src] to you."
			M.l_arm_op_stage = 0
			M.addRoboPart("arm_left")
			del(src)
		return
	..()

/obj/item/robot_parts/r_arm/attack(mob/living/carbon/human/M as mob, mob/living/carbon/human/user as mob)
	if(istype(M) && istype(user))
		if(M.r_arm_op_stage == 3)
			user.drop_item()
			user << "\red You attach [src] to [M]."
			M << "[user] attaches [src] to you."
			M.r_arm_op_stage = 0
			M.addRoboPart("arm_right")
			del(src)
		return
	..()

/obj/item/robot_parts/l_leg/attack(mob/living/carbon/human/M as mob, mob/living/carbon/human/user as mob)
	if(istype(M) && istype(user))
		if(M.l_leg_op_stage == 3)
			user.drop_item()
			user << "\red You attach [src] to [M]."
			M << "[user] attaches [src] to you."
			M.l_leg_op_stage = 0
			M.addRoboPart("leg_left")
			del(src)
		return
	..()

/obj/item/robot_parts/r_leg/attack(mob/living/carbon/human/M as mob, mob/living/carbon/human/user as mob)
	if(istype(M) && istype(user))
		if(M.r_leg_op_stage == 3)
			user.drop_item()
			user << "\red You attach [src] to [M]."
			M << "[user] attaches [src] to you."
			M.r_leg_op_stage = 0
			M.addRoboPart("leg_right")
			del(src)
		return
	..()





////////////////
//BARBER TOOLS//
////////////////

///////////
//HAIRDYE//
///////////

/obj/item/weapon/dye/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M, /mob))
		return

	//hairstyle pick
	var/new_hair = input(user, "Please select hair color.", "Hairdye") as color
	if(new_hair)
		M:r_hair = hex2num(copytext(new_hair, 2, 4))
		M:g_hair = hex2num(copytext(new_hair, 4, 6))
		M:b_hair = hex2num(copytext(new_hair, 6, 8))

		M:update_body()
		M:update_face()

	return

////////////
//BEARDDYE//
////////////

/obj/item/weapon/bearddye/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M, /mob))
		return

	//hairstyle pick
	var/new_facial = input(user, "Please select facial hair color.", "Bearddye") as color
	if(new_facial)
		M:r_facial = hex2num(copytext(new_facial, 2, 4))
		M:g_facial = hex2num(copytext(new_facial, 4, 6))
		M:b_facial = hex2num(copytext(new_facial, 6, 8))

		M:update_body()
		M:update_face()

	return

/////////////
//BEARDCOMB//
////////////

/obj/item/weapon/comb/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M, /mob))
		return

	//hairstyle pick
	var/new_f_style = input(user, "Please select facial style", "Beardcomb")  as null|anything in list("Watson", "Chaplin", "Selleck", "Full Beard", "Long Beard", "Neckbeard", "Van Dyke", "Elvis", "Abe", "Chinstrap", "Hipster", "Goatee", "Hogan", "Shaved")
	if (new_f_style)
		M:f_style = new_f_style

	switch(M:f_style)
		if ("Watson")
			M:face_icon_state = "facial_watson"
		if ("Chaplin")
			M:face_icon_state = "facial_chaplin"
		if ("Selleck")
			M:face_icon_state = "facial_selleck"
		if ("Neckbeard")
			M:face_icon_state = "facial_neckbeard"
		if ("Full Beard")
			M:face_icon_state = "facial_fullbeard"
		if ("Long Beard")
			M:face_icon_state = "facial_longbeard"
		if ("Van Dyke")
			M:face_icon_state = "facial_vandyke"
		if ("Elvis")
			M:face_icon_state = "facial_elvis"
		if ("Abe")
			M:face_icon_state = "facial_abe"
		if ("Chinstrap")
			M:face_icon_state = "facial_chin"
		if ("Hipster")
			M:face_icon_state = "facial_hip"
		if ("Goatee")
			M:face_icon_state = "facial_gt"
		if ("Hogan")
			M:face_icon_state = "facial_hogan"
		else
			M:face_icon_state = "bald"

	M:update_body()
	M:update_face()

	return

/////////////
//SCISSORS//
////////////

/obj/item/weapon/scissors/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M, /mob))
		return


	//hairstyle pick
	var/new_style = input(user, "Please select hair style", "Scissors")  as null|anything in list( "Cut Hair", "Short Hair", "Long Hair", "Mohawk", "Balding", "Fag", "Afro", "Bieber", "Goku", "Dreadlocks", "Rocker", "Bald", "Super-long Hair", "Ponytail", "Short Female Hair", "Scene Hair", "Girly Hair", "Messy Hair", "Male Bedhead", "Female Bedhead" )
	if (new_style)
		M:h_style = new_style

	switch(M:h_style)
		if("Short Hair")
			M:hair_icon_state = "hair_a"
		if("Long Hair")
			M:hair_icon_state = "hair_b"
		if("Cut Hair")
			M:hair_icon_state = "hair_c"
		if("Mohawk")
			M:hair_icon_state = "hair_d"
		if("Balding")
			M:hair_icon_state = "hair_e"
		if("Fag")
			M:hair_icon_state = "hair_f"
		if("Afro")
			M:hair_icon_state = "hair_afro"
		if("Bieber")
			M:hair_icon_state = "hair_bieber"
		if("Goku")
			M:hair_icon_state = "hair_bedhead"
		if("Dreadlocks")
			M:hair_icon_state = "hair_dreads"
		if("Rocker")
			M:hair_icon_state = "hair_rocker"
		if("Ponytail")
			M:hair_icon_state = "hair_pony"
		if("Super-long Hair")
			M:hair_icon_state = "hair_long"
		if("Short Female Hair")
			M:hair_icon_state = "hair_female_short"
		if("Scene Hair")
			M:hair_icon_state = "hair_scene"
		if("Girly Hair")
			M:hair_icon_state = "hair_girly"
		if("Messy Hair")
			M:hair_icon_state = "hair_femalemessy"
		if("Male Bedhead")
			M:hair_icon_state = "hair_messym"
		if("Female Bedhead")
			M:hair_icon_state = "hair_messyf"
		else
			M:hair_icon_state = "bald"

	M:update_body()
	M:update_face()


	return

//end barber tools