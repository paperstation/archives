// It is a gizmo that flashes a small area

/obj/machinery/flasher
	name = "Mounted flash"
	desc = "A wall-mounted flashbulb device."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "mflash1"
	var/id = null
	var/range = 2 //this is roughly the size of brig cell
	var/disable = 0
	var/last_flash = 0 //Don't want it getting spammed like regular flashes
	var/strength = 10 //How weakened targets are when flashed.
	var/base_state = "mflash"
	anchored = 1

	power_change()
		if(powered())
			stat &= ~NOPOWER
			icon_state = "[base_state]1"
		else
			stat |= ~NOPOWER
			icon_state = "[base_state]1-p"


//Don't want to render prison breaks impossible
	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/wirecutters))
			add_fingerprint(user)
			src.disable = !src.disable
			if(src.disable)
				user.visible_message("\red [user] has disconnected the [src]'s flashbulb!", "\red You disconnect the [src]'s flashbulb!")
			if(!src.disable)
				user.visible_message("\red [user] has connected the [src]'s flashbulb!", "\red You connect the [src]'s flashbulb!")
			return
		..()
		return

//Let the AI trigger them directly.
	attack_ai()
		if(src.anchored)
			return src.flash()
		else
			return


	proc/flash()
		if(!(powered()))
			return

		if((src.disable) || (src.last_flash && world.time < src.last_flash + 150))
			return

		playsound(src.loc, 'sound/weapons/flash.ogg', 100, 1)
		flick("[base_state]_flash", src)
		src.last_flash = world.time
		use_power(1000)

		for(var/mob/living/O in oviewers(range, src))
			if(O.eyecheck() > 0)
				continue
			O.deal_damage(strength, WEAKEN)
			if(!O.blinded)
				flick("flash", O:flash)


	emp_act(severity)
		if(stat & (BROKEN|NOPOWER))
			..(severity)
			return
		if(prob(75/severity))
			flash()
		..(severity)
		return



//map defines
/obj/machinery/flasher/cell_1
	name = "Cell 1 Flash"
	id = "Cell 1"
	pixel_y = 28

/obj/machinery/flasher/cell_2
	name = "Cell 2 Flash"
	id = "Cell 2"
	pixel_y = 28

/obj/machinery/flasher/cell_3
	name = "Cell 3 Flash"
	id = "Cell 3"
	pixel_y = 28

/obj/machinery/flasher/cell_4
	name = "Cell 4 Flash"
	id = "Cell 4"
	pixel_y = 28

/obj/machinery/flasher/cell_5
	name = "Cell 5 Flash"
	id = "Cell 5"
	pixel_y = 28



/obj/machinery/flasher/portable //Portable version of the flasher. Only flashes when anchored
	name = "portable flasher"
	desc = "A portable flashing device. Wrench to activate and deactivate. Cannot detect slow movements."
	icon_state = "pflash1"
	strength = 8
	anchored = 0
	base_state = "pflash"
	density = 1


	HasProximity(atom/movable/AM as mob|obj)
		if((src.disable) || (src.last_flash && world.time < src.last_flash + 150))
			return

		if(istype(AM, /mob/living/carbon))
			var/mob/living/carbon/M = AM
			if((M.m_intent != "walk") && (src.anchored))
				src.flash()


	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/wrench))
			add_fingerprint(user)
			src.anchored = !src.anchored

			if (!src.anchored)
				user.show_message(text("\red [src] can now be moved."))
				src.overlays.Cut()

			else if (src.anchored)
				user.show_message(text("\red [src] is now secured."))
				src.overlays += "[base_state]-s"
			return
		..()
		return



/obj/machinery/flasher_button
	name = "flasher button"
	desc = "A remote control switch for a mounted flasher."
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt"
	var/id = null
	var/active = 0
	anchored = 1.0
	use_power = USE_POWER_IDLE
	idle_power_usage = 2
	active_power_usage = 4


	attack_ai(mob/user as mob)
		return src.attack_hand(user)


	attack_paw(mob/user as mob)
		return src.attack_hand(user)


	attackby(obj/item/weapon/W, mob/user as mob)
		return src.attack_hand(user)


	attack_hand(mob/user as mob)
		if(stat & (NOPOWER|BROKEN))
			return
		if(active)
			return

		use_power(5)

		active = 1
		icon_state = "launcheract"

		for(var/obj/machinery/flasher/M in world)
			if(M.id == src.id)
				spawn()
					M.flash()

		spawn(50)
			icon_state = "launcherbtt"
			active = 0
		return
