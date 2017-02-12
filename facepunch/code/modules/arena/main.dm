//This is so we can access it easily
var/global/list/mob/living/carbon/arenaplayers = list()
var/global/datum/team/greenteam = new/datum/team
var/global/datum/team/redteam = new/datum/team
//Hold each team's players and score

/datum/team
	var/name
	var/teamname
	var/score
	var/list/mob/living/carbon/human/players = list()



/obj/structure/joiner
	name = "joiner"
	desc = "joiner"
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "filmer"
	var/team = 0
	var/palyers = 0
	var/off = 0
//	var/list = arenaplayers
	attack_hand()
		if(off)
			return
		if(usr in arenaplayers)
			arenaplayers.Remove(usr)
			usr << "You have been removed from the waiting list for the arena"
			palyers--
		else
			usr << "You are now on the waiting list for the arena"
			arenaplayers.Add(usr)
			palyers++
			if(palyers >= 8)
				start()
			return

	/proc/start()
		for(var/mob/living/carbon/D in arenaplayers)
			D << "\red The games have begun! Enter a Pod and play!"
			spawn(80)
				playsound(D.loc, 'sound/voice/arena/countdown.ogg', 25, 1)
				spawn(40)
					for(var/obj/effect/cultbarrier/arena/C in world)
						del(C)
					for(var/obj/structure/arena/generator/S in world)
						processing_objects.Add(S)
						S.on = 1
/obj/structure/arena/generator
	name = "Resource Generator"
	desc = "joiner"
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "filmer"
	var/team = 0
	var/on = 0
	var/counter = 0	//Goes up once per tick
	var/countamount = 30 //How many var/counters it takes
	var/spawned = 0 //The amount of resources spawned
	process()
		if(on && spawned <= 50)
			counter++
			if(counter == countamount)
				new/obj/item/resource(src.loc)
				counter = 0
				spawned++

	attack_hand()
		on = 1
		processing_objects.Add(src)

/obj/structure/arena/collector
	name = "Resource Collector"
	desc = "Put your teams resources into here"
	icon = 'icons/obj/mining.dmi'
	icon_state = "orebox"
	var/amount = 0
	var/team = 0 // 1 or 2
/obj/item/resource
	icon = 'icons/obj/mining.dmi'
	icon_state = "adamantite-core"
	name = "Resource"

/obj/machinery/vrpod
	name = "Virtual Realityator"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "vrpod2"
	density = 1
	anchored = 1
	var/orient = "LEFT" // "RIGHT" changes the dir suffix to "-r"
	var/mob/living/occupant = null
	var/mob/living/linkedmob = null
	use_power = USE_POWER_IDLE
	active_power_usage = 500
	idle_power_usage = 100

	New()
		switch(orient)
			if("LEFT")
				icon_state = "vrpod2"
			if("RIGHT")
				icon_state = "sleeper_0-r"

	process()
		if(occupant && linkedmob)
			if(occupant.stat == 2)//Main body dies
				if(linkedmob.stat == 0)
					occupant.client = linkedmob.client
					occupant.loc = src.loc
					linkedmob = null
					occupant = null
					icon_state = "vrpod2"
			if(linkedmob.stat == 2)//VR body dies
				occupant.client = linkedmob.client
				occupant.loc = src.loc
				linkedmob = null
				occupant = null
				icon_state = "vrpod2"
	blob_act()
		if(prob(75))
			for(var/atom/movable/A as mob|obj in src)
				A.loc = src.loc
				A.blob_act()
			del(src)
		return





	ex_act(severity)
		switch(severity)
			if(1.0)
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
				del(src)
				return
			if(2.0)
				if(prob(50))
					for(var/atom/movable/A as mob|obj in src)
						A.loc = src.loc
						ex_act(severity)
					del(src)
					return
			if(3.0)
				if(prob(25))
					for(var/atom/movable/A as mob|obj in src)
						A.loc = src.loc
						ex_act(severity)
					del(src)
					return
		return
	emp_act(severity)
		if(stat & (BROKEN|NOPOWER))
			..(severity)
			return
		if(occupant)
			go_out()
		..(severity)


	proc/go_out()
		if(!src.occupant)
			return
		use_power = USE_POWER_IDLE
		for(var/obj/O in src)
			O.loc = src.loc
		if(src.occupant.client)
			src.occupant.client.eye = src.occupant.client.mob
			src.occupant.client.perspective = MOB_PERSPECTIVE
		src.occupant.loc = src.loc
		src.occupant = null
		if(orient == "RIGHT")
			icon_state = "sleeper_0-r"
		return



	verb/eject()
		set name = "Eject Sleeper"
		set category = "Object"
		set src in oview(1)
		if(usr.stat != 0)
			return
		if(usr == occupant)//Only the user
			src.go_out()
		add_fingerprint(usr)
		if(orient == "RIGHT")
			icon_state = "vrpod21"
		else
			src.icon_state = "vrpod2"
		return


	verb/move_inside()
		set name = "Enter Sleeper"
		set category = "Object"
		set src in oview(1)

		if(usr in arenaplayers)
			usr << "You have not signed up!"
			return

		if(usr.stat != 0 || !(ishuman(usr) || ismonkey(usr)))
			return

		if(src.occupant)
			usr << "\blue <B>The sleeper is already occupied!</B>"
			return

		for(var/mob/living/carbon/slime/M in range(1,usr))
			if(M.Victim == usr)
				usr << "You're too busy getting your life sucked out of you."
				return
		visible_message("[usr] starts climbing into the sleeper.", 3)
		if(do_after(usr, 20))
			if(src.occupant)
				usr << "\blue <B>The sleeper is already occupied!</B>"
				return
			use_power = USE_POWER_ACTIVE
			usr.stop_pulling()
			usr.client.perspective = EYE_PERSPECTIVE
			usr.client.eye = src
			usr.loc = src
			src.occupant = usr
			src.icon_state = "vrpod2"
			if(orient == "RIGHT")
				icon_state = "sleeper_1-r"

			for(var/obj/O in src)
				del(O)
			src.add_fingerprint(usr)
			icon_state = "vrpod1"
			if(occupant)
				occupant.client.lastknownmob = usr
				var/mob/living/carbon/human/virtualreality/S1 = new/mob/living/carbon/human/virtualreality
				S1.prevmob = usr.client.mob
				S1.prevname = usr.client.mob.real_name
				linkedmob = S1
				var/team = rand(1,2)
				var/mob/living/carbon/human/M = S1
				switch(team)
					if(1)
						M.equip_to_slot_or_del(new /obj/item/clothing/under/color/green(M), slot_w_uniform)
						M.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/tdome/green(M), slot_wear_suit)
						M.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(M), slot_shoes)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(M), slot_gloves)
						M.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/eyepatch(M), slot_glasses)
						M.equip_to_slot_or_del(new /obj/item/clothing/mask/cigarette/cigar/havana(M), slot_wear_mask)
						M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/thunderdome(M), slot_head)
						M.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/gun/nuclear(M), slot_belt)
						M.update_icons()
						for(var/list/obj/effect/landmark/vrstart/g/G in world)
							M.loc = G.loc
					if(2)
						M.equip_to_slot_or_del(new /obj/item/clothing/under/color/red(M), slot_w_uniform)
						M.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/tdome/red(M), slot_wear_suit)
						M.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(M), slot_shoes)
						M.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(M), slot_gloves)
						M.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/eyepatch(M), slot_glasses)
						M.equip_to_slot_or_del(new /obj/item/clothing/mask/cigarette/cigar/havana(M), slot_wear_mask)
						M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/thunderdome(M), slot_head)
						M.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/gun/nuclear(M), slot_belt)
						M.update_icons()
						for(var/list/obj/effect/landmark/vrstart/r/R in world)
							M.loc = R.loc
				for(var/obj/item/X in S1)
					X.can_remove = 0
				usr.client.mob = S1
				S1.linkedmachine = src
				S1.client.screen += new /obj/screen/exit2
				S1 << "Welcome to the system, [occupant]. Your body will remain were it last was, and it can be moved away from the machine. We are not responsible to any harm your main body has. If you die in the simulation, you will be put back in your body no matter the state unless it was blown up. You can also manually return to your body. Right click the pod after you have awoken and Eject yourself from it."
			return
		return