# Health Component
class_name HealthComponent
extends Node

@export var max_health: int
@export var health: int = 100
@export var defense: int = 1

signal health_changed(new_health: int, new_max_health: int, damage_value: int, is_damaged: bool)

func take_damage(damage: int):
	var final_damage: int = damage
	if defense > 0:
		final_damage = int(damage / (1 + defense * 0.025))
	elif defense < 0:
		final_damage = damage * (1 + abs(defense) * 0.025)
	
	if final_damage > health:
		final_damage = health
	
	health -= final_damage
	# Sending a signal to a global group "ui_manager"
	get_tree().call_group("ui_manager", "on_health_changed", health, max_health)
	# Sending the same signal locally
	health_changed.emit(health, max_health, -final_damage, true)

func heal(heal_value: int):
	health += heal_value
	# Sending a signal to a global group "ui_manager"
	get_tree().call_group("ui_manager", "on_health_changed", health)
	# Sending the same signal locally
	health_changed.emit(health, max_health, heal_value, false)
