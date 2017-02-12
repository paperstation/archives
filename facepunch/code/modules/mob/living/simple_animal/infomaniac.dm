/mob/living/simple_animal/alienplant/
	name = "Maneater"
	real_name = "Maneater"
	desc = "Something tells me you shouldn't use Robust Harvest on it."
	icon_state = "maneater"
	speak_emote = list("rasps","croaks")
	canmove = 0
	var/usedrh = 0
	var/caneat = 1
	var/target = null

/mob/living/simple_animal/alienplant/HasProximity(atom/movable/AM as mob|obj)
	if(istype(AM,/mob/living/carbon))
		if(caneat)
			caneat = 0
			var/mob/living/carbon/Z = AM
			target = Z
			if(Z.health <= 0)//Hey its a living mob, it has its tastes too!
				caneat = 1
				return 0
			if(!do_mob(src, Z)||!do_after(src, 1)) //If the mob isn't in range, remove the target and let him start checking again
				target = null
				Z = null
				caneat = 1
				return
			src.visible_message("\red The [name] slithers toward [Z.name]!")
			if(!do_mob(src, Z)||!do_after(src, 5))
				target = null
				Z = null
				caneat = 1
				return
			Z.say(pick("WHAT TH-", "WHAT IS THI-", "ONE DAY WHILE ANDY WAS OH SHIT I-", "HELP IT'S EA-"))
			say(pick("NUM NUM NUM", "TASTEY!", "A LITTLE ON THE SPICEY SIDE!","IT TASTES LIKE TOOLBOX!", "COULD USE SOME MORE BRAINS!"))
			src.visible_message("\red [name] gobbles down [Z.name] to pieces!")
			Z.gib()
			caneat = 1
			return 1
		else
			caneat = 1
		return 1
	return 0

/mob/living/simple_animal/alienplant/attackby(obj/item/I as obj, mob/living/user as mob)
	if(usedrh == 0)
		if(istype(I,/obj/item/nutrient/rh))
			usedrh = 1
			src.say("Feed me [user.name]! THATS RIGHT DO IT!")
			sleep(20)
			src.say("BETTA STAY CLEAR CAUSE I'M HUNGRY TONIGHT!!")
			sleep(20)
			src.say("GAAAAAAAGHHHHH! I'M SOOOOO HUNGRY!")
	//		new/obj/effect/spacevine_controller(src.loc) //Smoke spacevine everyday
			caneat = 1

/*
/mob/living/simple_animal/alienplant/Bumped(mob/living/user as mob)
	if(caneat == 1)
		src.visible_message("\red [user.name] has been eaten by the [name]!")
		user.say("FUCKING HELL!")
		sleep(1)
		user.gib()
		sleep(1)
		user.paralysis = "500"
		src.say("WELL ARNT YOU A TASTEY LOOKING LUNCH!!")
		sleep(20)
		src.say("NUM NUM NUM!")
		sleep(20)
		src.visible_message("\red The [name] burps!")
*/



/mob/living/simple_animal/alienplant/Die()
	src.gib()
	src.visible_message("\red The [name] has exploded!")

/*
/mob/living/simple_animal/infomaniac/attackby(obj/item/I as obj, mob/living/user as mob)
	if(istype(I,/obj/item/weapon/match))
		src.say("This is a match! You can use it to light the furnace inside of your office!")

//This is the original code for the Infomaniac NPC; but then I turned it into a plant so this is for reference
	*/