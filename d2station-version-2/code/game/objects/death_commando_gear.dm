/obj/beam/a_laser/pulse_laser
	name = "pulse laser"
	icon_state = "u_laser"

	Bump(atom/A)
		spawn()
			if(A)
				A.bullet_act(PROJECTILE_LASER, src, def_zone)
				del(src)