class_name WeaponComponent
extends Node

@export var shoot_timer: Timer
@export var bullet: PackedScene
@export var muzzle: Marker2D
@export var sprite: AnimatedSprite2D

var can_shoot: bool = false
var automatic_shoot_delay: float = 0.2
var automatic: bool

var bullet_damage: int
var bullet_speed: float

func handle_aim(player_pos: Vector2, mouse_pos: Vector2) -> float:
	var direction: Vector2 = mouse_pos - player_pos
	var rotation_angle = atan2(direction.y, direction.x)
	return rotation_angle

func shoot():
	if can_shoot:
		var bullet_instance = bullet.instantiate()
		get_tree().current_scene.add_child(bullet_instance)
		bullet_instance.global_rotation = muzzle.global_rotation
		bullet_instance.global_position = muzzle.global_position

	shoot_timer.start()

func equip(id: String):
	can_shoot = true
	sprite.animation = id
	match id:
		"none":
			can_shoot = false
		"pistol":
			automatic = false
			shoot_timer.wait_time = 0.5
			bullet_damage = 5
		"rifle":
			automatic = true
			shoot_timer.wait_time = automatic_shoot_delay
			bullet_damage = 3
