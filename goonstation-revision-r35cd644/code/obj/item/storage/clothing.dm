
/* ============================== */
/* ---------- Clothing ---------- */
/* ============================== */

/obj/item/storage/box/clothing
	icon_state = "clothing"

/obj/item/storage/box/clothing/captain
	name = "\improper Captain's clothing"
	spawn_contents = list(/obj/item/clothing/under/rank/captain,\
	/obj/item/clothing/under/rank/captain/dress,\
	/obj/item/clothing/head/fancy/captain,\
	/obj/item/clothing/under/rank/captain/fancy,\
	/obj/item/clothing/under/suit/captain,\
	/obj/item/clothing/under/suit/captain/dress)

/obj/item/storage/box/clothing/hos
	name = "\improper Head of Security's clothing"
	spawn_contents = list(/obj/item/clothing/under/rank/head_of_securityold,\
	/obj/item/clothing/under/rank/head_of_securityold/dress,\
	/obj/item/clothing/under/suit/hos,\
	/obj/item/clothing/under/suit/hos/dress,\
	/obj/item/clothing/under/rank/head_of_securityold/fancy)

/obj/item/storage/box/clothing/hop
	name = "\improper Head of Personnel's clothing"
	spawn_contents = list(/obj/item/clothing/under/rank/head_of_personnel,\
	/obj/item/clothing/under/rank/head_of_personnel/dress,\
	/obj/item/clothing/under/suit/hop,\
	/obj/item/clothing/under/suit/hop/dress,\
	/obj/item/clothing/head/fancy/rank,\
	/obj/item/clothing/under/rank/head_of_personnel/fancy)

/obj/item/storage/box/clothing/research_director
	name = "\improper Research Director's clothing"
	spawn_contents = list(/obj/item/clothing/under/rank/research_director,\
	/obj/item/clothing/under/rank/research_director/dress,\
	/obj/item/clothing/suit/labcoat,\
	/obj/item/clothing/head/fancy/rank,\
	/obj/item/clothing/under/rank/research_director/fancy)

/obj/item/storage/box/clothing/medical_director
	name = "\improper Medical Director's clothing"
	spawn_contents = list(/obj/item/clothing/under/rank/medical_director,\
	/obj/item/clothing/under/rank/medical_director/dress,\
	/obj/item/clothing/suit/labcoat,\
	/obj/item/clothing/head/fancy/rank,\
	/obj/item/clothing/under/rank/medical_director/fancy)

/obj/item/storage/box/clothing/chief_engineer
	name = "\improper Chief Engineer's clothing"
	spawn_contents = list(/obj/item/clothing/under/rank/chief_engineer,\
	/obj/item/clothing/under/rank/chief_engineer/dress,\
	/obj/item/clothing/head/fancy/rank,\
	/obj/item/clothing/under/rank/chief_engineer/fancy)

/* ============================== */
/* ---------- Costumes ---------- */
/* ============================== */

/obj/item/storage/box/costume
	icon_state = "costume"

/obj/item/storage/box/costume/clown
	name = "clown costume"
	icon_state = "clown"
	desc = "A box that contains a clown costume."
	spawn_contents = list(/obj/item/clothing/mask/clown_hat,\
	/obj/item/clothing/under/misc/clown,\
	/obj/item/clothing/shoes/clown_shoes,\
	/obj/item/storage/fanny/funny,\
	/obj/item/card/id/clown,\
	/obj/item/device/pda2/clown)

/obj/item/storage/box/costume/robuddy
	name = "guardbuddy costume"
	spawn_contents = list(/obj/item/clothing/suit/robuddy)

/obj/item/storage/box/costume/bee
	name = "bee costume"
	spawn_contents = list(/obj/item/clothing/suit/bee)

/obj/item/storage/box/costume/monkey
	name = "monkey costume"
	spawn_contents = list(/obj/item/clothing/suit/monkey,\
	/obj/item/reagent_containers/food/snacks/plant/banana)

/obj/item/storage/box/costume/crap
	icon_state = "costume-crap"
	desc = "'Another great costume brought to you by Spook*Corp!'"

/obj/item/storage/box/costume/crap/waltwhite
	name = "meth scientist costume"
	spawn_contents = list(/obj/item/clothing/mask/waltwhite)

	make_my_stuff()
		..()
		var/obj/item/clothing/under/color/orange/jump = new /obj/item/clothing/under/color/orange(src)
		jump.name = "meth scientist uniform"
		jump.desc = "What? This clearly isn't a repurposed prison uniform, we promise."

/obj/item/storage/box/costume/crap/spiderman
	name = "red alien costume"

	make_my_stuff()
		..()
		var/obj/item/clothing/mask/cmask = new /obj/item/clothing/mask/spiderman(src)
		cmask.name = "red alien mask"
		cmask.desc = "The material of this mask can probably scrape off your face. 'Spook*Corp Costumes' on embedded on the side of it."

		var/obj/item/clothing/under/sunder = new /obj/item/clothing/under/gimmick/spiderman(src)
		sunder.name = "red alien suit"
		sunder.desc = "Just looking at this thing makes you feel itchy! 'Spook*Corp Costumes' is embedded on the side of it."

/obj/item/storage/box/costume/crap/wonka
	name = "victorian confectionery factory owner costume"
	spawn_contents = list(/obj/item/reagent_containers/food/snacks/candy)

	make_my_stuff()
		..()
		var/obj/item/clothing/head/chat = new /obj/item/clothing/head/that/purple(src)
		chat.name = "victorian confectionery factory owner hat"
		chat.desc = "This hat really feels like something you shouldn't be putting near your brain! 'Spook*Corp Costumes' on embedded on the side of it."

		var/obj/item/clothing/under/sunder = new /obj/item/clothing/under/suit/purple(src)
		sunder.name = "victorian confectionery factory owner suit"
		sunder.desc = "Just looking at this thing makes you feel itchy! 'Spook*Corp Costumes' is embedded on the side of it."

		var/obj/item/acane = new /obj/item/crowbar(src)
		acane.name = "cane"
		acane.desc = "Totally a cane."

/obj/item/storage/box/costume/light_borg
	name = "light cyborg costume"
	spawn_contents = list(/obj/item/clothing/suit/gimmick/light_borg)

/obj/item/storage/box/costume/utena
	name = "revolutionary costume set"
	spawn_contents = list(/obj/item/clothing/under/gimmick/utena,\
	/obj/item/clothing/under/gimmick/anthy,\
	/obj/item/clothing/shoes/utenashoes)

	make_my_stuff()
		..()
		var/obj/item/e_g_g = new /obj/item/reagent_containers/food/snacks/ingredient/egg(src)
		e_g_g.name = "e g g"
		e_g_g.desc = "Smash the world's shell!"
