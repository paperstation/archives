/*
CONTAINS:
TOILET

*/
/obj/item/storage/toilet
	name = "toilet"
	w_class = 4.0
	anchored = 1.0
	density = 0.0
	mats = 5
	var/status = 0.0
	var/clogged = 0.0
	anchored = 1.0
	icon = 'icons/obj/objects.dmi'
	icon_state = "toilet"
	rand_pos = 0

/obj/item/storage/toilet/attackby(obj/item/W as obj, mob/user as mob)

	if (src.contents.len >= 7)
		boutput(user, "The toilet is clogged!")
		return
	if (istype(W, /obj/item/storage/))
		return
	if (istype(W, /obj/item/grab))
		playsound(src.loc, "sound/effects/slosh.ogg", 50, 1)
		user.visible_message("<span style=\"color:blue\">[user] gives [W:affecting] a swirlie!</span>", "<span style=\"color:blue\">You give [W:affecting] a swirlie. It's like Middle School all over again!</span>")
		return

	return ..()

/obj/item/storage/toilet/MouseDrop(atom/over_object, src_location, over_location)
	if (usr && over_object == usr && in_range(src, usr) && iscarbon(usr) && !usr.stat)
		usr.visible_message("<span style=\"color:red\">[usr] [pick("shoves", "sticks", "stuffs")] [his_or_her(usr)] hand into [src]!</span>")
		playsound(src.loc, "sound/effects/slosh.ogg", 50, 1)
	..()

/obj/item/storage/toilet/MouseDrop_T(mob/M as mob, mob/user as mob)
	if (!ticker)
		boutput(user, "You can't help relieve anyone before the game starts.")
		return
	if ((!( istype(M, /mob) ) || get_dist(src, user) > 1 || M.loc != src.loc || user.restrained() || usr.stat))
		return
	if (M == usr)
		user.visible_message("<span style=\"color:blue\">[user] sits on the toilet.</span>", "<span style=\"color:blue\">You sit on the toilet.</span>")
	else
		user.visible_message("<span style=\"color:blue\">[M] is seated on the toilet by [user]!</span>")
	M.anchored = 1
	M.buckled = src
	M.set_loc(src.loc)
	src.add_fingerprint(user)
	return

/obj/item/storage/toilet/attack_hand(mob/user as mob)
	for(var/mob/M in src.loc)
		if (M.buckled)
			if (M != user)
				user.visible_message("<span style=\"color:blue\">[M] is zipped up by [user]. That's... that's honestly pretty creepy.</span>")
			else
				user.visible_message("<span style=\"color:blue\">[M] zips up.</span>", "<span style=\"color:blue\">You zip up.</span>")
//			boutput(world, "[M] is no longer buckled to [src]")
			M.anchored = 0
			M.buckled = null
			src.add_fingerprint(user)
	if((src.clogged < 1) || (src.contents.len < 7) || (user.loc != src.loc))
		user.visible_message("<span style=\"color:blue\">[user] flushes the toilet.</span>", "<span style=\"color:blue\">You flush the toilet.</span>")
		src.clogged = 0
		src.contents.len = 0
	else if((src.clogged >= 1) || (src.contents.len >= 7) || (user.buckled != src.loc))
		src.visible_message("<span style=\"color:blue\">The toilet is clogged!</span>")

/obj/item/storage/toilet/random
	New()
		..()
		if (prob(1))
			var/something = pick(trinket_safelist)
			if (ispath(something))
				new something(src)
