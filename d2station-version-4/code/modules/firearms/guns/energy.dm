
/obj/item/weapon/gun/energy/laser
	name = "laser gun"
	icon_state = "laser"
	fire_sound = 'Laser.ogg'
	w_class = 3.0
	m_amt = 2000
	origin_tech = "combat=3;magnets=2"
	mode = 1 //We don't want laser guns to be on a stun setting. --Superxpdude

	attack_self(mob/living/user as mob)
		return // We don't want laser guns to be able to change to a stun setting. --Superxpdude


/obj/item/weapon/gun/energy/laser/captain
	icon_state = "caplaser"
	item_state = "capgun"
	desc = "This is an antique laser gun. All craftsmanship is of the highest quality. It is decorated with assistant leather and chrome. The object menaces with spikes of energy. On the item is an image of Space Station 13. The station is exploding."
	force = 10
	origin_tech = null //forgotten technology of ancients lol

	New()
		..()
		charge()

	proc
		charge()
			if(power_supply.charge < power_supply.maxcharge)
				power_supply.give(100)
			update_icon()
			spawn(50) charge()
			//Added this to the cap's laser back before the gun overhaul to make it halfways worth stealing. It's back now. --NEO


/obj/item/weapon/gun/energy/laser/cyborg/load_into_chamber()
	if(in_chamber)
		return 1
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		R.cell.use(40)
		in_chamber = new /obj/item/projectile/beam(src)
		return 1
	return 0


/obj/item/weapon/gun/energy/pulse_rifle
	name = "pulse rifle"
	desc = "A heavy-duty, pulse-based energy weapon with multiple fire settings, preferred by front-line combat personnel."
	icon_state = "pulse"
	force = 10 //The standard high damage
	mode = 2
	fire_sound = 'pulse.ogg'
	load_into_chamber()
		if(in_chamber)
			return 1
		if(power_supply.charge < charge_cost)
			return 0
		switch (mode)
			if(0)
				in_chamber = new /obj/item/projectile/electrode(src)
			if(1)
				in_chamber = new /obj/item/projectile/beam(src)
			if(2)
				in_chamber = new /obj/item/projectile/beam/pulse(src)
		power_supply.use(charge_cost)
		return 1


	attack_self(mob/living/user as mob)
		mode++
		switch(mode)
			if(1)
				user << "\red [src.name] is now set to kill."
				fire_sound = 'Laser.ogg'
				charge_cost = 100
			if(2)
				user << "\red [src.name] is now set to destroy."
				fire_sound = 'pulse.ogg'
				charge_cost = 200
			else
				mode = 0
				user << "\red [src.name] is now set to stun."
				fire_sound = 'Taser.ogg'
				charge_cost = 50


	New()
		power_supply = new /obj/item/ammo_magazine/energy/super(src)
		update_icon()


/obj/item/weapon/gun/energy/pulse_rifle/destroyer
	name = "pulse destroyer"
	desc = "A heavy-duty, pulse-based energy weapon. The mode is set to DESTROY. Always destroy."
	mode = 2
	New()
		power_supply = new /obj/item/ammo_magazine/energy/infinite(src)
		update_icon()
	attack_self(mob/living/user as mob)
		return


/obj/item/weapon/gun/energy/pulse_rifle/M1911
	name = "m1911-P"
	desc = "It's not the size of the gun, it's the size of the hole it puts through people."
	icon_state = "m1911-p"
	New()
		power_supply = new /obj/item/ammo_magazine/energy/infinite(src)
		update_icon()


/obj/item/weapon/gun/energy/nuclear
	name = "Advanced Energy Gun"
	desc = "An energy gun with an experimental miniaturized reactor."
	origin_tech = "combat=3;materials=5;powerstorage=3"
	var/lightfail = 0
	icon_state = "nucgun"

	New()
		..()
		charge()

	proc
		charge()
			if(power_supply.charge < power_supply.maxcharge)
				if(failcheck())
					power_supply.give(100)
			update_icon()
			if(!crit_fail)
				spawn(50) charge()


		failcheck()
			lightfail = 0
			if (prob(src.reliability)) return 1 //No failure
			if (prob(src.reliability))
				for (var/mob/M in range(0,src)) //Only a minor failure, enjoy your radiation if you're in the same tile or carrying it
					if (src in M.contents)
						M << "\red Your gun feels pleasantly warm for a moment."
					else
						M << "\red You feel a warm sensation."
					M.radiation += rand(1,40)
				lightfail = 1
			else
				for (var/mob/M in range(rand(1,4),src)) //Big failure, TIME FOR RADIATION BITCHES
					if (src in M.contents)
						M << "\red Your gun's reactor overloads!"
					M << "\red You feel a wave of heat wash over you."
					M.radiation += 100
				crit_fail = 1 //break the gun so it stops recharging
				update_icon()


		update_charge()
			if (crit_fail)
				overlays += "nucgun-whee"
				return
			var/ratio = power_supply.charge / power_supply.maxcharge
			ratio = round(ratio, 0.25) * 100
			overlays += text("nucgun-[]", ratio)


		update_reactor()
			if(crit_fail)
				overlays += "nucgun-crit"
				return
			if(lightfail)
				overlays += "nucgun-medium"
			else if ((power_supply.charge/power_supply.maxcharge) <= 0.5)
				overlays += "nucgun-light"
			else
				overlays += "nucgun-clean"


		update_mode()
			if (mode == 2)
				overlays += "nucgun-stun"
			else if (mode == 1)
				overlays += "nucgun-kill"

	emp_act(severity)
		..()
		reliability -= round(15/severity)

	update_icon()
		overlays = null
		update_charge()
		update_reactor()
		update_mode()



/obj/item/weapon/gun/energy/taser
	name = "taser gun"
	desc = "A small, low capacity gun used for non-lethal takedowns."
	icon_state = "taser"
	fire_sound = 'Taser.ogg'
	charge_cost = 50

	load_into_chamber()
		if(in_chamber)
			return 1
		if(power_supply.charge < charge_cost)
			return 0
		in_chamber = new /obj/item/projectile/weakelectrode(src)
		power_supply.use(charge_cost)
		return 1

	New()
		power_supply = new /obj/item/ammo_magazine/energy/crap(src)

/obj/item/weapon/gun/energy/taser/cyborg/load_into_chamber()
	if(in_chamber)
		return 1
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		R.cell.use(40)
		in_chamber = new /obj/item/projectile/electrode(src)
		return 1
	return 0

/obj/item/weapon/gun/energy/taser/modern
	name = "taser gun"
	desc = "A small energy gun used for non-lethal takedowns."
	icon_state = "taser_new"
	item_state = "taser_new"
	charge_cost = 100
	locked = "/obj/item/weapon/implant/securityweapons"

	load_into_chamber()
		if(in_chamber)
			return 1
		if(power_supply.charge < charge_cost)
			return 0
		in_chamber = new /obj/item/projectile/electrode(src)
		power_supply.use(charge_cost)
		return 1

	attack_self(mob/living/user as mob)
		if(burst_size == 3)
			burst_size = 1
			user << "\blue You set the [name] to semi-automatic fire."
		else
			burst_size = 3
			user << "\blue You set the [name] to three-round burst fire."

	update_icon()
		var/ratio = power_supply.charge / power_supply.maxcharge
		ratio = round(ratio, 0.20) * 100
		icon_state = text("[][]", initial(icon_state), ratio)

/obj/item/weapon/gun/energy/lasercannon//TODO: go over this one
	name = "laser cannon"
	desc = "A heavy-duty laser cannon."
	icon_state = "lasercannon"
	fire_sound = 'lasercannonfire.ogg'
	origin_tech = "combat=4;materials=3;powerstorage=3"


	load_into_chamber()
		if(in_chamber)
			return 1
		if(power_supply.charge < charge_cost)
			return 0
		in_chamber = new /obj/item/projectile/beam/heavylaser(src)
		power_supply.use(charge_cost)
		return 1


	attack_self(mob/living/user as mob)
		return


	New()
		power_supply = new /obj/item/ammo_magazine/energy(src)
		update_icon()



/obj/item/weapon/gun/energy/shockgun
	name = "shock gun"
	desc = "A high tech energy weapon that stuns and burns a target."
	icon_state = "shockgun"
	fire_sound = 'Laser.ogg'
	origin_tech = "combat=5;materials=4;powerstorage=3"
	charge_cost = 250

	load_into_chamber()
		if(in_chamber)
			return 1
		if(power_supply.charge < charge_cost)
			return 0
		in_chamber = new /obj/item/projectile/beam/fireball(src)
		power_supply.use(charge_cost)
		return 1

	attack_self(mob/living/user as mob)
		return

	New()
		power_supply = new /obj/item/ammo_magazine/energy(src)



/obj/item/weapon/gun/energy/ionrifle
	name = "ion rifle"
	desc = "A man portable anti-armor weapon designed to disable mechanical threats"
	icon_state = "ionrifle"
	fire_sound = 'Laser.ogg'
	origin_tech = "combat=3;magnets=2"//This could likely be changed up a bit
	w_class = 4.0
	flags =  FPRINT | TABLEPASS | CONDUCT | USEDELAY | ONBACK
	charge_cost = 200

	load_into_chamber()
		if(in_chamber)
			return 1
		if(power_supply.charge < charge_cost)
			return 0
		in_chamber = new /obj/item/projectile/ion(src)
		power_supply.use(charge_cost)
		return 1

	attack_self(mob/living/user as mob)
		return

	New()
		power_supply = new /obj/item/ammo_magazine/energy(src)


/obj/item/weapon/gun/energy/decloner
	name = "biological demolecularisor"
	desc = "A gun that discharges high amounts of controlled radiation to slowly break a target into component elements."
	icon_state = "decloner"
	fire_sound = 'pulse3.ogg'
	origin_tech = "combat=5;materials=4;powerstorage=3"
	charge_cost = 100


	load_into_chamber()
		if(in_chamber)
			return 1
		if(power_supply.charge < charge_cost)
			return 0
		in_chamber = new /obj/item/projectile/declone(src)
		power_supply.use(charge_cost)
		return 1


	attack_self(mob/living/user as mob)
		return


	New()
		power_supply = new /obj/item/ammo_magazine/energy(src)


/obj/item/weapon/gun/energy/stunrevolver
	name = "stun revolver"
	desc = "A high-tech revolver that fires stun cartridges. The stun cartridges can be recharged using a conventional energy weapon recharger."
	icon_state = "stunrevolver"
	fire_sound = 'Gunshot.ogg'
	origin_tech = "combat=3;materials=3;powerstorage=2"
	charge_cost = 125


	load_into_chamber()
		if(in_chamber)
			return 1
		if(power_supply.charge < charge_cost)
			return 0
		in_chamber = new /obj/item/projectile/electrode(src)
		power_supply.use(charge_cost)
		return 1


	attack_self(mob/living/user as mob)
		return


	New()
		power_supply = new /obj/item/ammo_magazine/energy(src)



/obj/item/weapon/gun/energy/freeze
	name = "freeze gun"
	icon_state = "freezegun"
	fire_sound = 'pulse3.ogg'
	desc = "A gun that shoots supercooled hydrogen particles to drastically chill a target's body temperature."
	var/temperature = T20C
	var/current_temperature = T20C
	charge_cost = 100
	origin_tech = "combat=3;materials=4;powerstorage=3;magnets=2"


	New()
		power_supply = new /obj/item/ammo_magazine/energy/crap(src)
		spawn()
			Life()


	load_into_chamber()
		if(in_chamber)
			return 1
		if(power_supply.charge < charge_cost)
			return 0
		in_chamber = new /obj/item/projectile/freeze(src)
		power_supply.use(charge_cost)
		return 1


	attack_self(mob/living/user as mob)
		user.machine = src
		var/temp_text = ""
		if(temperature > (T0C - 50))
			temp_text = "<FONT color=black>[temperature] ([round(temperature-T0C)]&deg;C) ([round(temperature*1.8-459.67)]&deg;F)</FONT>"
		else
			temp_text = "<FONT color=blue>[temperature] ([round(temperature-T0C)]&deg;C) ([round(temperature*1.8-459.67)]&deg;F)</FONT>"

		var/dat = {"<B>Freeze Gun Configuration: </B><BR>
		Current output temperature: [temp_text]<BR>
		Target output temperature: <A href='?src=\ref[src];temp=-100'>-</A> <A href='?src=\ref[src];temp=-10'>-</A> <A href='?src=\ref[src];temp=-1'>-</A> [current_temperature] <A href='?src=\ref[src];temp=1'>+</A> <A href='?src=\ref[src];temp=10'>+</A> <A href='?src=\ref[src];temp=100'>+</A><BR>
		"}

		user << browse(dat, "window=freezegun;size=450x300")
		onclose(user, "freezegun")


	Topic(href, href_list)
		if (..())
			return
		usr.machine = src
		src.add_fingerprint(usr)
		if(href_list["temp"])
			var/amount = text2num(href_list["temp"])
			if(amount > 0)
				src.current_temperature = min(T20C, src.current_temperature+amount)
			else
				src.current_temperature = max(0, src.current_temperature+amount)
		if (istype(src.loc, /mob))
			attack_self(src.loc)
		src.add_fingerprint(usr)
		return


	proc/Life()
		while(src)
			sleep(10)

			switch(temperature)
				if(0 to 10) charge_cost = 500
				if(11 to 50) charge_cost = 150
				if(51 to 100) charge_cost = 100
				if(101 to 150) charge_cost = 75
				if(151 to 200) charge_cost = 50
				if(201 to 300) charge_cost = 25

			if(current_temperature != temperature)
				var/difference = abs(current_temperature - temperature)
				if(difference >= 10)
					if(current_temperature < temperature)
						temperature -= 10
					else
						temperature += 10
				else
					temperature = current_temperature
				if (istype(src.loc, /mob))
					attack_self(src.loc)



/obj/item/weapon/gun/energy/plasma
	name = "plasma gun"
	icon_state = "plasmagun"
	fire_sound = 'pulse3.ogg'
	desc = "A gun that fires super heated plasma at targets, thus increasing their overall body temparature and also harming them."
	var/temperature = T20C
	var/current_temperature = T20C
	charge_cost = 100
	origin_tech = "combat=3;materials=4;powerstorage=3;magnets=2"


	New()
		power_supply = new /obj/item/ammo_magazine/energy/crap(src)
		spawn()
			Life()


	load_into_chamber()
		if(in_chamber)
			return 1
		if(power_supply.charge < charge_cost)
			return 0
		in_chamber = new /obj/item/projectile/plasma(src)
		power_supply.use(charge_cost)
		return 1


	attack_self(mob/living/user as mob)
		user.machine = src
		var/temp_text = ""
		if(temperature < (T0C + 50))
			temp_text = "<FONT color=black>[temperature] ([round(temperature+T0C)]&deg;C) ([round(temperature*1.8+459.67)]&deg;F)</FONT>"
		else
			temp_text = "<FONT color=red>[temperature] ([round(temperature+T0C)]&deg;C) ([round(temperature*1.8+459.67)]&deg;F)</FONT>"

		var/dat = {"<B>Plasma Gun Configuration: </B><BR>
		Current output temperature: [temp_text]<BR>
		Target output temperature: <A href='?src=\ref[src];temp=-100'>-</A> <A href='?src=\ref[src];temp=-10'>-</A> <A href='?src=\ref[src];temp=-1'>-</A> [current_temperature] <A href='?src=\ref[src];temp=1'>+</A> <A href='?src=\ref[src];temp=10'>+</A> <A href='?src=\ref[src];temp=100'>+</A><BR>
		"}

		user << browse(dat, "window=plasmagun;size=450x300")
		onclose(user, "plasmagun")


	Topic(href, href_list)
		if (..())
			return
		usr.machine = src
		src.add_fingerprint(usr)
		if(href_list["temp"])
			var/amount = text2num(href_list["temp"])
			if(amount < 0)
				src.current_temperature = max(T20C, src.current_temperature+amount)
			else
				src.current_temperature = min(800, src.current_temperature+amount)
		if (istype(src.loc, /mob))
			attack_self(src.loc)
		src.add_fingerprint(usr)
		return


	proc/Life()
		while(src)
			sleep(10)

			switch(temperature)
				if(601 to 800) charge_cost = 500
				if(401 to 600) charge_cost = 150
				if(201 to 400) charge_cost = 100
				if(101 to 200) charge_cost = 75
				if(51 to 100) charge_cost = 50
				if(0 to 50) charge_cost = 25

			if(current_temperature != temperature)
				var/difference = abs(current_temperature + temperature)
				if(difference >= 10)
					if(current_temperature < temperature)
						temperature -= 10
					else
						temperature += 10

				else
					temperature = current_temperature

				if (istype(src.loc, /mob))
					attack_self(src.loc)


/obj/item/weapon/gun/energy/plasma/rifle
	name = "plasma rifle"
	icon_state = "Plasma_Rifle"
	charge_cost = 100
	origin_tech = "combat=4;materials=4;powerstorage=4;magnets=3"

	New()
		power_supply = new /obj/item/ammo_magazine/energy(src)
		spawn()
			Life()



/obj/item/weapon/gun/energy/crossbow
	name = "mini energy-crossbow"
	desc = "A weapon favored by many of the syndicates stealth specialists."
	icon_state = "crossbow"
	w_class = 2.0
	item_state = "crossbow"
	m_amt = 2000
	origin_tech = "combat=2;magnets=2;syndicate=5"
	suppressed = 1
	fire_sound = 'Genhit.ogg'


	New()
		power_supply = new /obj/item/ammo_magazine/energy/crap(src)
		charge()


	proc/charge()
		if(power_supply)
			if(power_supply.charge < power_supply.maxcharge) power_supply.give(100)
		spawn(50) charge()


	update_icon()
		return


	attack_self(mob/living/user as mob)
		return


	load_into_chamber()
		if(in_chamber)
			return 1
		if(power_supply.charge < charge_cost)
			return 0
		in_chamber = new /obj/item/projectile/bolt(src)
		power_supply.use(charge_cost)
		return 1



/obj/item/weapon/gun/energy/crossbow/cyborg/load_into_chamber()
	if(in_chamber)
		return 1
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		R.cell.use(20)
		in_chamber = new /obj/item/projectile/bolt(src)
		return 1
	return 0



/obj/item/weapon/gun/energy/crossbow/largecrossbow
	name = "Energy Crossbow"
	desc = "A weapon favored by syndicate infiltration teams."
	icon_state = "crossbow"
	w_class = 4.0
	item_state = "crossbow"
	force = 10
	m_amt = 2000
	origin_tech = "combat=2;magnets=2;syndicate=5"
	suppressed = 1
	fire_sound = 'Genhit.ogg'


	New()
		power_supply = new /obj/item/ammo_magazine/energy/crap(src)
		charge()


	charge()
		if(power_supply)
			if(power_supply.charge < power_supply.maxcharge) power_supply.give(200)
		spawn(20) charge()


	update_icon()
		return


	attack_self(mob/living/user as mob)
		return


	load_into_chamber()
		if(in_chamber)
			return 1
		if(power_supply.charge <= charge_cost)
			return 0
		in_chamber = new /obj/item/projectile/largebolt(src)
		power_supply.use(charge_cost)
		return 1

/obj/item/weapon/gun/energy/phaser
	name = "phaser gun"
	icon_state = "phaser"
	fire_sound = 'laser4.ogg'
	desc = "A weapon that can fire variable-size suppressive waves of energy."
	charge_cost = 100
	origin_tech = "combat=3;materials=3;magnets=2"
	var/p_lock = 1	// Power lock, emagging lets you use more powerful shots
	var/radius = 0.0
	var/power = 25.0
	var/loaded_effect = "stun"

	New()
		..()
		AdjustPowerUse()

	load_into_chamber()
		if(in_chamber)
			return 1
		if(power_supply.charge <= charge_cost)
			return 0
		in_chamber = new /obj/item/projectile/phaser(src)
		power_supply.use(charge_cost)
		return 1

	proc/AdjustPowerUse()
		while(src)
			sleep(10)
			if(power)
				charge_cost = ((power * 4) * (radius + 1))

	attack_self(mob/living/user as mob)
		user.machine = src
		var/dat = {"<B>Phaser Gun Configuration: </B><BR>
		Radius: <A href='?src=\ref[src];radius_adj=-1'>-</A> [radius+1] <A href='?src=\ref[src];radius_adj=1'>+</A><BR>
		Power: <A href='?src=\ref[src];power_adj=-5'>-</A> [power] <A href='?src=\ref[src];power_adj=5'>+</A><BR>
		Each shot will use [charge_cost] units of power!<BR>
		<HR>
		<A href='?src=\ref[user];mach_close=phaser'>Close</A><BR>
		"}

		user << browse(dat, "window=phaser;size=450x300")
		onclose(user, "phaser")

	Topic(href, href_list)
		if (..())
			return
		usr.machine = src
		src.add_fingerprint(usr)
		if (href_list["radius_adj"])
			var/rdiff = text2num(href_list["radius_adj"])
			if(rdiff > 0)
				radius += rdiff
			else
				radius -= rdiff
			if(radius < 0)
				radius = 0
			if(radius > 2)
				radius = 2
		if (href_list["power_adj"])
			var/pdiff = text2num(href_list["power_adj"])
			if(pdiff > 0)
				power += pdiff
			else
				power -= pdiff
			if(power < 5)
				power = 5
			if(power > 40 && p_lock)
				power = 40
		if (istype(loc, /mob))
			attack_self(loc)
		AdjustPowerUse()
		src.add_fingerprint(usr)
		return



/obj/item/weapon/gun/energy/wavegun
	name = "concussion rifle"
	desc = "A weapon that can fire concussive waves of energy."
	icon_state = "wavegun"
	item_state = "wavegun"
	charge_cost = 200
	origin_tech = "combat=4;materials=4;powerstorage=4;magnets=3"

	New()
		power_supply = new /obj/item/ammo_magazine/energy(src)

	load_into_chamber()
		if(in_chamber)
			return 1
		if(power_supply.charge < charge_cost)
			return 0
		in_chamber = new /obj/item/projectile/concussivewave(src)
		power_supply.use(charge_cost)
		return 1

	attack_self(mob/living/user as mob)
		if(burst_size == 3)
			burst_size = 1
			user << "\blue You set the [name] to semi-automatic fire."
		else
			burst_size = 3
			user << "\blue You set the [name] to three-round burst fire."

/obj/item/weapon/gun/energy/ep90
	name = "E-P90"
	desc = "An ancient model, reworked to fire light energy pulses."
	icon_state = "ep90"
	item_state = "ep90"
	fire_sound = 'ep90_4.ogg'
	removable_mag = 1
	item_state = "ep90"
	calibre = "ep90"
	charge_cost = 40
	var/aoe = 0			// Area of effect round

	New()
		power_supply = new /obj/item/ammo_magazine/energy/ep90(src)
		update_icon()

	load_into_chamber()
		if(in_chamber)
			return 1
		if(power_supply)
			if(power_supply.charge < charge_cost)
				return 0
			in_chamber = new /obj/item/projectile/ep90electrode(src)
			power_supply.use(charge_cost)
			update_icon()
			return 1
		else
			return 0

	attack_self(mob/living/user as mob)
		if(aoe == 1)
			burst_size = 1
			aoe = 0
			charge_cost = 40
			user << "\blue You set the [name] to semi-automatic fire."
		else if(burst_size == 1)
			burst_size = 3
			aoe = 0
			user << "\blue You set the [name] to three-round burst fire."
		else
			burst_size = 1
			aoe = 1
			charge_cost = 360
			user << "\blue You set the [name] to area-of-effect fire."

	update_icon()
		if(power_supply)
			var/ratio = power_supply.charge / power_supply.maxcharge
			ratio = round(ratio, 0.25) * 100
			icon_state = text("[]_mag[]", initial(icon_state), ratio)
		else
			icon_state = text("[]", initial(icon_state))