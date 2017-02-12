/obj
	animate_movement = 2
	var/unacidable = 0 //universal "unacidabliness" var, here so you can use it in any obj.
	var/m_amt = 0	// metal
	var/g_amt = 0	// glass
	var/w_amt = 0	// waster amounts

	var/damtype = BRUTE
	var/force = 0
	var/forcetype = IMPACT
	//var/throwforce = 1


	//This thing is part of the really bad newer update dialog code
	var/in_use = 0 // If we have a user using us, this will be set on. We will check if the user has stopped using us, and thus stop updating and LAGGING EVERYTHING!

	//Health vars
	var/health = 100
	var/max_health = 100
	var/damage_resistance = 0//-1 means it will never break
	var/damage_sound = null//Can be a list or a single sound, will make this sound when damaged

	attackby(obj/item/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/grab) || istype(W, /obj/item/weapon/plastique) || istype(W, /obj/item/weapon/reagent_containers/spray) || istype(W, /obj/item/weapon/packageWrap) | istype(W, /obj/item/device/detective_scanner))
			return
		damaged_by(W, user)
		return 1


	proc/damaged_by(var/obj/item/W, var/mob/user = null, var/use_armor = 1)
		var/amount = W.force
		if(use_armor)
			amount = max((W.force-damage_resistance), 1)
		var/averb = "hit"
		if(W.attack_verb.len)
			averb = pick(W.attack_verb)
		if(W.force == 0 || amount <= 0 || damage_resistance == -1)
			visible_message("\red <b>\The [src] has been [averb] with \the [W][(user ? " by [user]" : "")] to no affect!</b>")
			return
		else
			visible_message("\red <b>\The [src] has been [averb] with \the [W][(user ? " by [user]!" : "!")]</b>")

		damage(amount,0)//Already calc'd armor above
		return


	proc/damage(var/amount, var/use_armor = 1, var/use_sound = 1)
		if(damage_resistance == -1)
			return
		if(use_armor)
			amount = max((amount-damage_resistance), 1)
		if(use_sound && damage_sound)
			playsound(src.loc, pick(damage_sound), 80, 1, -1)
		health -= amount
		update_health()
		return


	//Called to finish off an item
	proc/destroy()
		if(SSpower.defer_powernet_rebuild <= 0)//This is a very ugly hack to make it not use message when a bomb goes off.  Its needed for the moment, will fix later
			visible_message("\red [src] breaks!")
		Del()
		return


	proc/update_health()
		if(health <= 0)
			destroy()
		return


	blob_act()
		damage(100)
		return


	meteorhit()
		damage(200)
		return


	bullet_act(var/obj/item/projectile/Bullet)
		if(Bullet.damtype == BRUTE || Bullet.damtype == BURN)
			damaged_by(Bullet)
		return ..()


	ex_act(severity)
		switch(severity)
			if(1.0)
				damage(200, 0, 0)
				return
			if(2.0)
				damage(rand(200,100), 0, 0)
				return
			if(3.0)
				damage(rand(100,50), 0, 0)
				return


/obj/proc/process()
	processing_objects.Remove(src)
	return 0

/obj/assume_air(datum/air_group/giver)
	if(loc)
		return loc.assume_air(giver)
	else
		return null

/obj/remove_air(amount)
	if(loc)
		return loc.remove_air(amount)
	else
		return null

/obj/return_air()
	if(loc)
		return loc.return_air()
	else
		return null
/*
/obj/proc/handle_internal_lifeform(mob/lifeform_inside_me, breath_request)
	//Return: (NONSTANDARD)
	//		null if object handles breathing logic for lifeform
	//		datum/air_group to tell lifeform to process using that breath return
	//DEFAULT: Take air from turf to give to have mob process
	if(breath_request>0)
		return remove_air(breath_request)
	else
		return null*/

/atom/movable/proc/initialize()
	return

/obj/proc/updateUsrDialog()
	if(in_use)
		var/is_in_use = 0
		var/list/nearby = viewers(1, src)
		for(var/mob/M in nearby)
			if ((M.client && M.machine == src))
				is_in_use = 1
				src.attack_hand(M)
		if (istype(usr, /mob/living/silicon/ai) || istype(usr, /mob/living/silicon/robot))
			if (!(usr in nearby))
				if (usr.client && usr.machine==src) // && M.machine == src is omitted because if we triggered this by using the dialog, it doesn't matter if our machine changed in between triggering it and this - the dialog is probably still supposed to refresh.
					is_in_use = 1
					src.attack_ai(usr)

		// check for TK users

		if (istype(usr, /mob/living/carbon/human))
			if(istype(usr.l_hand, /obj/item/tk_grab) || istype(usr.r_hand, /obj/item/tk_grab/))
				if(!(usr in nearby))
					if(usr.client && usr.machine==src)
						is_in_use = 1
						src.attack_hand(usr)
		in_use = is_in_use

/obj/proc/updateDialog()
	// Check that people are actually using the machine. If not, don't update anymore.
	if(in_use)
		var/list/nearby = viewers(1, src)
		var/is_in_use = 0
		for(var/mob/M in nearby)
			if ((M.client && M.machine == src))
				is_in_use = 1
				src.interact(M)
		var/ai_in_use = AutoUpdateAI(src)

		if(!ai_in_use && !is_in_use)
			in_use = 0

/obj/proc/interact(mob/user)
	return

/obj/proc/update_icon()
	return

/mob/proc/unset_machine()
	src.machine = null

/mob/proc/set_machine(var/obj/O)
	if(src.machine)
		unset_machine()
	src.machine = O
	if(istype(O))
		O.in_use = 1

/obj/item/proc/updateSelfDialog()
	var/mob/M = src.loc
	if(istype(M) && M.client && M.machine == src)
		src.attack_self(M)


/obj/proc/alter_health()
	return 1

/obj/proc/hide(h)
	return


/obj/proc/hear_talk(mob/M as mob, text)
/*
	var/mob/mo = locate(/mob) in src
	if(mo)
		var/rendered = "<span class='game say'><span class='name'>[M.name]: </span> <span class='message'>[text]</span></span>"
		mo.show_message(rendered, 2)
		*/
	return