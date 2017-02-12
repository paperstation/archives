/*
	Hello good coder sir!

	Recently the quality of these lists went down, like WAY DOWN.

	The only things that should be in the random name lists are
	science fiction themed things and references to
	existing science fiction media (movies, books, etc).

	If you wish to add anything else, FUCK YOU AND DIE.

	(and don't add it)

	-Rick
*/

/proc/station_name()
	if (station_name)
		return station_name

	var/name = ""

	//halloween prefixes, temporary thing
#ifdef HALLOWEEN
	name += pick_string("station_name.txt", "halloweenPrefixes")
	name += " "
#endif

	if (map_setting == "DESTINY")
		name += "NSS Destiny"
	else
		if (prob(10))
			name += pick_string("station_name.txt", "prefixes1")
			name += pick("Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune", "Ceres", "Pluto", "Haumea", "Makemake", "Eris", "Luna", "engineering", "Gen", "gen", "Co", "You", "Galactic", "Node", "Capital", "Moon", "Main", "Labs", "Lab", "trasen", "tum")
		else if (prob(10))
			name += pick_string("station_name.txt", "prefixes2")
			name += " "

		// Prefix
		name += pick_string("station_name.txt", "prefixes3")
		if (name)
			name += " "

		// Suffix
		name += pick_string("station_name.txt", "suffixes")
		name += " "

		// ID Number
		if (prob(40))
			name += "[rand(1, 99)]"
		else if (prob(5))
			name += "3000"
		else if (prob(5))
			name += "9000"
		else if (prob(5))
			name += "14000000000"
		else if (prob(5))
			name += "205[pick(1, 3)]"
		else if (prob(50))
			name += pick_string("station_name.txt", "greek")
		else if (prob(30))
			name += pick_string("station_name.txt", "romanNum")
		else if (prob(40))
			name += pick_string("station_name.txt", "militaryLetters")
		else
			name += pick_string("station_name.txt", "numbers")

	station_name = name

	if (config && config.server_name)
		world.name = "[config.server_name]: [name]"
	else
		world.name = name

	return name
