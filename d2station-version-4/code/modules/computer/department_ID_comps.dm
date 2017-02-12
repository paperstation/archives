/obj/machinery/computer/card/RD
	name = "Research and Development's Identification Computer"
	desc = "You can use this to change ID's. YOU ARE GOD!"
	icon_state = "idRD"
	req_access = list(access_change_ids_RD)

/obj/machinery/computer/card/RD/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/card/RD/attack_paw(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/card/RD/attack_hand(var/mob/user as mob)
	user.machine = src
	var/dat
	if (!( ticker ))
		return
	if (src.mode) // accessing crew manifest
		var/crew = ""
		for(var/datum/data/record/t in data_core.general)
			crew += "[t.fields["name"]] - [t.fields["rank"]]<br>"
		dat = "<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><tt><b>Crew Manifest:</b><br>Please use security record computer to modify entries.<br>[crew]<a href='?src=\ref[src];print=1'>Print</a><br><br><a href='?src=\ref[src];mode=0'>Access ID modification console.</a><br></tt>"
	else
		var/header = "<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><b>Identification Card Modifier</b><br><i>Please insert the cards into the slots</i><br>"

		var/target_name
		var/target_owner
		var/target_rank
		if(src.modify)
			target_name = src.modify.name
		else
			target_name = "--------"
		if(src.modify && src.modify.registered)
			target_owner = src.modify.registered
		else
			target_owner = "--------"
		if(src.modify && src.modify.assignment)
			target_rank = src.modify.assignment
		else
			target_rank = "Unassigned"
		header += "Target: <a href='?src=\ref[src];modify=1'>[target_name]</a><br>"

		var/scan_name
		if(src.scan)
			scan_name = src.scan.name
		else
			scan_name = "--------"
		header += "Confirm Identity: <a href='?src=\ref[src];scan=1'>[scan_name]</a><br>"
		header += "<hr>"
		var/body
		if (src.authenticated && src.modify)
			var/carddesc = "Registered: <a href='?src=\ref[src];reg=1'>[target_owner]</a><br>Assignment: [target_rank]"
			var/list/alljobs = get_all_jobsRD() + "Custom"
			var/jobs = ""
			for(var/job in alljobs)
				jobs += "<a href='?src=\ref[src];assign=[job]'>[dd_replacetext(job, " ", "&nbsp")]</a> " //make sure there isn't a line break in the middle of a job
			var/accesses = ""
			for(var/A in get_all_accessesRD())
				if(A in src.modify.access)
					accesses += "<a href='?src=\ref[src];access=[A];allowed=0'><font color=\"red\">[dd_replacetext(get_access_desc(A), " ", "&nbsp")]</font></a> "
				else
					accesses += "<a href='?src=\ref[src];access=[A];allowed=1'>[dd_replacetext(get_access_desc(A), " ", "&nbsp")]</a> "
			body = "[carddesc]<br>[jobs]<br><br>[accesses]"
		else
			body = "<a href='?src=\ref[src];auth=1'>{Log in}</a>"
		dat = "<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><tt>[header][body]<hr><a href='?src=\ref[src];mode=1'>Access Crew Manifest</a><br></tt>"
	user << browse(dat, "window=id_com;size=700x375")
	onclose(user, "id_com")
	return

/obj/machinery/computer/card/RD/Topic(href, href_list)
	usr.machine = src
	if (href_list["modify"])
		if (src.modify)
			src.modify.name = text("[]'s ID Card ([])", src.modify.registered, src.modify.assignment)
			src.modify.loc = src.loc
			src.modify = null
		else
			var/obj/item/I = usr.equipped()
			if (istype(I, /obj/item/weapon/card/id))
				usr.drop_item()
				I.loc = src
				src.modify = I
		src.authenticated = 0
	if (href_list["scan"])
		if (src.scan)
			src.scan.loc = src.loc
			src.scan = null
		else
			var/obj/item/I = usr.equipped()
			if (istype(I, /obj/item/weapon/card/id))
				usr.drop_item()
				I.loc = src
				src.scan = I
		src.authenticated = 0
	if (href_list["auth"])
		if ((!( src.authenticated ) && (src.scan || (istype(usr, /mob/living/silicon))) && (src.modify || src.mode)))
			if (src.check_access(src.scan))
				src.authenticated = 1
		else if ((!( src.authenticated ) && (istype(usr, /mob/living/silicon))) && (!src.modify))
			usr << "You can't modify an ID without an ID inserted to modify. Once one is in the modify slot on the computer, you can log in."
	if(href_list["access"] && href_list["allowed"])
		if(src.authenticated)
			var/access_type = text2num(href_list["access"])
			var/access_allowed = text2num(href_list["allowed"])
			if(access_type in get_all_accessesRD())
				src.modify.access -= access_type
				if(access_allowed == 1)
					src.modify.access += access_type
	if (href_list["assign"])
		if (src.authenticated)
			var/t1 = href_list["assign"]
			if(t1 == "Custom")
				t1 = strip_html(input("Enter a custom job assignment.","Assignment"), 35)
			else
				src.modify.access = get_access(t1)
			if (src.modify)
				src.modify.assignment = t1
	if (href_list["reg"])
		if (src.authenticated)
			var/t2 = src.modify
			var/t1 = strip_html(input(usr, "What name?", "ID computer", null), 35)  as text
			if ((src.authenticated && src.modify == t2 && (in_range(src, usr) || (istype(usr, /mob/living/silicon))) && istype(src.loc, /turf)))
				src.modify.registered = t1
	if (href_list["mode"])
		src.mode = text2num(href_list["mode"])
	if (href_list["print"])
		if (!( src.printing ))
			src.printing = 1
			sleep(50)
			var/obj/item/weapon/paper/P = new /obj/item/weapon/paper( src.loc )
			var/t1 = "<B>Crew Manifest:</B><BR>"
			for(var/datum/data/record/t in data_core.general)
				t1 += "<B>[t.fields["name"]]</B> - [t.fields["rank"]]<BR>"
			P.info = t1
			P.name = "paper- 'Crew Manifest'"
			src.printing = null
	if (href_list["mode"])
		src.authenticated = 0
		src.mode = text2num(href_list["mode"])
	if (src.modify)
		src.modify.name = text("[]'s ID Card ([])", src.modify.registered, src.modify.assignment)
	src.updateUsrDialog()
	return

/obj/machinery/computer/card/RD/attackby(I as obj, user as mob)
	if(istype(I, /obj/item/weapon/screwdriver))
		playsound(src.loc, 'Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			if (src.stat & BROKEN)
				user << "\blue The broken glass falls out."
				var/obj/computerframe/A = new /obj/computerframe( src.loc )
				new /obj/item/weapon/shard( src.loc )
				var/obj/item/weapon/circuitboard/card/M = new /obj/item/weapon/circuitboard/card( A )
				for (var/obj/C in src)
					C.loc = src.loc
				A.circuit = M
				A.state = 3
				A.icon_state = "3"
				A.anchored = 1
				del(src)
			else
				user << "\blue You disconnect the monitor."
				var/obj/computerframe/A = new /obj/computerframe( src.loc )
				var/obj/item/weapon/circuitboard/card/M = new /obj/item/weapon/circuitboard/card( A )
				for (var/obj/C in src)
					C.loc = src.loc
				A.circuit = M
				A.state = 4
				A.icon_state = "4"
				A.anchored = 1
				del(src)
	else
		src.attack_hand(user)
	return


	////////////////////////////// MEDICAL START


/obj/machinery/computer/card/Medical
	name = "Medbay's Identification Computer"
	desc = "You can use this to change ID's. YOU ARE GOD!"
	icon_state = "idMedBay"
	req_access = list(access_change_ids_Medical)

/obj/machinery/computer/card/Medical/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/card/Medical/attack_paw(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/card/Medical/attack_hand(var/mob/user as mob)
	user.machine = src
	var/dat
	if (!( ticker ))
		return
	if (src.mode) // accessing crew manifest
		var/crew = ""
		for(var/datum/data/record/t in data_core.general)
			crew += "[t.fields["name"]] - [t.fields["rank"]]<br>"
		dat = "<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><tt><b>Crew Manifest:</b><br>Please use security record computer to modify entries.<br>[crew]<a href='?src=\ref[src];print=1'>Print</a><br><br><a href='?src=\ref[src];mode=0'>Access ID modification console.</a><br></tt>"
	else
		var/header = "<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><b>Identification Card Modifier</b><br><i>Please insert the cards into the slots</i><br>"

		var/target_name
		var/target_owner
		var/target_rank
		if(src.modify)
			target_name = src.modify.name
		else
			target_name = "--------"
		if(src.modify && src.modify.registered)
			target_owner = src.modify.registered
		else
			target_owner = "--------"
		if(src.modify && src.modify.assignment)
			target_rank = src.modify.assignment
		else
			target_rank = "Unassigned"
		header += "Target: <a href='?src=\ref[src];modify=1'>[target_name]</a><br>"

		var/scan_name
		if(src.scan)
			scan_name = src.scan.name
		else
			scan_name = "--------"
		header += "Confirm Identity: <a href='?src=\ref[src];scan=1'>[scan_name]</a><br>"
		header += "<hr>"
		var/body
		if (src.authenticated && src.modify)
			var/carddesc = "Registered: <a href='?src=\ref[src];reg=1'>[target_owner]</a><br>Assignment: [target_rank]"
			var/list/alljobs = get_all_jobsMedical() + "Custom"
			var/jobs = ""
			for(var/job in alljobs)
				jobs += "<a href='?src=\ref[src];assign=[job]'>[dd_replacetext(job, " ", "&nbsp")]</a> " //make sure there isn't a line break in the middle of a job
			var/accesses = ""
			for(var/A in get_all_accesses_Medical())
				if(A in src.modify.access)
					accesses += "<a href='?src=\ref[src];access=[A];allowed=0'><font color=\"red\">[dd_replacetext(get_access_desc(A), " ", "&nbsp")]</font></a> "
				else
					accesses += "<a href='?src=\ref[src];access=[A];allowed=1'>[dd_replacetext(get_access_desc(A), " ", "&nbsp")]</a> "
			body = "[carddesc]<br>[jobs]<br><br>[accesses]"
		else
			body = "<a href='?src=\ref[src];auth=1'>{Log in}</a>"
		dat = "<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><tt>[header][body]<hr><a href='?src=\ref[src];mode=1'>Access Crew Manifest</a><br></tt>"
	user << browse(dat, "window=id_com;size=700x375")
	onclose(user, "id_com")
	return

/obj/machinery/computer/card/Medical/Topic(href, href_list)
	usr.machine = src
	if (href_list["modify"])
		if (src.modify)
			src.modify.name = text("[]'s ID Card ([])", src.modify.registered, src.modify.assignment)
			src.modify.loc = src.loc
			src.modify = null
		else
			var/obj/item/I = usr.equipped()
			if (istype(I, /obj/item/weapon/card/id))
				usr.drop_item()
				I.loc = src
				src.modify = I
		src.authenticated = 0
	if (href_list["scan"])
		if (src.scan)
			src.scan.loc = src.loc
			src.scan = null
		else
			var/obj/item/I = usr.equipped()
			if (istype(I, /obj/item/weapon/card/id))
				usr.drop_item()
				I.loc = src
				src.scan = I
		src.authenticated = 0
	if (href_list["auth"])
		if ((!( src.authenticated ) && (src.scan || (istype(usr, /mob/living/silicon))) && (src.modify || src.mode)))
			if (src.check_access(src.scan))
				src.authenticated = 1
		else if ((!( src.authenticated ) && (istype(usr, /mob/living/silicon))) && (!src.modify))
			usr << "You can't modify an ID without an ID inserted to modify. Once one is in the modify slot on the computer, you can log in."
	if(href_list["access"] && href_list["allowed"])
		if(src.authenticated)
			var/access_type = text2num(href_list["access"])
			var/access_allowed = text2num(href_list["allowed"])
			if(access_type in get_all_accesses_Medical())
				src.modify.access -= access_type
				if(access_allowed == 1)
					src.modify.access += access_type
	if (href_list["assign"])
		if (src.authenticated)
			var/t1 = href_list["assign"]
			if(t1 == "Custom")
				t1 = strip_html(input("Enter a custom job assignment.","Assignment"), 35)
			else
				src.modify.access = get_access(t1)
			if (src.modify)
				src.modify.assignment = t1
	if (href_list["reg"])
		if (src.authenticated)
			var/t2 = src.modify
			var/t1 = strip_html(input(usr, "What name?", "ID computer", null), 35)  as text
			if ((src.authenticated && src.modify == t2 && (in_range(src, usr) || (istype(usr, /mob/living/silicon))) && istype(src.loc, /turf)))
				src.modify.registered = t1
	if (href_list["mode"])
		src.mode = text2num(href_list["mode"])
	if (href_list["print"])
		if (!( src.printing ))
			src.printing = 1
			sleep(50)
			var/obj/item/weapon/paper/P = new /obj/item/weapon/paper( src.loc )
			var/t1 = "<B>Crew Manifest:</B><BR>"
			for(var/datum/data/record/t in data_core.general)
				t1 += "<B>[t.fields["name"]]</B> - [t.fields["rank"]]<BR>"
			P.info = t1
			P.name = "paper- 'Crew Manifest'"
			src.printing = null
	if (href_list["mode"])
		src.authenticated = 0
		src.mode = text2num(href_list["mode"])
	if (src.modify)
		src.modify.name = text("[]'s ID Card ([])", src.modify.registered, src.modify.assignment)
	src.updateUsrDialog()
	return

/obj/machinery/computer/card/Medical/attackby(I as obj, user as mob)
	if(istype(I, /obj/item/weapon/screwdriver))
		playsound(src.loc, 'Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			if (src.stat & BROKEN)
				user << "\blue The broken glass falls out."
				var/obj/computerframe/A = new /obj/computerframe( src.loc )
				new /obj/item/weapon/shard( src.loc )
				var/obj/item/weapon/circuitboard/card/M = new /obj/item/weapon/circuitboard/card( A )
				for (var/obj/C in src)
					C.loc = src.loc
				A.circuit = M
				A.state = 3
				A.icon_state = "3"
				A.anchored = 1
				del(src)
			else
				user << "\blue You disconnect the monitor."
				var/obj/computerframe/A = new /obj/computerframe( src.loc )
				var/obj/item/weapon/circuitboard/card/M = new /obj/item/weapon/circuitboard/card( A )
				for (var/obj/C in src)
					C.loc = src.loc
				A.circuit = M
				A.state = 4
				A.icon_state = "4"
				A.anchored = 1
				del(src)
	else
		src.attack_hand(user)
	return


	////////////////////////////// SECURITY START


/obj/machinery/computer/card/Sec
	name = "Security's Identification Computer"
	desc = "You can use this to change ID's. YOU ARE GOD!"
	icon_state = "idSec"
	req_access = list(access_change_ids_Security)

/obj/machinery/computer/card/Sec/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/card/Sec/attack_paw(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/card/Sec/attack_hand(var/mob/user as mob)
	user.machine = src
	var/dat
	if (!( ticker ))
		return
	if (src.mode) // accessing crew manifest
		var/crew = ""
		for(var/datum/data/record/t in data_core.general)
			crew += "[t.fields["name"]] - [t.fields["rank"]]<br>"
		dat = "<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><tt><b>Crew Manifest:</b><br>Please use security record computer to modify entries.<br>[crew]<a href='?src=\ref[src];print=1'>Print</a><br><br><a href='?src=\ref[src];mode=0'>Access ID modification console.</a><br></tt>"
	else
		var/header = "<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><b>Identification Card Modifier</b><br><i>Please insert the cards into the slots</i><br>"

		var/target_name
		var/target_owner
		var/target_rank
		if(src.modify)
			target_name = src.modify.name
		else
			target_name = "--------"
		if(src.modify && src.modify.registered)
			target_owner = src.modify.registered
		else
			target_owner = "--------"
		if(src.modify && src.modify.assignment)
			target_rank = src.modify.assignment
		else
			target_rank = "Unassigned"
		header += "Target: <a href='?src=\ref[src];modify=1'>[target_name]</a><br>"

		var/scan_name
		if(src.scan)
			scan_name = src.scan.name
		else
			scan_name = "--------"
		header += "Confirm Identity: <a href='?src=\ref[src];scan=1'>[scan_name]</a><br>"
		header += "<hr>"
		var/body
		if (src.authenticated && src.modify)
			var/carddesc = "Registered: <a href='?src=\ref[src];reg=1'>[target_owner]</a><br>Assignment: [target_rank]"
			var/list/alljobs = get_all_jobsSec() + "Custom"
			var/jobs = ""
			for(var/job in alljobs)
				jobs += "<a href='?src=\ref[src];assign=[job]'>[dd_replacetext(job, " ", "&nbsp")]</a> " //make sure there isn't a line break in the middle of a job
			var/accesses = ""
			for(var/A in get_all_accesses_Sec())
				if(A in src.modify.access)
					accesses += "<a href='?src=\ref[src];access=[A];allowed=0'><font color=\"red\">[dd_replacetext(get_access_desc(A), " ", "&nbsp")]</font></a> "
				else
					accesses += "<a href='?src=\ref[src];access=[A];allowed=1'>[dd_replacetext(get_access_desc(A), " ", "&nbsp")]</a> "
			body = "[carddesc]<br>[jobs]<br><br>[accesses]"
		else
			body = "<a href='?src=\ref[src];auth=1'>{Log in}</a>"
		dat = "<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><tt>[header][body]<hr><a href='?src=\ref[src];mode=1'>Access Crew Manifest</a><br></tt>"
	user << browse(dat, "window=id_com;size=700x375")
	onclose(user, "id_com")
	return

/obj/machinery/computer/card/Sec/Topic(href, href_list)
	usr.machine = src
	if (href_list["modify"])
		if (src.modify)
			src.modify.name = text("[]'s ID Card ([])", src.modify.registered, src.modify.assignment)
			src.modify.loc = src.loc
			src.modify = null
		else
			var/obj/item/I = usr.equipped()
			if (istype(I, /obj/item/weapon/card/id))
				usr.drop_item()
				I.loc = src
				src.modify = I
		src.authenticated = 0
	if (href_list["scan"])
		if (src.scan)
			src.scan.loc = src.loc
			src.scan = null
		else
			var/obj/item/I = usr.equipped()
			if (istype(I, /obj/item/weapon/card/id))
				usr.drop_item()
				I.loc = src
				src.scan = I
		src.authenticated = 0
	if (href_list["auth"])
		if ((!( src.authenticated ) && (src.scan || (istype(usr, /mob/living/silicon))) && (src.modify || src.mode)))
			if (src.check_access(src.scan))
				src.authenticated = 1
		else if ((!( src.authenticated ) && (istype(usr, /mob/living/silicon))) && (!src.modify))
			usr << "You can't modify an ID without an ID inserted to modify. Once one is in the modify slot on the computer, you can log in."
	if(href_list["access"] && href_list["allowed"])
		if(src.authenticated)
			var/access_type = text2num(href_list["access"])
			var/access_allowed = text2num(href_list["allowed"])
			if(access_type in get_all_accesses_Sec())
				src.modify.access -= access_type
				if(access_allowed == 1)
					src.modify.access += access_type
	if (href_list["assign"])
		if (src.authenticated)
			var/t1 = href_list["assign"]
			if(t1 == "Custom")
				t1 = strip_html(input("Enter a custom job assignment.","Assignment"), 35)
			else
				src.modify.access = get_access(t1)
			if (src.modify)
				src.modify.assignment = t1
	if (href_list["reg"])
		if (src.authenticated)
			var/t2 = src.modify
			var/t1 = strip_html(input(usr, "What name?", "ID computer", null), 35)  as text
			if ((src.authenticated && src.modify == t2 && (in_range(src, usr) || (istype(usr, /mob/living/silicon))) && istype(src.loc, /turf)))
				src.modify.registered = t1
	if (href_list["mode"])
		src.mode = text2num(href_list["mode"])
	if (href_list["print"])
		if (!( src.printing ))
			src.printing = 1
			sleep(50)
			var/obj/item/weapon/paper/P = new /obj/item/weapon/paper( src.loc )
			var/t1 = "<B>Crew Manifest:</B><BR>"
			for(var/datum/data/record/t in data_core.general)
				t1 += "<B>[t.fields["name"]]</B> - [t.fields["rank"]]<BR>"
			P.info = t1
			P.name = "paper- 'Crew Manifest'"
			src.printing = null
	if (href_list["mode"])
		src.authenticated = 0
		src.mode = text2num(href_list["mode"])
	if (src.modify)
		src.modify.name = text("[]'s ID Card ([])", src.modify.registered, src.modify.assignment)
	src.updateUsrDialog()
	return

/obj/machinery/computer/card/Sec/attackby(I as obj, user as mob)
	if(istype(I, /obj/item/weapon/screwdriver))
		playsound(src.loc, 'Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			if (src.stat & BROKEN)
				user << "\blue The broken glass falls out."
				var/obj/computerframe/A = new /obj/computerframe( src.loc )
				new /obj/item/weapon/shard( src.loc )
				var/obj/item/weapon/circuitboard/card/M = new /obj/item/weapon/circuitboard/card( A )
				for (var/obj/C in src)
					C.loc = src.loc
				A.circuit = M
				A.state = 3
				A.icon_state = "3"
				A.anchored = 1
				del(src)
			else
				user << "\blue You disconnect the monitor."
				var/obj/computerframe/A = new /obj/computerframe( src.loc )
				var/obj/item/weapon/circuitboard/card/M = new /obj/item/weapon/circuitboard/card( A )
				for (var/obj/C in src)
					C.loc = src.loc
				A.circuit = M
				A.state = 4
				A.icon_state = "4"
				A.anchored = 1
				del(src)
	else
		src.attack_hand(user)
	return

	////////////////////////////// Engineering Start


/obj/machinery/computer/card/Engineering
	name = "Engineer's Identification Computer"
	desc = "You can use this to change ID's. YOU ARE GOD!"
	icon_state = "idEng"
	req_access = list(access_change_ids_Engineering)

/obj/machinery/computer/card/Engineering/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/card/Engineering/attack_paw(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/card/Engineering/attack_hand(var/mob/user as mob)
	user.machine = src
	var/dat
	if (!( ticker ))
		return
	if (src.mode) // accessing crew manifest
		var/crew = ""
		for(var/datum/data/record/t in data_core.general)
			crew += "[t.fields["name"]] - [t.fields["rank"]]<br>"
		dat = "<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><tt><b>Crew Manifest:</b><br>Please use security record computer to modify entries.<br>[crew]<a href='?src=\ref[src];print=1'>Print</a><br><br><a href='?src=\ref[src];mode=0'>Access ID modification console.</a><br></tt>"
	else
		var/header = "<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><b>Identification Card Modifier</b><br><i>Please insert the cards into the slots</i><br>"

		var/target_name
		var/target_owner
		var/target_rank
		if(src.modify)
			target_name = src.modify.name
		else
			target_name = "--------"
		if(src.modify && src.modify.registered)
			target_owner = src.modify.registered
		else
			target_owner = "--------"
		if(src.modify && src.modify.assignment)
			target_rank = src.modify.assignment
		else
			target_rank = "Unassigned"
		header += "Target: <a href='?src=\ref[src];modify=1'>[target_name]</a><br>"

		var/scan_name
		if(src.scan)
			scan_name = src.scan.name
		else
			scan_name = "--------"
		header += "Confirm Identity: <a href='?src=\ref[src];scan=1'>[scan_name]</a><br>"
		header += "<hr>"
		var/body
		if (src.authenticated && src.modify)
			var/carddesc = "Registered: <a href='?src=\ref[src];reg=1'>[target_owner]</a><br>Assignment: [target_rank]"
			var/list/alljobs = get_all_jobsEng() + "Custom"
			var/jobs = ""
			for(var/job in alljobs)
				jobs += "<a href='?src=\ref[src];assign=[job]'>[dd_replacetext(job, " ", "&nbsp")]</a> " //make sure there isn't a line break in the middle of a job
			var/accesses = ""
			for(var/A in get_all_accesses_Eng())
				if(A in src.modify.access)
					accesses += "<a href='?src=\ref[src];access=[A];allowed=0'><font color=\"red\">[dd_replacetext(get_access_desc(A), " ", "&nbsp")]</font></a> "
				else
					accesses += "<a href='?src=\ref[src];access=[A];allowed=1'>[dd_replacetext(get_access_desc(A), " ", "&nbsp")]</a> "
			body = "[carddesc]<br>[jobs]<br><br>[accesses]"
		else
			body = "<a href='?src=\ref[src];auth=1'>{Log in}</a>"
		dat = "<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><tt>[header][body]<hr><a href='?src=\ref[src];mode=1'>Access Crew Manifest</a><br></tt>"
	user << browse(dat, "window=id_com;size=700x375")
	onclose(user, "id_com")
	return

/obj/machinery/computer/card/Engineering/Topic(href, href_list)
	usr.machine = src
	if (href_list["modify"])
		if (src.modify)
			src.modify.name = text("[]'s ID Card ([])", src.modify.registered, src.modify.assignment)
			src.modify.loc = src.loc
			src.modify = null
		else
			var/obj/item/I = usr.equipped()
			if (istype(I, /obj/item/weapon/card/id))
				usr.drop_item()
				I.loc = src
				src.modify = I
		src.authenticated = 0
	if (href_list["scan"])
		if (src.scan)
			src.scan.loc = src.loc
			src.scan = null
		else
			var/obj/item/I = usr.equipped()
			if (istype(I, /obj/item/weapon/card/id))
				usr.drop_item()
				I.loc = src
				src.scan = I
		src.authenticated = 0
	if (href_list["auth"])
		if ((!( src.authenticated ) && (src.scan || (istype(usr, /mob/living/silicon))) && (src.modify || src.mode)))
			if (src.check_access(src.scan))
				src.authenticated = 1
		else if ((!( src.authenticated ) && (istype(usr, /mob/living/silicon))) && (!src.modify))
			usr << "You can't modify an ID without an ID inserted to modify. Once one is in the modify slot on the computer, you can log in."
	if(href_list["access"] && href_list["allowed"])
		if(src.authenticated)
			var/access_type = text2num(href_list["access"])
			var/access_allowed = text2num(href_list["allowed"])
			if(access_type in get_all_accesses_Eng())
				src.modify.access -= access_type
				if(access_allowed == 1)
					src.modify.access += access_type
	if (href_list["assign"])
		if (src.authenticated)
			var/t1 = href_list["assign"]
			if(t1 == "Custom")
				t1 = strip_html(input("Enter a custom job assignment.","Assignment"), 35)
			else
				src.modify.access = get_access(t1)
			if (src.modify)
				src.modify.assignment = t1
	if (href_list["reg"])
		if (src.authenticated)
			var/t2 = src.modify
			var/t1 = strip_html(input(usr, "What name?", "ID computer", null), 35)  as text
			if ((src.authenticated && src.modify == t2 && (in_range(src, usr) || (istype(usr, /mob/living/silicon))) && istype(src.loc, /turf)))
				src.modify.registered = t1
	if (href_list["mode"])
		src.mode = text2num(href_list["mode"])
	if (href_list["print"])
		if (!( src.printing ))
			src.printing = 1
			sleep(50)
			var/obj/item/weapon/paper/P = new /obj/item/weapon/paper( src.loc )
			var/t1 = "<B>Crew Manifest:</B><BR>"
			for(var/datum/data/record/t in data_core.general)
				t1 += "<B>[t.fields["name"]]</B> - [t.fields["rank"]]<BR>"
			P.info = t1
			P.name = "paper- 'Crew Manifest'"
			src.printing = null
	if (href_list["mode"])
		src.authenticated = 0
		src.mode = text2num(href_list["mode"])
	if (src.modify)
		src.modify.name = text("[]'s ID Card ([])", src.modify.registered, src.modify.assignment)
	src.updateUsrDialog()
	return

/obj/machinery/computer/card/Engineering/attackby(I as obj, user as mob)
	if(istype(I, /obj/item/weapon/screwdriver))
		playsound(src.loc, 'Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			if (src.stat & BROKEN)
				user << "\blue The broken glass falls out."
				var/obj/computerframe/A = new /obj/computerframe( src.loc )
				new /obj/item/weapon/shard( src.loc )
				var/obj/item/weapon/circuitboard/card/M = new /obj/item/weapon/circuitboard/card( A )
				for (var/obj/C in src)
					C.loc = src.loc
				A.circuit = M
				A.state = 3
				A.icon_state = "3"
				A.anchored = 1
				del(src)
			else
				user << "\blue You disconnect the monitor."
				var/obj/computerframe/A = new /obj/computerframe( src.loc )
				var/obj/item/weapon/circuitboard/card/M = new /obj/item/weapon/circuitboard/card( A )
				for (var/obj/C in src)
					C.loc = src.loc
				A.circuit = M
				A.state = 4
				A.icon_state = "4"
				A.anchored = 1
				del(src)
	else
		src.attack_hand(user)
	return