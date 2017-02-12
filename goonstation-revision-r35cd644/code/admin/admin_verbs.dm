#include "macros.dm"

var/list/admin_verbs = list(


1 = list(\
// LEVEL_BABBY, goat fart, ayn rand's armpit
/client/proc/cmd_admin_say,\
/client/proc/cmd_admin_gib_self,\
),


2 = list(\
// LEVEL_MOD, moderator
/client/proc/admin_changes,\
/client/proc/admin_play,\
/client/proc/admin_observe,\
/client/proc/voting,\
/client/proc/game_panel,\
/client/proc/player_panel,\
/client/proc/cmd_admin_view_playernotes,\
/client/proc/toggle_pray,\
/client/proc/cmd_whois,\

/client/proc/cmd_admin_pm,\
/client/proc/dsay,\
/client/proc/blobsay,\
/client/proc/toggle_hearing_all_looc,\
/client/proc/cmd_admin_prison_unprison,\
/client/proc/cmd_admin_playermode,\

/datum/admins/proc/vmode,\
/datum/admins/proc/votekill,\
/datum/admins/proc/voteres,\
/datum/admins/proc/announce,\
/datum/admins/proc/toggleooc,\
/datum/admins/proc/togglelooc,\
/datum/admins/proc/toggleoocdead,\
/datum/admins/proc/startnow,\
/datum/admins/proc/toggleAI,\
/datum/admins/proc/delay_start,\
/datum/admins/proc/delay_end,\

/client/proc/cmd_admin_subtle_message,\
/client/proc/cmd_admin_alert,\
/client/proc/toggle_banlogin_announcements,\
/client/proc/toggle_jobban_announcements,\
/client/proc/toggle_popup_verbs,\
/client/proc/toggle_server_toggles_tab,\
/client/proc/toggle_attack_messages,\
/client/proc/toggle_hear_prayers,\
/client/proc/cmd_admin_plain_message,\
/client/proc/cmd_admin_check_vehicle,\
/client/proc/change_admin_prefs,\
/client/proc/cmd_boot,\

/client/proc/enableDrunkMode,\
/client/proc/forceDrunkMode,\

/client/proc/cmd_shame_cube,\
),\


3 = list(\
// LEVEL_SA, secondary administrator
/client/proc/stealth,\
/datum/admins/proc/pixelexplosion,\
/client/proc/alt_key,\
/client/proc/secrets,\
/verb/create_portal,\
/datum/admins/proc/togglefarting,\
/client/proc/cmd_admin_show_ai_laws,\
/client/proc/cmd_admin_reset_ai,\
/verb/restart_the_fucking_server_i_mean_it,\
/client/proc/cmd_admin_forceallsay,\
/client/proc/cmd_admin_murraysay,\
/datum/admins/proc/restart,\
/datum/admins/proc/toggleenter,\
/client/proc/respawn_target,\
/client/proc/respawn_self,\
/client/proc/cmd_admin_check_reagents,\
/client/proc/cmd_admin_check_health,\
/client/proc/revive_all_bees,\
/client/proc/revive_all_cats,\
/client/proc/revive_all_parrots,\
/client/proc/revive_critter,\
/client/proc/kill_critter,\
/datum/admins/proc/toggle_blood_system,\
/client/proc/narrator_mode,\
/client/proc/admin_pick_random_player,\

/datum/admins/proc/delay_start,\
/datum/admins/proc/delay_end,\
/client/proc/cmd_admin_create_centcom_report,\
/client/proc/cmd_admin_create_advanced_centcom_report,\
/client/proc/cmd_admin_advanced_centcom_report_help,\
/client/proc/warn,\
/client/proc/cmd_admin_playeropt,\
/client/proc/popt_key,\
/client/proc/show_rules_to_player,\
/client/proc/view_fingerprints,\
/client/proc/cmd_admin_intercom_announce,\
/client/proc/cmd_admin_intercom_help,\
/client/proc/cmd_dectalk,\
/client/proc/cmd_admin_remove_plasma,\
/client/proc/toggle_death_confetti,\

/client/proc/Jump,\
/client/proc/jumptomob,\
/client/proc/jtm,\
/client/proc/jumptokey,\
/client/proc/jtk,\
/client/proc/jumptoturf,\
/client/proc/jtt,\
/client/proc/jumptocoord,\
/client/proc/jtc,\
/client/proc/admin_follow_mobject,\
/client/proc/main_loop_context,\
/client/proc/main_loop_tick_detail,\
/client/proc/display_bomb_monitor, \
//Ban verbs
/client/proc/openBanPanel,\
/client/proc/cmd_admin_addban,\
/client/proc/banooc,\
/client/proc/view_cid_list,\
/client/proc/modify_parts,\

// moved down from admin
/client/proc/cmd_admin_add_freeform_ai_law,\
/client/proc/cmd_admin_mute,\
/client/proc/cmd_admin_mute_temp,\
/client/proc/respawn_as_self,\
/datum/admins/proc/toggletraitorscaling,\
),\

4 = list(\
/*// LEVEL_ADMIN, admin
/client/proc/noclip,\
/client/proc/cmd_admin_mute,\
/client/proc/cmd_admin_mute_temp,\
/client/proc/cmd_admin_delete,\
/client/proc/cmd_admin_add_freeform_ai_law,\
/client/proc/cmd_admin_show_ai_laws,\
/client/proc/cmd_admin_reset_ai,\
/client/proc/addpathogens,\
/client/proc/addreagents,\
/client/proc/respawn_as_self,\
/datum/admins/proc/toggletraitorscaling,\
/datum/admins/proc/togglerandomaiblobs\
*/),\


5 = list(\
// LEVEL_PA, primary administrator
/datum/admins/proc/togglesuicide,\
/datum/admins/proc/pixelexplosion,\
/client/proc/play_sound,\
/client/proc/play_music,\
/client/proc/cmd_admin_djmode,\
/client/proc/give_dj,\
/client/proc/play_ambient_sound,\
/client/proc/cmd_admin_clownify,\
/client/proc/toggle_theater,\
/client/proc/toggle_toggles,\
/client/proc/cmd_admin_plain_message_all,\
/client/proc/cmd_admin_fake_medal,\
/datum/admins/proc/togglemonkeyspeakhuman,\
/datum/admins/proc/toggleautoending,\
/datum/admins/proc/togglelatetraitors,\
/client/proc/togglebuildmode,\
/client/proc/cmd_admin_rejuvenate_all,\
/client/proc/fix_powernets,\
/client/proc/toggle_force_mixed_blob,\
/client/proc/toggle_force_mixed_wraith,\
/proc/possess,\
/proc/possessmob,\
/proc/releasemob,\
/client/proc/critter_creator_debug,\
/client/proc/cmd_cat_county,\
/client/proc/find_thing,\
/client/proc/find_one_of,\
/client/proc/cmd_admin_advview,\
/client/proc/cmd_swap_minds,\
/client/proc/edit_module,\
/*/client/proc/modify_organs,\*/
/client/proc/toggle_atom_verbs,\
/client/proc/toggle_camera_network_reciprocity,\
/client/proc/generate_poster,\
/client/proc/count_all_of,\
/client/proc/admin_set_ai_vox,\
/client/proc/cmd_makeshittyweapon,\

// moved up from admin
/client/proc/cmd_admin_delete,\
/client/proc/noclip,\
/client/proc/addpathogens,\
/client/proc/addreagents,\
/client/proc/respawn_as_self,\
/client/proc/cmd_give_pet,\
/client/proc/cmd_give_pets\
),\


6 = list(\
// LEVEL_SHITGUY, shit person
/datum/admins/proc/togglesoundwaiting,\
/datum/admins/proc/pixelexplosion,\
/client/proc/rspawn_panel,\
/proc/mod_color,\
/client/proc/debug_variables,\
/verb/adminCreateBlueprint,\
/client/proc/cmd_mass_modify_object_variables,\
/client/proc/cmd_debug_mutantrace,\
/client/proc/cmd_admin_gib,\
/client/proc/cmd_admin_partygib,\
/client/proc/cmd_admin_owlgib,\
/client/proc/cmd_admin_firegib,\
/client/proc/cmd_admin_elecgib,\
/client/proc/sharkgib,\
/client/proc/cmd_admin_icegib,\
/client/proc/cmd_admin_goldgib,\
/client/proc/cmd_admin_spidergib,\
/client/proc/cmd_admin_cluwnegib,\
/client/proc/cmd_admin_polymorph,\
/client/proc/cmd_admin_rejuvenate,\
/client/proc/cmd_admin_drop_everything,\
/client/proc/cmd_admin_humanize,\
/client/proc/cmd_admin_mobileAIize,\
/client/proc/cmd_admin_makeai,\
/client/proc/cmd_debug_del_all,\
/client/proc/cmd_admin_godmode,\
/client/proc/cmd_admin_godmode_self,\
/client/proc/cmd_admin_get_mobject,\
/client/proc/Getmob,\
/client/proc/sendmob,\
/client/proc/gethmobs,\
/client/proc/sendhmobs,\
/client/proc/getmobs,\
/client/proc/sendmobs,\
/client/proc/gettraitors,\
/client/proc/getnontraitors,\
/client/proc/Debug2,\
/client/proc/debug_deletions,\
#ifdef IMAGE_DEL_DEBUG
/client/proc/debug_image_deletions,\
/client/proc/debug_image_deletions_clear,\
#endif
/client/proc/jobbans,\
/client/proc/rebuild_jobbans_panel,\
/datum/admins/proc/adrev,\
/datum/admins/proc/adspawn,\
/datum/admins/proc/adjump,\
/client/proc/find_all_of,\
/client/proc/cmd_add_to_screen,\
/client/proc/respawn_as,\

/client/proc/general_report,\
/client/proc/map_debug_panel,\
/client/proc/air_report,\
/client/proc/air_status,\
/client/proc/fix_next_move,\
/client/proc/debugreward,\

/client/proc/flip_view,\
/client/proc/show_image_to_all,\
/client/proc/sharkban,\
/client/proc/cmd_explosion,\
/client/proc/toggle_literal_disarm,\
/client/proc/admin_smoke,\
/client/proc/admin_foam,\

/datum/admins/proc/toggleaprilfools,\
/client/proc/cmd_admin_pop_off_all_the_limbs_oh_god,\
/datum/admins/proc/togglethetoggles,\
/datum/admins/proc/togglesimsmode,\
/client/proc/admin_toggle_nightmode,\
/client/proc/toggle_ip_alerts,\
/client/proc/upload_custom_hud,\
/client/proc/replace_with_explosive\

),\

7 = list(\
// LEVEL_CODER, coder
/client/proc/cmd_job_controls,\
/datum/admins/proc/pixelexplosion,\
/client/proc/cmd_modify_market_variables,\
/client/proc/BK_finance_debug,\
/client/proc/BK_alter_funds,\
/client/proc/debug_pools,\
/client/proc/cmd_claim_rs_verbs,\
/client/proc/debug_variables,\
/client/proc/get_admin_state,\
/client/proc/call_proc,\
/client/proc/call_proc_all,\
/datum/admins/proc/adsound,\
/datum/admins/proc/pcap,\
/client/proc/toggle_extra_verbs,\
/client/proc/cmd_randomize_look,\
/client/proc/toggle_numbers_station_messages,\
/*
/client/proc/export_banlist,\
/client/proc/import_banlist,\
*/

/client/proc/ticklag,\
/client/proc/cmd_debug_vox,\
/datum/admins/proc/spawn_atom,\
/client/proc/view_save_data,\
/client/proc/check_gang_scores,\
/client/proc/mapWorld,\
/client/proc/call_proc_atom,\
/client/proc/haine_blood_debug,\
/client/proc/debug_messages,\
/client/proc/toggle_next_click,\
/client/proc/debug_reaction_list,\
/client/proc/debug_reagents_cache,\
/client/proc/debug_check_possible_reactions,\
/client/proc/set_admin_level,\
/client/proc/show_camera_paths, \
/*/client/proc/remove_camera_paths_verb, \*/
/client/proc/show_runtime_window,\
/client/proc/cmd_chat_debug,\
/client/proc/toggleIrcbotDebug,\
/datum/admins/proc/toggle_bone_system,\
#ifdef MACHINE_PROCESSING_DEBUG
/client/proc/cmd_display_detailed_machine_stats,\
#endif
#ifdef QUEUE_STAT_DEBUG
/client/proc/cmd_display_queue_stats,\
#endif
/client/proc/cmd_randomize_handwriting,\
/client/proc/wireTest,\
/client/proc/toggleResourceCache,\
/client/proc/debugResourceCache\
),\


8 = list(\
// LEVEL_HOST, host
/client/proc/cmd_claim_rs_verbs\
)\
)

// verbs that SAs and As get while observing. PA+ get these all the time
var/list/special_admin_observing_verbs = list(\
/client/proc/cmd_admin_check_contents,\
/datum/admins/proc/toggle_respawns,\
/datum/admins/proc/toggledeadchat,\
/client/proc/togglepersonaldeadchat\
)

// verbs that PAs get while observing. Coder+ get these all the time
var/list/special_pa_observing_verbs = list(\
/client/proc/cmd_admin_drop_everything,\
/client/proc/debug_variables,\
/client/proc/cmd_modify_object_variables,\
/client/proc/cmd_modify_ticker_variables,\
/client/proc/cmd_modify_controller_variables,\
/client/proc/Getmob,\
/client/proc/sendmob,\
/client/proc/cmd_admin_rejuvenate,\
/client/proc/toggle_view_range,\
/client/proc/cmd_admin_aview\
)

/client/proc/cmd_add_to_screen(var/atom/A as obj|mob|turf in world)
	set name = "Add to Screen"
	set desc = "Add a thing to some poor sod's screen."
	set popup_menu = 1
	set category = null

	var/list/who = list("everyone" = 1)
	for (var/client/C in clients)
		var/keyname = "[C] ([C.mob])"
		who += keyname
		who[keyname] = who

	var/chosen = input("Whose screen do you want to add this to?", "Add to screen", "everyone") as null|anything in who
	if (!chosen)
		return
	if (chosen == "everyone")
		for (var/client/C in clients)
			C.screen += A
		message_admins("[key_name(usr)] added [A] to everyone's screen!")
		logTheThing("admin", usr, null, "added [A] to everyone's screen.")
	else
		var/client/C = who[chosen]
		C.screen += A
		boutput(usr, "<span style=\"color:blue\">Successful.</span>")
		logTheThing("admin", usr, C.mob, "added [A] to %target%'s screen.")

/client/proc/update_admins(var/rank)
	if(!src.holder)
		src.holder = new /datum/admins(src)

	src.holder.rank = rank

	if(!src.holder.state)
		var/state = alert("Which state do you want the admin to begin in?", "Admin-state", "Play", "Observe", "Neither")
		if(state == "Play")
			src.holder.state = 1
			src.admin_play()
			return
		else if(state == "Observe")
			src.holder.state = 2
			src.admin_observe()
			return
		else
			src.holder.dispose()
			src.holder = null
			return

	switch (rank)
		if ("Host")
			src.holder.level = LEVEL_HOST
		if ("Coder")
			src.holder.level = LEVEL_CODER
		if ("Shit Person")
			src.holder.level = LEVEL_SHITGUY
		if ("Primary Administrator")
			src.holder.level = LEVEL_PA
		if ("Administrator")
			src.holder.level = LEVEL_ADMIN
		if ("Secondary Administrator")
			src.holder.level = LEVEL_SA
		if ("Moderator")
			src.holder.level = LEVEL_MOD
		if ("Goat Fart", "Ayn Rand's Armpit")
			src.holder.level = LEVEL_BABBY

		if ("Inactive")
			src.holder.dispose()
			src.holder = null
			boutput(src, "<span style='color:red;font-size:150%'><b>You are set to Inactive admin status! Please join #ss13admin on irc.synirc.net if you would like to become active again!</b></span>")
			return

		if ("Banned")
			del(src)
			return

		else
			src.holder.dispose()
			src.holder = null
			return

	if (src.holder)
		src.holder.owner = src
		for(var/i = 1; i < 9; i++)
			if (src.holder.level + 2 >= i && admin_verbs.len >= i && !isnull(admin_verbs[i]))
				src.verbs += admin_verbs[i]

		// certain ranks get special treatment while observing
		if( src.holder.state ) // literally the laziest way to do this
			if ( src.holder.level > LEVEL_MOD)
				src.deadchat = 1
				src.verbs += special_admin_observing_verbs
			if ( src.holder.level > LEVEL_ADMIN )
				src.verbs += special_pa_observing_verbs
		else
			if ( src.holder.level > LEVEL_ADMIN)
				src.deadchat = 1
				src.verbs += special_admin_observing_verbs
			if( src.holder.level > LEVEL_PA ) //SHIT GUY PLUS
				src.verbs += special_pa_observing_verbs

	if (src.chatOutput && src.chatOutput.loaded)
		src.chatOutput.loadAdmin()

/client/proc/clear_admin_verbs()
	src.deadchat = 0

	for(var/i = 1;i < 9; i++)
		src.verbs -= admin_verbs[i]

	src.verbs -= special_admin_observing_verbs
	src.verbs -= special_pa_observing_verbs

	src.buildmode = 0
	src.show_popup_menus = 1
	src.view = world.view
	usr.see_in_dark = initial(usr.see_in_dark)
	if(buildmode)
		qdel(buildmode)

	if(src.holder)
		src.holder.level = 0

/client/proc/admin_observe()
	set category = "Admin"
	set name = "Set Observe"
	if(!src.holder)
		alert("You are not an admin")
		return
/*
	if(!src.mob.start)
		alert("You cannot observe while in the starting position")
		return
*/
	src.verbs -= /client/proc/admin_play
	spawn( 100 )										//I believe that we can trust people to not spam shit with the observe things, because we trust them with the ban button after all
		src.verbs += /client/proc/admin_play

	if(!src.holder.popuptoggle) //Hrngh
		var/rank = src.holder.rank
		clear_admin_verbs()
		src.holder.state = 2
	//	src.mob.mind.observing = 1
		update_admins(rank)
	if(!istype(src.mob, /mob/dead/observer) && !istype(src.mob, /mob/dead/target_observer))
		src.mob.ghostize()
		boutput(src, "<span style=\"color:blue\">You are now observing</span>")
	else
		boutput(src, "<span style=\"color:blue\">You are already observing!</span>")

/client/proc/admin_play()
	set category = "Admin"
	set name = "Set Play"
	if(!src.holder)
		alert("You are not an admin")
		return
	src.verbs -= /client/proc/admin_observe
	spawn( 100 )										//I believe that we can trust people to not spam shit with the observe things, because we trust them with the ban button after all
		src.verbs += /client/proc/admin_observe

	if(!src.holder.popuptoggle) //Hrngh x2
		var/rank = src.holder.rank
		clear_admin_verbs()
		src.holder.state = 1
	//	src.mob.mind.observing = 0
		update_admins(rank)

	if(istype(src.mob, /mob/dead/observer))
		src.mob:reenter_corpse()
		boutput(src, "<span style=\"color:blue\">You are now playing</span>")
	else
		boutput(src, "<span style=\"color:blue\">You are already playing!</span>")

/client/proc/get_admin_state()
	set category = "Special Verbs"
	for(var/mob/M in mobs)
		if(M.client && M.client.holder)
			if(M.client.holder.state == 1)
				boutput(src, "[M.key] is playing - [M.client.holder.state]")
			else if(M.client.holder.state == 2)
				boutput(src, "[M.key] is observing - [M.client.holder.state]")
			else
				boutput(src, "[M.key] is undefined - [M.client.holder.state]")

//admin client procs ported over from mob.dm

/client/proc/player_panel()
	set name = "Player Panel"
	set category = "Admin"
	if (src.holder)
		src.holder.player()
	return

/client/proc/rspawn_panel()
	set name = "Respawn Panel"
	set category = "Admin"
	if (src.holder)
		src.holder.s_respawn()
	return

/client/proc/jobbans()
	set name = "Jobban Panel"
	set category = "Admin"
	if(src.holder)
		src.holder.Jobbans()
	return

/client/proc/rebuild_jobbans_panel()
	set name = "Rebuild Jobbans Panel"
	set category = "Admin"
	if (src.holder)
		src.holder.buildjobbanspanel()
	return

/client/proc/game_panel()
	set name = "Game Panel"
	set category = "Admin"
	if (src.holder)
		src.holder.Game()
	return

/client/proc/secrets()
	set name = "Secrets"
	set category = "Admin"
	if (src.holder)
		src.holder.Secrets()
	return

/client/proc/voting()
	set name = "Voting"
	set category = "Admin"
	if (src.holder)
		src.holder.Voting()

/client/proc/stealth()
	set category = "Admin"
	set name = "Stealth Mode"
	admin_only

	//fuck u
	src.holder.set_stealth_mode(null, 0)

/datum/admins/proc/set_stealth_mode(var/new_key = null, var/force_on = 0)
	if (!src.owner || !istype(src.owner, /client))
		return // farte
	if (force_on)
		src.owner:stealth = 1
	else
		src.owner:stealth = !(src.owner:stealth)

	if (src.owner:stealth)
		if (!new_key)
			new_key = input(usr, "Enter your desired display name.", "Fake Key", src.owner:key) as null|text
			if (!new_key)
				src.owner:stealth = 0
		if (src.owner:stealth && src.owner:alt_key)
			src.set_alt_key()
		if (new_key)
			new_key = trim(new_key)
			//stealth_hide_fakekey = (alert("Hide your fake key when using DSAY?", "Extra stealthy","Yes", "No") == "Yes")
			// I think if people really wanna be Denmark they can just set themselves to be Denmark
			new_key = strip_html(new_key)
			if (length(new_key) >= 26)
				new_key = copytext(new_key, 1, 26)
			src.owner:fakekey = new_key
	else
		src.owner:fakekey = null
		src.owner:stealth_hide_fakekey = 0

	logTheThing("admin", src.owner, null, "has turned stealth mode [src.owner:stealth ? "ON using key \"[src.owner:fakekey]\"" : "OFF"]")
	logTheThing("diary", src.owner, null, "has turned stealth mode [src.owner:stealth ? "ON using key \"[src.owner:fakekey]\"" : "OFF"]", "admin")
	message_admins("[key_name(src.owner)] has turned stealth mode [src.owner:stealth ? "ON using key \"[src.owner:fakekey]\"" : "OFF"]")

	if (src.owner:stealth)
		var/ircmsg[] = new()
		ircmsg["key"] = src.owner:key
		ircmsg["name"] = (usr && usr.real_name) ? usr.real_name : "NULL"
		ircmsg["msg"] = "Has enabled stealth mode as ([src.owner:fakekey])"
		ircbot.export("admin", ircmsg)

/client/proc/alt_key()
	set category = "Admin"
	set name = "Alternate Key"
	set desc = "Shows your key as something else!"
	admin_only

	src.holder.set_alt_key(null, 0)

/datum/admins/proc/set_alt_key(var/new_key = null, var/force_on = 0)
	if (!src.owner || !istype(src.owner, /client))
		return // farte
	if (force_on)
		src.owner:alt_key = 1
	else
		src.owner:alt_key = !(src.owner:alt_key)

	if (src.owner:alt_key)
		if (!new_key)
			new_key = input(usr, "Enter your desired display name.", "Fake Key", src.owner:key) as null|text
			if (!new_key)
				src.owner:alt_key = 0
		if (src.owner:alt_key && src.owner:stealth)
			src.set_stealth_mode()
		if (new_key)
			new_key = trim(new_key)
			new_key = strip_html(new_key)
			if (length(new_key) >= 26)
				new_key = copytext(new_key, 1, 26)
			src.owner:fakekey = new_key
	else
		src.owner:fakekey = null

	logTheThing("admin", src.owner, null, "has changed their displayed key to [src.owner:alt_key ? "\"[src.owner:fakekey]\"" : "\"[src.owner:key]\""]")
	logTheThing("diary", src.owner, null, "has changed their displayed key to [src.owner:alt_key ? "\"[src.owner:fakekey]\"" : "\"[src.owner:key]\""]", "admin")
	message_admins("[key_name(src.owner)] has changed their displayed key to [src.owner:alt_key ? "\"[src.owner:fakekey]\"" : "\"[src.owner:key]\""]")
/*
	if (src.alt_key)
		var/ircmsg[] = new()
		ircmsg["key"] = src.owner:key
		ircmsg["name"] = (usr && usr.real_name) ? usr.real_name : "NULL"
		ircmsg["msg"] = "Has set their displayed key to ([src.owner:fakekey])"
		ircbot.export("admin", ircmsg)
*/
/client/proc/banooc()
	set category = "Admin"
	set name = "OOC (Un)Ban"
	set desc = "Ban or unban a player from using OOC"
	admin_only
	var/mob/target
	var/client/selection = input("Please, select a player!", "OOC Ban") as null|anything in clients
	if (!selection)
		return
	target = selection.mob
	if (!oocban_isbanned(target))
		oocban_fullban(target)
		message_admins("[key_name(src)] has banned [key_name(target)] from OOC")
		logTheThing("admin", usr, target, "Banned %target% from OOC")
		logTheThing("diary", usr, target, "Banned %target% from OOC", "admin")
	else
		oocban_unban(selection)
		message_admins("[key_name(src)] has unbanned [key_name(target)] from OOC")
		logTheThing("admin", usr, target, "Unbanned %target% from OOC")
		logTheThing("diary", usr, target, "Unbanned %target% from OOC", "admin")

/client/proc/warn(var/mob/M in world)
	set category = null
	set popup_menu = 0
	set name = "Warn"
	set desc = "Warn a player"
	admin_only
	if(M.client && M.client.holder && (M.client.holder.level >= src.holder.level))
		alert("You cannot perform this action. You must be of a higher administrative rank!", null, null, null, null, null)
		return
	if(!M.client.warned)
		M << browse(rules, "window=rules;size=480x320")
		boutput(M, "<span style=\"color:red\"><B>You have been warned by an administrator. This is the only warning you will receive.</B></span>")
		M.client.warned = 1
		message_admins("<span style=\"color:blue\">[src.ckey] warned [M.ckey].</span>")
	else
		var/addData[] = new()
		addData["ckey"] = M.ckey
		addData["compID"] = M.computer_id
		addData["ip"] = M.client.address
		addData["reason"] = "Autobanning due to previous warn. This is what we in the biz like to call a \"second warning\"."
		addData["akey"] = src.ckey
		addData["mins"] = 10
		addBan(1, addData)

var/list/fun_images = list()
/client/proc/show_image_to_all()
	set name = "Show Image to All"
	set category = "Special Verbs"

	if(fun_images.len)
		switch(alert("There is already an existing image.", "Warning", "Ignore", "Clear", "Cancel"))
			if("Clear")
				for (var/datum/hud/funimage/fun_image)
					for (var/client/C in fun_image.clients)
						fun_image.remove_client(C)
				fun_images.len = 0
				return
			if("Cancel")
				return

	var/icon/I = input("Pick an icon:","Icon") as null|icon
	if (I)
		var/datum/hud/funimage/fun_image = new(I)
		fun_images += fun_image
		for (var/client/C)
			fun_image.add_client(C)
		logTheThing("admin", src, null, "has uploaded icon [I] to all players")
		logTheThing("diary", src, null, "has uploaded icon [I] to all players", "admin")
		message_admins("[key_name(src)] has uploaded icon [I] to all players")

/client/proc/show_rules_to_player(mob/M as mob in world)
	set name = "Show Rules to Player"
	set popup_menu = 0
	set category = null
	if(!M.client)
		alert("[M] is logged out, so you should probably ban them!")
		return
	logTheThing("admin", src, M, "forced %target% to view the rules")
	logTheThing("diary", src, M, "forced %target% to view the rules", "admin")
	message_admins("[key_name(src)] forced [key_name(M)] to view the rules.")
	M << csound("sound/misc/klaxon.ogg")
	boutput(M, "<span style=\"color:red\"><B>WARNING: An admin is likely very cross with you and wants you to read the rules right fucking now!</B></span>")
	M << browse(rules, "window=rules;size=480x320")

/client/proc/view_fingerprints(obj/O as obj in world)
	set name = "View Object Fingerprints"
	set category = "Special Verbs"
	admin_only
	if(!O.fingerprintshidden.len)
		alert("There are no fingerprints on this object.", null, null, null, null, null)
		return

	boutput(src, "<b>Hidden Fingerprints on [O]:</b>")
	for(var/i in O.fingerprintshidden)
		boutput(src, i)

	boutput(src, "<b>Last touched by:</b> [O.fingerprintslast].")
	return

/client/proc/respawn_as(var/client/cli in clients)
	set name = "Respawn As"
	set desc = "Respawn yourself as the currenly loaded character of a player. Instantly. Right where you stand."
	set category = "Special Verbs"
	set popup_menu = 0
	admin_only

	if (!cli)
		cli = input("Please, select a player!", "Respawn As", null, null) as null|anything in clients
		if(!cli)
			return

	if (!cli.preferences)
		boutput(src, "<span style=\"color:red\">No preferences found on target client.</span>")

	var/mob/mymob = src.mob
	var/mob/living/carbon/human/H = new(mymob.loc)
	cli.preferences.copy_to(H,src.mob,1)
	if (!mymob.mind)
		mymob.mind = new /datum/mind()
		mymob.mind.key = key
		mymob.mind.current = mymob
		ticker.minds += mymob.mind
	mymob.mind.transfer_to(H)
	qdel(mymob)
	H.Equip_Rank("Staff Assistant", 1)

/client/proc/respawn_as_self()
	set name = "Respawn As Self"
	set desc = "Respawn yourself as your currenly loaded character. Instantly. Right where you stand."
	set category = "Special Verbs"
	set popup_menu = 0
	admin_only

	if (!src.preferences)
		boutput(src, "<span style=\"color:red\">No preferences found on your client.</span>")

	if (alert(usr, "Are you sure you wanna respawn yourself where you are? If you're already in a living mob, it'll be deleted!", "Confirmation", "Yes", "No") == "No")
		return

	var/mob/mymob = src.mob
	var/mob/living/carbon/human/H = new(mymob.loc)
	src.preferences.copy_to(H,src.mob,1)
	if (!mymob.mind)
		mymob.mind = new /datum/mind()
		mymob.mind.key = key
		mymob.mind.current = mymob
		ticker.minds += mymob.mind
	mymob.mind.transfer_to(H)
	qdel(mymob)
	H.Equip_Rank("Staff Assistant", 1)

/client/proc/cmd_admin_humanize(var/mob/M in world)
	set category = null
	set name = "Humanize"
	set popup_menu = 0

	if (!ticker)
		spawn (0)
			alert("Wait until the game starts.")
		return

	if (istype(M, /mob/new_player) || istype(M, /mob/dead/target_observer) || istype(M, /mob/living/intangible/aicamera))
		spawn (0)
			alert("You can't humanize new_player mobs or target observers.")
		return

	// You now get to chose (mostly) if you want to send the target to the arrival shuttle (Convair880).
	var/send_to_arrival_shuttle = 0
	if (iswraith(M))
		if (M.mind && M.mind.special_role == "wraith")
			remove_antag(M, src, 0, 1) // Can't complete specialist objectives as a human. Also, the proc takes care of the rest.
			return
		send_to_arrival_shuttle = 1
	else if (isintangible(M))
		if (M.mind && M.mind.special_role == "blob")
			remove_antag(M, src, 0, 1) // Ditto.
			return
		send_to_arrival_shuttle = 1
	else if (isAI(M))
		send_to_arrival_shuttle = 1
	else
		switch (input(src, "Send mob to arrival shuttle?", "Auto-teleport", "No") in list("Yes", "No", "Cancel"))
			if ("Cancel")
				return
			if ("Yes")
				send_to_arrival_shuttle = 1
			if ("No")
				send_to_arrival_shuttle = 0
			else
				send_to_arrival_shuttle = 0

	if (issilicon(M))
		var/mob/living/silicon/S = M
		if (S.dependent && S.mainframe && isAI(S.mainframe))
			qdel(S.mainframe) // Delete mainframe if it's an AI-controlled robot.

	logTheThing("admin", src, M, "has made %target% a human.")
	logTheThing("diary", src, M, "has made %target% a human.", "admin")
	message_admins("[key_name(src)] has made [key_name(M)] a human.")

	if (send_to_arrival_shuttle == 1)
		M.show_text("<h2><font color=red><B>You have been respawned as a human and send to the arrival shuttle. If this is an unexpected development, please inquire about it in adminhelp.</B></font></h2>", "red")
		return M.humanize(1)
	else
		M.show_text("<h2><font color=red><B>You have been respawned as a human. If this is an unexpected development, please inquire about it in adminhelp.</B></font></h2>", "red")
		return M.humanize(0)

/client/proc/cmd_admin_pop_off_all_the_limbs_oh_god()
	set category = null
	set name = "Pop off everyone's limbs"
	set desc = "Oh christ no don't do this"

	if(alert("Really pop off everyone's limbs?", "JESUS CHRIST", "Yes, I'm a crazy bastard", "No") == "Yes, I'm a crazy bastard")
		logTheThing("admin", src, null, "popped off all limbs.")
		logTheThing("diary", src, null, "has popped off all limbs", "admin")
		message_admins("[key_name(src)] has popped off everyone's limbs.")

		for (var/mob/living/M in world)
			for (var/obj/item/parts/P in M)
				P.sever()

			M.update_body()
	else
		alert("Thank fuck.")

//Special proc to set up the server for mapping via screenshots
/client/proc/mapWorld()
	set name = "Map World"
	set desc = "Takes a series of screenshots for mapping"
	set category =  null

	//Gotta prevent dummies
	var/confirm = alert("WARNING: This proc should absolutely not be run on a live server! Make sure you know what you are doing!", "WARNING", "Cancel", "Proceed")
	if(confirm == "Cancel")
		return

	//Viewport size
	var/viewport_width
	var/viewport_height
	var/inputView = input(src, "Set your desired viewport size. (60 for 300x300 maps, 50 for 200x200)", "Viewport Size", 60) as num
	if (inputView < 1)
		return
	else
		viewport_width = inputView
		viewport_height = inputView

	src.view = "[viewport_width]x[viewport_height]"

	//Z levels to map
	var/z
	var/allZ = 0
	var/safeAllZ = 0
	var/inputZ = input(src, "What Z level do you want to map? (10 for all levels, 11 for all except centcom level)", "Z Level", 11) as num
	if (inputZ < 1)
		return
	else if (inputZ == 10)
		allZ = 1
	else if (inputZ == 11)
		safeAllZ = 1
	else
		z = inputZ

	var/delay
	var/inputDelay = input(src, "Delay between changing location/taking screenshots. (If unsure, leave as as default)", "Delay", 7) as num
	if (inputDelay < 1)
		return
	else
		delay = inputDelay

	var/confirm2 = alert("Make everyone invisible? (Literally every mob)", "Invisible Mobs?", "No", "Yes")
	if (confirm2 == "Yes")
		//Make everyone invisible so they don't get in the way of screenshots
		for (var/mob/M in mobs)
			if (M.ckey)
				M.alpha = 0

	var/confirm3 = alert("Max out all power devices? (Prevents lights from going out mid-mapping)", "Max Power?", "No", "Yes")
	if (confirm3 == "Yes")
		//Max out all power (to avoid lights dying mid mapping)
		for(var/obj/machinery/power/apc/C in machines)
			if(C.cell && C.z == 1)
				C.cell.charge = C.cell.maxcharge
		for(var/obj/machinery/power/smes/S in machines)
			if(S.z != 1)
				continue
			S.charge = S.capacity
			S.output = 200000
			S.online = 1
			S.updateicon()
			S.power_change()

	var/confirm4 = alert("Turn space bright pink? (For post processing/optimizations)", "Pink Background?", "No", "Yes")
	if (confirm4 == "Yes")
		//Make every space tile bright pink (for further processing via local image manipulation)
		for (var/turf/space/S in world)
			if (S.contents.len == 0 && S.overlays.len == 0) //Doesnt pinkify tiles with crap on top of them (transparant overlays fuck with the image processing later)
				S.icon = 'icons/effects/ULIcons.dmi'
				S.icon_state = "etc"
				S.color = "#ff00e4"

	var/confirm5 = alert("Delete all objects under '/obj/overlay/tile_effect'? (Removes shadows and makes everything fullbright)", "Fullbright?", "No", "Yes")
	if (confirm5 == "Yes")
		for (var/obj/overlay/tile_effect/T in world)
			qdel(T)

	var/start_x = (viewport_width / 2) + 1
	var/start_y = (viewport_height / 2) + 1

	//Map eeeeverything
	if (allZ || safeAllZ)
		for (var/curZ = 1; curZ <= world.maxz; curZ++)
			if (safeAllZ && curZ == 2)
				continue //Skips centcom
			for (var/y = start_y; y <= world.maxy; y += viewport_height)
				for (var/x = start_x; x <= world.maxx; x += viewport_width)
					src.mob.x = x
					src.mob.y = y
					src.mob.z = curZ
					sleep(delay)
					winset(src, null, "command=\".screenshot auto\"")
					sleep(delay)
			if (curZ != world.maxz)
				var/pause = alert("Z Level ([curZ]) finished. Organise your screenshot files and press Ok to continue or Cancel to cease mapping.", "Tea break", "Ok", "Cancel")
				if (pause == "Cancel")
					return
	//Or just one level I GUESS
	else
		for (var/y = start_y; y <= world.maxy; y += viewport_height)
			for (var/x = start_x; x <= world.maxx; x += viewport_width)
				src.mob.x = x
				src.mob.y = y
				src.mob.z = z
				sleep(delay)
				winset(src, null, "command=\".screenshot auto\"")
				sleep(delay)

	alert("Mapping complete!", "Yay!", "Ok")

/client/proc/view_cid_list(var/C as text)
	set name = "View CompID List"
	set desc = "View the list of observed computer IDs belonging to a key"
	set category = "Admin"

	admin_only

	view_client_compid_list(usr, C)

/client/proc/cmd_chat_debug(var/client/C in clients)
	set name = "Debug Chat"
	set desc = "Opens a firebug console in the target's chat area"
	set category = "Debug"

	admin_only

	if (src != C)
		var/trigger = (C.holder ? src.key : (src.stealth || src.fakekey ? src.fakekey : src.key))
		ehjax.send(C, "browseroutput", list("firebug" = 1, "trigger" = trigger))
		message_admins("[key_name(src)] has enabled Debug Chat mode on [key_name(C)]")
	else
		ehjax.send(C, "browseroutput", list("firebug" = 1))

/client/proc/blobsay(msg as text)
	set category = "Special Verbs"
	set name = "blobsay"
	set hidden = 1
	admin_only
	if (!src.mob)
		return

	msg = copytext(sanitize(html_encode(msg)), 1, MAX_MESSAGE_LEN)
	logTheThing("admin", src, null, "BLOBSAY: [msg]")
	logTheThing("diary", src, null, "BLOBSAY: [msg]", "admin")

	if (!msg)
		return
	var/show_other_key = 0
	if (src.stealth || src.alt_key)
		show_other_key = 1
	var/rendered = "<span class='game blobsay'><span class='prefix'>BLOB:</span> <span class='name'>ADMIN([show_other_key ? src.fakekey : src.key])</span> says, <span class='message'>\"[msg]\"</span></span>"
	var/adminrendered = "<span class='game blobsay'><span class='prefix'>BLOB:</span> <span class='name' data-ctx='\ref[src.mob.mind]'>[show_other_key ? "ADMIN([src.key] (as [src.fakekey])" : "ADMIN([src.key]"])</span> says, <span class='message'>\"[msg]\"</span></span>"

	for (var/mob/M in mobs)
		if(istype(M, /mob/new_player))
			continue

		if (M.client && (istype(M, /mob/living/intangible/blob_overmind) || M.client.holder))
			var/thisR = rendered
			if (M.client.holder && src.mob.mind)
				thisR = "<span class='adminHearing' data-ctx='[M.client.chatOutput.ctxFlag]'>[adminrendered]</span>"
			M.show_message(thisR, 2)

/client/proc/cmd_dectalk()
	set name = "Dectalk"
	set category = "Special Verbs"
	set desc = "Sends a message as voice to all players"
	set popup_menu = 0

	var/msg
	if (args && args.len > 0)
		msg = args[1]

	msg = input(src, "Sends a message as voice to all players", "Dectalk", msg) as null|message
	if (!msg) return 0

	var/audio = dectalk(msg)
	if (audio && audio["audio"])
		message_admins("[key_name(src)] has used the dectalk verb with message: [audio["message"]]")
		logTheThing("admin", src, null, "has used the dectalk verb with message: [audio["message"]]")
		logTheThing("diary", src, null, "has used the dectalk verb with message: [audio["message"]]", "admin")

		for (var/client/C in clients)
			var/trigger = src.key
			if (src.holder && (src.stealth || src.alt_key))
				trigger = (C.holder ? "[src.key] (as [src.fakekey])" : src.fakekey)
			ehjax.send(C, "browseroutput", list("dectalk" = audio["audio"], "decTalkTrigger" = trigger))
		return 1
	else if (audio && audio["cooldown"])
		alert(src, "There is a [nextDectalkDelay] second global cooldown between uses of this verb. Please wait [((world.timeofday + nextDectalkDelay * 10) - world.timeofday)/10] seconds.")
		src.cmd_dectalk(msg)
		return 0
	else
		alert(src, "An external server error has occurred. Please report this.")
		return 0

/client/proc/cmd_give_pet(var/mob/M)
	set popup_menu = 0
	set name = "Give Pet"
	set desc = "Assigns someone a pet!  Woo!"
	set hidden = 1
	admin_only

	if (!M)
		M = input("Choose a target.", "Selection") as null|anything in mobs
		if (!M)
			return
	var/pet_input = input("Enter path of the thing you want to give as a pet or enter a part of the path to search", "Enter Path", pick("/obj/critter/domestic_bee", "/obj/critter/parrot/random", "/obj/critter/cat")) as null|text
	if (!pet_input)
		return
	var/pet_path = get_one_match(pet_input, /obj)
	if (!pet_path)
		return

	var/obj/Pet = new pet_path(get_turf(M))
	Pet.name = "[M]'s pet [Pet.name]"

	logTheThing("admin", usr ? usr : src, M, "gave %target% a pet [pet_path]!")
	logTheThing("diary", usr ? usr : src, M, "gave %target% a pet [pet_path]!", "admin")
	message_admins("[key_name(usr ? usr : src)] gave [M] a pet [pet_path]!")

/client/proc/cmd_give_pets()
	set popup_menu = 0
	set name = "Give Pets"
	set desc = "Assigns everyone a pet!  Woo!"
	set hidden = 1
	admin_only

	var/pet_input = input("Enter path of the thing you want to give people as pets or enter a part of the path to search", "Enter Path", pick("/obj/critter/domestic_bee", "/obj/critter/parrot/random", "/obj/critter/cat")) as null|text
	if (!pet_input)
		return
	var/pet_path = get_one_match(pet_input, /obj)
	if (!pet_path)
		return

	for (var/mob/living/L in mobs)
		var/obj/Pet = new pet_path(get_turf(L))
		Pet.name = "[L]'s pet [Pet.name]"
		sleep(-1)

	logTheThing("admin", usr ? usr : src, null, "gave everyone a pet [pet_path]!")
	logTheThing("diary", usr ? usr : src, null, "gave everyone a pet [pet_path]!", "admin")
	message_admins("[key_name(usr ? usr : src)] gave everyone a pet [pet_path]!")

/client/proc/admin_changes()
	set category = "Admin"
	set name = "Admin Changelog"
	set desc = "Show or hide the admin changelog"
	admin_only

	if (winget(src, "adminchanges", "is-visible") == "true")
		src.Browse(null, "window=adminchanges")
	else
		var/changelogHtml = grabResource("html/changelog.html")
		var/data = admin_changelog:html
		changelogHtml = dd_replacetext(changelogHtml, "<!-- HTML GOES HERE -->", "[data]")
		src.Browse(changelogHtml, "window=adminchanges;size=500x650;title=Admin+Changelog;")