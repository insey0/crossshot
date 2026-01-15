# Powerup (sub)class. Adds specified effect to a target
class_name Powerup
extends Interactive

@export var effect: Effect

func interact() -> void:
	target.effects.add(effect)
	target.sound.play_sound("powerup")
	queue_free()
