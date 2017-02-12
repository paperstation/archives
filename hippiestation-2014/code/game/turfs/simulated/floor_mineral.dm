
/turf/simulated/floor/mineral
	name = "mineral floor"
	icon_state = ""
	var/last_event = 0
	var/active = null

/turf/simulated/floor/mineral/plasma
	name = "plasma floor"
	icon_state = "plasma1"
	mineral = "plasma"
	floortype = "plasma"
	floor_tile = new/obj/item/stack/tile/mineral/plasma

/turf/simulated/floor/mineral/gold
	name = "gold floor"
	icon_state = "gold1"
	mineral = "gold"
	floortype = "gold"
	floor_tile = new/obj/item/stack/tile/mineral/gold

/turf/simulated/floor/mineral/silver
	name = "silver floor"
	icon_state = "silver1"
	mineral = "silver"
	floortype = "silver"
	floor_tile = new/obj/item/stack/tile/mineral/silver

/turf/simulated/floor/mineral/bananium
	name = "bananium floor"
	icon_state = "clown1"
	mineral = "clown"
	floortype = "clown"
	floor_tile = new/obj/item/stack/tile/mineral/bananium

/turf/simulated/floor/mineral/diamond
	name = "diamond floor"
	icon_state = "diamond1"
	mineral = "diamond"
	floortype = "diamond"
	floor_tile = new/obj/item/stack/tile/mineral/diamond

/turf/simulated/floor/mineral/uranium
	name = "uranium floor"
	icon_state = "uranium1"
	mineral = "uranium"
	floortype = "uranium"
	floor_tile = new/obj/item/stack/tile/mineral/uranium