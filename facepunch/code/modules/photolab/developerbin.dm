/obj/item/weapon/reagent_containers/glass/canister
	name = "Canister"
	desc = "Canister"
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "canister"

/obj/item/weapon/reagent_containers/glass/devbin
	name = "Chemical Bin"
	desc = "Develop photos in these"
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "dev"
	m_amt = 200
	g_amt = 0
	w_class = 3.0
	anchored = 1
	density = 1
	var/bintype = 0
	var/progtype = 0
	volume = 200
	var/chemicals = 0
	var/ison = 0
	flags = FPRINT | OPENCONTAINER
	var/obj/item/weapon/photo/photos

	attack_hand()
		return



	attackby(obj/item/W, mob/user)
		if(istype(W, /obj/item/weapon/photo/))
			var/obj/item/weapon/photo/D = W
			if(D.progtype == progtype)
				if(!chemicals)
					user << "You should put chemicals in first!"
				if(D.status == 2)
					user << "You see no point in putting a ruined photo into the [src]!"
					return
				if(photos)
					user << "\red There are photos already inside of the bin!"
				else
					user << "\red You insert the photos."
					user.drop_item(W)
					W.loc = src.contents
					photos = W
					turnon()
			else
				user << "You should not do this step yet"
		if (istype(W, /obj/item/weapon/reagent_containers/glass/canister))
			if(chemicals)
				user << "\red There is already a chemical canister attached."
			else
				user << "\red You insert the [W.name]."
				user.drop_item(W)
				for(var/datum/reagent/R in W.reagents.reagent_list)
					if(R.id=="developer")
						progtype = 1
					if(R.id=="stopbath")
						progtype = 2
					if(R.id=="fixer")
						progtype = 3
				chemicals += 10
				icon_state = "dev1"
				del(W)


/obj/item/weapon/reagent_containers/glass/devbin/proc/turnon(mob/user)
	if(ison)return
	if(photos && chemicals)
		ison = 1
		icon_state = pick("devw1","devw2","devw3")
		spawn(300)
			ison = 0
			photos.loc = src.loc
			photos.status = 1
			photos.progtype++
			photos = null
			chemicals--
			if(chemicals <= 1)
				icon_state = "dev"
			icon_state = "dev1"



/obj/machinery/photo/debug
	name = "Insta-photo"
	desc = "Develop photos in these"
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "dev"
	anchored = 1
	density = 1
	var/obj/item/weapon/photo/photos

	attack_hand()
		return


	attackby(obj/item/W, mob/user)
		if (istype(W, /obj/item/weapon/negative/))
			var/obj/item/weapon/negative/D = W
			if(D.img)
				var/obj/item/weapon/photo/P = new/obj/item/weapon/photo()
				P.loc = user.loc
				if(!user.get_inactive_hand())
					user.put_in_inactive_hand(P)
				var/icon/small_img = icon(D.img)
				var/icon/ic = icon('icons/obj/items.dmi',"photo")
				small_img.Scale(8, 8)
				ic.Blend(small_img,ICON_OVERLAY, 10, 13)
				P.icon = ic
				P.img = D.img
			//	P.desc = mobs
				P.pixel_x = rand(-10, 10)
				P.pixel_y = rand(-10, 10)
				playsound(loc, pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 75, 1, -3)


/obj/machinery/photo/developer
	name = "Film Developer"
	desc = "Develop photos in these"
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "filmer"
	anchored = 1
	density = 1
	var/obj/item/weapon/negative/negatives
	var/on = 0

	attack_hand()
		return


	attackby(obj/item/W, mob/user)
		if (istype(W, /obj/item/weapon/negative/) && !negatives)
			user.drop_item(W)
			W.loc = src
			negatives = W
			user << "\blue You insert the film canister into the developer."

	attack_hand(mob/user)
		..()
		if(!on)
			if(!negatives)
				user << "\red You go to turn the machine on but realize you didn't insert anything into it."
				return
			else
				user << "\blue You turn the machine on."
				develop()
		if(on)
			user << "\red The machine is currently developing the film"
			return

/obj/machinery/photo/developer/proc/develop()
	var/devtime = rand(200,250)
	on = 1
	icon_state = "filmeron"
	sleep(devtime)
	src.visible_message("\blue The machine turns off.")
	negatives.status = 2
	negatives.ruined = 1
	negatives.loc = src.loc
	negatives.desc = "Negatives developed at [worldtime2text()]"
	negatives = null
	playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
	icon_state = "filmer"
	on = 0


/obj/machinery/photo/enlarger
	name = "Photo Enlarger"
	desc = "Develop photos in these"
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "incubator"
	anchored = 1
	density = 1
	var/obj/item/weapon/negative/negatives
	var/on = 0

	attack_hand()
		return


	attackby(obj/item/W, mob/user)
		if (istype(W, /obj/item/weapon/negative/) && !negatives)
			var/obj/item/weapon/negative/D = W
			if(D.status == 2)
				user.drop_item(D)
				D.loc = src
				negatives = D
				user << "\blue You insert the negatives"

	attack_hand(mob/user)
		..()
		if(!on)
			if(!negatives)
				user << "\red You go to turn the machine on but realize you didn't insert anything into it."
				return
			else
				user << "\blue You turn the machine on."
				develop()
		if(on)
			user << "\red The machine is currently exposing the paper"
			return

/obj/machinery/photo/enlarger/proc/develop()
	icon_state = "incubator_on"
	var/devtime = rand(200,250)
	on = 1
	sleep(devtime)
	src.visible_message("\blue The machine turns off.")
	negatives.loc = src.loc
	if(negatives.img)
		var/obj/item/weapon/photo/P = new/obj/item/weapon/photo()
		var/icon/small_img = icon(negatives.img)
		var/icon/ic = icon('icons/obj/items.dmi',"photo")
		small_img.Scale(8, 8)
		ic.Blend(small_img,ICON_OVERLAY, 10, 13)
		P.icon = ic
		P.img = negatives.img
		P.loc = src.loc
		P.ruined = 1
				//	P.desc = mobs
		P.pixel_x = rand(-10, 10)
		P.pixel_y = rand(-10, 10)
		P.progtype = 1
	if(negatives.img2)
		var/obj/item/weapon/photo/P = new/obj/item/weapon/photo()
		var/icon/small_img = icon(negatives.img2)
		var/icon/ic = icon('icons/obj/items.dmi',"photo")
		small_img.Scale(8, 8)
		ic.Blend(small_img,ICON_OVERLAY, 10, 13)
		P.icon = ic
		P.img = negatives.img2
		P.loc = src.loc
		P.ruined = 1
				//	P.desc = mobs
		P.pixel_x = rand(-10, 10)
		P.pixel_y = rand(-10, 10)
		P.progtype = 1
	if(negatives.img3)
		var/obj/item/weapon/photo/P = new/obj/item/weapon/photo()
		var/icon/small_img = icon(negatives.img3)
		var/icon/ic = icon('icons/obj/items.dmi',"photo")
		small_img.Scale(8, 8)
		ic.Blend(small_img,ICON_OVERLAY, 10, 13)
		P.icon = ic
		P.img = negatives.img3
		P.loc = src.loc
		P.ruined = 1
				//	P.desc = mobs
		P.pixel_x = rand(-10, 10)
		P.pixel_y = rand(-10, 10)
		P.progtype = 1
	playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
	icon_state = "incubator"
	negatives = null
	on = 0