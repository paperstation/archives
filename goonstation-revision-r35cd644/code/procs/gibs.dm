/proc/gibs(atom/location, var/list/diseases, var/list/ejectables, var/blood_DNA, var/blood_type)
    // Added blood type and DNA for forensics (Convair880).
	var/obj/decal/cleanable/blood/gibs/gib = null
	var/list/gibs = new()
	spawn(0)
		playsound(location, "sound/effects/gib.ogg", 50, 1)

	// NORTH
	gib = new /obj/decal/cleanable/blood/gibs(location)
	if (prob(30))
		gib.icon_state = "gibup1"
	gib.streak(list(NORTH, NORTHEAST, NORTHWEST))
	gib.diseases += diseases
	gib.blood_DNA = blood_DNA
	gib.blood_type = blood_type
	gibs.Add(gib)

	// SOUTH
	gib = new /obj/decal/cleanable/blood/gibs(location)
	if (prob(30))
		gib.icon_state = "gibdown1"
	gib.streak(list(SOUTH, SOUTHEAST, SOUTHWEST))
	gib.diseases += diseases
	gib.blood_DNA = blood_DNA
	gib.blood_type = blood_type
	gibs.Add(gib)

	// WEST
	gib = new /obj/decal/cleanable/blood/gibs(location)
	gib.streak(list(WEST, NORTHWEST, SOUTHWEST))
	gib.diseases += diseases
	gib.blood_DNA = blood_DNA
	gib.blood_type = blood_type
	gibs.Add(gib)

	// EAST
	gib = new /obj/decal/cleanable/blood/gibs(location)
	gib.streak(list(EAST, NORTHEAST, SOUTHEAST))
	gib.diseases += diseases
	gib.blood_DNA = blood_DNA
	gib.blood_type = blood_type
	gibs.Add(gib)

	// RANDOM BODY
	gib = new /obj/decal/cleanable/blood/gibs/body(location)
	gib.streak(alldirs)
	gib.diseases += diseases
	gib.blood_DNA = blood_DNA
	gib.blood_type = blood_type
	gibs.Add(gib)

	// CORE
	gib = new /obj/decal/cleanable/blood/gibs/core(location)
	gib.diseases += diseases
	gib.blood_DNA = blood_DNA
	gib.blood_type = blood_type
	gibs.Add(gib)

	var/turf/Q = get_turf(location)
	if (!Q)
		return
	if (ejectables && ejectables.len)
		for (var/atom/movable/I in ejectables)
			var/turf/target = null
			var/tries = 0
			while (!target)
				if (tries == 4)
					target = get_edge_target_turf(location, pick(alldirs))
					break
				var/tx = rand(-6, 6)
				var/ty = rand(-6, 6)
				if (tx == ty && tx == 0)
					continue
				target = locate(Q.x + tx, Q.y + ty, Q.z)

			var/atom/movable/newobj = I.set_loc(location)
			newobj.layer = initial(newobj.layer)
			spawn
				newobj.throw_at(target, 12, 3)

	. = gibs

/proc/robogibs(atom/location, var/list/diseases)
	var/obj/decal/cleanable/robot_debris/gib = null
	var/list/gibs = new()
	spawn(0)
		playsound(location, "sound/effects/robogib.ogg", 50, 1)

	// RUH ROH
	var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
	s.set_up(2, 1, location)
	s.start()

	// NORTH
	gib = new /obj/decal/cleanable/robot_debris(location)
	if (prob(25))
		gib.icon_state = "gibup1"
	gib.streak(list(NORTH, NORTHEAST, NORTHWEST))
	gibs.Add(gib)

	// SOUTH
	gib = new /obj/decal/cleanable/robot_debris(location)
	if (prob(25))
		gib.icon_state = "gibdown1"
	gib.streak(list(SOUTH, SOUTHEAST, SOUTHWEST))
	gibs.Add(gib)

	// WEST
	gib = new /obj/decal/cleanable/robot_debris(location)
	gib.streak(list(WEST, NORTHWEST, SOUTHWEST))
	gibs.Add(gib)

	// EAST
	gib = new /obj/decal/cleanable/robot_debris(location)
	gib.streak(list(EAST, NORTHEAST, SOUTHEAST))
	gibs.Add(gib)

	// RANDOM
	gib = new /obj/decal/cleanable/robot_debris(location)
	gib.streak(alldirs)
	gibs.Add(gib)

	// RANDOM LIMBS
	for (var/i = 0, i < pick(0, 1, 2), i++)
		gib = new /obj/decal/cleanable/robot_debris/limb(location)
		gib.streak(alldirs)
	gibs.Add(gib)

	.=gibs

/proc/partygibs(atom/location, var/list/diseases, var/blood_DNA, var/blood_type)
    // Added blood type and DNA for forensics (Convair880).
	var/list/party_colors = list(rgb(0,0,255),rgb(204,0,102),rgb(255,255,0),rgb(51,153,0))
	var/obj/decal/cleanable/blood/gibs/gib = null

	// NORTH
	gib = new /obj/decal/cleanable/blood/gibs(location)
	if (prob(30))
		gib.icon_state = "gibup1"
	gib.diseases += diseases
	gib.blood_DNA = blood_DNA
	gib.blood_type = blood_type
	gib.color = pick(party_colors)
	gib.streak(list(NORTH, NORTHEAST, NORTHWEST))

	// SOUTH
	gib = new /obj/decal/cleanable/blood/gibs(location)
	if (prob(30))
		gib.icon_state = "gibdown1"
	gib.diseases += diseases
	gib.blood_DNA = blood_DNA
	gib.blood_type = blood_type
	gib.color = pick(party_colors)
	gib.streak(list(SOUTH, SOUTHEAST, SOUTHWEST))

	// WEST
	gib = new /obj/decal/cleanable/blood/gibs(location)
	gib.diseases += diseases
	gib.blood_DNA = blood_DNA
	gib.blood_type = blood_type
	gib.color = pick(party_colors)
	gib.streak(list(WEST, NORTHWEST, SOUTHWEST))


	// EAST
	gib = new /obj/decal/cleanable/blood/gibs(location)
	gib.diseases += diseases
	gib.blood_DNA = blood_DNA
	gib.blood_type = blood_type
	gib.color = pick(party_colors)
	gib.streak(list(EAST, NORTHEAST, SOUTHEAST))


	// RANDOM BODY
	gib = new /obj/decal/cleanable/blood/gibs/body(location)
	gib.diseases += diseases
	gib.blood_DNA = blood_DNA
	gib.blood_type = blood_type
	gib.color = pick(party_colors)
	gib.streak(alldirs)


	// RANDOM LIMBS
	for (var/i = 0, i < pick(0, 1, 2), i++)
		var/limb_type = pick(/obj/item/parts/human_parts/arm/left, /obj/item/parts/human_parts/arm/right, /obj/item/parts/human_parts/leg/left, /obj/item/parts/human_parts/leg/right)
		gib = new limb_type(location)
		gib.throw_at(get_edge_target_turf(location, pick(alldirs)), 4, 3)
		gib.color = pick(party_colors)

	// CORE
	gib = new /obj/decal/cleanable/blood/gibs/core(location)
	gib.diseases += diseases
	gib.blood_DNA = blood_DNA
	gib.blood_type = blood_type
	gib.color = pick(party_colors)
