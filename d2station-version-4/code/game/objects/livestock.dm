//Blatently copy/pasted from facehugger code + a few changes.

/obj/livestock
	name = "animal thing"
	desc = "This doesn't seem so bad..."
	icon = 'livestock.dmi'
	layer = 5.0
	density = 1
	anchored = 0
	unacidable = 1//While not technically mobs, these objects should not be affected by alien acid.

	var/state = 0		//0 = null, 1 = attack, 2 = idle

	var/list/path = new/list()

	var/frustration = 0						//How long it's gone without reaching it's target.
	var/patience = 35						//The maximum time it'll chase a target.
	var/mob/living/carbon/target			//Its combat target.
	var/list/mob/living/carbon/flee_from = new/list()
	var/list/path_target = new/list()		//The path to the combat target.

	var/turf/trg_idle					//It's idle target, the one it's following but not attacking.
	var/list/path_idle = new/list()		//The path to the idle target.

	var/alive = 1 //1 alive, 0 dead
	var/maxhealth = 25
	var/health = 25
	var/aggressive = 0
	var/cowardly = 0 //PLEASE do not mix with agressive, I have no idea what its behaviour will be then
	flags = 258.0
	var/strength = 10 //The damage done by the creature if it attacks something.
	var/cycle_pause = 5
	var/view_range = 7				//How far it can see.
	var/obj/item/weapon/card/id/anicard		//By default, animals can open doors but not any with access restrictions.
	var/intelligence = null					// the intelligence var allows for additional access (by job).

	var/species = "animal" //affects icon_state

	New()			//Initializes the livestock's AI and access
		..()
		anicard = new(src)
		if(!isnull(src.intelligence))
			anicard.access = get_access(intelligence)
		else
			anicard.access = null
		src.process()

	examine()
		set src in view()
		..()
		if(!alive)
			usr << text("\red <B>The animal is not moving</B>")
		else if (src.health == src.health)
			usr << text("\red <B>The animal looks healthy.</B>")
		else
			usr << text("\red <B>The animal looks beat up</B>")
		if (aggressive && alive)
			usr << text("\red <B>Looks fierce!</B>")
		return

	proc/gib()			//Will move this to a generic livestock proc once I get some gib animations for the others -- Darem.
		var/atom/movable/overlay/animation = null
		src.icon = null
		src.invisibility = 101
		animation = new(src.loc)
		animation.icon = 'livestock.dmi'
		animation.icon_state = "blank"
		animation.master = src
		if(istype(src, /obj/livestock/spesscarp)) flick("spesscarp_g", animation)
		sleep(11)
		src.death(1)
		del(animation)
		return


	attack_hand(user as mob)
		return

	attack_alien(var/mob/living/carbon/alien/user as mob) //So aliums can attack and potentially eat space carp.
		if(src.alive)
			if (user.a_intent == "help")
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("\blue [user] caresses [src.name] with its scythe like arm."), 1)
			else
				src.health -= rand(15,30)
				if(src.aggressive)
					src.target = user
					src.state = 1
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("\red <B>[] has slashed [src.name]!</B>", user), 1)
				playsound(src.loc, 'slice.ogg', 25, 1, -1)
				if(prob(10)) new /obj/decal/cleanable/blood(src.loc)
				if (src.health <= 0)
					src.death()
		else
			if (user.a_intent == "grab")
				for(var/mob/N in viewers(user, null))
					if(N.client)
						N.show_message(text("\red <B>[user] is attempting to devour the carp!</B>"), 1)
				if(!do_after(user, 50))	return
				for(var/mob/N in viewers(user, null))
					if(N.client)
						N.show_message(text("\red <B>[user] hungrily devours the carp!</B>"), 1)
				user.health += rand(10,25)
				del(src)
			else
				user << "\green The creature is already dead."
		return

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(src.alive)
			switch(W.damtype)
				if("fire")
					src.health -= W.force * 0.75
				if("brute")
					src.health -= W.force * 0.5
				else
			if (src.health <= 0)
				src.death()
			else if (W.force)
				if(src.aggressive && (ishuman(user) || ismonkey(user) || isrobot(user)))
					src.target = user
					src.state = 1
				if(prob(10)) new /obj/decal/cleanable/blood(src.loc)
		else if(istype(W, /obj/item/weapon/kitchenknife))
			user << "\red You slice open the [src.name]!"
			for (var/obj/item/I in src)
				I.loc = src.loc
			del(src)
			return
		..()

	bullet_act(var/obj/item/projectile/Proj)
		health -= Proj.damage
		if(istype(Proj, /obj/item/projectile/beam/pulse))
			if(prob(30))
				gib()
		if(prob(10)) new /obj/decal/cleanable/blood(src.loc)
		healthcheck()

	ex_act(severity)
		switch(severity)
			if(1.0)
				src.death(1)
			if(2.0)
				src.health -= 15
				healthcheck()
		return

	meteorhit()
		src.gib()
		return

	blob_act()
		if(prob(50))
			src.death()
		return

	Bumped(AM as mob|obj)
		if(ismob(AM) && src.aggressive && (ishuman(AM) || ismonkey(AM)) )
			src.target = AM
			set_attack()
		else if(ismob(AM))
			spawn(0)
				var/turf/T = get_turf(src)
				AM:loc = T

	Bump(atom/A)
		if(ismob(A) && src.aggressive && (ishuman(A) || ismonkey(A)))
			src.target = A
			set_attack()
		else if(ismob(A))
			src.loc = A:loc
		..()

	temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
		if(exposed_temperature > 300)
			health -= 5
			healthcheck()

	proc/set_attack()
		state = 1
		if(path_idle.len) path_idle = new/list()
		trg_idle = null

	proc/set_idle()
		state = 2
		if (path_target.len) path_target = new/list()
		target = null
		frustration = 0

	proc/set_null()
		state = 0
		if (path_target.len) path_target = new/list()
		if (path_idle.len) path_idle = new/list()
		target = null
		trg_idle = null
		frustration = 0

	proc/special_extra()	//Placeholder for animal specific effects such as cow milk or spess carp breathing.

	proc/special_attack()	//Placeholder for extra effects from the attack such as the carp's stun.

	proc/special_target()	//Placeholder for extra targeting protocol

	proc/random_movement()						//Unlike pick(cardinal), it has a bias towards continuing on in it's
		var/temp_move = null					//	original direction.
		switch(roll(1,20))  //50% => Foreward, 20% turn left, 20% turn right, 10% don't move.
			if(1 to 10)
				temp_move = src.dir
			if(11 to 14)
				temp_move = turn(src.dir, -90)
			if(15 to 18)
				temp_move = turn(src.dir, 90)
		if(!isnull(temp_move))
			step(src,temp_move)

	proc/process()				//Master AI proc.
		set background = 1
		if (!alive)				//If it isn't alive, it shouldn't be doing anything.
			return
		if (cowardly) //cowardly = 1 stuff
			var/view = view_range-2							//Actual sight slightly lower then it's total sight.
			for (var/mob/living/carbon/C in range(view,src.loc)) //checking for threats
				if (((get_dir(src,C) & dir) || (C.m_intent=="run" && C.moved_recently)) && !(C in flee_from)) //if it can see or hear anyone nearby, start fleeing
					flee_from += C
			if (flee_from.len) //ohgodrun
				var/viable_dirs = 0
				for(var/mob/living/carbon/C in flee_from)
					if(!(C in view(src,view_range))) //first, see if someone who it has been fleeing from is still there. if not, delete that guy from the list
						flee_from -= C
					else
						viable_dirs |= get_dir(src,C)
				viable_dirs = 15 - viable_dirs //so it runs AWAY from those directions, not TOWARDS them
				if(viable_dirs) //if there is somewhere to run, DO IT DAMNIT
					var/list/turfs_to_move_to = new/list()
					for(var/turf/T in orange(src,1))
						if(((get_dir(src,T) & viable_dirs) == get_dir(src,T)) && !T.density)
							turfs_to_move_to += T
					src.Move(pick(turfs_to_move_to))
		if (aggressive) //aggressive = 1 stuff
			if (!target)
				if (path_target.len) path_target = new/list()	//No target but there's still path data? reset it.
				var/last_health = INFINITY						//Set as high as possible as an initial value.
				var/view = view_range-2							//Actual sight slightly lower then it's total sight.
				for (var/mob/living/carbon/C in range(view,src.loc))	//Checks all carbon creatures in range.
					if (!aggressive)									//Is this animal angry? If not, what the fuck are you doing?
						break
					if (C.stat == 2 || !can_see(src,C,view_range) || (!can_see(src,C,(view_range / 2)) && C.invisibility >= 1))
						continue
					if(C:stunned || C:paralysis || C:weakened)
						target = C
						break
					if(C:health < last_health)				//Selects the target but does NOT break the FOR loop.
						last_health = C:health				//	As such, it'll keep going until it finds the one with the
						target = C							//	lowest health.
				if(target)			//Does it have a target NOW?
					if (aggressive)	//Double checking if it is aggressive or not.
						set_attack()
				else if(state != 2)	//If it doesn't have a target and it isn't idling already, idle.
					set_idle()
					idle()
			else if(target)		//It already has a target? YAY!
				var/turf/distance = get_dist(src, target)
				if (src.aggressive)  //I probably don't need this check, but just in case.
					set_attack()
				else
					set_idle()
					idle()
				if(can_see(src,target,view_range ))	//Can I see it?
					if(distance <= 1)  				//Am I close enough to attack it?
						for(var/mob/O in viewers(world.view,src))
							O.show_message("\red <B>[src.target] has been attacked by [src.name]!</B>", 1, "\red You hear someone fall.", 2)
						target.take_organ_damage(strength)
						special_attack()
						src.loc = target.loc
						set_null()
					step_towards(src,get_step_towards2(src , target)) // Move towards the target.
				else
					if( !path_target.len )		//Don't have a path yet but do have a target?
						path_attack(target)			//Find a path!
						if(!path_target.len)		//Still no path?
							set_null()				//Fuck this shit.
					if( path_target.len )						 //Ok, I DO have a path
						var/turf/next = path_target[1] //Select the next square to move to.
						if(next in range(1,src))		//Is it next to it?
							path_attack(target)			//Re-find path.
						if(!path_target.len)			//If can't path to the target, it gets really angry.
							src.frustration += 5
						else
							next = path_target[1]		//If it CAN path to the target, select the next move point
							path_target -= next
							step_towards(src,next)		//And move in that direction.
				if (get_dist(src, src.target) >= distance) src.frustration++ //If it hasn't reached the target yet, get a little angry.
				else src.frustration--			//It reached the target! Get less angry.
				if(frustration >= patience) set_null()		//If too angry? Fuck this shit.
		special_extra()
		if(target || flee_from.len)
			spawn(cycle_pause / 3)
				src.process()
		else
			spawn(cycle_pause)
				src.process()

	proc/idle()					//Idle proc for when it isn't in combat mode. Called by itself and process()
		set background = 1
		if(state != 2 || !alive || target) return  //If you arne't idling, aren't alive, or have a target, you shouldn't be here.
		if(prob(5) && health < maxhealth)			//5% chance of healing every cycle.
			health++
		special_extra()
		if(isnull(trg_idle))						//No one to follow? Find one.
			for(var/mob/living/O in viewers(world.view,src))
				if(O.mutations == (0 || CLOWN))		//Hates mutants and fatties.
					trg_idle = O
					break
		if(isnull(trg_idle))						//Still no one to follow? Step in a random direction.
			random_movement()
		else if(!path_idle.len)						//Has a target but no path?
			if(can_see(src,trg_idle,view_range))	//Can see it? Then move towards it.
				step_towards(src,get_step_towards2(src , trg_idle))
			else
				path_idle(trg_idle)		//Can't see it? Find a path.
				if(!path_idle.len)		//Still no path? Stop trying to follow it.
					trg_idle = null
				random_movement()
		else
			if(can_see(src,trg_idle,view_range))	//Has a path and can see the target?
				if(get_dist(src, trg_idle) >= 2)		//If 2 or more squares away, re-find path and move towards it.
					step_towards(src,get_step_towards2(src , trg_idle))
					if(path_idle.len) path_idle = new/list()
			else
				var/turf/next = path_idle[1]		//Has a target and a path but can't see it?
				if(!next in range(1,src))			//If end of path and not next to target, find new path.
					path_idle(trg_idle)

				if(path_idle.len)					//If still some path left, move along path.
					next = path_idle[1]
					path_idle -= next
					step_towards(src,next)
		spawn(cycle_pause)
			idle()

	proc/path_idle(var/atom/trg)
		path_idle = AStar(src.loc, get_turf(trg), /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 250, anicard, null)
		path_idle = reverselist(path_idle)

	proc/path_attack(var/atom/trg)
		path_target = AStar(src.loc, trg.loc, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 250, anicard, null)
		path_target = reverselist(path_target)

	proc/death(var/messy = 0)
		if(!alive) return
		alive = 0
		density = 0
		icon_state = "[species]_d"
		set_null()
		if(!messy)
			for(var/mob/O in hearers(src, null))
				O.show_message("\red <B>[src]'s eyes glass over!</B>", 1)
		else
			for (var/obj/item/I in src)
				if(!istype(I, /obj/item/weapon/card)) I.loc = src.loc
			del(src)

	proc/healthcheck()
		if (src.health <= 0)
			src.death()


//////////////////////////////////////////////////////////////////////////////
/////////////////////////Specific Creature Entries////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/*/obj/livestock/chick
	name = "Chick"
	desc = "A harmless little baby chicken, it's so cute!"
	icon_state = "chick"
	health = 10
	maxhealth = 10
	strength = 5
	cycle_pause = 15
	patience = 25
	var/obj/item/weapon/reagent_containers/food/snacks/egg_holder
	special_extra()
		if(prob(5))
			for(var/mob/O in hearers(src, null))
				O << "\green Chick: Cluck."
			src.egg_holder = new /obj/item/weapon/reagent_containers/food/snacks/egg(src)
			src.egg_holder.loc = src.loc
			src.egg_holder = null
		for(var/mob/living/carbon/human/V in viewers(world.view,src))
			if(V.mind.special_role == "wizard")
				for(var/mob/H in hearers(src, null))
					H << "\green Chick clucks in an angry manner at [V.name]."
*/
/obj/livestock/spessbee
	name = "Space Bee"
	desc = "Oh fuck, a space bee."
	icon_state = "normalbee"
	flags = FPRINT | TABLEPASS | OPENCONTAINER
	aggressive = 1
	health = 2
	density = 0
	maxhealth = 5
	strength = 1
	cycle_pause = 15
	patience = 20
	view_range = 10
	var/sting_chance = 20
	species = "normalbee"
	special_attack()
		if (prob(sting_chance))
			target.show_message("\red <B>[src] has stung you!</B>")
			aggressive = 0
			sting_chance = 0
			cowardly = 1

			var/datum/reagents/R = new/datum/reagents(5)
			reagents = R
			R.my_atom = src
			R.add_reagent("apitoxin", 15)
			reagents.trans_to(target, rand(5,15))
			sleep(20)
			src.death()

/obj/livestock/spessbee/infectious
	name = "Space Bee"
	desc = "Oh fuck, a space bee."
	icon_state = "infectedbee"
	flags = FPRINT | TABLEPASS | OPENCONTAINER
	aggressive = 1
	health = 2
	density = 0
	maxhealth = 5
	strength = 1
	cycle_pause = 3
	patience = 5
	view_range = 15
	sting_chance = 50
	species = "infectedbee"
	intelligence = "Captain"
	special_attack()
		if (prob(sting_chance))
			target.show_message("\red <B>[src] has stung you!</B>")
			aggressive = 0
			sting_chance = 0
			cowardly = 1

			target:contract_disease(new /datum/disease/beesease,1)
			var/datum/reagents/R = new/datum/reagents(5)
			reagents = R
			R.my_atom = src
			R.add_reagent("apitoxin", 15)
			reagents.trans_to(target, rand(5,15))
			sleep(20)
			src.death()

/obj/livestock/spessbee/butt
	name = "Space Bee"
	desc = "Oh fuck, a space bee."
	icon_state = "buttbee"
	flags = FPRINT | TABLEPASS | OPENCONTAINER
	aggressive = 1
	health = 2
	density = 0
	maxhealth = 5
	strength = 1
	cycle_pause = 3
	patience = 5
	view_range = 15
	sting_chance = 50
	species = "infectedbee"
	intelligence = "Captain"
	special_attack()
		if (prob(sting_chance))
			target.show_message("\red <B>[src] has stung you!</B>")
			aggressive = 0
			sting_chance = 0
			cowardly = 1

			target:contract_disease(new /datum/disease/buttease,1)
			var/datum/reagents/R = new/datum/reagents(5)
			reagents = R
			R.my_atom = src
			R.add_reagent("apitoxin", 15)
			reagents.trans_to(target, rand(5,15))
			sleep(10)
			src.death()

/obj/livestock/spaceroach
	name = "Space Roach"
	desc = "A cockroach, usually lives in dirty, smelly places, such as the Atmos."
	icon_state = "spaceroach"
	aggressive = 0
	health = 5
	maxhealth = 5
	strength = 1
	cycle_pause = 10
	patience = 40
	view_range = 4

/obj/livestock/baby
	name = "Baby"
	desc = "Oh shit."
	icon_state = "baby1"
	species = "baby1"
	var/babygender
	aggressive = 0
	cowardly = 1
	health = 10
	maxhealth = 10
	strength = 1
	cycle_pause = 10
	patience = 40
	view_range = 4
	var/growup = 1000
	var/mob/dead/observer/G = null
	New()
		..()
		new /obj/item/weapon/reagent_containers/food/snacks/meat/monkey(src)
	process()
		..()
		spawn(growup)
			var/list/candidates = list() // Picks a random ghost in the world to shove in the larva -- TLE
			for(var/mob/dead/observer/G in mobz)
				if(G.client)
					if(((G.client.inactivity/10)/60) <= 5)
						if(G.corpse) //hopefully will make adminaliums possible --Urist
							if(G.corpse.stat==2)
								candidates.Add(G)
						if(!G.corpse) //hopefully will make adminaliums possible --Urist
							candidates.Add(G)
			if(candidates.len)
				var/mob/living/carbon/human/new_kid = new(src.loc)
				for(var/mob/dead/observer/A in candidates)
					G = pick(candidates)
				//new_kid.mind_initialize(G)
				new_kid.dna = new /datum/dna(null)
				//updateappearance(new_kid, new_kid.dna.uni_identity)
				//domutcheck(new_kid)
				if(src.babygender == "boy")
					new_kid.gender = "male"
					new_kid.h_style = pick("bald", "hair_a", "hair_c", "hair_d", "hair_e", "hair_f", "hair_bedhead", "hair_rocker", "hair_femalemessy", "hair_dreads", "hair_scene", "hair_messym", "hair_messyf")
					new_kid.hair_icon_state = pick("bald", "hair_a", "hair_c", "hair_d", "hair_e", "hair_f", "hair_bedhead", "hair_rocker", "hair_femalemessy", "hair_dreads", "hair_scene", "hair_messym", "hair_messyf")
				else if(src.babygender == "girl")
					new_kid.gender = "female"
					new_kid.h_style = pick("hair_b", "hair_long", "hair_pony", "hair_femalemessy", "hair_scene", "hair_girly", "hair_messym", "hair_messyf")
					new_kid.hair_icon_state = pick("hair_b", "hair_long", "hair_pony", "hair_femalemessy", "hair_scene", "hair_girly", "hair_messym", "hair_messyf")
				new_kid.key = G.key
				new_kid.real_name = src.name
				new_kid.name = src.name
				del(src)
		if (prob(1))
			for(var/mob/O in viewers(src, null))
				O.show_message("<B>[src.name]</B> poos on the floor!", 1)
			playsound(src.loc, 'fart.ogg', 60, 1)
			playsound(src.loc, 'squishy.ogg', 40, 1)
			var/turf/location = src.loc

			new /obj/decal/cleanable/poo(location) //Places a stain of shit on the floor
			new /obj/item/weapon/reagent_containers/food/snacks/poo(location) //Spawns a turd
		if (prob(1))
			for(var/mob/O in viewers(src, null))
				O.show_message("<B>[src.name]</B> cries!", 1)
		if (prob(1))
			for(var/mob/O in viewers(src, null))
				O.show_message("<B>[src.name]</B> whines!", 1)

/obj/livestock/baby/instant
	growup = 10

/obj/livestock/baby/New()
	src.babygender = pick("boy", "girl")
	if(src.babygender == "boy")
		src.name = capitalize(pick(first_names_male) + " " + pick(last_names))
	else if(src.babygender == "girl")
		src.name = capitalize(pick(first_names_female) + " " + pick(last_names))
	..()

/obj/livestock/spesscarp
	name = "Spess Carp"
	desc = "Oh shit, you're really fucked now."
	icon_state = "spesscarp"
	species = "spesscarp"
	aggressive = 1
	health = 25
	maxhealth = 25
	strength = 10
	cycle_pause = 10
	patience = 25
	view_range = 8
	var/stun_chance = 5					// determines the prob of a stun
	New()
		..()
		new /obj/item/weapon/reagent_containers/food/snacks/carpmeat(src)
		new /obj/item/weapon/reagent_containers/food/snacks/carpmeat(src)
		new /obj/item/weapon/reagent_containers/food/snacks/carpmeat(src)
	special_attack()
		if (prob(stun_chance))
			target:stunned = max(target:stunned, (strength / 2))

/obj/livestock/spesscarp/elite
	desc = "Oh shit, you're really fucked now. It has an evil gleam in it's eye."
	health = 50
	maxhealth = 50
	view_range = 14
	stun_chance = 40
	intelligence = "Assistant"

/obj/livestock/killertomato
	name = "Killer Tomato"
	desc = "Oh shit, you're really fucked now."
	icon_state = "killertomato"
	species = "killertomato"
	aggressive = 1
	cowardly = 0
	health = 75
	maxhealth = 75
	cycle_pause = 10
	patience = 10
	view_range = 14
	intelligence = "Captain"
	var/stun_chance = 10					// determines the prob of a stun
	New()
		..()
		new /obj/item/weapon/reagent_containers/food/snacks/tomatomeat(src)
		new /obj/item/weapon/reagent_containers/food/snacks/tomatomeat(src)
		new /obj/item/weapon/reagent_containers/food/snacks/tomatomeat(src)

/obj/livestock/walkingmushroom
	name = "Walking Mushroom"
	desc = "A...huge...mushroom...with legs!?"
	icon_state = "walkingmushroom"
	species = "walkingmushroom"
	cowardly = 1
	health = 50
	maxhealth = 50
	strength = 0
	cycle_pause = 10
	patience = 25
	view_range = 8
	intelligence = "Captain"
	var/stun_chance = 0
	New()
		..()
		new /obj/item/weapon/reagent_containers/food/snacks/hugemushroomslice(src)
		new /obj/item/weapon/reagent_containers/food/snacks/hugemushroomslice(src)
		new /obj/item/weapon/reagent_containers/food/snacks/hugemushroomslice(src)

/obj/livestock/lizard
	name = "Lizard"
	desc = "A cute tiny lizard."
	icon_state = "lizard"
	species = "lizard"
	cowardly = 1
	health = 10
	maxhealth = 10
	strength = 2
	cycle_pause = 10
	patience = 50
	view_range = 7

/obj/livestock/remy
	name = "Remy"
	desc = ""
	icon_state = "remy"
	species = "remy"
	density = 0
	cowardly = 1
	health = 100
	maxhealth = 100
	strength = 2
	cycle_pause = 30
	patience = 50
	view_range = 7

/obj/livestock/cat1
	name = "Michael Catson"
	icon_state = "cat1"
	species = "cat1"
	density = 0
	cowardly = 1
	health = 100
	maxhealth = 100
	strength = 2
	cycle_pause = 30
	patience = 50
	view_range = 7

/obj/livestock/cat2
	name = "Melons"
	icon_state = "cat2"
	species = "cat2"
	density = 0
	cowardly = 1
	health = 100
	maxhealth = 100
	strength = 2
	cycle_pause = 30
	patience = 50
	view_range = 7


/obj/livestock/roach
	name = "Roach"
	desc = "A cute large roach."
	icon_state = "roach"
	species = "roach"
	aggressive = 1
	health = 15
	maxhealth = 15
	strength = 2
	cycle_pause = 10
	patience = 50
	view_range = 7

/obj/livestock/bear
	name = "ninja space bear"
	desc = "Its sight is unbearable to your eye."
	icon_state = "bear"
	species = "bear"
	aggressive = 1
	health = 100
	maxhealth = 100
	cycle_pause = 15
	patience = 75
	strength = 30
	intelligence = "Captain"

	var/adaptationChance = 10 //the chance per tick the bear will change its camouflage
	var/camouflage = "space" //"", "space" or "floor"

	New()
		..()
		//new /obj/item/clothing/suit/bearpelt(src)
		new /obj/item/weapon/reagent_containers/food/snacks/bearmeat(src)
		new /obj/item/weapon/reagent_containers/food/snacks/bearmeat(src)
		new /obj/item/weapon/reagent_containers/food/snacks/bearmeat(src)
		new /obj/item/weapon/reagent_containers/food/snacks/bearmeat(src)
		new /obj/item/weapon/reagent_containers/food/snacks/bearmeat(src)
		//new /obj/item/weapon/reagent_containers/food/snacks/bearinnards(src)

	special_extra() //camouflage check
		if(prob(adaptationChance))
			if(istype(loc,/turf/simulated/floor))
				if(camouflage != "floor")
					camouflage = "floor"
			else if(istype(loc,/turf/space))
				if(camouflage != "space")
					camouflage = "space"
			else if(camouflage != "")
				camouflage = ""
		update_icon()

	update_icon()
		icon_state = "[species][camouflage][alive?"":"_d"]"

/* 		Commented out because of Filthy Xeno-lovers.
/obj/livestock/cow
	name = "Pigmy Cow"
	desc = "That's not my cow!"
	icon_state = "cow"
	health = 100
	maxhealth = 100
	strength = 20
	cycle_pause = 20
	patience = 50
	view_range = 10
	New()
		..()
		new /obj/item/weapon/reagent_containers/food/snacks/monkeymeat(src)
		new /obj/item/weapon/reagent_containers/food/snacks/monkeymeat(src)
		new /obj/item/weapon/reagent_containers/food/snacks/monkeymeat(src)
	special_extra()
		if(prob(20))
			for(var/mob/O in hearers(src, null))
				O << "\green Cow: Moo."
			src.reagents.add_reagent("milk", 1)
		if(src.reagents.get_reagent_amount("milk") >= 100)
			gib()

	examine()
		..()
		switch(src.reagents.get_reagent_amount("milk"))
			if(0 to 10)
				usr << text("\red The cow looks content.")
			if(11 to 80)
				usr << text("\red The cow looks uncomfortable.")
			if(81 to INFINITY)
				usr << text("\red The cow looks as if it could burst at any minute!")
			*/

// p much straight up copied from secbot code =I



/////critters innit/////



/obj/critter/
	name = "critter"
	desc = "you shouldnt be able to see this"
	icon = 'critter.dmi'
	layer = 5.0
	density = 1
	anchored = 0
	var/alive = 1
	var/health = 10
	var/task = "thinking"
	var/aggressive = 0
	var/defensive = 0
	var/wanderer = 1
	var/opensdoors = 0
	var/frustration = 0
	var/last_found = null
	var/target = null
	var/oldtarget_name = null
	var/target_lastloc = null
	var/atkcarbon = 0
	var/atksilicon = 0
	var/atcritter = 0
	var/attack = 0
	var/attacking = 0
	var/steps = 0
	var/firevuln = 1
	var/brutevuln = 1
	var/seekrange = 7 // how many tiles away it will look for a target
	var/friend = null // used for tracking hydro-grown monsters's creator
	var/attacker = null // used for defensive tracking
	var/angertext = "charges at" // comes between critter name and target name

	attackby(obj/item/weapon/W as obj, mob/living/user as mob)
		..()
		if (!src.alive)
			..()
			return
		switch(W.damtype)
			if("fire")
				src.health -= W.force * src.firevuln
			if("brute")
				src.health -= W.force * src.brutevuln
			else
		if (src.alive && src.health <= 0) src.CritterDeath()
		if (src.defensive)
			src.target = user
			src.oldtarget_name = user.name
			for(var/mob/O in viewers(src, null))
				O.show_message("\red <b>[src]</b> [src.angertext] [user.name]!", 1)
			src.task = "chasing"

	attack_hand(var/mob/user as mob)
		..()
		if (!src.alive)
			..()
			return
		if (user.a_intent == "hurt")
			src.health -= rand(1,2) * src.brutevuln
			for(var/mob/O in viewers(src, null))
				O.show_message("\red <b>[user]</b> punches [src]!", 1)
			playsound(src.loc, "punch", 50, 1)
			if (src.alive && src.health <= 0) src.CritterDeath()
			if (src.defensive)
				src.target = user
				src.oldtarget_name = user.name
				for(var/mob/O in viewers(src, null))
					O.show_message("\red <b>[src]</b> [src.angertext] [user.name]!", 1)
				src.task = "chasing"
		else
			for(var/mob/O in viewers(src, null))
				O.show_message("\red <b>[user]</b> pets [src]!", 1)

	proc/patrol_step()
		var/moveto = locate(src.x + rand(-1,1),src.y + rand(-1, 1),src.z)
		if (istype(moveto, /turf/simulated/floor) || istype(moveto, /turf/simulated/shuttle/floor) || istype(moveto, /turf/unsimulated/floor)) step_towards(src, moveto)
		if(src.aggressive) seek_target()
		steps += 1
		if (steps == rand(5,20)) src.task = "thinking"

	Bump(M as mob|obj)
		spawn(0)
			if ((istype(M, /obj/machinery/door)))
				var/obj/machinery/door/D = M
				if (src.opensdoors)
					D.open()
					src.frustration = 0
				else src.frustration ++
			else if ((istype(M, /mob/living/)) && (!src.anchored))
				src.loc = M:loc
				src.frustration = 0
			return
		return

	Bumped(M as mob|obj)
		spawn(0)
			var/turf/T = get_turf(src)
			M:loc = T

/*	Strumpetplaya - Not supported
	bullet_act(var/datum/projectile/P)
		var/damage = 0
		damage = round((P.power*P.ks_ratio), 1.0)

		if((P.damage_type == D_KINETIC)||(P.damage_type == D_PIERCING)||(P.damage_type == D_SLASHING))
			src.health -= (damage*brutevuln)
		else if(P.damage_type == D_ENERGY)
			src.health -= damage
		else if(P.damage_type == D_BURNING)
			src.health -= (damage*firevuln)
		else if(P.damage_type == D_RADIOACTIVE)
			src.health -= 1
		else if(P.damage_type == D_TOXIC)
			src.health -= 1

		if (src.health <= 0)
			src.CritterDeath()
*/
	ex_act(severity)
		switch(severity)
			if(1.0)
				src.CritterDeath()
				return
			if(2.0)
				src.health -= 15
				if (src.health <= 0)
					src.CritterDeath()
				return
			else
				src.health -= 5
				if (src.health <= 0)
					src.CritterDeath()
				return
		return

	meteorhit()
		src.CritterDeath()
		return

	proc/check_health()
		if (src.health <= 0)
			src.CritterDeath()

	blob_act()
		if(prob(25))
			src.CritterDeath()
		return

	proc/process()
		set background = 1
		if (!src.alive) return
		check_health()
		switch(task)
			if("thinking")
				src.attack = 0
				src.target = null
				sleep(15)
				walk_to(src,0)
				if (src.aggressive) seek_target()
				if (src.wanderer && !src.target) src.task = "wandering"
			if("chasing")
				if (src.frustration >= 8)
					src.target = null
					src.last_found = world.time
					src.frustration = 0
					src.task = "thinking"
					walk_to(src,0)
				if (target)
					if (get_dist(src, src.target) <= 1)
						var/mob/living/carbon/M = src.target
						ChaseAttack(M)
						src.task = "attacking"
						src.anchored = 1
						src.target_lastloc = M.loc
					else
						var/turf/olddist = get_dist(src, src.target)
						walk_to(src, src.target,1,4)
						if ((get_dist(src, src.target)) >= (olddist))
							src.frustration++
						else
							src.frustration = 0
						sleep(5)
				else src.task = "thinking"
			if("attacking")
				// see if he got away
				if ((get_dist(src, src.target) > 1) || ((src.target:loc != src.target_lastloc)))
					src.anchored = 0
					src.task = "chasing"
				else
					if (get_dist(src, src.target) <= 1)
						var/mob/living/carbon/M = src.target
						if (!src.attacking) CritterAttack(src.target)
						if (!src.aggressive)
							src.task = "thinking"
							src.target = null
							src.anchored = 0
							src.last_found = world.time
							src.frustration = 0
							src.attacking = 0
						else
							if(M!=null)
								if (M.health < 0)
									src.task = "thinking"
									src.target = null
									src.anchored = 0
									src.last_found = world.time
									src.frustration = 0
									src.attacking = 0
					else
						src.anchored = 0
						src.attacking = 0
						src.task = "chasing"
			if("wandering")
				patrol_step()
				sleep(10)
		spawn(8)
			process()
		return


	New()
		spawn(0) process()
		..()

/obj/critter/proc/seek_target()
	src.anchored = 0
	for (var/mob/living/C in view(src.seekrange,src))
		if (src.target)
			src.task = "chasing"
			break
		if ((C.name == src.oldtarget_name) && (world.time < src.last_found + 100)) continue
		if (istype(C, /mob/living/carbon/) && !src.atkcarbon) continue
		if (istype(C, /mob/living/silicon/) && !src.atksilicon) continue
		if (C.health < 0) continue
		if (C.name == src.friend) continue
		if (C.name == src.attacker) src.attack = 1
		if (istype(C, /mob/living/carbon/) && src.atkcarbon) src.attack = 1
		if (istype(C, /mob/living/silicon/) && src.atksilicon) src.attack = 1

		if (src.attack)
			src.target = C
			src.oldtarget_name = C.name
			for(var/mob/O in viewers(src, null))
				O.show_message("\red <b>[src]</b> [src.angertext] [C.name]!", 1)
			src.task = "chasing"
			break
		else
			continue




/obj/critter/proc/CritterDeath()
	if (!src.alive) return
	src.icon_state += "-dead"
	src.alive = 0
	src.anchored = 0
	src.density = 0
	walk_to(src,0)
	src.visible_message("<b>[src]</b> dies!")

/obj/critter/proc/ChaseAttack(mob/M)
	for(var/mob/O in viewers(src, null))
		O.show_message("\red <B>[src]</B> leaps at [src.target]!", 1)
	//playsound(src.loc, 'genhit1.ogg', 50, 1, -1)

/obj/critter/proc/CritterAttack(mob/M)
	src.attacking = 1
	for(var/mob/O in viewers(src, null))
		O.show_message("\red <B>[src]</B> bites [src.target]!", 1)
	src.target:bruteloss += 1
	spawn(25)
		src.attacking = 0

/obj/critter/proc/CritterTeleport(var/telerange, var/dospark, var/dosmoke)
	if (!src.alive) return
	var/list/randomturfs = new/list()
	for(var/turf/T in orange(src, telerange))
		if(istype(T, /turf/space) || T.density) continue
		randomturfs.Add(T)
	src.loc = pick(randomturfs)
	if (dospark)
		var/datum/effects/system/spark_spread/s = new /datum/effects/system/spark_spread
		s.set_up(5, 1, src)
		s.start()
	if (dosmoke)
		var/datum/effects/system/harmless_smoke_spread/smoke = new /datum/effects/system/harmless_smoke_spread()
		smoke.set_up(3, 0, src.loc)
		smoke.start()
	src.task = "thinking"

/*
/obj/critter/horror
	name = "The Dark"
	desc = "The Darkness."
	icon_state = "horrormovie"
	density = 0
	health = 175
	aggressive = 1
	defensive = 0
	wanderer = 1
	opensdoors = 1
	atkcarbon = 1
	atksilicon = 0
	firevuln = 2
	brutevuln = 0
	seekrange = 25
	angertext = null // comes between critter name and target name
	var/alivetime = 0
	var/tilelight = 0
	var/tilelightcheck = 0
	process()
		if (!src.alive) return
		alivetime += 5
		check_health()
		for(var/turf/simulated/A in src.loc)
			tilelight = A.LightLevelBlue + A.LightLevelGreen + A.LightLevelRed
		switch(task)
			if("thinking")
				src.attack = 0
				src.target = null
				walk_to(src,0)
				if (src.aggressive) seek_target()
				if (src.wanderer && !src.target) src.task = "wandering"
			if("chasing")
				if (src.frustration >= 8 || tilelight > 4)
					src.target = null
					src.last_found = world.time
					src.frustration = 0
					src.task = "thinking"
					walk_to(src,0)
				if (target)
					if (get_dist(src, src.target) <= 1)
						var/mob/living/carbon/M = src.target
						ChaseAttack(M)
						src.task = "attacking"
						src.anchored = 1
						src.target_lastloc = M.loc
					else
						var/turf/olddist = get_dist(src, src.target)
						walk_to(src, src.target,1,12)
						if ((get_dist(src, src.target)) >= (olddist))
							src.frustration++
						else
							src.frustration = 0
						sleep(1)
				else src.task = "thinking"
			if("attacking")
				// see if he got away
				if ((get_dist(src, src.target) > 1) || ((src.target:loc != src.target_lastloc)))
					src.anchored = 0
					src.task = "chasing"
				else
					if (get_dist(src, src.target) <= 1)
						var/mob/living/carbon/M = src.target
						if (!src.attacking) CritterAttack(src.target)
						if (!src.aggressive)
							src.task = "thinking"
							src.target = null
							src.anchored = 0
							src.last_found = world.time
							src.frustration = 0
							src.attacking = 0
						else
							if(M!=null)
								if (M.health < 0)
									src.task = "thinking"
									src.target = null
									src.anchored = 0
									src.last_found = world.time
									src.frustration = 0
									src.attacking = 0
					else
						src.anchored = 0
						src.attacking = 0
						src.task = "chasing"
			if("wandering")
				patrol_step()

		for(var/obj/item/weapon/cell/A in range(15, src))
			A.use(100 + alivetime)
		for(var/obj/item/device/pda/A in range(15, src))
			if(A.luminosity)
				A.ul_SetLuminosity(0)
//		for(var/obj/machinery/camera/A in range(15, src))
//			A.idle_power_usage = 5 * 100
//			A.active_power_usage = 10 * 100
		for(var/obj/item/device/flashlight/A in range(4, src))
			if(A.luminosity)
				A.power.maxcharge = 50000
				A.power.charge = 50000
		spawn(8)
			process()
		return


	New()
		src.seek_target()
		ul_SetLuminosity(-10)
		..()

	seek_target()
		src.anchored = 0
		for (var/mob/living/C in range(src.seekrange,src))
			if (src.target)
				src.task = "chasing"
				break
			if ((C.name == src.oldtarget_name) && (world.time < src.last_found + 100)) continue
			if (C.health < 0) continue
			if (C.name == src.attacker) src.attack = 1
			if (istype(C, /mob/living/carbon/)) src.attack = 1
			if (istype(C, /mob/living/silicon/)) src.attack = 1
			if (src.attack)
				src.target = C
				src.oldtarget_name = C.name
//				for(var/mob/O in viewers(src, null))
//					O.show_message("\red <b>[src]</b> [src.angertext] [C.name]!", 1)
				//playsound(src.loc, pick('YetiGrowl.ogg'), 50, 0)	Strumpetplaya - Not supported
				src.task = "chasing"
				break
			else
				continue

	ChaseAttack(mob/M)
//		for(var/mob/O in viewers(src, null))
//			O.show_message("\red <B>[src]</B> punches out [M]!", 1)
		playsound(src.loc, 'screech.ogg', 30, 1, -2)
		M.stunned = 10
		M.weakened = 10

	CritterAttack(mob/M)
		src.attacking = 1
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>[M] vanishes into darkness front of your eyes!</B>", 1)
		playsound(src.loc, 'screech.ogg', 30, 1, -2)
		M.death(1)
		M.monkeyizing = 1
		M.canmove = 0
		M.icon = null
		M.invisibility = 101
		if(M.client)
			del M.client
		del(M)
		src.task = "thinking"
		src.seek_target()
		src.attacking = 0
		//playsound(src.loc, pick('burp_alien.ogg'), 50, 0)	Strumpetplaya - Not supported

	patrol_step()
		for(var/turf/simulated/A in range(15, src))
			if(istype(A, /turf/simulated/))
				tilelightcheck =  A.LightLevelBlue + A.LightLevelGreen + A.LightLevelRed
				if(tilelightcheck <= tilelight)
					if(!A)
						CritterTeleport(20, 1, 1)
					else
						walk_to(src, A,1,12)

		if(src.aggressive)
			seek_target()
		steps += 1
		if (steps == rand(5,20))
			src.task = "thinking"
*/

// Critter Defines
//

/obj/critter/roach
	name = "cockroach"
	desc = "An unpleasant insect that lives in filthy places."
	icon_state = "roach"
	health = 10
	aggressive = 0
	defensive = 0
	wanderer = 1
	opensdoors = 0
	atkcarbon = 0
	atksilicon = 0

	attack_hand(mob/user as mob)
		if (src.alive && (user.a_intent != "hurt"))
			src.visible_message("\red <b>[user]</b> pets [src]!")
			return
		if(prob(95))
			src.visible_message("\red <B>[user] stomps [src], killing it instantly!</B>")
			CritterDeath()
			return
		..()

/obj/critter/slipperydick
	name = "slippery dick"
	desc = "An unpleasant insect that is slippery as fuck."
	icon_state = "roach"
	health = 50
	aggressive = 0
	defensive = 0
	wanderer = 1
	opensdoors = 0
	atkcarbon = 0
	atksilicon = 0

	attack_hand(mob/user as mob)
		if (src.alive && (user.a_intent != "hurt"))
			src.visible_message("\red <b>[user]</b> pets [src]!")
			return
		if(prob(95))
			src.visible_message("\red <B>[user] stomps [src], killing it instantly!</B>")
			CritterDeath()
			return
		..()

/*	HasEntered(var/mob/carbon/AM)
		if (istype(AM, /mob/living/carbon))
		var/mob/M =	AM
		M.pulling = null
		M << "\blue You slipped on the slippery dick!"
		playsound(src.loc, 'slip.ogg', 50, 1, -3)
		M.stunned = 8
		M.weakened = 5
		*/


/obj/critter/yeti
	name = "space yeti"
	desc = "Well-known as the single most aggressive, dangerous and hungry thing in the universe."
	icon_state = "yeti"
	density = 1
	health = 75
	aggressive = 1
	defensive = 0
	wanderer = 1
	opensdoors = 0
	atkcarbon = 1
	atksilicon = 1
	firevuln = 3
	brutevuln = 1
	angertext = "starts chasing" // comes between critter name and target name

	New()
		src.seek_target()
		..()

	seek_target()
		src.anchored = 0
		for (var/mob/living/C in view(src.seekrange,src))
			if (src.target)
				src.task = "chasing"
				break
			if ((C.name == src.oldtarget_name) && (world.time < src.last_found + 100))
				continue
			if (C.health < 0) continue
			if (C.name == src.attacker) src.attack = 1
			if (istype(C, /mob/living/carbon/)) src.attack = 1
			if (istype(C, /mob/living/silicon/)) src.attack = 1
			if (src.attack)
				src.target = C
				src.oldtarget_name = C.name
				for(var/mob/O in viewers(src, null))
					O.show_message("\red <b>[src]</b> [src.angertext] [C.name]!", 1)
				//playsound(src.loc, pick('YetiGrowl.ogg'), 50, 0)	Strumpetplaya - Not supported
				src.task = "chasing"
				break
			else
				continue

	ChaseAttack(mob/M)
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>[src]</B> punches out [M]!", 1)
		playsound(src.loc, 'bang.ogg', 50, 1, -1)
		M.stunned = 10
		M.weakened = 10

	CritterAttack(mob/M)
		src.attacking = 1
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>[src]</B> devours [M] in one bite!", 1)
		playsound(src.loc, 'eatfood.ogg', 30, 1, -2)
		M.death(1)
		var/atom/movable/overlay/animation = null
		M.monkeyizing = 1
		M.canmove = 0
		M.icon = null
		M.invisibility = 101
		if(ishuman(M))
			animation = new(src.loc)
			animation.icon_state = "blank"
			animation.icon = 'mob.dmi'
			animation.master = src
		if (M.client)
			var/mob/dead/observer/newmob
			newmob = new/mob/dead/observer(M)
			M.client:mob = newmob
			M.mind.transfer_to(newmob)
		del(M)
		src.task = "thinking"
		src.seek_target()
		src.attacking = 0
		sleep(10)
		//playsound(src.loc, pick('burp_alien.ogg'), 50, 0)	Strumpetplaya - Not supported


/obj/critter/penis
	name = "space penis"
	desc = "Well-known as the single most aggressive, dangerous and hungry thing in the universe."
	icon = 'belts.dmi'
	icon_state = "cock"
	density = 1
	health = 76
	aggressive = 1
	defensive = 0
	wanderer = 1
	opensdoors = 0
	atkcarbon = 1
	atksilicon = 1
	firevuln = 3
	brutevuln = 1
	angertext = "starts to charge at" // comes between critter name and target name

	New()
		src.seek_target()
		..()

	seek_target()
		src.anchored = 0
		for (var/mob/living/C in view(src.seekrange,src))
			if (src.target)
				src.task = "chasing"
				break
			if ((C.name == src.oldtarget_name) && (world.time < src.last_found + 100)) continue
			if (C.health < 0) continue
			if (C.name == src.attacker) src.attack = 1
			if (istype(C, /mob/living/carbon/)) src.attack = 1
			if (istype(C, /mob/living/silicon/)) src.attack = 1
			if (src.attack)
				src.target = C
				src.oldtarget_name = C.name
				for(var/mob/O in viewers(src, null))
					O.show_message("\red <b>[src]</b> [src.angertext] [C.name]!", 1)
				src.task = "chasing"
				break
			else
				continue

	ChaseAttack(mob/M)
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>[src]</B> knocks out [M]!", 1)
		playsound(src.loc, 'bang.ogg', 50, 1, -1)
		M.stunned = 10
		M.weakened = 10

	CritterAttack(mob/M)
		src.attacking = 1
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>[src]</B> cockslaps [M]!", 1)
			O.show_message("\red [M] has been cockslapped out of existence!", 1)
		M.death(1)
		var/atom/movable/overlay/animation = null
		M.monkeyizing = 1
		M.canmove = 0
		M.icon = null
		M.invisibility = 101
		if(ishuman(M))
			animation = new(src.loc)
			animation.icon_state = "blank"
			animation.icon = 'mob.dmi'
			animation.master = src
		if (M.client)
			var/mob/dead/observer/newmob
			newmob = new/mob/dead/observer(M)
			M.client:mob = newmob
			M.mind.transfer_to(newmob)
		del(M)
		src.task = "thinking"
		src.seek_target()
		src.attacking = 0
		sleep(10)



/obj/critter/maneater
	name = "man-eating plant"
	desc = "It looks hungry..."
	icon_state = "maneater"
	density = 1
	health = 30
	aggressive = 1
	defensive = 0
	wanderer = 1
	opensdoors = 0
	atkcarbon = 1
	atksilicon = 0
	firevuln = 2
	brutevuln = 0.5

	New()
		..()
		//playsound(src.loc, pick('MEilive.ogg'), 50, 0)	Strumpetplaya - Not supported

	seek_target()
		src.anchored = 0
		for (var/mob/living/C in view(src.seekrange,src))
			if ((C.name == src.oldtarget_name) && (world.time < src.last_found + 100)) continue
			if (istype(C, /mob/living/carbon/) && !src.atkcarbon) continue
			if (istype(C, /mob/living/silicon/) && !src.atksilicon) continue
			if (C.job == "Botanist") continue
			if (C.health < 0) continue
			if (C.name == src.friend) continue
			if (istype(C, /mob/living/carbon/) && src.atkcarbon) src.attack = 1
			if (istype(C, /mob/living/silicon/) && src.atksilicon) src.attack = 1

			if (src.attack)
				src.target = C
				src.oldtarget_name = C.name
				for(var/mob/O in viewers(src, null))
					O.show_message("\red <b>[src]</b> charges at [C.name]!", 1)
				//playsound(src.loc, pick('MEhunger.ogg', 'MEraaargh.ogg', 'MEruncoward.ogg', 'MEbewarecoward.ogg'), 50, 0)	Strumpetplaya - Not supported
				src.task = "chasing"
				break
			else continue

	ChaseAttack(mob/M)
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>[src]</B> slams into [M]!", 1)
		playsound(src.loc, 'genhit1.ogg', 50, 1, -1)
		M.stunned += rand(1,4)
		M.weakened += rand(1,4)

	CritterAttack(mob/M)
		src.attacking = 1
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>[src]</B> starts trying to eat [M]!", 1)
		spawn(60)
			if (get_dist(src, M) <= 1 && ((M:loc == target_lastloc)))
				if(istype(M,/mob/living/carbon))
					for(var/mob/O in viewers(src, null))
						O.show_message("\red <B>[src]</B> ravenously wolfs down [M]!", 1)
					playsound(src.loc, 'eatfood.ogg', 30, 1, -2)
					M.death(1)
					var/atom/movable/overlay/animation = null
					M.monkeyizing = 1
					M.canmove = 0
					M.icon = null
					M.invisibility = 101
					if(ishuman(M))
						animation = new(src.loc)
						animation.icon_state = "blank"
						animation.icon = 'mob.dmi'
						animation.master = src
					if (M.client)
						var/mob/dead/observer/newmob
						newmob = new/mob/dead/observer(M)
						M.client:mob = newmob
						M.mind.transfer_to(newmob)
					del(M)
					sleep(25)
					src.target = null
					src.task = "thinking"
					//playsound(src.loc, pick('burp_alien.ogg'), 50, 0)	Strumpetplaya - Not supported
			else
				for(var/mob/O in viewers(src, null))
					O.show_message("\red <B>[src]</B> gnashes its teeth in fustration!", 1)
			src.attacking = 0

/obj/critter/thething
	name = "THE THING ripoff"
	desc = "Today, Space Station 13 - tomorrow, THE WORLD!"
	icon = 'livestock.dmi'
	icon_state = ""
	density = 0
	health = 15
	aggressive = 1
	defensive = 1
	wanderer = 1
	opensdoors = 1
	atkcarbon = 1
	atksilicon = 1
	firevuln = 2
	brutevuln = 2
	var/infectedby = null
	var/list/absorbed_dna = list()
	var/olddna
	var/oldname
	seek_target()
		src.anchored = 0
		for (var/mob/living/C in view(src.seekrange,src))
			if ((C.name == src.oldtarget_name) && (world.time < src.last_found + 100)) continue
			if (istype(C, /mob/living/carbon/) && !src.atkcarbon) continue
			if (istype(C, /mob/living/silicon/) && !src.atksilicon) continue
			if (C.health < 0) continue
			if (C.name == src.attacker) src.attack = 1
			if (istype(C, /mob/living/carbon/) && src.atkcarbon) src.attack = 1
			if (istype(C, /mob/living/silicon/) && src.atksilicon) src.attack = 1
			if (C.changeling_level >= 1) continue
			if (src.attack)
				src.target = C
				src.oldtarget_name = C.name
				for(var/mob/O in viewers(src, null))
					O.show_message("\red <b>[src]</b> charges at [C:name]!", 1)
				//playsound(src.loc, pick('MEhunger.ogg', 'MEraaargh.ogg', 'MEruncoward.ogg', 'MEbewarecoward.ogg'), 50, 0)	Strumpetplaya - Not supported
				src.task = "chasing"
				break
			else
				continue

	ChaseAttack(mob/M)
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>[src]</B> viciously lunges at [M]!", 1)
		//M.stunned = 10
		M.weakened = 10
	//	var/datum/disease/the_thing/A = new /datum/disease/the_thing
	//	A.infectedby = src.infectedby
	//	A.absorbed_dna = absorbed_dna
	//	A.oldname = src.oldname
	//	A.olddna = src.olddna
	//	target:contract_disease(A)
		seek_target()
		sleep(20)

	CritterAttack(mob/M)
		sleep(20)
		src.attacking = 1
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>[src]</B> bites [src.target]!", 1)
		src.target:bruteloss += rand(1,2)
	//	var/datum/disease/the_thing/A = new /datum/disease/the_thing
	//	A.infectedby = src.infectedby
	//	A.absorbed_dna = absorbed_dna
	//	A.oldname = src.oldname
	//	A.olddna = src.olddna
	//	target:contract_disease(A)
		seek_target()
		spawn(10)
			src.attacking = 0

	CritterDeath()
		src.visible_message("<b>[src]</b> messily splatters into a puddle of blood!")
		src.alive = 0
		playsound(src.loc, 'splat.ogg', 100, 1)
		var/obj/decal/cleanable/blood/B = new(src.loc)
		B.name = "Blood"
		del src


/obj/critter/killertomato
	name = "killer tomato"
	desc = "Today, Space Station 13 - tomorrow, THE WORLD!"
	icon_state = "ktomato"
	density = 1
	health = 15
	aggressive = 1
	defensive = 0
	wanderer = 1
	opensdoors = 1
	atkcarbon = 1
	atksilicon = 1
	firevuln = 2
	brutevuln = 2

	New()
		..()
		playsound(src.loc, 'bewareilive.ogg', 40, 0)

	seek_target()
		src.anchored = 0
		for (var/mob/living/C in view(src.seekrange,src))
			if ((C.name == src.oldtarget_name) && (world.time < src.last_found + 100)) continue
			if (istype(C, /mob/living/carbon/) && !src.atkcarbon) continue
			if (istype(C, /mob/living/silicon/) && !src.atksilicon) continue
			if (C.health < 0) continue
			if (C.name == src.attacker) src.attack = 1
			if (istype(C, /mob/living/carbon/) && src.atkcarbon) src.attack = 1
			if (istype(C, /mob/living/silicon/) && src.atksilicon) src.attack = 1

			if (src.attack)
				src.target = C
				src.oldtarget_name = C.name
				for(var/mob/O in viewers(src, null))
					O.show_message("\red <b>[src]</b> charges at [C:name]!", 1)
				playsound(src.loc, pick('ihunger.ogg', 'sinistarscream.ogg', 'runcoward.ogg'), 40, 0)
				src.task = "chasing"
				break
			else
				continue

	ChaseAttack(mob/M)
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>[src]</B> viciously lunges at [M]!", 1)
		if (prob(20)) M.stunned += rand(1,3)
		M.bruteloss += rand(2,5)

	CritterAttack(mob/M)
		src.attacking = 1
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>[src]</B> bites [src.target]!", 1)
		src.target:bruteloss += rand(1,2)
		spawn(10)
			src.attacking = 0

	CritterDeath()
		src.visible_message("<b>[src]</b> messily splatters into a puddle of tomato sauce!")
		src.alive = 0
		playsound(src.loc, 'splat.ogg', 100, 1)
		var/obj/decal/cleanable/blood/B = new(src.loc)
		B.name = "ruined tomato"
		del src

/obj/critter/spore
	name = "plasma spore"
	desc = "A barely intelligent colony of organisms. Very volatile."
	icon_state = "spore"
	density = 1
	health = 1
	aggressive = 0
	defensive = 0
	wanderer = 1
	opensdoors = 0
	atkcarbon = 0
	atksilicon = 0
	firevuln = 2
	brutevuln = 2

	CritterDeath()
		src.visible_message("<b>[src]</b> ruptures and explodes!")
		src.alive = 0
		var/turf/T = get_turf(src.loc)
		if(T)
			T.hotspot_expose(700,125)
			explosion(T, -1, -1, 2, 3)
		del src

	ex_act(severity)
		CritterDeath()

	bullet_act(flag, A as obj)
		CritterDeath()

/obj/critter/mouse
	name = "space-mouse"
	desc = "A mouse.  In space."
	icon_state = "mouse"
	density = 0
	health = 2
	aggressive = 0
	defensive = 1
	wanderer = 1
	opensdoors = 0
	atkcarbon = 0
	atksilicon = 0
	firevuln = 1
	brutevuln = 1

	CritterAttack(mob/M)
		src.attacking = 1
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>[src]</B> bites [src.target]!", 1)
		src.target:bruteloss += 1
		spawn(10)
			src.attacking = 0

/obj/critter/mimic
	name = "mechanical toolbox"
	desc = null
	icon_state = "mimic1"
	health = 20
	aggressive = 1
	defensive = 1
	wanderer = 0
	atkcarbon = 1
	atksilicon = 1
	brutevuln = 0.5
	seekrange = 1
	angertext = "suddenly comes to life and lunges at"

	process()
		..()
		if (src.alive)
			switch(task)
				if("thinking")
					src.icon_state = "mimic1"
					src.name = "mechanical toolbox"
				if("chasing")
					src.icon_state = "mimic2"
					src.name = "mimic"
				if("attacking")
					src.icon_state = "mimic2"
					src.name = "mimic"

	ChaseAttack(mob/M)
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>[src]</B> hurls itself at [M]!", 1)
		if (prob(33)) M.weakened += rand(3,6)

	CritterAttack(mob/M)
		src.attacking = 1
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>[src]</B> bites [src.target]!", 1)
		src.target:bruteloss += rand(2,4)
		spawn(25)
			src.attacking = 0

	CritterDeath()
		src.visible_message("<b>[src]</b> crumbles to pieces!")
		src.alive = 0
		density = 0
		walk_to(src,0)
		src.icon_state = "mimic-dead"

/obj/critter/martian
	name = "martian"
	desc = "Genocidal monsters from Mars."
	icon_state = "martian"
	density = 1
	health = 20
	aggressive = 0
	defensive = 1
	wanderer = 1
	opensdoors = 1
	atkcarbon = 1
	atksilicon = 1
	firevuln = 1.5
	brutevuln = 1

	attackby(obj/item/weapon/W as obj, mob/living/user as mob)
		..()
		if (!src.alive) return
		switch(W.damtype)
			if("fire") src.health -= W.force * src.firevuln
			if("brute") src.health -= W.force * src.brutevuln
		if (src.alive && src.health <= 0) src.CritterDeath()
		if (src.defensive)
			MartianPsyblast(user)
			for(var/mob/O in viewers(src, null))
				O.show_message("\red <b>[src]</b> teleports away!", 1)
			CritterTeleport(20, 1, 0)

	attack_hand(var/mob/user as mob)
		if (!src.alive) return
		if (user.a_intent == "hurt")
			src.health -= rand(1,2) * src.brutevuln
			for(var/mob/O in viewers(src, null))
				O.show_message("\red <b>[user]</b> punches [src]!", 1)
			playsound(src.loc, pick('punch1.ogg','punch2.ogg','punch3.ogg','punch4.ogg'), 100, 1)
			if (src.alive && src.health <= 0) src.CritterDeath()
			if (src.defensive)
				MartianPsyblast(user)
				for(var/mob/O in viewers(src, null))
					O.show_message("\red <b>[src]</b> teleports away!", 1)
				CritterTeleport(20, 1, 0)
		else
			for(var/mob/O in viewers(src, null))
				O.show_message("\red <b>[user]</b> pets [src]!", 1)
			for(var/mob/O in hearers(src, null))
				O.show_message("<b>[src]</b> screeches, 'KXBQUB IJFDQVW??'", 1)


/obj/critter/martian/proc/MartianPsyblast(mob/target as mob)
	for(var/mob/O in hearers(src, null))
		O.show_message("<b>[src]</b> screeches, 'GBVQW UVQWIBJZ PKDDR!!!'", 1)
	target << "\red You are blasted by psychic energy!"
	playsound(target.loc, 'ghost2.ogg', 100, 1)
	target.paralysis += 10
	target.stuttering += 60
	target.brainloss += 20
	target.fireloss += 5

/obj/critter/martian/soldier
	name = "martian soldier"
	desc = "Genocidal monsters from Mars."
	icon_state = "martianS"
	health = 35
	aggressive = 1
	seekrange = 7

	seek_target()
		src.anchored = 0
		for (var/mob/living/C in view(src.seekrange,src))
			if (!src.alive) break
			if (C.health < 0) continue
			if (C.name == src.attacker) src.attack = 1
			if (istype(C, /mob/living/carbon/) && src.atkcarbon) src.attack = 1
			if (istype(C, /mob/living/silicon/) && src.atksilicon) src.attack = 1

			if (src.attack)
				src.target = C
				src.oldtarget_name = C.name
				for(var/mob/O in viewers(src, null))
					O.show_message("\red <b>[src]</b> shoots at [C.name]!", 1)
				//playsound(src.loc, 'lasermed.ogg', 100, 1)	Strumpetplaya - Not supported
				if (prob(66))
					C.fireloss += rand(3,5)
					var/datum/effects/system/spark_spread/s = new /datum/effects/system/spark_spread
					s.set_up(3, 1, C)
					s.start()
				else target << "\red The shot missed!"
				src.attack = 0
				sleep(12)
				seek_target()
				src.task = "thinking"
				break
			else continue

/obj/critter/martian/psychic
	name = "martian mutant"
	desc = "Genocidal monsters from Mars."
	icon_state = "martianP"
	health = 10
	aggressive = 1
	seekrange = 4

	seek_target()
		src.anchored = 0
		for (var/mob/living/C in view(src.seekrange,src))
			if (!src.alive) break
			if (C.health < 0) continue
			if (C.name == src.attacker) src.attack = 1
			if (istype(C, /mob/living/carbon/) && src.atkcarbon) src.attack = 1
			if (istype(C, /mob/living/silicon/) && src.atksilicon) src.attack = 1

			if (src.attack)
				src.target = C
				src.oldtarget_name = C.name
				for(var/mob/O in viewers(src, null))
					O.show_message("\red <b>[src]</b> stares at [C.name]!", 1)
				//playsound(src.loc, 'phaseroverload.ogg', 100, 1)	Strumpetplaya - Not supported
				C << "\red You feel a horrible pain in your head!"
				C.stunned += rand(1,2)
				sleep(55)
				if ((get_dist(src, C) <= 6) && src.alive)
					for(var/mob/O in viewers(C, null))
						O.show_message("\red <b>[C.name]'s</b> head explodes!", 1)
					C.gib()
				else
					for(var/mob/O in viewers(src, null))
						O.show_message("\red <b>[src]</b> screeches, 'VWYK QWU!!'", 1)
				src.attack = 0
				sleep(30)
				src.task = "thinking"
				break
			else continue

/obj/critter/martian/warrior
	name = "martian warrior"
	desc = "Genocidal monsters from Mars."
	icon_state = "martianW"
	health = 35
	aggressive = 1
	seekrange = 7

	ChaseAttack(mob/M)
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>[src]</B> grabs at [M]!", 1)
		if (prob(33)) M.weakened += rand(2,4)
		spawn(25)
			if (get_dist(src, M) <= 1)
				for(var/mob/O in viewers(src, null))
					O.show_message("\red <B>[src]</B> starts strangling [M]!", 1)

	CritterAttack(mob/M)
		src.attacking = 1
		if (prob(95))
			if (prob(10))
				for(var/mob/O in viewers(src, null))
					O.show_message("\red <B>[src]</B> wraps its tentacles around [M]'s neck!", 1)
			M:oxyloss += 2
			M.weakened += 1
		else
			for(var/mob/O in viewers(src, null))
				O.show_message("\red <B>[src]'s</B> grip slips!", 1)
			M.stunned = 0
			sleep(10)
			for(var/mob/O in viewers(src, null))
				O.show_message("\red <b>[src]</b> screeches, 'KBWKB WVYPGD!!'", 1)
			src.task = "thinking"
		spawn(10)
			src.attacking = 0

/obj/critter/martian/sapper
	name = "martian sapper"
	desc = "Genocidal monsters from Mars."
	icon_state = "martianSP"
	health = 10
	aggressive = 0
	defensive = 0
	atkcarbon = 0
	atksilicon = 0
	task = "wandering"

	New()
		..()
		src.task = "wandering"


	process()
		set background = 1
		if (!src.alive) return
		switch(task)
			if("thinking")
				var/obj/machinery/martianbomb/B = new(src.loc)
				B.icon_state = "mbomb-timing"
				B.active = 1
				for(var/mob/O in viewers(src, null))
					O.show_message("\red <B>[src];s</B> plants a bomb and teleports away!", 1)
				del src
			if("wandering")
				patrol_step()
				sleep(10)
		spawn(10)
			process()

/obj/machinery/martianbomb
	name = "martian bomb"
	desc = "You'd best destroy this thing fast."
	icon = 'critter.dmi'
	icon_state = "mbomb-off"
	anchored = 1
	density = 1
	health = 100
	var/active = 0
	var/timeleft = 120
	//mats = 15		Strumpetplaya - not supported

	process()
		if (src.active)
			src.icon_state = "mbomb-timing"
			src.timeleft -= 1
			if (src.timeleft <= 10) src.icon_state = "mbomb-det"
			if (src.timeleft == 0)
				explosion(src.loc, 5, 10, 15, 20)
				del src
			//proc/explosion(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range)
		else
			src.icon_state = "mbomb-off"

	ex_act(severity)
		if(severity)
			for(var/mob/O in viewers(src, null))
				O.show_message("\blue <B>[src]</B> crumbles away into dust!", 1)
			del src
		return
/*	Strumpetplaya - Not supported
	bullet_act(var/datum/projectile/P)
		var/damage = 0
		damage = round((P.power*P.ks_ratio), 1.0)


		if(P.damage_type == D_KINETIC)
			if(damage >= 20)
				src.health -= damage
			else
				damage = 0
		else if(P.damage_type == D_PIERCING)
			src.health -= (damage*2)
		else if(P.damage_type == D_ENERGY)
			src.health -= damage
		else
			damage = 0

		if(damage >= 15)
			if (src.active && src.timeleft > 10)
				for(var/mob/O in viewers(src, null))
					O.show_message("\red <B>[src]</B> begins buzzing loudly!", 1)
				src.timeleft = 10

		if (src.health <= 0)
			for(var/mob/O in viewers(src, null))
				O.show_message("\blue <B>[src]</B> crumbles away into dust!", 1)
			del src
*/
	attackby(obj/item/weapon/W as obj, mob/user as mob)
		..()
		src.health -= W.force
		if (src.active && src.timeleft > 10)
			for(var/mob/O in viewers(src, null))
				O.show_message("\red <B>[src]</B> begins buzzing loudly!", 1)
			src.timeleft = 10
		if (src.health <= 0)
			for(var/mob/O in viewers(src, null))
				O.show_message("\blue <B>[src]</B> crumbles away into dust!", 1)
			del src

/obj/critter/rockworm
	name = "rock worm"
	desc = "Tough lithovoric worms."
	icon_state = "rockworm"
	density = 0
	health = 80
	aggressive = 1
	defensive = 0
	wanderer = 1
	opensdoors = 0
	atkcarbon = 0
	atksilicon = 0
	firevuln = 0.1
	brutevuln = 1
	angertext = "hisses at"
	var/eaten = 0

	seek_target()
		src.anchored = 0
		for (var/obj/item/weapon/ore/C in view(src.seekrange,src))
			if (src.target)
				src.task = "chasing"
				break
			if ((C.name == src.oldtarget_name) && (world.time < src.last_found + 100)) continue
			src.attack = 1

			if (src.attack)
				src.target = C
				src.oldtarget_name = C.name
				for(var/mob/O in viewers(src, null))
					O.show_message("\red <b>[src]</b> sees [C.name]!", 1)
				src.task = "chasing"
				break
			else
				continue

	CritterAttack(mob/M)
		src.attacking = 1

		if(istype(M, /obj/item/weapon/ore/))
			src.visible_message("\red <b>[src]</b> hungrily eats [src.target]!")
			playsound(src.loc, 'eatfood.ogg', 30, 1, -2)
			del(src.target)
			src.eaten++
			src.target = null
			src.task = "thinking"

		src.attacking = 0
		return

	CritterDeath()
		src.alive = 0
		src.target = null
		src.task = "dead"
		density = 0
		src.icon_state = "rockworm-dead"
		walk_to(src,0)
		for(var/mob/O in viewers(src, null)) O.show_message("<b>[src]</b> dies!",1)
		//var/countstones = 0	Strumpetplaya - Not supported
		//while (src.eaten)
			//countstones++
			//if (countstones == 10)
			//	if (prob(50)) new /obj/item/weapon/ore/cytine(src.loc)
			//	else new /obj/item/weapon/ore/uqill(src.loc)
			//	countstones = 0
			//src.eaten--

/obj/critter/lizard
	name = "lizard"
	desc = "Tough lithovoric worms."
	icon = 'livestock.dmi'
	icon_state = "lizard"
	density = 0
	health = 80
	aggressive = 1
	defensive = 0
	wanderer = 1
	opensdoors = 0
	atkcarbon = 0
	atksilicon = 0
	firevuln = 0.1
	brutevuln = 1
	angertext = "hisses at"
	var/eaten = 0

	seek_target()
		src.anchored = 0
		for (var/obj/glowshroom/C in view(src.seekrange,src))
			if (src.target)
				src.task = "chasing"
				break
			if ((C.name == src.oldtarget_name) && (world.time < src.last_found + 100)) continue
			src.attack = 1

			if (src.attack)
				src.target = C
				src.oldtarget_name = C.name
				for(var/mob/O in viewers(src, null))
					O.show_message("\red <b>[src]</b> sees [C.name]!", 1)
				src.task = "chasing"
				break
			else
				continue

	CritterAttack(mob/M)
		src.attacking = 1

		if(istype(M, /obj/glowshroom/))
			src.visible_message("\red <b>[src]</b> hungrily eats [src.target]!")
			playsound(src.loc, 'eatfood.ogg', 30, 1, -2)
			del(src.target)
			src.eaten++
			src.target = null
			src.task = "thinking"

		src.attacking = 0
		return

	CritterDeath()
		src.alive = 0
		src.target = null
		src.task = "dead"
		density = 0
		src.icon_state = "lizard_d"
		walk_to(src,0)
		for(var/mob/O in viewers(src, null)) O.show_message("<b>[src]</b> dies!",1)
		//var/countstones = 0	Strumpetplaya - Not supported
		//while (src.eaten)
			//countstones++
			//if (countstones == 10)
			//	if (prob(50)) new /obj/item/weapon/ore/cytine(src.loc)
			//	else new /obj/item/weapon/ore/uqill(src.loc)
			//	countstones = 0
			//src.eaten--

/obj/critter/lizzzard
	name = "lizard"
	desc = "Tough lithovoric worms."
	icon = 'livestock.dmi'
	icon_state = "lizzzard"
	density = 0
	health = 120
	aggressive = 1
	defensive = 0
	wanderer = 1
	opensdoors = 0
	atkcarbon = 0
	atksilicon = 0
	firevuln = 0.1
	brutevuln = 1
	angertext = "hisses at"
	var/eaten = 0

	seek_target()
		src.anchored = 0
		for (var/obj/item/C in view(src.seekrange,src))
			if (src.target)
				src.task = "chasing"
				break
			if ((C.name == src.oldtarget_name) && (world.time < src.last_found + 100)) continue
			src.attack = 1

			if (src.attack)
				src.target = C
				src.oldtarget_name = C.name
				for(var/mob/O in viewers(src, null))
					O.show_message("\red <b>[src]</b> sees [C.name]!", 1)
				src.task = "chasing"
				break
			else
				continue

	CritterAttack(mob/M)
		src.attacking = 1

		if(istype(M, /obj/item/))
			src.visible_message("\red <b>[src]</b> hungrily eats [src.target]!")
			playsound(src.loc, 'eatfood.ogg', 30, 1, -2)
			del(src.target)
			src.eaten++
			src.target = null
			src.task = "thinking"

		src.attacking = 0
		return

	CritterDeath()
		src.alive = 0
		src.target = null
		src.task = "dead"
		density = 0
		src.icon_state = "lizzzard_d"
		walk_to(src,0)
		for(var/mob/O in viewers(src, null)) O.show_message("<b>[src]</b> dies!",1)
		//var/countstones = 0	Strumpetplaya - Not supported
		//while (src.eaten)
			//countstones++
			//if (countstones == 10)
			//	if (prob(50)) new /obj/item/weapon/ore/cytine(src.loc)
			//	else new /obj/item/weapon/ore/uqill(src.loc)
			//	countstones = 0
			//src.eaten--


/obj/critter/lizzzzard
	name = "lizard"
	desc = "Tough lithovoric worms."
	icon = 'livestock.dmi'
	icon_state = "lizzzzard"
	density = 0
	health = 120
	aggressive = 1
	defensive = 0
	wanderer = 1
	opensdoors = 0
	atkcarbon = 0
	atksilicon = 0
	firevuln = 0.1
	brutevuln = 1
	angertext = "hisses at"
	var/eaten = 0

	seek_target()
		src.anchored = 0
		for (var/obj/C in view(src.seekrange,src))
			if(!istype(C, /obj/critter/lizzzzard))
				if (src.target)
					src.task = "chasing"
					break
				if ((C.name == src.oldtarget_name) && (world.time < src.last_found + 100)) continue
				src.attack = 1

				if (src.attack)
					src.target = C
					src.oldtarget_name = C.name
					for(var/mob/O in viewers(src, null))
						O.show_message("\red <b>[src]</b> sees [C.name]!", 1)
					src.task = "chasing"
					break
				else
					continue

	CritterAttack(mob/M)
		src.attacking = 1

		if(!istype(M, /obj/critter/lizzzzard))
			if(istype(M, /obj/))
				src.visible_message("\red <b>[src]</b> hungrily eats [src.target]!")
				playsound(src.loc, 'eatfood.ogg', 30, 1, -2)
				del(src.target)
				src.eaten++
				src.target = null
				src.task = "thinking"

			src.attacking = 0
			return

	CritterDeath()
		src.alive = 0
		src.target = null
		src.task = "dead"
		density = 0
		src.icon_state = "lizzzzard_d"
		walk_to(src,0)
		for(var/mob/O in viewers(src, null)) O.show_message("<b>[src]</b> dies!",1)
		//var/countstones = 0	Strumpetplaya - Not supported
		//while (src.eaten)
			//countstones++
			//if (countstones == 10)
			//	if (prob(50)) new /obj/item/weapon/ore/cytine(src.loc)
			//	else new /obj/item/weapon/ore/uqill(src.loc)
			//	countstones = 0
			//src.eaten--