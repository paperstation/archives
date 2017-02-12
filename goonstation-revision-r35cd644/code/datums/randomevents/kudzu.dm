/datum/random_event/major/kudzu
	name = "Kudzu Outbreak"
	centcom_headline = "Plant Outbreak"
	centcom_message = "Rapidly expanding plant organism detected aboard the station. All personnel must contain the outbreak."
	message_delay = 1200 // 2m
	wont_occur_past_this_time = 24000 // 40m
	disabled = 1

	event_effect(var/source)
		..()
		if(!kudzustart.len)
			message_admins("Error starting event, no kudzu start landmarks. Process aborted.")
			return
		var/kudzloc = pick(kudzustart)
		var/obj/spacevine/K = new /obj/spacevine(kudzloc)
		K.Life()

/obj/spacevine
	name = "Space Kudzu"
	desc = "An extremely expansionistic species of vine."
	icon = 'icons/obj/objects.dmi'
	icon_state = "vine-light1"
	anchored = 1
	density = 0
	var/growth = 0
	var/waittime = 40

	New()
		if(istype(src.loc, /turf/space))
			qdel(src)
			return

	attackby(obj/item/W as obj, mob/user as mob)
		if (!W) return
		if (!user) return
		if (istype(W, /obj/item/axe)) qdel (src)
		if (istype(W, /obj/item/circular_saw)) qdel (src)
		if (istype(W, /obj/item/kitchen/utensil/knife)) qdel (src)
		if (istype(W, /obj/item/scalpel)) qdel (src)
		if (istype(W, /obj/item/screwdriver)) qdel (src)
		if (istype(W, /obj/item/raw_material/shard)) qdel (src)
		if (istype(W, /obj/item/sword)) qdel (src)
		if (istype(W, /obj/item/saw)) qdel (src)
		if (istype(W, /obj/item/weldingtool)) qdel (src)
		if (istype(W, /obj/item/wirecutters)) qdel (src)
		..()

/obj/spacevine/proc/Life()
	if (!src) return
	var/Vspread
	if (prob(50)) Vspread = locate(src.x + rand(-1,1),src.y,src.z)
	else Vspread = locate(src.x,src.y + rand(-1, 1),src.z)
	var/dogrowth = 1
	if (!istype(Vspread, /turf/simulated/floor)) dogrowth = 0
	for(var/obj/O in Vspread)
		if (istype(O, /obj/window) || istype(O, /obj/forcefield) || istype(O, /obj/blob) || istype(O, /obj/spacevine)) dogrowth = 0
		if (istype(O, /obj/machinery/door/))
			if(O:p_open == 0 && prob(50)) O:open()
			else dogrowth = 0
	if (dogrowth == 1)
		var/obj/spacevine/B = new /obj/spacevine(Vspread)
		B.icon_state = pick("vine-light1", "vine-light2", "vine-light3")
		spawn(20)
			if(B)
				B.Life()
	src.growth += 1
	if (src.growth == 10)
		src.name = "Thick Space Kudzu"
		src.icon_state = pick("vine-med1", "vine-med2", "vine-med3")
		src.opacity = 1
		src.waittime = 80
	if (src.growth == 20)
		src.name = "Dense Space Kudzu"
		src.icon_state = pick("vine-hvy1", "vine-hvy2", "vine-hvy3")
		src.density = 1
	spawn(src.waittime)
		if (src.growth < 20) src.Life()

/obj/spacevine/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(66))
				qdel(src)
				return
		if(3.0)
			if (prob(33))
				qdel(src)
				return
		else
	return

/obj/spacevine/temperature_expose(null, temp, volume)
	qdel(src)