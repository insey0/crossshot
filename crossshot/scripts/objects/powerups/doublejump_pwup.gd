extends Powerup

func on_pickup(player: Player):
	player.movement.max_extra_jumps = 1
