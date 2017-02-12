/obj/item/gunparts/circuits/triple
	name = "Circuit - Triple Shot"
	desc = "Allows a custom gun to shoot three times at once"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"

/obj/item/gunparts/circuits/single
	name = "Circuit - Single shot"
	desc = "Allows a custom gun to shoot once per click"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"

/obj/item/gunparts/modules/taser
	name = "Module - Taser"
	desc = "Allows a custom gun to shoot tasers."
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"

/obj/item/gunparts/modules/lethal
	name = "Module - Lethal"
	desc = "Allows a custom gun to shoot lethal lasers."
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"

/obj/item/gunparts/modules/emp
	name = "Module - Emp"
	desc = "Allows a custom gun to shoot EMPs."
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"


/obj/item/gunparts/modules/rand
	New()
		var/modules = typesof(/obj/item/gunparts/modules/) - /obj/item/gunparts/modules/ - /obj/item/gunparts/modules/rand
		var/modulez = pick(modules)
		new modulez (src.loc)
		del(src)


/obj/item/gunparts/circuits/rand
	New()
		var/modules = typesof(/obj/item/gunparts/circuits/) - /obj/item/gunparts/circuits/ - /obj/item/gunparts/circuits/rand
		var/modulez = pick(modules)
		new modulez (src.loc)
		del(src)