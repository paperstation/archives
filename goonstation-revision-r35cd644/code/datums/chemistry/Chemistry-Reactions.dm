/proc/ldmatter_reaction(var/datum/reagents/holder, var/created_volume, var/id)
	var/cube = 0
	var/atom/psource = holder.my_atom
	while (psource)
		psource = psource.loc
		if (istype(psource, /obj) && !istype(psource, /obj/item) && (istype(psource, /obj/machinery/vehicle) || !istype(psource, /obj/machinery)) && !istype(psource, /obj/submachine))
			cube = 1
			break

	var/atom/source = get_turf(holder.my_atom)
	new/obj/decal/implo(source)
	playsound(source, 'sound/effects/suck.ogg', 100, 1)

	if (cube)
		for (var/mob/living/carbon/human/H in psource)
			H.set_loc(source)
			logTheThing("combat", H, null, "becomes a meatcube due to ldmatter implosion.")
			H.make_meatcube(INFINITY)
		for (var/obj/O in psource)
			O.set_loc(source)
		psource:visible_message("<span style=\"color:red\">[psource] implodes!</span>")
		qdel(psource)
		return

	for(var/atom/movable/M in view(3 + (created_volume > 30 ? 1:0), source))
		if(M.anchored || M == source || M.throwing) continue
		spawn(0) M.throw_at(source, 20 + round(created_volume * 2), 1 + round(created_volume / 10))
	if (holder)
		holder.del_reagent(id)

/proc/smoke_reaction(var/datum/reagents/holder, var/smoke_size, var/turf/location, var/vox_smoke = 0)
	if (narrator_mode || vox_smoke)
		playsound(location, 'sound/vox/smoke.ogg', 50, 1, -3)
	else
		playsound(location, 'sound/effects/smoke.ogg', 50, 1, -3)
	particleMaster.SpawnSystem(new /datum/particleSystem/chemSmoke(location, holder, 100, smoke_size))
