/obj/machinery/computer/card
	name = "Identification Computer"
	icon_state = "id"
	var/obj/item/card/id/scan = null
	var/obj/item/card/id/modify = null
	var/authenticated = 0.0
	var/mode = 0.0
	var/printing = null
	var/list/scan_access = null
	req_access = list(access_change_ids)
	desc = "A computer that allows an authorized user to change the identification of other ID cards."


/obj/machinery/computer/card/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/card/attack_hand(var/mob/user as mob)
	if(..())
		return

	user.machine = src
	var/dat
	if (!( ticker ))
		return
	if (src.mode) // accessing crew manifest
		var/crew = ""
		for(var/datum/data/record/t in data_core.general)
			crew += "[t.fields["name"]] - [t.fields["rank"]]<br>"
		dat = "<tt><b>Crew Manifest:</b><br>Please use security record computer to modify entries.<br>[crew]<a href='?src=\ref[src];print=1'>Print</a><br><br><a href='?src=\ref[src];mode=0'>Access ID modification console.</a><br></tt>"
	else
		var/header = "<b>Identification Card Modifier</b><br><i>Please insert the cards into the slots</i><br>"

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
		//When both IDs are inserted
		if (src.authenticated && src.modify)
			body = "Registered: <a href='?src=\ref[src];reg=1'>[target_owner]</a><br>"
			body += "Assignment: <a href='?src=\ref[src];assign=Custom Assignment'>[dd_replacetext(target_rank, " ", "&nbsp")]</a>"

			//Jobs organised into sections
			var/list/civilianjobs = list("Staff Assistant", "Barman", "Chef", "Botanist", "Chaplain", "Janitor", "Clown")
			var/list/maintainencejobs = list("Engineer", "Mechanic", "Miner", "Quartermaster")
			var/list/researchjobs = list("Scientist", "Medical Doctor", "Geneticist", "Roboticist")
			var/list/securityjobs = list("Security Officer", "Detective")
			var/list/commandjobs = list("Head of Personnel", "Chief Engineer", "Research Director", "Medical Director", "Captain")

			body += "<br><br><u>Jobs</u>"
			body += "<br>Civilian:"
			for(var/job in civilianjobs)
				body += " <a href='?src=\ref[src];assign=[job]'>[dd_replacetext(job, " ", "&nbsp")]</a>" //make sure there isn't a line break in the middle of a job

			body += "<br>Supply and Maintainence:"
			for(var/job in maintainencejobs)
				body += " <a href='?src=\ref[src];assign=[job]'>[dd_replacetext(job, " ", "&nbsp")]</a>"

			body += "<br>Research and Medical:"
			for(var/job in researchjobs)
				body += " <a href='?src=\ref[src];assign=[job]'>[dd_replacetext(job, " ", "&nbsp")]</a>"

			body += "<br>Security:"
			for(var/job in securityjobs)
				body += " <a href='?src=\ref[src];assign=[job]'>[dd_replacetext(job, " ", "&nbsp")]</a>"

			body += "<br>Command:"
			for(var/job in commandjobs)
				body += " <a href='?src=\ref[src];assign=[job]'>[dd_replacetext(job, " ", "&nbsp")]</a>"

			//Change access to individual areas
			body += "<br><br><u>Access</u>"

			//Organised into sections
			var/civilian_access = "<br>Staff:"
			var/list/civilian_access_list = list(6, 12, 22, 23, 25, 26, 27, 28, 35)
			var/engineering_access = "<br>Engineering:"
			/* Conor12: I removed some unused accesses as the page is large enough, add these if they ever get used:
			3 (access_armory). Replaced by HoS-exclusive access_maxsec.
			21 (access_all_personal_lockers). Current personal lockers don't have a master key.
			36 (access_mail)
			42 (access_engineering_eva)*/
			var/list/engineering_access_list = list(13, 32, 40, 41, 43, 44, 45, 46, 47, 48)
			var/supply_access = "<br>Supply:"
			var/list/supply_access_list = list(30, 31, 47, 50, 51)
			var/research_access = "<br>Science and Medical:"
			var/list/research_access_list = list(5, 7, 8, 9, 10, 24, 29, 33)
			var/security_access = "<br>Security:"
			var/list/security_access_list = list(1, 2, 4, 37, 38, 39)
			var/command_access = "<br>Command:"
			var/list/command_access_list = list(11, 14, 15, 16, 17, 18, 19, 20, 49, 53, 55, 56)

			for(var/A in access_name_lookup)
				if(access_name_lookup[A] in src.modify.access)
					//Click these to remove access
					if (access_name_lookup[A] in civilian_access_list)
						civilian_access += " <a href='?src=\ref[src];access=[access_name_lookup[A]];allowed=0'><font color=\"red\">[dd_replacetext(A, " ", "&nbsp")]</font></a>"
					if (access_name_lookup[A] in engineering_access_list)
						engineering_access += " <a href='?src=\ref[src];access=[access_name_lookup[A]];allowed=0'><font color=\"red\">[dd_replacetext(A, " ", "&nbsp")]</font></a>"
					if (access_name_lookup[A] in supply_access_list)
						supply_access += " <a href='?src=\ref[src];access=[access_name_lookup[A]];allowed=0'><font color=\"red\">[dd_replacetext(A, " ", "&nbsp")]</font></a>"
					if (access_name_lookup[A] in research_access_list)
						research_access += " <a href='?src=\ref[src];access=[access_name_lookup[A]];allowed=0'><font color=\"red\">[dd_replacetext(A, " ", "&nbsp")]</font></a>"
					if (access_name_lookup[A] in security_access_list)
						security_access += " <a href='?src=\ref[src];access=[access_name_lookup[A]];allowed=0'><font color=\"red\">[dd_replacetext(A, " ", "&nbsp")]</font></a>"
					if (access_name_lookup[A] in command_access_list)
						command_access += " <a href='?src=\ref[src];access=[access_name_lookup[A]];allowed=0'><font color=\"red\">[dd_replacetext(A, " ", "&nbsp")]</font></a>"
				else//Click these to add access
					if (access_name_lookup[A] in civilian_access_list)
						civilian_access += " <a href='?src=\ref[src];access=[access_name_lookup[A]];allowed=1'>[dd_replacetext(A, " ", "&nbsp")]</a>"
					if (access_name_lookup[A] in engineering_access_list)
						engineering_access += " <a href='?src=\ref[src];access=[access_name_lookup[A]];allowed=1'>[dd_replacetext(A, " ", "&nbsp")]</a>"
					if (access_name_lookup[A] in supply_access_list)
						supply_access += " <a href='?src=\ref[src];access=[access_name_lookup[A]];allowed=1'>[dd_replacetext(A, " ", "&nbsp")]</a>"
					if (access_name_lookup[A] in research_access_list)
						research_access += " <a href='?src=\ref[src];access=[access_name_lookup[A]];allowed=1'>[dd_replacetext(A, " ", "&nbsp")]</a>"
					if (access_name_lookup[A] in security_access_list)
						security_access += " <a href='?src=\ref[src];access=[access_name_lookup[A]];allowed=1'>[dd_replacetext(A, " ", "&nbsp")]</a>"
					if (access_name_lookup[A] in command_access_list)
						command_access += " <a href='?src=\ref[src];access=[access_name_lookup[A]];allowed=1'>[dd_replacetext(A, " ", "&nbsp")]</a>"

			body+= "[civilian_access]<br>[engineering_access]<br>[supply_access]<br>[research_access]<br>[security_access]<br>[command_access]"

			body += "<br><br><u>Customise ID</u><br>"
			body += "<a href='?src=\ref[src];colour=none'>Plain</a> "
			body += "<a href='?src=\ref[src];colour=blue'>Civilian</a> "
			body += "<a href='?src=\ref[src];colour=yellow'>Engineering</a> "
			body += "<a href='?src=\ref[src];colour=purple'>Research</a> "
			body += "<a href='?src=\ref[src];colour=red'>Security</a> "
			body += "<a href='?src=\ref[src];colour=green'>Command</a>"

			user.unlock_medal("Identity Theft", 1)

		else
			body = "<a href='?src=\ref[src];auth=1'>{Log in}</a>"
		dat = "<tt>[header][body]<hr><a href='?src=\ref[src];mode=1'>Access Crew Manifest</a><br></tt>"
	user << browse(dat, "window=id_com;size=725x500")
	onclose(user, "id_com")
	return

/obj/machinery/computer/card/Topic(href, href_list)
	if(..())
		return
	usr.machine = src
	if (href_list["modify"])
		if (src.modify)
			src.modify.update_name()
			src.modify.set_loc(src.loc)
			src.modify = null
		else
			var/obj/item/I = usr.equipped()
			if (istype(I, /obj/item/card/id))
				usr.drop_item()
				I.set_loc(src)
				src.modify = I
		src.authenticated = 0
		src.scan_access = null
	if (href_list["scan"])
		if (src.scan)
			src.scan.set_loc(src.loc)
			src.scan = null
		else
			var/obj/item/I = usr.equipped()
			if (istype(I, /obj/item/card/id))
				usr.drop_item()
				I.set_loc(src)
				src.scan = I
		src.authenticated = 0
		src.scan_access = null
	if (href_list["auth"])
		if ((!( src.authenticated ) && (src.scan || (issilicon(usr) && !isghostdrone(usr))) && (src.modify || src.mode)))
			if (src.check_access(src.scan))
				src.authenticated = 1
				src.scan_access = src.scan.access
		else if ((!( src.authenticated ) && (istype(usr, /mob/living/silicon))) && (!src.modify))
			boutput(usr, "You can't modify an ID without an ID inserted to modify. Once one is in the modify slot on the computer, you can log in.")
	if(href_list["access"] && href_list["allowed"])
		if(src.authenticated)
			var/access_type = text2num(href_list["access"])
			var/access_allowed = text2num(href_list["allowed"])
			if(access_type in get_all_accesses())
				src.modify.access -= access_type
				if(access_allowed == 1)
					src.modify.access += access_type

	if (href_list["assign"])
		if (src.authenticated && src.modify)
			var/t1 = href_list["assign"]

			if (t1 == "Custom Assignment")
				t1 = input(usr, "Enter a custom job assignment.", "Assignment")
				t1 = strip_html(t1, 100, 1)
			else
				src.modify.access = get_access(t1)

			src.modify.assignment = t1

	if (href_list["reg"])
		if (src.authenticated)
			var/t2 = src.modify

			var/t1 = input(usr, "What name?", "ID computer", null)
			t1 = strip_html(t1, 100, 1)

			if ((src.authenticated && src.modify == t2 && (in_range(src, usr) || (istype(usr, /mob/living/silicon))) && istype(src.loc, /turf)))
				src.modify.registered = t1

	if (href_list["mode"])
		src.mode = text2num(href_list["mode"])
	if (href_list["print"])
		if (!( src.printing ))
			src.printing = 1
			sleep(50)
			var/obj/item/paper/P = new /obj/item/paper( src.loc )
			var/t1 = "<B>Crew Manifest:</B><BR>"
			for(var/datum/data/record/t in data_core.general)
				t1 += "<B>[t.fields["name"]]</B> - [t.fields["rank"]]<BR>"
			P.info = t1
			P.name = "paper- 'Crew Manifest'"
			src.printing = null
	if (href_list["mode"])
		src.authenticated = 0
		src.scan_access = null
		src.mode = text2num(href_list["mode"])
	if (href_list["colour"])
		if(src.modify && src.modify.icon_state != "gold" && src.modify.icon_state != "id_clown")
			var/newcolour = href_list["colour"]
			if (newcolour == "none")
				src.modify.icon_state = "id"
			if (newcolour == "blue")
				src.modify.icon_state = "id_civ"
			if (newcolour == "yellow")
				src.modify.icon_state = "id_eng"
			if (newcolour == "purple")
				src.modify.icon_state = "id_res"
			if (newcolour == "red")
				src.modify.icon_state = "id_sec"
			if (newcolour == "green")
				src.modify.icon_state = "id_com"
	if (src.modify)
		src.modify.name = "[src.modify.registered]'s ID Card ([src.modify.assignment])"
	src.updateUsrDialog()
	return

/obj/machinery/computer/card/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/screwdriver))
		playsound(src.loc, "sound/items/Screwdriver.ogg", 50, 1)
		if(do_after(user, 20))
			if (src.stat & BROKEN)
				boutput(user, "<span style=\"color:blue\">The broken glass falls out.</span>")
				var/obj/computerframe/A = new /obj/computerframe( src.loc )
				if(src.material) A.setMaterial(src.material)
				new /obj/item/raw_material/shard/glass( src.loc )
				var/obj/item/circuitboard/card/M = new /obj/item/circuitboard/card( A )
				for (var/obj/C in src)
					C.set_loc(src.loc)
				A.circuit = M
				A.state = 3
				A.icon_state = "3"
				A.anchored = 1
				qdel(src)
			else
				boutput(user, "<span style=\"color:blue\">You disconnect the monitor.</span>")
				var/obj/computerframe/A = new /obj/computerframe( src.loc )
				if(src.material) A.setMaterial(src.material)
				var/obj/item/circuitboard/card/M = new /obj/item/circuitboard/card( A )
				for (var/obj/C in src)
					C.set_loc(src.loc)
				A.circuit = M
				A.state = 4
				A.icon_state = "4"
				A.anchored = 1
				qdel(src)
	else if (istype(I, /obj/item/card/id))
		if (!src.scan)
			boutput(user, "<span style=\"color:blue\">You insert [I] into the authentication card slot.</span>")
			user.drop_item()
			I.set_loc(src)
			src.scan = I
		else if (!src.modify)
			boutput(user, "<span style=\"color:blue\">You insert [I] into the target card slot.</span>")
			user.drop_item()
			I.set_loc(src)
			src.modify = I
		src.updateUsrDialog()

	else
		src.attack_hand(user)
	return