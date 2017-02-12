#define UI_OLD 0
#define UI_NEW 1

var/global/list/special_roles = list( //keep synced with the defines BE_* in setup.dm --rastaf
//some autodetection here.
	"traitor" = IS_MODE_COMPILED("traitor"),
	"operative" = IS_MODE_COMPILED("nuclear"),
	"changeling" = IS_MODE_COMPILED("changeling"),
	"wizard" = IS_MODE_COMPILED("wizard"),
	"malf AI" = IS_MODE_COMPILED("malfunction"),
	"revolutionary" = IS_MODE_COMPILED("revolution"),
	"alien candidate" = 1, //always show
	//"cultist" = IS_MODE_COMPILED("cult"),
	//"infested monkey" = IS_MODE_COMPILED("monkey"),
)
/*
var/global/list/special_roles = list( //keep synced with the defines BE_* in setup.dm --rastaf
//some autodetection here.
	"traitor" = ispath(text2path("/datum/game_mode/traitor")),
	"operative" = ispath(text2path("/datum/game_mode/nuclear")),
	"changeling" = ispath(text2path("/datum/game_mode/changeling")),
	"wizard" = ispath(text2path("/datum/game_mode/wizard")),
	"malf AI" = ispath(text2path("/datum/game_mode/malfunction")),
	"revolutionary" = ispath(text2path("/datum/game_mode/revolution")),
	"alien candidate" = 1, //always show
	"cultist" = ispath(text2path("/datum/game_mode/cult")),
	"infested monkey" = ispath(text2path("/datum/game_mode/monkey")),
)
*/

datum/preferences
	var/real_name
	var/gender = MALE
	var/sexuality = 0
	var/age = 30.0
	var/b_type = "A+"


	var/be_special //bitfields. See defines in setup.dm. --rastaf0
	var/midis = 1
	var/lastchangelog = 0 // size of last seen changelog file -- rastaf0
	var/ooccolor = "#b82e00"
	var/be_random_name = 0
	var/underwear = 1

	var/occupation[] = list("No Preference", "No Preference", "No Preference")
	var/datum/jobs/wanted_jobs = list()

	var/h_style = "Short Hair"
	var/f_style = "Shaved"

	var/r_hair = 0
	var/g_hair = 0
	var/b_hair = 0

	var/r_facial = 0
	var/g_facial = 0
	var/b_facial = 0

	var/s_tone = 0
	var/r_eyes = 0
	var/g_eyes = 0
	var/b_eyes = 0

	var/UI = UI_NEW // saving the whole .DMI in preferences is not a good idea. --rastaf0 //'screen1_old.dmi' // Skie

	var/icon/preview_icon = null

	New()
		randomize_name()
		..()

	//The mob should have a gender you want before running this proc.
	proc/randomize_appearance_for(var/mob/living/carbon/human/H)
		if(H.gender == MALE)
			gender = MALE
		else
			gender = FEMALE
		sexuality = rand(0,1)
		randomize_skin_tone()
		randomize_hair(gender)
		randomize_hair_color("hair")
		if(gender == MALE)//only for dudes.
			randomize_facial()
			randomize_hair_color("facial")
		randomize_eyes_color()
		underwear = pick(0,1)
		b_type = pick("A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-")
		age = rand(19,35)
		copy_to(H,1)

	proc/randomize_name()
		if (gender == MALE)
			real_name = capitalize(pick(first_names_male) + " " + capitalize(pick(last_names)))
		else
			real_name = capitalize(pick(first_names_female) + " " + capitalize(pick(last_names)))

	proc/randomize_hair(var/gender)
		//Women are more likely to have longer hair.
		var/temp = gender==FEMALE&&prob(80) ? pick(2,6,8) : rand(1,9)
		switch(temp)
			if(1)
				h_style = "Short Hair"
			if(2)
				h_style = "Long Hair"
			if(3)
				h_style = "Cut Hair"
			if(4)
				h_style = "Mohawk"
			if(5)
				h_style = "Balding"
			if(6)
				h_style = "Fag"
			if(7)
				h_style = "Bedhead"
			if(8)
				h_style = "Dreadlocks"
			else
				h_style = "bald"

	proc/randomize_facial()
		var/temp = prob(50) ? 14 : rand(1,13)//50% of not having a beard. Otherwise get a random one.
		switch(temp)
			if(1)
				f_style = "Watson"
			if(2)
				f_style = "Chaplin"
			if(3)
				f_style = "Selleck"
			if(4)
				f_style = "Neckbeard"
			if(5)
				f_style = "Full Beard"
			if(6)
				f_style = "Long Beard"
			if(7)
				f_style = "Van Dyke"
			if(8)
				f_style = "Elvis"
			if(9)
				f_style = "Abe"
			if(10)
				f_style = "Chinstrap"
			if(11)
				f_style = "Hipster"
			if(12)
				f_style = "Goatee"
			if(13)
				f_style = "Hogan"
			else
				f_style = "bald"

	proc/randomize_skin_tone()
		var/tone

		var/tmp = pickweight ( list ("caucasian" = 55, "afroamerican" = 15, "african" = 10, "latino" = 10, "albino" = 5, "weird" = 5))
		switch (tmp)
			if ("caucasian")
				tone = -45 + 35
			if ("afroamerican")
				tone = -150 + 35
			if ("african")
				tone = -200 + 35
			if ("latino")
				tone = -90 + 35
			if ("albino")
				tone = -1 + 35
			if ("weird")
				tone = -(rand (1, 220)) + 35

		s_tone = min(max(tone + rand (-25, 25), -185), 34)

	proc/randomize_hair_color(var/target = "hair")
		if (prob (75) && target == "facial") // Chance to inherit hair color
			r_facial = r_hair
			g_facial = g_hair
			b_facial = b_hair
			return

		var/red
		var/green
		var/blue

		var/col = pick ("blonde", "black", "chestnut", "copper", "brown", "wheat", "old", "punk")
		switch (col)
			if ("blonde")
				red = 255
				green = 255
				blue = 0
			if ("black")
				red = 0
				green = 0
				blue = 0
			if ("chestnut")
				red = 153
				green = 102
				blue = 51
			if ("copper")
				red = 255
				green = 153
				blue = 0
			if ("brown")
				red = 102
				green = 51
				blue = 0
			if ("wheat")
				red = 255
				green = 255
				blue = 153
			if ("old")
				red = rand (100, 255)
				green = red
				blue = red
			if ("punk")
				red = rand (0, 255)
				green = rand (0, 255)
				blue = rand (0, 255)

		red = max(min(red + rand (-25, 25), 255), 0)
		green = max(min(green + rand (-25, 25), 255), 0)
		blue = max(min(blue + rand (-25, 25), 255), 0)

		switch (target)
			if ("hair")
				r_hair = red
				g_hair = green
				b_hair = blue
			if ("facial")
				r_facial = red
				g_facial = green
				b_facial = blue

	proc/randomize_eyes_color()
		var/red
		var/green
		var/blue

		var/col = pick ("black", "grey", "brown", "chestnut", "blue", "lightblue", "green", "albino", "weird")
		switch (col)
			if ("black")
				red = 0
				green = 0
				blue = 0
			if ("grey")
				red = rand (100, 200)
				green = red
				blue = red
			if ("brown")
				red = 102
				green = 51
				blue = 0
			if ("chestnut")
				red = 153
				green = 102
				blue = 0
			if ("blue")
				red = 51
				green = 102
				blue = 204
			if ("lightblue")
				red = 102
				green = 204
				blue = 255
			if ("green")
				red = 0
				green = 102
				blue = 0
			if ("albino")
				red = rand (200, 255)
				green = rand (0, 150)
				blue = rand (0, 150)
			if ("weird")
				red = rand (0, 255)
				green = rand (0, 255)
				blue = rand (0, 255)

		red = max(min(red + rand (-25, 25), 255), 0)
		green = max(min(green + rand (-25, 25), 255), 0)
		blue = max(min(blue + rand (-25, 25), 255), 0)

		r_eyes = red
		g_eyes = green
		b_eyes = blue

	proc/update_preview_icon()
		del(preview_icon)

		var/g = "m"
		if (gender == MALE)
			g = "m"
		else if (gender == FEMALE)
			g = "f"

		preview_icon = new /icon('human.dmi', "body_[g]_s")

		// Skin tone
		if (s_tone >= 0)
			preview_icon.Blend(rgb(s_tone, s_tone, s_tone), ICON_ADD)
		else
			preview_icon.Blend(rgb(-s_tone,  -s_tone,  -s_tone), ICON_SUBTRACT)

		if (underwear > 0)
			preview_icon.Blend(new /icon('human.dmi', "underwear[underwear]_[g]_s"), ICON_OVERLAY)

		var/icon/eyes_s = new/icon("icon" = 'human_face.dmi', "icon_state" = "eyes_s")
		eyes_s.Blend(rgb(r_eyes, g_eyes, b_eyes), ICON_ADD)

		var/h_style_r = null
		switch(h_style)
			if("Short Hair")
				h_style_r = "hair_a"
			if("Long Hair")
				h_style_r = "hair_b"
			if("Cut Hair")
				h_style_r = "hair_c"
			if("Mohawk")
				h_style_r = "hair_d"
			if("Balding")
				h_style_r = "hair_e"
			if("Fag")
				h_style_r = "hair_f"
			if("Afro")
				h_style_r = "hair_afro"
			if("Bieber")
				h_style_r = "hair_bieber"
			if("Goku")
				h_style_r = "hair_bedhead"
			if("Dreadlocks")
				h_style_r = "hair_dreads"
			if("Rocker")
				h_style_r = "hair_rocker"
			if("Ponytail")
				h_style_r = "hair_pony"
			if("Super-long Hair")
				h_style_r = "hair_long"
			if("Scene Hair")
				h_style_r = "hair_scene"
			if("Short Female Hair")
				h_style_r = "hair_female_short"
			if("Girly Hair")
				h_style_r = "hair_girly"
			if("Messy Hair")
				h_style_r = "hair_femalemessy"
			if("Male Bedhead")
				h_style_r = "hair_messym"
			if("Female Bedhead")
				h_style_r = "hair_messyf"
			else
				h_style_r = "bald"

		var/f_style_r = null
		switch(f_style)
			if ("Watson")
				f_style_r = "facial_watson"
			if ("Chaplin")
				f_style_r = "facial_chaplin"
			if ("Selleck")
				f_style_r = "facial_selleck"
			if ("Neckbeard")
				f_style_r = "facial_neckbeard"
			if ("Full Beard")
				f_style_r = "facial_fullbeard"
			if ("Long Beard")
				f_style_r = "facial_longbeard"
			if ("Van Dyke")
				f_style_r = "facial_vandyke"
			if ("Elvis")
				f_style_r = "facial_elvis"
			if ("Abe")
				f_style_r = "facial_abe"
			if ("Chinstrap")
				f_style_r = "facial_chin"
			if ("Hipster")
				f_style_r = "facial_hip"
			if ("Goatee")
				f_style_r = "facial_gt"
			if ("Hogan")
				f_style_r = "facial_hogan"
			else
				f_style_r = "bald"

		var/icon/hair_s = new/icon("icon" = 'human_face.dmi', "icon_state" = "[h_style_r]_s")
		hair_s.Blend(rgb(r_hair, g_hair, b_hair), ICON_ADD)

		var/icon/facial_s = new/icon("icon" = 'human_face.dmi', "icon_state" = "[f_style_r]_s")
		facial_s.Blend(rgb(r_facial, g_facial, b_facial), ICON_ADD)

		var/icon/mouth_s = new/icon("icon" = 'human_face.dmi', "icon_state" = "mouth_[g]_s")

		eyes_s.Blend(hair_s, ICON_OVERLAY)
		eyes_s.Blend(mouth_s, ICON_OVERLAY)
		eyes_s.Blend(facial_s, ICON_OVERLAY)

		preview_icon.Blend(eyes_s, ICON_OVERLAY)

		del(mouth_s)
		del(facial_s)
		del(hair_s)
		del(eyes_s)

	proc/ShowChoices(mob/user)
		set src = usr
		update_preview_icon()
		user << browse_rsc(preview_icon, "previewicon.png")

		var/list/destructive = assistant_occupations.Copy()
		var/dat = "<html><body>"
		dat += "<head><link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><style type=\"text/css\">"
		dat += "body, table{font-family: Tahoma; font-size: 10pt;}"
		dat += "table {"
		dat += "border-width: 0px;"
		dat += "border-spacing: 0px;"
		dat += "border-style: none;"
		dat += "border-color: gray;"
		dat += "border-collapse: collapse;"
		dat += "margin-left: auto;"
		dat += "margin-right: auto;"
		dat += "}"
		dat += "table th {"
		dat += "border-width: 0px;"
		dat += "padding: 0px;"
		dat += "border-style: solid;"
		dat += "border-color: gray;"
		dat += "}"
		dat += "table td {"
		dat += "border-width: 0px;"
		dat += "padding: 0px;"
		dat += "border-style: solid;"
		dat += "border-color: gray;"
		dat += "}"
		dat += "</style></head>"
		dat += "<body>"
		dat += "<table border=\"0\" bordercolor=\"\" width=\"600\" bgcolor=\"\">"
		dat += "<tr>"
		dat += "<td style=\"padding: 8px; width: 500px;\">"
		dat += "<b>Name:</b> <a href=\"byond://?src=\ref[user];preferences=1;real_name=input\">[real_name]</a>"
		dat += " (<a href=\"byond://?src=\ref[user];preferences=1;real_name=random\">&reg;</A>) "
		dat += "(&reg; = <a href=\"byond://?src=\ref[user];preferences=1;b_random_name=1\">[be_random_name ? "Yes" : "No"]</a>)<br>"
		dat += "<b>Gender:</b> <a href=\"byond://?src=\ref[user];preferences=1;gender=input\">[gender == MALE ? "Male" : "Female"]</a><br>"
		dat += "<b>Sexuality:</b> <a href=\"byond://?src=\ref[user];preferences=1;sexuality=input\">[sexuality == 0 ? "Heterosexual" : "Homosexual"]</a><br>"
		dat += "<b>Age:</b> <a href='byond://?src=\ref[user];preferences=1;age=input'>[age]</a><br>"
		dat += "<b>UI Style:</b> <a href=\"byond://?src=\ref[user];preferences=1;UI=input\"><b>[UI == UI_NEW ? "New" : "Old"]</b></a><br><br>"
		dat += "<b>Body (<a href=\"byond://?src=\ref[user];preferences=1;s_tone=random;underwear=random;age=random;b_type=random;hair=random;h_style=random;facial=random;f_style=random;eyes=random\">&reg;</A>):</b><br>"
		dat += "<b>Blood Type:</b> <a href='byond://?src=\ref[user];preferences=1;b_type=input'>[b_type]</a><br>"
		dat += "<font face=\"fixedsys\" size=\"3\" color=\"#[num2hex(r_eyes, 2)][num2hex(g_eyes, 2)][num2hex(b_eyes, 2)]\"><table style='display:inline; margin-bottom: -3px;' bgcolor=\"#[num2hex(r_eyes, 2)][num2hex(g_eyes, 2)][num2hex(b_eyes)]\"><tr><td>__</td></tr></table></font>&nbsp;&nbsp;<b>Eye Color:</b> <a href='byond://?src=\ref[user];preferences=1;eyes=input'>change</a><br>"
		dat += "<font face=\"fixedsys\" size=\"3\" color=\"#[num2hex(r_hair, 2)][num2hex(g_hair, 2)][num2hex(b_hair, 2)]\"><table style='display:inline; margin-bottom: -3px;' bgcolor=\"#[num2hex(r_hair, 2)][num2hex(g_hair, 2)][num2hex(b_hair)]\"><tr><td>__</td></tr></table></font>&nbsp;&nbsp;<b>Head Hair:</b> <a href='byond://?src=\ref[user];preferences=1;h_style=input'>[h_style]</a> <a href='byond://?src=\ref[user];preferences=1;hair=input'>(change color)</a><br>"
		dat += "<font face=\"fixedsys\" size=\"3\" color=\"#[num2hex(r_facial, 2)][num2hex(g_facial, 2)][num2hex(b_facial, 2)]\"><table style='display:inline; margin-bottom: -3px;' bgcolor=\"#[num2hex(r_facial, 2)][num2hex(g_facial, 2)][num2hex(b_facial)]\"><tr><td>__</td></tr></table></font>&nbsp;&nbsp;<b>Facial Hair:</b> <a href='byond://?src=\ref[user];preferences=1;f_style=input'>[f_style]</a> <a href='byond://?src=\ref[user];preferences=1;facial=input'>(change color)</a>"
		dat += "<br><br>"
		dat += "<b>Skin Tone:</b> <a href='byond://?src=\ref[user];preferences=1;s_tone=input'>[-s_tone + 35]/220</a><br>"
		if (!IsGuestKey(user.key))
			dat += "<b>Underwear:</b> <a href =\"byond://?src=\ref[user];preferences=1;underwear=1\">[underwear == 1 ? "Yes" : "No"]</a><br>"
		dat += "<br><b>Occupation:</b><br>"
		if (destructive.Find(occupation[1]))
			dat += "\t<a href=\"byond://?src=\ref[user];preferences=1;occ=1\"><b>[occupation[1]]</b></a><br>"
		else
			if (jobban_isbanned(user, occupation[1]))
				occupation[1] = "Assistant"
			if (jobban_isbanned(user, occupation[2]))
				occupation[2] = "Assistant"
			if (jobban_isbanned(user, occupation[3]))
				occupation[3] = "Assistant"
			if (occupation[1] != "No Preference")
				dat += "\tFirst Choice: <a href=\"byond://?src=\ref[user];preferences=1;occ=1\"><b>[occupation[1]]</b></a><br>"

				if (destructive.Find(occupation[2]))
					dat += "\tSecond Choice: <a href=\"byond://?src=\ref[user];preferences=1;occ=2\"><b>[occupation[2]]</b></a><BR>"

				else
					if (occupation[2] != "No Preference")
						dat += "\tSecond Choice: <a href=\"byond://?src=\ref[user];preferences=1;occ=2\"><b>[occupation[2]]</b></a><BR>"
						dat += "\tLast Choice: <a href=\"byond://?src=\ref[user];preferences=1;occ=3\"><b>[occupation[3]]</b></a><BR>"

					else
						dat += "\tSecond Choice: <a href=\"byond://?src=\ref[user];preferences=1;occ=2\">No Preference</a><br>"
			else
				dat += "\t<a href=\"byond://?src=\ref[user];preferences=1;occ=1\">No Preference</a><br>"

		dat += "<br>"
		if (!IsGuestKey(user.key))
			dat += "<a href='byond://?src=\ref[user];preferences=1;load=1'>Load Setup</a><br>"
			dat += "<a href='byond://?src=\ref[user];preferences=1;save=1'>Save Setup</a><br>"

		dat += "<a href='byond://?src=\ref[user];preferences=1;reset_all=1'>Reset Setup</a><br>"
		if(user.client.holder)
			if(user.client.holder.rank)
				if(user.client.holder.rank == "Host" || user.client.holder.rank == "Robustmin" || user.client.holder.rank == "Badmin")
					dat += "<font face=\"fixedsys\" size=\"3\" color=\"[ooccolor]\"><table style='display:inline; margin-bottom: -3px;'  bgcolor=\"[ooccolor]\"><tr><td>__</td></tr></table></font>&nbsp;&nbsp;<b>OOC Color:</b> (<a href='byond://?src=\ref[user];preferences=1;ooccolor=input'>change</a>)"
		dat += "</td>"
		dat += "<td style=\"padding: 8px; width: 150px\">"
		dat += "<img src=\"previewicon.png\" height=\"64\" width=\"64\"><BR><BR>"
		if(!ticker || ticker.current_state <= GAME_STATE_PREGAME)
			for(var/mob/new_player/P in mobz)
				if(P.mind.key == user.key)
					if (!P.client || !P.ready)
						dat += "<a href='byond://?src=\ref[user];ready=1'>Declare Ready</A><BR>"
					else
						dat += "You are ready.<BR>"
		else
			dat += "<a href='byond://?src=\ref[user];late_join=1'>Join Game!</A><BR>"

		dat += "<a href='byond://?src=\ref[user];observe=1'>Observe</A><BR>"

		dat += "<a href=\"http://d2k5.com/pages/shop/?item=ss13-changeloadout\" target=\"_blank\">Change Loadout</a> (<a href=\"http://d2k5.com/threads/you-can-now-select-the-clothing-you-spawn-with.1026/\" target=\"_blank\">?</a>)<BR>"

		dat += "<br>"
		if(!jobban_isbanned(user, "Syndicate"))
			var/n = 0
			for (var/i in special_roles)
				if (special_roles[i]) //if mode is available on the server
					dat += "<b>Be [i]:</b> <a href=\"byond://?src=\ref[user];preferences=1;be_special=[n]\"><b>[src.be_special&(1<<n) ? "Yes" : "No"]</b></a><br>"
				n++
		else
			dat += "<b>You are banned from being syndicate.</b>"
			src.be_special = 0
		dat += "</td>"
		dat += "</tr>"
		dat += "<table>"
		dat += "</body>"

		dat += "</body></html>"

		user << browse(dat, "window=preferences;size=650x440;can_close=0")

	proc/SetChoices(mob/user, occ=1)
		var/HTML = "<html><body>"
		HTML += "<head><link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><style type=\"text/css\">"
		HTML += "body, table{font-family: Tahoma; font-size: 10pt;}"
		HTML += "table {"
		HTML += "border-width: 1px;"
		HTML += "border-spacing: 0px;"
		HTML += "border-style: none;"
		HTML += "border-color: gray;"
		HTML += "border-collapse: collapse;"
		HTML += "margin-left: auto;"
		HTML += "margin-right: auto;"
		HTML += "}"
		HTML += "table th {"
		HTML += "border-width: 1px;"
		HTML += "padding: 4px;"
		HTML += "border-style: solid;"
		HTML += "border-color: gray;"
		HTML += "}"
		HTML += "table td {"
		HTML += "border-width: 1px;"
		HTML += "padding: 4px;"
		HTML += "border-style: solid;"
		HTML += "border-color: gray;"
		HTML += "}"
		HTML += "</style></head>"
		HTML += "<body>"
		if(config.usewhitelist && !check_whitelist(user))
			HTML += "<font color='red'><strong>To play as AI, Captain or HoP you must be whitelisted. The clown is playable by Gold Members.</strong></font><br>To do so, <a href='http://d2k5.com/threads/how-do-i-link-my-forum-acount-with-byond.923/' target='_blank'>link your accounts here</a>!<br><br>"
		else
			HTML += "<font color='green'><strong>You are whitelisted!</strong></font><br>"

		HTML += "<table border=\"0\" bordercolor=\"\" width=\"\" bgcolor=\"\">"
		HTML += "<tr>"
		HTML += "<td><b>Management</b></td>"
		HTML += "<td><b>Engineering/Maintenance</b></td>"
		HTML += "<td><b>Med/Sci</b></td>"
		HTML += "<td><b>Security</b></td>"
		HTML += "<td><b>Civilian</b></td>"
		HTML += "</tr>"
		HTML += "<tr>"
		HTML += "<td>"
		HTML += "<a href='byond://?src=\ref[user];preferences=1;occ=[occ];job=AI'>A.I.</a><br>"
		HTML += "<a href='byond://?src=\ref[user];preferences=1;occ=[occ];job=Captain'>Captain</a><br>"
		HTML += "<a href='byond://?src=\ref[user];preferences=1;occ=[occ];job=Head of Personnel'>Head of Personnel</a><br>"
		HTML += "<a href='byond://?src=\ref[user];preferences=1;occ=[occ];job=Head of Security'>Head of Security</a><br>"
		HTML += "<a href='byond://?src=\ref[user];preferences=1;occ=[occ];job=Chief Engineer'>Chief Engineer</a><br>"
		HTML += "<a href='byond://?src=\ref[user];preferences=1;occ=[occ];job=Research Director'>Research Director</a><br>"
		HTML += "<a href='byond://?src=\ref[user];preferences=1;occ=[occ];job=Chief Medical Officer'>Chief Medical Officer</a><br>"
		HTML += "</td>"
		HTML += "<td>"
		HTML += "<a href='byond://?src=\ref[user];preferences=1;occ=[occ];job=Station Engineer'>Station Engineer</a><br>"
		HTML += "<a href='byond://?src=\ref[user];preferences=1;occ=[occ];job=Janitor'>Janitor</a><br>"
		HTML += "<a href='byond://?src=\ref[user];preferences=1;occ=[occ];job=Quartermaster'>Quartermaster</a><br>"
		HTML += "</td>"
		HTML += "<td>"
		HTML += "<a href='byond://?src=\ref[user];preferences=1;occ=[occ];job=Medical Doctor'>Medical Doctor</a><br>"
		HTML += "<a href='byond://?src=\ref[user];preferences=1;occ=[occ];job=Chemist'>Chemist</a><br>"
		HTML += "<a href='byond://?src=\ref[user];preferences=1;occ=[occ];job=Scientist'>Scientist</a><br>"
		//HTML += "<a href='byond://?src=\ref[user];preferences=1;occ=[occ];job=Geneticist'>Geneticist</a><br>"
		HTML += "<a href='byond://?src=\ref[user];preferences=1;occ=[occ];job=Roboticist'>Roboticist</a><br>"
		HTML += "<a href='byond://?src=\ref[user];preferences=1;occ=[occ];job=Virologist'>Virologist</a><br>"
		HTML += "</td>"
		HTML += "<td>"
		HTML += "<a href='byond://?src=\ref[user];preferences=1;occ=[occ];job=Security Officer'>Security Officer</a><br>"
		HTML += "<a href='byond://?src=\ref[user];preferences=1;occ=[occ];job=Detective'>Detective</a><br>"
		HTML += "</td>"
		HTML += "<td>"
		HTML += "<a href='byond://?src=\ref[user];preferences=1;occ=[occ];job=Chef'>Chef</a><br>"
		HTML += "<a href='byond://?src=\ref[user];preferences=1;occ=[occ];job=Bartender'>Bartender</a><br>"
		HTML += "<a href='byond://?src=\ref[user];preferences=1;occ=[occ];job=Botanist'>Botanist</a><br>"
		HTML += "<a href='byond://?src=\ref[user];preferences=1;occ=[occ];job=Chaplain'>Chaplain</a><br>"
		if (usr.client.goon)
			HTML += "<a href='byond://?src=\ref[user];preferences=1;occ=[occ];job=Clown'>Clown</a><br>" // what have i released -- deadsnipe
			HTML += "<a href='byond://?src=\ref[user];preferences=1;occ=[occ];job=Mime'>Mime</a><br>" // see ^
			HTML += "<a href='byond://?src=\ref[user];preferences=1;occ=[occ];job=Lawyer'>Lawyer</a><br>"
			HTML += "<a href='byond://?src=\ref[user];preferences=1;occ=[occ];job=Retard'>Retard</a><br>"
			HTML += "<a href='byond://?src=\ref[user];preferences=1;occ=[occ];job=Prostitute'>Prostitute</a><br>" //Atleast I know what I released, AIDS - Nernums
			HTML += "<a href='byond://?src=\ref[user];preferences=1;occ=[occ];job=Monkey'>Monkey</a><br>" //Speaking of AIDS- Nernums
		HTML += "<a href='byond://?src=\ref[user];preferences=1;occ=[occ];job=Assistant'>Assistant</a><br>"
		HTML += "<a href='byond://?src=\ref[user];preferences=1;occ=[occ];job=Tourist'>Tourist</a><br>"
		HTML += "</table>"
		HTML += "</body>"

		user << browse(HTML, "window=mob_occupation;size=640x200")
		return

	proc/SetJob(mob/user, occ=1, job="Captain")
		if ((!( occupations.Find(job) ) && !( assistant_occupations.Find(job) ) && job != "Captain"))
			return
		if (job=="AI" && (!config.allow_ai))
			return
		if (jobban_isbanned(user, job))
			return

		switch(occ)
			if(1.0)
				if (job == occupation[1])
					user << browse(null, "window=mob_occupation")
					return
				else
					if (job == "No Preference")
						occupation[1] = "No Preference"
					else
						if (job == occupation[2])
							job = occupation[1]
							occupation[1] = occupation[2]
							occupation[2] = job
						else
							if (job == occupation[3])
								job = occupation[1]
								occupation[1] = occupation[3]
								occupation[3] = job
							else
								occupation[1] = job
			if(2.0)
				if (job == occupation[2])
					user << browse(null, "window=mob_occupation")
					return
				else
					if (job == "No Preference")
						if (occupation[3] != "No Preference")
							occupation[2] = occupation[3]
							occupation[3] = "No Preference"
						else
							occupation[2] = "No Preference"
					else
						if (job == occupation[1])
							if (occupation[2] == "No Preference")
								user << browse(null, "window=mob_occupation")
								return
							job = occupation[2]
							occupation[2] = occupation[1]
							occupation[1] = job
						else
							if (job == occupation[3])
								job = occupation[2]
								occupation[2] = occupation[3]
								occupation[3] = job
							else
								occupation[2] = job
			if(3.0)
				if (job == occupation[3])
					user << browse(null, "window=mob_occupation")
					return
				else
					if (job == "No Preference")
						occupation[3] = "No Preference"
					else
						if (job == occupation[1])
							if (occupation[3] == "No Preference")
								user << browse(null, "window=mob_occupation")
								return
							job = occupation[3]
							occupation[3] = occupation[1]
							occupation[1] = job
						else
							if (job == occupation[2])
								if (occupation[3] == "No Preference")
									user << browse(null, "window=mob_occupation")
									return
								job = occupation[3]
								occupation[3] = occupation[2]
								occupation[2] = job
							else
								occupation[3] = job

		user << browse(null, "window=mob_occupation")
		ShowChoices(user)

		return 1

	proc/process_link(mob/user, list/link_tags)

		if (link_tags["occ"])
			if (link_tags["cancel"])
				user << browse(null, "window=\ref[user]occupation")
				return
			else if(link_tags["job"])
				SetJob(user, text2num(link_tags["occ"]), link_tags["job"])
			else
				SetChoices(user, text2num(link_tags["occ"]))

			return 1

		if (link_tags["real_name"])
			var/new_name

			switch(link_tags["real_name"])
				if("input")
					new_name = input(user, "Please use a full name (first name and last name):", "Character Generation")  as text
					var/list/bad_characters = list("_", "'", "\"", "<", ">", ";", "[", "]", "{", "}", "|", "\\")
					for(var/c in bad_characters)
						new_name = dd_replacetext(new_name, c, "")
					if(!new_name || (new_name == "Unknown"))
						alert("Don't do this")
						return
					var/sanitizename = world.Export("http://78.47.53.54/requester.php?url=http://lemon.d2k5.com/namecheck.php@vals@name=[new_name]")
					if(sanitizename)
						var/sancontent = file2text(sanitizename["CONTENT"])
						if(sancontent == "failed")
							alert("You did not type in a full name or used special characters in your name, please try again.")
							return
						else
							new_name = sancontent
					else
						return

				if("random")
					randomize_name()

			if(new_name)
				if(length(new_name) >= 26)
					new_name = copytext(new_name, 1, 26)
				real_name = new_name

		if (link_tags["age"])
			switch(link_tags["age"])
				if ("input")
					var/new_age = input(user, "Please select type in age: 20-45", "Character Generation")  as num
					if(new_age)
						age = max(min(round(text2num(new_age)), 45), 20)
				if ("random")
					age = rand (20, 45)

		if (link_tags["b_type"])
			switch(link_tags["b_type"])
				if ("input")
					var/new_b_type = input(user, "Please select a blood type:", "Character Generation")  as null|anything in list( "A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-" )
					if (new_b_type)
						b_type = new_b_type
				if ("random")
					b_type = pickweight ( list ("A+" = 31, "A-" = 7, "B+" = 8, "B-" = 2, "AB+" = 2, "AB-" = 1, "O+" = 40, "O-" = 9))


		if (link_tags["hair"])
			switch(link_tags["hair"])
				if ("input")
					var/new_hair = input(user, "Please select hair color.", "Character Generation") as color
					if(new_hair)
						r_hair = hex2num(copytext(new_hair, 2, 4))
						g_hair = hex2num(copytext(new_hair, 4, 6))
						b_hair = hex2num(copytext(new_hair, 6, 8))
				if ("random")
					randomize_hair_color("hair")

/*
		if (link_tags["r_hair"])
			var/new_component = input(user, "Please select red hair component: 1-255", "Character Generation")  as text

			if (new_component)
				r_hair = max(min(round(text2num(new_component)), 255), 1)

		if (link_tags["g_hair"])
			var/new_component = input(user, "Please select green hair component: 1-255", "Character Generation")  as text

			if (new_component)
				g_hair = max(min(round(text2num(new_component)), 255), 1)

		if (link_tags["b_hair"])
			var/new_component = input(user, "Please select blue hair component: 1-255", "Character Generation")  as text

			if (new_component)
				b_hair = max(min(round(text2num(new_component)), 255), 1)
*/

		if (link_tags["facial"])
			switch(link_tags["facial"])
				if ("input")
					var/new_facial = input(user, "Please select facial hair color.", "Character Generation") as color
					if(new_facial)
						r_facial = hex2num(copytext(new_facial, 2, 4))
						g_facial = hex2num(copytext(new_facial, 4, 6))
						b_facial = hex2num(copytext(new_facial, 6, 8))
				if ("random")
					randomize_hair_color("facial")

/*
		if (link_tags["r_facial"])
			var/new_component = input(user, "Please select red facial component: 1-255", "Character Generation")  as text

			if (new_component)
				r_facial = max(min(round(text2num(new_component)), 255), 1)

		if (link_tags["g_facial"])
			var/new_component = input(user, "Please select green facial component: 1-255", "Character Generation")  as text

			if (new_component)
				g_facial = max(min(round(text2num(new_component)), 255), 1)

		if (link_tags["b_facial"])
			var/new_component = input(user, "Please select blue facial component: 1-255", "Character Generation")  as text

			if (new_component)
				b_facial = max(min(round(text2num(new_component)), 255), 1)
*/
		if (link_tags["eyes"])
			switch(link_tags["eyes"])
				if ("input")
					var/new_eyes = input(user, "Please select eye color.", "Character Generation") as color
					if(new_eyes)
						r_eyes = hex2num(copytext(new_eyes, 2, 4))
						g_eyes = hex2num(copytext(new_eyes, 4, 6))
						b_eyes = hex2num(copytext(new_eyes, 6, 8))
				if ("random")
					randomize_eyes_color()

/*
		if (link_tags["r_eyes"])
			var/new_component = input(user, "Please select red eyes component: 1-255", "Character Generation")  as text

			if (new_component)
				r_eyes = max(min(round(text2num(new_component)), 255), 1)

		if (link_tags["g_eyes"])
			var/new_component = input(user, "Please select green eyes component: 1-255", "Character Generation")  as text

			if (new_component)
				g_eyes = max(min(round(text2num(new_component)), 255), 1)

		if (link_tags["b_eyes"])
			var/new_component = input(user, "Please select blue eyes component: 1-255", "Character Generation")  as text

			if (new_component)
				b_eyes = max(min(round(text2num(new_component)), 255), 1)
*/
		if (link_tags["s_tone"])
			switch(link_tags["s_tone"])
				if ("random")
					randomize_skin_tone()
				if("input")
					var/new_tone = input(user, "Please select skin tone level: 1-220 (1=albino, 35=caucasian, 150=black, 220='very' black)", "Character Generation")  as text
					if (new_tone)
						s_tone = max(min(round(text2num(new_tone)), 220), 1)
						s_tone = -s_tone + 35

		if (link_tags["h_style"])
			switch(link_tags["h_style"])
				if ("random")
					if (gender == FEMALE)
						h_style = pickweight ( list ("Cut Hair" = 5, "Short Hair" = 5, "Long Hair" = 5, "Mohawk" = 5, "Balding" = 1, "Fag" = 5, "Afro" = 5, "Bieber" = 5, "Goku" = 5, "Dreadlocks" = 5, "Rocker" = 5, "Bald" = 5, "Super-long Hair" = 5, "Ponytail" = 5, "Short Female Hair" = 5, "Scene Hair" = 5, "Girly Hair" = 5, "Messy Hair" = 5, "Male Bedhead" = 5, "Female Bedhead" = 5))
					else
						h_style = pickweight ( list ("Cut Hair" = 5, "Short Hair" = 5, "Long Hair" = 5, "Mohawk" = 5, "Balding" = 5, "Fag" = 5, "Afro" = 5, "Bieber" = 5, "Goku" = 5, "Dreadlocks" = 5, "Rocker" = 5, "Bald" = 5, "Super-long Hair" = 5, "Ponytail" = 5, "Short Female Hair" = 5, "Scene Hair" = 5, "Girly Hair" = 5, "Messy Hair" = 5, "Male Bedhead" = 5, "Female Bedhead" = 5))

				if("input")
					var/new_style = input(user, "Please select hair style", "Character Generation")  as null|anything in list( "Cut Hair", "Short Hair", "Long Hair", "Mohawk", "Balding", "Fag", "Afro", "Bieber", "Goku", "Dreadlocks", "Rocker", "Bald", "Super-long Hair", "Ponytail", "Short Female Hair", "Scene Hair", "Girly Hair", "Messy Hair", "Male Bedhead", "Female Bedhead" )
					if (new_style)
						h_style = new_style

		if (link_tags["ooccolor"])
			var/ooccolor = input(user, "Please select OOC colour.", "OOC colour") as color

			if(ooccolor)
				src.ooccolor = ooccolor

		if (link_tags["f_style"])
			switch(link_tags["f_style"])
				if ("random")
					if (gender == FEMALE)
						f_style = pickweight ( list("Watson" = 1, "Chaplin" = 1, "Selleck" = 1, "Full Beard" = 1, "Long Beard" = 1, "Neckbeard" = 1, "Van Dyke" = 1, "Elvis" = 1, "Abe" = 1, "Chinstrap" = 1, "Hipster" = 1, "Goatee" = 1, "Hogan" = 1, "Shaved" = 100))
					else
						f_style = pickweight ( list("Watson" = 1, "Chaplin" = 1, "Selleck" = 1, "Full Beard" = 1, "Long Beard" = 1, "Neckbeard" = 1, "Van Dyke" = 1, "Elvis" = 1, "Abe" = 1, "Chinstrap" = 1, "Hipster" = 1, "Goatee" = 1, "Hogan" = 1, "Shaved" = 10))
				if("input")
					var/new_style = input(user, "Please select facial style", "Character Generation")  as null|anything in list("Watson", "Chaplin", "Selleck", "Full Beard", "Long Beard", "Neckbeard", "Van Dyke", "Elvis", "Abe", "Chinstrap", "Hipster", "Goatee", "Hogan", "Shaved")
					if (new_style)
						f_style = new_style

		if (link_tags["gender"])
			if (gender == MALE)
				gender = FEMALE
			else
				gender = MALE

		if (link_tags["sexuality"])
			if (sexuality == 0)
				sexuality = 1
			else
				sexuality = 0

		if (link_tags["UI"])
			if (UI == UI_OLD)
				UI = UI_NEW
			else
				UI = UI_OLD

		if (link_tags["midis"])
			midis = (midis+1)%2

		if (link_tags["underwear"])
			if(!IsGuestKey(user.key))
				if (underwear == 1)
					underwear = 0
				else
					underwear = 1

		if (link_tags["be_special"])
			src.be_special^=(1<<text2num(link_tags["be_special"])) //bitwize magic, sorry for that. --rastaf0

		if (link_tags["b_random_name"])
			be_random_name = !be_random_name

		if(!IsGuestKey(user.key))
			if(link_tags["save"])
				savefile_save(user)

			else if(link_tags["load"])
				if (!savefile_load(user, 0))
					alert(user, "You do not have a savefile.")

		if (link_tags["reset_all"])
			gender = MALE
			sexuality = 0
			randomize_name()

			age = 30
			occupation[1] = "No Preference"
			occupation[2] = "No Preference"
			occupation[3] = "No Preference"
			underwear = 1
			//be_syndicate = 0
			be_special = 0
			be_random_name = 0
			r_hair = 0.0
			g_hair = 0.0
			b_hair = 0.0
			r_facial = 0.0
			g_facial = 0.0
			b_facial = 0.0
			h_style = "Short Hair"
			f_style = "Shaved"
			r_eyes = 0.0
			g_eyes = 0.0
			b_eyes = 0.0
			s_tone = 0.0
			b_type = "A+"
			UI = UI_OLD
			midis = 1


		ShowChoices(user)

	proc/copy_to(mob/living/carbon/human/character, safety = 0)
		if(be_random_name)
			randomize_name()
		character.real_name = real_name

		character.gender = gender
		character.homosexual = sexuality

		character.age = age
		character.b_type = b_type

		character.r_eyes = r_eyes
		character.g_eyes = g_eyes
		character.b_eyes = b_eyes

		character.r_hair = r_hair
		character.g_hair = g_hair
		character.b_hair = b_hair

		character.r_facial = r_facial
		character.g_facial = g_facial
		character.b_facial = b_facial

		character.s_tone = s_tone

		character.h_style = h_style
		character.f_style = f_style

		switch (UI)
			if (UI_OLD)
				character.UI = 'screen1_old.dmi'
			if (UI_NEW)
				character.UI = 'screen1.dmi'

		switch(h_style)
			if("Short Hair")
				character.hair_icon_state = "hair_a"
			if("Long Hair")
				character.hair_icon_state = "hair_b"
			if("Cut Hair")
				character.hair_icon_state = "hair_c"
			if("Mohawk")
				character.hair_icon_state = "hair_d"
			if("Balding")
				character.hair_icon_state = "hair_e"
			if("Fag")
				character.hair_icon_state = "hair_f"
			if("Afro")
				character.hair_icon_state = "hair_afro"
			if("Bieber")
				character.hair_icon_state = "hair_bieber"
			if("Goku")
				character.hair_icon_state = "hair_bedhead"
			if("Dreadlocks")
				character.hair_icon_state = "hair_dreads"
			if("Rocker")
				character.hair_icon_state = "hair_rocker"
			if("Ponytail")
				character.hair_icon_state = "hair_pony"
			if("Super-long Hair")
				character.hair_icon_state = "hair_long"
			if("Short Female Hair")
				character.hair_icon_state = "hair_female_short"
			if("Scene Hair")
				character.hair_icon_state = "hair_scene"
			if("Girly Hair")
				character.hair_icon_state = "hair_girly"
			if("Messy Hair")
				character.hair_icon_state = "hair_femalemessy"
			if("Male Bedhead")
				character.hair_icon_state = "hair_messym"
			if("Female Bedhead")
				character.hair_icon_state = "hair_messyf"
			else
				character.hair_icon_state = "bald"

		switch(f_style)
			if ("Watson")
				character.face_icon_state = "facial_watson"
			if ("Chaplin")
				character.face_icon_state = "facial_chaplin"
			if ("Selleck")
				character.face_icon_state = "facial_selleck"
			if ("Neckbeard")
				character.face_icon_state = "facial_neckbeard"
			if ("Full Beard")
				character.face_icon_state = "facial_fullbeard"
			if ("Long Beard")
				character.face_icon_state = "facial_longbeard"
			if ("Van Dyke")
				character.face_icon_state = "facial_vandyke"
			if ("Elvis")
				character.face_icon_state = "facial_elvis"
			if ("Abe")
				character.face_icon_state = "facial_abe"
			if ("Chinstrap")
				character.face_icon_state = "facial_chin"
			if ("Hipster")
				character.face_icon_state = "facial_hip"
			if ("Goatee")
				character.face_icon_state = "facial_gt"
			if ("Hogan")
				character.face_icon_state = "facial_hogan"
			else
				character.face_icon_state = "bald"

		if (underwear == 1)
			character.underwear = pick(1,2,3,4,5)
		else
			character.underwear = 0

		character.update_face()
		character.update_body()

		if(!safety)//To prevent run-time errors due to null datum when using randomize_appearance_for()
			spawn(10)
				if(character&&character.client)
					character.client.midis = midis
					character.client.ooccolor = ooccolor
					character.client.be_alien = be_special&BE_ALIEN

/*

	if (!M.real_name || M.be_random_name)
		if (M.gender == "male")
			M.real_name = capitalize(pick(first_names_male) + " " + capitalize(pick(last_names)))
		else
			M.real_name = capitalize(pick(first_names_female) + " " + capitalize(pick(last_names)))
	for(var/mob/living/carbon/human/H in world)
		if(cmptext(H.real_name,M.real_name))
			usr << "You are using a name that is very similar to a currently used name, please choose another one using Character Setup."
			return
	if(cmptext("Unknown",M.real_name))
		usr << "This name is reserved for use by the game, please choose another one using Character Setup."
		return

*/
#undef UI_OLD
#undef UI_NEW