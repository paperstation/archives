/datum/computer/file/computer_program/card
	name = "Crew Monitoring"
	size = 32.0
	active_icon = "crew"
	var/authenticated = null
	var/rank = null
	var/screen = null
	var/datum/data/record/active1 = null
	var/datum/data/record/active2 = null
	var/a_id = null
	var/temp = null
	req_access = list(access_medical)
	var/crew = ""
	var/header = "<b>Identification Card Modifier</b><br><i>Please insert the cards into the slots</i><br>"



	return_text()
		if(..())
			return
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
		src.master.icon_state = "computer_med_data"
		var/carddesc = "Registered: <a href='?src=\ref[src];reg=1'>[target_owner]</a><br>Assignment: [target_rank]"
		var/list/alljobs = get_all_jobs() + "Custom"
		var/jobs = ""
		for(var/job in alljobs)
			jobs += "<a href='?src=\ref[src];assign=[job]'>[dd_replacetext(job, " ", "&nbsp")]</a> " //make sure there isn't a line break in the middle of a job
		var/accesses = ""
		var/dat
		var/i
	/*	for(var/A in get_all_accesses())
			if(A in src.master.auxid.access)
				accesses += "<a href='?src=\ref[src];access=[A];allowed=0'><font color=\"red\">[dd_replacetext(get_access_desc(A), " ", "&nbsp")]</font></a> "
			else
				accesses += "<a href='?src=\ref[src];access=[A];allowed=1'>[dd_replacetext(get_access_desc(A), " ", "&nbsp")]</a> "
	*/
		if (src.temp)
			dat = text("<TT>[src.temp]</TT><BR><BR><A href='?src=\ref[src];temp=1'>Clear Screen</A>")
		else
			dat += "Current ID: <a href='?src=\ref[src];id=auth'>[src.master.authid ? "[src.master.authid.name]" : "----------"]</a><br>"
			dat += "Auxiliary ID: <a href='?src=\ref[src];id=aux'>[src.master.auxid ? "[src.master.auxid.name]" : "----------"]</a><br><br>"
			if (src.authenticated)
				var/crew = ""
				for(var/datum/data/record/t in data_core.general)
					crew += "[t.fields["name"]] - [t.fields["rank"]]<br>"
				switch(src.screen)
					if(1.0)
						dat += {"
<tt><b>Crew Manifest:</b><br>Please use security record computer to modify entries.<br>[crew]</a><br>
<a href='?src=\ref[src];print=1'>Print</a><br><br>
<a href='?src=\ref[src];screen=2'>Access ID modification console.</a><br></tt>
<BR><A href='?src=\ref[src];logout=1'>{Log Out}</A><BR>
"}
					if(2.0)
						dat = "<tt>[header]<hr><a href='?src=\ref[src];screen=1'>Access Crew Manifest</a><br></tt>"

					if(6.0)

					else
			else
				dat += text("<A href='?src=\ref[];login=1'>{Log In}</A>", src)
				dat += "<br><a href='byond://?src=\ref[src];quit=1'>{Quit}</a>"

		return dat



	Topic(href, href_list)

		if(..())
			return
		if (href_list["id"])
			switch(href_list["id"])
				if("auth")
					if(!isnull(src.master.authid))
						src.master.authid.loc = get_turf(src.master)
						src.master.authid = null
					else
						var/obj/item/I = usr.equipped()
						if (istype(I, /obj/item/weapon/card/id))
							usr.drop_item()
							I.loc = src.master
							src.master.authid = I
				if("aux")
					if(!isnull(src.master.auxid))
						src.master.auxid.loc = get_turf(src.master)
						src.master.auxid = null
					else
						var/obj/item/I = usr.equipped()
						if (istype(I, /obj/item/weapon/card/id))
							usr.drop_item()
							I.loc = src.master
							src.master.auxid = I
		if (!( data_core.general.Find(src.active1) ))
			src.active1 = null
		if (!( data_core.medical.Find(src.active2) ))
			src.active2 = null
		if (href_list["temp"])
			src.temp = null
		else if (href_list["logout"])
			src.authenticated = null
			src.screen = null
			src.active1 = null
			src.active2 = null
		else if (href_list["login"])
			if (istype(src.master, /mob/living/silicon))
				src.active1 = null
				src.active2 = null
				src.authenticated = 1
				src.rank = "AI"
				src.screen = 1
			else if (istype(src.master.authid, /obj/item/weapon/card/id))
				src.active1 = null
				src.active2 = null
				if (src.check_access(src.master.authid))
					src.authenticated = src.master.authid.registered
					src.rank = src.master.authid.assignment
					src.screen = 1
		if (src.authenticated)
			if(href_list["screen"])
				src.screen = text2num(href_list["screen"])
				if(src.screen < 1)
					src.screen = 1

				src.active1 = null
				src.active2 = null


			if (href_list["print_p"])
				var/info = "<CENTER><B>Medical Record</B></CENTER><BR>"
				if ((istype(src.active1, /datum/data/record) && data_core.general.Find(src.active1)))
					info += text("Name: [] ID: []<BR>\nSex: []<BR>\nAge: []<BR>\nFingerprint: []<BR>\nPhysical Status: []<BR>\nMental Status: []<BR>", src.active1.fields["name"], src.active1.fields["id"], src.active1.fields["sex"], src.active1.fields["age"], src.active1.fields["fingerprint"], src.active1.fields["p_stat"], src.active1.fields["m_stat"])
				else
					info += "<B>General Record Lost!</B><BR>"
				if ((istype(src.active2, /datum/data/record) && data_core.medical.Find(src.active2)))
					info += text("<BR>\n<CENTER><B>Medical Data</B></CENTER><BR>\nBlood Type: []<BR>\n<BR>\nMinor Disabilities: []<BR>\nDetails: []<BR>\n<BR>\nMajor Disabilities: []<BR>\nDetails: []<BR>\n<BR>\nAllergies: []<BR>\nDetails: []<BR>\n<BR>\nCurrent Diseases: [] (per disease info placed in log/comment section)<BR>\nDetails: []<BR>\n<BR>\nImportant Notes:<BR>\n\t[]<BR>\n<BR>\n<CENTER><B>Comments/Log</B></CENTER><BR>", src.active2.fields["b_type"], src.active2.fields["mi_dis"], src.active2.fields["mi_dis_d"], src.active2.fields["ma_dis"], src.active2.fields["ma_dis_d"], src.active2.fields["alg"], src.active2.fields["alg_d"], src.active2.fields["cdi"], src.active2.fields["cdi_d"], src.active2.fields["notes"])
					var/counter = 1
					while(src.active2.fields[text("com_[]", counter)])
						info += text("[]<BR>", src.active2.fields[text("com_[]", counter)])
						counter++
				else
					info += "<B>Medical Record Lost!</B><BR>"
				info += "</TT>"

				var/datum/signal/signal = new
				signal.data["data"] = info
				signal.data["title"] = "Medical Record"
				src.peripheral_command("print",signal)

		src.master.add_fingerprint(usr)
		src.master.updateUsrDialog()
		return




/*
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
					if(A in src.modify.access)
						accesses += "<a href='?src=\ref[src];access=[A];allowed=0'><font color=\"red\">[dd_replacetext(get_access_desc(A), " ", "&nbsp")]</font></a> "
					else
						accesses += "<a href='?src=\ref[src];access=[A];allowed=1'>[dd_replacetext(get_access_desc(A), " ", "&nbsp")]</a> "
				accesses += "<br>"
			body = "[carddesc]<br>[jobs]<br><br>[accesses]"
			*/