/obj/alien/flower/New()
	if(aliens_allowed)
		spawn(10)
			src.flower_life()
	else
		del(src)

/obj/alien/flower/proc/belch()
	spawn(10)
		for (var/turf/simulated/floor/target in range(1,src))
			if(!target.blocks_air)
				if(target.parent)
					target.parent.suspend_group_processing()
				var/datum/gas_mixture/payload = new
				payload.toxins = 25
				target.air.merge(payload)

/obj/alien/flower/proc/flower_life()
	if(health)
		spawn(200)
			belch()
			src.flower_life()

/obj/alien/flower/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage
	healthcheck()
	return

/obj/alien/flower/attackby(var/obj/item/weapon/W, var/mob/user)
	if(health <= 0)
		return
	src.visible_message("\red <B>\The [src] has been attacked with \the [W][(user ? " by [user]." : ".")]")
	var/damage = W.force
	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.welding)
			damage = 15
			playsound(src.loc, 'Welder.ogg', 100, 1)
	src.health -= damage
	src.healthcheck()

/obj/alien/flower/proc/healthcheck()
	if(health <= 0)
		src.icon_state = "flower_dead"

/obj/alien/flower/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 500)
		health -= 5
		healthcheck()