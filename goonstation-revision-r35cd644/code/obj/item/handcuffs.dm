/obj/item/handcuffs
	name = "handcuffs"
	icon = 'icons/obj/items.dmi'
	icon_state = "handcuff"
	flags = FPRINT | TABLEPASS | CONDUCT | ONBELT
	throwforce = 5
	w_class = 2.0
	throw_speed = 2
	throw_range = 5
	m_amt = 500
	var/strength = 2
	var/delete_on_last_use = 0 // Delete src when it's used up (e.g. tape roll)?
	desc = "Adjustable metal rings joined by cable, made to be applied to a person in such a way that they are unable to use their hands. Difficult to remove from oneself."

	examine()
		..()
		if (src.delete_on_last_use)
			boutput(usr, "There are [src.amount] lengths of [istype(src, /obj/item/handcuffs/tape_roll) ? "tape" : "ziptie"] left!")
		return

	suicide(var/mob/user as mob) //brutal
		if(!hasvar(user,"organHolder") || istype(src,/obj/item/handcuffs/tape_roll) || istype(src,/obj/item/handcuffs/tape)) return 0
		user.canmove = 0
		user.visible_message("<span style=\"color:red\"><b>[user] jams one end of the [src.name] into one of \his eye sockets, closing the loop through the other!")
		playsound(src.loc, "sound/effects/bloody_stab.ogg", 50, 1)
		user.emote("scream")
		spawn(10)
			user.visible_message("<span style=\"color:red\"><b>[user] yanks the other end of the [src.name] as hard as \he can, ripping \his skull clean out of \his head! [pick("Jesus christ!","Holy shit!","What the fuck!?","Oh my god!")]</b></span>")
			var/obj/skull = user:organHolder.drop_organ("skull")
			skull.set_loc(user.loc)
			new /obj/decal/cleanable/blood(user.loc)
			playsound(src.loc, "sound/effects/gib.ogg", 50, 1)
			user.updatehealth()
			for (var/mob/O in AIviewers(user, null))
				if (O != user && ishuman(O) && prob(33))
					O.show_message("<span style=\"color:red\">You feel ill from watching that.</span>")
					for (var/mob/V in viewers(O, null))
						V.show_message("<span style=\"color:red\">[O.name] pukes all over \himself. Thanks, [user.name].</span>", 1)
						playsound(O.loc, "sound/effects/splat.ogg", 50, 1)
						new /obj/decal/cleanable/vomit(O.loc)

			spawn(5)
				var/obj/brain = user:organHolder.drop_organ("brain")
				brain.set_loc(skull.loc)
				brain.visible_message("<span style=\"color:red\"><b>[brain.name] falls out of the bottom of [skull.name]</b></span>")

			spawn(100)
				if (user)
					user.suiciding = 0
					user.canmove = 1
		return 1

/obj/item/handcuffs/tape_roll
	name = "Ducktape"
	desc = "Our new top of the line high-tech handcuffs"
	icon_state = "ducktape"
	flags = FPRINT | TABLEPASS | ONBELT
	m_amt = 200
	amount = 10
	delete_on_last_use = 1

/obj/item/handcuffs/tape
	desc = "These seem to be made of tape"
	strength = 1

/obj/item/handcuffs/guardbot
	name = "ziptie cuffs"
	desc = "A wrist-binding tie made from a durable synthetic material.  Weaker than traditional handcuffs, but much more comfortable."
	icon_state = "buddycuff"
	m_amt = 0
	strength = 1

	unequipped(var/mob/user)
		boutput(user, "<span style=\"color:red\">[src] biodegrade instantly. [prob (10) ? "DO NOT QUESTION THIS" : null]</span>")
		qdel(src)


/obj/item/handcuffs/attack(mob/M as mob, mob/user as mob)
	if (usr.bioHolder.HasEffect("clumsy") && prob(50))//!usr.bioHolder.HasEffect("lost_left_arm") && !usr.bioHolder.HasEffect("lost_right_arm"))
		boutput(usr, "<span style=\"color:red\">Uh ... how do those things work?!</span>")
		if(ishuman(usr) && (!usr:limbs:l_arm || !usr:limbs:r_arm))
			return
		M = user

	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		if(istype(H.mutantrace, /datum/mutantrace/abomination))
			boutput(user, "<span style=\"color:red\">You can't! There's nowhere to put them!</span>")
			return

		var/handslost = !istype(H.limbs.l_arm,/obj) + !istype(H.limbs.r_arm,/obj)
		if(handslost)
			boutput(user, "<span style=\"color:red\">[H.name] [(handslost>1) ? "has no arms" : "only has one arm"], you can't handcuff them!</span>")
			return

		if (H.handcuffed)
			boutput(user, "<span style=\"color:red\">[H] is already handcuffed</span>")
			return

		playsound(src.loc, "sound/weapons/handcuffs.ogg", 30, 1, -2)
		actions.start(new/datum/action/bar/icon/handcuffSet(H, src), user)
		return

	return

/obj/item/handcuffs/disposing()
	if (ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc
		H.set_clothing_icon_dirty()

	..()
