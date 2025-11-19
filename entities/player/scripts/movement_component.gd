# Movement Component
class_name MovementComponent
extends Node

# Variables
# Gravity
@export var gravity: float
# Speed
@export var speed: float
@export var acceleration: float
@export var deceleration: float
# Jump
@export var jump_force: float
@export var can_jump: bool = true
# Double jump
var max_extra_jumps: int
var extra_jumps_left: int

# Handle gravity
func handle_gravity(player: CharacterBody2D, delta_time: float) -> void:
	if not player.is_on_floor():
		player.velocity.y += gravity * delta_time

# Handle horizontal Movement
func handle_movement(player: CharacterBody2D, horizontal_direction: float, delta_time: float) -> void:
	var target_velocity: float = speed * horizontal_direction
	
	if horizontal_direction != 0:
		player.velocity.x = lerp(player.velocity.x, target_velocity, acceleration * delta_time)
	else:
		player.velocity.x = lerp(player.velocity.x, 0.0, deceleration * delta_time)
	
	player.move_and_slide()

# Jumping
func handle_jump(player: Player) -> bool:
	if can_jump:
		if player.is_on_floor():
			player.velocity.y = jump_force
			return true
		elif extra_jumps_left > 0:
			player.velocity.y = jump_force
			extra_jumps_left -= 1
			return true
	return false

func renew_jumps(player: Player):
	if player.is_on_floor():
		extra_jumps_left = max_extra_jumps

func handle_bounce(player: CharacterBody2D, direction: Vector2, bounce_power: float) -> void:
	player.velocity = Vector2(direction.x * bounce_power, direction.y * bounce_power)
