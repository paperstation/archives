/obj/machinery/bot/ed209
	name = "\improper ED-209 Security Robot"
	desc = "A security robot.  He looks less than thrilled."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "ed2090"
	layer = 5.0
	density = 1
	anchored = 0
//	weight = 1.0E7
	req_one_access = list(access_security, access_forensics_lockers)
	health = 100
	maxhealth = 100
	fire_dam_coeff = 0.7
	brute_dam_coeff = 0.5

	var/lastfired = 0
	var/shot_delay = 3 //.3 seconds between shots
	var/lasercolor = ""
	var/disabled = 0//A holder for if it needs to be disabled, if true it will not seach for targets, shoot at targets, or move, currently only used for lasertag

	//var/lasers = 0

	var/mob/living/carbon/target
	var/oldtarget_name
	var/threatlevel = 0
	var/target_lastloc //Loc of target when arrested.
	var/last_found //There's a delay
//var/emagged = 0 //Emagged Secbots view everyone as a criminal
	var/declare_arrests = 1 //When making an arrest, should it notify everyone wearing sechuds?
	var/idcheck = 1 //If true, arrest people with no IDs
	var/weaponscheck = 1 //If true, arrest people for weapons if they don't have access
	var/check_records = 1 //Does it check security records?
	var/arrest_type = 0 //If true, don't handcuff
	var/projectile = null//Holder for projectile type, to avoid so many else if chains
	bot_type = SEC_BOT
	bot_filter = RADIO_SECBOT
/
	//List of weapons that secbots will not arrest for
	var/safe_weapons = list(\
		/obj/item/weapon/gun/energy/laser/bluetag,\
		/obj/item/weapon/gun/energy/laser/redtag,\
		/obj/item/weapon/gun/energy/laser/practice)


/obj/item/weapon/ed209_assembly
	name = "\improper ED-209 assembly"
	desc = "Some sort of bizarre assembly."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "ed209_frame"
	item_state = "ed209_frame"
	var/build_step = 0
	var/created_name = "ED-209 Security Robot" //To preserve the name if it's a unique securitron I guess
	var/lasercolor = ""


/obj/machinery/bot/ed209/New(loc,created_name,created_lasercolor)
	..()
	if(created_name)		name = created_name
	if(created_lasercolor)	lasercolor = created_lasercolor
	icon_state = "[lasercolor]ed209[on]"
	spawn(3)
		var/datum/job/detective/J = new/datum/job/detective
		botcard.access = J.get_access()
		prev_access = botcard.access


		add_to_beacons(bot_filter)
		if(lasercolor)
			shot_delay = 6//Longer shot delay because JESUS CHRIST
			check_records = 0//Don't actively target people set to arrest
			arrest_type = 1//Don't even try to cuff
			req_access = list(access_maint_tunnels, access_theatre)
			arrest_type = 1
			if((lasercolor == "b") && (name == "ED-209 Security Robot"))//Picks a name if there isn't already a custome one
				name = pick("BLUE BALLER","SANIC","BLUE KILLDEATH MURDERBOT")
			if((lasercolor == "r") && (name == "ED-209 Security Robot"))
				name = pick("RED RAMPAGE","RED ROVER","RED KILLDEATH MURDERBOT")

/obj/machinery/bot/ed209/turn_on()
	. = ..()
	icon_state = "[lasercolor]ed209[on]"
	mode = BOT_IDLE
	updateUsrDialog()

/obj/machinery/bot/ed209/turn_off()
	..()
	icon_state = "[lasercolor]ed209[on]"
	updateUsrDialog()

/obj/machinery/bot/ed209/bot_reset()
	..()
	target = null
	oldtarget_name = null
	anchored = 0
	walk_to(src,0)
	last_found = world.time
	projectile = null

/obj/machinery/bot/ed209/set_custom_texts()
	text_hack = "You disable [name]'s combat inhibitor."
	text_dehack = "You restore [name]'s combat inhibitor."
	text_dehack_fail = "[name] ignores your attempts to restrict him!"

/obj/machinery/bot/ed209/attack_hand(mob/user as mob)
	. = ..()
	if (.)
		return
	var/dat
	dat += hack(user)
	dat += text({"
<TT><B>Security Unit v2.6 controls</B></TT><BR><BR>
Status: []<BR>
Behaviour controls are [locked ? "locked" : "unlocked"]<BR>
Maintenance panel panel is [open ? "opened" : "closed"]"},

"<A href='?src=\ref[src];power=1'>[on ? "On" : "Off"]</A>" )

	if(!locked || issilicon(user))
		if(!lasercolor)
			dat += text({"<BR>
Arrest for No ID: []<BR>
Arrest for Unauthorized Weapons: []<BR>
Arrest for Warrant: []<BR>
<BR>
Operating Mode: []<BR>
Report Arrests[]<BR>
Auto Patrol: []"},

"<A href='?src=\ref[src];operation=idcheck'>[idcheck ? "Yes" : "No"]</A>",
"<A href='?src=\ref[src];operation=weaponscheck'>[weaponscheck ? "Yes" : "No"]</A>",
"<A href='?src=\ref[src];operation=ignorerec'>[check_records ? "Yes" : "No"]</A>",
"<A href='?src=\ref[src];operation=switchmode'>[arrest_type ? "Detain" : "Arrest"]</A>",
"<A href='?src=\ref[src];operation=declarearrests'>[declare_arrests ? "Yes" : "No"]</A>",
"<A href='?src=\ref[src];operation=patrol'>[auto_patrol ? "On" : "Off"]</A>" )
		else
			dat += text({"<BR>
Auto Patrol: []"},

"<A href='?src=\ref[src];operation=patrol'>[auto_patrol ? "On" : "Off"]</A>" )


	var/datum/browser/popup = new(user, "autoed209", "Automatic Security Unit v2.6")
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/bot/ed209/Topic(href, href_list)
	if(lasercolor && (istype(usr,/mob/living/carbon/human)))
		var/mob/living/carbon/human/H = usr
		if((lasercolor == "b") && (istype(H.wear_suit, /obj/item/clothing/suit/redtag)))//Opposing team cannot operate it
			return
		else if((lasercolor == "r") && (istype(H.wear_suit, /obj/item/clothing/suit/bluetag)))
			return
	..()

	switch(href_list["operation"])
		if ("idcheck")
			idcheck = !idcheck
		if("weaponscheck")
			weaponscheck = !weaponscheck
			updateUsrDialog()
			updateUsrDialog()
		if ("ignorerec")
			check_records = !check_records
			updateUsrDialog()
		if ("switchmode")
			arrest_type = !arrest_type
			updateUsrDialog()
		if("declarearrests")
			declare_arrests = !declare_arrests
			updateUsrDialog()

/obj/machinery/bot/ed209/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/card/id)||istype(W, /obj/item/device/pda))
		if (allowed(user) && !open && !emagged)
			locked = !locked
			user << "<span class='notice'>Controls are now [locked ? "locked" : "unlocked"].</span>"
		else
			if(emagged)
				user << "<span class='warning'>ERROR</span>"
			if(open)
				user << "<span class='warning'>Please close the access panel before locking it.</span>"
			else
				user << "<span class='notice'>Access denied.</span>"
	else
		..()
		if (!istype(W, /obj/item/weapon/screwdriver) && !istype(W, /obj/item/weapon/weldingtool) && (!target)) // Added check for welding tool to fix #2432. Welding tool behavior is handled in superclass.
			if(hasvar(W,"force") && W.force)//If force is defined and non-zero
				threatlevel = user.assess_threat(src)
				threatlevel += 6
				if(threatlevel > 0)
					target = user
					if(lasercolor)//To make up for the fact that lasertag bots don't hunt
						shootAt(user)
					mode = BOT_HUNT

/obj/machinery/bot/ed209/Emag(mob/user as mob)
	..()
	if(emagged == 2)
		if(user)
			user << "<span class='warning'>You short out [src]'s target assessment circuits.</span>"
		spawn(0)
			for(var/mob/O in hearers(src, null))
				O.show_message("<span class='danger'> <B>[src] buzzes oddly!</B></span>", 1)
		if(user)
			oldtarget_name = user.name
		projectile = null
		declare_arrests = 0

/obj/machinery/bot/ed209/process()
	set background = BACKGROUND_ENABLED

	if (!on || disabled)
		return

	if(call_path)
		call_mode()
		return

	var/list/targets = list()
	for (var/mob/living/carbon/C in view(9,src)) //Let's find us a target
		var/threatlevel = 0
		if ((C.stat) || (C.lying))
			continue
		if (istype(C, /mob/living/carbon/human))
			threatlevel = C.assess_threat(src, lasercolor)
		//speak(C.real_name + text(": threat: []", threatlevel))
		if (threatlevel < 4 )
			continue

		var/dst = get_dist(src, C)
		if ( dst <= 1 || dst > 12)
			continue

		targets += C
	if (targets.len>0)
		var/mob/t = pick(targets)
		if (istype(t, /mob/living))
			if ((t.stat!=2) && (t.lying != 1))
				//speak("selected target: " + t.real_name)
				shootAt(t)
	switch(mode)

		if(BOT_IDLE)		// idle
			walk_to(src,0)
			look_for_perp()	// see if any criminals are in range
			if(!mode && auto_patrol)	// still idle, and set to patrol
				mode = BOT_START_PATROL	// switch to patrol mode

		if(BOT_HUNT)		// hunting for perp
			if(lasercolor)//Lasertag bots do not tase or arrest anyone, just patrol and shoot and whatnot
				mode = BOT_IDLE
				return
			// if can't reach perp for long enough, go idle
			if (frustration >= 8)
		//		for(var/mob/O in hearers(src, null))
		//			O << "<span class='game say'><span class='name'>[src]</span> beeps, \"Backup requested! Suspect has evaded arrest.\""
				target = null
				last_found = world.time
				frustration = 0
				mode = BOT_IDLE
				walk_to(src,0)

			if (target)		// make sure target exists
				if (get_dist(src, target) <= 1)		// if right next to perp
					playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)
					icon_state = "[lasercolor]ed209-c"
					spawn(2)
						icon_state = "[lasercolor]ed209[on]"
					var/mob/living/carbon/M = target
					var/maxstuns = 4
					if (istype(M, /mob/living/carbon/human))
						if (M.stuttering < 10 && (!M.has_organic_effect(/datum/organic_effect/hulk))  /*&& (!istype(M:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
							M.stuttering = 10
						M.Stun(10)
						M.Weaken(10)
					else
						M.Weaken(10)
						M.stuttering = 10
						M.Stun(10)

					if(declare_arrests)
						declare()
					target.visible_message("<span class='danger'>[target] has been stunned by [src]!</span>",\
											"<span class='userdanger'>[target] has been stunned by [src]!</span></span>")

					maxstuns--
					if (maxstuns <= 0)
						target = null

					mode = BOT_PREP_ARREST
					anchored = 1
					target_lastloc = M.loc
					return

				else								// not next to perp
					var/turf/olddist = get_dist(src, target)
					walk_to(src, target,1,4)
					if ((get_dist(src, target)) >= (olddist))
						frustration++
					else
						frustration = 0

		if(BOT_PREP_ARREST)		// preparing to arrest target
			if(lasercolor)
				mode = BOT_IDLE
				return
			if (!target)
				mode = BOT_IDLE
				anchored = 0
				return
			// see if he got away
			if ((get_dist(src, target) > 1) || ((target:loc != target_lastloc) && target:weakened < 2))
				anchored = 0
				mode = BOT_HUNT
				return

			if(iscarbon(target) && target.canBeHandcuffed())
				if (!target.handcuffed && !arrest_type)
					playsound(loc, 'sound/weapons/cablecuff.ogg', 30, 1, -2)
					mode = BOT_ARREST
					visible_message("<span class='danger'> <B>[src] is trying to restrain [target] with zipties!</B></span>")

					spawn(60)
						if (get_dist(src, target) <= 1)
							if (target.handcuffed)
								return

							if(istype(target,/mob/living/carbon))
								target.handcuffed = new /obj/item/weapon/handcuffs/cyborg(target)
								target.update_inv_handcuffed(0)	//update handcuff overlays

							mode = BOT_IDLE
							target = null
							anchored = 0
							last_found = world.time
							frustration = 0

		//					playsound(loc, pick('sound/voice/bgod.ogg', 'sound/voice/biamthelaw.ogg', 'sound/voice/bsecureday.ogg', 'sound/voice/bradio.ogg', 'sound/voice/binsult.ogg', 'sound/voice/bcreep.ogg'), 50, 0)
		//					var/arrest_message = pick("Have a secure day!","I AM THE LAW.", "God made tomorrow for the crooks we don't catch today.","You can't outrun a radio.")
		//					speak(arrest_message)
			else
				mode = BOT_IDLE
				target = null
				anchored = 0
				last_found = world.time
				frustration = 0

		if(BOT_ARREST)		// arresting
			if(lasercolor)
				mode = BOT_IDLE
				return
			if (!target || target.handcuffed)
				anchored = 0
				mode = BOT_IDLE
				return
			else
				mode = BOT_PREP_ARREST
				anchored = 0

		if(BOT_START_PATROL)
			start_patrol()

		if(BOT_PATROL)
			bot_patrol()

		if(BOT_SUMMON)
			bot_summon()
	return

// look for a criminal in view of the bot

/obj/machinery/bot/ed209/proc/look_for_perp()
	if(disabled)
		return
	anchored = 0
	threatlevel = 0
	for (var/mob/living/carbon/C in view(12,src)) //Let's find us a criminal
		if ((C.stat) || (C.handcuffed))
			continue

		if((lasercolor) && (C.lying))
			continue//Does not shoot at people lyind down when in lasertag mode, because it's just annoying, and they can fire once they get up.

		if ((C.name == oldtarget_name) && (world.time < last_found + 100))
			continue

		threatlevel = C.assess_threat(src, lasercolor)

		if (!threatlevel)
			continue

		else if (threatlevel >= 4)
			target = C
			oldtarget_name = C.name
			speak("Level [threatlevel] infraction alert!")
			if(!lasercolor)
				playsound(loc, pick('sound/voice/ed209_20sec.ogg', 'sound/voice/EDPlaceholder.ogg'), 50, 0)
			visible_message("<b>[src]</b> points at [C.name]!")
			mode = BOT_HUNT
			spawn(0)
				process()	// ensure bot quickly responds to a perp
			break
		else
			continue




/obj/machinery/bot/ed209/proc/check_for_weapons(var/obj/item/slot_item)
	if(istype(slot_item, /obj/item/weapon/gun) || istype(slot_item, /obj/item/weapon/melee))
		if(!(slot_item.type in safe_weapons))
			return 1
	return 0
/* terrible
/obj/machinery/bot/ed209/Bumped(atom/movable/M as mob|obj)
	spawn(0)
		if (M)
			var/turf/T = get_turf(src)
			M:loc = T
*/

/obj/machinery/bot/ed209/explode()
	walk_to(src,0)
	visible_message("<span class='danger'> <B>[src] blows apart!</B></span>", 1)
	var/turf/Tsec = get_turf(src)

	var/obj/item/weapon/ed209_assembly/Sa = new /obj/item/weapon/ed209_assembly(Tsec)
	Sa.build_step = 1
	Sa.overlays += image('icons/obj/aibots.dmi', "hs_hole")
	Sa.created_name = name
	new /obj/item/device/assembly/prox_sensor(Tsec)

	if(!lasercolor)
		var/obj/item/weapon/gun/energy/taser/G = new /obj/item/weapon/gun/energy/taser(Tsec)
		G.power_supply.charge = 0
	else if(lasercolor == "b")
		var/obj/item/weapon/gun/energy/laser/bluetag/G = new /obj/item/weapon/gun/energy/laser/bluetag(Tsec)
		G.power_supply.charge = 0
	else if(lasercolor == "r")
		var/obj/item/weapon/gun/energy/laser/redtag/G = new /obj/item/weapon/gun/energy/laser/redtag(Tsec)
		G.power_supply.charge = 0

	if (prob(50))
		new /obj/item/robot_parts/l_leg(Tsec)
		if (prob(25))
			new /obj/item/robot_parts/r_leg(Tsec)
	if (prob(25))//50% chance for a helmet OR vest
		if (prob(50))
			new /obj/item/clothing/head/helmet(Tsec)
		else
			if(!lasercolor)
				new /obj/item/clothing/suit/armor/vest(Tsec)
			if(lasercolor == "b")
				new /obj/item/clothing/suit/bluetag(Tsec)
			if(lasercolor == "r")
				new /obj/item/clothing/suit/redtag(Tsec)

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()

	new /obj/effect/decal/cleanable/oil(loc)
	qdel(src)


/obj/machinery/bot/ed209/proc/shootAt(var/mob/target)
	if(lastfired && world.time - lastfired < shot_delay)
		return
	lastfired = world.time
	var/turf/T = loc
	var/atom/U = (istype(target, /atom/movable) ? target.loc : target)
	if ((!( U ) || !( T )))
		return
	while(!( istype(U, /turf) ))
		U = U.loc
	if (!( istype(T, /turf) ))
		return

	//if(lastfired && world.time - lastfired < 100)
	//	playsound(loc, 'ed209_shoot.ogg', 50, 0)
	var/shoot_sound

	if(!projectile)
		shoot_sound = 'sound/weapons/laser.ogg' //Pew Pew!
		if(!lasercolor)
			if (emagged == 2)
				projectile = /obj/item/projectile/beam
			else
				projectile = /obj/item/projectile/energy/electrode
				shoot_sound = 'sound/weapons/Taser.ogg' //Face the wrath of the Golden Bolt!
		else if(lasercolor == "b")
			if (emagged == 2)
				projectile = /obj/item/projectile/lasertag
			else
				projectile = /obj/item/projectile/lasertag/bluetag
		else if(lasercolor == "r")
			if (emagged == 2)
				projectile = /obj/item/projectile/lasertag
			else
				projectile = /obj/item/projectile/lasertag/redtag

	if (!( istype(U, /turf) ))
		return
	var/obj/item/projectile/A = new projectile (loc)
	playsound(loc, shoot_sound, 60, 1)
	A.current = U
	A.yo = U.y - T.y
	A.xo = U.x - T.x
	spawn( 0 )
		A.process()
		return
	return

/obj/machinery/bot/ed209/attack_alien(var/mob/living/carbon/alien/user as mob)
	..()
	if (!isalien(target))
		target = user
		mode = BOT_HUNT


/obj/machinery/bot/ed209/emp_act(severity)

	if(severity==2 && prob(70))
		..(severity-1)
	else
		var/obj/effect/overlay/pulse2 = new/obj/effect/overlay ( loc )
		pulse2.icon = 'icons/effects/effects.dmi'
		pulse2.icon_state = "empdisable"
		pulse2.name = "emp sparks"
		pulse2.anchored = 1
		pulse2.dir = pick(cardinal)
		spawn(10)
			pulse2.delete()
		var/list/mob/living/carbon/targets = new
		for (var/mob/living/carbon/C in view(12,src))
			if (C.stat==2)
				continue
			targets += C
		if(targets.len)
			if(prob(50))
				var/mob/toshoot = pick(targets)
				if (toshoot)
					targets-=toshoot
					if (prob(50) && emagged < 2)
						emagged = 2
						shootAt(toshoot)
						emagged = 0
					else
						shootAt(toshoot)
			else if(prob(50))
				if(targets.len)
					var/mob/toarrest = pick(targets)
					if (toarrest)
						target = toarrest
						mode = BOT_HUNT



/obj/item/weapon/ed209_assembly/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()

	if(istype(W, /obj/item/weapon/pen))
		var/t = copytext(stripped_input(user, "Enter new robot name", name, created_name),1,MAX_NAME_LEN)
		if(!t)	return
		if(!in_range(src, usr) && loc != usr)	return
		created_name = t
		return

	switch(build_step)
		if(0,1)
			if(istype(W, /obj/item/robot_parts/l_leg) || istype(W, /obj/item/robot_parts/r_leg))
				user.drop_item()
				qdel(W)
				build_step++
				user << "<span class='notice'>You add the robot leg to [src].</span>"
				name = "legs/frame assembly"
				if(build_step == 1)
					item_state = "ed209_leg"
					icon_state = "ed209_leg"
				else
					item_state = "ed209_legs"
					icon_state = "ed209_legs"

		if(2)
			if(istype(W, /obj/item/clothing/suit/redtag))
				lasercolor = "r"
			else if(istype(W, /obj/item/clothing/suit/bluetag))
				lasercolor = "b"
			if(lasercolor || istype(W, /obj/item/clothing/suit/armor/vest))
				user.drop_item()
				qdel(W)
				build_step++
				user << "<span class='notice'>You add the armor to [src].</span>"
				name = "vest/legs/frame assembly"
				item_state = "[lasercolor]ed209_shell"
				icon_state = "[lasercolor]ed209_shell"

		if(3)
			if(istype(W, /obj/item/weapon/weldingtool))
				var/obj/item/weapon/weldingtool/WT = W
				if(WT.remove_fuel(0,user))
					build_step++
					name = "shielded frame assembly"
					user << "<span class='notice'>You welded the vest to [src].</span>"
		if(4)
			switch(lasercolor)
				if("b")
					if(!istype(W, /obj/item/clothing/head/helmet/bluetaghelm))
						return

				if("r")
					if(!istype(W, /obj/item/clothing/head/helmet/redtaghelm))
						return

				if("")
					if(!istype(W, /obj/item/clothing/head/helmet))
						return

			user.drop_item()
			qdel(W)
			build_step++
			user << "<span class='notice'>You add the helmet to [src].</span>"
			name = "covered and shielded frame assembly"
			item_state = "[lasercolor]ed209_hat"
			icon_state = "[lasercolor]ed209_hat"

		if(5)
			if(isprox(W))
				user.drop_item()
				qdel(W)
				build_step++
				user << "<span class='notice'>You add the prox sensor to [src].</span>"
				name = "covered, shielded and sensored frame assembly"
				item_state = "[lasercolor]ed209_prox"
				icon_state = "[lasercolor]ed209_prox"

		if(6)
			if(istype(W, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/coil = W
				var/turf/T = get_turf(user)
				user << "<span class='notice'>You start to wire [src]...</span>"
				sleep(40)
				if(get_turf(user) == T)
					coil.use(1)
					build_step++
					user << "<span class='notice'>You wire the ED-209 assembly.</span>"
					name = "wired ED-209 assembly"

		if(7)
			switch(lasercolor)
				if("b")
					if(!istype(W, /obj/item/weapon/gun/energy/laser/bluetag))
						return
					name = "bluetag ED-209 assembly"
				if("r")
					if(!istype(W, /obj/item/weapon/gun/energy/laser/redtag))
						return
					name = "redtag ED-209 assembly"
				if("")
					if(!istype(W, /obj/item/weapon/gun/energy/taser))
						return
					name = "taser ED-209 assembly"
				else
					return
			build_step++
			user << "<span class='notice'>You add [W] to [src].</span>"
			item_state = "[lasercolor]ed209_taser"
			icon_state = "[lasercolor]ed209_taser"
			user.drop_item()
			qdel(W)

		if(8)
			if(istype(W, /obj/item/weapon/screwdriver))
				playsound(loc, 'sound/items/Screwdriver.ogg', 100, 1)
				var/turf/T = get_turf(user)
				user << "<span class='notice'>Now attaching the gun to the frame...</span>"
				sleep(40)
				if(get_turf(user) == T)
					build_step++
					name = "armed [name]"
					user << "<span class='notice'>Taser gun attached.</span>"

		if(9)
			if(istype(W, /obj/item/weapon/stock_parts/cell))
				build_step++
				user << "<span class='notice'>You complete the ED-209.</span>"
				var/turf/T = get_turf(src)
				new /obj/machinery/bot/ed209(T,created_name,lasercolor)
				user.drop_item()
				qdel(W)
				user.unEquip(src, 1)
				qdel(src)


/obj/machinery/bot/ed209/bullet_act(var/obj/item/projectile/Proj)
	if(!disabled)
		var/lasertag_check = 0
		if((lasercolor == "b"))
			if(istype(Proj, /obj/item/projectile/lasertag/redtag))
				lasertag_check++
		else if((lasercolor == "r"))
			if(istype(Proj, /obj/item/projectile/lasertag/bluetag))
				lasertag_check++
		if(lasertag_check)
			icon_state = "[lasercolor]ed2090"
			disabled = 1
			target = null
			spawn(100)
				disabled = 0
				icon_state = "[lasercolor]ed2091"
			return 1
		else
			..(Proj)
	else
		..(Proj)

/obj/machinery/bot/ed209/bluetag/New()//If desired, you spawn red and bluetag bots easily
	new /obj/machinery/bot/ed209(get_turf(src),null,"b")
	qdel(src)


/obj/machinery/bot/ed209/redtag/New()
	new /obj/machinery/bot/ed209(get_turf(src),null,"r")
	qdel(src)

/obj/machinery/bot/ed209/declare()
	var/area/location = get_area(src)
	declare_message = "<span class='info'>\icon[src] [name] is [arrest_type ? "detaining" : "arresting"] level [threatlevel] scumbag <b>[target]</b> in <b>[location]</b></span>"
	..()