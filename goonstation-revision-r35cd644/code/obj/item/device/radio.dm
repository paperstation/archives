/obj/item/device/radio
	name = "station bounced radio"
	suffix = "\[3\]"
	icon_state = "walkietalkie"
	item_state = "walkietalkie"
	var/device_color = RADIOC_STANDARD
	var/last_transmission
	var/frequency = R_FREQ_DEFAULT
	var/list/secure_frequencies = null
	var/list/secure_colors = list("#E00000")
	var/protected_radio = 0 // Cannot be picked up by radio_brain bioeffect.
	var/traitor_frequency = 0.0
	var/obj/item/device/radio/patch_link = null
	var/obj/item/uplink/integrated/radio/traitorradio = null
	var/wires = WIRE_SIGNAL | WIRE_RECEIVE | WIRE_TRANSMIT
	var/b_stat = 0.0
	var/broadcasting = null
	var/listening = 1.0
	var/list/secure_connections = null
	var/datum/radio_frequency/radio_connection
	var/speaker_range = 2
	flags = FPRINT | TABLEPASS | ONBELT | CONDUCT
	throw_speed = 2
	throw_range = 9
	w_class = 2.0
	mats = 3
	var/const
		WIRE_SIGNAL = 1 //sends a signal, like to set off a bomb or electrocute someone
		WIRE_RECEIVE = 2
		WIRE_TRANSMIT = 4
		TRANSMISSION_DELAY = 5 // only 2/second/radio
	desc = "A portable, non-wearable radio for communicating over a specified frequency. Has a microphone and a speaker which can be independently toggled."

	// Moved initializaiton to world/New
var/list/headset_channel_lookup

/obj/item/device/radio/New()
	..()
	if(radio_controller)
		initialize()

/obj/item/device/radio/initialize()
	if (src.frequency < 1441 || src.frequency > 1489)
		world.log << "[src] ([src.type]) has a frequency of [src.frequency], sanitizing."
		src.frequency = sanitize_frequency(src.frequency)

	set_frequency(frequency)
	if(src.secure_frequencies)
		set_secure_frequencies()


/obj/item/device/radio
	proc
		set_frequency(new_frequency)
			radio_controller.remove_object(src, "[frequency]")
			frequency = new_frequency
			radio_connection = radio_controller.add_object(src, "[frequency]")

		set_secure_frequencies()
			if(istype(src.secure_frequencies))
				for (var/sayToken in src.secure_frequencies)
					var/frequency_id = src.secure_frequencies["[sayToken]"]
					if (frequency_id)
						if (!istype(src.secure_connections))
							src.secure_connections = list()
						src.secure_connections["[sayToken]"] = radio_controller.add_object(src, "[frequency_id]")
					else
						src.secure_frequencies -= "[sayToken]"

		set_secure_frequency(frequencyToken, newFrequency)
			if (!istype(src.secure_frequencies) || !frequencyToken || !newFrequency)
				return

			var/oldFrequency = src.secure_frequencies["[frequencyToken]"]
			if (oldFrequency)
				radio_controller.remove_object(src, "[oldFrequency]")

			src.secure_connections["[frequencyToken]"] = radio_controller.add_object(src, "[newFrequency]")
			src.secure_frequencies["[frequencyToken]"] = newFrequency
			return

/obj/item/device/radio/attack_self(mob/user as mob)
	user.machine = src
	var/t1
	if (src.b_stat)
		t1 = {"
-------<BR>
Green Wire: <A href='byond://?src=\ref[src];wires=4'>[src.wires & 4 ? "Cut" : "Mend"] Wire</A><BR>
Red Wire:   <A href='byond://?src=\ref[src];wires=2'>[src.wires & 2 ? "Cut" : "Mend"] Wire</A><BR>
Blue Wire:  <A href='byond://?src=\ref[src];wires=1'>[src.wires & 1 ? "Cut" : "Mend"] Wire</A><BR>-------<BR>"}
/*
		if (istype(src.secure_frequencies) && src.secure_frequencies.len)
			t1 += "Supplementary Channels:<br>"
			for (var/sayToken in src.secure_frequencies)
				t1 += "\[[format_frequency(src.secure_frequencies["[sayToken]"])]] (Activator: <b>[sayToken]</b>) <a href='byond://?src=\ref[src];removemodule=[sayToken]'>Remove</a><br>"
*/
	else
		t1 = "-------"
	var/dat = {"
<TT>
Microphone: [src.broadcasting ? "<A href='byond://?src=\ref[src];talk=0'>Engaged</A>" : "<A href='byond://?src=\ref[src];talk=1'>Disengaged</A>"]<BR>
Speaker: [src.listening ? "<A href='byond://?src=\ref[src];listen=0'>Engaged</A>" : "<A href='byond://?src=\ref[src];listen=1'>Disengaged</A>"]<BR>
Frequency:
<A href='byond://?src=\ref[src];freq=-10'>-</A>
<A href='byond://?src=\ref[src];freq=-2'>-</A>
[format_frequency(src.frequency)]
<A href='byond://?src=\ref[src];freq=2'>+</A>
<A href='byond://?src=\ref[src];freq=10'>+</A><BR>"}
	if (istype(src.secure_frequencies) && src.secure_frequencies.len)
		dat+= "Supplementary Channels:<br>"
		for (var/sayToken in src.secure_frequencies)
			dat += "[ headset_channel_lookup["[src.secure_frequencies["[sayToken]"]]"] ? headset_channel_lookup["[src.secure_frequencies["[sayToken]"]]"] : "???" ]: \[[format_frequency(src.secure_frequencies["[sayToken]"])]] (Activator: <b>[sayToken]</b>)<br>"

	dat += "[t1]</TT>"
	user << browse(dat, "window=radio")
	onclose(user, "radio")
	return

/obj/item/device/radio/Topic(href, href_list)
	//..()
	if (usr.stat)
		return
	if ((istype(usr, /mob/living/silicon)) || (src in usr) || (istype(src, /obj/item/device/radio/intercom) && (get_dist(src, usr) <= 1) && (istype(src.loc, /turf))) || (usr.loc == src.loc)) // Band-aid fix for intercoms, RE 'bounds_dist' check in the 'in_range' proc. Feel free to improve the implementation (Convair880).
		usr.machine = src
		if (href_list["track"])
			var/mob/target = locate(href_list["track"])
			var/mob/living/silicon/ai/A = locate(href_list["track2"])
			A.ai_actual_track(target)
			return
		if (href_list["freq"])
			var/new_frequency = sanitize_frequency(frequency + text2num(href_list["freq"]))
			set_frequency(new_frequency)

			if (!isnull(src.traitorradio) && src.traitor_frequency && src.frequency == src.traitor_frequency)
				usr.machine = null
				usr << browse(null, "window=radio")
				onclose(usr, "radio")
				// now transform the regular radio, into a (disguised)syndicate uplink!
				var/obj/item/uplink/integrated/radio/T = src.traitorradio
				var/obj/item/device/radio/R = src
				R.set_loc(T)
				usr.u_equip(R)
				usr.put_in_hand_or_drop(T)
				R.set_loc(T)
				T.attack_self(usr)
				return

		else if (href_list["talk"])
			src.broadcasting = text2num(href_list["talk"])

		else if (href_list["listen"])
			src.listening = text2num(href_list["listen"])

		else if (href_list["wires"])
			var/t1 = text2num(href_list["wires"])
			if (!( istype(usr.equipped(), /obj/item/wirecutters) ))
				return
			if (t1 & 1)
				if (src.wires & 1)
					src.wires &= 65534
				else
					src.wires |= 1
			else
				if (t1 & 2)
					if (src.wires & 2)
						src.wires &= 65533
					else
						src.wires |= 2
				else
					if (t1 & 4)
						if (src.wires & 4)
							src.wires &= 65531
						else
							src.wires |= 4
/*
		else if (href_list["removemodule"])
			var/tokenToRemove = ckey(href_list["removemodule"])
			if (!tokenToRemove || !(tokenToRemove in src.secure_frequencies))
				return

*/

		if (!( src.master ))
			if (istype(src.loc, /mob))
				attack_self(src.loc)
			else if (istype(src.loc, /obj))
				for(var/mob/M in src.loc)
					attack_self(M)
			else
				src.updateDialog()
		else
			if (istype(src.master.loc, /mob))
				src.attack_self(src.master.loc)
			else
				src.updateDialog()
		src.add_fingerprint(usr)
	else
		usr << browse(null, "window=radio")

/obj/item/device/radio/talk_into(mob/M as mob, messages, secure, real_name, lang_id)
	// According to a pair of DEBUG calls set up for testing, no radio jammer check for the src radio was performed.
	// As improbable as this sounds, there are bug reports too to back up the findings. So uhm...
	if (src.radio_connection.check_for_jammer(src) != 0)
		return
	if (!(src.wires & 4))
		return
//	if (last_transmission && world.time < (last_transmission + TRANSMISSION_DELAY))
//		return

	var/eqjobname

	if (iscarbon(M))
		if (hasvar(M, "wear_id"))
			if (M:wear_id)
				eqjobname = M:wear_id:assignment
			else
				eqjobname = "No ID"
	else if (isAI(M))
		eqjobname = "AI"
	else if (isrobot(M))
		eqjobname = "Cyborg"
	else if (istype(M, /obj/machinery/computer)) // :v
		eqjobname = "Computer"
	else
		eqjobname = "Unknown"

	var/list/receive = list()

	var/display_freq = src.frequency //Frequency to display on radio broadcast messages

	var/datum/radio_frequency/connection = null
	if (secure && src.secure_connections && istype(src.secure_connections["[secure]"], /datum/radio_frequency))
		connection = src.secure_connections["[secure]"]
		display_freq = src.secure_frequencies["[secure]"]
	else
		connection = src.radio_connection
		secure = 0

	for (var/obj/item/device/radio/R in connection.devices)
		if (connection.check_for_jammer(R))
			continue
		if (R.accept_rad(src, messages, connection))
			for (var/i in R.send_hear())
				if (!(i in receive))
					receive += i

	// Don't let them monitor Syndie headsets. You can get the radio_brain bioeffect at the start of the round, basically.
	if (src.protected_radio != 1 && isnull(src.traitorradio))
		for (var/mob/living/L in radio_brains)
			receive += L

	for (var/mob/dead/D in mobs)
		if (D.client && (istype(D, /mob/dead/observer) || (istype(D, /mob/wraith) && !D.density)) || ((!isturf(src.loc) && src.loc == D.loc) && !istype(D, /mob/dead/target_observer)))
			if (!(D in receive))
				receive += D

	var/list/heard_masked = list() // masked name or no real name
	var/list/heard_normal = list() // normal message
	var/list/heard_voice = list() // voice message
	var/list/heard_garbled = list() // garbled message

	// Receiving mobs
	for (var/mob/R in receive)
		if (R.say_understands(M, lang_id))
			if (!ishuman(M) || (ishuman(M) && M.wear_mask && M.wear_mask.vchange))//istype(M.wear_mask, /obj/item/clothing/mask/gas/voice))
				heard_masked += R
			else
				heard_normal += R
		else
			if (M.voice_message)
				heard_voice += R
			else
				heard_garbled += R

		//DEBUG("Message transmitted. Frequency: [display_freq]. Source: [src] at [log_loc(src)]. Receiver: [R] at [log_loc(R)].")

	var/rendered

	if (length(heard_masked) || length(heard_normal) || length(heard_voice) || length(heard_garbled))
		var/textColor = null
		if (secure)
			textColor = secure_colors["[secure]"]
			if (!textColor)
				if (secure_colors.len)
					textColor = secure_colors[1]
				else
					textColor = "#E00000"

		var/part_a
		if (ismob(M) && M.mind)
			part_a = "<span class='radio' style='color: [secure ? textColor : src.device_color]'><span class='name' data-ctx='\ref[M.mind]'>"
		else
			part_a = "<span class='radio' style='color: [secure ? textColor : src.device_color]'><span class='name'>"
		var/part_b = "</span><b> [bicon(src)]\[[format_frequency(display_freq)]\]</b> <span class='message'>"
		var/part_c = "</span></span>"

		if (length(heard_masked))
			if (ishuman(M))
				if (M:wear_id)
					rendered = "[part_a][M:wear_id:registered][part_b][M.say_quote(messages[1])][part_c]"
				else
					rendered = "[part_a]Unknown[part_b][M.say_quote(messages[1])][part_c]"
			else
				rendered = "[part_a][M.name][part_b][M.say_quote(messages[1])][part_c]"

			for (var/mob/R in heard_masked)
				var/thisR = rendered
				if (isAI(R))
					thisR = "[part_a]<a href='byond://?src=\ref[src];track2=\ref[R];track=\ref[M]'>[M.name] ([eqjobname]) </a>[part_b][M.say_quote(messages[1])][part_c]"

				if (R.client && R.client.holder && ismob(M) && M.mind)
					thisR = "<span class='adminHearing' data-ctx='[R.client.chatOutput.ctxFlag]'>[thisR]</span>"
				R.show_message(thisR, 2)

		if (length(heard_normal))
			rendered = "[part_a][real_name ? real_name : M.real_name][part_b][M.say_quote(messages[1])][part_c]"
			for (var/mob/R in heard_normal)
				var/thisR = rendered
				if (isAI(R))
					thisR = "[part_a]<a href='byond://?src=\ref[src];track2=\ref[R];track=\ref[M]'>[real_name ? real_name : M.real_name] ([eqjobname]) </a>[part_b][M.say_quote(messages[1])][part_c]"

				if (R.client && R.client.holder && M.mind)
					thisR = "<span class='adminHearing' data-ctx='[R.client.chatOutput.ctxFlag]'>[thisR]</span>"
				R.show_message(thisR, 2)

		if (length(heard_voice))
			rendered = "[part_a][M.voice_name][part_b][M.voice_message][part_c]"
			for (var/mob/R in heard_voice)
				var/thisR = rendered
				if (isAI(R))
					thisR = "[part_a]<a href='byond://?src=\ref[src];track2=\ref[R];track=\ref[M]'>[M.voice_name] ([eqjobname]) </a>[part_b][M.voice_message][part_c]"

				if (R.client && R.client.holder && M.mind)
					thisR = "<span class='adminHearing' data-ctx='[R.client.chatOutput.ctxFlag]'>[thisR]</span>"
				R.show_message(thisR, 2)

		if (length(heard_garbled))
			rendered = "[part_a][M.voice_name][part_b][M.say_quote(messages[2])][part_c]"
			for (var/mob/R in heard_garbled)
				var/thisR = rendered
				if (isAI(R))
					thisR = "[part_a]<a href='byond://?src=\ref[src];track2=\ref[R];track=\ref[M]'>[M.voice_name]</a>[part_b][M.say_quote(messages[2])][part_c]"

				if (R.client && R.client.holder && M.mind)
					thisR = "<span class='adminHearing' data-ctx='[R.client.chatOutput.ctxFlag]'>[thisR]</span>"
				R.show_message(thisR, 2)

/obj/item/device/radio/hear_talk(mob/M as mob, msgs, real_name, lang_id)
	if (src.broadcasting)
		talk_into(M, msgs, null, real_name, lang_id)

// Hope I didn't butcher this, but I couldn't help but notice some odd stuff going on when I tried to debug radio jammers (Convair880).
/obj/item/device/radio/proc/accept_rad(obj/item/device/radio/R as obj, message, var/datum/radio_frequency/freq)
	if (message)
		// Simple frequency match. The only check that used to be here.
		if (src.frequency == R.frequency)
			//DEBUG("Match found for transmission from [R] at [log_loc(R)] (simple frequency match)")
			return 1

		// Secure channel lookup when R.frequency != src.frequency. According to DEBUG calls set up for testing,
		// this meant the receiving radio would decline the message even though both share a secure channel.
		else if (src.secure_connections && istype(src.secure_connections) && src.secure_connections.len && freq && istype(freq))
			var/list/datum/radio_frequency/RF = list()

			for (var/key in src.secure_connections)
				if (!RF.Find(src.secure_connections["[key]"]) && istype(src.secure_connections["[key]"], /datum/radio_frequency))
					RF.Add(src.secure_connections["[key]"])

			// Secure channel match. Easy.
			if (RF.Find(freq) && freq.devices.Find(src))
				//DEBUG("Match found for transmission from [R] at [log_loc(R)] (list/devices match)")
				return 1

			// Sender didn't use a secure channel prefix, giving us the 145.9 radio frequency datum.
			// The devices list is useless here, but we can still receive the message if one of our
			// secure channels happens to have the same frequency as the sender's radio.
			if (src.secure_frequencies && istype(src.secure_frequencies) && src.secure_frequencies.len)
				for (var/freq2 in src.secure_frequencies)
					if (isnum(src.secure_frequencies["[freq2]"]) && src.secure_frequencies["[freq2]"] == R.frequency)
						//DEBUG("Match found for transmission from [R] at [log_loc(R)] (frequency compare)")
						return 1

	return 0

/obj/item/device/radio/proc/send_hear()

	last_transmission = world.time
	if ((src.listening && src.wires & 2))
		var/list/hear = hearers(src.speaker_range, src.loc) // changed so station bounce radios will be loud and headsets will only be heard on their tile

		// modified so that a mob holding the radio is always a hearer of it
		// this fixes radio problems when inside something (e.g. mulebot)

		if(ismob(loc))
			if(! hear.Find(loc) )
				hear += loc
		//modified so people in the same object as it can hear it
		if(istype(loc, /obj))
			for(var/mob/M in loc)
				if(! hear.Find(M) )
					hear += M
		return hear
	return

/obj/item/device/radio/examine()
	set src in view()
	set category = "Local"

	..()
	if ((in_range(src, usr) || src.loc == usr))
		if (src.b_stat)
			usr.show_message("<span style=\"color:blue\">\the [src] can be attached and modified!</span>")
		else
			usr.show_message("<span style=\"color:blue\">\the [src] can not be modified or attached!</span>")
	if (istype(src.secure_frequencies) && src.secure_frequencies.len)
		boutput(usr, "Supplementary Channels:")
		for (var/sayToken in src.secure_frequencies) //Most convoluted string of the year award 2013
			boutput(usr, "[ headset_channel_lookup["[src.secure_frequencies["[sayToken]"]]"] ? headset_channel_lookup["[src.secure_frequencies["[sayToken]"]]"] : "???" ]: \[[format_frequency(src.secure_frequencies["[sayToken]"])]] (Activator: <b>[sayToken]</b>)")
	return

/obj/item/device/radio/attackby(obj/item/W as obj, mob/user as mob)
	user.machine = src
	if (!( istype(W, /obj/item/screwdriver) ))
		return
	src.b_stat = !( src.b_stat )
	if (src.b_stat)
		user.show_message("<span style=\"color:blue\">The radio can now be attached and modified!</span>")
	else
		user.show_message("<span style=\"color:blue\">The radio can no longer be modified or attached!</span>")
	if (istype(src.loc, /mob/living))
		var/mob/living/M = src.loc
		src.attack_self(M)
		//Foreach goto(83)
	src.add_fingerprint(user)
	return

/obj/item/device/radio/emp_act()
	broadcasting = 0
	listening = 0
	return

/obj/item/radiojammer
	name = "signal jammer"
	desc = "An illegal device used to jam radio signals, preventing broadcast or transmission."
	icon = 'icons/obj/objects.dmi'
	icon_state = "shieldoff"
	w_class = 1
	var/active = 0
	is_syndicate = 1
	mats = 10

	attack_self(var/mob/user as mob)
		if (!(radio_controller && istype(radio_controller)))
			return

		src.active = !src.active
		if (src.active)
			boutput(user, "You activate [src].")
			src.icon_state = "shieldon"
			if (!radio_controller.active_jammers.Find(src))
				radio_controller.active_jammers.Add(src)
		else
			boutput(user, "You shut off [src].")
			icon_state = "shieldoff"
			if (radio_controller.active_jammers.Find(src))
				radio_controller.active_jammers.Remove(src)

	disposing()
		if (radio_controller && istype(radio_controller) && radio_controller.active_jammers.Find(src))
			radio_controller.active_jammers.Remove(src)
		..()

/obj/item/device/radio/beacon
	name = "Tracking Beacon"
	icon_state = "beacon"
	item_state = "signaler"
	desc = "A small beacon that is tracked by the Teleporter Computer, allowing things to be sent to its general location."
	burn_possible = 0

/obj/item/device/radio/beacon/hear_talk()
	return

/obj/item/device/radio/beacon/send_hear()
	return null

/obj/item/device/radio/electropack
	name = "Electropack"
	icon_state = "electropack0"
	var/code = 2.0
	var/on = 0.0
//	var/e_pads = 0.0
	frequency = 1451
	w_class = 5.0
	flags = FPRINT | TABLEPASS | ONBACK | CONDUCT
	item_state = "electropack"
	desc = "A device that, when signaled on the correct frequency, causes a disabling electric shock to be sent to the animal wearing it."
	cant_self_remove = 1

/*
/obj/item/device/radio/electropack/examine()
	set src in view()
	set category = "Local"

	..()
	if ((in_range(src, usr) || src.loc == usr))
		if (src.e_pads)
			boutput(usr, "<span style=\"color:blue\">The electric pads are exposed!</span>")
	return*/

/obj/item/device/radio/electropack/attackby(obj/item/W as obj, mob/user as mob)

	// This doesn't seem to do anything (Convair880).
	/*if (istype(W, /obj/item/screwdriver))
		src.e_pads = !( src.e_pads )
		if (src.e_pads)
			user.show_message("<span style=\"color:blue\">The electric pads have been exposed!</span>")
		else
			user.show_message("<span style=\"color:blue\">The electric pads have been reinserted!</span>")
		src.add_fingerprint(user)
	else*/

	if (istype(W, /obj/item/clothing/head/helmet))
		var/obj/item/assembly/shock_kit/A = new /obj/item/assembly/shock_kit( user )
		W.set_loc(A)
		A.part1 = W
		W.layer = initial(W.layer)
		user.u_equip(W)
		user.put_in_hand_or_drop(A)
		W.master = A
		src.master = A
		src.layer = initial(src.layer)
		user.u_equip(src)
		src.set_loc(A)
		A.part2 = src
		src.add_fingerprint(user)
	return

/obj/item/device/radio/electropack/Topic(href, href_list)
	//..()
	if (usr.stat || usr.restrained())
		return
	if (src in usr || (src.master && src.master in usr) || (in_range(src, usr) && istype(src.loc, /turf)))
		usr.machine = src
		if (href_list["freq"])
			var/new_frequency = sanitize_frequency(frequency + text2num(href_list["freq"]))
			set_frequency(new_frequency)
		else
			if (href_list["code"])
				src.code += text2num(href_list["code"])
				src.code = round(src.code)
				src.code = min(100, src.code)
				src.code = max(1, src.code)
			else
				if (href_list["power"])
					src.on = !( src.on )
					src.icon_state = text("electropack[]", src.on)
		if (!( src.master ))
			if (istype(src.loc, /mob))
				attack_self(src.loc)
			else
				for(var/mob/M in viewers(1, src))
					if (M.client)
						src.attack_self(M)
		else
			if (istype(src.master.loc, /mob))
				src.attack_self(src.master.loc)
			else
				for(var/mob/M in viewers(1, src.master))
					if (M.client)
						src.attack_self(M)
	else
		usr << browse(null, "window=radio")
		return
	return
/*
/obj/item/device/radio/electropack/accept_rad(obj/item/device/radio/signaler/R as obj, message)

	if ((istype(R, /obj/item/device/radio/signaler) && R.frequency == src.frequency && R.code == src.code))
		return 1
	else
		return null
	return
*/
/obj/item/device/radio/electropack/receive_signal(datum/signal/signal)
	if (!signal || !signal.data || ("[signal.data["code"]]" != "[code]"))//(signal.encryption != code))
		return

	if (ismob(src.loc) && src.on)
		var/mob/M = src.loc
		if (src == M.back)
			M.show_message("<span style=\"color:red\"><B>You feel a sharp shock!</B></span>")
			logTheThing("signalers", usr, M, "signalled an electropack worn by %target% at [log_loc(M)].") // Added (Convair880).
			if(ticker && ticker.mode && istype(ticker.mode, /datum/game_mode/revolution))
				if(M.mind in ticker.mode:revolutionaries && !M.mind in ticker.mode:head_revolutionaries && prob(20))
					ticker.mode:remove_revolutionary(M.mind)
			if (M.weakened < 10)
				M.weakened = 10

	if ((src.master && src.wires & 1))
		src.master.receive_signal()

	return

/obj/item/device/radio/electropack/attack_self(mob/user as mob, flag1)

	if (!( istype(user, /mob/living/carbon/human) ))
		return
	user.machine = src
	var/dat = {"<TT>
<A href='?src=\ref[src];power=1'>Turn [src.on ? "Off" : "On"]</A><BR>
<B>Frequency/Code</B> for electropack:<BR>
Frequency:
<A href='byond://?src=\ref[src];freq=-10'>-</A>
<A href='byond://?src=\ref[src];freq=-2'>-</A> [format_frequency(src.frequency)]
<A href='byond://?src=\ref[src];freq=2'>+</A>
<A href='byond://?src=\ref[src];freq=10'>+</A><BR>

Code:
<A href='byond://?src=\ref[src];code=-5'>-</A>
<A href='byond://?src=\ref[src];code=-1'>-</A> [src.code]
<A href='byond://?src=\ref[src];code=1'>+</A>
<A href='byond://?src=\ref[src];code=5'>+</A><BR>
</TT>"}
	user << browse(dat, "window=radio")
	onclose(user, "radio")
	return



// ****************************************************




/obj/item/device/radio/signaler
	name = "Remote Signaling Device"
	icon_state = "signaller"
	item_state = "signaler"
	var/code = 30.0
	w_class = 1.0
	frequency = 1457
	var/delay = 0
	var/airlock_wire = null
	desc = "A device used to send a coded signal over a specified frequency, with the effect depending on the device that recieves the signal."

/*
/obj/item/device/radio/signaler/examine()
	set src in view()
	set category = "Local"
	..()
	if ((in_range(src, usr) || src.loc == usr))
		if (src.b_stat)
			usr.show_message("<span style=\"color:blue\">The signaler can be attached and modified!</span>")
		else
			usr.show_message("<span style=\"color:blue\">The signaler can not be modified or attached!</span>")
	return
*/

/obj/item/device/radio/signaler/attack_self(mob/user as mob, flag1)
	user.machine = src
	var/t1
	if ((src.b_stat && !( flag1 )))
		t1 = text("-------<BR><br>Green Wire: []<BR><br>Red Wire:   []<BR><br>Blue Wire:  []<BR><br>", (src.wires & 4 ? text("<A href='?src=\ref[];wires=4'>Cut Wire</A>", src) : text("<A href='?src=\ref[];wires=4'>Mend Wire</A>", src)), (src.wires & 2 ? text("<A href='?src=\ref[];wires=2'>Cut Wire</A>", src) : text("<A href='?src=\ref[];wires=2'>Mend Wire</A>", src)), (src.wires & 1 ? text("<A href='?src=\ref[];wires=1'>Cut Wire</A>", src) : text("<A href='?src=\ref[];wires=1'>Mend Wire</A>", src)))
	else
		t1 = "-------"
	var/dat = {"
<TT>
Speaker: [src.listening ? "<A href='byond://?src=\ref[src];listen=0'>Engaged</A>" : "<A href='byond://?src=\ref[src];listen=1'>Disengaged</A>"]<BR>
<A href='byond://?src=\ref[src];send=1'>Send Signal</A><BR>
<B>Frequency/Code</B> for signaler:<BR>
Frequency:
<A href='byond://?src=\ref[src];freq=-10'>-</A>
<A href='byond://?src=\ref[src];freq=-2'>-</A>
[format_frequency(src.frequency)]
<A href='byond://?src=\ref[src];freq=2'>+</A>
<A href='byond://?src=\ref[src];freq=10'>+</A><BR>

Code:
<A href='byond://?src=\ref[src];code=-5'>-</A>
<A href='byond://?src=\ref[src];code=-1'>-</A>
[src.code]
<A href='byond://?src=\ref[src];code=1'>+</A>
<A href='byond://?src=\ref[src];code=5'>+</A><BR>
[t1]
</TT>"}
	user << browse(dat, "window=radio")
	onclose(user, "radio")
	return

obj/item/device/radio/signaler/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/bikehorn))
		var/obj/item/assembly/radio_horn/A = new /obj/item/assembly/radio_horn( user )
		W.set_loc(A)
		A.part2 = W
		W.layer = initial(W.layer)
		user.u_equip(W)
		user.put_in_hand_or_drop(A)
		W.master = A
		src.master = A
		src.layer = initial(src.layer)
		user.u_equip(src)
		src.set_loc(A)
		A.part1 = src
		src.add_fingerprint(user)
		boutput(user, "You open the signaler and cram the [W.name] in there!")
	else
		..()
	return

/obj/item/device/radio/signaler/hear_talk()
	return

/obj/item/device/radio/signaler/send_hear()
	return


/obj/item/device/radio/signaler/receive_signal(datum/signal/signal)
	if(!signal || !signal.data || "[signal.data["code"]]" != "[code]")//(signal.encryption != code))
		return

	if (!( src.wires & 2 ))
		return
	if(istype(src.loc, /obj/machinery/door/airlock) && src.airlock_wire && src.wires & 1)
//		boutput(world, "/obj/.../signaler/r_signal([signal]) has master = [src.master] and type [(src.master?src.master.type : "none")]")
//		boutput(world, "[src.airlock_wire] - [src] - [usr] - [signal]")
		var/obj/machinery/door/airlock/A = src.loc
		A.pulse(src.airlock_wire)
//		src.master:r_signal(signal)
	if(src.master && (src.wires & 1))
		var/turf/T = get_turf(src.master)
		if (src.master && istype(src.master, /obj/item/device/transfer_valve))
			logTheThing("bombing", usr, null, "signalled a radio on a transfer valve at [T ? "[log_loc(T)]" : "horrible no-loc nowhere void"].")
			message_admins("[key_name(usr)] signalled a radio on a transfer valve at [T ? "[log_loc(T)]" : "horrible no-loc nowhere void"].")

		else if (src.master && istype(src.master, /obj/item/assembly/rad_ignite)) //Radio-detonated beaker assemblies
			var/obj/item/assembly/rad_ignite/RI = src.master
			logTheThing("bombing", usr, null, "signalled a radio on a radio-igniter assembly at [T ? "[log_loc(T)]" : "horrible no-loc nowhere void"]. Contents: [log_reagents(RI.part3)]")

		else if(src.master && istype(src.master, /obj/item/assembly/radio_bomb))	//Radio-detonated single-tank bombs
			logTheThing("bombing", usr, null, "signalled a radio on a single-tank bomb at [T ? "[log_loc(T)]" : "horrible no-loc nowhere void"].")
			message_admins("[key_name(usr)] signalled a radio on a single-tank bomb at [T ? "[log_loc(T)]" : "horrible no-loc nowhere void"].")
		spawn(0)
			src.master.receive_signal(signal)
	for(var/mob/O in hearers(1, src.loc))
		O.show_message("[bicon(src)] *beep* *beep*", 3, "*beep* *beep*", 2)

	return

/obj/item/device/radio/signaler/proc/send_signal(message="ACTIVATE")

	if(last_transmission && world.time < (last_transmission + TRANSMISSION_DELAY))
		return
	last_transmission = world.time

	if (!( src.wires & 4 ))
		return

	logTheThing("signalers", !usr && src.master ? src.master.fingerprintslast : usr, null, "used remote signaller[src.master ? " (connected to [src.master.name])" : ""] at [src.master ? "[log_loc(src.master)]" : "[log_loc(src)]"]. Frequency: [format_frequency(frequency)]/[code].")

	var/datum/signal/signal = get_free_signal()
	signal.source = src
	//signal.encryption = code
	signal.data["code"] = code
	signal.data["message"] = message

	radio_connection.post_signal(src, signal)

	return

/obj/item/device/radio/signaler/Topic(href, href_list)
	//..()
	if (usr.stat)
		return
	var/is_detonator_trigger = 0
	if (src.master)
		if (istype(src.master, /obj/item/assembly/detonator/) && src.master.master)
			if (istype(src.master.master, /obj/machinery/portable_atmospherics/canister/) && in_range(src.master.master, usr))
				is_detonator_trigger = 1
	if (is_detonator_trigger || (src in usr) || (src.master && (src.master in usr)) || (in_range(src, usr) && istype(src.loc, /turf)))
		usr.machine = src
		if (href_list["freq"])
			var/new_frequency = sanitize_frequency(frequency + text2num(href_list["freq"]))
			set_frequency(new_frequency)
		else if (href_list["code"])
			src.code += text2num(href_list["code"])
			src.code = round(src.code)
			src.code = min(100, src.code)
			src.code = max(1, src.code)
		else if (href_list["send"])
			spawn( 0 )
				src.send_signal("ACTIVATE")
				return
		else if (href_list["listen"])
			src.listening = text2num(href_list["listen"])
		else if (href_list["wires"])
			var/t1 = text2num(href_list["wires"])
			if (!( istype(usr.equipped(), /obj/item/wirecutters) ))
				return
			if ((!( src.b_stat ) && !( src.master )))
				return
			if (t1 & 1)
				if (src.wires & 1)
					src.wires &= 65534
				else
					src.wires |= 1
			else
				if (t1 & 2)
					if (src.wires & 2)
						src.wires &= 65533
					else
						src.wires |= 2
				else
					if (t1 & 4)
						if (src.wires & 4)
							src.wires &= 65531
						else
							src.wires |= 4
		src.add_fingerprint(usr)
		if (!src.master)
			if (istype(src.loc, /mob))
				attack_self(src.loc)
			else
				for(var/mob/M in viewers(1, src))
					if (M.client)
						src.attack_self(M)
		else
			if (is_detonator_trigger)
				src.attack_self(usr)
			if (istype(src.master.loc, /mob))
				src.attack_self(src.master.loc)
			else
				for(var/mob/M in viewers(1, src.master))
					if (M.client)
						src.attack_self(M)
	else
		usr << browse(null, "window=radio")
		return
	return