// the power monitoring computer
// for the moment, just report the status of all APCs in the same powernet
/obj/machinery/power/monitor
	name = "power monitoring computer"
	desc = "It monitors power levels across the station."
	icon = 'icons/obj/computer.dmi'
	icon_state = "power"
	density = 1
	anchored = 1
	use_power = USE_POWER_ACTIVE
	idle_power_usage = 20
	active_power_usage = 80

//fix for issue 521, by QualityVan.
//someone should really look into why circuits have a powernet var, it's several kinds of retarded.
/obj/machinery/power/monitor/New()
	..()
	var/obj/structure/cable/attached = null
	var/turf/T = loc
	if(isturf(T))
		attached = locate() in T
	if(attached)
		powernet = attached.get_powernet()


/obj/machinery/power/monitor/attack_ai(mob/user)
	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER))
		return
	interact(user)

/obj/machinery/power/monitor/attack_hand(mob/user)
	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER))
		return
	interact(user)

/obj/machinery/power/monitor/attackby(I as obj, user as mob)
	if(istype(I, /obj/item/weapon/screwdriver))
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			if (src.stat & BROKEN)
				user << "\blue The broken glass falls out."
				var/obj/structure/computerframe/A = new /obj/structure/computerframe( src.loc )
				new /obj/item/weapon/shard( src.loc )
				var/obj/item/weapon/circuitboard/powermonitor/M = new /obj/item/weapon/circuitboard/powermonitor( A )
				for (var/obj/C in src)
					C.loc = src.loc
				A.circuit = M
				A.state = 3
				A.icon_state = "3"
				A.anchored = 1
				del(src)
			else
				user << "\blue You disconnect the monitor."
				var/obj/structure/computerframe/A = new /obj/structure/computerframe( src.loc )
				var/obj/item/weapon/circuitboard/powermonitor/M = new /obj/item/weapon/circuitboard/powermonitor( A )
				for (var/obj/C in src)
					C.loc = src.loc
				A.circuit = M
				A.state = 4
				A.icon_state = "4"
				A.anchored = 1
				del(src)
	else
		src.attack_hand(user)
	return

/obj/machinery/power/monitor/interact(mob/user)

	if ( (get_dist(src, user) > 1 ) || (stat & (BROKEN|NOPOWER)) )
		if (!istype(user, /mob/living/silicon))
			user.unset_machine()
			user << browse(null, "window=powcomp")
			return


	user.set_machine(src)
	var/t = "<TT><B>Power Monitoring</B><HR>"

	t += "<BR><HR><A href='?src=\ref[src];update=1'>Refresh</A>"
	t += "<BR><HR><A href='?src=\ref[src];close=1'>Close</A>"

	if(!powernet)
		t += "\red No connection"
	else
		var/factor = 10 / SSpower.wait
		t += "<PRE>Total power: [num2text(round(powernet.avail*factor,1),10)] W/s<BR>Total load:  [num2text(round(powernet.load*factor,1),10)] W/s<BR>"

		t += "<FONT SIZE=-1>"

		t += "<table width=100%>"
		t += "<tr><th>Area</th><th>Eqp.</th><th>Lgt.</th><th>Env.</th><th>Load</th><th>Cell</th></tr>"

		var/list/chg = list("N","C","F")
		for(var/obj/machinery/power/apc/A in SSpower.apcs)
			if(A.terminal && A.terminal.powernet == powernet)
				t += "<tr><td>[copytext(add_tspace("\The [A.area]", 30), 1, 30)]</td><td>[channelmodetext(A.equipment,A.equipment_percent)]</td><td>[channelmodetext(A.lighting,A.lighting_percent)]</td><td>[channelmodetext(A.environ,A.environ_percent)]</td><td>[add_lspace(A.lastused_total*factor, 6)]</td><td>[A.cell ? "[add_lspace(round(A.cell.percent()), 3)]% [chg[A.charging+1]]" : "  N/C"]</td></tr>"

		t += "</table>"

		t += "</FONT></PRE></TT>"

	user << browse(t, "window=powcomp;size=850x600")
	onclose(user, "powcomp")


/obj/machinery/power/monitor/Topic(href, href_list)
	..()
	if( href_list["close"] )
		usr << browse(null, "window=powcomp")
		usr.unset_machine()
		return
	if( href_list["update"] )
		src.updateDialog()
		return


/obj/machinery/power/monitor/power_change()

	if(stat & BROKEN)
		icon_state = "broken"
	else
		if( powered() )
			icon_state = initial(icon_state)
			stat &= ~NOPOWER
		else
			spawn(rand(0, 15))
				src.icon_state = "computer_no_power"
				stat |= NOPOWER

