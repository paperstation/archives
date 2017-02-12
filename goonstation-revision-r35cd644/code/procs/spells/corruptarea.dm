/client/proc/wiz_corruption()
	set category = "Spells"
	set name = "Corruption Ritual"
	set desc="Pollutes an area with evil magic to please the dark gods."

	if(usr.stat)
		boutput(usr, "Not when you're incapacitated.")
		return

	var/area/getarea = get_area(usr)
	if(!getarea)
		boutput(usr, "Something went wrong with the ritual!")
		return
	if(getarea.name == "Space")
		boutput(usr, "This spell will not work in the void!")
		return
	if(getarea.z != 1)
		boutput(usr, "The dark gods do not desire this region of space.")
		return
	if(istype(getarea, /area/wizard_station) || istype(getarea, /area/syndicate_station)|| istype(getarea, /area/supply)|| istype(getarea, /area/shuttle/))
		boutput(usr, "The dark gods do not desire this area of the station.")
		return
	if(getarea.corrupted)
		boutput(usr, "This area is already corrupted!")
		return
	if(getarea.name == "Chapel" || getarea.name == "Chapel Office")
		if (get_corruption_percent() < 40)
			boutput(usr, "<span style=\"color:red\">You cannot cast spells on hallowed ground! Maybe if the station were more corrupted...</span>")
			return

	var/sizecount = 0
	for(var/turf/simulated/floor/T in getarea)
		sizecount++

	for(var/mob/O in AIviewers(usr, null)) O.show_message(text("<span style=\"color:red\"><B>[]</B> begins to channel dark energy!</span>", usr), 1)
	playsound(usr, 'sound/effects/chanting.ogg', 80, 1)

	var/crpttime = sizecount
	var/staystill = usr.loc
	crpttime *= 1
	if (!usr.wizard_spellpower())
		boutput(usr, "<span style=\"color:red\">Without your enchanted gear, the ritual takes much longer!</span>")
		crpttime *= 2
	if (istype(usr.l_hand, /obj/item/staff/cthulhu)) crpttime /= 6
	else if (istype(usr.r_hand, /obj/item/staff/cthulhu)) crpttime /= 6

	crpttime /= 5
	boutput(usr, "It will take [crpttime] seconds to finish the ritual.")
	var/list/chant = list("Kali ma...","Klaatu barada nikto...","Ia ia Fthaghn...")
	for(var/Ti = crpttime, Ti > 0, Ti--)
		if (usr.loc != staystill || usr.stat || usr.stunned || usr.paralysis || usr.weakened)
			boutput(usr, "<span style=\"color:red\">You lose your concentration!</span>")
			return
		if (prob(8)) usr.say(pick(chant))
		sleep(10)

	getarea.areacorrupt()
	boutput(usr, "You finish the ritual.")

/proc/get_total_corruptible_terrain()
	var/list/ignoreareas = list("Space","Arrival Shuttle","Emergency Shuttle","Supply Shuttle","Fore Solar Array","Aft Solar Array","Port Solar Array","Starboard Solar Array","Wizard's Den","Syndicate Station")
	var/turfcount = 0
	for(var/turf/simulated/floor/T in world)
		if(T.z != 1) continue
		if(T.loc.name in ignoreareas) continue
		turfcount++
	var/percentage
	percentage = (turfcount * 0.4)
	logTheThing("debug", null, null, "<b>I Said No/Corruptible Terrain:</b> Found [turfcount] corruptible terrains, 40% corruption is [percentage]")
	return turfcount

/proc/get_corruption_percent()
/* Hello, this proc is called a billion times by wizard shit. Do not iterate through all turfs in the world with it tia
	var/corrupt = 0
	for(var/turf/simulated/floor/T in world)
		if(T.z != 1) continue
		if(T.loc:corrupted) corrupt++
*/
	var/percentage = round((total_corrupted_terrain / total_corruptible_terrain) * 100, 0.25)

	return percentage

/client/proc/sense_corruption()
	set category = "Spells"
	set name = "Sense Corruption"
	set desc="Tells you what percentage of the station is corrupted with dark magic."
	var/corrupt = get_corruption_percent()
	boutput(usr, "<b>[corrupt]%</b> of the station has been corrupted.")

/client/proc/remove_corruption()
	set category = "Spells"
	set name = "Prayer"
	set desc="Clears dark magic corruption from an area."

	if(usr.stat)
		boutput(usr, "Not when you're incapacitated.")
		return

	var/area/getarea = get_area(usr)
	if(!getarea)
		boutput(usr, "Something went wrong with the prayer!")
		return
	if(getarea.name == "Space")
		boutput(usr, "This spell will not work in space!")
		return
	if(!getarea.corrupted)
		boutput(usr, "This area is not corrupted!")
		return

	var/sizecount = 0
	for(var/turf/simulated/floor/T in getarea)
		sizecount++

	for(var/mob/O in AIviewers(usr, null)) O.show_message(text("<span style=\"color:red\"><B>[]</B> closes \his eyes and begins to pray!</span>", usr), 1)

	var/crpttime = sizecount
	var/staystill = usr.loc
	crpttime *= 1

	crpttime /= 6
	boutput(usr, "It will take [crpttime] seconds to finish purifying this area.")
	for(var/Ti = crpttime, Ti > 0, Ti--)
		if (usr.loc != staystill || usr.stat || usr.stunned || usr.paralysis || usr.weakened)
			boutput(usr, "<span style=\"color:red\">You lose your concentration!</span>")
			return
		sleep(10)

	getarea.areauncorrupt()
	boutput(usr, "You finish the ritual.")
	playsound(usr, 'sound/effects/heavenly.ogg', 80, 1)