/obj/datacore
	name = "datacore"
	var/list/medical = list(  )
	var/list/general = list(  )
	var/list/security = list(  )
	var/list/bank = list (  )
	var/list/fines = list (  )
	var/list/tickets = list (  )
	var/obj/machinery/networked/mainframe/mainframe = null

/obj/datacore/proc/addManifest(var/mob/living/carbon/human/H as mob)
	if (!H || !H.mind)
		return

	var/datum/data/record/G = new /datum/data/record(  )
	var/datum/data/record/M = new /datum/data/record(  )
	var/datum/data/record/S = new /datum/data/record(  )
	var/datum/data/record/B = new /datum/data/record(  )

	if (H.mind.assigned_role)
		G.fields["rank"] = H.mind.assigned_role
	else
		G.fields["rank"] = "Unassigned"

	G.fields["name"] = H.real_name
	G.fields["id"] = text("[]", add_zero(num2hex(rand(1, 1.6777215E7)), 6))
	M.fields["name"] = G.fields["name"]
	M.fields["id"] = G.fields["id"]
	S.fields["name"] = G.fields["name"]
	S.fields["id"] = G.fields["id"]

	B.fields["name"] = G.fields["name"]
	B.fields["id"] = G.fields["id"]

	if (H.gender == FEMALE)
		G.fields["sex"] = "Female"
	else
		G.fields["sex"] = "Male"

	G.fields["age"] ="[H.bioHolder.age]"
	G.fields["fingerprint"] = "[md5(H.bioHolder.Uid)]"
	G.fields["dna"] = H.bioHolder.Uid
	G.fields["p_stat"] = "Active"
	G.fields["m_stat"] = "Stable"
	spawn(10)
		G.fields["file_photo"] = H.build_flat_icon()

	M.fields["bioHolder.bloodType"] = "[H.bioHolder.bloodType]"
	M.fields["mi_dis"] = "None"
	M.fields["mi_dis_d"] = "No minor disabilities have been declared."
	M.fields["ma_dis"] = "None"
	M.fields["ma_dis_d"] = "No major disabilities have been diagnosed."
	M.fields["alg"] = "None"
	M.fields["alg_d"] = "No allergies have been detected in this patient."
	M.fields["cdi"] = "None"
	M.fields["cdi_d"] = "No diseases have been diagnosed at the moment."

	M.fields["h_imp"] = "No health implant detected."

	M.fields["notes"] = "No notes."

	M.fields["dnasample"] = create_new_dna_sample_file(H)

	var/traitStr = ""
	if(H.traitHolder)
		for(var/X in H.traitHolder.traits)
			var/obj/trait/T = getTraitById(X)
			if(length(traitStr)) traitStr += " | [T.cleanName]"
			else traitStr = T.name

	M.fields["traits"] = traitStr

	S.fields["criminal"] = "None"
	S.fields["mi_crim"] = "None"
	S.fields["mi_crim_d"] = "No minor crime convictions."
	S.fields["ma_crim"] = "None"
	S.fields["ma_crim_d"] = "No major crime convictions."
	S.fields["notes"] = "No notes."

	B.fields["job"] = H.job
	B.fields["current_money"] = 100.0
	B.fields["notes"] = "No notes."

	// If it exists for a job give them the correct wage
	var/wageMult = 1
	if(H.traitHolder.hasTrait("unionized"))
		wageMult = 1.5

	if(wagesystem.jobs[H.job])
		B.fields["wage"] = round(wagesystem.jobs[H.job] * wageMult)
	// Otherwise give them a default wage
	else
		var/datum/job/J = find_job_in_controller_by_string(G.fields["rank"])
		if (J && J.wages)
			B.fields["wage"] = round(J.wages * wageMult)
		else
			B.fields["wage"] = 0

	src.general += G
	src.medical += M
	src.security += S
	src.bank += B

	//Add email group
	if ("[H.mind.assigned_role]" in job_mailgroup_list)
		var/mailgroup = job_mailgroup_list["[H.mind.assigned_role]"]
		if (!mailgroup)
			return

		var/username = format_username(H.real_name)
		if (!src.mainframe || !src.mainframe.hd || !(src.mainframe.hd in src.mainframe))
			for (var/obj/machinery/networked/mainframe/newMainframe in machines)
				if (newMainframe.z != 1 || newMainframe.stat)
					continue

				if (newMainframe.hd)
					src.mainframe = newMainframe
					break

		if (src.mainframe)
			for (var/datum/computer/folder/folder in src.mainframe.hd.root.contents)
				if (ckey(folder.name) == "etc")
					for (var/datum/computer/folder/folder2 in folder.contents)
						if (ckey(folder2.name) == "mail")
							for (var/datum/computer/file/record/groups in folder2.contents)
								if (ckey(groups.name) != "groups")
									continue

								if (!groups.fields)
									break

								for (var/mailgroupEntry in groups.fields)
									if (dd_hasprefix(mailgroupEntry, "[mailgroup]:"))
										groups.fields -= mailgroupEntry
										groups.fields += "[mailgroupEntry][username],"
										break

								groups.fields += "[mailgroup]:[username],"
								break

						break

					break

			return
		return

/datum/ticket
	var/name = "ticket"
	var/target = null
	var/reason = null
	var/issuer = null
	var/issuer_job = null
	var/text = null
	var/target_byond_key = null
	var/issuer_byond_key = null

	New()
		spawn(10)
			statlog_ticket(src, usr)

/datum/fine
	var/ID = null
	var/name = "fine"
	var/target = null
	var/reason = null
	var/amount = 0
	var/issuer = null
	var/issuer_job = null
	var/approver = null
	var/approver_job = null
	var/paid_amount = 0
	var/paid = 0
	var/datum/data/record/bank_record = null
	var/target_byond_key = null
	var/issuer_byond_key = null
	var/approver_byond_key = null

	New()
		generate_ID()
		spawn(10)
			for(var/datum/data/record/B in data_core.bank) //gross
				if(B.fields["name"] == target)
					bank_record = B
					break
			if(!bank_record) qdel(src)
			statlog_fine(src, usr)

/datum/fine/proc/approve(var/approved_by,var/their_job)
	if(approver || paid) return
	if(!(their_job in list("Captain","Head of Security","Head of Personnel"))) return

	approver = approved_by
	approver_job = their_job
	approver_byond_key = get_byond_key(approver)

	if(bank_record.fields["current_money"] >= amount)
		bank_record.fields["current_money"] -= amount
		paid = 1
		paid_amount = amount
	else
		paid_amount += bank_record.fields["current_money"]
		bank_record.fields["current_money"] = 0
		spawn(300) process_payment()

/datum/fine/proc/process_payment()
	if(bank_record.fields["current_money"] >= (amount-paid_amount))
		bank_record.fields["current_money"] -= (amount-paid_amount)
		paid = 1
		paid_amount = amount
	else
		paid_amount += bank_record.fields["current_money"]
		bank_record.fields["current_money"] = 0
		spawn(300) process_payment()

/datum/fine/proc/generate_ID()
	if(!ID) ID = (data_core.fines.len + 1)