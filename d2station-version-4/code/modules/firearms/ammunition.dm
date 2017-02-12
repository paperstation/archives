/* Ammunition!
Calibres measured in millimetres

5.56 = 5.56 NATO					(Not implemented)
5.6  = .22 rimfire					(Not implemented)
5.7  = 5.7x28mm five-seven round
6.1  = gyrojet rocket round
7.8  = .30-06						(Not implemented)
7.82 = 7.62×51mm NATO				(Not implemented)
9.0  = 9mm, self-explanatory
9.1  = .357 round, .38Spc
11.4 = .45 round
12.7 = .50 Action Express
18.5 = 12-gauge shotgun shell

*/


/obj/item/ammo_casing
	name = "bullet casing"
	desc = "A .357 bullet casing."
	icon = 'ammo.dmi'
	icon_state = "s-casing"
	flags = FPRINT | TABLEPASS | CONDUCT | ONBELT
	throwforce = 1
	w_class = 1.0
	var

		calibre = "9.1"								//Which kind of guns and magazines into which it can be loaded. Measured in mm
		projectile_type = "/obj/item/projectile"	//The bullet type to create when New() is called
		obj/item/projectile/BB = list() 			//The loaded bullet
		spent = 0									//If the bullet has already been used
		proj_amt = 1								//how many projectiles come out of the bullet, used for things like shotguns

	New()
		if(projectile_type)
			for(var/i = 0; i < proj_amt, i++)
				BB = new projectile_type(src)


		pixel_x = rand(-10.0, 10)
		pixel_y = rand(-10.0, 10)
		dir = pick(cardinal)
		..()

	update_icon()
		return



//Boxes of ammo
/obj/item/ammo_box
	name = "ammo box (.357)"
	desc = "A box of .357 ammo"
	icon_state = "357"
	icon = 'ammo.dmi'
	flags = FPRINT | TABLEPASS | CONDUCT | ONBELT
	item_state = "syringe_kit"
	m_amt = 50000
	throwforce = 2
	w_class = 1.0
	throw_speed = 4
	throw_range = 10
	origin_tech = "combat=1;materials=1"
	var
		list/stored_ammo = list()


	New()
		for(var/i = 1, i <= 7, i++)
			stored_ammo += new /obj/item/ammo_casing(src)
		update_icon()


	update_icon()
		icon_state = text("[initial(icon_state)]-[]", stored_ammo.len)
		desc = text("There are [] shell\s left!", stored_ammo.len)

//Magazines
/obj/item/ammo_magazine
	icon = 'ammo.dmi'
	icon_state = "5.56s"
	flags = FPRINT | TABLEPASS | CONDUCT | ONBELT
	item_state = "syringe_kit"
	m_amt = 50000
	throwforce = 2
	w_class = 1.0
	throw_speed = 4
	throw_range = 10
	origin_tech = "combat=2;materials=1"
	var
		list/stored_ammo = list()	// Rounds currently in the magazine
		max_ammo = 30				// Maximum capacity
		calibre = "x"				// Magazines can only be loaded into guns with the same calibre

	New()
		update_icon()


	update_icon()
		icon_state = text("[initial(icon_state)]-[]", stored_ammo.len)
		desc = text("There are [] round\s left!", stored_ammo.len)

	attackby(var/obj/item/A as obj, mob/user as mob)
		if(istype(A, /obj/item/ammo_casing))
			var/obj/item/ammo_casing/C = A
			if(C.calibre == calibre)
				if(stored_ammo.len < max_ammo)
					user.drop_item()
					C.loc = src
					stored_ammo += C
					user << text("\blue You load the [] into the [].", C.name, name)
					update_icon()
				else
					user << text("\red The [] is fully loaded!", name)
			else
				user << text("\red The [] is the wrong calibre for this type of magazine.", C.name)
		else ..()