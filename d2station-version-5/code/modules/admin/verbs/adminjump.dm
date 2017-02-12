/client/proc/Jump(var/area/A in areaz)
	set name = "Jump to Area"
	set desc = "Area to jump to"
	set category = "Admin"
	if(!src.authenticated || !src.holder)
		src << "Only administrators may use this command."
		return

	if(config.allow_admin_jump)
		usr.loc = pick(get_area_turfs(A))

		log_admin("[key_name(usr)] jumped to [A]")
		message_admins("[key_name_admin(usr)] jumped to [A]", 1)
	else
		alert("Admin jumping disabled")

/client/proc/jumptoturf(var/turf/T in turfs)
	set name = "Jump to Turf"
	set category = "Admin"
	if(!src.authenticated || !src.holder)
		src << "Only administrators may use this command."
		return
	if(config.allow_admin_jump)
		log_admin("[key_name(usr)] jumped to [T.x],[T.y],[T.z] in [T.loc]")
		message_admins("[key_name_admin(usr)] jumped to [T.x],[T.y],[T.z] in [T.loc]", 1)
		usr.loc = T
	else
		alert("Admin jumping disabled")
	return

/client/proc/jumptomob(var/mob/M in mobz)
	set category = "Admin"
	set name = "Jump to Mob"

	if(!src.authenticated || !src.holder)
		src << "Only administrators may use this command."
		return

	if(config.allow_admin_jump)
		log_admin("[key_name(usr)] jumped to [key_name(M)]")
		message_admins("[key_name_admin(usr)] jumped to [key_name_admin(M)]", 1)
		usr.loc = get_turf(M)
	else
		alert("Admin jumping disabled")

/client/proc/jumptocoordinates() // done because it's hard to get to the shuttle area -snipe
	set category = "Admin"
	set name = "Jump to Coordinates"

	if(!src.authenticated || !src.holder)
		src << "Only administrators may use this command."
		return

	if(config.allow_admin_jump)
		var/xlevel = input("Pick a X level!)", text("Input"))  as num
		var/ylevel = input("Pick a Y level!)", text("Input"))  as num
		var/zlevel = input("Pick a Z level!)", text("Input"))  as num
		if(zlevel > 2 || zlevel < 0)
			alert("No entering the twilight zone, fucknut")
		if(xlevel > 230 || xlevel < 0)
			alert("No entering the twilight zone, fucknut")
		if(ylevel > 170 || ylevel < 0)
			alert("No entering the twilight zone, fucknut")
		else
			usr.x = xlevel
			usr.y = ylevel
			usr.z = zlevel
			log_admin("[key_name(usr)] jumped to coordinates X:[xlevel], Y:[ylevel], Z:[zlevel]")
			message_admins("[key_name_admin(usr)] jumped to coordinates X:[xlevel], Y:[ylevel], Z:[zlevel]")
	else
		alert("Admin jumping disabled")


/client/proc/jumptokey()
	set category = "Admin"
	set name = "Jump to Key"

	if(!src.authenticated || !src.holder)
		src << "Only administrators may use this command."
		return

	if(config.allow_admin_jump)
		var/list/keys = list()
		for(var/mob/M in mobz)
			keys += M.client
		var/selection = input("Please, select a player!", "Admin Jumping", null, null) as null|anything in keys
		if(!selection)
			return
		var/mob/M = selection:mob
		log_admin("[key_name(usr)] jumped to [key_name(M)]")
		message_admins("[key_name_admin(usr)] jumped to [key_name_admin(M)]", 1)
		usr.loc = M.loc
	else
		alert("Admin jumping disabled")

/client/proc/Getmob(var/mob/M in mobz)
	set category = "Admin"
	set name = "Get Mob"
	set desc = "Mob to teleport"
	if(!src.authenticated || !src.holder)
		src << "Only administrators may use this command."
		return
	if(config.allow_admin_jump)
		log_admin("[key_name(usr)] teleported [key_name(M)]")
		message_admins("[key_name_admin(usr)] teleported [key_name_admin(M)]", 1)
		M.loc = get_turf(usr)
	else
		alert("Admin jumping disabled")

/client/proc/sendmob(var/mob/M in mobz, var/area/A in areaz)
	set category = "Admin"
	set name = "Send Mob"
	if(!src.authenticated || !src.holder)
		src << "Only administrators may use this command."
		return
	if(config.allow_admin_jump)
		M.loc = pick(get_area_turfs(A))

		log_admin("[key_name(usr)] teleported [key_name(M)] to [A]")
		message_admins("[key_name_admin(usr)] teleported [key_name_admin(M)] to [A]", 1)
	else
		alert("Admin jumping disabled")