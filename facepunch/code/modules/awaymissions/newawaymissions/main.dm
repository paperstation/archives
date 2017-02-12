var/global/list/awaymissionholder = list()

/datum/awaymission
	var/name
	var/desc
	var/difficulty = 0
	var/gatecode
	var/boss = 0
	var/area/linkedarea
	var/initialized = 0
	var/completed // for rewards


	var/dynamic = 0 //If 1 fill the next two things out, if not fill the third thing.
	var/list/possiblerewards = list()
	var/list/enemies = list()

	var/list/rewards = list()//Dynamic = 1? Don't use this!

	New()
		//Creates a code
		var/A = pick("1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S")
		var/B = pick("1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S")
		var/C = pick("1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S")
		var/D = pick("1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S")
		var/E = pick("1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S")
		var/F = pick("1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S")
		gatecode = A+B+C+D+E+F
		awaymissionholder.Add(src)

/datum/awaymission/proc/initialize()
	initialized = 1
	//remember to ..()
	return

/datum/awaymission/proc/closure()
	initialized = 1
	//remember to ..()
	return