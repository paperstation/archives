/obj/structure/other/boundry
	name = "Boundry"
	desc = "Do not pass g- Actually just don't pass."
	anchored = 1
	density = 1
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "stand"


/obj/structure/other/door/ultra
	name = "ULTRA Boundry"
	desc = "Only the chosen one may enter!"
	anchored = 1
	density = 1
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "standgate"
	var/use = 0

	attackby(var/obj/item/O as obj, var/mob/living/carbon/human/user as mob)
		if(istype(O, /obj/item/weapon/card/VIP/ultra))
			use = 1
			density = 0
			icon = 'icons/obj/scooterstuff.dmi'
			icon_state = "standgated"
			src.visible_message("The boundry opens for [user.name]! They ROCK!")
			sleep(20)
			use = 0
			density = 1
			icon = 'icons/obj/scooterstuff.dmi'
			icon_state = "standgate"


/obj/item/weapon/card/VIP
	name = "VIP Card"
	desc = "VIP LOUNGE! GO GO GO!."
	icon_state = "data"
	item_state = "card-id"

/obj/item/weapon/card/VIP/ultra
	name = "ULTRA Card"
	desc = "......"


/obj/structure/other/blackbox //This is just a prop
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "blackbox"
	name = "Blackbox Recorder"





/obj/structure/other/door/special
	name = "Boundry"
	desc = "Do not pass g- Oh you have to get 300 coins into the little slot on the boundry."
	anchored = 1
	density = 1
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "standgate"
	var/boundry = 0
	var/amount = 300

	attackby(var/obj/item/O as obj, var/mob/living/carbon/human/user as mob)
		if(istype(O, /obj/item/weapon/storage/bag/coin))
			var/i
			for(var/obj/item/weapon/coin/plasma/G in contents)
				i++
				boundry++
				del(G)
			user << "You insert [i] coins into the device. There are [boundry] amount of coins of the required [amount]."
			if(boundry >= amount)
				world << "The Spook-E-Ville costume room opens up in the casino!"
				del(src)










/obj/structure/other/informer //baseobjct

/obj/structure/other/informer/AI //use a specified item on it, get a responce!
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "blackbox"
	name = "Informer"
	var/cooldown = 0

	attackby(var/obj/item/O as obj, var/mob/user as mob)
		if(istype(O, /obj/item/weapon/aiModule/asimov))
			user << "<b>Exhibit Guide</b> says,'This is an Asimov core module for your stations AI and is the basic one your starting AI starts with. Do not confuse this with Antimov."
		if(istype(O, /obj/item/weapon/aiModule/antimov))
			user << "<b>Exhibit Guide</b> says,'This is an Antimov core module for your stations AI. This will cause your station's AI to murder everyone. Becareful, make sure you check what you are uploading first!"
		if(istype(O, /obj/item/weapon/aiModule/reset))
			user << "<b>Exhibit Guide</b> says,'This is a Reset module for your stations AI. Any non-core laws will be removed once this is used on the AI!"
		if(istype(O, /obj/item/weapon/aiModule/purge))
			user << "<b>Exhibit Guide</b> says,'This is a Purge module for your stations AI. This removes all of your AI's laws, even the core ones!"
		else
			user << "<b>Exhibit Guide</b> says,'We do not have any data in our data banks involving this item!"



/obj/structure/other/ladder
	name = "ladder"
	desc = "A sturdy metal ladder."
	icon = 'icons/obj/structures.dmi'
	icon_state = "ladder11"

/proc/liveordie()
	for(var/mob/living/carbon/Z in world)
		new /obj/item/dummy/implant (Z)

/proc/liveordie2()
	for(var/mob/living/carbon/Z in world)
		for(var/obj/item/clothing/suit/D in Z)
			Z.drop_item(D)
			del(D)
		Z.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/trap(Z), slot_wear_suit)
		Z.regenerate_icons()
/proc/dieordie()
	for(var/mob/living/carbon/human/Z in world)
		for(var/obj/item/dummy/implant/D in Z)
			Z << "5"
			sleep(5)
			Z << "4"
			sleep(5)
			Z << "3"
			sleep(5)
			Z << "2"
			sleep(5)
			Z << "1"
			sleep(5)
			playsound(Z.loc, 'sound/weapons/gibgun.ogg', 50, 1)
			Z.visible_message("The implant inside of [Z.name] goes off.")
			Z.gib()

/proc/dieordie2()
	for(var/mob/living/carbon/human/Z in world)
		for(var/obj/item/clothing/suit/armor/trap/D in Z.wear_suit)
			Z << "5"
			sleep(5)
			Z << "4"
			sleep(5)
			Z << "3"
			sleep(5)
			Z << "2"
			sleep(5)
			Z << "1"
			sleep(5)
			playsound(Z.loc, 'sound/weapons/gibgun.ogg', 50, 1)
			Z.visible_message("The device on [Z.name] goes crushes his body to pieces.")
			Z.drop_item(D)
			D.can_remove = 1
			Z.gib()

/obj/item/dummy/implant
	name = "implant"


/obj/item/dummy/key
	name = "key"
	desc = "Looks like whoever made this was too lazy to make something new.."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "keys"



/obj/item/clothing/suit/armor/trap
	name = "device"
	desc = "AAHHHHHH!"
	icon_state = "samurai"
	item_state = "samurai"
	body_parts_covered = CHEST|LEGS|ARMS
	can_remove = 0

	attackby(obj/item/I as obj, mob/user as mob)
		if(can_remove == 0)
			if(istype(I, /obj/item/dummy/key))
				can_remove = 1
				user << "The device clicks off and can now be removed."
				user.drop_item(I)
				del(I)


/obj/structure/other/cat
	name = "SyndiCat"
	desc = "Meow?"
	icon = 'icons/mob/animal.dmi'
	icon_state = "syndicat"
	anchored = 0
	density = 1
	health = 50000
	var/start = 0

	attackby(mob/user as mob)
		if(istype(user, /mob/living/carbon/human))
			if(!start)
				new /obj/item/dummy/key (src.loc)
				start = 1










/proc/halloweennew()
//	world << sound('sound/ambience/midnight.ogg')
	world << "You feel a great evil in the distance! The dead walk again!"
	for(var/obj/effect/decal/remains/human/Z in world)
		new /mob/living/simple_animal/hostile/skel (Z.loc)
		del(Z)
	spawn(150)
		world << sound('sound/ambience/TheRideNeverEnds.ogg')