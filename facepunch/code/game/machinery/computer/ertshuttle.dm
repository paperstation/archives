//Config stuff
#define ert_MOVETIME 600	//Time to station is milliseconds.
#define ert_STATION_AREATYPE "/area/shuttle/transport1/centcom" //Type of the ert shuttle area for station
#define ert_DOCK_AREATYPE "/area/shuttle/transport1/station"	//Type of the ert shuttle area for dock

var/ert_shuttle_moving_to_station = 0
var/ert_shuttle_moving_to_ert = 0
var/ert_shuttle_at_station = 0
var/ert_shuttle_can_send = 1
var/ert_shuttle_time = 0
var/ert_shuttle_timeleft = 0

/obj/machinery/computer/ert_shuttle
	name = "ERP Shuttle Console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "shuttle"
	req_access = list(access_security)
	circuit = "/obj/item/weapon/circuitboard/ert_shuttle"
	var/temp = null
	var/hacked = 0
	var/allowedtocall = 0
	var/ert_break = 0
	var/donotreturn = 0


	attackby(I as obj, user as mob)
		return src.attack_hand(user)


	attack_ai(var/mob/user as mob)
		return src.attack_hand(user)


	attack_paw(var/mob/user as mob)
		return src.attack_hand(user)


	attackby(I as obj, user as mob)
		return src.attack_hand(user)


	attack_hand(var/mob/user as mob)
		if(!src.allowed(user) && (!hacked))
			user << "\red Access Denied."
			return
		if(ert_break)
			user << "\red Unable to locate shuttle."
			return
		if(..())
			return
		user.set_machine(src)
		post_signal("ert")
		var/dat
		if (src.temp)
			dat = src.temp
		else
			dat += {"<BR><B>ERP Shuttle</B><HR>
			\nLocation: [ert_shuttle_moving_to_station || ert_shuttle_moving_to_ert ? "Station":ert_shuttle_at_station ? "Station":"Dock"]<BR>
			[ert_shuttle_moving_to_station || ert_shuttle_moving_to_ert ? "\n*Shuttle already called*<BR>\n<BR>":ert_shuttle_at_station ? "\n<A href='?src=\ref[src];sendtodock=1'>Send to Dock</A><BR>\n<BR>":"\n<A href='?src=\ref[src];sendtostation=1'>Send to station</A><BR>\n<BR>"]
			\n<A href='?src=\ref[user];mach_close=computer'>Close</A>"}

		user << browse(dat, "window=computer;size=575x450")
		onclose(user, "computer")
		return


	Topic(href, href_list)
		if(..())
			return

		if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
			usr.set_machine(src)

		if (href_list["sendtodock"])
			if(donotreturn == 0 )
				if (!ert_can_move())
					usr << "\red The ERT shuttle is unable to leave."
					return
				if(!ert_shuttle_at_station|| ert_shuttle_moving_to_station || ert_shuttle_moving_to_ert) return
				post_signal("ert")
				src.temp += "Shuttle sent.<BR><BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
				src.updateUsrDialog()
				ert_shuttle_moving_to_ert = 1
				ert_shuttle_time = world.timeofday + ert_MOVETIME
				spawn(600)
					donotreturn = 1
					move_ferry()
			else
				return

		else if (href_list["sendtostation"])
			if(donotreturn == 0 )
				if (!ert_can_move())
					usr << "\red The ERT shuttle is unable to leave."
					return
				if(ert_shuttle_at_station || ert_shuttle_moving_to_station || ert_shuttle_moving_to_ert) return
				post_signal("ert")
				usr << "\blue The ERT shuttle has been called and will arrive at the station in [(ert_MOVETIME/10)] seconds."
				src.temp += "Shuttle sent.<BR><BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
				src.updateUsrDialog()
				ert_shuttle_moving_to_station = 1
				ert_shuttle_time = world.timeofday + ert_MOVETIME
				spawn(600)
					donotreturn = 1
					move_ferry()
			else
				return

		else if (href_list["mainmenu"])
			src.temp = null

		src.add_fingerprint(usr)
		src.updateUsrDialog()
		return


	proc/post_signal(var/command)
		var/datum/radio_frequency/frequency = radio_controller.return_frequency(1311)
		if(!frequency) return
		var/datum/signal/status_signal = new
		status_signal.source = src
		status_signal.transmission_method = 1
		status_signal.data["command"] = command
		frequency.post_signal(src, status_signal)
		return


	proc/ert_can_move()
		if(ert_shuttle_moving_to_station || ert_shuttle_moving_to_ert) return 0
		else return 1


	proc/ert_break()
		switch(ert_break)
			if (0)
				if(!ert_shuttle_at_station || ert_shuttle_moving_to_ert) return

				ert_shuttle_moving_to_ert = 1
				ert_shuttle_at_station = ert_shuttle_at_station

				if (!ert_shuttle_moving_to_ert || !ert_shuttle_moving_to_station)
					ert_shuttle_time = world.timeofday + ert_MOVETIME
				spawn(0)
				ert_break = 1
			if(1)
				ert_break = 0

