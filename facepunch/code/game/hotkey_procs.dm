
/atom/proc/ShiftClick(var/mob/M as mob)
	examine()
	return


/atom/proc/AltClick()
	if (world.time <= usr:lastPoint+20)
		return
	usr:lastPoint = world.time
	point()
	return


/atom/proc/CtrlClick()
	if(hascall(src,"pull"))
		src:pull()
	return


/atom/proc/ShiftCtrlClick()//Teles user if they have a certain suit on
	if(isobserver(usr))
		if(!usr.client)
			return
		if(!usr.client.holder && src.z >= 6)//No teleporting around on Z6
			usr.z = 1
			return
		usr.loc = get_turf(src)
		return
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr//Need to add no tele when stunned to this
		if(istype(H.wear_suit))
			H.wear_suit.suit_function(src)
		return



/atom/proc/MiddleClick(var/mob/M as mob) // switch hands
	if(istype(M, /mob/living/carbon))
		var/mob/living/carbon/U = M
		U.swap_hand()
	return


/atom/proc/AIShiftClick() // Opens and closes doors!
	if(istype(src, /obj/machinery/door/airlock))
		if(src:density)
			var/nhref = "src=\ref[src];aiEnable=7"
			src.Topic(nhref, params2list(nhref), src, 1)
		else
			var/nhref = "src=\ref[src];aiDisable=7"
			src.Topic(nhref, params2list(nhref), src, 1)
		return
	ShiftClick(usr)//If we are not using a door then examine it
	return


/atom/proc/AIAltClick() // Eletrifies doors.
	if(istype(src , /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/door = src
		if(door.secondsElectrified)//Unshock it
			var/nhref = "src=\ref[src];aiDisable=5"
			src.Topic(nhref, params2list(nhref), src, 1)
			usr << "\blue The [src] will no longer shock users."
			return
		//Shock it
		var/nhref = "src=\ref[src];aiEnable=6"
		src.Topic(nhref, params2list(nhref), src, 1)
		usr << "\red The [src] will now shock users."
		return

	if(istype(src, /mob/living))
		if(isAI(usr) && usr != src)
			var/mob/living/silicon/ai/A = usr
			A.ai_actual_track(src)
		return
	return


/atom/proc/AICtrlClick() // Bolts doors, turns off APCs, tracks mobs
	if(istype(src , /obj/machinery/door/airlock))
		if(src:locked)
			var/nhref = "src=\ref[src];aiEnable=4"
			src.Topic(nhref, params2list(nhref), src, 1)
			usr << "\blue The [src] has been unbolted."
			return
		var/nhref = "src=\ref[src];aiDisable=4"
		src.Topic(nhref, params2list(nhref), src, 1)
		usr << "\red The [src] has been bolted."
		return

	if(istype(src , /obj/machinery/power/apc/))
		var/nhref = "src=\ref[src];breaker=1"
		src.Topic(nhref, params2list(nhref), 0)
		return

	return



/atom/proc/AIShiftCtrlClick()//Teleports mob
	move_camera_by_click()
	return