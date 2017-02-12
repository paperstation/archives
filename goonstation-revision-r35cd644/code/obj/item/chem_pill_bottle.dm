/obj/item/chem_pill_bottle
	name = "Pill bottle"
	icon_state = "pill_canister"
	icon = 'icons/obj/chemical.dmi'
	w_class = 2.0
	stamina_damage = 3
	stamina_cost = 3
	stamina_crit_chance = 1
	rand_pos = 1

	var/pname
	var/pvol
	var/pcount
	var/datum/reagents/reagents_internal

	// setup this pill bottle from some reagents
	proc/create_from_reagents(var/datum/reagents/R, var/pillname, var/pillvol, var/pillcount)
		var/volume = pillcount * pillvol

		reagents_internal = new/datum/reagents(volume)
		reagents_internal.my_atom = src

		R.trans_to_direct(reagents_internal,volume)

		src.name = "[pillname] pill bottle"
		src.desc = "Contains [pillcount] [pillname] pills."
		src.pname = pillname
		src.pvol = pillvol
		src.pcount = pillcount

	// spawn a pill, returns a pill or null if there aren't any left in the bottle
	proc/create_pill()
		var/totalpills = src.pcount + src.contents.len

		if(totalpills <= 0)
			return null

		var/obj/item/reagent_containers/pill/P = null

		// give back stored pills first
		if (src.contents.len)
			P = src.contents[src.contents.len]

		// otherwise create a new one from the reagent holder
		else if (pcount)
			if (src.reagents_internal.total_volume < src.pvol)
				src.pcount = 0
			else
				P = unpool(/obj/item/reagent_containers/pill)
				P.loc = src
				P.name = "[pname] pill"

				src.reagents_internal.trans_to(P,src.pvol)
				src.pcount--
		// else return null

		return P

	proc/rebuild_desc()
		var/totalpills = src.pcount + src.contents.len
		if(totalpills > 15)
			src.desc = "A [src.pname] pill bottle. There are too many to count."
		else if (totalpills <= 0)
			src.desc = "A [src.pname] pill bottle. It looks empty."
		else
			src.desc = "A [src.pname] pill bottle. There [totalpills==1? "is [totalpills] pill." : "are [totalpills] pills." ]"

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/reagent_containers/pill/))
			user.u_equip(W)
			W.set_loc(src)
			W.dropped()
			boutput(user, "<span style=\"color:blue\">You put [W] in [src].</span>")
			rebuild_desc()
		else ..()

	attack_self(var/mob/user as mob)
		var/obj/item/reagent_containers/pill/P = src.create_pill()
		if (istype(P))
			do
				P.set_loc(user.loc)
				P = src.create_pill()
			while(istype(P))
			boutput(user, "<span style=\"color:blue\">You tip out all the pills from [src] into [user.loc].</span>")
			rebuild_desc()
		else
			boutput(user, "<span style=\"color:red\">It's empty.</span>")
			return

	attack_hand(mob/user as mob)
		if(user.r_hand == src || user.l_hand == src)
			var/obj/item/reagent_containers/pill/P = src.create_pill()
			if(istype(P))
				user.put_in_hand_or_drop(P)
				boutput(user, "You take [P] from [src].")
				rebuild_desc()
			else
				boutput(user, "<span style=\"color:red\">It's empty.</span>")
				return

		else
			return ..()


