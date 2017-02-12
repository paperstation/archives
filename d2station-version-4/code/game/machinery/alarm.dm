/**

# Air Alarms

An air alarm monitors the local atmosphere, alerting people to dangerous
atmospheric conditions and controlling atmospheric equipment in order to
rectify problems.

## Atmospheric monitoring and control

Air alarms take the following measurements from the air:

* Pressure
* Oxygen level
* Carbon dioxide levels
* Plasma levels
* Other trace gas levels
* Temperature

Each of these measurements is compared to a reference set of threshold limit
values, which gives a range outside which a warning is triggered (causing the
air alarm to flash yellow), and a range outside which the alarm is triggered
(causing the air alarm to flash red).

Air alarms control air vent pumps and air scrubbers. Air vent pumps can pump
air in or out of a room, obeying variable upper limits on pressure (both in
the room and in the pipes). Air scrubbers can filter out harmful gases from
the environment, as well as quickly siphon out all the air from a room.

(For brevity, I'll refer to air vent pumps and air scrubbers as 'vents'.)

Air alarms have the following preset modes for vents:

* Scrubbing (default): the scrubbers remove any harmful gases, the vents
keep the pressure at 1atm.
* Venting: the scrubbers remove all gases, the vents keep the pressure at
1atm. (The scrubbers are less powerful than the vents so this creates a
pleasing draught.)
* Panic syphon: the scrubbers siphon gases, the vents turn off. Quickly
removes all gases from the room (in case of catastrophic failure)
* Replacement: Panic until the pressure is down to 0.05atm, then switch to
scrubbing.
* Repressurize: Brings the pressure up to 1atm, then switch to scrubbing.
* Off: The vents and scrubbers are both turned off.

## Wireless infrastructure

Only one air alarm per area is in 'master' mode at any given time. The master
is the one responsible for setting the modes on the vents, as well as
requesting that the vents send status information. The master can change - if
somebody opens a non-master alarm, or the master is disabled, then another air
alarm may take up the position of master at any point.

-Jetbeard

*/

/obj/machinery/alarm
	name = "alarm"
	icon = 'monitors.dmi'
	icon_state = "alarm0"
	anchored = 1
	use_power = 1
	idle_power_usage = 4
	active_power_usage = 8
	power_channel = ENVIRON
	req_access = list(access_atmospherics)

	var/const
		AALARM_REPORT_TIMEOUT = 100 // The time after which

		// The various atmospheric control modes.
		#define ATMOS_MODE_SCRUBBING    (1)
		#define ATMOS_MODE_VENTING      (2)
		#define ATMOS_MODE_PANIC        (3)
		#define ATMOS_MODE_REPLACEMENT  (4)
		#define ATMOS_MODE_REPRESSURIZE (5)
		#define ATMOS_MODE_OFF          (6)

		// The screen being displayed.
		SCREEN_MAIN    = 0
		SCREEN_DEVICES = 1
		SCREEN_MODE    = 2
		SCREEN_SENSORS = 3

		// The danger level of the atmosphere.
		DANGER_NORMAL  = 0
		DANGER_WARNING = 1
		DANGER_ALERT   = 2

	var
		locked = 1 // Whether the access panel is locked or not.
		frequency = 1439
		alarm_frequency = 1437 // The frequency for alarm->atmos_computer communication.
		datum/radio_frequency/radio_connection // The alarm<->vent radio connection.

		screen = SCREEN_MAIN // the screen that the panel is currently displaying.

		area/alarm_area // the area in which the alarm is operating.
		area_uid // the UID of the area.

		danger_level = DANGER_NORMAL // the current danger level.

		// breathable air according to human/Life()
		list/TLV = list(
			"oxygen"         = new/datum/tlv(  16,   19, 135, 140), // Partial pressure, kpa
			"carbon dioxide" = new/datum/tlv(-1.0, -1.0,   3,  5), // Partial pressure, kpa
			"plasma"         = new/datum/tlv(-1.0, -1.0, -1.0, -1.0), // Partial pressure, kpa
			"other"          = new/datum/tlv(-1.0, -1.0, 0.1, 0.2), // Partial pressure, kpa
			"pressure"       = new/datum/tlv(ONE_ATMOSPHERE*0.80,ONE_ATMOSPHERE*0.90,ONE_ATMOSPHERE*1.10,ONE_ATMOSPHERE*1.20), /* kpa */
			"temperature"    = new/datum/tlv(T0C+10, T0C+15, T0C+32, T0C+46), // K
		)

/area
	var/atmospherics_mode = ATMOS_MODE_SCRUBBING
	var/obj/machinery/alarm/master_air_alarm
	var/obj/machinery/atmospherics/unary/vent_pump/vents[] = new
	var/obj/machinery/atmospherics/unary/vent_scrubber/scrubbers[] = new

	proc/apply_atmospherics_mode()
		for (var/obj/machinery/atmospherics/unary/vent_pump/vent in vents)
			vent.apply_atmospherics_mode()
		for (var/obj/machinery/atmospherics/unary/vent_scrubber/scrubber in scrubbers)
			scrubber.apply_atmospherics_mode()

/obj/machinery/alarm/New()
	..()
	alarm_area = get_area(loc)
	while (alarm_area.master && alarm_area != alarm_area.master)
		alarm_area = alarm_area.master
	if (name == initial(name))
		name = "[alarm_area.name] Air Alarm"

/obj/machinery/alarm/initialize()
	if (!master_is_operating())
		elect_master()

/obj/machinery/alarm/proc/master_is_operating()
	return alarm_area.master_air_alarm && alarm_area.master_air_alarm.is_operating()

/obj/machinery/alarm/proc/elect_master()
	for (var/area/A in alarm_area.related)
		for (var/obj/machinery/alarm/AA in A)
			if (AA.is_operating())
				alarm_area.master_air_alarm = AA
				return 1
	return 0

/obj/machinery/alarm/attack_hand(mob/user)
	. = ..()
	if (.)
		return
	user.machine = src
	user << browse(return_text(),"window=air_alarm")
	onclose(user, "air_alarm")
	return

/obj/machinery/alarm/proc/return_text()
	if(!(istype(usr, /mob/living/silicon)) && locked)
		return "<html><head><link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><title>[src]</title></head><body>[return_status()]<hr><i>(Swipe ID card to unlock interface)</i></body></html>"
	else
		return "<html><head><link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><title>[src]</title></head><body>[return_status()]<hr>[return_controls()]</body></html>"

/obj/machinery/alarm/proc/return_status()
	var/turf/location = src.loc
	var/datum/gas_mixture/environment = location.return_air()
	var/total = environment.oxygen + environment.carbon_dioxide + environment.toxins + environment.nitrogen
	var/output = "<b>Air Status:</b><br>"

	if(total == 0)
		output +={"<font color='red'><b>Warning: Cannot obtain air sample for analysis.</b></font>"}
		return output

	output += {"
<style>
.dl0 { color: green; }
.dl1 { color: orange; }
.dl2 { color: red; font-weght: bold;}
</style>
"}
	var/datum/tlv/cur_tlv
	var/GET_PP = R_IDEAL_GAS_EQUATION*environment.temperature/environment.volume

	cur_tlv = TLV["pressure"]
	var/environment_pressure = environment.return_pressure()
	var/pressure_dangerlevel = cur_tlv.get_danger_level(environment_pressure)

	cur_tlv = TLV["oxygen"]
	var/oxygen_dangerlevel = cur_tlv.get_danger_level(environment.oxygen*GET_PP)
	var/oxygen_percent = round(environment.oxygen / total * 100, 2)

	cur_tlv = TLV["carbon dioxide"]
	var/co2_dangerlevel = cur_tlv.get_danger_level(environment.carbon_dioxide*GET_PP)
	var/co2_percent = round(environment.carbon_dioxide / total * 100, 2)

	cur_tlv = TLV["plasma"]
	var/plasma_dangerlevel = cur_tlv.get_danger_level(environment.toxins*GET_PP)
	var/plasma_percent = round(environment.toxins / total * 100, 2)

	cur_tlv = TLV["other"]
	var/other_moles = 0.0
	for(var/datum/gas/G in environment.trace_gases)
		other_moles+=G.moles
	var/other_dangerlevel = cur_tlv.get_danger_level(other_moles*GET_PP)

	cur_tlv = TLV["temperature"]
	var/temperature_dangerlevel = cur_tlv.get_danger_level(environment.temperature)

	output += {"
Pressure: <span class='dl[pressure_dangerlevel]'>[environment_pressure]</span>kPa<br>
Oxygen: <span class='dl[oxygen_dangerlevel]'>[oxygen_percent]</span>%<br>
Carbon dioxide: <span class='dl[co2_dangerlevel]'>[co2_percent]</span>%<br>
Toxins: <span class='dl[plasma_dangerlevel]'>[plasma_percent]</span>%<br>
"}
	if (other_dangerlevel==2)
		output += {"Notice: <span class='dl2'>High Concentration of Unknown Particles Detected</span><br>"}
	else if (other_dangerlevel==1)
		output += {"Notice: <span class='dl1'>Low Concentration of Unknown Particles Detected</span><br>"}

	output += {"
Temperature: <span class='dl[temperature_dangerlevel]'>[environment.temperature]</span>K<br>
"}

	var/display_danger_level = max(
		pressure_dangerlevel,
		oxygen_dangerlevel,
		co2_dangerlevel,
		plasma_dangerlevel,
		other_dangerlevel,
		temperature_dangerlevel
	)

	//Overall status
	output += {"Local Status: "}
	if(display_danger_level == 2)
		output += {"<span class='dl2'>DANGER: Internals Required</span>"}
	else if(display_danger_level == 1)
		output += {"<span class='dl1'>Caution</span>"}
	else if (alarm_area.atmosalm)
		output += {"<span class='dl1'>Caution: Atmos alert in area</span>"}
	else
		output += {"<span class='dl0'>Optimal</span>"}

	return output

/obj/machinery/alarm/proc/return_controls()
	var/output = ""//"<B>[alarm_zone] Air [name]</B><HR>"

	switch(screen)
		if (SCREEN_MAIN)
			if(alarm_area.atmosalm)
				output += {"<a href='?src=\ref[src];atmos_reset=1'>Reset - Atmospheric Alarm</a><hr>"}
			else
				output += {"<a href='?src=\ref[src];atmos_alarm=1'>Activate - Atmospheric Alarm</a><hr>"}

			output += {"
<a href='?src=\ref[src];screen=[SCREEN_DEVICES]'>Atmospheric devices</a><br>
<a href='?src=\ref[src];screen=[SCREEN_MODE]'>Set environmentals mode</a><br>
<a href='?src=\ref[src];screen=[SCREEN_SENSORS]'>Sensor Control</a><br>
<HR>
"}
			if (alarm_area.atmospherics_mode==ATMOS_MODE_PANIC)
				output += "<font color='red'><B>PANIC SYPHON ACTIVE</B></font><br><A href='?src=\ref[src];mode=[ATMOS_MODE_OFF]'>turn syphoning off</A>"
			else
				output += "<A href='?src=\ref[src];mode=[ATMOS_MODE_PANIC]'><font color='red'><B>ACTIVATE PANIC SYPHON IN AREA</B></font></A>"
		if (SCREEN_DEVICES)
			output += {"
<a href='?src=\ref[src];screen=[SCREEN_MAIN]'>Main menu</a><br>
<b>Atmospheric devices:</b><br>
<ul>"}
			var/normal_vents = 0
			var/normal_scrubbers = 0
			for (var/obj/machinery/atmospherics/unary/vent_pump/vent in alarm_area.vents)
				var/state
				if (vent.stat & BROKEN)
					state = "broken"
				else if (vent.stat & NOPOWER)
					state = "no power"
				if (state)
					output += {"<li>[vent] <font face='red'>([state]!)</font>"}
				else normal_vents += 1
			for (var/obj/machinery/atmospherics/unary/vent_scrubber/scrubber in alarm_area.scrubbers)
				var/state
				if (scrubber.stat & BROKEN)
					state = "broken"
				else if (scrubber.stat & NOPOWER)
					state = "no power"
				if (state)
					output += {"<li>[scrubber] <font face='red'>([state]!)</font>"}
				else normal_scrubbers += 1
			if (normal_vents)
				output += {"<li>Air vent (status normal) x[normal_vents]</li>"}
			if (normal_scrubbers)
				output += {"<li>Air scrubber (status normal) x[normal_scrubbers]</li>"}
			output += {"</ul>"}
		if (SCREEN_MODE)
			output += {"
<a href='?src=\ref[src];screen=[SCREEN_MAIN]'>Main menu</a><br>
<b>Air machinery mode for the area:</b><ul>"}
			var/list/modes = list(
				ATMOS_MODE_SCRUBBING   = "Filtering",
				ATMOS_MODE_VENTING     = "Draught",
				ATMOS_MODE_PANIC       = "<font color='red'>PANIC</font>",
				ATMOS_MODE_REPLACEMENT = "<font color='red'>REPLACE AIR</font>",
				ATMOS_MODE_REPRESSURIZE = "<font color='red'>Repressurize room</font>",
				ATMOS_MODE_OFF         = "Off",
			)
			for (var/m=1,m<=modes.len,m++)
				if (alarm_area.atmospherics_mode==m)
					output += {"<li><A href='?src=\ref[src];mode=[m]'><b>[modes[m]]</b></A> (selected)</li>"}
				else
					output += {"<li><A href='?src=\ref[src];mode=[m]'>[modes[m]]</A></li>"}
			output += "</ul>"
		if (SCREEN_SENSORS)
			output += {"
<a href='?src=\ref[src];screen=[SCREEN_MAIN]'>Main menu</a><br>
<b>Alarm thresholds:</b><br>
Partial pressure for gases
<style>/* some CSS woodoo here. Does not work perfect in ie6 but who cares? */
table td { border-left: 1px solid black; border-top: 1px solid black;}
table tr:first-child th { border-left: 1px solid black;}
table th:first-child { border-top: 1px solid black; font-weight: normal;}
table tr:first-child th:first-child { border: none;}
.dl0 { color: green; }
.dl1 { color: orange; }
.dl2 { color: red; font-weght: bold;}
</style>
<table cellspacing=0>
<TR><th></th><th class=dl2>min2</th><th class=dl1>min1</th><th class=dl1>max1</th><th class=dl2>max2</th></TR>
"}
			var/list/gases = list(
				"oxygen"         = "O<sub>2</sub>",
				"carbon dioxide" = "CO<sub>2</sub>",
				"plasma"         = "Toxin",
				"other"          = "Other",
			)
			var/list/thresholds = list("min2", "min1", "max1", "max2")
			var/datum/tlv/tlv
			for (var/g in gases)
				output += {"
<TR><th>[gases[g]]</th>
"}
				tlv = TLV[g]
				for (var/v in thresholds)
					output += {"
<td>
<A href='?src=\ref[src];command=set_threshold;env=[g];var=[v]'>[tlv.vars[v]>=0?tlv.vars[v]:"OFF"]</A>
</td>
"}
				output += {"
</TR>
"}
			tlv = TLV["pressure"]
			output += {"
<TR><th>Pressure</th>
"}
			for (var/v in thresholds)
				output += {"
<td>
<A href='?src=\ref[src];command=set_threshold;env=pressure;var=[v]'>[tlv.vars[v]>=0?tlv.vars[v]:"OFF"]</A>
</td>
"}
			output += {"
</TR>
"}
			tlv = TLV["temperature"]
			output += {"
<TR><th>Temperature</th>
"}
			for (var/v in thresholds)
				output += {"
<td>
<A href='?src=\ref[src];command=set_threshold;env=temperature;var=[v]'>[tlv.vars[v]>=0?tlv.vars[v]:"OFF"]</A>
</td>
"}
			output += {"
</TR>
"}
			output += {"</table>"}

	return output

/obj/machinery/alarm/Topic(href, href_list)
	if(..())
		return

	if(href_list["screen"])
		screen = text2num(href_list["screen"])
		spawn(1)
			src.updateUsrDialog()


	if(href_list["atmos_alarm"])
		if (alarm_area.atmosalert(2))
			post_alert(2)
			alarm()
		spawn(1)
			src.updateUsrDialog()
		update_icon()
	if(href_list["atmos_reset"])
		if (alarm_area.atmosalert(0))
			post_alert(0)
			reset()
		spawn(1)
			src.updateUsrDialog()
		update_icon()

	if(href_list["mode"])
		alarm_area.atmospherics_mode = text2num(href_list["mode"])
		alarm_area.apply_atmospherics_mode()
		spawn(5)
			src.updateUsrDialog()

	return

/obj/machinery/alarm/update_icon()
	if(!is_operating())
		icon_state = "alarmp"
		return
	switch(max(danger_level, alarm_area.atmosalm))
		if (0)
			src.icon_state = "alarm0"
			src.reset()
		if (1)
			src.icon_state = "alarm2" //yes, alarm2 is yellow alarm
			playsound(src.loc, 'yellowalert.ogg',50, 0)
		if (2)
			src.icon_state = "alarm1"
			src.alarm()

/obj/machinery/alarm/process()
	if(!is_operating())
		return

	var/turf/simulated/location = src.loc
	if (!istype(location))
		return 0

	var/datum/gas_mixture/environment = location.return_air()

	var/datum/tlv/cur_tlv
	var/GET_PP = R_IDEAL_GAS_EQUATION*environment.temperature/environment.volume

	cur_tlv = TLV["pressure"]
	var/environment_pressure = environment.return_pressure()
	var/pressure_dangerlevel = cur_tlv.get_danger_level(environment_pressure)

	cur_tlv = TLV["oxygen"]
	var/oxygen_dangerlevel = cur_tlv.get_danger_level(environment.oxygen*GET_PP)

	cur_tlv = TLV["carbon dioxide"]
	var/co2_dangerlevel = cur_tlv.get_danger_level(environment.carbon_dioxide*GET_PP)

	cur_tlv = TLV["plasma"]
	var/plasma_dangerlevel = cur_tlv.get_danger_level(environment.toxins*GET_PP)

	cur_tlv = TLV["other"]
	var/other_moles = 0.0
	for(var/datum/gas/G in environment.trace_gases)
		other_moles+=G.moles
	var/other_dangerlevel = cur_tlv.get_danger_level(other_moles*GET_PP)

	cur_tlv = TLV["temperature"]
	var/temperature_dangerlevel = cur_tlv.get_danger_level(environment.temperature)

	var/old_danger_level = danger_level
	danger_level = max(
		pressure_dangerlevel,
		oxygen_dangerlevel,
		co2_dangerlevel,
		plasma_dangerlevel,
		other_dangerlevel,
		temperature_dangerlevel
	)
	if (old_danger_level!=danger_level)
		apply_danger_level()

	if (alarm_area.atmospherics_mode==ATMOS_MODE_REPLACEMENT && environment_pressure<ONE_ATMOSPHERE*0.05)
		alarm_area.atmospherics_mode=ATMOS_MODE_SCRUBBING
		alarm_area.apply_atmospherics_mode()

	if (alarm_area.atmospherics_mode==ATMOS_MODE_REPRESSURIZE && abs(environment_pressure-ONE_ATMOSPHERE)<15)
		alarm_area.atmospherics_mode=ATMOS_MODE_SCRUBBING
		alarm_area.apply_atmospherics_mode()

	src.updateDialog()
	return

/obj/machinery/alarm/proc/post_alert(alert_level)

	var/datum/radio_frequency/frequency = radio_controller.return_frequency(alarm_frequency)

	if(!frequency) return

	var/datum/signal/alert_signal = new
	alert_signal.source = src
	alert_signal.transmission_method = 1
	alert_signal.data["zone"] = alarm_area.name
	alert_signal.data["type"] = "Atmospheric"

	if(alert_level==2)
		alert_signal.data["alert"] = "severe"
	else if (alert_level==1)
		alert_signal.data["alert"] = "minor"
	else if (alert_level==0)
		alert_signal.data["alert"] = "clear"

	frequency.post_signal(src, alert_signal)

/obj/machinery/alarm/proc/apply_danger_level()
	var/new_area_danger_level = 0
	for (var/area/A in alarm_area.related)
		for (var/obj/machinery/alarm/AA in A)
			if (AA.is_operating())
				new_area_danger_level = max(new_area_danger_level,AA.danger_level)
	if (alarm_area.atmosalert(new_area_danger_level)) //if area was in normal state or if area was in alert state
		post_alert(new_area_danger_level)
	update_icon()

/obj/machinery/alarm/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/wirecutters))
		stat ^= BROKEN
		src.add_fingerprint(user)
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red [] has []activated []!", user, (stat&BROKEN) ? "de" : "re", src), 1)
		update_icon()
		return

	else if (istype(W, /obj/item/weapon/card/id) || istype(W, /obj/item/device/pda))// trying to unlock the interface with an ID card
		if(!is_operating())
			user << "It does nothing"
		else
			if(src.allowed(usr))
				locked = !locked
				user << "\blue You [ locked ? "lock" : "unlock"] the Air Alarm interface."
				if(locked == 0)
					overlays += "airpump1_1"
				else
					overlays -= "airpump1_1"
				src.updateUsrDialog()
			else
				user << "\red Access denied."
		return
	return ..()

/obj/machinery/alarm/power_change()
	if(powered(power_channel))
		stat &= ~NOPOWER
	else
		stat |= NOPOWER
	spawn(rand(0,15))
		update_icon()

// A datum for dealing with threshold limit values
// used in /obj/machinery/alarm
/datum/tlv
	var
		min2
		min1
		max1
		max2
	New(_min2 as num, _min1 as num, _max1 as num, _max2 as num)
		min2 = _min2
		min1 = _min1
		max1 = _max1
		max2 = _max2
	proc/get_danger_level(curval as num)
		if (max2 >=0 && curval>=max2)
			return 2
		if (min2 >=0 && curval<=min2)
			return 2
		if (max1 >=0 && curval>=max1)
			return 1
		if (min1 >=0 && curval<=min1)
			return 1
		return 0
	proc/CopyFrom(datum/tlv/other)
		min2 = other.min2
		min1 = other.min1
		max1 = other.max1
		max2 = other.max2

/* TODO documentation for fire alarm */

/obj/machinery/firealarm/temperature_expose(datum/gas_mixture/air, temperature, volume)
	if(src.detecting)
		if(temperature > T0C+200)
			src.alarm()			// added check of detector status here
	return

/obj/machinery/firealarm/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/firealarm/bullet_act(BLAH)
	return src.alarm()

/obj/machinery/firealarm/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/firealarm/emp_act(severity)
	if(prob(50/severity)) alarm()
	..()

/obj/machinery/firealarm/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/wirecutters))
		src.detecting = !( src.detecting )
		if (src.detecting)
			user.visible_message("\red [user] has reconnected [src]'s detecting unit!", "You have reconnected [src]'s detecting unit.")
		else
			user.visible_message("\red [user] has disconnected [src]'s detecting unit!", "You have disconnected [src]'s detecting unit.")
	else
		src.alarm()
	src.add_fingerprint(user)
	return

/obj/machinery/firealarm/process()
	if(!is_operating())
		return

	var/area/A = src.loc
	A = A.loc

	if(A.fire)
		src.icon_state = "fire1"
	else
		src.icon_state = "fire0"

	if (src.timing)
		if (src.time > 0)
			src.time = round(src.time) - 1
		else
			alarm()
			src.time = 0
			src.timing = 0
		src.updateDialog()
	return

/obj/machinery/firealarm/power_change()
	if(powered(ENVIRON))
		stat &= ~NOPOWER
		icon_state = "fire0"
	else
		spawn(rand(0,15))
			stat |= NOPOWER
			icon_state = "firep"

/obj/machinery/firealarm/attack_hand(mob/user as mob)
	if(user.stat || !is_operating())
		return

	user.machine = src
	var/area/A = src.loc
	var/d1
	var/d2
	if (istype(user, /mob/living/carbon/human) || istype(user, /mob/living/silicon))
		A = A.loc

		if (A.fire)
			d1 = text("<A href='?src=\ref[];reset=1'>Reset - Lockdown</A>", src)
		else
			d1 = text("<A href='?src=\ref[];alarm=1'>Alarm - Lockdown</A>", src)
		if (src.timing)
			d2 = text("<A href='?src=\ref[];time=0'>Stop Time Lock</A>", src)
		else
			d2 = text("<A href='?src=\ref[];time=1'>Initiate Time Lock</A>", src)
		var/second = src.time % 60
		var/minute = (src.time - second) / 60
		var/dat = text("<HTML><HEAD><link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /></HEAD><BODY><TT><B>Fire alarm</B> []\n<HR>\nTimer System: []<BR>\nTime Left: [][] <A href='?src=\ref[];tp=-30'>-</A> <A href='?src=\ref[];tp=-1'>-</A> <A href='?src=\ref[];tp=1'>+</A> <A href='?src=\ref[];tp=30'>+</A>\n</TT></BODY></HTML>", d1, d2, (minute ? text("[]:", minute) : null), second, src, src, src, src)
		user << browse(dat, "window=firealarm")
		onclose(user, "firealarm")
	else
		A = A.loc
		if (A.fire)
			d1 = text("<A href='?src=\ref[];reset=1'>[]</A>", src, stars("Reset - Lockdown"))
		else
			d1 = text("<A href='?src=\ref[];alarm=1'>[]</A>", src, stars("Alarm - Lockdown"))
		if (src.timing)
			d2 = text("<A href='?src=\ref[];time=0'>[]</A>", src, stars("Stop Time Lock"))
		else
			d2 = text("<A href='?src=\ref[];time=1'>[]</A>", src, stars("Initiate Time Lock"))
		var/second = src.time % 60
		var/minute = (src.time - second) / 60
		var/dat = text("<HTML><HEAD><link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /></HEAD><BODY><TT><B>[]</B> []\n<HR>\nTimer System: []<BR>\nTime Left: [][] <A href='?src=\ref[];tp=-30'>-</A> <A href='?src=\ref[];tp=-1'>-</A> <A href='?src=\ref[];tp=1'>+</A> <A href='?src=\ref[];tp=30'>+</A>\n</TT></BODY></HTML>", stars("Fire alarm"), d1, d2, (minute ? text("[]:", minute) : null), second, src, src, src, src)
		user << browse(dat, "window=firealarm")
		onclose(user, "firealarm")
	return

/obj/machinery/firealarm/Topic(href, href_list)
	..()
	if (usr.stat || !is_operating())
		return
	if ((usr.contents.Find(src) || ((get_dist(src, usr) <= 1) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.machine = src
		if (href_list["reset"])
			src.reset()
		else
			if (href_list["alarm"])
				src.alarm()
			else
				if (href_list["time"])
					src.timing = text2num(href_list["time"])
				else
					if (href_list["tp"])
						var/tp = text2num(href_list["tp"])
						src.time += tp
						src.time = min(max(round(src.time), 0), 120)
		src.updateUsrDialog()

		src.add_fingerprint(usr)
	else
		usr << browse(null, "window=firealarm")
		return
	return

/obj/machinery/firealarm/proc/reset()
	if (!( src.working ))
		return
	var/area/A = src.loc
	A = A.loc
	if (!( istype(A, /area) ))
		return
	for(var/area/RA in A.related)
		RA.firereset()
	return

/obj/machinery/firealarm/proc/alarm()
	if (!( src.working ))
		return
	var/area/A = src.loc
	A = A.loc
	playsound(src.loc, 'alarm2.ogg', 50, 0)
	if (!( istype(A, /area) ))
		return
	for(var/area/RA in A.related)
		RA.firealert()
	return

/obj/machinery/alarm/proc/reset()
	var/area/A = src.loc
	A = A.loc
	if (!( istype(A, /area) ))
		return
	for(var/area/RA in A.related)
		RA.firereset()
	return

/obj/machinery/alarm/proc/alarm()
	var/area/A = src.loc
	A = A.loc
	playsound(src.loc, 'redalert3.ogg',50, 0)
	if (!( istype(A, /area) ))
		return
	for(var/area/RA in A.related)
		RA.firealert()
	return

/obj/machinery/partyalarm/attack_paw(mob/user as mob)
	return src.attack_hand(user)
/obj/machinery/partyalarm/attack_hand(mob/user as mob)
	if(user.stat || !is_operating())
		return

	user.machine = src
	var/area/A = src.loc
	var/d1
	var/d2
	if (istype(user, /mob/living/carbon/human) || istype(user, /mob/living/silicon/ai))
		A = A.loc

		if (A.party)
			d1 = text("<A href='?src=\ref[];reset=1'>No Party :(</A>", src)
		else
			d1 = text("<A href='?src=\ref[];alarm=1'>PARTY!!!</A>", src)
		if (src.timing)
			d2 = text("<A href='?src=\ref[];time=0'>Stop Time Lock</A>", src)
		else
			d2 = text("<A href='?src=\ref[];time=1'>Initiate Time Lock</A>", src)
		var/second = src.time % 60
		var/minute = (src.time - second) / 60
		var/dat = text("<HTML><HEAD><link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /></HEAD><BODY><TT><B>Party Button</B> []\n<HR>\nTimer System: []<BR>\nTime Left: [][] <A href='?src=\ref[];tp=-30'>-</A> <A href='?src=\ref[];tp=-1'>-</A> <A href='?src=\ref[];tp=1'>+</A> <A href='?src=\ref[];tp=30'>+</A>\n</TT></BODY></HTML>", d1, d2, (minute ? text("[]:", minute) : null), second, src, src, src, src)
		user << browse(dat, "window=partyalarm")
		onclose(user, "partyalarm")
	else
		A = A.loc
		if (A.fire)
			d1 = text("<A href='?src=\ref[];reset=1'>[]</A>", src, stars("No Party :("))
		else
			d1 = text("<A href='?src=\ref[];alarm=1'>[]</A>", src, stars("PARTY!!!"))
		if (src.timing)
			d2 = text("<A href='?src=\ref[];time=0'>[]</A>", src, stars("Stop Time Lock"))
		else
			d2 = text("<A href='?src=\ref[];time=1'>[]</A>", src, stars("Initiate Time Lock"))
		var/second = src.time % 60
		var/minute = (src.time - second) / 60
		var/dat = text("<HTML><HEAD><link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /></HEAD><BODY><TT><B>[]</B> []\n<HR>\nTimer System: []<BR>\nTime Left: [][] <A href='?src=\ref[];tp=-30'>-</A> <A href='?src=\ref[];tp=-1'>-</A> <A href='?src=\ref[];tp=1'>+</A> <A href='?src=\ref[];tp=30'>+</A>\n</TT></BODY></HTML>", stars("Party Button"), d1, d2, (minute ? text("[]:", minute) : null), second, src, src, src, src)
		user << browse(dat, "window=partyalarm")
		onclose(user, "partyalarm")
	return

/obj/machinery/partyalarm/proc/reset()
	if (!( src.working ))
		return
	var/area/A = src.loc
	A = A.loc
	if (!( istype(A, /area) ))
		return
	A.partyreset()
	return

/obj/machinery/partyalarm/proc/alarm()
	if (!( src.working ))
		return
	var/area/A = src.loc
	A = A.loc
	if (!( istype(A, /area) ))
		return
	A.partyalert()
	return

/obj/machinery/partyalarm/Topic(href, href_list)
	..()
	if (usr.stat || !is_operating())
		return
	if ((usr.contents.Find(src) || ((get_dist(src, usr) <= 1) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon/ai)))
		usr.machine = src
		if (href_list["reset"])
			src.reset()
		else
			if (href_list["alarm"])
				src.alarm()
			else
				if (href_list["time"])
					src.timing = text2num(href_list["time"])
				else
					if (href_list["tp"])
						var/tp = text2num(href_list["tp"])
						src.time += tp
						src.time = min(max(round(src.time), 0), 120)
		src.updateUsrDialog()

		src.add_fingerprint(usr)
	else
		usr << browse(null, "window=partyalarm")
		return
	return
