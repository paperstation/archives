/obj/manifest/New()

	src.invisibility = 101
	return

/obj/manifest/proc/manifest()
	var/dat = "<B>Crew Manifest</B>:<BR>"
	for(var/mob/living/carbon/human/M in mobs)
		dat += "    <B>[M.name]</B> -  [(istype(M.wear_id, /obj/item/card/id) || istype(M.wear_id, /obj/item/device/pda2)) ? "[M.wear_id:assignment]" : "Unknown Position"]<BR>"
	var/obj/item/paper/P = new /obj/item/paper( src.loc )
	P.info = dat
	P.name = "paper- 'Crew Manifest'"
	//SN src = null
	qdel(src)
	return

