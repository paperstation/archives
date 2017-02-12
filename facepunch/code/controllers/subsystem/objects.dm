/datum/subsystem/objects
	name = "Objects"
	wait = 20

/datum/subsystem/objects/Initialize()
	set background = 1
	..()
	for(var/atom/movable/object in world)
		object.initialize()

/datum/subsystem/objects/fire()
	set background = 1

	var/i = 1
	while(i<=processing_objects.len)
		var/obj/Object = processing_objects[i]
		if(Object)
			Object.process()
			++i
			continue
		processing_objects.Cut(i,i+1)
