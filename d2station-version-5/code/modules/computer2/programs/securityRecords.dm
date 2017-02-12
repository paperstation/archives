/datum/computer/file/computer_program/sec_data
	name = "Security Records"
	size = 32.0
	program_screen_icon = "security"
	req_access = list(access_security)
	var/obj/item/weapon/card/id/scan = null
	var/authenticated = null
	var/rank = null
	var/screen = null
	var/datum/data/record/active1 = null
	var/datum/data/record/active2 = null
	var/a_id = null
	var/temp = null
	var/printing = null
	var/can_change_id = 0

/datum/computer/file/computer_program/sec_data/return_text()
	if(..())
		return
	//src.master.icon_state = "security"
	var/dat
	if (src.temp)
		dat = text("<TT>[src.temp]</TT><BR><BR><A href='?src=\ref[src];temp=1'>Clear Screen</A>")
	else
		dat = text("Confirm Identity: <A href='?src=\ref[];id=auth'>[]</A><HR>", master, (src.master.authid ? text("[]", src.master.authid.name) : "----------"))
		if (src.authenticated)
			switch(src.screen)
				if(1.0)
					dat += {"
<A href='?src=\ref[src];search=1'>Search Records</A>
<BR><A href='?src=\ref[src];screen=2'>List Records</A>
<BR>
<BR><A href='?src=\ref[src];screen=6'>SecBot Tracking</A>
<BR>
<BR><A href='?src=\ref[src];screen=3'>Record Maintenance</A>
<BR><A href='?src=\ref[src];logout=1'>{Log Out}</A><BR>
"}
				if(2.0)
					dat += "<B>Record List</B>:<HR>"
					for(var/datum/data/record/R in data_core.general)
						dat += text("<A href='?src=\ref[];d_rec=\ref[]'>[]: []<BR>", src, R, R.fields["id"], R.fields["name"])
						//Foreach goto(132)
					dat += text("<HR><A href='?src=\ref[];screen=1'>Back</A>", src)
				if(3.0)
					dat += text("<B>Records Maintenance</B><HR>\n<A href='?src=\ref[];back=1'>Backup To Disk</A><BR>\n<A href='?src=\ref[];u_load=1'>Upload From disk</A><BR>\n<A href='?src=\ref[];del_all=1'>Delete All Records</A><BR>\n<BR>\n<A href='?src=\ref[];screen=1'>Back</A>", src, src, src, src)
				if(4.0)
					dat += "<CENTER><B>Security Record</B></CENTER><BR>"
					if ((istype(src.active1, /datum/data/record) && data_core.general.Find(src.active1)))
						dat += text("Name: <A href='?src=\ref[];field=name'>[]</A> ID: <A href='?src=\ref[];field=id'>[]</A><BR>\nSex: <A href='?src=\ref[];field=sex'>[]</A><BR>\nAge: <A href='?src=\ref[];field=age'>[]</A><BR>\nRank: <A href='?src=\ref[];field=rank'>[]</A><BR>\nFingerprint: <A href='?src=\ref[];field=fingerprint'>[]</A><BR>\nPhysical Status: []<BR>\nMental Status: []<BR>", src, src.active1.fields["name"], src, src.active1.fields["id"], src, src.active1.fields["sex"], src, src.active1.fields["age"], src, src.active1.fields["rank"], src, src.active1.fields["fingerprint"], src.active1.fields["p_stat"], src.active1.fields["m_stat"])
					else
						dat += "<B>General Record Lost!</B><BR>"
					if ((istype(src.active2, /datum/data/record) && data_core.security.Find(src.active2)))
						dat += text("<BR>\n<CENTER><B>Security Data</B></CENTER><BR>\nCriminal Status: <A href='?src=\ref[];field=criminal'>[]</A><BR>\n<BR>\nMinor Crimes: <A href='?src=\ref[];field=mi_crim'>[]</A><BR>\nDetails: <A href='?src=\ref[];field=mi_crim_d'>[]</A><BR>\n<BR>\nMajor Crimes: <A href='?src=\ref[];field=ma_crim'>[]</A><BR>\nDetails: <A href='?src=\ref[];field=ma_crim_d'>[]</A><BR>\n<BR>\nImportant Notes:<BR>\n\t<A href='?src=\ref[];field=notes'>[]</A><BR>\n<BR>\n<CENTER><B>Comments/Log</B></CENTER><BR>", src, src.active2.fields["criminal"], src, src.active2.fields["mi_crim"], src, src.active2.fields["mi_crim_d"], src, src.active2.fields["ma_crim"], src, src.active2.fields["ma_crim_d"], src, src.active2.fields["notes"])
						var/counter = 1
						while(src.active2.fields[text("com_[]", counter)])
							dat += text("[]<BR><A href='?src=\ref[];del_c=[]'>Delete Entry</A><BR><BR>", src.active2.fields[text("com_[]", counter)], src, counter)
							counter++
						dat += text("<A href='?src=\ref[];add_c=1'>Add Entry</A><BR><BR>", src)
						dat += text("<A href='?src=\ref[];del_r=1'>Delete Record (Medical Only)</A><BR><BR>", src)
					else
						dat += "<B>Security Record Lost!</B><BR>"
						dat += text("<A href='?src=\ref[src];new=1'>New Record</A><BR><BR>")
					dat += text("\n<A href='?src=\ref[];print_p=1'>Print Record</A><BR>\n<A href='?src=\ref[];screen=2'>Back</A><BR>", src, src)
				if(6.0)
					dat += "<center><b>Security Robot Monitor</b></center>"
					dat += "<a href='?src=\ref[src];screen=1'>Back</a>"
					dat += "<br><b>Secbots:</b><BR>"
					var/bdat = null
					for(var/obj/machinery/bot/secbot/M in world)
						var/turf/bl = get_turf(M)
						bdat += "<font color='blue'> <B>[M.name]</B></font><BR> - <b>\[[bl.x],[bl.y]\]</b> <BR>- [M.on ? "<font color='darkgreen'>Online</font>" : "<font color='darkred'>Offline</font>"]<BR>"
						if(M.arrest_type >= 1)
							bdat += "Set to Detain.<BR><BR>"
						else
							bdat += "Set to Arrest.<BR><BR>"

					if(!bdat)
						dat += "<br><center>None detected</center>"
					else
						dat += "[bdat]"

				else

		else
			dat += text("<A href='?src=\ref[];login=1'>{Log In}</A>", src)
			dat += "<br><a href='byond://?src=\ref[src];quit=1'>{Quit}</a>"

	return dat

/datum/computer/file/computer_program/sec_data/Topic(href, href_list)
	if(..())
		return
	if (!( data_core.general.Find(src.active1) ))
		src.active1 = null
	if (!( data_core.security.Find(src.active2) ))
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


		if (href_list["del_all"])
			src.temp = text("Are you sure you wish to delete all records?<br>\n\t<A href='?src=\ref[];temp=1;del_all2=1'>Yes</A><br>\n\t<A href='?src=\ref[];temp=1'>No</A><br>", src, src)

		if (href_list["del_all2"])
			for(var/datum/data/record/R in data_core.security)
				del(R)
			src.temp = "All records deleted."

		if (href_list["field"])
			var/a1 = src.active1
			var/a2 = src.active2
			switch(href_list["field"])
				if("fingerprint")
					if (istype(src.active1, /datum/data/record))
						var/t1 = input("Please input fingerprint hash:", "Secure. records", src.active1.fields["id"], null)  as text
						if ((!( t1 ) || !( src.authenticated ) || (!src.master) || usr.stat || usr.restrained() || src.active1 != a1))
							return
						src.active1.fields["fingerprint"] = t1
				if("sex")
					if (istype(src.active1, /datum/data/record))
						if (src.active1.fields["sex"] == "Male")
							src.active1.fields["sex"] = "Female"
						else
							src.active1.fields["sex"] = "Male"
				if("age")
					if (istype(src.active1, /datum/data/record))
						var/t1 = input("Please input age:", "Secure. records", src.active1.fields["age"], null)  as text
						if ((!( t1 ) || !( src.authenticated ) || (!src.master) || usr.stat || usr.restrained() || src.active1 != a1))
							return
						src.active1.fields["age"] = t1
				if("mi_crim")
					if (istype(src.active2, /datum/data/record))
						var/t1 = input("Please input minor disabilities list:", "Secure. records", src.active2.fields["mi_crim"], null)  as text
						if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() ||  src.active2 != a2))
							return
						src.active2.fields["mi_crim"] = t1
				if("mi_crim_d")
					if (istype(src.active2, /datum/data/record))
						var/t1 = input("Please summarize minor dis.:", "Secure. records", src.active2.fields["mi_crim_d"], null)  as message
						if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || src.active2 != a2))
							return
						src.active2.fields["mi_crim_d"] = t1
				if("ma_crim")
					if (istype(src.active2, /datum/data/record))
						var/t1 = input("Please input major diabilities list:", "Secure. records", src.active2.fields["ma_crim"], null)  as text
						if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || src.active2 != a2))
							return
						src.active2.fields["ma_crim"] = t1
				if("ma_crim_d")
					if (istype(src.active2, /datum/data/record))
						var/t1 = input("Please summarize major dis.:", "Secure. records", src.active2.fields["ma_crim_d"], null)  as message
						if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || src.active2 != a2))
							return
						src.active2.fields["ma_crim_d"] = t1
				if("notes")
					if (istype(src.active2, /datum/data/record))
						var/t1 = input("Please summarize notes:", "Secure. records", src.active2.fields["notes"], null)  as message
						if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || src.active2 != a2))
							return
						src.active2.fields["notes"] = t1
				if("criminal")
					if (istype(src.active2, /datum/data/record))
						src.temp = text("<B>Criminal Status:</B><BR>\n\t<A href='?src=\ref[];temp=1;criminal2=none'>None</A><BR>\n\t<A href='?src=\ref[];temp=1;criminal2=arrest'>*Arrest*</A><BR>\n\t<A href='?src=\ref[];temp=1;criminal2=incarcerated'>Incarcerated</A><BR>\n\t<A href='?src=\ref[];temp=1;criminal2=parolled'>Parolled</A><BR>\n\t<A href='?src=\ref[];temp=1;criminal2=released'>Released</A><BR>", src, src, src, src, src)
				if("rank")
					var/list/L = list( "Head of Personnel", "Captain", "AI" )
					if ((istype(src.active1, /datum/data/record) && L.Find(src.rank)))
						src.temp = text("<B>Rank:</B><BR>\n<B>Assistants:</B><BR>\n<A href='?src=\ref[];temp=1;rank=res_assist'>Assistant</A><BR>\n<B>Technicians:</B><BR>\n<A href='?src=\ref[];temp=1;rank=foren_tech'>Detective</A><BR>\n<A href='?src=\ref[];temp=1;rank=atmo_tech'>Atmospheric Technician</A><BR>\n<A href='?src=\ref[];temp=1;rank=engineer'>Station Engineer</A><BR>\n<B>Researchers:</B><BR>\n<A href='?src=\ref[];temp=1;rank=med_res'>Geneticist</A><BR>\n<A href='?src=\ref[];temp=1;rank=tox_res'>Scientist</A><BR>\n<B>Officers:</B><BR>\n<A href='?src=\ref[];temp=1;rank=med_doc'>Medical Doctor</A><BR>\n<A href='?src=\ref[];temp=1;rank=secure_off'>Security Officer</A><BR>\n<B>Higher Officers:</B><BR>\n<A href='?src=\ref[];temp=1;rank=hoperson'>Head of Security</A><BR>\n<A href='?src=\ref[];temp=1;rank=hosecurity'>Head of Personnel</A><BR>\n<A href='?src=\ref[];temp=1;rank=captain'>Captain</A><BR>", src, src, src, src, src, src, src, src, src, src, src)

				else

		if (href_list["p_stat"])
			if (src.active1)
				switch(href_list["p_stat"])
					if("deceased")
						src.active1.fields["p_stat"] = "*Deceased*"
					if("unconscious")
						src.active1.fields["p_stat"] = "*Unconscious*"
					if("active")
						src.active1.fields["p_stat"] = "Active"
					if("unfit")
						src.active1.fields["p_stat"] = "Physically Unfit"

		if (href_list["m_stat"])
			if (src.active1)
				switch(href_list["m_stat"])
					if("insane")
						src.active1.fields["m_stat"] = "*Insane*"
					if("unstable")
						src.active1.fields["m_stat"] = "*Unstable*"
					if("watch")
						src.active1.fields["m_stat"] = "*Watch*"
					if("stable")
						src.active2.fields["m_stat"] = "Stable"
		if (href_list["rank"])
			if (src.active1)
				switch(href_list["rank"])
					if("res_assist")
						src.active1.fields["rank"] = "Assistant"
					if("foren_tech")
						src.active1.fields["rank"] = "Detective"
					if("atmo_tech")
						src.active1.fields["rank"] = "Atmospheric Technician"
					if("engineer")
						src.active1.fields["rank"] = "Station Engineer"
					if("med_res")
						src.active1.fields["rank"] = "Geneticist"
					if("tox_res")
						src.active1.fields["rank"] = "Scientist"
					if("med_doc")
						src.active1.fields["rank"] = "Medical Doctor"
					if("secure_off")
						src.active1.fields["rank"] = "Security Officer"
					if("hoperson")
						src.active1.fields["rank"] = "Head of Security"
					if("hosecurity")
						src.active1.fields["rank"] = "Head of Personnel"
					if("captain")
						src.active1.fields["rank"] = "Captain"
					if("barman")
						src.active1.fields["rank"] = "Barman"
					if("chemist")
						src.active1.fields["rank"] = "Chemist"
					if("janitor")
						src.active1.fields["rank"] = "Janitor"
					if("clown")
						src.active1.fields["rank"] = "Clown"


		if (href_list["criminal2"])
			if (src.active2)
				switch(href_list["criminal2"])
					if("none")
						src.active2.fields["criminal"] = "None"
					if("arrest")
						src.active2.fields["criminal"] = "*Arrest*"
					if("incarcerated")
						src.active2.fields["criminal"] = "Incarcerated"
					if("parolled")
						src.active2.fields["criminal"] = "Parolled"
					if("released")
						src.active2.fields["criminal"] = "Released"


		if (href_list["del_r"])
			if (src.active2)
				src.temp = "Are you sure you wish to delete the record (Security Portion Only)?<br>\n\t<A href='?src=\ref[src];temp=1;del_r2=1'>Yes</A><br>\n\t<A href='?src=\ref[src];temp=1'>No</A><br>"

		if (href_list["del_r2"])
			if (src.active2)
				del(src.active2)


		if (href_list["d_rec"])
			var/datum/data/record/R = locate(href_list["d_rec"])
			var/S = locate(href_list["d_rec"])
			if (!( data_core.general.Find(R) ))
				src.temp = "Record Not Found!"
				return
			for(var/datum/data/record/E in data_core.security)
				if ((E.fields["name"] == R.fields["name"] || E.fields["id"] == R.fields["id"]))
					S = E
				else
				//Foreach continue //goto(2614)
			src.active1 = R
			src.active2 = S
			src.screen = 4

		if (href_list["new"])
			if ((istype(src.active1, /datum/data/record) && !( istype(src.active2, /datum/data/record) )))
				var/datum/data/record/R = new /datum/data/record(  )
				R.fields["name"] = src.active1.fields["name"]
				R.fields["id"] = src.active1.fields["id"]
				R.name = text("Security Record #[]", R.fields["id"])
				R.fields["criminal"] = "None"
				R.fields["mi_crim"] = "None"
				R.fields["mi_crim_d"] = "No minor crime convictions."
				R.fields["ma_crim"] = "None"
				R.fields["ma_crim_d"] = "No major crime convictions."
				R.fields["notes"] = "No notes."
				data_core.security += R
				src.active2 = R
				src.screen = 4
		if (href_list["add_c"])
			if (!( istype(src.active2, /datum/data/record) ))
				return
			var/a2 = src.active2
			var/t1 = input("Add Comment:", "Secure. records", null, null)  as message
			if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || (!in_range(src.master, usr) && (!istype(usr, /mob/living/silicon))) || src.active2 != a2))
				return
			var/counter = 1
			while(src.active2.fields[text("com_[]", counter)])
				counter++
			src.active2.fields[text("com_[]", counter)] = text("Made by [] ([]) on [], 2053<BR>[]", src.authenticated, src.rank, time2text(world.realtime, "DDD MMM DD hh:mm:ss"), t1)

		if (href_list["del_c"])
			if ((istype(src.active2, /datum/data/record) && src.active2.fields[text("com_[]", href_list["del_c"])]))
				src.active2.fields[text("com_[]", href_list["del_c"])] = "<B>Deleted</B>"

		if (href_list["search"])
			var/t1 = input("Search String: (Name or ID)", "Secure. records", null, null)  as text
			if ((!( t1 ) || usr.stat || (!src.master) || !( src.authenticated ) || usr.restrained() || ((!in_range(src.master, usr)) && (!istype(usr, /mob/living/silicon)))))
				return
			src.active1 = null
			src.active2 = null
			t1 = lowertext(t1)
			for(var/datum/data/record/R in data_core.general)
				if ((lowertext(R.fields["name"]) == t1 || t1 == lowertext(R.fields["id"])))
					src.active1 = R
				else

			if (!( src.active1 ))
				src.temp = text("Could not locate record [].", t1)
			else
				for(var/datum/data/record/E in data_core.security)
					if ((E.fields["name"] == src.active1.fields["name"] || E.fields["id"] == src.active1.fields["id"]))
						src.active2 = E
					else

				src.screen = 4

		if (href_list["search"])
			var/t1 = input("Search String: (Name or ID)", "Secure. records", null, null)  as text
			if ((!( t1 ) || usr.stat || !( src.authenticated ) || usr.restrained() || !in_range(src, usr)))
				return
			src.active1 = null
			src.active2 = null
			t1 = lowertext(t1)
			for(var/datum/data/record/R in data_core.general)
				if ((lowertext(R.fields["name"]) == t1 || t1 == lowertext(R.fields["id"])))
					src.active1 = R
				else
				//Foreach continue //goto(3708)
			if (!( src.active1 ))
				src.temp = text("Could not locate record [].", t1)
			else
				for(var/datum/data/record/E in data_core.security)
					if ((E.fields["name"] == src.active1.fields["name"] || E.fields["id"] == src.active1.fields["id"]))
						src.active2 = E
					else
					//Foreach continue //goto(3813)
			src.screen = 4

		if (href_list["print_p"])
			var/info = "<CENTER><B>Security Record</B></CENTER><BR>"
			if ((istype(src.active1, /datum/data/record) && data_core.general.Find(src.active1)))
				info += text("Name: [] ID: []<BR>\nSex: []<BR>\nAge: []<BR>\nFingerprint: []<BR>\nPhysical Status: []<BR>\nMental Status: []<BR>", src.active1.fields["name"], src.active1.fields["id"], src.active1.fields["sex"], src.active1.fields["age"], src.active1.fields["fingerprint"], src.active1.fields["p_stat"], src.active1.fields["m_stat"])
			else
				info += "<B>General Record Lost!</B><BR>"
			if ((istype(src.active2, /datum/data/record) && data_core.security.Find(src.active2)))
				info += text("<BR>\n<CENTER><B>Security Data</B></CENTER><BR>\nCriminal Status: []<BR>\n<BR>\nMinor Crimes: []<BR>\nDetails: []<BR>\n<BR>\nMajor Crimes: []<BR>\nDetails: []<BR>\n<BR>\nImportant Notes:<BR>\n\t[]<BR>\n<BR>\n<CENTER><B>Comments/Log</B></CENTER><BR>", src.active2.fields["criminal"], src.active2.fields["mi_crim"], src.active2.fields["mi_crim_d"], src.active2.fields["ma_crim"], src.active2.fields["ma_crim_d"], src.active2.fields["notes"])
				var/counter = 1
				while(src.active2.fields[text("com_[]", counter)])
					info += text("[]<BR>", src.active2.fields[text("com_[]", counter)])
					counter++
			else
				info += "<B>Security Record Lost!</B><BR>"
			var/datum/signal/signal = new
			signal.data["data"] = info
			signal.data["title"] = "Security Record"
			src.peripheral_command("print",signal)

		if (href_list["back"])
			src.temp = "Now backing up files."
			sleep(5)
			if(src.master.diskette.root == data_core.security)
				return
			else
				src.master.diskette.root = data_core.security
				src.master.diskette.root.name = "Security Records Backup"
			return

		if (href_list["u_load"])
			src.temp = "Now restoring files."
			sleep(5)
			if(!(src.master.diskette.root == data_core.security))
				return
			else
				data_core.security += src.master.diskette.root
				src.temp = "Restore complete."
				sleep(5)
			return

	src.master.add_fingerprint(usr)
	src.master.updateUsrDialog()
	return

/*		if (href_list["load_disk"])
			var/buffernum = text2num(href_list["load_disk"])
			if ((buffernum > 3) || (buffernum < 1))
				return
			if ((isnull(src.diskette)) || (!src.diskette.data) || (src.diskette.data == ""))
				return
			switch(buffernum)
				if(1)
					src.buffer1 = src.diskette.data
					src.buffer1type = src.diskette.data_type
					src.buffer1iue = src.diskette.ue
					src.buffer1owner = src.diskette.owner
				if(2)
					src.buffer2 = src.diskette.data
					src.buffer2type = src.diskette.data_type
					src.buffer2iue = src.diskette.ue
					src.buffer2owner = src.diskette.owner
				if(3)
					src.buffer3 = src.diskette.data
					src.buffer3type = src.diskette.data_type
					src.buffer3iue = src.diskette.ue
					src.buffer3owner = src.diskette.owner
			src.temphtml = "Data loaded."

		if (href_list["save_disk"])
			var/buffernum = text2num(href_list["save_disk"])
			if ((buffernum > 3) || (buffernum < 1))
				return
			if ((isnull(src.diskette)) || (src.diskette.read_only))
				return
			switch(buffernum)
				if(1)
					src.diskette.data = buffer1
					src.diskette.data_type = src.buffer1type
					src.diskette.ue = src.buffer1iue
					src.diskette.owner = src.buffer1owner
					src.diskette.name = "data disk - '[src.buffer1owner]'"
				if(2)
					src.diskette.data = buffer2
					src.diskette.data_type = src.buffer2type
					src.diskette.ue = src.buffer2iue
					src.diskette.owner = src.buffer2owner
					src.diskette.name = "data disk - '[src.buffer2owner]'"
				if(3)
					src.diskette.data = buffer3
					src.diskette.data_type = src.buffer3type
					src.diskette.ue = src.buffer3iue
					src.diskette.owner = src.buffer3owner
					src.diskette.name = "data disk - '[src.buffer3owner]'"
			src.temphtml = "Data saved."
		if (href_list["eject_disk"])
			if (!src.diskette)
				return
			src.diskette.loc = get_turf(src)
			src.diskette = null
*/
