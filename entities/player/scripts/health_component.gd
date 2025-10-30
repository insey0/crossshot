class_name HealthComponent
extends Node

var health: int = 100
var defense: int = 1

signal health_changed(new_health)

func take_damage(damage: int):
	var final_damage: int = damage
	if defense > 0:
		final_damage = int(damage / (1 + defense * 0.025))
	elif defense < 0:
		final_damage = damage * (1 + abs(defense) * 0.025)
	
	health -= final_damage
	health_changed.emit(health)

func heal(heal_value: int):
	health += heal_value
	health_changed.emit(health)
