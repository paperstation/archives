var/global/list/stoutshako = list(
	/obj/item/weapon/syntiflesh,
	/obj/item/weapon/soap/deluxe,
	/obj/item/weapon/scythe,
	/obj/item/weapon/grenade/smokebomb,
	/obj/item/weapon/cell/super,
	/obj/item/device/camera,
	/obj/item/weapon/storage/toolbox/syndicate,
	/obj/item/weapon/storage/box/lunchbox,
	/obj/item/weapon/reagent_containers/food/drinks/bottle/orangejuice,
	/obj/item/weapon/melee/classic_baton,
	/obj/item/toy/katana/,
	/obj/item/weapon/firstaid_arm_assembly,
	/obj/item/weapon/hatchet,
	/obj/item/weapon/lighter/zippo,
	/obj/item/weapon/mop,
	/obj/item/weapon/sonicscrewdriver,
	/obj/item/weapon/grown/log
			)


//The effect when you wrap a dead body in gift wrap
/obj/effect/spresent
	name = "strange present"
	desc = "It's a ... present?"
	icon = 'icons/obj/items.dmi'
	icon_state = "strangepresent"
	density = 1
	anchored = 0


/obj/effect/rendfake
	name = "Tear in the fabric of reality"
	desc = "You should run now"
	icon = 'icons/obj/biomass.dmi'
	icon_state = "rift"
	density = 0
	unacidable = 1
	anchored = 1.0

/obj/effect/rendfake/New()
	spawn(100)
		del(src)

/obj/effect/rendfake/spawner //It spawns mobs and mob accessories
	New()
		src.visible_message("A portal opens!")
		spawn(50)
			new /mob/living/simple_animal/hostile/cult (src.loc)
			new /mob/living/simple_animal/hostile/cult (src.loc)
			new /mob/living/simple_animal/hostile/wargolem (src.loc)
			spawn(50)
				del(src)





/obj/machinery/fakeobject
	name = "Trigger"
	desc = "Controls the elevator"
	icon = 'icons/obj/biomass.dmi'
	icon_state = "rift"
	var/once

	attack_hand()
		if(!once)
			once = 1
			src.visible_message("Pay attention, the only way to get past this barricade is simple")
			spawn(60)
			for(var/obj/structure/statue/alien/C in world)
				C.backroom()



/obj/structure/statue/
	icon = 'icons/mob/animal.dmi'
	icon_state = "assistant"
	density = 1
	anchored = 1
	damage_resistance = -1

	ass
		name = "Assistant Marty Cist"

	harmbaton
		name = "Officer Fizzlethief"
		icon_state = "harmbaton"

	scientist
		name = "Scientist Hopson"
		icon_state = "scientist"

	chef
		name = "Chef Cakeson"
		icon_state = "chef"

	alien
		name = "Alien Queen"
		desc = "See me rollin"
		icon = 'icons/mob/queencar.dmi'
		icon_state = "spaceexplorer"
		var/moved = 0
		density = 1

		Del()
			..()
			processing_objects.Remove(src)

		Bump(mob/living/user as mob)//This stuff causes runtimes, but is hilarious as hell
			user.unlock_achievement("FLOOR IT!?!?!")
			user.gib()

		Bumped(mob/living/user as mob)
			user.unlock_achievement("FLOOR IT!?!?!")
			user.gib()

		process()
			Path_set(src, list(WEST),  1, 50,  1, 0)

		proc/backroom(mob/living as obj)
			processing_objects.Add(src)
			for(var/mob/Z in range(src,30))
				Z << sound('sound/effects/carhorn.ogg')
			moved = 1
			for(var/obj/effect/cultbarrier/C in range(src,20))
				var/datum/effect/effect/system/harmless_smoke_spread/s = new /datum/effect/effect/system/harmless_smoke_spread
				s.set_up(1, 1, C, 0)
				s.start()
				for(var/mob/living/X in range(C,5))
					X.stunned = 2
				del(C)
			Path_set(src, list(WEST),  1, 16,  1, 0)
			spawn(80)
				spawn(1)
					moved = 2
					var/msg = "FUCK!"
					visible_message("<b>[name]</b> says, \"" + msg + "\"", 2)
					spawn(50)
						msg = "THAT IS FIVE CRASHES TODAY!"
						visible_message("<b>[name]</b> says, \"" + msg + "\"", 2)
						spawn(50)
							msg = "MY INSURANCE WON'T COVER THIS!"
							visible_message("<b>[name]</b> says, \"" + msg + "\"", 2)
							spawn(70)
								msg = "I'LL JUST HAVE TO EAT YOU BEFORE YOU CAN GET MY INSURANCE INFORMATION!"
								visible_message("<b>[name]</b> says, \"" + msg + "\"", 2)
								spawn(1)
									new/obj/effect/critter/alien(src.loc)
									del(src)

/obj/structure/shelf
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "shelf"


/obj/item/chestkey
	name = "old key"
	desc = "It has Epsilon written on it."
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "key"
	var/style = 0 //1 = greed, 2 = gluttony

/obj/effect/landmark/trap

/obj/effect/landmark/gluttony

/obj/structure/chest
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "chest"
	var/canopen = 0
	density = 1
	anchored = 1
	var/tempstate = 0
	attack_hand()
		if(canopen)
			usr << "You begin to open the chest"
			if(do_after(usr, 100))
				usr << "You open the chest, but you suddenly can't move!"
				for(var/mob/living/C in range(src, 15))
					C << "A mysterious chilling force pulls you to the ground."
					C.stunned = 5
				icon_state = "chestopen"
				spawn(10)
					switch(tempstate)
						if(1)
							usr.loc = src.loc
							usr << "You are sucked into the chest!"
							spawn(5)
								for(var/obj/effect/landmark/trap/D in world)
									usr.loc = D.loc
									canopen = 0
									specialchange = 1
									icon_state = "chest"
									usr.unlock_achievement("Seven Deadly Sins: Greed")
									for(var/mob/living/C in range(src, 15))
										C.unlock_achievement("Seven Deadly Sins: Envy")
									for(var/mob/G in oview(10, src))
										G << playsound('sound/effects/burp.ogg')
						if(2)
							usr.loc = src.loc
							usr << "You are sucked into the chest!"
							spawn(5)
								for(var/obj/effect/landmark/gluttony/D in world)
									usr.loc = D.loc
									canopen = 0
									specialchange = 1
									icon_state = "chest"
									usr.unlock_achievement("Seven Deadly Sins: Gluttony")
									for(var/mob/living/C in range(src, 15))
										C.unlock_achievement("Seven Deadly Sins: Envy")
									for(var/mob/G in oview(10, src))
										G << playsound('sound/effects/burp.ogg')
		else
			usr << "You can't find a way to open it."

	attackby(var/obj/item/chestkey/W, var/mob/user)
		tempstate = W.style
		canopen = 1
		del(W)



/obj/item/weapon/reagent_containers/glass/tub
	desc = "Holds 2000 reagents."
	name = "Chemical Tub"
	icon = 'icons/obj/storage.dmi'
	icon_state = "largebinsopen"
	item_state = "largebinsopen"
	m_amt = 200
	g_amt = 0
	w_class = 3.0
	anchored = 1
	density = 1
	amount_per_transfer_from_this = 0
	possible_transfer_amounts = list(10,20,30,50,70)
	volume = 2000
	flags = FPRINT | OPENCONTAINER

	attack_hand()
		return




/obj/effect/warper
	name = "rift"
	desc = "Wow..."
	icon = 'icons/effects/160x160.dmi'
	icon_state = "Singularity"
	anchored = 1

/obj/effect/warper/proc/weaponize()
	for(var/obj/effect/landmark/lavazone/C in world)
		C.changeturf()

/obj/effect/landmark/lavazone/proc/changeturf()
	for(var/turf/simulated/floor/plating/snow/C in range(src,0))
		C.icon = 'icons/turf/floors.dmi'
		C.icon_state = "lava"
		C.lava = 1
		C.name = "Lava"
/obj/machinery/power/eventgenerator
	name = "power generator"
	desc = "A christmas spirit powered generator. Has a slot were a christmas cookie would go."
	icon_state = "teg"
	var/on = 0
	var/spirit = 0
	var/list/recorded = list("santa", "ho ho ho", "ho", "all", "of", "silent night", "jingle bells", "jingle bell", "rudolph", "snowman", "rock", "housetop", "christmas", "white", "kringle", "silent", "night")

	hear_talk(mob/living/M as mob, msg)
		if(on == 1)
			if(findtext(msg, recorded))
				spirit += rand(10)
				if(spirit >= 1000)
					on = 2
					for(var/obj/effect/landmark/santa/C in world)
						new/obj/effect/santaripley(C.loc)
						world << "Santa has arrived north of the workshop!"
						var/datum/effect/effect/system/harmless_smoke_spread/s = new /datum/effect/effect/system/harmless_smoke_spread
						s.set_up(4, 1, src, 0)
						s.start()
	attack_hand()
		if(on)
			usr << "The generator has absorbed [spirit] christmas spirit out of the 1000 required."
		else
			usr << "The generator is off!"

/obj/machinery/power/eventgenerator/attackby(var/obj/item/weapon/reagent_containers/food/snacks/cookie/christmas/W, var/mob/user)
	if(on)
		user << "The generator is already on."
	else
		user << "You insert the Christmas Cookie into the generator, turning it on."
		on = 1
		user.drop_item(W)
		del(W)

/obj/effect/fakenarsie
	name = "NAR-SIE"
	desc = "Rumored to hunger for your soul..."
	icon = 'icons/obj/magic_terror.dmi'


/obj/effect/cultbarrier
	name = "barrier"
	icon = 'icons/effects/effects.dmi'
	icon_state = "wavenew"
	damage_resistance = -1
	explosion_resistance = - 1
	health = INFINITY
	density = 1
	anchored = 1
	var/event = 0

/obj/effect/cultbarrier/arena

/obj/effect/cultbarrier/arenadoor/red/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	else if(istype(mover, /mob/living/carbon/human/virtualreality))
		var/mob/living/carbon/human/virtualreality/C = mover
		if(C.teamtype == 1)
			C << "\red You can't enter this teams respawn room!"
			return 0
		else
			return 1
	else if(istype(mover, /obj/item/projectile))
		return prob(0)
	return 1
/obj/effect/cultbarrier/arenadoor/green/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	else if(istype(mover, /mob/living/carbon/human/virtualreality))
		var/mob/living/carbon/human/virtualreality/C = mover
		if(C.teamtype == 2)
			C << "\red You can't enter this teams respawn room!"
			return 0
		else
			return 1
	else if(istype(mover, /obj/item/projectile))
		return prob(0)
	return 1

/obj/effect/spider/stickyweb/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(istype(mover, /mob/living/simple_animal/hostile/giant_spider))
		return 1
	if(istype(mover, /obj/item/projectile/spidervenom))
		return 1
	else if(istype(mover, /mob/living))
		if(prob(50))
			mover << "\red You get stuck in \the [src] for a moment."
			return 1
	else if(istype(mover, /obj/item/projectile))
		return prob(30)
	return 1


/obj/effect/cultbarrier/special
	var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread
/obj/effect/cultbarrier/special/proc/shockeffect()
		src.spark_system.start()
/obj/effect/santaripley
	name = "S.A.N.T.A. SMASH3R"
	desc = "SANTA SMASH"
	icon = 'icons/mecha/mecha.dmi'
	icon_state = "santaripley"
	anchored = 1
	var/mob/living/carbon/human/G = null
	//nodamage = 1

/obj/effect/santaripley/Bump(obj/effect/cultbarrier/D as obj)
	del(D)

/obj/effect/santaripley/Bumped(obj/effect/cultbarrier/D as obj)
	del(D)

/obj/effect/santaripley/New()
	spawn(100)
	//	christmasprog = 1
		world << "Santa has appeared north of the workshop!"
		spawn(100)
			G = new/mob/living/carbon/human
			G.loc = src
			G.name = "Santa"
			G.real_name = "Kris Kringle"
			Path_set(src, list(NORTH),  1, 1,  1, 0)
			spawn(1)
				G.say("YOU WILL PAY FOR THIS WITH MY DYING BREATH!")
				spawn(30)
					G.say("SANTA SMASH!")
					Path_set(src, list(NORTH),  2, 1,  1, 0)
					spawn(100)
					for(var/obj/effect/cultbarrier/special/C in world)
						var/obj/effect/cultbarrier/special/D = C
						D.shockeffect()
						spawn(100)
							del(C)
							src.visible_message("Santa smashes through the barrier!")
							for(var/obj/effect/cultbarrier/G in world)
								del(G)


/obj/effect/lava_controller
	var/list/turf/simulated/floor/plating/lava/vines = list()
	var/list/growth_queue = list()
	var/reached_collapse_size
	var/reached_slowdown_size
	//What this does is that instead of having the grow minimum of 1, required to start growing, the minimum will be 0,
	//meaning if you get the spacevines' size to something less than 20 plots, it won't grow anymore.

	New()
		if(!istype(src.loc,/turf/simulated/floor))
			del(src)

		spawn_lava_piece(src.loc)
		processing_objects.Add(src)

	Del()
		processing_objects.Remove(src)
		..()

	proc/spawn_lava_piece(var/turf/location)
		var/turf/simulated/floor/plating/lava/SV = new(location)
		growth_queue += SV
		vines += SV
		SV.master = src

	process()
		if(!vines)
			del(src) //space  vines exterminated. Remove the controller
			return
		if(!growth_queue)
			del(src) //Sanity check
			return
		if(vines.len >= 250 && !reached_collapse_size)
			reached_collapse_size = 1
		if(vines.len >= 30 && !reached_slowdown_size )
			reached_slowdown_size = 1

		var/length = 0
		if(reached_collapse_size)
			length = 0
		else if(reached_slowdown_size)
			if(prob(25))
				length = 1
			else
				length = 0
		else
			length = 1
		length = min( 30 , max( length , vines.len / 5 ) )
		var/i = 0
		var/list/turf/simulated/floor/plating/lava/queue_end = list()

		for( var/turf/simulated/floor/plating/lava/SV in growth_queue )
			i++
			queue_end += SV
			growth_queue -= SV

			//if(prob(25))
			SV.spread()
			if(i >= length)
				break

		growth_queue = growth_queue + queue_end
		//sleep(5)
		//src.process()