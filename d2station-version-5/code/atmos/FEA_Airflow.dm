

var/OXYGEN_LOSS = 1
var/OXYGEN_LOSS_DESC = "A multiplier for damage due to lack of air, CO2 poisoning, and vacuum. Does not affect oxyloss\
	from being incapacitated or dying."
var/TEMP_DMG = 1
var/TEMP_DMG_DESC = "A multiplier for damage due to body temperature irregularities."
var/BURN_DMG = 4
var/BURN_DMG_DESC = "A multiplier for damage due to direct fire exposure."

var/AF_TINY_MOVEMENT_THRESHOLD = 5 //% difference to move tiny items.
var/AF_TINY_MOVEMENT_THRESHOLD_DESC = "Percent of 1 Atm. at which items with the tiny weight class will move."
var/AF_SMALL_MOVEMENT_THRESHOLD = 10 //% difference to move small items.
var/AF_SMALL_MOVEMENT_THRESHOLD_DESC = "Percent of 1 Atm. at which items with the small weight class will move."
var/AF_NORMAL_MOVEMENT_THRESHOLD = 35 //% difference to move normal items.
var/AF_NORMAL_MOVEMENT_THRESHOLD_DESC = "Percent of 1 Atm. at which items with the normal weight class will move."
var/AF_LARGE_MOVEMENT_THRESHOLD = 90 //% difference to move large and huge items.
var/AF_LARGE_MOVEMENT_THRESHOLD_DESC = "Percent of 1 Atm. at which items with the large or huge weight class will move."
var/AF_MOVEMENT_THRESHOLD = 70 //% difference to move dense crap and mobs.
var/AF_MOVEMENT_THRESHOLD_DESC = "Percent of 1 Atm. at which dense objects or mobs will be shifted by airflow."

var/AF_HUMAN_STUN_THRESHOLD = 90
var/AF_HUMAN_STUN_THRESHOLD_DESC = "Percent of 1 Atm. at which living things are stunned or knocked over."

var/AF_PERCENT_OF = ONE_ATMOSPHERE
var/AF_PERCENT_OF_DESC = "Normally set to 1 Atm. in kPa, this indicates what pressure is considered 100% by the system."

var/AF_CANISTER_P = ONE_ATMOSPHERE*20
var/AF_CANISTER_P_DESC = "Unused, will be used to calculate airflow from canisters."

var/AF_SPEED_MULTIPLIER = 5 //airspeed per movement threshold value crossed.
var/AF_SPEED_MULTIPLIER_DESC = "Airspeed increase per \[AF_TINY_MOVEMENT_THRESHOLD\] percent of airflow."
var/AF_DAMAGE_MULTIPLIER = 3 //Amount of damage applied per airflow_speed.
var/AF_DAMAGE_MULTIPLIER_DESC = "Amount of damage applied per unit of speed (1-15 units) at which mobs are thrown."
var/AF_STUN_MULTIPLIER = 0.02 //Seconds of stun applied per airflow_speed.
var/AF_STUN_MULTIPLIER_DESC = "Amount of stun effect applied per unit of speed (1-15 units) at which mobs are thrown."
var/AF_SPEED_DECAY = 1.5 //Amount that flow speed will decay with time.
var/AF_SPEED_DECAY_DESC = "Amount of airflow speed lost per tick on a moving object."
var/AF_SPACE_MULTIPLIER = 20 //Increasing this will make space connections more DRAMATIC!
var/AF_SPACE_MULTIPLIER_DESC = "Increasing this multiplier will cause more powerful airflow to space, and vice versa."

var/air_base_thresh = (5/100) * ONE_ATMOSPHERE
var/air_base_thres_DESC = "Do not alter in the course of normal gameplay, unless you changed AF_TINY_MOVEMENT_THRESHOLD\
	 or PERCENT_OF and airflow no longer works, in which case it should be set to (AF_TINY_MOVEMENT_THRESHOLD/100)*PERCENT_OF."

mob/proc
	Change_Airflow_Constants()
		set category = "Debug"

		var/choice = input("Which constant will you modify?","Change Airflow Constants")\
		as null|anything in list("Movement Threshold","Speed Multiplier","Damage Multiplier","Stun Multiplier","Speed Decay")

		var/n

		switch(choice)
			if("Movement Threshold")
				n = input("What will you change it to","Change Airflow Constants",AF_MOVEMENT_THRESHOLD) as num
				n = max(1,n)
				AF_MOVEMENT_THRESHOLD = n
				world.log << "AF_MOVEMENT_THRESHOLD set to [n]."
			if("Speed Multiplier")
				n = input("What will you change it to","Change Airflow Constants",AF_SPEED_MULTIPLIER) as num
				n = max(1,n)
				AF_SPEED_MULTIPLIER = n
				world.log << "AF_SPEED_MULTIPLIER set to [n]."
			if("Damage Multiplier")
				n = input("What will you change it to","Change Airflow Constants",AF_DAMAGE_MULTIPLIER) as num
				AF_DAMAGE_MULTIPLIER = n
				world.log << "AF_DAMAGE_MULTIPLIER set to [n]."
			if("Stun Multiplier")
				n = input("What will you change it to","Change Airflow Constants",AF_STUN_MULTIPLIER) as num
				AF_STUN_MULTIPLIER = n
				world.log << "AF_STUN_MULTIPLIER set to [n]."
			if("Speed Decay")
				n = input("What will you change it to","Change Airflow Constants",AF_SPEED_DECAY) as num
				AF_SPEED_DECAY = n
				world.log << "AF_SPEED_DECAY set to [n]."
			if("Space Flow Multiplier")
				n = input("What will you change it to","Change Airflow Constants",AF_SPEED_DECAY) as num
				AF_SPEED_DECAY = n
				world.log << "AF_SPEED_DECAY set to [n]."

//turf/verb/TossMeHere(n as num,use_airflow as anything in list("Use Airflow Destination","Use Zone Airflow Rules"))
//	set src in view()
//	if(use_airflow == "Use Airflow Destination")
//		usr.airflow_dest = src
//		usr.GotoAirflowDest(n)
//	else
//		var/turf/T = usr.loc
//		if(zone != T.zone)
//			Airflow(zone,T.zone,n)

//mob/verb/TestAirflow(m as num,n as num)
//	n = abs(m - n)
//	n = round(n/AF_PERCENT_OF * 100,0.1)
//
//	if(n < 0)
//		usr << "Fail: n\[[n]\] < 0."
//	if(abs(n) > AF_TINY_MOVEMENT_THRESHOLD)
//		usr << "Success: n\[[n]\] > threshold\[[AF_TINY_MOVEMENT_THRESHOLD]\]."
//	else
//		usr << "Fail: n\[[n]\] < threshold\[[AF_TINY_MOVEMENT_THRESHOLD]\]."

proc/Airflow(zone/A,zone/B,n)

	//return
	//Comment this out to use airflow again.
	//world << "Airflow called with [n] as gas difference."
//	world << "Airflow threshold is [(AF_TINY_MOVEMENT_THRESHOLD/100) * AF_PERCENT_OF]"
//	sleep(-1)
	if(n < air_base_thresh) return
	n = round(n/AF_PERCENT_OF * 100,0.1)
	var/list/connected_turfs = A.connections[B]
	var/list/pplz = A.movables()
	var/list/otherpplz = B.movables()
	if(1)
		//world << "<b>Airflow!</b>"
		if(ticker)
			if(ticker.current_state == 3)
				if(prob(10))
					world << sound('turbulence.ogg', volume=rand(2,5))
				if(prob(10))
					world << sound('Hullcreak.ogg', volume=rand(2,5))
				if(prob(10))
					world << sound('industrial_suspense1.ogg', volume=2)
				if(prob(10))
					world << sound('industrial_suspense2.ogg', volume=2)
		/*
		if(prob(10))
			world << sound('turbulence.ogg', volume=rand(5,20))
		if(prob(10))
			world << sound('turbulence.ogg', volume=rand(5,20))
		if(prob(10))
			world << sound('turbulence.ogg', volume=rand(5,20))
		*/
		for(var/atom/movable/M in pplz)
			//world << "[M] / \..."


			if(M.anchored && !ismob(M)) continue
			if(istype(M,/mob/dead/observer)) continue
			if(istype(M,/mob/living/silicon/robot)) continue
			if(M.anchored && !ismob(M)) continue

			if(ismob(M) && n > AF_HUMAN_STUN_THRESHOLD)
				if(istype(src, /mob/living/carbon/human))
					if(src:buckled) continue
					if(src:shoes)
						if(src:shoes.airflowprot) continue
						if(M:weakened <= 0) M << "\red The sudden rush of air pushes you over!"
						M:weakened = max(M:weakened,5)
				else if(M:weakened <= 0) M << "\red The sudden rush of air pushes you over!"
				M:weakened = max(M:weakened,5)
			if(!istype(M,/obj/item) && n < AF_MOVEMENT_THRESHOLD) continue
			if(istype(M,/obj/item))
				switch(M:w_class)
					if(2)
						if(n < AF_SMALL_MOVEMENT_THRESHOLD) continue
					if(3)
						if(n < AF_NORMAL_MOVEMENT_THRESHOLD) continue
					if(4)
						if(n < AF_LARGE_MOVEMENT_THRESHOLD) continue
					if(5)
						if(n < AF_LARGE_MOVEMENT_THRESHOLD) continue
			var/fail = 1
			for(var/turf/U in connected_turfs)
				if(M in range(U)) fail = 0
			if(fail) continue
			//world << "Sonovabitch! [M] won't move!"
			if(!M.airflow_speed)
				M.airflow_dest = pick(connected_turfs)
				spawn M.GotoAirflowDest(abs(n) / (AF_TINY_MOVEMENT_THRESHOLD/AF_SPEED_MULTIPLIER))
			//else if(M.airflow_speed > 0)
			//	M.airflow_speed = abs(n) / (AF_MOVEMENT_THRESHOLD/AF_SPEED_MULTIPLIER)
		for(var/atom/movable/M in otherpplz)
			//world << "[M] / \..."
			if(istype(M,/mob/living/silicon/ai)) continue
			if(istype(M,/mob/dead/observer)) continue
			if(istype(M,/mob/living/silicon/robot)) continue
			if(M.anchored && !ismob(M)) continue

			if(ismob(M) && n > AF_HUMAN_STUN_THRESHOLD)
				if(istype(src, /mob/living/carbon/human))
					if(src:buckled) continue
					if(src:shoes)
						if(src:shoes.airflowprot) continue
						if(M:weakened <= 0) M << "\red The sudden rush of air pushes you over!"
						M:weakened = max(M:weakened,5)
				else if(M:weakened <= 0) M << "\red The sudden rush of air pushes you over!"
				M:weakened = max(M:weakened,5)
			if(!istype(M,/obj/item) && n < AF_MOVEMENT_THRESHOLD) continue
			if(istype(M,/obj/item))
				switch(M:w_class)
					if(2)
						if(n < AF_SMALL_MOVEMENT_THRESHOLD) continue
					if(3)
						if(n < AF_NORMAL_MOVEMENT_THRESHOLD) continue
					if(4)
						if(n < AF_LARGE_MOVEMENT_THRESHOLD) continue
					if(5)
						if(n < AF_LARGE_MOVEMENT_THRESHOLD) continue

			var/fail = 1
			for(var/turf/U in connected_turfs)
				if(M in range(U)) fail = 0
			if(fail) continue
			//world << "Sonovabitch! [M] won't move either!"
			if(M && !M.airflow_speed)
				M.airflow_dest = pick(connected_turfs)
				spawn M.RepelAirflowDest(abs(n) / (AF_TINY_MOVEMENT_THRESHOLD/AF_SPEED_MULTIPLIER))
		//	else if(M.airflow_speed > 0)
			//	M.airflow_speed = abs(n) / (AF_MOVEMENT_THRESHOLD/AF_SPEED_MULTIPLIER)
proc/AirflowSpace(zone/A)

	//return
	//Comment this out to use airflow again.
	//world << "Airflow called with [n] as gas difference."
//	world << "Airflow threshold is [(AF_TINY_MOVEMENT_THRESHOLD/100) * AF_PERCENT_OF]"
	var/n = (A.turf_oxy + A.turf_nitro + A.turf_co2)*AF_SPACE_MULTIPLIER
	if(n < air_base_thresh) return

	var/list/connected_turfs = A.space_connections
	var/list/pplz = A.movables()
	if(1)
		//world << "<b>Airflow!</b>"
		for(var/atom/movable/M in pplz)
			//world << "[M] / \..."


			if(M.anchored && !ismob(M)) continue
			if(istype(M,/mob/dead/observer)) continue
			if(istype(M,/mob/living/silicon/robot)) continue
			if(M.anchored && !ismob(M)) continue

			if(ismob(M) && n > AF_HUMAN_STUN_THRESHOLD)
				if(istype(M, /mob/living/carbon/human))
					if(M:buckled) continue
					if(M:shoes)
						if(M:shoes.airflowprot) continue
						if(M:weakened <= 0) M << "\red The sudden rush of air pushes you over!"
						M:weakened = max(M:weakened,5)
				else if(M:weakened <= 0) M << "\red The sudden rush of air pushes you over!"
				M:weakened = max(M:weakened,5)

			if(!istype(M,/obj/item) && n < AF_MOVEMENT_THRESHOLD) continue
			if(istype(M,/obj/item))
				switch(M:w_class)
					if(2)
						if(n < AF_SMALL_MOVEMENT_THRESHOLD) continue
					if(3)
						if(n < AF_NORMAL_MOVEMENT_THRESHOLD) continue
					if(4)
						if(n < AF_LARGE_MOVEMENT_THRESHOLD) continue
					if(5)
						if(n < AF_LARGE_MOVEMENT_THRESHOLD) continue

			var/fail = 1
			for(var/turf/U in connected_turfs)
				if(M in range(U)) fail = 0
			if(fail) continue
			//world << "Sonovabitch! [M] won't move!"
			if(!M.airflow_speed)
				M.airflow_dest = pick(connected_turfs)
				spawn
					if(M) M.GotoAirflowDest(abs(n) / (AF_TINY_MOVEMENT_THRESHOLD/AF_SPEED_MULTIPLIER))
			//else if(M.airflow_speed > 0)
			//	M.airflow_speed = abs(n) / (AF_MOVEMENT_THRESHOLD/AF_SPEED_MULTIPLIER)
proc/AirflowRepel(zone/A,turf/T,n)


	//return
	//Comment this out to use airflow again.
	//world << "Airflow(Repel) called with [n] as gas difference."
	//world << "Airflow threshold is [(AF_TINY_MOVEMENT_THRESHOLD/100) * AF_PERCENT_OF]"
	n = round(n/AF_CANISTER_P * 100,0.1)

	if(n < 0) return
	if(abs(n) > AF_TINY_MOVEMENT_THRESHOLD)
		//world << "Airflow!"
		var/list/pplz = A.movables()
		for(var/atom/movable/M in pplz)
			//world << "[M] / \..."
			if(istype(M,/mob/living/silicon/ai)) continue
			if(istype(M,/mob/dead/observer)) continue
			if(M.anchored && !ismob(M)) continue

			if(!istype(M,/obj/item) && n < AF_MOVEMENT_THRESHOLD) continue
			if(istype(M,/obj/item))
				switch(M:w_class)
					if(2)
						if(n < AF_SMALL_MOVEMENT_THRESHOLD) continue
					if(3)
						if(n < AF_NORMAL_MOVEMENT_THRESHOLD) continue
					if(4)
						if(n < AF_LARGE_MOVEMENT_THRESHOLD) continue
					if(5)
						if(n < AF_LARGE_MOVEMENT_THRESHOLD) continue
			if(!(M in range(T))) continue
			//world << "Sonovabitch! [M] won't move either!"
			if(!M.airflow_speed)
				M.airflow_dest = T
				spawn M.RepelAirflowDest(abs(n) / (AF_TINY_MOVEMENT_THRESHOLD/AF_SPEED_MULTIPLIER))
		//	else if(M.airflow_speed > 0)
			//	M.airflow_speed = abs(n) / (AF_MOVEMENT_THRESHOLD/AF_SPEED_MULTIPLIER)
proc/AirflowAttract(zone/A,turf/T,n)


	//return
	//Comment this out to use airflow again.
	//world << "Airflow(Repel) called with [n] as gas difference."
	//world << "Airflow threshold is [(AF_TINY_MOVEMENT_THRESHOLD/100) * AF_PERCENT_OF]"
	n = round(n/AF_CANISTER_P * 100,0.1)

	if(n < 0) return
	if(abs(n) > AF_TINY_MOVEMENT_THRESHOLD)
		//world << "Airflow!"
		var/list/pplz = A.movables()
		for(var/atom/movable/M in pplz)
			//world << "[M] / \..."
			if(istype(M,/mob/living/silicon/ai)) continue
			if(istype(M,/mob/dead/observer)) continue
			if(M.anchored && !ismob(M)) continue

			if(!istype(M,/obj/item) && n < AF_MOVEMENT_THRESHOLD) continue
			if(istype(M,/obj/item))
				switch(M:w_class)
					if(2)
						if(n < AF_SMALL_MOVEMENT_THRESHOLD) continue
					if(3)
						if(n < AF_NORMAL_MOVEMENT_THRESHOLD) continue
					if(4)
						if(n < AF_LARGE_MOVEMENT_THRESHOLD) continue
					if(5)
						if(n < AF_LARGE_MOVEMENT_THRESHOLD) continue
			if(!(M in range(T))) continue
			//world << "Sonovabitch! [M] won't move either!"
			if(!M.airflow_speed)
				M.airflow_dest = T
				spawn M.GotoAirflowDest(abs(n) / (AF_TINY_MOVEMENT_THRESHOLD/AF_SPEED_MULTIPLIER))
		//	else if(M.airflow_speed > 0)
			//	M.airflow_speed = abs(n) / (AF_MOVEMENT_THRESHOLD/AF_SPEED_MULTIPLIER)
atom/movable
	var/turf/airflow_dest
	var/airflow_speed = 0
	var/airflow_time = 0
	proc/GotoAirflowDest(n)
		if(!airflow_dest) return
		if(airflow_speed < 0) return
		if(airflow_speed)
			airflow_speed = n
			return
		if(airflow_dest == loc)
			step_away(src,loc)
		if(ismob(src))
			if(src:nodamage) return
			if(istype(src, /mob/living/carbon/human))
				if(istype(src, /mob/living/carbon/human))
					if(src:buckled) return
					if(src:shoes)
						if(src:shoes.airflowprot) return
			src << "\red You are pushed away by the strong rush of air!"
		airflow_speed = min(round(n),9)
		//world << "[src]'s headed to [airflow_dest] at [n] times the SPEED OF LIGHT!"
		//airflow_dest = get_step(src,Get_Dir(src,airflow_dest))
		var
			xo = airflow_dest.x - src.x
			yo = airflow_dest.y - src.y
			od = 0
		//world << "[xo],[yo]"
		airflow_dest = null
		if(!density)
			density = 1
			od = 1
		while(airflow_speed > 0)
			if(airflow_speed <= 0) return
			airflow_speed = min(airflow_speed,15)
			airflow_speed -= AF_SPEED_DECAY
			if(airflow_speed > 7)
				if(airflow_time++ >= airflow_speed - 7)
					sleep(1)
			else
				sleep(max(1,10-(airflow_speed+3)))
			if ((!( src.airflow_dest ) || src.loc == src.airflow_dest))
				src.airflow_dest = locate(min(max(src.x + xo, 1), world.maxx), min(max(src.y + yo, 1), world.maxy), src.z)
				//world << "New destination: [airflow_dest]"
			if ((src.x == 1 || src.x == world.maxx || src.y == 1 || src.y == world.maxy))
				return
			step_towards(src, src.airflow_dest)
			if(ismob(src) && src:client) src:client:move_delay = world.time + 10
		airflow_dest = null
		airflow_speed = -1
		spawn(50) airflow_speed = 0
		if(od)
			density = 0
	proc/RepelAirflowDest(n)
		if(!airflow_dest) return
		if(airflow_speed < 0) return
		if(airflow_speed)
			airflow_speed = n
			return
		if(airflow_dest == loc)
			step_away(src,loc)
		if(ismob(src))
			if(src:nodamage) return
			if(istype(src, /mob/living/carbon/human))
				if(istype(src, /mob/living/carbon/human))
					if(src:buckled) return
					if(src:shoes)
						if(src:shoes.airflowprot) return
				src << "\red You are pushed away by the rush of air!"
		airflow_speed = min(round(n),9)
		//airflow_dest = get_step(src,Get_Dir(airflow_dest,src))
		var
			xo = -(airflow_dest.x - src.x)
			yo = -(airflow_dest.y - src.y)
			od = 0
		airflow_dest = null
		if(!density)
			density = 1
			od = 1
		while(airflow_speed > 0)
			if(airflow_speed <= 0) return
			airflow_speed = min(airflow_speed,15)
			airflow_speed -= AF_SPEED_DECAY
			if(airflow_speed > 7)
				if(airflow_time++ >= airflow_speed - 7)
					sleep(1)
			else
				sleep(max(1,10-(airflow_speed+3)))
			if ((!( src.airflow_dest ) || src.loc == src.airflow_dest))
				src.airflow_dest = locate(min(max(src.x + xo, 1), world.maxx), min(max(src.y + yo, 1), world.maxy), src.z)
			if ((src.x == 1 || src.x == world.maxx || src.y == 1 || src.y == world.maxy))
				return
			step_towards(src, src.airflow_dest)
			if(ismob(src) && src:client) src:client:move_delay = world.time + 10
		airflow_dest = null
		airflow_speed = -1
		spawn(50) airflow_speed = 0
		if(od)
			density = 0
	Bump(atom/A)
		if(airflow_speed > 0 && airflow_dest)
			//if(istype(A,/obj/item)) return .
			//viewers(src) << "\red <b>[src] slams into [A]!</b>"
			if(ismob(src) || (isobj(src) && !istype(src,/obj/item)))
				//for(var/mob/M in hearers(src))
					//M.show_message("\red <B>[src] is thrown into [A]!</B>")
				if(istype(src,/mob/living/carbon/human))
					playsound(src.loc, "swing_hit", 25, 1, -1)
					loc:add_blood(src)
					if (src:wear_suit)
						src:wear_suit:add_blood(src)
					if (src:w_uniform)
						src:w_uniform:add_blood(src)
			if(istype(src,/mob/living/carbon/human))
				var/b_loss = airflow_speed * AF_DAMAGE_MULTIPLIER
				for(var/organ in src:organs)
					var/datum/organ/external/temp = src:organs["[organ]"]
					if (istype(temp, /datum/organ/external))
						switch(temp.name)
							if("head")
								temp.take_damage(b_loss * 0.2, 0)
							if("chest")
								temp.take_damage(b_loss * 0.4, 0)
							if("diaper")
								temp.take_damage(b_loss * 0.1, 0)
							if("l_arm")
								temp.take_damage(b_loss * 0.05, 0)
							if("r_arm")
								temp.take_damage(b_loss * 0.05, 0)
							if("l_hand")
								temp.take_damage(b_loss * 0.0225, 0)
							if("r_hand")
								temp.take_damage(b_loss * 0.0225, 0)
							if("l_leg")
								temp.take_damage(b_loss * 0.05, 0)
							if("r_leg")
								temp.take_damage(b_loss * 0.05, 0)
							if("l_foot")
								temp.take_damage(b_loss * 0.0225, 0)
							if("r_foot")
								temp.take_damage(b_loss * 0.0225, 0)
				spawn src:UpdateDamageIcon()
				if(airflow_speed > 10)
					src:paralysis += round(airflow_speed * AF_STUN_MULTIPLIER)
					src:stunned = max(src:stunned,src:paralysis + 1)
				else
					src:stunned += round(airflow_speed * AF_STUN_MULTIPLIER/2)
			airflow_speed = min(-1,airflow_speed-1)
			spawn(50) airflow_speed = min(0,airflow_speed+1)
			airflow_dest = null
		else if(!airflow_speed)
			. = ..()

zone/proc/movables()
	. = list()
	for(var/turf/T in members)
		for(var/atom/A in T)
			. += A

//obj/machinery/door/is_door = 1
//obj/machinery/door/poddoor/is_door = 1


proc/Get_Dir(atom/S,atom/T) //Shamelessly stolen from AJX.AdvancedGetDir
	var/GDist=get_dist(S,T)
	var/GDir=get_dir(S,T)
	if(GDist<=3)
		if(GDist==0) return 0
		if(GDist==1)
			return GDir


	var/X1=S.x*10
	var/X2=T.x*10
	var/Y1=S.y*10
	var/Y2=T.y*10
	var/Ref
	if(GDir==NORTHEAST)
		Ref=(X2/X1)*Y1
		if(Ref-1>Y2) .=EAST
		else if(Ref+1<Y2) .=NORTH
		else .=NORTHEAST
	else if(GDir==NORTHWEST)
		Ref=(1+((1-(X2/X1))))*Y1
		if(Ref-1>Y2) .=WEST
		else if(Ref+1<Y2) .=NORTH
		else .=NORTHWEST
	else if(GDir==SOUTHEAST)
		Ref=(1-((X2/X1)-1))*Y1
		if(Ref-1>Y2) .=SOUTH
		else if(Ref+1<Y2) .=EAST
		else .=SOUTHEAST
	else if(GDir==SOUTHWEST)
		Ref=(X2/X1)*Y1
		if(Ref-1>Y2) .=SOUTH
		else if(Ref+1<Y2) .=WEST
		else .=SOUTHWEST
	else
		return GDir

proc/SaveTweaks()
	var/savefile/F = new("data/game_settings.sav")
	F << vs_control
	del F
	world.log << "TWEAKS: Airflow, Plasma and Damage settings saved."
proc/LoadTweaks()
	if(fexists("data/game_settings.sav"))
		var/savefile/F = new("data/game_settings.sav")
		F >> vs_control
		del F
		world.log << "TWEAKS: Airflow, Plasma and Damage settings loaded."