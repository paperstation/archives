/obj/machinery/imp/chair
	name = "Implant Chair"
	desc = "Implants the user with a loyalty implant"
	icon = 'icons/misc/simroom.dmi'
	icon_state = "simchair"
	anchored = 1
	density = 0
	var/obj/item/implant/imp = null

/obj/machinery/imp/chair/MouseDrop_T(mob/M as mob, mob/user as mob)
	if (!ticker)
		boutput(user, "You can't buckle anyone in before the game starts.")
		return
	if ((!( iscarbon(M) ) || get_dist(src, user) > 1 || M.loc != src.loc || user.restrained() || usr.stat))
		return
	if (M.buckled)	return
	if (M == usr)
		user.visible_message("<span style=\"color:blue\">[M] buckles in!</span>", "<span style=\"color:blue\">You buckle yourself in.</span>")
	else
		user.visible_message("<span style=\"color:blue\">[M] is buckled in by [user].</span>", "<span style=\"color:blue\">You buckle in [M].</span>")
	M.anchored = 1
	M.buckled = src
	M.set_loc(src.loc)
	implantgo(M)
	src.add_fingerprint(user)
	return

/obj/machinery/imp/chair/attack_hand(mob/user as mob)
	for(var/mob/M in src.loc)
		if (M.buckled)
			if (M != user)
				user.visible_message("<span style=\"color:blue\">[M] is unbuckled by [user].</span>", "<span style=\"color:blue\">You unbuckle [M].</span>")
			else
				user.visible_message("<span style=\"color:blue\">[M] unbuckles.</span>", "<span style=\"color:blue\">You unbuckle.</span>")
			M.anchored = 0
			M.buckled = null
			src.add_fingerprint(user)
	return

/obj/machinery/imp/chair/proc/implantgo(mob/M as mob)
	if (!istype(M, /mob))
		return

	src.imp = new/obj/item/implant/antirev(src)

	M.visible_message("<span style=\"color:red\">[M] has been implanted by the [src].</span>")


	if(istype(M, /mob/living/carbon/human))
		M:implant.Add(src.imp)


		if(ticker && ticker.mode && istype(ticker.mode, /datum/game_mode/revolution))
			if(istype(src.imp, /obj/item/implant/antirev))
				if(M.mind in ticker.mode:head_revolutionaries)
					M.visible_message("<span style=\"color:red\">[M] seems to resist the implant.</span>")
				else if(M.mind in ticker.mode:revolutionaries)
					ticker.mode:remove_revolutionary(M.mind)

	src.imp.set_loc(M)
	src.imp.implanted = 1
	src.imp.implanted(M)
	src.imp.owner = M
	src.imp = null
	return
