/obj/machinery/computer/diseasesplicer
	name = "Disease Splicer"
	icon = 'computer.dmi'
	icon_state = "splicer"
//	brightnessred = 0
//	brightnessgreen = 2
//	brightnessblue = 2
	broken_icon
	var/datum/disease/effectholder/memorybank = null
	var/analysed = 0
	var/obj/item/weapon/reagent_containers/
	var/burning = 0
	var/splicing = 0
	var/scanning = 0

/obj/machinery/computer/diseasesplicer/proc/newvirus()
	var/datum/disease/holder/A = new /datum/disease/holder
	A.newviruscreation()
	var/obj/item/weapon/reagent_containers/glass/bottle/blood/B = new /obj/item/weapon/reagent_containers/glass/bottle/blood(1)
	var/list/data = list("viruses"= list(A))
	B.reagents.add_reagent("blood", 20, data)
	B.loc = src.loc


/obj/machinery/computer/diseasesplicer/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/diseasesplicer/attack_paw(var/mob/user as mob)

	return src.attack_hand(user)
	return

/obj/machinery/computer/diseasesplicer/attack_hand(var/mob/user as mob)
	newvirus()