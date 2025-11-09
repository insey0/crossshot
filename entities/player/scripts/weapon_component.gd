class_name WeaponComponent
extends Node

@export var weapon_id: String = "none":
	set(value):
		equip(value)
		sprite.animation = value
		weapon_id = value

@export var shoot_timer: Timer
@export var bullet: PackedScene
@export var muzzle: Marker2D
@export var sprite: AnimatedSprite2D

var automatic_shoot_delay: float
var automatic: bool
var can_single_shoot: bool = true
var damage: int

func handle_aim(player_pos: Vector2, mouse_pos: Vector2) -> float:
	var direction: Vector2 = mouse_pos - player_pos
	var rotation_angle = atan2(direction.y, direction.x)
	return rotation_angle

func shoot():
	if weapon_id != "none":
		var bullet_instance = bullet.instantiate()
		get_tree().current_scene.add_child(bullet_instance)
		bullet_instance.global_rotation = muzzle.global_rotation
		bullet_instance.global_position = muzzle.global_position

	shoot_timer.start()

func equip(id: String):
	match id:
		"pistol":
			automatic = false
			shoot_timer.wait_time = 0.5
			damage = 5
		"rifle":
			automatic = true
			shoot_timer.wait_time = automatic_shoot_delay
			damage = 3
