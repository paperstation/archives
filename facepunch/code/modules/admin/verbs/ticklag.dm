//Merged Doohl's and the existing ticklag as they both had good elements about them ~Carn

/client/proc/set_fps()
	set category = "Debug"
	set name = "Set FPS"
	set desc = "Sets the frames-per-second of the game"

	if(!check_rights(R_DEBUG))	return

	var/newfps = round(input("Sets a new fps setting. Please don't mess with this too much! (Default: [initial(world.fps)]","FPS", world.fps) as num|null)
	if(newfps > 0)
		log_admin("[key_name(src)] has modified world.fps to [newfps]", 0)
		message_admins("[key_name(src)] has modified world.fps to [newfps]", 0)
		world.fps = newfps
	else
		src << "\red Error: set_fps(): Invalid world.fps value. No changes made."


