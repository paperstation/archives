var/const/BLOCK_LAYER = 10
mob
	Move()
		. = ..()
		if(client && .) client.UpdateViewFilter()

turf
	var/image/viewblock
	New()
		..()
		viewblock = image('screen1.dmi',src,"black",BLOCK_LAYER)

client
	var/list/ViewFilter = list()
	var/list/SeenTurfs = list()

	New()
		..()
		SeenTurfs = list()

	proc/UpdateViewFilter()
		var/Image
		var/obj/window/basic/oneway/Onewaywindow
		var/obj/thinwall/Thinwall
		var/list/newimages = list()
		var/list/mobview = view(world.view,mob) + 1
		var/list/onewaylist = list()
		var/list/thinwalllist = list()

		for(Onewaywindow in mobview)
			if(Onewaywindow.dir & get_dir(Onewaywindow,mob))
				Onewaywindow.opacity = 1
				onewaylist += Onewaywindow

		for(Thinwall in mobview)
			if(Thinwall.dir & get_dir(Thinwall,mob))
				Thinwall.opacity = 1
				thinwalllist += Thinwall
			if(Thinwall.dir & get_dir(mob,Thinwall))
				Thinwall.opacity = 1
				thinwalllist += Thinwall
			if(perspective == Thinwall.loc)
				for(var/turf/virtualtwall in get_step(Thinwall,Thinwall.dir))
					virtualtwall.opacity = 1
					thinwalllist += virtualtwall

		if(onewaylist.len)
			var/list/List = mobview - view(world.view,mob)
			for(var/turf/T in List)
				if(!istext(T.viewblock))
					src << T.viewblock
					newimages += T.viewblock

			for(Onewaywindow in onewaylist)
				Onewaywindow.opacity = 0

		if(thinwalllist.len)
			var/list/List = mobview - view(world.view,mob)
			for(var/turf/T in List)
				if(!istext(T.viewblock))
					src << T.viewblock
					newimages += T.viewblock

			for(Thinwall in thinwalllist)
				Thinwall.opacity = 0

		for(Image in ViewFilter-newimages)
			images -= Image
		ViewFilter = newimages

