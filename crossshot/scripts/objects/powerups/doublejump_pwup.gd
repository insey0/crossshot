extends Powerup

func on_pickup(player: CharacterBody2D):
	player.movement.max_extra_jumps = 1
