/*
CONTAINS:
SANDSTONE
DIAMOND
URANIUM
PLASMA
GOLD
SILVER
*/

//Sandstone
var/global/list/datum/stack_recipe/sandstone_recipes = list ()

/obj/item/stack/sheet/sandstone
	New(var/loc, var/amount=null)
		recipes = sandstone_recipes
		return ..()

//Diamond
var/global/list/datum/stack_recipe/diamond_recipes = list ()

/obj/item/stack/sheet/diamond
	New(var/loc, var/amount=null)
		recipes = diamond_recipes
		return ..()

//Uranium
var/global/list/datum/stack_recipe/uranium_recipes = list ()

/obj/item/stack/sheet/uranium
	New(var/loc, var/amount=null)
		recipes = uranium_recipes
		return ..()

//Plasma
var/global/list/datum/stack_recipe/plasma_recipes = list ()

/obj/item/stack/sheet/plasma
	New(var/loc, var/amount=null)
		recipes = plasma_recipes
		return ..()

//Gold
var/global/list/datum/stack_recipe/gold_recipes = list ()

/obj/item/stack/sheet/gold
	New(var/loc, var/amount=null)
		recipes = gold_recipes
		return ..()

//Silver
var/global/list/datum/stack_recipe/silver_recipes = list ()

/obj/item/stack/sheet/silver
	New(var/loc, var/amount=null)
		recipes = silver_recipes
		return ..()