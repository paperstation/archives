/mob/living/carbon/alien/larva
	name = "alien larva"
	real_name = "alien larva"
	icon_state = "larva0"
	pass_flags = PASSTABLE

	maxHealth = 25
	health = 25
	storedPlasma = 25
	max_plasma = 50

	var/amount_grown = 0
	var/max_grown = 200
	var/time_of_birth

	New()
		if(name == "alien larva")
			name = "alien larva ([rand(1, 1000)])"
		real_name = name
		..()
		return


	adjustPlasma(amount)
		amount_grown = min(max(amount_grown + amount, 0), max_grown) //upper limit of max_plasma, lower limit of 0
		return


	Stat()
		..()
		stat(null, "Progress: [amount_grown]/[max_grown]")


	attack_ui(slot_id)//can't equip anything
		return


	u_equip(obj/item/W as obj)
		return


	restrained()
		return 0


	show_inv(mob/user as mob)
		user.set_machine(src)
		var/dat = {"
		<B><HR><FONT size=3>[name]</FONT></B>
		<BR><HR><BR>
		<BR><A href='?src=\ref[user];mach_close=mob[name]'>Close</A>
		<BR>"}
		user << browse(dat, text("window=mob[name];size=340x480"))
		onclose(user, "mob[name]")
		return

	Life()
		set invisibility = 0
		set background = 1

		if (monkeyizing)
			return

		if(stat != DEAD)
			adjustPlasma(2)//Slowly growing
		..()//Everything else is in the parent proc
		return
