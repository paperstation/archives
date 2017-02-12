/obj/table
	name = "table"
	desc = "A metal table strong enough to support a substantial amount of weight, but easily made portable by unsecuring the bolts with a wrench."
	icon = 'icons/obj/table.dmi'//'icons/obj/structures.dmi'
	icon_state = "0"
	density = 1
	anchored = 1.0
	flags = NOSPLASH
	var/auto_type = /obj/table/auto
	var/auto = 0

	New()
		..()
		spawn(10)
			if (src.auto)
				if (ispath(src.auto_type) && src.icon_state == "0") // if someone's set up a special icon state don't mess with it
					src.set_up()
					spawn(1)
						for (var/obj/table/T in orange(1))
							if (T.auto)
								T.set_up()

		var/bonus = 0
		for (var/obj/O in loc)
			if (istype(O, /obj/item))
				bonus += 4
			if (istype(O, /obj/table) && O != src)
				return
			if (istype(O, /obj/rack))
				return
		var/area/Ar = get_area(src)
		if (Ar)
			Ar.sims_score = min(Ar.sims_score + bonus, 100)

	proc/set_up()
		if (!ispath(src.auto_type))
			return
		var/dirs = 0
		for (var/direction in cardinal)
			var/turf/T = get_step(src, direction)
			if (locate(src.auto_type) in T)
				dirs |= direction
		icon_state = num2text(dirs)

		//christ this is ugly
		var/obj/table/SWT = locate(src.auto_type) in get_step(src, SOUTHWEST)
		if (SWT)
			var/obj/table/ST = locate(src.auto_type) in get_step(src, SOUTH)
			var/obj/table/WT = locate(src.auto_type) in get_step(src, WEST)
			if (ST && WT)
				src.overlays += "SW"

		var/obj/table/SET = locate(src.auto_type) in get_step(src, SOUTHEAST)
		if (SET)
			var/obj/table/ST = locate(src.auto_type) in get_step(src, SOUTH)
			var/obj/table/ET = locate(src.auto_type) in get_step(src, EAST)
			if (ST && ET)
				src.overlays += "SE"

		var/obj/table/NWT = locate(src.auto_type) in get_step(src, NORTHWEST)
		if (NWT)
			var/obj/table/NT = locate(src.auto_type) in get_step(src, NORTH)
			var/obj/table/WT = locate(src.auto_type) in get_step(src, WEST)
			if (NT && WT)
				src.overlays += "NW"

		var/obj/table/NET = locate(src.auto_type) in get_step(src, NORTHEAST)
		if (NET)
			var/obj/table/NT = locate(src.auto_type) in get_step(src, NORTH)
			var/obj/table/ET = locate(src.auto_type) in get_step(src, EAST)
			if (NT && ET)
				src.overlays += "NE"

	suicide(var/mob/user as mob) //if this is TOO ridiculous just remove it idc
		user.visible_message("<span style=\"color:red\"><b>[user] contorts \himself so that \his head is underneath one of the [src.name]'s legs and \his heels are resting on top of it, then raises \his feet and slams them back down over and over again!</b></span>")
		user.TakeDamage("head", 175, 0)
		user.updatehealth()
		spawn(100)
			if (user)
				user.suiciding = 0
		return 1

/obj/table/auto
	auto = 1

/obj/table/round
	icon = 'icons/obj/table_round.dmi'

	auto
		auto = 1
		auto_type = /obj/table/round/auto

/obj/table/wood
	name = "wooden table"
	desc = "A table made from solid oak, which is quite rare in space."
	icon = 'icons/obj/table_wood.dmi'

	auto
		auto = 1
		auto_type = /obj/table/wood/auto

/obj/table/wood/round
	icon = 'icons/obj/table_wood_round.dmi'

	auto
		auto = 1
		auto_type = /obj/table/wood/round/auto

/obj/table/reinforced
	name = "reinforced table"
	desc = "A table made from reinforced metal, it is quite strong and it requires welding and wrenching to disassemble it."
	icon = 'icons/obj/table_reinforced.dmi'
	var/status = 2

	auto
		auto = 1
		auto_type = /obj/table/reinforced/auto

/obj/table/reinforced/bar
	name = "bar table"
	desc = "A reinforced table with a faux wooden finish to make you feel at ease."
	icon = 'icons/obj/table_bar.dmi'

	auto
		auto = 1
		auto_type = /obj/table/reinforced/bar/auto

/* =================================================== */
/* -------------------- Auto-Join -------------------- */
/* =================================================== */
/*
/* ---------- Table ---------- */

/obj/table/auto
	icon = 'icons/obj/table.dmi'
	icon_state = "0"

	New()
		spawn(1)
			src.set_up()
			for (var/obj/table/auto/T in orange(1))
				T.set_up()
			..()

	proc/set_up()
		var/dirs = 0
		for (var/direction in cardinal)
			var/turf/T = get_step(src, direction)
			if (locate(/obj/table/auto) in T)
				dirs |= direction
		icon_state = num2text(dirs)

/* ---------- Round ---------- */

/obj/table/round/auto
	icon = 'icons/obj/table_round.dmi'
	icon_state = "0"

	New()
		spawn(1)
			src.set_up()
			for (var/obj/table/round/auto/T in orange(1))
				T.set_up()
			..()

	proc/set_up()
		var/dirs = 0
		for (var/direction in cardinal)
			var/turf/T = get_step(src, direction)
			if (locate(/obj/table/round/auto) in T)
				dirs |= direction
		icon_state = num2text(dirs)

/* ---------- Wood ---------- */

/obj/table/woodentable/auto
	icon = 'icons/obj/table_wood.dmi'
	icon_state = "0"

	New()
		spawn(1)
			src.set_up()
			for (var/obj/table/woodentable/auto/T in orange(1))
				T.set_up()
			..()

	proc/set_up()
		var/dirs = 0
		for (var/direction in cardinal)
			var/turf/T = get_step(src, direction)
			if (locate(/obj/table/woodentable/auto) in T)
				dirs |= direction
		icon_state = num2text(dirs)

/* ---------- Round Wood ---------- */

/obj/table/woodentable/round/auto
	icon = 'icons/obj/table_wood_round.dmi'
	icon_state = "0"

	New()
		spawn(1)
			src.set_up()
			for (var/obj/table/woodentable/round/auto/T in orange(1))
				T.set_up()
			..()

	proc/set_up()
		var/dirs = 0
		for (var/direction in cardinal)
			var/turf/T = get_step(src, direction)
			if (locate(/obj/table/woodentable/round/auto) in T)
				dirs |= direction
		icon_state = num2text(dirs)

/* ---------- Reinforced ---------- */

/obj/table/reinforced/auto
	icon = 'icons/obj/table_reinforced.dmi'
	icon_state = "0"

	New()
		spawn(1)
			src.set_up()
			for (var/obj/table/reinforced/auto/T in orange(1))
				T.set_up()
			..()

	proc/set_up()
		var/dirs = 0
		for (var/direction in cardinal)
			var/turf/T = get_step(src, direction)
			if (locate(/obj/table/reinforced/auto) in T)
				dirs |= direction
		icon_state = num2text(dirs)

/* ---------- Bar ---------- */

/obj/table/reinforced/bar/auto
	icon = 'icons/obj/table_bar.dmi'
	icon_state = "0"

	New()
		spawn(1)
			src.set_up()
			for (var/obj/table/reinforced/bar/auto/T in orange(1))
				T.set_up()
			..()

	proc/set_up()
		var/dirs = 0
		for (var/direction in cardinal)
			var/turf/T = get_step(src, direction)
			if (locate(/obj/table/reinforced/bar/auto) in T)
				dirs |= direction
		icon_state = num2text(dirs)
*/
/* ======================================== */
/* ---------------------------------------- */
/* ======================================== */

/obj/table/ex_act(severity)
	switch(severity)
		if(1.0)
			//SN src = null
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				//SN src = null
				qdel(src)
				return
		if(3.0)
			if (prob(25))
				src.density = 0
		else
	return
//

/obj/table/dispose()
	var/turf/OL = get_turf(src)
	loc = null
	if (!OL)
		return
	if (!(locate(/obj/table) in OL) && !(locate(/obj/rack) in OL))
		var/area/Ar = OL.loc
		for (var/obj/item/I in OL)
			Ar.sims_score -= 4
		Ar.sims_score = max(Ar.sims_score, 0)
	..()

/obj/table/blob_act(var/power)
	if (prob(power * 2.5))
		var/atom/A = new /obj/item/table_parts(src.loc)
		if (src.material)
			A.setMaterial(src.material)
		qdel(src)

/obj/table/attack_hand(mob/user as mob)
	if (user.bioHolder && user.bioHolder.HasEffect("hulk"))
		user.visible_message("<span style=\"color:red\">[user] destroys the table.</span>")
		if (istype(src, /obj/table/reinforced))
			var/atom/A = new /obj/item/table_parts/reinforced(src.loc)
			if (src.material)
				A.setMaterial(src.material)
		else
			var/atom/A = new /obj/item/table_parts(src.loc)
			if (src.material)
				A.setMaterial(src.material)
		src.density = 0
		qdel(src)
	if (ishuman(user))
		var/mob/living/carbon/human/H = user
		if (istype(H.w_uniform, /obj/item/clothing/under/misc/lawyer))
			src.visible_message("<span style=\"color:red\"><b>[H] slams their palms against [src]!</b></span>")
			playsound(src.loc, "sound/misc/meteorimpact.ogg", 50, 1)
			for (var/mob/N in AIviewers(usr, null))
				if (N.client)
					shake_camera(N, 4, 1, 0.5)
	return

/obj/table/meteorhit()
	if(istype(src, /obj/table/reinforced))
		var/atom/A = new /obj/item/table_parts/reinforced( src.loc )
		if(src.material) A.setMaterial(src.material)
	else
		var/atom/A = new /obj/item/table_parts( src.loc )
		if(src.material) A.setMaterial(src.material)
	qdel(src)

/obj/table/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1

	if ((mover.flags & TABLEPASS || istype(mover, /obj/newmeteor)) )
		return 1
	else
		return 0

/obj/table/MouseDrop_T(obj/O as obj, mob/user as mob)

	if (istype(O,/obj/item/satchel/))
		if (O.contents.len < 1)
			boutput(usr, "<span style=\"color:red\">There's nothing in the satchel!</span>")
		else
			user.visible_message("<span style=\"color:blue\">[user] dumps out [O]'s contents onto [src]!</span>")
			for(var/obj/item/I in O.contents) I.set_loc(src.loc)
			O.desc = "A leather bag. It holds 0/[O:maxitems] [O:itemstring]."
			O:satchel_updateicon()
			return
	if (isrobot(user) || (!( istype(O, /obj/item) ) || user.equipped() != O) || (O:cant_drop || O:cant_self_remove))
		return
	user.drop_item()
	if (O.loc != src.loc)
		step(O, get_dir(O, src))
	return

/obj/table/proc/smash_bottle(var/mob/user as mob, var/obj/item/reagent_containers/food/drinks/bottle/bottle as obj)
	if (!istype(bottle, /obj/item/reagent_containers/food/drinks/bottle) || user.a_intent != "harm")
		return
	if (issilicon(user) || !user.reagents)
		return

	var/turf/U = user.loc
	var/damage = rand(5,15)

	if (bottle.broken)
		user.visible_message("<span style=\"color:red\"><b>[user] smashes [bottle] on [src]! [bottle] shatters completely!</span>")
		playsound(U, pick('sound/effects/Glassbr1.ogg','sound/effects/Glassbr2.ogg','sound/effects/Glassbr3.ogg'), 100, 1)
		new /obj/item/raw_material/shard/glass(U)
		bottle.reagents.reaction(U)
		qdel(bottle)
		if (prob (50))
			user.visible_message("<span style=\"color:red\">The broken shards of [bottle] slice up [user]'s hand!</span>")
			playsound(U, "sound/effects/splat.ogg", 50, 1)
			random_brute_damage(user, damage)
			take_bleeding_damage(user, user, damage)
		return

	if (bottle.unbreakable)
		boutput(user, "[bottle] bounces uselessly off [src]!")
		return

	var/success_prob = 25
	var/hurt_prob = 50

	if (user.reagents.has_reagent("ethanol") && user.mind && user.mind.assigned_role == "Barman")
		success_prob = 75
		hurt_prob = 25

	else if (user.mind && user.mind.assigned_role == "Barman")
		success_prob = 50
		hurt_prob = 10

	else if (user.reagents.has_reagent("ethanol"))
		success_prob = 75
		hurt_prob = 75

	if (prob(success_prob))
		user.visible_message("<span style=\"color:red\"><b>[user] smashes [bottle] on [src], shattering it open![prob(50) ? " [user] looks like they're ready for a fight!" : " [bottle] has one mean edge on it!"]</span>")
		playsound(U, pick('sound/effects/Glassbr1.ogg','sound/effects/Glassbr2.ogg','sound/effects/Glassbr3.ogg'), 100, 1)
		new /obj/item/raw_material/shard/glass(U)
		bottle.broken = 1
		bottle.reagents.reaction(U)
		bottle.create_reagents(0)
		bottle.update_icon()

	else
		user.visible_message("<span style=\"color:red\"><b>[user] smashes [bottle] on [src]! [bottle] shatters completely!</span>")
		playsound(U, pick('sound/effects/Glassbr1.ogg','sound/effects/Glassbr2.ogg','sound/effects/Glassbr3.ogg'), 100, 1)
		new /obj/item/raw_material/shard/glass(U)
		bottle.reagents.reaction(U)
		qdel(bottle)
		if (prob(hurt_prob))
			user.visible_message("<span style=\"color:red\">The broken shards of [bottle] slice up [user]'s hand!</span>")
			playsound(U, "sound/effects/splat.ogg", 50, 1)
			random_brute_damage(user, damage)
			take_bleeding_damage(user, user, damage)

/obj/table/attackby(obj/item/W as obj, mob/user as mob, params)
	if (istype(W, /obj/item/grab))
		var/obj/item/grab/G = W
		if(!G.affecting || G.affecting.buckled)
			return
		if(!G.state)
			boutput(usr, "<span style=\"color:red\">You need a tighter grip!</span>")
			return
		G.affecting.set_loc(src.loc)
		G.affecting.weakened = 2
		src.visible_message("<span style=\"color:red\">[G.assailant] puts [G.affecting] on the table.</span>")
		if(G.affecting.bioHolder.HasEffect("fat")) // fatties crash through the table instead :V
			var/atom/A = new /obj/item/table_parts( src.loc )
			if(src.material) A.setMaterial(src.material)
			qdel(src)
		qdel(W)
		return

	else if (istype(W, /obj/item/wrench))
		boutput(user, "<span style=\"color:blue\">Now disassembling table</span>")
		playsound(src.loc, "sound/items/Ratchet.ogg", 50, 1)
		if(do_after(user,50))
			var/atom/A = new /obj/item/table_parts( src.loc )
			if(src.material) A.setMaterial(src.material)
			playsound(src.loc, "sound/items/Deconstruct.ogg", 50, 1)
			//SN src = null
			qdel(src)
		return

	else if (istype(W, /obj/item/reagent_containers/food/drinks/bottle) && user.a_intent == "harm")
		smash_bottle(user, W)
		return

	if (!isrobot(user))
		user.drop_item()
		if (W && W.loc && !(W.cant_drop || W.cant_self_remove))
			W.set_loc(src.loc)
			if (islist(params) && params["icon-y"] && params["icon-x"])
				W.pixel_x = text2num(params["icon-x"]) - 16
				W.pixel_y = text2num(params["icon-y"]) - 16
	return

/obj/table/reinforced/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weldingtool) && W:welding)
		var/turf/T = user.loc
		if(src.status == 2)
			boutput(user, "<span style=\"color:blue\">Now weakening the reinforced table</span>")
			playsound(src.loc, "sound/items/Welder.ogg", 50, 1)
			sleep(50)
			if ((user.loc == T && user.equipped() == W))
				boutput(user, "<span style=\"color:blue\">Table weakened</span>")
				src.status = 1
			else if((istype(user, /mob/living/silicon/robot) && (user.loc == T)))
				boutput(user, "<span style=\"color:blue\">Table weakened</span>")
				src.status = 1
		else
			boutput(user, "<span style=\"color:blue\">Now strengthening the reinforced table</span>")
			playsound(src.loc, "sound/items/Welder.ogg", 50, 1)
			sleep(50)
			if ((user.loc == T && user.equipped() == W))
				boutput(user, "<span style=\"color:blue\">Table strengthened</span>")
				src.status = 2
			else if((istype(user, /mob/living/silicon/robot) && (user.loc == T)))
				boutput(user, "<span style=\"color:blue\">Table strengthened</span>")
				src.status = 2
		return

	else if (istype(W, /obj/item/wrench))
		var/turf/T = user.loc
		if(src.status == 1)
			boutput(user, "<span style=\"color:blue\">Now disassembling the reinforced table</span>")
			playsound(src.loc, "sound/items/Ratchet.ogg", 50, 1)
			sleep(50)
			if (user.loc == T)
				var/atom/A = new /obj/item/table_parts/reinforced( src.loc )
				if(src.material) A.setMaterial(src.material)
				playsound(src.loc, "sound/items/Deconstruct.ogg", 50, 1)
				qdel(src)
				return

	else
		return ..()

// -------------------- VR --------------------
/obj/table/virtual
	desc = "A simulated table. Fortunately the kind that's less of a pain in the ass to deal with."
	icon = 'icons/effects/VR.dmi'
	icon_state = "table"
// --------------------------------------------
