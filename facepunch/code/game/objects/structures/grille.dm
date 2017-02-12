/obj/structure/grille
	desc = "A flimsy lattice of metal rods, with screws to secure it to the floor."
	name = "grille"
	icon = 'icons/obj/structures.dmi'
	icon_state = "grille"
	density = 1
	anchored = 1
	flags = FPRINT | CONDUCT
	pressure_resistance = 5*ONE_ATMOSPHERE
	layer = 3.5//2.9 use to be 2.9
	explosion_resistance = 5
	health = 20
	max_health = 20
	damage_resistance = 8
	damage_sound = 'sound/effects/grillehit.ogg'
	var/destroyed = 0
	var/last_shock = 0


	Bumped(atom/user)
		if(ismob(user)) shock(user, 70)


	attack_paw(mob/user as mob)
		attack_hand(user)


	attack_hand(mob/user as mob)
		user.visible_message("<span class='warning'>[user] kicks [src].</span>", \
							 "<span class='warning'>You kick [src].</span>", \
							 "You hear twisting metal.")

		if(HULK in user.mutations)
			damage(8,0)
		else
			damage(3,0)

		shock(user, 70)
		return


	attack_alien(mob/user as mob)
		if(istype(user, /mob/living/carbon/alien/larva))	return
		user.visible_message("<span class='warning'>[user] mangles [src].</span>", \
							 "<span class='warning'>You mangle [src].</span>", \
							 "You hear twisting metal.")

		damage(5,0)
		shock(user, 70)
		return


	attack_slime(mob/user as mob)
		if(!istype(user, /mob/living/carbon/slime/adult))	return
		user.visible_message("<span class='warning'>[user] smashes against [src].</span>", \
							 "<span class='warning'>You smash against [src].</span>", \
							 "You hear twisting metal.")

		damage(3,0)
		shock(user,70)
		return


	attack_animal(var/mob/living/simple_animal/M as mob)
		if(M.melee_damage_upper == 0)	return

		M.visible_message("<span class='warning'>[M] smashes against [src].</span>", \
						  "<span class='warning'>You smash against [src].</span>", \
						  "You hear twisting metal.")

		damage(M.melee_damage_upper, 0)
		return


	CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
		if(air_group || (height==0)) return 1
		if(istype(mover) && mover.checkpass(PASSGRILLE))
			return 1

		if(density && istype(mover, /obj/item/projectile))
			return prob(30)
		return !density


	attackby(obj/item/W as obj, mob/user as mob)
		if(iswirecutter(W))
			if(!shock(user, 100))
				playsound(loc, 'sound/items/Wirecutter.ogg', 100, 1)
				damage(15,0,0)
			return

		if(isscrewdriver(W) && (istype(loc, /turf/simulated) || anchored))
			if(shock(user, 90))
				return
			playsound(loc, 'sound/items/Screwdriver.ogg', 100, 1)
			anchored = !anchored
			user.visible_message("<span class='notice'>[user] [anchored ? "fastens" : "unfastens"] the grille.</span>", \
								 "<span class='notice'>You have [anchored ? "fastened the grille to" : "unfastened the grill from"] the floor.</span>")
			return

		if(istype(W,/obj/item/stack/sheet/glass))
			user << "<span class='notice'>This glass does not appear to be strong enough.</span>"
			return

		if(istype(W,/obj/item/stack/sheet/rglass))
			if(!density)
				user << "<span class='notice'>The [src] is broken!</span>"
				return
			if(!anchored)
				user << "<span class='notice'>The [src] needs to be attached to the floor first!</span>"
				return
			if(locate(/obj/structure/window) in loc)
				user << "<span class='notice'>There is already a window there.</span>"
				return

			user << "<span class='notice'>You start placing the window.</span>"
			if(do_after(user,20))
				if(!src) return //Grille destroyed while waiting
				if(!density || !anchored) return//Grille messed with or broken while waiting

				if(locate(/obj/structure/window) in loc)//Second check to make sure
					user << "<span class='notice'>There is already a window there.</span>"
					return

				var/obj/item/stack/ST = W
				if(ST.amount < 2)
					user << "<span class='notice'>You dont have enough glass.</span>"
					return
				ST.use(2)
				var/obj/structure/window/WD = new/obj/structure/window/reinforced(loc) //reinforced window
				WD.anchored = 1
				WD.state = 0
				spawn(1)
					WD.update_nearby_icons()//Need to call this here so after we anchor it, it updates properly
				user << "<span class='notice'>You place the [WD] on [src].</span>"
			return//window placing end

		switch(W.damtype)
			if(BURN)
				damage(W.force)
			if(BRUTE)
				damage(W.force)
		if(!istype(W, /obj/item/weapon/shard))
			shock(user, 70)//Glass does not conduct
		visible_message("\red <B>[src] has been hit by [user] with [W]</B>")
		return


	update_health()
		if(!destroyed && health < 10 && health > 0)
			icon_state = "brokengrille"
			density = 0
			destroyed = 1
			new /obj/item/stack/rods(loc)
			return
		..()
		return

// shock user with probability prb (if all connections & power are working)
// returns 1 if shocked, 0 otherwise

	proc/shock(mob/user as mob, prb)
		if(last_shock > world.time)
			return 0
		last_shock = world.time + 5
		if(!anchored || destroyed)		// anchored/destroyed grilles are never connected
			return 0
		if(!prob(prb))
			return 0
		if(!in_range(src, user))//To prevent TK and mech users from getting shocked
			return 0
		var/turf/T = get_turf(src)
		var/obj/structure/cable/C = T.get_cable_node()
		if(C)
			if(electrocute_mob(user, C, src))
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(3, 1, src)
				s.start()
				return 1
			else
				return 0
		return 0


	temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
		if(!destroyed)
			if(exposed_temperature > T0C + 1500)
				damage(1)
		..()
		return