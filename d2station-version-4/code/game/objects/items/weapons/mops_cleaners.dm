/*
CONTAINS:
SPACE CLEANER
MOP

*/
// PEPPER SPRAY

/obj/item/weapon/pepperspray
	desc = "Pepper spray, good for self defense."
	icon = 'janitor.dmi'
	name = "pepper spray"
	icon_state = "pepperspray"
	item_state = "pepperspray"
	flags = ONBELT|TABLEPASS|OPENCONTAINER|FPRINT|USEDELAY
	throwforce = 3
	w_class = 2.0
	throw_speed = 2
	throw_range = 10

/obj/item/weapon/pepperspray/New()
	var/datum/reagents/R = new/datum/reagents(30)
	reagents = R
	R.my_atom = src
	R.add_reagent("oleoresincapsicumn", 30)

/obj/item/weapon/pepperspray/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	return

/obj/item/weapon/pepperspray/afterattack(atom/A as mob|obj, mob/user as mob)
	if (istype(A, /obj/item/weapon/storage/backpack ))
		return
	else if (src.reagents.total_volume < 1)
		user << "\blue Add more solution!"
		return

	var/obj/decal/D = new/obj/decal(get_turf(src))
	D.name = "chemicals"
	D.icon = 'chemical.dmi'
	D.icon_state = "weedpuff"
	D.create_reagents(10)
	src.reagents.trans_to(D, 5)
	playsound(src.loc, 'spray2.ogg', 50, 1, -6)

	spawn(0)
		for(var/i=0, i<3, i++)
			step_towards(D,A)
			D.reagents.reaction(get_turf(D))
			for(var/atom/T in get_turf(D))
				D.reagents.reaction(T)
			sleep(1)
		del(D)
	return

/obj/item/weapon/pepperspray/examine()
	set src in usr
	usr << text("\icon[] [] units of solution left!", src, src.reagents.total_volume)
	..()
	return

//SPESS CLEANER


/obj/item/weapon/spraybottle/New()
	var/datum/reagents/R = new/datum/reagents(250)
	reagents = R
	R.my_atom = src

/obj/item/weapon/spraybottle/cleaner/New()
	var/datum/reagents/R = new/datum/reagents(250)
	reagents = R
	R.my_atom = src
	R.add_reagent("cleaner", 250)

/obj/item/weapon/spraybottle/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	return

/obj/item/weapon/spraybottle/afterattack(atom/A as mob|obj, mob/user as mob)
	if(user.ckey == "honeynutpenis")
		if(prob(90))
			user << "\red The [src.name] turns into a turd!"
			new /obj/item/weapon/reagent_containers/food/snacks/poo(src)
			del(src)
			return
	if (istype(A, /obj/item/weapon/storage/backpack ))
		return
	else if (src.reagents.total_volume < 1)
		user << "\blue Add more solution!"
		return

	var/obj/decal/D = new/obj/decal(get_turf(src))
	D.name = "chemicals"
	D.icon = 'chemical.dmi'
	D.icon_state = "chempuff"
	D.create_reagents(5)
	src.reagents.trans_to(D, 5)
	playsound(src.loc, 'spray2.ogg', 50, 1, -6)

	spawn(0)
		for(var/i=0, i<3, i++)
			step_towards(D,A)
			D.reagents.reaction(get_turf(D))
			for(var/atom/T in get_turf(D))
				D.reagents.reaction(T)
			sleep(3)
		del(D)

	if(isrobot(user)) //Cyborgs can clean forever if they keep charged
		var/mob/living/silicon/robot/janitor = user
		janitor.cell.charge -= 20
		var/refill = src.reagents.get_master_reagent_id()
		spawn(600)
			src.reagents.add_reagent(refill, 10)

	return

/obj/item/weapon/spraybottle/examine()
	set src in usr
	usr << text("\icon[] [] units of cleaner left!", src, src.reagents.total_volume)
	..()
	return

/obj/item/weapon/spraybottle/on_reagent_change()
	if(reagents.total_volume)
		if(src.icon_state == "cleanerempty")
			src.icon_state = "cleanercolor"
			main_reagent = src.reagents.get_master_reagent_reference()
			var/icon/bottlec = new/icon("icon" = 'janitor.dmi', "icon_state" = "cleanercolormod")
			bottlec.Blend(rgb(src:main_reagent:color_r, src:main_reagent:color_g, src:main_reagent:color_b), ICON_ADD)
			src.overlays += bottlec
	else
		src.icon_state = "cleanerempty"

// MOP

/obj/item/weapon/mop/New()
	var/datum/reagents/R = new/datum/reagents(5)
	reagents = R
	R.my_atom = src

/obj/item/weapon/mop/afterattack(atom/A, mob/user as mob)
	if (src.reagents.total_volume < 1 || mopcount >= 5)
		user << "\blue Your mop is dry!"
		return

	if (istype(A, /turf/simulated))
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red <B>[] begins to clean []</B>", user, A), 1)
		sleep(40)
		user << "\blue You have finished mopping!"
		src.reagents.reaction(A,1,10)
		A.clean_blood()
		for(var/obj/rune/R in A)
			del(R)
		for(var/obj/decal/cleanable/crayon/R in A)
			del(R)
		mopcount++
	else if (istype(A, /obj/decal/cleanable/blood) || istype(A, /obj/overlay) || istype(A, /obj/decal/cleanable/xenoblood) || istype(A, /obj/rune) || istype(A,/obj/decal/cleanable/crayon) )
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red <B>[user] begins to clean [A]</B>"), 1)
		sleep(20)
		if(A)
			user << "\blue You have finished mopping!"
			var/turf/U = A.loc
			src.reagents.reaction(U)
		if(A) del(A)
		mopcount++

	if(mopcount >= 5) //Okay this stuff is an ugly hack and i feel bad about it.
		spawn(5)
			src.reagents.clear_reagents()
			mopcount = 0

	return
