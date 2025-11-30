extends Powerup

func on_pickup(player: Player):
	if player.weapon.shoot_delay > 0.05:
		player.weapon.shoot_delay -= 0.05
