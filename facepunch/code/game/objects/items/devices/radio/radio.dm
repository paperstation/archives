/obj/item/device/radio
	icon = 'icons/obj/radio.dmi'
	name = "station bounced radio"
	suffix = "\[3\]"
	icon_state = "walkietalkie"
	item_state = "walkietalkie"
	var/on = 1 // 0 for off
	var/last_transmission
	var/frequency = 1459 //common chat
	var/traitor_frequency = 0 //tune to frequency to unlock traitor supplies
	var/canhear_range = 3 // the range which mobs can hear this radio from
	var/obj/item/device/radio/patch_link = null
	var/wires = WIRE_SIGNAL | WIRE_RECEIVE | WIRE_TRANSMIT
	var/b_stat = 0
	var/broadcasting = 0
	var/listening = 1
	var/freerange = 0 // 0 - Sanitize frequencies, 1 - Full range
	var/list/channels = list() //see communications.dm for full list. First channes is a "default" for :h
	var/subspace_transmission = 0
	var/syndie = 0//Holder to see if it's a syndicate encrpyed radio
	var/maxf = 1499
//			"Example" = FREQ_LISTENING|FREQ_BROADCASTING
	flags = FPRINT | CONDUCT | TABLEPASS
	slot_flags = SLOT_BELT
	w_class = 2
	g_amt = 25
	m_amt = 75
	var/const/WIRE_SIGNAL = 1 //sends a signal, like to set off a bomb or electrocute someone
	var/const/WIRE_RECEIVE = 2
	var/const/WIRE_TRANSMIT = 4
	var/const/TRANSMISSION_DELAY = 5 // only 2/second/radio
	var/const/FREQ_LISTENING = 1
		//FREQ_BROADCASTING = 2

	var/datum/radio_frequency/radio_connection
	var/list/datum/radio_frequency/secure_radio_connections = new

	proc/set_frequency(new_frequency)
		radio_controller.remove_object(src, frequency)
		frequency = new_frequency
		radio_connection = radio_controller.add_object(src, frequency, RADIO_CHAT)

	New()
		..()
		if(radio_controller)
			initialize()
		return


	initialize()
		if(freerange)
			if(frequency < 1200 || frequency > 1600)
				frequency = sanitize_frequency(frequency, maxf)
		// The max freq is higher than a regular headset to decrease the chance of people listening in, if you use the higher channels.
		else if (frequency < 1441 || frequency > maxf)
			//world.log << "[src] ([type]) has a frequency of [frequency], sanitizing."
			frequency = sanitize_frequency(frequency, maxf)

		set_frequency(frequency)

		for (var/ch_name in channels)
			secure_radio_connections[ch_name] = radio_controller.add_object(src, radiochannels[ch_name],  RADIO_CHAT)
		return


	attack_self(mob/user as mob)
		user.set_machine(src)
		interact(user)
		return


	interact(mob/user as mob)
		if(!on)
			return

		if(active_uplink_check(user))
			return

		var/dat = "<html><head><title>[src]</title></head><body><TT>"

		if(!istype(src, /obj/item/device/radio/headset)) //Headsets dont get a mic button
			dat += "Microphone: [broadcasting ? "<A href='byond://?src=\ref[src];talk=0'>Engaged</A>" : "<A href='byond://?src=\ref[src];talk=1'>Disengaged</A>"]<BR>"

		dat += {"
					Speaker: [listening ? "<A href='byond://?src=\ref[src];listen=0'>Engaged</A>" : "<A href='byond://?src=\ref[src];listen=1'>Disengaged</A>"]<BR>
					Frequency:
					<A href='byond://?src=\ref[src];freq=-10'>-</A>
					<A href='byond://?src=\ref[src];freq=-2'>-</A>
					[format_frequency(frequency)]
					<A href='byond://?src=\ref[src];freq=2'>+</A>
					<A href='byond://?src=\ref[src];freq=10'>+</A><BR>
					"}

		for (var/ch_name in channels)
			dat+=text_sec_channel(ch_name, channels[ch_name])
		dat+={"[text_wires()]</TT></body></html>"}
		user << browse(dat, "window=radio")
		onclose(user, "radio")
		return


	proc/text_wires()
		if (!b_stat)
			return ""
		return {"
				<hr>
				Green Wire: <A href='byond://?src=\ref[src];wires=4'>[(wires & 4) ? "Cut" : "Mend"] Wire</A><BR>
				Red Wire:   <A href='byond://?src=\ref[src];wires=2'>[(wires & 2) ? "Cut" : "Mend"] Wire</A><BR>
				Blue Wire:  <A href='byond://?src=\ref[src];wires=1'>[(wires & 1) ? "Cut" : "Mend"] Wire</A><BR>
				"}


	proc/text_sec_channel(var/chan_name, var/chan_stat)
		var/list = !!(chan_stat&FREQ_LISTENING)!=0
		return {"
				<B>[chan_name]</B><br>
				Speaker: <A href='byond://?src=\ref[src];ch_name=[chan_name];listen=[!list]'>[list ? "Engaged" : "Disengaged"]</A><BR>
				"}


	Topic(href, href_list)
		//..()
		if (usr.stat || !on)
			return

		if(!(issilicon(usr) || (usr.contents.Find(src) || ( in_range(src, usr) && istype(loc, /turf) ))))
			usr << browse(null, "window=radio")
			return
		usr.set_machine(src)
		if(href_list["track"])
			var/mob/target = locate(href_list["track"])
			var/mob/living/silicon/ai/A = locate(href_list["track2"])
			if(A && target)
				A.ai_actual_track(target)
			return

		if(href_list["faketrack"])
			var/mob/target = locate(href_list["track"])
			var/mob/living/silicon/ai/A = locate(href_list["track2"])
			if(A && target)

				A:cameraFollow = target
				A << text("Now tracking [] on camera.", target.name)
				if (usr.machine == null)
					usr.machine = usr

				while (usr:cameraFollow == target)
					usr << "Target is not on or near any active cameras on the station. We'll check again in 5 seconds (unless you use the cancel-camera verb)."
					sleep(40)
					continue
			return

		if(href_list["freq"])
			var/new_frequency = (frequency + text2num(href_list["freq"]))
			if (!freerange || (frequency < 1200 || frequency > 1600))
				new_frequency = sanitize_frequency(new_frequency, maxf)
			set_frequency(new_frequency)
			if(hidden_uplink)
				if(hidden_uplink.check_trigger(usr, frequency, traitor_frequency))
					usr << browse(null, "window=radio")
					return

		if(href_list["talk"])
			broadcasting = text2num(href_list["talk"])
			return
		if(href_list["listen"])
			var/chan_name = href_list["ch_name"]
			if(!chan_name)
				listening = text2num(href_list["listen"])
			else
				if (channels[chan_name] & FREQ_LISTENING)
					channels[chan_name] &= ~FREQ_LISTENING
				else
					channels[chan_name] |= FREQ_LISTENING
			return
		if(href_list["wires"])
			var/t1 = text2num(href_list["wires"])
			if (!( istype(usr.get_active_hand(), /obj/item/weapon/wirecutters) ))
				return
			if (wires & t1)
				wires &= ~t1
			else
				wires |= t1
			return
		if(!master)
			if (istype(loc, /mob))
				interact(loc)
			else
				updateDialog()
			return
		if (istype(master.loc, /mob))
			interact(master.loc)
		else
			updateDialog()
		add_fingerprint(usr)
		return


	talk_into(mob/living/M as mob, message, channel)
		if(!on) return // the device has to be on
		if(!M || !message) return

		if(!(src.wires & WIRE_TRANSMIT)) // The device has to have all its wires and shit intact
			return

		var/datum/radio_frequency/connection = null
		if(channel && channels && channels.len > 0)
			if (channel == "department")
				//world << "DEBUG: channel=\"[channel]\" switching to \"[channels[1]]\""
				channel = channels[1]
			connection = secure_radio_connections[channel]
		else
			connection = radio_connection
			channel = null
		if (!istype(connection))
			return
		var/display_freq = connection.frequency

		//world << "DEBUG: used channel=\"[channel]\" frequency= \"[display_freq]\" connection.devices.len = [connection.devices["[RADIO_CHAT]"]]"

		var/eqjobname

		if (ishuman(M))
			eqjobname = M:get_assignment()
		else if(iscarbon(M))
			eqjobname = "No id" //only humans can wear ID
		else if(isAI(M))
			eqjobname = "AI"
		else if(isrobot(M))
			eqjobname = "Cyborg"//Androids don't really describe these too well, in my opinion.
		else if(istype(M, /mob/living/silicon/pai))
			eqjobname = "Personal AI"
		else
			eqjobname = "Unknown"

		if (!(wires & WIRE_TRANSMIT))
			return

		var/list/radios = list()

		var/turf/position = get_turf(src)

		for (var/obj/item/device/radio/R in connection.devices["[RADIO_CHAT]"]) // Modified for security headset code -- TLE
			if(R.receive_range(display_freq, position.z) > -1)
				radios += R

		//world << "DEBUG: receive.len=[receive.len]"
		var/list/heard_masked = list() // masked name or no real name
		var/list/heard_normal = list() // normal message
		var/list/heard_voice = list() // voice message
		var/list/heard_garbled = list() // garbled message

		var/list/receive = get_mobs_in_radio_ranges(radios)
	 	//world << "DEBUG: GMIRR: [recieve.len] radios: [radios.len]"

		for (var/mob/R in receive)
			if (R.client && !(R.client.prefs.toggles & CHAT_RADIO)) //Adminning with 80 people on can be fun when you're trying to talk and all you can hear is radios.
				continue
			if (R.say_understands(M))
				if (ishuman(M) && M.GetVoice() != M.real_name)
					heard_masked += R
				else
					heard_normal += R
			else
				if (M.voice_message)
					heard_voice += R
				else
					heard_garbled += R

		//world << "DEBUG: HM: [heard_masked.len] HN: [heard_normal.len] HV: [heard_voice.len] HG: [heard_garbled.len]"

		if (length(heard_masked) || length(heard_normal) || length(heard_voice) || length(heard_garbled))
			var/part_a = "<span class='radio'><span class='name'>"
			//var/part_b = "</span><b> \icon[src]\[[format_frequency(frequency)]\]</b> <span class='message'>"
			var/freq_text
			switch(display_freq)
				if(SYND_FREQ)
					freq_text = "#unkn"
				if(COMM_FREQ)
					freq_text = "Command"
				if(1351)
					freq_text = "Science"
				if(1355)
					freq_text = "Medical"
				if(1357)
					freq_text = "Engineering"
				if(SEC_FREQ)
					freq_text = "Security"
				if(1349)
					freq_text = "Mining"
				if(1347)
					freq_text = "Cargo"
				if(1214)
					freq_text = "Starship"
				if(STARSHIP_FREQ)
					freq_text = "Starship"
			//There's probably a way to use the list var of channels in code\game\communications.dm to make the dept channels non-hardcoded, but I wasn't in an experimentive mood. --NEO

			if(!freq_text)
				freq_text = format_frequency(display_freq)

			var/part_b = "</span><b> \icon[src]\[[freq_text]\]</b> <span class='message'>" // Tweaked for security headsets -- TLE
			var/part_c = "</span></span>"

			if (display_freq==SYND_FREQ)
				part_a = "<span class='syndradio'><span class='name'>"
			else if (display_freq==COMM_FREQ)
				part_a = "<span class='comradio'><span class='name'>"
			else if (display_freq==SEC_FREQ)
				part_a = "<span class='secradio'><span class='name'>"
			else if (display_freq in DEPT_FREQS)
				part_a = "<span class='deptradio'><span class='name'>"
			else if (display_freq in STARSHIP_FREQ)
				part_a = "<span class='starradio'><span class='name'>"
			var/quotedmsg = M.say_quote(message)

			if (length(heard_masked))
				var/N = M.name
				var/J = eqjobname
				if(ishuman(M) && M.GetVoice() != M.real_name)
					N = M.GetVoice()
					J = "Unknown"
				var/rendered = "[part_a][N][part_b][quotedmsg][part_c]"
				for (var/mob/R in heard_masked)
					if(istype(R, /mob/living/silicon/ai))
						R.show_message("[part_a]<a href='byond://?src=\ref[src];track2=\ref[R];track=\ref[M]'>[N] ([J]) </a>[part_b][quotedmsg][part_c]", 2)
					else
						R.show_message(rendered, 2)

			if (length(heard_normal))
				var/rendered = "[part_a][M.real_name][part_b][quotedmsg][part_c]"

				for (var/mob/R in heard_normal)
					if(istype(R, /mob/living/silicon/ai))
						R.show_message("[part_a]<a href='byond://?src=\ref[src];track2=\ref[R];track=\ref[M]'>[M.real_name] ([eqjobname]) </a>[part_b][quotedmsg][part_c]", 2)
					else
						R.show_message(rendered, 2)

			if (length(heard_voice))
				var/rendered = "[part_a][M.voice_name][part_b][M.voice_message][part_c]"

				for (var/mob/R in heard_voice)
					if(istype(R, /mob/living/silicon/ai))
						R.show_message("[part_a]<a href='byond://?src=\ref[src];track2=\ref[R];track=\ref[M]'>[M.voice_name] ([eqjobname]) </a>[part_b][M.voice_message][part_c]", 2)
					else
						R.show_message(rendered, 2)

			if (length(heard_garbled))
				quotedmsg = M.say_quote(stars(message))
				var/rendered = "[part_a][M.voice_name][part_b][quotedmsg][part_c]"

				for (var/mob/R in heard_voice)
					if(istype(R, /mob/living/silicon/ai))
						R.show_message("[part_a]<a href='byond://?src=\ref[src];track2=\ref[R];track=\ref[M]'>[M.voice_name]</a>[part_b][quotedmsg][part_c]", 2)
					else
						R.show_message(rendered, 2)
		return


	hear_talk(mob/M as mob, msg)
		if (broadcasting)
			talk_into(M, msg)
		return


/*
/obj/item/device/radio/proc/accept_rad(obj/item/device/radio/R as obj, message)

	if ((R.frequency == frequency && message))
		return 1
	else if

	else
		return null
	return
*/

	proc/receive_range(freq, level)
		// check if this radio can receive on the given frequency, and if so,
		// what the range is in which mobs will hear the radio
		// returns: -1 if can't receive, range otherwise

		if(!(wires & WIRE_RECEIVE))
			return -1
		if(!listening)
			return -1
		if(level)
			var/turf/position = get_turf(src)
			if(!position)//We have no turf
				return -1
			if((level > 6 && !position.z > 6)||(!level > 6 && position.z > 6))//If its over the limit and we are not or its not and we are then block it otherwise its fine
				return -1
		if(freq == SYND_FREQ)
			if(!(src.syndie))//Checks to see if it's allowed on that frequency, based on the encryption keys
				return -1
		if(!on)
			return -1
		if(!freq) //recieved on main frequency
			if (!listening)
				return -1
		else
			var/accept = (freq==frequency && listening)
			if (!accept)
				for (var/ch_name in channels)
					var/datum/radio_frequency/RF = secure_radio_connections[ch_name]
					if (RF.frequency==freq && (channels[ch_name]&FREQ_LISTENING))
						accept = 1
						break
			if (!accept)
				return -1
		return canhear_range


	proc/send_hear(freq, level)
		var/range = receive_range(freq, level)
		if(range > -1)
			return get_mobs_in_view(canhear_range, src)
		return


	examine()
		..()
		if(b_stat)
			usr.show_message("\blue \the [src] can be attached and modified!")
		else
			usr.show_message("\blue \the [src] can not be modified or attached!")
		return


	attackby(obj/item/weapon/W as obj, mob/user as mob)
		..()
		user.set_machine(src)
		if (!( istype(W, /obj/item/weapon/screwdriver) ))
			return
		b_stat = !( b_stat )
		if(!istype(src, /obj/item/device/radio/beacon))
			if (b_stat)
				user.show_message("\blue The radio can now be attached and modified!")
			else
				user.show_message("\blue The radio can no longer be modified or attached!")
			updateDialog()
				//Foreach goto(83)
			add_fingerprint(user)
			return
		else return


	emp_act(severity)
		broadcasting = 0
		listening = 0
		for (var/ch_name in channels)
			channels[ch_name] = 0
		..()

///////////////////////////////
//////////Borg Radios//////////
///////////////////////////////
//Giving borgs their own radio to have some more room to work with -Sieve

/obj/item/device/radio/borg
	var/obj/item/device/encryptionkey/keyslot = null//Borg radios can handle a single encryption key

	attackby(obj/item/weapon/W as obj, mob/user as mob)
	//	..()
		user.set_machine(src)
		if (!( istype(W, /obj/item/weapon/screwdriver) || (istype(W, /obj/item/device/encryptionkey/ ))))
			return

		if(istype(W, /obj/item/weapon/screwdriver))
			if(keyslot)
				for(var/ch_name in channels)
					radio_controller.remove_object(src, radiochannels[ch_name])
					secure_radio_connections[ch_name] = null

				if(keyslot)
					var/turf/T = get_turf(user)
					if(T)
						keyslot.loc = T
						keyslot = null

				recalculateChannels()
				user << "You pop out the encryption key in the radio!"

			else
				user << "This radio doesn't have any encryption keys!"

		if(istype(W, /obj/item/device/encryptionkey/))
			if(keyslot)
				user << "The radio can't hold another key!"
				return

			if(!keyslot)
				user.drop_item()
				W.loc = src
				keyslot = W

			recalculateChannels()
		return


	proc/recalculateChannels()
		src.channels = list()
		src.syndie = 0

		if(keyslot)
			for(var/ch_name in keyslot.channels)
				if(ch_name in src.channels)
					continue
				src.channels += ch_name
				src.channels[ch_name] = keyslot.channels[ch_name]

			if(keyslot.syndie)
				src.syndie = 1

		for (var/ch_name in channels)
			if(!radio_controller)
				sleep(30) // Waiting for the radio_controller to be created.
			if(!radio_controller)
				src.name = "broken radio"
				return

			secure_radio_connections[ch_name] = radio_controller.add_object(src, radiochannels[ch_name],  RADIO_CHAT)
		return


	interact(mob/user as mob)
		if(!on)
			return

		var/dat = "<html><head><title>[src]</title></head><body><TT>"
		dat += {"
					Speaker: [listening ? "<A href='byond://?src=\ref[src];listen=0'>Engaged</A>" : "<A href='byond://?src=\ref[src];listen=1'>Disengaged</A>"]<BR>
					Frequency:
					<A href='byond://?src=\ref[src];freq=-10'>-</A>
					<A href='byond://?src=\ref[src];freq=-2'>-</A>
					[format_frequency(frequency)]
					<A href='byond://?src=\ref[src];freq=2'>+</A>
					<A href='byond://?src=\ref[src];freq=10'>+</A><BR>
					"}
		for (var/ch_name in channels)
			dat+=text_sec_channel(ch_name, channels[ch_name])
		dat+={"[text_wires()]</TT></body></html>"}
		user << browse(dat, "window=radio")
		onclose(user, "radio")
		return