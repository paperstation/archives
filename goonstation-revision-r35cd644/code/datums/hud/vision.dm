/datum/hud/vision // generic overlays for modifying the mobs vision
	var/obj/screen/hud
		scan
		color_mod
		dither
		flash

	New()
		scan = create_screen("", "", 'icons/mob/hud_common.dmi', "scan", "WEST, SOUTH to EAST, NORTH", HUD_LAYER_UNDER_1)
		scan.mouse_opacity = 0
		scan.alpha = 0
		color_mod = create_screen("", "", 'icons/mob/hud_common.dmi', "white", "WEST, SOUTH to EAST, NORTH", HUD_LAYER_UNDER_2)
		color_mod.mouse_opacity = 0
		color_mod.blend_mode = BLEND_MULTIPLY
		dither = create_screen("", "", 'icons/mob/hud_common.dmi', "dither", "WEST, SOUTH to EAST, NORTH", HUD_LAYER_UNDER_3)
		dither.mouse_opacity = 0
		dither.alpha = 0
		flash = create_screen("", "", 'icons/mob/hud_common.dmi', "white", "WEST, SOUTH to EAST, NORTH", HUD_LAYER_UNDER_3)
		flash.mouse_opacity = 0
		flash.alpha = 0

	proc
		flash(duration)
			flash.alpha = 255
			animate(flash, alpha = 0, time = duration, easing = SINE_EASING)

		noise(duration)
			// hacky and incorrect but I didnt want to introduce another object just for this
			flash.icon_state = "noise"
			src.flash(duration)
			spawn(duration)
				flash.icon_state = "white"

		set_scan(scanline)
			scan.alpha = scanline ? 255 : 0

		set_color_mod(color)
			color_mod.color = color

		animate_color_mod(color, duration)
			animate(color_mod, color = color, time = duration)

		set_dither_alpha(alpha)
			dither.alpha = alpha

		animate_dither_alpha(alpha, duration)
			animate(dither, alpha = alpha, time = duration)
