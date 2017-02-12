// The day has come when this warps into existence.
// Dear god, imagine the horrors that will soon lurk in here.

/proc/chs(var/str, var/i)
	return ascii2text(text2ascii(str,i))

/**
 * BASH explode:
 * Splits a string into string pieces the same way BASH handles this.
 * - Process quoted strings LTR: Apostrophized strings are unparsed. Quoted strings are parsed.
 * - Insert parsed strings back into the string by using a placeholder for spaces.
 * - Split the string with the usual space separation method.
 * - Return list.
 */

// TODO: Variable processing.

#define NONE 0
#define APOS 1
#define QUOT 2

#define ESCAPE "\\"

/proc/bash_explode(var/str)
	var/fin = 0
	var/state = NONE
	var/pos = 1
	var/qpos = 1
	var/buf = ""
	while (!fin)
		switch(state)
			if (NONE)
				var/NA = findtext(str, "'", pos)
				var/NQ = findtext(str, "\"", pos)
				if (!NA && !NQ)
					buf += copytext(str, pos)
					fin = 1
				else if (NA && !NQ || (NA && NQ && NA < NQ))
					if (chs(str, NA - 1) == ESCAPE)
						buf += copytext(str, pos, NA - 1) + "'"
						pos = NA + 1
						continue
					else
						buf += copytext(str, pos, NA)
						pos = NA + 1
						state = APOS
				else if (NQ && !NA || (NA && NQ && NQ < NA))
					if (chs(str, NQ - 1) == ESCAPE)
						buf += copytext(str, pos, NQ - 1) + "\""
						pos = NQ + 1
						continue
					else
						buf += copytext(str, pos, NQ)
						pos = NQ + 1
						qpos = NQ + 1
						state = QUOT
				else if (NA == NQ)
					//??????
					return null

			if (APOS)
				var/NA = findtext(str, "'", pos)
				if (!NA)
					return null
				var/temp = copytext(str, pos, NA)
				buf += dd_replacetext(temp, " ", "&nbsp;")
				pos = NA + 1
				state = NONE

			if (QUOT)
				var/NQ = findtext(str, "\"", pos)
				if (!NQ)
					return null
				if (copytext(str, NQ - 1, NQ) == ESCAPE)
					pos = NQ + 1
					continue
				var/temp = copytext(str, qpos, NQ)
				buf += dd_replacetext(dd_replacetext(temp, " ", "&nbsp;"), "\\\"", "\"")
				pos = NQ + 1
				state = NONE

	var/list/el = dd_text2list(buf, " ")
	var/list/ret = list()
	for (var/s in el)
		ret += dd_replacetext(s, "&nbsp;", " ")
	return ret

#undef ESCAPE
#undef QUOT
#undef APOS
#undef NONE

/proc/bash_sanitize(var/data)
	var/list/allowed_chars = list(" ")
	var/ret = ""
	var/lgp = 0
	for (var/i = 1, i <= length(data), i++)
		var/char = text2ascii(data, i)
		var/ord = ascii2text(char)
		if ((65 <= char && char <= 90) || (97 <= char && char <= 122) || (ord in allowed_chars))
			if (lgp == 0)
				lgp = i
			continue
		if (lgp == 0)
			continue
		ret += copytext(data, lgp, i)
		lgp = 0
	if (lgp)
		ret += copytext(data, lgp)
	return ret


/obj/nerd_trap_door
	name = "Heavily locked door"
	desc = "Man, whatever is in here must be pretty valuable. This door seems to be indestructible and features an unrealistic amount of keyholes."
	var/list/expected = list("silver key", "skeleton key", "literal skeleton key", "hot iron key", "cold steel key", "onyx key", "key lime pie", "futuristic key", "virtual key", "golden key", "bee key", "iron key", "iridium key", "lunar key")
	var/list/unlocked = list()
	var/list/ol = list()
	icon = 'icons/misc/aprilfools.dmi'
	icon_state = "hld0"
	opacity = 1
	density = 1
	anchored = 1

	examine()
		..()
		boutput(usr, "Your keen skills of observation tell you that [expected.len - unlocked.len] out of the [expected.len] locks are locked.")

	attackby(var/obj/item/I, var/mob/user)
		if (istype(I, /obj/item/device/key))
			var/kname = null
			if (I.name in expected)
				kname = I.name
			//for (var/N in expected)
			//	if (dd_hasprefix(I.name, N))
			//		break
			if (kname)
				boutput(user, "<span style='color:blue'>You insert the [I.name] into the [kname]hole and turn it. The door emits a loud click.</span>")
				playsound(src.loc, "sound/effects/thunk.ogg", 60, 1)
				if (kname in unlocked)
					unlocked -= kname
					overlays -= ol[kname]
					ol -= kname
				else
					unlocked += kname
					var/image/IM = image('icons/misc/aprilfools.dmi', "[kname]hole")
					ol[kname] = IM
					overlays += IM
			else
				boutput(user, "<span style='color:red'>You cannot find a matching keyhole for that key!</span>")
		else if (istype(I, /obj/item/reagent_containers/food/snacks/pie/lime))
			if ("key lime pie" in expected)
				boutput(user, "<span style='color:blue'>You insert the [I.name] into the key lime piehole and turn it. The door emits a loud click.</span>")
				playsound(src.loc, "sound/effects/thunk.ogg", 60, 1)
				if ("key lime pie" in unlocked)
					unlocked -= "key lime pie"
					overlays -= ol["key lime pie"]
					ol -= "key lime pie"
				else
					unlocked += "key lime pie"
					var/image/IM = image('icons/misc/aprilfools.dmi', "key lime piehole")
					ol["key lime pie"] = IM
					overlays += IM
			else
				boutput(user, "<span style='color:red'>You cannot find a matching keyhole for that key!</span>")

	Bumped(var/mob/M)
		if (!istype(M))
			return
		attack_hand(M)

	attack_hand(var/mob/user)
		if (!density)
			return
		if (unlocked.len == expected.len)
			open()
		else
			boutput(user, "<span style='color:red'>The door won't budge!</span>")

	proc/open()
		if (unlocked.len != expected.len)
			return
		playsound(src.loc, "sound/machines/door_open.ogg", 50, 1)
		icon_state = "hld1"
		density = 0
		opacity = 0
		overlays.len = 0

	meteorhit()
		return

	ex_act()
		return

	blob_act()
		return

	bullet_act()
		return

/obj/steel_beams
	name = "steel beams"
	desc = "A bunch of unfortunately placed, tightly packed steel beams. You cannot get a meaningful glimpse of what's on the other side."
	anchored = 1
	density = 1
	opacity = 1
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "beams"

	meteorhit()
		return

	ex_act()
		return

	blob_act()
		return

	bullet_act()
		return

/obj/faint_shimmer
	name = "faint shimmer"
	desc = "Huh."
	anchored = 1
	density = 0
	invisibility = 2
	blend_mode = 4
	icon = 'icons/misc/old_or_unused.dmi'
	icon_state = "noise5"
	var/decloaked_type = /obj/item/storage/toilet

	dense
		density = 1

// Aiming bow action.
/datum/action/bar/aim
	duration = -1
	var/obj/item/gun/bow/bow = null
	var/progress = 0
	var/direction = 1
	var/progression = 0.18
	var/linger = 15
	var/moved = 0

	New(var/mob/M, var/obj/item/gun/bow/B)
		owner = M
		bow = B
		..()

	onStart()
		..()
		playsound(get_turf(owner), 'sound/effects/bow_aim.ogg', 75, 1)
		owner.visible_message("<span style='color:red'>[owner] pulls the string on [bow]!</span>", "<span style='color:blue'>You pull the string on [bow]!</span>")

	onDelete()
		if (bow)
			bow.aim = null
		..()

	onEnd()
		boutput(owner, "<span style='color:red'>You couldn't hold the string any longer.</span>")
		if (bow)
			bow.aim = null
		..()

	interrupt(var/flag)
		var/mob/mowner = owner
		if(flag == INTERRUPT_MOVE && mowner.m_intent == "walk")
			bar.color = "#FF0000"
			switch (direction)
				if (-1)
					progress = max(0, progress - 4 * progression)
					progression += 0.035
					if (!progress)
						state = ACTIONSTATE_FINISH
				if (0)
					linger = max(linger - 4, 0)
					if (linger)
						direction = 1
						progress = max(0, progress - 4 * progression)
						moved = 1
					else
						direction = -1
						moved = 0
				if (1)
					moved = 2
					linger = max(0, linger - 2)
					progress = max(0, progress - 3 * progression)
					if (!linger)
						direction = -1
						moved = 0
			return
		..()

	onUpdate()
		if (!progress && direction == -1)
			state = ACTIONSTATE_FINISH
			return
		if (moved)
			moved--
			linger = max(0, linger - 1)
			if (linger <= 0)
				direction = -1
				moved = 0
			return
		switch (direction)
			if (-1)
				progress = max(0, progress - progression)
				if (!progress)
					state = ACTIONSTATE_FINISH
			if (0)
				linger--
				if (linger <= 0)
					direction = -1
			if (1)
				progress = min(1, progress + progression)
				if (progress == 1)
					direction = 0
		var/complete = progress
		bar.color = "#0000FF"
		bar.transform = matrix(complete, 1, MATRIX_SCALE)
		bar.pixel_x = -nround( ((30 - (30 * complete)) / 2) )

/obj/item/arrow
	name = "steel-headed arrow"
	icon = 'icons/obj/items.dmi'
	icon_state = null
	flags = FPRINT | TABLEPASS | SUPPRESSATTACK
	// placeholder
	var/datum/material/head_material
	var/datum/material/shaft_material
	var/image/shaft
	var/image/head
	amount = 1

	New()
		..()
		shaft = image(icon, "arrow_base")
		head = image(icon, "arrow_head")
		reagents = new /datum/reagents(3)
		reagents.my_atom = src
		overlays += shaft
		overlays += head

	examine()
		..()
		if (amount > 1)
			boutput(usr, "<span style='color:blue'>This is a stack of [amount] arrows. Picking it up will take a single arrow from the stack.")
		if (reagents.total_volume)
			boutput(usr, "<span style='color:blue'>The tip of the arrow is coated with reagents.</span>")

	clone(var/newloc = null)
		var/obj/item/arrow/O = new(loc)
		if (newloc)
			O.set_loc(newloc)
		O.setHeadMaterial(head_material)
		O.setShaftMaterial(shaft_material)

	attack_hand(var/mob/user)
		if (amount > 1)
			amount--
			var/obj/item/arrow/O = clone(loc)
			user.put_in_hand_or_drop(O, user.hand)
			boutput(usr, "<span style='color:blue'>You take \a [src] from the stack of [src]s. [amount] remaining on the stack.")
		else
			..()

	set_loc()
		..()
		if (isturf(loc))
			overlays.len = 0
			head.layer = initial(head.layer)
			shaft.layer = initial(shaft.layer)
			overlays += shaft
			overlays += head
		else
			overlays.len = 0
			head.layer = HUD_LAYER+3
			shaft.layer = HUD_LAYER+3
			overlays += shaft
			overlays += head

	proc/setName()
		if (head_material && shaft_material)
			name = "[head_material]-headed [shaft_material] arrow"
		else if (head_material)
			name = "[head_material]-headed arrow"
		else if (shaft_material)
			name = "steel-headed [shaft_material] arrow"
		else
			name = "steel-headed arrow"

	proc/setHeadMaterial(var/datum/material/M)
		head_material = copyMaterial(M)
		overlays -= head
		if (M)
			head.color = M.color
			head.alpha = M.alpha
		else
			head.color = null
			head.alpha = 255
		overlays += head
		setName()

	proc/setShaftMaterial(var/datum/material/M)
		shaft_material = copyMaterial(M)
		material = shaft_material
		overlays -= shaft
		if (M)
			shaft.color = M.color
			shaft.alpha = M.alpha
		else
			shaft.color = null
			shaft.alpha = 255
		overlays += head
		setName()

	afterattack(var/atom/target, var/mob/user, reach)
		if (!reach)
			return
		if (istype(target, /mob/living))
			if (prob(50))
				user.visible_message("<span style='color:red'><b>[user] tries to stab [target] with [src] but misses!</b></span>")
				playsound(get_turf(user), 'sound/weapons/punchmiss.ogg', 25, 1, 1)
				return
			user.visible_message("<span style='color:red'><b>[user] stabs [target] with [src]!</b></span>")
			user.u_equip(src)
			playsound(get_turf(user), 'sound/effects/bloody_stab.ogg', 75, 1)
			if (ishuman(target))
				var/mob/living/carbon/human/H = target
				var/obj/item/implant/projectile/arrow/A = new
				A.material = head_material
				A.arrow = src
				A.name = name
				set_loc(A)
				A.set_loc(target)
				A.owner = target
				H.implant += A
				A.implanted(H, null, 100)
			reagents.reaction(target, 2)
			reagents.trans_to(target, reagents.total_volume)
			take_bleeding_damage(target, null, 8, DAMAGE_STAB)
			if (head_material)
				head_material.triggerOnAttack(src, user, target)
		else
			var/obj/item/I = target
			if (istype(I) && I.is_open_container() == 1 && I.reagents)
				if (reagents.total_volume == reagents.maximum_volume)
					boutput(user, "<span style='color:red'>[src] is already coated in the maximum amount of reagents it can hold.</span>")
				else if (!I.reagents.total_volume)
					boutput(user, "<span style='color:red'>[I] is empty.</span>")
				else
					var/amt = min(reagents.maximum_volume - reagents.total_volume, I.reagents.total_volume)
					logTheThing("combat", user, null, "poisoned [src] [log_reagents(I)] at [log_loc(user)].") // Logs would be nice (Convair880).
					I.reagents.trans_to(src, amt)
					boutput(user, "<span style='color:blue'>You dip [src] into [I], coating it with [amt] units of reagents.</span>")

/obj/item/arrowhead
	name = "arrowhead"
	icon = 'icons/obj/items.dmi'
	icon_state = "arrowhead"

	examine()
		..()
		boutput(usr, "There [amount == 1 ? "is" : "are"] [amount] arrowhead[amount != 1 ? "s" : null] in the stack.")

/obj/item/implant/projectile/arrow
	name = "arrow"
	icon = null
	icon_state = null
	desc = "An arrow."
	var/obj/item/arrow/arrow = null

	New()
		..()
		implant_overlay = image(icon='icons/mob/human.dmi', icon_state="arrow_stick_[rand(0,4)]", layer=MOB_EFFECT_LAYER)

	// Hack.
	set_loc()
		..()
		if (isturf(loc))
			if (arrow)
				arrow.set_loc(loc)
			qdel(src)

/obj/item/quiver
	name = "quiver"
	icon = 'icons/obj/items.dmi'
	icon_state = "quiver-0"
	wear_image_icon = 'icons/mob/back.dmi'
	item_state = "quiver"
	flags = FPRINT | TABLEPASS | ONBACK

	attackby(var/obj/item/arrow/I, var/mob/user)
		if (!istype(I))
			boutput(user, "<span style='color:red'>That cannot be placed in [src]!</span>")
			return
		user.u_equip(I)
		I.loc = src
		maptext = "[contents.len]"
		icon_state = "quiver-[min(contents.len, 4)]"

	attack_hand(var/mob/user)
		if (src in user)
			if (contents.len)
				boutput(user, "<span style='color:blue'>You take [contents[1]] from [src].</span>")
				user.put_in_hand(contents[1], user.hand)
				if (contents.len)
					maptext = "[contents.len]"
				else
					maptext = null
				icon_state = "quiver-[min(contents.len, 4)]"
				return
		..()

	MouseDrop(atom/over_object, src_location, over_location)
		..()
		var/obj/screen/hud/S = over_object
		if (istype(S))
			playsound(src.loc, "rustle", 50, 1, -5)
			if (!usr.restrained() && !usr.stat && src.loc == usr)
				if (S.id == "rhand")
					if (!usr.r_hand)
						usr.u_equip(src)
						usr.put_in_hand(src, 0)
				else
					if (S.id == "lhand")
						if (!usr.l_hand)
							usr.u_equip(src)
							usr.put_in_hand(src, 1)
				return
		if (usr.is_in_hands(src))
			var/turf/T = over_object
			if (istype(T, /obj/table))
				T = get_turf(T)
			if (!(usr in range(1, T)))
				return
			if (istype(T))
				for (var/obj/O in T)
					if (O.density && !istype(O, /obj/table) && !istype(O, /obj/rack))
						return
				if (!T.density)
					usr.visible_message("<span style=\"color:red\">[usr] dumps the contents of [src] onto [T]!</span>")
					for (var/obj/item/I in src)
						I.set_loc(T)
						I.layer = initial(I.layer)

/datum/projectile/arrow
	name = "arrow"
	power = 25
	dissipation_delay = 4
	dissipation_rate = 5
	shot_sound = 'sound/effects/bow_fire.ogg'
	damage_type = D_KINETIC
	hit_type = DAMAGE_STAB
	implanted = null
	ks_ratio = 1.0
	icon_turf_hit = "bhole"
	icon_state = "arrow"

	on_hit(var/atom/A, angle, var/obj/projectile/P)
		if (ismob(A))
			playsound(get_turf(A), 'sound/effects/bloody_stab.ogg', 75, 1)
			var/obj/item/implant/projectile/arrow/B = P.implanted
			if (istype(B))
				if (B.material)
					B.material.triggerOnAttack(B, null, A)
				B.arrow.reagents.reaction(A, 2)
				B.arrow.reagents.trans_to(A, B.arrow.reagents.total_volume)
			take_bleeding_damage(A, null, round(src.power / 3), src.hit_type)


/obj/item/gun/bow
	name = "bow"
	icon = 'icons/obj/items.dmi'
	icon_state = "bow"
	var/obj/item/arrow/loaded = null
	var/datum/action/bar/aim/aim = null
	current_projectile = new/datum/projectile/arrow
	spread_angle = 30
	force = 5

	attack_hand(var/mob/user)
		if (loaded && user.is_in_hands(src))
			user.put_in_hand_or_drop(loaded)
			boutput(user, "<span style='color:blue'>You unload the arrow from the bow.</span>")
			overlays.len = 0
			loaded = null
		else
			..()

	attack(var/mob/target, var/mob/user)
		user.lastattacked = target
		target.lastattacker = user
		target.lastattackertime = world.time

		if(isliving(target) && aim)
			src.shoot_point_blank(target, user)
		else
			..()

	#ifdef DATALOGGER
			game_stats.Increment("violence")
	#endif
			return


	attack_self(var/mob/user)
		if (!aim && loaded)
			aim = new(user, src)
			actions.start(aim, user)

	process_ammo(var/mob/user)
		if (!loaded)
			boutput(user, "<span style='color:red'>Nothing is loaded in the bow!</span>")
			return 0
		overlays.len = 0
		var/obj/item/implant/projectile/arrow/A = new
		A.material = loaded.head_material
		A.arrow = loaded
		A.name = loaded.name
		current_projectile.name = loaded.name
		loaded.set_loc(A)
		current_projectile.implanted = A
		loaded = null
		return 1

	canshoot()
		return loaded != null

	pixelaction(atom/target, params, mob/user, reach)
		if (!loaded)
			boutput(user, "<span style='color:red'>Nothing is loaded in the bow!</span>")
			return 1
		spread_angle = 30
		if (aim)
			spread_angle = (1 - aim.progress) * 30
			aim.state = ACTIONSTATE_FINISH
		..()

	attackby(var/obj/item/arrow/I, var/mob/user)
		if (!istype(I))
			return
		if (loaded)
			boutput(user, "<span style='color:red'>An arrow is already loaded onto the bow.</span>")
		overlays += I
		user.u_equip(I)
		loaded = I
		I.loc = src
