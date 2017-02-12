// the SMES
// stores power

#define SMESMAXCHARGELEVEL 200000
#define SMESMAXOUTPUT 200000

/obj/machinery/power/smes
	name = "power storage unit"
	desc = "A high-capacity superconducting magnetic energy storage (SMES) unit."
	icon_state = "smes"
	density = 1
	anchored = 1
	use_power = USE_POWER_NONE
	var/output = 70000
	var/lastout = 0
	var/loaddemand = 0
	var/capacity = 5e6
	var/charge = 2e6
	var/charging = 0
	var/chargemode = 0
	var/chargelevel = 80000
	var/online = 1
	var/n_tag = null
	var/obj/machinery/power/terminal/terminal = null

	var/update_icon = 0


/obj/machinery/power/smes/New()
	..()
	SSpower.smes += src
	spawn(5)
		dir_loop:
			for(var/d in cardinal)
				var/turf/T = get_step(src, d)
				for(var/obj/machinery/power/terminal/term in T)
					if(term && term.dir == turn(d, 180))
						terminal = term
						break dir_loop
		if(!terminal)
			stat |= BROKEN
			return
		terminal.master = src
		updateicon()
	return

/obj/machinery/power/smes/Del()
	SSpower.smes -= src
	return ..()

/*
/obj/machinery/power/smes/connect_to_network()
	. = ..()
	if(.)
		powernet.smes += src

/obj/machinery/power/smes/disconnect_from_network()
	. = ..()
	if(.)
		powernet.smes -= src
*/


/obj/machinery/power/smes/proc/updateicon()
	overlays.Cut()
	if(stat & BROKEN)	return

	overlays += image('icons/obj/power.dmi', "smes-op[online]")

	if(charging)
		overlays += image('icons/obj/power.dmi', "smes-oc1")
	else
		if(chargemode)
			overlays += image('icons/obj/power.dmi', "smes-oc0")

	var/clevel = chargedisplay()
	if(clevel>0)
		overlays += image('icons/obj/power.dmi', "smes-og[clevel]")
	return


/obj/machinery/power/smes/proc/chargedisplay()
	return round(5.5*charge/capacity)

#define SMESRATE 0.05			// rate of internal charge to external power


/obj/machinery/power/smes/proc/distribute_power(seconds)
	if(stat & BROKEN)	return

	if(online && powernet)
		lastout = min( charge/SMESRATE, output*seconds ) //limit output to that stored, and our output level
		charge -= lastout*SMESRATE
		powernet.avail += lastout
	return

//SMES are handled differently to other machines.
/obj/machinery/power/smes/process_power()
	if(update_icon)
		updateicon()
		update_icon = 0
	updateDialog()

/obj/machinery/power/smes/proc/charge(seconds)
	if(stat & BROKEN)	return

	var/last_chrg = charging
	charging = 0
	if(terminal && chargemode && terminal.powernet)
		var/power_available = terminal.surplus()
		var/smes_demand = chargelevel * seconds
		if(power_available >= smes_demand)	//if the available power exceeds the minimum we require, we charge up
			var/used_by_smes = min((capacity-charge)/SMESRATE, smes_demand)	// charge at set rate, limited to spare capacity
			charge += used_by_smes * SMESRATE	// increase the charge
			terminal.powernet.load += used_by_smes
			if(used_by_smes)
				charging = 1
	if(last_chrg != charging)
		update_icon = 1


// called after all power processes are finished
// restores charge level to smes if there was excess this ptick


/obj/machinery/power/smes/proc/reclaim_unused_power()
	loaddemand = 0

	if(stat & BROKEN) return

	if(online && powernet)
		var/unused_power_to_reclaim = min( (powernet.avail - powernet.load), lastout, (capacity-charge)/SMESRATE )
			// clamp it to how much was actually output by this SMES last ptick
			// for safety, also limit recharge by space capacity of SMES (shouldn't happen)

		if(unused_power_to_reclaim > 0)
			var/chargedisplay = chargedisplay()	//used to see if the chargemeter overlay needs updating

			//remove this surplus from the network
			powernet.avail -= unused_power_to_reclaim
			//now add it to our charge
			charge += unused_power_to_reclaim * SMESRATE

			loaddemand = lastout - unused_power_to_reclaim

			if(chargedisplay != chargedisplay())
				update_icon = 1


/obj/machinery/power/smes/add_load(var/amount)
	if(terminal && terminal.powernet)
		terminal.powernet.newload += amount


/obj/machinery/power/smes/attack_ai(mob/user)
	add_fingerprint(user)
	if(stat & BROKEN) return
	interact(user)


/obj/machinery/power/smes/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & BROKEN) return

	if(ishuman(user))
		if(istype(user:gloves, /obj/item/clothing/gloves/space_ninja)&&user:gloves:candrain&&!user:gloves:draining)
			call(/obj/item/clothing/gloves/space_ninja/proc/drain)("SMES",src,user:wear_suit)
			return
	interact(user)


/obj/machinery/power/smes/interact(mob/user)
	if(get_dist(src, user) > 1 && !istype(user, /mob/living/silicon/ai))
		user.unset_machine()
		user << browse(null, "window=smes")
		return

	user.set_machine(src)

	var/t = "<TT><B>SMES Power Storage Unit</B> [n_tag? "([n_tag])" : null]<HR><PRE>"

	t += "Stored capacity : [round(100.0*charge/capacity, 0.1)]%<BR><BR>"

	t += "Input: [charging ? "Charging" : "Not Charging"]    [chargemode ? "<B>Auto</B> <A href = '?src=\ref[src];cmode=1'>Off</A>" : "<A href = '?src=\ref[src];cmode=1'>Auto</A> <B>Off</B> "]<BR>"


	t += "Input level:  <A href = '?src=\ref[src];input=-4'>M</A> <A href = '?src=\ref[src];input=-3'>-</A> <A href = '?src=\ref[src];input=-2'>-</A> <A href = '?src=\ref[src];input=-1'>-</A> [add_lspace(chargelevel,5)] W/s <A href = '?src=\ref[src];input=1'>+</A> <A href = '?src=\ref[src];input=2'>+</A> <A href = '?src=\ref[src];input=3'>+</A> <A href = '?src=\ref[src];input=4'>M</A><BR>"

	t += "<BR><BR>"

	t += "Output: [online ? "<B>Online</B> <A href = '?src=\ref[src];online=1'>Offline</A>" : "<A href = '?src=\ref[src];online=1'>Online</A> <B>Offline</B> "]<BR>"

	t += "Output level: <A href = '?src=\ref[src];output=-4'>M</A> <A href = '?src=\ref[src];output=-3'>-</A> <A href = '?src=\ref[src];output=-2'>-</A> <A href = '?src=\ref[src];output=-1'>-</A> [add_lspace(output,5)] W/s <A href = '?src=\ref[src];output=1'>+</A> <A href = '?src=\ref[src];output=2'>+</A> <A href = '?src=\ref[src];output=3'>+</A> <A href = '?src=\ref[src];output=4'>M</A><BR>"

	t += "Output load: [round(loaddemand*10/SSpower.wait)] W/s<BR>"

	t += "<BR></PRE><HR><A href='?src=\ref[src];close=1'>Close</A>"

	t += "</TT>"
	user << browse(t, "window=smes;size=460x300")
	onclose(user, "smes")
	return


/obj/machinery/power/smes/Topic(href, href_list)
	..()

	if (usr.stat || usr.restrained() )
		return
	if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		if(!istype(usr, /mob/living/silicon/ai))
			usr << "\red You don't have the dexterity to do this!"
			return

//world << "[href] ; [href_list[href]]"

	if (( usr.machine==src && ((get_dist(src, usr) <= 1) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon/ai)))


		if( href_list["close"] )
			usr << browse(null, "window=smes")
			usr.unset_machine()
			return

		else if( href_list["cmode"] )
			chargemode = !chargemode
			if(!chargemode)
				charging = 0
			updateicon()

		else if( href_list["online"] )
			online = !online
			updateicon()
		else if( href_list["input"] )

			var/i = text2num(href_list["input"])

			var/d = 0
			switch(i)
				if(-4)
					chargelevel = 0
				if(4)
					chargelevel = SMESMAXCHARGELEVEL		//30000

				if(1)
					d = 100
				if(-1)
					d = -100
				if(2)
					d = 1000
				if(-2)
					d = -1000
				if(3)
					d = 10000
				if(-3)
					d = -10000

			chargelevel += d
			chargelevel = max(0, min(SMESMAXCHARGELEVEL, chargelevel))	// clamp to range

		else if( href_list["output"] )

			var/i = text2num(href_list["output"])

			var/d = 0
			switch(i)
				if(-4)
					output = 0
				if(4)
					output = SMESMAXOUTPUT		//30000

				if(1)
					d = 100
				if(-1)
					d = -100
				if(2)
					d = 1000
				if(-2)
					d = -1000
				if(3)
					d = 10000
				if(-3)
					d = -10000

			output += d
			output = max(0, min(SMESMAXOUTPUT, output))	// clamp to range

		investigate_log("input/output; [chargelevel>output?"<font color='green'>":"<font color='red'>"][chargelevel]/[output]</font> | Output-mode: [online?"<font color='green'>on</font>":"<font color='red'>off</font>"] | Input-mode: [chargemode?"<font color='green'>auto</font>":"<font color='red'>off</font>"] by [usr.key]","singulo")
		src.updateUsrDialog()

	else
		usr << browse(null, "window=smes")
		usr.unset_machine()
	return


/obj/machinery/power/smes/proc/ion_act()
	if(src.z == 1)
		if(prob(1)) //explosion
			world << "\red SMES explosion in [src.loc.loc]"
			for(var/mob/M in viewers(src))
				M.show_message("\red The [src.name] is making strange noises!", 3, "\red You hear sizzling electronics.", 2)
			sleep(10*pick(4,5,6,7,10,14))
			var/datum/effect/effect/system/harmless_smoke_spread/smoke = new /datum/effect/effect/system/harmless_smoke_spread()
			smoke.set_up(3, 0, src.loc)
			smoke.attach(src)
			smoke.start()
			explosion(src.loc, -1, 0, 1, 3, 0)
			del(src)
			return
		if(prob(15)) //Power drain
			world << "\red SMES power drain in [src.loc.loc]"
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(3, 1, src)
			s.start()
			if(prob(50))
				emp_act(1)
			else
				emp_act(2)
		if(prob(5)) //smoke only
			world << "\red SMES smoke in [src.loc.loc]"
			var/datum/effect/effect/system/harmless_smoke_spread/smoke = new /datum/effect/effect/system/harmless_smoke_spread()
			smoke.set_up(3, 0, src.loc)
			smoke.attach(src)
			smoke.start()


/obj/machinery/power/smes/emp_act(severity)
	charge -= round(1e6/severity)
	if(charge < 0)
		charge = 0
	..()



/obj/machinery/power/smes/magical
	name = "magical power storage unit"
	desc = "A high-capacity superconducting magnetic energy storage (SMES) unit. Magically produces power."
	process()
		capacity = INFINITY
		charge = INFINITY
		..()



/proc/rate_control(var/S, var/V, var/C, var/Min=1, var/Max=5, var/Limit=null)
	var/href = "<A href='?src=\ref[S];rate control=1;[V]"
	var/rate = "[href]=-[Max]'>-</A>[href]=-[Min]'>-</A> [(C?C : 0)] [href]=[Min]'>+</A>[href]=[Max]'>+</A>"
	if(Limit) return "[href]=-[Limit]'>-</A>"+rate+"[href]=[Limit]'>+</A>"
	return rate


#undef SMESRATE