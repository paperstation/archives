/obj/machinery/computer/curer
	name = "Vaccine Research Machine"
	icon = 'computer.dmi'
	icon_state = "curecomp"
//	brightnessred = 0
//	brightnessgreen = 2
//	brightnessblue = 2
	var/curing
	var/virusing

	var/obj/item/weapon/reagent_containers/glass/virusdish/dish = null

/obj/machinery/computer/curer/attackby(var/obj/I as obj, var/mob/user as mob)
	if(istype(I, /obj/item/weapon/screwdriver))
		playsound(src.loc, 'Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			if (src.stat & BROKEN)
				user << "\blue The broken glass falls out."
				var/obj/computerframe/A = new /obj/computerframe( src.loc )
				new /obj/item/weapon/shard( src.loc )
				var/obj/item/weapon/circuitboard/curer/M = new /obj/item/weapon/circuitboard/curer( A )
				for (var/obj/C in src)
					C.loc = src.loc
				A.circuit = M
				A.state = 3
				A.icon_state = "3"
				A.anchored = 1
				del(src)
			else
				user << "\blue You disconnect the monitor."
				var/obj/computerframe/A = new /obj/computerframe( src.loc )
				var/obj/item/weapon/circuitboard/curer/M = new /obj/item/weapon/circuitboard/curer( A )
				for (var/obj/C in src)
					C.loc = src.loc
				A.circuit = M
				A.state = 4
				A.icon_state = "4"
				A.anchored = 1
				del(src)
	if(istype(I,/obj/item/weapon/reagent_containers/glass/virusdish))
		var/mob/living/carbon/c = user
		if(!dish)

			dish = I
			c.drop_item()
			I.loc = src

	//else
	src.attack_hand(user)
	return

/obj/machinery/computer/curer/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/curer/attack_paw(var/mob/user as mob)

	return src.attack_hand(user)
	return

/*
/obj/machinery/computer/curer/attack_hand(var/mob/user as mob)
	if(..())
		return
	user.machine = src
	var/dat
	if(curing)
		dat = "Antibody production in progress"
	else if(virusing)
		dat = "Virus production in progress"
	else if(dish)
		dat = "Virus dish inserted"
		if(dish.virus2)
			if(dish.growth >= 100)
				dat += "<BR><A href='?src=\ref[src];antibody=1'>Begin antibody production</a>"
				dat += "<BR><A href='?src=\ref[src];virus=1'>Begin virus production</a>"
			else
				dat += "<BR>Insufficent cells to attempt to create cure"
		else
			dat += "<BR>Please check dish contents"

		dat += "<BR><A href='?src=\ref[src];eject=1'>Eject disk</a>"
	else
		dat = "Please insert dish"

	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return
*/

/obj/machinery/computer/curer/attack_hand(var/mob/user as mob)
	if(..())
		return
	var/dat
	if(curing)
		dat = "Antibody production in progress"
	else if(virusing)
		dat = "Virus production in progress"
	else if(dish)
		dat = "Virus dish inserted"


		var/datum/reagents/R = dish.reagents
		var/datum/reagent/blood/Blood = null
		for(var/datum/reagent/blood/B in R.reagent_list)
			if(B)
				Blood = B
				break
		if(!R.total_volume||!R.reagent_list.len)
			dat += "The dish is empty<BR>"
		else if(!Blood)
			dat += "Insufficent cells to attempt to create vaccine"
		else
			dat += "<h3>Blood sample data:</h3>"
			var/datum/disease/D = Blood.data["virus"]
			if(D)
				dat += "<b>Common name:</b> [(D.name||"none")]<BR>"
				dat += "<b>Possible vulnerability:</b> [(D.cure||"none")]<BR>"
			dat += "<b>Contains antibodies to:</b> "
			if(Blood.data["resistances"])
				var/list/res = Blood.data["resistances"]
				if(res.len)
					dat += "<ul>"
					for(var/type in Blood.data["resistances"])
						var/datum/disease/DR = new type
						dat += "<li>[DR.name] - <A href='?src=\ref[src];create_vaccine=[type]'>Create vaccine</A></li>"
						del(DR)
					dat += "</ul><BR>"
				else
					dat += "nothing<BR>"
			else
				dat += "nothing<BR>"
		dat += "<BR><A href='?src=\ref[src];eject=1'>Eject disk</a>"
		dat += "<A href='?src=\ref[user];mach_close=computer'>Close</A>"

	else
		dat = "Please insert dish"

	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return





/obj/machinery/computer/curer/process()
	..()

	if(stat & (NOPOWER|BROKEN))
		return
	use_power(500)
	src.updateDialog()

	if(curing)
		curing -= 1
		if(curing == 0)
			icon_state = "curecomp"
//			if(dish.virus2)
//				createcure(dish.virus2)
	if(virusing)
		virusing -= 1
		if(virusing == 0)
			icon_state = "curecomp"
//			if(dish.virus2)
//				createvirus(dish.virus2)

	return

/obj/machinery/computer/curer/Topic(href, href_list)
	if(..())
		return
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.machine = src

		if (href_list["create_vaccine"])
			if(!src.curing)
				curing = 1
				var/obj/item/weapon/cureimplanter/B = new /obj/item/weapon/cureimplanter(src.loc)
		//		var/obj/item/weapon/reagent_containers/glass/bottle/B = new/obj/item/weapon/reagent_containers/glass/bottle(src.loc)
				var/vaccine_type = text2path(href_list["create_vaccine"])//the path is received as string - converting
				var/datum/disease/D = new vaccine_type
				var/name = input(usr,"Name:","Name the vaccine",D.name)
				if(!name || name == " ") name = D.name
				B.name = "[name] vaccine injector"
				B.reagents.add_reagent("vaccine",15,vaccine_type)
				spawn(500)
					src.curing = null

			else
				state("The [src.name] buzzes")
		if (href_list["virus"])
			virusing = 50
//			dish.growth -= 100
			src.icon_state = "curecomp_processing"
		else if(href_list["eject"])
			dish.loc = src.loc
			dish = null

		src.add_fingerprint(usr)
	src.updateUsrDialog()
	return





/obj/machinery/computer/curer/proc/createvirus(var/datum/disease2/disease/virus2)
	var/obj/item/weapon/cureimplanter/implanter = new /obj/item/weapon/cureimplanter(src.loc)
	implanter.name = "Viral implanter (MAJOR BIOHAZARD)"
//	implanter.virus2 = dish.virus2.getcopy()
	implanter.works = 3
	state("The [src.name] Buzzes")


/obj/machinery/computer/curer/proc/state(var/msg)
	for(var/mob/O in hearers(src, null))
		O.show_message("\icon[src] \blue [msg]", 2)


/*
/obj/item/weapon/virusdish
	name = "Virus containment/growth dish"
	icon = 'items.dmi'
	icon_state = "petridish"
	var/datum/disease2/disease/virus2 = null
	var/growth = 0
	var/info = 0
	var/analysed = 0

/obj/item/weapon/virusdish/attackby(var/obj/item/weapon/W as obj,var/mob/living/carbon/user as mob)
	if(istype(W,/obj/item/weapon/hand_labeler))
		return
	..()
	if(prob(50))
		user << "The dish shatters"
//		if(virus2.infectionchance > 0)
//			infect_virus2(user,virus2)
		del src

/obj/item/weapon/virusdish/examine()
	usr << "This is a virus containment dish"
	if(src.info)
		usr << "It has the following information about its contents"
		usr << src.info
*/