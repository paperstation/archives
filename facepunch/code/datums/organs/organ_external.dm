
//Updates an organ's brute/burn states for use by updateDamageIcon()
//Returns 1 if we need to update overlays. 0 otherwise.
/*
/datum/organ/external/proc/update_icon()
	var/tbrute	= round( (brute_dam/max_damage)*3, 1 )
	var/tburn	= round( (burn_dam/max_damage)*3, 1 )
	if((tbrute != brutestate) || (tburn != burnstate))
		brutestate = tbrute
		burnstate = tburn
		return 1
	return 0
*/