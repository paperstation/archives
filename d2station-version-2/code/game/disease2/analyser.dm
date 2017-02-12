/obj/machinery/disease2/diseaseanalyser
	name = "Disease Analyser"
	icon = 'virology.dmi'
	icon_state = "analyzer0"
	anchored = 1
	density = 1

	var/scanning = 0
	var/pause = 0

	var/obj/item/weapon/reagent_containers/glass/virusdish/dish = null

/obj/machinery/disease2/diseaseanalyser/attackby(var/obj/I as obj, var/mob/user as mob)
	if(istype(I,/obj/item/weapon/reagent_containers/glass/virusdish))
		var/mob/living/carbon/c = user
		if(!dish)

			dish = I
			c.drop_item()
			I.loc = src
			for(var/mob/M in viewers(src))
				if(M == user)	continue
				M.show_message("\blue [user.name] inserts the [dish.name] in the [src.name]", 3)
				icon_state = "analyzer1"


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
//			var/r = "GNAv2 based virus lifeform"
			var/r
//			r += "<BR>Infection rate : [dish.virus2.infectionchance * 10]"
//			r += "<BR>Spread form : [dish.virus2.spreadtype]"
//			r += "<BR>Progress Speed : [dish.virus2.stageprob * 10]"
//			for(var/datum/disease2/effectholder/E in dish.virus2.effects)
//				r += "<BR>Effect:[E.effect.name]. Strength : [E.multiplier * 8]. Verosity : [E.chance * 15]. Type : [5-E.stage]."
			var/datum/reagents/E = dish.reagents
			var/datum/reagent/blood/Blood = null
			for(var/datum/reagent/blood/B in E.reagent_list)
				if(B)
					Blood = B
					break
			if(!E.total_volume||!E.reagent_list.len)
				r += "The dish is clean<BR>"
			else if(!Blood)
				r += "No proper blood sample found in the dish"
			else
				r += "<h3>Blood sample data:</h3>"
				r += "<b>Blood DNA:</b> [(Blood.data["blood_DNA"]||"none")]<BR>"
				r += "<b>Blood Type:</b> [(Blood.data["blood_type"]||"none")]<BR>"
				var/datum/disease/D = Blood.data["virus"]
				r += "<b>Agent of disease:</b> [D?"[D.agent] - <A href='?src=\ref[src];create_virus_culture=[D.type]'>Create virus culture bottle</A>":"none"]<BR>"
				if(D)
					r += "<b>Common name:</b> [(D.name||"none")]<BR>"
					r += "<b>Possible cure:</b> [(D.cure||"none")]<BR>"
				r += "<b>Contains antibodies to:</b> "
				if(Blood.data["resistances"])
					var/list/res = Blood.data["resistances"]
					if(res.len)
						r += "<ul>"
						for(var/type in Blood.data["resistances"])
							var/datum/disease/DR = new type
							r += "<li>[DR.name]</li>"
							del(DR)
						r += "</ul><BR>"
					else
						r += "nothing<BR>"
				else
					r += "nothing<BR>"

			var/obj/item/weapon/paper/P = new /obj/item/weapon/paper(src.loc)
			P.info = r
//			dish.info = r
//			dish.analysed = 1
			dish.loc = src.loc
			dish = null
			icon_state = "analyser"

			for(var/mob/O in hearers(src, null))
				O.show_message("\icon[src] \blue The [src.name] prints a sheet of paper.", 3)

			spawn(25)
				dish.loc = src.loc
				dish = null
				icon_state = "analyzer1"
				for(var/mob/M in viewers(src))
					M.show_message("\icon[src] \blue The [src.name] buzzes", 2)
/*	else if(dish && !scanning && !pause)
//		if(dish.virus2 && dish.growth > 50)
			dish.growth -= 10
			scanning = 25
			icon_state = "analyser_processing"
		else
			pause = 1
			spawn(25)
				dish.loc = src.loc
				dish = null
				for(var/mob/M in viewers(src))
					M.show_message("\icon[src] \blue The [src.name] buzzes", 2)
				pause = 0
*/


	return