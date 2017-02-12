/datum/surgery/butt_removal
	name = "butt removal"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/clamp_bleeders, /datum/surgery_step/retract_skin, /datum/surgery_step/saw, /datum/surgery_step/extract_butt)
	species = list(/mob/living/carbon/human, /mob/living/carbon/monkey, /mob/living/carbon/alien)
	location = "groin"


//extract ur butte
/datum/surgery_step/extract_butt
	implements = list(/obj/item/weapon/hemostat = 100, /obj/item/weapon/crowbar = 55)
	time = 64
	var/obj/item/clothing/head/butt/B = null

/datum/surgery_step/extract_butt/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	B = target.getorgan(/obj/item/clothing/head/butt)
	if(B)
		user.visible_message("<span class='notice'>[user] begins to remove [target]'s butt.</span>")
	else
		user.visible_message("<span class='notice'>[user] stares at [target]'s non-existent ass.</span>")

/datum/surgery_step/extract_butt/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(B)
		user.visible_message("<span class='notice'>[user] successfully removes [target]'s butt!</span>")
		B.loc = get_turf(target)
		target.internal_organs -= B
	else
		user.visible_message("<span class='notice'>[user] can't find a butt on [target]!</span>")
	return 1

/*

/datum/surgery/butt_implant
	name = "butt implant"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/clamp_bleeders, /datum/surgery_step/retract_skin, /datum/surgery_step/saw, /datum/surgery_step/add_butt)
	species = list(/mob/living/carbon/human, /mob/living/carbon/monkey, /mob/living/carbon/alien)
	location = "groin"


//adds ur butte
/datum/surgery_step/add_butt
	implements = list(/obj/item/clothing/head/butt = 100)
	time = 64
	var/obj/item/clothing/head/butt/B = null

/datum/surgery_step/add_butt/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	B = target.getorgan(/obj/item/clothing/head/butt)
	if(!B)
		user.visible_message("<span class='notice'>[user] begins to replace [target]'s butt.</span>")
	else
		user.visible_message("<span class='notice'>[user] rubs the butt against [target]'s butt. That's pretty creepy.</span>")

/datum/surgery_step/add_butt/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(!B)
		user.visible_message("<span class='notice'>[user] successfully removes [target]'s butt!</span>")
		user.drop_item()
		qdel(tool)
		target.internal_organs += B
	else
		user.visible_message("<span class='notice'>[user] rubs the butt against [target]'s butt. They need to stop that.</span>")
	return 1
*/