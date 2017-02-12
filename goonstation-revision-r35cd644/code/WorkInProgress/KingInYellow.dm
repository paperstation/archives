
/obj/item/clothing/mask/pallid
	name = "The Pallid Mask"
	desc = "..."
	icon_state = "pallid_mask"

/proc/get_oov_tile(var/atom) //Get a tile that is *just* outside the view of a given atom.
	var/list/viewl = oview(7, atom)
	for(var/atom/A in viewl) //List of visible turfs.
		if(!isturf(A)) viewl -= A

	var/list/rangel = orange(7, atom)
	for(var/atom/A2 in rangel) //List of all turfs.
		if(!isturf(A2)) rangel -= A2

	var/list/not_vis = viewl ^ rangel //List of all turfs that are NOT visible.
	var/list/valid = new/list()		//List of all turfs that are NOT visible that border a VISIBLE turf.

	for(var/turf/T in not_vis)
		for(var/dir in cardinal)
			if(get_step(T, dir) in viewl)
				if(is_free(T))
					var/atom/between = get_step(T, get_dir(T, atom))
					if(!between.opacity || 1) //this might limit it too much. check later
						valid += T
						break

	if(!valid.len) return null
	else return pick(valid)

/obj/kingyellow_vanish
	name = "Distortion"
	desc = ""
	density = 0
	anchored = 1
	layer = EFFECTS_LAYER_BASE
	var/image/effect = null

	New(var/atom/location, var/atom/trg)
		if(trg != null)
			loc = location
			effect = image('icons/effects/effects.dmi', src, "ykingvanish", 4)
			trg << effect
			spawn(3)	qdel(src)
		else	qdel(src)


/obj/kingyellow_phantom
	name = "Strange Person"
	desc = "Who is that? They look extremely out-of-place."
	density = 0
	anchored = 1
	var/atom/target = null
	var/image/showimg = null
	var/created = null

	New(var/atom/location, var/atom/trg)
		loc = location
		target = trg
		created = world.time
		showimg = image('icons/misc/critter.dmi', src, "kingyellow", 3)
		target << showimg
		src.dir = get_dir(src, target)
		spawn(5) update()

	attackby(obj/item/W as obj, mob/user as mob)
		vanish()

	attack_hand(mob/user as mob)
		vanish()

	proc/update()
		if(!target) vanish()
		if(!(src in view(7, target)) && (world.time - created) > 40) vanish()
		if(get_dist(src,target) <= 2) vanish()
		src.dir = get_dir(src, target)
		spawn(5) update()

	proc/vanish()
		new/obj/kingyellow_vanish(src.loc, target)
		spawn(3)	qdel(src)

/obj/item/book_kinginyellow
	name = "\"The King In Yellow\""
	desc = "This appears to be an ancient Book containing a Play."
	icon = 'icons/obj/writing.dmi'
	icon_state = "bookkiy"
	item_state = "paper"
	layer = OBJ_LAYER

	var/list/readers = new/list()
	var/atom/curr_phantom = null

	New()
		work()
		return

	proc/work()
		if(readers.len)
			var/mob/living/L = pick(readers)
			var/turf/oovTile = get_oov_tile(L)
			if(oovTile != null && curr_phantom == null)
				curr_phantom = new/obj/kingyellow_phantom(oovTile, L)

		spawn(30) work()
		return

	examine()
		set src in view()
		if (!issilicon(usr))
			var/mob/living/carbon/reader = usr
			if(!istype(reader)) return

			if(usr in readers)
				var/message = "This appears to be an ancient Book containing a Play.<br><br>"
				message += "You frantically read the play again ...<br>"
				message += "You feel as if you're about to faint."
				boutput(usr, message)

				reader.drowsyness += 3
			else
				var/message = "This appears to be an ancient Book containing a Play.<br><br>"
				message += "The first act tells of a city named Carcosa, and a mysterious \"King in Yellow\"<br>"
				message += "The second act seems incomplete but ... It is horrifying.<br>"
				boutput(usr, message)

				for(var/mob/M in readers)
					boutput(M, "<span style=\"color:red\">You feel the irresistible urge to read the \"The King In Yellow\" again.</span>")
					readers -= M

				readers += reader
			return
		else
			boutput(usr, "This ancient data storage medium appears to contain data used for entertainment purposes.")

	suicide(var/mob/user as mob)
		if (ishuman(user))
			var/mob/living/carbon/human/H = user
			if (!farting_allowed)
				return 0
			user.visible_message("<span style=\"color:red\">[user] farts on [src].<br><b>A mysterious force sucks [user] into the Book!!</b></span>")
			user.u_equip(src)
			src.layer = initial(src.layer)
			src.set_loc(user.loc)
			if (user.gender == MALE)
				playsound(get_turf(user), "sound/voice/male_fallscream.ogg", 100, 0, 0, H.get_age_pitch())
			else
				playsound(get_turf(user), "sound/voice/female_fallscream.ogg", 100, 0, 0, H.get_age_pitch())
			user.implode()
			return 1
		else
			return 0