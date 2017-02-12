


//Sets space back to its default state
//If level is 0 then reset every tile in the world otherwise only that zlevel
/client/proc/reload_space()
	set category = "Debug"
	set name = "Reset Space"

	if(!holder)
		src << "Only administrators may use this command."
		return 0

	space_icon = 'icons/turf/space.dmi'
	space_icon_state = "default"
	space_name = "space"
	space_desc = "Dark and cold."


	var/zlevel = input("Please enter the z level you wish to reset, 0 means all, -1 means cancel.","Z","0") as num|null
	if(zlevel == -1)
		return 0
	for(var/turf/space/S in world)
		if(zlevel && S.z != zlevel)
			continue
		if(istype(S, /turf/space/transit))
			continue
		S.set_icon()
	log_admin("[key_name(usr)] reset space.")
	message_admins("[key_name_admin(usr)] reset space.", 1)
	return 1


/client/proc/edit_space()
	set category = "Debug"
	set name = "Edit Space"

	if(!holder)
		src << "Only administrators may use this command."
		return 0

	var/preset = input("Select Space Preset","Spess") as null|anything in list("default", "old", "oldslow", "oldstill", "nacho", "fire", "bloodriver", "custom")
	if(!preset)
		return 0
	switch(preset)
		if("default")
			space_icon = 'icons/turf/space.dmi'
			space_icon_state = "default"
			space_name = "space"
			space_desc = "Dark and cold."
		if("old")
			space_icon = 'icons/turf/space.dmi'
			space_icon_state = "space"
			space_name = "space"
			space_desc = "Dark and cold."
		if("oldslow")
			space_icon = 'icons/turf/space.dmi'
			space_icon_state = "oldspace"
			space_name = "space"
			space_desc = "Dark and cold."
		if("oldstill")
			space_icon = 'icons/turf/space.dmi'
			space_icon_state = "stillspace"
			space_name = "space"
			space_desc = "Dark and cold."
		if("nacho")
			space_icon = 'icons/turf/space.dmi'
			space_icon_state = "nachospace"
			space_name = "space"
			space_desc = "Looks nasty."
		if("fire")
			space_icon = 'icons/turf/space.dmi'
			space_icon_state = "firespace"
			space_name = "space"
			space_desc = "Looks hot."
		if("bloodriver")
			space_icon = 'icons/turf/space.dmi'
			space_icon_state = "bloodriver"
			space_name = "bloodriver"
			space_desc = "Red and odd."

		if("custom")
			var/new_icon = input("Please enter new icon file.","Icon",null) as null|icon
			if(!new_icon)
				return 0
			var/new_state = input("Please enter new icon state.","IconState","space") as text|null
			if(!new_state)
				return 0
			var/new_name = input("Please enter new name.","Name","space") as text|null
			if(!new_name)
				return 0
			var/new_desc = input("Please enter desc.","Desc","black") as text|null
			if(!new_desc)
				return 0
			space_icon = new_icon
			space_icon_state = new_state
			space_name = new_name
			space_desc = new_desc

	var/target_z = input("Please enter the z level you wish to edit, 0 means all.","Z","0") as num|null//Note new space anywhere will still end up looking like the edited version but this does give us a bit more control
	mass_edit_space(target_z)
	log_admin("[key_name(usr)] edited space to [preset].")
	message_admins("[key_name_admin(usr)] edited space to [preset].", 1)
	return 1


/proc/mass_edit_space(var/target_z = 0)
	for(var/turf/space/S in world)
		if(target_z && S.z != target_z)
			continue
		if(istype(S, /turf/space/transit))
			continue
		S.set_icon()
	return 1
