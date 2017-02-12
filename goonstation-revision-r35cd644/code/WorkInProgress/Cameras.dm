/obj/item/storage/photo_album
	name = "Photo album"
	icon = 'icons/obj/items.dmi'
	icon_state = "album"
	item_state = "briefcase"

/obj/item/storage/photo_album/attackby(obj/item/W as obj, mob/user as mob)
	if (!istype(W,/obj/item/photo))
		boutput(user, "<span style=\"color:red\">You can only put photos in a photo album.</span>")
		return

	return ..()

/obj/item/camera_test
	name = "camera"
	icon = 'icons/obj/device.dmi'
	desc = "A reusable polaroid camera."
	icon_state = "camera"
	item_state = "electropack"
	w_class = 2.0
	flags = FPRINT | TABLEPASS | EXTRADELAY | CONDUCT | ONBELT
	m_amt = 2000
	throwforce = 5
	throw_speed = 4
	throw_range = 10
	var/pictures_left = 10
	var/pictures_max = 30
	var/can_use = 1

	large
		pictures_left = 30

	examine()
		..()
		boutput(usr, "There are [src.pictures_left] pictures left!")
		return

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/camera_film))
			var/obj/item/camera_film/C = W

			if (C.pictures <= 0)
				user.show_text("The [C.name] is used up.", "red")
				return
			if (src.pictures_left < 0)
				src.pictures_left = 0
			if (src.pictures_left != 0)
				user.show_text("You have to use up the current film cartridge before you can replace it.", "red")
				return

			src.pictures_left = min(src.pictures_left + C.pictures, src.pictures_max)
			user.u_equip(C)
			qdel(C)
			user.show_text("You replace the film cartridge. The camera can now take [src.pictures_left] pictures.", "blue")

		else
			..()
		return

/obj/item/camera_film
	name = "film cartridge"
	desc = "A replacement film cartridge for an instant camera."
	icon = 'icons/obj/device.dmi'
	icon_state = "camera_film"
	item_state = "box"
	w_class = 2.0
	mats = 10
	var/pictures = 10

	large
		name = "film cartridge (large)"
		pictures = 30
		mats = 15

	examine()
		..()
		boutput(usr, "It is good for [src.pictures] pictures.")
		return

/obj/item/photo
	name = "photo"
	icon = 'icons/obj/items.dmi'
	icon_state = "photo"
	item_state = "clipboard"
	w_class = 1.0
	var/image/fullImage
	var/icon/fullIcon

//////////////////////////////////////////////////////////////////////////////////////////////////
/*/obj/item/camera_test*/
/proc/build_composite_icon(var/atom/C)
	if (!C)
		return
	var/image/composite = image(C.icon, null, C.icon_state, null /*max(OBJ_LAYER, C.layer)*/, C.dir)
	if (!composite)
		return

	composite.overlays = C.overlays
	composite.underlays = C.underlays
	return composite
//////////////////////////////////////////////////////////////////////////////////////////////////
/obj/item/camera_test/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	return

/obj/item/camera_test/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
	if (!can_use || ismob(target.loc)) return
	if (src.pictures_left <= 0)
		if (src.pictures_left < 0)
			src.pictures_left = 0
		user.show_text("The film cartridge is used up. You have to replace it first.", "red")
		return

	var/turf/the_turf = get_turf(target)

	var/image/photo = image(the_turf.icon, null, the_turf.icon_state, OBJ_LAYER, the_turf.dir)
	var/icon/photo_icon = getFlatIcon(the_turf)
	if (!photo)
		return

	//photo.overlays += the_turf

	//turficon.Scale(22,20)

	var/mob_title = null
	var/mob_detail = null

	var/item_title = null
	var/item_detail = null

	var/itemnumber = 0
	for(var/atom/A in the_turf)
		if(A.invisibility || istype(A, /obj/overlay/tile_effect))
			continue
		if(ismob(A))
			var/image/X = build_composite_icon(A)
			var/icon/Y = A:build_flat_icon()
			//X.Scale(22,20)
			photo.overlays += X
			photo_icon.Blend(Y, ICON_OVERLAY)
			qdel(X)
			qdel(Y)

			if(!mob_title)
				mob_title = "[A]"
			else
				mob_title += " and [A]"

			if(!mob_detail)

				var/holding = null
				if(iscarbon(A))
					var/mob/living/carbon/temp = A
					if(temp.l_hand || temp.r_hand)
						if(temp.l_hand) holding = "They are holding \a [temp.l_hand]"
						if(temp.r_hand)
							if(holding)
								holding += " and \a [temp.r_hand]."
							else
								holding = "They are holding \a [temp.r_hand]."

				if(!mob_detail)
					mob_detail = "You can see [A] on the photo[A:health < 75 ? " - [A] looks hurt":""].[holding ? " [holding]":"."]"
				else
					mob_detail += "You can also see [A] on the photo[A:health < 75 ? " - [A] looks hurt":""].[holding ? " [holding]":"."]"

		else
			if(itemnumber < 5)
				var/image/X = build_composite_icon(A)
				var/icon/Y = getFlatIcon(A)
				if (X)
					//X.Scale(22,20)
					photo.overlays += X
				if (Y)
					photo_icon.Blend(Y, ICON_OVERLAY)
				itemnumber++
				qdel(X)
				qdel(Y)

				if(!item_title)
					item_title = " \a [A]"
				else
					item_title = " some objects"

				if(!item_detail)
					item_detail = "\a [A]"
				else
					item_detail += " and \a [A]"

	var/finished_title = null
	var/finished_detail = null

	if(!item_title && !mob_title)
		finished_title = "boring photo"
		finished_detail = "This is a pretty boring photo of \a [the_turf]."
	else
		if(mob_title)
			finished_title = "photo of [mob_title][item_title ? " and[item_title]":""]"
			finished_detail = "[mob_detail][item_detail ? " Theres also [item_detail].":"."]"
		else if(item_title)
			finished_title = "photo of[item_title]"
			finished_detail = "You can see [item_detail]"

	var/obj/item/photo/P = new/obj/item/photo( get_turf(src) )

	P.fullImage = photo//image(photo, "")
	P.fullIcon = photo_icon

	var/oldtransform = P.fullImage.transform
	P.fullImage.transform = matrix(0.6875, 0.625, MATRIX_SCALE)
	P.fullImage.pixel_y = 1
	P.overlays += P.fullImage
	P.fullImage.transform = oldtransform
	P.fullImage.pixel_y = 0
	//boutput(world, "[bicon(P.fullImage)]")

	P.name = finished_title
	P.desc = finished_detail

	playsound(src.loc, pick('sound/items/polaroid1.ogg','sound/items/polaroid2.ogg'), 75, 1, -3)

	src.pictures_left = max(0, src.pictures_left - 1)
	boutput(user, "<span style=\"color:blue\">[pictures_left] photos left.</span>")
	can_use = 0
	spawn (50)
		if (src) src.can_use = 1