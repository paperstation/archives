//The wizard car, yes it is a chair, yes this is bad.
/obj/structure/stool/bed/chair/wizard_car
	name = "wizard car"
	icon = 'icons/obj/wizard_car.dmi'
	icon_state = "car"
	desc = "A 2080 Chevrolet Camaro, it's in perfect condition. According to the spedometer it has two speeds; Fast and 2Fast. The liscence plate reads BDMIN-1."
	anchored = 1
	density = 1
	pixel_x = -80
	pixel_y = -7
	damage_resistance = -1
	var
		locked = 1//Can you get in
		on = 0

	New()
		handle_rotation()


	attackby(obj/item/W, mob/user)
		if(istype(W, /obj/item/wizard_key))
			if(user != buckled_mob)
				user << "You [locked ? "unlock" : "lock"] the [name]."
				locked = !locked
				return
			user << "You [on ? "deactivate" : "activate"] the [name]."
			on = !on
			locked = on
			return
		visible_message("The [name] has been hit by [user] with the [W]!","You hit the [name] with the [W]")
		return


	attack_hand(mob/user)
		if(buckled_mob == user)
			if(on)
				user << "The [name] is still on!"
				return
			user << "You get out of the [name]."
			unbuckle()
			return
		if(!buckled_mob)
			return
		if(!locked)
			user.visible_message(\
			"<span class='notice'>[user] pulls [buckled_mob] out of the [name]!</span>",\
			"<span class='notice'>You pull [buckled_mob] out of the [name]!</span>")
			on = 0
			unbuckle()
			return
		else
			user << "The [name] is locked!"
		return


	ex_act(severity)
		return 0


	meteorhit(obj/O as obj)
		return 0


	relaymove(mob/user, direction)
		if(user.stat || user.stunned)
			return
		if(!on)
			user << "<span class='notice'>The [name] is not on!</span>"
			return
		step(src, direction)
		update_mob()
		handle_rotation()
		return


	Move()
		..()
		if(buckled_mob)
			if(buckled_mob.buckled == src)
				buckled_mob.loc = loc
		return


	buckle_mob(mob/M, mob/user)
		if(M != user || !ismob(M) || get_dist(src, user) > 1 || user.restrained() || user.lying || user.stat || M.buckled || istype(user, /mob/living/silicon))
			return

		if(locked)
			user << "The [name] is locked!"
			return
		unbuckle()

		M.visible_message(\
			"<span class='notice'>[M] climbs onto the [name]!</span>",\
			"<span class='notice'>You climb onto the [name]!</span>")
		M.buckled = src
		M.loc = loc
		M.dir = dir
		M.update_canmove()
		buckled_mob = M
		buckled_mob.layer = 2.9
		update_mob()
		add_fingerprint(user)
		return


	unbuckle()
		if(buckled_mob)
			buckled_mob.pixel_x = 0
			buckled_mob.pixel_y = 0
			buckled_mob.layer = 3
		..()


	handle_rotation()
		if(buckled_mob)
			if(buckled_mob.loc != loc)
				buckled_mob.buckled = null //Temporary, so Move() succeeds.
				buckled_mob.buckled = src //Restoring
		update_mob()
		return


	proc/update_mob()
		if(buckled_mob)
			buckled_mob.dir = dir
			switch(dir)
				if(SOUTH)
					buckled_mob.pixel_x = 10
					buckled_mob.pixel_y = 8
				if(WEST)
					buckled_mob.pixel_x = 12
					buckled_mob.pixel_y = 8
				if(NORTH)
					buckled_mob.pixel_x = -10
					buckled_mob.pixel_y = 6
				if(EAST)
					buckled_mob.pixel_x = -12
					buckled_mob.pixel_y = 8


	bullet_act(var/obj/item/projectile/Proj)
		if(buckled_mob)
			if(prob(50))
				return buckled_mob.bullet_act(Proj)
		visible_message("<span class='warning'>[Proj] ricochets off the [name]!</span>")
		return


/obj/item/wizard_key
	name = "wizard key"
	desc = "A keyring with a small steel key."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "keys"
	w_class = 1