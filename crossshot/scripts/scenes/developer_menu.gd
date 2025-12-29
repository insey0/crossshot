extends Node2D

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://crossshot/scenes/ui/screens/main_menu.tscn")

func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://crossshot/scenes/levels/level_1.tscn")

func _on_boss_2_test_pressed() -> void:
	get_tree().change_scene_to_file("res://crossshot/scenes/test_scenes/boss_2_test/boss_2_test.tscn")
