/obj/item/weapon/gun/projectile/cannon//Test for the clown traitor item.
	name = "handcannon"
	desc = "A large metal cannon."
	icon_state = "silenced_pistol"
	w_class = 4.0
	max_shells = 1
	caliber = "cannon"
	silenced = 0
	recoil = 1
	origin_tech = "combat=2;materials=2;syndicate=8"
	ammo_type = "/obj/item/ammo_casing/cannon"
	ejectshell = 0

	afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag)
	//TODO: add check to make sure its actually going to fire before knocking down user.
		var/fired = loaded.len
		..()
		if(loaded.len == fired)//We must have fired because we are missing a bullet
			return
		if(!user || flag)	return
		user.visible_message("<span class='warning'>The recoil knocks [user] down!</span>", "<span class='warning'>The [src]'s recoil knocks you down!</span>")
		user.deal_damage(2, WEAKEN)
		return