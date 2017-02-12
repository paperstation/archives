/*
CONTAINS:
RCD

*/
/obj/item/rcd
	name = "rapid-construction-device (RCD)"
	desc = "A device used to rapidly build walls/floor."
	icon = 'icons/obj/items.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	icon_state = "rcd"
	opacity = 0
	density = 0
	anchored = 0.0
	var/matter = 0
	var/max_matter = 50
	var/working = 0
	var/mode = 1
	flags = FPRINT | TABLEPASS| CONDUCT
	force = 10.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 5
	w_class = 3.0
	m_amt = 50000
	var/datum/effects/system/spark_spread/spark_system
	mats = 12
	stamina_damage = 15
	stamina_cost = 15
	stamina_crit_chance = 5
	module_research = list("tools" = 8, "engineering" = 8, "devices" = 3, "efficiency" = 5)
	module_research_type = /obj/item/rcd

	var/matter_create_floor = 1
	var/matter_create_wall = 2
	var/matter_create_door = 5
	var/matter_remove_door = 15
	var/matter_remove_floor = 8
	var/matter_remove_wall = 8

	var/material_name = "steel"

	cyborg
		material_name = "electrum"

/obj/item/rcd/construction
	name = "rapid-construction-device (RCD) deluxe"
	desc = "A device used to rapidly construct."
	max_matter = 15000

	matter_remove_door = 3
	matter_remove_wall = 2
	matter_remove_floor = 2

	var/static/hangar_id_number = 1
	var/hangar_id = null
	var/door_name = null
	var/door_access = 0
	var/door_access_name_cache = null
	var/door_type_name_cache = null
	var/static/list/access_names = list()
	var/door_type = null
	var/static/list/door_types = list("Command" = /obj/machinery/door/airlock/command, "Security" = /obj/machinery/door/airlock/security, \
"Engineering" = /obj/machinery/door/airlock/engineering, "Medical" = /obj/machinery/door/airlock/medical, \
"Glass" = /obj/machinery/door/airlock/glass, "Glass (Command)" = /obj/machinery/door/airlock/glass/command, \
"Glass (Engineering)" = /obj/machinery/door/airlock/glass/engineering, "Glass (Medical)" = /obj/machinery/door/airlock/glass/medical, \
"Classic" = /obj/machinery/door/airlock/classic, "Maintenance" = /obj/machinery/door/airlock/maintenance, "External" = /obj/machinery/door/airlock/external)

/obj/item/rcd_fake
	name = "rapid-construction-device (RCD)"
	desc = "A device used to rapidly build walls/floor."
	icon = 'icons/obj/items.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	icon_state = "rcd"
	opacity = 0
	density = 0
	anchored = 0.0
	flags = FPRINT | TABLEPASS| CONDUCT
	force = 10.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 5
	w_class = 3.0

/obj/item/rcd_ammo
	name = "Compressed matter cartridge"
	desc = "Highly compressed matter for the RCD."
	icon = 'icons/obj/ammo.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	icon_state = "rcd"
	item_state = "rcdammo"
	opacity = 0
	density = 0
	anchored = 0.0
	m_amt = 30000
	g_amt = 15000
	var/matter = 10

	examine()
		..()
		boutput(usr, "It contains [matter] units of ammo.")

/obj/item/rcd_ammo/big
	name = "Large compressed matter cartridge"
	matter = 100

/obj/item/rcd/New()
	desc = "A RCD. It currently holds [matter]/[max_matter] matter-units."
	src.spark_system = unpool(/datum/effects/system/spark_spread)
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	return

/obj/item/rcd/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/rcd_ammo))
		if (!W:matter)
			return
		if (matter == max_matter)
			boutput(user, "The RCD can't hold any more matter.")
			return
		if (matter + W:matter > max_matter)
			W:matter -= (max_matter - matter)
			boutput(user, "The cartridge now contains [W:matter] units of matter.")
			matter = max_matter
		else
			matter += W:matter
			W:matter = 0
			qdel(W)
		playsound(src.loc, "sound/machines/click.ogg", 50, 1)
		boutput(user, "The RCD now holds [matter]/[max_matter] matter-units.")
		desc = "A RCD. It currently holds [matter]/[max_matter] matter-units."
		return

/obj/item/rcd/attack_self(mob/user as mob)
	playsound(src.loc, "sound/effects/pop.ogg", 50, 0)
	if (mode == 1)
		mode = 2
		boutput(user, "Changed mode to 'Airlock'")
		src.spark_system.start()
		return
	if (mode == 2)
		mode = 3
		boutput(user, "Changed mode to 'Deconstruct'")
		src.spark_system.start()
		return
	if (mode == 3)
		mode = 1
		boutput(user, "Changed mode to 'Floor & Walls'")
		src.spark_system.start()
		return
	// Change mode

/obj/item/rcd/construction/attack_self(mob/user as mob)
	if (mode == 1 || mode == 2)
		..()
	else if (mode == 3)
		mode = 4
		boutput(user, "Changed mode to 'Pod Door Control'")
		boutput(user, "<span style=\"color:blue\">Place a door control on a wall, then place any amount of pod doors on floors.</span>")
		boutput(user, "<span style=\"color:blue\">You can also select an existing door control by whacking it with the RCD.</span>")
	else if (mode == 4 || mode == 5)
		mode = 1
		boutput(user, "Changed mode to 'Floor & Walls'")
		src.spark_system.start()
		return

/obj/item/rcd/proc/create_door(var/turf/A, mob/user as mob)
	boutput(user, "Building Airlock ([matter_create_door])...")
	playsound(src.loc, "sound/machines/click.ogg", 50, 1)
	if(do_after(user, 50))
		if (rcd_ammocheck(user, matter_create_door))
			spark_system.set_up(5, 0, src)
			src.spark_system.start()
			var/obj/machinery/door/airlock/T = new /obj/machinery/door/airlock( A )
			logTheThing("station", user, null, "builds an Airlock using the RCD in [user.loc.loc] ([showCoords(user.x, user.y, user.z)])")
			rcd_ammoconsume(user, matter_create_door)
			T.autoclose = 1
			playsound(src.loc, "sound/items/Deconstruct.ogg", 50, 1)
			playsound(src.loc, "sound/effects/sparks2.ogg", 50, 1)

/obj/item/rcd/construction/create_door(var/turf/A, mob/user as mob)
	var/turf/L = get_turf(user)
	var/set_data = 0
	if (door_name)
		if (alert("Use saved data?",,"Yes","No") == "No")
			set_data = 1
	else
		set_data = 1
	if (set_data)
		door_name = copytext(adminscrub(input("Door name", "Door name", door_name) as text), 1, 512)
		if (!access_names.len)
			for (var/access in get_all_accesses())
				var/access_name = get_access_desc(access)
				access_names[access_name] = access
		door_access_name_cache = input("Required access", "Required access", door_access_name_cache) in access_names
		door_access = access_names[door_access_name_cache]
		door_type_name_cache = input("Door type", "Door type", door_type_name_cache) in door_types
		door_type = door_types[door_type_name_cache]

	if (user.loc != L)
		boutput(user, "<span style=\"color:red\">Stand still you oaf.</span>")
		return

	boutput(user, "Building Airlock ([matter_create_door])...")
	playsound(src.loc, "sound/machines/click.ogg", 50, 1)
	if(do_after(user, 50))
		if (rcd_ammocheck(user, matter_create_door))
			spark_system.set_up(5, 0, src)
			src.spark_system.start()
			var/obj/machinery/door/airlock/T = new door_type( A )
			logTheThing("station", user, null, "builds an Airlock ([T], name: [door_name], access: [door_access]) using the RCD in [user.loc.loc] ([showCoords(user.x, user.y, user.z)])")
			rcd_ammoconsume(user, matter_create_door)
			T.autoclose = 1
			T.name = door_name
			T.req_access = list(door_access)
			T.req_access_txt = "[door_access]"
			playsound(src.loc, "sound/items/Deconstruct.ogg", 50, 1)
			playsound(src.loc, "sound/effects/sparks2.ogg", 50, 1)

/obj/item/rcd/construction/afterattack(atom/A, mob/user as mob)
	..()
	if (mode == 3)
		if (istype(A, /obj/machinery/door/poddoor/blast) && rcd_ammocheck(user, matter_remove_door, 500))
			var /obj/machinery/door/poddoor/blast/B = A
			if (findtext(B.id, "rcd_built") != 0)
				boutput(user, "Deconstructing Pod Door ([matter_remove_door])...")
				playsound(src.loc, "sound/machines/click.ogg", 50, 1)
				if(do_after(user, 50))
					if (rcd_ammocheck(user, matter_remove_door))
						playsound(src.loc, "sound/items/Deconstruct.ogg", 50, 1)
						spark_system.set_up(5, 0, src)
						src.spark_system.start()
						rcd_ammoconsume(user, matter_remove_door)
						qdel(A)
						logTheThing("station", user, null, "removes a Pod Door using the RCD in [user.loc.loc] ([showCoords(user.x, user.y, user.z)])")
						playsound(src.loc, "sound/items/Deconstruct.ogg", 50, 1)
			else
				boutput(user, "<span style=\"color:red\">You cannot deconstruct that!</span>")
				return
		else if (istype(A, /obj/machinery/r_door_control) && rcd_ammocheck(user, matter_remove_door, 500))
			var/obj/machinery/r_door_control/R = A
			if (findtext(R.id, "rcd_built") != 0)
				boutput(user, "Deconstructing Door Control ([matter_remove_door])...")
				playsound(src.loc, "sound/machines/click.ogg", 50, 1)
				if(do_after(user, 50))
					if (rcd_ammocheck(user, matter_remove_door))
						playsound(src.loc, "sound/items/Deconstruct.ogg", 50, 1)
						spark_system.set_up(5, 0, src)
						src.spark_system.start()
						rcd_ammoconsume(user, matter_remove_door)
						qdel(A)
						logTheThing("station", user, null, "removes a Door Control using the RCD in [user.loc.loc] ([showCoords(user.x, user.y, user.z)])")
						playsound(src.loc, "sound/items/Deconstruct.ogg", 50, 1)
			else
				boutput(user, "<span style=\"color:red\">You cannot deconstruct that!</span>")
				return
	else if (mode == 4)
		if (istype(A, /obj/machinery/r_door_control))
			var/obj/machinery/r_door_control/R = A
			if (findtext(R.id, "rcd_built") != 0)
				boutput(user, "<span style=\"color:blue\">Selected.</span>")
				hangar_id = R.id
				mode = 5
			else
				boutput(user, "<span style=\"color:red\">You cannot modify that!</span>")
		else if (istype(A, /turf/simulated/wall) && rcd_ammocheck(user, matter_create_door, 500))
			boutput(user, "Creating Door Control ([matter_create_door])")
			playsound(src.loc, "sound/machines/click.ogg", 50, 1)
			if(do_after(user, 50))
				if (rcd_ammocheck(user, matter_create_door))
					playsound(src.loc, "sound/items/Deconstruct.ogg", 50, 1)
					spark_system.set_up(5, 0, src)
					src.spark_system.start()
					var/idn = hangar_id_number
					hangar_id_number++
					hangar_id = "rcd_built_[idn]"
					mode = 5
					var/obj/machinery/r_door_control/R = new /obj/machinery/r_door_control(A)
					R.id="[hangar_id]"
					R.pass="[hangar_id]"
					R.name="Access code: [hangar_id]"
					rcd_ammoconsume(user, matter_create_door)
					logTheThing("station", user, null, "creates Door Control [hangar_id] using the RCD in [user.loc.loc] ([showCoords(user.x, user.y, user.z)])")
					boutput(user, "Now creating pod bay blast doors linked to the new door control.")
	else if (mode == 5)
		if (istype(A, /turf/simulated/floor) && rcd_ammocheck(user, matter_create_door, 500))
			boutput(user, "Creating Pod Bay Door ([matter_create_door])")
			playsound(src.loc, "sound/machines/click.ogg", 50, 1)
			if(do_after(user, 50))
				if (rcd_ammocheck(user, matter_create_door))
					playsound(src.loc, "sound/items/Deconstruct.ogg", 50, 1)
					spark_system.set_up(5, 0, src)
					src.spark_system.start()
					var/stepdir = get_dir(src, A)
					var/poddir = turn(stepdir, 90)
					var/obj/machinery/door/poddoor/blast/B = new /obj/machinery/door/poddoor/blast(A)
					B.id = "[hangar_id]"
					B.dir = poddir
					B.autoclose = 1
					rcd_ammoconsume(user, matter_create_door)
					logTheThing("station", user, null, "creates Blast Door [hangar_id] using the RCD in [user.loc.loc] ([showCoords(user.x, user.y, user.z)])")

/obj/item/rcd/afterattack(atom/A, mob/user as mob)
	if (!(istype(A, /turf) || istype(A, /obj/machinery/door/airlock)))
		return
	if (istype(A, /turf) && mode == 1)
		if (istype(A, /turf/space) && rcd_ammocheck(user, matter_create_floor, 50))
			boutput(user, "Building Floor ([matter_create_floor])...")
			playsound(src.loc, "sound/items/Deconstruct.ogg", 50, 1)
			spark_system.set_up(5, 0, src)
			src.spark_system.start()
			var/turf/simulated/floor/T = A:ReplaceWithFloor()
			T.setMaterial(getCachedMaterial(material_name))
			rcd_ammoconsume(user, matter_create_floor)
			return
		if (istype(A, /turf/simulated/floor) && rcd_ammocheck(user, matter_create_wall, 150))
			boutput(user, "Building Wall ([matter_create_wall])...")
			playsound(src.loc, "sound/machines/click.ogg", 50, 1)
			if(do_after(user, 20))
				if (rcd_ammocheck(user, matter_create_wall))
					spark_system.set_up(5, 0, src)
					src.spark_system.start()
					var/datum/material/M = A:material
					var/turf/simulated/wall/T = A:ReplaceWithWall()
					if (M)
						T.setMaterial(M)
					else
						T.setMaterial(getCachedMaterial(material_name))

					logTheThing("station", user, null, "builds a Wall using the RCD in [user.loc.loc] ([showCoords(user.x, user.y, user.z)])")
					playsound(src.loc, "sound/items/Deconstruct.ogg", 50, 1)
					rcd_ammoconsume(user, matter_create_wall)
			return
	else if (istype(A, /turf/simulated/floor) && mode == 2 && rcd_ammocheck(user, matter_create_door, 1000))
		create_door(A, user)
		return
	else if (mode == 3 && (istype(A, /turf) || istype(A, /obj/machinery/door/airlock) ) )
		if (istype(A, /turf/simulated/wall) && rcd_ammocheck(user, matter_remove_wall, 500))
			boutput(user, "Deconstructing Wall ([matter_remove_wall])...")
			playsound(src.loc, "sound/machines/click.ogg", 50, 1)
			if(do_after(user, 50))
				if (rcd_ammocheck(user, matter_remove_wall))
					spark_system.set_up(5, 0, src)
					src.spark_system.start()
					rcd_ammoconsume(user, matter_remove_wall)
					var/datum/material/M = A:material
					var/turf/simulated/floor/T = A:ReplaceWithFloor()
					if (M)
						T.setMaterial(M)
					else
						T.setMaterial(getCachedMaterial(material_name))

					logTheThing("station", user, null, "removes a Wall using the RCD in [user.loc.loc] ([showCoords(user.x, user.y, user.z)])")
					playsound(src.loc, "sound/items/Deconstruct.ogg", 50, 1)
			return
		if ((istype(A, /turf/simulated/wall/r_wall) || istype(A, /turf/simulated/wall/auto/reinforced)) && rcd_ammocheck(user, matter_remove_wall, 500))
			boutput(user, "Deconstructing RWall ([matter_remove_wall])...")
			playsound(src.loc, "sound/machines/click.ogg", 50, 1)
			if(do_after(user, 50))
				if (rcd_ammocheck(user, matter_remove_door))
					spark_system.set_up(5, 0, src)
					src.spark_system.start()
					rcd_ammoconsume(user, matter_remove_wall)
					var/datum/material/M = A:material
					var/turf/simulated/wall/T = A:ReplaceWithWall()
					if (M)
						T.setMaterial(M)
					else
						T.setMaterial(getCachedMaterial(material_name))

					playsound(src.loc, "sound/items/Deconstruct.ogg", 50, 1)
			return
		if (istype(A, /turf/simulated/floor) && rcd_ammocheck(user, matter_remove_floor, 500))
			boutput(user, "Deconstructing Floor ([matter_remove_floor])...")
			playsound(src.loc, "sound/machines/click.ogg", 50, 1)
			if(do_after(user, 50))
				if (rcd_ammocheck(user, matter_remove_floor))
					spark_system.set_up(5, 0, src)
					src.spark_system.start()
					rcd_ammoconsume(user, matter_remove_floor)
					A:ReplaceWithSpace()
					logTheThing("station", user, null, "removes the floor using the RCD in [user.loc.loc] ([showCoords(user.x, user.y, user.z)])")
					playsound(src.loc, "sound/items/Deconstruct.ogg", 50, 1)
			return

		if (istype(A, /obj/machinery/door/airlock) && rcd_ammocheck(user, matter_remove_door, 500))
			var/obj/machinery/door/airlock/AL = A
			if (AL.hardened == 1)
				boutput(user, "<span style=\"color:red\">The airlock is reinforced against rapid deconstruction!</span>")
				return
			boutput(user, "Deconstructing Airlock ([matter_remove_door])...")
			playsound(src.loc, "sound/machines/click.ogg", 50, 1)
			if(do_after(user, 50))
				if (rcd_ammocheck(user, matter_remove_door))
					spark_system.set_up(5, 0, src)
					src.spark_system.start()
					rcd_ammoconsume(user, matter_remove_door)
					qdel(AL)
					logTheThing("station", user, null, "removes an airlock using the RCD at [log_loc(user)].")
					playsound(src.loc, "sound/items/Deconstruct.ogg", 50, 1)
			return

/* /obj/item/rcd/attack(mob/M as mob, mob/user as mob, def_zone)
	if (ishuman(M) && matter >= 3)
		var/mob/living/carbon/human/H = M
		if(H.stat != 2 && H.health > 0)
			boutput(user, "<span style=\"color:red\">You poke [H] with the RCD.</span>")
			boutput(H, "<span style=\"color:red\">[user] pokes you with the RCD.</span>")
			return
		boutput(user, "<span style=\"color:red\"><B>You shove the RCD down [H]'s mouth and pull the trigger!</B></span>")
		H.show_message("<span style=\"color:red\"><B>[user] is shoving an RCD down your throat!</B></span>", 1)
		for(var/mob/N in viewers(user, 3))
			if(N.client && N != user && N != H)
				N.show_message(text("<span style=\"color:red\"><B>[] shoves the RCD down []'s throat!</B></span>", user, H), 1)
		playsound(src.loc, "sound/machines/click.ogg", 50, 1)
		if(do_after(user, 20))
			spark_system.set_up(5, 0, src)
			src.spark_system.start()
			var/mob/living/carbon/wall/W = new(H.loc)
			W.real_name = H.real_name
			playsound(src.loc, "sound/items/Deconstruct.ogg", 50, 1)
			playsound(src.loc, "sound/effects/splat.ogg", 50, 1)
			if(H.mind)
				H.mind.transfer_to(W)
			H.gib()
			matter -= 3
			boutput(user, "The RCD now holds [matter]/30 matter-units.")
			desc = "A RCD. It currently holds [matter]/30 matter-units."
		return
	else
		return ..(M, user, def_zone) */

/obj/item/rcd/proc/rcd_ammocheck(mob/user as mob, var/checkamt = 0)
	if (istype(user,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = user
		if (R.cell.charge >= checkamt * 5) return 1
		else return 0
	else if (istype(user,/mob/living/silicon/ghostdrone))
		var/mob/living/silicon/ghostdrone/R = user
		if (R.cell.charge >= checkamt * 5) return 1
		else return 0
	else
		if (src.matter >= checkamt) return 1
		else return 0

/obj/item/rcd/proc/rcd_ammoconsume(mob/user as mob, var/checkamt = 0)
	if (istype(user,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = user
		R.cell.charge -= checkamt * 125
	else if (istype(user,/mob/living/silicon/ghostdrone))
		var/mob/living/silicon/ghostdrone/R = user
		R.cell.charge -= checkamt * 125
	else
		src.matter -= checkamt
		boutput(user, "The RCD now holds [src.matter]/[src.max_matter] matter-units.")
		src.desc = "A RCD. It currently holds [src.matter]/[src.max_matter] matter-units."
