extends StaticBody2D

@export var button: Area2D
@export var animation: AnimationPlayer

func _ready() -> void:
	button.connect("pressed", _on_button_pressed)

func _on_button_pressed():
	animation.play("door_open")
