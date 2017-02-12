/datum/computer/file/computer_program/idcard
	name = "CardIdentity"
	size = 23.7
	program_screen_icon = "id"
	var/mode = 0.0
	var/printing = null
	req_access = list(access_change_ids)

	return_text()
		if(..())
			return
		var/dat = "<a href='byond://?src=\ref[src];close=1'>Close</a> | "
		dat += "<a href='byond://?src=\ref[src];quit=1'>Quit</a><br>"
		dat += "<b>CardIdentity V1.1.0</b><br>"
		if (src.mode) // accessing crew manifest
			var/crew = ""
			for(var/datum/data/record/t in data_core.general)
				crew += "[t.fields["name"]] - [t.fields["rank"]]<br>"
			dat = "<tt><b>Crew Manifest:</b><br>Please use security record computer to modify entries.<br>[crew]<a href='?src=\ref[src];print=1'>Print</a><br><br><a href='?src=\ref[src];mode=0'>Access ID modification console.</a><br></tt>"
			dat += "<br><a href='byond://?src=\ref[src];quit=1'>{Quit}</a>"
		else
			var/header = "<b>Identification Card Modifier</b><br><i>Please insert the cards into the slots</i><br>"

			var/target_name
			var/target_owner
			var/target_rank
			if(src.master.auxid)
				target_name = src.master.auxid.name
			else
				target_name = "--------"
			if(src.master.auxid && src.master.auxid.registered)
				target_owner = src.master.auxid.registered
			else
				target_owner = "--------"
			if(src.master.auxid && src.master.auxid.assignment)
				target_rank = src.master.auxid.assignment
			else
				target_rank = "Unassigned"
			header += "Target: <a href='?src=\ref[src];modify=1'>[target_name]</a><br>"

			var/scan_name
			if(src.master.authid)
				scan_name = src.master.authid.name
			else
				scan_name = "--------"
			header += "Confirm Identity: <a href='?src=\ref[src];scan=1'>[scan_name]</a><br>"
			header += "<hr>"
			var/body
			if (src.master.authenticated && src.master.auxid)
				var/carddesc = "Registered: <a href='?src=\ref[src];reg=1'>[target_owner]</a><br>Assignment: [target_rank]"
				var/list/alljobs = get_all_jobs() + "Custom"
				var/jobs = ""
				for(var/job in alljobs)
					jobs += "<a href='?src=\ref[src];assign=[job]'>[dd_replacetext(job, " ", "&nbsp")]</a> " //make sure there isn't a line break in the middle of a job
				var/accesses = ""
				var/i
				for(i = 1; i <= 7; i++)
					accesses += "<b>[get_region_accesses_name(i)]:</b> "
					for(var/A in get_region_accesses(i))
						if(A in src.master.auxid.access)
							accesses += "<a href='?src=\ref[src];access=[A];allowed=0'><font color=\"red\">[dd_replacetext(get_access_desc(A), " ", "&nbsp")]</font></a> "
						else
							accesses += "<a href='?src=\ref[src];access=[A];allowed=1'>[dd_replacetext(get_access_desc(A), " ", "&nbsp")]</a> "
					accesses += "<br>"
				body = "[carddesc]<br>[jobs]<br><br>[accesses]"
			else
				body = "<a href='?src=\ref[src];auth=1'>{Log in}</a>"
			dat = "<tt>[header][body]<hr><a href='?src=\ref[src];mode=1'>Access Crew Manifest</a><br></tt>"
			dat += "<br><a href='byond://?src=\ref[src];quit=1'>{Quit}</a>"
		return dat

	Topic(href, href_list)
		if(..())
			return

		if (href_list["modify"])
			if (src.master.auxid)
				src.master.auxid.name = text("[]'s ID Card ([])", src.master.auxid.registered, src.master.auxid.assignment)
				src.master.auxid.loc = src.master.loc
				src.master.auxid = null
			else
				var/obj/item/I = usr.equipped()
				if (istype(I, /obj/item/weapon/card/id))
					usr.drop_item()
					I.loc = src
					src.master.auxid = I
			src.master.authenticated = 0
		if (href_list["scan"])
			if (src.master.authid)
				src.master.authid.loc = src.master.loc
				src.master.authid = null
			else
				var/obj/item/I = usr.equipped()
				if (istype(I, /obj/item/weapon/card/id))
					usr.drop_item()
					I.loc = src
					src.master.authid = I
			src.master.authenticated = 0

		if (href_list["auth"])
			if ((!( src.master.authenticated ) && (src.master.authid || (istype(usr, /mob/living/silicon))) && (src.master.auxid || src.mode)))
				if (src.check_access(src.master.authid))
					src.master.authenticated = 1
			else if ((!( src.master.authenticated ) && (istype(usr, /mob/living/silicon))) && (!src.master.auxid))
				usr << "You can't modify an ID without an ID inserted to modify. Once one is in the modify slot on the computer, you can log in."
		if(href_list["access"] && href_list["allowed"])
			if(src.master.authenticated)
				var/access_type = text2num(href_list["access"])
				var/access_allowed = text2num(href_list["allowed"])
				if(access_type in get_all_accesses())
					src.master.auxid.access -= access_type
					if(access_allowed == 1)
						src.master.auxid.access += access_type
		if (href_list["assign"])
			if (src.master.authenticated)
				var/t1 = href_list["assign"]
				if(t1 == "Custom")
					t1 = input("Enter a custom job assignment.","Assignment")
				else
					src.master.auxid.access = get_access(t1)
				if (src.master.auxid)
					src.master.auxid.assignment = t1
		if (href_list["reg"])
			if (src.master.authenticated)
				var/t1 = input(usr, "What name?", "ID computer", null) as text
				src.master.auxid.registered = t1
		if (href_list["mode"])
			src.mode = text2num(href_list["mode"])
		if (href_list["print"])
			var/info = "<B>Crew Manifest:</B><BR>"
			for(var/datum/data/record/t in data_core.general)
				info += "<B>[t.fields["name"]]</B> - [t.fields["rank"]]<BR>"
			var/datum/signal/signal = new
			signal.data["data"] = info
			signal.data["title"] = "Crew Manifest"
			src.peripheral_command("print",signal)

		if (href_list["mode"])
			src.master.authenticated = 0
			src.mode = text2num(href_list["mode"])
		if (src.master.auxid)
			src.master.auxid.name = text("[]'s ID Card ([])", src.master.auxid.registered, src.master.auxid.assignment)

		src.master.add_fingerprint(usr)
		src.master.updateUsrDialog()
		return

	receive_command(obj/source, command, datum/signal/signal)
		if(..() || !signal)
			return
