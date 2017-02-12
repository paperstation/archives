/obj/cable/blue/shield
	icon = 'shield_cable.dmi'

	name = "Shielding Cable"
	layer = 2.4

	ConnectableTypes = list( /obj/machinery/shielding )
	NetworkControllerType = /datum/UnifiedNetworkController/ShieldingNetworkController
	DropCablePieceType = /obj/item/weapon/cable_coil/blue/shield
	EquivalentCableType = /obj/cable/blue/shield

/obj/item/weapon/cable_coil/blue/shield
	icon_state = "bluecoil3"
	CoilColour = "blue"
	BaseName  = "Shielding"
	ShortDesc = "A piece of specialized low-capacitance shielding cable"
	LongDesc  = "A long piece of specialized low-capacitance shielding cable"
	CoilDesc  = "A Spool of specialized low-capacitance shielding cable"
	CableType = /obj/cable/blue/shield


