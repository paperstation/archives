/mob/living/blob
	name = "blob fragment"
	real_name = "blob fragment"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob_spore_temp"
	pass_flags = PASSBLOB
	maxHealth = 60
	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_LEVEL_TWO
	var/ghost_name = "Unknown"
	var/creating_blob = 0
	faction = "blob"


	New()
		real_name += " [pick(rand(1, 99))]"
		name = real_name
		..()


	say(var/message)
		return//No talking for you


	emote(var/act,var/m_type=1,var/message = null)
		return


	Life()
		set invisibility = 0
		set background = 1

		clamp_values()
		update_health()
		if(health < 0)
			src.dust()


	proc/clamp_values()
		paralysis = 0
		sleeping = 0
		if(stat)
			stat = CONSCIOUS
		return



	death(gibbed)
		if(key)
			var/mob/dead/observer/ghost = new(src)
			ghost.name = ghost_name
			ghost.real_name = ghost_name
			ghost.key = key
			if (ghost.client)
				ghost.client.eye = ghost
			return ..(gibbed)


	blob_act()
		src << "The blob attempts to absorb you."
		deal_damage(20, TOX)
		return


	Process_Spacemove()
		if(locate(/obj/effect/blob) in oview(1,src))
			return 1
		return (..())


/mob/living/blob/verb/create_node()
	set category = "Blob"
	set name = "Create Node"
	set desc = "Create a Node."
	if(creating_blob)	return
	var/turf/T = get_turf(src)
	creating_blob = 1
	if(!T)
		creating_blob = 0
		return
	var/obj/effect/blob/B = (locate(/obj/effect/blob) in T)
	if(!B)//We are on a blob
		usr << "There is no blob here!"
		creating_blob = 0
		return
	if(istype(B,/obj/effect/blob/node)||istype(B,/obj/effect/blob/core)||istype(B,/obj/effect/blob/factory))
		usr << "Unable to use this blob, find a normal one."
		creating_blob = 0
		return
	for(var/obj/effect/blob/node/blob in orange(5))
		usr << "There is another node nearby, move more than 5 tiles  away from it!"
		creating_blob = 0
		return
	for(var/obj/effect/blob/factory/blob in orange(2))
		usr << "There is a porus blob nearby, move more than 2 tiles away from it!"
		creating_blob = 0
	B.change_to("Node")
	src.dust()
	return


/mob/living/blob/verb/create_factory()
	set category = "Blob"
	set name = "Create Defense"
	set desc = "Create a Spore producing blob."
	if(creating_blob)	return
	var/turf/T = get_turf(src)
	creating_blob = 1
	if(!T)
		creating_blob = 0
		return
	var/obj/effect/blob/B = (locate(/obj/effect/blob) in T)
	if(!B)
		usr << "You must be on a blob!"
		creating_blob = 0
		return
	if(istype(B,/obj/effect/blob/node)||istype(B,/obj/effect/blob/core)||istype(B,/obj/effect/blob/factory))
		usr << "Unable to use this blob, find a normal one."
		creating_blob = 0
		return
	for(var/obj/effect/blob/blob in orange(2))//Not right next to nodes/cores
		if(istype(B,/obj/effect/blob/node))
			usr << "There is a node nearby, move away from it!"
			creating_blob = 0
			return
		if(istype(B,/obj/effect/blob/core))
			usr << "There is a core nearby, move away from it!"
			creating_blob = 0
			return
		if(istype(B,/obj/effect/blob/factory))
			usr << "There is another porous blob nearby, move away from it!"
			creating_blob = 0
			return
	B.change_to("Factory")
	src.dust()
	return


/mob/living/blob/verb/revert()
	set category = "Blob"
	set name = "Purge Defense"
	set desc = "Removes a porous blob."
	if(creating_blob)	return
	var/turf/T = get_turf(src)
	creating_blob = 1
	if(!T)
		creating_blob = 0
		return
	var/obj/effect/blob/B = (locate(/obj/effect/blob) in T)
	if(!B)
		usr << "You must be on a blob!"
		creating_blob = 0
		return
	if(!istype(B,/obj/effect/blob/factory))
		usr << "Unable to use this blob, find another one."
		creating_blob = 0
		return
	B.change_to("Normal")
	src.dust()
	return


/mob/living/blob/verb/spawn_blob()
	set category = "Blob"
	set name = "Create new blob"
	set desc = "Attempts to create a new blob in this tile."
	if(creating_blob)	return
	var/turf/T = get_turf(src)
	creating_blob = 1
	if(!T)
		creating_blob = 0
		return
	var/obj/effect/blob/B = (locate(/obj/effect/blob) in T)
	if(B)
		usr << "There is a blob here!"
		creating_blob = 0
		return
	new/obj/effect/blob(src.loc)
	src.dust()
	return






