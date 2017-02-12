/obj/reagent_dispensers/verb/climb_over()
	set name = "Climb Over"
	set src in oview(1)
	for (var/mob/V in viewers(usr))
		usr.visible_message("[usr] starts climbing over [src]")
	if(do_after(usr, 20))
		usr.loc = src.loc
	return

/obj/crate/verb/climb_over()
	set name = "Climb Over"
	set src in oview(1)
	for (var/mob/V in viewers(usr))
		usr.visible_message("[usr] starts climbing over [src]")
	if(do_after(usr, 20))
		usr.loc = src.loc
	return

/obj/closet/verb/climb_over()
	set name = "Climb Over"
	set src in oview(1)
	for (var/mob/V in viewers(usr))
		usr.visible_message("[usr] starts climbing over [src]")
	if(do_after(usr, 20))
		usr.loc = src.loc
	return

/obj/secure_closet/verb/climb_over()
	set name = "Climb Over"
	set src in oview(1)
	for (var/mob/V in viewers(usr))
		usr.visible_message("[usr] starts climbing over [src]")
	if(do_after(usr, 20))
		usr.loc = src.loc
	return

/obj/machinery/portable_atmospherics/verb/climb_over()
	set name = "Climb Over"
	set src in oview(1)
	for (var/mob/V in viewers(usr))
		usr.visible_message("[usr] starts climbing over [src]")
	if(do_after(usr, 20))
		usr.loc = src.loc
	return