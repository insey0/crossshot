# Input Manager
class_name InputManager
extends Node

# Event signals
signal act_jump
signal act_jump_released

signal act_shoot
signal act_shoot_released

signal act_shift
signal act_shift_released

signal act_ability
signal act_interact

# Constant signals
signal move_input(direction: Vector2)

# Variables
var jump_held: bool
var shoot_held: bool
var shift_held: bool

var horizontal_direction: float
var vertical_direction: float

var mouse_pos: Vector2
var raw_input: Vector2 = Vector2.ZERO

# Config
@export var input_enabled: bool = true
@export var mouse_sensitivity: float = 1.0

func _physics_process(_delta: float) -> void:
	if input_enabled:
		get_input()

# Handle discrete actions
func _input(event: InputEvent) -> void:
	# Ignore if input is not allowed
	if not input_enabled:
		return

	# Interact
	if event.is_action_pressed("plr_interact"):
		act_interact.emit()
	# Special ability
	if event.is_action_pressed("plr_ability"):
		act_ability.emit()

	# Holdable
	# Jump
	if event.is_action_pressed("plr_jump"):
		act_jump.emit()
		jump_held = true
	elif event.is_action_released("plr_jump"):
		act_jump_released.emit()
		jump_held = false

	# Shoot
	if event.is_action_pressed("plr_shoot"):
		act_shoot.emit()
		shoot_held = true
	elif event.is_action_released("plr_shoot"):
		act_shoot_released.emit()
		shoot_held = false

	# Shift
	if event.is_action_pressed("plr_shift"):
		act_shift.emit()
		shift_held = true
	elif event.is_action_released("plr_shift"):
		act_shift_released.emit()
		shift_held = false

# Input that needs to be handled each frame
func get_input() -> void:
	# Get raw input
	raw_input = Input.get_vector("plr_left", "plr_right", "plr_up", "plr_down")
	move_input.emit(Vector2(horizontal_direction, vertical_direction))
	
	# Get input by direction
	horizontal_direction = raw_input.x
	vertical_direction = raw_input.y
	
	# Get camera-relative mouse position
	var camera = get_viewport().get_camera_2d()
	if camera:
		mouse_pos = camera.get_global_mouse_position()
	else:
		# Fallback if no camera is found
		mouse_pos = get_viewport().get_mouse_position()
		push_error("InputManager: Camera is NULL, using viewport mouse position as a fallback")

# Enable/disable input with variables reset
func set_input_enabled(enabled: bool) -> void:
	input_enabled = enabled
	if not enabled:
		_reset_variables()

# Reset all variables so player doesn't keep shooting or holding jump
func _reset_variables():
	raw_input = Vector2.ZERO
	shoot_held = false
	jump_held = false

# Get raw input information
func get_input_info() -> Dictionary:
	return {
		"input_enabled": input_enabled,
		"direction": {"x": raw_input.x, "y": raw_input.y},
		"mouse_pos": {"x": mouse_pos.x, "y": mouse_pos.y},
		"shoot_held": shoot_held,
		"jump_held": jump_held
	}
