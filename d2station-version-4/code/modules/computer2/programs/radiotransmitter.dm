/datum/computer/file/computer_program/radiotransmitter
	name = "Radio Transmitter Control"
	size = 4.0
	program_screen_icon = "comm"
	var/transmitteron = 1


	return_text()
		if(..())
			return


		var/dat = "<a href='byond://?src=\ref[src];close=1'>Close</a> | "
		dat += "<a href='byond://?src=\ref[src];quit=1'>Quit</a><br>"

		dat += "<b>Radio Transmitter Control V2.1</b><br><br>"
		dat += "<b>Communication Lines:</b><br>"
		if (transmitteron == 1)
			dat += "<b>Status:</b> on<br>"
		else
			dat += "<b>Status:</b> off<br>"
		dat += "<a href='byond://?src=\ref[src];turnon=1'>Enable</a><br>"
		dat += "<a href='byond://?src=\ref[src];turnoff=1'>Disable</a>"

		dat += "</center>"

		return dat

	Topic(href, href_list)
		if(..())
			return

		if(href_list["turnon"])
			transmitteron = 1

		if(href_list["turnoff"])
			transmitteron = 0