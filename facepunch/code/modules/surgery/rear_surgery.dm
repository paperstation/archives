/datum/surgery/buttsurgery
	name = "body repair"
	steps = list(/datum/surgery_step/buttsurgery, /datum/surgery_step/close)
	species = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	location = "chest"


//fix eyes
/datum/surgery_step/buttsurgery
	implements = list(/obj/item/weapon/syntiflesh = 100)
	time = 64

/datum/surgery_step/buttsurgery/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='notice'>[user] begins to place the replacement flesh on [target].</span>")

/datum/surgery_step/buttsurgery/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='notice'>[user] successfully applies the replacement flesh onto [target]!</span>")
	target.physeffect &= ASSLESS
	target.physeffect &= FACESCAR
/datum/surgery_step/buttsurgery/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(!target.physeffect)
		user.visible_message("<span class='warning'>[user] can't find a place to put the replacement flesh on [target]!</span>")