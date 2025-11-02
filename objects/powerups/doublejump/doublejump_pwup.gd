extends Powerup

func on_pickup(player: Player):
	player.movement.can_double_jump = true
