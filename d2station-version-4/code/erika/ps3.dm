/obj/item/ps3
	name = "PlayStation 3"
	desc = "Has no games."
	icon = 'erika.dmi'
	icon_state = "ps3"
	throwforce = 20
	w_class = 2.0

/obj/sign/brody
	name = "Painting (Adrien Brody)"
	desc = "A painting of Adrien Brody."
	icon = 'brody.dmi'
	icon_state = "1"
	anchored = 1
	opacity = 0

/obj/sign/brody/New()
	icon_state = "[rand(1,16)]"

/obj/sign/bankofd2k5
	name = "Official Bank of D2K5"
	desc = "The sign of the Official Bank of D2K5."
	icon = 'erika.dmi'
	icon_state = "bankofd2k5"
	anchored = 1
	opacity = 0

/obj/bombcase
	name = "\"Analdevastator Worthy Bomb\" Display Case"
	icon = 'stationobjs.dmi'
	icon_state = "assbox1"
	desc = "A display case for prized possessions. It taunts you to kick it."
	density = 1
	anchored = 1
	unacidable = 1//Dissolving the case would also delete the dicks.
	var/health = 30
	var/occupied = 1
	var/destroyed = 0

/obj/bombcase/ex_act(severity)
	switch(severity)
		if (1)
			new /obj/item/weapon/shard( src.loc )
			if (occupied)
				new /obj/spawner/bomb/timer/analdevastators( src.loc )
				occupied = 0
			del(src)
		if (2)
			if (prob(50))
				src.health -= 15
				src.healthcheck()
		if (3)
			if (prob(50))
				src.health -= 5
				src.healthcheck()

/obj/bombcase/bullet_act(var/obj/item/projectile/Proj)

	if (Proj.flag == "bullet")
		src.health -= 10
		src.healthcheck()
		return
	else
		src.health -= 4
		src.healthcheck()
		return


/obj/bombcase/blob_act()
	if (prob(75))
		new /obj/item/weapon/shard( src.loc )
		if (occupied)
			new /obj/spawner/bomb/timer/analdevastators( src.loc )
			occupied = 0
		del(src)


/obj/bombcase/meteorhit(obj/O as obj)
		new /obj/item/weapon/shard( src.loc )
		new /obj/spawner/bomb/timer/analdevastators( src.loc )
		del(src)


/obj/bombcase/proc/healthcheck()
	if (src.health <= 0)
		if (!( src.destroyed ))
			src.density = 0
			src.destroyed = 1
			new /obj/item/weapon/shard( src.loc )
			playsound(src, "shatter", 70, 1)
			update_icon()
	else
		playsound(src.loc, 'Glasshit.ogg', 75, 1)
	return

/obj/bombcase/update_icon()
	if(src.destroyed)
		src.icon_state = "glassboxb[src.occupied]"
	else
		src.icon_state = "glassbox[src.occupied]"
	return


/obj/bombcase/attackby(obj/item/weapon/W as obj, mob/user as mob)
	src.health -= W.force
	src.healthcheck()
	..()
	return

/obj/bombcase/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/bombcase/attack_hand(mob/user as mob)
	if (src.destroyed && src.occupied)
		new /obj/spawner/bomb/timer/analdevastators( src.loc )
		user << "\b You deactivate the hover field built into the case."
		src.occupied = 0
		src.add_fingerprint(user)
		update_icon()
		return
	else
		usr << text("\blue You kick the display case.")
		for(var/mob/O in oviewers())
			if ((O.client && !( O.blinded )))
				O << text("\red [] kicks the display case.", usr)
		src.health -= 2
		healthcheck()
		return

/obj/item/keycard
	name = "Keycard"
	desc = "A keycard."
	icon = 'items.dmi'
	icon_state = "jukebox_key"
	anchored = 0
	opacity = 0
	var/typeid

/obj/item/keycard/jukebox
	name = "Jukebox Keycard"
	desc = "Stop that pesky tourist scum from changing your favorite song!"
	icon = 'items.dmi'
	icon_state = "jukebox_key"
	anchored = 0
	opacity = 0


/obj/item/keycard/piano
	name = "Piano Keycard"
	desc = "Prevent the bothersome tourists from changing your delightful tunes!"
	icon = 'items.dmi'
	icon_state = "piano_key"
	anchored = 0
	opacity = 0

/obj/item/weapon/clownvuvuzela
	name = "Modified Clown Vuvuzela"
	desc = "BBBZZZZZZZZZZZZZZZZ"
	icon = 'items.dmi'
	icon_state = "vuvuzela"
	item_state = "vuvuzela"
	throwforce = 3
	w_class = 1.0
	throw_speed = 3
	throw_range = 15
	var/spam_flag = 0

/obj/item/weapon/clownvuvuzela/attack_self(mob/user as mob)
	if (spam_flag == 0)
		spam_flag = 1
		playsound(src.loc, 'AirHorn.ogg', rand(70,100), 1)
		for (var/mob/O in viewers(O, null))
			O << "<font color='red' size='7'>HONK</font>"
			spawn(10)
				spam_flag = 0

/obj/machinery/metaldetector
	name = "metal detector"
	desc = "a metal detector. staff can toggle this between ignore security and detect all with their id."
	anchored = 1.0
	density = 0
	icon = 'erika.dmi'
	icon_state = "metaldetector0"
	use_power = 1
	idle_power_usage = 20
	active_power_usage = 250
	var/guncount = 0
	var/knifecount = 0
	var/bombcount = 0
	var/meleecount = 0
	var/emagged = 0
	var/detectall = 0

/obj/machinery/metaldetector/check_access(obj/item/weapon/card/id/I, list/access_list)
	if(!istype(access_list))
		return 1
	if(!access_list.len) //no requirements
		return 1
	if(istype(I, /obj/item/device/pda))
		var/obj/item/device/pda/pda = I
		I = pda.id
	if(!istype(I) || !I.access) //not ID or no access
		return 0
	return 1

/obj/machinery/metaldetector/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/card/emag))
		if(!src.emagged)
			src.emagged = 1
			user << "\blue You short out the circuitry."
			return
	if(istype(W, /obj/item/weapon/card))
		for(var/ID in list(user.equipped(), user:wear_id, user:belt))
			if(src.check_access(ID,list("20")))
				if(!src.detectall)
					src.detectall = 1
					user << "\blue You set the [src] to detect all personnel."
					return
				else
					src.detectall = 0
					user << "\blue You set the [src] to ignore all staff and security."
					return
			else
				user << "\red You lack access to the control panel!"
				return

/obj/machinery/metaldetector/HasEntered(AM as mob|obj)
	if(emagged)
		return
	if (istype(AM, /mob/living))
		var/mob/M =	AM
		if(!src.detectall)
			if(M:wear_id || M:belt)
				for(var/ID in list(M:equipped(), M:wear_id, M:belt))
					if(src.check_access(ID,list("1", "2", "3", "20", "57", "58")))
						return
		if (istype(M, /mob/living))
			for(var/obj/item/weapon/gun/G in M)
				guncount++
			for(var/obj/item/device/transfer_valve/B in M)
				bombcount++
			for(var/obj/item/weapon/kitchen/utensil/knife/K in M)
				knifecount++
			for(var/obj/item/weapon/kitchen/utensil/razorblade/R in M)
				knifecount++
			for(var/obj/item/weapon/kitchenknife/KK in M)
				knifecount++
			for(var/obj/item/weapon/plastique/KK in M)
				bombcount++
			for(var/obj/item/weapon/melee/ML in M)
				meleecount++
			if(guncount)
				flick("metaldetector2",src)
				playsound(src.loc, 'alert.ogg', 60, 0)
				for (var/mob/O in viewers(O, null))
					O << "\red <b>[src.name]</b> beeps, \"Alert! Firearm found on [M.name]!\""

				if(seen_by_camera(M))
					// determine the name of the perp (goes by ID if wearing one)
					var/perpname = M.name
					if(M:wear_id && M:wear_id.registered)
						perpname = M:wear_id.registered
					// find the matching security record
					for(var/datum/data/record/R in data_core.general)
						if(R.fields["name"] == perpname)
							for (var/datum/data/record/S in data_core.security)
								if (S.fields["id"] == R.fields["id"])
									// now add to rap sheet
									S.fields["criminal"] = "*Arrest*"
									S.fields["mi_crim"] = "Carrying a firearm."
									break

				guncount = 0
			else if(knifecount)
				flick("metaldetector2",src)
				playsound(src.loc, 'alert.ogg', 60, 0)
				for (var/mob/O in viewers(O, null))
					O << "\red <b>[src.name]</b> beeps, \"Alert! Knife found on [M.name]!\""

				if(seen_by_camera(M))
					// determine the name of the perp (goes by ID if wearing one)
					var/perpname = M.name
					if(M:wear_id && M:wear_id.registered)
						perpname = M:wear_id.registered
					// find the matching security record
					for(var/datum/data/record/R in data_core.general)
						if(R.fields["name"] == perpname)
							for (var/datum/data/record/S in data_core.security)
								if (S.fields["id"] == R.fields["id"])
									// now add to rap sheet
									S.fields["criminal"] = "*Arrest*"
									S.fields["mi_crim"] = "Carrying a knife."
									break

				knifecount = 0
			else if(bombcount)
				flick("metaldetector2",src)
				playsound(src.loc, 'alert.ogg', 60, 0)
				for (var/mob/O in viewers(O, null))
					O << "\red <b>[src.name]</b> beeps, \"Alert! Bomb found on [M.name]!\""

				if(seen_by_camera(M))
					// determine the name of the perp (goes by ID if wearing one)
					var/perpname = M.name
					if(M:wear_id && M:wear_id.registered)
						perpname = M:wear_id.registered
					// find the matching security record
					for(var/datum/data/record/R in data_core.general)
						if(R.fields["name"] == perpname)
							for (var/datum/data/record/S in data_core.security)
								if (S.fields["id"] == R.fields["id"])
									// now add to rap sheet
									S.fields["criminal"] = "*Arrest*"
									S.fields["mi_crim"] = "Carrying a bomb."
									break

				bombcount = 0
			else if(meleecount)
				flick("metaldetector2",src)
				playsound(src.loc, 'alert.ogg', 60, 0)
				for (var/mob/O in viewers(O, null))
					O << "\red <b>[src.name]</b> beeps, \"Alert! Melee weapon found on [M.name]!\""

				if(seen_by_camera(M))
					// determine the name of the perp (goes by ID if wearing one)
					var/perpname = M.name
					if(M:wear_id && M:wear_id.registered)
						perpname = M:wear_id.registered
					// find the matching security record
					for(var/datum/data/record/R in data_core.general)
						if(R.fields["name"] == perpname)
							for (var/datum/data/record/S in data_core.security)
								if (S.fields["id"] == R.fields["id"])
									// now add to rap sheet
									S.fields["criminal"] = "*Arrest*"
									S.fields["mi_crim"] = "Carrying a weapon."
									break

				meleecount = 0
			else
				flick("metaldetector1",src)
