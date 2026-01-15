# Double Jump Effect
# Does not add more jumps, instead setting them to a constant value (plus one)
extends Effect

func activate(target: Entity):
	if target is Player:
		target.movement.max_extra_jumps = 1

func deactivate(target: Entity):
	if target is Player:
		target.movement.max_extra_jumps = 0
	
