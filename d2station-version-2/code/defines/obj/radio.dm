/obj/item/device/radio
	name = "station bounced radio"
	suffix = "\[3\]"
	icon_state = "walkietalkie"
	item_state = "walkietalkie"
	var
		last_transmission
		frequency = 1459 //common chat
		traitor_frequency = 0 //tune to frequency to unlock traitor supplies
		obj/item/device/radio/patch_link = null
		obj/item/weapon/syndicate_uplink/traitorradio = null
		wires = WIRE_SIGNAL | WIRE_RECEIVE | WIRE_TRANSMIT
		b_stat = 0
		broadcasting = 0
		requiretransmitter = 0
		listening = 1
		freerange = 0 // 0 - Sanitize frequencies, 1 - Full range
		list/channels = list() //see communications.dm for full list. First channes is a "default" for :h
//			"Example" = FREQ_LISTENING|FREQ_BROADCASTING
	flags = 450
	throw_speed = 2
	throw_range = 9
	w_class = 2.0
	var/const
		WIRE_SIGNAL = 1 //sends a signal, like to set off a bomb or electrocute someone
		WIRE_RECEIVE = 2
		WIRE_TRANSMIT = 4
		TRANSMISSION_DELAY = 5 // only 2/second/radio
		FREQ_LISTENING = 1
		//FREQ_BROADCASTING = 2

/obj/item/device/radio/beacon
	name = "Tracking Beacon"
	icon_state = "beacon"
	item_state = "signaler"
	var/code = "electronic"
	requiretransmitter = 1

/obj/item/device/radio/courtroom_beacon
	name = "Tracking Beacon"
	icon_state = "beacon"
	item_state = "signaler"
	var/code = "electronic"
	requiretransmitter = 1

/obj/item/device/radio/electropack
	name = "Electropack"
	icon_state = "electropack0"
	var/code = 2
	var/on = 0
	var/e_pads = 0.0
	frequency = 1449
	w_class = 5.0
	flags = 323
	item_state = "electropack"
	requiretransmitter = 1

/obj/item/device/radio/signaler
	name = "Remote Signaling Device"
	icon_state = "signaller"
	item_state = "signaler"
	var/code = 30
	w_class = 1
	frequency = 1457
	var/delay = 0
	var/airlock_wire = null

/obj/item/device/radio/intercom
	name = "Station Intercom (Radio)"
	icon_state = "intercom"
	anchored = 1
	var/number = 0
	var/anyai = 1
	var/mob/living/silicon/ai/ai = list()

/obj/item/device/radio/headset
	name = "Radio Headset"
	icon_state = "headset"
	item_state = "headset"
	requiretransmitter = 1
	var
		protective_temperature = 0
		translate_binary = 0
		translate_hive = 0

/obj/item/device/radio/headset/traitor
	translate_binary = 1
	channels = list("Syndicate" = 1)

/obj/item/device/radio/headset/headset_sec
	name = "Security Radio Headset"
	icon_state = "sec_headset"
	item_state = "headset"
	channels = list("Security" = 1)

/obj/item/device/radio/headset/headset_eng
	name = "Engineering Radio Headset"
	icon_state = "eng_headset"
	item_state = "headset"
	channels = list("Engineering" = 1)

/obj/item/device/radio/headset/headset_med
	name = "Medical Radio Headset"
	icon_state = "med_headset"
	item_state = "headset"
	channels = list("Medical" = 1)

/obj/item/device/radio/headset/headset_com
	name = "Command Radio Headset"
	icon_state = "com_headset"
	item_state = "headset"
	channels = list("Command" = 1)
/obj/item/device/radio/headset/headset_sci
	name = "Science Radio Headset"
	icon_state = "com_headset"
	item_state = "headset"
	channels = list("Science" = 1)

/obj/item/device/radio/headset/heads/captain
	name = "Captain's Headset"
	icon_state = "com_headset"
	item_state = "headset"
	channels = list("Command" = 1, "Science" = 0, "Medical" = 0, "Security" = 1, "Engineering" = 0)

/obj/item/device/radio/headset/heads/rd
	name = "Research Director's Headset"
	icon_state = "com_headset"
	item_state = "headset"
	channels = list("Science" = 1, "Command" = 1, "Medical" = 1)

/obj/item/device/radio/headset/heads/hos
	name = "Head of Security's Headset"
	icon_state = "com_headset"
	item_state = "headset"
	channels = list("Security" = 1, "Command" = 1)

/obj/item/device/radio/headset/heads/ce
	name = "Chief Engineer's Headset"
	icon_state = "com_headset"
	item_state = "headset"
	channels = list("Engineering" = 1, "Command" = 1)

/obj/item/device/radio/headset/heads/cmo
	name = "Chief Medical Officer's Headset"
	icon_state = "com_headset"
	item_state = "headset"
	channels = list("Medical" = 1, "Command" = 1)