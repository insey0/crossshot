class_name UIManager
extends CanvasLayer

# Информация об игре
@export var game_info: Label
@export var hp_bar: TextureProgressBar
@export var hp_percentage: Label
@export var level_timer: Timer
@export var time_text: Label
@export var effects_container: HBoxContainer
@export var mouse_tooltip: RichTextLabel
var time: int = 0
var app_version: String
var fps_update_timer: float = 0.0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and mouse_tooltip.text != "":
		mouse_tooltip.position = get_viewport().get_mouse_position() + Vector2(16.0, 16.0)

func _ready():
	add_to_group("ui_manager")
	app_version = ProjectSettings.get_setting("application/config/version")

func _process(delta: float) -> void:
	fps_update_timer += delta # Таймер обновления информации
	
	# Обновление информации об игре
	if fps_update_timer >= 0.2:
		fps_update_timer = 0.0
		game_info.text = "CroSSShot!\n%s\nFPS: %d" % [app_version, Engine.get_frames_per_second()]

func on_health_changed(health: int, max_health: int):
	hp_percentage.text = str(health) + "%"
	hp_bar.value = health
	hp_bar.max_value = max_health

func _on_level_timer_timeout() -> void:
	time += 1
	var divisor: String
	@warning_ignore("integer_division")
	if time - int(time / 60) * 60 < 10:
		divisor = ":0"
	else:
		divisor = ":"
	@warning_ignore("integer_division")
	time_text.text = "Time " + str(int(time / 60)) + divisor + str(time - int(time / 60) * 60)
	level_timer.start()

func _on_new_effect(effect_texture: Texture2D, effect_name: String, effect_description: String):
	if effect_texture:
		var new_effect := Effect.new()
		effects_container.add_child(new_effect)
		new_effect.custom_minimum_size = Vector2(48.0, 48.0)
	
		new_effect.effect_texture = effect_texture
		new_effect.description = effect_description
		new_effect.display_name = effect_name.capitalize()
		new_effect.tooltip = mouse_tooltip
