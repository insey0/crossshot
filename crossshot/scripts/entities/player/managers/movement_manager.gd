# Movement Manager
class_name MovementManager
extends Node

signal jumped()

# Variables
var max_extra_jumps: int = 0
var extra_jumps_left: int = 0
var is_climbing: bool = false
var current_ladder: Node2D = null

# Config
@export var gravity: float = 1800.0
@export var speed: float = 800.0
@export var acceleration: float = 8.0
@export var deceleration: float = 10.0
@export var jump_force: float = -800.0
@export var climb_speed: float = 400.0

@export var horizontal_moving_enabled: bool = true
@export var climbing_enabled: bool = true
@export var jump_enabled: bool = true
@export var gravity_enabled: bool = true

# Handle gravity
func apply_gravity(player_body: Entity, delta_time: float) -> void:
	if not player_body.is_on_floor() and gravity_enabled:
		player_body.velocity.y += gravity * delta_time

# Make idle
func stop(player_body: Entity):
	player_body.velocity.x = 0.0

# Handle horizontal Movement
func handle_movement(player_body: Entity, horizontal_direction: float, delta_time: float) -> void:
	if not horizontal_moving_enabled or is_climbing:
		return
	
	var target_velocity: float = speed * horizontal_direction
	
	if horizontal_direction != 0:
		player_body.velocity.x = lerp(player_body.velocity.x, target_velocity, acceleration * delta_time)
	else:
		player_body.velocity.x = lerp(player_body.velocity.x, 0.0, deceleration * delta_time)
	
	player_body.move_and_slide()

# Ladder climbing
# When player presses 'up' or 'down' near the ladder
func start_climbing(player_body: Entity, ladder: Node2D):
	if not climbing_enabled or is_climbing:
		return
	
	current_ladder = ladder
	gravity_enabled = false
	jump_enabled = false
	is_climbing = true
	
	player_body.velocity.y = 0
	# Snap to the ladder horizontally
	player_body.global_position.x = ladder.global_position.x

# When player reaches the end of the ladder normally
func finish_climbing():
	if not is_climbing:
		return
	
	gravity_enabled = true
	jump_enabled = true
	is_climbing = false
	
	current_ladder = null

# When player jumps mid-ladder
func jump_off(player_body: Entity):
	if not is_climbing:
		return
	finish_climbing()
	player_body.velocity.y = jump_force * 0.8

# Process climbing logic
func climb(player_body: Entity, vertical_direction: float, delta_time: float) -> void:
	if not is_climbing or not current_ladder:
		return
	
	# Applying vertical velocity without gravity
	player_body.velocity.y = vertical_direction * climb_speed * delta_time
	
	# X axis limitation
	if current_ladder:
		var target_x = current_ladder.global_position.x
		player_body.global_position.x = lerp(player_body.global_position.x, target_x, 10.0 * delta_time)
	
	# Finish climbing when the player reaches the bottom of the ladder
	if player_body.is_on_floor() and vertical_direction <= 0:
		finish_climbing()
	
# Jumping
func jump(player_body: Entity) -> bool:
	if jump_enabled:
		if player_body.is_on_floor():
			player_body.velocity.y = jump_force
			jumped.emit()
			return true
		elif extra_jumps_left > 0:
			player_body.velocity.y = jump_force
			extra_jumps_left -= 1
			jumped.emit()
			return true
	return false

func renew_jumps(player_body: Entity):
	if player_body.is_on_floor():
		extra_jumps_left = max_extra_jumps

func handle_bounce(player_body: Entity, direction: Vector2, bounce_power: float) -> void:
	player_body.velocity = Vector2(direction.x * bounce_power, direction.y * bounce_power)
