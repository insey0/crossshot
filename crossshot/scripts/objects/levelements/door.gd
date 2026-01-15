extends StaticBody2D

@export var is_open: bool = false
@export var button: Area2D
@export var animation: AnimationPlayer
@export var sound: SoundManager

func _ready() -> void:
	button.connect("pressed", _on_button_pressed)
	if is_open:
		animation.play("door_open")
		button.sprite.play("pressed")

func _on_button_pressed():
	if not is_open:
		animation.play("door_open", 1)
		is_open = true
	else:
		animation.play("door_close", 1)
		is_open = false
	
	sound.play_sound("mechanical_door_open")
