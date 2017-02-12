world
	mob = /mob/new_player
	turf = /turf/space
	area = /area
	view = "12x10"
	maxx = 190
	maxy = 190
	maxz = 1
	icon_size = 64

	Topic(href, href_list[])
		world << "Received a Topic() call!"
		world << "[href]"
		for(var/a in href_list)
			world << "[a]"
		if(href_list["hello"])
			world << "Hello world!"
			return "Hello world!"
		world << "End of Topic() call."
		..()