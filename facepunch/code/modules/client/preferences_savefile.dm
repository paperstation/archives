#define SAVEFILE_VERSION_MIN	11
#define SAVEFILE_VERSION_MAX	11

//handles converting savefiles to new formats
//MAKE SURE YOU KEEP THIS UP TO DATE!
//If the sanity checks are capable of handling any issues. Only increase SAVEFILE_VERSION_MAX,
//this will mean that savefile_version will still be over SAVEFILE_VERSION_MIN, meaning
//this savefile update doesn't run everytime we load from the savefile.
//This is mainly for format changes, such as the bitflags in toggles changing order or something.
//if a file can't be updated, return 0 to delete it and start again
//if a file was updated, return 1
/datum/preferences/proc/savefile_update(savefile/S)

	//pai savefiles were merged into main player savefile, fetch data from old file if possible
	//"name_is_always_random"/be_random_name was deprecated by using blank names
	if(savefile_version == 9)
		var/pai = load_path("pai.sav")	//old_pai_savefile_path
		if(fexists(pai))
			var/savefile/P = new /savefile(pai)
			if(P)
				S["pai_name"]			<< P["name"]			//transfer data to our main savefile
				S["pai_description"]	<< P["description"]
		S.dir.Remove("name_is_always_random")					//deprecated
		++savefile_version

	//date_first_joined introduced
	if(savefile_version == 10)
		S["date_first_joined"] << 0		//just so players that have joined before this feature, aren't blocked from jobs like a first-time player would be
		++savefile_version

	if(savefile_version == SAVEFILE_VERSION_MAX)	//update successful.
		S["version"] << SAVEFILE_VERSION_MAX
		return 1

	//we couldn't update to current version, wipe it and overwrite with defaults
	//this will be what happens for players with really old savefiles, or new players with blank-savefiles
	S.dir.Cut()
	savefile_version = SAVEFILE_VERSION_MAX
	save_preferences(S)
	return 0

/datum/preferences/proc/load_path(filename="preferences.sav")
	if(ckey)
		return"data/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename]"

/datum/preferences/proc/load_preferences()
	if(!path)				return 0
	//if(!fexists(path))		return 0
	var/savefile/S = new /savefile(path,SAVEFILE_TIMEOUT)
	if(!S)					return 0
	S.cd = "/"

	S["version"] >> savefile_version

	//Conversion
	if(!isnum(savefile_version) || savefile_version < SAVEFILE_VERSION_MIN || savefile_version > SAVEFILE_VERSION_MAX)
		if(!savefile_update(S))  //handles updates
			return 1

	S["date_first_joined"]	>> date_first_joined

	//general preferences
	S["ooccolor"]			>> ooccolor
	S["lastchangelog"]		>> lastchangelog
	S["UI_style"]			>> UI_style
	S["be_special"]			>> be_special
	S["default_slot"]		>> default_slot
	S["toggles"]			>> toggles
	S["points"]				>> points
	S["pai_name"]			>> pai_name
	S["pai_description"]	>> pai_description
	S["clown_name"]			>> clown_name
	S["ai_name"]			>> ai_name

	//Sanitize
	sanitize_general()

	return 1

/datum/preferences/proc/save_preferences(savefile/S)
	if(!path)				return 0
	if(!savefile_version)	return 0
	if(!S)
		S = new /savefile(path,SAVEFILE_TIMEOUT)
	if(!S)					return 0
	S.cd = "/"

	S["version"] << savefile_version
	S["date_first_joined"]	<< date_first_joined

	//general preferences
	S["ooccolor"]			<< ooccolor
	S["lastchangelog"]		<< lastchangelog
	S["UI_style"]			<< UI_style
	S["be_special"]			<< be_special
	S["default_slot"]		<< default_slot
	S["toggles"]			<< toggles
	S["points"]				<< points
	S["pai_name"]			<< pai_name
	S["pai_description"]	<< pai_description
	S["clown_name"]			<< clown_name
	S["ai_name"]			<< ai_name
	return 1


/datum/preferences/proc/load_character(slot)
	if(!path)				return 0
	//if(!fexists(path))		return 0
	var/savefile/S = new /savefile(path,SAVEFILE_TIMEOUT)
	if(!S)					return 0

	update_preview_icon(1)	//clear preview_icon_front and preview_icon_side

	S.cd = "/"
	if(!slot)	slot = default_slot
	slot = sanitize_integer(slot, 1, MAX_SAVE_SLOTS, initial(default_slot))
	if(slot != default_slot)
		save_character(S)	//save our changes before switching character
		default_slot = slot
		S.cd = "/"
		S["default_slot"] << slot

	if(!(S.dir.Find("character[slot]")))	//if we're switching to a non-existing character slot, randomize it to avoid bald-diaper manbaby guy
		gender = pick(MALE, FEMALE)
		randomize_appearance_for()
		real_name = initial(real_name)
		ResetJobs()
		save_character(S)					//save the new random character
		return 1

	S.cd = "/character[slot]"

	//Character
	S["real_name"]			>> real_name
	S["gender"]				>> gender
	S["age"]				>> age
	//colors to be consolidated into hex strings (requires some work with dna code)
	S["hair_red"]			>> r_hair
	S["hair_green"]			>> g_hair
	S["hair_blue"]			>> b_hair
	S["facial_red"]			>> r_facial
	S["facial_green"]		>> g_facial
	S["facial_blue"]		>> b_facial
	S["skin_tone"]			>> s_tone
	S["hair_style_name"]	>> h_style
	S["facial_style_name"]	>> f_style
	S["eyes_red"]			>> r_eyes
	S["eyes_green"]			>> g_eyes
	S["eyes_blue"]			>> b_eyes
	S["underwear"]			>> underwear
	S["backbag"]			>> backbag

	//Jobs
	S["job_civilian_1"] 	>> job_civilian_1
	S["job_civilian_2"] 	>> job_civilian_2
	S["job_civilian_3"] 	>> job_civilian_3
	S["job_civilian_4"] 	>> job_civilian_4
	S["job_civilian_5"] 	>> job_civilian_5
	S["job_engsec_1"]		>> job_engsec_1
	S["job_engsec_2"]		>> job_engsec_2
	S["job_engsec_3"]		>> job_engsec_3
	S["job_engsec_4"]		>> job_engsec_4
	S["job_engsec_5"]		>> job_engsec_5
	S["job_medsci_1"]		>> job_medsci_1
	S["job_medsci_2"]		>> job_medsci_2
	S["job_medsci_3"]		>> job_medsci_3
	S["job_medsci_4"]		>> job_medsci_4
	S["job_medsci_5"]		>> job_medsci_5

	//Sanitize
	sanitize_character()
	return 1


/datum/preferences/proc/save_character(savefile/S)
	if(!path)				return 0
	if(!S)
		S = new /savefile(path,SAVEFILE_TIMEOUT)
	if(!S)					return 0
	S.cd = "/character[default_slot]"

	//Character
	S["real_name"]			<< real_name
	S["gender"]				<< gender
	S["age"]				<< age
	S["hair_red"]			<< r_hair
	S["hair_green"]			<< g_hair
	S["hair_blue"]			<< b_hair
	S["facial_red"]			<< r_facial
	S["facial_green"]		<< g_facial
	S["facial_blue"]		<< b_facial
	S["skin_tone"]			<< s_tone
	S["hair_style_name"]	<< h_style
	S["facial_style_name"]	<< f_style
	S["eyes_red"]			<< r_eyes
	S["eyes_green"]			<< g_eyes
	S["eyes_blue"]			<< b_eyes
	S["underwear"]			<< underwear
	S["backbag"]			<< backbag

	//Jobs
	S["job_civilian_1"] 	<< job_civilian_1
	S["job_civilian_2"] 	<< job_civilian_2
	S["job_civilian_3"] 	<< job_civilian_3
	S["job_civilian_4"] 	<< job_civilian_4
	S["job_civilian_5"] 	<< job_civilian_5
	S["job_engsec_1"]		<< job_engsec_1
	S["job_engsec_2"]		<< job_engsec_2
	S["job_engsec_3"]		<< job_engsec_3
	S["job_engsec_4"]		<< job_engsec_4
	S["job_engsec_5"]		<< job_engsec_5
	S["job_medsci_1"]		<< job_medsci_1
	S["job_medsci_2"]		<< job_medsci_2
	S["job_medsci_3"]		<< job_medsci_3
	S["job_medsci_4"]		<< job_medsci_4
	S["job_medsci_5"]		<< job_medsci_5
	S["points"]	<< points

	return 1


/datum/preferences/proc/sanitize_general()
	date_first_joined	= isnum(date_first_joined) ? date_first_joined : world.realtime
	ooccolor		= sanitize_hexcolor(ooccolor, initial(ooccolor))
	lastchangelog	= sanitize_text(lastchangelog, initial(lastchangelog))
	UI_style		= sanitize_inlist(UI_style, list("Midnight","Orange","old"), initial(UI_style))
	be_special		= sanitize_integer(be_special, 0, 65535, initial(be_special))
	default_slot	= sanitize_integer(default_slot, 1, MAX_SAVE_SLOTS, initial(default_slot))
	toggles			= sanitize_integer(toggles, 0, 65535, initial(toggles))
	points			= isnum(points) ? round(points) : 0		//sanitize_integer() would bound the value.
	pai_name		= reject_bad_name(pai_name, 1)
	pai_description	= reject_bad_text(pai_description)
	clown_name		= reject_bad_name(clown_name)
	ai_name			= reject_bad_name(ai_name, 1)


/datum/preferences/proc/sanitize_character()
	real_name		= reject_bad_name(real_name)
	gender			= sanitize_gender(gender)
	age				= sanitize_integer(age, AGE_MIN, AGE_MAX, initial(age))
	r_hair			= sanitize_integer(r_hair, 0, 255, initial(r_hair))
	g_hair			= sanitize_integer(g_hair, 0, 255, initial(g_hair))
	b_hair			= sanitize_integer(b_hair, 0, 255, initial(b_hair))
	r_facial		= sanitize_integer(r_facial, 0, 255, initial(r_facial))
	g_facial		= sanitize_integer(g_facial, 0, 255, initial(g_facial))
	b_facial		= sanitize_integer(b_facial, 0, 255, initial(b_facial))
	s_tone			= sanitize_integer(s_tone, -185, 34, initial(s_tone))
	h_style			= sanitize_inlist(h_style, hair_styles_list, initial(h_style))
	f_style			= sanitize_inlist(f_style, facial_hair_styles_list, initial(f_style))
	r_eyes			= sanitize_integer(r_eyes, 0, 255, initial(r_eyes))
	g_eyes			= sanitize_integer(g_eyes, 0, 255, initial(g_eyes))
	b_eyes			= sanitize_integer(b_eyes, 0, 255, initial(b_eyes))
	underwear		= sanitize_integer(underwear, 1, underwear_m.len, initial(underwear))
	backbag			= sanitize_integer(backbag, 1, backbaglist.len, initial(backbag))

	job_civilian_1 = sanitize_integer(job_civilian_1, 0, 65535, initial(job_civilian_1))
	job_civilian_2 = sanitize_integer(job_civilian_2, 0, 65535, initial(job_civilian_2))
	job_civilian_3 = sanitize_integer(job_civilian_3, 0, 65535, initial(job_civilian_3))
	job_civilian_4 = sanitize_integer(job_civilian_4, 0, 65535, initial(job_civilian_4))
	job_civilian_5 = sanitize_integer(job_civilian_5, 0, 65535, initial(job_civilian_5))
	job_engsec_1 = sanitize_integer(job_engsec_1, 0, 65535, initial(job_engsec_1))
	job_engsec_2 = sanitize_integer(job_engsec_2, 0, 65535, initial(job_engsec_2))
	job_engsec_3 = sanitize_integer(job_engsec_3, 0, 65535, initial(job_engsec_3))
	job_engsec_4 = sanitize_integer(job_engsec_4, 0, 65535, initial(job_engsec_4))
	job_engsec_5 = sanitize_integer(job_engsec_5, 0, 65535, initial(job_engsec_5))
	job_medsci_1 = sanitize_integer(job_medsci_1, 0, 65535, initial(job_medsci_1))
	job_medsci_2 = sanitize_integer(job_medsci_2, 0, 65535, initial(job_medsci_2))
	job_medsci_3 = sanitize_integer(job_medsci_3, 0, 65535, initial(job_medsci_3))
	job_medsci_4 = sanitize_integer(job_medsci_4, 0, 65535, initial(job_medsci_4))
	job_medsci_5 = sanitize_integer(job_medsci_5, 0, 65535, initial(job_medsci_5))

#undef SAVEFILE_VERSION_MAX
#undef SAVEFILE_VERSION_MIN
