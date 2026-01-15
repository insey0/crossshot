# Entity Effect Manager
class_name EffectManager
extends Node

var target: Entity

var active_effects: Array = []
var passive_effects: Array = []

func _ready() -> void:
	if get_parent() is Entity:
		target = get_parent()

func add(effect: Effect):
	if not effect.is_active:
		effect.effect_number = len(passive_effects)
		passive_effects.append([effect.effect_id, effect.effect_number])
		effect.activate(target)
	else:
		effect.effect_number = len(active_effects)
		active_effects.append([effect.effect_id, effect.effect_number])
