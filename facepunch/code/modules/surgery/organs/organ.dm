/obj/item/organ
	name = "organ"
	icon = 'icons/obj/surgery.dmi'
	var/uses = 30


/obj/item/organ/heart
	name = "heart"
	icon_state = "heart-on"
	var/beating = 1
	var/istate = "heart"

/obj/item/organ/heart/update_icon()
	if(beating)
		icon_state = "[istate]-on"
	else
		icon_state = "[istate]-off"

/obj/item/organ/appendix
	name = "appendix"
	icon_state = "appendix"
	var/inflamed = 1

/obj/item/organ/appendix/update_icon()
	if(inflamed)
		icon_state = "appendixinflamed"
	else
		icon_state = "appendix"



/obj/item/organ/heart/attack(mob/living/M as mob, mob/living/user as mob)
	if(M == user)
		if(beating)
			if(uses >= 1)
				uses -= 10.
				user 	<< "You unwillingly chew a bit of the heart."
				user.nutrition += 5
			else
				user << "\red You finish eating the heart."
				del(src)
		else
			..()

/obj/item/organ/appendix/attack(mob/living/M as mob, mob/living/user as mob)
	if(M == user)
		if(inflamed)
			if(uses >= 1)
				uses -= 10.
				user 	<< "You unwillingly chew a bit of the appendix."
				user.nutrition += 5
			else
				user << "\red You finish eating the appendix."
				del(src)
		else
			..()