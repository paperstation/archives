

/obj/item/ammo_box/magazine/cannon
	name = "cannonball"
	icon_state = "9x19p"
	origin_tech = "combat=2"
	ammo_type = /obj/item/ammo_casing/cannon
	caliber = "cannonball"
	max_ammo = 1
	multiple_sprites = 0


/obj/item/ammo_casing/cannon
	desc = "A 9mm bullet casing."
	caliber = "9mm"
	projectile_type = /obj/item/projectile/bullet/handcannon

/obj/item/weapon/gun/projectile/handcannon
	desc = "YARR HARR"
	name = "projectile gun"
	icon_state = "pistol"
	origin_tech = "combat=2;materials=2"
	w_class = 3.0
	m_amt = 1000
	fire_sound = 'sound/weapons/handcannon.ogg'
	mag_type = /obj/item/ammo_box/magazine/cannon //Removes the need for max_ammo and caliber info




/obj/item/weapon/gun/projectile/cannonball/afterattack(atom/target as mob|obj|turf, mob/living/user as mob|obj, params)
	..()
	user.visible_message("<span class='warning'>The recoil knocks [user] down!</span>", "<span class='warning'>The [src]'s recoil knocks you down!</span>")
	user.apply_effect(2, WEAKEN, 0)