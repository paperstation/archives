/datum/computer/file/computer_program/Reactor
	name = "Reactor"
	size = 24.0
	program_screen_icon = "reactor"
	var/reactorid = ""
	var/powerpercentage = 100
	var/obj/machinery/power/Reactor/linked = list()
	id_tag = "test"
	var/oldpower = null

	New()
		..()
		for(var/obj/machinery/power/Reactor/R in machines)
			if(id_tag == R.id_tag)
				linked = R
				linked.outputlevel = powerpercentage

	return_text()
		if(..())
			return
		if(!linked)
			return
		var/dat = "<a href='byond://?src=\ref[src];close=1'>Close</a> | "
		dat += "<a href='byond://?src=\ref[src];quit=1'>Quit</a><br>"

		dat += "<b>Reactor Controls</b><br>"

		dat += {"Output:<BR>
				Current Output: [linked.output]KW<br>
				<A href='byond://?src=\ref[src];power=-5'>-</A>
				<A href='byond://?src=\ref[src];power=-1'>-</A>
				[powerpercentage]%
				<A href='byond://?src=\ref[src];power=1'>+</A>
				<A href='byond://?src=\ref[src];power=5'>+</A><BR>
				"}


		return dat
//	process()
///		..()
	//	oldpower = linked.output
	//	if(oldpower != linked.output)
	//		src.master.updateUsrDialog()


	Topic(href, href_list)
		if(..())
			return
		if (href_list["power"])
			powerpercentage  = (powerpercentage + text2num(href_list["power"]))
			linked.outputlevel = powerpercentage
			if(powerpercentage < 0)
				powerpercentage = 0
			if(powerpercentage > 150)
				powerpercentage = 150
		src.master.updateUsrDialog()

	receive_command(obj/source, command, datum/signal/signal)
		if(..() || !signal)
			return
