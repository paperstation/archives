/obj/mecha/combat/scout_mech
	desc = "Light recon exosuit."
	name = "Tick"
	icon_state = "scout_mech"
	step_in = 1
	health = 150
	deflect_chance = 5
	max_temperature = 500
	infra_luminosity = 8
	operation_req_access = null
	force = 35
	var/defence = 0
	var/defence_deflect = 20
	wreckage = "/obj/decal/mecha_wreckage/scout_mech"

/*
/obj/mecha/combat/scout_mech/New()
	..()
//	selected_weapon = weapons[1]
	return
*/

/obj/mecha/combat/scout_mech/relaymove(mob/user,direction)
	if(defence)
		src.occupant_message("<font color='red'>Unable to move while in defence mode</font>")
		return 0
	. = ..()
	return


/obj/mecha/combat/scout_mech/verb/defence_mode()
	set category = "Exosuit Interface"
	set name = "Toggle defence mode"
	set src in view(0)
	if(usr!=src.occupant)
		return
	defence = !defence
	if(defence)
		deflect_chance = defence_deflect
		src.occupant_message("<font color='blue'>You enable [src] defence mode.</font>")
	else
		deflect_chance = initial(deflect_chance)
		src.occupant_message("<font color='red'>You disable [src] defence mode.</font>")
	src.log_message("Toggled defence mode.")
	return


/obj/mecha/combat/scout_mech/get_stats_part()
	var/output = ..()
	output += "<b>Defence mode: [defence?"on":"off"]</b>"
	return output

/obj/mecha/combat/scout_mech/get_commands()
	var/output = "<a href='?src=\ref[src];toggle_defence_mode=1'>Toggle defence mode</a><hr>"
	output += ..()
	return output

/obj/mecha/combat/scout_mech/Topic(href, href_list)
	..()
	if (href_list["toggle_defence_mode"])
		src.defence_mode()
	return