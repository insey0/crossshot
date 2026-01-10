# Entity Effect Manager
class_name EffectManager
extends Node

var target: Node2D
var current_effects: Dictionary = {}

func _ready() -> void:
	target = get_parent()

func add(effect: Effect):
	current_effects[effect.name] = effect
	if not effect.is_active:
		effect.apply()

func activate(id: String):
	if id in current_effects:
		current_effects[id].apply()

func remove(id: String):
	if id in current_effects:
		current_effects.erase(id)
