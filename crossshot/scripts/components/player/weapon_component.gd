# Weapon Component
class_name WeaponComponent
extends Node

# Variables
# Nodes
@export var shoot_timer: Timer
@export var bullet: PackedScene
@export var weapon_node: Node2D
@export var muzzle: Marker2D
@export var sprite: AnimatedSprite2D
@export var sound: SoundManager

# Weapon properties
var can_shoot: bool = false
var is_delayed: bool = false
var shoot_delay: float
var automatic: bool

# Bullet properties
var bullet_damage: int
var bullet_speed: float

# Fixed dictionary with weapon data
var weapons: Dictionary = {}

func _ready() -> void:
	weapons = _load_data("res://crossshot/data/weapons.json")

func handle_aim(player_pos: Vector2, mouse_pos: Vector2) -> void:
	var direction: Vector2 = mouse_pos - player_pos
	weapon_node.rotation = atan2(direction.y, direction.x)

# Shoot function
# (todo: creating bullet must transfer parameters to them)
func shoot() -> void:
	if can_shoot and not is_delayed:
		shoot_timer.wait_time = shoot_delay
		shoot_timer.start()
		is_delayed = true
		
		var bullet_instance = bullet.instantiate()
		get_tree().current_scene.add_child(bullet_instance)
		
		bullet_instance.global_rotation = muzzle.global_rotation
		bullet_instance.global_position = muzzle.global_position
		sound.play_sound("weap_rifle_shoot")

func equip(id: String):
	can_shoot = true
	sprite.animation = id
	
	automatic = weapons[id]["automatic"]
	shoot_delay = weapons[id]["shoot_delay"]
	bullet_damage = weapons[id]["bullet_damage"]

func _load_data(path: String) -> Dictionary:
	var datafile = FileAccess.open(path, FileAccess.READ)
	if datafile == null:
		push_error("WeaponManager: weapons.json is missing")
		return {}
	var datatext = datafile.get_as_text()
	datafile.close()
	
	var data := JSON.new()
	var parsed_data = data.parse(datatext)
	if parsed_data != OK:
		push_error("WeaponManager: JSON parsing error: " + data.get_error_message())
		return {}
	
	return data.data

func _on_shoot_delay_timeout() -> void:
	is_delayed = false
