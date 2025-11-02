class_name UIManager
extends CanvasLayer

# Информация об игре
@export var game_info: Label
@export var hp_bar: TextureProgressBar
@export var hp_percentage: Label
@export var level_timer: Timer
@export var time_text: Label
var time: int = 0
var app_version: String
var fps_update_timer: float = 0.0

func _ready():
	add_to_group("ui_manager")
	app_version = ProjectSettings.get_setting("application/config/version")

func _process(delta: float) -> void:
	fps_update_timer += delta # Таймер обновления информации
	
	# Обновление информации об игре
	if fps_update_timer >= 0.2:
		fps_update_timer = 0.0
		game_info.text = "CroSSShot!\n%s\nFPS: %d" % [app_version, Engine.get_frames_per_second()]

func  on_health_changed(health):
	hp_percentage.text = str(health) + "%"
	hp_bar.value = health

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
