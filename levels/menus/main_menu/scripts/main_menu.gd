extends Node2D

@export var fader: AnimationPlayer
@export var game_info: Label
@export var sound: SoundManager
var next_scene_path: String
var app_version: String
var fps_update_timer: float = 0.0

func _ready():
	sound.emit_sound("amb_main_menu", &"Music")
	app_version = ProjectSettings.get_setting("application/config/version")

func _process(delta: float) -> void:
	fps_update_timer += delta # Info update timer
	
	# Game info update
	if fps_update_timer >= 0.2:
		fps_update_timer = 0.0
		game_info.text = "CroSSShot!\n%s\nFPS: %d" % [app_version, Engine.get_frames_per_second()]

func _on_btn_play_pressed() -> void:
	fader.play("fade_out")
	next_scene_path = "res://levels/level1/level_1.tscn"

func _on_btn_settings_pressed() -> void:
	fader.play("fade_out")
	next_scene_path = "res://levels/menus/settings_menu/settings_menu.tscn"

func _on_btn_exit_pressed() -> void:
	fader.play("fade_out")
	next_scene_path = "exit"

func _on_fade_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		if next_scene_path != "exit":
			get_tree().change_scene_to_file(next_scene_path)
		else:
			get_tree().quit(0)
