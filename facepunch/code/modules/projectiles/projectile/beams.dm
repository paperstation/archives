/obj/item/projectile/beam
	name = "laser"
	icon_state = "laser"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	force = DAMAGE_EXTREME
	damtype = BURN
	forcetype = PIERCE

	on_hit(var/atom/target, var/blocked = 0)
		if(blocked)
			return 0
		if(istype(target, /mob/living))
			var/mob/living/L = target
			L.deal_damage(force, damtype, forcetype, def_zone)
		return 1


/obj/item/projectile/beam/mediumlaser
	force = 30

/obj/item/projectile/beam/minilaser
	force = 10

/obj/item/projectile/beam/heavylaser
	name = "heavy laser"
	icon_state = "heavylaser"
	force = 40

/obj/item/projectile/beam/xray
	name = "xray beam"
	icon_state = "xray"

/obj/item/projectile/beam/pulse
	name = "pulse"
	icon_state = "u_laser"

	on_hit(var/atom/target, var/blocked = 0)
		..()
		target.ex_act(2)
		return 1

/obj/item/projectile/beam/deathlaser
	name = "death laser"
	icon_state = "heavylaser"
	force = 60

/obj/item/projectile/beam/emitter
	name = "emitter beam"
	icon_state = "emitter"
	force = 30

/obj/item/projectile/beam/deathray
	name = "starship beam"
	icon_state = "pulse0_bl"
	force = 50

/obj/item/projectile/beam/lavaray
	name = "magma"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "pulse0_bl"
	force = 1