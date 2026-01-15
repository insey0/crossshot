extends Interactive

signal pressed()

@export var sound: SoundManager
@export var sprite: AnimatedSprite2D

func interact():
	if sprite.animation == "default":
		sprite.play("pressed")
	else:
		sprite.play("default")

	pressed.emit()
	sound.play_sound("button_push")
