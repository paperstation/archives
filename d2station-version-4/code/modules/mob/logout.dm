/mob/Logout()

	if(src.client)
		src << browse("about:blank", "window=rpane.hwload")

	log_access("Logout: [key_name(src)]")
	if (admins[src.ckey])
		message_admins("Admin logout: [key_name(src)]")
	src.logged_in = 0

	..()

	return 1