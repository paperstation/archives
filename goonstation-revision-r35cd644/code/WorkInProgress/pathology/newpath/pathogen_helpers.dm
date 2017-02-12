/proc/shakespearify(var/string)
	string = dd_replacetext(string, "your ", "[pick("thy", "thine")] ")
	string = dd_replacetext(string, " your", " [pick("thy", "thine")]")
	string = dd_replacetext(string, " is ", " be ")
	string = dd_replacetext(string, "you ", "thou ")
	string = dd_replacetext(string, " you", " thou")
	string = dd_replacetext(string, "are ", "art ")
	string = dd_replacetext(string, " are", " art")
	string = dd_replacetext(string, "does ", "doth ")
	string = dd_replacetext(string, " does", " doth")
	string = dd_replacetext(string, "do ", "doth ")
	string = dd_replacetext(string, " do", " doth")
	string = dd_replacetext(string, "she ", "the lady ")
	string = dd_replacetext(string, " she", " the lady")
	string = dd_replacetext(string, "i think", "methinks")
	return string

/mob/living/carbon/human/proc/become_ice_statue()
	var/obj/overlay/iceman = new /obj/overlay(get_turf(src))
	src.pixel_x = 0
	src.pixel_y = 0
	src.set_loc(iceman)
	iceman.name = "ice statue of [src.name]"
	iceman.desc = "We here at Space Station 13 believe in the transparency of our employees. It doesn't look like a functioning human can be retrieved from this."
	iceman.anchored = 0
	iceman.density = 1
	iceman.layer = MOB_LAYER
	iceman.dir = src.dir
	iceman.alpha = 128

	var/ist = "body_f"
	if (src.gender == "male")
		ist = "body_m"
	var/icon/composite = icon('icons/mob/human.dmi', ist, null, 1)
	for(var/O in src.overlays)
		var/image/I = O
		composite.Blend(icon(I.icon, I.icon_state, null, 1), ICON_OVERLAY)
	composite.ColorTone( rgb(165,242,243) ) // ice
	iceman.icon = composite
	src.take_toxin_damage(INFINITY)
	src.ghostize()

/proc/generate_random_pathogen()
	var/datum/pathogen/P = unpool(/datum/pathogen)
	P.setup(1, null, 0)
	return P

/proc/wrap_pathogen(var/datum/reagents/reagents, var/datum/pathogen/P, var/units = 5)
	reagents.add_reagent("pathogen", units)
	var/datum/reagent/blood/pathogen/R = reagents.get_reagent("pathogen")
	if (R)
		R.pathogens[P.pathogen_uid] = P

/proc/ez_pathogen(var/stype)
	var/datum/pathogen/P = unpool(/datum/pathogen)
	var/datum/pathogen_cdc/cdc = P.generate_name()
	cdc.mutations += P.name
	cdc.mutations[P.name] = P
	P.generate_components(cdc, 0)
	P.generate_attributes(0)
	P.mutativeness = 0
	P.mutation_speed = 0
	P.advance_speed = 6
	P.suppression_threshold = max(1, P.suppression_threshold)
	P.add_symptom(pathogen_controller.path_to_symptom[stype])
	logTheThing("pathology", null, null, "Pathogen [P.name] created by quick-pathogen-proc with symptom [stype].")
	return P
