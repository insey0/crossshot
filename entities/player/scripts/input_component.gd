class_name InputComponent
extends Node

signal jump
signal shoot
var shoot_held: bool
var direction: float
var mouse_pos: Vector2

func _physics_process(_delta: float) -> void:
	get_input()

func get_input():
	# Get horizontal direction
	direction = Input.get_axis("plr_left", "plr_right")
	
	# Mouse position
	var camera = get_viewport().get_camera_2d()
	if camera:
		mouse_pos = camera.get_global_mouse_position()
	else:
		mouse_pos = get_viewport().get_mouse_position()
		push_error("InputComponent: Camera is NULL, using viewport mouse position as a fallback")
	
	# Jump
	if Input.is_action_just_pressed("plr_jump"):
		jump.emit()
	# Shoot
	if Input.is_action_just_pressed("plr_shoot"):
		shoot.emit()
		shoot_held = true
	if Input.is_action_just_released("plr_shoot"):
		shoot_held = false
