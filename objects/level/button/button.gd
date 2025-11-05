extends Interactable

signal pressed()

@export var sprite: AnimatedSprite2D

func on_interact():
	sprite.play("pressed")
	pressed.emit()
