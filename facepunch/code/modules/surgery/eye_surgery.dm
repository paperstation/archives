/datum/surgery/eye_surgery
	name = "eye surgery"
	steps = list(/datum/surgery_step/incise/eyes, /datum/surgery_step/retract_skin/eyes, /datum/surgery_step/clamp_bleeders/eyes, /datum/surgery_step/fix_eyes, /datum/surgery_step/close/eyes)
	species = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	location = "head"


//fix eyes
/datum/surgery_step/fix_eyes
	implements = list(/obj/item/weapon/hemostat = 100, /obj/item/weapon/screwdriver = 45, /obj/item/weapon/pen = 25)
	time = 64

/datum/surgery_step/fix_eyes/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='notice'>[user] begins to fix [target]'s eyes.</span>")

/datum/surgery_step/fix_eyes/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='notice'>[user] successfully fixes [target]'s eyes!</span>")
	target.sdisabilities &= ~BLIND
	target.disabilities &= ~NEARSIGHTED
	target.eye_blurry = 35	//this will fix itself slowly.
	target.eye_stat = 0

/datum/surgery_step/fix_eyes/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(getbrain(target))
		user.visible_message("<span class='warning'>[user] accidentally stabs [target] right in the brain!</span>")
		target.brain_damage += 100
	else
		user.visible_message("<span class='warning'>[user] accidentally stabs [target] right in the brain! Or would have, if [target] had a brain.</span>")








/datum/surgery_step/incise/eyes
	implements = list(/obj/item/weapon/scalpel = 100, /obj/item/weapon/kitchenknife = 65, /obj/item/weapon/shard = 45)
	time = 24

/datum/surgery_step/incise/eyes/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='notice'>[user] begins to make an incision in [target]'s eyes.</span>")

//clamp bleeders
/datum/surgery_step/clamp_bleeders/eyes
	implements = list(/obj/item/weapon/hemostat = 100, /obj/item/weapon/wirecutters = 60, /obj/item/weapon/cable_coil = 15)
	time = 48

/datum/surgery_step/clamp_bleeders/eyes/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='notice'>[user] begins to clamp bleeders in [target]'s eyes.</span>")


//retract skin
/datum/surgery_step/retract_skin/eyes
	implements = list(/obj/item/weapon/retractor = 100, /obj/item/weapon/screwdriver = 45, /obj/item/weapon/wirecutters = 35)
	time = 32

/datum/surgery_step/retract_skin/eyes/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='notice'>[user] begins to retract the skin in [target]'s eyes.</span>")


//close incision
/datum/surgery_step/close/eyes
	implements = list(/obj/item/weapon/cautery = 100, /obj/item/weapon/weldingtool = 70, /obj/item/weapon/lighter = 45, /obj/item/weapon/match = 20)
	time = 32

/datum/surgery_step/close/eyes/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='notice'>[user] begins to mend the incision in [target]'s eyes.</span>")
