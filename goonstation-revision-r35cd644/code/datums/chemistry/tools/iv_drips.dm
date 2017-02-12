#define IV_INJECT 1
#define IV_DRAW 0

/* ================================================= */
/* -------------------- IV Drip -------------------- */
/* ================================================= */

/obj/item/reagent_containers/iv_drip
	name = "\improper IV drip"
	desc = "A bag with a fine needle attached at the end, for injecting patients with fluids."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "IV"
	inhand_image_icon = 'icons/mob/inhand/hand_medical.dmi'
	item_state = "IV"
	w_class = 1.0
	flags = FPRINT | TABLEPASS | SUPPRESSATTACK | OPENCONTAINER
	rc_flags = RC_VISIBLE | RC_FULLNESS | RC_SPECTRO
	amount_per_transfer_from_this = 5
	initial_volume = 250//100
	var/image/fluid_image = null
	var/mob/living/carbon/human/patient = null
	var/obj/iv_stand/stand = null
	var/mode = IV_DRAW
	var/in_use = 0

	New()
		..()
		src.fluid_image = image(src.icon, "IV-0")
		src.update_icon()

	on_reagent_change()
		src.update_icon()
		if (src.stand)
			src.stand.update_icon()

	proc/update_icon()
		src.overlays = null
		if (src.reagents.total_volume)
			var/iv_state = max(min(round((src.reagents.total_volume / src.reagents.maximum_volume) * 100, 10) / 10, 100), 0) //Look away, you fool! Like the sun, this section of code is harmful for your eyes if you look directly at it
			//var/iv_state = max(min(round(src.reagents.total_volume, 10) / 10, 100), 0)
			src.fluid_image.icon_state = "IV-[iv_state]"
			var/datum/color/average = reagents.get_average_color()
			src.fluid_image.color = average.to_rgba()
			src.overlays += src.fluid_image
			src.name = src.reagents.get_master_reagent_name() == "blood" ? "blood pack" : "[src.reagents.get_master_reagent_name()] drip"
		else
			src.fluid_image.icon_state = "IV-0"
			src.name = "\improper IV drip"
		if (ismob(src.loc))
			src.overlays += src.mode ? "inject" : "draw"

	is_open_container()
		return 1

	pickup(mob/user)
		..()
		src.update_icon()

	dropped(mob/user)
		..()
		src.update_icon()

	attack_self(mob/user as mob)
		src.mode = !(src.mode)
		user.show_text("You switch [src] to [src.mode ? "inject" : "draw"].")
		src.update_icon()

	attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
		if (!ishuman(M))
			return ..()
		var/mob/living/carbon/human/H = M

		if (in_use && src.patient)
			if (src.patient != H)
				user.show_text("[src] is already being used by someone else!", "red")
				return
			else if (src.patient == H)
				H.tri_message("<span style=\"color:blue\"><b>[user]</b> removes [src]'s needle from [H == user ? "[H.gender == "male" ? "his" : "her"]" : "[H]'s"] arm.</span>",\
				user, "<span style=\"color:blue\">You remove [src]'s needle from [H == user ? "your" : "[H]'s"] arm.</span>",\
				H, "<span style=\"color:blue\">[H == user ? "You remove" : "<b>[user]</b> removes"] [src]'s needle from your arm.</span>")
				src.stop_transfusion()
				return
		else
			if (src.mode == IV_INJECT)
				if (!src.reagents.total_volume)
					user.show_text("There's nothing left in [src]!", "red")
					return
				if (H.reagents && H.reagents.is_full())
					user.show_text("[H]'s blood pressure seems dangerously high as it is, there's probably no room for anything else!", "red")
					return

			else if (src.mode == IV_DRAW)
				if (src.reagents.is_full())
					user.show_text("[src] is full!", "red")
					return
				// Vampires can't use this trick to inflate their blood count, because they can't get more than ~30% of it back.
				// Also ignore that second container of blood entirely if it's a vampire (Convair880).
				if ((isvampire(H) && (H.get_vampire_blood() <= 0)) || (!isvampire(H) && !H.blood_volume))
					user.show_text("[H] doesn't have anything left to give!", "red")
					return

			H.tri_message("<span style=\"color:blue\"><b>[user]</b> begins inserting [src]'s needle into [H == user ? "[H.gender == "male" ? "his" : "her"]" : "[H]'s"] arm.</span>",\
			user, "<span style=\"color:blue\">You begin inserting [src]'s needle into [H == user ? "your" : "[H]'s"] arm.</span>",\
			H, "<span style=\"color:blue\">[H == user ? "You begin" : "<b>[user]</b> begins"] inserting [src]'s needle into your arm.</span>")
			logTheThing("combat", user, H, "tries to hook up an IV drip [log_reagents(src)] to %target% at [log_loc(user)].")

			if (H != user)
				if (!do_mob(user, H, 50))
					user.show_text("You were interrupted!", "red")
					return
			else if (!do_after(H, 15))
				H.show_text("You were interrupted!", "red")
				return

			src.patient = H
			H.tri_message("<span style=\"color:blue\"><b>[user]</b> inserts [src]'s needle into [H == user ? "[H.gender == "male" ? "his" : "her"]" : "[H]'s"] arm.</span>",\
			user, "<span style=\"color:blue\">You insert [src]'s needle into [H == user ? "your" : "[H]'s"] arm.</span>",\
			H, "<span style=\"color:blue\">[H == user ? "You insert" : "<b>[user]</b> inserts"] [src]'s needle into your arm.</span>")
			logTheThing("combat", user, H, "connects an IV drip [log_reagents(src)] to %target% at [log_loc(user)].")
			src.start_transfusion()
			return

	process(var/mob/living/carbon/human/H as mob)
		if (!src.patient || !ishuman(src.patient) || !src.patient.reagents)
			src.stop_transfusion()
			return

		if ((!src.stand && get_dist(src, src.patient) > 1) || (src.stand && get_dist(src.stand, src.patient) > 1))
			var/fluff = pick("pulled", "yanked", "ripped")
			src.patient.visible_message("<span style=\"color:red\"><b>[src]'s needle gets [fluff] out of [src.patient]'s arm!</b></span>",\
			"<span style=\"color:red\"><b>[src]'s needle gets [fluff] out of your arm!</b></span>")
			src.stop_transfusion()
			return

		if (src.mode == IV_INJECT)
			if (src.patient.reagents.is_full())
				src.patient.visible_message("<span style=\"color:blue\"><b>[src.patient]</b>'s transfusion finishes.</span>",\
				"<span style=\"color:blue\">Your transfusion finishes.</span>")
				src.stop_transfusion()
				return
			if (!src.reagents.total_volume)
				src.patient.visible_message("<span style=\"color:red\">[src] runs out of fluid!</span>")
				src.stop_transfusion()
				return

			// the part where shit's actually transferred
			src.reagents.trans_to(src.patient, src.amount_per_transfer_from_this)
			src.patient.reagents.reaction(src.patient, INGEST, src.amount_per_transfer_from_this)
			return

		else if (src.mode == IV_DRAW)
			if (src.reagents.is_full())
				src.patient.visible_message("<span style=\"color:blue\">[src] fills up and stops drawing blood from [src.patient].</span>",\
				"<span style=\"color:blue\">[src] fills up and stops drawing blood from you.</span>")
				src.stop_transfusion()
				return
			// Vampires can't use this trick to inflate their blood count, because they can't get more than ~30% of it back.
			// Also ignore that second container of blood entirely if it's a vampire (Convair880).
			if ((isvampire(src.patient) && (src.patient.get_vampire_blood() <= 0)) || (!isvampire(src.patient) && !src.patient.reagents.total_volume && !src.patient.blood_volume))
				src.patient.visible_message("<span style=\"color:red\">[src] can't seem to draw anything more out of [src.patient]!</span>",\
				"<span style=\"color:red\">Your veins feel utterly empty!</span>")
				src.stop_transfusion()
				return

			// actual transfer
			transfer_blood(src.patient, src, src.amount_per_transfer_from_this)
			return

	proc/start_transfusion()
		src.in_use = 1
		if (!(src in processing_items))
			processing_items.Add(src)

	proc/stop_transfusion()
		if (src in processing_items)
			processing_items.Remove(src)
		src.in_use = 0
		src.patient = null

/* =================================================== */
/* -------------------- Sub-Types -------------------- */
/* =================================================== */

/obj/item/reagent_containers/iv_drip/blood
	desc = "A bag filled with some odd, synthetic blood. There's a fine needle at the end that can be used to transfer it to someone."
	icon_state = "IV-blood"
	mode = IV_INJECT
	New()
		..()
		src.reagents.add_reagent("blood", src.initial_volume)

/obj/item/reagent_containers/iv_drip/blood/vr
	icon = 'icons/effects/VR.dmi'

/obj/item/reagent_containers/iv_drip/saline
	desc = "A bag filled with saline. There's a fine needle at the end that can be used to transfer it to someone."
	mode = IV_INJECT
	New()
		..()
		src.reagents.add_reagent("saline", src.initial_volume)

/* ================================================== */
/* -------------------- IV Stand -------------------- */
/* ================================================== */

/obj/iv_stand
	name = "\improper IV stand"
	desc = "A metal pole that you can hang IV bags on, which is useful since we aren't animals that go leaving our sanitized medical equipment all over the ground or anything!"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "IVstand"
	anchored = 0
	density = 0
	var/image/fluid_image = null
	var/obj/item/reagent_containers/iv_drip/IV = null
	mats = 10

	New()
		..()
		fluid_image = image(src.icon, "IVstand1-fluid")

	get_desc()
		if (src.IV)
			return src.IV.examine()

	proc/update_icon()
		src.overlays = null
		if (!src.IV)
			src.icon_state = "IVstand"
			src.name = "\improper IV stand"
			return
		else
			src.icon_state = "IVstand1"
			src.name = "\improper IV stand ([src.IV])"
			if (src.IV.reagents.total_volume)
				src.fluid_image.icon_state = "IVstand1-fluid"
				var/datum/color/average = src.IV.reagents.get_average_color()
				src.fluid_image.color = average.to_rgba()
				src.overlays += src.fluid_image
			return

	attackby(obj/item/W, mob/user)
		if (!src.IV && istype(W, /obj/item/reagent_containers/iv_drip))
			if (isrobot(user)) // are they a borg? it's probably a mediborg's IV then, don't take that!
				return
			user.visible_message("<span style=\"color:blue\">[user] hangs [W] on [src].</span>",\
			"<span style=\"color:blue\">You hang [W] on [src].</span>")
			user.u_equip(W)
			W.set_loc(src)
			src.IV = W
			W:stand = src
			src.update_icon()
			return
		else if (src.IV)
			//src.IV.attackby(W, user)
			W.afterattack(src.IV, user)
			return
		else
			return ..()

	attack_hand(mob/user as mob)
		if (src.IV && !isrobot(user))
			var/obj/item/reagent_containers/iv_drip/oldIV = src.IV
			user.visible_message("<span style=\"color:blue\">[user] takes [oldIV] down from [src].</span>",\
			"<span style=\"color:blue\">You take [oldIV] down from [src].</span>")
			user.put_in_hand_or_drop(oldIV)
			oldIV.stand = null
			src.IV = null
			src.update_icon()
			return
		else
			return ..()

	MouseDrop(atom/over_object as mob|obj)
		if (usr && !usr.restrained() && !usr.stat && in_range(src, usr) && in_range(over_object, usr))
			if (src.IV && ishuman(over_object))
				src.IV.attack(over_object, usr)
				return
			else if (src.IV && over_object == src)
				src.IV.attack_self(usr)
				return
			else if (istype(over_object, /obj/stool/bed) || istype(over_object, /obj/stool/chair) || istype(over_object, /obj/machinery/optable))
				if (!(src in over_object.attached_objs))
					mutual_attach(src, over_object)
					src.set_loc(over_object.loc)
					src.layer = over_object.layer-1
					src.pixel_y += 8
					src.visible_message("[usr] attaches [src] to [over_object].")
					return
				else if (src in over_object.attached_objs)
					mutual_detach(src, over_object)
					src.layer = initial(src.layer)
					src.pixel_y = initial(src.pixel_y)
					src.visible_message("[usr] detaches [src] from [over_object].")
					return
			else
				return ..()
		else
			return ..()

#undef IV_INJECT
#undef IV_DRAW