var/list/forensic_IDs = new/list() //Global list of all guns, based on bioholder uID stuff

/obj/item/gun
	name = "gun"
	icon = 'icons/obj/gun.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_weapons.dmi'
	flags =  FPRINT | TABLEPASS | CONDUCT | ONBELT | USEDELAY | EXTRADELAY
	item_state = "gun"
	m_amt = 2000
	force = 10.0
	throwforce = 5
	w_class = 3.0
	throw_speed = 4
	throw_range = 6
	contraband = 4

	var/spread_angle = 0
	var/datum/projectile/current_projectile = null
	var/list/projectiles = null
	var/current_projectile_num = 1
	var/silenced = 0

	var/forensic_ID = null
	var/add_residue = 0 // Does this gun add gunshot residue when fired (Convair880)?

	New()
		spawn(20)
			src.forensic_ID = src.CreateID()
			forensic_IDs.Add(src.forensic_ID)
		return

/obj/item/gun/proc/CreateID() //Creates a new tracking id for the gun and returns it.
	var/newID = ""

	do
		for(var/i = 1 to 10) // 20 characters are way too fuckin' long for anyone to care about
			newID += "[pick(numbersAndLetters)]"
	while(forensic_IDs.Find(newID))

	return newID

///CHECK_LOCK
///Call to run a weaponlock check vs the users implant
///Return 0 for fail
/obj/item/gun/proc/check_lock(var/user as mob)
	return 1

///CHECK_VALID_SHOT
///Call to check and make sure the shot is ok
///Not called much atm might remove, is now inside shoot
/obj/item/gun/proc/check_valid_shot(atom/target as mob|obj|turf|area, mob/user as mob)
	var/turf/T = get_turf(user)
	var/turf/U = get_turf(target)
	if(!istype(T) || !istype(U))
		return 0
	if (U == T)
		//user.bullet_act(current_projectile)
		return 0
	return 1
/*
/obj/item/gun/proc/emag(obj/item/A as obj, mob/user as mob)
	if(istype(A, /obj/item/card/emag))
		boutput(user, "<span style=\"color:red\">No lock to break!</span>")
		return 1
	return 0
*/
/obj/item/gun/emag_act(var/mob/user, var/obj/item/card/emag/E)
	if (user)
		boutput(user, "<span style=\"color:red\">No lock to break!</span>")
	return 0

/obj/item/gun/attack_self(mob/user as mob)

	if(src.projectiles && src.projectiles.len > 1)
		src.current_projectile_num = ((src.current_projectile_num) % src.projectiles.len) + 1
		src.current_projectile = src.projectiles[src.current_projectile_num]
		boutput(user, "<span style=\"color:blue\">you set the output to [src.current_projectile.sname].</span>")
	return

/obj/item/gun/pixelaction(atom/target, params, mob/user, reach)
	if (reach)
		return 0
	if (!isturf(user.loc))
		return 0
	var/pox = text2num(params["icon-x"]) - 16
	var/poy = text2num(params["icon-y"]) - 16
	shoot(get_turf(target), get_turf(user), user, pox, poy)
	return 1

/obj/item/gun/attack(mob/M as mob, mob/user as mob)

	user.lastattacked = M
	M.lastattacker = user
	M.lastattackertime = world.time

	if(user.a_intent != "help" && isliving(M))
		src.shoot_point_blank(M, user)
	else
		..()

#ifdef DATALOGGER
		game_stats.Increment("violence")
#endif
		return

/obj/item/gun/proc/shoot_point_blank(var/mob/M as mob, var/mob/user as mob)
	if (!M || !user)
		return

	if (!canshoot())
		if (!silenced)
			M.visible_message("<span style=\"color:red\"><B>[user] tries to shoot [M] with [src] point-blank, but it was empty!</B></span>")
		else
			user.show_text("*click* *click*", "red")
		return

	if (ishuman(user) && src.add_residue) // Additional forensic evidence for kinetic firearms (Convair880).
		var/mob/living/carbon/human/H = user
		H.gunshot_residue = 1

	if (!src.silenced)
		for (var/mob/O in AIviewers(M, null))
			if (O.client)
				O.show_message("<span style=\"color:red\"><B>[user] shoots [M] point-blank with [src]!</B></span>")
	else
		user.show_text("<span style=\"color:red\">You silently shoot [M] point-blank with [src]!</span>") // Was non-functional (Convair880).

	if (!process_ammo(user))
		return
	var/obj/projectile/P = initialize_projectile_ST(user, current_projectile, M)
	if (!P)
		return

	if (user == M)
		P.shooter = null
		P.mob_shooter = user

	alter_projectile(P)
	P.forensic_ID = src.forensic_ID // Was missing (Convair880).
	P.was_pointblank = 1
	hit_with_existing_projectile(P, M) // Includes log entry.

	var/mob/living/L = M
	if (M && M.stat == 0)
		L.lastgasp()
	M.set_clothing_icon_dirty()
	src.update_icon()

/obj/item/gun/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
	src.add_fingerprint(user)

	if (flag)
		return

/obj/item/gun/proc/alter_projectile(var/obj/projectile/P)
	return

/obj/item/gun/proc/shoot(var/target,var/start,var/mob/user,var/POX,var/POY)
	if(!canshoot())
		if (ismob(user))
			user.show_text("*click* *click*", "red") // No more attack messages for empty guns (Convair880).
		return
	if(!process_ammo(user))
		return
	if (!istype(target, /turf) || !istype(start, /turf))
		return
	if (!istype(src.current_projectile,/datum/projectile/))
		return

	var/obj/projectile/P = shoot_projectile_ST_pixel_spread(user, current_projectile, target, POX, POY, spread_angle)
	if (P)
		alter_projectile(P)
		P.forensic_ID = src.forensic_ID

	if(user)
		if(!src.silenced)
			for(var/mob/O in AIviewers(user, null))
				O.show_message("<span style=\"color:red\"><B>[user] fires [src] at [target]!</B></span>", 1, "<span style=\"color:red\">You hear a gunshot</span>", 2)
		else
			if (ismob(user)) // Fix for: undefined proc or verb /obj/item/mechanics/gunholder/show text().
				user.show_text("<span style=\"color:red\">You silently fire the [src] at [target]!</span>") // Some user feedback for silenced guns would be nice (Convair880).

		var/turf/T = target
		logTheThing("combat", user, null, "fires \a [src] from [log_loc(user)], vector: ([T.x - user.x], [T.y - user.y]), dir: <I>[dir2text(get_dir(user, target))]</I>, projectile: <I>[P.name]</I>[P.proj_data && P.proj_data.type ? ", [P.proj_data.type]" : null]")

	if (ismob(user))
		var/mob/M = user
		if (ishuman(M) && src.add_residue) // Additional forensic evidence for kinetic firearms (Convair880).
			var/mob/living/carbon/human/H = user
			H.gunshot_residue = 1
		/*if (!disable_next_click) aggressive thing, so disable_next_click shouldn't affect this
			*/M.next_click = world.time + 4

	src.update_icon()

/obj/item/gun/proc/canshoot()
	return 0

/obj/item/gun/examine()
	set src in usr
	set category = "Local"

	if (src.artifact)
		boutput(usr, "You have no idea what the hell this thing is!")
		return

	..()
	return

/obj/item/gun/proc/update_icon()
	return 0

/obj/item/gun/proc/process_ammo(var/mob/user)
	boutput(user, "<span style=\"color:red\">*click* *click*</span>")
	return 0

// Could be useful in certain situations (Convair880).
/obj/item/gun/proc/logme_temp(mob/user as mob, obj/item/gun/G as obj, obj/item/ammo/A as obj)
	if (!user || !G || !A)
		return

	else if (istype(G, /obj/item/gun/kinetic) && istype(A, /obj/item/ammo/bullets))
		logTheThing("combat", user, null, "reloads [G] (<b>Ammo type:</b> <i>[G.current_projectile.type]</i>) at [log_loc(user)].")
		return

	else if (istype(G, /obj/item/gun/energy) && istype(A, /obj/item/ammo/power_cell))
		logTheThing("combat", user, null, "reloads [G] (<b>Cell type:</b> <i>[A.type]</i>) at [log_loc(user)].")
		return

	else return

/obj/item/gun/on_spin_emote(var/mob/living/carbon/human/user as mob)
	if ((user.bioHolder && user.bioHolder.HasEffect("clumsy") && prob(50)) || (user.reagents && prob(user.reagents.get_reagent_amount("ethanol") / 2)) || prob(5))
		user.visible_message("<span style=\"color:red\"><b>[user] accidentally shoots [him_or_her(user)]self with [src]!</b></span>")
		src.shoot_point_blank(user, user)