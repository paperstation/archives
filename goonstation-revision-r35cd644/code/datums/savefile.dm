/* see _setup.dm for the actual defines
#define SAVEFILE_VERSION_MIN	3
#define SAVEFILE_VERSION_MAX	7
#define SAVEFILE_PROFILES_MAX	3
*/
datum/preferences/proc/savefile_path(client/user)
	return "data/player_saves/[copytext(user.ckey, 1, 2)]/[user.ckey].sav"

datum/preferences/proc/savefile_save(client/user, profileNum=1)
	if (IsGuestKey(user.key))
		return 0

	profileNum = max(1, min(profileNum, SAVEFILE_PROFILES_MAX))

	var/savefile/F = new /savefile(src.savefile_path(user), -1)
	F.Lock(-1)

	F["version"] << SAVEFILE_VERSION_MAX

	F["[profileNum]_saved"] << 1
	F["[profileNum]_profile_name"] << src.profile_name
	F["[profileNum]_real_name"] << src.real_name
	F["[profileNum]_gender"] << src.gender
	F["[profileNum]_age"] << src.age
	F["[profileNum]_pin"] << src.pin
	F["[profileNum]_changelog"] << src.view_changelog
	F["[profileNum]_score"] << src.view_score
	F["[profileNum]_tickets"] << src.view_tickets
	F["[profileNum]_sounds"] << src.admin_music_volume
	F["[profileNum]_clickbuffer"] << src.use_click_buffer
	F["[profileNum]_job_prefs_1"] << src.job_favorite
	F["[profileNum]_job_prefs_2"] << src.jobs_med_priority
	F["[profileNum]_job_prefs_3"] << src.jobs_low_priority
	F["[profileNum]_job_prefs_4"] << src.jobs_unwanted
	if (src.AH)
		F["[profileNum]_eye_color"] << AH.e_color
		F["[profileNum]_hair_color"] << AH.customization_first_color
		F["[profileNum]_facial_color"] << AH.customization_second_color
		F["[profileNum]_detail_color"] << AH.customization_third_color
		F["[profileNum]_skin_tone"] << AH.s_tone
		F["[profileNum]_hair_style_name"] << AH.customization_first
		F["[profileNum]_facial_style_name"] << AH.customization_second
		F["[profileNum]_detail_style_name"] << AH.customization_third
		F["[profileNum]_underwear_style_name"] << AH.underwear
		F["[profileNum]_underwear_color"] << AH.u_color
	F["[profileNum]_random_blood"] << src.random_blood
	F["[profileNum]_blood_type"] << src.blType
	F["[profileNum]_be_changeling"] << src.be_changeling
	F["[profileNum]_be_revhead"] << src.be_revhead
	F["[profileNum]_be_syndicate"] << src.be_syndicate
	F["[profileNum]_be_wizard"] << src.be_wizard
	F["[profileNum]_be_traitor"] << src.be_traitor
	F["[profileNum]_be_vampire"] << src.be_vampire
	F["[profileNum]_be_spy"] << src.be_spy
	F["[profileNum]_be_gangleader"] << src.be_gangleader
	F["[profileNum]_be_wraith"] << src.be_wraith
	F["[profileNum]_be_blob"] << src.be_blob
	F["[profileNum]_be_misc"] << src.be_misc
	F["[profileNum]_hud_style"] << src.hud_style
	F["[profileNum]_tcursor"] << src.target_cursor

	if(src.traitPreferences.isValid())
		F["[profileNum]_traits"] << src.traitPreferences.traits_selected

	if (!force_random_names) // don't save this preference if that's enabled, because it might not be set to what people want it to be
		F["[profileNum]_name_is_always_random"] << src.be_random_name
	if (!force_random_looks)
		F["[profileNum]_look_is_always_random"] << src.be_random_look

	// Global prefs
	F["see_mentor_pms"] << src.see_mentor_pms
	F["listen_ooc"] << src.listen_ooc
	F["listen_looc"] << src.listen_looc
	F["default_wasd"] << src.default_wasd
	F["use_azerty"] << src.use_azerty

	return 1

// loads the savefile corresponding to the mob's ckey
// if silent=true, report incompatible savefiles
// returns 1 if loaded (or file was incompatible)
// returns 0 if savefile did not exist

datum/preferences/proc/savefile_load(client/user, var/profileNum = 1)
	var/client/C
	var/mob/M = user
	if(istype(user, /mob))
		C = M.client
	else if(istype(user, /client))
		C = user

	if (IsGuestKey(user.key))
		return 0

	var/path = savefile_path(user)

	if (!fexists(path))
		return 0

	profileNum = max(1, min(profileNum, SAVEFILE_PROFILES_MAX))

	var/savefile/F = new /savefile(path, -1)

	var/version = null
	F["version"] >> version

	if (isnull(version) || version < SAVEFILE_VERSION_MIN || version > SAVEFILE_VERSION_MAX)
		fdel(path)

//		if (!silent)
//			alert(user, "Your savefile was incompatible with this version and was deleted.")

		return 0
/*
	var/sanity_check = null
	F["[profileNum]_saved"] >> sanity_check
	if (isnull(sanity_check))
		F["1_saved"] >> sanity_check
		if (isnull(sanity_check))
			F["2_saved"] >> sanity_check
			if (isnull(sanity_check))
				F["3_saved"] >> sanity_check
				if (isnull(sanity_check))
					fdel(path)
		return 0
*/
	var/sanity_check = null
	F["[profileNum]_saved"] >> sanity_check
	if (isnull(sanity_check))
		for (var/i=1, i <= SAVEFILE_PROFILES_MAX, i++)
			F["[i]_saved"] >> sanity_check
			if (!isnull(sanity_check))
				break
		if (isnull(sanity_check))
			fdel(path)
		return 0

	if (version < 6)
		src.use_click_buffer = 0
	else
		F["[profileNum]_clickbuffer"] >> src.use_click_buffer

	F["[profileNum]_profile_name"] >> src.profile_name
	F["[profileNum]_real_name"] >> src.real_name
	F["[profileNum]_gender"] >> src.gender
	F["[profileNum]_age"] >> src.age
	F["[profileNum]_pin"] >> src.pin
	F["[profileNum]_changelog"] >> src.view_changelog
	F["[profileNum]_score"] >> src.view_score
	F["[profileNum]_tickets"] >> src.view_tickets
	F["[profileNum]_sounds"] >> src.admin_music_volume
	F["[profileNum]_job_prefs_1"] >> src.job_favorite
	F["[profileNum]_job_prefs_2"] >> src.jobs_med_priority
	F["[profileNum]_job_prefs_3"] >> src.jobs_low_priority
	F["[profileNum]_job_prefs_4"] >> src.jobs_unwanted
	if (src.AH)
		F["[profileNum]_eye_color"] >> AH.e_color
		F["[profileNum]_hair_color"] >> AH.customization_first_color
		F["[profileNum]_facial_color"] >> AH.customization_second_color
		F["[profileNum]_detail_color"] >> AH.customization_third_color
		F["[profileNum]_skin_tone"] >> AH.s_tone
		F["[profileNum]_hair_style_name"] >> AH.customization_first
		F["[profileNum]_facial_style_name"] >> AH.customization_second
		F["[profileNum]_detail_style_name"] >> AH.customization_third
		F["[profileNum]_underwear_style_name"] >> AH.underwear
		F["[profileNum]_underwear_color"] >> AH.u_color
	F["[profileNum]_random_blood"] >> src.random_blood
	F["[profileNum]_blood_type"] >> src.blType
	F["[profileNum]_be_changeling"] >> src.be_changeling
	F["[profileNum]_be_revhead"] >> src.be_revhead
	F["[profileNum]_be_syndicate"] >> src.be_syndicate
	F["[profileNum]_be_wizard"] >> src.be_wizard
	F["[profileNum]_be_traitor"] >> src.be_traitor
	F["[profileNum]_be_vampire"] >> src.be_vampire
	F["[profileNum]_be_spy"] >> src.be_spy
	F["[profileNum]_be_gangleader"] >> src.be_gangleader
	F["[profileNum]_be_wraith"] >> src.be_wraith
	F["[profileNum]_be_blob"] >> src.be_blob
	F["[profileNum]_be_misc"] >> src.be_misc
	F["[profileNum]_hud_style"] >> src.hud_style
	F["[profileNum]_tcursor"] >> src.target_cursor

	if(!istext(src.hud_style)) src.hud_style = "New"
	if(!istext(src.target_cursor)) src.target_cursor = "Default"

	F["[profileNum]_traits"] >> src.traitPreferences.traits_selected
	if (src.traitPreferences.traits_selected == null) src.traitPreferences.traits_selected = list()

	for (var/T in src.traitPreferences.traits_selected)
		if (!traitList.Find(T)) src.traitPreferences.traits_selected.Remove(T)

	if (!src.traitPreferences.isValid())
		src.traitPreferences.traits_selected.Cut()
		src.traitPreferences.calcTotal()
		alert(usr, "You loaded traits are invalid and have been reset.")

	if (!force_random_names)
		F["[profileNum]_name_is_always_random"] >> src.be_random_name
	else
		src.be_random_name = 1
	if (!force_random_looks)
		F["[profileNum]_look_is_always_random"] >> src.be_random_look
	else
		src.be_random_look = 1

	// Global prefs
	if (C && C.mentor_authed)
		var/saved_mpmpref
		F["see_mentor_pms"] >> saved_mpmpref
		if (isnull(saved_mpmpref))
			saved_mpmpref = 1
		if (saved_mpmpref == 0)
			src.see_mentor_pms = saved_mpmpref
			user.set_mentorhelp_visibility(saved_mpmpref)

	if (version < 7)
		src.listen_ooc = 1
	else
		F["listen_ooc"] >> src.listen_ooc

	F["listen_looc"] >> src.listen_looc
	if (isnull(src.listen_looc))
		src.listen_looc = 1

	F["use_azerty"] >> src.use_azerty
	C.preferences.use_azerty = src.use_azerty

	var/saved_wasdpref
	F["default_wasd"] >> saved_wasdpref
	if (isnull(saved_wasdpref))
		saved_wasdpref = 0
	if (saved_wasdpref == 1)
		src.default_wasd = saved_wasdpref

		var/current = winget(user, "mainwindow", "macro")
		if (current == "macro")
			user.togglewasdzqsd()

	return 1

/*
#undef SAVEFILE_VERSION_MAX
#undef SAVEFILE_VERSION_MIN
#undef SAVEFILE_PROFILES_MAX
*/

//This might be a bad way of doing it IDK
datum/preferences/proc/savefile_get_profile_name(client/user, var/profileNum = 1)
	if (IsGuestKey(user.key))
		return 0

	var/path = savefile_path(user)

	if (!fexists(path))
		return 0

	profileNum = max(1, min(profileNum, SAVEFILE_PROFILES_MAX))

	var/savefile/F = new /savefile(path, -1)

	var/version = null
	F["version"] >> version

	if (isnull(version) || version < SAVEFILE_VERSION_MIN || version > SAVEFILE_VERSION_MAX)
		fdel(path)
		return 0

	var/profile_name = null
	F["[profileNum]_profile_name"] >> profile_name

	return profile_name