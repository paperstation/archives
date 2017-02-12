/obj/machinery/disease2/monkeycloner
	name = "Monkey dispenser"
	icon = 'cloning.dmi'
	icon_state = "pod_0"
	density = 1
	anchored = 1

	var/cloning = 0

/obj/machinery/disease2/monkeycloner/attack_hand()
	if(stat & (NOPOWER|BROKEN))
		return

	if(!cloning)
		cloning = 30

		icon_state = "pod_g"
		process()

/obj/machinery/disease2/monkeycloner/process()
	if(stat & (NOPOWER|BROKEN))
		icon_state = "pod_0"
		cloning = 30
		return

	use_power(5000)
	src.updateDialog()

	if(cloning)
		cloning -= 1
		if(!cloning)
			new /mob/living/carbon/monkey(src.loc)
			icon_state = "pod_0"



	return


/obj/machinery/disease2/babycloner
	name = "Baby dispenser"
	icon = 'cloning.dmi'
	icon_state = "pod_0"
	density = 1
	anchored = 1

	var/cloning = 0

/obj/machinery/disease2/babycloner/attack_hand()
	if(stat & (NOPOWER|BROKEN))
		return

	if(!cloning)
		cloning = 10

		icon_state = "pod_g"
		process()

/obj/machinery/disease2/babycloner/process()
	if(stat & (NOPOWER|BROKEN))
		icon_state = "pod_0"
		cloning = 10
		return

	use_power(5000)
	src.updateDialog()

	if(cloning)
		cloning -= 1
		if(!cloning)
			new /obj/livestock/baby(src.loc)
			icon_state = "pod_0"



	return
