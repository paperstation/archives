var/global/hasvariables = "e"
/world/proc/update_status()
	var/s = ""

	if (config && config.server_name)
		//Server Name + Links
		s += "<big><a href='http://d2k5.com/' target='_blank'><b>[config.server_name]</b></a> &#8212; (<a href='http://d2k5.com'>[game_version]</a>)</big>"

		//Server Feature List
		s += "<br><br><img src='http://lemon.d2k5.com/features.png?v8'>"

	/* does this help? I do not know */
	if (src.status != s)
		src.status = s
