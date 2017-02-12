/turf/simulated/wall/false_wall
	name = "wall"
	icon = 'icons/obj/doors/Doorf.dmi'
	icon_state = "door1"
	blocks_air = 0
	var/operating = null
	var/visible = 1
	var/floorname
	var/floorintact
	var/floorhealth
	var/floorburnt
	var/icon/flooricon
	var/flooricon_state
	var/const/delay = 15
	var/const/prob_opens = 25
	var/list/known_by = list()
	var/can_be_auto = 1
	var/mod = null

	temp
		var/was_rwall = 0

	reinforced
		icon_state = "rdoor1"
		mod = "R"

	hive
		name = "strange hive wall"
		desc = "Looking more closely, these are actually really squat octagons, not hexagons! What!!"
		icon = 'icons/turf/walls.dmi'
		icon_state = "hive"
		can_be_auto = 0

	New()
		..()
		//Hide the wires or whatever THE FUCK
		src.levelupdate()
		src.blocks_air = 1
		src.find_icon_state()
		spawn(10)
		// so that if it's getting created by the map it works, and if it isn't this will just return
		src.setFloorUnderlay('icons/turf/floors.dmi', "plating", 0, 100, 0, "plating")

	proc/setFloorUnderlay(FloorIcon, FloorIcon_State, Floor_Intact, Floor_Health, Floor_Burnt, Floor_Name)
		if(src.underlays.len)
			//only one underlay
			return 0
		if(!(FloorIcon || FloorIcon_State))
			return 0
		if(!Floor_Health)
			Floor_Health = 150
		if(!Floor_Burnt)
			Floor_Burnt = 0
		if(!Floor_Intact)
			Floor_Intact = 1
		if(!Floor_Name)
			Floor_Name = "floor"
		underlays += image(FloorIcon, FloorIcon_State)
		src.flooricon = FloorIcon
		src.flooricon_state = FloorIcon_State
		src.floorintact = Floor_Intact
		src.floorhealth = Floor_Health
		src.floorburnt = Floor_Burnt
		src.floorname = Floor_Name
		return 1

	attack_hand(mob/user as mob)
		src.add_fingerprint(user)
		var/known = (user in known_by)
		if (src.density)
			//door is closed
			if (known)
				if (open())
					boutput(user, "<span style=\"color:blue\">The wall slides open.</span>")
			else if (prob(prob_opens))
				//it's hard to open
				if (open())
					boutput(user, "<span style=\"color:blue\">The wall slides open!</span>")
					known_by += user
			else
				return ..()
		else
			if (close())
				boutput(user, "<span style=\"color:blue\">The wall slides shut.</span>")
		return

	attackby(obj/item/screwdriver/S as obj, mob/user as mob)
		src.add_fingerprint(user)
		var/known = (user in known_by)
		if (istype(S, /obj/item/screwdriver))
			//try to disassemble the false wall
			if (!src.density || prob(prob_opens))
				//without this, you can detect a false wall just by going down the line with screwdrivers
				//if it's already open, you can disassemble it no problem
				if (src.density && !known) //if it was closed, let them know that they did something
					boutput(user, "<span style=\"color:blue\">It was a false wall!</span>")
				//disassemble it
				boutput(user, "<span style=\"color:blue\">Now dismantling false wall.</span>")
				var/floorname1	= src.floorname
				var/floorintact1	= src.floorintact
				var/floorburnt1	= src.floorburnt
				var/icon/flooricon1	= src.flooricon
				var/flooricon_state1	= src.flooricon_state
				src.density = 0
				src.RL_SetOpacity(0)
				src.update_nearby_tiles()
				var/turf/simulated/floor/F = src.ReplaceWithFloor()
				F.name = floorname1
				F.icon = flooricon1
				F.icon_state = flooricon_state1
				F.intact = floorintact1
				F.burnt = floorburnt1

				//a false wall turns into a sheet of metal and displaced girders
				var/atom/A = new /obj/item/sheet(F)
				var/atom/B = new /obj/structure/girder/displaced(F)
				if(src.material)
					A.setMaterial(src.material)
					B.setMaterial(src.material)
				else
					var/datum/material/M = getCachedMaterial("steel")
					A.setMaterial(M)
					B.setMaterial(M)
				F.levelupdate()
				logTheThing("station", user, null, "dismantles a False Wall in [user.loc.loc] ([showCoords(user.x, user.y, user.z)])")
				return
			else
				return ..()
		// grabsmash
		else if (istype(S, /obj/item/grab/))
			var/obj/item/grab/G = S
			if  (!grab_smash(G, user))
				return ..(S, user)
			else return
		else
			return src.attack_hand(user)

	proc/open()
		if (src.operating)
			return 0
		src.operating = 1
		src.name = "false wall"
		animate(src, time = delay, pixel_x = 25, easing = BACK_EASING)
		spawn(delay)
			//we want to return 1 without waiting for the animation to finish - the textual cue seems sloppy if it waits
			//actually do the opening things
			src.density = 0
			src.blocks_air = 0
			src.pathable = 1
			src.update_air_properties()
			src.RL_SetOpacity(0)
			if(!floorintact)
				src.intact = 0
				src.levelupdate()
			if(checkForMultipleDoors())
				update_nearby_tiles()
			src.operating = 0
		return 1

	proc/close()
		if (src.operating)
			return 0
		src.operating = 1
		src.name = "wall"
		animate(src, time = delay, pixel_x = 0, easing = BACK_EASING)
		src.density = 1
		src.blocks_air = 1
		src.pathable = 0
		src.update_air_properties()
		if (src.visible)
			src.RL_SetOpacity(1)
		src.intact = 1
		update_nearby_tiles()
		spawn(delay)
			//we want to return 1 without waiting for the animation to finish - the textual cue seems sloppy if it waits
			src.operating = 0
		return 1

	proc/find_icon_state()
		if (!map_setting)
			return

		//var/wall_path = /turf/simulated/wall/auto
		var/r_wall_path = /turf/simulated/wall/auto/reinforced
		if (map_setting == "COG2")
			icon = 'icons/turf/walls_supernorn.dmi'
			//wall_path = /turf/simulated/wall/auto/supernorn
			r_wall_path = /turf/simulated/wall/auto/reinforced/supernorn
		else if (map_setting == "DESTINY")
			icon = 'icons/turf/walls_destiny.dmi'
			//wall_path = /turf/simulated/wall/auto/gannets
			r_wall_path = /turf/simulated/wall/auto/reinforced/gannets
		else
			icon = 'icons/turf/walls_auto.dmi'

		var/dirs = 0
		for (var/dir in cardinal)
			var/turf/T = get_step(src, dir)
			if (istype(T, /turf/simulated/wall/auto))
				// neither of us are reinforced
				if (!istype(T, r_wall_path) && !istype(src, /turf/simulated/wall/false_wall/reinforced))
					dirs |= dir
				// both of us are reinforced
				else if (istype(T, r_wall_path) && istype(src, /turf/simulated/wall/false_wall/reinforced))
					dirs |= dir
		src.icon_state = "[mod][num2text(dirs)]"
		return src.icon_state

	get_desc()
		if (!src.density)
			return "It's a false wall. It's open."

	//Temp false walls turn back to regular walls when closed.
	temp/New()
		..()
		spawn(11)
			src.open()

	temp/close()
		if (src.operating)
			return 0
		src.operating = 1
		src.name = "wall"
		animate(src, time = delay, pixel_x = 0, easing = BACK_EASING)
		src.icon_state = "door1"
		src.density = 1
		src.blocks_air = 1
		src.pathable = 0
		src.update_air_properties()
		if (src.visible)
			src.opacity = 0
			src.RL_SetOpacity(1)
		src.intact = 1
		update_nearby_tiles()
		if(src.was_rwall)
			src.ReplaceWithRWall()
		else
			src.ReplaceWithWall()
		return 1
