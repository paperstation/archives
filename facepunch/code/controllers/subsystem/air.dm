var/datum/subsystem/air/SSair
/datum/subsystem/air
	name = "Air"
	wait = 50

	var/obj/effect/overlay/plmaster
	var/obj/effect/overlay/slmaster
	var/obj/effect/overlay/ablmaster

/datum/subsystem/air/New()
	if(SSair != src)
		SSair = src

/datum/subsystem/air/Initialize()
	set background = 1
	..()
	plmaster	= new /obj/effect/overlay{icon='icons/effects/tile_effects.dmi';mouse_opacity=0;layer=5;icon_state="plasma"}()
	slmaster	= new /obj/effect/overlay{icon='icons/effects/tile_effects.dmi';mouse_opacity=0;layer=5;icon_state="sleeping_agent"}()
	ablmaster	= new /obj/effect/overlay{icon='icons/effects/tile_effects.dmi';mouse_opacity=0;layer=5;icon_state="agentb"}()

	if(!air_master)
		air_master = new
		air_master.setup()

/datum/subsystem/air/fire()
	air_master.process()
