/datum/computer/file/computer_program/securitycam
	name = "SecView"
	size = 16.0
	var/network = "SS13"


	return_text()
		if(..())
			return

		var/dat = "<a href='byond://?src=\ref[src];close=1'>Close</a> | "
		dat += "<a href='byond://?src=\ref[src];quit=1'>Quit</a><br>"

		dat += "<b>SecView 1.00</b><br>"

		dat += "<a href='byond://?src=\ref[src];cameralist=1'>View Camera List</a>"

		return dat

	Topic(href, href_list)
		if(..())
			return
		if(href_list["cameralist"])
			if (!in_range(src.master, usr))
				return
			var/list/cameras = list()
			for (var/obj/machinery/camera/C in machines)
				cameras.Add(C)
			camera_sort(cameras)
			var/list/D = list()
			D["Cancel"] = "Cancel"
			for (var/obj/machinery/camera/C in cameras)
				if (C.network == src.network)
					D[text("[][]", C.c_tag, (C.status ? null : " (Deactivated)"))] = C
			var/t = input(usr, "Please select a camera:") as null|anything in D
			if(!t)
				usr.machine = null
				return 0
			var/obj/machinery/camera/C = D[t]
			if (t == "Cancel")
				usr.machine = null
				return 0
			if (C)
				usr.machine = C
				usr.reset_view(C)
//				usr.current = C
				master.current.use_power(50)

	receive_command(obj/source, command, datum/signal/signal)
		if(..() || !signal)
			return
