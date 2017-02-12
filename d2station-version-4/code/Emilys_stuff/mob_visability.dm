
// File:    mob-visibility.dm
// Library: Forum_account.FogOfWar
// Author:  Forum_account
//
// Contents:
//   This file manages the creation of images to represent
//   mobs and controls when the images get displayed to
//   clients. These images are used to show or hide mobs
//   based on the visibility the client has of the tile
//   the mob is standing on.

atom
	movable
		var
			// this list maps FogClient objects to image objects
			list/fog_images

			// this list maps FogClient objects to booleans to store
			// whether or not each FogClient can see this mob.
			list/fog_visibility

		Move()
			. = ..()

			if(.)
				// we have to call fog_update when this mob moves
				for(var/FogClient/fog_client in fog_clients)
					fog_update(loc, fog_client)

		proc
			// this is called when a FogClient's _visibility of a
			// turf changes, it's responsible for updating the display
			// of this mob based on the _visibility.
			fog_update(turf/t, FogClient/fog_client)

				// if this mob hasn't been initialized...
				if(!fog_images)
					fog_images = list()
					fog_visibility = list()

					layer = TURF_LAYER - 1

				// each mob has a list of images, one image for each FogClient,
				// so check if we need to create the image for this client.
				if(!fog_images[fog_client])
					var/image/image = image(icon, src, icon_state, MOB_LAYER)
					fog_images[fog_client] = image
					fog_visibility[fog_client] = 0

				var/visible = 0

				// if the mob contributes to your sight it is always visible
				if(fog_sight)
					if(fog_sight.fog_client == fog_client)
						visible = 1

				// if didn't already decide that it's visible
				if(!visible)
					// check how many mobs can see this tile
					var/mob_count = fog_client.tiles[t]

					// if any mobs can see that tile, you can see the mob
					if(mob_count > 0)
						visible = 1

				// it's possible (it's actually quite likely) that a mob will
				// move from a visible tile to another visible tile, in that
				// case we don't need to do anything with the image - it was
				// initially being shown to the client and we want it to
				// remain shown.
				if(fog_visibility[fog_client] == visible) return

				// we keep track of the mob's _visibility to each client, that
				// way we only add or remove the image when this value changes.
				fog_visibility[fog_client] = visible

				// if you can see the mob, show its image
				if(visible)
					fog_client.client.images += fog_images[fog_client]

				// otherwise hide its image
				else
					fog_client.client.images -= fog_images[fog_client]
