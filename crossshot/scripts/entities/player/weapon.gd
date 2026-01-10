# Weapon behaviour script
extends Node2D

# Managers
@export var data: DataManager
@export var sound: SoundManager
@export var weapon: WeaponManager
@export var input: InputManager

@export var tex_anim: AnimationPlayer
@export var flip_anim: AnimationPlayer

# Nodes
@export var player: CharacterBody2D
@export var muzzle: Marker2D
@export var shoot_timer: Timer
@export var bullet: PackedScene
@export var blaze: PackedScene

@export var hand_sprite: Sprite2D

func _ready() -> void:
	input.connect("act_shoot", _on_act_shoot)
	weapon.connect("equipped", _on_equip)
	weapon.connect("shot", _on_shot_made)
	
	tex_anim.connect("animation_finished", _on_animation_finished)
	
	shoot_timer.connect("timeout", _on_shoot_delay_timeout)
	
	weapon.weapons = data.load_json("res://crossshot/data/weapons.json")
	weapon.equip("pistol")

func _physics_process(_delta: float) -> void:
	weapon.handle_aim(self, player.global_position, input.mouse_pos)
	if input.mouse_pos.x > global_position.x:
		flip_anim.play(&"weapon_unflipped")
	else:
		flip_anim.play(&"weapon_flipped")

# Shoot a bullet
func _on_act_shoot() -> void:
	weapon.shoot(shoot_timer, bullet, blaze, muzzle)

# Play animation & sound if shot is made
func _on_shot_made():
	tex_anim.play(weapon.current_weapon + "_shoot")
	sound.play_sound("pistol_shoot")

# Visualize equipped weapon
func _on_equip(id: String):
	tex_anim.play(id + "_idle")
	if id != "none":
		hand_sprite.visible = false
	else:
		hand_sprite.visible = true

# Reset delay on timeout
func _on_shoot_delay_timeout() -> void:
	weapon.is_delayed = false

# When animation fihishes
func _on_animation_finished(anim_name: StringName):
	if anim_name == weapon.current_weapon + "_shoot":
		tex_anim.play(weapon.current_weapon + "_idle")
