//START BASE ITEM
//ALL ADDITIONAL VEHICLES GO BELOW THIS
/obj/mecha/working/robustmobile
	desc = "Robustmobile, used for quick delivery of robusting."
	name = "Robustmobile"
	icon_state = "qmtruck1"
	step_in = 2
	max_temperature = 1000
	opacity = 0
	health = 400
	var/licenseplate
	var/list/cargo = new
	cargo_capacity = 20
	step_energy_drain = 5
	max_equip = 3
	var/passengers = 0
	var/maxpassengers = 1
	var/hornsound

/obj/mecha/working/robustmobile/New()
	licenseplate = "[pick("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z")][pick("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z")]-[rand(100,999)]"
	name = "[name] ([licenseplate])"
	hornsound = rand(2, 10)
	..()

/*
/obj/mecha/working/robustmobile/verb/move_inside_passenger()
	set category = "Object"
	set name = "Enter Vehicle (As Passenger)"
	set src in oview(1)
	if(src.passengers == src.maxpassengers)
		usr << "\blue <B>All the passenger seats are taken.</B>"
		return
	if (usr.stunned || usr.weakened)
		return
	if (usr.stat || !ishuman(usr))
		return
	src.log_message("[usr] tries to move in as a passenger.")
	usr << "You start climbing into [src.name]"
	if(do_after(20))
		moved_inside(usr)
	return
*/

/obj/mecha/working/robustmobile/verb/horn()
	set category = "Vehicle Interface"
	set name = "Horn"
	set src in view(0)
	if(!src.occupant) return
	if(usr!=src.occupant)
		return
		playsound(src, 'carhorn.ogg', 25, 1)
	return

/obj/mecha/working/robustmobile/Bump(var/atom/obstacle)
	if(istype(obstacle, /obj/mecha))
		var/damage = rand(10,30)
		src.cell.use(2*damage)
		obstacle:cell.use(damage)
		src.take_damage(damage)
		obstacle:take_damage(damage)
		playsound(src, 'bang.ogg', 25)
		playsound(obstacle, 'bang.ogg', 25)
		obstacle:occupant.stunned = 3
		obstacle:occupant.weakened = 3
		obstacle:occupant.bruteloss += 4
		src.occupant.stunned = 3
		src.occupant.weakened = 3
		src.occupant.bruteloss += 2
		for(var/mob/living/carbon/V in ohearers(6, src))
			V.show_message("\red <B>[src.occupant] crashes into [occupant.name] with their [src.name]!</B>",1)
	else if(istype(obstacle, /obj))
		var/obj/O = obstacle
		if(O.anchored)
			var/damage = rand(10,30)
			src.occupant.stunned = 4
			src.occupant.weakened = 3
			src.occupant.bruteloss += 1
			src.cell.use(damage)
			playsound(src, 'bang.ogg', 25)
			src.take_damage(damage - 10)
			for(var/mob/living/carbon/V in ohearers(6, src))
				V.show_message("\red <B>[src.occupant] crashes into [occupant.name] with their [src.name]!</B>",1)
		else
			obstacle.Bumped(src)
	else if(istype(obstacle, /mob))
		var/mob/M = obstacle
		M:stunned = 5
		M:weakened = 7
		playsound(src, 'bang.ogg', 25)

		for(var/mob/living/carbon/V in ohearers(6, src))
			V.show_message("\red <B>[src.occupant] runs over [M] with their [src.name]!</B>",1)
		playsound(src, 'splat.ogg', 50, 1)

		var/damage = rand(10,30)

		src.take_damage(damage)
		src.cell.use(2*damage)
		src.occupant.stunned = 3
		src.occupant.weakened = 3
		src.occupant.bruteloss += damage

		M:TakeDamage("head", 2*damage, 0)
		M:TakeDamage("chest",2*damage, 0)
		M:TakeDamage("l_leg",0.5*damage, 0)
		M:TakeDamage("r_leg",0.5*damage, 0)
		M:TakeDamage("l_arm",0.5*damage, 0)
		M:TakeDamage("r_arm",0.5*damage, 0)

		if(prob(1))
			M:removePart("arm_left")
		if(prob(1))
			M:removePart("arm_right")
		if(prob(1))
			M:removePart("leg_left")
		if(prob(1))
			M:removePart("leg_right")
		if(prob(1))
			M:removePart(M:organ_manager.head)

		var/obj/decal/cleanable/blood/B = new(M:loc)
		B.blood_DNA = M.dna.unique_enzymes
		var/obj/decal/cleanable/blood/tracks/D = new(M:loc)
		var/newdir = get_dir(M, loc)
		if(newdir == dir)
			D.dir = newdir
		else
			newdir = newdir | dir
			if(newdir == 3)
				newdir = 1
			else if(newdir == 12)
				newdir = 4
			D.dir = newdir
	else
		obstacle.Bumped(src)
	return


/obj/mecha/working/robustmobile/Exit(atom/movable/O)
	if(O in cargo)
		return 0
	return ..()


/obj/mecha/working/robustmobile/Topic(href, href_list)
	..()
	if(href_list["drop_from_cargo"])
		var/obj/O = locate(href_list["drop_from_cargo"])
		if(O && O in src.cargo)
			src.occupant << "\blue You unload [O]."
			O.loc = get_turf(src)
			src.cargo -= O
			var/turf/T = get_turf(O)
			if(T)
				T.Entered(O)
			src.log_message("Unloaded [O]. Cargo compartment capacity: [cargo_capacity - src.cargo.len]")
	return

/obj/mecha/working/robustmobile/relaymove(mob/user,direction)
	..()
	playsound(src, 'drive.ogg', 1, 0)

/obj/mecha/working/robustmobile/go_out()
	playsound(src, 'enterexitcar.ogg', 30, 0)
	..()

/obj/mecha/working/robustmobile/moved_inside()
	playsound(src, 'enterexitcar.ogg', 30, 0)
	..()

/obj/mecha/working/robustmobile/get_stats_part()
	var/output = ..()
	output += "<b>Cargo Compartment Contents:</b><div style=\"margin-left: 15px;\">"
	if(src.cargo.len)
		for(var/obj/O in src.cargo)
			output += "<a href='?src=\ref[src];drop_from_cargo=\ref[O]'>Unload</a> : [O]<br>"
	else
		output += "Nothing"
	output += "</div>"
	return output

/obj/mecha/working/robustmobile/Del()
	for(var/mob/M in src)
		if(M==src.occupant)
			continue
		M.loc = get_turf(src)
		M.loc.Entered(M)
		step_rand(M)
	for(var/atom/movable/A in src.cargo)
		A.loc = get_turf(src)
		var/turf/T = get_turf(A)
		if(T)
			T.Entered(A)
		step_rand(A)
	..()
	return

/turf/simulated/floor/Entered(atom/A as mob|obj)
	..()
	if(istype(A, /obj/mecha/working/robustmobile))
		if(istype(src, /turf/simulated/floor/spacedome/water))
			A:cell.use(1000)
			A:take_damage(rand(5,15))
			playsound(src.loc, 'bang.ogg', 25)
		if(!istype(src, /turf/simulated/floor/spacedome/concrete) && !istype(src, /turf/simulated/floor/spacedome/concrete) && (src.icon_state != "roaddottedstripes") && (src.icon_state != "zebracrossing"))
			A:cell.use(20)
			A:step_in = 10
			if(prob(5))
				A:take_damage(rand(5,15))
				playsound(src.loc, 'bang.ogg', 25)
		else
			A:step_in = initial(A:step_in)

	if(istype(A, /obj/item/weapon/cell))
		if(A:charge != 0)
			if(istype(src, /turf/simulated/floor/spacedome/water))
				A:cell.use(1000)

	if(istype(A, /mob))
		if(istype(src, /turf/simulated/floor/spacedome/water))
			A:nutrition -= rand(2,5)
			if(A:nutrition <= 120)
				A:bruteloss += rand(2,4)
				A:update_health()

//END BASE ITEM

//PUT YOUR VEHICLES BELOW THIS COMMENT
/obj/mecha/working/robustmobile/taxi
	desc = "A city taxi"
	name = "Taxi"
	icon_state = "taxi1"
	step_in = 1.5
	max_temperature = 700
	health = 100
	list/cargo = new
	cargo_capacity = 2
	step_energy_drain = 4

/obj/mecha/working/robustmobile/truck
	desc = "Truck"
	name = "Truck"
	icon_state = "regtruck1"
	step_in = 2
	max_temperature = 700
	health = 200
	list/cargo = new
	cargo_capacity = 4
	step_energy_drain = 3

/obj/mecha/working/robustmobile/ambulance
	desc = "Ambulance"
	name = "Ambulance"
	icon_state = "ambulance1"
	step_in = 2
	max_temperature = 700
	health = 200
	list/cargo = new
	cargo_capacity = 4
	step_energy_drain = 3

/obj/mecha/working/robustmobile/firetruck
	desc = "Firetruck"
	name = "Firetruck"
	icon_state = "ambulance1"
	step_in = 2
	max_temperature = 800
	health = 200
	list/cargo = new
	cargo_capacity = 4
	step_energy_drain = 3
	list/equipment = new /obj/item/mecha_parts/mecha_equipment/tool/extinguisher


/obj/mecha/working/robustmobile/tank
	desc = "Tank"
	name = "Tank"
	icon_state = "ambulance1"
	step_in = 2
	max_temperature = 900
	health = 700
	list/cargo = new
	cargo_capacity = 4
	step_energy_drain = 7
	list/equipment = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack