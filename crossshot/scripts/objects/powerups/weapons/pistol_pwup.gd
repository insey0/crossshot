extends Powerup

func on_pickup(player: CharacterBody2D):
	player.weapon.equip("pistol")
