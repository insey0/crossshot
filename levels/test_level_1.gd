class_name Level
extends Node2D

var current_slot_set: int
var current_slot: int

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_R:
			get_tree().reload_current_scene()
