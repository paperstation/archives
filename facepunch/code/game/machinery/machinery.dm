/*
Overview:
   Used to create objects that need a per step proc call.  Default definition of 'New()'
   stores a reference to src machine in global 'machines list'.  Default definition
   of 'Del' removes reference to src machine in global 'machines list'.

Class Variables:
   use_power (num)
      current state of auto power use.
      Possible Values:
         0 -- no auto power use
         1 -- machine is using power at its idle power level
         2 -- machine is using power at its active power level

   active_power_usage (num)
      Value for the amount of power to use when in active power mode

   idle_power_usage (num)
      Value for the amount of power to use when in idle power mode

   power_channel (num)
      What channel to draw from when drawing power for power mode
      Possible Values:
         EQUIP:0 -- Equipment Channel
         LIGHT:2 -- Lighting Channel
         ENVIRON:3 -- Environment Channel

   component_parts (list)
      A list of component parts of machine used by frame based machines.

   uid (num)
      Unique id of machine across all machines.

   gl_uid (global num)
      Next uid value in sequence

   stat (bitflag)
      Machine status bit flags.
      Possible bit flags:
         BROKEN:1 -- Machine is broken
         NOPOWER:2 -- No power is being supplied to machine.
         POWEROFF:4 -- tbd
         MAINT:8 -- machine is currently under going maintenance.
         EMPED:16 -- temporary broken by EMP pulse

   manual (num)
      Currently unused.

Class Procs:
   New()                     'game/machinery/machine.dm'

   Del()                     'game/machinery/machine.dm'

   powered(chan = EQUIP)         'modules/power/power.dm'
      Checks to see if area that contains the object has power available for power
      channel given in 'chan'.

   use_power(amount, chan=EQUIP)   'modules/power/power.dm'
      Deducts 'amount' from the power channel 'chan' of the area that contains the object.

   power_change()               'modules/power/power.dm'
      Called by the area that contains the object when ever that area under goes a
      power state change (area runs out of power, or area channel is turned off).

   RefreshParts()               'game/machinery/machine.dm'
      Called to refresh the variables in the machine that are contributed to by parts
      contained in the component_parts list. (example: glass and material amounts for
      the autolathe)

      Default definition does nothing.

   assign_uid()               'game/machinery/machine.dm'
      Called by machine to assign a value to the uid variable.

   process()                  'game/machinery/machine.dm'
      Called by the 'master_controller' once per game tick for each machine that is listed in the 'machines' list.


	Compiled by Aygar
*/

/obj/machinery
	name = "machinery"
	icon = 'icons/obj/stationobjs.dmi'
	health = 100
	max_health = 100
	damage_resistance = 0//-1 means it will never break
	var/stat = 0
	var/emagged = 0
	var/use_power = USE_POWER_NONE
		//USE_POWER_NONE = dont use any power
		//USE_POWER_IDLE = run auto, use idle
		//USE_POWER_ACTIVE = run auto, use active
	var/idle_power_usage = 0
	var/active_power_usage = 0
	var/power_channel = EQUIP
		//EQUIP,ENVIRON or LIGHT
	var/list/component_parts = null //list of all the parts used to build it, if made from certain kinds of frames.
	var/uid
	var/manual = 0
	var/global/gl_uid = 1


	New()
		..()
		machines += src
		SSmachines.processing += src
		SSpower.processing += src
		return


	Del()
		machines -= src
		SSmachines.processing -= src
		SSpower.processing -= src
		return ..()


	process()//If you dont use process, remove from the SSmachines.processing list
		return PROCESS_KILL


	emp_act(severity)
		if(use_power && stat == 0)
			use_power(7500/severity)

			var/obj/effect/overlay/pulse2 = new/obj/effect/overlay ( src.loc )
			pulse2.icon = 'icons/effects/effects.dmi'
			pulse2.icon_state = "empdisable"
			pulse2.name = "emp sparks"
			pulse2.anchored = 1
			pulse2.dir = pick(cardinal)

			spawn(10)
				del(pulse2)
		..()
		return


	Topic(href, href_list)
		..()
		if(stat & (NOPOWER|BROKEN))
			return 1
		if(usr.restrained() || usr.lying || usr.stat)
			return 1
		if(!usr.IsAdvancedToolUser())
			usr << "\red You don't have the dexterity to do this!"
			return 1

		var/norange = 0
		if(istype(usr, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = usr
			if(istype(H.l_hand, /obj/item/tk_grab))
				norange = 1
			else if(istype(H.r_hand, /obj/item/tk_grab))
				norange = 1

		if(!norange)
			if ((!in_range(src, usr) || !istype(src.loc, /turf)) && !istype(usr, /mob/living/silicon))
				return 1

		src.add_fingerprint(usr)
		return 0


	attack_ai(mob/user as mob)
		if(isrobot(user))
			// For some reason attack_robot doesn't work
			// This is to stop robots from using cameras to remotely control machines.
			if(user.client && user.client.eye == user)
				return src.attack_hand(user)
		else
			return src.attack_hand(user)

	attack_paw(mob/user as mob)
		return src.attack_hand(user)

	attack_hand(mob/user as mob)
		if(stat & (NOPOWER|BROKEN|MAINT))
			return 1
		if(user.lying || user.stat)
			return 1
		if ( ! (istype(usr, /mob/living/carbon/human) || \
				istype(usr, /mob/living/silicon) || \
				istype(usr, /mob/living/carbon/monkey) && ticker && ticker.mode.name == "monkey") )
			usr << "\red You don't have the dexterity to do this!"
			return 1
	/*
		//distance checks are made by atom/proc/DblClick
		if ((get_dist(src, user) > 1 || !istype(src.loc, /turf)) && !istype(user, /mob/living/silicon))
			return 1
	*/
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.brain_damage >= 60)
				visible_message("\red [H] stares cluelessly at [src] and drools.")
				return 1
			else if(prob(H.brain_damage))
				user << "\red You momentarily forget how to use [src]."
				return 1

		src.add_fingerprint(user)
		return 0


	proc/RefreshParts() //Placeholder proc for machines that are built using frames.
		return 0


	proc/assign_uid()
		uid = gl_uid
		gl_uid++
		return

