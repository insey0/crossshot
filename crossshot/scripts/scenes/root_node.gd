class_name Level
extends Node2D

@export var data: DataManager
@export var music: SoundManager

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_R:
				get_tree().reload_current_scene()
