/obj/machinery/adamantite
	name = "Adamantite Refinery"
	desc = "Refines adamantite into a single powerful entity."
	icon_state = "autolathe"
	density = 1
	anchored = 1
	var/empty
	var/contains
	var/opened = 0
	var/core
	var/energy
	var/totalenergy
	var/shard
	var/use = 0
	var/screen
	var/spawntemp
	var/tempmessage
	var/transfer
/obj/machinery/adamantite/attack_hand(mob/user as mob)
	var/dat = "<b>Adamantite Refinery Information</b><BR>"
	dat += "Stored Refinery Energy:[totalenergy]<br><br>"
	dat += "Current Shard Information<br>"
	if(!screen)
		if(!use)
			dat += "No shard inserted<br>"
			dat += "No energy detected<br>"
		else
			dat += "Adamantite shard inserted<br>"
			dat += "Energy:[energy]<br>"
			dat += "<A href='byond://?src=\ref[src];op=convert'>Convert to energy</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=transform'>Transform into an item</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=infuse'>Infuse with energy</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=eject'>Eject</A><BR>"
			dat += tempmessage
	else if(screen == 1)
		dat += "Mining Equipment<br>"
		dat += "<A href='byond://?src=\ref[src];op=item1'>Adamantite Pickaxe (85 Energy)</A><br>"
		dat += "<A href='byond://?src=\ref[src];op=item4'>Adamantite Shovel (50 Energy)</A><br><br>"
		dat += "Electronics<br>"
		dat += "<A href='byond://?src=\ref[src];op=item2'>Quick-Fix Powercell (25 Energy)</A><br><br>"
		dat += "Misc<br>"
		dat += "<A href='byond://?src=\ref[src];op=item3'>Cane(25 Energy)</A><br><br>"
		dat += "<A href='byond://?src=\ref[src];op=item5'>Mining Charge (200 Energy)</A><br>"
		dat += "<A href='byond://?src=\ref[src];op=item6'>NutriStor(250 Energy)</A><br><br>"
		dat += "<A href='byond://?src=\ref[src];op=item7'>Custom Plaque (500 Energy)</A><br><br>"
		dat += "Electronics<br>"
		dat += "<A href='byond://?src=\ref[src];op=item8'>Starship Frame(200 Energy)</A><br><br>"
	else if(screen == 3)
		dat += "Not enough stored energy.<br>"
		dat += "<A href='byond://?src=\ref[src];op=back'>Back</A>"
	else if(screen == 4)
		dat += "Creating selected item."
		spawn(100)
			screen = 0
			new spawntemp(src.loc)
	else if(screen == 5)
		dat += "Infusing shard with energy.<br>"
		dat += "<A href='byond://?src=\ref[src];op=t1'>Infuse with 1-4 energy</A><BR>"
		dat += "<A href='byond://?src=\ref[src];op=t2'>Infuse with 5-10 energy</A><BR>"
		dat += "<A href='byond://?src=\ref[src];op=t3'>Infuse with 11-20 energy</A><BR>"

	user << browse(dat, "window=scroll")
	onclose(user, "scroll")
	return
/obj/machinery/adamantite/attackby(var/obj/item/O as obj, var/mob/user as mob)

	if(istype(O, /obj/item/adamantitecore/diamond))
		if(opened)
			if(core)
				user << "\blue There is already a core installed."
			else
				user << "\blue You insert the core into the [name]."
				user.drop_item()
				O.loc = src
				core = 2
				return
		else
			return
	if(istype(O, /obj/item/adamantitecore/norm))
		if(opened)
			if(core)
				user << "\blue There is already a core installed."
			else
				user << "\blue You insert the core into the [name]."
				user.drop_item()
				O.loc = src
				core = 1
				return
		else
			return
	if(istype(O, /obj/item/weapon/crowbar))
		if(opened)
			if(core)
				user << "\blue You pry out the core."
				for(var/obj/item/adamantitecore/D in src)
					D.loc = src.loc
					core = 0
				return
			else
				return
		else
			return
	if(istype(O, /obj/item/weapon/ore/adamantite))
		if(!use)
			var/obj/item/weapon/ore/adamantite/F = O
			user << "\blue You insert the adamantite shard into the machine."
			user.drop_item()
			energy = F.energy
			use = 1
			del(O)
			return
		else
			user << "\blue There is already a shard inside."
	if (istype(O, /obj/item/weapon/screwdriver))
		if (!opened)
			src.opened = 1
			src.icon_state = "autolathe_t"
			user << "You open the maintenance hatch of [src]."
		else
			src.opened = 0
			src.icon_state = "autolathe"
			user << "You close the maintenance hatch of [src]."
		return 1
	onclose(user, "scroll")
	return

/obj/machinery/adamantite/process()
	if(!core)
		if(energy >= 101)
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(3, 1, src)
			s.start()
			energy = 0
			use = 0
			screen = 0
	else
		if(energy >= 1001)
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(4, 1, src)
			s.start()
			energy = 0
			use = 0
			screen = 0


/obj/machinery/adamantite/Topic(href, href_list)
	if (usr.stat)
		return
	if ((in_range(src, usr) && istype(src.loc, /turf)) || (istype(usr, /mob/living/silicon)))
		usr.set_machine(src)
		var/holder
		switch(href_list["op"])

			if("convert")
				totalenergy += energy
				use = 0
			if("back")
				screen = 0
			if("transform")
				screen = 1
			if("t1")
				if(totalenergy > 0)
					holder = rand(1,4)
					if(totalenergy >= holder)
						energy += holder
						totalenergy -= holder
						tempmessage = "Transferred [holder] energy to the shard"
						screen = 0
			if("t2")
				if(totalenergy > 0)
					holder = rand(5,10)
					if(totalenergy >= holder)
						energy += holder
						totalenergy -= holder
						tempmessage = "Transferred [holder] energy to the shard"
						screen = 0
			if("t3")
				if(totalenergy > 0)
					holder = rand(11,20)
					if(totalenergy >= holder)
						energy += holder
						totalenergy -= holder
						tempmessage = "Transferred [holder] energy to the shard"
						screen = 0
			if("item1")//pick
				if(src.energy >= 85)
					screen = 2
					energy = 0
					new /obj/item/weapon/pickaxe/adamantite(src.loc)
					use = 0
					screen = 0
				else
					screen = 3
			if("item2")//cell
				if(src.energy >= 25)
					screen = 2
					energy = 0
					new /obj/item/weapon/cell/adamantite(src.loc)
					use = 0
					screen = 0
				else
					screen = 3
			if("item3")//cane
				if(src.energy >= 25)
					screen = 2
					energy = 0
					var/obj/item/weapon/cane/D = new /obj/item/weapon/cane
					D.loc = src.loc
					D.name = "Cane"
					use = 0
					screen = 0
				else
					screen = 3
			if("item4")
				if(src.energy >= 50)
					screen = 2
					energy = 0
					new /obj/item/weapon/shovel/adamantite(src.loc)
					use = 0
					screen = 0
				else
					screen = 3
			if("item5")
				if(src.energy >= 200)
					screen = 2
					energy = 0
					new /obj/item/weapon/plastique/mining/(src.loc)
					use = 0
					screen = 0
				else
					screen = 3
			if("item6")
				if(src.energy >= 250)
					screen = 2
					energy = 0
					new /obj/item/weapon/storage/bag/nutrientstor(src.loc)
					use = 0
					screen = 0
				else
					screen = 3
			if("item7")
				if(src.energy >= 500)
					screen = 2
					energy = 0
					new /obj/structure/sign/plaque/custom(src.loc)
					use = 0
					screen = 0
				else
					screen = 3
			if("item8")
				if(src.energy >= 200)
					screen = 2
					energy = 0
					new /obj/item/starship/frame(src.loc)
					use = 0
					screen = 0
				else
					screen = 3
			if("ore")
				if(src.energy >= 100)
					screen = 2
					energy = 0
					new /obj/structure/sign/plaque/custom(src.loc)
					use = 0
					screen = 0
				else
					screen = 3
			if("infuse")
				screen = 5
			if("eject")
				use = 0
				var/obj/item/weapon/ore/adamantite/D = new/obj/item/weapon/ore/adamantite
				D.loc = src.loc
				D.energy = src.energy
				screen = 0

	attack_hand(usr)

/obj/item/weapon/ore/adamantite
	name = "adamantite"
	icon = 'icons/obj/mining.dmi'
	icon_state = "adamantite"
	item_state = "adamantite"
	origin_tech = "plasmatech=2;materials=2"
	var/energy


/obj/item/weapon/ore/adamantite/New(var/loc, var/amount=null)
	pixel_x = rand(0,4)-4
	pixel_y = rand(0,4)-4
	..()
	energy = rand(10,60)

/var/global/cores_smashed = 0
/obj/item/adamantitecore/
	name = "fused adamantite core"
	icon = 'icons/obj/mining.dmi'
	icon_state = "adamantite-core"

	throw_impact(atom/hit_atom)
		..()
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, src)
		s.start()
		src.visible_message("\red The [src.name] explodes!","\red You hear a loud smash!")
		src.explode()
		del(src)

	proc/explode()

		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, src)
		s.start()
		cores_smashed +=1
		explosion(src.loc,-1,-1,1)
		if(src)
			del(src)

/obj/item/adamantitecore/norm

/obj/item/adamantitecore/diamond
	name = "fused diamond-adamantite core"
	explode()

		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, src)
		s.start()

		explosion(src.loc,-1,-1,2)//Morepowerful
		if(src)
			del(src)


/obj/item/weapon/storage/box/adamantite
	name = "snap pop box"
	desc = "Holds infused adamantite."
	icon = 'icons/obj/toy.dmi'
	icon_state = "spbox"
	storage_slots = 8
	can_hold = list("/obj/item/weapon/ore/adamantite/active")