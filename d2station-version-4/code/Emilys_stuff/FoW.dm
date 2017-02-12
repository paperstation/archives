
// File:    fog-of-war.dm
// Library: Forum_account.FogOfWar
// Author:  Forum_account
//
// Contents:
//   This file defines the objects needed to keep track of
//   a client's visiblity of each tile, the graphical display
//   to indicate this visibility, and the ability to have
//   mobs that lend sight to increase a client's visibility.

var
	FogTile/null_FogTile = new(null, null)
	list/fog_clients = list()

	const
		FOG_LAYER = MOB_LAYER + 50

client
	var
		FogClient/fog

atom
	movable
		var
			FogSight/fog_sight

// Every FogClient has a list of FogTile objects
FogTile
	var
		turf/tile
		FogClient/fog_client
		image/image

		// value can have one of three values:
		//  0 - the client cannot see this tile
		//  1 - the client has explored this tile but it's not currently in their sight
		//  2 - the tile is currently in the client's sight
		value = 0

		FogTile/c1
		FogTile/c2
		FogTile/c3

		FogTile/u1
		FogTile/u2
		FogTile/u3

	New(turf/t, FogClient/c)
		tile = t
		fog_client = c

		// for the null_FogTile global instance these vars
		// will be null, so we need to check for that
		if(t && c)

			// the default icon_state, "0000", is all black
			image = image('fog-of-war.dmi', tile, "0000", FOG_LAYER)
			image.pixel_x = -16
			image.pixel_y = -16
			fog_client.client.images += image

	proc
		init()

			// c1, c2, and c3 are the other FogTile objects whose values
			// contribute towards the icon_state of this FogTile's image.
			c1 = fog_client.fog[locate(tile.x    , tile.y - 1, tile.z)]
			c2 = fog_client.fog[locate(tile.x - 1, tile.y - 1, tile.z)]
			c3 = fog_client.fog[locate(tile.x - 1, tile.y    , tile.z)]

			// u1, u2, and u3 are the other FogTile objects whose icon
			// state depends on the value of this FogTile object.
			u1 = fog_client.fog[locate(tile.x + 1, tile.y    , tile.z)]
			u2 = fog_client.fog[locate(tile.x + 1, tile.y + 1, tile.z)]
			u3 = fog_client.fog[locate(tile.x    , tile.y + 1, tile.z)]

			// we set these vars to reference a single, global instance of
			// FogTile if they're null, this way we don't need to constantly
			// be checking if c1 is null before referencing it.
			if(!c1) c1 = null_FogTile
			if(!c2) c2 = null_FogTile
			if(!c3) c3 = null_FogTile

			if(!u1) u1 = null_FogTile
			if(!u2) u2 = null_FogTile
			if(!u3) u3 = null_FogTile

		update()

			// image will be null if this instance of FogTile is
			// the global null_FogTile instance.
			if(!image) return

			// we have to remove the image, change its icon_state, and
			// add it back for the client to see the change.
			fog_client.client.images -= image
			image.icon_state = "[c1.value][c2.value][c3.value][value]"
			fog_client.client.images += image

		// changes the visibility value for this tile
		// and triggers updates for the neighboring tiles.
		value(mob_count, has_seen)

			var/old_value = value

			if(mob_count >= 1)
				value = 2
			else if(has_seen)
				value = 1
			else
				value = 0

			// even if the mob_count changes, we only care if the
			// overall value changes. we only call update() to change
			// the icon states if the value changed.
			if(value != old_value)
				update()
				u1.update()
				u2.update()
				u3.update()
				return 1

			return 0

FogClient
	var
		// this keeps track of all tiles you've ever seen
		list/has_seen = list()

		// this keeps track of how many mobs can see each tile
		list/tiles = list()

		// this list maps turfs to FogTile objects
		list/fog = list()

		// the client this is attached to
		client/client

	New(client/c)

		if(!istype(c))
			CRASH("The first argument to the FogClient object's constructor must be a client, but you passed it '[c]' instead.")

		client = c
		fog_clients += src

	proc
		init(z = -1)

			var/list/z_levels = list()

			// figure out what z levels we're initializing
			if(z == -1)
				for(var/i = 1 to world.maxz)
					z_levels += i
			else
				z_levels += z

			// initialize each z level
			for(z in z_levels)
				for(var/x = 1 to world.maxx)
					for(var/y = 1 to world.maxy)

						var/turf/t = locate(x, y, z)

						if(!t) break

						var/FogTile/f = new(t, src)

						// we keep a list that maps turfs to FogTile objects
						fog[t] = f

			for(var/turf/t in fog)
				var/FogTile/f = fog[t]
				f.init()

		update(FogSight/fog_sight)

			// if the mob's sight isn't shared with you, we can stop
			if(fog_sight.fog_client != src)
				return

			var/list/changed = list()

			// if the mob is contributing to your sight, cancel out
			// what it currently sees.
			if(fog_sight.effect)
				for(var/turf/t in fog_sight.effect)
					tiles[t] -= 1
					changed += t

			var/list/L = fog_sight.sight()

			for(var/turf/t in L)

				changed += t
				has_seen[t] = 1

				if(isnull(tiles[t]))
					tiles[t] = 1
				else
					tiles[t] += 1

			for(var/turf/t in changed)
				var/FogTile/f = fog[t]
				var/value_changed = f.value(tiles[t], has_seen[t])

				if(value_changed)
					for(var/atom/movable/m in t)
						m.fog_update(t, src)


FogSight
	var
		// the mob this sight range is attached to
		atom/movable/mob

		// the fog client that this sight contributes visibility to,
		// eventually this will be a list of fog clients so that a
		// single mob can lend vision to multiple players.
		FogClient/fog_client

		// the "publicly accessible" radius var
		radius = 2

		// the internal radius var, this is used to detect when
		// the user modified the radius var. when radius != __radius,
		// the user changed the radius var and we update __radius
		// and update the fog of war.
		__radius = 2

		// the last position this object's mob was positioned at
		turf/last_loc

		// the tiles the mob is contributing towards
		list/effect

	// the first argument is the mob we're giving sight
	// the second argument is the client or FogClient
	// the third argument is the sight radius
	New(atom/movable/m, FogClient/fc, r = 3)

		if(istype(fc, /client))
			var/client/c = fc
			fc = c.fog

		if(!fc)
			CRASH("You need to initialize the client's fog var before creating these fog_sight objects.")

		if(!istype(m))
			CRASH("The first argument to the FogSight object's constructor must be a movable atom, but you passed it '[m]' instead.")

		if(!istype(fc))
			CRASH("The second argument to the FogSight object's constructor must be a client or FogClient, but you passed it '[fc]' instead.")

		mob = m
		fog_client = fc
		radius = r

		spawn()
			loop()

	proc
		loop()
			while(1)
				tick()

				if(!mob)
					return

				sleep(world.tick_lag)

		tick()

			var/changed = 0

			if(!mob)
				changed = 1
			else if(mob.loc != last_loc)
				changed = 1
			else if(__radius != radius)
				changed = 1

			if(changed)
				if(mob)
					last_loc = mob.loc
				__radius = radius

				fog_client.update(src)

		sight()
			var/list/L = list()

			if(!mob)
				effect = L
				return L

			for(var/turf/t in range(radius, mob))
				var/dx = (t.x - mob.x)
				var/dy = (t.y - mob.y)

				var/d = sqrt(dx * dx + dy * dy)

				if(d > radius + 0.5) continue

				L += t

			effect = L
			return L
