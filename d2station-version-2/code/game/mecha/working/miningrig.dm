/obj/mecha/working/miningrig
	desc = "A mobile exosuit designed with mining in mind."
	name = "Mining Rig"
	icon_state = "mining_rig"
	step_in = 4
	max_temperature = 500
	health = 200
	wreckage = "/obj/decal/mecha_wreckage/mining_rig"
	var/list/cargo = new
	var/cargo_capacity = 5

/*
/obj/mecha/working/miningrig/New()
	..()
	return
*/

/obj/mecha/working/miningrig/Exit(atom/movable/O)
	if(O in cargo)
		return 0
	return ..()


/obj/mecha/working/miningrig/Topic(href, href_list)
	..()
	if(href_list["drop_from_cargo"])
		var/obj/O = locate(href_list["drop_from_cargo"])
		if(O && O in src.cargo)
			src.occupant << "\blue You unload [O]."
			O.loc = get_turf(src)
			src.cargo -= O
			var/turf/T = get_turf(O)
			if(T)
				T.Entered(O)
			src.log_message("Unloaded [O]. Cargo compartment capacity: [cargo_capacity - src.cargo.len]")
	return



/obj/mecha/working/miningrig/get_stats_part()
	var/output = ..()
	output += "<b>Cargo Compartment Contents:</b><div style=\"margin-left: 15px;\">"
	if(src.cargo.len)
		for(var/obj/O in src.cargo)
			output += "<a href='?src=\ref[src];drop_from_cargo=\ref[O]'>Unload</a> : [O]<br>"
	else
		output += "Nothing"
	output += "</div>"
	return output

/obj/mecha/working/miningrig/Del()
	for(var/mob/M in src)
		if(M==src.occupant)
			continue
		M.loc = get_turf(src)
		M.loc.Entered(M)
		step_rand(M)
	for(var/atom/movable/A in src.cargo)
		A.loc = get_turf(src)
		var/turf/T = get_turf(A)
		if(T)
			T.Entered(A)
		step_rand(A)
	..()
	return



