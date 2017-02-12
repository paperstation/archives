
/obj/item/clothing/head/helmet/space/blasto
	name = "blasto co helmet"
	desc = "Blasto Co advanced EOD helmet."
	icon_state = "cardborg_h"
	item_state = "cardborg_h"
	armor = list(impact = 0.4, slash = 0.4, pierce = 0.2, bomb = 1.0, bio = 1.0, rad = 1.0)
	can_remove = 0

/obj/item/clothing/suit/space/blasto
	name = "blasto co advanced eod suit"
	desc = "Blasto Co advanced EOD suit with an attatched underarm grenade launcher."//todo
	icon_state = "cardborg"
	item_state = "cardborg"
	//flags_inv = HIDESHOES
	armor = list(impact = 0.4, slash = 0.4, pierce = 0.2, bomb = 1.0, bio = 1.0, rad = 1.0)
	slowdown = 5
	can_remove = 0
	icon_action_button = "action_blasto"
	action_button_name = "Fire a Grenade."
	var/list/grenades = new/list()
	var/grenadenum = 5
	var/canfire = 1



/obj/item/clothing/suit/space/blasto/proc/blastogrenadeo(atom/target, mob/user)
	if(canfire && grenadenum >= 1)
		var/mob/living/S1 = usr
		var/obj/item/weapon/grenade/chem_grenade/blasto/A = new /obj/item/weapon/grenade/chem_grenade/blasto( S1.loc )
		playsound(S1.loc, 'sound/weapons/armbomb.ogg', 25, 1)
		spawn()
			grenadenum--
			S1 << "You fire a grenade from the underarm attachment.You have [grenadenum] grenades left."
			A.dir = S1.dir
			Path_set(A, list(S1.dir),  0, 6,  1, 0)
			spawn()//Let it finish first
				explosion(A, 1, 2, 3, 4)




/obj/item/clothing/suit/space/blasto/ui_action_click()
	if( src in usr )
		blastogrenadeo()

/*
		if(canfire)
			icon_state="fire2"
			canfire = 0
			for(var/mob/living/simple_animal/starship/S1 in world)
				var/obj/item/projectile/beam/emitter/A = new /obj/item/projectile/beam/deathray( S1.loc )
				playsound(S1.loc, 'sound/effects/shoot.ogg', 25, 1)
				var/area/shuttle/starship/Z = locate(/area/station/starship)in world
				for(var/mob/living/C in Z)
					playsound(Z, 'sound/effects/hit.ogg', 25, 1)
					shake_camera(Z, 2, 1) // buckled, not a lot of shaking
				A.dir = S1.dir
				switch(S1.dir)
					if(NORTH)
						A.yo = 20
						A.xo = 0
					if(EAST)
						A.yo = 0
						A.xo = 20
					if(WEST)
						A.yo = 0
						A.xo = -20
					else
						A.yo = -20
						A.xo = 0
				A.process()
				spawn(50)
					canfire = 1
					icon_state="fire1"
					usr << "Laser is off cooldown"
*/


/obj/item/clothing/under/blasto
	name = "blasto co jumpsuit"
	desc = "Blasto Co jumpsuit."
	icon_state = "syndicate"
	item_state = "bl_suit"
	variant = "syndicate"

/obj/item/clothing/shoes/skates
	name = "blasto co spess rollerskates"
	desc = "A pair of black shoes with wheels."
	icon_state = "rollerskates"
	variant = "rollerskates"
	slowdown = -5



/obj/structure/closet/suit/syndicate/blasto
	name = "blasto suit"
	desc = "Formerly deconstruction experts, now part of the Syndicate."
	icon_state = "black"
	icon_closed = "black"

	New()
		..()
		sleep(2)
		new/obj/item/weapon/tank/jetpack/oxygen(src)
		new/obj/item/clothing/shoes/skates(src)
		new/obj/item/clothing/under/blasto(src)
		new/obj/item/clothing/suit/space/blasto(src)
		new/obj/item/clothing/head/helmet/space/blasto(src)
		new/obj/item/clothing/gloves/combat(src)
		new/obj/item/clothing/mask/breath(src)
		new/obj/item/weapon/implanter/blasto(src)

