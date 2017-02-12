/*
CONTAINS:
RCDadv



What I'm trying to do here is create a device that can easily create things that are useful
to the ship but can only be accessed by admins currently, such as disposal ends and heat sinks for the engines.
Freezers, ect.



- Nernums



*/
/obj/item/weapon/rcdadv/New()
	desc = "An Advanced RCD. It currently holds [matter]/50 matter-units."
	src.spark_system = new /datum/effects/system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	return

/obj/item/weapon/rcd/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if (istype(W, /obj/item/weapon/rcd_ammo))
		if ((matter + 10) > 50)
			user << "The Advanced RCD cant hold any more matter."
			return
		del(W)
		matter += 10
		playsound(src.loc, 'click.ogg', 50, 1)
		user << "The RCD now holds [matter]/50 matter-units."
		desc = "A RCD. It currently holds [matter]/50 matter-units."
		return

/obj/item/weapon/rcd/attack_self(mob/user as mob)
	playsound(src.loc, 'pop.ogg', 50, 0)
	if (mode == 1)
		mode = 2
		user << "Changed mode to 'Airlock'"
		src.spark_system.start()
		return
	if (mode == 2)
		mode = 3
		user << "Changed mode to 'Deconstruct'"
		src.spark_system.start()
		return
	if (mode == 3)
		mode = 4
		user << "Changed mode to 'Hydroponics Tray'"
		src.spark_system.start()
		return
	if (mode == 4)
		mode = 5
		user << "Changed mode to 'Heat Reservoir'"
		src.spark_system.start()
		return
	if (mode == 5)
		mode = 6
		user << "Changed mode to 'Cold Sink'"
		src.spark_system.start()
		return
	if (mode == 6)
		mode = 7
		user << "Changed mode to 'Gas mixer'"
		src.spark_system.start()
		return
	if (mode == 7)
		mode = 8
		user << "Changed mode to 'Gas Filter'"
		src.spark_system.start()
		return
	if (mode == 8)
		mode = 9
		user << "Changed mode to 'SMES'"
		src.spark_system.start()
		return
	if (mode == 9)
		mode = 1
		user << "Changed mode to 'Station Intercom'"
		src.spark_system.start()
		return
	// Change mode

/obj/item/weapon/rcd/afterattack(atom/A, mob/user as mob)
	if (!(istype(A, /turf) || istype(A, /obj/machinery/door/airlock)))
		return

	if (istype(A, /turf) && mode == 1)
		if (istype(A, /turf/space) && matter >= 1)
			user << "Building Floor (1)..."
			if (!disabled)
				playsound(src.loc, 'Deconstruct.ogg', 50, 1)
				spark_system.set_up(5, 0, src)
				src.spark_system.start()
				A:ReplaceWithFloor()
				if (isrobot(user))
					var/mob/living/silicon/robot/engy = user
					engy.cell.charge -= 30
				else
					matter--
					user << "The RCD now holds [matter]/50 matter-units."
					desc = "A RCD. It currently holds [matter]/50 matter-units."
			return
		if (istype(A, /turf/simulated/floor) && matter >= 3)
			user << "Building Wall (3)..."
			playsound(src.loc, 'click.ogg', 50, 1)
			if(do_after(user, 20))
				if (!disabled)
					spark_system.set_up(5, 0, src)
					src.spark_system.start()
					A:ReplaceWithWall()
					playsound(src.loc, 'Deconstruct.ogg', 50, 1)
					if (isrobot(user))
						var/mob/living/silicon/robot/engy = user
						engy.cell.charge -= 90
					else
						matter -= 3
						user << "The RCD now holds [matter]/50 matter-units."
						desc = "A RCD. It currently holds [matter]/50 matter-units."
			return
	else if (istype(A, /turf/simulated/floor) && mode == 2 && matter >= 10)
		user << "Building Airlock (10)..."
		playsound(src.loc, 'click.ogg', 50, 1)
		if(do_after(user, 50))
			if (!disabled)
				spark_system.set_up(5, 0, src)
				src.spark_system.start()
				var/obj/machinery/door/airlock/T = new /obj/machinery/door/airlock( A )
				T.autoclose = 1
				playsound(src.loc, 'Deconstruct.ogg', 50, 1)
				playsound(src.loc, 'sparks2.ogg', 50, 1)
				if (isrobot(user))
					var/mob/living/silicon/robot/engy = user
					engy.cell.charge -= 300
				else
					matter -= 10
					user << "The RCD now holds [matter]/50 matter-units."
					desc = "A RCD. It currently holds [matter]/50 matter-units."

		return
	//hydrotray
	else if (istype(A, /turf/simulated/floor) && mode == 2 && matter >= 10)
		user << "Building Hydroponics Tray (10)..."
		playsound(src.loc, 'click.ogg', 50, 1)
		if(do_after(user, 50))
			if (!disabled)
				spark_system.set_up(5, 0, src)
				src.spark_system.start()
				var/obj/machinery/hydroponics/T = new /obj/machinery/hydroponics( A )
				playsound(src.loc, 'Deconstruct.ogg', 50, 1)
				playsound(src.loc, 'sparks2.ogg', 50, 1)
				if (isrobot(user))
					var/mob/living/silicon/robot/engy = user
					engy.cell.charge -= 300
				else
					matter -= 10
					user << "The RCD now holds [matter]/50 matter-units."
					desc = "A RCD. It currently holds [matter]/50 matter-units."

		return

	//heat reservior
	else if (istype(A, /turf/simulated/floor) && mode == 2 && matter >= 10)
		user << "Building Heat Reservoir (10)..."
		playsound(src.loc, 'click.ogg', 50, 1)
		if(do_after(user, 50))
			if (!disabled)
				spark_system.set_up(5, 0, src)
				src.spark_system.start()
				var/obj/machinery/atmospherics/unary/heat_reservoir/T = new /obj/machinery/atmospherics/unary/heat_reservoir( A )
				T.autoclose = 1
				playsound(src.loc, 'Deconstruct.ogg', 50, 1)
				playsound(src.loc, 'sparks2.ogg', 50, 1)
				if (isrobot(user))
					var/mob/living/silicon/robot/engy = user
					engy.cell.charge -= 300
				else
					matter -= 10
					user << "The RCD now holds [matter]/50 matter-units."
					desc = "A RCD. It currently holds [matter]/50 matter-units."

		return

	//coldsink
	else if (istype(A, /turf/simulated/floor) && mode == 2 && matter >= 10)
		user << "Building Cold Sink (10)..."
		playsound(src.loc, 'click.ogg', 50, 1)
		if(do_after(user, 50))
			if (!disabled)
				spark_system.set_up(5, 0, src)
				src.spark_system.start()
				var/obj/machinery/atmospherics/unary/cold_sink/T = new /obj/machinery/atmospherics/unary/cold_sink( A )
				T.autoclose = 1
				playsound(src.loc, 'Deconstruct.ogg', 50, 1)
				playsound(src.loc, 'sparks2.ogg', 50, 1)
				if (isrobot(user))
					var/mob/living/silicon/robot/engy = user
					engy.cell.charge -= 300
				else
					matter -= 10
					user << "The RCD now holds [matter]/50 matter-units."
					desc = "A RCD. It currently holds [matter]/50 matter-units."

		return
	//gasmixer
	else if (istype(A, /turf/simulated/floor) && mode == 2 && matter >= 10)
		user << "Building Gas Mixer (10)..."
		playsound(src.loc, 'click.ogg', 50, 1)
		if(do_after(user, 50))
			if (!disabled)
				spark_system.set_up(5, 0, src)
				src.spark_system.start()
				varobj/machinery/atmospherics/mixer/T = new obj/machinery/atmospherics/mixer( A )
				T.autoclose = 1
				playsound(src.loc, 'Deconstruct.ogg', 50, 1)
				playsound(src.loc, 'sparks2.ogg', 50, 1)
				if (isrobot(user))
					var/mob/living/silicon/robot/engy = user
					engy.cell.charge -= 300
				else
					matter -= 10
					user << "The RCD now holds [matter]/50 matter-units."
					desc = "A RCD. It currently holds [matter]/50 matter-units."

		return
	//gasfilter
	else if (istype(A, /turf/simulated/floor) && mode == 2 && matter >= 10)
		user << "Building Gas Filter (10)..."
		playsound(src.loc, 'click.ogg', 50, 1)
		if(do_after(user, 50))
			if (!disabled)
				spark_system.set_up(5, 0, src)
				src.spark_system.start()
				varobj/machinery/atmospherics/filter/T = new obj/machinery/atmospherics/filter( A )
				T.autoclose = 1
				playsound(src.loc, 'Deconstruct.ogg', 50, 1)
				playsound(src.loc, 'sparks2.ogg', 50, 1)
				if (isrobot(user))
					var/mob/living/silicon/robot/engy = user
					engy.cell.charge -= 300
				else
					matter -= 10
					user << "The RCD now holds [matter]/50 matter-units."
					desc = "A RCD. It currently holds [matter]/50 matter-units."

		return
	//SMES
	else if (istype(A, /turf/simulated/floor) && mode == 2 && matter >= 10)
		user << "Building SMES (10)..."
		playsound(src.loc, 'click.ogg', 50, 1)
		if(do_after(user, 50))
			if (!disabled)
				spark_system.set_up(5, 0, src)
				src.spark_system.start()
				var/obj/machinery/power/smes/T = new /obj/machinery/power/smes( A )
				T.autoclose = 1
				playsound(src.loc, 'Deconstruct.ogg', 50, 1)
				playsound(src.loc, 'sparks2.ogg', 50, 1)
				if (isrobot(user))
					var/mob/living/silicon/robot/engy = user
					engy.cell.charge -= 300
				else
					matter -= 10
					user << "The RCD now holds [matter]/50 matter-units."
					desc = "A RCD. It currently holds [matter]/50 matter-units."

		return
	//station radio
	else if (istype(A, /turf/simulated/floor) && mode == 2 && matter >= 10)
		user << "Building Intercom (10)..."
		playsound(src.loc, 'click.ogg', 50, 1)
		if(do_after(user, 50))
			if (!disabled)
				spark_system.set_up(5, 0, src)
				src.spark_system.start()
				var/obj/item/device/radio/intercomT = new /obj/item/device/radio/intercom( A )
				T.autoclose = 1
				playsound(src.loc, 'Deconstruct.ogg', 50, 1)
				playsound(src.loc, 'sparks2.ogg', 50, 1)
				if (isrobot(user))
					var/mob/living/silicon/robot/engy = user
					engy.cell.charge -= 300
				else
					matter -= 10
					user << "The RCD now holds [matter]/50 matter-units."
					desc = "A RCD. It currently holds [matter]/50 matter-units."

		return
//
//
//Deconstruction starts here
//
//
	else if (mode == 3 && (istype(A, /turf) || istype(A, /obj/machinery/door/airlock) ) )
		if (istype(A, /turf/simulated/wall) && matter >= 5)
			user << "Deconstructing Wall (5)..."
			playsound(src.loc, 'click.ogg', 50, 1)
			if(do_after(user, 50))
				if (!disabled)
					spark_system.set_up(5, 0, src)
					src.spark_system.start()
					A:ReplaceWithFloor()
					playsound(src.loc, 'Deconstruct.ogg', 50, 1)
					if (isrobot(user))
						var/mob/living/silicon/robot/engy = user
						engy.cell.charge -= 150
					else
						matter -= 5
						user << "The RCD now holds [matter]/50 matter-units."
						desc = "A RCD. It currently holds [matter]/50 matter-units."
			return

		if (istype(A, /turf/simulated/wall/r_wall) && matter >= 5)
			user << "Deconstructing RWall (5)..."
			playsound(src.loc, 'click.ogg', 50, 1)
			if(do_after(user, 50))
				if (!disabled)
					spark_system.set_up(5, 0, src)
					src.spark_system.start()
					A:ReplaceWithWall()
					playsound(src.loc, 'Deconstruct.ogg', 50, 1)
					if (isrobot(user))
						var/mob/living/silicon/robot/engy = user
						engy.cell.charge -= 150
					else
						matter -= 5
						user << "The RCD now holds [matter]/50 matter-units."
						desc = "A RCD. It currently holds [matter]/50 matter-units."
			return

		if (istype(A, /turf/simulated/floor) && matter >= 5)
			user << "Deconstructing Floor (5)..."
			playsound(src.loc, 'click.ogg', 50, 1)
			if(do_after(user, 50))
				if (!disabled)
					spark_system.set_up(5, 0, src)
					src.spark_system.start()
					A:ReplaceWithSpace()
					playsound(src.loc, 'Deconstruct.ogg', 50, 1)
					if (isrobot(user))
						var/mob/living/silicon/robot/engy = user
						engy.cell.charge -= 150
					else
						matter -= 5
						user << "The RCD now holds [matter]/50 matter-units."
						desc = "A RCD. It currently holds [matter]/50 matter-units."
			return
		if (istype(A, /obj/machinery/door/airlock) && matter >= 10)
			user << "Deconstructing Airlock (10)..."
			playsound(src.loc, 'click.ogg', 50, 1)
			if(do_after(user, 50))
				if (!disabled)
					spark_system.set_up(5, 0, src)
					src.spark_system.start()
					del(A)
					playsound(src.loc, 'Deconstruct.ogg', 50, 1)
					if (isrobot(user))
						var/mob/living/silicon/robot/engy = user
						engy.cell.charge -= 300
					else
						matter -= 10
						user << "The RCD now holds [matter]/50 matter-units."
						desc = "A RCD. It currently holds [matter]/50 matter-units."
			return

		//hydrotray
		if (istype(A, /obj/machinery/door/airlock) && matter >= 10)
			user << "Deconstructing Airlock (10)..."
			playsound(src.loc, 'click.ogg', 50, 1)
			if(do_after(user, 50))
				if (!disabled)
					spark_system.set_up(5, 0, src)
					src.spark_system.start()
					del(A)
					playsound(src.loc, 'Deconstruct.ogg', 50, 1)
					if (isrobot(user))
						var/mob/living/silicon/robot/engy = user
						engy.cell.charge -= 300
					else
						matter -= 10
						user << "The RCD now holds [matter]/50 matter-units."
						desc = "A RCD. It currently holds [matter]/50 matter-units."
			return

		//heatrerv
		if (istype(A, /obj/machinery/door/airlock) && matter >= 10)
			user << "Deconstructing Airlock (10)..."
			playsound(src.loc, 'click.ogg', 50, 1)
			if(do_after(user, 50))
				if (!disabled)
					spark_system.set_up(5, 0, src)
					src.spark_system.start()
					del(A)
					playsound(src.loc, 'Deconstruct.ogg', 50, 1)
					if (isrobot(user))
						var/mob/living/silicon/robot/engy = user
						engy.cell.charge -= 300
					else
						matter -= 10
						user << "The RCD now holds [matter]/50 matter-units."
						desc = "A RCD. It currently holds [matter]/50 matter-units."
			return
		//coldsink
		if (istype(A, /obj/machinery/door/airlock) && matter >= 10)
			user << "Deconstructing Airlock (10)..."
			playsound(src.loc, 'click.ogg', 50, 1)
			if(do_after(user, 50))
				if (!disabled)
					spark_system.set_up(5, 0, src)
					src.spark_system.start()
					del(A)
					playsound(src.loc, 'Deconstruct.ogg', 50, 1)
					if (isrobot(user))
						var/mob/living/silicon/robot/engy = user
						engy.cell.charge -= 300
					else
						matter -= 10
						user << "The RCD now holds [matter]/50 matter-units."
						desc = "A RCD. It currently holds [matter]/50 matter-units."
			return
		//gasmixer
		if (istype(A, /obj/machinery/door/airlock) && matter >= 10)
			user << "Deconstructing Airlock (10)..."
			playsound(src.loc, 'click.ogg', 50, 1)
			if(do_after(user, 50))
				if (!disabled)
					spark_system.set_up(5, 0, src)
					src.spark_system.start()
					del(A)
					playsound(src.loc, 'Deconstruct.ogg', 50, 1)
					if (isrobot(user))
						var/mob/living/silicon/robot/engy = user
						engy.cell.charge -= 300
					else
						matter -= 10
						user << "The RCD now holds [matter]/50 matter-units."
						desc = "A RCD. It currently holds [matter]/50 matter-units."
			return
		//gasfilter
		if (istype(A, /obj/machinery/door/airlock) && matter >= 10)
			user << "Deconstructing Airlock (10)..."
			playsound(src.loc, 'click.ogg', 50, 1)
			if(do_after(user, 50))
				if (!disabled)
					spark_system.set_up(5, 0, src)
					src.spark_system.start()
					del(A)
					playsound(src.loc, 'Deconstruct.ogg', 50, 1)
					if (isrobot(user))
						var/mob/living/silicon/robot/engy = user
						engy.cell.charge -= 300
					else
						matter -= 10
						user << "The RCD now holds [matter]/50 matter-units."
						desc = "A RCD. It currently holds [matter]/50 matter-units."
			return
		//smes
		if (istype(A, /obj/machinery/door/airlock) && matter >= 10)
			user << "Deconstructing Airlock (10)..."
			playsound(src.loc, 'click.ogg', 50, 1)
			if(do_after(user, 50))
				if (!disabled)
					spark_system.set_up(5, 0, src)
					src.spark_system.start()
					del(A)
					playsound(src.loc, 'Deconstruct.ogg', 50, 1)
					if (isrobot(user))
						var/mob/living/silicon/robot/engy = user
						engy.cell.charge -= 300
					else
						matter -= 10
						user << "The RCD now holds [matter]/50 matter-units."
						desc = "A RCD. It currently holds [matter]/50 matter-units."
			return
		//stationradio
		if (istype(A, /obj/machinery/door/airlock) && matter >= 10)
			user << "Deconstructing Airlock (10)..."
			playsound(src.loc, 'click.ogg', 50, 1)
			if(do_after(user, 50))
				if (!disabled)
					spark_system.set_up(5, 0, src)
					src.spark_system.start()
					del(A)
					playsound(src.loc, 'Deconstruct.ogg', 50, 1)
					if (isrobot(user))
						var/mob/living/silicon/robot/engy = user
						engy.cell.charge -= 300
					else
						matter -= 10
						user << "The RCD now holds [matter]/50 matter-units."
						desc = "A RCD. It currently holds [matter]/50 matter-units."
			return
