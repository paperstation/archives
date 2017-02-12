/datum/ovenrecipe
	var
		ingred1 = ""
		ingred2 = ""
		ingred3 = ""
		ingred4 = ""
		fullcookedtime = 10
		creates = "" // The item that is spawned when the recipe is made

/datum/ovenrecipe/jellydonut
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/doughball"
	ingred2 = "/obj/item/weapon/reagent_containers/food/snacks/flour"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/jellydonut"


/datum/ovenrecipe/donut
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/doughball"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/donut"

/datum/ovenrecipe/monkeyburger
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/breaddoughball"
	ingred2 = "/obj/item/weapon/reagent_containers/food/snacks/monkeymeat"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/monkeyburger"

/datum/ovenrecipe/humanburger
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/breaddoughball"
	ingred2 = "/obj/item/weapon/reagent_containers/food/snacks/humanmeat"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/humanburger"

/datum/ovenrecipe/brainburger
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/breaddoughball"
	ingred2 = "/obj/item/brain"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/brainburger"

/datum/ovenrecipe/roburger/
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/breaddoughball"
	ingred2 = "/obj/item/robot_parts/head"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/roburger"

/datum/ovenrecipe/waffles
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/breaddoughball"
	ingred2 = "/obj/item/weapon/reagent_containers/food/snacks/breaddoughball"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/waffles"

/datum/ovenrecipe/pie
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/doughball"
	ingred2 = "/obj/item/weapon/reagent_containers/food/snacks/flour"
	ingred3 = "/obj/item/weapon/reagent_containers/food/snacks/banana"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/pie"

/datum/ovenrecipe/donkpocket
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/flour"
	ingred2 = "/obj/item/weapon/reagent_containers/food/snacks/faggot"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/donkpocket"

/datum/ovenrecipe/donkpocket_warm
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/donkpocket"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/donkpocket"

/datum/ovenrecipe/xenoburger
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/breaddoughball"
	ingred2 = "/obj/item/weapon/reagent_containers/food/snacks/xenomeat"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/xenoburger"

/datum/ovenrecipe/meatbread
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/breaddoughball"
	ingred2 = "/obj/item/weapon/reagent_containers/food/snacks/monkeymeat"
	ingred3 = "/obj/item/weapon/reagent_containers/food/snacks/monkeymeat"
	ingred4 = "/obj/item/weapon/reagent_containers/food/snacks/cheesewheel"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/meatbread"

/datum/ovenrecipe/meatbreadhuman
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/breaddoughball"
	ingred2 = "/obj/item/weapon/reagent_containers/food/snacks/humanmeat"
	ingred3 = "/obj/item/weapon/reagent_containers/food/snacks/humanmeat"
	ingred4 = "/obj/item/weapon/reagent_containers/food/snacks/cheesewheel"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/meatbread"

/datum/ovenrecipe/xenomeatbread
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/breaddoughball"
	ingred2 = "/obj/item/weapon/reagent_containers/food/snacks/xenomeat"
	ingred3 = "/obj/item/weapon/reagent_containers/food/snacks/xenomeat"
	ingred4 = "/obj/item/weapon/reagent_containers/food/snacks/cheesewheel"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/xenomeatbread"

/datum/ovenrecipe/bananabread
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/breaddoughball"
	ingred2 = "/obj/item/weapon/reagent_containers/food/snacks/breaddoughball"
	ingred3 = "/obj/item/weapon/reagent_containers/food/drinks/milk"
	ingred4 = "/obj/item/weapon/reagent_containers/food/snacks/banana"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/bananabread"

/datum/ovenrecipe/omelette
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/egg"
	ingred2 = "/obj/item/weapon/reagent_containers/food/snacks/cheesewedge"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/omelette"

/datum/ovenrecipe/muffin
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/doughball"
	ingred2 = "/obj/item/weapon/reagent_containers/food/drinks/milk"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/muffin"

/datum/ovenrecipe/eggplantparm
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/grown/eggplant"
	ingred2 = "/obj/item/weapon/reagent_containers/food/snacks/cheesewedge"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/eggplantparm"

/datum/ovenrecipe/soylenviridians
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/breaddoughball"
	ingred2 = "/obj/item/weapon/reagent_containers/food/snacks/breaddoughball"
	ingred3 = "/obj/item/weapon/reagent_containers/food/snacks/grown/soybeans"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/soylenviridians"

/datum/ovenrecipe/soylentgreen
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/breaddoughball"
	ingred2 = "/obj/item/weapon/reagent_containers/food/snacks/breaddoughball"
	ingred3 = "/obj/item/weapon/reagent_containers/food/snacks/humanmeat"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/soylentgreen"

/datum/ovenrecipe/carrotcake
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/breaddoughball"
	ingred2 = "/obj/item/weapon/reagent_containers/food/snacks/breaddoughball"
	ingred3 = "/obj/item/weapon/reagent_containers/food/drinks/milk"
	ingred4 = "/obj/item/weapon/reagent_containers/food/snacks/grown/carrot"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/carrotcake"

/datum/ovenrecipe/cheesecake
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/breaddoughball"
	ingred2 = "/obj/item/weapon/reagent_containers/food/snacks/breaddoughball"
	ingred3 = "/obj/item/weapon/reagent_containers/food/drinks/milk"
	ingred4 = "/obj/item/weapon/reagent_containers/food/drinks/bottle/cream"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/cheesecake"

/datum/ovenrecipe/plaincake
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/breaddoughball"
	ingred2 = "/obj/item/weapon/reagent_containers/food/snacks/breaddoughball"
	ingred3 = "/obj/item/weapon/reagent_containers/food/drinks/milk"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/plaincake"

/datum/ovenrecipe/humeatpie
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/doughball"
	ingred2 = "/obj/item/weapon/reagent_containers/food/snacks/flour"
	ingred3 = "/obj/item/weapon/reagent_containers/food/snacks/humanmeat"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/humeatpie"

/datum/ovenrecipe/momeatpie
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/doughball"
	ingred2 = "/obj/item/weapon/reagent_containers/food/snacks/flour"
	ingred3 = "/obj/item/weapon/reagent_containers/food/snacks/monkeymeat"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/momeatpie"

/datum/ovenrecipe/xemeatpie
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/doughball"
	ingred2 = "/obj/item/weapon/reagent_containers/food/snacks/flour"
	ingred3 = "/obj/item/weapon/reagent_containers/food/snacks/xenomeat"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/xemeatpie"

/datum/ovenrecipe/wingfangchu
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/xenomeat"
	ingred2 = "/obj/item/weapon/reagent_containers/food/snacks/grown/soybeans"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/wingfangchu"

/datum/ovenrecipe/chaosdonut
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/doughball"
	ingred2 = "/obj/item/weapon/reagent_containers/food/snacks/grown/cannabisleaf"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/chaosdonut"

/datum/ovenrecipe/humankabob
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/humanmeat"
	ingred2 = "/obj/item/stack/rods"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/humankabob"

/datum/ovenrecipe/monkeykabob
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/monkeymeat"
	ingred2 = "/obj/item/stack/rods"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/monkeykabob"

/datum/ovenrecipe/tofubread
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/breaddoughball"
	ingred2 = "/obj/item/weapon/reagent_containers/food/snacks/tofu"
	ingred3 = "/obj/item/weapon/reagent_containers/food/snacks/tofu"
	ingred4 = "/obj/item/weapon/reagent_containers/food/snacks/cheesewheel"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/tofubread"

/datum/ovenrecipe/loadedbakedpotato
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/grown/potato"
	ingred2 = "/obj/item/weapon/reagent_containers/food/snacks/cheesewedge"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/loadedbakedpotato"

/datum/ovenrecipe/cheesyfries
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/fries"
	ingred2 = "/obj/item/weapon/reagent_containers/food/snacks/cheesewedge"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/cheesyfries"

/datum/ovenrecipe/clownburger
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/breaddoughball"
	ingred2 = "/obj/item/clothing/mask/gas/clown_hat"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/clownburger"

/datum/ovenrecipe/mimeburger
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/breaddoughball"
	ingred2 = "/obj/item/clothing/head/beret"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/mimeburger"

/datum/ovenrecipe/cubancarp
	ingred1 = "/obj/item/weapon/reagent_containers/food/snacks/flour"
	ingred2 = "/obj/item/weapon/reagent_containers/food/snacks/carpmeat"
	ingred3 = "/obj/item/weapon/reagent_containers/food/snacks/grown/chili"
	creates = "/obj/item/weapon/reagent_containers/food/snacks/cubancarp"



// *** After making the recipe above, add it in here! ***
// Special Note: When adding recipes to the list, make sure to list recipes with extra_item before similar recipes without
//					one. The reason being that sometimes the FOR loop that searchs through the recipes will just stop
//					at the wrong recipe. It's a hack job but it works until I clean up the code.
/obj/machinery/oven/New()
	..()
	src.available_ovenrecipes += new /datum/ovenrecipe/clownburger(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/mimeburger(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/cubancarp(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/humankabob(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/monkeykabob(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/jellydonut(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/donut(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/monkeyburger(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/humanburger(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/waffles(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/brainburger(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/roburger(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/donkpocket(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/donkpocket_warm(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/pie(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/xenoburger(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/meatbread(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/meatbreadhuman(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/omelette (src)
	src.available_ovenrecipes += new /datum/ovenrecipe/muffin (src)
	src.available_ovenrecipes += new /datum/ovenrecipe/eggplantparm(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/soylenviridians(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/soylentgreen(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/carrotcake(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/cheesecake(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/plaincake(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/humeatpie(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/momeatpie(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/xemeatpie(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/wingfangchu(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/chaosdonut(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/tofubread(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/loadedbakedpotato(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/cheesyfries(src)
	src.available_ovenrecipes += new /datum/ovenrecipe/xenomeatbread(src)
	src.reset()


/*******************
*   Item Adding
********************/

obj/machinery/oven/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if (istype(src, /obj/item/weapon/disk/nuclear))
		user << "\blue This is way too important to cook!"
	if (istype(src, /obj/item/weapon/grab/))// fuck off nernums goddamn grab cooker /DS
		user << "\blue You can't fit that person in the oven!" //sry DS but it works by putting in nulls still. I will eat as many grabs as I want. -Nernums
		return
	if (ingred1)
		if (ingred2)
			if (ingred3)
				if (ingred4)
					user << "\red The [src.name] already has the maximum capacity of ingredients!"
					return
				else
					src.ingred4 = "[O.type]"
			else
				src.ingred3 = "[O.type]"
		else
			src.ingred2 = "[O.type]"
	else
		src.ingred1 = "[O.type]"
	user.u_equip(O)
	O.loc = src
	if((user.client  && user.s_active != src))
		user.client.screen -= O
	O.dropped(user)
	for(var/mob/V in viewers(src, null))
		V.show_message(text("\blue [user] adds [O] to the oven."))
	if (ingred1 && !ingred2 && !ingred3 && !ingred4)
		ingred1disp = O.name
	if (ingred1 && ingred2 && !ingred3 && !ingred4)
		ingred2disp = O.name
	if (ingred1 && ingred2 && ingred3 && !ingred4)
		ingred3disp = O.name
	if (ingred1 && ingred2 && ingred3 && ingred4)
		ingred4disp = O.name


obj/machinery/oven/attack_paw(user as mob)
	return src.attack_hand(user)


/*******************
*   Oven Menu
********************/

/obj/machinery/oven/attack_hand(user as mob) // The oven Menu
	var/dat
	if(src.cooking)
		dat = {"
<TT>Currently cooking something!<BR>
Please wait...!</TT><BR>
<BR>
"}
	else
		dat = {"
<B>Ingredient 1: </B>[ingred1disp]<BR>
<B>Ingredient 2: </B>[ingred2disp]<BR>
<B>Ingredient 3: </B>[ingred3disp]<BR>
<B>Ingredient 4: </B>[ingred4disp]<BR>
<HR>
<BR>
<A href='?src=\ref[src];cook=1'>Turn on!<BR>
<A href='?src=\ref[src];dump=1'>Dispose contents!<BR>
"}

	user << browse("<HEAD><link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><TITLE>COOKULATOR 2050</TITLE></HEAD><TT>[dat]</TT>", "window=oven")
	onclose(user, "oven")
	return

/***********************************
*   Oven Menu Handling/Cooking
************************************/

/obj/machinery/oven/Topic(href, href_list)
	if(..())
		return

	usr.machine = src
	src.add_fingerprint(usr)

	if(href_list["cook"])
		var/cook_time = 200 // The time to wait before spawning the item
		var/cooked_item

		for(var/mob/V in viewers(src, null))
			V.show_message(text("\blue The oven begins cooking something!"))
		for(var/datum/ovenrecipe/R in src.available_ovenrecipes) //Look through the recipe list we made above
			if(src.ingred1 == R.ingred1 && src.ingred2 == R.ingred2 && src.ingred3 == R.ingred3 && src.ingred4 == R.ingred4) // Check if it's an accepted recipe
				src.reset() //Clear the ingredients out for the resulting food item
				if(!cooked_item)
					cooked_item = R.creates // Store the item that will be created

		if(!cooked_item) //Oops that wasn't a recipe dummy!!!
			if(!src.ingred1 || !src.ingred2 || !src.ingred3 || !src.ingred4) //Random ingredients used to create a failed dish
				src.cooking = 1 // Turn it on
				src.icon_state = "ovenstove_on"
				src.updateUsrDialog()
				src.reset() //Clear the failed ingredients out
				sleep(40) // Half way through
				playsound(src.loc, 'Welder.ogg', 50, 1) // Play a welder sound until I find a good sizzling sound
				cooked_item = /obj/item/weapon/reagent_containers/food/snacks/faileddish //Give the chef something to forcefeed people with even if he got the recipe wrong

			else //Otherwise it was empty, so just turn it on then off again with nothing happening
				src.cooking = 1
				src.icon_state = "ovenstove_on"
				src.updateUsrDialog()
				sleep(80)
				src.icon_state = "ovenstove"
//				playsound(src.loc, 'ding.ogg', 50, 1)
				src.cooking = 0

		var/cooking = cooked_item // Get the item that needs to be spawned
		cooked_item = null
		if(!isnull(cooking))
			src.cooking = 1 // Turn it on so it can't be used again while it's cooking
			src.icon_state = "ovenstove_on" //Make it look on too
			src.updateUsrDialog()
			src.being_cooked = new cooking(src)
			spawn(cook_time) //After the cooking time
				if(!isnull(src.being_cooked))
/*					if(istype(src.being_cooked, /obj/item/weapon/reagent_containers/food/snacks/humanburger))
						src.being_cooked.name = humanmeat_name + src.being_cooked.name
						src.being_cooked:job = humanmeat_job
					else if(istype(src.being_cooked, /obj/item/weapon/reagent_containers/food/snacks/humeatpie))
						src.being_cooked.name = humanmeat_name + src.being_cooked.name
						src.being_cooked:job = humanmeat_job
					else if(istype(src.being_cooked, /obj/item/weapon/reagent_containers/food/snacks/humankabob))
						src.being_cooked.name = humanmeat_name + src.being_cooked.name
						src.being_cooked:job = humanmeat_job*/
					if(istype(src.being_cooked, /obj/item/weapon/reagent_containers/food/snacks/donkpocket))
						src.being_cooked:warm = 1
						src.being_cooked.name = "warm " + src.being_cooked.name
						src.being_cooked:cooltime()
					src.being_cooked.loc = get_turf(src) // Create the new item
					src.being_cooked = null // We're done!
					playsound(src.loc, 'ding.ogg', 50, 1)
				src.cooking = 0 // Turn the oven back off
				src.icon_state = "ovenstove"
		else
			return

	if(href_list["dump"])
		src.reset()
		usr << "The oven disposes of its contents."

/obj/machinery/oven/proc/reset()
	src.ingred1 = ""
	src.ingred2 = ""
	src.ingred3 = ""
	src.ingred4 = ""
	src.ingred1disp = "Nothing"
	src.ingred2disp = "Nothing"
	src.ingred3disp = "Nothing"
	src.ingred4disp = "Nothing"
	return


