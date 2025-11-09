extends Powerup

func on_pickup(player: Player):
	if player.weapon.automatic_shoot_delay > 0.05:
		player.weapon.automatic_shoot_delay -= 0.05
