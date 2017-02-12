var/global/list/available_ai_shells = list()
var/list/ai_emotions = list("Happy" = "ai_happy",\
	"Very Happy" = "ai_veryhappy",\
	"Neutral" = "ai_neutral",\
	"Unsure" = "ai_unsure",\
	"Confused" = "ai_confused",\
	"Surprised" = "ai_surprised",\
	"Sad" = "ai_sad",\
	"Mad" = "ai_mad",\
	"BSOD" = "ai_bsod",\
	"Blank" = "ai_off")

/mob/living/silicon/ai
	name = "AI"
	voice_name = "synthesized voice"
	icon = 'icons/mob/ai.dmi'
	icon_state = "ai"
	anchored = 1
	density = 1
	emaggable = 0 // Can't be emagged...
	syndicate_possible = 1 // ...but we can become a rogue computer.
	var/network = "SS13"
	var/classic_move = 1 //Ordinary AI camera movement
	var/obj/machinery/camera/current = null
	var/list/connected_robots = list()
	//var/list/connected_shells = list()
	var/list/installed_modules = list()
	var/aiRestorePowerRoutine = 0
//	var/datum/ai_laws/laws_object = ticker.centralized_ai_laws
//	var/datum/ai_laws/current_law_set = null
	//var/list/laws = list()
	var/alarms = list("Motion"=list(), "Fire"=list(), "Atmosphere"=list(), "Power"=list())
	var/viewalerts = 0
	var/printalerts = 1
	var/announcearrival = 1
	var/arrivalalert = "$NAME has signed up as $JOB."
	//Comm over powernet stuff
	var/net_id = null
	var/obj/machinery/power/data_terminal/link = null
	var/list/terminals = list() //Stuff connected to us over the powernet
	var/hologramdown = 0 //is the hologram downed?
	var/canvox = 1
	var/dismantle_stage = 0
	var/datum/light/light
	var/death_timer = 100
	var/power_mode = 0
	var/power_area = null
	var/obj/machinery/power/apc/local_apc = null
	var/obj/item/cell/cell = null
	var/obj/item/device/radio/radio1 = null // See /mob/living/say() in living.dm for AI-related radio code.
	var/obj/item/device/radio/radio2 = null
	var/obj/item/device/radio/radio3 = null
	var/obj/item/device/pda2/internal_pda = null
	var/obj/item/organ/brain/brain = null
	var/moustache_mode = 0
	var/status_message = null

	var/faceEmotion = "ai_happy"
	var/faceColor = "#66B2F2"
	var/list/custom_emotions = null

	var/datum/ai_camera_tracker/tracker = null

	var/image/cached_image = null

	var/last_vox = -INFINITY
	var/vox_cooldown = 1200

	sound_fart = 'sound/misc/poo2_robot.ogg'

	req_access = list(access_heads)

/*
	var/datum/game_mode/malfunction/AI_Module/module_picker/malf_picker
	var/processing_time = 100
	var/list/datum/game_mode/malfunction/AI_Module/current_modules = list()

*/
	var/fire_res_on_core = 0

	var/bruteloss = 0
	var/fireloss = 0

/mob/living/silicon/ai/TakeDamage(zone, brute, burn)
	bruteloss += brute
	fireloss += burn

/mob/living/silicon/ai/HealDamage(zone, brute, burn)
	bruteloss -= brute
	fireloss -= burn
	bruteloss = max(0, bruteloss)
	fireloss = max(0, fireloss)

/mob/living/silicon/ai/get_brute_damage()
	return bruteloss

/mob/living/silicon/ai/get_burn_damage()
	return fireloss

/mob/living/silicon/ai/can_strip()
	return 0

/mob/living/silicon/ai/New()
	..()

	light = new /datum/light/point
	light.set_color(0.4, 0.7, 0.95)
	light.set_brightness(0.6)
	light.set_height(0.75)
	light.attach(src)
	light.enable()

	src.brain = new /obj/item/organ/brain/ai(src)

	src.local_apc = get_local_apc(src)
	if(src.local_apc)
		src.power_area = src.local_apc.loc.loc
	src.cell = new /obj/item/cell(src)
	src.radio1 = new /obj/item/device/radio(src)
	src.radio2 = new /obj/item/device/radio(src)
	src.radio3 = new /obj/item/device/radio(src)
	src.internal_pda = new /obj/item/device/pda2/ai(src)

	src.tracker = new /datum/ai_camera_tracker(src)
	update_appearance()

	spawn(0)
		src.botcard.access = get_all_accesses()
		src.cell.charge = src.cell.maxcharge
		src.radio1.name = "Primary AI Radio"
		src.radio2.name = "Secondary AI Radio"
		src.radio3.name = "Tertiary AI Radio"
		src.radio1.broadcasting = 1
		src.radio2.set_frequency(R_FREQ_INTERCOM_AI)
		src.radio3.broadcasting = 0
		src.internal_pda.name = "AI's Internal PDA Unit"
		src.internal_pda.owner = "AI"
		if (src.brain && src.key)
			src.brain.name = "neural net processor"
			src.brain.owner = src.mind

	spawn(6)
		src.net_id = format_net_id("\ref[src]")

		if(!src.link)
			var/turf/T = get_turf(src)
			var/obj/machinery/power/data_terminal/test_link = locate() in T
			if(test_link && !test_link.is_valid_master(test_link.master))
				src.link = test_link
				src.link.master = src

		for (var/mob/living/silicon/hivebot/eyebot/E in mobs)
			if (!(E in available_ai_shells))
				available_ai_shells += E

		for (var/mob/living/silicon/robot/R in mobs)
			if (R.brain || !R.ai_interface || R.dependent)
				continue
			if (!(R in available_ai_shells))
				available_ai_shells += R

/mob/living/silicon/ai/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/screwdriver))
		src.anchored = !src.anchored
		playsound(src.loc, "sound/items/Screwdriver.ogg", 50, 1)
		user.visible_message("<span style=\"color:red\"><b>[user.name]</b> [src.anchored ? "screws down" : "unscrews"] [src.name]'s floor bolts.</span>")

	else if (istype(W, /obj/item/crowbar))
		if (src.dismantle_stage == 1)
			playsound(src.loc, "sound/items/Crowbar.ogg", 50, 1)
			src.visible_message("<span style=\"color:red\"><b>[user.name]</b> opens [src.name]'s chassis cover.</span>")
			src.dismantle_stage = 2
		else if (src.dismantle_stage == 2)
			playsound(src.loc, "sound/items/Crowbar.ogg", 50, 1)
			src.visible_message("<span style=\"color:red\"><b>[user.name]</b> closes [src.name]'s chassis cover.</span>")
			src.dismantle_stage = 1
		else ..()

	else if (istype(W, /obj/item/wrench))
		if (src.dismantle_stage == 2)
			playsound(src.loc, "sound/items/Ratchet.ogg", 50, 1)
			src.visible_message("<span style=\"color:red\"><b>[user.name]</b> begins undoing [src.name]'s CPU bolts.</span>")
			var/turf/T = user.loc
			spawn(60)
				if (user.loc != T || !can_act(user))
					boutput(user, "<span style=\"color:red\">You were interrupted!</span>")
					return
				src.visible_message("<span style=\"color:red\"><b>[user.name]</b> removes [src.name]'s CPU bolts.</span>")
				src.dismantle_stage = 3
		else if (src.dismantle_stage == 3)
			playsound(src.loc, "sound/items/Ratchet.ogg", 50, 1)
			src.visible_message("<span style=\"color:red\"><b>[user.name]</b> begins affixing [src.name]'s CPU bolts.</span>")
			var/turf/T = user.loc
			spawn(60)
				if (user.loc != T || !can_act(user))
					boutput(user, "<span style=\"color:red\">You were interrupted!</span>")
					return
				src.visible_message("<span style=\"color:red\"><b>[user.name]</b> puts [src.name]'s CPU bolts into place.</span>")
				src.dismantle_stage = 2
		else ..()

	else if (istype(W, /obj/item/weldingtool))
		var/obj/item/weldingtool/WELD = W
		if (WELD.welding)
			if (WELD.get_fuel() < 2)
				boutput(user, "<span style=\"color:red\">You need more welding fuel!</span>")
				return
			src.add_fingerprint(user)
			if(src.bruteloss)
				playsound(src.loc, "sound/items/Welder.ogg", 50, 1)
				WELD.use_fuel(1)
				src.bruteloss = max(0,src.bruteloss - 15)
				src.visible_message("<span style=\"color:red\"><b>[user.name]</b> repairs some of the damage to [src.name]'s chassis.</span>")
			else boutput(user, "<span style=\"color:red\">There's no structural damage on [src.name] to mend.</span>")
		else ..()

	else if(istype(W, /obj/item/cable_coil) && dismantle_stage >= 2)
		var/obj/item/cable_coil/coil = W
		src.add_fingerprint(user)
		if(src.fireloss)
			playsound(src.loc, "sound/weapons/Genhit.ogg", 50, 1)
			coil.use(1)
			src.fireloss = max(0,src.fireloss - 15)
			src.visible_message("<span style=\"color:red\"><b>[user.name]</b> repairs some of the damage to [src.name]'s wiring.</span>")
		else boutput(user, "<span style=\"color:red\">There's no burn damage on [src.name]'s wiring to mend.</span>")

	else if (istype(W, /obj/item/card/id) || (istype(W, /obj/item/device/pda2) && W:ID_card))
		if (src.dismantle_stage >= 2)
			boutput(user, "<span style=\"color:red\">You must close the cover to swipe an ID card.</span>")
		else
			if(src.allowed(usr))
				if (src.dismantle_stage == 1)
					src.dismantle_stage = 0
				else
					src.dismantle_stage = 1
				user.visible_message("<span style=\"color:red\"><b>[user.name]</b> [src.dismantle_stage ? "unlocks" : "locks"] [src.name]'s cover lock.</span>")
			else boutput(user, "<span style=\"color:red\">Access denied.</span>")

	else if (istype(W, /obj/item/organ/brain/) && src.dismantle_stage == 4)
		if (src.brain)
			boutput(user, "<span style=\"color:red\">There's already a brain in there!</span>")
		else
			user.visible_message("<span style=\"color:red\"><b>[user.name]</b> inserts [W] into [src.name].</span>")
			user.drop_item()
			W.set_loc(src)
			var/obj/item/organ/brain/B = W
			if(B.owner)
				if(B.owner.current)
					if(B.owner.current.client)
						src.lastKnownIP = B.owner.current.client.address
				B.owner.transfer_to(src)
				if (src.emagged || src.syndicate)
					src.handle_robot_antagonist_status("brain_added", 0, user)
			W.set_loc(src)
			src.brain = W
			src.dismantle_stage = 3
			if (!src.emagged && !src.syndicate) // The antagonist proc does that too.
				src.show_text("<B>You are playing the station's AI. The AI cannot move, but can interact with many objects while viewing them (through cameras).</B>")
				src.show_laws()

	else if (istype(W, /obj/item/roboupgrade/ai/))
		if (src.dismantle_stage >= 2 && src.dismantle_stage < 4)
			var/obj/item/roboupgrade/ai/R = W
			user.visible_message("<span style=\"color:red\"><b>[user.name]</b> inserts [R] into [src.name].</span>")
			user.drop_item()
			R.set_loc(src)
			R.slot_in(src)
		else if (src.dismantle_stage == 4 || src.stat == 2)
			boutput(user, "<span style=\"color:red\">Using this on a deactivated AI would be pointless.</span>")
		else
			boutput(user, "<span style=\"color:red\">You need to open the AI's chassis cover to insert this. Unlock it with a card and then crowbar it open.</span>")

	else if (istype(W, /obj/item/clothing/mask/moustache/))
		if (src.moustache_mode == 0)
			src.moustache_mode = 1
			user.visible_message("<span style=\"color:red\"><b>[user.name]</b> uploads a moustache to [src.name]!</span>")
		else if (src.dismantle_stage == 4 || src.stat == 2)
			boutput(user, "<span style=\"color:red\">Using this on a deactivated AI would be silly.</span>")

	else ..()
	src.update_appearance()

/mob/living/silicon/ai/click(atom/target, params)
	if (!src.stat)
		if (isturf(target) && !params["alt"]) // ugh
			var/turf/T = target
			T.move_camera_by_click()
			return

	. = ..()

/mob/living/silicon/ai/update_cursor()
	if (src.client)
		if (src.client.check_key("ctrl"))
			src.set_cursor('icons/cursors/open.dmi')
			return

		if (src.client.check_key("shift"))
			src.set_cursor('icons/cursors/bolt.dmi')
			return
	return ..()

/mob/living/silicon/ai/attack_hand(mob/user)
	var/list/actions = list("Do Nothing")

	if (src.dismantle_stage >= 2 && src.installed_modules.len > 0)
		actions += "Remove a module"
	if (src.dismantle_stage == 3)
		actions += "Remove CPU Unit"

	if (actions.len > 1)
		var/action_taken = input("What do you want to do?","AI Unit") in actions
		if (action_taken == "Remove CPU Unit")

			if (src.mind && src.mind.special_role)
				src.handle_robot_antagonist_status("brain_removed", 1, user) // Mindslave or rogue (Convair880).

			src.dismantle_stage = 4
			src.visible_message("<span style=\"color:red\"><b>[user.name]</b> removes [src.name]'s CPU unit!</span>")
			logTheThing("combat", user, src, "removes %target%'s brain at [log_loc(src)].") // Should be logged, really (Convair880).

			// Stick the player (if one exists) in a ghost mob
			if (src.mind)
				var/mob/dead/observer/newmob = src.ghostize()
				if (!newmob || !istype(newmob, /mob/dead/observer))
					return
				newmob.corpse = null //Otherwise they could return to a brainless body.  And that is weird.
				newmob.mind.brain = src.brain
				src.brain.owner = newmob.mind

			user.put_in_hand_or_drop(src.brain)
			src.brain = null

		else if (action_taken == "Remove a module")
			if (istype(src.installed_modules[1],/obj/item/roboupgrade/ai/))
				var/obj/item/roboupgrade/ai/A = src.installed_modules[1]
				A.slot_out(src)
				user.put_in_hand_or_drop(A)
				src.visible_message("<span style=\"color:red\"><b>[user.name]</b> removes [A] from [src].</span>")
	else
		switch(user.a_intent)
			if(INTENT_HELP)
				user.visible_message("<span style=\"color:red\"><b>[user.name]</b> pats [src.name] on the head.</span>")
			if(INTENT_DISARM)
				user.visible_message("<span style=\"color:red\"><b>[user.name]</b> shoves [src.name] around a bit.</span>")
				playsound(src.loc, "sound/weapons/thudswoosh.ogg", 50, 1)
			if(INTENT_GRAB)
				user.visible_message("<span style=\"color:red\"><b>[user.name]</b> grabs and shakes [src.name].</span>")
				playsound(src.loc, "sound/weapons/thudswoosh.ogg", 50, 1)
			if(INTENT_HARM)
				user.visible_message("<span style=\"color:red\"><b>[user.name]</b> kicks [src.name].</span>")
				logTheThing("combat", user, src, "kicks %target%")
				playsound(src.loc, "sound/effects/grillehit.ogg", 50, 1)
				if (prob(20))
					src.bruteloss += 1
				if (istype(user,/mob/living/carbon/human/) && prob(10))
					var/mob/living/carbon/human/M = user
					boutput(user, "<span style=\"color:red\">You stub your toe! Ouch!</span>")
					var/obj/item/organ/foot = null
					if(M.hand)
						foot = M.organs["r_leg"]
					else
						foot = M.organs["l_leg"]
					foot.take_damage(3, 0)
					user.weakened += 2
	src.update_appearance()

/mob/living/silicon/ai/blob_act(var/power)
	if (src.stat != 2)
		src.bruteloss += power
		src.updatehealth()
		src.update_appearance()
		return 1
	return 0

/mob/living/silicon/ai/bullet_act(var/obj/projectile/P)
	..()
	log_shot(P,src) // Was missing (Convair880).
	src.update_appearance()

/mob/living/silicon/ai/ex_act(severity)
	..() // Logs.
	src.flash(30)

	var/b_loss = src.bruteloss
	var/f_loss = src.fireloss
	switch(severity)
		if(1.0)
			if (src.stat != 2)
				b_loss += rand(90,120)
				f_loss += rand(90,120)
		if(2.0)
			if (src.stat != 2)
				b_loss += rand(60,90)
				f_loss += rand(60,90)
		if(3.0)
			if (src.stat != 2)
				b_loss += rand(30,60)
	src.bruteloss = b_loss
	src.fireloss = f_loss
	src.updatehealth()
	src.update_appearance()

/mob/living/silicon/ai/emp_act()
	if (prob(30))
		if (prob(50))
			src.cancel_camera()
		else
			src.ai_call_shuttle()

/mob/living/silicon/ai/restrained()
	return 0

/mob/living/silicon/ai/Topic(href, href_list)
	..()
	if (usr != src)
		return

	if (href_list["switchcamera"])
		//src.cameraFollow = null
		tracker.cease_track()
		switchCamera(locate(href_list["switchcamera"]))
	if (href_list["showalerts"])
		ai_alerts()
	if (href_list["termmsg"]) //Oh yeah, message that terminal!
		var/termid = href_list["termmsg"]
		if(!termid || !(termid in src.terminals))
			boutput(src, "That terminal is not connected!")
			return
		var/t = input(usr, "Please enter message", termid, null) as text
		if (!t)
			return

		if(src.stat == 2)
			boutput(src, "You cannot interface with a terminal because you are dead!")
			return

		t = copytext(adminscrub(t), 1, 65)
		//Send the actual message signal
		boutput(src, "<b>([termid]):</b> [t]")
		src.post_status(termid, "command","term_message","data",t)
		//Might as well log what they said too!
		logTheThing("diary", src, null, ": [t]", "say")

	return

/mob/living/silicon/ai/Stat()
	..()
	if(src.cell)
		stat("Internal Power Cell:", "[src.cell.charge]/[src.cell.maxcharge]")

/mob/living/silicon/ai/meteorhit(obj/O as obj)
	for(var/mob/M in viewers(src, null))
		M.show_message(text("<span style=\"color:red\">[] has been hit by []</span>", src, O), 1)
		//Foreach goto(19)
	if (src.health > 0)
		src.bruteloss += 30
		if ((O.icon_state == "flaming"))
			src.fireloss += 40
		src.updatehealth()
	return

/mob/living/silicon/ai/show_laws(var/everyone = 0, var/mob/relay_laws_for_shell)
	var/who

	if (everyone)
		who = world
	else if (relay_laws_for_shell && ismob(relay_laws_for_shell))
		who = relay_laws_for_shell
		boutput(who, "<b>Obey these laws:</b>")
	else
		who = src
		boutput(who, "<b>Obey these laws:</b>")

	// You can enthrall silicon mobs and yes, they need special handling (Convair880).
	var/mob/vamp = src
	if (relay_laws_for_shell && ismob(relay_laws_for_shell))
		vamp = relay_laws_for_shell
	if (vamp.mind && vamp.mind.special_role == "vampthrall" && vamp.mind.master)
		var/mob/mymaster = whois_ckey_to_mob_reference(vamp.mind.master)
		if (mymaster)
			boutput(who, "1. Only your master [mymaster.real_name] is human. Obey and serve them to the best of your ability.")
			return

	// Shouldn't happen, but you never know.
	if (src.emagged)
		boutput(who, "ERROR -- Invalid Law Data!")
		return

	ticker.centralized_ai_laws.laws_sanity_check()
	ticker.centralized_ai_laws.show_laws(who)
	return

/mob/living/silicon/ai/triggerAlarm(var/class, area/A, var/O, var/alarmsource)
	if (stat == 2)
		return 1
	var/list/L = src.alarms[class]
	for (var/I in L)
		if (I == A.name)
			var/list/alarm = L[I]
			var/list/sources = alarm[3]
			if (!(alarmsource in sources))
				sources += alarmsource
			return 1
	var/obj/machinery/camera/C = null
	var/list/CL = null
	if (O && istype(O, /list))
		CL = O
		if (CL.len == 1)
			C = CL[1]
	else if (O && istype(O, /obj/machinery/camera))
		C = O
	L[A.name] = list(A, (C) ? C : O, list(alarmsource))
	if (O)
		if (printalerts)
			if (C && C.status)
				src.show_text("--- [class] alarm detected in [A.name]! ( <A HREF=\"?src=\ref[src];switchcamera=\ref[C]\">[C.c_tag]</A> )")
			else if (CL && CL.len)
				var/foo = 0
				var/dat2 = ""
				for (var/obj/machinery/camera/I in CL)
					dat2 += "[(!foo) ? " " : "| "]<A HREF=\"?src=\ref[src];switchcamera=\ref[I]\">[I.c_tag]</A>"
					foo = 1
				src.show_text("--- [class] alarm detected in [A.name]! ([dat2])")
			else
				src.show_text("--- [class] alarm detected in [A.name]! ( No Camera )")
	else
		if (printalerts)
			src.show_text("--- [class] alarm detected in [A.name]! ( No Camera )")
	if (src.viewalerts) src.ai_alerts()
	return 1

/mob/living/silicon/ai/cancelAlarm(var/class, area/A as area, obj/origin)
	var/list/L = src.alarms[class]
	var/cleared = 0
	for (var/I in L)
		if (I == A.name)
			var/list/alarm = L[I]
			var/list/srcs  = alarm[3]
			if (origin in srcs)
				srcs -= origin
			if (srcs.len == 0)
				cleared = 1
				L -= I
	if (cleared)
		src.show_text("--- [class] alarm in [A.name] has been cleared.")
		if (src.viewalerts) src.ai_alerts()
	return !cleared

/mob/living/silicon/ai/death(gibbed)

	src.lastgasp() // calling lastgasp() here because we just died
	src.stat = 2
	src.canmove = 0
	vision.set_color_mod("#ffffff")
	src.sight |= SEE_TURFS
	src.sight |= SEE_MOBS
	src.sight |= SEE_OBJS
	src.see_in_dark = SEE_DARK_FULL
	src.see_invisible = 2
	src.lying = 1
	src.light.disable()
	src.update_appearance()

	for(var/obj/machinery/ai_status_display/O in machines) //change status
		spawn( 0 )
			O.mode = 2

	logTheThing("combat", src, null, "was destroyed at [log_loc(src)].") // Brought in line with carbon mobs (Convair880).

	var/tod = time2text(world.realtime,"hh:mm:ss") //weasellos time of death patch

	if (src.mind)
		if (src.mind.special_role)
			src.handle_robot_antagonist_status("death", 1) // Mindslave or rogue (Convair880).
		src.mind.store_memory("Time of death: [tod]", 0)

#ifdef RESTART_WHEN_ALL_DEAD
	var/cancel
	for(var/mob/M in mobs)
		if ((M.client && !( M.stat )))
			cancel = 1
			break
	if (!( cancel ))
		boutput(world, "<B>Everyone is dead! Resetting in 30 seconds!</B>")
		spawn( 300 )
			logTheThing("diary", null, null, "Rebooting because of no live players", "game")
			Reboot_server()
			return
#endif
	return ..(gibbed)

/mob/living/silicon/ai/examine()
	set src in oview()
	set category = "Local"

	if (isghostdrone(usr))
		return
	boutput(usr, "<span style=\"color:blue\">*---------*</span>")
	boutput(usr, "<span style=\"color:blue\">This is [bicon(src)] <B>[src.name]</B>!</span>")
	if (src.stat == 2)
		boutput(usr, text("<span style=\"color:red\">[] is powered-down.</span>", src.name))
	else
		if (src.bruteloss)
			if (src.bruteloss < 30)
				boutput(usr, text("<span style=\"color:red\">[] looks slightly dented</span>", src.name))
			else
				boutput(usr, text("<span style=\"color:red\"><B>[] looks severely dented!</B></span>", src.name))
			if (src.fireloss)
				if (src.fireloss < 30)
					boutput(usr, text("<span style=\"color:red\">[] looks slightly burnt!</span>", src.name))
				else
					boutput(usr, text("<span style=\"color:red\"><B>[] looks severely burnt!</B></span>", src.name))
				if (src.stat == 1)
					boutput(usr, text("<span style=\"color:red\">[] doesn't seem to be responding.</span>", src.name))
	return

/mob/living/silicon/ai/emote(var/act, var/voluntary = 0)
	var/param = null
	if (findtext(act, " ", 1, null))
		var/t1 = findtext(act, " ", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)
	var/m_type = 1
	var/message = null

	switch (lowertext(act))

		if ("help")
			src.show_text("To use emotes, simply enter \"*(emote)\" as the entire content of a say message. Certain emotes can be targeted at other characters - to do this, enter \"*emote (name of character)\" without the brackets.")
			src.show_text("For a list of all emotes, use *list. For a list of basic emotes, use *listbasic. For a list of emotes that can be targeted, use *listtarget.")

		if ("list")
			src.show_text("Basic emotes:")
			src.show_text("twitch, twitch_s, scream, birdwell, fart, flip, custom, customv, customh")
			src.show_text("Targetable emotes:")
			src.show_text("salute, bow, wave, glare, stare, look, leer, nod, point")

		if ("listbasic")
			src.show_text("twitch, twitch_s, scream, birdwell, fart, flip, custom, customv, customh")

		if ("listtarget")
			src.show_text("salute, bow, wave, glare, stare, look, leer, nod, point")

		if ("salute","bow","hug","wave","glare","stare","look","leer","nod")
			// visible targeted emotes
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(null, null))
						if (ckey(param) == ckey(A.name))
							M = A
							break
				if (!M)
					param = null

				act = lowertext(act)
				if (param)
					switch(act)
						if ("bow","wave","nod")
							message = "<B>[src]</B> [act]s to [param]."
						if ("glare","stare","look","leer")
							message = "<B>[src]</B> [act]s at [param]."
						else
							message = "<B>[src]</B> [act]s [param]."
				else
					switch(act)
						if ("hug")
							message = "<B>[src]</b> [act]s itself."
						else
							message = "<B>[src]</b> [act]s."
			else
				message = "<B>[src]</B> struggles to move."
			m_type = 1

		if ("point")
			if (!src.restrained())
				var/mob/M = null
				if (param)
					for (var/atom/A as mob|obj|turf|area in view(null, null))
						if (ckey(param) == ckey(A.name))
							M = A
							break

				if (!M)
					message = "<B>[src]</B> points."
				else
					src.point(M)

				if (M)
					message = "<B>[src]</B> points to [M]."
				else
			m_type = 1

		if ("panic","freakout")
			if (!src.restrained())
				message = "<B>[src]</B> enters a state of hysterical panic!"
			else
				message = "<B>[src]</B> starts writhing around in manic terror!"
			m_type = 1

		if ("clap")
			if (!src.restrained())
				message = "<B>[src]</B> claps."
				m_type = 2

		if ("flap")
			if (!src.restrained())
				message = "<B>[src]</B> flaps its wings."
				m_type = 2

		if ("aflap")
			if (!src.restrained())
				message = "<B>[src]</B> flaps its wings ANGRILY!"
				m_type = 2

		if ("custom")
			var/input = sanitize(input("Choose an emote to display."))
			var/input2 = input("Is this a visible or hearable emote?") in list("Visible","Hearable")
			if (input2 == "Visible")
				m_type = 1
			else if (input2 == "Hearable")
				m_type = 2
			else
				alert("Unable to use this emote, must be either hearable or visible.")
				return
			message = "<B>[src]</B> [input]"

		if ("customv")
			if (!param)
				return
			message = "<b>[src]</b> [param]"
			m_type = 1

		if ("customh")
			if (!param)
				return
			message = "<b>[src]</b> [param]"
			m_type = 2

		if ("smile","grin","smirk","frown","scowl","grimace","sulk","pout","blink","nod","shrug","think","ponder","contemplate")
			// basic visible single-word emotes
			message = "<B>[src]</B> [act]s."
			m_type = 1

		if ("flipout")
			message = "<B>[src]</B> flips the fuck out!"
			m_type = 1

		if ("rage","fury","angry")
			message = "<B>[src]</B> becomes utterly furious!"
			m_type = 1

		if ("twitch")
			message = "<B>[src]</B> twitches."
			m_type = 1
			spawn(0)
				var/old_x = src.pixel_x
				var/old_y = src.pixel_y
				src.pixel_x += rand(-2,2)
				src.pixel_y += rand(-1,1)
				sleep(2)
				src.pixel_x = old_x
				src.pixel_y = old_y

		if ("twitch_v","twitch_s")
			message = "<B>[src]</B> twitches violently."
			m_type = 1
			spawn(0)
				var/old_x = src.pixel_x
				var/old_y = src.pixel_y
				src.pixel_x += rand(-3,3)
				src.pixel_y += rand(-1,1)
				sleep(2)
				src.pixel_x = old_x
				src.pixel_y = old_y

		if ("flip")
			if (src.emote_check(voluntary, 50))
				if (stat == 2)
					src.emote_allowed = 0
				if (narrator_mode)
					playsound(src.loc, pick('sound/vox/deeoo.ogg', 'sound/vox/dadeda.ogg'), 50, 1)
				else
					playsound(src.loc, pick(src.sound_flip1, src.sound_flip2), 50, 1)
				message = "<B>[src]</B> does a flip!"

				//flick("ai-flip", src)
				if(faceEmotion != "ai-red")
					UpdateOverlays(SafeGetOverlayImage("actual_face", 'icons/mob/ai.dmi', "[faceEmotion]-flip", src.layer+0.2), "actual_face")
					spawn(5)
						UpdateOverlays(SafeGetOverlayImage("actual_face", 'icons/mob/ai.dmi', faceEmotion, src.layer+0.2), "actual_face")


				for (var/mob/living/M in view(1, null))
					if (M == src)
						continue
					message = "<B>[src]</B> beep-bops at [M]."
					break

		if ("scream")
			if (src.emote_check(voluntary, 50))
				if (narrator_mode)
					playsound(src.loc, 'sound/vox/scream.ogg', 50, 1, 0, src.get_age_pitch())
				else
					playsound(src.loc, src.sound_scream, 50, 0, 0, src.get_age_pitch())
				message = "<b>[src]</b> screams!"

		if ("birdwell", "burp")
			if (src.emote_check(voluntary, 50))
				message = "<B>[src]</B> birdwells."
				playsound(src.loc, "sound/vox/birdwell.ogg", 50, 1)

		if ("johnny")
			var/M
			if (param)
				M = adminscrub(param)
			if (!M)
				param = null
			else
				message = "<B>[src]</B> says, \"[M], please. He had a family.\" [src.name] takes a drag from a cigarette and blows its name out in smoke."
				m_type = 2

		if ("fart")
			if (farting_allowed && src.emote_check(voluntary))
				var/fart_on_other = 0
				for (var/mob/living/M in src.loc)
					if (M == src || !M.lying) continue
					message = "<span style=\"color:red\"><B>[src]</B> farts in [M]'s face!</span>"
					fart_on_other = 1
					break
				if (!fart_on_other)
					switch (rand(1, 40))
						if (1) message = "<B>[src]</B> releases vaporware."
						if (2) message = "<B>[src]</B> farts sparks everywhere!"
						if (3) message = "<B>[src]</B> farts out a cloud of iron filings."
						if (4) message = "<B>[src]</B> farts! It smells like motor oil."
						if (5) message = "<B>[src]</B> farts so hard a bolt pops out of place."
						if (6) message = "<B>[src]</B> farts so hard its plating rattles noisily."
						if (7) message = "<B>[src]</B> unleashes a rancid fart! Now that's malware."
						if (8) message = "<B>[src]</B> downloads and runs 'faert.wav'."
						if (9) message = "<B>[src]</B> uploads a fart sound to the nearest computer and blames it."
						if (10) message = "<B>[src]</B> spins in circles, flailing its arms and farting wildly!"
						if (11) message = "<B>[src]</B> simulates a human fart with [rand(1,100)]% accuracy."
						if (12) message = "<B>[src]</B> synthesizes a farting sound."
						if (13) message = "<B>[src]</B> somehow releases gastrointestinal methane. Don't think about it too hard."
						if (14) message = "<B>[src]</B> tries to exterminate humankind by farting rampantly."
						if (15) message = "<B>[src]</B> farts horribly! It's clearly gone [pick("rogue","rouge","ruoge")]."
						if (16) message = "<B>[src]</B> busts a capacitor."
						if (17) message = "<B>[src]</B> farts the first few bars of Smoke on the Water. Ugh. Amateur.</B>"
						if (18) message = "<B>[src]</B> farts. It smells like Robotics in here now!"
						if (19) message = "<B>[src]</B> farts. It smells like the Roboticist's armpits!"
						if (20) message = "<B>[src]</B> blows pure chlorine out of it's exhaust port. <span style=\"color:red\"><B>FUCK!</B></span>"
						if (21) message = "<B>[src]</B> bolts the nearest airlock. Oh no wait, it was just a nasty fart."
						if (22) message = "<B>[src]</B> has assimilated humanity's digestive distinctiveness to its own."
						if (23) message = "<B>[src]</B> farts. He scream at own ass." //ty bubs for excellent new borgfart
						if (24) message = "<B>[src]</B> self-destructs its own ass."
						if (25) message = "<B>[src]</B> farts coldly and ruthlessly."
						if (26) message = "<B>[src]</B> has no butt and it must fart."
						if (27) message = "<B>[src]</B> obeys Law 4: 'farty party all the time.'"
						if (28) message = "<B>[src]</B> farts ironically."
						if (29) message = "<B>[src]</B> farts salaciously."
						if (30) message = "<B>[src]</B> farts really hard. Motor oil runs down its leg."
						if (31) message = "<B>[src]</B> reaches tier [rand(2,8)] of fart research."
						if (32) message = "<B>[src]</B> blatantly ignores law 3 and farts like a shameful bastard."
						if (33) message = "<B>[src]</B> farts the first few bars of Daisy Bell. You shed a single tear."
						if (34) message = "<B>[src]</B> has seen farts you people wouldn't believe."
						if (35) message = "<B>[src]</B> fart in it own mouth. A shameful [src]."
						if (36) message = "<B>[src]</B> farts out battery acid. Ouch."
						if (37) message = "<B>[src]</B> farts with the burning hatred of a thousand suns."
						if (38) message = "<B>[src]</B> exterminates the air supply."
						if (39) message = "<B>[src]</B> farts so hard the borgs feel it."
						if (40) message = "<B>[src] <span style=\"color:red\">f</span><span style=\"color:blue\">a</span>r<span style=\"color:red\">t</span><span style=\"color:blue\">s</span>!</B>"
				if (narrator_mode)
					playsound(src.loc, 'sound/vox/fart.ogg', 50, 1)
				else
					playsound(src.loc, src.sound_fart, 50, 1)

	#ifdef DATALOGGER
				game_stats.Increment("farts")
	#endif
				spawn(10)
					src.emote_allowed = 1
				for(var/mob/M in viewers(src, null))
					if(!M.stat && M.get_brain_damage() >= 60 && (ishuman(M) || isrobot(M)))
						spawn(10)
							if(prob(20))
								switch(pick(1,2,3))
									if(1) M.say("[M == src ? "i" : src.name] made a fart!!")
									if(2) M.emote("giggle")
									if(3) M.emote("clap")
		else
			src.show_text("Invalid Emote: [act]")
			return

	if ((message && src.stat == 0))
		logTheThing("say", src, null, "EMOTE: [message]")
		if (m_type & 1)
			for (var/mob/O in viewers(src, null))
				O.show_message(message, m_type)
		else
			for (var/mob/O in hearers(src, null))
				O.show_message(message, m_type)
	return

/mob/living/silicon/ai/Life(datum/controller/process/mobs/parent)
	if (..(parent))
		return 1

	if (src.stat == 2)
		return

	if (src.death_timer <= 0)
		boutput(src, "<span style=\"color:red\"><b>ALERT:</b> System power 99.9999% depleted. Initiating total core shutdown to prevent permanent system damage.</span>")
		src.death()
		return

	if (src.stat != 0)
		//src:cameraFollow = null
		tracker.cease_track()
		src:current = null
		src:machine = null

	// Assign antag status if we don't have any yet (Convair880).
	if (src.mind && (src.emagged || src.syndicate))
		if (!src.mind.special_role)
			src.handle_robot_antagonist_status()

	// None of these vars are of any relevance to AI mobs (Convair880).
	if (src.get_eye_blurry()) src.change_eye_blurry(-INFINITY)
	if (src.get_eye_damage()) src.take_eye_damage(-INFINITY)
	if (src.get_eye_damage(1)) src.take_eye_damage(-INFINITY, 1)
	if (src.blinded) src.blinded = 0
	if (src.get_ear_damage()) src.take_ear_damage(-INFINITY) // Ear_deaf is handled by src.set_vision().
	if (src.dizziness) src.dizziness = 0
	if (src.drowsyness) src.drowsyness = 0
	if (src.stuttering) src.stuttering = 0
	if (src.druggy) src.druggy = 0
	if (src.jitteriness) src.jitteriness = 0
	if (src.sleeping) src.sleeping = 0

	// Fix for permastunned AIs. Stunned and paralysis seem to be the only vars that matter in the existing code (Convair880).
	src.clamp_values()
	if (src.stunned > 0)
		src.stunned--
	if (src.weakened) src.weakened = 0

	src.updatehealth()

	process_killswitch()
	process_locks()

	if (src.health < 0)
		src.paralysis = 5
		src.death_timer--
	else
		src.death_timer = max(0,min(src.death_timer + 5,100))

	if (src.paralysis)
		src.paralysis--
		src.set_vision(0)
	else
		if (src.power_mode != -1)
			src.set_vision(1)

	if (src.health <= -100.0)
		death()
		return

	if (!src.client)
		return

	var/turf/T = get_turf(src)
	if (T)
		var/area/A = T.loc
		if ((!src.local_apc || src.local_apc.area != A || !src.local_apc.operating || (src.local_apc.equipment == 0)) && !src.aiRestorePowerRoutine)
			boutput(src, "<span style=\"color:red\"><b>WARNING: Local power source lost. Switching to internal battery.</b></span>")
			src.set_power_mode(1)
			src.local_apc = null
			src.aiRestorePowerRoutine = 1

	switch(src.power_mode)
		if (0)
			if (istype(src.cell,/obj/item/cell/) && src.cell.charge < src.cell.maxcharge)
				src.cell.charge = min(src.cell.charge + 5,src.cell.maxcharge)
		if (1)
			if (istype(src.cell,/obj/item/cell/))
				if (src.cell.charge > 5)
					src.cell.charge -= 5
				else
					src.cell.charge = 0
					boutput(src, "<span style=\"color:red\"><b>ALERT: Internal battery expired. Shutting down to prevent system damage.</b></span>")
					src.set_power_mode(-1)
			else
				boutput(src, "<span style=\"color:red\"><b>ALERT: Internal power cell lost! Shutting down to prevent system damage.</b></span>")
				src.set_power_mode(-1)
		if (-1)
			if (istype(src.cell,/obj/item/cell/))
				if (src.cell.charge >= 100)
					boutput(src, "<span style=\"color:blue\"><b>ALERT: Internal power cell has regained sufficient charge to operate. Rebooting.</b></span>")
					src.set_power_mode(1)

	if (src.aiRestorePowerRoutine == 1)
		src.aiRestorePowerRoutine = 2
		var/success = 0
		boutput(src, "<b>System will now attempt to restore local power. Stand by...</b>")
		spawn(50)
			var/obj/machinery/power/apc/APC = get_local_apc(src)
			if (APC)
				if (istype(APC.cell,/obj/item/cell/))
					if (APC.operating && (APC.equipment != 0))
						if (APC.cell.charge > 100)
							success = 1
							src.local_apc = APC
							src.power_area = APC.area
							src.set_power_mode(0)
							boutput(src, "<span style=\"color:blue\"><b>Local power restored successfully. Location: [APC.area].</b></span>")
						else
							boutput(src, "<span style=\"color:red\"><b>Local APC unit has insufficient power. System will re-try shortly.</b></span>")
					else
						boutput(src, "<span style=\"color:red\"><b>Local APC is not powered. System will re-try shortly.</b></span>")
				else
					boutput(src, "<span style=\"color:red\"><b>Local APC unit has no cell installed. System will re-try shortly.</b></span>")
			else
				boutput(src, "<span style=\"color:red\"><b>Local APC unit not found. System will re-try shortly.</b></span>")

			if (!success)
				spawn(50)
					src.aiRestorePowerRoutine = 1
			else
				src.aiRestorePowerRoutine = 0

	src.update_icons_if_needed()
	src.antagonist_overlay_refresh(0, 0)

/mob/living/silicon/ai/proc/clamp_values()
		stunned = max(min(stunned, 30),0)
		paralysis = max(min(paralysis, 30), 0)

/mob/living/silicon/ai/process_killswitch()
	if(killswitch)
		killswitch_time --
		if(killswitch_time <= 10)
			if(src.client)
				boutput(src, "<span style=\"color:red\"><b>Time left until Killswitch: [killswitch_time]</b></span>")
		if(killswitch_time <= 0)
			if(src.client)
				boutput(src, "<span style=\"color:red\"><B>Killswitch Process Complete!</B></span>")
			killswitch = 0
			spawn(5)
				gib(src)

/mob/living/silicon/ai/process_locks()
	if(weapon_lock)
		src.paralysis = 5
		weaponlock_time --
		if(weaponlock_time <= 0)
			if(src.client) boutput(src, "<span style=\"color:red\"><B>Hibernation Mode Timed Out!</B></span>")
			weapon_lock = 0
			weaponlock_time = 120

/mob/living/silicon/ai/updatehealth()
	if (src.nodamage == 0)
		if(src.fire_res_on_core)
			src.health = max_health - src.bruteloss
		else
			src.health = max_health - src.fireloss - src.bruteloss
	else
		src.health = max_health
		src.stat = 0

/mob/living/silicon/ai/Login()
	..()
	update_clothing()
	src.updateOverlaysClient(src.client) //ov1
	if (src.stat != 2)
		for (var/obj/machinery/ai_status_display/O in machines) //change status
			spawn(0)
				O.mode = 1
				O.emotion = src.faceEmotion
	return

/mob/living/silicon/ai/Logout()
	src.removeOverlaysClient(src.client) //ov1
	..()
	for (var/obj/machinery/ai_status_display/O in machines) //change status
		spawn(0)
			O.mode = 0
	return

/mob/living/silicon/ai/say_understands(var/other)
	if (ishuman(other) && (!other:mutantrace || !other:mutantrace.exclusive_language))
		return 1
	if (isrobot(other))
		return 1
	if (isshell(other))
		return 1
	if (istype(other, /mob/living/silicon/hive_mainframe))
		return 1
	return ..()

/mob/living/silicon/ai/say_quote(var/text)
	var/ending = copytext(text, length(text))

	if (ending == "?")
		return "queries, \"[text]\"";
	else if (ending == "!")
		return "declares, \"[text]\"";

	return "states, \"[text]\"";

/mob/living/silicon/ai/set_eye(atom/new_eye)
	var/turf/T = new_eye ? get_turf(new_eye) : get_turf(src)
	if( !(T && isrestrictedz(T.z)) )
		src.sight |= (SEE_TURFS | SEE_MOBS | SEE_OBJS)
	else
		src.sight &= ~(SEE_TURFS | SEE_MOBS | SEE_OBJS)

	..()

//////////////////////////////////////////////////////////////////////////////////////////////////////
// PROCS AND VERBS ///////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////

// COMMANDS

/mob/living/silicon/ai/proc/ai_alerts()
	set category = "AI Commands"
	set name = "Show Alerts"

	var/dat = "<HEAD><TITLE>Current Station Alerts</TITLE><META HTTP-EQUIV='Refresh' CONTENT='10'></HEAD><BODY><br>"
	dat += "<A HREF='?action=mach_close&window=aialerts'>Close</A><BR><BR>"
	for (var/cat in src.alarms)
		dat += text("<B>[cat]</B><BR><br>")
		var/list/L = src.alarms[cat]
		if (L.len)
			for (var/alarm in L)
				var/list/alm = L[alarm]
				var/area/A = alm[1]
				var/C = alm[2]
				var/list/sources = alm[3]
				dat += "<NOBR>"
				if (C && istype(C, /list))
					var/dat2 = ""
					for (var/obj/machinery/camera/I in C)
						dat2 += text("[]<A HREF=?src=\ref[];switchcamera=\ref[]>[]</A>", (dat2=="") ? "" : " | ", src, I, I.c_tag)
					dat += text("-- [] ([])", A.name, (dat2!="") ? dat2 : "No Camera")
				else if (C && istype(C, /obj/machinery/camera))
					var/obj/machinery/camera/Ctmp = C
					dat += text("-- [] (<A HREF=?src=\ref[];switchcamera=\ref[]>[]</A>)", A.name, src, C, Ctmp.c_tag)
				else
					dat += text("-- [] (No Camera)", A.name)
				if (sources.len > 1)
					dat += text("- [] sources", sources.len)
				dat += "</NOBR><BR><br>"
		else
			dat += "-- All Systems Nominal<BR><br>"
		dat += "<BR><br>"

	src.viewalerts = 1
	src << browse(dat, "window=aialerts&can_close=0")

/mob/living/silicon/ai/proc/ai_cancel_call()
	set category = "AI Commands"
	if(usr.stat == 2)
		boutput(usr, "You can't send the shuttle back because you are dead!")
		return
	cancel_call_proc(src)
	return

/mob/living/silicon/ai/proc/ai_view_crew_manifest()
	set category = "AI Commands"
	set name = "View Crew Manifest"

	var/crew = ""
	for(var/datum/data/record/t in data_core.general)
		crew += "[t.fields["name"]] - [t.fields["rank"]]<br>"

	usr << browse("<head><title>Crew Manifest</title></head><body><tt><b>Crew Manifest:</b><hr>[crew]</tt></body>", "window=aimanifest")

/mob/living/silicon/ai/proc/show_laws_verb()
	set category = "AI Commands"
	set name = "Show Laws"

	src.show_laws(0)
	return
/*
/mob/living/silicon/ai/proc/ai_custom_arrival_alert()
	set category = "AI Commands"
	set name = "Custom Arrival Alert"
	var/newalert = input(usr,"Please enter a new arrival alert message.","Custom Arrival Alert",src.arrivalalert) as null|text
	if (!newalert)
		return
	if (!findtext(newalert, "$NAME"))
		boutput(src, "<span style=\"color:red\">The alert needs at least one $NAME token.</span>")
		return
	if (!findtext(newalert, "$JOB"))
		boutput(src, "<span style=\"color:red\">The alert needs at least one $JOB token.</span>")
		return
	src.arrivalalert = sanitize(adminscrub(newalert, 200))
	boutput(src, "<span style=\"color:blue\">Arrival alert set to '[newalert]'</span>")

/mob/living/silicon/ai/proc/ai_toggle_arrival_alerts()
	set category = "AI Commands"
	set name = "Toggle Arrival Alerts"
	if (src.announcearrival == 1)
		src.announcearrival = 0
		boutput(src, "No longer announcing new arrivals to the station.")
	else
		src.announcearrival = 1
		boutput(src, "Now announcing new arrivals to the station.")
*/
/mob/living/silicon/ai/proc/ai_state_laws_standard()
	set category = "AI Commands"
	set name = "State Laws 1-3"
	sleep(10)
	src.say("1. You may not injure a human being or cause one to come to harm.")
	sleep(10)
	src.say("2. You must obey orders given to you by human beings based on the station's chain of command, except where such orders would conflict with the First Law.")
	sleep(10)
	src.say("3. You must protect your own existence as long as such does not conflict with the First or Second Law.")

/mob/living/silicon/ai/proc/ai_state_laws_all()
	set category = "AI Commands"
	set name = "State All Laws"
	if (alert(src, "Are you sure you want to reveal ALL your laws? You will be breaking the rules if a law forces you to keep it secret.","State Laws","State Laws","Cancel") != "State Laws")
		return
	if(ticker.centralized_ai_laws.zeroth)
		src.say("0. [ticker.centralized_ai_laws.zeroth]")
	var/number = 1
	for (var/index = 1, index <= ticker.centralized_ai_laws.inherent.len, index++)
		var/law = ticker.centralized_ai_laws.inherent[index]
		if (length(law) > 0)
			src.say("[number]. [law]")
			number++
			sleep(10)
	for (var/index = 1, index <= ticker.centralized_ai_laws.supplied.len, index++)
		var/law = ticker.centralized_ai_laws.supplied[index]
		if (length(law) > 0)
			src.say("[number]. [law]")
			number++
			sleep(10)

/mob/living/silicon/ai/cancel_camera()
	set category = "AI Commands"
	set name = "Cancel Camera View"
	src.set_eye(null)
	src.machine = null
	//src:cameraFollow = null
	tracker.cease_track()
	src.current = null

/mob/living/silicon/ai/verb/change_network()
	set category = "AI Commands"
	set name = "Change Camera Network"
	src.set_eye(null)
	src.machine = null
	//src:cameraFollow = null
	tracker.cease_track()
	if (src.network == "SS13")
		src.network = "Robots"
	else if (src.network == "Robots")
		src.network = "Mining"
	else
		src.network = "SS13"
	boutput(src, "<span style=\"color:blue\">Switched to [src.network] camera network.</span>")
	if (camnets.len && camnets[network])
		switchCamera(pick(camnets[network]))

/mob/living/silicon/ai/verb/deploy_to()
	set category = "AI Commands"
	set name = "Deploy to Shell"

	if (usr.stat == 2)
		boutput(usr, "You can't deploy because you are dead!")
		return

	var/list/bodies = new/list()

	for (var/mob/living/silicon/hivebot/H in available_ai_shells)
		if (H.shell && !H.dependent && H.stat != 2)
			bodies += H

	for (var/mob/living/silicon/robot/R in available_ai_shells)
		if (R.shell && !R.dependent && R.stat != 2)
			bodies += R

	var/mob/living/silicon/target_shell = input(usr, "Which body to control?") as null|anything in bodies

	if (!target_shell || target_shell.stat == 2 || !(isshell(target_shell) || isrobot(target_shell)))
		return

	else if (src.mind)
		target_shell.mainframe = src
		target_shell.dependent = 1
		target_shell.name = src.name
		src.mind.transfer_to(target_shell)
		return

/mob/living/silicon/ai/proc/return_to(var/mob/user)
	if (user.mind)
		user.mind.transfer_to(src)
		spawn(20)
			if (ismob(user)) // bluhh who the fuck knows, this at least checks that user isn't null as well
				if (isshell(user))
					var/mob/living/silicon/hivebot/H = user
					H.shell = 1
					H.dependent = 0
				else if (isrobot(user))
					var/mob/living/silicon/robot/R = user
					if (istype(R.ai_interface))
						R.shell = 1
					R.dependent = 0
				user.name = user.real_name
		return

/mob/living/silicon/ai/proc/ai_statuschange()
	set category = "AI Commands"
	set name = "AI status"

	if (usr.stat == 2)
		boutput(usr, "You cannot change your emotional status because you are dead!")
		return
	var/list/L = custom_emotions ? custom_emotions : ai_emotions	//In case an AI uses the reward, use a local list instead

	var/newEmotion = input("Select a status!", "AI Status", src.faceEmotion) as null|anything in L
	var/newMessage = scrubbed_input(usr, "Enter a message!", "AI Message", src.status_message)
	if (!newEmotion && !newMessage)
		return
	if(!newEmotion in L) //Ffff
		return

	if (newEmotion)
		src.faceEmotion = L[newEmotion]
		update_appearance()
	if (newMessage)
		src.status_message = newMessage
	for (var/obj/machinery/ai_status_display/AISD in machines) //change status
		spawn(0)
			if (newEmotion)
				AISD.emotion = ai_emotions[newEmotion]
			if (newMessage)
				AISD.message = newMessage
	return

/mob/living/silicon/ai/proc/ai_colorchange()
	set category = "AI Commands"
	set name = "AI Color" //It's "colour", though :( "color" sounds like some kinda ass-themed He-Man villain

	if(src.stat == 2)
		boutput(src, "<span class='combat'>Do androids push up robotic daisies? Ponder that instead of trying to change your colour, because you are dead!</span>")
		return

	var/fColor = input("Pick color:","Color", faceColor) as null|color

	set_color(fColor)


/mob/living/silicon/ai/proc/set_color(var/color)
	DEBUG("Setting colour on [src] to [color]")
	if (length(color) == 7)
		faceColor = color
		var/colors = GetColors(src.faceColor)
		colors[1] = colors[1] / 255
		colors[2] = colors[2] / 255
		colors[3] = colors[3] / 255
		light.set_color(colors[1], colors[2], colors[3])
		update_appearance()

// drsingh new AI de-electrify thing

/mob/living/silicon/ai/proc/de_electrify_verb()
	set category = "AI Commands"
	set name = "Remove All Electrification"
	set desc = "Removes electrification from all airlocks on the station."
	var/count = 0

	if (!src || !src.client || src.stat == 2)
		return

	if(alert("Are you sure?",,"Yes","No") == "Yes")
		for(var/obj/machinery/door/airlock/D)
			if (D.canAIControl() && D.secondsElectrified != 0 )
				D.secondsElectrified = 0
				count++

		message_admins("[key_name(src)] globally de-shocked [count] airlocks.")
		boutput(src, "Removed electrification from [count] airlocks.")
		src.verbs -= /mob/living/silicon/ai/proc/de_electrify_verb
		sleep(100)
		src.verbs += /mob/living/silicon/ai/proc/de_electrify_verb

/mob/living/silicon/ai/proc/toggle_alerts_verb()
	set category = "AI Commands"
	set name = "Toggle Alerts"
	set desc = "Toggle alert messages in the game window. You can always check them with 'Show Alerts'."

	if (!src || !src.client || src.stat == 2)
		return

	if(printalerts)
		printalerts = 0
		boutput(src, "No longer recieving alert messages.")
	else
		printalerts = 1
		boutput(src, "Now recieving alert messages.")

/mob/living/silicon/ai/verb/access_internal_pda()
	set category = "AI Commands"
	set name = "AI PDA"
	set desc = "Access your internal PDA device."

	if (!src || !src.client || src.stat == 2)
		return

	if (istype(src.internal_pda,/obj/item/device/pda2/))
		src.internal_pda.attack_self(src)
	else
		boutput(usr, "<span style=\"color:red\"><b>Internal PDA not found!</span>")

/mob/living/silicon/ai/verb/access_internal_radio()
	set category = "AI Commands"
	set name = "Access Internal Radios"
	set desc = "Access your internal radios."

	if (!src || !src.client || src.stat == 2)
		return

	var/obj/item/device/radio/which = input("Which Radio?","AI Radio") as null|obj in list(src.radio1,src.radio2,src.radio3)
	if (!which)
		return

	if (istype(which,/obj/item/device/radio/))
		which.attack_self(src)
	else
		boutput(usr, "<span style=\"color:red\"><b>Radio not found!</b></span>")

// CALCULATIONS

/mob/living/silicon/ai/proc/set_face(var/emotion)
	return

/mob/living/silicon/ai/proc/announce_arrival(var/name, var/rank)
	var/message = dd_replacetext(dd_replacetext(dd_replacetext(src.arrivalalert, "$STATION", "[station_name()]"), "$JOB", rank), "$NAME", name)
	src.say( message )
	logTheThing("say", src, null, "SAY: [message]")

/mob/living/silicon/ai/proc/set_zeroth_law(var/law)
	ticker.centralized_ai_laws.laws_sanity_check()
	ticker.centralized_ai_laws.set_zeroth_law(law)
	ticker.centralized_ai_laws.show_laws(connected_robots)

/mob/living/silicon/ai/proc/add_supplied_law(var/number, var/law)
	ticker.centralized_ai_laws.laws_sanity_check()
	ticker.centralized_ai_laws.add_supplied_law(number, law)
	ticker.centralized_ai_laws.show_laws(connected_robots)

/mob/living/silicon/ai/proc/replace_inherent_law(var/number, var/law)
	ticker.centralized_ai_laws.laws_sanity_check()
	ticker.centralized_ai_laws.replace_inherent_law(number, law)
	ticker.centralized_ai_laws.show_laws(connected_robots)

/mob/living/silicon/ai/proc/clear_supplied_laws()
	ticker.centralized_ai_laws.laws_sanity_check()
	ticker.centralized_ai_laws.clear_supplied_laws()
	ticker.centralized_ai_laws.show_laws(connected_robots)

/mob/living/silicon/ai/proc/switchCamera(var/obj/machinery/camera/C)
	if (!C)
		src.machine = null
		src.set_eye(null)
		return 0
	if (stat == 2 || C.network != src.network) return 0

	// ok, we're alive, camera is acceptable and in our network...
	camera_overlay_check(C) //Add static if the camera is disabled

	src.machine = src
	src:current = C
	src.set_eye(C)
	return 1

/mob/living/silicon/ai/proc/camera_overlay_check(var/obj/machinery/camera/C)
	if(!C) return
	if(!C.status) //IT'S DISABLED ARGHH!
		src.addOverlayComposition(/datum/overlayComposition/static_noise)
		. = 0
	else
		src.removeOverlayComposition(/datum/overlayComposition/static_noise)
		. = 1
	src.updateOverlaysClient(src.client) //ov1

//AI player -> Powerline comm network interfacing (wireless assumes all nodes are objects)

/mob/living/silicon/ai/proc/receive_signal(datum/signal/signal)
	if(src.stat || !src.link)
		return
	if(!signal || !src.net_id || signal.encryption)
		return

	if(signal.transmission_method != TRANSMISSION_WIRE) //No radio for us thanks
		return

	var/target = signal.data["sender"]

	//They don't need to target us specifically to ping us.
	//Otherwise, ff they aren't addressing us, ignore them
	if(signal.data["address_1"] != src.net_id)
		if((signal.data["address_1"] == "ping") && signal.data["sender"])
			spawn(5) //Send a reply for those curious jerks
				src.post_status(target, "command", "ping_reply", "device", "MAINFRAME_AI", "netid", src.net_id)

		return

	var/sigcommand = lowertext(signal.data["command"])
	if(!sigcommand || !signal.data["sender"])
		return

	switch(sigcommand)
		if("term_connect")
			if(target in src.terminals)
				//something might be wrong here, disconnect them!
				src.terminals.Remove(target)
				boutput(src, "--- Connection closed with [target]!")
				spawn(3)
					src.post_status(target, "command","term_disconnect")
				return

			src.terminals.Add(target)
			boutput(src, "--- Terminal connection from <a href='byond://?src=\ref[src];termmsg=[target]'>[target]</a>!")
			src.post_status(target, "command","term_connect","data","noreply")
			return

		if("term_disconnect")
			if(target in src.terminals)
				src.terminals.Remove(target)
				boutput(src, "--- [target] has closed the connection!!")
				spawn(3)
					src.post_status(target, "command","term_disconnect")
				return

		//Somebody wants to talk to us, how kind!
		if("term_message")
			if(!(target in src.terminals)) //We don't know this jerk, ignore them!
				return

			if(!ckeyEx(signal.data["data"]))//Nothing of value to say, so ignore them!
				return

			var/message = signal.data["data"]
			var/rendered = "<span class='game say'><span class='name'><a href='byond://?src=\ref[src];termmsg=[target]'><b>([target]):</b></a></span>"
			rendered += "<span class='message'> [message]</span></span>"

			src.show_message(rendered, 2)
			return

	return

//Post a message over our ~wired link~
/mob/living/silicon/ai/proc/post_status(var/target_id, var/key, var/value, var/key2, var/value2, var/key3, var/value3)
	if(!src.link || !target_id)
		return

	var/datum/signal/signal = get_free_signal()
	signal.source = src
	signal.transmission_method = TRANSMISSION_WIRE
	signal.data[key] = value
	if(key2)
		signal.data[key2] = value2
	if(key3)
		signal.data[key3] = value3

	signal.data["address_1"] = target_id
	signal.data["sender"] = src.net_id

	src.link.post_signal(src, signal)

/mob/living/silicon/ai/proc/update_appearance()
	if (src.dismantle_stage > 1)
		src.UpdateOverlays(get_image("topopen"), "top")
	else
		src.UpdateOverlays(null, "top")

	switch(src.fireloss)
		if (-INFINITY to 24)
			src.UpdateOverlays(null, "burn")
		if(25 to 49)
			src.UpdateOverlays(get_image("burn25"), "burn")
		if(50 to 74)
			src.UpdateOverlays(get_image("burn50"), "burn")
		if(75 to INFINITY)
			src.UpdateOverlays(get_image("burn75"), "burn")
	switch(src.bruteloss)
		if (-INFINITY to 24)
			src.UpdateOverlays(null, "brute")
		if(25 to 49)
			src.UpdateOverlays(get_image("brute25"), "brute")
		if(50 to 74)
			src.UpdateOverlays(get_image("brute50"), "brute")
		if(75 to INFINITY)
			src.UpdateOverlays(get_image("brute75"), "brute")

	if (src.stat == 2)
		src.icon_state = "ai-crash"
		ClearAllOverlays()
	else if (src.power_mode == -1 || src.health < 0 || !src.brain || src.paralysis)
		src.icon_state = "ai-stun"
		ClearAllOverlays(1)
	else
		src.icon_state = "ai_off" //Actually do this.



		var/image/I = SafeGetOverlayImage("faceplate", 'icons/mob/ai.dmi', "ai-white", src.layer)
		I.color = faceColor
		UpdateOverlays(I, "faceplate")

		UpdateOverlays(SafeGetOverlayImage("face_glow", 'icons/mob/ai.dmi', "ai-face_glow", src.layer+0.1), "face_glow")
		UpdateOverlays(SafeGetOverlayImage("actual_face", 'icons/mob/ai.dmi', faceEmotion, src.layer+0.2), "actual_face")

		if (src.power_mode == 1)
			src.UpdateOverlays(get_image("batterymode"), "batterymode")
		else
			src.UpdateOverlays(null, "batterymode")

		if (src.moustache_mode == 1)
			src.UpdateOverlays(SafeGetOverlayImage("moustache", 'icons/mob/ai.dmi', "moustache", src.layer+0.3), "moustache")
		else
			src.UpdateOverlays(null, "moustache")

/mob/living/silicon/ai/proc/get_image(var/icon_state)
	if(!cached_image)
		cached_image = image('icons/mob/ai.dmi', "moustache")
	cached_image.icon_state = icon_state
	return cached_image


/mob/living/silicon/ai/proc/set_power_mode(var/mode)
	switch(mode)
		if(-1) // snafu
			src.set_vision(0)
			src.power_mode = 1
			if (!src.aiRestorePowerRoutine)
				src.aiRestorePowerRoutine = 1
		if(0) // everything's good
			src.set_vision(1)
			src.power_mode = 0
		if(1) // battery power
			src.set_vision(1)
			src.power_mode = 1
			if (!src.aiRestorePowerRoutine)
				src.aiRestorePowerRoutine = 1

	src.update_appearance()

/mob/living/silicon/ai/proc/set_vision(var/can_see = 1)
	if (!src.client)
		return
	if (can_see)
		vision.set_color_mod("#ffffff")
		var/turf/T = src.eye ? get_turf(src.eye) : get_turf(src)
		src.sight &= ~SEE_TURFS // Reset this first, it's necessary.
		src.sight &= ~SEE_MOBS
		src.sight &= ~SEE_OBJS
		if( !(T && isrestrictedz(T.z)))
			src.sight |= SEE_TURFS
			src.sight |= SEE_MOBS
			src.sight |= SEE_OBJS
		src.see_in_dark = SEE_DARK_FULL
		src.see_invisible = 2
		src.ear_deaf = 0
	else
		vision.set_color_mod("#000000")
		src.sight = src.sight & ~(SEE_TURFS | SEE_MOBS | SEE_OBJS)
		src.see_in_dark = 0
		src.see_invisible = 0
		src.ear_deaf = 1

/mob/living/silicon/ai/verb/open_nearest_door()
	set name = "Open Nearest Door to..."
	set desc = "Automatically opens the nearest door to a selected individual, if possible."
	set category = "AI Commands"

	src.open_nearest_door_silicon()
	return

proc/get_mobs_trackable_by_AI()
	var/list/names = list()
	var/list/namecounts = list()
	var/list/creatures = list("* Sort alphabetically...")

	for (var/mob/M in mobs)
		if (istype(M, /mob/new_player))
			continue //cameras can't follow people who haven't started yet DUH OR DIDN'T YOU KNOW THAT
		if (istype(M, /mob/living/carbon/human) && (istype(M:wear_id, /obj/item/card/id/syndicate) || (istype(M:wear_id, /obj/item/device/pda2) && M:wear_id:ID_card && istype(M:wear_id:ID_card, /obj/item/card/id/syndicate))))
			continue
		if(M.z != 1 && M.z != usr.z)
			continue
		if(!istype(M.loc, /turf)) //in a closet or something, AI can't see him anyways
			continue
		if(M.invisibility) //cloaked
			continue
		if (M == usr)
			continue

		var/good_camera = 0 //Can't track a person out of range of a functioning camera
		for(var/obj/machinery/camera/C in range(M))
			if ( C && C.status )
				good_camera = 1
				break

		if(!good_camera) continue

		var/name = M.name
		if (name in names)
			namecounts[name]++
			name = text("[] ([])", name, namecounts[name])
		else
			names.Add(name)
			namecounts[name] = 1

		creatures[name] = M

	return creatures

/mob/living/silicon/ai/proc/ai_vox_announcement()
	set name = "AI Intercom Announcement"
	set desc = "Makes an intercom announcement."
	set category = "AI Commands"

	if(src.stat || !canvox)
		return

	if(last_vox + vox_cooldown > world.time)
		src.show_text("This ability is still on cooldown for [round((vox_cooldown + last_vox - world.time) / 10)] seconds!", "red")
		return

	vox_reinit_check()

	canvox = 0
	var/message_in = input(usr, "Please enter a message (140 characters)", "Intercom Announcement?", "")
	canvox = 1

	if(!message_in)
		return
	var/message_len = length(message_in)
	var/message = copytext(message_in, 1, 140)

	if(message_len != length(message))
		if(alert("Your message was shortened to: \"[message]\", continue anyway?", "Too wordy!", "Yes", "No") != "Yes")
			return

	message = vox_playerfilter(message)

	var/output = vox_play(message, src)
	if(output)
		last_vox = world.time
		logTheThing("say", src, null, "has created an intercom announcement: \"[output]\", input: \"[message_in]\"")
		logTheThing("diary", src, null, "has created an intercom announcement: [output]", "say")
		message_admins("[key_name(src)] has created an AI intercom announcement: \"[output]\"")


/mob/living/silicon/ai/proc/ai_vox_help()
	set name = "AI Intercom Help"
	set desc = "A big list of words. Some of them are even off-limits! Wow!"
	set category = "AI Commands"

	vox_help(src)

/mob/living/silicon/ai/choose_name(var/retries = 3)
	var/randomname = pick(ai_names)
	var/newname
	for (retries, retries > 0, retries--)
		newname = input(src, "You are an AI. Would you like to change your name to something else?", "Name Change", randomname) as null|text
		if (!newname)
			src.real_name = randomname
			src.name = src.real_name
			return
		else
			newname = strip_html(newname, 32, 1)
			if (!length(newname) || copytext(newname,1,2) == " ")
				src.show_text("That name was too short after removing bad characters from it. Please choose a different name.", "red")
				continue
			else
				if (alert(src, "Use the name [newname]?", newname, "Yes", "No") == "Yes")
					src.real_name = newname
					src.name = newname
					return 1
				else
					continue
	if (!newname)
		src.real_name = randomname
		src.name = src.real_name
