
/obj/item/paint // this seems to be a completely different paint can than the standard one, uhh. w/e it gets to live in here too
	name = "paint can"
	icon = 'icons/misc/old_or_unused.dmi'
	icon_state = "paint_neutral"
	var/paintcolor = "neutral"
	item_state = "paintcan"
	w_class = 3.0
	desc = "A can of impossible to remove paint."

/obj/item/paint/attack_self(mob/user as mob)

	var/t1 = input(user, "Please select a color:", "Locking Computer", null) in list( "red", "blue", "green", "yellow", "black", "white", "neutral" )
	if ((user.equipped() != src || user.stat || user.restrained()))
		return
	src.paintcolor = t1
	src.icon_state = text("paint_[]", t1)
	add_fingerprint(user)
	return

/obj/machinery/vending/paint
	name = "paint dispenser"
	desc = "Dispenses paint. Derp."
	icon = 'icons/obj/vending.dmi'
	icon_state = "paint-vend"
	var/paint_color = "#ff0000"

	emag_act(var/mob/user, var/obj/item/card/emag/E)
		if(user)
			boutput(user, "<span style=\"color:blue\">You swipe the card along a crack in the machine.</span>")

		if (prob(5))
			var/obj/item/paint_can/rainbow/plaid/P = new/obj/item/paint_can/rainbow/plaid(src.loc)
			if (user)
				boutput(user, "<span style=\"color:blue\">You hear a faint droning sound. Like a tiny set of bagpipes.</span>")
			P.uses = (15 * 7)
			P.generate_icon()
		else
			var/obj/item/paint_can/rainbow/P = new/obj/item/paint_can/rainbow(src.loc)
			P.uses = (15 * 7)
			P.generate_icon()

		return 1

	attackby(obj/item/W as obj, mob/user as mob)
		if(istype(W,/obj/item/paint_can))
			boutput(user, "<span style=\"color:blue\">You refill the paint can.</span>")
			W:uses = 15
			W:generate_icon()

			return

	attack_hand(mob/user as mob)
		var/col_new = F_Color_Selector.Get_Color(user, paint_color)
		if(col_new)
			var/obj/item/paint_can/P = new/obj/item/paint_can(src.loc)
			P.paint_color = col_new
			paint_color = col_new
			P.generate_icon()
		return

var/list/cached_colors = new/list()

/obj/item/paint_can
	name = "paint can"
	desc = "A Paint Can and a brush."
	icon = 'icons/misc/old_or_unused.dmi'
	icon_state = "paint"
	item_state = "bucket"
	var/paint_color = rgb(1,1,1)
	var/obj/paint_overlay
	var/uses = 15
	flags = FPRINT | EXTRADELAY | TABLEPASS | CONDUCT
	w_class = 2.0

	attack_hand(mob/user as mob)
		..()

		generate_icon()

	afterattack(atom/target as mob|obj|turf, mob/user as mob)
		if(target == loc || get_dist(src,target) > 1 || istype(target,/obj/machinery/vending/paint) ) return

		if(!uses)
			boutput(user, "It's empty.")
			return

		boutput(user, "You paint \the [target].")
		for(var/mob/O in oviewers(world.view, user))
			O.show_message("<span style=\"color:blue\">[user] paints \the [target].</span>", 1)

		playsound(src, "sound/effects/splat.ogg", 40, 1)

		uses--
		if(!uses) overlays = null

		/*
		if( (paint_color+"[initial(target.icon)]") in cached_colors )
			target.icon = cached_colors[(paint_color+"[initial(target.icon)]")]
		else
			var/icon/new_icon = icon(target.icon)
			new_icon.ColorTone(paint_color)
			cached_colors += (paint_color+"[initial(target.icon)]")
			cached_colors[(paint_color+"[initial(target.icon)]")] = new_icon
			target.icon = new_icon
		*/
		var/oldVal = target.color
		target.color = paint_color
		target.onVarChanged("color", oldVal, paint_color) // to force redraws on worn items if needed

		//var/icon/new_icon = icon(initial(target.icon))
		//new_icon.ColorTone(color)
		//target.icon = new_icon

		return

	proc/generate_icon()
		if (!paint_overlay)
			paint_overlay = new
			paint_overlay.icon = icon('icons/misc/old_or_unused.dmi',"paint_overlay")
		paint_overlay.color = paint_color
		overlays = null
		overlays += paint_overlay

/obj/item/paint_can/random
	name = "random paint can"
	uses = 5
	New()
		..()
		spawn(5)
			var/colorname = "Weird"
			switch(rand(1,6))
				if(1)
					paint_color = rgb(255,10,10)
					colorname = "red"
				if(2)
					paint_color = rgb(10,255,10)
					colorname = "green"
				if(3)
					paint_color = rgb(10,10,255)
					colorname = "blue"
				if(4)
					paint_color = rgb(255,255,10)
					colorname = "yellow"
				if(5)
					paint_color = rgb(255,10,255)
					colorname = "purple"
				if(6)
					paint_color = rgb(150,150,150)
					colorname = "gray"

			name = "[colorname] paint can"
			desc = "[colorname] paint. In a can. Whoa!"
			src.generate_icon()

/obj/item/paint_can/rainbow
	name = "rainbow paint can"
	desc = "This Paint Can contains rich, thick, rainbow paint. No, we don't know how it works either."
	var/colorlist[]
	var/currentcolor
	New()
		..()

		//A rainbow of colours! Joy!
		src.colorlist = list(rgb(255,0,0),rgb(255,165,0), rgb(255,255,0), rgb(0,128,0), rgb(0,0,255), rgb(075,0,128), rgb(238,128,238))
		src.currentcolor = 1
		src.paint_color = colorlist[currentcolor]


	afterattack(atom/target as mob|obj|turf, mob/user as mob)
		..()
		src.currentcolor += 1
		if (src.currentcolor == 8)
			src.currentcolor = 1

		src.paint_color = colorlist[currentcolor]

		src.generate_icon()

		return

/obj/item/paint_can/rainbow/plaid
	name = "pattern paint can"
	desc = "A perfectly ordinary can of paint. Oh, except that it paints patterns."
	var/patternlist[]
	var/currentpattern

	New()
		..()

		src.patternlist = list("tartan", "strongplaid", "polka", "hearts")
		currentpattern = 1

	afterattack(atom/target as mob|obj|turf, mob/user as mob)
		if(target == loc || get_dist(src,target) > 1 || istype(target,/obj/machinery/vending/paint) ) return

		if(!uses)
			boutput(user, "It's empty.")
			return

		boutput(user, "You paint \the [target].")
		for(var/mob/O in oviewers(world.view, user))
			O.show_message("<span style=\"color:blue\">[user] paints \the [target].</span>", 1)

		playsound(src, "sound/effects/splat.ogg", 40, 1)

		uses--
		if(!uses) overlays = null

		if( (paint_color+"[initial(target.icon)]") in cached_colors )
			target.icon = cached_colors[(paint_color+"[initial(target.icon)]")]
		else
			var/icon/new_icon = icon(target.icon)

			//Add pattern here.
			var/icon/pattern = new('icons/obj/paint.dmi', patternlist[currentpattern])
			new_icon.Blend(pattern,ICON_MULTIPLY)

			new_icon.ColorTone(paint_color)
			cached_colors += (paint_color+"[initial(target.icon)]")
			cached_colors[(paint_color+"[initial(target.icon)]")] = new_icon
			target.icon = new_icon


		src.currentcolor += 1
		if (src.currentcolor == 8)
			src.currentcolor = 1

		src.paint_color = colorlist[currentcolor]

		src.currentpattern += 1
		if (src.currentpattern == 4)
			src.currentpattern = 1

		src.generate_icon()
