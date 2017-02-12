/obj/item/device/flash
	name = "flash"
	desc = "A device that emits an extremely bright light when used. Useful for briefly stunning people or starting a dance party."
	icon_state = "flash"
	throwforce = 5
	w_class = 1.0
	throw_speed = 4
	throw_range = 10
	flags = FPRINT | TABLEPASS| CONDUCT
	item_state = "electronic"
	mats = 2
	module_research = list("energy" = 1, "devices" = 3)

	var/status = 1 // Bulb still functional?
	var/secure = 1 // Access panel still secured?
	var/use = 0 // Times the flash has been used.
	var/l_time = 0 // Anti-spam cooldown (in relation to world time).

	var/eye_damage_mod = 0
	var/range_mod = 0
	var/burn_mod = 0 // De-/increases probability of bulb burning out, so not related to BURN damage.
	var/stun_mod = 0

	var/animation_type = "flash2"

	var/turboflash = 0 // Turbo flash-specific vars.
	var/obj/item/cell/cell = null
	var/max_flash_power = 0
	var/min_flash_power = 0

	cyborg
		process_burnout(mob/user)
			return

		attack(mob/living/M as mob, mob/user as mob)
			..()
			var/mob/living/silicon/robot/R = user
			if (istype(R))
				R.cell.use(300)

		attack_self(mob/user as mob, flag)
			..()
			var/mob/living/silicon/robot/R = user
			if (istype(R))
				R.cell.use(150)

// Tweaked attack and attack_self to reduce the amount of duplicate code. Turboflashes to be precise (Convair880).
/obj/item/device/flash/attack(mob/living/M as mob, mob/user as mob)
	src.add_fingerprint(user)

	if (src.l_time && world.time < src.l_time + 20)
		return
	if (user.bioHolder && user.bioHolder.HasEffect("clumsy") && prob(50))
		user.visible_message("<span style=\"color:red\"><b>[user]</b> tries to use [src], but slips and drops it!</span>")
		user.drop_item()
		return
	if (src.status == 0)
		boutput(user, "<span style=\"color:red\">The bulb has been burnt out!</span>")
		return

	// Handle turboflash power cell.
	var/flash_power = 0
	if (src.turboflash)
		if (!src.cell)
			user.show_text("[src] doesn't seem to be connected to a power cell.", "red")
			return
		if (src.cell && istype(src.cell,/obj/item/cell/erebite))
			user.visible_message("<span style=\"color:red\">[user]'s flash/cell assembly violently explodes!</span>")
			logTheThing("combat", user, M, "tries to blind %target% with [src] (erebite power cell) at [log_loc(user)].")
			var/turf/T = get_turf(src.loc)
			explosion(src, T, 0, 1, 2, 2)
			spawn (1)
				if (src) qdel(src)
			return
		if (src.cell)
			if (src.cell.charge < min_flash_power)
				user.show_text("[src] seems to be out of power.", "red")
				return
			else
				flash_power = src.cell.charge / max_flash_power
				if (flash_power > 1)
					flash_power = 1
				flash_power++
	else
		flash_power = 1

	// Play animations.
	if (isrobot(user))
		spawn(0)
			var/atom/movable/overlay/animation = new(user.loc)
			animation.layer = user.layer + 1
			animation.icon_state = "blank"
			animation.icon = 'icons/mob/mob.dmi'
			animation.master = user
			flick("blspell", animation)
			sleep(5)
			qdel(animation)

	playsound(src.loc, "sound/weapons/flash.ogg", 100, 1)
	flick(src.animation_type, src)
	src.l_time = world.time
	if (!src.turboflash)
		src.use++

	// Calculate target damage.
	var/animation_duration
	var/weakened
	var/eye_blurry
	var/eye_damage
	var/burning

	if (src.turboflash)
		animation_duration = 60
		weakened = (10 + src.stun_mod) * flash_power
		eye_blurry = src.eye_damage_mod + rand(2, (4 * flash_power))
		eye_damage = src.eye_damage_mod + rand(5, (10 * flash_power))
		burning = 15 * flash_power
	else
		animation_duration = 30
		weakened = (8 + src.stun_mod) * flash_power
		eye_damage = src.eye_damage_mod + rand(0, (2 * flash_power))

	// We're flashing somebody directly, hence the 100% chance to disrupt cloaking device at the end.
	M.apply_flash(animation_duration, weakened, 0, 0, eye_blurry, eye_damage, 0, burning, 100)

	// Rev mode check.
	if (ticker && ticker.mode && istype(ticker.mode, /datum/game_mode/revolution))
		var/datum/game_mode/revolution/R = ticker.mode
		if (ishuman(M))
			var/mob/living/carbon/human/H = M
			var/safety = 0
			if (H.eyes_protected_from_light())
				safety = 1

			if (safety == 0 && user.mind && (user.mind in R.head_revolutionaries))
				var/list/U = R.get_unconvertables()
				if (!H.client || !H.mind)
					user.show_text("[H] is braindead and cannot be converted.", "red")
				else if (H.mind in U)
					user.show_text("[H] seems unwilling to revolt.", "red")
				else if (H.mind in R.head_revolutionaries)
					user.show_text("[H] is already a member of the revolution.", "red")
				else
					if (!(H.mind in R.revolutionaries))
						R.add_revolutionary(H.mind)
					else
						user.show_text("[H] is already a member of the revolution.", "red")

	// Log entry.
	M.visible_message("<span style=\"color:red\">[user] blinds [M] with the [src.name]!</span>")
	logTheThing("combat", user, M, "blinds %target% with [src] at [log_loc(user)].")

	// Handle bulb wear.
	if (src.turboflash)
		status = 0
		src.cell.use(min(src.cell.charge, max_flash_power))
		boutput(user, "<span style=\"color:red\"><b>The bulb has burnt out!</b></span>")
		src.icon_state = "turboflash3"
		src.name = "depleted flash/cell assembly"

	else
		src.process_burnout(user)

	// Some after attack stuff.
	user.lastattacked = M
	M.lastattacker = user
	M.lastattackertime = world.time

	return

/obj/item/device/flash/attack_self(mob/user as mob)
	src.add_fingerprint(user)

	if (src.l_time && world.time < src.l_time + 20)
		return
	if (user.bioHolder && user.bioHolder.HasEffect("clumsy") && prob(50))
		user.visible_message("<span style=\"color:red\"><b>[user]</b> tries to use [src], but slips and drops it!</span>")
		user.drop_item()
		return
	if (status == 0)
		boutput(user, "<span style=\"color:red\">The bulb has been burnt out!</span>")
		return

	// Handle turboflash power cell.
	if (src.turboflash)
		if (!src.cell)
			user.show_text("[src] doesn't seem to be connected to a power cell.", "red")
			return
		if (src.cell && src.cell.charge < min_flash_power)
			user.show_text("[src] seems to be out of power.", "red")
			return
		if (src.cell && istype(src.cell,/obj/item/cell/erebite))
			user.visible_message("<span style=\"color:red\">[user]'s flash/cell assembly violently explodes!</span>")
			logTheThing("combat", user, null, "tries to area-flash with [src] (erebite power cell) at [log_loc(user)].")
			var/turf/T = get_turf(src.loc)
			explosion(src, T, 0, 1, 2, 2)
			spawn (1)
				if (src) qdel(src)
			return

	// Play animations.
	playsound(src.loc, "sound/weapons/flash.ogg", 100, 1)
	flick(src.animation_type, src)
	src.l_time = world.time

	if (isrobot(user))
		spawn(0)
			var/atom/movable/overlay/animation = new(user.loc)
			animation.layer = user.layer + 1
			animation.icon_state = "blank"
			animation.icon = 'icons/mob/mob.dmi'
			animation.master = user
			flick("blspell", animation)
			sleep(5)
			qdel(animation)

	// Flash target mobs.
	for (var/mob/M in oviewers((3 + src.range_mod), get_turf(src)))
		if (src.turboflash)
			M.apply_flash(35, 0, 0, 25)
		else
			M.apply_flash(20, 0)

	// Handle bulb wear.
	if (src.turboflash)
		status = 0
		src.cell.use(min(src.cell.charge, max_flash_power))
		boutput(user, "<span style=\"color:red\"><b>The bulb has burnt out!</b></span>")
		src.icon_state = "turboflash3"
		src.name = "depleted flash/cell assembly"
	else
		src.use++
		src.process_burnout(user)

	return

/obj/item/device/flash/proc/process_burnout(mob/user as mob)
	if (prob(max(0,(use*2) + burn_mod)))
		status = 0
		boutput(user, "<span style=\"color:red\"><b>The bulb has burnt out!</b></span>")
		icon_state = "flash3"
		name = "depleted flash"

	return

/obj/item/device/flash/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/cell) && !src.secure)
		boutput(user, "<span style=\"color:blue\">You combine [W] and [src]...</span>")
		var/obj/item/device/flash/turbo/T = new /obj/item/device/flash/turbo(user.loc)
		T.cell = W
		user.drop_item()
		W.set_loc(T)

		if(!src.status)
			T.icon_state = "turboflash3"
			T.status = 0

		qdel(src)
		return
	else if (istype(W, /obj/item/screwdriver))
		boutput(user, "<span style=\"color:blue\">You [src.secure ? "unscrew" : "secure"] the access panel.</span>")
		secure = !secure
	else if (istype(W, /obj/item/device/multitool))
		if (src.status == 0)
			boutput(user, "<span style=\"color:red\">The bulb has been burnt out.</span>")
		else
			if (src.use <= 0)
				boutput(user, "<span style=\"color:blue\">The bulb is in perfect condition.</span>")
			else if (src.use>0 && src.use<5)
				boutput(user, "<span style=\"color:blue\">The bulb is in good condition.</span>")
			else if (src.use>5 && src.use<10)
				boutput(user, "<span style=\"color:blue\">The bulb is in decent condition.</span>")
			else if (src.use>10 && src.use<15)
				boutput(user, "<span style=\"color:blue\">The bulb is in bad condition.</span>")
			else
				boutput(user, "<span style=\"color:blue\">The bulb is in terrible condition.</span>")
	else
		return ..()

/obj/item/device/flash/is_detonator_attachment()
	return 1

/obj/item/device/flash/detonator_act(event, var/obj/item/assembly/detonator/det)
	switch (event)
		if ("pulse")
			det.attachedTo.visible_message("<span class='bold' style='color: #B7410E;'>\The [src] discharges.</span>")
			for (var/mob/living/M in viewers(4, det.attachedTo))
				M.apply_flash(30, 20)
		if ("cut")
			det.attachedTo.visible_message("<span class='bold' style='color: #B7410E;'>\The [src] goes black.</span>")
			det.attachments.Remove(src)
		if ("process")
			if (prob(5))
				det.attachedTo.visible_message("<span class='bold' style='color: #B7410E;'>\The [src] discharges.</span>")
				for (var/mob/living/M in viewers(2, det.attachedTo))
					M.apply_flash(30, 8)

/obj/item/device/flash/emp_act()
	if(iscarbon(src.loc))
		src.attack_self()
	return

// The Turboflash - A flash combined with a charged energy cell to make a bigger, meaner flash (That dies after one use).
/obj/item/device/flash/turbo
	name = "flash/cell assembly"
	desc = "A common stun weapon with a power cell hastily wired into it. Looks dangerous."
	icon_state = "turboflash"
	mats = 0
	animation_type = "turboflash2"
	turboflash = 1
	max_flash_power = 5000
	min_flash_power = 500

	New()
		..()
		spawn(10)
			if(!src.cell)
				src.cell = new /obj/item/cell(src)
				src.cell.maxcharge = max_flash_power
				src.cell.charge = src.cell.maxcharge
		return

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/wrench) && !src.secure)
			boutput(user, "You disassemble [src]!")
			src.cell.set_loc(get_turf(src))
			var/obj/item/device/flash/F = new /obj/item/device/flash( get_turf(src) )
			if(!src.status)
				F.status = 0
				F.icon_state = "flash3"
			qdel(src)
		else if (istype(W, /obj/item/screwdriver))
			boutput(user, "<span style=\"color:blue\">You [src.secure ? "unscrew" : "secure"] the access panel.</span>")
			secure = !secure
		return