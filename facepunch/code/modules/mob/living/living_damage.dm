
//This proc is called to deal damage to a mob without having to run several armor checks
//The armor checks are ran and dealt with inside this proc and in general this proc should require no overrides
//The first arg is how much damage to do
//The second is what type (brute,fire,stun,tox,ect)
//The third is the weapon type (impact,pierce,slash,bomb,irradiate) null will ignore armor
//The final arg is where you are aiming (head,chest,arms,legs) if null will pick one.
/mob/living/proc/deal_damage(var/amount, var/damage_type = "brute", var/weapon_type = null, var/def_zone = null)
	if(amount == 0)//Not allowed to do 0 damage, less however is fine
		return 0
	if((amount > 0) && status_flags & GODMODE)//Godmode means no damage but can still heal
		return 0
	var/zone = check_zone(amount, damage_type, def_zone)
	var/resistance = 0
	if(weapon_type)
		resistance = get_resistance(weapon_type, zone)
	if(resistance >= 1)//Resistance is good enough to block everything so stop here
		return 0
	amount = (amount*(1-resistance))
	if(amount > 0 && amount < 1)
		amount = 1//Do at least one damage if armor knocked us below 1
	switch(damage_type)//Might need max() here
		if(TOX)
			tox_damage = max(0, tox_damage + amount)
		if(OXY)
			oxy_damage = max(0, oxy_damage + amount)
		if(CLONE)
			clone_damage = max(0, clone_damage + amount)
		if(FATIGUE)
			fatigue  = min(max(0, fatigue + amount),105)
		if(IRRADIATE)
			radiation += amount
		if(BRAIN)
			brain_damage = max(0, brain_damage + amount)
		//These are the older ways of stunning people
		if(WEAKEN)
			if(!(status_flags & CANWEAKEN))
				return
			if(amount < 0)
				weakened = max(0, weakened + amount)
			else
				weakened = max(weakened, amount)//Stuns do not stack they just take the highest
		if(PARALYZE)
			if(!(status_flags & CANPARALYSE))
				return
			if(amount < 0)
				paralysis = max(0, paralysis + amount)
			else
				paralysis = max(paralysis, amount)
		if(STUTTER)
			if(amount < 0)
				stuttering = max(0, stuttering - amount)
			else
				stuttering = max(stuttering, amount)
	damage_zone(amount, damage_type, zone)
	update_health()
	return amount



//This proc is called in order to determine if a zone is able to be damaged and return it
/mob/living/proc/check_zone(var/amount, var/damage_type, var/zone)
	if(damage_type == IRRADIATE)
		return null//IRRADIATE should calc armor for the entire body so use null
	if(!zone)
		zone = random_zone()
	if(amount < 0)//If healing then we dont care where you try to heal
		return zone
	if(damage_type != BRUTE && damage_type != BURN)
		return zone
	switch(zone)
		if("head")
			if((brute_head + fire_head) >= 100)//Heads have 100 hp atm
				zone = "chest"
		if("arms")
			if((brute_arms + fire_arms) >= 50)//Arms have 50 hp atm
				zone = "chest"
		//if("chest")//Chests take it no matter what, this could try and figure out who can still take it but not needed atm
		//	return "chest"
		if("legs")
			if((brute_legs + fire_legs) >= 50)//Legs have 50 hp atm
				zone = "chest"
	return zone



//This proc figures out the armor on a portion of the body and returns it
/mob/living/proc/get_resistance(var/weapon_type, var/zone)
	return 0//do body armor here


//This proc actually deals brute/fire damage to the proper var
//Amount can be < 0, this will heal, if update_damage is set to 1 it will update the damage overlays
/mob/living/proc/damage_zone(var/amount, var/damage_type, var/zone, var/update_damage = 1)
	if(status_flags & GODMODE)
		return 0
	if(damage_type != BRUTE && damage_type != BURN)//Needs to be brute or burn
		return 0
	if(TEMPATURE_RESIST in mutations && damage_type == BURN && amount > 0)//temp resist means no damage from burn
		return 0
	switch(zone)
		if("chest")
			if(damage_type == BRUTE)
				brute_chest = max(brute_chest + amount,0)
			else
				fire_chest = max(fire_chest + amount,0)
		if("head")
			if(damage_type == BRUTE)
				brute_head = max(min(brute_head + amount, 100),0)
			else
				fire_head = max(min(fire_head + amount, 100),0)
		if("arms")
			if(damage_type == BRUTE)
				brute_arms = max(min(brute_arms + amount, 50),0)
			else
				fire_arms = max(min(fire_arms + amount, 50),0)
		if("legs")
			if(damage_type == BRUTE)
				brute_legs = max(min(brute_legs + amount, 50),0)
			else
				fire_legs = max(min(fire_legs + amount, 50),0)
	if(update_damage)
		UpdateDamageIcon()
	return 1

//Will apply damage between zones ignoring armor
//This can also heal
/mob/living/proc/deal_overall_damage(var/brute, var/burn)
	damage_zone(brute * 0.4 , BRUTE, "chest", 0)
	damage_zone(burn * 0.4, BURN, "chest", 0)
	damage_zone(brute * 0.2, BRUTE, "head", 0)
	damage_zone(burn * 0.2, BURN, "head", 0)
	damage_zone(brute * 0.2, BRUTE, "arms", 0)
	damage_zone(burn * 0.2, BURN, "arms", 0)
	damage_zone(brute * 0.2, BRUTE, "legs", 0)
	damage_zone(burn * 0.2, BURN, "legs", 1)//The final one updates the damage icon
	return

//Should be called before a blockable attack is made
/mob/living/proc/check_shields(var/damage = 0, var/attack_text = "the attack")
	return 0

//mob/living/proc/heal_damage(var/amount)
	//Should go through all damages and zones to pick one and heal it


/mob/living/proc/scan_zone(var/zone)
	switch(zone)
		if("head")
			return ("\blue \t Head: [brute_head > 0?"\red [brute_head]":0]\blue-[fire_head > 0 ?"\red [fire_head]":0]")
		if("chest")
			return ("\blue \t Chest: [brute_chest > 0?"\red [brute_chest]":0]\blue-[fire_chest > 0?"\red [fire_chest]":0]")
		if("arms")
			return ("\blue \t Arms: [brute_arms > 0?"\red [brute_arms]":0]\blue-[fire_arms > 0?"\red [fire_arms]":0]")
		if("legs")
			return ("\blue \t Legs: [brute_legs > 0?"\red [brute_legs]":0]\blue-[fire_legs > 0?"\red [fire_legs]":0]")
	return "\blue \t Unknown: ???"








