
/* ================================================ */
/* -------------------- Stools -------------------- */
/* ================================================ */

/obj/stool
	name = "stool"
	icon = 'icons/obj/chairs.dmi'
	icon_state = "stool"
	flags = FPRINT
	throwforce = 10
	pressure_resistance = 3*ONE_ATMOSPHERE
	desc = "A four-legged padded stool for crewmembers to relax on."
	var/allow_unbuckle = 1
	var/mob/living/buckled_guy = null
	var/deconstructable = 1

	ex_act(severity)
		switch(severity)
			if(1)
				qdel(src)
				return
			if(2)
				if (prob(50))
					qdel(src)
					return
			if(3)
				if (prob(5))
					qdel(src)
					return
			else
		return

	blob_act(var/power)
		if(prob(power * 2.5))
			var/obj/item/I = new /obj/item/raw_material/scrap_metal(get_turf(src))
			if (src.material)
				I.setMaterial(src.material)
			else
				var/datum/material/M = getCachedMaterial("steel")
				I.setMaterial(M)
			qdel(src)

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/wrench) && src.deconstructable)
			playsound(src.loc, "sound/items/Ratchet.ogg", 50, 1)
			var/atom/C = new /obj/item/sheet(src.loc)
			if (src.material)
				C.setMaterial(src.material)
			else
				var/datum/material/M = getCachedMaterial("steel")
				C.setMaterial(M)
			//SN src = null
			qdel(src)
	//grabsmash
		else if (istype(W, /obj/item/grab/))
			var/obj/item/grab/G = W
			if  (!grab_smash(G, user))
				return ..(W, user)
			else return
		return

	proc/buckle_in(mob/living/to_buckle, var/stand = 0) //Handles the actual buckling in
		return

	proc/unbuckle() //Ditto but for unbuckling
		return

/obj/stool/bar
	name = "bar stool"
	icon_state = "bar-stool"
	desc = "Like a stool, but in a bar."

/* ================================================= */
/* -------------------- Benches -------------------- */
/* ================================================= */

/obj/stool/bench
	name = "bench"
	desc = "It's a bench! You can sit on it!"
	icon = 'icons/obj/bench.dmi'
	icon_state = "0"
	anchored = 1
	var/auto = 0
	var/auto_path = null

	New()
		if (src.auto)
			spawn(1)
				src.set_up(1)
		..()

	proc/set_up(var/setup_others = 0)
		if (!src.auto || !ispath(src.auto_path))
			return
		var/dirs = 0
		for (var/dir in cardinal)
			var/turf/T = get_step(src, dir)
			if (locate(src.auto_path) in T)
				dirs |= dir
		icon_state = num2text(dirs)
		if (setup_others)
			for (var/obj/stool/bench/B in orange(1))
				if (istype(B, src.auto_path))
					B.set_up()

/obj/stool/bench/auto
	auto = 1
	auto_path = /obj/stool/bench/auto

/* ---------- Red ---------- */

/obj/stool/bench/red
	icon = 'icons/obj/bench_red.dmi'

/obj/stool/bench/red/auto
	auto = 1
	auto_path = /obj/stool/bench/red/auto

/* ---------- Blue ---------- */

/obj/stool/bench/blue
	icon = 'icons/obj/bench_blue.dmi'

/obj/stool/bench/blue/auto
	auto = 1
	auto_path = /obj/stool/bench/blue/auto

/* ---------- Green ---------- */

/obj/stool/bench/green
	icon = 'icons/obj/bench_green.dmi'

/obj/stool/bench/green/auto
	auto = 1
	auto_path = /obj/stool/bench/green/auto

/* ---------- Yellow ---------- */

/obj/stool/bench/yellow
	icon = 'icons/obj/bench_yellow.dmi'

/obj/stool/bench/yellow/auto
	auto = 1
	auto_path = /obj/stool/bench/yellow/auto

/* ============================================== */
/* -------------------- Beds -------------------- */
/* ============================================== */

/obj/stool/bed
	name = "bed"
	desc = "A solid metal frame with some padding on it, useful for sleeping on."
	icon_state = "bed"
	anchored = 1
	var/security = 0
	var/obj/item/clothing/suit/bedsheet/Sheet = null

	brig
		name = "brig cell bed"
		desc = "It doesn't look very comfortable. Fortunately there's no way to be buckled to it."
		security = 1

	moveable
		name = "roller bed"
		desc = "A solid metal frame with some padding on it, useful for sleeping on. This one has little wheels on it, neat!"
		anchored = 0
		icon_state = "rollerbed"

		attackby(obj/item/W as obj, mob/user as mob)
			..()
			if (istype(W, /obj/item/screwdriver))
				if (src.anchored)
					playsound(src.loc, "sound/items/Screwdriver.ogg", 50, 1)
					if (do_after(user, 30))
						user.show_text("You unscrew [src] from the floor.", "blue")
						src.anchored = 0
						return
				else
					var/turf/T = get_turf(src)
					if (istype(T, /turf/space))
						user.show_text("What exactly are you gunna secure [src] to?", "red")
						return
					else
						playsound(src.loc, "sound/items/Screwdriver.ogg", 50, 1)
						if (do_after(user, 30))
							user.show_text("You secure [src] to [T].", "blue")
							src.anchored = 1
							return

	Move()
		..()
		if (src.buckled_guy)
			var/mob/living/carbon/C = src.buckled_guy
			C.buckled = null
			C.Move(src.loc)
			C.buckled = src

	attackby(obj/item/W as obj, mob/user as mob)
		..()
		if (istype(W, /obj/item/clothing/suit/bedsheet))
			src.tuck_sheet(W, user)
			return
		if (istype(W, /obj/item/wrench))
			if (src.security)
				boutput(user, "<span style=\"color:red\">You briefly ponder how to go about disassembling a featureless slab using a wrench. You quickly give up.</span>")
			else
				playsound(src.loc, "sound/items/Ratchet.ogg", 50, 1)
				var/obj/item/sheet/C = new /obj/item/sheet( src.loc )
				if (src.material)
					C.setMaterial(src.material)
				else
					var/datum/material/M = getCachedMaterial("steel")
					C.setMaterial(M)
				qdel(src)
		return

	attack_hand(mob/user as mob)
		..()
		if (src.Sheet)
			src.untuck_sheet(user)
		for (var/mob/M in src.loc)
			src.unbuckle_mob(M, user)
		return

	proc/buckle_mob(var/mob/living/carbon/C as mob, var/mob/user as mob)
		if (!C || (C.loc != src.loc))
			return // yeesh

		if (!ticker)
			user.show_text("You can't buckle anyone in before the game starts.", "red")
			return
		if (src.security)
			user.show_text("There's nothing you can buckle them to!", "red")
			return
		if (get_dist(src, user) > 1)
			user.show_text("[src] is too far away!", "red")
			return
		if ((!(iscarbon(C)) || C.loc != src.loc || user.restrained() || user.stat))
			return

		if (C == user)
			user.visible_message("<span style=\"color:blue\"><b>[C]</b> buckles in!</span>", "<span style=\"color:blue\">You buckle yourself in.</span>")
		else
			user.visible_message("<span style=\"color:blue\"><b>[C]</b> is buckled in by [user].</span>", "<span style=\"color:blue\">You buckle in [C].</span>")
		buckle_in(C)
		src.add_fingerprint(user)

	proc/unbuckle_mob(var/mob/M as mob, var/mob/user as mob)
		if (M.buckled && !user.restrained())
			if (allow_unbuckle)
				if (M != user)
					user.visible_message("<span style=\"color:blue\"><b>[M]</b> is unbuckled by [user].</span>", "<span style=\"color:blue\">You unbuckle [M].</span>")
				else
					user.visible_message("<span style=\"color:blue\"><b>[M]</b> unbuckles.</span>", "<span style=\"color:blue\">You unbuckle.</span>")
				unbuckle()
			else
				user.show_text("Seems like the buckle is firmly locked into place.", "red")

			src.add_fingerprint(user)

	buckle_in(mob/living/to_buckle)
		to_buckle.lying = 1
		if (src.anchored)
			to_buckle.anchored = 1
		to_buckle.buckled = src
		src.buckled_guy = to_buckle
		to_buckle.set_loc(src.loc)

		to_buckle.set_clothing_icon_dirty()

	unbuckle()
		if(src.buckled_guy)
			buckled_guy.anchored = 0
			buckled_guy.buckled = null
			src.buckled_guy = null

	proc/tuck_sheet(var/obj/item/clothing/suit/bedsheet/newSheet as obj, var/mob/user as mob)
		if (!newSheet || newSheet.cape || (src.Sheet == newSheet && newSheet.loc == src.loc)) // if we weren't provided a new bedsheet, the new bedsheet we got is tied into a cape, or the new bedsheet is actually the one we already have and is still in the same place as us...
			return // nevermind

		if (src.Sheet && src.Sheet.loc != src.loc) // a safety check: do we have a sheet and is it not where we are?
			if (src.Sheet.Bed && src.Sheet.Bed == src) // does our sheet have us listed as its bed?
				src.Sheet.Bed = null // set its bed to null
			src.Sheet = null // then set our sheet to null: it's not where we are!

		if (src.Sheet && src.Sheet != newSheet) // do we have a sheet, and is the new sheet we've been given not our sheet?
			user.show_text("You try to kinda cram [newSheet] into the edges of [src], but there's not enough room with [src.Sheet] tucked in already!", "red")
			return // they're crappy beds, okay?  there's not enough space!

		if (!src.Sheet && (newSheet.loc == src.loc || user.find_in_hand(newSheet))) // finally, do we have room for the new sheet, and is the sheet where we are or in the hand of the user?
			src.Sheet = newSheet // let's get this shit DONE!
			newSheet.Bed = src
			user.u_equip(newSheet)
			newSheet.set_loc(src.loc)
			mutual_attach(src, newSheet)

			var/mob/somebody
			if (src.buckled_guy)
				somebody = src.buckled_guy
			else
				somebody = locate(/mob/living/carbon) in get_turf(src)
			if (somebody && somebody.lying)
				user.tri_message("<span style=\"color:blue\"><b>[user]</b> tucks [somebody == user ? "[him_or_her(user)]self" : "[somebody]"] into bed.</span>",\
				user, "<span style=\"color:blue\">You tuck [somebody == user ? "yourself" : "[somebody]"] into bed.</span>",\
				somebody, "<span style=\"color:blue\">[somebody == user ? "You tuck yourself" : "<b>[user]</b> tucks you"] into bed.</span>")
				newSheet.layer = EFFECTS_LAYER_BASE-1
				return
			else
				user.visible_message("<span style=\"color:blue\"><b>[user]</b> tucks [newSheet] into [src].</span>",\
				"<span style=\"color:blue\">You tuck [newSheet] into [src].</span>")
				return

	proc/untuck_sheet(var/mob/user as mob)
		if (!src.Sheet) // vOv
			return // there's nothing to do here, everyone go home

		var/obj/item/clothing/suit/bedsheet/oldSheet = src.Sheet

		if (user)
			var/mob/somebody
			if (src.buckled_guy)
				somebody = src.buckled_guy
			else
				somebody = locate(/mob/living/carbon) in get_turf(src)
			if (somebody && somebody.lying)
				user.tri_message("<span style=\"color:blue\"><b>[user]</b> untucks [somebody == user ? "[him_or_her(user)]self" : "[somebody]"] from bed.</span>",\
				user, "<span style=\"color:blue\">You untuck [somebody == user ? "yourself" : "[somebody]"] from bed.</span>",\
				somebody, "<span style=\"color:blue\">[somebody == user ? "You untuck yourself" : "<b>[user]</b> untucks you"] from bed.</span>")
				oldSheet.layer = initial(oldSheet.layer)
			else
				user.visible_message("<span style=\"color:blue\"><b>[user]</b> untucks [oldSheet] from [src].</span>",\
				"<span style=\"color:blue\">You untuck [oldSheet] from [src].</span>")

		if (oldSheet.Bed == src) // just in case it's somehow not us
			oldSheet.Bed = null
		mutual_detach(src, oldSheet)
		src.Sheet = null
		return

	MouseDrop_T(atom/A as mob|obj, mob/user as mob)
		..()
		if (get_dist(src, user) > 1)
			user.show_text("[src] is too far away!", "red")
			return

		if (istype(A, /obj/item/clothing/suit/bedsheet))
			if ((!src.Sheet || (src.Sheet && src.Sheet.loc != src.loc)) && A.loc == src.loc)
				src.tuck_sheet(A, user)
				return
			if (src.Sheet && A == src.Sheet)
				src.untuck_sheet(user)
				return

		else if (ismob(A))
			src.buckle_mob(A, user)
		else
			return ..()

	disposing()
		for (var/mob/M in src.loc)
			if (M.buckled == src)
				M.buckled = null
				src.buckled_guy = null
				M.lying = 0
				M.anchored = 0
		if (src.Sheet && src.Sheet.Bed == src)
			src.Sheet.Bed = null
			src.Sheet = null
		..()
		return

	verb/rest_in()
		set src in oview(1)
		set name = "sleep in"
		set category = "Local"

		var/mob/living/carbon/user = usr
		if (!istype(user))
			return

		if (user.stat == 2)
			boutput(user, "<span style=\"color:red\">Some would say that death is already the big sleep.</span>")
			return

		if ((get_turf(user) != src.loc) || (!user.lying))
			boutput(user, "<span style=\"color:red\">You must be lying down on [src] to sleep on it.</span>")
			return

		user.asleep = 1
		user.resting = 1
		return

/* ================================================ */
/* -------------------- Chairs -------------------- */
/* ================================================ */

/obj/stool/chair
	name = "chair"
	icon_state = "chair"
	var/comfort_value = 3
	var/buckledIn = 0
	var/status = 0
	var/rotatable = 1
	var/foldable = 1
	anchored = 1
	desc = "A four-legged metal chair, rigid and slightly uncomfortable. Helpful when you don't want to use your legs at the moment."

	moveable
		anchored = 0

	New()
		//if (src.anchored)
			//src.verbs -= /atom/movable/verb/pull
		if (src.dir == NORTH)
			src.layer = FLY_LAYER+1
		..()
		return

	Move()
		..()
		if (src.dir == NORTH)
			src.layer = FLY_LAYER+1
		else
			src.layer = OBJ_LAYER
		if (src.buckled_guy)
			var/mob/living/carbon/C = src.buckled_guy
			C.buckled = null
			C.Move(src.loc)
			C.buckled = src

	attackby(obj/item/W as obj, mob/user as mob)
		..()
		if (istype(W, /obj/item/assembly/shock_kit))
			var/obj/stool/chair/e_chair/E = new /obj/stool/chair/e_chair(src.loc)
			if (src.material)
				E.setMaterial(src.material)
			playsound(src.loc, "sound/items/Deconstruct.ogg", 50, 1)
			E.dir = src.dir
			E.part1 = W
			W.set_loc(E)
			W.master = E
			user.u_equip(W)
			W.layer = initial(W.layer)
			//SN src = null
			qdel(src)
			return
		return

	attack_hand(mob/user as mob)
		if (!ishuman(user)) return
		var/mob/living/carbon/human/H = user
		var/mob/living/carbon/human/chump = null
		for (var/mob/M in src.loc)

			if (ishuman(M))
				chump = M
			if (!chump || !chump.on_chair == 1)
				chump = null
			if (H.on_chair == 1)
				if (M == user)
					user.visible_message("<span style=\"color:blue\"><b>[M]</b> steps off [src].</span>", "<span style=\"color:blue\">You step off [src].</span>")
					src.add_fingerprint(user)
					unbuckle()
					return

			if ((M.buckled) && (!H.on_chair))
				if (allow_unbuckle)
					if(user.restrained())
						return
					if (M != user)
						user.visible_message("<span style=\"color:blue\"><b>[M]</b> is unbuckled by [user].</span>", "<span style=\"color:blue\">You unbuckle [M].</span>")
					else
						user.visible_message("<span style=\"color:blue\"><b>[M]</b> unbuckles.</span>", "<span style=\"color:blue\">You unbuckle.</span>")
					src.add_fingerprint(user)
					unbuckle()
					return
				else
					user.show_text("Seems like the buckle is firmly locked into place.", "red")

		if (!src.buckledIn && src.foldable)
			user.visible_message("<b>[user.name] folds [src].</b>")
			if ((chump) && (chump != user))
				chump.visible_message("<span style=\"color:red\"><b>[chump.name] falls off of [src]!</b></span>")
				chump.on_chair = 0
				chump.pixel_y = 0
				chump.weakened++
				chump.stunned+=2
				random_brute_damage(chump, 15)
				playsound(chump.loc, "swing_hit", 50, 1)

			var/obj/item/chair/folded/C = new/obj/item/chair/folded(src.loc)
			if (src.material)
				C.setMaterial(src.material)
			if (src.icon_state)
				C.c_color = src.icon_state

			qdel(src)
		return

	MouseDrop_T(mob/M as mob, mob/user as mob)
		..()
		if (!ticker)
			boutput(user, "You can't buckle anyone in before the game starts.")
			return
		if ((!( iscarbon(M) ) || get_dist(src, user) > 1 || M.loc != src.loc || user.restrained() || usr.stat))
			return
		if (M == usr)
			if (usr.a_intent == INTENT_GRAB)
				user.visible_message("<span style=\"color:blue\"><b>[M]</b> climbs up on [src]!</span>", "<span style=\"color:blue\">You climb up on [src].</span>")
				buckle_in(M, 1)
			else
				user.visible_message("<span style=\"color:blue\"><b>[M]</b> buckles in!</span>", "<span style=\"color:blue\">You buckle yourself in.</span>")
				buckle_in(M)
		else
			user.visible_message("<span style=\"color:blue\"><b>[M]</b> is buckled in by [user].</span>", "<span style=\"color:blue\">You buckle in [M].</span>")
			buckle_in(M)
		return

	buckle_in(mob/living/to_buckle, var/stand = 0)
		if(!istype(to_buckle)) return

		if(stand)
			if(ishuman(to_buckle))
				var/mob/living/carbon/human/H = to_buckle
				to_buckle.set_loc(src.loc)
				to_buckle.pixel_y = 10
				if (src.anchored)
					to_buckle.anchored = 1
				H.on_chair = 1
				to_buckle.buckled = src
				src.buckled_guy = to_buckle
		else
			if (src.anchored)
				to_buckle.anchored = 1
			to_buckle.buckled = src
			src.buckled_guy = to_buckle
			to_buckle.set_loc(src.loc)
			src.buckledIn = 1

	unbuckle()
		if(!src.buckled_guy) return

		var/mob/living/M = src.buckled_guy
		var/mob/living/carbon/human/H = src.buckled_guy

		if (istype(H) && H.on_chair == 1)
			M.pixel_y = 0
			M.anchored = 0
			M.buckled = null
			src.buckled_guy = null
			spawn (5)
				H.on_chair = 0
				src.buckledIn = 0
		else if ((M.buckled))
			M.anchored = 0
			M.buckled = null
			src.buckled_guy = null
			spawn (5)
				src.buckledIn = 0


	ex_act(severity)
		for (var/mob/M in src.loc)
			if (M.buckled == src)
				M.buckled = null
				src.buckled_guy = null
		switch (severity)
			if (1.0)
				qdel(src)
				return
			if (2.0)
				if (prob(50))
					qdel(src)
					return
			if (3.0)
				if (prob(5))
					qdel(src)
					return
		return

	blob_act(var/power)
		if (prob(power * 2.5))
			for (var/mob/M in src.loc)
				if (M.buckled == src)
					M.buckled = null
					src.buckled_guy = null
			qdel(src)

	disposing()
		for (var/mob/M in src.loc)
			if (M.buckled == src)
				M.buckled = null
				src.buckled_guy = null
		..()
		return

	verb/rotate()
		set name = "Rotate"
		set category = "Local"
		if (rotatable)
			set src in oview(1)

			src.dir = turn(src.dir, 90)
			if (src.dir == NORTH)
				src.layer = FLY_LAYER+1
			else
				src.layer = OBJ_LAYER
			if (buckled_guy)
				var/mob/living/carbon/C = src.buckled_guy
				C.dir = dir
		return

	blue
		icon_state = "chair-b"

	yellow
		icon_state = "chair-y"

	red
		icon_state = "chair-r"

	green
		icon_state = "chair-g"

/* ========================================================== */
/* -------------------- Syndicate Chairs -------------------- */
/* ========================================================== */

/obj/stool/chair/syndicate
	desc = "That chair is giving off some bad vibes."
	comfort_value = -5

	HasProximity(atom/movable/AM as mob|obj)
		if (ishuman(AM) && prob(40))
			src.visible_message("<span style=\"color:red\">[src] trips [AM]!</span>", "<span style=\"color:red\">You hear someone fall</span>")
			AM:weakened += 2
		return

/* ======================================================= */
/* -------------------- Folded Chairs -------------------- */
/* ======================================================= */

/obj/item/chair/folded
	name = "chair"
	desc = "A folded chair. Good for smashing noggin-shaped things."
	icon = 'icons/obj/items.dmi'
	icon_state = "folded_chair"
	item_state = "folded_chair"
	w_class = 4.0
	throwforce = 10
	flags = FPRINT | TABLEPASS | CONDUCT
	stamina_damage = 45
	stamina_cost = 40
	stamina_crit_chance = 10
	var/c_color = null

/obj/item/chair/folded/attack_self(mob/user as mob)
	var/obj/stool/chair/C = new/obj/stool/chair(user.loc)
	if (src.material)
		C.setMaterial(src.material)
	if (src.c_color)
		C.icon_state = src.c_color
	C.dir = user.dir
	boutput(user, "You unfold [C].")
	user.drop_item()
	qdel(src)
	return

/obj/item/chair/folded/attack(atom/target, mob/user as mob)
	var/mob/living/carbon/human/H = user
	var/mob/living/M = target
	if (ishuman(target))
		if (iswrestler(H))
			M.stunned += 4
			H.emote("scream")
		M.TakeDamage("chest", 5, 0)
		M.updatehealth()
		playsound(src.loc, pick(sounds_punch), 100, 1)
	..()

/* ====================================================== */
/* -------------------- Comfy Chairs -------------------- */
/* ====================================================== */

/obj/stool/chair/comfy
	name = "comfy brown chair"
	desc = "This advanced seat commands authority and respect. Everyone is super jealous of whoever sits in this chair."
	icon_state = "chair_comfy"
	comfort_value = 7
	foldable = 0
	deconstructable = 0
//	var/atom/movable/overlay/overl = null
	var/image/arm_image = null
	var/arm_icon_state = "arm"

	New()
		..()
		update_icon()
/* what in the unholy mother of god was this about
		src.overl = new /atom/movable/overlay( src.loc )
		src.overl.icon = 'icons/obj/objects.dmi'
		src.overl.icon_state = "arm"
		src.overl.layer = 6// TODO Layer wtf
		src.overl.name = "chair arm"
		src.overl.master = src
		src.overl.dir = src.dir
*/
	rotate()
		set src in oview(1)
		set category = "Local"

		src.dir = turn(src.dir, 90)
//		src.overl.dir = src.dir
		src.update_icon()
		if (buckled_guy)
			var/mob/living/carbon/C = src.buckled_guy
			C.dir = dir
		return

	proc/update_icon()
		if (src.dir == NORTH)
			src.layer = FLY_LAYER+1
		else
			src.layer = OBJ_LAYER
			if ((src.dir == WEST || src.dir == EAST) && !src.arm_image)
				src.arm_image = image(src.icon, src.arm_icon_state)
				src.arm_image.layer = FLY_LAYER+1
				src.UpdateOverlays(src.arm_image, "arm")

	blue
		name = "comfy blue chair"
		icon_state = "chair_comfy-blue"
		arm_icon_state = "arm-blue"

	red
		name = "comfy red chair"
		icon_state = "chair_comfy-red"
		arm_icon_state = "arm-red"

	green
		name = "comfy green chair"
		icon_state = "chair_comfy-green"
		arm_icon_state = "arm-green"

	purple
		name = "comfy purple chair"
		icon_state = "chair_comfy-purple"
		arm_icon_state = "arm-purple"

/* ======================================================== */
/* -------------------- Shuttle Chairs -------------------- */
/* ======================================================== */

/obj/stool/chair/comfy/shuttle
	name = "shuttle seat"
	desc = "Equipped with a safety buckle and a tray on the back for the person behind you to use!"
	icon_state = "shuttle_chair"
	arm_icon_state = "shuttle_chair-arm"
	comfort_value = 5

	red
		icon_state = "shuttle_chair-red"
	brown
		icon_state = "shuttle_chair-brown"
	green
		icon_state = "shuttle_chair-green"

/* ======================================================= */
/* -------------------- Wooden Chairs -------------------- */
/* ======================================================= */

/obj/stool/chair/wooden
	name = "wooden chair"
	icon_state = "chair_wooden" // this sprite is bad I will fix it at some point
	comfort_value = 3
	foldable = 0
	anchored = 0
	deconstructable = 0

/* ================================================= */
/* -------------------- Couches -------------------- */
/* ================================================= */

/obj/stool/chair/couch
	name = "comfy brown couch"
	desc = "You've probably lost some space credits in these things before."
	icon_state = "chair_couch-brown"
	rotatable = 0
	foldable = 0
	var/damaged = 0
	comfort_value = 5
	deconstructable = 0

	New()
		..()
		couches.Add(src)

	Del()
		couches.Remove(src)
		..()

	proc/damage(severity)
		if(severity > 1 && damaged < 2)
			damaged += 2
			overlays += icon('icons/obj/objects.dmi', "couch-tear")
		else if(damaged < 1)
			damaged += 1
			overlays += icon('icons/obj/objects.dmi', "couch-rip")

	blue
		name = "comfy blue couch"
		icon_state = "chair_couch-blue"

	red
		name = "comfy red couch"
		icon_state = "chair_couch-red"

	green
		name = "comfy green couch"
		icon_state = "chair_couch-green"

	purple
		name = "comfy purple couch"
		icon_state = "chair_couch-purple"

/* ======================================================= */
/* -------------------- Office Chairs -------------------- */
/* ======================================================= */

/obj/stool/chair/office
	name = "office chair"
	desc = "Hey, you remember spinning around on one of these things as a kid!"
	icon_state = "office_chair"
	comfort_value = 4
	foldable = 0
	deconstructable = 0

	red
		icon_state = "office_chair_red"

	green
		icon_state = "office_chair_green"

	blue
		icon_state = "office_chair_blue"

	yellow
		icon_state = "office_chair_yellow"

	purple
		icon_state = "office_chair_purple"

	moveable
		anchored = 0

	attackby(obj/item/W as obj, mob/user as mob)
		..()
		if (istype(W, /obj/item/screwdriver))
			if (src.anchored)
				playsound(src.loc, "sound/items/Screwdriver.ogg", 50, 1)
				if (do_after(user, 30))
					user.show_text("You unscrew [src] from the floor.", "blue")
					src.anchored = 0
					return
			else
				var/turf/T = get_turf(src)
				if (istype(T, /turf/space))
					user.show_text("What exactly are you gunna secure [src] to?", "red")
					return
				else
					playsound(src.loc, "sound/items/Screwdriver.ogg", 50, 1)
					if (do_after(user, 30))
						user.show_text("You secure [src] to [T].", "blue")
						src.anchored = 1
						return

/* ========================================================= */
/* -------------------- Electric Chairs -------------------- */
/* ========================================================= */

/obj/stool/chair/e_chair
	name = "electrified chair"
	desc = "A chair that has been modified to conduct current with over 2000 volts, enough to kill a human nearly instantly."
	icon_state = "e_chair0"
	foldable = 0
	var/on = 0
	var/obj/item/assembly/shock_kit/part1 = null
	var/last_time = 1
	var/lethal = 0
	var/image/image_belt = null
	comfort_value = -3

	New()
		..()
		spawn (20)
			if (src)
				if (!(src.part1 && istype(src.part1)))
					src.part1 = new /obj/item/assembly/shock_kit(src)
					src.part1.master = src
				src.update_icon()
		return

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/wrench))
			var/obj/stool/chair/C = new /obj/stool/chair(get_turf(src))
			if (src.material)
				C.setMaterial(src.material)
			playsound(src.loc, "sound/items/Ratchet.ogg", 50, 1)
			C.dir = src.dir
			if (src.part1)
				src.part1.set_loc(get_turf(src))
				src.part1.master = null
				src.part1 = null
			qdel(src)
			return

	verb/controls()
		set src in oview(1)
		set category = "Local"

		src.control_interface(usr)

	// Seems to be the only way to get this stuff to auto-refresh properly, sigh (Convair880).
	proc/control_interface(mob/user as mob)
		if (!user.handcuffed && user.stat == 0)
			user.machine = src

			var/dat = ""

			var/area/A = get_area(src)
			if (!isarea(A) || !A.powered(EQUIP))
				dat += "\n<font color='red'>ERROR:</font> No power source detected!</b>"
			else
				dat += {"<A href='?src=\ref[src];on=1'>[on ? "Switch Off" : "Switch On"]</A><BR>
				<A href='?src=\ref[src];lethal=1'>[lethal ? "<font color='red'>Lethal</font>" : "Nonlethal"]</A><BR><BR>
				<A href='?src=\ref[src];shock=1'>Shock</A><BR>"}

			user << browse("<TITLE>Electric Chair</TITLE><b>Electric Chair</b><BR>[dat]", "window=e_chair;size=180x180")

			onclose(usr, "e_chair")
		return

	Topic(href, href_list)
		if (usr.stunned || usr.weakened || usr.stat || usr.restrained()) return
		if (!in_range(src, usr)) return

		if (href_list["on"])
			toggle_active()
		else if (href_list["lethal"])
			toggle_lethal()
		else if (href_list["shock"])
			if (src.buckled_guy)
				// The log entry for remote signallers can be found in item/assembly/shock_kit.dm (Convair880).
				logTheThing("combat", usr, src.buckled_guy, "activated an electric chair (setting: [src.lethal ? "lethal" : "non-lethal"]), shocking %target% at [log_loc(src)].")
			shock(lethal)

		src.control_interface(usr)
		src.add_fingerprint(usr)
		return

	proc/toggle_active()
		src.on = !(src.on)
		src.update_icon()
		return src.on

	proc/toggle_lethal()
		src.lethal = !(src.lethal)
		src.update_icon()
		return

	proc/update_icon()
		src.icon_state = "e_chair[src.on]"
		if (!src.image_belt)
			src.image_belt = image(src.icon, "e_chairo[src.on][src.lethal]", layer = FLY_LAYER + 1)
			src.UpdateOverlays(src.image_belt, "belts")
			return
		src.image_belt.icon_state = "e_chairo[src.on][src.lethal]"
		src.UpdateOverlays(src.image_belt, "belts")

	// Options:      1) place the chair anywhere in a powered area (fixed shock values),
	// (Convair880)  2) on top of a powered wire (scales with engine output).
	proc/get_connection()
		var/turf/T = get_turf(src)
		if (!istype(T, /turf/simulated/floor))
			return 0

		for (var/obj/cable/C in T)
			return C.netnum

		return 0

	proc/get_gridpower()
		var/netnum = src.get_connection()

		if (netnum)
			var/datum/powernet/PN
			if (powernets && powernets.len >= netnum)
				PN = powernets[netnum]
				return PN.avail

		return 0

	proc/shock(lethal)
		if (!src.on)
			return
		if ((src.last_time + 50) > world.time)
			return
		src.last_time = world.time

		// special power handling
		var/area/A = get_area(src)
		if (!isarea(A))
			return
		if (!A.powered(EQUIP))
			return
		A.use_power(EQUIP, 5000)
		A.updateicon()

		for (var/mob/M in AIviewers(src, null))
			M.show_message("<span style=\"color:red\">The electric chair went off!</span>", 3)
			if (lethal)
				playsound(src.loc, "sound/effects/electric_shock.ogg", 100, 0)
			else
				playsound(src.loc, "sound/effects/sparks4.ogg", 100, 0)

		if (src.buckled_guy && ishuman(src.buckled_guy))
			var/mob/living/carbon/human/H = src.buckled_guy

			if (src.lethal)
				var/net = src.get_connection() // Are we wired-powered (Convair880)?
				var/power = src.get_gridpower()
				if (!net || (net && (power < 2000000)))
					H.shock(src, 2000000, "chest", 0.3, 1) // Nope or not enough juice, use fixed values instead (around 80 BURN per shock).
				else
					//DEBUG("Shocked [H] with [power]")
					src.electrocute(H, 100, net, 1) // We are, great. Let that global proc calculate the damage.
			else
				H.shock(src, 2500, "chest", 1, 1)
				if (H.stunned < 10)
					H.stunned = 10

			if (ticker && ticker.mode && istype(ticker.mode, /datum/game_mode/revolution))
				if (H.mind in ticker.mode:revolutionaries && !H.mind in ticker.mode:head_revolutionaries && prob(66))
					ticker.mode:remove_revolutionary(H.mind)

		A.updateicon()
		return
