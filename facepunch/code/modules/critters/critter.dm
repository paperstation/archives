//Critter attack bitflags
#define ATKHUMAN		1
#define ATKMONKEY		2
#define ATKALIEN		4
#define ATKCARBON		7
#define ATKSILICON		8
#define ATKSIMPLE		16
#define ATKCRITTER		32
#define ATKMOBS			63
#define ATKSAME			64
#define ATKMECH			128
#define AVOIDSYNDI		256


/obj/effect/critter
	name = "Critter"
	desc = "Generic critter."
	icon = 'icons/mob/critter.dmi'
	icon_state = "basic"
	layer = 5.0
	density = 1
	anchored = 0
	var/alive = 1
	health = 10
	max_health = 10
	damage_resistance = 0
	var/list/access_list = list()//accesses go here
//AI things
	var/task = "thinking"
	//Attacks at will
	var/aggressive = 1
	//Will target an attacker
	var/defensive = 0
	//Will randomly move about
	var/wanderer = 1
	//Will open doors it bumps ignoring access
	var/opensdoors = 0

	//Internal tracking ignore
	var/frustration = 0
	var/max_frustration = 8
	//var/attack = 0
	var/attacking = 0
	var/steps = 0
	var/last_found = null
	var/target = null
	var/oldtarget_name = null
	var/target_lastloc = null

	var/thinkspeed  = 15
	var/chasespeed  = 4
	var/wanderspeed = 10
		//The last guy who attacked it
	var/attacker = null
		//Will not attack this thing
	//var/friend = null
		//How far to look for things, dont set this overly high
	var/seekrange = 7

	//Valid target bitflags
	var/can_target = ATKCARBON | ATKSILICON | ATKSIMPLE
	var/team = "critter"//If this mob has team defined and lacks ATKSAME it will not target members with a matching team

	//Damage multipliers
	var/brutevuln = 1
	var/firevuln = 1
		//DR

		//How much damage it does it melee
	var/melee_damage_lower = 1
	var/melee_damage_upper = 2
		//Basic attack message when they move to attack and attack
	var/angertext = "charges at"
	var/attacktext = "attacks"
	var/deathtext = "dies!"

	var/chasestate = null // the icon state to use when attacking or chasing a target
	//var/attackflick = null // the icon state to flick when it attacks
	var/attack_sound = null // the sound it makes when it attacks!

	var/attack_speed = 25 // delay of attack


	proc/AfterAttack(var/mob/living/target)
		return



/* TODO:Go over these and see how/if to add them

	proc/set_attack()
		state = 1
		if(path_idle.len) path_idle = new/list()
		trg_idle = null

	proc/set_idle()
		state = 2
		if (path_target.len) path_target = new/list()
		target = null
		frustration = 0

	proc/set_null()
		state = 0
		if (path_target.len) path_target = new/list()
		if (path_idle.len) path_idle = new/list()
		target = null
		trg_idle = null
		frustration = 0

	proc/path_idle(var/atom/trg)
		path_idle = AStar(src.loc, get_turf(trg), /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 250, anicard, null)
		path_idle = reverselist(path_idle)

	proc/path_attack(var/atom/trg)
		path_target = AStar(src.loc, trg.loc, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 250, anicard, null)
		path_target = reverselist(path_target)


//Look these over
	var/list/path = new/list()
	var/patience = 35						//The maximum time it'll chase a target.
	var/list/mob/living/carbon/flee_from = new/list()
	var/list/path_target = new/list()		//The path to the combat target.

	var/turf/trg_idle					//It's idle target, the one it's following but not attacking.
	var/list/path_idle = new/list()		//The path to the idle target.



*/
