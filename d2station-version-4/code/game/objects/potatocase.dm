/obj/potatocase
	name = "Centcomm's 'Best Surgeon' Award"
	icon = 'stationobjs.dmi'
	icon_state = "labcage2"
	desc = "An esteemed prize only for the best of surgeons... So they say."
	density = 1
	anchored = 1
	unacidable = 1//Dissolving the case would also delete POTATOE
	var/health = 30
	var/occupied = 2//Ripped Lamarr Case code, so change this var to '2'
	var/destroyed = 0

/obj/potatocase/ex_act(severity)
	switch(severity)
		if (1)
			new /obj/item/weapon/shard( src.loc )
			if (occupied)
				var/obj/item/weapon/reagent_containers/food/snacks/grown/potato/A = new /obj/item/weapon/reagent_containers/food/snacks/grown/potato( src.loc )
				A.name = "Centcomm 'Award'"
				occupied = 0
			del(src)
		if (2)
			if (prob(50))
				src.health -= 15
				src.healthcheck()
		if (3)
			if (prob(50))
				src.health -= 5
				src.healthcheck()

/obj/potatocase/bullet_act(var/obj/item/projectile/Proj)
	if (Proj.flag == "bullet")
		src.health -= 10
		src.healthcheck()
		return
	else
		src.health -= 4
		src.healthcheck()
		return

/obj/potatocase/blob_act()
	if (prob(75))
		new /obj/item/weapon/shard( src.loc )
		if (occupied)
			var/obj/item/weapon/reagent_containers/food/snacks/grown/potato/A = new /obj/item/weapon/reagent_containers/food/snacks/grown/potato( src.loc )
			A.name = "Centcomm 'Award'"
			occupied = 0
		del(src)


/obj/potatocase/meteorhit(obj/O as obj)
		new /obj/item/weapon/shard( src.loc )
		var/obj/item/weapon/reagent_containers/food/snacks/grown/potato/A = new /obj/item/weapon/reagent_containers/food/snacks/grown/potato( src.loc )
		A.name = "Centcomm 'Award'"
		del(src)


/obj/potatocase/proc/healthcheck()
	if (src.health <= 0)
		if (!( src.destroyed ))
			src.density = 0
			src.destroyed = 1
			new /obj/item/weapon/shard( src.loc )
			playsound(src, "shatter", 70, 1)
			var/obj/item/weapon/reagent_containers/food/snacks/grown/potato/A = new /obj/item/weapon/reagent_containers/food/snacks/grown/potato( src.loc )
			A.name = "Centcomm 'Award'"
			occupied = 0
			update_icon()
	else
		playsound(src.loc, 'Glasshit.ogg', 75, 1)
	return

/obj/potatocase/update_icon()
	if(src.destroyed)
		src.icon_state = "labcageb[src.occupied]"
	else
		src.icon_state = "labcage[src.occupied]"
	return


/obj/potatocase/attackby(obj/item/weapon/W as obj, mob/user as mob)
	src.health -= W.force
	src.healthcheck()
	..()
	return

/obj/potatocase/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/potatocase/attack_hand(mob/user as mob)
	if (src.destroyed)
		return
	else
		usr << text("\blue You kick the display case.")
		for(var/mob/O in oviewers())
			if ((O.client && !( O.blinded )))
				O << text("\red [] kicks the display case.", usr)
		src.health -= 2
		healthcheck()
		return