/obj/structure/beerpong
	name = "beer pong"
	desc = "Fun."
	icon_state = "pong"
	icon = 'icons/obj/structures.dmi'
	var/cup1
	var/cup2
	var/cup1balls
	var/cup2balls
	density = 1
	anchored = 1
	var/locked = 0
	attack_hand()
		if(locked)
			locked = 0
			if(cup1balls > cup2balls)
				src.visible_message("Southern player wins.")
				return
			if(cup2balls > cup1balls)
				src.visible_message("Northern player wins.")
				return
			if(cup1balls == cup2balls)
				src.visible_message("Tie. Neither player wins.")
				return
			cup1balls = 0
			cup2balls = 0
			icon_state = "pong"
			icon = 'icons/obj/structures.dmi'
			for(var/obj/item/ball/G in src)
				del(G)
			new/obj/item/weapon/storage/box/balls(src.loc)
			new/obj/item/weapon/storage/box/balls(src.loc)
/obj/structure/beerpong/attackby(obj/O as obj, mob/user as mob)
	if(istype(O, /obj/item/weapon/reagent_containers/food/drinks/beer))
		if(!cup1)
			user.drop_item()
			O.loc = src
			cup1 = O
			user << "You place down the first cup."
			icon = 'icons/obj/scooterstuff.dmi'
			icon_state = "t1"
			return
		if(!cup2)
			user.drop_item()
			O.loc = src
			cup2 = O
			user << "You place down the second cup."
			icon = 'icons/obj/scooterstuff.dmi'
			icon_state = "t2"
			return
		user << "You try to place the beer can onto the table, but you realize you have no reason to place another down."
		return


/obj/structure/beerpong/Bumped(AM as mob|obj)
	..()
	if(istype(AM,/obj/item/ball))
		var/obj/item/ball/H = AM
		if(!cup1) return
		if(!cup2) return
		if(locked) return
		if(H.dir == 1)
			if(prob(50))
				cup1balls++
				src.visible_message("The ball lands in the northern cup")
				for(var/mob/M in range(src,5))
					M.playsound_local(src, 'sound/effects/pingpong.ogg', 5, 1, 1, falloff = 5)
				H.loc = src
				if(cup1balls >= 10)
					locked = 1
				return
			else
				src.visible_message("The ball misses!")
				return
		if(H.dir == 2)
			if(prob(50))
				cup2balls++
				src.visible_message("The ball lands in the southern cup")
				for(var/mob/M in range(src,5))
					M.playsound_local(src, 'sound/effects/pingpong.ogg', 5, 1, 1, falloff = 5)
				H.loc = src
				if(cup2balls >= 10)
					locked = 1
				return
			else
				src.visible_message("The ball misses!")
				return
		else
			src.visible_message("The ball misses because the game is over! Access the table to get the results!")

/obj/item/ball
	name = "ball"
	desc = "For ping-pong"
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "ball"



/obj/item/weapon/storage/box/balls/New()
	..()
	new /obj/item/ball(src)
	new /obj/item/ball(src)
	new /obj/item/ball(src)
	new /obj/item/ball(src)
	new /obj/item/ball(src)
	new /obj/item/ball(src)
	new /obj/item/ball(src)
	new /obj/item/ball(src)
	new /obj/item/ball(src)
	new /obj/item/ball(src)
