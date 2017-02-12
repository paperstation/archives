/obj/item/ammo_casing/a418
	desc = "A .418 bullet casing."
	calibre = "9.1"
	projectile_type = "/obj/item/projectile/suffocationbullet"


/obj/item/ammo_casing/a75
	desc = "A .75 bullet casing."
	calibre = "6.1"
	projectile_type = "/obj/item/projectile/gyro"


/obj/item/ammo_casing/a666
	desc = "A .666 bullet casing."
	calibre = "9.1"
	projectile_type = "/obj/item/projectile/cyanideround"


/obj/item/ammo_casing/c38
	desc = "A .38 bullet casing."
	calibre = "9.1"
	projectile_type = "/obj/item/projectile/weakbullet"


/obj/item/ammo_casing/cT38
	desc = "A .38 taser casing."
	icon_state = "t-casing"
	calibre = "9.1"
	projectile_type = "/obj/item/projectile/electrode"


/obj/item/ammo_casing/c9mm
	desc = "A 9mm bullet casing."
	calibre = "9.0"
	projectile_type = "/obj/item/projectile/midbullet"


/obj/item/ammo_casing/c45
	desc = "A .45 bullet casing."
	calibre = "11.4"
	projectile_type = "/obj/item/projectile/midbullet"


/obj/item/ammo_casing/c57
	desc = "A 5.7x28mm bullet casing."
	calibre = "5.7"
	projectile_type = "/obj/item/projectile/midbullet"


/obj/item/ammo_casing/c50ae
	desc = "A .50 Action Express bullet casing."
	calibre = "12.7"
	projectile_type = "/obj/item/projectile/strongbullet"


/obj/item/ammo_casing/shotgun
	name = "shotgun slug shell"
	desc = "A 12 gauge slug shell."
	icon_state = "gshell"
	calibre = "18.5"
	projectile_type = "/obj/item/projectile"
	m_amt = 12500


/obj/item/ammo_casing/shotgun/blank
	name = "shotgun shell"
	desc = "A blank shell."
	icon_state = "blshell"
	m_amt = 250


/obj/item/ammo_casing/shotgun/beanbag
	name = "beanbag shell"
	desc = "A weak beanbag shell."
	icon_state = "bshell"
	projectile_type = "/obj/item/projectile/weakbullet"
	m_amt = 500


/obj/item/ammo_casing/shotgun/stunshell
	name = "stun shell"
	desc = "A stunning shell."
	icon_state = "stunshell"
	projectile_type = "/obj/item/projectile/stunshot"
	m_amt = 2500


/obj/item/ammo_casing/shotgun/dart
	name = "shotgun darts"
	desc = "A dart for use in shotguns."
	icon_state = "blshell" //someone, draw the icon, please.
	projectile_type = "/obj/item/projectile/dart"
	m_amt = 12500

/obj/item/ammo_casing/shotgun/scatter
	name = "shotgun buckshot shell"
	desc = "A 12 gauge shell."
	icon_state = "gshell"
	proj_amt = 8
	projectile_type = "/obj/item/projectile/pellet"
	m_amt = 12500 //someday little fella, some day..-Nernums


/obj/item/ammo_casing/magnetpellet
	name = ""
	desc = ""
	icon_state = " "
	calibre = "magnetrifle"
	projectile_type = "/obj/item/projectile/magnet"

	New()
		..()
		del(src)

