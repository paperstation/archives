/*
obj/LightSource
	icon='icons/effects/lighting.dmi'
	icon_state="dither50"
	var/brightness=255 // Something I was toying with, just judges how dark the shadow is
	New()
		..() // This is just for effect, makes the grass around it lighter when it's created
		for(var/turf.G in getcircle(src,5))
			G.icon+=rgb(30,30,30)
		for(var/turf.G in getcircle(src,3))
			G.icon+=rgb(60,60,60)
		for(var/turf.G in getcircle(src,1))
			G.icon+=rgb(80,80,80)
	Del() // Same as above, but makes it darker.
		for(var/turf.G in getcircle(src,5))
			G.icon-=rgb(30,30,30)
		for(var/turf/G in getcircle(src,3))
			G.icon-=rgb(60,60,60)
		for(var/turf.G in getcircle(src,1))
			G.icon-=rgb(80,80,80)
		..()

/mob/Move()
	..() // Everytime you move, update your shadow.
	UpdateShadow()

mob/verb/Change_Icon(I as icon,Is as text)
	src.icon=I
	src.icon_state=Is
	src.UpdateShadow()

mob/verb/Create_Light()
	new/obj/LightSource(src.loc)

mob/proc/UpdateShadow()
	for(var/I in src.underlays) src.underlays -= I // First, remove all underlays.
	for(var/obj/LightSource/Light in view(src))
		var/obj/NewObj=new()
		var/BrightSubtract=Light.brightness
		var/angle = GetAngle(Light,src) // Calculate the angle from the light to you only once; less processing.
		var/thedir
		var/CheckDir=src.dir // This chunk of code messes with directions of the shadows. (So it looks 'realistic')
							 // Not entirely finished, but enough for you to get the idea.
		if(get_dir(Light,src)==EAST||get_dir(Light,src)==WEST)
			if(CheckDir==EAST||CheckDir==WEST) thedir=SOUTH
			if(CheckDir==NORTH||CheckDir==SOUTH) thedir=EAST
		NewObj.icon = icon(src.icon,src.icon_state,thedir) // Duplicate src's icon, and darken it the right amount
		NewObj.icon+=rgb(255,255,255)
		NewObj.icon-=rgb(BrightSubtract,BrightSubtract,BrightSubtract)

		var/icon/I=new(NewObj.icon)
		I.Turn(angle) // Turn the shadow in the right direction.
		NewObj.icon=I
		NewObj.pixel_x += cos(90-angle) * 16 // Displace the shadow correctly.
		NewObj.pixel_y += sin(90-angle) * 16 - 16
		src.underlays+=NewObj

proc/GetAngle(atom/Ref,atom/Target) // This is just a procedure to get the angle between two atoms.
	var/dx = ((Target.x * 32) + Target.pixel_x - 16) - ((Ref.x*32) + Ref.pixel_x - 16)
	var/dy = ((Target.y * 32) + Target.pixel_y - 16) - ((Ref.y*32) + Ref.pixel_y - 16)
	var/dev = sqrt(dx * dx + dy * dy)
	var/angle=0
	if(dev > 0)
		angle=arccos(dy / sqrt(dx * dx + dy * dy))
	var/ang = (dx>=0) ? (angle) : (360-angle)
	return ang



/*AbyssDragon.BasicMath v1.1
  written by AbyssDragon (abyssdragon@,molotov.nu)
  http://www.molotov.nu

  (used to be AbyssDragon.AbyssLibrary)

  Feel free to modify/improve/destroy/steal/use any of this code however you see fit.
  A thanks or mention in your project would be nice, but neither are required.

  This is a library of procs to do some basic math and geometrical things.
  Many of the procs in the old version of this have been invalidated since then and have been removed.
  A lot of these procs may be duplicated in other BYOND libraries/demos.  However, all of this code
  was written by me, or was adapted from C libraries/tutorials by me.
*/
var
	const//Some nice and lengthy mathematical constants.  BYOND rounds them off, but I like to have 'em handy anyway.
		pi =	3.1415926535897932384626433832795
		sqrt2 =	1.4142135623730950488016887242097	//Square root of 2
		e =		2.7182818284590452353602874713527


proc
	xrange(atom/center, range)
		var/startx = center.x - range
		var/starty = center.y - range
		var/endx = center.x + range
		var/endy = center.y + range
		if(startx < 1) startx = 1
		if(starty < 1) starty = 1
		if(endx > world.maxx) endx = world.maxx
		if(endy > world.maxy) endy=world.maxy
		var/contents[] = list()
		for(var/turf/T in block(locate(startx, starty, center.z), locate(endx, endy, center.z)))
			contents += T
			contents += T.contents
		return contents

	get_steps(atom/ref,dir,num)
		var/x
		var/turf/T=ref:loc
		if(isturf(ref))
			T=ref
		for(x=0;x<num;x++)
			ref=get_step(ref,dir)
			if(!ref)break
			T=ref
		return T

	allclear(turf/T)
		if(isturf(T))
			if(T.density) return 0
		var/mob/M
		for(M as mob|obj in T)
			if(M.density)
				return 0
		return 1

	cardinal(atom/ref)
		return (list(get_step(ref,NORTH),get_step(ref,SOUTH),get_step(ref,EAST),get_step(ref,WEST)))

	cardinal_stuff(atom/ref)
		var/turfs[]=list(get_step(ref,NORTH),get_step(ref,SOUTH),get_step(ref,EAST),get_step(ref,WEST))
		var/stuff[]=list()
		var/turf/T
		for(T in turfs)
			stuff+=T.contents
		return stuff

	midpoint(atom/M,atom/N)
		var/turf/T = locate((N.x + M.x)/2, (N.y + M.y)/2, (N.z + M.z)/2)
		return T

	distance(atom/M,atom/N)
		return sqrt((N.x-M.x)**2 + (N.y-M.y)**2)

	getring(atom/M, radius)
		var/ring[] = list()
		var/turf/T
		for(T as turf in range(radius+1,M))
			if(abs(distance(T, M)-radius) < 0.5)//The < 0.5 check is to make sure the ring is smooth
				ring += T
		return ring

	getcircle(atom/M, radius)
		var/list/circle = list()
		var/turf/T
		for(T as turf in range(radius+3,M))		//The < 0.5 check is to ensure it has the same shape as
			if(distance(T, M) < radius + 0.5) 	//a get_ring() of the same radius
				circle += T
		return circle


*/