extends Node

@export var movement: MovementManager
@export var weapon: WeaponManager

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_BRACKETRIGHT:
				movement.max_extra_jumps += 1
			elif event.keycode == KEY_BRACKETLEFT:
				movement.max_extra_jumps -= 1
