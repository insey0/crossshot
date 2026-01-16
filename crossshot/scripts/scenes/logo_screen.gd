extends Node2D

var developer_mode: int = 0

# Активация режима разработчика
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_E and developer_mode == 0:
				developer_mode = 1
			elif event.keycode == KEY_M and developer_mode == 1:
				developer_mode = 2
			elif event.keycode == KEY_I and developer_mode == 2:
				developer_mode = 3
			elif event.keycode == KEY_L and developer_mode == 3:
				developer_mode = 4
			elif event.keycode == KEY_Y and developer_mode == 4:
				Global.is_devmode_on = true
				get_tree().change_scene_to_file("res://crossshot/scenes/levels/menus/developer_menu.tscn")
			else:
				get_tree().change_scene_to_file("res://crossshot/scenes/levels/menus/main_menu.tscn")
	
func _on_logo_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "appear":
		get_tree().change_scene_to_file("res://crossshot/scenes/levels/menus/main_menu.tscn")
