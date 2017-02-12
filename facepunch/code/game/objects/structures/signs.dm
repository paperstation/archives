/obj/structure/sign
	icon = 'icons/obj/decals.dmi'
	anchored = 1
	opacity = 0
	density = 0
	layer = 3.5

/obj/structure/sign/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			del(src)
			return
		if(3.0)
			del(src)
			return
		else
	return


/obj/structure/sign/blob_act()
	del(src)
	return


/obj/structure/sign/map
	name = "station map"
	desc = "A framed picture of the station."

/obj/structure/sign/map/left
	icon_state = "map-left"

/obj/structure/sign/map/right
	icon_state = "map-right"

/obj/structure/sign/securearea
	name = "\improper SECURE AREA"
	desc = "A warning sign which reads 'SECURE AREA'."
	icon_state = "securearea"

/obj/structure/sign/biohazard
	name = "\improper BIOHAZARD"
	desc = "A warning sign which reads 'BIOHAZARD'"
	icon_state = "bio"

/obj/structure/sign/electricshock
	name = "\improper HIGH VOLTAGE"
	desc = "A warning sign which reads 'HIGH VOLTAGE'"
	icon_state = "shock"

/obj/structure/sign/examroom
	name = "\improper EXAM"
	desc = "A guidance sign which reads 'EXAM ROOM'"
	icon_state = "examroom"

/obj/structure/sign/vacuum
	name = "\improper HARD VACUUM AHEAD"
	desc = "A warning sign which reads 'HARD VACUUM AHEAD'"
	icon_state = "space"

/obj/structure/sign/deathsposal
	name = "\improper DISPOSAL LEADS TO SPACE"
	desc = "A warning sign which reads 'DISPOSAL LEADS TO SPACE'"
	icon_state = "deathsposal"

/obj/structure/sign/pods
	name = "\improper ESCAPE PODS"
	desc = "A warning sign which reads 'ESCAPE PODS'"
	icon_state = "pods"

/obj/structure/sign/fire
	name = "\improper DANGER: FIRE"
	desc = "A warning sign which reads 'DANGER: FIRE'"
	icon_state = "fire"


/obj/structure/sign/nosmoking_1
	name = "\improper NO SMOKING"
	desc = "A warning sign which reads 'NO SMOKING'"
	icon_state = "nosmoking"

/obj/structure/sign/stpatrick
	name = "\improper St. Patricks Day"
	desc = "Why are you not yet drunk?"
	icon_state = "clover"


/obj/structure/sign/nosmoking_2
	name = "\improper NO SMOKING"
	desc = "A warning sign which reads 'NO SMOKING'"
	icon_state = "nosmoking2"

/obj/structure/sign/redcross
	name = "medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here.'"
	icon_state = "redcross"

/obj/structure/sign/greencross
	name = "medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here.'"
	icon_state = "greencross"

/obj/structure/sign/goldenplaque
	name = "The Most Robust Men Award for Robustness"
	desc = "To be Robust is not an action or a way of life, but a mental state. Only those with the force of Will strong enough to act during a crisis, saving friend from foe, are truly Robust. Stay Robust my friends."
	icon_state = "goldenplaque"

/obj/structure/sign/kiddieplaque
	name = "AI developers plaque"
	desc = "Next to the extremely long list of names and job titles, there is a drawing of a little child. The child appears to be retarded. Beneath the image, someone has scratched the word \"PACKETS\""
	icon_state = "kiddieplaque"

/obj/structure/sign/atmosplaque
	name = "\improper FEA Atmospherics Division plaque"
	desc = "This plaque commemorates the fall of the Atmos FEA division. For all the charred, dizzy, and brittle men who have died in its hands."
	icon_state = "atmosplaque"

/obj/structure/sign/maltesefalcon	//The sign is 64x32, so it needs two tiles. ;3
	name = "The Maltese Falcon"
	desc = "The Maltese Falcon, Space Bar and Grill."

/obj/structure/sign/maltesefalcon/left
	icon_state = "maltesefalcon-left"

/obj/structure/sign/maltesefalcon/right
	icon_state = "maltesefalcon-right"


/obj/structure/sign/maltesefalconnew/left
	icon_state = "classyfalcon-left"

/obj/structure/sign/maltesefalconnew/right
	icon_state = "classyfalcon-right"


/obj/structure/sign/science			//These 3 have multiple types, just var-edit the icon_state to whatever one you want on the map
	name = "\improper SCIENCE!"
	desc = "A warning sign which reads 'SCIENCE!'"
	icon_state = "science1"

/obj/structure/sign/chemistry
	name = "\improper CHEMISTRY"
	desc = "A warning sign which reads 'CHEMISTRY'"
	icon_state = "chemistry1"

/obj/structure/sign/botany
	name = "\improper HYDROPONICS"
	desc = "A warning sign which reads 'HYDROPONICS'"
	icon_state = "hydro1"

/obj/structure/sign/casino
	name = "Casino Night"
	desc = "Come on in and have a drink!."
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "casino"
	pixel_y = 30



/obj/structure/sign/plaque/custom
	name = "Plaque"
	desc = "It doesn't have anything written on it."
	icon_state = "goldenplaque"
	var/edited = 0

/obj/structure/sign/plaque/custom/attackby( obj/item/I as obj, mob/user as mob)
	if( istype(I, /obj/item/weapon/pen/))
		if(!anchored)
			user << "You need to wrench it down first to edit it!"
			return
		if(edited)
			user << "It was already engraved!"
			return
		var/T = input("Enter what you want name the plaque:", "Write", null, null) as text
		if(!T)
			return
		var/D =	input("Enter what you want the plaque to describe:", "Write", null, null) as text
		if(!D)
			return
		name = T
		desc = D
		edited = 1
		update_icon()
		return
	..()

	if (istype(I, /obj/item/weapon/wrench))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user,50))
			if(!anchored)
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
				anchored = 1
				user << "\blue You bolt down the plaque."
				return
			if(anchored)
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
				anchored = 0
				user << "\blue You unbolt the plaque."
				return

/obj/structure/sign/sec			//These 3 have multiple types, just var-edit the icon_state to whatever one you want on the map
	name = "\improper SECURITY!"
	desc = "A warning sign which reads 'SECURITY!'"
	icon_state = "sec"