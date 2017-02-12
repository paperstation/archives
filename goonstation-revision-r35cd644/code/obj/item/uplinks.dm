/*
Contains:
- Uplink parent
- Generic Syndicate uplink
- Integrated uplink (PDA & headset)
- Wizard's spellbook

Note: Add new traitor items to syndicate_buylist.dm, not here.
      Every type of Syndicate uplink now includes support for job- and objective-specific items.
*/

/////////////////////////////////////////// Uplink parent ////////////////////////////////////////////

/obj/item/uplink
	name = "uplink"
	stamina_damage = 25
	stamina_cost = 25
	stamina_crit_chance = 10

	var/uses = 12 // Amount of telecrystals.
	var/list/datum/syndicate_buylist/items_general = list() // See setup().
	var/list/datum/syndicate_buylist/items_job = list()
	var/list/datum/syndicate_buylist/items_objective = list()
	var/is_VR_uplink = 0
	var/lock_code = null
	var/lock_code_autogenerate = 0
	var/locked = 0

	var/use_default_GUI = 0 // Use the parent's HTML interface (less repeated code).
	var/temp = null
	var/selfdestruct = 0
	var/can_selfdestruct = 0
	var/datum/syndicate_buylist/reading_about = null

	// Spawned uplinks for which setup() wasn't called manually only get the standard (generic) items.
	New()
		spawn (10)
			if (src && istype(src) && (!src.items_general.len && !src.items_job.len && !src.items_objective.len))
				src.setup()
		return

	proc/generate_code()
		if (!src || !istype(src))
			return

		var/code = "[rand(100,999)] [pick("Alpha","Bravo","Delta","Omega","Gamma","Zeta")]"
		return code

	proc/setup(var/datum/mind/ownermind, var/obj/item/device/master)
		if (!src || !istype(src))
			return

		if (!islist(src.items_general))
			src.items_general = list()
		if (!islist(src.items_job))
			src.items_job = list()
		if (!islist(src.items_objective))
			src.items_objective = list()

		for (var/datum/syndicate_buylist/S in syndi_buylist_cache)
			var/blocked = 0
			if (ticker && ticker.mode && S.blockedmode && islist(S.blockedmode) && S.blockedmode.len)
				for (var/V in S.blockedmode)
					if (ispath(V) && istype(ticker.mode, V) && !src.is_VR_uplink) // No meta by checking VR uplinks.
						blocked = 1
						break

			if (blocked == 0)
				if (istype(S, /datum/syndicate_buylist/surplus))
					continue
				if (istype(S, /datum/syndicate_buylist/generic) && !src.items_general.Find(S))
					src.items_general.Add(S)

				if (ownermind || istype(ownermind))
					if (ownermind.special_role != "nukeop" && istype(S, /datum/syndicate_buylist/traitor))
						if (!S.objective && !S.job && !src.items_general.Find(S))
							src.items_general.Add(S)

					if (S.objective)
						if (ownermind.objectives)
							var/has_objective = 0
							for (var/datum/objective/O in ownermind.objectives)
								if (istype(O, S.objective))
									has_objective = 1
							if (has_objective && !src.items_objective.Find(S))
								src.items_objective.Add(S)

					if (S.job)
						for (var/allowedjob in S.job)
							if (ownermind.assigned_role && ownermind.assigned_role == allowedjob && !src.items_job.Find(S))
								src.items_job.Add(S)

		// Sort alphabetically by item name.
		var/list/names = list()
		var/list/namecounts = list()

		if (src.items_general.len)
			var/list/sort1 = list()

			for (var/datum/syndicate_buylist/S1 in src.items_general)
				var/name = S1.name
				if (name in names) // Should never, ever happen, but better safe than sorry.
					namecounts[name]++
					name = text("[] ([])", name, namecounts[name])
				else
					names.Add(name)
					namecounts[name] = 1

				sort1[name] = S1

			src.items_general = sortList(sort1)

		if (src.items_job.len)
			var/list/sort2 = list()

			for (var/datum/syndicate_buylist/S2 in src.items_job)
				var/name = S2.name
				if (name in names)
					namecounts[name]++
					name = text("[] ([])", name, namecounts[name])
				else
					names.Add(name)
					namecounts[name] = 1

				sort2[name] = S2

			src.items_job = sortList(sort2)

		if (src.items_objective.len)
			var/list/sort3 = list()

			for (var/datum/syndicate_buylist/S3 in src.items_objective)
				var/name = S3.name
				if (name in names)
					namecounts[name]++
					name = text("[] ([])", name, namecounts[name])
				else
					names.Add(name)
					namecounts[name] = 1

				sort3[name] = S3

			src.items_objective = sortList(sort3)

		return

	proc/vr_check(var/mob/user)
		if (!src || !istype(src) || !user || !ismob(user))
			return 0
		if (src.is_VR_uplink == 0)
			return 1

		var/area/A = get_area(user)
		if (!A || !istype(A, /area/sim))
			return 0
		else
			return 1

	proc/explode()
		if (!src || !istype(src))
			return

		if (src.can_selfdestruct == 1)
			var/turf/location = get_turf(src.loc)
			if (location && isturf(location))
				location.hotspot_expose(700,125)
				explosion(src, location, 0, 0, 2, 4)
			qdel(src)

		return

	attack_self(mob/user as mob)
		if (src.vr_check(user) != 1)
			user.show_text("This uplink only works in virtual reality.", "red")
		else if (src.use_default_GUI == 1)
			user.machine = src
			src.generate_menu()
		return

	proc/generate_menu()
		if (src.uses < 0)
			src.uses = 0
		if (src.use_default_GUI == 0)
			return

		var/dat
		if (src.selfdestruct)
			dat = "Self Destructing..."

		else if (src.locked && !isnull(src.lock_code))
			dat = "The uplink is locked. <A href='byond://?src=\ref[src];unlock=1'>Enter password</A>.<BR>"

		else if (reading_about)
			var/item_about = "<b>Error:</b> We're sorry, but there is no current entry for this item!<br>For full information on Syndicate Tools, call 1-555-SYN-DKIT."
			if(reading_about.desc) item_about = "[reading_about.desc]"
			dat += "<b>Extended Item Information:</b><hr>[item_about]<hr><A href='byond://?src=\ref[src];back=1'>Back</A>"

		else
			if (src.temp)
				dat = "[src.temp]<BR><BR><A href='byond://?src=\ref[src];temp=1'>Clear</A>"
			else
				if (src.is_VR_uplink)
					dat = "<B><U>Syndicate Simulator 2053!</U></B><BR>"
					dat += "Buy the Cat Armor DLC today! Only 250 Credits!"
					dat += "<HR>"
					dat += "<B>Sandbox mode - Spawn item:</B><BR><table cellspacing=5>"
				else
					dat = "<B>Syndicate Uplink Console:</B><BR>"
					dat += "Tele-Crystals left: [src.uses]<BR>"
					dat += "<HR>"
					dat += "<B>Request item:</B><BR>"
					dat += "<I>Each item costs a number of tele-crystals as indicated by the number following their name.</I><BR><table cellspacing=5>"

				if (src.items_general && islist(src.items_general) && src.items_general.len)
					for (var/G in src.items_general)
						var/datum/syndicate_buylist/I1 = src.items_general[G]
						dat += "<tr><td><A href='byond://?src=\ref[src];spawn=\ref[src.items_general[G]]'>[I1.name]</A> ([I1.cost])</td><td><A href='byond://?src=\ref[src];about=\ref[src.items_general[G]]'>About</A></td>"
				if (src.items_job && islist(src.items_job) && src.items_job.len)
					dat += "</table><B>Job specific:</B><BR><table cellspacing=5>"
					for (var/J in src.items_job)
						var/datum/syndicate_buylist/I2 = src.items_job[J]
						dat += "<tr><td><A href='byond://?src=\ref[src];spawn=\ref[src.items_job[J]]'>[I2.name]</A> ([I2.cost])</td><td><A href='byond://?src=\ref[src];about=\ref[src.items_job[J]]'>About</A></td>"
				if (src.items_objective && islist(src.items_objective) && src.items_objective.len)
					dat += "</table><B>Objective specific:</B><BR><table cellspacing=5>"
					for (var/O in src.items_objective)
						var/datum/syndicate_buylist/I3 = src.items_objective[O]
						dat += "<tr><td><A href='byond://?src=\ref[src];spawn=\ref[src.items_objective[O]]'>[I3.name]</A> ([I3.cost])</td><td><A href='byond://?src=\ref[src];about=\ref[src.items_objective[O]]'>About</A></td>"

				dat += "</table>"
				var/do_divider = 1

				if (istype(src, /obj/item/uplink/integrated/radio))
					var/obj/item/uplink/integrated/radio/RU = src
					if (!isnull(RU.origradio) && istype(RU.origradio, /obj/item/device/radio))
						dat += "<HR><A href='byond://?src=\ref[src];lock=1'>Lock</A><BR>"
						do_divider = 0
				else if (src.is_VR_uplink == 0 && !isnull(src.lock_code))
					dat += "<HR><A href='byond://?src=\ref[src];lock=1'>Lock</A><BR>"
					do_divider = 0

				if (src.can_selfdestruct == 1)
					dat += "[do_divider == 1 ? "<HR>" : ""]<A href='byond://?src=\ref[src];selfdestruct=1'>Self-Destruct</A>"

		usr << browse(dat, "window=radio")
		onclose(usr, "radio")
		return

#define CHECK1 (get_dist(src, usr) > 1 || !usr.contents.Find(src) || !isliving(usr) || iswraith(usr) || isintangible(usr))
#define CHECK2 (usr.stunned > 0 || usr.weakened > 0 || usr.paralysis > 0 || usr.stat != 0 || usr.restrained())
	Topic(href, href_list)
		..()
		if (src.uses < 0)
			src.uses = 0
		if (src.use_default_GUI == 0)
			return
		if (CHECK1)
			return
		if (CHECK2)
			return
		if (src.vr_check(usr) != 1)
			usr.show_text("This uplink only works in virtual reality.", "red")
			return

		usr.machine = src

		if (href_list["unlock"] && src.locked && !isnull(src.lock_code))
			var/the_code = adminscrub(input(usr, "Please enter the password.", "Unlock Uplink", null))
			if (!src || !istype(src) || !usr || !ismob(usr) || CHECK1 || CHECK2)
				return
			if (isnull(the_code) || !cmptext(the_code, src.lock_code))
				usr.show_text("Incorrect password.", "red")
				return

			src.locked = 0
			usr.show_text("The uplink beeps softly and unlocks.", "blue")

		else if (href_list["lock"])
			if (istype(src, /obj/item/uplink/integrated/radio))
				var/obj/item/uplink/integrated/radio/RU = src
				if (!isnull(RU.origradio) && istype(RU.origradio, /obj/item/device/radio))
					usr.machine = null
					usr << browse(null, "window=radio")
					var/obj/item/device/radio/T = RU.origradio
					RU.set_loc(T)
					T.set_loc(usr)
					usr.u_equip(RU)
					usr.put_in_hand_or_drop(T)
					RU.set_loc(T)
					T.set_frequency(initial(T.frequency))
					T.attack_self(usr)
					return

			else if (src.locked == 0 && src.is_VR_uplink == 0)
				src.locked = 1
				usr.show_text("The uplink is now locked.", "blue")

		else if (href_list["spawn"])
			var/datum/syndicate_buylist/I = locate(href_list["spawn"])
			if (!I || !istype(I))
				usr.show_text("Something went wrong (invalid syndicate_buylist reference). Please try again and contact a coder if the problem persists.", "red")
				return

			if (src.is_VR_uplink == 0)
				if (src.uses < I.cost)
					boutput(usr, "<span style=\"color:red\">The uplink doesn't have enough telecrystals left for that!</span>")
					return
				src.uses = max(0, src.uses - I.cost)
				if (usr.mind)
					usr.mind.purchased_traitor_items += I

			if (I.item)
				var/obj/item = new I.item(get_turf(src))
				I.run_on_spawn(item, usr)
				if (src.is_VR_uplink == 0)
					statlog_traitor_item(usr, I.name, I.cost)
			if (I.item2)
				new I.item2(get_turf(src))
			if (I.item3)
				new I.item3(get_turf(src))

		else if (href_list["about"])
			reading_about = locate(href_list["about"])

		else if (href_list["back"])
			reading_about = null

		else if (href_list["selfdestruct"] && src.can_selfdestruct == 1)
			src.selfdestruct = 1
			spawn (100)
				if (src)
					src.explode()

		else if (href_list["temp"])
			src.temp = null

		src.attack_self(usr)
		return
#undef CHECK1
#undef CHECK2

/////////////////////////////////////////////// Syndicate uplink ////////////////////////////////////////////

/obj/item/uplink/syndicate
	name = "station bounced radio"
	icon = 'icons/obj/device.dmi'
	icon_state = "radio"
	flags = FPRINT | TABLEPASS | CONDUCT | ONBELT
	w_class = 2.0
	item_state = "radio"
	throw_speed = 4
	throw_range = 20
	m_amt = 100
	use_default_GUI = 1
	can_selfdestruct = 1

	setup(var/datum/mind/ownermind, var/obj/item/device/master)
		..()
		if (src.lock_code_autogenerate == 1)
			src.lock_code = src.generate_code()
			src.locked = 1

		return

/obj/item/uplink/syndicate/virtual
	name = "Syndicate Simulator 2053"
	desc = "Pretend you are a space terrorist! Harmless VR fun for all the family!"
	uses = INFINITY
	is_VR_uplink = 1
	can_selfdestruct = 0

	explode()
		src.temp = "Bang! Just kidding."
		return

///////////////////////////////////////////////// Integrated uplinks (PDA & headset) //////////////////////////////////

/obj/item/uplink/integrated
	name = "uplink module"
	desc = "An electronic uplink system of unknown origin."
	icon = 'icons/obj/module.dmi'
	icon_state = "power_mod"
	can_selfdestruct = 0

	explode()
		return

/obj/item/uplink/integrated/pda
	lock_code_autogenerate = 1
	var/obj/item/device/pda2/hostpda = null
	var/orignote = null //Restore original notes when locked.
	var/active = 0 //Are we currently active??
	var/menu_message = ""

	setup(var/datum/mind/ownermind, var/obj/item/device/master)
		..()
		if (master && istype(master))
			if (istype(master, /obj/item/device/pda2))
				var/obj/item/device/pda2/P = master
				P.uplink = src
				if (src.lock_code_autogenerate == 1)
					src.lock_code = src.generate_code()
				src.hostpda = P
		return

	proc/unlock()
		if ((isnull(src.hostpda)))
			return

		if(src.active)
			src.hostpda.host_program:mode = 1
			return

		if(istype(src.hostpda.host_program, /datum/computer/file/pda_program/os/main_os))

			src.orignote = src.hostpda.host_program:note
			src.active = 1
			src.hostpda.host_program:mode = 1 //Switch right to the notes program

		src.generate_menu()
		src.print_to_host(src.menu_message)
		return

	//Communicate with traitor through the PDA's note function.
	proc/print_to_host(var/text)
		if (isnull(src.hostpda))
			return

		if (!istype(src.hostpda.host_program, /datum/computer/file/pda_program/os/main_os))
			return
		src.hostpda.host_program:note = text

		for (var/mob/M in viewers(1, src.hostpda.loc))
			if (M.client && M.machine == src.hostpda)
				src.hostpda.attack_self(M)

		return

	//Let's build a menu!
	generate_menu()
		if (src.uses < 0)
			src.uses = 0
		if (src.vr_check(usr) != 1)
			src.menu_message = "This uplink only works in virtual reality."
			return

		src.menu_message = "<B>Syndicate Uplink Console:</B><BR>"
		src.menu_message += "Tele-Crystals left: [src.uses]<BR>"
		src.menu_message += "<HR>"
		src.menu_message += "<B>Request item:</B><BR>"
		src.menu_message += "<I>Each item costs a number of tele-crystals as indicated by the number following their name.</I><BR><table cellspacing=5>"

		if (src.items_general && islist(src.items_general) && src.items_general.len)
			for (var/G in src.items_general)
				var/datum/syndicate_buylist/I1 = src.items_general[G]
				src.menu_message += "<tr><td><A href='byond://?src=\ref[src];buy_item=\ref[src.items_general[G]]'>[I1.name]</A> ([I1.cost])</td><td><A href='byond://?src=\ref[src];abt_item=\ref[src.items_general[G]]'>About</A></td>"
		if (src.items_job && islist(src.items_job) && src.items_job.len)
			src.menu_message += "</table><B>Job specific:</B><BR><table cellspacing=5>"
			for (var/J in src.items_job)
				var/datum/syndicate_buylist/I2 = src.items_job[J]
				src.menu_message += "<tr><td><A href='byond://?src=\ref[src];buy_item=\ref[src.items_job[J]]'>[I2.name]</A> ([I2.cost])</td><td><A href='byond://?src=\ref[src];abt_item=\ref[src.items_job[J]]'>About</A></td>"
		if (src.items_objective && islist(src.items_objective) && src.items_objective.len)
			src.menu_message += "</table><B>Objective specific:</B><BR><table cellspacing=5>"
			for (var/O in src.items_objective)
				var/datum/syndicate_buylist/I3 = src.items_objective[O]
				src.menu_message += "<tr><td><A href='byond://?src=\ref[src];buy_item=\ref[src.items_objective[O]]'>[I3.name]</A> ([I3.cost])</td><td><A href='byond://?src=\ref[src];abt_item=\ref[src.items_objective[O]]'>About</A></td>"

		src.menu_message += "</table><HR>"
		return

	Topic(href, href_list)
		if (src.uses < 0)
			src.uses = 0
		if (isnull(src.hostpda) || !src.active)
			return
		if (get_dist(src.hostpda, usr) > 1 || !usr.contents.Find(src.hostpda) || !isliving(usr) || iswraith(usr) || isintangible(usr))
			return
		if (usr.stunned > 0 || usr.weakened > 0 || usr.paralysis > 0 || usr.stat != 0 || usr.restrained())
			return
		if (src.vr_check(usr) != 1)
			usr.show_text("This uplink only works in virtual reality.", "red")
			return

		if (href_list["buy_item"])
			var/datum/syndicate_buylist/I = locate(href_list["buy_item"])
			if (!I || !istype(I))
				usr.show_text("Something went wrong (invalid syndicate_buylist reference). Please try again and contact a coder if the problem persists.", "red")
				return

			if (src.is_VR_uplink == 0)
				if (src.uses < I.cost)
					boutput(usr, "<span style=\"color:red\">The uplink doesn't have enough telecrystals left for that!</span>")
					return
				src.uses = max(0, src.uses - I.cost)
				if (usr.mind)
					usr.mind.purchased_traitor_items += I

			if (I.item)
				var/obj/item = new I.item(get_turf(src.hostpda))
				I.run_on_spawn(item, usr)
				if (src.is_VR_uplink == 0)
					statlog_traitor_item(usr, I.name, I.cost)
			if (I.item2)
				new I.item2(get_turf(src.hostpda))
			if (I.item3)
				new I.item3(get_turf(src.hostpda))

		else if (href_list["abt_item"])
			var/datum/syndicate_buylist/I = locate(href_list["abt_item"])
			var/item_about = "<b>Error:</b> We're sorry, but there is no current entry for this item!<br>For full information on Syndicate Tools, call 1-555-SYN-DKIT."
			if(I.desc) item_about = I.desc

			src.print_to_host("<b>Extended Item Information:</b><hr>[item_about]<hr><A href='byond://?src=\ref[src];back=1'>Back</A>")
			return

		/*else if (href_list["back"])
			src.generate_menu()
			src.print_to_host(src.menu_message)
			return*/

		src.generate_menu()
		src.print_to_host(src.menu_message)
		return

/obj/item/uplink/integrated/radio
	lock_code_autogenerate = 1
	use_default_GUI = 1
	var/obj/item/device/radio/origradio = null

	generate_code()
		if (!src || !istype(src))
			return

		var/freq = 1441
		var/list/freqlist = list()
		while (freq <= 1489)
			if (freq < 1451 || freq > 1459)
				freqlist += freq
			freq += 2
			if ((freq % 2) == 0)
				freq += 1
		freq = freqlist[rand(1, freqlist.len)]
		return freq

	setup(var/datum/mind/ownermind, var/obj/item/device/master)
		..()
		if (master && istype(master))
			if (istype(master, /obj/item/device/radio))
				var/obj/item/device/radio/R = master
				R.traitorradio = src
				if (src.lock_code_autogenerate == 1)
					R.traitor_frequency = src.generate_code()
				R.protected_radio = 1
				src.name = R.name
				src.icon = R.icon
				src.icon_state = R.icon_state
				src.origradio = R
		return

///////////////////////////////////////// Wizard's spellbook ///////////////////////////////////////////////////

/obj/item/SWF_uplink
	name = "Spellbook"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "spellbook"
	item_state = "spellbook"
	var/wizard_key = ""
	var/temp = null
	var/uses = 4
	var/selfdestruct = 0
	var/traitor_frequency = 0
	var/obj/item/device/radio/origradio = null
	var/list/spells = list()
	flags = FPRINT | ONBELT | TABLEPASS
	throwforce = 5
	w_class = 2
	throw_speed = 4
	throw_range = 20
	m_amt = 100

	New()
		..()
		src.spells += new /datum/SWFuplinkspell/soulguard(src)
		src.spells += new /datum/SWFuplinkspell/staffofcthulhu(src)
		src.spells += new /datum/SWFuplinkspell/fireball(src)
		src.spells += new /datum/SWFuplinkspell/shockingtouch(src)
		src.spells += new /datum/SWFuplinkspell/iceburst(src)
		src.spells += new /datum/SWFuplinkspell/blind(src)
		src.spells += new /datum/SWFuplinkspell/clownsrevenge(src)
		src.spells += new /datum/SWFuplinkspell/rathensecret(src)
		src.spells += new /datum/SWFuplinkspell/forcewall(src)
		src.spells += new /datum/SWFuplinkspell/blink(src)
		src.spells += new /datum/SWFuplinkspell/teleport(src)
		src.spells += new /datum/SWFuplinkspell/warp(src)
		src.spells += new /datum/SWFuplinkspell/spellshield(src)
		src.spells += new /datum/SWFuplinkspell/doppelganger(src)
		src.spells += new /datum/SWFuplinkspell/knock(src)
		src.spells += new /datum/SWFuplinkspell/empower(src)
		src.spells += new /datum/SWFuplinkspell/summongolem(src)
		src.spells += new /datum/SWFuplinkspell/animatedead(src)
		src.spells += new /datum/SWFuplinkspell/pandemonium(src)
		//src.spells += new /datum/SWFuplinkspell/shockwave(src)
		src.spells += new /datum/SWFuplinkspell/bull(src)

/datum/SWFuplinkspell
	var/name = "Spell"
	var/eqtype = "Spell"
	var/desc = "This is a spell."
	var/cost = 1
	var/cooldown = null
	var/assoc_spell = null
	var/obj/item/assoc_item = null

	proc/SWFspell_CheckRequirements(var/mob/living/carbon/human/user,var/obj/item/SWF_uplink/book)
		if (!user || !book)
			return 999 // unknown error
		if (book.uses < src.cost)
			return 1 // ran out of points
		if (src.assoc_spell)
			if (user.abilityHolder.getAbility(assoc_spell))
				return 2

	proc/SWFspell_Purchased(var/mob/living/carbon/human/user,var/obj/item/SWF_uplink/book)
		if (!user || !book)
			return
		if (src.assoc_spell)
			user.abilityHolder.addAbility(src.assoc_spell)
		if (src.assoc_item)
			var/obj/item/I = new src.assoc_item(usr.loc)
			if (istype(I, /obj/item/staff) && usr.mind)
				var/obj/item/staff/S = I
				S.wizard_key = usr.mind.key
		book.uses -= src.cost

/datum/SWFuplinkspell/soulguard
	name = "Soulguard"
	eqtype = "Enchantment"
	desc = "Soulguard is basically a one-time do-over that teleports you back to the wizard shuttle and restores your life in the event that you die. However, the enchantment doesn't trigger if your body has been gibbed or otherwise destroyed. Also note that you will respawn completely naked."

	SWFspell_CheckRequirements(var/mob/living/carbon/human/user,var/obj/item/SWF_uplink/book)
		. = ..()
		if (user.spell_soulguard) return 2

	SWFspell_Purchased(var/mob/living/carbon/human/user,var/obj/item/SWF_uplink/book)
		..()
		user.spell_soulguard = 1

/datum/SWFuplinkspell/staffofcthulhu
	name = "Staff of Cthulhu"
	eqtype = "Equipment"
	desc = "The crew will normally steal your staff and run off with it to cripple your casting abilities, but that doesn't work so well with this version. Any non-wizard dumb enough to touch or pull the Staff of Cthulhu takes massive brain damage and is knocked down for quite a while, and hiding the staff in a closet or somewhere else is similarly ineffective given that you can summon it to your active hand at will. It also makes a much better bludgeoning weapon than the regular staff, hitting harder and occasionally inflicting brain damage."
	assoc_spell = /datum/targetable/spell/summon_staff
	assoc_item = /obj/item/staff/cthulhu

/datum/SWFuplinkspell/bull
	name = "Bull's Charge"
	eqtype = "Offensive"
	desc = "Records your movement for 4 seconds, after which a massive bull charges along the recorded path, smacking anyone unfortunate to get in its way (excluding yourself) and dealing a significant amount of brute damage in the process. Watch your head for loose items, they are thrown around too."
	cooldown = 15
	assoc_spell = /datum/targetable/spell/bullcharge

/datum/SWFuplinkspell/shockwave
	name = "Shockwave"
	eqtype = "Offensive"
	desc = "This spell will violently throw back any nearby objects or people.<br>Cooldown:"
	cooldown = 40
	assoc_spell = /datum/targetable/spell/shockwave

/datum/SWFuplinkspell/fireball
	name = "Fireball"
	eqtype = "Offensive"
	desc = "This spell allows you to fling a fireball at a nearby target of your choice. The fireball will explode, knocking down and burning anyone too close, including you."
	cooldown = 20
	assoc_spell = /datum/targetable/spell/fireball
/*
/datum/SWFuplinkspell/shockinggrasp
	name = "Shocking Grasp"
	eqtype = "Offensive"
	desc = "This spell cannot be used on a moving target due to the need for a very short charging sequence, but will instantly kill them, destroy everything they're wearing, and vaporize their body."
	cooldown = 60
	assoc_spell = /datum/targetable/spell/kill
*/
/datum/SWFuplinkspell/shockingtouch
	name = "Shocking Touch"
	eqtype = "Offensive"
	desc = "This spell cannot be used on a moving target due to the need for a very short charging sequence, but will instantly put them in critical condition, and shock and stun anyone close to them."
	cooldown = 80
	assoc_spell = /datum/targetable/spell/shock

/datum/SWFuplinkspell/iceburst
	name = "Ice Burst"
	eqtype = "Offensive"
	desc = "This spell fires freezing cold projectiles that will temporarily freeze the floor beneath them, and slow down targets on contact."
	cooldown = 20
	assoc_spell = /datum/targetable/spell/iceburst

/datum/SWFuplinkspell/blind
	name = "Blind"
	eqtype = "Offensive"
	desc = "This spell temporarily blinds and stuns a target of your choice."
	cooldown = 10
	assoc_spell = /datum/targetable/spell/blind

/datum/SWFuplinkspell/clownsrevenge
	name = "Clown's Revenge"
	eqtype = "Offensive"
	desc = "This spell turns an adjacent target into an obese, idiotic, horrible, and useless clown."
	cooldown = 125
	assoc_spell = /datum/targetable/spell/cluwne

/datum/SWFuplinkspell/rathensecret
	name = "Rathen's Secret"
	eqtype = "Offensive"
	desc = "This spell summons a shockwave that rips the arses off of your foes. If you're lucky, the shockwave might even sever an arm or leg."
	cooldown = 50
	assoc_spell = /datum/targetable/spell/rathens

/*/datum/SWFuplinkspell/lightningbolt
	name = "Lightning Bolt"
	eqtype = "Offensive"
	desc = "Fires a bolt of electricity in a cardinal direction. Causes decent damage, and can go through thin walls and solid objects. You need special HAZARDOUS robes to cast this!"
	cooldown = 20
	assoc_verb = */

/datum/SWFuplinkspell/forcewall
	name = "Forcewall"
	eqtype = "Defensive"
	desc = "This spell creates an unbreakable wall from where you stand that extends to your sides. It lasts for 30 seconds."
	cooldown = 10
	assoc_spell = /datum/targetable/spell/forcewall

/datum/SWFuplinkspell/blink
	name = "Blink"
	eqtype = "Defensive"
	desc = "This spell teleports you a short distance forwards. Useful for evasion or getting into areas."
	cooldown = 10
	assoc_spell = /datum/targetable/spell/blink

/datum/SWFuplinkspell/teleport
	name = "Teleport"
	eqtype = "Defensive"
	desc = "This spell teleports you to an area of your choice, but requires a short time to charge up."
	cooldown = 45
	assoc_spell = /datum/targetable/spell/teleport

/datum/SWFuplinkspell/warp
	name = "Warp"
	eqtype = "Defensive"
	desc = "This spell teleports a visible foe away from you."
	cooldown = 10
	assoc_spell = /datum/targetable/spell/warp

/datum/SWFuplinkspell/spellshield
	name = "Spell Shield"
	eqtype = "Defensive"
	desc = "This spell encases you in a magical shield that protects you from melee attacks and projectiles for 10 seconds. It also absorbs some of the blast of explosions."
	cooldown = 30
	assoc_spell = /datum/targetable/spell/magshield

/datum/SWFuplinkspell/doppelganger
	name = "Doppelganger"
	eqtype = "Defensive"
	desc = "This spell projects a decoy in the direction you were moving while rendering you invisible and capable of moving through solid matter for a few moments."
	cooldown = 30
	assoc_spell = /datum/targetable/spell/doppelganger

/datum/SWFuplinkspell/knock
	name = "Knock"
	eqtype = "Utility"
	desc = "This spell opens all doors, lockers, and crates up to five tiles away. It also blows open cyborg head compartments, damaging them and exposing their brains."
	cooldown = 10
	assoc_spell = /datum/targetable/spell/knock

/datum/SWFuplinkspell/empower
	name = "Empower"
	eqtype = "Utility"
	desc = "This spell causes you to turn into a hulk, and gain telekinesis for a short while."
	cooldown = 40
	assoc_spell = /datum/targetable/spell/mutate

/datum/SWFuplinkspell/summongolem
	name = "Summon Golem"
	eqtype = "Utility"
	desc = "This spell allows you to turn a reagent you currently hold (in a jar, bottle or other container) into a golem. Golems will attack your enemies, and release their contents as chemical smoke when destroyed."
	cooldown = 50
	assoc_spell = /datum/targetable/spell/golem

/datum/SWFuplinkspell/animatedead
	name = "Animate Dead"
	eqtype = "Utility"
	desc = "This spell infuses an adjacent human corpse with necromantic energy, creating a durable skeleton minion that seeks to pummel your enemies into oblivion."
	cooldown = 85
	assoc_spell = /datum/targetable/spell/animatedead

/datum/SWFuplinkspell/pandemonium
	name = "Pandemonium"
	eqtype = "Miscellaneous"
	desc = "This spell causes random effects to happen. Best used only by skilled wizards."
	cooldown = 40
	assoc_spell = /datum/targetable/spell/pandemonium

/obj/item/SWF_uplink/proc/explode()
	var/turf/location = get_turf(src.loc)
	location.hotspot_expose(700, 125)

	explosion(src, location, 0, 0, 2, 4)

	qdel(src.master)
	qdel(src)
	return

/obj/item/SWF_uplink/attack_self(mob/user as mob)
	if(!user.mind || (user.mind && user.mind.key != src.wizard_key))
		boutput(user, "<span style=\"color:red\"><b>The spellbook is magically attuned to someone else!</b></span>")
		return
	user.machine = src
	var/dat
	if (src.selfdestruct)
		dat = "Self Destructing..."
	else
		if (src.temp)
			dat = "[src.temp]<BR><BR><A href='byond://?src=\ref[src];temp=1'>Clear</A>"
		else
			dat = "<B>The Book of Spells</B><BR>"
			dat += "Magic Points left: [src.uses]<BR>"
			dat += "<HR>"
			dat += "<B>Request item:</B><BR>"
			for (var/datum/SWFuplinkspell/SP in src.spells)
				dat += "<A href='byond://?src=\ref[src];buyspell=\ref[SP]'><b>[SP.name]</b></A> ([SP.eqtype]) <A href='byond://?src=\ref[src];aboutspell=\ref[SP]'>(?)</A><br>"
			dat += "<HR>"
/*
			if (src.origradio)
				dat += "<A href='byond://?src=\ref[src];lock=1'>Lock</A><BR>"
				dat += "<HR>"
			dat += "<A href='byond://?src=\ref[src];selfdestruct=1'>Self-Destruct</A>"
*/
	user << browse(dat, "window=radio")
	onclose(user, "radio")
	return

/obj/item/SWF_uplink/Topic(href, href_list)
	..()
	if (usr.stat || usr.restrained())
		return
	var/mob/living/carbon/human/H = usr
	if (!( istype(H, /mob/living/carbon/human)))
		return 1
	if ((usr.contents.Find(src) || (in_range(src,usr) && istype(src.loc, /turf))))
		usr.machine = src

		if (href_list["buyspell"])
			var/datum/SWFuplinkspell/SP = locate(href_list["buyspell"])
			switch(SP.SWFspell_CheckRequirements(usr,src))
				if(1) boutput(usr, "<span style=\"color:red\">You have no more magic points to spend.</span>")
				if(2) boutput(usr, "<span style=\"color:red\">You already have this spell.</span>")
				if(999) boutput(usr, "<span style=\"color:red\">Unknown Error.</span>")
				else
					SP.SWFspell_Purchased(usr,src)

		else if (href_list["aboutspell"])
			var/datum/SWFuplinkspell/SP = locate(href_list["aboutspell"])
			src.temp = "[SP.desc]"
			if (SP.cooldown)
				src.temp += "<BR>It takes [SP.cooldown] seconds to recharge after use."

		else if (href_list["lock"] && src.origradio)
			// presto chango, a regular radio again! (reset the freq too...)
			usr.machine = null
			usr << browse(null, "window=radio")
			var/obj/item/device/radio/T = src.origradio
			var/obj/item/SWF_uplink/R = src
			R.set_loc(T)
			T.set_loc(usr)
			// R.layer = initial(R.layer)
			R.layer = 0
			usr.u_equip(R)
			usr.put_in_hand_or_drop(T)
			R.set_loc(T)
			T.set_frequency(initial(T.frequency))
			T.attack_self(usr)
			return

		else if (href_list["selfdestruct"])
			src.temp = "<A href='byond://?src=\ref[src];selfdestruct2=1'>Self-Destruct</A>"

		else if (href_list["selfdestruct2"])
			src.selfdestruct = 1
			spawn (100)
				explode()
				return
		else
			if (href_list["temp"])
				src.temp = null

		if (istype(src.loc, /mob))
			attack_self(src.loc)
		else
			for(var/mob/M in viewers(1, src))
				if (M.client)
					src.attack_self(M)

	//if (istype(H.wear_suit, /obj/item/clothing/suit/wizrobe))
	//	H.wear_suit.check_abilities()
	return