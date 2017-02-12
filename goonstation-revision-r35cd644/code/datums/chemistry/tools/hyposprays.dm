var/global/list/chem_whitelist = list("antihol", "charcoal", "epinephrine", "insulin", "mutadone", "teporone",\
"silver_sulfadiazine", "salbutamol", "perfluorodecalin", "omnizine", "stimulants", "synaptizine", "anti_rad",\
"oculine", "mannitol", "penteticacid", "stypic_powder", "methamphetamine", "spaceacillin", "saline",\
"salicylic_acid", "cryoxadone", "blood", "bloodc")

/* =================================================== */
/* -------------------- Hypospray -------------------- */
/* =================================================== */

/obj/item/reagent_containers/hypospray
	name = "hypospray"
	desc = "An automated injector that will dump out any harmful chemicals it finds in itself."
	icon = 'icons/obj/chemical.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_medical.dmi'
	initial_volume = 30
	item_state = "syringe_0"
	icon_state = "hypo0"
	amount_per_transfer_from_this = 5
	flags = FPRINT | TABLEPASS | OPENCONTAINER | ONBELT | NOSPLASH
	module_research = list("science" = 3, "medicine" = 2)
	module_research_type = /obj/item/reagent_containers/hypospray
	var/list/whitelist = list()
	var/inj_amount = 5
	var/safe = 1
	mats = 6
	rc_flags = RC_SCALE | RC_VISIBLE | RC_SPECTRO
	var/image/fluid_image

	emagged
		safe = 0 // who keeps doing the emag_act() thing idgi

	New()
		..()
		fluid_image = image(src.icon, "hypoover")
		if (src.safe && islist(chem_whitelist) && chem_whitelist.len)
			src.whitelist = chem_whitelist

	proc/check_whitelist(var/mob/user as mob)
		if (!safe || !src.whitelist || (islist(src.whitelist) && !src.whitelist.len))
			return
		var/found = 0
		for (var/reagent_id in src.reagents.reagent_list)
			if (!src.whitelist.Find(reagent_id))
				src.reagents.del_reagent(reagent_id)
				found = 1
		if (found)
			if (user)
				user.show_text("[src] identifies and removes a harmful substance.", "red") // haine: done -> //TODO: using usr in procs is evil shame on you
			else if (ismob(src.loc))
				var/mob/M = src.loc
				M.show_text("[src] identifies and removes a harmful substance.", "red")
			else
				src.visible_message("<span style=\"color:red\">[src] identifies and removes a harmful substance.</span>")

	proc/update_icon()
		if (src.reagents.total_volume)
			src.icon_state = "hypo1"
			src.name = "hypospray ([src.reagents.get_master_reagent_name()])"
			if (!src.fluid_image)
				fluid_image = image(src.icon, "hypoover")
			src.fluid_image.color = src.reagents.get_master_color()
			src.UpdateOverlays(src.fluid_image, "fluid")
		else
			src.icon_state = "hypo0"
			src.name = "hypospray"
			src.UpdateOverlays(null, "fluid")

	on_reagent_change(add)
		if (src.safe && add)
			src.check_whitelist() // we only need to purge bad chems if new chems have been added
		src.update_icon()

	attack_self(mob/user as mob)
		update_icon()
		user.machine = src
		var/dat = ""
		dat += "Injection amount: <A href='?src=\ref[src];change_amt=1'>[inj_amount == -1 ? "ALL" : inj_amount]</A><BR><BR>"

		if (src.reagents.total_volume)
			dat += "Contains: <BR>"
			for (var/current_id in reagents.reagent_list)
				var/datum/reagent/current_reagent = reagents.reagent_list[current_id]
				dat += " - [current_reagent.volume] [current_reagent.name]<BR>"
			dat += "<A href='?src=\ref[src];dump_cont=1'>Dump contents</A>"

		user << browse("<TITLE>Hypospray</TITLE>Hypospray:<BR><BR>[dat]", "window=hypospray;size=350x250")
		onclose(user, "hypospray")
		return

	Topic(href, href_list)
		..()
		if (usr != src.loc)
			return

		if (href_list["dump_cont"])
			src.reagents.clear_reagents()

		if (href_list["change_amt"])
			var/amt = input(usr,"Select:","Amount", inj_amount) in list("ALL",1,2,3,4,5,8,10,15,20,25)
			if (amt == "ALL")
				inj_amount = -1
			else
				inj_amount = amt

		updateUsrDialog()
		attack_self(usr)

	emag_act(var/mob/user, var/obj/item/card/emag/E)
		if (!safe)
			return 0
		if (user)
			user.show_text("[src]'s safeties have been disabled.", "red")
		safe = 0
		var/image/magged = image(src.icon, "hypomag", layer = FLOAT_LAYER)
		src.UpdateOverlays(magged, "emagged")
		return 1

	demag(var/mob/user)
		if (safe)
			return 0
		if (user)
			user.show_text("[src]'s safeties have been reactivated.", "blue")
		safe = 1
		src.overlays = null
		src.update_icon()
		return 1


	attack(mob/M as mob, mob/user as mob, def_zone)
		if (!reagents.total_volume)
			user.show_text("[src] is empty.", "red")
			return

		if (ismob(M))
			var/amt_prop = inj_amount == -1 ? src.reagents.total_volume : inj_amount
			user.visible_message("<span style=\"color:blue\"><B>[user] injects [M] with [min(amt_prop, reagents.total_volume)] units of [src.reagents.get_master_reagent_name()].</B></span>",\
			"<span style=\"color:blue\">You inject [min(amt_prop, reagents.total_volume)] units of [src.reagents.get_master_reagent_name()]. [src] now contains [max(0,(src.reagents.total_volume-amt_prop))] units.</span>")
			logTheThing("combat", user, M, "uses a hypospray [log_reagents(src)] to inject %target% at [log_loc(user)].")

			src.reagents.trans_to(M, amt_prop)

			playsound(M.loc, 'sound/items/hypo.ogg', 80, 0)
		else
			user.show_text("[src] can only be used on living organisms.", "red")

		update_icon()
