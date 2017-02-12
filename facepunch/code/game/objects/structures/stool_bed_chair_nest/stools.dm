/obj/structure/stool
	name = "stool"
	desc = "Apply butt."
	icon = 'icons/obj/objects.dmi'
	icon_state = "stool"
	anchored = 0
	flags = FPRINT
	pressure_resistance = 15
	health = 20
	max_health = 20
	var/is_syndicate = 0


	destroy()
		new /obj/item/stack/sheet/metal(src.loc)
		..()
		return


	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(user.a_intent == "hurt")
			..()
			return
		if(istype(W, /obj/item/weapon/wrench))
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			new /obj/item/stack/sheet/metal(src.loc)
			del(src)
		return


	HasProximity(atom/movable/AM as mob|obj)
		if(!is_syndicate)
			return
		if(ishuman(AM) && prob(40))
			var/mob/living/carbon/human/H = AM
			src.visible_message("\red <b>The [src.name] trips [AM]!</b>","\red You hear someone fall")
			H.deal_damage(2, WEAKEN)
		return