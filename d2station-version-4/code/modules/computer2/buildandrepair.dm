//Motherboard is just used in assembly/disassembly, doesn't exist in the actual computer object.
/obj/item/weapon/periph_mobo
	name = "mainboard"
	desc = "A computer motherboard."
	icon = 'module.dmi'
	icon_state = "mainboard"
	item_state = "electronic"
	w_class = 3
	var/created_name = null //If defined, result computer will have this name.
	var/burnt = 0			//Computer won't start if burnt = 1

/obj/computer2frame
	density = 1
	anchored = 0
	name = "heavy computer-frame"
	icon = 'computer2.dmi'
	icon_state = "heavy0"
	var/state = 0
	var/obj/item/weapon/periph_mobo/mainboard = null		// mainboard
	var/mainboard_secure = 0								// if the motherboard's screwed in
	var/obj/item/weapon/disk/data/fixed_disk/hd = null		// hard drive
	var/list/peripherals = list()							// list of peripherals (card scanner, prize vendor) in the frame
	var/screen_size = "heavy"

/obj/computer2frame/arcade
	name = "arcade computer-frame"
	icon_state = "arcade0"
	screen_size = "arcade"

/obj/computer2frame/atm
	name = "atm computer-frame"
	icon_state = "atmframe0"
	screen_size = "atmframe"

/obj/computer2frame/attackby(obj/item/P as obj, mob/user as mob)
	switch(state)

		// Empty computer2 frame, unanchored
		if(0)
			if(istype(P, /obj/item/weapon/wrench))
				playsound(loc, 'Ratchet.ogg', 50, 1)
				if(do_after(user, 20))
					user << "\blue You wrench the frame into place."
					anchored = 1
					state = 1
			if(istype(P, /obj/item/weapon/weldingtool))
				playsound(loc, 'Welder.ogg', 50, 1)
				if(do_after(user, 20))
					user << "\blue You deconstruct the frame."
					new /obj/item/stack/sheet/metal( loc, 5 )
					del(src)

		// Empty computer2 frame, anchored
		if(1)
			if(istype(P, /obj/item/weapon/wrench))
				if(!mainboard)
					playsound(src.loc, 'Ratchet.ogg', 50, 1)
					if(do_after(user, 20))
						user << "\blue You unfasten the frame."
						src.anchored = 0
						src.state = 0
				else user << "\red You need to remove the mainboard."
			if(istype(P, /obj/item/weapon/periph_mobo) && !mainboard)
				playsound(loc, 'Deconstruct.ogg', 50, 1)
				user << "\blue You place the mainboard inside the frame."
				icon_state = "[screen_size]1"
				mainboard = P
				user.drop_item()
				P.loc = src


			if(istype(P, /obj/item/weapon/crowbar))
				if(mainboard && !hd)
					playsound(loc, 'Crowbar.ogg', 50, 1)
					user << "\blue You remove the mainboard."
					state = 1
					icon_state = "[screen_size]0"
					mainboard.loc = loc
					mainboard = null
					return

			if(istype(P, /obj/item/weapon/screwdriver) && mainboard)
				if(!mainboard_secure)
					playsound(loc, 'Screwdriver.ogg', 50, 1)
					user << "\blue You screw the mainboard into place."
					mainboard_secure = 1
					state = 2
					icon_state = "[screen_size]2"
					return
				if(mainboard_secure && (!peripherals.len))
					playsound(loc, 'Screwdriver.ogg', 50, 1)
					user << "\blue You unfasten the mainboard."
					state = 1
					icon_state = "[screen_size]1"
					return

		// Anchored computer2 frame, with peripherals installed
		if(2)
			if(istype(P, /obj/item/weapon/peripheral))
				if(mainboard)
					if(mainboard_secure)
						if(peripherals.len < 3)
							user.drop_item()
							peripherals.Add(P)
							P.loc = src
							user << "\blue You add [P] to the [name]."
						else
							user << "\red There is no more room for peripheral cards."
					else
						user << "\red The mainboard needs to be secured."
				else
					user << "\red This [name] needs a mainboard."
			if(istype(P, /obj/item/weapon/disk/data/fixed_disk) && !hd)
				if(mainboard)
					user.drop_item()
					hd = P
					P.loc = src
					user << "\blue You connect the drive to the frame."
				else
					user << "\red This [name] needs a mainboard."
			if(istype(P, /obj/item/weapon/crowbar))
				if(hd)
					playsound(loc, 'Crowbar.ogg', 50, 1)
					user << "\blue You remove the [hd.name]."
					hd.loc = loc
					hd = null
					return
				if(peripherals.len)
					playsound(loc, 'Crowbar.ogg', 50, 1)
					var/obj/item/weapon/peripheral/W = pick(peripherals)
					user << "\blue You remove a [W.name] from the [name]."
					W.loc = loc
					peripherals.Remove(W)
					return
			if(istype(P, /obj/item/weapon/screwdriver) && mainboard)
				if(mainboard_secure && (!peripherals.len))
					playsound(loc, 'Screwdriver.ogg', 50, 1)
					user << "\blue You unfasten the mainboard."
					mainboard_secure = 0
					state = 1
					icon_state = "[screen_size]1"
					return
			if(istype(P, /obj/item/weapon/cable_coil))
				if(P:amount >= 5)
					playsound(loc, 'Deconstruct.ogg', 50, 1)
					if(do_after(user, 20))
						P:amount -= 5
						if(!P:amount) del(P)
						user << "\blue You add cables to the frame."
						state = 3
						icon_state = "[screen_size]3"

		// Anchored computer2 frame, with peripherals installed, wired up
		if(3)
			if(istype(P, /obj/item/weapon/wirecutters))
				playsound(loc, 'wirecutter.ogg', 50, 1)
				user << "\blue You remove the cables."
				state = 2
				icon_state = "[screen_size]2"
				var/obj/item/weapon/cable_coil/A = new /obj/item/weapon/cable_coil( loc )
				A.amount = 5

			if(istype(P, /obj/item/stack/sheet/glass))
				if(P:amount >= 2)
					playsound(loc, 'Deconstruct.ogg', 50, 1)
					if(do_after(user, 20))
						P:use(2)
						user << "\blue You put in the glass panel."
						state = 4
						icon_state = "[screen_size]4"

		// Anchored computer2 frame, with peripherals installed, wired up, unsecured monitor
		if(4)
			if(istype(P, /obj/item/weapon/crowbar))
				playsound(loc, 'Crowbar.ogg', 50, 1)
				user << "\blue You remove the glass panel."
				state = 3
				icon_state = "[screen_size]3"
				new /obj/item/stack/sheet/glass( loc, 2 )
			if(istype(P, /obj/item/weapon/screwdriver))
				playsound(loc, 'Screwdriver.ogg', 50, 1)
				user << "\blue You connect the monitor."
				var/obj/machinery/computer2/C= new /obj/machinery/computer2( loc )
				C.setup_drive_size = 0
				if(mainboard.created_name) C.name = mainboard.created_name
				C.screen_size = screen_size
				C.frame_type = type
				C.pixel_x = pixel_x
				C.pixel_y = pixel_y
				C.density = density
				C.icon_state = "[screen_size]4"
				if(mainboard)
					C.mainboard = mainboard
					mainboard.loc = C
				if(hd)
					C.hd = hd
					hd.loc = C
				for(var/obj/item/weapon/peripheral/W in peripherals)
					W.loc = C
					W.host = C
					C.peripherals.Add(W)
				del(src)

