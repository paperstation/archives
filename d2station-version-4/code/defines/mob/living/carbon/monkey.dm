/mob/living/carbon/monkey
	name = "monkey"
	voice_name = "monkey"
	voice_message = "chimpers"
	say_message = "chimpers"
	icon = 'monkey.dmi'
	icon_state = "monkey1"
	gender = NEUTER
	pass_flags = PASSTABLE

	var/obj/item/weapon/card/id/wear_id = null // Fix for station bounced radios -- Skie

/mob/living/carbon/monkey/New()
	..()
	if(prob(20))
		if(prob(10))
			contract_disease(new /datum/disease/spaceaids) //MONKEYS RANDOMLY CATCH AIDS CUZ THEYR BLACK LOL

/mob/living/carbon/monkey/rpbody // For admin RP
	update_icon = 0
	voice_message = "says"
	say_message = "says"


/mob/living/carbon/monkey/ai_test/New()
	..()
	spawn(20)
		ai_init()

/mob/living/carbon/monkey/ai_test/violent/New()
	..()

/mob/living/carbon/monkey/rpbody // For admin RP
	update_icon = 0
	voice_message = "says"
	say_message = "says"

/mob/living/carbon/monkey/elf
	icon_state = "monkey1xmas"

/mob/living/carbon/monkey/rathen
	name = "Mr Rathen"
	icon_state = "rathen1"
	update_icon = 0
/mob/living/carbon/monkey/mellens
	name = "Mr Melons"
	icon_state = "melons1"
	update_icon = 0
/mob/living/carbon/monkey/muggles
	name = "Mr Muggles"
	icon_state = "muggles1"
	update_icon = 0
/mob/living/carbon/monkey/mrsmuggles
	name = "Mrs Muggles"
	icon_state = "mrsmuggles1"
	update_icon = 0
/mob/living/carbon/monkey/hunke
	name = "Hunke"
	icon_state = "hunke1"
	update_icon = 0
/mob/living/carbon/monkey/mimeky
	name = "Mimeky"
	icon_state = "mimeky1"
	update_icon = 0
/mob/living/carbon/monkey/dorfky
	name = "Dorfky"
	icon_state = "dorfky1"
	update_icon = 0
/mob/living/carbon/monkey/kobold
	name = "Kobold"
	icon_state = "kobold1"
	update_icon = 0

/mob/living/carbon/monkey/rat/brown
	name = "rat"
	voice_name = "rat"
	voice_message = "squeeks"
	say_message = "squeeks"
	icon = 'rats.dmi'
	icon_state = "brownrat1"
	gender = NEUTER
	flags = 258.0

/mob/living/carbon/monkey/rat/white
	name = "rat"
	voice_name = "rat"
	voice_message = "squeeks"
	say_message = "squeeks"
	icon = 'rats.dmi'
	icon_state = "whiterat1"
	gender = NEUTER
	flags = 258.0

/mob/living/carbon/monkey/rat/white/rpbody // For admin RP
	update_icon = 0
	voice_message = "says"
	say_message = "says"
	icon = 'rats.dmi'
	icon_state = "whiterat1"

/mob/living/carbon/monkey/rat/brown/rpbody // For admin RP
	update_icon = 0
	voice_message = "says"
	say_message = "says"
	icon = 'rats.dmi'
	icon_state = "brownrat1"