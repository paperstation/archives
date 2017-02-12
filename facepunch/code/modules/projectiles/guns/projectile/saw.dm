


/obj/item/weapon/gun/projectile/automatic/l6_saw
	name = "L6 SAW"
	desc = "A light machine gun"
	icon_state = "l6closed100"
	item_state = "l6closedmag"
	w_class = 3
	slot_flags = 0
	max_shells = 100
	caliber = "a762"
	origin_tech = "combat=5;materials=1;syndicate=2"
	ammo_type = "/obj/item/ammo_casing/a762"
	fire_sound = 'sound/weapons/mp5gunshot.ogg'
	load_method = 2
	var/cover_open = 0
	var/mag_inserted = 1
	rateoffire = 0
	var/max_shots = 3
	locked = 3//Ass level

	attack_self(mob/user as mob)
		cover_open = !cover_open
		user << "<span class='notice'>You [cover_open ? "open" : "close"] [src]'s cover.</span>"
		update_icon()


	update_icon()
		icon_state = "l6[cover_open ? "open" : "closed"][mag_inserted ? round(loaded.len, 25) : "-empty"]"


	afterattack(atom/target as mob|obj|turf, mob/living/user as mob|obj, flag, params) //what I tried to do here is just add a check to see if the cover is open or not and add an icon_state change because I can't figure out how c-20rs do it with overlays
		if(cover_open)
			user << "<span class='notice'>[src]'s cover is open! Close it before firing!</span>"
		else
			..()
			update_icon()


	attack_hand(mob/user as mob)
		if(loc != user)
			..()
			return	//let them pick it up
		if(!cover_open || (cover_open && !mag_inserted))
			..()
		else if(cover_open && mag_inserted)
			//drop the mag
			empty_mag = new/obj/item/ammo_magazine/a762(src)
			empty_mag.stored_ammo = loaded
			empty_mag.icon_state = "a762-[round(loaded.len, 10)]"
			empty_mag.desc = "There are [loaded.len] shells left!"
			empty_mag.loc = get_turf(src.loc)
			user.put_in_hands(empty_mag)
			empty_mag = null
			mag_inserted = 0
			loaded = list()
			update_icon()
			user << "<span class='notice'>You remove the magazine from [src].</span>"


	attackby(var/obj/item/A as obj, mob/living/user as mob)
		if(istype(A, /obj/item/ammo_magazine/a762))
			if(!cover_open)
				user << "<span class='notice'>[src]'s cover is closed! You can't insert a new mag!</span>"
				return
			else if(cover_open && mag_inserted)
				user << "<span class='notice'>[src] already has a magazine inserted!</span>"
				return
			else if(cover_open && !mag_inserted)
				mag_inserted = 1
				user << "<span class='notice'>You insert the magazine!</span>"
				update_icon()
		..()
		return



	fire(var/mob/living/user, var/turf/targloc, var/turf/curloc, var/atom/target, var/shots = 0)
		if(shots >= max_shots)
			return
		if(!load_into_chamber())
			user << "\red *click*";
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

		if(!shots)//Quick hack on a hack to make it only go bang once
			if(silenced)
				playsound(user, fire_sound, 10, 1)
			else
				playsound(user, fire_sound, 50, 1)
				user.visible_message("<span class='warning'>[user] fires [src]!</span>", "<span class='warning'>You fire [src]!</span>", "You hear a [istype(in_chamber, /obj/item/projectile/beam) ? "laser blast" : "gunshot"]!")

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
		fire(user,targloc,curloc,target,++shots)


/obj/item/weapon/gun/projectile/automatic/l6_saw/bullet
	name = "L6 SAW"
	desc = "A rather traditionally made light machine gun with a pleasantly lacquered wooden pistol grip. Has 'Aussec Armoury- 2531' engraved on the reciever"
	icon_state = "l6closed100"
	item_state = "l6closedmag"
	ammo_type = "/obj/item/ammo_casing/a762x54r"
	max_shots = 5


