/* Weapons
 * Contains:
 *		Banhammer
 *		Sword
 *		Classic Baton
 *		Energy Blade
 *		Energy Axe
 *		Energy Shield
 */

/*
 * Banhammer
 */
/obj/item/weapon/banhammer/attack(mob/M as mob, mob/user as mob)
	M << "<font color='red'><b> You have been banned FOR NO REISIN by [user]<b></font>"
	user << "<font color='red'> You have <b>BANNED</b> [M]</font>"

/*
 * Sword
 */
/*
 * Classic Baton
 */
/obj/item/weapon/melee/classic_baton
	name = "police baton"
	desc = "A wooden truncheon for beating criminal scum."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "baton"
	item_state = "classic_baton"
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_BELT
	force = DAMAGE_MED

/*
 *Chainsword
 */

/obj/item/weapon/melee/chainsword
	name = "Chain Sword"
	desc = "An imperium sword with motorized teeth than run along the blade. These monomolecure edged reazor sharp teeth make an angry buzzing sound as they spin and are capable of cutting through any foe."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "chainsword_bloodravens"
	item_state = "chainsword_bloodravens"
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_BACK
	force = DAMAGE_EXTREME
	forcetype = SLASH
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hit_sound = 'sound/weapons/chainsword.ogg'


/obj/item/weapon/melee/chainsword/attack(mob/M as mob, mob/living/user as mob)
	if ((CLUMSY in user.mutations) && prob(50))
		user << "\red You slice yourself."
		user.deal_damage(2*force, BRUTE, SLASH, "head")
		return
	..()
	return

/obj/item/weapon/melee/chainsword/ultramarines
	icon_state = "chainsword_ultramarines"
	item_state = "chainsword_ultramarines"

/*
 *Energy Blade
 */
//Most of the other special functions are handled in their own files.

/obj/item/weapon/melee/energy/sword/green
	New()
		variant = "green"

/obj/item/weapon/melee/energy/sword/red
	New()
		variant = "red"

/obj/item/weapon/melee/energy/blade/New()
	spark_system = new /datum/effect/effect/system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	return

/obj/item/weapon/melee/energy/blade/dropped()
	del(src)
	return

/obj/item/weapon/melee/energy/blade/proc/throw()
	del(src)
	return

/*
 * Energy Axe
 */
/obj/item/weapon/melee/energy/axe/attack(target as mob, mob/user as mob)
	..()

/obj/item/weapon/melee/energy/axe/attack_self(mob/user as mob)
	src.active = !( src.active )
	if (src.active)
		user << "\blue The axe is now energised."
		src.force = 150
		src.icon_state = "axe1"
		src.w_class = 5
	else
		user << "\blue The axe can now be concealed."
		src.force = 40
		src.icon_state = "axe0"
		src.w_class = 5
	src.add_fingerprint(user)
	return
