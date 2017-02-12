
//Somewhere out in the vast nothingness of space, a chef (and an admin) is crying.

/obj/machinery/vending/pizza
	name = "Pizza Vending Machine"
	icon_state = "pizza"
	desc = "A vending machine that serves.. pizza?"
	var/pizcooking = 0
	var/piztopping = "plain"
	anchored = 0
	acceptcard = 0
	pay = 1
	credit = 100

	New()
		..()
		slogan_list += "A revolution in the pizza industry!"
		slogan_list += "Prepared in moments!"
		slogan_list += "I'm a chef who works 24 hours a day!"


	attack_hand(mob/user as mob)
		if (stat & (NOPOWER|BROKEN))
			return
		var/dat
		if(pizcooking)
			dat += "<TT><B>Cooking your pizza, please wait!</B></TT><BR>"
		else
			dat += "<TT><B>PizzaVend 0.5b</B></TT><BR>"
			if(emagged)
				dat += "<BR><B>Available Credits:</B> CREDIT CALCULATION ERROR<BR>"
			else
				dat += "<BR><B>Available Credits:</B> $[src.credit]<BR>"
			dat += "Topping - <A href='?src=\ref[src];picktopping=1'>[piztopping]</A><BR>"
			dat += "<A href='?src=\ref[src];cook=1'>Cook!</A><BR>"
		user << browse("<HEAD><TITLE>Pizza Vendor</TITLE></HEAD>[dat]", "window=pizzavend")
		onclose(user, "pizzavend")
		return

	Topic(href, href_list)
		if(..())
			return

		if (stat & (NOPOWER|BROKEN))
			return

		if (usr.contents.Find(src) || in_range(src, usr) && istype(src.loc, /turf))
			usr.machine = src
			if (href_list["cook"])
				if(!pizcooking)
					if((credit < 50)&&(!emagged))
						boutput(usr, "<span style=\"color:red\">Insufficient funds!</span>") // no money? get out
						return
					if(!emagged)
						credit -= 50
					pizcooking = 1
					icon_state = "pizza-vend"
					updateUsrDialog()
					sleep(200)
					playsound(src.loc, 'sound/machines/ding.ogg', 50, 1, -1)
					var/obj/item/reagent_containers/food/snacks/pizza/P = new /obj/item/reagent_containers/food/snacks/pizza(src.loc)
					P.quality = 0.6
					P.heal_amt = 2
					P.desc = "A typical [piztopping] pizza."
					P.name = "[piztopping] pizza"
					sleep(0.2)
					if(piztopping != "plain")
						switch(piztopping)
							if("meatball") P.topping_color ="#663300"
							if("mushroom") P.topping_color ="#CFCFCF"
							if("pepperoni") P.topping_color ="#C90E0E"
						P.topping = 1
						P.add_topping(0)

					if (!(stat & (NOPOWER|BROKEN)))
						icon_state = "pizza"

					pizcooking = 0
			if(href_list["picktopping"])
				switch(piztopping)
					if("plain") piztopping = "meatball"
					if("meatball") piztopping = "mushroom"
					if("mushroom") piztopping = "pepperoni"
					if("pepperoni") piztopping = "plain"
			add_fingerprint(usr)
			updateUsrDialog()
		return

/obj/monkeyplant
	name = "monkeyplant"
	icon = 'icons/obj/decoration.dmi'
	icon_state = "monkeyplant"
	desc = "Jane Goodall is crying."
	density = 1

	attackby(obj/item/W as obj, mob/user as mob)
		src.visible_message("<B>[src]</B> screams!",1)
		if (narrator_mode)
			playsound(get_turf(src), 'sound/vox/scream.ogg', 10, 1, -1)
		else
			playsound(get_turf(src), 'sound/voice/monkey_scream.ogg', 10, 1, -1)
		..()
		return

//abandoned mars outpost stuff/

/obj/item/clothing/suit/armor/mars
	name = "ME-3 Suit"
	desc = "A suit designed to withstand intense dust storms."
	icon_state = "mars_blue"
	icon = 'icons/obj/clothing/overcoats/item_suit_hazard.dmi'
	wear_image_icon = 'icons/mob/overcoats/worn_suit_hazard.dmi'
	item_state = "mars_blue"
	c_flags = SPACEWEAR
	permeability_coefficient = 0.02
	protective_temperature = 700
	heat_transfer_coefficient = 0.02

/obj/item/clothing/head/helmet/mars
	name = "ME-3 Helmet "
	desc = "A suit designed to preserve the user's visibility during intense dust storms."
	icon_state = "mars"
	item_state = "mars"
	c_flags = SPACEWEAR | COVERSEYES | COVERSMOUTH
	see_face = 0.0


/obj/critter/marsrobot
	name = "Inactive Robot"
	desc = "It looks like it hasn't been in service for decades."
	icon_state = "mars_bot"
	density = 1
	health = 55
	aggressive = 1
	defensive = 1
	wanderer = 0
	opensdoors = 1
	atkcarbon = 1
	atksilicon = 1
	firevuln = 1
	brutevuln = 1
	var/active = 0
	var/startup = 1

	New()
		..()
		icon_state = "mars_bot-0"

	seek_target()
		if(active)
			src.anchored = 0
			for (var/mob/living/C in hearers(src.seekrange,src))
				if ((C.name == src.oldtarget_name) && (world.time < src.last_found + 100)) continue
				if (iscarbon(C) && !src.atkcarbon) continue
				if (istype(C, /mob/living/silicon/) && !src.atksilicon) continue
				if (C.health < 0) continue
				if (C in src.friends) continue
				if (C.name == src.attacker) src.attack = 1
				if (iscarbon(C) && src.atkcarbon) src.attack = 1
				if (istype(C, /mob/living/silicon/) && src.atksilicon) src.attack = 1

				if (src.attack)
					src.target = C
					src.oldtarget_name = C.name
					if(startup)
						src.visible_message("<span class='combat'>The <b>[src]</b> suddenly turns on!</span>")
						name = "malfunctioning robot"
						src.speak("Lev##LLl 7 SEV-s-E infraAAAAAaction @leRT??!")
						src.visible_message("The <b>[src]</b> points at [C.name]!")
						playsound(src.loc, 'sound/voice/robot_scream.ogg', 50, 1)
						startup = 0
						wanderer = 1
					src.visible_message("<span style=\"color:red\">The <b>[src]</b> charges at [C:name]!</span>")
					src.speak(pick("DooN'T Wor##y I'M hERE!!!","LawwSS UpdAA&$.A.!!.!","CANIHELPYO&£%SIR","REsREACH!!!!!","NATAS&$%LIAHLLA ERROR CODE #736"))
					playsound(src.loc, 'sound/machines/glitch3.ogg', 50, 1)
					icon_state = "mars_bot"
					src.task = "chasing"
					break
				else
					continue

	ChaseAttack(mob/M)
		src.visible_message("<span class='combat'>The <B>[src]</B> launches itself towards [M]!</span>")
		if (prob(20)) M.stunned += rand(1,3)
		random_brute_damage(M, rand(2,5))

	CritterAttack(mob/M)
		src.attacking = 1
		src.visible_message("<span class='combat'>The <B>[src]</B> slams itself against [src.target]!</span>")
		random_brute_damage(src.target, rand(7,17))
		spawn(10)
			src.attacking = 0


	Move()
		..()
		playsound(src.loc, 'sound/effects/airbridge_dpl.ogg', 30, 10, -2)


	proc/speak(var/message)
		for(var/mob/O in hearers(src, null))
			boutput(O, "<span class='game say'><span class='name'>[src]</span> beeps, \"[message]\"")
		return

	attackby(obj/item/W as obj, mob/living/user as mob)
		if(active) ..()

	attack_hand(var/mob/user as mob)
		if(active) ..()

	CritterDeath()
		if (!src.alive) return
		src.icon_state += "-dead"
		src.alive = 0
		src.anchored = 0
		src.density = 0
		walk_to(src,0)
		src.visible_message("<b>[src]</b> collapses!")
		playsound(src.loc, 'sound/voice/robot_scream.ogg', 50, 1)
		speak("aaaaaaalkaAAAA##AAAAAAAAAAAAAAAAA'ERRAAAAAAAA!!!")

/obj/mars_roverpuzzle
	name = "rover frame"
	icon = 'icons/misc/worlds.dmi'
	icon_state = "rover_puzzle_base"
	desc = "It looks like this rover was never finished."
	density = 1
	anchored = 1
	var/wheel = 0
	var/oxy = 0
	var/battery = 0
	var/glass = 0
	var/motherboard = 0

	attackby(obj/item/P as obj, mob/user as mob)
		if (istype(P, /obj/item/mars_roverpart))
			if ((istype(P, /obj/item/mars_roverpart/wheel))&&(!wheel))
				boutput(user, "<span style=\"color:blue\">You attach the wheel to the rover's chassis.</span>")
				overlays += icon('icons/misc/worlds.dmi', "rover_puzzle_wheel")
				wheel = 1
			if ((istype(P, /obj/item/mars_roverpart/oxy))&&(!oxy))
				boutput(user, "<span style=\"color:blue\">You connect the life support module to the rover.</span>")
				overlays += icon('icons/misc/worlds.dmi', "rover_puzzle_oxy")
				oxy = 1
			if ((istype(P, /obj/item/mars_roverpart/glass))&&(!glass))
				boutput(user, "<span style=\"color:blue\">You attach the glass to the rover.</span>")
				overlays += icon('icons/misc/worlds.dmi', "rover_puzzle_window")
				glass = 1
			if ((istype(P, /obj/item/mars_roverpart/battery))&&(!battery))
				boutput(user, "<span style=\"color:blue\">You wire the battery to the rover.</span>")
				overlays += icon('icons/misc/worlds.dmi', "rover_puzzle_cell")
				battery = 1
			if ((istype(P, /obj/item/mars_roverpart/motherboard))&&(!motherboard))
				boutput(user, "<span style=\"color:blue\">You wire the motherboard to the rover.</span>")
				motherboard = 1
			playsound(user, 'sound/items/Deconstruct.ogg', 65, 1)
			qdel(P)
			if((wheel)&&(oxy)&&(battery)&&(glass)&&(motherboard))
				var/obj/vehicle/marsrover/R = new /obj/vehicle/marsrover(loc)
				R.dir = WEST
				playsound(src.loc, 'sound/machines/rev_engine.ogg', 50, 1)
				boutput(user, "<span style=\"color:blue\">The rover has been completed!</span>")
				qdel(src)

/obj/item/mars_roverpart
	icon = 'icons/misc/worlds.dmi'

	wheel
		name = "wheel"
		icon_state = "rover_puzzle_wheelitem"
		desc = "A wheel for some kind of vehicle."
	oxy
		name = "filter"
		icon_state = "rover_puzzle_oxyitem"
		desc = "Some kind of filter designed to keep dust from getting into a chamber."
	glass
		name = "glass"
		icon_state = "rover_puzzle_glassitem"
		desc = "It looks pretty strong."
	battery
		name = "rover battery"
		icon_state = "rover_puzzle_batteryitem"
		desc = "A battery designed for rovers. I don't think it's safe to poke around with this thing."

	motherboard
		name = "rover motherboard"
		icon_state = "rover_puzzle_motherboarditem"
		desc = "The motherboard of a rover, it looks pretty fancy!"
		var/pickedup = 0

		pickup(mob/user)
			..()
			if(!pickedup)
				boutput(user, "<span style=\"color:red\">Uh oh.</span>")
				for(var/obj/critter/marsrobot/M in oview(4,src))
					M.active = 1
					M.seek_target()
				pickedup = 1


/obj/vehicle/marsrover
	name = "Rover"
	desc = "A rover designed to let researchers explore hazardous planets safely and efficiently. It looks pretty old."
	icon_state = "marsrover"
	rider_visible = 0
	layer = MOB_LAYER + 1
	sealed_cabin = 1
	mats = 8

/obj/vehicle/marsrover/proc/update()
	if(rider)
		icon_state = "marsrover2"
	else
		icon_state = "marsrover"

/obj/vehicle/marsrover/eject_rider(var/crashed, var/selfdismount)
	rider.set_loc(src.loc)
	rider.pixel_y = 0
	walk(src, 0)

	for (var/obj/item/I in src)
		I.set_loc(get_turf(src))

	if(crashed)
		if(crashed == 2)
			playsound(src.loc, 'sound/misc/meteorimpact.ogg', 40, 1)
		boutput(rider, "<span class='combat'><B>You are flung over the [src]'s handlebars!</B></span>")
		rider.stunned = 8
		rider.weakened = 5
		for (var/mob/C in AIviewers(src))
			if(C == rider)
				continue
			C.show_message("<span class='combat'><B>[rider] is flung over the [src]'s handlebars!</B></span>", 1)
		var/turf/target = get_edge_target_turf(src, src.dir)
		rider.throw_at(target, 5, 1)
		rider.buckled = null
		rider = null

		update()
		return
	if(selfdismount)
		boutput(rider, "<span style=\"color:blue\">You dismount from the [src].</span>")
		for (var/mob/C in AIviewers(src))
			if(C == rider)
				continue
			C.show_message("<B>[rider]</B> dismounts from the [src].", 1)
	rider.buckled = null
	rider = null
	update()
	return

/obj/vehicle/marsrover/relaymove(mob/user as mob, dir)
	if(rider)
		if(istype(src.loc, /turf/space))
			return
		icon_state = "marsrover2"
		walk(src, dir, 2)
	else
		for(var/mob/M in src.contents)
			M.set_loc(src.loc)

/obj/vehicle/marsrover/MouseDrop_T(mob/living/carbon/human/target, mob/user)
	if (rider || !istype(target) || target.buckled || LinkBlocked(target.loc,src.loc) || get_dist(user, src) > 1 || get_dist(user, target) > 1 || user.paralysis || user.stunned || user.weakened || user.stat || istype(user, /mob/living/silicon/ai))
		return

	var/msg

	if(target == user && !user.stat)	// if drop self, then climbed in
		msg = "[user.name] climbs onto the [src]."
		boutput(user, "<span style=\"color:blue\">You climb onto the [src].</span>")
	else if(target != user && !user.restrained())
		msg = "[user.name] helps [target.name] onto the [src]!"
		boutput(user, "<span style=\"color:blue\">You help [target.name] onto the [src]!</span>")
	else
		return

	for (var/obj/item/I in src)
		I.set_loc(get_turf(src))

	target.set_loc(src)
	rider = target
	rider.pixel_x = 0
	rider.pixel_y = 5
	if(rider.restrained() || rider.stat)
		rider.buckled = src

	for (var/mob/C in AIviewers(src))
		if(C == user)
			continue
		C.show_message(msg, 3)

	update()
	return

/obj/vehicle/marsrover/Click()
	if(usr != rider)
		..()
		return
	if(!(usr.paralysis || usr.stunned || usr.weakened || usr.stat))
		eject_rider(0, 1)
	return

/obj/vehicle/marsrover/attack_hand(mob/living/carbon/human/M as mob)
	if(!M || !rider)
		..()
		return
	switch(M.a_intent)
		if("harm", "disarm")
			if(prob(60))
				playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
				src.visible_message("<span class='combat'><B>[M] has shoved [rider] off of the [src]!</B></span>")
				rider.weakened = 2
				eject_rider()
			else
				playsound(src.loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				src.visible_message("<span class='combat'><B>[M] has attempted to shove [rider] off of the [src]!</B></span>")
	return

/obj/vehicle/marsrover/bullet_act(flag, A as obj)
	if(rider)
		eject_rider()
		rider.bullet_act(flag, A)
	return

/obj/vehicle/marsrover/meteorhit()
	if(rider)
		eject_rider()
		rider.meteorhit()
	return

/obj/vehicle/marsrover/disposing()
	if(rider)
		boutput(rider, "<span class='combat'><B>Your rover is destroyed!</B></span>")
		eject_rider()
	..()
	return

/area/marsoutpost
	name = "Abandoned Outpost"
	var/sound/mysound = null

	New()
		..()
		var/sound/S = new/sound()
		mysound = S
		S.file = 'sound/ambience/mars_interiorambi.ogg'
		S.repeat = 1
		S.wait = 0
		S.channel = 123
		S.volume = 60
		S.priority = 255
		S.status = SOUND_UPDATE
		spawn(10) process()

	Entered(atom/movable/Obj,atom/OldLoc)
		..()
		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_UPDATE
				Obj << mysound
		return

	Exited(atom/movable/Obj)
		..()
		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_PAUSED | SOUND_UPDATE
				Obj << mysound

	proc/process()
		var/sound/S = null
		var/sound_delay = 0
		while(ticker && ticker.current_state < GAME_STATE_FINISHED)
			sleep(60)
			if (ticker.current_state == GAME_STATE_PLAYING)
				if(prob(10))
					S = sound(file=pick('sound/ambience/marsfx1.ogg','sound/ambience/marsfx2.ogg','sound/ambience/marsfx3.ogg','sound/ambience/marsfx4.ogg'), volume=100)
					sound_delay = rand(0, 50)
				else
					S = null
					continue

				for(var/mob/living/carbon/human/H in src)
					if(H.client)
						mysound.status = SOUND_UPDATE
						H << mysound
						if(S)
							spawn(sound_delay)
								H << S

/area/marsoutpost/duststorm
	name = "Barren Planet"
	icon_state = "yellow"

	New()
		..()
		overlays += image(icon = 'icons/turf/areas.dmi', icon_state = "dustverlay", layer = EFFECTS_LAYER_BASE)

	Entered(atom/movable/O)
		..()
		if (istype(O, /mob/living/carbon/human))
			var/mob/living/jerk = O
			if (jerk.stat != 2)
				if((istype(jerk:wear_suit, /obj/item/clothing/suit/armor/mars))&&(istype(jerk:head, /obj/item/clothing/head/helmet/mars))) return
				random_brute_damage(jerk, 100)
				jerk.weakened = 40
				step(jerk,EAST)
				if(prob(50))
					playsound(src.loc, 'sound/effects/bloody_stabOLD.ogg', 50, 1)
					boutput(jerk, pick("Dust gets caught in your eyes!","The wind blows you off course!","Debris pierces through your skin!"))



/area/marsoutpost/vault
	icon_state = "red"

/obj/critter/gunbot/heavy
	name = "security robot"
	desc = "A 2030's-era security robot. Uh oh."
	icon = 'icons/misc/critter.dmi'
	icon_state = "mars_sec_bot"
	opensdoors = 0
	atksilicon = 1
	var/overheat = 0
	var/datum/projectile/my_bullet = new/datum/projectile/bullet/revolver_38

	Shoot()
		if(overheat < 10)
			overheat ++
			..()

	proc/speak(var/message)
		if((!alive) || (!message))
			return

		var/fontSize = 2
		var/fontIncreasing = 1
		var/fontSizeMax = 2
		var/fontSizeMin = -2
		var/messageLen = length(message)
		var/processedMessage = ""

		for (var/i = 1, i <= messageLen, i++)
			processedMessage += "<font size=[fontSize]>[copytext(message, i, i+1)]</font>"
			if (fontIncreasing)
				fontSize = min(fontSize+1, fontSizeMax)
				if (fontSize >= fontSizeMax)
					fontIncreasing = 0
			else
				fontSize = max(fontSize-1, fontSizeMin)
				if (fontSize <= fontSizeMin)
					fontIncreasing = 1
			if(prob(10))
				processedMessage += pick("%","##A","-","- - -","ERROR")

		for(var/mob/O in hearers(src, null))
			O.show_message("<span class='game say'><span class='name'>[src]</span> blares, \"<B>[processedMessage]</B>\"",2)

		return


	seek_target()
		src.anchored = 0
		if(overheat == 10)
			speak("WARNING : OVERHEATING")
			sleep(50)
			overheat = 0
		else
			for (var/mob/living/C in hearers(src.seekrange,src))
				if (!src.alive) break
				if (C.health < 0) continue
				if (C.name == src.attacker) src.attack = 1
				if (iscarbon(C) && src.atkcarbon) src.attack = 1
				if (istype(C, /mob/living/silicon/) && src.atksilicon) src.attack = 1

				if (src.attack)

					src.target = C
					src.oldtarget_name = C.name
					src.visible_message("<span class='combat'><b>[src]</b> rapidly fires at [src.target]!</span>")


					playsound(src.loc, 'sound/weapons/ak47shot.ogg', 50, 1)
					var/tturf = get_turf(target)
					spawn(2)
						Shoot(tturf, src.loc, src)
						src.pixel_x += rand(-3,3)
						src.pixel_y += rand(-3,3)
					if(prob(55))
						speak(pick("SECURITY OPERATION IN PROGRESS.","WARNING - YOU ARE IN A SECURITY ZONE.","ALERT - ALL OUTPOST PERSONNEL ARE TO MOVE TO A SAFE ZONE.","WARNING: THREAT RECOGNIZED AS NANOTRASEN, ESPONIAGE DETECTED","THIS IS FOR THE FREE MARKET","NANOTRASEN BETRAYED YOU."))
						var/glitchsound = pick('sound/machines/romhack1.ogg', 'sound/machines/romhack2.ogg', 'sound/machines/romhack3.ogg','sound/machines/glitch1.ogg','sound/machines/glitch2.ogg','sound/machines/glitch3.ogg','sound/machines/glitch4.ogg','sound/machines/glitch5.ogg')
						playsound(src.loc, glitchsound, 50, 1)
					if(prob(75))
						spawn(0) step_to(src,target)
					src.attack = 0
					return
				else continue
		task = "thinking"

	Shoot(var/target, var/start, var/user, var/bullet = 0)
		if(target == start)
			return
		if (!start) //Wire: fix for Cannot read null.y (start was null somehow)
			return

		shoot_projectile_ST(src, my_bullet, target)

/obj/machinery/computer/mars_vault
	name = "Vault Console"
	desc = "A very old computer that controls the vault."
	icon_state = "old"
	pixel_y = 8
	var/triggered = 0

	attack_hand(mob/user as mob)
		if (..() || (stat & (NOPOWER|BROKEN)))
			return

		user.machine = src
		add_fingerprint(user)

		var/dat = "<center><h4>Vault Computer</h4></center>"
		if(triggered)
			dat += "<center><font size = 20>VAULT UNLOCKED</font></center><br>"

		else
			dat += "<center><a href='?src=\ref[src];unlock=1'>Unlock Vault</a></center>"
		user << browse("<head><title>Vault Computer</title></head>[dat]", "window=tourconsole;size=302x245")
		onclose(user, "vaultcomputer")
		return

	Topic(href, href_list)
		if(..())
			return
		usr.machine = src
		src.add_fingerprint(usr)

		if (href_list["unlock"])
			if(!triggered)
				triggered = 1
				for(var/area/marsoutpost/vault/V in world)
					V.overlays += image(icon = 'icons/effects/alert.dmi', icon_state = "blue", layer = EFFECTS_LAYER_1)
				for(var/obj/machinery/door/poddoor/P)
					if (P.id == "mars_vault")
						spawn( 0 )
							P.open()
				for(var/obj/item/storage/secure/ssafe/marsvault/M in world)
					M.disabled = 0

				for(var/obj/machinery/door/poddoor/P)
				playsound(src.loc, 'sound/machines/engine_alert1.ogg', 50, 1)


		src.updateUsrDialog()
		return

/obj/item/device/audio_log/mars
		continuous = 0
		audiolog_messages = list("*Heavy breathing*",
								"ALERT: THE EMERGENCY ROCKET WILL ARRIVE IN FIVE MINUTES.",
								"Come on, wh-have to get out of here!",
								"I can't.. *cough*",
								"Please! We can't just stay here, we are the only ones left who-",
								"It's too late for me, you sti-*cough*-have a chance to escape with it.",
								"Take the r-ro-rover, it's yo-u-*cough* *cough* ... . .   .",
								"*Psshhh*")
		audiolog_speakers = list("Male Scientist",
								"Computerized Voice",
								"Female Scientist",
								"Male Scientist",
								"Female Scientist",
								"Male Scientist",
								"Male Scientist",
								"Airlock")