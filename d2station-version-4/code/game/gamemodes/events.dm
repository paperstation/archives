/proc/meteorevent()
	if (meteorevent)
		if (prob(10)) meteor_wave()
		else spawn_meteors()
		if (prob(1))
			if (prob(1))
				meteorevent = 0
	spawn(5)
		meteorevent()

/proc/start_events()
	if(prob(1))//Every 120 seconds and prob 50 2-4 weak spacedusts will hit the station
		spawn(1)
			dust_swarm("weak")
	if (!event && prob(eventchance))
		event()
		hadevent = 1
		score_eventsendured++
		spawn(1600)
			event = 0
	spawn(1500)
		start_events()

/proc/event()
	event = 1

	switch(rand(1,9))
		if(1)
			command_alert("Meteors have been detected on collision course with the station.", "Meteor Alert!")
			//world << sound('meteors.ogg')
			meteorevent = 1
			dothemeteor()

		if(2)
			command_alert("Gravitational anomalies detected on the station. There is no additional data.", "Anomaly Alert!")
			//world << sound('granomalies.ogg')
			var/turf/T = pick(blobstart)
			var/obj/bhole/bh = new /obj/bhole( T.loc, 30 )
			spawn(rand(50, 300))
				del(bh)

/*
		if(3) //Leaving the code in so someone can try and delag it, but this event can no longer occur randomly, per SoS's request. --NEO
			command_alert("Space-time anomalies detected on the station. There is no additional data.", "Anomaly Alert!")
//			world << sound('spanomalies.ogg')
			var/turf/picked
			for(var/turf/simulated/floor/T in turfs)
				if(prob(20))
					spawn(50+rand(0,3000))
						picked = pick(turfs)
						var/obj/portal/P = new /obj/portal( T )
						P.target = picked
						P.creator = null
						P.icon = 'objects.dmi'
						P.failchance = 0
						P.icon_state = "anom"
						P.name = "wormhole"
						spawn(rand(300,600))
							del(P)
*/

		if(4)
			command_alert("Pirates have begun boarding the station!", "Boarding Alert!") //lolnowearentunderattacktimeforpanics
		if(5)
			command_alert("Russians have boarded the station!", "Boarding Alert!")
		//	alien_infestation() //please may god have mercy on my soul for doing this.
		if(6)
			viral_outbreak()
		if(7)
			high_radiation_event()
		if(8)
			command_alert("Centcom is now a child company of nanotransen!", "Corporate Alert!")
		if(9)
			command_alert("Farm Station 11 has produced a surplus crop, please accept these crops as thanks from us at Centcom!", "Bumper-crop Alert!")
			bumpercrop()
		//	lightsout()
		//	viral_outbreak()


/proc/dotheblobbaby()
	if (blobevent)
		for(var/obj/blob/B in world)
			if (prob (40))
				B.Life()
		spawn(30)
			dotheblobbaby()

proc/dothemeteor()
	meteorevent = 1
	spawn(600)
		meteorevent = 0
	return 0

/obj/bhole/New()
	src:life()

/obj/bhole/Bumped(atom/A)
	if (istype(A,/mob/living/carbon/human))
		A:mutantrace = pick("sanic","dog","vriska","rabbit")
	else
		A:ex_act(1.0)

/obj/bhole/proc/life() //Oh man , this will LAG

	if (prob(10))
		src.anchored = 0
		step(src,pick(alldirs))
		if (prob(30))
			step(src,pick(alldirs))
		src.anchored = 1

	for (var/atom/X in orange(9,src))
		if ((istype(X,/obj) || istype(X,/mob/living)) && prob(7))
			if (!X:anchored)
				step_towards(X,src)

	for (var/atom/B in orange(7,src))
		if (istype(B,/obj))
			if (!B:anchored && prob(50))
				step_towards(B,src)
				if(prob(10)) B:ex_act(3.0)
			else
				B:anchored = 0
				//step_towards(B,src)
				//B:anchored = 1
				if(prob(10)) B:ex_act(3.0)
		else if (istype(B,/turf))
			if (istype(B,/turf/simulated) && (prob(1) && prob(75)))
				B:ReplaceWithSpace()
		else if (istype(B,/mob/living))
			step_towards(B,src)


	for (var/atom/A in orange(4,src))
		if (istype(A,/obj))
			if (!A:anchored && prob(90))
				step_towards(A,src)
				if(prob(30)) A:ex_act(2.0)
			else
				A:anchored = 0
				//step_towards(A,src)
				//A:anchored = 1
				if(prob(30)) A:ex_act(2.0)
		else if (istype(A,/turf))
			if (istype(A,/turf/simulated) && prob(1))
				A:ReplaceWithSpace()
		else if (istype(A,/mob/living))
			step_towards(A,src)


	for (var/atom/D in orange(1,src))
		//if (hascall(D,"blackholed"))
		//	call(D,"blackholed")(null)
		//	continue
		if (istype(D,/mob/living/carbon/human))
			D:mutantrace = pick("sanic","dog","vriska","rabbit")
		else
			D:ex_act(1.0)

	spawn(17)
		life()

/proc/power_failure()
	command_alert("Abnormal activity detected in [station_name()]'s powernet. As a precautionary measure, the station's power will be shut off for an indeterminate duration.", "Critical Power Failure!")
	//world << sound('poweroff.ogg')
	for(var/obj/machinery/power/apc/C in machines)
		if(C.cell && C.z == 1)
			C.cell.charge = 0
	for(var/obj/machinery/power/smes/S in machines)
		if(istype(get_area(S), /area/turret_protected) || S.z != 1)
			continue
		S.charge = 0
		S.output = 0
		S.online = 0
		S.updateicon()
		S.power_change()
	for(var/area/A in areaz)
		if(A.name != "Space" && A.name != "Engine Walls" && A.name != "Chemical Lab Test Chamber" && A.name != "Escape Shuttle" && A.name != "Arrival Area" && A.name != "Arrival Shuttle" && A.name != "start area" && A.name != "Engine Combustion Chamber")
			A.power_light = 0
			A.power_equip = 0
			A.power_environ = 0
			A.power_change()

/proc/power_restore()
	command_alert("Power has been restored to [station_name()]. We apologize for the inconvenience.", "Power Systems Nominal!")
	//world << sound('poweron.ogg')
	for(var/obj/machinery/power/apc/C in machines)
		if(C.cell && C.z == 1)
			C.cell.charge = C.cell.maxcharge
	for(var/obj/machinery/power/smes/S in machines)
		if(S.z != 1)
			continue
		S.charge = S.capacity
		S.output = 200000
		S.online = 1
		S.updateicon()
		S.power_change()
	for(var/area/A in areaz)
		if(A.name != "Space" && A.name != "Engine Walls" && A.name != "Chemical Lab Test Chamber" && A.name != "space" && A.name != "Escape Shuttle" && A.name != "Arrival Area" && A.name != "Arrival Shuttle" && A.name != "start area" && A.name != "Engine Combustion Chamber")
			A.power_light = 1
			A.power_equip = 1
			A.power_environ = 1
			A.power_change()

/proc/fartstorm()
	command_alert("Abnormal space wind approaching station, suggest panic.")
	world << sound('airraid.ogg')
	spawn(rand(30,500))
	world << sound('fartstorm.ogg')
	for(var/mob/living/carbon/human/H in mobz)
		if(H.lying || H.sleeping || H.weakened || H.stat)
			H << "\blue A huge woosh of air flows over your head, and a rancid smell fills your nostrils. Good thing you weren't standing up!"
			shake_camera(H, 1, 1)
		else
			H.emote("superfart")
			shake_camera(H, 2, 1)
			H << "\red ARGH! Your rectal region shakes furiously!"

/proc/cumstorm()
	command_alert("Massive white object zeroing in on station, suggest panic.")
	world << sound('airraid.ogg')
	spawn(rand(30,500))
	for(var/mob/living/carbon/human/H in mobz)
	//	if(H.lying || H.sleeping || H.weakened || H.stat)
		//	H << "\blue A huge woosh of air flows over your head, and a rancid smell fills your nostrils. Good thing you weren't standing up!"
		//	shake_camera(H, 1, 1) - fuck you i can copy my code if i want to
		H.emote("superwank")
		shake_camera(H, 5, 1)
		H << "\red Weeeeeeeeeeeeeeeeee!"
		spawn(30)
		H.weakened = 4
		H.paralysis = 4
	//	if(prob(45))
	//		H.contract_disease(new /datum/disease/baby,1) // if it hadn't been for cotton eye joe
	//		H << "\red Urgh, you feel sick."


/proc/viral_outbreak(var/virus = null)
	command_alert("Confirmed outbreak of level 4 viral biohazard aboard [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert!")
	//world << sound('outbreak7.ogg')
	var/virus_type
	if(!virus)
		virus_type = pick(/datum/disease/cold,/datum/disease/appendicitis,/datum/disease/alzheimers,/datum/disease/ebola,/datum/disease/fake_gbs,/datum/disease/flu,/datum/disease/fluspanish,/datum/disease/gastric_ejections,/datum/disease/gbs,/datum/disease/inhalational_anthrax,/datum/disease/mochashakah,/datum/disease/plague,/datum/disease/squirts,/datum/disease/swineflu,/datum/disease/dnaspread)
	else
		switch(virus)
			if("fake gbs")
				virus_type = /datum/disease/fake_gbs
			if("gbs")
				virus_type = /datum/disease/gbs
			if("cold")
				virus_type = /datum/disease/cold
			if("flu")
				virus_type = /datum/disease/flu
			if("appendicitis")
				virus_type = /datum/disease/appendicitis
			if("alzheimers")
				virus_type = /datum/disease/alzheimers
			if("ebola")
				virus_type = /datum/disease/ebola
			if("fluspanish")
				virus_type = /datum/disease/fluspanish
			if("gastric_ejections")
				virus_type = /datum/disease/gastric_ejections
			if("mochashakah")
				virus_type = /datum/disease/mochashakah
			if("plague")
				virus_type = /datum/disease/plague
			if("squirts")
				virus_type = /datum/disease/squirts
			if("swineflu")
				virus_type = /datum/disease/swineflu
			if("DNAspread")
				virus_type = /datum/disease/dnaspread


	for(var/mob/living/carbon/human/H in world)

		var/foundAlready = 0 // don't infect someone that already has the virus
		for(var/datum/disease/D in H.viruses)
			foundAlready = 1
		if(H.stat == 2 || foundAlready)
			continue

		if(virus_type == /datum/disease/dnaspread) //Dnaspread needs strain_data set to work.
			if((!H.dna) || (H.sdisabilities & 1)) //A blindness disease would be the worst.
				continue
			var/datum/disease/dnaspread/D = new
			D.strain_data["name"] = H.real_name
			D.strain_data["UI"] = H.dna.uni_identity
			D.strain_data["SE"] = H.dna.struc_enzymes
			D.carrier = 1
			D.holder = H
			D.affected_mob = H
			H.viruses += D
			break
		else
			var/datum/disease/D = new virus_type
			D.carrier = 1
			D.holder = H
			D.affected_mob = H
			H.viruses += D
			break

/proc/alien_infestation() // -- TLE
	command_alert("Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.", "Lifesign Alert!")
	//world << sound('aliens.ogg')
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in machines)
		if(temp_vent.loc.z == 1 && !temp_vent.welded)
			vents.Add(temp_vent)
	var/spawncount = rand(2, 6)
	while(spawncount > 1)
		var/obj/vent = pick(vents)
		if(prob(50))
			new /obj/alien/facehugger (vent.loc)
		if(prob(50))
			new /obj/alien/facehugger (vent.loc)
		if(prob(75))
			new /obj/alien/egg (vent.loc)
		vents.Remove(vent)
		spawncount -= 1

/proc/high_radiation_event()
	command_alert("High levels of radiation detected near the station. Please report to the Med-bay if you feel strange.", "Anomaly Alert!")
	//world << sound('radiation.ogg')
	for(var/mob/living/carbon/human/H in mobz)
		H.radiation += rand(5,25)
		if (prob(5))
			H.radiation += rand(30,50)
		if (prob(25))
			if (prob(75))
				randmutb(H)
				domutcheck(H,null,1)
			else
				randmutg(H)
				domutcheck(H,null,1)
	for(var/mob/living/carbon/monkey/M in mobz)
		M.radiation += rand(5,25)

/proc/prison_break() // -- Callagan
	for (var/obj/machinery/power/apc/temp_apc in machines)
		if(istype(get_area(temp_apc), /area/prison))
			temp_apc.overload_lighting()
	for (var/obj/machinery/computer/transitshuttle/newstationprison/temp_shuttle in machines)
		temp_shuttle.prison_break()
	for (var/obj/secure_closet/security1/temp_closet in world)
		if(istype(get_area(temp_closet), /area/prison))
			temp_closet.prison_break()
	for (var/obj/machinery/door/airlock/security/temp_airlock in machines)
		if(istype(get_area(temp_airlock), /area/prison))
			temp_airlock.prison_open()
	sleep(150)
	command_alert("Prison station VI is not accepting commands. Recommend station AI involvement.", "VI Alert!")

/proc/carp_migration() // -- Darem
	for(var/obj/landmark/C in landmarkz)
		if(C.name == "carpspawn")
			if(prob(99))
				new /obj/livestock/spesscarp(C.loc)
			else
				new /obj/livestock/spesscarp/elite(C.loc)
	sleep(100)
	command_alert("Unknown biological entities have been detected near [station_name()], please stand-by.", "Lifesign Alert!")
	//world << sound('commandreport.ogg')

/proc/bumpercrop() // -- Darem
	for(var/obj/landmark/C in landmarkz)
		if(C.name == "bumpercropspawn")
			if(prob(90))
				new /obj/item/weapon/reagent_containers/food/snacks/grown/wheat(C.loc)
				new /obj/item/weapon/reagent_containers/food/snacks/grown/wheat(C.loc)
				new /obj/item/weapon/reagent_containers/food/snacks/grown/wheat(C.loc)
				new /obj/item/weapon/reagent_containers/food/snacks/grown/wheat(C.loc)
				new /obj/item/weapon/reagent_containers/food/snacks/grown/tomato(C.loc)
				new /obj/item/weapon/reagent_containers/food/snacks/grown/corn(C.loc)
				new /obj/item/weapon/reagent_containers/food/snacks/grown/corn(C.loc)
				new /obj/item/weapon/reagent_containers/food/snacks/grown/corn(C.loc)
				new /obj/item/weapon/reagent_containers/food/snacks/grown/potato(C.loc)
				new /obj/item/weapon/reagent_containers/food/snacks/grown/potato(C.loc)
				new /obj/item/weapon/reagent_containers/food/snacks/grown/potato(C.loc)
				new /obj/item/weapon/reagent_containers/food/snacks/grown/carrot(C.loc)
				new /obj/item/weapon/reagent_containers/food/snacks/grown/carrot(C.loc)
				new /obj/item/weapon/reagent_containers/food/snacks/grown/tomato(C.loc)
			else
				new /obj/item/weapon/reagent_containers/food/snacks/grown/apple(C.loc)
				new /obj/item/weapon/reagent_containers/food/snacks/grown/banana(C.loc)
				new /obj/item/weapon/reagent_containers/food/snacks/grown/watermelon(C.loc)
				new /obj/item/weapon/reagent_containers/food/snacks/grown/apple(C.loc)
				new /obj/item/weapon/reagent_containers/food/snacks/grown/banana(C.loc)
				new /obj/item/weapon/reagent_containers/food/snacks/grown/watermelon(C.loc)
	sleep(100)
	//command_alert("Unknown biological entities have been detected near [station_name()], please stand-by.", "Lifesign Alert!")

/proc/zombie_attack() // -- Darem
	for(var/obj/landmark/C in landmarkz)
		if(C.name == "zombiespawn")
			if(prob(80))
				new /mob/living/carbon/human/retard/violent/zombors(C.loc)
			else
				new /mob/living/carbon/human/retard/violent/zombors/randomizedgear(C.loc)
	sleep(100)
	command_alert("Unknown biological entities have been detected near [station_name()], please stand-by.", "Lifesign Alert!")
	//world << sound('commandreport.ogg')

/proc/lightsout(isEvent = 0, lightsoutAmount = 1,lightsoutRange = 3) //leave lightsoutAmount as 0 to break ALL lights
	if(isEvent)
		command_alert("An Electrical storm has been detected in your area, please repair potential electronic overloads.","Electrical Storm Alert!")

	if(lightsoutAmount)
		var/list/epicentreList = list()

		for(var/i=1,i<=lightsoutAmount,i++)
			var/list/possibleEpicentres = list()
			for(var/obj/landmark/newEpicentre in landmarkz)
				if(newEpicentre.name == "lightsout" && !(newEpicentre in epicentreList))
					possibleEpicentres += newEpicentre
			if(possibleEpicentres.len)
				epicentreList += pick(possibleEpicentres)
			else
				break

		if(!epicentreList.len)
			return

		for(var/obj/landmark/epicentre in epicentreList)
			for(var/obj/machinery/power/apc/apc in range(epicentre,lightsoutRange))
				apc.overload_lighting()

	else
		for(var/obj/machinery/power/apc/apc in machines)
			apc.overload_lighting()

	return