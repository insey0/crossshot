# Extra Jump Effect
# Adds one extra jump until there's five
extends Effect

var extra_jumps_limit: int = 5

func activate(target: Entity):
	if target is Player and target.movement.max_extra_jumps < extra_jumps_limit:
		target.movement.max_extra_jumps += 1

func deactivate(target: Entity):
	if target is Player:
		target.movement.max_extra_jumps -= 1
	
