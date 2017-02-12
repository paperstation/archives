
/obj/storage/closet/syndi
	name = "floor"
	desc = "Something weird about this thing."
	icon_state = "closedf"
	icon_closed = "closedf"
	density = 0
	soundproofing = 15

	close()
		var/turf/T = get_turf(src)
		if (T)
			src.icon = T.icon
			src.icon_closed = T.icon_state
			src.desc = T.desc + " It looks odd."
		else
			src.icon = 'icons/obj/large_storage.dmi'
			src.icon_closed = "closedf"
		..()
		return

	open()
		if (src.welded)
			return
		src.icon = 'icons/obj/large_storage.dmi'
		..()
		return

	CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
		return 1

/obj/storage/closet/syndi/hidden
	anchored = 1
	New()
		..()
		var/turf/T = get_turf(src.loc)
		if (T)
			src.icon = T.icon
			src.icon_closed = T.icon_state
			src.icon_state = icon_closed
			src.name = T.name
		else
			src.icon = 'icons/obj/closet.dmi'
			src.icon_closed = "closedf"

