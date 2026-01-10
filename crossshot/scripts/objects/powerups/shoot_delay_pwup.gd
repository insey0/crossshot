extends Powerup

func on_pickup(player: CharacterBody2D):
	if player.weapon.shoot_delay > 0.05:
		player.weapon.shoot_delay -= 0.05
