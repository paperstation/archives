/* Kitchen tools
 * Contains:
 *		Utensils
 *		Spoons
 *		Forks
 *		Knives
 *		Kitchen knives
 *		Butcher's cleaver
 *		Rolling Pins
 *		Trays
 */

/obj/item/weapon/kitchen
	icon = 'icons/obj/kitchen.dmi'

/*
 * Utensils
 */
/obj/item/weapon/kitchen/utensil
	force = DAMAGE_LOW
	w_class = 1.0
	flags = FPRINT | TABLEPASS | CONDUCT
	origin_tech = "materials=1"
	attack_verb = list("attacked", "stabbed", "poked")

	New()
		if (prob(60))
			src.pixel_y = rand(0, 4)
		return

/*
 * Spoons
 */
 /obj/item/weapon/kitchen/utensil/spoon
	name = "spoon"
	desc = "SPOON!"
	icon_state = "spoon"
	forcetype = PIERCE


/*
 * Forks
 */
/obj/item/weapon/kitchen/utensil/fork
	name = "fork"
	desc = "Pointy."
	icon_state = "fork"
	forcetype = PIERCE

/*
 * Knives
 */
/obj/item/weapon/kitchen/utensil/knife
	name = "knife"
	desc = "Can cut through any food."
	icon_state = "knife"
	force = DAMAGE_LOW
	forcetype = SLASH
	hit_sound = list('sound/weapons/bladeslice.ogg')

	suicide_act(mob/user)
		viewers(user) << pick("\red <b>[user] slits \his wrists with the [src.name]!</b>", \
							"\red <b>[user] slits \his throat with the [src.name]!</b>", \
							"\red <b>[user] slits \his stomach open with the [src.name]!</b>")
		return (BRUTELOSS)


/*
 * Kitchen knives
 */
/obj/item/weapon/kitchenknife
	name = "kitchen knife"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "knife"
	desc = "A general purpose Chef's Knife made by SpaceCook Incorporated. Guaranteed to stay sharp for years to come."
	flags = FPRINT | TABLEPASS | CONDUCT
	force = DAMAGE_MED
	forcetype = SLASH
	m_amt = 12000
	origin_tech = "materials=1"
	attack_verb = list("slashed", "stabbed", "sliced", "diced", "cut")
	hit_sound = 'sound/weapons/bladeslice.ogg'
	var/cooldown = 0
	suicide_act(mob/user)
		viewers(user) << pick("\red <b>[user] slits \his wrists with the [src.name]!</b>", \
							"\red <b>[user] slits \his throat with the [src.name]!</b>", \
							"\red <b>[user] slits \his stomach open with the [src.name]!</b>")
		return (BRUTELOSS)

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/kitchenknife))
			if(cooldown < world.time - 25)
				user.visible_message("<span class='warning'>[user] slashes the knifes together!</span>")
				playsound(user.loc, 'sound/effects/knifesharp.ogg', 50, 1)
				cooldown = world.time
		else
			..()


/obj/item/weapon/kitchenknife/ritual
	name = "ritual knife"
	desc = "The unearthly energies that once powered this blade are now dormant."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "render"

/*
 * Bucher's cleaver
 */
/obj/item/weapon/butch
	name = "butcher's Cleaver"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "butch"
	desc = "A huge thing used for chopping and chopping up meat. This includes clowns and clown-by-products."
	flags = FPRINT | TABLEPASS | CONDUCT
	force = DAMAGE_HIGH
	forcetype = SLASH
	w_class = 3
	m_amt = 12000
	origin_tech = "materials=1"
	attack_verb = list("cleaved", "slashed", "stabbed", "sliced", "diced", "cut")
	hit_sound = 'sound/weapons/bladeslice.ogg'

/*
 * Rolling Pins
 */

/obj/item/weapon/kitchen/rollingpin
	name = "rolling pin"
	desc = "Used to knock out the Bartender."
	icon_state = "rolling_pin"
	force = DAMAGE_MED
	w_class = 3.0
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")


/*
 * Trays - Agouri
 */
/obj/item/weapon/tray
	name = "tray"
	icon = 'icons/obj/food.dmi'
	icon_state = "tray"
	desc = "A metal tray to lay food on."
	force = DAMAGE_LOW
	flags = FPRINT | TABLEPASS | CONDUCT
	m_amt = 3000

	attack_verb = list("slammed", "battered", "bludgeoned", "whacked")
	hit_sound = list('sound/items/trayhit1.ogg', 'sound/items/trayhit2.ogg')

	var/list/carrying = list() // List of things on the tray. - Doohl
	var/max_carry = 10 // w_class = 1 -- takes up 1
					   // w_class = 2 -- takes up 3
					   // w_class = 3 -- takes up 5

/obj/item/weapon/tray/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	// Drop all the things. All of them.
	overlays.Cut()
	for(var/obj/item/I in carrying)
		I.loc = M.loc
		carrying.Remove(I)
		if(isturf(I.loc))
			spawn()
				for(var/i = 1, i <= rand(1,2), i++)
					if(I)
						step(I, pick(NORTH,SOUTH,EAST,WEST))
						sleep(rand(2,4))

	return ..()


/*
===============~~~~~================================~~~~~====================
=																			=
=  Code for trays carrying things. By Doohl for Doohl erryday Doohl Doohl~  =
=																			=
===============~~~~~================================~~~~~====================
*/
/obj/item/weapon/tray/proc/calc_carry()
	// calculate the weight of the items on the tray
	var/val = 0 // value to return

	for(var/obj/item/I in carrying)
		if(I.w_class == 1.0)
			val ++
		else if(I.w_class == 2.0)
			val += 3
		else
			val += 5

	return val

/obj/item/weapon/tray/pickup(mob/user)

	if(!isturf(loc))
		return

	for(var/obj/item/I in loc)
		if( I != src && !I.anchored && !istype(I, /obj/item/clothing/under) && !istype(I, /obj/item/clothing/suit) && !istype(I, /obj/item/projectile) )
			var/add = 0
			if(I.w_class == 1.0)
				add = 1
			else if(I.w_class == 2.0)
				add = 3
			else
				add = 5
			if(calc_carry() + add >= max_carry)
				break

			I.loc = src
			carrying.Add(I)
			overlays += image("icon" = I.icon, "icon_state" = I.icon_state, "layer" = 30 + I.layer)

/obj/item/weapon/tray/dropped(mob/user)

	var/mob/living/M
	for(M in src.loc) //to handle hand switching
		return

	var/foundtable = 0
	for(var/obj/structure/table/T in loc)
		foundtable = 1
		break

	overlays.Cut()

	for(var/obj/item/I in carrying)
		I.loc = loc
		carrying.Remove(I)
		if(!foundtable && isturf(loc))
			// if no table, presume that the person just shittily dropped the tray on the ground and made a mess everywhere!
			spawn()
				for(var/i = 1, i <= rand(1,2), i++)
					if(I)
						step(I, pick(NORTH,SOUTH,EAST,WEST))
						sleep(rand(2,4))
