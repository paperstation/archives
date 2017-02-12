/*
AWWWWWWW YEAAHH NON FUNCTIONING ALPHA CONCEPT SCRIPTS
-Nernums
*/



/mob/living/carbon/human/var/dropcount = 0

/mob/living/carbon/human/proc/grav_init()

	grav_loop()

/mob/living/carbon/human/proc/grav_loop()
	var/turf/simulated/T = get_turf(src)
	if(istype(get_turf(src), /turf/openspace)
		movemob z-1
		dropcount + 1
		sleep(5)		//the reason this is set so low is so that we can fall quickly, this loop is not always on, its only in affect when on empty space. -Nernums
		grav_loop()


	else if(!istype(get_turf(src), /turf/openspace)
		if dropcount == 1
			return
		else if dropcount == 2
			+10 bruteloss
		else if dropcount == 3
			+20 bruteloss
		else if dropcount == 4
			+40 bruteloss
		else if dropcount == 5
			+65 bruteloss
		else if dropcount == 6
			+90 bruteloss
		else if dropcount == 7
			+120 bruteloss
		else if dropcount == 8
			+150 bruteloss
		else if dropcount == 9
			gibthefucker

