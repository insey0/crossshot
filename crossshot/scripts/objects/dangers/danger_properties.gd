class_name DangerProperties
extends Area2D

@export var damage: int
@export var bounce_power: float

func _ready() -> void:
	damage = randi_range(damage-int(0.2*damage), int(damage+0.2*damage))
