// why were most of these in gimmick.dm??????  that's a file for clothing.  what??????????????????????????

/obj/item/device/key
	name = "skeleton key"
	desc = "It unlocks or locks doors."
	icon = 'icons/misc/aprilfools.dmi'
	icon_state = "key"
	item_state = "pen"
	force = null
	w_class = 1.0
	burn_possible = 0 // too important to burn!

/obj/item/device/key/cheget
	name = "old fancy key"
	desc = "It unlocks or locks slightly newer doors."
	icon_state = "ckey1"

/obj/item/device/key/skull
	name = "collar key"
	desc = "Unlocks places you'd otherwise need a bone to pick. Proof that you are an awful human being."
	icon_state = "bloodyskull"

// The key that unlocks walls.  (please refer to turf.dm)
/obj/item/device/key/haunted
	name = "iron key"
	desc = "An old key of iron."
	var/last_use = 0

var/list/rkey_adjectives = list("burning", "searing","alien","old", "ancient","ethereal", "shining", "secret", "hidden", "dull", "prismatic", "crystaline", "eldritch", "strange", "odd", "buzzing", "mysterious", "great", "rusted", "broken", "glowing", "floating", "mystical", "magic")
var/list/rkey_nouns = list("dragon", "master", "wizard's", "yendor's", "solarium", "automaton's", "bee's", "shitty bill's", "captain's", "jones'", "void", "ghost", "skeleton")
var/list/rkey_materials = list("bronze","crystal", "metal", "iron", "mauxite", "pharosium", "char", "molitz", "cobryl", "cytine", "uqill", "bohrum", "claretine", "erebite", "cerenkite", "plasmastone", "syreline", "gold", "silver", "copper", "titanium", "unobtanium")
var/list/rkey_keynames = list("key","passkey", "latchkey", "opener", "rune-key")
var/list/rkey_ofwhat = list("of unlocking", "of the yellow king", "of magic", "of kings", "of a thousand locks", "of doom", "of evil", "of the forge", "of the sun", "of fire")

var/list/rkey_descfluff = list(\
"You are not sure what this Key could be used for.",\
"The key feels slightly warm.",\
"The key feels cold.",\
"The key feels strange.",\
"Its very light.",\
"It somehow frightens you.",\
"It almost seems alive.",\
"There is a small red fish engraved on it.",\
"There is a small sun engraved on it.",\
"It has an engraving of a man wearing a strange mask.",\
"There is a tiny robot symbol on it.",\
"It menaces with spikes of bread.",\
"The key feels very smooth.",\
"It glows faintly.",\
"There are small red blotches on it. It almost looks like blood.",\
"You notice light warping around the key.",\
)

/obj/item/device/key/random
	name = ""
	desc = "You are not sure what this key is for."

	icon = 'icons/obj/randomkeys.dmi'
	icon_state = "null"

	New(var/loca)
		randomize()
		return ..(loca)

	proc/randomize()
		var/part1 = ""
		var/part2 = ""
		var/part3 = ""
		var/part4 = ""

		switch (pick(prob(100);1, prob(40);2, prob(15);3))
			if (1) //adjective only
				part1 = pick(rkey_adjectives)
			if (2) //noun only
				part1 = pick(rkey_nouns)
			if (3) //adjective and noun
				part1 = "[pick(rkey_adjectives)] [pick(rkey_nouns)]"

		if (prob(50)) //add material?
			part2 = "[pick(rkey_materials)] "

		part3 = pick(rkey_keynames) //pick name for key

		if (prob(5)) //add more fluff?
			part4 = " [pick(rkey_ofwhat)]"

		name = "[part1] [part2][part3][part4]"

		desc = "\A [part1] key. [length(part2) ? "It is made of [part2]. ":""][prob(5) ? pick(rkey_descfluff):""]"

		color = rgb(rand(0, 255), rand(0, 255), rand(0, 255))

		if (findtext(name, "crystal") || findtext(name, "prismatic") || findtext(name, "glowing") || findtext(name, "shining")) blend_mode = 2
		else if (findtext(name, "void") || findtext(name, "evil") || findtext(name, "doom") || findtext(name, "ancient")) blend_mode = 3

		if (findtext(name, "ghost") || findtext(name, "crystal") || findtext(name, "void") || findtext(name, "ethereal")) alpha = 150

		if (findtext(name, "float"))
			animate_float(src, -1, rand(10, 40))
		else if (findtext(name, "eldritch") || findtext(name, "wizard") || findtext(name, "magic"))
			animate_flash_color_fill(src,rgb(rand(0, 255), rand(0, 255), rand(0, 255)),-1, rand(10, 100))
		else if (prob(50))
			src.Turn(rand(0, 359))

		if (findtext(name, "burning") || findtext(name, "searing") || findtext(name, "fire") || findtext(name, "sun"))
			particleMaster.SpawnSystem(new /datum/particleSystem/fireTest(src))

		overlays += image('icons/obj/randomkeys.dmi',src,"ring[rand(0,10)]")
		overlays += image('icons/obj/randomkeys.dmi',src,"shaft[rand(0,9)]")
		overlays += image('icons/obj/randomkeys.dmi',src,"teeth[rand(0,10)]")
		return

/obj/item/device/key/iridium
	name = "iridium key"
	desc = "A key made of a fancy, silvery material."

	virtual
		desc = "A key made of a fancy, silvery set of pixels."
		Move()
			..()
			var/area/A = get_area(src)
			if (A && !A.virtual)
				qdel(src)

		set_loc()
			..()
			var/area/A = get_area(src)
			if (A && !A.virtual)
				qdel(src)


/obj/item/device/key/virtual
	name = "virtual key"
	desc = "A key crafted of polygons and VRML."
	icon_state = "key_vr"

	New()
		..()
		. = rand(5, 20)
		spawn(rand(1,10))
			animate(src, pixel_y = 32, transform = matrix(., MATRIX_ROTATE), time = 20, loop = -1, easing = SINE_EASING)
			animate(pixel_y = 0, transform = matrix(. * (-1), MATRIX_ROTATE), time = 20, loop = -1, easing = SINE_EASING)

/obj/item/device/key/lead
	name = "lead key"
