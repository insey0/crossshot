extends Area2D

signal pressed()

@export var sprite: AnimatedSprite2D
var pressable: bool = false
var activated: bool = false

func _input(event: InputEvent) -> void:
	if pressable and not activated and event.is_action_pressed("plr_interact"):
		sprite.play("pressed")
		activated = true
		pressed.emit()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		pressable = true

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		pressable = false
