/*
CONTAINS:
SCALPEL
CIRCULAR SAW
DYE
SCISSORS
MOUSTACHEBRUSH
RETRACTOR
HEMOSTAT
CAUTERY
SURGICAL DRILL

*/




/////////////
//HAIRDYE//
////////////

/obj/item/weapon/dye/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M, /mob))
		return

	var/mob/living/carbon/human/H = M

	if (user.zone_sel.selecting == "head")
		if(istype(M, /mob/living/carbon/human) && ((H.head && H.head.flags & HEADCOVERSEYES) || (H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) || (H.glasses && H.glasses.flags & GLASSESCOVERSEYES)))
			// hair can't be cut unless the head is clear
			user << "\blue You're going to need to remove that mask/helmet/glasses first."
			return

		//hairstyle pick
		var/new_hair = input(user, "Please select hair color.", "Hairdye") as color
		if(new_hair)
			M:r_hair = hex2num(copytext(new_hair, 2, 4))
			M:g_hair = hex2num(copytext(new_hair, 4, 6))
			M:b_hair = hex2num(copytext(new_hair, 6, 8))

			M:update_body()

	else if (user.zone_sel.selecting == "mouth")
		if(istype(M, /mob/living/carbon/human) && ((H.head && H.head.flags & HEADCOVERSEYES) || (H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) || (H.glasses && H.glasses.flags & GLASSESCOVERSEYES)))
			// hair can't be cut unless the head is clear
			user << "\blue You're going to need to remove that mask/helmet/glasses first."
			return

		//hairstyle pick
		var/new_facial = input(user, "Please select facial hair color.", "Bearddye") as color
		if(new_facial)
			M:r_facial = hex2num(copytext(new_facial, 2, 4))
			M:g_facial = hex2num(copytext(new_facial, 4, 6))
			M:b_facial = hex2num(copytext(new_facial, 6, 8))

			M:update_body()

	else if((!(user.zone_sel.selecting == "mouth")) || (!(user.zone_sel.selecting == "head")) || (!(istype(M, /mob/living/carbon/human))))
		return ..()

	return

/////////////
//BEARDDYE//
////////////

/obj/item/weapon/bearddye/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M, /mob))
		return


	var/mob/living/carbon/human/H = M
	if (user.zone_sel.selecting == "mouth")
		if(istype(M, /mob/living/carbon/human) && ((H.head && H.head.flags & HEADCOVERSEYES) || (H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) || (H.glasses && H.glasses.flags & GLASSESCOVERSEYES)))
			// hair can't be cut unless the head is clear
			user << "\blue You're going to need to remove that mask/helmet/glasses first."
			return

		//hairstyle pick
		var/new_facial = input(user, "Please select facial hair color.", "Bearddye") as color
		if(new_facial)
			M:r_facial = hex2num(copytext(new_facial, 2, 4))
			M:g_facial = hex2num(copytext(new_facial, 4, 6))
			M:b_facial = hex2num(copytext(new_facial, 6, 8))

			M:update_body()

	else if((!(user.zone_sel.selecting == "mouth")) || (!(istype(M, /mob/living/carbon/human))))
		return ..()

	return

/////////////
//BEARDCOMB//
////////////

/obj/item/weapon/comb/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M, /mob))
		return

	var/mob/living/carbon/human/H = M

	if (user.zone_sel.selecting == "mouth")
		if(istype(M, /mob/living/carbon/human) && ((H.head && H.head.flags & HEADCOVERSEYES) || (H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) || (H.glasses && H.glasses.flags & GLASSESCOVERSEYES)))
			// hair can't be cut unless the head is clear
			user << "\blue You're going to need to remove that mask/helmet/glasses first."
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
		new /obj/decal/cleanable/hair(M.loc)

	else if((!(user.zone_sel.selecting == "mouth")) || (!(istype(M, /mob/living/carbon/human))))
		return ..()

	return

/////////////
//SCISSORS//
////////////

/obj/item/weapon/scissors/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M, /mob))
		return

	var/mob/living/carbon/human/H = M

	if (user.zone_sel.selecting == "head")
		if(istype(M, /mob/living/carbon/human) && ((H.head && H.head.flags & HEADCOVERSEYES) || (H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) || (H.glasses && H.glasses.flags & GLASSESCOVERSEYES)))
			// hair can't be cut unless the head is clear
			user << "\blue You're going to need to remove that mask/helmet/glasses first."
			return

		//hairstyle pick
		var/new_style = input(user, "Please select hair style", "Scissors")  as null|anything in list( "Cut Hair", "Short Hair", "Long Hair", "Mohawk", "Balding", "Fag", "Afro", "Bieber", "Bedhead", "Dreadlocks", "Rocker", "Bald", "Super-long Hair", "Ponytail", "Short Female Hair", "Scene Hair", "Girly Hair", "Messy Hair" )
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
			if("Bedhead")
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
			else
				M:hair_icon_state = "bald"

		M:update_body()
		new /obj/decal/cleanable/hair(M.loc)

	else if((!(user.zone_sel.selecting == "head")) || (!(istype(M, /mob/living/carbon/human))))
		return ..()

	return

/////////////
//RETRACTOR//
/////////////

/obj/item/weapon/retractor/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M, /mob))
		return

	if(!((locate(/obj/machinery/optable, M.loc) && M.resting) || (locate(/obj/table/, M.loc) && (M.lying || M.weakened || M.stunned || M.paralysis || M.sleeping || M.stat) && prob(50))))
		return ..()

	if (user.zone_sel.selecting == "eyes")

		var/mob/living/carbon/human/H = M
		if(istype(M, /mob/living/carbon/human) && ((H.head && H.head.flags & HEADCOVERSEYES) || (H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) || (H.glasses && H.glasses.flags & GLASSESCOVERSEYES)))
			// Eye surgery cannot be performed unless the head is clear
			user << "\blue You're going to need to remove that mask/helmet/glasses first."
			return

		switch(M.eye_op_stage)
			if(1.0)
				for(var/mob/O in viewers(M, null))
					if(O == (user || M))
						continue
					if(M == user)
						O.show_message(text("\red [user] begins to have his eyes retracted."), 1)
					else
						O.show_message(text("\red [M] is having his eyes retracted by [user]."), 1)

				if(M != user)
					M << "\red [user] begins to seperate your eyes with [src]!"
					user << "\red You seperate [M]'s eyes with [src]!"
				else
					user << "\red You begin to pry open your eyes with [src]!"
					if(prob(25))
						user << "\red You mess up!"
						M.bruteloss += 15

				M.updatehealth()
				M:eye_op_stage = 2.0

	else if((!(user.zone_sel.selecting == "head")) || (!(user.zone_sel.selecting == "groin")) || (!(istype(M, /mob/living/carbon/human))))
		return ..()

	return

////////////
//Hemostat//
////////////

/obj/item/weapon/hemostat/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M, /mob))
		return

	if(!((locate(/obj/machinery/optable, M.loc) && M.resting) || (locate(/obj/table/, M.loc) && M.lying && prob(50))))
		return ..()

	if (user.zone_sel.selecting == "eyes")

		var/mob/living/carbon/human/H = M
		if(istype(M, /mob/living/carbon/human) && ((H.head && H.head.flags & HEADCOVERSEYES) || (H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) || (H.glasses && H.glasses.flags & GLASSESCOVERSEYES)))
			// Eye surgery cannot be performed unless the head is clear
			user << "\blue You're going to need to remove that mask/helmet/glasses first."
			return

		switch(M.eye_op_stage)
			if(2.0)
				for(var/mob/O in viewers(M, null))
					if(O == (user || M))
						continue
					if(M == user)
						O.show_message(text("\red [user] begins to have his eyes mended."), 1)
					else
						O.show_message(text("\red [M] is having his eyes mended by [user]."), 1)

				if(M != user)
					M << "\red [user] begins to mend your eyes with [src]!"
					user << "\red You mend [M]'s eyes with [src]!"
				else
					user << "\red You begin to mend your eyes with [src]!"
					if(prob(25))
						user << "\red You mess up!"
						M.bruteloss += 15

				M.updatehealth()
				M:eye_op_stage = 3.0

	else if((!(user.zone_sel.selecting == "head")) || (!(user.zone_sel.selecting == "groin")) || (!(istype(M, /mob/living/carbon/human))))
		return ..()

	return

///////////
//Cautery//
///////////

/obj/item/weapon/cautery/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M, /mob))
		return

	if(!((locate(/obj/machinery/optable, M.loc) && M.resting) || (locate(/obj/table/, M.loc) && M.lying && prob(50))))
		return ..()

	if (user.zone_sel.selecting == "eyes")

		var/mob/living/carbon/human/H = M
		if(istype(M, /mob/living/carbon/human) && ((H.head && H.head.flags & HEADCOVERSEYES) || (H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) || (H.glasses && H.glasses.flags & GLASSESCOVERSEYES)))
			// Eye surgery cannot be performed unless the head is clear
			user << "\blue You're going to need to remove that mask/helmet/glasses first."
			return

		switch(M.eye_op_stage)
			if(3.0)
				for(var/mob/O in viewers(M, null))
					if(O == (user || M))
						continue
					if(M == user)
						O.show_message(text("\red [user] begins to have his eyes cauterized."), 1)
					else
						O.show_message(text("\red [M] is having his eyes cauterized by [user]."), 1)

				if(M != user)
					M << "\red [user] begins to cauterize your eyes!"
					user << "\red You cauterize [M]'s eyes with [src]!"
				else
					user << "\red You begin to cauterize your eyes!"
					if(prob(25))
						user << "\red You mess up!"
						M.bruteloss += 15


				M.updatehealth()
				M.sdisabilities &= ~1
				M:eye_op_stage = 0.0

	else if((!(user.zone_sel.selecting == "head")) || (!(user.zone_sel.selecting == "groin")) || (!(istype(M, /mob/living/carbon/human))))
		return ..()

	return


//obj/item/weapon/surgicaldrill


///////////
//SCALPEL//
///////////

/obj/item/weapon/scalpel/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M, /mob))
		return

	if((usr.mutations & 16) && prob(50))
		M << "\red You stab yourself in the eye."
		M.sdisabilities |= 1
		M.weakened += 4
		M.bruteloss += 10

	src.add_fingerprint(user)

	if(!((locate(/obj/machinery/optable, M.loc) && M.resting) || (locate(/obj/table/, M.loc) && M.lying && prob(50))))
		return ..()

	if(user.zone_sel.selecting == "head")

		var/mob/living/carbon/human/H = M
		if(istype(M, /mob/living/carbon/human) && ((H.head && H.head.flags & HEADCOVERSEYES) || (H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) || (H.glasses && H.glasses.flags & GLASSESCOVERSEYES)))
			// you can't stab someone in the eyes wearing a mask!
			user << "\blue You're going to need to remove that mask/helmet/glasses first."
			return

		switch(M:brain_op_stage)
			if(0.0)
				for(var/mob/O in viewers(M, null))
					if(O == (user || M))
						continue
					if(M == user)
						O.show_message(text("\red [user] begins to cut open his skull with [src]!"), 1)
					else
						O.show_message(text("\red [M] is beginning to have his head cut open with [src] by [user]."), 1)

				if(M != user)
					M << "\red [user] begins to cut open your head with [src]!"
					user << "\red You cut [M]'s head open with [src]!"
				else
					user << "\red You begin to cut open your head with [src]!"
					if(prob(25))
						user << "\red You mess up!"
						M.bruteloss += 15

				if(istype(M, /mob/living/carbon/human))
					var/datum/organ/external/affecting = M.organs["head"]
					affecting.take_damage(7)
				else
					M.bruteloss += 7

				M.updatehealth()
				M:brain_op_stage = 1.0
			if(2.0)
				for(var/mob/O in viewers(M, null))
					if(O == (user || M))
						continue
					if(M == user)
						O.show_message(text("\red [user] begin to delicately remove the connections to his brain with [src]!"), 1)
					else
						O.show_message(text("\red [M] is having his connections to the brain delicately severed with [src] by [user]."), 1)

				if(M != user)
					M << "\red [user] begins to cut open your head with [src]!"
					user << "\red You cut [M]'s head open with [src]!"
				else
					user << "\red You begin to delicately remove the connections to the brain with [src]!"
					if(prob(25))
						user << "\red You nick an artery!"
						M.bruteloss += 75

				if(istype(M, /mob/living/carbon/human))
					var/datum/organ/external/affecting = M.organs["head"]
					affecting.take_damage(7)
				else
					M.bruteloss += 7

				M.updatehealth()
				M:brain_op_stage = 3.0
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
					var/datum/organ/external/affecting = M.organs["groin"]
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
					var/datum/organ/external/affecting = M.organs["groin"]
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
		if(istype(M, /mob/living/carbon/human) && ((H.head && H.head.flags & HEADCOVERSEYES) || (H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) || (H.glasses && H.glasses.flags & GLASSESCOVERSEYES)))
			// Eye surgery cannot be performed unless the head is clear
			user << "\blue You're going to need to remove that mask/helmet/glasses first."
			return

		switch(M:eye_op_stage)
			if(0.0)
				for(var/mob/O in viewers(M, null))
					if(O == (user || M))
						continue
					if(M == user)
						O.show_message(text("\red [user] begins to cut around his eyes with [src]!"), 1)
					else
						O.show_message(text("\red [M] is beginning to have his eyes incised with [src] by [user]."), 1)

				if(M != user)
					M << "\red [user] begins to cut open your eyes with [src]!"
					user << "\red You make an incision around [M]'s eyes with [src]!"
				else
					user << "\red You begin to cut open your eyes with [src]!"
					if(prob(25))
						user << "\red You mess up!"
						M.bruteloss += 15

				user << "\blue So far so good before."
				M.updatehealth()
				M:eye_op_stage = 1.0
				user << "\blue So far so good after."

	else if((!(user.zone_sel.selecting == "head")) || (!(user.zone_sel.selecting == "groin")) || (!(istype(M, /mob/living/carbon/human))))
		return ..()

	return

////////////////
//CIRCULAR SAW//
////////////////

/obj/item/weapon/circular_saw/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M, /mob))
		return

	if((usr.mutations & 16) && prob(50))
		M << "\red You cut out your eyes."
		M.sdisabilities |= 1
		M.weakened += 4
		M.bruteloss += 10

	src.add_fingerprint(user)

	if(!((locate(/obj/machinery/optable, M.loc) && M.resting) || (locate(/obj/table/, M.loc) && M.lying && prob(50))))
		return ..()

	if(user.zone_sel.selecting == "head")

		var/mob/living/carbon/human/H = M
		if(istype(M, /mob/living/carbon/human) && ((H.head && H.head.flags & HEADCOVERSEYES) || (H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) || (H.glasses && H.glasses.flags & GLASSESCOVERSEYES)))
			// you can't stab someone in the eyes wearing a mask!
			user << "\blue You're going to need to remove that mask/helmet/glasses first."
			return

		switch(M:brain_op_stage)
			if(1.0)
				for(var/mob/O in viewers(M, null))
					if(O == (user || M))
						continue
					if(M == user)
						O.show_message(text("\red [user] saws open his skull with [src]!"), 1)
					else
						O.show_message(text("\red [M] has his skull sawed open with [src] by [user]."), 1)

				if(M != user)
					M << "\red [user] begins to saw open your head with [src]!"
					user << "\red You saw [M]'s head open with [src]!"
				else
					user << "\red You begin to saw open your head with [src]!"
					if(prob(25))
						user << "\red You mess up!"
						M.bruteloss += 40

				if(istype(M, /mob/living/carbon/human))
					var/datum/organ/external/affecting = M.organs["head"]
					affecting.take_damage(7)
				else
					M.bruteloss += 7

				M.updatehealth()
				M:brain_op_stage = 2.0

			if(3.0)
				for(var/mob/O in viewers(M, null))
					if(O == (user || M))
						continue
					if(M == user)
						O.show_message(text("\red [user] severs his brain's connection to the spine with [src]!"), 1)
					else
						O.show_message(text("\red [M] has his spine's connection to the brain severed with [src] by [user]."), 1)

				if(M != user)
					M << "\red [user] severs your brain's connection to the spine with [src]!"
					user << "\red You sever [M]'s brain's connection to the spine with [src]!"
				else
					user << "\red You sever your brain's connection to the spine with [src]!"

				M:brain_op_stage = 4.0
				M.death()

				var/obj/item/brain/B = new /obj/item/brain(M.loc)
				B.owner = M
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
					var/datum/organ/external/affecting = M.organs["groin"]
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
	force = 1.0
	w_class = 1.0
	throwforce = 1.0
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