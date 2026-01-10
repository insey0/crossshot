# Weapon Manager
class_name WeaponManager
extends Node

signal equipped(id: String)
signal shot()

# Variables
# Weapon properties
var current_weapon: String = ""
var can_shoot: bool = false
var is_delayed: bool = false
var shoot_delay: float
var automatic: bool

# Bullet properties
var bullet_damage: int
var bullet_speed: float

# A dictionary with weapon properties
var weapons: Dictionary = {}

func handle_aim(weapon_node: Node2D, player_pos: Vector2, mouse_pos: Vector2) -> void:
	var direction: Vector2 = mouse_pos - player_pos
	weapon_node.rotation = atan2(direction.y, direction.x)

# Shoot function
# (todo: creating a bullet must transfer parameters to it)
func shoot(shoot_timer: Timer, bullet: PackedScene, blaze: PackedScene, muzzle: Marker2D) -> void:
	if can_shoot and not is_delayed:
		# Delay
		shoot_timer.wait_time = shoot_delay
		shoot_timer.start()
		is_delayed = true
		
		# Create a bullet
		var bullet_instance = bullet.instantiate()
		get_tree().current_scene.add_child(bullet_instance)
		
		# Rotate the bullet properly
		bullet_instance.global_rotation = muzzle.global_rotation
		bullet_instance.global_position = muzzle.global_position
		
		# Create a blaze
		var blaze_instance = blaze.instantiate()
		get_tree().current_scene.add_child(blaze_instance)
		
		# Rotate the blaze properly
		blaze_instance.global_rotation = muzzle.global_rotation
		blaze_instance.global_position = muzzle.global_position
		
		shot.emit()

# Equip and adopt equipped weapon's properties
func equip(id: String):
	can_shoot = true
	
	current_weapon = id
	automatic = weapons[id]["automatic"]
	shoot_delay = weapons[id]["shoot_delay"]
	bullet_damage = weapons[id]["bullet_damage"]
	equipped.emit(id)
