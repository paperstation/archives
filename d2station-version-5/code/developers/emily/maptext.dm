/*
	Maptext Demo/Library created by Albro1 on 12APRIL2012.

	This is more of a demo than a library, as it does not contain very much.  These may be helpful to some, however, so I am setting
		it up as a library for those who wish to use it.

	I did not do very much commenting in this, but I hope my explanation as well as the simplicity of this will overcome that.

	I give credit to Kaiochao for the text_obj.  This originated with his code, but I redid the New() proc to suit my needs, and added more things.

	The key thing here is, obviously, text_obj.  It's fairly simple.  Don't bother referencing it with a variable unless you need to, all you need is this:

	new /text_obj(text, place_at, show_to)

	This is another reason this is more of a demo than a library; it does a specific thing.  This "library" creates a label above atom X and shows it to mob Y.

	In all reality, unless you are using the text_obj for some other reason, you don't ever need to call it's new() proc yourself.
		Just call:
			place_at.maptext_CreateText(show_to)

		I hope that is labeled enough for you to understand what it does.

	You shouldn't have to worry about any clashing procs should you include this as a library.  I used the "maptext_" naming convention on all of these.
*/





atom/var/list/maptext_Screen = list()

image/var/maptext_TextName

text_obj
	parent_type = /obj
	icon = null
	New(var/text, atom/movable/place_at, mob/show_to, width = 192, height = 96, px = 0, py = 0, lyr = FLY_LAYER)
		if(!text) text = place_at.name
		maptext = text
		maptext_width = width
		maptext_height = height
		pixel_x = px
		pixel_y = py
		layer = lyr
		var/image/s = image('speechbubble.dmi', place_at)
		s.pixel_x = 64
		s.pixel_y = 64
		var/image/i = image(src, place_at)
		i.maptext_TextName = text
		mouse_opacity = 1
		s.mouse_opacity = 1
		show_to.maptext_Screen += s
		show_to.maptext_Screen += i
	//	world << "appears"
		show_to.maptext_UpdateScreen()
		sleep(40)
		show_to.maptext_Screen -= s
		show_to.maptext_Screen -= i
		//world << "disappears"
		show_to.maptext_UpdateScreen()
		del src

mob/proc/maptext_UpdateScreen()
	for(var/i in client.images)
		client.images -= i

	for(var/v in maptext_Screen)
//		v.mouse_opacity = 0
		client.images += v

atom/proc
	maptext_CreateText(atom/a)
		var/mob/m
		if(ismob(a) && a:client)
			m = a
			new /text_obj(name, src, m, 96, 96, 0, 32)

	maptext_DeleteText(atom/a)
		var/mob/m
		if(ismob(a) && a:client)
			m = a
			for(var/image/i in m.maptext_Screen)
				if(i.maptext_TextName == name)
					m.maptext_Screen -= i
			m.maptext_UpdateScreen()