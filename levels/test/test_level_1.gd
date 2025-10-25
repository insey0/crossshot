class_name Level
extends Node2D

var current_slot_set: int
var current_slot: int

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_R:
			get_tree().reload_current_scene()
		if event.pressed and event.keycode == KEY_G:
			ItemEquipmentComponent.instance.pickup_item("test", randi_range(1, 50), randi_range(0,1))
		if event.pressed and event.keycode == KEY_H:
			ItemEquipmentComponent.instance.drop_item("test", randi_range(0,1), randi_range(0,1))
