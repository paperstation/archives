/obj/mecha/combat/segway/motorbike
	desc = "Holy shit this things fast!"
	name = "Motorbike"
	icon_state = "motorcycle"
	melee_cooldown = 10
	melee_can_hit = 0
	anchored = 0
	step_in = -1
	health = 40
	opacity = 0
	deflect_chance = 10
	internal_damage_threshold = 60
	max_temperature = 500
	infra_luminosity = 5
	operation_req_access = ""
	add_req_access = 0
	max_equip = 0
	step_energy_drain = 1

/obj/mecha/combat/segway/motorbike/New()
	..()
	src.icon_state = "motorcycle"