/////////////COLLECTOR UNIT

/obj/machinery/power/collector_array
	name = "Radiation Collector Array"
	desc = "A device which uses Hawking Radiation and plasma to produce power."
	icon = 'singularity.dmi'
	icon_state = "ca"
	anchored = 1
	density = 1
	directwired = 1
//	use_power = 0
	var
		obj/item/weapon/tank/plasma/P = null
		obj/machinery/power/collector_control/CU = null
		last_power = 0
		active = 0
		locked = 0

	process()
		if(src.active == 1)
			if(P)
				if(P.air_contents.toxins <= 0)
					P.air_contents.toxins = 0
					eject()
				else
					P.air_contents.toxins -= 0.001
			return

	attackby(obj/item/W, mob/user)
		if(istype(W, /obj/item/device/analyzer))
			user << "\blue The [W.name] detects that [last_power]W were recently produced."
			return 1
		else if(istype(W, /obj/item/weapon/tank/plasma))
			if(!src.anchored)
				user << "The [src] needs to be secured to the floor first."
				return 1
			if(src.P)
				user << "\red There appears to already be a plasma tank loaded!"
				return 1
			src.P = W
			W.loc = src
			if (user.client)
				user.client.screen -= W
			user.u_equip(W)
			updateicon()
			if (CU)
				CU.updatecons()
		else if(istype(W, /obj/item/weapon/crowbar))
			if(P)
				if(active)
					user << "\red Turn off the collector first."
					return 1
				else
					eject()
					return 1
		else if(istype(W, /obj/item/weapon/wrench))
			if(active)
				user << "\red Turn off the collector first."
				return 1
			if(P)
				user << "\red Remove the plasma tank first."
				return 1
			playsound(src.loc, 'Ratchet.ogg', 75, 1)
			src.anchored = !src.anchored
			user.visible_message("[user.name] [anchored? "secures":"unsecures"] the [src.name].", \
				"You [anchored? "secure":"undo"] the external bolts.", \
				"You hear ratchet")
			for(var/obj/machinery/power/collector_control/myCC in orange(1,src))
				myCC.updatecons()
			if(anchored)
				connect_to_network()
			else
				disconnect_from_network()
		else if(istype(W, /obj/item/weapon/card/id)||istype(W, /obj/item/device/pda))
			if (src.allowed(user))
				src.locked = !src.locked
				user << "Controls are now [src.locked ? "locked." : "unlocked."]"
			else
				user << "\red Access denied."
				return 1
		else
			..()
			return 1

	attack_hand(mob/user as mob)
		if (..())
			return
		if(!src.anchored)
			user << "\red The [src] needs to be secured to the floor first."
			return 1
		if (!P)
			user << "\red The [src] cannot be turned on without plasma."
			return 1
		if (!CU)
			user << "\red The [src] is not connected with The Radiation Collector Control."
			return 1
		if(src.locked)
			user << "\red The controls are locked."
			return 1
		src.active = !src.active
		if(src.active)
			updateicon_on()
			user.visible_message("[user.name] turns on the collector array.", \
				"You turn on the collector array.")
		else
			updateicon_off()
			user.visible_message("[user.name] turns off the collector array.", \
				"You turn off the collector array.")
		CU.updatecons()

	ex_act(severity)
		switch(severity)
			if(2, 3)
				eject()
		return ..()

	Del()
		var/oldsrc = src
		src = null
		spawn(1)
			for(var/obj/machinery/power/collector_control/myCC in orange(1,src))
				myCC.updatecons()
		src = oldsrc
		. = ..()

	proc
		eject()
			var/obj/item/weapon/tank/plasma/Z = src.P
			if (!Z)
				return
			Z.loc = get_turf(src)
			Z.layer = initial(Z.layer)
			src.P = null
			if(active)
				icon_state = "collector"
				updateicon_off()
			else
				updateicon()
		receive_pulse(var/pulse_strength)
			if(P && active)
				var/power_produced = 0
				power_produced = P.air_contents.toxins*pulse_strength*20
				add_avail(power_produced)
				last_power = power_produced
				return
			return
		updateicon()
			overlays = null
			if(P)
				overlays += image('singularity.dmi', "ptank")
			if(stat & (NOPOWER|BROKEN))
				return
			if(active)
				overlays += image('singularity.dmi', "on")
		updateicon_on()
			icon_state = "ca_on"
			flick("ca_active", src)
			updateicon()
		updateicon_off()
			updateicon()
			icon_state = "ca"
			flick("ca_deactive", src)

////////////CONTROL UNIT

#define collector_control_range 12
/obj/machinery/power/collector_control
	name = "Radiation Collector Control"
	desc = "A device which uses Hawking Radiation and Plasma to produce power."
	icon = 'singularity.dmi'
	icon_state = "cu"
	anchored = 1
	density = 1
	req_access = list(access_engine)
	directwired = 1
	var
		active = 0
		lastpower = 0
		obj/machinery/power/collector_array/CA[4]
		list/obj/machinery/singularity/S
		locked

	New()
		..()
		spawn(10)
			while(1)
				updatecons()
				sleep(600)

	power_change()
		..() //this set NOPOWER
		if (stat & (NOPOWER|BROKEN))
			lastpower = 0
		updateicon() //this checks NOPOWER


	process()
		if(stat & (NOPOWER|BROKEN))
			return
		if(!active)
			return
		var/power_a = 0
		var/power_s = 0
		var/power_p = 0
		for (var/obj/machinery/singularity/myS in S)
			if(!isnull(myS))
				power_s += myS.energy
		for (var/i = 1, i<= CA.len, i++)
			var/obj/machinery/power/collector_array/myCA = CA[i]
			if (!myCA)
				continue
			var/obj/item/weapon/tank/plasma/myP = myCA.P
			if (myCA.active && myP)
				myCA.use_power(250)
				power_p += myP.air_contents.toxins
				myP.air_contents.toxins -= 0.001
		power_a = power_p*power_s*50
		src.lastpower = power_a
		add_avail(power_a)
		use_power(250)


	attack_hand(mob/user as mob)
		if (..())
			return
		if(!src.anchored)
			user << "\red The [src] needs to be secured to the floor first."
			return 1
		if(src.locked)
			user << "\red The controls are locked."
			return 1
		src.active = !src.active
		if(!src.active)
			user << "You turn off the [src]."
			src.lastpower = 0
			updateicon()
		if(src.active)
			user << "You turn on the [src]."
			updatecons()

	attackby(obj/item/W, mob/user)
		if(istype(W, /obj/item/device/analyzer))
			user << "\blue The analyzer detects that [lastpower]W are being produced."
		else if(istype(W, /obj/item/weapon/wrench))
			if(active)
				user << "\red Turn off the collector control first."
				return 1

			playsound(src.loc, 'Ratchet.ogg', 75, 1)
			src.anchored = !src.anchored
			if(src.anchored == 1)
				user.visible_message("[user.name] secures [src.name] to the floor.", \
					"You secure the [src.name] to the floor.", \
					"You hear ratchet")
				connect_to_network()
			else
				user.visible_message("[user.name] unsecures [src.name] to the floor.", \
					"You undo the [src] securing bolts.", \
					"You hear ratchet")
				disconnect_from_network()
		else if(istype(W, /obj/item/weapon/card/id)||istype(W, /obj/item/device/pda))
			if (src.allowed(user))
				src.locked = !src.locked
				user << "Controls are now [src.locked ? "locked." : "unlocked."]"
			else
				user << "\red Access denied."
				return 1
		else
			user.visible_message("\red The [src.name] has been hit with the [W.name] by [user.name]!", \
				"\red You hit the [src.name] with your [W.name]!", \
				"You hear bang")
		src.add_fingerprint(user)

	proc
		add_ca(var/obj/machinery/power/collector_array/newCA)
			if (newCA in CA)
				return 1
			for (var/i = 1, i<= CA.len, i++)
				var/obj/machinery/power/collector_array/nextCA = CA[i]
				if (isnull(nextCA))
					CA[i] = newCA
					return 1
			//CA += newCA
			return 0

		updatecons()
			S = list()
			for(var/obj/machinery/singularity/myS in orange(collector_control_range,src))
				S += myS

			for (var/ca_dir in list( WEST, EAST, NORTH, SOUTH ) /* cardinal*/ )
				var/obj/machinery/power/collector_array/newCA = locate() in get_step(src,ca_dir)
				if (isnull(newCA))
					continue
				if (!isnull(newCA.CU) && newCA.CU != src)
					var/n = CA.Find(newCA)
					if (n)
						CA[n] = null
					continue
				if (!newCA.anchored || (!isnull(newCA.CU) && newCA.CU != src))
					var/n = CA.Find(newCA)
					if (n)
						CA[n] = null
						newCA.CU = null
					continue
				if (add_ca(newCA))
					newCA.CU = src
			updateicon()
			//is not recursive now, because can be called several times. See New(). - rastaf0

		updateicon()
			overlays = null
			if(stat & (NOPOWER|BROKEN))
				return
			if(src.active == 0)
				return
			overlays += image('singularity.dmi', "cu on")
			var/err = 0
			for (var/i = 1, i <= CA.len, i++)
				var/obj/machinery/power/collector_array/myCA = CA[i]
				if(myCA)
					if (myCA.P)
						if(myCA.active)
							overlays += image('singularity.dmi', "cu [i] on")
						if (myCA.P.air_contents.toxins <= 0)
							err = 1
					else
						err = 1
			if(err)
				overlays += image('singularity.dmi', "cu n error")
			for (var/obj/machinery/singularity/myS in S)
				if(myS)
					overlays += image('singularity.dmi', "cu sing")
					break
			for (var/obj/machinery/singularity/myS in S)
				if(myS && myS.active)
					overlays += image('singularity.dmi', "cu conterr")
					break