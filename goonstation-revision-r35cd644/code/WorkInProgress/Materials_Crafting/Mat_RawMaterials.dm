/obj/item/material_piece
	name = "bar"
	desc = "Some sort of processed material bar."
	icon = 'icons/obj/materials.dmi'
	icon_state = "bar"
	var/default_material = null // used for prefab bars

	New()
		..()
		if (istext(default_material))
			var/datum/material/M = getCachedMaterial(default_material)
			src.setMaterial(M)

	block
		// crystal, rubber
		name = "block"
		icon_state = "block"
		desc = "A nicely cut square brick."

	cloth
		// fabric
		icon_state = "fabric"
		name = "fabric"
		desc = "A weave of some kind."

	wad
		// organic
		icon_state = "wad"
		name = "clump"
		desc = "A clump of some kind of material."

	sphere
		// energy
		icon_state = "sphere"
		name = "sphere"
		desc = "A weird sphere of some kind."

	MouseDrop(over_object, src_location, over_location)
		if (istype(usr,/mob/dead/))
			boutput(usr, "<span style=\"color:red\">Quit that! You're dead!</span>")
			return

		if (get_dist(usr,src) > 1)
			boutput(usr, "<span style=\"color:red\">You're too far away from it to do that.</span>")
			return

		if (get_dist(usr,over_object) > 1)
			boutput(usr, "<span style=\"color:red\">You're too far away from it to do that.</span>")
			return

		if (isturf(over_object))
			var/turf/T = over_object
			usr.visible_message("<span style=\"color:blue\">[usr.name] begins sorting [src] into a pile!</span>")
			var/staystill = usr.loc
			for(var/obj/item/I in view(1,usr))
				if (!I)
					continue
				if (src.name != I.name)
					continue
				if (I.loc == usr)
					continue
				I.set_loc(T)
				sleep(0.5)
				if (usr.loc != staystill) break
			boutput(usr, "<span style=\"color:blue\">You finish sorting [src]!</span>")

		else
			..()

/obj/item/material_piece/iridiumalloy
	icon_state = "iridium"
	name = "iridium-alloy plate"
	desc = "A chunk of some sort of iridium-alloy plating."
	New()
		src.material = getCachedMaterial("iridiumalloy")
		..()

/obj/item/material_piece/spacelag
	icon_state = "spacelag"
	name = "spacelag bar"
	desc = "Yep. There it is. You've done it. I hope you're happy now."
	New()
		src.material = getCachedMaterial("spacelag")
		..()

/obj/item/material_piece/slag
	icon_state = "slag"
	name = "slag"
	desc = "By-product of smelting"
	New()
		src.material = getCachedMaterial("slag")
		..()

/obj/item/material_piece/cloth/spidersilk
	name = "space spider silk"
	desc = "space silk produced by space dwelling space spiders. space."
	icon_state = "spidersilk"
	New()
		src.material = getCachedMaterial("spidersilk")
		..()

/obj/item/material_piece/cloth/leather
	name = "leather"
	desc = "leather made from the skin of some sort of space critter."
	icon_state = "leather"
	New()
		src.material = getCachedMaterial("leather")
		..()

/obj/item/material_piece/cloth/synthleather
	name = "synthleather"
	desc = "A type of artificial leather."
	icon_state = "synthleather"
	New()
		src.material = getCachedMaterial("synthleather")
		..()

/obj/item/material_piece/cloth/cottonfabric
	name = "cotton fabric"
	desc = "A type of natural fabric."
	icon_state = "fabric"
	New()
		src.material = getCachedMaterial("cotton")
		..()

/obj/item/material_piece/cloth/wendigohide
	name = "wendigo hide"
	desc = "The hide of a wendigo."
	icon_state = "wendigohide"
	New()
		src.material = getCachedMaterial("wendigohide")
		..()

/obj/item/material_piece/cloth/kingwendigohide
	name = "king wendigo hide"
	desc = "The hide of a king wendigo."
	icon_state = "wendigohide"
	New()
		src.material = getCachedMaterial("kingwendigohide")
		..()

/obj/item/material_piece/cloth/carbon
	name = "carbon nano fibre fabric"
	desc = "carbon based hi-tech material."
	icon_state = "carbonfibre"
	New()
		src.material = getCachedMaterial("carbonfibre")
		..()

/obj/item/material_piece/cloth/dyneema
	name = "dyneema fabric"
	desc = "carbon nanofibres and space spider silk!"
	icon_state = "dyneema"
	New()
		src.material = getCachedMaterial("dyneema")
		..()

/obj/item/material_piece/soulsteel
	name = "soulsteel bar"
	desc = "A bar of soulsteel. Metal made from souls."
	icon_state = "soulsteel"
	New()
		src.material = getCachedMaterial("soulsteel")
		..()

/obj/item/material_piece/bone
	name = "bits of bone"
	desc = "some bits and pieces of bones."
	icon_state = "scrap3"
	New()
		src.material = getCachedMaterial("bone")
		..()
