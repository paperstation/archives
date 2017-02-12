/datum/surgery/appendectomy
	name = "appendectomy"
	steps = list(/datum/surgery_step/incise/groin, /datum/surgery_step/clamp_bleeders/groin, /datum/surgery_step/retract_skin/groin, /datum/surgery_step/incise/groin, /datum/surgery_step/extract_appendix, /datum/surgery_step/close/groin)
	species = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	location = "chest"


//extract appendix
/datum/surgery_step/extract_appendix
	implements = list(/obj/item/weapon/hemostat = 100, /obj/item/weapon/crowbar = 55)
	time = 64
	var/obj/item/organ/appendix/A = null

/datum/surgery_step/extract_appendix/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	A = locate() in target.internal_organs
	if(A)
		user.visible_message("<span class='notice'>[user] begins to extract [target]'s appendix.</span>")
	else
		user.visible_message("<span class='notice'>[user] looks for an appendix in [target].</span>")

/datum/surgery_step/extract_appendix/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(A)
		user.visible_message("<span class='notice'>[user] successfully removes [target]'s appendix!</span>")
		A.loc = get_turf(target)
		target.internal_organs -= A
		for(var/datum/disease/appendicitis in target.viruses)
			appendicitis.cure()
	else
		user.visible_message("<span class='notice'>[user] can't find an appendix in [target]!</span>")




/datum/surgery_step/incise/groin
	implements = list(/obj/item/weapon/scalpel = 100, /obj/item/weapon/kitchenknife = 65, /obj/item/weapon/shard = 45)
	time = 24

/datum/surgery_step/incise/groin/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='notice'>[user] begins to make an incision in [target]'s groin.</span>")

//clamp bleeders
/datum/surgery_step/clamp_bleeders/groin
	implements = list(/obj/item/weapon/hemostat = 100, /obj/item/weapon/wirecutters = 60, /obj/item/weapon/cable_coil = 15)
	time = 48

/datum/surgery_step/clamp_bleeders/groin/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='notice'>[user] begins to clamp bleeders in [target]'s groin.</span>")


//retract skin
/datum/surgery_step/retract_skin/groin
	implements = list(/obj/item/weapon/retractor = 100, /obj/item/weapon/screwdriver = 45, /obj/item/weapon/wirecutters = 35)
	time = 32

/datum/surgery_step/retract_skin/groin/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='notice'>[user] begins to retract the skin in [target]'s groin.</span>")


//close incision
/datum/surgery_step/close/groin
	implements = list(/obj/item/weapon/cautery = 100, /obj/item/weapon/weldingtool = 70, /obj/item/weapon/lighter = 45, /obj/item/weapon/match = 20)
	time = 32

/datum/surgery_step/close/groin/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='notice'>[user] begins to mend the incision in [target]'s groin.</span>")
