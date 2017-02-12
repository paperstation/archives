/obj/item/stack/medical
	name = "medical pack"
	singular_name = "medical pack"
	icon = 'icons/obj/items.dmi'
	amount = 3
	max_amount = 3
	w_class = 1
	var/heal_brute = 0
	var/heal_burn = 0

/obj/item/stack/medical/attack(mob/living/M as mob, mob/living/user as mob)
	if (M.stat == 2)
		var/t_him = "it"
		if (M.gender == MALE)
			t_him = "him"
		else if (M.gender == FEMALE)
			t_him = "her"
		user << "\red \The [M] is dead, you cannot help [t_him]!"
		return

	if (!istype(M))
		user << "\red \The [src] cannot be applied to [M]!"
		return 1


	if (user)
		if (M != user)
			user.visible_message( \
				"\blue [M] has been applied with [src] by [user].", \
				"\blue You apply \the [src] to [M]." \
			)
		else
			var/t_himself = "itself"
			if (user.gender == MALE)
				t_himself = "himself"
			else if (user.gender == FEMALE)
				t_himself = "herself"

			user.visible_message( \
				"\blue [M] applied [src] on [t_himself].", \
				"\blue You apply \the [src] on yourself." \
			)

	var/zone = user.get_zone(0)
	if(heal_brute)
		M.deal_damage(heal_brute, BRUTE, null, zone)
	if(heal_burn)
		M.deal_damage(heal_burn, BURN, null, zone)
	use(1)
	return

/obj/item/stack/medical/bruise_pack
	name = "bruise pack"
	singular_name = "bruise pack"
	desc = "A pack designed to treat blunt-force trauma."
	icon_state = "brutepack"
	heal_brute = -60
	origin_tech = "biotech=1"

/obj/item/stack/medical/ointment
	name = "ointment"
	desc = "Used to treat those nasty burns."
	gender = PLURAL
	singular_name = "ointment"
	icon_state = "ointment"
	heal_burn = -40
	origin_tech = "biotech=1"



/obj/item/stack/medical/evil/syndibruise
	name = "bruise pack"
	singular_name = "bruise pack"
	desc = "A pack designed to treat blunt-force trauma. The packaging seems off."
	icon_state = "brutepack"
	heal_brute = 20
	origin_tech = "biotech=1"

/obj/item/stack/medical/evil/syndibruise/syndioints
	name = "ointment"
	desc = "Used to treat those nasty burns. The packaging seems off."
	gender = PLURAL
	singular_name = "ointment"
	icon_state = "ointment"
	heal_burn = 30
	origin_tech = "biotech=1"



/*/obj/item/stack/medical/evil/syndioint
	name = "ointment"
	desc = "Used to treat those nasty burns."
	gender = PLURAL
	singular_name = "ointment"
	icon_state = "ointment"
	heal_burn = 30
	origin_tech = "biotech=1"


//I'll add additional damage effects to the ointment eventually
	*/
