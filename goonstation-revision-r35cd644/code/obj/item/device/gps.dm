/obj/item/device/gps
	name = "space GPS"
	desc = "Tells you your coordinates based on the nearest coordinate beacon."
	icon_state = "gps"
	item_state = "electronic"
	var/allowtrack = 1 // defaults to on so people know where you are (sort of!)
	var/serial = "4200" // shouldnt show up as this
	var/identifier = "NT13" // four characters max plz
	var/distress = 0
	flags = FPRINT | TABLEPASS| CONDUCT
	w_class = 2.0
	m_amt = 50
	g_amt = 100
	mats = 2
	module_research = list("science" = 1, "devices" = 1, "miniaturization" = 8)

	proc/get_z_info(var/turf/T)
		. =  "Landmark: Unknown"
		if (!T)
			return
		if (!istype(T))
			T = get_turf(T)
		if (!T)
			return
		if (T.z == 1)
			if (map_setting == "DESTINY")
				. =  "Landmark: NSS Destiny"
			else
				. =  "Landmark: Station"
		else if (T.z == 2)
			. =  "Landmark: Restricted"
		else if (T.z == 3)
			. =  "Landmark: Debris Field"
		return

	proc/show_HTML(var/mob/user)
		if (!user)
			return
		user.machine = src
		var/HTML = "<span style='font-size:80%;text-align:right'><A href='byond://?src=\ref[src];refresh=6'>(Refresh)</A></span><br>"
		HTML += "Each GPS is coined with a unique four digit number followed by a four letter identifier.<br>This GPS is assigned <b>[serial]-[identifier]</b>.<hr>"
		HTML += "<A href='byond://?src=\ref[src];getcords=1'>Get Local Coordinates</A><BR>"
		if (allowtrack == 0)
			HTML += "<A href='byond://?src=\ref[src];track1=2'>Enable Tracking</A><BR>"
		if (allowtrack == 1)
			HTML += "<A href='byond://?src=\ref[src];track2=3'>Disable Tracking</A><BR>"
		HTML += "<A href='byond://?src=\ref[src];changeid=4'>Change Identifier</A><BR>"
		HTML += "<A href='byond://?src=\ref[src];help=5'>Toggle Distress Signal</A><BR>"
		HTML += "<hr>"

		HTML += "<b>GPSes</b>:<br>"
		for (var/obj/item/device/gps/G in world)
			if (G.allowtrack == 1)
				var/turf/T = get_turf(G.loc)
				if (!T)
					continue
				HTML += "<span style='font-size:80%'><b>[G.serial]-[G.identifier]</b> located at: [T.x], [T.y]. [src.get_z_info(T)]</span><br>"
				HTML += "<span style='font-size:65%'>[G.distress ? "<font color=\"red\">(DISTRESS)</font>" : "<font color=666666>(DISTRESS)</font>"]</span><br>"
		HTML += "<hr>"

		HTML += "<b>Tracking Implants</b>:<br>"
		for (var/obj/item/implant/tracking/imp in world)
			if (iscarbon(imp.loc))
				var/turf/T = get_turf(imp.loc)
				if (!T)
					continue
				HTML += "<span style='font-size:80%'><b>[imp.loc.name]</b> located at: [T.x], [T.y]. [src.get_z_info(T)]</span><br>"
		HTML += "<hr>"

		HTML += "<b>Beacons</b>:<br>"
		for (var/obj/machinery/beacon/B in machines)
			if (B.enabled == 1)
				var/turf/T = get_turf(B.loc)
				HTML += "<span style='font-size:80%'><b>[B.sname]</b> located at: [T.x], [T.y]. [src.get_z_info(T)]</span><br>"
		HTML += "<br>"

		//user << browse(HTML, "window=gps;size=400x540")
		user.Browse(HTML, "window=gps_[src];title=GPS;size=400x540")
		onclose(user, "gps")

	attack_self(mob/user as mob)
		if ((user.contents.Find(src) || user.contents.Find(src.master) || get_dist(src, user) <= 1 && istype(src.loc, /turf)))
			src.show_HTML(user)
		else
			//user << browse(null, "window=gps")
			user.Browse(null, "window=gps_[src]")
			user.machine = null
		return

	Topic(href, href_list)
		..()
		if (usr.stat || usr.restrained() || usr.lying)
			return
		if ((usr.contents.Find(src) || usr.contents.Find(src.master) || in_range(src, usr) && istype(src.loc, /turf)))
			usr.machine = src
			if(href_list["getcords"])
				boutput(usr, "<span style=\"color:blue\">Located at: <b>X</b>: [usr.x], <b>Y</b>: [usr.y]</span>")
			if(href_list["track1"])
				boutput(usr, "<span style=\"color:blue\">Tracking enabled.</span>")
				src.allowtrack = 1
			if(href_list["track2"])
				boutput(usr, "<span style=\"color:blue\">Tracking disabled.</span>")
				src.allowtrack = 0
			if(href_list["changeid"])
				var/t = strip_html(input(usr, "Enter new GPS identification name (must be 4 characters)", src.identifier) as text)
				if(length(t) > 4)
					boutput(usr, "<span style=\"color:red\">Input too long.</span>")
					return
				if(length(t) < 4)
					boutput(usr, "<span style=\"color:red\">Input too short.</span>")
					return
				if(!t)
					return
				src.identifier = t
			if(href_list["help"])
				if(!distress)
					boutput(usr, "<span style=\"color:red\">Sending distress signal.</span>")
					distress = 1
					//IBMNOTE: This really should be changed to use the radio system, for (x in world) sucks
					for(var/obj/item/device/gps/G in world)
						G.visible_message("<b>[bicon(G)] [G]</b> beeps, \"NOTICE: Distress signal recieved.\".")
				else
					distress = 0
					boutput(usr, "<span style=\"color:red\">Distress signal cleared.</span>")
					for(var/obj/item/device/gps/G in world)
						G.visible_message("<b>[bicon(G)] [G]</b> beeps, \"NOTICE: Distress signal cleared.\".")
			if(href_list["refresh"])
				..()
			if (!src.master)
				if (istype(src.loc, /mob))
					attack_self(src.loc)
				else
					for(var/mob/M in viewers(1, src))
						if (M.client && (M.machine == src.master || M.machine == src))
							src.attack_self(M)
			else
				if (istype(src.master.loc, /mob))
					src.attack_self(src.master.loc)
				else
					for(var/mob/M in viewers(1, src.master))
						if (M.client && (M.machine == src.master || M.machine == src))
							src.attack_self(M)
			src.add_fingerprint(usr)
		else
			//usr << browse(null, "window=gps")
			usr.Browse(null, "window=gps_[src]")
			return
		return


	New()
		serial = rand(4201,7999)
		desc += " It's serial code is [src.serial]-[identifier]."


// coordinate beacons. pretty useless but whatever you never know

/obj/machinery/beacon
	name = "coordinate beacon"
	desc = "A coordinate beacon used for space GPSes."
	icon = 'icons/obj/ship.dmi'
	icon_state = "beacon"
	var/sname = "unidentified"
	var/enabled = 1

	process()
		if(enabled == 1)
			use_power(50)

	attack_hand()
		enabled = !enabled
		boutput(usr, "<span style=\"color:blue\">You switch the beacon [src.enabled ? "on" : "off"].</span>")

	attack_ai(mob/user as mob)
		var/t = input(user, "Enter new beacon identification name", src.sname) as text
		t = strip_html(dd_replacetext(t, "'",""))
		t = copytext(t, 1, 45)
		if (!t)
			return
		src.sname = t