class_name Player
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
@export var health: HealthComponent

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
	
	# Double Jump
	if is_on_floor():
		movement.jump_count = 2

# Прыжок (signal)
func _on_jump() -> void:
	movement.handle_jump(self)
# Выстрел (signal)
func _on_shoot() -> void:
	weapon.shoot(bullet, muzzle, shoot_delay)
func _on_shoot_delay_timeout() -> void:
	if weapon.automatic and input.shoot_held:
		weapon.shoot(bullet, muzzle, shoot_delay)

# Изменение здоровья
func _on_health_changed(new_health: int, is_damaged: bool) -> void:
	if new_health > 0 and is_damaged:
		print("Damaged to ", new_health)
	if not is_damaged:
		print("Healed to ", new_health)
	if new_health == 0:
		print("Died")

# Проверка столкновений (враги, опасности, интерактивные объедки...)
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("dangers"):
		var danger: DangerProperties = area
		movement.handle_bounce(self, (global_position - danger.global_position).normalized(), danger.bounce_power)
		health.take_damage(danger.damage)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("powerups"):
		var pwup: Powerup = body
		pwup.on_pickup(self)
		pwup.queue_free()
