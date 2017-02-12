/datum/computer/file/computer_program/crew
	name = "Crew Monitoring"
	size = 32.0
	program_screen_icon = "crew"
	var/authenticated = null
	var/rank = null
	var/screen = null
	var/datum/data/record/active1 = null
	var/datum/data/record/active2 = null
	var/a_id = null
	var/temp = null
	var

	var
		list/tracked

	New()
		tracked = list()
		..()

/datum/computer/file/computer_program/crew/return_text(mob/master)
	src.scan()
	//src.master.icon_state = "crew"
	var/t = "<TT><B>Crew Monitoring</B><HR>"
	t += "<BR><A href='?src=\ref[src];update=1'>Refresh</A>"
	t += "<BR><A href='?src=\ref[src];quit=1'>Close</A><br>"
	for(var/obj/item/clothing/under/C in src.tracked)
		if((C) && (C.has_sensor) && (C.loc) && (C.loc.z == 1))
			if(istype(C.loc, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = C.loc
				var/dam1 = round(H.oxyloss,1)
				var/dam2 = round(H.toxloss,1)
				var/dam3 = round(H.fireloss,1)
				var/dam4 = round(H.bruteloss,1)
				switch(C.sensor_mode)
					if(1)
						if(H.wear_id)
							t += "<br><font color=blue><b>[H.name]</font></b> - "
						else
							t += "<font color=blue><b>Unknown:</font></b>"
						t+= "[H.stat > 1 ? "<font color=red>Deceased</font>" : "Living"]<br>Not Available<br>"
					if(2)
						if(H.wear_id)
							t += "<br><br><font color=blue><b>[H.name]</font></b> - "
						else
							t += "<br><font color=blue><b>Unknown:></font></b>"
						t += "[H.stat > 1 ? "<font color=red>Deceased</font>" : "Living"]<br>Oxygen Deprivation - [dam1]<br>Toxins Damage  - [dam2]<br>Burn Damage - [dam3]<br>Brute Damage - [dam4]<br><br>Not Available<br>"
					if(3)
						t += "<br><font color=blue><b>[H.name]</font></b> - [H.stat > 1 ? "<font color=red>Deceased</font>" : "Living"]<br>Oxygen Deprivation - [dam1]<br>Toxins Damage  - [dam2]<br>Burn Damage - [dam3]<br>Brute Damage - [dam4]<br><br>[get_area(H)] ([H.x], [H.y])<br>"
	t += "</FONT></PRE></TT>"
	master << browse(t, "window=crewcomp;size=600x800")
	onclose(master, "quit")
	return t

/datum/computer/file/computer_program/crew/proc/scan()
	for(var/obj/item/clothing/under/C in world)
		if((C.has_sensor) && (istype(C.loc, /mob/living/carbon/human)))
			var/check = 0
			for(var/O in src.tracked)
				if(O == C)
					check = 1
					break
			if(!check)
				src.tracked.Add(C)
	return 1



/datum/computer/file/computer_program/crew/Topic(href, href_list)
	..()
	if(href_list["update"])
		master.updateDialog()
		return


