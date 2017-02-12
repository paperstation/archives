// Alright this will have to be the main shield controller since doing it without is annoying as shit

/datum/controller/shields
	var/charge
	var/max_charge
	var/on
	var/broken
	var/list/emitters = list()
	var/list/deployed_shields = list()
	var/capacitators = 0
	var/power

/datum/controller/shields/proc/UsePowerCheck()
	for(var/obj/machinery/shielding/emitter/emitter_tile in machines)
		emitters += emitter_tile
	if(!on)
		return
	else if(deployed_shields.len <= 0)
		power += (emitters.len * 500)
		UsePower(power)
		sleep(1)
		Balance()
	else if(deployed_shields.len > 0)
		power += (deployed_shields.len * 5000) + (emitters.len * 500)
		UsePower(power)
		sleep(1)
		Balance()

/datum/controller/shields/proc/AddShield(var/turf/S)
	if(CheckTurf(S))
	//	world << "check failed"
		return
	else if(!CheckTurf(S))
	//	world << "check passed"
		if(!on)
			var/obj/machinery/shield/Shield = new /obj/machinery/shield(S)
			deployed_shields += Shield
//			world << "not turned on"
			return

		var/obj/machinery/shield/Shield = new /obj/machinery/shield(S)
		deployed_shields += Shield
//		world << "deployed shield"
		spawn(1)
		return
//	else
	//	world << "fuck you I don't bother checking"
/datum/controller/shields/proc/CheckTurf(var/turf/S)
//	world << "check called"
	var/list/turf = list()
//	for(var/obj/machinery/shield/Shield2 in S)
	//	world << "grats"
	//	world << "Shields2 found"
	for(var/turf/space/space in range(S,1))
		turf += space
	//	world << "space gratz"
	for(var/turf/simulated/floor/plating/airless/airless in range(S,1))
		turf += airless
	//	world << "airless plating gratz"

	if(turf.len > 0)
	//	world << "passed"
		return(0)
	else
	//	world << "not passed"
		return(1)

/datum/controller/shields/proc/RemoveShield(var/turf/S)
	if(!on)return
	for(var/obj/machinery/shield/Shield in S)
		if(Shield)
			deployed_shields -= Shield
			del(Shield)
	//		world << "taken shield"
	return

/datum/controller/shields/proc/Balance()  //stolen from baystation to balence all the capacitors
	var/TotalCharge = 0
	var/TotalCaps = 0

	for(var/obj/machinery/shielding/capacitor/S in machines)
		TotalCharge += S.charge
		TotalCaps++

	for(var/obj/machinery/shielding/capacitor/S in machines)
		S.charge = TotalCharge / TotalCaps

	return

/datum/controller/shields/proc/HasPower()
	// at least three capacitators need to be working
	return (capacitators >= 3)

/datum/controller/shields/proc/UsePower(Amount)
	for(var/obj/machinery/shielding/capacitor/S in machines)
		if(S.charge >= Amount)
			S.charge -= Amount
			return 1
		else if(S.charge <= Amount && S.charge > 0)
			Amount -= S.charge
			S.charge = 0
		Balance()
	return 0

/datum/controller/shields/proc/startshields()
	for(var/obj/machinery/shielding/capacitor/C in machines)
		capacitators++

	if(!Shields.HasPower())
		return
	for(var/obj/machinery/shielding/emitter/E in machines)
		E.control = 1
	for(var/obj/machinery/shielding/capacitor/C in machines)
		C.shields_enabled = 1

//	for(var/obj/landmark/alterations/E in world)
//		if(E.name == "Shield")
//			on = 1
//	for(var/obj/machinery/shield/shield_tile in deployed_shields)
//		shield_tile.density = 1
//		shield_tile.icon_state = "shieldsparkles1"
//			deployed_shields += new /obj/machinery/shield(E.loc)
	on = 1

/datum/controller/shields/proc/stopshields()
	for(var/obj/machinery/shielding/emitter/E in machines)
		E.control = 0
	for(var/obj/machinery/shielding/capacitor/C in machines)
		C.shields_enabled = 0
	on = 0
//	for(var/obj/machinery/shield/shield_tile in deployed_shields)
//		shield_tile.density = 0
//		shield_tile.icon_state = "shieldsparklesblank"
//	..()





