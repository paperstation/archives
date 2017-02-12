/mob/living/simple_animal/hostile/creature
	name = "creature"
	desc = "A sanity-destroying otherthing."
	icon = 'icons/mob/critter.dmi'
	speak_emote = list("gibbers")
	icon_state = "otherthing"
	icon_living = "otherthing"
	icon_dead = "otherthing-dead"
	health = 80
	maxHealth = 80
	melee_damage_lower = 25
	melee_damage_upper = 50
	attacktext = "chomps"
	attack_sound = 'sound/weapons/bite.ogg'
	faction = "creature"

/mob/living/simple_animal/hostile/ghoul
	name = "ghoul"
	desc = "A sanity-destroying otherthing."
	icon = 'icons/mob/critter.dmi'
	speak_emote = list("gibbers")
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "ghoul"
	icon_living = "ghoul"
	icon_dead = "ghoul"
	health = 50
	maxHealth = 50
	melee_damage_lower = 2
	melee_damage_upper = 6
	attacktext = "chomps"
	attack_sound = 'sound/weapons/bite.ogg'
	faction = "creature"

	Life()
		..()
		if(stat == 2)
			new/obj/item/weapon/ectoplasm(src.loc)
			visible_message("\red [src] lets out a contented sigh as their form unwinds.")
			ghostize()
			del(src)
			return

	Move()
		..()
		if(stat == 0)
			if(prob(1))
				playsound(src, 'sound/voice/ghoul.ogg', 100, 1)

/mob/living/simple_animal/hostile/ghoul/big
	name = "big ghoul"
	desc = "Formed out of smaller ghouls."
	icon = 'icons/mob/critter.dmi'
	speak_emote = list("gibbers")
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "ghoul"
	icon_living = "ghoul"
	icon_dead = "ghoul"
	health = 200
	maxHealth = 200
	melee_damage_lower = 5
	melee_damage_upper = 10
	attacktext = "chomps"
	attack_sound = 'sound/weapons/bite.ogg'
	faction = "creature"

	Life()
		..()
		if(stat == 2)
			new/obj/item/weapon/ectoplasm(src.loc)
			visible_message("\red [src] splits into smaller ghouls.")
			new/mob/living/simple_animal/hostile/ghoul(src.loc)
			new/mob/living/simple_animal/hostile/ghoul(src.loc)
			new/mob/living/simple_animal/hostile/ghoul(src.loc)
			new/mob/living/simple_animal/hostile/ghoul(src.loc)
			ghostize()
			del(src)
			return

/mob/living/simple_animal/hostile/ghoul/beam
	name = "malformed ghoul"
	desc = "ITS A FIRING ITS LASER!"
	icon = 'icons/mob/critter.dmi'
	speak_emote = list("gibbers")
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "ghoul"
	icon_living = "ghoul"
	icon_dead = "ghoul"
	health = 1000
	maxHealth = 1000
	melee_damage_lower = 5
	melee_damage_upper = 10
	attacktext = "chomps"
	attack_sound = 'sound/weapons/bite.ogg'
	faction = "creature"
	ranged = 1


/mob/living/simple_animal/hostile/ghoul/beam/OpenFire(target_mob)
	var/target = target_mob
	visible_message("\red <b>[src]</b> drains life from [target]!", 1)

	spawn(0)
		Beam(target,"r_beam1",'icons/effects/beam.dmi',5, 2, 10)
		playsound(src, 'sound/weapons/hivebotlaser.ogg', 100, 1)
		if(istype(target, /mob/living/carbon/human))
			var/mob/living/carbon/human/Z = target
			Z.deal_damage(rand(5,15), BURN)
			src.health += 20

	stance = HOSTILE_STANCE_IDLE
	target_mob = null
	return








/mob/living/simple_animal/hostile/skel
	name = "Skeleton"
	desc = "Defense against the dark arts has nothing against this thing."
	icon = 'icons/mob/animal.dmi'
	speak_emote = list("moans")
	//icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "skeleton"
	icon_living = "skeleton"
	icon_dead = "skeleton"
	health = 10
	maxHealth = 10
	melee_damage_lower = 1
	melee_damage_upper = 3
	attacktext = "rattles"
	attack_sound = 'sound/mobs/samurai/skeletonhit.ogg'
	faction = "creature"

	Life()
		..()
		if(stat == 2)
			new/obj/effect/decal/remains/human/skel(src.loc)
			playsound(src.loc, 'sound/mobs/samurai/SkeletonPile.ogg', 50, 1)
			visible_message("\red [src] falls down in a heap.")
			del(src)
			return

	Move()
		..()
		if(prob(15))
			var/Z = rand(1,2)
			switch(Z)
				if(1)
					playsound(src.loc, 'sound/mobs/samurai/skelestep1.ogg', 50, 1)
				if(2)
					playsound(src.loc, 'sound/mobs/samurai/skelestep2.ogg', 50, 1)




/mob/living/simple_animal/hostile/samureye
	name = "Samur-Eye"
	desc = "I see."
	icon = 'icons/mob/critter.dmi'
	icon_state = "samureye"
	pass_flags = PASSBLOB
	health = 200
	melee_damage_lower = 1
	melee_damage_upper = 5
	var/samurainame
	attacktext = "attacks"
	attack_sound = 'sound/weapons/genhit1.ogg'

/mob/living/simple_animal/hostile/samureye/attack_paw(mob/living/carbon/monkey/M as mob)
	attack_hand(M)

/mob/living/simple_animal/hostile/samureye/attack_alien(mob/living/carbon/M as mob)
	attack_hand(M)

/mob/living/simple_animal/hostile/samureye/attack_hand(mob/living/carbon/human/M as mob)
	..()
	if(isliving(M))
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/C = M
			if(prob(25) && !C.weakened)
				C.weakened = 5
				C << "The Samur-Eye knocks you down."
				src << "You have knocked [C.name] down. Attack again to take over."
				return
			if(C.weakened)
				ghostize(C)
				spawn(0)
					C.name = samurainame
					C.real_name = samurainame
					C.equip_samurai()
					C.ckey = src.ckey
					C.key = src.key
					C.client = src.client
				return



/mob/living/simple_animal/hostile/lizard
	name = "lizard warrior"
	desc = "Slimey"
	icon_state = "lizard"
	health = 200
	melee_damage_lower = 1
	melee_damage_upper = 5

	Die()
		src.gib()