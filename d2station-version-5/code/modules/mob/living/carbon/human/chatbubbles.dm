/*
 sd_Text
	By: Shadowdarke (shadowdarke@hotmail.com)

*********************************************************************
 DO NOT ALTER THIS FILE!
 This file contains the implimentation of the sd_Text library. If
 alter it in any way, I will not be able to help you troubleshoot
 any problems that might arise.

 The accompanying test.dm file demonstrates how to use many of
 the sd_Text features with other programs.

 CONTACT INFORMATION:
 If you have any questions, suggestions, or problems for sd_Text
 please email me at shadowdarke@hotmail.com or post a message at
 http://shadowdarke.byond.com/forum/forum.cgi?forum=libraries
*********************************************************************

Please refer to sd_Text_Reference.html for detailed information on the
procs and datum outlined here.

LIBRARY PROCS:

sd_Text(To, Text as text, Loc, Layer = FLY_LAYER, line = 0, offset = 0, charset = 'charset.dmi')
	MapText draws text as images on map turfs.
	RETURNS:
		list of the images created

sd_OverlayText(Text as text, Loc, Layer = FLY_LAYER, line = 0, offset = 0, charset = 'charset.dmi')
	OverlayText draws text as overlays on map turfs, this allows
	everyone to see the text.

sd_WordBalloon(To = view(), Text as text, atom/Owner = usr, layer = FLY_LAYER, delay = 150, charset = 'charset.dmi', balloon = 'balloon50.dmi', rigid = 0, fixedwidth = 0, maxheight = 4)
	sd_WordBalloon creates a mobile word balloon that will move to follow
	the Owner.

sd_ImprovedWordBalloon(Text as text, atom/Owner = usr, layer = FLY_LAYER, delay = 150, charset = 'charset.dmi', balloon = 'balloon50.dmi')
	sd_WordBalloon uses the new pixel offset vars to cut down on the processor power needed to
	move Word Balloons and let you see word balloons through opaque objects!

sd_MapFrame(To, Left, Right, Top, Bottom, Z, Layer = FLY_LAYER, frame = 'balloon50.dmi')
	sd_MapFrame draws a box  as images on map turfs.
	RETURNS:
		list of the images created

sd_OverlayFrame(Left, Right, Top, Bottom, Z, Layer = FLY_LAYER, frame = 'balloon50.dmi')
	sd_OverlayFrame draws a box as overlays on map turfs, this allows
	everyone to see the box.

sd_BalloonText(Text as text, turf/Loc, delay = 150, charset = 'charset.dmi', balloon = 'balloon50.dmi')
	sd_BalloonText is an early form of sd_WordBalloon from the MapText
	library that creates immobile word balloons on turf's only. It is
	left in the library for	backwards compatability.
	sd_BalloonText combines sd_MapFrame and sd_Text to create word
	balloons visible to each mob within view().

sd_Input(atom/Client = usr,list/List,X = 1,Y = 1, width, height = 3, Selections = 1, frame = 1, Layer = FLY_LAYER, charset = 'charset.dmi', windowicon = 'window50.dmi', scrollicon = 'scrollarrows.dmi')
	sd_Input displays a list of options in a text window on the client
	screen and lets the client select one or more items from the list.
	sd_Input requires a mouse.
	RETURNS:
		If selections = 1 (default), returns the text or atom selected.
		Otherwise, sd_Input returns a list of all the selected text and/or
		atoms.

client.sd_ScreenHeight()
	This proc returns the height of client.view, no matter if view is
	numeric	or text.
	RETURNS:
		The height, in tiles, of client.view

client.sd_ScreenWidth()
	This proc returns the width of client.view, no matter if view is
	numeric	or text.
	RETURNS:
		The width, in tiles, of client.view


LIBRARY DATUM TYPE:

sd_TextWindow
	The sd_TextWindow draws and maintains a client screen box for
	displaying scrolling text and/or atoms.

	READ VARS: These vars provide information about an sd_TextWindow, but
		SHOULD NEVER BE OVERWRITTEN MANUALLY or the window may not
		function properly.

		client/Client
		X
		Y
		Layer
		height
		width
		Lines

	READ/WRITE VARS: These vars may be changed manually.
		offset
		maxlines
		highlight
		select
		wordwrap

	PROCS:
		New(atom/Client = usr,X = 1,Y = 1, width, height = 3, wordwrap = 1, scroll = 1, frame = 1, highlight = 0, maxlines = 255, Layer = FLY_LAYER, windowicon = 'window.dmi', scrollicon = 'scrollarrows.dmi')
			called when you create a new sd_TextWindow
		Update()
			Updates the window display.

		Append(Line, charset = 'charset.dmi', update = 1)
			Add a line of text or an atom to the window.

		Unframe(part as text)
			remove all or part of the window frame.


Nothing but code below this line. You don't need to worry about it
unless you are an advanced BYOND user and just curious.
**********************************************************************/

// allow library users access to the resources in this directory
#define FILE_DIR .

proc
	sd_Text(To, Text as text, Loc, Layer = FLY_LAYER, line = 0, offset = 0, charset = 'charset.dmi')
		if(!Loc || !Text) return
		if(offset > 3)
			world.log << "Invalid offset in sd_Text:\n\t\
				To:[To]   Loc:[Loc]\n\t\
				line:[line]   offset:[offset]\n\t\
				Text:[Text]"
			return
		var
			Image
			list/Images = list()
			len = lentext(Text)
			list/Locs
			obj/O = new()
			current_loc
			loc_index = 1
		if(istype(Loc,/list))
			Locs = Loc
		else if(istype(Loc,/turf))
			var/turf/Turf = Loc
			Locs = block(Turf,locate(world.maxx,Turf.y,Turf.z))
		else
			Locs = list(Loc)
		current_loc = Locs[1]
		if(len > (Locs.len * 4 - offset)) len = Locs.len * 4 - offset
		O.layer = Layer
		for(var/position = 1, position <= len,)
		// no increment here because I do it in the copytext line
			O.icon = charset
			O.pixel_x = offset * 8
			O.pixel_y = line * 16
			O.icon_state = copytext(Text, position, ++position)
			// increment position here to avoid redundant math operations
			Image = image(O,current_loc)
			Images += Image
			To << Image
			if(++offset > 3)
				offset = 0
				if(++loc_index <= Locs.len) current_loc = Locs[loc_index]
		return Images

	sd_OverlayText(Text as text, Loc, Layer = FLY_LAYER, line = 0, offset = 0, charset = 'charset.dmi')
		if(!Loc || !Text) return
		if(offset > 3)
			world.log << "Invalid offset in MapText:\n\t\
				Text:[Text]   Loc:[Loc]\n\t\
				line:[line]   offset:[offset]"
			return
		var
			len = lentext(Text)
			list/Locs
			obj/O = new()
			atom/current_loc
			loc_index = 1
		if(istype(Loc,/list))
			Locs = Loc
		else if(istype(Loc,/turf))
			var/turf/Turf = Loc
			Locs = block(Turf,locate(world.maxx,Turf.y,Turf.z))
		else
			Locs = list(Loc)
		if(!Locs.len) return
		current_loc = Locs[1]
		if(len > (Locs.len * 4 - offset)) len = Locs.len * 4 - offset
		O.layer = Layer
		for(var/position = 1, position <= len,)
		// no increment here because I do it in the copytext line
			O.icon = charset
			O.pixel_x = offset * 8
			O.pixel_y = line * 16
			O.icon_state = copytext(Text, position, ++position)
			// increment position here to avoid redundant math operations
			current_loc.overlays += O
			if(++offset > 3)
				offset = 0
				if(++loc_index <= Locs.len) current_loc = Locs[loc_index]
		return 1

	sd_MapFrame(To,Left,Right,Top,Bottom,Z, Layer = FLY_LAYER, frame = 'balloon50.dmi')
		var
			obj/O = new()
			Image
			list/Images = list()

		O.icon = frame
		O.layer = Layer
		O.icon_state = "tl"
		Image = image(O,locate(Left,Top,Z))
		To << Image
		Images += Image

		O.icon_state = "tr"
		Image = image(O,locate(Right,Top,Z))
		To << Image
		Images += Image

		O.icon_state = "bl"
		Image = image(O,locate(Left,Bottom,Z))
		To << Image
		Images += Image

		O.icon_state = "br"
		Image = image(O,locate(Right,Bottom,Z))
		To << Image
		Images += Image

		for(var/X = Left + 1, X < Right, ++X)
			O.icon_state = "tm"
			Image = image(O,locate(X,Top,Z))
			To << Image
			Images += Image

			O.icon_state = "bm"
			Image = image(O,locate(X,Bottom,Z))
			To << Image
			Images += Image

			for(var/Y = Bottom+1, Y < Top, ++Y)
				O.icon_state = "cl"
				Image = image(O,locate(Left,Y,Z))
				To << Image
				Images += Image

				O.icon_state = "cr"
				Image = image(O,locate(Right,Y,Z))
				To << Image
				Images += Image

				O.icon_state = "cm"
				Image = image(O,locate(X, Y, Z))
				To << Image
				Images += Image

		return Images


	sd_OverlayFrame(Left,Right,Top,Bottom,Z, Layer = FLY_LAYER, frame = 'balloon50.dmi')
		var
			obj/O = new()
			turf/T = locate(Left,Top,Z)

		O.icon = frame
		O.layer = Layer
		O.icon_state = "tl"
		T.overlays += O

		O.icon_state = "tr"
		T = locate(Right,Top,Z)
		T.overlays += O

		O.icon_state = "bl"
		T = locate(Left,Bottom,Z)
		T.overlays += O

		O.icon_state = "br"
		T = locate(Right,Bottom,Z)
		T.overlays += O

		for(var/X = Left + 1, X < Right, ++X)
			O.icon_state = "tm"
			T = locate(X,Top,Z)
			T.overlays += O

			O.icon_state = "bm"
			T = locate(X,Bottom,Z)
			T.overlays += O

			for(var/Y = Bottom+1, Y < Top, ++Y)
				O.icon_state = "cl"
				T = locate(Left,Y,Z)
				T.overlays += O

				O.icon_state = "cr"
				T = locate(Right,Y,Z)
				T.overlays += O

				O.icon_state = "cm"
				T = locate(X,Y,Z)
				T.overlays += O

	sd_BalloonText(Text as text, turf/Loc, delay = 150, charset = 'charset.dmi', balloon = 'balloon50.dmi')
		if(!Loc || !Text) return
		var
			Len = lentext(Text)
			width
			height
			Top
			Bottom
			Left
			Right
			Z = Loc.z
			obj/O = new()
			Image
			list/Images = list()

		// find height and width
		if(Len < 13)
			height = 0
			width = 0
		else if(Len < 21)
			height = 0
			width = 1
		else if(Len < 41)
			height = 1
			width = 1
		else if(Len < 57)
			height = 1
			width = 2
		else if(Len < 85)
			height = 2
			width = 2
		else
			height = 2
			width = 3
		// chop off excess
			if(Len > 108)
				Text = copytext(Text,1,106) + "..."
				Len = 108


		Top = Loc.y + height + 2
		if(Top > world.maxy) Top = Loc.y - 1
		Bottom = Top - height - 1

		Left = Loc.x - round((height/2),1) - 1
		if(Left < 1 ) Left = 1
		Right = Left + width + 1
		if(Right > world.maxx)
			Right = world.maxx
			Left = Right - width - 1

		// draw the balloon
		Images = sd_MapFrame(view(Loc), Left, Right, Top, Bottom, Z,, balloon)

		// draw the tail
		O.icon = balloon
		O.layer = FLY_LAYER
		if(Top > Loc.y)
			O.icon_state = "dtail"
			Image = image(O,locate(Loc.x, Bottom, Z))
			view(Loc) << Image
			spawn(delay) del(Image)
		else
			O.icon_state = "utail"
			Image = image(O,locate(Loc.x, Top, Z))
			view(Loc) << Image
			spawn(delay) del(Image)

		// draw the text
		width = 6 + 4 * width	// width in characters
		var high = 0
		var turf/Turf = locate(Left,Top,Z)
		for(var/Y = 0, Y < ((height+1)*2), Y++)
			Images += sd_Text(view(Loc),copytext(Text,Y*width+1,(Y+1)*width+1),Turf,,high,1,charset)
			high = !high
			if(high)
				Turf = locate(Left,Turf.y-1,Z)

		spawn(delay)
			for(var/I in Images)
				del(I)


	sd_WordBalloon(To = view(), Text as text, atom/Owner = usr, layer = FLY_LAYER, delay = 150, charset = 'charset.dmi', balloon = 'balloon50.dmi', rigid = 0, fixedwidth = 0, maxheight = 4)
		if(!Owner || !Text) return
		var
			Len = lentext(Text)
			width
			textwidth
			height
			Top
			Bottom
			Left
			Right
			Z = Owner.z
			obj/O = new()
			atom/movable/sd_BalloonTail/Tail = new()
			atom/movable/sd_WordBalloon/WB
			Image

		// find height and width
		if(fixedwidth)
			width = fixedwidth
			textwidth = width * 4 - 2

			for(var/lineend = 0, lineend < Len)
				var/beginline = lineend
				lineend += textwidth
				if(lineend > Len) break

				// check the char at the end of this line.
				var/char = lowertext(copytext(Text,lineend,lineend+1))
				if(((char>="a")&&(char<="z"))||((char>="0")&&(char<="9")))
					// check the next character
					char = lowertext(copytext(Text,lineend+1,lineend+2))
					if(((char>="a")&&(char<="z"))||((char>="0")&&(char<="9")))
						for(var/position = lineend, position>beginline, --position)
							char = lowertext(copytext(Text,position,position+1))
							if(((char>="a")&&(char<="z"))||((char>="0")&&(char<="9")))
								continue	// position loop

							// found a word break
							var/spaces = ""
							for(var/loop in position+1 to lineend)
								spaces += " "
							Text = copytext(Text,1, position+1) + spaces + copytext(Text,position+1)
							Len = lentext(Text)
							break	// position loop

			height = max(2, round((Len/textwidth)+0.5,1))
			if(height > maxheight)
				height = maxheight
				Len = textwidth * (height * 2 - 2)
				Text = copytext(Text,1,Len-2) + "..."

		else
			if(Len < 13)
				height = 2
				width = 2
			else if(Len < 21)
				height = 2
				width = 3
			else if(Len < 41)
				height = 3
				width = 3
			else if(Len < 57)
				height = 3
				width = 4
			else if(Len < 85)
				height = 4
				width = 4
			else
				height = 4
				width = 5
			// chop off excess
				if(Len > 108)
					Text = copytext(Text,1,106) + "..."
					Len = 108

		// calculate box position
		Top = Owner.y + height
		if(Top > world.maxy) Top = Owner.y - 1
		Bottom = Top - height + 1

		Left = Owner.x - round((width/2),1) + 1
		if(Left < 1 ) Left = 1
		Right = Left + width
		if(Right > world.maxx)
			Right = world.maxx
			Left = Right - width +1

		textwidth = 4 * width - 2	// width in characters
		O.icon = balloon
		O.layer = layer

		for(var/Y in 1 to height)
			//draw part of the balloon
			var/list/DrawList = new()	// blank the DrawList
			for(var/X in 1 to width)
				WB = new(locate(Left + X - 1, Top - Y + 1, Z))

				// O.icon  and O.layer set before the loop
				if(Y == 1)
					O.icon_state = "t"
				else if(Y == height)
					O.icon_state = "b"
				else
					O.icon_state = "c"
				if(X == 1)
					O.icon_state += "l"
				else if(X == width)
					O.icon_state += "r"
				else
					O.icon_state += "m"
				Image = image(O,WB)
				To << Image

				DrawList += WB	// add WB to the draw List

			/* Add this line of sd_WordBallons to the Tail's Balloon list
			   so the Tail can keep track of them all. */
			Tail.Balloon += DrawList

			// draw the text on DrawList
			sd_Text(To,copytext(Text,(Y-1)*2*textwidth+1,((Y-1)*2+1)*textwidth+1),DrawList,layer,0,1,charset)
			sd_Text(To,copytext(Text,((Y-1)*2-1)*textwidth+1,(Y-1)*2*textwidth+1),DrawList,layer,1,1,charset)


		// draw the tail
		if(Top > Owner.y)
			O.icon_state = "dtail"
			Tail.loc = locate(Owner.x, Bottom, Z)
		else
			O.icon_state = "utail"
			Tail.loc = locate(Owner.x, Top, Z)
			Tail.above = -1
		Tail.Image = image(O,Tail)
		To << Tail.Image
		if(!Owner.sd_BalloonTails) Owner.sd_BalloonTails = list()
		Owner.sd_BalloonTails += Tail

		Tail.height = height
		Tail.width = width
		Tail.rigid = rigid

		if(delay > 0)
			spawn(delay)
				del(Tail)
				if(!Owner.sd_BalloonTails.len) del(Owner.sd_BalloonTails)

		return Tail


	sd_ImprovedWordBalloon(Text as text, atom/Owner = usr, layer = FLY_LAYER, delay = 150, charset = 'charset.dmi', balloon = 'balloon50.dmi')
		if(!Owner || !Text) return
		var
			Len = lentext(Text)
			width = 5
			textwidth
			height = 2
			obj/O
			atom/movable/Tail = new(Owner.loc)

		// find height and width
		textwidth = width * 4 - 2

		for(var/lineend = 0, lineend < Len)
			var/beginline = lineend
			lineend += textwidth
			if(lineend > Len) break

			// check the char at the end of this line.
			var/char = lowertext(copytext(Text,lineend,lineend+1))
			if(((char>="a")&&(char<="z"))||((char>="0")&&(char<="9")))
				// check the next character
				char = lowertext(copytext(Text,lineend+1,lineend+2))
				if(((char>="a")&&(char<="z"))||((char>="0")&&(char<="9")))
					for(var/position = lineend, position>beginline, --position)
						char = lowertext(copytext(Text,position,position+1))
						if(((char>="a")&&(char<="z"))||((char>="0")&&(char<="9")))
							continue	// position loop

						// found a word break
						var/spaces = ""
						for(var/loop in position+1 to lineend)
							spaces += " "
						Text = copytext(Text,1, position+1) + spaces + copytext(Text,position+1)
						Len = lentext(Text)
						break	// position loop

		if(Len > textwidth * (height * 2 - 2))
			Len = textwidth * (height * 2 - 2)
			Text = copytext(Text,1,Len-2) + "..."
		textwidth = 4 * width - 2	// width in characters

		for(var/Y in 1 to height)
			//draw part of the balloon
			var/list/DrawList = new()	// blank the DrawList
			for(var/X in 1 to width)
				O = new()
				O.icon = balloon
				O.layer = layer

				if(Y == 1)
					O.icon_state = "t"
				else if(Y == height)
					O.icon_state = "b"
				else
					O.icon_state = "c"
				if(X == 1)
					O.icon_state += "l"
				else if(X == width)
					O.icon_state += "r"
				else
					O.icon_state += "m"

				O.pixel_x = (X-3) * 32
				O.pixel_y = (2 - Y) * 32

				DrawList += O	// add WB to the draw List

			// draw the text on DrawList
			sd_OverlayText(copytext(Text,(Y-1)*2*textwidth+1,((Y-1)*2+1)*textwidth+1),DrawList,layer,0,1,charset)
			sd_OverlayText(copytext(Text,((Y-1)*2-1)*textwidth+1,(Y-1)*2*textwidth+1),DrawList,layer,1,1,charset)

			/* Add this line of sd_WordBallons to the Tail's Balloon list
			   so the Tail can keep track of them all. */
			for(var/atom/movable/A in DrawList)
				Tail.overlays += A


		// draw the tail
		Tail.icon = balloon
		Tail.animate_movement = SYNC_STEPS
		Tail.icon_state = "dtail"
		Tail.layer = layer + 0.1
		Tail.pixel_y = 32

		if(!Owner.sd_BalloonTails) Owner.sd_BalloonTails = list()
		Owner.sd_BalloonTails += Tail

		if(delay > 0)
			spawn(delay)
				del(Tail)
				if(!Owner.sd_BalloonTails.len) del(Owner.sd_BalloonTails)

			spawn()
				while(Tail)
					Tail.loc = Owner.loc
					sleep(1)

		return Tail



	sd_Input(atom/Client = usr,list/List,X = 1,Y = 1, width, height = 3, Selections = 1, frame = 1, Layer = FLY_LAYER, charset = 'charset.dmi', windowicon = 'window50.dmi', scrollicon = 'scrollarrows.dmi')

		// see if this window needs to scroll
		var/scroll = 0
		var/list_height = List.len
		for(var/atom/A in List)
			list_height++
		if(list_height > (height*2)) scroll = 1

		// create the window
		var/sd_TextWindow/Window = new(Client, X, Y, width, height, 0, scroll, frame, 1, , Layer, windowicon, scrollicon)

		// optionally remove part of the frame
		if(istext(frame)) Window.Unframe(frame)

		// load the list into the window
		for(var/L in List)
			Window.Append(L,charset,0)

		Window.Update()

		// wait for selections to be made
		while(Window.select.len < Selections)
			sleep(1)

		// if only waiting for one selection, return it alone
		if(Selections == 1)
			// set the return value
			. = Window.Lines[text2num(Window.select[1])]
			del Window
			return .

		// assemble output list
		var/list/Output = list()
		for(var/select in Window.select)
			var/N = text2num(select)
			if(N)
				Output += Window.Lines[N]

		del Window
		return Output

atom
	// list of BalloonTails linked to this atom
	var/tmp/list/sd_BalloonTails

atom/movable
	Move()
		/* add code to atom/movable/Move() so that if the atom has
		   Word Balloons attached to it, they each move as well. */
		. = ..()
		if(.)
			for(var/atom/movable/sd_BalloonTail/Tail in sd_BalloonTails)
				Tail.sd_OwnerMoved(src)

	sd_WordBalloon	// componant of a word balloon
		density = 0
	sd_BalloonTail
	/* tail of a word balloon, used to track a word balloon and keep
	   it linked to the owning mob */
		density = 0
		var
			list/Balloon[] 	// list of sd_WordBalloons in this balloon
			above = 1	// is the tail above or below the Owner?
			height	// height (in tiles) of the balloon
			width	// width (in tiles) of the balloon
			rigid = 0	/* If 0, the tail will slide along the edge of
						   the balloon, only moving the balloon if the
						   tail moves beyond the edge.
						   If 1, the balloon moves each time the Owner
						   moves. */
			image/Image	// image on the tail

		Del()
			for(var/A in Balloon)
				del(A)
			..()

		proc/sd_OwnerMoved(atom/movable/Owner)
			var/atom/left = Balloon[1]
			// left is used to check the horizontal boundries of the balloon
			var/redraw = rigid // if redraw = 1, the balloon must be redrawn
			var/dx = Owner.x - x			// change in x position
			var/dy = (Owner.y+above) - y	// change in y position

			// check if the balloon bumped the left or right edge of the map
			if(((left.x + dx) < 1) || ((left.x + width + dx - 1) > world.maxx))
				dx = 0

			/* if the tail is not rigid and the owner is in the horizontal
			   boundries, don't change the balloon horiontally */
			if(!rigid && (Owner.x >= left.x) && (Owner.x <= (left.x + width - 1)))
				dx = 0

			// check if the balloon bumped the top or bottom of the map
			var/edge = Owner.y + (height * above)
			if((edge > world.maxy) || (edge < 1))
				above = -above
				dy += above * (height + 1) // move the balloon
				redraw = 1
				if(above == 1)
					Image.icon_state = "dtail"
				else
					Image.icon_state = "utail"

			// redraw if Owner changed coordinates
			else if((Owner.z != z) || dy || dx)
				redraw = 1

			if(redraw)
				// move every atom in the Balloon
				for(var/atom/movable/sd_WordBalloon/WB in Balloon)
					WB.loc = locate(WB.x + dx,WB.y + dy, z)

			// move the tail
			loc = locate(Owner.x,Owner.y + above, Owner.z)


	sd_WindowPiece
		name = "text window"
		mouse_opacity = 2
		var
			sd_TextWindow/Window
			// which TextWindow this peice belongs to
			line1 = 0
			/* which line of the TextWindow the top of this peice
			   coresponds to */
			line2 = 0
			/* which line of the TextWindow the bottom of this peice
			   coresponds to */
			Y	// Y position of this piece, relative to top


		MouseDown(loc,icon_x,icon_y)
			if(Window.highlight)
				/* get the leftmost piece in this line, where the
				   line data is stored */
				var/atom/movable/sd_WindowPiece/Left = Window.Pieces[Y][1]
				var/selection

				/* check if the top or bottom half was clicked
				   and select the data in that half */
				if(icon_y>16) selection = num2text(Left.line1)
				else selection = num2text(Left.line2)

				// clicked an empty slot, no selection
				if(selection == "0") return

				if(selection in Window.select)	// if already selected
					Window.select -= selection	// deselect
				else
					Window.select += selection	// select this item

				Window.Update()	// update the window display

		scrollarrow
			var
				speed = 1
				// used by scroll arrows to control scroll speed

			DblClick()
				speed = src.Window.height-1

			MouseDown()
				var/direction = 0
				switch(icon_state)
					if("up")
						icon_state = "upclick"
						direction = -1
						spawn(2) icon_state = "up"
					if("upclick")
						direction = -1
					if("down")
						icon_state = "downclick"
						direction = 1
						spawn(2) icon_state = "down"
					if("downclick")
						direction = 1
				spawn()
					var/old_offset = src.Window.offset
					src.Window.offset += direction*speed
					if(src.Window.offset > src.Window.Lines.len) src.Window.offset = src.Window.Lines.len
					if(src.Window.offset < 1) src.Window.offset = 1
					if(src.Window.offset != old_offset) src.Window.Update()
					speed = 1

		frame
			name = "window frame"
			mouse_opacity = 1

sd_TextWindow
	var
		client/Client		// client the window belongs to
		X	// screen_loc of the lower left corner
		Y
		Layer	//textwindow layer
		height
		width
		offset = 1	// offset to the top line displayed
		maxlines = 255	// maximum number of lines allowed
		highlight	// highlight lines when they are clicked?
		wordwrap = 1	// if set, lines will wordwrap
		//justify	// controls if text if left, right, or center justified
		list
			Pieces// sd_WindowPieces in the window
			Frame = list()	// frame pieces
			Lines = list()	// lines of display in the window
			Charset = list ()	// charset for coresponding line
			select = list()	// list of selected lines
			ScrollList = list()	// the scroll, made of sd_WindowPieces

	New(atom/Client = usr,X = 1,Y = 1, width, height = 3, wordwrap = 1, scroll = 1, frame = 1, highlight = 0, maxlines = 255, Layer = FLY_LAYER, windowicon = 'window.dmi', scrollicon = 'scrollarrows.dmi')
		..()

		// get the client
		if(!istype(Client,/client) && !ismob(Client))
			world.log << "Invalid client in sd_TextWindow.New(): [Client] ([Client.type])"
			return
		src.Client = Client
		if(ismob(Client)) src.Client = Client:client
		if(!src.Client) return

		// If no width, default to the client screen width
		if(!width) width = src.Client.sd_ScreenWidth()

		//copy initialization values to src
		src.X = X
		src.Y = Y
		src.height = height
		src.width = width
		src.wordwrap = wordwrap
		src.Layer = Layer
		src.highlight = highlight
		src.maxlines = maxlines

		// initialize Pieces list
		var/list/List[height][width]
		Pieces = List

		var/atom/movable/sd_WindowPiece/Piece
		for(var/V in 1 to height)
			for(var/H in 1 to width)
				Piece = new()
				Piece.Y = V
				Piece.icon = windowicon
				Piece.layer = Layer
				Piece.screen_loc = "[X + H - 1],[Y + height - V]"
				src.Client.screen += Piece
				Pieces[V][H] = Piece
				Piece.Window = src

		if(scroll)
			Piece = new/atom/movable/sd_WindowPiece/scrollarrow()
			Piece.mouse_opacity = 1
			Piece.icon = scrollicon
			Piece.layer = Layer
			Piece.icon_state = "up"
			Piece.name = "scroll up"
			Piece.screen_loc = "[X + width - 1],[Y + height - 1]"
			ScrollList += Piece
			Piece.Window = src

			Piece = new/atom/movable/sd_WindowPiece/scrollarrow()
			Piece.mouse_opacity = 1
			Piece.icon = scrollicon
			Piece.layer = Layer
			Piece.icon_state = "down"
			Piece.name = "scroll down"
			Piece.screen_loc = "[X + width - 1],[Y]"
			ScrollList += Piece
			Piece.Window = src

		if(frame)
			var/x = X - 1
			var/y = Y - 1
			if(onmap(x,y) || (frame==2))
				frame(x,y,windowicon,"bl")
			y = Y + height
			if(onmap(x,y) || (frame==2))
				frame(x,y,windowicon,"tl")
			x = X + width
			if(onmap(x,y) || (frame==2))
				frame(x,y,windowicon,"tr")
			y = Y - 1
			if(onmap(x,y) || (frame==2))
				frame(x,y,windowicon,"br")
			for(y in Y to (Y+height-1))
				x = X - 1
				if(onmap(x,y) || (frame==2))
					frame(x,y,windowicon,"cl")
				x = X+width
				if(onmap(x,y) || (frame==2))
					frame(x,y,windowicon,"cr")
			for(x in X to (X+width-1))
				y = Y - 1
				if(onmap(x,y) || (frame==2))
					frame(x,y,windowicon,"bm")
				y = Y+height
				if(onmap(x,y) || (frame==2))
					frame(x,y,windowicon,"tm")


	Del()
		for(var/V in 1 to height)
			for(var/H in 1 to width)
				var/O = Pieces[V][H]
				del(O)
		for(var/O in ScrollList + Frame)
			del(O)
		..()

	proc
		onmap(x,y)
			if(x >= 1 && x <= Client.sd_ScreenWidth() && y >= 1 && y<= Client.sd_ScreenHeight()) return 1
			else return 0

		frame(x,y,windowicon,state)
			var/atom/movable/sd_WindowPiece/frame/Piece = new()
			Piece.icon = windowicon
			Piece.layer = Layer
			Piece.icon_state = state
			Piece.screen_loc = "[x],[y]"
			Client.screen += Piece
			Piece.Window = src
			Frame += Piece

		Update()
			var/currentline = offset
			var/obj/Obj = new()
			for(var/atom/movable/I in ScrollList)
				Client.screen -= I
			var/end = 0
			for(var/V in 1 to height)
				if(currentline > Lines.len)
					currentline = 0
					end = 1
				var/list/List = list()
				for(var/H in 1 to width)
					var/atom/O = Pieces[V][H]
					O.overlays = list()
					O.icon_state = ""
					List += O

				var/atom/movable/sd_WindowPiece/Left = List[1]
				Left.line1 = currentline
				Left.line2 = 0

				if(currentline)
					if(istext(Lines[currentline]))
						sd_OverlayText(Lines[currentline], List, Layer + 0.1, 1, 0, Charset[currentline])
						currentline++
						if(currentline > Lines.len)
							currentline = 0
							end = 1
						else if(istext(Lines[currentline]))
							sd_OverlayText(Lines[currentline], List, Layer + 0.1, 0, 0, Charset[currentline])
							Left.line2 += currentline
							currentline++

					else if(istype(Lines[currentline],/atom))
						var/atom/Atom = Lines[currentline]
						Obj.icon = Atom.icon
						Obj.dir = Atom.dir
						Obj.icon_state = Atom.icon_state
						Obj.layer = Layer
						Obj.overlays = Atom.overlays
						Left.overlays += Obj
						AtomImage(Atom,Left)
						List -= Left
						sd_OverlayText(Atom.name, List, Layer + 0.1, 1, 0, Charset[currentline])
						sd_OverlayText(Atom.suffix, List, Layer + 0.1, 0, 0, Charset[currentline])
						Left.line2 = currentline
						currentline++

				else
					Left.line2 = 0
				var/state = 0
				if(num2text(Left.line1) in select) state++
				if(num2text(Left.line2) in select) state += 2
				if(state)
					for(var/atom/A in List)
						A.icon_state = num2text(state)

			if(ScrollList.len)
				if(offset > 1) Client.screen += ScrollList[1]
				if(!end)
					Client.screen += ScrollList[2]


		Append(Line, charset = 'charset.dmi', update = 1)

			// remove oldest lines if about to go over the max
			if(Lines.len >= maxlines)
				Lines -= Lines[1]
				Charset -= Charset[1]

			var/nextline
			if(wordwrap && (lentext(Line)>(width*4)))
				// copy text within window width
				nextline = copytext(Line, 1, width * 4 + 1)
				var
					lastspace
					space = 0
				do
					lastspace = space
					space = max(findtext(nextline," ",space+1,0),findtext(nextline,"-",space+1,0))
				while(space)

				if(!lastspace)	// no spaces found, just chop at width
					lastspace = width * 4
				nextline = copytext(Line, lastspace + 1)
				Line = copytext(Line, 1, lastspace + 1)

			Lines += Line
			Charset += charset

			if(nextline)
				/* append extra stuff, with no update so it only updates
				   once after they are all added */
				Append(nextline, charset, 0)

			if(update)
				offset = Lines.len - height*2 +1
				if(offset < 1) offset = 1
				for(var/V in offset to Lines.len)
					if(istype(Lines[V],/atom))
						offset+=0.5
				offset = round(offset)
				if(offset > Lines.len) offset = Lines.len
				if(offset < 1) offset = 1
				Update()

		AtomImage(atom/A, atom/movable/O)
			/* does nothing, this a is just a hook so people may further
			   transform the image of atom A when it is displayed in an
			   sd_TextWindow. O is the obj*/

		Unframe(part as text)
			for(var/atom/A in Frame)
				if(!part || (findtext(A.icon_state,part))) del A

client/proc
	sd_ScreenHeight()
		if(istext(view))
			return text2num(copytext(view,findtext(view,"x")+1,0))
		else
			return view * 2 + 1

	sd_ScreenWidth()
		if(istext(view))
			return text2num(copytext(view,1,findtext(view,"x")))
		else
			return view * 2 + 1
