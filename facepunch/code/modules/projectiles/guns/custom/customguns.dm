//Holds stuff for custom guns
//Parts are in parts.dmi


/obj/item/weapon/gun/custom
	icon_state = "energy"
	name = "blank gun"
	desc = "A blank gun. See the library book on custom guns for more!"
	fire_sound = 'sound/weapons/Taser.ogg'

	var/obj/item/weapon/cell/power_supply //What type of power cell this uses
	var/charge_cost = 100 //How much energy is needed to fire.
	var/cell_type = "/obj/item/weapon/cell"
	var/projectile_type = "/obj/item/projectile/energy"
	var/modifystate
	locked = 0
	var/burst = 0
	var/open = 0
//	var/completion = 0
	var/obj/item/gunparts/modules/module = null
	var/obj/item/gunparts/circuits/circuit = null
	emp_act(severity)
		power_supply.use(round(power_supply.maxcharge / severity))
		update_icon()
		..()


	New()
		..()
		if(cell_type)
			power_supply = new cell_type(src)
		else
			power_supply = new(src)
		power_supply.give(power_supply.maxcharge)
		return


	load_into_chamber()
		if(in_chamber)	return 1
		if(!power_supply)	return 0
		if(!power_supply.use(charge_cost))	return 0
		if(!projectile_type)	return 0
		in_chamber = new projectile_type(src)
		return 1


	update_icon()
		var/ratio = power_supply.charge / power_supply.maxcharge
		ratio = round(ratio, 0.25) * 100
		if(modifystate)
			icon_state = "[modifystate][ratio]"
		else
			icon_state = "[initial(icon_state)][ratio]"


	fire(var/mob/living/user, var/turf/targloc, var/turf/curloc, var/atom/target)

		if(!load_into_chamber())
			user << "\red *click*"
			playsound(user, 'sound/weapons/empty.wav', 50, 1)
			return

		if(!in_chamber)
			return

		in_chamber.firer = user
		in_chamber.def_zone = user.zone_sel.selecting


		if(targloc == curloc)
			user.bullet_act(in_chamber)
			del(in_chamber)
			update_icon()
			return

		if(recoil)
			spawn()
				shake_camera(user, recoil + 1, recoil)

		if(silenced)
			playsound(user, fire_sound, 10, 1)
		else
			var/turf/source = get_turf(src)
			var/far_dist = 0
			for(var/mob/M in hearers(15, source))
				var/turf/M_turf = get_turf(M)
				if(M_turf && M_turf.z == source.z)
					var/dist = get_dist(M_turf, source)
					var/far_volume = Clamp(far_dist, 30, 50) // Volume is based on explosion size and dist
					far_volume += (dist <= far_dist * 0.5 ? 50 : 0) // add 50 volume if the mob is pretty close to the explosion
					M.playsound_local(source, fire_sound, far_volume, 1, 1, falloff = 5)
		//	user.visible_message("<span class='warning'>[user] fires [src]!</span>", "<span class='warning'>You fire [src]!</span>", "You hear a [istype(in_chamber, /obj/item/projectile/beam) ? "laser blast" : "gunshot"]!")

		in_chamber.original = target
		in_chamber.loc = get_turf(user)
		in_chamber.starting = get_turf(user)
		in_chamber.shot_from = src
		user.next_move = world.time + rateoffire
		in_chamber.silenced = silenced
		in_chamber.current = curloc
		in_chamber.yo = targloc.y - curloc.y
		in_chamber.xo = targloc.x - curloc.x

		spawn()
			if(in_chamber)
				in_chamber.process()
		sleep(1)
		in_chamber = null

		update_icon()

		if(user.hand)
			user.update_inv_l_hand()
		else
			user.update_inv_r_hand()


	afterattack(atom/target as mob|obj|turf, mob/living/user as mob|obj, flag, params)//TODO: go over this
		if(open)return 0
		if(flag)	return //we're placing gun on a table or in backpack
		if(istype(target, /obj/machinery/recharger) && istype(src, /obj/item/weapon/gun/energy))	return//Shouldnt flag take care of this?

		add_fingerprint(user)
		var/turf/curloc = user.loc
		var/turf/targloc = get_turf(target)
		if (!istype(targloc) || !istype(curloc))
			return
		if(!special_check(user))

			return
		if(load_into_chamber())
			user.visible_message("<span class='warning'>[user] fires [src]!</span>", "<span class='warning'>You fire [src]!</span>", "You hear a [istype(in_chamber, /obj/item/projectile/beam) ? "laser blast" : "gunshot"]!")
		if(istype(circuit, /obj/item/gunparts/circuits/triple))
			fire(user, targloc, curloc,target)
			spawn(0)
				fire(user, targloc, curloc,target)
				spawn(0)
					fire(user, targloc, curloc,target)
		else if(istype(circuit, /obj/item/gunparts/circuits/single))
			fire(user, targloc, curloc,target)
		else
			user << "The gun is unable to fire."
		return


/obj/item/weapon/gun/custom/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/screwdriver))
		switch(open)
			if(0)
				user << "You open the [name]"
				open = 1
			if(1)
				user << "You close the [name]"
				open = 0
	if(istype(I, /obj/item/weapon/cell/))
		if(open)
			if(!power_supply)
				user.drop_item(I)
				power_supply = I
				I.loc = I.contents
				update_cell()
				return
			if(power_supply)
				user << "You start banging the [I.name] against the [name]'s [power_supply] but you have no idea why you are doing it."
				return
	if(istype(I, /obj/item/gunparts/circuits/))
		if(open)
			if(!circuit)
				user << "You install the [I.name] to the [name]"
				user.drop_item(I)
				circuit = I
				I.loc = I.contents
				return
			if(circuit)
				user << "You try to put another circuit into the [name], however the previous one prevents you from doing so."
				return
	if(istype(I, /obj/item/gunparts/modules))
		if(open)
			if(!module)
				user.drop_item(I)
				module = I
				update_type()
				I.loc = I.contents
				return
			if(module)
				user << "You try to put another module into the [name], however the previous one prevents you from doing so."
				return
	if(istype(I, /obj/item/weapon/crowbar))
		if(open)
			if(power_supply)
				user << "You must remove the power supply first!"
				return 0
			if(module && circuit)
				playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
				module.loc = user.loc
				circuit.loc = user.loc
				module = null
				circuit = null
				return 0
			if(module)
				playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
				module.loc = user.loc
				module = null
				return 0
			if(circuit)
				playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
				circuit.loc = user.loc
				circuit = null
				return 0
	if(istype(I, /obj/item/weapon/pen/))
		var/mob/living/carbon/human/M = user
		var/input = stripped_input(M,"What do you want to name the gun?", ,"", MAX_NAME_LEN)
		if(src && input && !M.stat && in_range(M,src))
			name = input
			M << "You name the gun [input]. Say hello to your new friend."
			return 1
/obj/item/weapon/gun/custom/attack_hand(mob/user as mob)
	if(loc == user)
		if(open)
			if(user.l_hand != src && user.r_hand != src)
				..()
				return
			user << "<span class='notice'>You pull the [power_supply] from [src].</span>"
			power_supply.loc = user.loc
			power_supply = null
			return
	..()
/obj/item/weapon/gun/custom/proc/update_cell()//Changes the charge cost
	if(istype(power_supply, /obj/item/weapon/cell))
		charge_cost = 100
	if(istype(power_supply, /obj/item/weapon/cell/high))
		charge_cost = 150
	if(istype(power_supply, /obj/item/weapon/cell/hyper))
		charge_cost = 200
	if(istype(power_supply, /obj/item/weapon/cell/infinite))
		charge_cost = 0

/obj/item/weapon/gun/custom/proc/update_type()//Changes the type of gun and projectile sound
	if(istype(module, /obj/item/gunparts/modules/taser))
		projectile_type = "/obj/item/projectile/energy"
		fire_sound = 'sound/weapons/cgtaser.ogg'
	if(istype(module, /obj/item/gunparts/modules/lethal))
		projectile_type = "/obj/item/projectile/beam/minilaser"
		fire_sound = 'sound/weapons/cglaser.ogg'
	if(istype(module, /obj/item/gunparts/modules/emp))
		projectile_type = "/obj/item/projectile/ion"
		fire_sound = 'sound/weapons/cgion.ogg'

/obj/item/weapon/gun/custom/proc/update_desc()

//Generates a randomly named weapon with random parts
/obj/item/weapon/gun/custom/random
	New()
		..()

		var/namepart1 = pick("Cunning ", "Shooty ", "Grifftacular ", "Customized ")
		var/namepart2 = pick("Gun ", "Pistol ", "Shooter ", "Blaster ")
		var/namepart3 = pick("Griff", "Science", "Security", "Engineering", "Mr. Jennings", "Medical")

		name = namepart1 + namepart2 + "of " + namepart3

		var/modules = typesof(/obj/item/gunparts/modules/) - /obj/item/gunparts/modules/
		var/modulez = pick(modules)
		module = new modulez

		var/circuits = typesof(/obj/item/gunparts/circuits) - /obj/item/gunparts/circuits
		var/circuitz = pick(circuits)
		circuit = new circuitz
		spawn()
			update_type()