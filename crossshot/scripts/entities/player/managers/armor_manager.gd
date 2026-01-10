# Player Armor Manager
class_name ArmorManager
extends Node

var armor_cache: Dictionary = {}
var current_armorset: String = "none"
var modules: Array = [""]

# Armor functions
func equip(id: String) -> void:
	if not id in armor_cache:
		return
	var new_slots: int = armor_cache[id]["slots"]
	current_armorset = id
	
	# Expand slots
	if new_slots > len(modules):
		for i in range(new_slots):
			modules.append("")
	# Reduce slots
	elif new_slots < len(modules):
		for i in range(len(modules)-1, new_slots-2, -1):
			drop_module(modules[i]) # Drop the module squeezed out of the slot to the ground
		modules.resize(new_slots) # Resize the module slots array
	
	# Apply buffs
	# Work in progress...
	
func drop_module(_id: String):
	pass
