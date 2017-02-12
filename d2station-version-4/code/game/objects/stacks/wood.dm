/*
CONTAINS:
WOOD PLANKS
*/

var/global/list/datum/stack_recipe/wood_recipes = list ( \
	new/datum/stack_recipe("table parts", /obj/item/weapon/table_parts/wood, 2), \
	new/datum/stack_recipe("hydroponics crate", /obj/crate/hydroponics, 3), \
	new/datum/stack_recipe("paper bag", /obj/item/weapon/storage/paperbag, 2), \
	new/datum/stack_recipe("paper bin", /obj/item/weapon/paper_bin, 2), \
	new/datum/stack_recipe("rolling papers", /obj/item/weapon/storage/rollingpapers, 2), \
	new/datum/stack_recipe("wooden door left west", /obj/machinery/door/window/wood/westleft, 4), \
	new/datum/stack_recipe("wooden door left east", /obj/machinery/door/window/wood/eastleft, 4), \
	new/datum/stack_recipe("wooden door left south", /obj/machinery/door/window/wood/southleft, 4), \
	new/datum/stack_recipe("wooden door left north", /obj/machinery/door/window/wood/northleft, 4), \
	new/datum/stack_recipe("wooden door right west", /obj/machinery/door/window/wood/westright, 4), \
	new/datum/stack_recipe("wooden door right east", /obj/machinery/door/window/wood/eastright, 4), \
	new/datum/stack_recipe("wooden door right south", /obj/machinery/door/window/wood/southright, 4), \
	new/datum/stack_recipe("wooden door right north", /obj/machinery/door/window/wood/northright, 4), \
	new/datum/stack_recipe("reinforced table", /obj/table/reinforced/wood, 6), \
	new/datum/stack_recipe("coffin", /obj/closet/coffin, 2), \
	new/datum/stack_recipe("wooden barricade", /obj/barricade/wooden, 4, time = 30, one_per_turf = 1, on_floor = 1),\
	)

/obj/item/stack/sheet/wood
	New(var/loc, var/amount=null)
		recipes = wood_recipes
		return ..()