/obj/item/weapon/melee/energy
	var/active = 0
	var/variant

	suicide_act(mob/user)
		viewers(user) << pick("\red <b>[user] slits \his stomach open with the [src.name]! </b>", \
							"\red <b>[user] falls on the [src.name]!</b>")
		return (BRUTELOSS|FIRELOSS)

/obj/item/weapon/melee/energy/axe
	name = "energy axe"
	desc = "An energised battle axe."
	icon_state = "axe0"
	force = 40
	forcetype = PIERCE
	w_class = 3.0
	flags = FPRINT | CONDUCT | NOSHIELD | TABLEPASS
	origin_tech = "combat=3"
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] swings the [src.name] towards /his head! It looks like \he's trying to commit suicide.</b>"
		return (BRUTELOSS|FIRELOSS)

/obj/item/weapon/melee/energy/sword
	name = "energy sword"
	desc = "May the force be within you."
	icon_state = "sword0"
	force = DAMAGE_LOW
	w_class = 2.0
	flags = FPRINT | TABLEPASS | NOSHIELD
	origin_tech = "magnets=3;syndicate=4"
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	var/cooldown = 0 //based on world.time


	IsShield()
		if(active)
			return 1
		return 0


	New()
		variant = pick("red","blue","green","purple")


	attack_self(mob/living/user as mob)
		if(cooldown > world.time)
			return
		cooldown = world.time+30
		if ((CLUMSY in user.mutations) && prob(50))
			user << "\red You accidentally cut yourself with [src]."
			user.deal_overall_damage(5,5)
		active = !active
		if(active)
			force = DAMAGE_EXTREME
			forcetype = PIERCE
			if(istype(src,/obj/item/weapon/melee/energy/sword/pirate))
				icon_state = "cutlass1"
			else
				icon_state = "sword[variant]"
			w_class = 4
			playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
			user << "\blue [src] is now active."
		else
			force = DAMAGE_LOW
			forcetype = IMPACT
			if(istype(src,/obj/item/weapon/melee/energy/sword/pirate))
				icon_state = "cutlass0"
			else
				icon_state = "sword0"
			w_class = 2
			playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
			user << "\blue [src] can now be concealed."
		add_fingerprint(user)
		return



/obj/item/weapon/melee/energy/sword/pirate
	name = "energy cutlass"
	desc = "Arrrr matey."
	icon_state = "cutlass0"

/obj/item/weapon/melee/energy/blade
	name = "energy blade"
	desc = "A concentrated beam of energy in the shape of a blade. Very stylish... and lethal."
	icon_state = "blade"
	force = 70.0//Normal attacks deal very high damage.
	forcetype = SLASH
	w_class = 4.0//So you can't hide it in your pocket or some such.
	flags = FPRINT | TABLEPASS | NOSHIELD
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	var/datum/effect/effect/system/spark_spread/spark_system