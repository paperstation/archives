/obj/reagent_dispensers/verb/climb_over()
	set name = "Climb Over"
	set src in oview(1)
	usr.visible_message("[usr] starts climbing over \the [src].", "You start climbing over \the [src].")
	if(do_after(usr, 20))
		usr.loc = src.loc
	return

/obj/crate/verb/climb_over()
	set name = "Climb Over"
	set src in oview(1)
	usr.visible_message("[usr] starts climbing over \the [src].", "You start climbing over \the [src].")
	if(do_after(usr, 20))
		usr.loc = src.loc
	return

/obj/closet/verb/climb_over()
	set name = "Climb Over"
	set src in oview(1)
	usr.visible_message("[usr] starts climbing over \the [src].", "You start climbing over \the [src].")
	if(do_after(usr, 20))
		usr.loc = src.loc
	return

/obj/secure_closet/verb/climb_over()
	set name = "Climb Over"
	set src in oview(1)
	usr.visible_message("[usr] starts climbing over \the [src].", "You start climbing over \the [src].")
	if(do_after(usr, 20))
		usr.loc = src.loc
	return

/obj/rack/verb/climb_over()
	set name = "Climb Over"
	set src in oview(1)
	usr.visible_message("[usr] starts climbing over \the [src].", "You start climbing over \the [src].")
	if(do_after(usr, 20))
		usr.loc = src.loc
	return

/obj/machinery/portable_atmospherics/verb/climb_over()
	set name = "Climb Over"
	set src in oview(1)
	usr.visible_message("[usr] starts climbing over \the [src].", "You start climbing over \the [src].")
	if(do_after(usr, 20))
		usr.loc = src.loc
	return

/obj/machinery/space_heater/verb/climb_over()
	set name = "Climb Over"
	set src in oview(1)
	usr.visible_message("[usr] starts climbing over \the [src].", "You start climbing over \the [src].")
	if(do_after(usr, 20))
		usr.loc = src.loc
	return

/obj/machinery/computer/verb/climb_over()
	set name = "Climb Over"
	set src in oview(1)
	usr.visible_message("[usr] starts climbing over \the [src].", "You start climbing over \the [src].")
	if(do_after(usr, 20))
		usr.loc = src.loc
	return

/* Removed until we have a nice way of making areas you can't climb into. ~jetbeard
/obj/table/verb/climb_over()
	set name = "Climb Over"
	set src in oview(1)
	usr.visible_message("[usr] starts climbing over \the [src].", "You start climbing over \the [src].")
	if(do_after(usr, 20))
		usr.loc = src.loc
	return
*/