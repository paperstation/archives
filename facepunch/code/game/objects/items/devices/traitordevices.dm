/*

Miscellaneous traitor devices

BATTERER


*/

/*

The Batterer, like a flashbang but 50% chance to knock people over. Can be either very
effective or pretty fucking useless.

*/

/obj/item/device/batterer
	name = "mind batterer"
	desc = "A strange device with twin antennas."
	icon_state = "batterer"
	w_class = 1.0
	flags = FPRINT | TABLEPASS| CONDUCT
	item_state = "electronic"
	origin_tech = "magnets=3;combat=3;syndicate=3"

	var/times_used = 0 //Number of times it's been used.
	var/max_uses = 2


/obj/item/device/batterer/attack_self(mob/living/carbon/user as mob, flag = 0, emp = 0)
	if(!user) 	return
	if(times_used >= max_uses)
		user << "\red The mind batterer has been burnt out!"
		return

	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used [src] to knock down people in the area.</font>")

	for(var/mob/living/carbon/human/M in orange(10, user))
		spawn()
			if(prob(50))

				M.deal_damage(rand(10,20), WEAKEN)
				M.deal_damage(10, STUTTER)
				M << "\red <b>You feel a tremendous, paralyzing wave flood your mind.</b>"

			else
				M << "\red <b>You feel a sudden, electric jolt travel through your head.</b>"

	playsound(src.loc, 'sound/misc/interference.ogg', 50, 1)
	user << "\blue You trigger [src]."
	times_used += 1
	if(times_used >= max_uses)
		icon_state = "battererburnt"





/obj/item/device/relocate
	name = "relocater"
	desc = "Can send its bound master about 10 seconds back in time."
	icon_state = "batterer"
	w_class = 1.0
	flags = FPRINT | TABLEPASS| CONDUCT
	item_state = "electronic"
	origin_tech = "magnets=3;combat=3;syndicate=3"
	var/on = 0
	var/times_used = 0 //Number of times it's been used.
	var/max_uses = 2
	var/weakened
	var/disabilities
	var/sdisabilities
	var/srcloc
	var/x1
	var/y1
	var/z1
	var/tick = 10
	var/mob/living/carbon/user1
	var/cooldown
	var/jitter
	var/dizzy
	var/healthz
	var/suicide
	var/stut
	var/jitteriness
	var/sleeping
/obj/item/device/relocate/process()
	tick--
	if(tick == 0)
		disabilities = user1.disabilities
		sdisabilities = user1.sdisabilities
		weakened = user1.weakened
		x1 = user1.x
		y1 = user1.y
		z1 = user1.z
		jitteriness = user1.jitteriness
		jitter = user1.is_jittery
		stut = user1.stuttering
		suicide = user1.suiciding
		sleeping = user1.sleeping
		health = user1.health
		srcloc = user1.loc
		tick = 10

/obj/item/device/relocate/attack_self(mob/living/carbon/user as mob, flag = 0, emp = 0)
	if(!user) 	return
	if(!on)
		on = 1
		user1 = user
		user << "You turn the relocator on. Every 10 seconds it will save your position and body state allowing you to recall back to it."
		processing_objects.Add(src)
		//So it saves their current state
		disabilities = user1.disabilities
		sdisabilities = user1.sdisabilities
		weakened = user1.weakened
		x1 = user1.x
		y1 = user1.y
		z1 = user1.z
		srcloc = user1.loc
	else
		if(cooldown < world.time - 50)
			if(user1 == user)
				user1 << "You rollback your time"
			else
				user << "You rollback time for the unlucky sap who owned this"
				user1 << "You rollback in time."
			user1.disabilities = disabilities
			user1.sdisabilities = sdisabilities
			user1.weakened = weakened
			user1.x = x1
			user1.y = y1
			user1.z = z1
			user1.jitteriness = jitteriness
			user1.is_jittery = jitter
			user1.stuttering = stut
			user1.suiciding = suicide
			user1.sleeping = sleeping
			user1.health = healthz
			user1.loc = srcloc
			cooldown = world.time
			playsound(loc, 'sound/effects/relocate.ogg', 30, 1)
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(5, 2, user)
			s.start()
		else
			user << "The device is still on cooldown"