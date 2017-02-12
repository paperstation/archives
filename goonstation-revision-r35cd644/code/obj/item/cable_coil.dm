// the cable coil object, used for laying cable

#define MAXCOIL 30
/obj/item/cable_coil
	name = "cable coil"
	var/base_name = "cable coil"
	desc = "A coil of power cable."
	amount = MAXCOIL
	max_stack = MAXCOIL
	stack_type = /obj/item/cable_coil // so cut cables can stack with partially depleted full coils
	icon = 'icons/obj/power.dmi'
	icon_state = "coil"
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	item_state = "coil"
	throwforce = 10
	w_class = 1.0
	throw_speed = 2
	throw_range = 5
	flags = TABLEPASS|EXTRADELAY|FPRINT|CONDUCT
	stamina_damage = 5
	stamina_cost = 5
	stamina_crit_chance = 10
	rand_pos = 1

	var/datum/material/insulator = null
	var/datum/material/conductor = null

	// will use getCachedMaterial() to apply these at spawn
	var/spawn_insulator_name = "synthrubber"
	var/spawn_conductor_name = "steel"

	New(loc, length = MAXCOIL)
		src.amount = length
		pixel_x = rand(-2,2)
		pixel_y = rand(-2,2)
		updateicon()
		..(loc)
		if (spawn_conductor_name)
			applyCableMaterials(src, getCachedMaterial(spawn_insulator_name), getCachedMaterial(spawn_conductor_name))

	before_stack(atom/movable/O as obj, mob/user as mob)
		user.visible_message("<span style=\"color:blue\">[user] begins coiling cable!</span>")

	after_stack(atom/movable/O as obj, mob/user as mob, var/added)
		boutput(user, "<span style=\"color:blue\">You finish coiling cable.</span>")

	suicide(var/mob/user as mob)
		user.visible_message("<span style=\"color:red\"><b>[user] wraps the cable around \his neck and tightens it.</b></span>")
		user.take_oxygen_deprivation(160)
		user.updatehealth()
		spawn(100)
			if (user)
				user.suiciding = 0
		return 1

	proc/setInsulator(var/datum/material/M)
		if (!M)
			return
		insulator = M
		applyCableMaterials(src, M, conductor)

	proc/setConductor(var/datum/material/M)
		if (!M)
			return
		conductor = M
		applyCableMaterials(src, insulator, M)

	proc/updateName()
		if (!conductor)
			return
		if (insulator)
			name = "[insulator.name]-insulated [conductor.name]-[base_name]"
		else
			name = "uninsulated [conductor.name]-[base_name]"

	proc/use(var/used)
		if (src.amount < used)
			return 0
		else if (src.amount == used)
			qdel(src)
		else
			amount -= used
			updateicon()
			return 1

	proc/take(var/amt, var/newloc)
		if (amt > amount)
			amt = amount
		if (amt == amount)
			if (ismob(loc))
				var/mob/owner = loc
				owner.u_equip(src)
			loc = newloc
			return src
		src.use(amt)
		var/obj/item/cable_coil/C = new /obj/item/cable_coil(newloc)
		C.amount = amt
		C.updateicon()
		C.setInsulator(insulator)
		C.setConductor(conductor)

	proc/updateicon()
		if (amount <= 0)
			qdel(src)
		else if (amount >= 1 && amount <= 4)
			icon_state = "coil[amount]"
			base_name = "cable piece"
		else
			icon_state = "coil"
			base_name = "cable coil"
		updateName()

/obj/item/cable_coil/cut
	icon = 'icons/obj/power.dmi'
	icon_state = "coil2"
	New(loc, length)
		if (length)
			..(loc, length)
		else
			..(loc, rand(1,2))

/obj/item/cable_coil/cut/small
	New(loc, length)
		..(loc, rand(1,5))

/obj/item/cable_coil/attack_self(var/mob/living/M)
	if (istype(M))
		if (M.move_laying)
			M.move_laying = null
			boutput(M, "<span style=\"color:blue\">No longer laying the cable while moving.</span>")
		else
			M.move_laying = src
			boutput(M, "<span style=\"color:blue\">Now laying cable while moving.</span>")

/obj/proc/move_callback(var/mob/M, var/turf/source, var/turf/target)
	return

/proc/find_half_cable(var/turf/T, var/ignore_dir)
	for (var/obj/cable/C in T)
		if (!C.d1 && C.d2 != ignore_dir)
			return C

/obj/item/cable_coil/move_callback(var/mob/living/M, var/turf/source, var/turf/target)
	if (!istype(M))
		return
	if (!src.amount)
		M.move_laying = null
		boutput(M, "<span style=\"color:red\">Your cable coil runs out!</span>")
		return
	var/obj/cable/C

	C = find_half_cable(source, get_dir(source, target))
	if (C)
		cable_join_between(C, target)
	else
		turf_place_between(source, target)

	if (!src.amount)
		M.move_laying = null
		boutput(M, "<span style=\"color:red\">Your cable coil runs out!</span>")
		return

	C = find_half_cable(target, get_dir(target, source))

	if (C)
		cable_join_between(C, source)
	else
		turf_place_between(target, source)

	if (!src.amount)
		M.move_laying = null
		boutput(M, "<span style=\"color:red\">Your cable coil runs out!</span>")
		return

/obj/item/cable_coil/examine()
	set src in view(1)
	set category = "Local"

	if (amount == 1)
		boutput(usr, "A short piece of power cable.")
	else if (amount == 1)
		boutput(usr, "A piece of power cable.")
	else
		boutput(usr, "A coil of power cable. There's [amount] length[s_es(amount)] of cable in the coil.")

	if (insulator)
		boutput(usr, "It is insulated with [insulator].")
	if (conductor)
		boutput(usr, "Its conductive layer is made out of [conductor].")

/obj/item/cable_coil/attackby(obj/item/W, mob/user)
	if (istype(W, /obj/item/wirecutters) && src.amount > 1)
		src.amount--
		take(1, usr.loc)
		boutput(user, "You cut a piece off the cable coil.")
		src.updateicon()
		return

	else if (istype(W, /obj/item/cable_coil))
		var/obj/item/cable_coil/C = W
		if (C.conductor.mat_id != src.conductor.mat_id || C.insulator.mat_id != src.insulator.mat_id)
			boutput(user, "You cannot link together cables made from different materials. That would be silly.")
			return

		if (C.amount == MAXCOIL)
			boutput(user, "The coil is too long, you cannot add any more cable to it.")
			return

		if ((C.amount + src.amount <= MAXCOIL))
			C.amount += src.amount
			boutput(user, "You join the cable coils together.")
			C.updateicon()
			qdel(src)
			return

		else
			boutput(user, "You transfer [MAXCOIL - src.amount ] length\s of cable from one coil to the other.")
			src.amount -= (MAXCOIL-C.amount)
			src.updateicon()
			C.amount = MAXCOIL
			C.updateicon()
			return

/obj/item/cable_coil/MouseDrop_T(atom/movable/O as obj, mob/user as mob)
	..(O, user)
	for (var/obj/item/cable_coil/C in view(1, user))
		C.updateicon()

// called when cable_coil is clicked on a turf/simulated/floor
/obj/item/cable_coil/proc/turf_place_between(turf/simulated/floor/A, turf/simulated/floor/B)
	if (!isturf(B))
		return
	if (get_dist(A, B) > 1)
		return
	if (A.intact)
		return

	var/dirn = get_dir(A, B)
	for (var/obj/cable/C in A)
		if (C.d1 == dirn || C.d2 == dirn)
			return
	var/obj/cable/NC = new(A)

	applyCableMaterials(NC, src.insulator, src.conductor)
	NC.d1 = 0
	NC.d2 = dirn
	NC.updateicon()
	NC.update_network()
	NC.log_wirelaying(usr)
	src.use(1)
	return

/obj/item/cable_coil/proc/cable_join_between(var/obj/cable/C, var/turf/simulated/floor/B)
	if (!isturf(B))
		return

	var/turf/T = C.loc

	if (!isturf(T) || T.intact)		// sanity checks, also stop use interacting with T-scanner revealed cable
		return

	if (get_dist(C, B) > 1)		// make sure it's close enough
		return

	if (B == T)		// do nothing if we clicked a cable we're standing on
		return		// may change later if can think of something logical to do

	var/dirn = get_dir(C, B)

	if (C.d1 == 0)			// exisiting cable doesn't point at our position, so see if it's a stub
							// if so, make it a full cable pointing from it's old direction to our dirn

		var/nd1 = C.d2	// these will be the new directions
		var/nd2 = dirn

		if (nd1 > nd2)		// swap directions to match icons/states
			nd1 = dirn
			nd2 = C.d2


		for (var/obj/cable/LC in T)		// check to make sure there's no matching cable
			if (LC == C)			// skip the cable we're interacting with
				continue
			if ((LC.d1 == nd1 && LC.d2 == nd2) || (LC.d1 == nd2 && LC.d2 == nd1) )	// make sure no cable matches either direction
				return
		qdel(C)
		var/obj/cable/NC = new(T)
		applyCableMaterials(NC, src.insulator, src.conductor)
		NC.d1 = nd1
		NC.d2 = nd2
		NC.updateicon()
		NC.update_network()
		NC.log_wirelaying(usr)
		src.use(1)
	return

/obj/item/cable_coil/proc/turf_place(turf/simulated/floor/F, mob/user)
	if (!isturf(user.loc))
		return

	if (get_dist(F,user) > 1)
		boutput(user, "You can't lay cable at a place that far away.")
		return

	if (F.intact)		// if floor is intact, complain
		boutput(user, "You can't lay cable there unless the floor tiles are removed.")
		return

	else
		var/dirn

		if (user.loc == F)
			dirn = user.dir			// if laying on the tile we're on, lay in the direction we're facing
		else
			dirn = get_dir(F, user)

		for (var/obj/cable/LC in F)
			if (LC.d1 == dirn || LC.d2 == dirn)
				boutput(user, "There's already a cable at that position.")
				return

		var/obj/cable/C = new(F)
		C.d1 = 0
		C.d2 = dirn
		C.add_fingerprint(user)
		C.updateicon()
		C.update_network()
		applyCableMaterials(C, src.insulator, src.conductor)
		C.log_wirelaying(user)
		src.use(1)
	return

// called when cable_coil is click on an installed obj/cable
/obj/item/cable_coil/proc/cable_join(obj/cable/C, mob/user)
	var/turf/U = user.loc
	if (!isturf(U))
		return

	var/turf/T = C.loc

	if (!isturf(T) || T.intact)		// sanity checks, also stop use interacting with T-scanner revealed cable
		return

	if (get_dist(C, user) > 1)		// make sure it's close enough
		boutput(user, "You can't lay cable at a place that far away.")
		return

	if (U == T)		// do nothing if we clicked a cable we're standing on
		return		// may change later if can think of something logical to do

	var/dirn = get_dir(C, user)

	if (C.d1 == dirn || C.d2 == dirn)		// one end of the clicked cable is pointing towards us
		if (U.intact)						// can't place a cable if the floor is complete
			boutput(user, "You can't lay cable there unless the floor tiles are removed.")
			return
		else
			// cable is pointing at us, we're standing on an open tile
			// so create a stub pointing at the clicked cable on our tile

			var/fdirn = turn(dirn, 180)		// the opposite direction

			for (var/obj/cable/LC in U)		// check to make sure there's not a cable there already
				if (LC.d1 == fdirn && LC.d2 == fdirn)
					boutput(user, "There's already a cable at that position.")
					return

			var/obj/cable/NC = new(U)
			applyCableMaterials(NC, src.insulator, src.conductor)
			NC.d1 = 0
			NC.d2 = fdirn
			NC.add_fingerprint()
			NC.updateicon()
			NC.update_network()
			NC.log_wirelaying(user)
			src.use(1)
			C.shock(user, 25)
			return

	else if (C.d1 == 0)		// exisiting cable doesn't point at our position, so see if it's a stub
							// if so, make it a full cable pointing from it's old direction to our dirn

		var/nd1 = C.d2	// these will be the new directions
		var/nd2 = dirn

		if (nd1 > nd2)		// swap directions to match icons/states
			nd1 = dirn
			nd2 = C.d2


		for (var/obj/cable/LC in T)		// check to make sure there's no matching cable
			if (LC == C)			// skip the cable we're interacting with
				continue
			if ((LC.d1 == nd1 && LC.d2 == nd2) || (LC.d1 == nd2 && LC.d2 == nd1) )	// make sure no cable matches either direction
				boutput(user, "There's already a cable at that position.")
				return
		C.shock(user, 25)
		qdel(C)
		var/obj/cable/NC = new(T)
		applyCableMaterials(NC, src.insulator, src.conductor)
		NC.d1 = nd1
		NC.d2 = nd2
		NC.add_fingerprint()
		NC.updateicon()
		NC.update_network()
		NC.log_wirelaying(user)
		src.use(1)
		return