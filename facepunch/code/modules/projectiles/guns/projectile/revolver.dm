/obj/item/weapon/gun/projectile/detective
	desc = "A cheap Martian knock-off of a Smith & Wesson Model 10. Uses .38-Special rounds."
	name = "revolver"
	icon_state = "detective"
	max_shells = 6
	caliber = "38"
	origin_tech = "combat=2;materials=2"
	ammo_type = "/obj/item/ammo_casing/c38"
	ejectshell = 0
	w_class = 2
	locked = 1//Not 100% sure if this should be locked but meh


	special_check(var/mob/living/carbon/human/M)
		if(caliber != initial(caliber))
			if(prob(10))
				M << "<span class='danger'>[src] blows up in your face.</span>"
				M.deal_damage(20, BURN, PIERCE)
				M.drop_item()
				del(src)
				return 0
		..()
		return 1


	verb/rename_gun()
		set name = "Name Gun"
		set category = "Object"
		set desc = "Click to rename your gun. If you're the detective."

		var/mob/M = usr
		if(!M.mind)	return 0
		if(!M.mind.assigned_role == "Detective")
			M << "<span class='notice'>You don't feel cool enough to name this gun, chump.</span>"
			return 0

		var/input = stripped_input(usr,"What do you want to name the gun?", ,"", MAX_NAME_LEN)
		if(src && input && !M.stat && in_range(M,src))
			name = input
			M << "You name the gun [input]. Say hello to your new friend."
			return 1


	attackby(var/obj/item/A as obj, mob/user as mob)
		..()
		if(istype(A, /obj/item/weapon/screwdriver))
			if(caliber == "38")
				user << "<span class='notice'>You begin to reinforce the barrel of [src].</span>"
				if(loaded.len)
					afterattack(user, user)	//you know the drill
					playsound(user, fire_sound, 50, 1)
					user.visible_message("<span class='danger'>[src] goes off!</span>", "<span class='danger'>[src] goes off in your face!</span>")
					return
				if(do_after(user, 30))
					if(loaded.len)
						user << "<span class='notice'>You can't modify it!</span>"
						return
					caliber = "357"
					desc = "The barrel and chamber assembly seems to have been modified."
					user << "<span class='warning'>You reinforce the barrel of [src]! Now it will fire .357 rounds.</span>"
			else
				user << "<span class='notice'>You begin to revert the modifications to [src].</span>"
				if(loaded.len)
					afterattack(user, user)	//and again
					playsound(user, fire_sound, 50, 1)
					user.visible_message("<span class='danger'>[src] goes off!</span>", "<span class='danger'>[src] goes off in your face!</span>")
					return
				if(do_after(user, 30))
					if(loaded.len)
						user << "<span class='notice'>You can't modify it!</span>"
						return
					caliber = "38"
					desc = initial(desc)
					user << "<span class='warning'>You remove the modifications on [src]! Now it will fire .38 rounds.</span>"




/obj/item/weapon/gun/projectile/mateba
	name = "mateba"
	desc = "When you absolutely, positively need a 10mm hole in the other guy. Uses .357 ammo."	//>10mm hole >.357
	icon_state = "mateba"
	origin_tech = "combat=2;materials=2"
	ejectshell = 0


// A gun to play Russian Roulette!
// You can spin the chamber to randomize the position of the bullet.

/obj/item/weapon/gun/projectile/russian
	name = "Russian Revolver"
	desc = "A Russian made revolver. Uses .357 ammo. It has a single slot in it's chamber for a bullet."
	max_shells = 6
	origin_tech = "combat=2;materials=2"
	ejectshell = 0


	New()
		Spin()
		update_icon()


	proc/Spin()
		for(var/obj/item/ammo_casing/AC in loaded)
			del(AC)
		loaded = list()
		var/random = rand(1, max_shells)
		for(var/i = 1; i <= max_shells; i++)
			if(i != random)
				loaded += i // Basically null
			else
				loaded += new ammo_type(src)


	attackby(var/obj/item/A as obj, mob/user as mob)
		if(!A) return
		var/num_loaded = 0
		if(istype(A, /obj/item/ammo_magazine))

			if((load_method == 2) && loaded.len)	return
			var/obj/item/ammo_magazine/AM = A
			for(var/obj/item/ammo_casing/AC in AM.stored_ammo)
				if(getAmmo() > 0 || loaded.len >= max_shells)
					break
				if(AC.caliber == caliber && loaded.len < max_shells)
					AC.loc = src
					AM.stored_ammo -= AC
					loaded += AC
					num_loaded++
				break
			A.update_icon()

		if(num_loaded)
			user.visible_message("<span class='warning'>[user] loads a single bullet into the revolver and spins the chamber.</span>", "<span class='warning'>You load a single bullet into the chamber and spin it.</span>")
		else
			user.visible_message("<span class='warning'>[user] spins the chamber of the revolver.</span>", "<span class='warning'>You spin the revolver's chamber.</span>")
		if(getAmmo() > 0)
			Spin()
		update_icon()
		return


	attack_self(mob/user as mob)
		user.visible_message("<span class='warning'>[user] spins the chamber of the revolver.</span>", "<span class='warning'>You spin the revolver's chamber.</span>")
		if(getAmmo() > 0)
			Spin()


	attack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj)
		if(!loaded.len)
			user.visible_message("\red *click*", "\red *click*")
			return

		if(isliving(target) && isliving(user))
			if(target == user)
				var/affecting = user.zone_sel.selecting
				if(affecting == "head")
					if(!load_into_chamber())
						user.visible_message("\red *click*", "\red *click*")
						return
					if(!in_chamber)
						return
					playsound(user, fire_sound, 50, 1)
					user.visible_message("<span class='danger'>[user.name] fires [src] at \his head!</span>", "<span class='danger'>You fire [src] at your head!</span>", "You hear a [istype(in_chamber, /obj/item/projectile/beam) ? "laser blast" : "gunshot"]!")
					user.deal_damage(300, BRUTE, PIERCE, affecting) // You are dead, dead, dead.
					return
		..()




/obj/item/weapon/gun/projectile/raigun
	desc = "Once owned by the man with the broken gun. One shot; yeah thats just about it."
	name = "Broken Gun"
	icon_state = "somegun"
	max_shells = 1
	caliber = ".357"
	origin_tech = "combat=1;materials=1"
	ammo_type = "/obj/item/ammo_casing/c45"





/obj/item/weapon/gun/projectile/mp80
	name = "MP-80"
	desc = "A submachine gun chambered in 9mm designed for security personnel, it uses a straight blowback action on a closed bolt, it's semi automatic only."
	icon_state = "mp80"
	w_class = 3.0
	max_shells = 10
	caliber = "9mm"
	origin_tech = "combat=5;materials=2"
	ammo_type = "/obj/item/ammo_casing/c9mm"