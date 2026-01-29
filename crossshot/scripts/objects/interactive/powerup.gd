# Powerup (sub)class. Adds specified effect to a target
class_name Powerup
extends Interactive

@export var texture: Texture2D
@export var effect_id: String
@export var is_active: bool
@export var is_stackable: bool
@export var max_stack: int
@export var active_time: float

func interact() -> void:
	target.effects.add(effect_id, is_active, active_time, is_stackable, max_stack, texture)
	target.sound.play_sound("powerup")
	queue_free()
