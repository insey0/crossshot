extends Powerup

func on_pickup(player: Player):
	player.weapon.equip("pistol")
