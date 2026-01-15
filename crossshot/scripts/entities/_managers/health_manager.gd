# Health Component
class_name HealthManager
extends Node

# Event signals
signal health_changed(new_health: int, new_max_health: int, damage_value: int, is_damaged: bool)
signal died()
signal invincibility_started(duration: float)
signal invincibility_ended()

# Variables
var invincibility_timer: Timer
var is_invincible: bool = false

# Config
@export var max_health: int
@export var health: int = max_health
@export var defense: int = 1
@export var invincibility_duration: float = 0.5

# Initialize invincibility timer
func _ready() -> void:
	invincibility_timer = Timer.new()
	invincibility_timer.one_shot = true
	invincibility_timer.timeout.connect(_on_invincibility_ended)
	add_child(invincibility_timer)

# Change maximum health value
func change_max_health(new_max_health: int) -> void:
	max_health = new_max_health
	health = max_health
	health_changed.emit(health, max_health, 0, false)

# Take damage function
func take_damage(damage: int) -> bool:
	# Don't take damage if invincible or dead
	if is_invincible or health <= 0:
		return false

	var final_damage: int = _calculate_final_damage(damage)
	
	if final_damage >= health:
		final_damage = health
	
	health -= final_damage
	
	# Sending a signal to a global group "ui_manager"
	get_tree().call_group("ui_manager", "on_health_changed", health, max_health)
	# Sending the same signal locally
	health_changed.emit(health, max_health, -final_damage, true)
	
	# Check if player died after taking damage
	if health <= 0:
		died.emit()
	
	# Start invincibility frames
	if invincibility_duration > 0 and health > 0:
		start_invincibility(invincibility_duration)
	
	return true

# Damage calculation
func _calculate_final_damage(initial_damage: int) -> int:
	var calculated_damage: int
	if defense > 0:
		calculated_damage = int(initial_damage / (1 + defense * 0.025))
	elif defense < 0:
		calculated_damage = int(initial_damage * (1 + abs(defense) * 0.025))
	else:
		calculated_damage = initial_damage

	return calculated_damage

# Heal function
func heal(heal_value: int):
	health = min(health + heal_value, max_health)
	# Sending a signal to a global group "ui_manager"
	get_tree().call_group("ui_manager", "_on_health_updated", health, max_health)
	# Sending the same signal locally
	health_changed.emit(health, max_health, heal_value, false)

# Invincibility frames
func start_invincibility(duration_seconds: float):
	if duration_seconds <= 0:
		return
	is_invincible = true
	invincibility_started.emit(duration_seconds)
	invincibility_timer.start(duration_seconds)

func _on_invincibility_ended():
	is_invincible = false
	invincibility_ended.emit()

# Helpful stuff
func get_health_percentage() -> float:
	return (float(health) / float(max_health)) * 100

func is_alive() -> bool:
	return health > 0

func reset() -> void:
	health = max_health
	is_invincible = false
	invincibility_timer.stop()
	health_changed.emit(health, max_health, 0, false)
