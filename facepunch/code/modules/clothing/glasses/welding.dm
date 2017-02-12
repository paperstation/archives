
/obj/item/clothing/glasses/welding
	name = "welding goggles"
	desc = "Protects the eyes from welders, approved by the mad scientist association."
	icon_state = "welding-g"
	item_state = "welding-g"
	icon_action_button = "action_welding_g"
	var/up = 0

	attack_self()
		toggle()

	verb/toggle()
		set category = "Object"
		set name = "Adjust welding goggles"
		set src in usr

		if(usr.canmove && !usr.stat && !usr.restrained())
			if(src.up)
				src.up = !src.up
				src.flags |= GLASSESCOVERSEYES
				flags_inv |= HIDEEYES
				icon_state = initial(icon_state)
				usr << "You flip the [src] down to protect your eyes."
			else
				src.up = !src.up
				src.flags &= ~HEADCOVERSEYES
				flags_inv &= ~HIDEEYES
				icon_state = "[initial(icon_state)]up"
				usr << "You push the [src] up out of your face."
			usr.update_inv_glasses()
		return

