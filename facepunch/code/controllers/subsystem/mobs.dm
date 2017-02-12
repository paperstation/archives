/datum/subsystem/mobs
	name = "Mobs"
	wait = 20

/datum/subsystem/mobs/fire()
	set background = 1

	var/i = 1
	while(i <= mob_list.len)
		var/mob/M = mob_list[i]
		if(M)
			M.Life()
			++i
			continue
		mob_list.Cut(i,i+1)