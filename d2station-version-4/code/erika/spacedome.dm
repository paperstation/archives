global/var/timecontroller

/obj/helipad
	name = "shuttlepad"
	anchored = 1
	opacity = 0
	density = 0
	layer = 2
	icon = 'helipad-320px.dmi'
	icon_state = "helipad0"

/obj/item/timecontroller
	name = "Time Controller"
	desc = "Controls Time"
	icon = 'erika.dmi'
	icon_state = "weathercontroller"
	var/timehours = 12
	var/timeminutes = 0
	var/timestate = "PM"
	var/displaymzero = ""
	var/displayhzero = ""
	var/weather = ""
	var/snowcreated = 0
	anchored = 1

/obj/item/timecontroller/New()
	timecontroller = src
	//icon_state = "blank"
	process()

/obj/item/timecontroller/process()
	spawn(10)
		timeminutes += 30
		if(timeminutes >= 60)
			timehours++
			timeminutes = 0
		if((timehours == 11) && (timeminutes >= 59))
			if(timestate == "AM")
				timestate = "PM"
			else
				timestate = "AM"
		if(timehours > 12)
			timehours = 1
		if(timeminutes < 10)
			displaymzero = "0"
		else
			displaymzero = ""
		if(timehours < 10)
			displayhzero = "0"
		else
			displayhzero = ""
		if(prob(1) && prob(1) && prob(1))
			weather = "rainy"
		if(prob(1) && prob(1) && prob(1))
			weather = "foggy"
		if(prob(1) && prob(1) && prob(1))
			weather = ""
		//world << "Time: [displayhzero][timehours]:[displaymzero][timeminutes] [timestate]"
		process()

/obj/machinery/purchasebutton
	icon = 'erika.dmi'
	icon_state = "purchasebutton"
	name = "Purchase"
	var/itemname
	var/typeid
	var/price
	anchored = 1
	var/obj/giveitem = /obj/item/keycard

/obj/machinery/purchasebutton/New()
	price += text2num(src.getInflation())
	name = "Purchase [itemname] (Ð[price])"

/obj/machinery/purchasebutton/attack_hand(mob/user as mob)
	if(!type || !typeid || !price)
		user << "\red HEY THE DEVELOPERS FUCKED UP AGAIN"
		return
	if(!user.ckey)
		user << "\red get a real key shithead"
		return
	if(alert("Are you sure you wish to purchase this [type]? This will cost you Ð[price]!",,"Yes","No")=="Yes")
		if(src.doTransaction(user.ckey,"-[price]","[itemname]."))
			user << "\blue Purchase successful."
			var/I = new giveitem(src.loc)
			I:name = "Key ([itemname])"
			I:typeid = typeid
		else
			user << "\red Purchase failed (possibly insufficient funds or missing bank account)."



/obj/machinery/light/lamppole
	name = "lamp"
	desc = "turns on at night!"
	icon = 'lampposts.dmi'
	icon_state = "lamptop0"
	base_state = "lamptop"
	pixel_y = 45
	fitting = "bulb"
	light_type = /obj/item/weapon/light/bulb
	brightness = 5
/*
/obj/machinery/light/lamppole/New()
	if(timecontroller.timestate == "AM")
		on = 1
		update()
	else
		on = 0
		update()
	..()*/

/obj/lampbae
	name = "lamp pole"
	desc = "turns on at night!"
	anchored = 1.0
	density = 0
	icon = 'lampposts.dmi'
	icon_state = "lampbase"

/turf/simulated/floor/housing
	icon = 'natureicons.dmi'
	name = "floor"
	icon_state = "grass"
	temperature = T20C
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD

/turf/simulated/floor/spacedome
	icon = 'natureicons.dmi'
	name = "grass"
	icon_state = "grass"
	temperature = T20C
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD

/turf/simulated/floor/spacedome/attackby(obj/item/W as obj, mob/user as mob)
	return

/turf/simulated/floor/spacedome/grass/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/minihoe))
		new/obj/machinery/hydroponics(src)
		user << "\blue You prepare the soil for agricultural shenanigans."
	if(istype(W, /obj/item/weapon/shovel))
		src.icon_state = "dirt"
		user << "\blue You dig up the dirt."



/turf/simulated/floor/spacedome/grass
	icon = 'natureicons.dmi'
	name = "grass"
	icon_state = "grass"
	temperature = T20C
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD

/turf/simulated/floor/spacedome/sand
	icon = 'natureicons.dmi'
	name = "sand"
	icon_state = "sand"
	temperature = T20C
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD

/turf/simulated/floor/spacedome/water
	name = "water"
	icon = 'natureicons.dmi'
	icon_state = "water"
	temperature = T20C
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD

/turf/simulated/floor/spacedome/concrete
	name = "concrete"
	icon = 'natureicons.dmi'
	icon_state = "concreteroad"
	temperature = T20C
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD

/turf/simulated/floor/spacedome/grass/New()
	sleep(-1)
	if (locate(/turf/simulated/floor/spacedome/sand, oview(1, src)) && !locate(/obj/machinery, oview(1, src)) && !locate(/obj/window, oview(1, src)))
		if(prob(1))
			new/obj/beach/palm/side2(src)
		if(prob(1))
			new/obj/beach/palm(src)
	if (!locate(/turf/simulated/floor/spacedome/sand, oview(1, src)) && !locate(/turf/simulated/floor/spacedome/concrete, oview(1, src)) && !locate(/obj/nature, src) && !locate(/obj/machinery, oview(1, src)))
		if(prob(6))
			new/obj/nature/tree/tree1(src)
		if(prob(6))
			new/obj/nature/tree/tree2(src)
		if(prob(6))
			new/obj/nature/tree/tree3(src)
		if(prob(6))
			new/obj/nature/tree/tree5(src)
		if(prob(3))
			new/obj/nature/bush/bush1(src)
		if(prob(3))
			new/obj/nature/bush/bush2(src)
		if(prob(1))
			new/obj/nature/rocks(src)
		if(prob(1) && prob(1))
			new/obj/nature/plants(src)
		if(prob(1) && prob(1))
			new/obj/machinery/hydroponics(src)
		if(prob(1) && prob(1))
			new/obj/nature/stumps(src)
		if(prob(1) && prob(1) && prob(1))
			new/obj/item/weapon/grown/log(src)
		if(prob(1) && prob(1) && prob(1))
			new/obj/item/weapon/ore/iron(src)
		if(prob(1) && prob(1) && prob(1) && prob(1))
			new/obj/item/weapon/ore/silver(src)
		if(prob(1) && prob(1) && prob(1) && prob(1))
			new/obj/item/weapon/ore/gold(src)
		if(prob(1) && prob(1) && prob(1))
			new/obj/item/weapon/ore/slag(src)
	..()

/turf/simulated/floor/spacedome/concrete/New()
	sleep(-1)
	if(prob(1) && prob(1))
		new/obj/decal/cleanable/generic(src)
	if(prob(1))
		new/obj/decal/cleanable/dirt(src)
	if(prob(1) && prob(1))
		new/obj/item/weapon/cigbutt(src)
	if(prob(1) && prob(1) && prob(1))
		new/obj/decal/cleanable/oil/streak(src)
	..()

/turf/simulated/floor/spacedome/sand/New()
	sleep(-1)
	if(prob(1) && prob(1))
		new/obj/item/weapon/cigbutt(src)
	if(prob(1) && prob(1))
		new/obj/beach/coconut(src)
	if (locate(/turf/simulated/floor/spacedome/grass, oview(12, src)))
		if(prob(1))
			new/obj/beach/palm/side2(src)
		if(prob(1))
			new/obj/beach/palm(src)
	if(prob(1) && prob(1))
		new/obj/item/weapon/beach_ball(src)
	if(prob(2))
		new/obj/nature/rocks/beach(src)
	if(prob(1))
		new/obj/nature/stones(src)
	if(prob(1) && prob(1))
		new/obj/nature/plants/beach(src)
	if(prob(1) && prob(1) && prob(1))
		new/obj/item/weapon/ore/glass(src)
	if(prob(1) && prob(1) && prob(1))
		new/obj/item/weapon/ore/slag(src)
	..()

/turf/simulated/floor/spacedome/water/New()
	sleep(-1)
	new/obj/beach/water(src)
	if(prob(1) && prob(1) && prob(1))
		new/obj/nature/water(src)
	..()

/*
/obj/street
	name = "street"
	desc = "a street"
	icon = 'natureicons.dmi'
	icon_state = "concreteroad"
	density = 0
	anchored = 1

/obj/street/corner
	name = "sidewalk"
	icon_state = "sidewalk_corner"

/obj/street/sidewalk
	name = "sidewalk"
	icon_state = "sidewalkconcrete"

/obj/street/crossing
	name = "zebra crossing"
	icon_state = "zebracrossing"

/obj/street/stripes
	name = "stripes"
	icon_state = "roaddottedstripes"
*/


/obj/beach/ex_act()
	del(src)

/obj/nature/ex_act()
	del(src)

/obj/beach
	icon = 'beach.dmi'
	anchored = 1
	density = 1

/obj/beach/coconut
	name = "coconut"
	desc = "it's a coconut"
	icon = 'beach.dmi'
	icon_state = "coconuts"

/obj/beach/water
	name = "water"
	desc = "water"
	layer = 5
	icon = 'beach.dmi'
	icon_state = "water2"
	density = 0

/obj/beach/crab
	name = "crab"
	desc = "it's a crab"
	icon = 'beach.dmi'
	icon_state = "crab"

/obj/beach/palm
	name = "palm tree"
	desc = "it's a palm tree"
	icon = 'tree6.dmi'
	icon_state = ""
	layer = 5

/obj/beach/palm/side2
	name = "palm tree"
	desc = "it's a palm tree"
	icon = 'tree6.dmi'
	icon_state = "2"
	layer = 5

/obj/nature
	name = "nature"
	desc = "bluh"
	icon = 'erika.dmi'
	icon_state = ""
	density = 1
	anchored = 1

/obj/nature/tree
	name = "tree"
	desc = "it's a tree"
	icon = 'tree1.dmi'
	icon_state = ""
	layer = 5
	var/logamount = 0
	var/hitsleft = 0

/obj/nature/tree/New()
	..()
	logamount = rand(2,7)
	hitsleft = rand(2,7)

/obj/nature/tree/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/fireaxe) || istype(W, /obj/item/weapon/fireaxe/regular))
		user << "\blue You cut the [src.name]."
		playsound(src.loc, 'axe.ogg', 50, 1)
		spawn(10)
			hitsleft--
			if(hitsleft <= 0)
				if(logamount <= 0)
					del(src)
					user << "\blue You finish cutting the [src.name]."
				else
					hitsleft = rand(5,10)
			else
				logamount--
				if(prob(20))
					new/obj/item/weapon/grown/log(user.loc)

/obj/nature/tree/Del()
	..()
	if(prob(20))
		new/obj/item/weapon/grown/log(src.loc)

/obj/nature/rocks/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/pickaxe) || istype(W, /obj/item/weapon/tgpickaxe))
		user << "\blue You mine the [src.name]."
		playsound(src.loc, 'pickaxe.ogg', 50, 1)
		spawn(10)
			hitsleft--
			if(hitsleft <= 0)
				if(oreamount <= 0)
					del(src)
					user << "\blue You finish mining the [src.name]."
				else
					hitsleft = rand(5,10)
			else
				oreamount--
				if(prob(1))
					new/obj/item/weapon/ore/slag(user.loc)
				if(prob(1) && prob(1))
					new/obj/item/weapon/ore/silver(user.loc)
				if(prob(1) && prob(1))
					new/obj/item/weapon/ore/iron(user.loc)
				if(prob(1) && prob(1))
					new/obj/item/weapon/ore/plasma(user.loc)
				if(prob(1) && prob(1))
					new/obj/item/weapon/ore/diamond(user.loc)
				if(prob(1) && prob(1))
					new/obj/item/weapon/ore/gold(user.loc)
				if(prob(1) && prob(1))
					new/obj/item/weapon/ore/clown(user.loc)
				if(prob(1) && prob(1))
					new/obj/item/weapon/ore/adamantine(user.loc)
				if(prob(1) && prob(1))
					new/obj/item/weapon/ore/char(user.loc)
				if(prob(1) && prob(1))
					new/obj/item/weapon/ore/claretine(user.loc)
				if(prob(1) && prob(1))
					new/obj/item/weapon/ore/bohrum(user.loc)
				if(prob(1) && prob(1))
					new/obj/item/weapon/ore/syreline(user.loc)
				if(prob(1) && prob(1))
					new/obj/item/weapon/ore/erebite(user.loc)
				if(prob(1) && prob(1))
					new/obj/item/weapon/ore/Elerium(user.loc)
				if(prob(1) && prob(1))
					new/obj/item/weapon/ore/cytine(user.loc)
				if(prob(1) && prob(1))
					new/obj/item/weapon/ore/uqill(user.loc)
				if(prob(1) && prob(1))
					new/obj/item/weapon/ore/telecrystal(user.loc)
				if(prob(1) && prob(1))
					new/obj/item/weapon/ore/fabric(user.loc)
				if(prob(1) && prob(1))
					new/obj/item/weapon/ore/molitz(user.loc)
				if(prob(1) && prob(1))
					new/obj/item/weapon/ore/pharosium(user.loc)
				if(prob(1) && prob(1))
					new/obj/item/weapon/ore/cobryl(user.loc)
				if(prob(1) && prob(1) && prob(1))
					new/obj/item/weapon/ore/uranium(user.loc)
				if(prob(1) && prob(1) && prob(1))
					new/obj/item/weapon/ore/mauxite(user.loc)
				if(prob(1) && prob(1) && prob(1))
					new/obj/item/weapon/ore/telecrystal(user.loc)
				if(prob(1))
					new/obj/item/weapon/ore/rock(user.loc)
				if(prob(1))
					new/obj/item/weapon/ore/rock(user.loc)
				if(prob(1))
					new/obj/item/weapon/ore/rock(user.loc)
				if(prob(1))
					new/obj/item/weapon/ore/rock(user.loc)
				if(prob(1))
					new/obj/item/weapon/ore/rock(user.loc)

/obj/nature/rocks/Del()
	..()
	if(prob(1))
		new/obj/item/weapon/ore/slag(src.loc)
	if(prob(1) && prob(1))
		new/obj/item/weapon/ore/silver(src.loc)
	if(prob(1) && prob(1))
		new/obj/item/weapon/ore/iron(src.loc)
	if(prob(1) && prob(1))
		new/obj/item/weapon/ore/plasma(src.loc)
	if(prob(1) && prob(1))
		new/obj/item/weapon/ore/diamond(src.loc)
	if(prob(1) && prob(1))
		new/obj/item/weapon/ore/gold(src.loc)
	if(prob(1) && prob(1))
		new/obj/item/weapon/ore/clown(src.loc)
	if(prob(1) && prob(1))
		new/obj/item/weapon/ore/adamantine(src.loc)
	if(prob(1) && prob(1))
		new/obj/item/weapon/ore/char(src.loc)
	if(prob(1) && prob(1))
		new/obj/item/weapon/ore/claretine(src.loc)
	if(prob(1) && prob(1))
		new/obj/item/weapon/ore/bohrum(src.loc)
	if(prob(1) && prob(1))
		new/obj/item/weapon/ore/syreline(src.loc)
	if(prob(1) && prob(1))
		new/obj/item/weapon/ore/erebite(src.loc)
	if(prob(1) && prob(1))
		new/obj/item/weapon/ore/Elerium(src.loc)
	if(prob(1) && prob(1))
		new/obj/item/weapon/ore/cytine(src.loc)
	if(prob(1) && prob(1))
		new/obj/item/weapon/ore/uqill(src.loc)
	if(prob(1) && prob(1))
		new/obj/item/weapon/ore/telecrystal(src.loc)
	if(prob(1) && prob(1))
		new/obj/item/weapon/ore/fabric(src.loc)
	if(prob(1) && prob(1))
		new/obj/item/weapon/ore/molitz(src.loc)
	if(prob(1) && prob(1))
		new/obj/item/weapon/ore/pharosium(src.loc)
	if(prob(1) && prob(1))
		new/obj/item/weapon/ore/cobryl(src.loc)
	if(prob(1) && prob(1) && prob(1))
		new/obj/item/weapon/ore/uranium(src.loc)
	if(prob(1) && prob(1) && prob(1))
		new/obj/item/weapon/ore/mauxite(src.loc)
	if(prob(1) && prob(1) && prob(1))
		new/obj/item/weapon/ore/telecrystal(src.loc)
	if(prob(1))
		new/obj/item/weapon/ore/rock(src.loc)
	if(prob(1))
		new/obj/item/weapon/ore/rock(src.loc)
	if(prob(1))
		new/obj/item/weapon/ore/rock(src.loc)
	if(prob(1))
		new/obj/item/weapon/ore/rock(src.loc)
	if(prob(1))
		new/obj/item/weapon/ore/rock(src.loc)

/obj/nature/tree/tree1
	icon = 'tree1.dmi'

/obj/nature/tree/tree2
	icon = 'tree2.dmi'

/obj/nature/tree/tree3
	icon = 'tree3.dmi'

/obj/nature/tree/tree4
	icon = 'tree4.dmi'

/obj/nature/tree/tree5
	icon = 'tree5.dmi'

/obj/nature/bush/bush1
	name = "bush"
	desc = "it's a bush"
	icon = 'bush1.dmi'
	icon_state = ""
	layer = 5
	density = 0

/obj/nature/bush/bush2
	name = "bush"
	desc = "it's a bush"
	icon = 'bush2.dmi'
	icon_state = ""
	layer = 5
	density = 0

/obj/nature/rocks
	name = "rock"
	desc = "it's a rock"
	density = 1
	anchored = 0
	icon_state = "rock2"
	var/oreamount
	var/hitsleft

/obj/nature/rocks/asteroid
	name = "space rock"
	desc = "it's a space rock"
	icon_state = "asteroid1"
	anchored = 1
	density = 1
	opacity = 1

/obj/nature/rocks/asteroid/New()
	..()
	oreamount = rand(5,10)
	hitsleft = rand(8,15)
	icon_state = pick("asteroid1", "asteroid2", "asteroid3")

/obj/nature/rocks/New()
	..()
	oreamount = rand(2,4)
	hitsleft = rand(8,15)
	icon_state = pick("rock2", "rock3")

/obj/nature/rocks/beach
	name = "rock"
	desc = "it's a rock"
	density = 1
	anchored = 1

/obj/nature/stones
	name = "stones"
	desc = "they're stones"
	var/amountofstones = 3
	anchored = 1
	density = 0

/obj/nature/plants
	name = "plant"
	desc = "a plant"
	density = 0


/obj/nature/plants/beach
	name = "plant"
	desc = "a plant"
	density = 0

/obj/nature/logs
	name = "logs"
	desc = "tree logs"
	density = 0

/obj/nature/water
	name = "plant"
	desc = "a plant"
	density = 0

/obj/nature/stumps
	name = "tree stump"
	desc = "a tree stump"
	density = 0

/obj/nature/rocks/beach/New()
	icon_state = pick("beachrock1", "beachrock2", "rocks2")

/obj/nature/stones/New()
	icon_state = pick("rocks1", "rocks3")

/obj/nature/plants/New()
	icon_state = pick("grassbush", "green1", "green2", "green3", "green6", "green7", "wood1", "wood2")

/obj/nature/logs/New()
	icon_state = pick("grassbush", "green1", "green2", "green3", "green6", "green7", "wood1", "wood2")

/obj/nature/plants/beach/New()
	icon_state = pick("beachgreen1", "beachgreen2", "beachgreen3", "beachgreen4", "beachgreen5")

/obj/nature/water/New()
	icon_state = pick("waterstuff1", "waterstuff2")

/obj/nature/stumps/New()
	icon_state = pick("wood1", "wood2")


/obj/item/timecontroller/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature <= 273)
		if((timecontroller.weather == "rainy"))
			timecontroller.weather = "snowy"
			for(var/turf/simulated/floor/spacedome/concrete/C in oview(7))
				if(prob(3))
					new/obj/decal/cleanable/snow(src.loc)


	else
		if((timecontroller.weather == "snowy"))
			timecontroller.weather = "rainy"
			timecontroller.snowcreated = 0
	..()

/area/outerarea
	name = "central island"
	icon_state = "null"
	var/timelum = 0

/area/outerarea/New()
	updatetime()
	..()

/area/outerarea/proc/updatetime()
	if(timecontroller.timestate == "AM")
		if(timecontroller.timehours <= 5)
			timelum = 0
			ul_Light(timelum, timelum, timelum)
		else
			timelum = timecontroller.timehours - 2
			ul_Light(timelum, timelum, timelum)
	else
		if(timecontroller.timehours >= 6)
			timelum = timecontroller.timehours - 3
			ul_Light(timelum, timelum, timelum)
		else
			timelum = timecontroller.timehours + 12
			ul_Light(timelum, timelum, timelum)
	if((timecontroller.weather == "rainy") && (icon_state != "rain"))
		icon = 'erika.dmi'
		icon_state = "rain"
		//world << "getting rainy"
	else if((timecontroller.weather == "snowy") && (icon_state != "snow"))
		icon = 'erika.dmi'
		//icon_state = "snow"
	else if((timecontroller.weather == "foggy") && (icon_state != "fog"))
		icon = 'erika.dmi'
		icon_state = "fog"
		//world << "getting foggy"
	else if(((icon_state == "rain") && (timecontroller.weather != "rainy")) || ((icon_state == "snow") && (timecontroller.weather != "snowy")) || ((icon_state == "fog") && (timecontroller.weather != "foggy")))
		icon = 'erika.dmi'
		icon_state = "blank"
		//world << "clearing weather"
	spawn(300)
		updatetime()

/area/outerarea/s5
	name = "industrial island"
	icon_state = "engine"

/area/outerarea/s1
	name = "north coast"
	icon_state = "cell1"

/area/outerarea/s2
	name = "east coast"
	icon_state = "storage"

/area/outerarea/s3
	name = "south coast"
	icon_state = "auxstorage"

/area/outerarea/s4
	name = "west coast"
	icon_state = "yellow"

/area/outerarea/s6
	name = "runaway"
	icon_state = "Warden"

/area/outerarea/water
	name = "Water"
	icon_state = "green"

/area/outerarea/street
	name = "Street"
	icon_state = "DJ"
