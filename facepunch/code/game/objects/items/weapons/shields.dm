/obj/item/weapon/shield
	name = "shield"

/obj/item/weapon/shield/riot
	name = "riot shield"
	desc = "A shield adept at blocking blunt objects from connecting with the torso of the shield wielder."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "riot"
	slot_flags = SLOT_BACK
	force = DAMAGE_LOW
	w_class = 4.0
	g_amt = 7500
	m_amt = 1000
	origin_tech = "materials=2"
	attack_verb = list("shoved", "bashed")
	var/cooldown = 0 //shield bash cooldown. based on world.time

	IsShield()
		return 1

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/melee/baton))
			if(cooldown < world.time - 25)
				user.visible_message("<span class='warning'>[user] bashes [src] with [W]!</span>")
				playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
				cooldown = world.time
		else
			..()

/obj/item/weapon/shield/riot/adam
	name = "riot shield"
	desc = "Made of adamantite."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "riotad"


/obj/item/weapon/shield/energy
	name = "energy combat shield"
	desc = "A shield capable of stopping most projectile and melee attacks. It can be retracted, expanded, and stored anywhere."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "eshield0" // eshield1 for expanded
	flags = FPRINT | TABLEPASS| CONDUCT
	force = DAMAGE_LOW
	w_class = 1
	origin_tech = "materials=4;magnets=3;syndicate=4"
	attack_verb = list("shoved", "bashed")
	var/active = 0
	var/cooldown = 0 //based on world.time


	IsShield()
		if(active)
			return 1
		else
			return 0


	attack_self(mob/living/user as mob)
		if(cooldown > world.time)
			return
		cooldown = world.time+30
		active = !active
		if (active)
			force = 10
			icon_state = "eshield[active]"
			w_class = 4
			playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
			user << "\blue [src] is now active."
		else
			force = 3
			icon_state = "eshield[active]"
			w_class = 1
			playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
			user << "\blue [src] can now be concealed."
		add_fingerprint(user)
		return


/obj/item/weapon/cloaking_device
	name = "cloaking device"
	desc = "Use this to become invisible to the human eyesocket."
	icon = 'icons/obj/device.dmi'
	icon_state = "shield0"
	var/active = 0.0
	flags = FPRINT | TABLEPASS| CONDUCT
	item_state = "electronic"
	w_class = 2.0
	origin_tech = "magnets=3;syndicate=4"
	var/cooldown = 0 //based on world.time


	attack_self(mob/user as mob)
		if(cooldown > world.time)
			return
		cooldown = world.time+30
		src.active = !( src.active )
		if (src.active)
			user << "\blue The cloaking device is now active."
			src.icon_state = "shield1"
		else
			user << "\blue The cloaking device is now inactive."
			src.icon_state = "shield0"
		src.add_fingerprint(user)
		return


	emp_act(severity)
		active = 0
		icon_state = "shield0"
		if(ismob(loc))
			loc:update_icons()
		..()
