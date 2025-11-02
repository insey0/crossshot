extends Powerup

func on_pickup(player: Player):
	if player.shoot_delay.wait_time > 0.05:
		player.shoot_delay.wait_time -= 0.05
