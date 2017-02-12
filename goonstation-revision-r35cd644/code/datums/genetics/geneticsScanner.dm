var/list/genescanner_addresses = list()

/obj/machinery/genetics_scanner
	name = "GeneTek scanner"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "scanner_0"
	density = 1
	mats = 15
	var/mob/occupant = null
	var/locked = 0
	anchored = 1.0
	soundproofing = 10

	var/net_id = null
	var/frequency = 1149
	var/datum/radio_frequency/radio_connection

	New()
		..()
		spawn(8)
			if(radio_controller)
				radio_connection = radio_controller.add_object(src, "[frequency]")
			if(!src.net_id)
				src.net_id = generate_net_id(src)
				genescanner_addresses += src.net_id

	disposing()
		if (radio_controller)
			radio_controller.remove_object(src, "[frequency]")
		radio_connection = null
		if (src.net_id)
			genescanner_addresses -= src.net_id
		occupant = null
		..()

	allow_drop()
		return 0

	examine()
		set src in oview(7)

		..()
		if (src.occupant)
			boutput(usr, "[src.occupant.name] is inside the scanner.")
		else
			boutput(usr, "There is nobody currently inside the scanner.")
		if (src.locked)
			boutput(usr, "The scanner is currently locked.")
		else
			boutput(usr, "The scanner is not currently locked.")

	verb/move_inside()
		set name = "Enter"
		set src in oview(1)
		set category = "Local"

		if(!iscarbon(usr))
			boutput(usr, "<span style=\"color:red\"><B>The scanner supports only carbon based lifeforms.</B></span>")
			return

		if (usr.stat != 0)
			return

		if (src.occupant)
			boutput(usr, "<span style=\"color:blue\"><B>The scanner is already occupied!</B></span>")
			return

		if (src.locked)
			boutput(usr, "<span style=\"color:red\"><B>You need to unlock the scanner first.</B></span>")
			return

		usr.pulling = null
		src.go_in(usr)

		for(var/obj/O in src)
			qdel(O)

		src.add_fingerprint(usr)
		return

	attackby(var/obj/item/grab/G as obj, user as mob)
		if ((!( istype(G, /obj/item/grab) ) || !( ismob(G.affecting) )))
			return
		if (!istype(user,/mob/living/))
			boutput(user, "<span style=\"color:red\">You're dead! Quit that!</span>")
			return

		if (src.occupant)
			boutput(user, "<span style=\"color:red\"><B>The scanner is already occupied!</B></span>")
			return

		if (src.locked)
			boutput(usr, "<span style=\"color:red\"><B>You need to unlock the scanner first.</B></span>")
			return

		if(!iscarbon(G.affecting))
			boutput(user, "<span style=\"color:blue\"><B>The scanner supports only carbon based lifeforms.</B></span>")
			return

		var/mob/living/L = user

		var/mob/M = G.affecting
		if (L.pulling == M)
			L.pulling = null
		src.go_in(M)

		for(var/obj/O in src)
			O.set_loc(src.loc)

		src.add_fingerprint(user)
		qdel(G)
		return

	verb/eject()
		set name = "Eject Occupant"
		set src in oview(1)
		set category = "Local"

		if (usr.stat != 0)
			return
		if (src.locked)
			boutput(usr, "<span style=\"color:red\"><b>The scanner door is locked!</b></span>")
			return

		src.go_out()
		add_fingerprint(usr)
		return

	verb/lock()
		set name = "Scanner Lock"
		set src in oview(1)
		set category = "Local"

		if (usr.stat != 0)
			return
		if (usr == src.occupant)
			boutput(usr, "<span style=\"color:red\"><b>You can't reach the scanner lock from the inside.</b></span>")
			return

		playsound(src.loc, "sound/machines/click.ogg", 50, 1)
		if (src.locked)
			src.locked = 0
			usr.visible_message("<b>[usr]</b> unlocks the scanner.")
			if (src.occupant)
				boutput(src.occupant, "<span style=\"color:red\">You hear the scanner's lock slide out of place.</span>")
		else
			src.locked = 1
			usr.visible_message("<b>[usr]</b> locks the scanner.")
			if (src.occupant)
				boutput(src.occupant, "<span style=\"color:red\">You hear the scanner's lock click into place.</span>")

		// Added (Convair880).
		if (src.occupant)
			logTheThing("station", usr, src.occupant, "[src.locked ? "locks" : "unlocks"] the [src.name] with %target% inside at [log_loc(src)].")

		return

	proc/go_in(var/mob/M)
		if (src.occupant || !M)
			return

		if (src.locked)
			return

		M.set_loc(src)
		src.occupant = M
		src.icon_state = "scanner_1"
		return

	proc/go_out()
		if (!src.occupant)
			return

		if (src.locked)
			return

		for(var/obj/O in src)
			O.set_loc(src.loc)

		src.occupant.set_loc(src.loc)
		src.occupant = null
		src.icon_state = "scanner_0"
		return

///////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/genetics_appearancemenu
	var/client/usercl = null

	var/mob/living/carbon/human/target_mob = null

	var/customization_first = "Short Hair"
	var/customization_second = "None"
	var/customization_third = "None"

	var/customization_first_color = "#FFFFFF"
	var/customization_second_color = "#FFFFFF"
	var/customization_third_color = "#FFFFFF"
	var/e_color = "#FFFFFF"

	var/s_tone = 0.0

	var/icon/preview_icon = null

	New(var/client/newuser, var/mob/target)
		..()
		if(!newuser || !ishuman(target))
			qdel(src)
			return

		src.target_mob = target
		src.usercl = newuser
		src.load_mob_data(src.target_mob)
		src.update_menu()
		src.process()
		return

	disposing()
		if(usercl && usercl.mob)
			usercl.mob << browse(null, "window=geneticsappearance")
			usercl = null
		target_mob = null
		..()

	Topic(href, href_list)
		if(href_list["close"])
			qdel(src)
			return

		else if (href_list["customization_first"])
			var/new_style = input(usr, "Please select detail style", "Appearance Menu")  as null|anything in customization_styles + customization_styles_gimmick

			if (new_style)
				src.customization_first = new_style

		else if (href_list["customization_second"])
			var/new_style = input(usr, "Please select detail style", "Appearance Menu")  as null|anything in customization_styles + customization_styles_gimmick

			if (new_style)
				src.customization_second = new_style

		else if (href_list["customization_third"])
			var/new_style = input(usr, "Please select detail style", "Appearance Menu")  as null|anything in customization_styles + customization_styles_gimmick

			if (new_style)
				src.customization_third = new_style

		else if (href_list["hair"])
			var/new_hair = input(usr, "Please select hair color.", "Appearance Menu") as color
			if(new_hair)
				src.customization_first_color = new_hair

		else if (href_list["facial"])
			var/new_facial = input(usr, "Please select detail 1 color.", "Appearance Menu") as color
			if(new_facial)
				src.customization_second_color = new_facial

		else if (href_list["detail"])
			var/new_detail = input(usr, "Please select detail 2 color.", "Appearance Menu") as color
			if(new_detail)
				src.customization_third_color = new_detail

		else if (href_list["eyes"])
			var/new_eyes = input(usr, "Please select eye color.", "Appearance Menu") as color
			if(new_eyes)
				src.e_color = new_eyes

		else if (href_list["s_tone"])
			var/new_tone = input(usr, "Please select skin tone level: 1-220 (1=albino, 35=caucasian, 150=black, 220='very' black)", "Appearance Menu")  as text

			if (new_tone)
				src.s_tone = max(min(round(text2num(new_tone)), 220), 1)
				src.s_tone =  -src.s_tone + 35

		else if(href_list["apply"])
			src.copy_to_target()
			qdel(src)

		src.update_menu()
		return

	proc
		load_mob_data(var/mob/living/carbon/human/H)
			if(!ishuman(H))
				qdel(src)
				return

			src.s_tone = H.bioHolder.mobAppearance.s_tone

			src.customization_first = H.bioHolder.mobAppearance.customization_first
			src.customization_first_color = H.bioHolder.mobAppearance.customization_first_color

			src.customization_second = H.bioHolder.mobAppearance.customization_second
			src.customization_second_color = H.bioHolder.mobAppearance.customization_second_color

			src.customization_third = H.bioHolder.mobAppearance.customization_third
			src.customization_third_color = H.bioHolder.mobAppearance.customization_third_color

			if(!(customization_styles[src.customization_first] || customization_styles_gimmick[src.customization_first]))
				src.customization_first = "None"

			if(!(customization_styles[src.customization_second] || customization_styles_gimmick[src.customization_second]))
				src.customization_second = "None"

			if(!(customization_styles[src.customization_third] || customization_styles_gimmick[src.customization_third]))
				src.customization_third = "None"

			src.e_color = H.bioHolder.mobAppearance.e_color

			return

		update_menu()
			set background = 1
			if(!usercl)
				qdel(src)
				return
			var/mob/user = usercl.mob
			src.update_preview_icon()
			user << browse_rsc(preview_icon, "polymorphicon.png")

			var/dat = "<html><body><title>GeneTek Appearance Modifier</title>"

			dat += "<table><tr><td>"
			dat += "<b>Appearance:</b><br>"
			dat += "<a href='byond://?src=\ref[src];s_tone=input'><b>Skin Tone:</b></a> [-src.s_tone + 35]/220<br>"
			dat += "<a href='byond://?src=\ref[src];eyes=input'><b>Eye Color:</b> <font face=\"fixedsys\" size=\"3\" color=\"[src.e_color]\"><b>#</b></font></a><br>"

			dat += "<a href='byond://?src=\ref[src];customization_first=input'><b>Bottom Detail:</b></a> [src.customization_first] "
			dat += "<a href='byond://?src=\ref[src];hair=input'><font face=\"fixedsys\" size=\"3\" color=\"[src.customization_first_color]\"><b>#</b></font></a><br>"

			dat += "<a href='byond://?src=\ref[src];customization_second=input'><b>Mid Detail:</b></a> [src.customization_second] "
			dat += "<a href='byond://?src=\ref[src];facial=input'><font face=\"fixedsys\" size=\"3\" color=\"[src.customization_second_color]\"><b>#</b></font></a><br>"

			dat += "<a href='byond://?src=\ref[src];customization_third=input'><b>Top Detail:</b></a> [src.customization_third] "
			dat += "<a href='byond://?src=\ref[src];detail=input'><font face=\"fixedsys\" size=\"3\" color=\"[src.customization_third_color]\"><b>#</b></font></a><br>"

			dat += "</td><td>"
			dat += "<center><b>Preview</b>:<br>"
			dat += "<img src=polymorphicon.png height=64 width=64></center>"
			dat += "</td></tr></table>"
			dat += "<hr>"

			dat += "<a href='byond://?src=\ref[src];apply=1'>Apply</a><br>"
			dat += "</body></html>"

			user << browse(dat, "window=geneticsappearance;size=300x250;can_resize=0;can_minimize=0")
			onclose(user, "geneticsappearance", src)
			return

		copy_to_target()
			if(!target_mob)
				return

			target_mob.bioHolder.mobAppearance.e_color = e_color
			target_mob.bioHolder.mobAppearance.customization_first_color = customization_first_color
			target_mob.bioHolder.mobAppearance.customization_second_color = customization_second_color
			target_mob.bioHolder.mobAppearance.customization_third_color = customization_third_color

			target_mob.bioHolder.mobAppearance.s_tone = s_tone

			target_mob.bioHolder.mobAppearance.customization_first = customization_first
			target_mob.bioHolder.mobAppearance.customization_second = customization_second
			target_mob.bioHolder.mobAppearance.customization_third = customization_third

			target_mob.cust_one_state = customization_styles[customization_first]
			if(!target_mob.cust_one_state)
				target_mob.cust_one_state = customization_styles_gimmick[customization_first]
				if(!target_mob.cust_one_state)
					target_mob.cust_one_state = "None"

			target_mob.cust_two_state = customization_styles[customization_second]
			if(!target_mob.cust_two_state)
				target_mob.cust_two_state = customization_styles_gimmick[customization_second]
				if(!target_mob.cust_two_state)
					target_mob.cust_two_state = "None"

			target_mob.cust_three_state = customization_styles[customization_third]
			if(!target_mob.cust_three_state)
				target_mob.cust_three_state = customization_styles_gimmick[customization_third]
				if(!target_mob.cust_three_state)
					target_mob.cust_three_state = "None"

			target_mob.set_face_icon_dirty()
			target_mob.set_body_icon_dirty()

		process()
			set background = 1
			if(!usercl || !target_mob)
				qdel(src)
				return
			spawn(20)
				src.process()
			return

		update_preview_icon()
			set background = 1
			qdel(src.preview_icon)

			var/customization_first_r = null
			var/customization_second_r = null
			var/customization_third_r = null

			var/gender = ""
			if(target_mob.gender == "male") gender = "m"
			else gender = "f"

			src.preview_icon = new /icon('icons/mob/human.dmi', "body_[gender]")

			if (src.s_tone >= 0)
				src.preview_icon.Blend(rgb(src.s_tone, src.s_tone, src.s_tone), ICON_ADD)
			else
				src.preview_icon.Blend(rgb(-src.s_tone,  -src.s_tone,  -src.s_tone), ICON_SUBTRACT)

			var/icon/eyes_s = new/icon("icon" = 'icons/mob/human_hair.dmi', "icon_state" = "eyes")

			customization_first_r = customization_styles[customization_first]
			if(!customization_first_r)
				customization_first_r = customization_styles_gimmick[customization_first]
				if(!customization_first_r)
					customization_first_r = "None"

			customization_second_r = customization_styles[customization_second]
			if(!customization_second_r)
				customization_second_r = customization_styles_gimmick[customization_second]
				if(!customization_second_r)
					customization_second_r = "None"

			customization_third_r = customization_styles[customization_third]
			if(!customization_third_r)
				customization_third_r = customization_styles_gimmick[customization_third]
				if(!customization_third_r)
					customization_third_r = "None"

			var/icon/hair_s = new/icon("icon" = 'icons/mob/human_hair.dmi', "icon_state" = customization_first_r)
			hair_s.Blend(src.customization_first_color, ICON_MULTIPLY)
			eyes_s.Blend(hair_s, ICON_OVERLAY)
			qdel(hair_s)

			var/icon/facial_s = new/icon("icon" = 'icons/mob/human_hair.dmi', "icon_state" = customization_second_r)
			facial_s.Blend(src.customization_second_color, ICON_MULTIPLY)
			eyes_s.Blend(facial_s, ICON_OVERLAY)
			qdel(facial_s)

			var/icon/detail_s = new/icon("icon" = 'icons/mob/human_hair.dmi', "icon_state" = customization_third_r)
			detail_s.Blend(src.customization_third_color, ICON_MULTIPLY)
			eyes_s.Blend(detail_s, ICON_OVERLAY)
			qdel(detail_s)

			src.preview_icon.Blend(eyes_s, ICON_OVERLAY)
			qdel(eyes_s)
			return