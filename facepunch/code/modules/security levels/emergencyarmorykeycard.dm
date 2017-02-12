/obj/machinery/armorykeycard
	name = "Armory Safe Authentication Device"
	desc = "It opens the Armory Safe."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "auth_off"
	var/active = 0 //This gets set to 1 on all devices except the one where the initial request was made.
	var/event = ""
	var/screen = 1
	var/confirmed = 0 //This variable is set by the device that confirms the request.
	var/confirm_delay = 20 //(2 seconds)
	var/busy = 0 //Busy when waiting for authentication or an event request has been sent from this device.
	var/obj/machinery/armorykeycard/event_source
	var/mob/event_triggered_by
	var/mob/event_confirmed_by
	//1 = select event
	//2 = authenticate
	anchored = 1.0
	use_power = USE_POWER_IDLE
	idle_power_usage = 2
	active_power_usage = 6
	power_channel = ENVIRON



/obj/machinery/armorykeycard/attack_ai(mob/user as mob)
	user << "The station AI is not to interact with these devices."
	return

/obj/machinery/armorykeycard/attack_paw(mob/user as mob)
	user << "You are too primitive to use this device."
	return

/obj/machinery/armorykeycard/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		if(screen == 2)
			user << "This device is not powered."
			return
	if(istype(W,/obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/ID = W
		if(access_armory_area in ID.access)
			if(active == 1)
				//This is not the device that made the initial request. It is the device confirming the request.
				if(event_source)
					event_source.event_confirmed_by = usr
					if(event_source.event_confirmed_by == event_triggered_by)
						usr << "You may not double swipe as yourself!"
					else
						event_source.confirmed = 1
			else if(screen == 2)
				event_triggered_by = usr
				broadcast_request() //This is the device making the initial event request. It needs to broadcast to other devices
	if(istype(W, /obj/item/weapon/card/emag))
		broadcast_request()




/obj/machinery/armorykeycard/power_change()
	if(powered(ENVIRON))
		stat &= ~NOPOWER
		icon_state = "auth_off"
	else
		stat |= NOPOWER

/obj/machinery/armorykeycard/attack_hand(mob/user as mob)
	if(user.stat || stat & (NOPOWER|BROKEN))
		user << "This device is not powered."
		return
	if(busy)
		user << "This device is busy."
		return

	user.set_machine(src)

	var/dat = "<h1>Keycard Authentication Device</h1>"

	dat += "This device is used to trigger some high security events. It requires the simultaneous swipe of two high-level ID cards."
	dat += "<br><hr><br>"

	if(screen == 1)
		dat += "Select an event to trigger:<ul>"
		dat += "<li><A href='?src=\ref[src];triggerevent=Emergency Armory Door'>Open Gun Safe</A></li>"
		dat += "</ul>"
		user << browse(dat, "window=keycard_auth;size=500x250")
	if(screen == 2)
		dat += "Please swipe your card to authorize the following event: <b>[event]</b>"
		dat += "<p><A href='?src=\ref[src];reset=1'>Back</A>"
		user << browse(dat, "window=keycard_auth;size=500x250")
	return


/obj/machinery/armorykeycard/Topic(href, href_list)
	..()
	if(busy)
		usr << "This device is busy."
		return
	if(usr.stat || stat & (BROKEN|NOPOWER))
		usr << "This device is without power."
		return
	if(href_list["triggerevent"])
		event = href_list["triggerevent"]
		screen = 2
	if(href_list["reset"])
		reset()

	updateUsrDialog()
	add_fingerprint(usr)
	return

/obj/machinery/armorykeycard/proc/reset()
	active = 0
	event = ""
	screen = 1
	confirmed = 0
	event_source = null
	icon_state = "auth_off"
	event_triggered_by = null
	event_confirmed_by = null

/obj/machinery/armorykeycard/proc/broadcast_request()
	icon_state = "auth_on"
	for(var/obj/machinery/armorykeycard/KA in world)
		if(KA == src) continue
		KA.reset()
		spawn()
			KA.receive_request(src)

	sleep(confirm_delay)
	if(confirmed)
		confirmed = 0
		trigger_event(event)
		log_game("[key_name(event_triggered_by)] triggered and [key_name(event_confirmed_by)] confirmed event [event]")
		message_admins("[key_name(event_triggered_by)] triggered and [key_name(event_confirmed_by)] confirmed event [event]", 1)
	reset()

/obj/machinery/armorykeycard/proc/receive_request(var/obj/machinery/armorykeycard/source)
	if(stat & (BROKEN|NOPOWER))
		return
	event_source = source
	busy = 1
	active = 1
	icon_state = "auth_on"

	sleep(confirm_delay)

	event_source = null
	icon_state = "auth_off"
	active = 0
	busy = 0

/obj/machinery/armorykeycard/proc/trigger_event()
	switch(event)
		if("Emergency Armory Door")
			for(var/obj/structure/closet/secure_closet/armorysafe/A in world)
				if(A.z == 1)
					if(A.locked)
						A.unlock()
						A.open()
			world << "<font size=4 color='red'>Emergency Armory has been opened</font>"
			world << "<font color='red'>Attention. A high level emergency has been detected on the station. Please be cautious and follow the orders of the heads of staff.</font>"
			world << sound('sound/AI/highlevelemergency.ogg')
