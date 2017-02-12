#define SOLID 1
#define LIQUID 2
#define GAS 3

/obj/submachine/chef_sink/chem_sink/
	name = "sink"
	density = 0
	layer = 5 // Todo not sure about this layer
	icon = 'icons/obj/chemical.dmi'
	icon_state = "sink"
	flags = NOSPLASH

// Removed quite a bit of of duplicate code here (Convair880).

///////////////////////////////////////////////////////////////////////////////////////////////////
/obj/machinery/chem_heater/
	name = "Reagent Heater/Cooler"
	density = 1
	anchored = 1
	icon = 'icons/obj/chemical.dmi'
	icon_state = "heater"
	flags = NOSPLASH
	mats = 15
	power_usage = 50
	var/obj/beaker = null
	var/active = 0
	var/target_temp = T0C
	var/roboworking = 0
	var/static/image/icon_beaker = image('icons/obj/chemical.dmi', "heater-beaker")
	// The chemistry APC was largely meaningless, so I made dispensers/heaters require a power supply (Convair880).

	attackby(var/obj/item/reagent_containers/glass/B as obj, var/mob/user as mob)

		if(!istype(B, /obj/item/reagent_containers/glass))
			return

		if (stat & (NOPOWER|BROKEN))
			user.show_text("[src] seems to be out of order.", "red")
			return

		if(src.beaker)
			boutput(user, "A beaker is already loaded into the machine.")
			return

		if(istype(user,/mob/living/silicon/robot/))
			if (roboworking)
				boutput(user, "<span style=\"color:red\">A cyborg is already using this!</span>")
				return
			var/temperature = input("Target Temperature (0-1000):", "Reagent Heater/Cooler", null, null) as null|num
			if(!temperature) return
			if (temperature > 1000) temperature = 1000
			if (temperature < 0) temperature = 0
			roboactive(B, user, temperature)
			roboworking = 1
		else
			src.beaker =  B
			user.drop_item()
			B.set_loc(src)
			boutput(user, "You add the beaker to the machine!")
			src.updateUsrDialog()
			src.update_icon()

	handle_event(var/event)
		if (event == "reagent_holder_update")
			src.update_icon()
			src.updateUsrDialog()

	ex_act(severity)
		switch(severity)
			if(1.0)
				qdel(src)
				return
			if(2.0)
				if (prob(50))
					qdel(src)
					return

	blob_act(var/power)
		if (prob(25 * power/20))
			qdel(src)

	meteorhit()
		qdel(src)
		return

	Topic(href, href_list)
		if(stat & (NOPOWER|BROKEN)) return
		if(usr.stat || usr.restrained()) return
		if(!in_range(src, usr)) return

		usr.machine = src
		if (!beaker) return

		if (href_list["eject"])
			beaker:set_loc(src.loc)
			beaker = null
			src.update_icon()
			src.updateUsrDialog()
			return
		else if (href_list["adjustM"])
			if (!beaker.reagents.total_volume) return
			var/change = text2num(href_list["adjustM"])
			target_temp = min(max(0, target_temp-change),1000)
			src.update_icon()
			src.updateUsrDialog()
			return
		else if (href_list["adjustP"])
			if (!beaker.reagents.total_volume) return
			var/change = text2num(href_list["adjustP"])
			target_temp = min(max(0, target_temp+change),1000)
			src.update_icon()
			src.updateUsrDialog()
			return
		else if (href_list["settemp"])
			if (!beaker.reagents.total_volume) return
			var/change = input(usr,"Target Temperature (0-1000):","Enter target temperature",target_temp) as null|num
			if(!change || !isnum(change)) return
			target_temp = min(max(0, change),1000)
			src.update_icon()
			src.updateUsrDialog()
			return
		else if (href_list["stop"])
			active = 0
			src.update_icon()
			src.updateUsrDialog()
			return
		else if (href_list["start"])
			if (!beaker.reagents.total_volume) return
			active = 1
			active()
			src.update_icon()
			src.updateUsrDialog()
			return
		else
			usr << browse(null, "window=chem_heater")
			src.update_icon()
			src.updateUsrDialog()
			return

		src.update_icon()
		src.updateUsrDialog()
		src.add_fingerprint(usr)
		return

	attack_ai(mob/user as mob)
		return src.attack_hand(user)

	attack_hand(mob/user as mob)
		if(stat & (NOPOWER|BROKEN))
			return
		user.machine = src
		var/dat = ""

		if(!beaker)
			dat += "Please insert beaker.<BR>"
		else if (!beaker.reagents.total_volume)
			dat += "Beaker is empty.<BR>"
			dat += "<A href='?src=\ref[src];eject=1'>Eject beaker</A><BR><BR>"
		else
			var/datum/reagents/R = beaker:reagents
			dat += "<A href='?src=\ref[src];eject=1'>Eject beaker</A><BR><BR>"
			dat += "<A href='?src=\ref[src];adjustM=10'>(<<)</A><A href='?src=\ref[src];adjustM=1'>(<)</A><A href='?src=\ref[src];settemp=1'> [target_temp] </A><A href='?src=\ref[src];adjustP=1'>(>)</A><A href='?src=\ref[src];adjustP=10'>(>>)</A><BR><BR>"

			if(active)
				dat += "Status: Active ([(target_temp > R.total_temperature) ? "Heating" : "Cooling"])<BR>"
				dat += "Current Temperature: [R.total_temperature]<BR>"
				dat += "<A href='?src=\ref[src];stop=1'>Deactivate</A><BR><BR>"
			else
				dat += "Status: Inactive<BR>"
				dat += "Current Temperature: [R.total_temperature]<BR>"
				dat += "<A href='?src=\ref[src];start=1'>Activate</A><BR><BR>"

			for(var/reagent_id in R.reagent_list)
				var/datum/reagent/current_reagent = R.reagent_list[reagent_id]
				dat += "[current_reagent.name], [current_reagent.volume] Units.<BR>"

		user << browse("<TITLE>Reagent Heating/Cooling Unit</TITLE>Reagent Heating/Cooling Unit:<BR><BR>[dat]", "window=chem_heater")

		onclose(user, "chem_heater")
		return


	proc/active()
		if(!active) return
		if (stat & (NOPOWER|BROKEN))
			src.power_usage = 50
			active = 0
			return
		if(!beaker)
			src.power_usage = 50
			active = 0
			return
		if(!beaker.reagents.total_volume)
			src.power_usage = 50
			active = 0
			return

		var/datum/reagents/R = beaker:reagents
		R.temperature_reagents(target_temp, 10)

		src.power_usage = 1000

		if(abs(R.total_temperature - target_temp) <= 3) active = 0

		src.updateUsrDialog()

		spawn(10) active()

	proc/roboactive(var/obj/item/reagent_containers/glass/B, var/mob/user, var/temperature)
		roboworking = 1
		src.power_usage = 1000
		var/datum/reagents/ROB = B:reagents
		boutput(user, "<span style=\"color:blue\">The temperature of [B] is now [ROB.total_temperature] degrees.</span>")

		if (get_dist(src, user) > 1)
			boutput(user, "<span style=\"color:red\">You need to move closer to heat the chemicals!</span>")
			src.power_usage = 50
			roboworking = 0
			return
		if (stat & (NOPOWER|BROKEN))
			user.show_text("[src] seems to be out of order.", "red")
			src.power_usage = 50
			roboworking = 0
			return

		ROB.temperature_reagents(temperature, 10)
		if(abs(ROB.total_temperature - temperature) <= 3)
			boutput(user, "<span style=\"color:blue\">The [src] has finished!</span>")
			src.power_usage = 50
			roboworking = 0
			return

		spawn(10) roboactive(B, user, temperature)
		B.reagents.handle_reactions()

	proc/update_icon()
		src.overlays -= src.icon_beaker
		if (src.beaker)
			src.overlays += src.icon_beaker
			if (src.active && src.beaker:reagents && src.beaker:reagents:total_volume)
				if (target_temp > src.beaker:reagents:total_temperature)
					src.icon_state = "heater-heat"
				else if (target_temp < src.beaker:reagents:total_temperature)
					src.icon_state = "heater-cool"
				else
					src.icon_state = "heater"
			else
				src.icon_state = "heater"
		else
			src.icon_state = "heater"

///////////////////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/chem_dispenser/
	name = "chem dispenser"
	density = 1
	anchored = 1
	icon = 'icons/obj/chemical.dmi'
	icon_state = "dispenser"
	var/icon_base = "dispenser"
	flags = NOSPLASH
	mats = 30
	var/beaker = null
	var/list/dispensable_reagents = list("aluminium","barium","bromine","carbon","chlorine","chromium","copper","fluorine","ethanol","hydrogen","iodine","iron","lithium","magnesium","mercury","nickel","nitrogen","oxygen","plasma","platinum","phosphorus","potassium","radium","silicon","silver","sodium","sulfur","sugar","water")
	var/glass_path = /obj/item/reagent_containers/glass
	var/glass_name = "beaker"
	var/dispenser_name = "Chemical"
	var/obj/item/card/id/user_id = null
	var/datum/reagent_group_account/current_account = null
	var/list/accounts = list()
	var/doing_a_thing = 0
	// The chemistry APC was largely meaningless, so I made dispensers/heaters require a power supply (Convair880).

	New()
		UnsubscribeProcess()

	attackby(var/obj/item/reagent_containers/glass/B as obj, var/mob/user as mob)
		if (!istype(B, glass_path) || B.incompatible_with_chem_dispensers == 1)
			return

		if (stat & (NOPOWER|BROKEN))
			user.show_text("[src] seems to be out of order.", "red")
			return

		if (istype(user,/mob/living/silicon/robot/))
			var/the_reagent = input("Which chemical do you want to put in the [glass_name]?", "[dispenser_name] Dispenser", null, null) as null|anything in src.dispensable_reagents
			if (!the_reagent)
				return
			var/amtlimit = B.reagents.maximum_volume - B.reagents.total_volume
			var/amount = input("How much of it do you want? (1 to [amtlimit])", "[dispenser_name] Dispenser", null, null) as null|num
			if (!amount)
				return
			amount = max(min(amount, amtlimit),0)
			if (get_dist(src,user) > 1)
				boutput(user, "You need to move closer to get the chemicals!")
				return
			if (stat & (NOPOWER|BROKEN))
				user.show_text("[src] seems to be out of order.", "red")
				return
			B.reagents.add_reagent(the_reagent,amount)
			B.reagents.handle_reactions()
			return

		else
			if (src.beaker)
				boutput(user, "A [glass_name] is already loaded into the machine.")
				return

			src.beaker =  B
			user.drop_item()
			B.set_loc(src)
			boutput(user, "You add the [glass_name] to the machine!")
			attack_hand(user)
			src.update_icon()

	handle_event(var/event)
		if (event == "reagent_holder_update")
			src.updateUsrDialog()

	ex_act(severity)
		switch(severity)
			if(1.0)
				qdel(src)
				return
			if(2.0)
				if (prob(50))
					qdel(src)
					return

	blob_act(var/power)
		if (prob(25 * power/20))
			qdel(src)

	meteorhit()
		qdel(src)
		return

	Topic(href, href_list)
		if (stat & (NOPOWER|BROKEN)) return
		if (usr.stat || usr.restrained()) return
		if (!in_range(src, usr)) return
		if (doing_a_thing) return

		usr.machine = src

		if (href_list["card"])
			if (src.user_id)
				src.eject_card()
				src.update_account()
			else
				var/obj/item/I = usr.equipped()
				if (istype(I, /obj/item/card/id))
					usr.drop_item()
					I.set_loc(src)
					src.user_id = I
					src.update_account()
			src.updateUsrDialog()

		else if (href_list["new_group"])
			doing_a_thing = 1
			var/reagents = input("Which reagents (separated by semicolons)?","New Group") as null|text
			if (!reagents)
				doing_a_thing = 0
				return
			var/name = input("What should the reagent group be called?","New Group") as null|text
			name = copytext(sanitize(html_encode(name)), 1, MAX_MESSAGE_LEN)
			if (!name)
				doing_a_thing = 0
				return
			var/list/reagentlist = params2list(reagents)
			var/datum/reagent_group/G = new /datum/reagent_group()
			for (var/reagent in reagentlist)
				if (lowertext(reagent) in src.dispensable_reagents)
					G.reagents += lowertext(reagent)
					G.reagent_number++
			if (!G.reagent_number)
				doing_a_thing = 0
				return
			G.name = name
			current_account.groups += G
			src.updateUsrDialog()
			doing_a_thing = 0
			return

		if (!beaker)
			return

		if (href_list["eject"])
			beaker:set_loc(src.loc)
			beaker = null
			src.update_icon()
			usr.machine = null
			usr << browse(null, "window=chem_dispenser")
			return

		else if (href_list["dispense"])
			if (!beaker)
				return
			else
				doing_a_thing = 1
				var/id = href_list["dispense"]
				if (!(id in dispensable_reagents))
					doing_a_thing = 0
					return
				beaker:reagents.add_reagent(id,10)
				beaker:reagents.handle_reactions()
				src.update_icon()
				src.updateUsrDialog()
				doing_a_thing = 0
				return

		else if (href_list["group_dispense"])
			if (!beaker)
				return
			else
				doing_a_thing = 1
				var/datum/reagent_group/group = locate(href_list["group_dispense"])
				for (var/reagent in group.reagents)
					if ((reagent in dispensable_reagents))
						beaker:reagents.add_reagent(reagent,10)
						beaker:reagents.handle_reactions()
				src.update_icon()
				src.updateUsrDialog()
				doing_a_thing = 0
				return
		else if (href_list["group_delete"])
			var/datum/reagent_group/group = locate(href_list["group_delete"])
			src.current_account.groups -= group
			qdel(group)
			src.updateUsrDialog()
			return
		if (href_list["isolate"])
			beaker:reagents.isolate_reagent(href_list["isolate"])
			src.update_icon()
			src.updateUsrDialog()
			return
		else if (href_list["remove"])
			beaker:reagents.del_reagent(href_list["remove"])
			src.update_icon()
			src.updateUsrDialog()
			return
		else if (href_list["remove5"])
			beaker:reagents.remove_reagent(href_list["remove5"], 5)
			src.update_icon()
			src.updateUsrDialog()
			return
		else if (href_list["remove1"])
			beaker:reagents.remove_reagent(href_list["remove1"], 1)
			src.update_icon()
			src.updateUsrDialog()
			return
		else
			usr << browse(null, "window=chem_dispenser")
			return

		src.add_fingerprint(usr)
		return

	attack_ai(mob/user as mob)
		return src.attack_hand(user)

	attack_hand(mob/user as mob)
		if(stat & (NOPOWER|BROKEN))
			return
		user.machine = src
		var/dat = ""
		if(!beaker)
			dat = "Please insert [glass_name].<BR>"
		else
			var/datum/reagents/R = beaker:reagents
			dat += "<A href='?src=\ref[src];eject=1'>Eject [glass_name]</A><BR><BR>"
			if (!R.total_volume)
				dat += "[capitalize(glass_name)] is empty.<BR>"
			else
				dat += "Contained reagents:<BR>"
				for (var/reagent_id in R.reagent_list)
					var/datum/reagent/current_reagent = R.reagent_list[reagent_id]
					dat += "[capitalize(current_reagent.name)], [current_reagent.volume] Units - <A href='?src=\ref[src];isolate=[current_reagent.id]'>(Isolate)</A> <A href='?src=\ref[src];remove=[current_reagent.id]'>(Remove all)</A> <A href='?src=\ref[src];remove5=[current_reagent.id]'>(Remove 5)</A> <A href='?src=\ref[src];remove1=[current_reagent.id]'>(Remove 1)</A><BR>"
			if (R.total_volume == R.maximum_volume)
				dat += "[capitalize(glass_name)] is full.<BR>"
			else
				dat += "<BR>"
				for (var/re in dispensable_reagents)
					var/datum/reagent/to_dispense = reagents_cache[re]
					if (to_dispense)
						dat += "<A href='?src=\ref[src];dispense=[to_dispense.id];state=[to_dispense.reagent_state];name=[to_dispense.name]'>[capitalize(to_dispense.name)]</A><BR>"
		dat += "<BR>Card: <a href='?src=\ref[src];card=1'>[src.user_id ? "Eject" : "-----"]</a>"
		if (src.current_account)
			dat += "<BR><BR><a href='?src=\ref[src];new_group=1'>New Group</a><BR>"
			for (var/datum/reagent_group/group in current_account.groups)
				dat += "<BR><a href='?src=\ref[src];group_dispense=\ref[group]'>[group.name]</a>: "
				var/reagent_number = 0
				for (var/reagent in group.reagents)
					reagent_number++
					dat += "[reagent][group.reagent_number == reagent_number ? "" : ", "]"
				dat += "<BR><a href='?src=\ref[src];group_delete=\ref[group]'>Delete</a>"
		user << browse("<TITLE>[dispenser_name] Dispenser</TITLE>[dispenser_name] dispenser:<BR>[dat]", "window=chem_dispenser;size=500x800")

		onclose(user, "chem_dispenser")
		return

	proc/eject_card()
		if (src.user_id)
			src.user_id.set_loc(get_turf(src))
			src.user_id = null
		return

	proc/update_account()
		for (var/datum/reagent_group_account/A in src.accounts)
			if (A.user_id == src.user_id)
				src.current_account = A
				return
		var/datum/reagent_group_account/new_account = new /datum/reagent_group_account()
		new_account.user_id = src.user_id
		src.accounts += new_account
		src.current_account = new_account

	proc/update_icon()
		if (!beaker)
			src.icon_state = src.icon_base
		else
			src.icon_state = "[src.icon_base][rand(1,5)]"

/obj/machinery/chem_dispenser/alcohol
	name = "alcohol dispenser"
	desc = "You see a small, fading warning label on the side of the machine:<br>WARNING: Contents artificially produced using industrial ethanol. Not recommended for human consumption."
	dispensable_reagents = list("beer", "cider", "gin", "wine", "champagne", "rum", "vodka", "bourbon", "vermouth", "tequila", "bitters", "tonic")
	icon_state = "alc_dispenser"
	icon_base = "alc_dispenser"
	glass_path = /obj/item/reagent_containers/food/drinks
	glass_name = "bottle"
	dispenser_name = "Alcohol"

/obj/machinery/chem_dispenser/soda
	name = "soda fountain"
	desc = "A soda fountain that definitely does not have a suspicious similarity to the alcohol and chemical dispensers. No sir."
	dispensable_reagents = list("cola", "juice_lime", "juice_lemon", "juice_orange", "juice_cran", "juice_cherry", "juice_pineapple", "juice_tomato", "coconut_milk", "sugar", "water", "vanilla", "tea")
	icon_state = "alc_dispenser"
	icon_base = "alc_dispenser"
	glass_path = /obj/item/reagent_containers/food/drinks
	glass_name = "bottle"
	dispenser_name = "Soda"

// Reagent Groups

/datum/reagent_group_account
	var/obj/item/card/id/user_id = null
	var/list/groups = list()

/datum/reagent_group
	var/name = null
	var/reagents = list()
	var/reagent_number = 0

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/chem_master/
	name = "CheMaster 3000"
	density = 1
	anchored = 1
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mixer0"
	flags = NOSPLASH
	mats = 15
	var/beaker = null
	var/list/whitelist = list()
	var/emagged = 0

	New()
		..()
		if (!src.emagged && islist(chem_whitelist) && chem_whitelist.len)
			src.whitelist = chem_whitelist

	ex_act(severity)
		switch (severity)
			if (1.0)
				qdel(src)
				return
			if (2.0)
				if (prob(50))
					qdel(src)
					return

	blob_act(var/power)
		if (prob(25 * power/20))
			qdel(src)

	meteorhit()
		qdel(src)
		return

	handle_event(var/event)
		if (event == "reagent_holder_update")
			src.updateUsrDialog()

	attackby(var/obj/item/reagent_containers/glass/B as obj, var/mob/user as mob)
		if (!istype(B, /obj/item/reagent_containers/glass))
			return

		if (src.beaker)
			boutput(user, "A beaker is already loaded into the machine.")
			return
		if (istype(user,/mob/living/silicon/robot/))
			boutput(user, "This machine is not compatible with mechanical users.")
			return
		src.beaker =  B
		user.drop_item()
		B.set_loc(src)
		boutput(user, "You add the beaker to the machine!")
		src.updateUsrDialog()
		icon_state = "mixer1"

	Topic(href, href_list)
		if (stat & BROKEN) return
		if (usr.stat || usr.restrained()) return
		if (!in_range(src, usr)) return

		usr.machine = src

		if (href_list["close"])
			usr << browse(null, "window=chem_master")
			return

		if (!beaker) return
		var/datum/reagents/R = beaker:reagents

		if (href_list["analyze"])
			var/dat = "<TITLE>Chemmaster 3000</TITLE>Chemical infos:<BR><BR>Name:<BR>[href_list["name"]]<BR><BR>Description:<BR>[href_list["desc"]]<BR><BR><BR><A href='?src=\ref[src];main=1'>(Back)</A>"
			usr << browse(dat, "window=chem_master;size=575x400")
			return
		else if (href_list["isolate"])
			beaker:reagents.isolate_reagent(href_list["isolate"])
			src.updateUsrDialog()
			return
		else if (href_list["remove"])
			beaker:reagents.del_reagent(href_list["remove"])
			src.updateUsrDialog()
			return
		else if (href_list["remove5"])
			beaker:reagents.remove_reagent(href_list["remove5"], 5)
			src.updateUsrDialog()
			return
		else if (href_list["remove1"])
			beaker:reagents.remove_reagent(href_list["remove1"], 1)
			src.updateUsrDialog()
			return
		else if (href_list["main"])
			attack_hand(usr)
			return
		else if (href_list["eject"])
			beaker:set_loc(src.loc)
			beaker = null
			icon_state = "mixer0"
			src.updateUsrDialog()
			return

		else if (href_list["createpill"])
			var/input_name = input(usr, "Name the pill:", "Name", R.get_master_reagent_name()) as null|text
			var/pillname = copytext(html_encode(input_name), 1, 32)
			if (!pillname)
				return
			if (pillname == " ")
				pillname = R.get_master_reagent_name()
			var/obj/item/reagent_containers/pill/P = new/obj/item/reagent_containers/pill(src.loc)
			P.name = "[pillname] pill"
			R.trans_to(P, 100)//R.total_volume) we can't move all of the reagents if it's >100u so let's only move 100u
			src.updateUsrDialog()
			return

		else if (href_list["multipill"])
			// get the pill name from the user
			var/input_pillname = input(usr, "Name the pill:", "Name", R.get_master_reagent_name()) as null|text
			var/pillname = copytext(html_encode(input_pillname), 1, 32)
			if (!pillname)
				return
			if (pillname == " ")
				pillname = R.get_master_reagent_name()

			// get the pill volume from the user
			var/pillvol = input(usr, "Volume of chemical per pill: (Min/Max 5/100):", "Volume", 5) as null|num
			if (!pillvol)
				return
			pillvol = minmax(pillvol, 5, 100)

			// maths
			var/pillcount = round(R.total_volume / pillvol) // round with a single parameter is actually floor because byond
			if (!pillcount)
				// invalid input
				boutput(usr, "[src] makes a weird grinding noise. That can't be good.")
				return
			else
				// create a pill bottle
				var/obj/item/chem_pill_bottle/B = new /obj/item/chem_pill_bottle(src.loc)
				B.create_from_reagents(R, pillname, pillvol, pillcount)

			src.updateUsrDialog()
			return

		else if (href_list["createbottle"])
			var/input_name = input(usr, "Name the bottle:", "Name", R.get_master_reagent_name()) as null|text
			var/bottlename = copytext(html_encode(input_name), 1, 32)
			if (!bottlename)
				return
			if (bottlename == " ")
				bottlename = R.get_master_reagent_name()
			var/obj/item/reagent_containers/glass/bottle/P = new/obj/item/reagent_containers/glass/bottle(src.loc)
			P.name = "[bottlename] bottle"
			R.trans_to(P,30)
			src.updateUsrDialog()
			return

		else if (href_list["createpatch"])
			var/input_name = input(usr, "Name the patch:", "Name", R.get_master_reagent_name()) as null|text
			var/patchname = copytext(html_encode(input_name), 1, 32)
			if (!patchname)
				return
			if (patchname == " ")
				patchname = R.get_master_reagent_name()
			var/med = src.check_whitelist(R)
			var/obj/item/reagent_containers/patch/P
			if (R.total_volume <= 20)
				P = new /obj/item/reagent_containers/patch/mini(src.loc)
				P.name = "[patchname] mini-patch"
			else
				P = new /obj/item/reagent_containers/patch(src.loc)
				P.name = "[patchname] patch"
			P.medical = med
			R.trans_to(P, 40)
			src.updateUsrDialog()
			return

		else if (href_list["multipatch"])
			// get the pill name from the user
			var/input_name = input(usr, "Name the patch:", "Name", R.get_master_reagent_name()) as null|text
			var/patchname = copytext(html_encode(input_name), 1, 32)
			if (!patchname)
				return
			if (patchname == " ")
				patchname = R.get_master_reagent_name()

			// get the pill volume from the user
			var/patchvol = input(usr, "Volume of chemical per patch: (Min/Max 5/40)", "Volume", 5) as null|num
			if (!patchvol)
				return
			patchvol = minmax(patchvol, 5, 40)

			// maths
			var/patchcount = round(R.total_volume / patchvol) // round with a single parameter is actually floor because byond
			if (!patchcount)
				// invalid input
				boutput(usr, "[src] makes a weird grinding noise. That can't be good.")
				return
			else
				// create a patchbox
				var/obj/item/item_box/medical_patches/B = new /obj/item/item_box/medical_patches(src.loc)
				var/med = src.check_whitelist(R)
				for (var/i=patchcount, i>0, i--)
					var/obj/item/reagent_containers/patch/P
					if (patchvol <= 20)
						P = new /obj/item/reagent_containers/patch/mini(B)
						P.name = "[patchname] mini-patch"
					else
						P = new /obj/item/reagent_containers/patch(B)
						P.name = "[patchname] patch"
					P.medical = med
					R.trans_to(P, patchvol)

			src.updateUsrDialog()
			return

		else
			usr << browse(null, "window=chem_master")
			return

		src.add_fingerprint(usr)
		return

	attack_ai(mob/user as mob)
		return src.attack_hand(user)

	attack_hand(mob/user as mob)
		if (stat & BROKEN)
			return
		user.machine = src
		var/dat = ""
		if (!beaker)
			dat = "Please insert beaker.<BR>"
			dat += "<A href='?src=\ref[src];close=1'>Close</A>"
		else
			var/datum/reagents/R = beaker:reagents
			dat += "<A href='?src=\ref[src];eject=1'>Eject beaker</A><BR><BR>"
			if (!R.total_volume)
				dat += "Beaker is empty."
			else
				dat += "Contained reagents:<BR>"
				for (var/reagent_id in R.reagent_list)
					var/datum/reagent/current_reagent = R.reagent_list[reagent_id]
					dat += "[capitalize(current_reagent.name)] - [current_reagent.volume] Units - <A href='?src=\ref[src];analyze=1;desc=[html_encode(current_reagent.description)];name=[capitalize(current_reagent.name)]'>(Analyze)</A> <A href='?src=\ref[src];isolate=[current_reagent.id]'>(Isolate)</A> <A href='?src=\ref[src];remove=[current_reagent.id]'>(Remove all)</A> <A href='?src=\ref[src];remove5=[current_reagent.id]'>(-5)</A> <A href='?src=\ref[src];remove1=[current_reagent.id]'>(-1)</A><BR>"
				dat += "<BR><A href='?src=\ref[src];createpill=1'>Create pill (100 units max)</A><BR>"
				dat += "<A href='?src=\ref[src];multipill=1'>Create multiple pills (5 units min)</A><BR>"
				dat += "<A href='?src=\ref[src];createbottle=1'>Create bottle (30 units max)</A><BR>"
				dat += "<A href='?src=\ref[src];createpatch=1'>Create patch (40 units max)</A><BR>"
				dat += "<A href='?src=\ref[src];multipatch=1'>Create multiple patches (5 units min)</A>"
		user << browse("<TITLE>Chemmaster 3000</TITLE>Chemmaster menu:<BR><BR>[dat]", "window=chem_master;size=575x400")
		onclose(user, "chem_master")
		return

	emag_act(var/mob/user, var/obj/item/card/emag/E)
		if (src.emagged)
			return 0
		if (user)
			user.show_text("[src]'s safeties have been disabled.", "red")
		src.emagged = 1
		return 1

	demag(var/mob/user)
		if (!src.emagged)
			return 0
		if (user)
			user.show_text("[src]'s safeties have been reactivated.", "blue")
		src.emagged = 0
		return 1

	proc/check_whitelist(var/datum/reagents/R)
		if (src.emagged || !R || !src.whitelist || (islist(src.whitelist) && !src.whitelist.len))
			return 1
		var/all_safe = 1
		for (var/reagent_id in R.reagent_list)
			if (!src.whitelist.Find(reagent_id))
				all_safe = 0
		return all_safe

/datum/chemicompiler_core/stationaryCore
	statusChangeCallback = "statusChange"

/obj/machinery/chemicompiler_stationary/
	name = "ChemiCompiler CCS1000"
	desc = "this device looks very difficult to use."
	density = 1
	anchored = 1
	icon = 'icons/obj/chemical.dmi'
	icon_state = "chemicompiler_st_off"
	mats = 15
	var/datum/chemicompiler_executor/executor
	var/datum/light/light

	New()
		..()
		executor = new(src, /datum/chemicompiler_core/stationaryCore)
		light = new /datum/light/point
		light.set_brightness(0.4)
		light.attach(src)

	ex_act(severity)
		switch (severity)
			if (1.0)
				qdel(src)
				return
			if (2.0)
				if (prob(50))
					qdel(src)
					return

	blob_act(var/power)
		if (prob(25 * power/20))
			qdel(src)

	meteorhit()
		qdel(src)
		return

	attack_ai(mob/user as mob)
		return src.attack_hand(user)

	attack_hand(mob/user as mob)
		if (stat & BROKEN || !powered())
			return
		user.machine = src
		executor.panel()
		onclose(usr, "chemicompiler")
		return

	power_change()
		if(stat & BROKEN)
			icon_state = initial(icon_state)
			light.disable()

		else if(powered())
			if (executor.core.running)
				icon_state = "chemicompiler_st_working"
				light.set_brightness(0.6)
				light.enable()
			else
				icon_state = "chemicompiler_st_on"
				light.set_brightness(0.4)
				light.enable()
		else
			spawn(rand(0, 15))
				icon_state = initial(icon_state)
				stat |= NOPOWER
				light.disable()

	proc
		topicPermissionCheck(action)
			if (!(src in range(1)))
				return 0
			if (executor.core.running)
				if(!(action in list("getUIState", "reportError")))
					return 0
			return 1

		statusChange(oldStatus, newStatus)
			power_change()