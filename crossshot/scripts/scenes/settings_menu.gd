extends Node2D

@export var fader: AnimationPlayer

func _on_btn_back_pressed() -> void:
	fader.play("fade_out")

func _on_fade_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		get_tree().change_scene_to_file("res://levels/menus/main_menu/main_menu.tscn")
