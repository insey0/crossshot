class_name MovementComponent
extends Node

@export var gravity: float = 1800.0
@export var speed: float = 1000.0
@export var acceleration: float = 10.0
@export var deceleration: float = 12.0
@export var jump_force: float = -800.0

# Gravity
func handle_gravity(player: CharacterBody2D, delta_time: float) -> void:
	if not player.is_on_floor():
		player.velocity.y += gravity * delta_time

# Horizontal Movement
func handle_movement(player: CharacterBody2D, direction: float, delta_time: float) -> void:
	var target_velocity: float = speed * direction
	
	if direction != 0:
		player.velocity.x = lerp(player.velocity.x, target_velocity, acceleration * delta_time)
	else:
		player.velocity.x = lerp(player.velocity.x, 0.0, deceleration * delta_time)
	
	player.move_and_slide()

# Jumping
func handle_jump(player: CharacterBody2D) -> void:
	if player.is_on_floor():
		player.velocity.y = jump_force
