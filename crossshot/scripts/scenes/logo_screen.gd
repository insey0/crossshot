extends Node2D

func _input(event: InputEvent) -> void:
	if event.is_pressed() and (event is InputEventKey or event is InputEventMouseButton):
		get_tree().change_scene_to_file("res://levels/menus/main_menu/main_menu.tscn")

func _on_logo_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "appear":
		get_tree().change_scene_to_file("res://levels/menus/main_menu/main_menu.tscn")
