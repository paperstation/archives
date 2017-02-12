/mob/living/silicon/ai/proc/lockdown()
	set category = "AI Commands"
	set name = "Lockdown"

	if(usr.stat == 2)
		usr <<"You cannot initiate lockdown because you are dead!"
		return

	//world << "\red Lockdown initiated by [usr.name]!"
	//world << sound('Alarm.ogg', volume=90)

//	for(var/obj/machinery/firealarm/FA in world) //activate firealarms
//		spawn( 0 )
//			if(FA.lockdownbyai == 0)
//				FA.lockdownbyai = 1
//				FA.alarm()
	for(var/obj/machinery/door/airlock/AL in airlocks) //close airlocks
		spawn( 0 )
			if(AL.canAIControl() && AL.lockdownbyai == 0)
				AL.close()
				AL.lockdownbyai = 1
				AL.locked = 1
				AL.update_icon()
	for(var/obj/machinery/door/firedoor/D in doors)
		if(!D.blocked)
			if(D.operating)
				D.nextstate = CLOSED
			else if(!D.density)
				spawn(0)
				D.close()

	var/obj/machinery/computer/communications/C = locate() in machines
	if(C)
		C.post_status("alert", "lockdown")

/*	src.verbs -= /mob/living/silicon/ai/proc/lockdown
	src.verbs += /mob/living/silicon/ai/proc/disablelockdown
	usr << "\red Disable lockdown command enabled!"
	winshow(usr,"rpane",1)
*/

/mob/living/silicon/ai/proc/disablelockdown()
	set category = "AI Commands"
	set name = "Disable Lockdown"

	if(usr.stat == 2)
		usr <<"You cannot disable lockdown because you are dead!"
		return

	world << "\red Lockdown cancelled by [usr.name]!"

//	for(var/obj/machinery/firealarm/FA in world) //deactivate firealarms
///		spawn( 0 )
//			if(FA.lockdownbyai == 1)
//				FA.lockdownbyai = 0
//				FA.reset()
	for(var/obj/machinery/door/airlock/AL in airlocks) //open airlocks
		spawn ( 0 )
			if(AL.canAIControl() && AL.lockdownbyai == 1)
				AL.lockdownbyai = 0
				AL.locked = 0
				AL.update_icon()

	for(var/obj/machinery/door/firedoor/D in doors)
		if(!D.blocked)
			if(D.operating)
				D.nextstate = OPEN
			else if(D.density)
				spawn(0)
				D.open()

/*	src.verbs -= /mob/living/silicon/ai/proc/disablelockdown
	src.verbs += /mob/living/silicon/ai/proc/lockdown
	usr << "\red Disable lockdown command removed until lockdown initiated again!"
	winshow(usr,"rpane",1)
*/