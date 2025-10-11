extends CharacterBody2D

@export var weapon_node: Node2D
@export var weapon_sprite: AnimatedSprite2D
@export var sprite: AnimatedSprite2D

@export var bullet: PackedScene
@export var muzzle: Marker2D
@export var shoot_delay: Timer

@export var input: InputComponent
@export var movement: MovementComponent
@export var weapon: WeaponComponent

func _physics_process(delta: float) -> void:
	# Movement
	movement.handle_gravity(self, delta)
	movement.handle_movement(self, input.direction, delta)
	
	# Aim
	weapon_node.rotation = weapon.handle_aim(global_position, input.mouse_pos)
	
	# Animation
	if input.mouse_pos.x > position.x:
		sprite.flip_h = false
		weapon_sprite.flip_v = false
	else:
		sprite.flip_h = true
		weapon_sprite.flip_v = true

# Jump (signal)
func _on_jump() -> void:
	movement.handle_jump(self)

# Shoot (signal)
func _on_shoot() -> void:
	weapon.shoot(bullet, muzzle, shoot_delay)

func _on_shoot_delay_timeout() -> void:
	if weapon.automatic and input.shoot_held:
		weapon.shoot(bullet, muzzle, shoot_delay)
