/client/proc/gearspawn_traitor()
	set category = "Commands"
	set name = "Call Syndicate"
	set desc="Teleports useful items to your location."

	if (usr.stat || !isliving(usr) || isintangible(usr))
		usr.show_text("You can't use this command right now.", "red")
		return

	var/obj/item/uplink/syndicate/U = new(usr.loc)
	if (!usr.put_in_hand(U))
		U.set_loc(get_turf(usr))
		usr.show_text("<h3>Uplink spawned. You can find it on the floor at your current location.</h3>", "blue")
	else
		usr.show_text("<h3>Uplink spawned. You can find it in your active hand.</h3>", "blue")

	if (usr.mind && istype(usr.mind))
		U.lock_code_autogenerate = 1
		U.setup(usr.mind)
		usr.show_text("<h3>The password to your uplink is '[U.lock_code]'.</h3>", "blue")
		usr.mind.store_memory("<B>Uplink password:</B> [U.lock_code].")

	usr.verbs -= /client/proc/gearspawn_traitor

	return

/client/proc/gearspawn_wizard()
	set category = "Commands"
	set name = "Call Wizards"
	set desc="Teleports useful items to your location."

	if (usr.stat || !isliving(usr) || isintangible(usr))
		usr.show_text("You can't use this command right now.", "red")
		return

	if (!istype(usr,/mob/living/carbon/human))
		boutput(usr, "<span style=\"color:red\">You must be a human to use this!</span>")
		return

	var/mob/living/carbon/human/H = usr

	equip_wizard(H, 1)

	usr.verbs -= /client/proc/gearspawn_wizard

	return

/proc/equip_traitor(mob/living/carbon/human/traitor_mob)
	if (!(traitor_mob && ishuman(traitor_mob)))
		return

	var/freq = null
	var/pda_pass = null

	// find a radio! toolbox(es), backpack, belt, headset
	var/loc = ""
	var/obj/item/device/R = null //Hide the uplink in a PDA if available, otherwise radio
	if (!R && istype(traitor_mob.belt, /obj/item/device/pda2))
		R = traitor_mob.belt
		loc = "on your belt"
	if (!R && istype(traitor_mob.r_store, /obj/item/device/pda2))
		R = traitor_mob.r_store
		loc = "In your pocket"
	if (!R && istype(traitor_mob.l_store, /obj/item/device/pda2))
		R = traitor_mob.l_store
		loc = "In your pocket"
	if (!R && istype(traitor_mob.ears, /obj/item/device/radio))
		R = traitor_mob.ears
		loc = "on your head"
	if (!R && traitor_mob.w_uniform && istype(traitor_mob.belt, /obj/item/device/radio))
		R = traitor_mob.belt
		loc = "on your belt"
	if (!R && istype(traitor_mob.l_hand, /obj/item/storage))
		var/obj/item/storage/S = traitor_mob.l_hand
		var/list/L = S.get_contents()
		for (var/obj/item/device/radio/foo in L)
			R = foo
			loc = "in the [S.name] in your left hand"
			break
	if (!R && istype(traitor_mob.r_hand, /obj/item/storage))
		var/obj/item/storage/S = traitor_mob.r_hand
		var/list/L = S.get_contents()
		for (var/obj/item/device/radio/foo in L)
			R = foo
			loc = "in the [S.name] in your right hand"
			break
	if (!R && istype(traitor_mob.back, /obj/item/storage))
		var/obj/item/storage/S = traitor_mob.back
		var/list/L = S.get_contents()
		for (var/obj/item/device/radio/foo in L)
			R = foo
			loc = "in the [S.name] in your backpack"
			break
		if(!R)
			R = new /obj/item/device/radio/headset(traitor_mob)
			loc = "in the [S.name] in your backpack"
			// Everything else failed and there's no room in the backpack either, oh no.
			// I mean, we can't just drop a super-obvious uplink onto the floor. Hands might be full, too (Convair880).
			if (traitor_mob.equip_if_possible(R, traitor_mob.slot_in_backpack) == 0)
				qdel(R)
				traitor_mob.verbs += /client/proc/gearspawn_traitor
				traitor_mob << browse(grabResource("html/traitorTips/traitorradiouplinkTips.html"),"window=antagTips;titlebar=1;size=600x400;can_minimize=0;can_resize=0")
				return
	if (!R)
		traitor_mob.verbs += /client/proc/gearspawn_traitor
		traitor_mob << browse(grabResource("html/traitorTips/traitorradiouplinkTips.html"),"window=antagTips;titlebar=1;size=600x400;can_minimize=0;can_resize=0")
	else
		if (!(ticker && ticker.mode && istype(ticker.mode, /datum/game_mode/revolution)) && !(traitor_mob.mind && traitor_mob.mind.special_role == "Spy"))
			traitor_mob << browse(grabResource("html/traitorTips/traitorTips.html"),"window=antagTips;titlebar=1;size=600x400;can_minimize=0;can_resize=0")

		if (istype(R, /obj/item/device/radio))
			var/obj/item/device/radio/RR = R
			var/obj/item/uplink/integrated/radio/T = new /obj/item/uplink/integrated/radio(RR)
			T.setup(traitor_mob.mind, RR)
			freq = RR.traitor_frequency

			boutput(traitor_mob, "The Syndicate have cunningly disguised a Syndicate Uplink as your [RR.name] [loc]. Simply dial the frequency [format_frequency(freq)] to unlock its hidden features.")
			traitor_mob.mind.store_memory("<B>Radio Freq:</B> [format_frequency(freq)] ([RR.name] [loc]).")

		else if (istype(R, /obj/item/device/pda2))
			var/obj/item/device/pda2/P = R
			var/obj/item/uplink/integrated/pda/T = new /obj/item/uplink/integrated/pda(P)
			T.setup(traitor_mob.mind, P)
			pda_pass = T.lock_code

			boutput(traitor_mob, "The Syndicate have cunningly disguised a Syndicate Uplink as your [P.name] [loc]. Simply enter the code \"[pda_pass]\" into the ringtone select to unlock its hidden features.")
			traitor_mob.mind.store_memory("<B>Set your ringtone to:</B> [pda_pass] (In the Messenger menu in the [P.name] [loc]).")

/proc/equip_syndicate(mob/living/carbon/human/synd_mob)
	if (!ishuman(synd_mob))
		return

	synd_mob.equip_if_possible(new /obj/item/device/radio/headset/syndicate(synd_mob), synd_mob.slot_ears)
	synd_mob.equip_if_possible(new /obj/item/clothing/under/misc/syndicate(synd_mob), synd_mob.slot_w_uniform)
	synd_mob.equip_if_possible(new /obj/item/clothing/shoes/swat(synd_mob), synd_mob.slot_shoes)
	synd_mob.equip_if_possible(new /obj/item/clothing/suit/armor/vest(synd_mob), synd_mob.slot_wear_suit)
	synd_mob.equip_if_possible(new /obj/item/clothing/gloves/swat(synd_mob), synd_mob.slot_gloves)
	synd_mob.equip_if_possible(new /obj/item/clothing/head/helmet/swat(synd_mob), synd_mob.slot_head)
	synd_mob.equip_if_possible(new /obj/item/storage/backpack(synd_mob), synd_mob.slot_back)
	synd_mob.equip_if_possible(new /obj/item/ammo/bullets/a357(synd_mob), synd_mob.slot_in_backpack)
	synd_mob.equip_if_possible(new /obj/item/reagent_containers/pill/tox(synd_mob), synd_mob.slot_in_backpack)
	synd_mob.equip_if_possible(new /obj/item/remote/syndicate_teleporter(synd_mob), synd_mob.slot_l_store)
	synd_mob.equip_if_possible(new /obj/item/gun/kinetic/revolver(synd_mob), synd_mob.slot_belt)

	var/obj/item/uplink/syndicate/U = new /obj/item/uplink/syndicate(synd_mob)
	if (synd_mob.mind && istype(synd_mob.mind))
		U.setup(synd_mob.mind)
	synd_mob.equip_if_possible(U, synd_mob.slot_r_store)

	var/obj/item/card/id/syndicate/I = new /obj/item/card/id/syndicate(synd_mob) // for whatever reason, this is neccessary
	I.icon_state = "id"
	I.icon = 'icons/obj/card.dmi'
	synd_mob.equip_if_possible(I, synd_mob.slot_wear_id)

	var/obj/item/implant/syn/S = new /obj/item/implant/syn(synd_mob)
	S.implanted = 1
	S.implanted(synd_mob)

	var/obj/item/implant/microbomb/M = new /obj/item/implant/microbomb(synd_mob)
	M.implanted = 1
	M.implanted(synd_mob)
	S.owner = synd_mob
	synd_mob.implant.Add(S)

	var/the_frequency = R_FREQ_SYNDICATE
	if (ticker && ticker.mode && istype(ticker.mode, /datum/game_mode/nuclear))
		var/datum/game_mode/nuclear/N = ticker.mode
		the_frequency = N.agent_radiofreq

	for (var/obj/item/device/radio/headset/R in synd_mob.contents)
		if (!R.secure_frequencies)
			R.secure_frequencies = list ("h" = the_frequency)
		else
			R.secure_frequencies["h"] = the_frequency

		R.secure_colors = list(RADIOC_SYNDICATE)
		R.protected_radio = 1 // Ops can spawn with the deaf trait.
		R.frequency = the_frequency // let's see if this stops rounds from being ruined every fucking time

	return