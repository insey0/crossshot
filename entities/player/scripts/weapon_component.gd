class_name WeaponComponent
extends Node

@export var weapon_id: String = "none"
@export var automatic: bool

func handle_aim(player_pos: Vector2, mouse_pos: Vector2) -> float:
	var direction: Vector2 = mouse_pos - player_pos
	var rotation_angle = atan2(direction.y, direction.x)
	return rotation_angle

func shoot(bullet: PackedScene, muzzle: Marker2D, delay: Timer):
	var bullet_instance = bullet.instantiate()
	get_tree().current_scene.add_child(bullet_instance)
	bullet_instance.global_rotation = muzzle.global_rotation
	bullet_instance.global_position = muzzle.global_position
	
	delay.start()
