/obj/item/clothing
	name = "clothing"

	var/flags_inv //This flag is used to determine when items in someone's inventory cover others. IE helmets making it so you can't see glasses, etc.

	var/slowdown = 0 // How much clothing is slowing you down. Negative values speeds you up
	var/variant = null


//***********************Ears***********************: currently only used for headsets and earmuffs
/obj/item/clothing/ears
	name = "ears"
	w_class = 1.0
	slot_flags = SLOT_EARS


/obj/item/clothing/ears/earmuffs
	name = "earmuffs"
	desc = "Protects your hearing from loud noises, and quiet ones as well."
	icon_state = "earmuffs"
	item_state = "earmuffs"


//***********************Glasses***********************
/obj/item/clothing/glasses
	name = "glasses"
	icon = 'icons/obj/clothing/glasses.dmi'
	w_class = 2.0
	flags = GLASSESCOVERSEYES
	slot_flags = SLOT_EYES
	var/vision_flags = 0
	var/darkness_view = 0//Base human is 2
	var/invisa_view = 0

/*
SEE_SELF  // can see self, no matter what
SEE_MOBS  // can see all mobs, no matter what
SEE_OBJS  // can see all objs, no matter what
SEE_TURFS // can see all turfs (and areas), no matter what
SEE_PIXELS// if an object is located on an unlit area, but some of its pixels are
          // in a lit area (via pixel_x,y or smooth movement), can see those pixels
BLIND     // can't see anything
*/


//***********************Gloves***********************
/obj/item/clothing/gloves
	name = "gloves"
	gender = PLURAL
	w_class = 2.0
	icon = 'icons/obj/clothing/gloves.dmi'
	var/siemens_coefficient = 0.50//for electrical admittance/conductance (electrocution checks and shit)
	var/wired = 0
	var/obj/item/weapon/cell/cell = 0
	slot_flags = SLOT_GLOVES
	attack_verb = list("challenged")


	emp_act(severity)
		if(cell)
			cell.emp_act(severity)
		..()
		return


//***********************Mask***********************
/obj/item/clothing/mask
	name = "mask"
	icon = 'icons/obj/clothing/masks.dmi'
	slot_flags = SLOT_MASK


//***********************Shoes***********************
/obj/item/clothing/shoes
	name = "shoes"
	icon = 'icons/obj/clothing/shoes.dmi'
	desc = "Comfortable-looking shoes."
	gender = PLURAL
	var/chained = 0

	slot_flags = SLOT_FEET
	slowdown = SHOES_SLOWDOWN


//***********************Head***********************
/obj/item/clothing/head
	name = "head"
	icon = 'icons/obj/clothing/hats.dmi'
	slot_flags = SLOT_HEAD
	var/armor = list(impact = 0, slash = 0, pierce = 0, bomb = 0, bio = 0, rad = 0)

	var/body_parts_covered = HEAD 			//see setup.dm for appropriate bit flags
	var/max_temperature = 0 			//After this point heat will pass right through
	var/max_pressure = 0				//After this point pressre will ignore resistance
	var/min_pressure = 600				//After this point pressre will ignore resistance, human max is 550 so capping at 600 wont change anything

	examine()
		..()
		var/info = "\blue It appears to cover: "
		if(!body_parts_covered)//Display what it covers
			info += "|Nothing|"
		if(body_parts_covered & HEAD)
			info += "|Head|"
		if(body_parts_covered & ARMS)
			info += "|Arms|"
		if(body_parts_covered & CHEST)
			info += "|Chest|"
		if(body_parts_covered & LEGS)
			info += "|Legs|"
		//Might want to display temp/pressure values here
		//Next display armor values
		for(var/armortype in list(IMPACT, SLASH, PIERCE, BOMB, BIO, IRRADIATE))
			var/value = armor[armortype]
			if(!value)//If we dont have any protection then dont display it
				continue
			var/armordesc = "negligible"
			switch(value)
				if(0.0 to 0.35)
					armordesc = "low"
				if(0.36 to 0.6)
					armordesc = "medium"
				if(0.61 to 0.99)
					armordesc = "high"
				else
					armordesc = "extreme"
			usr << "\blue It has \a [armordesc] resistance to [armortype] damage."
		return 1


//***********************Suit***********************
/obj/item/clothing/suit
	icon = 'icons/obj/clothing/suits.dmi'
	name = "suit"
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL
	slot_flags = SLOT_OCLOTHING
	var/blood_overlay_type = "suit"
	var/allowed = list(/obj/item/weapon/tank/emergency_oxygen)//Suit storage
	var/armor = list(impact = 0, slash = 0, pierce = 0, bomb = 0, bio = 0, rad = 0)
	var/body_parts_covered = CHEST
	var/max_temperature = 0 			//After this point heat will pass right through, should this have a lower bound?
	var/max_pressure = 0				//After this point pressre will ignore resistance
	var/min_pressure = 600				//After this point pressre will ignore resistance, human max is 550 so capping at 600 wont change anything

	proc/suit_function(var/atom/target)//Called when the user ctrl+shift+clicks on something, might get renamed
		return 1

	examine()
		..()
		var/info = "\blue It appears to cover: "
		if(!body_parts_covered)//Display what it covers
			info += "|Nothing|"
		if(body_parts_covered & HEAD)
			info += "|Head|"
		if(body_parts_covered & ARMS)
			info += "|Arms|"
		if(body_parts_covered & CHEST)
			info += "|Chest|"
		if(body_parts_covered & LEGS)
			info += "|Legs|"
		//Might want to display temp/pressure values here
		//Next display armor values
		for(var/armortype in list(IMPACT, SLASH, PIERCE, BOMB, BIO, IRRADIATE))
			var/value = armor[armortype]
			if(!value)//If we dont have any protection then dont display it
				continue
			var/armordesc = "negligible"
			switch(value)
				if(0.0 to 0.35)
					armordesc = "low"
				if(0.36 to 0.6)
					armordesc = "medium"
				if(0.61 to 0.99)
					armordesc = "high"
				else
					armordesc = "extreme"
			usr << "\blue It has \a [armordesc] resistance to [armortype] damage."
		return 1



//***********************Uniforms***********************
/obj/item/clothing/under
	icon = 'icons/obj/clothing/uniforms.dmi'
	name = "under"
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_ICLOTHING
	var/has_sensor = 1//For the crew computer 2 = unable to change mode
	var/sensor_mode = 0
		/*
		1 = Report living/dead
		2 = Report detailed damages
		3 = Report location
		*/
	var/obj/item/clothing/tie/hastie = null

	attackby(obj/item/I, mob/user)
		if(!hastie && istype(I, /obj/item/clothing/tie))
			user.drop_item()
			hastie = I
			I.loc = src
			user << "<span class='notice'>You attach [I] to [src].</span>"
			if(istype(loc, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = loc
				H.update_inv_w_uniform()
			return
		..()
		return


	examine()
		..()
		switch(src.sensor_mode)
			if(0)
				usr << "Its sensors appear to be disabled."
			if(1)
				usr << "Its binary life sensors appear to be enabled."
			if(2)
				usr << "Its vital tracker appears to be enabled."
			if(3)
				usr << "Its vital tracker and tracking beacon appear to be enabled."
		if(hastie)
			usr << "\A [hastie] is clipped to it."
		return


	verb/toggle()
		set name = "Toggle Suit Sensors"
		set category = "Object"
		set src in usr
		var/mob/M = usr
		if(istype(M, /mob/dead/)) return
		if(usr.stat) return
		if(src.has_sensor >= 2)
			usr << "The controls are locked."
			return 0
		if(src.has_sensor <= 0)
			usr << "This suit does not have any sensors."
			return 0
		src.sensor_mode += 1
		if(src.sensor_mode > 3)
			src.sensor_mode = 0
		switch(src.sensor_mode)
			if(0)
				usr << "You disable your suit's remote sensing equipment."
			if(1)
				usr << "Your suit will now report whether you are live or dead."
			if(2)
				usr << "Your suit will now report your vital lifesigns."
			if(3)
				usr << "Your suit will now report your vital lifesigns as well as your coordinate position."
				usr.unlock_achievement("Safety First")
		..()
		return


	verb/removetie()
		set name = "Remove Accessory"
		set category = "Object"
		set src in usr
		if(!istype(usr, /mob/living)) return
		if(usr.stat) return

		if(hastie)
			usr.put_in_hands(hastie)
			hastie = null

			if(istype(loc, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = loc
				H.update_inv_w_uniform()


/obj/item/clothing/under/rank/New()//Random sensor levels
	sensor_mode = pick(0,1,2,3)
	..()





/obj/item/clothing/back/weld
	name = "welderpack"
	desc = "You wear this on your back and put items into it."
	icon = 'icons/obj/storage.dmi'
	icon_state = "welderpack"
	item_state = "welderpack"
	var/max_fuel = 100
	w_class = 4.0
	flags = FPRINT|TABLEPASS
	slot_flags = SLOT_BACK
	New()
		var/datum/reagents/R = new/datum/reagents(100)
		reagents = R
		R.my_atom = src
		reagents.add_reagent("fuel",100)


	afterattack(obj/O as obj, mob/user as mob)
		if(istype(O, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,O) <= 1)
			O.reagents.trans_to(src, max_fuel)
			user << "\blue Welderpack refueled"
			playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
			return


	ex_act()
		explosion(src.loc,-1,0,2)
		if(src)
			del(src)


	bullet_act(var/obj/item/projectile/Proj)
		if(Proj.damtype == BRUTE || Proj.damtype == BURN)
			explosion(src.loc,-1,0,2)
			if(src)
				del(src)



