var/global/mob/living/simple_animal/starship/starship = null

/mob/living/simple_animal/starship
	name = "S.S. Facepunchia"
	icon ='icons/vehicles/starship.dmi'
	icon_state="ship"
	var/canclick = 1
	canmove = 0
	health = 5000
	maxHealth = 5000
	var/fuel = 0
	var/spaces = 5
	var/obj/item/device/radio/headset/ears = null
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	luminosity = 10
	max_n2 = 0
	minbodytemp = 0
	status_flags = CANPUSH
	var/warned = 0
	var/mob/living/prevmob = null
	var/list/available_channels = list()
	var/wait = 0
	attack_hand()
		if(world.time < wait)
			usr << "<span class='notice'>Error: The starship is still powering up its systems. Estimated time to completion: [round(((wait - world.time) / 10) / 60)] minutes.</span>"
			return
		if(canclick)//So you can't go to the ship as the ship itself, its another z-level you know
			if(usr == src)
				return
			if(usr in range(1,src))//Controls the range of the click
				var/obj/effect/landmark/shiploc/Z = locate(/obj/effect/landmark/shiploc/)in world
				usr.loc = Z.loc
	New()
		starship = src
		ears = new/obj/item/device/radio/headset/headset_starship
		available_channels = list(":z")
		..()
		var/MM	=	text2num(time2text(world.timeofday, "MM")) 	// get the current month
		var/DD	=	text2num(time2text(world.timeofday, "DD")) 	// get the current day
		if(DD == 31 && MM == 10)
			name = pick("S.S. Scarepunchia", "S.S. Frankengrief")
		if(DD == 25 && MM == 12)
			name = pick("S.S. Christmasclause", "S.S. Rednose")
		name = pick("S.S. Facepunchia", "S.S. Assistanic", "S.S. Runtimica", "S.S. Dumbfire", "S.S. Lingling", "S.S. Opthree", "S.S. Bookinson", "S.S. Disappointment")
		wait = world.time + 200	//+ thirty minutes default


	Move()
		..()
		if(z == 2)
			ibrokeeverything()


/mob/living/simple_animal/starship/Process_Spacemove(var/check_drift = 1)
	inertia_dir = 0
	return 1

/mob/living/simple_animal/starship/bullet_act(var/obj/item/projectile/Proj)
	health()
	if(prob(50-Proj.force))
		if(client)
			var/mob/living/C = src.client.lastknownmob
			C.say("*scream")
		var/area/shuttle/starship/Z = locate(/area/station/starship/)in world
		for(var/mob/living/X in Z)
			spawn(0)
				if(X.buckled)
					shake_camera(X, 7, 1) // buckled, not a lot of shaking
				else
					shake_camera(X, 10, 2) // unbuckled, HOLY SHIT SHAKE THE ROOM
					X.deal_damage(5, WEAKEN)
			shake_camera(X, 7, 1)
		return
	..()


/mob/living/simple_animal/starship/attackby(var/obj/item/O as obj, var/mob/user as mob)
	health()
	if(prob(50-O.force))
		if(client)
			var/mob/living/C = src.client.lastknownmob
			C.say("*scream")
		var/area/shuttle/starship/Z = locate(/area/station/starship)in world
		for(var/mob/X in Z)
			spawn(0)
				if(X.buckled)

					shake_camera(X, 1, 1)
				else
					shake_camera(X, 5, 2)
			shake_camera(X, 7, 1)
		return
	..()

/mob/living/simple_animal/starship/emp_act()
	return

/mob/living/simple_animal/starship/proc/health()
	if(health < maxHealth * 0.75 && warned == 0)
		for(var/area/station/starship/impact_area in world)
			for(var/mob/living/C in impact_area)
				playsound(C, 'sound/machines/starship75.ogg', 75, 0)
				C << "<b>[name]</b> alerts, \"Hull strength at 75%.\""
				warned = 1
				return

	if(health < maxHealth * 0.50 && warned == 1)
		for(var/area/station/starship/impact_area in world)
			for(var/mob/living/C in impact_area)
				playsound(C, 'sound/machines/starship50.ogg', 75, 0)
				C << "<b>[name]</b> alerts, \"Hull strength at 50%.\""
				warned = 2
				return

	if(health < maxHealth * 0.25 && warned == 2)
		for(var/area/station/starship/impact_area in world)
			for(var/mob/living/C in impact_area)
				playsound(C, 'sound/machines/starship25.ogg', 75, 0)
				C << "<b>[name]</b> alerts, \"Hull strength at 25%.\""
				warned = 3
				return

	if(health < maxHealth * 0.05 && warned == 3)
		for(var/area/station/starship/impact_area in world)
			for(var/mob/living/C in impact_area)
				playsound(C, 'sound/machines/starshipevac.ogg', 75, 0)
				C << "<b>[name]</b> alerts, \"Hull strength at critical level, prepare to evacuate!\""
				warned = 4
				return

	if(health < maxHealth * 0.02 && warned == 4)
		for(var/area/station/starship/impact_area in world)
			for(var/mob/living/C in impact_area)
				playsound(C, 'sound/effects/evac2.ogg', 75, 0)
				warned = 5
				return

/mob/living/simple_animal/starship/Move()
	var/turf/T = src.loc

	if(spaces >= 1)
		spaces--
		if(istype(T, /turf/simulated/floor/plating/starshipplating))
			..()
			return
		if(istype(T, /turf/simulated/))
			src << "The starship stalls because its stuck on something!"
			return
		if(istype(T, /turf/unsimulated/floor/ash))
			src << "The starship stalls because its stuck on something!"
			return
		..()
		return
	if(spaces == 0)
		if(fuel >= 1)
			fuel -= rand(10,20)//Temp
			spaces = 5
		else
			src << "The starship has run out of plasma fuel!"

/*
/mob/living/simple_animal/starship/Life()//Ejects braindeads
	if(src.client.is_afk() && client)
		if(client.lastknownmob)
			client.mob = client.lastknownmob
*/
/mob/living/simple_animal/starship/Die()
	..()
	ibrokeeverything()
/mob/living/simple_animal/starship/proc/ibrokeeverything()

	client.mob = client.lastknownmob//stop the client from breaking by returning and ejecting the mob container
	for(var/obj/structure/pod/C in world)
		for(var/mob/living/D in C)
			if(D)
				D.loc = C.loc
	canclick = 0//Since there isn't a need for turning the computer back on, it stays off. Additionally the ship can't be rentered if exited
	for(var/area/station/starship/impact_area in world)
		var/turf/T = pick(get_area_turfs(impact_area))
		if(T)
			spawn(200)
				for(var/mob/M in range(10, src))
					if(!M.stat && !istype(M, /mob/living/silicon/ai))
						shake_camera(M, 7, 1)
				playsound(impact_area, 'sound/effects/starshipinteriorexplosion.ogg', 75, 0)
				new/obj/effect/effect/harmless_smoke (T.loc)
				for(var/mob/living/Z in impact_area)
					Z.unlock_achievement("Gotta get that Boom Boom Boom")
					Z.gib()
/obj/machinery/console1
	name = "Control Machine"
	icon = 'icons/obj/computer.dmi'
	icon_state = "comm_monitor"
	var/on = 0
	var/mob/living/mob
	var/obj/
	var/mob/living/simple_animal/starship/linked = null
	New()
		linked = starship
	attack_hand(mob/user as mob)
		if(!on)
			on = 1
			mob = user
			usr.client.lastknownmob = usr
			if(starship)
				var/mob/living/simple_animal/starship/S1 = starship
				S1.prevmob = usr.client.mob
				usr.client.mob = S1
				for(var/obj/structure/pod/C in world)
					usr.loc = C
				S1.client.screen += new /obj/screen/exit
				S1.client.screen += new /obj/screen/lasergun
				S1.client.screen += new /obj/screen/dimensionaltransgress
				S1.client.screen += new /obj/screen/crane
				S1.canclick = 0
				S1.canmove = 1
				S1 << "Your mind has been transported to the [name] data center. You will not be able to control your body at all while connected to the transmitters; which means you can not talk either. The [name] is equiped with two modules, a transmitter deactivator and a laser cannon module."
				icon_state = "comm_logs"

/obj/screen/exit
	icon ='icons/vehicles/starship.dmi'
	icon_state="body"
	screen_loc = "1,1"
	layer = MOB_LAYER+100
	var/obj/machinery/console1/linked
	New()
		for(var/obj/machinery/console1/X in world)
			linked = X

	DblClick()
		usr.client.screen -= locate(/obj/screen/exit)in usr.client.screen
		usr.client.screen -= locate(/obj/screen/lasergun)in usr.client.screen
		usr.client.screen -= locate(/obj/screen/dimensionaltransgress)in usr.client.screen
		usr.client.screen -= locate(/obj/screen/crane)in usr.client.screen
		if(usr.client.lastknownmob)//Fail safe just in case, makes the player a ghost if they don't return to their own body before its destroyed
			usr.client.mob = usr.client.lastknownmob
		else
			usr.ghostize()
		spawn(1)
			for(var/obj/structure/pod/C in world)
				for(var/mob/living/D in C)
					D.loc = C.loc
		for(var/obj/machinery/console1/Z in world)
			Z.on = 0
			Z.mob = null
			Z.icon_state = "comm_logs"
		for(var/mob/living/simple_animal/starship/S1 in world)
			S1.canclick = 1
			S1.canmove = 0

/obj/screen/lasergun
	icon ='icons/vehicles/starship.dmi'
	icon_state="fire1"
	screen_loc = "2,1"
	var/canfire = 1

	DblClick()
		if(canfire)
			icon_state="fire2"
			canfire = 0
			for(var/mob/living/simple_animal/starship/S1 in world)
				var/obj/item/projectile/beam/emitter/A = new /obj/item/projectile/beam/deathray( S1.loc )
				playsound(S1.loc, 'sound/effects/shoot.ogg', 25, 1)
				var/area/shuttle/starship/Z = locate(/area/station/starship)in world
				for(var/mob/living/C in Z)
					playsound(Z, 'sound/effects/hit.ogg', 25, 1)
					shake_camera(Z, 2, 1) // buckled, not a lot of shaking
				A.dir = S1.dir
				switch(S1.dir)
					if(NORTH)
						A.yo = 20
						A.xo = 0
					if(EAST)
						A.yo = 0
						A.xo = 20
					if(WEST)
						A.yo = 0
						A.xo = -20
					else
						A.yo = -20
						A.xo = 0
				A.process()
				spawn(50)
					canfire = 1
					icon_state="fire1"
					usr << "Laser is off cooldown"

/obj/effect/landmark/starship/
	name = "starship away mission"

var/global/dtphonehome = 0
var/global/list/starshipaway = list()
/obj/screen/dimensionaltransgress
	icon ='icons/vehicles/starship.dmi'
	icon_state="rift1"
	screen_loc = "3,1"
	var/canfire = 1
	var/found = 0

	DblClick()
		if(canfire)
			if(dtphonehome)
				canfire = 0
				var/obj/effect/landmark/starship/X = pick(starshipaway)
				starship.canmove = 0
				starship << "Preparing for warp, pilot system offline."
				spawn(100)
					starship.loc = X.loc
					for(var/mob/living/C in starship)
						C << "Warping."
						playsound(C, 'sound/machines/dtmodule.ogg', 25, 1)
					var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
					spark_system.set_up(5, 0, starship.loc)
					spark_system.start()
					starship << "Warp complete, pilot system online."
					starship.canmove = 1
					spawn(500)
						canfire = 1
						icon_state="fire1"
						usr << "DT Module fully charged"
						icon_state="rift2"
			else
				usr << "You load a list of warp portals into the Starships drive."
				for(var/obj/effect/landmark/starship/C in world)
					starshipaway.Add(C)
				dtphonehome = 1




/obj/screen/crane
	icon ='icons/vehicles/starship.dmi'
	icon_state="crane1"
	screen_loc = "4,1"
	var/canfire = 1
	var/found = 0

	DblClick()
		if(canfire)
			usr << "You suck in nearby items."
			icon_state="crane2"
			canfire = 0
			for(var/obj/item/X in range(1,usr.client.mob))
				for(var/obj/effect/landmark/shipcargoloc/Z in world)
					X.loc = Z.loc
			spawn(100)
				icon_state="crane1"
				usr << "Crane is now ready"
				canfire = 1


/obj/structure/pod
	name = "container pod"
	desc = "Holds the controller of the ship"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "scanner_0"


/obj/machinery/power/fuel
	name = "Plasma Generator"
	desc = "Powers starships with plasma sheets"
	icon ='icons/vehicles/starship.dmi'
	icon_state="generator"
	anchored = 1
	density = 1
	var/fuelholder = 0

	attackby(I as obj, user as mob)
		..()
		if(istype(I, /obj/item/stack/sheet/mineral/plasma))
			var/obj/item/stack/sheet/mineral/plasma/C = I
			for(var/mob/living/simple_animal/starship/X in world)
				X.fuel += 400*C.amount
				fuelholder = X.fuel
				user << "You insert the plasma sheets. The ship has [X.fuel] fuel."
				del(C)

	attack_hand(user as mob)
		..()
		for(var/mob/living/simple_animal/starship/X in world)
			user << "The ship has [X.fuel] fuel."

	process()
		..()
		for(var/mob/living/simple_animal/starship/X in world)
			if(X.fuel >= 0)
				add_avail(fuelholder)

	New()
		processing_objects.Add(src)




/obj/structure/docking
	name = "ship builder"
	desc = "Add four parts and a core to make a starship!"
	icon ='icons/vehicles/starship.dmi'
	icon_state="buidingdock"
	var/prog = 0
	anchored = 1
	density = 1


/obj/structure/docking/attackby(obj/item/weapon/W as obj, mob/user as mob)
	switch(prog)
		if(0)
			if(istype(W, /obj/item/starship/part1))
				user << "You add the [W.name] to the starship base"
				prog = 1
				user.drop_item(W)
				del(W)
		if(1)
			if(istype(W, /obj/item/starship/part2))
				user << "You add the [W.name] to the starship base"
				prog = 2
				user.drop_item(W)
				del(W)
		if(2)
			if(istype(W, /obj/item/starship/part3))
				user << "You add the [W.name] to the starship base"
				prog = 3
				user.drop_item(W)
				del(W)
		if(3)
			if(istype(W, /obj/item/starship/core))
				user << "You attach the [W.name] to the starship base"
				prog = 4
				user.drop_item(W)
				del(W)
		if(4)
			if(istype(W, /obj/item/weapon/wrench))
				user << "You [W.name] the parts together."
				prog = 5
		if(5)
			if(istype(W, /obj/item/starship/frame))
				user << "You attach the [W.name] to the starship base"
				prog = 6
				user.drop_item(W)
				icon_state = "buildingdock2"
				del(W)
		if(6)
			if(istype(W, /obj/item/weapon/cell/hyper))
				user << "You insert the [W.name] to the starship."
				prog = 7
				user.drop_item(W)
				del(W)
		if(7)
			if(istype(W, /obj/item/weapon/cable_coil))
				user << "You wire the cables to the starship."
				prog = 8
				user.drop_item(W)
				del(W)
		if(8)
			if(istype(W, /obj/item/weapon/circuitboard/communications))
				user << "You insert the [W.name] to the circuits."
				prog = 9
				user.drop_item(W)
				del(W)
		if(9)
			if(istype(W, /obj/item/device/radio/beacon))
				user << "You attach the [W.name] to the starship base"
				prog = 10
				user.drop_item(W)
				del(W)
		if(10)
			if(istype(W, /obj/item/weapon/wrench))
				user << "You wrench the parts togethier, completing the starship!"
				playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
				new /mob/living/simple_animal/starship( src.loc )
				del(src)

/obj/item/starship/part1
	name = "Blasto Module"
	desc = "Its a part for a starship"
	icon ='icons/vehicles/starship.dmi'
	icon_state="part1"

/obj/item/starship/part2
	name = "Bluespace Crane"
	desc = "Its a part for a starship"
	icon ='icons/vehicles/starship.dmi'
	icon_state="part2"

/obj/item/starship/part3
	name = "Dimensional Warpfinder"
	desc = "Its a part for a starship"
	icon ='icons/vehicles/starship.dmi'
	icon_state="part3"

/obj/item/starship/core
	name = "Alien Core"
	desc = "Its a part for a starship"
	icon ='icons/vehicles/starship.dmi'
	icon_state="core"

/obj/item/starship/frame
	name = "starship frame"
	desc = "Its a part for a starship"
	icon ='icons/vehicles/starship.dmi'
	icon_state="frame"





/obj/screen/exit2
	name = "Return to body"
	desc = "Returns you to your body, if you still exist"
	icon ='icons/vehicles/starship.dmi'
	icon_state="body"
	screen_loc = "1,5"
	layer = MOB_LAYER+100
	var/obj/machinery/console1/linked

	DblClick(mob/user as mob)
		usr.client.screen -= locate(/obj/screen/exit)in usr.client.screen
		usr.client.mob.stat = 2



































