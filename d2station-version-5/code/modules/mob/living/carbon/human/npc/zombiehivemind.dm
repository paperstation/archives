/*

/datum/zombiehavmund
	var/difficulty
	var/intelligence
	var/debug
	var/list/tempmobs = list()

/datum/zombiehavmund/proc/targets()
	for(var/mob/living/carbon/human/L in tempmobs)
//		world << "test calling next"
		Zombie_Hivemind.zombies(L)

/datum/zombiehavmund/proc/rebuild_targets()
	tempmobs = mobz
//	world << "rebuilding lists, [tempmobs.len]"
	for(var/mob/living/carbon/human/L in tempmobs)
		if(L.mutantrace == "zombie") tempmobs -= L
		if(L.stat > 1) tempmobs -= L
		if(L in zombies) tempmobs -= L


/datum/zombiehavmund/proc/zombies(var/mob/living/carbon/human/L)
//	world << "called next"
	for(var/mob/living/carbon/human/M in oview(L.prioritory, L))
		if(M in zombies)
		//	world << "m in zombies"
			if(!M.tempmob)
			//	world << "working targets"
				M.tempmob = L
			else
				var/newmob = get_dist(L.loc,M.loc)
				var/oldmob = get_dist(M.loc,M.tempmob.loc)
				if(newmob < oldmob)
					M.tempmob = L
				else
					M.tempmob = M.tempmob
*/