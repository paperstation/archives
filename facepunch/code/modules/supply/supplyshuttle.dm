//Config stuff
#define SUPPLY_DOCKZ 2          //Z-level of the Dock.
#define SUPPLY_STATIONZ 1       //Z-level of the Station.

var/list/mechtoys = list(
	/obj/item/toy/prize/ripley,
	/obj/item/toy/prize/fireripley,
	/obj/item/toy/prize/deathripley,
	/obj/item/toy/prize/gygax,
	/obj/item/toy/prize/durand,
	/obj/item/toy/prize/honk,
	/obj/item/toy/prize/marauder,
	/obj/item/toy/prize/seraph,
	/obj/item/toy/prize/mauler,
	/obj/item/toy/prize/odysseus,
	/obj/item/toy/prize/phazon
)

/area/supply/station //DO NOT TURN THE lighting_use_dynamic STUFF ON FOR SHUTTLES. IT BREAKS THINGS.
	name = "supply shuttle"
	icon_state = "shuttle3"
	luminosity = 1
	lighting_use_dynamic = 0
	requires_power = 0

/area/supply/dock //DO NOT TURN THE lighting_use_dynamic STUFF ON FOR SHUTTLES. IT BREAKS THINGS.
	name = "supply shuttle"
	icon_state = "shuttle3"
	luminosity = 1
	lighting_use_dynamic = 0
	requires_power = 0

//SUPPLY PACKS MOVED TO /code/defines/obj/supplypacks.dm

/obj/structure/plasticflaps //HOW DO YOU CALL THOSE THINGS ANYWAY
	name = "\improper Plastic flaps"
	desc = "I definitely cant get past those. No way."
	icon = 'icons/obj/stationobjs.dmi' //Change this.
	icon_state = "plasticflaps"
	density = 0
	anchored = 1
	layer = 4
	health = 80
	max_health = 80
	damage_resistance = 0
	explosion_resistance = 5

/obj/structure/plasticflaps/CanPass(atom/A, turf/T)
	if(istype(A) && A.checkpass(PASSGLASS))
		return prob(60)

	var/obj/structure/stool/bed/B = A
	if (istype(A, /obj/structure/stool/bed) && B.buckled_mob)//if it's a bed/chair and someone is buckled, it will not pass
		return 0

	else if(istype(A, /mob/living)) // You Shall Not Pass!
		var/mob/living/M = A
		if(!M.lying && !istype(M, /mob/living/carbon/monkey) && !istype(M, /mob/living/carbon/slime))	//If your not laying down, or a small creature, no pass.
			return 0
	return ..()

/obj/structure/plasticflaps/ex_act(severity)
	switch(severity)
		if (1)
			del(src)
		if (2)
			if (prob(50))
				del(src)
		if (3)
			if (prob(5))
				del(src)

/obj/structure/plasticflaps/mining //A specific type for mining that doesn't allow airflow because of them damn crates
	name = "\improper Airtight plastic flaps"
	desc = "Heavy duty, airtight, plastic flaps."

	New() //set the turf below the flaps to block air
		var/turf/T = get_turf(loc)
		if(T)
			T.blocks_air = 1
		..()

	Del() //lazy hack to set the turf to allow air to pass if it's a simulated floor
		var/turf/T = get_turf(loc)
		if(T)
			if(istype(T, /turf/simulated/floor))
				T.blocks_air = 0
		..()


/obj/machinery/computer/ordercomp
	name = "Supply ordering console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "request"
	circuit = "/obj/item/weapon/circuitboard/ordercomp"
	var/temp = null
	var/reqtime = 0 //Cooldown for requisitions - Quarxink

/*
/obj/effect/marker/supplymarker
	icon_state = "X"
	icon = 'icons/misc/mark.dmi'
	name = "X"
	invisibility = 101
	anchored = 1
	opacity = 0
*/

/datum/supply_order
	var/ordernum
	var/datum/supply_packs/object = null
	var/orderedby = null
	var/comment = null


/obj/item/weapon/paper/manifest
	name = "Supply Manifest"


/obj/machinery/computer/ordercomp/attack_ai(var/mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/ordercomp/attack_paw(var/mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/ordercomp/attack_hand(var/mob/user as mob)
	if(..())
		return
	user.set_machine(src)
	var/dat
	if(temp)
		dat = temp
	else
		dat += {"<BR><B>Supply shuttle</B><HR>
		Location: [supply_shuttle.moving ? "Moving to station ([round((supply_shuttle.eta_time - world.time)/600,1)] Mins.)":supply_shuttle.at_station ? "Station":"Dock"]<BR>
		<HR>Supply points: [supply_shuttle.points]<BR>
		<BR>\n<A href='?src=\ref[src];order=1'>Request items</A><BR><BR>
		<A href='?src=\ref[src];vieworders=1'>View approved orders</A><BR><BR>
		<A href='?src=\ref[src];viewrequests=1'>View requests</A><BR><BR>
		<A href='?src=\ref[user];mach_close=computer'>Close</A>"}

	user << browse(dat, "window=computer;size=575x450")
	onclose(user, "computer")
	return

/obj/machinery/computer/ordercomp/Topic(href, href_list)
	if(..())
		return

	if( isturf(loc) && (in_range(src, usr) || istype(usr, /mob/living/silicon)) )
		usr.set_machine(src)

	if(href_list["order"])
		temp = "Supply points: [supply_shuttle.points]<BR><HR><BR>Request what?<BR><BR>"
		for(var/supply_name in supply_shuttle.supply_packs )
			var/datum/supply_packs/N = supply_shuttle.supply_packs[supply_name]
			if(N.hidden || N.contraband) continue																	//Have to send the type instead of a reference to
			temp += "<A href='?src=\ref[src];doorder=[supply_name]'>[supply_name]</A> Cost: [N.cost]<BR>"    //the obj because it would get caught by the garbage
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"

	else if (href_list["doorder"])
		if(world.time < reqtime)
			for(var/mob/V in hearers(src))
				V.show_message("<b>[src]</b>'s monitor flashes, \"[world.time - reqtime] seconds remaining until another requisition form may be printed.\"")
			return

		//Find the correct supply_pack datum
		var/datum/supply_packs/P = supply_shuttle.supply_packs[href_list["doorder"]]
		if(!istype(P))	return

		var/timeout = world.time + 600
		var/reason = copytext(sanitize(input(usr,"Reason:","Why do you require this item?","") as null|text),1,MAX_MESSAGE_LEN)
		if(world.time > timeout)	return
		if(!reason)	return

		var/idname = "*None Provided*"
		var/idrank = "*None Provided*"
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			idname = H.get_authentification_name()
			idrank = H.get_assignment()
		else if(issilicon(usr))
			idname = usr.real_name

		supply_shuttle.ordernum++
		var/obj/item/weapon/paper/reqform = new /obj/item/weapon/paper(loc)
		reqform.name = "Requisition Form - [P.name]"
		reqform.info += "<h3>[station_name] Supply Requisition Form</h3><hr>"
		reqform.info += "INDEX: #[supply_shuttle.ordernum]<br>"
		reqform.info += "REQUESTED BY: [idname]<br>"
		reqform.info += "RANK: [idrank]<br>"
		reqform.info += "REASON: [reason]<br>"
		reqform.info += "SUPPLY CRATE TYPE: [P.name]<br>"
		reqform.info += "ACCESS RESTRICTION: [replacetext(get_access_desc(P.access))]<br>"
		reqform.info += "CONTENTS:<br>"
		reqform.info += P.manifest
		reqform.info += "<hr>"
		reqform.info += "STAMP BELOW TO APPROVE THIS REQUISITION:<br>"

		reqform.update_icon()	//Fix for appearing blank when printed.
		reqtime = (world.time + 5) % 1e5

		//make our supply_order datum
		var/datum/supply_order/O = new /datum/supply_order()
		O.ordernum = supply_shuttle.ordernum
		O.object = P
		O.orderedby = idname
		supply_shuttle.requestlist += O

		temp = "Thanks for your request. The cargo team will process it as soon as possible.<BR>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"

	else if (href_list["vieworders"])
		temp = "Current approved orders: <BR><BR>"
		for(var/S in supply_shuttle.shoppinglist)
			var/datum/supply_order/SO = S
			temp += "[SO.object.name] approved by [SO.orderedby] [SO.comment ? "([SO.comment])":""]<BR>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"

	else if (href_list["viewrequests"])
		temp = "Current requests: <BR><BR>"
		for(var/S in supply_shuttle.requestlist)
			var/datum/supply_order/SO = S
			temp += "#[SO.ordernum] - [SO.object.name] requested by [SO.orderedby]<BR>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"

	else if (href_list["mainmenu"])
		temp = null

	add_fingerprint(usr)
	updateUsrDialog()
	return




/obj/machinery/computer/supplycomp
	name = "Supply shuttle console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "supply"
	#ifdef NEWMAP
	req_access = list(access_cargo_office_area)
	#else
	req_access = list(access_cargo)
	#endif
	circuit = "/obj/item/weapon/circuitboard/supplycomp"
	req_access_txt = "0"
	var/temp = null
	var/reqtime = 0 //Cooldown for requisitions - Quarxink
	var/hacked = 0
	var/can_order_contraband = 0


	attack_ai(var/mob/user as mob)
		return attack_hand(user)


	attack_paw(var/mob/user as mob)
		return attack_hand(user)


	attack_hand(var/mob/user as mob)
		if(!allowed(user))
			user << "\red Access Denied."
			return

		if(..())
			return
		user.set_machine(src)
		post_signal("supply")
		var/dat
		if (temp)
			dat = temp
		else
			dat += {"<BR><B>Supply shuttle</B><HR>
			\nLocation: [supply_shuttle.moving ? "Moving to station ([round((supply_shuttle.eta_time - world.time)/600,1)] Mins.)":supply_shuttle.at_station ? "Station":"Away"]<BR>
			<HR>\nSupply points: [round(supply_shuttle.points)]<BR>\n<BR>
			[supply_shuttle.moving ? "\n*Must be away to order items*<BR>\n<BR>":supply_shuttle.at_station ? "\n*Must be away to order items*<BR>\n<BR>":"\n<A href='?src=\ref[src];order=1'>Order items</A><BR>\n<BR>"]
			[supply_shuttle.moving ? "\n*Shuttle already called*<BR>\n<BR>":supply_shuttle.at_station ? "\n<A href='?src=\ref[src];send=1'>Send away</A><BR>\n<BR>":"\n<A href='?src=\ref[src];send=1'>Send to station</A><BR>\n<BR>"]
			\n<A href='?src=\ref[src];viewrequests=1'>View requests</A><BR>\n<BR>
			\n<A href='?src=\ref[src];vieworders=1'>View orders</A><BR>\n<BR>
			\n<A href='?src=\ref[user];mach_close=computer'>Close</A>"}

		user << browse(dat, "window=computer;size=575x450")
		onclose(user, "computer")
		return


	attackby(I as obj, user as mob)
		if(istype(I,/obj/item/weapon/card/emag) && !hacked)
			user << "\blue Special supplies unlocked and access requirement removed."
			hacked = 1
			req_access = list()
			return
		if(istype(I, /obj/item/weapon/screwdriver))
			playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
			if(do_after(user, 20))
				if (stat & BROKEN)
					user << "\blue The broken glass falls out."
					var/obj/structure/computerframe/A = new /obj/structure/computerframe( loc )
					new /obj/item/weapon/shard( loc )
					var/obj/item/weapon/circuitboard/supplycomp/M = new /obj/item/weapon/circuitboard/supplycomp( A )
					for (var/obj/C in src)
						C.loc = loc
					A.circuit = M
					A.state = 3
					A.icon_state = "3"
					A.anchored = 1
					del(src)
				else
					user << "\blue You disconnect the monitor."
					var/obj/structure/computerframe/A = new /obj/structure/computerframe( loc )
					var/obj/item/weapon/circuitboard/supplycomp/M = new /obj/item/weapon/circuitboard/supplycomp( A )
					if(can_order_contraband)
						M.contraband_enabled = 1
					for (var/obj/C in src)
						C.loc = loc
					A.circuit = M
					A.state = 4
					A.icon_state = "4"
					A.anchored = 1
					del(src)
		else
			attack_hand(user)
		return


	Topic(href, href_list)
		if(!supply_shuttle)
			world.log << "## ERROR: Eek. The supply_shuttle controller datum is missing somehow."
			return
		if(..())
			return

		if(isturf(loc) && ( in_range(src, usr) || istype(usr, /mob/living/silicon) ) )
			usr.set_machine(src)

		//Calling the shuttle
		if(href_list["send"])
			if(!supply_shuttle.can_move())
				temp = "For safety reasons the automated supply shuttle cannot transport live organisms, classified nuclear weaponry or homing beacons.<BR><BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"

			else if(supply_shuttle.at_station)
				supply_shuttle.moving = -1
				supply_shuttle.sell()
				supply_shuttle.send()
				temp = "The supply shuttle has departed.<BR><BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
			else
				supply_shuttle.moving = 1
				supply_shuttle.buy()
				supply_shuttle.eta_time = (world.time + supply_shuttle.movetime)
				temp = "The supply shuttle has been called and will arrive in [round(supply_shuttle.movetime/600,1)] minutes.<BR><BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
				post_signal("supply")

		else if (href_list["order"])
			if(supply_shuttle.moving) return
			temp = "Supply points: [supply_shuttle.points]<BR><HR><BR>Request what?<BR><BR>"

			for(var/supply_name in supply_shuttle.supply_packs )
				var/datum/supply_packs/N = supply_shuttle.supply_packs[supply_name]
				if(N.hidden && !hacked) continue
				if(N.contraband && !can_order_contraband) continue
				temp += "<A href='?src=\ref[src];doorder=[supply_name]'>[supply_name]</A> Cost: [N.cost]<BR>"    //the obj because it would get caught by the garbage
			temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"

		else if (href_list["doorder"])
			if(world.time < reqtime)
				for(var/mob/V in hearers(src))
					V.show_message("<b>[src]</b>'s monitor flashes, \"[world.time - reqtime] seconds remaining until another requisition form may be printed.\"")
				return

			//Find the correct supply_pack datum
			var/datum/supply_packs/P = supply_shuttle.supply_packs[href_list["doorder"]]
			if(!istype(P))	return

			var/timeout = world.time + 600
			var/reason = copytext(sanitize(input(usr,"Reason:","Why do you require this item?","") as null|text),1,MAX_MESSAGE_LEN)
			if(world.time > timeout)	return
			if(!reason)	return

			var/idname = "*None Provided*"
			var/idrank = "*None Provided*"
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				idname = H.get_authentification_name()
				idrank = H.get_assignment()
			else if(issilicon(usr))
				idname = usr.real_name

			supply_shuttle.ordernum++
			var/obj/item/weapon/paper/reqform = new /obj/item/weapon/paper(loc)
			reqform.name = "Requisition Form - [P.name]"
			reqform.info += "<h3>[station_name] Supply Requisition Form</h3><hr>"
			reqform.info += "INDEX: #[supply_shuttle.ordernum]<br>"
			reqform.info += "REQUESTED BY: [idname]<br>"
			reqform.info += "RANK: [idrank]<br>"
			reqform.info += "REASON: [reason]<br>"
			reqform.info += "SUPPLY CRATE TYPE: [P.name]<br>"
			reqform.info += "ACCESS RESTRICTION: [replacetext(get_access_desc(P.access))]<br>"
			reqform.info += "CONTENTS:<br>"
			reqform.info += P.manifest
			reqform.info += "<hr>"
			reqform.info += "STAMP BELOW TO APPROVE THIS REQUISITION:<br>"

			reqform.update_icon()	//Fix for appearing blank when printed.
			reqtime = (world.time + 5) % 1e5

			//make our supply_order datum
			var/datum/supply_order/O = new /datum/supply_order()
			O.ordernum = supply_shuttle.ordernum
			O.object = P
			O.orderedby = idname
			supply_shuttle.requestlist += O

			temp = "Order request placed.<BR>"
			temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A> | <A href='?src=\ref[src];confirmorder=[O.ordernum]'>Authorize Order</A>"

		else if(href_list["confirmorder"])
			//Find the correct supply_order datum
			var/ordernum = text2num(href_list["confirmorder"])
			var/datum/supply_order/O
			var/datum/supply_packs/P
			temp = "Invalid Request"
			for(var/i=1, i<=supply_shuttle.requestlist.len, i++)
				var/datum/supply_order/SO = supply_shuttle.requestlist[i]
				if(SO.ordernum == ordernum)
					O = SO
					P = O.object
					if(supply_shuttle.points >= P.cost)
						supply_shuttle.requestlist.Cut(i,i+1)
						supply_shuttle.points -= P.cost
						supply_shuttle.shoppinglist += O
						temp = "Thanks for your order.<BR>"
						temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
					else
						temp = "Not enough supply points.<BR>"
						temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
					break

		else if (href_list["vieworders"])
			temp = "Current approved orders: <BR><BR>"
			for(var/S in supply_shuttle.shoppinglist)
				var/datum/supply_order/SO = S
				temp += "#[SO.ordernum] - [SO.object.name] approved by [SO.orderedby][SO.comment ? " ([SO.comment])":""]<BR>"// <A href='?src=\ref[src];cancelorder=[S]'>(Cancel)</A><BR>"
			temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
/*
		else if (href_list["cancelorder"])
			var/datum/supply_order/remove_supply = href_list["cancelorder"]
			supply_shuttle_shoppinglist -= remove_supply
			supply_shuttle_points += remove_supply.object.cost
			temp += "Canceled: [remove_supply.object.name]<BR><BR><BR>"

			for(var/S in supply_shuttle_shoppinglist)
				var/datum/supply_order/SO = S
				temp += "[SO.object.name] approved by [SO.orderedby][SO.comment ? " ([SO.comment])":""] <A href='?src=\ref[src];cancelorder=[S]'>(Cancel)</A><BR>"
			temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
*/
		else if (href_list["viewrequests"])
			temp = "Current requests: <BR><BR>"
			for(var/S in supply_shuttle.requestlist)
				var/datum/supply_order/SO = S
				temp += "#[SO.ordernum] - [SO.object.name] requested by [SO.orderedby]  [supply_shuttle.moving ? "":supply_shuttle.at_station ? "":"<A href='?src=\ref[src];confirmorder=[SO.ordernum]'>Approve</A> <A href='?src=\ref[src];rreq=[SO.ordernum]'>Remove</A>"]<BR>"

			temp += "<BR><A href='?src=\ref[src];clearreq=1'>Clear list</A>"
			temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"

		else if (href_list["rreq"])
			var/ordernum = text2num(href_list["rreq"])
			temp = "Invalid Request.<BR>"
			for(var/i=1, i<=supply_shuttle.requestlist.len, i++)
				var/datum/supply_order/SO = supply_shuttle.requestlist[i]
				if(SO.ordernum == ordernum)
					supply_shuttle.requestlist.Cut(i,i+1)
					temp = "Request removed.<BR>"
					break
			temp += "<BR><A href='?src=\ref[src];viewrequests=1'>OK</A>"

		else if (href_list["clearreq"])
			supply_shuttle.requestlist.Cut()
			temp = "List cleared.<BR>"
			temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"

		else if (href_list["mainmenu"])
			temp = null

		add_fingerprint(usr)
		updateUsrDialog()
		return


	proc/post_signal(var/command)
		var/datum/radio_frequency/frequency = radio_controller.return_frequency(1435)

		if(!frequency) return

		var/datum/signal/status_signal = new
		status_signal.source = src
		status_signal.transmission_method = 1
		status_signal.data["command"] = command
		frequency.post_signal(src, status_signal)
		return




