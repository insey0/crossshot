class_name UIManager
extends CanvasLayer

# Game Info
@export var game_info: Label
var app_version: String
var fps_update_timer: float = 0.0
# Health
@export var hp_bar: TextureProgressBar
@export var hp_percentage: Label
# Time
@export var level_timer: Timer
@export var time_text: Label
var time: int = 0
# Effects
@export var mouse_tooltip: RichTextLabel

# Mouse tooltip update
func _input(event: InputEvent) -> void:
	# Make tooltip follow the mouse when it's not empty
	if event is InputEventMouseMotion and mouse_tooltip.text != "":
		mouse_tooltip.position = get_viewport().get_mouse_position() + Vector2(16.0, 16.0)

# Get the game version
func _ready():
	app_version = ProjectSettings.get_setting("application/config/version")

# Update level timer
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
