//Atmos local air alarms
/obj/machinery/alarm
	name = "alarm"
	icon = 'icons/obj/monitors.dmi'
	icon_state = "alarm0"
	anchored = 1
	use_power = USE_POWER_IDLE
	idle_power_usage = 4
	active_power_usage = 8
	power_channel = ENVIRON

	#ifdef NEWMAP
	req_access = list(access_atmosia_area)
	#else
	req_access = list(access_atmospherics)
	#endif

	var/locked = 1
	var/aidisabled = 0
	var/frequency
	var/shorted = 0

	var/vent_on = 1
	var/vent_pressure_check = 1//1 external, 2 internal, 3 both
	var/external_pressure_bound = ONE_ATMOSPHERE
	var/internal_pressure_bound = 0

	var/panic = 0 //is scrubber panicked?
	var/scrubbing = SCRUB_CO2

#define ALARM_SCREEN_MAIN    1
#define ALARM_SCREEN_SENSORS 2
	var/screen = ALARM_SCREEN_MAIN
	var/area/alarm_area
	var/danger_level = 0

	// breathable air according to human/Life()
	var/list/TLV = list(
		"oxygen"         = new/datum/tlv(  16,   19, 135, 140), // Partial pressure, kpa
		"carbon dioxide" = new/datum/tlv(-1.0, -1.0,   5,  10), // Partial pressure, kpa
		"plasma"         = new/datum/tlv(-1.0, -1.0, 0.2, 0.5), // Partial pressure, kpa
		"other"          = new/datum/tlv(-1.0, -1.0, 0.5, 1.0), // Partial pressure, kpa
		"pressure"       = new/datum/tlv(ONE_ATMOSPHERE*0.80,ONE_ATMOSPHERE*0.90,ONE_ATMOSPHERE*1.10,ONE_ATMOSPHERE*1.20), /* kpa */
		"temperature"    = new/datum/tlv(T0C, T0C+10, T0C+40, T0C+66), // K
	)


	New(nloc, ndir, nbuild)
		..()
		if(nloc)
			loc = nloc

		if(ndir)
			dir = ndir

		if(nbuild)
			pixel_x = (dir & 3)? 0 : (dir == 4 ? -24 : 24)
			pixel_y = (dir & 3)? (dir ==1 ? -24 : 24) : 0

		alarm_area = get_area(loc)
		if(alarm_area.master)
			alarm_area = alarm_area.master
		if (name == "alarm")
			name = "[alarm_area.name] Local Air Alarm"

		if(ticker && ticker.current_state == 3)//if the game is running
			src.initialize()

		update_icon()
		return


	initialize()
		if(alarm_area)
			if(!alarm_area.local_alarm)
				alarm_area.local_alarm = src
				update_area_vents()
				return
		shorted = 1
		return


	attack_hand(mob/user)
		if(..())
			return
		user.set_machine(src)

		if((get_dist(src, user) > 1) && istype(user, /mob/living/silicon) && src.aidisabled)//AI disabled AND not able to touch it
			user << "AI control for this Air Alarm interface has been disabled."
			user << browse(null, "window=air_alarm")
			return


		if(!shorted)
			user << browse(return_text(),"window=air_alarm")
			onclose(user, "air_alarm")
		return


	proc/shock(mob/user, prb)
		if((stat & (NOPOWER)))		// unpowered, no shock
			return 0
		if(!prob(prb))
			return 0 //you lucked out, no shock for you
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, src)
		s.start() //sparks always.
		if (electrocute_mob(user, get_area(src), src))
			return 1
		else
			return 0




	//Grabs the air info and control text to display
	proc/return_text()
		if(!(istype(usr, /mob/living/silicon)) && locked)
			return "<html><head><title>[src]</title></head><body>[return_status()]<hr><i>(Swipe ID card to unlock interface)</i></body></html>"
		else
			return "<html><head><title>[src]</title></head><body>[return_status()]<hr>[return_controls()]</body></html>"

	//Gets the air and reports it to the user
	proc/return_status()
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
		if(other_dangerlevel==2)
			output += {"Notice: <span class='dl2'>High Concentration of Unknown Particles Detected</span><br>"}
		else if(other_dangerlevel==1)
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


	proc/return_controls()
		var/output = ""//"<B>[alarm_zone] Air [name]</B><HR>"

		switch(screen)
			if(AALARM_SCREEN_MAIN)
				if(alarm_area.atmosalm)
					output += {"<a href='?src=\ref[src];atmos_reset=1'>Reset - Atmospheric Alarm</a><hr>"}
				else
					output += {"<a href='?src=\ref[src];atmos_alarm=1'>Activate - Atmospheric Alarm</a><hr>"}

				output += {"
				<a href='?src=\ref[src];screen=[ALARM_SCREEN_SENSORS]'>Sensor Settings</a><br/>
				<HR>
				"}

				output += {"<b>[alarm_area.name] local vent settings</b>
				<BR/>
				<B>Panic:</B> <A href='?src=\ref[src];command=scrub_panic;val=[!panic]'><font color='[(panic?"blue'>Dea":"red'>A")]ctivate</font></A><BR/>
				"}
				if(!panic)//Only show the controls if we are not panicing
					output+={"
					Vent Power: <A href='?src=\ref[src];command=vent_power;val=[!vent_on]'>[vent_on?"on":"off"]</A>
					<BR/>
					<B>Pressure checks:</B>
					<BR/>
					<B>External pressure bound: </B>
					<A href='?src=\ref[src];command=vent_checks;val=[vent_pressure_check^1]'>[(vent_pressure_check&1)?"On":"Off"]</A>
					<BR/>
					<A href='?src=\ref[src];command=adjust_external_pressure;val=-1000'>-</A>
					<A href='?src=\ref[src];command=adjust_external_pressure;val=-100'>-</A>
					<A href='?src=\ref[src];command=adjust_external_pressure;val=-10'>-</A>
					<A href='?src=\ref[src];command=adjust_external_pressure;val=-1'>-</A>
					[external_pressure_bound]
					<A href='?src=\ref[src];command=adjust_external_pressure;val=+1'>+</A>
					<A href='?src=\ref[src];command=adjust_external_pressure;val=+10'>+</A>
					<A href='?src=\ref[src];command=adjust_external_pressure;val=+100'>+</A>
					<A href='?src=\ref[src];command=adjust_external_pressure;val=+1000'>+</A>
					<A href='?src=\ref[src];command=set_external_pressure;val=[ONE_ATMOSPHERE]'> (reset) </A>
					<BR/>
					<B>Internal pressure bound: </B>
					<A href='?src=\ref[src];command=vent_checks;val=[vent_pressure_check^2]'>[(vent_pressure_check&2)?"On":"Off"]</A>
					<BR/>
					<A href='?src=\ref[src];command=adjust_internal_pressure;val=-1000'>-</A>
					<A href='?src=\ref[src];command=adjust_internal_pressure;val=-100'>-</A>
					<A href='?src=\ref[src];command=adjust_internal_pressure;val=-10'>-</A>
					<A href='?src=\ref[src];command=adjust_internal_pressure;val=-1'>-</A>
					[internal_pressure_bound]
					<A href='?src=\ref[src];command=adjust_internal_pressure;val=1'>+</A>
					<A href='?src=\ref[src];command=adjust_internal_pressure;val=10'>+</A>
					<A href='?src=\ref[src];command=adjust_internal_pressure;val=100'>+</A>
					<A href='?src=\ref[src];command=adjust_internal_pressure;val=1000'>+</A>
					<A href='?src=\ref[src];command=set_external_pressure;val=0'> (reset) </A>
					<BR/><BR/>
					<B>Scrubber: </B>[scrubbing?"Enabled":"Disabled"]
					<BR/>
					<B>Filters:</B>
					<BR/>
					O2: <A href='?src=\ref[src];command=filter;val=[scrubbing^1]'>[scrubbing&1?"on":"off"]</A><BR/>
					N2: <A href='?src=\ref[src];command=filter;val=[scrubbing^2]'>[scrubbing&2?"on":"off"]</A><BR/>
					CO2: <A href='?src=\ref[src];command=filter;val=[scrubbing^4]'>[scrubbing&4?"on":"off"]</A><BR/>
					N2O: <A href='?src=\ref[src];command=filter;val=[scrubbing^8]'>[scrubbing&8?"on":"off"]</A><BR/>
					Toxins: <A href='?src=\ref[src];command=filter;val=[scrubbing^16]'>[scrubbing&16?"on":"off"]</A><BR/><BR/>
					"}

			if(ALARM_SCREEN_SENSORS)
				output += {"
				<a href='?src=\ref[src];screen=[ALARM_SCREEN_MAIN]'>Main menu</a><br>
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
				for(var/g in gases)
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
				for(var/v in thresholds)
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
				for(var/v in thresholds)
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


	Topic(href, href_list)
		if(..())
			return
		src.add_fingerprint(usr)
		usr.set_machine(src)

		if ((get_dist(src, usr) > 1 ))
			if(!istype(usr, /mob/living/silicon))
				usr.unset_machine()
				usr << browse(null, "window=air_alarm")
				return

		if(href_list["command"])
			var/update_vents = 0
			var/value = text2num(href_list["val"])
			if(value == null)
				return
			switch(href_list["command"])
				if("vent_power")
					vent_on = value
					update_vents = 1
				if("scrub_panic")
					panic = value
					update_vents = 1
				if("vent_checks")
					vent_pressure_check = value
					update_vents = 1
				if("adjust_external_pressure")
					external_pressure_bound += value
					update_vents = 1
				if("set_external_pressure")
					external_pressure_bound = value
					update_vents = 1
				if("adjust_internal_pressure")
					internal_pressure_bound += value
					update_vents = 1
				if("set_internal_pressure")
					internal_pressure_bound = value
					update_vents = 1
				if("filter")
					scrubbing = value
					update_vents = 1

				if("set_threshold")
					var/env = href_list["env"]
					var/varname = href_list["var"]
					var/datum/tlv/tlv = TLV[env]
					var/newval = input("Enter [varname] for env", "Alarm triggers", tlv.vars[varname]) as num|null

					if (isnull(newval) || ..() || (locked && !issilicon(usr)))
						return
					if (newval<0)
						tlv.vars[varname] = -1.0
					else if (env=="temperature" && newval>5000)
						tlv.vars[varname] = 5000
					else if (env=="pressure" && newval>50*ONE_ATMOSPHERE)
						tlv.vars[varname] = 50*ONE_ATMOSPHERE
					else if (env!="temperature" && env!="pressure" && newval>200)
						tlv.vars[varname] = 200
					else
						newval = round(newval,0.01)
						tlv.vars[varname] = newval
			spawn(1)
				src.updateUsrDialog()
			if(update_vents)
				update_area_vents()

		if(href_list["screen"])
			screen = text2num(href_list["screen"])
			spawn(1)
				src.updateUsrDialog()

		if(href_list["atmos_alarm"])
			apply_danger_level(2)
			spawn(1)
				src.updateUsrDialog()
			update_icon()
		if(href_list["atmos_reset"])
			apply_danger_level(0)
			spawn(1)
				src.updateUsrDialog()
			update_icon()
		return

	//Scan all area vents and set values
	proc/update_area_vents()
		if(alarm_area && alarm_area.local_alarm == src)
			for(var/obj/machinery/atmospherics/local_vent/vent in alarm_area.vents)
				vent.vent_on = vent_on
				vent.panic = panic
				vent.pressure_checks = vent_pressure_check
				vent.external_pressure_bound = external_pressure_bound
				vent.internal_pressure_bound = internal_pressure_bound
				vent.scrubbing = scrubbing
				vent.update_icon()
		return


	update_icon()//Waiting on fragg sprites
		/*if(wiresexposed)
			switch(buildstage)
				if(2)
					if(src.AAlarmwires == 0) // All wires cut
						icon_state = "alarm_b2"
					else
						icon_state = "alarmx"
				if(1)
					icon_state = "alarm_b2"
				if(0)
					icon_state = "alarm_b1"
			return*/

		if((stat & (NOPOWER|BROKEN)) || shorted)
			icon_state = "alarmp"
			return
		switch(max(danger_level, alarm_area.atmosalm))
			if (0)
				src.icon_state = "alarm0"
			if (1)
				src.icon_state = "alarm2" //yes, alarm2 is yellow alarm
			if (2)
				src.icon_state = "alarm1"
		return


	process()
		if((stat & (NOPOWER|BROKEN)) || shorted)
			return

		var/turf/simulated/location = src.loc
		if(!istype(location))
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
		if(old_danger_level!=danger_level)
			apply_danger_level(danger_level)
		return


	/*proc/post_alert(alert_level)//Dont fully know what this does
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
		return*/


	proc/apply_danger_level(var/level = 0)
		alarm_area.atmosalert(level)
		/*for(var/area/A in alarm_area.related)
			for (var/obj/machinery/alarm/AA in A)
				if(!(AA.stat & (NOPOWER|BROKEN)) && !AA.shorted)
					new_area_danger_level = max(new_area_danger_level,AA.danger_level)*/
		//if(alarm_area.atmosalert(new_area_danger_level)) //if area was in normal state or if area was in alert state
		//	post_alert(new_area_danger_level)
		update_icon()
		return


	attackby(obj/item/W as obj, mob/user as mob)
		//Needs emag
		if(istype(W, /obj/item/weapon/card/id) || istype(W, /obj/item/device/pda))// trying to unlock the interface with an ID card
			if(stat & (NOPOWER|BROKEN))
				user << "It does nothing"
			else
				if(src.allowed(usr))
					locked = !locked
					user << "\blue You [ locked ? "lock" : "unlock"] the Air Alarm interface."
					src.updateUsrDialog()
				else
					user << "\red Access denied."
			return
		return ..()


	power_change()
		if(powered(power_channel))
			stat &= ~NOPOWER
		else
			stat |= NOPOWER
		spawn(rand(0,15))
			update_icon()
