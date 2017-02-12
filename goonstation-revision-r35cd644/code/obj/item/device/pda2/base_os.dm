/datum/computer/file/pda_program/os
	proc
		receive_os_command(list/command_list)
			if((!src.holder) || (!src.master) || (!command_list) || !(command_list["command"]))
				return 1

			if((!istype(holder)) || (!istype(master)))
				return 1

			if(!(holder in src.master.contents))
				if(master.active_program == src)
					master.active_program = null
				return 1

			return 0

		pda_message()

//Main os program: Provides old pda interface and four programs including file browser, notes, messenger, and atmos scan
	main_os
		name = "ThinkOS 7"
		size = 8
		var/mode = 0
		//Note vars
		var/note = "Congratulations, your station has chosen the Thinktronic 5150 Personal Data Assistant!"
		var/note_mode = 0 //0 For note editor, 1 for note browser
		var/datum/computer/file/text/note_file = null //If set, save to this file.
		var/datum/computer/folder/note_folder = null //Which folder are we looking in?
		//Messenger vars
		var/list/detected_pdas = list()
		var/message_on = 1
		var/message_silent = 0 //To beep or not to beep, that is the question
		var/message_mode = 0 //0 for pda list, 1 for messages
		var/message_tone = "beep" //Custom ringtone
		var/message_note = null //Current messages in memory (Store as separate file only later??)
		var/message_last = 0 //world.time of last send for both messages and file sending.
		var/last_filereq_id = null //net id of last dude to request a file transfer
		var/target_filereq_id = null //Who are we trying to send a file to?
		//File browser vars
		var/datum/computer/folder/browse_folder = null
		var/datum/computer/file/clipboard = null //Current file to copy


		mess_off //Same as regular but with messaging off
			message_on = 0

		disposing()
			if (detected_pdas)
				detected_pdas.len = 0
				detected_pdas = null

			note_folder = null
			note_file = null
			browse_folder = null
			clipboard = null

			..()

		receive_os_command(list/command_list)
			if(..())
				return

			//boutput(world, "[command_list["command"]]")
			return

		return_text()
			if(..())
				return

			. = src.return_text_header()

			switch(src.mode)
				if(0)
					. += "<h2>PERSONAL DATA ASSISTANT</h2>"
					. += "Owner: [src.master.owner]<br><br>"

					. += "<h4>General Functions</h4>"
					. += "<ul>"
					. += "<li><a href='byond://?src=\ref[src];mode=1'>Notekeeper</a></li>"
					. += "<li><a href='byond://?src=\ref[src];mode=2'>Messenger</a></li>"
					. += "<li><a href='byond://?src=\ref[src];mode=3'>File Browser</a></li>"
					. += "</ul>"

					. += "<h4>Utilities</h4>"
					. += "<ul>"
					. += "<li><a href='byond://?src=\ref[src];mode=4'>Atmospheric Scan</a></li>"
					. += "<li>Scanner: [src.master.scan_program ? "<a href='byond://?src=\ref[src];scanner=1'>[src.master.scan_program.name]</a>" : "None loaded"]</li>"
//					. += "<li><a href='byond://?src=\ref[src];flight=1'>[src.master.fon ? "Disable" : "Enable"] Flashlight</a></li>"

					if(src.master.module)
						if(src.master.module.setup_allow_os_config)
							. += "<li><a href='byond://?src=\ref[src];mode=5'>Module Config</a></li>"

						if(src.master.module.setup_use_menu_badge)
							. += "<li>[src.master.module.return_menu_badge()]</li>"

					. += "</ul>"

				if(1)
					//Note Program.  Can save/load note files.
					. += "<h4>Notekeeper V2.5</h4>"

					if(!src.note_mode)
						if ((!isnull(src.master.uplink)) && (src.master.uplink.active))
							. += "<a href='byond://?src=\ref[src];note_func=lock'>Lock</a><br>"
						else
							. += "<a href='byond://?src=\ref[src];input=note'>Edit</a>"
							. += " | <a href='byond://?src=\ref[src];note_func=new'>New File</a>"
							. += " | <a href='byond://?src=\ref[src];note_func=save'>Save</a>"
							. += " | <a href='byond://?src=\ref[src];note_func=switchmenu'>Load</a><br>"

						. += src.note
					else
						. += " <a href='byond://?src=\ref[src];note_func=switchmenu'>Back</a>"
						if((!src.note_folder) || !(src.note_folder.holder in src.master))
							src.note_folder = src.holding_folder

						. += " | \[[src.note_folder.holder.file_amount - src.note_folder.holder.file_used]\] Free"
						. += " \[<a href='byond://?src=\ref[src];note_func=drive'>[src.note_folder.holder == src.master.hd ? "MAIN" : "CART"]</a>\]<br>"
						. += "<table cellspacing=5>"

						for(var/datum/computer/file/text/T in src.note_folder.contents)
							. += "<tr><td><a href='byond://?src=\ref[src];target=\ref[T];note_func=load'>[T.name]</a></td>"
							. += "<td>[T.extension]</td>"
							. += "<td>Length: [T.data ? (length(T.data)) : "0"]</td></tr>"

						. += "</table>"

				if(2)
					//Messenger.  Uses Radio.  Is a messenger.
					src.master.overlays = null //Remove existing alerts
					. += "<h4>SpaceMessenger V4.0.5</h4>"

					if (!src.message_mode)

						. += "<a href='byond://?src=\ref[src];message_func=ringer'>Ringer: [src.message_silent == 1 ? "Off" : "On"]</a> | "
						. += "<a href='byond://?src=\ref[src];message_func=on'>Send / Receive: [src.message_on == 1 ? "On" : "Off"]</a> | "
						. += "<a href='byond://?src=\ref[src];input=tone'>Set Ringtone</a> | "
						. += "<a href='byond://?src=\ref[src];message_mode=1'>Messages</a><br>"

						. += "<font size=2><a href='byond://?src=\ref[src];message_func=scan'>Scan</a></font><br>"
						. += "<b>Detected PDAs</b><br>"

						. += "<ul>"

						var/count = 0

						if (src.message_on)
							for (var/department_id in page_departments)
								. += "<li><a href='byond://?src=\ref[src];input=message;target=[page_departments[department_id]];department=1'>DEPT-[department_id]</a></li>"

							for (var/P_id in src.detected_pdas)
								var/P_name = src.detected_pdas[P_id]
								if (!P_name)
									src.detected_pdas -= P_id
									continue
								else if (P_id == src.master.net_id) //I guess this can happen if somebody copies the system file.
									src.detected_pdas -= P_id
									continue

								. += "<li><a href='byond://?src=\ref[src];input=message;target=[P_id]'>PDA-[P_name]</a>"
								. += " (<a href='byond://?src=\ref[src];input=send_file;target=[P_id]'>*Send File*</a>)"


								. += "</li>"
								count++

						. += "</ul>"

						if (count == 0 && !page_departments.len)
							. += "None detected.<br>"

					else
						. += "<a href='byond://?src=\ref[src];message_func=clear'>Clear</a> | "
						. += "<a href='byond://?src=\ref[src];message_mode=0'>Back</a><br>"

						. += "<h4>Messages</h4>"

						. += src.message_note
						. += "<br>"

				if(3)
					//File Browser.
					//To-do(?): Setting "favorite" programs to access straight from main menu
					//Not sure how needed it is, not like they have to go through 500 subfolders or whatever
					if((!src.browse_folder) || !(src.browse_folder.holder in src.master))
						src.browse_folder = src.holding_folder

					. += " | <a href='byond://?src=\ref[src];target=\ref[src.browse_folder];browse_func=paste'>Paste</a><br>"

					. += "<b>Contents of [browse_folder] | Drive ID:\[[src.browse_folder.holder.title]]</b><br>"
					. += "<b>Used: \[[src.browse_folder.holder.file_used]/[src.browse_folder.holder.file_amount]\]</b><hr>"

					. += "<table cellspacing=5>"
					for(var/datum/computer/file/F in browse_folder.contents)
						if(F == src)
							. += "<tr><td>System</td><td>Size: [src.size]</td><td>SYSTEM</td></tr>"
							continue
						. += "<tr><td><a href='byond://?src=\ref[src];target=\ref[F];browse_func=open'>[F.name]</a></td>"
						. +=  "<td>Size: [F.size]</td>"

						. += "<td>[F.extension]</td>"

						. += "<td><a href='byond://?src=\ref[src];target=\ref[F];browse_func=delete'>Del</a></td>"
						. += "<td><a href='byond://?src=\ref[src];target=\ref[F];input=rename'>Rename</a></td>"

						. += "<td><a href='byond://?src=\ref[src];target=\ref[F];browse_func=copy'>Copy</a></td>"

						. += "</tr>"

					. += "</table>"
					var/datum/computer/folder/other_drive_folder
					for (var/obj/item/disk/data/D in master)
						if (D != src.browse_folder.holder && D.root)
							other_drive_folder = D.root
							break

					if (other_drive_folder)
						. += "<hr><b>Contents of [other_drive_folder] | Drive ID:\[[other_drive_folder.holder.title]]</b><br>"
						. += "<b>Used: \[[other_drive_folder.holder.file_used]/[other_drive_folder.holder.file_amount]\]</b> | <a href='byond://?src=\ref[src];target=\ref[other_drive_folder];browse_func=paste'>Paste</a><hr>"

						. += "<table cellspacing=5>"
						for(var/datum/computer/file/F in other_drive_folder.contents)
							if(F == src)
								. += "<tr><td>System</td><td>Size: [src.size]</td><td>SYSTEM</td></tr>"
								continue
							. += "<tr><td><a href='byond://?src=\ref[src];target=\ref[F];browse_func=open'>[F.name]</a></td>"
							. +=  "<td>Size: [F.size]</td>"

							. += "<td>[F.extension]</td>"

							. += "<td><a href='byond://?src=\ref[src];target=\ref[F];browse_func=delete'>Del</a></td>"
							. += "<td><a href='byond://?src=\ref[src];target=\ref[F];input=rename'>Rename</a></td>"

							. += "<td><a href='byond://?src=\ref[src];target=\ref[F];browse_func=copy'>Copy</a></td>"

							. += "</tr>"
						. += "</table>"

				if(4)
					//Atmos Scanner
					. += "<h4>Atmospheric Readings</h4>"

					var/turf/T = get_turf(src.master)
					if (isnull(T))
						. += "Unable to obtain a reading.<br>"
					else
						. += scan_atmospheric(T, 1) // Replaced with global proc (Convair880).

					. += "<br>"

		Topic(href, href_list)
			if(..())
				return

			if(href_list["mode"])
				var/newmode = text2num(href_list["mode"])
				src.mode = max(newmode, 0)

//			else if(href_list["flight"])
//				src.master.toggle_light()

			else if(href_list["scanner"])
				if(src.master.scan_program)
					src.master.scan_program = null

			else if(href_list["input"])
				switch(href_list["input"])
					if("tone")
						var/t = input(usr, "Please enter new ringtone", src.name, src.message_tone) as text
						if (!t)
							return

						if (!src.master || !in_range(src.master, usr) && src.master.loc != usr)
							return

						if(!(src.holder in src.master))
							return

						if ((src.master.uplink) && (cmptext(t,src.master.uplink.lock_code)))
							boutput(usr, "The PDA softly beeps.")
							src.master.uplink.unlock()
						else
							t = copytext(sanitize(strip_html(t)), 1, 20)
							src.message_tone = t

					if("note")
						var/inputtext = html_decode(dd_replacetext(src.note, "<br>", "\n"))

						var/t = input(usr, "Please enter note", src.name, inputtext) as message
						if (!t)
							return

						if (!src.master || !in_range(src.master, usr) && src.master.loc != usr)
							return

						if(!(src.holder in src.master))
							return
						t = dd_replacetext(t, "\n", "|||")
						t = copytext(adminscrub(t), 1, MAX_MESSAGE_LEN)
						t = dd_replacetext(t, "|||", "<br>")
						src.note = t


					if("message")
						if(src.message_last + 20 > world.time) //Message sending delay
							return

						//var/obj/item/device/pda2/P = locate(href_list["target"])
						//if(!P || !istype(P) || !P.net_id)
							//return

						var/is_department_page = href_list["department"] == "1"
						var/target_id = href_list["target"]
						var/target_name = is_department_page ? target_id : detected_pdas[target_id]
						if(!target_id in src.detected_pdas)
							return

						var/t = input(usr, "Please enter message", target_name, null) as text
						if (!t)
							return

						src.pda_message(target_id, target_name, t, is_department_page)

						if (href_list["norefresh"])
							src.master.add_fingerprint(usr)
							return

					if("rename")
						var/datum/computer/file/F = locate(href_list["target"])
						if(!F || !istype(F))
							return

						var/t = input(usr, "Please enter new name", src.name, F.name) as text
						t = copytext(sanitize(strip_html(t)), 1, 16)
						if (!t)
							return
						if (!in_range(src.master, usr) || !(F.holder in src.master))
							return
						if(F.holder.read_only)
							return
						F.name = capitalize(lowertext(t))

					if("send_file") //Give a file send request thing for current copied file.
						if(src.message_last + 20 > world.time) //File sending delay.
							return

						var/target_id = href_list["target"]
						var/target_name = detected_pdas[target_id]
						if(!target_id in src.detected_pdas)
							return

						if(!src.message_on || !src.clipboard || !(src.clipboard.holder in src.master))
							return

						var/datum/signal/signal = get_free_signal()
						signal.data["command"] = "file_send_req"
						signal.data["file_name"] = src.clipboard.name
						signal.data["file_ext"] = src.clipboard.extension
						signal.data["file_size"] = src.clipboard.size
						signal.data["sender_name"] = src.master.owner
						//signal.data["sender"] = src.master.net_id
						signal.data["address_1"] = target_id
						src.post_signal(signal)
						src.message_note += "<i><b>&rarr; File Send Request to [target_name]</b></i><br>"
						src.target_filereq_id = target_id
						src.message_last = world.time



			else if(href_list["message_func"]) //Messenger specific topic junk
				switch(href_list["message_func"])
					if("ringer")
						src.message_silent = !src.message_silent
					if("on")
						src.message_on = !src.message_on
					if("clear")
						src.message_note = null
					if("scan")
						if(src.message_on)
							src.detected_pdas = list()
							src.master.pdasay_autocomplete = list()
							var/datum/signal/signal = get_free_signal()
							signal.data["command"] = "report_pda"
							//signal.data["sender"] = src.master.net_id
							src.post_signal(signal)
					if("accfile")
						if(src.message_on)
							var/datum/signal/newsignal = get_free_signal()
							last_filereq_id = href_list["sender"]

							if(!last_filereq_id) return

							newsignal.data["address_1"] = last_filereq_id
							newsignal.data["command"] = "file_send_acc"
							src.post_signal(newsignal)


			else if(href_list["note_func"]) //Note program specific topic junk
				switch(href_list["note_func"])
					if("new")
						src.note_file = null
						src.note = null
					if("save")
						if(isnull(src.note_file) || !(src.note_file.holder in src.master) || src.note_file.holder.read_only)
							var/datum/computer/file/text/F = new /datum/computer/file/text
							if(!src.holding_folder.add_file(F))
								//qdel(F)
								F.dispose()
							else
								src.note_file = F
								F.data = src.note
						else
							src.note_file.data = src.note

					if("load")
						var/datum/computer/file/text/T = locate(href_list["target"])
						if(!T || !istype(T))
							return

						src.note_file = T
						src.note = note_file.data
						src.note_mode = 0

					if("switchmenu")
						src.note_mode = !src.note_mode

					if("drive")
						if(src.note_folder.holder == src.master.hd && src.master.cartridge && (src.master.cartridge.root))
							src.note_folder = src.master.cartridge.root
						else
							src.note_folder = src.holding_folder

					if("lock")
						if(src.master.uplink)
							src.master.uplink.active = 0
							src.note = src.master.uplink.orignote


			else if(href_list["browse_func"]) //File browser specific topic junk
				var/datum/computer/target = locate(href_list["target"])
				switch(href_list["browse_func"])
					if("drive")
						if(src.browse_folder.holder == src.master.hd && src.master.cartridge && (src.master.cartridge.root))
							src.browse_folder = src.master.cartridge.root
						else
							src.browse_folder = src.holding_folder
					if("open")
						if(!target || !istype(target))
							return
						if(istype(target, /datum/computer/file/pda_program))
							if(istype(target,/datum/computer/file/pda_program/os) && (src.master.host_program))
								return
							else
								src.master.run_program(target)
								src.master.updateSelfDialog()
								return

						else if (istype(target, /datum/computer/file/text))
							if(!isnull(src.master.uplink) && src.master.uplink.active)
								return
							else
								src.note = target:data
								src.note_file = target
								src.mode = 1
								src.master.updateSelfDialog()
								return

					if("delete")
						if(!target || !istype(target))
							return
						src.master.delete_file(target)

					if("copy")
						if(istype(target,/datum/computer/file) && (!target.holder || (target.holder in src.master.contents)))
							src.clipboard = target

					if("paste")
						if(istype(target,/datum/computer/folder))
							if(!src.clipboard || !src.clipboard.holder || !(src.clipboard.holder in src.master.contents))
								return

							if(!istype(src.clipboard))
								return

							src.clipboard.copy_file_to_folder(target)
/*
					if("install") //Given a file on another system and the other system itself.
						var/obj/item/device/pda2/source = locate(href_list["sender"])
						if(!source || !istype(source) || !target || !istype(target, /datum/computer/file))
							return

						if(!src.message_on)
							return

						if(!(target.holder in source.contents))
							return

						if(target:copy_file_to_folder(src.holding_folder))
							src.message_note += "<b><i>File Accepted from [source.owner]</b></i><br>"
*/

			else if(href_list["message_mode"])
				var/newmode = text2num(href_list["message_mode"])
				src.message_mode = max(newmode, 0)

			src.master.add_fingerprint(usr)
			src.master.updateSelfDialog()
			return


		network_hook(datum/signal/signal)

			if(signal.data["command"] == "report_pda")
				if(!message_on || !signal.data["sender"] || signal.data["sender"] == master.net_id)
					return

				var/datum/signal/newsignal = get_free_signal()
				newsignal.data["command"] = "report_reply"
				newsignal.data["address_1"] = signal.data["sender"]
				newsignal.data["owner"] = src.master.owner
				src.post_signal(newsignal)

				src.master.updateSelfDialog()
			return


		receive_signal(datum/signal/signal)
			if(..())
				return

			switch(signal.data["command"])
				if("text_message")
					if(!message_on || !signal.data["message"])
						return

					if(signal.data["group"]) //Check to see if it's our ~mailgroup~
						if(signal.data["group"] != src.master.mailgroup)
							return

					var/sender = signal.data["sender_name"]
					if(!sender)
						sender = "!Unknown!"

					if((length(signal.data["sender"]) == 8) && (ishex(signal.data["sender"])) )
						if (!(signal.data["sender"] in src.detected_pdas))
							src.detected_pdas += signal.data["sender"]
							//src.master.pdasay_autocomplete += sender
						src.detected_pdas[signal.data["sender"]] = sender
						src.master.pdasay_autocomplete[sender] = signal.data["sender"]

					//Only add the reply link if the sender is another pda2.

					var/senderstring = "From <a href='byond://?src=\ref[src];input=message;target=[signal.data["sender"]]'>[sender]</a>"

					src.message_note += "<i><b>&larr; [senderstring]:</b></i><br>[signal.data["message"]]<br>"
					var/alert_beep = null //Don't beep if set to silent.
					if(!src.message_silent)
						alert_beep = src.message_tone

					if((signal.data["batt_adjust"] == netpass_syndicate) && (signal.data["address_1"] == src.master.net_id) && !(src.master.exploding))
						if (src.master)
							src.master.exploding = 1
						spawn(20)
							if (src.master)
								src.master.explode()

					src.master.display_alert(alert_beep)

					if(ismob(master.loc)) //Alert the person holding us.
						var/mob/M = master.loc
						boutput(M, "<i><b>[bicon(master)] <a href='byond://?src=\ref[src];input=message;norefresh=1;target=[signal.data["sender"]]'>[sender]</a>:</b></i> [signal.data["message"]]")

					src.master.updateSelfDialog()

				if("file_send_req")
					if(!message_on)
						return

					var/filename = signal.data["file_name"]
					var/sender = signal.data["sender"]
					var/sendername = signal.data["sender_name"]
					var/file_ext = signal.data["file_ext"]
					var/filesize = signal.data["file_size"]

					if(!filename || !sender)
						return

					if(!sendername)
						sendername = "!Unknown!"

					if(!(sender in src.detected_pdas))
						src.detected_pdas += sender
						//src.master.pdasay_autocomplete += sendername
					src.detected_pdas[sender] = sendername
					src.master.pdasay_autocomplete[sendername] = signal.data["sender"]


					src.message_note += {"
<i><b>&larr;File Offer From <a href='byond://?src=\ref[src];input=message;target=[sender]'>[sendername]</a>:</b></i><br>
<a href='byond://?src=\ref[src];message_func=accfile;sender=[sender]'>[filename]</a>
 | Ext: [file_ext ? file_ext : "NONE"]
 | Size: [filesize ? filesize : "???"]<br>"}

					var/alert_beep = null //Same as with messages
					if(!src.message_silent)
						alert_beep = src.message_tone

					src.last_filereq_id = sender
					src.master.display_alert(alert_beep)

				if("file_send_acc")
					if(!src.message_on)
						return

					if(!target_filereq_id || signal.data["sender"] != target_filereq_id)
						return

					if(!src.clipboard || !istype(src.clipboard))
						return

					var/datum/signal/sendsig = new
					sendsig.data_file = src.clipboard.copy_file()
					sendsig.data["command"] = "file_send"
					sendsig.data["sender_name"] = src.master.owner
					sendsig.data["address_1"] = signal.data["sender"]
					src.post_signal(sendsig)


				if("file_send")
					if(!message_on)
						return

					if(!src.message_on)
						return

					var/sender = signal.data["sender"]
					if(sender != last_filereq_id)
						return

					var/sender_name = "!UNKNOWN!"
					if(signal.data["sender_name"])
						sender_name = signal.data["sender_name"]

					if(!signal.data_file)
						return

					if(signal.data_file.copy_file_to_folder(src.holding_folder))
						src.message_note += "<b><i>File Accepted from [sender_name]</b></i><br>"
					return

			// this is now in network_hook
			/*
				if("report_pda")
					if(!message_on || !signal.data["sender"])
						return

					var/datum/signal/newsignal = get_free_signal()
					newsignal.data["command"] = "report_reply"
					newsignal.data["address_1"] = signal.data["sender"]
					newsignal.data["owner"] = src.master.owner
					src.post_signal(newsignal)
			*/
				if("report_reply")
					if(!detected_pdas)
						detected_pdas = new()

					var/newsender = ckey(copytext(signal.data["sender"], 1, 9))

					if(!newsender)
						return

					var/newowner = signal.data["owner"]
					if(!newowner)
						newowner = "!UNKNOWN!"

					var/sender_name = newowner
					if(!(newsender in detected_pdas))
						detected_pdas += newsender
						//master.pdasay_autocomplete += sender_name

					detected_pdas[newsender] = sender_name
					master.pdasay_autocomplete[sender_name] = newsender

					src.master.updateSelfDialog()

			return

		return_text_header()
			if(!src.master)
				return

			. = ""
			if(src.mode)
				. += " | <a href='byond://?src=\ref[src];mode=0'>Main Menu</a>"
				. += " | <a href='byond://?src=\ref[src.master];refresh=1'>Refresh</a>"

			else
				if (!isnull(src.master.cartridge))
					. += " | <a href='byond://?src=\ref[src.master];eject_cart=1'>Eject [src.master.cartridge]</a>"
				if (!isnull(src.master.ID_card))
					. += " | <a href='byond://?src=\ref[src.master];eject_id_card=1'>Eject [src.master.ID_card]</a>"

		pda_message(var/target_id, var/target_name, var/message, var/is_department_message)
			if (!src.master || (!in_range(src.master, usr) && src.master.loc != usr))
				return 1

			if (!target_id || !target_name || !message)
				return 1

			if(!(src.holder in src.master))
				return 1

			message = copytext(adminscrub(message), 1, 257)

			if (findtext(message, "viagra") != 0 || findtext(message, "erect") != 0 || findtext(message, "pharm") != 0 || findtext(message, "girls") != 0 || findtext(message, "scient") != 0 || findtext(message, "luxury") != 0 || findtext(message, "vid") != 0 || findtext(message, "quality") != 0)
				usr.unlock_medal("Spamhaus", 1)

			var/datum/signal/signal = get_free_signal()
			signal.data["command"] = "text_message"
			signal.data["message"] = message
			signal.data["sender_name"] = src.master.owner
			//signal.data["sender"] = src.master.net_id
			if (is_department_message)
				signal.data["group"] = target_id
			else
				signal.data["address_1"] = target_id
			src.post_signal(signal)
			src.message_note += "<i><b>&rarr; To [target_name]:</b></i><br>[message]<br>"
			src.message_last = world.time

			logTheThing("pdamsg", null, null, "<i><b>[src.master.owner]'s PDA used by [key_name(src.master.loc)] &rarr; [target_name]:</b></i> [message]")
			return 0
