//Warning! Do not animate to low alpha values unless you animate to a high non 255 value first. This breaks things for some bizzare reason.

// particle system states
#define PS_READY 1
#define PS_RUNNING 2
#define PS_FINISHED 0

// --------------------------------------------------------------------------------------------------------------------------------------
// Base object used for particles

/obj/particle
	name = ""
	desc = ""
	mouse_opacity = 0
	anchored = 1
	density = 0
	opacity = 0
	layer = EFFECTS_LAYER_BASE
	animate_movement = NO_STEPS //Stop shifting around recycled particles.
	var/atom/target = null // target location for directional particles
	var/override_state = null

// --------------------------------------------------------------------------------------------------------------------------------------
// Master particle datum, handles creating and recycling particles and particle systems

var/datum/particleMaster/particleMaster = new

/datum/particleMaster
	var/list/particleTypes = null
	var/list/particleSystems = null

	New()
		particleTypes = list()
		particleSystems = list()
		for (var/ptype in typesof(/datum/particleType) - /datum/particleType)
			var/datum/particleType/typeDatum = new ptype()
			particleTypes[typeDatum.name] = typeDatum

	proc/SpawnSystem(var/datum/particleSystem/system)
		if (!istype(system))
			return

		particleSystems += system

		return system

	// check if a particular location has a particle system running there
	proc/CheckSystemExists(var/systemType, var/atom/location)
		for (var/datum/particleSystem/system in particleSystems)
			if (system.type == systemType && system.location == location)
				return 1
		return 0

	// kill a particle system in progress
	proc/RemoveSystem(var/systemType, var/atom/location)
		for (var/datum/particleSystem/system in particleSystems)
			if (system.type == systemType && system.location == location)
				system.Die()
				particleSystems -= system

	// Called by the particle process loop in the game controller
	// Runs every effect that's ready to go and cleans up anything that's finished or in an invalid location
	proc/Tick()
		// Set background tells byond that it can sleep(0) this proc automatically within loops to get other stuff running.
		set background = 1
		for (var/datum/particleSystem/system in particleSystems)
			if (!istype(system.location))
				system.state = PS_FINISHED
				particleSystems -= system
				continue

			switch(system.state)
				if (PS_FINISHED)
					particleSystems -= system
					continue

				if (PS_READY)
					// This is the only place a spawn is remotely helpful
					// Adding a lot of extra spawn(0) calls can really shit up the scheduler
					spawn(0)
						system.Run()
					continue

	//Spawns specified particle. If type can be recycled, do that - else create new. After time is over, move particle to recycling to avoid del and new calls.
	proc/SpawnParticle(var/atom/location, var/particleTypeName = null, var/particleTime = null, var/particleColor = null, var/atom/target = null, var/particleSprite = null) //This should be the only thing you access from the outside.
		var/datum/particleType/pType = particleTypes[particleTypeName]

		if (istype(pType))
			var/obj/particle/p = unpool(/obj/particle)
			p.loc = get_turf(location)
			p.color = particleColor
			if (particleSprite)
				p.override_state = particleSprite
			if (target)
				p.target = get_turf(target)
			pType.Apply(p)

			spawn(particleTime)
				if (p)
					pType.Reset(p)
					pool(p)

			return p
		else
			return 0

// --------------------------------------------------------------------------------------------------------------------------------------
// These datums are used by the particle master datum to apply the various effects to the base particle object before use.

/datum/particleType
	var/name = null
	var/icon = null
	var/icon_state = null

	// ugly but fast
	var/matrix/first = null
	var/matrix/second = null
	var/matrix/third = null

	var/static/matrix/reset_matrix = matrix()

	New()
		MatrixInit()

	proc/MatrixInit()
		return

	proc/Apply(var/obj/particle/par)
		if (istype(par))
			par.icon = icon
			par.icon_state = par.override_state ? par.override_state : icon_state
			return 1
		return 0

	proc/Reset(var/obj/particle/par)
		if (istype(par))
			par.alpha = 255
			par.blend_mode = 0
			par.color = null
			par.pixel_x = 0
			par.pixel_y = 0
			par.transform = null
			par.override_state = null
			animate(par)
			return 1
		return 0

/datum/particleType/fireTest
	name = "fireTest"
	icon = 'icons/effects/effects.dmi'
	icon_state = "fpart"

	MatrixInit()
		first = matrix()
		second = matrix()

	Apply(var/obj/particle/par)
		if (..())
			par.blend_mode = BLEND_ADD
			par.alpha = 0
			par.pixel_x = rand (-3, 3)
			par.pixel_y = -16 + rand(-3,3)

			first.Turn(rand(-90, 90))
			second.Turn(rand(-90, 90))

			var/x_float = rand(-5, 5)

			animate(par, time = 10, transform = first, pixel_y = 0, pixel_x = x_float, alpha = 255)
			animate(transform = second, time = 10, pixel_y = 16, pixel_x = round(x_float / 2), alpha = 0)

			first.Reset()

/datum/particleType/exppart
	name = "exppart"
	icon = 'icons/effects/64x64.dmi'
	icon_state = "exppart"

	MatrixInit()
		first = matrix()

	Apply(var/obj/particle/par)
		if(..())
			par.blend_mode = BLEND_ADD
			par.Turn(rand(90, 90))

			first.Turn(rand(90, 90))
			first.Scale(1.5, 1.5)

			animate(par, transform = first, time = 20, pixel_y = rand(-64, 64), pixel_x = rand(-64, 64), easing = CUBIC_EASING|EASE_IN, alpha = 0)

			MatrixInit()

/datum/particleType/mechpart
	name = "mechpart"
	icon = 'icons/effects/particles.dmi'
	icon_state = "2x2outline"

	Apply(var/obj/particle/par)
		if(..())
			if (!par || !par.target) return //Wire: Fix for Cannot read null.x
			var/move_x = (par.target.x - par.x) * 32
			var/move_y = (par.target.y - par.y) * 32

			animate(par, time = get_dist(par, par.target) * 5, pixel_y = move_y,  pixel_x = move_x , color = "#0000FF", easing = LINEAR_EASING)

/datum/particleType/elecpart
	name = "elecpart"
	icon = 'icons/effects/particles.dmi'
	icon_state = "electro"

	MatrixInit()
		first = matrix()
		second = matrix()
		third = matrix()

	Apply(var/obj/particle/par)
		if(..())
			par.blend_mode = BLEND_ADD
			par.pixel_x += rand(-3,3)
			par.pixel_y += rand(-3,3)

			first.Turn(rand(-90, 90))
			first.Scale(0.1,0.1)
			par.transform = first

			second = matrix(first, 20, MATRIX_SCALE)

			third.Scale(0.1,0.1)
			third.Turn(rand(-90, 90))

			var/move_x = rand(-96, 96)
			var/move_y = rand(-96, 96)

			animate(par,transform = second, time = 5, alpha = 100)
			animate(transform = third, time = 10, pixel_y = move_y, pixel_x = move_x, alpha = 1)

			MatrixInit()

/datum/particleType/elecpart_green
	name = "elecpart_green"

	MatrixInit()
		first = matrix()
		second = matrix()
		third = matrix()

	Apply(var/obj/particle/par)
		if(..())
			par.blend_mode = BLEND_ADD
			par.pixel_x += rand(-10,10)
			par.pixel_y += rand(-10,10)

			var/rot = rand(-90, 90)
			first.Turn(rot)
			first.Scale(0.1,0.1)
			par.transform = first

			second = matrix(first, 10, MATRIX_SCALE)

			third = matrix(matrix(first, rot, MATRIX_ROTATE), 0.1, MATRIX_SCALE)

			animate(par,transform = second, time = 5, alpha = 245)
			animate(transform = third, time = 5, alpha = 50)

			MatrixInit()

/datum/particleType/glitter
	name = "glitter"
	icon = 'icons/effects/glitter.dmi'

	MatrixInit()
		first = matrix()
		second = matrix()
		third = matrix()

	Apply(var/obj/particle/par)
		if(..())
			par.pixel_x += rand(-5,5)
			par.pixel_y += rand(-5,5)
			par.color = random_saturated_hex_color(1)//rgb(rand(25, 255),rand(25, 255),rand(25, 255))
			par.icon_state = "glitter[rand(1,10)]"
			var/rot = rand(-45, 45)

			first.Turn(rot)
			first.Scale(0.1,0.1)
			par.transform = first

			second = matrix(first, 12, MATRIX_SCALE)

			third = matrix(matrix(second, rot, MATRIX_ROTATE), 0.1, MATRIX_SCALE)

			animate(par,transform = second, time = 10, alpha = 200)
			animate(transform = third, time = 10, alpha = 50)

			MatrixInit()

/datum/particleType/sparkle
	name = "sparkle"
	icon = 'icons/effects/particles.dmi'
	icon_state = "sparkle"

	MatrixInit()
		first = matrix()
		second = matrix()
		third = matrix()

	Apply(var/obj/particle/par)
		if(..())
			par.pixel_x += rand(-10,10)
			par.pixel_y += rand(-10,10)

			var/rot = rand(-90, 90)
			first.Turn(rot)
			first.Scale(0.1,0.1)
			par.transform = first

			second = matrix(first, 10, MATRIX_SCALE)
			second.Scale(1.1,1.1)

			third = matrix(matrix(first, 0.1, MATRIX_SCALE), rot, MATRIX_ROTATE)

			animate(par,transform = second, time = 5, alpha = 245)
			animate(transform = third, time = 5, alpha = 50)

			MatrixInit()

/datum/particleType/tpbeam
	name = "tpbeam"
	icon = 'icons/effects/particles.dmi'
	icon_state = "tpbeam"

	MatrixInit()
		first = matrix(1, 0.1, MATRIX_SCALE)
		second = matrix()

	Apply(var/obj/particle/par)
		if(..())
			par.pixel_x += rand (-16, 16)
			par.pixel_y = -16
			par.alpha = 0

			par.transform = first

			animate(par, time = 3, alpha = 255)
			animate(transform = second, time = 15 + rand(0,6), pixel_y = 32, alpha = 0)

			MatrixInit()

/datum/particleType/swoosh
	name = "swoosh"
	icon = 'icons/effects/particles.dmi'
	icon_state = "swoosh"

	MatrixInit()
		first = matrix()
		second = matrix()

	Apply(var/obj/particle/par)
		if(..())
			par.pixel_x += rand(-14,14)
			par.pixel_y = -16
			par.alpha = 200

			var/xflip = rand(100) > 50 ? -1 : 1
			first.Scale(xflip, 0.01)
			par.transform = first

			second.Scale(xflip, 1)

			animate(par,transform = second, time = 40, alpha = 0, pixel_y = 64)

			MatrixInit()

/datum/particleType/fireworks
	name = "fireworks"
	icon = 'icons/effects/effects.dmi'
	icon_state = "wpart"

	MatrixInit()
		first = matrix()
		second = matrix()
		third = matrix()

	Apply(var/obj/particle/par)
		if(..())
			par.blend_mode = BLEND_ADD
			par.color = rgb(rand(0, 255),rand(0, 255),rand(0, 255))

			first.Turn(rand(-180, 180))
			second.Turn(rand(-90, 90))
			second.Scale(0.5,0.5)
			third.Turn(rand(-90, 90))

			if(!istype(par)) return
			animate(par, time = 10, transform = first, pixel_y = 96, alpha = 250)
			animate(transform = second, time = 10, pixel_y = 96 + rand(-32, 32), pixel_x = rand(-32, 32) + par.pixel_x, easing = SINE_EASING, alpha = 200)
			animate(transform = third, time = 7, pixel_y = 0, easing = LINEAR_EASING|EASE_OUT, alpha = 0)

			MatrixInit()

/datum/particleType/confetti
	name = "confetti"
	icon = 'icons/effects/effects.dmi'
	icon_state = "wpart"

	MatrixInit()
		first = matrix()
		second = matrix()

	Apply(var/obj/particle/par)
		if(..())
			par.blend_mode = BLEND_ADD
			var/r = 255
			var/g = 255
			var/b = 255
			switch (rand(1, 3))
				if (1)
					r = rand(0, 150)
				if (2)
					g = rand(0, 150)
				if (3)
					b = rand(0, 150)
			par.color = rgb(r, g, b)

			first.Turn(rand(-90, 90))
			first.Scale(0.5,0.5)
			second.Turn(rand(-90, 90))

			if(!istype(par)) return
			animate(par, transform = first, time = 4, pixel_y = rand(-32, 32) + par.pixel_y, pixel_x = rand(-32, 32) + par.pixel_x, easing = LINEAR_EASING)
			animate(transform = second, time = 5, alpha = 0, pixel_y = par.pixel_y - 5, easing = LINEAR_EASING|EASE_OUT)

			MatrixInit()

/datum/particleType/gravaccel
	name = "gravaccel"
	icon = 'icons/effects/effects.dmi'
	icon_state = "wpart"

	MatrixInit()
		first = matrix(0.25, MATRIX_SCALE)
		second = matrix(0.125, MATRIX_SCALE)
		third = matrix(0.1, MATRIX_SCALE)

	Apply(var/obj/particle/par)
		if(..())
			par.blend_mode = BLEND_ADD
			par.pixel_x = rand(-14, 14)
			par.pixel_y = rand(-14, 14)

			par.transform = first

			var/move_x = ((par.target.x-par.loc.x) * 2) * 32 + rand(-14, 14)
			var/move_y = ((par.target.y-par.loc.y) * 2) * 32 + rand(-14, 14)

			animate(par,transform = second, time = 25, pixel_y = move_y,  pixel_x = move_x , easing = SINE_EASING)
			animate(transform = third, time = 5, easing = LINEAR_EASING|EASE_OUT)

/datum/particleType/stink
	name = "stink"
	icon = 'icons/effects/effects.dmi'
	icon_state = "stink"

	MatrixInit()
		first = matrix(1, 0, MATRIX_SCALE)
		second = matrix()

	Apply(var/obj/particle/par)
		if(..())
			par.alpha = 0
			par.pixel_x += rand(-5,5)
			par.pixel_y = -16

			par.transform = first

			animate(par, time = 10, transform = second, pixel_y = 0, alpha = 150)
			animate(time = 10, pixel_y = 16, alpha = 0)

/datum/particleType/barrelSmoke
	name = "barrelSmoke"
	icon = 'icons/effects/64x64.dmi'
	icon_state = "smoke"

	MatrixInit()
		first = matrix()
		second = matrix()

	Apply(var/obj/particle/par)
		if(..())
			par.pixel_x += -16
			par.pixel_y += -5
			par.color = "#222222"

			first.Turn(rand(-90, 90))
			first.Scale(0.1, 0.1)
			par.transform = first

			second = first
			second.Scale(5,5)
			second.Turn(rand(-90, 90))

			animate(par,transform = second, time = 5, alpha = 90)
			animate(transform = third, time = 20, pixel_y = 75, alpha = 1)

			MatrixInit()

/datum/particleType/cruiserSmoke
	name = "cruiserSmoke"
	icon = 'icons/effects/64x64.dmi'
	icon_state = "smoke"

	MatrixInit()
		first = matrix()
		second = matrix()

	Apply(var/obj/particle/par)
		if(..())
			par.pixel_x += rand(0, 96)
			par.pixel_y += rand(0, 96)
			par.color = "#777777"

			first.Turn(rand(-90, 90))
			first.Scale(0.1, 0.1)
			par.transform = first

			second = first
			second.Scale(5,5)
			second.Turn(rand(-90, 90))

			animate(par,transform = second, time = 5, color="#dddddd", alpha = 120)
			animate(transform = third, time = 20, pixel_y = par.pixel_y+32,  alpha = 1)

			MatrixInit()

/datum/particleType/areaSmoke
	name = "areaSmoke"
	icon = 'icons/effects/64x64.dmi'
	icon_state = "smoke"

	MatrixInit()
		first = matrix()
		second = matrix()
		third = matrix()

	Apply(var/obj/particle/par)
		if(..())
			par.pixel_x += -16 + rand(-112,122)
			par.pixel_y += -16 + rand(-112,122)

			first.Turn(rand(-90, 90))
			first.Scale(0.1, 0.1)
			par.transform = first

			second = first
			second.Scale(5,5)

			third.Scale(2,2)
			third.Turn(rand(-90, 90))

			animate(par,transform = second, time = 5, alpha = 250)
			animate(transform = third, time = 20, alpha = 1)

			MatrixInit()

/datum/particleType/chemSpray
	name = "chemSpray"
	icon = 'icons/effects/64x64.dmi'
	icon_state = "smoke"

	MatrixInit()
		first = matrix(0.1, MATRIX_SCALE)
		second = matrix(0.3, MATRIX_SCALE)
		third = matrix(0.6, MATRIX_SCALE)


	Apply(var/obj/particle/par)
		if(..())
			par.alpha = 50

			par.transform = first

			var/move_x
			var/move_y

			if (!par.loc)
				return

			if (par.target)
				move_x = (par.target.x-par.loc.x)*32 + rand(-32, 0)
				move_y = (par.target.y-par.loc.y)*32 + rand(-32, 0)
			else
				move_x = rand(-64, 64)
				move_y = rand(-64, 64)

			animate(par,transform = second, time = 10, pixel_y = move_y, pixel_x = move_x, alpha = 25)
			animate(transform = third, time = 5, alpha = 1)

/datum/particleType/fireSpray
	name = "fireSpray"
	icon = 'icons/effects/64x64.dmi'
	icon_state = "smoke"

	MatrixInit()
		first = matrix(0.1, MATRIX_SCALE)
		second = matrix(0.3, MATRIX_SCALE)
		third = matrix(0.6, MATRIX_SCALE)

	Apply(var/obj/particle/par)
		if(..())
			par.color = "#FF0000"
			par.alpha = 50

			par.transform = first

			var/move_x
			var/move_y

			if (!par.loc)
				return

			if (par.target)
				move_x = (par.target.x-par.loc.x)*32 + rand(-32, 0)
				move_y = (par.target.y-par.loc.y)*32 + rand(-32, 0)
			else
				move_x = rand(-64, 64)
				move_y = rand(-64, 64)

			animate(par,transform = second, time = 20, color = "#FFFF00", pixel_y = move_y, pixel_x = move_x, alpha = 25)
			animate(transform = third, time = 10, color="#FFFFFF", alpha = 1)

/datum/particleSystem/firespray
	var/runLength = 10

	New(var/atom/location, var/atom/destination)
		..(location, "fireSpray", 10, null, destination)

	Run()
		if (state != PS_RUNNING && ..())
			for(var/x=0, x < runLength, x++)
				for(var/i=0, i<rand(5,14), i++)
					SpawnParticle()
				sleep(1)
			Die()

/datum/particleType/localSmokeSmall
	name = "localSmokeSmall"
	icon = 'icons/effects/64x64.dmi'
	icon_state = "smoke"

	MatrixInit()
		first = matrix()
		second = matrix()
		third = matrix()

	Apply(var/obj/particle/par)
		if(..())
			par.pixel_x += -16 + rand(-3,3)
			par.pixel_y += -16 + rand(-3,3)

			first = turn(first, rand(-90, 90))
			first.Scale(0.05, 0.05)
			par.transform = first

			second = first // assignment operator modifies an existing matrix
			second.Scale(2.5,2.5)

			third.Scale(1,1)
			third = turn(third, rand(-90, 90))

			animate(par,transform = second, time = 5, alpha = 200)
			animate(transform = third, time = 20, pixel_y = rand(-48, 48), pixel_x = rand(-48, 48), alpha = 1)

			MatrixInit()

/datum/particleType/localSmoke
	name = "localSmoke"
	icon = 'icons/effects/64x64.dmi'
	icon_state = "smoke"

	MatrixInit()
		first = matrix()
		second = matrix()
		third = matrix()

	Apply(var/obj/particle/par)
		if(..())
			par.pixel_x += -16 + rand(-3,3)
			par.pixel_y += -16 + rand(-3,3)

			first = turn(first, rand(-90, 90))
			first.Scale(0.1, 0.1)
			par.transform = first

			second = first // assignment operator modifies an existing matrix
			second.Scale(5,5)

			third.Scale(2,2)
			third = turn(third, rand(-90, 90))

			animate(par,transform = second, time = 5, alpha = 200)
			animate(transform = third, time = 20, pixel_y = rand(-96, 96), pixel_x = rand(-96, 96), alpha = 1)

			MatrixInit()

/datum/particleType/radevent_warning
	name = "radevent_warning"
	icon = 'icons/effects/particles.dmi'
	icon_state = "8x8circle"

	MatrixInit()
		first = matrix()

	Apply(var/obj/particle/par)
		if(..())
			par.alpha = 250
			par.color = "#FF00FF"
			par.blend_mode = BLEND_SUBTRACT

			first = turn(first, rand(-360,360))
			first.Scale(rand(4,6))

			animate(par, transform = first, time = 50, alpha = 1, pixel_x = rand(-8,8), pixel_y = rand(-8,8), easing = LINEAR_EASING)

			first.Reset()

/datum/particleType/radevent_pulse
	name = "radevent_warning"
	icon = 'icons/effects/particles.dmi'
	icon_state = "8x8circle"

	MatrixInit()
		first = matrix(50, MATRIX_SCALE)

	Apply(var/obj/particle/par)
		if(..())
			par.alpha = 250
			par.color = "#00AA00"
			par.blend_mode = BLEND_ADD

			animate(par, transform = first, time = 7, alpha = 1, easing = LINEAR_EASING)

/datum/particleType/bhole_static
	name = "bhole_static"
	icon_state = "2x2square"

	Apply(var/obj/particle/par)
		if(..())
			par.blend_mode = BLEND_MULTIPLY
			par.alpha = 255
			par.color = "#7E52C4"
			par.pixel_x = rand(-128,128)
			par.pixel_y = rand(-128,128)

			animate(par, time = 100, alpha = 250, pixel_y = par.pixel_y + rand(64,256), easing = LINEAR_EASING)
			animate(time = 4, pixel_y = par.pixel_y + rand(64,256) + 4, alpha = 200,easing = LINEAR_EASING)
			animate(time = 4, pixel_y = par.pixel_y + rand(64,256) + 4, alpha = 1,easing = LINEAR_EASING)

/datum/particleType/soundwave
	name = "soundwave"
	icon = 'icons/effects/particles.dmi'
	icon_state = "8x8ring"

	MatrixInit()
		first = matrix()

	Apply(var/obj/particle/par)
		if(..())
			par.alpha = 255
			par.color = "#FFFFFF"

			first.Scale(rand(5,10))

			animate(par, transform = first, time = 6, alpha = 1, easing = LINEAR_EASING)

			first.Reset()

/datum/particleType/tele_wand
	name = "tele_wand"
	icon = 'icons/effects/particles.dmi'
	icon_state = "8x8circle"

	MatrixInit()
		first = matrix()

	Apply(var/obj/particle/par)
		if(..())
			par.alpha = 255
			par.pixel_x = rand(-16,16)
			par.pixel_y = rand(-16,16)

			first = turn(first, rand(-360,360))
			first.Scale(rand(0.25,0.75))

			animate(par, transform = first, time = 6, pixel_y = par.pixel_y + rand(8,16), alpha = 1, easing = LINEAR_EASING)

			first.Reset()

/datum/particleType/blob_attack
	name = "blob_attack"
	icon = 'icons/effects/particles.dmi'
	icon_state = "splatter1"

	MatrixInit()
		first = matrix(0.2, 0.5, MATRIX_SCALE)

	Apply(var/obj/particle/par)
		if(..())
			par.icon_state = pick("splatter1", "splatter2", "splatter3")
			par.alpha = 220
			par.pixel_x = rand(-12,12)
			par.pixel_y = rand(-12,12)

			animate(par, transform = first, pixel_y = par.pixel_y - rand(12,32), time = 20, alpha = 1, easing = SINE_EASING)

/datum/particleType/blob_heal
	name = "blob_heal"
	icon = 'icons/effects/particles.dmi'
	icon_state = "bubble"

	Apply(var/obj/particle/par)
		if(..())
			par.alpha = 220
			par.pixel_x = rand(-8,8)
			par.pixel_y = rand(-8,8)

			animate(par, pixel_x = par.pixel_x + rand(-6,6), pixel_y = par.pixel_y + rand(32,64), time = 30, alpha = 1, easing = SINE_EASING)

/datum/particleType/warp_star
	name = "warp_star"
	icon = 'icons/effects/particles.dmi'
	icon_state = "starsmall"
	var/star_direction = NORTH // the direction the stars travel to

	MatrixInit()
		first = matrix()
		second = matrix()

	Apply(var/obj/particle/par)
		if(..())
			par.dir = src.star_direction
			if (prob(40))
				par.icon_state = "starlarge"

			if (src.star_direction & NORTH|SOUTH)
				par.pixel_x += rand(-240,240)
			if (src.star_direction & EAST|WEST)
				par.pixel_y += rand(-240,240)
			//par.pixel_y += rand(-96,0)

			par.transform = first

			second = first

			animate(par,transform = second, time = 1, alpha = 255)
			switch (src.star_direction)
				if (NORTH)
					animate(transform = third, time = rand(1,25), pixel_y = 800, alpha = 25)
				if (SOUTH)
					animate(transform = third, time = rand(1,25), pixel_y = -800, alpha = 25)
				if (EAST)
					animate(transform = third, time = rand(1,25), pixel_x = 800, alpha = 25)
				if (WEST)
					animate(transform = third, time = rand(1,25), pixel_x = -800, alpha = 25)

			MatrixInit()

/datum/particleType/warp_star/warp_star_s
	name = "warp_star_s"
	star_direction = SOUTH

/datum/particleType/warp_star/warp_star_e
	name = "warp_star_e"
	star_direction = EAST

/datum/particleType/warp_star/warp_star_w
	name = "warp_star_w"
	star_direction = WEST

// --------------------------------------------------------------------------------------------------------------------------------------
// Each particle system datum represents one effect happening in the world.

/datum/particleSystem
	var/state = PS_READY
	var/particleTypeName = null
	var/particleTime = 0
	var/particleColor = null
	var/particleSprite = null
	var/atom/location = null
	var/atom/target = null

	New(var/atom/location = null, var/particleTypeName = null, var/particleTime = null, var/particleColor = null, var/atom/target = null, particleSprite = null)
		if (location && particleTypeName)
			src.location = location
			src.particleTypeName = particleTypeName
			src.particleTime = particleTime
			src.particleColor = particleColor
			src.particleSprite = particleSprite
			src.target = target
		else
			Die()

	proc/Run()
		state = PS_RUNNING
		if (!istype(location) || !particleTypeName)
			Die()
		return state != PS_FINISHED

	proc/Die()
		state = PS_FINISHED
		location = null
		target = null
		particleTypeName = null

	proc/SpawnParticle()
		. = 0
		if (location && particleTypeName)
			var/obj/particle/par = particleMaster.SpawnParticle(get_turf(location), particleTypeName, particleTime, particleColor, target, particleSprite)
			if (!istype(par))
				Die()
			else
				. = par
		else
			Die()

/datum/particleSystem/energysp
	New(var/atom/location = null)
		..(location, "elecpart_green", 15, "#00DD00")

	Run()
		if (state != PS_RUNNING && ..())
			for(var/i=0, i < 20, i++)
				SpawnParticle()
				sleep(1)
			Die()

/datum/particleSystem/sparkles
	New(var/atom/location = null)
		..(location, "sparkle", 10, "#FFFFDD")

	Run()
		if (..())
			for(var/i=0, i<3, i++)
				sleep(rand(3,6))
				SpawnParticle()
			state = PS_READY

/datum/particleSystem/glitter
	New(var/atom/location = null)
		..(location, "glitter", 10)

	Run()
		if (..())
			for(var/i=1, i<10, i++)
				sleep(rand(3,6))
				SpawnParticle()
			state = PS_READY


/datum/particleSystem/swoosh/endless
	endless = 1

/datum/particleSystem/swoosh
	var/endless = 0
	New(var/atom/location = null)
		..(location, "swoosh", 45, "#5C0E80")

	Run()
		set background = 1
		if (state != PS_RUNNING && ..())
			if (endless)
				while(endless)
					SpawnParticle()
					sleep(4)
			else
				for(var/x=0, x < 30, x++)
					SpawnParticle()
					sleep(4)
			Die()

/datum/particleSystem/elecburst
	New(var/atom/location = null)
		..(location, "elecpart", 15, "#5577CC")

	Run()
		if (state != PS_RUNNING && ..())
			for(var/x=0, x < 10, x++)
				for(var/i=0, i<rand(5,9), i++)
					SpawnParticle()
				sleep(1)
			Die()

/datum/particleSystem/localSmoke
	var/runLength = 1000

	New(var/col = "#ffffff", var/duration = 1000, var/atom/location = null)
		..(location, "localSmoke", 26, col)
		runLength = duration

	Run()
		if (state != PS_RUNNING && ..())
			for(var/x=0, x < runLength, x++)
				for(var/i=0, i<rand(2,6), i++)
					SpawnParticle()
					sleep(1)
			Die()

/datum/particleSystem/barrelSmoke
	New(var/atom/location = null)
		..(location, "barrelSmoke", 26, "#222222")

	Run()
		if (state != PS_RUNNING && ..())
			while(state != PS_FINISHED)
				SpawnParticle()
				sleep(1)
			Die()

/datum/particleSystem/cruiserSmoke
	New(var/atom/location = null)
		..(location, "cruiserSmoke", 26, "#777777")

	Run()
		if (state != PS_RUNNING && ..())
			while(state != PS_FINISHED)
				for(var/i=0, i<rand(2,6), i++)
					SpawnParticle()
					sleep(1)
				sleep(1)
			Die()

/datum/particleSystem/areaSmoke
	var/runLength = 1000

	New(var/col = "#ffffff", var/duration = 1000, var/atom/location = null)
		..(location, "areaSmoke", 26, col)
		runLength = duration

	Run()
		if (state != PS_RUNNING && ..())
			for(var/x=0, x < runLength, x++)
				for(var/i=0, i<rand(2,6), i++)
					SpawnParticle()
					sleep(1)
			Die()

/datum/particleSystem/areaSmoke/blueTest
	New(var/atom/location = null)
		..("#3333ff", 1000, location)

/datum/particleSystem/fireworks
	New(var/atom/location = null)
		..(location, "fireworks", 35)

	Run()
		if (state != PS_RUNNING && ..())
			for(var/i=0, i<rand(40,50), i++)
				SpawnParticle()
			Die()

/datum/particleSystem/confetti
	New(var/atom/location = null)
		..(location, "confetti", 35)

	Run()
		if (state != PS_RUNNING && ..())
			for(var/i=0, i<rand(40,50), i++)
				SpawnParticle()
			Die()

/datum/particleSystem/explosion
	New(var/atom/location = null)
		..(location, "exppart", 25)

	Run()
		if (state != PS_RUNNING && ..())
			for(var/i=0, i<45, i++)
				SpawnParticle()
			Die()

/datum/particleSystem/tpbeam
	New(var/atom/location = null)
		..(location, "tpbeam", 28)

	Run()
		if (state != PS_RUNNING && ..())
			for(var/x=0, x < 20, x++)
				for(var/i=0, i<rand(1,3), i++)
					SpawnParticle()
				sleep(1)
			Die()

/datum/particleSystem/fireTest
	New(var/atom/location = null)
		..(location, "fireTest", 21)

	Run()
		if (state != PS_RUNNING && ..())
			for(var/x=0, x < 1000, x++)
				for(var/i=0, i<rand(2,10), i++)
					SpawnParticle()
				sleep(1)
			Die()

/datum/particleSystem/stinkTest
	New(var/atom/location = null)
		..(location, "stink", 21)

	Run()
		if (..())
			SpawnParticle()
			state = PS_READY

/datum/particleSystem/radevent_warning
	New(var/atom/location = null)
		..(location, "radevent_warning", 50)

	Run()
		if (state != PS_RUNNING && ..())
			for(var/i=0, i < 20, i++)
				SpawnParticle()
				sleep(0.5)
			Die()

/datum/particleSystem/radevent_pulse
	New(var/atom/location = null)
		..(location, "radevent_pulse", 7)

	Run()
		if (state != PS_RUNNING && ..())
			for(var/i=0, i < 30, i++)
				SpawnParticle()
				sleep(0.2)
			Die()

/datum/particleSystem/bhole_warning
	New(var/atom/location = null)
		..(location, "bhole_warning", 108)

	Run()
		if (state != PS_RUNNING && ..())
			for(var/i=0, i < 100, i++)
				SpawnParticle()
				sleep(1)
			Die()

/datum/particleSystem/sonic_burst
	New(var/atom/location = null)
		..(location, "soundwave", 4)

	Run()
		if (state != PS_RUNNING && ..())
			for(var/i=0, i < rand(5,12), i++)
				SpawnParticle()
				sleep(1)
			Die()

/datum/particleSystem/tele_wand
	var/particle_sprite = null

	New(var/atom/location,var/p_sprite,var/p_color)
		..(location, "tele_wand", 6, p_color, null, p_sprite)

	Run()
		if (state != PS_RUNNING && ..())
			for(var/i=0, i < rand(5,12), i++)
				SpawnParticle()
			Die()


/datum/particleSystem/blobattack
	New(var/atom/location = null, var/color)
		..(location, "blob_attack", 70, color)

	Run()
		if (state != PS_RUNNING && ..())
			for(var/i=0, i < rand(2,5), i++)
				SpawnParticle()
				sleep(0.2)
			Die()

/datum/particleSystem/blobheal
	New(var/atom/location = null, var/color)
		..(location, "blob_heal", 60, color)

	Run()
		if (state != PS_RUNNING && ..())
			for(var/i=0, i < rand(3,4), i++)
				SpawnParticle()
				sleep(0.2)
			Die()

/datum/particleSystem/chemSmoke
	var/runLength = 100
	var/datum/reagents/copied
	var/list/affected
	var/list/banned_reagents = list("smokepowder", "thalmerite", "fluorosurfactant", "stimulants", "salt")
	var/smoke_size = 3

	New(var/atom/location = null, var/datum/reagents/source, var/duration = 100, var/size = 3)
		smoke_size = size
		var/part_id = "localSmoke"
		if (size < 3)
			part_id = "localSmokeSmall"
		..(location, part_id, 26)
		if(source)
			affected = list()
			copied = new/datum/reagents(source.maximum_volume)
			copied.inert = 1 //No reactions inside the metaphysical concept of smoke thanks.
			source.copy_to(copied, 1, 1)
			source.clear_reagents()
			for (var/banned in banned_reagents)
				copied.del_reagent("[banned]")
			particleColor = copied.get_master_color(1)
			runLength = duration
		else
			Die()

	Die()
		..()
		if (affected)
			affected.Cut()
		affected = null
		if (copied)
			copied.dispose()
		copied = null

	Run()
		if (state != PS_RUNNING && ..())
			for(var/x=0, x < runLength, x++)
				for(var/i=0, i<rand(2,6), i++)
					SpawnParticle()

				if(x % 10 == 0) //Once every 10 ticks.
					DoEffect()

				sleep(1)
				if (state == PS_FINISHED)
					return
			Die()

	proc/DoEffect()
		if (!location)
			Die()
			return

		for(var/atom/A in range(smoke_size, get_turf(location)))
			if(istype(A, /obj/particle))
				continue
			if(A in affected) continue
			affected += A
			if(!can_line(location, A, 4)) continue

			if(!istype(A,/obj/particle) && !istype(A,/obj/effects/foam))
				copied.reaction(A, TOUCH)

			if(istype(A, /mob/living))
				if(hasvar(A,"wear_mask"))
					// Added log entries (Convair880).
					logTheThing("combat", A, null, "is hit by chemical smoke [log_reagents(copied)] at [log_loc(A)].")
					if(!istype(A:wear_mask,/obj/item/clothing/mask/gas) && !(istype(A:wear_mask,/obj/item/clothing/mask/breath) && A:internal != null))
						if(hasvar(A,"reagents") && A:reagents != null)
							copied.copy_to(A:reagents, 1)
				else
					logTheThing("combat", A, null, "is hit by chemical smoke [log_reagents(copied)] at [log_loc(A)].")
					if(hasvar(A,"reagents") && A:reagents != null)
						copied.copy_to(A:reagents, 1)

/datum/particleSystem/chemspray
	var/runLength = 10
	var/datum/reagents/copied = null

	New(var/atom/location, var/atom/destination, var/datum/reagents/source)
		..(location, "chemSpray", 10, null, destination)
		copied = new/datum/reagents(source.maximum_volume)
		source.copy_to(copied)
		particleColor = copied.get_master_color(1)

	Die()
		..()
		copied.dispose()
		copied = null

	Run()
		if (state != PS_RUNNING && ..())
			for(var/x=0, x < runLength, x++)
				for(var/i=0, i<rand(2,6), i++)
					SpawnParticle()
				sleep(1)
			Die()

/datum/particleSystem/mechanic
	New(var/atom/location, var/atom/destination)
		..(location, "mechpart", get_dist(location, destination) * 5,  "#00FF00", destination)

	Run()
		if (..())
			for(var/i=0, i<10, i++)
				SpawnParticle()
				sleep(2)
			state = PS_READY

/datum/particleSystem/gravaccel
	New(var/atom/location, var/direction)
		..(location, "gravaccel", 35, "#1155ff", get_step(location, direction))

	Run()
		if (state != PS_RUNNING && ..())
			for(var/i=0, i<30, i++)
				for(var/x=0, x<3, x++)
					SpawnParticle()
				sleep(1)
			Die()

/datum/particleSystem/warp_star
	New(var/atom/location = null, var/star_dir = null)
		..(location, "warp_star[star_dir]", 35, "#FFFFFF")

	Run()
		if (state != PS_RUNNING && ..())
			while (state != PS_FINISHED)
				SpawnParticle()
				sleep(1)
			Die()
