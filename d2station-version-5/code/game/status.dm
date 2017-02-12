var/global/hasvariables = "e"
/world/proc/update_status()
	//D2K5's Custom World List

	var/servername = config.server_name
	var/worldname = station_name()

	var/link = config.banappeals
	var/mode = master_mode
	var/display_version = "D2Station V5"
	var/revision = check_svnrevlist()

	var/can_enter = config.enable_authentication
	var/can_vote = config.allow_vote_mode
	var/can_ai = config.allow_ai
	var/listed = world.visibility //listed by default
	var/address = world.Export("http://api.d2k5.com/ss13/getip.php", null, 1)
	if(!address)
		return world.address
	address = file2text(address["CONTENT"])

	var/players = 0
	for (var/mob/M in world)
		if (M.client)
			players++

	var/s = ""

	if (config && config.server_name)
		s += "<a href='[link]'><b>[servername] - [worldname]</b></a> &#8212; ([display_version] R[revision])"

	if (src.status != s)
		src.status = s

	world.name = "[servername] - [worldname]"

	//Add to D2K5 Server List
	world.Export("http://api.d2k5.com/ss13/servers.php?update=1&server=[servername]&world=[worldname]&link=[link]&mode=[mode]&revision=[revision]&can_enter=[can_enter]&can_vote=[can_vote]&can_ai=[can_ai]&players=[players]&address=[address]&port=[world.port]&listed=[listed]")
	spawn(60)
		update_status()