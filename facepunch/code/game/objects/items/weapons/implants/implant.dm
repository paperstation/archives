/obj/item/weapon/implant
	name = "implant"
	var/implanted = null
	var/mob/imp_in = null
	var/variant = "b"
	var/allow_reagents = 0

	proc/trigger(emote, source as mob)
		return

	proc/activate()
		return

	// What does the implant do upon injection?
	// return 0 if the implant fails (ex. Revhead and loyalty implant.)
	// return 1 if the implant succeeds (ex. Nonrevhead and loyalty implant.)
	proc/implanted(var/mob/source)
		return 1

	proc/get_data()
		return



	trigger(emote, source as mob)
		return


	activate()
		return


	implanted(mob/source)
		return 1


	get_data()
		return "No information available"

	proc/on_remove()//The surgery to remove implants will call this
		activate("removal")
		return


/obj/item/weapon/implant/tracking
	name = "tracking"
	desc = "Track with this."
	var/id = 1.0


	get_data()
		var/dat = {"<b>Implant Specifications:</b><BR>
<b>Name:</b> Tracking Beacon<BR>
<b>Life:</b> 10 minutes after death of host<BR>
<b>Important Notes:</b> None<BR>
<HR>
<b>Implant Details:</b> <BR>
<b>Function:</b> Continuously transmits low power signal. Useful for tracking.<BR>
<b>Special Features:</b><BR>
<i>Neuro-Safe</i>- Specialized shell absorbs excess voltages self-destructing the chip if
a malfunction occurs thereby securing safety of subject. The implant will melt and
disintegrate into bio-safe elements.<BR>
<b>Integrity:</b> Gradient creates slight risk of being overcharged and frying the
circuitry. As a result neurotoxins can cause massive damage.<HR>
Implant Specifics:<BR>"}
		return dat



/obj/item/weapon/implant/explosive
	name = "explosive"
	desc = "And boom goes the weasel."
	var/ex_heavy = -1
	var/ex_med = 0
	var/ex_light = 2
	var/weapon_level = 2//Allows you to use locked weapons of this or lower level

	get_data()
		var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Robust Corp RX-78 Employee Management Implant<BR>
<b>Life:</b> Activates upon death.<BR>
<b>Important Notes:</b> Explodes<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Contains a compact, electrically detonated explosive that detonates upon receiving a specially encoded signal or upon host death.<BR>
<b>Special Features:</b> Explodes<BR>
<b>Integrity:</b> Implant will occasionally be degraded by the body's immune system and thus will occasionally malfunction."}
		return dat


	trigger(emote, source as mob)
		if(emote == "deathgasp")
			src.activate("death")
		return


	activate(var/cause)
		if((!cause) || (!src.imp_in))	return 0
		explosion(src, ex_heavy, ex_med, ex_light, 3, 0)//This might be a bit much, dono will have to see.
		if(src.imp_in)
			src.imp_in.gib()
		return

/*
/obj/item/weapon/implant/spooky
	name = "spooky implant"

	trigger(emote, source as mob)
		if(src.stat == 2)
			src.activate("death")
		return


	activate(var/cause)
		if((!cause) || (!src.imp_in))	return 0
		if(src.imp_in)
			src.imp_in.gib()
		return


*/


/obj/item/weapon/implant/explosive/blasto
	name = "explosive-blasto"
	ex_heavy = -1
	ex_med = 1
	ex_light = 3


/obj/item/weapon/implant/explosive/ass
	name = "explosive-ass"
	weapon_level = 3//Allows you to use locked weapons of this or lower level

	get_data()
		var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Assault Systems Specialists Weapon Auth Implant<BR>
<b>Life:</b> Six Years<BR>
<b>Important Notes:</b> Explosive<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Contains a compact microchip designed to interface with secure weapons.  A small explosive charge ensures the implant will not fall into enemy hands.<BR>
<b>Special Features:</b> Explodes<BR>
<b>Integrity:</b>  Very Strong"}
		return dat



/obj/item/weapon/implant/samurai
	name = "explosive"
	desc = "And boom goes the weasel."
/*
	activate(var/cause)
		if((!cause) || (!src.imp_in))	return 0
		if(src.imp_in)
			var/mob/living/simple_animal/hostile/samureye/X = new/mob/living/simple_animal/hostile/samureye
			X.loc = src.imp_in.loc
			X.key = src.imp_in.key
			X.client = src.imp_in.client
		return
*/
	trigger(emote, source as mob)
		if(emote == "deathgasp")
			var/mob/living/simple_animal/hostile/samureye/X = new/mob/living/simple_animal/hostile/samureye
			X.loc = src.imp_in.loc
			X.key = src.imp_in.key
			X.client = src.imp_in.client
			X.samurainame = src.name
		return

/obj/item/weapon/implant/chem
	name = "chem"
	desc = "Injects things."
	allow_reagents = 1


	get_data()
		var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Robust Corp MJ-420 Prisoner Management Implant<BR>
<b>Life:</b> Deactivates upon death but remains within the body.<BR>
<b>Important Notes: Due to the system functioning off of nutrients in the implanted subject's body, the subject<BR>
will suffer from an increased appetite.</B><BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Contains a small capsule that can contain various chemicals. Upon receiving a specially encoded signal<BR>
the implant releases the chemicals directly into the blood stream.<BR>
<b>Special Features:</b>
<i>Micro-Capsule</i>- Can be loaded with any sort of chemical agent via the common syringe and can hold 50 units.<BR>
Can only be loaded while still in its original case.<BR>
<b>Integrity:</b> Implant will last so long as the subject is alive. However, if the subject suffers from malnutrition,<BR>
the implant may become unstable and either pre-maturely inject the subject or simply break."}
		return dat


	New()
		..()
		var/datum/reagents/R = new/datum/reagents(50)
		reagents = R
		R.my_atom = src


	trigger(emote, source as mob)
		if(emote == "deathgasp")
			src.activate(src.reagents.total_volume)
		return


	activate(var/cause)
		if((!cause) || (!src.imp_in))	return 0
		var/mob/living/carbon/R = src.imp_in
		src.reagents.trans_to(R, cause)
		R << "You hear a faint *beep*."
		if(!src.reagents.total_volume)
			R << "You hear a faint click from your chest."
			spawn(0)
				del(src)
		return



/obj/item/weapon/implant/loyalty//Counts as having level 1 weapon auth
	name = "loyalty"
	desc = "Makes you loyal or such."
	var/alt_icon = 0//Should we use an alternate icon

	get_data()
		var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Nanotrasen Employee Management Implant<BR>
<b>Life:</b> Ten years.<BR>
<b>Important Notes:</b> Personnel injected with this device tend to be much more loyal to the company.<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Contains a small pod of nanobots that manipulate the host's mental functions.<BR>
<b>Special Features:</b> Will prevent and cure most forms of brainwashing.<BR>
<b>Integrity:</b> Implant will last so long as the nanobots are inside the bloodstream."}
		return dat


	implanted(mob/M)
		if(!istype(M, /mob/living/carbon/human))	return 0
		var/mob/living/carbon/human/H = M
		if(H.mind in ticker.mode.head_revolutionaries)
			H.visible_message("[H] seems to resist the implant!", "You feel the corporate tendrils of Nanotrasen try to invade your mind! But you resist it!")
			alt_icon = 1
			return 1
		else if(H.mind in ticker.mode.revolutionaries)
			ticker.mode:remove_revolutionary(H.mind)

		if(H.mind in ticker.mode.cult)
			H.visible_message("[H] seems to resist the implant!", "You feel the corporate tendrils of Nanotrasen try to invade your mind! But you resist it!")
			alt_icon = 1
			return 1

		if(H.mind in ticker.mode.traitors)
			H << "\red You feel the corporate tendrils of Nanotrasen try to invade your mind! But you resist it!"
			return 1

		if(H.mind in ticker.mode.changelings)
			H << "\red You feel the corporate tendrils of Nanotrasen try to invade your mind! But you resist it!"
			spawn(1200)//Loyalty implants will fall apart due to changling biochem
				if(src)
					del(src)
			return 1

		if(H.mind in ticker.mode.wizards)
			H << "\red You feel the corporate tendrils of Nanotrasen try to invade your mind! But you resist it!"
			return 1


		H << "\blue You feel a surge of loyalty towards Nanotrasen."
		return 1

	on_remove()
		if(imp_in)
			imp_in << "<span class='notice'>You feel a sense of liberation as Nanotrasen's grip on your mind fades away.</span>"
		..()
		return


/obj/item/weapon/implant/adrenalin
	name = "adrenalin"
	desc = "Removes all stuns and knockdowns."
	var/uses = 5

	get_data()
		var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Cybersun Industries Adrenalin Implant<BR>
<b>Life:</b> Five days.<BR>
<b>Important Notes:</b> <font color='red'>Illegal</font><BR>
<HR>
<b>Implant Details:</b> Subjects injected with implant can activate a massive injection of adrenalin.<BR>
<b>Function:</b> Contains nanobots to stimulate body to mass-produce Adrenalin.<BR>
<b>Integrity:</b> Implant can only be used five times before the nanobots are depleted."}
		return dat


	trigger(emote, mob/source as mob)
		if(src.uses < 1)	return 0
		if(emote == "pale")
			activate("trigger")
		return


	activate(var/cause)
		if((!cause) || (!src.imp_in) || uses < 1)	return 0
		src.uses--
		var/mob/living/carbon/M = src.imp_in
		M << "\blue You feel a sudden surge of energy!"
		M.deal_damage(-100, WEAKEN)
		M.deal_damage(-100, PARALYZE)
		return


	implanted(mob/source)
		source.mind.store_memory("A implant can be activated by using the pale emote, <B>say *pale</B> to attempt to activate.", 0, 0)
		source << "The implanted freedom implant can be activated by using the pale emote, <B>say *pale</B> to attempt to activate."
		return 1


