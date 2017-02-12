//todo: toothbrushes, and some sort of "toilet-filthinator" for the hos

/obj/structure/furnace
	name = "furnace"
	desc = "A warm welcome to the minature hell located inside this machine. Use a match to light it up"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "furnace"
	density = 1
	anchored = 1
	var/open = 0
	var/cistern = 1
	var/w_items = 0
	var/cremating = 0
	var/mob/living/swirlie = null
	var/locked = 0



/obj/structure/furnace/attackby(obj/item/I as obj, mob/living/user as mob)
	if(istype(I,/obj/item/weapon/match))
		w_items -= I.w_class
		w_items = 0
		cremate(user)
	if(I.w_class > 3)
		user << "<span class='notice'>\The [I] does not fit.</span>"
		return
	if(w_items + I.w_class > 5)
		user << "<span class='notice'>The furnace is full.</span>"
		return
	user.drop_item()
	I.loc = src
	w_items += I.w_class
	user << "You carefully place \the [I] into the furnace."
	return


/obj/structure/furnace/attack_hand(mob/living/user as mob)
	if(!contents.len)
		user << "<span class='notice'>The furnace is empty.</span>"
		return
	else
		var/obj/item/I = pick(contents)
		if(ishuman(user))
			user.put_in_hands(I)
		else
			I.loc = get_turf(src)
		user << "<span class='notice'>You pull \an [I] out of the furnace.</span>"
		w_items -= I.w_class
		return


/obj/structure/furnace/proc/cremate(atom/A, mob/user as mob)
	if(cremating)
		return //don't let you cremate something twice or w/e

	if(contents.len <= 0)
		for (var/mob/M in viewers(src))
			M.show_message("\red You hear a hollow crackle.", 1)
			return

	else
		if(!isemptylist(src.search_contents_for(/obj/item/weapon/disk/nuclear)))
			usr << "You get the feeling that you shouldn't cremate one of the items in the furnace."
			return

		for (var/mob/M in viewers(src))
			M.show_message("\red You hear a roar as the furnace activates.", 1)
			icon_state = "furnaceon"

		cremating = 1
		locked = 1

		for(var/mob/living/M in contents)
			if (M.stat!=2)
				M.emote("scream")
			M.attack_log += "\[[time_stamp()]\] Has been cremated by <b>[user]/[user.ckey]</b>" //No point in this when the mob's about to be deleted
			user.attack_log +="\[[time_stamp()]\] Cremated <b>[M]/[M.ckey]</b>"
			log_attack("\[[time_stamp()]\] <b>[user]/[user.ckey]</b> cremated <b>[M]/[M.ckey]</b>")
			M.death(1)
			M.ghostize()
			del(M)

		for(var/obj/O in contents) //obj instead of obj/item so that bodybags and ashes get destroyed. We dont want tons and tons of ash piling up
			del(O)

		new /obj/effect/decal/cleanable/ash(src.loc)
		spawn(30)
		cremating = 0
		icon_state = "furnaceopen"
		w_items = 0
		locked = 0
		playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
	return




/obj/structure/reagent_dispensers/boiler
	name = "Boiler"
	desc = "LODS E WATER"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "boiler"
	amount_per_transfer_from_this = 100
	anchored = 1
	density = 1
	var/id = 0
	New()
		..()
		reagents.add_reagent("water",10000)


/turf/simulated/floor/boilerfloor
	name = "Fill Station"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "fillspot"
	var/obj/structure/stool/bed/chair/janicart/cart = null
	var/delay = 0
	var/units = 2000
	var/id = 0

	Entered(var/obj/structure/stool/bed/chair/janicart)
		var/area/A = get_area(src.loc)
		var/list/L = A.get_contents()
		if(!A)return
		. = ..()
		if(istype(janicart))
			if(delay == 0)
				if(units >= 100)
					cart = janicart
					cart.reagents.add_reagent("water",50)
					cart.visible_message("\red The boiler connects with the Janicart; filling it up!")
					for(var/obj/structure/reagent_dispensers/boiler/T in L)
						if(src.id == T.id)
							T.reagents.remove_reagent("water",50)
							units -= 50
					delay = 1
					spawn(200)
						delay = 0
			else
				return


	Exited(atom)
		. = ..()
		if(atom == cart)
			cart = null
		return

/*


	Entered(var/obj/mecha/mecha)
		. = ..()
		if(istype(mecha))
			mecha.occupant_message("<b>Initializing power control devices.</b>")
			init_devices()
			if(recharge_console && recharge_port)
				janicart = mecha
				recharge_console.mecha_in(mecha)
				return
			else if(!recharge_console)
				mecha.occupant_message("<font color='red'>Control console not found. Terminating.</font>")
			else if(!recharge_port)
				mecha.occupant_message("<font color='red'>Power port not found. Terminating.</font>")
		return

	Exited(atom)
		. = ..()
		if(atom == janicart)
			janicart = null
		return



*/



/obj/item/weapon/storage/box/lunchbox
	name = "Janitors Lunchbox"
	icon = 'icons/obj/janitor.dmi'
	desc = "As for my profession; lets just say I'm the lunch whore."
	icon_state = "lunchbox"

	New()
		..()
		new /obj/item/weapon/reagent_containers/food/snacks/tofuburger(src)
		new /obj/item/weapon/reagent_containers/food/snacks/tofupie(src)
		new /obj/item/weapon/reagent_containers/food/drinks/soymilk(src)