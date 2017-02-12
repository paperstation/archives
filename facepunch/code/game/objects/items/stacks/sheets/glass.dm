/* Glass stack types
 * Contains:
 *		Glass sheets
 *		Reinforced glass sheets
 *		Glass shards - TODO: Move this into code/game/object/item/weapons
 */

/*
 * Glass sheets
 */
/obj/item/stack/sheet/glass
	name = "glass"
	desc = "A large stack of glass."
	singular_name = "glass sheet"
	icon_state = "sheet-glass"
	g_amt = 3750
	origin_tech = "materials=1"


	attack_self(mob/user as mob)
		construct_window(user)
		return


	attackby(obj/item/W, mob/user)
		..()
		if(istype(W,/obj/item/weapon/cable_coil))
			var/obj/item/weapon/cable_coil/CC = W
			if(CC.amount < 5)
				user << "\b There is not enough wire in this coil. You need 5 lengths."
				return
			CC.use(5)
			user << "\blue You attach wire to the [name]."
			new /obj/item/stack/light_w(user.loc)
			src.use(1)
		else if( istype(W, /obj/item/stack/rods) )
			var/obj/item/stack/rods/V  = W
			var/obj/item/stack/sheet/rglass/RG = new (user.loc)
			RG.add_fingerprint(user)
			RG.add_to_stacks(user)
			V.use(1)
			var/obj/item/stack/sheet/glass/G = src
			src = null
			var/replace = (user.get_inactive_hand()==G)
			G.use(1)
			if (!G && !RG && replace)
				user.put_in_hands(RG)
		else
			return ..()


	proc/construct_window(mob/user as mob)
		if(!user || !src)	return 0
		if(!istype(user.loc,/turf)) return 0
		if(!user.IsAdvancedToolUser())
			user << "\red You don't have the dexterity to do this!"
			return 0
		if(!src)	return 0
		if(src.loc != user)	return 0
		if(src.amount < 2)
			user << "\red You need more glass to do that."
			return 0
		if(locate(/obj/structure/window) in user.loc)
			user << "\red There is a window in the way."
			return 0
		var/obj/structure/window/W
		W = new /obj/structure/window/basic( user.loc, 0 )
		W.dir = SOUTHWEST
		W.anchored = 0
		src.use(2)
		return 1


/*
 * Reinforced glass sheets
 */
/obj/item/stack/sheet/rglass
	name = "reinforced glass"
	desc = "Glass which seems to have rods stuck in it."
	singular_name = "reinforced glass sheet"
	icon_state = "sheet-rglass"
	g_amt = 3750
	m_amt = 1875
	origin_tech = "materials=2"


	attack_self(mob/user as mob)
		construct_window(user)
		return


	proc/construct_window(mob/user as mob)
		if(!user || !src)	return 0
		if(!istype(user.loc,/turf)) return 0
		if(!user.IsAdvancedToolUser())
			user << "\red You don't have the dexterity to do this!"
			return 0
		if(!src)	return 0
		if(src.loc != user)	return 0
		if(src.amount < 2)
			user << "\red You need more glass to do that."
			return 0
		if(locate(/obj/structure/window) in user.loc)
			user << "\red There is a window in the way."
			return 0
		var/obj/structure/window/W
		W = new /obj/structure/window/reinforced( user.loc, 1 )
		W.state = 0
		W.anchored = 0
		src.use(2)
		return 1


/obj/item/stack/sheet/rglass/cyborg
	name = "reinforced glass"
	desc = "Glass which seems to have rods stuck in it."
	singular_name = "reinforced glass sheet"
	icon_state = "sheet-rglass"
	g_amt = 0
	m_amt = 0



//Not sure if this should be in this file but it works for now
/obj/item/weapon/shard
	name = "shard"
	icon = 'icons/obj/shards.dmi'
	icon_state = "large"
	desc = "A large chunk of broken glass."
	w_class = 1.0
	force = DAMAGE_LOW
	item_state = "shard-glass"
	g_amt = 3750
	attack_verb = list("stabbed", "slashed", "sliced", "cut")
	hit_sound = 'sound/weapons/bladeslice.ogg'

	suicide_act(mob/user)
		viewers(user) << pick("\red <b>[user] slits \his wrists with the shard of glass!</b>", \
							"\red <b>[user] slits \his throat with the shard of glass!</b>")
		return (BRUTELOSS)


	Bump()
		spawn( 0 )
			if (prob(20))
				src.force = 10
			else
				src.force = 4
			..()
			return
		return


	New()
		src.icon_state = pick("large", "medium", "small")
		switch(src.icon_state)
			if("small")
				src.pixel_x = rand(-12, 12)
				src.pixel_y = rand(-12, 12)
			if("medium")
				src.pixel_x = rand(-8, 8)
				src.pixel_y = rand(-8, 8)
			if("large")
				src.pixel_x = rand(-5, 5)
				src.pixel_y = rand(-5, 5)
			else
		return


	attackby(obj/item/weapon/W as obj, mob/user as mob)
		..()
		if ( istype(W, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/WT = W
			if(WT.remove_fuel(0, user))
				var/obj/item/stack/sheet/glass/NG = new (user.loc)
				for (var/obj/item/stack/sheet/glass/G in user.loc)
					if(G==NG)
						continue
					if(G.amount>=G.max_amount)
						continue
					G.attackby(NG, user)
					usr << "You add the newly-formed glass to the stack. It now contains [NG.amount] sheets."
				//SN src = null
				del(src)
				return
		return ..()


	HasEntered(AM as mob|obj)
		if(ismob(AM))
			var/mob/M = AM
			M << "\red <B>You step in the broken glass!</B>"
			playsound(src.loc, 'sound/effects/glass_step.ogg', 50, 1)
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(!H.shoes)
					H.deal_damage(5, BRUTE, SLASH, "legs")
					H.deal_damage(3, WEAKEN, SLASH, "legs")
		..()
		return