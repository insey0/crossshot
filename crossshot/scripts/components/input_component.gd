# Input Component
class_name InputComponent
extends Node

# Event signals
signal act_jump
signal act_shoot
signal act_interact

# Variables
var shoot_held: bool
var horizontal_direction: float
var mouse_pos: Vector2

func _physics_process(_delta: float) -> void:
	get_input()

# Input that needs to be handled only if an event happens
func _input(event: InputEvent) -> void:
	# Handle singular actions
	if event.is_action_pressed("plr_jump"):
		act_jump.emit()
	elif event.is_action_pressed("plr_interact"):
		act_interact.emit()
	elif event.is_action_pressed("plr_shoot"):
		act_shoot.emit()

# Input that needs to be handled each frame
func get_input() -> void:
	# Get horizontal direction
	horizontal_direction = Input.get_axis("plr_left", "plr_right")
	
# Mouse position
	var camera = get_viewport().get_camera_2d()
	if camera:
		mouse_pos = camera.get_global_mouse_position()
	else:
		mouse_pos = get_viewport().get_mouse_position()
		push_error("InputComponent: Camera is NULL, using viewport mouse position as a fallback")
	
	# Shoot Held
	if Input.is_action_pressed("plr_shoot"):
		shoot_held = true
	else:
		shoot_held = false
