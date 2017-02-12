/datum/targetable/spell/animatedead
	name = "Animate Dead"
	desc = "Turns a human corpse into a skeletal minion."
	icon_state = "pet"
	targeted = 1
	max_range = 1
	cooldown = 850
	requires_robes = 1
	offensive = 1
	cooldown_staff = 1
	sticky = 1

	cast(mob/target)
		if(!holder)
			return
		if(target.stat != 2)
			boutput(holder.owner, "<span style=\"color:red\">That person is still alive! Find a corpse.</span>")
			return 1 // No cooldown when it fails.

		holder.owner.say("EI NECRIS")
		playsound(holder.owner.loc, "sound/voice/wizard/AnimateDeadLoud.ogg", 50, 0, -1)

		var/obj/critter/magiczombie/UMMACTUALLYITSASKELETONNOWFUCKZOMBIESFOREVER = new /obj/critter/magiczombie(get_turf(target)) // what the fuck
		UMMACTUALLYITSASKELETONNOWFUCKZOMBIESFOREVER.CustomizeMagZom(target.real_name)

		boutput(holder.owner, "<span style=\"color:blue\">You saturate [target] with dark magic!</span>")
		holder.owner.visible_message("<span style=\"color:red\">[holder.owner] rips the skeleton from [target]'s corpse!</span>")

		for(var/obj/item/I in target)
			if(istype(target, /obj/item))
				target.u_equip(I)
				if(I)
					I.set_loc(target.loc)
					I.dropped(target)
		target.gib(1)
