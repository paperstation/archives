/obj/effect/critter/pizza
	name = "Meat pizza"
	desc = "A living pizza."
	icon_state = "pizzularity_idle"
	chasestate = "pizzularity"
	health = 100
	max_health = 100
	aggressive = 1
	defensive = 1
	wanderer = 1
	opensdoors = 1
	can_target = ATKCARBON | ATKSILICON | ATKSIMPLE | ATKCRITTER | ATKSAME | ATKMECH
	firevuln = 1
	brutevuln = 1
	melee_damage_lower = 0
	melee_damage_upper = 0
	angertext = "looks"
	attacktext = "chomps"
	deathtext = "collapses"
	attack_sound = 'sound/effects/phasein.ogg'
	var/pizza_type = "/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/meatpizza"
	var/power = 0//How many things it has eaten


	AfterAttack(var/target)
		if(istype(target,/obj/effect/critter/pizza))
			var/obj/effect/critter/pizza/pizza = target
			power += pizza.power + 5//Merge them
			damage_resistance += pizza.damage_resistance
			pizza.Die()
			return
		frustration = max_frustration//Guy will have moved away so it will revert to chasing and this will tell it to seek a new target.
		var/list/turfs = list()
		for(var/turf/T in orange(10))
			if(T.x>world.maxx-8 || T.x<8)	continue
			if(T.y>world.maxy-8 || T.y<8)	continue
			turfs += T
		if(!turfs.len)
			return
		power++
		do_teleport(target, pick(turfs), 1)

		if(power >= 10)
			power -=10
			damage_resistance++
			health = min(max_health, health + 10)
		return


	Bumped(M as mob|obj)
		AfterAttack(M)
		return


	Die()
		src.visible_message("<b>[src]</b> [deathtext]")
		if(pizza_type)
			new pizza_type(src.loc)
		del(src)
		return