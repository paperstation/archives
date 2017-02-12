
/client/proc/cmd_admin_gib(mob/M as mob in world)
	set category = null
	set name = "Gib"
	set popup_menu = 1

	if (!src.holder)
		boutput(src, "Only administrators may use this command.")
		return
	if (alert(src, "Are you sure you want to gib [M]?", "Confirmation", "Yes", "No") == "Yes")
		if(usr.key != M.key && M.client)
			logTheThing("admin", usr, M, "has gibbed %target%")
			logTheThing("diary", usr, M, "has gibbed %target%", "admin")
			message_admins("[key_name(usr)] has gibbed [key_name(M)]")
		M.transforming = 1

		var/obj/overlay/O = new/obj/overlay(get_turf(M))
		O.anchored = 1
		O.name = "Explosion"
		O.layer = NOLIGHT_EFFECTS_LAYER_BASE
		O.pixel_x = -17
		O.icon = 'icons/effects/hugeexplosion.dmi'
		O.icon_state = "explosion"
		spawn(35) qdel(O)
		spawn(5) M.gib()

/client/proc/cmd_admin_partygib(mob/M as mob in world)
	set category = null
	set name = "Party Gib"
	set popup_menu = 0

	if (!src.holder)
		boutput(src, "Only administrators may use this command.")
		return

	if (alert(src, "Are you sure you want to gib [M]?", "Confirmation", "Yes", "No") == "Yes")
		if(usr.key != M.key && M.client)
			logTheThing("admin", usr, M, "has partygibbed %target%")
			logTheThing("diary", usr, M, "has partygibbed %target%", "admin")
			message_admins("[key_name(usr)] has partygibbed [key_name(M)]")

		spawn(5) M.partygib()

/client/proc/cmd_admin_owlgib(mob/M as mob in world)
	set category = null
	set name = "Owl Gib"
	set popup_menu = 0

	if (!src.holder)
		boutput(src, "Only administrators may use this command.")
		return

	if (alert(src, "Are you sure you want to gib [M]?", "Confirmation", "Yes", "No") == "Yes")
		if(usr.key != M.key && M.client)
			logTheThing("admin", usr, M, "has owlgibbed %target%")
			logTheThing("diary", usr, M, "has owlgibbed %target%", "admin")
			message_admins("[key_name(usr)] has owlgibbed [key_name(M)]")

		spawn(5) M.owlgib()

/client/proc/cmd_admin_firegib(mob/M as mob in world)
	set category = null
	set name = "Fire Gib"
	set popup_menu = 0

	if (!src.holder)
		boutput(src, "Only administrators may use this command.")
		return

	if (alert(src, "Are you sure you want to gib [M]?", "Confirmation", "Yes", "No") == "Yes")
		if(usr.key != M.key && M.client)
			logTheThing("admin", usr, M, "has firegibbed %target%")
			logTheThing("diary", usr, M, "has firegibbed %target%", "admin")
			message_admins("[key_name(usr)] has firegibbed [key_name(M)]")

		spawn(5) M.firegib()

/client/proc/cmd_admin_elecgib(mob/M as mob in world)
	set category = null
	set name = "Elec Gib"
	set popup_menu = 0

	if (!src.holder)
		boutput(src, "Only administrators may use this command.")
		return

	if (alert(src, "Are you sure you want to gib [M]?", "Confirmation", "Yes", "No") == "Yes")
		if(usr.key != M.key && M.client)
			logTheThing("admin", usr, M, "has elecgibbed %target%")
			logTheThing("diary", usr, M, "has elecgibbed %target%", "admin")
			message_admins("[key_name(usr)] has elecgibbed [key_name(M)]")

		spawn(5) M.elecgib()

/client/proc/cmd_admin_icegib(mob/M as mob in world)
	set category = null
	set name = "Ice Gib"
	set popup_menu = 0

	if (!src.holder)
		boutput(src, "Only administrators may use this command.")
		return

	if (!istype(M, /mob/living/carbon/human))
		boutput(src, "<span style=\"color:red\">Only humans can be icegibbed.</span>")
		return

	if (alert(src, "Are you sure you want to gib [M]?", "Confirmation", "Yes", "No") == "Yes")
		if(usr.key != M.key && M.client)
			logTheThing("admin", usr, M, "has icegibbed %target%")
			logTheThing("diary", usr, M, "has icegibbed %target%", "admin")
			message_admins("[key_name(usr)] has icegibbed [key_name(M)]")

		spawn(5) M:become_ice_statue()

/client/proc/cmd_admin_goldgib(mob/M as mob in world)
	set category = null
	set name = "Gold Gib"
	set popup_menu = 0

	if (!src.holder)
		boutput(src, "Only administrators may use this command.")
		return

	if (!istype(M, /mob/living/carbon/human))
		boutput(src, "<span style=\"color:red\">Only humans can be goldgibbed.</span>")
		return

	if (alert(src, "Are you sure you want to gib [M]?", "Confirmation", "Yes", "No") == "Yes")
		if(usr.key != M.key && M.client)
			logTheThing("admin", usr, M, "has goldgibbed %target%")
			logTheThing("diary", usr, M, "has goldgibbed %target%", "admin")
			message_admins("[key_name(usr)] has goldgibbed [key_name(M)]")

		M.desc = "A very fancy statue of a shitty player."
		spawn(5) M:become_gold_statue()

/client/proc/cmd_admin_spidergib(mob/M as mob in world)
	set category = null
	set name = "Spider Gib"
	set popup_menu = 0

	if (!src.holder)
		boutput(src, "Only administrators may use this command.")
		return

	if (!istype(M, /mob/living/carbon/human))
		boutput(src, "<span style=\"color:red\">Only humans can be spidergibbed.</span>")
		return

	if (alert(src, "Are you sure you want to gib [M]?", "Confirmation", "Yes", "No") == "Yes")
		if(usr.key != M.key && M.client)
			logTheThing("admin", usr, M, "has spidergibbed %target%")
			logTheThing("diary", usr, M, "has spidergibbed %target%", "admin")
			message_admins("[key_name(usr)] has spidergibbed [key_name(M)]")

		spawn(5) M:spidergib()

/client/proc/cmd_admin_cluwnegib(mob/M as mob in world)
	set category = null
	set name = "Cluwne Gib"
	set desc = "Summon the fearsome floor cluwne..."
	set popup_menu = 0

	if (!src.holder)
		boutput(src, "Only administrators may use this command.")
		return

	if (alert(src, "Are you sure you want to gib [M]?", "Confirmation", "Yes", "No") == "Yes")
		var/duration = input("Input duration in 1/10ths of seconds (10 - 100)", "The Honkening", 30) as num
		if(!duration) return
		if(usr.key != M.key && M.client)
			logTheThing("admin", usr, M, "has set a floor cluwne upon %target%")
			logTheThing("diary", usr, M, "has set a floor cluwne upon %target%", "admin")
			message_admins("[key_name(usr)] has set a floor cluwne upon [key_name(M)]")

		spawn(5) M.cluwnegib(duration)

/client/proc/cmd_admin_gib_self()
	set name = "gibself"
	set category = "Special Verbs"
	set popup_menu = 0
	if (istype(src.mob, /mob/dead)) // so they don't spam gibs everywhere
		return
	else
		var/obj/overlay/O = new/obj/overlay(get_turf(src.mob))
		O.anchored = 1
		O.name = "Explosion"
		O.layer = NOLIGHT_EFFECTS_LAYER_BASE
		O.pixel_x = -17
		O.icon = 'icons/effects/hugeexplosion.dmi'
		O.icon_state = "explosion"
		spawn(35) qdel(O)
		spawn(5) src.mob.gib()
