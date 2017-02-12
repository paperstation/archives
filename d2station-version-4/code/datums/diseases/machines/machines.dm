// all dis is stolen from baystation, and modified to be intergrated into the original virus code that I've expanded.
var/list/prob_G_list = list()

/proc/probG(var/define,var/everyother)
	if(prob_G_list["[define]"])
		prob_G_list["[define]"] += 1
		if(prob_G_list["[define]"] == everyother)
			prob_G_list["[define]"] = 0
			return 1
	else
		(prob_G_list["[define]"]) = 0
		(prob_G_list["[define]"]) = rand(1,everyother-1)
	return 0

/obj/machinery/disease2/incubator
	name = "Pathogenic incubator"
	density = 1
	anchored = 1
	icon = 'virology.dmi'
	icon_state = "incubator"
	var/obj/item/weapon/reagent_containers/glass/beaker = null
	var/radiation = 0
	var/on = 0
	var/power = 0
	var/foodsupply = 0
	var/toxins = 0
	var/obj/item/weapon/virusdish/dish = null

	ex_act(severity)
		switch(severity)
			if(1.0)
				del(src)
				return
			if(2.0)
				if (prob(50))
					del(src)
					return

	blob_act()
		if (prob(25))
			del(src)

	meteorhit()
		del(src)
		return

	attackby(var/obj/B as obj, var/mob/user as mob)
		if(istype(B, /obj/item/weapon/reagent_containers/glass/beaker))

			if(src.beaker)
				user << "A test tube is already loaded into the machine."
				return

			src.beaker =  B
			user.drop_item()
			B.loc = src
			user << "You add the beaker to the machine!"
			src.updateUsrDialog()

		else
			if(istype(B,/obj/item/weapon/virusdish))
				if(src.dish)
					user << "A dish is already loaded into the machine."
					return

				src.dish =  B
				user.drop_item()
				B.loc = src
				if(istype(B,/obj/item/weapon/virusdish))
					user << "You add the dish to the machine!"
					src.updateUsrDialog()

	Topic(href, href_list)
		if(stat & BROKEN) return
		if(usr.stat || usr.restrained()) return
		if(!in_range(src, usr)) return

		usr.machine = src
		if(!dish)
			on = 0
			return

		if (href_list["power"])
			on = !on
			if(on)
				icon_state = "incubator_on"
			else
				icon_state = "incubator"
		if (href_list["ejectchem"])
			if(beaker)
				beaker.loc = src.loc
				beaker = null
		if (href_list["ejectdish"])
			if(dish)
				dish.loc = src.loc
				dish = null
//		if (href_list["rad"])
//			radiation += 10
		if (href_list["flush"])
			radiation = 0
			toxins = 0
			foodsupply = 0


		src.add_fingerprint(usr)
		src.updateUsrDialog()

	attack_hand(mob/user as mob)
		if(stat & BROKEN)
			return
		user.machine = src
		var/dat = ""
		if(!dish)
			dat = "<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' />Please insert dish into the incubator.<BR>"
			dat += "<A href='?src=\ref[src];close=1'>Close</A><br>"
		var/string = "Off"
		if(dish && on)
			string = "On"
		if(dish)
			dat += "Power status : <A href='?src=\ref[src];power=1'>[string]</a>"
			dat += "<BR>"
			dat += "Anti-Toxins : [foodsupply]"
	//		dat += "<BR>"
	//		dat += "Debug : [dish.virus.name]"
	//		dat += "<BR>"
	//		dat += "Radiation Levels : [radiation] RADS : <A href='?src=\ref[src];rad=1'>Radiate</a>"
			dat += "<BR>"
			dat += "Toxins : [toxins]"
			dat += "<BR><BR>"
		if(beaker)
			dat += "Eject chemicals : <A href='?src=\ref[src];ejectchem=1'> Eject</a>"
			dat += "<BR>"
		if(dish)
			dat += "Eject Virus dish : <A href='?src=\ref[src];ejectdish=1'> Eject</a>"
			dat += "<BR>"
		dat += "<BR><BR>"
		dat += "<A href='?src=\ref[src];flush=1'>Flush system</a>"


		user << browse("<TITLE>Pathogenic incubator</TITLE>incubator menu:<BR><BR>[dat]", "window=incubator;size=575x400")
		onclose(user, "incubator")
		return




	process()
		sleep(-1)
		if(dish && on && dish.virus)
			use_power(50,EQUIP)
			if(!powered(EQUIP))
				on = 0
				icon_state = "incubator"
			if(foodsupply)
				foodsupply -= 1
				dish.growth += 1
				if(dish.growth == 100)
					state("The [src.name] pings")
//			if(radiation)
//				if(radiation > 50 & prob(5))

//					dish.virus = dish.virus.mutate(dish.virus)
		//			world << "mutated to [dish.virus.name]"
//					if(dish.info)
//						dish.info = "OUTDATED : [dish.info]"
//						dish.analysed = 0
//					src.updateUsrDialog()
//					state("The [src.name] beeps")

//				else if(prob(1))
//					dish.virus.mutate()
//				 radiation -= 1
//			if(toxins && prob(5))
//				dish.virus.infectionchance -= 1
			if(toxins > 50)
				dish.virus = null
		else if(!dish)
			on = 0
			icon_state = "incubator"


		if(beaker)
			if(!beaker.reagents.remove_reagent("anti_toxin",5))
				foodsupply += 20
			if(!beaker.reagents.remove_reagent("toxins",1))
				toxins += 1

	proc/state(var/msg)
		for(var/mob/O in hearers(src, null))
			O.show_message("\icon[src] \blue [msg]", 2)



// Dis ist der isolator apparently



/obj/machinery/disease2/isolator/
	name = "Pathogenic Isolator"
	density = 1
	anchored = 1
	icon = 'virology.dmi'
	icon_state = "isolator"
	var/datum/disease/virus = null
	var/isolating = 0
	var/beaker = null

	ex_act(severity)
		switch(severity)
			if(1.0)
				del(src)
				return
			if(2.0)
				if (prob(50))
					del(src)
					return

	blob_act()
		if (prob(25))
			del(src)

	meteorhit()
		del(src)
		return

	attackby(var/obj/item/weapon/reagent_containers/glass/B as obj, var/mob/user as mob)
		if(!istype(B,/obj/item/weapon/reagent_containers/syringe))
			return

		if(src.beaker)
			user << "A syringe is already loaded into the machine."
			return

		src.beaker =  B
		user.drop_item()
		B.loc = src
		if(istype(B,/obj/item/weapon/reagent_containers/syringe))
			user << "You add the syringe to the machine!"
			src.updateUsrDialog()
			icon_state = "isolator_in"

	Topic(href, href_list)
		if(stat & BROKEN) return
		if(usr.stat || usr.restrained()) return
		if(!in_range(src, usr)) return

		usr.machine = src
		if(!beaker) return

		if (href_list["isolate"])
			for(var/datum/disease/E)
				if(E.name == href_list["isolate"])
	//				world << "[E.name]"
					virus = E
//			world << "[virus.name] passed to var..."
			isolating = 10
			while(isolating > 0)
				isolating -= 1
//				world << "[isolating] left.."
				icon_state = "isolator_processing"

				if(isolating == 0)
//					world << "isolating done creating dish.."
					var/obj/item/weapon/virusdish/d = new /obj/item/weapon/virusdish(src.loc)
					d.virus = virus
					icon_state = "isolator_in"
			icon_state = "isolator_processing"
			src.updateUsrDialog()
//			world << "[virus.name] is now being processed."
			return

		else if (href_list["main"])
			attack_hand(usr)
			return
		else if (href_list["eject"])
			beaker:loc = src.loc
			beaker = null
			icon_state = "isolator"
			src.updateUsrDialog()
			return

	attack_hand(mob/user as mob)
		if(stat & BROKEN)
			return
		user.machine = src
		var/dat = ""
		if(!beaker)
			dat = "<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' />Please insert sample into the isolator.<BR>"
			dat += "<A href='?src=\ref[src];close=1'>Close</A>"
		else if(isolating)
			dat = "<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' />Isolating"
		else
			var/datum/reagents/R = beaker:reagents
			dat += "<A href='?src=\ref[src];eject=1'>Eject</A><BR><BR>"
			if(!R.total_volume)
				dat += "[beaker] is empty."
			else
				dat += "\red<b>Viruses found:</b><BR>"
				for(var/datum/reagent/blood/G in R.reagent_list)
					for(var/datum/disease/Z in G.data["viruses"])
						dat += "    [Z.name]: <A href='?src=\ref[src];isolate=[Z.name]'>Isolate</a><br>"
		user << browse("<TITLE>Pathogenic Isolator</TITLE>Isolator menu:<BR><BR>[dat]", "window=isolator;size=575x400")
		onclose(user, "isolator")
		return



/obj/machinery/disease2/diseaseanalyser
	name = "Disease Analyser"
	icon = 'virology.dmi'
	icon_state = "analyser"
	anchored = 1
	density = 1

	var/scanning = 0
	var/pause = 0

	var/obj/item/weapon/virusdish/dish = null

/obj/machinery/disease2/diseaseanalyser/attackby(var/obj/I as obj, var/mob/user as mob)
	if(istype(I,/obj/item/weapon/virusdish))
		var/mob/living/carbon/c = user
		if(!dish)

			dish = I
			c.drop_item()
			I.loc = src
			for(var/mob/M in viewers(src))
				if(M == user)	continue
				M.show_message("\blue [user.name] inserts the [dish.name] in the [src.name]", 3)


		else
			user << "There is already a dish inserted"

	//else
	return


/obj/machinery/disease2/diseaseanalyser/process()
	if(stat & (NOPOWER|BROKEN))
		return
	use_power(500)
	src.updateDialog()


	if(scanning)
		scanning -= 1
		if(scanning == 0)
			var/r = "[dish.virus.name]"
			r += "<BR>Infection stages : [dish.virus.max_stages]"
			if(dish.virus.spread_type == 4)
				r += "<BR>Spread form : Airbourne"
			else if(dish.virus.spread_type == 1)
				r += "<BR>Spread form : Contact"
			else
				r += "<BR>Spread form : Unknown"
			r += "<BR>Progress Speed : [dish.virus.stage_prob * 10]"
			r += "<br>Possible cure: [dish.virus.cure]"
			r += "<br>Description: [dish.virus.desc]"
//			for(var/datum/effectholder/E in dish.virus.effects)
//				r += "<BR>Effect:[E.effect.name]. Strength : [E.multiplier * 8]. Verosity : [E.chance * 15]. Type : [5-E.stage]."
			var/obj/item/weapon/paper/P = new /obj/item/weapon/paper(src.loc)
			P.info = r
			dish.info = r
			dish.analysed = 1
			dish.loc = src.loc
			dish = null
			icon_state = "analyser"
			score_researchdone++

			for(var/mob/O in hearers(src, null))
				O.show_message("\icon[src] \blue The [src.name] prints a sheet of paper", 3)
	else if(dish && !scanning && !pause)
		if(dish.virus && dish.growth > 50)
			dish.growth -= 10
			scanning = 5
			icon_state = "analyser_processing"
		else
			pause = 1
			spawn(25)
				dish.loc = src.loc
				dish = null
				for(var/mob/M in viewers(src))
					M.show_message("\icon[src] \blue The [src.name] buzzes", 2)
				pause = 0



	return




/obj/machinery/computer/curer
	name = "Cure Research Machine"
	icon = 'computer.dmi'
	icon_state = "curer"
//	brightnessred = 0
//	brightnessgreen = 2 //Used for multicoloured lighting on BS12
//	brightnessblue = 2
	var/curing
	var/virusing
	var/obj/item/weapon/reagent_containers/glass/beaker/testtube/tube = null
//	circuit = "/obj/item/weapon/circuitboard/mining"

	var/obj/item/weapon/virusdish/dish = null

/obj/machinery/computer/curer/attackby(var/obj/I as obj, var/mob/user as mob)
	/*if(istype(I, /obj/item/weapon/screwdriver))
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
				del(src)*/
	if(istype(I,/obj/item/weapon/virusdish))
		var/mob/living/carbon/c = user
		if(!dish)

			dish = I
			c.drop_item()
			I.loc = src

	if(istype(I,/obj/item/weapon/reagent_containers/glass/hyposprayvial))
		var/mob/living/carbon/c = user
		if(!tube)
			tube = I
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

/obj/machinery/computer/curer/attack_hand(var/mob/user as mob)
	if(..())
		return
	user.machine = src
	var/dat
	if(curing)
		dat = "<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' />Antibody production in progress"
	else if(virusing)
		dat = "<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' />Virus production in progress"
	else if(dish)
		dat = "<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' />Virus dish inserted"
		if(dish.virus)
			if(dish.growth >= 100 && tube && !tube.reagents.total_volume >= 0)
				dat += "<BR><A href='?src=\ref[src];antibody=1'>Begin antibody production</a>"
				dat += "<BR><A href='?src=\ref[src];virus=1'>Begin virus production</a>"
			else if(dish.growth <= 99)
				dat += "<BR>Insufficent cells to attempt to create cure"
			else
				dat += 	"<BR>Please check hypospray tube is inserted and empty."
		else
			dat += "<BR>Please check dish contents"

		dat += "<BR><A href='?src=\ref[src];eject=1'>Eject dish</a>"
		dat += "<BR><A href='?src=\ref[src];eject2=1'>Eject test tube</a>"

	if(!dish)
		if(!tube)
			dat = "<br>Please insert hypospray tube<br>"
		dat = "<br>Please insert dish<br>"
		dat += "<BR><A href='?src=\ref[src];eject2=1'>Eject test tube</a>"
		dat += "<BR><A href='?src=\ref[src];eject=1'>Eject dish</a>"
		user << browse(dat, "window=computer;size=400x500")
		onclose(user, "computer")
		return

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
			icon_state = "curer"
			if(dish.virus)
				createcure(dish.virus)
	if(virusing)
		virusing -= 1
		if(virusing == 0)
			icon_state = "curer"
			if(dish.virus)
				createvirus(dish.virus)

	return

/obj/machinery/computer/curer/Topic(href, href_list)
	if(..())
		return
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.machine = src

		if (href_list["antibody"])
			if(!tube)return
			curing = 30
			dish.growth -= 50
			src.icon_state = "curer_processing"
		if (href_list["virus"])
			if(!tube)return
			virusing = 30
			dish.growth -= 100
			src.icon_state = "curer_processing"
		else if(href_list["eject"])
			if(!dish)
				return
			dish.loc = src.loc
			dish = null

		else if(href_list["eject2"])
			if(!tube)
				return
			tube.loc = src.loc
			tube = null

		src.add_fingerprint(usr)
	src.updateUsrDialog()
	return


/obj/machinery/computer/curer/proc/createcure(var/datum/disease/virus)
//	world << "real cure"
	tube.name = "Vaccine container"
	var/vaccine_type = null
	var/type = virus.type
	var/saved_type = "[type]"
//	world << "[type] << type is"
	vaccine_type = text2path(saved_type)
//	world << "[virus.name] converted and made into a new [vaccine_type]"
	tube.reagents.add_reagent("vaccine",30,vaccine_type)
	tube.loc = src.loc
	tube = null
	state("The [src.name] Buzzes")
	score_researchdone++
	command_alert("A vaccine for [virus.name] has been made in virology!", "The scientists in virology have discovered a new vaccine.")

/obj/machinery/computer/curer/proc/createvirus(var/datum/disease/virus)

	tube.name = "Viral container (MAJOR BIOHAZARD)"
	var/datum/disease/D = new virus.type
//	world << "[virus.name] converted and made into a new [D.name]"
	var/list/data = list("viruses"=list(D))
	var/name = sanitize(input(usr,"Name:","Name the culture",D.name))
	if(!name || name == " ") name = D.name
	tube.name = "[name] culture bottle"
	tube.desc = "A small bottle. Contains [D.agent] culture in synthblood medium."
	tube.reagents.add_reagent("blood",30,data)
	tube.loc = src.loc
	tube = null
	score_researchdone++
	state("The [src.name] Buzzes")
	command_alert("A virus bottle of [D.agent] has been made in virology!", "The scientists in virology have created a new virus.")


/obj/machinery/computer/curer/proc/state(var/msg)
	for(var/mob/O in hearers(src, null))
		O.show_message("\icon[src] \blue [msg]", 2)


/obj/machinery/computer/pandemic2
	name = "Antibody Isolation and replication matrix."
	density = 1
	anchored = 1
	icon = 'chemical.dmi'
	icon_state = "genesploicer0"
	var/temphtml = ""
	var/wait = null
	var/obj/item/weapon/reagent_containers/glass/beaker = null


	set_broken()
		icon_state = (src.beaker?"genesploicer1_b":"genesploicer0_b")
		stat |= BROKEN


	power_change()

		if(stat & BROKEN)
			icon_state = (src.beaker?"genesploicer1_b":"genesploicer0_b")

		else if(powered())
			icon_state = (src.beaker?"genesploicer1":"genesploicer0")
			stat &= ~NOPOWER

		else
			spawn(rand(0, 15))
				src.icon_state = (src.beaker?"genesploicer1_nopower":"genesploicer0_nopower")
				stat |= NOPOWER


	Topic(href, href_list)
		if(stat & (NOPOWER|BROKEN)) return
		if(usr.stat || usr.restrained()) return
		if(!in_range(src, usr)) return

		usr.machine = src
		if(!beaker) return

		if (href_list["create_vaccine"])
			if(!src.wait)
				var/obj/item/weapon/reagent_containers/glass/bottle/B = new/obj/item/weapon/reagent_containers/glass/bottle(src.loc)
				var/vaccine_type = text2path(href_list["create_vaccine"])//the path is received as string - converting
				var/datum/disease/D = new vaccine_type
				var/name = input(usr,"Name:","Name the vaccine",D.name)
				if(!name || name == " ") name = D.name
				B.name = "[name] vaccine bottle"
				B.reagents.add_reagent("vaccine",15,vaccine_type)
				score_researchdone++
				del(D)
				wait = 1
				spawn(1200)
					src.wait = null
			else
				src.temphtml = "The replicator is not ready yet."
			src.updateUsrDialog()
			return
		else if (href_list["create_virus_culture"])
			if(!wait)
				var/obj/item/weapon/reagent_containers/glass/bottle/B = new/obj/item/weapon/reagent_containers/glass/bottle(src.loc)
				B.icon_state = "bottle3"
				var/type = text2path(href_list["create_virus_culture"])//the path is received as string - converting
				var/datum/disease/D = new type
				var/list/data = list("viruses"=list(D))
				var/name = sanitize(input(usr,"Name:","Name the culture",D.name))
				if(!name || name == " ") name = D.name
				B.name = "[name] culture bottle"
				B.desc = "A small bottle. Contains [D.agent] culture in synthblood medium."
				B.reagents.add_reagent("blood",20,data)
				src.updateUsrDialog()
				wait = 1
				spawn(3000)
					src.wait = null
			else
				src.temphtml = "The replicator is not ready yet."
			src.updateUsrDialog()
			return
		else if (href_list["empty_beaker"])
			beaker.reagents.clear_reagents()
			src.updateUsrDialog()
			return
		else if (href_list["eject"])
			beaker:loc = src.loc
			beaker = null
			icon_state = "genesploicer0"
			src.updateUsrDialog()
			return
		else if(href_list["clear"])
			src.temphtml = ""
			src.updateUsrDialog()
			return
		else
			usr << browse(null, "window=pandemic")
			src.updateUsrDialog()
			return

		src.add_fingerprint(usr)
		return

	attack_ai(mob/user as mob)
		return src.attack_hand(user)

	attack_paw(mob/user as mob)
		return src.attack_hand(user)

	attack_hand(mob/user as mob)
		if(stat & (NOPOWER|BROKEN))
			return
		user.machine = src
		var/dat = ""
		if(src.temphtml)
			dat = "<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' />[src.temphtml]<BR><BR><A href='?src=\ref[src];clear=1'>Main Menu</A>"
		else if(!beaker)
			dat += "<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' />Please insert beaker.<BR>"
			dat += "<A href='?src=\ref[user];mach_close=pandemic'>Close</A>"
		else
			var/datum/reagents/R = beaker.reagents
			var/datum/reagent/blood/Blood = null
			for(var/datum/reagent/blood/B in R.reagent_list)
				if(B)
					Blood = B
					break
			if(!R.total_volume||!R.reagent_list.len)
				dat += "The beaker is empty<BR>"
			else if(!Blood)
				dat += "No blood sample found in beaker"
			else
				dat += "<h3>Blood sample data:</h3>"
				dat += "<b>Blood DNA:</b> [(Blood.data["blood_DNA"]||"none")]<BR>"
				dat += "<b>Blood Type:</b> [(Blood.data["blood_type"]||"none")]<BR>"


//				if(Blood.data["viruses"])
//					var/list/vir = Blood.data["viruses"]
//					if(vir.len)
//						for(var/datum/disease/D in Blood.data["viruses"])
//							if(!D.hidden[PANDEMIC])
//								if(!(D.mutated))
//									dat += "<b>Disease Agent:</b> [D?"[D.agent] - <A href='?src=\ref[src];create_virus_culture=[D.type]'>Create virus culture bottle</A>":"none"]<BR>"
//								else
//									dat += "<b>Disease Agent:</b> [D.agent] - Cannot Replicate<BR>"
//								dat += "<b>Common name:</b> [(D.name||"none")]<BR>"
//								dat += "<b>Description: </b> [(D.desc||"none")]<BR>"
				dat += "<b>Contains antibodies to:</b> "
				if(Blood.data["resistances"])
					var/list/res = Blood.data["resistances"]
					if(res.len)
						dat += "<ul>"
						for(var/type in Blood.data["resistances"])
							var/datum/disease/DR = new type
							dat += "<li>[DR.name] - <A href='?src=\ref[src];create_vaccine=[type]'>Create vaccine bottle</A></li>"
							del(DR)
						dat += "</ul><BR>"
					else
						dat += "nothing<BR>"
				else
					dat += "nothing<BR>"
			dat += "<BR><A href='?src=\ref[src];eject=1'>Eject beaker</A>[((R.total_volume&&R.reagent_list.len) ? "-- <A href='?src=\ref[src];empty_beaker=1'>Empty beaker</A>":"")]<BR>"
			dat += "<A href='?src=\ref[user];mach_close=pandemic'>Close</A>"

		user << browse("<TITLE>[src.name]</TITLE><BR>[dat]", "window=pandemic;size=575x400")
		onclose(user, "pandemic")
		return

	attackby(var/obj/I as obj, var/mob/user as mob)
		if(istype(I, /obj/item/weapon/screwdriver))
			playsound(src.loc, 'Screwdriver.ogg', 50, 1)
			if(do_after(user, 20))
				if (src.stat & BROKEN)
					user << "\blue The broken glass falls out."
					var/obj/computerframe/A = new /obj/computerframe(src.loc)
					new /obj/item/weapon/shard(src.loc)
					var/obj/item/weapon/circuitboard/pandemic/M = new /obj/item/weapon/circuitboard/pandemic(A)
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
					var/obj/item/weapon/circuitboard/pandemic/M = new /obj/item/weapon/circuitboard/pandemic(A)
					for (var/obj/C in src)
						C.loc = src.loc
					A.circuit = M
					A.state = 4
					A.icon_state = "4"
					A.anchored = 1
					del(src)
		else if(istype(I, /obj/item/weapon/reagent_containers/glass))
			if(stat & (NOPOWER|BROKEN)) return
			if(src.beaker)
				user << "A beaker is already loaded into the machine."
				return

			src.beaker =  I
			user.drop_item()
			I.loc = src
			user << "You add the beaker to the machine!"
			src.updateUsrDialog()
			icon_state = "genesploicer1"

		else
			..()
		return
