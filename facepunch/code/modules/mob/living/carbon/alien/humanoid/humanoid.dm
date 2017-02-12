/mob/living/carbon/alien/humanoid
	name = "alien"
	icon_state = "alien_s"

	var/obj/item/weapon/r_store = null
	var/obj/item/weapon/l_store = null
	var/caste = ""//Deals with which icon it should use
	update_icon = 1


	New()
		if(name == "alien")
			name = text("alien ([rand(1, 1000)])")
		real_name = name
		storedPlasma = max_plasma/2//Alens start with half of the total
		..()
		return

	movement_delay()
		return (2 + move_delay_add + config.alien_delay)

	attack_hand(mob/living/carbon/human/M as mob)
		..()
		switch(M.a_intent)
			if("help")
				help_shake_act(M)

			if("grab")
				if (M == src)
					return
				var/obj/item/weapon/grab/G = new /obj/item/weapon/grab(M, M, src)
				M.put_in_active_hand(G)
				grabbed_by += G
				G.synch()
				LAssailant = M
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
				visible_message("\red [M] has grabbed [src] passively!")

			if("hurt")
				var/damage = 2
				if(HULK in M.mutations)//HULK SMASH
					damage += 13
					spawn(0)
						step_away(src,M,15)
				playsound(loc, "punch", 25, 1, -1)
				visible_message("\red <B>[M] has punched [src]!</B>")
				deal_damage(damage, BRUTE, IMPACT, "chest")

			if("disarm")
				if(prob(50) && !lying)
					drop_item()
					playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
					visible_message("\red <B>[M] disarmed [src]!</B>")
				else
					playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
					visible_message("\red <B>[M] attempted to disarm [src]!</B>")
		return


	restrained()
		if(handcuffed)
			return 1
		return 0


	show_inv(mob/user as mob)
		user.set_machine(src)
		var/dat = {"
		<B><HR><FONT size=3>[name]</FONT></B>
		<BR><HR>
		<BR><B>Left Hand:</B> <A href='?src=\ref[src];item=l_hand'>[(l_hand ? text("[]", l_hand) : "Nothing")]</A>
		<BR><B>Right Hand:</B> <A href='?src=\ref[src];item=r_hand'>[(r_hand ? text("[]", r_hand) : "Nothing")]</A>
		<BR><A href='?src=\ref[src];item=pockets'>Empty Pouches</A>
		<BR><A href='?src=\ref[user];mach_close=mob[name]'>Close</A>
		<BR>"}
		user << browse(dat, text("window=mob[name];size=340x480"))
		onclose(user, "mob[name]")
		return


