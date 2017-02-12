//UltraLight system, by Sukasa, made ROBUST by Tobba

var
	const
		UL_LUMINOSITY = 0
		UL_SQUARELIGHT = 0

		UL_RGB = 1
		UL_ROUNDLIGHT = 2

		UL_I_FALLOFF_SQUARE = 0
		UL_I_FALLOFF_ROUND = 1

		UL_I_LUMINOSITY = 0
		UL_I_RGB = 1

		UL_I_LIT = 0
		UL_I_EXTINGUISHED = 1
		UL_I_ONZERO = 2

	ul_LightingEnabled = 1
	ul_Steps = 7
	ul_LightingModel = UL_I_RGB
	ul_FalloffStyle = UL_I_FALLOFF_ROUND
	ul_TopLuminosity = 0
	ul_Layer = 10
	ul_SuppressLightLevelChanges = 0

	list/ul_ToUpdate = list()
	list/ul_OpacityUpdates = list()

	list/ul_FastRoot = list()


proc
	ul_Clamp(var/Value)
		return min(max(Value, 0), ul_Steps)

	ul_Update()
		var/list/blankList = list()
		for (var/atom/Affected in ul_OpacityUpdates)
			var/oldOpacity = ul_OpacityUpdates[Affected]
			var/newOpacity = Affected.opacity
			Affected.opacity = oldOpacity
			for (var/atom/A in view(ul_TopLuminosity, Affected))
				if (A.ul_IsLuminous() && A.ul_Extinguished == UL_I_LIT && !blankList[A])
					blankList[A] = 1
					A.ul_Extinguish()
			Affected.opacity = newOpacity
		for (var/atom/Affected in blankList)
			Affected.ul_Illuminate()
		for (var/i = 1; i <= ul_ToUpdate.len; i++)
			var/turf/Affected = ul_ToUpdate[i]
			if (!istype(Affected))
				continue
			Affected.ul_UpdateLight()
			if (ul_SuppressLightLevelChanges == 0)
				Affected.ul_LightLevelChanged()
				for(var/atom/AffectedAtom in Affected)
					AffectedAtom.ul_LightLevelChanged()
		ul_ToUpdate = null
		ul_ToUpdate = list() // Destroy the old list TODO: find a better way to clear the shit out of it
		ul_OpacityUpdates = null
		ul_OpacityUpdates = list()


atom
	var
		ColorRed = 1
		ColorGreen = 1
		ColorBlue = 1
		Luminosity = 0
		Exponent = 1
		ul_Extinguished = UL_I_ONZERO

	proc
		ul_SetLuminosity(var/Lum)
			//world << "setlum"
			if(Luminosity == Lum)
				return //No point doing all that work if it won't have any effect anyways...

			if (ul_Extinguished == UL_I_EXTINGUISHED)
				Luminosity = Lum

				return

			if (ul_IsLuminous())
				ul_Extinguish()

			Luminosity = Lum

			ul_Extinguished = UL_I_ONZERO

			if (ul_IsLuminous())
				ul_Illuminate()

			return

		ul_SetExponent(var/Exp)
			//world << "setlum"
			if(Exponent == Exp)
				return //No point doing all that work if it won't have any effect anyways...

			if (ul_Extinguished == UL_I_EXTINGUISHED)
				Exponent = Exp

				return

			if (ul_IsLuminous())
				ul_Extinguish()

			Exponent = Exp

			ul_Extinguished = UL_I_ONZERO

			if (ul_IsLuminous())
				ul_Illuminate()

			return

		ul_SetColor(var/Red, var/Green, var/Blue)
			//world << "setlum"
			if(ColorRed == Red && ColorGreen == Green && ColorBlue == Blue)
				return //No point doing all that work if it won't have any effect anyways...

			if (ul_Extinguished == UL_I_EXTINGUISHED)
				ColorRed = Red
				ColorGreen = Green
				ColorBlue = Blue

				return

			if (ul_IsLuminous())
				ul_Extinguish()

			ColorRed = Red
			ColorGreen = Green
			ColorBlue = Blue

			ul_Extinguished = UL_I_ONZERO

			if (ul_IsLuminous())
				ul_Illuminate()

			return

		ul_Illuminate()
			//world << "illum"
			if (ul_Extinguished == UL_I_LIT)
				return

			ul_Extinguished = UL_I_LIT

			ul_UpdateTopLuminosity()
			luminosity = ul_Luminosity()

			for(var/turf/Affected in view(ul_Luminosity(), src))
				var/Falloff = 0
				if (Luminosity > 0)
					Falloff = (Luminosity - src.ul_FalloffAmount(Affected)) / Luminosity
				if (Exponent != 1)
					Falloff = Falloff**Exponent

				var/Red = ColorRed * Falloff
				var/Green = ColorGreen * Falloff
				var/Blue = ColorBlue * Falloff

				Affected.LightsRed[src] = max(Red * ul_Steps, 0)
				Affected.LightsGreen[src] = max(Green * ul_Steps, 0)
				Affected.LightsBlue[src] = max(Blue * ul_Steps, 0)
				ul_ToUpdate[Affected] = 1
			return

		ul_Extinguish()
			//world << "extinglumb"
			if (ul_Extinguished != UL_I_LIT)
				return

			ul_Extinguished = UL_I_EXTINGUISHED

			for(var/turf/Affected in view(ul_Luminosity(), src))
				Affected.LightsRed -= src
				Affected.LightsGreen  -= src
				Affected.LightsBlue -= src
				ul_ToUpdate[Affected] = 1

			luminosity = 0

			return

		ul_FalloffAmount(var/atom/ref)
			//world << "fallam"
			if (ul_FalloffStyle == UL_I_FALLOFF_ROUND)
				var/x = (ref.x - src.x)
				var/y = (ref.y - src.y)
				if ((x*x + y*y + 1) > ul_FastRoot.len)
					for(var/i = ul_FastRoot.len, i <= x*x+y*y, i++)
						ul_FastRoot += sqrt(x*x+y*y)
				return round(ul_FastRoot[x*x + y*y + 1], 1)

			else if (ul_FalloffStyle == UL_I_FALLOFF_SQUARE)
				return get_dist(src, ref)

			return 0

		ul_SetOpacity(var/NewOpacity)
			//world << "setopac"
			if(opacity != NewOpacity)
				ul_OpacityUpdates[src] = opacity
				opacity = NewOpacity

			return

		ul_UnblankLocal(var/list/ReApply = view(ul_TopLuminosity, src))
			//world << "unblank"
			for(var/atom/Light in ReApply)
				if(Light.ul_IsLuminous())
					Light.ul_Illuminate()

			return

		ul_BlankLocal()
			//world << "blankl"
			var/list/Blanked = list( )
			var/TurfAdjust = isturf(src) ? 1 : 0

			for(var/atom/Affected in view(ul_TopLuminosity, src))
				if(Affected.ul_IsLuminous() && Affected.ul_Extinguished == UL_I_LIT && (ul_FalloffAmount(Affected) <= Affected.luminosity + TurfAdjust))
					Affected.ul_Extinguish()
					Blanked += Affected

			return Blanked

		ul_UpdateTopLuminosity()
			//world << "uptop"
			if (ul_TopLuminosity < Luminosity)
				ul_TopLuminosity = Luminosity

			return

		ul_Luminosity()
			//world << "lum"
			return Luminosity

		ul_IsLuminous(var/Red = ColorRed, var/Green = ColorGreen, var/Blue = ColorBlue)
			////world << "islum"
			return (Red > 0 || Green > 0 || Blue > 0)

		ul_LightLevelChanged()
			//world << "llclum"
			//Designed for client projects to use.  Called on items when the turf they are in has its light level changed
			return

	New()
		..()
		if(ul_IsLuminous())
			spawn(1)
				ul_Illuminate()
		return

	Del()
		if(ul_IsLuminous())
			ul_Extinguish()

		..()

		return

	/*
	//this is what broke diagonals
	movable
		Move()
			ul_Extinguish()
			//world << "movexting"
			..()
			ul_Illuminate()
			//world << "moveillum"
			return
	*/
turf
	var
		list/LightsRed = list()
		list/LightsGreen = list()
		list/LightsBlue = list()
		LightLevelRed = 0
		LightLevelGreen = 0
		LightLevelBlue = 0

	proc

		ul_GetRed()
			return ul_Clamp(LightLevelRed)
		ul_GetGreen()
			return ul_Clamp(LightLevelGreen)
		ul_GetBlue()
			return ul_Clamp(LightLevelBlue)

		ul_UpdateLight()
			//world << "turfuplight"
			var/area/CurrentArea = loc

			LightLevelRed = 0
			LightLevelGreen = 0
			LightLevelBlue = 0
			for (var/i = 1; i <= LightsRed.len; i++)
				var/k = LightsRed[i]
				LightLevelRed = ul_Steps - ((ul_Steps - LightsRed[k]) * (ul_Steps - LightLevelRed)) / ul_Steps
			for (var/i = 1; i <= LightsGreen.len; i++)
				var/k = LightsGreen[i]
				LightLevelGreen = ul_Steps - ((ul_Steps - LightsGreen[k]) * (ul_Steps - LightLevelGreen)) / ul_Steps
			for (var/i = 1; i <= LightsBlue.len; i++)
				var/k = LightsBlue[i]
				LightLevelBlue = ul_Steps - ((ul_Steps - LightsBlue[k]) * (ul_Steps - LightLevelBlue)) / ul_Steps

			LightLevelRed = ul_Clamp(round(LightLevelRed, 1))
			LightLevelGreen = ul_Clamp(round(LightLevelGreen, 1))
			LightLevelBlue = ul_Clamp(round(LightLevelBlue, 1))

			if(!isarea(CurrentArea) || !CurrentArea.ul_Lighting)
				return

			var/LightingTag = copytext(CurrentArea.tag, 1, findtext(CurrentArea.tag, ":UL")) + ":UL[ul_GetRed()]_[ul_GetGreen()]_[ul_GetBlue()]"

			if(CurrentArea.tag != LightingTag)
				var/area/NewArea = locate(LightingTag)

				if(!NewArea)
					NewArea = new CurrentArea.type()
					NewArea.tag = LightingTag

					for(var/V in CurrentArea.vars - "contents")
						if(issaved(CurrentArea.vars[V]))
							NewArea.vars[V] = CurrentArea.vars[V]

					NewArea.tag = LightingTag

					NewArea.ul_Light(ul_GetRed(), ul_GetGreen(), ul_GetBlue())


				NewArea.contents += src

			return

		ul_Recalculate()
			//world << "ulrecalc"
			ul_SuppressLightLevelChanges++

			var/list/Lights = ul_BlankLocal()

			LightLevelRed = 0
			LightLevelGreen = 0
			LightLevelBlue = 0

			ul_UnblankLocal(Lights)

			ul_SuppressLightLevelChanges--

			return

area
	var
		ul_Overlay = null
		ul_Lighting = 1

		LightLevelRed = 0
		LightLevelGreen = 0
		LightLevelBlue = 0

	proc
		ul_Light(var/Red = LightLevelRed, var/Green = LightLevelGreen, var/Blue = LightLevelBlue)
			//world << "ullight"
			if(!src || !src.ul_Lighting)
				return

			overlays -= ul_Overlay

			LightLevelRed = Red
			LightLevelGreen = Green
			LightLevelBlue = Blue

			luminosity = ul_IsLuminous(LightLevelRed, LightLevelGreen, LightLevelBlue)

			ul_Overlay = image('ULIcons.dmi', , num2text(LightLevelRed) + "-" + num2text(LightLevelGreen) + "-" + num2text(LightLevelBlue), ul_Layer)

			overlays += ul_Overlay

			return

		ul_Prep()
			//world << "ulprep"
			if(!tag)
				tag = "[type]"
			if(ul_Lighting)
				if(!findtext(tag,":UL"))
					ul_Light()
			//world.log << tag

			return