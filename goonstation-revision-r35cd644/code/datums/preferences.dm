datum/preferences
	var/profile_name
	var/real_name
	var/gender = MALE
	var/age = 30
	var/pin = null
	var/blType = "A+"

	var/be_changeling = 0
	var/be_revhead = 0
	var/be_syndicate = 0
	var/be_wizard = 0
	var/be_traitor = 0
	var/be_vampire = 0
	var/be_spy = 0
	var/be_gangleader = 0
	var/be_wraith = 0
	var/be_blob = 0
	var/be_misc = 0

	var/be_random_name = 0
	var/be_random_look = 0
	var/random_blood = 0
	var/view_changelog = 1
	var/view_score = 1
	var/view_tickets = 1
	var/admin_music_volume = 50
	var/use_click_buffer = 0
	var/listen_ooc = 1
	var/listen_looc = 1
	var/default_wasd = 0 // do they want wasd on by default?
	var/use_azerty = 0 // do they have an AZERTY keyboard?

	var/job_favorite = null
	var/list/jobs_med_priority = list()
	var/list/jobs_low_priority = list()
	var/list/jobs_unwanted = list()

	var/datum/appearanceHolder/AH = new

	var/random = 0
	var/random2 = 0
	var/random3 = 0

	var/icon/preview_icon = null

	var/mentor = 0
	var/see_mentor_pms = 1 // do they wanna disable mentor pms?
	var/antispam = 0

	var/datum/traitPreferences/traitPreferences = new

	var/target_cursor = "Default"
	var/hud_style = "New"

	New()
		randomize_name()
		..()

	proc/randomize_name()
		real_name = random_name(src.gender)

	proc/randomizeLook() // im laze
		if (!AH)
			logTheThing("debug", usr ? usr : null, null, "a preference datum's appearence holder is null!")
			return
		randomize_look(AH, 0, 0, 0, 0, 0, 0) // keep gender/bloodtype/age/name/underwear/bioeffects
		if (prob(1))
			blType = "Zesty Ranch"

		update_preview_icon()

	proc/sanitize_name()
		var/list/bad_characters = list("_", "'", "\"", "<", ">", ";", "\[", "\]", "{", "}", "|", "\\", "/")
		for (var/c in bad_characters)
			real_name = dd_replacetext(real_name, c, "")
		var/list/namecheck = dd_text2list(trim(real_name), " ")
		if (namecheck.len < 2 || length(real_name) < 5)
			randomize_name()
			return
		for (var/i = 1, i <= namecheck.len, i++)
			namecheck[i] = capitalize(namecheck[i])
		real_name = dd_list2text(namecheck, " ")

	proc/update_preview_icon()
		//qdel(src.preview_icon)
		if (!AH)
			logTheThing("debug", usr ? usr : null, null, "a preference datum's appearence holder is null!")
			return

		src.preview_icon = null

		src.preview_icon = new /icon('icons/mob/human.dmi', "body_[src.gender == MALE ? "m" : "f"]")

		// Skin tone
		if (AH.s_tone >= 0)
			src.preview_icon.Blend(rgb(AH.s_tone, AH.s_tone, AH.s_tone), ICON_ADD)
		else
			src.preview_icon.Blend(rgb(-AH.s_tone,  -AH.s_tone,  -AH.s_tone), ICON_SUBTRACT)


		var/icon/eyes_s = new/icon("icon" = 'icons/mob/human_hair.dmi', "icon_state" = "eyes")
		if (is_valid_color_string(AH.e_color))
			eyes_s.Blend(AH.e_color, ICON_MULTIPLY)
		else
			eyes_s.Blend("#101010", ICON_MULTIPLY)

		var/customization_first_r = customization_styles[AH.customization_first]
		if (!customization_first_r)
			customization_first_r = "None"

		var/customization_second_r = customization_styles[AH.customization_second]
		if (!customization_second_r)
			customization_second_r = "None"

		var/customization_third_r = customization_styles[AH.customization_third]
		if (!customization_third_r)
			customization_third_r = "none"

		var/icon/hair_s = new/icon("icon" = 'icons/mob/human_hair.dmi', "icon_state" = customization_first_r)
		if (is_valid_color_string(AH.customization_first_color))
			hair_s.Blend(AH.customization_first_color, ICON_MULTIPLY)
		else
			hair_s.Blend("#101010", ICON_MULTIPLY)

		var/icon/facial_s = new/icon("icon" = 'icons/mob/human_hair.dmi', "icon_state" = customization_second_r)
		if (is_valid_color_string(AH.customization_second_color))
			facial_s.Blend(AH.customization_second_color, ICON_MULTIPLY)
		else
			facial_s.Blend("#101010", ICON_MULTIPLY)

		var/icon/detail_s = new/icon("icon" = 'icons/mob/human_hair.dmi', "icon_state" = customization_third_r)
		if (is_valid_color_string(AH.customization_third_color))
			detail_s.Blend(AH.customization_third_color, ICON_MULTIPLY)
		else
			detail_s.Blend("#101010", ICON_MULTIPLY)

		var/underwear_style = underwear_styles[AH.underwear]
		var/icon/underwear_s = new/icon("icon" = 'icons/mob/human_underwear.dmi', "icon_state" = "[underwear_style]")
		if (is_valid_color_string(AH.u_color))
			underwear_s.Blend(AH.u_color, ICON_MULTIPLY)

		eyes_s.Blend(hair_s, ICON_OVERLAY)
		eyes_s.Blend(facial_s, ICON_OVERLAY)
		eyes_s.Blend(detail_s, ICON_OVERLAY)
		eyes_s.Blend(underwear_s, ICON_OVERLAY)

		src.preview_icon.Blend(eyes_s, ICON_OVERLAY)

		facial_s = null
		hair_s = null
		underwear_s = null
		eyes_s = null

	proc/ShowChoices(mob/user)
		sanitize_null_values()
		update_preview_icon()
		user << browse_rsc(preview_icon, "previewicon.png")
		user << browse_rsc(icon(cursors_selection[target_cursor]), "tcursor.png")
		user << browse_rsc(icon(hud_style_selection[hud_style], "preview"), "hud_preview.png")

		var/dat = "<html><head><meta http-equiv=\"X-UA-Compatible\" content=\"IE=8\"/></head><body><title>Character Setup</title>"

		dat += "<b>Profile Name:</b> "
		dat += "<a href=\"byond://?src=\ref[user];preferences=1;profile_name=input\"><b>[src.profile_name ? src.profile_name : "Unnamed"]</b></a> "

		dat += "<hr><b>Character Name:</b> "
		dat += "<a href=\"byond://?src=\ref[user];preferences=1;real_name=input\"><b>[src.real_name]</b></a> "

		dat += "<br><b>Random name? </b>"
		dat += "(&reg; = <a href=\"byond://?src=\ref[user];preferences=1;b_random_name=1\">[src.be_random_name ? "Yes" : "No"]</a>)"
		dat += "<br>"

		dat += "<b>Random appearance? </b>"
		dat += "(&reg; = <a href=\"byond://?src=\ref[user];preferences=1;b_random_look=1\">[src.be_random_look ? "Yes" : "No"]</a>)"
		dat += "<br>"

		dat += "<b>Gender:</b> <a href=\"byond://?src=\ref[user];preferences=1;gender=input\"><b>[src.gender == MALE ? "Male" : "Female"]</b></a><br>"
		dat += "<b>Age:</b> <a href='byond://?src=\ref[user];preferences=1;age=input'>[src.age]</a><br>"
		dat += "<b>Blood Type:</b> <a href='byond://?src=\ref[user];preferences=1;blType=input'>[src.random_blood ? "Random" : src.blType]</a><br>"
		dat += "<b>Bank PIN:</b> <a href='byond://?src=\ref[user];preferences=1;pin=input'>[src.pin ? src.pin : "Random"]</a> (<a href=\"byond://?src=\ref[user];preferences=1;random_pin=1\">&reg;</a>)<br>"

		var/favoriteJob = find_job_in_controller_by_string(src.job_favorite)
		dat += "<b><a href=\"byond://?src=\ref[user];preferences=1;jobswindow=1\">Occupation Choices</a>[ favoriteJob ? " (Fav: [favoriteJob])" : "" ]</b><br>"
		dat += "<b><a href=\"byond://?src=\ref[user];preferences=1;traitswindow=1\">Trait Choices</a></b>"

		dat += "<hr>"
		dat += "<table><tr><td>"
		dat += "<b>Appearance:</b><br>"

		if (AH)
			dat += "<a href='byond://?src=\ref[user];preferences=1;s_tone=input'><b>Skin Tone:</b></a> [-AH.s_tone + 35]/220<br>"

			dat += "<a href='byond://?src=\ref[user];preferences=1;underwear=input'><b>Underwear:</b></a> [AH.underwear] "
			dat += "<a href='byond://?src=\ref[user];preferences=1;underwear_color=input'><font face=\"fixedsys\" size=\"3\" color=\"[AH.u_color]\"><b>#</b></font></a><br>"

			dat += "<a href='byond://?src=\ref[user];preferences=1;eyes=input'><b>Eye Color:</b> <font face=\"fixedsys\" size=\"3\" color=\"[AH.e_color]\"><b>#</b></font></a><br>"

			dat += "<a href='byond://?src=\ref[user];preferences=1;customization_first=input'><b>Bottom Detail:</b></a> [AH.customization_first] "
			dat += "<a href='byond://?src=\ref[user];preferences=1;hair=input'><font face=\"fixedsys\" size=\"3\" color=\"[AH.customization_first_color]\"><b>#</b></font></a><br>"

			dat += "<a href='byond://?src=\ref[user];preferences=1;customization_second=input'><b>Mid Detail:</b></a> [AH.customization_second] "
			dat += "<a href='byond://?src=\ref[user];preferences=1;facial=input'><font face=\"fixedsys\" size=\"3\" color=\"[AH.customization_second_color]\"><b>#</b></font></a><br>"

			dat += "<a href='byond://?src=\ref[user];preferences=1;customization_third=input'><b>Top Detail:</b></a> [AH.customization_third] "
			dat += "<a href='byond://?src=\ref[user];preferences=1;detail=input'><font face=\"fixedsys\" size=\"3\" color=\"[AH.customization_third_color]\"><b>#</b></font></a><br>"

			dat += "</td><td>"
			dat += "<center><b>Preview</b>:<br>"
			dat += "<img style=\"-ms-interpolation-mode:nearest-neighbor;\" src=previewicon.png height=64 width=64></center>"

		else
			dat += "<span color=red>ERROR:<br>PREFERENCE APPEARENCE HOLDER IS NULL<br>Please alert a coder!</span>"

		dat += "</td></tr></table>"

		dat += "<hr>"

		if ((user && ismob(user)) && user.client && user.client.mentor_authed) // undefined variable /client/var/client
			dat += "<b>Display Mentorhelps?</b> <a href=\"byond://?src=\ref[user];preferences=1;toggle_mentorhelp=1\">[(src.see_mentor_pms ? "Yes" : "No")]</a></b><br>"

		dat += "<b>HUD style: <a href =\"byond://?src=\ref[user];preferences=1;hud_style=1\"><img style=\"-ms-interpolation-mode:nearest-neighbor;\" src=hud_preview.png></a></b> | "
		dat += "<b>Targeting cursor: <a href =\"byond://?src=\ref[user];preferences=1;tcursor=1\"><img style=\"-ms-interpolation-mode:nearest-neighbor;\" src=tcursor.png></a></b><br>"
		dat += "<b>Display OOC chat?</b> <a href=\"byond://?src=\ref[user];preferences=1;listen_ooc=1\">[(src.listen_ooc ? "Yes" : "No")]</a></b><br>"
		dat += "<b>Display LOOC chat?</b> <a href=\"byond://?src=\ref[user];preferences=1;listen_looc=1\">[(src.listen_looc ? "Yes" : "No")]</a></b><br>"
		dat += "<b>View Changelog Automatically?: <a href =\"byond://?src=\ref[user];preferences=1;changelog=1\">[(src.view_changelog ? "Yes" : "No")]</a></b><br>"
		dat += "<b>View Score Info Automatically?: <a href =\"byond://?src=\ref[user];preferences=1;scores=1\">[(src.view_score ? "Yes" : "No")]</a></b><br>"
		dat += "<b>View Tickets/Fines Automatically?: <a href =\"byond://?src=\ref[user];preferences=1;tickets=1\">[(src.view_tickets ? "Yes" : "No")]</a></b><br>"
		dat += "<b>Use Click Buffer?: <a href =\"byond://?src=\ref[user];preferences=1;clickbuffer=1\">[(src.use_click_buffer ? "Yes" : "No")]</a></b><br>"
		dat += "<b>Admin Music Volume: <a href =\"byond://?src=\ref[user];preferences=1;volume=1\">[src.admin_music_volume]</a></b><br>"
		dat += "<b>Default to WASD Mode?: <a href =\"byond://?src=\ref[user];preferences=1;default_wasd=1\">[(src.default_wasd ? "Yes" : "No")]</a></b><br>"
		dat += "<b>Use AZERTY Layout?: <a href =\"byond://?src=\ref[user];preferences=1;use_azerty=1\">[(src.use_azerty ? "Yes" : "No")]</a></b><br>"

		dat += "<hr>"
		if (!IsGuestKey(user.key))
			dat += "<b>Save Profile:</b>"
			for (var/i=1, i <= SAVEFILE_PROFILES_MAX, i++)
				dat += " <a href='byond://?src=\ref[user];preferences=1;save=[i]'>[i]</a>"
			dat += "<br>"
			dat += "<b>Load Profile:</b>"
			for (var/i=1, i <= SAVEFILE_PROFILES_MAX, i++)
				dat += " <a href='byond://?src=\ref[user];preferences=1;load=[i]'>[savefile_get_profile_name(user, i) || i]</a>"
			dat += "<br>"
		dat += "<a href='byond://?src=\ref[user];preferences=1;reset_all=1'><b>Reset</b></a> - "
		dat += "<a href='byond://?src=\ref[user];preferences=1;real_name=random'><b>Randomize</b></A><br>"
		dat += "</body></html>"

		traitPreferences.updateTraits(user)

		user << browse(dat,"window=preferences;size=333x615")

	proc/ResetAllPrefsToMed(mob/user)
		src.job_favorite = null
		src.jobs_med_priority = list()
		src.jobs_low_priority = list()
		src.jobs_unwanted = list()
		for (var/datum/job/J in job_controls.staple_jobs)
			if (istype(J, /datum/job/daily))
				continue
			if (jobban_isbanned(user,J.name) || (J.requires_whitelist && !NT.Find(ckey(user.mind.key))))
				src.jobs_unwanted += J.name
				continue
			src.jobs_med_priority += J.name
		return

	proc/ResetAllPrefsToLow(mob/user)
		src.job_favorite = null
		src.jobs_med_priority = list()
		src.jobs_low_priority = list()
		src.jobs_unwanted = list()
		for (var/datum/job/J in job_controls.staple_jobs)
			if (istype(J, /datum/job/daily))
				continue
			if (jobban_isbanned(user,J.name) || (J.requires_whitelist && !NT.Find(ckey(user.mind.key))))
				src.jobs_unwanted += J.name
				continue
			src.jobs_low_priority += J.name
		return

	proc/ResetAllPrefsToUnwanted(mob/user)
		src.job_favorite = null
		src.jobs_med_priority = list()
		src.jobs_low_priority = list()
		src.jobs_unwanted = list()
		for (var/datum/job/J in job_controls.staple_jobs)
			if (istype(J, /datum/job/daily))
				continue
			if (J.cant_allocate_unwanted)
				src.jobs_low_priority += J.name
			else
				src.jobs_unwanted += J.name
		return

	proc/SetChoices(mob/user)
		if (isnull(src.jobs_med_priority) || isnull(src.jobs_low_priority) || isnull(src.jobs_unwanted))
			src.ResetAllPrefsToLow(user)
			boutput(user, "<span style=\"color:red\"><b>Your Job Preferences were null, and have been reset.</b></span>")
		else if (isnull(src.job_favorite) && !src.jobs_med_priority.len && !src.jobs_low_priority.len && !src.jobs_unwanted.len)
			src.ResetAllPrefsToLow(user)
			boutput(user, "<span style=\"color:red\"><b>Your Job Preferences were empty, and have been reset.</b></span>")

		var/HTML = "<body><title>Job Preferences</title>"

		HTML += "<b>Favorite Job:</b>"
		if (!src.job_favorite)
			HTML += " None"
		else
			var/datum/job/J_Fav = find_job_in_controller_by_string(src.job_favorite)
			if (!J_Fav)
				HTML += " Favorite Job not found!"
			else if (jobban_isbanned(user,J_Fav.name) || (J_Fav.requires_whitelist && !NT.Find(ckey(user.mind.key))))
				boutput(user, "<span style=\"color:red\"><b>You are no longer allowed to play [J_Fav.name]. It has been removed from your Favorite slot.</span>")
				src.jobs_unwanted += J_Fav.name
				src.job_favorite = null
			else
				HTML += " <a href=\"byond://?src=\ref[user];preferences=1;occ=1;job=[J_Fav.name];level=0\"><font color=[J_Fav.linkcolor]>[J_Fav.name]</font></a>"
		HTML += " <a href=\"byond://?src=\ref[user];preferences=1;help=favjobs\"><small>(Help)</small></a><br>"

		HTML += "<table>"

		HTML += "<tr>"
		HTML += "<th><b>Medium Priority:</b> <a href=\"byond://?src=\ref[user];preferences=1;help=medjobs\"><small>(Help)</small></a></th>"
		HTML += "<th><b>Low Priority:</b> <a href=\"byond://?src=\ref[user];preferences=1;help=lowjobs\"><small>(Help)</small></a></th>"
		HTML += "<th><b>Unwanted Jobs:</b> <a href=\"byond://?src=\ref[user];preferences=1;help=unjobs\"><small>(Help)</small></a></th>"
		HTML += "</tr><tr>"

		var/category_counter = 0
		HTML += {"<td valign="top"><center>"}
		for (var/J in src.jobs_med_priority)
			var/datum/job/J_Med = find_job_in_controller_by_string(J)
			if (!J_Med) continue
			if (jobban_isbanned(user,J_Med.name))
				boutput(user, "<span style=\"color:red\"><b>You are no longer allowed to play [J_Med.name]. It has been removed from your Medium Priority List.</span>")
				src.jobs_med_priority -= J_Med.name
				src.jobs_unwanted += J_Med.name
			else
				HTML += "<a href=\"byond://?src=\ref[user];preferences=1;occ=2;job=[J_Med.name];level=1\">\<</a> "
				HTML += "<a href=\"byond://?src=\ref[user];preferences=1;occ=2;job=[J_Med.name];level=0\"><font color=[J_Med.linkcolor]>[J_Med.name]</font></a>"
				HTML += " <a href=\"byond://?src=\ref[user];preferences=1;occ=2;job=[J_Med.name];level=3\">\></a>"
				HTML += "<br>"
				category_counter++
		if (category_counter == 0)
			HTML += "No Jobs are in this category."
		HTML += "</center></td>"

		category_counter = 0
		HTML += {"<td valign="top"><center>"}
		for (var/J in src.jobs_low_priority)
			var/datum/job/J_Low = find_job_in_controller_by_string(J)
			if (!J_Low) continue
			if (J_Low.requires_whitelist && !NT.Find(ckey(user.mind.key))) continue
			if (jobban_isbanned(user,J_Low.name))
				boutput(user, "<span style=\"color:red\"><b>You are no longer allowed to play [J_Low.name]. It has been removed from your Low Priority List.</span>")
				src.jobs_low_priority -= J_Low.name
				src.jobs_unwanted += J_Low.name
			else
				HTML += "<a href=\"byond://?src=\ref[user];preferences=1;occ=3;job=[J_Low.name];level=2\">\<</a> "
				HTML += "<a href=\"byond://?src=\ref[user];preferences=1;occ=3;job=[J_Low.name];level=0\"><font color=[J_Low.linkcolor]>[J_Low.name]</font></a>"
				HTML += " <a href=\"byond://?src=\ref[user];preferences=1;occ=3;job=[J_Low.name];level=4\">\></a>"
				HTML += "<br>"
				category_counter++
		if (category_counter == 0)
			HTML += "No Jobs are in this category."
		HTML += "</center></td>"

		category_counter = 0
		HTML += {"<td valign="top"><center>"}
		for (var/J in src.jobs_unwanted)
			var/datum/job/J_Un = find_job_in_controller_by_string(J)
			if (!J_Un) continue
			if (J_Un.requires_whitelist && !NT.Find(ckey(user.mind.key))) continue
			if (J_Un.cant_allocate_unwanted)
				boutput(user, "<span style=\"color:red\"><b>[J_Un.name] is not supposed to be in the Unwanted category. It has been moved to Low Priority.</b></span>")
				boutput(user, "<span style=\"color:red\"><b>You may need to refresh your job preferences page to correct the job count.</b></span>")
				src.jobs_unwanted -= J_Un.name
				src.jobs_low_priority += J_Un.name
			if (jobban_isbanned(user,J_Un.name))
				HTML += "<strike>[J_Un.name]</strike><br>"
				category_counter++
			else
				HTML += "<a href=\"byond://?src=\ref[user];preferences=1;occ=4;job=[J_Un.name];level=3\">\<</a> "
				HTML += "<a href=\"byond://?src=\ref[user];preferences=1;occ=4;job=[J_Un.name];level=0\"><font color=[J_Un.linkcolor]>[J_Un.name]</font></a>"
				HTML += "<br>"
				category_counter++
		if (category_counter == 0)
			HTML += "No Jobs are in this category."
		HTML += "</center></td>"

		HTML += "</tr></table>"

		HTML += "<br><b>Antagonist Roles:</b>"
		HTML += "<a href=\"byond://?src=\ref[user];preferences=1;help=antags\"><small>(Help)</small></a></a><br>"

		if (jobban_isbanned(user, "Syndicate"))
			HTML += "You are banned from playing antagonist roles.<br>"
			src.be_changeling = 0
			src.be_revhead = 0
			src.be_syndicate = 0
			src.be_wizard = 0
			src.be_traitor = 0
			src.be_vampire = 0
			src.be_spy = 0
			src.be_gangleader = 0
		else
			if (src.be_traitor) HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_traitor=1\"><font color=#00CC00>Traitor</font></a>"
			else HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_traitor=1\"><font color=#FF0000><strike>Traitor</strike></font></a>"

			HTML += " * "

			if (src.be_syndicate) HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_syndicate=1\"><font color=#00CC00>Syndicate Operative</font></a>"
			else HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_syndicate=1\"><font color=#FF0000><strike>Syndicate Operative</strike></font></a>"

			HTML += " * "
			/*
			if (src.be_spy) HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_spy=1\"><font color=#00CC00>Spy</font></a>"
			else HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_spy=1\"><font color=#FF0000><strike>Spy</strike></font></a>"

			HTML += " * "
			*/
			if (src.be_gangleader) HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_gangleader=1\"><font color=#00CC00>Gang Leader</font></a>"
			else HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_gangleader=1\"><font color=#FF0000><strike>Gang Leader</strike></font></a>"

			HTML += " * "

			/*
			if (src.be_revhead) HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_revhead=1\"><font color=#00CC00>Revolution Leader</font></a><br>"
			else HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_revhead=1\"><font color=#FF0000><strike>Revolution Leader</strike></font></a><br>"
			*/

			if (src.be_changeling) HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_changeling=1\"><font color=#00CC00>Changeling</font></a>"
			else HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_changeling=1\"><font color=#FF0000><strike>Changeling</strike></font></a>"

			HTML += "<br>"

			if (src.be_wizard) HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_wizard=1\"><font color=#00CC00>Wizard</font></a>"
			else HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_wizard=1\"><font color=#FF0000><strike>Wizard</strike></font></a>"

			HTML += " * "

			if (src.be_vampire) HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_vampire=1\"><font color=#00CC00>Vampire</font></a>"
			else HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_vampire=1\"><font color=#FF0000><strike>Vampire</strike></font></a>"

			HTML += " * "

			if (src.be_wraith) HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_wraith=1\"><font color=#00CC00>Wraith</font></a>"
			else HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_wraith=1\"><font color=#FF0000><strike>Wraith</strike></font></a>"

			HTML += " * "

			if (src.be_blob) HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_blob=1\"><font color=#00CC00>Blob</font></a>"
			else HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_blob=1\"><font color=#FF0000><strike>Blob</strike></font></a>"

			HTML += " * "

			if (src.be_misc) HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_misc=1\"><font color=#00CC00>Other Foes</font></a>"
			else HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_misc=1\"><font color=#FF0000><strike>Other Foes</strike></font></a>"

		HTML += "<hr>"
		HTML += {"<a href=\"byond://?src=\ref[user];preferences=1;help=jobs\"><b>Help</b></a> * "}
		HTML += {"<a href=\"byond://?src=\ref[user];preferences=1;jobswindow=1\"><b>Refresh</b></a> * "}
		HTML += {"<a href=\"byond://?src=\ref[user];preferences=1;resetalljobs=1\"><b>Reset All Jobs</b></a> * "}
		HTML += {"<a href=\"byond://?src=\ref[user];preferences=1;closejobswindow=1\"><b>Close Window</b></a>"}

		user << browse(null, "window=preferences")
		user << browse(HTML, "window=mob_occupation;size=550x400")
		return

	proc/SetJob(mob/user, occ=1, job="Captain",var/level = 0)
		if (src.antispam)
			return
		if (!find_job_in_controller_by_string(job,1))
			boutput(user, "<span style=\"color:red\"><b>The game could not find that job in the internal list of jobs.</b></span>")
			switch(occ)
				if (1) src.job_favorite = null
				if (2) src.jobs_med_priority -= job
				if (3) src.jobs_low_priority -= job
				if (4) src.jobs_unwanted -= job
			return
		if (job=="AI" && (!config.allow_ai))
			boutput(user, "<span style=\"color:red\"><b>Selecting the AI is not currently allowed.</b></span>")
			if (occ != 4)
				switch(occ)
					if (1) src.job_favorite = null
					if (2) src.jobs_med_priority -= job
					if (3) src.jobs_low_priority -= job
				src.jobs_unwanted += job
			return

		if (jobban_isbanned(user, job))
			boutput(user, "<span style=\"color:red\"><b>You are banned from this job and may not select it.</b></span>")
			if (occ != 4)
				switch(occ)
					if (1) src.job_favorite = null
					if (2) src.jobs_med_priority -= job
					if (3) src.jobs_low_priority -= job
				src.jobs_unwanted += job
			return

		src.antispam = 1

		var/picker = "Low Priority"
		if (level == 0)
			var/list/valid_actions = list("Favorite","Medium Priority","Low Priority","Unwanted")

			switch(occ)
				if (1) valid_actions -= "Favorite"
				if (2) valid_actions -= "Medium Priority"
				if (3) valid_actions -= "Low Priority"
				if (4) valid_actions -= "Unwanted"

			picker = input("Which bracket would you like to move this job to?","Job Preferences") as null|anything in valid_actions
			if (!picker)
				src.antispam = 0
				return
		else
			switch(level)
				if (1) picker = "Favorite"
				if (2) picker = "Medium Priority"
				if (3) picker = "Low Priority"
				if (4) picker = "Unwanted"
		var/datum/job/J = find_job_in_controller_by_string(job)
		if (J.cant_allocate_unwanted && picker == "Unwanted")
			boutput(user, "<span style=\"color:red\"><b>[job] cannot be set to Unwanted.</b></span>")
			src.antispam = 0
			return

		var/successful_move = 0

		switch(picker)
			if ("Favorite")
				if (src.job_favorite)
					src.jobs_med_priority += src.job_favorite
				src.job_favorite = job
				successful_move = 1
			if ("Medium Priority")
				src.jobs_med_priority += job
				if (occ == 1)
					src.job_favorite = null
				successful_move = 1
			if ("Low Priority")
				src.jobs_low_priority += job
				if (occ == 1)
					src.job_favorite = null
				successful_move = 1
			if ("Unwanted")
				src.jobs_unwanted += job
				if (occ == 1)
					src.job_favorite = null
				successful_move = 1

		if (successful_move)
			switch(occ)
				// i know, repetitive, but its the safest way i can think of right now
				if (2) src.jobs_med_priority -= job
				if (3) src.jobs_low_priority -= job
				if (4) src.jobs_unwanted -= job

		src.antispam = 0
		return 1

	proc/process_link(mob/user, list/link_tags)
		if (!user.client)
			return

		if (link_tags["help"])
			var/helptext = "<html><body><title>Jobs Help</title><b><u>Job Preferences Help:</u></b><br>"
			switch(link_tags["help"])
				if ("favjobs")
					helptext = {"The Favorite Job slot is for the one job you like the most - the game will always try to
					get you into this job first if it can.<br><br>
					During round setup, favorite jobs are always looked at first - the game will loop through every player
					who has not been currently granted a job and see if they have a favorite set. If they do, and there
					are still slots for that job open, they will be assigned their favorite. The list of players is
					randomized in order before this happens, to make sure the same players don't get priority every time.<br><br>
					You might not always get your favorite job, especially if it's a single-slot role like a Head, but
					don't be discouraged if you don't get it - it's just luck of the draw. You might get it next time."}
				if ("medjobs")
					helptext = {"Medium Priority Jobs are any jobs you would like to play that aren't your favorite. People with
					jobs in this category get priority over those who have the same job in their low priority bracket. It's best
					to put jobs here that you actively enjoy playing and wouldn't mind ending up with if you don't get your favorite."}
				if ("lowjobs")
					helptext = {"Low Priority Jobs are jobs that you don't mind doing. When the game is finding candidates for a job,
					it will try to fill it with Medium Priority players first, then Low Priority players if there are still free slots."}
				if ("unjobs")
					helptext = {"Unwanted Jobs are jobs that you absolutely don't want to have. Putting a job here will make sure you
					are never allocated this job at all. However, certain jobs can't be added to this category, such as Staff Assistant.
					This is because these jobs are flagged as low-end jobs that will only be given out once all the other job slots are
					taken up - so don't worry, as long as you have jobs in your Medium or Low brackets and the server doesn't have a
					large player count at the time, you most likely won't end up as an Assistant unless you have it as your favorite."}
				if ("jobs")
					helptext = {"This is the Job Preference panel. Hold your mouse over a job icon and a tooltip will appear telling you
					what job it corresponds to. Clicking on one of these icons will prompt you for which category you want to move it to.
					More information about how the categories work can be obtained by clicking on the help icon next to the category name.<br><br>
					If you don't see all the job icons here (or if you don't see any at all), try resetting your job preferences."}
				if ("antags")
					helptext = {"These are your preferences for antagonist roles. If you have any of these disabled, you will never be
					selected automatically by the game to play as one of these enemy types. Green is enabled, Red is disabled. Bear in
					mind that admins can still select you by hand to play enemy roles during a round. Generally if you don't want to go
					along with whatever the admin has in mind, just adminhelp it and say so. Most of us are cool about that kind of thing."}

			user << browse(helptext, "window=jobs_help;size=400x400")
			return

		if (link_tags["job"])
			src.SetJob(user, text2num(link_tags["occ"]), link_tags["job"], text2num(link_tags["level"]))
			src.SetChoices(user)
			return

		if (link_tags["jobswindow"])
			src.SetChoices(user)
			return

		if (link_tags["traitswindow"])
			traitPreferences.showTraits(user)
			return

		if (link_tags["closejobswindow"])
			user << browse(null, "window=mob_occupation")
			src.ShowChoices(user)
			return

		if (link_tags["resetalljobs"])
			var/resetwhat = input("Reset all jobs to which level?","Job Preferences") as null|anything in list("Medium Priority","Low Priority","Unwanted")
			switch(resetwhat)
				if ("Medium Priority")
					src.ResetAllPrefsToMed(user)
				if ("Low Priority")
					src.ResetAllPrefsToLow(user)
				if ("Unwanted")
					src.ResetAllPrefsToUnwanted(user)
				else
					return
			src.SetChoices(user)
			return

		if (link_tags["profile_name"])
			var/new_profile_name

			new_profile_name = input(user, "Please select a name:", "Character Generation")  as null|text

			var/list/bad_characters = list("_", "'", "\"", "<", ">", ";", "[", "]", "{", "}", "|", "\\", "/")
			for (var/c in bad_characters)
				new_profile_name = dd_replacetext(new_profile_name, c, "")

			new_profile_name = trim(new_profile_name)

			if (new_profile_name)
				if (length(new_profile_name) >= 26)
					new_profile_name = copytext(new_profile_name, 1, 26)
				src.profile_name = new_profile_name

		if (link_tags["real_name"])
			var/new_name

			switch(link_tags["real_name"])
				if ("input")
					new_name = input(user, "Please select a name:", "Character Generation")  as null|text
					var/list/bad_characters = list("_", "'", "\"", "<", ">", ";", "[", "]", "{", "}", "|", "\\", "/")
					for (var/c in bad_characters)
						new_name = dd_replacetext(new_name, c, "")

					new_name = trim(new_name)
					if (!new_name || (lowertext(new_name) in list("unknown", "floor", "wall", "r wall")))
						alert("That name is reserved for use by the game. Please select another.")
						return
					if (!usr.client.holder)
						var/list/namecheck = dd_text2list(trim(new_name), " ")
						if (namecheck.len < 2)
							alert("Your name must have at least a First and Last name, e.g. John Smith")
							return
						if (length(new_name) < 5)
							alert("Your name is too short. It must be at least 5 characters long.")
							return
						for (var/i = 1, i <= namecheck.len, i++)
							namecheck[i] = capitalize(namecheck[i])
						new_name = dd_list2text(namecheck, " ")

				if ("random")
					if (src.gender == MALE)
						new_name = capitalize(pick(first_names_male) + " " + capitalize(pick(last_names)))
					else
						new_name = capitalize(pick(first_names_female) + " " + capitalize(pick(last_names)))
					randomizeLook()
			if (new_name)
				if (length(new_name) >= 26)
					new_name = copytext(new_name, 1, 26)
				src.real_name = new_name

		if (link_tags["hud_style"])
			var/new_hud = input(user, "Please select HUD style:", "New") as null|anything in hud_style_selection

			if (new_hud)
				src.hud_style = new_hud

		if (link_tags["tcursor"])
			var/new_cursor = input(user, "Please select cursor:", "Cursor") as null|anything in cursors_selection

			if (new_cursor)
				src.target_cursor = new_cursor

		if (link_tags["age"])
			var/new_age = input(user, "Please select type in age: 20-80", "Character Generation")  as null|num

			if (new_age)
				src.age = max(min(round(text2num(new_age)), 80), 20)


		if (link_tags["pin"])
			var/new_pin = input(user, "Please select a PIN between 1000 and 9999", "Character Generation")  as null|num

			if (new_pin)
				src.pin = max(min(round(text2num(new_pin)), 9999), 1000)

		if (link_tags["blType"])
			var/blTypeNew = input(user, "Please select a blood type:", "Character Generation")  as null|anything in list("Random", "A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-")

			if (blTypeNew)
				if (blTypeNew == "Random")
					src.random_blood = 1
				else
					src.random_blood = 0
					blType = blTypeNew

		if (link_tags["hair"])
			var/new_hair = input(user, "Please select hair color.", "Character Generation") as null|color
			if (new_hair)
				AH.customization_first_color = new_hair

		if (link_tags["facial"])
			var/new_facial = input(user, "Please select detail 1 color.", "Character Generation") as null|color
			if (new_facial)
				AH.customization_second_color = new_facial

		if (link_tags["detail"])
			var/new_detail = input(user, "Please select detail 2 color.", "Character Generation") as null|color
			if (new_detail)
				AH.customization_third_color = new_detail

		if (link_tags["eyes"])
			var/new_eyes = input(user, "Please select eye color.", "Character Generation") as null|color
			if (new_eyes)
				AH.e_color = new_eyes

		if (link_tags["s_tone"])
			var/new_tone = input(user, "Please select skin tone level: 1-220 (1=albino, 35=caucasian, 150=black, 220='very' black)", "Character Generation")  as null|num

			if (new_tone)
				AH.s_tone = max(min(round(new_tone), 220), 1)
				AH.s_tone =  -AH.s_tone + 35

		if (link_tags["customization_first"])
			var/new_style = input(user, "Please select the hair style you want.", "Character Generation")  as null|anything in customization_styles

			if (new_style)
				AH.customization_first = new_style

		if (link_tags["customization_second"])
			var/new_style = input(user, "Please select the detail style you want.", "Character Generation")  as null|anything in customization_styles

			if (new_style)
				AH.customization_second = new_style

		if (link_tags["customization_third"])
			var/new_style = input(user, "Please select the detail style you want.", "Character Generation")  as null|anything in customization_styles

			if (new_style)
				AH.customization_third = new_style

		if (link_tags["underwear"])
			var/new_style = input(user, "Please select the underwear you want.", "Character Generation")  as null|anything in underwear_styles

			if (new_style)
				AH.underwear = new_style

		if (link_tags["underwear_color"])
			var/new_ucolor = input(user, "Please select underwear color.", "Character Generation") as null|color
			if (new_ucolor)
				AH.u_color = new_ucolor

		if (link_tags["gender"])
			if (src.gender == MALE)
				src.gender = FEMALE
				AH.gender = FEMALE
			else
				src.gender = MALE
				AH.gender = MALE

		if (link_tags["changelog"])
			src.view_changelog = !(src.view_changelog)

		if (link_tags["toggle_mentorhelp"])
			if (user && user.client && user.client.mentor_authed)
				src.see_mentor_pms = !(src.see_mentor_pms)
				user.client.set_mentorhelp_visibility(src.see_mentor_pms)

		if (link_tags["listen_ooc"])
			src.listen_ooc = !(src.listen_ooc)

		if (link_tags["listen_looc"])
			src.listen_looc = !(src.listen_looc)

		if (link_tags["volume"])
			src.admin_music_volume = input("Goes from 0 to 100.","Admin Music Volume", src.admin_music_volume) as num
			src.admin_music_volume = max(0,min(src.admin_music_volume,100))

		if (link_tags["clickbuffer"])
			src.use_click_buffer = !(src.use_click_buffer)

		if (link_tags["default_wasd"])
			src.default_wasd = !(src.default_wasd)

		if (link_tags["use_azerty"])
			src.use_azerty = !(src.use_azerty)
			if (user && user.client)
				user.client.use_azerty = src.use_azerty

		if (link_tags["scores"])
			src.view_score = !(src.view_score)

		if (link_tags["tickets"])
			src.view_tickets = !(src.view_tickets)

		if (link_tags["b_changeling"])
			src.be_changeling = !( src.be_changeling )
			src.SetChoices(user)
			return

		if (link_tags["b_revhead"])
			src.be_revhead = !( src.be_revhead )
			src.SetChoices(user)
			return

		if (link_tags["b_syndicate"])
			src.be_syndicate = !( src.be_syndicate )
			src.SetChoices(user)
			return

		if (link_tags["b_wizard"])
			src.be_wizard = !( src.be_wizard)
			src.SetChoices(user)
			return

		if (link_tags["b_traitor"])
			src.be_traitor = !( src.be_traitor)
			src.SetChoices(user)
			return

		if (link_tags["b_vampire"])
			src.be_vampire = !( src.be_vampire)
			src.SetChoices(user)
			return

		if (link_tags["b_spy"])
			src.be_spy = !( src.be_spy)
			src.SetChoices(user)
			return

		if (link_tags["b_gangleader"])
			src.be_gangleader = !( src.be_gangleader)
			src.SetChoices(user)
			return

		if (link_tags["b_wraith"])
			src.be_wraith = !( src.be_wraith)
			src.SetChoices(user)
			return

		if (link_tags["b_blob"])
			src.be_blob = !( src.be_blob)
			src.SetChoices(user)
			return

		if (link_tags["b_misc"])
			src.be_misc = !src.be_misc
			src.SetChoices(user)
			return

		if (link_tags["b_random_name"])
			if (!force_random_names)
				src.be_random_name = !src.be_random_name
			else
				src.be_random_name = 1

		if (link_tags["b_random_look"])
			if (!force_random_looks)
				src.be_random_look = !src.be_random_look
			else
				src.be_random_look = 1

		/* Wire: a little thing i'll finish up eventually
		if (link_tags["set_will"])
			var/new_will = input(user, "Write a Will that shall appear in the event of your death. (250 max)", "Character Generation")  as text
			var/list/bad_characters = list("_", "'", "\"", "<", ">", ";", "[", "]", "{", "}", "|", "\\", "/")
			for (var/c in bad_characters)
				new_will = dd_replacetext(new_will, c, "")

			if (new_will)
				if (length(new_will) > 250)
					new_will = copytext(new_will, 1, 251)
				src.will = new_will
		*/

		if (!IsGuestKey(user.key))
			if (link_tags["save"])
				src.savefile_save(user, (isnum(text2num(link_tags["save"])) ? text2num(link_tags["save"]) : 1))
				boutput(user, "<span style=\"color:blue\"><b>Character saved to Slot [text2num(link_tags["save"])].</b></span>")

			else if (link_tags["load"])
				if (!src.savefile_load(user, (isnum(text2num(link_tags["load"])) ? text2num(link_tags["load"]) : 1)))
					alert(user, "You do not have a savefile.")
				else if (!user.client.holder)
					sanitize_name()
					boutput(user, "<span style=\"color:blue\"><b>Character loaded from Slot [text2num(link_tags["load"])].</b></span>")
				else
					boutput(user, "<span style=\"color:blue\"><b>Character loaded from Slot [text2num(link_tags["load"])].</b></span>")

		if (link_tags["reset_all"])
			src.gender = MALE
			AH.gender = MALE
			randomize_name()

			AH.customization_first = "Trimmed"
			AH.customization_second = "None"
			AH.customization_third = "None"
			AH.underwear = "No Underwear"

			AH.customization_first_color = 0
			AH.customization_second_color = 0
			AH.customization_third_color = 0
			AH.e_color = 0
			AH.u_color = "#FFFFFF"

			AH.s_tone = 0

			age = 30
			pin = null
			src.ResetAllPrefsToLow(user)
			listen_ooc = 1
			view_changelog = 1
			view_score = 1
			view_tickets = 1
			admin_music_volume = 50
			use_click_buffer = 0
			be_changeling = 0
			be_revhead = 0
			be_syndicate = 0
			be_wizard = 0
			be_wraith = 0
			be_blob = 0
			be_misc = 0
			be_traitor = 0
			be_vampire = 0
			be_spy = 0
			be_gangleader = 0
			if (!force_random_names)
				be_random_name = 0
			else
				be_random_name = 1
			if (!force_random_looks)
				be_random_look = 0
			else
				be_random_look = 1
			blType = "A+"

		src.ShowChoices(user)

	proc/copy_to(mob/character,var/mob/user,ignore_randomizer = 0)
		sanitize_null_values()
		if (!ignore_randomizer)
			var/namebanned = jobban_isbanned(user, "Custom Names")
			if (be_random_name || namebanned)
				randomize_name()

			if (be_random_look || namebanned)
				randomizeLook()

			if (character.bioHolder)
				if (random_blood || namebanned)
					character.bioHolder.bloodType = random_blood_type()
				else
					character.bioHolder.bloodType = blType

		character.real_name = real_name

		//Wire: Not everything has a bioholder you morons
		if (character.bioHolder)
			character.bioHolder.age = age
			character.bioHolder.mobAppearance.CopyOther(AH)
			character.bioHolder.mobAppearance.gender = src.gender

		//Also I think stuff other than human mobs can call this proc jesus christ
		if (ishuman(character))
			var/mob/living/carbon/human/H = character
			H.pin = pin
			H.gender = src.gender

		if (traitPreferences.isValid() && character.traitHolder)
			for (var/T in traitPreferences.traits_selected)
				character.traitHolder.addTrait(T)

		character.update_face()
		character.update_body()

	proc/sanitize_null_values()
		if (!src.gender || !(src.gender == MALE || src.gender == FEMALE))
			src.gender = MALE
		if (!AH)
			AH = new
		if (AH.gender != src.gender)
			AH.gender = src.gender
		if (AH.customization_first_color == null)
			AH.customization_first_color = "#101010"
		if (AH.customization_first == null)
			AH.customization_first = "None"
		if (AH.customization_second_color == null)
			AH.customization_second_color = "#101010"
		if (AH.customization_second == null)
			AH.customization_second = "None"
		if (AH.customization_third_color == null)
			AH.customization_third_color = "#101010"
		if (AH.customization_third == null)
			AH.customization_third = "None"
		if (AH.e_color == null)
			AH.e_color = "#101010"
		if (AH.u_color == null)
			AH.u_color = "#FFFFFF"

/* ---------------------- RANDOMIZER PROC STUFF */

/proc/random_blood_type(var/weighted = 1)
	var/return_type
	// set a default one so that, if none of the weighted ones happen, they at least have SOME kind of blood type
	return_type = pick("O", "A", "B", "AB") + pick("+", "-")
	if (weighted)
		var/list/types_and_probs = list(\
		"O" = 40,\
		"A" = 30,\
		"B" = 15,\
		"AB" = 5)
		for (var/i in types_and_probs)
			if (prob(types_and_probs[i]))
				return_type = i
				if (prob(80))
					return_type += "+"
				else
					return_type += "-"

	if (prob(1))
		return_type = "Zesty Ranch"

	return return_type

/proc/random_saturated_hex_color(var/pound = 0)
	var/R
	var/G
	var/B
	var/return_RGB

	var/colorpick = rand(1,3)

	switch (colorpick)
		if (1)
			R = "FF"
			G = random_hex(2)
			B = random_hex(2)
		if (2)
			R = random_hex(2)
			G = "FF"
			B = random_hex(2)
		if (3)
			R = random_hex(2)
			G = random_hex(2)
			B = "FF"

	return_RGB = (pound ? "#" : null) + R + G + B
	return return_RGB

/proc/randomize_hair_color(var/hcolor)
	if (!hcolor)
		return
	var/adj = 0
	if (copytext(hcolor, 1, 2) == "#")
		adj = 1
	DEBUG("HAIR initial: [hcolor]")
	var/hR_adj = num2hex(hex2num(copytext(hcolor, 1 + adj, 3 + adj)) + rand(-25,25))
	DEBUG("HAIR R: [hR_adj]")
	var/hG_adj = num2hex(hex2num(copytext(hcolor, 3 + adj, 5 + adj)) + rand(-5,5))
	DEBUG("HAIR G: [hG_adj]")
	var/hB_adj = num2hex(hex2num(copytext(hcolor, 5 + adj, 7 + adj)) + rand(-10,10))
	DEBUG("HAIR B: [hB_adj]")
	var/return_color = "#" + hR_adj + hG_adj + hB_adj
	DEBUG("HAIR final: [return_color]")
	return return_color

/proc/randomize_eye_color(var/ecolor)
	if (!ecolor)
		return
	var/adj = 0
	if (copytext(ecolor, 1, 2) == "#")
		adj = 1
	DEBUG("EYE initial: [ecolor]")
	var/eR_adj = num2hex(hex2num(copytext(ecolor, 1 + adj, 3 + adj)) + rand(-10,10))
	DEBUG("EYE R: [eR_adj]")
	var/eG_adj = num2hex(hex2num(copytext(ecolor, 3 + adj, 5 + adj)) + rand(-10,10))
	DEBUG("EYE G: [eG_adj]")
	var/eB_adj = num2hex(hex2num(copytext(ecolor, 5 + adj, 7 + adj)) + rand(-10,10))
	DEBUG("EYE B: [eB_adj]")
	var/return_color = "#" + eR_adj + eG_adj + eB_adj
	DEBUG("EYE final: [return_color]")
	return return_color

var/global/list/feminine_hstyles = list("Mohawk" = "mohawk",\
	"Pompadour" = "pomp",\
	"Ponytail" = "ponytail",\
	"Mullet" = "long",\
	"Emo" = "emo",\
	"Bun" = "bun",\
	"Bieber" = "bieb",\
	"Parted Hair" = "part",\
	"Draped" = "shoulders",\
	"Bedhead" = "bedhead",\
	"Afro" = "afro",\
	"Long Braid" = "longbraid",\
	"Very Long" = "vlong",\
	"Hairmetal" = "80s",\
	"Glammetal" = "glammetal",\
	"Fabio" = "fabio",\
	"Right Half-Shaved" = "halfshavedL",\
	"Left Half-Shaved" = "halfshavedR",\
	"High Ponytail" = "spud",\
	"Low Ponytail" = "band",\
	"Indian" = "indian",\
	"Shoulder Drape" = "pulledf",\
	"Punky Flip" = "shortflip",\
	"Pigtails" = "pig",\
	"Low Pigtails" = "lowpig",\
	"Mid-Back Length" = "midb",\
	"Shoulder Length" = "shoulderl",\
	"Pulled Back" = "pulledb",\
	"Choppy Short" = "chop_short",\
	"Long and Froofy" = "froofy_long",\
	"Wavy Ponytail" = "wavy_tail")

var/global/list/masculine_hstyles = list("None" = "None",\
	"Balding" = "balding",\
	"Tonsure" = "tonsure",\
	"Buzzcut" = "cut",\
	"Trimmed" = "short",\
	"Mohawk" = "mohawk",\
	"Flat Top" = "flattop",\
	"Pompadour" = "pomp",\
	"Ponytail" = "ponytail",\
	"Mullet" = "long",\
	"Emo" = "emo",\
	"Bieber" = "bieb",\
	"Persh Cut" = "bowl",\
	"Parted Hair" = "part",\
	"Einstein" = "einstein",\
	"Bedhead" = "bedhead",\
	"Dreadlocks" = "dreads",\
	"Afro" = "afro",\
	"Kingmetal" = "king-of-rock-and-roll",\
	"Scraggly" = "scraggly",\
	"Right Half-Shaved" = "halfshavedL",\
	"Left Half-Shaved" = "halfshavedR",\
	"High Flat Top" = "charioteers",\
	"Punky Flip" = "shortflip",\
	"Mid-Back Length" = "midb",\
	"Split-Tails" = "twotail",\
	"Choppy Short" = "chop_short")

var/global/list/facial_hair = list("None" = "none",\
	"Chaplin" = "chaplin",\
	"Selleck" = "selleck",\
	"Watson" = "watson",\
	"Old Nick" = "devil",\
	"Fu Manchu" = "fu",\
	"Twirly" = "villain",\
	"Dali" = "dali",\
	"Hogan" = "hogan",\
	"Van Dyke" = "vandyke",\
	"Hipster" = "hip",\
	"Robotnik" = "robo",\
	"Elvis" = "elvis",\
	"Goatee" = "gt",\
	"Chinstrap" = "chin",\
	"Neckbeard" = "neckbeard",\
	"Abe" = "abe",\
	"Full Beard" = "fullbeard",\
	"Braided Beard" = "braided",\
	"Puffy Beard" = "puffbeard",\
	"Long Beard" = "longbeard",\
	"Tramp" = "tramp",\
	"Eyebrows" = "eyebrows",\
	"Huge Eyebrows" = "thufir")

// this is weird but basically: a list of hairstyles and their appropriate detail styles, aka hair_details["80s"] would return the Hairmetal: Faded style
// further on in the randomize_look() proc we'll see if we've got one of the styles in here and if so, we have a chance to add the detailing
// if it's a list then we'll pick from the options in the list
var/global/list/hair_details = list("einstein" = "einalt",\
	"80s" = "80sfade",\
	"glammetal" = "glammetalO",\
	"pomp" = "pompS",\
	"mohawk" = list("mohawkFT", "mohawkFB", "mohawkS"),\
	"emo" = "emoH",\
	"clown" = list("clownT", "clownM", "clownB"),\
	"dreads" = "dreadsA",\
	"afro" = list("afroHR", "afroHL", "afroST", "afroSM", "afroSB", "afroSL", "afroSR", "afroSC", "afroCNE", "afroCNW", "afroCSE", "afroCSW", "afroSV", "afroSH"))

// all these icon state names are ridiculous
var/global/list/feminine_ustyles = list("No Underwear" = "none",\
	"Bra and Panties" = "brapan",\
	"Tanktop and Panties" = "tankpan",\
	"Bra and Boyshorts" = "braboy",\
	"Tanktop and Boyshorts" = "tankboy",\
	"Panties" = "panties",\
	"Boyshorts" = "boyshort")
var/global/list/masculine_ustyles = list("No Underwear" = "none",\
	"Briefs" = "briefs",\
	"Boxers" = "boxers",\
	"Boyshorts" = "boyshort")

/proc/randomize_look(var/to_randomize, var/change_gender = 1, var/change_blood = 1, var/change_age = 1, var/change_name = 1, var/change_underwear = 1, var/remove_effects = 1)
	if (!to_randomize)
		return

	var/mob/living/carbon/human/H
	var/datum/appearanceHolder/AH

	if (ishuman(to_randomize))
		H = to_randomize
		if (H.bioHolder && H.bioHolder.mobAppearance)
			AH = H.bioHolder.mobAppearance

	else if (istype(to_randomize, /datum/appearanceHolder))
		AH = to_randomize
		if (ishuman(AH.owner))
			H = AH.owner

	else
		return

	if (H && remove_effects)
		H.bioHolder.RemoveAllEffects()
		H.bioHolder.BuildEffectPool()

	if (change_gender)
		AH.gender = pick(MALE, FEMALE)
	if (H && change_name)
		if (AH.gender == FEMALE)
			H.real_name = pick(first_names_female)
		else
			H.real_name = pick(first_names_male)
		H.real_name += " [pick(last_names)]"

	var/list/hair_colors = list("#101010", "#924D28", "#61301B", "#E0721D", "#D7A83D",\
	"#D8C078", "#E3CC88", "#F2DA91", "#F21AE", "#664F3C", "#8C684A", "#EE2A22", "#B89778", "#3B3024", "#A56b46")
	var/hair_color
	if (prob(75))
		hair_color = randomize_hair_color(pick(hair_colors))
	else
		hair_color = randomize_hair_color(random_saturated_hex_color())

	AH.customization_first_color = hair_color
	AH.customization_second_color = hair_color
	AH.customization_third_color = hair_color

	AH.s_tone = rand(34,-184)
	if (AH.s_tone < -30)
		AH.s_tone = rand(34,-184)
	if (AH.s_tone < -50)
		AH.s_tone = rand(34,-184)
	if (H)
		if (H.limbs)
			H.limbs.reset_stone()

	var/list/eye_colors = list("#101010", "#613F1D", "#808000", "#3333CC")
	AH.e_color = randomize_eye_color(pick(eye_colors))

	var/has_second = 0
	if (AH.gender == MALE)
		if (prob(5)) // small chance to have a hairstyle more geared to the other gender
			AH.customization_first = pick(feminine_hstyles)
		else // otherwise just use one standard to the current gender
			AH.customization_first = pick(masculine_hstyles)

		if (prob(33)) // since we're a guy, a chance for facial hair
			AH.customization_second = pick(facial_hair)
			has_second = 1 // so the detail check doesn't do anything - we already got a secondary thing!!

	else // if FEMALE
		if (prob(8)) // same as above for guys, just reversed and with a slightly higher chance since it's ~more appropriate~ for ladies to have guy haircuts than vice versa  :I
			AH.customization_first = pick(masculine_hstyles)
		else // ss13 is coded with gender stereotypes IN ITS VERY CORE
			AH.customization_first = pick(feminine_hstyles)

	if (!has_second)
		var/hair_detail = hair_details[AH.customization_first] // check for detail styles for our chosen style

		if (hair_detail && prob(50)) // found something in the list
			AH.customization_second = hair_detail // default to being whatever we found

			if (islist(hair_detail)) // if we found a bunch of things in the list
				AH.customization_second = pick(hair_detail) // let's choose just one (we don't need to assign a list as someone's hair detail)

				if (prob(20)) // with a small chance for another detail thing
					AH.customization_third = pick(hair_detail)
					AH.customization_third_color = random_saturated_hex_color()
					if (prob(5))
						AH.customization_third_color = randomize_hair_color(pick(hair_colors))
				else
					AH.customization_third = "none"

			AH.customization_second_color = random_saturated_hex_color() // if you have a detail style you're likely to want a crazy color
			if (prob(15))
				AH.customization_second_color = randomize_hair_color(pick(hair_colors)) // but have a chance to be a normal hair color

		else if (prob(5)) // chance for a special eye color
			AH.customization_second = pick("hetcroL", "hetcroR")
			if (prob(75))
				AH.customization_second_color = random_saturated_hex_color()
			else
				AH.customization_second_color = randomize_eye_color(pick(eye_colors))
			AH.customization_third = "none"

		else // otherwise, nada
			AH.customization_second = "none"
			AH.customization_third = "none"

	if (change_underwear)
		if (AH.gender == MALE)
			if (prob(1))
				AH.underwear = pick(feminine_ustyles)
			else
				AH.underwear = pick(masculine_ustyles)
		else
			if (prob(5))
				AH.underwear = pick(masculine_ustyles)
			else
				AH.underwear = pick(feminine_ustyles)
		AH.u_color = random_saturated_hex_color()

	if (H && change_blood)
		H.bioHolder.bloodType = random_blood_type(1)

	if (H && change_age)
		H.bioHolder.age = rand(20,80)

	if (H && H.organHolder && H.organHolder.head && H.organHolder.head.donor_appearance) // aaaa
		H.organHolder.head.donor_appearance.CopyOther(AH)

	spawn(1)
		AH.UpdateMob()
		if (H)
			H.set_face_icon_dirty()
			H.set_body_icon_dirty()
