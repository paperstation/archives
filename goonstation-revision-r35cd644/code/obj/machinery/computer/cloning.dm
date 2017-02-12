//Cloning revival method.
//The pod handles the actual cloning while the computer manages the clone profiles

/obj/machinery/computer/cloning
	name = "Cloning console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "dna"
	req_access = list(access_heads) //Only used for record deletion right now.
	var/obj/machinery/clone_scanner/scanner = null //Linked scanner. For scanning.
	var/obj/machinery/clonepod/pod1 = null //Linked cloning pod.
	var/temp = "Initializing System..."
	var/menu = 1 //Which menu screen to display
	var/list/records = list()
	var/datum/data/record/active_record = null
	var/obj/item/disk/data/floppy/diskette = null //Mostly so the geneticist can steal somebody's identity while pretending to give them a handy backup profile.
	var/held_credit = 5000 // one free clone

	var/allow_dead_scanning = 0 //Can the dead be scanned in the cloner?
	var/portable = 0 //override new() proc and proximity check, for port-a-clones

	old
		icon_state = "old2"
		desc = "With the price of cloning pods nowadays it's not unexpected to skimp on the controller."

		power_change()

			if(stat & BROKEN)
				icon_state = "old2b"
			else
				if( powered() )
					icon_state = initial(icon_state)
					stat &= ~NOPOWER
				else
					spawn(rand(0, 15))
						src.icon_state = "old20"
						stat |= NOPOWER

/obj/item/cloner_upgrade
	name = "NecroScan II cloner upgrade module"
	desc = "A circuit module designed to improve cloning machine scanning capabilities to the point where even the deceased may be scanned."
	icon = 'icons/obj/module.dmi'
	icon_state = "cloner_upgrade"
	w_class = 1
	throwforce = 1

/obj/machinery/computer/cloning/New()
	..()
	spawn(5)
		if(portable) return
		src.scanner = locate(/obj/machinery/clone_scanner, orange(2,src))
		src.pod1 = locate(/obj/machinery/clonepod, orange(4,src))

		src.temp = ""
		if (isnull(src.scanner))
			src.temp += " <font color=red>SCNR-ERROR</font>"
		if (isnull(src.pod1))
			src.temp += " <font color=red>POD1-ERROR</font>"
		else
			src.pod1.connected = src

		if (src.temp == "")
			src.temp = "System ready."
		return
	return

/obj/machinery/computer/cloning/attackby(obj/item/W as obj, mob/user as mob)
	if (wagesystem.clones_for_cash && istype(W, /obj/item/spacecash))
		var/obj/item/spacecash/cash = W
		src.held_credit += cash.amount
		cash.amount = 0
		user.show_text("<span style=\"color:blue\">You add [cash] to the credit in [src].</span>")
		user.u_equip(W)
		qdel(W)
	else if (istype(W, /obj/item/disk/data/floppy))
		if (!src.diskette)
			user.drop_item()
			W.set_loc(src)
			src.diskette = W
			boutput(user, "You insert [W].")
			src.updateUsrDialog()
			return

	else if((istype(W, /obj/item/screwdriver)) && ((src.stat & BROKEN) || !src.pod1 || !src.scanner))
		playsound(src.loc, "sound/items/Screwdriver.ogg", 50, 1)
		if(do_after(user, 20))
			boutput(user, "<span style=\"color:blue\">The broken glass falls out.</span>")
			var/obj/computerframe/A = new /obj/computerframe( src.loc )
			if(src.material) A.setMaterial(src.material)
			new /obj/item/raw_material/shard/glass( src.loc )
			var/obj/item/circuitboard/cloning/M = new /obj/item/circuitboard/cloning( A )
			for (var/obj/C in src)
				C.set_loc(src.loc)
			M.records = src.records
			if (src.allow_dead_scanning)
				new /obj/item/cloner_upgrade (src.loc)
			A.circuit = M
			A.state = 3
			A.icon_state = "3"
			A.anchored = 1
			qdel(src)

	else if (istype(W, /obj/item/cloner_upgrade))
		if (allow_dead_scanning)
			boutput(user, "<span style=\"color:red\">There is already an upgrade card installed.</span>")
			return

		user.visible_message("[user] installs [W] into [src].", "You install [W] into [src].")
		src.allow_dead_scanning = 1
		user.drop_item()
		qdel(W)

	else
		src.attack_hand(user)
	return

/obj/machinery/computer/cloning/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/cloning/attack_hand(mob/user as mob)
	user.machine = src
	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER))
		return

	var/dat = {"<h3>Cloning System Control</h3>
	<font size=-1><a href='byond://?src=\ref[src];refresh=1'>Refresh</a></font>
	<br><tt>[temp]</tt><br><hr>"}

	switch(src.menu)
		if(1) //Scan someone
			dat += "<h4>Scanner Functions</h4>"

			if (isnull(src.scanner))
				dat += "No scanner connected!"
			else
				if (src.scanner.occupant)
					dat += "<a href='byond://?src=\ref[src];scan=1'>Scan - [src.scanner.occupant]</a>"
				else
					dat += "Scanner unoccupied"

				dat += "<br>Lock status: <a href='byond://?src=\ref[src];lock=1'>[src.scanner.locked ? "Locked" : "Unlocked"]</a><BR>"

			dat += {"<h4>Cloning Pod Functions</h4>
					<a href='byond://?src=\ref[src];menu=5'>Genetic Analysis Mode</a><br>
					Status: <B>[pod1 && pod1.gen_analysis ? "Enabled" : "Disabled"]</B>
					<h4>Database Functions</h4>
					<a href='byond://?src=\ref[src];menu=2'>View Records</a><br>"}
			if (src.diskette)
				dat += "<a href='byond://?src=\ref[src];disk=eject'>Eject Disk</a>"


		if(2) //Viewing records
			dat += {"<h4>Current records</h4>
					<a href='byond://?src=\ref[src];menu=1'>Back</a><br><br>"}
			for(var/datum/data/record/R in src.records)
				dat += "<a href='byond://?src=\ref[src];view_rec=\ref[R]'>[R.fields["id"]]-[R.fields["name"]]</a><br>"

		if(3) //Viewing details of record
			dat += {"<h4>Selected Record</h4>
					<a href='byond://?src=\ref[src];menu=2'>Back</a><br>"}

			if (!src.active_record)
				dat += "<font color=red>ERROR: Record not found.</font>"
			else
				dat += {"<br><font size=1><a href='byond://?src=\ref[src];del_rec=1'>Delete Record</a></font><br>
						<b>Name:</b> [src.active_record.fields["name"]]<br>"}

				var/obj/item/implant/health/H = locate(src.active_record.fields["imp"])

				if ((H) && (istype(H)))
					dat += "<b>Health:</b> [H.sensehealth()]<br>"
				else
					dat += "<font color=red>Unable to locate implant.</font><br>"

				if (!isnull(src.diskette))
					dat += {"<a href='byond://?src=\ref[src];disk=load'>Load from disk.</a>
							 | Save: <a href='byond://?src=\ref[src];save_disk=holder'>Complete</a>
							<br>"}
				else
					dat += "<br>" //Keeping a line empty for appearances I guess.

				if (wagesystem.clones_for_cash)
					dat += "Current machine credit: [src.held_credit]<br>"
				dat += {"<a href='byond://?src=\ref[src];clone=\ref[src.active_record]'>Clone</a><br>"}

		if(4) //Deleting a record
			if (!src.active_record)
				src.menu = 2
			dat = {"[src.temp]<br>
					<h4>Confirm Record Deletion</h4>
					<b><a href='byond://?src=\ref[src];del_rec=1'>Yes</a></b><br>
					<b><a href='byond://?src=\ref[src];menu=3'>No</a></b>"}

		if(5) //Advanced genetics analysis
			dat += {"<h4>Advanced Genetic Analysis</h4>
					<a href='byond://?src=\ref[src];menu=1'>Back</a><br>
					<B>Notice:</B> Enabling this feature will prompt the attached clone pod to analyze the genetic makeup of the subject during cloning.
					Data will then be sent to any nearby GeneTek scanners and be used to improve their efficiency. The cloning process will be slightly slower as a result.<BR><BR>"}

			if(!pod1.operating)
				if(pod1.gen_analysis)
					dat += {"Enabled<BR>
							<a href='byond://?src=\ref[src];set_analysis=0'>Disable</A><BR>"}
				else
					dat += {"<a href='byond://?src=\ref[src];set_analysis=1'>Enable</A><BR>
							Disabled<BR>"}
			else
				dat += {"Cannot toggle while cloning pod is active. <BR>
						AGA: <B>[pod1.gen_analysis ? "Enabled" : "Disabled"]</B>"}

	user << browse(dat, "window=cloning")
	onclose(user, "cloning")
	return

/obj/machinery/computer/cloning/Topic(href, href_list)
	if(..())
		return

	if ((href_list["scan"]) && (!isnull(src.scanner)))
		src.scan_mob(src.scanner.occupant)

		//No locking an open scanner.
	else if ((href_list["lock"]) && (!isnull(src.scanner)))
		if ((!src.scanner.locked) && (src.scanner.occupant))
			src.scanner.locked = 1
		else
			src.scanner.locked = 0

	else if (href_list["view_rec"])
		src.active_record = locate(href_list["view_rec"])
		if ((isnull(src.active_record.fields["ckey"])) || (src.active_record.fields["ckey"] == ""))
			qdel(src.active_record)
			src.temp = "ERROR: Record Corrupt"
		else
			src.menu = 3

	else if (href_list["del_rec"])
		if ((!src.active_record) || (src.menu < 3))
			return
		if (src.menu == 3) //If we are viewing a record, confirm deletion
			src.temp = "Delete record?"
			src.menu = 4

		else if (src.menu == 4)
			src.records.Remove(src.active_record)
			qdel(src.active_record)
			src.temp = "Record deleted."
			src.menu = 2
/*
			var/obj/item/card/id/C = usr.equipped()
			if (istype(C))
				if(src.check_access(C))
					src.records.Remove(src.active_record)
					qdel(src.active_record)
					src.temp = "Record deleted."
					src.menu = 2
				else
					src.temp = "Access Denied."
*/
	else if (href_list["disk"]) //Load or eject.
		switch(href_list["disk"])
			if("load")
				if ((isnull(src.diskette)) || (src.diskette.data == ""))
					src.temp = "Load error."
					src.updateUsrDialog()
					return

				if (isnull(src.active_record))
					src.temp = "Record error."
					src.menu = 1
					src.updateUsrDialog()
					return

				if (src.diskette.data_type == "holder")
					src.active_record.fields["holder"] = src.diskette.data
					if (src.diskette.ue)
						src.active_record.fields["name"] = src.diskette.owner

				src.temp = "Load successful."
			if("eject")
				if (!isnull(src.diskette))
					src.diskette.set_loc(src.loc)
					src.diskette = null

	else if (href_list["save_disk"]) //Save to disk!
		if ((isnull(src.diskette)) || (src.diskette.read_only) || (isnull(src.active_record)))
			src.temp = "Save error."
			src.updateUsrDialog()
			return

		switch(href_list["save_disk"]) //Save as Ui/Ui+Ue/Se
			if("holder")
				src.diskette.data = src.active_record.fields["holder"]
				src.diskette.ue = 1
				src.diskette.data_type = "holder"
		src.diskette.owner = src.active_record.fields["name"]
		src.diskette.name = "data disk - '[src.diskette.owner]'"
		src.temp = "Save \[[href_list["save_disk"]]\] successful."

	else if (href_list["refresh"])
		src.updateUsrDialog()

	else if (href_list["clone"])
		var/datum/data/record/C = locate(href_list["clone"])
		//Look for that player! They better be dead!
		if (!istype(C))
			src.temp = "Record association error."
			return
		var/mob/selected = find_dead_player("[C.fields["ckey"]]")

//Can't clone without someone to clone.  Or a pod.  Or if the pod is busy. Or full of gibs.
		if (!selected)
			src.temp = "Unable to initiate cloning cycle." // most helpful error message in THE HISTORY OF THE WORLD
		else if (!src.pod1)
			src.temp = "No pod connected."
		else if (src.pod1.occupant)
			src.temp = "Pod already in use."
		else if (src.pod1.mess)
			src.temp = "Abnormal readings from pod."

		else if (wagesystem.clones_for_cash)
			var/datum/data/record/Ba = FindBankAccountByName(C.fields["name"])
			if (Ba && Ba.fields["current_money"] >= wagesystem.clone_cost)
				if (src.pod1.growclone(selected, C.fields["name"], C.fields["mind"], C.fields["holder"], C.fields["abilities"] , C.fields["traits"]))
					Ba.fields["current_money"] -= wagesystem.clone_cost
					src.temp = "[wagesystem.clone_cost] credits removed from [C.fields["name"]]'s account. Cloning cycle activated."
					src.records.Remove(C)
					qdel(C)
					src.menu = 1
			else if (src.held_credit >= wagesystem.clones_for_cash)
				if (src.pod1.growclone(selected, C.fields["name"], C.fields["mind"], C.fields["holder"], C.fields["abilities"] , C.fields["traits"]))
					src.held_credit -= wagesystem.clone_cost
					src.temp = "[wagesystem.clone_cost] credits removed from machine credit. Cloning cycle activated."
					src.records.Remove(C)
					qdel(C)
					src.menu = 1
			else
				src.temp = "Isufficient funds to begin clone cycle."

		else if (src.pod1.growclone(selected, C.fields["name"], C.fields["mind"], C.fields["holder"], C.fields["abilities"] , C.fields["traits"]))
			src.temp = "Cloning cycle activated."
			src.records.Remove(C)
			qdel(C)
			src.menu = 1

	else if (href_list["menu"])
		src.menu = text2num(href_list["menu"])
	else if (href_list["set_analysis"])
		pod1.gen_analysis = text2num(href_list["set_analysis"])

	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return

/obj/machinery/computer/cloning/proc/scan_mob(mob/living/carbon/human/subject as mob)
	if ((isnull(subject)) || (!istype(subject, /mob/living/carbon/human)))
		src.temp = "Error: Unable to locate valid genetic data."
		return
	if(!allow_dead_scanning && subject.decomp_stage)
		src.temp = "Error: Failed to read genetic data from subject.<br>Necrosis of tissue has been detected."
		return
	if (!subject.bioHolder || subject.bioHolder.HasEffect("husk"))
		src.temp = "Error: Extreme genetic degredation present."
		return

	var/datum/mind/subjMind = subject.mind
	if ((!subjMind) || (!subjMind.key))
		if (subject.ghost && subject.ghost.mind && subject.ghost.mind.key)
			subjMind = subject.ghost.mind
		else
			src.temp = "Error: Mental interface failure."
			return
	if (!isnull(find_record(ckey(subjMind.key))))
		src.temp = "Subject already in database."
		return

	var/datum/data/record/R = new /datum/data/record(  )
	R.fields["ckey"] = ckey(subjMind.key)
	R.fields["name"] = subject.real_name
	R.fields["id"] = copytext(md5(subject.real_name), 2, 6)

	var/datum/bioHolder/H = new/datum/bioHolder(null)
	H.CopyOther(subject.bioHolder)

	R.fields["holder"] = H

	R.fields["abilities"] = null
	if (subject.abilityHolder)
		var/datum/abilityHolder/A = subject.abilityHolder.deepCopy()
		R.fields["abilities"] = A

	R.fields["traits"] = list()
	if(subject.traitHolder && subject.traitHolder.traits.len)
		R.fields["traits"] = subject.traitHolder.traits.Copy()

	//Add an implant if needed
	var/obj/item/implant/health/imp = locate(/obj/item/implant/health, subject)
	if (isnull(imp))
		imp = new /obj/item/implant/health(subject)
		imp.implanted = 1
		imp.owner = subject
		subject.implant.Add(imp)
//		imp.implanted = subject // this isn't how this works with new implants sheesh
		R.fields["imp"] = "\ref[imp]"
	//Update it if needed
	else
		R.fields["imp"] = "\ref[imp]"

	if (!isnull(subjMind)) //Save that mind so traitors can continue traitoring after cloning.
		R.fields["mind"] = subjMind

	src.records += R
	src.temp = "Subject successfully scanned."

//Find a specific record by key.
/obj/machinery/computer/cloning/proc/find_record(var/find_key)
	var/selected_record = null
	for(var/datum/data/record/R in src.records)
		if (R.fields["ckey"] == find_key)
			selected_record = R
			break
	return selected_record

/obj/machinery/computer/cloning/power_change()

	if(stat & BROKEN)
		icon_state = "commb"
	else
		if( powered() )
			icon_state = initial(icon_state)
			stat &= ~NOPOWER
		else
			spawn(rand(0, 15))
				src.icon_state = "c_unpowered"
				stat |= NOPOWER


//New loading/storing records is a todo while I determine how it should work.
/obj/machinery/computer/cloning/proc
	load_record()
		if (!src.diskette || !src.diskette.root)
			return -1


		return 0

	save_record()
		if (!src.diskette || !src.diskette.root)
			return -1



		return 0


//Find a dead mob with a brain and client.
/proc/find_dead_player(var/find_key, needbrain=0)
	if (isnull(find_key))
		return

	var/mob/selected = null
	for(var/mob/M in mobs)
		//Dead people only thanks!
		if ((M.stat != 2) || (!M.client))
			continue
		//They need a brain!
		if (needbrain && ishuman(M) && !M:brain)
			continue

		if (M.ckey == find_key)
			selected = M
			break
	return selected

/obj/machinery/clone_scanner
	name = "Cloning machine scanner"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "scanner_0"
	density = 1
	mats = 15
	var/locked = 0.0
	var/mob/occupant = null
	anchored = 1.0
	soundproofing = 10

	allow_drop()
		return 0

	verb/move_inside()
		set src in oview(1)
		set category = "Local"

		if (usr.stat != 0)
			return

		if (src.occupant)
			boutput(usr, "<span style=\"color:blue\"><B>The scanner is already occupied!</B></span>")
			return

		usr.pulling = null
		usr.set_loc(src)
		src.occupant = usr
		src.icon_state = "scanner_1"

		for(var/obj/O in src)
			qdel(O)

		src.add_fingerprint(usr)
		return

	attackby(var/obj/item/grab/G as obj, user as mob)
		if ((!( istype(G, /obj/item/grab) ) || !( ismob(G.affecting) )))
			return

		if (src.occupant)
			boutput(user, "<span style=\"color:blue\"><B>The scanner is already occupied!</B></span>")
			return

		var/mob/M = G.affecting
		M.set_loc(src)
		src.occupant = M
		src.icon_state = "scanner_1"

		for(var/obj/O in src)
			O.set_loc(src.loc)

		src.add_fingerprint(user)
		qdel(G)
		return

	verb/eject()
		set src in oview(1)
		set category = "Local"

		if (usr.stat != 0)
			return

		src.go_out()
		add_fingerprint(usr)
		return

	proc/go_out()
		if ((!( src.occupant ) || src.locked))
			return

		for(var/obj/O in src)
			O.set_loc(src.loc)

		src.occupant.set_loc(src.loc)
		src.occupant = null
		src.icon_state = "scanner_0"
		return