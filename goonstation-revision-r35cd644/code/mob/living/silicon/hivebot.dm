/mob/living/silicon/hivebot
	name = "Robot"
	voice_name = "synthesized voice"
	icon = 'icons/mob/hivebot.dmi'
	icon_state = "vegas"
	health = 60
	max_health = 60
	var/self_destruct = 0
	var/beebot = 0
	robot_talk_understand = 2

//HUD
	var/obj/screen/hands = null
	var/obj/screen/cells = null
	var/obj/screen/inv1 = null
	var/obj/screen/inv2 = null
	var/obj/screen/inv3 = null

//3 Modules can be activated at any one time.
	var/obj/item/robot_module/module = null
	var/module_active = null
	var/list/module_states = list(null,null,null)

	var/obj/item/device/radio/radio = null

	req_access = list(access_robotics)
	var/obj/item/cell/cell = null
	//var/energy = 4000
	//var/energy_max = 4000
	var/jetpack = 0

	shell = 1

	sound_fart = 'sound/misc/poo2_robot.ogg'

	var/bruteloss = 0
	var/fireloss = 0

/mob/living/silicon/hivebot/TakeDamage(zone, brute, burn)
	bruteloss += brute
	fireloss += burn

/mob/living/silicon/hivebot/HealDamage(zone, brute, burn)
	bruteloss -= brute
	fireloss -= burn
	bruteloss = max(0, bruteloss)
	fireloss = max(0, fireloss)

/mob/living/silicon/hivebot/get_brute_damage()
	return bruteloss

/mob/living/silicon/hivebot/get_burn_damage()
	return fireloss

/mob/living/silicon/hivebot/eyebot
	name = "Eyebot"
	icon_state = "eyebot"
	jetpack = 1
	health = 40
	self_destruct = 1

	New()
		..()
		bioHolder = new/datum/bioHolder( src )
		spawn(5)
			if (src.module)
				qdel(src.module)
			pick_module()
			var/ion_trail = new /datum/effects/system/ion_trail_follow()
			ion_trail:set_up(src)

			//ew
			if (!(src in available_ai_shells))
				available_ai_shells += src

		return

	pick_module()
		if (src.module)
			return

		if (!ticker)
			src.module = new /obj/item/robot_module( src )
			return
		if (!ticker.mode)
			src.module = new /obj/item/robot_module( src )
			return
		if (ticker.mode && istype(ticker.mode, /datum/game_mode/construction))
			src.module = new /obj/item/robot_module/construction_ai( src )
		else
			src.module = new /obj/item/robot_module( src )

	movement_delay()
		return -1

	updateicon() // Haine wandered in here and just junked up this code with bees.  I'm so sorry it's so ugly aaaa
		src.overlays = null

		if(src.stat == 0)
			if(src.client)
				if(pixel_y)
					if (src.beebot == 1)
						src.icon_state = "eyebot-bee"
					else
						src.icon_state = "[initial(icon_state)]"
				else
					spawn(0)
						while(src.pixel_y < 10)
							src.pixel_y++
							sleep(1)
						if (src.beebot == 1)
							src.icon_state = "eyebot-bee"
						else
							src.icon_state = "[initial(icon_state)]"
					return
			else
				if (src.beebot == 1)
					src.icon_state = "eyebot-bee-logout"
				else
					src.icon_state = "[initial(icon_state)]-logout"
				src.pixel_y = 0
		else
			if (src.beebot == 1)
				src.icon_state = "eyebot-bee-dead"
			else
				src.icon_state = "[initial(icon_state)]-dead"
			src.pixel_y = 0
		return

	show_laws()
		var/mob/living/silicon/ai/aiMainframe = src.mainframe
		if (istype(aiMainframe))
			aiMainframe.show_laws(0, src)
		else
			ticker.centralized_ai_laws.show_laws(src)

		return

	ghostize()
		if(src.mainframe)
			src.mainframe.return_to(src)
		else
			return ..()

	handle_regular_hud_updates()
		..()
		if (!ticker)
			return
		if (!ticker.mode)
			return
		if (ticker.mode && istype(ticker.mode, /datum/game_mode/construction))
			see_invisible = 9

/mob/living/silicon/hivebot/drop_item_v()
	return

/mob/living/silicon/hivebot/death(gibbed)
	if (src.mainframe)
		logTheThing("combat", src, null, "'s AI shell was destroyed at [log_loc(src)].") // Brought in line with carbon mobs (Convair880).
		src.mainframe.return_to(src)
	src.stat = 2
	src.canmove = 0

	vision.set_color_mod("#ffffff") // reset any blindness
	src.sight |= SEE_TURFS
	src.sight |= SEE_MOBS
	src.sight |= SEE_OBJS

	src.see_in_dark = SEE_DARK_FULL
	src.see_invisible = 2
	src.updateicon()
/*
	if(src.client)
		spawn(0)
			var/key = src.ckey
			recently_dead += key
			spawn(recently_time) recently_dead -= key
*/
	var/tod = time2text(world.realtime,"hh:mm:ss") //weasellos time of death patch
	store_memory("Time of death: [tod]", 0)

	return ..(gibbed)

/mob/living/silicon/hivebot/emote(var/act, var/voluntary = 0)
	var/param = null
	if (findtext(act, " ", 1, null))
		var/t1 = findtext(act, " ", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)
	var/m_type = 1
	var/message = null

	switch(lowertext(act))

		/*if ("shit")
			new /obj/item/rods/(src.loc)
			playsound(src.loc, "sound/misc/poo2_robot.ogg", 50, 1)
			message = "<B>[src]</B> shits on the floor."
			m_type = 1*/

		if ("help")
			src.show_text("To use emotes, simply enter \"*(emote)\" as the entire content of a say message. Certain emotes can be targeted at other characters - to do this, enter \"*emote (name of character)\" without the brackets.")
			src.show_text("For a list of all emotes, use *list. For a list of basic emotes, use *listbasic. For a list of emotes that can be targeted, use *listtarget.")

		if ("list")
			src.show_text("Basic emotes:")
			src.show_text("clap, flap, aflap, twitch, twitch_s, scream, birdwell, fart, flip, custom, customv, customh")
			src.show_text("Targetable emotes:")
			src.show_text("salute, bow, hug, wave, glare, stare, look, leer, nod, point")

		if ("listbasic")
			src.show_text("clap, flap, aflap, twitch, twitch_s, scream, birdwell, fart, flip, custom, customv, customh")

		if ("listtarget")
			src.show_text("salute, bow, hug, wave, glare, stare, look, leer, nod, point")

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

		if ("birdwell", "burp")
			if (src.emote_check(voluntary, 50))
				message = "<B>[src]</B> birdwells."
				playsound(src.loc, "sound/vox/birdwell.ogg", 50, 1)

		if ("scream")
			if (src.emote_check(voluntary, 50))
				if (narrator_mode)
					playsound(src.loc, 'sound/vox/scream.ogg', 50, 1, 0, src.get_age_pitch())
				else
					playsound(get_turf(src), src.sound_scream, 80, 0, 0, src.get_age_pitch())
				message = "<b>[src]</b> screams!"

		if ("johnny")
			var/M
			if (param)
				M = adminscrub(param)
			if (!M)
				param = null
			else
				message = "<B>[src]</B> says, \"[M], please. He had a family.\" [src.name] takes a drag from a cigarette and blows its name out in smoke."
				m_type = 2

		if ("flip")
			if (src.emote_check(voluntary, 50))
				if (narrator_mode)
					playsound(src.loc, pick('sound/vox/deeoo.ogg', 'sound/vox/dadeda.ogg'), 50, 1)
				else
					playsound(src.loc, pick(src.sound_flip1, src.sound_flip2), 50, 1)
				message = "<B>[src]</B> does a flip!"
				if (prob(50))
					animate_spin(src, "R", 1, 0)
				else
					animate_spin(src, "L", 1, 0)

				for (var/mob/living/M in view(1, null))
					if (M == src)
						continue
					message = "<B>[src]</B> beep-bops at [M]."
					break

		if ("fart")
			if (src.emote_check(voluntary))
				m_type = 2
				var/fart_on_other = 0
				for (var/mob/living/M in src.loc)
					if (M == src || !M.lying)
						continue
					message = "<span style=\"color:red\"><B>[src]</B> farts in [M]'s face!</span>"
					fart_on_other = 1
					break
				if (!fart_on_other)
					switch (rand(1, 48))
						if (1) message = "<B>[src]</B> lets out a girly little 'toot' from his fart synthesizer."
						if (2) message = "<B>[src]</B> farts loudly!"
						if (3) message = "<B>[src]</B> lets one rip!"
						if (4) message = "<B>[src]</B> farts! It sounds wet and smells like rotten eggs."
						if (5) message = "<B>[src]</B> farts robustly!"
						if (6) message = "<B>[src]</B> farted! It reminds you of your grandmother's queefs."
						if (7) message = "<B>[src]</B> queefed out his metal ass!"
						if (8) message = "<B>[src]</B> farted! It reminds you of your grandmother's queefs."
						if (9) message = "<B>[src]</B> farts a ten second long fart."
						if (10) message = "<B>[src]</B> groans and moans, farting like the world depended on it."
						if (11) message = "<B>[src]</B> breaks wind!"
						if (12) message = "<B>[src]</B> synthesizes a farting sound."
						if (13) message = "<B>[src]</B> generates an audible discharge of intestinal gas."
						if (14) message = "<span style=\"color:red\"><B>[src]</B> is a farting motherfucker!!!</span>"
						if (15) message = "<span style=\"color:red\"><B>[src]</B> suffers from flatulence!</span>"
						if (16) message = "<B>[src]</B> releases flatus."
						if (17) message = "<B>[src]</B> releases gas generated in his digestive tract, his stomach and his intestines. <span style=\"color:red\"><B>It stinks way bad!</B></span>"
						if (18) message = "<B>[src]</B> farts like your mom used to!"
						if (19) message = "<B>[src]</B> farts. It smells like Soylent Surprise!"
						if (20) message = "<B>[src]</B> farts. It smells like pizza!"
						if (21) message = "<B>[src]</B> farts. It smells like George Melons' perfume!"
						if (22) message = "<B>[src]</B> farts. It smells like atmos in here now!"
						if (23) message = "<B>[src]</B> farts. It smells like medbay in here now!"
						if (24) message = "<B>[src]</B> farts. It smells like the bridge in here now!"
						if (25) message = "<B>[src]</B> farts like a pubby!"
						if (26) message = "<B>[src]</B> farts like a goone!"
						if (27) message = "<B>[src]</B> farts so hard he's certain poop came out with it, but dares not find out."
						if (28) message = "<B>[src]</B> farts delicately."
						if (29) message = "<B>[src]</B> farts timidly."
						if (30) message = "<B>[src]</B> farts very, very quietly. The stench is OVERPOWERING."
						if (31) message = "<B>[src]</B> farts and says, \"Mmm! Delightful aroma!\""
						if (32) message = "<B>[src]</B> farts and says, \"Mmm! Sexy!\""
						if (33) message = "<B>[src]</B> farts and fondles his own buttocks."
						if (34) message = "<B>[src]</B> farts and fondles YOUR buttocks."
						if (35) message = "<B>[src]</B> fart in he own mouth. A shameful [src]."
						if (36) message = "<B>[src]</B> farts out pure plasma! <span style=\"color:red\"><B>FUCK!</B></span>"
						if (37) message = "<B>[src]</B> farts out pure oxygen. What the fuck did he eat?"
						if (38) message = "<B>[src]</B> breaks wind noisily!"
						if (39) message = "<B>[src]</B> releases gas with the power of the gods! The very station trembles!!"
						if (40) message = "<B>[src] <span style=\"color:red\">f</span><span style=\"color:blue\">a</span>r<span style=\"color:red\">t</span><span style=\"color:blue\">s</span>!</B>"
						if (41) message = "<B>[src] shat his pants!</B>"
						if (42) message = "<B>[src] shat his pants!</B> Oh, no, that was just a really nasty fart."
						if (43) message = "<B>[src]</B> is a flatulent whore."
						if (44) message = "<B>[src]</B> likes the smell of his own farts."
						if (45) message = "<B>[src]</B> doesnt wipe after he poops."
						if (46) message = "<B>[src]</B> farts! Now he smells like Tiny Turtle."
						if (47) message = "<B>[src]</B> burps! He farted out of his mouth!! That's Showtime's style, baby."
						if (48) message = "<B>[src]</B> laughs! His breath smells like a fart."

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
									if(1)
										M.say("[M == src ? "i" : src.name] made a fart!!")
									if(2)
										M.emote("giggle")
									if(3)
										M.emote("clap")
		else
			src.show_text("Invalid Emote: [act]")
			return

	if ((message && src.stat == 0))
		if (m_type & 1)
			for (var/mob/O in viewers(src, null))
				O.show_message(message, m_type)
		else
			for (var/mob/O in hearers(src, null))
				O.show_message(message, m_type)
	return

/mob/living/silicon/hivebot/examine()
	set src in oview()
	set category = "Local"

	if (isghostdrone(usr))
		return
	boutput(usr, "<span style=\"color:blue\">*---------*</span>")
	boutput(usr, text("<span style=\"color:blue\">This is [bicon(src)] <B>[src.name]</B>!</span>"))
	if (src.stat == 2)
		boutput(usr, text("<span style=\"color:red\">[src.name] is powered-down.</span>"))
	if (src.bruteloss)
		if (src.bruteloss < 75)
			boutput(usr, text("<span style=\"color:red\">[src.name] looks slightly dented</span>"))
		else
			boutput(usr, text("<span style=\"color:red\"><B>[src.name] looks severely dented!</B></span>"))
	if (src.fireloss)
		if (src.fireloss < 75)
			boutput(usr, text("<span style=\"color:red\">[src.name] looks slightly burnt!</span>"))
		else
			boutput(usr, text("<span style=\"color:red\"><B>[src.name] looks severely burnt!</B></span>"))
	if (src.stat == 1)
		boutput(usr, text("<span style=\"color:red\">[src.name] doesn't seem to be responding.</span>"))
	return

/mob/living/silicon/hivebot/New(loc, mainframe)
	boutput(src, "<span style=\"color:blue\">Your icons have been generated!</span>")
	updateicon()

	if (mainframe)
		dependent = 1
		//src.real_name = mainframe:name
		src.name = mainframe:name
	else
		src.real_name = "Robot [pick(rand(1, 999))]"
		src.name = src.real_name

	src.radio = new /obj/item/device/radio(src)
	src.ears = src.radio

	spawn(10)
		if (!src.cell)
			src.cell = new /obj/item/cell/shell_cell/charged (src)

	..()
	src.botcard.access = get_all_accesses()

/mob/living/silicon/hivebot/proc/pick_module()
	if(src.module)
		return
	var/mod = input("Please, select a module!", "Robot", null, null) in list("Construction", "Engineering", "Mining")
	if(src.module)
		return
	switch(mod)
//		if("Combat")
//			src.module = new /obj/item/hive_module/standard(src)

//		if("Security")
//			src.module = new /obj/item/hive_module/security(src)

		if("Engineering")
			src.module = new /obj/item/hive_module/engineering(src)

		if("Construction")
			src.module = new /obj/item/hive_module/construction(src)

		if("Mining")
			boutput(src, "You may now fly in space using your Mining Jetpack")
			src.module = new /obj/item/hive_module/mining(src)
			src.jetpack = 1

	src.hands.icon_state = "malf"
	updateicon()


/mob/living/silicon/hivebot/blob_act(var/power)
	if (src.stat != 2)
		src.bruteloss += power
		src.updatehealth()
		return 1
	return 0

/mob/living/silicon/hivebot/Stat()
	..()
	if(src.cell)
		stat("Charge Left:", "[src.cell.charge]/[src.cell.maxcharge]")
	else
		stat("No Cell Inserted!")

/mob/living/silicon/hivebot/restrained()
	return 0

/mob/living/silicon/hivebot/bullet_act(var/obj/projectile/P)
	..()
	log_shot(P,src) // Was missing (Convair880).

/mob/living/silicon/hivebot/ex_act(severity)
	..() // Logs.
	src.flash(30)

	if (src.stat == 2 && src.client)
		src.gib(1)
		return

	else if (src.stat == 2 && !src.client)
		qdel(src)
		return

	var/b_loss = src.bruteloss
	var/f_loss = src.fireloss
	switch(severity)
		if(1.0)
			if (src.stat != 2)
				b_loss += 100
				f_loss += 100
				src.gib(1)
				return
		if(2.0)
			if (src.stat != 2)
				b_loss += 60
				f_loss += 60
		if(3.0)
			if (src.stat != 2)
				b_loss += 30
	src.bruteloss = b_loss
	src.fireloss = f_loss
	src.updatehealth()

/mob/living/silicon/hivebot/meteorhit(obj/O as obj)
	for(var/mob/M in viewers(src, null))
		M.show_message(text("<span style=\"color:red\">[src] has been hit by [O]</span>"), 1)
		//Foreach goto(19)
	if (src.health > 0)
		src.bruteloss += 30
		if ((O.icon_state == "flaming"))
			src.fireloss += 40
		src.updatehealth()
	return

/mob/living/silicon/hivebot/Bump(atom/movable/AM as mob|obj, yes)
	spawn( 0 )
		if ((!( yes ) || src.now_pushing))
			return
		src.now_pushing = 1
		if(ismob(AM))
			var/mob/tmob = AM
			if(istype(tmob, /mob/living/carbon/human) && tmob.bioHolder.HasEffect("fat"))
				if(prob(20))
					for(var/mob/M in viewers(src, null))
						if(M.client)
							boutput(M, "<span style=\"color:red\"><B>[src] fails to push [tmob]'s fat ass out of the way.</B></span>")
					src.now_pushing = 0
					src.unlock_medal("That's no moon, that's a GOURMAND!", 1)
					return
		src.now_pushing = 0


		if (!istype(AM, /atom/movable))
			return
		if (!src.now_pushing)
			src.now_pushing = 1
			if (!AM.anchored)
				var/t = get_dir(src, AM)
				step(AM, t)
			src.now_pushing = null

		if(AM)
			AM.last_bumped = world.timeofday
			AM.Bumped(src)
		return
	return

/mob/living/silicon/hivebot/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weldingtool) && W:welding)
		if (src.get_brute_damage() < 1)
			boutput(user, "<span style=\"color:red\">[src] has no dents to repair.</span>")
			return
		if (W:get_fuel() > 2)
			W:use_fuel(1)
		else
			boutput(user, "Need more welding fuel!")
			return
		src.HealDamage("All", 30, 0)
		src.add_fingerprint(user)
		if (src.get_brute_damage() < 1)
			src.bruteloss = 0
			src.visible_message("<span style=\"color:red\"><b>[user] fully repairs the dents on [src]!</b></span>")
		else
			src.visible_message("<span style=\"color:red\">[user] has fixed some of the dents on [src].</span>")
		src.updatehealth()

	// Added ability to repair burn-damaged AI shells (Convair880).
	else if (istype(W, /obj/item/cable_coil))
		var/obj/item/cable_coil/coil = W
		src.add_fingerprint(user)
		if (src.get_burn_damage() < 1)
			user.show_text("There's no burn damage on [src.name]'s wiring to mend.", "red")
			return
		coil.use(1)
		src.HealDamage("All", 0, 30)
		if (src.get_burn_damage() < 1)
			src.fireloss = 0
			src.visible_message("<span style=\"color:red\"><b>[user.name]</b> fully repairs the damage to [src.name]'s wiring.</span>")
		else
			boutput(user, "<span style=\"color:red\"><b>[user.name]</b> repairs some of the damage to [src.name]'s wiring.</span>")
		src.updatehealth()

	else if (istype(W, /obj/item/clothing/suit/bee))
		boutput(user, "You stuff [src] into [W]! It fits surprisingly well.")
		src.beebot = 1
		src.updateicon()
		qdel(W)
		return
	else
		return ..()

/mob/living/silicon/hivebot/attack_hand(mob/user)
	..()
	if(user.a_intent == INTENT_GRAB && src.beebot == 1)
		var/obj/item/clothing/suit/bee/B = new /obj/item/clothing/suit/bee(src.loc)
		boutput(user, "You pull [B] off of [src]!")
		src.beebot = 0
		src.updateicon()
	return

/mob/living/silicon/hivebot/allowed(mob/M)
	//check if it doesn't require any access at all
	if(src.check_access(null))
		return 1
	return 0

/mob/living/silicon/hivebot/check_access(obj/item/I)
	if(!istype(src.req_access, /list)) //something's very wrong
		return 1

	if (istype(I, /obj/item/device/pda2) && I:ID_card)
		I = I:ID_card
	var/list/L = src.req_access
	if(!L.len) //no requirements
		return 1
	if(!I || !istype(I, /obj/item/card/id) || !I:access) //not ID or no access
		return 0
	for(var/req in src.req_access)
		if(!(req in I:access)) //doesn't have this access
			return 0
	return 1

/mob/living/silicon/hivebot/proc/updateicon()

	src.overlays = null

//	if (src.beebot == 1)
//		src.icon_state = "eyebot-bee"
	if (src.stat == 0)
		if (src.beebot == 1)
			src.icon_state = "eyebot-bee[src.client ? null : "-logout"]"
		else
			src.icon_state = "[initial(icon_state)][src.client ? null : "-logout"]"
	else
		if (src.beebot == 1)
			src.icon_state = "eyebot-bee-dead"
		else
			src.icon_state = "[initial(icon_state)]-dead"


/mob/living/silicon/hivebot/proc/installed_modules()

	if(!src.module)
		src.pick_module()
		return
	var/dat = "<HEAD><TITLE>Modules</TITLE><META HTTP-EQUIV='Refresh' CONTENT='10'></HEAD><BODY><br>"
	dat += {"<A HREF='?action=mach_close&window=robotmod'>Close</A>
	<BR>
	<BR>
	<B>Activated Modules</B>
	<BR>
	Module 1: [module_states[1] ? "<A HREF=?src=\ref[src];mod=\ref[module_states[1]]>[module_states[1]]<A>" : "No Module"]<BR>
	Module 2: [module_states[2] ? "<A HREF=?src=\ref[src];mod=\ref[module_states[2]]>[module_states[2]]<A>" : "No Module"]<BR>
	Module 3: [module_states[3] ? "<A HREF=?src=\ref[src];mod=\ref[module_states[3]]>[module_states[3]]<A>" : "No Module"]<BR>
	<BR>
	<B>Installed Modules</B><BR><BR>"}

	for (var/obj in src.module.modules)
		if(src.activated(obj))
			dat += text("[obj]: <B>Activated</B><BR>")
		else
			dat += text("[obj]: <A HREF=?src=\ref[src];act=\ref[obj]>Activate</A><BR>")
/*
		if(src.activated(obj))
			dat += text("[obj]: \[<B>Activated</B> | <A HREF=?src=\ref[src];deact=\ref[obj]>Deactivate</A>\]<BR>")
		else
			dat += text("[obj]: \[<A HREF=?src=\ref[src];act=\ref[obj]>Activate</A> | <B>Deactivated</B>\]<BR>")
*/
	src << browse(dat, "window=robotmod&can_close=0")


/mob/living/silicon/hivebot/Topic(href, href_list)
	..()
	if (href_list["mod"])
		var/obj/item/O = locate(href_list["mod"])
		O.attack_self(src)

	if (href_list["act"])
		var/obj/item/O = locate(href_list["act"])
		if(activated(O))
			boutput(src, "Already activated")
			return
		if(!src.module_states[1])
			src.module_states[1] = O
			O.layer = HUD_LAYER
			src.contents += O
			O.pickup(src) // Handle light datums and the like.
		else if(!src.module_states[2])
			src.module_states[2] = O
			O.layer = HUD_LAYER
			src.contents += O
			O.pickup(src)
		else if(!src.module_states[3])
			src.module_states[3] = O
			O.layer = HUD_LAYER
			src.contents += O
			O.pickup(src)
		else
			boutput(src, "You need to disable a module first!")
		src.installed_modules()

	if (href_list["deact"])
		var/obj/item/O = locate(href_list["deact"])
		if(activated(O))
			if(src.module_states[1] == O)
				src.module_states[1] = null
				src.contents -= O
				O.dropped(src) // Handle light datums and the like.
			else if(src.module_states[2] == O)
				src.module_states[2] = null
				src.contents -= O
				O.dropped(src)
			else if(src.module_states[3] == O)
				src.module_states[3] = null
				src.contents -= O
				O.dropped(src)
			else
				boutput(src, "Module isn't activated.")
		else
			boutput(src, "Module isn't activated")
		src.installed_modules()
	return

/mob/living/silicon/hivebot/proc/uneq_active()
	if (isnull(src.module_active))
		return
	if (isitem(src.module_active))
		var/obj/item/I = src.module_active
		I.dropped(src) // Handle light datums and the like.

	if(src.module_states[1] == src.module_active)
		if (src.client)
			src.client.screen -= module_states[1]
		src.contents -= module_states[1]
		src.module_active = null
		src.module_states[1] = null
		src.inv1.icon_state = "inv1"
	else if(src.module_states[2] == src.module_active)
		if (src.client)
			src.client.screen -= module_states[2]
		src.contents -= module_states[2]
		src.module_active = null
		src.module_states[2] = null
		src.inv2.icon_state = "inv2"
	else if(src.module_states[3] == src.module_active)
		if (src.client)
			src.client.screen -= module_states[3]
		src.contents -= module_states[3]
		src.module_active = null
		src.module_states[3] = null
		src.inv3.icon_state = "inv3"


/mob/living/silicon/hivebot/proc/activated(obj/item/O)
	if(src.module_states[1] == O)
		return 1
	else if(src.module_states[2] == O)
		return 1
	else if(src.module_states[3] == O)
		return 1
	else
		return 0

/mob/living/silicon/hivebot/proc/radio_menu()
	if(!src.radio)
		src.radio = new /obj/item/device/radio(src)
		src.ears = src.radio
	var/dat = {"
<TT>
Microphone: [src.radio.broadcasting ? "<A href='byond://?src=\ref[src.radio];talk=0'>Engaged</A>" : "<A href='byond://?src=\ref[src.radio];talk=1'>Disengaged</A>"]<BR>
Speaker: [src.radio.listening ? "<A href='byond://?src=\ref[src.radio];listen=0'>Engaged</A>" : "<A href='byond://?src=\ref[src.radio];listen=1'>Disengaged</A>"]<BR>
Frequency:
<A href='byond://?src=\ref[src.radio];freq=-10'>-</A>
<A href='byond://?src=\ref[src.radio];freq=-2'>-</A>
[format_frequency(src.radio.frequency)]
<A href='byond://?src=\ref[src.radio];freq=2'>+</A>
<A href='byond://?src=\ref[src.radio];freq=10'>+</A><BR>
-------
</TT>"}
	src << browse(dat, "window=radio")
	onclose(src, "radio")
	return


/mob/living/silicon/hivebot/Move(a, b, flag)

	if (src.buckled)
		return

	if (src.restrained())
		src.pulling = null

	var/t7 = 1
	if (src.restrained())
		for(var/mob/M in range(src, 1))
			if ((M.pulling == src && M.stat == 0 && !( M.restrained() )))
				t7 = null
	if ((t7 && (src.pulling && ((get_dist(src, src.pulling) <= 1 || src.pulling.loc == src.loc) && (src.client && src.client.moving)))))
		var/turf/T = src.loc
		. = ..()

		if (src.pulling && src.pulling.loc)
			if(!( isturf(src.pulling.loc) ))
				src.pulling = null
				return
			else
				if(Debug)
					diary <<"src.pulling disappeared? at [__LINE__] in mob.dm - src.pulling = [src.pulling]"
					diary <<"REPORT THIS"

		/////
		if(src.pulling && src.pulling.anchored)
			src.pulling = null
			return

		if (!src.restrained())
			var/diag = get_dir(src, src.pulling)
			if ((diag - 1) & diag)
			else
				diag = null
			if ((get_dist(src, src.pulling) > 1 || diag))
				if (ismob(src.pulling))
					var/mob/M = src.pulling
					var/ok = 1
					if (locate(/obj/item/grab, M.grabbed_by))
						if (prob(75))
							var/obj/item/grab/G = pick(M.grabbed_by)
							if (istype(G, /obj/item/grab))
								M.visible_message("<span style=\"color:red\">[G.affecting] has been pulled from [G.assailant]'s grip by [src]</span>")
								qdel(G)
						else
							ok = 0
						if (locate(/obj/item/grab, M.grabbed_by.len))
							ok = 0
					if (ok)
						var/t = M.pulling
						M.pulling = null
						step(src.pulling, get_dir(src.pulling.loc, T))
						M.pulling = t
				else
					if (src.pulling)
						step(src.pulling, get_dir(src.pulling.loc, T))
	else
		src.pulling = null
		. = ..()
	if (src.s_active && !(s_active.master in src))
		src.detach_hud(src.s_active)
		src.s_active = null

/mob/living/silicon/hivebot/verb/cmd_show_laws()
	set category = "Robot Commands"
	set name = "Show Laws"

	src.show_laws()
	return

/mob/living/silicon/hivebot/verb/open_nearest_door()
	set category = "Robot Commands"
	set name = "Open Nearest Door to..."
	set desc = "Automatically opens the nearest door to a selected individual, if possible."

	src.open_nearest_door_silicon()
	return

/mob/living/silicon/hivebot/verb/cmd_return_mainframe()
	set category = "Robot Commands"
	set name = "Recall to Mainframe"
	return_mainframe()

/mob/living/silicon/hivebot/proc/return_mainframe()
	if(mainframe)
		mainframe.return_to(src)
		src.updateicon()
	else
		boutput(src, "<span style=\"color:red\">You lack a dedicated mainframe!</span>")
		return

/mob/living/silicon/hivebot/Life(datum/controller/process/mobs/parent)
	set invisibility = 0
	if (..(parent))
		return 1
	if (src.transforming)
		return

	if (src.stat != 2)
		use_power()
	else
		if(self_destruct)
			spawn(5)
				gib(src)

	src.blinded = null

	clamp_values()

	update_icons_if_needed()
	src.antagonist_overlay_refresh(0, 0)

	handle_regular_status_updates()

	if(client)
		src.shell = 0
		handle_regular_hud_updates()
		update_items()
		if(dependent)
			mainframe_check()

	update_canmove()


/mob/living/silicon/hivebot

	proc/clamp_values()

		stunned = max(min(stunned, 10),0)
		paralysis = max(min(paralysis, 1), 0)
		weakened = max(min(weakened, 15), 0)
		sleeping = max(min(sleeping, 1), 0)
		bruteloss = max(bruteloss, 0)
		fireloss = max(fireloss, 0)

	proc/use_power()

		if (src.cell)
			if (src.cell.charge <= 0)
				//death() no why would it just explode upon running out of power that is absurd
				if (src.stat == 0)
					sleep(0)
					src.lastgasp()
				src.stat = 1
			else if (src.cell.charge <= 10)
				src.module_active = null
				src.module_states[1] = null
				src.module_states[2] = null
				src.module_states[3] = null
				src.cell.charge -=1
			else
				if (src.module_states[1])
					src.cell.charge -=1
				if (src.module_states[2])
					src.cell.charge -=1
				if (src.module_states[3])
					src.cell.charge -=1
				src.cell.charge -=1
				src.blinded = 0
				src.stat = 0
		else
			src.blinded = 1
			if (src.stat == 0)
				sleep(0)
				src.lastgasp() // calling lastgasp() here because we just ran out of power
			src.stat = 1


	proc/update_canmove()
		if (paralysis || stunned || weakened || buckled)
			canmove = 0
		else
			canmove = 1


	proc/handle_regular_status_updates()

		health = src.max_health - (fireloss + bruteloss)

		if(health <= 0)
			death()

		if (src.stat != 2) //Alive.

			if (src.paralysis || src.stunned || src.weakened) //Stunned etc.
				var/setStat = src.stat
				if (src.stunned > 0)
					src.stunned--
					setStat = 0
				if (src.weakened > 0)
					src.weakened--
					src.lying = 1
					setStat = 0
				if (src.paralysis > 0)
					src.paralysis--
					src.blinded = 1
					src.lying = 1
					setStat = 1
				if (src.stat == 0 && setStat == 1)
					sleep(0)
					src.lastgasp() // calling lastgasp() here because we just got knocked out
				src.stat = setStat
			else	//Not stunned.
				src.lying = 0
				src.stat = 0

		else //Dead.
			src.blinded = 1
			src.stat = 2

		if (src.stuttering)
			src.stuttering = 0

		src.lying = 0
		src.density = 1

		if (src.get_eye_blurry())
			src.change_eye_blurry(-1)

		if (src.druggy > 0)
			src.druggy--
			src.druggy = max(0, src.druggy)

		return 1

	proc/handle_regular_hud_updates()

		if (src.stat == 2 || src.bioHolder.HasEffect("xray"))
			src.sight |= SEE_TURFS
			src.sight |= SEE_MOBS
			src.sight |= SEE_OBJS
			src.see_in_dark = SEE_DARK_FULL
			src.see_invisible = 2
		else if (src.stat != 2)
			src.sight &= ~SEE_MOBS
			src.sight &= ~SEE_TURFS
			src.sight &= ~SEE_OBJS
			src.see_in_dark = SEE_DARK_FULL
			src.see_invisible = 2

		if (src.healths)
			if (src.stat != 2)
				switch(health)
					if(max_health to INFINITY)
						src.healths.icon_state = "health0"
					if(src.max_health*0.80 to src.max_health)
						src.healths.icon_state = "health1"
					if(src.max_health*0.60 to src.max_health*0.80)
						src.healths.icon_state = "health2"
					if(src.max_health*0.40 to src.max_health*0.60)
						src.healths.icon_state = "health3"
					if(src.max_health*0.20 to src.max_health*0.40)
						src.healths.icon_state = "health4"
					if(0 to max_health*0.20)
						src.healths.icon_state = "health5"
					else
						src.healths.icon_state = "health6"
			else
				src.healths.icon_state = "health7"

		if (src.cells)
			if (src.cell)
				switch(round(100*src.cell.charge/src.cell.maxcharge))
					if (75 to INFINITY)
						cells.icon_state = "charge4"
					if (50 to 75)
						cells.icon_state = "charge3"
					if (25 to 50)
						cells.icon_state = "charge2"
					if (1 to 25)
						cells.icon_state = "charge1"
					else
						cells.icon_state = "charge0"
			else
				cells.icon_state = "charge-none"

		switch(get_temp_deviation())
			if(2 to INFINITY)
				src.bodytemp.icon_state = "temp2"
			if(1 to 2)
				src.bodytemp.icon_state = "temp1"
			if(-1 to 1)
				src.bodytemp.icon_state = "temp0"
			if(-2 to -1)
				src.bodytemp.icon_state = "temp-1"
			else
				src.bodytemp.icon_state = "temp-2"


		if(src.pullin)	src.pullin.icon_state = "pull[src.pulling ? 1 : 0]"

		if (!src.sight_check(1) && src.stat != 2)
			vision.set_color_mod("#000000")
		else
			vision.set_color_mod("#ffffff")
		return 1


	proc/update_items()
		if (src.client)
			src.client.screen -= src.contents
			src.client.screen += src.contents
		var/obj/item/I = null
		if(src.module_states[1])
			I = src.module_states[1]
			I.screen_loc = ui_inv1
		if(src.module_states[2])
			I = src.module_states[2]
			I.screen_loc = ui_inv2
		if(src.module_states[3])
			I = src.module_states[3]
			I.screen_loc = ui_inv3

	proc/mainframe_check()
		if (mainframe)
			if (mainframe.stat == 2)
				mainframe.return_to(src)
		else
			death()

/mob/living/silicon/hivebot/Login()
	..()

	update_clothing()
	updateicon()

	if(src.real_name == "Cyborg")
		src.real_name += " "
		src.real_name += pick("Alpha", "Beta", "Gamma", "Delta", "Epsilon", "Zeta", "Eta", "Theta", "Iota", "Kappa", "Lambda", "Mu", "Nu", "Xi", "Omicron", "Pi", "Rho", "Sigma", "Tau", "Upsilon", "Phi", "Chi", "Psi", "Omega")
		src.real_name += "-[pick(rand(1, 99))]"
		src.name = src.real_name
	return

/mob/living/silicon/hivebot/Logout()
	..()
	updateicon()
	return

/mob/living/silicon/hivebot/say_understands(var/other)
	if (isAI(other))
		return 1
	if (ishuman(other))
		var/mob/living/carbon/human/H = other
		if (!H.mutantrace || !H.mutantrace.exclusive_language)
			return 1
		else
			return 0
	if (isrobot(other) || isshell(other))
		return 1
	return ..()

/mob/living/silicon/hivebot/say_quote(var/text)
	var/ending = copytext(text, length(text))

	if (ending == "?")
		return "queries, \"[text]\"";
	else if (ending == "!")
		return "declares, \"[text]\"";

	return "states, \"[text]\"";

/*-----Shell-Creation---------------------------------------*/

/obj/item/ai_interface
	name = "\improper AI interface board"
	desc = "A board that allows AIs to interface with the robot it's installed in. It features a little blinking LED, but who knows what the LED is trying to tell you? Does it even mean anything? Why is it blinking? WHY?? WHAT DOES IT MEAN?! ??????"
	icon = 'icons/mob/hivebot.dmi'
	icon_state = "ai-interface"
	item_state = "ai-interface"
	w_class = 2.0

//obj/item/cell/shell_cell moved to cells.dm

/obj/item/shell_frame
	name = "AI shell frame"
	desc = "An empty frame for an AI shell."
	icon = 'icons/mob/hivebot.dmi'
	icon_state = "shell-frame"
	item_state = "shell-frame"
	w_class = 2.0
	var/build_step = 0
	var/obj/item/cell/cell = null
	var/has_radio = 0
	var/has_interface = 0

/obj/item/shell_frame/attackby(obj/item/W as obj, mob/user as mob)
	if ((istype(W, /obj/item/sheet)) && (!src.build_step))
		var/obj/item/sheet/M = W
		if (M.amount >= 1)
			src.build_step++
			boutput(user, "You add the plating to [src]!")
			playsound(get_turf(src), "sound/weapons/Genhit.ogg", 40, 1)
			src.icon_state = "shell-plate"
			M.amount -= 1
			if (M.amount < 1)
				user.drop_item()
				qdel(M)
			return
		else
			boutput(user, "<span style=\"color:red\">You need at least one metal sheet to add plating!</span>")
			return

	else if ((istype(W, /obj/item/cable_coil)) && (src.build_step == 1))
		var/obj/item/cable_coil/coil = W
		if (coil.amount >= 3)
			src.build_step++
			boutput(user, "You add the cable to [src]!")
			playsound(get_turf(src), "sound/weapons/Genhit.ogg", 40, 1)
			coil.amount -= 3
			src.icon_state = "shell-cable"
			if (coil.amount < 1)
				user.drop_item()
				qdel(coil)
			return
		else
			boutput(user, "<span style=\"color:red\">You need at least three lengths of cable to install it in [src]!</span>")
			return

	else if (istype(W, /obj/item/cell))
		if (src.build_step >= 2)
			src.build_step++
			boutput(user, "You add the [W] to [src]!")
			playsound(get_turf(src), "sound/weapons/Genhit.ogg", 40, 1)
			src.cell = W
			user.u_equip(W)
			W.set_loc(src)
			return
		else
			boutput(user, "[src] needs[src.build_step ? "" : " metal plating and"] at least three lengths of cable installed before you can add the cell.")
			return

	else if (istype(W, /obj/item/device/radio))
		if (src.build_step >= 2)
			src.build_step++
			boutput(user, "You add the [W] to [src]!")
			playsound(get_turf(src), "sound/weapons/Genhit.ogg", 40, 1)
			src.icon_state = "shell-radio"
			src.has_radio = 1
			qdel(W)
			return
		else
			boutput(user, "[src] needs[src.build_step ? "" : " metal plating and"] at least three lengths of cable installed before you can add the radio.")
			return

	else if (istype(W, /obj/item/ai_interface))
		if (src.build_step >= 2)
			src.build_step++
			boutput(user, "You add the [W] to [src]!")
			playsound(get_turf(src), "sound/weapons/Genhit.ogg", 40, 1)
			src.has_interface = 1
			qdel(W)
			return
		else
			boutput(user, "[src] needs[src.build_step ? "" : " metal plating and"] at least three lengths of cable installed before you can add the AI interface.")
			return

	else if (istype(W, /obj/item/wrench))
		if (src.build_step >= 5)
			src.build_step++
			boutput(user, "You activate the shell!  Beep bop!")
			var/mob/living/silicon/hivebot/eyebot/S = new /mob/living/silicon/hivebot/eyebot(get_turf(src))
			S.cell = src.cell
			src.cell.set_loc(S)
			qdel(src)
			return
		else if (src.build_step >= 2)
			var/still_needed = ""
			if (!src.cell)
				still_needed += " a power cell,"
			if (!src.has_radio)
				still_needed += " a station bounced radio,"
			if (!src.has_interface)
				still_needed += " an AI interface board,"
			if (still_needed)
				still_needed = copytext(still_needed, 1, -1)
			boutput(user, "[src] needs [still_needed] before you can activate it.")
			return
		else
			var/still_needed = ""
			if (!src.cell)
				still_needed += " a power cell,"
			if (!src.has_radio)
				still_needed += " a station bounced radio,"
			if (!src.has_interface)
				still_needed += " an AI interface board,"
			if (still_needed)
				still_needed = copytext(still_needed, 1, -1)
			boutput(user, "[src] needs[src.build_step ? "" : " metal plating and"] at least three lengths of cable installed and[still_needed] before you can activate it.")
			return
