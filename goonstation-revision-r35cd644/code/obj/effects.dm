/* This is an attempt to make some easily reusable "particle" type effects, to stop the code
constantly having to be rewritten. An item like the jetpack that uses the ion_trail_follow system, just has one
defined, then set up when it is created with New(). Then this same system can just be reused each time
it needs to create more trails.A beaker could have a steam_trail_follow system set up, then the steam
would spawn and follow the beaker, even if it is carried or thrown.
*/
#define TOUCH 1
#define INGEST 2

/obj/effects
	name = "effects"
	icon = 'icons/effects/effects.dmi'
	mouse_opacity = 0
	flags = TABLEPASS
	desc = null

	pooled()
		..()
		color = initial(color)
