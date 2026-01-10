# Effect base class
class_name Effect
extends Node

var effect_manager: EffectManager
var is_active: bool

func _ready() -> void:
	effect_manager = get_parent()

func apply() -> void:
	pass

func remove() -> void:
	pass
