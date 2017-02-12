var/datum/subsystem/supply_shuttle/supply_shuttle

#define SUPPLY_STATION_AREATYPE "/area/supply/station" //Type of the supply shuttle area for station
#define SUPPLY_DOCK_AREATYPE "/area/supply/dock"	//Type of the supply shuttle area for dock

/datum/subsystem/supply_shuttle
	name = "Supply Shuttle"
	wait = 300

	var/points = 50
	var/points_per_minute = 2
	var/points_per_slip = 2
	var/points_per_crate = 5
	var/plasma_per_point = 5 // 2 plasma for 1 point
	//control
	var/ordernum
	var/list/shoppinglist = list()
	var/list/requestlist = list()
	var/list/supply_packs = list()
	//shuttle movement
	var/at_station = 0
	var/movetime = 1200
	var/moving = 0
	var/eta_time
	//var/eta

/datum/subsystem/supply_shuttle/New()
	ordernum = rand(1,9000)
	if(supply_shuttle != src)
		supply_shuttle = src
	return ..()

/datum/subsystem/supply_shuttle/fire()
	set background = 1

	points += (points_per_minute / 600) * wait

	if(moving == 1)
		if((eta_time - world.time) <= 0)
			send()

/datum/subsystem/supply_shuttle/Initialize()
	for(var/typepath in (typesof(/datum/supply_packs) - /datum/supply_packs))
		var/datum/supply_packs/P = new typepath()
		supply_packs[P.name] = P

/datum/subsystem/supply_shuttle
	proc/send()
		var/area/from
		var/area/dest
		var/area/the_shuttles_way
		switch(at_station)
			if(1)
				from = locate(SUPPLY_STATION_AREATYPE)
				dest = locate(SUPPLY_DOCK_AREATYPE)
				the_shuttles_way = from
				at_station = 0
			if(0)
				from = locate(SUPPLY_DOCK_AREATYPE)
				dest = locate(SUPPLY_STATION_AREATYPE)
				the_shuttles_way = dest
				at_station = 1
		moving = 0

		//Do I really need to explain this loop?
		for(var/mob/living/unlucky_person in the_shuttles_way)
			unlucky_person.gib()

		from.move_contents_to(dest)

	//Check whether the shuttle is allowed to move
	proc/can_move()
		if(moving) return 0

		var/area/shuttle = locate(/area/supply/station)
		if(!shuttle) return 0

		if(forbidden_atoms_check(shuttle))
			return 0

		return 1

	//To stop things being sent to centcomm which should not be sent to centcomm. Recursively checks for these types.
	proc/forbidden_atoms_check(atom/A)
		if(istype(A,/mob/living))
			return 1
		if(istype(A,/obj/item/weapon/disk/nuclear))
			return 1
		if(istype(A,/obj/machinery/nuclearbomb))
			return 1
		if(istype(A,/obj/item/device/radio/beacon))
			return 1

		for(var/i=1, i<=A.contents.len, i++)
			var/atom/B = A.contents[i]
			if(.(B))
				return 1

	//Sellin
	proc/sell()
		var/shuttle_at
		if(at_station)	shuttle_at = SUPPLY_STATION_AREATYPE
		else			shuttle_at = SUPPLY_DOCK_AREATYPE

		var/area/shuttle = locate(shuttle_at)
		if(!shuttle)	return

		var/plasma_count = 0

		for(var/atom/movable/MA in shuttle)
			if(istype(MA,/obj/))
				if(MA in traitoritemlist)
					if(vouchers <= 10)//So traitors can't abuse.
						vouchers++
			if(MA.anchored)	continue

			// Must be in a crate!
			if(istype(MA,/obj/structure/closet/crate))
				points += points_per_crate
				var/find_slip = 1

				for(var/atom in MA)
					// Sell manifests
					var/atom/A = atom
					if(find_slip && istype(A,/obj/item/weapon/paper/manifest))
						var/obj/item/weapon/paper/slip = A
						if(slip.stamped && slip.stamped.len) //yes, the clown stamp will work. clown is the highest authority on the station, it makes sense
							points += points_per_slip
							find_slip = 0
						continue

					// Sell plasma
					if(istype(A, /obj/item/stack/sheet/mineral/plasma))
						var/obj/item/stack/sheet/mineral/plasma/P = A
						plasma_count += P.amount
			del(MA)

		if(plasma_count)
			points += Floor(plasma_count / plasma_per_point)

	//Buyin
	proc/buy()
		if(!shoppinglist.len) return

		var/shuttle_at
		if(at_station)	shuttle_at = SUPPLY_STATION_AREATYPE
		else			shuttle_at = SUPPLY_DOCK_AREATYPE

		var/area/shuttle = locate(shuttle_at)
		if(!shuttle)	return

		var/list/clear_turfs = list()

		for(var/turf/T in shuttle)
			if(T.density || T.contents.len)	continue
			clear_turfs += T

		for(var/S in shoppinglist)
			if(!clear_turfs.len)	break
			var/i = rand(1,clear_turfs.len)
			var/turf/pickedloc = clear_turfs[i]
			clear_turfs.Cut(i,i+1)

			var/datum/supply_order/SO = S
			var/datum/supply_packs/SP = SO.object

			var/atom/A = new SP.containertype(pickedloc)
			A.name = "[SP.containername] [SO.comment ? "([SO.comment])":"" ]"

			//supply manifest generation begin

			var/obj/item/weapon/paper/manifest/slip = new /obj/item/weapon/paper/manifest(A)
			slip.info = "<h3>[command_name()] Shipping Manifest</h3><hr><br>"
			slip.info +="Order #[SO.ordernum]<br>"
			slip.info +="Destination: [station_name]<br>"
			slip.info +="[supply_shuttle.shoppinglist.len] PACKAGES IN THIS SHIPMENT<br>"
			slip.info +="CONTENTS:<br><ul>"

			//spawn the stuff, finish generating the manifest while you're at it
			if(SP.access)
				A:req_access = list()
				A:req_access += text2num(SP.access)

			var/list/contains
			if(istype(SP,/datum/supply_packs/randomised))
				var/datum/supply_packs/randomised/SPR = SP
				contains = list()
				if(SPR.contains.len)
					for(var/j=1,j<=SPR.num_contained,j++)
						contains += pick(SPR.contains)
			else
				contains = SP.contains

			for(var/typepath in contains)
				if(!typepath)	continue
				var/atom/B2 = new typepath(A)
				if(SP.amount && B2:amount) B2:amount = SP.amount
				slip.info += "<li>[B2.name]</li>" //add the item to the manifest

			//manifest finalisation
			slip.info += "</ul><br>"
			slip.info += "CHECK CONTENTS AND STAMP BELOW THE LINE TO CONFIRM RECEIPT OF GOODS<hr>"

		supply_shuttle.shoppinglist.Cut()
		return

#undef SUPPLY_STATION_AREATYPE
#undef SUPPLY_DOCK_AREATYPE