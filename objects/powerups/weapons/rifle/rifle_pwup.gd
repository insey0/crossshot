extends Powerup

func on_pickup(player: Player):
	player.weapon.equip("rifle")
	player.weapon.automatic_shoot_delay = 0.1
