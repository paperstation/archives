/proc/mass_edit_client_dir()
	if(!usr)
		return
	var/ndir = input("Please enter the direction, 0 means all, -1 means cancel.","dir","0") as num|null
	if(ndir == 0 || ndir == -1)
		return
	for(var/mob/M in world)
		if(!M.client)
			continue
		M.client.dir = ndir
	return 1

/proc/toggle_water_sprite()
	alt_water = !alt_water
	return alt_water
var/alt_water = 0


/*	No longer required, you can just debug the master controller and then access the individual subsystems that way
/proc/show_processing()
	var/dat = "Machine processing <br>"
	for(var/atom/A in SSmachines.processing)
		dat += "[A.name] : [A.type] <br>"
	dat += "Object processing <br>"
	for(var/atom/A in processing_objects)
		dat += "[A.name] : [A.type] <br>"
	usr << browse(dat, "window=machines")
	return
*/

/*
/proc/blobcount()
	if(!holder)
		src << "Only administrators may use this command."
		return
	if(ticker && ticker.mode)
		src << "blobs: [blobs.len]"
		src << "cores: [blob_cores.len]"
		src << "nodes: [blob_nodes.len]"
	return


/proc/blobize()//Mostly stolen from the respawn command
	if(!holder)
		src << "Only administrators may use this command."
		return
	var/input = input(src, "Please specify which key will be turned into a bloby.", "Key", "")

	var/mob/dead/observer/G_found
	if(!input)
		var/list/ghosts = list()
		for(var/mob/dead/observer/G in player_list)
			ghosts += G
		if(ghosts.len)
			G_found = pick(ghosts)

	else
		for(var/mob/dead/observer/G in player_list)
			if(G.client&&ckey(G.key)==ckey(input))
				G_found = G
				break

	if(!G_found)//If a ghost was not found.
		alert("There is no active key like that in the game or the person is not currently a ghost. Aborting command.")
		return

	if(G_found.client)
		G_found.client.screen.len = null
	var/mob/living/blob/B = new/mob/living/blob(locate(0,0,1))//temp area also just in case should do this better but tired
	if(blob_cores.len > 0)
		var/obj/effect/blob/core/core = pick(blob_cores)
		if(core)
			B.loc = core.loc
	B.ghost_name = G_found.real_name
	if (G_found.client)
		G_found.client.mob = B
	B.verbs += /mob/living/blob/verb/create_node
	B.verbs += /mob/living/blob/verb/create_factory
	B << "<B>You are now a blob fragment.</B>"
	B << "You are a weak bit that has temporarily broken off of the blob."
	B << "If you stay on the blob for too long you will likely be reabsorbed."
	B << "If you stray from the blob you will likely be killed by other organisms."
	B << "You have the power to create a new blob node that will help expand the blob."
	B << "To create this node you will have to be on a normal blob tile and far enough away from any other node."
	B << "Check your Blob verbs and hit Create Node to build a node."
	spawn(10)
		del(G_found)*/