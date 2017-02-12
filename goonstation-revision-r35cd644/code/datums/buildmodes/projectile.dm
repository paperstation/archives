/datum/buildmode/projectile
	name = "Projectile"
	desc = {"***********************************************************<br>
Right Mouse Button on buildmode button = Select projectile type<br>
Ctrl + RMB on buildmode button         = Edit projectile variables<br>
Left Mouse Button                      = FIRE!<br>
***********************************************************"}
	icon_state = "buildmode_zap"
	var/datum/projectile/P

	click_mode_right(var/ctrl, var/alt, var/shift)
		if (ctrl && P)
			usr.client.debug_variables(P)
		else
			var/projtype = input("Select projectile type.", "Projectile type", P) in typesof(/datum/projectile) - /datum/projectile
			if (P)
				if (projtype == P.type)
					return
			P = new projtype()

	click_left(atom/object, var/ctrl, var/alt, var/shift)
		var/obj/projectile/proj = initialize_projectile_ST(usr, P, object)
		proj.launch()