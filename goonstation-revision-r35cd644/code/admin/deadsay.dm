#include "macros.dm"
/client/proc/dsay(msg as text)
	set category = "Special Verbs"
	set name = "dsay"
	set hidden = 1
	admin_only
	if (!src.mob)
		return
	if (src.ismuted())
		boutput(src, "You are currently muted and cannot use deadsay.")
		return

	msg = copytext(sanitize(html_encode(msg)), 1, MAX_MESSAGE_LEN)
	logTheThing("admin", src, null, "DSAY: [msg]")
	logTheThing("diary", src, null, "DSAY: [msg]", "admin")

	if (!msg)
		return
	var/show_other_key = 0
	if (src.stealth || src.alt_key)
		show_other_key = 1
	var/rendered = "<span class='game deadsay'><span class='prefix'>DEAD:</span> <span class='name'>ADMIN([show_other_key ? src.fakekey : src.key])</span> says, <span class='message'>\"[msg]\"</span></span>"
	var/adminrendered = "<span class='game deadsay'><span class='prefix'>DEAD:</span> <span class='name' data-ctx='\ref[src.mob.mind]'>[show_other_key ? "ADMIN([src.key] (as [src.fakekey])" : "ADMIN([src.key]"])</span> says, <span class='message'>\"[msg]\"</span></span>"

	for (var/mob/M in mobs)
		if(istype(M, /mob/new_player))
			continue

		if(M.client && M.client.holder && !M.client.player_mode)
			var/thisR = adminrendered
			if (src.mob.mind)
				thisR = "<span class='adminHearing' data-ctx='[M.client.chatOutput.ctxFlag]'>[adminrendered]</span>"
			boutput(M, thisR)
		else if(M.stat == 2)
			M.show_message(rendered, 2)