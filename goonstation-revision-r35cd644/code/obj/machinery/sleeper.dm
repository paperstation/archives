// Contains:
// - Sleeper control console
// - Sleeper
// - Portable sleeper (fake Port-a-Medbay)

// I overhauled the sleeper to make it a little more viable. Aside from being a saline dispenser,
// it was of practically no use to medical personnel and thus ignored in general. The current
// implemention is by no means a substitute for a doctor in the same way that a medibot isn't, but
// the sleeper should now be capable of keeping light-crit patients stabilized for a reasonable
// amount of time. I tried to ensure that, at the time of writing, the sleeper is neither under-
// or overpowered with regard to other methods of healing mobs (Convair880).

//////////////////////////////////////// Sleeper control console //////////////////////////////

/obj/machinery/sleep_console
	name = "sleeper console"
	desc = "A device that displays the vital signs of the occupant of the sleeper, and can dispense chemicals."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeperconsole"
	anchored = 1
	density = 1
	mats = 8
	var/timing = 0 // Timer running?
	var/time = null // In seconds.
	var/obj/machinery/sleeper/our_sleeper = null

	New()
		..()
		spawn(5)
			if (src)
				src.find_sleeper()
		return

	ex_act(severity)
		switch (severity)
			if (1.0)
				qdel(src)
				return
			if (2.0)
				if (prob(50))
					qdel(src)
					return
			else
		return

	// Just relay emag_act() here.
	emag_act(var/mob/user, var/obj/item/card/emag/E)
		src.add_fingerprint(user)
		if (!src.our_sleeper)
			return 0
		switch (src.our_sleeper.emag_act(user, E))
			if (0) return 0
			if (1) return 1

	proc/find_sleeper()
		if (!src)
			return
		var/sleeper_west = locate(/obj/machinery/sleeper, get_step(src, WEST))
		var/sleeper_east = locate(/obj/machinery/sleeper, get_step(src, EAST))
		if (sleeper_west)
			src.our_sleeper = sleeper_west
			src.dir = 2
		else if (sleeper_east)
			src.our_sleeper = sleeper_east
			src.dir = 4
		return

	proc/wake_occupant()
		if (!src || !src.our_sleeper)
			return

		var/mob/occupant = src.our_sleeper.occupant
		if (ishuman(occupant))
			var/mob/living/carbon/human/O = occupant
			if (O.sleeping)
				O.sleeping = 3
				if (prob(5)) // Heh.
					boutput(O, "<font color='green'> [bicon(src)] Wake up, Neo...</font>")
				else
					boutput(O, "<font color='blue'> [bicon(src)] *beep* *beep*</font>")
			src.visible_message("<span style=\"color:blue\">The [src.name]'s occupant alarm clock dings!</span>")
			playsound(src.loc, "sound/machines/ding.ogg", 100, 1)
		return

	process()
		if (!src)
			return
		if (src.stat & (NOPOWER|BROKEN))
			return
		if (!src.our_sleeper)
			src.time = 0
			src.timing = 0
			src.updateDialog()
			return
		if (src.timing)
			if (src.time > 0)
				src.time = round(src.time) - 1
				var/mob/occupant = src.our_sleeper.occupant
				if (occupant)
					if (ishuman(occupant))
						var/mob/living/carbon/human/O = occupant
						if (O.stat == 2)
							src.visible_message("<span class='game say'><span class='name'>[src]</span> beeps, \"Alert! No further life signs detected from occupant.\"")
							playsound(src.loc, "sound/machines/buzz-two.ogg", 100, 0)
							src.timing = 0
						else
							if (O.sleeping != 5)
								O.sleeping = 5
							src.our_sleeper.alter_health(O)
				else
					src.timing = 0
			else
				src.wake_occupant()
				src.time = 0
				src.timing = 0

		src.updateDialog()
		return

	// Makes sense, I suppose. They're on the shuttles too.
	powered()
		return

	use_power()
		return

	power_change()
		return

	attack_hand(mob/user as mob)
		if (..())
			return

		src.add_fingerprint(user)
		user.machine = src

		var/dat = ""

		if (src.our_sleeper)
			var/mob/occupant = src.our_sleeper.occupant
			dat += "<font color='blue'><B>Occupant Statistics:</B></FONT><BR>"

			if (occupant)
				var/t1
				switch(occupant.stat)
					if(0)
						t1 = "Conscious"
					if(1)
						t1 = "Unconscious"
					if(2)
						t1 = "*dead*"
					else

				var/brute = occupant.get_brute_damage()
				var/burn = occupant.get_burn_damage()
				dat += "<hr>[occupant.health > 50 ? "<font color='blue'>" : "<font color='red'>"]\tHealth: [occupant.health]% ([t1])</FONT><BR>"
				dat += "[occupant.get_oxygen_deprivation() < 60 ? "<font color='blue'>" : "<font color='red'>"]&emsp;-Respiratory Damage: [occupant.get_oxygen_deprivation()]</FONT><BR>"
				dat += "[occupant.get_toxin_damage() < 60 ? "<font color='blue'>" : "<font color='red'>"]&emsp;-Toxin Content: [occupant.get_toxin_damage()]</FONT><BR>"
				dat += "[burn < 60 ? "<font color='blue'>" : "<font color='red'>"]&emsp;-Burn Severity: [burn]</FONT><BR>"
				dat += "[brute < 60 ? "<font color='blue'>" : "<font color='red'>"]&emsp;-Brute Damage: [brute]</FONT><BR>"

				// We don't have a fully-fledged reagent scanner built-in. Of course, this also means
				// we can't detect our own poisons if the sleeper's emagged. Too bad.
				var/reagents = ""
				for (var/R in occupant.reagents.reagent_list)
					var/datum/reagent/MR = occupant.reagents.reagent_list[R]
					if (istype(MR, /datum/reagent/medical))
						reagents += " [MR.name] ([MR.volume]),"
				if (reagents == "")
					reagents += "None "
				var/report = copytext(reagents, 1, -1)
				dat += "<br>Detectable rejuvenators in occupant's bloodstream:<br>"
				dat += "<font color='blue' size=2>[report]</font><br>"
				dat += "<br><font size=2>Note: Use separate reagent scanner for complete analysis.</font><br>"

				dat += "<hr>"

				// Capped at 3 min. Used to be 10 min, Christ.
				var/second = src.time % 60
				var/minute = (src.time - second) / 60
				dat += "<TT><B>Occupant Alarm Clock</B><br>[src.timing ? "<A href='?src=\ref[src];time=0'>Timing</A>" : "<A href='?src=\ref[src];time=1'>Not Timing</A>"] [minute]:[second]<br><A href='?src=\ref[src];tp=-30'>-</A> <A href='?src=\ref[src];tp=-1'>-</A> <A href='?src=\ref[src];tp=1'>+</A> <A href='?src=\ref[src];tp=30'>+</A><br></TT>"
				dat += "<br><font size=2>System will inject rejuvenators automatically when occupant is in hibernation.</font>"

				dat += "<hr>"

				dat += "<A href='?src=\ref[src];refresh=1'>Refresh</A> | <A href='?src=\ref[src];rejuv=1'>Inject Rejuvenators</A> | <A href='?src=\ref[src];eject_occupant=1'>Eject Occupant</A>"

			else
				dat += "<HR>The sleeper is unoccupied."

		else
			dat += "<font color='red'><b>ERROR:</b> No sleeper detected!</font><br>"
			dat += "<br><A href='?src=\ref[src];refresh=1'>Refresh Connection</A>"

		user << browse(dat, "window=sleeper")
		onclose(user, "sleeper")

		return

	Topic(href, href_list)
		if (..()) return
		if (!isturf(src.loc)) return
		if ((src.our_sleeper && src.our_sleeper.occupant == usr) || usr.stunned || usr.weakened || usr.stat || usr.restrained()) return
		if (!issilicon(usr) && !in_range(src, usr)) return

		src.add_fingerprint(usr)
		usr.machine = src

		if (href_list["time"])
			if (src.our_sleeper && src.our_sleeper.occupant)
				if (src.our_sleeper.occupant.stat == 2)
					usr.show_text("The occupant is dead.", "red")
				else
					src.timing = text2num(href_list["time"])
					src.visible_message("<span style=\"color:blue\">[usr] [src.timing ? "sets" : "stops"] the [src]'s occupant alarm clock.</span>")
					if (src.timing)
						// People do use sleepers for grief from time to time.
						logTheThing("station", usr, src.our_sleeper.occupant, "initiates a sleeper's timer ([src.our_sleeper.emagged ? "<b>EMAGGED</b>, " : ""][src.time] seconds), forcing %target% asleep at [log_loc(src.our_sleeper)].")
					else
						src.wake_occupant()

		// Capped at 3 min. Used to be 10 min, Christ.
		if (href_list["tp"])
			if (src.our_sleeper)
				var/t = text2num(href_list["tp"])
				if (t > 0 && src.timing && src.our_sleeper.occupant)
					// People do use sleepers for grief from time to time.
					logTheThing("station", usr, src.our_sleeper.occupant, "increases a sleeper's timer ([src.our_sleeper.emagged ? "<b>EMAGGED</b>, " : ""]occupied by %target%) by [t] seconds at [log_loc(src.our_sleeper)].")
				src.time = min(180, max(0, src.time + t))

		if (href_list["rejuv"])
			if (src.our_sleeper && src.our_sleeper.occupant)
				if (src.timing)
					// So they can't combine this with manual injections to spam/farm reagents.
					usr.show_text("Occupant alarm clock active. Manual injection unavailable.", "red")
				else
					src.our_sleeper.inject(usr, 1)

		if (href_list["refresh"])
			if (!src.our_sleeper)
				src.find_sleeper()

		if (href_list["eject_occupant"])
			if (src.our_sleeper && src.our_sleeper.occupant)
				src.our_sleeper.go_out()
				usr.machine = null
				usr << browse(null, "window=sleeper")

		src.updateUsrDialog()
		return

////////////////////////////////////////////// Sleeper ////////////////////////////////////////

/obj/machinery/sleeper
	name = "sleeper"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper_0"
	desc = "An enterable machine that analyzes and stabilizes the vital signs of the occupant."
	density = 1
	anchored = 1
	mats = 25
	var/mob/occupant = null
	var/obj/machinery/power/data_terminal/link = null
	var/net_id = null //net id for control over powernet

	var/no_med_spam = 0 // In relation to world time.
	var/med_stabilizer = "saline" // Basic med that will always be injected.
	var/med_crit = "ephedrine" // If < -25 health.
	var/med_oxy = "salbutamol" // If > +15 OXY.
	var/med_tox = "charcoal" // If > +15 TOX.

	var/emagged = 0
	var/list/med_emag = list("sulfonal", "toxin", "mercury") // Picked at random per injection.

	New()
		..()
		spawn (6)
			if (src && !src.link)
				var/turf/T = get_turf(src)
				var/obj/machinery/power/data_terminal/test_link = locate() in T
				if (test_link && !test_link.is_valid_master(test_link.master))
					src.link = test_link
					src.link.master = src
			src.net_id = format_net_id("\ref[src]")

	proc/update_icon()
		if (!src)
			return
		src.icon_state = "sleeper_[!isnull(occupant)]"
		return

	ex_act(severity)
		switch (severity)
			if (1.0)
				for (var/atom/movable/A as mob|obj in src)
					A.set_loc(src.loc)
					A.ex_act(severity)
				qdel(src)
				return
			if (2.0)
				if (prob(50))
					for (var/atom/movable/A as mob|obj in src)
						A.set_loc(src.loc)
						A.ex_act(severity)
					qdel(src)
					return
			if (3.0)
				if (prob(25))
					for (var/atom/movable/A as mob|obj in src)
						A.set_loc(src.loc)
						A.ex_act(severity)
					qdel(src)
					return
		return

	// Let's get us some poisons.
	emag_act(var/mob/user, var/obj/item/card/emag/E)
		src.add_fingerprint(user)
		if (src.emagged == 1)
			return 0
		else
			src.emagged = 1
			if (user && ismob(user))
				user.show_text("You short out the [src.name]'s reagent synthesis safety protocols.", "blue")
			src.visible_message("<span style=\"color:red\"><b>The [src.name] buzzes oddly!</b></span>")
			logTheThing("station", user, src.occupant, "emags a [src.name] [src.occupant ? "with %target% inside " : ""](setting it to inject poisons) at [log_loc(src)].")
			return 1

	demag(var/mob/user)
		if (!src.emagged)
			return 0
		if (user)
			user.show_text("You repair the [src.name]'s reagent synthesis safety protocols.", "blue")
		src.emagged = 0
		return 1

	blob_act(var/power)
		if (prob(power * 3.75))
			for (var/atom/movable/A as mob|obj in src)
				A.set_loc(src.loc)
				A.blob_act(power)
			qdel(src)
		return

	relaymove(mob/user as mob)
		if (usr.stat != 0 || usr.stunned != 0)
			return
		src.go_out()
		return

	allow_drop()
		return 0

	attackby(obj/item/grab/G as obj, mob/user as mob)
		src.add_fingerprint(user)

		if (!istype(G, /obj/item/grab) || !ismob(G.affecting))
			..()
			return
		if (src.occupant)
			user.show_text("The [src.name] is already occupied!", "red")
			return

		var/mob/M = G.affecting
		M.set_loc(src)
		src.occupant = M
		src.update_icon()
#ifdef DATALOGGER
		game_stats.Increment("sleeper")
#endif
		for (var/obj/O in src)
			O.set_loc(src.loc)
		qdel(G)
		return

	// Makes sense, I suppose. They're on the shuttles too.
	powered()
		return

	use_power()
		return

	power_change()
		return

	// Called by sleeper console once per tick when occupant is asleep/hibernating.
	alter_health(var/mob/living/M as mob)
		if (!M || !isliving(M))
			return
		if (M.stat == 2)
			return

		// We always inject this, even when emagged to mask the fact we're malfunctioning.
		// Otherwise, one glance at the control console would be sufficient.
		if (M.reagents.get_reagent_amount(src.med_stabilizer) == 0)
			M.reagents.add_reagent(src.med_stabilizer, 2)

		// Why not, I guess? Might convince people to willingly enter hiberation, providing
		// traitorous MDs with a good opportunity to off somebody with an emagged sleeper.
		if (M.ailments)
			for (var/datum/ailment_data/D in M.ailments)
				if (istype(D.master, /datum/ailment/addiction))
					var/datum/ailment_data/addiction/A = D
					var/probability = 5
					if (world.timeofday > A.last_reagent_dose + 1500)
						probability = 10
					if (prob(probability))
						//DEBUG("Healed [M]'s [A.associated_reagent] addiction.")
						M.show_text("You no longer feel reliant on [A.associated_reagent]!", "blue")
						M.ailments -= A
						qdel(A)

		// No life-saving meds for you, buddy.
		if (src.emagged)
			var/our_poison = pick(src.med_emag)
			if (M.reagents.get_reagent_amount(our_poison) == 0)
				//DEBUG("Injected occupant with [our_poison] at [log_loc(src)].")
				M.reagents.add_reagent(our_poison, 2)
		else
			if (M.health < -25 && M.reagents.get_reagent_amount(src.med_crit) == 0)
				M.reagents.add_reagent(src.med_crit, 2)
			if (M.get_oxygen_deprivation() >= 15 && M.reagents.get_reagent_amount(src.med_oxy) == 0)
				M.reagents.add_reagent(src.med_oxy, 2)
			if (M.get_toxin_damage() >= 15 && M.reagents.get_reagent_amount(src.med_tox) == 0)
				M.reagents.add_reagent(src.med_tox, 2)

		src.no_med_spam = world.time // So they can't combine this with manual injections.
		return

	// Called by sleeper console when injecting stuff manually.
	proc/inject(mob/user_feedback as mob, var/manual_injection = 0)
		if (!src)
			return
		if (src.occupant)
			if (src.occupant.stat == 2)
				if (user_feedback && ismob(user_feedback))
					user_feedback.show_text("The occupant is dead.", "red")
				return
			if (src.no_med_spam && world.time < src.no_med_spam + 50)
				if (user_feedback && ismob(user_feedback))
					user_feedback.show_text("The reagent synthesizer is recharging.", "red")
				return

			var/crit = src.occupant.reagents.get_reagent_amount(src.med_crit)
			var/rejuv = src.occupant.reagents.get_reagent_amount(src.med_stabilizer)
			var/oxy = src.occupant.reagents.get_reagent_amount(src.med_oxy)
			var/tox = src.occupant.reagents.get_reagent_amount(src.med_tox)

			// We always inject this, even when emagged to mask the fact we're malfunctioning.
			// Otherwise, one glance at the control console would be sufficient.
			if (rejuv < 10)
				var/inject_r = 5
				if ((rejuv + 5) > 10)
					inject_r = max(0, (10 - rejuv))
				src.occupant.reagents.add_reagent(src.med_stabilizer, inject_r)

			// No life-saving meds for you, buddy.
			if (src.emagged)
				var/our_poison = pick(src.med_emag)
				var/poison = src.occupant.reagents.get_reagent_amount(our_poison)
				if (poison < 5)
					var/inject_p = 2.5
					if ((poison + 2.5) > 5)
						inject_p = max(0, (2.5 - poison))
					src.occupant.reagents.add_reagent(our_poison, inject_p)
					//DEBUG("Injected occupant with [inject_p] units of [our_poison] at [log_loc(src)].")
					if (manual_injection == 1)
						logTheThing("station", user_feedback, src.occupant, "manually injects %target% with [our_poison] ([inject_p]) from an emagged sleeper at [log_loc(src)].")
			else
				if (src.occupant.health < -25 && crit < 10)
					var/inject_c = 5
					if ((crit + 5) > 10)
						inject_c = max(0, (10 - crit))
					src.occupant.reagents.add_reagent(src.med_crit, inject_c)

				if (src.occupant.get_oxygen_deprivation() >= 15 && oxy < 10)
					var/inject_o = 5
					if ((oxy + 5) > 10)
						inject_o = max(0, (10 - oxy))
					src.occupant.reagents.add_reagent(src.med_oxy, inject_o)

				if (src.occupant.get_toxin_damage() >= 15 && tox < 10)
					var/inject_t = 5
					if ((tox + 5) > 10)
						inject_t = max(0, (10 - tox))
					src.occupant.reagents.add_reagent(src.med_tox, inject_t)

			src.no_med_spam = world.time

		return

	proc/go_out()
		if (!src || !src.occupant)
			return
		for (var/obj/O in src)
			O.set_loc(src.loc)
		src.add_fingerprint(usr)
		src.occupant.set_loc(src.loc)
		src.occupant.weakened = 2
		src.occupant = null
		src.update_icon()
		return

	verb/move_inside()
		set src in oview(1)
		set category = "Local"

		if (!src) return
		if (usr.stat || usr.stunned || usr.weakened || usr.paralysis) return
		if (src.occupant)
			usr.show_text("The [src.name] is already occupied!", "red")
			return
		usr.pulling = null
		usr.set_loc(src)
		src.occupant = usr
		src.update_icon()
		for (var/obj/O in src)
			O.set_loc(src.loc)
		return

	verb/eject()
		set src in oview(1)
		set category = "Local"

		if (!src) return
		if (usr.stat != 0 || usr.stunned != 0) return
		src.go_out()
		return

	//Sleeper communication over powernet link thing.
	receive_signal(datum/signal/signal)
		if(stat & (NOPOWER|BROKEN) || !src.link)
			return
		if(!signal || !src.net_id || signal.encryption)
			return

		if(signal.transmission_method != TRANSMISSION_WIRE) //No radio for us thanks
			return

		//They don't need to target us specifically to ping us.
		//Otherwise, ff they aren't addressing us, ignore them
		if(signal.data["address_1"] != src.net_id)
			if((signal.data["address_1"] == "ping") && signal.data["sender"])
				var/datum/signal/pingsignal = get_free_signal()
				pingsignal.data["device"] = "MED_SLEEPER"
				pingsignal.data["netid"] = src.net_id
				pingsignal.data["address_1"] = signal.data["sender"]
				pingsignal.data["command"] = "ping_reply"
				pingsignal.data["sender"] = src.net_id
				pingsignal.transmission_method = TRANSMISSION_WIRE
				spawn(5) //Send a reply for those curious jerks
					src.link.post_signal(src, pingsignal)

			return

		var/sigcommand = lowertext(signal.data["command"])
		if(!sigcommand || !signal.data["sender"])
			return

		switch(sigcommand)
			if("status") //How is our patient doing?
				var/patient_stat = "NONE"
				if(src.occupant)
					patient_stat = "[src.occupant.get_brute_damage()];[src.occupant.get_burn_damage()];[src.occupant.get_toxin_damage()];[src.occupant.get_oxygen_deprivation()]"

				var/datum/signal/reply = new
				reply.data["command"] = "device_reply"
				reply.data["status"] = patient_stat
				reply.data["address_1"] = signal.data["sender"]
				reply.data["sender"] = src.net_id
				reply.transmission_method = TRANSMISSION_WIRE
				spawn(5)
					src.link.post_signal(src, reply)

			if("inject")
				src.inject(null, 1)

		return

/obj/machinery/sleeper/portable
	name = "Port-A-Medbay"
	desc = "Huh... so that's where it went..."
	icon = 'icons/obj/porters.dmi'
	icon_state = "med_0"
	anchored = 0

	update_icon()
		icon_state = "med_[!isnull(occupant)]"
		return