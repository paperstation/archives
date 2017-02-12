//Cat
/mob/living/simple_animal/cat
	name = "cat"
	desc = "Kitty!!"
	icon_state = "cat"
	icon_living = "cat"
	icon_dead = "cat_dead"
	speak = list("Meow!","Esp!","Purr!","HSSSSS")
	speak_emote = list("purrs", "meows")
	emote_hear = list("meows","mews")
	emote_see = list("shakes its head", "shivers")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"

//RUNTIME IS ALIVE! SQUEEEEEEEE~
/mob/living/simple_animal/cat/Runtime
	name = "Runtime"
	desc = ""
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	var/turns_since_scan = 0
	var/mob/living/simple_animal/mouse/movement_target

	New()
		..()
		if(Holiday == "April Fool's Day")
			name = "Legison"
			desc = "Looks a little blood thirsty."
			icon_state = "horselegs"
			icon_living = "horselegs"
			icon_dead = "horselegs-dead"
			icon = 'icons/mob/spacefuneral.dmi'
			speak = list("ROAR", "GRRRRR!")
			speak_emote = list("howls")
			emote_hear = list("roars")

/mob/living/simple_animal/cat/Runtime/Life()
	//MICE!
	if((src.loc) && isturf(src.loc))
		if(!stat && !resting && !buckled)
			for(var/mob/living/simple_animal/mouse/M in view(1,src))
				if(!M.stat)
					M.splat()
					emote("splats \the [M]")
					movement_target = null
					stop_automated_movement = 0
					break

	..()

	if(!stat && !resting && !buckled)
		turns_since_scan++
		if(turns_since_scan > 5)
			walk_to(src,0)
			turns_since_scan = 0
			if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
				movement_target = null
				stop_automated_movement = 0
			if( !movement_target || !(movement_target.loc in oview(src, 3)) )
				movement_target = null
				stop_automated_movement = 0
				for(var/mob/living/simple_animal/mouse/snack in oview(src,3))
					if(isturf(snack.loc) && !snack.stat)
						movement_target = snack
						break
			if(movement_target)
				stop_automated_movement = 1
				walk_to(src,movement_target,0,3)



/mob/living/simple_animal/cat/syndicat
	name = "Syndicat"
	desc = "The latest in robocat technology."
	icon_state = "syndicat"
	icon_living = "syndicat"
	icon_dead = "syndicat_dead"
	speak = list("Me-ow!","I am a real cat.","Me-ow, Me-ow, Me-ow; I am a real cat.","I do cat things.")
	speak_emote = list("boops", "beeps")
	emote_hear = list("beeps","boops")
	emote_see = list("shakes its head", "shivers")
	speak_chance = 1
	turns_per_move = 6
	see_in_dark = 6
	response_help  = "pats the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"