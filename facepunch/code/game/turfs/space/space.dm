var/global/space_icon = 'icons/turf/space.dmi'
var/global/space_icon_state = "default"
var/global/space_name = "space"
var/global/space_desc = "Dark and cold."


/turf/space
	name = "space"
	desc = "Dark and cold."
	icon = 'icons/turf/space.dmi'
	icon_state = "0"

	temperature = SPACE_TEMP
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 700000


	New()
		set_icon()
		return


	proc/set_icon()
		icon = space_icon
		if(space_icon_state == "default")
			icon_state = "[((x + y) ^ ~(x * y) + z) % 25]"
		else
			icon_state = space_icon_state
		name = space_name
		desc = space_desc
		return 1


	attack_paw(mob/user as mob)
		return src.attack_hand(user)


	attack_hand(mob/user as mob)
		if ((user.restrained() || !( user.pulling )))
			return
		if (user.pulling.anchored)
			return
		if ((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
			return
		if (ismob(user.pulling))
			var/mob/M = user.pulling
			var/atom/movable/t = M.pulling
			M.stop_pulling()
			step(user.pulling, get_dir(user.pulling.loc, src))
			M.start_pulling(t)
		else
			step(user.pulling, get_dir(user.pulling.loc, src))
		return


	attackby(obj/item/C as obj, mob/user as mob)
		if (istype(C, /obj/item/stack/rods))
			var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
			if(L)
				return
			var/obj/item/stack/rods/R = C
			user << "\blue Constructing support lattice ..."
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			ReplaceWithLattice()
			R.use(1)
			return

		if (istype(C, /obj/item/stack/tile/plasteel))
			var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
			if(!L)
				user << "\red The plating is going to need some support."
				return
			var/obj/item/stack/tile/plasteel/S = C
			del(L)
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			S.build(src)
			S.use(1)
			return


	Entered(atom/movable/A as mob|obj)
		..()
		if ((!(A) || src != A.loc))	return

		inertial_drift(A)

		if(ticker && ticker.mode)
			if(A.z > 5) return
			if (A.x <= TRANSITIONEDGE || A.x >= (world.maxx - TRANSITIONEDGE - 1) || A.y <= TRANSITIONEDGE || A.y >= (world.maxy - TRANSITIONEDGE - 1))
				if(istype(A, /obj/effect/meteor)||istype(A, /obj/effect/space_dust))
					del(A)
					return
				if(istype(A, /mob/living/carbon/slime)||istype(A, /mob/living/carbon/slime/adult))
					var/mob/living/carbon/slime/M = A
					if(M.stat == 2)
						del(M)
						return

				var/move_to_z = src.z
				//var/safety = 1

				if(ticker.mode.name == "nuclear emergency" && move_to_z == 1)//Its nuke and we are on Z level 1
					move_to_z = 1//This is pointless but I cant think well enough atm to restructure this tree
				/*else if(move_to_z == 6) Currently Z6 is away mission//The space level should not loop back to itself due to the high chance
					while(move_to_z == 6)//src.z)//Select a level
						var/move_to_z_str = pickweight(accessable_z_levels)
						move_to_z = text2num(move_to_z_str)
						safety++
						if(safety > 10)
							break*/
				else//Otherwise just pick a level
					move_to_z = text2num(pickweight(accessable_z_levels))

				if(!move_to_z)
					return

				A.z = move_to_z

				if(src.x <= TRANSITIONEDGE)
					A.x = world.maxx - TRANSITIONEDGE - 2
					A.y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

				else if (A.x >= (world.maxx - TRANSITIONEDGE - 1))
					A.x = TRANSITIONEDGE + 1
					A.y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

				else if (src.y <= TRANSITIONEDGE)
					A.y = world.maxy - TRANSITIONEDGE -2
					A.x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

				else if (A.y >= (world.maxy - TRANSITIONEDGE - 1))
					A.y = TRANSITIONEDGE + 1
					A.x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

				spawn (0)
					if ((A && A.loc))
						A.loc.Entered(A)
		return

/*
/turf/space/proc/Sandbox_Spacemove(atom/movable/A as mob|obj)
	var/cur_x
	var/cur_y
	var/next_x
	var/next_y
	var/target_z
	var/list/y_arr

	if(src.x <= 1)
		if(istype(A, /obj/effect/meteor)||istype(A, /obj/effect/space_dust))
			del(A)
			return

		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		next_x = (--cur_x||global_map.len)
		y_arr = global_map[next_x]
		target_z = y_arr[cur_y]
/*
		//debug
		world << "Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]"
		world << "Target Z = [target_z]"
		world << "Next X = [next_x]"
		//debug
*/
		if(target_z)
			A.z = target_z
			A.x = world.maxx - 2
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
	else if (src.x >= world.maxx)
		if(istype(A, /obj/effect/meteor))
			del(A)
			return

		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		next_x = (++cur_x > global_map.len ? 1 : cur_x)
		y_arr = global_map[next_x]
		target_z = y_arr[cur_y]
/*
		//debug
		world << "Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]"
		world << "Target Z = [target_z]"
		world << "Next X = [next_x]"
		//debug
*/
		if(target_z)
			A.z = target_z
			A.x = 3
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
	else if (src.y <= 1)
		if(istype(A, /obj/effect/meteor))
			del(A)
			return
		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		y_arr = global_map[cur_x]
		next_y = (--cur_y||y_arr.len)
		target_z = y_arr[next_y]
/*
		//debug
		world << "Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]"
		world << "Next Y = [next_y]"
		world << "Target Z = [target_z]"
		//debug
*/
		if(target_z)
			A.z = target_z
			A.y = world.maxy - 2
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)

	else if (src.y >= world.maxy)
		if(istype(A, /obj/effect/meteor)||istype(A, /obj/effect/space_dust))
			del(A)
			return
		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		y_arr = global_map[cur_x]
		next_y = (++cur_y > y_arr.len ? 1 : cur_y)
		target_z = y_arr[next_y]
/*
		//debug
		world << "Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]"
		world << "Next Y = [next_y]"
		world << "Target Z = [target_z]"
		//debug
*/
		if(target_z)
			A.z = target_z
			A.y = 3
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
	return*/