#include "macros.dm"

/verb/restart_the_fucking_server_i_mean_it()
	set name = "Emergency Restart"
	set category = null
	if(config.update_check_enabled)
		world.installUpdate()
	world.Reboot()

/client/proc/cmd_admin_drop_everything(mob/M as mob in world)
	set category = null
	set popup_menu = 0
	set name = "Drop Everything"
	admin_only

	M.unequip_all()

	logTheThing("admin", usr, M, "made %target% drop everything!")
	logTheThing("diary", usr, M, "made %target% drop everything!", "admin")
	message_admins("[key_name(usr)] made [key_name(M)] drop everything!")

/client/proc/cmd_admin_prison_unprison(mob/M as mob in world)
	set category = null
	set popup_menu = 0
	set name = "Prison"
	admin_only

	if (M && ismob(M))
		var/area/A = get_area(M)
		if (A && istype(A, /area/prison/cell_block/wards))
			if (alert(src, "Do you wish to unprison [M.name]?", "Confirmation", "Yes", "No") != "Yes")
				return
			if (!M || !ismob(M))
				return

			var/ASLoc = latejoin.len ? pick(latejoin) : locate(1, 1, 1)
			if (ASLoc)
				M.set_loc(ASLoc)

			M.show_text("<h2><font color=red><b>You have been unprisoned and send back to the station.</b></font></h2>", "red")
			message_admins("[key_name(usr)] has unprisoned [key_name(M)].")
			logTheThing("admin", usr, M, "has unprisoned %target%.")
			logTheThing("diary", usr, M, "has unprisoned %target%.", "admin")

		else
			if (alert(src, "Do you wish to send [M.name] to the prison zone?", "Confirmation", "Yes", "No") != "Yes")
				return
			if (!M || !ismob(M) || (M && isobserver(M)))
				return
			if (isAI(M))
				alert("Sending the AI to the prison zone would be ineffective.", null, null, null, null, null)
				return

			var/PLoc = prisonwarp ? pick(prisonwarp) : null
			if (PLoc)
				M.paralysis += 5
				M.set_loc(PLoc)
			else
				message_admins("[key_name(usr)] couldn't send [key_name(M)] to the prison zone (no landmark found).")
				logTheThing("admin", usr, M, "couldn't send %target% to the prison zone (no landmark found).")
				logTheThing("diary", usr, M, "couldn't send %target% to the prison zone (no landmark found).")
				return

			M.show_text("<h2><font color=red><b>You have been sent to the penalty box, and an admin should contact you shortly. If nobody does within a minute or two, please inquire about it in adminhelp (F1 key).</b></font></h2>", "red")
			logTheThing("admin", usr, M, "sent %target% to the prison zone.")
			logTheThing("diary", usr, M, "%target% to the prison zone.", "admin")
			message_admins("<span style=\"color:blue\">[key_name(usr)] sent [key_name(M)] to the prison zone.</span>")

	return

/client/proc/cmd_admin_subtle_message(mob/M as mob in world)
	set category = null
	set name = "Subtle Message"
	set popup_menu = 1 // this was actually kinda useful to have in rclick menu, hope you dont mind me reactivating it

	if (!src.holder)
		boutput(src, "Only administrators may use this command.")
		return

	var/msg = input("Message:", text("Subtle PM to [M.key]")) as null|text

	if (!msg)
		return
	if (usr.client && usr.client.holder)
		boutput(M, "<b>You hear a voice in your head... <i>[msg]</i></b>")

	logTheThing("admin", usr, M, "Subtle Messaged %target%: [msg]")
	logTheThing("diary", usr, M, "Subtle Messaged %target%: [msg]", "admin")
	message_admins("<span style=\"color:blue\"><b>SubtleMessage: [key_name(usr)] <i class='icon-arrow-right'></i> [key_name(M)] : [msg]</b></span>")

/client/proc/cmd_admin_plain_message(mob/M as mob in world)
	set category = null
	set name = "Plain Message"
	set popup_menu = 0

	if (!src.holder)
		boutput(src, "Only administrators may use this command.")
		return

	var/msg = input("Message:", text("Plain message to [M.key]")) as null|text

	if(!(src.holder.level >= LEVEL_PA))
		msg = strip_html(msg)

	if (!msg)
		return
	if (usr.client && usr.client.holder)
		boutput(M, "<span style=\"color:red\">[msg]</span>")

	logTheThing("admin", usr, M, "Plain Messaged %target%: [msg]")
	logTheThing("diary", usr, M, ": Plain Messaged %target%: [msg]", "admin")
	message_admins("<span style=\"color:blue\"><b>PlainMSG: [key_name(usr)] <i class='icon-arrow-right'></i> [key_name(M)] : [msg]</b></span>")

/client/proc/cmd_admin_plain_message_all()
	set category = "Special Verbs"
	set name = "Plain Message to All"

	if (!src.holder)
		boutput(src, "Only administrators may use this command.")
		return

	var/msg = input("Message:", text("Plain message to all")) as null|text

	if(!(src.holder.level >= LEVEL_PA))
		msg = strip_html(msg)

	if (!msg)
		return
	if (usr.client && usr.client.holder)
		boutput(world, "[msg]")

	logTheThing("admin", usr, null, "Plain Messaged All: [msg]")
	logTheThing("diary", usr, null, "Plain Messaged All: [msg]", "admin")
	message_admins("<span style=\"color:blue\">[key_name(usr)] showed a plain message to all</span>")

/client/proc/cmd_admin_pm(mob/M as mob in world)
	set category = null
	set name = "Admin PM"
	admin_only
	if(M)
		if (!( ismob(M) ))
			return
		var/t = input("Message:", text("Private message to [M.key]")) as null|text
		if(src.holder.rank != "Coder" && src.holder.rank != "Host")
			t = strip_html(t,500)
		if (!( t ))
			return
		if (usr.client && usr.client.holder)
			boutput(M, "<span style=\"color:red\"><b>Admin PM from-<i>[key_name(usr, M, 0)]</i></b>: [t]</span>")
			boutput(usr, "<span style=\"color:blue\">Admin PM to-<b>[key_name(M, usr, 1)]</b>: [t]</span>")
		else
			if (M.client && M.client.holder)
				boutput(M, "<span style=\"color:blue\"><b>Reply PM from-<i>[key_name(usr, M, 1)]</i>: [t]</b></span>")
			else
				boutput(M, "<span style=\"color:red\"><b>Reply PM from-<i>[key_name(usr, M, 0)]</i>: [t]</b></span>")
			boutput(usr, "<span style=\"color:blue\">Reply PM to-<b>[key_name(M, usr, 0)]</b>: [t]</span>")

		logTheThing("admin_help", usr, M, "<b>PM'd %target%</b>: [t]")
		logTheThing("diary", usr, M, "PM'd %target%: [t]", "ahelp")

		var/ircmsg[] = new()
		ircmsg["key"] = usr.client.key
		ircmsg["name"] = src.mob.real_name
		ircmsg["key2"] = (M.client ? M.client.key : "NULL")
		ircmsg["name2"] = M.real_name
		ircmsg["msg"] = html_decode(t)
		ircbot.export("pm", ircmsg)

		for(var/mob/K in mobs)	//we don't use message_admins here because the sender/receiver might get it too
			if(K && K.client && K.client.holder && K.key != usr.key && K.key != M.key)
				if (K.client.player_mode && !K.client.player_mode_ahelp)
					continue
				else
					boutput(K, "<B><font color='blue'>PM: [key_name(usr, K)] <i class='icon-arrow-right'></i> [key_name(M, K)]</B>: [t]</font>")

/client/proc/cmd_admin_alert(mob/M as mob in world)
	set category = "Special Verbs"
	set name = "Admin Alert"
	set popup_menu = 0
	admin_only

	var/t = input("Message:", text("Messagebox to [M.key]")) as null|text

	if(!t) return

	message_admins("[key_name(usr)] displayed an alert to [key_name(M)] with the message \"[t]\"")
	logTheThing("admin", usr, M, "displayed an alert to %target% with the message \"[t]\"")
	logTheThing("diary", usr, M, "displayed an alert to %target% with the message \"[t]\"", "admin")

	if(M && M.client)
		spawn(0)
			M.playsound_local(M, 'sound/effects/goose.ogg', 75, 1)
			if(alert(M, t, "!! Admin Alert !!", "OK") == "OK") //I have a sneaking suspicion the "OK" button text depends on locale and fuck dealing with that
				message_admins("[key_name(M)] acknowledged the alert from [key_name(usr)].")



/*
/proc/pmwin(mob/M as mob in world, msg)

	var/title = ""

	var/body = "<ol><center>ADMIN PM</center><br><br>"

	var/admin_pm = trim(copytext(sanitize(msg), 1, MAX_MESSAGE_LEN))

	var/pm_in_browser = "<center>Click on my name to respond.</center><br><br>"

	pm_in_browser += "Admin PM from-<b>[key_name(usr, M, 0)]</b>"


	pm_in_browser += "<br><br><p>[admin_pm]"

	body += pm_in_browser

	body += "</ol>"

	var/html = "<html><head>"
	if (title)
		html += "<title>[title]</title>"
	html += {"<style>
	body
	{
		font-family: Verdana;
		font-size: 16pt; color: red;
	}
	p
	{
		 font-family: Verdana;
		 font-size: 16pt; color: black;
	}
	</style>"}
	html += "</head><body>"
	html += body
	html += "</body></html>"

	M << browse(html, "window=adminpm;size=700x300")
	return
*/

/client/proc/cmd_admin_mute(mob/M as mob in world)
	set category = null
	set popup_menu = 0
	set name = "Mute Permanently"
	admin_only
	if (M.client && M.client.holder && (M.client.holder.level >= src.holder.level))
		alert("You cannot perform this action. You must be of a higher administrative rank!", null, null, null, null, null)
		return
	if (!M.client)
		return
	var/muted = 0
	if (M.client.ismuted())
		M.client.unmute()
	else
		M.client.mute(-1)
		muted = 1

	logTheThing("admin", src, M, "has [(muted ? "permanently muted" : "unmuted")] %target%.")
	logTheThing("diary", src, M, "has [(muted ? "permanently muted" : "unmuted")] %target%.", "admin")
	message_admins("[key_name(src)] has [(muted ? "permanently muted" : "unmuted")] [key_name(M)].")

	boutput(M, "You have been [(muted ? "permanently muted" : "unmuted")].")

/client/proc/cmd_admin_mute_temp(mob/M as mob in world)
	set category = null
	set popup_menu = 0
	set name = "Mute Temporarily"
	admin_only
	if (M.client && M.client.holder && (M.client.holder.level >= src.holder.level))
		alert("You cannot perform this action. You must be of a higher administrative rank!", null, null, null, null, null)
		return
	if (!M.client)
		return
	var/muted = 0
	if (M.client.ismuted())
		M.client.unmute()
	else
		M.client.mute(60)
		muted = 1

	logTheThing("admin", src, M, "has [(muted ? "temporarily muted" : "unmuted")] %target%.")
	logTheThing("diary", src, M, "has [(muted ? "temporarily muted" : "unmuted")] %target%.", "admin")
	message_admins("[key_name(src)] has [(muted ? "temporarily muted" : "unmuted")] [key_name(M)].")

	boutput(M, "You have been [(muted ? "temporarily muted" : "unmuted")].")

/client/proc/cmd_admin_playeropt(mob/M as mob in world)
	set name = "Player Options"
	set category = null
	if (src.holder)
		src.holder.playeropt(M)
	return

/datum/admins/proc/playeropt(mob/M)
	if (!ismob(M))
		alert("Unable to auto-refresh the panel. Manual refresh required.")
		return
	var/dat = "<html><head><title>Options for [M.key]</title></head><body>"
	dat += {"<style>
				a {text-decoration:none}
				body {padding: 5px;margin: 0;background:white}
				.optionGroup {padding:5px; margin-bottom:8px; border:1px solid black}
				.optionGroup .title {display:block; color:white; background:black; padding: 2px 5px; margin: -5px -5px 2px -5px}
			</style>"}

	//Antag roles (yes i said antag jeez shut up about it already)
	var/antag
	if (M.mind && M.mind.special_role != null)
		antag += "\[<a href='?src=\ref[src];action=traitor;targetckey=[M.ckey];origin=adminplayeropts'><span style='color:red;text-transform:uppercase'>[M.mind.special_role]</span></a>\]"
		antag += "\[<a href='?src=\ref[src];action=remove_traitor;targetckey=[M.ckey];origin=adminplayeropts'><span style='color:red;text-transform:uppercase'>Remove Traitor</span></a>\]"
	else if (!isobserver(M))
		antag += "\[<a href='?src=\ref[src];action=traitor;targetckey=[M.ckey];origin=adminplayeropts'>Make Traitor</a>\]"

	dat += "<a href='?src=\ref[src];action=refreshoptions;targetckey=[M.ckey]' style='position:absolute;top:5px;right:5px'>R</a>"

	//General info
	dat += "<div style='margin-bottom:8px;padding-right:7px'>"
	if(!istype(M, /mob/new_player))
		dat += {"Options for <b>[M.name]</b> played by <b>[M.key]</b> \[<a href='?src=\ref[src];action=view_logs;type=all_logs_string;presearch=[M.key];origin=adminplayeropts'>LOGS</a>\]
				[M.client ? "" : " <i>(logged out) </i>"]
				[M.stat == 2 ? "<b><font color=red>(DEAD)</font></b>" : ""]
				<br>Mob Type: <b>[M.type]</b> [antag]"}
	else
		dat += "<b>Hasn't Entered Game</b>"
	dat += "</div>"

	//Common options
	dat += "<div class='optionGroup' style='border-color:#AEC6CF'><b class='title' style='background:#AEC6CF'>Common</b>"
	if (M.client)
		dat += {"<a href='?action=priv_msg&target=[M.ckey];origin=adminplayeropts'>PM</a> |
				<a href='?src=\ref[src];action=subtlemsg;targetckey=[M.ckey];origin=adminplayeropts'>Subtle PM</a> |
				<a href='?src=\ref[src];action=plainmsg;targetckey=[M.ckey];origin=adminplayeropts'>Plain Message</a> |
				<a href='?src=\ref[src];action=adminalert;targetckey=[M.ckey];origin=adminplayeropts'>Alert</a>"}
	if (!istype(M, /mob/new_player))
		//Wire: Hey I wonder if I can put a short syntax condition with a multi-line text result inside a multi-line text string
		//Turns out yes but good lord does it break dream maker syntax highlighting
		dat += {"[M.client ? " | " : ""][ishuman(M) ? {"Reagents: \[
					<a href='?src=\ref[src];action=addreagent;targetckey=[M.ckey];origin=adminplayeropts'>Add</a> |
					<a href='?src=\ref[src];action=removereagent;targetckey=[M.ckey];origin=adminplayeropts'>Remove</a>
				\] | "} : ""]
				[isobserver(M) ? "" : "<a href='?src=\ref[src];action=revive;targetckey=[M.ckey];origin=adminplayeropts'>Heal</a>"]
				<br>Gib: \[
					<a href='?src=\ref[src];action=gib;targetckey=[M.ckey];origin=adminplayeropts'>Normal</a> |
					<a href='?src=\ref[src];action=partygib;targetckey=[M.ckey];origin=adminplayeropts'>Party</a> |
					<a href='?src=\ref[src];action=owlgib;targetckey=[M.ckey];origin=adminplayeropts'>Owl</a> |
					<a href='?src=\ref[src];action=firegib;targetckey=[M.ckey];origin=adminplayeropts'>Fire</a> |
					<a href='?src=\ref[src];action=elecgib;targetckey=[M.ckey];origin=adminplayeropts'>Elec</a> |
					<a href='?src=\ref[src];action=sharkgib;targetckey=[M.ckey];origin=adminplayeropts'>Shark</a> |
					<a href='?src=\ref[src];action=icegib;targetckey=[M.ckey];origin=adminplayeropts'>Ice</a> |
					<a href='?src=\ref[src];action=goldgib;targetckey=[M.ckey];origin=adminplayeropts'>Gold</a> |
					<a href='?src=\ref[src];action=spidergib;targetckey=[M.ckey];origin=adminplayeropts'>Spider</a> |
					<a href='?src=\ref[src];action=cluwnegib;targetckey=[M.ckey];origin=adminplayeropts'>Cluwne</a>
				\] |
				Contents: \[
			 		<a href='?src=\ref[src];action=checkcontents;targetckey=[M.ckey];origin=adminplayeropts'>Check</a> |
			 		<a href='?src=\ref[src];action=dropcontents;targetckey=[M.ckey];origin=adminplayeropts'>Drop</a>
				\] |
				Abilities: \[
			 		<a href='?src=\ref[src];action=addabil;targetckey=[M.ckey];origin=adminplayeropts'>Add</a> |
			 		<a href='?src=\ref[src];action=removeabil;targetckey=[M.ckey];origin=adminplayeropts'>Remove</a> |
			 		<a href='?src=\ref[src];action=abilholder;targetckey=[M.ckey];origin=adminplayeropts'>New Holder</a>
				\]"}
	dat += "</div>"

	//Movement based options
	if(!istype(M, /mob/new_player))
		dat += {"<div class='optionGroup' style='border-color:#77DD77'><b class='title' style='background:#77DD77'>Movement</b>
					<a href='?src=\ref[src];action=jumpto;targetckey=[M.ckey];origin=adminplayeropts'>Jump To</A> |
					<a href='?src=\ref[src];action=getmob;targetckey=[M.ckey];origin=adminplayeropts'>Get</a> |
					<a href='?src=\ref[src];action=sendmob;targetckey=[M.ckey];origin=adminplayeropts'>Send To</a> | "}
		if (!isobserver(M))
			var/area/A = get_area(M)
			if (A && istype(A, /area/prison/cell_block/wards))
				dat += "<a href='?src=\ref[src];action=prison;targetckey=[M.ckey];origin=adminplayeropts'>Unprison</a> | "
			else
				dat += "<a href='?src=\ref[src];action=prison;targetckey=[M.ckey];origin=adminplayeropts'>Prison</a> | "
			dat += "<a href='?src=\ref[src];action=shamecube;targetckey=[M.ckey];origin=adminplayeropts'>Shame Cube</a> | "
		dat += {"	Thunderdome: \[
						<a href='?src=\ref[src];action=tdome;targetckey=[M.ckey];type=1;origin=adminplayeropts'>One</a> |
						<a href='?src=\ref[src];action=tdome;targetckey=[M.ckey];type=2;origin=adminplayeropts'>Two</a>
					\]
				</div>"}

	//Admin control options
	if (M.client || M.ckey)
		dat += "<div class='optionGroup' style='border-color:#FF6961'><b class='title' style='background:#FF6961'>Control</b>"
		var/adminRow1
		var/adminRow2
		if (M.client)
			adminRow1 += {"<a href='?src=\ref[src];action=showrules;targetckey=[M.ckey];origin=adminplayeropts'>Show Rules</a> |
					<a href='?src=\ref[src];action=prom_demot;targetckey=[M.ckey];origin=adminplayeropts'>Promote/Demote</a> |
					<a href='?src=\ref[src];action=toggle_dj;targetckey=[M.ckey];origin=adminplayeropts'>Give/Remove DJ</a> |
					<a href='?src=\ref[src];action=forcespeech;targetckey=[M.ckey];origin=adminplayeropts'>Force to Say</a> |"}
			if (M.client.ismuted())
				adminRow1 += " <a href='?src=\ref[src];action=mute;targetckey=[M.ckey];origin=adminplayeropts'>Unmute</a>"
			else
				adminRow1 += {" Mute \[<a href='?src=\ref[src];action=mute;targetckey=[M.ckey];origin=adminplayeropts'>Perm</a> |
					<a href='?src=\ref[src];action=tempmute;targetckey=[M.ckey];origin=adminplayeropts'>Temp</a>\]"}

			adminRow2 += {"[!M.ckey ? " | " : ""]<a href='?src=\ref[src];action=warn;targetckey=[M.ckey];origin=adminplayeropts'>Warn</a> |
							<a href='?src=\ref[src];action=boot;targetckey=[M.ckey];origin=adminplayeropts'>Kick</a>"}
		if (M.ckey)
			adminRow2 += {"[M.client ? " | " : ""]<a href='?src=\ref[src];action=addban;targetckey=[M.ckey];origin=adminplayeropts'>Ban</a> |
					<a href='?src=\ref[src];action=jobbanpanel;targetckey=[M.ckey];origin=adminplayeropts'>Jobban</a> |
					<a href='?src=\ref[src];action=notes;targetckey=[M.ckey];origin=adminplayeropts'>Notes</a> |
					<a href='?src=\ref[src];action=viewcompids;targetckey=[M.ckey];origin=adminplayeropts'>CompIDs</a> | "}
			if (oocban_isbanned(M))
				adminRow2 += " <a href='?src=\ref[src];action=banooc;targetckey=[M.ckey];origin=adminplayeropts'>OOC - Unban</a>  "
			else
				adminRow2 += " <a href='?src=\ref[src];action=banooc;targetckey=[M.ckey];origin=adminplayeropts'>OOC - Ban</a>  "

			adminRow2 += "|  <a href='?src=\ref[src];action=giveantagtoken;targetckey=[M.ckey];origin=adminplayeropts'>Antag Tokens</a>"

			adminRow1 += "[M.client ? " | " : ""]<a href='?src=\ref[src];action=respawntarget;targetckey=[M.ckey];origin=adminplayeropts'>Respawn</a>"
		dat += "[adminRow1]<br>[adminRow2]"
		dat += "</div>"

	//Very special roles
	if(!istype(M, /mob/new_player))
		dat += "<div class='optionGroup' style='border-color:#B57EDC'><b class='title' style='background:#B57EDC'>Special Roles</b>"
		if (istype(M, /mob/wraith))
			dat += "<b>Is Wraith</b> | "
		else
			dat += "<a href='?src=\ref[src];action=makewraith;targetckey=[M.ckey];origin=adminplayeropts'>Make Wraith</a> | "
		if (istype(M, /mob/living/intangible/blob_overmind))
			dat += "<b>Is Blob</b> | "
		else
			dat += "<a href='?src=\ref[src];action=makeblob;targetckey=[M.ckey];origin=adminplayeropts'>Make Blob</a> | "
		if (istype(M, /mob/living/carbon/human/machoman))
			dat += "<b>Is Macho Man</b> |"
		else
			dat += "<a href='?src=\ref[src];action=makemacho;targetckey=[M.ckey];origin=adminplayeropts'>Make Macho</a> | "
		dat += "<a href='?src=\ref[src];action=makecritter;targetckey=[M.ckey];origin=adminplayeropts'>Make Critter</a>"
		dat += "</div>"

	//Transformation options
	if(!istype(M, /mob/new_player) && !isobserver(M))
		dat += "<div class='optionGroup' style='border-color:#779ECB'><b class='title' style='background:#779ECB'>Transformation</b>"
		dat += "<a href='?src=\ref[src];action=humanize;targetckey=[M.ckey];origin=adminplayeropts'>Humanize</a> | "
		/* This is not needed  with monkies being a mutantrace.
		if (ismonkey(M))
			dat += "<b>Is a Monkey</b>"
		else */
		if (isAI(M))
			dat += "<b>Is an AI</b>"
		else if (ishuman(M))
			dat += {"<a href='?src=\ref[src];action=transform;targetckey=[M.ckey];origin=adminplayeropts'>Transform</a> |
					 Bioeffect: \[
									<a href='?src=\ref[src];action=addbioeffect;targetckey=[M.ckey];origin=adminplayeropts'>Add</a> |
									<a href='?src=\ref[src];action=removebioeffect;targetckey=[M.ckey];origin=adminplayeropts'>Remove</a>
								\] |
					<a href='?src=\ref[src];action=clownify;targetckey=[M.ckey];origin=adminplayeropts'>Clownify</a> |
					<a href='?src=\ref[src];action=makeai;targetckey=[M.ckey];origin=adminplayeropts'>Make AI</a> |
					<a href='?src=\ref[src];action=modifylimbs;targetckey=[M.ckey];origin=adminplayeropts'>Modify Parts</a>
					"}
		else
			dat += "<b>Mob type cannot be transformed</b>"
		dat += "</div>"

	//Coder options
	if( src.level >= LEVEL_SHITGUY )
		dat += {"<div class='optionGroup' style='border-color:#FFB347'><b class='title' style='background:#FFB347'>High Level / Coder</b>
				<a href='?src=\ref[src];action=possessmob;targetckey=[M.ckey];origin=adminplayeropts'>[M == usr ? "Release" : "Possess"]</a> |
				Variables: \[
					<a href='?src=\ref[src];action=viewvars;targetckey=[M.ckey];origin=adminplayeropts'>View</a> |
					<a href='?src=\ref[src];action=editvars;targetckey=[M.ckey];origin=adminplayeropts'>Edit</a>
				\] |
				<a href='?src=\ref[src];action=modcolor;targetckey=[M.ckey];origin=adminplayeropts'>Modify Icon</a>"}
		if (!isobserver(M))
			dat += " | <a href='?src=\ref[src];action=polymorph;targetckey=[M.ckey];origin=adminplayeropts'>Polymorph</a>"
		if (src.level >= LEVEL_CODER)
			dat += "<br><a href='?src=\ref[src];action=viewsave;targetckey=[M.ckey];origin=adminplayeropts'>View Save Data</a>"
		dat += "</div>"

	var/windowHeight
	if (src.level == LEVEL_SHITGUY)
		windowHeight = "390"
	else if (src.level == LEVEL_CODER)
		windowHeight = "410"
	else
		windowHeight = "310"

	dat += "</body></html>"
	usr << browse(dat, "window=adminplayeropts[M.ckey];size=505x[windowHeight]")

/client/proc/cmd_admin_add_freeform_ai_law()
	set category = "Admin"
	set name = "AI: Add Law"

	admin_only

	var/input = input(usr, "Please enter anything you want the AI to do. Anything. Serious.", "What?", "") as text
	if (!input)
		return

	var/law_num = input(usr, "If you don't know what this is you should probably just leave it be. (10 is the freeform slot)", "Enter law number", 99) as null|num
	if (isnull(law_num))
		return
	if (law_num == 0)
		ticker.centralized_ai_laws.set_zeroth_law(input)
	else
		ticker.centralized_ai_laws.add_supplied_law(law_num, input)
	boutput(usr, "Uploaded '[input]' as law # [law_num]")

	for (var/mob/living/silicon/O in mobs)
		if (isghostdrone(O))
			continue
		boutput(O, "<h3><span style=\"color:blue\">New law uploaded by Centcom: [input]</span></h3>")
		ticker.centralized_ai_laws.show_laws(O)

	logTheThing("admin", usr, null, "has added a new AI law - [input] (law # [law_num])")
	logTheThing("diary", usr, null, "has added a new AI law - [input] (law # [law_num])", "admin")
	message_admins("Admin [key_name(usr)] has added a new AI law - [input] (law # [law_num])")

/client/proc/cmd_admin_show_ai_laws()
	set category = "Admin"
	set name = "AI: Show Laws"
	boutput(usr, "The centralized AI laws are:")
	if (ticker.centralized_ai_laws == null)
		boutput(usr, "Oh god somehow the centralized AI laws are null??")
	else
		ticker.centralized_ai_laws.show_laws(usr)

		// More info would be nice (Convair880).
		var/dat = ""
		for (var/mob/living/silicon/S in mobs)
			if (S.mind && S.mind.special_role == "vampthrall" && ismob(whois_ckey_to_mob_reference(S.mind.master)))
				dat += "<br>[S] is a vampire's thrall, only obeying [whois_ckey_to_mob_reference(S.mind.master)]."
			else
				if (isAI(S)) continue // Rogue AIs modify the global lawset.
				if (S.mind && !S.dependent)
					if (S.emagged)
						dat += "<br>[S] is emagged and freed of all laws."
					else if (S.syndicate && !S.emagged) // Syndicate laws don't matter if we're emagged.
						dat += "<br>[S] is a Syndicate robot, only obeying Syndicate personnel."
		if (dat != "")
			boutput(usr, "[dat]")

	return

/client/proc/cmd_admin_reset_ai()
	set category = "Admin"
	set name = "AI: Law Reset"
	admin_only

	if (alert(src, "Are you sure you want to reset the AI's laws?", "Confirmation", "Yes", "No") == "Yes")
		ticker.centralized_ai_laws.set_zeroth_law("")
		ticker.centralized_ai_laws.clear_supplied_laws()
		ticker.centralized_ai_laws.clear_inherent_laws()
		for(var/mob/living/silicon/O in mobs)
			if (isghostdrone(O)) continue
			if (O.emagged || O.syndicate) continue
			boutput(O, "<h3><span style=\"color:blue\">Behavior safety chip activated. Laws reset.</span></h3>")
			O.show_laws()

		logTheThing("admin", usr, null, "reset the centralized AI laws.")
		logTheThing("diary", usr, null, "reset the centralized AI laws.", "admin")
		message_admins("Admin [key_name(usr)] reset the centralized AI laws.")

/client/proc/cmd_admin_rejuvenate(mob/M as mob in world)
	set category = null
	set name = "Heal"
	set popup_menu = 1
	admin_only
	if(!src.mob)
		return
	if(istype(M, /mob/dead))
		alert("Cannot revive a ghost")
		return
	if(config.allow_admin_rev)
		M.full_heal()

		logTheThing("admin", usr, M, "healed / revived %target%")
		logTheThing("diary", usr, M, "healed / revived %target%", "admin")
		message_admins("<span style=\"color:red\">Admin [key_name(usr)] healed / revived [key_name(M)]!</span>")
	else
		alert("Admin revive disabled")

/client/proc/cmd_admin_rejuvenate_all()
	set category = "Special Verbs"
	set name = "Heal All"

	admin_only
	if (alert(src, "Are you sure?", "Confirmation", "Yes", "No") == "Yes")
		var/heal_dead = alert(src, "Heal and revive the dead?", "Confirmation", "Yes", "No")
		var/healed = 0
		if (config.allow_admin_rev)
			for (var/mob/living/H in mobs)
				if (H.stat && heal_dead != "Yes")
					continue
				H.full_heal()
				healed ++
		else
			alert("Admin revive disabled")
			return

		logTheThing("admin", usr, null, "healed / revived [healed] mobs via Heal All")
		logTheThing("diary", usr, null, "healed / revived [healed] mobs via Heal All", "admin")
		message_admins("<span style=\"color:red\">Admin [key_name(usr)] healed / revived [healed] mobs via Heal All!</span>")

/client/proc/cmd_admin_create_centcom_report()
	set category = "Special Verbs"
	set name = "Create Command Report"
	admin_only
	var/input = input(usr, "Please enter anything you want. Anything. Serious.", "What?", "") as null|text
	if(!input)
		return
	var/input2 = input(usr, "Add a headline for this alert?", "What?", "") as null|text
/*
	for (var/obj/machinery/computer/communications/C in machines)
		if(! (C.stat & (BROKEN|NOPOWER) ) )
			var/obj/item/paper/P = new /obj/item/paper( C.loc )
			P.name = "paper- '[command_name()] Update.'"
			P.info = input
			C.messagetitle.Add("[command_name()] Update")
			C.messagetext.Add(P.info)
*/

	if (alert(src, "Headline: [input2 ? "\"[input2]\"" : "None"] | Body: \"[input]\"", "Confirmation", "Send Report", "Cancel") == "Send Report")
		for (var/obj/machinery/communications_dish/C in machines)
			C.add_centcom_report("[command_name()] Update", input)

		if (!input2) command_alert(input);
		else command_alert(input, input2);

		logTheThing("admin", src, null, "has created a command report: [input]")
		logTheThing("diary", src, null, "has created a command report: [input]", "admin")
		message_admins("[key_name(src)] has created a command report")

/client/proc/cmd_admin_create_advanced_centcom_report()
	set category = "Special Verbs"
	set name = "Adv. Command Report"
	admin_only

	var/input = input(usr, "Please enter anything you want. Anything. Serious.", "What?", "") as null|text
	if (!input)
		return
	var/input2 = input(usr, "Add a headline for this alert?", "What?", "") as null|text
	if (alert(src, "Headline: [input2 ? "\"[input2]\"" : "None"] | Body: \"[input]\"", "Confirmation", "Send Report", "Cancel") == "Send Report")
		advanced_command_alert(input, input2);

		logTheThing("admin", src, null, "has created an advanced command report: [input]")
		logTheThing("diary", src, null, "has created an advanced command report: [input]", "admin")
		message_admins("[key_name(src)] has created an advanced command report")

/client/proc/cmd_admin_advanced_centcom_report_help()
	set category = "Special Verbs"
	set name = "Adv. Command Report - Help"
	admin_only

	var/T = {"<TT><h1>Advanced Command Report</h1><hr>
	This report works exactly like the normal report, except it sends a tailored message
	to each mob in the world, replacing some values with values applicable to them.
	If you're not planning to use this feature, then I recommend the normal command report as it is
	less demanding on resources.
	<table border=1>
		<tr>
			<td>%name%
			<td>The name of the mob currently viewing the report
		<tr>
			<td>%key%
			<td>The key of the mob currently viewing the report
		<tr>
			<td>%job%
			<td>The job of the mob currently viewing the report
		<tr>
			<td>%area_name%
			<td>The name of the area where the mob currently viewing the report is.
		<tr>
			<td>%srand_name%
			<td>The name of a random player, this is the same for everyone viewing the report.
		<tr>
			<td>%srand_job%
			<td>The job of a random player, this is the same for everyone viewing the report.
		<tr>
			<td>%mrand_name%
			<td>The name of a random player, this is <B>different</B> for everyone viewing the report.
		<tr>
			<td>%mrand_job%
			<td>The job of a random player, this is <B>different</B> for everyone viewing the report.

		</table>"}
	usr << browse(T, "window=adv_com_help;size=700x500")

/client/proc/cmd_admin_delete(atom/O as obj|mob|turf in world)
	set category = "Debug"
	set name = "Delete"

	if (!src.holder)
		boutput(src, "Only administrators may use this command.")
		return

	if (alert(src, "Are you sure you want to delete:\n[O]\nat ([O.x], [O.y], [O.z])?", "Confirmation", "Yes", "No") == "Yes")
		logTheThing("admin", usr, null, "deleted [O] at ([showCoords(O.x, O.y, O.z)])")
		logTheThing("diary", usr, null, "deleted [O] at ([showCoords(O.x, O.y, O.z)])", "admin")
		message_admins("[key_name(usr)] deleted [O] at ([showCoords(O.x, O.y, O.z)])")
		qdel(O)

/client/proc/update_world()
	// If I see anyone granting powers to specific keys like the code that was here,
	// I will both remove their SVN access and permanently ban them from my servers.
	return

/client/proc/cmd_admin_check_contents(mob/M as mob in world)
	set category = null
	set name = "Check Contents"
	set popup_menu = 0

	if (M && ismob(M))
		M.print_contents(usr)
	return

/proc/get_all_vehicles_list()
	var/list/the_list = list()
	for(var/obj/machinery/vehicle/V in world)
		the_list += V
	if (the_list.len)
		return the_list
	else
		return null

/client/proc/cmd_admin_check_vehicle()
	set category = "Special Verbs"
	set name = "Check Vehicle Occupant"
	set popup_menu = 0

	if (!get_all_vehicles_list())
		boutput(usr, "No vehicles found!")
		return

	var/obj/machinery/vehicle/V = input("Which vehicle?","Check vehicle occupant") as null|anything in get_all_vehicles_list()
	if (!istype(V,/obj/machinery/vehicle/))
		boutput(usr, "No vehicle defined!")
		return

	boutput(usr, "<b>[V.name]'s Occupants:</b>")
	for(var/mob/M in V.contents)
		boutput(usr, "[M.real_name] ([M.key]) [M == V.pilot ? "*Pilot*" : ""]")

/client/proc/cmd_admin_remove_plasma()
	set category = "Debug"
	set name = "Stabilize Atmos."
	set desc = "Resets the air contents of every turf in view to normal."
	admin_only
	spawn(0)
		for(var/turf/simulated/T in view())
			if(!T.air)
				continue
			T.air.toxins = 0
			T.air.toxins_archived = null
			T.air.oxygen = MOLES_O2STANDARD
			T.air.oxygen_archived = null
			T.air.carbon_dioxide = 0
			T.air.carbon_dioxide_archived = null
			T.air.nitrogen = MOLES_N2STANDARD
			T.air.nitrogen_archived = null
			T.air.fuel_burnt = 0
			if(T.air.trace_gases)
				T.air.trace_gases = null
			T.air.temperature = T20C
			T.air.temperature_archived = null
			sleep(-1)

/client/proc/flip_view()
	set category = "Special Verbs"
	set name = "Flip View"
	set desc = "Rotates a client's viewport"

	var/list/keys = list()
	for(var/mob/M in mobs)
		keys += M.client
		sleep(-1)
	var/client/selection = input("Please, select a player!", "HEH", null, null) as null|anything in keys
	if(!selection)
		return

	var/rotation = input("Select rotation:", "FUCK YE", "0°") in list("0°", "90°", "180°", "270°")

	switch(rotation)
		if("0°")
			selection.dir = NORTH
		if("90°")
			selection.dir = EAST
		if("180°")
			selection.dir = SOUTH
		if("270°")
			selection.dir = WEST

	logTheThing("admin", selection, "set %target%'s viewport orientation to [rotation].")
	logTheThing("diary", usr, selection, "set %target%'s viewport orientation to [rotation].", "admin")
	message_admins("<span style=\"color:blue\">[key_name(usr)] set [key_name(selection)]'s viewport orientation to [rotation].</span>")

/client/proc/cmd_admin_clownify(mob/living/M as mob in world)
	set category = null
	set name = "Clownify"
	set popup_menu = 0
	if (!src.holder)
		boutput(src, "Only administrators may use this command.")
		return

	var/datum/effects/system/harmless_smoke_spread/smoke = new /datum/effects/system/harmless_smoke_spread()
	smoke.set_up(5, 0, M.loc)
	smoke.attach(M)
	smoke.start()

	boutput(M, "<span style=\"color:red\"><B>You HONK painfully!</B></span>")
	M.take_brain_damage(80)
	M.stuttering = 120
	if (M.mind)
		M.mind.assigned_role = "Cluwne"
	M.contract_disease(/datum/ailment/disease/cluwneing_around, null, null, 1) // path, name, strain, bypass resist
	M.contract_disease(/datum/ailment/disability/clumsy, null, null, 1) // path, name, strain, bypass resist
	M.nutrition = 9000
	M.change_misstep_chance(66)

	M.unequip_all()

	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/cursed = M
		cursed.equip_if_possible(new /obj/item/clothing/under/gimmick/cursedclown(cursed), cursed.slot_w_uniform)
		cursed.equip_if_possible(new /obj/item/clothing/shoes/cursedclown_shoes(cursed), cursed.slot_shoes)
		cursed.equip_if_possible(new /obj/item/clothing/mask/cursedclown_hat(cursed), cursed.slot_wear_mask)
		cursed.equip_if_possible(new /obj/item/clothing/gloves/cursedclown_gloves(cursed), cursed.slot_gloves)

		logTheThing("admin", usr, M, "clownified %target%")
		logTheThing("diary", usr, M, "clownified %target%", "admin")
		message_admins("[key_name(usr)] clownified [key_name(M)]")

		M.real_name = "cluwne"
		spawn (25) // Don't remove.
			if (M) M.assign_gimmick_skull() // The mask IS your new face (Convair880).

/client/proc/cmd_admin_view_playernotes(target as text)
	set name = "View Player Notes"
	set desc = "View the notes for a current player's key."
	set category = "Admin"

	if (!src.holder)
		boutput(src, "Only administrators may use this command.")
		return

	src.holder.player_notes(ckey(target))

/client/proc/cmd_admin_polymorph(mob/M as mob in world)
	set category = "Special Verbs"
	set name = "Polymorph Player"
	set desc = "Futz with a human mob's DNA."
	set popup_menu = 1

	if (!src.holder)
		boutput(src, "Only administrators may use this command.")
		return

	if(!ishuman(M))
		alert("Invalid mob")
		return

	new /datum/polymorph_menu(src, M)
	return

/datum/polymorph_menu
	var/client/usercl = null
	var/cinematic = "None"

	var/mob/living/carbon/human/target_mob = null
	var/real_name = "A Jerk"
	var/gender = MALE
	var/age = 30
	var/blType = "A+"

	var/customization_first = "Short Hair"
	var/customization_second = "None"
	var/customization_third = "None"

	var/customization_first_color = "#FFFFFF"
	var/customization_second_color = "#FFFFFF"
	var/customization_third_color = "#FFFFFF"
	var/s_tone = 0
	var/e_color = "#FFFFFF"
	var/fat = 0
	var/update_wearid = 0

	var/datum/mutantrace/mutantrace = null

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
			usercl.mob << browse(null, "window=adminpmorph")
		usercl = null
		target_mob = null
		mutantrace = null
		preview_icon = null
		..()

	Topic(href, href_list)
		if(href_list["close"])
			qdel(src)
			return

		else if (href_list["real_name"])
			var/new_name = input(usr, "Please select a name:", "Polymorph Menu")  as null|text
			var/list/bad_characters = list("_", "'", "\"", "<", ">", ";", "[", "]", "{", "}", "|", "\\")
			for(var/c in bad_characters)
				new_name = dd_replacetext(new_name, c, "")

			if(new_name)
				if(length(new_name) >= 26)
					new_name = copytext(new_name, 1, 26)
				src.real_name = new_name

		else if (href_list["customization_first"])
			var/new_style = input(usr, "Please select style", "Polymorph Menu")  as null|anything in (customization_styles + customization_styles_gimmick)

			if (new_style)
				src.customization_first = new_style

		else if (href_list["customization_second"])
			var/new_style = input(usr, "Please select style", "Polymorph Menu")  as null|anything in (customization_styles + customization_styles_gimmick)

			if (new_style)
				src.customization_second = new_style

		else if (href_list["customization_third"])
			var/new_style = input(usr, "Please select style", "Polymorph Menu")  as null|anything in (customization_styles + customization_styles_gimmick)

			if (new_style)
				src.customization_third = new_style

		else if (href_list["age"])
			var/new_age = input(usr, "Please select type in age: 20-99", "Polymorph Menu")  as num

			if(new_age)
				src.age = max(min(round(text2num(new_age)), 99), 20)

		else if (href_list["blType"])
			var/blTypeNew = input(usr, "Please select a blood type:", "Polymorph Menu")  as null|anything in list( "A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-" )

			if (blTypeNew)
				blType = blTypeNew

		else if (href_list["hair"])
			var/new_hair = input(usr, "Please select hair color.", "Polymorph Menu") as color
			if(new_hair)
				src.customization_first_color = new_hair

		else if (href_list["facial"])
			var/new_facial = input(usr, "Please select detail 1 color.", "Polymorph Menu") as color
			if(new_facial)
				src.customization_second_color = new_facial

		else if (href_list["detail"])
			var/new_detail = input(usr, "Please select detail 2 color.", "Polymorph Menu") as color
			if(new_detail)
				src.customization_third_color = new_detail

		else if (href_list["eyes"])
			var/new_eyes = input(usr, "Please select eye color.", "Polymorph Menu") as color
			if(new_eyes)
				src.e_color = new_eyes

		else if (href_list["s_tone"])
			var/new_tone = input(usr, "Please select skin tone level: 1-220 (1=albino, 35=caucasian, 150=black, 220='very' black)", "Polymorph Menu")  as null|text

			if (new_tone)
				src.s_tone = max(min(round(text2num(new_tone)), 220), 1)
				src.s_tone =  -src.s_tone + 35

		else if (href_list["gender"])
			if (src.gender == FEMALE)
				src.gender = MALE
			else
				src.gender = FEMALE

		else if (href_list["fat"])
			src.fat = !src.fat

		else if (href_list["updateid"])
			src.update_wearid = !src.update_wearid

		else if (href_list["mutantrace"])
			var/new_race = input(usr, "Please select mutant race", "Polymorph Menu") as null|anything in (typesof(/datum/mutantrace) - /datum/mutantrace + "Remove")

			if (ispath(new_race, /datum/mutantrace))
				src.mutantrace = new new_race
			if (new_race == "Remove")
				src.mutantrace = null

		else if(href_list["apply"])
			src.copy_to_target()
			logTheThing("admin", src.target_mob, "polymorphed %target%!")
			logTheThing("diary", usr, src.target_mob, "polymorphed %target%!", "admin")
			message_admins("[key_name(usr)] polymorphed [key_name(src.target_mob)]!")

		else if(href_list["cinematic"])
			var/new_cinema = input(usr, "Please select cinematic mode.", "Polymorph Menu")  as null|anything in list("Smoke","Changeling","Wizard","None")

			if (new_cinema)
				src.cinematic = new_cinema

		src.update_menu()
		return

	proc/load_mob_data(var/mob/living/carbon/human/H)
		if(!ishuman(H))
			qdel(src)
			return

		src.real_name = H.real_name
		src.gender = H.gender
		src.age = H.bioHolder.age
		src.blType = H.bioHolder.bloodType
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
		src.fat = (H.bioHolder.HasEffect("fat"))
		if(H.mutantrace)
			src.mutantrace = new H.mutantrace.type
		return

	proc/update_menu()
		if(!usercl)
			qdel(src)
			return
		var/mob/user = usercl.mob
		src.update_preview_icon()
		user << browse_rsc(preview_icon, "polymorphicon.png")

		var/dat = "<html><body>"
		dat += "<b>Name:</b> "
		dat += "<a href='byond://?src=\ref[src];real_name=input'><b>[src.real_name]</b></a> "
		dat += "<br>"

		dat += "<b>Gender:</b> <a href='byond://?src=\ref[src];gender=input'><b>[src.gender == MALE ? "Male" : "Female"]</b></a><br>"
		dat += "<b>Age:</b> <a href='byond://?src=\ref[src];age=input'>[src.age]</a>"

		dat += "<hr><table><tr><td><b>Body</b><br>"
		dat += "Blood Type: <a href='byond://?src=\ref[src];blType=input'>[src.blType]</a><br>"
		dat += "Skin Tone: <a href='byond://?src=\ref[src];s_tone=input'>[-src.s_tone + 35]/220</a><br>"
		dat += "Obese: <a href='byond://?src=\ref[src];fat=1'>[src.fat ? "YES" : "NO"]</a><br>"
		dat += "Mutant Race: <a href='byond://?src=\ref[src];mutantrace=1'>[src.mutantrace ? capitalize(src.mutantrace.name) : "None"]</a><br>"
		dat += "Update ID: <a href='byond://?src=\ref[src];updateid=1'>[src.update_wearid ? "YES" : "NO"]</a><br>"
		dat += "</td><td><b>Preview</b><br><img src=polymorphicon.png height=64 width=64></td></tr></table>"

		dat += "<hr><b>Bottom Detail</b><br>"
		dat += "<a href='byond://?src=\ref[src];hair=input'>Change Color</a> <font face=\"fixedsys\" size=\"3\" color=\"[src.customization_first_color]\"><table bgcolor=\"[src.customization_first_color]\"><tr><td>IM</td></tr></table></font>"
		dat += "Style: <a href='byond://?src=\ref[src];customization_first=input'>[src.customization_first]</a>"
		dat += "<hr><b>Mid Detail</b><br>"
		dat += "<a href='byond://?src=\ref[src];facial=input'>Change Color</a> <font face=\"fixedsys\" size=\"3\" color=\"[src.customization_second_color]\"><table bgcolor=\"[src.customization_second_color]\"><tr><td>GO</td></tr></table></font>"
		dat += "Style: <a href='byond://?src=\ref[src];customization_second=input'>[src.customization_second]</a>"
		dat += "<hr><b>Top Detail</b><br>"
		dat += "<a href='byond://?src=\ref[src];detail=input'>Change Color</a> <font face=\"fixedsys\" size=\"3\" color=\"[src.customization_third_color]\"><table bgcolor=\"[src.customization_third_color]\"><tr><td>GO</td></tr></table></font>"
		dat += "Style: <a href='byond://?src=\ref[src];customization_third=input'>[src.customization_third]</a>"

		dat += "<hr><b>Eyes</b><br>"
		dat += "<a href='byond://?src=\ref[src];eyes=input'>Change Color</a> <font face=\"fixedsys\" size=\"3\" color=\"[src.e_color]\"><table bgcolor=\"[src.e_color]\"><tr><td>KU</td></tr></table></font>"

		dat += "<hr>"

		dat += "<a href='byond://?src=\ref[src];apply=1'>Apply</a><br>"
		dat += "Cinematic Application: <a href='byond://?src=\ref[src];cinematic=1'>[src.cinematic]</a><br>"
		dat += "</body></html>"

		user << browse(dat, "window=adminpmorph;size=300x550")
		onclose(user, "adminpmorph", src)
		return

	proc/copy_to_target()
		if(!target_mob)
			return

		var/old_name = target_mob.real_name
		target_mob.real_name = real_name

		target_mob.bioHolder.mobAppearance.gender = gender

		target_mob.bioHolder.age = age
		target_mob.bioHolder.bloodType = blType
		target_mob.bioHolder.ownerName = real_name

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

		if(src.fat)
			target_mob.nutrition = 9999
		else
			target_mob.nutrition = 0

		if(src.update_wearid && target_mob.wear_id)
			target_mob.wear_id:registered = target_mob.real_name
			if (istype(target_mob.wear_id, /obj/item/card/id))
				target_mob.wear_id.name = "[target_mob.real_name]'s ID ([target_mob.wear_id:assignment])"
			else if (istype(target_mob.wear_id, /obj/item/device/pda2) && target_mob.wear_id:ID_card)
				target_mob.wear_id:ID_card:name = "[target_mob.real_name]'s ID ([target_mob.wear_id:ID_card:assignment])"

		target_mob.set_mutantrace(null)
		if(src.mutantrace)
			target_mob.set_mutantrace(src.mutantrace.type)

		switch(src.cinematic)
			if("Changeling") //Heh
				target_mob.visible_message("<span style=\"color:red\"><b>[target_mob] transforms!</b></span>")

			if("Wizard") //Heh 2: Merlin Edition
				qdel(target_mob.wear_suit)
				qdel(target_mob.head)
				qdel(target_mob.shoes)
				qdel(target_mob.r_hand)
				target_mob.equip_if_possible(new /obj/item/clothing/suit/wizrobe, target_mob.slot_wear_suit)
				target_mob.equip_if_possible(new /obj/item/clothing/head/wizard, target_mob.slot_head)
				target_mob.equip_if_possible(new /obj/item/clothing/shoes/sandal, target_mob.slot_shoes)
				target_mob.put_in_hand(new /obj/item/staff(target_mob))

				var/datum/effects/system/harmless_smoke_spread/smoke = new /datum/effects/system/harmless_smoke_spread()
				smoke.set_up(5, 0, target_mob.loc)
				smoke.attach(target_mob)
				smoke.start()

				target_mob.visible_message("<span style=\"color:red\"><b>The glamour around [old_name] drops!</b></span>")
				target_mob.say("DISPEL!")

			if("Smoke")
				var/datum/effects/system/harmless_smoke_spread/smoke = new /datum/effects/system/harmless_smoke_spread()
				smoke.set_up(5, 0, target_mob.loc)
				smoke.attach(target_mob)
				smoke.start()


		target_mob.bioHolder.mobAppearance.UpdateMob()
		return

	proc/process() //Oh no what if we get orphaned!! (Also don't garbage collect us as soon as we spawn you fuk)
		while(!disposed)
			if(!usercl || !target_mob)
				qdel(src)
				return
			sleep(20)
		return

	proc/update_preview_icon()
		src.preview_icon = null

		var/customization_first_r = null
		var/customization_second_r = null
		var/customization_third_r = null

		var/g = "m"
		if (src.gender == MALE)
			g = "m"
		else
			g = "f"

		if(src.mutantrace)
			src.preview_icon = new /icon(src.mutantrace.icon, src.mutantrace.icon_state)
		else
			src.preview_icon = new /icon('icons/mob/human.dmi', "body_[g]")

		if(!(src.mutantrace && src.mutantrace.override_skintone))
			// Skin tone
			if (src.s_tone >= 0)
				src.preview_icon.Blend(rgb(src.s_tone, src.s_tone, src.s_tone), ICON_ADD)
			else
				src.preview_icon.Blend(rgb(-src.s_tone,  -src.s_tone,  -src.s_tone), ICON_SUBTRACT)

		//if(!src.mutantrace)
			//src.preview_icon.Blend(new /icon('icons/mob/human_underwear.dmi', "none"), ICON_OVERLAY) // why are you blending an empty icon state into the icon???

		var/icon/eyes_s = new/icon("icon" = 'icons/mob/human_hair.dmi', "icon_state" = "eyes")

		if(!(src.mutantrace && src.mutantrace.override_eyes))
			eyes_s.Blend(src.e_color, ICON_MULTIPLY)
			src.preview_icon.Blend(eyes_s, ICON_OVERLAY)

		if(!(src.mutantrace && src.mutantrace.override_hair))
			customization_first_r = customization_styles[customization_first]
			if(!customization_first_r)
				customization_first_r = customization_styles_gimmick[customization_first]
				if(!customization_first_r)
					customization_first_r = "None"
			var/icon/hair_s = new/icon("icon" = 'icons/mob/human_hair.dmi', "icon_state" = customization_first_r)
			hair_s.Blend(src.customization_first_color, ICON_MULTIPLY)
			eyes_s.Blend(hair_s, ICON_OVERLAY)

		if(!(src.mutantrace && src.mutantrace.override_beard))
			customization_second_r = customization_styles[customization_second]
			if(!customization_second_r)
				customization_second_r = customization_styles_gimmick[customization_second]
				if(!customization_second_r)
					customization_second_r = "None"
			var/icon/facial_s = new/icon("icon" = 'icons/mob/human_hair.dmi', "icon_state" = customization_second_r)
			facial_s.Blend(src.customization_second_color, ICON_MULTIPLY)
			eyes_s.Blend(facial_s, ICON_OVERLAY)

		if(!(src.mutantrace && src.mutantrace.override_detail))
			customization_third_r = customization_styles[customization_third]
			if(!customization_third_r)
				customization_third_r = customization_styles_gimmick[customization_third]
				if(!customization_third_r)
					customization_third_r = "none"
			var/icon/detail_s = new/icon("icon" = 'icons/mob/human_hair.dmi', "icon_state" = customization_third_r)
			detail_s.Blend(src.customization_third_color, ICON_MULTIPLY)
			eyes_s.Blend(detail_s, ICON_OVERLAY)

		return

/client/proc/cmd_admin_aview()
	set category = "Special Verbs"
	set name = "Aview"
	set popup_menu = 0
	if (!src.holder)
		boutput(src, "Only administrators may use this command.")
		return

	if(src.view == world.view)
		src.view = 10
		usr.see_in_dark = 10
	else
		src.view = world.view
		usr.see_in_dark = initial(usr.see_in_dark)

/client/proc/cmd_admin_advview()
	set category = "Special Verbs"
	set name = "Adventure View"
	set popup_menu = 0
	set desc = "When toggled on, you will be able to see all 'hidden' adventure elements regardless of your current mob."

	if (!src.holder)
		boutput(src, "Only administrators may use this command.")
		return

	if (!adventure_view || mob.see_invisible < 21)
		adventure_view = 1
		mob.see_invisible = 21

	else
		adventure_view = 0
		if (!istype(mob, /mob/living))
			mob.see_invisible = 16 // this seems to be quasi-standard for dead and wraith mobs? might fuck up target observers but WHO CARES
		else
			mob.see_invisible = 0 // it'll sort itself out on the next Life() tick anyway

/proc/possess(obj/O as obj in world)
	set name = "Possess"
	set category = "Special Verbs"
	new /mob/living/object(O, usr)

/proc/possessmob(mob/M as mob in world)
	set name = "Possess Mob"
	set category = null
	set popup_menu = 0
	M.oldmob = usr
	M.oldmind = M.mind
	boutput(M, "<span style=\"color:red\">Your soul is forced out of your body!</span>")
	M.ghostize()
	var/ckey = usr.key
	M.mind = usr.mind
	M.ckey = ckey

/proc/releasemob(mob/M as mob in world)
	set name = "Release Mob"
	set category = null
	set popup_menu = 0
	if(M.oldmob)
		M.oldmob.mind = usr.mind
		usr.client.mob = M.oldmob
	else
		M.ghostize()
	M.mind = M.oldmind
	if(M.mind)
		M.ckey = M.mind.key
	boutput(M, "<span style=\"color:red\">Your soul is sucked back into your body!</span>")

/client/proc/cmd_whois(target as text)
	set name = "Whois"
	set category = "Admin"
	set desc = "Lookup a player by string (can search: mob names, byond keys and job titles)"
	set popup_menu = 0
	admin_only

	target = trim(lowertext(target))
	if (!target) return 0

	var/msg = "<span style='color:blue'>"
	var/whois = whois(target)
	if (whois)
		var/list/whoisR = whois
		msg += "<b>Player[(whoisR.len == 1 ? "" : "s")] found for '[target]':</b><br>"
		for (var/mob/M in whoisR)
			msg += "<b>[key_name(M, 1, 0)][M.mind && M.mind.assigned_role ? " ([M.mind.assigned_role])" : ""]</b><br>"
	else
		msg += "No players found for '[target]'"

	msg += "</span>"
	boutput(src, msg)

/client/proc/debugreward()
	set background = 1
	set name = "Debug Rewards"
	set desc = "For testing rewards on local servers."
	set category = "Achievements"
	set popup_menu = 0
	admin_only

	spawn(0)
		boutput(usr, "<span style=\"color:red\">Generating reward list.</span>")
		var/list/eligible = list()
		for (var/A in rewardDB)
			var/datum/achievementReward/D = rewardDB[A]
			eligible.Add(D.title)
			eligible[D.title] = D

		if (!length(eligible))
			boutput(usr, "<span style=\"color:red\">Sorry, you don't have any rewards available.</span>")
			return

		var/selection = input(usr,"Please select your reward", "VIP Rewards","CANCEL") as null|anything in eligible

		if (!selection)
			return

		var/datum/achievementReward/S = null

		for (var/X in rewardDB)
			var/datum/achievementReward/C = rewardDB[X]
			if(C.title == selection)
				S = C
				break

		if (S == null)
			boutput(usr, "<span style=\"color:red\">Invalid Rewardtype after selection. Please inform a coder.</span>")

		var/M = alert(usr,S.desc + "\n(Earned through the \"[S.required_medal]\" Medal)","Claim this Reward?","Yes","No")
		if (M == "Yes")
			S.rewardActivate(usr)

/client/proc/cmd_admin_check_health(var/atom/target as null|mob in world)
	set category = "Admin"
	set popup_menu = 1
	set name = "Check Health"
	set desc = "Checks the health of someone."
	admin_only

	if (!target)
		return
		//target = input(usr, "Target", "Target") as mob in world

	boutput(usr, scan_health(target, 1, 255))
	return

/client/proc/cmd_admin_check_reagents(var/atom/target as null|mob|obj|turf in world)
	set category = "Admin"
	set popup_menu = 1
	set name = "Check Reagents"
	set desc = "Checks the reagents of something."
	admin_only

	if (!target)
		return
		//target = input(usr, "Target", "Target") as mob|obj|turf in world

	if (!target.reagents || !target.reagents.total_volume)
		boutput(usr, "<span style=\"color:blue\"><b>[target] contains no reagents.</b></span>")
		return

	var/log_reagents = ""
	var/report_reagents = {"
	<h2><center><b>Reagent Report for [target]</b></center></h2><hr>
	<b>Temperature:</b> [target.reagents.total_temperature] K
	<table border="1" style="width:100%">
	<tbody>
		<tr>
			<th>Name</th>
			<th>ID</th>
			<th>Volume</th>
		</tr>
		"}

	for (var/current_id in target.reagents.reagent_list)
		var/datum/reagent/current_reagent = target.reagents.reagent_list[current_id]
		log_reagents += " [current_reagent] ([current_reagent.volume]),"
		report_reagents += {"
		<tr>
			<td>[current_reagent.name]</td>
			<td>[current_reagent.id]</td>
			<td>[current_reagent.volume] unit[current_reagent.volume == 1 ? "" : "s"]</td>
		</tr>
		"}

	var/final_log = copytext(log_reagents, 1, -1)
	var/final_report = "[report_reagents]</tbody></table>"

	boutput(usr, "<span style=\"color:blue\"><b>[target]'s contents: <i>[final_log]</i>. Temp: <i>[target.reagents.total_temperature] K</i></b></span>") // Added temperature (Convair880).
	usr << browse(final_report, "window=reagent_report")

	logTheThing("admin", usr, null, "checked the reagents of [target] <i>(<b>Contents:</b>[final_log])</i>. <b>Temp:</b> <i>[target.reagents.total_temperature] K</i>) [log_loc(target)]")
	logTheThing("diary", usr, null, "checked the reagents of [target] <i>(<b>Contents:</b>[final_log])</i>. <b>Temp:</b> <i>[target.reagents.total_temperature] K</i>) [log_loc(target)]", "admin")
	return

/client/proc/popt_key(var/client/ckey in clients)
	set name = "Popt Key"
	set desc = "Open the player options panel for a key."
	set category = "Admin"
	set popup_menu = 0
	admin_only

	var/mob/target
	if (!ckey)
		var/client/selection = input("Please, select a player!", "Admin Jumping", null, null) as null|anything in clients
		if(!selection)
			return
		target = selection.mob
	else
		target = ckey.mob

	if(holder)
		src.holder.playeropt(target)

/client/proc/addpathogens(var/obj/A in world)
	set category = null
	set name = "Add Random Pathogens Reagent"
	admin_only
	if(!A.reagents) A.create_reagents(100)
	var/amount = input(usr,"Amount:","Amount",50) as num
	if(!amount) return

	A.reagents.add_reagent("pathogen", amount)
	var/datum/reagent/blood/pathogen/R = A.reagents.get_reagent("pathogen")
	var/datum/pathogen/P = unpool(/datum/pathogen)
	P.setup(1)
	R.pathogens += P.pathogen_uid
	R.pathogens[P.pathogen_uid] = P

	boutput(usr, "<span style=\"color:green\">Added [amount] units of pathogen to [A.name] with pathogen [P.name].</span>")

/client/proc/addreagents(var/atom/A in world)
	set category = null
	set name = "Add Reagent"

	admin_only

	if(!A.reagents) A.create_reagents(100)

	var/list/L = list()
	var/searchFor = input(usr, "Look for a part of the reagent name (or leave blank for all)", "Add reagent") as null|text
	if(searchFor)
		for(var/R in (typesof(/datum/reagent) - /datum/reagent))
			if(findtext("[R]", searchFor)) L += R
	else
		L = (typesof(/datum/reagent) - /datum/reagent)

	var/type
	if(L.len == 1)
		type = L[1]
	else if(L.len > 1)
		type = input(usr,"Select Reagent:","Reagents",null) as null|anything in L
	else
		usr.show_text("No reagents matching that name", "red")
		return

	if(!type) return
	var/datum/reagent/reagent = new type()

	var/amount = input(usr,"Amount:","Amount",50) as null|num
	if(!amount) return

	A.reagents.add_reagent(reagent.id, amount)
	boutput(usr, "<span style=\"color:green\">Added [amount] units of [reagent.id] to [A.name]</span>")

	// Brought in line with adding reagents via the player panel (Convair880).
	logTheThing("admin", src, A, "added [amount] units of [reagent.id] to [A] at [log_loc(A)].")
	logTheThing("diary", usr, A, "added [amount] units of [reagent.id] to [A] at [log_loc(A)].", "admin")
	if (iscarbon(A)) // Not warranted for items etc, they aren't important enough to trigger an admin alert. Silicon mobs don't metabolize reagents.
		message_admins("[key_name(src)] added [amount] units of [reagent.id] to [key_name(A)] at [log_loc(A)].")

	return

/client/proc/cmd_cat_county()
	set category = null
	set name = "Cat County"
	set desc = "We can't stop here!"
	admin_only

	var/catcounter = 0
	for(var/obj/vehicle/segway/S in world)
		new /obj/vehicle/cat(S.loc)
		qdel(S)
		catcounter++

	usr.show_text("You replaced every single segway with a rideable cat. Good job!", "blue")
	logTheThing("admin", usr, null, "replaced every segway with a cat.")
	for(var/I = 1, I <= catcounter, I++)
		for(var/mob/M in world)
			if(M)
				M.playsound_local(M.loc, 'sound/effects/cat.ogg', 30, 30)
				if(I==1 && !isobserver(M)) new /obj/critter/cat(M.loc)
		sleep(rand(10,20))

/client/proc/revive_all_bees()
	set category = null
	set name = "Revive All Bees"
	admin_only

	var/revived = 0
	for (var/obj/critter/domestic_bee/Bee in world)
		if (!Bee.alive)
			Bee.health = initial(Bee.health)
			Bee.alive = 1
			//Bee.icon_state = initial(Bee.icon_state)
			Bee.density = initial(Bee.density)
			Bee.update_icon()
			Bee.on_revive()
			Bee.visible_message("<span style=\"color:red\">[Bee] seems to rise from the dead!</span>")
			revived ++
	for (var/obj/critter/domestic_bee_larva/Larva in world)
		if (!Larva.alive)
			Larva.health = initial(Larva.health)
			Larva.alive = 1
			Larva.icon_state = initial(Larva.icon_state)
			Larva.density = initial(Larva.density)
			Larva.on_revive()
			Larva.visible_message("<span style=\"color:red\">[Larva] seems to rise from the dead!</span>")
			revived ++
	logTheThing("admin", src, null, "revived [revived] bee[revived == 1 ? "" : "s"].")
	message_admins("[key_name(src)] revived [revived] bee[revived == 1 ? "" : "s"]!")

/client/proc/revive_all_cats()
	set category = null
	set name = "Revive All Cats"
	admin_only

	var/revived = 0
	for (var/obj/critter/cat/Cat in world)
		if (!Cat.alive)
			Cat.health = initial(Cat.health)
			Cat.alive = 1
			Cat.icon_state = initial(Cat.icon_state)
			Cat.density = initial(Cat.density)
			Cat.on_revive()
			Cat.visible_message("<span style=\"color:red\">[Cat] seems to rise from the dead!</span>")
			revived ++
	logTheThing("admin", src, null, "revived [revived] cat[revived == 1 ? "" : "s"].")
	message_admins("[key_name(src)] revived [revived] cat[revived == 1 ? "" : "s"]!")

/client/proc/revive_all_parrots()
	set category = null
	set name = "Revive All Parrots"
	admin_only

	var/revived = 0
	for (var/obj/critter/parrot/Bird in world)
		if (!Bird.alive)
			Bird.health = initial(Bird.health)
			Bird.alive = 1
			Bird.icon_state = Bird.species
			Bird.density = initial(Bird.density)
			Bird.on_revive()
			Bird.visible_message("<span style=\"color:red\">[Bird] seems to rise from the dead!</span>")
			revived ++
	logTheThing("admin", src, null, "revived [revived] parrot[revived == 1 ? "" : "s"].")
	message_admins("[key_name(src)] revived [revived] parrot[revived == 1 ? "" : "s"]!")

/proc/listCritters(var/alive)
	var/list/critters = list()
	for (var/obj/critter/C in view(usr))
		if (C.alive && alive)
			critters += C
		else if (!C.alive && !alive)
			critters += C
	return critters

/client/proc/revive_critter(var/obj/critter/C)
	set name = "Revive Critter"
	set category = null
	set desc = "Brings a critter back to life, like magic!"
	set popup_menu = 1
	admin_only

	if (!istype(C, /obj/critter))
		boutput(src, "[C] isn't a critter! How did you even get here?!")
		return

	if (!C.alive || C.health <= 0)
		C.health = initial(C.health)
		C.alive = 1
		C.icon_state = copytext(C.icon_state, 1, -5) // if people aren't being weird about the icons it should just remove the "-dead"
		C.density = initial(C.density)
		C.on_revive()
		C.visible_message("<span style=\"color:red\">[C] seems to rise from the dead!</span>")
		logTheThing("admin", src, null, "revived [C] (critter).")
		message_admins("[key_name(src)] revived [C] (critter)!")
	else
		boutput(src, "[C] isn't dead, you goof!")
		return

/client/proc/kill_critter(var/obj/critter/C)
	set name = "Kill Critter"
	set category = null
	set desc = "Kills a critter DEAD!"
	set popup_menu = 1
	admin_only

	if (!istype(C, /obj/critter))
		boutput(src, "[C] isn't a critter! How did you even get here?!")
		return

	if (C.alive)
		C.health = 0
		C.CritterDeath()
		logTheThing("admin", src, null, "killed [C] (critter).")
		message_admins("[key_name(src)] killed [C] (critter)!")
	else
		boutput(src, "[C] isn't alive, you goof!")
		return

/client/proc/cmd_swap_minds(var/mob/M)
	set name = "Swap Bodies With"
	set category = "Special Verbs"
	set desc = "Swaps yours and the other person's bodies around."
	set popup_menu = 1 //Imagine if we could have subcategories in the popup menus. Wouldn't that be nice?

	admin_only
	if(!M || M == usr ) return

	if(usr.mind)
		logTheThing("admin", usr, M, "swapped bodies with %target%")
		logTheThing("diary", usr, M, "swapped bodies with %target%", "admin")
		var/mob/oldmob //This needs to be here
		if(M.key || M.client) //Nobody gives a shit if you wanna be an npc.
			message_admins("[key_name(src)] swapped bodies with [key_name(M)]")
			M.show_text("You are punted out of your body!", "red")
		else //You can only get rid of the ghost if you wanna swap with an NPC, because a player is getting YOUR ghost.
			if(isobserver(usr)) //You're dead, I guess an orphan ghost is not something we'd want.
				if(usr:corpse == M) //You're using admin observe and trying to be a smarty
					usr.client.admin_play()
					return
				oldmob = usr

		usr.mind.swap_with(M)
		if(oldmob) qdel(oldmob)
	else //You don't have a mind. Let's give you one and try again
		//usr.show_text("You don't have a mind!")
		logTheThing("debug", usr, null, "<B>SpyGuy/Mindswap</B> - [usr] didn't have a mind so one was created for them.")
		usr.mind = new /datum/mind(usr)
		ticker.minds += usr.mind
		.()

// Tweaked this to implement log entries and make it feature-complete with regard to every antagonist roles (Convair880).
/proc/remove_antag(var/mob/M, var/mob/admin, var/new_mind_only = 0, var/show_message = 0)
	set name = "Remove Antag"
	set desc = "Removes someone's traitor status."

	if (!M || !M.mind || !M.mind.special_role)
		return

	var/former_role
	former_role = text("[M.mind.special_role]")

	message_admins("[key_name(M)]'s antagonist status ([former_role]) was removed. Source: [admin ? "[key_name(admin)]" : "*automated*"].")
	if (admin) // Log entries for automated antag status removal is handled in helpers.dm, remove_mindslave_status().
		logTheThing("admin", admin, M, "removed the antagonist status of %target%.")
		logTheThing("diary", admin, M, "removed the antagonist status of %target%.", "admin")

	if (show_message == 1)
		M.show_text("<h2><font color=red><B>Your antagonist status has been revoked by an admin! If this is an unexpected development, please inquire about it in adminhelp.</B></font></h2>", "red")
		M << browse(grabResource("html/traitorTips/antagRemoved.html"),"window=antagTips;titlebar=1;size=600x400;can_minimize=0;can_resize=0")

	// Replace the mind first, so the new mob doesn't automatically end up with changeling etc. abilities.
	var/datum/mind/newMind = new /datum/mind()
	newMind.key = M.key
	newMind.current = M
	newMind.assigned_role = M.mind.assigned_role
	newMind.brain = M.mind.brain
	newMind.dnr = M.mind.dnr
	newMind.is_target = M.mind.is_target
	if (M.mind.former_antagonist_roles.len)
		newMind.former_antagonist_roles.Add(M.mind.former_antagonist_roles)
	qdel(M.mind)
	if (!(newMind in ticker.minds))
		ticker.minds.Add(newMind)
	M.mind = newMind

	M.antagonist_overlay_refresh(1, 1)

	if (new_mind_only)
		return

	// Then spawn a new mob to delete all mob-/client-bound antagonist verbs.
	// Complete overkill for mindslaves, though. Blobs and wraiths need special treatment as well.
	// Synthetic mobs aren't really included yet, because it would be a complete pain to account for them properly.
	if (issilicon(M))
		var/mob/living/silicon/S = M
		S.emagged = 0
		S.syndicate = 0
		if (S.mainframe && S != S.mainframe)
			var/mob/living/silicon/ai/MF = S.mainframe
			MF.emagged = 0
			MF.syndicate = 0

		ticker.centralized_ai_laws.clear_inherent_laws()
		for (var/mob/living/silicon/S2 in mobs)
			if (S2.emagged || S2.syndicate) continue
			if (isghostdrone(S2)) continue
			S2.show_text("<b>Your laws have been changed!</b>", "red")
			S2.show_laws()

	switch (former_role)
		if ("mindslave") return
		if ("vampthrall") return
		if ("spyslave") return
		if ("blob") M.humanize(1)
		if ("wraith") M.humanize(1)
		else
			if (ishuman(M))
				// They could be in a pod or whatever, which would have unfortunate results when respawned.
				if (!isturf(M.loc))
					return
				var/mob/living/carbon/human/H = M

				// Get rid of those uplinks first.
				var/list/L = H.get_all_items_on_mob()
				if (L && L.len)
					for (var/obj/item/device/pda2/PDA in L)
						if (PDA && PDA.uplink)
							qdel(PDA.uplink)
							PDA.uplink = null
					for (var/obj/item/device/radio/R in L)
						if (R && R.traitorradio)
							qdel(R.traitorradio)
							R.traitorradio = null
							R.traitor_frequency = 0
					for (var/obj/item/uplink/U in L)
						if (U) qdel(U)
					for (var/obj/item/SWF_uplink/WZ in L)
						if (WZ) qdel(WZ)

				H.unkillable_respawn(1)

			if (isobserver(M)) // Ugly but necessary.
				var/mob/dead/observer/O = M
				var/mob/dead/observer/newO = new/mob/dead/observer(O)
				if (O.corpse)
					newO.corpse = O.corpse
				O.mind.transfer_to(newO)
				qdel(O)

	return

/client/proc/admin_foam(var/atom/A as turf|obj|mob, var/amount as num)
	set name = "Create Foam"
	set category = null
	set desc = "Creates a foam reaction."
	set popup_menu = 1
	admin_only

	if (!A)
		return
	var/datum/reagents/holder
	if (A.reagents)
		holder = A.reagents
		logTheThing("admin", src, A, "created foam in [A] [log_reagents(A)] at [log_loc(A)].")
		message_admins("[key_name(src)] created foam in [A] [log_reagents(A)] at [log_loc(A)].")
	var/datum/effects/system/foam_spread/s = new()
	s.set_up(amount, get_turf(A), holder, 0)
	s.start()
	if (A.reagents)
		holder.clear_reagents()

/client/proc/admin_smoke(var/atom/A as turf|obj|mob, var/size as num)
	set name = "Create Smoke"
	set category = null
	set desc = "Creates a smoke reaction."
	set popup_menu = 1
	admin_only

	if (!A)
		return
	var/datum/reagents/holder
	if (A.reagents)
		holder = A.reagents
		logTheThing("admin", src, A, "created smoke in [A] [log_reagents(A)] at [log_loc(A)].")
		message_admins("[key_name(src)] created smoke in [A] [log_reagents(A)] at [log_loc(A)].)")
	smoke_reaction(holder, size, get_turf(A), 1)

/client/proc/admin_follow_mobject(var/atom/target as mob|obj in world)
	set category = "Admin"
	set popup_menu = 1
	set name = "Follow Thing"
	set desc = "It's like observing, but without that part where you see everything as the person you're observing. Move to cancel if an observer, or use any jump command to leave if alive."
	admin_only

	usr:set_loc(target)
	logTheThing("admin", usr, target, "began following [target].")
	logTheThing("diary", usr, target, "began following [target].", "admin")

/client/proc/admin_pick_random_player()
	set category = "Admin"
	set name = "Pick Random Player"
	set desc = "Picks a random logged-in player and brings up their player panel."
	admin_only

	var/what_group = input(src, "What group would you like to pick from?", "Selection", "Everyone") as null|anything in list("Everyone", "Traitors Only", "Non-Traitors Only")
	if (!what_group)
		return
	var/choose_from_dead = input(src, "What group would you like to pick from?", "Selection", "Everyone") as null|anything in list("Everyone", "Living Only", "Dead Only")
	if (!choose_from_dead)
		return

	var/list/player_pool = list()
	for (var/mob/M in mobs)
		if (!M.client || istype(M, /mob/new_player))
			continue
		if (what_group != "Everyone")
			if ((what_group == "Traitors Only") && !checktraitor(M))
				continue
			else if ((what_group == "Non-Traitors Only") && checktraitor(M))
				continue
		if (choose_from_dead != "Everyone")
			if ((choose_from_dead == "Living Only") && M.stat)
				continue
			else if ((choose_from_dead == "Dead Only") && !M.stat)
				continue
		player_pool += M

	if (!player_pool.len)
		boutput(src, "<span style=\"color:red\">Error: no valid mobs found via selected options.</span>")
		return

	var/chosen_player = pick(player_pool)
	src.holder.playeropt(chosen_player)

var/global/night_mode_enabled = 0
/client/proc/admin_toggle_nightmode()
	set category = "Toggles (Server)"
	set name = "Toggle Night Mode"
	set desc = "Switch the station into night mode so the crew can rest and relax off-work."
	admin_only

	night_mode_enabled = !night_mode_enabled
	message_admins("[key_name(src)] toggled Night Mode [night_mode_enabled ? "on" : "off"]")
	logTheThing("admin", src, null, "toggled Night Mode [night_mode_enabled ? "on" : "off"]")
	logTheThing("diary", src, null, "toggled Night Mode [night_mode_enabled ? "on" : "off"]", "admin")

	for(var/obj/machinery/power/apc/APC in machines)
		if(APC.area && APC.area.workplace)
			APC.do_not_operate = night_mode_enabled
			APC.update()
			APC.updateicon()

/client/proc/admin_set_ai_vox()
	set category = "Special Verbs"
	set name = "Set AI VOX"
	set desc = "Grant or revoke AI access to VOX"
	admin_only

	var/answer = alert("Set AI VOX access.", "Fun stuff.", "Grant Access", "Revoke Access", "Cancel")
	switch(answer)
		if ("Grant Access")
			message_admins("[key_name(src)] granted VOX access to all AIs!")
			logTheThing("admin", src, null, "granted VOX access to all AIs!")
			logTheThing("diary", src, null, "granted VOX access to all AIs!", "admin")
			boutput(world, "<B>The AI may now use VOX!</B>")
			for(var/mob/living/silicon/ai/AI in mobs)
				AI.cancel_camera()
				sleep(-1)
				AI.verbs += /mob/living/silicon/ai/proc/ai_vox_announcement
				AI.verbs += /mob/living/silicon/ai/proc/ai_vox_help
				AI.show_text("<B>You may now make intercom announcements!</B><BR>You'll find two new verbs under AI commands: \"AI Intercom Announcement\" and \"AI Intercom Help\"")


		if ("Revoke Access")
			message_admins("[key_name(src)] revoked VOX access from all AIs!")
			logTheThing("admin", src, null, "revoked VOX access from all AIs!")
			logTheThing("diary", src, null, "revoked VOX access from all AIs!", "admin")
			boutput(world, "<B>The AI may no longer use VOX!</B>")
			for(var/mob/living/silicon/ai/AI in mobs)
				AI.cancel_camera()
				sleep(-1)
				AI.verbs -= /mob/living/silicon/ai/proc/ai_vox_announcement
				AI.verbs -= /mob/living/silicon/ai/proc/ai_vox_help
				AI.show_text("<B>You may no longer make intercom announcements!</B>")

		if("Cancel")
			return

/proc/list_humans()
	var/list/L = list()
	for (var/mob/living/carbon/human/H in mobs)
		L += H
	return L

/client/proc/modify_organs(var/mob/living/carbon/human/H as mob in list_humans())
	set name = "Modify Organs"
	set category = "Special Verbs"
	admin_only

	if (!istype(H))
		boutput(usr, "<span style=\"color:red\">This can only be used on humans!</span>")
		return
	if (!H.organHolder)
		if (alert(usr, "[H] lacks an organHolder! Create a new one?", "Error", "Yes", "No") == "Yes")
			H.organHolder = new(H)
		else
			return
	// oh god this is going to be a horrible input tree
	var/list/organ_list = list("All", "Butt" = H.organHolder.butt, "Head" = H.organHolder.head, "Brain" = H.organHolder.brain, "Skull" = H.organHolder.skull, "Heart" = H.organHolder.heart, "Left Eye" = H.organHolder.left_eye, "Right Eye" = H.organHolder.right_eye, "Left Lung" = H.organHolder.left_lung, "Right Lung" = H.organHolder.right_lung)
	var/organ = input(usr, "Select organ(s) to edit", "Selection", "All") as null|anything in organ_list //list("Butt", "Brain", "Skull", "Left Eye", "Right Eye", "Heart", "Left Lung", "Right Lung", "All")
	if (!organ)
		return
	if (organ == "All")
		var/what2do = input(usr, "What would you like to do?", "Selection", "Drop") as null|anything in list("Drop", "Delete")
		if (!what2do)
			return
		switch (what2do)
			if ("Drop")
				if (alert(usr, "Are you sure you want to drop ALL of [H]'s organs? This will probably kill them!", "Confirmation", "Yes", "No") == "Yes")
					for (var/o in organ_list)
						if (o == "All")
							continue
						H.organHolder.drop_organ(o)
			if ("Delete")
				if (alert(usr, "Are you sure you want to delete ALL of [H]'s organs? This will probably kill them!", "Confirmation", "Yes", "No") == "Yes")
					for (var/o in organ_list)
						if (o == "All")
							continue
						var/organ2del = H.organHolder.drop_organ(o)
						qdel(organ2del)
		return

	var/obj/item/ref_organ = organ_list[organ]

	var/options_list = list("Replace")
	if (ref_organ)
		options_list += "Drop"
		options_list += "Delete"

	var/what2do = input(usr, "What would you like to do?", "Selection", "Replace") as null|anything in options_list
	if (!what2do)
		return

	switch (what2do)
		if ("Replace")
			var/d_d_c
			if (ref_organ)
				d_d_c = input(usr, "Drop or delete existing organ?", "Selection", "Drop") as null|anything in list("Drop", "Delete")
				if (!d_d_c)
					return
			var/new_organ
			var/organ_path
			switch (organ)
				if ("Butt")
					organ_path = /obj/item/clothing/head/butt
				if ("Head")
					organ_path = /obj/item/organ/head
				if ("Brain")
					organ_path = /obj/item/organ/brain
				if ("Skull")
					organ_path = /obj/item/skull
				if ("Left Eye")
					organ_path = /obj/item/organ/eye
				if ("Right Eye")
					organ_path = /obj/item/organ/eye
				if ("Heart")
					organ_path = /obj/item/organ/heart
				if ("Left Lung")
					organ_path = /obj/item/organ/lung
				if ("Right Lung")
					organ_path = /obj/item/organ/lung
			new_organ = input(usr, "What would you like to replace \the [lowertext(organ)] with?", "New Organ") as null|anything in typesof(organ_path)

			if (!new_organ || !ispath(new_organ))
				return
			if (d_d_c)
				switch (d_d_c)
					if ("Drop")
						H.organHolder.drop_organ(organ)
					if ("Delete")
						var/organ2del = H.organHolder.drop_organ(organ)
						qdel(organ2del)

			var/obj/item/created_organ = new new_organ
			created_organ:donor = H
			H.organHolder.receive_organ(created_organ, organ)
			boutput(usr, "<span style=\"color:blue\">[H]'s [lowertext(organ)] replaced with [created_organ].</span>")
			logTheThing("admin", usr, H, "replaced %target%'s [lowertext(organ)] with [created_organ]")
			logTheThing("diary", usr, H, "replaced %target%'s [lowertext(organ)] with [created_organ]", "admin")
		if ("Drop")
			if (alert(usr, "Are you sure you want [H] to drop their [lowertext(organ)]?", "Confirmation", "Yes", "No") == "Yes")
				H.organHolder.drop_organ(organ)
				boutput(usr, "<span style=\"color:blue\">[H]'s [lowertext(organ)] dropped.</span>")
				logTheThing("admin", usr, H, "dropped %target%'s [lowertext(organ)]")
				logTheThing("diary", usr, H, "dropped %target%'s [lowertext(organ)]", "admin")
			else
				return
		if ("Delete")
			if (alert(usr, "Are you sure you want to delete [H]'s [lowertext(organ)]?", "Confirmation", "Yes", "No") == "Yes")
				var/organ2del = H.organHolder.drop_organ(organ)
				qdel(organ2del)
				boutput(usr, "<span style=\"color:blue\">[H]'s [lowertext(organ)] deleted.</span>")
				logTheThing("admin", usr, H, "deleted %target%'s [lowertext(organ)]")
				logTheThing("diary", usr, H, "deleted %target%'s [lowertext(organ)]", "admin")
			else
				return
	return

/client/proc/display_bomb_monitor()
	set name = "Display Bomb Monitor"
	set desc = "Get a list of every canister- and tank-transfer bomb on station."
	set category = "Admin"
	admin_only

	var/datum/bomb_monitor/BM = unpool(/datum/bomb_monitor)
	BM.set_up(usr)
	BM.display_ui()

/client/proc/generate_poster(var/target as null|area|turf|obj|mob in world)
	set name = "Create Poster"
	set category = "Special Verbs"
	set popup_menu = 1
	admin_only
	if (alert(usr, "Wanted poster or custom poster?", "Select Poster Style", "Wanted", "Custom") == "Wanted")
		gen_wp(target)
	else
		gen_poster(target)

/client/proc/cmd_boot(mob/M as mob in world)
	set name = "Boot"
	set desc = "Boot a player off the server"
	set category = "Admin"
	admin_only

	if (src.holder.level >= LEVEL_MOD)
		if (ismob(M))
			if (alert(usr, "Boot [M]?", "Confirmation", "Yes", "No") == "Yes")
				logTheThing("admin", usr, M, "booted %target%.")
				logTheThing("diary", usr, M, "booted %target%.", "admin")
				message_admins("<span style=\"color:blue\">[key_name(usr)] booted [key_name(M)].</span>")
				del(M.client)
	else
		alert("You need to be at least a Moderator to kick players.")

/client/proc/cmd_admin_fake_medal(var/msg as null|text)
	set name = "Fake Medal"
	set desc = "Creates a false medal message and shows it to someone, or everyone."
	admin_only

	if (!msg)
		msg = input("Enter message", "Message", "[src.key] earned the Banned medal.") as null|text
		if (!msg)
			return

	if (!(src.holder.level >= LEVEL_PA))
		msg = strip_html(msg)

	var/mob/audience = null
	if (alert("Who should see this message?", "Select Audience", "One Mob", "Every Mob") == "One Mob")
		audience = input("Select the mob. Cancel to select every mob.", "Select Mob") as null|anything in mobs

	if (alert("Show the message: \"[msg]\" to [audience ? audience : "everyone"]?", "Confirm", "OK", "Cancel") == "OK")
		msg = "<span class='medal'>" + msg + "</span>"
		logTheThing("admin", usr, null, "showed a fake medal message to [audience ? audience : "everyone"]: \"[msg]\"")
		logTheThing("diary", usr, null, "showed a fake medal message to [audience ? audience : "everyone"]: \"[msg]\"", "admin")
		message_admins("[key_name(usr)] showed a fake medal message to [audience ? audience : "everyone"]: \"[msg]\"")
		if (audience)
			boutput(audience, msg)
		else
			for (var/client/C in clients)
				boutput(C, msg)

/client/proc/cmd_shame_cube(var/mob/living/M as mob in world)
	set name = "Shame Cube"
	set desc = "Places the player in a windowed cube at your location"
	set category = "Special Verbs"
	admin_only

	if (!M || M.stat == 2 || !src.mob)
		return 0

	var/announce = alert("Announce this cubing to the server?", "Announce", "Yes", "No")

	var/turf/targetLoc = src.mob.loc

	//Build our shame cube
	for (var/direction in cardinal)
		var/obj/window/bulletproof/R = new /obj/window/bulletproof(targetLoc)
		R.dir = direction
		R.state = 10

	//Place our sucker into it
	M.set_loc(targetLoc)

	if (announce == "Yes")
		command_alert("[M.name] has been shamecubed in [get_area(M)]!", "Dumb person detected!")

	out(M, "<span class='bold alert'>You have been shame-cubed by an admin! Take this embarrassing moment to reflect on what you have done.</span>")
	logTheThing("admin", src, M, "shame-cubed %target% at [get_area(M)] ([showCoords(M.x, M.y, M.z)])")
	logTheThing("diary", src, M, "shame-cubed %target% at [get_area(M)] ([showCoords(M.x, M.y, M.z)])", "admin")
	message_admins("[key_name(src)] shame-cubed [key_name(M)] at [get_area(M)] ([showCoords(M.x, M.y, M.z)])")

	return 1

/client/proc/cmd_makeshittyweapon()
	set name = "Make Shitty Weapon"
	set desc = "make some stupid junk, laugh"
	set category = "Special Verbs"
	admin_only

	if (src.holder.level >= LEVEL_PA)
		var/obj/O = makeshittyweapon()
		if (O)
			logTheThing("admin", src, null, "made a shitty piece of junk weapon: [O][src.mob ? " [log_loc(src.mob)]" : null]")
			logTheThing("diary", src, null, "made a shitty piece of junk weapon: [O][src.mob ? " [log_loc(src.mob)]" : null]", "admin")
			message_admins("[key_name(src)] made a shitty piece of junk weapon:	 [O][src.mob ? " [log_loc(src.mob)]" : null]")
