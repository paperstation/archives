/turf/unsimulated/floor
	name = "floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "floor"

/turf/unsimulated/floor/plating
	name = "plating"
	icon_state = "plating"
	intact = 0

/turf/unsimulated/floor/bluegrid
	icon = 'icons/turf/floors.dmi'
	icon_state = "bcircuit"

/turf/unsimulated/floor/engine
	icon_state = "engine"

/turf/unsimulated/floor/attack_paw(user as mob)
	return src.attack_hand(user)



/turf/unsimulated/floor/mars
	icon_state = "ironsand1"
	temperature = 420 //look hell's temp cap is 445c it doesn't really matter as long as it's under 445c

/turf/unsimulated/floor/mars/New()
	icon_state = "ironsand[rand(1, 15)]" //changes up them boring floors for you
	..()

/turf/unsimulated/floor/plasma
	icon_state = "pasteroid0"
	toxins = 50000

/turf/unsimulated/floor/plasma/New()
	icon_state = "pasteroid[rand(0, 12)]" //changes up them boring floors for you
	..()

/turf/unsimulated/floor/lava
	icon = 'icons/turf/floors.dmi'
	icon_state = "lava"
	desc = "Holy shit, that's lava!"
	temperature = 99999

/* fuck it
/turf/unsimulated/floor/lava/Enter(mob/living/M as mob)
	if(prob(70))
		return //stop them from entering because we don't want you to always plunge in and die
	if(prob(30))
		..() */

/turf/unsimulated/floor/lava/Entered(mob/living/M as mob)
	visible_message("<span class='danger'>[M] plunges into the lava!</span>", "<span class='danger'>You fall into the lava!</span>")
	M.emote("scream")
	M.dust()


