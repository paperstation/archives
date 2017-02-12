// Navigation beacon for AI robots
// Functions as a transponder: looks for incoming signal matching

/obj/machinery/navbeacon

	icon = 'icons/obj/objects.dmi'
	icon_state = "navbeacon0-f"
	name = "navigation beacon"
	desc = "A radio beacon used for bot navigation."
	level = 1		// underfloor
	layer = 2.5 // TODO layer whatever
	anchored = 1

	var/open = 0		// true if cover is open
	var/locked = 1		// true if controls are locked
	var/freq = 1445		// radio frequency
	var/location = ""	// location response text
	var/list/codes		// assoc. list of transponder codes
	var/codes_txt = ""	// codes as set on map: "tag1;tag2" or "tag1=value;tag2=value"
	var/net_id = ""

	req_access = list(access_engineering)

	New()
		..()

		UnsubscribeProcess()

		set_codes()

		var/turf/T = loc
		hide(T.intact)

		spawn(5)	// must wait for map loading to finish
			if(radio_controller)
				radio_controller.add_object(src, "[freq]")

			if(!net_id)
				net_id = generate_net_id(src)

	// set the transponder codes assoc list from codes_txt
	proc/set_codes()
		if(!codes_txt)
			return

		codes = new()

		var/list/entries = dd_text2List(codes_txt, ";")	// entries are separated by semicolons

		for(var/e in entries)
			var/index = findtext(e, "=")		// format is "key=value"
			if(index)
				var/key = copytext(e, 1, index)
				var/val = copytext(e, index+1)
				codes[key] = val
			else
				codes[e] = "1"


	// called when turf state changes
	// hide the object if turf is intact
	hide(var/intact)
		invisibility = intact ? 101 : 0
		updateicon()

	// update the icon_state
	proc/updateicon()
		var/state="navbeacon[open]"

		if(invisibility)
			icon_state = "[state]-f"	// if invisible, set icon to faded version
										// in case revealed by T-scanner
		else
			icon_state = "[state]"


	// look for a signal of the form "findbeacon=X"
	// where X is any
	// or the location
	// or one of the set transponder keys
	// if found, return a signal
	receive_signal(datum/signal/signal)

//		if(stat & NOPOWER)
//			return

		var/request = signal.data["findbeacon"]
		if(request && ((request in codes) || request == "any" || request == location))
			spawn(1)
				post_signal()


	// return a signal giving location and transponder codes

	proc/post_signal()

		var/datum/radio_frequency/frequency = radio_controller.return_frequency("[freq]")

		if(!frequency) return

		var/datum/signal/signal = get_free_signal()
		signal.source = src
		signal.transmission_method = 1
		signal.data["beacon"] = location
		signal.data["netid"] = net_id

		for(var/key in codes)
			signal.data[key] = codes[key]

		frequency.post_signal(src, signal)


	attackby(var/obj/item/I, var/mob/user)
		var/turf/T = loc
		if (T.intact)
			return		// prevent intraction when T-scanner revealed

		if (istype(I, /obj/item/screwdriver))
			open = !open

			user.visible_message("[user] [open ? "opens" : "closes"] the beacon's cover.", "You [open ? "open" : "close"] the beacon's cover.")

			updateicon()

		if (istype(I, /obj/item/device/pda2) && I:ID_card)
			I = I:ID_card
		if (istype(I, /obj/item/card/id))
			if (open)
				if (src.allowed(user, req_only_one_required))
					src.locked = !src.locked
					boutput(user, "Controls are now [src.locked ? "locked." : "unlocked."]")
				else
					boutput(user, "<span style=\"color:red\">Access denied.</span>")
				updateDialog()
			else
				boutput(user, "You must open the cover first!")
		return

	attack_ai(var/mob/user)
		interact(user, 1)

	attack_hand(var/mob/user)
		if (ismonkey(user))
			return
		interact(user, 0)

	proc/interact(var/mob/user, var/ai = 0)
		var/turf/T = loc
		if(T.intact)
			return		// prevent intraction when T-scanner revealed

		if(!open && !ai)	// can't alter controls if not open, unless you're an AI
			boutput(user, "The beacon's control cover is closed.")
			return


		var/t

		if(locked && !ai)
			t = {"<TT><B>Navigation Beacon</B><HR><BR>
<i>(swipe card to unlock controls)</i><BR>
Frequency: [format_frequency(freq)]<BR><HR>
Location: [location ? location : "(none)"]</A><BR>
Transponder Codes:<UL>"}

			for(var/key in codes)
				t += "<LI>[key] ... [codes[key]]"
			t+= "<UL></TT>"

		else

			t = {"<TT><B>Navigation Beacon</B><HR><BR>
<i>(swipe card to lock controls)</i><BR>
Frequency:
<A href='byond://?src=\ref[src];freq=-10'>-</A>
<A href='byond://?src=\ref[src];freq=-2'>-</A>
[format_frequency(freq)]
<A href='byond://?src=\ref[src];freq=2'>+</A>
<A href='byond://?src=\ref[src];freq=10'>+</A><BR>
<HR>
Location: <A href='byond://?src=\ref[src];locedit=1'>[location ? location : "(none)"]</A><BR>
Transponder Codes:<UL>"}

			for(var/key in codes)
				t += "<LI>[key] ... [codes[key]]"
				t += " <small><A href='byond://?src=\ref[src];edit=1;code=[key]'>(edit)</A>"
				t += " <A href='byond://?src=\ref[src];delete=1;code=[key]'>(delete)</A></small><BR>"
			t += "<small><A href='byond://?src=\ref[src];add=1;'>(add new)</A></small><BR>"
			t+= "<UL></TT>"

		user << browse(t, "window=navbeacon")
		onclose(user, "navbeacon")
		return

	Topic(href, href_list)
		..()
		if (usr.stat)
			return
		if ((in_range(src, usr) && istype(src.loc, /turf)) || (istype(usr, /mob/living/silicon)))
			if(open && !locked)
				usr.machine = src

				if (href_list["freq"])
					freq = sanitize_frequency(freq + text2num(href_list["freq"]))
					updateDialog()

				else if(href_list["locedit"])
					var/newloc = input("Enter New Location", "Navigation Beacon", location) as text|null
					newloc = copytext(adminscrub(newloc), 1, 64)
					if(newloc)
						location = newloc
						updateDialog()

				else if(href_list["edit"])
					var/codekey = href_list["code"]

					var/newkey = input("Enter Transponder Code Key", "Navigation Beacon", codekey) as text|null
					newkey = copytext(adminscrub(newkey), 1, 64)
					if(!newkey)
						return

					var/codeval = codes[codekey]
					var/newval = input("Enter Transponder Code Value", "Navigation Beacon", codeval) as text|null
					newval = copytext(adminscrub(newval), 1, 64)
					if(!newval)
						newval = codekey
						return

					codes.Remove(codekey)
					codes[newkey] = newval

					updateDialog()

				else if(href_list["delete"])
					var/codekey = href_list["code"]
					codes.Remove(codekey)
					updateDialog()

				else if(href_list["add"])

					var/newkey = input("Enter New Transponder Code Key", "Navigation Beacon") as text|null
					newkey = copytext(adminscrub(newkey), 1, 64)
					if(!newkey)
						return

					var/newval = input("Enter New Transponder Code Value", "Navigation Beacon") as text|null
					newval = copytext(adminscrub(newval), 1, 64)
					if(!newval)
						newval = "1"
						return

					if(!codes)
						codes = new()

					codes[newkey] = newval

					updateDialog()

//Wired nav device
/obj/machinery/wirenav
	name = "Wired Nav Beacon"
	icon = 'icons/obj/objects.dmi'
	icon_state = "wirednav-f"
	level = 1		// underfloor
	layer = OBJ_LAYER
	anchored = 1
	mats = 8
	var/nav_tag = null
	var/net_id = null
	var/obj/machinery/power/data_terminal/link = null

	hide(var/intact)
		invisibility = intact ? 101 : 0
		src.icon_state = "wirednav[invisibility ? "-f" : ""]"

	New()
		..()

		var/turf/T = get_turf(src)
		hide(T.intact)

		spawn(6)
			if(!nav_tag)
				src.nav_tag = "NOWHERE"
				var/area/A = get_area(src)
				if(A)
					src.nav_tag = A.name

			if(!src.net_id)
				src.net_id = generate_net_id(src)

			if(!src.link)
				var/obj/machinery/power/data_terminal/test_link = locate() in T
				if(test_link && !test_link.is_valid_master(test_link.master))
					src.link = test_link
					src.link.master = src

		return

	receive_signal(datum/signal/signal)
		if(stat & NOPOWER || !src.link)
			return

		if(!signal || signal.encryption || !signal.data["sender"])
			return

		if(signal.transmission_method != TRANSMISSION_WIRE)
			return

		var/sender = signal.data["sender"]
		if((signal.data["address_1"] in list(src.net_id, "ping")) && sender)
			var/datum/signal/reply = new
			reply.data["address_1"] = sender
			reply.data["command"] = "ping_reply"
			reply.data["device"] = "PNET_NAV_BEACN"
			reply.data["netid"] = src.net_id
			reply.data["data"] = src.nav_tag
			reply.data["navdat"] = "x=[src.x]&y=[src.y]&z=[src.z]"
			spawn(5)
				src.link.post_signal(src, reply)
			return

		return

/obj/machinery/navbeacon/guardbot_buddytime
	name = "buddy time beacon"
	location = "buddytime"
	codes_txt = "patrol"

// Circular patrol pattern. I'm sure as hell not going to varedit all those things by hand.
// 20 should be sufficient for a full-sized map such as COG1 or 2 (Convair880).
/obj/machinery/navbeacon/guardbotsecbot_circularpatrol
	name = "bot patrol navigational beacon"

	beacon1_start
		location = "1"
		codes_txt = "patrol;next_patrol=2"
	beacon2
		location = "2"
		codes_txt = "patrol;next_patrol=3"
	beacon3
		location = "3"
		codes_txt = "patrol;next_patrol=4"
	beacon4
		location = "4"
		codes_txt = "patrol;next_patrol=5"
	beacon5
		location = "5"
		codes_txt = "patrol;next_patrol=6"
	beacon6
		location = "6"
		codes_txt = "patrol;next_patrol=7"
	beacon7
		location = "7"
		codes_txt = "patrol;next_patrol=8"
	beacon8
		location = "8"
		codes_txt = "patrol;next_patrol=9"
	beacon9
		location = "9"
		codes_txt = "patrol;next_patrol=10"
	beacon10
		location = "10"
		codes_txt = "patrol;next_patrol=11"
	beacon11
		location = "11"
		codes_txt = "patrol;next_patrol=12"
	beacon12
		location = "12"
		codes_txt = "patrol;next_patrol=13"
	beacon13
		location = "13"
		codes_txt = "patrol;next_patrol=14"
	beacon14
		location = "14"
		codes_txt = "patrol;next_patrol=15"
	beacon15
		location = "15"
		codes_txt = "patrol;next_patrol=16"
	beacon16
		location = "16"
		codes_txt = "patrol;next_patrol=17"
	beacon17
		location = "17"
		codes_txt = "patrol;next_patrol=18"
	beacon18
		location = "18"
		codes_txt = "patrol;next_patrol=19"
	beacon19
		location = "19"
		codes_txt = "patrol;next_patrol=20"
	beacon20_to_1_end
		location = "20"
		codes_txt = "patrol;next_patrol=1"

// Same deal for MULE delivery beacons (Convair880).
/obj/machinery/navbeacon/mule
	name = "MULE delivery beacon"

	QM1_north
		location = "QM #1"
		codes_txt = "delivery;dir=1"

		east
			codes_txt = "delivery;dir=4"
		south
			codes_txt = "delivery;dir=2"
		west
			codes_txt = "delivery;dir=8"
	QM2_north
		location = "QM #2"
		codes_txt = "delivery;dir=1"

		east
			codes_txt = "delivery;dir=4"
		south
			codes_txt = "delivery;dir=2"
		west
			codes_txt = "delivery;dir=8"
	crewA_north
		location = "Crew Quarters A"
		codes_txt = "delivery;dir=1"

		east
			codes_txt = "delivery;dir=4"
		south
			codes_txt = "delivery;dir=2"
		west
			codes_txt = "delivery;dir=8"
	crewB_north
		location = "Crew Quarters B"
		codes_txt = "delivery;dir=1"

		east
			codes_txt = "delivery;dir=4"
		south
			codes_txt = "delivery;dir=2"
		west
			codes_txt = "delivery;dir=8"
	catering_north
		location = "Catering"
		codes_txt = "delivery;dir=1"

		east
			codes_txt = "delivery;dir=4"
		south
			codes_txt = "delivery;dir=2"
		west
			codes_txt = "delivery;dir=8"
	toolstorage_north
		location = "Tool Storage"
		codes_txt = "delivery;dir=1"

		east
			codes_txt = "delivery;dir=4"
		south
			codes_txt = "delivery;dir=2"
		west
			codes_txt = "delivery;dir=8"
	hydroponics_north
		location = "Hydroponics"
		codes_txt = "delivery;dir=1"

		east
			codes_txt = "delivery;dir=4"
		south
			codes_txt = "delivery;dir=2"
		west
			codes_txt = "delivery;dir=8"
	chapel_north
		location = "Chapel"
		codes_txt = "delivery;dir=1"

		east
			codes_txt = "delivery;dir=4"
		south
			codes_txt = "delivery;dir=2"
		west
			codes_txt = "delivery;dir=8"
	security_north
		location = "Security"
		codes_txt = "delivery;dir=1"

		east
			codes_txt = "delivery;dir=4"
		south
			codes_txt = "delivery;dir=2"
		west
			codes_txt = "delivery;dir=8"
	courtroom_north
		location = "Courtroom"
		codes_txt = "delivery;dir=1"

		east
			codes_txt = "delivery;dir=4"
		south
			codes_txt = "delivery;dir=2"
		west
			codes_txt = "delivery;dir=8"
	market_north
		location = "Market"
		codes_txt = "delivery;dir=1"

		east
			codes_txt = "delivery;dir=4"
		south
			codes_txt = "delivery;dir=2"
		west
			codes_txt = "delivery;dir=8"
	podbay_north
		location = "Main Pod Bay"
		codes_txt = "delivery;dir=1"

		east
			codes_txt = "delivery;dir=4"
		south
			codes_txt = "delivery;dir=2"
		west
			codes_txt = "delivery;dir=8"
	engineering_north
		location = "Engineering"
		codes_txt = "delivery;dir=1"

		east
			codes_txt = "delivery;dir=4"
		south
			codes_txt = "delivery;dir=2"
		west
			codes_txt = "delivery;dir=8"
	research_north
		location = "Research"
		codes_txt = "delivery;dir=1"

		east
			codes_txt = "delivery;dir=4"
		south
			codes_txt = "delivery;dir=2"
		west
			codes_txt = "delivery;dir=8"
	medbay_north
		location = "Medbay"
		codes_txt = "delivery;dir=1"

		east
			codes_txt = "delivery;dir=4"
		south
			codes_txt = "delivery;dir=2"
		west
			codes_txt = "delivery;dir=8"
	bridge_north
		location = "Bridge"
		codes_txt = "delivery;dir=1"

		east
			codes_txt = "delivery;dir=4"
		south
			codes_txt = "delivery;dir=2"
		west
			codes_txt = "delivery;dir=8"
	cafeteria_north
		location = "Cafeteria"
		codes_txt = "delivery;dir=1"

		east
			codes_txt = "delivery;dir=4"
		south
			codes_txt = "delivery;dir=2"
		west
			codes_txt = "delivery;dir=8"
	hallway_escape_north
		location = "Escape Hallway"
		codes_txt = "delivery;dir=1"

		east
			codes_txt = "delivery;dir=4"
		south
			codes_txt = "delivery;dir=2"
		west
			codes_txt = "delivery;dir=8"
	hallway_arrivals_north
		location = "Arrivals Hallway"
		codes_txt = "delivery;dir=1"

		east
			codes_txt = "delivery;dir=4"
		south
			codes_txt = "delivery;dir=2"
		west
			codes_txt = "delivery;dir=8"
	hallway_fore_north
		location = "Fore Primary Hallway"
		codes_txt = "delivery;dir=1"

		east
			codes_txt = "delivery;dir=4"
		south
			codes_txt = "delivery;dir=2"
		west
			codes_txt = "delivery;dir=8"
	hallway_starboard_north
		location = "Starboard Primary Hallway"
		codes_txt = "delivery;dir=1"

		east
			codes_txt = "delivery;dir=4"
		south
			codes_txt = "delivery;dir=2"
		west
			codes_txt = "delivery;dir=8"
	hallway_aft_north
		location = "Aft Primary Hallway"
		codes_txt = "delivery;dir=1"

		east
			codes_txt = "delivery;dir=4"
		south
			codes_txt = "delivery;dir=2"
		west
			codes_txt = "delivery;dir=8"
	hallway_port_north
		location = "Port Primary Hallway"
		codes_txt = "delivery;dir=1"

		east
			codes_txt = "delivery;dir=4"
		south
			codes_txt = "delivery;dir=2"
		west
			codes_txt = "delivery;dir=8"
	hallway_central_north
		location = "Central Primary Hallway"
		codes_txt = "delivery;dir=1"

		east
			codes_txt = "delivery;dir=4"
		south
			codes_txt = "delivery;dir=2"
		west
			codes_txt = "delivery;dir=8"