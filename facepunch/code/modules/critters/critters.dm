/obj/effect/critter/creature
	name = "creature"
	desc = "A sanity-destroying otherthing."
	icon_state = "otherthing"
	health = 80
	max_health = 80
	aggressive = 1
	defensive = 1
	wanderer = 1
	opensdoors = 1
	can_target = ATKCARBON | ATKSILICON | ATKSIMPLE | ATKCRITTER | ATKSAME | ATKMECH
	firevuln = 1
	brutevuln = 1
	melee_damage_lower = 25
	melee_damage_upper = 50
	angertext = "runs"
	attacktext = "chomps"
	attack_sound = 'sound/weapons/bite.ogg'


/obj/effect/critter/roach
	name = "cockroach"
	desc = "An unpleasant insect that lives in filthy places."
	icon_state = "roach"
	health = 5
	max_health = 5
	aggressive = 0
	defensive = 1
	wanderer = 1
	attacktext = "bites"

	Die()
		..()
		del(src)

/obj/effect/critter/spore
	name = "plasma spore"
	desc = "A barely intelligent colony of organisms. Very volatile."
	icon_state = "spore"
	density = 1
	health = 1
	max_health = 1
	aggressive = 0
	defensive = 0
	wanderer = 1


	Die()
		src.visible_message("<b>[src]</b> ruptures and explodes!")
		src.alive = 0
		var/turf/T = get_turf(src.loc)
		if(T)
			T.hotspot_expose(700,125)
			explosion(T, -1, -1, 2, 3, 0)
		del src


	ex_act(severity)
		src.Die()



/obj/effect/critter/blob
	name = "blob"
	desc = "Some blob thing."
	icon_state = "blob"
	pass_flags = PASSBLOB
	health = 20
	max_health = 20
	aggressive = 1
	defensive = 0
	wanderer = 1
	can_target = ATKCARBON | ATKSILICON | ATKSIMPLE | ATKCRITTER | ATKMECH
	firevuln = 2
	brutevuln = 0.5
	melee_damage_lower = 2
	melee_damage_upper = 8
	angertext = "charges"
	attacktext = "hits"
	attack_sound = 'sound/weapons/genhit1.ogg'
	var/obj/effect/blob/factory/factory = null


	New(loc, var/obj/effect/blob/factory/linked_node)
		if(istype(linked_node))
			factory = linked_node
			factory.spores += src
		..(loc)
		return


	Die()
		if(factory)
			factory.spores -= src
		..()
		del(src)



/obj/effect/critter/lizard
	name = "Lizard"
	desc = "A cute tiny lizard."
	icon_state = "lizard"
	health = 5
	max_health = 5
	aggressive = 0
	defensive = 1
	wanderer = 1
	opensdoors = 0
	attacktext = "bites"





/obj/effect/critter/alien
	name = "Queen Alien"
	desc = "Car-ful."
	icon = 'icons/mob/alienempress.dmi'
	icon_state = "empress_s"
	health = 2000
	max_health = 2000
	aggressive = 1
	wanderer = 1
	opensdoors = 1
	can_target = ATKCARBON | ATKSIMPLE | ATKCRITTER | ATKMECH
	firevuln = 0.5
	brutevuln = 1
	seekrange = 8
	damage_resistance = 5
	melee_damage_lower = 2
	melee_damage_upper = 3
	angertext = "leaps at"
	attacktext = "claws"
	team = "alien"
	var/ranged = 1
	var/rapid = 0
	var/sound = 0
	proc
		Shoot(var/target, var/start, var/user, var/bullet = 0)
		OpenFire(var/thing)//bluh ill rename this later or somethin
		Hugger()
		Weed()


	Del()
		new/obj/item/chestkey(src.loc)
		..()
	SetTarget(var/atom/target)
		target = target
		oldtarget_name = target.name
		if(ranged)

			var/C = rand(1,3)
			switch(C)
				if(1)
					OpenFire(target)
				if(2)
					Hugger()
				if(3)
					Weed()
			return 1
		task = "chasing"
		return 1

	Hugger()
		for(var/obj/effect/alien/egg/grow/D in src.loc)
			return
		var/obj/effect/alien/egg/grow/C = new/obj/effect/alien/egg/grow
		C.loc = src.loc
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <b>[src]</b> lays an alien egg!", 1)

	Weed()
		for(var/obj/effect/alien/weeds/node/D in src.loc)
			return
		var/obj/effect/alien/weeds/node/C = new/obj/effect/alien/weeds/node
		C.loc = src.loc
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <b>[src]</b> lays down some weeds!", 1)

	OpenFire(var/thing)
		src.target = thing
		src.oldtarget_name = thing:name
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <b>[src]</b> spits at [src.target]!", 1)

		var/tturf = get_turf(target)
		if(rapid)
			spawn(1)
				Shoot(tturf, src.loc, src)
			spawn(4)
				Shoot(tturf, src.loc, src)
			spawn(6)
				Shoot(tturf, src.loc, src)
		else
			Shoot(tturf, src.loc, src)

		sleep(12)
		seek_target()
		src.task = "thinking"
		return


	Shoot(var/target, var/start, var/user, var/bullet = 0)
		if(target == start)
			return

		var/obj/item/projectile/energy/neurotoxin/A = new /obj/item/projectile/energy/neurotoxin(user:loc)
		playsound(user, 'sound/weapons/hivebotgun.ogg', 100, 1)

		if(!A)	return

		if (!istype(target, /turf))
			del(A)
			return
		A.current = target
		A.yo = target:y - start:y
		A.xo = target:x - start:x
		spawn( 0 )
			A.process()
		return






/obj/effect/node
	name = "node"
	icon = 'icons/effects/effects.dmi'
	icon_state = "eggs"
	anchored = 1
	damage_resistance = -1
	explosion_resistance = -1



/obj/effect/node/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(istype(mover, /mob/living/simple_animal/hostile/giant_spider))
		return 1
	if(istype(mover, /obj/item/projectile/spidervenom))
		return 1
	else if(istype(mover, /mob/living))
		return 1
	else if(istype(mover, /obj/item/projectile))
		return prob(30)
	return 1

/obj/effect/critter/spider
	name = "Spider"
	desc = "Is it a spider?"
	icon = 'icons/mob/bosses.dmi'
	health = 2000
	max_health = 2000
	aggressive = 1
	wanderer = 0
	opensdoors = 1
	can_target = ATKCARBON | ATKCRITTER | ATKMECH	| ATKSILICON
	firevuln = 4
	brutevuln = 1
	seekrange = 8
	damage_resistance = 2
	melee_damage_lower = 2
	melee_damage_upper = 3
	angertext = "leaps at"
	attacktext = "claws"
	team = "alien"
	var/ranged = 1
	var/rapid = 1
	var/sound = 0
	var/obj/effect/node/nodes = list()
	var/obj/effect/node/C
	New()
		..()
		for(var/obj/effect/node/C in range(src, 50))
			nodes += C
	attackby(obj/item/weapon/W as obj, mob/living/user as mob)
		..()
		playsound(user, 'sound/mobs/spider/spit2.ogg', 100, 1)

	proc
		Shoot(var/target, var/start, var/user, var/bullet = 0)
		OpenFire(var/thing)
		Hugger()
		Weed()
		NodeMove()
		Spit()


	patrol_step()
		..()
		if(prob(15))
			playsound(src, 'sound/mobs/spider/chitters.ogg', 100, 1)


	Del()
		new/obj/effect/spider/acid(src.loc)
		playsound(src, 'sound/mobs/spider/spiderdie.ogg', 100, 1)
		src.visible_message("\green <b>[src]</b> melts into a puddle!", 1)
		..()
	SetTarget(var/atom/target)
		target = target
		oldtarget_name = target.name
		if(ranged)

			var/C = rand(1,4)
			switch(C)
				if(1)
					OpenFire(target)
				if(2)
					if(nodes)
						NodeMove()
					else
						OpenFire(target)
				if(3)
					Spit()
				if(4)
					if(nodes)
						NodeMove()
					else
						OpenFire(target)
			return 1
		task = "chasing"
		return 1

	Hugger()
		if(nodes)
			for(var/obj/effect/node/D in src.loc)
				new/obj/effect/spider/spiderling(src.loc)
				new/obj/effect/spider/spiderling(src.loc)
				new/obj/effect/spider/spiderling(src.loc)
				nodes -= D
				if(nodes)
					C = pick(nodes)
				del(D)
	Spit()
		for(var/turf/unsimulated/X in range(2, src))
			new/obj/effect/spider/acid(X.loc)


	OpenFire(var/thing)
		NodeMove()
		src.target = thing
		src.oldtarget_name = thing:name
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <b>[src]</b> spits at [src.target]!", 1)

		var/tturf = get_turf(target)
		if(rapid)
			spawn(1)
				Shoot(tturf, src.loc, src)
			spawn(4)
				Shoot(tturf, src.loc, src)
			spawn(6)
				Shoot(tturf, src.loc, src)
		else
			Shoot(tturf, src.loc, src)

		sleep(12)
		seek_target()
		src.task = "thinking"
		return

	NodeMove()
		if(nodes)
			if(!C)
				C = pick(nodes)
			if(C)
				Hugger()
				var/moveto = locate(C.x + rand(-1,1),C.y + rand(-1, 1),C.z)
				if (istype(moveto, /turf/simulated/floor) || istype(moveto, /turf/simulated/shuttle/floor) || istype(moveto, /turf/unsimulated/floor)) step_towards(src, moveto)
			//	if(src.aggressive) seek_target()
				steps += 1
				if (steps == rand(5,20)) src.task = "thinking"


	Shoot(var/target, var/start, var/user, var/bullet = 0)
		if(target == start)
			return

		var/obj/item/projectile/spidervenom/A = new /obj/item/projectile/spidervenom(user:loc)
		playsound(src, 'sound/mobs/spider/spit.ogg', 100, 1)

		if(!A)	return

		if (!istype(target, /turf))
			del(A)
			return
		A.current = target
		A.yo = target:y - start:y
		A.xo = target:x - start:x
		spawn( 0 )
			A.process()
		return

/obj/item/projectile/spidervenom
	force = 1
	icon_state = "toxin"

	on_hit(var/atom/target, var/blocked = 0)
		if(istype(target, /mob/living))
			new/obj/effect/spider/acid(target.loc)
		return 1

/obj/effect/spider/acid
	name = "acid puddle"
	desc = "Burbling corrossive stuff. I wouldn't want to touch it."
	icon_state = "acid"
	icon = 'icons/mob/alien.dmi'
	density = 0
	opacity = 0
	anchored = 1

	New()
		spawn(300)
			del(src)

	HasProximity(mob/living/carbon/human/C)
//		var/mob/living/carbon/human/C = Obj
		C.deal_damage(rand(2, 5), IRRADIATE, IRRADIATE)

/obj/effect/spider/pylon
	name = "Modified Pylon"
	desc = "A floating crystal that hums with an unearthly energy"
	icon_state = "pylon"
	luminosity = 5
	density = 1
	anchored = 1
	damage_resistance = -1
	explosion_resistance = -1
	icon = 'icons/obj/cult.dmi'


/obj/effect/spider/pylon/bullet_act(var/obj/item/projectile/Proj)
	if(istype(Proj ,/obj/item/projectile))
		for(var/mob/living/C in range(5, src))
			var/mob/living/D = pick(C)
			if(D)
				C << "\red The venom activates the Pylon."
				Beam(C,"n_beam",'icons/effects/beam.dmi',5, 5, 1)
				C.deal_damage(rand(5,15), BURN)
		del(Proj)
		return prob(100)
	return 1
