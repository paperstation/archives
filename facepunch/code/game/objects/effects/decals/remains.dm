/obj/effect/decal/remains/human
	name = "remains"
	desc = "They look like human remains."
	gender = PLURAL
	icon = 'icons/effects/blood.dmi'
	icon_state = "remains"
	anchored = 0

/obj/effect/decal/remains/human/skel
	name = "remains"
	desc = "They look like human remains."
	gender = PLURAL
	icon = 'icons/effects/blood.dmi'
	icon_state = "remains"
	anchored = 0

	New()
		spawn(200)
			visible_message("The human remains reanimates!")
			spawn(1)
				new/mob/living/simple_animal/hostile/skel(src.loc)
				playsound(src.loc, 'sound/mobs/samurai/SkeletonReanimate.ogg', 50, 1)
				del(src)
				return

/obj/effect/decal/remains/xeno
	name = "remains"
	desc = "They look like the remains of something... alien. They have a strange aura about them."
	gender = PLURAL
	icon = 'icons/effects/blood.dmi'
	icon_state = "remainsxeno"
	anchored = 1

/obj/effect/decal/remains/robot
	name = "remains"
	desc = "They look like the remains of something mechanical. They have a strange aura about them."
	gender = PLURAL
	icon = 'icons/mob/robots.dmi'
	icon_state = "remainsrobot"
	anchored = 1