/obj
	//var/datum/module/mod		//not used
	var/real_name = null
	var/real_desc = null
	var/m_amt = 0	// metal
	var/g_amt = 0	// glass
	var/w_amt = 0	// waster amounts
	var/quality = 1
	var/adaptable = 0

	var/is_syndicate = 0
	var/list/mats = 0
	var/mechanics_type_override = null //Fix for children of scannable items being reproduced in mechanics
	var/artifact = null
	var/move_triggered = 0

	proc/move_trigger(var/mob/M, var/kindof)
		var/atom/movable/x = loc
		while (x && !isarea(x) && x != M)
			x = x.loc
		if (!x || isarea(x))
			return 0
		return 1

	animate_movement = 2
//	desc = "<span style=\"color:red\">HI THIS OBJECT DOESN'T HAVE A DESCRIPTION MAYBE IT SHOULD???</span>"
//heh no not really

	var/_health = 100
	var/_max_health = 100
	proc/setHealth(var/value)
		var/prevHealth = _health
		_health = min(value, _max_health)
		updateHealth(prevHealth)
		return
	proc/changeHealth(var/change = 0)
		var/prevHealth = _health
		_health += change
		_health = min(_health, _max_health)
		updateHealth(prevHealth)
		return
	proc/updateHealth(var/prevHealth)
		/*
		if(_health <= 0)
			onDestroy()
		else
			if((_health > 75) && !(prevHealth > 75))
				UpdateOverlays(null, "damage")
			else if((_health <= 75 && _health > 50) && !(prevHealth <= 75 && prevHealth > 50))
				setTexture("damage1", BLEND_MULTIPLY, "damage")
			else if((_health <= 50 && _health > 25) && !(prevHealth <= 50 && prevHealth > 25))
				setTexture("damage2", BLEND_MULTIPLY, "damage")
			else if((_health <= 25) && !(prevHealth <= 25))
				setTexture("damage3", BLEND_MULTIPLY, "damage")
		*/
		return
	proc/onDestroy()
		src.visible_message("<span style=\"color:red\"><b>[src] is destroyed.</b></span>")
		qdel(src)
		return

	ex_act(severity)
		if(src.material)
			src.material.triggerExp(src, severity)
		switch(severity)
			if(1.0)
				changeHealth(-95)
				return
			if(2.0)
				changeHealth(-70)
				return
			if(3.0)
				changeHealth(-40)
				return
			else
		return

	proc/ex_act_third(severity)
		switch(severity)
			if(1.0)
				qdel(src)
				return
			if(2.0)
				if (prob(66))
					qdel(src)
					return
			if(3.0)
				if (prob(33))
					qdel(src)
					return
			else
		return


	onMaterialChanged()
		..()
		if(istype(src.material))
			pressure_resistance = round((material.getProperty(PROP_COMPRESSIVE) + material.getProperty(PROP_TENSILE)) / 2)
			throwforce = round(max(material.getProperty(PROP_HARDNESS),7) / 7)
			quality = src.material.quality
			if(initial(src.opacity) && src.material.alpha <= MATERIAL_ALPHA_OPACITY)
				src.opacity = 0
			else if(initial(src.opacity) && !src.opacity && src.material.alpha > MATERIAL_ALPHA_OPACITY)
				src.opacity = 1
		return

	disposing()
		mats = null
		..()

	proc/override_southeast(var/mob/user)
		return 0
	proc/override_northeast(var/mob/user)
		return 0
	proc/override_northwest(var/mob/user)
		return 0
	proc/client_login(var/mob/user)
		return

	proc/clone(var/newloc = null)
		var/obj/O = new type()
		if (newloc)
			O.set_loc(newloc)
		O.name = name
		O.quality = quality
		O.icon = icon
		O.icon_state = icon_state
		O.dir = dir
		O.desc = desc
		O.pixel_x = pixel_x
		O.pixel_y = pixel_y
		O.color = color
		O.anchored = anchored
		O.density = density
		O.opacity = opacity
		if (material)
			O.setMaterial(material)
		O.transform = transform
		return O

	proc/pixelaction(atom/target, params, mob/user, reach)
		return 0

	proc/handle_internal_lifeform(mob/lifeform_inside_me, breath_request)
		//Return: (NONSTANDARD)
		//		null if object handles breathing logic for lifeform
		//		datum/air_group to tell lifeform to process using that breath return
		//DEFAULT: Take air from turf to give to have mob process
		if(breath_request>0)
			return remove_air(breath_request)
		else
			return null

	proc/initialize()

	proc/hotkey(var/mob/user, var/key)
		return

	attackby(obj/item/I as obj, mob/user as mob)
// grabsmash
		if (istype(I, /obj/item/grab/))
			var/obj/item/grab/G = I
			if  (!grab_smash(G, user))
				return ..(I, user)
			else return
		return ..(I, user)


	MouseDrop(atom/over_object as mob|obj|turf)
		..()
		if(usr.bioHolder && usr.bioHolder.HasEffect("telekinesis_drag") && istype(src, /obj) && isturf(src.loc) && usr.stat == 0  && usr.canmove && get_dist(src,usr) <= 7 )
			var/datum/bioEffect/TK = usr.bioHolder.GetEffect("telekinesis_drag")

			if(!src.anchored && (istype(src, /obj/item) || TK.variant == 2))
				src.throw_at(over_object, 7, 1)
				logTheThing("combat", usr, null, "throws \the [src] with telekinesis.")

	serialize(var/savefile/F, var/path, var/datum/sandbox/sandbox)
		F["[path].type"] << type
		serialize_icon(F, path, sandbox)
		F["[path].name"] << name
		F["[path].dir"] << dir
		F["[path].desc"] << desc
		F["[path].color"] << color
		F["[path].density"] << density
		F["[path].opacity"] << opacity
		F["[path].anchored"] << anchored
		F["[path].pixel_x"] << pixel_x
		F["[path].pixel_y"] << pixel_y
		F["[path].layer"] << layer
		matrix_serializer(F, path, sandbox, "transform", transform)

	deserialize(var/savefile/F, var/path, var/datum/sandbox/sandbox)
		deserialize_icon(F, path, sandbox)
		F["[path].name"] >> name
		F["[path].dir"] >> dir
		F["[path].desc"] >> desc
		F["[path].color"] >> color
		F["[path].density"] >> density
		F["[path].opacity"] >> opacity
		RL_SetOpacity(opacity)
		F["[path].anchored"] >> anchored
		F["[path].pixel_x"] >> pixel_x
		F["[path].pixel_y"] >> pixel_y
		if (F["[path].layer"]) //I added this on 19/10/15, many people have older saves so this is here to not break them - Wire
			F["[path].layer"] >> layer
		transform = matrix_deserializer(F, path, sandbox, "transform", transform)
		return DESERIALIZE_OK

	deserialize_postprocess()
		return

/obj/proc/updateUsrDialog()
	var/list/nearby = viewers(1, src)
	for(var/mob/M in nearby)
		if ((M.client && M.machine == src))
			src.attack_hand(M)
	if (istype(usr, /mob/living/silicon))
		if (!(usr in nearby))
			if (usr.client && usr.machine==src) // && M.machine == src is omitted because if we triggered this by using the dialog, it doesn't matter if our machine changed in between triggering it and this - the dialog is probably still supposed to refresh.
				src.attack_ai(usr)

/obj/proc/updateDialog()
	var/list/nearby = viewers(1, src)
	for(var/mob/M in nearby)
		if ((M.client && M.machine == src))
			src.attack_hand(M)
	AutoUpdateAI(src)

/obj/item/proc/updateSelfDialog()
	var/mob/M = src.loc
	if(istype(M) && M.client && M.machine == src)
		src.attack_self(M)

/obj/mark
		icon = 'icons/misc/mark.dmi'
		icon_state = "blank"

		anchored = 1
		layer = 99
		mouse_opacity = 0

		var/mark = ""

/obj/bedsheetbin
	name = "linen bin"
	desc = "A bin for containing bedsheets."
	icon = 'icons/obj/items.dmi'
	icon_state = "bedbin"
	var/amount = 23.0
	anchored = 1.0

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/clothing/suit/bedsheet))
			qdel(W)
			src.amount++
		return

	attack_hand(mob/user as mob)
		if (src.amount >= 1)
			src.amount--
			new /obj/item/clothing/suit/bedsheet(src.loc)
			add_fingerprint(user)

	get_desc()
		. += "There's [src.amount ? src.amount : "no"] bedsheet[s_es(src.amount)] in [src]."

/obj/towelbin
	name = "towel bin"
	desc = "A bin for containing towels."
	icon = 'icons/obj/items.dmi'
	icon_state = "bedbin"
	var/amount = 23.0
	anchored = 1.0

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/clothing/under/towel))
			qdel(W)
			src.amount++
		return

	attack_hand(mob/user as mob)
		if (src.amount >= 1)
			src.amount--
			new /obj/item/clothing/under/towel(src.loc)
			add_fingerprint(user)

	get_desc()
		. += "There's [src.amount ? src.amount : "no"] towel[s_es(src.amount)] in [src]."

/obj/equip_e
	name = "equip e"
	var/mob/source = null
	var/s_loc = null
	var/t_loc = null
	var/obj/item/item = null
	var/place = null

/obj/equip_e/human
	name = "human"
	var/mob/living/carbon/human/target = null

/obj/securearea
	desc = "A warning sign which reads 'SECURE AREA'"
	name = "SECURE AREA"
	icon = 'icons/obj/decals.dmi'
	icon_state = "securearea"
	anchored = 1.0
	opacity = 0
	density = 0
	layer=EFFECTS_LAYER_BASE

/obj/securearea/ex_act(severity)
	ex_act_third(severity)

/obj/joeq
	desc = "Here lies Joe Q. Loved by all. He was a terrorist. R.I.P."
	name = "Joe Q. Memorial Plaque"
	icon = 'icons/obj/decals.dmi'
	icon_state = "rip"
	anchored = 1.0
	opacity = 0
	density = 0

/obj/fudad
	desc = "In memory of Arthur \"F. U. Dad\" Muggins, the bravest, toughest Vice Cop SS13 has ever known. Loved by all. R.I.P."
	name = "Arthur Muggins Memorial Plaque"
	icon = 'icons/obj/decals.dmi'
	icon_state = "rip"
	anchored = 1.0
	opacity = 0
	density = 0

/obj/juggleplaque
	desc = "In loving and terrified memory of those who discovered the dark secret of Jugglemancy. \"E. Shirtface, Juggles the Clown, E. Klein, A.F. McGee,  J. Flarearms.\""
	name = "Funny-Looking Memorial Plaque"
	icon = 'icons/obj/decals.dmi'
	icon_state = "rip"
	anchored = 1.0
	opacity = 0
	density = 0

/obj/lattice
	desc = "A lightweight support lattice."
	name = "lattice"
	icon = 'icons/obj/structures.dmi'
	icon_state = "lattice"
	density = 0
	anchored = 1.0
	layer = LATTICE_LAYER
	//	flags = CONDUCT

	blob_act(var/power)
		if(prob(75))
			qdel(src)
			return

	ex_act(severity)
		if(src.material)
			src.material.triggerExp(src, severity)
		switch(severity)
			if(1.0)
				qdel(src)
				return
			if(2.0)
				qdel(src)
				return
			if(3.0)
				return
			else
		return

	attackby(obj/item/C as obj, mob/user as mob)

		if (istype(C, /obj/item/tile))

			C:build(get_turf(src))
			C:amount--
			playsound(src.loc, "sound/weapons/Genhit.ogg", 50, 1)
			C.add_fingerprint(user)

			if (C:amount < 1)
				user.u_equip(C)
				qdel(C)
			qdel(src)
			return
		if (istype(C, /obj/item/weldingtool) && C:welding)
			boutput(user, "<span style=\"color:blue\">Slicing lattice joints ...</span>")
			C:eyecheck(user)
			new /obj/item/rods/steel(src.loc)
			qdel(src)
		if (istype(C, /obj/item/rods))
			var/obj/item/rods/R = C
			if (R.amount >= 2)
				R.amount -= 2
				boutput(user, "<span style=\"color:blue\">You assemble a barricade from the lattice and rods.</span>")
				new /obj/lattice/barricade(src.loc)
				if (R.amount < 1)
					user.u_equip(C)
					qdel(C)
				qdel(src)
		return

/obj/lattice/barricade
	name = "barricade"
	desc = "A lattice that has been turned into a makeshift barricade."
	icon_state = "girder"
	density = 1
	var/strength = 2

	proc/barricade_damage(var/hitstrength)
		strength -= hitstrength
		playsound(src.loc, "sound/effects/grillehit.ogg", 50, 1)
		if (strength < 1)
			src.visible_message("The barricade breaks!")
			if (prob(50)) new /obj/item/rods/steel(src.loc)
			qdel(src)
			return

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/weldingtool))
			var/obj/item/weldingtool/WELD = W
			if(WELD.welding)
				boutput(user, "<span style=\"color:blue\">You disassemble the barricade.</span>")
				WELD.eyecheck(user)
				var/obj/item/rods/R = new /obj/item/rods/steel(src.loc)
				R.amount = src.strength
				qdel(src)
				return
		else if (istype(W,/obj/item/rods))
			var/obj/item/rods/R = W
			var/difference = 5 - src.strength
			if (difference <= 0)
				boutput(user, "<span style=\"color:red\">This barricade is already fully reinforced.</span>")
				return
			if (R.amount > difference)
				R.amount -= difference
				src.strength = 5
				boutput(user, "<span style=\"color:blue\">You reinforce the barricade.</span>")
				boutput(user, "<span style=\"color:blue\">The barricade is now fully reinforced!</span>") // seperate line for consistency's sake i guess
				return
			else if (R.amount <= difference)
				R.amount -= difference
				src.strength = 5
				boutput(user, "<span style=\"color:blue\">You use up the last of your rods to reinforce the barricade.</span>")
				if (src.strength >= 5) boutput(user, "<span style=\"color:blue\">The barricade is now fully reinforced!</span>")
				if (R.amount < 1)
					user.u_equip(W)
					qdel(W)
				return
		else
			if (W.force > 8)
				src.barricade_damage(W.force / 8)
				playsound(src.loc, "sound/effects/grillehit.ogg", 50, 1)
			..()

	ex_act(severity)
		switch(severity)
			if(1.0)
				qdel(src)
				return
			if(2.0) src.barricade_damage(3)
			if(3.0) src.barricade_damage(1)
		return

	blob_act(var/power)
		src.barricade_damage(2 * power / 20)

	meteorhit()
		src.barricade_damage(1)

/obj/list_container
	name = "list container"

/obj/list_container/mobl
	name = "mobl"
	var/master = null

	var/list/container = list(  )

/obj/manifest
	name = "manifest"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"

/obj/overlay
	name = "overlay"
	mat_changename = 0
	mat_changedesc = 0
	updateHealth()
		return

	meteorhit(obj/M as obj)
		if (src.z == 2)
			return
		else
			return ..()

	ex_act(severity)
		if (src.z == 2)
			return
		else
			return ..()

/obj/overlay/self_deleting
	New(newloc, deleteTimer)
		..()
		if (deleteTimer)
			spawn(deleteTimer)
				qdel(src)

/obj/projection
	name = "Projection"
	anchored = 1.0



/obj/shut_controller
	name = "shut controller"
	var/moving = null
	var/list/parts = list(  )

/obj/deskclutter
	name = "desk clutter"
	icon = 'icons/obj/items.dmi'
	icon_state = "deskclutter"
	desc = "What a mess..."
	anchored = 1



/obj/item/mouse_drag_pointer = MOUSE_ACTIVE_POINTER

// TODO: robust mixology system! (and merge with beakers, maybe)
//obj/item/glass
//	name = "empty glass"
//	icon = 'icons/obj/kitchen.dmi'
//	icon_state = "glass_empty"
//	item_state = "beaker"
//	flags = FPRINT | TABLEPASS | OPENCONTAINER
//	var/datum/substance/inside = null
//	throwforce = 5
//	g_amt = 100
//	New()
//		..()
//		src.pixel_x = rand(-5, 5)
//		src.pixel_y = rand(-5, 5)

/obj/proc/alter_health()
	return 1

/obj/proc/hide(h)
	return

/client/proc/replace_with_explosive(var/obj/O as obj in world)
	set name = "Replace with explosive replica"
	set desc = "Dick move."
	set category = "Special Verbs"
	if (alert("Are you sure? This will irreversibly replace this object with a copy that gibs the first person trying to touch it!", "Replace with explosive", "Yes", "No") == "Yes")
		message_admins("[key_name(usr)] replaced [src] ([showCoords(O.x, O.y, O.z)]) with an explosive replica.")
		logTheThing("admin", usr, null, "replaced [src] ([showCoords(O.x, O.y, O.z)]) with an explosive replica.")
		var/obj/replica = new /obj/item/card/id/captains_spare/explosive(O.loc)
		replica.icon = O.icon
		replica.icon_state = O.icon_state
		replica.name = O.name
		replica.desc = O.desc
		replica.density = O.density
		replica.opacity = O.opacity
		replica.anchored = O.anchored
		replica.layer = O.layer - 0.05
		replica.pixel_x = O.pixel_x
		replica.pixel_y = O.pixel_y
		replica.dir = O.dir
		qdel(O)


/obj/disposing()
	for(var/mob/M in src.contents)
		M.set_loc(src.loc)
	set_loc(null)
	tag = null
	..()